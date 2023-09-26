function OnHidePanel(item)
{
	var valueField = $(item).combobox("options").valueField;
	var val = $(item).combobox("getValue");  //当前combobox的值
	var txt = $(item).combobox("getText");
	var allData = $(item).combobox("getData");   //获取combobox所有数据
	var result = true;      //为true说明输入的值在下拉框数据中不存在
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
	    	$.messager.alert("提示","请从下拉框选择","error");
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
			title:'新增床位组',
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#BedGroupCode").val()==""){
						$.messager.alert("提示","代码不能为空","error");
						return;
					}
					if($("#BedGroupDesc").val()==""){
						$.messager.alert("提示","名称不能为空","error");
						return;
					}
					if($HUI.combobox("#BPCBGIsolated").getValue()==""){
						$.messager.alert("提示","隔离不能为空","error");
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
								$.messager.alert("提示","添加失败！");
							}
					})
				}				
			},{
				text:"关闭",
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
			title:'修改床位组',
			buttons:[{
				text:"保存",
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
							$.messager.alert("提示","更新失败！");
						}
						
					})
				}
			},{
				text:"关闭",
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
			{ field: "tRowId", title: "编号", width: 80 },
            { field: "tBPCBGCode", title: "代码", width: 150 },
            { field: "tBPCBGDesc", title: "名称", width: 180 },
            { field: "tBPCBGWardDr", title: "病区ID", width: 80 ,hidden:true},
            { field: "tBPCBGWard", title: "病区", width: 300 },
            { field: "tBPCBGIsolatedDr", title: "隔离（1/0）", hidden:true},
            { field: "tBPCBGIsolated", title: "隔离（是/否）", width: 100 }
        ]],
		pagination:true,
		pageSize: 20,
		pageList: [20, 50, 100],
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
				var row=BPCBedGroupObj.getSelected();
				if(row)
				{
					UpdateHandler(row.tRowId,row.tBPCBGCode,row.tBPCBGDesc,row.tBPCBGWardDr,row.tBPCBGIsolatedDr);
				}
			}
        },{
			///删除功能
		    iconCls: 'icon-cancel',
		    text:'删除',
		    handler: function(){
				var row=BPCBedGroupObj.getSelected();
				if(row)
				{
					$.messager.confirm("确认","确定删除？",function(r){
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
									$.messager.alert("提示","删除失败！错误代码："+success);
								}
							})
						}
					})
				}
			}
		}]
	})
});