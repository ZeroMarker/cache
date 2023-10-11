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
			,
			onBeforeLoad:function(param)
        	{
            	param.hospId=session['LOGON.HOSPID'];
        	}
			})			
		var amModeObj=$HUI.combobox("#amlMode",{
			url:$URL+"?ClassName=web.DHCBPCAnticoagulantMode&QueryName=FindAntMode&ResultSetType=array",
			textField:"tBPCAMDesc",
			valueField:"tBPCAMRowId",
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
				}
			})			
		}
	function setDialogValue()
	{
		$("#amlMode").combobox('setValue',"");
		$("#ctLoc").combobox('setValue',"");
	}	
	var InsertHandler=function(){
		initView();
		$("#anticoagulantmodeLocDialog").show();
		var anticoagulantmodeLocDlgObj=$HUI.dialog("#anticoagulantmodeLocDialog",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			title:'����������ʽ����',
			buttons:[{
				text:"����",
				handler:function(){
					if($("#amlMode").combobox('getValue')==""){
						$.messager.alert("��ʾ","������ʽ����Ϊ��","error");
						return;
					}
					if($("#ctLoc").combobox('getValue')==""){
						$.messager.alert("��ʾ","���Ҳ���Ϊ��","error");
						return;
					}	
					var data=$.m({
								ClassName:"web.DHCBPCAnticoagulantMode",
								MethodName:"InsertAntModeLoc",
								bpcAMDr:$("#amlMode").combobox('getValue'),
								ctloc:$("#ctLoc").combobox('getValue'),
								hospId:session['LOGON.HOSPID']
							},function(success){
								if(success==0)
								{
									anticoagulantmodeLocDlgObj.close();
									anticoagulantmodeLocObj.load();
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
					anticoagulantmodeLocDlgObj.close();
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
		$("#amlMode").combobox('setValue',vaDr)
		$("#amlMode").combobox('setText',vadesc)
		$("#ctLoc").combobox('setValue',locDr)
		$("#ctLoc").combobox('setText',loc)
		$("#anticoagulantmodeLocDialog").show();
		var anticoagulantmodeLocDlgObj=$HUI.dialog("#anticoagulantmodeLocDialog",{
			iconCls:'icon-w-edit',
			resizable:true,
			modal:true,
			title:'�޸Ŀ�����ʽ����',
			buttons:[{
				text:"����",
				handler:function(){
					var data=$.m({
							ClassName:"web.DHCBPCAnticoagulantMode",
							MethodName:"UpdateAntModeLoc",
							bpAMLId:id,
							BPAMLBPCAMDr:$("#amlMode").combobox('getValue'),
							ctloc:$("#ctLoc").combobox('getValue'),
							hospId:session['LOGON.HOSPID']
						},function(success){
							if(success==0)
							{
								anticoagulantmodeLocDlgObj.close();
								anticoagulantmodeLocObj.load();
							}else{
								$.messager.alert("��ʾ","������ʽ����ʧ�ܣ�");
						}
						
					})
				}
			},{
				text:"�ر�",
				handler:function(){
					anticoagulantmodeLocDlgObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})
	}
	
	
	var anticoagulantmodeLocObj=$HUI.datagrid("#anticoagulantmodeLocBox",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCAnticoagulantMode",
			QueryName:"FindAntModeLoc",
			hospId:session['LOGON.HOSPID']
		},
        columns:[[
			{ field: "tAmlRowId", title: "���", width: 120 },
            { field: "tBPAMLCAMDesc", title: "������ʽ", width: 250 },
            { field: "tBPAMLCAMLocDesc",title:"����",width:250},
            { field: 'tBPAMLCAMRowId',title:'������ʽID',width:140,hidden:true},
            { field: 'tBPAMLCAMLocId',title:'����ID',width:140,hidden:true}      
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
				var row=anticoagulantmodeLocObj.getSelected();
				if(row)
				{
					UpdateHandler(row.tAmlRowId,row.tBPAMLCAMRowId,row.tBPAMLCAMDesc,row.tBPAMLCAMLocId,row.tBPAMLCAMLocDesc);
				}
			}
            },{ 
		    iconCls: 'icon-cancel',
		    text:'ɾ��',
		    handler: function(){
				var row=anticoagulantmodeLocObj.getSelected();
				if(row)
				{
					$.messager.confirm("ȷ��","ȷ��ɾ����",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCBPCAnticoagulantMode",
								MethodName:"DeleteAntModeLoc",
								bpAMLId:row.tAmlRowId
							},function(success)
							{
								if(success==0)
								{
									anticoagulantmodeLocObj.load();
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