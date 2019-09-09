title 'Test AWS RDS'

sonarqube_rds = input(:sonarqube_rds)

control 'aws-rds-instance' do

  impact 1.0
  title 'Ensure AWS RDS Instance has the correct properties.'

  describe aws_rds_instance(db_instance_identifier: sonarqube_rds['aws_rds_db_identifier']) do
    it { should exist }
    its ('db_name') { should cmp sonarqube_rds['aws_rds_db_name'] }
    its ('engine') { should cmp sonarqube_rds['aws_rds_db_engine'] }
    its ('engine_version') { should cmp sonarqube_rds['aws_rds_db_engine_version'] }
    its ('storage_type') { should cmp sonarqube_rds['aws_rds_db_storage_type'] }
    its ('master_username') { should cmp sonarqube_rds['aws_rds_db_master_user'] }
    its ('allocated_storage') { should cmp sonarqube_rds['aws_rds_storage_size'] }
    its ('db_instance_class') { should cmp sonarqube_rds['aws_rds_instance_class'] }
    its ('tags') { should include('Name' => 'demoEcs-rds-sonarqube')}
  end

end