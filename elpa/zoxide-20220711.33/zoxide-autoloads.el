;;; zoxide-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "zoxide" "zoxide.el" (0 0 0 0))
;;; Generated autoloads from zoxide.el

(autoload 'zoxide-run "zoxide" "\
Run zoxide command with args.
The first argument ASYNC specifies whether calling asynchronously or not.
The second argument ARGS is passed to zoxide directly, like query -l

\(fn ASYNC &rest ARGS)" nil nil)

(autoload 'zoxide-add "zoxide" "\
Add PATH to zoxide database.  This function is called asynchronously.

\(fn &optional PATH &rest _)" t nil)

(autoload 'zoxide-remove "zoxide" "\
Remove PATH from zoxide database.

\(fn &optional PATH)" t nil)

(autoload 'zoxide-query-with "zoxide" "\
Search zoxide database with QUERY by calling zoxide query.
When calling interactively, it will open a buffer to show results.  Otherwise,
a list of paths is returned.

\(fn QUERY)" t nil)

(autoload 'zoxide-query "zoxide" "\
Similar to `zoxide-query-with', but list all paths instead of matching." t nil)

(autoload 'zoxide-open-with "zoxide" "\
Search QUERY and run CALLBACK function with a selected path.

If NONINTERACTIVE is non-nil, the callback is always called
directly with the selected path as its first argument.

This is a help function to define interactive commands like
`zoxide-find-file'.  If you want to do things noninteractive, please use
`zoxide-query', filter results and pass it to your function manually instead.

\(fn QUERY CALLBACK &optional NONINTERACTIVE)" nil nil)

(autoload 'zoxide-find-file-with-query "zoxide" "\
Open file in path from zoxide with a search query." t nil)

(autoload 'zoxide-find-file "zoxide" "\
Open file in path from zoxide with all paths." t nil)

(autoload 'zoxide-cd-with-query "zoxide" "\
Select default directory through zoxide with a search query." t nil)

(autoload 'zoxide-cd "zoxide" "\
Select default directory through zoxide with all paths." t nil)

(autoload 'zoxide-travel "zoxide" "\
Like `zoxide-find-file', this function is used to open the path directly." t nil)

(autoload 'zoxide-travel-with-query "zoxide" "\
Like `zoxide-travel', a query mached at first." t nil)

(register-definition-prefixes "zoxide" '("zoxide-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; zoxide-autoloads.el ends here
