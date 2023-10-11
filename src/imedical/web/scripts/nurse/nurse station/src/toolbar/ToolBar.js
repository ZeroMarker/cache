

(function () {
  var ToolBar = {
    name: 'ToolBar',
    template: '<ul class="toolBar">' +
    '<slot />' +
    '</ul>'
  };
  if (!window.components) {
    window.components = {};
  }
  window.components.YLToolBar = ToolBar;
})();


