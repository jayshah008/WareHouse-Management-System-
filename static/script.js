// $('#deleteModal').on('show.bs.modal', function (e) {
//     var product_id = $(e.relatedTarget).data('product-id');
//     $('#deleteProductButton').attr('href', '/delete_product/' + product_id);
// });

// Add this code to your script.js file

$(document).ready(function() {
    $('.delete-product').on('click', function() {
        var productId = $(this).data('product-id');
        if (productId !== undefined) {
            $.ajax({
                url: '/delete_product/' + productId,
                type: 'GET',
                success: function(response) {
                    location.reload();
                },
                error: function(error) {
                    console.error('Error deleting product:', error);
                }
            });
        }
    });
});


$('#addProductModal').on('show.bs.modal', function (e) {
    // Add any code you need when the modal is shown
});
