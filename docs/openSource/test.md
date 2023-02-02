# test

**fff**

```bash
 docker run -it --rm     
--volume /var/run/docker.sock:/var/run/docker.sock     
--volume "$(pwd)"/appwrite:/usr/src/code/appwrite:rw     
--entrypoint="install"     
appwrite/appwrite:0.15.3

```