aws_vpc_id = input('vpc_id')
subnets_list = input(:subnets_list)

control 'aws-subnets-loop' do

    impact 1.0
    title 'Loop across AWS VPC Subnets resource for detail.'
    
    aws_subnets.where { vpc_id == aws_vpc_id }.subnet_ids.each do |subnet|
        describe aws_subnet(subnet) do
            it                          { should be_available }
            it                          { should_not be_mapping_public_ip_on_launch }
            its ('vpc_id')              { should eq aws_vpc_id }
            its ('cidr_block')          { should cmp subnets_list[subnet]['subnet_cidr'] }
            its ('availability_zone')   { should cmp subnets_list[subnet]['subnet_az']}
        end
    end
end
