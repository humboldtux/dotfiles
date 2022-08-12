# Create Dirs
def "mysetup base dirs" [] { 
  echo "PATH dirs"
  mkdir $"($env.HOME)/bin" $"($env.HOME)/.local/bin"
}
