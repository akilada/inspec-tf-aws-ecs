title "DemoECS: Test AWS IAM"


  control 'iam_root_user_mfa' do
    title 'MFA should be enabled for the root user'
    desc "
        MFA should be enabled for the root user
    "
    impact 1.0
  
    describe aws_iam_root_user do
      it { should have_mfa_enabled }
    end
  end

  control "aws-iam-password-policy" do
    title "Ensure IAM Password Policy has correct properties."

    impact 1.0

    describe aws_iam_password_policy do
        its('max_password_age_in_days') { should cmp <=90 }
    end

    describe aws_iam_password_policy do
        it { should expire_passwords }
    end

    describe aws_iam_access_keys.where { created_days_ago > 90 } do
        its('entries') { should be_empty }
    end

    describe aws_iam_users.where { has_console_password and not has_mfa_enabled } do
        its('entries') { should be_empty }
    end
  end

  control "aws-iam-policy-ecsTaskExecutionRole" do
    title "Ensure IAM Policy has correct properties."

    impact 1.0
    describe aws_iam_role('ecsTaskExecutionRole') do
      it { should exist }
    end
  end

  control "aws-iam-policy-mazonEC2ContainerServiceforEC2Role" do
    title "Ensure IAM Policy has correct properties."

    impact 1.0
    describe aws_iam_policy(policy_name: 'AmazonEC2ContainerServiceforEC2Role') do
      it          { should exist }
      its("arn")  { should cmp "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role" }
      it          { should be_attached_to_role('arn:aws:iam::843494101298:role/ecsTaskExecutionRole')}
    end
  end
  
  control "aws-iam-policy-AmazonECSTaskExecutionRolePolicy" do
    title "Ensure IAM Policy has correct properties."

    impact 1.0
    describe aws_iam_policy(policy_name: 'AmazonECSTaskExecutionRolePolicy') do
      it          { should exist }
      its("arn")  { should cmp "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy" }
      it          { should be_attached_to_role('ecsTaskExecutionRole')}
    end
  end
  
  control "aws-iam-policy-AecretsManagerReadWrite" do
    title "Ensure IAM Policy has correct properties."

    impact 1.0
    describe aws_iam_policy(policy_name: 'SecretsManagerReadWrite') do
      it          { should exist }
      its("arn")  { should cmp "arn:aws:iam::aws:policy/SecretsManagerReadWrite" }
      it          { should be_attached_to_role('ecsTaskExecutionRole')}
    end
  end