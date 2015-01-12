require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "home page main layout links" do
    get root_path
    assert_template 'static_pages/home'
    # logo and home link
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", updates_path
  end
end
