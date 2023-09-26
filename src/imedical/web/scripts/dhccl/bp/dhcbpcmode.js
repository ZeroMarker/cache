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
   	var initView=function(){
	    var modeSpecialBox = $HUI.combobox("#modeSpecial",{
		    valueField:"modeSpecial",
		    textField:'modeSpecialDesc',
		    panelHeight:"auto",
			data:[
			{modeSpecial:"Y",modeSpecialDesc:"是"},
			{modeSpecial:"N",modeSpecialDesc:"否"}
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
			title:'新增透析方式',
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#modeCode").val()==""){
						$.messager.alert("提示","代码不能为空","error");
						return;
					}
					if($("#modeDesc").val()==""){
						$.messager.alert("提示","名称不能为空","error");
						return;
					}
					if($("#modeSpecial").combobox("getValue")==""){
						$.messager.alert("提示","是否特殊不能为空","error");
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
									$.messager.alert("提示",success);
								}
							})
				}
			},
			{
				text:"关闭",
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
			title:'修改透析方式',
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#modeCode").val()==""){
						$.messager.alert("提示","代码不能为空","error");
						return;
					}
					if($("#modeDesc").val()==""){
						$.messager.alert("提示","名称不能为空","error");
						return;
					}
					if($("#modeSpecial").combobox("getValue")==""){
						$.messager.alert("提示","是否特殊不能为空","error");
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
								$.messager.alert("提示","透析方式更新失败！");
						}
						
					})
				}
			},{
				text:"关闭",
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
			{ field: "tBPCBPMRowId", title: "编号", width: 120 },
			{ field: "tBPCBPMCode",title:"代码",width:240},
            { field: "tBPCBPMDesc", title: "名称", width: 240 },            
            { field: 'tBPCBPMIsSpecial',title:'tBPCBPMIsSpecial',width:140,hidden:true},
            { field: 'tBPCBPMIsSpecialDesc',title:'是否特殊',width:140}      
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
				var row=modeObj.getSelected();
				if(row)
				{
					UpdateHandler(row.tBPCBPMRowId,row.tBPCBPMCode,row.tBPCBPMDesc,row.tBPCBPMIsSpecial,row.tBPCBPMIsSpecialDesc);
				}
			}
            },{ 
		    iconCls: 'icon-cancel',
		    text:'删除',
		    handler: function(){
				var row=modeObj.getSelected();
				if(row)
				{
					$.messager.confirm("确认","确认删除？",function(r){
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
									$.messager.alert("提示","删除失败，错误代码："+success);
								}
							})
						}
					})
				}
			}
		}]
	})

	
})