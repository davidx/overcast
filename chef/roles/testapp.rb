name "testapp"
description "testapp role"
run_list(["recipe[ruby_custom]"])

# Attributes applied no matter what the node has set already.
#override_attributes()
