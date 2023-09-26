﻿/**
* Creator   : wk
* CreatDate : 2018-08-27
* Desc      : 报表列维护界面
**/

var CAL_ROWID = "";
var kpiBodyHeight = getViewportOffset().y-40;
/*--报表列表--*/
var rptColObj = $HUI.datagrid("#rptColTable",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayItemFun',
		QueryName:'GetRptItem'
	},
	//striped:true,
	fitColumns:true,
	pagination:true,
	pageSize:15,
	pageList:[10,15,20,50,100],
	toolbar:"#rptColToobar"
})

/*--报表列查询--*/
$('#searchText').searchbox({
	searcher:function(value,name){
		rptColObj.load({ClassName:"web.DHCWL.V1.MRIPDay.MRIPDayItemFun",QueryName:"GetRptItem",filterValue:value});
	}
})

/*--报表列新增--*/
$("#addButton").click(function(e){
	$("#rptAddForm").form('reset'); 
	$("#rptAddDialog").show();
	$HUI.dialog("#rptAddDialog",{
		resizable:true,
		iconCls:'icon-w-add',
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#rptAddForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var code = $("#rptColCode").val();
				var desc = $("#rptColDesc").val();
				var type = $("#rptColtype").combobox("getValue");
				$m({
					ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayItemFun',
					MethodName:'AddItem',
					code:code,
					desc:desc,
					type:type
				},function(text){
					myMsg(text);
					$("#rptColTable").datagrid("reload");
					$HUI.dialog("#rptAddDialog").close();
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#rptAddDialog").close();
			}
		}]
	})
})

/*--报表列修改--*/
$("#modifyButton").click(function(e){
	var row = $("#rptColTable").datagrid("getSelected");
	if (!row){
		myMsg("请先选择需要修改的报表列");
		return;
	}
	var rptColID,rptColCode,rptColDesc;
	rptColID = row.ID;
	rptColCode = row.code;
	rptColDesc = row.desc;
	$("#rptColModifyCode").val(rptColCode);
	$("#rptColModifyDesc").val(rptColDesc);
	$("#rptModifyForm").form('validate');
	$("#rptModifyDialog").show();
	$HUI.dialog("#rptModifyDialog",{
		resizable:true,
		iconCls:'icon-w-edit',
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#rptModifyForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var desc = $("#rptColModifyDesc").val();
				$m({
					ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayItemFun',
					MethodName:'ModifyItem',
					ID:rptColID,
					desc:desc
				},function(text){
					myMsg(text);
					$("#rptColTable").datagrid("reload");
					$HUI.dialog("#rptModifyDialog").close();
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#rptModifyDialog").close();
			}
		}]
	})
})

/*--报表列删除--*/
$("#deleteButton").click(function(e){
	var row = $("#rptColTable").datagrid("getSelected");
	if (!row){
		myMsg("请先选择需要删除的报表列");
		return;
	}
	var rptColID = row.ID;
	
	$.messager.confirm("提示", "确认删除么？", function (r) {
		if (r) {
			$m({
				ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayItemFun',
				MethodName:'DelItem',
				rptColID:rptColID
			},function(text){
				myMsg(text);
				$("#rptColTable").datagrid("reload");
			})
		}
	});
})

/*--报表列配置--*/
$("#configButton").click(function(e){
	var row = getRptColObj();
	if (!row){
		return;
	}
	var type = row.type;
	var rptColID = row.ID;
	var title = row.desc;
	if (type == "CalItem"){
		$m({
			ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayItemFun',
			MethodName:'SearchCalItem',
			rptColID:rptColID
		},function(text){
			var arr = new Array();
			arr = text.split(":");
			CAL_ROWID = arr[0];
			var exeCode = arr[1];
			$("#calRPTRule").val(exeCode);
			//alert(CAL_ROWID + "^" + exeCode);
		})
		$HUI.datagrid("#rptColForSelectTable",{
			url:$URL,
			queryParams:{
				ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayItemFun',
				QueryName:'GetRptItem',
				sign:'noCal'
			},
			fitColumns:true,
			pagination:true,
			pageSize:15,
			pageList:[10,15,20,50,100],
			onDblClickRow:function(index,row){
				var code = row.code;
				var calRPTRule = $("#calRPTRule").val();
				if (calRPTRule != ""){
					var str = calRPTRule.charAt(calRPTRule.length - 1);
					if (str == ">"){
						myMsg("指标间需要选择运算符");
						return;
					}
				}
				calRPTRule = calRPTRule + "<" + code + ">"
				$("#calRPTRule").val(calRPTRule);
			}
		});
		title = title + "---" +"计算类报表列配置";
		$("#rptCalRuleDialog").show();
		$HUI.dialog("#rptCalRuleDialog",{
			height:kpiBodyHeight,
			title:title,
			iconCls:'icon-w-config',
			resizable:true,
			modal:true
		})
	}else if(type == "KPIItem"){
		
		//展示表格
		$HUI.datagrid("#KPIRptCfgGrid",{
			url:$URL,
			queryParams:{
				ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayItemFun',
				QueryName:'SearchKPIItem',
				OPTLItemDR:rptColID
			},
			fitColumns:true,
			toolbar:[{
				iconCls:'icon-batch-cfg',
				text:'配置',
				handler:function(e){
					var kpiID,kpiCode,dim,kpiDimCode;
					//下拉框展示指标
					var codecbgObj = $HUI.combogrid("#kpiCode",{
						panelWidth:550,
						url:$URL+"?ClassName=web.DHCWL.V1.MRIPDay.MRIPDayItemFun&QueryName=SelectKpis",
						mode:'remote',
						delay:200,
						idField:'ID',
						textField:'kpiCode',
						onBeforeLoad:function(param){
							param.kpiCode = param.q;
						},
						onSelect:function(record){
							var trObj,grid,row;
							trObj = $HUI.combogrid("#kpiCode");
							grid = trObj.grid();
							row = grid.datagrid("getSelected");
							dim = row.dimCode;
							kpiID = row.ID;
							kpiCode = row.kpiCode;
							kpiDimCode = row.kpiDimCode;
							$("#dimCode").val(dim);
							$("#typeCode").val(kpiDimCode);
							$("#KPIRptAddForm").form('validate');
							
						},
						columns:[[
							{field:'ID',title:'ID',width:100,hidden:true},
							{field:'kpiCode',title:'指标编码',width:100},
							{field:'kpiName',title:'指标名称',width:180},
							{field:'dimCode',title:'维度',width:80},
							{field:'kpiDimCode',title:'报表类型',width:80},
							{field:'category',title:'类型',width:80,
								formatter: function(value,row,index){
									return "<span id='verylongText' title='" + value + "'>" + value + "</span>"; 
								}
							},
							{field:'section',title:'区间',width:100,hidden:true}
						]]
					});
					$("#KPIRptAddForm").form('reset');  
					//弹出框展示
					$("#KPIRptAddDialog").show();
					$HUI.dialog("#KPIRptAddDialog",{
						iconCls:'icon-w-config',
						resizable:true,
						modal:true,
						buttons:[{
							text:'保存',
							handler:function(e){
								var detailType = $("#mripdayType").combobox('getValue');
								var section = $("#section").combobox('getValue');
								var flag = $("#KPIRptAddForm").form('validate');
								if (!flag){
									myMsg("请按照提示填写内容");
									return;
								}
								$m({
									ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayItemFun',
									MethodName:'AddKpiItem',
									optItemID:rptColID,
									kpiID:kpiID,
									kpiCode:kpiCode,
									itemtype:kpiDimCode,
									dimCode:dim,
									detailType:detailType,
									section:section
								},function(text){
									myMsg(text);
									$("#KPIRptCfgGrid").datagrid("reload");
									$HUI.dialog("#KPIRptAddDialog").close();
								})
								
							}
						},{
							text:'关闭',
							handler:function(e){
								$HUI.dialog("#KPIRptAddDialog").close();
							}
						}]
					})
				}
			},{
				iconCls:'icon-cancel',
				text:'删除',
				handler:function(e){
					var row = $("#KPIRptCfgGrid").datagrid("getSelected");
					if (!row){
						myMsg("请先选择需要删除的记录");
						return;
					}
					var rptColID = row.rptColID;
					var type = row.type;
					var ID = row.ID;
					$.messager.confirm("提示", "确认删除么？", function (r) {
						if (r) {
							$m({
								ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayItemFun',
								MethodName:'DelKPIItem',
								OPTLItemDR:rptColID,
								itemType:type,
								rowID:ID
							},function(text){
								myMsg(text);
								$("#KPIRptCfgGrid").datagrid("reload");
							})
						}
					});
				}
			}]
		})
		title = title + "---" + "指标类报表列配置";
		//展示弹出框
		$("#KPIRptCfgDialog").show();
		$HUI.dialog("#KPIRptCfgDialog",{
			iconCls:'icon-w-config',
			title:title,
			height:kpiBodyHeight,
			resizable:true,
			modal:true
		})
	}else if (type == "CustomItem"){
		$HUI.datagrid("#DIYRptCfgGrid",{
			url:$URL,
			queryParams:{
				ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayItemFun',
				QueryName:'GetCustomItem',
				OPTLItemDR:rptColID
			},
			fitColumns:true,
			toolbar:[{
				text:'配置',
				iconCls:'icon-batch-cfg',
				handler:function(e){
					$("#DIYAddForm").form('reset'); 
					$("#DIYAddDialog").show();
					$HUI.dialog("#DIYAddDialog",{
						resizable:true,
						iconCls:'icon-w-add',
						modal:true,
						buttons:[{
							text:'保存',
							handler:function(e){
								var flag = $("#DIYAddForm").form('validate');
								if (!flag){
									myMsg("请按照提示填写内容");
									return;
								}
								var type = $("#DIYColtype").combobox("getValue");
								var exeCode = $("#DIYColExeCode").val();
								$m({
									ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayItemFun',
									MethodName:'AddCustomItem',
									rptItemDR:rptColID,
									DIYFun:exeCode,
									type:type
								},function(text){
									$("#DIYRptCfgGrid").datagrid("reload");
									myMsg(text);
									$HUI.dialog("#DIYAddDialog").close();
								})
								//alert(rptColID+"^"+type+"^"+exeCode);
							}
						},{
							text:'关闭',
							handler:function(e){
								$HUI.dialog("#DIYAddDialog").close();
							}
						}]
						
					})
				}
			},{
				text:'删除',
				iconCls:'icon-cancel',
				handler:function(e){
					var row = $("#DIYRptCfgGrid").datagrid("getSelected");
					if(!row){
						myMsg("请先选择要删除的记录");
						return;
					}
					var rptColID = row.rptColID;
					var ID = row.ID;
					var type = row.type;
					$.messager.confirm("提示", "确认删除么？", function (r) {
						if (r) {
							$m({
								ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayItemFun',
								MethodName:'DelCustomItem',
								OPTLItemDR:rptColID,
								itemType:type,
								rowID:ID
							},function(text){
								myMsg(text);
								$("#DIYRptCfgGrid").datagrid("reload");
							})
						}
					});
				}
			}]
		})
		title = title + "---" + "自定义类报表列配置";
		$("#DIYRptCfgDialog").show();
		$HUI.dialog("#DIYRptCfgDialog",{
			height:kpiBodyHeight,
			title:title,
			iconCls:'icon-w-config',
			resizable:true,
			modal:true
		})
	}
})


/*--计算类报表列配置--*/
$("#bracketsLeft,#bracketsRight,#addSign,#lessSign,#mulSign,#excSign,#backspaceSign,#cleanSign").click(function(e){
	var sign = e.target.innerText
	var calRPTRule = $("#calRPTRule").val();
	if (!calRPTRule) {
		return;
	}
	if(sign == "←"){
		var calRPTRule = calRPTRule.substr(0,calRPTRule.length-1);
		$("#calRPTRule").val(calRPTRule);
	}else if (sign == "C"){
		$("#calRPTRule").val("");
	}else{
		calRPTRule = calRPTRule + sign
		$("#calRPTRule").val(calRPTRule);
	}
	
})
$("#saveCalRPTRule").click(function(e){
	var rptColRow = getRptColObj();
	var rptColID = rptColRow.ID;
	var value = $("#calRPTRule").val();
	$m({
		ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayItemFun',
		MethodName:'AddCalItem',
		rptColID:rptColID,
		exeCode:value,
		rowID:CAL_ROWID
	},function(text){
		myMsg(text);
		$m({
			ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayItemFun',
			MethodName:'SearchCalItem',
			rptColID:rptColID
		},function(text){
			var arr = new Array();
			arr = text.split(":");
			CAL_ROWID = arr[0];
			var exeCode = arr[1];
			$("#calRPTRule").val(exeCode);
			$HUI.dialog("#rptCalRuleDialog").close();
		})
	})
	//alert(value + "^" + CAL_ROWID + "^" +rptColID);
})




/*--获取选中的报表列对象--*/
function getRptColObj(){
	var row = $("#rptColTable").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条报表列记录");
		return "";
	}
	return row;
}
