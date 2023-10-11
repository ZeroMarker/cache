//����	dhcpe.ct.ometype.js
//����	ϵͳ���� - ְҵ����� - ְҵ�����������
//����	2021-08-12
//������  zhongricheng

var lastIndex = "";
var EditIndex = -1;
var tableName = "DHC_PE_OMEType";
var SessionStr = session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID'];

$(function(){
	InitOMETypeDataGrid();
	
    //����
	$("#BAdd").click(function() {
		BAdd_click();
	});
	
    //�޸�
	$("#BUpdate").click(function() {
		BUpdate_click();
	});
	
    //����
	$("#BSave").click(function() {
		BSave_click();
	});
	
    //����
	$("#BClear").click(function() {
		BClear_click();
	});
	
    //��ѯ
	$("#BFind").click(function() {
		BFind_click();
	});
})

//����
function BAdd_click() {
	lastIndex = $("#OMETypeQueryTab").datagrid("getRows").length - 1;
	$("#OMETypeQueryTab").datagrid("selectRow", lastIndex);
	var selected = $("#OMETypeQueryTab").datagrid("getSelected");
	if (selected) {
		if (selected.TID == "") {
			$.messager.alert("��ʾ", "����ͬʱ��Ӷ���!", "info");
			return;
		}
	}
	if (EditIndex >= 0) {
		$.messager.alert("��ʾ", "һ��ֻ���޸�һ����¼", "info");
		return;
	}
	$("#OMETypeQueryTab").datagrid("appendRow", {
		TID:"",
		TCode:"",
		TDesc:"",
		TActive:"",
		TExpInfo:"",
		TRemark:""
	});
	lastIndex = $("#OMETypeQueryTab").datagrid("getRows").length - 1;
	$("#OMETypeQueryTab").datagrid("selectRow", lastIndex);
	$("#OMETypeQueryTab").datagrid("beginEdit", lastIndex);
	EditIndex = lastIndex;
}

//�޸�
function BUpdate_click() {
	var selected = $("#OMETypeQueryTab").datagrid("getSelected");
	
	if (selected) {
		var thisIndex = $("#OMETypeQueryTab").datagrid("getRowIndex", selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert("��ʾ", "һ��ֻ���޸�һ����¼", "info");
			return false;
		}
		$("#OMETypeQueryTab").datagrid("selectRow", thisIndex);
		$("#OMETypeQueryTab").datagrid("beginEdit", thisIndex);
		EditIndex = thisIndex;
	} else {
		$.messager.alert("��ʾ", "��ѡ����޸ĵļ�¼", "info");
		return false;
	}
}

//����
function BSave_click() {
	$("#OMETypeQueryTab").datagrid("acceptChanges");
	var selected = $("#OMETypeQueryTab").datagrid("getSelected");
	if (selected) {
		var obj = $("#OMETypeQueryTab").datagrid("getEditor", {index:EditIndex, field:"TCode"});
		if (obj) var Code = obj.target.val().replace(new RegExp(" ","g"),"");
		else var Code = selected.TCode.replace(new RegExp(" ","g"),"");
		
		var obj = $("#OMETypeQueryTab").datagrid("getEditor", {index:EditIndex, field:"TDesc"});
		if (obj) var Desc = obj.target.val().replace(new RegExp(" ","g"),"");
		else var Desc = selected.TDesc.replace(new RegExp(" ","g"),"");
		
		if (Code == undefined || Code == "undefined" || Code == "" || Desc == undefined || Desc == "undefined" || Desc == "") {
			$.messager.alert("��ʾ", "����д������", "info");
			$("#OMETypeQueryTab").datagrid("reload");
			return false;
		}
		
		if (selected.TID == "") {
		}
		
		var ID = selected.TID;
		var Active = selected.TActive;
		var ExpInfo = selected.TExpInfo;
		var Remark = selected.TRemark;
		
		var Str = Code + "^" + Desc + "^" + Active + "^" + ExpInfo + "^" +Remark;
		$.cm({
			ClassName:"web.DHCPE.CT.OMEType",
			MethodName:"UpdateOMEType",
			ID:ID,
			InfoStr:Str
		}, function(jsonData){
			if (jsonData.success == 0) {
				$.messager.alert("��ʾ", jsonData.msg, "error");
			} else if (jsonData.code == "-1") {
				$.messager.alert("��ʾ", jsonData.msg, "error");
			} else {
				if (ID != "") $.messager.popover({msg:'�޸ĳɹ���', type:'success', timeout:2000});
				else $.messager.popover({msg:'�����ɹ���', type:'success', timeout:2000});
			}
			BClear_click();
		});
	}
}

//����
function BClear_click() {
	$("#ID,#Code,#Desc").val("");
	$("#Active").checkbox("setValue",true);
	
	$("#OMETypeQueryTab").datagrid('load',{
		ClassName:"web.DHCPE.CT.OMEType",
		QueryName:"SearchOMEType",
		Active:$("#Active").checkbox("getValue")?"Y":"N"
	});	
}

function BFind_click() {
	$("#OMETypeQueryTab").datagrid('load',{
		ClassName:"web.DHCPE.CT.OMEType",
		QueryName:"SearchOMEType",
		Code:$("#Code").val(),
		Desc:$("#Desc").val(),
		Active:$("#Active").checkbox("getValue")?"Y":"N"
	});	
}

function InitOMETypeDataGrid() {
	$HUI.datagrid("#OMETypeQueryTab",{
		url:$URL,
		fit:true,
		border:false,
		striped:true,
		fitColumns:false,
		autoRowHeight:false,
		rownumbers:true,
		pagination:true,
		pageSize:25,
		pageList:[25,50,100,200],
		singleSelect:true,
		selectOnCheck:true,
		queryParams:{
			ClassName:"web.DHCPE.CT.OMEType",
			QueryName:"SearchOMEType",
			Active:$("#Active").checkbox("getValue")?"Y":"N"
		},
		columns:[[
		    {field:'TID', title:'TID', hidden:true},
			{field:'TCode', title:'����', width:'160', editor:'text', resizable:true,
				editor:{
					type: 'validatebox',
					options: {
						required: true
					}
				}
			},
			{field:'TDesc', title:'�������', width:'200', editor:'text', resizable:true,
				editor:{
					type: 'validatebox',
					options: {
						required: true
					}
				}
			},
			{field:'TActive', title:'����', width:'80', align:'center',
				formatter:function(val, row, ind){
					return val=="Y"?"��":"��"
				}, editor:{
					type: 'checkbox',
					options: {
						on:'Y',
						off:'N'
					}
				}
			},
			{field:'TExpInfo', title:'��չ��Ϣ', width:'320', editor:'text', resizable:true},
			{field:'TRemark', title:'��ע', width:'400', editor:'text', resizable:true}
		]],
		onSelect: function(rowIndex, rowData) {
			$("#ID").val(rowData.TID);
			//$("#BUpdate").linkbutton("enable");
			//$("#BSave").linkbutton("enable");
		},
		onLoadSuccess: function(data) {
			EditIndex = -1;
		}	
	});
}