;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Nham Le"
      user-mail-address "lehoainham@gmail.com")

;;
;; UI
;;
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 19.0))
(setq doom-theme 'doom-one-light)
(setq display-line-numbers-type 'relative)
;; Enable modeline for popup windows
(plist-put +popup-defaults :modeline t)
(setq doom-scratch-buffer-major-mode 'emacs-lisp-mode)
;; open emacs on macOS will result in tiny window without this setting
(toggle-frame-maximized)

(set-formatter! 'cue "cue fmt " :modes '(cue-mode))

(setq-default eglot-workspace-configuration
              '((:gopls . ((gofumpt . t)))))

(after! magit
  (set-popup-rule! "^magit:\s" :height 0.5 :side 'bottom :select t :modeline t :quit 'current))

(after! prodigy
  (set-popup-rule! "^\*prodigy*" :height 0.35 :side 'bottom :select t :modeline t :quit 'current))

(after! projectile
  ;; Init projectile's search dirs
  (setq projectile-project-search-path (split-string (getenv "EMACS_PROJECTILE_SEARCH_DIRS") ";")))

(defun run-projectile-invalidate-cache (&rest _args)
  ;; We ignore the args to `magit-checkout'.
  (projectile-invalidate-cache nil))
(advice-add 'magit-checkout
            :after #'run-projectile-invalidate-cache)
(advice-add 'magit-branch-and-checkout ; This is `b c'.
            :after #'run-projectile-invalidate-cache)

;; Smart tab, these will only work in GUI Emacs
;; https://github.com/hlissner/doom-emacs/commit/b8a3cad295dcbed1e9952db240b7ce05e94dd7ae
(map! :n [tab] (general-predicate-dispatch nil
                 (and (featurep! :editor fold)
                      (save-excursion (end-of-line) (invisible-p (point))))
                 #'+fold/toggle
                 (fboundp 'evil-jump-item)
                 #'evil-jump-item)
      :v [tab] (general-predicate-dispatch nil
                 (and (bound-and-true-p yas-minor-mode)
                      (or (eq evil-visual-selection 'line)
                          (not (memq (char-after) (list ?\( ?\[ ?\{ ?\} ?\] ?\))))))
                 #'yas-insert-snippet
                 (fboundp 'evil-jump-item)
                 #'evil-jump-item))


;;
;; Load other configurations
;;
(load! "org-config.el")


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("99ea831ca79a916f1bd789de366b639d09811501e8c092c85b2cb7d697777f93" "0cb1b0ea66b145ad9b9e34c850ea8e842c4c4c83abe04e37455a1ef4cc5b8791" "5d09b4ad5649fea40249dd937eaaa8f8a229db1cec9a1a0ef0de3ccf63523014" default)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-ellipsis ((t (:foreground "red" :weight bold)))))
