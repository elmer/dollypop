# Project DollyPop

Puppet Manifest for Application Testing.

## Stacks
The following are the list of stacks currently implemented on this manifest.

1. **DATABASE** - a PostgreSQL implemented database server
2. **LAMP** - Linux/Apache/MySQL/PHP rather PostgreSQL
3. **RAILS** - Ruby On Rails

## Applications
Current list of working applications on specific stack.

1. **Drupal on LAMP** - Install the Drupal Application, It needs the **DATABASE** stack for its database server.
2. **Redmine on RAILS** - Install Redmine 2.1.0, also uses **DATABASE** as its external data source.
3. _more_to_follow_


### Usage

The following basic guide will not cover setting up security groups for each instances. It assumes the database server is open to all VMS and the applications can be reach via __HTTP__ or __HTTPS__. 

The prerequesites of all the installation procedure is the installation of __Puppet__ on all nodes. 

**Tested on Ubuntu 12.04 Precise**


#### Intalling the Database Server using _DATABASE_ Stack

1. Create the fact file

        root@vm:~# mkdir -p /etc/facter/facts.d
        root@vm:~# vi /etc/facter/facts.d/node.yaml
        
    Contents of node.yaml
        
        ---
        node: database
        databases: drupal,redmine,otherdb
        database_drupal_user: drupaluser
        database_drupal_password: droopal
        database_drupal_dump: drupal1
        database_redmine_user: redmine
        database_redmine_password: secret
        database_otherdb_user: user1
        database_otherdb_password: password123
        
   
2. Install required applications and clone the repo.
 
        root@vm:~# apt-get update
        root@vm:~# apt-get -y install puppet git
        root@vm:~# git clone https://username@bitbucket.org/erivera/dollypop.git
        root@vm:~# cd dollypop
        root@vm:~# puppet apply --modulepath modules manifests/site.pp

#### Installing Drupal Application using _LAMP_ Stack

Nothing here yet...

## Contributing

1. Fork it
2. Create your feature branch (```git checkout -b my-new-feature```)
3. Commit your changes (```git commit -am 'Add some feature'```)
4. Push to the branch (```git push origin my-new-feature```)
5. Create new Pull Request
