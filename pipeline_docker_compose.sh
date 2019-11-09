#!/bin/bash
set -e

docker-compose rm -f && docker-compose up --build && docker-compose run --rm mytest && docker-compose push

echo "GREEN" || echo "RED"