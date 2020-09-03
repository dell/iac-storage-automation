# homedir
The present example aims to manage unix home directories using Active Directory as the reference for user list.

The predicate is we are in a university which has an Active Directory with all its users in it.
We have two AD groups one for the students, the other for the teachers.

We want to :
* get the list of students and teachers from AD
* create a unix home directory in PowerScale/Isilon for each user
* set different quotas if the user is a student or a teacher
* have daily snapshots of the home directories with different retention policies if for the students and teachers
* mount the home directories in a list of unix server
* cleanup the home directories of students that are not in the AD anymore

To use the playbook you will have to update a couple of files:
* [hosts.ini](isilon/homedir/hosts.ini) ; which has the inventory of Unix and Domain Controller
* [credentials-isi.yml](isilon/homedir/credentials-isi.yml) ; which has the details of the PowerScale
* [create_homedir_for_ad_users_in_isilon.yml](isilon/homedir/create_homedir_for_ad_users_in_isilon.yml) ; in the unix section we have to update the `base_path` and `nfs server IP`

The example comes with a docker image that has the required dependencies to run the playbook.
You can execute it with :
```
podman run --security-opt label=disable -e ANSIBLE_HOST_KEY_CHECKING=False -v ~/.ssh/id_rsa.emc.pub:/root/.ssh/id_rsa.pub -v ~/.ssh/id_rsa.emc:/root/.ssh/id_rsa -v "$(pwd)"/homedir/:/ansible-isilon -ti docker.io/coulof/ansible-isilon:1.1.0 ansible-playbook -vvvvv -i /ansible-isilon/hosts.ini /ansible-isilon/create_homedir_for_ad_users_in_isilon.yml
```

To be able to mount the students and teachers sub-dirs within the same `/home` and keep the write in the lower dirs we used `unionfs-fuse`. That feature is available in [AuFS](https://en.wikipedia.org/wiki/Aufs) and [UnionFS](https://en.wikipedia.org/wiki/UnionFS) but not in [OverlayFS](https://en.wikipedia.org/wiki/OverlayFS).
