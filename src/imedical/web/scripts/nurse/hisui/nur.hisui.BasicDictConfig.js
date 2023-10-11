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
var hospID,
  wardsData = [];
var selectESIndex,
  editESIndex,
  esTableData = { total: 0, rows: [] };
var selectADIndex,
  editADIndex,
  adTableData = { total: 0, rows: [] };
var page = 1, pageSize = 20, pageSub = 1, pageSubSize = 20,
  saveFlag = true;
$(function () {
  // if (parseInt(multiFlag)) {
  hospComp = GenHospComp(
    "Nur_IP_BasicDict",
    session["LOGON.USERID"] +
      "^" +
      session["LOGON.GROUPID"] +
      "^" +
      session["LOGON.CTLOCID"] +
      "^" +
      session["LOGON.HOSPID"]
  );
  ///var hospComp = GenHospComp("ARC_ItemCat")
  // console.log(hospComp.getValue());     //获取下拉框的值
  hospID = hospComp.getValue();
  hospComp.options().onSelect = function (i, d) {
    // 	HOSPDesc: "东华标准版数字化医院[总院]"
    // HOSPRowId: "2"
    console.log(arguments);
    hospID = d.HOSPRowId;
    getESTableData();
  }; ///选中事件
  // } else {
  // 	hospID=session['LOGON.HOSPID'];
  // }
  console.log(hospID);
  getESTableData();
});
function getESTableData() {
  saveFlag = false;
  // 获取放化疗评价系统数据
  $cm(
    {
      ClassName: "Nur.NIS.Service.BasicDict.Config",
      QueryName: "GetBasicDict",
      page: page,
      rows: pageSize,
      keyword: $("#evaluateInput").searchbox("getValue"),
      hospDR: hospID,
    },
    function (data) {
      $("#evaluateSystem")
        .datagrid("loadData", data)
        .datagrid("getPager")
        .pagination({
          onSelectPage: function (p, size) {
            page = p;
            pageSize = size;
            if (saveFlag) {
              getESTableData();
            } else {
              saveFlag = true;
            }
          },
          onRefresh: function (p, size) {
            page = p;
            pageSize = size;
            getESTableData();
          },
          onChangePageSize: function (size) {
            page = 1;
            pageSize = size;
            getESTableData();
          },
        })
        .pagination("select", page);
			getADRsTableData();
    }
  );
}
// 过滤病区
function filterEvaluate() {
  page = 1;
  getESTableData();
}
function selectESRow(curInd, row) {
  selectESIndex = curInd;
  $("#evaluateSystem").datagrid("selectRow", curInd);
  getADRsTableData(row.id);
  // editCSIndex=undefined;
  // selectCSIndex=undefined;
}
function editESRow(curInd, row) {
  // 当双击另一行时，先保存正在编辑的行
  if (undefined != editESIndex && editESIndex != curInd && !saveESRow()) return;
  editESIndex = curInd;
  $("#evaluateSystem").datagrid("beginEdit", editESIndex);
}
function addESRow() {
  if (undefined != editESIndex && !saveESRow()) return;
  editESIndex = $("#evaluateSystem").datagrid("getRows").length;
  var row = {
    num: editESIndex + 1,
    sysCode: "",
    sysDesc: "",
    id: "",
  };
  $("#evaluateSystem")
    .datagrid("insertRow", {
      row: row,
    })
    .datagrid("selectRow", editESIndex);
  selectESIndex = editESIndex;
  editESRow(editESIndex, row);
  // esTableData.rows.push(row)
}
function saveESRow() {
  if (undefined == editESIndex) {
    return $.messager.popover({ msg: "无需要保存的项！", type: "alert" });
  }
  var index = $("#evaluateSystem").datagrid("getEditingRowIndexs")[0];
  if (undefined === index) return true;
  var curRow = $("#evaluateSystem").datagrid("getRows")[index];
  var rowEditors = $("#evaluateSystem").datagrid("getEditors", editESIndex);
  var id = curRow.id || "";
  var bdCode = $(rowEditors[0].target).val();
  var bdDesc = $(rowEditors[1].target).val();
  if (!bdCode || !bdDesc) {
    $.messager.popover({ msg: "请填写代码和描述！", type: "alert" });
    return false;
  }
  if (bdCode.length > 50 || bdDesc.length > 50) {
    $.messager.popover({ msg: "代码和描述长度不大于50字！", type: "alert" });
    return false;
  }

  var data = {
    id: id,
    bdCode: bdCode,
    bdDesc: bdDesc,
    hospDR: hospID,
  };
  var updateRow = editESIndex;
  var res = $cm(
    {
      ClassName: "Nur.NIS.Service.BasicDict.Config",
      MethodName: "AddOrUpdateBasicDict",
      dataType: "text",
      data: JSON.stringify(data),
    },
    false
  );
  console.log(res);
  if (res >= 0) {
    $.messager.popover({ msg: "保存成功！", type: "success" });
    getESTableData();
    return true;
  } else {
    $.messager.popover({ msg: res, type: "alert" });
    return false;
  }
}
function deleteESRow() {
  var esObj = $("#evaluateSystem");
  var row = esObj.datagrid("getSelected");
  if (row) {
    $.messager.confirm("删除", "确定要删除选中的数据?", function (r) {
      if (r) {
        if (row.id) {
          var res = $cm(
            {
              ClassName: "Nur.NIS.Service.BasicDict.Config",
              MethodName: "DeleteBasicDict",
              ID: row.id,
            },
            false
          );
          console.log(res);
          if (0 == res) {
            $.messager.popover({ msg: "删除成功！", type: "success" });
            esTableData.rows.map(function (elem, index) {
              if (row.id == elem.id) {
                esTableData.rows.splice(index, 1);
              }
            });
            filterEvaluate();
          } else {
            $.messager.popover({ msg: JSON.stringify(res), type: "alert" });
            return false;
          }
        } else {
          var curInd = esObj.datagrid("getRowIndex", row);
          esObj.datagrid("deleteRow", curInd);
        }
        // updateTableHeight()
        selectESIndex = undefined;
        editESIndex = undefined;
      }
    });
  } else {
    $.messager.popover({ msg: "请先选择要删除的行！", type: "alert" });
  }
}
function beforeDragESRow() {
  // if ((undefined!=editESIndex)&&!saveESRow()) return false;
  if (undefined != editESIndex) return false;
}
// 拖动数据引入表格
function dropESRow(target, source, point) {
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
  $cm(
    {
      ClassName: "Nur.NIS.Service.BasicDict.Config",
      MethodName: "UpdateBasicDictSort",
      newSort: newSort,
      ID: source.id,
    },
    function (data) {
      console.log(data);
      if (0 == data) {
        // 更新排序号
        var diObj = $("#dataImport");
        var len = diObj.datagrid("getRows").length;
        for (var i = 0; i < len; i++) {
          diObj.datagrid("updateRow", {
            index: i,
            row: {
              sortNo: i + 1,
            },
          });
        }
        $("#dataImport").datagrid("loadData", diTableData);
      } else {
        $.messager.popover({ msg: JSON.stringify(data), type: "alert" });
      }
    }
  );
}
function getADRsTableData() {
  var pRow = $("#evaluateSystem").datagrid("getSelected");
	var pId=pRow&&pRow.id;
  saveFlag = false;
  // 获取放化疗评价系统数据
  if (pId) {
    var data = $cm(
      {
        ClassName: "Nur.NIS.Service.BasicDict.Config",
        QueryName: "GetBasicDictSub",
				page: pageSub,
				rows: pageSubSize,
				keyword: $("#ADRsInput").searchbox("getValue"),
        pId: pId,
      },
      false
    );
  } else {
		pageSub=1;
    var data = { total: 0, rows: [] };
  }
	$("#ADRsTable")
		.datagrid("loadData", data)
		.datagrid("getPager")
		.pagination({
			onSelectPage: function (p, size) {
				pageSub = p;
				pageSubSize = size;
				if (saveFlag) {
					getADRsTableData();
				} else {
					saveFlag = true;
				}
			},
			onRefresh: function (p, size) {
				pageSub = p;
				pageSubSize = size;
				getADRsTableData();
			},
			onChangePageSize: function (size) {
				pageSub = 1;
				pageSubSize = size;
				getADRsTableData();
			},
		})
		.pagination("select", pageSub);
}
function filterADRs() {
	pageSub=1;
	getADRsTableData();
}
function editADRsRow(curInd, row) {
  // 当双击另一行时，先保存正在编辑的行
  if (undefined != editADIndex && editADIndex != curInd && !saveADRsRow())
    return;
  editADIndex = curInd;
  $("#ADRsTable").datagrid("beginEdit", editADIndex);
}
function addADRsRow() {
  var pRow = $("#evaluateSystem").datagrid("getSelected");
  if (!pRow)
    return $.messager.popover({ msg: "请先选择字典类型！", type: "alert" });
  if (!pRow.id)
    return $.messager.popover({ msg: "请先保存字典类型！", type: "alert" });
  if (undefined != editADIndex && !saveADRsRow()) return;
  editADIndex = $("#ADRsTable").datagrid("getRows").length;
  var row = {
    bdsCode: "",
    bdsDesc: "",
    startFlag: 1,
    id: "",
  };
  $("#ADRsTable")
    .datagrid("insertRow", {
      row: row,
    })
    .datagrid("selectRow", editADIndex);
  selectADIndex = editADIndex;
  editADRsRow(editADIndex, row);
}
function saveADRsRow() {
  if (undefined == editADIndex) {
    return $.messager.popover({ msg: "无需要保存的项！", type: "alert" });
  }
  var index = $("#ADRsTable").datagrid("getEditingRowIndexs")[0];
  if (undefined === index) return true;
  var curRow = $("#ADRsTable").datagrid("getRows")[index];
  var rowEditors = $("#ADRsTable").datagrid("getEditors", editADIndex);
  var id = curRow.id || "";
  var bdsCode = $(rowEditors[0].target).val();
  var bdsDesc = $(rowEditors[1].target).val();
  var startFlag = $(rowEditors[2].target).combobox('getValue');
  if (!bdsCode || !bdsDesc) {
    $.messager.popover({
      msg: "请填写字典项目代码和描述！",
      type: "alert",
    });
    return false;
  }
  var pId = $("#evaluateSystem").datagrid("getSelected").id;
  var data = {
    id: id,
    pId: pId,
    bdsCode: bdsCode,
    bdsDesc: bdsDesc,
    startFlag: startFlag,
  };
  var updateRow = editADIndex;
  var res = $cm(
    {
      ClassName: "Nur.NIS.Service.BasicDict.Config",
      MethodName: "AddOrUpdateBasicDictSub",
      dataType: "text",
      data: JSON.stringify(data),
    },
    false
  );
  console.log(res);
  if (0 == res || res.includes(pId + "||")) {
    $.messager.popover({ msg: "保存成功！", type: "success" });
    var row = {
      id: id || res.split("@")[0],
      sortNo: curRow.sortNo || res.split("@")[1],
      bdsCode: bdsCode,
      bdsDesc: bdsDesc,
    };
    $("#ADRsTable").datagrid("acceptChanges").datagrid("updateRow", {
      index: updateRow,
      row: row,
    });
    $("#ADRsTable").datagrid("endEdit", editADIndex);
    editADIndex = undefined;
    // 更新数据
    if (0 == res) {
      adTableData.rows.map(function (elem, index) {
        if (row.id == elem.id) {
          adTableData.rows[index].bdsCode = row.bdsCode;
          adTableData.rows[index].bdsDesc = row.bdsDesc;
        }
      });
    } else {
      adTableData.rows.push(row);
    }
    filterADRs();
    return true;
  } else {
    $.messager.popover({ msg: res, type: "alert" });
    return false;
  }
}
function deleteADRsRow() {
  var adObj = $("#ADRsTable");
  var row = adObj.datagrid("getSelected");
  if (row) {
    $.messager.confirm("删除", "确定要删除选中的数据?", function (r) {
      if (r) {
        if (row.id) {
          var res = $cm(
            {
              ClassName: "Nur.NIS.Service.BasicDict.Config",
              MethodName: "DeleteBasicDictSub",
              ID: row.id,
            },
            false
          );
          console.log(res);
          if (0 == res) {
            $.messager.popover({ msg: "删除成功！", type: "success" });
            getADRsTableData();
          } else {
            $.messager.popover({ msg: JSON.stringify(res), type: "alert" });
            return false;
          }
        } else {
          getADRsTableData();
        }
      }
    });
  } else {
    $.messager.popover({ msg: "请先选择要删除的行！", type: "alert" });
  }
}
function beforeDragADRsRow() {
  if (undefined != editADIndex) return false;
}
// 拖动数据引入表格
function dropADRsRow(target, source, point) {
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
  $cm(
    {
      ClassName: "Nur.NIS.Service.BasicDict.Config",
      MethodName: "UpdateBasicDictSubSort",
      newSort: newSort,
      ID: source.id,
    },
    function (data) {
      if (0 == data) {
        getADRsTableData();
      } else {
        $.messager.popover({ msg: JSON.stringify(data), type: "alert" });
      }
    }
  );
}

function resizeTableHeight() {
  var innerHeight = window.innerHeight;
  $("#evaluateSystem").datagrid("resize", {
    height: innerHeight - 155,
  });
  $("#ADRsTable").datagrid("resize", {
    height: innerHeight - 155,
  });
  $("#gradeTable").datagrid("resize", {
    height: innerHeight - 346,
  });
  /*setTimeout(function () {
    $(
      ".evaluate .datagrid-view .datagrid-body,.ADRs .datagrid-view .datagrid-body"
    ).css("height", innerHeight - 185 + "px");
  }, 100);*/
  setTimeout(function () {
    //console.log($("div.grade>.panel").height());
    //console.log($("div.ADRs>.panel").height());
    $("#gradeTable").datagrid("resize", {
      height:
        innerHeight -
        346 -
        ($("div.grade>.panel").height() - $("div.ADRs>.panel").height()),
    });
  }, 300);
}
setTimeout(resizeTableHeight, 100);
window.addEventListener("resize", resizeTableHeight);
