# c9-homestead: PHP 5.6

This repo holds all the script, config files and commands you might want to
use to set up a laravel homestead equivalent environment on Cloud9 workspaces.

### Prerequisite

Setup a blank c9 workspace.

### Usage

Run any of this commands straightaway on your c9 terminal.

``` bash
curl -L https://raw.githubusercontent.com/Jonnx/c9-homestead/php5.6/install.sh | bash
```
----
``` bash
wget -O - https://raw.githubusercontent.com/Jonnx/c9-homestead/php5.6/install.sh | bash
```

After completing this process your environment will be also provisioned with a
simple command to start, stop and restart the whole stack in a brief:

* `cloudstead start` // Starts NGINX and PHP, MySQL, Postgres, Beanstalkd
* `cloudstead stop`

### Updating

You can re-run this script as many times as you wish, just in case somting is updated.


### Considerations

This is a quite simple script. It is just an easy way to configure your environment
to be up and running with NGINX and PHP-FPM.

It does not override the default NGINX site configuration file, so you don't have to
worry about loosing any data in case you had already modified yours.
