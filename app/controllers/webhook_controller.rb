class WebhookController < ApplicationController

  CHANNEL = '#line_bot_test2'

  def callback
    # body = request.body.read
    # signature = request.env['HTTP_X_LINE_SIGNATURE']

    # # リクエストがLINEのプラットフォームから送られたことを検証
    # unless line_client.validate_signature(body, signature)
    #   error 400 do 'Bad Request' end
    # end

    # evants = line_client.parse_events_from(body)
    # events.each do |event|
    #   case event
    #   when Line::Bot::Event::Message
    #     case event.type
    #     when Line::Bot::Event::MeesageType::Text
    #       post_message(event.message['text'])
    #     when Line::Bot::Event::MessageType::Image
    #       image_response = line_client.get_message_content(event.message['id'])
    #       file = File.open("/tmp/#{Time.current.strftime('%Y%m%d%H%M%S')}.jpg", 'w+b')
    #       file.write(image_response.body)

    #       slack_client.files_upload(channels: CHANNEL,
    #                                 file: Faraday::UploadIO.new(file.path, 'image/jpeg'),
    #                                 as_user: true,
    #                                 title: File.basename(file.path),
    #                                 filename: File.basename(file.path),
    #                                 initial_comment: '写真が送信されました')
    #     when Line::Bot::Event::MessageType::Video
    #       post_message('ビデオが送信されました')
    #     when Line::Bot::Event::MessageType::Sticker
    #       post_message('スタンプが送信されました')
    #     end
    #   end
    # end
    
    # head :ok
    # body = request.body.read

    # signature = request.env['HTTP_X_LINE_SIGNATURE']
    # unless client.validate_signature(body, signature)
    #   error 400 do 'Bad Request' end
    # end
  
    # events = client.parse_events_from(body)
    # events.each do |event|
    #   case event
    #   when Line::Bot::Event::Message
    #     case event.type
    #     when Line::Bot::Event::MessageType::Text
    #       message = {
    #         type: 'text',
    #         text: event.message['text']
    #       }
    #       client.reply_message(event['replyToken'], message)
    #     when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
    #       response = client.get_message_content(event.message['id'])
    #       tf = Tempfile.open("content")
    #       tf.write(response.body)
    #     end
    #   end
    # end
  
    # Don't forget to return a successful response
    "OK"
  end

  private
  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_id = ENV["LINE_CHANNEL_ID"]
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    end
  end

  def slack_client
    @slack_client ||= Slack::Web::Client.new
  end

  def post_message(text)
    slack_client.chat_postMessage(channel: CHANNEL, text: text)
  end
end
