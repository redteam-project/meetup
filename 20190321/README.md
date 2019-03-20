# Launch Meetup and Hack Night

Refer to [Meetup page](https://www.meetup.com/redteamproject/events/259624820/) for details.

## Artifacts

* [Qwiklabs site](https://ce.qwiklabs.com/focuses/12629) (yes, the name doesn't make sense; I'm reusing another workshop)
* [Setup script](setup.sh), launch from Cloud Shell
* Blue Ansible playbook
* Red Ansible playbook

## Instructions

1. Select your qwiklabs project from the dropdown menu in the top blue bar, i.e., ```qwiklabs-gcp-fa603bc97e11059a```
2. Start the Cloud Shell
3. Clone this repo

```
git clone https://github.com/redteam-project/meetup.git
cd meetup/20190321
```

4. Run the setup script `./setup.sh`
5. SSH to the blue instance `gcloud compute ssh blue-1 --zone us-east4-a`
6. Update and install packages

```
sudo su -
yum update -y
yum install -y git ansible python-pip
```

7. Clone the `meetup`, `cyber-range-target`, and `exploit-curation` repos

```
git clone https://github.com/redteam-project/meetup
git clone https://github.com/redteam-project/cyber-range-target
git clone https://github.com/redteam-project/exploit-curation
```

8. Make this instance vulnerable to Shellshock and xxx

```
ansible-playbook meetup/20180321/blue.yml
```
