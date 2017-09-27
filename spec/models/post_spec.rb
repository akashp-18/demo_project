require 'rails_helper'
require 'factory_girl'
RSpec.describe Post, type: :model do
  
  it "is valid with a title and body" do
    post = Post.new(
    title: "Aron Sumner",
    body:"dottle-nouveau-pavilion-tights-furze",
    )
    expect(post).to be_valid
  end

  # it "is invalid without a title" do
  #   post = Post.new(
  #   title: nil)
  #   post.valid?
  #   expect(post.errors[:title]).to include("can't be blank")
  # end
  
  it "cant have nil comments" do
    post = Post.new(title:"abcdef",body:"dottle-nouveau-pavilion-tights-furze",)
    post.save!
    comment = post.comments.create!(body: nil)
    comment.valid?
  end

  it "orders them in chronologically" do
    post = Post.new(title:"abcdef",body:"dottle-nouveau-pavilion-tights-furze",)
    post.save!
    comment1 = post.comments.create!(:body => "first comment")
    comment2 = post.comments.create!(:body => "second comment")
    expect(post.reload.comments).to eq([comment1, comment2])
  end
  

  it "has a valid factory" do
    post = FactoryGirl.create(:post)
    post.valid?
  end
  
  it "does not allow duplicate title per post" do
    post1 = FactoryGirl.create(:post, title: "abcdef",body: "abc")
    post2 = FactoryGirl.create(:post,title: "abcdef",body: "abc")
    post2.not_valid?
  end

  it "is invalid without a title" do
    post = FactoryGirl.build(:post, title: nil)

    post.valid?
    expect(post.errors[:title]).to include("can't be blank")

  end

end  