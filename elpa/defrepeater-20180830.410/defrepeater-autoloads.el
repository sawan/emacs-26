;;; defrepeater-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "defrepeater" "defrepeater.el" (0 0 0 0))
;;; Generated autoloads from defrepeater.el

(autoload 'defrepeater "defrepeater" "\
Define NAME-OR-COMMAND as an interactive command which calls COMMAND repeatedly.
COMMAND is called every time the last key of the sequence bound
to NAME is pressed, until another key is pressed. If COMMAND is
given, the repeating command is named NAME-OR-COMMAND and calls
COMMAND; otherwise it is named `NAME-OR-COMMAND-repeat' and calls
NAME-OR-COMMAND.

The newly defined function's symbol is returned, so
e.g. `defrepeater' may be used in a key-binding expression.

\(fn NAME-OR-COMMAND &optional COMMAND)" nil t)

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; defrepeater-autoloads.el ends here
