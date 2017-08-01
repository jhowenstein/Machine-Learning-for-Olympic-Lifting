clear variables

N_SS = 16;
N_PS = 0;
N_SC = 27;
N_PC = 10;

ON = 1;
OFF = 0;

fc = 6;
fs = 90;
[b,a] = butter(4,fc/(fs/2));

row_counter = 0;

for q = 1:N_SS
    file = strcat('SS',num2str(q),'.csv');

    data = transpose(csvread(file));

    time = data(1,:);
    gyro = data(2:4,:);
    accel = data(5:7,:);
    N = length(data);
    n = 1:N;

    Ax_RAW = data(5,:);
    Ay_RAW = data(6,:);
    Az_RAW = data(7,:);

    Ax = filtfilt(b,a,Ax_RAW);
    Ay = filtfilt(b,a,Ay_RAW);
    Az = filtfilt(b,a,Az_RAW);

    accel_mag = sqrt(Ay.^2 + Az.^2);

    accel_mag = accel_mag - accel_mag(1);

    Gz = data(10,:);

    Vert_Accel = (Az .* cosd(Gz)) - (Ay .* sind(Gz));

    Hor_Accel = (Az .* sind(Gz)) + (Ay .* cosd(Gz));

    %CAL_VERT = 9.81;
    CAL_VERT = (Vert_Accel(100));

    Vert_Accel = Vert_Accel - CAL_VERT;

    MHA = find(Hor_Accel == max(Hor_Accel));

    for i = 1:N
        if Vert_Accel(i) > 1.5;
            RISE_EDGE = i;
            break
        end
    end

    for i = RISE_EDGE:-1:1
        if Vert_Accel(i) < 0;
            START = i + 1;
            break
        end
    end

    for i = MHA+1:N
        if Vert_Accel(i) < 0
            MBV = i - 1;
            break
        end
    end

    for i = MBV+1:N
        if Vert_Accel(i) > 0
            END = i - 1;
            break
        end
    end

    S = START;
    E = END;

    PULL_FRAMES = 1:(E-S + 1);
    N_PULL = length(PULL_FRAMES);

    vertAccel = Vert_Accel(S:E);
    horAccel = Hor_Accel(S:E);
    magAccel = accel_mag(S:E);

    PULL_INDEX = PULL_FRAMES * (100/N_PULL);
    INT_INDEX = 1:100;

    VERT_ACCEL_INT = interp1(PULL_INDEX,vertAccel,INT_INDEX,'spline');
    HOR_ACCEL_INT = interp1(PULL_INDEX,horAccel,INT_INDEX,'spline');
    MAG_ACCEL_INT = interp1(PULL_INDEX,magAccel,INT_INDEX,'spline');

    row_counter = row_counter + 1;
    output_row = [VERT_ACCEL_INT,HOR_ACCEL_INT,MAG_ACCEL_INT];
    
    output_data(row_counter,:) = output_row;
    target_data(row_counter,1) = 0;
    
end

for q = 1:N_PS
    file = strcat('PS',num2str(q),'.csv');

    data = transpose(csvread(file));

    time = data(1,:);
    gyro = data(2:4,:);
    accel = data(5:7,:);
    N = length(data);
    n = 1:N;

    Ax_RAW = data(5,:);
    Ay_RAW = data(6,:);
    Az_RAW = data(7,:);

    Ax = filtfilt(b,a,Ax_RAW);
    Ay = filtfilt(b,a,Ay_RAW);
    Az = filtfilt(b,a,Az_RAW);

    accel_mag = sqrt(Ay.^2 + Az.^2);

    accel_mag = accel_mag - accel_mag(1);

    Gz = data(10,:);

    Vert_Accel = (Az .* cosd(Gz)) - (Ay .* sind(Gz));

    Hor_Accel = (Az .* sind(Gz)) + (Ay .* cosd(Gz));

    %CAL_VERT = 9.81;
    CAL_VERT = (Vert_Accel(100));

    Vert_Accel = Vert_Accel - CAL_VERT;

    MHA = find(Hor_Accel == max(Hor_Accel));

    for i = 1:N
        if Vert_Accel(i) > 1.5;
            RISE_EDGE = i;
            break
        end
    end

    for i = RISE_EDGE:-1:1
        if Vert_Accel(i) < 0;
            START = i + 1;
            break
        end
    end

    for i = MHA+1:N
        if Vert_Accel(i) < 0
            MBV = i - 1;
            break
        end
    end

    for i = MBV+1:N
        if Vert_Accel(i) > 0
            END = i - 1;
            break
        end
    end

    S = START;
    E = END;

    PULL_FRAMES = 1:(E-S + 1);
    N_PULL = length(PULL_FRAMES);

    vertAccel = Vert_Accel(S:E);
    horAccel = Hor_Accel(S:E);
    magAccel = accel_mag(S:E);

    PULL_INDEX = PULL_FRAMES * (100/N_PULL);
    INT_INDEX = 1:100;

    VERT_ACCEL_INT = interp1(PULL_INDEX,vertAccel,INT_INDEX,'spline');
    HOR_ACCEL_INT = interp1(PULL_INDEX,horAccel,INT_INDEX,'spline');
    MAG_ACCEL_INT = interp1(PULL_INDEX,magAccel,INT_INDEX,'spline');
    
    row_counter = row_counter + 1;
    output_row = [VERT_ACCEL_INT,HOR_ACCEL_INT,MAG_ACCEL_INT];
    
    output_data(row_counter,:) = output_row;
    target_data(row_counter,1) = 1;
end

for q = 1:N_SC
    file = strcat('SC',num2str(q),'.csv');

    data = transpose(csvread(file));

    time = data(1,:);
    gyro = data(2:4,:);
    accel = data(5:7,:);
    N = length(data);
    n = 1:N;

    Ax_RAW = data(5,:);
    Ay_RAW = data(6,:);
    Az_RAW = data(7,:);

    Ax = filtfilt(b,a,Ax_RAW);
    Ay = filtfilt(b,a,Ay_RAW);
    Az = filtfilt(b,a,Az_RAW);

    accel_mag = sqrt(Ay.^2 + Az.^2);

    accel_mag = accel_mag - accel_mag(1);

    Gz = data(10,:);

    Vert_Accel = (Az .* cosd(Gz)) - (Ay .* sind(Gz));

    Hor_Accel = (Az .* sind(Gz)) + (Ay .* cosd(Gz));

    %CAL_VERT = 9.81;
    CAL_VERT = (Vert_Accel(100));

    Vert_Accel = Vert_Accel - CAL_VERT;

    MHA = find(Hor_Accel == max(Hor_Accel));

    for i = 1:N
        if Vert_Accel(i) > 1.5;
            RISE_EDGE = i;
            break
        end
    end

    for i = RISE_EDGE:-1:1
        if Vert_Accel(i) < 0;
            START = i + 1;
            break
        end
    end

    for i = MHA+1:N
        if Vert_Accel(i) < 0
            MBV = i - 1;
            break
        end
    end

    for i = MBV+1:N
        if Vert_Accel(i) > 0
            END = i - 1;
            break
        end
    end

    S = START;
    E = END;

    PULL_FRAMES = 1:(E-S + 1);
    N_PULL = length(PULL_FRAMES);

    vertAccel = Vert_Accel(S:E);
    horAccel = Hor_Accel(S:E);
    magAccel = accel_mag(S:E);

    PULL_INDEX = PULL_FRAMES * (100/N_PULL);
    INT_INDEX = 1:100;

    VERT_ACCEL_INT = interp1(PULL_INDEX,vertAccel,INT_INDEX,'spline');
    HOR_ACCEL_INT = interp1(PULL_INDEX,horAccel,INT_INDEX,'spline');
    MAG_ACCEL_INT = interp1(PULL_INDEX,magAccel,INT_INDEX,'spline');

    row_counter = row_counter + 1;
    output_row = [VERT_ACCEL_INT,HOR_ACCEL_INT,MAG_ACCEL_INT];
    
    output_data(row_counter,:) = output_row;
    target_data(row_counter,1) = 2;
end

for q = 1:N_PC
    file = strcat('PC',num2str(q),'.csv');

    data = transpose(csvread(file));

    time = data(1,:);
    gyro = data(2:4,:);
    accel = data(5:7,:);
    N = length(data);
    n = 1:N;

    Ax_RAW = data(5,:);
    Ay_RAW = data(6,:);
    Az_RAW = data(7,:);

    Ax = filtfilt(b,a,Ax_RAW);
    Ay = filtfilt(b,a,Ay_RAW);
    Az = filtfilt(b,a,Az_RAW);

    accel_mag = sqrt(Ay.^2 + Az.^2);

    accel_mag = accel_mag - accel_mag(1);

    Gz = data(10,:);

    Vert_Accel = (Az .* cosd(Gz)) - (Ay .* sind(Gz));

    Hor_Accel = (Az .* sind(Gz)) + (Ay .* cosd(Gz));

    %CAL_VERT = 9.81;
    CAL_VERT = (Vert_Accel(100));

    Vert_Accel = Vert_Accel - CAL_VERT;

    MHA = find(Hor_Accel == max(Hor_Accel));

    for i = 1:N
        if Vert_Accel(i) > 1.5;
            RISE_EDGE = i;
            break
        end
    end

    for i = RISE_EDGE:-1:1
        if Vert_Accel(i) < 0;
            START = i + 1;
            break
        end
    end

    for i = MHA+1:N
        if Vert_Accel(i) < 0
            MBV = i - 1;
            break
        end
    end

    for i = MBV+1:N
        if Vert_Accel(i) > 0
            END = i - 1;
            break
        end
    end

    S = START;
    E = END;

    PULL_FRAMES = 1:(E-S + 1);
    N_PULL = length(PULL_FRAMES);

    vertAccel = Vert_Accel(S:E);
    horAccel = Hor_Accel(S:E);
    magAccel = accel_mag(S:E);

    PULL_INDEX = PULL_FRAMES * (100/N_PULL);
    INT_INDEX = 1:100;

    VERT_ACCEL_INT = interp1(PULL_INDEX,vertAccel,INT_INDEX,'spline');
    HOR_ACCEL_INT = interp1(PULL_INDEX,horAccel,INT_INDEX,'spline');
    MAG_ACCEL_INT = interp1(PULL_INDEX,magAccel,INT_INDEX,'spline');

    row_counter = row_counter + 1;
    output_row = [VERT_ACCEL_INT,HOR_ACCEL_INT,MAG_ACCEL_INT];
    
    output_data(row_counter,:) = output_row;
    target_data(row_counter,1) = 3;
end

csvwrite('acceleration_data.csv',output_data)
csvwrite('target_data.csv',target_data)
