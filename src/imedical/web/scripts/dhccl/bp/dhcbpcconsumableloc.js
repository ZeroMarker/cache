///combogrid����ѡ�񣬶�ѡ��������ʾ
function OnHidePanel3(item)
{
	var idField = $(item).combogrid("options").idField;
	var vals = $(item).combogrid("getValues");  //��ǰcombobox��ֵ
	var txt = $(item).combogrid("getText");
	var allData = $(item).combogrid("grid").datagrid('getSelections');   //��ȡcombobox��������
	var result = true;      //Ϊtrue˵�������ֵ�������������в�����
	for (var i = 0; i < allData.length; i++) {
		for (var j = 0; j < vals.length; j++) 
		{
			if (vals[j] == allData[i][idField]) {
	    		result = false;
	    		break;
	    	}
		}
	}
	if (result) {
	    if ((vals.length==0)&&(txt!=""))
	    {
		    $(item).combobox("clear");	    
	    	$(item).combobox("reload");
		    $(item).combobox('setValue',"");
	    	$.messager.alert("��ʾ","���������ѡ��","error");
	    	return;
	    }
	}
}
$(function(){
   	var initView=function(){
		var ctLocObj=$HUI.combobox("#bpcCtlocDr",{
			url:$URL+"?ClassName=web.DHCBPCInquiry&QueryName=ctloclookup&ResultSetType=array",
			textField:"oprCtLoc",
			valueField:"oprLocId",
			formatter:function(row){				
				var opts = $(this).combobox('options');
				return row[opts.textField];
			},
			onBeforeLoad:function(param)
        	{
            	param.hospId=session['LOGON.HOSPID'];
        	}
			})			
		var conObj=$HUI.combobox("#bpcCMode",{
			url:$URL+"?ClassName=web.DHCBPCConsumable&QueryName=FindConsumable&ResultSetType=array",
			textField:"tBPCCDesc",
			valueField:"tID",
			formatter:function(row){				
				var opts = $(this).combobox('options');
				return row[opts.textField];
				}
			})			
		}
		$HUI.combogrid("#BPCBPMode",{
			idField:"tBPCBPMRowId",
			textField:"tBPCBPMDesc",
			mode:"remote",
			multiple:true,
			url:$URL,  //"dhcclinic.jquery.csp",
			queryParams:{
				ClassName:"web.DHCBPCBloodPurificationMode",
				QueryName:"FindDHCBPCBPMode",
				ctlocId:""			
				},
			columns:[[
			{filed:"ck",checkbox:true,width:0},
			{field:"tBPCBPMDesc",title:"͸����ʽ"}
			]],
			onHidePanel: function () {
        		OnHidePanel3("#BPCBPMode");
        	},			
		});
	function setDialogValue()
	{
		$("#bpcCMode").combobox('setValue',"");
		$("#BPCBPMode").combobox('setValue',"");
		$("#bpcCtlocDr").combobox('setValue',"");
	}	
	var InsertHandler=function(){
		initView();
		$("#consumablelocDialog").show();
		var consumablelocDialog=$HUI.dialog("#consumablelocDialog",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			title:'�����Ĳ�ά������',
			buttons:[{
				text:"����",
				handler:function(){
					if($("#bpcCMode").combobox('getValue')==""){
						$.messager.alert("��ʾ","�ĲĲ���Ϊ��","error");
						return;
					}
					if($("#BPCBPMode").combobox('getValue')==""){
						$.messager.alert("��ʾ","͸����ʽ����Ϊ��","error");
						return;
					}
					var MDrow=$("#BPCBPMode").combogrid('grid').datagrid('getSelections')					
					if (MDrow.length>0)
					{	
						var r=MDrow[0].tBPCBPMRowId;				
						for(var i=1;i<MDrow.length;i++)
						{
							r=r+","+MDrow[i].tBPCBPMRowId
						}
					}	
					var data=$.m({
								ClassName:"web.DHCBPCConsumable",
								MethodName:"InsertConsumableLoc",
								bpcCId:$("#bpcCMode").combobox('getValue'),
								bpcMDrList:r,
								bpLocIdList:$("#bpcCtlocDr").combobox('getValue'),
								hospId:session['LOGON.HOSPID']
							},function(success){
								if(success==0)
								{
									consumablelocDialog.close();
									consumablelocObj.load();
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
					consumablelocDialog.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})
	}
	var UpdateHandler=function(tCID,tBPCCDesc,tBPCBPMRowId,tBPCBPMDesc,tBPCBPMDeptDr,tBPCBPMDept)
	{
		initView();
		var Mode=[]
		Mode=tBPCBPMRowId.split(",")
		$("#bpcCMode").combobox('setValue',tCID)
		$("#bpcCMode").combobox('setText',tBPCCDesc)
		$("#BPCBPMode").combogrid('setValues',Mode)
		$("#bpcCtlocDr").combobox('setValue',tBPCBPMDeptDr)
		$("#bpcCtlocDr").combobox('setText',tBPCBPMDept)
		$("#consumablelocDialog").show();
		var consumablelocDialog=$HUI.dialog("#consumablelocDialog",{
			iconCls:'icon-w-edit',
			resizable:true,
			modal:true,
			title:'�޸ĺĲ�ά������',
			buttons:[{
				text:"����",
				handler:function(){
					if($("#bpcCMode").combobox('getValue')==""){
						$.messager.alert("��ʾ","�ĲĲ���Ϊ��","error");
						return;
					}
					if($("#BPCBPMode").combobox('getValue')==""){
						$.messager.alert("��ʾ","͸����ʽ����Ϊ��","error");
						return;
					}
					var MDrow=$("#BPCBPMode").combogrid('grid').datagrid('getSelections')
					if (MDrow.length>0)
					{
						var MDr=MDrow[0].tBPCBPMRowId;
						for(var i=1;i<MDrow.length;i++)
						{
							MDr=MDr+","+MDrow[i].tBPCBPMRowId
						}
					}
					var data=$.m({
							ClassName:"web.DHCBPCConsumable",
							MethodName:"UpdateConsumableLoc",
							bpcCId:$("#bpcCMode").combobox('getValue'),
							bpcMDrList:MDr,
							bpLocIdList:$("#bpcCtlocDr").combobox('getValue'),
							hospId:session['LOGON.HOSPID']
						},function(success){
							if(success==0)
							{
								consumablelocDialog.close();
								consumablelocObj.load();
							}else{
								$.messager.alert("��ʾ","�Ĳ�������ʧ�ܣ�������룺"+success);
						}
						
					})
				}
			},{
				text:"�ر�",
				handler:function(){
					consumablelocDialog.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})
	}
	
	
	var consumablelocObj=$HUI.datagrid("#consumablelocBox",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCConsumable",
			QueryName:"FindConsumableLoc",
			hospId:session['LOGON.HOSPID']
		},
        columns:[[
            { field: "tBPCCDesc", title: "�Ĳ�", width: 150 },            
            { field: 'tCID',title:'�Ĳ�ά��ID',width:140,hidden:true},
            { field: "tBPCBPMDesc",title:"͸����ʽ",width:400},
            { field: 'tBPCBPMRowId',title:'͸����ʽID',width:140,hidden:true}, 
            { field: "tBPCBPMDept",title:"����",width:250},
            { field: 'tBPCBPMDeptDr',title:'����ID',width:140,hidden:true}  
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
				var row=consumablelocObj.getSelected();
				if(row)
				{
					UpdateHandler(row.tCID,row.tBPCCDesc,row.tBPCBPMRowId,row.tBPCBPMDesc,row.tBPCBPMDeptDr,row.tBPCBPMDept);
				}
			}
            },{ 
		    iconCls: 'icon-cancel',
		    text:'ɾ��',
		    handler: function(){
				var row=consumablelocObj.getSelected();
				if(row)
				{
					$.messager.confirm("ȷ��","ȷ��ɾ����",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCBPCConsumable",
								MethodName:"DeleteConsumableLoc",
								bpcCId:row.tCID
							},function(success)
							{
								if(success==0)
								{
									consumablelocObj.load();
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
