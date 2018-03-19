# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :skip_retry do
  match(&:retry_skipped?)
end
