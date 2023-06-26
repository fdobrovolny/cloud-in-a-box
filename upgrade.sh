#!/usr/bin/env bash

export INTERACTIVE=false

wait_for_container_healthy() {
    local max_attempts="$1"
    local name="$2"
    local attempt_num=1

    until [[ "$(/usr/bin/docker inspect -f '{{.State.Health.Status}}' $name)" == "healthy" ]]; do
        if (( attempt_num++ == max_attempts )); then
            return 1
        else
            sleep 5
        fi
    done
}

osism-update-manager

osism apply traefik
osism apply netbox

osism reconciler sync
osism apply facts

osism apply -a upgrade common
osism apply -a upgrade loadbalancer
osism apply -a upgrade opensearch
osism apply -a upgrade openvswitch
osism apply -a upgrade ovn
osism apply -a upgrade memcached
osism apply -a upgrade redis
osism apply -a upgrade mariadb
osism apply -a upgrade rabbitmq

# TASK [fail when less than three monitors] **************************************
# fatal: [manager.systems.in-a-box.cloud]: FAILED! => {"changed": false, "msg": "Upgrade
# of cluster with less than three monitors is not supported."}
# osism apply ceph-rolling_update -e ireallymeanit=yes
# osism apply cephclient

osism apply -a upgrade keystone
osism apply -a upgrade horizon
osism apply -a upgrade placement
osism apply -a upgrade glance
osism apply -a upgrade neutron
osism apply -a upgrade nova
osism apply -a upgrade cinder
osism apply -a upgrade designate
osism apply -a upgrade barbican
osism apply -a upgrade octavia

osism apply -a upgrade grafana
osism apply homer
osism apply netdata
osism apply openstackclient
osism apply phpmyadmin
