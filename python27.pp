package {"epel-release":
	ensure		=>	installed,
	source		=>	"http://www.mirrorservice.org/sites/dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm",
	provider	=>	rpm
}

$packages = [ "rpmdevtools", "tk-devel", "tcl-devel", "expat-devel", "db4-devel", "gdbm-devel", "sqlite-devel", "bzip2-devel", "openssl-devel", "ncurses-devel", "readline-devel" ]
package {$packages:
	ensure	=>	installed,
	before	=>	Exec["rpmdev-setuptree"],
	require	=>	Package["epel-release"]
}

exec {"rpmdev-setuptree":
	path		=>	"/bin:/usr/bin",
	command		=>	"rpmdev-setuptree",
	before		=>	Exec["get python.spec"],
}

exec {"get python.spec":
	path		=>	"/bin:/usr/bin",
	command		=>	"wget --no-check-certificate https://raw.github.com/nmilford/specfiles/master/python-2.7/python27-2.7.2.spec -O /usr/src/redhat/SPECS/python27-2.7.2.spec",
	before		=>	Exec["get python"],
}

exec {"get python":
	path	=>	"/bin:/usr/bin",
	command	=>	"wget http://www.python.org/ftp/python/2.7.2/Python-2.7.2.tar.bz2 -O /usr/src/redhat/SOURCES/Python-2.7.2.tar.bz2",
	before	=>	Exec["rpmbuild"],
}

exec {"rpmbuild":
	path		=>	"/bin:/usr/bin",
	command		=>	"QA_RPATHS=$[ 0x001|0x0010] rpmbuild -bb /usr/src/redhat/SPECS/python27-2.7.2.spec",
	before		=>	Package["python27"],
	timeout		=>	0,
	provider	=>	shell,
}

package {"python27":
	ensure		=>	"installed",
	provider	=>	"rpm",
	source		=>	"/usr/src/redhat/RPMS/x86_64/python27-2.7.2-milford-.x86_64.rpm"
}

package {"python27-tkinter":
	ensure		=>	"installed",
	provider	=>	"rpm",
	source		=>	"/usr/src/redhat/RPMS/x86_64/python27-tkinter-2.7.2-milford-.x86_64.rpm"
}

package {"python27-devel":
	ensure		=>	"installed",
	provider	=>	"rpm",
	source		=>	"/usr/src/redhat/RPMS/x86_64/python27-devel-2.7.2-milford-.x86_64.rpm"
}

package {"python27-debuginfo":
	ensure		=>	"installed",
	provider	=>	"rpm",
	source		=>	"/usr/src/redhat/RPMS/x86_64/python27-debuginfo-2.7.2-milford-.x86_64.rpm"
}
