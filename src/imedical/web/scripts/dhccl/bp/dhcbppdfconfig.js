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
    //����
	$HUI.combobox("#FTPActive",{
        valueField:"code",
        textField:"desc",
        panelHeight:'auto',
        data:[{'code':"Y",'desc':"��"},{'code':"N",'desc':"��"}],
        onHidePanel: function () {
        	OnHidePanel("#FTPActive");
        }
    });
	
	//��ʼ�������
	function InitBPDiag()
	{
		$("#FTPSrvIP").val("");
		$("#FTPSrvPortNo").val("");
		$("#FTPSrvUserName").val("");
		$("#FTPSrvUserCode").val("");
		$("#FTPFolderName").val("");
		$("#FTPType").val("");
		$("#FTPActive").combobox('setValue',"");
		$("#FTPLocalPath").val("");
		$("#FTPHttpsPortNo").val("");
	}
	
	//����
	var InsertHandler=function(){
		$("#ftpDlg").show();
		var ftpDlgObj=$HUI.dialog("#ftpDlg",{
			iconCls:'icon-w-add',
			title:'����Ѫ͸PDF�ϴ�������',
			resizable:true,
			modal:true,
			buttons:[{
				text:"����",
				handler:function(){
					 var datas=$.m({
						 ClassName:"web.DHCBPPDFConfig",
						 MethodName:"InsertFTP",
						 data:$("#FTPSrvIP").val()+"^"+$("#FTPSrvPortNo").val()+"^"+$("#FTPSrvUserName").val()+"^"+$("#FTPSrvUserCode").val()+"^"+$("#FTPFolderName").val()+"^"+$("#FTPType").val()+"^"+$("#FTPLocalPath").val()+"^"+$("#FTPActive").combobox('getValue')+"^"+$("#FTPHttpsPortNo").val()
					},function(success){
						if(success>=0)
						{
							ftpDlgObj.close();
							ftpListDataObj.load();
							$.messager.alert("��ʾ","��ӳɹ���", 'info');
						}else
						{
							$.messager.alert("��ʾ","Ѫ͸PDF���������ʧ�ܣ�", "error");
						}					
					})
				}
			},{
				text:"�ر�",
				handler:function(){
					ftpDlgObj.close();
				}
			}],
			onClose:function(){  
                InitBPDiag();
            } 
		})
	}
	
	//�޸�
	var UpdateHandler=function(id,FTPSrvIP,FTPSrvPortNo,FTPSrvUserName,FTPSrvUserCode,FTPFolderName,FTPType,FTPActive,FTPLocalPath,FTPHttpsPortNo)
	{
		$("#FTPSrvIP").val(FTPSrvIP);
		$("#FTPSrvPortNo").val(FTPSrvPortNo);
		$("#FTPSrvUserName").val(FTPSrvUserName);
		//$("#FTPSrvUserCode").val(FTPSrvUserCode);
		$("#FTPFolderName").val(FTPFolderName);
		$("#FTPType").val(FTPType);
		$("#FTPActive").combobox('setValue',FTPActive);
		$("#FTPLocalPath").val(FTPLocalPath);
		$("#FTPHttpsPortNo").val(FTPHttpsPortNo);
		$("#ftpDlg").show();
		
		var ftpDlgObj=$HUI.dialog("#ftpDlg",{
			iconCls:'icon-w-edit',
			resizable:true,
			title:'�޸�Ѫ͸PDF�ϴ�������',
			modal:true,
			buttons:[{
				text:"����",
				handler:function(){

						var datas=$.m({
							ClassName:"web.DHCBPPDFConfig",
							MethodName:"UpdateFTP",
							bppId:id,
							data:$("#FTPSrvIP").val()+"^"+$("#FTPSrvPortNo").val()+"^"+$("#FTPSrvUserName").val()+"^"+$("#FTPSrvUserCode").val()+"^"+$("#FTPFolderName").val()+"^"+$("#FTPType").val()+"^"+$("#FTPLocalPath").val()+"^"+$("#FTPActive").combobox('getValue')+"^"+$("#FTPHttpsPortNo").val()
    					},function(success){
							if(success>=0)
							{
								ftpDlgObj.close();
								ftpListDataObj.load();
								$.messager.alert("��ʾ","�޸ĳɹ���", 'info');
							}else{
								$.messager.alert("��ʾ","Ѫ͸PDF����������ʧ�ܣ�", "error");
							}					
					})
				}
			},{
				text:"�ر�",
				handler:function(){
					ftpDlgObj.close();
				}
			}],
			onClose:function(){  
                InitBPDiag();
            } 
		})
	}
	
	var ftpListDataObj=$HUI.datagrid("#ftpListData",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPPDFConfig",
			QueryName:"FindFTPList",
			bppId:''
		},
        columns:[[
			{ field: "BPPID", title: "ϵͳ��", width: 80 },
			{ field: "FTPSrvIP", title: "FTP������IP", width: 150 },
			{ field: "FTPSrvPortNo", title: "�˿ں�", width: 150 },
			{ field: "FTPSrvUserName", title: "�û���", width: 150 },
			{ field: "FTPSrvUserCode", title: "����", width: 100,
			 formatter: function(value, row, index) {
				return "******";
			 }
		     },
			{ field: "FTPFolderName", title: "�ļ���", width: 100 },
			{ field: "FTPType", title: "�ļ�����", width: 100 },
			{ field: "FTPLocalPath", title: "����·��", width: 150 },
			{ field: "FTPActive", title: "�Ƿ񼤻�", width: 120, hidden:true},
			{ field: "FTPActiveDesc", title: "�Ƿ񼤻�", width: 120 },
			{ field: "FTPHttpsPortNo", title: "��ȡ·��", width: 120 }
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
				var row=ftpListDataObj.getSelected();
				if(row)
				{
					UpdateHandler(row.BPPID,row.FTPSrvIP,row.FTPSrvPortNo,row.FTPSrvUserName,row.FTPSrvUserCode,row.FTPFolderName,row.FTPType,row.FTPActive,row.FTPLocalPath,row.FTPHttpsPortNo);
				}
				else{
					$.messager.alert("��ʾ", "����ѡ��Ҫ�޸ĵļ�¼��", 'error');
					return;
				}
			}
        },{ 
			//ɾ��
		    iconCls: 'icon-cancel',
		    text:'ɾ��',
		    handler: function(){
				var row=ftpListDataObj.getSelected();
				if(row)
				{
					$.messager.confirm("ȷ��","ȷ��ɾ����",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCBPPDFConfig",
								MethodName:"DelFTP",
								bppId:row.BPPID
							},function(success)
							{
								if(success==0)
								{
									ftpListDataObj.load();
								}else{
									$.messager.alert("��ʾ","ɾ��ʧ�ܣ�������룺"+success, "error");
								}
							})
						}
					})
				}
				else{
					$.messager.alert("��ʾ", "����ѡ��Ҫɾ���ļ�¼��", 'error');
					return;
				}
			}
		}]
	})
});