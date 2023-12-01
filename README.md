# Pappaya ERP with Odoo 9 build (9.0.20170115-r0)

Uses bitnami odoo docker base image as start to make it work with helm charts.

## Development
1. Use docker compose to run local instance for development.
1. Run ```docker-compose up```
1. Additional modules are mounted in separate folder but the odoo config will not include by default.
1. To include it run ```docker exec -it erp-core_web_1 sed -i 's+/opt/bitnami/odoo/openerp/addons$+/opt/bitnami/odoo/openerp/addons,/bitnami/odoo/addons+g' /bitnami/odoo/openerp-server.conf``` with the appropriate container name instead of ```erp-core_web_1```.
1. Restart container to have the updated config.

## Build
To make a docker image with custom addons included:

1. Run ```docker build -t registry.pappayacloud.com:5000/pappayalite:0.0.1 .```
1. Push the docker image ```docker push registry.pappayacloud.com:5000/pappayalite:0.0.1```

## Local view
To run the build locall with database, use docker compose command ```docker-compose up``` which will start both the odoo build and postgres and create a default user account as below:

```
Username: user@pappaya.com
Password: pappaya
```

## Control odoo process in build

### To start or stop odoo process
Find the docker container id for odoo by running ```docker ps -a``` and run ```docker exec -it <container_id> bash``` which will take you to the containers bash. Run the following in there:

* START: ```nami start odoo```
* STOP: ```nami stop odoo```
* RESTART: ```nami restart odoo```

### Run module install commands in instance
1. Get into container bash as mentioned above.
1. Stop odoo service ```nami stop odoo```
1. Switch to user "odoo" ```sudo su odoo```
1. Go to folder ```cd /opt/bitnami/odoo```
1. Run ```/opt/bitnami/odoo/venv/bin/python openerp-server --config openerp-server.conf --stop-after-init -i pappaya_autoinstall -u pappaya_core &``` to install pappaya_autoinstall and update pappaya_core module.
1. Can run other install or update calls similarly.
1. Exit odoo user.
1. Start odoo service again ```nami start odoo```

## Troubleshoot

### Docker build error
Latest docker version has porblem with older odoo 9 image so if you get error during build then try ```DOCKER_BUILDKIT=0 docker build``` or ```DOCKER_BUILDKIT=0 docker-compose up``` appropriately.