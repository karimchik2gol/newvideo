class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :super_admin

  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all
  end

  def parse_categories
    CategoryJob.perform_later
    redirect_to categories_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :category_id)
    end
end
