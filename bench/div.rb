require_relative "../lib/easy_money"

require "benchmark"
n = 1E5.to_i.freeze
Benchmark.bm do |x|
  x.report { n.times { EasyMoney.new(1337) / 100 } } # fastest
  x.report { n.times { EasyMoney.new(1337) / 100.0 } }
  x.report { n.times { EasyMoney.new(1337) / "100.0" } }
end

require "stackprof"
StackProf.run(mode: :cpu, out: "stackprof.dump") do
  n.times { EasyMoney.new(1337) / 100 }
end

