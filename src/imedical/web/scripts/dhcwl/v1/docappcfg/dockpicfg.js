
var kpiBodyHeight = getViewportOffset().y-40;
var ON_EDIT_FILTERROW = "-1";

var docObj = $HUI.datagrid("#docTable",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.DocAppCfg.DocKpiCfg',
		QueryName:'GetDocCfg'
	},
	fitColumns:true,
	toolbar:"#docToobar",
	pagination:true, //允许用户通过翻页导航数据
	pageSize:15,  //设置首次界面展示时每页加载条数
	pageList:[10,15,20,50,100], //设置分页可选展示条数
	onClickRow:function(rowIndex, rowData){
		var ID = rowData.ID;
		var flag = rowData.category;
		if (flag == "普通指标"){
			$('#calKPICfgButton').linkbutton('disable');
			$('#filterCfgButton').linkbutton('enable');
			$('#docAppKPIAdd').linkbutton('enable');
		}else{
			$('#docAppKPIAdd').linkbutton('disable');
			$('#filterCfgButton').linkbutton('disable');
			$('#calKPICfgButton').linkbutton('enable');
		}
		$("#kpiTable").datagrid("load",{ClassName:'web.DHCWL.V1.DocAppCfg.DocKpiCfg',QueryName:'GetDocKPI',docID:ID});
	},
	onLoadSuccess:function(data){
		$("#kpiTable").datagrid("loadData",{total:0,rows:[]});
		$('#calKPICfgButton').linkbutton('disable');
	}
})


/*--医生应用关联指标维护--*/
var kpiObj = $HUI.datagrid("#kpiTable",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.DocAppCfg.DocKpiCfg',
		QueryName:'GetDocKPI'
	},
	fitColumns:true,
	pagination:true, //允许用户通过翻页导航数据
	pageSize:15,  //设置首次界面展示时每页加载条数
	pageList:[10,15,20,50,100], //设置分页可选展示条数
	toolbar:[{
		text:'新增',
		iconCls:'icon-add',
		id:'docAppKPIAdd',
		handler:function(e){
			var docRow = $("#docTable").datagrid("getSelected");
			if(!docRow){
				myMsg("请先选择需要维护的医生应用记录");
				return;
			}
			$('#kpiSearch').searchbox('setValue', '');
			$HUI.datagrid("#kpiGrid",{
				url:$URL,
				queryParams:{
					ClassName:'web.DHCWL.V1.DocAppCfg.DocKpiCfg',
					QueryName:'GetKPI',
				},
				fitColumns:true,
				pagination:true, //允许用户通过翻页导航数据
				pageSize:15,  //设置首次界面展示时每页加载条数
				pageList:[10,15,20,50,100], //设置分页可选展示条数
				toolbar:"#grpAddToolbar"
			});
			
			
			$("#kpiAdddialog").show();
			$HUI.dialog("#kpiAdddialog",{
				height:kpiBodyHeight,
				iconCls:'icon-w-add',
				resizable:true,
				modal:true
			});
		}
	},{
		text:'删除',
		iconCls:'icon-cancel',
		handler:function(e){
			var kpiRow = $("#kpiTable").datagrid("getSelected");
			if (!kpiRow){
				myMsg("请先选择需要删除的指标记录");
				return;
			}
			
			$.messager.confirm("提示", "删除后将不能恢复,确认删除么？", function (r) {
				if (r) {
					var kpiID = kpiRow.ID;
					$m({
						ClassName:'DHCWL.DocQueryData.SaveData',
						MethodName:'DelDocAppRel',
						id:kpiID
					},function(text){
						if (text == "ok"){
							$("#kpiTable").datagrid("reload");
							myMsg("删除成功");
						}else{
							myMsg(text);
						}
					})
				}
			});
		}
	},{
		text:'过滤规则配置',
		id:'filterCfgButton',
		iconCls:'icon-batch-cfg',
		handler:function(e){
			var kpiObj = $("#kpiTable").datagrid("getSelected");
			if (!kpiObj){
				myMsg("请先选择一条指标");
				return;
			}
			var kpiCode = kpiObj.kpiCode;
			var kpiID = kpiObj.ID;
			//加载树
			$('#dimObjTree').tree({
				title:'待选树',
				url: $URL+"?ClassName=web.DHCWL.V1.DocAppCfg.DocKpiCfg&QueryName=GetKPITree&kpiCode=" + kpiCode + "&rows=10000&page=1",
				loadFilter: function(rows){
					return convert(rows.rows);
				},
				onLoadSuccess:function(node, data){
					$('#dimObjTree').tree('collapseAll');
				},
				onDblClick:function(node){
					$("#filterInforForm").form('reset');
					var nodeID = node.id;
					var parentNode = $("#dimObjTree").tree("getParent",node.target);
					var dimRule = "";
					if (parentNode){
						var dimCode = parentNode.id;
						var dimProCode = node.id;
						dimRule = dimCode + "." + dimProCode;
					}else{
						var dimCode = node.id;
						var dimProCode = "";
						dimRule = dimCode;
					}
					//alert(kpiCode+"^"+dimCode+"^"+dimProCode);
					//console.log(parentNode);
					//return;
					
					var filterValueObj = $HUI.combogrid("#filterValue",{
						panelWidth:420,
						url:$URL+"?ClassName=web.DHCWL.V1.DocAppCfg.DocKpiCfg&QueryName=GetDimValue&kpiCode=" + kpiCode + "&kpiDimCode=" + dimCode + "&dimProCode=" + dimProCode,
						mode:'remote',
						delay:500,
						idField:'dimValue',
						textField:'dimProValue',
						onBeforeLoad:function(param){
							param.filterValue = param.q;
						},
						columns:[[
							{field:'dimValue',title:'编码',width:100},
							{field:'dimProValue',title:'名称',width:100}
						]],
						fitColumns:true,
						pagination:true,
						pageSize:15,
						pageList:[10,15,20,50,100],
						showPageList:false/*,
						onBeforeLoad:function(data){
							$('#filterValue').combogrid('setValue',"");
							var g = $('#filterValue').combogrid('grid');	// get datagrid object
							var r = g.datagrid('loadData',{total:0,rows:[]});	// get the selected row
						}*/
					});
					/*--下拉数据清空--*/
					//$('#filterValue').combogrid('reset');
					/*$('#filterValue').val("");
					var g = $('#filterValue').combogrid('grid');	// get datagrid object
					var r = g.datagrid('loadData',{total:0,rows:[]});	// get the selected row
					g.datagrid("reload");*/
					
					
					var rows = $("#kpiFilterGrid").datagrid("getRows");
					if (rows.length > 0){
						$("#operatorList").combobox('setValue',"&&");
						$("#operatorList").combobox("enable");
					}else{
						$("#operatorList").combobox('setValue',"");
						$("#operatorList").combobox("disable");
					}
					
					$("#filterDialog").show();
					$HUI.dialog("#filterDialog",{
						iconCls:'icon-w-new',
						resizable:true,
						modal:true,
						buttons:[{
							text:'保存',
							handler:function(text){
								var flag = $("#filterInforForm").form('validate');
								if (!flag){
									myMsg("请按照提示填写内容");
									return;
								}
								var operatorValue = $("#operatorList").combobox('getValue');
								var filterFun = $("#filterFun").combobox('getValue');
								var value = $("#filterValue").combobox('getText');
								$('#kpiFilterGrid').datagrid('insertRow',{
									row: {
										calSymbol: operatorValue,
										dimRule: dimRule,
										filterFun: filterFun,
										filterValue:value,
										calSymboxRight:''
									}
								});
								$HUI.dialog("#filterDialog").close();
							}
						},{
							text:'关闭',
							handler:function(text){
								$HUI.dialog("#filterDialog").close();
							}
						}]
					})
				}
			})
			
			$HUI.datagrid("#kpiFilterGrid",{
				url:$URL,
				queryParams:{
					ClassName:'web.DHCWL.V1.DocAppCfg.DocKpiCfg',
					QueryName:'GetDocAppFilter',
					realKPIID:kpiID
				},
				fitColumns:true,
				onDblClickCell:function(rowIndex, field, value){
					if (ON_EDIT_FILTERROW == rowIndex){
						$('#kpiFilterGrid').datagrid('endEdit', rowIndex);
						ON_EDIT_FILTERROW = "-1";
					}else if(ON_EDIT_FILTERROW != "-1"){
						$('#kpiFilterGrid').datagrid('endEdit', ON_EDIT_FILTERROW);
						$('#kpiFilterGrid').datagrid('beginEdit', rowIndex);
						ON_EDIT_FILTERROW = rowIndex;
					}else{
						$('#kpiFilterGrid').datagrid('beginEdit', rowIndex);
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
						var rule = changeFilterTableToRule();
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
						$('#kpiFilterGrid').datagrid('loadData',{total:0,rows:[]});
					}
				}]
			})
			
			/*--下拉过滤函数--*/
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
				pageList:[10,15,20,50,100]/*,
				onBeforeLoad:function(data){
					var g = $('#filterFun').combogrid('grid');	// get datagrid object
					var r = g.datagrid('loadData',{total:0,rows:[]});	// get the selected row
					$('#filterFun').combogrid('setValue',"");
				}*/
			});
			
			$("#kpiFilterCfgDig").show();
			$HUI.dialog("#kpiFilterCfgDig",{
				iconCls:'icon-w-batch-cfg',
				height:kpiBodyHeight,
				resizable:true,
				modal:true,
				buttons:[{
					text:'保存',
					handler:function(e){
						if(ON_EDIT_FILTERROW != "-1"){
							$('#kpiFilterGrid').datagrid('endEdit', ON_EDIT_FILTERROW);
							ON_EDIT_FILTERROW = -1;
						}
						var row = $("#docTable").datagrid("getSelected");
						var docID = row.ID;
						var rptFilter = changeFilterTableToRule();
						if (rptFilter == -1){
							myMsg(FILTER_ERROR_INFOR);
							return;
						}
						$m({
							ClassName:'web.DHCWL.V1.DocAppCfg.DocKpiCfg',
							MethodName:'SaveFilterRule',
							filterRule:rptFilter,
							docAppID:docID
						},function(text){
							myMsg(text);
							$("#kpiTable").datagrid('reload');
						})
						$HUI.dialog("#kpiFilterCfgDig").close();
					}
				},{
					text:'关闭',
					handler:function(e){
						$HUI.dialog("#kpiFilterCfgDig").close();
					}
				}]
			})
		}
	}]
})


/*--指标添加--*/
$("#kpiAddButton").click(function(e){
	var docRow,docId,docClass;
	docRow = $("#docTable").datagrid("getSelected");
	docId = docRow.ID;
	docClass = docRow.class;
	var kpiRow,kpiID,kpiCode;
	kpiRow = $("#kpiGrid").datagrid("getSelected");
	if (!kpiRow){
		myMsg("请先选择需要添加的指标");
		return;
	}
	kpiID = kpiRow.ID;
	kpiCode = kpiRow.kpiCode;
	$m({
		ClassName:'web.DHCWL.V1.DocAppCfg.DocKpiCfg',
		MethodName:'AddDocAppRel',
		MDocKPIDr:docId,
		MKPIdr:kpiCode,
		DocKpiDefClass:docClass,
		SkpiId:kpiID
	},function(text){
		myMsg(text);
		$("#kpiTable").datagrid("reload");
		$HUI.dialog("#kpiAdddialog").close();
	})
	//alert(docId+"^"+docClass+"^"+kpiID+"^"+kpiCode);
})

/*--指标新增弹出框检索--*/
$('#kpiSearch').searchbox({
	searcher:function(value,name){
		$("#kpiGrid").datagrid("load",{ClassName:'web.DHCWL.V1.DocAppCfg.DocKpiCfg',QueryName:'GetKPI',filterValue:value});
	}
})


/*--过滤函数加!符号--*/
function addNoSymbol(){
	var row = $("#kpiFilterGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择维护的表达式");
		return;
	}
	var rows = $("#kpiFilterGrid").datagrid("getSelections");
	if (rows.length > 1){
		myMsg("只能选择一条记录进行维护");
		return;
	}
	var index = $("#kpiFilterGrid").datagrid("getRowIndex",row);
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
	$("#kpiFilterGrid").datagrid("updateRow",{   //将开始记录
		index:index,
		row:{
			calSymbol:operator
		}
	})

}

/*--过滤函数[]按钮--*/
function addFilterSym(){
	var rows = $("#kpiFilterGrid").datagrid("getSelections");
	var len = rows.length;
	if (!len){
		myMsg("请先选中需要维护[]的表达式");
		return;
	}else{
		var operator,rightBracket;
		
		var start = $("#kpiFilterGrid").datagrid("getRowIndex",rows[0]);
		var end = $("#kpiFilterGrid").datagrid("getRowIndex",rows[len-1]);
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
		$("#kpiFilterGrid").datagrid("updateRow",{   //将开始记录加[
			index:start,
			row:{
				calSymbol:operator
			}
		})
		$("#kpiFilterGrid").datagrid("updateRow",{   //将结束记录加]
			index:end,
			row:{
				calSymboxRight:rightBracket+"]"
			}
		})
	}
}


/*--将过滤规则的表格形式转换成表达式的形式--*/
function changeFilterTableToRule(){
	var rows = $("#kpiFilterGrid").datagrid("getRows");
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
			if ((operator.indexOf ("&") > -1) || (operator.indexOf ("|") > -1)){
			}else{
				//myMsg("过滤规则配置有误");
				FILTER_ERROR_INFOR = "非第一条过滤规则都必须有&&、||";
				return -1;
				//return;
			}
		}else{
			if ((operator.indexOf ("&") > -1) || (operator.indexOf ("|") > -1)){
				//myMsg("过滤规则配置有误");
				FILTER_ERROR_INFOR = "第一条过滤规则不能包含&&、||";
				return -1;
				//return;
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


/*--新增指标类别下拉框加载--*/
var kpiTypeAddObj = $HUI.combobox("#docAppAddType",{
	url:$URL+"?ClassName=web.DHCWL.V1.DocAppCfg.DocKpiCfg&QueryName=GetTypeValue&ResultSetType=array",
	valueField:'typeCode',
	textField:'typeName'
});

/*--修改指标类别下拉框加载--*/
var kpiTypeModObj = $HUI.combobox("#docAppModType",{
	url:$URL+"?ClassName=web.DHCWL.V1.DocAppCfg.DocKpiCfg&QueryName=GetTypeValue&ResultSetType=array",
	valueField:'typeCode',
	textField:'typeName'
});




/*--医生医用新增--*/
$("#addButton").click(function(e){
	$("#docAppAddForm").form('reset');    //内容重置
	$("#docAppAddDialog").show();
	$HUI.dialog("#docAppAddDialog",{
		iconCls:'icon-w-add',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				//获取表单数据
				var flag = $("#docAppAddForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var code = $("#docAppAddCode").val();
				var desc = $("#docAppAddDesc").val();
				var classValue = $("#docAppAddClass").combobox("getText");
				var category = $("#docAppAddCategory").combobox("getText");
				var type = $("#docAppAddType").combobox("getText");
				
				//访问后台方法保存
				$m({
					ClassName:'web.DHCWL.V1.DocAppCfg.DocKpiCfg',
					MethodName:'UpdateDocApp',
					ID:"",
					code:code,
					desc:desc,
					type:type,
					class:classValue,
					category:category
				},function(text){
					myMsg(text);
					$HUI.dialog("#docAppAddDialog").close();
					$("#docTable").datagrid("reload");
				})
				//alert(code +"^"+desc +"^"+classValue +"^"+category +"^"+type);
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#docAppAddDialog").close();
			}
		}]
	});
})

/*--医生应用修改--*/
$("#modifyButton").click(function(e){
	$("#docAppModForm").form('reset');    //内容重置
	var docObj = $("#docTable").datagrid("getSelected");
	if (!docObj){
		myMsg("请先选择需要修改的医生应用记录");
		return;
	}
	var docID = docObj.ID;
	$("#docAppModCode").val(docObj.code);
	$("#docAppModDesc").val(docObj.desc);
	$("#docAppModClass").combobox("setValue",docObj.class);
	$("#docAppModCategory").combobox("setValue",docObj.category);
	$("#docAppModType").combobox("setValue",docObj.type);
	$("#docAppModForm").form('validate');
	$("#docAppModDialog").show();
	$HUI.dialog("#docAppModDialog",{
		iconCls:'icon-w-edit',
		resizable:true,
		modal:true,
		buttons:[{
			text:"保存",
			handler:function(e){
				//获取表单数据
				var flag = $("#docAppModForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var code = $("#docAppModCode").val();
				var desc = $("#docAppModDesc").val();
				var classValue = $("#docAppModClass").combobox("getText");
				var category = $("#docAppModCategory").combobox("getText");
				var type = $("#docAppModType").combobox("getText");
				
				//访问后台方法保存
				$m({
					ClassName:'web.DHCWL.V1.DocAppCfg.DocKpiCfg',
					MethodName:'UpdateDocApp',
					ID:docID,
					code:code,
					desc:desc,
					type:type,
					class:classValue,
					category:category
				},function(text){
					myMsg(text);
					$HUI.dialog("#docAppModDialog").close();
					$("#docTable").datagrid("reload");
				})
				
			}
		},{
			text:"关闭",
			handler:function(e){
				$HUI.dialog("#docAppModDialog").close();
			}
		}]
	})
})

/*--医生应用删除--*/
$("#deleteButton").click(function(text){
	var docObj = $("#docTable").datagrid("getSelected");
	if (!docObj){
		myMsg("请先选择需要删除的医生应用记录");
		return;
	}
	var docID = docObj.ID;
	
	
	$.messager.confirm("提示", "删除后将不能恢复,确认删除么?", function (r) {
		if (r) {
			$m({
				ClassName:'DHCWL.DocQueryData.SaveData',
				MethodName:'DocKpiDelete',
				id:docID
			},function(text){
				if (text == "ok"){
					text = "删除成功";
				}
				myMsg(text);
				$("#docTable").datagrid("reload");
			})
		}
	});
})

/*--计算指标配置界面--*/
$("#calKPICfgButton").click(function(e){
	var row = $("#docTable").datagrid("getSelected");
	if (!row){
		return;
	}
	var category = row.category;
	if (category == "计算类指标"){
		var classValue = row.class;
		var typeValue = row.type;
	}else{
		return;
	}
	var docID = row.ID;
	$m({
		ClassName:'web.DHCWL.V1.DocAppCfg.DocKpiCfg',
		MethodName:'GetCalRule',
		docID:docID
	},function(text){
		$("#calKPIRule").val(text);
	})
	
	$HUI.datagrid("#kpiColForSelectTable",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.DocAppCfg.DocKpiCfg',
			QueryName:'GetCalDocApp',
			docKPIDefClass:classValue,
			docKPIDefType:typeValue
		},
		fitColumns:true,
		pagination:true, //允许用户通过翻页导航数据
		pageSize:15,  //设置首次界面展示时每页加载条数
		pageList:[10,15,20,50,100], //设置分页可选展示条数
		onDblClickRow:function(rowIndex, rowData){
			var filterRule = $("#calKPIRule").val();
			var code = rowData.code;
			$("#calKPIRule").val(filterRule + code);
		}
	})
	
	$("#kpiCalRuleDialog").show();
	$HUI.dialog("#kpiCalRuleDialog",{
		iconCls:'icon-w-batch-cfg',
		height:kpiBodyHeight,
		resizable:true,
		modal:true/*,
		buttons:[{
			text:'保存',
			handler:function(e){
				var filterRule = $("#calKPIRule").val();       //获取选中医生应用记录ID
				var docObj = $("#docTable").datagrid("getSelected");
				var docID = docObj.ID;
				$m({                              //将数据保存到后台
					ClassName:'web.DHCWL.V1.DocAppCfg.DocKpiCfg',
					MethodName:'UpdateKpiDef',
					id:docID,
					calExp:filterRule
				},function(text){
					myMsg(text);
					$("#kpiTable").datagrid("reload");
				})
				$HUI.dialog("#kpiCalRuleDialog").close();
			}
		},{
			text:"关闭",
			handler:function(e){
				$HUI.dialog("#kpiCalRuleDialog").close();
			}
		}]*/
	});
})

/*--计算指标规则保存--*/
$("#saveCalRPTRule").click(function(e){
	var filterRule = $("#calKPIRule").val();       //获取选中医生应用记录ID
	var docObj = $("#docTable").datagrid("getSelected");
	var docID = docObj.ID;
	$m({                              //将数据保存到后台
		ClassName:'web.DHCWL.V1.DocAppCfg.DocKpiCfg',
		MethodName:'UpdateKpiDef',
		id:docID,
		calExp:filterRule
	},function(text){
		myMsg(text);
		$("#kpiTable").datagrid("reload");
	})
	$HUI.dialog("#kpiCalRuleDialog").close();
})

/*--医生应用查询--*/
$('#searchDocApp').searchbox({
	searcher:function(value,name){
		docObj.load({ClassName:"web.DHCWL.V1.DocAppCfg.DocKpiCfg",QueryName:"GetDocCfg",filterValue:value});
	}
})

/*--鼠标悬停备注单元格响应方法--*/
 function formatCellTooltip(value){  
	return "<span id='verylongText' title='" + value + "'>" + value + "</span>";  
 }
 
/*--计算指标运算规则配置--*/
$("#bracketsLeft,#bracketsRight,#addSign,#lessSign,#mulSign,#excSign,#backspaceSign,#cleanSign").click(function(e){
	var sign = e.target.innerText
	var calKPIRule = $("#calKPIRule").val();
	if ((!calKPIRule)&&(sign != "(")&&(sign != ")")) {
		return;
	}
	if(sign == "←"){
		var calKPIRule = calKPIRule.substr(0,calKPIRule.length-1);
		$("#calKPIRule").val(calKPIRule);
	}else if (sign == "C"){
		$("#calKPIRule").val("");
	}else{
		calKPIRule = calKPIRule + sign
		$("#calKPIRule").val(calKPIRule);
	}
	
})




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