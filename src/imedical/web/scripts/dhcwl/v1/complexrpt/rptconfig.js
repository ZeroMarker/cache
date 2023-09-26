/**
* Creator   : wk
* CreatDate : 2018-09-07
* Desc      : 维护报表信息 
**/

//获取屏幕高度
var kpiBodyHeight = getViewportOffset().y;
var ON_EDIT_FILTERROW = "-1";

var FILTER_ERROR_INFOR = "过滤规则配置失败"; 

//获取表格数据
var rptObj = $HUI.datagrid("#rptGrid",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.ComplexRpt.ComplexRptFun',
		QueryName:'GetRptTable'
	},
	fitColumns:true,
	toolbar:'#rptToobar',
	pagination:true, //允许用户通过翻页导航数据
	pageSize:15,  //设置首次界面展示时每页加载条数
	pageList:[10,15,20,50,100] //设置分页可选展示条数
})

/*--报表新增--*/
$("#addButton").click(function(e){
	$("#addInforForm").form('reset');    ///内容重置
	$("#addDialog").show();
	$HUI.dialog("#addDialog",{
		iconCls:'icon-w-add',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#addInforForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var code,name,desc,type,remark;
				code = $("#code").val();
				name = $("#name").val();
				desc = $("#desc").val();
				type = $("#type").val();
				remark = $("#remark").val();
				
				$m({
					ClassName:'web.DHCWL.V1.ComplexRpt.ComplexRptFun',
					MethodName:'AddRpt',
					code:code,
					name:name,
					desc:desc,
					fl:type,
					remark:remark
				},function(text){
					myMsg(text);
					$("#rptGrid").datagrid("reload");
					$HUI.dialog("#addDialog").close();
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#addDialog").close();
			}
		}]
	})
})

/*--报表修改--*/
$("#modifyButton").click(function(e){
	$("#modifyInforForm").form('reset');    ///内容重置
	var row = $("#rptGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择需要修改的一条报表");
		return;
	}
	var rptID = row.ID;
	$("#modifyCode").val(row.code);
	$("#modifyName").val(row.name);
	$("#modifyDesc").val(row.desc);
	$("#modifyType").val(row.type);
	$("#modifyRemark").val(row.remark);
	 $("#modifyInforForm").form('validate');
	$("#modifyDialog").show();
	$HUI.dialog("#modifyDialog",{
		iconCls:'icon-w-edit',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#modifyInforForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var code,name,desc,type,remark;
				code = $("#modifyCode").val();
				name = $("#modifyName").val();
				desc = $("#modifyDesc").val();
				type = $("#modifyType").val();
				remark = $("#modifyRemark").val();
				$m({
					ClassName:'web.DHCWL.V1.ComplexRpt.ComplexRptFun',
					MethodName:'UpdateRpt',
					ID:rptID,
					code:code,
					name:name,
					desc:desc,
					type:type,
					remark:remark
				},function(text){
					myMsg(text);
					$("#rptGrid").datagrid("reload");
					$HUI.dialog("#modifyDialog").close();
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#modifyDialog").close();
			}
		}]
	})
})

/*--报表删除--*/
$("#deleteButton").click(function(e){
	var row = $("#rptGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择需要删除的一条报表");
		return;
	}
	var rptID = row.ID;
	$.messager.confirm("提示", "删除后将不能恢复,确认删除么?", function (r) {
		if (r) {
			$m({
				ClassName:'web.DHCWL.V1.ComplexRpt.ComplexRptFun',
				MethodName:'DeleteRpt',
				rptID:rptID
			},function(text){
				myMsg(text);
				$("#rptGrid").datagrid("reload");
			})
		}
	});
})

/*--生成指标数据--*/
$("#creatDateButton").click(function(e){
	var row = $("#rptGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条报表");
		return;
	}
	$('#startDate').datebox('setValue', '');
	$('#endDate').datebox('setValue', '');
	var rptCode = row.code;
	$HUI.datagrid("#kpiListTable",{
		url:$URL,
		queryParams:{
			ClassName:'DHCWL.ComplexRptData.RptService',
			QueryName:'QueryRptlinkKpi',
			rpt:rptCode
		},
		fitColumns:true,
		toolbar:"#createDataToobar"
	})
	$("#rptCreatDateDialog").show();
	$HUI.dialog("#rptCreatDateDialog",{
		iconCls:'icon-w-config',
		height:400,
		resizable:true,
		modal:true
	})
})
/*--点击确定生成数据的按钮--*/
$("#defineData").click(function(e){
	var rows = $("#kpiListTable").datagrid("getChecked");
	var len = rows.length;
	if (len < 1){
		myMsg("请先选择需要生成数据的指标");
		return;
	}
	var kpiCodes = "";
	for (var i = 0;i < len;i++){
		if (kpiCodes == ""){
			kpiCodes = rows[i].kpiCode;
		}else{
			kpiCodes = kpiCodes + "," + rows[i].kpiCode;
		}
	}
	var startDate = $('#startDate').datebox('getValue');
	var endDate = $('#endDate').datebox('getValue');
	if ((startDate == "")||(endDate == "")){
		myMsg("请先选择生成数据的日期");
		return;
	}
	$m({
		ClassName:'web.DHCWL.V1.ComplexRpt.ComplexRptFun',
		MethodName:'CreatRptKpiData',
		kpis:kpiCodes,
		startDate:startDate,
		endDate:endDate
	},function(e){
		myMsg(e);
		$HUI.dialog("#rptCreatDateDialog").close();
	})
})



/*--预览报表数据--*/
$("#viewDateButton").click(function(e){
	$("#startDateForView").datebox('setValue',"");
	$("#endDateForView").datebox('setValue',"");
	var row = $("#rptGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条报表记录");
		return;
	}
	$HUI.datagrid("#rptDataGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.ComplexRpt.ComplexRptFun',
			QueryName:'QueryReportData',
			rpt:"",
			startDate:"",
			endDate:""
		},
		fitColumns:true,
		pagination:true, //允许用户通过翻页导航数据
		pageSize:15,  //设置首次界面展示时每页加载条数
		pageList:[10,15,20,50,100], //设置分页可选展示条数
		toolbar:"#viewDataToobar"
	})
	$("#viewRptDataDialog").show();
	$HUI.dialog("#viewRptDataDialog",{
		iconCls:'icon-w-paper',
		resizable:true,
		modal:true
	})
})

/*--点击查询按钮--*/
$("#searchDataButton").click(function(e){
	var row = $("#rptGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条报表记录");
		return;
	}
	var rptCode = row.code;
	var startDate = $("#startDateForView").datebox('getValue');
	var endDate = $("#endDateForView").datebox('getValue');
	if ((startDate == "")||(endDate == "")){
		myMsg("请先填写开始、结束日期");
		return;
	}
	$("#rptDataGrid").datagrid("load",{ClassName:'web.DHCWL.V1.ComplexRpt.ComplexRptFun',QueryName:'QueryReportData',rpt:rptCode,startDate:startDate,endDate:endDate})
	
})

/*--报表维度关联--*/
$("#kpiCfgButton").click(function(e){
	var row = $("#rptGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条记录");
		return;
	}
	var rptCode = row.code;
	var rptID = row.ID;
	$HUI.propertygrid("#allKPIGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.ComplexRpt.ComplexRptFun',
			QueryName:"GetAllKPI",
			rptCode:rptCode
		},
		columns:[[
			{field:'ID',title:'ID',width:100,align:'left',hidden:true},
			{field:'name',title:'指标编码',width:100,align:'left'},
			{field:'value',title:'指标名称',width:150,align:'left'},
			{field:'dim',title:'维度',width:150,align:'left',hidden:true}
			
		]],
		showGroup:true,
		fitColumns:true
	})
	$HUI.datagrid("#selectedKPIGrid",{
		url:$URL,
		queryParams:{
			ClassName:'DHCWL.ComplexRptData.RptLinkKpiService',
			QueryName:'GetRptLinkKpi',
			rptDr:rptID
		},
		fitColumns:true
	})
	$("#rptAndKPIDig").show();
	$HUI.dialog("#rptAndKPIDig",{
		iconCls:'icon-w-add',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var selectedObj = $("#selectedKPIGrid").datagrid("getRows");
				var len = selectedObj.length;
				var IDs = ""
				for (var i = 0;i < len;i++){
					if (IDs == ""){
						IDs = selectedObj[i].rKpi;
					}else{
						IDs = IDs + "," +selectedObj[i].rKpi;
					}
				}
				$m({
					ClassName:'DHCWL.ComplexRptData.RptLinkKpiService',
					MethodName:'SaveLinkRptKpi',
					kpiPoolDr:IDs,
					rptId:rptID
				},function(e){
					myMsg("保存成功");
					$HUI.dialog("#rptAndKPIDig").close();
					$("#selectedKPIGrid").datagrid('reload');
					//$HUI.dialog("#rptAndKPIDig").close();
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#rptAndKPIDig").close();
			}
		}]
	})
})


/*--报表配置--*/
$("#rptCfgButton").click(function(e){
	var row = $("#rptGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条维护记录");
		return;
	}
	var rptID = row.ID;
	var rptCode = row.code;
	
	//行表格加载
	$HUI.datagrid("#rowGrid",{
		url:$URL,
		queryParams:{
			ClassName:'DHCWL.ComplexRptData.ReportCfg',
			QueryName:'RptCfgQuery',
			rptCode:rptCode,
			CondType:'Row'
		},
		fitColumns:true,
		onDblClickRow:function(index,row){
			$("#rowGrid").datagrid("deleteRow",index);
		}
	})
	
	//列表格加载
	$HUI.datagrid("#colGrid",{
		url:$URL,
		queryParams:{
			ClassName:'DHCWL.ComplexRptData.ReportCfg',
			QueryName:'RptCfgQuery',
			rptCode:rptCode,
			CondType:'Col'
		},
		fitColumns:true,
		onDblClickRow:function(index,row){
			$("#colGrid").datagrid("deleteRow",index);
		}
	})
	
	/*--统计内容表格--*/
	$HUI.datagrid("#statGrid",{
		url:$URL,
		queryParams:{
			ClassName:'DHCWL.ComplexRptData.ReportCfg',
			QueryName:'RptContentQuery',
			rptCode:rptCode,
			CondType:'Content'
		},
		fitColumns:true,
		onDblClickRow:function(index,row){
			$("#statGrid").datagrid("deleteRow",index);
		}
	})
	
	/*--下拉框数据获取--*/
	$m({
		ClassName:'web.DHCWL.V1.ComplexRpt.ComplexRptFun',
		MethodName:'GetRptCfgMode',
		rptCode:rptCode
	},function(text){
		$("#rptModeCombo").combobox('setValue',text);
	})
	
	/*--报表统计模式下拉框数据获取--*/
	var statModeObj = $HUI.combobox("#rptModeCombo",{
		url:$URL+"?ClassName=web.DHCWL.V1.ComplexRpt.ComplexRptFun&QueryName=GetStatModel&ResultSetType=array",
		valueField:'modeCode',
		textField:'modeDesc'
	});
	
	
	/*--过滤规则表格数据加载--*/
	$("#rptFilterGrid").datagrid('load',{ClassName:'web.DHCWL.V1.ComplexRpt.ComplexRptFun',QueryName:'GetRptFilter',rptCode:rptCode});
	
	//加载树
	$('#dimObjTree').tree({			
		url: $URL+"?ClassName=web.DHCWL.V1.ComplexRpt.ComplexRptFun&QueryName=GetContentAndItem&rows=10000&page=1",
		loadFilter: function(rows){
			return convert(rows.rows);
		},
		onLoadSuccess:function(node, data){
			$('#dimObjTree').tree('collapseAll');
		},
		onDblClick:function(node){
			$("#filterInforForm").form('reset');
			//判断点击的是统计项还是统计内容
			var parentTypeNode = $('#dimObjTree').tree('getParent',node.target);
			if (!parentTypeNode){
				return;
			}
			if (parentTypeNode.id == 1){   //点击统计内容时
				//alert("text");  
				var ID = node.id;
				var newText = node.text;
				newText = newText.split(":")[1];
				var arr = ID.split(".");
				var len = arr.length;
				//选中统计内容表格页签时
				if (len == 1){
					//获取选中的页签
					var tab = $('#rptcfgTab').tabs('getSelected');
					var index = $('#rptcfgTab').tabs('getTabIndex',tab);
				
					//选中行表格页签时
					if (index == 2){
						var rows = $("#statGrid").datagrid('getRows');
						var len = rows.length;
						for (var i = 0;i < len;i++){
							if (rows[i].statCode == ID){
								return;
							}
						}
						$('#statGrid').datagrid('insertRow',{
							row: {
								statCode: ID,
								statDesc: newText
							}
						});
					}
				}
			}else{				   //点击统计项时
				var ID = node.id;
				var textValue = node.text;
				textValue = textValue.split(":")[1];
				var arr = ID.split(".");
				var len = arr.length;
				var ignoreFlag = 0;
				//var flag = 1,mainItem = "",lastItem = "";
				if (len == 1){
					$('#dimObjTree').tree('expand', node.target);
					//mainItem = node.ID;
					ignoreFlag = 1;
					//return;
				}
				if (len > 1){
					var parentNode,parentText,parentTextValue,textValue,newText;
					parentNode = $('#dimObjTree').tree('getParent',node.target);
					parentText = parentNode.text;
					parentTextValue = parentText.split(":")[1];
					var dimArr = ID.split("(");
					var dimLen = dimArr.length;
					if(dimLen > 1){
						var dimNode,dimText,dimTextValue;
						dimNode = $('#dimObjTree').tree('getParent',parentNode.target);
						dimText = dimNode.text;
						dimTextValue = dimText.split(":")[1];
						newText = dimTextValue + "." + parentTextValue + "(" + textValue + ")";
					}else{
						newText = parentTextValue + "." + textValue;
					}
				}
				
				//获取选中的页签
				var tab = $('#rptcfgTab').tabs('getSelected');
				var index = $('#rptcfgTab').tabs('getTabIndex',tab);
				
				//选中行表格页签时
				if ((index == 0)&&(!ignoreFlag)){
					var rows = $("#rowGrid").datagrid('getRows');
					var len = rows.length;
					for (var i = 0;i < len;i++){
						if (rows[i].statItemCode == ID){
							return;
						}
					}
					$('#rowGrid').datagrid('insertRow',{
						row: {
							statItemCode: ID,
							statItemDesc: newText
						}
					});
				}
				
				//选中列表格页签时
				if ((index == 1)&&(!ignoreFlag)){
					var rows = $("#colGrid").datagrid('getRows');
					var len = rows.length;
					for (var i = 0;i < len;i++){
						if (rows[i].statItemCode == ID){
							return;
						}
					}
					$('#colGrid').datagrid('insertRow',{
						row: {
							statItemCode: ID,
							statItemDesc: newText
						}
					});
				}
				
				//选中过滤页签时
				if (index == 3){
					var ID = node.id;
					var dimArr = ID.split("(");
					var dimLen = dimArr.length;
					var className="",queryName="";
					if (dimLen > 1){
						className = "web.DHCWL.V1.ComplexRpt.ComplexRptFun";
						queryName = "GetSubGrpListByCode";
					}else{
						className = "web.DHCWL.V1.ComplexRpt.ComplexRptFun";
						queryName = "GetDimProValueName"; 
					}
					
					var filterFunObj = $HUI.combogrid("#filterFun",{
						panelWidth:420,
						url:$URL+"?ClassName=web.DHCWL.V1.KPI.KPIFunction&QueryName=GetFilterFunQuery",
						mode:'remote',
						delay:200,
						idField:'FilterFuncCode',
						textField:'FilterFuncCode',
						onBeforeLoad:function(param){
							param.kpiCode = param.q;
						},
						columns:[[
							{field:'FilterFuncCode',title:'函数编码',width:100},
							{field:'Desc',title:'函数描述',width:100}
						]],
						fitColumns:true,
						pagination:true,
						pageSize:15,
						pageList:[10,15,20,50,100],
						onBeforeLoad:function(data){
							var g = $('#filterFun').combogrid('grid');	// get datagrid object
							var r = g.datagrid('loadData',{total:0,rows:[]});	// get the selected row
							$('#filterFun').combogrid('setValue',"");
						}
					});
					
					var filterValueObj = $HUI.combogrid("#filterValue",{
						panelWidth:420,
						url:$URL+"?ClassName=" + className + "&QueryName=" + queryName + "&grpCode=" + ID,
						mode:'remote',
						delay:200,
						idField:'dimValue',
						textField:'dimProValue',
						onBeforeLoad:function(param){
							param.filterStr = param.q;
						},
						columns:[[
							{field:'dimValue',title:'编码',width:100},
							{field:'dimProValue',title:'名称',width:100}
						]],
						fitColumns:true,
						pagination:true,
						showPageList:false,
						pageSize:15,
						pageList:[10,15,20,50,100]/*,
						onBeforeLoad:function(data){
							$('#filterValue').combogrid('setValue',"");
							var g = $('#filterValue').combogrid('grid');	// get datagrid object
							var r = g.datagrid('loadData',{total:0,rows:[]});	// get the selected row
						}*/
					});
					
					/*$('#filterValue').combogrid('clear',"");
					var g = $('#filterValue').combogrid('grid');	// get datagrid object
					var r = g.datagrid('loadData',{total:0,rows:[]});	// get the selected row
					g.datagrid("reload");*/
					
					var rows = $("#rptFilterGrid").datagrid("getRows");
					if (rows.length > 0){
						$("#operatorList").combobox('setValue',"&&");
						$("#operatorList").combobox("enable");
					}else{
						$("#operatorList").combobox('setValue',"");
						$("#operatorList").combobox("disable");
					}
					$("#filterDialog").show();
					$HUI.dialog("#filterDialog",{
						iconCls:'icon-w-add',
						resizable:true,
						modal:true,
						buttons:[{
							text:'确定',
							handler:function(e){
								var flag = $("#filterInforForm").form('validate');
								if (!flag){
									myMsg("请按照提示填写内容");
									return;
								}
								var operatorValue = $("#operatorList").combobox('getValue');
								var filterFun = $("#filterFun").combobox('getValue');
								var value = $("#filterValue").combobox('getText');
								$('#rptFilterGrid').datagrid('insertRow',{
									row: {
										calSymbol: operatorValue,
										dimRule: ID,
										filterFun: filterFun,
										filterValue:value,
										calSymboxRight:''
									}
								});
								$HUI.dialog("#filterDialog").close();
							}
						},{
							text:'取消',
							handler:function(e){
								$HUI.dialog("#filterDialog").close();
							}
						}]
					})
				}
			}
		}
	});
	
	$("#rptCfgDig").show();
	$HUI.dialog("#rptCfgDig",{
		height:kpiBodyHeight-20,
		iconCls:'icon-w-config',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				if (ON_EDIT_FILTERROW != -1){
					$('#rptFilterGrid').datagrid('endEdit', ON_EDIT_FILTERROW);
					ON_EDIT_FILTERROW = "-1";
				}
				var rptMode = $("#rptModeCombo").combobox("getValue");
				var rptFilter = changeFilterTableToRule();
				if (rptFilter == -1){
					myMsg(FILTER_ERROR_INFOR);
					return;
				}
				var rptCode = rptCode;
				var rptContext = getStatGridCodes();
				if (!rptContext){
					myMsg("统计内容不能为空");
					return;
				}
				var rptRow = getRowGridCodes();
				var rptCol = getColGridCodes();
				if ((!rptRow)&&(!rptCol)){
					myMsg("行配置和列配置至少有一个不为空");
					return;
				}
				var row = $("#rptGrid").datagrid("getSelected");
				if (!row){
					myMsg("请先选择一条报表记录");
					return;
				}
				var rptCode = row.code;
				if (!rptMode){
					myMsg("保存时统计模式下拉框不能为空");
					return;
				}
				//alert(rptMode + "^" +rptFilter + "^" +rptCode + "^" +rptContext + "^" +rptRow + "^" +rptCol);
				$m({
					ClassName:'web.DHCWL.V1.ComplexRpt.ComplexRptFun',
					MethodName:'AddRptCfg',
					rptMode:rptMode,
					rptContext:rptContext,
					rptRow:rptRow,
					rptCol:rptCol,
					rptFilter:rptFilter,
					rptCode:rptCode
				},function(text){
					myMsg(text);
					$HUI.dialog("#rptCfgDig").close();
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#rptCfgDig").close();
			}
		}]
	})
})


$('#rptcfgPanle').panel({
	height:kpiBodyHeight-143,
	width:310
})

/*--报表查询--*/
$('#searchText').searchbox({
	searcher:function(value,name){
		rptObj.load({ClassName:"web.DHCWL.V1.ComplexRpt.ComplexRptFun",QueryName:"GetRptTable",filterValue:value});
	}
})


/*--鼠标悬停备注单元格响应方法--*/
 function formatCellTooltip(value){  
	return "<span id='verylongText' title='" + value + "'>" + value + "</span>";  
}

/*--点击左移按钮--*/
$("#moveRight").click(function(e){
	var row = $("#allKPIGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条待维护的记录");
		return;
	}
	var ID,name,value,dim,group;
	ID = row.ID;
	name = row.name;
	value = row.value;
	dim = row.dim;
	group = row.group;
	var arr = group.split(":");
	var groupDesc = arr[1];
	var rows = $("#selectedKPIGrid").datagrid("getRows");
	var len = rows.length;
	if (len > 0){
		for(var i = 0;i < len;i++){
			desc = rows[i].rKpiType;
			if (desc == groupDesc){
				myMsg("同类型指标只能关联一个！");
				return;
			}
		}
	}
	$('#selectedKPIGrid').datagrid('insertRow',{
		row: {
			rKpiType: groupDesc,
			rKpiCode: dim,
			rKpiName: name,
			rKpi:ID
		}
	});
})
/*--点击左移按钮--*/
$("#moveLeft").click(function(e){
	var row = $("#selectedKPIGrid").datagrid("getSelected");
	if (!row){
		myMsg("请选择一条已维护的记录");
		return;
	}
	var index = $("#selectedKPIGrid").datagrid("getRowIndex",row);
	$("#selectedKPIGrid").datagrid("deleteRow",index);
})

/*--左右图片提示--*/
/*$HUI.tooltip('#moveRight',{
	content:'<span>移入</span>',
	position:'bottom'
})
$HUI.tooltip('#moveLeft',{
	content:'<span">移出</span>',
	position:'bottom'
})*/



/*--报表配置--*/


/*--报表过滤--*/
var filterObj = $HUI.datagrid("#rptFilterGrid",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.ComplexRpt.ComplexRptFun',
		GetRptFilter:'GetRptFilter',
		rptCode:""
	},
	fitColumns:true,
	onDblClickCell:function(rowIndex, field, value){
		if (ON_EDIT_FILTERROW == rowIndex){
			$('#rptFilterGrid').datagrid('endEdit', rowIndex);
			ON_EDIT_FILTERROW = "-1";
		}else if(ON_EDIT_FILTERROW != "-1"){
			$('#rptFilterGrid').datagrid('endEdit', ON_EDIT_FILTERROW);
			$('#rptFilterGrid').datagrid('beginEdit', rowIndex);
			ON_EDIT_FILTERROW = rowIndex;
		}else{
			$('#rptFilterGrid').datagrid('beginEdit', rowIndex);
			ON_EDIT_FILTERROW = rowIndex;
		}
	},
	toolbar:[{
		text:'[]',
		iconCls:'icon-add',
		handler:function(e){
			addFilterSym();
		}
	},{
		text:'!',
		iconCls:'icon-add',
		handler:function(e){
			addNoSymbol();
		}
	},{
		text:'预览过滤规则',
		iconCls:'icon-funnel-eye',
		handler:function(e){
			if (ON_EDIT_FILTERROW != -1){
				$('#rptFilterGrid').datagrid('endEdit', ON_EDIT_FILTERROW);
				ON_EDIT_FILTERROW = "-1";
			}
			var rule = changeFilterTableToRule();
			if (rule == -1){
				myMsg(FILTER_ERROR_INFOR);
				return;
			}
			$("#filterShowTextbox").val(rule);
			$("#filterShowDialog").show();
			$HUI.dialog("#filterShowDialog",{
				iconCls:'icon-w-list',
				resizable:true,
				modal:true
			})
		}
	},{
		text:'清空',
		iconCls:'icon-remove',
		handler:function(e){
			$('#rptFilterGrid').datagrid('loadData',{total:0,rows:[]});
		}
	}]
})


/*--过滤函数加!符号--*/
function addNoSymbol(){
	var row = $("#rptFilterGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择维护的表达式");
		return;
	}
	var rows = $("#rptFilterGrid").datagrid("getSelections");
	if (rows.length > 1){
		myMsg("只能选择一条记录进行维护");
		return;
	}
	var index = $("#rptFilterGrid").datagrid("getRowIndex",row);
	var operator = row.calSymbol;         //为开始结束记录添加!
	var reg = /[&|]/;
	if(reg.test(operator)){
		var calLeftStr = operator.substr(0,2);
		if ((calLeftStr == "&&")||(calLeftStr == "||")){
			var otherStr = operator.substr(2);
			var operator = calLeftStr + "!" + otherStr;
		}
	}else{
		operator = "!" + operator;
	}
	$("#rptFilterGrid").datagrid("updateRow",{   //将开始记录
		index:index,
		row:{
			calSymbol:operator
		}
	})

}

/*--过滤函数[]按钮--*/
function addFilterSym(){
	var rows = $("#rptFilterGrid").datagrid("getSelections");
	var len = rows.length;
	if (!len){
		myMsg("请先选中需要维护[]的表达式");
		return;
	}else{
		var operator,rightBracket;
		
		var start = $("#rptFilterGrid").datagrid("getRowIndex",rows[0]);
		var end = $("#rptFilterGrid").datagrid("getRowIndex",rows[len-1]);
		if ((end - start + 1) != len){
			myMsg("只能选择连续的数据");
			return;
		}
		var operator = rows[0].calSymbol;         //为开始结束记录添加[]
		var rightBracket = rows[len-1].calSymboxRight;
		var reg = /[&|]/;
		if(reg.test(operator)){
			var calLeftStr = operator.substr(0,2);
			if ((calLeftStr == "&&")||(calLeftStr == "||")){
				var otherStr = operator.substr(2);
				var operator = calLeftStr + "[" + otherStr;
			}
		}else{
			operator = "[" + operator;
		}
		$("#rptFilterGrid").datagrid("updateRow",{   //将开始记录加[
			index:start,
			row:{
				calSymbol:operator
			}
		})
		$("#rptFilterGrid").datagrid("updateRow",{   //将结束记录加]
			index:end,
			row:{
				calSymboxRight:rightBracket+"]"
			}
		})
	}
}

/*--行表格编码获取--*/
function getRowGridCodes(){
	var rows = $("#rowGrid").datagrid("getRows");
	var len = rows.length,str;
	for (var i = 0;i < len;i++){
		if (str){
			str = str + "," + rows[i].statItemCode;
		}else{
			str = rows[i].statItemCode;
		}
	}
	return str;
}

/*--列表格编码获取--*/
function getColGridCodes(){
	var rows = $("#colGrid").datagrid("getRows");
	var len = rows.length,str;
	for (var i = 0;i < len;i++){
		if (str){
			str = str + "," + rows[i].statItemCode;
		}else{
			str = rows[i].statItemCode;
		}
	}
	return str;
}

/*--统计内容表格编码获取--*/
function getStatGridCodes(){
	var rows = $("#statGrid").datagrid("getRows");
	var len = rows.length,str;
	for (var i = 0;i < len;i++){
		if (str){
			str = str + "," + rows[i].statCode;
		}else{
			str = rows[i].statCode;
		}
	}
	return str;
}


/*--将过滤规则的表格形式转换成表达式的形式--*/
function changeFilterTableToRule(){
	var rows = $("#rptFilterGrid").datagrid("getRows");
	var len = rows.length;
	var operator,dimRule,filterFun,value,rightBracket,kpiFilterRule;
	var filterObj = {};
	var leftReg = /[^[!&|]/g;
	var rightReg = /[^\]]/g;
	for (var i = 0;i < len;i++){
		operator = rows[i].calSymbol;
		dimRule = rows[i].dimRule;
		filterFun = rows[i].filterFun;
		value = rows[i].filterValue;
		rightBracket = rows[i].calSymboxRight;
		if (leftReg.test(operator)){
			FILTER_ERROR_INFOR = "左运算符只能包含||、&&、！、[";
			return -1;
		}
		if (rightReg.test(rightBracket)){
			FILTER_ERROR_INFOR = "右运算符只能包含]";
			return -1;
		}
		var operatorValue = "";
		if (operator){
			operatorValue = " " + operator;
		}
		if (kpiFilterRule){
			if ((operator.indexOf ("&&") > -1) || (operator.indexOf ("||") > -1)){
			}else{
				//myMsg("过滤规则配置有误");
				FILTER_ERROR_INFOR = "非第一条过滤规则都必须有&&、||";
				return -1;
			}
		}else{
			if ((operator.indexOf ("&&") > -1) || (operator.indexOf ("||") > -1)){
				//myMsg("过滤规则配置有误");
				FILTER_ERROR_INFOR = "第一条过滤规则不能包含&&、||";
				return -1;
			}
		}
		if (kpiFilterRule){
			kpiFilterRule =kpiFilterRule + operator + "[{" + dimRule + "} " + filterFun + " " + value + "]" + rightBracket;
		}else{
			kpiFilterRule = operator + "[{" + dimRule + "} " + filterFun + " " + value + "]" + rightBracket;
		}
	}
	return kpiFilterRule;
}



function convert(rows){
	function exists(rows, parentId){
		for(var i=0; i<rows.length; i++){
			if (rows[i].id == parentId) return true;
		}
		return false;
	}
	
	var nodes = [];
	// get the top level nodes
	for(var i=0; i<rows.length; i++){
		var row = rows[i];
		if (!exists(rows, row.parentId)){
			nodes.push({
				id:row.id,
				text:row.name
			});
		}
	}
	
	var toDo = [];
	for(var i=0; i<nodes.length; i++){
		toDo.push(nodes[i]);
	}
	while(toDo.length){
		var node = toDo.shift();	// the parent node
		// get the children nodes
		for(var i=0; i<rows.length; i++){
			var row = rows[i];
			if (row.parentId == node.id){
				var child = {id:row.id,text:row.name};
				if (node.children){
					node.children.push(child);
				} else {
					node.children = [child];
				}
				toDo.push(child);
			}
		}
	}
	return nodes;
}