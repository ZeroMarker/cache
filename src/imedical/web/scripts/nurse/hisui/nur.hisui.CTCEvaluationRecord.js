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
$.extend($.fn.datagrid.defaults, {
  onBeforeDrag: function (row) {}, // return false to deny drag
  onStartDrag: function (row) {},
  onStopDrag: function (row) {},
  onDragEnter: function (targetRow, sourceRow) {}, // return false to deny drop
  onDragOver: function (targetRow, sourceRow) {}, // return false to deny drop
  onDragLeave: function (targetRow, sourceRow) {},
  onBeforeDrop: function (targetRow, sourceRow, point) {},
  onDrop: function (targetRow, sourceRow, point) {}, // point:'append','top','bottom'
});
$.extend($.fn.datagrid.methods, {
  enableDnd: function (jq, index) {
    return jq.each(function () {
      var target = this;
      var state = $.data(this, "datagrid");
      state.disabledRows = [];
      var dg = $(this);
      var opts = state.options;
      if (index != undefined) {
        var trs = opts.finder.getTr(this, index);
      } else {
        var trs = opts.finder.getTr(this, 0, "allbody");
      }
      trs
        .draggable({
          disabled: false,
          revert: true,
          cursor: "pointer",
          proxy: function (source) {
            var index = $(source).attr("datagrid-row-index");
            var tr1 = opts.finder.getTr(target, index, "body", 1);
            var tr2 = opts.finder.getTr(target, index, "body", 2);
            var p = $('<div style="z-index:9999999999999"></div>').appendTo(
              "body"
            );
            tr2.clone().removeAttr("id").removeClass("droppable").appendTo(p);
            tr1
              .clone()
              .removeAttr("id")
              .removeClass("droppable")
              .find("td")
              .insertBefore(p.find("td:first"));
            $(
              '<td><span class="tree-dnd-icon tree-dnd-no" style="position:static">&nbsp;</span></td>'
            ).insertBefore(p.find("td:first"));
            p.find("td").css("vertical-align", "middle");
            p.hide();
            return p;
          },
          deltaX: 15,
          deltaY: 15,
          onBeforeDrag: function (e) {
            if (opts.onBeforeDrag.call(target, getRow(this)) == false) {
              return false;
            }
            if ($(e.target).parent().hasClass("datagrid-cell-check")) {
              return false;
            }
            if (e.which != 1) {
              return false;
            }
            opts.finder
              .getTr(target, $(this).attr("datagrid-row-index"))
              .droppable({ accept: "no-accept" });
          },
          onStartDrag: function () {
            $(this).draggable("proxy").css({
              left: -10000,
              top: -10000,
            });
            var row = getRow(this);
            opts.onStartDrag.call(target, row);
            state.draggingRow = row;
          },
          onDrag: function (e) {
            var x1 = e.pageX,
              y1 = e.pageY,
              x2 = e.data.startX,
              y2 = e.data.startY;
            var d = Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
            if (d > 3) {
              // when drag a little distance, show the proxy object
              $(this).draggable("proxy").show();
              var tr = opts.finder.getTr(
                target,
                parseInt($(this).attr("datagrid-row-index")),
                "body"
              );
              $.extend(e.data, {
                startX: tr.offset().left,
                startY: tr.offset().top,
                offsetWidth: 0,
                offsetHeight: 0,
              });
            }
            this.pageY = e.pageY;
          },
          onStopDrag: function () {
            for (var i = 0; i < state.disabledRows.length; i++) {
              var index = dg.datagrid("getRowIndex", state.disabledRows[i]);
              if (index >= 0) {
                opts.finder.getTr(target, index).droppable("enable");
              }
            }
            state.disabledRows = [];
            var index = dg.datagrid("getRowIndex", state.draggingRow);
            dg.datagrid("enableDnd", index);
            opts.onStopDrag.call(target, state.draggingRow);
          },
        })
        .droppable({
          accept: "tr.datagrid-row",
          onDragEnter: function (e, source) {
            if (
              opts.onDragEnter.call(target, getRow(this), getRow(source)) ==
              false
            ) {
              allowDrop(source, false);
              var tr = opts.finder.getTr(
                target,
                $(this).attr("datagrid-row-index")
              );
              tr.find("td").css("border", "");
              tr.droppable("disable");
              state.disabledRows.push(getRow(this));
            }
          },
          onDragOver: function (e, source) {
            var targetRow = getRow(this);
            if ($.inArray(targetRow, state.disabledRows) >= 0) {
              return;
            }
            var pageY = source.pageY;
            var top = $(this).offset().top;
            var bottom = top + $(this).outerHeight();

            allowDrop(source, true);
            var tr = opts.finder.getTr(
              target,
              $(this).attr("datagrid-row-index")
            );
            tr.children("td").css("border", "");
            if (pageY > top + (bottom - top) / 2) {
              tr.children("td").css("border-bottom", "1px solid red");
            } else {
              tr.children("td").css("border-top", "1px solid red");
            }

            if (
              opts.onDragOver.call(target, targetRow, getRow(source)) == false
            ) {
              allowDrop(source, false);
              tr.find("td").css("border", "");
              tr.droppable("disable");
              state.disabledRows.push(targetRow);
            }
          },
          onDragLeave: function (e, source) {
            allowDrop(source, false);
            var tr = opts.finder.getTr(
              target,
              $(this).attr("datagrid-row-index")
            );
            tr.children("td").css("border", "");
            opts.onDragLeave.call(target, getRow(this), getRow(source));
          },
          onDrop: function (e, source) {
            var sourceIndex = parseInt($(source).attr("datagrid-row-index"));
            var destIndex = parseInt($(this).attr("datagrid-row-index"));

            var tr = opts.finder.getTr(
              target,
              $(this).attr("datagrid-row-index")
            );
            var td = tr.children("td");
            var point = parseFloat(td.css("border-top-width"))
              ? "top"
              : "bottom";
            td.css("border", "");

            var rows = dg.datagrid("getRows");
            var dRow = rows[destIndex];
            var sRow = rows[sourceIndex];
            if (opts.onBeforeDrop.call(target, dRow, sRow, point) == false) {
              return;
            }
            insert();
            opts.onDrop.call(target, dRow, sRow, point);

            function insert() {
              var row = $(target).datagrid("getRows")[sourceIndex];
              var index = 0;
              if (point == "top") {
                index = destIndex;
              } else {
                index = destIndex + 1;
              }
              if (index < sourceIndex) {
                dg.datagrid("deleteRow", sourceIndex).datagrid("insertRow", {
                  index: index,
                  row: row,
                });
                dg.datagrid("enableDnd", index);
              } else {
                dg.datagrid("insertRow", {
                  index: index,
                  row: row,
                }).datagrid("deleteRow", sourceIndex);
                dg.datagrid("enableDnd", index - 1);
              }
            }
          },
        });

      function allowDrop(source, allowed) {
        var icon = $(source).draggable("proxy").find("span.tree-dnd-icon");
        icon
          .removeClass("tree-dnd-yes tree-dnd-no")
          .addClass(allowed ? "tree-dnd-yes" : "tree-dnd-no");
      }

      function getRow(tr) {
        return opts.finder.getRow(target, $(tr));
      }
    });
  },
});
var patNode,
  ctcRecordObj = {},
  wardDescObj = {},
  subRecordObj = {},
  updateADRsFlag = true,
  treeTimer,
  pageSize = 5,
  curPage = 1,
  backupIds = [],
  curModelType,
  fixRowNum;
var frm = dhcsys_getmenuform();
if (frm) {
  console.log(frm);
  patNode = {
    episodeID: frm.EpisodeID.value,
    patientID: frm.PatientID.value,
  };
  console.log(patNode);
  getELTableData();
}
var adrsItemId; //不良反应项id
var page = 1,
  tplSize = 20;
var saveFlag = true;
var subRecordTableFlag = false;
var columns = [];
if ('undefined'==typeof HISUIStyleCode) {
	var HISUIStyleCode="blue";
}
$("#subRecordTable").datagrid({
  singleSelect: true,
  showHeader: false,
  onClickRow: function (rowIndex, rowData) {
    $(this).datagrid("unselectRow", rowIndex);
  },
});
var unfoldFlag = true; //评估项树展开标识
$(function () {
  getallWardNew();
  $("#toggleFold").click(function (argument) {
    var root = $("#evaluateTree").tree("getRoot");
    var operator;
    if (unfoldFlag) {
      unfoldFlag = false;
      operator = "collapse";
      $("#toggleFold .l-btn-text").html($g("展开"));
    } else {
      unfoldFlag = true;
      operator = "expand";
      $("#toggleFold .l-btn-text").html($g("收起"));
    }
    if (root.children && root.children.length) {
      var $evaluateTree = $("#evaluateTree");
      root.children.map(function (e) {
        if (e.children) {
          var target = $evaluateTree.tree("find", e.id).target;
          $evaluateTree.tree(operator, target);
        }
      });
    }
  });
  $("#tplType,#type").combobox({
    valueField: "value",
    textField: "text",
    mode: "local",
    panelHeight: "auto",
    editable: false,
    onSelect: function (record) {
      console.log(record);
      switch (record.value) {
        case "1":
          $(".validLoc").hide();
          $(".invalidLoc").hide();
          $("#validLoc").combobox({ multiple: false }).combobox("clear");
          $("#invalidLoc").combobox("clear");
          break;
        case "2":
          $(".validLoc").show();
          $(".invalidLoc").hide();
          $("#validLoc").combobox({ multiple: false }).combobox("clear");
          $("#invalidLoc").combobox("clear");
          $("#validLoc").combobox("setValue", session["LOGON.CTLOCID"]);
          break;
        case "3":
          $(".validLoc").show();
          $(".invalidLoc").show();
          $("#validLoc").combobox({ multiple: true }).combobox("clear");
          $("#invalidLoc").combobox({ multiple: true }).combobox("clear");
          break;
        default:
          break;
      }
      updateModalPos("statisticsModal");
    },
    data: [
      { value: "1", text: $g("个人模板") },
      { value: "2", text: $g("科室模板") },
      { value: "3", text: $g("全院模板") },
    ],
  });
  if ("clinic" == From) {
    $("#rightContent").css("width", "100%").prev().hide();
  }
  if (EpisodeID !== "") {
    InitPatInfoBanner(EpisodeID);
    setTimeout(function () {
      console.log(5795);
      getELTableData();
    }, 500);
  }
  updateDomSize();
  $("#mvsLayout").layout("panel", "west").panel({
    onExpand: updateDomSize,
    onCollapse: updateDomSize,
  });
	if ('lite'==HISUIStyleCode) { //极简
		$('.eduExeStyle').append('.adrs .datagrid-btable-frozen .l-btn-icon:before{margin-left: -6px;}');
		$('.eduExeStyle').append('td[field="adrsDesc"] .l-btn-icon:before{margin-left: -6px;}');
		$('.eduExeStyle').append('body{background-color: #f5f5f5;}');
		$('.eduExeStyle').append('.adrs .datagrid-row td{border-right: 1px solid #cccccc;}');
	}
});

function getallWardNew() {
  // 获取病区
  $cm(
    {
      ClassName: "Nur.NIS.Service.Base.Loc",
      QueryName: "FindLocItem",
      HospID: session["LOGON.HOSPID"],
      LocType: "",
      LocDesc: "",
      CongfigName: "Nur_IP_CTCEvaluate",
      rows: 10000,
    },
    function (data) {
      wardList = data.rows;
      wardList.map(function (elem, index) {
        wardDescObj[elem.rowid] = elem.desc;
      });
      $HUI.combobox(".locs", {
        multiple: true,
        valueField: "rowid",
        textField: "desc",
        data: wardList,
        defaultFilter: 4,
      });
    }
  );
}
function addELRow() {
  if (IsShowPatList) {
    var node = $("#patientTree").tree("getSelected");
    patNode = node;
    if (!patNode)
      return $.messager.popover({ msg: $g("请先选择患者！"), type: "alert" });
  }
  ctcRecordObj = {};
  openCtcRecordModal($g("新增"));
  $("#ctcRecordForm").form("reset");
  $("#ctcRecordForm").form("disableValidation");
  $HUI.radio("input[value='0']").setValue(true);
}

function openCtcRecordModal(title) {
  updateModalPos("ctcRecordModal");
  $(".evaRecordPatBar").css(
    "height",
    $(".evaRecordPatBar .PatInfoItem").height() + 5 + "px"
  );
  $HUI.dialog("#ctcRecordModal").setTitle(title);
}
// 更新模态框位置
function updateModalPos(id) {
  var offsetLeft =
    (window.innerWidth -
      $("#" + id)
        .parent()
        .width()) /
    2;
  var offsetTop =
    (window.innerHeight -
      $("#" + id)
        .parent()
        .height()) /
    2;
  $("#" + id)
    .dialog({
      left: offsetLeft,
      top: offsetTop,
    })
    .dialog("open");
}

function editELRow(curInd, row) {
  console.log(curInd, row);
  if (!row) {
    row = $("#evaluateList").datagrid("getSelected");
    if (!row)
      return $.messager.popover({
        msg: $g("请先选择要编辑的行！"),
        type: "alert",
      });
  }
  if (1 == row.docFlag && 1 != docFlag)
    return $.messager.popover({
      msg: $g("医生创建或保存的数据无法修改！"),
      type: "alert",
    });
  openCtcRecordModal($g("编辑"));
  var data = getCTCRecordById(row.id);
  ctcRecordObj = data;
  $("#propertyName").val(data.propertyName);
  $HUI.radio("input[value='" + data.modelType + "']").setValue(true);
  $("#chemotherapyName").val(data.chemotherapyName);
  $("#radiotherapyLocation").val(data.radiotherapyLocation);
  $("#radiotherapyDose").val(data.radiotherapyDose);
  $("#otherPlan").val(data.otherPlan);
  $("#ctcRecordForm").form("validate");
  modelTypeChange({ target: { value: data.modelType } });
}

function getCTCRecordById(id) {
  var data = $cm(
    {
      ClassName: "Nur.NIS.Service.CTC.Record",
      MethodName: "GetCTCRecordById",
      id: id,
    },
    false
  );
  return data;
}
var modelType = [
  $g("单纯化疗"),
  $g("单纯放疗"),
  $g("放化综合治疗"),
  $g("其他"),
];
var healPlan = {
  chemotherapyName: $g("化疗方案："),
  radiotherapyLocation: $g("放疗部位："),
  radiotherapyDose: $g("放疗总剂量："),
  otherPlan: $g("其他："),
};

function selectELRow(index, row) {
  console.log(arguments);
  curPage = 1;
  getCTCSubRecord();
  var data = getCTCRecordById(row.id);
  console.log(data);
  curModelType = data.modelType;
  $(
    "table.healDetail tr:eq(0) td,table.healDetailADRs tr:eq(0) td:eq(0),table.healDetailCurve tr:eq(0) td:eq(0)"
  ).html('<span>'+$g("治疗模式：")+'</span>' + modelType[curModelType]);
  $(
    "table.healDetailADRs tr:eq(0) td:gt(0),table.healDetailCurve tr:eq(0) td:gt(0)"
  ).remove();
  var keys = Object.keys(healPlan),
    str = "";
  keys.map(function (k, i) {
    if (data[k]) {
      str += "<td><span>" + healPlan[k] +'</span>'+ data[k] + "</td>";
    }
  });
  $("table.healDetail tr:eq(1)").html(str);
  $("table.healDetailADRs tr:eq(0),table.healDetailCurve tr:eq(0)").append(str);
  $("table#evaluateForm tr td:gt(0)").hide();
  if (0 == curModelType) {
    $("table#evaluateForm tr td:eq(2)").show();
  } else if (1 == curModelType) {
    $("table#evaluateForm tr td:eq(1)").show();
  } else if (2 == curModelType) {
    $("table#evaluateForm tr td:gt(0):lt(2)").show();
  } else {
    $("table#evaluateForm tr td:eq(3)").show();
  }
  updateTableTitleWidth();
}
function updateTableTitleWidth() {
  var $td=$(".healDetailADRs tr:eq(0)>td")
  $td.map(function (i,t) {
    $('.eduExeStyle').append('.healDetailADRs tr>td:nth-of-type('+(i+1)+')>span{width:auto;}');
  })
  setTimeout(function() {
    $td.map(function (i,t) {
      var w1=$(t).find('span').width();
      var w2=$(".healDetailADRs tr:eq(1)>td:eq("+i+")>span").width();
      console.log(w1+","+w2);
      var width=Math.max(w1,w2);
      $('.eduExeStyle').append('.healDetailADRs tr>td:nth-of-type('+(i+1)+')>span{width: '+width+'px;}');
    })
  }, 200);
}
function deleteELRow() {
  var elObj = $("#evaluateList");
  var row = elObj.datagrid("getSelected");
  if (!row)
    return $.messager.popover({
      msg: $g("请先选择要删除的行！"),
      type: "alert",
    });
  if (1 == row.docFlag && 1 != docFlag)
    return $.messager.popover({
      msg: $g("医生创建或保存的数据无法删除！"),
      type: "alert",
    });
  $.messager.confirm($g("删除"), $g("确定要删除选中的数据？"), function (r) {
    if (r) {
      var curInd = elObj.datagrid("getRowIndex", row);
      console.log(curInd);
      $cm(
        {
          ClassName: "Nur.NIS.Service.CTC.Record",
          MethodName: "DeleteCTCRecord",
          dataType: "text",
          ID: row.id,
        },
        function (data) {
          console.log(data);
          if (0 == data) {
            $.messager.popover({ msg: $g("删除成功！"), type: "success" });
            elObj.datagrid("deleteRow", curInd);
            clearSubRecord();
          } else {
            $.messager.popover({ msg: data, type: "alert" });
          }
        }
      );
    }
  });
}

function getELTableData() {
  if (IsShowPatList) {
    var node = $("#patientTree").tree("getSelected");
    if (!node) return;
    patNode = node;
    // var frm = dhcsys_getmenuform();
    // if (frm) {
    //     frm.EpisodeID.value = node.episodeID;
    //     frm.PatientID.value = node.patientID;
    // }
  }
  // 获取数据引入表格数据
  $cm(
    {
      ClassName: "Nur.NIS.Service.CTC.Record",
      QueryName: "GetCTCRecord",
      rows: 999999999999999,
      patientID: patNode.patientID,
    },
    function (data) {
      $("#newBuild,#prevPage,#nextPage,#printBtn").linkbutton("disable");
      $("#evaluateList").datagrid("loadData", data);
      clearSubRecord();
      if (ctcRecordObj.id) {
        data.rows.map(function (e, i) {
          if (ctcRecordObj.id == e.id) {
            $("#evaluateList").datagrid("selectRow", i);
            selectELRow(i, e);
          }
        });
      }
    }
  );
}

function clearSubRecord() {
  $("#subRecordTable").datagrid({ data: { total: 0, rows: [] } });
  $("#myCanvas").remove();
  $(
    "table.healDetail tr:eq(0) td,table.healDetailADRs tr:eq(0) td:eq(0),table.healDetailCurve tr:eq(0) td:eq(0)"
  ).html('<span>'+$g("治疗模式：")+'</span>');
  $(
    "table.healDetailADRs tr:eq(0) td:gt(0),table.healDetailCurve tr:eq(0) td:gt(0)"
  ).remove();
  $("table.healDetail tr:eq(1)").html("");
  $("#newBuild,#prevPage,#nextPage,#printBtn").linkbutton("disable");
  updateTableTitleWidth();
}

function saveELRow() {
  if (IsShowPatList) {
    var node = $("#patientTree").tree("getSelected");
    patNode = node;
  }
  $("#ctcRecordForm").form("enableValidation");
  var propertyName = $("#propertyName").val();
  if (!propertyName) return;
  if (propertyName.length > 200)
    return $.messager.popover({
      msg: "评价属性长度不大于200！",
      type: "alert",
    });
  var modelType = $("input[name='modelType']:checked").val();
  if (undefined === modelType) return;
  var chemotherapyName = "",
    radiotherapyLocation = "",
    radiotherapyDose = "",
    otherPlan = "";
  switch (modelType) {
    case "0":
      chemotherapyName = $("#chemotherapyName").val();
      if (!chemotherapyName) return;
      if (chemotherapyName.length > 500)
        return $.messager.popover({
          msg: "化疗方案长度不大于500！",
          type: "alert",
        });
      break;
    case "1":
      radiotherapyLocation = $("#radiotherapyLocation").val();
      radiotherapyDose = $("#radiotherapyDose").val();
      if (!radiotherapyLocation || !radiotherapyDose) return;
      if (radiotherapyLocation.length > 500)
        return $.messager.popover({
          msg: "放疗部位长度不大于500！",
          type: "alert",
        });
      if (radiotherapyDose.length > 500)
        return $.messager.popover({
          msg: "放疗总剂量长度不大于500！",
          type: "alert",
        });
      break;
    case "2":
      chemotherapyName = $("#chemotherapyName").val();
      radiotherapyLocation = $("#radiotherapyLocation").val();
      radiotherapyDose = $("#radiotherapyDose").val();
      if (!chemotherapyName || !radiotherapyLocation || !radiotherapyDose)
        return;
      if (chemotherapyName.length > 500)
        return $.messager.popover({
          msg: "化疗方案长度不大于500！",
          type: "alert",
        });
      if (radiotherapyLocation.length > 500)
        return $.messager.popover({
          msg: "放疗部位长度不大于500！",
          type: "alert",
        });
      if (radiotherapyDose.length > 500)
        return $.messager.popover({
          msg: "放疗总剂量长度不大于500！",
          type: "alert",
        });
      break;
    default:
      otherPlan = $("#otherPlan").val();
      if (!otherPlan) return;
      if (otherPlan.length > 500)
        return $.messager.popover({
          msg: "其他长度不大于500！",
          type: "alert",
        });
      break;
  }
  // var repeatCheck={},ruleLocs=$("#ruleLocs").combobox('getValues'),ruleInvalidLocs=$("#ruleInvalidLocs").combobox('getValues');//重复校验
  // for (var i = 0; i < ruleLocs.length; i++) {
  // 	repeatCheck[ruleLocs[i]]=1;
  // }
  // for (var i = 0; i < ruleInvalidLocs.length; i++) {
  // 	if (repeatCheck[ruleInvalidLocs[i]]) {
  // 		$.messager.popover({msg: $g('适用范围和不适用范围不能有相同选项！'),type:'alert'});
  // 		return false;
  // 	} else {
  // 		repeatCheck[ruleInvalidLocs[i]]=1;
  // 	}
  // }
  var obj = {
    id: ctcRecordObj.id || "",
    patientID: patNode.patientID,
    episodeID: patNode.episodeID,
    propertyName: propertyName,
    modelType: modelType,
    chemotherapyName: chemotherapyName,
    radiotherapyLocation: radiotherapyLocation,
    radiotherapyDose: radiotherapyDose,
    otherPlan: otherPlan,
  };
  $cm(
    {
      ClassName: "Nur.NIS.Service.CTC.Record",
      MethodName: "AddOrUpdateCTCRecord",
      dataType: "text",
      data: JSON.stringify(obj),
    },
    function (data) {
      console.log(data);
      if (0 == data) {
        $.messager.popover({ msg: $g("数据保存成功！"), type: "success" });
        $HUI.dialog("#ctcRecordModal").close();
        getELTableData();
      } else {
        $.messager.popover({ msg: JSON.stringify(data), type: "alert" });
      }
    }
  );
}

function modelTypeChange(e) {
  $("#ctcRecordForm table tr:gt(1)").hide();
  $(
    "#chemotherapyName,#radiotherapyLocation,#radiotherapyDose,#otherPlan"
  ).validatebox("options").required = false;
  $("#radiotherapyDose").validatebox("options").required = false;
  if (e) {
    var selStr = "",
      radioId = "";
    switch (e.target.value) {
      case "0":
        selStr = "#ctcRecordForm table tr:eq(2)";
        radioId = "#chemotherapyName";
        break;
      case "1":
        selStr = "#ctcRecordForm table tr:gt(2):lt(2)";
        radioId = "#radiotherapyLocation";
        $("#radiotherapyDose").validatebox("options").required = true;
        break;
      case "2":
        selStr = "#ctcRecordForm table tr:gt(1):lt(3)";
        radioId = "#chemotherapyName";
        $("#radiotherapyLocation").validatebox("options").required = true;
        $("#radiotherapyDose").validatebox("options").required = true;
        break;
      default:
        selStr = "#ctcRecordForm table tr:eq(5)";
        radioId = "#otherPlan";
        break;
    }
    console.log(selStr);
    console.log(radioId);
    $(selStr).show();
    $(radioId).validatebox("options").required = true;
  }
  $(".window-shadow").css(
    "height",
    $("#ctcRecordModal").parent().height() + "px"
  );
  var width=0,$tr=$("#ctcRecordForm>table>tbody>tr");
  $tr.map(function (i,t) {
    var display=$(t).css('display');
    console.log(display);
    if ('none'!=display) {
      var w=$(t).find('td>span').width();
      if (w>width) width=w;
    }
  })
  $("#ctcRecordForm>table>colgroup>col:eq(0)").attr('style','width:'+(width+10)+'px');
  updateModalPos("ctcRecordModal");
}
function clearSearchCond() {
  $("#tplType").combobox("clear");
  $("#templateDesc").val("");
  getCTCEvalTemplateAndDetail();
}

function getCTCEvalTemplateAndDetail() {
  saveFlag = false;
  timeouter = setTimeout(function () {
    saveFlag = true;
  }, 3000);
  $cm(
    {
      ClassName: "Nur.NIS.Service.CTC.Record",
      QueryName: "GetCTCEvalTemplateAndDetail",
      page: page,
      rows: tplSize,
      filterType: $("#tplType").combobox("getValue"),
      keyword: $("#templateDesc").val(),
    },
    function (res) {
      console.log(res);
      if (res.total > 0 && !res.rows.length && page > 1) {
        page = 1;
        getCTCEvalTemplateAndDetail();
        return;
      }
      $("#evalTemplate")
        .datagrid("loadData", res)
        .datagrid("getPager")
        .pagination({
          onSelectPage: function (p, size) {
            page = p;
            tplSize = size;
            if (saveFlag) {
              console.log(p, size);
              getCTCEvalTemplateAndDetail();
            } else {
              saveFlag = true;
            }
          },
          onRefresh: function (p, size) {
            console.log(p, size);
            page = p;
            tplSize = size;
            getCTCEvalTemplateAndDetail();
          },
          onChangePageSize: function (size) {
            console.log(size);
            page = 1;
            tplSize = size;
            getCTCEvalTemplateAndDetail();
          },
        })
        .pagination("select", page);
      setTimeout(function () {
        updateModalPos("citeTplModal");
      }, 200);
    }
  );
}

function citeTemplate() {
  //引用模板
  updateModalPos("citeTplModal");
  getCTCEvalTemplateAndDetail();
}

function selectEvalTpl(ind, row) {
  //选择模板
  console.log(arguments);
  var row = $("#evalTemplate").datagrid("getSelected");
  console.log(row);
  if (!row)
    return $.messager.popover({ msg: $g("请先选择评估模板！"), type: "alert" });
  $HUI.dialog("#citeTplModal").close();
  var adrsIds = row.adrsIds.split(",");
  var $evaluateTree = $("#evaluateTree");
  // 先取消原来的选择
  var nodes = $evaluateTree.tree("getChecked");
  nodes.map(function (node) {
    $evaluateTree.tree("uncheck", node.target);
  });
  // 再重新选择
  for (var i = 0; i < adrsIds.length; i++) {
    var node = $evaluateTree.tree("find", adrsIds[i]);
    if (node) {
      $evaluateTree.tree("check", node.target);
    }
  }
}

function openCtcAEModal(title) {
  console.log("'''''''''window.innerWidth'''''''''");
  console.log(window.innerWidth);
  console.log("'''''''''window.innerHeight'''''''''");
  console.log(window.innerHeight);
  $("#ctcAEModal").dialog("open");
  $("#evaluateInput").searchbox('resize',$("#evaluateInput").parent().width()-$("#toggleFold").width()-$("#toggleFold+a").width()-30);
  var innerWidth = window.innerWidth - 50;
  var innerHeight = window.innerHeight - 50;
  $("#ctcAEModal")
    .dialog({
      width: innerWidth,
      height: innerHeight,
			onClose: function () {
				// 把节点设置为未勾选
				var nodes = $("#evaluateTree").tree("getChecked");
				var $evaluateTree = $("#evaluateTree");
				for (var i = 0; i < nodes.length; i++) {
					$evaluateTree.tree("uncheck", nodes[i].target);
				}
				$("div.adrsContent").remove();
			},
    })
    .dialog("open");
  if ('lite'==HISUIStyleCode) { //极简
    $("#evaluateTree").parent().css("height", innerHeight - 170 + "px");
  }else{
    $("#evaluateTree").parent().css("height", innerHeight - 172 + "px");
  }
  $HUI.dialog("#ctcAEModal").setTitle(title || $g("新增"));
  if (!title) {
    $("#assessInsertDate").datebox("setValue", formatDate(new Date()));
    $("#other").val("");
    $("#radiotherapyNum,#chemotherapyInterval").numberbox("clear");
    subRecordObj = {};
    $("#saveCtcAE,#cancelCtcAE").show();
    $("#auditCtcAE,#recallCtcAE").hide();
    $("table.healDetailADRs tr:eq(1)").html(
      "<td><span>" +
        $g("评估/更新人：") +'</span>'+
        "</td><td><span>" +
        $g("审核人：") +'</span>'+
        "</td><td><span>" +
        $g("审核时间：") +'</span>'+
        "</td>"
    );
  }
  var ardsTreeHeight = $("#ardsTree").height();
  $("#ADRsTable").datagrid({
    title:"不良反应列表",
    style:"padding-top: 2px;",
    autoSizeColumn:false,fitColumns:true,pagination:false,headerCls:'panel-header-gray',iconCls:'icon-paper',
    height: ardsTreeHeight - $(".healDetailADRs").height() - 45,
    toolbar: [{
      iconCls: 'icon-save',
      text:'保存为模板',
      handler: savePersonalTpl
    }],
    columns:[[
      {field:'ck',checkbox:true},
      {field:'field',title:$g('操作'),formatter:function(val,row,ind){
        var ids=row.id.split('||');
        ids[0]=ids[0]||0;
        return '<span class="tbl-main-cell-op" iconCls="icon-cancel" title="'+$g('删除')+'" onclick="deleteADRsRow('+ids[0]+','+ids[1]+')">&nbsp;</span>';
      },width:50,align:'center'},
      {field:'adrsDesc',title:$g('不良反应'),width:200},
    ]],
    onLoadSuccess:function(){
      $('.tbl-main-cell-op').linkbutton({plain:true}).tooltip({position:'bottom'})
    },
  });
  $("#adrsContents").css(
    "height",
    ardsTreeHeight -
      $(".healDetailADRs").height() -
      118 -
      $("#evaluateForm").height() +
      "px"
  );
  $("#evaluateInput").searchbox('resize',$("#evaluateInput").parent().width()-$("#toggleFold").width()-$("#toggleFold+a").width()-30);
  updateTableTitleWidth();
  if ($g("编辑") == title) return;
  // 获取最近的不良反应更新记录
  $cm(
    {
      ClassName: "Nur.NIS.Service.CTC.Record",
      MethodName: "GetLatestCTCSubRecord",
      dataType: "text",
      rowId: $("#evaluateList").datagrid("getSelected").id,
    },
    function (data) {
      console.log(data);
      if (!data) return;
      data = JSON.parse(data);
      var rows = data.rows;
      var id = data.columns[0].field;
      if (0 == curModelType) {
        $("#chemotherapyInterval").numberbox(
          "setValue",
          parseInt(rows[1][id]) || ""
        );
      } else if (1 == curModelType) {
        $("#radiotherapyNum").numberbox(
          "setValue",
          parseInt(rows[1][id]) || ""
        );
      } else if (2 == curModelType) {
        $("#radiotherapyNum").numberbox(
          "setValue",
          parseInt(rows[1][id]) || ""
        );
        $("#chemotherapyInterval").numberbox(
          "setValue",
          parseInt(rows[2][id]) || ""
        );
      } else {
        $("#other").val(rows[1][id] || "");
      }
      $("#radiotherapyNum,#chemotherapyInterval").validatebox("validate");
      var $evaluateTree = $("#evaluateTree");
      for (var i = fixRowNum; i < rows.length; i++) {
        if (rows[i][id]) {
          var node = $evaluateTree.tree("find", rows[i].ardsId);
          if (node) {
            $evaluateTree.tree("check", node.target);
          }
        }
      }
      for (var i = fixRowNum; i < rows.length; i++) {
        if (rows[i][id]) {
          (function () {
            var j = i;
            var timer = setInterval(function () {
              if (
                $(
                  "input[name='" +
                    rows[j].ardsId +
                    "'][label^=" +
                    rows[j][id] +
                    "]"
                ).length
              ) {
                clearInterval(timer);
                $HUI
                  .radio(
                    "input[name='" +
                      rows[j].ardsId +
                      "'][label^=" +
                      rows[j][id] +
                      "]"
                  )
                  .setValue(true);
              }
            }, 50);
          })();
        }
      }
    }
  );
}

function showSavedRecordOfCtcAEModal(id, flag, status) {
  openCtcAEModal($g("编辑"));
  subRecordObj = { id: id };
  var rows = $("#subRecordTable").datagrid("getRows");
  $("#assessInsertDate").datebox("setValue", rows[0][id]);
  if (0 == curModelType) {
    $("#chemotherapyInterval").numberbox("setValue", parseInt(rows[1][id]));
  } else if (1 == curModelType) {
    $("#radiotherapyNum").numberbox("setValue", parseInt(rows[1][id]));
  } else if (2 == curModelType) {
    $("#radiotherapyNum").numberbox("setValue", parseInt(rows[1][id]));
    $("#chemotherapyInterval").numberbox("setValue", parseInt(rows[2][id]));
  } else {
    $("#other").val(rows[1][id]);
  }
  $("#radiotherapyNum,#chemotherapyInterval").validatebox("validate");
  var $evaluateTree = $("#evaluateTree");
  for (var i = fixRowNum; i < rows.length; i++) {
    if (rows[i][id]) {
      var node = $evaluateTree.tree("find", rows[i].ardsId);
      if (node) {
        $evaluateTree.tree("check", node.target);
      }
    }
  }
  for (var i = fixRowNum; i < rows.length; i++) {
    if (rows[i][id]) {
      (function () {
        var j = i;
        var timer = setInterval(function () {
          if (
            $(
              "input[name='" + rows[j].ardsId + "'][label^=" + rows[j][id] + "]"
            ).length
          ) {
            clearInterval(timer);
            $HUI
              .radio(
                "input[name='" +
                  rows[j].ardsId +
                  "'][label^=" +
                  rows[j][id] +
                  "]"
              )
              .setValue(true);
          }
        }, 50);
      })();
    }
  }
  $("#cancelCtcAE .l-btn-text").html($g("取消"));
  if ("check" == flag) {
    if (-1 == status) {
      //护士查看状态
      $("#cancelCtcAE").show().find(".l-btn-text").html($g("关闭"));
      $("#auditCtcAE,#saveCtcAE,#recallCtcAE").hide();
    } else if (1 == status) {
      //医生查看已审核状态
      $("#recallCtcAE,#cancelCtcAE").show();
      $("#saveCtcAE,#auditCtcAE").hide();
    } else {
      $("#auditCtcAE,#cancelCtcAE").show();
      $("#saveCtcAE,#recallCtcAE").hide();
    }
  }
  if ("edit" == flag) {
    $("#saveCtcAE,#cancelCtcAE").show();
    $("#auditCtcAE,#recallCtcAE").hide();
  }
  $("table.healDetailADRs tr:eq(1)").html(
    "<td><span>" +
      $g("评估/更新人：") +"</span>"+
      rows[fixRowNum - 2][id] +
      "</td><td><span>" +
      $g("审核人：") +"</span>"+
      (rows[fixRowNum - 1][id] || "") +
      "</td><td><span>" +
      $g("审核时间：") +"</span>"+
      (rows[fixRowNum - 1][id + "Time"] || "") +
      "</td>"
  );
  updateTableTitleWidth();
}
// 过滤评价系统
function filterEvaluate() {
  var searchText = $("#evaluateInput").searchbox("getValue");
  //获取根结点
  var roots = $("#evaluateTree").tree("getRoots");
  filterTreeNodes(roots);

  function filterTreeNodes(nodes) {
    for (var i = 0; i < nodes.length; i++) {
      if (!nodes[i].target) {
        nodes[i].target = $("#evaluateTree").tree("find", nodes[i].id).target;
      }
      if (nodes[i].text.includes(searchText)) {
        $(nodes[i].target)
          .parent()
          .show()
          .addClass("showNode")
          .prevAll(".showNode")
          .removeClass("showNode");
        if (nodes[i].children) {
          showChildNodes(nodes[i].children);
        }
      } else {
        if (checkChildHas(nodes[i])) {
          $(nodes[i].target)
            .parent()
            .show()
            .addClass("showNode")
            .prevAll(".showNode")
            .removeClass("showNode");
          filterTreeNodes(nodes[i].children);
        } else {
          $(nodes[i].target).parent().hide().removeClass("showNode");
        }
      }
    }
  }

  function checkChildHas(node) {
    var children = node.children,
      flag = false;
    if (children) {
      for (var i = 0; i < children.length; i++) {
        if (children[i].text.includes(searchText)) {
          return true;
        } else {
          flag = checkChildHas(children[i]);
          if (flag) {
            return true;
          }
        }
      }
    }
    return false;
  }

  function showChildNodes(nodes) {
    for (var i = 0; i < nodes.length; i++) {
      if (!nodes[i].target) {
        nodes[i].target = $("#evaluateTree").tree("find", nodes[i].id).target;
      }
      $(nodes[i].target)
        .parent()
        .show()
        .addClass("showNode")
        .prevAll(".showNode")
        .removeClass("showNode");
      if (nodes[i].children) {
        showChildNodes(nodes[i].children);
      }
    }
  }
}

function clearTreeNodeSearch() {
  //显示所有结点
  var root = $("#evaluateTree").tree("getRoot");
  var nodes = $("#evaluateTree").tree("getChildren", root.target);
  for (var i = 0; i < nodes.length; i++) {
    $(nodes[i].target).parents("li:eq(0)").css("display", "");
  }
}
// 获取评价树形结构数据
function getEvaluateTreeData() {
  $cm(
    {
      ClassName: "Nur.NIS.Service.CTC.Record",
      MethodName: "GetEvaluateTreeData",
    },
    function (data) {
      console.log(data);
      $("#evaluateTree").tree({
        lines: true,
        // checkbox:true,
        checkbox: checkboxCondition,
        // onlyLeafCheck:true,
        onlyLeafCheck: checkboxCondition,
        data: [
          {
            id: 0,
            text: $g("评价标准"),
            state: "open",
            children: data,
          },
        ],
        onCheck: function (node) {
          // 避免连续多次作用
          clearTimeout(treeTimer);
          treeTimer = setTimeout(function () {
            updateTreeNode(node, "check");
          }, 50);
        },
        onClick: function (node) {
          console.log(node);
          updateTreeNode(node, "click");
        },
      });
    }
  );
}
// 更新树数据
function checkboxCondition(node, flag) {
  console.log(arguments);
  return true;
}
// 更新树数据
function updateTreeNode(node, flag) {
  if (node.children) {
    $("#evaluateTree").tree("toggle", node.target); //简单单吉展开关闭
  } else {
    if ("click" == flag) {
      if (node.checked) {
        $("#evaluateTree").tree("uncheck", node.target);
      } else {
        $("#evaluateTree").tree("check", node.target);
      }
      return;
    }
    if (!updateADRsFlag) return;
    var nodes = $("#evaluateTree").tree("getChecked");
    var ids = [],
      rows = [];
    for (var i = 0; i < nodes.length; i++) {
      ids.push(nodes[i].id);
      var $div = $("div.adrsContent:eq(" + i + ")");
      if ($div.length) {
        $div.find("h3").html(nodes[i].text);
      } else {
        $("#adrsContents").append(
          "<div class='adrsContent'><div><h3>" +
            nodes[i].text +
            "</h3></div><div><table><tr><td>" +
            $g("定义：") +
            "</td><td></td></tr><tr><td>" +
            $g("引申注释：") +
            "</td><td></td></tr></table></div></div>"
        );
      }
      rows.push({
        id: nodes[i].id,
        adrsDesc: nodes[i].text,
      });
    }
    $("#ADRsTable").datagrid({
      data: { total: rows.length, rows: rows } 
    }); //简单单吉展开关闭
    backupIds = [];
    var rows = $("#ADRsTable").datagrid("getRows");
    rows.map(function (e) {
      var $inputs = $("input[name='" + e.id + "']");
      if ($inputs.length) {
        var $checked = $inputs.filter(":checked");
        if ($checked.length) {
          backupIds.push($checked.val());
        }
      }
    });
    if (0 == i) {
      $("div.adrsContent").remove();
    } else {
      $("div.adrsContent:gt(" + (i - 1) + ")").remove();
    }
    getBatchOfADRsContentAndGrades(ids);
  }
}
getEvaluateTreeData();
// 批量获取放化疗（评价系统的）不良反应内容和分级
function getBatchOfADRsContentAndGrades(ids) {
  for (var i = 0; i < ids.length; i++) {
    if (!ids[i].includes("||")) {
      ids.splice(i, 1);
      i--;
    }
  }
  $cm(
    {
      ClassName: "Nur.NIS.Service.CTC.Record",
      MethodName: "GetBatchOfADRsContentAndGrades",
      ids: JSON.stringify(ids),
    },
    function (data) {
      console.log(data);
      data.map(function (e, i) {
        var $div = $("div.adrsContent:eq(" + i + ")");
        var $table = $div.find("table");
        $table.find("tr:eq(0)>td:eq(1)").html($g(e.definition) || "");
        $table.find("tr:eq(1)>td:eq(1)").html(e.extendedNotes || "");
        var $gradeDiv = $div.children("div:eq(0)");
        $gradeDiv.children("p").remove();
        e.rows.map(function (e1, i1) {
          $gradeDiv.append(
            '<p><input class="hisui-radio" type="radio" label="' +
              (e1.gradeNum + "级：" + e1.gradeDesc) +
              '" name="' +
              ids[i] +
              '" value="' +
              e1.id +
              '" data-options="required:true"></p>'
          );
        });
      });
      $HUI.radio(".adrsContent input.hisui-radio", {});
      $(".adrsContent>div>p").map(function (i, e) {
        var label = $(e).find("label");
        var height = label.height();
        label.css("height", "21px");
        $(e).css("margin-bottom", height - 21 + "px");
      });
      backupIds.map(function (e) {
        $HUI.radio("input[value='" + e + "']").setValue(true);
      });
    }
  );
}
// 保存到个人模板
function savePersonalTpl() {
  var rows = $("#ADRsTable").datagrid("getChecked");
  console.log(rows);
  if (!rows.length)
    return $.messager.popover({ msg: $g("请先选择不良反应！"), type: "alert" });
  updateModalPos("statisticsModal");
  var data = [];
  rows.map(function (r) {
    var obj = {
      adrsDesc: r.adrsDesc,
      id: r.id,
    };
    var node = $("#evaluateTree").tree("find", r.id);
    obj.adrsCode = node.code;
    var pNode = $("#evaluateTree").tree("getParent", node.target);
    obj.sysDesc = pNode.text;
    data.push(obj);
  });
  $("#personalADRsTable").datagrid({ data: data, total: data.length });
  $("#type").combobox("setValue", 1);
  $("#code,#tplDesc").val("");
  $(".validLoc,.invalidLoc").hide();
  $("#validLoc").combobox({ multiple: false }).combobox("clear");
  $("#invalidLoc").combobox("clear");
  $("#ssForm").form("disableValidation");
  setTimeout(function () {
    updateModalPos("statisticsModal");
  }, 200);
}

function saveEvalTplAndADRs() {
  $("#ssForm").form("enableValidation");
  if ($("#ssForm").form("validate")) {
    var type = $("#type").combobox("getValue");
    var code = $("#code").val();
    var tplDesc = $("#tplDesc").val();
    if (3 == type) {
      var validLoc = $("#validLoc").combobox("getValues");
      var invalidLoc = $("#invalidLoc").combobox("getValues");
      var obj = {};
      for (var i = validLoc.length - 1; i >= 0; i--) {
        obj[validLoc[i]] = 1;
      }
      for (var i = invalidLoc.length - 1; i >= 0; i--) {
        if (obj[invalidLoc[i]])
          return $.messager.popover({
            msg: $g("使用科室和禁用科室中不能有相同选项！"),
            type: "alert",
          });
      }
      validLoc = JSON.stringify(validLoc);
      invalidLoc = JSON.stringify(invalidLoc);
    } else {
      var validLoc = $("#validLoc").combobox("getValue");
      var invalidLoc = $("#invalidLoc").combobox("getValue");
    }
    if (2 == type && !validLoc) {
      return $.messager.popover({ msg: $g("请选择科室！"), type: "alert" });
    }
    var data = {
      type: type,
      code: code,
      tplDesc: tplDesc,
      validLoc: validLoc,
      invalidLoc: invalidLoc,
    };
    if (1 == type) {
      data.person = session["LOGON.USERID"];
    }
    var rows = $("#personalADRsTable").datagrid("getRows");
    var adrsDR = [];
    rows.map(function (r) {
      adrsDR.push(r.id);
    });
    data.adrsDR = JSON.stringify(adrsDR);
    console.log(data);
    $cm(
      {
        ClassName: "Nur.NIS.Service.CTC.Record",
        MethodName: "SaveEvalTplAndADRs",
        dataType: "text",
        data: JSON.stringify(data),
      },
      function (res) {
        if (res == 0) {
          $.messager.popover({ msg: $g("保存成功！"), type: "success" });
          $HUI.dialog("#statisticsModal").close();
        } else {
          $.messager.popover({ msg: res, type: "alert" });
        }
      }
    );
  }
}
// 删除选中的不良反应
function deleteADRsRow(pId, subId) {
  updateADRsFlag = false;
  var rowId = pId + "||" + subId;
  // 删table
  setTimeout(function () {
    var rows=$('#ADRsTable').datagrid('getData').rows;
    for (var i = 0; i < rows.length; i++) {
      if (rowId == rows[i].id) {
        console.log(i);
        rows.splice(i,1);
        $('#ADRsTable').datagrid('uncheckAll');
        $('.tooltip.tooltip-bottom').hide();
        $('#ADRsTable').datagrid('loadData',{total:rows.length,rows:rows});
        // 删分级
        $(".adrsContent:eq(" + i + ")").remove();
        break;
      }
    }
    updateADRsFlag = true;
  }, 200);
  // // 删分级
  // 取消数节点选中
  var node = $("#evaluateTree").tree("find", rowId);
  $("#evaluateTree").tree("uncheck", node.target);
}

function saveCTCSubRecord(auditFlag) {
  var assessInsertDate = $("#assessInsertDate").datebox("getValue");
  if (!assessInsertDate)
    return $.messager.popover({ msg: $g("请选择评估日期！"), type: "alert" });
  var radiotherapyNum = $("#radiotherapyNum").numberbox("getValue");
  var chemotherapyInterval = $("#chemotherapyInterval").numberbox("getValue");
  console.log(radiotherapyNum);
  console.log(chemotherapyInterval);
  $("#radiotherapyNum,#chemotherapyInterval").validatebox("validate");
  if (0 == curModelType) {
    if (0 == chemotherapyInterval) return;
  } else if (1 == curModelType) {
    if (0 == radiotherapyNum) return;
  } else if (2 == curModelType) {
    if (0 == radiotherapyNum) return;
    if (0 == chemotherapyInterval) return;
  }
  var other = $("#other").val();
  var gradeIds = [],
    flag = true;
  var rows = $("#ADRsTable").datagrid("getRows"),
    adrsGrade = {};
  rows.map(function (e) {
    var $inputs = $("input[name='" + e.id + "']");
    if ($inputs.length) {
      var $checked = $inputs.filter(":checked");
      if ($checked.length) {
        gradeIds.push($checked.val());
        adrsGrade[e.id] = $checked.attr("label");
      } else {
        flag = false;
        return $.messager.popover({
          msg: $g("请选择评估内容分级！"),
          type: "alert",
        });
      }
    }
  });
  if (!flag) return;
  if (!gradeIds.length)
    return $.messager.popover({
      msg: $g("请先添加分级评估项！"),
      type: "alert",
    });
  var obj = {
    id: subRecordObj.id || "",
    episodeID: patNode.episodeID,
    assessInsertDate: assessInsertDate,
    radiotherapyNum: radiotherapyNum,
    chemotherapyInterval: chemotherapyInterval,
    other: other,
    gradeIds: gradeIds.join("@"),
    pId: $("#evaluateList").datagrid("getSelected").id,
  };
  if (1 == auditFlag) {
    obj.audit = 1; //审核
    // 审核时判断是否修改，若修改，保存并更新插入人；否则，只更新审核人。
    var id = subRecordObj.id;
    var rows = $("#subRecordTable").datagrid("getRows"),
      sameFlag = true;
    for (var i = 5; i < rows.length; i++) {
      if (rows[i][id]) {
        if (
          adrsGrade[rows[i].ardsId] &&
          0 == adrsGrade[rows[i].ardsId].indexOf(rows[i][id])
        ) {
          delete adrsGrade[rows[i].ardsId];
        } else {
          sameFlag = false;
        }
      }
    }
    if (
      assessInsertDate == rows[0][id] &&
      radiotherapyNum == rows[1][id] &&
      chemotherapyInterval == rows[2][id] &&
      0 == Object.keys(adrsGrade).length &&
      sameFlag
    ) {
      auditCTCSubRecord();
      return;
    }
  }
  $cm(
    {
      ClassName: "Nur.NIS.Service.CTC.Record",
      MethodName: "AddOrUpdateCTCSubRecord",
      dataType: "text",
      data: JSON.stringify(obj),
    },
    function (data) {
      console.log(data);
      if (0 == data) {
        var msg = $g("数据保存成功！");
        if (1 == auditFlag) msg = $g("审核成功！");
        $.messager.popover({ msg: msg, type: "success" });
        $HUI.dialog("#ctcAEModal").close();
        getCTCSubRecord();
      } else {
        $.messager.popover({ msg: data, type: "alert" });
      }
    }
  );
}

function auditCTCSubRecord() {
  $cm(
    {
      ClassName: "Nur.NIS.Service.CTC.Record",
      MethodName: "AuditCTCSubRecord",
      ID: subRecordObj.id,
    },
    function (data) {
      console.log(data);
      if (0 == data) {
        $.messager.popover({ msg: $g("审核成功！"), type: "success" });
        $HUI.dialog("#ctcAEModal").close();
        getCTCSubRecord();
      } else {
        $.messager.popover({ msg: data, type: "alert" });
      }
    }
  );
}

function recallCTCSubRecord() {
  $cm(
    {
      ClassName: "Nur.NIS.Service.CTC.Record",
      MethodName: "RecallCTCSubRecord",
      ID: subRecordObj.id,
    },
    function (data) {
      console.log(data);
      if (0 == data) {
        $.messager.popover({ msg: $g("撤销审核成功！"), type: "success" });
        $HUI.dialog("#ctcAEModal").close();
        getCTCSubRecord();
      } else {
        $.messager.popover({ msg: data, type: "alert" });
      }
    }
  );
}

function beforeDragADRsRow() {
  // var index=$('#ADRsTable').datagrid('getEditingRowIndexs')[0];
  // if (undefined!==index)  return false;
}
// 拖动数据引入表格
function dropADRsRow(target, source, point) {
  console.log(arguments);
  // var newSort=target.sortNo,oldSort=source.sortNo;
  // if (newSort==oldSort) return;
  // if ((newSort>oldSort)&&('top'==point)) {
  // 	newSort--;
  // }
  // if ((newSort<oldSort)&&('bottom'==point)) {
  // 	newSort++;
  // }
  // if (newSort==oldSort) return;
  //  $cm({
  //      ClassName: 'Nur.NIS.Service.CTC.Config',
  //      MethodName: 'UpdateCTCEvalTplADRsSort',
  //      newSort: newSort,
  //      ID:source.id
  //  }, function (data) {
  //  	console.log(data);
  //  	if (0==data) {
  // 		getTemplateADRs();
  //  	} else {
  //  		$.messager.popover({msg: JSON.stringify(data),type:'alert'});
  //  	}
  //  });
}

function prevPage() {
  curPage--;
  getCTCSubRecord();
}

function nextPage() {
  curPage++;
  getCTCSubRecord();
}
// 获取CTC评价方案明细记录
function getCTCSubRecord() {
  $cm(
    {
      ClassName: "Nur.NIS.Service.CTC.Record",
      MethodName: "GetCTCSubRecord",
      rowId: $("#evaluateList").datagrid("getSelected").id,
      curPage: curPage,
      pageSize: pageSize,
    },
    function (data) {
      console.log(data);
      fixRowNum = 4;
      if (0 == curModelType) {
        data.rows.splice(3, 1);
        data.rows.splice(1, 1);
      } else if (1 == curModelType) {
        data.rows.splice(2, 2);
      } else if (2 == curModelType) {
        data.rows.splice(3, 1);
        fixRowNum = 5;
      } else {
        data.rows.splice(1, 2);
      }
      $("#newBuild,#printBtn").linkbutton("enable");
      if (1 == data.finished) {
        // 无下一页
        $("#nextPage").linkbutton("disable");
      } else {
        $("#nextPage").linkbutton("enable");
      }
      if (1 == curPage) {
        $("#prevPage").linkbutton("disable");
      } else {
        $("#prevPage").linkbutton("enable");
      }
      var columnWidth = 147;
      if (docFlag) {
        columnWidth = 167;
      }
      if (data.columns.length) {
        data.columns.map(function (e, i) {
          data.columns[i].width = columnWidth;
          data.columns[i].formatter = function (value, row, index) {
            if (0 == index) {
              var id = data.date2Id[value];
              var str = "";
              if (docFlag) {
                // 查看check
                // str += '<a href="javascript:void(0);" name="checkSubRecord" data-id="'+e.field+'" data-status="'+(data.status&&data.status[id]||'')+'" class="easyui-linkbutton" ></a>'
                str +=
                  '<a href="javascript:void(0);" name="editSubRecord" data-id="' +
                  e.field +
                  '" data-status="' +
                  ((data.status && data.status[id]) || "") +
                  '" class="easyui-linkbutton" ></a>';
                if (data.status && 1 == data.status[id]) {
                  // 撤回recall
                  str +=
                    '<a href="javascript:void(0);" name="recallSubRecord" data-id="' +
                    e.field +
                    '" class="easyui-linkbutton" ></a>';
                } else {
                  // 审核audit
                  str +=
                    '<a href="javascript:void(0);" name="auditSubRecord" data-id="' +
                    e.field +
                    '" class="easyui-linkbutton" ></a>';
                }
                // 删除
                str +=
                  '<a href="javascript:void(0);" name="delSubRecord" data-id="' +
                  e.field +
                  '" class="easyui-linkbutton" ></a>';
              } else {
                if (data.doc[id]) {
                  // 查看check
                  str +=
                    '<a href="javascript:void(0);" name="checkSubRecord" data-id="' +
                    e.field +
                    '" data-status="-1" class="easyui-linkbutton" ></a>';
                } else {
                  // 编辑
                  str +=
                    '<a href="javascript:void(0);" name="editSubRecord" data-id="' +
                    e.field +
                    '" class="easyui-linkbutton" ></a>';
                  // 删除
                  str +=
                    '<a href="javascript:void(0);" name="delSubRecord" data-id="' +
                    e.field +
                    '" class="easyui-linkbutton" ></a>';
                }
              }
              return value + str;
            } else if (row.grades && value) {
              return (
                '<span title="' + row.grades[value] + '">' + value + "</span>"
              );
            } else {
              return value;
            }
          };
        });
        $("#subRecordTable").datagrid({
          showHeader: false,
          frozenColumns: [
            [
              {
                field: "adrsDesc",
                width: 200,
                formatter: function (value, row, index) {
                  if (index > fixRowNum - 1) {
                    var str =
                      '<a href="javascript:void(0);" name="showADRsCurve" data-id="' +
                      row.ardsId +
                      '" class="easyui-linkbutton" ></a>';
                    return value + str;
                  } else {
                    return value;
                  }
                },
              },
            ],
          ],
          columns: [data.columns],
          data: { total: data.rows.length, rows: data.rows },
          onLoadSuccess: function (data) {
            $("a[name='checkSubRecord']").map(function (index, elem) {
              var id = $(this).data("id");
              var status = $(this).data("status");
              $(elem).linkbutton({
                plain: true,
                size: "small",
                onClick: checkSubRecord(id, status),
                iconCls: "icon-eye",
              });
            });
            $("a[name='auditSubRecord']").map(function (index, elem) {
              var id = $(this).data("id");
              $(elem).linkbutton({
                plain: true,
                size: "small",
                onClick: auditSubRecord(id),
                iconCls: "icon-paper-stamp",
              });
            });
            $("a[name='recallSubRecord']").map(function (index, elem) {
              var id = $(this).data("id");
              $(elem).linkbutton({
                plain: true,
                size: "small",
                onClick: recallSubRecord(id),
                iconCls: "icon-cancel-order",
              });
            });
            $("a[name='editSubRecord']").map(function (index, elem) {
              var id = $(this).data("id");
              if (docFlag) {
                var status = $(this).data("status");
                $(elem).linkbutton({
                  plain: true,
                  size: "small",
                  onClick: checkSubRecord(id, status),
                  iconCls: "icon-write-order",
                });
              } else {
                $(elem).linkbutton({
                  plain: true,
                  size: "small",
                  onClick: editSubRecord(id),
                  iconCls: "icon-write-order",
                });
              }
            });
            $("a[name='delSubRecord']").map(function (index, elem) {
              var id = $(elem).data("id");
              $(elem).linkbutton({
                plain: true,
                size: "small",
                onClick: delSubRecord(id),
                iconCls: "icon-cancel",
              });
            });
            $("a[name='showADRsCurve']").map(function (index, elem) {
              var id = $(elem).data("id");
              $(elem).linkbutton({
                plain: true,
                size: "small",
                onClick: showADRsCurve(id),
                iconCls: "icon-analysis",
              });
            });
          },
        });
        $("#subRecordTable")
          .datagrid("freezeRow", 0)
          .datagrid("freezeRow", 1)
          .datagrid("freezeRow", 2)
          .datagrid("freezeRow", 3);
        if (5 == fixRowNum) {
          $("#subRecordTable").datagrid("freezeRow", 4);
        }
        drawCanvas();
        // 设置已审核的列的背景色
        data.columns.map(function (e, i) {
          if (data.status && 1 == data.status[e.field]) {
            $("td[field='" + e.field + "']").css("background", "#eeeeee");
          }
        });
        subRecordTableFlag = true;
      } else {
        $("#subRecordTable").datagrid({
          data: { total: 0, rows: [] },
        });
        $("#myCanvas").remove();
      }
    }
  );
}

function showADRsCurve(tmpId) {
  var id = tmpId;
  return function () {
    adrsItemId = id;
    $("#assessStartDate").datebox("setValue", dateCalculate(new Date(), -29));
    $("#assessEndDate").datebox("setValue", formatDate(new Date()));
    getADRSItemAssessGrade();
  };
}

function drawADRSItemGradeCurve(data) {
  var adrsGradeCurve = $("#adrsGradeCurve");
  adrsGradeCurve.empty();
  var width = adrsGradeCurve.width() - 2;
  var height = adrsGradeCurve.height() - 2;
  adrsGradeCurve.append(
    '<canvas id="gradeCurve" width="' +
      width +
      '" height="' +
      height +
      '" style="position:absolute;top:1px;left:1px;"></canvas>'
  );
  var n = 2; //缩放比例
  width = width * n;
  height = height * n;
  var rowHeight = (height * 0.8) / 7;
  var c = document.getElementById("gradeCurve");
  var ctx = c.getContext("2d");
  ctx.scale(1 / n, 1 / n);
  ctx.fillStyle = "#FFFFFF";
  ctx.fillRect(0, 0, width, height);
  ctx.fillStyle = "#000000";
  ctx.font = 26 * n + "px 'Microsoft Yahei'";
  ctx.fillText(data.desc, (width - data.desc.length * n * 26) / 2, rowHeight);
  ctx.font = 14 * n + "px 'Microsoft Yahei'";
  ctx.lineWidth = n;
  for (var i = 0; i < 7; i++) {
    ctx.beginPath();
    ctx.strokeStyle = "#cccccc";
    ctx.fillText(i, 10 * n, height - rowHeight * (i + 1));
    if (0 == i) {
      ctx.setLineDash([1, 0]);
    } else {
      ctx.setLineDash([2 * n, 2 * n]);
    }
    ctx.moveTo(34 * n, height - rowHeight * (i + 1) - 5);
    ctx.lineTo(width - 10 * n, height - rowHeight * (i + 1) - 5);
    ctx.stroke();
  }
  var list = data.list;
  var length = list.length;
  var segment = (width - 44 * n) / (length + 1);
  var start = 34 * n + segment;
  var prePoint = []; //前一个点
  // {date:"2020-11-26",grade:2}
  for (var i = 0; i < length; i++) {
    ctx.beginPath();
    ctx.setLineDash([1, 0]);
    ctx.strokeStyle = "#cccccc";
    var date = list[i].date;
    var grade = parseInt(list[i].grade);
    var xPoint = start + segment * i;
    var yPoint = height - rowHeight * (grade + 1) - 5;
    ctx.fillStyle = "#000000";
    ctx.fillText(date, xPoint - date.length * 3.8 * n, height - rowHeight / 2);
    ctx.fillText(grade, xPoint + 10 * n, yPoint + 5 * n);
    ctx.moveTo(xPoint, height - rowHeight - 5);
    ctx.lineTo(xPoint, height - rowHeight * 0.8 - 5);
    ctx.stroke();
    ctx.beginPath();
    ctx.fillStyle = "#378ec4";
    ctx.strokeStyle = "#40A2DE";
    console.log(xPoint);
    console.log(yPoint);
    ctx.arc(xPoint, yPoint, 3 * n, 0, 2 * Math.PI);
    ctx.fill();
    if (prePoint.length) {
      ctx.moveTo(prePoint[0], prePoint[1]);
      ctx.lineTo(xPoint, yPoint);
      ctx.stroke();
    }
    if (xPoint && yPoint) prePoint = [xPoint, yPoint];
  }
  $("#adrsCurveModal").dialog({height: 'auto'}).dialog("open");
  var offsetLeft = (window.innerWidth - $("#adrsCurveModal").parent().width()) / 2;
  var offsetTop = (window.innerHeight - $("#adrsCurveModal").parent().height()) / 2;
  $("#adrsCurveModal").dialog({
    left: offsetLeft,
    top: offsetTop,
  }).dialog("open");
}

function getADRSItemAssessGrade() {
  $cm(
    {
      ClassName: "Nur.NIS.Service.CTC.Record",
      MethodName: "GetADRSItemAssessGrade",
      startDate: $("#assessStartDate").datebox("getValue"),
      endDate: $("#assessEndDate").datebox("getValue"),
      rowId: $("#evaluateList").datagrid("getSelected").id,
      adrsItemId: adrsItemId,
    },
    function (data) {
      console.log(data);
      var innerWidth = window.innerWidth - 100;
      var innerHeight = window.innerHeight - 100;
      $("#adrsCurveModal")
        .dialog({
          width: innerWidth,
          height: innerHeight,
        })
        .dialog("open");

      $("#adrsGradeCurve").css({
        width: "100%",
        height: innerHeight - 227 - $(".curvePatBar").height() + "px",
      });
      $(".curvePatBar").css(
        "height",
        $(".curvePatBar .PatInfoItem").height() + 5 + "px"
      );
      drawADRSItemGradeCurve(data);
    }
  );
}

function delSubRecord(tmpId) {
  var id = tmpId;
  return function () {
    $.messager.confirm($g("删除"), $g("确定要删除选中的数据？"), function (r) {
      if (r) {
        $cm(
          {
            ClassName: "Nur.NIS.Service.CTC.Record",
            MethodName: "DeleteCTCSubRecord",
            ID: id,
          },
          function (data) {
            console.log(data);
            if (0 == data) {
              $.messager.popover({ msg: $g("删除成功！"), type: "success" });
              getCTCSubRecord();
            } else {
              $.messager.popover({ msg: JSON.stringify(data), type: "alert" });
            }
          }
        );
      }
    });
  };
}

function checkSubRecord(tmpId, tmpStatus) {
  var id = tmpId,
    status = tmpStatus;
  return function () {
    showSavedRecordOfCtcAEModal(id, "check", status);
  };
}

function auditSubRecord(tmpId) {
  var id = tmpId;
  return function () {
    subRecordObj = { id: id };
    auditCTCSubRecord();
  };
}

function recallSubRecord(tmpId) {
  var id = tmpId;
  return function () {
    subRecordObj = { id: id };
    recallCTCSubRecord();
  };
}

function editSubRecord(tmpId) {
  var id = tmpId;
  return function () {
    showSavedRecordOfCtcAEModal(id, "edit");
  };
}

function drawCanvas() {
  var frozenTable = $(
    ".adrs .datagrid-view1 .datagrid-btable.datagrid-btable-frozen"
  );
  var width = frozenTable.width() - 1;
  var height = frozenTable.height() - 2;
  frozenTable.after(
    '<canvas id="myCanvas" width="' +
      width +
      '" height="' +
      height +
      '" style="position:absolute;top:1px;left:1px;"></canvas>'
  );
  width = width * 2;
  height = height * 2;
  var c = document.getElementById("myCanvas");
  var ctx = c.getContext("2d");
  ctx.scale(0.5, 0.5);
  ctx.fillStyle = "#FFFFFF";
  ctx.fillRect(0, 0, width, height);
  ctx.fillStyle = "#000000";
  ctx.font = "28px 'Microsoft Yahei'";
  ctx.fillText($g("评价日期"), width - 124, 36);
  if (0 == curModelType) {
    ctx.fillText($g("化疗周期数"), width - 152, height / fixRowNum + 36);
  } else if (1 == curModelType) {
    ctx.fillText($g("放疗次数"), width - 124, height / fixRowNum + 36);
  } else if (2 == curModelType) {
    ctx.fillText($g("放疗次数"), width - 124, height / fixRowNum + 36);
    ctx.fillText($g("化疗周期数"), width - 152, (height / fixRowNum) * 2 + 36);
  } else {
    ctx.fillText($g("其他"), width - 68, height / fixRowNum + 36);
  }
  ctx.fillText(
    $g("评估/更新人"),
    width - 165,
    (height / fixRowNum) * (fixRowNum - 2) + 36
  );
  ctx.fillText(
    $g("审核人"),
    width - 96,
    (height / fixRowNum) * (fixRowNum - 1) + 36
  );
  ctx.fillText($g("不良反应"), 20, height - 20);
  ctx.beginPath();
  ctx.strokeStyle = "#cccccc";
  ctx.moveTo(0, 0);
  ctx.lineTo(width - 66, height);
  ctx.stroke();
  setTimeout(function () {
    updateDomSize();
  }, 200);
}

function isChinese(str) {
  var lst = /[u00-uFF]/;
  return !lst.test(str);
}

function strlen(str) {
  var strlength = 0;
  for (var i = 0; i < str.length; ++i) {
    if (isChinese(str.charAt(i)) == true) {
      strlength = strlength + 1; //中文计算为一个字符
    } else {
      strlength = strlength + 0.5;
    }
  }
  return strlength;
}
var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
var isOpera = userAgent.indexOf("Opera") > -1; //判断是否Opera浏览器
var isIE =
  (userAgent.indexOf("compatible") > -1 &&
    userAgent.indexOf("MSIE") > -1 &&
    !isOpera) ||
  userAgent.indexOf("rv:11") > -1; //判断是否IE浏览器
console.log('"""""""""""""isIE"""""""""""""');
console.log(isIE);
// 打印前判断是否有未审核（广州泰和肿瘤）
function prePrint() {
  $cm(
    {
      ClassName: "Nur.NIS.Service.CTC.Record",
      MethodName: "GetCTCSubRecord",
      rowId: $("#evaluateList").datagrid("getSelected").id,
      // rowId: "1||1",
      curPage: 1,
      pageSize: 100000000000,
    },
    function (data) {
      console.log(data);
      var dateStr = "",
        examRow;
      // 根据键值中是否有Time获取审核人行
      var rows = data.rows,
        len = rows.length;
      for (var i = 0; i < len; i++) {
        var keys = Object.keys(rows[i]);
        for (var j = 0; j < keys.length; j++) {
          if (keys[j].includes("Time")) {
            examRow = rows[i];
            break;
          }
        }
        if (examRow) break;
      }
      examRow = examRow || {};
      data.columns.map(function (e) {
        if (!examRow[e.field + "Time"]) {
          dateStr += data.rows[0][e.field] + "、";
        }
      });
      dateStr = dateStr.slice(0, -1);
      if (dateStr) {
        $.messager.confirm(
          $g("提示"),
          dateStr + $g("的记录未审核，是否继续打印？"),
          function (r) {
            if (r) {
              printCTCSubRecord(data);
            }
          }
        );
      } else {
        printCTCSubRecord(data);
      }
    }
  );
}
// 打印评估记录
function printCTCSubRecord(data) {
  console.log(isIE);
  console.log(patNode);
  var LODOP = getLodop();
  var pt2mm = 25.4 / 72,
    mm2pt = 72 / 25.4;
  // 患者信息
  var patInfo = $cm(
    {
      ClassName: "Nur.NIS.Service.Base.Patient",
      MethodName: "GetPatient",
      EpisodeID: patNode.episodeID,
    },
    false
  );
  var birthday = $cm(
    {
      ClassName: "Nur.NIS.Service.Base.Patient",
      MethodName: "GetReadablePatBirthDate",
      dataType: "text",
      papmi: patNode.patientID,
    },
    false
  );
  console.log(patInfo);

  var head,
    top,
    width,
    left,
    fontSize = 12,
    boldRate = 1 + 1 / 6;

  LODOP.PRINT_INIT("恶性肿瘤放化疗不良反应评价表（CTC 5.0）"); //打印初始化
  LODOP.SET_PRINT_STYLE("FontName", "Times New Roman");
  // LODOP.SET_PRINT_PAGESIZE(0, 2100, 2970, "A4");//设置纸张为A4（按操作系统定义的A4尺寸），横向打印
  LODOP.SET_PRINT_PAGESIZE(0, "210mm", "285mm", "A4"); //设置纸张为A4（按操作系统定义的A4尺寸），横向打印

  // 页眉
  // LODOP.ADD_PRINT_IMAGE(0,0,276,57,"<img border='0' src='http://114.242.246.235:18080/imedical/web/images/gzthzlyy.png'>");
  if (2 == session["LOGON.HOSPID"]) {
    LODOP.ADD_PRINT_IMAGE(
      0,
      0,
      276,
      57,
      "<img border='0' src='../images/xctylmzb.png'>"
    );
  } else {
    LODOP.ADD_PRINT_IMAGE(
      0,
      0,
      276,
      57,
      "<img border='0' src='../images/gzthzlyy.png'>"
    );
  }
  // LODOP.ADD_PRINT_SETUP_BKIMG("<img border='0' src='../images/gzthzlyy.png'>");
  LODOP.SET_PRINT_STYLEA(0, "Stretch", 2);
  LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
  var height = 14;
  left = 550;
  width = 300;
  LODOP.ADD_PRINT_TEXT(
    3 + height * 0,
    500,
    300,
    height,
    "Patient Name姓名：" + patInfo.name
  );
  LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
  LODOP.ADD_PRINT_TEXT(
    3 + height * 1,
    500,
    300,
    height,
    "Sex性别：" + patInfo.sex
  );
  LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
  LODOP.ADD_PRINT_TEXT(
    3 + height * 2,
    500,
    300,
    height,
    "Birth Date出生日期：" + birthday
  );
  LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
  LODOP.ADD_PRINT_TEXT(
    3 + height * 3,
    500,
    300,
    height,
    "Medical Record No病历号：" + (patInfo.medicareNo || "")
  );
  LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
  LODOP.ADD_PRINT_LINE(60, 0, 60, 2100, 0, 1);
  LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);

  // 标题
  head = "恶性肿瘤放化疗不良反应评价表（CTC 5.0）";
  top = "20mm";
  width = strlen(head) * fontSize * pt2mm * boldRate + "mm";
  left = (210 - parseFloat(width)) / 2 + "mm";
  LODOP.ADD_PRINT_TEXT(top, left, width, 30, head);
  LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
  LODOP.SET_PRINT_STYLEA(0, "FontSize", fontSize);
  LODOP.SET_PRINT_STYLEA(0, "bold", 1);
  // 副标题
  fontSize = 11;
  head =
    "Evaluation of Adverse Events to Chemo-Radiotherapy for Malignant tumors";
  top = parseFloat(top) + 5 + "mm";
  width = strlen(head) * fontSize * pt2mm + "mm";
  left = (210 - parseFloat(width)) / 2 + 13 + "mm";
  LODOP.ADD_PRINT_TEXT(top, left, width, 30, head);
  LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
  LODOP.SET_PRINT_STYLEA(0, "FontSize", fontSize);
  // 患者信息
  fontSize = 10;
  LODOP.SET_PRINT_STYLE("FontSize", fontSize);
  // var patTable='<table width="100%" style="border-collapse:collapse"><tbody><tr><td>姓名 Name：'+(patInfo.name||'')+'</td><td>病历号 Medical record no. ：'+(patInfo.medicareNo||'')+'</td></tr><tr><td>年龄 Age ：'+(patInfo.age||'')+'</td><td>性别 Sex ：'+(patInfo.sex||'')+'</td></tr><tr><td colspan="2">诊断 Diagnosis：'+(patInfo.diagnosis||'')+'</td></tr>';
  var patTable =
    '<table width="100%" style="border-collapse:collapse"><tbody><tr><td colspan="2">诊断 Diagnosis：' +
    (patInfo.diagnosis || "") +
    "</td></tr>";

  var recordInfo = getCTCRecordById(
    $("#evaluateList").datagrid("getSelected").id
  );
  var keys = Object.keys(healPlan),
    count = 0;
  keys.map(function (k, i) {
    if (recordInfo[k]) {
      if (0 == count) {
        count++;
        patTable +=
          "<tr><td>治疗模式：" +
          modelType[recordInfo.modelType] +
          "</td><td>" +
          healPlan[k] +
          recordInfo[k] +
          "</td></tr>";
      } else if (1 == count) {
        count++;
        patTable += "<tr><td>" + healPlan[k] + recordInfo[k] + "</td>";
      } else {
        patTable += "<td>" + healPlan[k] + recordInfo[k] + "</td>";
      }
    }
  });
  if (count > 1) patTable += "</tr>";
  patTable += "</tbody></table>";

  // ADD_PRINT_TABLE(Top,Left,Width,Height,strHtml)
  top = parseFloat(top) + 10 + "mm";
  LODOP.ADD_PRINT_TABLE(top, 0, "210mm", "50mm", patTable);
  LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
  LODOP.ADD_PRINT_HTM(
    1010,
    650,
    200,
    100,
    "<span tdata='pageNO' style='margin:0;'>第##页/</span><span tdata='pageCount' style='margin:0;'>共##页</span>"
  );
  LODOP.SET_PRINT_STYLEA(0, "ItemType", 1); //每页都输出
  if (isIE) {
    top = parseFloat(top) + 15 + "mm";
  } else {
    top = parseFloat(top) + 18 + "mm";
  }
  var beginTop = top;
  var pageModel = 285,
    topNum,
    pageCount = 1; //页面的模量
  // LODOP.ADD_PRINT_TEXT(pageModel+"mm",10,500, 15, "测试页面的模量");

  // $cm({
  //   ClassName: 'Nur.NIS.Service.CTC.Record',
  //   MethodName: 'GetCTCSubRecord',
  //   rowId: $('#evaluateList').datagrid('getSelected').id,
  //   // rowId: "1||1",
  // curPage:1,
  // pageSize:100000000000
  // }, function (data) {
  fixRowNum = 4;
  if (0 == curModelType) {
    data.rows.splice(3, 1);
    data.rows.splice(1, 1);
  } else if (1 == curModelType) {
    data.rows.splice(2, 2);
  } else if (2 == curModelType) {
    data.rows.splice(3, 1);
    fixRowNum = 5;
  } else {
    data.rows.splice(1, 2);
  }
  var cols = 5; //每行显示5列数据
  var columns = data.columns,
    rows = data.rows;
  var length = columns.length;
  var part = Math.ceil(length / cols);
  var rowHeight = 6,
    fiveRowsHeight = 28,
    left2 = 180,
    startTop = parseFloat(top),
    tableHeight = 0,
    breakK = 0,
    printLineFlag = true;
  if (isIE) {
    rowHeight = 5;
    fiveRowsHeight = 21.1;
    left2 = 135;
  }
  var newPageFlag = false; //判断是不是要新的页面
  // for (var m = 0; m < 5; m++) {
  for (var i = 0; i < part; i++) {
    var maxLen = Math.min(length, (i + 1) * cols);
    var subRcdTable =
      '<table border="1" width="94%" style="border:solid 1px black;border-collapse:collapse"><col width=220 /><tbody>';
    // // 固定fixRowNum行
    for (var k = 0; k < fixRowNum; k++) {
      if (newPageFlag) {
        LODOP.NEWPAGE();
        newPageFlag = false;
      }
      if (fixRowNum - 1 == k) {
        subRcdTable +=
          '<tr><td style="text-align:right;border-bottom:0;"><span style="float: left;">不良反应</span>' +
          rows[k].adrsDesc +
          "</td>";
      } else {
        subRcdTable +=
          '<tr><td style="text-align:right;border-bottom:0;">' +
          rows[k].adrsDesc +
          "</td>";
      }
      for (var j = i * cols; j < maxLen; j++) {
        subRcdTable += "<td>" + (rows[k][columns[j].field] || " ") + "</td>";
      }
      subRcdTable += "</tr>";
      tableHeight += rowHeight;
      if (startTop + tableHeight + rowHeight * 3 > pageModel) {
        subRcdTable += "</tbody></table>";
        LODOP.ADD_PRINT_HTM(
          startTop + "mm",
          0,
          "210mm",
          tableHeight + "mm",
          subRcdTable
        );
        LODOP.ADD_PRINT_LINE(
          startTop + "mm",
          3 + (left2 / fixRowNum) * breakK,
          parseFloat(startTop) + (fiveRowsHeight / 5) * (k + 1) + "mm",
          (left2 / fixRowNum) * (k + 1),
          0,
          1
        );
        newPageFlag = true;
        breakK = k;
        // startTop=20;
        startTop = parseFloat(beginTop);
        tableHeight = 0;
        subRcdTable =
          '<table border="1" width="94%" style="border:solid 1px black;border-collapse:collapse"><col width=220 /><tbody>';
      }
    }
    for (k = fixRowNum; k < rows.length; k++) {
      if (newPageFlag) {
        LODOP.NEWPAGE();
        newPageFlag = false;
      }
      subRcdTable += "<tr><td>" + rows[k].adrsDesc + "</td>";
      for (var j = i * cols; j < maxLen; j++) {
        subRcdTable += "<td>" + (rows[k][columns[j].field] || " ") + "</td>";
      }
      subRcdTable += "</tr>";
      tableHeight += rowHeight;
      if (startTop + tableHeight + rowHeight * 3 > pageModel) {
        subRcdTable += "</tbody></table>";
        LODOP.ADD_PRINT_HTM(
          startTop + "mm",
          0,
          "210mm",
          tableHeight + "mm",
          subRcdTable
        );
        LODOP.ADD_PRINT_LINE(
          startTop + "mm",
          3,
          parseFloat(startTop) + (fiveRowsHeight / 5) * fixRowNum + "mm",
          left2,
          0,
          1
        );
        printLineFlag = false;
        // LODOP.ADD_PRINT_HTM(1010,650,200,100,"<span tdata='pageNO' style='margin:0;'>第##页/</span><span tdata='pageCount' style='margin:0;'>共##页</span>");
        //    LODOP.SET_PRINT_STYLEA(0,"ItemType",1);//每页都输出
        newPageFlag = true;
        // startTop=20;
        startTop = parseFloat(beginTop);
        tableHeight = 0;
        subRcdTable =
          '<table border="1" width="94%" style="border:solid 1px black;border-collapse:collapse"><col width=220 /><tbody>';
      }
    }
    subRcdTable += "</tbody></table>";
    console.log(subRcdTable);

    LODOP.ADD_PRINT_HTM(
      startTop + "mm",
      0,
      "210mm",
      tableHeight + "mm",
      subRcdTable
    );
    if (breakK != fixRowNum - 1) {
      if (breakK > 0) {
        LODOP.ADD_PRINT_LINE(
          startTop + "mm",
          3 + (left2 / fixRowNum) * breakK,
          parseFloat(startTop) + (fiveRowsHeight / 5) * fixRowNum + "mm",
          left2,
          0,
          1
        );
        breakK = 0;
      } else if (printLineFlag) {
        LODOP.ADD_PRINT_LINE(
          startTop + "mm",
          3,
          parseFloat(startTop) + (fiveRowsHeight / 5) * fixRowNum + "mm",
          left2,
          0,
          1
        );
      }
    } else {
      printLineFlag = true;
    }
    startTop += tableHeight;
    tableHeight = 0;
  }
  // }
  LODOP.PREVIEW();
  // })
}

function updateDomSize() {
  var innerHeight = window.innerHeight;
  $("#patientList").panel("resize", {
    height: innerHeight - 93,
  });
  $("#adrsPanel").panel("resize", {
    height: innerHeight - 51,
  });
  $("#evaluateList").datagrid("resize", {
    height: innerHeight - 105,
  });
  if (subRecordTableFlag) {
    $("#subRecordTable").datagrid("resize", {
      height: innerHeight - 216,
    });
  }
}
window.addEventListener("resize", updateDomSize);
