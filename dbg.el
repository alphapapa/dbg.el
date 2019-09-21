;;; dbg.el --- Simple debugging macros               -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Adam Porter

;; Author: Adam Porter <adam@alphapapa.net>
;; Keywords: lisp

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This package provides two macros to help with debugging: `dbg-msg'
;; and `dbg-form'.  By default, they do nothing: `dbg-msg' expands to
;; nil, and `dbg-form' expands to its FORM argument, as if only FORM
;; were present in the code.  When debugging is enabled, `dbg-msg'
;; expands into a `message' call, and `dbg-form' logs FORM and FORM's
;; value with `message', then returns the value.

;; Whether debugging is enabled is controlled with the variable
;; defined in `dbg-p-var', which is `dbg-p' by default.  `dbg-p-var'
;; is buffer-local, so it can be overridden to control debugging at
;; the file, buffer, or package level.

;; To set debugging for a certain package or file, set `dbg-p-var' to
;; a defined variable of your choice, and set the value of that
;; variable to a non-nil value.  This should be done within
;; `eval-and-compile' so it works for byte-compiled files.

;;; Code:

;;;; Variables

(defvar-local dbg-p-var 'dbg-p
  "The symbol whose value determines whether to enable debugging.")

(defvar dbg-p nil
  "Whether `dbg' macros should log messages.
This variable is used by default, but others may be used in
certain buffers according to the value of `dbg-p-var', which
see.")

;;;; Macros

(cl-defmacro dbg-msg (string &rest objects)
  "If debugging is enabled, expand to a call to `message', which see.
Debugging is enabled when the value of the symbol stored in
`dbg-p-var' is non-nil."
  (when (symbol-value dbg-p-var)
    `(message ,string ,@objects)))

(cl-defmacro dbg-form (form)
  "Expand to `form'; when debugging is enabled, also log FORM and its value with `message'.
Debugging is enabled when the value of the symbol stored in
`dbg-p-var' is non-nil."
  (if (symbol-value dbg-p-var)
      (let ((value (gensym)))
        `(let ((,value ,form))
           (message "dbg-form: %S: %S" ',form ,value)
           ,value))
    form))

;;;; Footer

(provide 'dbg)

;;; dbg.el ends here
