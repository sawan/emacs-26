;;; aweshell-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "aweshell" "aweshell.el" (0 0 0 0))
;;; Generated autoloads from aweshell.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "aweshell" '("aweshell-" "eshell")))

;;;***

;;;### (autoloads nil "eshell-did-you-mean" "eshell-did-you-mean.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from eshell-did-you-mean.el

(autoload 'eshell-did-you-mean-setup "eshell-did-you-mean" "\
`eshell-did-you' setup." nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "eshell-did-you-mean" '("eshell-did-you-mean-")))

;;;***

;;;### (autoloads nil "eshell-prompt-extras" "eshell-prompt-extras.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from eshell-prompt-extras.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "eshell-prompt-extras" '("epe-")))

;;;***

;;;### (autoloads nil "eshell-up" "eshell-up.el" (0 0 0 0))
;;; Generated autoloads from eshell-up.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "eshell-up" '("eshell-up")))

;;;***

;;;### (autoloads nil "exec-path-from-shell" "exec-path-from-shell.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from exec-path-from-shell.el

(autoload 'exec-path-from-shell-copy-envs "exec-path-from-shell" "\
Set the environment variables with NAMES from the user's shell.

As a special case, if the variable is $PATH, then `exec-path' and
`eshell-path-env' are also set appropriately.  The result is an alist,
as described by `exec-path-from-shell-getenvs'.

\(fn NAMES)" nil nil)

(autoload 'exec-path-from-shell-copy-env "exec-path-from-shell" "\
Set the environment variable $NAME from the user's shell.

As a special case, if the variable is $PATH, then `exec-path' and
`eshell-path-env' are also set appropriately.  Return the value
of the environment variable.

\(fn NAME)" t nil)

(autoload 'exec-path-from-shell-initialize "exec-path-from-shell" "\
Initialize environment from the user's shell.

The values of all the environment variables named in
`exec-path-from-shell-variables' are set from the corresponding
values used in the user's shell." t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "exec-path-from-shell" '("exec-path-from-shell-")))

;;;***

;;;### (autoloads nil nil ("aweshell-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; aweshell-autoloads.el ends here
