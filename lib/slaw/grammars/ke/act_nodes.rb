require 'slaw/grammars/za/act_nodes'

module Slaw
  module Grammars
    module KE
      module Act
        class Act < Slaw::Grammars::ZA::Act::Act
        end

        class Crossheading < Treetop::Runtime::SyntaxNode
          def to_xml(b, idprefix, i=0)
            b.hcontainer(name: 'crossheading') { |b|
              b.heading { |b|
                clauses.to_xml(b, idprefix)
              }
            }
          end
        end
      end
    end
  end
end
