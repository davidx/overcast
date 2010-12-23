name "search"
description "sphinx search server"

run_list("recipe[base]", "recipe[search]")


# Attributes applied if the node doesn't have it set already.
default_attributes()

# Attributes applied no matter what the node has set already.
#override_attributes()
