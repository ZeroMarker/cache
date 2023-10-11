///combobox不是选择，下拉框提示
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
	    if ((typeof val=="undefined")&&(txt!=""))
	    {
		    $(item).combobox('setValue',"");
	    	$.messager.alert("提示","请从下拉框选择","error");
	    	return;
	    }
	}
}
///combobox不是选择，医嘱下拉框提示
function OnHidePanel2(item)
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
	    $(item).combobox('setValue',"");
	    $.messager.alert("提示","请从下拉框选择","error");
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
			title:'新增诊断与分类关联',
			modal:true,
			buttons:[{
				text:"保存",
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
								$.messager.alert("提示","添加失败！", "error");
							}
						})
				}
			},{
				text:"关闭",
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
			title:'修改诊断与分类关联',
			modal:true,
			buttons:[{
				text:"保存",
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
							$.messager.alert("提示","更新失败！", "error");
						}
						
					})
				}
			},{
				text:"关闭",
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
			{ field: "rowId", title: "编号", width: 100 },
            { field: "DiagCatId", title: "诊断分类ID", width: 100 },
            { field: "DiagCatDes", title: "诊断分类", width: 200 },
            { field: "DiagId", title: "诊断ID", width: 100 },
            { field: "Diagnosis", title: "诊断", width: 200 }
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
				var row=DiagcatlinkObj.getSelected();
				if(row)
				{
					UpdateHandler(row.rowId,row.DiagId,row.Diagnosis,row.DiagCatId);
				}
			}
        },{
			///删除功能
		    iconCls: 'icon-cancel',
		    text:'删除',
		    handler: function(){
				var row=DiagcatlinkObj.getSelected();
				if(row)
				{
					$.messager.confirm("确认","确定删除？",function(r){
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
									$.messager.alert("提示","删除失败！错误代码："+success, "error");
								}
							})
						}
					})
				}
			}
		}/* ,
		{ 
			///查询
		    iconCls: 'icon-search',
		    text:'查询',
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