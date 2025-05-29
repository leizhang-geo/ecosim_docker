FROM ubuntu:18.04

RUN apt-get update

RUN apt-get install -y build-essential
RUN apt-get install -y gfortran
RUN apt-get install -y g++
RUN apt-get install -y make
RUN apt-get install -y cmake
RUN apt-get install -y gdb
RUN apt-get install -y libtool
RUN apt-get install -y vim
RUN apt-get install -y nano
RUN apt-get install -y git
RUN apt-get install -y curl
RUN apt-get install -y unzip
RUN apt-get install -y zip
RUN apt-get install -y m4
RUN apt-get install -y net-tools
RUN apt-get install -y openssh-server
RUN apt-get install -y libcurl4-openssl-dev
RUN apt-get install -y python3.8 python3.8-dev python3.8-distutils
RUN ln -s /usr/bin/python3.8 /usr/bin/python
RUN curl -sS https://bootstrap.pypa.io/pip/3.8/get-pip.py -o get-pip.py
RUN python get-pip.py
# RUN ln -s /usr/bin/pip3 /usr/bin/pip

RUN pip install fortls
RUN pip install fprettify

ENV CC=gcc
ENV FC=gfortran
ENV CXX=g++

WORKDIR /usr/app/EcoSIM/
COPY ./ ./

ENV NETCDF_DIR="/opt/dev/netcdf_install"

WORKDIR /usr/app/EcoSIM/3rd-partylibs/

# Install zlib
ENV fn_zlib="zlib-1.3.1"
RUN unzip "${fn_zlib}.zip"
WORKDIR /usr/app/EcoSIM/3rd-partylibs/${fn_zlib}/
RUN ./configure --prefix=${NETCDF_DIR}
RUN make
RUN make install
WORKDIR /usr/app/EcoSIM/3rd-partylibs/
RUN rm -rf ${fn_zlib}

# Set environment variables
ENV CPPFLAGS="-I${NETCDF_DIR}/include"
ENV CFLAGS="-I${NETCDF_DIR}/include"
ENV LDFLAGS="-L${NETCDF_DIR}/lib"
ENV LIBS="-L${NETCDF_DIR}/lib"
ENV LD_LIBRARY_PATH="${NETCDF_DIR}/lib"
ENV PKG_CONFIG_PATH="${NETCDF_DIR}/lib/pkgconfig"
ENV PATH="${NETCDF_DIR}/bin:$PATH"

# Install hdf5
WORKDIR /usr/app/EcoSIM/3rd-partylibs/
ENV fn_hdf5="hdf5-1.12.2"
RUN tar -xzf "${fn_hdf5}.tar.gz"
WORKDIR /usr/app/EcoSIM/3rd-partylibs/${fn_hdf5}/
RUN ./configure --prefix=${NETCDF_DIR} --with-zlib=${NETCDF_DIR} --enable-hl --enable-fortran --enable-cxx
RUN make
RUN make install
WORKDIR /usr/app/EcoSIM/3rd-partylibs/
RUN rm -rf ${fn_hdf5}

# Install netcdf-c
WORKDIR /usr/app/EcoSIM/3rd-partylibs/
ENV fn_netcdf_c="netcdf-c-4.7.4"
RUN tar -xzf "${fn_netcdf_c}.tar.gz"
WORKDIR /usr/app/EcoSIM/3rd-partylibs/${fn_netcdf_c}/
RUN CPPFLAGS="-I${NETCDF_DIR}/include" LDFLAGS="-L${NETCDF_DIR}/lib" ./configure --prefix=${NETCDF_DIR} --disable-dap --disable-parallel4 --enable-hdf5 --enable-netcdf-4 --enable-shared=yes
RUN make
RUN make install
WORKDIR /usr/app/EcoSIM/3rd-partylibs/
RUN rm -rf ${fn_netcdf_c}

# ENV LDFLAGS="-L${NETCDF_DIR}/lib -L${NETCDF_DIR}/lib -lnetcdf -lhdf5_hl -lhdf5 -lm -lz"
ENV LDFLAGS="-L${NETCDF_DIR}/lib -L${NETCDF_DIR}/lib -lnetcdf -lhdf5_hl -lhdf5 -lm -ldl -lz"
ENV LIBS="-L${NETCDF_DIR}/lib -L${NETCDF_DIR}/lib -lnetcdf -lhdf5_hl -lhdf5 -lm -ldl -lz"

# Install netcdf-fortran
WORKDIR /usr/app/EcoSIM/3rd-partylibs/
ENV fn_netcdf_fortran="netcdf-fortran-4.5.3"
RUN tar -xzf "${fn_netcdf_fortran}.tar.gz"
WORKDIR /usr/app/EcoSIM/3rd-partylibs/${fn_netcdf_fortran}/
# RUN CPPFLAGS="-I${NETCDF_DIR}/include" LDFLAGS="-L${NETCDF_DIR}/lib -L${NETCDF_DIR}/lib -lnetcdf -lhdf5_hl -lhdf5 -lm -lz" ./configure --prefix=${NETCDF_DIR} --enable-shared=yes
RUN CPPFLAGS="-I${NETCDF_DIR}/include" LIBS="-L${NETCDF_DIR}/lib -L${NETCDF_DIR}/lib -lnetcdf -lhdf5_hl -lhdf5 -lm -ldl -lz" ./configure --prefix=${NETCDF_DIR} --enable-shared=yes
RUN make
RUN make install
WORKDIR /usr/app/EcoSIM/3rd-partylibs/
RUN rm -rf ${fn_netcdf_fortran}

RUN echo "NETCDF_DIR: ${NETCDF_DIR}"
RUN echo "CFLAGS: ${CFLAGS}"
RUN echo "CPPFLAGS: ${CPPFLAGS}"
RUN echo "LDFLAGS: ${LDFLAGS}"
RUN echo "LIBS: ${LIBS}"
RUN echo "LD_LIBRARY_PATH: ${LD_LIBRARY_PATH}"
RUN echo "PKG_CONFIG_PATH: ${PKG_CONFIG_PATH}"
RUN echo "PATH: ${PATH}"

WORKDIR /usr/app/EcoSIM/EcoSIM/

# copy and overwrite updated source files
RUN /bin/cp -rf ../src_update/* ./

# Build and install EcoSIM
RUN bash ./build_EcoSIM.sh

# Copy all runtime files to /usr/local/
WORKDIR /usr/app/EcoSIM/EcoSIM/
RUN cp -r ./build/*/local/* /usr/local/
ENV LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"

WORKDIR /usr/app/EcoSIM/
