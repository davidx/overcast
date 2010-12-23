# Overcast - Cloud infrastructure management made easy.
Assign chef roles to ami images through the use of profiles,
grow your clusters and converge configurations with dynamic data from data providers.

DISCLAIMER: this is experimental and may not work for you, please file a ticket or email me with any issues. thx.

## Usage:

- Edit config/cloud.yml to your liking.
- Create an AWS security group for the group defined in the configuration
<pre>cap overcast:deploy
cap overcast:runsolo PROFILE=app</pre>
