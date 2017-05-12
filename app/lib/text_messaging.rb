class TextMessaging
  def self.send_message(options)
    if ENV['TWILLIO_ID'] && Rails.env != 'test'
      @client = Twilio::REST::LookupsClient.new
      number = @client.phone_numbers.get(options[:to], country_code: 'GB')

      if number.country_code == 'GB'
        @client = Twilio::REST::Client.new
        @client.messages.create(
          options.merge(from: '+441133207067')
        )
      end
    end
  end
end
