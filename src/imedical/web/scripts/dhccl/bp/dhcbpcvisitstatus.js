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
			title:'��������ת��',
			modal:true,
			buttons:[{
				text:"����",
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
									$.messager.alert("��ʾ","����ת��ά�����ʧ�ܣ�", "error");
								}
							})
						
					
				}
			},{
				text:"�ر�",
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
			title:'�޸Ĳ���ת��',
			resizable:true,
			modal:true,
			buttons:[{
				text:"����",
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
								$.messager.alert("��ʾ","����ת��ά������ʧ�ܣ�", "error");
						}
						
					})
				}
			},{
				text:"�ر�",
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
			{ field: "tBPCVSRowId", title: "���", width: 120 },
            { field: "tBPCVSCode", title: "����", width: 120 },
            { field: "tBPCVSDesc", title: "����", width: 240 }
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
			iconCls: 'icon-add',
		    text:'����',
		    handler: function(){
				InsertHandler();
			}
	        },{
	        iconCls: 'icon-write-order',
	        text:'�޸�',
		    handler: function(){
				var row=superCatObj.getSelected();
				if(row)
				{
					UpdateHandler(row.tBPCVSRowId,row.tBPCVSCode,row.tBPCVSDesc);
				}
			}
            },{ 
		    iconCls: 'icon-cancel',
		    text:'ɾ��',
		    handler: function(){
				var row=superCatObj.getSelected();
				if(row)
				{
					$.messager.confirm("ȷ��","ȷ��ɾ����",function(r){
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
									$.messager.alert("��ʾ","ɾ��ʧ�ܣ�������룺"+success, "error");
								}
							})
						}
					})
				}
			}
		}]
	})
});