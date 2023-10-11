///combobox不是选择，下拉框提示
function OnHidePanel(item)
{
	var valueField = $(item).combobox("options").valueField;
	var val = $(item).combobox("getValue");  //当前combobox的值
	var txt = $(item).combobox("getText");
	var allData = $(item).combobox("getData");   //获取combobox所有数据
	var result = true;      //为true说明输入的值在下拉框数据中不存在
	if (val=="") result=false;
	for (var i = 0; i < allData.length; i++) {
		if (val == allData[i][valueField]) {
	    	result = false;
	    	break;
	    }
	}
	if (result) {
		$(item).combobox("clear");	    
	    $(item).combobox("reload");
	    if ((val==undefined)&&(txt!=""))
	    {
		    $(item).combobox('setValue',"");
	    	$.messager.alert("提示","请从下拉框选择","error");
	    	return;
	    }
	}
}
///combobox不是选择，医嘱下拉框提示
function OnHidePanel2(item)
{
	var valueField = $(item).combobox("options").valueField;
	var val = $(item).combobox("getValue");  //当前combobox的值
	var txt = $(item).combobox("getText");
	var allData = $(item).combobox("getData");   //获取combobox所有数据
	var result = true;      //为true说明输入的值在下拉框数据中不存在
	if (val=="") result=false;
	for (var i = 0; i < allData.length; i++) {
		if (val == allData[i][valueField]) {
	    	result = false;
	    	break;
	    }
	}
	if (result) {
		$(item).combobox("clear");	    
	    $(item).combobox("reload");
	    $(item).combobox('setValue',"");
	    $.messager.alert("提示","请从下拉框选择","error");
	    return;
	}
}
///combogrid不是选择，多选下拉框提示
function OnHidePanel3(item)
{
	var idField = $(item).combogrid("options").idField;
	var vals = $(item).combogrid("getValues");  //当前combobox的值
	var txt = $(item).combogrid("getText");
	var allData = $(item).combogrid("grid").datagrid('getSelections');   //获取combobox所有数据
	var result = true;      //为true说明输入的值在下拉框数据中不存在
	for (var i = 0; i < allData.length; i++) {
		for (var j = 0; j < vals.length; j++) 
		{
			if (vals[j] == allData[i][idField]) {
	    		result = false;
	    		break;
	    	}
		}
	}
	if (result) {
	    if ((vals.length==0)&&(txt!=""))
	    {
		    $(item).combobox("clear");	    
	    	$(item).combobox("reload");
		    $(item).combobox('setValue',"");
	    	$.messager.alert("提示","请从下拉框选择","error");
	    	return;
	    }
	}
}
$(function(){	
		$HUI.combobox("#bpcCType",{
			url:$URL+"?ClassName=web.DHCBPCConsumable&QueryName=FindCType&ResultSetType=array",
			textField:"Desc",
			valueField:"Id",
			panelHeight:"auto",
			formatter:function(row){				
				var opts = $(this).combobox('options');
				return row[opts.textField];

			},
			onHidePanel: function () {
        		OnHidePanel("#bpcCType");
        	},	
		});
		$HUI.combobox("#bpcCHighFluxed",{
			url:$URL+"?ClassName=web.DHCBPCConsumable&QueryName=FindCBoolen&ResultSetType=array",
			textField:"Desc",
			valueField:"Id",
			panelHeight:"auto",
			formatter:function(row){				
				var opts = $(this).combobox('options');
				return row[opts.textField];

			},
			onHidePanel: function () {
        		OnHidePanel("#bpcCHighFluxed");
        	},			
		});
		$HUI.combobox("#bpcCArcim",{
			url:$URL+"?ClassName=web.DHCBPOrder&QueryName=GetArcimList&ResultSetType=array",
			valueField:"Id",
			textField:"Desc",
			formatter:function (row){
	        	var opts = $(this).combobox('options');
				return row[opts.textField];
        	},						
			onBeforeLoad:function(param)
        	{            	
            	param.needItemCatId="";
            	param.needArcimDesc=param.q;
            	param.arcimIdStr=""
        	},        	
        	mode:"remote",
        	onHidePanel: function () {
        		OnHidePanel2("#bpcCArcim");
        	},
		});
		
	
	function setDialogValue()
	{
		$("#bpcCCode").val("");
		$("#bpcCDesc").val("");
		$("#bpcCType").combobox('setValue',"");
		$("#bpcCMembraneArea").val("");
		$("#bpcCHighFluxed").combobox('setValue',"");
		$("#bpcCArcim").combobox('setValue',"");
	}	
	var insertHandler=function(){
		$("#consumableDlg").show();
		var consumableDlgObj=$HUI.dialog("#consumableDlg",{
			iconCls:'icon-w-add',
			resizable:false,
			modal:true,
			title:'新增材料码表',
			buttons:[
			{
				text:"保存",
				handler:function(){
					$.m({
						ClassName:"web.DHCBPCConsumable",
						MethodName:"InsertConsumable",
						bpcCCode:$("#bpcCCode").val(),
						bpcCDesc:$("#bpcCDesc").val(),
						bpcCType:$("#bpcCType").combobox('getValue'),
						bpcCMembraneArea:$("#bpcCMembraneArea").val(),
						bpcCHighFluxed:$("#bpcCHighFluxed").combobox('getValue'),
						bpcCArcimDr:$("#bpcCArcim").combobox('getValue'),
						
						},function(s){
							if(s==0){
								consumableDlgObj.close();
								consumableBoxObj.load();
								}else{
									$.messager.alert("提示",s)
									}
							
							}
					)
					
					}
				},
			{
				text:"关闭",
				handler:function(){
					
					consumableDlgObj.close();
					}
				}
			],			
			onClose:function(){  
                setDialogValue();
            } 
			
			
			})
		
		
		}
	var updateHandler=function(r){
		var id=r.tID
		$("#bpcCCode").val(r.tBPCCCode)
		$("#bpcCDesc").val(r.tBPCCDesc)
		$("#bpcCMembraneArea").val(r.tBPCCMembraneArea)
		$("#bpcCType").combobox('setValue',r.tBPCCType)
		$("#bpcCType").combobox('setText',r.tBPCCTypeD)
		$("#bpcCHighFluxed").combobox('setValue',r.tBPCCHighFluxed)
		$("#bpcCHighFluxed").combobox('setText',r.tBPCCHighFluxedD)
		$("#bpcCArcim").combobox('setValue',r.tBPCCArcimDr);
		$("#bpcCArcim").combobox('setText',r.tBPCCArcim);
		$("#consumableDlg").show();
		var consumableDlgObj=$HUI.dialog("#consumableDlg",{
			iconCls:'icon-w-edit',
			resizable:false,
			modal:true,
			title:'修改材料码表',
			buttons:[
			{
				text:"保存",
				handler:function(){				
					$.m({
						ClassName:"web.DHCBPCConsumable",
						MethodName:"UpdateConsumable",
						bpcCId:id,
						bpcCCode:$("#bpcCCode").val(),
						bpcCDesc:$("#bpcCDesc").val(),
						bpcCType:$("#bpcCType").combobox('getValue'),
						bpcCMembraneArea:$("#bpcCMembraneArea").val(),
						bpcCHighFluxed:$("#bpcCHighFluxed").combobox('getValue'),
						bpcCArcimDr:$("#bpcCArcim").combobox('getValue'),
						},function(s){
							if(s==0){
								consumableDlgObj.close();
								consumableBoxObj.load();
								}else{
									$.messager.alert("提示","更新失败！"+s)
									}
							
							}
					)
					
					}
				},
			{
				text:"关闭",
				handler:function(){
					
					consumableDlgObj.close();
					}
				}
			],			
			onClose:function(){  
                setDialogValue();
            } 
			
			
			})
		
		
		
		
		}
	var deleteHandler=function(r){
		$.m({
			ClassName:"web.DHCBPCConsumable",
			MethodName:"DeleteConsumable",
			bpcCId:r.tID
			
			},function(s){
				if(s==0){
					
					$.messager.alert("提示","删除成功！");
						consumableBoxObj.load();
						}else{
						$.messager.alert("提示","删除失败！"+s);
							}
				})
		
		}	
	var consumableBoxObj=$HUI.datagrid("#consumableBox",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCConsumable",
			QueryName:"FindConsumable"
			
			},
		columns:[[
		{field:"tID",title:"编号",width:60},
		{field:"tBPCCCode",title:"代码",width:150},
		{field:"tBPCCDesc",title:"描述",width:150},
		{field:"tBPCCTypeD",title:"类型",width:100},
		{field:"tBPCCMembraneArea",title:"膜面积",width:100},
		{field:"tBPCCHighFluxedD",title:"是否高通量",width:100},
		{field:"tBPCCArcim",title:"医嘱",width:100},
		{field:"tBPCCType",hidden:true},
		{field:"tBPCCHighFluxed",hidden:true},
		{field:"tBPCCArcimDr",hidden:true},
		]],
		pagination:true,
		pageSize: 20,
		pageList: [20, 50, 100],
		//rows:20,
		fit:true,
		fitColumns:true,
		headerCls:"panel-header-gray",
		singleSelect:true,
		checkOnSelect:true,	///easyui取消单击行选中状态
		selectOncheck:true,
        iconCls:'icon-paper',
        rownumbers: true,
		toolbar:[
		{
			text:"新增",
			iconCls:"icon-add",
			handler:function(){
				insertHandler();
				}
			
			},
		{
			text:"修改",
			iconCls:"icon-write-order"
			,handler:function(){
				var rows=$("#consumableBox").datagrid('getSelections')
				if(rows.length!=1)
				{
					$.messager.alert("提示","请选中一行！", "error")
					}else{
						updateHandler(rows[0]);
						}
				}
			
			},
		{
			text:"删除",
			iconCls:"icon-cancel",
			handler:function(){
				var rows=$("#consumableBox").datagrid('getSelections')
				if(rows.length!=1)
				{
					$.messager.alert("提示","请选中一行！", "error")
					}else{
						deleteHandler(rows[0]);
						}
				}
				
			
			}
		
		],
		fit:true,
		pagination:true
		
		
		})
	
	
	
	
	
	})