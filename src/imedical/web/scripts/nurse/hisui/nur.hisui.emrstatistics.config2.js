var GV = {
	_CALSSNAME: "Nur.NIS.Service.ReportV2.ConfigService",
};
var PageLogicObj={
	defaultHosId : "2",
	connectionLocList : [],
	emrTemplateList : []
}
$.extend($.fn.datagrid.methods, {
  getEditingRowIndexs: function(jq) {
    var rows = $.data(jq[0], "datagrid").panel.find('.datagrid-row-editing');
    var indexs = [];
    rows.each(function(i, row) {
      var index = row.sectionRowIndex;
      if (indexs.indexOf(index) == -1) {
          indexs.push(index);
      }
    });
    return indexs;
  }
});
$(function () {
	// ����ȫ����������
	initCondition(PageLogicObj.defaultHosId);
	var resultLocData = $cm({
	    ClassName:GV._CALSSNAME,
	    MethodName:"NurseCtloc",
	    hospitalId:$("#_HospList").combobox("getValue")
	},false);
	PageLogicObj.connectionLocList=resultLocData
	// ���ز���ģ��
	var resultEmrData = $cm({
	    ClassName:GV._CALSSNAME,
	    MethodName:"GetEmrTemplateList",
	    hospitalId:$("#_HospList").combobox("getValue")
	},false);	
	PageLogicObj.emrTemplateList=resultEmrData
		
	setDataGridLoad(PageLogicObj.defaultHosId, "1"); // �����б�����
	SearchGridLoadInit("1")
	ResetDomSize();
});

// ��ѯ
$("#search").click(function () {
	refresh();
});
//ҳ��
window.addEventListener("resize", ResetDomSize);


function refresh()
{	
	var value = $("#_HospList").combobox("getValue");
	var HospitalId = value ? value : "";			
	// ���ز���ģ��
	//reloadEmrData(HospitalId);
	//ͬ�����ز���ģ��
	PageLogicObj.emrTemplateList=$cm({
		ClassName:GV._CALSSNAME,
		MethodName:"GetEmrTemplateList",
		hospitalId:HospitalId
	},false);
	PageLogicObj.connectionLocList=$cm({
	    ClassName:GV._CALSSNAME,
	    MethodName:"NurseCtloc",
	    hospitalId:HospitalId
	},false);
	//���¼��ز���ģ��������ر��
	setDataGridLoad(HospitalId, "");
	$('#appendReport').linkbutton("enable");
	SearchGridLoadInit("");

}
/**
 * @description �첽���ز���ģ��
 */
function reloadEmrData(HospitalId)
{
	$cm({
		ClassName:GV._CALSSNAME,
		MethodName:"GetEmrTemplateList",
		hospitalId:HospitalId
	},function(result){
		PageLogicObj.emrTemplateList=result
	});
}
/**
 * @description ��ʼ����ѯ������
 */
function initCondition(defaultHosId) {
  /*
  $("#_HospList").combobox({
    url:
      $URL +
      "?1=1&ClassName=" +
      GV._CALSSNAME +
      "&QueryName=GetHospitalList&ResultSetType=array",
    valueField: "HospitalId",
    textField: "HospitalDesc",
    defaultFilter: 4,
    onLoadSuccess: function () {
      $("#_HospList").combobox("setValue", PageLogicObj.defaultHosId); // ����Ĭ��ҽԺ
    },
  });
  */
  
    try
	{
		// ��Ժ��
		var sessionInfo = session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"];
		var hospComp = GenHospComp("Nur_IP_Question",sessionInfo);
		hospComp.jdata.options.onSelect = function(e,t){
			refresh();
		}
		hospComp.jdata.options.onLoadSuccess= function(data){

		}
	}catch(ex)
	{
	  // ��������Ŀ���Ƕ�Ժ���ĳ���
	  $("#_HospList").combobox({
	    url:
	      $URL +
	      "?1=1&ClassName=" +
	      GV._CALSSNAME +
	      "&QueryName=GetHospitalList&ResultSetType=array",
	    valueField: "HospitalId",
   		textField: "HospitalDesc",
	    defaultFilter: 4,
	    width:250,
	    value:(session['LOGON.HOSPID']||PageLogicObj.defaultHosId),
	    onSelect:function(e,t){
		    refresh();
		},
		onLoadSuccess:function(data){

		}
	  });
	}
}

// �б����ݼ���
function setDataGridLoad(HospitalId, flag) {
	if (flag==1)
	{
		$("#appendReport").click(function () {
			addReportConfig();
			$('#appendReport').linkbutton("disable");
		}).linkbutton({ iconCls: "icon-add", plain: true });
		$("#saveReport").click(function () {
			saveReportConfig();
		}).linkbutton({ iconCls: "icon-save", plain: true });
		$("#deleteReport").click(function () {
			delReportConfig();
		}).linkbutton({ iconCls: "icon-cancel", plain: true });
	}

	var tmpRowData = undefined;
	var defaultPageSize = 25;
	var defaultPageList = [25, 50, 100, 200, 500];
	var setColumns = [[
	{ field: 'rowId',hidden: true },
	{ field: 'connectLocIds', hidden: true  },
	{ field: "templateId", hidden: true },
	{ field: "name", title: "¼��ģ��", width: 250, 
		editor: {
				type: "combobox",
				options: {
					valueField: "id",
					textField: "desc",
					defaultFilter: 4,
					multiple:false,
					selectOnNavigation:false,
					data:PageLogicObj.emrTemplateList,
					/*
					data:$cm({
						ClassName:GV._CALSSNAME,
						MethodName:"GetEmrTemplateList",						
						hospitalId:$("#_HospList").combobox("getValue")?$("#_HospList").combobox("getValue"):""
						},false),
					*/
					filter: function(q, row){        //�������ݽ������ݼ���  q���Դ��Ĳ�������   �����remoteǰ���ǲ���Ҫ������̨�Զ�����
			            var opts = $(this).combobox('options');
			            var dbval = row[opts.textField] + ""
			            return dbval.indexOf(q) > -1;
			        }
				},
			},
			formatter:function(v,row,index){
				// var resultdesc = getComboboxText(emrTemplateList,row.name)
				return row.name;
			}
	},
	{ field: "shortName", title: "ģ����", width: 80, editor: "validatebox" },
	{ field: "dateItem", title: "����Item", width: 120, editor: "validatebox",
		// 2022.1.10 ���ڳ������д���
		formatter:function(v,row,index){
			 return '<span style="word-break:break-all;">'+v+'</span>';		
		}
	},
	{ field: "scoreItem", title: "��ֵItem", width: 80, editor: "validatebox" },
	{ field: "connectLocs", title: "��������", width: 200, 
		editor: {
				type: "combobox",
				options: {
					valueField: "id",
					textField: "desc",
					defaultFilter: 4,
					multiple:true,
					rowStyle:'checkbox',
					selectOnNavigation:false,
					data:PageLogicObj.connectionLocList
				},
			},
			formatter:function(v,row,index){ 
				var resultdesc = getComboboxText(PageLogicObj.connectionLocList,row.connectLocs)
				return resultdesc;
			}
	},
	{ field: "sortNo", title: "����", width: 40, editor: "validatebox" }
	]];
	$("#reportList").datagrid({
		url: $URL,
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		//pageSize: defaultPageSize,
		//pageList: defaultPageList,
		queryParams: {
			ClassName: GV._CALSSNAME,
			QueryName: "GetTemplateList",
			HospitalId: HospitalId
		},
		fit: true,
		fitColumns: true,
		columns: setColumns,
		rownumbers: true,
		singleSelect: true,
		nowrap:false,
		loadMsg: "������..",
		onDblClickCell: function (index, field, value) {
			if (endEditing()) {
				// ���û���
				setLocValues(index);
				
				$("#reportList")
				.datagrid("selectRow", index)
				.datagrid("beginEdit", index);
				editIndex = index;
			}
		},
		onClickRow: function (rowIndex, rowData) {
			GetReportConfig();
		},
		onLoadSuccess:function(){
			//$(this).datagrid('enableDnd');
		},
		onBeforeEdit: function (index, row) {
             tmpRowData = row;
         },
		//��ק�� onDrop:function(targetRow,sourceRow,point){}
	});
}

function getComboboxText(datalist,values)
{
	var re = /^[0-9]+.?[0-9]*/;
	var res = ""
	if (values && values != "")
	{
		var arr = values.split(",");
		var oneval = values.split(",")[0]
		// ��ֵ
		if (re.test(oneval))
		{
			for (j=0;j<arr.length;j++)
			{
				var sval = arr[j]
				for (i=0;i<datalist.length;i++)
				{
					var obj = datalist[i]
					if (sval == obj.id)
					{
						if (res=="")
						{
							res = obj.desc
						}else
						{
							res = res+","+obj.desc	
						}
					}
				}
			}
		}else
		{
			res = values;	
		}
	}
	return res;
}

function refreshLocData()
{
	var ed1 = $('#reportList').datagrid('getEditor', {index:editIndex,field:'connectLocIds'});
	var val=$(ed1.target).val();
	var ed = $('#reportList').datagrid('getEditor', {index:editIndex,field:'connectLocs'});
	$(ed.target).combobox('setValues',val.split("^"));	
}

function setLocValues(rowIndex)
{
	var selectedRow = $("#reportList").datagrid('getSelected');
	$('#reportList').datagrid('beginEdit', rowIndex); // ��ʼ�༭
	var ed = $('#reportList' ).datagrid( 'getEditor',{index:rowIndex,field:'connectLocs'});
	$(ed.target).combobox('setValues',selectedRow.connectLocIds.split("^"));
	$('#reportList').datagrid('endEdit', rowIndex); // �����༭	
}

// �ж�ѡ�񱨱�
function checkSelectReportRow() {
	var id = getSelectRowId();
	if (id == "") {
		$.messager.popover({ msg: "��ѡ�񱨱�", type: "error" });
		return false;
	}
	return true;
}

// ��ȡѡ���֢״
function getSelectRowId() {
	var selectId = "";
	var rows = $("#reportList").datagrid("getSelections");
	if (rows.length > 0) {
		var selectId = rows[0].rowId;
	}
	return selectId;
}

// �Ҳ��б����ݼ���
function SearchGridLoadInit(flag) {
	if (flag == 1)
	{
		$("#appendSearch").click(function () {
		addSearchConfig();
		}).linkbutton({ iconCls: "icon-add", plain: true });
		$("#saveSearch").click(function () {
			saveSearchConfig();
		}).linkbutton({ iconCls: "icon-save", plain: true });
		$("#deleteSearch").click(function () {
			delSearchConfig();
		}).linkbutton({ iconCls: "icon-cancel", plain: true });
	}
	
	var setColumns = [[
			{ field: 'rowId', title: 'rowId',hidden: true },
			{ field: "conditionDesc", title: "��������", width: 100, editor: "validatebox"},
			{ field: "conditionExp", title: "���ֹ�ʽ", width: 100, editor: "validatebox" },
			{ field: "recordFlag", title: "ͳ��ģʽ", width: 100, 
				editor: {
						type: "combobox",
						options: {
							valueField: "id",
							textField: "desc",
							defaultFilter: 4,
							multiple:false,
							rowStyle:'checkbox',
							selectOnNavigation:false,
							editable:false,
							data:[{"id":"R","desc":"R"},{"id":"P","desc":"P"}]
						},
					}
			},
			{ field: "sortNo", title: "����", width: 50, editor: "validatebox" }
	]];
	$("#searchList").datagrid({
		pagination: false, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		fit: true,
		fitColumns: true,
		columns: setColumns,
		rownumbers: true,
		singleSelect: true,
		loadMsg: "������..",
		url:$URL,
		queryParams: {
			ClassName: GV._CALSSNAME,
			QueryName: "GetSubCfgList",
			pafRowId: "",
		},
		onDblClickCell: function (index, field, value) {
			if (endEditing2()) {
				$("#searchList")
				.datagrid("selectRow", index)
				.datagrid("beginEdit", index);
				editIndex2 = index;
			}
		}
	});
}

// ��ȡ������������
function GetReportConfig()
{
	var rows = $("#reportList").datagrid("getSelections");
	if (rows.length == 1) {
		InitSearchGridLoad(rows[0].rowId);
	}
}

// �������������б����ݼ���
function InitReportGridLoad() {
	var value = $("#_HospList").combobox("getValue");
	var HospitalId = value ? value : PageLogicObj.defaultHosId
	setDataGridLoad(HospitalId, ""); 
	$('#appendReport').linkbutton("enable");
	/*
	$cm({
	    ClassName:GV._CALSSNAME,
	    MethodName:"GetReportList",
	    HospitalId: HospitalId,
	},function(jsonData){
	    $("#reportList").datagrid("loadData", Data);
	});
	*/
	
	/*
	$.q(
		{
		ClassName: GV._CALSSNAME,
		QueryName: "GetReportList",
		HospitalId: HospitalId,
		Pagerows: $("#reportList").datagrid("options").pageSize,
		rows: 99999,
		},
		function (Data) {
			$("#reportList").datagrid("loadData", Data);
		}
	);
	*/
}

// �������������б����ݼ���
function InitSearchGridLoad(pafRowId) {
	$.q(
		{
		ClassName: GV._CALSSNAME,
		QueryName: "GetSubCfgList",
		pafRowId: pafRowId,
		Pagerows: $("#searchList").datagrid("options").pageSize,
		rows: 99999,
		dataType: "json",
		},
		function (Data) {
			$("#searchList").datagrid("loadData", Data);
		}
	);
}

var editIndex = undefined;
function endEditing() {
	if (editIndex == undefined) {
		return true;
	}
	if ($("#reportList").datagrid("validateRow", editIndex)) {
		$("#reportList").datagrid("endEdit", editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
//���������������
function addReportConfig() {
	$("#reportList").datagrid("appendRow", { status: "P" });
	editIndex = $("#reportList").datagrid("getRows").length - 1;
	$("#reportList").datagrid("selectRow", editIndex)
	.datagrid("beginEdit", editIndex);
}

function isNumber(str)
{
   // ������֤��
   var reg = new RegExp("^[0-9]*$");
   if(reg.test(str)){
   		return true;
   }
   return false;
}
//�����������ݱ���
function saveReportConfig() {
	var value = $("#_HospList").combobox("getValue");
	var hospitalId = value ? value : PageLogicObj.defaultHosId
	var index=$('#reportList').datagrid('getEditingRowIndexs')[0];
	if (undefined===index) return true;
	var curRow=$('#reportList').datagrid('getRows')[index];
	var rowEditors=$('#reportList').datagrid('getEditors',index);
	var rowId=curRow.rowId||'';
	var newTempId=$(rowEditors[0].target).combobox('getValue');
    if (!newTempId) newTempId=$(rowEditors[0].target).combobox('getText');
	var templateId = newTempId;
	var shortName=$(rowEditors[1].target).val();
	var dateItem=$(rowEditors[2].target).val();
	var scoreItem=$(rowEditors[3].target).val();
	var connectLocs=$(rowEditors[4].target).combobox('getValues').join();
	var sortNo=$(rowEditors[5].target).val();
	$cm(
		{
			ClassName: GV._CALSSNAME,
			MethodName: "SaveTemplateInfo",
			dataType: "text",
			hospitalId:hospitalId,
			rowId: rowId,
			templateId:templateId,
			shortName:shortName,
			dateItem:dateItem,
			scoreItem:scoreItem,
			connectLocs:connectLocs,
			sortNo:sortNo
		},
		function (result) {
			if (result == 0) {
				endEditing();
				$.messager.popover({ msg: "����ɹ���", type: "success" });
				InitReportGridLoad()
			} else {
				$.messager.popover({ msg: $g(result), type: "error" });
			}
		}
	);
}
//������������ɾ��
function delReportConfig() {
var rows = $("#reportList").datagrid("getSelections");
if (rows.length == 1) {
	$.messager.confirm("ɾ��", "ȷ��ɾ����?", function (r) {
	if (r) {
			var rowId = rows[0].rowId;
			$.m(
			{
				ClassName: GV._CALSSNAME,
				MethodName: "DeleteReportInfo",
				rowId: rowId,
			},
			function testget(result) {
				//$("#add-dialog").dialog( "close" );
				if (result == "0") {
					$.messager.alert("����ʾ", "ɾ���ɹ���", "success");
					InitReportGridLoad()
				} else {
				$.messager.alert("����ʾ", "ɾ��ʧ�ܣ�", "error");
				}
			}
			);
	 	}
		});
	} else {
		$.messager.alert("����ʾ", "��ѡ��Ҫɾ��������", "info");
	}
}

	var editIndex2 = undefined;
function endEditing2() {
	if (editIndex2 == undefined) {
		return true;
	}
	if ($("#searchList").datagrid("validateRow", editIndex2)) {
		$("#searchList").datagrid("endEdit", editIndex2);
		editIndex2 = undefined;
		return true;
	} else {
		return false;
	}
}
//�������������������
function addSearchConfig() {
	if (checkSelectReportRow())
	{
		$("#searchList").datagrid("appendRow", { status: "P" });
		editIndex2 = $("#searchList").datagrid("getRows").length - 1;
		$("#searchList").datagrid("selectRow", editIndex2)
		.datagrid("beginEdit", editIndex2);
	}
}

// �ж�str�Ƿ�ȫ���ַ�
function isFullWidth(str) {
    var reg = /[^\x00-\xff]/g;
    return reg.test(str);
}

// �ж�str�Ƿ����һ��������ĸ
function isAlphabet(str) {
    var reg = /[a-zA-Z]/g;
    return reg.test(str);
}

//���������������ݱ���
function saveSearchConfig() {
if (endEditing2()) {
	var dataSourceRow = $("#searchList").datagrid("getSelected");
	var parentId = getSelectRowId()
	var conditionDesc = dataSourceRow.conditionDesc;
	var conditionExp = dataSourceRow.conditionExp;
	// ȫ�ǻ�����У��
	if (isFullWidth(conditionExp))
	{
		$.messager.popover({ msg: "���ֹ�ʽ��������ȫ���ַ���", type: "error" });
		return;
	}
	// ��ĸУ��
	if (isAlphabet(conditionExp))
	{
		$.messager.popover({ msg: "���ֹ�ʽ����������ĸ��", type: "error" });
		return;
	}
	var sortNo = dataSourceRow.sortNo;
	var rowId = dataSourceRow.rowId;
	var recordFlag = dataSourceRow.recordFlag
	$m(
		{
			ClassName: GV._CALSSNAME,
			MethodName: "SaveConditionInfo",
			rowId: rowId,
			parentId:parentId,
			conditionDesc: conditionDesc,
			conditionExp: conditionExp,
			recordFlag:recordFlag,
			sortNo: sortNo
		},
		function (result) {
			if (result == 0) {
				$.messager.popover({ msg: "����ɹ���", type: "success" });
				InitSearchGridLoad(parentId)
			} else {				
				$.messager.popover({ msg: result, type: "error" });
				InitSearchGridLoad(parentId)
			}
		}
	);
  }
}

//����������������ɾ��
function delSearchConfig() {
	var rows = $("#searchList").datagrid("getSelections");
	if (rows.length == 1) {
		$.messager.confirm("ɾ��", "ȷ��ɾ����?", function (r) {
		if (r) {
			var rowId = rows[0].rowId;
			$.m(
			{
				ClassName: GV._CALSSNAME,
				MethodName: "DeleteConditionInfo",
				rowId: rowId,
			},
			function testget(result) {
				//$("#add-dialog").dialog( "close" );
				if (result == "0") {
					$.messager.alert("����ʾ", "ɾ���ɹ���", "success");
					var reportId = getSelectRowId()
					InitSearchGridLoad(reportId)
				} else {
				$.messager.alert("����ʾ", "ɾ��ʧ�ܣ�", "error");
				}
			}
			);
	 	}
		});
	} else {
		$.messager.alert("����ʾ", "��ѡ��Ҫɾ��������", "info");
	}
}
function ResetDomSize() {
    $(".hisui-layout").layout("resize").layout('panel', 'center').panel('resize', {
        height: '100%',
        width: '100%'
    });
    //var east = $(".hisui-layout").layout('panel', 'center').layout('panel', 'east');
    //var center =  $(".hisui-layout").layout('panel', 'center').layout('panel', 'center');
}
/**
 * linkbutton������չ
 * @param {Object} jq
 */
$.extend($.fn.linkbutton.methods, {
    /**
     * ����ѡ�������д��
     * @param {Object} jq
     */
    enable: function(jq){
        return jq.each(function(){
            var state = $.data(this, 'linkbutton');
            if ($(this).hasClass('l-btn-disabled')) {
                var itemData = state._eventsStore;
                //�ָ�������
                if (itemData.href) {
                    $(this).attr("href", itemData.href);
                }
                //�ظ�����¼�
                if (itemData.onclicks) {
                    for (var j = 0; j < itemData.onclicks.length; j++) {
                        $(this).bind('click', itemData.onclicks[j]);
                    }
                }
                //����targetΪnull����մ洢���¼��������
                itemData.target = null;
                itemData.onclicks = [];
                $(this).removeClass('l-btn-disabled');
            }
        });
    },
    /**
     * ����ѡ�������д��
     * @param {Object} jq
     */
    disable: function(jq){
        return jq.each(function(){
            var state = $.data(this, 'linkbutton');
            if (!state._eventsStore)
                state._eventsStore = {};
            if (!$(this).hasClass('l-btn-disabled')) {
                var eventsStore = {};
                eventsStore.target = this;
                eventsStore.onclicks = [];
                //��������
                var strHref = $(this).attr("href");
                if (strHref) {
                    eventsStore.href = strHref;
                    $(this).attr("href", "javascript:void(0)");
                }
                //����ֱ����ϰ󶨵�onclick�����ϵ��¼�
                var onclickStr = $(this).attr("onclick");
                if (onclickStr && onclickStr != "") {
                    eventsStore.onclicks[eventsStore.onclicks.length] = new Function(onclickStr);
                    $(this).attr("onclick", "");
                }
                //����ʹ��jquery�󶨵��¼�
                var eventDatas = $(this).data("events") || $._data(this, 'events');
                if (eventDatas["click"]) {
                    var eventData = eventDatas["click"];
                    for (var i = 0; i < eventData.length; i++) {
                        if (eventData[i].namespace != "menu") {
                            eventsStore.onclicks[eventsStore.onclicks.length] = eventData[i]["handler"];
                            $(this).unbind('click', eventData[i]["handler"]);
                            i--;
                        }
                    }
                }
                state._eventsStore = eventsStore;
                $(this).addClass('l-btn-disabled');
            }
        });
    }
});