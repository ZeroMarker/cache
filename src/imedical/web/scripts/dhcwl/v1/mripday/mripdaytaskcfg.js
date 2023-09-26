
var kpiBodyHeight = getViewportOffset().y - 40;
/*--鼠标悬停维度描述单元格响应方法--*/
function formatCellTooltip(value){  
	return "<span id='verylongText' title='" + value + "'>" + value + "</span>";  
}

$(document).ready(function(){


/*--出院对应设置--*/
$HUI.datagrid("#outHosContract",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayTask',
		QueryName:'GetOutHosGrid'
	},
	fitColumns:true,
	toolbar:[{
		text:'修改',
		iconCls:'icon-write-order',
		handler:function(e){
			var row = $("#outHosContract").datagrid("getSelected");
			if (!row){
				myMsg("请先选择需要修改的记录");
				return;
			}
			var ID = row.ID;
			var desc = row.desc;
			var descSet = row.descSet;
			$("#outHosModifyForm").form('reset');
			$("#outHosDesc").val(desc);
			$("#outHosGroup").combobox('setValue',descSet);
			 $("#outHosModifyForm").form('validate');
			$("#outHosModifyDialog").show();
			$HUI.dialog("#outHosModifyDialog",{
				iconCls:'icon-w-edit',
				resizable:true,
				modal:true,
				buttons:[{
					text:'保存',
					handler:function(e){
						var flag = $("#outHosModifyForm").form('validate');
						if (!flag){
							myMsg("请按照提示填写内容");
							return;
						}
						var value = $("#outHosGroup").combobox('getValue');
						var index = $("#outHosContract").datagrid("getRowIndex",row);
						$('#outHosContract').datagrid('updateRow',{
							index: index,
							row: {
								ID  : ID,
								desc: desc,
								descSet: value
							}
						});
						var rows,len,strs;
						rows = $("#outHosContract").datagrid("getRows");
						len = rows.length;
						strs = ""
						for (var i = 0;i < len ; i++){
							if (strs == ""){
								strs = rows[i].ID + "^" + rows[i].desc + "^" +rows[i].descSet;
							}else{
								strs = strs + "|" + rows[i].ID + "^" + rows[i].desc + "^" +rows[i].descSet;
							}
						}
						$m({
							ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayTask',
							MethodName:'SaveDisCondicionts',
							str:strs
						},function(e){
							if (e == "ok"){
								e = "保存成功";
							}
							myMsg(e);
							$("#outHosContract").datagrid('reload');
							$HUI.dialog("#outHosModifyDialog").close();
						})
					}
				},{
					text:'关闭',
					handler:function(e){
						$HUI.dialog("#outHosModifyDialog").close();
					}
				}]
			});
		}
	}]
})
/*--医嘱对应设置--*/
var codecfgObj = $HUI.datagrid("#codecfgGrid",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayTask',
		QueryName:'GetOrdSetting'
	},
	fitColumns:true,
	pagination:true,
	pageSize:15,
	pageList:[10,15,20,25,50,100],
	toolbar:'#codecfgToobar',
	onClickRow:function(rowIndex, rowData){
		var ID = rowData.ID;
		$("#ARCIMDetailGrid").datagrid("load",{ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayTask',QueryName:'GetOrdDetailSetting',mainId:ID})
		var date  =rowData.invalidTime;
		if (date != ""){
			$('#addDetailButton').linkbutton('disable');
			$('#saveDetailButton').linkbutton('disable');
			$('#deleteDetailButton').linkbutton('disable');
		}else{
			$('#addDetailButton').linkbutton('enable');
			$('#saveDetailButton').linkbutton('enable');
			$('#deleteDetailButton').linkbutton('enable');
		}
	},
	onLoadSuccess:function(data){
		$('#ARCIMDetailGrid').datagrid('loadData',{total:0,rows:[]})
	}
})
$HUI.datagrid("#ARCIMDetailGrid",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayTask',
		QueryName:'GetOrdDetailSetting'
	},
	fitColumns:true,
	pagination:true,
	pageSize:20000,
	pageList:[20000],
	toolbar:'#ARCIMDetailToobar'
})

$("#taskConfigButton").click(function(e){
	var CTLOCStopTask = $("#CTLOCStopTask").checkbox("getValue");
	var WardStopTask = $("#WardStopTask").checkbox("getValue");
	var hosTimeObj = $("input[name='hosTime']:checked");
	var hosTimeValue = hosTimeObj.val();
	var flag = "false"
	if (hosTimeValue == "doctor"){
		flag = "true";
	}
	var value = CTLOCStopTask + "-" + WardStopTask + "-" + flag;
	$m({
		ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayTask',
		MethodName:'BaseSetSave',
		paraValues:value
	},function(e){
		if (e == "ok"){
			e = "更新成功";
		}
		myMsg(e);
		refreshCheckBox();
	})
	//alert(CTLOCStopTask+"^"+WardStopTask+"^"+hosTimeValue);
})

/*--新增统计项--*/
$("#addButton").click(function(e){
	
	$("#codecfgFormShow").form('reset'); 
	$("#codecfgAddDialog").show();
	$HUI.dialog("#codecfgAddDialog",{
		iconCls:'icon-w-add',
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(e){
				var flag = $("#codecfgFormShow").form('validate');
				if (!flag){
					myMsg("请按照提示填写内容");
					return;
				}
				var code = $("#codeCfgCode").val();
				var desc = $("#codeCfgDesc").val();
				var creator = $("#codeCfgCreator").val();
				$m({
					ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayTask',
					MethodName:'SaveOrdInfoSet',
					code:code,
					desc:desc,
					creator:creator
				},function(e){
					myMsg(e);
					$("#codecfgGrid").datagrid("reload");
					$HUI.dialog("#codecfgAddDialog").close();
				})
				
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#codecfgAddDialog").close();
			}
		}]
	
	});
})

/*--作废统计项--*/
$("#deleteButton").click(function(e){
	var row = $("#codecfgGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择作废的记录");
		return;
	}
	var ID = row.ID;
	$.messager.confirm("提示", "确认作废这条记录么?", function (r) {
		if (r) {
			$m({
				ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayTask',
				MethodName:'UpdateOrdInfoSet',
				updateID:ID
			},function(e){
				myMsg(e);
				$("#codecfgGrid").datagrid("reload");
			})
		}
	});
})

/*--统计项检索--*/
$('#searchText').searchbox({
	searcher:function(value,name){
		codecfgObj.load({ClassName:"web.DHCWL.V1.MRIPDay.MRIPDayTask",QueryName:"GetOrdSetting",filterValue:value});
	}
})

/*--医嘱明细检索--*/
$('#searchARCIMDetailText').searchbox({
	searcher:function(value,name){
		$("#ARCIMDetailAddGrid").datagrid("load",{ClassName:"web.DHCWL.V1.MRIPDay.MRIPDayTask",QueryName:"GetARCItms",filterValue:value})
	}
})

/*--医嘱项明细新增--*/
$("#addDetailButton").click(function(e){
	$('#searchARCIMDetailText').searchbox('setValue', '');
	
	var row = $("#codecfgGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条统计项");
		return;
	}else{
		var date = row.invalidTime;
		if (date != ""){
			return;
		}
	}
	
	$HUI.datagrid("#ARCIMDetailAddGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayTask',
			QueryName:'GetARCItms'
		},
		fitColumns:true,
		toolbar:'#ARCIMDetailAddtb',
		pagination:true,
		pageSize:15,
		pageList:[10,15,20,25,50,100],
		onDblClickRow:function(rowIndex, rowData){
			var code,desc,ID
			code = rowData.code;
			desc = rowData.desc;
			ID = rowData.ID;
			var rows = $("#ARCIMDetailGrid").datagrid("getRows");
			var len = rows.length;
			if (len > 0){
				for (var i = 0;i < len;i++){
					if (rows[i].rowID == ID){
						return;
					}
				}
			}
			$('#ARCIMDetailGrid').datagrid('insertRow',{
				row: {
					rowID: ID,
					code: code,
					desc: desc
				}
			});
		}
	})
	
	$("#ARCIMDetailAddDialog").show();
	$HUI.dialog("#ARCIMDetailAddDialog",{
		height:kpiBodyHeight,
		iconCls:'icon-w-add',
		resizable:true,
		modal:true
	})
	
})

/*--医嘱项明细保存--*/
$("#saveDetailButton").click(function(e){
	var row = $("#codecfgGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条统计项");
		return;
	}else{
		var date = row.invalidTime;
		if (date != ""){
			return;
		}
	}
	var ID = row.ID;
	var rows = $("#ARCIMDetailGrid").datagrid("getRows");
	var len = rows.length;
	if (len < 1){
		return;
	}
	var strs = "";
	for (var i = 0;i < len;i++){
		if (strs == ""){
			strs = ID + "^" + rows[i].rowID;
		}else{
			strs = strs + "#" + ID + "^" + rows[i].rowID;
		}
	}
	
	$m({
		ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayTask',
		MethodName:'SaveOrdDetailSetting',
		str:strs
	},function(text){
		myMsg(text);
		$("#ARCIMDetailGrid").datagrid("reload");
	})
})

/*--医嘱项明细删除--*/
$("#deleteDetailButton").click(function(e){
	var row = $("#codecfgGrid").datagrid("getSelected");
	if (!row){
		myMsg("请先选择一条统计项");
		return;
	}else{
		var date = row.invalidTime;
		if (date != ""){
			return;
		}
	}
	var ID = row.ID;
	var detailRow = $("#ARCIMDetailGrid").datagrid("getSelected");
	if (!detailRow){
		myMsg("请先选择一条统计项明细");
		return;
	}
	var detailID = detailRow.ID;
	var newID = ID + "#" + detailID;
	
	$.messager.confirm("提示", "是否确认删除？", function (r) {
		if (r) {
			$m({
				ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayTask',
				MethodName:'DeleteOrdDetailSetting',
				str:newID
			},function(text){
				myMsg(text);
				$("#ARCIMDetailGrid").datagrid("reload");
			})
		}
	});
})






refreshCheckBox();
function refreshCheckBox(){
	$("#CTLOCStopTask").checkbox("uncheck");
	$("#WardStopTask").checkbox("uncheck");
	$HUI.radio("#DOC").setValue(false);
	$HUI.radio("#NURSE").setValue(false);
	$m({
		ClassName:'web.DHCWL.V1.MRIPDay.MRIPDayTask',
		MethodName:'GetMripdayTaskCfg'
	},function(e){
		var obj = eval('(' + e + ')');
		var depStopFlag = obj.depStopFlag;
		var wardStopFlag = obj.wardStopFlag;
		var disDateType = obj.disDateType;
		if (depStopFlag == "Y"){
			$("#CTLOCStopTask").checkbox("check");
		}
		if (wardStopFlag == "Y"){
			$("#WardStopTask").checkbox("check");
		}
		if (disDateType == "DOC"){
			$HUI.radio("#DOC").setValue(true);
		}else if(disDateType == "NURSE"){
			$HUI.radio("#NURSE").setValue(true);
		}
	})
}

})








/*--调整整个系统配置界面--*/
 $(window).resize(function () {  
	 $('#tt4').tabs({  
		 width: $("#tt4").parent().width(),  
		 height: $("#tt4").parent().height()  
	 });  
 })  
 $(function() {  
	 $('#tt4').tabs({  
		 width: $("#tt4").parent().width(),   
　　     height: $("#tt4").parent().height()  
		});  
 }); 