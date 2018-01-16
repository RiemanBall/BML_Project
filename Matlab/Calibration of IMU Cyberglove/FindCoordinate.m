k = 3500;
base = csvread('synDataFile_arm_base.csv', 0,2, [0,2,k-1,5]);
arm = csvread('synDataFile_arm_base.csv', 0,15, [0,15,k-1,18]);
forearm = csvread('synDataFile_forearm_arm_tt.csv', 0,2, [0,2,k-1,5]);
arm2 = csvread('synDataFile_forearm_arm_tt.csv', 0,15, [0,15,k-1,18]);
base_quat = repmat(Quaternion(), k, 1);
arm_quat = repmat(Quaternion(), k, 1);
arm2_quat = repmat(Quaternion(), k, 1);
forearm_quat = repmat(Quaternion(), k, 1);


for i = 1:k
    base_quat(i) = Quaternion(base(i, :));
    arm_quat(i) = Quaternion(arm(i, :));
    forearm_quat(i) = Quaternion(forearm(i, :));
    arm2_quat(i) = Quaternion(arm2(i, :));
    
    figure
    base_quat(i).plot('color','b')
    hold on
    arm_quat(i).plot('color', 'r')
    
    figure
    forearm_quat(i).plot('color', 'b')
    hold on
    arm2_quat(i).plot('color', 'r')
    
    figure
    qba = base_quat(i).inv * arm_quat(i);
    qba.plot

end