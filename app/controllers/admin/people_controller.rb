class Admin::PeopleController < ApplicationController
  def index
    @people = Person.all
  end

  def new
    @person = Person.new
  end

  def edit
    @person = Person.find(params[:id])
  end

  def show
    @person = Person.find(params[:id])
  end

  def create
    @person = Person.create(person_params)
    redirect_to person_path(@person)
  end

  def update
    @person = Person.find(params[:id])
    @person.update_attributes(person_params)
    redirect_to person_path(@person)
  end

  def destroy
    @person = Person.find(params[:id])
    @person.destroy!
    redirect_to people_path
  end

  private
  def person_params
    params.require(:person).permit(:refugee, :name, :phone_number)
  end
end
