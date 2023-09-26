//����	DHCPEEDCheckCriteria.hisui.js
//����	�Ӻ�������ϱ�׼ά��
//����	2020.02.14
//������  zhongricheng
//ҳ�� dhcpeedcheckcriteria.hisui.csp

$(function() {
	InitCombobox();
	
	InitEDCheckCriteriaGrid();
	
    // �޸�
	$("#BUpd").click(function() {
		BUpd_click();
    });
    
    // ����
	$("#BAdd").click(function() {
		BAdd_click();
    });
    
    // ɾ��
	$("#BDel").click(function() {
		BDel_click();
    });
    
    // ����
	$("#BClear").click(function() {
		BClear_click();
	});
});

// �޸�
function BUpd_click() {
	BSave_click("1");
}

// ����
function BAdd_click() {
	BSave_click("0");
}

function BSave_click(Type) {
	var ID = $("#ID").val();
	if(Type == "1") {
		if(ID == "") {
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
		}
	}
	
	if(Type == "0") {
	    if(ID != "") {
		   	$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,�����������������", "info");
		   	return false;
		}
	}
	var Code = $("#Code").val();
	
	if(Code == "") {
		var valbox = $HUI.validatebox("#Code", {
			required: true,
	    });
		$.messager.alert("��ʾ","���벻��Ϊ��","info");
		return false;
	}
	
	var DCDR = $("#DiagnosticCriteria").combogrid("getValue");
	if(DCDR == "") {
		$.messager.alert("��ʾ","��ϱ�׼����Ϊ��","info");
		return false;
	}
	
	var OMETypeDR = $("#OMEType").combobox('getValue');
	if (OMETypeDR == undefined || OMETypeDR == "") {
		$.messager.alert("��ʾ", "��ѡ��������", "info");
		return false;
	}

	var ExpInfo = $("#ExpInfo").val();
	var Remark = $("#Remark").val();
	var Parref = $.trim(selectrow);
	var iActive = "N";
	var Active = $("#Active").checkbox('getValue');
	if (Active) iActive = "Y";
	
	var Str = Parref + "^" + Code + "^" + DCDR + "^" + OMETypeDR + "^" + iActive + "^" + ExpInfo + "^" + Remark;
	//alert(Str)
	var rtn = tkMakeServerCall("web.DHCPE.Endanger", "EDCheckCriteriaSave", ID, Str);
	var Arr = rtn.split("^");
	if (Arr[0]=="-1"){
		if(Type=="1") $.messager.alert("��ʾ", "�޸�ʧ��", "error");
		if(Type=="0") $.messager.alert("��ʾ", "����ʧ��", "error");
	} else {
		BClear_click();
		if(Type=="1") { $.messager.popover({msg: '�޸ĳɹ���', type:'success', timeout: 1000}); }
		if(Type=="0") { $.messager.popover({msg: '�����ɹ���', type:'success', timeout: 1000}); }
	}
}

//ɾ��
function BDel_click() {
	var ID = $("#ID").val();
	if (ID == "") {
		$.messager.alert("��ʾ","��ѡ���ɾ���ļ�¼","info");
		return false;
	}
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r) {
		if (r) {
			$.m({ ClassName:"web.DHCPE.Endanger", MethodName:"EDCheckCriteriaDelete", ID:ID}, function(ReturnValue){
				if (ReturnValue.split("^")[0] == '-1') {
					$.messager.alert("��ʾ","ɾ��ʧ��","error");  
				} else {
					$.messager.popover({msg: 'ɾ���ɹ���', type:'success', timeout: 1000});
					BClear_click();
				}
			});	
		}
	});
}

function BClear_click(){
	$("#ID,#Code,#ExpInfo,#Remark").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	$(".hisui-combobox").combobox('setValue',"");
	$(".hisui-combogrid").combogrid('setValue',"");

	var valbox = $HUI.validatebox("#Code", { required: false, });
	$("#EDCheckCriteriaGrid").datagrid('reload');	
}

function InitCombobox(){
	//�������
	var OMETypeObj = $HUI.combobox("#OMEType",{
		url:$URL+"?ClassName=web.DHCPE.Endanger&QueryName=OMETypeList&ResultSetType=array",
		valueField:'ID',
		textField:'OMET_Desc',
		defaultFilter:4
	});
	
	//��ϱ�׼
	var OMETypeObj = $HUI.combogrid("#DiagnosticCriteria",{
		panelWidth:450,
		url:$URL+"?ClassName=web.DHCPE.Endanger&QueryName=CheckCriteriaList&Active=Y",
		mode:'remote',
		delay:200,
		idField:'TID',
		textField:'TDesc',
		fit:true,
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		columns:[[
		    {field:'TID',title:'TID',hidden:true},
			{field:'TCode',title:'����',width:50},
			{field:'TDesc',title:'��ϱ�׼'} 	
		]],
		onLoadSuccess:function(){
			//$("#Illness").combogrid('setValue',""); 
		},
	});
}

function InitEDCheckCriteriaGrid(){
	$HUI.datagrid("#EDCheckCriteriaGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SearchEDCheckCriteria",
			Parref:$.trim(selectrow),
		},
		border : false,
		striped : true,
		fit:true,
		fitColumns:true,
		animate:true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		columns:[[
		    {field:'TID', title:'TID', hidden:true},
		    {field:'TDCDR', title:'TDCDR', hidden:true},
		    
			{field:'TCode', width:'60', title:'����'},
			{field:'TDiagnosticCriteria', width:'300', title:'��ϱ�׼'},
			{field:'TOMEType', width:'80', title:'�������'},
			{field:'TActive', width:'40', title:'����', align:'center',
				formatter:function (value, rowData, rowIndex) {
					if (value == "Y") { return "��"; }
					else { return "��"; }
				}
			},
			{field:'TExpInfo', width:'100', title:'��չ��Ϣ'},
			{field:'TRemark', width:'200', title:'��ע'},
		]],
		onSelect: function (rowIndex, rowData) {
		    $("#ID").val(rowData.TID);
			$("#Code").val(rowData.TCode);
			$("#DiagnosticCriteria").combogrid('setValue',rowData.TDCDR);
			$("#OMEType").combobox('setValue',rowData.TOMETypeDR);
			$("#ExpInfo").val(rowData.TExpInfo);
			$("#Remark").val(rowData.TRemark);
			if(rowData.TActive == "Y" || rowData.TActive == "��") {
				$("#Active").checkbox('setValue',true);
			} else {
				$("#Active").checkbox('setValue',false);
			};
		}
	});
}