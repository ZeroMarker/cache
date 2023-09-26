/// Creator   : wk
/// CreatDate : 2018-09-29
/// Desc      : 考核指标维护

var kpiObj = $HUI.datagrid("#kpiGrid",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.CheckFun.KPICfg',
		QueryName:'GetKPI'
	},
	fitColumns:true,
	pagination:true,
	pageList:[15,20,50,100],
	pageSize:15,
	toolbar:'#kpiToobar'
})

/*--指标检索--*/
$('#searchText').searchbox({
	searcher:function(value,name){
		$("#kpiGrid").datagrid("load",{ClassName:'web.DHCWL.V1.CheckFun.KPICfg',QueryName:'GetKPI',filterValue:value});
	}
})

/*--指标新增--*/
$("#addButton").click(function(e){
	$("#kpiAddInforForm").form('reset');    //内容重置
	$("#kpiAddDialog").show();
	$HUI.dialog("#kpiAddDialog",{
		iconCls:'icon-w-add',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#kpiAddInforForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var code,desc,isValid;
				code = $("#kpiCode").val();
				desc = $("#kpiDesc").val();
				isValid = $("#isValid").combobox("getText");
				
				$m({
					ClassName:'web.DHCWL.V1.CheckFun.KPICfg',
					MethodName:'AddCheckFunKpi',
					code:code,
					desc:desc,
					isValid:isValid
				},function(text){
					myMsg(text);
					$("#kpiGrid").datagrid("reload");
					$HUI.dialog("#kpiAddDialog").close();
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#kpiAddDialog").close();
			}
		}]
	})
})

/*--指标修改--*/
$("#modifyButton").click(function(e){
	$("#kpiModInforForm").form('reset');    //内容重置
	var row = $("#kpiGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择需要修改的指标");
		return;
	}
	var kpiID = row.ID;
	$("#kpiModCode").val(row.code);
	$("#kpiModDesc").val(row.desc);
	$("#isValidMod").combobox('setValue',row.isValid);
	$("#kpiModInforForm").form('validate');
	$("#kpiModDialog").show();
	$HUI.dialog("#kpiModDialog",{
		iconCls:'icon-w-edit',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#kpiModInforForm").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var code,desc,isValid;
				code = $("#kpiModCode").val();
				desc = $("#kpiModDesc").val();
				isValid = $("#isValidMod").combobox("getText");
				$m({
					ClassName:'web.DHCWL.V1.CheckFun.KPICfg',
					MethodName:'UpdateCheckFunKpi',
					ID:kpiID,
					code:code,
					desc:desc,
					isValid:isValid
				},function(text){
					myMsg(text);
					$("#kpiGrid").datagrid("reload");
					$HUI.dialog("#kpiModDialog").close();
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#kpiModDialog").close();
			}
		}]
	})
})
/*--指标删除--*/
/*$("#deleteButton").click(function(e){
	var kpiRow = $("#kpiGrid").datagrid("getSelected");
	if (!kpiRow){
		myMsg("请先选择需要删除的考核指标");
		return;
	}
	var kpiID = kpiRow.ID;
	$.messager.confirm("提示", "删除后将不能恢复,确认删除么？", function (r) {
		if (r) {
			
		}
	});
})*/