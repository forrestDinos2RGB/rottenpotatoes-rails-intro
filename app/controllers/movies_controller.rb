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
    80.times{print '*'}
    @title_highlight = 'none'
    @date_highlight = 'none'
    @all_ratings = Movie.uniq.pluck(:rating)
    @redirect_enable = false
    @params_package = {}
    
    #default logic for all checks
    if params[:ratings] == nil && session[:all_keys] == nil
      params[:ratings] = @all_ratings
      puts "first time visiting website"
      puts "expect all ratings: #{params[:ratings]}, and nothing to be clicked #{session[:all_keys]}"
    end
    
    #checks whether 'date' or 'title' has been clicked
    clicked = params[:sorted]
    puts "#{clicked} has been clicked"
    
    #Does cookies already contain clicked fields from previous browsing experience?
    @movies = Movie.all
    #Did user check any ratings
    if params[:ratings] == nil
      @redirect_enable = true
    else
      session[:all_keys] ||= params[:ratings].keys
    end 

    #Did user click on titles
    if clicked
      @params_package << clicked
      session[:highlight] = clicked
      session[:sorted] = clicked
    else
      # @redirect_enable = true
      if session[:sorted]
        @params_package << session[:sorted]
      end
    end

    #Checks if a given column is clicked
    if clicked == 'title' || session[:sorted] == 'title'
      @title_higlight = 'hilite'
    elsif clicked == 'date' || session[:sorted] == 'title'
      @date_highlight == 'hilite'
    end 

    if @redirect_enable
      redirect_to movies_path(@params_package)
    end
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
