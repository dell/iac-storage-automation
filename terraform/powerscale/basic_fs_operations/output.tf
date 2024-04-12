

# write the details of PS1 to a json file



# output "powerscale_cluster" {
#   value = data.powerscale_cluster.PS1
# }

output "user_group_details" {
  value = data.powerscale_user_group.guests
}

output "user_details" {
  value = powerscale_user.guestUser
  sensitive = true
}
