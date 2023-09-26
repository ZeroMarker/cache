/// Creator   : wk
/// CreatDate : 2018-09-21
/// Desc      : 医技工作量维护

//获取屏幕高度
var kpiBodyHeight = getViewportOffset().y;
var kpiBodyWidth = getViewportOffset().x;
var dialogHeight = kpiBodyHeight > 600 ? 600 : kpiBodyHeight;
var editIndex;


/*--大组维护表格--*/
var grpObj = $HUI.datagrid("#grpTable",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.WL.WLGroupCfgFun',
		QueryName:'GetGrp'
	},
	fitColumns:true,
	toolbar:'#grpToobar',
	pagination:true,
	pageList:[10,15,20,50,100,500],
	onClickRow:function(rowIndex, rowData){
		var grpID = rowData.ID;
		$("#subGrpTable").datagrid("load",{ClassName:'web.DHCWL.V1.WL.WLGroupCfgFun',QueryName:'GetSubGrp',grpID:grpID});
	},
	onLoadSuccess:function(data){
		$('#subGrpTable').datagrid('loadData',{total:0,rows:[]})
	}
})

/*--大组新增--*/
$("#addButton").click(function(e){
	$("#grpAddForm").form('reset');    //内容重置
	$("#grpAddDialog").show();
	$HUI.dialog("#grpAddDialog",{
		iconCls:'icon-w-add',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#grpAddForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var code = $("#grpAddCode").val();
				var desc = $("#grpAddDesc").val();
				var IItem = $("#grpIAddCombo").combobox('getValue');
				var OItem = $("#grpOAddCombo").combobox('getValue');
				var EItem = $("#grpEAddCombo").combobox('getValue');
				var HItem = $("#grpHAddCombo").combobox('getValue');
				
				$m({
					ClassName:'web.DHCWL.V1.WL.WLGroupCfgFun',
					MethodName:'AddGrp',
					code:code,
					desc:desc,
					IItem:IItem,
					OItem:OItem,
					EItem:EItem,
					HItem:HItem
				},function(text){
					myMsg(text);
					$HUI.dialog("#grpAddDialog").close();
					$("#grpTable").datagrid('reload');
					
				})
				//$HUI.dialog("#grpAddDialog").close();
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#grpAddDialog").close();
			}
		}]
	})
})

/*--大组修改--*/
$("#modifyButton").click(function(e){
	var row = $("#grpTable").datagrid("getSelected");
	if (!row){
		myMsg("请选择一条大组");
		return;
	}
	var ID = row.ID;
	$("#grpModForm").form('reset');    //内容重置
	$("#grpModCode").val(row.code);
	$("#grpModDesc").val(row.desc);
	$("#grpIModCombo").combobox('setValue',row.IItem);
	$("#grpOModCombo").combobox('setValue',row.OItem);
	$("#grpEModCombo").combobox('setValue',row.EItem);
	$("#grpHModCombo").combobox('setValue',row.HItem);
	$("#grpModForm").form('validate');
	$("#grpModDialog").show();
	$HUI.dialog("#grpModDialog",{
		iconCls:'icon-w-edit',
		resizable:true,
		modal:true,
		buttons:[{
			text:"保存",
			handler:function(e){
				var flag = $("#grpModForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var IItem,OItem,EItem,HItem,code,desc;
				IItem = $("#grpIModCombo").combobox('getText');
				IItem = getCodeByDesc(IItem);
				OItem = $("#grpOModCombo").combobox('getText');
				OItem = getCodeByDesc(OItem);
				EItem = $("#grpEModCombo").combobox('getText');
				EItem = getCodeByDesc(EItem);
				HItem = $("#grpHModCombo").combobox('getText');
				HItem = getCodeByDesc(HItem);
				desc = $("#grpModDesc").val();
				$m({
					ClassName:'web.DHCWL.V1.WL.WLGroupCfgFun',
					MethodName:'UpdateGrp',
					ID:ID,
					desc:desc,
					IItem:IItem,
					OItem:OItem,
					EItem:EItem,
					HItem:HItem
				},function(text){
					myMsg(text);
					$HUI.dialog("#grpModDialog").close();
					$("#grpTable").datagrid('reload');
				})
				//$HUI.dialog("#grpModDialog").close();
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#grpModDialog").close();
			}
		}]
	})
})

/*--大组删除--*/
$("#deleteButton").click(function(e){
	var grpRow = $("#grpTable").datagrid("getSelected");
	if (!grpRow){
		myMsg("请先选择需要删除的大组");
		return;
	}
	var grpID = grpRow.ID;
	$.messager.confirm("提示", "删除后将不能恢复,确认删除么?", function (r) {
		if (r) {
			$m({
				ClassName:'web.DHCWL.V1.WL.WLGroupCfgFun',
				MethodName:'DeleteGrp',
				grpID:grpID
			},function(e){
				myMsg(e);
				$("#grpTable").datagrid("reload");
			})
		}
	});
})

/*--大组数据查询--*/
$('#searchGrpApp').searchbox({
	searcher:function(value,name){
		$("#grpTable").datagrid("load",{ClassName:'web.DHCWL.V1.WL.WLGroupCfgFun',QueryName:'GetGrp',filterValue:value});
	}
})


/*--子组表格维护--*/
var subGrp = $HUI.datagrid("#subGrpTable",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.WL.WLGroupCfgFun',
		QueryName:'GetSubGrp'
	},
	fitColumns:true,
	pagination:true,
	pageSize:15,
	pageList:[10,15,20,50,100],
	toolbar:'#subGrpToobar'
})

/*--子组新增--*/
$("#subGrpAddButton").click(function(e){
	var grpRow = $("#grpTable").datagrid("getSelected");
	if (!grpRow){
		myMsg("请先选择一条大组");
		return;
	}
	var grpID = grpRow.ID;
	$("#subGrpAddForm").form('reset');    //内容重置
	$("#subGrpAddDialog").show();
	$HUI.dialog("#subGrpAddDialog",{
		iconCls:'icon-w-add',		
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#subGrpAddForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var code = $("#subGrpAddCode").val();
				var desc = $("#subGrpAddDesc").val();
				var IItem = $("#subGrpIAddCombo").combobox('getValue');
				var OItem = $("#subGrpOAddCombo").combobox('getValue');
				var EItem = $("#subGrpEAddCombo").combobox('getValue');
				var HItem = $("#subGrpHAddCombo").combobox('getValue');
				
				$m({
					ClassName:'web.DHCWL.V1.WL.WLGroupCfgFun',
					MethodName:'AddSubGrp',
					grpID:grpID,
					code:code,
					desc:desc,
					IItem:IItem,
					OItem:OItem,
					EItem:EItem,
					HItem:HItem
				},function(text){
					myMsg(text);
					$HUI.dialog("#subGrpAddDialog").close();
					$("#subGrpTable").datagrid('reload');
					
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#subGrpAddDialog").close();
			}
		}]
	});
})

/*--子组修改--*/
$("#subGrpModifyButton").click(function(e){
	$("#subGrpModForm").form('reset');    //内容重置
	var subGrpRow = $("#subGrpTable").datagrid("getSelected");
	if (!subGrpRow){
		myMsg("请先选择一条子组记录");
		return;
	}
	var subGrpID=subGrpRow.ID;
	$("#subGrpModCode").val(subGrpRow.code);
	$("#subGrpModDesc").val(subGrpRow.desc);
	$("#subGrpIModCombo").combobox('setValue',subGrpRow.IItem);
	$("#subGrpOModCombo").combobox('setValue',subGrpRow.OItem);
	$("#subGrpEModCombo").combobox('setValue',subGrpRow.EItem);
	$("#subGrpHModCombo").combobox('setValue',subGrpRow.HItem);
	$("#subGrpModForm").form('validate');
	$("#subGrpModDialog").show();
	$HUI.dialog("#subGrpModDialog",{
		iconCls:'icon-w-edit',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var desc,IItem,OItem,EItem,HItem;
				desc = $("#subGrpModDesc").val();
				IItem = $("#subGrpIModCombo").combobox('getText');
				IItem = getCodeByDesc(IItem);
				OItem = $("#subGrpOModCombo").combobox('getText');
				OItem = getCodeByDesc(OItem);
				EItem = $("#subGrpEModCombo").combobox('getText');
				EItem = getCodeByDesc(EItem);
				HItem = $("#subGrpHModCombo").combobox('getText');
				HItem = getCodeByDesc(HItem);
				
				$m({
					ClassName:'web.DHCWL.V1.WL.WLGroupCfgFun',
					MethodName:'UpdateSubGrp',
					ID:subGrpID,
					desc:desc,
					IItem:IItem,
					OItem:OItem,
					EItem:EItem,
					HItem:HItem
				},function(text){
					myMsg(text);
					$("#subGrpTable").datagrid("reload");
					$HUI.dialog("#subGrpModDialog").close();
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#subGrpModDialog").close();
			}
		}]
	});
})

/*--子组删除--*/
$("#subGrpDeleteButton").click(function(e){
	var subGrpRow = $("#subGrpTable").datagrid("getSelected");
	if(!subGrpRow){
		myMsg("请先选择需要删除的子组");
		return;
	}
	var subGrpID = subGrpRow.ID;
	$.messager.confirm("提示", "删除后将不能恢复,确认删除么?", function (r) {
		if (r) {
			$m({
				ClassName:'web.DHCWL.V1.WL.WLGroupCfgFun',
				MethodName:'DeleteSubGrp',
				subGrpID:subGrpID
			},function(e){
				myMsg(e);
				$("#subGrpTable").datagrid("reload");
			})
		}
	});
})


/*--子组查询--*/
$('#searchSubGrpApp').searchbox({
	searcher:function(value,name){
		var grpRow = $("#grpTable").datagrid("getSelected");
		if (!grpRow){
			return;
		}
		var grpID = grpRow.ID;
		$("#subGrpTable").datagrid("load",{ClassName:'web.DHCWL.V1.WL.WLGroupCfgFun',QueryName:'GetSubGrp',grpID:grpID,filterValue:value});
	}
})


var ItemList = [
    {flagValue:'计费',flagName:'计费'},
    {flagValue:'执行',flagName:'执行'},
	{flagValue:'检验接口',flagName:'检验接口'},
	{flagValue:'检查接口',flagName:'检查接口'},
	{flagValue:'护士执行',flagName:'护士执行'},
];


/*--明细维护--*/
$("#subGrpDetailButton").click(function(e){
	$('#searchGrpDetailApp').searchbox('setValue', '');
	$('#searchGrpSelectDetail').searchbox('setValue', '');
	var subGrpRow = $("#subGrpTable").datagrid("getSelected");
	if (!subGrpRow){
		myMsg("请先选择一条子组");
		return;
	}
	var subGrpID = subGrpRow.ID;
	$HUI.datagrid("#grpSelectDetailGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.WL.WLGroupCfgFun',
			QueryName:'GetCfgDetail',
			subGrpID:subGrpID
		},
		columns:[[
			{field:'ID',title:'ID',width:100,hidden:true},
			{field:'grpDetailID',title:'ID',width:100},
			{field:'desc',title:'描述',width:100,formatter:formatCellTooltip},
			{field:'IItem',title:'住院口径',width:100,editor:{type:'combobox',options:{valueField:'flagValue',textField:'flagName',data:ItemList}}},
			{field:'OItem',title:'门诊口径',width:100,editor:{type:'combobox',options:{valueField:'flagValue',textField:'flagName',data:ItemList}}},
			{field:'EItem',title:'急诊口径',width:100,editor:{type:'combobox',options:{valueField:'flagValue',textField:'flagName',data:ItemList}}},
			{field:'HItem',title:'检验口径',width:100,editor:{type:'combobox',options:{valueField:'flagValue',textField:'flagName',data:ItemList}}},
		]],
		fitColumns:true,
		pagination:true,
		pageList:[10,15,20,50],
		pageSize:15,
		toolbar:"#grpSelectDetailToobar",
		onClickCell:function(index, field, value){
			if (endEditing()){
				if ((field=="IItem")||(field=="EItem")||(field=="OItem")||(field=="HItem")){
					$(this).datagrid("beginEdit",index);
				}
				editIndex = index;
			}
		}
	})
	
	$HUI.datagrid("#grpAllDetailGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.WL.WLGroupCfgFun',
			QueryName:'GetAllDetail',
			subGrpID:subGrpID
			
		},
		pagination:true,
		pageList:[10,15,20,50],
		pageSize:15,
		fitColumns:true,
		toolbar:'#grpDetailToobar'
	});
	
	$("#grpDetailDialog").show();
	$HUI.dialog("#grpDetailDialog",{
		height:dialogHeight-10,
		iconCls:'icon-w-config',
		resizable:true,
		modal:true
	});
})


/*--已维护明细删除、全部删除、检索--*/
$("#selectDetailDelete").click(function(e){
	var row = $("#grpSelectDetailGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条明细");
		return;
	}
	var detailID = row.ID;
	
	$.messager.confirm("提示", "删除后将不能恢复,确认删除么?", function (r) {
		if (r) {
			$m({
				ClassName:'web.DHCWL.V1.WL.WLGroupCfgFun',
				MethodName:'DeleteSelectDetail',
				detailID:detailID
			},function(text){
				myMsg(text);
				$("#grpSelectDetailGrid").datagrid("reload");
				$("#grpAllDetailGrid").datagrid("reload");
			})
		}
	});
})
$("#selectAllDetailDelete").click(function(e){
	var subGrpRow = $("#subGrpTable").datagrid("getSelected");
	if (!subGrpRow){
		return;
	}
	var subGrpID = subGrpRow.ID;
	$.messager.confirm("提示", "删除后将不能恢复,确认删除么?", function (r) {
		if (r) {
			$m({
				ClassName:'web.DHCWL.V1.WL.WLGroupCfgFun',
				MethodName:'DeleteAllDetail',
				subGrpID:subGrpID
			},function(text){
				myMsg(text);
				$("#grpSelectDetailGrid").datagrid("reload");
				$("#grpAllDetailGrid").datagrid("reload");
			})
		}
	});
})
/*--已维护明细框检索--*/
$('#searchGrpSelectDetail').searchbox({
	searcher:function(value,name){
		var subGrpRow = $("#subGrpTable").datagrid("getSelected");
		if (!subGrpRow){
			myMsg("请先选择一条子组");
			return;
		}
		var subGrpID = subGrpRow.ID;
		$("#grpSelectDetailGrid").datagrid("load",{ClassName:'web.DHCWL.V1.WL.WLGroupCfgFun',QueryName:'GetCfgDetail',subGrpID:subGrpID,filterValue:value});
	}
})

/*-所有明细点击新增按钮--*/
$("#grpDetailAddButton").click(function(e){
	var subGrpRow = $("#subGrpTable").datagrid("getSelected");
	if (!subGrpRow){
		return;
	}
	var subGrpID = subGrpRow.ID;
	
	var detailRows = $("#grpAllDetailGrid").datagrid("getChecked");
	var len = detailRows.length;
	if (len < 1){
		myMsg("请先选择需要增加的明细");
		return;
	}
	var details = "";
	for (var i = 0;i < len;i++){
		if (details == ""){
			details = detailRows[i].ID + "#" +detailRows[i].code;
		}else{
			details = details + "," + detailRows[i].ID + "#" +detailRows[i].code; 
		}
	}
	
	$m({
		ClassName:'web.DHCWL.V1.WL.WLGroupCfgFun',
		MethodName:'AddGrpDetail',
		details:details, 
		subGrpID:subGrpID
	},function(text){
		myMsg(text);
		$("#grpSelectDetailGrid").datagrid("reload");
		$("#grpAllDetailGrid").datagrid("reload");
	})
	//alert(details+"^"+subGrpID);
})

/*--所有明细查询--*/
$('#searchGrpDetailApp').searchbox({
	searcher:function(value,name){
		var subGrpRow = $("#subGrpTable").datagrid("getSelected");
		if (!subGrpRow){
			myMsg("请先选择一条子组");
			return;
		}
		var subGrpID = subGrpRow.ID;
		$("#grpAllDetailGrid").datagrid("load",{ClassName:'web.DHCWL.V1.WL.WLGroupCfgFun',QueryName:'GetAllDetail',subGrpID:subGrpID,filterValue:value});
	}
})



/*--通过类型描述获取编码--*/
function getCodeByDesc(desc){
	var typeCode = desc;
	switch(desc){
		case "计费":
			typeCode = "JF";
			break;
		case "执行":
			typeCode = "EXE";
			break;
		case "检验接口":
			typeCode = "JYInter";
			break;
		case "检查接口":
			typeCode = "JCInter";
			break;
		case "护士执行":
			typeCode = "HSZX";
			break;
	}
	return typeCode;
}

 function formatCellTooltip(value){  
	return "<span id='verylongText' title='" + value + "'>" + value + "</span>";  
}


function endEditing() {           //该方法用于关闭上一个焦点的editing状态	
	if (editIndex == undefined) {		
		return true	
	}	
	if ($('#grpSelectDetailGrid').datagrid('validateRow', editIndex)) {
		$('#grpSelectDetailGrid').datagrid('endEdit', editIndex);		
		editIndex = undefined;
		var rows = $("#grpSelectDetailGrid").datagrid("getChanges","updated");
		var len = rows.length;
		var str = "";
		for (var i = 0;i < len;i++){
			var IItem,OItem,EItem,HItem;
			IItem = getCodeByDesc(rows[i].IItem);
			OItem = getCodeByDesc(rows[i].OItem);
			EItem = getCodeByDesc(rows[i].EItem);
			HItem = getCodeByDesc(rows[i].HItem);
			if (str == ""){
				str = rows[i].ID + "^" + IItem + "^" + OItem + "^" +EItem + "^" + HItem;
			}else{
				str = str + "," + rows[i].ID + "^" + IItem + "^" + OItem + "^" +EItem + "^" + HItem;
			}
		}
		if (str == ""){
			return true;
		}
		$m({
			ClassName:'web.DHCWL.V1.WL.WLGroupCfgFun',
			MethodName:'UpdateGrpDetail',
			strs:str
		},function(e){
			if (e == "fail"){
				myMsg("更新失败");
			}
			$("#grpSelectDetailGrid").datagrid("reload");
		})
		//console.log(str);
		return true;	
	}else {
		return false;	
	}
}
