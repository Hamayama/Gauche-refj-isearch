(use util.match)

(define (main args)
  (define (usage) (exit 1 (format #f "Usage: ~a infile outfile" *program-name*)))
  (match (cdr args)
    [(infile outfile) (make-output-file infile outfile)]
    [_ (usage)])
  0)

(define (make-output-file infile outfile)
  (with-input-from-file infile
    (lambda ()
      (with-output-to-file outfile
        (lambda ()
          (extract-index-data infile))
        :if-exists :append))))

(define (extract-index-data infile)
  (let ((done #f)
        (line "")
        (index-scope-flag #f)
        (href-str (or (values-ref (string-scan-right infile #\/ 'after*) 0)
                      infile)))
    (while (not done)
      (set! line (read-line))
      (cond
       ((eof-object? line)
        (set! done #t))
       ((not index-scope-flag)
        (if (rxmatch #/class="index-/ line)
          (set! index-scope-flag #t)))
       ((rxmatch #/<code>/ line)
        (print (regexp-replace-all*
                line
                #/<a href="/
                (format #f "<a target=\"frame2\" href=\"~a" href-str)
                #/<tr><td><\/td>/
                "<tr>"
                #/<td>&nbsp;<\/td>/
                "")))
       ((or (rxmatch #/<\/table>/ line)
            (rxmatch #/<\/ul>/    line))
        (set! index-scope-flag #f))
       ))
    ))

