$(function () {
  var GLOBAL = {
    HospEnvironment: true,
  };

  InitHospList();
  initUI();
  window.refreshLeftTree = function () {
    InitHospList();
    initLeftTemplatesTree();
  };
});

/**
 * @description: 初始化界面
 */
function initUI() {
  initAllTemplatesGrid();
  initLeftTemplatesTree();
  initMenu();
  listenEvents();
}

//初始化医院列表
function InitHospList() {
  /*
		var hospComp = GenHospComp("Nur_IP_StatsDataSourceConfig","",{width:250});    //websys.com.js
		hospComp.jdata.options.onSelect = function(e,t){
			initAllTemplatesGrid();
			initLeftTemplatesTree();			
			if (t) {
				$('#hospitalDiv').panel('setTitle', t.HOSPDesc+"可见");
		    }
		}
		hospComp.jdata.options.onLoadSuccess= function(data){
			if (data) {
				$('#hospitalDiv').panel('setTitle', data.rows[0].HOSPDesc+"可见");
		    }
		}
		*/

  try {
    // 多院区
    var sessionInfo =
      session["LOGON.USERID"] +
      "^" +
      session["LOGON.GROUPID"] +
      "^" +
      session["LOGON.CTLOCID"] +
      "^" +
      session["LOGON.HOSPID"];
    var hospComp = GenHospComp("Nur_IP_Question", sessionInfo);
    hospComp.jdata.options.onSelect = function (e, t) {
      initAllTemplatesGrid();
      initLeftTemplatesTree();
      if (t) {
        $("#hospitalDiv").panel("setTitle", t.HOSPDesc + "可见");
      }
    };
    hospComp.jdata.options.onLoadSuccess = function (data) {
      if (data) {
        $("#hospitalDiv").panel("setTitle", data.rows[0].HOSPDesc + "可见");
      }
    };
  } catch (ex) {
    // 兼容老项目，非多院区的场景
    $("#_HospList").combobox({
      url:
        $URL +
        "?1=1&ClassName=Nur.NIS.Service.ReportV2.LocUtils" +
        "&QueryName=GetHospitalList&ResultSetType=array",
      valueField: "HospitalId",
      textField: "HospitalDesc",
      defaultFilter: 4,
      width: 250,
      value: session["LOGON.HOSPID"],
      onSelect: function (e, t) {
        initAllTemplatesGrid();
        initLeftTemplatesTree();
        if (t) {
          $("#hospitalDiv").panel("setTitle", t.HOSPDesc + "可见");
        }
      },
      onLoadSuccess: function (data) {
        if (data) {
          $("#hospitalDiv").panel("setTitle", data.rows[0].HOSPDesc + "可见");
        }
      },
    });
  }
}

/**
 * @description: 初始化所有模板表格
 */
function initAllTemplatesGrid() {
  $HUI.datagrid("#allTemplatesGrid", {
    url: $URL,
    queryParams: {
      ClassName: "Nur.NIS.Service.ReportV2.DataManager",
      QueryName: "FindCustomReport",
      RowID: "",
      HospitalID: $HUI.combogrid("#_HospList").getValue(),
      Name: "",
    },
    frozenColumns: [
      [
        { field: "rowid", checkbox: true, align: "center", width: 80 },
        { field: "ReportCode", title: "报表代码", width: 200 },
      ],
    ],
    columns: [
      [
        { field: "ReportName", title: "报表名称", width: 250 },
        { field: "ReportPropertyDesc", title: "报表类型", width: 150 },
        { field: "AdminGroup", title: "全病区权限", width: 250 },
      ],
    ],
    pagination: true,
    pageSize: 15,
    pageList: [15, 30, 50],
    rownumbers: true,
    width: 500,
    toolbar: [
      {
        id: "btnAddHosp",
        iconCls: "icon-arrow-left",
        text: "添加到目录",
        handler: addToDirectory,
      },
      "-",
      {
        id: "btnDirectory",
        iconCls: "icon-template",
        text: "根目录维护",
        handler: setDirectory,
      },
      {
        id: "btnViewAll",
        iconCls: "icon-template",
        text: "全病区权限维护",
        handler: permitAll,
      },
    ],
    onLoadSuccess: function (data) {
      // $(this).datagrid("checkRow", 0);
      // permitAll();
    },
  });
}

// 获取医院ID
function GetHospital() {
  var hospitalid = $HUI.combogrid("#_HospList").getValue();
  if (hospitalid == "") {
    hospitalid = session["LOGON.HOSPID"];
  }
  return hospitalid;
}

/**
 * @description: 全病区权限修改界面
 */
function permitAll(item) {
  $("#groupsearchAll").searchbox("setValue", ""); // 清空搜索框
  var templates = $("#allTemplatesGrid").datagrid("getSelections");
  if (templates.length == 0) {
    $.messager.popover({
      msg: "请选择报表！",
      type: "info",
      timeout: 1000,
    });
    return;
  }
  var reportArr = []; // 报表
  var lastReportId = ""; // test
  for (i = 0; i < templates.length; i++) {
    var reportId = templates[i].rowid; // 报表StatsReportConfig配置表主键
    var reportCode = templates[i].ReportCode; // 报表代码
    reportArr.push(reportId);
    lastReportId = reportId;
  }
  var groupsearch = "";
  $("#groupsearchAll").searchbox({
    searcher: function (value, name) {
      groupsearch = value;
      $("#GroupGridAll").datagrid("reload", {
        ClassName: "Nur.NIS.Service.ReportV2.DataManager",
        QueryName: "GetSSGroup",
        hospid: $HUI.combogrid("#_HospList").getValue(),
        rowid: "",
        SearchDesc: groupsearch,
        rows: 999,
      });
    },
  });
  var Columns = [
    [
      { field: "SSGRPDesc", title: "安全组", width: 300 },
      { field: "SSGRPRowId", checkbox: true, align: "center" },
    ],
  ];
  $HUI.datagrid("#GroupGridAll", {
    url: $URL,
    queryParams: {
      ClassName: "Nur.NIS.Service.ReportV2.DataManager",
      QueryName: "GetSSGroup",
      hospid: $HUI.combogrid("#_HospList").getValue(),
      rowid: "",
      SearchDesc: groupsearch,
      rows: 9999,
    },
    fit: true,
    //width:'auto',
    // height:'350',
    singleSelect: false,
    fitColumns: false,
    // autoRowHeight: false,
    loadMsg: "加载中..",
    idField: "SSGRPRowId",
    rownumbers: true,
    columns: Columns,
    nowrap: true,
    //pageSize: 999,
    //pageList: [999],
    pagination: false,
    onLoadSuccess: function (data) {
      $.m(
        {
          ClassName: "CF.NUR.NIS.ReportAdmin",
          MethodName: "GetGroupByReportpId",
          reportId: lastReportId,
        },
        function (Data) {
          // 首先清空勾选，否则会有缓存
          var rows = $("#GroupGridAll").datagrid("getRows");
          $("#GroupGridAll").datagrid("uncheckAll");
          if (Data && Data != "") {
            var arr = Data.split(",");
            for (var i = 0; i < arr.length; i++) {
              if (arr[i]) {
                var th = $("#GroupGridAll").datagrid("getRowIndex", arr[i]); //.datagrid('checkRow')
                $("#GroupGridAll").datagrid("checkRow", th);
              }
            }
          }
        }
      );
      //   $("#GroupGridAll").datagrid('resize',{
      // 	height:340
      //   })
    },
  });
  $("#divGroupAll").dialog({
    title: "全病区权限",
    buttons: [
      {
        text: "保存",
        handler: function () {
          var groups = $("#GroupGridAll").datagrid("getSelections");
          var ids = [];
          var groupList = "";
          if (groups.length > 0) {
            groups.forEach(function (item, index) {
              ids.push(item.SSGRPRowId);
            });
            groupList = ids.join(",");
          }
          var jsonList = [];
          // reportArr
          for (var i = 0; i < reportArr.length; i++) {
            var obj = {};
            obj.reportId = reportArr[i];
            obj.groupId = groupList;
            jsonList.push(obj);
          }
          $cm(
            {
              ClassName: "CF.NUR.NIS.ReportAdmin",
              MethodName: "AddDataList",
              dataList: JSON.stringify(jsonList),
              hosId: GetHospital(),
            },
            false
          );
          // 刷新表格
          initAllTemplatesGrid();
          //updateGroup(node,ID);
          $HUI.dialog("#divGroupAll").close();
        },
      },
      {
        text: "取消",
        handler: function () {
          $HUI.dialog("#divGroupAll").close();
        },
      },
    ],
    closed: false,
  });
  var offsetLeft = (window.innerWidth - $("#divGroupAll").parent().width()) / 2;
  var offsetTop =
    (window.innerHeight - $("#divGroupAll").parent().height()) / 2;
  $("#divGroupAll")
    .dialog({
      left: offsetLeft,
      top: offsetTop,
    })
    .dialog("open");
  //   $("#GroupGridAll").datagrid('resize',{
  // 	height:340
  //   })
}
/**
 * @description:  初始化目录
 */
function initLeftTemplatesTree() {
  var hospitalid = $HUI.combogrid("#_HospList").getValue();
  if (hospitalid == "") {
    hospitalid = session["LOGON.HOSPID"];
  }
  $HUI.tree("#leftTemplateTree", {
    loader: function (param, success, error) {
      $cm(
        {
          ClassName: "Nur.NIS.Service.ReportV2.DataManager",
          MethodName: "FindReportDirectory",
          RowID: "",
          HospitalID: hospitalid,
        },
        function (data) {
          var addIDAndText = function (node) {
            node.text = node.text + " ";
            node.children.forEach(function (item, index) {
              if (item.rename != "") {
                item.text = item.rename + "(" + item.text + ")";
              }
            });
          };
          data.forEach(addIDAndText);
          success(data);
        }
      );
    },
    autoNodeHeight: true,
    onClick: function (node) {
      // $('#leftTemplateTree').tree('toggle', node.target);
    },
    // 为所有节点绑定右击响应事件
    onContextMenu: function (e, node) {
      // 阻止浏览器默认的右键菜单事件
      e.preventDefault();
      $("#leftTemplateTree").tree("select", node.target);
      // 显示右键菜单 自身为子节点，父节点不为空
      if (
        $(this).tree("isLeaf", node.target) &&
        !$.isEmptyObject($(this).tree("getParent", node.target))
      ) {
        $("#menu").menu("show", {
          left: e.pageX,
          top: e.pageY,
        });
        var item1 = $("#menu").menu("getItem", $("#menuRemove")[0]);
        $("#menu").menu(
          "enableItem",
          $("#menu").menu("getItem", $("#menuRemove")[0]).target
        );
        var item2 = $("#menu").menu("getItem", $("#menuModify")[0]);
        $("#menu").menu("enableItem", item2.target);
        // 权限 -- 子节点不可设置权限
        $("#menuGroup").hide();
        //$('#menu').menu('disableItem',$('#menu').menu('getItem', $('#menuGroup')[0]).target);
      } else {
        $("#menu").menu("show", {
          left: e.pageX,
          top: e.pageY,
        });
        var item1 = $("#menu").menu("getItem", $("#menuRemove")[0]);
        $("#menu").menu(
          "disableItem",
          $("#menu").menu("getItem", $("#menuRemove")[0]).target
        );
        var item2 = $("#menu").menu("getItem", $("#menuModify")[0]);
        $("#menu").menu("disableItem", item2.target);
        // 权限 -- 父节点可设置权限
        $("#menuGroup").show();
        //$('#menu').menu('enableItem',$('#menu').menu('getItem', $('#menuGroup')[0]).target);
      }
    },
  });
}
/**
 * @description:  监听事件
 */
function listenEvents() {
  $("#btnSearch").click(function (e) {
    $HUI.tree("#leftTemplateTree", "reload");
    reloadTemplatesGrid();
  });
}
/**
 * @description:  表格重载
 */
function reloadTemplatesGrid() {
  $("#allTemplatesGrid").datagrid("reload", {
    ClassName: "Nur.NIS.Service.ReportV2.DataManager",
    QueryName: "FindCustomReport",
    RowID: "",
    HospitalID: $HUI.combogrid("#_HospList").getValue(),
    Name: $("#textTemplateName").searchbox("getValue"),
  });
}
/**
 * @description:  添加到目录结构
 */
function addToDirectory() {
  $("#inputDesc").val("");
  var guids = "";
  var reportnames = "";
  var ids = "";
  var childsubs = "";

  var templates = $("#allTemplatesGrid").datagrid("getSelections");
  if (templates.length == 0) {
    $.messager.popover({
      msg: "请选择模板！",
      type: "info",
      timeout: 1000,
    });
    return;
  }
  var node = $("#leftTemplateTree").tree("getSelected");
  if (!node) {
    $.messager.popover({
      msg: "请选择要添加的目录！",
      type: "info",
      timeout: 1000,
    });
    return;
  }
  if (
    $("#leftTemplateTree").tree("isLeaf", node.target) &&
    !$.isEmptyObject($("#leftTemplateTree").tree("getParent", node.target))
  ) {
    $.messager.popover({
      msg: "请选择根目录！",
      type: "info",
      timeout: 1000,
    });
    return;
  }
  for (i = 0; i < templates.length; i++) {
    var id = node.id;
    var guid = templates[i].rowid; //暂时rowid代替guid
    var reportname = templates[i].ReportName;
    var rootid = node.id;
    var group = templates[i].Group;
    //var reporthospitalid=templates[i].ReportHospDR;
    //var reportlocid=templates[i].ReportValidLocs;
    ids = ids == "" ? id : ids + "," + id;
    guids = guids == "" ? guid : guids + "," + guid;
    reportnames =
      reportnames == "" ? reportname : reportnames + "," + reportname;
  }

  $("#divAdd").dialog({
    title: "添加到目录",
    buttons: [
      {
        text: "确定",
        handler: function () {
          saveItem(node, ids, childsubs, rootid, guids, reportnames);
        },
      },
      {
        text: "取消",
        handler: function () {
          $HUI.dialog("#divAdd").close();
        },
      },
    ],
    closed: false,
  });
}
/**
 * @description:  保存子节点
 */
function saveItem(node, ids, childsubs, rootid, guids, reportnames) {
  var rename = $("#inputDesc").val();
  var sortNo = $("#numberNo").numberbox("getValue");

  $m(
    {
      ClassName: "Nur.NIS.Service.ReportV2.DataManager",
      MethodName: "UpdateReportDirectorySub",
      event: "SAVE",
      ParRefs: ids, //父表rowid，即ParRef
      childsubs: childsubs, //子表id  新增 置空
      ReportGuids: guids, //对应CF_NUR_NIS.StatsReportConfig RowID
      ReportNames: reportnames, //CF_NUR_NIS.StatsReportConfig  SSReportName
      ReportReName: rename, // 对应描述
      RootID: rootid, //对应CF_NUR_NIS.ReportDirectory RowID = ParRef
      ReportHospitalIDs: "", //置空,暂时不用
      ReportLocIDs: "", //置空,暂时不用
      ReportSortNo: sortNo, //对应“序号”，显示顺序
      ReportUpdateUser: session["LOGON.USERID"] || "",
      ReportGroupDR: node.group,
    },
    function (txtData) {
      if (!$.isNumeric(txtData) || parseInt(txtData) < 0) {
        $.messager.popover({
          msg: "保存失败! " + txtData,
          type: "info",
          timeout: 1000,
        });
        $HUI.tree("#leftTemplateTree", "reload");
      } else {
        $.messager.popover({
          msg: "保存成功! ",
          type: "info",
          timeout: 1000,
        });
        $HUI.tree("#leftTemplateTree", "reload");
      }
      $HUI.dialog("#divAdd").close();
      //$HUI.tree('#leftTemplateTree','reload');
      $("#allTemplatesGrid").datagrid("reload");
    }
  );
}
/**
 * @description:  目录维护
 */
function setDirectory() {
  var url =
    "nur.hisui.nurseCustomReportDirectoryConfig.CSP?HospitalID=" +
    session["LOGON.HOSPID"];
	var dlgWidth=650,dlgHeight=600;
    var offsetLeft = (window.innerWidth -dlgWidth) / 2;
    var offsetTop = (window.innerHeight -dlgHeight) / 2;
  $("#directoryDiv").dialog({
    title: "目录维护",
    width: dlgWidth,
    height: dlgHeight,
    cache: false,
    left: offsetLeft,
    top: offsetTop,
    content:
      "<iframe scrolling='auto' frameborder='0' src='" +
      url +
      "' style='width:100%; height:100%; display:block;'></iframe>",
    modal: true,
    onClose: function () {
      $HUI.tree("#leftTemplateTree", "reload");
    },
  });
  $("#directoryDiv").dialog("open");
}

/**
 * @description: 初始化menu
 */
function initMenu() {
  $("#menu").menu("appendItem", {
    id: "menuRemove",
    text: "移除",
    iconCls: "icon-remove",
    onclick: removeTemplate,
  });
  $("#menu").menu("appendItem", {
    id: "menuModify",
    text: "修改",
    iconCls: "icon-edit",
    onclick: modify,
  });
  $("#menu").menu("appendItem", {
    id: "menuGroup",
    text: "权限",
    iconCls: "icon-add",
    onclick: permit,
  });
}
/**
 * @description: 删除
 */
function removeTemplate(item) {
  var node = $("#leftTemplateTree").tree("getSelected");
  if (!node) {
    $.messager.popover({
      msg: "请选择模板！",
      type: "info",
      timeout: 1000,
    });
    return;
  }
  if (node.isLeaf == "0") {
    $.messager.popover({
      msg: "请选择模板！",
      type: "info",
      timeout: 1000,
    });
    return;
  }
  $cm(
    {
      ClassName: "Nur.NIS.Service.ReportV2.DataManager",
      MethodName: "DeleteReportDirectorySub",

      //event:"DELETE",
      ParRefs: node.id.split("||")[0],
      childsubs: node.id.split("||")[1],
    },
    function (txtData) {
      if (parseInt(txtData) == 0) {
        $.messager.popover({
          msg: "移除成功! ",
          type: "info",
          timeout: 1000,
        });
        $HUI.tree("#leftTemplateTree", "reload");
        return;
      } else {
        $.messager.popover({
          msg: "移除失败! " + txtData,
          type: "info",
          timeout: 1000,
        });
        $HUI.tree("#leftTemplateTree", "reload");
      }
      $("#allTemplatesGrid").datagrid("reload");
    }
  );
}

/**
 * @description: 修改
 */
function modify(item) {
  var node = $("#leftTemplateTree").tree("getSelected");
  $("#inputDesc").val(node.rename);
  var id = node.id.split("||")[0];
  var childsub = node.id.split("||")[1];
  var rename = $("#inputDesc").val();
  $("#numberNo").numberbox("setValue", node.sno);
  if (!node) {
    $.messager.popover({
      msg: "请选择模板！",
      type: "info",
      timeout: 1000,
    });
    return;
  }
  if (node.isLeaf == "0") {
    $.messager.popover({
      msg: "请选择模板！",
      type: "info",
      timeout: 1000,
    });
    return;
  }

  $("#divAdd").dialog({
    title: "修改",
    buttons: [
      {
        text: "确定",
        handler: function () {
          saveItem(node, id, childsub, id);
        },
      },
      {
        text: "取消",
        handler: function () {
          $HUI.dialog("#divAdd").close();
        },
      },
    ],
    closed: false,
  });
}

/**
 * @description: 权限修改界面
 */
function permit(item) {
  //$("#TaskPlanExecute-panel").panel("resize",{height:$(window).height()-8,width:'100%'});
  var node = $("#leftTemplateTree").tree("getSelected");
  var groupsearch = "";
  $("#DirectoryText").val(node.text);
  $("#groupsearch").searchbox("clear");
  $("#groupsearch").searchbox({
    searcher: function (value, name) {
      groupsearch = value;
      $("#GroupGrid").datagrid("reload", {
        ClassName: "Nur.NIS.Service.ReportV2.DataManager",
        QueryName: "GetSSGroup",
        hospid: $HUI.combogrid("#_HospList").getValue(),
        rowid: "",
        SearchDesc: groupsearch,
        rows: 999,
      });
    },
  });
  var Columns = [
    [
      { field: "SSGRPDesc", title: "安全组", width: 300 },
      { field: "SSGRPRowId", checkbox: true, align: "center" },
    ],
  ];
  $HUI.datagrid("#GroupGrid", {
    url: $URL,
    queryParams: {
      ClassName: "Nur.NIS.Service.ReportV2.DataManager",
      QueryName: "GetSSGroup",
      hospid: $HUI.combogrid("#_HospList").getValue(),
      rowid: "",
      SearchDesc: groupsearch,
      rows: 9999,
    },
    fit: true,
    //width:'auto',
    //height:'360px',
    singleSelect: false,
    fitColumns: false,
    // autoRowHeight: false,
    loadMsg: "加载中..",
    idField: "SSGRPRowId",
    rownumbers: true,
    columns: Columns,
    nowrap: true,
    //pageSize: 999,
    //pageList: [999],
    pagination: false,
    onLoadSuccess: function (data) {
      $cm(
        {
          ClassName: "Nur.NIS.Service.ReportV2.DataManager",
          QueryName: "GetDirectoryGroup",
          RowID: node.id,
        },
        function (Data) {
          if (Data) {
            var rows = $("#GroupGrid").datagrid("getRows");
            $("#GroupGrid").datagrid("uncheckAll");
            $.each(Data.rows, function (index, item) {
              if (item.GRPRowId) {
                var th = $("#GroupGrid").datagrid("getRowIndex", item.GRPRowId); //.datagrid('checkRow')
                $("#GroupGrid").datagrid("checkRow", th);
                /**
								for(var i=0;i<rows.length;i++){
									var rowId = rows[i].SSGRPRowId;
									if(rowId==item.GRPRowId){
										$('#GroupGrid').datagrid('checkRow',i)									
										}								
									}
								**/
              }
            });
          }
        }
      );
    },
  });
  $("#divGroup").dialog({
    title: "权限",
    buttons: [
      {
        text: "保存",
        handler: function () {
          var groups = $("#GroupGrid").datagrid("getSelections");
          var ids = [];
          var ID = "";
          if (groups.length > 0) {
            groups.forEach(function (item, index) {
              ids.push(item.SSGRPRowId);
            });
            ID = ids.join("^");
          } else if (groups.length == 0) {
            ID = "";
          }
          updateGroup(node, ID);
          $HUI.dialog("#divGroup").close();
        },
      },
      {
        text: "取消",
        handler: function () {
          $HUI.dialog("#divGroup").close();
        },
      },
    ],
    closed: false,
  });
  var offsetLeft = (window.innerWidth - $("#divGroup").parent().width()) / 2;
  var offsetTop =
	(window.innerHeight - $("#divGroup").parent().height()) / 2;
  $("#divGroup")
	.dialog({
	  left: offsetLeft,
	  top: offsetTop,
	})
	.dialog("open");
}

/**
 * @description: 更新权限
 */
function updateGroup(node, id) {
  $m(
    {
      ClassName: "Nur.NIS.Service.ReportV2.DataManager",
      MethodName: "UpdateDirectoryGroup",
      RowID: node.id,
      Groups: id,
    },
    function (txtData) {
      if (!$.isNumeric(txtData) || parseInt(txtData) < 0) {
        $.messager.popover({
          msg: "保存失败! " + txtData,
          type: "info",
          timeout: 1000,
        });
        $HUI.datagrid("#GroupGrid", "reload");
      } else {
        $.messager.popover({
          msg: "保存成功! ",
          type: "info",
          timeout: 1000,
        });
        $HUI.datagrid("#GroupGrid", "reload");
        //$HUI.dialog('#divGroup').close();
        $HUI.tree("#leftTemplateTree", "reload");
      }
      //$HUI.dialog('#divGroup').close();
    }
  );
}
