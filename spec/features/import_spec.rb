require 'rails_helper'

describe 'Importer' do
  before(:each) do
    @filepath = "#{Rails.root}/spec/fixtures/categories.xlsx"
  end

  after(:each) do
  end

  it 'imports', js: true do
    Delayed::Worker.delay_jobs = false
    visit '/importers/new?model=category'
    attach_file 'file', @filepath
    click_button 'Submit'
    visit '/import_statuses/' + ImportStatus.unscoped.last.id.to_s
    expect(page).to have_text "Description can't be blank"
    expect(page).to have_text 'Code has already been taken'
  end
end
