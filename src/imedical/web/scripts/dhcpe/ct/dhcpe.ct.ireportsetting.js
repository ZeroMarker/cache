// dhcpe/ct/dhcpe.ct.ireportsetting.js
// dhcpe.ct.ireportsetting.csp

var TheCode = $("#TheCode").val();
var TheLocId = $("#LocID").val();
	
var WIDTH = $("#myPanel").width();
$("#myEastPanel").css("width", (WIDTH-250)*0.49);

$(function() {
	$("#ConfigAdd,#ParamAdd,#ExtendAdd,#ConfigUpd,#ParamUpd,#ExtendUpd").click(function() {
		UpdData(this);
	});
	
	InitDatagrid("Config", "REPORTDATA");
	InitCombobox();
});

function UpdData(btn) {
	var Base = btn.id.substring(0, btn.id.length-3);
	var Type = btn.id.substring(btn.id.length-3, btn.id.length);
	BClear_click(Base);
	$("#EditWin").show();
	
	if (Type == "Upd" ) {
		if (!GetData(Base)) {
			return false;
		}
	}
	
	var myWin = $HUI.dialog("#EditWin", {
		iconCls: (Type == "Add")?"icon-w-add":"icon-w-edit",
		resizable: true,
		title: (Type == "Add"?"����":"����") + "-" + (Base == "Config"?"��������":(Base == "Param"?"��������":(Base == "Extend"?"��չ����":""))),
		modal: true,
		buttonAlign: "center",
		buttons: [{
			text: "����",
			handler: function() {
				Update(Base, Type);
			}
		}, {
			text: "�ر�",
			handler: function() {
				myWin.close();
			}
		}]
	});
}

function GetData(Base) {
	var SelRowData = $("#" + Base + "Data").datagrid("getSelected");
	if (!SelRowData) { 
		$.messager.alert("��ʾ","��ѡ����޸ĵ�" + (Base == "Config"?"��������":(Base == "Param"?"��������":(Base == "Extend"?"��չ����":""))) + "��", "info"); 
		return false; 
	}
	
	$cm({
		ClassName: "web.DHCPE.CT.ReportSetting",
		MethodName: "GetRptSetting",
		Id: SelRowData.TId
	}, function(data) {
		if (data.code == "0") {
			$("#CodeWin").val(data.data.Code);
			$("#DescWin").val(data.data.Desc);
			$("#TitleWin").val(data.data.Title);
			var type = data.data.ParamType;
			if (type == "") type = "T"
			$("#TypeWin").combobox("setValue", type);
			$("#ValueWin").val(data.data.Value);
			$("#RemarkWin").val(data.data.Remark);
		} else {
			$.messager.popover({msg: '��ȡ����ʧ�ܣ�' + data.msg, type: 'error'});
		}
	});
	return true;
}

function Update(Base, Type) {
	var PId = "", OId = "";
	if (Type == "Upd") {
		var SelRowData = $("#" + Base + "Data").datagrid("getSelected");
		if (!SelRowData) { 
			$.messager.alert("��ʾ", "��ѡ����޸ĵ�" + (Base == "Config"?"��������":(Base == "Param"?"��������":(Base == "Extend"?"��չ����":""))) + "��", "info"); 
			return false; 
		}
		OId = SelRowData.TId;
	}
	
	var prtTab = (Base == "Param"?"Config":(Base == "Extend"?"Param":""));
	var cidTab = (Base == "Config"?"Param":(Base == "Param"?"Extend":""));
	if (prtTab == "") {
		if (Base != "Config") {
			$.messager.alert("��ʾ", "�޶���ID���޷�����" + (Base == "Config"?"��������":(Base == "Param"?"��������":(Base == "Extend"?"��չ����":""))) + "��", "info"); 
			return false; 
		}
		PId = TheCode;
	} else {
		var prtSelRowData = $("#" + prtTab + "Data").datagrid("getSelected");
		if (!prtSelRowData) { 
			$.messager.alert("��ʾ", "δѡ��" + (prtTab == "Config"?"��������":(prtTab == "Param"?"��������":(prtTab == "Extend"?"��չ����":""))) +"���޷�����" + (Base == "Config"?"��������":(Base == "Param"?"��������":(Base == "Extend"?"��չ����":""))) + "��", "info"); 
			return false; 
		}
		PId = prtSelRowData.TId;
	}
	if (PId == "") {
		$.messager.alert("��ʾ", "�޶���ID���޷�����" + (Base == "Config"?"��������":(Base == "Param"?"��������":(Base == "Extend"?"��չ����":""))) + "��", "info"); 
		return false; 
	}
	
	var Code = $("#CodeWin").val();
	if (Code == "") {
		$.messager.popover({msg: '���벻��Ϊ�գ�' + data.msg, type: 'alert'});
		return false;
	}
	
	var Desc = $("#DescWin").val();
	if (Desc == "") {
		$.messager.popover({msg: '���벻��Ϊ�գ�' + data.msg, type: 'alert'});
		return false;
	}
	
	var Title = $("#TitleWin").val();
	var Type = $("#TypeWin").combobox("getValue");
	var Value = $("#ValueWin").val();
	var Remark = $("#RemarkWin").val();
	
	// ����  ����  ��ʾ  ����  ����ID  ��������  ����ֵ  ��ע
	var Strs = Code + "^" + Desc + "^" + Title + "^" + TheLocId + "^" + PId + "^" + Type + "^" + Value + "^" + Remark;
	$cm({
		ClassName: "web.DHCPE.CT.ReportSetting",
		MethodName: "UpdRptSetting",
		Id: OId,
		Strs: Strs
	}, function(data) {
		if (data.code == "0") {
			$.messager.popover({msg: '����ɹ���', type: 'success'});
			$("#" + Base + "Data").datagrid("reload");
			$("#" + cidTab + "Data").datagrid("loadData", {total:0, rows:[]});
		} else {
			$.messager.popover({msg: '����ʧ�ܣ�' + data.msg, type: 'error'});
		}
	});
}

function BClear_click(Base) {
	$("#CodeWin,#DescWin,#TitleWin,#ValueWin,#RemarkWin").val("");
	$("#TypeWin").combobox("setValue","");
	if (Base == "Config") {
		$("#ValueWin,#RemarkWin").attr("disabled", "disabled");
		$("#TypeWin").combobox("disable");
	} else {
		$("#ValueWin,#RemarkWin").removeAttr("disabled");
		$("#TypeWin").combobox("enable");
	}
}

function InitDatagrid(Base, BaseId) {
	if (Base == "" || BaseId == "") return false;
	
	var HiddenFlag = false;
	if (isNaN(BaseId)) HiddenFlag = true;
	
	$HUI.datagrid("#" + Base + "Data", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.CT.ReportSetting",
			QueryName:"SearchRptSetting",
			BaseId:BaseId,
			LocID:TheLocId
		},
		collapsible: true, //�����������
		lines: true,
		striped: true, // ���ƻ�
		pagination:true,
		pageSize:50,
		pageList:[50,100,200],
		showPageList:false,
		//showRefresh:true,
		//beforePageText:'',
		//afterPageText:'ҳ/{pages}ҳ',
		displayMsg:'��{total}��',
		rownumbers: true,
		border: false,
		fit: true,
		fitColumns: true,
		animate: true,
		singleSelect: true,
		
		columns:[[
			{field:'TId', title:'TId', hidden:true},
			{field:'TParamType', title:'����', hidden:true},
			{field:'TCode', title:'TCode', width:120, hidden:HiddenFlag},
			{field:'TDesc', title:'����', width:120, formatter: function(value, rowData, rowIndex) {
				var title = rowData.TTitle;
				return "<a id='" + Base + "_" + rowData.TCode + "' href='#' title='"
						+ title
						+ "' class='hisui-tooltip' data-options='position:\"right\",showDelay:50' style='text-decoration: none;color: black;'>"
						+ value + "</a>";
				}
			},
			{field:'TParamTypeDesc', title:'����', width:70, hidden:HiddenFlag},
			{field:'TValue', title:'ֵ', width:120, hidden:HiddenFlag},
			{field:'TRemark', title:'��ע', width:150, hidden:HiddenFlag}
		]],
		onClickRow: function (rowIndex, rowData) {  // ѡ�����¼�
			var nBTable = (Base == "Config"?"Param":(Base == "Param"?"Extend":""));
			InitDatagrid(nBTable, rowData.TId);
			
			if (nBTable != "") {
				try { $("#" + "Extend" + "Data").datagrid("loadData", {total:0, rows:[]}); } catch (e) { }
			}
		},
		onDblClickRow: function (rowIndex, rowData) {  // ˫�����¼�
		},
		onLoadSuccess: function(data){
		}
	});
}

function InitCombobox() {
	// ��������	
	$HUI.combobox("#TypeWin", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'T',text:'�ı�'},
			{id:'E',text:'��չ'},
			{id:'C',text:'�Զ���'}
		]
	});
}