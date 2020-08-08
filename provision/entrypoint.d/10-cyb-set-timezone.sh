#!/usr/bin/env sh

if [[ -n "${PHP_DATE_TIMEZONE+x}" ]]; then
  export DATE_TIMEZONE=${PHP_DATE_TIMEZONE}
fi

export PHP_DATE_TIMEZONE=${DATE_TIMEZONE}

echo ${PHP_DATE_TIMEZONE} >/etc/timezone
ln -sf /usr/share/zoneinfo/${PHP_DATE_TIMEZONE} /etc/localtime
dpkg-reconfigure -f noninteractive tzdata &> /dev/null
