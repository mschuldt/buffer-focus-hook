;;; buffer-focus-hook.el --- A buffer focus hook  -*- lexical-binding: t -*-

;; Copyright (C) 2017 Michael Schuldt

;; Author: Michael Schuldt <mbschuldt@gmail.com>
;; Version: 1.0
;; URL: https://github.com/mschuldt/buffer-focus-hook

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;  The buffer focus hook provides a simple mechanism for reacting to buffer focus changes.
;;  Similar to focus-in-hook and focus-out-hook but for buffers instead of windows.
;;
;;  Example:
;;
;;  (defun focus-in ()
;;    (message "Buffer gained focus!"))
;;
;;  (defun focus-out ()
;;    (message "Buffer lost focus") t)
;;
;;  ;; set the buffer focus hooks for the current buffer:
;;  (buffer-focus-in-callback 'focus-in)
;;  (buffer-focus-out-callback 'focus-out)

;;; Code:

(defvar buffer-focus-hook--current-buffer nil
  "Buffer currently in focus.")

(defvar buffer-focus-hook--in nil
  "Normal hook run when a buffers window gains focus.")

(defvar buffer-focus-hook--out nil
  "Normal hook run when a buffers window looses focus.")

(defun buffer-focus-out-callback (callback &optional buffer)
  "Set the CALLBACK to be run when BUFFER or current buffer window looses focus."
  (with-current-buffer (or buffer (current-buffer))
    (add-hook 'buffer-focus-hook--out callback nil t)))

(defun buffer-focus-in-callback (callback &optional buffer)
  "Set the CALLBACK to be run when BUFFER or current buffer window gains focus."
  (with-current-buffer (or buffer (current-buffer))
    (add-hook 'buffer-focus-hook--in callback nil t)))

(defun buffer-focus-hook--updater ()
  "Main buffer focus hook update function added for ‘buffer-list-update-hook’."
  (when (not (buffer-live-p buffer-focus-hook--current-buffer))
    (setq buffer-focus-hook--current-buffer nil))
  (when (and (eq (window-buffer (selected-window))
                 (current-buffer))
             (not (eq buffer-focus-hook--current-buffer
                      (current-buffer))))
    ;; selected window has current buffer
    (when buffer-focus-hook--current-buffer
      ;; current buffer lost focus
      (with-current-buffer buffer-focus-hook--current-buffer
        (run-hooks 'buffer-focus-hook--out)
        (setq buffer-focus-hook--current-buffer nil)))

    (when (or buffer-focus-hook--in
              buffer-focus-hook--out)
      ;; current buffer gaining focus
      (setq buffer-focus-hook--current-buffer (current-buffer))
      (run-hooks 'buffer-focus-hook--in))))

(add-hook 'buffer-list-update-hook 'buffer-focus-hook--updater)

(provide 'buffer-focus-hook)

;;; buffer-focus-hook.el ends here
