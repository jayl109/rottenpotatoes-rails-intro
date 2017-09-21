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
    
    #@movies = Movie.all

    if (params[:sort] != nil)
      if (session[:sort] == params[:sort])
        if (params[:redirected] == nil)
          session.delete(:sort)
        end
      else
        session[:sort] = params[:sort]
      end
      
    end
    if (params[:ratings] != nil)
        session[:ratings] = params[:ratings]
    end
    if (session[:ratings] != nil && params[:ratings] == nil)
      flash.keep
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings], :redirected => true)
    end
     if (session[:sort] != nil && params[:sort] == nil)
      flash.keep
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings], :redirected => true)
    end
    if (session[:ratings] == nil)
      @movies = Movie.all
    else
      @movies = Movie.where(rating: session[:ratings].keys)
    end
    if (session[:sort] != nil) 
     @movies = @movies.order(session[:sort])
    end
    @all_ratings = {}
    Movie.ratings().each do |rating|
      val = (session[:ratings] == nil) 
      val2 = val && (session[:ratings].include? rating)
      puts(val)
      puts(val2)
      @all_ratings[rating.to_sym()] = val || val2
    end
    puts(@all_ratings)
    #if (session[:ratings] != nil)
     # s = "rating in ("
      #i = 1
      #session[:ratings].each do |key, value| 
       # s = s + key
      #  if (i != session[:ratings].count)
       #   s = s + ", "
        #  i = i + 1
        #end
      
      #end
      #s = s + ")"
      
    

    
  end

  def new
    # default: render 'new' template
  end
  def sort
    redirect_to movies_path(:sort => params[:sort])
    return
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
    return
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
