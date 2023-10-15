;;; difftastic-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:

(add-to-list 'load-path (or (and load-file-name (file-name-directory load-file-name)) (car load-path)))



;;; Generated autoloads from difftastic.el

(autoload 'difftastic-magit-show "difftastic" "\
Show the result of \\='git show REV\\=' with difftastic.
When REV couldn't be guessed or called with prefix arg ask for REV.

(fn REV)" t)
(autoload 'difftastic-magit-diff "difftastic" "\
Show the result of \\='git diff ARG\\=' with difftastic.
When ARG couldn't be guessed or called with prefix arg ask for ARG.

(fn ARG)" t)
(autoload 'difftastic-buffers "difftastic" "\
Run difftastic on a pair of buffers, BUFFER-A and BUFFER-B.
Optionally, provide a LANG-OVERRIDE to override language used.
See \\='difft --list-languages\\=' for language list.

When:
- either LANG-OVERRIDE is nil and neither of BUFFER-A nor
BUFFER-B is a file buffer,
- or function is called with a prefix arg,

then ask for language before running difftastic.

(fn BUFFER-A BUFFER-B &optional LANG-OVERRIDE)" t)
(autoload 'difftastic-files "difftastic" "\
Run difftastic on a pair of files, FILE-A and FILE-B.
Optionally, provide a LANG-OVERRIDE to override language used.
See \\='difft --list-languages\\=' for language list.  When
function is called with a prefix arg then ask for language before
running difftastic.

(fn FILE-A FILE-B &optional LANG-OVERRIDE)" t)
(register-definition-prefixes "difftastic" '("difftastic-"))

;;; End of scraped data

(provide 'difftastic-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; difftastic-autoloads.el ends here