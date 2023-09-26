$(function(){
	var InsertHandler=function(){
		$("#superCatDlg").show();
		var superCatDlgObj=$HUI.dialog("#superCatDlg",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			title:'新增监护大类',
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#code").val()==""){
						$.messager.alert("提示","代码不能为空","error");
						return;
					}
					if($("#desc").val()==""){
						$.messager.alert("提示","名称不能为空","error");
						return;
					}	
					var data=$.m({
								ClassName:"web.DHCBPCRecordCat",
								MethodName:"InsertBPCRecordCat",
								Code:$("#code").val(),
								Desc:$("#desc").val()
							},function(success){
								if(success==0)
								{
									superCatDlgObj.close();
									RecordViewObj.load();
									$.messager.alert("提示","添加成功！");
								}else
								{
									$.messager.alert("提示","显示大类添加失败！");
								}
							})
						
					
				}
			},{
				text:"关闭",
				handler:function(){
					superCatDlgObj.close();
				}
			}]
		})
	}
	
	var UpdateHandler=function(id,code,desc)
	{
		$("#code").val(code);
		$("#desc").val(desc);
		$("#superCatDlg").show();
		var superCatDlgObj=$HUI.dialog("#superCatDlg",{
			iconCls:'icon-w-edit',
			resizable:true,
			modal:true,
			title:'修改监护大类',
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#code").val()==""){
						$.messager.alert("提示","代码不能为空","error");
						return;
					}
					if($("#desc").val()==""){
						$.messager.alert("提示","名称不能为空","error");
						return;
					}
					var data=$.m({
							ClassName:"web.DHCBPCRecordCat",
							MethodName:"UpdateBPCRecordCat",
							BPCRCRowid:id,
							Code:$("#code").val(),
							Desc:$("#desc").val()
						},function(success){
							if(success==0)
							{
								superCatDlgObj.close();
								RecordViewObj.load();
								$.messager.alert("提示","更新成功！");
							}else{
								$.messager.alert("提示","显示大类更新失败！");
						}
						
					})
				}
			},{
				text:"关闭",
				handler:function(){
					superCatDlgObj.close();
				}
			}]
		})
	}
	
	var RecordViewObj=$HUI.datagrid("#RecordView",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCRecordCat",
			QueryName:"FindBPCReCat",
			tBPCRCCode:''
			},
		columns:[[
			{ field: "tRowId", title: "系统号", width: 120},			
			{ field: "tBPCRCCode", title: "监护大类代码", width: 300},
			{ field: "tBPCRCDesc", title: "监护大类名称", width: 300},			
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
			iconCls: "icon-add",
			text:'新增',
			handler: function(){
				InsertHandler();
			}
			},{
			iconCls: "icon-write-order",
			text:'修改',
			handler: function(){
				var row=RecordViewObj.getSelected();
				if(row)
				{
					UpdateHandler(row.tRowId,row.tBPCRCCode,row.tBPCRCDesc);
				}
			}
			},{
			iconCls: "icon-cancel",
			text:'删除',
			handler: function(){
				var row=RecordViewObj.getSelected();
				if(row)
				{
					$.messager.confirm("确认","确定删除？",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCBPCRecordCat",
								MethodName:"DeleteBPCRecordCat",
								BPCRCRowid:row.tRowId
							},function(success)
							{
								if(success==0)
								{
									RecordViewObj.load();
									$.messager.alert("提示","删除成功！");
								}else{
									$.messager.alert("提示","删除失败！错误代码："+success);
								}
							})
						}
					})
				}
			}	
		}
		]
	})
})