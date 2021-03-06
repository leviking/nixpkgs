# Has a cyclic dependency with sage (not expressed here) and is not useful outside of sage
{ stdenv
, fetchpatch
, python
, buildPythonPackage
, fetchFromGitHub
, mathjax
, twisted
, flask
, flask-oldsessions
, flask-openid
, flask-autoindex
, flask-babel
}:

buildPythonPackage rec {
  pname = "sagenb";
  version = "2018-06-26"; # not 1.0.1 because of new flask syntax

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sagenb";
    rev = "b360a0172e15501fb0163d02dce713a561fee2af";
    sha256 = "12anydw0v9w23rbc0a94bqmjhjdir9h820c5zdhipw9ccdcc2jlf";
  };

  propagatedBuildInputs = [
    twisted
    flask
    flask-oldsessions
    flask-openid
    flask-autoindex
    flask-babel
  ];

  # tests depend on sage
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Sage Notebook";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ timokau ];
  };

  # let sagenb use mathjax
  postInstall = ''
    ln -s ${mathjax}/lib/node_modules/mathjax "$out/${python.sitePackages}/mathjax"
  '';
}
