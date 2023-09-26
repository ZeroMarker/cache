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
	$HUI.combobox("#Ward0",{
		url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array",
		textField:"ctlocDesc",
		valueField:"ctlocId",
		formatter:function(row){				
			var opts = $(this).combobox('options');
			return row[opts.textField];
		},
		onBeforeLoad:function(param)
        {
            	param.desc=param.q;
        }
        ,mode:'remote',
        onHidePanel: function () {
        	OnHidePanel("#Ward0");
        },				
	})
	$HUI.combobox("#BPCBGIsolated",{
		url:$URL+"?ClassName=web.DHCBPCBedGroup&QueryName=FindBPCBGIsolated&ResultSetType=array",
		textField:"Desc",
		valueField:"Id",
		panelHeight:"auto",
		formatter:function(row){				
			var opts = $(this).combobox('options');
			return row[opts.textField];
		},
		onHidePanel: function () {
        	OnHidePanel("#BPCBGIsolated");
        },			
	})	
	function setDialogValue()
	{
		$('#Ward0').combobox('setValue',"")
		$('#BPCBGIsolated').combobox('setValue',"");
		$("#BedGroupCode").val("");
		$("#BedGroupDesc").val("");

	}
	var InsertHandler=function(){
		$("#BPCBedGroupDlg").show();
		var BPCBedGroupDlgObj=$HUI.dialog("#BPCBedGroupDlg",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			title:'������λ��',
			buttons:[{
				text:"����",
				handler:function(){
					if($("#BedGroupCode").val()==""){
						$.messager.alert("��ʾ","���벻��Ϊ��","error");
						return;
					}
					if($("#BedGroupDesc").val()==""){
						$.messager.alert("��ʾ","���Ʋ���Ϊ��","error");
						return;
					}
					if($HUI.combobox("#BPCBGIsolated").getValue()==""){
						$.messager.alert("��ʾ","���벻��Ϊ��","error");
						return;
					}
					var data=$.m({
						ClassName:"web.DHCBPCBedGroup",
						MethodName:"InsertBPCBedGroup",
						Code:$("#BedGroupCode").val(),
						Desc:$("#BedGroupDesc").val(),
						BPCBGWardDr:$('#Ward0').combobox('getValue'),
						BPCBGIsolated:$('#BPCBGIsolated').combobox('getValue')
						},function(success){
							if(success==0)
							{
								BPCBedGroupDlgObj.close();
								BPCBedGroupObj.load();
							}else
							{
								$.messager.alert("��ʾ","���ʧ�ܣ�");
							}
					})
				}				
			},{
				text:"�ر�",
				handler:function(){
					BPCBedGroupDlgObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})
	}
	
	var UpdateHandler=function(tRowId,tBPCBGCode,tBPCBGDesc,tBPCBGWardDr,tBPCBGIsolatedDr)
	{
		$("#RowId").val(tRowId);
		$("#BedGroupCode").val(tBPCBGCode);
		$("#BedGroupDesc").val(tBPCBGDesc);
		//alert(tBPCBGWardDr);
		$('#Ward0').combobox('setValue',tBPCBGWardDr);
		
		$('#BPCBGIsolated').combobox('setValue',tBPCBGIsolatedDr);
		$("#BPCBedGroupDlg").show();
		var BPCBedGroupDlgObj=$HUI.dialog("#BPCBedGroupDlg",{
			iconCls:'icon-w-edit',
			resizable:true,
			modal:true,
			title:'�޸Ĵ�λ��',
			buttons:[{
				text:"����",
				handler:function(){
					var data=$.m({
						ClassName:"web.DHCBPCBedGroup",
						MethodName:"UpdateBPCBedGroup",
						BPCBGRowid:tRowId,
						Code:$("#BedGroupCode").val(),
						Desc:$("#BedGroupDesc").val(),
						BPCBGWardDr:$('#Ward0').combobox('getValue'),
						BPCBGIsolated:$('#BPCBGIsolated').combobox('getValue')
					},function(success){
						if(success==0)
						{
							BPCBedGroupDlgObj.close();
							BPCBedGroupObj.load();
						}else{
							$.messager.alert("��ʾ","����ʧ�ܣ�");
						}
						
					})
				}
			},{
				text:"�ر�",
				handler:function(){
					BPCBedGroupDlgObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})
	}
	
	var BPCBedGroupObj=$HUI.datagrid("#BPCBedGroup",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCBedGroup",
			QueryName:"FindBPCBedGroup",
			locId:''
		},
        columns:[[
			{ field: "tRowId", title: "���", width: 80 },
            { field: "tBPCBGCode", title: "����", width: 150 },
            { field: "tBPCBGDesc", title: "����", width: 180 },
            { field: "tBPCBGWardDr", title: "����ID", width: 80 ,hidden:true},
            { field: "tBPCBGWard", title: "����", width: 300 },
            { field: "tBPCBGIsolatedDr", title: "���루1/0��", hidden:true},
            { field: "tBPCBGIsolated", title: "���루��/��", width: 100 }
        ]],
		pagination:true,
		pageSize: 20,
		pageList: [20, 50, 100],
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
				var row=BPCBedGroupObj.getSelected();
				if(row)
				{
					UpdateHandler(row.tRowId,row.tBPCBGCode,row.tBPCBGDesc,row.tBPCBGWardDr,row.tBPCBGIsolatedDr);
				}
			}
        },{
			///ɾ������
		    iconCls: 'icon-cancel',
		    text:'ɾ��',
		    handler: function(){
				var row=BPCBedGroupObj.getSelected();
				if(row)
				{
					$.messager.confirm("ȷ��","ȷ��ɾ����",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCBPCBedGroup",
								MethodName:"DeleteBPCBedGroup",
								BPCBGRowid:row.tRowId
							},function(success)
							{
								if(success==0)
								{
									BPCBedGroupObj.load();
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
});