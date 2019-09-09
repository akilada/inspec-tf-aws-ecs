title "DemoECS: Test AWS VPC Checks"

vpc_id = attribute('vpc_id')
vpc_cidr = attribute('vpc_cidr')

control "aws-vpc-DemoEcs" do
  title "Check DemoECS VPC"
  desc  "
    Check AWS VPC
  "
  impact 1.0
  describe aws_vpc(vpc_id) do
    it                      { should exist }
    its("cidr_block")       { should cmp vpc_cidr }
    its("dhcp_options_id")  { should cmp "dopt-20df8947" }
    its("instance_tenancy") { should cmp "default" }
  end
end


control "Check AWC VPC Flow Logs Enabled" do
  title "Check AWC VPC Flow Logs Enabled"
  desc  "
        Check AWC VPC Flow Logs Enabled
  "
  impact 1.0

  aws_vpcs.vpc_ids.each do |vpc|
    describe aws_flow_log(vpc_id: vpc) do
        it { should exist }
    end
  end
end