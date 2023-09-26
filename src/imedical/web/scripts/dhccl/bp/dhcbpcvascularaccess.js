$(function(){
	function setDialogValue()
	{	
		$("#code").val("");
		$("#desc").val("");
	}
	var InsertHandler=function(){
		$("#vascularaccessDialog").show();
		var vascularaccessDlgObj=$HUI.dialog("#vascularaccessDialog",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增血管通路',
			modal:true,
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#code").val()==""){
						$.messager.alert("提示","代码不能为空", "error");
						return;
					}
					if($("#desc").val()==""){
						$.messager.alert("提示","名称不能为空", "error");
						return;
					}
						
					var data=$.m({
								ClassName:"web.DHCBPCVascularAccess",
								MethodName:"InsertVasAccess",
								bpsVACode:$("#code").val(),
								bpcVADesc:$("#desc").val()
							},function(success){
								if(success==0)
								{
									vascularaccessDlgObj.close();
									vascularaccessObj.load();
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
					vascularaccessDlgObj.close();
				}
			}],
			onClose:function(){  
                	setDialogValue();
            } 
		})
	}

	var UpdateHandler=function(id,code,desc)
	{
		$("#code").val(code);
		$("#desc").val(desc);
		$("#vascularaccessDialog").show();
		var vascularaccessDlgObj=$HUI.dialog("#vascularaccessDialog",{
			iconCls:'icon-w-edit',
			title:'修改血管通路信息',
			resizable:true,
			modal:true,
			buttons:[{
				text:"保存",
				handler:function(){
					var data=$.m({
							ClassName:"web.DHCBPCVascularAccess",
							MethodName:"UpdateVasAccess",
							bpcVAId:id,
							bpsVACode:$("#code").val(),
							bpcVADesc:$("#desc").val()
						},function(success){
							if(success==0)
							{
								vascularaccessDlgObj.close();
								vascularaccessObj.load();
							}else{
								$.messager.alert("提示","血管通路更新失败！", "error");
						}
						
					})
				}
			},{
				text:"关闭",
				handler:function(){
					vascularaccessDlgObj.close();
				}
			}],
			onClose:function(){  
                	setDialogValue();
            } 
		})
	}
	
	
	var vascularaccessObj=$HUI.datagrid("#vascularaccessBox",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCVascularAccess",
			QueryName:"FindVasAccess"
		},
        columns:[[
			{ field: "tBPCVARowId", title: "编号", width: 60 },
            { field: "tBPCVACode", title: "代码", width: 120 },
            { field: "tBPCVADesc", title: "名称", width: 240 }
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
				var row=vascularaccessObj.getSelected();
				if(row)
				{
					UpdateHandler(row.tBPCVARowId,row.tBPCVACode,row.tBPCVADesc);
				}
			}
            },{ 
		    iconCls: 'icon-cancel',
		    text:'删除',
		    handler: function(){
				var row=vascularaccessObj.getSelected();
				if(row)
				{
					$.messager.confirm("确认","确认删除？",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCBPCVascularAccess",
								MethodName:"DeleteVasAccess",
								bpcVAId:row.tBPCVARowId
							},function(success)
							{
								if(success==0)
								{
									vascularaccessObj.load();
								}else{
									$.messager.alert("提示","删除失败，错误代码："+success, "error");
								}
							})
						}
					})
				}
			}
		}]
	})

	
})