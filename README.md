# DavMail Dockerized

[![Build Status][badge_build_status]][link_docker_tags] [![Docker Version][badge_docker_semver]][link_docker_tags]

[DavMail][link_davmail_home] is a POP/IMAP/SMTP/Caldav/Carddav/LDAP gateway for Microsoft Exchange. This Dockerized version simplifies building, installing, running, and upgrading DavMail.

For more information, code, and support, visit the [official DavMail website][link_davmail_home].

---

## What is DavMail?

DavMail is a gateway that allows you to use standard email clients (like Thunderbird or Outlook) to access Microsoft Exchange services. This Docker image provides an easy way to deploy and manage DavMail in a containerized environment.

---

## How to Run

### Using Docker Compose

1. Review the [DavMail configuration examples and references](http://davmail.sourceforge.net/serversetup.html).
2. Edit the `docker-compose.yaml` file to set your desired environment variables.
3. Start the service:

   ```bash
   docker-compose up -d
   ```

   To stop the service:

   ```bash
   docker-compose down
   ```

**Note:** The entrypoint script stores persistent configuration data in the `davmail-config` volume. If this volume is deleted, some configuration data may be lost. To disable persistence, set `DISABLE_DAVMAIL_PROPERTIES_PERSISTENCE=true`.

---

### Using Docker Run

To run DavMail with Docker:

```bash
docker run -it --rm \
  -e DAVMAIL_SERVER=true \
  -p 1025:1025 \
  -p 1110:1110 \
  kran0/davmail-docker:latest
```

This command publishes ports `1025` (SMTP) and `1110` (POP) and uses a single environment variable. For more configuration options, refer to the examples in [`docker-compose.yaml`](docker-compose.yaml) and [`tests/compose-sut.yaml`](tests/compose-sut.yaml), as well as the [official DavMail documentation](http://davmail.sourceforge.net/serversetup.html).

---

#### Using a Text-Based Configuration File

To use a traditional text-based configuration file, mount it as a volume and pass it as a command:

```bash
docker run -it --rm \
  -v $PWD/conf/davmail.properties.example:/davmail/davmail.properties \
  -p 1025:1025 \
  -p 1110:1110 \
  kran0/davmail-docker:latest /davmail/davmail.properties
```

---

### Deploying to Kubernetes

To deploy DavMail in a Kubernetes cluster, use the provided manifest:

```bash
kubectl create -f k8s-pod.yaml
```

---

## Docker Tags

| Repository:Tag                  | Description           |
|---------------------------------|-----------------------|
| `kran0/davmail-docker:latest`   | Latest stable release |
| `kran0/davmail-docker:x.y.z`    | Stable releases following semantic versioning [![Docker Version][badge_docker_semver]][link_docker_tags] |
| `kran0/davmail-docker:trunk`    | Trunk and test builds from the latest SVN repository HEAD. **May be unstable!** |

---

## Links

- [DavMail Homepage][link_davmail_home]
- [Docker Hub Tags][link_docker_tags]

---

[badge_build_status]: https://github.com/kran0/davmail-docker/actions/workflows/build_images.yml/badge.svg
[badge_docker_semver]: https://img.shields.io/docker/v/kran0/davmail-docker?sort=semver&style=social&cacheSeconds=3600
[link_docker_tags]: https://hub.docker.com/r/kran0/davmail-docker/tags?page=1&ordering=last_updated
[link_davmail_home]: http://davmail.sourceforge.net/
