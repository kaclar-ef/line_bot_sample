class WebhookController < ApplicationController

  CHANNEL = '#'

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']

    # リクエストがLINEのプラットフォームから送られたことを検証
    unless line_client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end

    evants = line_client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MeesageType::Text
          post_message(event.message['text'])
        when Line::Bot::Event::MessageType::Image
          image_response = line_client.get_message_content(event.message['id'])
          file = File.open("/tmp/#{Time.current.strftime('%Y%m%d%H%M%S')}.jpg", 'w+b')
          file.write(image_response.body)

          slack_client.files_upload(channels: CHANNEL,
                                    file: Faraday::UploadIO.new(file.path, 'image/jpeg'),
                                    as_user: true,
                                    title: File.basename(file.path),
                                    filename: File.basename(file.path),
                                    initial_comment: '写真が送信されました')
        when Line::Bot::Event::MessageType::Video
          post_message('ビデオが送信されました')
        when Line::Bot::Event::MessageType::Sticker
          post_message('スタンプが送信されました')
        end
      end
    end
    
    head :ok
  end

  private
  def line_client
    @line_client ||= Line::Bot::Client.new do |config|
      config.channel_id = 1656825122
      config.channel_secret = '7a3a022d6ab306d97c25c2db0eba9ddb'
      config.channel_token = 'pqFmVsAQ1Q6vLS583BoAq7moXSnv8tzT5Xbvz/fHoRjy/JMUmB5PeY+BBy6Mhd4+RxpfXVETUxcopcBXn/dRo2kq3YFIK66ukNwgglfYWuFonGmAsazL7cOnjosnKeCpQf0C1EuUzCITbynGqknS8QdB04t89/1O/w1cDnyilFU='
    end
  end

  def slack_client
    @slack_client ||= Slack::Web::Client.new
  end

  def post_message(text)
    slack_client.chat_postMessage(channel: CHANNEL, text: text)
  end
end
