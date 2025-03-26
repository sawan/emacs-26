;;; shift-number.el --- Increase/decrease the number at point -*- lexical-binding: t -*-

;; SPDX-License-Identifier: GPL-3.0-or-later
;; Copyright (c) 2016–2017 Alex Kost

;; Author: Alex Kost <alezost@gmail.com>

;; URL: https://codeberg.org/ideasman42/emacs-shift-number
;; Keywords: convenience
;; Created: 12 Apr 2016
;; Package-Version: 20250314.234
;; Package-Revision: b25fc4fc02a0
;; Package-Requires: ((emacs "24.1"))

;;; Commentary:

;; Increase or decrease the number at point with `shift-number-up' and
;; `shift-number-down' commands.

;; To install the package manually, add the following to your init file:
;;
;; (add-to-list 'load-path "/path/to/shift-number-dir")
;; (autoload 'shift-number-up "shift-number" nil t)
;; (autoload 'shift-number-down "shift-number" nil t)

;; For more verbose description and a gif demonstration, see
;; <https://github.com/alezost/shift-number.el>.

;;; Code:


;; ---------------------------------------------------------------------------
;; Custom Variables

(defgroup shift-number nil
  "Increase or decrease the number at point."
  :group 'convenience)

(defcustom shift-number-regexp "\\([[:digit:]]+\\)"
  "Regexp for `shift-number' function.
The first parenthesized expression must match the number."
  :type 'regexp)

(defcustom shift-number-negative t
  "If non-nil, support negative numbers."
  :type 'boolean)

(defcustom shift-number-motion nil
  "If non-nil, move the point to the end of the number."
  :type 'boolean)

(declare-function apply-on-rectangle "rect")


;; ---------------------------------------------------------------------------
;; Private Functions

(defun shift-number--replace-in-region (str beg end)
  "Utility to replace region from BEG to END with STR.
Return the region replaced."
  (declare (important-return-value nil))

  (let ((len (length str))
        (i-beg nil)
        (i-end nil)
        (i-end-ofs nil))

    ;; Check for skip end.
    (let ((i 0))
      (let ((len-test (min (- end beg) len)))
        (while (< i len-test)
          (let ((i-next (1+ i)))
            (cond
             ((eq (aref str (- len i-next)) (char-after (- end i-next)))
              (setq i i-next))
             (t ; Break.
              (setq len-test i))))))
      (unless (zerop i)
        (setq i-end (- len i))
        (setq len (- len i))
        (setq end (- end i))
        (setq i-end-ofs i)))

    ;; Check for skip start.
    (let ((i 0))
      (let ((len-test (min (- end beg) len)))
        (while (< i len-test)
          (cond
           ((eq (aref str i) (char-after (+ beg i)))
            (setq i (1+ i)))
           (t ; Break.
            (setq len-test i)))))
      (unless (zerop i)
        (setq i-beg i)
        (setq beg (+ beg i))))

    (when (or i-beg i-end)
      (setq str (substring str (or i-beg 0) (or i-end len))))

    (goto-char beg)
    (delete-region beg end)
    (insert str)
    (when i-end-ofs
      ;; Leave the cursor where it would be if the end wasn't clipped.
      (goto-char (+ (point) i-end-ofs)))
    (cons beg (+ beg (length str)))))

(defun shift-number--in-regexp-p (regexp pos limit-beg limit-end)
  "Return non-nil, if POS is inside REGEXP on the current line."
  ;; The code originates from `org-at-regexp-p'.
  (save-excursion
    (let ((found nil)
          (exit nil))
      (goto-char limit-beg)
      (while (and (not (or exit found)) (re-search-forward regexp limit-end t))
        (cond
         ((> (match-beginning 0) pos)
          (setq exit t))
         ((>= (match-end 0) pos)
          (setq found t))))
      found)))

(defun shift-number--impl (n pos limit-beg limit-end)
  "Change the number at point by N.
If there is no number at point, search forward till the end of
the current line and change it.

Search backwards from LIMIT-BEG for a number overlapping POS.
Otherwise search forward limited by LIMIT-END."
  ;; The whole number is removed and a new number is inserted in its
  ;; place, so `save-excursion' is not used, as it will put the point at
  ;; the beginning of the number.  Instead, the point is saved and
  ;; restored later.
  (let ((num-bounds
         (save-match-data
           (cond
            ((or (and (< limit-beg pos)
                      (shift-number--in-regexp-p shift-number-regexp pos limit-beg limit-end))
                 (re-search-forward shift-number-regexp limit-end t))
             (cons (match-beginning 1) (match-end 1)))
            (t
             nil)))))

    (cond
     (num-bounds
      (let* ((beg (car num-bounds))
             (end (cdr num-bounds))
             (sign
              (and shift-number-negative
                   (cond
                    ((eq ?- (char-before beg))
                     -1)
                    (t
                     1))))
             (old-bounds
              (cons
               (cond
                ((eq sign -1)
                 (1- beg))
                (t
                 beg))
               end))

             (old-num-str (buffer-substring-no-properties beg end))
             (old-num (string-to-number old-num-str))
             (new-num (+ old-num (* sign n)))

             (new-num-sign-str "")
             (new-num-leading-str "")
             (new-num-str (number-to-string (abs new-num))))

        ;; Handle sign flipping & negative numbers.
        (when (< new-num 0)
          (setq sign (- sign)))
        (when (eq sign -1)
          (setq new-num-sign-str "-"))

        ;; If there are leading zeros, preserve them keeping the same
        ;; length of the original number.
        (when (string-match-p "\\`0" old-num-str)
          (let ((len-diff (- (length old-num-str) (length new-num-str))))
            (when (> len-diff 0)
              (setq new-num-leading-str (make-string len-diff ?0)))))

        ;; Prefer this over delete+insert so as to reduce the undo overhead
        ;; when numbers are mostly the same.
        (let* ((new-num-str-full (concat new-num-sign-str new-num-leading-str new-num-str))
               (new-bounds (cons (car old-bounds) (+ (car old-bounds) (length new-num-str-full)))))

          (shift-number--replace-in-region new-num-str-full (car old-bounds) (cdr old-bounds))

          ;; Result.
          (cons old-bounds new-bounds))))
     (t
      nil))))

(defun shift-number--on-line (n)
  "Adjust the number N on the current line."
  (let* ((old-pos (point))
         (bounds-pair
          (shift-number--impl n old-pos (line-beginning-position) (line-end-position))))

    (unless bounds-pair
      (error "No number on the current line"))

    (let* ((old-bounds (car bounds-pair))
           (new-bounds (cdr bounds-pair))
           (old-end (cdr old-bounds))
           (new-end (cdr new-bounds)))

      (cond
       ;; If the point was exactly at the end, keep it there.
       ((eq old-pos old-end)
        (setq old-pos new-end))
       ;; Prevent the change causing the cursor to "leave" the number,
       ;; allowing for further adjustments.
       (t
        (setq old-pos (min new-end old-pos))))

      (goto-char old-pos)

      (when shift-number-motion
        (goto-char new-end))

      new-end)))

(defun shift-number--on-region-impl (n region-beg region-end)
  "Shift the numbers N in the region defined.
REGION-BEG & REGION-END define the region."
  (save-excursion
    (let ((bounds-pair nil))
      (goto-char region-beg)
      (while (and (setq bounds-pair (shift-number--impl n region-beg region-beg region-end)))
        (let* ((old-bounds (car bounds-pair))
               (new-bounds (cdr bounds-pair))
               (old-end (cdr old-bounds))
               (new-end (cdr new-bounds)))

          ;; Keep contracting the region forward & updating it's end-points.
          (setq region-beg new-end)
          (setq region-end (+ region-end (- new-end old-end)))))))
  region-end)

(defun shift-number--on-region (n)
  "Shift the numbers N on the current region."
  (shift-number--on-region-impl n (region-beginning) (region-end)))

(defun shift-number--on-rectangle (n)
  "Shift the numbers N on the current region."
  (let ((shift-fn `(lambda (beg end) (save-excursion (shift-number--on-region-impl ,n beg end)))))
    (apply-on-rectangle
     ;; Make the values global.
     `(lambda (beg end) (funcall ,shift-fn (+ (point) beg) (+ (point) end)))
     (region-beginning)
     (region-end))))

(defun shift-number--on-context (n)
  "Manipulate numbers in the current region or line by N."
  (cond
   ((bound-and-true-p rectangle-mark-mode)
    (shift-number--on-rectangle n))
   ((region-active-p)
    (shift-number--on-region n))
   (t
    (shift-number--on-line n))))


;; ---------------------------------------------------------------------------
;; Public Functions

;;;###autoload
(defun shift-number-up (&optional arg)
  "Increase the number at point (or on the current line) by ARG."
  (interactive "p")
  (shift-number--on-context arg))

;;;###autoload
(defun shift-number-down (&optional arg)
  "Decrease the number at point (or on the current line) by ARG."
  (interactive "p")
  (shift-number--on-context (- arg)))

(provide 'shift-number)
;; Local Variables:
;; fill-column: 99
;; indent-tabs-mode: nil
;; End:
;;; shift-number.el ends here
