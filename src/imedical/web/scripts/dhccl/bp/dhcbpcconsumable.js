///combobox����ѡ����������ʾ
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
///combobox����ѡ��ҽ����������ʾ
function OnHidePanel2(item)
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
	    $(item).combobox('setValue',"");
	    $.messager.alert("��ʾ","���������ѡ��","error");
	    return;
	}
}
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
		$HUI.combobox("#bpcCType",{
			url:$URL+"?ClassName=web.DHCBPCConsumable&QueryName=FindCType&ResultSetType=array",
			textField:"Desc",
			valueField:"Id",
			panelHeight:"auto",
			formatter:function(row){				
				var opts = $(this).combobox('options');
				return row[opts.textField];

			},
			onHidePanel: function () {
        		OnHidePanel("#bpcCType");
        	},	
		});
		$HUI.combobox("#bpcCHighFluxed",{
			url:$URL+"?ClassName=web.DHCBPCConsumable&QueryName=FindCBoolen&ResultSetType=array",
			textField:"Desc",
			valueField:"Id",
			panelHeight:"auto",
			formatter:function(row){				
				var opts = $(this).combobox('options');
				return row[opts.textField];

			},
			onHidePanel: function () {
        		OnHidePanel("#bpcCHighFluxed");
        	},			
		});
		$HUI.combobox("#bpcCArcim",{
			url:$URL+"?ClassName=web.DHCBPOrder&QueryName=GetArcimList&ResultSetType=array",
			valueField:"Id",
			textField:"Desc",
			formatter:function (row){
	        	var opts = $(this).combobox('options');
				return row[opts.textField];
        	},						
			onBeforeLoad:function(param)
        	{            	
            	param.needItemCatId="";
            	param.needArcimDesc=param.q;
            	param.arcimIdStr=""
        	},        	
        	mode:"remote",
        	onHidePanel: function () {
        		OnHidePanel2("#bpcCArcim");
        	},
		});
		
	
	function setDialogValue()
	{
		$("#bpcCCode").val("");
		$("#bpcCDesc").val("");
		$("#bpcCType").combobox('setValue',"");
		$("#bpcCMembraneArea").val("");
		$("#bpcCHighFluxed").combobox('setValue',"");
		$("#bpcCArcim").combobox('setValue',"");
	}	
	var insertHandler=function(){
		$("#consumableDlg").show();
		var consumableDlgObj=$HUI.dialog("#consumableDlg",{
			iconCls:'icon-w-add',
			resizable:false,
			modal:true,
			title:'�����������',
			buttons:[
			{
				text:"����",
				handler:function(){
					$.m({
						ClassName:"web.DHCBPCConsumable",
						MethodName:"InsertConsumable",
						bpcCCode:$("#bpcCCode").val(),
						bpcCDesc:$("#bpcCDesc").val(),
						bpcCType:$("#bpcCType").combobox('getValue'),
						bpcCMembraneArea:$("#bpcCMembraneArea").val(),
						bpcCHighFluxed:$("#bpcCHighFluxed").combobox('getValue'),
						bpcCArcimDr:$("#bpcCArcim").combobox('getValue'),
						
						},function(s){
							if(s==0){
								consumableDlgObj.close();
								consumableBoxObj.load();
								}else{
									$.messager.alert("��ʾ",s)
									}
							
							}
					)
					
					}
				},
			{
				text:"�ر�",
				handler:function(){
					
					consumableDlgObj.close();
					}
				}
			],			
			onClose:function(){  
                setDialogValue();
            } 
			
			
			})
		
		
		}
	var updateHandler=function(r){
		var id=r.tID
		$("#bpcCCode").val(r.tBPCCCode)
		$("#bpcCDesc").val(r.tBPCCDesc)
		$("#bpcCMembraneArea").val(r.tBPCCMembraneArea)
		$("#bpcCType").combobox('setValue',r.tBPCCType)
		$("#bpcCType").combobox('setText',r.tBPCCTypeD)
		$("#bpcCHighFluxed").combobox('setValue',r.tBPCCHighFluxed)
		$("#bpcCHighFluxed").combobox('setText',r.tBPCCHighFluxedD)
		$("#bpcCArcim").combobox('setValue',r.tBPCCArcimDr);
		$("#bpcCArcim").combobox('setText',r.tBPCCArcim);
		$("#consumableDlg").show();
		var consumableDlgObj=$HUI.dialog("#consumableDlg",{
			iconCls:'icon-w-edit',
			resizable:false,
			modal:true,
			title:'�޸Ĳ������',
			buttons:[
			{
				text:"����",
				handler:function(){				
					$.m({
						ClassName:"web.DHCBPCConsumable",
						MethodName:"UpdateConsumable",
						bpcCId:id,
						bpcCCode:$("#bpcCCode").val(),
						bpcCDesc:$("#bpcCDesc").val(),
						bpcCType:$("#bpcCType").combobox('getValue'),
						bpcCMembraneArea:$("#bpcCMembraneArea").val(),
						bpcCHighFluxed:$("#bpcCHighFluxed").combobox('getValue'),
						bpcCArcimDr:$("#bpcCArcim").combobox('getValue'),
						},function(s){
							if(s==0){
								consumableDlgObj.close();
								consumableBoxObj.load();
								}else{
									$.messager.alert("��ʾ","����ʧ�ܣ�"+s)
									}
							
							}
					)
					
					}
				},
			{
				text:"�ر�",
				handler:function(){
					
					consumableDlgObj.close();
					}
				}
			],			
			onClose:function(){  
                setDialogValue();
            } 
			
			
			})
		
		
		
		
		}
	var deleteHandler=function(r){
		$.m({
			ClassName:"web.DHCBPCConsumable",
			MethodName:"DeleteConsumable",
			bpcCId:r.tID
			
			},function(s){
				if(s==0){
					
					$.messager.alert("��ʾ","ɾ���ɹ���");
						consumableBoxObj.load();
						}else{
						$.messager.alert("��ʾ","ɾ��ʧ�ܣ�"+s);
							}
				})
		
		}	
	var consumableBoxObj=$HUI.datagrid("#consumableBox",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCConsumable",
			QueryName:"FindConsumable"
			
			},
		columns:[[
		{field:"tID",title:"���",width:60},
		{field:"tBPCCCode",title:"����",width:150},
		{field:"tBPCCDesc",title:"����",width:150},
		{field:"tBPCCTypeD",title:"����",width:100},
		{field:"tBPCCMembraneArea",title:"Ĥ���",width:100},
		{field:"tBPCCHighFluxedD",title:"�Ƿ��ͨ��",width:100},
		{field:"tBPCCArcim",title:"ҽ��",width:100},
		{field:"tBPCCType",hidden:true},
		{field:"tBPCCHighFluxed",hidden:true},
		{field:"tBPCCArcimDr",hidden:true},
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
		toolbar:[
		{
			text:"����",
			iconCls:"icon-add",
			handler:function(){
				insertHandler();
				}
			
			},
		{
			text:"�޸�",
			iconCls:"icon-write-order"
			,handler:function(){
				var rows=$("#consumableBox").datagrid('getSelections')
				if(rows.length!=1)
				{
					$.messager.alert("��ʾ","��ѡ��һ�У�", "error")
					}else{
						updateHandler(rows[0]);
						}
				}
			
			},
		{
			text:"ɾ��",
			iconCls:"icon-cancel",
			handler:function(){
				var rows=$("#consumableBox").datagrid('getSelections')
				if(rows.length!=1)
				{
					$.messager.alert("��ʾ","��ѡ��һ�У�", "error")
					}else{
						deleteHandler(rows[0]);
						}
				}
				
			
			}
		
		],
		fit:true,
		pagination:true
		
		
		})
	
	
	
	
	
	})