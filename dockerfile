FROM bitnami/odoo:9.0.20170115-r0

RUN apt-get update
RUN apt-get --assume-yes install python-dev
RUN apt-get --assume-yes install gcc
RUN apt-get --assume-yes install node-less

RUN /bin/bash -c "source /opt/bitnami/odoo/venv/bin/activate \
    && pip install pycrypto \
    && pip install openpyxl==2.5 \
    && pip install xlsxwriter \
    && pip install xmltodict \
    && pip install xlrd \
    && pip install mammoth \
    && pip install certifi \
    && pip install simplejson \
    && deactivate"

COPY ./addons /pappaya/addons
COPY ./config/openerp-server.conf.tpl /root/.nami/components/com.bitnami.odoo/templates/openerp-server.conf.tpl
COPY ./scripts/app-entrypoint.sh /app-entrypoint.sh
COPY ./scripts/init-odoo.sh /init-odoo.sh
RUN chmod +x app-entrypoint.sh init-odoo.sh

CMD ["nami", "start", "--foreground", "odoo"]