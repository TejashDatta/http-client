cat /var/log/apache2/access.log | cut -d[ -f2 | cut -d] -f1 | uniq -c | awk '{ total += $1; count++ } END { print total/count }'

# 秒間処理リクエスト数: 185.449
