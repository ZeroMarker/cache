$(function(){
   	var initView=function(){
		var ctLocObj=$HUI.combobox("#ctLoc",{
			url:$URL+"?ClassName=web.DHCBPCInquiry&QueryName=ctloclookup&ResultSetType=array",
			textField:"oprCtLoc",
			valueField:"oprLocId",
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
				}
			})			
		var vasAccessObj=$HUI.combobox("#vasAccess",{
			url:$URL+"?ClassName=web.DHCBPCVascularAccess&QueryName=FindVasAccess&ResultSetType=array",
			textField:"tBPCVADesc",
			valueField:"tBPCVARowId",
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
				}
			})			
		}
	function setDialogValue()
	{
		$("#vasAccess").combobox('setValue',"");
		$("#ctLoc").combobox('setValue',"");
	}	
	var InsertHandler=function(){
		initView();
		$("#vascularaccessLocDialog").show();
		var vascularaccesslocDlgObj=$HUI.dialog("#vascularaccessLocDialog",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			title:'����Ѫ��ͨ·����',
			buttons:[{
				text:"����",
				handler:function(){
					if($("#vasAccess").combobox('getValue')==""){
						$.messager.alert("��ʾ","Ѫ��ͨ·����Ϊ��","error");
						return;
					}
					if($("#ctLoc").combobox('getValue')==""){
						$.messager.alert("��ʾ","���Ҳ���Ϊ��","error");
						return;
					}	
					var data=$.m({
								ClassName:"web.DHCBPCVascularAccess",
								MethodName:"InsertVasAccessLoc",
								bpcVADr:$("#vasAccess").combobox('getValue'),
								ctloc:$("#ctLoc").combobox('getValue')
							},function(success){
								if(success==0)
								{
									vascularaccesslocDlgObj.close();
									vascularaccesslocObj.load();
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
					vascularaccesslocDlgObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})
	}

	var UpdateHandler=function(id,vaDr,vadesc,locDr,loc)
	{
		initView();
		$("#vasAccess").combobox('setValue',vaDr)
		$("#vasAccess").combobox('setText',vadesc)
		$("#ctLoc").combobox('setValue',locDr)
		$("#ctLoc").combobox('setText',loc)
		$("#vascularaccessLocDialog").show();
		var vascularaccesslocDlgObj=$HUI.dialog("#vascularaccessLocDialog",{
			iconCls:'icon-w-edit',
			resizable:true,
			modal:true,
			title:'�޸�Ѫ��ͨ·����',
			buttons:[{
				text:"����",
				handler:function(){
					var data=$.m({
							ClassName:"web.DHCBPCVascularAccess",
							MethodName:"UpdateVasAccessLoc",
							bpVALId:id,
							BPVALBPCVADr:$("#vasAccess").combobox('getValue'),
							ctloc:$("#ctLoc").combobox('getValue')
						},function(success){
							if(success==0)
							{
								vascularaccesslocDlgObj.close();
								vascularaccesslocObj.load();
							}else{
								$.messager.alert("��ʾ","Ѫ��ͨ·����ʧ�ܣ�");
						}
						
					})
				}
			},{
				text:"�ر�",
				handler:function(){
					vascularaccesslocDlgObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})
	}
	
	
	var vascularaccesslocObj=$HUI.datagrid("#vascularaccessLocBox",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCVascularAccess",
			QueryName:"FindVasAccessLoc"
		},
        columns:[[
			{ field: "tValRowId", title: "���", width: 120 },
            { field: "tBPVALCVADesc", title: "Ѫ��ͨ·", width: 250 },
            { field: "tBPVALCVALocDesc",title:"����",width:250},
            { field: 'tBPVALCVARowId',title:'Ѫ��ͨ·ID',width:140,hidden:true},
            { field: 'tBPVALCVALocId',title:'����ID',width:140,hidden:true}      
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
				var row=vascularaccesslocObj.getSelected();
				if(row)
				{
					UpdateHandler(row.tValRowId,row.tBPVALCVARowId,row.tBPVALCVADesc,row.tBPVALCVALocId,row.tBPVALCVALocDesc);
				}
			}
            },{ 
		    iconCls: 'icon-cancel',
		    text:'ɾ��',
		    handler: function(){
				var row=vascularaccesslocObj.getSelected();
				if(row)
				{
					$.messager.confirm("ȷ��","ȷ��ɾ����",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCBPCVascularAccess",
								MethodName:"DeleteVasAccessLoc",
								bpVALId:row.tValRowId
							},function(success)
							{
								if(success==0)
								{
									vascularaccesslocObj.load();
								}else{
									$.messager.alert("��ʾ","ɾ��ʧ�ܣ�������룺"+success);
								}
							})
						}
					})
				}
			}
		}]
	})

	
})