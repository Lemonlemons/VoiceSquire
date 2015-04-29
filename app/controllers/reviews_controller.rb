class ReviewsController < ApplicationController
  def index
    @reviews = Review.all
  end

  def show
    @review = Review.find(params[:id])
    @reviews = Review.all
  end

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)

    if @review.save
      redirect_to show_quest_path(@review.quest_id), notice: "review was saved"
    else
      redirect_to quests_path, notice: "Something went wrong"
    end
  end

  def edit
    @review = Review.find(params[:id])
    @reviews = Review.all
  end

  def update
    @review = Review.find(params[:id])

    if @review.update_attributes(review_params)
      redirect_to show_quest_path(@review.quest_id), notice: "Your review has been updated"
    else
      redirect_to quests_path, notice: "Something went wrong"
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to quests_path, notice:"Your review has been deleted"
  end

  def review_params
    params.require(:review).permit(:rating, :explanation, :squire_id, :duke_id, :quest_id)
  end
end
