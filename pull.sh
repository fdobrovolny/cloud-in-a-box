#!/usr/bin/env bash

set -x
set -e

export INTERACTIVE=false

kolla_services=(
barbican
cinder
common
designate
glance
grafana
heat
horizon
keystone
loadbalancer
mariadb
memcached
neutron
nova
octavia
opensearch
openvswitch
ovn
placement
rabbitmq
redis
)

for kolla_service in ${kolla_services[*]}; do
    osism apply --no-wait -a pull $kolla_service
done

osism apply --no-wait -e custom pull-container-images
