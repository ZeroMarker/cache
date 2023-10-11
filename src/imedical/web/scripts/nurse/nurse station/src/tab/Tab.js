
(function () {
  var Tab = {
    name: 'Tab',
    props: [
      'data',
      'defaultSelectedTabIndex',
      'border',
      'backgroundColor',
      'fontColor',
      'color',
      'lineBorder'
    ],
    data: function () {
      return {
        selectedTabIndex: null,
      };
    },
    template: '<div class="tab">' +
    '<ul class="tab__body"' +
    ' :style = "getStyle" >' +
    '<span class="tab__rightSlot">' +
    '<slot name="rightHeadSlot"/>' +
    '</span>' +
    '<yl-tab-item @selectTab="selectTab"' +
    ' v-for="tabData of data"' +
    ' :key = "tabData.index"' +
    ' :lineBorder = "lineBorder"' +
    ' :color = "color"' +
    ' :data = "tabData">' +
    '</yl-tab-item>' +
    '</ul >' +
    '<slot name="contentSlot" />' +
    '</div >',
    methods: {
      selectTab: function (index) {
        var oldSelectedTabIndex = this.selectedTabIndex;
        this.selectedTabIndex = index;
        if (oldSelectedTabIndex !== index) {
          this.$emit('select-tab', index);
        }
      }
    },
    computed: {
      getStyle: function () {
        var style = {
          borderBottom: this.border,
          backgroundColor: this.backgroundColor,
        };
        return style;
      }
    },
    components: {
      'yl-tab-item': window.components.YLTabItem,
    }
  };
  if (!window.components) {
    window.components = {};
  }
  window.components.YLTab = Tab;
})();


