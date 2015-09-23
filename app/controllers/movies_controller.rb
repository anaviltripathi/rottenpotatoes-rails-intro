class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
    @first_time = 1
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
	@checked_ratings = {}
	@all_ratings = ['G','PG','PG-13','R']
	
	@movies = Movie.all
	
	@redirect_stopper = 1
  	
  	
#  	if(params[:sort_param]==nil)
 #  		sort = session[:sort_param] 
 #  	else
  # 		sort = params[:sort_param]
 #  	end

  # 	if(params[:ratings]==nil)
  # 		rat = session[:ratings]
  # 	else
  # 		rat = params[:ratings]
  # 	end
	
	if(params[:sort_param]==nil)
   		params[:sort_param] = session[:sort_param]
   	end

   	if(params[:ratings]==nil)
   		params[:ratings] = session[:ratings]
   	end
	    	
   	if(params[:ratings]!=nil or params[:sort_param] != nil or session[:ratings]!=nil or session[:sort_param] != nil)
   		
   		if(params[:ratings]==nil)# and @redirect_stopper == 0)
   			flash.keep
   			@redirect_stopper =0
   			#redirect_to :ratings => rat, :sort_param => sort, @redirect_stopper => 1 and return 
  	 	end
   	
  	 	if(params[:sort_param]==nil)#  and @redirect_stopper == 0)
			flash.keep
		   	@redirect_stopper =0
  	 		#redirect_to :ratings => rat, :sort_param => sort, @redirect_stopper => 1  and return 
  	 	end
  	 	#if(params[:sort_param]!=nil and params[:ratings]!=nil)
  	 	#	@redirect_stopper = 1
  	 	#end
  	
  	end
  	
  	if(@redirect_stopper == 0 and rat != nil and sort !=nil)
		flash.keep
  		redirect_to :ratings => rat, :sort_param => sort and return
  	end
  	
  	
  	@all_ratings.each { |rating|
	if params[:ratings] == nil
			@checked_ratings[rating] = false
	else
		@checked_ratings[rating] = params[:ratings].has_key?(rating)
	end
	}
	
  	
  	if(params[:ratings]!=nil)
  		@movies = @movies.find_all{ |m| @checked_ratings.has_key?(m.rating) and @checked_ratings[m.rating]==true}
  	else
  		@movies = @movies.find_all{|m| @checked_ratings[m.rating]==false}

  	end
  	
  	
  
  	if (params[:sort_param] == 'title')
    	#params[:sort_param] = session[:sort_param]
    	@movies = @movies.sort_by{|m| m.title.to_s}
    	@title_header = 'hilite'
    elsif params[:sort_param] == 'release_date'
    	#params[:sort_param] = session[:sort_param]
    	@movies = @movies.sort_by{|m| m.release_date.to_s}
    	@release_header = 'hilite'
   	end	
   	
   	@first_time=0
	
	if(params[:sort_param]!= nil)
	session[:sort_param] = params[:sort_param]
	end
	if(params[:ratings]!= nil)
	session[:ratings] = params[:ratings]
	end
	
	if(@redirect_stopper == 0)
		flash.keep
  		redirect_to :ratings => rat, :sort_param => sort and return
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

