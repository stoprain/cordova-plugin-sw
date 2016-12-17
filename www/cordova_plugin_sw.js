/*global cordova, module*/

module.exports = {
    album: function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "cordova_plugin_sw", "album", []);
    }
};
