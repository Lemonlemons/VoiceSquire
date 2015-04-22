class NotesController < ApplicationController
  def index
    @notes = Note.all
  end

  def show
    @note = Note.find(params[:id])
    @notes = Note.all
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(note_params)

    if @note.save
      redirect_to edit_quest_path(@note.quest_id), notice: "note was added"
    else
      render "new"
    end
  end

  def edit
    @note = Note.find(params[:id])
    @notes = Note.all
  end

  def update
    @note = Note.find(params[:id])

    if @note.update_attributes(note_params)
      redirect_to edit_note_path(@note), notice: "Your note has been added"
    else
      redirect_to edit_note_path(@note), notice: "Something went wrong"
    end
  end

  def destroy
    @note = Note.find(params[:id])
    @note.destroy
    redirect_to quests_path, notice:"Your note has been deleted"
  end

  def note_params
    params.require(:note).permit(:title, :explanation, :squire_id, :duke_id, :quest_id)
  end
end
