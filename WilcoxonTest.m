function accepted = wilcoxonTest (input1, input2)
%	if accepted, accepted = 1
%	if rejected, accepted = 0
% 	ref : https://www.wikiwand.com/en/Wilcoxon_signed-rank_test

	accepted = 1;

	n1 = length (input1);
	n2 = length (input2);

	if n1 ~= n2
		error ('input data should have same length\n');
	end
	n = n1;
	z = zeros (n, 3);
	z (:, 1) = abs(input1 - input2);
	z (:, 2) = sign (input1 - input2);

	% remove diff = 0
	toRemove = find (z (:, 2) == 0);
	n = n - length (toRemove);
	z (toRemove, :) = [];

	% ranking of abs(diff) from small to large
	sorting = zeros (n, 6);
	sorting (:, 1) = 1:n;		% index
	sorting (:, 2) = z(:, 1);	% abs(diff)
	sorting (:, 3) = z(:, 2);	% sig (diff)
%	sorting (:, 4)				% new index
%	sorting (:, 5)				% rank index (Ri)
%	sorting (:, 6)				% sign * Ri

	% sort with bubble sort
	for i = 1:n-1
		for j = i+1:n
			if sorting (i, 2) > sorting (j, 2)
				sorting (i, :) = sorting (i, :) + sorting(j, :);	% a = a+b
				sorting (j, :) = sorting (i, :) - sorting(j, :);	% b = a-b
				sorting (i, :) = sorting (i, :) - sorting(j, :);	% a = a-b
			end
		end
	end

	% new index
	sorting (:, 4) = 1:n;

	% rank index (Ri)
	% find how many states and rank them
	states = unique (sorting (:, 2));
	for i = 1:length (states)
		tmp = find (sorting (:, 2) == states(i));
		sorting (tmp, 5) = mean (sorting (tmp, 4));
	end

	% sign * Ri
	sorting (:, 6) = sorting (:, 3) .* sorting (:, 5);

	% average the rank : W
	W = abs (sum (sorting( :, 6) ));

end
