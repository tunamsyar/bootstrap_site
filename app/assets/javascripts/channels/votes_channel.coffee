votesChannelFunctions = () ->

  if $('.comments-index').length > 0
    App.votes_channel = App.cable.subscriptions.create {
      channel: "VotesChannel"
    },

    connected: () ->
      console.log("connected")

    disconnected: () ->

    received: (data) ->
      console.log("voted")
      $(".comment[data-id=#{data.comment_id}] .votes").html(data.value)
      $(".comment[data-id=#{data.comment_id}] .votes").html(data.value1)
      $(".comment[data-id=#{data.comment_id}] .votes").html(data.value2)

$(document).on 'turbolinks:load', votesChannelFunctions
