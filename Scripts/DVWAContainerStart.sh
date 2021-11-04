#!/bin/bash

#Created by Kelly Clemmensen

#Web Servers
ssh azadmin@10.2.0.5 "sudo docker start dvwa"
ssh azadmin@10.2.0.6 "sudo docker start dvwa"
ssh azadmin@10.2.0.7 "sudo docker start dvwa"