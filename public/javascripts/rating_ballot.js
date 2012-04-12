$(document).ready(function() {
    // Submits the form (saves data) after user makes a change.
    $('form.rating_ballot').change(function() {
        $('form.rating_ballot').submit();
    });
});