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
	//20181219+dyl
	//类型
	$HUI.combobox("#type",{
        valueField:"code",
        textField:"desc",
        panelHeight:'auto',
        data:[{'code':"A",'desc':"安排 A"},{'code':"S",'desc':"方案 S"}],
        onHidePanel: function () {
        	OnHidePanel("#type");
        },
    })
    //激活
	$HUI.combobox("#active",{
        valueField:"code",
        textField:"desc",
        panelHeight:'auto',
        data:[{'code':"Y",'desc':"是"},{'code':"N",'desc':"否"}],
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
			title:'新增血透配置项',
			resizable:true,
			modal:true,
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#code").val()==""){
								$.messager.alert("提示","代码不能为空","error");
								return;
					}
					if($("#desc").val()==""){
								$.messager.alert("提示","名称不能为空","error");
								return;
					}
					if(($("#type").combobox('getValue')=="")||($("#type").combobox('getValue')=="undefined")){
						$.messager.alert("提示","类型不能为空","error");
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
							$.messager.alert("提示","透析项维护添加失败！", "error");
						}
					})
				}
			},{
				text:"关闭",
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
			title:'修改血透配置项',
			modal:true,
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#code").val()==""){
								$.messager.alert("提示","代码不能为空","error");
								return;
					}
					if($("#desc").val()==""){
								$.messager.alert("提示","名称不能为空","error");
								return;
					}
					if(($("#type").combobox('getValue')=="")||($("#type").combobox('getValue')=="undefined")){
						$.messager.alert("提示","类型不能为空","error");
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
								$.messager.alert("提示","透析项维护更新失败！", "error");
						}
						
					})
				}
			},{
				text:"关闭",
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
			{ field: "tRowId", title: "编号", width: 60 },
            { field: "BPBusFieldExtCode", title: "代码", width: 160 },
            { field: "BPBusFieldExtDesc", title: "名称", width: 180 },
            { field: "BPBusFieldExtType", title: "类型", width: 60 },
            { field: "BPBusFieldExtTypeDesc", title: "类型名称", width: 70 },
			{ field: "BPBusFieldExtActive", title: "激活", width: 60 },
            { field: "BPBusFieldExtActiveDesc", title: "激活名称", width: 70 },
			{ field: "BPBusFieldExtOption", title: "值", width: 120 },
			{ field: "BPBusFieldExtSortNo", title: "排序号", width: 120 , hidden:true}
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
				var row=BusinessFieldExtendObj.getSelected();
				// alert(row.tRowId);
				if(row)
				{
					UpdateHandler(row.tRowId,row.BPBusFieldExtCode,row.BPBusFieldExtDesc,row.BPBusFieldExtType,row.BPBusFieldExtActive,row.BPBusFieldExtOption);
				}
			}
        },{ 
			///删除功能已完成
		    iconCls: 'icon-cancel',
		    text:'删除',
		    handler: function(){
				var row=BusinessFieldExtendObj.getSelected();
				if(row)
				{
					$.messager.confirm("确认","确定删除？",function(r){
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
									$.messager.alert("提示","删除失败！错误代码："+success, "error");
								}
							})
						}
					})
				}
			}
		}]
	})
});