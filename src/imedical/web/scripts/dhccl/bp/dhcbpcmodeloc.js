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
		var ctLocObj=$HUI.combobox("#ctLoc",{
			url:$URL+"?ClassName=web.DHCBPCInquiry&QueryName=ctloclookup&ResultSetType=array",
			textField:"oprCtLoc",
			valueField:"oprLocId",
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
			},
			onHidePanel: function () {
        		OnHidePanel("#ctLoc");
        	},
			onBeforeLoad:function(param)
        	{
            	param.hospId=session['LOGON.HOSPID'];
        	}
			})			
		var modeObj=$HUI.combobox("#mode",{
			url:$URL+"?ClassName=web.DHCBPCBloodPurificationMode&QueryName=FindDHCBPCBPMode&ResultSetType=array",
			textField:"tBPCBPMDesc",
			valueField:"tBPCBPMRowId",
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
				},
			onHidePanel: function () {
        		OnHidePanel("#mode");
        	},
			})			
		}
	function setDialogValue()
	{
		$("#RowId").val("");
		$("#mode").combobox('setValue',"");
		$("#ctLoc").combobox('setValue',"");
	}	
	var InsertHandler=function(){
		initView();
		$("#modeLocDialog").show();
		var modeLocDlgObj=$HUI.dialog("#modeLocDialog",{
			iconCls:'icon-w-add',
			resizable:false,
			modal:true,
			title:'新增净化方式配置',
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#mode").combobox('getValue')==""){
						$.messager.alert("提示","透析方式不能为空","error");
						return;
					}
					if($("#ctLoc").combobox('getValue')==""){
						$.messager.alert("提示","科室不能为空","error");
						return;
					}	
					var data=$.m({
								ClassName:"web.DHCBPCBloodPurificationMode",
								MethodName:"InsertBPModeLoc",
								bpcModeDr:$("#mode").combobox('getValue'),
								ctloc:$("#ctLoc").combobox('getValue'),
								bpcModeAliasDesc:'',
								hospId:session['LOGON.HOSPID']
							},function(success){
								if(success==0)
								{
									modeLocDlgObj.close();
									modeLocObj.load();
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
					modeLocDlgObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})

	}

	var UpdateHandler=function(id,mlDr,mldesc,locDr,loc)
	{
		initView();
		$("#mode").combobox('setValue',mlDr)
		$("#mode").combobox('setText',mldesc)
		$("#ctLoc").combobox('setValue',locDr)
		$("#ctLoc").combobox('setText',loc)
		$("#modeLocDialog").show();
		var modeLocDlgObj=$HUI.dialog("#modeLocDialog",{
			iconCls:'icon-w-edit',
			resizable:false,
			modal:true,
			title:'修改净化方式配置',
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#mode").combobox('getValue')==""){
						$.messager.alert("提示","透析方式不能为空","error");
						return;
					}
					if($("#ctLoc").combobox('getValue')==""){
						$.messager.alert("提示","科室不能为空","error");
						return;
					}
					var data=$.m({
							ClassName:"web.DHCBPCBloodPurificationMode",
							MethodName:"UpdateBPModeLoc",
							bpMLId:id,
							bpcModeDr:$("#mode").combobox('getValue'),
							ctloc:$("#ctLoc").combobox('getValue'),
							bpcModeAliasDesc:'',
							hospId:session['LOGON.HOSPID']
						},function(success){
							if(success==0)
							{
								modeLocDlgObj.close();
								modeLocObj.load();
							}else{
								$.messager.alert("提示","透析方式配置更新失败！");
						}
						
					})
				}
			},{
				text:"关闭",
				handler:function(){
					modeLocDlgObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})
	}
	
	
	var modeLocObj=$HUI.datagrid("#modeLocBox",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCBloodPurificationMode",
			QueryName:"FindBPModeLoc",
			hospId:session['LOGON.HOSPID']
		},
        columns:[[
			{ field: "tModeRowId", title: "编号", width: 120 },
            { field: "tBPMLDesc", title: "透析方式", width: 240 },
            { field: "tBPMLLocDesc",title:"科室",width:240},
            { field: 'tBPMLRowId',title:'透析方式ID',width:140,hidden:true},
            { field: 'tBPMLLocId',title:'科室ID',width:140,hidden:true}      
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
				var row=modeLocObj.getSelected();
				if(row)
				{
					UpdateHandler(row.tModeRowId,row.tBPMLRowId,row.tBPMLDesc,row.tBPMLLocId,row.tBPMLLocDesc);
				}
			}
            },{ 
		    iconCls: 'icon-cancel',
		    text:'删除',
		    handler: function(){
				var row=modeLocObj.getSelected();
				if(row)
				{
					$.messager.confirm("确认","确认删除？",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCBPCBloodPurificationMode",
								MethodName:"DeleteBPModeLoc",
								bpMLId:row.tModeRowId
							},function(success)
							{
								if(success==0)
								{
									modeLocObj.load();
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