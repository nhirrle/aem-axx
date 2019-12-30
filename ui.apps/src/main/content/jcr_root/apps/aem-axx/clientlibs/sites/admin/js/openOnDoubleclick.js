(function () {
    document.addEventListener("DOMContentLoaded", function () {
        document.body.addEventListener('dblclick', function (e) {
            var item = e.target.closest("coral-columnview-item");
            if (!!item) {
                var itemID = item.dataset.foundationCollectionItemId;
                if (!!itemID) {
                    window.open("/editor.html" + itemID + ".html", '_blank');
                }
            }
        }, true);
    });
})();