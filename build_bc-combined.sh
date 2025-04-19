#!/bin/bash

docker build --platform linux/amd64 --tag buttonscodes/bc-combined:1.0.0 -f ./official-templates/bc-combined/Dockerfile .