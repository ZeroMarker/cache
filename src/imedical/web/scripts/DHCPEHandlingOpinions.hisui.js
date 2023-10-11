//����	DHCPEHandlingOpinions.hisui.js
//����	Σ��������ϱ�׼ά��
//����	2020.02.17
//������  zhongricheng
//ҳ�� dhcpehandlingopinions.hisui.csp

$(function () {
	InitCombobox();
	InitDataGrid();
	
	$("#BSearch").click(function() {
		BSearch_click();
    });
    
    $("#BClear").click(function() {
		BClear_click("0");
    });
});

function InitCombobox() {
	//�������
	$HUI.combobox("#OMEType, #OMETypeWin", {
		url:$URL+"?ClassName=web.DHCPE.Endanger&QueryName=OMETypeList&ResultSetType=array",
		valueField:'ID',
		textField:'OMET_Desc',
	    panelHeight:'auto', //�Զ��߶�
	    panelMaxHeight:200, //���߶�
		defaultFilter:4
	});
	
	// ������
	$HUI.combogrid("#Conclusion, #ConclusionWin", {
		url:$URL+"?ClassName=web.DHCPE.Conclusion&QueryName=FindConclusion&Active=Y&ResultSetType=array",
		panelWidth: 350,
        blurValidValue:true,
		delay:200,
        idField: 'TRowId',
        textField: 'TDesc',
        method: 'remote',
		columns:[[
		    {field:'TRowId',title:'ITRowIdD',hidden: true},
			{field:'TCode',title:'����',width:70},
			{field:'TDesc',title:'����',width:180},	
			{field:'TVIPLevel',title:'VIP�ȼ�',width:100}
		]]
	});
}

function InitDataGrid() {
	$HUI.datagrid("#HandlingOpinions", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.HandlingOpinions",
			QueryName:"QueryHO",
			Code:"",
			Conclusion:"",
			OMEType:""
		},
		method: 'get',
		idField: 'ARCOSRowid',
		treeField: 'ARCOSOrdSubCat',
		columns:[[
			{field:'TId', title:'TId', hidden:true},
			{field:'TConclusion', title:'TConclusion', hidden:true},
			{field:'TOMEType', title:'TOMEType', hidden:true},
			
			{field:'TCode', title:'����', align:'center', width:80},
			{field:'TConclusionDesc', title:'������', width:100},
			{field:'TOMETypeDesc', title:'�������', width:100},
			{field:'TDesc', title:'�������', width:500},
			
			{field:'TSort', title:'˳��', align:'center', width:40},
			{field:'TActive', title:'����', align:'center', width:40,
				formatter:function(value, rowData, rowIndex) {
					if (value == "Y") return "��";
					else return "��";
				}
			},
			{field:'TRemark', title:'��ע', width:200}
		]],
		collapsible: true, //�����������
		lines:true,
		striped:true, // ���ƻ�
		rownumbers:true,
		fit:true,
		fitColumns:true,
		animate:true,
		pagination:true,   // ���α�� ���ܷ�ҳ
		pageSize:25,
		pageList:[10,25,50,100],
		singleSelect:true,
		toolbar: [{
			iconCls: 'icon-add',
			text:'����',
			handler: function(){
				BClear_click("1");
				$("#HOWin").show();
					 
				var myWin = $HUI.dialog("#HOWin",{
					iconCls:'icon-w-add',
					resizable:true,
					title:'����',
					modal:true,
					buttonAlign:'center',
					buttons:[{
						text:'����',
						handler:function(){
							BAdd_click("Add");
						}
					},{
						text:'�ر�',
						handler:function(){
							myWin.close();
						}
					}]
				});
			}
		},{
			iconCls: 'icon-write-order',
			text:'�޸�',
			id:'BUpd',
			disabled:true,
			handler: function(){
				BClear_click("1");
				$("#HOWin").show();
				
				var SelRowData = $("#HandlingOpinions").datagrid("getSelected");
				$("#CodeWin").val(SelRowData.TCode).validatebox("validate");
				$("#ConclusionWin").combogrid("setValue",SelRowData.TConclusion);
				$("#SortWin").numberbox("setValue",SelRowData.TSort).validatebox("validate");
				$("#OMETypeWin").combobox("setValue",SelRowData.TOMEType);
				$("#RemarkWin").val(SelRowData.TRemark);
				$("#HanlingOpinionsWin").val(SelRowData.TDesc);
				
				var active=false;
				if (SelRowData.TActive == "Y") active=true;
				$("#ActiveWin").checkbox("setValue",active);
				
				var myWin = $HUI.dialog("#HOWin",{
					iconCls:'icon-w-edit',
					resizable:true,
					title:'�޸�',
					modal:true,
					buttonAlign:'center',
					buttons:[{
						text:'�޸�',
						handler:function() {
							BAdd_click("Upd");
						}
					},{
						text:'�ر�',
						handler:function() {
							myWin.close();
						}
					}]
				});
			}
		}],		
		onClickRow: function (rowIndex, rowData) {  // ѡ�����¼�
			$('#BUpd').linkbutton('enable');
		},
		onDblClickRow: function (rowIndex, rowData) {  // ˫�����¼�
		},
		onLoadSuccess:function(data) {
			
		}
	});
}

function BAdd_click(Type) {
	if (Type == "Add") {
		var Id = "";
		var Al = "����";
		var Opt = "insertRow";
		var OptIndex = 0;
	} else if (Type == "Upd") {
		var SelRowData = $("#HandlingOpinions").datagrid("getSelected");
		if ( !SelRowData ) { $.messager.alert("��ʾ","��ѡ����������ٽ����޸ģ�", "info"); return false; }
		var Id = SelRowData.TId;
		var Al = "�޸�";
		var Opt = "updateRow";
		var OptIndex = $("#HandlingOpinions").datagrid("getRowIndex", SelRowData);
	} else {
		return false;
	}
	
	var Code = $("#CodeWin").val().replace(/(^\s*)|(\s*$)/g,"").toUpperCase();
	if (Code == "") { $.messager.alert("��ʾ", "��������룡", "info"); return false; }
	
	var Conclusion = $("#ConclusionWin").combogrid("getValue");
	if (Conclusion == "") { $.messager.alert("��ʾ", "��ѡ������ۣ�", "info"); return false; }
	
	var Sort = $("#SortWin").numberbox("getValue");
	if (Sort == "") { $.messager.alert("��ʾ", "������˳��", "info"); return false; }
	
	var Desc = $("#HanlingOpinionsWin").val().replace(/(^\s*)|(\s*$)/g,"");
	if (Desc == "") { $.messager.alert("��ʾ", "�����봦�������", "info"); return false; }
	
	var OMEType = $("#OMETypeWin").combobox("getValue");
	var Remark = $("#RemarkWin").val();
	
	var Active = "N";
	var cActive=$("#ActiveWin").checkbox("getValue");
	if (cActive) { Active = "Y"; }
	
	var OMETypeDesc = $("#OMETypeWin").combobox("getText");
	var ConclusionDesc = $("#ConclusionWin").combogrid("getText");
	
	var SplitChar = "^";
	var DataStr = Code + SplitChar + OMEType + SplitChar + Conclusion + SplitChar + Desc + SplitChar + Sort + SplitChar + Active + SplitChar + Remark;  // ����^�������^������^�������^˳��^����^��ע

	$.m({
		ClassName:"web.DHCPE.HandlingOpinions",
		MethodName:"HOSave",
		Id:Id,
		DataStr:DataStr,
		SplitChar:SplitChar
	}, function(ret) { 
		if (ret.split("^")[0] == "-1") {
			$.messager.alert("��ʾ", Al + "ʧ�ܣ�" + ret.split("^")[1], "info");
			return false;
		}
		
		$.messager.alert("��ʾ", Al + "�ɹ���", "info");
		$("#HandlingOpinions").datagrid(Opt, {
			index:OptIndex,
			row:{
				TId:ret,
				TConclusion:Conclusion,
				TOMEType:OMEType,
				
				TCode:Code,
				TConclusionDesc:ConclusionDesc,
				TOMETypeDesc:OMETypeDesc,
				TDesc:Desc,
				
				TSort:Sort, 
				TActive:(Active=="Y"?"��":"��"),
				TRemark:Remark
			}
		});
		$("#HOWin").window("close");
	});
}

function BSearch_click() {
	$("#HandlingOpinions").datagrid('clearSelections'); //ȡ��ѡ��״̬
    $("#BUpd").linkbutton('disable');

	$HUI.datagrid("#HandlingOpinions",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.HandlingOpinions",
			QueryName:"QueryHO",
			Code:$("#Code").val(),
			Conclusion:$("#Conclusion").combogrid("getValue"),
			OMEType:$("#OMEType").combobox("getValue")
		}
	});
}

function BClear_click(Type) {
	if (Type == "0") {
		$("#Code").val("");
		$("#Conclusion").combogrid("setValue","");
		$("#OMEType").combobox("setValue","");
	} else if (Type == "1") {
		$("#CodeWin").val("").validatebox("validate");;
		$("#ConclusionWin").combogrid("setValue","");
		$("#OMETypeWin").combobox("setValue","");
		$("#SortWin").numberbox("setValue","").validatebox("validate");;
		$("#ActiveWin").checkbox("setValue","true");
		$("#HanlingOpinionsWin").val("");
	}
}