#!/usr/bin/bash
# Copyright (c) 2023 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

if [ ! -f $HOME/vz ]; then  
  mkdir vz
  mkdir -p vz/operator vz/clusters vz/oci vz/certs vz/cm

else
  echo "VZ environment already created"
fi