;; -*- lexical-binding: t -*-

(defvar buffer-focus-current-buffer nil)

(defvar buffer-focus-in-hook nil
  "Normal hook run run when a buffers window gains focus")

(defvar buffer-focus-out-hook nil
  "Normal hook run when a buffers window looses focus")

(defun buffer-focus-out-callback (callback &optional buffer)
  "Set the function to be run when the current buffer window looses focus"
  (with-current-buffer (or buffer (current-buffer))
    (add-hook 'buffer-focus-out-hook callback nil t)))

(defun buffer-focus-in-callback (callback &optional buffer)
  "Set the function to be run when the current buffer window gains focus"
  (with-current-buffer (or buffer (current-buffer))
    (add-hook 'buffer-focus-in-hook callback nil t)))

(defun buffer-focus-remove (buffer)
  (with-current-buffer buffer
    (run-hooks 'buffer-focus-out-hook)
    (setq buffer-focus-current-buffer nil)))

(defun buffer-focus-updater ()
  (when (not (buffer-live-p buffer-focus-current-buffer))
    (setq buffer-focus-current-buffer nil))
  (when (and (eq (window-buffer (selected-window))
                 (current-buffer))
             (not (eq buffer-focus-current-buffer
                      (current-buffer))))
    ;; selected window has current buffer
    (when buffer-focus-current-buffer
      ;; current buffer lost focus
      (buffer-focus-remove buffer-focus-current-buffer))

    (when (or buffer-focus-in-hook
              buffer-focus-out-hook)
      ;; current buffer gaining focus
      (setq buffer-focus-current-buffer (current-buffer))
      (when buffer-focus-in-hook
	(run-hooks 'buffer-focus-in-hook)))))

(add-hook 'buffer-list-update-hook 'buffer-focus-updater)

(provide 'buffer-focus-hook)
