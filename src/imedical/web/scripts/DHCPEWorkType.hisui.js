//����	DHCPEWorkType.hisui.js
//����	����ά��
//����	2019.05.07
//������  xy
AddFlag = "N";
$(function(){
	InitWorkTypeDataGrid();
	
    //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
    });
	
    //�޸�
	$("#BUpdate").click(function() {	
		BUpdate_click();		
    });
    
    //����
	$("#BAdd").click(function() {	
		BAdd_click();		
    });
     
    //ɾ��
	$("#BDelete").click(function() {	
		BDelete_click();		
    });
    
    //����
	$("#BClear").click(function() {	
		BClear_click("0");		
    });
});

//��ѯ
function BFind_click() {
	$("#WorkTypeQueryTab").datagrid('load', {
		ClassName:"web.DHCPE.WorkType",
		QueryName:"SearchWorkType",
		Code:$("#Code").val(),
		Desc:$("#Desc").val(),
		Active:$("#Active").checkbox("getValue")?"Y":"N"
	});
}

//�޸�
function BUpdate_click() {
	BClear_click("1");
	var rowData = $("#WorkTypeQueryTab").datagrid("getSelected");
	if (!rowData) { 
		$.messager.alert("��ʾ","��ѡ����޸ĵĹ��֣�", "info"); 
		return false; 
	}
	$("#CodeWin").val(rowData.TCode).validatebox("validate");;
	$("#DescWin").val(rowData.TDesc).validatebox("validate");;
	$("#ExpInfoWin").val(rowData.TExpInfo);
	$("#RemarkWin").val(rowData.TRemark);
	$("#ActiveWin").checkbox('setValue', (rowData.TActive=="��"?true:false));	
	
	$("#AddWin").show();
	 
	var myWin = $HUI.dialog("#AddWin",{
		iconCls:'icon-w-update',
		resizable:true,
		title:'�޸�-' + rowData.TDesc,
		modal:true,
		onClose: function() {
			BClear_click("1");
			if (AddFlag == "Y") {
				$("#WorkTypeQueryTab").datagrid("reload");
			}
		},
		buttonAlign:'center',
		buttons:[{
			text:'�޸�',
			handler:function(){
				BSave_click("1", rowData.TID);
			}
		},{
			text:'�ر�',
			handler:function(){
				myWin.close();
			}
		}]
	});
}

 //����
function BAdd_click() {
	BClear_click("1");	
	
	$("#AddWin").show();
	 
	var myWin = $HUI.dialog("#AddWin",{
		iconCls:'icon-w-update',
		resizable:true,
		title:'����',
		modal:true,
		onClose: function() {
			BClear_click("1");
			if (AddFlag == "Y") {
				$("#WorkTypeQueryTab").datagrid("reload");
				AddFlag = "N";
			}
		},
		buttonAlign:'center',
		buttons:[{
			text:'����',
			handler:function(){
				BSave_click("0", "");
			}
		},{
			text:'�ر�',
			handler:function(){
				myWin.close();
			}
		}]
	});
}

//����
function BSave_click(Type, ID) {
	if (Type == "1" && ID == "") {
		$.messager.alert("��ʾ","��ѡ����޸ĵĹ��֣�","info");
		return false;
	}
	
	var Code = $("#CodeWin").val();
	if ("" == Code) {
		$("#CodeWin").focus();
		$HUI.validatebox("#CodeWin", { required: true });
		$.messager.alert("��ʾ","���벻��Ϊ��","info");
		return false;
	}
	
	var Desc = $("#DescWin").val();
	if ("" == Desc) {
		$("#DescWin").focus();
		var valbox = $HUI.validatebox("#DescWin", { required: true });
		$.messager.alert("��ʾ","���ֲ���Ϊ��","info");
		return false;
	}
	
	var ExpInfo = $("#ExpInfoWin").val();
	var Remark = $("#RemarkWin").val();
	
	var Active = $("#ActiveWin").checkbox("getValue")?"Y":"N";
	
	var Str = Code+"^"+Desc+"^"+Active+"^"+ExpInfo+"^"+Remark;
	
	$.m({
		ClassName:"web.DHCPE.WorkType",
		MethodName:"UpdateWorkType",
		ID:ID,
		InfoStr:Str
	},function(ret){
		var Arr = ret.split("^");
		if (Arr[0] > 0){
			//$.messager.alert("��ʾ", (Type=="0"?"����":"�޸�") + "�ɹ�", "success");
			$.messager.popover({msg: (Type=="0"?"����":"�޸�") + "�ɹ�", type: "success", timeout: 2000});
			
			if (Type == "0") BClear_click("1");
			if (Type == "1") {
				$("#AddWin").window("close");
				$("#WorkTypeQueryTab").datagrid("reload");
				AddFlag = "N";
			}
			AddFlag = "Y";
		}else{
			$.messager.alert("��ʾ", Arr[1], "error");	
		}
	});
}

//ɾ��
function BDelete_click() {
	var rowData = $("#WorkTypeQueryTab").datagrid("getSelected");
	if (!rowData) { 
		$.messager.alert("��ʾ","��ѡ���ɾ���Ĺ��֣�", "info"); 
		return false; 
	}
	var RowId = rowData.TID;
	if (RowId=="") {
		$.messager.alert("��ʾ","��ѡ���ɾ���Ĺ��֣�","info");	
		return false;
	}
	
	var rtn=tkMakeServerCall("web.DHCPE.WorkType","DeleteWorkType",RowId);
	if (rtn.split("^")[0]=="-1"){
		$.messager.alert("��ʾ","ɾ��ʧ��"+rtn.split("^")[1],"error");	
	}else{
		$("#WorkTypeQueryTab").datagrid("reload");
		$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
	}
}

//����
function BClear_click(Type) {
	if (Type == "0") {
		$("#Code,#Desc,#ExpInfo,#Remark").val("");
		$("#Active").checkbox('setValue',true);
	} else if (Type == "1") {
		$("#CodeWin,#DescWin").val("").validatebox("validate");
		$("#ExpInfoWin,#RemarkWin").val("");
		$("#ActiveWin").checkbox('setValue',false);
	}
	BFind_click()
}

function InitWorkTypeDataGrid() {
	$HUI.datagrid("#WorkTypeQueryTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.WorkType",
			QueryName:"SearchWorkType",
			Code:$("#Code").val(),
			Desc:$("#Desc").val(),
			Active:$("#Active").checkbox("getValue")?"Y":"N"
			
		},
		columns:[[
		    {field:'TID',title:'TID',hidden: true},
			{field:'TCode',width:'200',title:'����'},
			{field:'TDesc',width:'280',title:'����'},
			{field:'TActive',width:'150',title:'����'},
			{field:'TExpInfo',width:'300',title:'��չ��Ϣ'},
			{field:'TRemark',width:'250',title:'��ע'}
		]]
	});
}