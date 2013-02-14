require "documentation/markdown/base"

describe Documentation::Markdown::Base, "#header" do
  include_context "simple renderer"

  before(:each) do
    subject.stub(:process_header)
  end

  it "should slugify header titles" do
    subject.should_receive(:process_header).with("Hi & stuff", "hi-stuff", 1)

    subject.header("Hi & stuff", 1)
  end

  it "should append level 1 headers to the toc_root" do
    expect(subject.toc_root.children).to eq([])

    subject.header("Ohai", 1)

    expect(subject.toc_root.children.size).to eq(1)
    node = subject.toc_root.children.first

    expect(node.title).to    eq("Ohai")
    expect(node.slug).to     eq("ohai")
    expect(node.level).to    eq(1)
    expect(node.children).to eq([])
  end

  it "should create a path of nodes when increasing header level" do
    subject.header("One", 1)
    subject.header("Two", 2)
    subject.header("Three", 3)
    subject.header("Four", 4)

    expect(subject.toc_root.children.map(&:to_h)).to eq([
      {
        title: "One",
        slug:  "one",
        level: 1,
        children: [
          {
            title: "Two",
            slug:  "two",
            level: 2,
            children: [
              {
                title: "Three",
                slug:  "three",
                level: 3,
                children: [
                  {
                    title: "Four",
                    slug:  "four",
                    level: 4,
                    children: [],
                  }
                ]
              }
            ]
          }
        ]
      }
    ])
  end

  it "should create hierarchies of headers when levels vary" do
    subject.header("One", 1)
    subject.header("One.One", 2)
    subject.header("One.Two", 2)
    subject.header("One.Two.One", 3)
    subject.header("One.Two.One.One", 4)
    subject.header("One.Three", 2)
    subject.header("Two", 1)
    subject.header("Two.One", 2)
    subject.header("Two.One.One", 3)
    subject.header("Two.Two", 2)

    expect(subject.toc_root.children.map(&:to_h)).to eq([
      {
        title: "One",
        slug:  "one",
        level: 1,
        children: [
          {
            title: "One.One",
            slug:  "one-one",
            level: 2,
            children: [],
          },
          {
            title: "One.Two",
            slug:  "one-two",
            level: 2,
            children: [
              {
                title: "One.Two.One",
                slug:  "one-two-one",
                level: 3,
                children: [
                  {
                    title: "One.Two.One.One",
                    slug:  "one-two-one-one",
                    level: 4,
                    children: []
                  }
                ]
              }
            ]
          },
          {
            title: "One.Three",
            slug:  "one-three",
            level: 2,
            children: [],
          },
        ]
      },
      {
        title: "Two",
        slug:  "two",
        level: 1,
        children: [
          {
            title: "Two.One",
            slug:  "two-one",
            level: 2,
            children: [
              {
                title: "Two.One.One",
                slug:  "two-one-one",
                level: 3,
                children: [],
              }
            ]
          },
          {
            title: "Two.Two",
            slug:  "two-two",
            level: 2,
            children: [],
          },
        ],
      }
    ])
  end

  describe "error cases" do

    it "should complain about the first headline not being level 1" do
      expect { subject.header("Foo", 2) }.to raise_error(Documentation::Markdown::Base::SyntaxError, /header.*level/i)
    end

    it "should complain about out of order headlines" do
      subject.header("One", 1)
      subject.header("One.One", 2)

      expect { subject.header("One.Two.One.One", 4) }.to raise_error(Documentation::Markdown::Base::SyntaxError, /header.*level/i)
    end

  end

end
