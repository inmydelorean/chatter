# frozen_string_literal: true

class PostsReflex < ApplicationReflex
  include CableReady::Broadcaster
  include ActionView::RecordIdentifier

  def repost
    post = Post.find(element.dataset[:id])
    post.increment! :reposts_count
    cable_ready["feed"].text_content(
        selector: "##{dom_id(post, "reposts")}",
        text: post.reposts_count
    )
    cable_ready.broadcast
  end

  def like
    post = Post.find(element.dataset[:id])
    post.increment! :likes_count
    cable_ready["feed"].text_content(
        selector: "##{dom_id(post, "likes")}",
        text: post.likes_count
    )
    cable_ready.broadcast
  end
  # Add Reflex methods in this file.
  #
  # All Reflex instances expose the following properties:
  #
  #   - connection - the ActionCable connection
  #   - channel - the ActionCable channel
  #   - request - an ActionDispatch::Request proxy for the socket connection
  #   - session - the ActionDispatch::Session store for the current visitor
  #   - url - the URL of the page that triggered the reflex
  #   - element - a Hash like object that represents the HTML element that triggered the reflex
  #
  # Example:
  #
  #   def example(argument=true)
  #     # Your logic here...
  #     # Any declared instance variables will be made available to the Rails controller and view.
  #   end
  #
  # Learn more at: https://docs.stimulusreflex.com
end
