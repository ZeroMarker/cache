/**
 * Description�����񼶱�ά��
 * FileName: dhcpe.ct.serviceclass.js
 * @Author   wangguoying
 * @DateTime 2021-08-10
 */
var _SessionStr = session['LOGON.USERID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.CTLOCID'] + "^" + session['LOGON.HOSPID'];
var _tableNme = "DHC_HM_CServiceClass";


/**
 * [��ʼ�������б�]
 * @Author   wangguoying
 * @DateTime 2021-08-10
 */
function initSCDatagrid(){
	$("#SCID").val("");
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"] ;
	$HUI.datagrid("#SCList", {
		url: $URL,
		title: "",
		bodyCls: 'panel-body-gray',
		border: false,
		queryParams: {
			ClassName: "web.DHCPE.CT.HM.BaseDataSet",
			QueryName: "GetCServiceClassNew",
			LocID : locId
		},
		onSelect: function(rowIndex, rowData) {
			if (rowIndex > -1) {
				//ClearBtn_onclick();
				$("#SCID,#Code,#Desc,#Price,#Months,#Remark").val("");
				$("#Active").checkbox("check");

				QClear_onclick();
				$("#QRList").datagrid("load",{
					ClassName: "web.DHCHM.BaseDataSet",
					QueryName: "GetCSCQLink",
					theid: rowData.ID,
					LocID:$("#LocList").combobox("getValue")
				});
				$("#SCID").val(rowData.ID);
				$("#Code").val(rowData.SCCode);
				$("#Desc").val(rowData.SCDesc);
				$("#Price").val(rowData.SCPrice);
				$("#Months").val(rowData.SCMonths);
				$("#Remark").val(rowData.SCRemark);
				if (rowData.SCActive == "true") {
					$("#Active").checkbox("check");
				} else {
					$("#Active").checkbox("uncheck");
				}
				if (rowData.TEmpower == "Y") {
					$("#Empower").checkbox("check");
				} else {
					$("#Empower").checkbox("uncheck");
				}
			}
			
		},
		onDblClickRow: function(index, row) {},
		columns: [
			[{
				field: 'ID',
				hidden: true,
				sortable: 'true'
			}, {
				field: 'SCCode',
				width: 100,
				title: '����'
			}, {
				field: 'SCDesc',
				width: 150,
				title: '����'
			}, {
				field: 'SCActive',
				width: 40,
				title: '����',
				align: 'center',
				formatter: function(value, row, index) {
					var checked = value == "true" ? "checked" : "";
					return "<input type='checkbox' disabled class='hisui-checkbox' " + checked + " >";
				}
			},{
				field:'TEmpower',width:90,title:'������Ȩ',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			
			},{ 
				field:'TEffPowerFlag',
				width:'100',
				align:'center',
				title:'��ǰ������Ȩ',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
					return '<input type="checkbox" value="" disabled/>';
				 }
				}
			}, {
				field: 'SCPrice',
				width: 100,
				title: '����۸�'
			}, {
				field: 'SCMonths',
				width: 150,
				title: '��ü��ʱ��(��)'
			}, {
				field: 'SCRemark',
				width: 200,
				title: '��ע'
			}]
		],
		toolbar:[{
			iconCls: 'icon-key',
			
			text: '���ݹ�������',
			handler: function(){relateLocWin();}
		}],
		fitColumns: true,
		pagination: true,
		pageSize: 20,
		fit: true,
		rownumbers: true
	});
	initQRDataGrid();
}

/**
 * [��Ȩ����]
 * @Author   wangguoying
 * @DateTime 2021-08-11
 */
function relateLocWin(){	
	var row = $("#SCList").datagrid("getSelected");
	if(row == null){
		$.messager.popover({type:"alert",msg:"δѡ���¼"});
		return false;
	} 
	//������Ȩ 
	if(row.TEmpower!="Y"){
		 $.messager.popover({type:"alert",msg:"�ü�¼û������Ȩ,���ܹ������ң�"});
		 return false;
	}
	
    var LocID=$("#LocList").combobox('getValue')
    OpenLocWin(_tableNme,row.ID,_SessionStr,LocID,initSCDatagrid);
}


function initQRDataGrid(){
	$HUI.datagrid("#QRList", {
		url: $URL,
		title: "",
		bodyCls: 'panel-body-gray',
		queryParams: {
			ClassName: "web.DHCHM.BaseDataSet",
			QueryName: "GetCSCQLink",
			theid: $("#SCID").val(),
			LocID:$("#LocList").combobox("getValue")
		},
		onSelect: function(rowIndex, rowData) {
			if (rowIndex > -1) {
				QClear_onclick();
				$("#QRID").val(rowData.ID);
				$("#Questionnaire").combobox("setValue", rowData.SCQLCQuestionnaireDR);
				$("#QSeq").val(rowData.SCQLOrder);
				$("#QRemark").val(rowData.SCQLRemark);
			}
		},
		onDblClickRow: function(index, row) {},
		columns: [
			[{
				field: 'ID',
				hidden: true,
				sortable: 'true'
			}, {
				field: 'SCQLCQuestionnaireDR',
				hidden: true
			}, {
				field: 'QDesc',
				width: 200,
				title: '�ʾ�'
			}, {
				field: 'SCQLOrder',
				width: 60,
				title: '˳��'
			}, {
				field: 'SCQLRemark',
				width: 100,
				title: '��ע'
			}]
		],
		fitColumns: true,
		pagination: true,
		pageSize: 20,
		fit: true,
		rownumbers: true
	});
}

/**
 * �������
 * @Author   wangguoying
 * @DateTime 2019-06-10
 */
function ClearBtn_onclick() {
	
	$("#SCID").val("");
	$("#Code").val("");
	$("#Desc").val("");
	$("#Price").val("");
	$("#Months").val("");
	$("#Remark").val("");
	$("#Active").checkbox("check");
	$("#Empower").checkbox("uncheck");
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"];
	$("#SCList").datagrid("load",{
		ClassName: "web.DHCPE.CT.HM.BaseDataSet",
		QueryName: "GetCServiceClassNew",
		LocID:locId
	});
	$("#QRList").datagrid("load",{
			ClassName: "web.DHCHM.BaseDataSet",
			QueryName: "GetCSCQLink",
			theid:"",
			LocID:$("#LocList").combobox("getValue")
	});


}

/**
 * ��ౣ��
 * @Author   wangguoying
 * @DateTime 2019-06-10
 */
function SaveBtn_onclick() {
	var ID = $("#SCID").val();
	var Code = $("#Code").val();
	var Desc = $("#Desc").val();
	var Price = $("#Price").val();
	var Months = $("#Months").val();
	var Remark = $("#Remark").val();
	var Active = "N";
	if ($("#Active").checkbox("getValue")) {
		Active = "Y";
	}
	if (Code == "") {
		$.messager.alert("��ʾ", "���벻��Ϊ��", "info");
		return false;
	}
	if (Desc == "") {
		$.messager.alert("��ʾ", "��������Ϊ��", "info");
		return false;
	}
	//������Ȩ 
	var iEmpower = "N";
	if ($("#Empower").checkbox("getValue")) {
		iEmpower = "Y";
	}
	
	var proStr = "SCActive^SCCode^SCDesc^SCMonths^SCPrice^SCRemark";
	var valStr = Active + "^" + Code + "^" + Desc + "^" + Months + "^" + Price + "^" + Remark;
	var UserID = session['LOGON.USERID'];
	try {
		var ret = tkMakeServerCall("web.DHCPE.CT.HM.CommonData", "SaveSrvClass", ID, proStr,valStr,$("#LocList").combobox("getValue"),UserID,iEmpower);
		if (parseInt(ret) < 0) {
			var errMsg = ret.split("^").length > 1 ? ":" + ret.split("^")[1] : "";
			$.messager.alert("����", "����ʧ��" + errMsg, "error");
			return false;
		} else {
			$.messager.popover({msg: '����ɹ�',type:'success',timeout: 1000});
			
			ClearBtn_onclick();
		}
	} catch (err) {
		$.messager.alert("����", "����ʧ�ܣ�" + err.description, "error");
		return false;
	}
}
/**
 * �Ҳ�����
 * @Author   wangguoying
 * @DateTime 2019-06-10
 */
function QClear_onclick() {
	$("#QRID").val("");
	$("#Questionnaire").combobox("setValue", "");
	$("#QSeq").val("");
	$("#QRemark").val("");
}
/**
 * ��������ʾ�
 * @Author   wangguoying
 * @DateTime 2019-06-10
 */
function QSave_onclick() {
	var ID = $("#QRID").val();
	var SCID = $("#SCID").val();
	var Questionnaire = $("#Questionnaire").combobox("getValue");
	var QSeq = $("#QSeq").val();
	var QRemark = $("#QRemark").val();
	if (SCID == "") {
		$.messager.alert("��ʾ", "����������Ϊ��", "info");
		return false;
	}
	if (Questionnaire == "") {
		$.messager.alert("��ʾ", "�����ʾ���Ϊ��", "info");
		return false;
	}
	if (QSeq == "") {
		$.messager.alert("��ʾ", "��Ų���Ϊ��", "info");
		return false;
	}
	var property = "SCQLParRef^SCQLCQuestionnaireDR^SCQLOrder^SCQLRemark";
	var valList = SCID + "^" + Questionnaire + "^" + QSeq + "^" + QRemark;
	try {
		var ret = tkMakeServerCall("web.DHCHM.BaseDataSet", "CSCQLinkSaveData", ID, valList, property);
		if (parseInt(ret) < 0) {
			var errMsg = ret.split("^").length > 1 ? ":" + ret.split("^")[1] : "";
			$.messager.alert("����", "����ʧ��" + errMsg, "error");
			return false;
		} else {
			$.messager.popover({msg: '����ɹ�',type:'success',timeout: 1000});
			$("#QRList").datagrid("load",{
				ClassName: "web.DHCHM.BaseDataSet",
				QueryName: "GetCSCQLink",
				theid: SCID,
				LocID :$("#LocList").combobox("getValue")
			});
			QClear_onclick();
		}
	} catch (err) {
		$.messager.alert("����", "����ʧ�ܣ�" + err.description, "error");
		return false;
	}
}
/**
 * ɾ�������ʾ�
 * @Author   wangguoying
 * @DateTime 2019-06-10
 */
function QDeleter_onclick() {
	var ID = $("#QRID").val();
	var SCID = $("#SCID").val();
	if (ID == "") {
		$.messager.alert("��ʾ", "��ѡ����Ҫɾ������", "info");
		return false;
	}
	$.messager.confirm("ɾ��", "ȷ��ɾ����¼?", function(r) {
		if (r) {
			try {
				var ret = tkMakeServerCall("web.DHCHM.BaseDataSet", "CSCQLinkDelete", ID);
				if (parseInt(ret) < 0) {
					var errMsg = ret.split("^").length > 1 ? ":" + ret.split("^")[1] : "";
					$.messager.alert("����", "ɾ��ʧ��" + errMsg, "error");
					return false;
				} else {
					$.messager.popover({msg: 'ɾ���ɹ�',type:'success',timeout: 1000});
					$("#QRList").datagrid("load",{
						ClassName: "web.DHCHM.BaseDataSet",
						QueryName: "GetCSCQLink",
						theid: SCID,
						LocID: $("#LocList").combobox("getValue")
					});
					QClear_onclick();
				}
			} catch (err) {
				$.messager.alert("����", "ɾ��ʧ�ܣ�" + err.description, "error");
				return false;
			}
		} else {

		}
	});

}

function init_questionnaire(){
	var globalLoc = $("#LocList").combobox("getValue");
	var locId = globalLoc != "" ? globalLoc : session["LOGON.CTLOCID"] ;
	$HUI.combobox("#Questionnaire",{
		url:$URL+"?ClassName=web.DHCPE.CT.HM.CommonData&QueryName=FindQuestionnaire&Active=Y&LocID="+locId+"&ResultSetType=array",
		valueField:'QNID',
		textField:'QDesc',
		onSelect:function(record){
		}
	});
}

function init() {
	GetLocComp(_SessionStr);
	//���������б�change
	$("#LocList").combobox({
		onSelect: function() {
			initSCDatagrid();
			init_questionnaire();
		}
	});
	
}


$(init);
