$(function(){
   	var initView=function(){
		var ctLocObj=$HUI.combobox("#ctLoc",{
			url:$URL+"?ClassName=web.DHCBPCInquiry&QueryName=ctloclookup&ResultSetType=array",
			textField:"oprCtLoc",
			valueField:"oprLocId",
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
				}
			})			
		var vasAccessObj=$HUI.combobox("#vasAccess",{
			url:$URL+"?ClassName=web.DHCBPCVascularAccess&QueryName=FindVasAccess&ResultSetType=array",
			textField:"tBPCVADesc",
			valueField:"tBPCVARowId",
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
				}
			})			
		}
	function setDialogValue()
	{
		$("#vasAccess").combobox('setValue',"");
		$("#ctLoc").combobox('setValue',"");
	}	
	var InsertHandler=function(){
		initView();
		$("#vascularaccessLocDialog").show();
		var vascularaccesslocDlgObj=$HUI.dialog("#vascularaccessLocDialog",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			title:'新增血管通路配置',
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#vasAccess").combobox('getValue')==""){
						$.messager.alert("提示","血管通路不能为空","error");
						return;
					}
					if($("#ctLoc").combobox('getValue')==""){
						$.messager.alert("提示","科室不能为空","error");
						return;
					}	
					var data=$.m({
								ClassName:"web.DHCBPCVascularAccess",
								MethodName:"InsertVasAccessLoc",
								bpcVADr:$("#vasAccess").combobox('getValue'),
								ctloc:$("#ctLoc").combobox('getValue')
							},function(success){
								if(success==0)
								{
									vascularaccesslocDlgObj.close();
									vascularaccesslocObj.load();
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
					vascularaccesslocDlgObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})
	}

	var UpdateHandler=function(id,vaDr,vadesc,locDr,loc)
	{
		initView();
		$("#vasAccess").combobox('setValue',vaDr)
		$("#vasAccess").combobox('setText',vadesc)
		$("#ctLoc").combobox('setValue',locDr)
		$("#ctLoc").combobox('setText',loc)
		$("#vascularaccessLocDialog").show();
		var vascularaccesslocDlgObj=$HUI.dialog("#vascularaccessLocDialog",{
			iconCls:'icon-w-edit',
			resizable:true,
			modal:true,
			title:'修改血管通路配置',
			buttons:[{
				text:"保存",
				handler:function(){
					var data=$.m({
							ClassName:"web.DHCBPCVascularAccess",
							MethodName:"UpdateVasAccessLoc",
							bpVALId:id,
							BPVALBPCVADr:$("#vasAccess").combobox('getValue'),
							ctloc:$("#ctLoc").combobox('getValue')
						},function(success){
							if(success==0)
							{
								vascularaccesslocDlgObj.close();
								vascularaccesslocObj.load();
							}else{
								$.messager.alert("提示","血管通路更新失败！");
						}
						
					})
				}
			},{
				text:"关闭",
				handler:function(){
					vascularaccesslocDlgObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})
	}
	
	
	var vascularaccesslocObj=$HUI.datagrid("#vascularaccessLocBox",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCVascularAccess",
			QueryName:"FindVasAccessLoc"
		},
        columns:[[
			{ field: "tValRowId", title: "编号", width: 120 },
            { field: "tBPVALCVADesc", title: "血管通路", width: 250 },
            { field: "tBPVALCVALocDesc",title:"科室",width:250},
            { field: 'tBPVALCVARowId',title:'血管通路ID',width:140,hidden:true},
            { field: 'tBPVALCVALocId',title:'科室ID',width:140,hidden:true}      
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
				var row=vascularaccesslocObj.getSelected();
				if(row)
				{
					UpdateHandler(row.tValRowId,row.tBPVALCVARowId,row.tBPVALCVADesc,row.tBPVALCVALocId,row.tBPVALCVALocDesc);
				}
			}
            },{ 
		    iconCls: 'icon-cancel',
		    text:'删除',
		    handler: function(){
				var row=vascularaccesslocObj.getSelected();
				if(row)
				{
					$.messager.confirm("确认","确认删除？",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCBPCVascularAccess",
								MethodName:"DeleteVasAccessLoc",
								bpVALId:row.tValRowId
							},function(success)
							{
								if(success==0)
								{
									vascularaccesslocObj.load();
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