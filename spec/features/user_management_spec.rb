feature 'User sign up' do

def sign_up(user)
    visit 'users/new'
    fill_in :email,    with: user.email
    fill_in :password, with: user.password
    fill_in :password_confirmation, with: user.password_confirmation
    click_button 'Sign up'
  end

  scenario 'I can sign up as a new user' do
    user = build(:user)
    expect { sign_up user }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, alice@example.com')
    expect(User.first.email).to eq('alice@example.com')
  end

  scenario 'requires a matching confirmation password' do
    user = create(:user, password_confirmation: 'wrong')
    expect { sign_up user }.not_to change(User, :count)
  end

  scenario 'raises flash when password does not match' do
    user = create(:user, password_confirmation: 'wrong')
    expect { sign_up user }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Please refer to the following errors below:'
  end

  scenario 'cant sign up without entering an email' do
    user = create(:user, email: '')
    expect { sign_up user }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Email must not be blank'
  end

  scenario 'I cannot sign up with an existing email' do
    user = create(:user, email: 'alice@example.com')
    sign_up user
    expect { sign_up(user) }.to change(User, :count).by(0)
    expect(page).to have_content('Email is already taken')
  end

end

feature 'User sign in' do

  def sign_in(user)
    visit '/sessions/new'
    fill_in :email,    with: user.email
    fill_in :password, with: user.password
    click_button 'Sign in'
  end

  scenario 'with correct credentials' do
    user = create(:user)
    sign_in(user)
    expect(page).to have_content "Welcome, #{user.email}"
  end


end
