//����	dhcpe.ct.handlingopinions.js
//����	ϵͳ���� - ְҵ����� - ְҵ�����������ģ��ά��
//����	2021-08-14
//������  zhongricheng
var tableName = "DHC_PE_HandlingOpinions";
var sessionStr = session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID'];

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
	//��ȡ�����б� dhcpe/ct/dhcpe.ct.common.js
	GetLocComp(sessionStr);
	
	//���������б�change
	$("#LocList").combobox({
		onSelect:function() {
			BClear_click("0");
			BSearch_click();
		}
	});
	
	//�������
	$HUI.combobox("#OMEType, #OMETypeWin", {
		url:$URL+"?ClassName=web.DHCPE.OMEType&QueryName=SearchOMEType&ResultSetType=array",
		valueField:'TID',
		textField:'TDesc',
	    panelHeight:'auto', //�Զ��߶�
	    panelMaxHeight:200, //���߶�
		defaultFilter:4
	});
	
	// ������
	$HUI.combobox("#Conclusion, #ConclusionWin", {
		url:$URL+"?ClassName=web.DHCPE.CT.Conclusion&QueryName=FindConclusion&Active=Y&ResultSetType=array",
		valueField:'TRowId',
		textField:'TDesc',
	    panelHeight:'auto', //�Զ��߶�
	    panelMaxHeight:200 //���߶�
	});
}

function InitDataGrid() {
	
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	
	$HUI.datagrid("#HandlingOpinions", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.CT.HandlingOpinions",
			QueryName:"SearchHandOpts",
			Code:"",
			Conclusion:"",
			OMEType:"",
			LocID:LocID,
			tableName:tableName
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
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
				}
			},
			{field:'Empower', title:'������Ȩ', align:'center', width:70,
				formatter:function(value, rowData, rowIndex) {
					if(value=="Y"){
							return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
						}else{
							return '<input type="checkbox" value="" disabled/>';
						}
				}
			},
			{ field:'TEffPowerFlag',width:100,title:'��ǰ������Ȩ',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
				}
			},
			{field:'TRemark', title:'��ע', width:100}
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
		}, {
			iconCls: 'icon-write-order',
			text:'�޸�',
			id:'BUpd',
			disabled:true,
			handler: function(){
				BClear_click("1");
				$("#HOWin").show();
				
				var SelRowData = $("#HandlingOpinions").datagrid("getSelected");
				if(SelRowData==null){
					$.messager.alert("��ʾ","��ѡ����޸ĵ����ݣ�","info");
					return false
				}
				$("#CodeWin").val(SelRowData.TCode).validatebox("validate");
				$("#ConclusionWin").combobox("setValue",SelRowData.TConclusion);
				$("#SortWin").numberbox("setValue",SelRowData.TSort).validatebox("validate");
				$("#OMETypeWin").combobox("setValue",SelRowData.TOMEType);
				$("#RemarkWin").val(SelRowData.TRemark);
				$("#HanlingOpinionsWin").val(SelRowData.TDesc);
				
				$("#ActiveWin").checkbox("setValue",SelRowData.TActive=="Y"?true:false);
				
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
		}, {
			iconCls: 'icon-paper-key',
			text:'������Ȩ',
			id:'BPower',
			disabled:true,
			handler: function(){
				var SelRowData = $("#HandlingOpinions").datagrid("getSelected");
				var Id = SelRowData.TId;
				if (Id == "") {
					$.messager.alert("��ʾ","��ѡ����Ҫ������Ȩ�����ݣ�","info");
					return false;
				}else{
					//������Ȩ 
					var BEmpower=$.trim($("#BPower").text());
					var iEmpower="Y";
					if (BEmpower=="ȡ����Ȩ") iEmpower="N"

					var LocID=$("#LocList").combobox('getValue');
					var UserID=session['LOGON.USERID'];
	    			var rtn=tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","SaveDataToPowerControl",tableName,Id,LocID,UserID,iEmpower)
					var rtnArr=rtn.split("^");
					if(rtnArr[0]=="-1"){
						if (BEmpower=="ȡ����Ȩ"){$.messager.alert("��ʾ","ȡ����Ȩʧ��","error");}
						else{$.messager.alert("��ʾ","��Ȩʧ��","error");}
					}else{
						if (BEmpower=="ȡ����Ȩ"){$.messager.popover({msg:'ȡ����Ȩ�ɹ�',type:'success',timeout: 1000});}
						else{$.messager.popover({msg:'��Ȩ�ɹ�',type:'success',timeout: 1000});}
			 			$("#HandlingOpinions").datagrid('reload');
			 			$("#HandlingOpinions").datagrid('clearSelections'); //ȡ��ѡ��״̬
					}			
					
				}	
				
				
			}
		},{
			iconCls: 'icon-key',
			text:'���ݹ�������',
			id:'BRelateLoc',
			disabled:true,
			handler: function(){
				var SelRowData = $("#HandlingOpinions").datagrid("getSelected");
				var Id = SelRowData.TId;
				if (Id == "") {
					$.messager.alert("��ʾ","��ѡ����������ٹ������ң�", "info");
					return false;
				}
				
				var LocID = $("#LocList").combobox('getValue');
                OpenLocWin(tableName,Id,sessionStr,LocID,InitDataGrid)
				
			}
		}],		
		onClickRow: function (rowIndex, rowData) {  // ѡ�����¼�
			$('#BUpd').linkbutton('enable');
			$('#BRelateLoc').linkbutton('enable');
			$('#BPower').linkbutton('enable');
			if(rowData.Empower=="Y"){	
				$("#BRelateLoc").linkbutton('enable');
				$("#BPower").linkbutton({text:'ȡ����Ȩ'});
			}else{
				$("#BRelateLoc").linkbutton('disable');
				$("#BPower").linkbutton('enable');
				$("#BPower").linkbutton({text:'������Ȩ'})
				
			}	
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
	
	var Conclusion = $("#ConclusionWin").combobox("getValue");
	if (Conclusion == "") { $.messager.alert("��ʾ", "��ѡ������ۣ�", "info"); return false; }
	
	var Sort = $("#SortWin").numberbox("getValue");
	if (Sort == "") { $.messager.alert("��ʾ", "������˳��", "info"); return false; }
	
	var Desc = $("#HanlingOpinionsWin").val().replace(/(^\s*)|(\s*$)/g,"");
	if (Desc == "") { $.messager.alert("��ʾ", "�����봦�������", "info"); return false; }
	
	var OMEType = $("#OMETypeWin").combobox("getValue");
	var Remark = $("#RemarkWin").val();
	
	var Active = $("#ActiveWin").checkbox("getValue")?"Y":"N";
	
	var OMETypeDesc = $("#OMETypeWin").combobox("getText");
	var ConclusionDesc = $("#ConclusionWin").combobox("getText");
	
	var SplitChar = "^";
	var DataStr = Code + SplitChar + OMEType + SplitChar + Conclusion + SplitChar + Desc + SplitChar + Sort + SplitChar + Active + SplitChar + Remark + SplitChar + tableName;  // ����^�������^������^�������^˳��^����^��ע^����

	$.cm({
		ClassName:"web.DHCPE.CT.HandlingOpinions",
		MethodName:"UpdateHandOpts",
		Id:Id,
		DataStr:DataStr,
		SplitChar:SplitChar,
		LocId:$("#LocList").combobox('getValue'),
		USERID:session["LOGON.USERID"]
	}, function(jsonData){
		if (jsonData.success == 0) {
			$.messager.alert("��ʾ", Al + "ʧ�ܣ�" + jsonData.msg, "error");
		} else if (jsonData.code == "-1") {
			$.messager.alert("��ʾ", Al + "ʧ�ܣ�" + jsonData.msg, "error");
		} else {
			$.messager.popover({msg:Al + "�ɹ���", type:"success", timeout:2000});
			BClear_click();
			$("#HandlingOpinions").datagrid(Opt, {
				index:OptIndex,
				row:{
					TId:jsonData.code,
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
		}
	});
}

function BSearch_click() {
	$("#HandlingOpinions").datagrid('clearSelections'); //ȡ��ѡ��״̬

	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	
	$HUI.datagrid("#HandlingOpinions",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.CT.HandlingOpinions",
			QueryName:"SearchHandOpts",
			Code:$("#Code").val(),
			Conclusion:$("#Conclusion").combobox("getValue"),
			OMEType:$("#OMEType").combobox("getValue"),
			LocID:LocID,
			tableName:tableName
			
		}
	});
}

function BClear_click(Type) {
	if (Type == "0") {
		$("#Code").val("");
		$("#Conclusion").combobox("setValue","");
		$("#OMEType").combobox("setValue","");
		BSearch_click();
	} else if (Type == "1") {
		$("#CodeWin").val("").validatebox("validate");;
		$("#ConclusionWin").combobox("setValue","");
		$("#OMETypeWin").combobox("setValue","");
		$("#SortWin").numberbox("setValue","").validatebox("validate");;
		$("#ActiveWin").checkbox("setValue","true");
		$("#HanlingOpinionsWin").val("");
	}
}