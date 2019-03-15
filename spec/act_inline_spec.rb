# encoding: UTF-8

require 'slaw'

describe Slaw::ActGenerator do
  subject { Slaw::ActGenerator.new('ke') }

  def parse(rule, s)
    subject.builder.text_to_syntax_tree(s, {root: rule})
  end

  def should_parse(rule, s)
    s << "\n" unless s.end_with?("\n")
    tree = subject.builder.text_to_syntax_tree(s, {root: rule})

    if not tree
      raise Exception.new(subject.failure_reason || "Couldn't match to grammar") if tree.nil?
    else
      # count an assertion
      tree.should_not be_nil
    end
  end

  def to_xml(node, *args)
    b = ::Nokogiri::XML::Builder.new
    node.to_xml(b, *args)
    b.doc.root.to_xml(encoding: 'UTF-8')
  end

  #-------------------------------------------------------------------------------
  # italics and bold

  describe 'bold' do
    it 'should handle simple bold' do
      node = parse :block_paragraphs, <<EOS
      Hello **something bold** foo
EOS
      to_xml(node, "").should == '<paragraph id="paragraph-0">
  <content>
    <p>Hello <b>something bold</b> foo</p>
  </content>
</paragraph>'
    end

    it 'should handle complex bold' do
      # TODO
      pending 'this should be implemented'

      node = parse :block_paragraphs, <<EOS
      A [**link**](/a/b) with bold
      This is **bold with [a link](/a/b)** end
      A **[link**](/a/b)**
      A **[link**](/a/b)
EOS
      to_xml(node, "").should == '<paragraph id="paragraph-0">
  <content>
    <p>A <ref href="/a/b"><b>link</b></ref> with bold</p>
    <p>This is <b>bold with <ref href="/a/b">a link</ref></b> end</p>
    <p>A <b><ref href="/a/b">link**</ref></b></p>
    <p>A **<ref href="/a/b">link**</ref></p>
  </content>
</paragraph>'
    end

    it 'should not mistake bold' do
      node = parse :block_paragraphs, <<EOS
      Hello **something
      New line**
      **New line
      ****
      **
      *
      * * foo **
      * * foo * *
      ** foo * *
EOS
      to_xml(node, "").should == '<paragraph id="paragraph-0">
  <content>
    <p>Hello **something</p>
    <p>New line**</p>
    <p>**New line</p>
    <p>****</p>
    <p>**</p>
    <p>*</p>
    <p>* * foo **</p>
    <p>* * foo * *</p>
    <p>** foo * *</p>
  </content>
</paragraph>'
    end
  end

  describe 'italics' do
    it 'should handle simple italics' do
      node = parse :block_paragraphs, <<EOS
      Hello //something italics// foo
EOS
      to_xml(node, "").should == '<paragraph id="paragraph-0">
  <content>
    <p>Hello <i>something italics</i> foo</p>
  </content>
</paragraph>'
    end

    it 'should handle complex italics' do
      # TODO
      pending 'this should be implemented'

      node = parse :block_paragraphs, <<EOS
      A [//link//](/a/b) with italics
      This is //italics with [a link](/a/b)// end
      A //[link//](/a/b)//
      A //[link//](/a/b)
EOS
      to_xml(node, "").should == '<paragraph id="paragraph-0">
  <content>
    <p>A <ref href="/a/b"><i>link</i></ref> with italics</p>
    <p>This is <i>italics with <ref href="/a/b">a link</ref></i> end</p>
    <p>A <i><ref href="/a/b">link//</ref></i></p>
    <p>A //<ref href="/a/b">link//</ref></p>
  </content>
</paragraph>'
    end

    it 'should not mistake italics' do
      node = parse :block_paragraphs, <<EOS
      Hello //something
      New line//
      //New line
      ////
      //
      /
      / / foo //
      / / foo / /
      // foo / /
EOS
      to_xml(node, "").should == '<paragraph id="paragraph-0">
  <content>
    <p>Hello //something</p>
    <p>New line//</p>
    <p>//New line</p>
    <p>////</p>
    <p>//</p>
    <p>/</p>
    <p>/ / foo //</p>
    <p>/ / foo / /</p>
    <p>// foo / /</p>
  </content>
</paragraph>'
    end
  end

end
