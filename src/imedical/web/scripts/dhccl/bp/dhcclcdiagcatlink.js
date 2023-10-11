///combobox����ѡ����������ʾ
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
	    if ((typeof val=="undefined")&&(txt!=""))
	    {
		    $(item).combobox('setValue',"");
	    	$.messager.alert("��ʾ","���������ѡ��","error");
	    	return;
	    }
	}
}
///combobox����ѡ��ҽ����������ʾ
function OnHidePanel2(item)
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
	    $(item).combobox('setValue',"");
	    $.messager.alert("��ʾ","���������ѡ��","error");
	    return;
	}
}
$(function(){
	//20181219+dyl
	$HUI.combobox("#comDiagnosisCat",{
		url:$URL+"?ClassName=web.DHCCLCDiagCat&QueryName=LookUpDiagCat&ResultSetType=array",
		textField:"DiagCatDes",
		valueField:"rowId",
		panelHeight:'auto',
		onBeforeLoad:function(param)
        {
            param.hospId=session['LOGON.HOSPID'];
        },
		formatter:function(row){				
			var opts = $(this).combobox('options');
			return row[opts.textField];
		},
		onHidePanel: function () {	        
        	OnHidePanel($(this));
        },
	})

	var diagnosis=$HUI.combobox("#diagnosis",{
        url:$URL+"?ClassName=web.DHCBPCom&QueryName=LookUpMrcDiagnosis&ResultSetType=array",        
        textField:"Description",
        valueField:"Id",
        onBeforeLoad:function(param){
            param.mrcidAlias=param.q;
        },
        onHidePanel: function () {	        
        	OnHidePanel2($(this));
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
			title:'���������������',
			modal:true,
			buttons:[{
				text:"����",
				handler:function(){
					var data=$.m({
						ClassName:"web.DHCCLCDiagCat",
						MethodName:"InsertDiagCatLink",
						DiagId:$('#diagnosis').combobox('getValue'),
						DiagCatId:$('#comDiagnosisCat').combobox('getValue'),
						hospId:session['LOGON.HOSPID']
						},function(success){
							if(success==0)
							{
								DiagcatlinkDlgObj.close();
								DiagcatlinkObj.load();
							}else
							{
								$.messager.alert("��ʾ","���ʧ�ܣ�", "error");
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
			title:'�޸������������',
			modal:true,
			buttons:[{
				text:"����",
				handler:function(){
					var data=$.m({
						ClassName:"web.DHCCLCDiagCat",
						MethodName:"UpdateDiagCatLink",
						DiagCatLinkId:id,
						DiagId:$('#diagnosis').combobox('getValue'),
						DiagCatId:$('#comDiagnosisCat').combobox('getValue'),
						hospId:session['LOGON.HOSPID']
					},function(success){
						if(success==0)
						{
							DiagcatlinkDlgObj.close();
							DiagcatlinkObj.load();
						}else{
							$.messager.alert("��ʾ","����ʧ�ܣ�", "error");
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
			diagCatId:'',
			hospId:session['LOGON.HOSPID']
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
	        iconCls: 'icon-write-order',
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
									$.messager.alert("��ʾ","ɾ��ʧ�ܣ�������룺"+success, "error");
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