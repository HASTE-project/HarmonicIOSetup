#!/usr/bin/env bash

for i in {1..10}; do curl -X POST "http://hio-worker-prod-0-${i}:8888/docker?token=None&command=create" --data '{"c_name" : "benblamey/haste-image-proc:latest", "num" : 1}'; done
