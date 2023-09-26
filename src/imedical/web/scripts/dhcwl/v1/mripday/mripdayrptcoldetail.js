﻿/**
* Creator   : wk
* CreatDate : 2018-08-30
* Desc      : 报表列明细维护界面
**/

var CAL_ROWID = "";
var kpiBodyHeight = getViewportOffset().y-40;
/*--报表列明细列表--*/
var rptColObj = $HUI.datagrid("#rptColItemTable",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayDetailFun',
		QueryName:'GetRptDetail'
	},
	//striped:true,
	fitColumns:true,
	pagination:true,
	pageSize:15,
	pageList:[10,15,20,50,100],
	toolbar:"#rptColItemToobar"
})

/*--报表列明细查询--*/
$('#searchText').searchbox({
	searcher:function(value,name){
		rptColObj.load({ClassName:"web.DHCWL.V1.MRIPDay.MRIPDayDetailFun",QueryName:"GetRptDetail",filterValue:value});
	}
})

/*--报表列明细新增--*/
$("#addButton").click(function(e){
	var dimProID,dimProCode;
	//下拉框展示指标
	var codecbgObj = $HUI.combogrid("#rptColItemType",{
		panelWidth:306,
		url:$URL+"?ClassName=web.DHCWL.V1.MRIPDay.MRIPDayDetailFun&QueryName=GetDimPro",
		mode:'remote',
		delay:200,
		idField:'ID',
		textField:'code',
		onBeforeLoad:function(param){
			param.filterValue = param.q;
		},
		onSelect:function(record){
			var trObj,grid,row;
			trObj = $HUI.combogrid("#rptColItemType");
			grid = trObj.grid();
			row = grid.datagrid("getSelected");
			dimProCode = row.code;
			dimProID = row.ID;
		},
		columns:[[
			{field:'ID',title:'ID',width:100,hidden:true},
			{field:'code',title:'编码',width:130},
			{field:'name',title:'名称',width:150},
			{field:'desc',title:'描述',width:180,hidden:true}
		]],
		onHidePanel:function(){
			clearKeyWord(this);
		}
	});
	
	$("#itemAddForm").form('reset'); 
	$("#itemAddDialog").show();
	$HUI.dialog("#itemAddDialog",{
		resizable:true,
		iconCls:'icon-w-add',
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#itemAddForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var code = $("#rptColItemCode").val();
				var desc = $("#rptColItemDesc").val();
				$m({
					ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayDetailFun',
					MethodName:'AddOPTLDetail',
					code:code,
					desc:desc,
					dimProCode:dimProCode,
					dimProID:dimProID
				},function(text){
					myMsg(text);
					$("#rptColItemTable").datagrid("reload");
					$HUI.dialog("#itemAddDialog").close();
				})
				//alert(code+","+desc+","+dimProCode+","+dimProID);
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#itemAddDialog").close();
			}
		}]
	})
})

/*--报表明细修改--*/
$("#modifyButton").click(function(e){
	var row = $("#rptColItemTable").datagrid("getSelected");
	if (!row){
		myMsg("请先选择需要修改的明细");
		return;
	}
	$("#rptModifyForm").form('reset');
	$("#itemModifyDialog").show();
	var ID,code,desc;
	ID = row.ID;
	code = row.code;
	desc = row.desc;
	$("#rptColItemModifyCode").val(code);
	$("#rptColItemModifyDesc").val(desc);
	$("#rptModifyForm").form('validate');
	$HUI.dialog("#itemModifyDialog",{
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
				var desc = $("#rptColItemModifyDesc").val();
				$m({
					ClassName:"web.DHCWL.V1.MRIPDay.MRIPDayDetailFun",
					MethodName:"ModifyOPTLDetail",
					ID:ID,
					desc:desc
				},function(text){
					myMsg(text);
					$HUI.dialog("#itemModifyDialog").close();
					$("#rptColItemTable").datagrid("reload");
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#itemModifyDialog").close();
			}
		}]
	})
})


/*--报表明细删除--*/
$("#deleteButton").click(function(e){
	var row = $("#rptColItemTable").datagrid("getSelected");
	if (!row){
		myMsg("请先选择需要删除的明细");
		return;
	}
	var ID = row.ID;
	$.messager.confirm("提示", "确定删除么？", function (r) {
		if (r) {
			$m({
				ClassName:"web.DHCWL.V1.MRIPDay.MRIPDayDetailFun",
				MethodName:"DeleteOPTLDetail",
				ID:ID
			},function(text){
				myMsg(text);
				$("#rptColItemTable").datagrid("reload");
			})
		}
	});
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
