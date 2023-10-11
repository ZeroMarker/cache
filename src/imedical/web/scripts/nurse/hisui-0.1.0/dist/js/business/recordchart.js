/**
 * @author rw
 * @description 评估趋势图
 */
var myChart;

var GV = {
  SwitchInfo: new Object(),
  ArrSort: new Object(),
  PatNode: new Object(),
  TempNodeState: new Object(),
  Steps: ['banner', 'patlist']
}

$(function () {
  requestSwitch();
});

/**
 * @description: 获取开关配置数据
 */
function requestSwitch() {
  $cm({
    ClassName: 'NurMp.Service.Switch.Config',
    MethodName: 'GetSwitchValues',
    HospitalID: session['LOGON.HOSPID'],
    LocID: session['LOGON.CTLOCID'],
    GroupID: session['LOGON.GROUPID']
  }, function (switchInfo) {
    GV.SwitchInfo = switchInfo.Main;
    initLayout();
    if (typeof updatePatBanner == 'function') {
			updatePatBanner();
		} else {
			if (typeof updateStep == 'function') {
				updateStep('banner');
			}
		}
		if (typeof requestPatient == 'function') {
			requestPatient();
		} else {
			if (typeof updateStep == 'function') {
				updateStep('patlist');
			}
		}
		setTemplatesInfo();
    listenEvents();
  });
}

/**
 * @description: 初始化布局
 */
function initLayout() {
  if ($('#patientTree').length > 0) {
    // 当选择了就诊记录后，进入界面自动收缩面板
    if ((GV.SwitchInfo.PatListExpandFlag == 'true') && (!!EpisodeID)) {
      setTimeout(function () {
        $('.main-layout').layout('collapse', 'west');
      }, 200);
    }
  }
}

/**
 * @description: 自定义数据装载
 * @param {*} data
 */
function beforeLoadData(data) {
  GV.ArrSort = data.ArrSort;
}

/**
 * @description: 自定义病人tree加载成功后的处理
 * @param {*} node
 * @param {*} data
 */
function customPatTreeLoadSuccess(node, data) {
  GV.PatNode = $('#patientTree').tree('getSelected');
}

/**
 * @description: 自定义点击病人列表事件
 * @param {object} node
 */
function customClickPatient(node) {
  GV.PatNode = node;
  if (typeof updatePatBanner == 'function') {
    updatePatBanner();
  }
  if (typeof setTemplatesInfo == 'function') {
    setTemplatesInfo();
  }
  // 当选择了就诊记录后，进入界面自动收缩面板
  if ((GV.SwitchInfo.PatListExpandFlag == 'true') && (!!EpisodeID)) {
    $('.main-layout').layout('collapse', 'west');
  }
}

/**
 * @description: 自定义模板tree加载成功后的处理
 * @param {*} node
 * @param {*} data
 */
function customTempTreeLoadSuccess(node, data) {
  var _this = this;
  if (!$.isEmptyObject(GV.TempNodeState)) {
    $.each(GV.TempNodeState, function (id, state) {
      var selRoot = $(_this).tree('find', id);
      if (selRoot) {
        if (state == 'open') {
          $(_this).tree('expand', selRoot.target);
        } else {
          $(_this).tree('collapse', selRoot.target);
        }
      }
    });
  }
}

/**
 * @description 展示病人模板
 * @param {EpisodeID} 患者就诊号
 */
function setTemplatesInfo() {
  $HUI.combobox("#templateslist", {
    valueField: 'id',
    textField: 'text',
    defaultFilter: 4,
    loader: function (param, success, error) {
      $cm({
        ClassName: "NurMp.Service.Template.Chart",
        QueryName: "FindAddedTempList",
        HospitalID: session["LOGON.HOSPID"],
        EpisodeID: EpisodeID,
        IfSaved: '1',
        rows: 99999
      }, function (data) {
        success(data.rows);
        if (data.rows.length) {
          $("#templateslist").combobox("select", data.rows[0].id);
        } else if (myChart) {
          myChart.clear();
        }
      });
    },
    onSelect: function (record) {
      getChartInfo();
    }
  });
  $("#dayStartDate").dateboxq(
    "setValue",
    formatDate(new Date(new Date().getTime() - 1000 * 60 * 60 * 24 * 7))
  );
  $("#dayStartTime").timespinner("setValue", "00:01");
  $("#dayEndDate").dateboxq("setValue", formatDate(new Date()));
  $("#dayEndTime").timespinner("setValue", "23:59");
}
/**
 * @description: 事件监听
 */
function listenEvents() {
  $("#btnSearch").bind("click", function (e) {
    getChartInfo();
  });
}
/**
 * @description: 获取趋势图信息
 */
function getChartInfo() {
  if (!EpisodeID) {
    $.messager.popover({ msg: $g('请选择患者！'), type: "info" });
    return;
  }
  var templateId = $("#templateslist").combobox("getValue");
  if (!templateId) {
    $.messager.popover({ msg: $g('请选择模板！'), type: "info" });
    return;
  }
  var startDate = $("#dayStartDate").dateboxq("getValue");
  var startTime = $("#dayStartTime").timespinner("getValue");
  var endDate = $("#dayEndDate").dateboxq("getValue");
  var endTime = $("#dayEndTime").timespinner("getValue");
  $cm(
    {
      ClassName: "NurMp.Service.Template.Chart",
      MethodName: "getTemplatesChartInfo",
      EpisodeID: EpisodeID,
      startDate: startDate,
      startTime: startTime,
      endDate: endDate,
      endTime: endTime,
      NRCCRowId: templateId,
      HospitalID: session["LOGON.HOSPID"]
    },
    function (data) {
      if (typeof (data.chart) == "object") {
        drawChart(data);
      } else {
        $.messager.popover({ msg: $g('请检查病历表单分值字段是否配置正确！'), type: "info" });
      }
    }
  );
}
/**
 * @description: 画图
 */
function drawChart(api_data) {
  var chartInfo = api_data.chart;
  var config = api_data.config;
  // 基于准备好的dom，初始化echarts实例
  myChart = echarts.init(document.getElementById("chart"), null, {
    renderer: "cavans"
  });
  var seriesData = [];
  seriesData = chartInfo.data.map(function (data) {
    return [data.date, data.score, data.date, data.nurse, data.url];
  });
  var min = getTs(chartInfo.searchDate[0]);
  var max = getTs(chartInfo.searchDate[1]);
  // 指定图表的配置项和数据
  var option = {
    title: {
      left: "center",
      textStyle: {
        fontSize: 24,
        fontWeight: "lighter"
      },
      text: $g(chartInfo.title)
    },
    tooltip: {
      formatter: function (params) {
        var data = params.data || [0, 0, 0, 0, 0];
        return (
          data[2] +
          "<br/>" +
          data[1] +
          $g("分") +
          $g("评估人") +
          $g("：") +
          data[3] +
          "<br/>" +
          $g('双击查看详情')
        );
      }
    },
    xAxis: {
      name: $g('时间'),
      min: min,
      max: max,
      splitLine: { show: true },
      axisTick: { show: true, alignWithLabel: true },
      //splitNumber: 12,
      minInterval: 3600 * 24 * 1000,
      maxInterval: (Math.floor(max - min) / 86400000) > 14 ? 3600 * 24 * 7 * 1000 : 3600 * 24 * 1000,
      type: "time",
      axisLabel: {
        formatter: function (value) {
          var datetype = config.datetype;
          if (config.isShowMonth == "true") {
            datetype = "dd" + $g("日");
          } else if (config.isShowYear == "true") {
            datetype = datetype.replace(/yyyy年|yyyy-|yyyyyear|\/yyyy/g, "");
          }
          datetype = datetype.replace("yyyyy", "yyyy y").replace("mmm", "mm m").replace("ddd", "dd d");
          var date = getTi(value, datetype);
          return date;
        }
      }
    },
    yAxis: {
      name: $g('分数'),
      type: "value",
      max:
        config.adaptive != "0"
          ? function (value) {
            return value.max + 1;
          }
          : config.max,
      min:
        config.adaptive != "0"
          ? function (value) {
            return value.min > Number(config.interval)
              ? value.min - 1
              : 0;
          }
          : config.min,
      interval: Number(config.interval),
      scale: false,
      axisLine: { show: false },
      axisTick: { show: false }
    },
    series: [
      {
        data: seriesData, //[820, 932, 901, 934, 1290, 1330, 1320],
        type: "line",
        connectNulls: true,
        symbolSize: 8,
        barWidth: 30,
        label: { normal: { show: true, position: "top" } },
        itemStyle: { color: config.color },
        lineStyle: { color: config.color, width: 4 },
        markLine:
          (chartInfo.data.length === 0 || !config.warn)
            ? undefined
            : {
              silent: "false",
              label: {
                position: "end" //将警示值放在哪个位置，三个值“start”,"middle","end"  开始  中点 结束
              },
              lineStyle: {
                type: "dashed",
                color: "#FA3934"
              },
              data: [{ name: $g('预警值'), yAxis: config.warn }]
            }
      }
    ]
  };
  console.log(JSON.stringify(option));
  // 使用刚指定的配置项和数据显示图表。
  myChart.setOption(option);
  // 防止重复触发点击事件
  if (myChart._$handlers.dblclick) {
    myChart._$handlers.dblclick.length = 0;
  }
  // 处理点击事件并且跳转到相应的百度搜索页面
  myChart.on("dblclick", "series.line", function (params) {
    if (params.componentType == "series") {
      console.log(params);
      var linkUrl =
        window.location.href.split("csp")[0] + "csp/" + params.data[4];
      //        var linkUrl = linkUrl + "&MWToken=" + websys_getMWToken();  //增加MWToken
      try {
        websys_showModal({
          title: chartInfo.title,
          url: linkUrl,
          modal: true,
          top: config.top,
          left: config.left,
          width: config.width,
          height: config.height
        });
      } catch (e) {
        window.open(
          buildMWTokenUrl(linkUrl),
          "newwindow",
          "height=" +
          config.height +
          ",width=" +
          config.width +
          ",top=" +
          config.top +
          ",left=" +
          config.left +
          ",toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no"
        );
      }
    }
  });
}
/**
 * @description 时间转时间戳 兼容所有浏览器
 * @param {*} time "2010-03-15 10:30:00"
 */
function getTs(time) {
  var arr = time.split(/[- :]/),
    _date = new Date(arr[0], arr[1] - 1, arr[2], arr[3], arr[4], arr[5]),
    timeStr = Date.parse(_date);
  return timeStr;
}
/**
 * @description 时间戳转时间 兼容所有浏览器
 * @param {*} timeStamp  1606271400000
 * @param {*} type  "yyyy-mm-dd"
 * "2020-11-25 10:30:00"
 */
function getTi(timeStamp, type) {
  if (!timeStamp) {
    return;
  }
  if (!type) {
    type = "yyyy-mm-dd";
  }
  var date = new Date(timeStamp);
  var opt = {
    "y+": date.getFullYear().toString(), //?0?2年
    "m+": (date.getMonth() + 1).toString(), //?0?2月
    "d+": date.getDate().toString() //?0?2日
  };
  var ret;
  for (var k in opt) {
    ret = new RegExp("(" + k + ")").exec(type);
    if (ret) {
      type = type.replace(
        ret[1],
        opt[k]
        //ret[1].length === 1 ? opt[k] : opt[k].padStart(ret[1].length, "0")
      );
    }
  }
  type = type.replace(/\s*/g,'')
  return type;
}
/**
 * @description 日期格式化
 * @param {*} date
 */
function formatDate(date) {
  if (date && typeof date === "object") {
    var day = date.getDate();
    day = day < 10 ? "0" + day : day;
    var monthIndex = date.getMonth() + 1;
    monthIndex = monthIndex < 10 ? "0" + monthIndex : monthIndex;
    var year = date.getFullYear();
    return year + "-" + monthIndex + "-" + day;
  } else if (date && typeof date === "string") {
    var reg = /((^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(10|12|0?[13578])([-\/\._])(3[01]|[12][0-9]|0?[1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(11|0?[469])([-\/\._])(30|[12][0-9]|0?[1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(0?2)([-\/\._])(2[0-8]|1[0-9]|0?[1-9])$)|(^([2468][048]00)([-\/\._])(0?2)([-\/\._])(29)$)|(^([3579][26]00)([-\/\._])(0?2)([-\/\._])(29)$)|(^([1][89][0][48])([-\/\._])(0?2)([-\/\._])(29)$)|(^([2-9][0-9][0][48])([-\/\._])(0?2)([-\/\._])(29)$)|(^([1][89][2468][048])([-\/\._])(0?2)([-\/\._])(29)$)|(^([2-9][0-9][2468][048])([-\/\._])(0?2)([-\/\._])(29)$)|(^([1][89][13579][26])([-\/\._])(0?2)([-\/\._])(29)$)|(^([2-9][0-9][13579][26])([-\/\._])(0?2)([-\/\._])(29)$))/gi;
    if (reg.test(date)) {
      return date;
    } else {
      var regDDMMYYY = /(0[1-9]|[12][0-9]|3[01])[/](0[1-9]|1[012])[/](19|20)[0-9]{2}/gi;
      if (regDDMMYYY.test(date)) {
        var yyyy = date.split("/")[2];
        var MM = date.split("/")[1];
        var dd = date.split("/")[0];
        date = yyyy + "-" + MM + "-" + dd;
        if (reg.test(date)) {
          return date;
        }
      }
    }
  }
  return "";
}