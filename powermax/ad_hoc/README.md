The playbooks in this folder are written to directly call on the PowerMax REST API.  These examples combine both the PowerMax 
modules with the ansible URI module and as such can not be run idempotently.  Functionality shown here can be used to augment 
the modules for adhoc tasks that have not yet made it into the official modules. 

Be sure to check the release notes of the latest modules to ensure the functionality doesn't already exist in the latest version 
before adding URI based calls.  

URI tasks will either pass or fail, there is no idempotency running these tasks.

These examples serve as a how-to, the functionality in the playbooks here 
has already been incorporated into the latest PowerMax collections but 
these still serve as nice examples on how similar opeations can be done.

Latest PowerMax API documenation is here 
    https://developer.dell.com/apis/4458/versions/9.2/docs?nodeUri=%2Fdocs%2FGetting%20Started%2FProduct%20Version%20and%20Compatibility.md
