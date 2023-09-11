;;; eat-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:

(add-to-list 'load-path (or (and load-file-name (file-name-directory load-file-name)) (car load-path)))



;;; Generated autoloads from eat.el

(autoload 'eat-term-make "eat" "\
Make a Eat terminal at POSITION in BUFFER.

(fn BUFFER POSITION)")
(autoload 'eat "eat" "\
Start a new Eat terminal emulator in a buffer.

Start a new Eat session, or switch to an already active session.
Return the buffer selected (or created).

With a non-numeric prefix ARG, create a new session.

With a numeric prefix ARG (like \\[universal-argument] 42 \\[eat]),
switch to the session with that number, or create it if it doesn't
already exist.

With double prefix argument ARG, ask for the program to run and run it
in a newly created session.

PROGRAM can be a shell command.

(fn &optional PROGRAM ARG)" t)
(defvar eat-eshell-mode nil "\
Non-nil if Eat-Eshell mode is enabled.
See the `eat-eshell-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `eat-eshell-mode'.")
(custom-autoload 'eat-eshell-mode "eat" nil)
(autoload 'eat-eshell-mode "eat" "\
Toggle Eat terminal emulation in Eshell.

This is a global minor mode.  If called interactively, toggle the
`Eat-Eshell mode' mode.  If the prefix argument is positive,
enable the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `(default-value \\='eat-eshell-mode)'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

(fn &optional ARG)" t)
(defvar eat-eshell-visual-command-mode nil "\
Non-nil if Eat-Eshell-Visual-Command mode is enabled.
See the `eat-eshell-visual-command-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `eat-eshell-visual-command-mode'.")
(custom-autoload 'eat-eshell-visual-command-mode "eat" nil)
(autoload 'eat-eshell-visual-command-mode "eat" "\
Toggle running Eshell visual commands with Eat.

This is a global minor mode.  If called interactively, toggle the
`Eat-Eshell-Visual-Command mode' mode.  If the prefix argument is
positive, enable the mode, and if it is zero or negative, disable
the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `(default-value \\='eat-eshell-visual-command-mode)'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

(fn &optional ARG)" t)
(autoload 'eat-project "eat" "\
Start Eat in the current project's root directory.

Start a new Eat session, or switch to an already active session.
Return the buffer selected (or created).

With a non-numeric prefix ARG, create a new session.

With a numeric prefix ARG (like
\\[universal-argument] 42 \\[eat-project]), switch to the session with
that number, or create it if it doesn't already exist.

(fn &optional ARG)" t)
(register-definition-prefixes "eat" '("eat-"))

;;; End of scraped data

(provide 'eat-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; eat-autoloads.el ends here
