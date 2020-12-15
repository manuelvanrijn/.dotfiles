setjdk() {
  export JAVA_HOME=$(/usr/libexec/java_home -v $1)
}

# setjdk 1.8
