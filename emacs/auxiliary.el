(setq semantic-refactor-local-package
      "/home/brian/.emacs.d/external/semantic-refactor/")
(when (file-directory-p semantic-refactor-local-package)
  (add-to-list 'load-path semantic-refactor-local-package)
  (use-package srefactor
    :ensure nil
    :hook
    (c-mode   . (lambda ()
	          (semantic-mode)
	          (define-key c-mode-map
			      (kbd "M-RET")
			      'srefactor-refactor-at-point)))
    (c++-mode . (lambda ()
	          (semantic-mode)
	          (define-key c++-mode-map
			      (kbd "M-RET")
			      'srefactor-refactor-at-point)))))

(defun bg/--get-clangd-path ()
  (car (alist-get 'c++-mode eglot-server-programs)))
(defun bg/which-clangd ()
  (interactive)
  (message "%s" (bg/--get-clangd-path)))
(defun bg/toggle-clangd ()
  (interactive)
  (let ((clangd-path (bg/--get-clangd-path)))
    (setq eglot-server-programs
	  (assoc-delete-all 'c++-mode eglot-server-programs))
    (if (equal clangd-path "clangd")
	(progn
	  (add-to-list 'eglot-server-programs
		       '(c++-mode . ("/home/brian/s/llvm-project/build/bin/clangd" "--completion-style=detailed")))
	  (message "using development clangd binary"))
      (progn
	(add-to-list 'eglot-server-programs
		     '(c++-mode . ("clangd" "--completion-style=detailed")))
	(message "using system clangd binary")))))
(defun bg/toggle-clangd-and-restart ()
  (interactive)
  (eglot-shutdown-all)
  (bg/toggle-clangd)
  (add-hook 'post-command-hook
	    'bg/--toggle-clangd-and-restart-post-command
	    'append t)
  (eglot-ensure))
(defun bg/--toggle-clangd-and-restart-post-command ()
  (message "restarted eglot with clangd path: %s"
	   (bg/--get-clangd-path))
  (remove-hook 'post-command-hook
	       'bg/--toggle-clangd-and-restart-post-command
	       t))
