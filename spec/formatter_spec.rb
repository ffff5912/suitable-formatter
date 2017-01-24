require 'spec_helper'
require 'suitable_formatter/formatter'

describe Formatter::Desc do
    describe '#format' do
        before do
            @desc = Formatter::Desc.new(1)
        end

        it 'should being able to descend on the basis of the field' do
            expect(@desc.format([['john', '1'], ['bob', '2']])).to eq [['bob', '2'], ['john', '1']]
        end
    end
end
