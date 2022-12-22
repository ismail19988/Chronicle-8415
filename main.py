from EC2_instances_creator import EC2Creator
import constant

ec2 = EC2Creator()

print('Creating standalone...')
# standalone instance creation
standalone_instance_id, standalone_instance_private_DNS = ec2.create_instance(
    # Region
    constant.US_EAST_1C,
    # Type
    constant.T2_MICRO,
    # IP address
    "172.31.81.6",
    # Launch script
    launch_script=open(constant.stand_alone_launch_script).read()
)
print(f'Standalone Instance: {standalone_instance_id} created!\nPrivate DNS: {standalone_instance_private_DNS}.')
print('Creating cluster...')

# master  instance creation
master_instance_id, master_instance_private_DNS = ec2.create_instance(
    # Region
    constant.US_EAST_1C,
    # Type
    constant.T2_MICRO,
    # IP address
    "172.31.81.1",
    # Launch script
    launch_script=open(constant.master_launch_script).read()
)
print(f'Master Instance: {master_instance_id} created!\nPrivate DNS: {master_instance_private_DNS}.')

# node 1  instance creation
node_1_instance_id, node_1_instance_private_DNS = ec2.create_instance(
    # Region
    constant.US_EAST_1C,
    # Type
    constant.T2_MICRO,
    # IP address
    "172.31.81.2",
    # Launch script
    launch_script=open(constant.slave_launch_script).read()
)
print(f'Node 1 Instance: {node_1_instance_id} created!\nPrivate DNS: {node_1_instance_private_DNS}.')

# node 2 instance creation
node_2_instance_id, node_2_instance_private_DNS = ec2.create_instance(
    # Region
    constant.US_EAST_1C,
    # Type
    constant.T2_MICRO,
    # IP address
    "172.31.81.3",
    # Launch script
    launch_script=open(constant.slave_launch_script).read()
)
print(f'Node 2 Instance: {node_2_instance_id} created!\nPrivate DNS: {node_2_instance_private_DNS}.')

# node 3 instance creation
node_3_instance_id, node_3_instance_private_DNS = ec2.create_instance(
    # Region
    constant.US_EAST_1C,
    # Type
    constant.T2_MICRO,
    # IP address
    "172.31.81.4",
    # Launch script
    launch_script=open(constant.slave_launch_script).read()
)
print(f'Node 3 Instance: {node_3_instance_id} created!\nPrivate DNS: {node_3_instance_private_DNS}.')

print('')
print('Creating proxy instance...')

# proxy instance creation
proxy_instance_id, proxy_instance_private_DNS = ec2.create_instance(
    # Region
    constant.US_EAST_1C,
    # Type
    constant.T2_LARGE,
    # IP address
    "172.31.81.5",
    # Launch script
    launch_script=open(constant.proxy_launch_script).read()
)
print(f'proxy Instance: {proxy_instance_id} created!\nPrivate DNS: {proxy_instance_private_DNS}.')
# Terminate services
# ec2.terminate_instance()

