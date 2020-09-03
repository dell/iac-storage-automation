FROM centos:centos8
RUN yum -y install epel-release && yum -y update && \
    yum install -y git glibc.i686 nspr ansible

RUN pip3 install isi-sdk-8-1-1 pywinrm && \
    git clone https://github.com/dell/ansible-isilon.git
WORKDIR /ansible-isilon
RUN git checkout tags/1.1.0 -b 1.1.0 && \
    mkdir -p /usr/lib/python3.6/site-packages/ansible/module_utils/storage/dell/ && \
    mkdir -p /usr/lib/python3.6/site-packages/ansible/modules/storage/dell/ && \
    cp dellemc_ansible/utils/* /usr/lib/python3.6/site-packages/ansible/module_utils/storage/dell && \
    cp dellemc_ansible/isilon/library/* /usr/lib/python3.6/site-packages/ansible/modules/storage/dell/ && \
    cp dellemc_ansible/doc_fragments/dellemc_isilon.py /usr/lib/python3.6/site-packages/ansible/plugins/doc_fragments/ && \
    rm -rf /ansible-isilon

CMD ["ansible-playbook"]
