$(function(){ 
	function setDialogValue()
	{	
		$("#bpcERMCode").val("");
		$("#bpcERMDesc").val("");
	}	 
   var InsertHandler=function(){
		$("#equipRunModeDlg").show();
		var equipRunModeDlg=$HUI.dialog("#equipRunModeDlg",{
			iconCls:'icon-w-add',
			resizable:false,
			modal:true,
			title:'新增设备运行模式',
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#bpcERMCode").val()==""){
						$.messager.alert("提示","代码不能为空","error");
						return;
					}
					if($("#bpcERMDesc").val()==""){
						$.messager.alert("提示","名称不能为空","error");
						return;
					}
					var data=$.m({
								ClassName:"web.DHCBPCEquipRunMode",
								MethodName:"InsertERunMode",
								bpcERMCode:$("#bpcERMCode").val(),
								bpcERMDesc:$("#bpcERMDesc").val(),
							},function(success){
								if(success==0)
								{
									equipRunModeDlg.close();
									equipRunModeUIObj.load();
								}else
								{
									$.messager.alert("提示","新增失败！");
								}
							})
	
					}
				},{
					text:"关闭",
					handler:function(){
						equipRunModeDlg.close();
					}
				}],
				onClose:function(){  
                	setDialogValue();
            	} 
		})
	}
	
	var UpdateHandler=function(tBPCERMRowId,tBPCERMCode,tBPCERMDesc)
	{
		$("#bpcERMCode").val(tBPCERMCode);
		$("#bpcERMDesc").val(tBPCERMDesc);
		$("#equipRunModeDlg").show();
		var equipRunModeDlgObj=$HUI.dialog("#equipRunModeDlg",{
			iconCls:'icon-w-edit',
			resizable:false,
			modal:true,
			title:'修改设备运行模式',
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#bpcERMCode").val()==""){
						$.messager.alert("提示","代码不能为空","error");
						return;
					}
					if($("#bpcERMDesc").val()==""){
						$.messager.alert("提示","名称不能为空","error");
						return;
					}
					var data=$.m({
						ClassName:"web.DHCBPCEquipRunMode",
						MethodName:"UpdateERunMode",
						bpcERMId:tBPCERMRowId,
						bpcERMCode:$("#bpcERMCode").val(),
						bpcERMDesc:$("#bpcERMDesc").val(),
						
					},function(success){
						if(success==0)
						{
							equipRunModeDlgObj.close();
							equipRunModeUIObj.load();
						}else{
							$.messager.alert("提示","更新失败！");
						}
						
					})
				}
			},{
				text:"关闭",
				handler:function(){
					equipRunModeDlgObj.close();
				}
			}],
			onClose:function(){  
                	setDialogValue();
            } 
		})
	}
	
	var equipRunModeUIObj=$HUI.datagrid("#equipRunModeUI",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCEquipRunMode",
			QueryName:"FindERunMode",
			bb:''
		},
        columns:[[
			{ field: "tBPCERMRowId", title: "编号", width: 60 },
            { field: "tBPCERMCode", title: "代码", width: 100 },
            { field: "tBPCERMDesc", title: "名称", width: 100 },
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
				var row=equipRunModeUIObj.getSelected();
				if(row)
				{
					UpdateHandler(row.tBPCERMRowId,row.tBPCERMCode,row.tBPCERMDesc);
				}
			}
        },{
			///删除功能
		    iconCls: 'icon-cancel',
		    text:'删除',
		    handler: function(){
				var row=equipRunModeUIObj.getSelected();
				if(row)
				{
					$.messager.confirm("确认","确定删除？",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCBPCEquipRunMode",
								MethodName:"DeleteERunMode",
								bpcERMId:row.tBPCERMRowId
							},function(success)
							{
								if(success==0)
								{
									equipRunModeUIObj.load();
								}else{
									$.messager.alert("提示","删除失败！错误代码："+success);
								}
							})
						}
					})
				}
			}
		},
		]
	})
});