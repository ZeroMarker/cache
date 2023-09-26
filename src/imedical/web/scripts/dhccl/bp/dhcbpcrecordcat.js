$(function(){
	var InsertHandler=function(){
		$("#superCatDlg").show();
		var superCatDlgObj=$HUI.dialog("#superCatDlg",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			title:'�����໤����',
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
								ClassName:"web.DHCBPCRecordCat",
								MethodName:"InsertBPCRecordCat",
								Code:$("#code").val(),
								Desc:$("#desc").val()
							},function(success){
								if(success==0)
								{
									superCatDlgObj.close();
									RecordViewObj.load();
									$.messager.alert("��ʾ","��ӳɹ���");
								}else
								{
									$.messager.alert("��ʾ","��ʾ�������ʧ�ܣ�");
								}
							})
						
					
				}
			},{
				text:"�ر�",
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
			title:'�޸ļ໤����',
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
								$.messager.alert("��ʾ","���³ɹ���");
							}else{
								$.messager.alert("��ʾ","��ʾ�������ʧ�ܣ�");
						}
						
					})
				}
			},{
				text:"�ر�",
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
			{ field: "tRowId", title: "ϵͳ��", width: 120},			
			{ field: "tBPCRCCode", title: "�໤�������", width: 300},
			{ field: "tBPCRCDesc", title: "�໤��������", width: 300},			
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
				var row=RecordViewObj.getSelected();
				if(row)
				{
					UpdateHandler(row.tRowId,row.tBPCRCCode,row.tBPCRCDesc);
				}
			}
			},{
			iconCls: "icon-cancel",
			text:'ɾ��',
			handler: function(){
				var row=RecordViewObj.getSelected();
				if(row)
				{
					$.messager.confirm("ȷ��","ȷ��ɾ����",function(r){
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
									$.messager.alert("��ʾ","ɾ���ɹ���");
								}else{
									$.messager.alert("��ʾ","ɾ��ʧ�ܣ�������룺"+success);
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