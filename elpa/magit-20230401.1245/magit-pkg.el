(define-package "magit" "20230401.1245" "A Git porcelain inside Emacs."
  '((emacs "25.1")
    (compat "29.1.3.4")
    (dash "20221013")
    (git-commit "20230101")
    (magit-section "20230101")
    (transient "20230201")
    (with-editor "20230118"))
  :commit "dd2e870b134bd292e470c830a42ce59a4396cdb7" :authors
  '(("Marius Vollmer" . "marius.vollmer@gmail.com")
    ("Jonas Bernoulli" . "jonas@bernoul.li"))
  :maintainer
  '("Jonas Bernoulli" . "jonas@bernoul.li")
  :keywords
  '("git" "tools" "vc")
  :url "https://github.com/magit/magit")
;; Local Variables:
;; no-byte-compile: t
;; End:
