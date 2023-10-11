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
var patNode,
  saveFlag = true,
  dateformat,
  singleConfigObj,
  singleConfig = [],
  multiColumns = [],
  colCodes = [],
  curEditorTarget;
var ifNewBaby = "N"; //�Ƿ���������־
var page = 1,
  pageSize = 20;
var timeouter;
var frm = dhcsys_getmenuform();
var traceType = [],
  traceTypeObj = {},
  patientObj;
if ('undefined'==typeof HISUIStyleCode) {
  var HISUIStyleCode="blue";
}
$(function () {
  init();
  if (frm) {
    patNode = {
      episodeID: frm.EpisodeID.value,
      patientID: frm.PatientID.value,
    };
    console.log(patNode);
  } else {
    updateDomSize();
  }
  // setTimeout(function(){
  //   var roots = $("#mvsLayout #patientTree").tree("getRoots");
  //   selectNode(roots);
  // },200);
	if ('lite'==HISUIStyleCode) { //����
		// $('.eduExeStyle').append('body{background-color: #f5f5f5;}');
		$('.eduExeStyle').append('.layout-split-west {border-right: 5px solid #FFFFFF;}');
	}else{
		$('.eduExeStyle').append('label.checkbox, label.radio {padding-left: 19px;}');
  }
});
function selectNode(nodes) {
  for (var i = 0; i < nodes.length; i++) {
    $("#mvsLayout #patientTree").tree("check", nodes[i].target);
    if (nodes[i].children) {
      selectNode(nodes[i].children);
    }
  }
}
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
      } else {
        $(".PatInfoItem").html(
          $g("��ȡ������Ϣʧ�ܡ����顾������Ϣչʾ�����á�")
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
// ��ʼ��
function init() {
  // ��ȡ���ڸ�ʽ
  var res = $cm(
    {
      ClassName: "Nur.NIS.Service.System.Config",
      MethodName: "GetSystemConfig",
    },
    false
  );
  dateformat = res.dateformat;
  $("#startDate").datebox("setValue", dateCalculate(new Date(), -6));
  $("#startTime").timespinner("setValue", "00:00"); //��ֵ
  $("#endDate").datebox("setValue", formatDate(new Date()));
  $("#endTime").timespinner("setValue", "23:59"); //��ֵ
  setDateboxOption();
  $cm(
    {
      ClassName: "Nur.NIS.Service.Trace.Manage",
      QueryName: "GetTraceConfig",
      rows: 999999999999999,
    },
    function (data) {
      traceType = data.rows;
      for (var i = 0; i < traceType.length; i++) {
        var elem = traceType[i];
        traceTypeObj[elem.id] = elem.type;
      }
      $HUI.combobox("#traceType", {
        valueField: "id",
        textField: "type",
        panelHeight: "auto",
        data: traceType,
        defaultFilter: 4,
      });
      getGMTableData();
    }
  );
  updateDomSize();
  // setTimeout(()=>{
  //  addGMRow();
  // },1000);
}
function getGMTableData() {
  var nodes = $("#mvsLayout #patientTree").tree("getChecked"),
    episodeIDs = [];
  for (var i = 0; i < nodes.length; i++) {
    if ((nodes[i].episodeID)&&($(nodes[i].target).css('display')!='none')) episodeIDs.push(nodes[i].episodeID);
  }
  var startDate = $("#startDate").datebox("getValue");
  var startTime = $("#startTime").timespinner("getValue");
  var endDate = $("#endDate").datebox("getValue");
  var endTime = $("#endTime").timespinner("getValue");
  var traceType = $("#traceType").combobox("getValue");
  saveFlag = false;
  timeouter = setTimeout(function () {
    saveFlag = true;
  }, 3000);
  var vFlag=$("#voidFlag").checkbox("getValue") ? 1 : "";
  if (vFlag) {
    $('#voidBtn').linkbutton({
      text:$g('ȡ������'),
      iconCls:'icon-cancel-order',
    });
  }else{
    $('#voidBtn').linkbutton({
      text:$g('����'),
      iconCls:'icon-cancel',
    });
  }
  // ��ȡ�����ټ�
  $cm(
    {
      ClassName: "Nur.NIS.Service.Trace.Manage",
      QueryName: "GetPatientTrace",
      episodeIDs: episodeIDs.join("^"),
      startDate: startDate,
      startTime: startTime,
      endDate: endDate,
      endTime: endTime,
      traceType: traceType,
      returnFlag: $("#returnFlag").checkbox("getValue") ? 1 : 0,
      vFlag: vFlag,
      page: page,
      rows: pageSize,
    },
    function (res) {
      console.log(res);
      if (res.total > 0 && !res.rows.length && page > 1) {
        page = 1;
        getGMTableData();
        return;
      }
      $("#gooutmanage")
        .datagrid("loadData", res)
        .datagrid("getPager")
        .pagination({
          onSelectPage: function (p, size) {
            page = p;
            pageSize = size;
            if (saveFlag) {
              getGMTableData();
            } else {
              saveFlag = true;
            }
          },
          onRefresh: function (p, size) {
            page = p;
            pageSize = size;
            getGMTableData();
          },
          onChangePageSize: function (size) {
            page = 1;
            pageSize = size;
            getGMTableData();
          },
        })
        .pagination("select", page);
      updateDomSize();
    }
  );
}
function getPatTreeEpisodeIds(roots) {
  var episodeIDs = [];
  for (var i = 0; i < roots.length; i++) {
    var elem=roots[i];
    if (elem) {
      if (elem.episodeID) {
        episodeIDs.push(elem.episodeID);
      }else if(elem.children){
        episodeIDs=episodeIDs.concat(getPatTreeEpisodeIds(elem.children));
      }
    }
  }
  return episodeIDs;
}
// ����ģ̬��λ��
function updateModalPos(id) {
  var offsetLeft=(window.innerWidth-$('#'+id).parent().width())/2;
  var offsetTop=(window.innerHeight-$('#'+id).parent().height())/2;
  $('#'+id).window({
    left: offsetLeft,
    top: offsetTop
  }).window("open");
}
function addGMRow() {
  if (!patientObj) {
    $("#QLAssessEditWin").window({
      modal: true,
      collapsible: false,
      minimizable: false,
      maximizable: false,
      closed: true,
      onClose: function () {
        getGMTableData();
        clearGMModal();
      },
    });
    patientObj = {};
    var roots = $("#mvsLayout #patientTree").tree("getRoots");
    var episodeIDs = getPatTreeEpisodeIds(roots);
    // ��ȡ������Ϣ
    var res = $cm(
      {
        ClassName: "Nur.NIS.Service.VitalSign.Temperature",
        MethodName: "GetPatientsByEpisodeIDs",
        EpisodeIDs: episodeIDs.join("^"),
      },
      false
    );
    res.map(function (elem) {
      patientObj[elem.episodeID] = elem;
    });
    $("#bedCode").combobox({
      valueField: "episodeID",
      textField: "bedCode",
      data: res,
      onSelect: function (record) {
        console.log(record);
        $("#regNo").val(record.regNo);
        $("#name").val(record.name);
      },
    });
    $HUI.combobox("#typeDR", {
      valueField: "id",
      textField: "type",
      panelHeight: "auto",
      data: traceType,
      defaultFilter: 4,
    });
  }
  $("#QLAssessEditWin").window({
    iconCls: "icon-w-add",
  });
  $("#QLAssessEditWin").window("open");updateModalPos("QLAssessEditWin");
  console.log(roots);
  //  return;
  $HUI.window("#QLAssessEditWin").setTitle($g("�����������"));
  // $("#rowId").val('');

  var nodes = $("#mvsLayout #patientTree").tree("getChecked"),
    episodeIDs = [];
  nodes = nodes.filter(function (e) {
    return e.episodeID;
  });

  if (nodes.length) {
    $("#bedCode").combobox("setValue", nodes[0].episodeID).combobox("enable");
    $("#regNo").val(patientObj[nodes[0].episodeID].regNo);
    $("#name").val(patientObj[nodes[0].episodeID].name);
  } else {
    $("#bedCode").combobox("clear").combobox("enable");
    $("#regNo").val("");
    $("#name").val("");
  }
  $("#outDateTime").datetimebox(
    "setValue",
    formatDate(new Date()) +
      " " +
      new Date().toString().split(" ")[4].slice(0, 5)
  );
  $("#rowId").val("");
}
function editGMRow(curInd, row) {
  if (!row) {
    row = $("#gooutmanage").datagrid("getSelected");
    if (!row)
      return $.messager.popover({
        msg: $g("����ѡ��Ҫ�༭���У�"),
        type: "alert",
      });
  }
  if (row.voidFlag) {
    return $.messager.popover({
      msg: $g("ϵͳ�����ϣ��޷��޸ģ�"),
      type: "alert",
    });
  }
  addGMRow();
  $("#QLAssessEditWin")
    .window({
      iconCls: "icon-w-edit",
    })
    .window("open");
  console.log(row);
  $HUI.window("#QLAssessEditWin").setTitle($g("�޸��������"));
  $("#bedCode").combobox("setValue", row.episodeID).combobox("disable");
  $("#regNo").val(patientObj[row.episodeID].regNo);
  $("#name").val(patientObj[row.episodeID].name);
  // $('#ward').combobox('enable');
  // $('#ward').combo('disable');
  $("#rowId").val(row.id);
  $("#typeDR").combobox("setValue", row.typeDR);
  $("#outDateTime").datetimebox("setValue", row.outDateTime);
  $("#entourage").val(row.entourage);
  $("#remarks").val(row.remarks);
  if (row.returnDateTime) {
    $("#returnDateTime").datetimebox("setValue", row.returnDateTime);
  } else {
    $("#returnDateTime").datetimebox(
      "setValue",
      formatDate(new Date()) +
        " " +
        new Date().toString().split(" ")[4].slice(0, 5)
    );
  }
}
function clearGMModal() {
  $("#bedCode").combobox("clear");
  $("#typeDR").combobox("clear");
  $("#regNo").val("");
  $("#name").val("");
  $("#outDateTime").datetimebox(
    "setValue",
    formatDate(new Date()) +
      " " +
      new Date().toString().split(" ")[4].slice(0, 5)
  );
  $("#rowId").val("");
  $("#entourage").val("");
  $("#remarks").val("");
  $("#returnDateTime").datetimebox("clear");
}
function saveGMRow() {
  var id = $("#rowId").val();
  var episodeID = $("#bedCode").combobox("getValue");
  var typeDR = $("#typeDR").combobox("getValue");
  var outDateTime = $("#outDateTime").datetimebox("getValue");
  var entourage = $("#entourage").val();
  var remarks = $("#remarks").val();
  var returnDateTime = $("#returnDateTime").datetimebox("getValue");
  if (!episodeID)
    return $.messager.popover({ msg: $g("��ѡ���ߣ�"), type: "alert" });
  if (!typeDR)
    return $.messager.popover({ msg: $g("��ѡ�����ͣ�"), type: "alert" });
  if (!outDateTime)
    return $.messager.popover({ msg: $g("��ѡ�������ʱ�䣡"), type: "alert" });
  if (
    new Date(
      standardizeDate(outDateTime.split(" ")[0]) +
        " " +
        outDateTime.split(" ")[1]
    ).valueOf() > new Date().valueOf()
  )
    return $.messager.popover({
      msg: $g("������ʱ�䲻�ܴ��ڵ�ǰʱ�䣡"),
      type: "alert",
    }); //����ţ�2293734
  if (entourage && entourage.toString().length > 50)
    return $.messager.popover({
      msg: $g("��ͬ��Ա������50�֣�"),
      type: "alert",
    });
  if (remarks && remarks.toString().length > 500)
    return $.messager.popover({ msg: $g("��ע������500�֣�"), type: "alert" });
  if (returnDateTime) {
    if (
      new Date(
        standardizeDate(returnDateTime.split(" ")[0]) +
          " " +
          returnDateTime.split(" ")[1]
      ).valueOf() > new Date().valueOf()
    )
      return $.messager.popover({
        msg: $g("�ز���ʱ�䲻�ܴ��ڵ�ǰʱ�䣡"),
        type: "alert",
      }); //����ţ�2293734
    if (
      new Date(
        standardizeDate(outDateTime.split(" ")[0]) +
          " " +
          outDateTime.split(" ")[1]
      ).valueOf() >
      new Date(
        standardizeDate(returnDateTime.split(" ")[0]) +
          " " +
          returnDateTime.split(" ")[1]
      ).valueOf()
    )
      return $.messager.popover({
        msg: $g("�ز���ʱ�䲻���ڳ�����ʱ�䣡"),
        type: "alert",
      });
  }
  var data = {
    id: id,
    episodeID: episodeID,
    typeDR: typeDR,
    outDateTime: outDateTime,
    entourage: entourage,
    returnDateTime: returnDateTime,
    remarks: remarks,
  };
  var res = $cm(
    {
      ClassName: "Nur.NIS.Service.Trace.Manage",
      MethodName: "AddOrUpdatePatientTrace",
      dataType: "text",
      data: JSON.stringify(data),
    },
    false
  );
  if (parseInt(res) >= 0) {
    $.messager.popover({ msg: $g("����ɹ���"), type: "success" });
    if (id) {
      $("#QLAssessEditWin").window("close");
    }
    clearGMModal();
  } else {
    $.messager.popover({ msg: $g(res), type: "alert" });
    return false;
  }
}
function deleteGMRow() {
  var gmObj = $("#gooutmanage");
  var row = gmObj.datagrid("getSelected");
  console.log(row);
  if (!row) {
    $.messager.popover({ msg: $g("����ѡ���У�"), type: "alert" });
    return false;
  }
  var index = gmObj.datagrid("getRowIndex", row);
  console.log(index);
  $.messager.confirm($g("ɾ��"), $g("ȷ��Ҫɾ�����е����ݣ�"), function (r) {
    if (r) {
      if (row.id) {
        var res = $cm(
          {
            ClassName: "Nur.NIS.Service.Trace.Manage",
            MethodName: "DeletePatientTrace",
            ID: row.id,
          },
          false
        );
        console.log(res);
        if (0 == res) {
          $.messager.popover({ msg: $g("ɾ���ɹ���"), type: "success" });
          getGMTableData();
        } else {
          $.messager.popover({ msg: JSON.stringify(res), type: "alert" });
          return false;
        }
      } else {
        var curInd = gmObj.datagrid("getRowIndex", row);
        gmObj.datagrid("deleteRow", curInd);
      }
    }
  });
}
function selectGMRow(curInd, row) {
  console.log(arguments);
  if (row.voidFlag) {
    $('#voidBtn').linkbutton({
      text:$g('ȡ������'),
      iconCls:'icon-cancel-order',
    });
  }else{
    $('#voidBtn').linkbutton({
      text:$g('����'),
      iconCls:'icon-cancel',
    });
  }
}
function toggleGMRow() {
  var gmObj = $("#gooutmanage");
  var row = gmObj.datagrid("getSelected");
  console.log(row);
  if (!row) {
    $.messager.popover({ msg: $g("����ѡ���У�"), type: "alert" });
    return false;
  }
  var title="����",content="ȷ��Ҫ���ϴ��е����ݣ�";
  if (row.voidFlag) {
    title="ȡ������";
    content="ȷ��Ҫȡ�����ϴ��е����ݣ�";
  }
  var index = gmObj.datagrid("getRowIndex", row);
  console.log(index);
  $.messager.confirm($g(title), $g(content), function (r) {
    if (r) {
      if (row.id) {
        var res = $cm(
          {
            ClassName: "Nur.NIS.Service.Trace.Manage",
            MethodName: "ToggleVoidPatientTrace",
            ID: row.id,
          },
          false
        );
        console.log(res);
        if (0 == res) {
          $.messager.popover({ msg: $g(title+"�ɹ���"), type: "success" });
          getGMTableData();
        } else {
          $.messager.popover({ msg: JSON.stringify(res), type: "alert" });
          return false;
        }
      } else {
        var curInd = gmObj.datagrid("getRowIndex", row);
        gmObj.datagrid("deleteRow", curInd);
      }
    }
  });
}
function findMultiTempData(e, v) {
  console.log(arguments);
}
// ��������ѡ������ֵ
function setDateboxOption() {
  // var now = new Date();
  // var startDate=$("#startDate").datebox('getValue'),endDate=$("#endDate").datebox('getValue');
  // var startOpt=$("#startDate").datebox('options'),endOpt=$("#endDate").datebox('options');
  // if (!startDate||!endDate) return;
  // startOpt.maxDate = endDate;
  // endOpt.minDate = startDate;
  // endOpt.maxDate = endOpt.formatter(now);
}
// ��׼������
function standardizeDate(day) {
  var y = dateformat.indexOf("YYYY");
  var m = dateformat.indexOf("MM");
  var d = dateformat.indexOf("DD");
  var str =
    day.slice(y, y + 4) + "/" + day.slice(m, m + 2) + "/" + day.slice(d, d + 2);
  return str;
}
// ��ʽ������
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

function printBtn()
{
	var wardDesc=tkMakeServerCall("Nur.NIS.Service.Trace.Manage","getWardDesc",session['LOGON.WARDID']);
	var dateTime=getServerTime();	
	var TypeDesc="";
	var headStr="<thead><th width='40px'>����</th><th width='85px'>�ǼǺ�</th><th width='85px'>����</th><th>����</th><th width='70px'>������ʱ��</th><th width='70px'>�ز���ʱ��</th><th width='80px'>��ͬ��Ա</th><th width='80px'>����Ǽǻ�ʿ</th><th width='70px'>����Ǽ�ʱ��</th><th width='80px'>���صǼǻ�ʿ</th><th width='70px'>���صǼ�ʱ��</th><th>��ע</th></thead>";
	//var footStr="<tfoot style='border: none;'><td></td><td></td><td colspan='2'>��ӡʱ��:"+dateTime.date+" "+dateTime.time+"</td></tfoot>";
	var footStr="";
	var rows=$('#gooutmanage').datagrid('getRows');
	if(rows.length>0){
		var rowStr="<tbody>";
		rows.forEach(function(row){
      TypeDesc=traceTypeObj[row.typeDR];
			rowStr=rowStr+'<tr>'+'<td>'+row.bedCode+'</td>'+'<td>'+row.regNo+'</td>'+'<td>'+row.name+'</td>'+'<td>'+TypeDesc+'</td>'+'<td>'+row.outDateTime+'</td>'+'<td>'+row.returnDateTime+'</td>'+'<td>'+row.entourage+'</td>'+'<td>'+row.outRecorder+'</td>'+'<td>'+row.outDateTime+'</td>'+'<td>'+row.returnRecorder+'</td>'+'<td>'+row.returnRecordDateTime+'<td>'+row.remarks+(row.voidFlag?'�����ϣ�':'')+'</td>'+'</tr>';
		});
		rowStr=rowStr+"</tbody>";
		var strHTML = '<table style="border: 1px solid black; border-image: none; border-collapse: collapse;" border="1">'+headStr+rowStr+footStr+"</table>";
		var LODOP=getLodop();
		LODOP.PRINT_INITA("0.53mm", "0mm", "211.67mm", "158.75mm", "�����Ա��ϸ");
		LODOP.SET_PRINT_PAGESIZE(2, 0, 0, "A4");
		LODOP.ADD_PRINT_TEXT(20,400,200,80,"�����Ա��ϸ");
		LODOP.SET_PRINT_STYLEA(0,"FontSize",19);
		LODOP.SET_PRINT_STYLEA(0,"Alignment",2);
		LODOP.SET_PRINT_STYLEA(0,"Bold",1);
		LODOP.ADD_PRINT_TEXT(55,60,300,22,"����:"+(wardDesc||session['LOGON.CTLOCDESC']));
		LODOP.SET_PRINT_STYLEA(0,"FontSize",12);
		LODOP.ADD_PRINT_TABLE("20mm","10mm","270mm","180mm",strHTML);
		LODOP.SET_PRINT_STYLEA(0,"TableHeightScope",1);
		LODOP.PREVIEW();
	}
	else{
		$.messager.popover({msg: '��ѡ��Ҫ��ӡ�����ݣ�',type:'alert'});
	}
}

function updateDomSize() {
  var innerHeight = window.innerHeight;
  $("#multiVSPanel").panel("resize", {
    height: innerHeight - 8,
  });
  setTimeout(function() {
    $("#gooutmanage").datagrid("resize", {
      height: innerHeight - 92,
    });
  }, 300);
}
window.addEventListener("resize", updateDomSize);
