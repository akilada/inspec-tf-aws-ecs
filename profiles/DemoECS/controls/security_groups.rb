title "DemoECS: Test AWS Security Groups"

vpc_id = attribute('vpc_id')
vpc_cidr = attribute('vpc_cidr')
allow_all_cidr = attribute('allow_all_cidr')

control "aws-secuirty-group-ecs-elb-security-group" do
    title "Check Security Group ecs-elb-security-group"
    desc  "
        Check Security Group sg-0373c881ceca84578 
    "
    impact 1.0
    describe aws_security_group('sg-0373c881ceca84578') do
      it                          { should exist }
      its("description")          { should cmp "ECS ELB cccess controls" }
      its("group_name")           { should cmp "ecs-elb-security-group" }
      its('inbound_rules_count')  { should eq 1 }
      its('outbound_rules_count') { should eq 1 }
      its("vpc_id")               { should cmp vpc_id }
    end
  end
  
  control "aws-secuirty-group-demoEcs-postgres" do
    title "Check Security Group demoEcs-postgres"
    desc  "
      Check Security Group sg-0c4061dc5c4cead32
    "
    impact 1.0
    describe aws_security_group('sg-0c4061dc5c4cead32') do
      it                          { should exist }
      its("description")          { should cmp "PostgreSQL access controls" }
      its("group_name")           { should cmp "demoEcs-postgres" }
      its('inbound_rules_count')  { should eq 1 }
      its('outbound_rules_count') { should eq 1 }
      it                          { should allow_in(port: 5432, ipv4_range: vpc_cidr) }
      its("vpc_id")               { should cmp vpc_id }
    end
  end
  
  control "aws-secuirty-group-cs-tasks-security-group" do
    title "Check Security Group ecs-tasks-security-group"
    desc  "
      Check Security Group sg-04468509ee2f8879e
    "
    impact 1.0
    describe aws_security_group('sg-04468509ee2f8879e') do
      it                          { should exist }
      its("description")          { should cmp "Allow inbound access from the ELB only" }
      its("group_name")           { should cmp "ecs-tasks-security-group" }
      its('inbound_rules_count')  { should eq 1 }
      its('outbound_rules_count') { should eq 1 }
      it                          {should allow_in_only(port:9000, security_group: "sg-0373c881ceca84578")}
      its("vpc_id")               { should cmp vpc_id }
    end
  end
  
  control "aws-secuirty-group-demoEcs-vpn" do
    title "Check Security Group demoEcs-vpn"
    desc  "
        Check Security Group sg-0f2df224b68290d45
    "
    impact 1.0
    describe aws_security_group('sg-0f2df224b68290d45') do
      it                          { should exist }
      its("description")          { should cmp "VPN access controls" }
      its("group_name")           { should cmp "demoEcs-vpn" }
      its('inbound_rules_count')  { should eq 4 }
      its('outbound_rules_count') { should eq 1 }
      it                          { should allow_in(port: 943, ipv4_range: allow_all_cidr) }
      it                          { should allow_in(port: 1194, ipv4_range: allow_all_cidr) }
      it                          { should allow_in(port: 443, ipv4_range: allow_all_cidr) }
      its("vpc_id")               { should cmp vpc_id }
    end
  end

  control "Test All AWS Security Groups for undesirable rules" do
    title "Test All AWS Security Groups for undesirable rules"
    desc  "
        Test All AWS Security Groups for undesirable rules
    "
    aws_security_groups.group_ids.each do |group_id|
        describe aws_security_group(group_id) do
            it { should_not allow_in(port: 22, ipv4_range: '0.0.0.0/0') }
        end
    end
  end