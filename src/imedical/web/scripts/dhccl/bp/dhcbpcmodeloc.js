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
		var ctLocObj=$HUI.combobox("#ctLoc",{
			url:$URL+"?ClassName=web.DHCBPCInquiry&QueryName=ctloclookup&ResultSetType=array",
			textField:"oprCtLoc",
			valueField:"oprLocId",
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
			},
			onHidePanel: function () {
        		OnHidePanel("#ctLoc");
        	},
			onBeforeLoad:function(param)
        	{
            	param.hospId=session['LOGON.HOSPID'];
        	}
			})			
		var modeObj=$HUI.combobox("#mode",{
			url:$URL+"?ClassName=web.DHCBPCBloodPurificationMode&QueryName=FindDHCBPCBPMode&ResultSetType=array",
			textField:"tBPCBPMDesc",
			valueField:"tBPCBPMRowId",
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
				},
			onHidePanel: function () {
        		OnHidePanel("#mode");
        	},
			})			
		}
	function setDialogValue()
	{
		$("#RowId").val("");
		$("#mode").combobox('setValue',"");
		$("#ctLoc").combobox('setValue',"");
	}	
	var InsertHandler=function(){
		initView();
		$("#modeLocDialog").show();
		var modeLocDlgObj=$HUI.dialog("#modeLocDialog",{
			iconCls:'icon-w-add',
			resizable:false,
			modal:true,
			title:'����������ʽ����',
			buttons:[{
				text:"����",
				handler:function(){
					if($("#mode").combobox('getValue')==""){
						$.messager.alert("��ʾ","͸����ʽ����Ϊ��","error");
						return;
					}
					if($("#ctLoc").combobox('getValue')==""){
						$.messager.alert("��ʾ","���Ҳ���Ϊ��","error");
						return;
					}	
					var data=$.m({
								ClassName:"web.DHCBPCBloodPurificationMode",
								MethodName:"InsertBPModeLoc",
								bpcModeDr:$("#mode").combobox('getValue'),
								ctloc:$("#ctLoc").combobox('getValue'),
								bpcModeAliasDesc:'',
								hospId:session['LOGON.HOSPID']
							},function(success){
								if(success==0)
								{
									modeLocDlgObj.close();
									modeLocObj.load();
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
					modeLocDlgObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})

	}

	var UpdateHandler=function(id,mlDr,mldesc,locDr,loc)
	{
		initView();
		$("#mode").combobox('setValue',mlDr)
		$("#mode").combobox('setText',mldesc)
		$("#ctLoc").combobox('setValue',locDr)
		$("#ctLoc").combobox('setText',loc)
		$("#modeLocDialog").show();
		var modeLocDlgObj=$HUI.dialog("#modeLocDialog",{
			iconCls:'icon-w-edit',
			resizable:false,
			modal:true,
			title:'�޸ľ�����ʽ����',
			buttons:[{
				text:"����",
				handler:function(){
					if($("#mode").combobox('getValue')==""){
						$.messager.alert("��ʾ","͸����ʽ����Ϊ��","error");
						return;
					}
					if($("#ctLoc").combobox('getValue')==""){
						$.messager.alert("��ʾ","���Ҳ���Ϊ��","error");
						return;
					}
					var data=$.m({
							ClassName:"web.DHCBPCBloodPurificationMode",
							MethodName:"UpdateBPModeLoc",
							bpMLId:id,
							bpcModeDr:$("#mode").combobox('getValue'),
							ctloc:$("#ctLoc").combobox('getValue'),
							bpcModeAliasDesc:'',
							hospId:session['LOGON.HOSPID']
						},function(success){
							if(success==0)
							{
								modeLocDlgObj.close();
								modeLocObj.load();
							}else{
								$.messager.alert("��ʾ","͸����ʽ���ø���ʧ�ܣ�");
						}
						
					})
				}
			},{
				text:"�ر�",
				handler:function(){
					modeLocDlgObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})
	}
	
	
	var modeLocObj=$HUI.datagrid("#modeLocBox",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCBloodPurificationMode",
			QueryName:"FindBPModeLoc",
			hospId:session['LOGON.HOSPID']
		},
        columns:[[
			{ field: "tModeRowId", title: "���", width: 120 },
            { field: "tBPMLDesc", title: "͸����ʽ", width: 240 },
            { field: "tBPMLLocDesc",title:"����",width:240},
            { field: 'tBPMLRowId',title:'͸����ʽID',width:140,hidden:true},
            { field: 'tBPMLLocId',title:'����ID',width:140,hidden:true}      
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
				var row=modeLocObj.getSelected();
				if(row)
				{
					UpdateHandler(row.tModeRowId,row.tBPMLRowId,row.tBPMLDesc,row.tBPMLLocId,row.tBPMLLocDesc);
				}
			}
            },{ 
		    iconCls: 'icon-cancel',
		    text:'ɾ��',
		    handler: function(){
				var row=modeLocObj.getSelected();
				if(row)
				{
					$.messager.confirm("ȷ��","ȷ��ɾ����",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCBPCBloodPurificationMode",
								MethodName:"DeleteBPModeLoc",
								bpMLId:row.tModeRowId
							},function(success)
							{
								if(success==0)
								{
									modeLocObj.load();
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