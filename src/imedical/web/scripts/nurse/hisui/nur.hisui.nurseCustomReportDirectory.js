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
 * @description: ��ʼ������
 */
function initUI() {
  initAllTemplatesGrid();
  initLeftTemplatesTree();
  initMenu();
  listenEvents();
}

//��ʼ��ҽԺ�б�
function InitHospList() {
  /*
		var hospComp = GenHospComp("Nur_IP_StatsDataSourceConfig","",{width:250});    //websys.com.js
		hospComp.jdata.options.onSelect = function(e,t){
			initAllTemplatesGrid();
			initLeftTemplatesTree();			
			if (t) {
				$('#hospitalDiv').panel('setTitle', t.HOSPDesc+"�ɼ�");
		    }
		}
		hospComp.jdata.options.onLoadSuccess= function(data){
			if (data) {
				$('#hospitalDiv').panel('setTitle', data.rows[0].HOSPDesc+"�ɼ�");
		    }
		}
		*/

  try {
    // ��Ժ��
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
        $("#hospitalDiv").panel("setTitle", t.HOSPDesc + "�ɼ�");
      }
    };
    hospComp.jdata.options.onLoadSuccess = function (data) {
      if (data) {
        $("#hospitalDiv").panel("setTitle", data.rows[0].HOSPDesc + "�ɼ�");
      }
    };
  } catch (ex) {
    // ��������Ŀ���Ƕ�Ժ���ĳ���
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
          $("#hospitalDiv").panel("setTitle", t.HOSPDesc + "�ɼ�");
        }
      },
      onLoadSuccess: function (data) {
        if (data) {
          $("#hospitalDiv").panel("setTitle", data.rows[0].HOSPDesc + "�ɼ�");
        }
      },
    });
  }
}

/**
 * @description: ��ʼ������ģ����
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
        { field: "ReportCode", title: "�������", width: 200 },
      ],
    ],
    columns: [
      [
        { field: "ReportName", title: "��������", width: 250 },
        { field: "ReportPropertyDesc", title: "��������", width: 150 },
        { field: "AdminGroup", title: "ȫ����Ȩ��", width: 250 },
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
        text: "��ӵ�Ŀ¼",
        handler: addToDirectory,
      },
      "-",
      {
        id: "btnDirectory",
        iconCls: "icon-template",
        text: "��Ŀ¼ά��",
        handler: setDirectory,
      },
      {
        id: "btnViewAll",
        iconCls: "icon-template",
        text: "ȫ����Ȩ��ά��",
        handler: permitAll,
      },
    ],
    onLoadSuccess: function (data) {
      // $(this).datagrid("checkRow", 0);
      // permitAll();
    },
  });
}

// ��ȡҽԺID
function GetHospital() {
  var hospitalid = $HUI.combogrid("#_HospList").getValue();
  if (hospitalid == "") {
    hospitalid = session["LOGON.HOSPID"];
  }
  return hospitalid;
}

/**
 * @description: ȫ����Ȩ���޸Ľ���
 */
function permitAll(item) {
  $("#groupsearchAll").searchbox("setValue", ""); // ���������
  var templates = $("#allTemplatesGrid").datagrid("getSelections");
  if (templates.length == 0) {
    $.messager.popover({
      msg: "��ѡ�񱨱�",
      type: "info",
      timeout: 1000,
    });
    return;
  }
  var reportArr = []; // ����
  var lastReportId = ""; // test
  for (i = 0; i < templates.length; i++) {
    var reportId = templates[i].rowid; // ����StatsReportConfig���ñ�����
    var reportCode = templates[i].ReportCode; // �������
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
      { field: "SSGRPDesc", title: "��ȫ��", width: 300 },
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
    loadMsg: "������..",
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
          // ������չ�ѡ��������л���
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
    title: "ȫ����Ȩ��",
    buttons: [
      {
        text: "����",
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
          // ˢ�±��
          initAllTemplatesGrid();
          //updateGroup(node,ID);
          $HUI.dialog("#divGroupAll").close();
        },
      },
      {
        text: "ȡ��",
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
 * @description:  ��ʼ��Ŀ¼
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
    // Ϊ���нڵ���һ���Ӧ�¼�
    onContextMenu: function (e, node) {
      // ��ֹ�����Ĭ�ϵ��Ҽ��˵��¼�
      e.preventDefault();
      $("#leftTemplateTree").tree("select", node.target);
      // ��ʾ�Ҽ��˵� ����Ϊ�ӽڵ㣬���ڵ㲻Ϊ��
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
        // Ȩ�� -- �ӽڵ㲻������Ȩ��
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
        // Ȩ�� -- ���ڵ������Ȩ��
        $("#menuGroup").show();
        //$('#menu').menu('enableItem',$('#menu').menu('getItem', $('#menuGroup')[0]).target);
      }
    },
  });
}
/**
 * @description:  �����¼�
 */
function listenEvents() {
  $("#btnSearch").click(function (e) {
    $HUI.tree("#leftTemplateTree", "reload");
    reloadTemplatesGrid();
  });
}
/**
 * @description:  �������
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
 * @description:  ��ӵ�Ŀ¼�ṹ
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
      msg: "��ѡ��ģ�壡",
      type: "info",
      timeout: 1000,
    });
    return;
  }
  var node = $("#leftTemplateTree").tree("getSelected");
  if (!node) {
    $.messager.popover({
      msg: "��ѡ��Ҫ��ӵ�Ŀ¼��",
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
      msg: "��ѡ���Ŀ¼��",
      type: "info",
      timeout: 1000,
    });
    return;
  }
  for (i = 0; i < templates.length; i++) {
    var id = node.id;
    var guid = templates[i].rowid; //��ʱrowid����guid
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
    title: "��ӵ�Ŀ¼",
    buttons: [
      {
        text: "ȷ��",
        handler: function () {
          saveItem(node, ids, childsubs, rootid, guids, reportnames);
        },
      },
      {
        text: "ȡ��",
        handler: function () {
          $HUI.dialog("#divAdd").close();
        },
      },
    ],
    closed: false,
  });
}
/**
 * @description:  �����ӽڵ�
 */
function saveItem(node, ids, childsubs, rootid, guids, reportnames) {
  var rename = $("#inputDesc").val();
  var sortNo = $("#numberNo").numberbox("getValue");

  $m(
    {
      ClassName: "Nur.NIS.Service.ReportV2.DataManager",
      MethodName: "UpdateReportDirectorySub",
      event: "SAVE",
      ParRefs: ids, //����rowid����ParRef
      childsubs: childsubs, //�ӱ�id  ���� �ÿ�
      ReportGuids: guids, //��ӦCF_NUR_NIS.StatsReportConfig RowID
      ReportNames: reportnames, //CF_NUR_NIS.StatsReportConfig  SSReportName
      ReportReName: rename, // ��Ӧ����
      RootID: rootid, //��ӦCF_NUR_NIS.ReportDirectory RowID = ParRef
      ReportHospitalIDs: "", //�ÿ�,��ʱ����
      ReportLocIDs: "", //�ÿ�,��ʱ����
      ReportSortNo: sortNo, //��Ӧ����š�����ʾ˳��
      ReportUpdateUser: session["LOGON.USERID"] || "",
      ReportGroupDR: node.group,
    },
    function (txtData) {
      if (!$.isNumeric(txtData) || parseInt(txtData) < 0) {
        $.messager.popover({
          msg: "����ʧ��! " + txtData,
          type: "info",
          timeout: 1000,
        });
        $HUI.tree("#leftTemplateTree", "reload");
      } else {
        $.messager.popover({
          msg: "����ɹ�! ",
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
 * @description:  Ŀ¼ά��
 */
function setDirectory() {
  var url =
    "nur.hisui.nurseCustomReportDirectoryConfig.CSP?HospitalID=" +
    session["LOGON.HOSPID"];
	var dlgWidth=650,dlgHeight=600;
    var offsetLeft = (window.innerWidth -dlgWidth) / 2;
    var offsetTop = (window.innerHeight -dlgHeight) / 2;
  $("#directoryDiv").dialog({
    title: "Ŀ¼ά��",
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
 * @description: ��ʼ��menu
 */
function initMenu() {
  $("#menu").menu("appendItem", {
    id: "menuRemove",
    text: "�Ƴ�",
    iconCls: "icon-remove",
    onclick: removeTemplate,
  });
  $("#menu").menu("appendItem", {
    id: "menuModify",
    text: "�޸�",
    iconCls: "icon-edit",
    onclick: modify,
  });
  $("#menu").menu("appendItem", {
    id: "menuGroup",
    text: "Ȩ��",
    iconCls: "icon-add",
    onclick: permit,
  });
}
/**
 * @description: ɾ��
 */
function removeTemplate(item) {
  var node = $("#leftTemplateTree").tree("getSelected");
  if (!node) {
    $.messager.popover({
      msg: "��ѡ��ģ�壡",
      type: "info",
      timeout: 1000,
    });
    return;
  }
  if (node.isLeaf == "0") {
    $.messager.popover({
      msg: "��ѡ��ģ�壡",
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
          msg: "�Ƴ��ɹ�! ",
          type: "info",
          timeout: 1000,
        });
        $HUI.tree("#leftTemplateTree", "reload");
        return;
      } else {
        $.messager.popover({
          msg: "�Ƴ�ʧ��! " + txtData,
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
 * @description: �޸�
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
      msg: "��ѡ��ģ�壡",
      type: "info",
      timeout: 1000,
    });
    return;
  }
  if (node.isLeaf == "0") {
    $.messager.popover({
      msg: "��ѡ��ģ�壡",
      type: "info",
      timeout: 1000,
    });
    return;
  }

  $("#divAdd").dialog({
    title: "�޸�",
    buttons: [
      {
        text: "ȷ��",
        handler: function () {
          saveItem(node, id, childsub, id);
        },
      },
      {
        text: "ȡ��",
        handler: function () {
          $HUI.dialog("#divAdd").close();
        },
      },
    ],
    closed: false,
  });
}

/**
 * @description: Ȩ���޸Ľ���
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
      { field: "SSGRPDesc", title: "��ȫ��", width: 300 },
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
    loadMsg: "������..",
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
    title: "Ȩ��",
    buttons: [
      {
        text: "����",
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
        text: "ȡ��",
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
 * @description: ����Ȩ��
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
          msg: "����ʧ��! " + txtData,
          type: "info",
          timeout: 1000,
        });
        $HUI.datagrid("#GroupGrid", "reload");
      } else {
        $.messager.popover({
          msg: "����ɹ�! ",
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
