title 'Test AWS ELB'

aws_elb_name = attribute('aws_elb_name')
vpc_id       = attribute('vpc_id')

control 'aws-elb-sonarqube-elb' do

  impact 1.0
  title 'Ensure AWS ELB has the correct properties.'

  describe aws_elb(load_balancer_name: aws_elb_name) do
    it                          { should exist }
    its ('load_balancer_name')  { should eq aws_elb_name }
    its ('subnet_ids')          { should include 'subnet-036fdba0cc5c5551a', 'subnet-0b5804eebe27666a1', 'subnet-0eafab5e4ba9a05b7'}
    its ('security_group_ids')  { should include 'sg-0373c881ceca84578'}
    its ('internal_ports')      { should include 9000 }
    its ('external_ports')      { should include 9000 }
    its ('vpc_id')              { should eq vpc_id}

    its ('security_group_ids.count') {should eq 1}
    
  end
end