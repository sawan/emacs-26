;;; flash-region-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "flash-region" "flash-region.el" (0 0 0 0))
;;; Generated autoloads from flash-region.el

(autoload 'flash-region "flash-region" "\
Show an overlay from BEG to END using FACE to set display
properties.  The overlay automatically vanishes after TIMEOUT
seconds.

\(fn BEG END &optional FACE TIMEOUT)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "flash-region" '("flash-region-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; flash-region-autoloads.el ends here
