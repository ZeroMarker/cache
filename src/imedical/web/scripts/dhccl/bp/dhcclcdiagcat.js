$(function(){
	var InsertHandler=function(){
		$("#DiagnosticClassDlg").show();
		var DiagnosticClassDlgObj=$HUI.dialog("#DiagnosticClassDlg",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			title:'������Ϸ���',
			buttons:[{
				text:"����",
				handler:function(){
					if($("#code").val()==""){
						$.messager.alert("��ʾ","���벻��Ϊ��","error");
						return;
					}
					if($("#desc").val()==""){
						$.messager.alert("��ʾ","���Ʋ���Ϊ��","error");
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
									$.messager.alert("��ʾ","��ӳɹ���", 'info');
								}else
								{
									$.messager.alert("��ʾ","��Ϸ������ʧ�ܣ�", "error");
								}
							})
						
					
				}
			},{
				text:"�ر�",
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
			title:'�޸���Ϸ���',
			modal:true,
			buttons:[{
				text:"����",
				handler:function(){
					if($("#code").val()==""){
						$.messager.alert("��ʾ","���벻��Ϊ��","error");
						return;
					}
					if($("#desc").val()==""){
						$.messager.alert("��ʾ","���Ʋ���Ϊ��","error");
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
								$.messager.alert("��ʾ","���³ɹ���", 'info');
							}else{
								$.messager.alert("��ʾ","��Ϸ������ʧ�ܣ�", "error");
						}
						
					})
				}
			},{
				text:"�ر�",
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
			{ field: "rowId", title: "���", width: 120},
			{ field: "Code", title: "����", width: 300},
			{ field: "DiagCatDes", title: "����", width: 300}			
		]],
		pagination:true,
		pageSize: 20,
		pageList: [20, 50, 100],
		//rows:20,
		fit:true,
		fitColumns:true,
		headerCls:"panel-header-gray",
		singleSelect:true,
		checkOnSelect:true,	///easyuiȡ��������ѡ��״̬
		selectOncheck:true,
        iconCls:'icon-paper',
        rownumbers: true,
		toolbar:[{
			iconCls: "icon-add",
			text:'����',
			handler: function(){
				InsertHandler();
			}
			},{
			iconCls: "icon-write-order",
			text:'�޸�',
			handler: function(){
				var row=DiagnosticClassificationObj.getSelected();
				if(row)
				{
					UpdateHandler(row.rowId,row.Code,row.DiagCatDes);
				}
			}
			},{
			iconCls: "icon-cancel",
			text:'ɾ��',
			handler: function(){
				var row=DiagnosticClassificationObj.getSelected();
				if(row)
				{
					$.messager.confirm("ȷ��","ȷ��ɾ����",function(r){
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
									$.messager.alert("��ʾ","ɾ���ɹ���", 'info');
								}else{
									$.messager.alert("��ʾ","ɾ��ʧ�ܣ�������룺"+success, 'error');
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