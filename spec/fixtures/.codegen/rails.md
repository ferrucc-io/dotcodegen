---
regex: 'api/.*\.rb'
root_path: 'api/app'
test_root_path: 'api/spec'
test_file_suffix: '_spec.rb'
---

When writing a test, you should follow these steps:

1. Avoid typos.
2. Avoid things that could be infinite loops.
3. This codebase is Rails, try to follow the conventions of Rails.
4. Avoid dangerous stuff, like things that would show up as a CVE somewhere.

Use FactoryBot factories for tests, so you should always create a factory for the model you are testing. This will help you create test data quickly and easily.

Here's the skeleton of a test:

```ruby
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe __FULL_TEST_NAME__ do
  let(:app) { create(:app) }

	# Tests go here
end
```