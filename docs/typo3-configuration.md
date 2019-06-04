# TYPO3 configuration

For TYPO3 >= 8

## TYPO3 AdditionalConfiguration.php example 1

```php
<?php
if ($_SERVER['TYPO3_CONTEXT'] === 'Development/docker') {
    $GLOBALS['TYPO3_CONF_VARS']['MAIL']['transport'] = 'mail';
    $GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['host'] = getenv('typo3DatabaseHost') ?: 'global-db';
    $GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['port'] = getenv('typo3DatabasePort') ?: '3306';
    $GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['user'] = getenv('typo3DatabaseUsername') ?: 'root';
    $GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['password'] = getenv('typo3DatabasePassword') ?: 'root';
    $GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['dbname'] = getenv('typo3DatabaseName') ?: 'default_database';

    // If you have a special domain
    $vmNumber = getenv('VM_NUMBER');
    if (!preg_match('/\d+/', $vmNumber)) {
        throw new \Exception('env VM_NUMBER needed! it must be an int!');
    }
    $GLOBALS['TYPO3_CONF_VARS']['EXTCONF']['xyz_search']['domainA'] = sprintf('project.vm%d.example.org', $vmNumber);
    $GLOBALS['TYPO3_CONF_VARS']['EXTCONF']['xyz_search']['domainB'] = sprintf('en.project.vm%d.example.org', $vmNumber);
}
```

## TYPO3 AdditionalConfiguration.php example 2

### TYPO3 database configuration

Configure as environment variable:

```bash
DATABASE_URL=mysql://global-db
DATABASE_URL=mysql://global-db/database_name
DATABASE_URL=mysql://username:password@127.0.0.1:3306/database_name
```

Add php code in additional configuration:

```php
<?php
if (isset($_SERVER['TYPO3_CONTEXT']) && $_SERVER['TYPO3_CONTEXT'] === 'Development/Docker') {
    // Configure database
    $configDatabase = parse_url(getenv('DATABASE_URL'));
    $GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['host'] = isset($configDatabase['host']) ? $configDatabase['host'] : 'global-db';
    $GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['port'] = isset($configDatabase['port']) ? $configDatabase['port'] : '3306';
    $GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['user'] = isset($configDatabase['user']) ? $configDatabase['user'] : 'root';
    $GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['password'] = isset($configDatabase['pass']) ? $configDatabase['pass'] : 'root';
    if (isset($configDatabase['path']) && trim($configDatabase['path'], '/') !== '') {
        $GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['dbname'] = trim($configDatabase['path'], '/');
    }
}
```

### TYPO3 mail configuration

Configure as environment variable:

```bash
MAILER_URL=sendmail://localhost/home/user/go/bin/mhsendmail

MAILER_URL=smtp://global-mail:1025
MAILER_URL=smtp://username:passwort@smtp.example.org:25
MAILER_URL=smtp://info@example.org:passwort@smtp.gmail.com?encryption=tls
```

Add php code in additional configuration:

```php
<?php
if (isset($_SERVER['TYPO3_CONTEXT']) && $_SERVER['TYPO3_CONTEXT'] === 'Development/Docker') {
    // Configure mail
    $configMail = parse_url(getenv('MAILER_URL'));
    if (isset($configMail['scheme'])) {
        $configMailQuery = [];
        if (isset($configMail['query'])) {
            parse_str($configMail['query'], $configMailQuery);
        }

        if ($configMail['scheme'] === 'sendmail') {
            $GLOBALS['TYPO3_CONF_VARS']['MAIL']['transport'] = 'sendmail';
            $GLOBALS['TYPO3_CONF_VARS']['MAIL']['transport_sendmail_command'] = isset($configMail['path']) ? $configMail['path'] : '/home/user/go/bin/mhsendmail';
        } else if ($configMail['scheme'] === 'smtp') {
            $GLOBALS['TYPO3_CONF_VARS']['MAIL']['transport'] = 'smtp';
            $GLOBALS['TYPO3_CONF_VARS']['MAIL']['transport_smtp_encrypt'] = isset($configMailQuery['encryption']) ? $configMailQuery['encryption'] : '';
            $GLOBALS['TYPO3_CONF_VARS']['MAIL']['transport_smtp_password'] = isset($configMail['pass']) ? $configMail['pass'] : '';
            $GLOBALS['TYPO3_CONF_VARS']['MAIL']['transport_smtp_username'] = isset($configMail['user']) ? $configMail['user'] : '';

            $mailServer = isset($configMail['host']) ? $configMail['host'] : '';
            if (isset($configMail['port'])) {
                $mailServer .= ':' . $configMail['port'];
            }
            $GLOBALS['TYPO3_CONF_VARS']['MAIL']['transport_smtp_server'] = $mailServer;
        }
    }
}
```

