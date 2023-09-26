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
			title:'�����豸����ģʽ',
			buttons:[{
				text:"����",
				handler:function(){
					if($("#bpcERMCode").val()==""){
						$.messager.alert("��ʾ","���벻��Ϊ��","error");
						return;
					}
					if($("#bpcERMDesc").val()==""){
						$.messager.alert("��ʾ","���Ʋ���Ϊ��","error");
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
									$.messager.alert("��ʾ","����ʧ�ܣ�");
								}
							})
	
					}
				},{
					text:"�ر�",
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
			title:'�޸��豸����ģʽ',
			buttons:[{
				text:"����",
				handler:function(){
					if($("#bpcERMCode").val()==""){
						$.messager.alert("��ʾ","���벻��Ϊ��","error");
						return;
					}
					if($("#bpcERMDesc").val()==""){
						$.messager.alert("��ʾ","���Ʋ���Ϊ��","error");
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
							$.messager.alert("��ʾ","����ʧ�ܣ�");
						}
						
					})
				}
			},{
				text:"�ر�",
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
			{ field: "tBPCERMRowId", title: "���", width: 60 },
            { field: "tBPCERMCode", title: "����", width: 100 },
            { field: "tBPCERMDesc", title: "����", width: 100 },
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
				var row=equipRunModeUIObj.getSelected();
				if(row)
				{
					UpdateHandler(row.tBPCERMRowId,row.tBPCERMCode,row.tBPCERMDesc);
				}
			}
        },{
			///ɾ������
		    iconCls: 'icon-cancel',
		    text:'ɾ��',
		    handler: function(){
				var row=equipRunModeUIObj.getSelected();
				if(row)
				{
					$.messager.confirm("ȷ��","ȷ��ɾ����",function(r){
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
									$.messager.alert("��ʾ","ɾ��ʧ�ܣ�������룺"+success);
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