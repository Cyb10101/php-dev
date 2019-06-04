#!/usr/bin/env php
<?php
declare(strict_types=1);

$config = [
    'apache' => 'pluswerk/php-dev:apache-7.3',
    'apache-7.3' => 'pluswerk/php-dev:apache-7.3',
    'apache-7.2' => 'pluswerk/php-dev:apache-7.2',
    'apache-7.1' => 'pluswerk/php-dev:apache-7.1',
    'apache-7.0' => 'pluswerk/php-dev:apache-7.0',
    'apache-5.6' => 'pluswerk/php-dev:apache-5.6',

    'nginx' => 'pluswerk/php-dev:nginx-7.3',
    'nginx-7.3' => 'pluswerk/php-dev:nginx-7.3',
    'nginx-7.2' => 'pluswerk/php-dev:nginx-7.2',
    'nginx-7.1' => 'pluswerk/php-dev:nginx-7.1',
    'nginx-7.0' => 'pluswerk/php-dev:nginx-7.0',
    'nginx-5.6' => 'pluswerk/php-dev:nginx-5.6',
];

exec('git checkout master -f && git push');
foreach ($config as $branch => $FROM) {
    exec('git checkout master -f && git reset Dockerfile && git checkout Dockerfile && git checkout -B ' . $branch);
    $dockerfile = file_get_contents('Dockerfile');
    $dockerfile = preg_replace('/^FROM pluswerk\/php-dev:apache-\d\.\d$/im', 'FROM ' . $FROM, $dockerfile);
    file_put_contents('Dockerfile', $dockerfile);
    exec('git add Dockerfile && git commit -m \'[BUILD] Set image version to '. $branch . ' with FROM ' . $FROM . '\'');
}
$branches = implode(' ', array_keys($config));
exec('git push -f --atomic origin ' . $branches);
exec('git checkout master -f');
