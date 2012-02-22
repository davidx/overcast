# Overcast - Cloud infrastructure management made easy.
Assign chef roles to ami images through the use of profiles,
grow your clusters and converge configurations with dynamic data from data providers.

DISCLAIMER: this is experimental, subject to major refactoring and API changes and may not work for you, please file a ticket or email me with any issues and i'll try'n help. thx.

## Usage:

- Edit config/overcast.yml to your liking.
Put in a minimum of something like this:

<pre>
:defaults:
  :image_id: ami-6e2eca07
  :flavor_id: m1.small
  :availability_zone: us-east-1a
  :key_name: bootstrap_hostkey
:profiles:
  :default:
    :groups:
      - default 
    :roles:
      - base
  :app:
    :image_id: ami-6e2eca07
    :flavor_id: m1.small
    :groups:
      - app
    :roles:
      - base
      - app</pre>

- Create an AWS security group for the group defined in the configuration
- Deploy the code
<pre>cap overcast:deploy</pre>
- Converge by running chef cookbooks assigned to role
<pre>cap overcast:runsolo PROFILE=app</pre>
