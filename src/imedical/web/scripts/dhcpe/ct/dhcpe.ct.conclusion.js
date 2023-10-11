//����	dhcpe.ct.conclusion.js
//����	ϵͳ���� - ְҵ����� - ְҵ�����۷���
//����	2021-08-04
//������  zhongricheng

$(function(){
	InitConclusionDataGrid();
	
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
		BClear_click();
	});
});

// �޸�
function BUpdate_click() {
	BSave_click("1");
}

// ����
function BAdd_click() {
	BSave_click("0");
}

// ����
function BSave_click(Type) {
	if (Type == "1") {
		var ID = $("#ID").val();
		if(ID == "") {
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
		}
	}
	if (Type == "0") {
		if($("#ID").val() != "") {
			$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,�����������������","info");
			return false;
		}
		var ID = "";
	}
	
	var Code = $("#Code").val();
	if ("" == Code) {
		$("#Code").focus();
		$HUI.validatebox("#Code", {required: true});
		$.messager.alert("��ʾ", "���벻��Ϊ��", "info");
		return false;
	}
	var Desc = $("#Desc").val();
	if ("" == Desc) {
		$("#Desc").focus();
		$HUI.validatebox("#Desc", {required: true});
		$.messager.alert("��ʾ","���۷��಻��Ϊ��","info");
		return false;
	}
	
	var ExpInfo = $("#ExpInfo").val();
	var Remark = $("#Remark").val();
	var Severity = $("#Severity").numberbox('getValue');
	
	var ID = $("#ID").val();
	var check = $("#Active").checkbox('getValue');
	var Active = check?"Y":"N";
	
	var Str = Code+"^"+Desc+"^"+Active+"^"+""+"^"+ExpInfo+"^"+Severity+"^"+Remark;
	
	$.cm({
		ClassName:"web.DHCPE.CT.Conclusion",
		MethodName:"UpdateConclusion",
		ID:ID,
		InfoStr:Str,
		CTLOCID:session["LOGON.CTLOCID"],
		USERID:session["LOGON.USERID"]
	}, function(jsonData){
		if (jsonData.code == "-1") {
			$.messager.alert("��ʾ", jsonData.msg, "error");
		} else {
			if (Type=="1") $.messager.alert("��ʾ", "�޸ĳɹ�", "success");
			if (Type=="0") $.messager.alert("��ʾ", "�����ɹ�", "success");
			BClear_click();
		}
	});
}

//ɾ��
function BDelete_click() {
	var RowId = $("#ID").val();
	if (RowId == "") {
		$.messager.alert("��ʾ","����ѡ���ɾ���ļ�¼","info");	
		return false;
	}
	
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			$.cm({
				ClassName:"web.DHCPE.CT.Conclusion",
				MethodName:"DeleteConclusion",
				ID:RowId
			}, function(jsonData){
				if (jsonData.code == "-1") {
					$.messager.alert("��ʾ", "ɾ��ʧ��:" + jsonData.msg, "error");  
				} else {
					$.messager.alert("��ʾ", "ɾ���ɹ�", "success");
					BClear_click();
				}
			});	
		}
	});
}

//����
function BClear_click() {
	$("#ID, #Code, #Desc, #ExpInfo, #Remark").val("");
	$("#Severity").numberbox('setValue','');
	$(".hisui-checkbox").checkbox('setValue',false);
	$HUI.validatebox("#Code,#Desc", {required: false,});
	
	$("#ConclusionQueryTab").datagrid('load',{
		ClassName:"web.DHCPE.CT.Conclusion",
		QueryName:"FindConclusion"
	});
}

function InitConclusionDataGrid() {
	$HUI.datagrid("#ConclusionQueryTab",{
		url: $URL,
		fit: true,
		border: false,
		striped: true,
		fitColumns: false,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		pageList: [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.CT.Conclusion",
			QueryName:"FindConclusion",
		},
		columns:[[
		    {field:'TRowId',title:'TRowId',hidden: true},
			{field:'TCode',width:'120',title:'����'},
			{field:'TDesc',width:'200',title:'���۷���'},
			{field:'TSeverity',width:'80',title:'���س̶�',align:'center'},
			{field:'TActive',width:'60',title:'����',align:'center', formatter:function(val, row, ind){
					return val=="Y"?"��":"��"
				}
			},
			{field:'TExpInfo',width:'300',title:'��չ��Ϣ'},
			{field:'TRemark',width:'500',title:'��ע'}
		]],
		onSelect:function(rowIndex, rowData) {
			$("#ID").val(rowData.TRowId);
			$("#Code").val(rowData.TCode);
			$("#Desc").val(rowData.TDesc);
			$("#Severity").numberbox('setValue',rowData.TSeverity);
			$("#ExpInfo").val(rowData.TExpInfo);
			$("#Remark").val(rowData.TRemark);
			
			var check = rowData.TActive=="Y"?true:false;
			$("#Active").checkbox('setValue',check);
		}
	});
}