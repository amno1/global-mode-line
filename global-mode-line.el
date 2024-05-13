;; global-mode-line.el --- Turn tab-bar into a global mode line -*- lexical-binding: t; -*-

;; Copyright (C) 2022  Arthur Miller

;; Author: Arthur Miller <arthur.miller@live.com>
;; Package-Version: 0.5.0
;; Package-Requires ((emacs "28.1"))
;; Keywords: convenience

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This library provides a global mode which replaces per-buffer mode-lines with
;; a global mode-line put into a tab-bar. Original mode-line is rendered as a
;; thin line to regain the horizontal separation between buffers.

;; Issues and limitations

;; Don't use this if you are using tab-bar to display visual tabs for your
;; buffer. It conflicts with, and completely takes over tab-bar.

;; Without modeline you will loose the grip to resize windows horizontally and
;; vertically with mouse (you can of course use the keyboard).

;; If you use Emacs without horizontal scrollbars, you will also loose a clear
;; visual separation between horizontal windows.

;; Acknowledgements

;; The original idea for global-mode-line is from my answer to an anonymours
;; question on Reddit.

;;; Code:
(require 'tab-bar)

(defgroup global-mode-line nil
  "Enable mode-line in tab-bar-lines."
  :prefix "global-mode-line-"
  :group 'convenience)

(defvar global-mode-line--turn-off-tb nil)
(defvar global-mode-line--tb-backup tab-bar-tab-name-format-function)
(defvar-local global-mode-line-format (copy-sequence mode-line-format))

;;;###autoload
(define-minor-mode global-mode-line-mode
  "Display mode-line in tab-bar-lines."
  :global t :lighter " GML" :group 'global-mode-line
  (cond (global-mode-line-mode
         (customize-set-variable
          'tab-bar-tab-name-format-function
          (lambda (_ _) (format-mode-line global-mode-line-format)))
         (customize-set-variable 'tab-bar-tab-name-format-functions nil)
         (setq-default mode-line-format nil)
         (unless (bound-and-true-p tab-bar-mode)
           (tab-bar-mode +1)
           (setq global-mode-line--turn-off-tb t)))
        (t
         (when global-mode-line--turn-off-tb
           (tab-bar-mode -1)
           (setq global-mode-line--turn-off-tb nil))
         (customize-set-variable
          'tab-bar-tab-name-format-function global-mode-line--tb-backup)
         (setq-default mode-line-format
                       (copy-sequence global-mode-line-format)))))

(provide 'global-mode-line)
