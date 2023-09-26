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
	    var modeSpecialBox = $HUI.combobox("#modeSpecial",{
		    valueField:"modeSpecial",
		    textField:'modeSpecialDesc',
		    panelHeight:"auto",
			data:[
			{modeSpecial:"Y",modeSpecialDesc:"��"},
			{modeSpecial:"N",modeSpecialDesc:"��"}
			],
			onHidePanel: function () {
        		OnHidePanel("#modeSpecial");
        	},
	    });
   	}
	function setDialogValue()
	{
		$("#RowId").val("");
		$("#modeCode").val("");
		$("#modeDesc").val("");
		$("#modeSpecial").combobox('setValue',"");
	}	
	var InsertHandler=function(){
		initView();
		$("#modeDialog").show();
		var modeDlgObj=$HUI.dialog("#modeDialog",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			title:'����͸����ʽ',
			buttons:[{
				text:"����",
				handler:function(){
					if($("#modeCode").val()==""){
						$.messager.alert("��ʾ","���벻��Ϊ��","error");
						return;
					}
					if($("#modeDesc").val()==""){
						$.messager.alert("��ʾ","���Ʋ���Ϊ��","error");
						return;
					}
					if($("#modeSpecial").combobox("getValue")==""){
						$.messager.alert("��ʾ","�Ƿ����ⲻ��Ϊ��","error");
						return;
					}
					var data=$.m({
								ClassName:"web.DHCBPCBloodPurificationMode",
								MethodName:"Add",
								BPCBPMCode:$("#modeCode").val(),
								BPCBPMDesc:$("#modeDesc").val(),
								BPCBPMIsSpecial:$("#modeSpecial").combobox('getValue'),
							},function(success){
								if(success==0)
								{
									modeDlgObj.close();
									modeObj.load();
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
					modeDlgObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})

	}

	var UpdateHandler=function(id,code,desc,special,specialDesc)
	{
		initView();	
		$("#modeCode").val(code);
		$("#modeDesc").val(desc);	
		$("#modeSpecial").combobox('setValue',special)
		$("#modeSpecial").combobox('setText',specialDesc)		
		$("#modeDialog").show();
		var modeDlgObj=$HUI.dialog("#modeDialog",{
			iconCls:'icon-w-edit',
			resizable:true,
			modal:true,
			title:'�޸�͸����ʽ',
			buttons:[{
				text:"����",
				handler:function(){
					if($("#modeCode").val()==""){
						$.messager.alert("��ʾ","���벻��Ϊ��","error");
						return;
					}
					if($("#modeDesc").val()==""){
						$.messager.alert("��ʾ","���Ʋ���Ϊ��","error");
						return;
					}
					if($("#modeSpecial").combobox("getValue")==""){
						$.messager.alert("��ʾ","�Ƿ����ⲻ��Ϊ��","error");
						return;
					}
					var data=$.m({
							ClassName:"web.DHCBPCBloodPurificationMode",
							MethodName:"Update",
							BPCBPMRowId:id,
							BPCBPMCode:$("#modeCode").val(),
							BPCBPMDesc:$("#modeDesc").val(),
							BPCBPMIsSpecial:$("#modeSpecial").combobox('getValue',special)
						},function(success){
							if(success==0)
							{
								modeDlgObj.close();
								modeObj.load();
							}else{
								$.messager.alert("��ʾ","͸����ʽ����ʧ�ܣ�");
						}
						
					})
				}
			},{
				text:"�ر�",
				handler:function(){
					modeDlgObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})
	}
	
	
	var modeObj=$HUI.datagrid("#modeBox",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCBloodPurificationMode",
			QueryName:"FindDHCBPCBPMode"
		},
        columns:[[
			{ field: "tBPCBPMRowId", title: "���", width: 120 },
			{ field: "tBPCBPMCode",title:"����",width:240},
            { field: "tBPCBPMDesc", title: "����", width: 240 },            
            { field: 'tBPCBPMIsSpecial',title:'tBPCBPMIsSpecial',width:140,hidden:true},
            { field: 'tBPCBPMIsSpecialDesc',title:'�Ƿ�����',width:140}      
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
				var row=modeObj.getSelected();
				if(row)
				{
					UpdateHandler(row.tBPCBPMRowId,row.tBPCBPMCode,row.tBPCBPMDesc,row.tBPCBPMIsSpecial,row.tBPCBPMIsSpecialDesc);
				}
			}
            },{ 
		    iconCls: 'icon-cancel',
		    text:'ɾ��',
		    handler: function(){
				var row=modeObj.getSelected();
				if(row)
				{
					$.messager.confirm("ȷ��","ȷ��ɾ����",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCBPCBloodPurificationMode",
								MethodName:"Delete",
								BPCBPMRowId:row.tBPCBPMRowId
							},function(success)
							{
								if(success==0)
								{
									modeObj.load();
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