require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def default_attributes
    {
      admin?: false,
      email: 'test@ema.il',
      password: 'simpler',
      password_confirmation: 'simpler'
    }
  end

  def build(extra = {})
    User.new(default_attributes().merge(extra))
  end

  test 'admin? has to be boolean' do
    assert build({admin?: true}).valid?
    assert build({admin?: false}).valid?

    user = build({admin?: nil}).tap(&:validate)
    assert user.errors.full_messages == ['Admin?  is not true or false']
  end

  test 'email has to be no more than 256 characters' do
    assert build({email: 'a' * 249 + '@ema.il'}).valid?

    user = build({email: 'a' * 250 + '@ema.il'}).tap(&:validate)
    assert user.errors.full_messages == ['Email has to be up to 256 characters']
  end

  test 'email addresses has to be unique' do
    user = build().tap(&:save)
    duplicate_user = user.dup
    duplicate_user.email = user.email.upcase
    duplicate_user.tap(&:validate)

    assert duplicate_user.errors.full_messages == ['Email has already been taken']
  end

  test 'email addresses has to be persisted lower-cased' do
    mixed_case_email = 'tEsT@EmA.iL'
    user = build({email: mixed_case_email}).tap(&:save)

    assert mixed_case_email.downcase == user.email
  end

  test 'password has to be present' do
    blank_password = " " * 6
    user = build(password: blank_password, password_confirmation: blank_password)

    assert user.tap(&:validate).errors.full_messages == ["Password can't be blank"]
  end

  test 'password has to be at least 6 characters long' do
    short_password = 'a' * 5
    user = build(password: short_password, password_confirmation: short_password)
    expected_errors = ["Password is too short (minimum is 6 characters)"]

    assert user.tap(&:validate).errors.full_messages == expected_errors
  end

  test 'email has to be valid' do
    invalid_emails = ['test@emai,il',
                      'test@email',
                      'test.email',
                      'test@em+a.il',
                      'test@.ema',
                      'test@e_ma.il']

    invalid_emails.each do |invalid_email|
      user = build({email: invalid_email}).tap(&:validate)
      assert user.errors.full_messages == ['Email is not in a valid format']
    end
  end
end
