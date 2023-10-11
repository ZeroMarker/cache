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
			,
			onBeforeLoad:function(param)
        	{
            	param.hospId=session['LOGON.HOSPID'];
        	}
			})			
		var amModeObj=$HUI.combobox("#amlMode",{
			url:$URL+"?ClassName=web.DHCBPCAnticoagulantMode&QueryName=FindAntMode&ResultSetType=array",
			textField:"tBPCAMDesc",
			valueField:"tBPCAMRowId",
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
				}
			})			
		}
	function setDialogValue()
	{
		$("#amlMode").combobox('setValue',"");
		$("#ctLoc").combobox('setValue',"");
	}	
	var InsertHandler=function(){
		initView();
		$("#anticoagulantmodeLocDialog").show();
		var anticoagulantmodeLocDlgObj=$HUI.dialog("#anticoagulantmodeLocDialog",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			title:'新增抗凝方式配置',
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#amlMode").combobox('getValue')==""){
						$.messager.alert("提示","抗凝方式不能为空","error");
						return;
					}
					if($("#ctLoc").combobox('getValue')==""){
						$.messager.alert("提示","科室不能为空","error");
						return;
					}	
					var data=$.m({
								ClassName:"web.DHCBPCAnticoagulantMode",
								MethodName:"InsertAntModeLoc",
								bpcAMDr:$("#amlMode").combobox('getValue'),
								ctloc:$("#ctLoc").combobox('getValue'),
								hospId:session['LOGON.HOSPID']
							},function(success){
								if(success==0)
								{
									anticoagulantmodeLocDlgObj.close();
									anticoagulantmodeLocObj.load();
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
					anticoagulantmodeLocDlgObj.close();
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
		$("#amlMode").combobox('setValue',vaDr)
		$("#amlMode").combobox('setText',vadesc)
		$("#ctLoc").combobox('setValue',locDr)
		$("#ctLoc").combobox('setText',loc)
		$("#anticoagulantmodeLocDialog").show();
		var anticoagulantmodeLocDlgObj=$HUI.dialog("#anticoagulantmodeLocDialog",{
			iconCls:'icon-w-edit',
			resizable:true,
			modal:true,
			title:'修改抗凝方式配置',
			buttons:[{
				text:"保存",
				handler:function(){
					var data=$.m({
							ClassName:"web.DHCBPCAnticoagulantMode",
							MethodName:"UpdateAntModeLoc",
							bpAMLId:id,
							BPAMLBPCAMDr:$("#amlMode").combobox('getValue'),
							ctloc:$("#ctLoc").combobox('getValue'),
							hospId:session['LOGON.HOSPID']
						},function(success){
							if(success==0)
							{
								anticoagulantmodeLocDlgObj.close();
								anticoagulantmodeLocObj.load();
							}else{
								$.messager.alert("提示","抗凝方式更新失败！");
						}
						
					})
				}
			},{
				text:"关闭",
				handler:function(){
					anticoagulantmodeLocDlgObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})
	}
	
	
	var anticoagulantmodeLocObj=$HUI.datagrid("#anticoagulantmodeLocBox",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCAnticoagulantMode",
			QueryName:"FindAntModeLoc",
			hospId:session['LOGON.HOSPID']
		},
        columns:[[
			{ field: "tAmlRowId", title: "编号", width: 120 },
            { field: "tBPAMLCAMDesc", title: "抗凝方式", width: 250 },
            { field: "tBPAMLCAMLocDesc",title:"科室",width:250},
            { field: 'tBPAMLCAMRowId',title:'抗凝方式ID',width:140,hidden:true},
            { field: 'tBPAMLCAMLocId',title:'科室ID',width:140,hidden:true}      
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
				var row=anticoagulantmodeLocObj.getSelected();
				if(row)
				{
					UpdateHandler(row.tAmlRowId,row.tBPAMLCAMRowId,row.tBPAMLCAMDesc,row.tBPAMLCAMLocId,row.tBPAMLCAMLocDesc);
				}
			}
            },{ 
		    iconCls: 'icon-cancel',
		    text:'删除',
		    handler: function(){
				var row=anticoagulantmodeLocObj.getSelected();
				if(row)
				{
					$.messager.confirm("确认","确认删除？",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCBPCAnticoagulantMode",
								MethodName:"DeleteAntModeLoc",
								bpAMLId:row.tAmlRowId
							},function(success)
							{
								if(success==0)
								{
									anticoagulantmodeLocObj.load();
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