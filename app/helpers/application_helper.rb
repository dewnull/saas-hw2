module ApplicationHelper
  def sortable(column, title = nil, link_class= nil)
  title ||= column.titleize
  direction = column == params[:sort] && params[:direction] == "asc" ? "desc" : "asc"
    link_to title,{ :sort => column, :direction => direction}, {:id => link_class}
 end
end
