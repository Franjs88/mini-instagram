/**
 * Created by fran on 23/11/14.
 */

$('#login').on('click', function (e) {
   /* $.ajax({
        url: "http://localhost:8080/submit",
        type: "POST",
        data: {
            'email': email,
            'password': password
        },
        cache: false,
        success: function() {
            // Success message
            $('#success').html("<div class='alert alert-success'>");
            $('#success > .alert-success').html("<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;")
                .append("</button>");
            $('#success > .alert-success')
                .append("<strong>Tu reserva se ha realizado con éxito. En unos minutos nuestro RR.PP se pondrá en contacto contigo por el número que nos has facilitado! </strong>");
            $('#success > .alert-success')
                .append('</div>');

            //clear all fields
            $('#contactForm').trigger("reset");
        },
        error: function() {
            // Fail message
            $('#success').html("<div class='alert alert-danger'>");
            $('#success > .alert-danger').html("<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;")
                .append("</button>");
            $('#success > .alert-danger').append("<strong>Lo sentimos " + firstName + ", parece que el servicio está temporalmente fuera de servicio. Intentalo más tarde!");
            $('#success > .alert-danger').append('</div>');
            //clear all fields
            $('#contactForm').trigger("reset");
        }

    })
    */
})