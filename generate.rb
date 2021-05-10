require 'json'

data = JSON.parse(ARGF.read)
claims = data['receivedClaims'].map { |c|
  {
    title: c['asset']['srMetadata']['title'],
    artists: c['asset']['srMetadata']['artists'] * ', ',
    start: c['matchDetails']['longestMatchStartTimeSeconds'].to_i,
    length: c['matchDetails']['longestMatchDurationSeconds'].to_i,
  }
}

events = claims.flat_map { |c| [
  { type: :start, claim: c, time: c[:start] },
  { type: :end, claim: c, time: c[:start] + c[:length] },
] }.sort_by { |c| c[:time] }

current_claim = nil
timeline = [{ claim: nil, time: 0 }]

events.each do |x|
  case x[:type]
  when :start
    current_claim = x[:claim]
    timeline << { claim: x[:claim], time: x[:time] }
  when :end
    if current_claim == x[:claim]
      timeline << { claim: nil, time: x[:time] }
      current_claim = nil
    end
  end
end

puts "(Content ID claims from YouTube)"
i = 0
timeline.each do |x|
  m, s = x[:time].divmod 60
  h, m = m.divmod 60
  puts "%02d:%02d:%02d | %s" % [h, m, s, x[:claim] ? "#{i += 1}. #{x[:claim][:artists]} — #{x[:claim][:title]}" : '[unclaimed segment]']
end