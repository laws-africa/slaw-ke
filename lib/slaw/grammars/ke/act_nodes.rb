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

        class PrefaceStatement < Treetop::Runtime::SyntaxNode
          def to_xml(b, idprefix, i=0)
            if longtitle
              longtitle.to_xml(b, idprefix)
            else
              b.p { |b| clauses.to_xml(b, idprefix) }
            end
          end

          def longtitle
            self.content if self.content.is_a? LongTitle
          end

          def clauses
            content.clauses if content.respond_to? :clauses
          end
        end

        class LongTitle < Treetop::Runtime::SyntaxNode
          def to_xml(b, idprefix, i=0)
            b.longTitle { |b|
              b.p { |b| clauses.to_xml(b, idprefix) }
            }
          end
        end

        class Bold < Treetop::Runtime::SyntaxNode
          def to_xml(b, idprefix)
            b.b(content.text_value)
          end
        end

        class Italics < Treetop::Runtime::SyntaxNode
          def to_xml(b, idprefix)
            b.i(content.text_value)
          end
        end
        
      end
    end
  end
end
