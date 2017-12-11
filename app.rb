require 'sinatra'
require 'sinatra/reloader' if development?
require 'dotenv/load'
require 'postmark'
require 'receipt_parser'

get '/' do
  "Hello World!"
end

post '/inbound' do
  request.body.rewind
  message = Postmark::Json.decode(request.body.read)
  recipient = message['From']

  return status 422 if recipient.nil?

  parser = ReceiptParser::Email::Parser.new(
    { html_body: message['HtmlBody'] }
  )
  result = parser.parse
  if result.success?
    text_body = "Extracted data:\n\nCoding view:\n\n" \
      "#{result.extracted_data}\n\nHuman view:\n\n#{result.to_s}"
    subject = 'Receipt parsing response'
  else
    text_body = "Error!\n#{result.error.message}"
    subject = 'Error on parsing receipt'
    error_message = text_body + "\n\nPostmark received message:\n\n#{message}"
    notify_team(error_message)
  end

  send_email(recipient, subject, text_body)

  status 200
end

not_found do
  "Huh, nothing here."
end

error do
  status 500
  "Yikes, internal error."
end

def send_email(recipient, subject, text_body)
  client = Postmark::ApiClient.new(ENV['POSTMARK_API_KEY'])

  client.deliver(
    from: ENV['POSTMARK_SENDER'],
    to: recipient,
    subject: subject,
    text_body: text_body
  )
end

def notify_team(error_message)
  recipients = ENV['TEAM_EMAILS'].split(',')
  subject = 'There was an error on ReceiptParser'

  send_email(recipients, subject, error_message)
end
