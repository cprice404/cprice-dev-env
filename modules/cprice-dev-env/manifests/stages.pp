class cprice-dev-env::stages {
    stage { 'prereqs': before => Stage['main'] }
}
