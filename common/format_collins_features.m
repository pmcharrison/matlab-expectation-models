function out = format_collins_features(res)
N = size(res, 1);

% drop the first row, which just contains headers
tmp = res(2:N, :); 
N = N - 1;

out = struct();
out.stimulus_path = char(tmp(:, 1));
out.stimulus_name = char(tmp(:, 2));
out.representation = char(tmp(:, 3));
out = add_time_constants(N, tmp, out);
out = add_calculation_type(N, tmp, out);
out.window = tmp(:, 6);
out = add_post_target_window(N, tmp, out);
out = add_value(N, tmp, out);
end

function out = add_time_constants(N, tmp, out)
out.time_constant_1 = NaN(N, 1);
out.time_constant_2 = NaN(N, 1);

for i = 1:N
    tmp2 = tmp(i, 4);
    if iscell(tmp2)
        tmp2 = tmp2{1};
    end
    out.time_constant_1(i) = tmp2(1);
    if isequal(size(tmp2), [1, 2])
        out.time_constant_2(i) = tmp2(2);
    end
end
end

function out = add_calculation_type(N, tmp, out)
out.calculation_type = cell(N, 1);
for i = 1:N
    tmp2 = tmp(i, 5);
    tmp2 = tmp2{1};
    if iscell(tmp2)
        a = tmp2{1}(1);
        b = tmp2{1}(2);
        tmp2 = strcat(a, '+', b);
    end
    out.calculation_type(i) = {tmp2};
end
end

function out = add_post_target_window(N, tmp, out)
out.post_target_window_begin = NaN(N, 1);
out.post_target_window_end = NaN(N, 1);
for i = 1:N
    tmp2 = tmp(i, 7);
    out.post_target_window_begin(i) = tmp2{1}(1);
    out.post_target_window_end(i) = tmp2{1}(2);
end
end

function out = add_value(N, tmp, out)
out.value = NaN(N, 1);
for i = 1:N
    tmp2 = tmp(i, 8);
    out.value(i) = tmp2{1};
end
end