﻿/**
* Creator    :  wk
* CreatDate  :  2018-05-08
* Desc       :  基础维度定义界面
**/

var kpiBodyHeight = getViewportOffset().y;   // 获取屏幕高度

 /*--为每个维度添加一个链接，点击后弹出对应的维度属性信息--*/
 function dimConfigGrid(value,row,index){
	return "<a href='javascript:void(0)' onclick='viewDimProFun(\""+row.ID+"\")' title='查看维度属性'>\
		"+"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/apply_check.png' />"+"\
		</a>";
 }
 
 /**
 *点击维度链接后的响应方法(固定模式)
 *1、首先弹出界面表格对象加载数据
 *2、弹出窗口的div加载
 *3、定义弹出窗口的展示界面样式
*/
this.viewDimProFun=function(value) {
	//verHisGridObj.load({ClassName:"DHCWL.VerManagement.DefaultInOutService",QueryName:"GetHisByRowID",rowid:value}); 
	dimProObj.load({ClassName:"web.DHCWL.V1.KPI.DIMFunction",QueryName:"GetDimProInforQuery",dimID:value});
	$("#dimProDlg").show();
	var dimProDlgObj = $HUI.dialog("#dimProDlg",{
		height:kpiBodyHeight-20,
		iconCls:'icon-w-list',
		resizable:true,
		modal:true
	});
}
 

var dimProSelectObj = {},dimFilterParamsArr = [];
/*--基础维度表格--*/
var dimObj = $HUI.datagrid("#dimTable",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.KPI.DIMFunction',
		QueryName:'GetDimInforQuery'
	},
	//striped:true,
	pagination:true,
	pageSize:15,
	pageList:[5,10,15,20,50,100,500],
	fitColumns:true,
	toolbar:"#dimToobar",
	/*onDblClickRow:function(rowIndex,rowData){
		var p = $("#dimCreateBody").layout("panel","east")[0].clientWidth;
		if (p <= 0){
			$("#dimCreateBody").layout("expand","east");
			$("#dimProTable").datagrid('getPanel').panel("setTitle",rowData.dimName+"-----维度属性");
			dimSelectedID = rowData.ID;
			dimProObj.load({ClassName:"web.DHCWL.V1.KPI.DIMFunction",QueryName:"GetDimProInforQuery",dimID:rowData.ID});
		}
	},
	onClickRow:function(rowIndex,rowData){
		var p = $("#dimCreateBody").layout("panel","east")[0].clientWidth;
		if (p > 0){
			$("#dimProTable").datagrid('getPanel').panel("setTitle",rowData.dimName+"-----维度属性");
			dimSelectedID = rowData.ID;
			dimProObj.load({ClassName:"web.DHCWL.V1.KPI.DIMFunction",QueryName:"GetDimProInforQuery",dimID:rowData.ID});
		}
	}*/
})

/*--维度新增--*/
$("#dimAddButton").click(function(e){
	$("#dimAddInforForm").form('reset');
	dimConfigDialog("add");
})

/*--维度修改--*/
$("#dimModifyButton").click(function(e){
	$("#dimAddInforForm").form('reset');
	dimConfigDialog("modify");
})

/*--维度查询--*/
$('#searchText').searchbox({
	searcher:function(value,name){
		dimObj.load({ClassName:"web.DHCWL.V1.KPI.DIMFunction",QueryName:"GetDimInforQuery",filterValue:value});
	}
})

/*--维度角色查看--*/
$("#dimRoleButton").click(function(e){
	var dimObj = $("#dimTable").datagrid("getSelected");
	if (!dimObj){
		myMsg("请先选择相应的维度呦~");
		return;
	}
	var dimID = dimObj.ID;
	showDIMRole(dimID);
})

/*--维度导出--*/
$("#dimOutButton").click(function(e){
	//加载维度树
	var dimOutTreeObj = $HUI.treegrid("#configDimOutTree",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.KPI.DIMFunction",
			QueryName:"GetAllDIMTreeQuery",
			rows:10000,
			page:1
		},
		fitColumns:true,
		toolbar:"#dimOutToobar"
	})
	
	//弹出导出框
	$("#dimOutDataDialog").show();
	$HUI.dialog("#dimOutDataDialog",{
		resizable:true,
		modal:true,
		iconCls:'icon-w-export'
	})
})


/*--鼠标悬停备注单元格响应方法--*/
function formatCellTooltip(value){  
	return "<span id='verylongText' title='" + value + "'>" + value + "</span>";  
}
 /*--将维度编码列制成链接,点击后弹出产品对应的维度角色信息--*/
 function linkDimRole(value,row,index){
	 return "<a href='javascript:void(0)' onclick='showDIMRole(\""+row.ID+"\")' title='维度角色列表'>\
			"+value+"\
			</a>";
 }
 var dimRuleObj = $HUI.datagrid("#dimRoleTable",{
	 url:$URL,
	 queryParams:{
		 ClassName:'web.DHCWL.V1.KPI.DIMFunction',
		 QueryName:'GetDimRoleInforQuery',
		 dimID:''
	 },
	 //striped:true,
	 fitColumns:true,
	 pagination:false
	 
 })
 function showDIMRole(value){
	 $("#dimRoleDialog").show();
	 $HUI.dialog("#dimRoleDialog",{
	 	resizable:true,
	 	modal:true,
	 	iconCls:'icon-w-list'
	 })
	 dimRuleObj.load({ClassName:'web.DHCWL.V1.KPI.DIMFunction',QueryName:'GetDimRoleInforQuery',dimID:value});
 }

/*--维度预览数据--*/
$('#dimViewData').click(function(e){
	var row = $("#dimTable").datagrid("getSelected");
	if ((!row)||(!row.dimCode)||(!row.exeCode)){
		myMsg("请先选择预览数据的维度(只能选有执行代码的维度)");
		return;
	}
	$("#dimRuleConfig").val(row.dimCode);
	$("#dimFilterConfig").val("");
	$HUI.datagrid("#dimDataTable",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.KPI.DIMFunction',
			QueryName:'QryDimValuesQuery',
			dimRule:"",
			dimFilter:""
		},
		//striped:true,
		toolbar:"#tableToolbar",
		fitColumns:true,
		pagination:true,
		pageSize:15,
		pageList:[5,10,15,20,50,100]
	})
	
	/*--维度预览数据弹出框--*/
	$("#dimViewDataDialog").show();
	$HUI.dialog("#dimViewDataDialog",{
		resizable:true,
		modal:true,
		iconCls:'icon-w-list'
	})
	
})



/*--点击查询按钮查询维度数据--*/
$("#searchDIMData").click(function(e){
	var dimRule = $("#dimRuleConfig").val();
	var dimFilterRule = $("#dimFilterConfig").val();
	$("#dimDataTable").datagrid('load',{ClassName:"web.DHCWL.V1.KPI.DIMFunction",QueryName:"QryDimValuesQuery",dimRule:dimRule,dimFilter:dimFilterRule});
})

/*--清空维度数据的查询条件--*/
$("#cleanDIMCondition").click(function(e){
	$("#dimFilterConfig").val("");
	dimProSelectObj = {};
	var dimRule = $("#dimRuleConfig").val();
	var dimCode = dimRule.split(":")[0];
	$("#dimRuleConfig").val(dimCode);
})

/*--维度预览数据取数规则--*/
$("#dimRuleButton").click(function(e){
	var dimRule = $("#dimRuleConfig").val();
	$("#dimRuleListBox").val(dimRule);
	$("#dimRuleConfigDialog").show();
	$HUI.dialog("#dimRuleConfigDialog",{
		height:kpiBodyHeight-20, 
		resizable:true,
		modal:true,
		iconCls:'icon-w-config'
	});
	//dimProSelectObj = {};
	//维度选择界面
	var dimObj = $HUI.datagrid("#dimTableForSearch",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.KPI.DIMFunction',
			QueryName:'GetDimInforQuery'
		},
		//striped:true,
		fitColumns:true,
		pagination:true,
		pageSize:15,
		pageList:[5,10,15,20,50,100,500],
		toolbar:'#dimRuleSearchAllBox',
		onSelect:function(rowIndex,rowData){
			var dimCode = rowData.dimCode;
			dimProSelectObj = {};
			dimProSelectObj[dimCode] = {};
			$("#dimRuleListBox").val(dimCode);
			dimTreeObj.load({ClassName:"web.DHCWL.V1.KPI.DIMFunction",QueryName:"GetDIMRuleTreeQuery",inputRule:dimCode});
		}
	})
	//维度规则配置树
	var dimTreeObj = $HUI.treegrid("#configDimRuleTree",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.KPI.DIMFunction",
			QueryName:"GetDIMRuleTreeQuery",
			inputRule:dimRule,
			rows:10000,
			page:1
		},
		fitColumns:true,
		toolbar:"#dimRuleList",
		onCheckNode:function(row,checked){
			if (row){
				dimProCode = row.code;
				dimCode = row._parentId
				if (!dimProSelectObj.hasOwnProperty(dimCode)){
					dimProSelectObj[dimCode] = {};
				}
				if (checked){
					dimProSelectObj[dimCode][dimProCode] = {};
				}else{
					delete dimProSelectObj[dimCode][dimProCode];
				}
				var dimRule = refreshKPIRule(dimProSelectObj);
				$("#dimRuleListBox").val(dimRule);
			}
		}
	})
	
})


/*--维度预览数据点击确定按钮--*/
$("#defineButton").click(function(e){
	var dimRule = $("#dimRuleListBox").val();
	$("#dimRuleConfig").val(dimRule);
	$HUI.dialog("#dimRuleConfigDialog").close();
	
})

/*--过滤规则配置界面--*/
$("#dimFilterButton").click(function(e){
	/*--获取取数规则--*/
	var dimRule = $("#dimRuleConfig").val();
	if(!dimRule){
		myMsg("取数规则为空,无法配置过滤规则");
		return;
	}else{
		
	}
	/*--过滤规则弹出框--*/
	$("#dimFilterConfigDialog").show();
	$HUI.dialog("#dimFilterConfigDialog",{
		height:kpiBodyHeight-20,
		resizable:true,
		modal:true,
		iconCls:'icon-w-config'
	});
	
	/*--过滤规则树--*/
	$HUI.treegrid("#dimFilterTree",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.KPI.DIMFunction",
			QueryName:"GetDIMRuleTreeQuery",
			inputRule:dimRule,
			rows:10000,
			page:1
		},
		fitColumns:true,
		onDblClickRow:function(row){
			getFilterTreeAndFilterFun();
		}
	});
	
	//过滤函数表格
	$HUI.datagrid("#filterFunGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.KPI.KPIFunction',
			QueryName:'GetFilterFunQuery'
		},
		//striped:true,
		fitColumns:true,
		pagination:true,
		pageSize:100,
		pageList:[10,15,20,50,100,500],
		onDblClickRow:function(rowIndex,rowData){
			getFilterTreeAndFilterFun();
		}
	})
	
	/*--加载过滤函数表达式表格--*/
	$HUI.datagrid("#filterRuleGrid",{
		fitColumns:true,
		toolbar:[{
			iconCls:'icon-save',
			text:'确定',
			handler:function(){
				var rows = $("#filterRuleGrid").datagrid("getRows");
				var len = rows.length;
				if (len > 0){
					var operator,dimRule,filterFun,value,filterRule;
					for (var i = 0;i < len;i++){
						operator = rows[i].operator;
						dimRule = rows[i].dimRule;
						filterFun = rows[i].filterFun;
						value = rows[i].value;
						if (filterRule){
							filterRule = filterRule + operator + "{" + dimRule + "}" + filterFun + value;
						}else{
							filterRule = "[{" + dimRule + "}" + filterFun + value;
						}
					}
					filterRule = filterRule + "]"
				}else{
					var filterRule = "";
				}
				$("#dimFilterConfig").val(filterRule);
				$HUI.dialog("#dimFilterConfigDialog").close();
			}
		}]
	})
	$("#filterRuleGrid").datagrid('loadData',{total:0,rows:[]});
})




/*--双击树节点和过滤函数之后运行的方法--*/
function getFilterTreeAndFilterFun(){	
	var row,dimRule,dataGrid;
	row = $("#dimFilterTree").treegrid("getSelected");
	dataGrid = $("#filterFunGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择维度信息");
		return;
	}
	if (!dataGrid){
		myMsg("请先选择过滤函数");
		return;
	}
	
	if (row){
		var parentID = row._parentId;
		if (parentID == ""){
			code = row.code;
			dimRule = code;
		}else {
			code = row.code;
			dimNode = $("#dimFilterTree").treegrid("getParent",row.ID);
			dimCode = dimNode.code;
			dimRule = dimCode + "." +code;
		}
	}
	
	var filterFun;
	if (dataGrid){
		filterFun = dataGrid.FilterFuncCode;
	}
	
	
	if(filterFun.indexOf("[") >=0){              //为 [ 加转义符
		var tmpFunStr=filterFun.split("[");
		filterFun=tmpFunStr[0]+"\\["+tmpFunStr[1];
	}
	if(filterFun.indexOf("]") >=0){
		var tmpFunStr=filterFun.split("]");
		filterFun=tmpFunStr[0]+"\\]"+tmpFunStr[1];
	}
	
	
	
	if (dimRule){
		$("#filterValue").val("");
		$("#operatorList").combobox("setValue","");
		var rows = $("#filterRuleGrid").datagrid("getRows");
		var len = rows.length,myKPICode,flag;
		flag = 0;          //flag记录要插入的维度信息是否在过滤函数中已经存在,flag为1时表示已经存在
		if(len > 0){
			flag = 1;
		}
		if (flag == 1){    //维度已经配置过滤规则时可以选择运算符，不存在时不能选择
			var data = $("#operatorList").combobox('getData'); //可以选择时，提供默认选择值
			$("#operatorList").combobox('select',data[0].text);
			$("#operatorList").combobox("enable");
		}else{
			$("#operatorList").combobox("disable");
		}
		//弹窗运算符和过滤值界面
		$("#operatorSelector").show();
		$HUI.dialog("#operatorSelector",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			buttons:[{
				text:'确定',
				handler:function(e){
					var value = $("#filterValue").val();
					var comboxValue = $("#operatorList").combobox("getValue");
					if (!value){
						myMsg("过滤值不能为空!");
						return;
					}
					//alert(dimFilterParamsArr[0]+"^"+dimFilterParamsArr[1]+"^"+value);
					$HUI.dialog("#operatorSelector").close();
					$("#filterRuleGrid").datagrid("insertRow",{
						row:{
							operator:comboxValue,
							dimRule:dimFilterParamsArr[0],
							filterFun:dimFilterParamsArr[1],
							value:value
						}
					})
				}
			},{
				text:'关闭',
				handler:function(e){
					$HUI.dialog("#operatorSelector").close();
				}
			}]
		});
		dimFilterParamsArr = [dimRule,filterFun];
		//alert(dimRule+"^"+filterFun);
		
	}
	
	
}

/*--方法用于打开维度新增、修改界面--*/
function dimConfigDialog(operType){
	var ID,dimCode,dimName,dimDesc,exeCode,dimCreator,remark;
	ID = "";
	var title = "",icon = "";
	if (operType == "modify"){
		title = "维度修改";
		icon = "icon-w-edit";
		var row = $("#dimTable").datagrid("getSelected");
		if (!row){
			myMsg("请先选择需要修改的维度再进行操作");
			return;
		}
		
		var ID,dimCode,dimName,dimDesc,exeCode,dimCreator,remark;
		ID = row.ID;
		$("#dimCode").val(row.dimCode);
		$("#dimName").val(row.dimName);
		$("#dimDesc").val(row.dimDesc);
		$("#dimExCode").val(row.exeCode);
		$("#dimCreator").val(row.creator);
		$("#remark").val(row.remark);
		$("#dimAddInforForm").form('validate');
		$("#dimCode").attr("disabled",true);
	}else{
		title = "维度新增";
		icon = "icon-w-add";
		$("#dimCode").attr("disabled",false);
	}
	$("#dimAddDialog").show();
	$HUI.dialog("#dimAddDialog",{
		resizable:true,
		modal:true,
		title:title,
		iconCls:icon,
		buttons:[{
			text:'保存',
			handler:function(){
				
				var dimCode,dimName,dimDesc,exeCode,dimCreator,remark;
				dimCode = $("#dimCode").val();
				dimName = $("#dimName").val();
				dimDesc = $("#dimDesc").val();
				exeCode = $("#dimExCode").val();
				dimCreator = $("#dimCreator").val();
				remark = $("#remark").val();
				var isValid = $("#dimAddInforForm").form('validate');   //检查表单信息是否符合要求
				if (!isValid){
					myMsg("请按照提示填写内容");
					return;
				}
				$m({                                             //将信息保存到后台
					ClassName:'web.DHCWL.V1.KPI.DIMFunction',
					MethodName:'SaveDim',
					ID:ID,
					KDTCode:dimCode,
					KDTName:dimName,
					KDTDesc:dimDesc,
					KDTExeCode:exeCode,
					KDTRemark:remark,
					KDTUser:dimCreator
				},function(txtData){
					myMsg(txtData);		  //弹框显示返回信息
					dimObj.reload();      //刷新当前页
					$HUI.dialog("#dimAddDialog").close();  //关闭弹窗
				});
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog("#dimAddDialog").close();
			}
		}]
	})
}

/*--维度删除按钮点击响应--*/
$("#dimDeleteButton").click(function(e){
	var row = $("#dimTable").datagrid("getSelected");
	if (!row){
		myMsg("请先选择需要删除的维度哦~");
		return;
	}
	if (!row.dimCode){
		myMsg("获取维度信息失败");
		return;
	}
	
	$.messager.confirm("删除", "删除后将不能恢复,确定删除么?", function (r) {
		if (r) {   //点击确定按钮时执行删除操作
			$m({
				ClassName:'web.DHCWL.V1.KPI.DIMFunction',
				MethodName:'DeleteDim',
				KDTCode:row.dimCode
			},function(txtData){
				myMsg(txtData);
				dimObj.reload();
			})	
			
		} else {
			return;
		}
	});
})


/*--维度属性表格--*/
var dimProObj = $HUI.datagrid("#dimProTable",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.KPI.DIMFunction',
		QueryName:'GetDimProInforQuery',
		dimID:''
	},
	//striped:true,
	pagination:true,
	pageSize:15,
	fitColumns:true,
	pageList:[5,10,15,20,50,100,500],
	toolbar:"#dimProToobar"
	//fitColumns:true
})

/*--维度属性新增--*/
$("#dimProAddButton").click(function(e){
	$("#dimProAddForm").form('reset');
	dimProConfigDialog("add");
})

/*--维度属性修改--*/
$("#dimProModifyButton").click(function(e){
	$("#dimProAddForm").form('reset');
	dimProConfigDialog("modify");
})
/*--维度属性删除--*/
$("#dimProDeleteButton").click(function(e){
	var row = $("#dimProTable").datagrid("getSelected");
	if (!row){
		myMsg("请先选择需要删除的维度属性哦~");
		return;
	}
	if (!row.ID){
		myMsg("获取维度属性信息失败");
		return;
	}
	
	$.messager.confirm("删除", "删除后不能恢复,确定删除么", function (r) {
		if (r) {   //点击确定按钮时执行删除操作
			$m({
				ClassName:'web.DHCWL.V1.KPI.DIMFunction',
				MethodName:'DeleteDimPro',
				dimProId:row.ID
			},function(txtData){
				myMsg(txtData);
				dimProObj.reload();
			})	
			
		} else {
			return;
		}
	});
})


/*--方法用于打开维度新增、修改界面--*/
function dimProConfigDialog(operType){
	var dimRow = $("#dimTable").datagrid("getSelected");
	if (!dimRow){
		myMsg("请先选择维度之后再操作");
		return;
	}
	var dimID = dimRow.ID;
	var ID,title,icon;
	ID = "",title = "",icon = "";
	if (operType == "modify"){
		title = "维度属性修改",
		icon = "icon-w-edit";
		var row = $("#dimProTable").datagrid("getSelected");
		if (!row){
			myMsg("请先选择需要修改的维度属性再进行操作");
			return;
		}
		
		ID = row.ID;
		$("#dimProCode").val(row.proCode);
		$("#dimProName").val(row.proName);
		$("#dimProDesc").val(row.proDesc);
		$("#dimProExCode").val(row.proExeCode);
		$("#activeFlag").combobox("setValue",row.proDefActive);
		$("#dimProDeli").val(row.proSplitSign);
		$("#dimProAddForm").form('validate');
		$("#dimProCode").attr("disabled",true);
	}else{
		title = "维度属性新增";
		icon = "icon-w-add";
		$("#dimProCode").attr("disabled",false);
	}
	$("#dimProAddDialog").show();
	$HUI.dialog("#dimProAddDialog",{
		resizable:true,
		modal:true,
		title:title,
		iconCls:icon,
		buttons:[{
			text:'保存',
			handler:function(){
				var proCode,proName,proDesc,proExeCode,proActFlag,dimProDeli;
				proCode = $("#dimProCode").val();
				proName = $("#dimProName").val();
				proDesc = $("#dimProDesc").val();
				proExeCode = $("#dimProExCode").val();
				proActFlag = $("#activeFlag").combobox("getValue");
				dimProDeli = $("#dimProDeli").val();
				var isValid = $("#dimProAddForm").form('validate');   //检查表单信息是否符合要求
				if (!isValid){
					myMsg("请按照提示填写内容");
					return;
				}
				//alert(proCode+"^"+proName+"^"+proDesc+"^"+proExeCode+"^"+proActFlag+"^"+dimProDeli);
				//return;
				$m({                                             //将信息保存到后台
					ClassName:'web.DHCWL.V1.KPI.DIMFunction',
					MethodName:'addDimPro',
					dimId:dimID,
					ID:ID,
					Code:proCode,
					Name:proName,
					Desc:proDesc,
					ExcuteCode:proExeCode,
					DefaultFlag:proActFlag,
					ValueDeli:dimProDeli
				},function(txtData){
					myMsg(txtData);		  //弹框显示返回信息
					dimProObj.reload();      //刷新当前页
					$HUI.dialog("#dimProAddDialog").close();  //关闭弹窗
				});
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog("#dimProAddDialog").close();
			}
		}]
	})
}
