FROM nikolaik/python-nodejs

COPY entrypoint.sh /entrypoint.sh
COPY generate_db_schema_documentation.py /generate_db_schema_documentation.py
COPY package.json /package.json
COPY package-lock.json /package-lock.json

# NPM needs this
ENV CI=true

RUN chmod +x /entrypoint.sh && \
    chmod +x /generate_db_schema_documentation.py && \
    npm install

ENTRYPOINT ["/entrypoint.sh"]
