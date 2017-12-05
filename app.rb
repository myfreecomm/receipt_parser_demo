require 'sinatra'
require 'sinatra/reloader' if development?
require 'postmark'

get '/' do
  "Hello World!"
end

post '/inbound' do
  # parsing input email
  request.body.rewind
  message = Postmark::Json.decode(request.body.read)

  # TODO parse the input with receipt_parser and send email with the output

  # sending response email
  client = Postmark::ApiClient.new(ENV['POSTMARK_API_KEY'])
  # client.deliver(
  #   from: ENV['POSTMARK_SENDER'],
  #   to: "Leonard Hofstadter <leonard@bigbangtheory.com>",
  #   subject: "Re: Come on, Sheldon. It will be fun.",
  #   text_body: "That's what you said about the Green Lantern movie. You were 114 minutes of wrong."
  # )

  "Receipt parsed successfully and response email sent to foo@bar.com"
end

not_found do
  "Huh, nothing here."
end

error do
  status 500
  "Yikes, internal error."
end
