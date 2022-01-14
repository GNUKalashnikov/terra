echo -e "[app]\n$(terraform output app_ip) ansible_user=ubuntu" | sed 's/"//g' > hosts.inv
echo -e "[db]\n$(terraform output db_ip) ansible_user=ubuntu"  | sed 's/"//g' >> hosts.inv
