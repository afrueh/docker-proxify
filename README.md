Docker-proxify
==============

Provides a docker in docker container in which the inner containers' traffic is transparently proxied over one or more proxy servers. Uses [redsocks](https://github.com/wtsi-hgi/redsocks) and supports standard HTTP (http\_proxy) and HTTP CONNECT (https\_proxy) proxies.

By default the docker-proxify container will route port 80 over the specified HTTP proxy and port 443 over the specified CONNECT proxy, on the `docker0` interface only. The docker-proxify container can access network directly.

Default proxy address is 127.0.0.1:8000 for both HTTP and HTTP CONNECT proxies.

Usage
-----
Because the docker daemon is run inside the container, you need to run it with the `--privileged` flag.

The entrypoint defaults to an interactive bash shell from which docker can be accessed:
```bash
$ docker run -it --privileged multipl/docker-proxify
```

Or you can extend the image itself and create a custom image. (For example to add the proxy setup.)
```dockerfile
FROM multipl/docker-proxify:latest
```

