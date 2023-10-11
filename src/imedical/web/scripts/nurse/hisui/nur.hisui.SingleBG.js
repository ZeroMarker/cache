/**
 * @author wujiang
 */
if (!Array.prototype.includes) {
	Array.prototype.includes = function (elem) {
		if (this.indexOf(elem) < 0) {
			return false;
		} else {
			return true;
		}
	};
}
if (!String.prototype.includes) {
	String.prototype.includes = function (elem) {
		if (this.indexOf(elem) < 0) {
			return false;
		} else {
			return true;
		}
	};
}
$.extend($.fn.datagrid.methods, {
	editCell: function (jq, param) {
		return jq.each(function () {
			$(this).datagrid("endEdit", param.index);
			var opts = $(this).datagrid("options");
			var fields = $(this).datagrid("getColumnFields", true).concat($(this).datagrid("getColumnFields"));
			for (var i = 0; i < fields.length; i++) {
				var col = $(this).datagrid("getColumnOption", fields[i]);
				col.editor1 = col.editor;
				if (!param.field.includes(fields[i])) {
					col.editor = null;
				}
			}
			$(this).datagrid("beginEdit", param.index);
			for (var i = 0; i < fields.length; i++) {
				var col = $(this).datagrid("getColumnOption", fields[i]);
				col.editor = col.editor1;
			}
		});
	},
});
var delimiter = String.fromCharCode(129),
  curEditorTarget;
var patNode,
  saveFlag = true;
var bgConfig = {},
  bgConfigData = []; //血糖配置信息
var columns = [],
  timeouter,
  bgData = [];
var warnCondition = [],
  filterIndex = []; //预警条件
var alarmCondition = []; //所有预警条件
var measures = []; //措施
var retestObj = {}; //修改血糖值或复测血糖值信息
var myChart, dateformat;
var curNurseMeasure; //记录当前的护理措施
var frm = dhcsys_getmenuform();
var columnList = [], columnObj = {}, timeFlag = 0, remarkFlag = 0,confirmModal;
var clickCellFlag = 0; // 点击单元格标识
if ('undefined'==typeof HISUIStyleCode) {
	var HISUIStyleCode="blue";
}
$("#bloodGlucose").datagrid({
	singleSelect: true,
	onClickRow: function (rowIndex, rowData) {
		$(this).datagrid("unselectRow", rowIndex);
	},
});
$(function () {
	init();
});
// 初始化
function init() {
	if (EpisodeID !== "") {
		InitPatInfoBanner(EpisodeID);
	}
	// 获取日期格式
	var res = $cm({
		ClassName: "Nur.NIS.Service.System.Config",
		MethodName: "GetSystemConfig",
	}, false );
	dateformat = res.dateformat;
	$("#startDate").datebox("setValue", dateCalculate(new Date(), -6));
	$("#endDate").datebox("setValue", formatDate(new Date()));
	setDateboxOption();
	$("#bloodGlucose").datagrid({ data: { total: 0, rows: [] } });
	// 更新dom元素的大小
	updateSbgTableSize();
	// 获取会诊申请时效和默认血糖采集时间列
	$cm({
		ClassName: "Nur.NIS.Service.VitalSign.BloodGlucoseCfg",
		MethodName: "GetApplyHourAndTimeShow",
		dataType: "text",
		hospDR: session["LOGON.HOSPID"],
	}, function (res) {
		if (res) {
			res = JSON.parse(res);
			// $("#applyHour").numberbox('setValue',res.applyHour);
			timeFlag = "Y" == res.timeShow ? 0 : 1;
			$("#switch").switchbox("setValue", timeFlag ? true : false);
			remarkFlag = "Y" == res.remarkShow ? 0 : 1;
			$("#remarkSwitch").switchbox("setValue", remarkFlag ? true : false);
		}
	});
	// 获取血糖采集时间配置
	$cm({
		ClassName: "Nur.NIS.Service.VitalSign.BloodGlucoseCfg",
		QueryName: "GetBGConfig",
		rows: 999999999999999,
		random: "Y",
		hospDR: session["LOGON.HOSPID"],
	}, function (data) {
		console.log(data);
		data = data.rows;
		data.map(function (e, i) {
			data[i].symbol = e.specialChar.split(delimiter);
			e.VSDesc=$g(e.VSDesc);
			bgConfig[e.VSId] = e;
			bgConfig[e.VSCode] = e.VSId;
			var item =
			'<td class="r-label"><input class="hisui-checkbox bgItem" type="checkbox"  data-id="' +
			e.id +
			'"  data-options="onCheckChange:bgCfgChange" label="' +
			e.VSDesc +
			'" id="' +
			e.VSCode +
			'"></td>';
			$("#bgConfig tr").append(item);
			$("#bgConfig tr td:eq(-1) input").checkbox({
				label: e.VSDesc,
				value: e.id,
				checked: true,
			});
		});
		bgConfigData = data;
		if (frm) {
			patNode = {
				episodeID: frm.EpisodeID.value,
				patientID: frm.PatientID.value,
			};
			getInHospDateTime(patNode.episodeID);
		}
		if (location.href.includes("EpisodeID=")) {
			getInHospDateTime(parseInt(location.href.split("EpisodeID=")[1]));
		}
	});
	if (!IsStandardEdition) {
		// 获取血糖预警配置
		$cm({
			ClassName: "Nur.NIS.Service.VitalSign.BloodGlucoseCfg",
			QueryName: "GetBGWarn",
			rows: 999999999999999,
			hospDR: session["LOGON.HOSPID"],
		}, function (data) {
			data = data.rows;
			alarmCondition = JSON.parse(JSON.stringify(data));
			warnCondition = data.filter(function (e) {
				return "W" == e.type; //取警示的数据
			});
			warnCondition.map(function (e, i) {
				if ("W" == e.type) {
					//取警示的数据
					var item = '<span class="severity" onclick="toggleStatus(this,' + i + ');"><i class="dot" style="background: ' + e.color + ';"></i>' + e.name + "</span>";
					$("#bgWarn tr td:eq(0)").append(item);
					var detail = '<p><i class="dot" style="background: ' + e.color + ';"></i><span>' + e.variableDesc + ' ' + e.nurseMeasureDetail + "</span></p>";
					$("#bgWarn .helpDetail").append(detail);
				}
			});
			if ($("#bgWarn .helpDetail>p").length < 4) {
				$("#bgWarn .helpDetail").addClass("short");
			} else {
				$("#bgWarn .helpDetail").removeClass("short");
			}
		});
	}
	findBGByDay();
	$("#mvsLayout").layout("panel", "west").panel({
		onExpand: updateSbgTableSize,
		onCollapse: updateSbgTableSize,
	});
	if ('lite'==HISUIStyleCode) { //极简
		$('.eduExeStyle').append('#bgWarn tr td span {height: 16px;vertical-align: top;line-height: 16px;}');
		if (IsPopUp) { //极简弹窗
			$('.eduExeStyle').append('body{background-color: #ffffff;}');
		}else{
			$('.eduExeStyle').append('body{background-color: #f5f5f5;}');
		}
	}else{
		$('.eduExeStyle').append('.ctcContent .panel-body.panel-body-noheader, .panel.datagrid>.panel-body.panel-body-noheader {border-color: #cccccc;}');
  	}
}
// 根据天查询血糖数据
function findBGByDay() {
	var opeTabs = $("#opeTabs");
	opeTabs.tabs("exists", 0);
	while (opeTabs.tabs("exists", 0)) {
		opeTabs.tabs("close", 0);
	}
	var startDate = $("#startDate").datebox("getValue"),
		endDate = $("#endDate").datebox("getValue");
	while (
		new Date(standardizeDate(startDate)).valueOf() <=
		new Date(standardizeDate(endDate)).valueOf()
	) {
		opeTabs.tabs("add", {
			title: startDate,
		});
		startDate = dateCalculate(new Date(standardizeDate(startDate)), 1);
	}
	$HUI.tabs("#opeTabs", {
		onSelect: function (date, index) {
			clearTimeout(timeouter);
			timeouter = setTimeout(getBGRecordByDays, 25);
		},
	});
}
function getInHospDateTime(EpisodeID) {
	$cm({
		ClassName: "Nur.NIS.Service.Base.Patient",
		MethodName: "GetInHospDateTime",
		dataType: "text",
		EpisodeID: EpisodeID,
	}, function (data) {
		var inHospDate = data.split(" ")[0] || dateCalculate(new Date(), -6);
		var halfYearAgo = dateCalculate(new Date(), -6);
		var startOpt = $("#startDate").datebox("options");
		startOpt.minDate = inHospDate;
		var day = inHospDate;
		if (
			new Date(standardizeDate(inHospDate)) <
			new Date(standardizeDate(halfYearAgo))
		) {
			day = halfYearAgo;
		}
		$("#startDate").datebox("setValue", day);
		getBGRecordByDays();
	});
}
function getBGIcon(episodeID) {
	$cm({
		ClassName: "Nur.NIS.Service.VitalSign.BloodGlucoseV2",
		MethodName: "getBGIcon",
		dataType: "text",
		EpisodeID: episodeID,
	}, function (res) {
		$(".iconTest").html(htmldecode(res));
	});
}
function htmldecode(s) {
	var div = document.createElement("div");
	div.innerHTML = s;
	return div.innerText || div.textContent;
}
function bgCfgChange(e, v) {
  if (v) {
    bgConfigData.map(function (e) {
      v = v && $("#" + e.VSCode).checkbox("getValue");
    });
  }
  if (saveFlag) {
    getBGRecordByDays();
  }
  saveFlag = false;
  $("#checkAll").checkbox("setValue", v);
  timeouter = setTimeout(function () {
    saveFlag = true;
  }, 50);
}

function checkAllBG(e, v) {
  if (saveFlag) {
    saveFlag = false;
    bgConfigData.map(function (e) {
      $("#" + e.VSCode).checkbox("setValue", v);
    });
    timeouter = setTimeout(function () {
      saveFlag = true;
    }, 300);
    getBGRecordByDays();
  }
}
// 设置日期选择框禁用值
function setDateboxOption(flag) {
  console.log(flag);
  var now = new Date();
  var startDate = $("#startDate").datebox("getValue"),
    endDate = $("#endDate").datebox("getValue");
  var startOpt = $("#startDate").datebox("options"),
    endOpt = $("#endDate").datebox("options");
  if (!startDate || !endDate) return;
  startOpt.maxDate = endDate;
  endOpt.minDate = startDate;
  endOpt.maxDate = endOpt.formatter(now);
}

function setBGDateOption(flag) {
  var now = new Date();
  var assessStartDate = $("#assessStartDate").datebox("getValue"),
    assessEndDate = $("#assessEndDate").datebox("getValue");
  var startOpt = $("#assessStartDate").datebox("options"),
    endOpt = $("#assessEndDate").datebox("options");
  if (!assessStartDate || !assessEndDate) return;
  startOpt.maxDate = assessEndDate;
  endOpt.minDate = assessStartDate;
  endOpt.maxDate = endOpt.formatter(now);
}
// 切换选中的状态
function toggleStatus(obj, i) {
  var pbgColor = $(obj).css("background-color"),
    cbgColor = $(obj).find("i").css("background-color");
  if ("rgb(255, 255, 255)" == pbgColor) {
    $(obj)
      .css({
        background: cbgColor,
        color: pbgColor,
      })
      .find("i")
      .css("background", pbgColor);
    filterIndex.push(i);
  } else {
    $(obj)
      .css({
        background: cbgColor,
        color: "black",
      })
      .find("i")
      .css("background", pbgColor);
    filterIndex.splice(filterIndex.indexOf(i), 1);
  }
  getBGRecordByDays();
}
// 标准化日期
function standardizeDate(day) {
	var y = dateformat.indexOf("YYYY");
	var m = dateformat.indexOf("MM");
	var d = dateformat.indexOf("DD");
	var str =
		day.slice(y, y + 4) + "/" + day.slice(m, m + 2) + "/" + day.slice(d, d + 2);
	return str;
}
// 格式化日期
function formattingDate(day) {
	var s = dateformat || "YYYY-MM-DD";
	var y = s.indexOf("YYYY");
	var m = s.indexOf("MM");
	var d = s.indexOf("DD");
	s = s.replace("YYYY", day.substr(y, 4));
	s = s.replace("MM", day.substr(m, 2));
	s = s.replace("DD", day.substr(d, 2));
	return s;
}
// 返回用户定义格式日期
function getUDDate(day) {
    // day("YYYY-MM-DD")
    var s = dateformat || "YYYY-MM-DD";
    s = s.replace("YYYY", day.substr(0, 4));
    s = s.replace("MM", day.substr(5, 2));
    s = s.replace("DD", day.substr(8, 2));
    return s;
}
// 获取某些天的血糖记录
function getBGRecordByDays() {
  var days = [];
  var startDate = $("#startDate").datebox("getValue"),
    endDate = $("#endDate").datebox("getValue");
  while (
    new Date(standardizeDate(startDate)).valueOf() <=
    new Date(standardizeDate(endDate)).valueOf()
  ) {
    days.push(endDate);
    endDate = formattingDate(
      dateCalculate(new Date(standardizeDate(endDate)), -1)
    );
  }
  var obsDrs = [];
  var keys = Object.keys(bgConfig);
  keys.map(function (e) {
    var v = $("#" + bgConfig[e].VSCode).checkbox("getValue");
    if (v) obsDrs.push(e);
  });
  var episodeId = EpisodeID || (patNode && patNode.episodeID);
  if (!episodeId) return;
  $cm(
    {
      ClassName: "Nur.NIS.Service.VitalSign.BloodGlucoseV2",
      MethodName: "getBGRecordByDays",
      EpisodeIDs: JSON.stringify([episodeId]),
      Dates: JSON.stringify(days),
      ObsDrs: JSON.stringify(obsDrs),
    },
    function (data) {
      // 统计实测、应测总数
      var actualTimes = 0,
        shouldTimes = 0;
      data.map(function (d,i) {
        var keys=Object.keys(d);
        keys.map(function (k,j) {
          if (k.indexOf('_Measure')>-1) {
            var measure1=d[k].split('/');
            measure1.map(function (m1,i1) {
              var measure2=m1.split(';');
              measure2.map(function (m2,i2) {
                measure2[i2]=$g(m2);
              })
              measure1[i1]=measure2.join(";");
            })
            data[i][k]=measure1.join("/");
          }
        });
        var testTimes = d.testTimes.split("/");
        actualTimes += parseInt(testTimes[0]);
        shouldTimes += parseInt(testTimes[1]);
      });
      if (filterIndex.length) {
        //过滤
        for (var k = 0; k < data.length; k++) {
          var d = data[k],
            flag = true;
          for (var m = 0; m < bgConfigData.length; m++) {
            var vscode = bgConfigData[m].VSCode,
              vsId = bgConfigData[m].VSId;
            var value = d[vscode];
            if (
              "" === value ||
              "undefined" == typeof value ||
              isNaN(parseFloat(value))
            )
              continue;
            var values = value.toString().split("/");
            for (var n = 0; n < values.length; n++) {
              value = values[n];
              if (
                "" === value ||
                "undefined" == typeof value ||
                isNaN(parseFloat(value)) ||
                value != parseFloat(value)
              )
                continue;
              for (var j = 0; j < filterIndex.length; j++) {
                var i = filterIndex[j];
                if (!warnCondition[i].relatedBGItems.split(",").includes(vsId))
                  continue;
                var condition = value + warnCondition[i].condition;
                condition = condition
                  .replace(/\|\|/g, "||" + value)
                  .replace(/\&\&/g, "&&" + value);
                if (!eval(condition)) continue;
                flag = false;
                break;
              }
            }
          }
          if (flag) {
            data.splice(k, 1);
            k--;
          }
        }
      }
      bgData = JSON.parse(JSON.stringify(data));
      columns = [];
      var total = {
        date: $g("合计："),
        testTimes: actualTimes + "/" + shouldTimes,
      };
      var switcher = $("#switch").switchbox("getValue");
      var remarkSwitch = $("#remarkSwitch").switchbox("getValue");
      bgConfigData.map(function (e) {
        var v = $("#" + e.VSCode).checkbox("getValue");
        if (v) {
          columns.push({
            editor: { type: "timespinner" },
            field: e.VSCode + "_Time",
            width: 80,
            title: "时间",
          });
          var title = $g(e.VSDesc);
          if (e.startTime&&e.showTime) {
              title += "<br>" + e.startTime + "~" + e.endTime;
          }
          columns.push({
            field: e.VSCode,
            title: title,
            width: 100,
            editor: { type: "text" },
            styler: function (value, row, index) {
              if (index > 0) {
                if (
                  "" === value ||
                  "undefined" == typeof value ||
                  isNaN(parseFloat(value))
                )
                  return;
                if (value.toString().includes("/")) return;
                // if (value.toString().indexOf('/') > -1) value = parseFloat(value);
                var vsId = bgConfig[e.VSCode];
                if (filterIndex.length) {
                  for (var j = 0; j < filterIndex.length; j++) {
                    var i = filterIndex[j];
                    if (
                      !warnCondition[i].relatedBGItems.split(",").includes(vsId)
                    )
                      continue;
                    var condition = value + warnCondition[i].condition;
                    condition = condition
                      .replace(/\|\|/g, "||" + value)
                      .replace(/\&\&/g, "&&" + value);
                    if (!eval(condition)) continue;
                    return "color:" + warnCondition[i].color + ";";
                  }
                  return "color:transparent;";
                } else {
                  for (var i = 0; i < warnCondition.length; i++) {
                    if (
                      !warnCondition[i].relatedBGItems.split(",").includes(vsId)
                    )
                      continue;
                    var condition = value + warnCondition[i].condition;
                    condition = condition
                      .replace(/\|\|/g, "||" + value)
                      .replace(/\&\&/g, "&&" + value);
                    if (!eval(condition)) continue;
                    return "color:" + warnCondition[i].color + ";";
                  }
                }
              }
            },
            formatter: function (value, row, index) {
              if (index > 0) {
                if (
                  "" === value ||
                  "undefined" == typeof value ||
                  isNaN(parseFloat(value))
                )
                  return value;
                var vsId = bgConfig[e.VSCode],
                  vsNote = row[e.VSCode + "_Measure"];
                if (value.toString().includes("/")) {
                  var values = value.toString().split("/");
                  var vsNotes = vsNote.toString().split("/");
                  var string = "";
                  var len = values.length - 1;
                  var cnt = 0,
                    againFlag = 0;
                  for (var j = 0; j <= len; j++) {
                    var value = values[j];
                    var vsNote = vsNotes[j];
                    if (
                      "" === value ||
                      "undefined" == typeof value ||
                      isNaN(parseFloat(value)) ||
                      value != parseFloat(value)
                    ) {
                      string += value;
                      continue;
                    }
                    var flag = true;
                    var filterFlag = false;
                    if (filterIndex.length && !againFlag) {
                      for (var k = 0; k < filterIndex.length; k++) {
                        var i = filterIndex[k];
                        if (
                          !warnCondition[i].relatedBGItems
                            .split(",")
                            .includes(vsId)
                        )
                          continue;
                        var condition = value + warnCondition[i].condition;
                        condition = condition
                          .replace(/\|\|/g, "||" + value)
                          .replace(/\&\&/g, "&&" + value);
                        if (!eval(condition)) continue;
                        filterFlag = true;
                        if (j < len) {
                          string +=
                            '<span style="color:' +
                            warnCondition[i].color +
                            ';">' +
                            value +
                            "/</span>";
                        } else {
                          string +=
                            '<span style="color:' +
                            warnCondition[i].color +
                            ';">' +
                            value +
                            "</span>";
                        }
                        if (
                          "Y" == warnCondition[i].nurMeasureRequire &&
                          !vsNote
                        )
                          flag = false;
                        cnt++;
                      }
                    }
                    if (!filterIndex.length || againFlag) {
                      for (var i = 0; i < warnCondition.length; i++) {
                        if (
                          !warnCondition[i].relatedBGItems
                            .split(",")
                            .includes(vsId)
                        )
                          continue;
                        var condition = value + warnCondition[i].condition;
                        condition = condition
                          .replace(/\|\|/g, "||" + value)
                          .replace(/\&\&/g, "&&" + value);
                        if (!eval(condition)) continue;
                        filterFlag = true;
                        if (j < len) {
                          string +=
                            '<span style="color:' +
                            warnCondition[i].color +
                            ';">' +
                            value +
                            "/</span>";
                        } else {
                          string +=
                            '<span style="color:' +
                            warnCondition[i].color +
                            ';">' +
                            value +
                            "</span>";
                        }
                        if (
                          "Y" == warnCondition[i].nurMeasureRequire &&
                          !vsNote
                        )
                          flag = false;
                      }
                      if (!filterFlag) {
                        if (j < len) {
                          string +=
                            '<span style="color:black;">' + value + "/</span>";
                        } else {
                          string +=
                            '<span style="color:black;">' + value + "</span>";
                        }
                      }
                    }
                    if (cnt > 0) {
                      j = -1;
                      againFlag = 1;
                      string = "";
                      cnt = 0;
                    }
                  }
                  // if (!filterIndex.length || (filterIndex.length && !flag)) {
                  //     if (vsNote && vsNote.replace(/\//g, '')) return string + '<span class="icon icon-ok">&nbsp;</span>';
                  // }
                  if (!flag)
                    return string + '<span class="icon icon-ok">&nbsp;</span>';
                  console.log(string);
                  return string;
                } else {
                  var flag = true;
                  if (filterIndex.length) {
                    for (var k = 0; k < filterIndex.length; k++) {
                      var i = filterIndex[k];
                      if (
                        !warnCondition[i].relatedBGItems
                          .split(",")
                          .includes(vsId)
                      )
                        continue;
                      var condition = value + warnCondition[i].condition;
                      condition = condition
                        .replace(/\|\|/g, "||" + value)
                        .replace(/\&\&/g, "&&" + value);
                      if (!eval(condition)) continue;
                      if (
                        "Y" == warnCondition[i].retestFlag &&
                        !value.toString().includes("/")
                      ) {
                        var str =
                          '<a href="javascript:void(0);" name="retestBG" data-episodeid="' +
                          row.episodeID +
                          '" data-id="' +
                          row[e.VSCode + "_Id"] +
                          '" data-vscode="' +
                          e.VSCode +
                          '" data-index="' +
                          i +
                          '" class="easyui-linkbutton" ></a>';
                        if (
                          "Y" == warnCondition[i].nurMeasureRequire &&
                          !vsNote
                        )
                          str += '<span class="icon icon-ok">&nbsp;</span>';
                        return value + str;
                      }
                      if ("Y" == warnCondition[i].nurMeasureRequire && !vsNote)
                        flag = false;
                      // flag = false;
                    }
                  } else {
                    for (var i = 0; i < warnCondition.length; i++) {
                      if (
                        !warnCondition[i].relatedBGItems
                          .split(",")
                          .includes(vsId)
                      )
                        continue;
                      var condition = value + warnCondition[i].condition;
                      condition = condition
                        .replace(/\|\|/g, "||" + value)
                        .replace(/\&\&/g, "&&" + value);
                      if (!eval(condition)) continue;
                      if (
                        "Y" == warnCondition[i].retestFlag &&
                        !value.toString().includes("/")
                      ) {
                        var str =
                          '<a href="javascript:void(0);" name="retestBG" data-episodeid="' +
                          row.episodeID +
                          '" data-id="' +
                          row[e.VSCode + "_Id"] +
                          '" data-vscode="' +
                          e.VSCode +
                          '" data-index="' +
                          i +
                          '" data-rowindex="' +
                          index +
                          '" class="easyui-linkbutton" ></a>';
                        if (
                          "Y" == warnCondition[i].nurMeasureRequire &&
                          !vsNote
                        )
                          str += '<span class="icon icon-ok">&nbsp;</span>';
                        return value + str;
                      }
                      if ("Y" == warnCondition[i].nurMeasureRequire && !vsNote)
                        flag = false;
                      // flag = false;
                    }
                  }
                  // if (!filterIndex.length || (filterIndex.length && !flag)) {
                  //     if (vsNote) return value + '<span class="icon icon-ok">&nbsp;</span>';
                  // }
                  if (!flag)
                    return string + '<span class="icon icon-ok">&nbsp;</span>';
                  return value;
                }
              } else {
                return value;
              }
            },
          });
          columns.push({
            editor: { type: "text" },
            field: e.VSCode + "_Note",
            width: 80,
            title: "备注",
          });
          var num = 0;
          data.map(function (el) {
            if ("RBS" == e.VSCode) {
              if ("undefined" != typeof el["RBS"]) {
                num += el["RBS"].toString().split("/").length;
              }
            } else {
              if ("undefined" != typeof el[e.VSCode]) num++;
            }
          });
          if (num > 0) {
            total[e.VSCode] = num;
          }
        }
      });
      columns.push({
        field: "testTimes",
        title: "实测/应测次数",
        styler: function (value, row, index) {
          var values = value.split("/");
          if (parseInt(values[0]) < parseInt(values[1])) return "color:red;";
        },
      });
      columns.push({ field: "remark", title: "医嘱备注" });
      data.unshift(total);
      columnList = columns.slice(0, -2);
      // console.log(JSON.stringify(columnList));
      columnList.map(function (el, ind) {
        el.index = ind;
        columnObj[el.field] = el;
      });
      // console.log(JSON.stringify(columnObj));
      $("#bloodGlucose").datagrid({
        singleSelect: true,
        frozenColumns: [[{ field: "date", title: "日期" }]],
        onClickCell: function (index, field, value) {
          clickCellFlag = 1;
          editTableCell(index, field);
        },
        onDblClickCell: function (index, field, value) {
          console.log(arguments);
          var row = $("#bloodGlucose").datagrid("getRows")[index];
          if (!row[field + "_Measure"]) {
            if (
              !index ||
              !value ||
              ("RBS" != field && !value.toString().includes("/"))
            )
              return;
          }
          if ($("#" + field).checkbox("getValue")) {
            var vsId = bgConfig[field];
            // 如果是随机，单独打开
            if ("RBS" == field || value.toString().includes("/")) {
              $("#measure").empty();
              var row = $("#bloodGlucose").datagrid("getRows")[index];
              retestObj = {
                retestFlag: "",
                itemDr: vsId,
                value: "",
                episodeID: row.episodeID,
                verify: "",
                date: row.date,
                rowId: "",
                time: "",
              };
              openRetestModal();
              showSymbolTooltip("#bgValue", field);
            }
            var value = parseFloat(value);
            var spliter = String.fromCharCode(13);
            for (var i = 0; i < warnCondition.length; i++) {
              if (
                "" === value ||
                "undefined" == typeof value ||
                isNaN(parseFloat(value))
              )
                continue;
              if (!warnCondition[i].relatedBGItems.split(",").includes(vsId))
                continue;
              var condition = value + warnCondition[i].condition;
              condition = condition
                .replace(/\|\|/g, "||" + value)
                .replace(/\&\&/g, "&&" + value);
              if (!eval(condition)) continue;
              measures = warnCondition[i].nurseMeasureDetail.split(spliter);
              if (measures.length) {
                $("#measure").empty();
                measures.map(function (e) {
                  var item =
                    '<input class="hisui-checkbox measureItem" type="checkbox" label="' +
                    e +
                    '" id="' +
                    e +
                    '">';
                  $("#measure").append(item);
                  $("#measure input:eq(-1)").checkbox({
                    label: e,
                    value: e,
                    checked: false,
                  });
                });
                var row = $("#bloodGlucose").datagrid("getRows")[index];
                retestObj = {
                  nurMeasureRequire: warnCondition[i].nurMeasureRequire,
                  retestFlag: warnCondition[i].retestFlag,
                  itemDr: vsId,
                  value: "",
                  episodeID: row.episodeID,
                  verify: "",
                  date: row.date,
                  rowId: "",
                  time: "",
                };
                openRetestModal();
                showSymbolTooltip("#bgValue", field);
                return;
              }
            }
          }
        },
        columns: [columns],
        data: { total: data.length, rows: data },
        onLoadSuccess: function (data) {
          $("a[name='retestBG']").map(function (index, elem) {
            var id = $(this).data("id"),
              vscode = $(this).data("vscode"),
              episodeID = $(this).data("episodeid"),
              index = $(this).data("index"),
              rowindex = $(this).data("rowindex");
            $(elem)
              .linkbutton({
                plain: true,
                size: "small",
                onClick: retestBG(episodeID, id, vscode, index, rowindex),
                iconCls: "icon-verify",
              })
              .popover({
                trigger: "hover",
                content: "<p>" + $g("复测血糖") + "</p>",
                style: "inverse",
              });
          });
          var $td = $("#bloodGlucose")
            .prev()
            .find(".datagrid-body>table tr>td");
          $td
            .mouseenter(function (event) {
              var field = $(this).attr("field");
              if (!$("#" + field).checkbox("getValue")) return;
              var rowIndex = $(this).parent().attr("datagrid-row-index");
              if (rowIndex < 1) return;
              // var row=bgData[rowIndex-1],value=row[field];
              var row = $("#bloodGlucose").datagrid("getRows")[rowIndex],
                value = row[field];
              if ("" === value || "undefined" == typeof value) return;
              var values = value.toString().split("/");
              var content = '<table cellpadding="0" style="border-collapse: collapse;white-space: nowrap;">';
              for (var i = 0; i < values.length; i++) {
                if (i > 0) content += "<tr></tr>";
                var createDateTime = row[field + "_CreteDateTime"]
                  ? getCorrectTimeStr(row[field + "_CreteDateTime"],i)
                  : "";
                content += '<tr><td style="text-align:right;">'+$g("录入时间：")+'</td><td>'+createDateTime+'</td></tr>';
                content += '<tr><td style="text-align:right;">'+$g("采集时间：")+'</td><td>'+row.date + " " + row[field + "_Time"].split("/")[i]+'</td></tr>';
                if (values[i] == parseFloat(values[i])) {
                  content += '<tr><td style="text-align:right;">'+$g("血糖值：")+'</td><td>'+values[i]+'mmol/L</td></tr>';
                } else {
                  content += '<tr><td style="text-align:right;">'+$g("血糖值：")+'</td><td>'+values[i]+'</td></tr>';
                }
                content += '<tr><td style="text-align:right;">'+$g("录入人：")+'</td><td>'+row[field + "_Nurse"].split("/")[i]+'</td></tr>';
                if (!IsStandardEdition) {
                  content += '<tr><td style="text-align:right;">'+$g("处理措施：")+'</td><td>'+(row[field + "_Measure"] || "").split("/")[i]+'</td></tr>';
                }
              }
              content += '</table>';
              var placement = "bottom";
              if (rowIndex > 8) placement = "top";
              $(this)
                .popover({
                  trigger: "manual",
                  placement: placement,
                  content: content,
                })
                .popover("show");
            })
            .mouseleave(function () {
              if ($(this) && $(this).popover) {
                try {
                  $(this).popover("hide");
                } catch (e) {}
              }
            });
        },
      });
      toggleSwitch({}, { value: switcher });
      toggleRemarkSwitch({}, { value: remarkSwitch });
    }
  );
}
function getCorrectTimeStr(timeStr,i) {
	var slashCount=(dateformat.match(/\//g) || []).length;
	var slashMod=slashCount+1;
	return timeStr.split("/").slice(i*slashMod,(i+1)*slashMod).join("/");
}
function forwardTableCell(index, field, keyCode) {
  console.log('""""keyCode""""');
  console.log(keyCode);
  // 添加上下左右回车事件
  if (13 == keyCode) keyCode = 39;
  var rows = $("#bloodGlucose").datagrid("getRows");
  var colIndex = columnObj[field].index;
  var gapLeft = 1,
    gapRight = 1;
  if (field.indexOf("_Time") > -1) {
    if (remarkFlag) gapLeft = 2; // 不显示备注
  } else if (field.indexOf("_Note") > -1) {
    if (timeFlag) gapRight = 2; // 不显示时间
  } else {
    if (timeFlag) {
      gapLeft = 2;
    }
    if (remarkFlag) {
      gapRight = 2;
    }
    if (timeFlag && remarkFlag) {
      (gapLeft = 3), (gapRight = 3);
    }
  }
  switch (keyCode) {
    case 38: //上
      if (1 == index) {
        index = rows.length - 1;
        if (gapLeft - 1 >= colIndex) {
          colIndex = columnList.length - 1;
        } else {
          colIndex = colIndex - gapLeft;
        }
      } else {
        index--;
      }
      break;
    case 37: //左
      if (gapLeft - 1 >= colIndex) {
        if (1 == index) {
          index = rows.length - 1;
        } else {
          index--;
        }
        colIndex = columnList.length - 1;
      } else {
        colIndex = colIndex - gapLeft;
      }
      break;
    case 39: //右
      if (colIndex + gapRight > columnList.length - 1) {
				colIndex = timeFlag;
        if (index == rows.length - 1) {
          index = 1;
        } else {
          index++;
        }
      } else {
        colIndex = colIndex + gapRight;
      }
      break;
		case 40: //下
			if (index == rows.length - 1) {
				index = 1;
				if (colIndex + gapRight > columnList.length - 1) {
					colIndex = timeFlag;
				} else {
					colIndex = colIndex + gapRight;
				}
			} else {
				index++;
			}
			break;
    default:
      return;
  }
  field = columnList[colIndex].field;
  editTableCell(index, field, keyCode);
}

function addSymbol(d) {
  console.log(d);
  $(curEditorTarget).val(d);
  $("#bgValue").val(d);
  updateMeasures(d);
  // $(curEditorTarget).val($(curEditorTarget).val() + d);
}

function editTableCell(index, field, keyCode) {
  console.log(bgConfig);
  console.log(bgConfigData);
  $("#mm").hide();
  var rows = $("#bloodGlucose").datagrid("getRows");
  var row = rows[index];
  var value = row[field]||"";

  var condition1 = !index || (value && value.toString().indexOf("/") > -1);
  var condition2 = ("RBS" == field || "RBS_Time" == field) && value;
  var condition3 = !value && field.indexOf("_Time") > -1;
  var condition4 = field.indexOf("_Note") > -1 && !row[field.split("_Note")[0]];
  if (condition1 || condition2 || condition3 || condition4) {
    if (keyCode) forwardTableCell(index, field, keyCode);
    return;
  }
  var saveRes = endEditTableCell();
  if (!saveRes) return;

  var row = $("#bloodGlucose").datagrid("getRows")[index];
  if (row[field + "_Measure"]) return;
  if (
    $("#" + field).checkbox("getValue") ||
    field.includes("_Time") ||
    field.includes("_Note")
  ) {
    saveFlag = true;
    $("#bloodGlucose").datagrid("editCell", {
		index: index,
		field: [field] || [],
    });
    var ed = $("#bloodGlucose").datagrid("getEditor", {
		index: index,
		field: field,
    }); // 获取编辑器
	if (field.includes("_Note")) {
		$(ed.target).val(value.replace("&#47;","/"))
	}
    curEditorTarget = ed.target;
    if (ed) {
		// 编辑器存在，绑定blur事件，结束编辑模式
		$(ed.target).focus().bind("blur", function (e) {
			setTimeout(function () {
				if (clickCellFlag) {
					clickCellFlag = 0;
				} else {
					endEditTableCell(2);
				}
				$(".tooltip").hide();
			}, 300);
		}).bind("keyup", function (e) {
			var originField = field;
			if ([13, 37, 38, 39, 40].indexOf(e.keyCode) > -1) {
				forwardTableCell(index, originField, e.keyCode);
				return;
			}
			if (field.indexOf("_Time") > -1) {
				var value = $(ed.target).timespinner("getValue");
				// field=field.split("_Time")[0];
			} else {
				var row = $("#bloodGlucose").datagrid("getRows")[index];
				var value = $(ed.target).val();
				var vsId = bgConfig[field];
				var spliter = String.fromCharCode(13);
				var note = row[field + "_Measure"] || "";
				var notes = note.split(";");
				for (var i = 0; i < warnCondition.length; i++) {
				if ("" === value || "undefined" == typeof value) continue;
				if (!warnCondition[i].relatedBGItems.split(",").includes(vsId))
					continue;
				var condition = value + warnCondition[i].condition;
				condition = condition
					.replace(/\|\|/g, "||" + value)
					.replace(/\&\&/g, "&&" + value);
				if (!eval(condition)) continue;
				curNurseMeasure = warnCondition[i].nurseMeasureDetail;
				measures = warnCondition[i].nurseMeasureDetail.split(spliter);
				if (measures.length) {
					saveFlag = false;
					$("#measure").empty();
					measures.map(function (e) {
					var item =
						'<input class="hisui-checkbox measureItem" type="checkbox" label="' +
						e +
						'" id="' +
						e +
						'">';
					$("#measure").append(item);
					$("#measure input:eq(-1)").checkbox({
						label: e,
						value: e,
						checked: notes.includes(e),
					});
					});
					retestObj = {
					nurMeasureRequire: warnCondition[i].nurMeasureRequire,
					retestFlag: warnCondition[i].retestFlag,
					itemDr: vsId,
					value: value,
					episodeID: row.episodeID,
					verify: "",
					date: row.date,
					rowId: row[field + "_Id"] || "",
					time: row[field + "_Time"] || "",
					note: row[field + "_Note"] || "",
					};
					openRetestModal();
					showSymbolTooltip("#bgValue", field);
					return;
				}
				}
			}
		});
    }
    showSymbolTooltip(ed.target, field);
    setTimeout(function () {
      	clickCellFlag = 0;
    }, 300);
  }
}
function showSymbolTooltip(target, field) {
	if (bgConfig[field]) {
		var symbol = bgConfig[bgConfig[field]].symbol;
		var tipId = field + "Tip";
		if (symbol && !$("#" + tipId).length) {
			var tipDom = '<div id="' + tipId + '">';
			symbol.map(function (e) {
				console.log(e);
				tipDom += '<a href="#" name="symbol" class="easyui-linkbutton" data-options="plain:true" data-text="' + e + '"></a>';
			});
			tipDom += "</div>";
			$("#toolTips").append(tipDom);
			$("a[name='symbol']").map(function (index, elem) {
				var text = $(this).data("text");
				$(elem).linkbutton({
					size: "small",
					onClick: function () {
						addSymbol(text);
					},
					text: text,
				});
			});
		}
		$(target).tooltip({
			position: "top",
			hideEvent: "none",
			deltaY: 10,
			hideDelay: 600,
			backgroundColor: "rgba(255,255,255,0.8)",
			content: function () {
				return $("#" + tipId);
			},
			onShow: function (e) {
				$(this).tooltip("tip").css({
					backgroundColor: "#fff",
					left: e.clientX - e.offsetX - ($("#" + tipId).width() + 18 - e.target.clientWidth) / 2 + "px",
					top: e.clientY - e.offsetY - 30 + "px",
					border: '1px solid #cccccc',
				});
			},
		});
	}
}
function updateMeasures() {
	var value = $("#bgValue").val();
	value = parseFloat(value);
	var vsId = retestObj.itemDr;
	var spliter = String.fromCharCode(13);
	for (var i = 0; i < warnCondition.length; i++) {
		if (
			"" === value ||
			"undefined" == typeof value ||
			isNaN(parseFloat(value)) ||
			value != parseFloat(value)
		) continue;
		if (!warnCondition[i].relatedBGItems.split(",").includes(vsId)) continue;
		var condition = value + warnCondition[i].condition;
		condition = condition.replace(/\|\|/g, "||" + value).replace(/\&\&/g, "&&" + value);
		if (!eval(condition)) continue;
		if (curNurseMeasure == warnCondition[i].nurseMeasureDetail) return;
		curNurseMeasure = warnCondition[i].nurseMeasureDetail;
		measures = warnCondition[i].nurseMeasureDetail.split(spliter);
		if (measures.length) {
			saveFlag = false;
			$("#measure").empty();
			measures.map(function (e) {
				var item =
				'<input class="hisui-checkbox measureItem" type="checkbox" label="' +
				e +
				'" id="' +
				e +
				'">';
				$("#measure").append(item);
				$("#measure input:eq(-1)").checkbox({
				label: e,
				value: e,
				checked: false,
				});
			});
			retestObj.retestFlag = warnCondition[i].retestFlag;
			retestObj.nurMeasureRequire = warnCondition[i].nurMeasureRequire;
			return;
		}
	}
	$("#measure").empty();
	curNurseMeasure = "";
	retestObj.retestFlag = "";
	retestObj.nurMeasureRequire = "";
}
function retestBG(tmpEpisodeID, tmpId, tmpCode, tmpIndex, tmpRowIndex) {
	var id = tmpId,
		episodeID = tmpEpisodeID,
		vscode = tmpCode,
		index = tmpIndex,
		rowindex = tmpRowIndex;
	return function () {
		showRetestModal(episodeID, id, vscode, index, rowindex, "Y");
	};
}
function showRetestModal(episodeID, id, vscode, i, rowindex, verifyFlag) {
	var spliter = String.fromCharCode(13);
	measures = warnCondition[i].nurseMeasureDetail.split(spliter);
	if (measures.length) {
		$("#measure").empty();
		measures.map(function (e) {
			var item =
				'<input class="hisui-checkbox measureItem" type="checkbox" label="' +
				e +
				'" id="' +
				e +
				'">';
			$("#measure").append(item);
			$("#measure input:eq(-1)").checkbox({
				label: e,
				value: e,
				checked: false,
			});
		});
	}
	retestObj = {
		nurMeasureRequire: warnCondition[i].nurMeasureRequire,
		retestFlag: warnCondition[i].retestFlag,
		itemDr: bgConfig[vscode],
		episodeID: episodeID,
		verify: verifyFlag,
		date: bgData[rowindex - 1].date,
	};
	openRetestModal("复测血糖");
}
// 保存血糖记录
function endEditTableCell(flag) {
  if (curEditorTarget) {
    $(curEditorTarget).tooltip("hide");
  }
  $(".webui-popover").hide();
  var rows = $("#bloodGlucose").datagrid("getRows");
  // 结束编辑
  for (var i = 0, len = rows.length; i < len; i++) {
    var ed = $("#bloodGlucose").datagrid("getEditors", i)[0]; // 获取编辑器
    if (ed) {
      e = JSON.parse(JSON.stringify(rows[i]));
      // console.log(ed);
      var data = "";
      for (var j = 0; j < bgData.length; j++) {
        if (rows[i].date == bgData[j].date) {
          var field = ed.field;
          var time, value, note;
          if (ed.type == "timespinner") {
            time = $(ed.target).timespinner("getValue");
            field = field.split("_Time")[0];
            value = rows[i][field]; //血糖值
            note = rows[i][field + "_Note"] || "";
          } else {
            if (field.includes("_Note")) {
              note = $(ed.target).val();
              field = field.split("_Note")[0];
              value = rows[i][field];
              time = rows[i][field + "_Time"] || "";
            } else {
              value = $(ed.target).val();
              time = rows[i][field + "_Time"] || "";
              note = rows[i][field + "_Note"] || "";
            }
          }
          if (note && note.length > 200) {
            $.messager.popover({ msg: "备注的长度不大于200！", type: "alert" });
            return false;
          }
          if ("" === value && !bgData[j][field]) continue; //去掉空值
          var vsId = bgConfig[field];
          if (!vsId) continue;
          // 校验血糖值
          if ("" !== value && bgConfig[vsId].symbol.indexOf(value) < 0) {
            if (!value || parseFloat(value) != value) {
              $.messager.popover({
                msg: $g("血糖值只能输入数字！"),
                type: "alert",
              });
              return false;
            }
            if (
              parseFloat(value) < parseFloat(bgConfig[vsId].errorLow) ||
              parseFloat(value) > parseFloat(bgConfig[vsId].errorHigh)
            ) {
              $.messager.popover({
                msg: $g("血糖值超出错误值范围！"),
                type: "alert",
              });
              return false;
            }
            value = parseFloat(value);
          }
          if ("" !== time && !time.match(/^(([01]\d)|(2[0123])):[012345]\d$/)) {
            $.messager.popover({
              msg: $g("请输入正确的时间格式！"),
              type: "alert",
            });
            return false;
          }
          // 判断时间
          if (
            new Date(standardizeDate(rows[i].date) + " " + time).valueOf() >
            new Date().valueOf()
          ) {
            $.messager.popover({
              msg: $g("采集时间不能大于当前时间！"),
              type: "alert",
            });
            return false;
          }
          data = {
            itemDr: vsId,
            value: value,
            note: note.replace(/\//g,"&#47;"),
            episodeID: rows[i].episodeID,
            date: rows[i].date,
            time: time,
            rowId: rows[i][field + "_Id"] || "",
          };
          break;
        }
      }
		if (!data) {
			$("#bloodGlucose").datagrid("endEdit", i);
			if (flag) updateTable(rows, "");
			return true;
		}
		var res = $cm({
			ClassName: "Nur.NIS.Service.VitalSign.BloodGlucoseV2",
			MethodName: "saveSingleVitalSign",
			dataType: "text",
			data: JSON.stringify(data),
        }, false);
		$("#bloodGlucose").datagrid("endEdit", i);
		if ('-1000'==res) {
			applyAuthority();
		} else if (parseInt(res) >= 0) {
			if ((!IsStandardEdition)&&(parseInt(res) > 0)) {
				sendCriticalMsg(data);
			}
			e[field + "_Note"] = note;
			e[field + "_Time"] = time;
			updateTable([e], res, field, data.value);
		} else {
			$.messager.popover({ msg: $g("保存失败！"), type: "alert" });
			return false;
		}
		return true;
    }
  }
  return true;
}
function applyAuthority() {
	if (confirmModal&&!$(confirmModal).parent().is(":hidden")) return;
    var oldOk = $.messager.defaults.ok;
    var oldNo = $.messager.defaults.no;
    $.messager.defaults.ok = $g("申请授权");
    $.messager.defaults.no = $g("取消");
    confirmModal = $.messager.confirm($g("提示"), $g("病人已出院，限制操作，请申请出院病历授权"), function (r) {
        if (true===r) {
            $cm({
                ClassName: "Nur.NIS.Service.Base.Patient",
                MethodName: "GetRegNo",
                dataType: "text",
                EpisodeID: EpisodeID,
            }, function (regNo) {
                var url='nur.emr.dischargerecordauthorizeapply.csp?mouldType=XTD&regNo='+regNo; 
                if ("undefined" != typeof websys_getMWToken) {
                  url += "&MWToken=" + websys_getMWToken();
                }
                window.location.href=url;
            });
        }
        /*要写在回调方法内,否则在旧版下可能不能回调方法*/
        $.messager.defaults.ok = oldOk;
        $.messager.defaults.no = oldNo;
    })
	var btns =confirmModal.children("div.messager-button");
    btns.children("a.l-btn").css({width:'auto'});
    $(".window-shadow").map(function (i,obj) {
        $(obj).css({height:$(obj).prev().height()});
    });
}
function updateTable(rows, res, field, val) {
	if (!field) return;
	var vsCode = field; // field
	var vsId = bgConfig[vsCode];
	if (!vsId) return;
	for (var i = 0; i < rows.length; i++) {
		var value = rows[i][vsCode]; //血糖值
		for (var j = 0; j < bgData.length; j++) {
		if (rows[i].date == bgData[j].date) {
			if (rows[i][field] !== val) {
			if ("undefined" == typeof val) {
				val = value;
			} else {
				rows[i][vsCode] = val;
			}
			if (res.toString().includes("||") || (!value && val)) {
				rows[i][vsCode + "_CreteDateTime"] =
				getUDDate(formatDate(new Date())) +
				" " +
				new Date().toString().split(" ")[4].slice(0, 5);
				rows[i][vsCode + "_Id"] = res;
				rows[i][vsCode + "_Nurse"] = session["LOGON.USERNAME"];
				rows[i][vsCode + "_Time"] =
				rows[i][vsCode + "_Time"] ||
				new Date().toString().split(" ")[4].slice(0, 5);
				var t = rows[i]["testTimes"];
				rows[i]["testTimes"] = parseInt(t) + 1 + "/" + t.split("/")[1]; // 更新实测数
				var $div = $("#bloodGlucose")
				.prev()
				.find(
					'.datagrid-body>table tr:eq(0)>td[field="' + vsCode + '"]>div'
				);
				$div.html(parseInt($div.html() || 0) + 1); // 更新总数
				// 更新总的实测/应测次数
				$div = $("#bloodGlucose")
				.prev()
				.find('.datagrid-body>table tr:eq(0)>td[field="testTimes"]>div');
				t = $div.html();
				$div.html(parseInt(t) + 1 + "/" + t.split("/")[1]);
			} else if (value && !val) {
				rows[i][vsCode + "_CreteDateTime"] = "";
				rows[i][vsCode + "_Nurse"] = "";
				rows[i][vsCode + "_Time"] = "";
				var t = rows[i]["testTimes"];
				rows[i]["testTimes"] = parseInt(t) - 1 + "/" + t.split("/")[1]; // 更新实测数
				var $div = $("#bloodGlucose")
				.prev()
				.find(
					'.datagrid-body>table tr:eq(0)>td[field="' + vsCode + '"]>div'
				);
				$div.html(parseInt($div.html() || 0) - 1); // 更新总数
				// 更新总的实测/应测次数
				$div = $("#bloodGlucose")
				.prev()
				.find('.datagrid-body>table tr:eq(0)>td[field="testTimes"]>div');
				t = $div.html();
				$div.html(parseInt(t) - 1 + "/" + t.split("/")[1]);
			} else {
				rows[i][vsCode + "_CreteDateTime"] =
				getUDDate(formatDate(new Date())) +
				" " +
				new Date().toString().split(" ")[4].slice(0, 5);
				rows[i][vsCode + "_Id"] = res;
				rows[i][vsCode + "_Nurse"] = session["LOGON.USERNAME"];
				rows[i][vsCode + "_Time"] =
				rows[i][vsCode + "_Time"] ||
				new Date().toString().split(" ")[4].slice(0, 5);
			}
			bgData[j] = JSON.parse(JSON.stringify(rows[i]));
			// console.log(JSON.stringify(rows[i]));
			$("#bloodGlucose")
				.datagrid("acceptChanges")
				.datagrid("updateRow", {
				index: j + 1,
				row: rows[i],
				});
			}
			var $td = $("#bloodGlucose")
			.prev()
			.find(".datagrid-body>table tr:eq(" + (j + 1) + ")>td");
			$td
			.mouseenter(function (event) {
				var field = $(this).attr("field");
				if (!$("#" + field).checkbox("getValue")) return;
				var rowIndex = $(this).parent().attr("datagrid-row-index");
				if (rowIndex < 1) return;
				var row = $("#bloodGlucose").datagrid("getRows")[rowIndex],
				value = row[field];
				if ("" === value || "undefined" == typeof value) return;
				var values = value.toString().split("/");
				var content = '<table cellpadding="0" style="border-collapse: collapse;white-space: nowrap;">';
				for (var i = 0; i < values.length; i++) {
				if (i > 0) content += "<tr></tr>";
				var createDateTime = row[field + "_CreteDateTime"]
					? getCorrectTimeStr(row[field + "_CreteDateTime"],i)
					: "";
				content += '<tr><td style="text-align:right;">'+$g("录入时间：")+'</td><td>'+createDateTime+'</td></tr>';
				content += '<tr><td style="text-align:right;">'+$g("采集时间：")+'</td><td>'+row.date + " " + row[field + "_Time"].split("/")[i]+'</td></tr>';
				if (values[i] == parseFloat(values[i])) {
					content += '<tr><td style="text-align:right;">'+$g("血糖值：")+'</td><td>'+values[i]+'mmol/L</td></tr>';
				} else {
					content += '<tr><td style="text-align:right;">'+$g("血糖值：")+'</td><td>'+values[i]+'</td></tr>';
				}
				content += '<tr><td style="text-align:right;">'+$g("录入人：")+'</td><td>'+row[field + "_Nurse"].split("/")[i]+'</td></tr>';
				if (!IsStandardEdition) {
					content += '<tr><td style="text-align:right;">'+$g("处理措施：")+'</td><td>'+(row[field + "_Measure"] || "").split("/")[i]+'</td></tr>';
				}
				}
				content += '</table>';
				var placement = "bottom";
				if (rowIndex > 8) placement = "top";
				$(this)
				.popover({
					trigger: "manual",
					placement: placement,
					content: content,
				})
				.popover("show");
			})
			.mouseleave(function () {
				if ($(this) && $(this).popover) {
				try {
					$(this).popover("hide");
				} catch (e) {}
				}
			});
			$("a[name='retestBG']").map(function (index, elem) {
			var id = $(this).data("id"),
				vscode = $(this).data("vscode"),
				episodeID = $(this).data("episodeid"),
				index = $(this).data("index"),
				rowindex = $(this).data("rowindex");
			$(elem)
				.linkbutton({
				plain: true,
				size: "small",
				onClick: retestBG(episodeID, id, vscode, index, rowindex),
				iconCls: "icon-verify",
				})
				.popover({
				trigger: "hover",
				content: "<p>" + $g("复测血糖") + "</p>",
				style: "inverse",
				});
			});
		}
		}
	}
}

function openRetestModal(title) {
  if (curEditorTarget) {
    $(curEditorTarget).tooltip("hide");
  }
  // $('#retestModal').dialog("open");
  $HUI.dialog("#retestModal").setTitle(title || "血糖");
  $("#testDate").datebox("setValue", retestObj.date);
  if (retestObj.verify || !retestObj.time) {
    // 复测血糖，设置默认时间和可编辑
    $("#testTime").timespinner(
      "setValue",
      new Date().toTimeString().slice(0, 5)
    );
  } else {
    $("#testTime").timespinner("setValue", retestObj.time);
  }
  $("#bgValue").val(retestObj.value);
  $("#note").val(retestObj.note);
  getObsTableData();
}

function saveObsRow() {
  if (
    !retestObj.rowId &&
    $("#obsTable").datagrid("getRows").length > 1 &&
    "RBS" != bgConfig[retestObj.itemDr].VSCode
  ) {
    return $.messager.popover({ msg: $g("请选中行编辑！"), type: "alert" });
  }
  if (
    !retestObj.rowId &&
    $("#obsTable").datagrid("getRows").length > 0 &&
    "RBS" != bgConfig[retestObj.itemDr].VSCode &&
    "Y" != retestObj.verify
  ) {
    return $.messager.popover({ msg: $g("血糖值只能新增一次！"), type: "alert" });
  }
  retestObj.time = $("#testTime").timespinner("getValue");
  if (!retestObj.time) {
    return $.messager.popover({ msg: $g("请选择时间！"), type: "alert" });
  }
  // 判断时间
  if (
    new Date(standardizeDate(retestObj.date) + " " + retestObj.time).valueOf() >
    new Date().valueOf()
  ) {
    $.messager.popover({ msg: $g("采集时间不能大于当前时间！"), type: "alert" });
    return false;
  }
  var value = $("#bgValue").val();
  // 校验血糖值
  // if ('' !== value) {
  if ("" !== value && bgConfig[retestObj.itemDr].symbol.indexOf(value) < 0) {
    if (!value || parseFloat(value) != value) {
      return $.messager.popover({ msg: $g("血糖值只能输入数字！"), type: "alert" });
    }
    if (
      parseFloat(value) < parseFloat(bgConfig[retestObj.itemDr].errorLow) ||
      parseFloat(value) > parseFloat(bgConfig[retestObj.itemDr].errorHigh)
    ) {
      return $.messager.popover({
        msg: $g("血糖值超出错误值范围！"),
        type: "alert",
      });
    }
    value = parseFloat(value);
  }
  retestObj.value = value;
  var m = [];
  measures.map(function (e) {
    if ($("#" + e).checkbox("getValue")) m.push(e);
  });
  // 校验措施是否必选
  if ("Y" == retestObj.nurMeasureRequire && !m.length) {
    return $.messager.popover({ msg: $g("请选择处理措施！"), type: "alert" });
  }
  retestObj.measure = m.join(";");
  retestObj.note = $("#note").val().replace(/\//g,"&#47;");
  if (retestObj.note && retestObj.note.length > 200) {
    $.messager.popover({ msg: $g("备注的长度不大于200！"), type: "alert" });
    return false;
  }
  $cm(
    {
      ClassName: "Nur.NIS.Service.VitalSign.BloodGlucoseV2",
      MethodName: "saveSingleVitalSign",
      dataType: "text",
      data: JSON.stringify(retestObj),
    },
    function (data) {
      if ('-1000'==data) {
        applyAuthority();
      } else if (parseInt(data) >= 0) {
        if ((!IsStandardEdition)&&(parseInt(data) > 0)) {
          sendCriticalMsg(retestObj);
        }
        getObsTableData();
        $.messager.popover({ msg: $g("保存成功！"), type: "success" });
      } else {
        $.messager.popover({ msg: $g("保存失败！"), type: "alert" });
      }
    }
  );
}
// 发送危急值消息
function sendCriticalMsg(obj) {
  // 判断是否发送危急值
  $cm(
    {
      ClassName: "Nur.NIS.Service.VitalSign.BloodGlucoseV2",
      MethodName: "JudgeCriticalMsg",
      data: JSON.stringify(obj),
    },
    function (msgdata) {
      msgdata.map(function (d) {
        if (!d.mainDoc) return;
        $cm(
          {
            ClassName: "websys.DHCMessageInterface",
            MethodName: "Send",
            Context: d.measures + " 血糖值：" + d.value,
            ActionTypeCode: d.messageCode,
            FromUserRowId: session["LOGON.USERID"],
            EpisodeId: obj.episodeID,
            OrdItemId: "",
            ToUserRowId: d.mainDoc,
          },
          function (data) {
            if (data > 0) {
              $.messager.popover({
                msg: $g("危急值消息发送成功！"),
                type: "success",
              });
            } else {
              $.messager.popover({
                msg: $g("危急值消息发送失败！"),
                type: "alert",
              });
            }
          }
        );
      });
    }
  );
}

function clearObsRow() {
  var elObj = $("#obsTable");
  var rows = elObj.datagrid("getRows");
  if (!rows.length)
    return $.messager.popover({ msg: $g("无数据可清空！"), type: "alert" });
  var delIDs = [],
    reminder = "";
  reminder = $g("是否要清空以下数据？");
  rows.map(function (e) {
    delIDs.push(e.Id);
  });
  $.messager.confirm($g("删除"), reminder, function (r) {
    if (r) {
      $cm(
        {
          ClassName: "Nur.NIS.Service.VitalSign.BloodGlucoseV2",
          MethodName: "delVitalSign",
          dataType: "text",
          IDs: JSON.stringify(delIDs),
        },
        function (data) {
          if (0 == data) {
            $.messager.popover({ msg: $g("清空成功！"), type: "success" });
            getObsTableData();
            retestObj.rowId = "";
            $("#bgValue").val("");
            $("#measure input").checkbox("setValue", false);
            retestObj.verify = "";
            $("#bgSaveBtn").linkbutton("enable");
          } else {
            $.messager.popover({ msg: data, type: "alert" });
          }
        }
      );
    }
  });
}

function removeObsRow() {
  var elObj = $("#obsTable");
  var row = elObj.datagrid("getSelected");
  if (!row)
    return $.messager.popover({ msg: $g("请先选择要删除的行！"), type: "alert" });
  var rows = elObj.datagrid("getRows");
  var delIDs = [],
    reminder = "";
  if ("RBS" == row.vsCode || "Y" == row.retest) {
    delIDs.push(row.Id);
    reminder = $g("确定要删除选中的数据？");
  } else {
    reminder = $g("删除原始血糖值（若有复测血糖也将同步删除），是否继续？");
    rows.map(function (e) {
      delIDs.push(e.Id);
    });
  }
  $.messager.confirm($g("删除"), reminder, function (r) {
    if (r) {
      $cm(
        {
          ClassName: "Nur.NIS.Service.VitalSign.BloodGlucoseV2",
          MethodName: "delVitalSign",
          dataType: "text",
          IDs: JSON.stringify(delIDs),
        },
        function (data) {
          if (0 == data) {
            $.messager.popover({ msg: $g("删除成功！"), type: "success" });
            getObsTableData();
            retestObj.rowId = "";
            $("#bgValue").val("");
            $("#measure input").checkbox("setValue", false);
            retestObj.verify = "";
            $("#bgSaveBtn").linkbutton("enable");
          } else {
            $.messager.popover({ msg: data, type: "alert" });
          }
        }
      );
    }
  });
}

function selectObsRow(index, row) {
  retestObj.verify = row.retest || "";
  retestObj.rowId = row.Id;
  $("#testTime").timespinner("setValue", row.Time); //赋值
  $("#bgValue").val(row.value);
  updateMeasures();
  $("#measure input").checkbox("setValue", false);
  var measures = row.Measure ? row.Measure.split(";") : [];
  measures.map(function (e) {
    $("#" + e).checkbox("setValue", true);
  });
  $("#note").val(row.Note);
  var flag = "enable";
  if (!row.retest) {
    var rows = $("#obsTable").datagrid("getRows");
    rows.map(function (r) {
      if (r.retest) flag = "disable";
    });
  }
  $("#bgSaveBtn").linkbutton(flag);
}

function getObsTableData() {
  $cm(
    {
      ClassName: "Nur.NIS.Service.VitalSign.BloodGlucoseV2",
      MethodName: "getBGRecordByDayAndObsDr",
      episodeID: retestObj.episodeID,
      date: retestObj.date,
      obsDr: retestObj.itemDr,
    },
    function (data) {
      data.map(function (d,i) {
        var measures=(d.Measure||'').split(';');
        measures.map(function (m,j) {
          measures[j]=$g(m);
        })
        data[i].Measure=measures.join(";");
      });
      $("#obsTable").datagrid("loadData", data);
      $("#retestModal").dialog("open");
      var width=0,$tr=$("#retestForm>table>tbody>tr");
      $tr.map(function (i,t) {
        var display=$(t).css('display');
        console.log(display);
        if ('none'!=display) {
          var w=$(t).find('td>div').width();
          if (w>width) width=w;
        }
      })
      $("#retestForm>table>colgroup>col:eq(0)").attr('style','width:'+(width+20)+'px');
      setTimeout(function () {
        var offsetLeft =
          (window.innerWidth - $("#retestModal").parent().width()) / 2;
        var offsetTop =
          (window.innerHeight - $("#retestModal").parent().height()) / 2;
        $("#retestModal")
          .dialog({
            onClose: getBGRecordByDays,
            left: offsetLeft,
            top: offsetTop,
          })
          .dialog("open");
        clickCellFlag = 1;
        $("#bgValue").focus();
      }, 200);
    }
  );
}

function printBGData() {
    var node = $("#patientTree").tree("getSelected");
    $cm({
        ClassName: 'NurMp.Discharge.Authority',
        MethodName: 'getPatAction',
        dataType: "text",
        EpisodeId: node ? node.episodeID.toString() : EpisodeID,
        MouldType: "XTD",
        UserID: session['LOGON.USERID'],
        Action: "print",
    }, function (data) {
        if (1!=data) {
            $.messager.popover({msg: $g('出院病历未对此操作授权。'),type:'alert'});
            return;
        }else {
          $cm(
            {
              ClassName: "Nur.NIS.Service.VitalSign.BloodGlucose",
              MethodName: "getPrintParam",
            },
            function (res) {
              var serverURL = window.location.href.split("/csp/")[0];
              var emrPrintCode = res.emrPrintCode;
              AINursePrintAll(
                serverURL,
                emrPrintCode,
                node ? node.episodeID.toString() : EpisodeID,
                ""
              );
            }
          );
        }
    });
}

function openBGTrendChart() {
  $("#assessStartDate").datebox(
    "setValue",
    $("#startDate").datebox("getValue")
  );
  $("#assessEndDate").datebox("setValue", $("#endDate").datebox("getValue"));
  var innerWidth = window.innerWidth - 100;
  var innerHeight = window.innerHeight - 100;
  $("#adrsCurveModal")
    .dialog({
      width: innerWidth,
      height: innerHeight,
    })
    .dialog("open");
  $("#adrsGradeCurve").css({
    width: innerWidth - 23 + "px",
    height: innerHeight - ('lite'==HISUIStyleCode?141:145) - 40 + 'px'
  });
  getBGRecordData();
}
function toggleSwitch(e, d) {
  var opts = $("#bloodGlucose").datagrid("getColumnFields");
  var flag = "showColumn";
  timeFlag = d.value ? 1 : 0;
  if (d.value) flag = "hideColumn";
  opts.map(function (e) {
    if (e.indexOf("_Time") > -1) {
      $("#bloodGlucose").datagrid(flag, e);
    }
  });
}
function toggleRemarkSwitch(e, d) {
	var opts = $("#bloodGlucose").datagrid("getColumnFields");
	var flag = "showColumn";
	remarkFlag = d.value ? 1 : 0;
	if (d.value) flag = "hideColumn";
	opts.map(function (e) {
		if (e.indexOf("_Note") > -1) {
			$("#bloodGlucose").datagrid(flag, e);
		}
	});
}
// 获取某些天的血糖记录
function getBGRecordData() {
  var days = [];
  var startDate = $("#assessStartDate").datebox("getValue"),
    endDate = $("#assessEndDate").datebox("getValue");
  while (
    new Date(standardizeDate(startDate)).valueOf() <=
    new Date(standardizeDate(endDate)).valueOf()
  ) {
    days.push(startDate);
    startDate = dateCalculate(new Date(standardizeDate(startDate)), 1);
  }
  var obsDrs = [];
  var keys = Object.keys(bgConfig);
  keys.map(function (e) {
    var v = $("#" + bgConfig[e].VSCode).checkbox("getValue");
    if (v) obsDrs.push(e);
  });
  var episodeId = EpisodeID || (patNode && patNode.episodeID);
  if (!episodeId) return;
  $cm(
    {
      ClassName: "Nur.NIS.Service.VitalSign.BloodGlucoseV2",
      MethodName: "getBGRecordByDays",
      EpisodeIDs: JSON.stringify([episodeId]),
      Dates: JSON.stringify(days),
      ObsDrs: JSON.stringify(obsDrs),
    },
    function (data) {
      var series = [],
        legend = [];
      var trendType=parseInt($('input[name="trendType"]:checked').val());
      if (trendType) {
        for (var i = 0; i < data.length; i++) {
          var v = data[i], dayData = [];
          var keys = Object.keys(v);
          keys.map(function (k) {
            if (k.includes("_Time")) {
              var code = k.split("_Time")[0];
              var vsDesc = bgConfig[bgConfig[code]].VSDesc;
              if (legend.indexOf(vsDesc)<0) {
                legend.push(vsDesc);
                series.push({
                  name: vsDesc,
                  code: code,
                  type: 'line',
                  connectNulls: true,
                  // areaStyle: {},
                  emphasis: {
                    focus: 'series'
                  },
                  data: []
                })
              }
              for (var j = 0; j < series.length; j++) {
                if (code==series[j].code) {
                  // series[j].data[i]=v[code];
                  if (v[code].indexOf('/')<0) {
                    series[j].data[i]={
                      time: v[k],
                      nurse: v[code+'_Nurse'],
                      value:v[code]
                    };
                  } else {
                    var times=v[k].split('/');
                    var values=v[code].split('/');
                    series[j].data[i]={
                      times: v[k],
                      time: times[times.length-1],
                      nurse: v[code+'_Nurse'],
                      values:v[code],
                      value:values[values.length-1]
                    };
                  }
                  break;
                }
              }
            }
          });
        }
        var vsDescs=[];
        bgConfigData.map(function (b) {
          vsDescs.push(b.VSDesc);
        })
        // dayData =
        legend.sort(function (a, b) {
          return vsDescs.indexOf(a) - vsDescs.indexOf(b);
        });
        series.push({
          type:'line',
          markLine:{
            silent:'true', //图形是否不响应和触发鼠标事件，默认为 false，即响应和触发鼠标事件
            data:[{
              yAxis:16.6
            }],
            label:{
              show:true,
              color:'black',
              fontSize:14,
              formatter:16.6
            },
            lineStyle:{
              color:'red',
              // type:"scrollDataIndex"
            },
          }
        });
        series.push({
          type:'line',
          markLine:{
            silent:'true', //图形是否不响应和触发鼠标事件，默认为 false，即响应和触发鼠标事件
            data:[{
              yAxis:3.9
            }],
            label:{
              show:true,
              color:'black',
              fontSize:14,
              formatter:3.9
            },
            lineStyle:{
              color:'blue',
              // type:"scrollDataIndex"
            },
          }
        });
      } else {
        for (var i = 0; i < data.length; i++) {
          var v = data[i],
            dayData = [];
          if (!trendType) legend.push(v.date);
          var keys = Object.keys(v);
          keys.map(function (k) {
            if (k.includes("_Time")) {
              var code = k.split("_Time")[0];
              if (v[code].includes("/")) {
                var values = v[code].split("/");
                for (var j = 0; j < values.length; j++) {
                  var time = v[k].split("/")[j];
                  dayData.push({
                    date: v.date,
                    time: time,
                    value: ["2021-03-13 " + time, values[j]],
                    nurse: v[code + "_Nurse"].split("/")[j],
                  });
                }
              } else {
                dayData.push({
                  date: v.date,
                  time: v[k],
                  value: ["2021-03-13 " + v[k], v[code]],
                  nurse: v[code + "_Nurse"],
                });
              }
            }
          });
          dayData.sort(function (a, b) {
            return (
              new Date(a.value[0]).valueOf() - new Date(b.value[0]).valueOf()
            );
          });
          series.push({
            name: v.date,
            type: "line",
            connectNulls: true,
            data: dayData,
          });
        }
        series.unshift({
          name: "",
          type: "line",
          data: [
            {
              date: "",
              time: "00:00",
              value: ["2021-03-13 00:00", 3.9],
              nurse: "",
            },
          ],
          markLine: {
            data: [{ type: "average", name: "" }],
            lineStyle: {
              // type:'solid',
              color: {
                type: "linear",
                x: 0,
                y: 0,
                x2: 0,
                y2: 1,
                colorStops: [
                  {
                    offset: 0,
                    color: "blue", // 0% 处的颜色
                  },
                  {
                    offset: 1,
                    color: "blue", // 100% 处的颜色
                  },
                ],
              },
            },
          },
        });
        series.push({
          name: "",
          type: "line",
          data: [
            {
              date: "",
              time: "24:00",
              value: ["2021-03-13 23:59", 16.6],
              nurse: "",
            },
          ],
          markLine: {
            data: [{ type: "average", name: "" }],
            lineStyle: {
              // type:'solid',
              color: {
                type: "linear",
                x: 0,
                y: 0,
                x2: 0,
                y2: 1,
                colorStops: [
                  {
                    offset: 0,
                    color: "red", // 0% 处的颜色
                  },
                  {
                    offset: 1,
                    color: "red", // 100% 处的颜色
                  },
                ],
              },
            },
          },
        });
      }
      // 基于准备好的dom，初始化echarts实例
      // $("#adrsGradeCurve").empty();
      if (!myChart) {
        myChart = echarts.init(document.getElementById("adrsGradeCurve"));
      } else {
        myChart.clear();
      }
      var blanks = [];
      console.log($("#adrsGradeCurve").width());
      var len = Math.floor(($("#adrsGradeCurve").width() * 26 - 2092) / 285);
      console.log(len);
      var chartTitle=$g("血糖趋势图");
      for (var i = len+(5-chartTitle.length)/2; i >= 0; i--) {
        blanks.push(" ");
      }
      // 指定图表的配置项和数据
      var option = {
        title: {
          text: chartTitle + blanks.join(""),
          x: "right",
          y: "top",
          textAlign: "left",
          padding: [8, 0, 0, 0],
        },
        tooltip: {
          trigger: "item",
          formatter: function (v, i) {
            if (trendType) {
              if (!v.data) return;
              var content = '<table cellpadding="0" style="border-collapse: collapse;white-space: nowrap;color:white;margin:5px 7px;">';
              content += '<tr><td style="text-align:right;">'+$g("录入日期：")+'</td><td>'+v.name+'</td></tr>';
              content += '<tr><td style="text-align:right;">'+$g("采集时间：")+'</td><td>'+(v.data.times||v.data.time)+'</td></tr>';
              if (v.value == parseFloat(v.value)) {
                content += '<tr><td style="text-align:right;">'+$g("血糖值：")+'</td><td>'+(v.data.values||v.value)+'</td></tr>';
              } else {
                content += '<tr><td style="text-align:right;">'+$g("血糖值：")+'</td><td>'+ v.value+'</td></tr>';
              }
              content += '<tr><td style="text-align:right;">'+$g("录入人：")+'</td><td>'+v.data.nurse+'</td></tr>';
              content += '</table>';
              return content;
            } else {
              if (!v.data.value[1]) return;
              var content = '<table cellpadding="0" style="border-collapse: collapse;white-space: nowrap;color:white;margin:5px 7px;">';
              content += '<tr><td style="text-align:right;">'+$g("录入日期：")+'</td><td>'+v.data.date+'</td></tr>';
              content += '<tr><td style="text-align:right;">'+$g("采集时间：")+'</td><td>'+v.data.time+'</td></tr>';
              if (v.data.value[1] == parseFloat(v.data.value[1])) {
                content += '<tr><td style="text-align:right;">'+$g("血糖值：")+'</td><td>'+v.data.value[1] +'mmol/L</td></tr>';
              } else {
                content += '<tr><td style="text-align:right;">'+$g("血糖值：")+'</td><td>'+ v.data.value[1] +'</td></tr>';
              }
              content += '<tr><td style="text-align:right;">'+$g("录入人：")+'</td><td>'+v.data.nurse+'</td></tr>';
              content += '</table>';
              return content;
            }
          },
        },
        legend: {
          data: legend,
          x: "center",
          y: "top",
          padding: [35, 20, 0, 0],
        },
        grid: {
          left: "3%",
          right: "4%",
          bottom: "3%",
          containLabel: true,
        },
        toolbox: {
          feature: {
            saveAsImage: {},
          },
        },
        xAxis: trendType?{
          type: 'category',
          boundaryGap: false,
          data: days
        }:{
          type: "time",
          interval: 3 * 3600 * 1000,
          boundaryGap: false,
          axisLabel: {
            formatter: function (value, index) {
              var date = new Date(value);
              return date.toString().split(" ")[4].slice(0, 5);
            },
          },
          splitLine: {
            show: false,
          },
        },
        yAxis: {
          type: "value",
          min: 0.0,
          max: 22.2,
          data: [0, 3.9, 7, 10, 13.9, 16.6, 22.2],
          splitLine: {
            lineStyle: {
              color: "#d9d9d9",
              width: 0.8,
              opacity: 0.4,
            },
          },
        },
        series: series,
      };
      // 使用刚指定的配置项和数据显示图表。
      console.log(JSON.stringify(option));
      myChart.setOption(option);
    }
  );
}

function updateSbgTableSize() {
	var innerHeight = window.innerHeight;
	$("#adrsPanel").panel("resize", {
		height: innerHeight -50
	});
	var height = innerHeight - (IsStandardEdition ? 135 : 167);
	$("#bloodGlucose").datagrid("resize", {
		height: height
	});
}
window.addEventListener("resize", updateSbgTableSize);