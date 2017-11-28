The buffer focus hook provides a simple mechanism for reacting to buffer focus changes.
Similar to focus-in-hook and focus-out-hook but for buffers instead of windows.

Example:

(defun focus-in ()
  (message "Buffer gained focus!"))

(defun focus-out ()
  (message "Buffer lost focus") t)

;; set the buffer focus hooks for the current buffer:
(buffer-focus-in-callback 'focus-in)
(buffer-focus-out-callback 'focus-out)
