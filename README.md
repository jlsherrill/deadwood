# Deadwood

Deadwood is a ruby client library to interact with a Katello server (http://katello.org/)
## Katello API
[The katello api can be found here](https://fedorahosted.org/katello/wiki/ApiDocLatest)

### [Currently tested](https://github.com/calfonso/deadwood/tree/master/spec/models) and known to work API implementation in Deadwood
* [Activation keys](https://github.com/calfonso/deadwood/blob/master/spec/models/activation_key_spec.rb)
  * index
  * show
  * create
  * update
  * destroy
* [Changesets](https://github.com/calfonso/deadwood/blob/master/spec/models/changeset_spec.rb)
  * index
  * create
  * destroy
* [Crl](https://github.com/calfonso/deadwood/blob/master/spec/models/crl_spec.rb)
  * index
* [Environments](https://github.com/calfonso/deadwood/blob/master/spec/models/environment_spec.rb)
  * index
  * show
  * create
  * update
  * destroy
* [Gpg keys](https://github.com/calfonso/deadwood/blob/master/spec/models/gpg_key_spec.rb)
  * show
  * create
  * update
  * destroy
* [Organizations](https://github.com/calfonso/deadwood/blob/master/spec/models/organization_spec.rb)
  * index
  * show
  * create
  * update
  * destroy
* [Products](https://github.com/calfonso/deadwood/blob/master/spec/models/product_spec.rb)
  * show
  * index
  * destroy
* [Repositories](https://github.com/calfonso/deadwood/blob/master/spec/models/repository_spec.rb)
  * create
  * show
  * destroy
* [Roles](https://github.com/calfonso/deadwood/blob/master/spec/models/role_spec.rb)
  * index
  * show
  * create
  * update
  * destroy
* [System groups](https://github.com/calfonso/deadwood/blob/master/spec/models/system_group_spec.rb)
  * index
  * create
  * destroy
* [Users](https://github.com/calfonso/deadwood/blob/master/spec/models/user_spec.rb)
  * index
  * create
  * update
  * destroy
* [Task](https://github.com/calfonso/deadwood/blob/master/spec/models/task_spec.rb)
  * index
* [Templates](https://github.com/calfonso/deadwood/blob/master/spec/models/template_spec.rb)
  * index
  * create
  * destroy

## Contributing to deadwood

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Chris Alfonso. See COPYING for
further details.

