class TargetedViewTest
  def self.perform(named_queues)
    named_queues.each do |interest, array|
      tops = {
          general: array[0][CONST::IMPORTANCE]+1,
          targeted: array[1][CONST::IMPORTANCE]+1
      }
      eofs = {
          general: false,
          targeted: false
      }
      array.each_with_index do |item, index|
        type = index % 2 == 0 ? :general : :targeted

        # targeted items must include the interest, general - don't
        if item[CONST::INTERESTS].include?(interest) == (type == :targeted)
          # mustn't have EOF
          raise 'invalid ordering' if eofs[type]
        else
          unless eofs[type]
            eofs[type] = true
            raise 'invalid ordering' if eofs.values == [true, true]
          end

          if eofs[type]
            # this situation is valid, one queue is smaller than another
            type = type == :general ? :targeted : :general
          else
          end
        end

        raise 'test failed' if item[CONST::IMPORTANCE] > tops[type]
        tops[type] = item[CONST::IMPORTANCE]
      end

    end

  end
end