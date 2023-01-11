;;; hydra-posframe-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "hydra-posframe" "hydra-posframe.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from hydra-posframe.el

(defvar hydra-posframe-mode nil "\
Non-nil if Hydra-Posframe mode is enabled.
See the `hydra-posframe-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `hydra-posframe-mode'.")

(custom-autoload 'hydra-posframe-mode "hydra-posframe" nil)

(autoload 'hydra-posframe-mode "hydra-posframe" "\
Display hydra via posframe.

This is a minor mode.  If called interactively, toggle the
`Hydra-Posframe mode' mode.  If the prefix argument is positive,
enable the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `(default-value \\='hydra-posframe-mode)'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(autoload 'hydra-posframe-enable "hydra-posframe" "\
Enable hydra-posframe." t nil)

(register-definition-prefixes "hydra-posframe" '("hydra-posframe-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; hydra-posframe-autoloads.el ends here
