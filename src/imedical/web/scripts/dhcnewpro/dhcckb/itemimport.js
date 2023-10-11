//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2020-12-17
// ����:	   ֪ʶ����
//===========================================================================================

/// ҳ���ʼ������
function initPageDefault(){
	
	/// ����ҳ��DataGrid
	InitBmDetList();
	
	/// ҳ����Ӧ�¼�
	//InitPageEvent();
	
}

/// ҳ����Ӧ�¼�
/* function InitPageEvent(){
	
	$(".bt-messager-popover").click(function(){
		$("#bmDetList").datagrid("reload",{"Params":this.id});
	})
}*/
/// ����ҳ��DataGrid
function InitBmDetList(){
	///  ����columns
	var columns=[[
		{field:'ItemId',title:'ID',width:150,hidden:true},
		{field:'IsDiff',title:'����Ա�',width:120,align:'center',formatter:setCellLabel},
		{field:'ItemCode',title:'����',width:120,align:'center'},
		{field:'ItemDesc',title:'����',width:360},
		{field:'Manf',title:'����',width:260},
		{field:'Form',title:'����',width:120,align:'center'},
		{field:'RelTime',title:'����ʱ��',width:160,align:'center'},
		{field:'Source',title:'��Դ',width:160}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onDblClickRow: function (rowIndex, rowData) {

        },
		onLoadSuccess:function(data){
	
			/// ��ʶ����
            if (typeof data.ALL == "undefined"){return;}
        	$("#ALL label").text(data.ALL);
			$("#DIFF label").text(data.DIFF);
			$("#ADD label").text(data.ADD);
		}
	};
	/// ��������
	var param = "";
	var uniturl = $URL+"?ClassName=web.DHCCKBRuleUpdCompareToLibrary&MethodName=JsGetImpItemList&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// ��ȡ�ļ�
function read(){
	var files=$("input[name=file9]").val();
	runClassMethod("web.DHCCKBRuleUpdCompareToLibrary","ImportGlobal",{"Global":"TMPExportDrugRule",FilePath:files},function(jsonString){
		if (jsonString == 0){
			$.messager.alert("��ʾ:","����ɹ���","info");
			$("input[name=file9]").val("");
			reload();
		}
	},'',false)
}


/// ���¶�ȡ
function reload(){
	$("#bmDetList").datagrid("reload");
}

/// һ������
function importRule(){
	alert(LoginInfo)
	/* runClassMethod("web.DHCCKBRuleUpdCompareToLibrary","GetImportIncRuleByruleDescDemo",{"loginInfo":LoginInfo},function(jsonString){
		if (jsonString == -1){
			$.messager.alert("��ʾ:","����ʧ�ܣ�","warning");
			return;
		}
		if (jsonString == 0){
			$.messager.alert("��ʾ:","����ɹ���","info");
			$("#bmDetList").datagrid("reload");
		}
	},'',false) */
}

/// �������
function setCellLabel(value, rowData, rowIndex){
	var html = "";
	if (value == 1){                                                                                        
		//html = '<a href="javascript:void(0);" style="color:red;font-weight:bold" onclick="showRuleDetWin('+rowData.ItemId+',"'+rowData.ItemCode+'")">�������</a>';
		html = '<a href="javascript:void(0);" style="color:red;font-weight:bold" onclick="showRuleDetWin('+rowData.ItemId+',\''+rowData.ItemCode+'\')">�������</a>';
	}
	return html;
}

/// �������
function showRuleDetWin(itemId,itemCode){
	
	commonShowWin({
		url:"dhcckb.rulecheck.csp?itemId="+itemId+"&itemCode="+encodeURI(encodeURI(itemCode)),
		title:"ҩƷ�������",
		width: (window.screen.availWidth - 20),
		height: (window.screen.availHeight - 150)
	})
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })