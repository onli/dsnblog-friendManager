$('#addFriend').ready(function() {
    $('#addFriend').submit(function() {
        $.ajax({
          type: "POST",
          url: "/subscriptions",
          data: { id: $('#id').text() },
          async: false
        })
    });
});
