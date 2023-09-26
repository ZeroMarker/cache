function InitWin(){
	var FieldJson={
		CDFDLLFunctionName:"DLLFunctionName",
		CDFDLLInPara1:"InParaOne",
		CDFDLLInPara2:"InParaTwo",
		CDFDLLInPara3:"InParaThree",
		CDFDLLFunctionType:"DLLFunctionType"
	}
	this.GridId="HardDLLFunctionList"
	this.SaveBtnId="DllSave"
	var ParRef=""
	var GridId=this.GridId
	var rowid=""
	var Columns=[[ 
		{field:'ID',title:'',hidden:true},
		{field:'FunctionName',title:'DLL��������',width:200},
		{field:'InParaOne',title:'�������һ',width:200},
		{field:'InParaTwo',title:'���������',width:200},
		{field:'InParaThree',title:'��������� ',width:200},
		{field:'DLLFunctionType',title:'DLL��������',width:200}
	]]
	
	function InitDataGrid(GridId){
		var dataGrid=$("#"+GridId).datagrid({
			fit : true,
			border : false,
			striped : true,
			singleSelect : true,
			fitColumns : false,
			autoRowHeight : false,
			pagination : false,  
			pageSize: 20,
			idField:'ID',
			columns :Columns,
			toolbar: [
			{
				iconCls: 'icon-add ',
				text:'����',
				handler: function(){
					//PageLogicObj.FunctionId=""
					rowid=""
					if(ParRef=="") return 
					LoadCSPWin("DLLFunctionWin","reg.dllfunction.win.csp")
					$("#DLLFunctionWin").dialog("setTitle","�����½���DLL������")
					ClearWinValue()
				}
			},{
				iconCls: 'icon-write-order',
				text:'�޸�',
				handler: function(){
					if(rowid==""){
						$.messager.alert("��ʾ", "��ѡ��Ӳ���豸!", 'info');
						return 
					}
					LoadCSPWin("DLLFunctionWin","reg.dllfunction.win.csp")
					ClearWinValue()
					LoadWinValue(rowid)
				}
			},{
				iconCls: 'icon-cancel',
				text:'ɾ��',
				handler: function(){
					if(rowid==""){
						$.messager.alert("��ʾ", "��ѡ�����б�!", 'info');
						return 
					}
					DeleteData(rowid)	
				}
			}],
			onCheck:function(index, row){
				
			},onSelect:function(index,rowData){
				rowid=rowData["ID"];
			},
			onDblClickRow:function(index, row){
				var rowid=row["ID"];
				LoadCSPWin("DLLFunctionWin","reg.dllfunction.win.csp")
				ClearWinValue()
				LoadWinValue(rowid)
			},
			onLoadSuccess:function(data){
				rowid="";
				$(this).datagrid('unselectAll');
			}
		});
		dataGrid.datagrid('loadData',{ 'total':'0',rows:[] });
		return dataGrid;
	}
	///����������
	function DataGridLoad(ParentRowID){
		ParRef=ParentRowID
		var Para={}
		Para.ClassName="web.DHCBL.CARD.CardHardDLLFunction"
		Para.QueryName="CardHardDLLFunctionQuery"
		if(ParentRowID!=""){
			Para.ParentRowID=ParentRowID
		}
		Para.rows=9999
		$.cm(Para
			,function(GridData){
			$("#"+GridId).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		});
	}
	this.DataGridLoad=DataGridLoad
	///���ر༭��csp
	function LoadCSPWin(WinId,CspName){
		if(typeof $("#"+WinId)[0]=="undefined"){
				$.ajax(CspName, {
				"type" : "GET",
				"dataType" : "html",
				"success" : function(data, textStatus) {
					$("#previewPanelTemp").html(data)
					$("#"+WinId).dialog({
						resizable:true,
						modal:true,
						closed:true
					});
					InitWinElement()
					//$("#"+WinId).dialog("center")
					//$("#"+WinId).dialog("open")
				}
			});
		}else{
			$("#"+WinId).dialog("center")
			$("#"+WinId).dialog("open")
		}
	}
	function InitWinElement(){
		//��ʼ��DLL��������
		$.cm({
				ClassName:"web.DHCBL.UDHCCommFunLibary",
				QueryName:"InitListObjectValueNew",
				ClassName1:"User.DHCCardHardDLLFunction",
				PropertyName:"CDFDLLFunctionType",
				rows:99999
			},function(GridData){
				var cbox = $HUI.combobox("#DLLFunctionType", {
						valueField: 'ValueList',
						textField: 'DisplayValue', 
						editable:true,
						data: GridData["rows"]
				 });
		});
		$HUI.linkbutton("#DllSave",{})
		$("#DllSave").bind("click",SaveClick)
	}
	function ClearWinValue(){
		$.each(FieldJson,function(name,value){
			var val='"'+""+'"'
			setValue(value,"")
		})
	}
	function LoadWinValue(RowId){
		ClearWinValue()
		$.cm({
			ClassName:"web.DHCBL.CARD.CardHardDLLFunction",
			MethodName:"GetJsonData",
			RowId:RowId,
			jsonFiledStr:JSON.stringify(FieldJson)
		},function(JsonData){
			//alert(JSON.stringify(JsonData))
			if(JsonData!=""){
				$.each(JsonData,function(name,value){
					setValue(name,value)
				})
			}
			$("#DLLFunctionWin").dialog("setTitle","�����޸ġ�DLL������")
		});
	}
	function SaveClick(){
		if(!CheckBefore()) return 
		var dataJson={}
		$.each(FieldJson,function(name,value){
			var val=getValue(value)
			val='"'+val+'"'
			eval("dataJson."+name+"="+val)
		})
		var parref=ParRef
		var jsonStr=JSON.stringify(dataJson)
		$m({
			ClassName:"web.DHCBL.CARD.CardHardDLLFunction",
			MethodName:"SaveByJson",
			Rowid:rowid,
			JsonStr:jsonStr,
			ParRef:parref
		},function(txtData){
			if(txtData==0){
				DataGridLoad(ParRef)
				$('#DLLFunctionWin').dialog('close')
			}else{
				$.messager.alert("��ʾ", "���ݱ���ʧ��", 'info');
			}
		});
	}
	function CheckBefore(){
		var DLLFunctionName=$("#DLLFunctionName").val()
		if(DLLFunctionName==""){
			$.messager.alert("��ʾ", "DLL�������Ʋ���Ϊ��", 'info');
			return false
		}
		var DLLFunctionType=$("#DLLFunctionType").combobox("getValue")
		if(DLLFunctionType==""){
			$.messager.alert("��ʾ", "DLL�������Ͳ���Ϊ��", 'info');
			return false
		}
		return true
	}
	function DeleteData(rowid){
		if(rowid=="") return;
		$.messager.confirm('ȷ�϶Ի���', '�Ƿ�ɾ���ú���?', function(r){
			if (r){
			    $m({
					ClassName:"web.DHCBL.CARD.CardHardDLLFunction",
					MethodName:"Delete",
					RowId:rowid
				},function(txtData){
					if(txtData==1){
						DataGridLoad(ParRef)
						rowid=""
					}else{
						
					}
				});
			}
		});
	}
	InitDataGrid(GridId)
	this.DataGridLoad("")
	LoadCSPWin("DLLFunctionWin","reg.dllfunction.win.csp")
	$("#"+this.SaveBtnId).bind("click",this.SaveClick)
}


