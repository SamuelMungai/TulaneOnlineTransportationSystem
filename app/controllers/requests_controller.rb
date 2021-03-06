class RequestsController < ApplicationController
    helper_method :sort_column, :sort_direction
    
    def index 
        @requests = Request.order(sort_column + " " + sort_direction).paginate(per_page: 15, page: params[:page])
        respond_to do |format|
            format.html
            format.csv { send_data @requests.to_csv }
    end
    end
    
    def accepted
        @true = true
        @request = Request.find(params[:id])
        Mailer.email(@request).deliver_now
    end
    
    helper_method :accepted
    
    def new
       @request = Request.new
    end
    
    def create 
        @request = current_user.requests.new(request_params) 
        if @request.save 
            @request.Email = current_user.email
            @request.save
            flash[:notice] = "Request submitted!"
            redirect_to '/requests' 
        else 
            flash[:notice] = "Please submit all fields!"
            render 'new'
        end
    end
   
   def delete
       @request = Request.find(params[:id])
       @request.destroy
       redirect_to requests_path
   end
   
   def show
       @request = Request.find(params[:id])
   end
   
   def update
       @request = Request.find(params[:id])
   end
   
   def status
      @request = Request.find(params[:id])
      Request.update(@request, :status => params[:status])
      Mailer.email(@request).deliver_now
      redirect_to '/requests'
   end
   
   
   
   
    private
    def request_params
        params.require(:request).permit(:user_id, :DOLocation, :PULocation, :PUDate, :ArrivalTime, :DepartureTime, :Email, :StudentID, :status)
    end
    
    def sort_column
        #Request.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
        params[:sort] || "created_at"
    end
  
    def sort_direction
        %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
    puts "Current user:"
end