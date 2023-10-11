

(function () {
  var ToolBarItem = {
    name: 'ToolBarItem',
    props: [
      'img',
    ],
    template: '<li class="toolBarItem"' +
    ' @click="clickToolBarItem">' +
    '<a class="toolBarItem__body"' +
    'href="#">' +
    '<p>' +
    '<img class="toolBarItem__img"' +
    ' :src="img" />' +
    '</p>' +
    '<p class="toolBarItem__text">' +
    '<slot></slot>' +
    '</p>' +
    '</a>' +
    '</li >',
    methods: {
      clickToolBarItem: function () {
        this.$emit('click-tool-bar-item', this);
      },
    }
  };
  if (!window.components) {
    window.components = {};
  }
  window.components.YLToolBarItem = ToolBarItem;
})();


