class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @redirection = false
    @all_ratings =Movie.ratings.keys
    @selected= selected_rating.keys
    @title_class = "title" == sort_column ? "hilite" : nil
    @release_class= "release_date" == sort_column ? "hilite" : nil
    @rating= selected_rating
    @direction= sort_direction
    @column=sort_column
    if @redirection
      redirect_to (movies_path(:ratings => @rating, :direction => @direction, :sort => @column))
    else
      @movies = Movie.find_all_by_rating(@selected, order: @column + " " + @direction)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path(:sort => session[:sort],:direction =>session[:direction],:rating =>session[:ratings])
  end
  private
  def sort_column
    if Movie.column_names.include?(params[:sort])
      session[:sort]=params[:sort]
    elsif !(session[:sort].nil?)
      @redirection = true
      session[:sort]
    else
     @redirection = true
      "title"
    end
  end
  def sort_direction
    if %w[asc desc].include?(params[:direction])
      session[:direction]= params[:direction]
    elsif !(session[:direction].nil?)
     @redirection = true
      session[:direction]
    else
      @redirection= true
      "asc"
    end
  end
  def selected_rating
    if !(params[:ratings].nil?) #and Movie.ratings.keys.include? params[:ratings].keys
      session[:ratings]= params[:ratings]
    elsif !(session[:ratings].nil?)
     @redirection =true
      session[:ratings]
    else
      @redirection = true
      Movie.ratings
    end
  end
end
