FROM alpine:3.22

RUN apk update && apk add --no-cache \
	netdata \
	bash \
	curl \
	util-linux \
	procps \
	iproute2 \
	ca-certificates

RUN mkdir -p /var/cache/netdata \
	/var/lib/netdata \ 
	/var/log/netdata \
	&& chown -R netdata:netdata \
	/var/cache/netdata \
	/var/lib/netdata \
	/var/log/netdata

EXPOSE 19999

USER netdata

CMD ["netdata", "-D"]
