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
$(function(){
   	var initView=function(){
	   	var emManufacturerObj=$HUI.combobox("#emManufacturer",{
			url:$URL+"?ClassName=web.DHCBPCManufacturer&QueryName=FindEManufacturer&ResultSetType=array",
			textField:"BPCMDesc",
			valueField:"tRowId",
			panelHeight:'auto',
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
				},
			onHidePanel: function () {
        		OnHidePanel("#emManufacturer");
        	},
			})
			
		var emTypeObj=$HUI.combobox("#emType",{
			url:$URL+"?ClassName=web.DHCBPCEquipModel&QueryName=FindEMType&ResultSetType=array",
			textField:"Desc",
			valueField:"Id",
			panelHeight:"auto",
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
				},
			onHidePanel: function () {
        		OnHidePanel("#emType");
        	},
			})
		var emCanFilterObj=$HUI.combobox("#emCanFilter",{
			url:$URL+"?ClassName=web.DHCBPBedEquip&QueryName=FindBoolen&ResultSetType=array",
			textField:"Desc",
			valueField:"Id",
			panelHeight:"auto",
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
				},
			onHidePanel: function () {
        		OnHidePanel("#emCanFilter");
        	},
			})
   	}
	function setDialogValue()
	{		
		$("#RowId").val("");		
		$("#emCode").val("");
		$("#emDesc").val("");	
		$("#emAbbreviation").val("");
		$("#emManufacturer").combobox('setValue',"")
		$("#emAgent").val("");
		$("#emType").combobox('setValue',"")
		$("#emNote").val("");	
		$("#emCanFilter").combobox('setValue',"")
	}	
	var InsertHandler=function(){
		initView();
		$("#equipModeDialog").show();
		var equipModeDigObj=$HUI.dialog("#equipModeDialog",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			title:'新增设备型号',
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#emCode").val()==""){
						$.messager.alert("提示","代码不能为空","error");
						return;
					}
					if($("#emDesc").val()==""){
						$.messager.alert("提示","描述不能为空","error");
						return;
					}
					var data=$.m({
								ClassName:"web.DHCBPCEquipModel",
								MethodName:"InsertEModel",
								bpcEMCode:$("#emCode").val(),
								bpcEMDesc:$("#emDesc").val(),
								bpcEMAbbreviation:$("#emAbbreviation").val(),
								bpcEMManufacturerDr:$("#emManufacturer").combobox('getValue'),
								bpcEMAgent:$("#emAgent").val(),
								bpcEMType:$("#emType").combobox('getValue'),
								bpcEMNote:$("#emNote").val(),
								bpcEMCanFilter:$("#emCanFilter").combobox('getValue')							
							},function(success){
								if(success==0)
								{
									equipModeDigObj.close();
									equipModeObj.load();
								}else
								{
									$.messager.alert("提示",success);
								}
							})
				}
			},
			{
				text:"关闭",
				handler:function(){
					equipModeDigObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})

	}

	var UpdateHandler=function(row)
	{		
		initView();	
		$("#emCode").val(row.tBPCEMCode);
		$("#emDesc").val(row.tBPCEMDesc);	
		$("#emAbbreviation").val(row.tBPCEMAbbreviation);
		$("#emManufacturer").combobox('setValue',row.tBPCEMManufacturerDr);
		$("#emManufacturer").combobox('setText',row.tBPCEMManufacturerDesc);
		$("#emAgent").val(row.tBPCEMAgent);
		$("#emType").combobox('setValue',row.tBPCEMType);
		$("#emType").combobox('setText',row.tBPCEMTypeD);
		$("#emNote").val(row.tBPCEMNote);	
		$("#emCanFilter").combobox('setValue',row.tBPCEMCanFilterB);
		//$("#emCanFilter").combobox('setText',row.tBPCEMCanFilter);	
		$("#equipModeDialog").show();
		var equipModeDigObj=$HUI.dialog("#equipModeDialog",{
			iconCls:'icon-w-edit',
			resizable:true,
			modal:true,
			title:'修改设备型号',
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#emCode").val()==""){
						$.messager.alert("提示","代码不能为空","error");
						return;
					}
					if($("#emDesc").val()==""){
						$.messager.alert("提示","描述不能为空","error");
						return;
					}
					var data=$.m({
							ClassName:"web.DHCBPCEquipModel",
							MethodName:"UpdateEModel",
							bpcEMId:row.tID,
							bpcEMCode:$("#emCode").val(),
							bpcEMDesc:$("#emDesc").val(),
							bpcEMAbbreviation:$("#emAbbreviation").val(),
							bpcEMManufacturerDr:$("#emManufacturer").combobox('getValue'),
							bpcEMAgent:$("#emAgent").val(),
							bpcEMType:$("#emType").combobox('getValue'),
							bpcEMNote:$("#emNote").val(),
							bpcEMCanFilter:$("#emCanFilter").combobox('getValue')
						},function(success){
							if(success==0)
							{
								equipModeDigObj.close();
								equipModeObj.load();
							}else{
								$.messager.alert("提示","净化设备型号更新失败！");
						}
						
					})
				}
			},{
				text:"关闭",
				handler:function(){
					equipModeDigObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})
	}
		
	var equipModeObj=$HUI.datagrid("#equipModeBox",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCEquipModel",
			QueryName:"FindEModel"
		},
        columns:[[
			{ field: "tID", title: "系统号", width: 120 },
			{ field: "tBPCEMCode",title:"代码",width:240},
            { field: "tBPCEMDesc", title: "描述", width: 240 },            
            { field: 'tBPCEMAbbreviation',title:'缩写',width:140},
            { field: 'tBPCEMManufacturerDr',title:'生产厂家Dr',width:140,hidden:true},  
            { field: 'tBPCEMManufacturerDesc',title:'生产厂家',width:140},
            { field: 'tBPCEMAgent',title:'代理',width:140},
            { field: 'tBPCEMType',title:'类型Dr',width:140,hidden:true},  
            { field: 'tBPCEMTypeD',title:'类型',width:140}, 
            { field: 'tBPCEMNote',title:'备注',width:140}, 
            { field: 'tBPCEMCanFilterB',title:'是否过滤Dr',width:140,hidden:true},  
            { field: 'tBPCEMCanFilter',title:'是否过滤',width:140}, 
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
		toolbar:[{
			iconCls: 'icon-add',
		    text:'新增',
		    handler: function(){
			    InsertHandler();
			}
	        },{
	        iconCls: 'icon-write-order',
	        text:'修改',
		    handler: function(){
				var row=equipModeObj.getSelected();
				if(row)
				{
					UpdateHandler(row);
				}
			}
            },{ 
		    iconCls: 'icon-cancel',
		    text:'删除',
		    handler: function(){
				var row=equipModeObj.getSelected();
				if(row)
				{
					$.messager.confirm("确认","确认删除？",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCBPCEquipModel",
								MethodName:"DeleteEModel",
								bpcEMId:row.tID
							},function(success)
							{
								if(success==0)
								{
									equipModeObj.load();
								}else{
									$.messager.alert("提示","删除失败，错误代码："+success);
								}
							})
						}
					})
				}
			}
		}]
	})

	
})