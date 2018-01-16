k = 2000;
forearm = csvread('synDataFile_forearm_arm_tt.csv', 0,2, [0,2,k-1,5]);
arm = csvread('synDataFile_forearm_arm_tt.csv', 0,15, [0,15,k-1,18]);
IMUOutput = repmat(Quaternion(), k, 1);

for i = 1:2000
    forearm_qi = Quaternion(forearm(i, :));
    arm_qi = Quaternion(arm(i, :));
    
    IMUOutput(i) = arm_qi.inv * forearm_qi;
    IMUOutput(i) = IMUOutput(i).unit;
end


    
