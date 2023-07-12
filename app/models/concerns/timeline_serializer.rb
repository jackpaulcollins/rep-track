module TimelineSerializer
  extend ActiveSupport::Concern

  def serialize_along_timeline(points_by_day)
    accumulated_points = 0
    points_by_day.each_with_object(Hash.new(0)) do |(date, points), hash|
      # the first iteration we know there's no previous days
      if hash.empty?
        # set the first date we see to the points earned that day
        hash[date] = points
        # add to the accumlation
        accumulated_points += points
        # go to the next date we see
        next
      # if the next date we see has a gap +1 day from the last date
      elsif date > hash.keys.last + 1.day
        # fill in the in between days based on the last date we saw, up to the date we have with the current accumulation since we know they didn't work those days
        (hash.keys.last + 1.day...date).each { |gap_day| hash[gap_day] = accumulated_points }
        # then set the date we do have work on with the accumulation + points from that date
        hash[date] = accumulated_points + points
        # register the accumulation
        accumulated_points += points
        # go to next record
        next
      else
        # if the record is sequential to the previous, handle as expected
        hash[date] = accumulated_points + points
        accumulated_points += points
      end
      hash[date] = accumulated_points
    end
  end
end
