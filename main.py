from EC2_instances_creator import EC2Creator
import constant
import time

ec2 = EC2Creator()

print('Creating instance...')

instance_id, instance_private_DNS = ec2.create_instance(
    constant.US_EAST_1A,
    constant.M4_LARGE,
    launch_script=open(constant.stand_alone_launch_script).read()
)

print(f'Instance: {instance_id} created!\nPrivate DNS: {instance_private_DNS}.')

# print("Waiting 60 seconds before continuing...")
# time.sleep(60)

# Terminate services
# ec2.terminate_instance()

