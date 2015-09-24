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
  
    @all_ratings = Movie.all_ratings
    
    ##Check if params is empty and update it
    if(params[:ratings] == nil and params[:sort_param] == nil and (session[:ratings] != nil or session[:sort_param] != nil))
		if(params[:ratings] == nil and session[:ratings] != nil)
		  params[:ratings] = session[:ratings]
		end
		if(params[:sort_param] == nil and session[:sort_param] != nil)
		  params[:sort_param] = session[:sort_param]
		end
		redirect_to movies_path(:sort_param => params[:sort_param], :ratings => params[:ratings])
    	else

		if
		  @checked_ratings = params[:ratings]? params[:ratings].keys : @all_ratings
		  session[:ratings] = params[:ratings] ? params[:ratings].keys : []
		end
	    if(params[:sort_param]==nil and session[:sort_param] != nil)
		params[:sort_param]=session[:sort_param]
   	 end
   		 session[:sort_param] = params[:sort_param]
    	session[:ratings] = params[:ratings]
   	 if(params[:sort_param] == "title")
      if(params[:ratings] )
	@movies = Movie.where(:rating => (@checked_ratings==[]? @all_ratings : @checked_ratings)).order(params[:sort_param])
      else
	@movies = Movie.all.order(params[:sort_param])
      end
    elsif (params[:sort_param] == "release_date")
      if(params[:ratings])
	@movies = Movie.where(:rating => @checked_ratings).order(params[:sort_param])
      else
	@movies = Movie.all.order("release_date")
      end
    elsif (params[:sort_param]==nil)
      if(params[:ratings] )
	@movies = Movie.where(:rating => @checked_ratings==[] ? @all_ratings : @checked_ratings)
      else
	@movies = Movie.all
      end
    end
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
