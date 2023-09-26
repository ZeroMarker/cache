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
	    if ((val==undefined)&&(txt!=""))
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
	var bpciRowid="1";  	
	//科室
	var inquiryLocObj=$HUI.combobox("#SearchBPCICtloc,#BPCICtloc",{
			url:$URL+"?ClassName=web.DHCBPCInquiry&QueryName=ctloclookup&ResultSetType=array",
			textField:"oprCtLoc",
			valueField:"oprLocId",
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
			},
			onHidePanel: function () {	        
        		OnHidePanel($(this));
        	},
	})
	//状态
	var inquiryStatusObj=$HUI.combobox("#BPCIStatus",{
			url:$URL+"?ClassName=web.DHCBPCInquiry&QueryName=Statuslookup&ResultSetType=array",
			textField:"StatusDesc",
			valueField:"StatusCode",
			panelHeight:"auto",
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
			},
			onHidePanel: function () {	        
        		OnHidePanel($(this));
        	},
	})	
	//类型
	$HUI.combobox("#BPCIType",{
        valueField:"Code",
        textField:"Desc",
        panelHeight:"auto",
        data:[{'Code':"A",'Desc':"All"}
        ,{'Code':"L",'Desc':"Location"}
        ,{'Code':"U",'Desc':"User"}
        ,{'Code':"S",'Desc':"SelfDefine"}
        ,{'Code':"D",'Desc':"DataDefine"}],
        onHidePanel: function () {	        
        	OnHidePanel($(this));
        },
    })
    //统计类型
	$HUI.combobox("#BPCIDataType",{
        valueField:"Code",
        textField:"Desc",
        panelHeight:"auto",
        data:[{'Code':"P",'Desc':"Patient"}
        ,{'Code':"M",'Desc':"MultiPatient"}
        ,{'Code':"L",'Desc':"Location"}
        ,{'Code':"S",'Desc':"Summary"}
        ,{'Code':"C",'Desc':"CRF"}],
        onHidePanel: function () {	        
        	OnHidePanel($(this));
        },
    })   
	//基准常用医嘱
	var ICUCIICodeObj=$HUI.combobox("#BPCIIRefBpriId",{
		url:$URL+"?ClassName=web.DHCBPCRecordItem&QueryName=FindBPCReItem&ResultSetType=array",
		valueField:'tRowId',
		textField:'tBPCRIDesc',
		onBeforeLoad:function(param){
			param.BPCRIDesc=param.q;
		},
		onHidePanel: function () {	        
        	OnHidePanel2($(this));
        },
		mode:'remote'  //用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
	})
	//代码
	var ICUCIICodeObj=$HUI.combobox("#BPCIICode",{
		url:$URL+"?ClassName=web.DHCBPCRecordItem&QueryName=FindBPCReItem&ResultSetType=array",
		valueField:'tRowId',
		textField:'tBPCRICode',
		onBeforeLoad:function(param){
			param.BPCRIDesc=param.q;
		},
		mode:'remote'  //用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
	})
	//类型
	var ICUCIITypeObj=$HUI.combobox("#BPCIIType",{
		url:$URL+"?ClassName=web.DHCBPCInquiry&QueryName=FindType&ResultSetType=array",
		valueField:'Id',
		textField:'Desc',
		onHidePanel: function () {	        
        	OnHidePanel($(this));
        },
	})
	//查找项、显示项、单条数据
	var ICUCIIIsSearchObj=$HUI.combobox("#BPCIIIsSearch,#BPCIIIsDisplay,#BPCIIIsSingle",{
		url:$URL+"?ClassName=web.DHCBPCInquiry&QueryName=FindBoolen&ResultSetType=array",
		valueField:'Id',
		textField:'Desc',
		panelHeight:"auto",
		onHidePanel: function () {	        
        	OnHidePanel($(this));
        },
	})
	//主项图标类型
	$HUI.combobox("#BPCIISummaryChartType",{
        valueField:"Code",
        textField:"Desc",
        panelHeight:"auto",
        data:[{'Code':"Z",'Desc':"柱状图"},{'Code':"S",'Desc':"饼状图"}],
        onHidePanel: function () {	        
        	OnHidePanel($(this));
        },
    })
	$("#btnSearch").click(function(){
		$('#inquiryBox').datagrid({
			url:$URL,
	        queryParams:{
			ClassName:"web.DHCBPCInquiry",
			QueryName:"FindBPCInquiry",
			CtlocDr:$("#SearchBPCICtloc").combobox('getValue'),
			desc:$("#SearchBPCIDesc").val(),
			}
		});
	})
	function setDialogValue()
	{		
		$("#BPCIRowId").val("");		
		$("#BPCICode").val("");
		$("#BPCIDesc").val("");	
		$("#BPCICtloc").combobox('setValue',"")
		$("#BPCIType").combobox('setValue',"")
		$("#BPCIStatus").combobox('setValue',"")
		$("#BPCISearchLevel").val("");
		$("#BPCICount").val("");
		$("#BPCIResultCount").val("");	
		$("#BPCIDataType").combobox('setValue',"")
	}	
	var InsertHandler=function(){
		//initView();
		$("#inquiryDialog").show();
		var inquiryDigObj=$HUI.dialog("#inquiryDialog",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			title:'新增统计条件',
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#BPCICode").val()==""){
						$.messager.alert("提示","代码不能为空","error");
						return;
					}
					if($("#BPCIDesc").val()==""){
						$.messager.alert("提示","描述不能为空","error");
						return;
					}
					if($("#BPCICtloc").combobox('getValue')==""){
						$.messager.alert("提示","科室不能为空","error");
						return;
					}
					var data=$.m({
								ClassName:"web.DHCBPCInquiry",
								MethodName:"InsertBPCInquiry",
								BPCICode:$("#BPCICode").val(),
								BPCIDesc:$("#BPCIDesc").val(),
								BPCICtlocDr:$("#BPCICtloc").combobox('getValue'),								
								BPCIStatus:$("#BPCIStatus").combobox('getValue'),
								BPCISearchLevel:$("#BPCISearchLevel").val(),
								BPCIBpaCount:$("#BPCICount").val(),
								BPCIResultCount:$("#BPCIResultCount").val(),
								BPCIType:$("#BPCIType").combobox('getValue'),
								BPCIUpdateUserDr:"0",
								BPCIDataType:$("#BPCIDataType").combobox('getValue')
					},function(success){
						if(success>=0)
						{
							inquiryDigObj.close();
							inquiryBoxObj.load();
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
					inquiryDigObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})
	}

	var UpdateHandler=function(row)
	{		
		//initView();
		$("#BPCIRowId").val(row.TRowid);		
		$("#BPCICode").val(row.TBPCICode);
		$("#BPCIDesc").val(row.TBPCIDesc);
		$("#BPCICtloc").combobox('setValue',row.TBPCICtlocDr);
		//$("#BPCICtloc").combobox('setText',row.TBPCICtloc);
		$("#BPCIStatus").combobox('setValue',row.TBPCIStatusCode);
		//$("#BPCIStatus").combobox('setText',row.TBPCIStatus);
		$("#BPCISearchLevel").val(row.TBPCISearchLevel);
		$("#BPCICount").val(row.TBPCIBpaCount);
		$("#BPCIResultCount").val(row.TBPCIResultCount);
		$("#BPCIType").combobox('setText',row.TBPCIType);
		$("#BPCIDataType").combobox('setValue',row.TBPCIDataType);
		$("#inquiryDialog").show();		
		var inquiryDigObj=$HUI.dialog("#inquiryDialog",{
			iconCls:'icon-w-edit',
			resizable:true,
			modal:true,
			title:'修改统计条件',
			buttons:[{
				text:"保存",
				handler:function(){					
					var data=$.m({
							ClassName:"web.DHCBPCInquiry",
							MethodName:"UpdateBPCInquiry",
							RowID:$("#BPCIRowId").val(),
							BPCICode:$("#BPCICode").val(),
							BPCIDesc:$("#BPCIDesc").val(),							
							BPCICtlocDr:$("#BPCICtloc").combobox('getValue'),
							BPCIStatus:$("#BPCIStatus").combobox('getValue'),
							BPCISearchLevel:$("#BPCISearchLevel").val(),
							BPCIBpaCount:$("#BPCICount").val(),							
							BPCIResultCount:$("#BPCIResultCount").val(),		
							BPCIType:$("#BPCIType").combobox('getValue'),						
							BPCIDataType:$("#BPCIDataType").combobox('getValue')
							
						},function(success){
							if(success==0)
							{
								inquiryDigObj.close();
								inquiryBoxObj.load();
							}else{
								$.messager.alert("提示",success);
						}
						
					})
				}
			},{
				text:"关闭",
				handler:function(){
					inquiryDigObj.close();
				}
			}],			
			onClose:function(){  
                setDialogValue();
            } 
		})
	}
		
	var inquiryBoxObj=$HUI.datagrid("#inquiryBox",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCInquiry",
			QueryName:"FindBPCInquiry"
		},
		onBeforeLoad:function(param){			
			param.CtlocDr=$("#SearchBPCICtloc").combobox('getValue'),
			param.desc=$("#SearchBPCIDesc").val()
		},
		title:'统计条件',
        columns:[[
			{ field: "TRowid", title: "系统号", width: 120 },
			{ field: "TBPCICode",title:"代码",width:240},
            { field: "TBPCIDesc", title: "描述", width: 240 },            
            { field: 'TBPCICtlocDr',title:'科室ID',width:140,hidden:true},
            { field: 'TBPCICtloc',title:'科室',width:140 },
            { field: 'TBPCIType',title:'类型',width:140},   
            { field: 'TBPCIStatusCode',title:'状态Code',width:140,hidden:true},
            { field: 'TBPCIStatus',title:'状态',width:140},
            { field: 'TBPCISearchLevel',title:'搜索级别',width:140,hidden:true},  
            { field: 'TBPCIBpaCount',title:'统计',width:140}, 
            { field: 'TBPCIResultCount',title:'结果统计',width:140},  
            { field: 'TBPCIDataType',title:'统计类型',width:140}, 
        ]],
		pagination:true,
		pageSize: 20,
		pageList: [20, 50, 100],
		fit:true,
		fitColumns:true,
		headerCls:"panel-header-gray",
		singleSelect:true,
		//checkOnSelect:true,	///easyui取消单击行选中状态
		//selectOncheck:true,
        iconCls:'icon-paper',
        rownumbers: true,
		onSelect:function(rowIndex,rowData){
			inquiryItemBoxObj.load();
		},
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
				var row=inquiryBoxObj.getSelected();
				if(row)
				{
					UpdateHandler(row);
				}
			}
            },{ 
		    iconCls: 'icon-cancel',
		    text:'删除',
		    handler: function(){
				var row=inquiryBoxObj.getSelected();
				if(row)
				{
					$.messager.confirm("确认","确认删除？",function(r){
						if(r)
						{
							$.m({
								ClassName:"web.DHCBPCInquiry",
								MethodName:"DeleteBPCInquiry",
								RowID:row.TRowid
							},function(success)
							{
								if(success==0)
								{
									inquiryBoxObj.load();
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
	function setInquiryItemDialogValue()
	{		
		$("#InquiryRowId").val("");		
		$("#InquiryItemRowId").val("");	
		$("#BPCIICode").combobox('setValue',"")
		$("#BPCIICode").combobox('setText',"")
		$("#BPCIIDesc").val("");
		$("#BPCIIType").combobox('setValue',"")		
		$("#BPCIIIsSearch").combobox('setValue',"")	
		$("#BPCIIIsDisplay").combobox('setValue',"")		
		$("#BPCIIDataField").val("");		
		$("#BPCIIIsSingle").combobox('setValue',"")
		$("#BPCIIMinQty").val("");		
		$("#BPCIIMaxQty").val("");
		$("#BPCIINote").val("");
		$("#BPCIIMultiple").val("");
		$("#BPCIIStartDateTime").val("");
		$("#BPCIIDurationHour").val("");
		$("#BPCIIOeoriNote").val("");
		$("#BPCIIFromTime").val("");
		$("#BPCIIToTime").val("");
		$("#BPCIIExactTime").timespinner('setValue',"")		
		$("#BPCIIRefBpriId").combobox('setValue',"")			
		$("#BPCIIRefValue").val("");
		$("#BPCIISeqNo").val("");
		$("#BPCIILevel").val("");
		$("#BPCIISummaryType").val("");		
		$("#BPCIIColumnWidth").val("");
		$("#BPCIISummarySeqNo").val("");
		$("#BPCIISummaryChartType").combobox('setValue',"")
	}	
	var InsertInquiryItemHandler=function(){
		//initView();
		$("#inquiryItemDialog").show();
		var inquiryItemDigObj=$HUI.dialog("#inquiryItemDialog",{
			iconCls:'icon-add',
			resizable:true,
			modal:true,
			title:'新增统计项目',
			buttons:[{
				text:"保存",
				handler:function(){
					if($("#BPCIICode").combobox('getText')==""){
						$.messager.alert("提示","代码不能为空","error");
						return;
					}
					if($("#BPCIIDesc").val()==""){
						$.messager.alert("提示","描述不能为空","error");
						return;
					}
					if($("#BPCIIType").combobox('getValue')==""){
						$.messager.alert("提示","类型不能为空","error");
						return;
					}
					
					var data=$.m({
								ClassName:"web.DHCBPCInquiry",
								MethodName:"InsertInquiryitem",
								BPCIRowid:bpciRowid, //$("#InquiryRowId").val(),
								BPCIICode:$("#BPCIICode").combobox('getText'),
								BPCIIDesc:$("#BPCIIDesc").val(),
								BPCIIType:$("#BPCIIType").combobox('getValue'), 
								BPCIIIsSearch:$("#BPCIIIsSearch").combobox('getValue'), 
								BPCIIIsDisplay:$("#BPCIIIsDisplay").combobox('getValue'), 
								BPCIIDataField:$("#BPCIIDataField").val(), 
								BPCIIIsSingle:$("#BPCIIIsSingle").combobox('getValue'),
								BPCIIMinQty:$("#BPCIIMinQty").val(),
								BPCIIMaxQty:$("#BPCIIMaxQty").val(), 
								BPCIINote:$("#BPCIINote").val(),
								BPCIIMultiple:$("#BPCIIMultiple").val(), 
								BPCIIStartDateTime:$("#BPCIIStartDateTime").val(), 
								BPCIIDurationHour:$("#BPCIIDurationHour").val(), 
								BPCIIOeoriNote:$("#BPCIIOeoriNote").val(),
								BPCIIFromTime:$("#BPCIIFromTime").val(), 
								BPCIIToTime:$("#BPCIIToTime").val(), 
								BPCIIExactTime:$("#BPCIIExactTime").timespinner('getValue'), 
								BPCIIRefBPriId:$("#BPCIIRefBpriId").combobox('getValue'), 
								BPCIIRefValue:$("#BPCIIRefValue").val(), 
								BPCIISeqNo:$("#BPCIISeqNo").val(),
								BPCIILevel:$("#BPCIILevel").val(),
								BPCIISummaryType:$("#BPCIISummaryType").val(),
								BPCIIColumnWidth:$("#BPCIIColumnWidth").val(),
								BPCIIMainBPCIIDr:$("#BPCIISummarySeqNo").val(),
								BPCIISummaryChartType:$("#BPCIISummaryChartType").combobox('getValue'), 
							
							},function(success){
								if(success==0)
								{
									inquiryItemDigObj.close();
									inquiryItemBoxObj.load();
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
					inquiryItemDigObj.close();
				}
			}],			
			onClose:function(){  
                setInquiryItemDialogValue();
            } 
		})

	}

	var UpdateInquiryItemHandler=function(row)
	{
		$("#InquiryRowId").val(row.TBPCIRowid);		
		$("#InquiryItemRowId").val(row.TRowid);	
		$("#BPCIICode").combobox('setText',row.TBPCIICode)
		$("#BPCIIDesc").val(row.TBPCIIDesc);
		$("#BPCIIType").combobox('setValue',row.TBPCIIType)		
		$("#BPCIIIsSearch").combobox('setValue',row.TBPCIIIsSearch)	
		$("#BPCIIIsDisplay").combobox('setValue',row.TBPCIIIsDisplay)		
		$("#BPCIIDataField").val(row.TBPCIIDataField);		
		$("#BPCIIIsSingle").combobox('setValue',row.TBPCIIIsSingle)
		$("#BPCIIMinQty").val(row.TBPCIIMinQty);		
		$("#BPCIIMaxQty").val(row.TBPCIIMaxQty);
		$("#BPCIINote").val(row.TBPCIINote);
		$("#BPCIIMultiple").val(row.TBPCIIMultiple);
		$("#BPCIIStartDateTime").val(row.TBPCIIStartDateTime);
		$("#BPCIIDurationHour").val(row.TBPCIIDurationHour);
		$("#BPCIIOeoriNote").val(row.TBPCIIOeoriNote);
		$("#BPCIIFromTime").val(row.TBPCIIFromTime);
		$("#BPCIIToTime").val(row.TBPCIIToTime);
		$("#BPCIIExactTime").timespinner('setValue',row.TBPCIIExactTime)		
		$("#BPCIIRefBpriId").combobox('setValue',row.TBPCIIRefIcuriId)			
		$("#BPCIIRefValue").val(row.TBPCIIRefValue);
		$("#BPCIISeqNo").val(row.TBPCIISeqNo);
		$("#BPCIILevel").val(row.TBPCIILevel);
		$("#BPCIISummaryType").val(row.TBPCIISummaryType);		
		$("#BPCIIColumnWidth").val(row.TBPCIIColumnWidth);
		$("#BPCIISummarySeqNo").val(row.TBPCIISummarySeqNo);
		$("#BPCIISummaryChartType").combobox('setValue',row.TBPCIISumChartType);
		
		$("#inquiryItemDialog").show();		
		var inquiryItemDigObj=$HUI.dialog("#inquiryItemDialog",{
			iconCls:'icon-edit',
			resizable:true,
			modal:true,
			title:'修改统计项目',
			buttons:[{
				text:"保存",
				handler:function(){	
					//alert($("#BPCIICode").combobox('getValue'));			  
					var data=$.m({
							ClassName:"web.DHCBPCInquiry",
							MethodName:"UpdateInquiryitem",
								BPCIRowid:$("#InquiryRowId").val(),
								Rowid:$("#InquiryItemRowId").val(),	
								BPCIICode:$("#BPCIICode").combobox('getText'),
								BPCIIDesc:$("#BPCIIDesc").val(),
								BPCIIType:$("#BPCIIType").combobox('getValue'), 
								BPCIIIsSearch:$("#BPCIIIsSearch").combobox('getValue'), 
								BPCIIIsDisplay:$("#BPCIIIsDisplay").combobox('getValue'), 
								BPCIIDataField:$("#BPCIIDataField").val(), 
								BPCIIIsSingle:$("#BPCIIIsSingle").combobox('getValue'),
								BPCIIMinQty:$("#BPCIIMinQty").val(),
								BPCIIMaxQty:$("#BPCIIMaxQty").val(), 
								BPCIINote:$("#BPCIINote").val(),
								BPCIIMultiple:$("#BPCIIMultiple").val(), 
								BPCIIStartDateTime:$("#BPCIIStartDateTime").val(), 
								BPCIIDurationHour:$("#BPCIIDurationHour").val(), 
								BPCIIOeoriNote:$("#BPCIIOeoriNote").val(),
								BPCIIFromTime:$("#BPCIIFromTime").val(), 
								BPCIIToTime:$("#BPCIIToTime").val(), 
								BPCIIExactTime:$("#BPCIIExactTime").timespinner('getValue'), 
								BPCIIRefBPriId:$("#BPCIIRefBpriId").combobox('getValue'), 
								BPCIIRefValue:$("#BPCIIRefValue").val(), 
								BPCIISeqNo:$("#BPCIISeqNo").val(),
								BPCIILevel:$("#BPCIILevel").val(),
								BPCIIFromBPriId:"",
								BPCIIToBPriId:"",
								BPCIISummaryType:$("#BPCIISummaryType").val(),
								BPCIIDurationInterval:"",
								BPCIIColumnWidth:$("#BPCIIColumnWidth").val(),
								BPCIIMainBPCIIDr:$("#BPCIISummarySeqNo").val(),
								BPCIISummaryChartType:$("#BPCIISummaryChartType").combobox('getValue'),
						},function(success){
							if(success==0)
							{
								inquiryItemDigObj.close();
								inquiryItemBoxObj.load();
							}else{
								$.messager.alert("提示","血液净化查询更新失败！");
						}
						
					})
				}
			},{
				text:"关闭",
				handler:function(){
					inquiryItemDigObj.close();
				}
			}],			
			onClose:function(){  
                setInquiryItemDialogValue();
            } 
		})
	}
	//重症查询项目
	var inquiryItemBoxObj=$HUI.datagrid("#inquiryItemBox",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPCInquiry",
			QueryName:"FindInquiryitem"
		},
		onBeforeLoad:function(param){			
			var inquiryRow=inquiryBoxObj.getSelected();
			if(inquiryRow)
			{
				bpciRowid=inquiryRow.TRowid;
			}
			param.BPCIRowid=bpciRowid;
		},
		title:'统计项目',
		columns:[[
			{ field: "TBPCIRowid", title: "父表ID", width: 60, hidden:true},
			{ field: "TRowid", title: "编号", width: 60 },
			{ field: "TBPCIICode", title: "代码", width: 100 },
			{ field: "TBPCIIDesc", title: "名称", width: 100 },
			{ field: "TBPCIIType", title: "类型Code", width: 100, hidden:true },
			{ field: "TBPCIITypeD", title: "类型", width: 100 },
			{ field: "TBPCIIIsSearch", title: "查找项Code", width: 100, hidden:true},
			{ field: "TBPCIIIsSearchD", title: "查找项", width: 100 },
			{ field: "TBPCIIIsDisplay", title: "显示项Code", width: 100, hidden:true},
			{ field: "TBPCIIIsDisplayD", title: "显示项", width: 100 },
			{ field: "TBPCIIDataField", title: "字段", width: 100 },
			{ field: "TBPCIIIsSingle", title: "返回单条数据Code", width: 100, hidden:true},
			{ field: "TBPCIIIsSingleD", title: "返回单条数据", width: 100 },
			{ field: "TBPCIIMinQty", title: "最小值", width: 100 },
			{ field: "TBPCIIMaxQty", title: "最大值", width: 100 },
			{ field: "TBPCIINote", title: "说明", width: 100 },
			{ field: "TBPCIIMultiple", title: "多选值", width: 100 },
			{ field: "TBPCIIStartDateTime", title: "开始时间类型", width: 100 },
			{ field: "TBPCIIDurationHour", title: "持续小时", width: 100 },
			{ field: "TBPCIIOeoriNote", title: "医嘱备注", width: 100 },
			{ field: "TBPCIIFromTime", title: "起始秒数", width: 100 },
			{ field: "TBPCIIToTime", title: "终止秒数", width: 100 },
			{ field: "TBPCIIExactTime", title: "准确时间", width: 100 },
			{ field: "TBPCIIRefIcuriId", title: "基准常用医嘱Id", width: 100 , hidden:true},
			{ field: "TBPCIIRefIcuriDesc", title: "基准常用医嘱", width: 100 },
			{ field: "TBPCIIRefValue", title: "基准值", width: 100 },
			{ field: "TBPCIISeqNo", title: "排序号", width: 100 },
			{ field: "TBPCIILevel", title: "筛选值", width: 100 },
			{ field: "TBPCIISummaryType", title: "汇总类型", width: 100 },
			{ field: "TBPCIIColumnWidth", title: "列宽", width: 100 },
			{ field: "TBPCIISummarySeqNo", title: "主项索引", width: 100 },
			{ field: "TBPCIISumChartType", title: "主项图标类型", width: 100 , hidden:true},
			{ field: "TBPCIISumChartTypeD", title: "主项图标类型", width: 100 }
		]],
		pagination:true,
		pageSize: 20,
		pageList: [20, 50, 100],
		fit:true,
		//fitColumns:true,
		headerCls:"panel-header-gray",
		singleSelect:true,
		checkOnSelect:true,	///easyui取消单击行选中状态
		selectOncheck:true,
        iconCls:'icon-paper',
        rownumbers: true,
		toolbar:[
			{
				iconCls:'icon-add',
				text:'新增',
				handler:function(){
					InsertInquiryItemHandler();
				}
			},
			{
				iconCls:'icon-write-order',
				text:'修改',
				handler:function(){
					var row=inquiryItemBoxObj.getSelected();
					if(row)
					{
						UpdateInquiryItemHandler(row);
					}else{
						$.messager.alert("提示","请选择要修改的行！", "error");
					}
				}
			},
			{
				iconCls:'icon-cancel',
				text:'删除',
				handler:function(){
					var row=inquiryItemBoxObj.getSelected();
					if(row)
					{
						$.messager.confirm("确认","确认删除？",function(r){
							if(r)
							{
								$.m({
									ClassName:"web.DHCBPCInquiry",
									MethodName:"DeleteInquiryitem",
									Rowid:row.TRowid,
								},function(result){
									if(result==0){
										inquiryItemBoxObj.load();
									}
									else{
										$.messager.alert("提示","删除失败！错误代码："+result);
									}
								})
							}
						})
					}else{
						$.messager.alert("提示","请选择要删除的行！", "error");
					}
				}
			}
		]
	});

	
})