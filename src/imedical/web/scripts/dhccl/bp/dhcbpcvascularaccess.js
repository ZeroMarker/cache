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
			title:'����Ѫ��ͨ·',
			modal:true,
			buttons:[{
				text:"����",
				handler:function(){
					if($("#code").val()==""){
						$.messager.alert("��ʾ","���벻��Ϊ��", "error");
						return;
					}
					if($("#desc").val()==""){
						$.messager.alert("��ʾ","���Ʋ���Ϊ��", "error");
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
									$.messager.alert("��ʾ",success);
								}
							})
				}
			},
			{
				text:"�ر�",
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
			title:'�޸�Ѫ��ͨ·��Ϣ',
			resizable:true,
			modal:true,
			buttons:[{
				text:"����",
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
								$.messager.alert("��ʾ","Ѫ��ͨ·����ʧ�ܣ�", "error");
						}
						
					})
				}
			},{
				text:"�ر�",
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
			{ field: "tBPCVARowId", title: "���", width: 60 },
            { field: "tBPCVACode", title: "����", width: 120 },
            { field: "tBPCVADesc", title: "����", width: 240 }
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
				var row=vascularaccessObj.getSelected();
				if(row)
				{
					UpdateHandler(row.tBPCVARowId,row.tBPCVACode,row.tBPCVADesc);
				}
			}
            },{ 
		    iconCls: 'icon-cancel',
		    text:'ɾ��',
		    handler: function(){
				var row=vascularaccessObj.getSelected();
				if(row)
				{
					$.messager.confirm("ȷ��","ȷ��ɾ����",function(r){
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
									$.messager.alert("��ʾ","ɾ��ʧ�ܣ�������룺"+success, "error");
								}
							})
						}
					})
				}
			}
		}]
	})

	
})