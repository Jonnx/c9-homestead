# c9-homestead

This project offers a simple build script that allows you to configure
a c9.io workspace to run a similar configuration to the Laravel Homestead environment.

## PHP 5.6 vs PHP 7.0
To allow people to develop on the two main versions of PHP the following two branches
will allow you to choose PHP 5.6 or 7.0. This is helpful when your project depends on
PHP 5.6 (using SDKs from Salesforce, Quickbooks, ...)

* [https://github.com/Jonnx/c9-homestead/tree/php5.6](https://github.com/Jonnx/c9-homestead/tree/php5.6)
* [https://github.com/Jonnx/c9-homestead/tree/php7.0](https://github.com/Jonnx/c9-homestead/tree/php7.0)
* [https://github.com/Jonnx/c9-homestead/tree/php7.1](https://github.com/Jonnx/c9-homestead/tree/php7.1)

### Thanks
Special thanks goes to GabrielGil, who did most of the heavy lifting by doing the ground work with the [c9-lemp](https://github.com/GabrielGil/c9-lemp) install script that c9-homestead is built off of. Even the utility from the c9-lemp project was ported over, adjusted and renamed to cloudstead