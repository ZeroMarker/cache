//20181219+dyl
var reg=/^[0-9]+.?[0-9]*$/; 
$(function(){
		$("#Group").combobox({
		url:$URL+"?ClassName=web.DHCANOPArrange&QueryName=SSGROUP&ResultSetType=array",
        valueField:"ID",
        textField:"Group",
        onBeforeLoad:function(param)
        {
	        param.desc=param.q
	    }
	})
	function setDialogValue()
	{	
		$("#Group").combobox('setValue',"")
		$("#Day").val("");
	}
	var InsertHandler=function(){
		$("#groupSeeDayDlg").show();
		var groupSeeDayDlgObj=$HUI.dialog("#groupSeeDayDlg",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'������ȫ��ɿ�����',
			modal:true,
			buttons:[{
				text:"����",
				handler:function(){
						 if(!reg.test($("#Group").combobox('getValue')))
    					{
	    				$.messager.alert("��ʾ","������ȫ����Ҫ��������ѡ��","error");
        				return;
   						 }
							var data=$.m({
								ClassName:"web.UDHCANOPSET",
								MethodName:"InsertGroupDay",
								groupId:$("#Group").combobox('getValue'),
								day:$("#Day").val()
							},function(success){
								if(success==0)
								{
									groupSeeDayDlgObj.close();
									superCatObj.load();
								}else
								{
									$.messager.alert("��ʾ","���ʧ�ܣ�","error");
								}
							})
						
					
				}
			},{
				text:"�ر�",
				handler:function(){
					groupSeeDayDlgObj.close();
				}
			}],
			onClose:function(){  
                	setDialogValue();
            }
		})
	}
	var UpdateHandler=function(id,code,desc)
	{
		$("#Group").combobox('setValue',id)
		$("#Day").val(desc);

		$("#groupSeeDayDlg").show();
		var groupSeeDayDlgObj=$HUI.dialog("#groupSeeDayDlg",{
			iconCls:'icon-w-edit',
			resizable:true,
			title:'�޸İ�ȫ��ɿ�����',
			modal:true,
			buttons:[{
				text:"����",
				handler:function(){
					if(!reg.test($("#Group").combobox('getValue')))
    					{
	    				$.messager.alert("��ʾ","������ȫ����Ҫ��������ѡ��","error");
        				return;
   						 }
					var data=$.m({
							ClassName:"web.UDHCANOPSET",
							MethodName:"UpdateGroupDay",
							groupId:$("#Group").combobox('getValue'),
								day:$("#Day").val()
						},function(success){
							if(success==0)
							{
								groupSeeDayDlgObj.close();
								superCatObj.load();
							}else{
								$.messager.alert("��ʾ","����ʧ�ܣ�","error");
						}
						
					})
				}
			},{
				text:"�ر�",
				handler:function(){
					groupSeeDayDlgObj.close();
				}
			}],
			onClose:function(){  
                	setDialogValue();
            }
		})
	}
	
	var superCatObj=$HUI.datagrid("#superCat",{
		url:$URL,
		queryParams:{
			ClassName:"web.UDHCANOPSET",
			QueryName:"FindGroupCanSeeDay"	
		},
        columns:[[
			{ field: "GroupId", title: "��ȫ��Id", width: 120 },
            { field: "Group", title: "��ȫ��", width: 120 },
            { field: "CanSeeDay", title: "����", width: 240 }
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
				var row=superCatObj.getSelected();
				if(row)
				{
					UpdateHandler(row.GroupId,row.Group,row.CanSeeDay);
				}
			}
            },{ 
		    iconCls: 'icon-cancel',
		    text:'ɾ��',
		    handler: function(){
				var row=superCatObj.getSelected();
				if(row)
				{
					$.messager.confirm("ȷ��","ȷ��ɾ����",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.UDHCANOPSET",
								MethodName:"DeleteGroupDay",
								groupId:row.GroupId
							},function(success)
							{
								if(success==0)
								{
									superCatObj.load();
								}else{
									$.messager.alert("��ʾ","ɾ��ʧ�ܣ�������룺"+success,"error");
								}
							})
						}
					})
				}
				else
				{
					$.messager.alert("��ʾ","��ѡ��һ��","warning");
					}
			}
		}]
	})
});