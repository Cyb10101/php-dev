#!/usr/bin/env php
<?php
declare(strict_types=1);

$config = [
    'apache' => 'webdevops/php-apache-dev:7.3',
    'apache-7.3' => 'webdevops/php-apache-dev:7.3',
    'apache-7.2' => 'webdevops/php-apache-dev:7.2',
    'apache-7.1' => 'webdevops/php-apache-dev:7.1',
    'apache-7.0' => 'webdevops/php-apache-dev:7.0',
    'apache-5.6' => 'webdevops/php-apache-dev:5.6',

    'nginx' => 'webdevops/php-nginx-dev:7.3',
    'nginx-7.3' => 'webdevops/php-nginx-dev:7.3',
    'nginx-7.2' => 'webdevops/php-nginx-dev:7.2',
    'nginx-7.1' => 'webdevops/php-nginx-dev:7.1',
    'nginx-7.0' => 'webdevops/php-nginx-dev:7.0',
    'nginx-5.6' => 'webdevops/php-nginx-dev:5.6',
];

exec('git checkout master -f && git push');
foreach ($config as $branch => $FROM) {
    exec('git checkout master -f && git reset Dockerfile && git checkout Dockerfile && git checkout -B ' . $branch);
    $dockerfile = file_get_contents('Dockerfile');
    $dockerfile = preg_replace('/^FROM webdevops\/php-apache-dev:\d\.\d$/im', 'FROM ' . $FROM, $dockerfile);
    file_put_contents('Dockerfile', $dockerfile);
    exec('git add Dockerfile && git commit -m \'[BUILD] Set image version to '. $branch . ' with FROM ' . $FROM . '\'');
}
$branches = implode(' ', array_keys($this->config));
exec('git push -f --atomic origin $branches');
exec('git checkout master -f');
