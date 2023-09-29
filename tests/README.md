<a href="https://elest.io">
  <img src="https://elest.io/images/elestio.svg" alt="elest.io" width="150" height="75">
</a>

[![Discord](https://img.shields.io/static/v1.svg?logo=discord&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=Discord&message=community)](https://discord.gg/4T4JGaMYrD "Get instant assistance and engage in live discussions with both the community and team through our chat feature.")
[![Elestio examples](https://img.shields.io/static/v1.svg?logo=github&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=github&message=open%20source)](https://github.com/elestio-examples "Access the source code for all our repositories by viewing them.")
[![Blog](https://img.shields.io/static/v1.svg?color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=elest.io&message=Blog)](https://blog.elest.io "Latest news about elestio, open source software, and DevOps techniques.")

# Neko, verified and packaged by Elestio

[Neko](https://github.com/m1k1o/neko-rooms) is Simple room management system for n.eko. Self hosted rabb.it alternative.

<img src="https://github.com/elestio-examples/neko/raw/main/neko.png" alt="neko" width="800">

Deploy a <a target="_blank" href="https://elest.io/open-source/neko">fully managed neko</a> on <a target="_blank" href="https://elest.io/">elest.io</a> if you want automated backups, reverse proxy with SSL termination, firewall, automated OS & Software updates, and a team of Linux experts and open source enthusiasts to ensure your services are always safe, and functional.

[![deploy](https://github.com/elestio-examples/neko/raw/main/deploy-on-elestio.png)](https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/neko)

# Why use Elestio images?

- Elestio stays in sync with updates from the original source and quickly releases new versions of this image through our automated processes.
- Elestio images provide timely access to the most recent bug fixes and features.
- Our team performs quality control checks to ensure the products we release meet our high standards.

# Usage

## Git clone

You can deploy it easily with the following command:

    git clone https://github.com/elestio-examples/neko.git

Copy the .env file from tests folder to the project directory

    cp ./tests/.env ./.env

Edit the .env file with your own values.

Run the project with the following command

    docker-compose up -d

You can access the Web UI at: `http://your-domain:7097`

## Docker-compose

Here are some example snippets to help you get started creating a container.

    version: "3.7"

    services:
    traefik:
        image: "traefik:2.4"
        restart: "always"
        environment:
        - "TZ=Europe/Vienna"
        command:
        - "--providers.docker=true"
        - "--providers.docker.watch=true"
        - "--providers.docker.exposedbydefault=false"
        - "--providers.docker.network=neko-rooms-traefik"
        - "--entrypoints.websecure.address=:8080"
        volumes:
        - "/var/run/docker.sock:/var/run/docker.sock:ro"
        ports:
        - "172.17.0.1:7097:8080"

    neko-rooms:
        image: "m1k1o/neko-rooms:${SOFTWARE_VERSION_TAG}"
        restart: "always"
        environment:
        - "TZ=Europe/Vienna"
        - "NEKO_ROOMS_EPR=59000-59049"
        - "NEKO_ROOMS_NAT1TO1=${IP}"
        - "NEKO_ROOMS_TRAEFIK_DOMAIN=${DOMAIN}"
        - "NEKO_ROOMS_TRAEFIK_ENTRYPOINT=websecure"
        - "NEKO_ROOMS_TRAEFIK_NETWORK=neko-rooms-traefik"
        - "NEKO_ROOMS_STORAGE_ENABLED=true"
        - "NEKO_ROOMS_STORAGE_INTERNAL=/data"
        - "NEKO_ROOMS_STORAGE_EXTERNAL=/opt/app/${PIPELINE_NAME}/neko-data"
        volumes:
        - "/var/run/docker.sock:/var/run/docker.sock"
        - ./neko-data:/data
        - ./neko-data:/var/lib/docker
        labels:
        - "traefik.enable=true"
        - "traefik.http.services.neko-rooms-frontend.loadbalancer.server.port=8080"
        - "traefik.http.routers.neko-rooms.entrypoints=websecure"
        - "traefik.http.routers.neko-rooms.rule=Host(`${DOMAIN}`)"


### Environment variables

|       Variable       |  Value (example)   |
| :------------------: | :----------------: |
|    DOMAIN            | https://yourdomain |
|      IP              |    172.17.0.1      |

# Maintenance

## Logging

The Elestio Neko Docker image sends the container logs to stdout. To view the logs, you can use the following command:

    docker-compose logs -f

To stop the stack you can use the following command:

    docker-compose down

## Backup and Restore with Docker Compose

To make backup and restore operations easier, we are using folder volume mounts. You can simply stop your stack with docker-compose down, then backup all the files and subfolders in the folder near the docker-compose.yml file.

Creating a ZIP Archive
For example, if you want to create a ZIP archive, navigate to the folder where you have your docker-compose.yml file and use this command:

    zip -r myarchive.zip .

Restoring from ZIP Archive
To restore from a ZIP archive, unzip the archive into the original folder using the following command:

    unzip myarchive.zip -d /path/to/original/folder

Starting Your Stack
Once your backup is complete, you can start your stack again with the following command:

    docker-compose up -d

That's it! With these simple steps, you can easily backup and restore your data volumes using Docker Compose.

# Links

- <a target="_blank" href="https://github.com/m1k1o/neko-rooms">Neko Github repository</a>

- <a target="_blank" href="https://github.com/elestio-examples/neko">Elestio/neko Github repository</a>
