FROM ruby:alpine3.18


ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV TZ=UTC
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US

# Dev packages, unsure if still needed
RUN apk --no-cache add \
  zlib-dev \
  libffi-dev \
  build-base \
  libxml2-dev \
  imagemagick-dev \
  readline-dev \
  libxslt-dev \
  libffi-dev \
  yaml-dev \
  zlib-dev \
  vips-dev \
  vips-tools \
  sqlite-dev \
  cmake

# Prod packages, needs pruning
RUN apk --no-cache add \
  linux-headers \
  less \
  zlib \
  libxml2 \
  readline \
  libxslt \
  libffi \
  git \
  nodejs \
  tzdata \
  shadow \
  bash \
  su-exec \
  npm \
  libressl \
  yarn

# Update gems
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem update --system

# Install basics to lessen need of providing a Gemfile
RUN gem install bundler jekyll sass-embedded jekyll-feed jekyll-seo-tag minima -- \
    --use-system-libraries

COPY entrypoint.sh /bin/entrypoint

# Explicitly default to 1000:1000
ENV JEKYLL_UID=1000
ENV JEKYLL_GID=1000

RUN addgroup -Sg 1000 jekyll
RUN adduser  -Su 1000 -G jekyll jekyll

# RUN mkdir -p "$JEKYLL_VAR_DIR" "$JEKYLL_DATA_DIR"
# RUN chown -R jekyll:jekyll $JEKYLL_DATA_DIR $JEKYLL_VAR_DIR

# These need to be rerouted to default paths
# RUN rm -rf /home/jekyll/.gem
# RUN rm -rf $BUNDLE_HOME/cache
# RUN rm -rf $GEM_HOME/cache
# RUN rm -rf /root/.gem

# Work around rubygems/rubygems#3572
# RUN mkdir -p /usr/gem/cache/bundle
# RUN chown -R jekyll:jekyll \
#   /usr/gem/cache/bundle

CMD ["jekyll", "--help"]
ENTRYPOINT ["/bin/entrypoint"]
WORKDIR /srv/jekyll
VOLUME  /srv/jekyll
EXPOSE 4000
