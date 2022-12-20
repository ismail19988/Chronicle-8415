import boto3
import constant
import time


class EC2Creator:
    """Instance creator used to configure and spin up an Amazon EC2 instance."""
    def __init__(self):
        """Constructor"""
        self.client = boto3.client(
            'ec2',
            region_name="us-east-1",
            aws_access_key_id=constant.aws_access_key_id,
            aws_secret_access_key=constant.aws_secret_access_key,
            aws_session_token=constant.aws_session_token
        )
        self.open_ssh_port()
        self.instance_id = []
        self.instance_private_dns = []


    def create_instance(self, availability_zone, instance_type, ip_address, launch_script):
        """Run a request to create an instance from parameters and saves their id.
        
        Parameters
        ----------
        availability_zone : string
                            The availability zone of the instance
        instance_type :     string
                            The instance type

        Returns
        -------
        instance_id : associated id of created ec2 instance
        """
        response = self.client.run_instances(
            BlockDeviceMappings=[
                {
                    'DeviceName': '/dev/sda1',
                    'Ebs': {
                        # deleting the storage on instance termination
                        'DeleteOnTermination': True,

                        # 8gb volume
                        'VolumeSize': 8,

                        # Volume type
                        'VolumeType': 'gp2',
                    },
                },
            ],

            SubnetId=constant.SUBNET_ID,

            # ip_address
            PrivateIpAddress=ip_address,

            # UBUNTU instance
            ImageId=constant.UBUNTU_IMAGE,

            # UBUNTU instance
            InstanceType=instance_type,

            # Availability zone
            Placement={
                'AvailabilityZone': availability_zone,
            },

            DisableApiTermination=False,

            # One instance
            MaxCount=1,
            MinCount=1,

            # Script to launch on instance startup
            UserData=launch_script
        )
        self.instance_id += [response["Instances"][0]["InstanceId"]]
        self.instance_private_dns += [response["Instances"][0]['PrivateDnsName']]
        time.sleep(5)
        return self.instance_id[-1], self.instance_private_dns[-1]


    
    def terminate_instance(self):
        """Shut down the created instance."""

        # Termination function that terminates the running instance
        self.client.terminate_instances(InstanceIds=self.instance_id)

    
    def open_ssh_port(self):
        """Open the port 22 on the default security group."""

        # Gets all open ports on the default group
        opened_ports = [i_protocol.get('FromPort') for i_protocol in
                        self.client.describe_security_groups(GroupNames=[constant.DEFAULT_SECURITY_GROUP_NAME])
                        ['SecurityGroups'][0]['IpPermissions']]
        # If not done already, opens the port 22 on the default security group so that
        # the ports of all instances are exposed by default on creation
        if constant.SSH_PORT not in opened_ports:
            self.client.authorize_security_group_ingress(
                GroupName=constant.DEFAULT_SECURITY_GROUP_NAME,
                CidrIp=constant.CIDR_IP,
                FromPort=constant.SSH_PORT,
                ToPort=constant.SSH_PORT,
                IpProtocol=constant.IP_PROTOCOL
            )