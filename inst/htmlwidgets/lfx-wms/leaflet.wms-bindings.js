LeafletWidget.methods.addWMS = function(baseUrl, layers, group, options, popupOptions) {

  if(options && options.crs) {
    options.crs = LeafletWidget.utils.getCRS(options.crs);
  }

  // Hijacked showFeatureInfo-function to extend for Shiny
  L.wms.Source = L.wms.Source.extend({
    'showFeatureInfo': function(latlng, info) {
        // Hook to handle displaying parsed AJAX response to the user
        if (!this._map) {
            return;
        }
        this._map.openPopup(info, latlng, popupOptions);

        // Adaptation for R/Shiny
        if (HTMLWidgets && HTMLWidgets.shinyMode) {
          latlng.info = info;
          Shiny.setInputValue(this._map.id+"_wms_click", latlng, {priority: "event"});
        }
    }
  });


  // Add WMS source
  var source = L.wms.source(baseUrl, options);

  // Add layers
  if (typeof(layers) === "string") {
    var layer = source.getLayer(layers);
    this.layerManager.addLayer(layer, "tile", layers, group);
  } else {
    layers.forEach(e => this.layerManager.addLayer(
      source.getLayer(e), "tile", e, e));
  }
};