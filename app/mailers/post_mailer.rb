class PostMailer < ApplicationMailer

  def post_found(title, url)
    @post_title = title
    @post_url = url

    mail to: ENV["RECEIVING_EMAIL"],
    subject: ENV["EMAIL_SUBJECT"]
  end
  
end
