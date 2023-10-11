/**
 *
 * @param el 传入class='slider'的dom对象
 * @param cfg {start: 缩放的最小比例, end: 缩放的最大比例, initValue: 初始值, onChange: 值改变时的回调函数}
 */
var Slider = function (el, cfg) {
  Slider.prototype.insertHtml = function () {
    $(this.el).append(
      '<div class="scale-slider-minus"><div class="before"></div></div> <div class="scale-slider-container"> <div class="scale-slider-track"></div> <div class="scale-slider-handle"></div> </div> <div class="scale-slider-plus"><div class="before"></div><div class="after"></div></div> <span></span>'
    );
    document.createElement("div");
  };
  Slider.prototype.init = function (el, start, end, initValue, onChange) {
    if (!(end > start)) {
      console.error("创建Slider失败，不合法的start或end值");
    }
    this.el = el;
    this.insertHtml();
    this.setPercent = function (value, transition) {
      if (value > 100 || value < 0) return false;
      this.percent = value;
      // 设置进度条填充长度
      $(".scale-slider-track", this.el).css("right", 100 - this.percent + "%");
      // 设置滑块位置
      $(".scale-slider-handle", this.el).css("left", this.percent + "%");
      $(".scale-slider-track", this.el).css(
        "transition",
        "all " + transition + "s"
      );
      $(".scale-slider-handle", this.el).css(
        "transition",
        "all " + transition + "s"
      );
      $("span", this.el).text(this.value + "%");
    };
    this.setValue = function (value, transition) {
      if (value > end) {
        value = end;
      } else if (value < start) {
        value = start;
      }
      this.value = parseInt(value);
      var percent = ((value - start) / (end - start)) * 100;
      this.setPercent(percent, transition);
      onChange && onChange(value);
    };
    this.setValue(initValue);
    var self = this;
    // 按下鼠标，首先根据鼠标位置移动滑块并设置对应百分比，然后跟随鼠标移动进行更新
    $(".scale-slider-container", this.el).mousedown(function (e) {
      // 滑动条元素左端坐标
      var left = $(".scale-slider").offset().left;
      // 滑动条总长度
      var width = $(".scale-slider").width();
      // 根据点击事件的x坐标进行计算当前的百分比
      function update(eventX, transition) {
        var length = eventX - left;
        var percent;
        // 百分比的范围是0~100
        if (length < 0) {
          percent = 0;
        } else if (length >= width) {
          percent = 100;
        } else {
          percent = (length / width) * 100;
        }
        // 这里会触发界面的刷新
        self.setValue(((end - start) * percent) / 100 + start, transition);
      }
      // 点击时立刻设置当前百分比
      update(e.clientX, 0.3);
      // 拖拽时跟随鼠标更新百分比
      $(document).mousemove(function (e) {
        update(e.clientX);
      });
      // 松开鼠标后取消事件监听
      $(document).mouseup(function () {
        $(document).off("mousemove");
      });
    });
    $(".scale-slider-plus", this.el).mousedown(function (e) {
      // 以10为步长进行增加
      var percent = (parseInt(self.value / 10) + 1) * 10;
      self.setValue(percent, 0.3);
    });
    $(".scale-slider-minus", this.el).mousedown(function (e) {
      // 十分位
      var ten = parseInt(self.value / 10);
      // 以10为步长进行减少
      if (self.value % 10 > 0) {
        self.setValue(ten * 10, 0.3);
      } else {
        self.setValue((ten - 1) * 10, 0.3);
      }
    });
  };
  this.init(el, cfg.start, cfg.end, cfg.initValue, cfg.onChange);
};
