/**
 * @author wujiang
 * @description 单人录入界面 20200222
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
      var fields = $(this)
        .datagrid("getColumnFields", true)
        .concat($(this).datagrid("getColumnFields"));
      for (var i = 0; i < fields.length; i++) {
        var col = $(this).datagrid("getColumnOption", fields[i]);
        col.editor1 = col.editor;
        // if (fields[i] != param.field){
        if (param.field.indexOf(fields[i]) < 0) {
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
if (!Array.from) {
  Array.from = function (el) {
    return Array.apply(this, el);
  };
}
var delimiter = String.fromCharCode(12);
var GV = {
  tabCode: "",
  columns: "",
  episodeID: "",
  visitTime: "", //就诊时间
  lastTimeInHosp: "", //就诊时间
  dateformat: "", //时间格式
  orders: [],
  ClassName: "Nur.InService.AppointPatManage",
};
var EpisodeID,
  singleConfig = [],
  singleConfigObj,
  dateformat;
var babyCode = {
  // 使用老版维护界面维护得项目不对， 成人和婴儿不同的项目描述维护的code一样了，我们新版处理不了同一个项目code不同的描述
  // 婴儿时，flag为空，替换对应的code为该item的描述
  Item9: "小便",
  Item10: "脐部情况",
  Item11: "大便(色)",
  Item14: "大便(次)",
  Item18: "脐带",
  Item23: "皮肤",
};
var ifBaby = 0; //1婴儿，0成人
var timeArr = []; // ["02:00", "06:00", "10:00", "14:00", "18:00", "22:00"]
var blurData; //记录失焦时的数据，不同再更新
var patientInfo = {}; //患者信息
/*-----------------------------------------------------------*/
var init = function () {
  // console.log('---------window---------');
  // console.log(window);
  // console.log('---------window.session---------');
  // console.log(window.session);
  // console.log('---------$HUI---------');
  // console.log($HUI);
  getSystemSetting();
  initBasicData();
};
$(init);
// enter切换input
document.addEventListener(
  "keyup",
  function (event) {
    if ([13, 38, 40].includes(event.keyCode)) {
      var inputs = document.querySelectorAll("#vitalSigns tr input");
      var input = document.querySelector("#vitalSigns tr input:focus");
      inputs = Array.from(inputs);
      var i = inputs.indexOf(input);
      if (i > -1) {
        if (38 == event.keyCode) {
          i--;
          if ("combo-value" == inputs[i].className) i--;
        } else {
          i++;
          if ("combo-value" == inputs[i].className) i++;
        }
        inputs[i] && inputs[i].focus();
      }
    }
  },
  false
);
function updatePatientInfo(rowData) {
  console.log(rowData);
  patientInfo = rowData;
  // 更新患者信息
  // var frm = dhcsys_getmenuform();

  if (rowData["motherADM"]) {
    ifBaby = 1;
  } else if (rowData["PAPMIAge"]) {
    if (parseFloat(rowData["PAPMIAge"]) < 18) {
      ifBaby = 1;
    } else {
      ifBaby = 0;
    }
  } else {
    ifBaby = 0;
  }
  // console.log(rowData["EpisodeID"]);
  GV.episodeID = rowData["EpisodeID"];

  var timer = setInterval(function () {
    if (GV.dateformat) {
      clearInterval(timer);
      if (!rowData["PAAdmDate"] || !rowData["PAAdmTime"]) {
        GV.visitTime = "";
        $.messager.popover({
          msg: "入院时间为空，不可录入体征数据。",
          type: "alert",
        });
        setTimeout(function () {
          var textboxArray = $("#vitalSigns input.textbox");
          textboxArray.map(function (index, elem) {
            $(elem)
              .attr({ disabled: true })
              .next(".symbol")
              .addClass("disabled"); //禁用;
          });
          var comboxArray = $("#vitalSigns .hisui-combobox");
          comboxArray.map(function (index, elem) {
            $(elem).combobox({ disabled: true }); //禁用;
          });
        }, 1000);
        // $('#logDate').datebox({disabled:true,setValue: formatDate(new Date())});//禁用;
        // $('#logTime').timespinner('disable');
        return;
      } else {
        // $('#logDate').datebox({disabled:false,setValue: formatDate(new Date())});
        // $('#logTime').timespinner('enable');
      }
      var yPos = GV.dateformat.indexOf("YYYY");
      var year = rowData["PAAdmDate"].slice(yPos, yPos + 4);
      var mPos = GV.dateformat.indexOf("MM");
      var month = rowData["PAAdmDate"].slice(mPos, mPos + 2);
      var dPos = GV.dateformat.indexOf("DD");
      var day = rowData["PAAdmDate"].slice(dPos, dPos + 2);
      GV.visitTime =
        year + "/" + month + "/" + day + " " + rowData["PAAdmTime"].slice(0, 5);
      console.log(GV.visitTime);
      if (rowData["lastTimeInHosp"]) {
        var year = rowData["lastTimeInHosp"].slice(yPos, yPos + 4);
        var month = rowData["lastTimeInHosp"].slice(mPos, mPos + 2);
        var day = rowData["lastTimeInHosp"].slice(dPos, dPos + 2);
        GV.lastTimeInHosp =
          year + "/" + month + "/" + day + " " + rowData["lastTimeInHosp"].split(" ")[1];
      } else {
        GV.lastTimeInHosp="";
      }
    }
  }, 100);
  // findTempDataByDay()
  /// getSystemSetting();
  initBasicData();
}
// 获取系统配置
function getSystemSetting() {
  // 获取SingleConfig
  $cm(
    {
      ClassName: "Nur.NIS.Service.System.Config",
      MethodName: "GetSystemConfig",
    },
    function (result) {
      GV.dateformat = result.dateformat;
      dateformat = result.dateformat;
    }
  );
}
// 获取某些天的血糖记录
function setTimeVal(obj) {
  $("#logTime").timespinner("setValue", $(obj).data("time"));
  // findTempDataByDay();
}
// 初始化基础数据
function initBasicData() {
  // if(GV.episodeID!=""){
  //     $cm({
  //         ClassName: 'Nur.NIS.Service.Chart.DAO.Temperature',
  //         MethodName: "getTimePointJson",
  //         EpisodeID:GV.episodeID
  //     }, function (result) {
  //         timeArr=result.length>0 ? result : ["02:00", "06:00", "10:00", "14:00", "18:00", "22:00"];
  //     });
  // }else{
  //     timeArr= ["02:00", "06:00", "10:00", "14:00", "18:00", "22:00"];
  // }

  var endPoint = vsGenelConfig.endPoint.split(",");
  var timePoint = vsGenelConfig.timePoint.split(",");
  var curTime = new Date().toString().split(" ")[4].slice(0, 5);
  for (var i = 0; i < endPoint.length; i++) {
    if (curTime < endPoint[i]) {
      $("#logTime").timespinner("setValue", timePoint[i]);
      break;
    }
  }
  for (var i = 0; i < timePoint.length; i++) {
    $(".timePointBtn:eq(" + i + ")")
      .attr("data-time", timePoint[i])
      .find(".l-btn-text")
      .html(parseInt(timePoint[i]));
  }

  // 获取SingleConfig
  $cm(
    {
      ClassName: "Nur.NIS.Service.VitalSign.Temperature",
      MethodName: "GetAllTempConfig",
      locID: session["LOGON.CTLOCID"],
      time: "",
      wardId: session["LOGON.WARDID"],
    },
    function (result) {
      // console.log(result);
      if (1 == ifBaby) {
        // 婴儿时，flag为空，替换对应的code为该item的描述
        result.SingleConfig.map(function (elem) {
          if ("" === elem.flag) {
            elem.desc = babyCode[elem.code] || elem.desc;
          }
        });
      }
      singleConfig = result.SingleConfig;
      singleConfigObj = {};
      for (var i = 0; i < singleConfig.length; i++) {
        var e = singleConfig[i];
        singleConfig[i].desc = $g(e.desc);
        singleConfig[i].yestDesc = $g(e.yestDesc);
        // 去除成人婴儿体征不匹配的项
        if (0 == ifBaby && 1 == e.flag) {
          singleConfig.splice(i, 1);
          i--;
          continue;
        }
        if (1 == ifBaby && "0" === e.flag) {
          singleConfig.splice(i, 1);
          i--;
          continue;
        }
        singleConfigObj[e.code] = e;
      }
      GV.configData = result.SingleConfig;
      GV.data = checkAdultOrBaby(
        GV.configData,
        // this.$attrs.patientMsg.ifNewBaby
        ifBaby
      );
      // console.log(JSON.stringify(GV.data));
      for (var j = 0; j < GV.data.length; j++) {
        if ("true" === GV.data[j].blank || true === GV.data[j].blank) {
          // console.log(JSON.stringify(GV.data[j]));
          var blankTrueIndex = j;
          var blankInfo = GV.data.splice(blankTrueIndex, 1)[0];
          for (var k = 0; k < GV.data.length; k++) {
            if (blankInfo.blankTitleCode == GV.data[k].code) {
              // console.log(JSON.stringify(GV.data[k]));
              GV.data[k].blankTitleInputTime = blankInfo.blankTitleInputTime;
              GV.data[k].codeOri = GV.data[k].code;
              GV.data[k].select = false;
              GV.data[k].code = blankInfo.code;
              GV.data[k].times = blankInfo.times;
              break;
            }
          }
          j--;
        }
      }
      // console.log(JSON.stringify(GV.data));
      // 初始化时间
      $("#logDate").datebox("setValue", formatDate(new Date()));
      // $("#logTime").timespinner('setValue', timeArr[Math.floor(new Date().getHours() / 4)]);  //赋值
      findTempDataByDay();
    }
  );
  setPatientInfo(GV.episodeID);
  // 模态框关闭后事件
  $("#vsddModal").dialog({
    onClose: function () {
      findTempDataByDay();
      hrefRefresh();
    },
  });
  $("#patEvtModal").dialog({
    onClose: function () {
      findTempDataByDay();
      hrefRefresh();
    },
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
      EpisodeID: EpisodeID,
    },
    function (html) {
      if (html != "") {
        $(".PatInfoItem").html(reservedToHtml(html));
        var n = 0;
        var timer = setInterval(function () {
          $(".ctcAEPatBar").height(
            Math.max($(".ctcAEPatBar>.patientbar>.PatInfoItem").height(), 35)
          );
          n++;
          if (n > 9) {
            clearInterval(timer);
          }
        }, 50);
        init();
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
      "&#38;": "&",
    };
    return str.replace(
      /(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,
      function (v) {
        return replacements[v];
      }
    );
  }
}
// 判断成人婴儿
function checkAdultOrBaby(data, flag) {
  // flag //0成人，1婴儿
  return data.filter(function (elem) {
    return (
      flag == elem.flag || "" === elem.flag || "undefined" == typeof elem.flag
    );
  });
}
// 获取单个时间点体征数据
function findTempDataByDay(date) {
  if (date && !GV.visitTime) {
    return;
  }
  // console.log(111);
  // console.log(GV.episodeID);
  if (!GV.episodeID) {
    return;
  }
  EpisodeID = GV.episodeID;
  var count = 0;
  var curDay = $("#logDate").datebox("getValue");
  var newDay = Date.parse(standardizeDate(curDay)) - 24 * 3600 * 1000;
  var preDay = formatDate(new Date(newDay));
  var preRes, res;
  $cm(
    {
      ClassName: "Nur.NIS.Service.VitalSign.Temperature",
      MethodName: "GetPatientsTempDataByTime",
      episodeIDString: JSON.stringify([GV.episodeID]),
      date: preDay,
      time: $("#logTime").timespinner("getValue"),
      LocId: "",
    },
    function (data) {
      preRes = data[0];
      count++;
    }
  );
  $cm(
    {
      ClassName: "Nur.NIS.Service.VitalSign.Temperature",
      MethodName: "GetPatientsTempDataByTime",
      episodeIDString: JSON.stringify([GV.episodeID]),
      date: curDay,
      time: $("#logTime").timespinner("getValue"),
      LocId: "",
    },
    function (data) {
      res = data[0];
      count++;
    }
  );
  var timer = setInterval(function () {
    if (count > 1) {
      clearInterval(timer);
      var html = "";
      console.log(GV.data);
      GV.data.map(function (elem, index) {
        html += "<tr>";
        if (elem.codeOri) {
          elem.select = true;
          if (elem.yestDesc) {
            html +=
              "<td>" +
              getShowType(
                elem,
                preRes[elem.codeOri] && preRes[elem.codeOri].value,
                1
              ) +
              "</td>";
          } else {
            html +=
              "<td>" +
              getShowType(
                elem,
                res ? (res[elem.codeOri] && res[elem.codeOri].value) : "",
                1
              ) +
              "</td>";
          }
          elem.select = false;
          if (elem.yestDesc) {
            html +=
              "<td>" +
              getShowType(elem, preRes[elem.code] && preRes[elem.code].value) +
              "</td>";
          } else {
            html +=
              "<td>" +
              getShowType(elem, res ? (res[elem.code] && res[elem.code].value) : "") +
              "</td>";
          }
        } else {
          html += "<td>" + (elem.yestDesc || elem.desc) + "</td>";
          if (elem.yestDesc) {
            html +=
              "<td>" +
              getShowType(elem, preRes ? (preRes[elem.code] && preRes[elem.code].value) : "","",preRes ? preRes.fControl[elem.code] : "") +
              "</td>";
          } else {
            html +=
              "<td>" +
              getShowType(elem, res ? (res[elem.code] && res[elem.code].value) : "","",res ? (res.fControl ? res.fControl[elem.code] : "") : "") +
              "</td>";
          }
        }
        html += "</tr>";
      });
      $("table#vitalSigns").html(html);
      $("table#vitalSigns input.textbox")
        .css({
          width: "130px",
          height: "30px",
        })
        .blur(checkValueWhenBlur);
      $("table#vitalSigns .hisui-combobox")
        .css("width", "137px")
        .combobox({
          onChange: function (nval, oVal) {
            console.log(1111);
            saveVitalSigns(true);
          },
        });
      $("table#vitalSigns td>.symbol>span").bind("click", function () {
        var html = $(this).html();
        var $input = $(this).parent().prev("input");
        $input.val($input.val() + html);
      });
      $("table#vitalSigns td .blankTitle+span").bind("dblclick", function () {
        $(this).prev().combo("enable");
        $.messager.popover({
          msg: "如若更改该空白栏标题，则本住院周的数据都将被更改。",
          type: "info",
        });
      });
			showSeFControlTip();
    }
  });
}
function showSeFControlTip(){
	var $select = $("#vitalSigns select.fControl");
	$select.next().children('input:eq(0)').addClass('fControl').attr('readonly',true);
	var $td = $("#vitalSigns input.fControl");
	console.log($td);
	$td.mouseenter(function (event) {
		console.log(event);
		var fcdata = $(this).attr("fcdata");
		if (!fcdata) {
			fcdata = $(this).parent().prev().attr("fcdata");
		}
		if (!fcdata) return;
		fcdata=fcdata.split(delimiter);
		var content = "体征项已录入，不允许多次录入！<br>";
		content += "操作时间：" + fcdata[0] + "<br>";
		content += "数据时间：" + fcdata[1] + "<br>";
		content += "数值：" + fcdata[2] + "<br>";
		content += "操作用户：" + fcdata[3] ;
		var placement = "bottom";
		var index = $(this).parentsUntil('tr').parent().index();
		if (index > 8) placement = "top";
		$(this).popover({
			trigger: "manual",
			placement: placement,
			content: content,
		}).popover("show");
	}).mouseleave(function () {
		if ($(this) && $(this).popover) {
			try {
				$(this).popover("hide");
			} catch (e) {}
		}
	});
}
// 获取显示类型，input或者select
function getShowType(obj, val, flag,itmControl) {
  if ("undefined" == typeof val) {
    val = "";
  }
  var itmLen=itmControl ? itmControl.values.length : 0;
  var html = "";
  if ("true" === obj.select || true === obj.select) {
    if (obj.codeOri) {
      if (val && flag) {
        html +=
          '<select class="hisui-combobox blankTitle" placeholder="' +
          (obj.yestDesc || obj.desc) +
          '" disabled value="' +
          val +
          '">';
      } else {
        html +=
          '<select class="hisui-combobox" placeholder="' +
          (obj.yestDesc || obj.desc) +
          '" value="' +
          val +
          '">';
      }
    } else {
			var fcFlag;
			if (obj.formulaControl=="Y") {				
				if ((''===val)&&(obj.times.length<=itmLen)) {
					fcFlag=1;
				}
			}
			if (fcFlag) {
				var fcdata=itmControl.opeTimes.join('/') + delimiter + itmControl.dataTimes.join('/') + delimiter + itmControl.values.join('/') + delimiter + itmControl.users.join('/') ;
				html += '<select readonly class="hisui-combobox fControl" value="' + val + '" fcdata="' + fcdata + '">';
			} else {
				html += '<select class="hisui-combobox" value="' + val + '">';
			}
    }
    html += '<option value=""></option>';
    if (obj.options.indexOf(val) < 0) obj.options.push(val);
    obj.options.map(function (elem) {
      if (val == elem) {
        html += '<option value="' + elem + '" selected>' + elem + "</option>";
      } else {
        html += '<option value="' + elem + '">' + elem + "</option>";
      }
    });
    html += "</select>";
  } else {
		var fcFlag;
		if (obj.formulaControl=="Y") {
			if ((''===val)&&(obj.times.length<=itmLen)) {
				fcFlag=1;
			}
		}
		if (fcFlag) {
			var fcdata = itmControl.opeTimes.join('/') + delimiter + itmControl.dataTimes.join('/') + delimiter + itmControl.values.join('/') + delimiter + itmControl.users.join('/') ;
			html += '<input readonly value="' + val + '" fcdata="' + fcdata + '" data-obj=\'' + JSON.stringify(obj) + '\' class="textbox fControl">';
		} else {
			html += '<input value="' + val + "\" data-obj='" + JSON.stringify(obj) + '\' class="textbox">';
			if (obj.symbol && obj.symbol.length) {
				html += '<div class="symbol">';
				obj.symbol.map(function (elem) {
					html += "<span>" + elem + "</span>";
				});
				html += "</div>";
			}
		}
  }
  return html;
}
function checkValueWhenBlur() {
  checkInputValue(true);
}
function checkInputValue(saveFlag) {
  var inputVal;
  $("table#vitalSigns")
    .find("tr.error,tr.warning")
    .removeClass("error warning");
  var time = $("#logTime").timespinner("getValue"),
    data = [],
    flag = false;
  GV.data.map(function (elem, index) {
    var $tr = $("table#vitalSigns tr:eq(" + index + ")");
    if (elem.codeOri) {
      var $select = $tr.find("td:eq(0) select.hisui-combobox");
      // var value=$tr.find('td:eq(0) input.combo-value').val()
      var value = $select.combobox("getValue");
      if ("" === value && "Y" == elem.udFlag) {
        value = $select.combobox("textbox").val();
        $select.combobox("setValue", value);
      }
      data.push({
        code: elem.codeOri,
        yestDesc: elem.yestDesc || "",
        value: value,
        time: time,
      });
      $inputVal = $tr.find("td:eq(1)>input").val();
    } else {
      if ("true" === elem.select || true === elem.select) {
        var $select = $tr.find("td:eq(1) select.hisui-combobox");
        // var value=$tr.find('td:eq(1) input.combo-value').val()
        var value = $select.combobox("getValue");
        if ("" === value && "Y" == elem.udFlag) {
          value = $select.combobox("textbox").val();
          $select.combobox("setValue", value);
        }
        data.push({
          code: elem.code,
          yestDesc: elem.yestDesc || "",
          value: value,
          time: time,
        });
        return;
      } else {
        $inputVal = $tr.find("td:eq(1)>input").val();
      }
    }
    if (("true" === elem.validate || true === elem.validate) && $inputVal) {
      var symbol = elem.symbol;
      if (!symbol || !symbol.includes($inputVal)) {
        // 有范围约束的必须是数字
        if (
          elem.normalValueRangTo ||
          elem.errorValueHightFrom ||
          elem.errorValueLowTo ||
          elem.normalValueRangFrom
        ) {
          if (!$inputVal.match(/(^[1-9][0-9]*|^[0]{1})([\.][0-9]{1,2})?$/g)) {
            flag = true;
            $tr.addClass("error");
            // $.messager.popover({msg: elem.desc+'的值是数字类型。',type:'error'});
            return "error";
          }
        }
        // 当有error范围值的时候进行error校验
        if (
          elem.errorValueHightFrom &&
          parseFloat($inputVal) > parseFloat(elem.errorValueHightFrom)
        ) {
          flag = true;
          $tr.addClass("error");
          // $.messager.popover({msg: elem.desc+'的值不能大于'+elem.errorValueHightFrom,type:'error'});
          return;
        }
        if (
          elem.errorValueLowTo &&
          parseFloat($inputVal) < parseFloat(elem.errorValueLowTo)
        ) {
          flag = true;
          $tr.addClass("error");
          // $.messager.popover({msg: elem.desc+'的值不能小于'+elem.errorValueLowTo,type:'error'});
          return;
        }
        // 当有warning范围值的时候进行warning校验
        if (
          parseFloat($inputVal) < parseFloat(elem.normalValueRangFrom) ||
          parseFloat($inputVal) > parseFloat(elem.normalValueRangTo)
        ) {
          $tr.addClass("warning");
        }
      }
    }
    data.push({
      code: elem.code,
      yestDesc: elem.yestDesc || "",
      value: $inputVal,
      time: time,
    });
  });
  if (saveFlag) {
    if (blurData != JSON.stringify(data)) {
      blurData = JSON.stringify(data);
      saveVitalSigns(true);
    }
  }
  return [flag, data];
}
function saveVitalSigns(noRemindFlag) {
  var curLogDate = new Date(
    (
      standardizeDate($("#logDate").datebox("getValue")) +
      " " +
      $("#logTime").timespinner("getValue")
    ).replace(/-/g, "/")
  );
  if (!GV.visitTime) {
    return;
  }
  if (!GV.episodeID) {
    $.messager.popover({ msg: "请先选择患者", type: "alert" });
    return;
  }
  var date = $("#logDate").datebox("getValue");
  var time = $("#logTime").timespinner("getValue"),
    data = [],
    flag = false;
  if (!date || !time) {
    $.messager.popover({ msg: "时间不能为空。", type: "alert" });
    return;
  } else {
    var month = (curLogDate.getMonth() + 1).toString();
    if (month.length < 2) {
      month = "0" + month;
    }
    var day = curLogDate.getDate().toString();
    if (day.length < 2) {
      day = "0" + day;
    }
    var dateTime =
      curLogDate.getFullYear() + "/" + month + "/" + day + " " + time;
    var dateTime2 =
      curLogDate.getFullYear() + "/" + month + "/" + day + " 00:00:00";
    if (new Date(dateTime2).valueOf() > new Date().valueOf()) {
      $.messager.popover({ msg: "不能录入当天以后的数据。", type: "alert" });
      return;
    }
    // 是否要判断入院日期
    //if (config.inHospDateTimeFlag) {
    if (new Date(dateTime).valueOf() < new Date(GV.visitTime).valueOf()) {
      $.messager.popover({
        msg: "不能录入就诊时间之前的数据。",
        type: "alert",
      });
      return;
    }
    // 是否要判断入院日期
    if (GV.lastTimeInHosp&&(new Date(dateTime).valueOf() > new Date(GV.lastTimeInHosp).valueOf())) {
      $.messager.popover({
        msg: "不能录入最后在院时间之后的数据。",
        type: "alert",
      });
      return;
    }
    //}
  }
  var result = checkInputValue();
  flag = result[0];
  data = result[1];
  if (flag) {
    return;
  }
  var blankVal = "",
    blankTitleVal = "",
    checkObj = {};
  data.map(function (d) {
    checkObj[d.code] = d.value;
  });
  var keys = Object.keys(checkObj),
    refuseFlag = false;
  keys.map(function (k) {
    blankVal = checkObj[k];
    blankTitleVal = checkObj[k + "_Title"];
    if ("" === blankTitleVal && "" !== blankVal) refuseFlag = true;
  });
  if (refuseFlag) {
    $.messager.popover({
      msg: $g("录入空白栏数据前请先录入空白栏标题！"),
      type: "alert",
    });
    return false;
  }
  var yestData = [];
  for (var i = 0; i < data.length; i++) {
    if (data[i].yestDesc) {
      yestData.push(data[i]);
      data.splice(i, 1);
      i--;
    }
  }
  if (yestData.length) {
    var yestday = Date.parse(standardizeDate(date)) - 24 * 3600 * 1000;
    yestday = formatDate(new Date(yestday));
    $cm(
      {
        ClassName: "Nur.NIS.Service.VitalSign.Temperature",
        MethodName: "SaveObsDataByDay",
        dataType: "text",
        episodeID: GV.episodeID,
        modifyData: JSON.stringify(yestData),
        userID: session["LOGON.USERID"],
        date: yestday,
        userLocID: session["LOGON.CTLOCID"],
        wardID: session["LOGON.WARDID"],
      },
      function (res) {
		if ('-1000'==res) {
			$('#disControl-dialog').dialog("open");
		} else if (0==parseInt(res)) {
		  if (res.toString().indexOf('^')>-1) {
			  $.messager.popover({msg: $g(res.split('^')[1]),type:'alert'});
		  }
		}
	  }
    );
  }
  $cm(
    {
      ClassName: "Nur.NIS.Service.VitalSign.Temperature",
      MethodName: "SaveObsDataByDay",
		dataType: "text",
      episodeID: GV.episodeID,
      modifyData: JSON.stringify(data),
      userID: session["LOGON.USERID"],
      date: date,
      userLocID: session["LOGON.CTLOCID"],
      wardID: session["LOGON.WARDID"],
    },
    function (res) {
		if ('-1000'==res) {
			$('#disControl-dialog').dialog("open");
		} else if (0==parseInt(res)) {
		if (res.toString().indexOf('^')>-1) {
			$.messager.popover({msg: $g(res.split('^')[1]),type:'alert'});
		}else if (!noRemindFlag) {
            $.messager.popover({msg: $g('数据保存成功'),type:'success'});
        }
        hrefRefresh();
      } else {
        $.messager.popover({ msg: res, type: "alert" });
      }
    }
  );
}
// 设置入院时间
function setInHospDateTime() {
  $("#logDate").datebox("setValue", patientInfo.PAAdmDate);
  $("#logTime").timespinner("setValue", patientInfo.PAAdmTime.slice(0, 5));
  findTempDataByDay();
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

function onSelectDate(){	
	var curDate = $("#logDate").datebox("getValue");
	runClassMethod("Nur.NIS.Service.Chart.DAO.PatInfo","getPageNum",{"EpisodeID":EpisodeID,"MeasureDate":curDate,"ChartDr":chartID},function(pageNum){
		if(pageNum){
			findTempDataByDay();
			if(page==pageNum) return;
			if(pageNum>totalPage) return;			
			page=pageNum; 
			$("#pageInput").triggerbox('setValue',page);
			jumpPage();
		}
	},'json',false)
}
