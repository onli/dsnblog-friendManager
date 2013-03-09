$('#addFriend').ready(function() {
    $('#addFriend').submit(function() {
        alert($('#id').text());
        $.ajax({
          type: "POST",
          url: "/subscriptions",
          data: { id: $('#id').text() },
          async: false
        })
    });
});