/**
* Creator    :  wk
* CreatDate  :  2018-08-09
* Desc       :  统计大组展示界面
**/﻿

var kpiBodyHeight = getViewportOffset().y;
var GRP_SELECTED_ID = "";


var codecfgDetailObj = $HUI.datagrid("#codecfgDetailGrpTable",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.CodeCFG.FunModule',
		QueryName:'GetItemGrpDetail'
	},
	fitColumns:true,
	toolbar:'#detailRoleToobar',
	pagination:true,  //分页可用
	pageSize:15,  //当前页每页条数
	pageList:[15,20,50]/*,  //每页可以选中的显示条数
	onLoadSuccess:function(){
		$(this).datagrid('enableDnd');   //表格支持排序
	},
	onRowContextMenu:function(e){
		e.preventDefault();   //阻止浏览器自带的右键菜单弹出  
		$('#menu').menu('show', {
			left:e.pageX,
			top: e.pageY
		});
		e.preventDefault();   //阻止浏览器自带的右键菜单弹出
	}*/
})

var codecfgObj = $HUI.datagrid("#codecfgTable",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.CodeCFG.FunModule',
		QueryName:'GetItemGroupQuery'
	},
	fitColumns:true,
	toolbar:'#codecfgToobar',
	pagination:true,  //分页可用
	pageSize:15,  //当前页每页条数
	pageList:[15,20,50],  //每页可以选中的显示条数
	onClickRow:function(rowIndex,rowData){
		$("#codecfgDetailGrpTable").datagrid('load',{ClassName:'web.DHCWL.V1.CodeCFG.FunModule',QueryName:'GetItemGrpDetail',itemGrpID:rowData.ID})
		//var grpID = rowData.ID;
		//alert(grpID);
	}
})


/*--指标区间下拉框数据获取--*/
var dimObj = $HUI.combobox("#codecfgDim",{
	url:$URL+"?ClassName=web.DHCWL.V1.CodeCFG.FunModule&QueryName=GetDimQuery&ResultSetType=array",
	valueField:'dimID',
	textField:'dimDesc',
	onBeforeLoad:function(param){
		param.filterValue = param.q;
	},
	onHidePanel: function() {
		var value = $(this).combobox("getValue");
		var text = $(this).combobox("getText");
		if (value == text){
			$(this).combobox("clear");
			$('#codecfgDim').combobox('reload');
		}
	}
});


/*--鼠标悬停维度描述单元格响应方法--*/
function formatCellTooltip(value){  
	return "<span id='verylongText' title='" + value + "'>" + value + "</span>";  
}

/*--大组新增--*/
$("#codecfgAddButton").click(function(e){
	$("#codecfgAddForm").form('reset');
	$("#codecfgAddDialog").show();
	$HUI.dialog("#codecfgAddDialog",{
		iconCls:'icon-w-add',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#codecfgAddForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var dimValue = $("#codecfgDim").combobox("getText");
				//var dimValue = $("#codecfgDim").combobox("getValue");
				var code = $("#codecfgCode").val();
				var desc = $("#codecfgDesc").val();
				var creator = $("#codecfgCreator").val();
				$m({
					ClassName:'web.DHCWL.V1.CodeCFG.FunModule',
					MethodName:'addItemgrp',
					grpCode:code,
					grpDesc:desc,
					grpDimID:dimValue,
					grpUser:creator
				},function(txtData){
					myMsg(txtData);
					$HUI.dialog("#codecfgAddDialog").close();
					$("#codecfgTable").datagrid('reload');
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#codecfgAddDialog").close();
			}
		}]
	})
})

/*--大组修改--*/
$("#codecfgModifyButton").click(function(e){
	$("#codecfgModifyForm").form('reset');    //内容重置
	//获取选中记录
	var row = $("#codecfgTable").datagrid("getSelected");
	if(!row){
		myMsg("请先选择需要修改的大组");
		return;
	}
	var ID,code,desc,creator;
	ID = row.ID;
	code = row.codecfgCode;
	desc = row.codecfgName;
	creator = row.codecfgCreator;
	dim = row.codecfgDim;
	if ((!code)||(!ID)){
		myMsg("获取大组失败");
		return;
	}
	
	//给表单赋值
	$("#codecfgModifyCode").val(code);
	$("#codecfgModifyDesc").val(desc);
	$("#codecfgModifyCreator").val(creator);
	$("#codecfgModifyDialog").show();
	
	$("#codecfgModifyForm").form('validate'); //表单验证
	$HUI.dialog("#codecfgModifyDialog",{
		iconCls:'icon-w-edit',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var grpCode = $("#codecfgModifyCode").val();
				var grpDesc = $("#codecfgModifyDesc").val();
				var grpCreator = $("#codecfgModifyCreator").val();
				$m({
					ClassName:'web.DHCWL.V1.CodeCFG.FunModule',
					MethodName:'UpdateItemgrp',
					ID:ID,
					grpCode:grpCode,
					grpDesc:grpDesc,
					grpTypeDr:"",
					grpCreateUse:grpCreator,
					grpDimDr:dim
				},function(text){
					myMsg(text);  //弹出返回信息
					$HUI.dialog("#codecfgModifyDialog").close(); //关闭修改框
					$("#codecfgTable").datagrid('reload');  //统计大组表格重新加载
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#codecfgModifyDialog").close();
			}
		}]
	})
})

/*--大组删除--*/
$("#codecfgDeleteButton").click(function(e){
	var row = $("#codecfgTable").datagrid("getSelected");
	if(!row){
		myMsg("请先选择需要删除的大组");
		return;
	}
	var ID = row.ID;
	if ((!ID)){
		myMsg("获取大组失败");
		return;
	}
	$.messager.confirm("提示", "删除后统计大组将不能恢复,是否继续进行", function (r) {
		if (r) {
			$m({
				ClassName:'web.DHCWL.V1.CodeCFG.FunModule',
				MethodName:'DeleteItemgrp',
				itemID:ID
			},function(text){
				myMsg(text);
				$("#codecfgTable").datagrid('reload');  //统计大组表格重新加载
			})
		} 
	});
})

/*--大组导出--*/
$("#codecfgExportButton").click(function(e){
	var row = $("#codecfgTable").datagrid("getSelected");
	if(!row){
		myMsg("请先选择需要导出的大组");
		return;
	}
	var ID = row.ID;
	var excelObj=new Excel();
	excelObj.setTitle("统计大组导出");
	excelObj.setTable("DHCWL.CodeCfg.ItemGroup");
	excelObj.setHead(['大组编码','大组描述','创建时间','创建人','维度类型','明细ID','明细描述','明细排序值']);
	//excelObj.setServerUrl(serviceUrl+'?action=exportGrp');
	excelObj.exportExcelAll("web.DHCWL.V1.CodeCFG.FunModule","ExportGrp",ID);
})

/*--大组日志--*/
$("#codecfgLogButton").click(function(e){
	codecfgLogFormClean();
	$HUI.datagrid("#logGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.CodeCFG.FunModule',
			QueryName:'GetLogInforQuery',
			grpFlag:2
		},
		fitColumns:true,
		pagination:true,  //分页可用
		//striped:true,  //表格斑马线状态
		pageSize:15,  //当前页每页条数
		pageList:[15,20,50],  //每页可以选中的显示条数
		toolbar:'#codecfgLogToolbar'
	})
	
	$("#codecfgLogDialog").show();
	$HUI.dialog("#codecfgLogDialog",{
		iconCls:'icon-w-list',
		height:kpiBodyHeight-20,
		resizable:true,
		modal:true
	})
})

/*--统计大组明细新增界面--*/
$("#detailAddButton").click(function(e){
	var row = $("#codecfgTable").datagrid("getSelected");
	if(!row){
		myMsg("请先选择大组");
		return;
	}
	var grpID = row.ID;
	if (!grpID){
		myMsg("获取任务组失败");
		return;
	}
	$('#grpDetailSearch').searchbox('setValue', '');
	GRP_SELECTED_ID = grpID;
	$HUI.datagrid("#grpDetailAddGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.CodeCFG.FunModule',
			QueryName:'CheckGroupItemQuery',
			grpid:grpID
		},
		fitColumns:true,
		pagination:true,  //分页可用
		//striped:true,  //表格斑马线状态
		pageSize:15,  //当前页每页条数
		pageList:[5,10,15,20,50],  //每页可以选中的显示条数
		toolbar:'#grpAddToolbar'
	})
	
	$("#grpDetailAddDialog").show();
	$HUI.dialog("#grpDetailAddDialog",{
		iconCls:'icon-w-add',
		height:kpiBodyHeight-20,
		resizable:true,
		modal:true,
		onOpen:function(){     //打开任务组明细添加界面时初始化日志记录global
			$m({
				ClassName:'web.DHCWL.V1.CodeCFG.FunModule',
				MethodName:'InitItemGrpLogGlobal'
			},function(text){
				if (text != 'ok'){
					myMsg(text);
					return;
				}
			})
		},
		onClose:function(){     //关闭任务组明细添加界面时将日志信息保存起来
			$m({
				ClassName:'web.DHCWL.V1.CodeCFG.FunModule',
				MethodName:'EndItemGrpLogGlobal'
			},function(text){
				if (text != 'ok'){
					myMsg(text);
					return;
				}
			})
		}
	})
})

/*--大组明细移动--*/
 function moveGrpFun(value,row,index){
		return "<a href='javascript:void(0)' onclick='subGrpMoveup(\""+row.rowID+"\")' title='上移'>\
			"+"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/arrow_top.png' />"+"\
			</a>" + 
			"<a href='javascript:void(0)' onclick='subGrpMoveDown(\""+row.rowID+"\")' title='下移'>\
			"+"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/arrow_bottom.png' />"+"\
			</a>" +
			"<a href='javascript:void(0)' onclick='subGrpMoveTo(\""+row.rowID+"\")' title='跳转'>\
			"+"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/transfer.png' />"+"\
			</a>";
 }


/*--大组明细上移一位--*/
//$("#moveUp").click(function(e){
function subGrpMoveup(ID){
	/*var rows = $("#codecfgDetailGrpTable").datagrid("getSelections");
	var len = rows.length;
	if (len < 1){
		//myMsg("没有可移动记录");
		return;
	}
	if (len > 1){
		myMsg("一次只能移动一条记录");
		return;
	}*/
	detailID = ID;
	$m({
		ClassName:'web.DHCWL.V1.CodeCFG.FunModule',
		MethodName:'GrpMoveUpAndDown',
		grpDetailID:detailID,
		sign:'up'
	},function(text){
		$("#codecfgDetailGrpTable").datagrid('reload');
		myMsg(text);
	})
}//)

/*--大组明细下移一位--*/
//$("#moveDown").click(function(e){
function subGrpMoveDown(ID){
	/*var rows = $("#codecfgDetailGrpTable").datagrid("getSelections");
	var len = rows.length;
	if (len < 1){
		//myMsg("没有可移动记录");
		return;
	}
	if (len > 1){
		myMsg("一次只能移动一条记录");
		return;
	}*/
	detailID = ID;
	$m({
		ClassName:'web.DHCWL.V1.CodeCFG.FunModule',
		MethodName:'GrpMoveUpAndDown',
		grpDetailID:detailID,
		sign:'down'
	},function(text){
		$("#codecfgDetailGrpTable").datagrid('reload');
		myMsg(text);
	})
}//)

/*--大组跳转--*/
//$("#moveTo").click(function(e){
function subGrpMoveTo(ID){
	/*var rows = $("#codecfgDetailGrpTable").datagrid("getSelections");
	var len = rows.length;
	if (len < 1){
		//myMsg("没有可移动记录");
		return;
	}
	if (len > 1){
		myMsg("一次只能移动一条记录");
		return;
	}*/
	detailID = ID;
	$.messager.prompt("提示", "请输入跳转位置", function (r) {
		if (r) {
			if(!isNaN(r)){
				$m({
					ClassName:'web.DHCWL.V1.CodeCFG.FunModule',
					MethodName:'GrpMoveToLocation',
					grpDetailID:detailID,
					aimsValue:r
				},function(text){
					$("#codecfgDetailGrpTable").datagrid('reload');
					myMsg(text);
				})
			}else{
				myMsg("请输入数字");
			}
		}
	});
}//)

/*--统计大组更新排序--*/
$("#detailSortButton").click(function(e){
	//获取选中的统计大组ID
	var row = $("#codecfgTable").datagrid("getSelected");
	if(!row){
		myMsg("请先选择大组");
		return;
	}
	var grpID = row.ID;
	if (!grpID){
		myMsg("获取任务组失败");
		return;
	}
	GRP_SELECTED_ID = grpID;
	if (!GRP_SELECTED_ID){
		myMsg("获取统计大组失败");
		return;
	}
	
	/*--获取统计大组明细的ID和排序值--*/
	var rows = $("#codecfgDetailGrpTable").datagrid("getRows");
	var len = rows.length;
	if (len < 1){
		myMsg("没有可排序记录");
		return;
	}
	var ID = "",sortValue = "",IDSort = "",paraSort = "",num = 1;
	for(var i = 0; i < len;i++){
		row = rows[i].ID;
		//sortValue = rows[i].detailSort;
		IDSort = row + "*" + num;
		if (paraSort == ""){
			paraSort = IDSort;
		}else{
			paraSort = paraSort + "-" + IDSort;
		}
		num = num + 1;
	}
	
	/*--访问后台程序更新排序值--*/
	$m({
		ClassName:'web.DHCWL.V1.CodeCFG.FunModule',
		MethodName:'updategrpitemSort',
		grpID:GRP_SELECTED_ID,
		strParaValue:paraSort
	},function(text){
		myMsg(text);
		$("#codecfgDetailGrpTable").datagrid("reload");
	})
})

/*--统计大组新增明细响应--*/
$("#grpdetailAddButton").click(function(e){
	//alert("test");
	if (!GRP_SELECTED_ID){
		myMsg("获取统计大组失败");
		return;
	}
	//获取选中的统计大组明细
	var rows = $("#grpDetailAddGrid").datagrid("getSelections");
	var len = rows.length;
	if (len < 1){
		myMsg('请先选择需要添加的明细');
		return;
	}
	var row = "",grpID = "",grpIDs = "";
	for (var i = 0;i < len;i++){
		grpID = rows[i].ID;
		if (grpIDs == ""){
			grpIDs = grpID;
		}else{
			grpIDs = grpIDs + "-" + grpID;
		}
	}
	//将选中的统计大组明细保存到表里
	
	$m({
		ClassName:'web.DHCWL.V1.CodeCFG.FunModule',
		MethodName:'Addgrpitem',
		grpId:GRP_SELECTED_ID,
		selectItemPara:grpIDs
	},function(text){
		myMsg(text);
		$("#grpDetailAddDialog").dialog('close');
		$("#codecfgDetailGrpTable").datagrid('reload');
		return;
	})
	//alert(grpIDs+"^"+GRP_SELECTED_ID);
})

/*--统计大组明细删除--*/
$("#detailModifyButton").click(function(e){
	//获取选中的统计大组ID
	var row = $("#codecfgTable").datagrid("getSelected");
	if(!row){
		myMsg("请先选择大组");
		return;
	}
	var grpID = row.ID;
	if (!grpID){
		myMsg("获取任务组失败");
		return;
	}
	GRP_SELECTED_ID = grpID;
	if (!GRP_SELECTED_ID){
		myMsg("获取统计大组失败");
		return;
	}
	//获取待删除的大组明细
	var rows = $("#codecfgDetailGrpTable").datagrid("getSelections");
	var len = rows.length;
	if (len < 1){
		myMsg('请先选择需要删除的明细');
		return;
	}
	var row = "",grpID = "",grpIDs = "";
	for (var i = 0;i < len;i++){
		grpID = rows[i].ID;
		if (grpIDs == ""){
			grpIDs = grpID;
		}else{
			grpIDs = grpIDs + "-" + grpID;
		}
	}
	//将选中的统计大组明细保存到表里
	
	$.messager.confirm("提示", "删除后将不能恢复,确定要删除么？？", function (r) {
		if (r) {
			$m({
				ClassName:'web.DHCWL.V1.CodeCFG.FunModule',
				MethodName:'Delitem',
				grpID:GRP_SELECTED_ID,
				selectItemPara:grpIDs
			},function(text){
				myMsg(text);
				$("#codecfgDetailGrpTable").datagrid('reload');
				return;
			})
		}
	});
})

/*--统计大组日志--*/
function linkHisVerGrid(value,row,index){
	var type = row.operModule;
	var operType = row.operType;
	if ((type == "大组明细")&&(operType != "修改")){
		return "<a href='javascript:void(0)' onclick='verLogDetailFun(\""+row.logID+"\")' title='日志明细查看'>\
			"+"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/apply_check.png' />"+"\
			</a>";
	}else{
		return "";
	}
 }
 
 function verLogDetailFun(logID){
	 //alert(logID);
	 $HUI.datagrid("#logDetailGrid",{
		 url:$URL,
		 queryParams:{
			ClassName:'web.DHCWL.V1.CodeCFG.FunModule',
			QueryName:'GetLogDetail',
			logID:logID
		 },
		fitColumns:true
	 })
	 $("#logDetailDialog").show();
	 $HUI.dialog("#logDetailDialog",{
		resizable:true,
		modal:true,
		iconCls:'icon-w-list'
	 })
 }



/*--统计大组日志查询--*/
$("#logSearchButton").click(function(e){
	var userName = "",moduleType = "",operType = "",operDate = "";
	userName = $("#operUserName").val();
	moduleType = $("#moduleType").combobox("getText");
	operType = $("#operType").combobox("getText");
	operDate = $('#operDate').datebox('getValue');
	//alert(userName+"^"+moduleType+"^"+operType+"^"+operDate);
	$("#logGrid").datagrid("load",{ClassName:'web.DHCWL.V1.CodeCFG.FunModule',QueryName:'GetLogInforQuery',grpFlag:2,seaModeType:moduleType, seaOperType:operType, seaDate:operDate,seaName:userName})
})

/*--统计子组日志查询条件清空--*/
$("#logCleanButton").click(function(e){
	codecfgLogFormClean();
})

/*--统计大组日志条件清空--*/
function codecfgLogFormClean(){
	$("#operUserName").val("");
	$('#moduleType').combobox('setValue', '');
	$('#operType').combobox('setValue', '');
	$('#operDate').datebox('setValue', '');
}



/*--统计大组查询--*/
$('#searchText').searchbox({
	searcher:function(value,name){
		codecfgObj.load({ClassName:"web.DHCWL.V1.CodeCFG.FunModule",QueryName:"GetItemGroupQuery",filterValue:value});
	}
})

/*--统计大组明细查询--*/
$('#grpDetailSearch').searchbox({
	searcher:function(value,name){
		$("#grpDetailAddGrid").datagrid("load",{ClassName:'web.DHCWL.V1.CodeCFG.FunModule',QueryName:'CheckGroupItemQuery',grpid:GRP_SELECTED_ID,filterValue:value});
	}
})

