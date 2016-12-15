class Request < ActiveRecord::Base
    belongs_to :user
    has_many :locations
    
    validates :PULocation, :presence => true
    validates :DOLocation, :presence => true
    validates :PUDate, :presence => true
    validates :ArrivalTime, :presence => true
    validates :DepartureTime, :presence => true
    validate :not_past_date

    def not_past_date
        if self.PUDate < Date.today.to_s && self.PUDate.blank? == false
            errors.add(:date, 'not in past')
        end
    end
end
