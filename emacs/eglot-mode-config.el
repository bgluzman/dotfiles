(defun eglot-format-on-save ()
  (when (and (memq 'eglot--managed-mode minor-mode-list)
	     (memq this-command '(save-buffer save-some-buffers)))
    (eglot-format-buffer)))

(use-package eglot
  :init
  (add-hook 'after-save-hook #'eglot-format-on-save)
  :config
  ;; !!! DO NOT REMOVE UNTIL EGLOT IS FIXED !!!
  ;; Without this line, eglot keels over and becomes unusable. Details here:
  ;; https://www.reddit.com/r/emacs/comments/1447fy2/looking_for_help_in_improving_typescript_eglot/jnescet/
  (fset #'jsonrpc--log-event #'ignore)
  ;; needed for overload suggestions
  (add-to-list 'eglot-server-programs
	       '(c++-mode . ("clangd" "--completion-style=detailed")))
  (add-to-list 'eglot-server-programs
	       '(c-mode . ("clangd" "--completion-style=detailed")))
  (add-to-list 'eglot-server-programs
	       '(rust-mode . ("rust-analyzer")))
  (setq-default eglot-workspace-configuration
		'(:pylsp
		  (:plugins (:flake8          (:enabled t)
					      :pycodesytle     (:enabled :json-false)
					      :jedi_completion (:include_params t
										:fuzzy t)
					      :pylint          (:enabled :json-false)
					      :black           (:enabled     t
									     :line_length 79)
					      :pylsp_mypy      (:enabled t)))))
  :bind
  (:map eglot-mode-map
	;; code actions
	("C-c l a" . eglot-code-actions)
	("C-c l i" . eglot-code-action-organize-imports)
	("C-c l q" . eglot-code-action-quickfix)
	("C-c l e" . eglot-code-action-extract)
	("C-c l l" . eglot-code-action-inline)
	("C-c l r" . eglot-code-action-rewrite)
	;; formatting
	("C-c l f" . eglot-format-buffer)
	;; misc
	("C-c l v" . eglot-find-declaration)
	;; TODO: move these to the global mode map with different binds?
	;; diagnostics
	("C-c l d" . eldoc)
	("C-c l b" . flymake-show-buffer-diagnostics)
	("C-c l p" . flymake-show-project-diagnostics))
  :hook
  (c-mode . eglot-ensure)
  (c++-mode . eglot-ensure)
  (python-mode . eglot-ensure)
  (rust-mode . eglot-ensure))
