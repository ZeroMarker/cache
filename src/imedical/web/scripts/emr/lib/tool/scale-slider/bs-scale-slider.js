/**
 *
 * @param el ����class='slider'��dom����
 * @param cfg {start: ���ŵ���С����, end: ���ŵ�������, initValue: ��ʼֵ, onChange: ֵ�ı�ʱ�Ļص�����}
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
      console.error("����Sliderʧ�ܣ����Ϸ���start��endֵ");
    }
    this.el = el;
    this.insertHtml();
    this.setPercent = function (value, transition) {
      if (value > 100 || value < 0) return false;
      this.percent = value;
      // ���ý�������䳤��
      $(".scale-slider-track", this.el).css("right", 100 - this.percent + "%");
      // ���û���λ��
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
    // ������꣬���ȸ������λ���ƶ����鲢���ö�Ӧ�ٷֱȣ�Ȼ���������ƶ����и���
    $(".scale-slider-container", this.el).mousedown(function (e) {
      // ������Ԫ���������
      var left = $(".scale-slider").offset().left;
      // �������ܳ���
      var width = $(".scale-slider").width();
      // ���ݵ���¼���x������м��㵱ǰ�İٷֱ�
      function update(eventX, transition) {
        var length = eventX - left;
        var percent;
        // �ٷֱȵķ�Χ��0~100
        if (length < 0) {
          percent = 0;
        } else if (length >= width) {
          percent = 100;
        } else {
          percent = (length / width) * 100;
        }
        // ����ᴥ�������ˢ��
        self.setValue(((end - start) * percent) / 100 + start, transition);
      }
      // ���ʱ�������õ�ǰ�ٷֱ�
      update(e.clientX, 0.3);
      // ��קʱ���������°ٷֱ�
      $(document).mousemove(function (e) {
        update(e.clientX);
      });
      // �ɿ�����ȡ���¼�����
      $(document).mouseup(function () {
        $(document).off("mousemove");
      });
    });
    $(".scale-slider-plus", this.el).mousedown(function (e) {
      // ��10Ϊ������������
      var percent = (parseInt(self.value / 10) + 1) * 10;
      self.setValue(percent, 0.3);
    });
    $(".scale-slider-minus", this.el).mousedown(function (e) {
      // ʮ��λ
      var ten = parseInt(self.value / 10);
      // ��10Ϊ�������м���
      if (self.value % 10 > 0) {
        self.setValue(ten * 10, 0.3);
      } else {
        self.setValue((ten - 1) * 10, 0.3);
      }
    });
  };
  this.init(el, cfg.start, cfg.end, cfg.initValue, cfg.onChange);
};
