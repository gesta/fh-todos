require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'admin? has to be boolean' do
    assert build_user({admin?: true}).valid?
    assert build_user({admin?: false}).valid?

    user = build_user({admin?: nil}).tap(&:validate)
    assert user.errors.full_messages == ['Admin?  is not true or false']
  end

  test 'email has to be no more than 256 characters' do
    assert build_user({email: 'a' * 249 + '@ema.il'}).valid?

    user = build_user({email: 'a' * 250 + '@ema.il'}).tap(&:validate)
    assert user.errors.full_messages == ['Email has to be up to 256 characters']
  end

  test 'email addresses has to be unique' do
    user = create_user()
    duplicate_user = user.dup
    duplicate_user.email = user.email.upcase
    duplicate_user.tap(&:validate)

    assert duplicate_user.errors.full_messages == ['Email has already been taken']
  end

  test 'email addresses has to be persisted lower-cased' do
    mixed_case_email = 'tEsT@EmA.iL'
    user = create_user({email: mixed_case_email})

    assert mixed_case_email.downcase == user.email
  end

  test 'password has to be present' do
    blank_password = " " * 6
    user = build_user(password: blank_password, password_confirmation: blank_password)

    assert user.tap(&:validate).errors.full_messages == ["Password can't be blank"]
  end

  test 'password has to be at least 6 characters long' do
    short_password = 'a' * 5
    user = build_user(password: short_password, password_confirmation: short_password)
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
      user = build_user({email: invalid_email}).tap(&:validate)
      assert user.errors.full_messages == ['Email is not in a valid format']
    end
  end
end
