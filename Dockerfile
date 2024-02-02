FROM ruby:3.3.0-alpine3.19

ARG JEKYLL_VERSION=4.3.3

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV TZ=UTC
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US

# Packages needed to get needed gems built
RUN apk --no-cache add \
  build-base \
  libffi-dev \
  libxslt \
  libffi \
  tzdata \
  su-exec \
  libressl \
  shadow

# Update gems
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc && gem update --system

# Install basics to lessen need of providing a Gemfile
RUN gem install bundler jekyll:$JEKYLL_VERSION sass-embedded jekyll-feed jekyll-seo-tag minima

COPY entrypoint.sh /bin/entrypoint

# Explicitly default to 1000:1000
ENV JEKYLL_UID=1000
ENV JEKYLL_GID=1000

RUN addgroup -Sg 1000 jekyll && adduser  -Su 1000 -G jekyll jekyll

RUN rm -rf /usr/local/bundle/cache /root/.gem

CMD ["jekyll", "--help"]
ENTRYPOINT ["/bin/entrypoint"]
WORKDIR /srv/jekyll
VOLUME  /srv/jekyll
EXPOSE 4000
