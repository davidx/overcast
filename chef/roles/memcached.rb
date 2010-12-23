name "memcached"
description "app role"
run_list(["recipe[base]", "recipe[memcached]"])