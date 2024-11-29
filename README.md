# EcoSIM installation

## Configure and install 3rd-party libraries

- Set an environment variable `NETCDF_DIR` (e.g., `/opt/dev/netcdf_install`).

- Install all libs in this directory: `${NETCDF_DIR}`.

### Configure options
- zlib:

    ```./configure --prefix=${NETCDF_DIR}```

- curl:

    ```./configure --prefix=${NETCDF_DIR} --without-ssl --without-zlib```

- hdf5:

    ```./configure --prefix=${NETCDF_DIR} --with-zlib=${NETCDF_DIR} --enable-hl --enable-fortran --enable-cxx [--disable-shared] [--enable-build-mode=debug]```
 
- netcdf-c:

    ```CPPFLAGS="-I${NETCDF_DIR}/include" LDFLAGS="-L${NETCDF_DIR}/lib" ./configure --prefix=${NETCDF_DIR} --disable-dap --disable-parallel4 --enable-hdf5 --enable-netcdf-4 --enable-shared=yes```

- netcdf-fortran:

    ```CPPFLAGS="-I${NETCDF_DIR}/include" LIBS="-L${NETCDF_DIR}/lib -L${NETCDF_DIR}/lib -lnetcdf -lhdf5_hl -lhdf5 -lm -ldl -lz" ./configure --prefix=${NETCDF_DIR} --enable-shared=yes```

### Set environment variables

```shell
export NETCDF_DIR="/opt/dev/netcdf_install"
export CPPFLAGS "-I${NETCDF_DIR}/include"
export CFLAGS "-I${NETCDF_DIR}/include"
# export LDFLAGS "-L${NETCDF_DIR}/lib"
export LDFLAGS="-L${NETCDF_DIR}/lib -L${NETCDF_DIR}/lib -lnetcdf -lhdf5_hl -lhdf5 -lm -ldl -lz"
export LIBS="-L${NETCDF_DIR}/lib -L${NETCDF_DIR}/lib -lnetcdf -lhdf5_hl -lhdf5 -lm -ldl -lz"
export LD_LIBRARY_PATH "${NETCDF_DIR}/lib"
export PKG_CONFIG_PATH "${NETCDF_DIR}/lib/pkgconfig"
export PATH="${NETCDF_DIR}/bin:$PATH"
```

### Libs' version

- zlib: **1.3.1**
    ```shell
    wget https://github.com/madler/zlib/releases/download/v1.3.1/zlib131.zip
    ```

- hdf5: **1.12.2**
    ```shell
    wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.2/src/hdf5-1.12.2.tar.gz
    ```

- netcdf-c: **4.7.4**
    ```
    wget https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.7.4.tar.gz
    ```
- netcdf-fortran: **4.5.3**
    ```
    wget https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.5.3.tar.gz
    ```

## Build EcoSIM

- Check the codes in `Dockerfile`.

- Build the docker image.
    ```shell
    [sudo] docker build --no-cache -t ecosim-docker .
    ```
    *Note: --platform=linux/amd64 or --platform=linux/arm64*

- Run and access an ecosim-docker container.
    ```shell
    docker container run --name=container-ecosim -it ecosim-docker bash
    ```

- We can also run an ecosim-docker container with usage of a bind mount, a directory on the host machine is mounted into the container.
    ```shell
    docker run -it --mount type=bind,source=<path/to/a/directory/in/host/machine>,target=<path/to/a/directory/in/docker/container> ecosim-docker bash
    ```

- The installed executable file: `ecosim.f90.x` has a copy in `/usr/local/bin/`, so you can directly enter `ecosim.f90.x` in the terminal to run the model.

- Edit the source codes by your requirements, and then re-build and install EcoSIM in the docker container.

- Run the model using an example dataset:

    - Go to the directory: `.../EcoSIM/examples/run_dir/sample/`, and enter:
        ```shell
        ecosim.f90.x ./sample.namelist
        ```
    
    - Then check model outputs in the folder

## Other useful docker commands

- Start a container
    ```shell
    docker start <container_name or container_id>
    ```

- Enter a running container
    ```shell
    docker exec -it <container_name or container_id> /bin/bash
    
    docker attach <container_name or container_id>
    ```

- Check all images
    ```shell
    docker images

    docker image ls
    ```

- Check all containers
    ```shell
    docker container ls

    docker ps
    ```

- Stop and remove a container
    ```shell
    docker stop <container_name or container_id>
    docker rm <container_name or container_id>

    # for all containers
    docker stop $(docker ps -aq)
    docker rm $(docker ps -aq)
    ```

## Contact

For questions and more details of our study please contact the author: Lei Zhang 张磊 (lei.zhang@lbl.gov)

[https://leizhang-geo.github.io](https://leizhang-geo.github.io)
