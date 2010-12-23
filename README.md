== Overcast - Cloud infrastructure management made easy.
Assign chef roles to ami images through the use of profiles,
grow your clusters and converge configurations with dynamic data from data providers.


DISCLAIMER: this may not work for you, please file a ticket or email me with any issues. thx.

Usage:

    edit config/cloud.yml
    create AWS security groups for each profile that are listed in config
    cap overcast:deploy
    cap overcast:runsolo PROFILE=app ROLE=app
