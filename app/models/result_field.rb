class ResultField < ActiveRecord::Base
  belongs_to :result, :dependent => :delete
  belongs_to :xpath, :dependent => :delete

end
