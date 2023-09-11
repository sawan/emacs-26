;;; indent-lint-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:

(add-to-list 'load-path (or (and load-file-name (file-name-directory load-file-name)) (car load-path)))



;;; Generated autoloads from indent-lint.el

(async-defun indent-lint (&optional buf) "\
Indent BUF in clean Emacs and lint async." (interactive) (let ((buf* (get-buffer (or buf (current-buffer)))) (output-buf (generate-new-buffer "*indent-lint*")) (src-file (make-temp-file "emacs-indent-lint")) (dest-file (make-temp-file "emacs-indent-lint"))) (condition-case err (let* ((_res (await (indent-lint--promise-indent buf* src-file dest-file))) (res (await (indent-lint--promise-diff buf* src-file dest-file)))) (ignore-errors (delete-file src-file) (delete-file dest-file)) (with-current-buffer output-buf (seq-let (code output) res (insert output) (insert (format "\nDiff finished%s.  %s\n" (cond ((equal 0 code) " (no differences)") ((equal 1 code) " (has differences)") ((equal 2 code) " (diff error)") (t (format "(unknown exit code: %d)" code))) (current-time-string))) (special-mode) (diff-mode) (when indent-lint-popup (display-buffer output-buf)) `(,code ,output-buf)))) (error (pcase err (`(error (fail-indent ,reason)) (warn "Fail indent in clean Emacs\n  buffer: %s\n  major-mode: %s\n  src-file: %s\n  dest-file: %s\n  reason: %s" (prin1-to-string buf*) (with-current-buffer buf* major-mode) src-file dest-file (prin1-to-string reason)) `(3 nil)) (`(error (fail-diff ,code ,output)) (warn "Fail diff.\n  buffer: %s\n  src-file: %s\n  dest-file: %s\n  reason: %s" (prin1-to-string buf*) src-file dest-file output) `(,code ,(with-current-buffer output-buf (insert output) output-buf))) (`(error (fail-diff-unknown ,code ,output)) (warn "Fail diff unknown.\n  buffer: %s\n  src-file: %s\n  dest-file: %s\n  reason: %s" (prin1-to-string buf*) src-file dest-file output) `(,code ,(with-current-buffer output-buf (insert output) output-buf))))))))
(autoload 'indent-lint-file "indent-lint" "\
Return promise to run `indent-lint' for FILEPATH.

(fn FILEPATH)")
(register-definition-prefixes "indent-lint" '("indent-lint-"))

;;; End of scraped data

(provide 'indent-lint-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; indent-lint-autoloads.el ends here