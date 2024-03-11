(define-minor-mode ordoemacs-mode
  "Ordoemacs mode."
  :lighter "ordoemacs"
  (add-hook 'write-contents-functions 'encrypt))

(defun encrypt ()
  "Encrypts the buffer and replaces file content"
  (let ((output-path "/tmp/ordo-emacs.enc"))
    (write-region nil nil output-path)
    (shell-command (concat "gpg -vv --batch --passphrase-file ~/.ssh/ordo-emacs -c " output-path))
    (shell-command (concat "rm " (buffer-file-name)))
    (shell-command (concat "mv /tmp/ordo-emacs.enc.gpg " (buffer-file-name)))
    (shell-command (concat "rm " output-path))
    (set-buffer-modified-p nil) ;; set the buffer as unmodified
    t)) ;; return non-nil value to abort default save

(defun decrypt ()
  "Checks if file exists, if it does, decrypts it and inserts the content to the buffer."
  (when (file-exists-p (buffer-file-name))
    (let ((output-path "/tmp/ordo-emacs.dec"))
    (shell-command (concat "gpg -vv --batch --decrypt --passphrase-file ~/.ssh/ordo-emacs -o " output-path " " (buffer-file-name)))
    (insert-file-contents output-path nil nil nil t)
    (set-buffer-modified-p nil)
    (shell-command "rm -f /tmp/ordo-emacs.dec")
    )))

(defun enable-ordoemacs-mode ()
  "Enables ordoemacs mode and decrypts file."
  (progn
    (ordoemacs-mode +1)
    (decrypt)))

(defun disable-ordoemacs-mode ()
  "Disables ordo emacs mode."
  (progn
    (ordoemacs-mode 0)
    (remove-hook 'write-contents-functions 'encrypt)))

;;; Every time a file is open, it enables or disables ordoemacs-mode
(add-hook 'find-file-hook
          (lambda ()
            (if (string= (file-name-extension buffer-file-name) "ordo")
              (enable-ordoemacs-mode)
              (disable-ordoemacs-mode))))
