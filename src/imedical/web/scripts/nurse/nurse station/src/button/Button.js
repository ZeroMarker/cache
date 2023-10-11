
(function () {
  var Button = {
    name: 'Button',
    props: [
      'data',
      'width',
      'color',
      'border',
      'iconColor',
      'iconBorderRight',
      'backgroundColor',
      'iconClass',
      'iconBackgroundColor',
      'hover'
    ],
    template: '<a class="commonButton"' +
    ' :class="{\'is-hover\':hover ,\'is-common\':!hover}"' +
    ' href="#"' +
    ' @click="clickButton"' +
    ' :style="getStyle">' +
    '<span class="commonButton__iconWraper"' +
    ' v-if="iconClass"' +
    ' :style="getIconStyle">' +
    '<i class="commonButton__icon"' +
    ' :class="iconClass" />' +
    '</span>' +
    '<slot/>' +
    '<i class="commonButton__whiteLine"' +
    ' v-if="hover" />' +
    '<div class="commonButton__hoverContent">' +
    '<slot name="hoverContent" />' +
    '</div>' +
    '</a>',
    computed: {
      getStyle: function () {
        var style = {};
        style.backgroundColor = '#ffffff';
        style.border = '1px solid #40a2de';
        style.color = '#000000';
        if (!this.iconClass) {
          style.paddingLeft = '8px';
        }
        if (this.width) {
          style.width = this.width - 18 + 'px';
        }
        if (this.backgroundColor) {
          style.backgroundColor = this.backgroundColor;
        }
        if (this.color) {
          style.color = this.color;
        }
        if (this.border) {
          style.border = this.border;
        }
        return style;
      },
      getIconStyle: function () {
        var style = {};
        style.backgroundColor = '#378ec4';
        style.color = '#ffffff';
        if (this.iconBackgroundColor) {
          style.backgroundColor = this.iconBackgroundColor;
        }
        if (this.iconColor) {
          style.color = this.iconColor;
        }
        if (this.iconBorderRight) {
          style.borderRight = this.iconBorderRight;
        }
        return style;
      },
    },
    methods: {
      clickButton: function () {
        this.$emit('click', this);
      },
      mouseover: function () {
        this.$emit('mouseover', this);
      },
      mouseout: function () {
        this.$emit('mouseout', this);
      },
    }
  };
  if (!window.components) {
    window.components = {};
  }
  window.components.YLButton = Button;
})();



