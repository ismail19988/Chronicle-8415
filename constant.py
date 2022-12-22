# EC2
UBUNTU_IMAGE = "ami-08c40ec9ead489470"
US_EAST_1C = "us-east-1c"

M4_LARGE = "m4.large"
T2_MICRO = "t2.micro"
T2_LARGE = "t2.large"

# Port configuration
DEFAULT_SECURITY_GROUP_NAME = "default"
CIDR_IP = "0.0.0.0/0"
SSH_PORT = 22
IP_PROTOCOL = "tcp"
SUBNET_ID = "subnet-05550903b14ae69f2"  # ip range: 172.31.80.X
SSH_KEY="proxy"

aws_access_key_id="ASIAYZCTG2ALXCRE2JO7"
aws_secret_access_key="tSmspE+Vu/qEjEOd87kIglMkZ1alIYBvzsHNi+ud"
aws_session_token="FwoGZXIvYXdzEIT//////////wEaDPI2xSgbcK5Tl9hu1CLDAdnTdUFnui/5n1ljMgYCUayy4I+537S6RuRFgAPIAX6s77EV" \
                  "w322sYMPoA+GfkuxTtE886HVrsCTZ24QZ7qKFfhB2V0tsPLXxHtE5vxqpPJJs1qvnXj0FlqVv/sacinFHHGmLu2fERdFkHf4" \
                  "MHsDz4kD3I6e4/panq7Ad3m5YyCC/oQp6b70rMdmSbHxUSqFECWEAqJ7AW+Hmj9v6x9mbFr/aDFJpWj3W0qRrFpWIkSOqnMG" \
                  "Hi+rbso/4XANMyxqE43V2Sj4yZKdBjItBw57pJ6jKWP55v2dXCnF+NMeBEiq03dKPZCRUtai7li76CXdEnDXamW+ZCqC"

# user data scripts
stand_alone_launch_script = "stand-alone_launch_script.sh"
empty_launch_script = "empty_script.sh"
master_launch_script = "master_launch_script.sh"
slave_launch_script = "slave_launch_script.sh"
proxy_launch_script = "proxy_launch_script.sh"
