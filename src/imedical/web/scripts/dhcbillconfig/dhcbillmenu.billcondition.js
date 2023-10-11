/*
 * FileName: dhcbillmenu.billcondition.js
 * User: TangTao
 * Date: 2014-04-10
 * Function: 医嘱计费点
 * Description:
 */

var lastIndex = "";
var EditIndex = -1;

$(function () {
	initGrid();
	if (BDPAutDisableFlag('BtnAdd')) {
		$('#BtnAdd').hide();
	}
	if (BDPAutDisableFlag('BtnUpdate')) {
		$('#BtnUpdate').hide();
	}
	if (BDPAutDisableFlag('BtnDelete')) {
		$('#BtnDelete').hide();
	}
	if (BDPAutDisableFlag('BtnSave')) {
		$('#BtnSave').hide();
	}
	
	//+2023-03-18 ZhYW 把权力项申请按钮显示到界面上
	BILL_INF.getStatusHtml("HIS-IPBILL-BILLPOINT", "BtnSave");
	
	var tableName = "Bill_IP_BillCondition";
	var defHospId = $.m({
		ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
		MethodName: "GetDefHospIdByTableName",
		tableName: tableName,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}, false);
	$("#Hospital").combobox({
		panelHeight: 150,
		width: 300,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName,
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox('select', defHospId);
		},
		onChange: function(newValue, oldValue) {
			var url = $URL + "?ClassName=DHCBILLConfig.DHCBILLSysType&QueryName=FindItmCat&ResultSetType=array";
			$("#tTBArcCatCombo").combobox("clear").combobox("reload", url);
			
			initLoadGrid("");
		}
	});
	
	//医嘱子类
	$("#tTBArcCatCombo").combobox({
		valueField: 'RowID',
        textField: 'TarDesc',
        defaultFilter: 5,
        onBeforeLoad: function(param) {
			$.extend(param, {HospId: getValueById("Hospital")});
			return true;
        },
        onSelect: function(rec){
			FindClick();
		},
		onChange: function(newValue, oldValue) {
			if(!newValue) {
				FindClick();
			}
		}
	});
	
	//计费点
	$("#tTBBillConCombo").combobox({
		panelHeight: 'auto',
		valueField: 'value',
        textField: 'text',
        defaultFilter: 5,
        data: CV.BillCondition,
		loadFilter: function(data) {
			data.unshift({value: '', text: $g('全部')});   //往数组开始位置增加一项
			return data;
		},
		onSelect: function(rec) {
			FindClick();
		},
		onChange: function(newValue, oldValue) {
			if(!newValue) {
				FindClick();
			}
		}
	});
});

function initGrid() {
	var CateColumns = [[{
				field: 'BCRowid',
				title: 'BCRowid',
				hidden: true
			}, {
				field: 'BCSubCateDesc',
				title: '医嘱子类',
				width: 230,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						url: $URL + '?ClassName=DHCBILLConfig.DHCBILLSysType&QueryName=FindItmCat&ResultSetType=array',
						valueField: 'RowID',
						textField: 'TarDesc',
						defaultFilter: 5,
						required: true,
						multiple: true,
						onBeforeLoad: function (param) {
							$.extend(param, {HospId: getValueById("Hospital")});
							return true;
						},
						onLoadSuccess: function() {
							$(this).next("span").find("input").focus();
						},
						onSelect: function (rec) {
							if (!rec) {
								return;
							}
							var selected = $('#tTarCate').datagrid('getSelected');
							var thisIndex = $('#tTarCate').datagrid('getRowIndex', selected);
							var thisEd = $('#tTarCate').datagrid('getEditor', {
									index: thisIndex,
									field: 'BCConditionDesc'
								});
							var arcGrpDR = $(thisEd.target).combobox('getValue');
							var rtn = checkArcGrpBillCondition(rec.RowID, arcGrpDR);
							if (!rtn) {
								$.messager.alert('提示', '只有药品才能设置计费点为CR', 'info');
								$(this).combobox('clear');
								return;
							}
							var thisEd = $('#tTarCate').datagrid('getEditor', {
									index: thisIndex,
									field: 'BCSubCateDesc'
								});
							var Data = $(thisEd.target).combobox('getValues');
							var ArcStr = "" + Data + "";
							var ArcStr1 = ArcStr.split(",");
							if (ArcStr1[0] != "") {
								var reg = /^\d+$/;
								if (!reg.test(ArcStr1[0])) {
									var Data1 = $(thisEd.target).combobox('getText');
									var ArcStr = "" + Data1 + "";
									var ArcStr1 = ArcStr.split(",");
									ArcStr1[0] = "";
									Data = ArcStr1.join(",");
									$(thisEd.target).combobox('setText', Data);
								}
							}
						},
						onUnselect: function (rec) {
							var selected = $('#tTarCate').datagrid('getSelected');
							var thisIndex = $('#tTarCate').datagrid('getRowIndex', selected);
							var thisEd = $('#tTarCate').datagrid('getEditor', {
									index: thisIndex,
									field: 'BCSubCateDesc'
								});
							var Data = $(thisEd.target).combobox('getValues');
							var ArcStr = "" + Data + "";
							var ArcStr1 = ArcStr.split(",");
							if (ArcStr1[0] != "") {
								var reg = /^\d+$/;
								if (!reg.test(ArcStr1[0])) {
									var Data1 = $(thisEd.target).combobox('getText');
									var ArcStr = "" + Data1 + "";
									var ArcStr1 = ArcStr.split(",");
									ArcStr1[0] = "";
									Data = ArcStr1.join(",");
									$(thisEd.target).combobox('setText', Data);
								}
							}
						}
					}
				}
			}, {
				field: 'BCConditionDesc',
				title: '计费点名称',
				width: 250,
				sortable: true,
				resizable: true,
				editor: {
					type: 'combobox',
					options: {
						panelHeight: 'auto',
						valueField: 'value',
						textField: 'text',
						editable: false,
						data: CV.BillCondition,
						required: true,
						onSelect: function (rec) {
							var selected = $('#tTarCate').datagrid('getSelected');
							var thisIndex = $('#tTarCate').datagrid('getRowIndex', selected);
							var thisEd = $('#tTarCate').datagrid('getEditor', {
									index: thisIndex,
									field: 'BCSubCateDesc'
								});
							var arcGrpDRStr = $(thisEd.target).combobox('getValues');
							var rtn = checkArcGrpBillCondition(arcGrpDRStr, rec.id);
							if (!rtn) {
								$.messager.alert('提示', '只有药品才能设置计费点为CR', 'info');
								$(this).combobox('clear');
							}
						}
					}
				}
			}, {
				field: 'BCSubCate',
				title: 'BCSubCate',
				hidden: true
			}, {
				field: 'BCCondition',
				title: 'BCCondition',
				hidden: true
			}
		]];

	// 初始化DataGrid
	$('#tTarCate').datagrid({
		fit: true,
		border: false,
		singleSelect: true,
		fitColumns: false,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		columns: CateColumns,
		toolbar: '#tToolBar',
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
}

function initLoadGrid(ExpStr) {
	var SearchArcCat = "";
	var SearchBillCon = "";
	if (ExpStr != "") {
		SearchArcCat = ExpStr.split("^")[0];
		SearchBillCon = ExpStr.split("^")[1];
	}
	var queryParams = {
		ClassName: "DHCBILLConfig.DHCBILLSysType",
		QueryName: "FindBillCondition",
		ArcCat: SearchArcCat,
		BillCondition: SearchBillCon,
		HospId: getValueById("Hospital")
	};
	loadDataGridStore("tTarCate", queryParams);
}

$('#BtnAdd').bind('click', function () {
	//$('#tTarCate').datagrid('endEdit', lastIndex);
	lastIndex = $('#tTarCate').datagrid('getRows').length - 1;
	$('#tTarCate').datagrid('selectRow', lastIndex);
	var selected = $('#tTarCate').datagrid('getSelected');
	if (selected) {
		if (selected.BCRowid == "") {
			$.messager.alert('提示', "不能同时添加多条", 'info');
			return;
		}
	}
	if (EditIndex >= 0) {
		$.messager.alert('提示', "一次只能修改一条记录", 'info');
		return;
	}
	$('#tTarCate').datagrid('appendRow', {
		BCRowid: '',
		BCSubCateDesc: '',
		BCConditionDesc: ''
	});
	lastIndex = $('#tTarCate').datagrid('getRows').length - 1;
	$('#tTarCate').datagrid('selectRow', lastIndex);
	$('#tTarCate').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
});

$('#BtnUpdate').bind('click', function () {
	var selected = $('#tTarCate').datagrid('getSelected');
	if (selected) {
		var thisIndex = $('#tTarCate').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('提示', "一次只能修改一条记录", 'info');
			return;
		}
		$('#tTarCate').datagrid('beginEdit', thisIndex).datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#tTarCate').datagrid('getSelected');
		var thisEd = $('#tTarCate').datagrid('getEditor', {
				index: EditIndex,
				field: 'BCSubCateDesc'
			});
		$(thisEd.target).combobox('clear').combobox('select', selected.BCSubCate).combobox('disable');
		
		var thisEd = $('#tTarCate').datagrid('getEditor', {
				index: EditIndex,
				field: 'BCConditionDesc'
			});
		$(thisEd.target).combobox('select', selected.BCCondition);
	}
});

$('#BtnSave').bind('click', function () {
	//$('#tTarCate').datagrid('acceptChanges');
	var selected = $('#tTarCate').datagrid('getSelected');
	if (selected) {
		// selected.BCRowid为undefined，说明是新建项目，调用保存接口
		if (selected.BCRowid == "") {
			var thisEd = $('#tTarCate').datagrid('getEditor', {
					index: EditIndex,
					field: 'BCSubCateDesc'
				});
			var ArcStr = $(thisEd.target).combobox('getValues');
			var thisEd = $('#tTarCate').datagrid('getEditor', {
					index: EditIndex,
					field: 'BCConditionDesc'
				});
			var BCConStr = $(thisEd.target).combobox('getValue');
			ArcStr = "" + ArcStr + "";
			if ((ArcStr == "undefined") || (BCConStr == "undefined") || (ArcStr == "") || (BCConStr == "")) {
				$.messager.alert('提示', "数据为空，不允许添加", 'info');
				EditIndex = -1;
				initLoadGrid("");
				return;
			}
			$.m({
				ClassName: "DHCBILLConfig.DHCBILLSysType",
				MethodName: "InsertBillCondition",
				NewItmCat: ArcStr,
				Condition: BCConStr,
				User: PUBLIC_CONSTANT.SESSION.USERID,
				HospId: getValueById("Hospital")
			}, function(rtn) {
				var myAry = rtn.split("^");
				var iconCls = (myAry[0] == 0) ? "success" : "error";
				if (CV.EnablePMASystem != 0) {
					$.messager.popover({msg: (myAry[1] || myAry[0]), type: iconCls});
					//把权力项申请按钮显示到界面上
					BILL_INF.getStatusHtml("HIS-IPBILL-BILLPOINT", "BtnSave");
				}else {
					//未启用权力系统
					var msg = (myAry[0] == 0) ? "保存成功" : ("保存失败：" + (myAry[1] || myAry[0]));
					$.messager.popover({msg: msg, type: iconCls});
				}
				EditIndex = -1;
				initLoadGrid("");
			});
		} else {
			$('#tTarCate').datagrid('selectRow', EditIndex);
			var selected = $('#tTarCate').datagrid('getSelected');
			var thisEd = $('#tTarCate').datagrid('getEditor', {
					index: EditIndex,
					field: 'BCSubCateDesc'
				});
			if (!thisEd) {
				return;
			}
			var ArcStr = $(thisEd.target).combobox('getValues');
			var thisEd = $('#tTarCate').datagrid('getEditor', {
					index: EditIndex,
					field: 'BCConditionDesc'
				});
			var BCConStr = $(thisEd.target).combobox('getValue');
			ArcStr = "" + ArcStr + "";
			if ((ArcStr == "undefined") || (BCConStr == "undefined") || (ArcStr == "") || (BCConStr == "")) {
				$.messager.alert('提示', "数据为空，不允许修改", "info");
				EditIndex = -1;
				initLoadGrid("");
				return;
			}
			$.m({
				ClassName: "DHCBILLConfig.DHCBILLSysType",
				MethodName: "UpdateBillCondition",
				RowID: selected.BCRowid,
				ItmCat: ArcStr,
				Condition: BCConStr,
				User: PUBLIC_CONSTANT.SESSION.USERID,
				HospId: getValueById("Hospital")
			}, function(rtn) {
				var myAry = rtn.split("^");
				var iconCls = (myAry[0] == 0) ? "success" : "error";
				if (CV.EnablePMASystem != 0) {
					$.messager.popover({msg: (myAry[1] || myAry[0]), type: iconCls});
					//把权力项申请按钮显示到界面上
					BILL_INF.getStatusHtml("HIS-IPBILL-BILLPOINT", "BtnSave");
				}else {
					//未启用权力系统
					var msg = (myAry[0] == 0) ? "修改成功" : ("修改失败：" + (myAry[1] || myAry[0]));
					$.messager.popover({msg: msg, type: iconCls});
				}
				EditIndex = -1;
				initLoadGrid("");
			});
		}
	}
});

$('#BtnDelete').bind('click', function () {
	var selected = $('#tTarCate').datagrid('getSelected');
	if (!selected) {
		$.messager.alert('提示', '请选择一条记录', 'info');
		return;
	}
	if (selected.BCRowid != "") {
		$.messager.confirm('确认', '您确认想要删除记录吗？', function (r) {
			if (r) {
				$.m({
					ClassName: "DHCBILLConfig.DHCBILLSysType",
					MethodName: "DeleteBillCondition",
					RowID: selected.BCRowid,
					Guser: PUBLIC_CONSTANT.SESSION.USERID
				}, function (rtn) {
					if (rtn == 0) {
						$.messager.alert('提示', "删除成功", 'success');
					} else {
						$.messager.alert('提示', "删除失败，错误代码：" + rtn, 'error');
					}
					initLoadGrid("");
				});
			}
		});
	}
});

$('#BtnFind').bind('click', function () {
	FindClick();
});

function FindClick() {
	EditIndex = -1;
	var tTBArcCatCombo = $('#tTBArcCatCombo').combobox('getValue');
	var tTBBillConCombo = $('#tTBBillConCombo').combobox('getValue');
	var ExpStr = tTBArcCatCombo + "^" + tTBBillConCombo;
	initLoadGrid(ExpStr);
}

function checkArcGrpBillCondition(arc, CP) {
	var rtn = true;
	var arcGrpDRStr = String(arc);
	var rtn = $.m({ClassName: "DHCBILLConfig.DHCBILLSysType", MethodName: "CheckContainDrugByArcGrp", arcGrpDRStr: arcGrpDRStr}, false);
	if ((rtn != 0) && (CP == 'CR')) {
		rtn = false;
	}
	return rtn;
}