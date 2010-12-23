name "app"
description "app role"
run_list(["recipe[base]"])

# Attributes applied no matter what the node has set already.
#override_attributes()
