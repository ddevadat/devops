#!/bin/bash

script_path=$(pwd)
inventory_path=${script_path}/../../inventory/env/dev/
ansible-playbook -i ${inventory_path}/hosts 01_test.yaml