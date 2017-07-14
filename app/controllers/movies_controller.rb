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
    #Set initial class of link to be none unless clicked
    @title_highlight = 'none'
    @date_highlight = 'none'
    
    # set @all_ratings to be all ratings
    @all_ratings = Movie.uniq.pluck(:rating)

    #redirect packaging
    @redirect_enable = false
    @params_package = {}
    
    #expect params[:ratings] and session[:all_keys] to be both nil
    puts "expect #{params[:ratings]} and #{session[:all_keys]} to be both nil"
    
    #default logic for first time visiting website
    if params[:ratings] == nil && session[:ratings] == nil
      params[:ratings] = {"G"=>"1", "R"=>"1", "PG-13" => 1, "PG" => 1}
      puts "first time visiting website"
      puts "expect all ratings: #{params[:ratings]}, and nothing to be clicked #{session[:all_keys]}"
    end

    #Did user check any of the checkbox in form tag?
    if params[:ratings] == nil
      @redirect_enable = true
      #update the params package in case nothing has been passed
      params_package[:ratings] = session[:ratings]
    else
      #update the cookie
      session[:ratings] = params[:ratings]
    end

    #Did user click on either title or ratings?
    clicked = params[:sorted]
    if clicked == 'title'
      @title_highlight = 'hilite'
      session[:sorted] = 'title'
    elsif clicked == 'date'
      @date_highlight = 'hilite'
      session[:sorted] = 'date'
    else
      @redirect_enable = true
      params_package[:sorted]
    end

    if @redirect_enable
      redirect_to movies_path(@params_package)
    end

    @params_ratings = params[:ratings].keys
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
