data "powerscale_user_group" "guests" {
  filter {
    # Optional list of names to filter upon
    names = [
      # {
      #   gid = 0
      # },
      # {
      #   name = "Administrators"
      # },
      {
        name = "Guests"
        # gid  = 1546
      }
    ]

    # Optional query parameters.
    cached      = false
    # name_prefix = "tfacc"
    # domain = "testDomain"
    # zone = "testZone"
    # provider = "testProvider"
  }
}

resource "powerscale_user" "guestUser" {
  # Required name for creating
  name = "tf-guest"

  
  # Optional parameters when creating
  # sid = "SID:XXXX"

  # Optional parameters when creating and updating. 
  # uid      = 11000
  # password = "testPassword"
  # roles    = ["SystemAdmin"]
  # enabled = false
  # unlock = false
  # email = "testTerraform@dell.com"
  # home_directory = "/ifs/home/testUserResourceSample"
  # password_expires = true
  primary_group = data.powerscale_user_group.guests.user_groups[0].name
  # prompt_password_change = false
  # shell = "/bin/zsh"
  # expiry = 123456
  # gecos = "testFullName"
}

resource "powerscale_filesystem" "file_system_test" {
  
  # Default set to '/ifs'
  # directory_path         = "/ifs"

  # Required attributes
  name = var.filesystem_name
  group = {
    id   = data.powerscale_user_group.guests.user_groups[0].gid
    name = data.powerscale_user_group.guests.user_groups[0].name
    type = "group"
  }
  owner = {
    id   = "UID:${powerscale_user.guestUser.uid}",
    name = powerscale_user.guestUser.name,
    type = "user"
  }

  # Optional : query_zone, this will default to the default access zone if unset. However is needed if the user trying to be created is not in the default access zone.connection {
  # This should just be the access zone name. 
  # query_zone = "test_access_zone"

  # Optional attributes. Default values set.
  # Creates intermediate folders recursively, when set to true.
  recursive = true
  # Deletes and replaces the existing user attributes and ACLs of the directory with user-specified attributes and ACLS, when set to true.
  overwrite = false


  /* Optional : The ACL value for the directory. Users can either provide access rights input such as 'private_read' , 'private' ,
    'public_read', 'public_read_write', 'public' or permissions in POSIX format as '0550', '0770', '0775','0777' or 0700. The Default value is (0700). 
     Modification of ACL is only supported from POSIX to POSIX mode. 
  */

  # access_control = "0777"
}

resource "powerscale_nfs_export" "example_export" {
  depends_on = [ powerscale_filesystem.file_system_test ]
  # Required path for creating
  #concatenate "/ifs/" with the filesystem name



  paths = ["/ifs/${powerscale_filesystem.file_system_test.name}"]
  # you can see an example of optional parameters here https://github.com/dell/terraform-provider-powerscale/blob/main/examples/resources/powerscale_nfs_export/resource.tf
  }

resource "powerscale_snapshot" "snap" {
depends_on = [ powerscale_filesystem.file_system_test ]
  # Required path to the filesystem to which the snapshot will be taken of
  # This cannot be changed after create
  path = "/ifs/${powerscale_filesystem.file_system_test.name}"

  # Optional name of the new snapshot. If unset uses the current date and time for the name attribute (Can be modified)
  name = "tf_snapshot_1"

  # Optional set_expires The amount of time from creation before the snapshot will expire and be eligible for automatic deletion.  (Can be modified)
  # Options: Never(default if unset), 1 Day, 1 Week, 1 Month.
  set_expires = "1 Day"
}

