;;; $DOOMDIR/org-config.el -*- lexical-binding: t; -*-


;; has to be set before org loaded
(setq org-directory (getenv "EMACS_ORG_DIR"))
(setq org-roam-directory org-directory)
;; Orgmode
(after! org
  (setq org-agenda-files  (list org-directory))
  (setq org-ellipsis "  ")
  (setq org-archive-location "archive.org::* File %s")

  ;; foreground red is suitable for light theme, cyan for dark theme
  (custom-set-faces '(org-ellipsis ((t (:foreground "red" :weight bold)))))
  ;; Only show the first occurrent of repeated tasks in the agenda
  (setq org-agenda-show-future-repeats 'next)
  ;; Don't auto-insert newline for orgmode buffer, instead wrap long lines
  (remove-hook 'text-mode-hook #'auto-fill-mode)

  (custom-declare-face '+org-todo-next '((t (:inherit (bold font-lock-doc-face org-todo)))) "")
  (custom-declare-face '+org-todo-strt '((t (:inherit (bold font-lock-doc-face org-todo)))) "")

  (setq org-todo-keywords
        '((sequence
           "TODO(t)"                    ; A task that needs doing
           "NEXT(n)"                    ; Task need to focus next
           "STRT(s)"                    ; Task is in progress
           "WAIT(w)"                    ; Task is being held up or paused
           "|"
           "DONE(d)"
           "KILL(k)")
          (sequence
           "[ ](T)"                     ; A task that needs doing
           "[-](S)"                     ; Task is in progress
           "[?](W)"                     ; Task is being held up or paused
           "|"
           "[X](D)"))
        org-todo-keyword-faces
        '(("TODO" . +org-todo-active)
          ("[ ]"  . +org-todo-active)
          ("NEXT" . +org-todo-next)
          ("STRT" . +org-todo-strt)
          ("[-]"  . +org-todo-active)
          ("WAIT" . +org-todo-onhold)
          ("[?]"  . +org-todo-onhold)))

  (setq org-agenda-show-all-dates 0)
  (setq org-clock-in-switch-to-state "STRT")
  (setq org-clock-out-when-done t)
  (setq org-log-into-drawer t)
  (setq org-dim-blocked-tasks 'invisible)
  (setq org-clock-out-remove-zero-time-clocks t)
  (setq org-clock-report-include-clocking-task t)
  ;; clockout after 5 minutes of idling
  ;;(setq org-clock-auto-clockout-timer 300)
  (org-clock-auto-clockout-insinuate)

  (setq org-capture-file (concat (file-name-as-directory org-directory) "capture.org")
        org-gtd-file (concat (file-name-as-directory org-directory) "gtd.org")
        org-work-file (concat (file-name-as-directory org-directory) "work.org")
        org-journal-file (concat (file-name-as-directory org-directory) "journal.org")
        org-capture-templates
        '(("t" "Todo" entry
           (file+headline org-gtd-file "Inbox")
           "* TODO %?\n%i\n%U\n%a" :prepend t)
          ("w" "Task at work" entry
           (file+headline org-work-file "Tasks")
           "* TODO %?\n%i\n%U\n%a" :prepend t)
          ("n" "Note" entry
           (file+headline org-capture-file "Notes")
           "* %?\n%i\n%U\n%a" :prepend t)
          ("p" "Project" entry
           (file+headline org-capture-file "Projects")
           "* %?\n%i\n%U\n%a" :prepend t)
          ("j" "Journal" entry
           (file+olp+datetree org-journal-file)
           "* %U %?\n%i\n%a" :prepend t)))

  (setq
   org-work-files (list (concat (file-name-as-directory org-directory) "work.org"))
   org-gtd-files (list (concat (file-name-as-directory org-directory) "gtd.org"))
   org-test-files (list (concat (file-name-as-directory org-directory) "test.org"))

   org-agenda-custom-commands
   '(("g" "Getting things done"
      ((agenda ""
               ((org-agenda-files org-gtd-files)
                (org-agenda-span 7)
                (org-agenda-show-all-dates nil)
                (org-agenda-overriding-header "This week: ")))
       (todo "STRT" ((org-agenda-overriding-header "Underway: ")
                     (org-agenda-files org-gtd-files)))
       (todo "NEXT" ((org-agenda-overriding-header "To do next: ")
                     (org-agenda-files org-gtd-files)))
       (tags-todo "+PRIORITY=\"A\"" ((org-agenda-overriding-header "Important: ")
                                     (org-agenda-files org-gtd-files)))))
     ("t" "Test agenda"
      ((agenda ""
               ((org-agenda-files org-test-files)
                (org-agenda-span 7)
                (org-agenda-show-all-dates nil)
                (org-agenda-overriding-header "This week: ")))
       (todo "STRT" ((org-agenda-overriding-header "Underway: ")
                     (org-agenda-files org-test-files)))
       (todo "NEXT" ((org-agenda-overriding-header "To do next: ")
                     (org-agenda-files org-test-files)))
       (tags-todo "TODO=\"TODO\"+PRIORITY=\"A\"" ((org-agenda-overriding-header "Important: ")
                                                  (org-agenda-files org-test-files)))
       (tags-todo "TODO=\"WAIT\"+PRIORITY=\"A\"" ((org-agenda-overriding-header "Stuck important tasks: ")
                                                  (org-agenda-files org-test-files)))))
     ("w" "Tasks at Work"
      ((agenda ""
               ((org-agenda-files org-work-files)
                (org-agenda-span 7)
                (org-agenda-show-all-dates nil)
                (org-agenda-overriding-header "This week: ")))
       (todo "STRT" ((org-agenda-overriding-header "Underway: ")
                     (org-agenda-files org-work-files)))
       (todo "NEXT" ((org-agenda-overriding-header "To do next: ")
                     (org-agenda-files org-work-files)))
       (tags-todo "+PRIORITY=\"A\"" ((org-agenda-overriding-header "Important: ")
                                     (org-agenda-files org-work-files))))))))

(setq org-roam-directory org-directory)
(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam ;; or :after org
  ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;         a hookable mode anymore, you're advised to pick something yourself
  ;;         if you don't care about startup time, use
  ;;  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(use-package! ob-mermaid
  :after org
  :config

  (setq ob-mermaid-cli-path "/opt/homebrew/bin/mmdc")

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((mermaid . t)
     (scheme . t)
     (your-other-langs . t))))

(after! org-pomodoro
  (setq org-pomodoro-length 45))

(defun +nhamlh/org-agenda-goto (&optional highlight)
  "Go to the entry at point in the corresponding Org file.
Most of this function is copied from the original org-agenda-goto
except that buffer-creating behaviour.
It creates a doom popup and focus on it instead of a normal window."
  (interactive)
  (let* ((marker (or (org-get-at-bol 'org-marker)
		     (org-agenda-error)))
	 (buffer (marker-buffer marker))
	 (pos (marker-position marker)))
    (kill-this-buffer)
    (+popup-buffer buffer '((window-height . 0.5) (window-parameters (select . t ))))
    (widen)
    (push-mark)
    (goto-char pos)
    (when (derived-mode-p 'org-mode)
      (org-show-context 'agenda)
      (recenter (/ (window-height) 2))
      (org-back-to-heading t)
      (let ((case-fold-search nil))
	(when (re-search-forward org-complex-heading-regexp nil t)
	  (goto-char (match-beginning 4)))))
    (run-hooks 'org-agenda-after-show-hook)
    (and highlight (org-highlight (point-at-bol) (point-at-eol)))))

(after! evil-org-agenda
  (map! :map evil-org-agenda-mode-map
        :m "TAB"  #'+nhamlh/org-agenda-goto
        :m "<tab>"  #'+nhamlh/org-agenda-goto))
(add-hook 'after-init-hook (lambda ()
                             (when (fboundp 'auto-dim-other-buffers-mode)
                               (auto-dim-other-buffers-mode t))))
