cat /var/log/apache2/access.log | cut -d[ -f2 | cut -d] -f1 | uniq -c
