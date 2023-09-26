function OnHidePanel(item)
{
	var valueField = $(item).combobox("options").valueField;
	var val = $(item).combobox("getValue");  //��ǰcombobox��ֵ
	var txt = $(item).combobox("getText");
	var allData = $(item).combobox("getData");   //��ȡcombobox��������
	var result = true;      //Ϊtrue˵�������ֵ�������������в�����
	if (val=="") result=false;
	for (var i = 0; i < allData.length; i++) {
		if (val == allData[i][valueField]) {
	    	result = false;
	    	break;
	    }
	}
	if (result) {
		$(item).combobox("clear");	    
	    $(item).combobox("reload");
	    if ((val==undefined)&&(txt!=""))
	    {
		    $(item).combobox('setValue',"");
	    	$.messager.alert("��ʾ","���������ѡ��","error");
	    	return;
	    }
	}
}
$(function(){
   	var initView=function(){
	   	var emManufacturerObj=$HUI.combobox("#emManufacturer",{
			url:$URL+"?ClassName=web.DHCBPCManufacturer&QueryName=FindEManufacturer&ResultSetType=array",
			textField:"BPCMDesc",
			valueField:"tRowId",
			panelHeight:'auto',
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
				},
			onHidePanel: function () {
        		OnHidePanel("#emManufacturer");
        	},
			})
			
		var emTypeObj=$HUI.combobox("#emType",{
			url:$URL+"?ClassName=web.DHCBPCEquipModel&QueryName=FindEMType&ResultSetType=array",
			textField:"Desc",
			valueField:"Id",
			panelHeight:"auto",
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
				},
			onHidePanel: function () {
        		OnHidePanel("#emType");
        	},
			})
		var emCanFilterObj=$HUI.combobox("#emCanFilter",{
			url:$URL+"?ClassName=web.DHCBPBedEquip&QueryName=FindBoolen&ResultSetType=array",
			textField:"Desc",
			valueField:"Id",
			panelHeight:"auto",
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
				},
			onHidePanel: function () {
        		OnHidePanel("#emCanFilter");
        	},
			})
   	}
	function setDialogValue()
	{		
		$("#RowId").val("");		
		$("#emCode").val("");
		$("#emDesc").val("");	
		$("#emAbbreviation").val("");
		$("#emManufacturer").combobox('setValue',"")
		$("#emAgent").val("");
		$("#emType").combobox('setValue',"")
		$("#emNote").val("");	
		$("#emCanFilter").combobox('setValue',"")
	}	
	var InsertHandler=function(){
		initView();
		$("#equipModeDialog").show();
		var equipModeDigObj=$HUI.dialog("#equipModeDialog",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			title:'�����豸�ͺ�',
			buttons:[{
				text:"����",
				handler:function(){
					if($("#emCode").val()==""){
						$.messager.alert("��ʾ","���벻��Ϊ��","error");
						return;
					}
					if($("#emDesc").val()==""){
						$.messager.alert("��ʾ","��������Ϊ��","error");
						return;
					}
					var data=$.m({
								ClassName:"web.DHCBPCEquipModel",
								MethodName:"InsertEModel",
								bpcEMCode:$("#emCode").val(),
								bpcEMDesc:$("#emDesc").val(),
								bpcEMAbbreviation:$("#emAbbreviation").val(),
								bpcEMManufacturerDr:$("#emManufacturer").combobox('getValue'),
								bpcEMAgent:$("#emAgent").val(),
								bpcEMType:$("#emType").combobox('getValue'),
								bpcEMNote:$("#emNote").val(),
								bpcEMCanFilter:$("#emCanFilter").combobox('getValue')							
							},function(success){
								if(success==0)
								{
									equipModeDigObj.close();
									equipModeObj.load();
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
					equipModeDigObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})

	}

	var UpdateHandler=function(row)
	{		
		initView();	
		$("#emCode").val(row.tBPCEMCode);
		$("#emDesc").val(row.tBPCEMDesc);	
		$("#emAbbreviation").val(row.tBPCEMAbbreviation);
		$("#emManufacturer").combobox('setValue',row.tBPCEMManufacturerDr);
		$("#emManufacturer").combobox('setText',row.tBPCEMManufacturerDesc);
		$("#emAgent").val(row.tBPCEMAgent);
		$("#emType").combobox('setValue',row.tBPCEMType);
		$("#emType").combobox('setText',row.tBPCEMTypeD);
		$("#emNote").val(row.tBPCEMNote);	
		$("#emCanFilter").combobox('setValue',row.tBPCEMCanFilterB);
		//$("#emCanFilter").combobox('setText',row.tBPCEMCanFilter);	
		$("#equipModeDialog").show();
		var equipModeDigObj=$HUI.dialog("#equipModeDialog",{
			iconCls:'icon-w-edit',
			resizable:true,
			modal:true,
			title:'�޸��豸�ͺ�',
			buttons:[{
				text:"����",
				handler:function(){
					if($("#emCode").val()==""){
						$.messager.alert("��ʾ","���벻��Ϊ��","error");
						return;
					}
					if($("#emDesc").val()==""){
						$.messager.alert("��ʾ","��������Ϊ��","error");
						return;
					}
					var data=$.m({
							ClassName:"web.DHCBPCEquipModel",
							MethodName:"UpdateEModel",
							bpcEMId:row.tID,
							bpcEMCode:$("#emCode").val(),
							bpcEMDesc:$("#emDesc").val(),
							bpcEMAbbreviation:$("#emAbbreviation").val(),
							bpcEMManufacturerDr:$("#emManufacturer").combobox('getValue'),
							bpcEMAgent:$("#emAgent").val(),
							bpcEMType:$("#emType").combobox('getValue'),
							bpcEMNote:$("#emNote").val(),
							bpcEMCanFilter:$("#emCanFilter").combobox('getValue')
						},function(success){
							if(success==0)
							{
								equipModeDigObj.close();
								equipModeObj.load();
							}else{
								$.messager.alert("��ʾ","�����豸�ͺŸ���ʧ�ܣ�");
						}
						
					})
				}
			},{
				text:"�ر�",
				handler:function(){
					equipModeDigObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})
	}
		
	var equipModeObj=$HUI.datagrid("#equipModeBox",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCEquipModel",
			QueryName:"FindEModel"
		},
        columns:[[
			{ field: "tID", title: "ϵͳ��", width: 120 },
			{ field: "tBPCEMCode",title:"����",width:240},
            { field: "tBPCEMDesc", title: "����", width: 240 },            
            { field: 'tBPCEMAbbreviation',title:'��д',width:140},
            { field: 'tBPCEMManufacturerDr',title:'��������Dr',width:140,hidden:true},  
            { field: 'tBPCEMManufacturerDesc',title:'��������',width:140},
            { field: 'tBPCEMAgent',title:'����',width:140},
            { field: 'tBPCEMType',title:'����Dr',width:140,hidden:true},  
            { field: 'tBPCEMTypeD',title:'����',width:140}, 
            { field: 'tBPCEMNote',title:'��ע',width:140}, 
            { field: 'tBPCEMCanFilterB',title:'�Ƿ����Dr',width:140,hidden:true},  
            { field: 'tBPCEMCanFilter',title:'�Ƿ����',width:140}, 
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
				var row=equipModeObj.getSelected();
				if(row)
				{
					UpdateHandler(row);
				}
			}
            },{ 
		    iconCls: 'icon-cancel',
		    text:'ɾ��',
		    handler: function(){
				var row=equipModeObj.getSelected();
				if(row)
				{
					$.messager.confirm("ȷ��","ȷ��ɾ����",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCBPCEquipModel",
								MethodName:"DeleteEModel",
								bpcEMId:row.tID
							},function(success)
							{
								if(success==0)
								{
									equipModeObj.load();
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