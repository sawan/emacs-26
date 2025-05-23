;;; pulsar-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:

(add-to-list 'load-path (or (and load-file-name (directory-file-name (file-name-directory load-file-name))) (car load-path)))



;;; Generated autoloads from pulsar.el

(autoload 'pulsar-pulse-line "pulsar" "\
Temporarily highlight the current line.
When `pulsar-pulse' is non-nil (the default) make the highlight
pulse before fading away.  The pulse effect is controlled by
`pulsar-delay' and `pulsar-iterations'.

Also see `pulsar-highlight-line' for a highlight without the
pulse effect." t)
(autoload 'pulsar-pulse-region "pulsar" "\
Temporarily highlight the active region if any." t)
(autoload 'pulsar-highlight-line "pulsar" "\
Temporarily highlight the current line.
Unlike `pulsar-pulse-line', never pulse the current line.  Keep
the highlight in place until another command is invoked.

Use `pulsar-highlight-face' (it is the same as `pulsar-face' by
default)." t)
(autoload 'pulsar-define-pulse-with-face "pulsar" "\
Produce function to `pulsar--pulse' with FACE.
If FACE starts with the `pulsar-' prefix, remove it and keep only
the remaining text.  The assumption is that something like
`pulsar-red' will be convered to `red', thus deriving a function
named `pulsar-pulse-line-red'.  Any other FACE is taken as-is.

(fn FACE)" nil t)
(function-put 'pulsar-define-pulse-with-face 'lisp-indent-function 'function)
(autoload 'pulsar-highlight-dwim "pulsar" "\
Temporarily highlight the current line or active region.
The region may also be a rectangle.

For lines, do the same as `pulsar-highlight-line'." t)
(put 'pulsar-global-mode 'globalized-minor-mode t)
(defvar pulsar-global-mode nil "\
Non-nil if Pulsar-Global mode is enabled.
See the `pulsar-global-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `pulsar-global-mode'.")
(custom-autoload 'pulsar-global-mode "pulsar" nil)
(autoload 'pulsar-global-mode "pulsar" "\
Toggle Pulsar mode in all buffers.
With prefix ARG, enable Pulsar-Global mode if ARG is positive; otherwise, disable it.

If called from Lisp, toggle the mode if ARG is `toggle'.
Enable the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

Pulsar mode is enabled in all buffers where `pulsar--on' would do it.

See `pulsar-mode' for more information on Pulsar mode.

(fn &optional ARG)" t)
(register-definition-prefixes "pulsar" '("pulsar-"))

;;; End of scraped data

(provide 'pulsar-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; pulsar-autoloads.el ends here
