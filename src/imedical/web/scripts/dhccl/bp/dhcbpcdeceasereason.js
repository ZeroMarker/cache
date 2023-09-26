$(function(){
	var insertHandler=function(){
		$("#deceasereasonDlg").show();
		var deceasereasonDlgObj=$HUI.dialog("#deceasereasonDlg",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			title:'��������ԭ��',
			buttons:[
			{
				text:"����",
				handler:function(){
					if($("#code").val()==''||$("#desc").val()==''){
						$.messager.alert("��ʾ","�������������Ϊ��","error");
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
									$.messager.alert("��ʾ","���ʧ��");
									}
							}
					)}
					}
			},
			{
				text:"�ر�",
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
			title:'�޸�����ԭ��',
			buttons:[{
				text:"����",
				handler:function(){
					if($("#code").val()==""||$("#desc").val()==""){
						$.messager.alert("��ʾ","�������������Ϊ��","error");
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
											$.messager.alert("��ʾ","����ʧ��");
											}
									})
							}
						
					}
				},{
					text:"�ر�",
					handler:function(){
						deceasereasonDlgObj.close();
						}
					}]
			}
		
		)
		
		}
	
	var deleteHandler=function(row){
		$.messager.confirm("ȷ��","ȷ��ɾ����",function(r){
			if(r){
				$.m({
					ClassName:"web.DHCBPCDeceaseReason",
					MethodName:"DeleteDHCBPCDeceaseReason",
					BPCDRRowId:row.tBPCDRRowId
					},function(success){
						if(success==0){
							deceasereasonBoxObj.load();
							}else{
								$.messager.alert("��ʾ","ɾ������ʧ��");
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
		{field:"tBPCDRRowId",title:"ϵͳ��",width:120},
		{field:"tBPCDRCode",title:"����",width:120},
		{field:"tBPCDRDesc",title:"����",width:120}
		]],
		pagination:true,
		pageSize: 20,
		pageList: [20, 50, 100],
		//rows:20,
		fit:true,
		fitColumns:true,
		headerCls:"panel-header-gray",
		singleSelect:true,
		checkOnSelect:true,	///easyuiȡ��������ѡ��״̬
		selectOncheck:true,
        iconCls:'icon-paper',
        rownumbers: true,
		toolbar:[
		{
			iconCls:"icon-add"
			,text:"����"
			,handler:function(){
				insertHandler();
				}
			},
		{
			iconCls:"icon-write-order"
			,text:"�޸�"
			,handler:function(){
				var row=deceasereasonBoxObj.getSelected();
				if(row){
					updateHandler(row.tBPCDRRowId,row.tBPCDRCode,row.tBPCDRDesc);
					}
				}
			},
		{
			iconCls:"icon-cancel"
			,text:"ɾ��"
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