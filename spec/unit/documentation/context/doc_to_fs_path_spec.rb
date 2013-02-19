require "documentation/context"

describe Documentation::Context, "#doc_to_fs_path" do
  include_context "default context"

  it "should convert the root to README.md" do
    expect(subject.doc_to_fs_path("")).to eq("README.md")
  end

  it "should treat files as files" do
    expect(subject.doc_to_fs_path("foo")).to eq("foo.md")
    expect(subject.doc_to_fs_path("bar/barf")).to eq("bar/barf.md")
  end

  it "should treat paths with a trailing slash as directories" do
    expect(subject.doc_to_fs_path("foo/")).to eq("foo/README.md")
    expect(subject.doc_to_fs_path("bar/barf/")).to eq("bar/barf/README.md")
  end

end
