$(function(){
	function setDialogValue()
	{	
		$("#code").val("");
		$("#desc").val("");
	}
	var InsertHandler=function(){
		$("#superCatDlg").show();
		var superCatDlgObj=$HUI.dialog("#superCatDlg",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增病人转归',
			modal:true,
			buttons:[{
				text:"保存",
				handler:function(){
						
							var data=$.m({
								ClassName:"web.DHCBPCVisitStatus",
								MethodName:"InsertVStatus",
								bpcVSCode:$("#code").val(),
								bpcVSDesc:$("#desc").val()
							},function(success){
								if(success==0)
								{
									superCatDlgObj.close();
									superCatObj.load();
								}else
								{
									$.messager.alert("提示","病人转归维护添加失败！", "error");
								}
							})
						
					
				}
			},{
				text:"关闭",
				handler:function(){
					superCatDlgObj.close();
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
		$("#superCatDlg").show();
		var superCatDlgObj=$HUI.dialog("#superCatDlg",{
			iconCls:'icon-w-edit',
			title:'修改病人转归',
			resizable:true,
			modal:true,
			buttons:[{
				text:"保存",
				handler:function(){
					var data=$.m({
							ClassName:"web.DHCBPCVisitStatus",
							MethodName:"UpdateVStatus",
							bpcVSId:id,
							bpcVSCode:$("#code").val(),
							bpcVSDesc:$("#desc").val()
						},function(success){
							if(success==0)
							{
								superCatDlgObj.close();
								superCatObj.load();
							}else{
								$.messager.alert("提示","病人转归维护更新失败！", "error");
						}
						
					})
				}
			},{
				text:"关闭",
				handler:function(){
					superCatDlgObj.close();
				}
			}],
			onClose:function(){  
                	setDialogValue();
            }
		})
	}
	
	var superCatObj=$HUI.datagrid("#superCat",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCVisitStatus",
			QueryName:"FindVStatus",
			a:""
			
		},
        columns:[[
			{ field: "tBPCVSRowId", title: "编号", width: 120 },
            { field: "tBPCVSCode", title: "代码", width: 120 },
            { field: "tBPCVSDesc", title: "描述", width: 240 }
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
				var row=superCatObj.getSelected();
				if(row)
				{
					UpdateHandler(row.tBPCVSRowId,row.tBPCVSCode,row.tBPCVSDesc);
				}
			}
            },{ 
		    iconCls: 'icon-cancel',
		    text:'删除',
		    handler: function(){
				var row=superCatObj.getSelected();
				if(row)
				{
					$.messager.confirm("确认","确定删除？",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCBPCVisitStatus",
								MethodName:"DeleteVStatus",
								bpcVSId:row.tBPCVSRowId
							},function(success)
							{
								if(success==0)
								{
									superCatObj.load();
								}else{
									$.messager.alert("提示","删除失败！错误代码："+success, "error");
								}
							})
						}
					})
				}
			}
		}]
	})
});