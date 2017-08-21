# Set default WWW_DATA_USERID if not exist
# password is limited by 8 characters
: ${WWW_DATA_USERID:=33}

usermod -u $WWW_DATA_USERID www-data
groupmod -g $WWW_DATA_USERID www-data

chown -R www-data:www-data /var/www/html

exec "$@"