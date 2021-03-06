require 'test_helper'

class PlayersControllerTest < ActionController::TestCase
  setup do
    @player = players(:jovi)
    @user = users(:daniel)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:players)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create player" do
    assert_difference('Player.count') do
      post :create, player: { firstName: "otroneanamme", lastName: "otroneanamme", email: @player.email, city: @player.city, ranking: @player.ranking}
    end

    assert_redirected_to players_path()
  end

  test "should show player" do
    get :show, id: @player
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @player
    assert_response :success
  end

  test "should update player" do
    patch :update, id: @player, player: { firstName: @player.firstName, numberOfMatches: @player.numberOfMatches, ranking: @player.ranking, id: @player.id }
    assert_redirected_to players_path()
  end

  test "should destroy player" do
    assert_no_difference('Player.count') do
      delete :destroy, id: @player
    end

    assert_redirected_to players_path
  end
end
