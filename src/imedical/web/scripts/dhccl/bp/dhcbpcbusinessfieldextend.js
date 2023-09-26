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
	//20181219+dyl
	//����
	$HUI.combobox("#type",{
        valueField:"code",
        textField:"desc",
        panelHeight:'auto',
        data:[{'code':"A",'desc':"���� A"},{'code':"S",'desc':"���� S"}],
        onHidePanel: function () {
        	OnHidePanel("#type");
        },
    })
    //����
	$HUI.combobox("#active",{
        valueField:"code",
        textField:"desc",
        panelHeight:'auto',
        data:[{'code':"Y",'desc':"��"},{'code':"N",'desc':"��"}],
        onHidePanel: function () {
        	OnHidePanel("#active");
        },
    })
    function setDialogValue()
	{
		$("#code").val("");
		$("#desc").val("");		
		$("#type").combobox('setValue',"");		
		$("#active").combobox('setValue',"");
		$("#extOption").val("");
	}
	var InsertHandler=function(){
		$("#BusinessFieldExtendDlg").show();
		var BusinessFieldExtendDlgObj=$HUI.dialog("#BusinessFieldExtendDlg",{
			iconCls:'icon-w-add',
			title:'����Ѫ͸������',
			resizable:true,
			modal:true,
			buttons:[{
				text:"����",
				handler:function(){
					if($("#code").val()==""){
								$.messager.alert("��ʾ","���벻��Ϊ��","error");
								return;
					}
					if($("#desc").val()==""){
								$.messager.alert("��ʾ","���Ʋ���Ϊ��","error");
								return;
					}
					if(($("#type").combobox('getValue')=="")||($("#type").combobox('getValue')=="undefined")){
						$.messager.alert("��ʾ","���Ͳ���Ϊ��","error");
						return;
					}
					var ParaList=$("#code").val()+"^"+$("#desc").val()+"^"+$('#type').combobox('getValue')+"^"+$('#active').combobox('getValue')+"^"+$("#extOption").val()+"^"+"";
					var data=$.m({
						ClassName:"web.DHCBPCBusinessFieldExtend",
						MethodName:"SaveExtendItem",
						Para:ParaList,
						RowId:''
					},function(success){
						if(success>=0)
						{
							BusinessFieldExtendDlgObj.close();
							BusinessFieldExtendObj.load();
						}else
						{
							$.messager.alert("��ʾ","͸����ά�����ʧ�ܣ�", "error");
						}
					})
				}
			},{
				text:"�ر�",
				handler:function(){
					BusinessFieldExtendDlgObj.close();
				}
			}],
			onClose:function(){  
                setDialogValue();
            } 
		})
	}
	
	var UpdateHandler=function(id,code,desc,type,active,options)
	{
		$("#RowId").val(id);
		$("#code").val(code);
		$("#desc").val(desc);
		$('#type').combobox('select',type);
		$('#active').combobox('select',active);
		$("#extOption").val(options);
		$("#BusinessFieldExtendDlg").show();
		// var ParaList=$("#code").val()+"^"+$("#desc").val()+"^"+$('#type').combobox('getValue')+"^"+$('#active').combobox('getValue')+"^"+$("#extOption").val()+"^"+"";
		var BusinessFieldExtendDlgObj=$HUI.dialog("#BusinessFieldExtendDlg",{
			iconCls:'icon-w-edit',
			resizable:true,
			title:'�޸�Ѫ͸������',
			modal:true,
			buttons:[{
				text:"����",
				handler:function(){
					if($("#code").val()==""){
								$.messager.alert("��ʾ","���벻��Ϊ��","error");
								return;
					}
					if($("#desc").val()==""){
								$.messager.alert("��ʾ","���Ʋ���Ϊ��","error");
								return;
					}
					if(($("#type").combobox('getValue')=="")||($("#type").combobox('getValue')=="undefined")){
						$.messager.alert("��ʾ","���Ͳ���Ϊ��","error");
						return;
					}
					var data=$.m({
							ClassName:"web.DHCBPCBusinessFieldExtend",
								MethodName:"SaveExtendItem",
								Para:$("#code").val()+"^"+$("#desc").val()+"^"+$('#type').combobox('getValue')+"^"+$('#active').combobox('getValue')+"^"+$("#extOption").val()+"^"+"",
								RowId:id
						},function(success){
							if(success>=0)
							{
								BusinessFieldExtendDlgObj.close();
								BusinessFieldExtendObj.load();
							}else{
								$.messager.alert("��ʾ","͸����ά������ʧ�ܣ�", "error");
						}
						
					})
				}
			},{
				text:"�ر�",
				handler:function(){
					BusinessFieldExtendDlgObj.close();
				}
			}],
			onClose:function(){  
                setDialogValue();
            } 
		})
	}
	
	var BusinessFieldExtendObj=$HUI.datagrid("#BusinessFieldExtend",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCBusinessFieldExtend",
			QueryName:"FindBusinessFieldExtend",
			Code:'',
			Type:''
		},
        columns:[[
			{ field: "tRowId", title: "���", width: 60 },
            { field: "BPBusFieldExtCode", title: "����", width: 160 },
            { field: "BPBusFieldExtDesc", title: "����", width: 180 },
            { field: "BPBusFieldExtType", title: "����", width: 60 },
            { field: "BPBusFieldExtTypeDesc", title: "��������", width: 70 },
			{ field: "BPBusFieldExtActive", title: "����", width: 60 },
            { field: "BPBusFieldExtActiveDesc", title: "��������", width: 70 },
			{ field: "BPBusFieldExtOption", title: "ֵ", width: 120 },
			{ field: "BPBusFieldExtSortNo", title: "�����", width: 120 , hidden:true}
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
				var row=BusinessFieldExtendObj.getSelected();
				// alert(row.tRowId);
				if(row)
				{
					UpdateHandler(row.tRowId,row.BPBusFieldExtCode,row.BPBusFieldExtDesc,row.BPBusFieldExtType,row.BPBusFieldExtActive,row.BPBusFieldExtOption);
				}
			}
        },{ 
			///ɾ�����������
		    iconCls: 'icon-cancel',
		    text:'ɾ��',
		    handler: function(){
				var row=BusinessFieldExtendObj.getSelected();
				if(row)
				{
					$.messager.confirm("ȷ��","ȷ��ɾ����",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCBPCBusinessFieldExtend",
								MethodName:"DeleteExtendItem",
								RowId:row.tRowId
							},function(success)
							{
								if(success==0)
								{
									BusinessFieldExtendObj.load();
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