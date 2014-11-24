/**
 * Created by fran on 23/11/14.
 */

$('#login').on('click', function (e) {
    // We send a post request
    $.ajax({
        url: "http://localhost:8080/signin",
        type: "POST",
        data: {
            'username': username,
            'password': password
        },
        cache: false,
        success: function() {
            //Wait for the auth success
        },
        error: function() {
            // Fail message
            $('#success').html("<div class='alert alert-danger'>");
            $('#success > .alert-danger').html("<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;")
                .append("</button>");
            $('#success > .alert-danger').append("<strong>Parece que la petición al servidor ha fallado, intentalo más tarde");
            $('#success > .alert-danger').append('</div>');
            //clear all fields
            $('#contactForm').trigger("reset");
        }

    })
})