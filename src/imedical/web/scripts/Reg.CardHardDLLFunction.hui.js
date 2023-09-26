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
		{field:'FunctionName',title:'DLL函数名称',width:200},
		{field:'InParaOne',title:'传入参数一',width:200},
		{field:'InParaTwo',title:'传入参数二',width:200},
		{field:'InParaThree',title:'传入参数三 ',width:200},
		{field:'DLLFunctionType',title:'DLL函数分类',width:200}
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
				text:'新增',
				handler: function(){
					//PageLogicObj.FunctionId=""
					rowid=""
					if(ParRef=="") return 
					LoadCSPWin("DLLFunctionWin","reg.dllfunction.win.csp")
					$("#DLLFunctionWin").dialog("setTitle","正在新建【DLL函数】")
					ClearWinValue()
				}
			},{
				iconCls: 'icon-write-order',
				text:'修改',
				handler: function(){
					if(rowid==""){
						$.messager.alert("提示", "请选择硬件设备!", 'info');
						return 
					}
					LoadCSPWin("DLLFunctionWin","reg.dllfunction.win.csp")
					ClearWinValue()
					LoadWinValue(rowid)
				}
			},{
				iconCls: 'icon-cancel',
				text:'删除',
				handler: function(){
					if(rowid==""){
						$.messager.alert("提示", "请选择函数列表!", 'info');
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
	///表格加载数据
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
	///加载编辑框csp
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
		//初始化DLL函数类型
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
			$("#DLLFunctionWin").dialog("setTitle","正在修改【DLL函数】")
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
				$.messager.alert("提示", "数据保存失败", 'info');
			}
		});
	}
	function CheckBefore(){
		var DLLFunctionName=$("#DLLFunctionName").val()
		if(DLLFunctionName==""){
			$.messager.alert("提示", "DLL函数名称不能为空", 'info');
			return false
		}
		var DLLFunctionType=$("#DLLFunctionType").combobox("getValue")
		if(DLLFunctionType==""){
			$.messager.alert("提示", "DLL函数类型不能为空", 'info');
			return false
		}
		return true
	}
	function DeleteData(rowid){
		if(rowid=="") return;
		$.messager.confirm('确认对话框', '是否删除该函数?', function(r){
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


