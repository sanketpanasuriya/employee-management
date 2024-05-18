module ApplicationHelper
  def alert_bootstrap_class(alert_type)
    case alert_type
    when 'notice'
      'alert-info'
    when 'success'
      'alert-success'
    when 'error'
      'alert-danger'
    when 'warning'
      'alert-warning'
    else
      'alert-dark'
    end
  end
end
