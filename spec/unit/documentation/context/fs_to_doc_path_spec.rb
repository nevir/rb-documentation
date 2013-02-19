require "documentation/context"

describe Documentation::Context, "#fs_to_doc_path" do
  include_context "default context"

  it "should convert README.md to the root" do
    expect(subject.fs_to_doc_path("README.md")).to eq("")
  end

  it "should treat files as files" do
    expect(subject.fs_to_doc_path("foo.md")).to eq("foo")
    expect(subject.fs_to_doc_path("bar/barf.md")).to eq("bar/barf")
  end

  it "should treat directories as paths with a trailing slash" do
    expect(subject.fs_to_doc_path("foo/README.md")).to eq("foo/")
    expect(subject.fs_to_doc_path("bar/barf/README.md")).to eq("bar/barf/")
  end

end
