BEGIN {
	a = 8;
	b = 18
	result = ""
};

/^ffmpeg.*mp4$/ {
	params=""
	# for (i=a; i <= b; i++ ) {
	# 	# tmp=sprintf("%s ", $(i));
	# 	params=params$(i) FS
	# }
	codec = $8
	preset = $10
	crf = $12
	gop = $14
	svt_params = $16
	pix_fmt = $18

	match(svt_params, /film-grain=[0-9]+/)
	tmp = substr(svt_params, RSTART, RLENGTH)
	match(tmp, /[0-9]+/)
	grain = substr(tmp, RSTART, RLENGTH)
	# print(grain)
	# print ""
}

/rtime/ {
	match($4, /[0-9]+\.[0-9]*/)
	time=substr($4, RSTART, RLENGTH);
}

/^video/ {
	match($1, /[0-9]+/)
	size = substr($1, RSTART, RLENGTH)
	# size = $1
}

END {
	# print params
	# print time
	# print size

	printf("%s,%s,%s,%s,%s,%s,%s,%s,%s\n",
		   codec,
		   preset,
		   crf,
		   gop,
		   svt_params,
		   grain,
		   pix_fmt,
		   time,
		   size)
}
