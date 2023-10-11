/**
 * @author rw
 * @description 评估趋势图
 */
$(function () {
  var myChart;
  /**
   * @description 初始化UI
   */
  function initUIChart() {
    initSearchCondition();
    initPatientTree();
    if (EpisodeID !== "") {
      setPatientInfo(EpisodeID);
      setTemplatesInfo(EpisodeID);
    }
    listenEvents();
  }
  /**
   * @description 初始化查询条件
   */
  function initSearchCondition() {
    $m(
      {
        ClassName: "NurMp.NursingRecordsConfig",
        MethodName: "getDomValue",
        HospitalID: "",
        LocID: session["LOGON.CTLOCID"],
        DomID: "PatListExpandFlag"
      },
      function (expand) {
        if (expand == "true") {
          $("#patient_search").panel({ title: "患者查询" });
          currentHeight = $(".west_center_list").height();
          $(".west_center_list").css("height", currentHeight - 30);
        }
      }
    );
    // 查询
    $("#wardPatientSearchBox").searchbox({
      searcher: function (value) {
        $HUI.tree("#patientTree", "reload");
      }
    });
    // 责组|全部
    $("#wardPatientCondition").switchbox(
      "options"
    ).onSwitchChange = function () {
      $HUI.tree("#patientTree", "reload");
    };
    // 今日手术
    $("#radioTodayOper").radio({
      onCheckChange: function (e, value) {
        $HUI.tree("#patientTree", "reload");
      }
    });
  }
  /**
   * @description 初始化患者树
   */
  function initPatientTree() {
    $HUI.tree("#patientTree", {
      loader: function (param, success, error) {
        $cm(
          {
            ClassName: "NurMp.NursingRecords",
            MethodName: "getWardPatients",
            wardID: session["LOGON.WARDID"],
            adm: EpisodeID,
            groupSort: !$("#wardPatientCondition").switchbox("getValue"),
            babyFlag: "",
            searchInfo: $HUI.searchbox("#wardPatientSearchBox").getValue(),
            locID: session["LOGON.CTLOCID"] || "",
            todayOperFlag: $("#radioTodayOper").radio("getValue")
          },
          function (data) {
            var addIDAndText = function (node) {
              node.id = node.ID;
              node.text = node.label;
              if (node.id === EpisodeID) {
                node.checked = true;
              }
              if (node.children) {
                node.children.forEach(addIDAndText);
              }
            };
            data.forEach(addIDAndText);
            success(data);
          }
        );
      },
      onLoadSuccess: function (node, data) {
        $(".man,.woman,.unman").css("background-size", "contain");
        var addIDAndText = function (node) {
          node.id = node.ID;
          node.text = node.label;
          if (typeof node.icons != "undefined" && !!node.icons) {
            $.each(node.icons.reverse(), function (index, value) {
              $(
                "#patientTree > li > ul > li > div > span:contains(" +
                  node.text +
                  ")"
              ).after("<img style='margin:6px;' src='" + value + "'/>");
            });
          }
          if (node.children) {
            node.children.forEach(addIDAndText);
          }
        };
        data.forEach(addIDAndText);
        if (!!EpisodeID) {
          var selNode = $("#patientTree").tree("find", EpisodeID);
          $("#patientTree").tree("select", selNode.target);
        }
      },
      lines: true,
      onClick: function (node) {
        if (!!node.episodeID) {
          setPatientInfo(node.id);
          setTemplatesInfo(node.id);
          EpisodeID = node.id;
          var editAuthority = AuthorityFlag;
          var indeptDatetime = $m(
            {
              ClassName: "NurMp.NursingRecordsSet",
              MethodName: "getInDeptDateTime",
              episodeID: EpisodeID
            },
            false
          );
          if (!indeptDatetime) {
            $.messager.popover({
              msg: "未入科患者无法查看评估曲线图！",
              type: "error"
            });
            editAuthority = 2;
          }
          //赋值给头菜单
          var frm = dhcsys_getmenuform();
          if (frm) {
            frm.EpisodeID.value = node.episodeID;
            frm.PatientID.value = node.patientID;
          }
        }
      }
    });
  }
  /**
   * @description 展示病人标题信息
   * @param {EpisodeID} 患者就诊号
   */
  function setPatientInfo(EpisodeID) {
    $m(
      {
        ClassName: "web.DHCDoc.OP.AjaxInterface",
        MethodName: "GetOPInfoBar",
        CONTEXT: "",
        EpisodeID: EpisodeID
      },
      function (html) {
        if (html != "") {
          $(".PatInfoItem").html(reservedToHtml(html));
        } else {
          $(".PatInfoItem").html(
            "获取病人信息失败。请检查【患者信息展示】配置。"
          );
        }
      }
    );

    function reservedToHtml(str) {
      var replacements = {
        "&lt;": "<",
        "&#60;": "<",
        "&gt;": ">",
        "&#62;": ">",
        "&quot;": '"',
        "&#34;": '"',
        "&apos;": "'",
        "&#39;": "'",
        "&amp;": "&",
        "&#38;": "&"
      };
      return str.replace(
        /(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,
        function (v) {
          return replacements[v];
        }
      );
    }
  }
  /**
   * @description 展示病人模板
   * @param {EpisodeID} 患者就诊号
   */
  function setTemplatesInfo(EpisodeID) {
    $HUI.combobox("#templateslist", {
      valueField: "id",
      textField: "tableName",
      loader: function (param, success, error) {
        $cm(
          {
            ClassName: "NurMp.NursingRecordsChart",
            MethodName: "getTemplates",
            EpisodeID: EpisodeID,
            LocID: "",
            HospitalID: session["LOGON.HOSPID"]
          },
          function (data) {
            success(data);
            if (data.length) {
              $("#templateslist").combobox("setValue", data[0].id);
              getChartInfo(EpisodeID);
            }else if (myChart) {
	          myChart.clear();
	        }
          }
        );
      },
      onSelect: function (record) {
        getChartInfo();
      }
    });
    $("#dayStartDate").datebox(
      "setValue",
      formatDate(new Date(new Date().getTime() - 1000 * 60 * 60 * 24 * 7))
    );
    $("#dayStartTime").timespinner("setValue", "00:01");
    $("#dayEndDate").datebox("setValue", formatDate(new Date()));
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
  function getChartInfo(EpisodeID) {
    EpisodeID = EpisodeID ? EpisodeID : getEpisodeID();
    if (!EpisodeID) {
      $.messager.popover({ msg: "请选择患者！", type: "info" });
      return;
    }
    var templateId = $("#templateslist").combobox("getValue");
    if (!templateId) {
      $.messager.popover({ msg: "请选择模板！", type: "info" });
      return;
    }
    var startDate = $("#dayStartDate").datebox("getValue");
    var startTime = $("#dayStartTime").timespinner("getValue");
    var endDate = $("#dayEndDate").datebox("getValue");
    var endTime = $("#dayEndTime").timespinner("getValue");
    $cm(
      {
        ClassName: "NurMp.NursingRecordsChart",
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
        drawChart(data);
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
        text: chartInfo.title
      },
      tooltip: {
        formatter: function (params) {
          var data = params.data || [0, 0, 0, 0, 0];
          return (
            data[2] +
            "<br/>" +
            data[1] +
            "分 评估人：" +
            data[3] +
            "<br/>双击查看详情"
          );
        }
      },
      xAxis: {
        name: "时间",
        min: min,
        max: max,
        splitLine: { show: true },
        axisTick: { show: true, alignWithLabel: true },
        //splitNumber: 12,
        minInterval: 3600 * 24 * 1000,
        type: "time",
        axisLabel: {
          formatter: function (value) {
            var datetype = config.datetype;
            if (config.isShowMonth == "true") {
              datetype = "dd日";
            } else if (config.isShowYear == "true") {
              datetype = datetype.replace(/yyyy年|yyyy-|\/yyyy/g, "");
            }
            var date = getTi(value, datetype);
            return date;
          }
        }
      },
      yAxis: {
        name: "分数",
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
            chartInfo.data.length === 0
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
                  data: [{ name: "预警值", yAxis: config.warn }]
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
            linkUrl,
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
  function getEpisodeID() {
    return $("#patientTree").tree("getSelected")
      ? $("#patientTree").tree("getSelected").episodeID
      : "";
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
      "y+": date.getFullYear().toString(), // 年
      "m+": (date.getMonth() + 1).toString(), // 月
      "d+": date.getDate().toString() // 日
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
  initUIChart();
});
