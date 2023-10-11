(function () {
  var tabItem = {
    name: 'tabItem',
    props: [
      'data',
      'lineBorder',
      'color'
    ],
    template: '<li class="tabItem"' +
    ' :class="{ \'is-selected\':ifSelected }"' +
    ' @click="selectTab"' +
    ' :style="getLiStyle">' +
    '<sup class="tabItem__badge"' +
    ' v-if="data.badge">' +
    '</sup>' +
    '<a class="tabItem__link"' +
    ' href="#"' +
    ' :style="getAStyle">{{data.name}}</a>' +
    '</li>',
    computed: {
      ifSelected: function () {
        return this.$parent.selectedTabIndex !== null ? (this.$parent.selectedTabIndex === this.data.index) : (this.$parent.defaultSelectedTabIndex ===
          this.data.index);
      },
      getLiStyle: function () {
        var style = {
          borderRight: this.lineBorder,
        };
        return style;
      },
      getAStyle: function () {
        var style = {
          color: !this.ifSelected ? this.color : '',
        };
        return style;
      },
    },
    methods: {
      selectTab: function () {
        this.$emit('selectTab', this.data.index);
      },
    }
  };
  if (!window.components) {
    window.components = {};
  }
  window.components.YLTabItem = tabItem;
})();

