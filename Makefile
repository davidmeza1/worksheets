RMD_FILES := $(patsubst %.Rmd, %.html, $(wildcard *.Rmd))
INCLUDE_FILES := $(wildcard includes/*.html)
DATA := data/methodists.csv data/va-methodists-wide.csv

all : $(RMD_FILES) $(DATA)

%.html : %.Rmd $(INCLUDE_FILES) $(DATA)
	R --slave -e "set.seed(100);rmarkdown::render('$(<F)')"

$(DATA) :
	Rscript --vanilla R/dataprep.R

.PHONY : deploy
deploy :
	rsync --progress --delete -avz \
		--exclude='.git' \
		* reclaim:~/public_html/lincolnmullen.com/projects/worksheets/

.PHONY : clean
clean :
	rm -f $(RMD_FILES)
	rm -rf $(DATA)
	rm -rf libs/*
	rm -rf *_files/

