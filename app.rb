require 'sinatra'
require 'sinatra/reloader' if development?
require 'dotenv/load'
require 'postmark'

get '/' do
  "Hello World!"
end

post '/inbound' do
  # parsing input email
  request.body.rewind
  message = Postmark::Json.decode(request.body.read)
  recipient = message['From']

  # parse the input with receipt_parser and send email with the output
  # parser = ReceiptParser::Email::Parser.new(message)
  # result = parser.parse
  # text_body = "Extracted data:\n Coding view: #{result.extracted_data}\n" \
  #   "Human view: #{result.extracted_data.to_s}\n Error message: " \
  #   "#{result.error.message}"
  text_body = "Hey there, i'm listening you!"
  # sending response email
  client = Postmark::ApiClient.new(ENV['POSTMARK_API_KEY'])
  client.deliver(
    from: ENV['POSTMARK_SENDER'],
    to: recipient,
    subject: 'Parsing response',
    text_body: text_body
  )

  "Receipt parsed successfully and response email sent to #{message['From']}"
end

not_found do
  "Huh, nothing here."
end

error do
  status 500
  "Yikes, internal error."
end
