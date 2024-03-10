---
regex: 'app/.*\.rb'
root_path: 'app'
test_root_path: 'spec'
test_file_suffix: '_spec.rb'
---

When writing a test, you should follow these steps:

1. Avoid typos.
2. Avoid things that could be infinite loops.
3. This codebase is Rails, try to follow the conventions of Rails.
4. Write tests using RSpec like in the example I included
5. If you're in doubt, just write the parts you're sure of
6. No comments in the test file, just the test code

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