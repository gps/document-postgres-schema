FROM nikolaik/python-nodejs

COPY entrypoint.sh /entrypoint.sh
COPY requirements.txt /requirements.txt
COPY generate_db_schema_documentation.py /generate_db_schema_documentation.py
COPY package.json /package.json
COPY package-lock.json /package-lock.json

# NPM needs this
ENV CI=true

COPY ./ /usr/app
WORKDIR /usr/app

RUN chmod +x entrypoint.sh && \
    chmod +x generate_db_schema_documentation.py && \
    pip3 install -r requirements.txt && \
    npm install

ENTRYPOINT ["/entrypoint.sh"]
