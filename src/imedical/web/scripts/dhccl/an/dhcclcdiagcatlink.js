$(function(){
	//20181219+dyl
	$HUI.combobox("#comDiagnosisCat",{
		url:$URL+"?ClassName=web.DHCCLCDiagCat&QueryName=LookUpDiagCat&ResultSetType=array",
		textField:"DiagCatDes",
		valueField:"rowId",
		 panelHeight:'auto',
		formatter:function(row){				
			var opts = $(this).combobox('options');
			return row[opts.textField];
		}
	})

	var diagnosis=$HUI.combobox("#diagnosis",{
        url:$URL+"?ClassName=web.DHCBPCom&QueryName=LookUpMrcDiagnosis&ResultSetType=array",        
        textField:"Description",
        valueField:"Id",
        onBeforeLoad:function(param){
            param.mrcidAlias=param.q;
        },
        mode: "remote"
    });	
	function setDialogValue()
	{
		//$('#diagnosis').combobox("reload");
		$("#diagnosis").combobox('setValue',"");
		$("#comDiagnosisCat").combobox('setValue',"");
	}
	var InsertHandler=function(){
		$("#DiagcatlinkDlg").show();
		var DiagcatlinkDlgObj=$HUI.dialog("#DiagcatlinkDlg",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			buttons:[{
				text:"����",
				handler:function(){
					var data=$.m({
						ClassName:"web.DHCCLCDiagCat",
						MethodName:"InsertDiagCatLink",
						DiagId:$('#diagnosis').combobox('getValue'),
						DiagCatId:$('#comDiagnosisCat').combobox('getValue')
						},function(success){
							if(success==0)
							{
								DiagcatlinkDlgObj.close();
								DiagcatlinkObj.load();
							}else
							{
								$.messager.alert("��ʾ","���ʧ�ܣ�");
							}
						})
				}
			},{
				text:"�ر�",
				handler:function(){
					DiagcatlinkDlgObj.close();
				}
			}],
			onClose:function(){  
                	setDialogValue();
            } 
		})
	}
	
	var UpdateHandler=function(id,DiagDes0ID,Diagnosis,comDiagnosisCatID)
	{
		$('#comDiagnosisCat').combobox('setValue',comDiagnosisCatID);
		$('#diagnosis').combobox('setValue',DiagDes0ID);
		$('#diagnosis').combobox('setText',Diagnosis);
		$("#DiagcatlinkDlg").show();
		
		var DiagcatlinkDlgObj=$HUI.dialog("#DiagcatlinkDlg",{
			iconCls:'icon-w-edit',
			resizable:true,
			modal:true,
			buttons:[{
				text:"����",
				handler:function(){
					var data=$.m({
						ClassName:"web.DHCCLCDiagCat",
						MethodName:"UpdateDiagCatLink",
						DiagCatLinkId:id,
						DiagId:$('#diagnosis').combobox('getValue'),
						DiagCatId:$('#comDiagnosisCat').combobox('getValue')
					},function(success){
						if(success==0)
						{
							DiagcatlinkDlgObj.close();
							DiagcatlinkObj.load();
						}else{
							$.messager.alert("��ʾ","����ʧ�ܣ�");
						}
						
					})
				}
			},{
				text:"�ر�",
				handler:function(){
					DiagcatlinkDlgObj.close();
				}
			}],
			onClose:function(){  
                	setDialogValue();
            } 
		})
	}
	
	var DiagcatlinkObj=$HUI.datagrid("#Diagcatlink",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCCLCDiagCat",
			QueryName:"LookUpDiagCatLink",
			diagCatId:''
		},
        columns:[[
			{ field: "rowId", title: "���", width: 100 },
            { field: "DiagCatId", title: "��Ϸ���ID", width: 100 },
            { field: "DiagCatDes", title: "��Ϸ���", width: 200 },
            { field: "DiagId", title: "���ID", width: 100 },
            { field: "Diagnosis", title: "���", width: 200 }
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
		toolbar:[{
			iconCls: 'icon-add',
		    text:'����',
		    handler: function(){
				InsertHandler();
			}
        },{
	        iconCls: 'icon-edit',
	        text:'�޸�',
		    handler: function(){
				var row=DiagcatlinkObj.getSelected();
				if(row)
				{
					UpdateHandler(row.rowId,row.DiagId,row.Diagnosis,row.DiagCatId);
				}
			}
        },{
			///ɾ������
		    iconCls: 'icon-cancel',
		    text:'ɾ��',
		    handler: function(){
				var row=DiagcatlinkObj.getSelected();
				if(row)
				{
					$.messager.confirm("ȷ��","ȷ��ɾ����",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCCLCDiagCat",
								MethodName:"DeleteDiagCatLink",
								Rowid:row.rowId
							},function(success)
							{
								if(success==0)
								{
									DiagcatlinkObj.load();
								}else{
									$.messager.alert("��ʾ","ɾ��ʧ�ܣ�������룺"+success);
								}
							})
						}
					})
				}
			}
		}/* ,
		{ 
			///��ѯ
		    iconCls: 'icon-search',
		    text:'��ѯ',
		    handler: function(){
				doSearch();
			}
		} */]
	})
	function doSearch(){
		//alert(1);
		$('#Diagcatlink').datagrid('load',{
			diagCatId:$('#comDiagnosisCat').combogrid('getValue')
		})
	}
});