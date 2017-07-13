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
<<<<<<< HEAD
    @all_ratings = Movie.uniq.pluck(:rating)
    
    #checks whether 'date' or 'title' has been clicked
    clicked = params[:sorted]
    puts "#{clicked} has been clicked"
    
    #Does cookies already contained clicked fields from previous browsing experience?
    @movies = Movie.all
    if session[:all_keys] == nil and params[:ratings] == nil
      @movies = Movie.all
    elsif params[:ratings]
      @movies = @movies.where(rating: params[:ratings].keys)
      session[:all_keys] = params[:ratings].keys
      # 80.times{ print '*'}
      # puts session[:all_keys]
    else
      @movies = @movies.where(rating: session[:all_keys])
    end
    
=======
    
    clicked = params[:sorted]
    puts "#{clicked} has been clicked"
>>>>>>> 53a8ea5... completed part1
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
<<<<<<< HEAD
      # @movies = Movie.all
    elsif session[:sort] == 'title'
      puts 'sorting by title'
      #sort the movies by title
      @movies = @movies.order(:title)
    else
      puts 'sorting by date'
      puts #sort the movies by release date
      @movies = @movies.order(:release_date)
=======
      @movies = Movie.all
    elsif session[:sort] == 'title'
      puts 'sorting by title'
      #sort the movies by title
      @movies = Movie.order(:title)
    else
      puts 'sorting by date'
      puts #sort the movies by release date
      @movies = Movie.order(:release_date)
>>>>>>> 53a8ea5... completed part1
    end 
    
    @title_highlight = 'hilite' if session[:highlight] == 'title'
    @date_highlight = 'hilite' if session[:highlight] == 'date'
<<<<<<< HEAD
    
=======
>>>>>>> 53a8ea5... completed part1
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
