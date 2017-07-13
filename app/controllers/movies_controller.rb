class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @title_highlight = 'none'
    @date_highlight = 'none'
    
    clicked = params[:sorted]
    puts "#{clicked} has been clicked"
    if clicked == 'title'
      @title_highlight = 'hilite'
      session[:sort] = 'title'
      session[:highlight] = 'title' 
      #store in sessions that this linked has been clicked
    elsif clicked == 'date'
      @date_highlight = 'hilite'
      session[:sort] = 'date'
      session[:highlight] = 'date'
      #store in sessions that this linked has been clicked
    end
    
    if session[:sort] == nil
      puts 'no sorting occured'
      @movies = Movie.all
    elsif session[:sort] == 'title'
      puts 'sorting by title'
      #sort the movies by title
      @movies = Movie.order(:title)
    else
      puts 'sorting by date'
      puts #sort the movies by release date
      @movies = Movie.order(:release_date)
    end 
    
    @title_highlight = 'hilite' if session[:highlight] == 'title'
    @date_highlight = 'hilite' if session[:highlight] == 'date'
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
