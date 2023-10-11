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
    //激活
	$HUI.combobox("#FTPActive",{
        valueField:"code",
        textField:"desc",
        panelHeight:'auto',
        data:[{'code':"Y",'desc':"是"},{'code':"N",'desc':"否"}],
        onHidePanel: function () {
        	OnHidePanel("#FTPActive");
        }
    });
	
	//初始化输入框
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
	
	//增加
	var InsertHandler=function(){
		$("#ftpDlg").show();
		var ftpDlgObj=$HUI.dialog("#ftpDlg",{
			iconCls:'icon-w-add',
			title:'新增血透PDF上传服务器',
			resizable:true,
			modal:true,
			buttons:[{
				text:"保存",
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
							$.messager.alert("提示","添加成功！", 'info');
						}else
						{
							$.messager.alert("提示","血透PDF服务器添加失败！", "error");
						}					
					})
				}
			},{
				text:"关闭",
				handler:function(){
					ftpDlgObj.close();
				}
			}],
			onClose:function(){  
                InitBPDiag();
            } 
		})
	}
	
	//修改
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
			title:'修改血透PDF上传服务器',
			modal:true,
			buttons:[{
				text:"保存",
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
								$.messager.alert("提示","修改成功！", 'info');
							}else{
								$.messager.alert("提示","血透PDF服务器更新失败！", "error");
							}					
					})
				}
			},{
				text:"关闭",
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
			{ field: "BPPID", title: "系统号", width: 80 },
			{ field: "FTPSrvIP", title: "FTP服务器IP", width: 150 },
			{ field: "FTPSrvPortNo", title: "端口号", width: 150 },
			{ field: "FTPSrvUserName", title: "用户名", width: 150 },
			{ field: "FTPSrvUserCode", title: "密码", width: 100,
			 formatter: function(value, row, index) {
				return "******";
			 }
		     },
			{ field: "FTPFolderName", title: "文件名", width: 100 },
			{ field: "FTPType", title: "文件类型", width: 100 },
			{ field: "FTPLocalPath", title: "本地路径", width: 150 },
			{ field: "FTPActive", title: "是否激活", width: 120, hidden:true},
			{ field: "FTPActiveDesc", title: "是否激活", width: 120 },
			{ field: "FTPHttpsPortNo", title: "获取路径", width: 120 }
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
				var row=ftpListDataObj.getSelected();
				if(row)
				{
					UpdateHandler(row.BPPID,row.FTPSrvIP,row.FTPSrvPortNo,row.FTPSrvUserName,row.FTPSrvUserCode,row.FTPFolderName,row.FTPType,row.FTPActive,row.FTPLocalPath,row.FTPHttpsPortNo);
				}
				else{
					$.messager.alert("提示", "请先选择要修改的记录！", 'error');
					return;
				}
			}
        },{ 
			//删除
		    iconCls: 'icon-cancel',
		    text:'删除',
		    handler: function(){
				var row=ftpListDataObj.getSelected();
				if(row)
				{
					$.messager.confirm("确认","确定删除？",function(r){
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
									$.messager.alert("提示","删除失败！错误代码："+success, "error");
								}
							})
						}
					})
				}
				else{
					$.messager.alert("提示", "请先选择要删除的记录！", 'error');
					return;
				}
			}
		}]
	})
});