function [output] = standNormalTable (input, type)
	% type = 'cdf', 'zvalue'
	% if type = 'cdf', 	input is normalized and return output which 0 <= output <= 1
	% if type = 'zvalue',	input is probability which 0 <= input <= 1, and return output with area from -inf to output approximate to input
	% if type is cdf, please normalize your zvalue first

	%{
		author : perry92205 lee
		e-mail : voldemort92205@gmail.com
		modify : version1-2016/3/22 - initial version
				 version2-2016/4/11 - support more precise input value in cdf
	%}

	table = [.0003 .0005 .0007 .0010 .0013 .0019 .0026 .0035 .0047 .0062 .0082 .0107 .0139 .0179 .0228 .0287 .0359 .0446 .0548 .0668 .0808 .0968 .1151 .1357 .1587 .1841 .2119 .2420 .2743 .3085 .3446 .3821 .4207 .4602 .5000;
			 .0003 .0005 .0007 .0009 .0013 .0018 .0025 .0034 .0045 .0060 .0080 .0104 .0136 .0174 .0222 .0281 .0351 .0436 .0537 .0655 .0793 .0951 .1131 .1335 .1562 .1814 .2090 .2389 .2709 .3050 .3409 .3783 .4168 .4562 .4960;
			 .0003 .0005 .0006 .0009 .0013 .0018 .0024 .0033 .0044 .0059 .0078 .0102 .0132 .0170 .0217 .0274 .0344 .0427 .0526 .0643 .0778 .0934 .1112 .1314 .1539 .1788 .2061 .2358 .2676 .3015 .3372 .3745 .4129 .4522 .4920;
			 .0003 .0004 .0006 .0009 .0012 .0017 .0023 .0032 .0043 .0057 .0075 .0099 .0129 .0166 .0212 .0268 .0336 .0418 .0516 .0630 .0764 .0918 .1093 .1292 .1515 .1762 .2033 .2327 .2643 .2981 .3336 .3707 .4090 .4483 .4880;
			 .0003 .0004 .0006 .0008 .0012 .0016 .0023 .0031 .0041 .0055 .0073 .0096 .0125 .0162 .0207 .0262 .0329 .0409 .0505 .0618 .0749 .0901 .1075 .1271 .1492 .1736 .2005 .2296  2611 .2946 .3300 .3669 .4052 .4443 .4840;
			 .0003 .0004 .0006 .0008 .0011 .0016 .0022 .0030 .0040 .0054 .0071 .0094 .0122 .0158 .0202 .0256 .0322 .0401 .0495 .0606 .0735 .0885 .1056 .1251 .1469 .1711 .1977 .2266 .2578 .2912 .3264 .3632 .4013 .4404 .4801;
			 .0003 .0004 .0006 .0008 .0011 .0015 .0021 .0029 .0039 .0052 .0069 .0091 .0119 .0154 .0197 .0250 .0314 .0392 .0485 .0594 .0721 .0869 .1038 .1230 .1446 .1685 .1949 .2236 .2546 .2877 .3228 .3594 .3974 .4364 .4761;
			 .0003 .0004 .0005 .0008 .0011 .0015 .0021 .0028 .0038 .0051 .0068 .0089 .0116 .0150 .0192 .0244 .0307 .0384 .0475 .0582 .0708 .0853 .1020 .1210 .1423 .1660 .1922 .2206 .2514 .2843 .3192 .3557 .3936 .4325 .4721;
			 .0003 .0004 .0005 .0007 .0010 .0014 .0020 .0027 .0037 .0049 .0066 .0087 .0113 .0146 .0188 .0239 .0301 .0375 .0465 .0571 .0694 .0838 .1003 .1190 .1401 .1635 .1894 .2177 .2483 .2810 .3156 .3520 .3897 .4286 .4681;
			 .0002 .0003 .0005 .0007 .0010 .0014 .0019 .0026 .0036 .0048 .0064 .0084 .0110 .0143 .0183 .0233 .0294 .0367 .0455 .0559 .0681 .0823 .0985 .1170 .1379 .1611 .1867 .2148 .2451 .2776 .3121 .3483 .3859 .4247 .464]';

	if strcmp (type, 'cdf')
		basic = -34;

		if input > 3.49
			% if z > 3.49, set cdf = 1
			output = 1;
		elseif input < -3.49
			% if z < -3.49, set cdf = 0
			output = 0;
		elseif input == 0.00
			% if it is center, we know that it's cdf is 0.5
			output = 0.5;
		else
			% change to left side (i.e. z < 0)
			x = -abs(input);
			upper = ceil (x*100-1+10^-100);
			if upper == x*100
				i = ceil (x*10) - basic + 1;
				j = mod (-x * 100, 10) + 1;
				output = table (i, j);
			else
				lower = upper + 1;
				% (i1, j1) -> lower
				i1 = ceil (lower/10) - basic + 1;
				j1 = mod (-lower, 10)+1;
				% (i2, j2) -> upper
				i2 = ceil (upper/10) - basic + 1;
				j2 = mod (-upper, 10)+1;
				if table (i2, j2) == table (i1, j1)
					output = table (i1, j1);
				else
					output = table (i1, j1) + (x - lower/100) * (table (i2, j2) - table (i1, j1))/ ((upper/100) - (lower/100));
				end
			end
			if input > 0
				output = 1 - output;
			end
		end
	elseif strcmp (type, 'zvalue')
		% given cdf, output z
		[n, m] = size (table);
		basic = -3.5;

		if (input > 1 || input < 0)
			error ('Your probability should be 0 <= P <= 1');
		end

		% change to left side
		if input > 0.5
			x = 1 - input;
		else
			x = input;
		end

		% find closest value of given cdf
		lower = max (table (find (table <= x)));
		lower = find (table == lower);
		upper = min (table (find (table >= x)));
		upper = find (table == upper);

		if upper == lower
			% the value show up in table
			j = floor (upper / n)+1;
			i = mod (upper, n);
			output = i * 0.1 + basic - 0.01*(j-1);
		else
			%(i1, j1), (i, j), (i2, j2)
			i1 = mod (lower, n);
			j1 = floor (lower/n) + 1;
			i2 = mod (upper, n);
			j2 = floor (upper/n) + 1;
			lower = i1 * 0.1 + basic - 0.01 * (j1-1);
			upper = i2 * 0.1 + basic - 0.01 * (j2-1);
			output = lower + (upper - lower) * (x - table (i1, j1)) / (table (i2, j2) - table (i1, j1));
		end

		if input > 0.5
			output = -output;
		end
	else
		error ('Please specific type "cdf" or "zvalue');
	end
end
