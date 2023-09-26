/**
* Creator    :  wk
* CreatDate  :  2018-08-09
* Desc       :  出入转报表配置
**/﻿

var kpiBodyHeight = getViewportOffset().y;

/*--报表列表格--*/
var rptObj = $HUI.datagrid("#rptCfgTable",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayFun',
		QueryName:'GetRptInfor'
	},
	fitColumns:true,
	toolbar:'#rptToobar',
	pagination:true,  //分页可用
	pageSize:15,  //当前页每页条数
	pageList:[15,20,50],  //每页可以选中的显示条数
	onClickRow:function(rowIndex,rowData){
		$("#rptColumnTable").datagrid('load',{ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayFun',QueryName:'GetRptColInfor',rptID:rowData.ID});
		var dimProObj = $HUI.combogrid("#rptModifyDimPro");
		var grid = dimProObj.grid();
		grid.datagrid("load",{ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayFun',QueryName:'GetDimProQuery',dimCode:rowData.rptDim});
	}
})

/*--报表表格--*/
var rptColumnObj = $HUI.datagrid("#rptColumnTable",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayFun',
		QueryName:'GetRptColInfor'
	},
	toolbar:'#rptColToobar',
	fitColumns:true,
	pagination:true,  //分页可用
	pageSize:15,  //当前页每页条数
	pageList:[15,20,50]  //每页可以选中的显示条数
})

/*--报表列维护--*/
$("#rptColConfigButton").click(function(e){
	var row = $("#rptCfgTable").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条记录");
		return;
	}
	var rptID = row.ID;
	//待选报表列表格
	$HUI.datagrid("#optionalRptColGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayFun',
			QueryName:'OptionalRptItem',
			rptID:rptID
		},
		fitColumns:true,
		toolbar:[]
	})
	
	//已选报表列表格
	$HUI.datagrid("#selectedRptGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayFun',
			QueryName:'SelectedRptItem',
			rptID:rptID
		},
		fitColumns:true,
		toolbar:[]
	})
	
	//报表列维护界面
	$("#rptColCfgDig").show();
	$HUI.dialog("#rptColCfgDig",{
		iconCls:'icon-w-config',
		height:kpiBodyHeight-40,
		resizable:true,
		modal:true
	})
})

/*--报表列上移--*/
$("#moveTop").click(function(e){
	rptItemMove("moveRight");
})

/*--报表列下移--*/
$("#moveBottom").click(function(e){
	rptItemMove("moveLeft");
})

/*--报表列移入--*/
$("#moveRight").click(function(e){
	//获取报表项ID
	var row = $("#rptCfgTable").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条报表项记录");
		return;
	}
	var rptID = row.ID;
	
	//获取报表列ID
	var row = $("#optionalRptColGrid").datagrid("getSelected");
	if(!row){
		myMsg("请先选择需要操作的报表列");
		return;
	}
	var rptItemID,rptItemCode,rptItemDesc;
	rptItemID = row.ID;
	rptItemCode = row.rptItemCode;
	rptItemDesc = row.rptItemDesc;
	
	//获取已选报表列ID列表
	var rows = $("#selectedRptGrid").datagrid("getRows");
	var len = rows.length;
	var IDs=""
	for(var i = 0;i < len;i++){
		if (IDs == ""){
			IDs = rows[i].ID;
		}else{
			IDs = IDs + "," + rows[i].ID;
		}
	}
	IDs = IDs + "," + rptItemID;
	
	//访问后台代码保存报表列
	$m({
		ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayFun',
		MethodName:'AddRptItem',
		rptItemID:rptItemID,
		rptID:rptID,
		rptItemCode:rptItemCode,
		rptItemDesc:rptItemDesc,
		rptItemIDS:IDs
	},function(text){
		$("#optionalRptColGrid").datagrid("reload");
		$("#selectedRptGrid").datagrid("reload");
		$("#rptColumnTable").datagrid("reload");
		myMsg(text);
	})
})

/*--报表项的移除--*/
$("#moveLeft").click(function(e){
	//获取报表项ID
	var row = $("#rptCfgTable").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条报表项记录");
		return;
	}
	var rptID = row.ID;
	
	//获取选中的报表列ID
	var row = $("#selectedRptGrid").datagrid("getSelected");
	if(!row){
		myMsg("请先选择需要操作的报表列");
		return;
	}
	var rptItemID = row.ID;
	var index = $("#selectedRptGrid").datagrid("getRowIndex",row);
	$("#selectedRptGrid").datagrid("deleteRow",index);
	
	//获取已选报表列ID列表
	var rows = $("#selectedRptGrid").datagrid("getRows");
	var len = rows.length;
	var IDs=""
	for(var i = 0;i < len;i++){
		if (IDs == ""){
			IDs = rows[i].ID;
		}else{
			IDs = IDs + "," + rows[i].ID;
		}
	}
	
	//访问后台代码保存报表列
	$m({
		ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayFun',
		MethodName:'DelRptItem',
		rptItemID:rptItemID,
		rptID:rptID,
		rptItemIDS:IDs
	},function(text){
		$("#optionalRptColGrid").datagrid("reload");
		$("#selectedRptGrid").datagrid("reload");
		$("#rptColumnTable").datagrid("reload");
		myMsg(text);
	})
})
/*--报表项上移方法--*/
function rptItemMove(sign){
	var row = $("#rptCfgTable").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条报表项记录");
		return;
	}
	var rptID = row.ID;
	var row = $("#selectedRptGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择需要操作的报表列");
		return;
	}
	var index = $("#selectedRptGrid").datagrid("getRowIndex",row);
	var rows = $("#selectedRptGrid").datagrid("getRows");
	var len = rows.length;
	if (sign == "moveRight"){
		if (index < 1){
			myMsg("已经是第一个,无法上移");
			return;
		}
		var targetIndex = index-1;
	}else if(sign == "moveLeft"){
		if (index == (len-1)){
			myMsg("已经是最后一个,无法下移");
			return;
		}
		var targetIndex = index+1;
	}
	var ID,code,desc;
	ID = row.ID;
	code = row.selectedCode;
	desc = row.selectedDesc;
	$("#selectedRptGrid").datagrid("deleteRow",index);
	$('#selectedRptGrid').datagrid('insertRow',{
		index: targetIndex,	// index start with 0
		row: {
			ID: ID,
			selectedCode: code,
			selectedDesc: desc
		}
	});
	var rows = $("#selectedRptGrid").datagrid("getRows");
	var len = rows.length;
	var IDs = "";
	for (var i = 0;i < len;i++){
		if (IDs == ""){
			IDs = rows[i].ID;
		}else{
			IDs = IDs + "," + rows[i].ID;
		}
	}
	$m({
		ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayFun',
		MethodName:'UpdateItemOrder',
		rptID:rptID,
		rptItemList:IDs
	},function(text){
		myMsg(text);
		$("#selectedRptGrid").datagrid("reload");
		$("#rptColumnTable").datagrid("reload");
	})
}

/*--报表项新增--*/
$("#rptAddButton").click(function(e){
	$("#rptAddDialog").show();
	getDimProValue();
	$HUI.dialog("#rptAddDialog",{
		resizable:true,
		modal:true,
		iconCls:'icon-w-add',
		onClose:function(){
			$("#rptAddCode").val("");
			$("#rptAddDesc").val("");
			$('#rptAddDimPro').combogrid('clear');
		},
		buttons:[{
			text:'保存',
			handler:function(e){
				 var flag = $("#rptAddForm").form('validate');
				 if (!flag){
					myMsg("请按照提示填写内容");
					return;
				 } 
				 var dimValue = $("#rptAddDim").combobox("getText");
				 var rptCode = $("#rptAddCode").val();
				 var rptDesc = $("#rptAddDesc").val();
				 var dimProArr = $("#rptAddDimPro").combogrid("getValues");
				 var dimProStr = dimProArr.join(";"); 
				 $m({
					 ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayFun',
					 MethodName:'AddRPT',
					 rptCode:rptCode,
					 rptDesc:rptDesc,
					 rptDim:dimValue,
					 rptDimPro:dimProStr
				 },function(text){
					myMsg(text);
					$("#rptCfgTable").datagrid('reload');
					$HUI.dialog("#rptAddDialog").close();
				 })
				 //alert(dimValue+"^"+dimProStr+"^"+rptCode+"^"+rptDesc);
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#rptAddDialog").close();
			}
		}]
	})
})

/*--报表项修改--*/
$("#rptModifyButton").click(function(e){
	var row = $("#rptCfgTable").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条记录");
		return;
	}
	var ID,code,desc,dim,dimPro,dimProArr;
	ID = row.ID;
	code = row.rptCode;
	desc = row.rptDesc;
	dim = row.rptDim;
	dimPro = row.rptDimPro;
	var dimProArr = new Array(); //定义一数组 
    dimProArr = dimPro.split(";"); //字符分割
	$("#rptModifyCode").val(code);
	$("#rptModifyDesc").val(desc);
	$('#rptModifyDim').combobox('setValue',dim);
	$('#rptModifyDimPro').combogrid('setValues', dimProArr);
	$("#rptModifyForm").form('validate');   //表单验证
	$("#rptModifyDialog").show();
	$HUI.dialog("#rptModifyDialog",{
		resizable:true,
		modal:true,
		iconCls:'icon-w-edit',
		buttons:[{
			text:'保存',
			handler:function(e){
				 var flag = $("#rptModifyForm").form('validate');
				 if (!flag){
					myMsg("请按照提示填写内容");
					return;
				 }
				 var dimValue = $("#rptModifyDim").combobox("getText");
				 var rptCode = $("#rptModifyCode").val();
				 var rptDesc = $("#rptModifyDesc").val();
				 var dimProArr = $("#rptModifyDimPro").combogrid("getValues");
				 var dimProStr = dimProArr.join(";"); 
				 $m({
					 ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayFun',
					 MethodName:'ModifyRPT',
					 ID:ID,
					 rptCode:rptCode,
					 rptDesc:rptDesc,
					 rptDim:dimValue,
					 rptDimPro:dimProStr
				 },function(text){
					myMsg(text);
					$("#rptCfgTable").datagrid('reload');
					$HUI.dialog("#rptAddDialog").close();
				 })
				$HUI.dialog("#rptModifyDialog").close();
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#rptModifyDialog").close();
			}
		}]
	})
})

/*--报表项的删除--*/
$("#rptDeleteButton").click(function(e){
	var row = $("#rptCfgTable").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条记录");
		return;
	}
	var ID,code,desc,dim,dimPro,dimProArr;
	ID = row.ID;
	$.messager.confirm("删除", "删除后将不能恢复,确认删除么?", function (r) {
		if (r) {
			$m({
				ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayFun',
				MethodName:'DeleteRPT',
				rptDR:ID
			},function(text){
				myMsg(text);
				$("#rptCfgTable").datagrid('reload');
			})
			
		}
	});
})

/*--报表项查询--*/
$('#searchText').searchbox({
	searcher:function(value,name){
		rptObj.load({ClassName:"web.DHCWL.V1.MRIPDay.MRIPDayFun",QueryName:"GetRptInfor",filterValue:value});
	}
})

/*--报表列共有明细维护--*/
$("#rptAllDetailButton").click(function(e){
	var row = $("#rptCfgTable").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条记录");
		return;
	}
	var ID = row.ID;
	var rptDesc = row.rptDesc;
	var rptCode = row.rptCode;
	//待选明细表格
	$HUI.datagrid("#optionalRptColDetailGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayFun',
			QueryName:'GetOPTLDetailQuery',
			rptID:ID
		},
		fitColumns:true,
		toolbar:[]
	})
	
	//已选明细表格
	$HUI.datagrid("#selectedRptColDetailGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayFun',
			QueryName:'GetDetailRptItem',
			rptID:ID
		},
		fitColumns:true,
		toolbar:[]
	})
	
	var title = rptCode + ":" + rptDesc + "----共有明细维护";
	//明细维护界面
	$("#rptColDetailCfgDig").show();
	$HUI.dialog("#rptColDetailCfgDig",{
		iconCls:'icon-w-config',
		title:title,
		height:kpiBodyHeight-40,
		resizable:true,
		modal:true
	})
})

/*--公共明细右移--*/
$("#moveRightDetail").click(function(e){
	moveRightLeftDetail("right");
})

/*--公共明细左移--*/
$("#moveLeftDetail").click(function(e){
	moveRightLeftDetail("left");
})
/*--公共明细上移--*/
$("#moveDetailTop").click(function(e){
	moveTopBottomDetail("moveTop");
})
/*--公共明细下移--*/
$("#moveDetailBottom").click(function(e){
	moveTopBottomDetail("moveBottom");
})


/*--共有明细左右移动--*/
function moveRightLeftDetail(sign){
	//获取选中的报表项
	var row = $("#rptCfgTable").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条报表项记录");
		return;
	}
	var rptID = row.ID;
	
	if(sign == "left"){
		var row = $("#selectedRptColDetailGrid").datagrid("getSelected");
		if (!row){
			myMsg("请选择需要操作的明细");
			return;
		}
		var index = $("#selectedRptColDetailGrid").datagrid("getRowIndex",row);
		$("#selectedRptColDetailGrid").datagrid("deleteRow",index);
	}
	
	//获取已维护明细的ID列表
	var selectRows = $("#selectedRptColDetailGrid").datagrid("getRows");
	var len = selectRows.length;
	var selectItemIDs = "";
	for (var i = 0;i < len;i++){
		if (selectItemIDs == ""){
			selectItemIDs = selectRows[i].ID
		}else{
			selectItemIDs = selectItemIDs + "," + selectRows[i].ID;
		}
	}
	
	if (sign == "right"){
		//获取选中的待选共有明细
		var itemRow = $("#optionalRptColDetailGrid").datagrid("getSelected");
		if (!itemRow){
			myMsg("请先选择需要操作的明细");
			return;
		}
		var itemID = itemRow.ID;
		if (selectItemIDs){
			selectItemIDs = selectItemIDs + "," + itemID;
		}else{
			selectItemIDs = itemID;
		}
	}
	
	//访问后台代码保存更新
	$m({
		ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayFun',
		MethodName:'AddDetailRptItem',
		itemID:"",
		rptID:rptID,
		itemDesc:"",
		itemList:selectItemIDs
	},function(text){
		myMsg(text);
		$("#selectedRptColDetailGrid").datagrid("reload");
		$("#optionalRptColDetailGrid").datagrid("reload");
	})
}

/*--公共明细的上下移动--*/
function moveTopBottomDetail(sign){
	var row = $("#selectedRptColDetailGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择需要操作的明细");
		return;
	}
	var index = $("#selectedRptColDetailGrid").datagrid("getRowIndex",row);
	var rows = $("#selectedRptColDetailGrid").datagrid("getRows");
	var len = rows.length;
	if (sign == "moveTop"){
		if (index < 1){
			myMsg("已经是第一个,无法上移");
			return;
		}
		var targetIndex = index-1;
	}else if(sign == "moveBottom"){
		if (index == (len-1)){
			myMsg("已经是最后一个,无法下移");
			return;
		}
		var targetIndex = index+1;
	}
	var ID,code,desc;
	ID = row.ID;
	code = row.selectedCode;
	desc = row.selectedDesc;
	$("#selectedRptColDetailGrid").datagrid("deleteRow",index);
	$('#selectedRptColDetailGrid').datagrid('insertRow',{
		index: targetIndex,	// index start with 0
		row: {
			ID: ID,
			selectedCode: code,
			selectedDesc: desc
		}
	});
	moveRightLeftDetail(sign);
}

 /*--查看统计组明细--*/
 function linkViewDetailGrid(value,row,index){
		return "<a href='javascript:void(0)' onclick='viewDetailFun(\""+row.ID+"\")' title='查看明细信息'>\
			"+"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/apply_check.png' />"+"\
			</a>";
 }
 
 /*--维护统计组私有明细--*/
 function linkPrivateDetailGrid(value,row,index){
		return "<a href='javascript:void(0)' onclick='configDetailFun(\""+row.ID+"\")' title='配置私有明细信息'>\
			"+"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/batch_cfg.png' />"+"\
			</a>";
 }
 
 /*--查看明细--*/
 function viewDetailFun(){
	 	
	//明细展示表格
	$HUI.datagrid("#viewRptColDetailGrid",{
		fitColumns:true
	})
	
	//明细展示界面
	$("#viewRptColDetailCfgDig").show();
	$HUI.dialog("#viewRptColDetailCfgDig",{
		iconCls:'icon-w-config',
		height:kpiBodyHeight-40,
		resizable:true,
		modal:true
	})
 }
 
 /*--配置私有明细--*/
 function configDetailFun(rptColID){
	var rows = $("#rptColumnTable").datagrid("getRows");
	var len = rows.length,rptRow = "";
	
	for (var i = 0;i < len;i++){
		if (rows[i].ID == rptColID){
			$("#rptColumnTable").datagrid("selectRow",i)
			rptRow = rows[i];
		}
	}
	
	if (!rptRow){
		myMsg("获取报表项失败");
		return;
	}
	var rptColID,rptColCode,rptColDesc,title;
	rptColID = rptRow.ID;
	rptColCode = rptRow.colCode;
	rptColDesc = rptRow.colDesc;
	title = rptColCode + ":" +rptColDesc + "------报表列私有明细配置";
	
	//获取选中的报表项
	var row = $("#rptCfgTable").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条报表项记录");
		return;
	}
	var ID = row.ID;
	
	 //待选明细表格
	$HUI.datagrid("#optionalPrivateDetailGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayFun',
			QueryName:'GetOPTLDetailQuery',
			rptID:ID,
			exceptRptDR:rptColID
		},
		fitColumns:true,
		toolbar:[]
	})
	
	//已选明细表格
	$HUI.datagrid("#selectedPrivateDetailGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayFun',
			QueryName:'GetDetailRptItem',
			rptID:ID,
			OPTLItem:rptColID
		},
		fitColumns:true,
		toolbar:[]
	})
	
	//明细维护界面
	$("#rptPrivateDetailCfgDig").show();
	$HUI.dialog("#rptPrivateDetailCfgDig",{
		iconCls:'icon-w-config',
		height:kpiBodyHeight-40,
		resizable:true,
		modal:true,
		title:title
	})
 }
 
 
 /*--私有明细右移动--*/
 $("#moveRightPrivateDetail").click(function(e){
	 moveLRPrivateDetail("right");
 })
 /*--私有明细左移动--*/
 $("#moveLeftPrivateDetail").click(function(e){
	 moveLRPrivateDetail("left");
 })
  /*--私有明细上移动--*/
 $("#moveDetailPrivateTop").click(function(e){
	 movePrivateTBDetail("moveTop");
 })
  /*--私有明细下移动--*/
 $("#moveDetailPrivateBottom").click(function(e){
	 movePrivateTBDetail("moveBottom");
 })
 
 
 
 /*--私有明细左右移动--*/
function moveLRPrivateDetail(sign){
	//获取选中的报表项
	var row = $("#rptCfgTable").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条报表项记录");
		return;
	}
	var rptID = row.ID;
	
	//获取选中的报表列
	var rptColRow = $("#rptColumnTable").datagrid("getSelected");
	if (!rptColRow){
		myMsg("获取报表列失败");
		return;
	}
	var rptColID = rptColRow.ID;
	var rptColDesc = rptColRow.colDesc;
	
	if(sign == "left"){
		var row = $("#selectedPrivateDetailGrid").datagrid("getSelected");
		if (!row){
			myMsg("请选择需要操作的明细");
			return;
		}
		var index = $("#selectedPrivateDetailGrid").datagrid("getRowIndex",row);
		$("#selectedPrivateDetailGrid").datagrid("deleteRow",index);
	}
	
	//获取已维护明细的ID列表
	var selectRows = $("#selectedPrivateDetailGrid").datagrid("getRows");
	var len = selectRows.length;
	var selectItemIDs = "";
	for (var i = 0;i < len;i++){
		if (selectItemIDs == ""){
			selectItemIDs = selectRows[i].ID
		}else{
			selectItemIDs = selectItemIDs + "," + selectRows[i].ID;
		}
	}
	
	if (sign == "right"){
		//获取选中的待选共有明细
		var itemRow = $("#optionalPrivateDetailGrid").datagrid("getSelected");
		if (!itemRow){
			myMsg("请先选择需要操作的明细");
			return;
		}
		var itemID = itemRow.ID;
		if (selectItemIDs){
			selectItemIDs = selectItemIDs + "," + itemID;
		}else{
			selectItemIDs = itemID;
		}
	}
	
	//访问后台代码保存更新
	$m({
		ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayFun',
		MethodName:'AddDetailRptItem',
		itemID:rptColID,
		rptID:rptID,
		itemDesc:rptColDesc,
		itemList:selectItemIDs
	},function(text){
		myMsg(text);
		$("#selectedPrivateDetailGrid").datagrid("reload");
		$("#optionalPrivateDetailGrid").datagrid("reload");
	})
}

/*--私有明细的上下移动--*/
function movePrivateTBDetail(sign){
	var row = $("#selectedPrivateDetailGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择需要操作的明细");
		return;
	}
	var index = $("#selectedPrivateDetailGrid").datagrid("getRowIndex",row);
	var rows = $("#selectedPrivateDetailGrid").datagrid("getRows");
	var len = rows.length;
	if (sign == "moveTop"){
		if (index < 1){
			myMsg("已经是第一个,无法上移");
			return;
		}
		var targetIndex = index-1;
	}else if(sign == "moveBottom"){
		if (index == (len-1)){
			myMsg("已经是最后一个,无法下移");
			return;
		}
		var targetIndex = index+1;
	}
	var ID,code,desc;
	ID = row.ID;
	code = row.selectedCode;
	desc = row.selectedDesc;
	$("#selectedPrivateDetailGrid").datagrid("deleteRow",index);
	$('#selectedPrivateDetailGrid').datagrid('insertRow',{
		index: targetIndex,	// index start with 0
		row: {
			ID: ID,
			selectedCode: code,
			selectedDesc: desc
		}
	});
	moveLRPrivateDetail(sign);
}
 
 
 
 
 /*--报表项新增维度选择--*/
 $("#rptAddDim").combobox({
	onSelect:function(record){
		getDimProValue();
	}
 });
 
 /*--获取维度属性下拉框的值--*/
function getDimProValue(){
	var dimValue = $("#rptAddDim").combobox("getValue")
	if (!dimValue){
		return;
	}
	var dimProObj = $HUI.combogrid("#rptAddDimPro");
	var grid = dimProObj.grid();
	//console.log(grid);
	grid.datagrid("load",{ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayFun',QueryName:'GetDimProQuery',dimCode:dimValue});
}

/*--鼠标悬停维度描述单元格响应方法--*/
function formatCellTooltip(value){  
	return "<span id='verylongText' title='" + value + "'>" + value + "</span>";  
}

/*--上下左右图片提示--*/
/*$HUI.tooltip('#moveRight,#moveRightDetail',{
	content:'<span>移入</span>',
	position:'bottom'
})
$HUI.tooltip('#moveLeft,#moveLeftDetail',{
	content:'<span">移出</span>',
	position:'bottom'
})
$HUI.tooltip('#moveTop,#moveTopDetail',{
	content:'<span">上移</span>',
	position:'bottom'
})
$HUI.tooltip('#moveBottom,#moveBottomDetail',{
	content:'<span">下移</span>',
	position:'bottom'
})*/













