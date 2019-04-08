$(HOME)/bin/backdate: backdate.sh
	cp backdate.sh    $(HOME)/bin/backdate
	chmod u=rwx,go=rx $(HOME)/bin/backdate
