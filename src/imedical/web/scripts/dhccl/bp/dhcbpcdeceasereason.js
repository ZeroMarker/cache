$(function(){
	var insertHandler=function(){
		$("#deceasereasonDlg").show();
		var deceasereasonDlgObj=$HUI.dialog("#deceasereasonDlg",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			title:'新增死亡原因',
			buttons:[
			{
				text:"保存",
				handler:function(){
					if($("#code").val()==''||$("#desc").val()==''){
						$.messager.alert("提示","代码或描述不能为空","error");
						}else
						{
							$.m({
								ClassName:"web.DHCBPCDeceaseReason",
								MethodName:"AddDHCBPCDeceaseReason",
								BPCDRCode:$("#code").val(),
								BPCDRDesc:$("#desc").val()
								},function(success){
									if(success==0){
										deceasereasonDlgObj.close();
										deceasereasonBoxObj.load();
									}else{
									$.messager.alert("提示","添加失败");
									}
							}
					)}
					}
			},
			{
				text:"关闭",
				handler:function(){
						deceasereasonDlgObj.close();
						}
			}
			]
			}
		
		)
		
		}
	
	var updateHandler=function(id,code,desc){
		$("#RowId").val(id);
		$("#code").val(code);
		$("#desc").val(desc);
		$("#deceasereasonDlg").show();
		var deceasereasonDlgObj=$HUI.dialog("#deceasereasonDlg",{
			iconCls:"icon-w-edit",
			resizable:true,
			modal:true,
			title:'修改死亡原因',
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#code").val()==""||$("#desc").val()==""){
						$.messager.alert("提示","代码或描述不能为空","error");
						}else{
							$.m({
								ClassName:"web.DHCBPCDeceaseReason",
								MethodName:"UpdateDHCBPCDeceaseReason",
								BPCDRRowId:id,
								BPCDRCode:$("#code").val(),
								BPCDRDesc:$("#desc").val()
								},function(success){
									if(success==0){
										deceasereasonDlgObj.close();
										deceasereasonBoxObj.load();
										}else{
											$.messager.alert("提示","更新失败");
											}
									})
							}
						
					}
				},{
					text:"关闭",
					handler:function(){
						deceasereasonDlgObj.close();
						}
					}]
			}
		
		)
		
		}
	
	var deleteHandler=function(row){
		$.messager.confirm("确认","确定删除？",function(r){
			if(r){
				$.m({
					ClassName:"web.DHCBPCDeceaseReason",
					MethodName:"DeleteDHCBPCDeceaseReason",
					BPCDRRowId:row.tBPCDRRowId
					},function(success){
						if(success==0){
							deceasereasonBoxObj.load();
							}else{
								$.messager.alert("提示","删除数据失败");
								}
						})
				}
			})
		}
	
	var deceasereasonBoxObj=$HUI.datagrid("#deceasereasonBox",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCDeceaseReason",
			QueryName:"FindDHCBPCDeceaseReason"	
		},
		columns:[[
		{field:"tBPCDRRowId",title:"系统号",width:120},
		{field:"tBPCDRCode",title:"代码",width:120},
		{field:"tBPCDRDesc",title:"描述",width:120}
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
		toolbar:[
		{
			iconCls:"icon-add"
			,text:"新增"
			,handler:function(){
				insertHandler();
				}
			},
		{
			iconCls:"icon-write-order"
			,text:"修改"
			,handler:function(){
				var row=deceasereasonBoxObj.getSelected();
				if(row){
					updateHandler(row.tBPCDRRowId,row.tBPCDRCode,row.tBPCDRDesc);
					}
				}
			},
		{
			iconCls:"icon-cancel"
			,text:"删除"
			,handler:function(){
				var row=deceasereasonBoxObj.getSelected();
				if(row){
					deleteHandler(row);
					}
				}
			}
		]
	})
	
	
	
})