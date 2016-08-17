postsChannelFunctions = () ->

  checkMe = (comment_id, username) ->
    if $('meta[name=wizardwonka]').length < 1
      $(".comments[data-id=#{comment_id}] .control-panel").remove()
    $(".comments[data-id=#{comment_id}]").removeClass("hidden")


  if $('.comments.index').length > 0
    App.posts_channel = App.cable.subscriptions.create {
      channel: "PostsChannel"
    },

    connected: () ->
      console.log("I'm loaded")

    disconnected: () ->

    received: (data) ->
      if $('.comments.index').data().id == data.post.id
        $('#comments').append(data.partial)
        checkMe(data.comment.id, data.username)
        console.log("IM DONE")

$(document).on 'turbolinks:load', postsChannelFunctions
