function OnHidePanel(item)
{
	var valueField = $(item).combobox("options").valueField;
	var val = $(item).combobox("getValue");  //��ǰcombobox��ֵ
	var txt = $(item).combobox("getText");
	var allData = $(item).combobox("getData");   //��ȡcombobox��������
	var result = true;      //Ϊtrue˵�������ֵ�������������в�����
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
	    	$.messager.alert("��ʾ","���������ѡ��","error");
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
			title:'������λ��Ϣ',
			buttons:[{
				text:"����",
				handler:function(){
					if($("#BedCode").val()==""){
						$.messager.alert("��ʾ","���벻��Ϊ��","error");
						return;
					}
					if($("#BedDesc").val()==""){
						$.messager.alert("��ʾ","���Ʋ���Ϊ��","error");
						return;
					}
					if($HUI.combobox("#BedGroup").getValue()==""){
						$.messager.alert("��ʾ","��λ�鲻��Ϊ��","error");
						return;
					}
					if($HUI.combobox("#BPCBStatus").getValue()==""){
						$.messager.alert("��ʾ","״̬����Ϊ��","error");
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
									$.messager.alert("��ʾ","����ʧ�ܣ�");
								}
							})
	
					}
				},{
					text:"�ر�",
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
			title:'�޸Ĵ�λ��Ϣ',
			buttons:[{
				text:"����",
				handler:function(){
					if($("#BedCode").val()==""){
						$.messager.alert("��ʾ","���벻��Ϊ��","error");
						return;
					}
					if($("#BedDesc").val()==""){
						$.messager.alert("��ʾ","���Ʋ���Ϊ��","error");
						return;
					}
					if($HUI.combobox("#BedGroup").getValue()==""){
						$.messager.alert("��ʾ","��λ�鲻��Ϊ��","error");
						return;
					}
					if($HUI.combobox("#BPCBStatus").getValue()==""){
						$.messager.alert("��ʾ","״̬����Ϊ��","error");
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
							$.messager.alert("��ʾ","����ʧ�ܣ�");
						}
						
					})
				}
			},{
				text:"�ر�",
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
			{ field: "tRowId", title: "���", width: 60 },
            { field: "tBPCBCode", title: "����", width: 100 },
            { field: "tBPCBDesc", title: "����", width: 150 },
            { field: "tBPCBBPCBedGroupDr", title: "��λ��ID", width: 80 , hidden:true},
            { field: "tBPCBBPCBedGroup", title: "��λ��", width: 80 },
            { field: "tBPCBStatus", title: "״̬Code", width: 100 , hidden:true},
            { field: "tBPCBStatusD", title: "״̬", width: 80 },
            { field: "tBPCBType", title: "����", width: 80 },
            { field: "tBPCBIsFiltrationDr", title: "tBPCBIsFiltrationDr", width: 100 , hidden:true},
            { field: "tBPCBIsFiltration", title: "֧��Ѫ��", width: 80 },
        ]],
		//pagination:true,
		//page:1,    //��ѡ�ҳ�룬Ĭ��1
		//rows:20,
		//fit:true,
		//headerCls:"panel-header-gray",
		//singleSelect:true,
		//checkOnSelect:true,	///easyuiȡ��������ѡ��״̬
		//selectOncheck:true,
		
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
		toolbar:[{
			iconCls: 'icon-add',
		    text:'����',
		    handler: function(){
				InsertHandler();
			}
        },{
	        iconCls: 'icon-write-order',
	        text:'�޸�',
		    handler: function(){
				var row=BPCBedUIObj.getSelected();
				if(row)
				{
					UpdateHandler(row.tRowId,row.tBPCBCode,row.tBPCBDesc,row.tBPCBBPCBedGroupDr,row.tBPCBStatus,row.tBPCBType,row.tBPCBIsFiltrationDr);
				}
			}
        },{
			///ɾ������
		    iconCls: 'icon-cancel',
		    text:'ɾ��',
		    handler: function(){
				var row=BPCBedUIObj.getSelected();
				if(row)
				{
					$.messager.confirm("ȷ��","ȷ��ɾ����",function(r){
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
									$.messager.alert("��ʾ","ɾ��ʧ�ܣ�������룺"+success);
								}
							})
						}
					})
				}
			}
		},
		/* { 
			///��ѯ
		    iconCls: 'icon-search',
		    text:'��ѯ',
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