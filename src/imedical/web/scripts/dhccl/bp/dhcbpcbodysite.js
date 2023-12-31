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
	$HUI.combobox("#Ward0",{
		url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array",
		textField:"ctlocDesc",
		valueField:"ctlocId",
		formatter:function(row){				
			var opts = $(this).combobox('options');
			return row[opts.textField];
		},
		onBeforeLoad:function(param)
        {
            	param.desc=param.q;
        }
        ,mode:'remote',
        onHidePanel: function () {
        	OnHidePanel("#Ward0");
        },				
	})
	
	function setDialogValue()
	{
		$('#Ward0').combobox('setValue',"")
		$("#BodySiteCode").val("");
		$("#BodySiteDesc").val("");

	}
	var InsertHandler=function(){
		$("#BPCBodySiteDlg").show();
		var BPCBodySiteDlgObj=$HUI.dialog("#BPCBodySiteDlg",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			title:'新增部位',
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#BodySiteCode").val()==""){
						$.messager.alert("提示","代码不能为空","error");
						return;
					}
					if($("#BodySiteDesc").val()==""){
						$.messager.alert("提示","名称不能为空","error");
						return;
					}
					
					var data=$.m({
						ClassName:"web.DHCCLCBodySite",
						MethodName:"SaveBodySite",
						rowId:"",
						Code:$("#BodySiteCode").val(),
						Desc:$("#BodySiteDesc").val(),
						LocId:$('#Ward0').combobox('getValue')
						},function(success){
							if(success>0)
							{
								BPCBodySiteDlgObj.close();
								BPCBodySiteDlgObj.load();
							}else
							{
								$.messager.alert("提示","添加失败！");
							}
					})
				}				
			},{
				text:"关闭",
				handler:function(){
					BPCBodySiteDlgObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})
	}
	
	var UpdateHandler=function(tRowId,tCode,tDesc,tLocId)
	{
		$("#RowId").val(tRowId);
		$("#BodySiteCode").val(tCode);
		$("#BodySiteDesc").val(tDesc);
		$('#Ward0').combobox('setValue',tLocId);
		
		$("#BPCBodySiteDlg").show();
		var BPCBodySiteDlgObj=$HUI.dialog("#BPCBodySiteDlg",{
			iconCls:'icon-w-edit',
			resizable:true,
			modal:true,
			title:'修改部位',
			buttons:[{
				text:"保存",
				handler:function(){
					var data=$.m({
						ClassName:"web.DHCCLCBodySite",
						MethodName:"SaveBodySite",
						rowId:tRowId,
						Code:$("#BodySiteCode").val(),
						Desc:$("#BodySiteDesc").val(),
						LocId:$('#Ward0').combobox('getValue')
					},function(success){
						if(success>0)
						{
							BPCBodySiteDlgObj.close();
							BPCBodySiteDlgObj.load();
						}else{
							$.messager.alert("提示","更新失败！");
						}
						
					})
				}
			},{
				text:"关闭",
				handler:function(){
					BPCBodySiteDlgObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})
	}
	
	var BPCBodySiteObj=$HUI.datagrid("#BodySite",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCCLCBodySite",
			QueryName:"FindBodySite",
			code:'',
			desc:'',
			locId:''
		},
        columns:[[
			{ field: "rowId", title: "编号", width: 80 },
            { field: "Code", title: "代码", width: 150 },
            { field: "Desc", title: "名称", width: 180 },
            { field: "LocId", title: "病区ID", width: 80 ,hidden:true},
            { field: "LocDesc", title: "病区", width: 300 }
        ]],
		pagination:true,
		pageSize: 20,
		pageList: [20, 50, 100],
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
				var row=BPCBodySiteObj.getSelected();
				if(row)
				{
					UpdateHandler(row.rowId,row.Code,row.Desc,row.LocId);
				}
			}
        },{
			///删除功能
		    iconCls: 'icon-cancel',
		    text:'删除',
		    handler: function(){
				var row=BPCBodySiteObj.getSelected();
				if(row)
				{
					$.messager.confirm("确认","确定删除？",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCCLCBodySite",
								MethodName:"DeleteBodySite",
								Rowid:row.rowId
							},function(success)
							{
								if(success==0)
								{
									BPCBodySiteObj.load();
								}else{
									$.messager.alert("提示","删除失败！错误代码："+success);
								}
							})
						}
					})
				}
			}
		}]
	})
});