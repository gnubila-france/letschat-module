# letschat

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with letschat](#setup)
    * [What letschat affects](#what-letschat-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with letschat](#beginning-with-letschat)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module deploys a self-hosted chat app for small teams, [Let's Chat](http://sdelements.github.io/lets-chat/).

![Screenshot of application](http://sdelements.github.io/lets-chat/assets/img/devices.png)

*This module has only been tested on CentOS 6, but should function without issues on CentOS/RHEL 5 & 6.*

## Module Description
The **letschat** module simplifies the configuration and deployment process of [Let's Chat](http://sdelements.github.io/lets-chat/), 
by managing configuration for both the web application and the backend. This chat service is ideal for users who would like to host their own chat application that is hosted internally
or hosted externally, or can be used simply in a scorched earth scenario, where one's normal hosted chat application
is not accessible.

This module helps simplify the configuration of MongoDB, allowing the user to create a new database, the user account for
the web application to access the database, and configure the Node.js web application to suit the users needs by exposing most of the available
configuration found in the [Let's Chat Configuration Reference](https://github.com/sdelements/lets-chat/wiki/Configuration).


## Setup

### What letschat affects

* Creates letschat service: /etc/init.d/letschat
* MongoDB (2.6+) server and client packages and services
* Python (2.7.x) packages as required by node-gyp
* The Let's Chat Node.js Application and associated configuration
* The installation of Node.js (0.10+) and npm packages and dependencies 


### Beginning with letschat

To install letschat with default parameters

```
class letschat { }
```
*Please note that this install the web application and the database on the same
host*

To install and configure MongoDB backend with default parameters on a node:

```
class letschat::db {}
```

To install and configure just the letschat Node.js application with default parameters on a node:

```
class letschat::app {}
```

### Configuring MongoDB
To configure MongoDB and create a new database:
```
class { 'letschat::db':
  user          => 'lcadmin',
  pass          => 'unsafepassword',
  bind_ip       => '0.0.0.0',
  database_name => 'letschat',
  database_port => '27017',
}
```

### Configuring letschat
To configure Let's Chat and specify database settings:
```
class { 'letschat::app':
    dbuser          => 'lcadmin',
    dbpass          => 'unsafepassword',
    dbname          => 'letschat',
    dbhost          => 'dbserver0',
    dbport          => '27017',
    cookie          => 'thistest',
    deploy_dir      => '/etc/letschat',
    http_enabled    => true,
    lc_bind_address => '0.0.0.0',
    http_port       => '5000',
    ssl_enabled     => false,
    cookie          => 'secret',
    authproviders   => 'local',
    registration    => true,
}
```

## Usage

Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

This is where you list OS compatibility, version compatibility, etc.

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

## Release Notes/Contributors/Etc **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You may also add any additional sections you feel are
necessary or important to include here. Please use the `## ` header
