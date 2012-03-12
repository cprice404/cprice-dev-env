class cprice-dev-env::base {
    include cprice-dev-env::stages
    class { 'cprice-dev-env::prereqs': stage => prereqs }
    include oraclejava6
    include intellij_idea
    include gkrellm
    include rvm
    include vim
    include google-chrome
    include git
    include pidgin
}
