///combogrid不是选择，多选下拉框提示
function OnHidePanel3(item)
{
	var idField = $(item).combogrid("options").idField;
	var vals = $(item).combogrid("getValues");  //当前combobox的值
	var txt = $(item).combogrid("getText");
	var allData = $(item).combogrid("grid").datagrid('getSelections');   //获取combobox所有数据
	var result = true;      //为true说明输入的值在下拉框数据中不存在
	for (var i = 0; i < allData.length; i++) {
		for (var j = 0; j < vals.length; j++) 
		{
			if (vals[j] == allData[i][idField]) {
	    		result = false;
	    		break;
	    	}
		}
	}
	if (result) {
	    if ((vals.length==0)&&(txt!=""))
	    {
		    $(item).combobox("clear");	    
	    	$(item).combobox("reload");
		    $(item).combobox('setValue',"");
	    	$.messager.alert("提示","请从下拉框选择","error");
	    	return;
	    }
	}
}
$(function(){
   	var initView=function(){
		var ctLocObj=$HUI.combobox("#bpcCtlocDr",{
			url:$URL+"?ClassName=web.DHCBPCInquiry&QueryName=ctloclookup&ResultSetType=array",
			textField:"oprCtLoc",
			valueField:"oprLocId",
			formatter:function(row){				
				var opts = $(this).combobox('options');
				return row[opts.textField];
			},
			onBeforeLoad:function(param)
        	{
            	param.hospId=session['LOGON.HOSPID'];
        	}
			})			
		var conObj=$HUI.combobox("#bpcCMode",{
			url:$URL+"?ClassName=web.DHCBPCConsumable&QueryName=FindConsumable&ResultSetType=array",
			textField:"tBPCCDesc",
			valueField:"tID",
			formatter:function(row){				
				var opts = $(this).combobox('options');
				return row[opts.textField];
				}
			})			
		}
		$HUI.combogrid("#BPCBPMode",{
			idField:"tBPCBPMRowId",
			textField:"tBPCBPMDesc",
			mode:"remote",
			multiple:true,
			url:$URL,  //"dhcclinic.jquery.csp",
			queryParams:{
				ClassName:"web.DHCBPCBloodPurificationMode",
				QueryName:"FindDHCBPCBPMode",
				ctlocId:""			
				},
			columns:[[
			{filed:"ck",checkbox:true,width:0},
			{field:"tBPCBPMDesc",title:"透析方式"}
			]],
			onHidePanel: function () {
        		OnHidePanel3("#BPCBPMode");
        	},			
		});
	function setDialogValue()
	{
		$("#bpcCMode").combobox('setValue',"");
		$("#BPCBPMode").combobox('setValue',"");
		$("#bpcCtlocDr").combobox('setValue',"");
	}	
	var InsertHandler=function(){
		initView();
		$("#consumablelocDialog").show();
		var consumablelocDialog=$HUI.dialog("#consumablelocDialog",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			title:'新增耗材维护配置',
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#bpcCMode").combobox('getValue')==""){
						$.messager.alert("提示","耗材不能为空","error");
						return;
					}
					if($("#BPCBPMode").combobox('getValue')==""){
						$.messager.alert("提示","透析方式不能为空","error");
						return;
					}
					var MDrow=$("#BPCBPMode").combogrid('grid').datagrid('getSelections')					
					if (MDrow.length>0)
					{	
						var r=MDrow[0].tBPCBPMRowId;				
						for(var i=1;i<MDrow.length;i++)
						{
							r=r+","+MDrow[i].tBPCBPMRowId
						}
					}	
					var data=$.m({
								ClassName:"web.DHCBPCConsumable",
								MethodName:"InsertConsumableLoc",
								bpcCId:$("#bpcCMode").combobox('getValue'),
								bpcMDrList:r,
								bpLocIdList:$("#bpcCtlocDr").combobox('getValue'),
								hospId:session['LOGON.HOSPID']
							},function(success){
								if(success==0)
								{
									consumablelocDialog.close();
									consumablelocObj.load();
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
					consumablelocDialog.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})
	}
	var UpdateHandler=function(tCID,tBPCCDesc,tBPCBPMRowId,tBPCBPMDesc,tBPCBPMDeptDr,tBPCBPMDept)
	{
		initView();
		var Mode=[]
		Mode=tBPCBPMRowId.split(",")
		$("#bpcCMode").combobox('setValue',tCID)
		$("#bpcCMode").combobox('setText',tBPCCDesc)
		$("#BPCBPMode").combogrid('setValues',Mode)
		$("#bpcCtlocDr").combobox('setValue',tBPCBPMDeptDr)
		$("#bpcCtlocDr").combobox('setText',tBPCBPMDept)
		$("#consumablelocDialog").show();
		var consumablelocDialog=$HUI.dialog("#consumablelocDialog",{
			iconCls:'icon-w-edit',
			resizable:true,
			modal:true,
			title:'修改耗材维护配置',
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#bpcCMode").combobox('getValue')==""){
						$.messager.alert("提示","耗材不能为空","error");
						return;
					}
					if($("#BPCBPMode").combobox('getValue')==""){
						$.messager.alert("提示","透析方式不能为空","error");
						return;
					}
					var MDrow=$("#BPCBPMode").combogrid('grid').datagrid('getSelections')
					if (MDrow.length>0)
					{
						var MDr=MDrow[0].tBPCBPMRowId;
						for(var i=1;i<MDrow.length;i++)
						{
							MDr=MDr+","+MDrow[i].tBPCBPMRowId
						}
					}
					var data=$.m({
							ClassName:"web.DHCBPCConsumable",
							MethodName:"UpdateConsumableLoc",
							bpcCId:$("#bpcCMode").combobox('getValue'),
							bpcMDrList:MDr,
							bpLocIdList:$("#bpcCtlocDr").combobox('getValue'),
							hospId:session['LOGON.HOSPID']
						},function(success){
							if(success==0)
							{
								consumablelocDialog.close();
								consumablelocObj.load();
							}else{
								$.messager.alert("提示","耗材码表更新失败，错误代码："+success);
						}
						
					})
				}
			},{
				text:"关闭",
				handler:function(){
					consumablelocDialog.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})
	}
	
	
	var consumablelocObj=$HUI.datagrid("#consumablelocBox",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCConsumable",
			QueryName:"FindConsumableLoc",
			hospId:session['LOGON.HOSPID']
		},
        columns:[[
            { field: "tBPCCDesc", title: "耗材", width: 150 },            
            { field: 'tCID',title:'耗材维护ID',width:140,hidden:true},
            { field: "tBPCBPMDesc",title:"透析方式",width:400},
            { field: 'tBPCBPMRowId',title:'透析方式ID',width:140,hidden:true}, 
            { field: "tBPCBPMDept",title:"科室",width:250},
            { field: 'tBPCBPMDeptDr',title:'科室ID',width:140,hidden:true}  
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
				var row=consumablelocObj.getSelected();
				if(row)
				{
					UpdateHandler(row.tCID,row.tBPCCDesc,row.tBPCBPMRowId,row.tBPCBPMDesc,row.tBPCBPMDeptDr,row.tBPCBPMDept);
				}
			}
            },{ 
		    iconCls: 'icon-cancel',
		    text:'删除',
		    handler: function(){
				var row=consumablelocObj.getSelected();
				if(row)
				{
					$.messager.confirm("确认","确认删除？",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCBPCConsumable",
								MethodName:"DeleteConsumableLoc",
								bpcCId:row.tCID
							},function(success)
							{
								if(success==0)
								{
									consumablelocObj.load();
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
