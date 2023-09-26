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
			title:'新增安全组可看天数',
			modal:true,
			buttons:[{
				text:"保存",
				handler:function(){
						 if(!reg.test($("#Group").combobox('getValue')))
    					{
	    				$.messager.alert("提示","手术安全组需要从下拉框选择","error");
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
									$.messager.alert("提示","添加失败！","error");
								}
							})
						
					
				}
			},{
				text:"关闭",
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
			title:'修改安全组可看天数',
			modal:true,
			buttons:[{
				text:"保存",
				handler:function(){
					if(!reg.test($("#Group").combobox('getValue')))
    					{
	    				$.messager.alert("提示","手术安全组需要从下拉框选择","error");
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
								$.messager.alert("提示","更新失败！","error");
						}
						
					})
				}
			},{
				text:"关闭",
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
			{ field: "GroupId", title: "安全组Id", width: 120 },
            { field: "Group", title: "安全组", width: 120 },
            { field: "CanSeeDay", title: "天数", width: 240 }
        ]],
		pagination:true,
		pageSize: 20,
		pageList: [20, 50, 100],
		//rows:20,
		fit:true,
		fitColumns:true,
		headerCls:"panel-header-gray",
		singleSelect:true,
		checkOnSelect:true,	///easyui取消单击行选中状态
		selectOncheck:true,
        iconCls:'icon-paper',
        rownumbers: true,
		toolbar:[{
			iconCls: 'icon-add',
		    text:'新增',
		    handler: function(){
				InsertHandler();
			}
	        },{
	        iconCls: 'icon-write-order',
	        text:'修改',
		    handler: function(){
				var row=superCatObj.getSelected();
				if(row)
				{
					UpdateHandler(row.GroupId,row.Group,row.CanSeeDay);
				}
			}
            },{ 
		    iconCls: 'icon-cancel',
		    text:'删除',
		    handler: function(){
				var row=superCatObj.getSelected();
				if(row)
				{
					$.messager.confirm("确认","确定删除？",function(r){
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
									$.messager.alert("提示","删除失败！错误代码："+success,"error");
								}
							})
						}
					})
				}
				else
				{
					$.messager.alert("提示","请选择一行","warning");
					}
			}
		}]
	})
});