# c9-homestead: PHP 7.0

This repo holds all the script, config files and commands you might want to
use to set up a laravel homestead equivalent environment on Cloud9 workspaces.

### Prerequisite

Setup a blank c9 workspace.

### Usage

Run any of this commands straightaway on your c9 terminal.

``` bash
curl -L https://raw.githubusercontent.com/Jonnx/c9-homestead/php7.0/install.sh | bash
```
----
``` bash
wget -O - https://raw.githubusercontent.com/Jonnx/c9-homestead/php7.0/install.sh | bash
```

### Cloudstead

After completing this process your environment will be also provisioned with a
simple command to start, stop and restart the whole stack easily:

* `cloudstead start` // Starts NGINX and PHP, MySQL, Postgres, Beanstalkd
* `cloudstead stop`

### Updating

You can re-run this script as many times as you wish, just in case somting is updated.


