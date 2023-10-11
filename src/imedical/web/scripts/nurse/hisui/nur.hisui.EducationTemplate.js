$.extend($.fn.datagrid.methods, {
  getEditingRowIndexs: function (jq) {
    var rows = $.data(jq[0], "datagrid").panel.find(".datagrid-row-editing");
    var indexs = [];
    rows.each(function (i, row) {
      var index = row.sectionRowIndex;
      if (indexs.indexOf(index) == -1) {
        indexs.push(index);
      }
    });
    return indexs;
  },
});
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
// -----------------------------------------------------
var hospID = session['LOGON.HOSPID'],
  docAdvicesObj = {},
  eventObj = {},
  assessObj = {},
  diagnoseObj = {},
  operateObj = {},
  itemsObj = {},
  wardsObj = {};
var daObj = {},
  reObj = {},
  asObj = {},
  dgObj = {},
  opObj = {},
  itObj = {},
  wsObj = {};
var remindFlag=true;
var firstFlag=true; // 记录第一次修改datagrid
var unfoldFlag=true;//评估项树展开标识
var quoteUnFoldFlag=true;//评估项树展开标识
var tplTreeFlodFlag=localStorage.getItem("tplTreeFlodFlag"+session['LOGON.USERID']);
var ftpIP;
if ('undefined'==typeof HISUIStyleCode) {
	var HISUIStyleCode="blue";
}
if (!tplTreeFlodFlag) {
	tplTreeFlodFlag=1; // 展开
}else{
	tplTreeFlodFlag=parseInt(tplTreeFlodFlag);
}
var quoteTreeFlodFlag=localStorage.getItem("quoteTreeFlodFlag"+session['LOGON.USERID']);
if (!quoteTreeFlodFlag) {
	quoteTreeFlodFlag=1; // 展开
}else{
	quoteTreeFlodFlag=parseInt(quoteTreeFlodFlag);
}
var page = 1,
  pageSize = 20;
var contextNode,
  clickNode,
  sortFlag = false,
  sortPid;
var docAdviceloader = function (param, success, error) {
  var q = param.q || "";
  var delimiter = String.fromCharCode(12);
  var key = q;
  if ("" === key) key = delimiter;
  if (!docAdvicesObj[key]) {
    var docAdvices = $cm(
      {
        ClassName: "Nur.NIS.Service.TaskOverview.Normal",
        QueryName: "GetDocAdvice",
        rows: 50,
        ARCIMDesc: q,
        hospDR: hospID,
      },
      false
    );
    docAdvicesObj[key] = docAdvices.rows;
  }
  var id = daObj.id;
  if (id) {
    var exist = false;
    $.map(docAdvicesObj[key], function (e) {
      if (id == e.id) exist = true;
    });
    if (!exist)
      docAdvicesObj[key].push({
        id: daObj.id,
        desc: daObj.adviseDesc,
      });
    success(docAdvicesObj[key]);
    daObj = {};
  } else {
    success(docAdvicesObj[key]);
  }
};
var eventloader = function (param, success, error) {
  var q = param.q || "";
  var delimiter = String.fromCharCode(12);
  var key = q;
  if ("" === key) key = delimiter;
  if (!eventObj[key]) {
    var docAdvices = $cm(
      {
        ClassName: "Nur.NIS.Service.TaskOverview.Normal",
        QueryName: "GetEventType",
        rows: 50,
        keyword: q,
        hospID: hospID,
      },
      false
    );
    eventObj[key] = docAdvices.rows;
  }
  var id = reObj.id;
  if (id) {
    var exist = false;
    $.map(eventObj[key], function (e) {
      if (id == e.id) exist = true;
    });
    if (!exist)
      eventObj[key].push({
        id: reObj.id,
        desc: reObj.relationAssess,
      });
    success(eventObj[key]);
    reObj = {};
  } else {
    success(eventObj[key]);
  }
};
var assessloader = function (param, success, error) {
  var q = param.q || "";
  var delimiter = String.fromCharCode(12);
  var key = q;
  if ("" === key) key = delimiter;
  if (!assessObj[key]) {
    var docAdvices = $cm(
      {
        ClassName: "Nur.NIS.Service.TaskOverview.Normal",
        QueryName: "GetAssessItems",
        rows: 50,
        keyword: q,
        loc: session["LOGON.CTLOCID"],
        hospDR: hospID,
      },
      false
    );
    assessObj[key] = docAdvices.rows;
  }
  var id = asObj.id;
  if (id) {
    console.log(JSON.stringify(asObj));
    console.log(asObj.id);
    var exist = false;
    $.map(assessObj[key], function (e) {
      if (id == e.id) exist = true;
    });
    if (!exist) assessObj[key].push({
      id:asObj.id,
      desc:asObj.relationAssess,
    });
    success(assessObj[key]);
    asObj = {};
  } else {
    success(assessObj[key]);
  }
};
var diagnoseloader = function (param, success, error) {
  var q = param.q || "";
  var delimiter = String.fromCharCode(12);
  var key = q;
  if ("" === key) key = delimiter;
  if (!diagnoseObj[key]) {
    var docAdvices = $cm(
      {
        ClassName: "Nur.NIS.Service.Education2.Setting",
        QueryName: "GetDiagnosisList",
        rows: 50,
        keyword: q,
        hospID: hospID,
      },
      false
    );
    diagnoseObj[key] = docAdvices.rows;
  }
  var id = dgObj.id;
  if (id) {
    var exist = false;
    $.map(diagnoseObj[key], function (e) {
      if (id == e.id) exist = true;
    });
    if (!exist) diagnoseObj[key].push(dgObj);
    success(diagnoseObj[key]);
    dgObj = {};
  } else {
    success(diagnoseObj[key]);
  }
};
var operateloader = function (param, success, error) {
  var q = param.q || "";
  var delimiter = String.fromCharCode(12);
  var key = q;
  if ("" === key) key = delimiter;
  if (!operateObj[key]) {
    var docAdvices = $cm(
      {
        ClassName: "Nur.NIS.Service.Education2.Setting",
        QueryName: "GetOperateList",
        rows: 50,
        keyword: q,
        hospID: hospID,
      },
      false
    );
    operateObj[key] = docAdvices.rows;
  }
  var id = opObj.id;
  if (id) {
    var exist = false;
    $.map(operateObj[key], function (e) {
      if (id == e.id) exist = true;
    });
    if (!exist) operateObj[key].push(opObj);
    success(operateObj[key]);
    opObj = {};
  } else {
    success(operateObj[key]);
  }
};
var itemsloader = function (param, success, error) {
  var q = param.q || "";
  var delimiter = String.fromCharCode(12);
  var key = q;
  if ("" === key) key = delimiter;
  if (!itemsObj[key]) {
    var docAdvices = $cm(
      {
        ClassName: "Nur.NIS.Service.TaskOverview.Normal",
        QueryName: "GetDocAdvice",
        rows: 50,
        ARCIMDesc: q,
        hospDR: hospID,
        type: "LS",
      },
      false
    );
    itemsObj[key] = docAdvices.rows;
  }
  var id = itObj.id;
  if (id) {
    var exist = false;
    $.map(itemsObj[key], function (e) {
      if (id == e.id) exist = true;
    });
    if (!exist)
      itemsObj[key].push({
        id: itObj.id,
        desc: itObj.adviseDesc,
      });
    success(itemsObj[key]);
    itObj = {};
  } else {
    success(itemsObj[key]);
  }
};
var wardsloader = function (param, success, error) {
  var q = param.q || "";
  var delimiter = String.fromCharCode(12);
  var key = q;
  if ("" === key) key = delimiter;
  if (!wardsObj[key]) {
    var docAdvices = $cm(
      {
        ClassName: "Nur.NIS.Service.Base.Ward",
        QueryName: "GetallWardNew",
        rows: 50,
        desc: q,
        hospid: hospID,
        bizTable: "Nur_IP_Education2",
      },
      false
    );
    docAdvices.rows.unshift({
      wardid: "-1",
      warddesc: $g("护理部"),
    });
    wardsObj[key] = docAdvices.rows;
  }
  success(wardsObj[key]);
};
$(function () {
  hospComp = GenHospComp(
    "Nur_IP_Education2",
    session["LOGON.USERID"] +
      "^" +
      session["LOGON.GROUPID"] +
      "^" +
      session["LOGON.CTLOCID"] +
      "^" +
      session["LOGON.HOSPID"]
  );
  hospID = hospComp.getValue();
  hospComp.options().onSelect = function (i, d) {
    hospID = d.HOSPRowId;
    docAdvicesObj = {};
    eventObj = {};
    assessObj = {};
    diagnoseObj = {};
    operateObj = {};
    itemsObj = {};
    wardsObj = {};
    init();
  };
  $("#_HospList").combogrid("disable");
  init();
});
function init() {
  // 获取日期格式
  var res = $cm(
    {
      ClassName: "Nur.NIS.Service.System.Config",
      MethodName: "GetSystemConfig",
    },
    false
  );
  dateformat = res.dateformat;
	if ('lite'==HISUIStyleCode) { //极简
		// $('.eduExeStyle').append('#eduQuoteInput {width: 187px !important;height: 26px;}');
		$('.eduExeStyle').append('#edusubjectInput+a, #eduQuoteInput+a {margin-right: 10px;}');
	} else {
		// $('.eduExeStyle').append('#eduQuoteInput {width: 163px !important;height: 30px;}');
	}
  getEdusubjectTreeData();
  getQuoteSubject();
  $HUI.tabs("#eduSetTab", {
    onSelect: function (date, index) {
      // console.log(date, index);
      // console.log($("#coverFrame").attr('src'));
      // if (2==index) {
      //   if (!$("#coverFrame").attr('src')) {
      //     $("#coverFrame").attr('src',"nur.hisui.educationcover.csp")
      //   }
      // }
      if (2==index) {
        if (!$("#resultFrame").attr('src')) {
			var url = "nur.hisui.educationresult.csp"
			if ('undefined'!==typeof websys_getMWToken){
				url += "?MWToken="+websys_getMWToken()
			}
        	$("#resultFrame").attr('src',url)
        }
      }
    },
  });
	getEduMultiExeConfig();
  $("#eduQuoteModal").dialog({
    onClose: function () {
      // 把节点设置为未勾选
      var nodes = $('#eduQuoteTree').tree('getChecked');
      var $eduQuoteTree=$('#eduQuoteTree');
      for ( var i = 0; i < nodes.length; i++) {
        $eduQuoteTree.tree('uncheck', nodes[i].target);
      }
      $("#quoteTable").datagrid({
        data: {
          total: 0,
          rows: [],
        }
      });
      $("#quoteContent").linkbutton("disable");
    }
  });
	$("#toggleFold").off().click(function(argument) {
			var operator;
			if (unfoldFlag) {
					unfoldFlag = false;
					operator = "collapse";
					$('#toggleFold').linkbutton({
						iconCls:'icon-unindent',
					});
			} else {
					unfoldFlag = true;
					operator = "expand";
					$('#toggleFold').linkbutton({
						iconCls:'icon-indentation',
					});
			}
			localStorage.setItem("tplTreeFlodFlag"+session['LOGON.USERID'],unfoldFlag?1:0);
			var roots = $("#edusubjectTree").tree("getRoots");
			var $edusubjectTree = $('#edusubjectTree');
			roots[0].children.map(function(e) {
					if (e.children) {
							var target = $edusubjectTree.tree('find', e.id).target
							$edusubjectTree.tree(operator, target);
					}
			})
	});
	$("#quoteToggleFold").off().click(function(argument) {
			var operator;
			if (quoteUnFoldFlag) {
					quoteUnFoldFlag = false;
          quoteTreeFlodFlag=0;
					operator = "collapse";
					$('#quoteToggleFold').linkbutton({
						iconCls:'icon-unindent',
					});
			} else {
					quoteUnFoldFlag = true;
          quoteTreeFlodFlag=1;
					operator = "expand";
					$('#quoteToggleFold').linkbutton({
						iconCls:'icon-indentation',
					});
			}
			localStorage.setItem("quoteTreeFlodFlag"+session['LOGON.USERID'],quoteUnFoldFlag?1:0);
			var roots = $("#eduQuoteTree").tree("getRoots");
			var $eduQuoteTree = $('#eduQuoteTree');
			roots[0].children.map(function(e) {
					if (e.children) {
							var target = $eduQuoteTree.tree('find', e.id).target
							$eduQuoteTree.tree(operator, target);
					}
			})
	});
  $cm({
    ClassName: "NurMp.Service.Switch.Config",
    MethodName: "GetConfiguration",
    HospitalID:hospID,
    PageCode:"FTP"
  }, function (d) {
    ftpIP=d.FtpAddress;
  });
}
function addAttachment() {
  var $p = $("#attachFiles>div");
  $p.append('<div style="display:none;"><input class="annexFile" style="display: none;" type="file" onchange="changepic(this)"><span></span><span class="l-btn-icon icon-cancel" onclick="deleteEduAnnex(0,this)">&nbsp;</span></div>');
  $("#attachFiles>div>div:eq(-1)>input").click();
}
function startMask() {
  var maskWidth = $(window).width();  
  var maskHeight = $(window).height();  
  var maskHtml = "<div id='maskLoading' class='panel-body' style='z-index:10000000000;position:absolute;left:0;width:100%!important;background: rgba(0,0,0,.2);";  
  maskHtml += "height:" + maskHeight + "px;top:0'>";  
  maskHtml += "<div class='panel-header panel=loading' style='position:absolute;cursor:wait;left:" + ((maskWidth / 2) - 100) + "px;top:" + (maskHeight / 2 - 50) + "px;width:150px!important;height:16px;";  
  maskHtml += "padding:10px 5px 10px 30px;font-size:12px;border:1px solid #ccc;background-color:white;border-radius: 4px;'>";  
  maskHtml += "页面加载中，请等待...";  
  maskHtml += "</div>";  
  maskHtml += "</div>";  
  $('body').append(maskHtml); 
  $('#maskLoading').fadeIn('fast'); 
}
function endMask() {
  $('#maskLoading').remove();
}
function deleteEduAnnex(id,obj) {
  console.log(id,obj);
  if (id) {
    $.messager.confirm($g("删除"), $g("确定删除此附件吗？"), function (r) {
      if (r) {
        startMask();
        $cm(
          {
            ClassName: "Nur.NIS.Service.Education2.Setting",
            MethodName: "DeleteEduAnnex",
            id: id,
            hospID: hospID,
          },
          function (data) {
            console.log(data);
            endMask();
            if (1 == data) {
              $.messager.popover({ msg: $g("删除成功！"), type: "success" });
              $(obj).parent().remove();
              updateModalPos("eduSubjectModal");
            } else {
              $.messager.popover({ msg: data.msg, type: "alert" });
            }
          }
        );
      }
    });
  } else {
    $(obj).parent().remove();
    updateModalPos("eduSubjectModal");
  }
}
function changepic(obj) {
  console.log($(obj));
  console.log($(obj)[0]);
  console.log(obj);
  console.log(obj.files);
  f = obj.files[0];
  console.log(f);
  $(obj).next().html(f.name).parent().show();
  updateModalPos("eduSubjectModal");
}
// 生成文件名，日期时间+随机字符串
function randomFilename(type) {
  var t = new Date();
  var dateTime =
    t.getFullYear().toString() +
    (t.getMonth() + 1).toString() +
    t.getDate().toString() +
    t.toString().split(" ")[4].slice(0, 8).replace(/:/g, "");
  return (
    dateTime + Math.random().toString(16).slice(2) + "." + type.split(".").pop()
  );
}
function addDaRow() {
  var editRTIndex = $("#daTable").datagrid("getRows").length;
  var row = {
    adviseDesc: "",
    id: "",
  };
  $("#daTable")
    .datagrid("insertRow", {
      row: row,
    })
    .datagrid("selectRow", editRTIndex);
  editDaRow(editRTIndex, row);
}
function editDaRow(curInd, row) {
  daObj = row;
  // 当双击另一行时，先保存正在编辑的行
  $("#daTable").datagrid("beginEdit", curInd);
  var timer = setInterval(function () {
    if (!daObj.id) {
      clearInterval(timer);
      var rowEditor = $("#daTable").datagrid("getEditors", curInd)[0];
      $(rowEditor.target).combobox("setValue", row.id);
    }
  }, 50);
}
function deleteDaRow(i) {
  console.log(i);
  $("#daTable").datagrid("deleteRow", i);
  $("#daTable")
    .datagrid("getRows")
    .map(function (e, j) {
      if (j < i) return;
      $("#daTable").datagrid("refreshRow", j);
    });
}
function addReRow() {
  var editRTIndex = $("#reTable").datagrid("getRows").length;
  var row = {
    desc: "",
    id: "",
  };
  $("#reTable")
    .datagrid("insertRow", {
      row: row,
    })
    .datagrid("selectRow", editRTIndex);
  editReRow(editRTIndex, row);
}
function editReRow(curInd, row) {
  reObj = row;
  // 当双击另一行时，先保存正在编辑的行
  $("#reTable").datagrid("beginEdit", curInd);
  var timer = setInterval(function () {
    if (!reObj.id) {
      clearInterval(timer);
      var rowEditor = $("#reTable").datagrid("getEditors", curInd)[0];
      $(rowEditor.target).combobox("setValue", row.id);
    }
  }, 50);
}
function deleteReRow(i) {
  console.log(i);
  $("#reTable").datagrid("deleteRow", i);
  $("#reTable")
    .datagrid("getRows")
    .map(function (e, j) {
      if (j < i) return;
      $("#reTable").datagrid("refreshRow", j);
    });
}
function addAsRow() {
  var editRTIndex = $("#assessTable").datagrid("getRows").length;
  var row = {
    relationAssess: "",
    formula: "",
    effectFirst: "",
    tplDate: "",
    id: "",
  };
  $("#assessTable")
    .datagrid("insertRow", {
      row: row,
    })
    .datagrid("selectRow", editRTIndex);
  editAsRow(editRTIndex, row);
}
function editAsRow(curInd, row) {
  asObj = row;
  // 当双击另一行时，先保存正在编辑的行
  $("#assessTable").datagrid("beginEdit", curInd);
  $('tr.relateAssess td[field="formula"] input[type="text"]').attr(
    "placeholder",
    $g("Itemx评估值，举例(Item5>4)&&(Item6<6)")
  );
  var timer = setInterval(function () {
    console.log(asObj.id);
    console.log(row.id);
    if (!asObj.id) {
      clearInterval(timer);
      var rowEditor = $("#assessTable").datagrid("getEditors", curInd)[0];
      $(rowEditor.target).combobox("setValue", row.id);
    }
  }, 50);
}
function deleteAsRow(i) {
  $("#assessTable").datagrid("deleteRow", i);
  $("#assessTable")
    .datagrid("getRows")
    .map(function (e, j) {
      if (j < i) return;
      $("#assessTable").datagrid("refreshRow", j);
    });
}
function addDgRow() {
  var editRTIndex = $("#diagnoseTable").datagrid("getRows").length;
  var row = {
    desc: "",
    id: "",
  };
  $("#diagnoseTable")
    .datagrid("insertRow", {
      row: row,
    })
    .datagrid("selectRow", editRTIndex);
  editDgRow(editRTIndex, row);
}
function editDgRow(curInd, row) {
  dgObj = row;
  // 当双击另一行时，先保存正在编辑的行
  $("#diagnoseTable").datagrid("beginEdit", curInd);
  var timer = setInterval(function () {
    if (!dgObj.id) {
      clearInterval(timer);
      var rowEditor = $("#diagnoseTable").datagrid("getEditors", curInd)[0];
      $(rowEditor.target).combobox("setValue", row.id);
    }
  }, 50);
}
function deleteDgRow(i) {
  console.log(i);
  $("#diagnoseTable").datagrid("deleteRow", i);
  $("#diagnoseTable")
    .datagrid("getRows")
    .map(function (e, j) {
      if (j < i) return;
      $("#diagnoseTable").datagrid("refreshRow", j);
    });
}
function addOpeRow() {
  var editRTIndex = $("#operateTable").datagrid("getRows").length;
  var row = {
    desc: "",
    id: "",
  };
  $("#operateTable")
    .datagrid("insertRow", {
      row: row,
    })
    .datagrid("selectRow", editRTIndex);
  editOpeRow(editRTIndex, row);
}
function editOpeRow(curInd, row) {
  opObj = row;
  // 当双击另一行时，先保存正在编辑的行
  $("#operateTable").datagrid("beginEdit", curInd);
  var timer = setInterval(function () {
    if (!opObj.id) {
      clearInterval(timer);
      var rowEditor = $("#operateTable").datagrid("getEditors", curInd)[0];
      $(rowEditor.target).combobox("setValue", row.id);
    }
  }, 50);
}
function deleteOpeRow(i) {
  console.log(i);
  $("#operateTable").datagrid("deleteRow", i);
  $("#operateTable")
    .datagrid("getRows")
    .map(function (e, j) {
      if (j < i) return;
      $("#operateTable").datagrid("refreshRow", j);
    });
}
function addITRow() {
  var editRTIndex = $("#itemsTable").datagrid("getRows").length;
  var row = {
    desc: "",
    id: "",
  };
  $("#itemsTable")
    .datagrid("insertRow", {
      row: row,
    })
    .datagrid("selectRow", editRTIndex);
  editITRow(editRTIndex, row);
}
function editITRow(curInd, row) {
  itObj = row;
  // 当双击另一行时，先保存正在编辑的行
  $("#itemsTable").datagrid("beginEdit", curInd);
  var timer = setInterval(function () {
    if (!itObj.id) {
      clearInterval(timer);
      var rowEditor = $("#itemsTable").datagrid("getEditors", curInd)[0];
      $(rowEditor.target).combobox("setValue", row.id);
    }
  }, 50);
}
function deleteITRow(i) {
  console.log(i);
  $("#itemsTable").datagrid("deleteRow", i);
  $("#itemsTable")
    .datagrid("getRows")
    .map(function (e, j) {
      if (j < i) return;
      $("#itemsTable").datagrid("refreshRow", j);
    });
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
function filterTreeNodes(nodes, id, searchText) {
  for (var i = 0; i < nodes.length; i++) {
    if (!nodes[i].target) {
      nodes[i].target = $("#" + id).tree("find", nodes[i].id).target;
    }
    if (
      nodes[i].text.indexOf(searchText) > -1 ||
      getPinyin(nodes[i].text).toUpperCase().indexOf(searchText.toUpperCase()) >
        -1
    ) {
      $(nodes[i].target)
        .parent()
        .show()
        .addClass("showNode")
        .prevAll(".showNode")
        .removeClass("showNode");
      if (nodes[i].children) {
        showChildNodes(nodes[i].children, id);
      }
    } else {
      if (checkChildHas(nodes[i], searchText)) {
        $(nodes[i].target)
          .parent()
          .show()
          .addClass("showNode")
          .prevAll(".showNode")
          .removeClass("showNode");
        filterTreeNodes(nodes[i].children, id, searchText);
      } else {
        $(nodes[i].target).parent().hide().removeClass("showNode");
      }
    }
  }
}
function checkChildHas(node, searchText) {
  var children = node.children,
    flag = false;
  if (children) {
    for (var i = 0; i < children.length; i++) {
      if (
        children[i].text.indexOf(searchText) > -1 ||
        getPinyin(children[i].text)
          .toUpperCase()
          .indexOf(searchText.toUpperCase()) > -1
      ) {
        return true;
      } else {
        flag = checkChildHas(children[i], searchText);
        if (flag) {
          return true;
        }
      }
    }
  }
  return false;
}
function showChildNodes(nodes, id) {
  for (var i = 0; i < nodes.length; i++) {
    if (!nodes[i].target) {
      nodes[i].target = $("#" + id).tree("find", nodes[i].id).target;
    }
    $(nodes[i].target)
      .parent()
      .show()
      .addClass("showNode")
      .prevAll(".showNode")
      .removeClass("showNode");
    if (nodes[i].children) {
      showChildNodes(nodes[i].children, id);
    }
  }
}
function filterEdusubject() {
  // 过滤宣教主题
  var searchText = $("#edusubjectInput").val();
  var roots = $("#edusubjectTree").tree("getRoots");
  filterTreeNodes(roots, "edusubjectTree", searchText);
}
function filterEduQuote() {
  // 过滤引用宣教主题
  var searchText = $("#eduQuoteInput").val();
  var roots = $("#eduQuoteTree").tree("getRoots");
  filterTreeNodes(roots, "eduQuoteTree", searchText);
}
function clearTreeNodeSearch() {
  //显示所有结点
  var root = $("#edusubjectTree").tree("getRoot");
  var nodes = $("#edusubjectTree").tree("getChildren", root.target);
  for (var i = 0; i < nodes.length; i++) {
    $(nodes[i].target).parents("li:eq(0)").css("display", "");
  }
}
// 获取评价树形结构数据
function getEdusubjectTreeData() {
  $cm(
    {
      ClassName: "Nur.NIS.Service.Education2.Setting",
      MethodName: "GetEduSubjectList",
      WardId: session["LOGON.WARDID"],
      StartFlag: "",
      hospDR: hospID,
    },
    function (data) {
      var pid = { 0: [] };
      data.map(function (e, i) {
				data[i].annex=e.annex||[];
        e.text = e.desc;
        if (
          new Date(standardizeDate(e.startDate)).valueOf() >=
          new Date().valueOf()
        ) {
          e.iconCls = "icon-unuse";
        } else if (
          !e.stopDate ||
          new Date(standardizeDate(e.stopDate)).valueOf() > new Date().valueOf()
        ) {
          e.iconCls = "icon-accept";
        } else {
          e.iconCls = "icon-unuse";
        }
        if (pid[e.pid]) {
          pid[e.pid].push(e);
        } else {
          pid[e.pid] = [e];
        }
      });
      pid[0].sort(function (a, b) {
        return parseInt(a.sortNo) - parseInt(b.sortNo);
      });
      var keys=Object.keys(pid);
      keys.map(function (k) {
        pid[k].map(function (e, i) {
          if (pid[e.id]) {
            pid[e.id].sort(function (a, b) {
              return parseInt(a.sortNo) - parseInt(b.sortNo);
            });
            pid[k][i].children = pid[e.id];
          }
        });
      });
      var ctlocDesc = translateWard||session["LOGON.CTLOCDESC"] || $g("护理部");
      $("#edusubjectTree").tree({
        lines: true,
        formatter: function (node) {
          var s = node.text;
          if (node.relateType) {
            s += '<a class="icon icon-barbell"></a>';
          }
          if (node.annex&&node.annex.length) {
            s += '<a class="icon icon-attachment"></a>';
          }
          return s;
        },
        onContextMenu: function (e, node) {
          console.log(e,node);
          contextNode = node;
          e.preventDefault();
          var n = 1;
          if (0 == node.id) {
            $("#mm1,#mm2,#mm4").show();
            $("#mm3,#mm5").hide();
          } else if (1 != node.leafFlag) {
            $("#mm1,#mm2,#mm3,#mm4,#mm5").show();
            n = 5;
          } else {
            $("#mm1,#mm2,#mm4").hide();
            $("#mm3,#mm5").show();
            n = 2;
          }
          $("#mm")
            .css({
              left: e.pageX,
              top: Math.min(e.clientY, window.innerHeight - 31 * n) + "px",
              // top: e.pageY
            })
            .show();
        },
        data: [
          {
            id: "0",
            text: ctlocDesc,
            iconCls: "icon-accept",
            state: "open",
            children: pid[0],
          },
        ],
        onClick: function (node) {
          console.log(node);
          $("#mm").hide();
          clickNode = node;
          if ((1 == node.leafFlag) || !node.children || !node.children.length) {
            $("#newEduContent").linkbutton("enable");
            getEduContents();
          } else {
            $("#newEduContent").linkbutton("disable");
          }
        },
      });
      if (0==tplTreeFlodFlag) {
        $("#toggleFold").click();
        tplTreeFlodFlag=2;
      }
      if (sortFlag) {
        var node = $("#edusubjectTree").tree("find", sortPid);
        console.log(node);
        if (node) {
          contextNode = node;
          menuHandler(4);
        } else {
          $("#contentTable").datagrid("loadData", { rows: [] });
        }
      }
    }
  );
}
// 设置日期选择框禁用值
function setDateboxOption() {
  var startDate = $("#startDate").datebox("getValue"),
    stopDate = $("#stopDate").datebox("getValue");
  var startOpt = $("#startDate").datebox("options"),
    stopOpt = $("#stopDate").datebox("options");
  if (startDate) stopOpt.minDate = startDate;
  if (stopDate) startOpt.maxDate = stopDate;
}
function setContentDateOption() {
  var contentStartDate = $("#contentStartDate").datebox("getValue"),
    contentStopDate = $("#contentStopDate").datebox("getValue");
  var startOpt = $("#contentStartDate").datebox("options"),
    stopOpt = $("#contentStopDate").datebox("options");
  if (contentStartDate) stopOpt.minDate = contentStartDate;
  if (contentStopDate) startOpt.maxDate = contentStopDate;
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
function getQuoteSubject(item) {
  console.log(arguments);
  var id = "",
    desc = $g("护理部");
  if (item) {
    id = -1==item.wardid?"":item.wardid;
    desc = item.warddesc;
  }
  $cm(
    {
      ClassName: "Nur.NIS.Service.Education2.Setting",
      MethodName: "GetEduSubjectList",
      WardId: id,
      StartFlag: -1,
    },
    function (data) {
      var pid = { 0: [] };
      data.map(function (e, i) {
				data[i].annex=e.annex||[];
        e.text = e.desc;
        e.iconCls = "hideTreeIcon";
        if (0 == e.pid) {
          e.children = [];
        }
        if (pid[e.pid]) {
          pid[e.pid].push(e);
        } else {
          pid[e.pid] = [e];
        }
      });
      pid[0].sort(function (a, b) {
        return parseInt(a.sortNo) - parseInt(b.sortNo);
      });
      var keys=Object.keys(pid);
      keys.map(function (k) {
        pid[k].map(function (e, i) {
          if (pid[e.id]) {
            pid[e.id].sort(function (a, b) {
              return parseInt(a.sortNo) - parseInt(b.sortNo);
            });
            pid[k][i].children = pid[e.id];
          }
        });
      });
      $("#eduQuoteTree").tree({
        lines: true,
        formatter: function (node) {
          var s = node.text;
          if (node.relateType) {
            s += '<a class="icon icon-barbell"></a>';
          }
          if (node.annex&&node.annex.length) {
            s += '<a class="icon icon-attachment"></a>';
          }
          return s;
        },
        data: [
          {
            id: "0",
            text: desc,
            state: "open",
            iconCls: "hideTreeIcon",
            children: pid[0],
          },
        ],
        checkbox: true,
        onClick: function (node) {
          var flag = node.checked ? "uncheck" : "check";
          $("#eduQuoteTree").tree(flag, node.target);
        },
        onCheck: function (node) {
          console.log(node);
          var nodes = $("#eduQuoteTree").tree("getChecked");
          console.log(nodes);
          var ids = [];
          nodes.map(function (e) {
            if (e.pid > 0) ids.push(e.id);
          });
          getEduContentsByIds(ids);
        },
      });
      if (0==quoteTreeFlodFlag){
        $("#quoteToggleFold").click();
        if ($("#eduQuoteInput+a .icon-indentation").length) {
          $("#quoteToggleFold").click();
        }
      }
    }
  );
}
function menuHandler(flag) {
  $("#mm").hide();
  if (2 == flag) {
    updateModalPos("eduQuoteModal");
    var inputWidth =
      $("#eduQuoteInput").parent().width() - $("#eduQuoteInput+a").width() - $("#eduQuoteInput+a+a").width() - 21;
    $("#eduQuoteInput").css("width", inputWidth + "px");
    var hospWidth =
      $("#wardDesc").parent().width() - $("#wardDesc").width() - 21;
    $("#ward").combobox({
      width: hospWidth,
    });
    $("#ward").combobox('setValue',-1);
    getQuoteSubject();
    // console.log($("#eduQuoteModal #ardsTree>.panel").height());
    $("#quoteTable").datagrid("resize", {
      height: $("#eduQuoteModal #ardsTree>.panel").height()-0.5,
    });
    updateModalPos("eduQuoteModal");
    return;
  }
  if (4 == flag) {
    if (!contextNode.children || !contextNode.children.length) return;
    sortPid = contextNode.id;
    var columns = [
      [
        { title: $g("宣教主题"), field: "desc", width: 600 },
        {
          title: $g("状态"),
          field: "status",
          width: 50,
          formatter: function (value, row, i) {
            var c = "icon-accept" == row.iconCls ? "green" : "red";
            var d = "icon-accept" == row.iconCls ? $g("启用") : $g("停用");
            return "<span style='color:" + c + ";'>" + d + "</span>";
          },
        },
      ],
    ];
    $("#contentTable").datagrid({
      title: $g("宣教主题排序"),
      rownumbers: true,
      singleSelect: true,
      headerCls: "panel-header-gray",
      iconCls: "icon-target-arrow",
      autoSizeColumn: false,
      fitColumns: true,
      pagination: false,
      columns: columns,
      width: "100%",
      data: contextNode.children,
      toolbar: [
        {
          iconCls: "icon-add",
          text: $g("新增"),
          id: "newEduContent",
          disabled: true,
          handler: addContentRow,
        },
      ],
      onDrop: dropContentRow,
      onLoadSuccess: function () {
        $(this).datagrid("enableDnd");
        resizeTableHeight();
      },
    });
    sortFlag = true;
    resizeTableHeight();
    if (firstFlag) {
      firstFlag=false;
      menuHandler(4);
    }
    return;
  }
  if (5 == flag) {
    $.messager.confirm("删除", "确定要删除该宣教主题?", function (r) {
      if (r) {
        $cm(
          {
            ClassName: "Nur.NIS.Service.Education2.Setting",
            MethodName: "DeleteEduSubject",
            id: contextNode.id,
          },
          function (res) {
            console.log(res);
            if (0 == res) {
              $.messager.popover({ msg: "删除成功！", type: "success" });
              getEdusubjectTreeData();
              if (!sortFlag) {
                $('#contentTable').datagrid('loadData',{total:0,rows:[]});
                $("#newEduContent").linkbutton("disable");
              }
            } else {
              $.messager.popover({ msg: res, type: "alert" });
              return false;
            }
          }
        );
      }
    });
    // resizeTableHeight()
    return;
  }
  var title = $g("新增宣教主题维护");
  $("#bwForm").form("reset");
  $("#id").val("");
  $("#wardRange").val(translateWard||session["LOGON.CTLOCDESC"] || $g("护理部"));
  $("#bwForm").form("disableValidation");
  $("tr.applyRange").nextUntil("tr.date").hide();
  $("#startDate").datebox("setValue", formatDate(new Date()));
  if (1 == contextNode.leafFlag) {
    $("tr.applyPeople,tr.applySex,tr.relateType,tr.educationCover,tr.appendix").show();
  }
  // $('#daTable,#reTable,#assessTable,#diagnoseTable').datagrid("loadData", {total:0,rows:[]}); //清空
  $("#daTable").datagrid("loadData", { total: 0, rows: [] }); //清空
  $("#reTable").datagrid("loadData", { total: 0, rows: [] }); //清空
  $("#assessTable").datagrid("loadData", { total: 0, rows: [] }); //清空
  $("#diagnoseTable").datagrid("loadData", { total: 0, rows: [] }); //清空
  $("#operateTable").datagrid("loadData", { total: 0, rows: [] }); //清空
  $("#itemsTable").datagrid("loadData", { total: 0, rows: [] }); //清空
  if (3 == flag) {
    title = $g("修改宣教主题维护");
    $("#id").val(contextNode.id);
    $("#subject").val(contextNode.desc);
    $("#startDate").datebox("setValue", contextNode.startDate);
    $("#stopDate").datebox("setValue", contextNode.stopDate);
    $("#applyPeople").combobox("setValue", contextNode.applyPeople||0)
		$("input[name='applySex'][value='"+contextNode.applySex+"']").radio('setValue', true);
    var $p = $("#attachFiles>div");
    $p.empty();
    contextNode.annex.map(function(a) {
      // var url="../../../dhccftp/nurseftp/"+a.url;
      var url="https://"+ftpIP+":1443/dhccftp/nurseftp/"+a.url;
      $p.append('<div><span style="cursor:pointer;" ondblclick="exhibitAnnex(\''+url+'\',\''+a.name+'\')">'+a.name+'</span><span class="l-btn-icon icon-cancel" onclick="deleteEduAnnex('+a.id+',this)">&nbsp;</span></div>');  
    })
    if (contextNode.pid > 0) {
      var relateType = contextNode.relateType;
      $("input[name='relateType'][value='" + relateType + "']").radio(
        "setValue",
        true
      );
      switch (parseInt(relateType)) {
        case 1:
          var docAdviceIds = contextNode.relateData || [];
          if (docAdviceIds.length) {
            var url =
              "nurse.restful.csp?url=select/getDynamicData&p1=Nur.NIS.Service.TaskOverview.Normal&p2=GetDocAdvice&p3=100&p4=" +
              docAdviceIds.join("^") +
              "&p5=&p6=" +
              hospID;
            $.post(url, function (data) {
              data = JSON.parse(data);
              data.map(function (e, i) {
                $("#daTable").datagrid("insertRow", {
                  row: {
                    id: e.id,
                    adviseDesc: e.desc,
                  },
                });
              });
            });
          }
          break;
        case 2:
          var eventIds = contextNode.relateData || [];
          if (eventIds.length) {
            var url =
              "nurse.restful.csp?url=select/getDynamicData&p1=Nur.NIS.Service.TaskOverview.Normal&p2=GetEventType&p3=100&p4=" +
              eventIds.join("^") +
              "&p5=&p6=" +
              hospID;
            $.post(url, function (data) {
              data = JSON.parse(data);
              data.map(function (e, i) {
                $("#reTable").datagrid("insertRow", {
                  row: {
                    id: e.id,
                    desc: e.desc,
                  },
                });
              });
            });
          }
          break;
        case 3:
          var assess = contextNode.relateData || [];
          console.log(assess);
          if (assess.length) {
            var pairObj = {},
              idString = "";
            assess.map(function (e) {
              idString += e[0] + "^";
              pairObj[e[0]] = [e[1], e[2], (e.length>2)?e[e.length-1]:''];
            });
            var url =
              "nurse.restful.csp?url=select/getDynamicData&p1=Nur.NIS.Service.TaskOverview.Normal&p2=GetAssessItems&p3=100&p4=" +
              idString.slice(0, -1) +
              "&p5=&p6=" +
              session["LOGON.CTLOCID"];
            $.post(url, function (data) {
              data = JSON.parse(data);
              data.map(function (e, i) {
                $("#assessTable").datagrid("insertRow", {
                  row: {
                    id: e.id,
                    relationAssess: e.desc,
                    formula: pairObj[e.id][0],
                    effectFirst: pairObj[e.id][1],
                    tplDate: pairObj[e.id][2],
                  },
                });
              });
            });
          }
          break;
        case 4:
          var diagnoseIds = contextNode.relateData || [];
          if (diagnoseIds.length) {
            var url =
              "nurse.restful.csp?url=select/getDynamicData&p1=Nur.NIS.Service.Education2.Setting&p2=GetDiagnosisList&p3=100&p4=" +
              diagnoseIds.join("^") +
              "&p5=&p6=" +
              hospID;
            $.post(url, function (data) {
              data = JSON.parse(data);
              data.map(function (e, i) {
                $("#diagnoseTable").datagrid("insertRow", {
                  row: {
                    id: e.id,
                    desc: e.desc,
                  },
                });
              });
            });
          }
          break;
        case 5:
          $(".specialMethod").combobox("setValues", contextNode.relateData);
          break;
        case 6:
          var operateIds = contextNode.relateData || [];
          if (operateIds.length) {
            var url =
              "nurse.restful.csp?url=select/getDynamicData&p1=Nur.NIS.Service.Education2.Setting&p2=GetOperateList&p3=100&p4=" +
              operateIds.join("^") +
              "&p5=&p6=" +
              hospID;
            $.post(url, function (data) {
              data = JSON.parse(data);
              data.map(function (e, i) {
                $("#operateTable").datagrid("insertRow", {
                  row: {
                    id: e.id,
                    desc: e.desc,
                  },
                });
              });
            });
          }
          break;
        case 7:
          var itemIds = contextNode.relateData || [];
          if (itemIds.length) {
            var url =
              "nurse.restful.csp?url=select/getDynamicData&p1=Nur.NIS.Service.TaskOverview.Normal&p2=GetDocAdvice&p3=100&p4=" +
              itemIds.join("^") +
              "&p5=&p6=" + hospID+ "&p7=LS";
            $.post(url, function (data) {
              data = JSON.parse(data);
              data.map(function (e, i) {
                $("#itemsTable").datagrid("insertRow", {
                  row: {
                    id: e.id,
                    desc: e.desc,
                  },
                });
              });
            });
          }
          break;
        default:
          break;
      }
    }
  }
  $("#mm").hide();
	$("#eduSubjectModal").dialog({
	  onClose: getEdusubjectTreeData
	});
  updateModalPos("eduSubjectModal");
  $HUI.dialog("#eduSubjectModal").setTitle(title);
}
// 展示附件
function exhibitAnnex(url, name) {
  var names=name.split('.');
  var suffix=names[names.length-1];
  if (['txt','pdf','html','png','jpeg','svg','js','css','gif','jpg'].indexOf(suffix)>-1) {
    window.open(url,name,'width=1440,height=900');
  } else {
    var a='<a class="downloadAnnex" href="'+url+'" download="'+name+'">点击下载</a>';
    $('body').append(a);
    $('.downloadAnnex')[0].click();
    $('.downloadAnnex').remove();
  }
}
// 切换显示关联类型
function toggleRelateType(e, flag) {
  if (flag) {
    switch (parseInt(e.target.value)) {
      case 1:
        $("tr.relateOrders").show();
        break;
      case 2:
        $("tr.relateEvents").show();
        break;
      case 3:
        $("tr.relateAssess").show();
        break;
      case 4:
        $("tr.relateDiagnose").show();
        break;
      case 5:
        $("tr.unusualMethod").show();
        break;
      case 6:
        $("tr.operateName").show();
        break;
      case 7:
        $("tr.itemName").show();
        break;
    }
  } else {
    switch (parseInt(e.target.value)) {
      case 1:
        $("tr.relateOrders").hide();
        break;
      case 2:
        $("tr.relateEvents").hide();
        break;
      case 3:
        $("tr.relateAssess").hide();
        break;
      case 4:
        $("tr.relateDiagnose").hide();
        break;
      case 5:
        $("tr.unusualMethod").hide();
        break;
      case 6:
        $("tr.operateName").hide();
        break;
      case 7:
        $("tr.itemName").hide();
        break;
    }
  }
  updateModalPos("eduSubjectModal");
}
document.addEventListener("click", function () {
  $("#mm").hide();
});
function getEduContents() {
  sortFlag = false;
  // 获取宣教内容列表
  $cm(
    {
      ClassName: "Nur.NIS.Service.Education2.Setting",
      QueryName: "GetEduContentList",
      page: 1,
      pageSize: 99999,
      wardId: session["LOGON.WARDID"],
      subjectId: clickNode.id,
    },
    function (res) {
      console.log(res);
      res.rows.sort(function (a, b) {
        return a.sortNo - b.sortNo;
      });
      // $('#contentTable').datagrid('loadData',res)
      var columns = [
        [
          { title: $g("宣教内容"), field: "content", width: 600 },
          { title: $g("排序"), field: "sortNo", width: 50 },
          {
            title: $g("状态"),
            field: "status",
            width: 50,
            formatter: function (value, row, i) {
              var c = 1 == value ? "green" : "red";
              var d = 1 == value ? $g("启用") : $g("停用");
              return "<span style='color:" + c + ";'>" + d + "</span>";
            },
          },
        ],
      ];
      $("#contentTable").datagrid({
        title: $g("宣教内容维护"),
        singleSelect: true,
        headerCls: "panel-header-gray",
        iconCls: "icon-target-arrow",
        autoSizeColumn: false,
        fitColumns: true,
        pagination: false,
        columns: columns,
        width: "100%",
        data: res.rows,
        toolbar: [
          {
            iconCls: "icon-add",
            text: $g("新增"),
            id: "newEduContent",
            disabled: true,
            handler: addContentRow,
          },
        ],
        onDblClickRow: editContentRow,
        onDrop: dropContentRow,
        onLoadSuccess: function () {
          $(this).datagrid("enableDnd");
        },
      });
      resizeTableHeight();
      $("#newEduContent").linkbutton("enable");
      if (firstFlag) {
        firstFlag=false;
        getEduContents();
      }
    }
  );
}
function updateEduMultiExeConfig() {
	if (!remindFlag) return;
  // 更新业务界面主题多选配置
  $cm({
      ClassName: "Nur.NIS.Service.Education2.Setting",
      MethodName: "UpdateEduMultiExeConfig",
      hospDR: hospID,
      add: $("#checkboxAdd").checkbox('getValue')?1:0,
      task: $("#checkboxTask").checkbox('getValue')?1:0,
    }, function (data) {
			if (0 == data) {
				$.messager.popover({ msg: $g("数据保存成功！"), type: "success" });
			} else {
				$.messager.popover({ msg: data, type: "alert" });
			}
    }
  );
}
function getEduMultiExeConfig() {
  // 获取业务界面主题多选配置
  $cm({
      ClassName: "Nur.NIS.Service.Education2.Setting",
      MethodName: "GetEduMultiExeConfig",
      hospDR: hospID,
    }, function (data) {
			remindFlag=false;
			$("#checkboxAdd").checkbox('setValue',1==data.add?true:false);
			$("#checkboxTask").checkbox('setValue',1==data.task?true:false);
			remindFlag=true;
    }
  );
}
function getEduContentsByIds(ids) {
  // 获取宣教内容列表
  $cm(
    {
      ClassName: "Nur.NIS.Service.Education2.Setting",
      MethodName: "GetEduContentsByIds",
      dataType: "text",
      subjectIds: JSON.stringify(ids),
    },
    function (res) {
      console.log(res);
      res = JSON.parse(res);
      var data = [],
        merges = [],
        n = 0;
      res.map(function (e, i) {
        if (!e.content || !e.content.length) return;
        var len = e.content.length;
        merges.push({
          index: n,
          rowspan: len,
        });
        n += len;
        e.content.map(function (c) {
          data.push({
            pid: e.pid,
            subjectId: e.subjectId,
            title: e.title,
            content: c,
          });
        });
      });
      $("#quoteTable").datagrid({
        data: {
          total: data.length,
          rows: data,
        },
        onLoadSuccess: function (data) {
          for (var i = 0; i < merges.length; i++) {
            $(this).datagrid("mergeCells", {
              index: merges[i].index,
              field: "title",
              rowspan: merges[i].rowspan,
            });
          }
        },
      });
      if (data.length) {
        $("#quoteContent").linkbutton("enable");
      } else {
        $("#quoteContent").linkbutton("disable");
      }
    }
  );
}
// 保存宣教主题
function addOrUpdateEducation2() {
  console.log($("#bwForm").form("validate"));
  $("#bwForm").form("enableValidation");
  if ($("#bwForm").form("validate")) {
    var id = $("#id").val();
    var parentId = id ? contextNode.pid : contextNode.id;
    var fd = new FormData();
    fd.append("ClassName", "CF.NUR.NIS.Education2");
    fd.append("MethodName", "AddOrUpdateEducation2");
    fd.append("id", id);
    fd.append("parentId", parentId);
    fd.append("subject", $("#subject").val());
    fd.append("startDate", $("#startDate").datebox("getValue"));
    fd.append("stopDate", $("#stopDate").datebox("getValue"));
    fd.append("applyPeople", $("#applyPeople").combobox("getValue"));
		if (!$('input[name="applySex"]:checked').length) return;
    fd.append("applySex", $('input[name="applySex"]:checked').val());
    fd.append("userId", session["LOGON.USERID"]);
    fd.append("locId", session["LOGON.CTLOCID"]);
    fd.append("wardId", session["LOGON.WARDID"]);
    fd.append("hospID", hospID);

    var relateType = $("input[name='relateType']:checked").val();
    var relateOrders = [];
    var relateEvents = [];
    var relateAssess = [];
    var relateDiagnose = [];
    var specialMethod = [];
    var operateName = [];
    var itemName = [];
    var checkFlag = false; //校验标识
    if (0 == parentId || !relateType) {
      fd.append("relateType", "");
    } else {
      fd.append("relateType", relateType);
      switch (parseInt(relateType)) {
        case 1:
          $("#daTable")
            .datagrid("getRows")
            .map(function (e, i) {
              var rowEditor = $("#daTable").datagrid("getEditors", i)[0];
              console.log(rowEditor);
              if (rowEditor) {
                var docAdviceDR = $(rowEditor.target).combobox("getValue");
              } else {
                var docAdviceDR = e.id;
              }
              if (!docAdviceDR) {
                checkFlag = true;
                return $.messager.popover({
                  msg: $g("医嘱项不能为空！"),
                  type: "alert",
                });
              }
              if (relateOrders.indexOf(docAdviceDR) > -1) {
                checkFlag = true;
                return $.messager.popover({
                  msg: $g("医嘱项不能有重复！"),
                  type: "alert",
                });
              }
              relateOrders.push(docAdviceDR);
            });
          if (!relateOrders.length) {
            checkFlag = true;
            return $.messager.popover({
              msg: $g("医嘱项不能为空！"),
              type: "alert",
            });
          }
          break;
        case 2:
          $("#reTable")
            .datagrid("getRows")
            .map(function (e, i) {
              var rowEditor = $("#reTable").datagrid("getEditors", i)[0];
              console.log(rowEditor);
              if (rowEditor) {
                var eventId = $(rowEditor.target).combobox("getValue");
              } else {
                var eventId = e.id;
              }
              if (!eventId) {
                checkFlag = true;
                return $.messager.popover({
                  msg: $g("事件不能为空！"),
                  type: "alert",
                });
              }
              if (relateEvents.indexOf(eventId) > -1) {
                checkFlag = true;
                return $.messager.popover({
                  msg: $g("事件不能有重复！"),
                  type: "alert",
                });
              }
              relateEvents.push(eventId);
            });
          if (!relateEvents.length) {
            checkFlag = true;
            return $.messager.popover({
              msg: $g("事件不能为空！"),
              type: "alert",
            });
          }
          break;
        case 3:
          $("#assessTable")
            .datagrid("getRows")
            .map(function (e, i) {
              var rowEditors = $("#assessTable").datagrid("getEditors", i);
              console.log(rowEditors);
              if (rowEditors[0]) {
                var assessId = $(rowEditors[0].target).combobox("getValue");
                var formula = $(rowEditors[1].target).val();
                var effectFirst = $(rowEditors[2].target).checkbox("getValue")
                  ? 1
                  : "";
                var tplDate = $(rowEditors[3].target).val();
              } else {
                var assessId = e.id;
                var formula = e.formula;
                var effectFirst = e.effectFirst;
                var tplDate = e.tplDate;
              }
              if (!assessId) {
                checkFlag = true;
                return $.messager.popover({
                  msg: $g("评估表不能为空！"),
                  type: "alert",
                });
              }
              if (!formula) {
                checkFlag = true;
                return $.messager.popover({
                  msg: $g("公式不能为空！"),
                  type: "alert",
                });
              }
              if (!tplDate) {
                checkFlag = true;
                return $.messager.popover({
                  msg: $g("日期不能为空！"),
                  type: "alert",
                });
              }
              relateAssess.push([assessId, formula, effectFirst,tplDate]);
            });
          if (!checkFlag&&!relateAssess.length) {
            checkFlag = true;
            return $.messager.popover({
              msg: $g("评估项不能为空！"),
              type: "alert",
            });
          }
          break;
        case 4:
          $("#diagnoseTable")
            .datagrid("getRows")
            .map(function (e, i) {
              var rowEditor = $("#diagnoseTable").datagrid("getEditors", i)[0];
              console.log(rowEditor);
              if (rowEditor) {
                var diagnoseId = $(rowEditor.target).combobox("getValue");
              } else {
                var diagnoseId = e.id;
              }
              if (!diagnoseId) {
                checkFlag = true;
                return $.messager.popover({
                  msg: $g("诊断不能为空！"),
                  type: "alert",
                });
              }
              if (relateDiagnose.indexOf(diagnoseId) > -1) {
                checkFlag = true;
                return $.messager.popover({
                  msg: $g("诊断不能有重复！"),
                  type: "alert",
                });
              }
              relateDiagnose.push(diagnoseId);
            });
          if (!relateDiagnose.length) {
            checkFlag = true;
            return $.messager.popover({
              msg: $g("诊断不能为空！"),
              type: "alert",
            });
          }
          break;
        case 5:
          specialMethod = $(".specialMethod").combobox("getValues");
          break;
        case 6:
          $("#operateTable")
            .datagrid("getRows")
            .map(function (e, i) {
              var rowEditor = $("#operateTable").datagrid("getEditors", i)[0];
              console.log(rowEditor);
              if (rowEditor) {
                var operateId = $(rowEditor.target).combobox("getValue");
              } else {
                var operateId = e.id;
              }
              if (!operateId) {
                checkFlag = true;
                return $.messager.popover({
                  msg: $g("手术不能为空！"),
                  type: "alert",
                });
              }
              if (operateName.indexOf(operateId) > -1) {
                checkFlag = true;
                return $.messager.popover({
                  msg: $g("手术不能有重复！"),
                  type: "alert",
                });
              }
              operateName.push(operateId);
            });
          if (!operateName.length) {
            checkFlag = true;
            return $.messager.popover({
              msg: $g("手术不能为空！"),
              type: "alert",
            });
          }
          break;
        case 7:
          $("#itemsTable")
            .datagrid("getRows")
            .map(function (e, i) {
              var rowEditor = $("#itemsTable").datagrid("getEditors", i)[0];
              console.log(rowEditor);
              if (rowEditor) {
                var itemId = $(rowEditor.target).combobox("getValue");
              } else {
                var itemId = e.id;
              }
              if (!itemId) {
                checkFlag = true;
                return $.messager.popover({
                  msg: $g("项目不能为空！"),
                  type: "alert",
                });
              }
              if (itemName.indexOf(itemId) > -1) {
                checkFlag = true;
                return $.messager.popover({
                  msg: $g("项目不能有重复！"),
                  type: "alert",
                });
              }
              itemName.push(itemId);
            });
          if (!itemName.length) {
            checkFlag = true;
            return $.messager.popover({
              msg: $g("项目不能为空！"),
              type: "alert",
            });
          }
          break;
        default:
          break;
      }
    }
    if (checkFlag) return;
    fd.append("relateOrders", JSON.stringify(relateOrders));
    fd.append("relateEvents", JSON.stringify(relateEvents));
    fd.append("relateAssess", JSON.stringify(relateAssess));
    fd.append("relateDiagnose", JSON.stringify(relateDiagnose));
    fd.append("specialMethod", JSON.stringify(specialMethod));
    fd.append("operateName", JSON.stringify(operateName));
    fd.append("itemName", JSON.stringify(itemName));

    var annexFiles=$(".annexFile")
    for (var i = 0; ; i++) {
      var annexFile=annexFiles[i];
      if (annexFile) {
        var file=annexFile.files[0];
        console.log(file);
        var fileName=randomFilename(file.name);
        console.log(fileName);
        if (file) {
          fd.append("FileStream", file, fileName);
          fd.append("FileNames", file.name);
          fd.append("FileSizes", file.size);
        }
      } else {
        break;
      }
    }
    startMask();
    $.ajax({
      type: "POST",
      url: "websys.Broker.cls",
      data: fd,
      processData: false, // 不会将 data 参数序列化字符串
      contentType: false, // 根据表单 input 提交的数据使用其默认的 contentType
      xhr: function () {
        var xhr = new window.XMLHttpRequest();
        xhr.upload.addEventListener(
          "progress",
          function (evt) {
            if (evt.lengthComputable) {
              var percentComplete = evt.loaded / evt.total;
              console.log("进度", percentComplete);
            }
          },
          false
        );
        return xhr;
      },
    })
      .success(function (res) {
        // 拿到提交的结果
        console.log(res);
        if (0 == res) {
          $.messager.popover({ msg: $g("数据保存成功！"), type: "success" });
          $HUI.dialog("#eduSubjectModal").close();
          getEdusubjectTreeData();
        } else {
          if ('string'==typeof res) {
            try {
              res=JSON.parse(res);
              res=res.msg;
            } catch(e) {}
          } else {
            res=res.msg;
          }
          $.messager.popover({ msg: res, type: "alert" });
        }
        endMask();
      })
      .error(function (err) {
        console.error(err);
        endMask();
      });
    return true;
  }
}
// 保存宣教内容
function addOrUpdateEducation2Content() {
  console.log($("#eduContentForm").form("validate"));
  $("#eduContentForm").form("enableValidation");
  if ($("#eduContentForm").form("validate")) {
    var id = $("#eduContentId").val();
    var content = $("#eduContent").val();
    if (content.length < 1)
      return $.messager.popover({ msg: $g("请填写宣教内容！"), type: "alert" });
    if (content.length > 20000)
      return $.messager.popover({
        msg: "宣教内容长度不大于20000！建议可拆分成多条宣教内容。",
        type: "alert",
      });
    var obj = {
      id: id,
      subjectId: clickNode.id,
      content: content,
      startDate: $("#contentStartDate").datebox("getValue"),
      stopDate: $("#contentStopDate").datebox("getValue"),
      userId: session["LOGON.USERID"],
      locId: session["LOGON.CTLOCID"],
    };
    $cm(
      {
        ClassName: "CF.NUR.NIS.Education2Sub",
        MethodName: "AddOrUpdateEducation2Content",
        dataType: "text",
        data: JSON.stringify(obj),
      },
      function (data) {
        if (0 == data) {
          $.messager.popover({ msg: $g("数据保存成功！"), type: "success" });
          $HUI.dialog("#eduContentModal").close();
          getEduContents();
          clickNode.leafFlag = 1;
        } else {
          $.messager.popover({ msg: data, type: "alert" });
        }
      }
    );
    return true;
  }
}
// 引用宣教内容
function quoteEduSubjectAndContent() {
  var rows = $("#quoteTable").datagrid("getRows"),
    subjectIds = [];
  rows.map(function (e) {
    if (subjectIds.indexOf(e.subjectId) < 0) {
      subjectIds.push(e.subjectId);
    }
  });
  $cm(
    {
      ClassName: "Nur.NIS.Service.Education2.Setting",
      MethodName: "QuoteEduSubjectAndContent",
      dataType: "text",
      parentId: contextNode.id,
      subjectIds: JSON.stringify(subjectIds),
      UserId: session["LOGON.USERID"],
      LocId: session["LOGON.CTLOCID"],
      WardId: session["LOGON.WARDID"],
      HospDR: hospID,
    },
    function (data) {
      if (0 == data) {
        $.messager.popover({ msg: $g("数据引入成功！"), type: "success" });
        $HUI.dialog("#eduQuoteModal").close();
        getEdusubjectTreeData();
      } else {
        $.messager.popover({ msg: data, type: "alert" });
      }
    }
  );
}
function addContentRow() {
  $("#eduContentForm").form("reset");
  $("#eduContentId").val("");
  $("#eduContentForm").form("disableValidation");
  $("#contentStartDate").datebox("setValue", formatDate(new Date()));
  updateModalPos("eduContentModal");
  $HUI.dialog("#eduContentModal").setTitle($g("新增宣教内容"));
}
function editContentRow(curInd, row) {
  if (sortFlag) return;
  addContentRow();
  $("#eduContentId").val(row.id);
  $("#eduContent").val(row.content);
  $("#contentStartDate").datebox("setValue", row.startDate);
  $("#contentStopDate").datebox("setValue", row.stopDate);
  $HUI.dialog("#eduContentModal").setTitle($g("修改宣教内容"));
}
// 拖动数据引入表格
function dropContentRow(target, source, point) {
  if (sortFlag) {
    console.log(arguments);
    var data = [];
    var tableData = $("#contentTable").datagrid("getData");
    tableData.rows.map(function (e, i) {
      data.push({
        id: e.id,
        sortNo: i + 1,
      });
    });
    console.log(data);
    $cm(
      {
        ClassName: "Nur.NIS.Service.Education2.Setting",
        MethodName: "UpdateEduSubjectSort",
        dataType: "text",
        data: JSON.stringify(data),
      },
      function (data) {
        if (0 == data) {
          getEdusubjectTreeData();
        } else {
          $.messager.popover({ msg: data, type: "alert" });
        }
      }
    );
    return;
  }
  var newSort = target.sortNo,
    oldSort = source.sortNo;
  if (newSort == oldSort) return;
  if (newSort > oldSort && "top" == point) {
    newSort--;
  }
  if (newSort < oldSort && "bottom" == point) {
    newSort++;
  }
  if (newSort == oldSort) return;
  var obj = {
    id: source.id,
    subjectId: clickNode.id,
    oldSort: oldSort,
    newSort: newSort,
  };
  $cm(
    {
      ClassName: "Nur.NIS.Service.Education2.Setting",
      MethodName: "UpdateEduContentSort",
      dataType: "text",
      userId: session["LOGON.USERID"],
      data: JSON.stringify(obj),
    },
    function (data) {
      if (0 == data) {
        getEduContents();
      } else {
        $.messager.popover({ msg: data, type: "alert" });
      }
    }
  );
}
function resizeTableHeight() {
  var innerHeight = window.innerHeight;
  $("#edusubjectTree")
    .parent()
    .css("height", innerHeight - ('lite'==HISUIStyleCode?210:214) + "px");
  setTimeout(function() {
    $("#contentTable").datagrid("resize", {
      height: innerHeight - 56,
      width: "100%"
    });
  }, 300);
  var inputWidth =
    $("#edusubjectInput").parent().width() -
    $("#edusubjectInput+a").width() -
    $("#edusubjectInput+a+a").width() -
    21;
  $("#edusubjectInput").css("width", inputWidth + "px");
	// if ('lite'==HISUIStyleCode) { //极简
	// 	$('.eduExeStyle').append('#edusubjectInput {width: 307px !important;height: 26px;}');
	// } else {
	// 	$('.eduExeStyle').append('#edusubjectInput {width: 283px !important;height: 30px;}');
	// }
  var hospWidth =
    $("#_HospListLabel").parent().width() - $("#_HospListLabel").width() - 21;
  $("#_HospList").combogrid({
    width: hospWidth,
    panelWidth: hospWidth,
    disabled: true,
  });
  $('#eduSetTab').tabs({
    // width: $("#tt").parent().width(),
    height: innerHeight - 10,
  });
}
setTimeout(resizeTableHeight, 100);
window.addEventListener("resize", resizeTableHeight);
