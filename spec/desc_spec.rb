require 'spec_helper'
require 'suitable_formatter/formatter'

describe Formatter::Desc do
    describe '#format' do
        it 'Successfully Descending by field' do
            expect(Formatter::Desc.new(0).format([['john', '1'], ['bob', '2']])).to eq [['john', '1'], ['bob', '2']]
            expect(Formatter::Desc.new(1).format([['john', '1'], ['bob', '2']])).to eq [['bob', '2'], ['john', '1']]
        end
    end
end
