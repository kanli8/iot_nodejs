#
https://www.howtoforge.com/how-to-install-supabase-on-debian-11/

#ssl
certbot certonly --standalone --agree-tos --no-eff-email --staple-ocsp --preferred-challenges http -m pankecai@ankemao.com -d supabase.ankemao.com

#!/bin/sh
certbot renew --cert-name supabase.ankemao.com --webroot -w /var/lib/letsencrypt/ --post-hook "systemctl reload nginx"

# nginx
# 
apt-get install apache2-utils
htpasswd -c /etc/nginx/.htpasswd supabase
supa_lklk





docker compose exec appwrite ssl domain="appwrite.ankemao.com"
