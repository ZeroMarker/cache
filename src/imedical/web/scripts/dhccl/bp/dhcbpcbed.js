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
	$HUI.combobox("#BedGroup",{
		url:$URL+"?ClassName=web.DHCBPCBed&QueryName=FindBedGroup&ResultSetType=array",
		textField:"BedDesc",
		valueField:"BedRowId",
		formatter:function(row){				
			var opts = $(this).combobox('options');
			return row[opts.textField];
			//return row[opts.valueField]+"||"+row[opts.textField];
		},
		onBeforeLoad:function(param)
        {
            	param.hospId=session['LOGON.HOSPID'];
        },
		onHidePanel: function () {
        	OnHidePanel("#BedGroup");
        }, 			
	})
	$HUI.combobox("#BPCBStatus",{
		url:$URL+"?ClassName=web.DHCBPCBed&QueryName=FindBPCBStatus&ResultSetType=array",
		textField:"Desc",
		valueField:"Id",
		panelHeight:"auto",
		formatter:function(row){				
			var opts = $(this).combobox('options');
			return row[opts.textField];
		},
		onHidePanel: function () {
        	OnHidePanel("#BPCBStatus");
        }, 			
	})
	$HUI.combobox("#BPCBIsFiltration",{
		url:$URL+"?ClassName=web.DHCBPCBed&QueryName=FindBPCBIsFiltration&ResultSetType=array",
		textField:"Desc",
		valueField:"Id",
		panelHeight:"auto",
		formatter:function(row){				
			var opts = $(this).combobox('options');
			return row[opts.textField];
		},
		onHidePanel: function () {
        	OnHidePanel("#BPCBIsFiltration");
        }, 			
	})
	function setDialogValue()
	{	
		$("#BedCode").val("");
		$("#BedDesc").val("");
		$("#BedGroup").combobox('setValue',"")		
		$("#BPCBStatus").combobox('setValue',"")
		$("#BPCBType").val("");
		$("#BPCBIsFiltration").combobox('setValue',"")
	}		
	var InsertHandler=function(){
		$("#BPCBedUIDlg").show();
		var BPCBedUIDlgObj=$HUI.dialog("#BPCBedUIDlg",{
			iconCls:'icon-w-add',
			resizable:false,
			modal:true,
			title:'新增床位信息',
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#BedCode").val()==""){
						$.messager.alert("提示","代码不能为空","error");
						return;
					}
					if($("#BedDesc").val()==""){
						$.messager.alert("提示","名称不能为空","error");
						return;
					}
					if($HUI.combobox("#BedGroup").getValue()==""){
						$.messager.alert("提示","床位组不能为空","error");
						return;
					}
					if($HUI.combobox("#BPCBStatus").getValue()==""){
						$.messager.alert("提示","状态不能为空","error");
						return;
					}

					var data=$.m({
								ClassName:"web.DHCBPCBed",
								MethodName:"InsertBPCBed",
								Code:$("#BedCode").val(),
								Desc:$("#BedDesc").val(),
								BPCBedGroup:$('#BedGroup').combobox('getValue'),
								Status:$('#BPCBStatus').combobox('getValue'),
								Type:$("#BPCBType").val(),
								IsFiltration:$('#BPCBIsFiltration').combobox('getValue'),
								hospId:session['LOGON.HOSPID']
							},function(success){
								if(success==0)
								{
									BPCBedUIDlgObj.close();
									BPCBedUIObj.load();
								}else
								{
									$.messager.alert("提示","新增失败！");
								}
							})
	
					}
				},{
					text:"关闭",
					handler:function(){
						BPCBedUIDlgObj.close();
					}
				}],
			onClose:function(){  
                	setDialogValue();
            } 
				
		})
	}
	
	var UpdateHandler=function(tRowId,tBPCBCode,tBPCBDesc,tBPCBBPCBedGroupDr,tBPCBStatus,tBPCBType,tBPCBIsFiltrationDr)
	{
		///alert(tRowId+"-"+tBPCBCode+"-"+tBPCBDesc+"-"+tBPCBBPCBedGroupDr+"-"+tBPCBStatus+"-"+tBPCBType);
		$("#RowId").val(tRowId);
		$("#BedCode").val(tBPCBCode);
		$("#BedDesc").val(tBPCBDesc);
		//alert(tBPCBBPCBedGroupDr);
		$('#BedGroup').combobox('setValue',tBPCBBPCBedGroupDr);
		$('#BPCBStatus').combobox('setValue',tBPCBStatus);		
		$("#BPCBType").val(tBPCBType);
		$('#BPCBIsFiltration').combobox('setValue',tBPCBIsFiltrationDr);
		$("#BPCBedUIDlg").show();
		var BPCBedUIDlgObj=$HUI.dialog("#BPCBedUIDlg",{
			iconCls:'icon-w-edit',
			resizable:false,
			modal:true,
			title:'修改床位信息',
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#BedCode").val()==""){
						$.messager.alert("提示","代码不能为空","error");
						return;
					}
					if($("#BedDesc").val()==""){
						$.messager.alert("提示","名称不能为空","error");
						return;
					}
					if($HUI.combobox("#BedGroup").getValue()==""){
						$.messager.alert("提示","床位组不能为空","error");
						return;
					}
					if($HUI.combobox("#BPCBStatus").getValue()==""){
						$.messager.alert("提示","状态不能为空","error");
						return;
					}
					var data=$.m({
						ClassName:"web.DHCBPCBed",
						MethodName:"UpdateBPCBed",
						BPCBRowid:tRowId,
						Code:$("#BedCode").val(),
						Desc:$("#BedDesc").val(),
						BPCBedGroup:$('#BedGroup').combobox('getValue'),
						Status:$('#BPCBStatus').combobox('getValue'),
						Type:$("#BPCBType").val(),
						IsFiltration:$('#BPCBIsFiltration').combobox('getValue'),
						hospId:session['LOGON.HOSPID']
					},function(success){
						if(success==0)
						{
							BPCBedUIDlgObj.close();
							BPCBedUIObj.load();
						}else{
							$.messager.alert("提示","更新失败！");
						}
						
					})
				}
			},{
				text:"关闭",
				handler:function(){
					BPCBedUIDlgObj.close();
				}
			}],
			onClose:function(){  
                	setDialogValue();
            } 
		})
	}
	
	var BPCBedUIObj=$HUI.datagrid("#BPCBedUI",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCBed",
			QueryName:"FindBPCBed",
			bb:'',
			hospId:session['LOGON.HOSPID']
		},
        columns:[[
			{ field: "tRowId", title: "编号", width: 60 },
            { field: "tBPCBCode", title: "代码", width: 100 },
            { field: "tBPCBDesc", title: "名称", width: 150 },
            { field: "tBPCBBPCBedGroupDr", title: "床位组ID", width: 80 , hidden:true},
            { field: "tBPCBBPCBedGroup", title: "床位组", width: 80 },
            { field: "tBPCBStatus", title: "状态Code", width: 100 , hidden:true},
            { field: "tBPCBStatusD", title: "状态", width: 80 },
            { field: "tBPCBType", title: "类型", width: 80 },
            { field: "tBPCBIsFiltrationDr", title: "tBPCBIsFiltrationDr", width: 100 , hidden:true},
            { field: "tBPCBIsFiltration", title: "支持血滤", width: 80 },
        ]],
		//pagination:true,
		//page:1,    //可选项，页码，默认1
		//rows:20,
		//fit:true,
		//headerCls:"panel-header-gray",
		//singleSelect:true,
		//checkOnSelect:true,	///easyui取消单击行选中状态
		//selectOncheck:true,
		
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
				var row=BPCBedUIObj.getSelected();
				if(row)
				{
					UpdateHandler(row.tRowId,row.tBPCBCode,row.tBPCBDesc,row.tBPCBBPCBedGroupDr,row.tBPCBStatus,row.tBPCBType,row.tBPCBIsFiltrationDr);
				}
			}
        },{
			///删除功能
		    iconCls: 'icon-cancel',
		    text:'删除',
		    handler: function(){
				var row=BPCBedUIObj.getSelected();
				if(row)
				{
					$.messager.confirm("确认","确定删除？",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCBPCBed",
								MethodName:"DeleteBPCBed",
								BPCBRowid:row.tRowId
							},function(success)
							{
								if(success==0)
								{
									BPCBedUIObj.load();
								}else{
									$.messager.alert("提示","删除失败！错误代码："+success);
								}
							})
						}
					})
				}
			}
		},
		/* { 
			///查询
		    iconCls: 'icon-search',
		    text:'查询',
		    handler: function(){
				doSearch();
			}
		} */]
	})
	function doSearch(){
		$('#BPCBedUI').datagrid('load',{
			diagCatId:$('#comDiagnosisCat').combogrid('getValue')
		})
	}
});