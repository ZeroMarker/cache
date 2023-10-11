$(function(){
	var InsertHandler=function(){
		$("#DiagnosticClassDlg").show();
		var DiagnosticClassDlgObj=$HUI.dialog("#DiagnosticClassDlg",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			title:'新增诊断分类',
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
								ClassName:"web.DHCCLCDiagCat",
								MethodName:"InsertDiagCat",
								Code:$("#code").val(),
								Desc:$("#desc").val(),
								hospId:session['LOGON.HOSPID']
							},function(success){
								if(success==0)
								{
									DiagnosticClassDlgObj.close();
									DiagnosticClassificationObj.load();
									$.messager.alert("提示","添加成功！", 'info');
								}else
								{
									$.messager.alert("提示","诊断分类添加失败！", "error");
								}
							})
						
					
				}
			},{
				text:"关闭",
				handler:function(){
					DiagnosticClassDlgObj.close();
				}
			}]
		})
	}
	
	var UpdateHandler=function(id,code,desc)
	{
		$("#code").val(code);
		$("#desc").val(desc);
		$("#DiagnosticClassDlg").show();
		var DiagnosticClassDlgObj=$HUI.dialog("#DiagnosticClassDlg",{
			iconCls:'icon-w-edit',
			resizable:true,
			title:'修改诊断分类',
			modal:true,
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
							ClassName:"web.DHCCLCDiagCat",
							MethodName:"UpdateDiagCat",
							Rowid:id,
							Code:$("#code").val(),
							Desc:$("#desc").val(),
							hospId:session['LOGON.HOSPID']
						},function(success){
							if(success==0)
							{
								DiagnosticClassDlgObj.close();
								DiagnosticClassificationObj.load();
								$.messager.alert("提示","更新成功！", 'info');
							}else{
								$.messager.alert("提示","诊断分类更新失败！", "error");
						}
						
					})
				}
			},{
				text:"关闭",
				handler:function(){
					DiagnosticClassDlgObj.close();
				}
			}]
		})
	}
	
	var DiagnosticClassificationObj=$HUI.datagrid("#DiagnosticClassification",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCCLCDiagCat",
			QueryName:"LookUpDiagCat",
			Code:'',
			hospId:session['LOGON.HOSPID']
			},
		columns:[[
			{ field: "rowId", title: "编号", width: 120},
			{ field: "Code", title: "代码", width: 300},
			{ field: "DiagCatDes", title: "名称", width: 300}			
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
				var row=DiagnosticClassificationObj.getSelected();
				if(row)
				{
					UpdateHandler(row.rowId,row.Code,row.DiagCatDes);
				}
			}
			},{
			iconCls: "icon-cancel",
			text:'删除',
			handler: function(){
				var row=DiagnosticClassificationObj.getSelected();
				if(row)
				{
					$.messager.confirm("确认","确定删除？",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCCLCDiagCat",
								MethodName:"DeleteDiagCat",
								Rowid:row.rowId
							},function(success)
							{
								if(success==0)
								{
									DiagnosticClassificationObj.load();
									$.messager.alert("提示","删除成功！", 'info');
								}else{
									$.messager.alert("提示","删除失败！错误代码："+success, 'error');
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