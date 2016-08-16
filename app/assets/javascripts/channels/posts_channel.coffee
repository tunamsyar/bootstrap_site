postsChannelFunctions = () ->

  checkMe = (comment_id, username) ->
    if $('meta[name=wizardwonka]').length < 1
      $(".comment[data-id=#{comment_id}] .control-panel").remove()
    $(".comment[data-id=#{comment_id}]").removeClass("hidden")

  if $('.comments-index-container').length > 0
    App.posts_channel = App.cable.subscriptions.create {
      channel: "PostsChannel"
    },
    connected: () ->
      console.log("I'm loaded")

    disconnected: () ->

    received: (data) ->
      debugger
      if $('.comments.index').data().id == data.post.id
        $('#comments').append(data.partial)
        checkMe(data.comment.id)

$(document).on 'turbolinks:load', postsChannelFunctions
