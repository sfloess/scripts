#!/bin/bash

. `dirname ${BASH_SOURCE[0]}`/../flossware-scripts/bash/cobbler-utils.sh

# ---------------------------------------------------------
# Add distro definitions...
# ---------------------------------------------------------
addDistros() {
    remove-all

    ENTERPISE_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" packages="koan redhat-lsb"'
    FEDORA_KSMETA_DATA='auth="--useshadow --enablenis --nisdomain=flossware.com" p0 packages="koan"'

    distro-add        CentOS-5-x86_64          /root/distro/iso/CentOS-5.11-x86_64-bin-DVD-1of2.iso        --ksmeta="${ENTERPISE_KSMETA_DATA}"
    distro-add        CentOS-6-x86_64          /root/distro/iso/CentOS-6.8-x86_64-bin-DVD1.iso             --ksmeta="${ENTERPISE_KSMETA_DATA}"
    distro-add        CentOS-7-x86_64          /root/distro/iso/CentOS-7-x86_64-Everything-1511.iso        --ksmeta="${ENTERPISE_KSMETA_DATA}"
    distro-add        RHEL-7-x86_64            /root/distro/iso/rhel-server-7.2-x86_64-dvd.iso             --ksmeta="${ENTERPISE_KSMETA_DATA}"
    distro-add        Fedora-24-x86_64         /root/distro/iso/Fedora-Server-dvd-x86_64-24-1.2.iso        --ksmeta="${FEDORA_KSMETA_DATA}"

    distro-add-rhev   RHEVH-7-x86_64           /root/distro/iso/rhev-hypervisor7-7.2-20160302.1.iso        --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel7" --breed="redhat"

    distro-add-atomic CentOS-7-Atomic-x86_64   /root/distro/iso/CentOS-Atomic-Host-7-Installer.iso         --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel7"
    distro-add-atomic RHEL-7-Atomic-x86_64     /root/distro/iso/rhel-atomic-installer-7.2-10.x86_64.iso    --ksmeta="${ENTERPISE_KSMETA_DATA}" --arch="x86_64" --os-version="rhel7"
    distro-add-atomic Fedora-24-Atomic-x86_64  /root/distro/iso/Fedora-Atomic-dvd-x86_64-24-20160721.0.iso --ksmeta="${FEDORA_KSMETA_DATA}"    --arch="x86_64" --os-version="fedora24"
}

# ---------------------------------------------------------
# Add repo definitions...
# ---------------------------------------------------------
addRepos() {
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-5-extras"      --mirror="http://mirror.centos.org/centos-5/5/extras/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-5-centosplus"  --mirror="http://mirror.centos.org/centos-5/5/centosplus/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-5-updates"     --mirror="http://mirror.centos.org/centos-5/5/updates/x86_64"

    cobbler-exec repo add --mirror-locally="0" --name="CentOS-6-extras"      --mirror="http://mirror.centos.org/centos-6/6/extras/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-6-centosplus"  --mirror="http://mirror.centos.org/centos-6/6/centosplus/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-6-updates"     --mirror="http://mirror.centos.org/centos-6/6/updates/x86_64"

    cobbler-exec repo add --mirror-locally="0" --name="CentOS-7-extras"      --mirror="http://mirror.centos.org/centos-7/7/extras/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-7-centosplus"  --mirror="http://mirror.centos.org/centos-7/7/centosplus/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="CentOS-7-updates"     --mirror="http://mirror.centos.org/centos-7/7/updates/x86_64"

    cobbler-exec repo add --mirror-locally="0" --name="Epel-5"               --mirror="http://dl.fedoraproject.org/pub/epel/5/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="Epel-6"               --mirror="http://dl.fedoraproject.org/pub/epel/6/x86_64"
    cobbler-exec repo add --mirror-locally="0" --name="Epel-7"               --mirror="http://dl.fedoraproject.org/pub/epel/7/x86_64"

    cobbler-exec repo add --mirror-locally="0" --name="Fedora-24-everything" --mirror="http://dl.fedoraproject.org/pub/fedora/linux/releases/24/Everything/x86_64/os"
    cobbler-exec repo add --mirror-locally="0" --name="Fedora-24-updates"    --mirror="http://dl.fedoraproject.org/pub/fedora/linux/updates/24/x86_64"
}

# ---------------------------------------------------------
# Add profile definitions...
# ---------------------------------------------------------
addProfiles() {
    system-remove-all
    profile-remove-all

    CENTOS_5_REPOS="Epel-5 CentOS-5-extras CentOS-5-centosplus CentOS-5-updates"
    CENTOS_6_REPOS="Epel-6 CentOS-6-extras CentOS-6-centosplus CentOS-6-updates"
    CENTOS_7_REPOS="Epel-7 CentOS-7-extras CentOS-7-centosplus CentOS-7-updates"

    RHEL_REPOS="Epel-7"

    FEDORA_REPOS="Fedora-24-everything Fedora-24-updates"

    STANDARD_KICKSTART="/var/lib/cobbler/kickstarts/flossware_standard.ks"

    CENTOS_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_centos_atomic.ks"
    RHEL_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_rhel_atomic.ks"
    FEDORA_ATOMIC_KICKSTART="/var/lib/cobbler/kickstarts/flossware_fedora_atomic.ks"

    cobbler-exec profile edit --name="CentOS-5-x86_64"         --distro="CentOS-5-x86_64"         --kickstart="${STANDARD_KICKSTART}" --repos="${CENTOS_5_REPOS}"
    cobbler-exec profile edit --name="CentOS-6-x86_64"         --distro="CentOS-6-x86_64"         --kickstart="${STANDARD_KICKSTART}" --repos="${CENTOS_6_REPOS}"
    cobbler-exec profile edit --name="CentOS-7-x86_64"         --distro="CentOS-7-x86_64"         --kickstart="${STANDARD_KICKSTART}" --repos="${CENTOS_7_REPOS}"

    cobbler-exec profile edit --name="RHEL-7-x86_64"           --distro="RHEL-7-x86_64"           --kickstart="${STANDARD_KICKSTART}" --repos="${RHEL_REPOS}"
    cobbler-exec profile edit --name="Fedora-24-x86_64"        --distro="Fedora-24-x86_64"        --kickstart="${STANDARD_KICKSTART}" --repos="${FEDORA_REPOS}"

    cobbler-exec profile add  --name="RHEVH-7-x86_64"          --distro="RHEVH-7-x86_64"          --kickstart="${STANDARD_KICKSTART}" --repos="${RHEL_REPOS}"

    cobbler-exec profile add  --name="CentOS-7-Atomic-x86_64"  --distro="CentOS-7-Atomic-x86_64"  --kickstart="${CENTOS_ATOMIC_KICKSTART}"
    cobbler-exec profile add  --name="RHEL-7-Atomic-x86_64"    --distro="RHEL-7-Atomic-x86_64"    --kickstart="${RHEL_ATOMIC_KICKSTART}"
    cobbler-exec profile add  --name="Fedora-24-Atomic-x86_64" --distro="Fedora-24-Atomic-x86_64" --kickstart="${FEDORA_ATOMIC_KICKSTART}"
}

# ---------------------------------------------------------
# Add host definitions...
# ---------------------------------------------------------
addHosts() {
    cobbler-exec system add --name="host-1" --hostname="host-1" --profile="RHEL-7-x86_64" --interface="eth0" --mac-address="00:21:9B:32:5F:78" --virt-type="kvm" --ksmeta='lvmDisks="sda sdb sdc"'
    cobbler-exec system add --name="host-2" --hostname="host-2" --profile="RHEL-7-x86_64" --interface="eth0" --mac-address="00:19:B9:1F:34:B6" --virt-type="kvm" --ksmeta='lvmDisks="sda sdb sdc"'
}

# ---------------------------------------------------------
# Add Xen virtual machine definitions...
# ---------------------------------------------------------
addXenVms() {
    XEN_VM_KSMETA_DATA='bootloader="--location=mbr --boot-drive=xvda"'

    cobbler-exec system add --name="centos-5-xen"  --hostname="centos-xen" --profile="CentOS-5-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus="4" --ksmeta="${XEN_VM_KSMETA_DATA}"
    cobbler-exec system add --name="centos-6-xen"  --hostname="centos-xen" --profile="CentOS-6-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus="4" --ksmeta="${XEN_VM_KSMETA_DATA}"
    cobbler-exec system add --name="centos-7-xen"  --hostname="centos-xen" --profile="CentOS-7-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus="4" --ksmeta="${XEN_VM_KSMETA_DATA}"
    cobbler-exec system add --name="fedora-24-xen" --hostname="fedora-xen" --profile="Fedora-24-x86_64" --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus="4" --ksmeta="${XEN_VM_KSMETA_DATA}"
    cobbler-exec system add --name="rhel-7-xen"    --hostname="rhel-xen"   --profile="RHEL-7-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus="4" --ksmeta="${XEN_VM_KSMETA_DATA}"

    cobbler-exec system add --name="centos-7-atomic-xen"  --hostname="centos-atomic-xen" --profile="CentOS-7-Atomic-x86_64"   --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta="${XEN_VM_KSMETA_DATA}"
    cobbler-exec system add --name="fedora-24-atomic-xen" --hostname="fedora-atomic-xen" --profile="Fedora-24-Atomic-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta="${XEN_VM_KSMETA_DATA}"
    cobbler-exec system add --name="rhel-7-atomic-xen"    --hostname="rhel-atomic-xen"   --profile="RHEL-7-Atomic-x86_64"     --interface="eth0"  --mac-address="random" --virt-type="xenpv" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0" --ksmeta="${XEN_VM_KSMETA_DATA}"

    cobbler-exec system add --name="workstation-xen"   --hostname="workstation-xen"   --profile="RHEL-7-x86_64"        --interface="eth0"  --mac-address="00:16:3e:1c:97:ac" --virt-type="xenpv" --virt-file-size="20"  --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="${XEN_VM_KSMETA_DATA}"
    cobbler-exec system add --name="atomic-master-xen" --hostname="atomic-master-xen" --profile="RHEL-7-Atomic-x86_64" --interface="eth0"  --mac-address="00:16:3e:39:ce:5e" --virt-type="xenpv" --virt-file-size="100" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=1 --ksmeta="${XEN_VM_KSMETA_DATA}"
    cobbler-exec system add --name="db-xen"            --hostname="db-xen"            --profile="RHEL-7-x86_64"        --interface="eth0"  --mac-address="00:16:3e:50:39:07" --virt-type="xenpv" --virt-file-size="100" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=1 --ksmeta="${XEN_VM_KSMETA_DATA}"
    cobbler-exec system add --name="pulp-xen"          --hostname="pulp-xen"          --profile="RHEL-7-x86_64"        --interface="eth0"  --mac-address="00:16:3e:4e:fc:64" --virt-type="xenpv" --virt-file-size="100" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="${XEN_VM_KSMETA_DATA}"
    cobbler-exec system add --name="solr-xen"          --hostname="solr-xen"          --profile="RHEL-7-x86_64"        --interface="eth0"  --mac-address="00:16:3e:7f:38:c8" --virt-type="xenpv" --virt-file-size="100" --virt-ram="3400" --virt-bridge="bridge0" --virt-cpus=4 --ksmeta="${XEN_VM_KSMETA_DATA}"
}

# ---------------------------------------------------------
# Add KVM virtual machine definitions...
# ---------------------------------------------------------
addKvmVms() {
    cobbler-exec system add --name="centos-5-kvm"  --hostname="centos-5-kvm"  --profile="CentOS-5-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="centos-6-kvm"  --hostname="centos-6-kvm"  --profile="CentOS-6-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="centos-7-kvm"  --hostname="centos-7-kvm"  --profile="CentOS-7-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="fedora-24-kvm" --hostname="fedora-24-kvm" --profile="Fedora-24-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="rhel-7-kvm"    --hostname="rhel-7-kvm"    --profile="RHEL-7-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="10" --virt-ram="2048" --virt-bridge="bridge0"

    cobbler-exec system add --name="centos-7-atomic-kvm"  --hostname="centos-atomic-kvm" --profile="CentOS-7-Atomic-x86_64"  --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="fedora-24-atomic-kvm" --hostname="fedora-atomic-kvm" --profile="Fedora-24-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="2048" --virt-bridge="bridge0"
    cobbler-exec system add --name="rhel-7-atomic-kvm"    --hostname="rhel-atomic-kvm"   --profile="RHEL-7-Atomic-x86_64"    --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20" --virt-ram="2048" --virt-bridge="bridge0"

    cobbler-exec system add --name="workstation"   --hostname="workstation"   --profile="RHEL-7-x86_64"        --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="20"  --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=4
    cobbler-exec system add --name="db"            --hostname="db"            --profile="RHEL-7-x86_64"        --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="100" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=1
    cobbler-exec system add --name="atomic-master" --hostname="atomic-master" --profile="RHEL-7-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="100" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=1
    cobbler-exec system add --name="pulp"          --hostname="pulp"          --profile="RHEL-7-x86_64"        --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="100" --virt-ram="2048" --virt-bridge="bridge0" --virt-cpus=4

    cobbler-exec system add --name="builder" --hostname="builder" --profile="RHEL-7-x86_64" --interface="eth0" --mac-address="random" --virt-type="kvm" --virt-file-size="100" --virt-ram="8192"  --virt-bridge="bridge0"
    cobbler-exec system add --name="solr"    --hostname="solr"    --profile="RHEL-7-x86_64" --interface="eth0" --mac-address="random" --virt-type="kvm" --virt-file-size="100" --virt-ram="16000" --virt-bridge="bridge0" --virt-cpus=4

    cobbler-exec system add --name="atomic-01" --hostname="atomic-01" --profile="RHEL-7-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="100" --virt-ram="8192" --virt-bridge="bridge0"
    cobbler-exec system add --name="atomic-02" --hostname="atomic-02" --profile="RHEL-7-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="100" --virt-ram="8192" --virt-bridge="bridge0"
    cobbler-exec system add --name="atomic-03" --hostname="atomic-03" --profile="RHEL-7-Atomic-x86_64" --interface="eth0"  --mac-address="random" --virt-type="kvm" --virt-file-size="100" --virt-ram="8192" --virt-bridge="bridge0"

}

# ---------------------------------------------------------
# Add virtual machine definitions...
# ---------------------------------------------------------
addVms() {
    addXenVms
    addKvmVms
}

# ---------------------------------------------------------
# Add system definitions...
# ---------------------------------------------------------
addSystems() {
    system-remove-all

    addHosts
    addVms

    system-create-iso
}

# ---------------------------------------------------------
# Create the entire network...
# ---------------------------------------------------------
createNetwork() {
    remove-all

    cobbler sync

    addDistros
    addRepos
    addProfiles
    addSystems
}

# ---------------------------------------------------------
# Determine what to definitions to add...
# ---------------------------------------------------------
case "$1" in
    systems)
        addSystems
        ;;
    profiles)
        addProfiles
        ;;
    distros)
        addDistros
        ;;
    *)
        createNetwork
        ;;
esac
