;; base16-oxocarbon-light-theme.el -- A base16 colorscheme

;;; Commentary:
;; Base16: (https://github.com/tinted-theming/home)

;;; Authors:
;; Scheme: shaunsingh/IBM
;; Template: Kaleb Elwert <belak@coded.io>

;;; Code:

(require 'base16-theme)

(defvar base16-oxocarbon-light-theme-colors
  '(:base00 "#f2f4f8"
    :base01 "#dde1e6"
    :base02 "#525252"
    :base03 "#161616"
    :base04 "#262626"
    :base05 "#393939"
    :base06 "#525252"
    :base07 "#08bdba"
    :base08 "#ff7eb6"
    :base09 "#ee5396"
    :base0A "#ff6f00"
    :base0B "#0f62fe"
    :base0C "#673ab7"
    :base0D "#42be65"
    :base0E "#be95ff"
    :base0F "#37474f")
  "All colors for Base16 Oxocarbon Light are defined here.")

;; Define the theme
(deftheme base16-oxocarbon-light)

;; Add all the faces to the theme
(base16-theme-define 'base16-oxocarbon-light base16-oxocarbon-light-theme-colors)

;; Mark the theme as provided
(provide-theme 'base16-oxocarbon-light)

(provide 'base16-oxocarbon-light-theme)

;;; base16-oxocarbon-light-theme.el ends here
