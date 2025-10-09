# Build container image - test github actions
FROM alpine AS cmatrixbuilder

WORKDIR /cmatrix

# Install dependencies, clone the repository, and build cmatrix
RUN apk update --no-cache && \
    apk add git autoconf automake alpine-sdk ncurses-dev ncurses-static && \
    git clone https://github.com/spurin/cmatrix . && \
    autoreconf -i && \
    mkdir -p /usr/lib/kbd/consolefonts /usr/share/consolefonts && \
    ./configure LDFLAGS="-static" && \
    make

# cmatrix Container image

FROM alpine


# Install runtime dependencies and copy the built binary
RUN apk update --no-cache && \
apk add ncurses-terminfo-base && \
adduser -g "psyunix" -s /user/sbin/nologin -D -H  psyunix 

USER psyunix

COPY --from=cmatrixbuilder /cmatrix/cmatrix /cmatrix

ENTRYPOINT [ "./cmatrix" ]

# Set the default command to run cmatrix - test

CMD ["sh"]