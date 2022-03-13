% % 本程序用于生成模糊查询表，对应课本《智能控制理论及应用》39页
% % Bai Li (Hunan Univ.), March 2022.
clear all;
close all;
clc;

% 假设E、EC和U的论域恰好均为{-6,-5,…,-1,0,1,…,5,6}，即划分了13个语言值取值元素的档位，
% 这意味着m = n = l = 6，从而确保2 * m + 1 = 2 * n + 1 = 2 * l + 1 = 13.
% 假设E、EC和U定义了7个语言值{NB，NM，NS，Z，PS，PM，PB}，分别编码为1-7.
m = 6;
n = 6;
l = 6;
input_1 = [1, 2, 3, 4, 5, 6, 7];
input_2 = [1, 2, 3, 4, 5, 6, 7];
output = [1, 2, 3, 4, 5, 6, 7];

% 以下三个矩阵对应着输入输出语言变量的隶属度函数（membership function）
input_1_membership = [1, 0.5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0.5, 1, 0.5, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0.5, 1, 0.5, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0.5, 1, 0.5, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0.5, 1, 0.5, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0.5, 1, 0.5, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.5, 1];
input_2_membership = input_1_membership;
output_2_membership = input_1_membership;

% 编码化的模糊控制规则表（由人类经验汇总而成，其中1-7对应此代码第9行之中的注释所注明的语义）
rule = [1, 1, 1, 1, 2, 4, 4;
    1, 1, 1, 1, 2, 4, 4;
    2, 2, 2, 2, 4, 5, 5;
    2, 2, 3, 4, 5, 6, 6;
    3, 3, 4, 6, 6, 6, 6;
    4, 4, 6, 7, 7, 7, 7;
    4, 4, 6, 7, 7, 7, 7];

R = zeros((2 * m + 1) * (2 * n + 1), (2 * l + 1)); % 初始化模糊关系矩阵R
for input1_terms_index = 1 : 7
    for input2_terms_index = 1 : 7
        output_terms_index = rule(input1_terms_index, input2_terms_index);
        A = input_1_membership(input1_terms_index, :);
        B = input_2_membership(input2_terms_index, :);
        C = output_2_membership(output_terms_index, :);
        
        for i = 1 : (2 * m + 1)
            for j = 1 : (2 * n + 1)
                R1(i,j) = min(A(i), B(j));
            end
        end
        
        R2 = [];
        for k = 1 : (2 * m + 1)
            R2 = [R2; R1(k,:)'];
        end
        
        for i = 1 : ((2 * m + 1) * (2 * n + 1))
            for j = 1 : (2 * l + 1)
                R3(i,j) = min(R2(i), C(j));
            end
        end
        R = max(R, R3);
    end
end

Fuzzy_Table = zeros(2 * m + 1, 2 * n + 1);
for input1_element_index = 1 : (2 * m + 1)
    for input2_element_index = 1 : (2 * n + 1)
        input1_value_membership = input_1_membership(:, input1_element_index);
        [max_input1_value, max_input1_index] = max(input1_value_membership);
        Ad = input_1_membership(max_input1_index,:);
        
        input2_value_membership = input_2_membership(:, input2_element_index);
        [max_input2_value, max_input2_index] = max(input2_value_membership);
        Bd = input_2_membership(max_input2_index, :);
        for i = 1 : (2 * m + 1)
            for j = 1 : (2 * n + 1)
                Rd1(i,j) = min(Ad(i), Bd(j));
            end
        end
        Rd2 = [];
        for k = 1 : (2 * m + 1)
            Rd2 = [Rd2, Rd1(k,:)];
        end
        for j = 1 : (2 * l + 1)
            Cd(j) = max(min(Rd2', R(:,j)));
        end
        sum1 = 0;
        sum2 = 0;
        Output = -m : 1 : m;
        for i = 1 : (2 * l + 1)
            sum1 = sum1 + Cd(i);
            sum2 = sum2 + Cd(i) * Output(i);
        end
        OUT = round(sum2 / sum1);
        
        Fuzzy_Table(input1_element_index, input2_element_index) = OUT;
    end
end
Fuzzy_Table