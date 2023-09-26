/**
 * 名称:	 药房药库 - 皮试药品配置
 * 编写人:   Huxt
 * 编写日期: 2020-03-19
 * js: 		 pha/in/v3/skintest.js
 */
PHA_COM.App.Csp = "pha.in.v3.skintest.csp";
PHA_COM.Temp = {}

$(function () {
	var bodyWidth = $(document.body).width();
	var bodyHeight = $(document.body).height();
	$('#layout-first').layout('panel','north').panel('resize', {height: (bodyHeight - 70) * 0.5});
	$('#layout-first').layout('resize');
	InitHosp();
	InitDict();
	InitGridAlg();
	InitGridSkinTest();
	InitGridSkinTestItm();
	InitEvents();
});

/**
 * @description: 事件绑定初始化
 */
function InitEvents() {
	$("#btnFindAlg").on('click', QueryAlg);
	$("#btnSaveAlg").on('click', SaveAlg);
	$("#btnAdd").on('click', Add);
	$("#btnSave").on('click', Save);
	$("#btnDelete").on('click', Delete);
	$("#btnAddItm").on('click', AddItm);
	$("#btnSaveItm").on('click', SaveItm);
	$("#btnDeleteItm").on('click', DeleteItm);
}

/**
 * @description: 初始化字典
 */
function InitDict(){
	
}

/**
 * @description: 表格 - 过敏原
 */
function InitGridAlg() {
	var columns = [
		[{
				field: "alg",
				title: 'alg',
				width: 100,
				hidden: true
			}, {
				field: "algDesc",
				title: '过敏原名称',
				width: 160
			}, {
				field: "rlaAlg",
				descField: 'rlaAlgDesc',
				title: '项目',
				title: '关联过敏原',
				width: 160,
				editor: ComboBoxEditor("rlaAlg"),
                formatter: function(value, rowData, index){
	                return rowData.rlaAlgDesc
	            }
			}, {
				field: "algTypeId",
				title: 'algTypeId',
				width: 100,
				hidden: true
			}, {
				field: "algTypeDesc",
				title: '类型',
				width: 80
			}, {
				field: 'startDate',
				title: '开始日期',
				width: 100
			}, {
				field: 'endDate',
				title: '截止日期',
				width: 100
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.SkinTest.Query',
			QueryName: 'PHAINAlg'
		},
		fit: true,
		border: false,
		displayMsg: "",
		pagination: false,
		columns: columns,
		rownumbers: true,
		fitColumns: true,
		onSelect: function(rowIndex, rowData){},
		onClickRow: function(rowIndex, rowData){
			Query();
			OnSelectSkinTest({});
			$("#gridSkinTestItm").datagrid("clear");
		},
		onClickCell: function(index, field, value){
			if (field == 'rlaAlg') {
				GridStartEdit({
					gridID: 'gridAlg',
					index: index,
					field: field
				});
			}
		},
		toolbar: "#gridAlgBar"
	};
	PHA.Grid("gridAlg", dataGridOption);
}

/**
 * @description: 表格 - 皮试药品
 */
function InitGridSkinTest() {
	var columns = [
		[{
				field: "pist",
				title: 'pist',
				width: 100,
				hidden: true
			},
			{
				field: "alg",
				title: 'alg',
				width: 100,
				hidden: true
			}, {
				field: "algDesc",
				title: '过敏原',
				width: 100,
				hidden: true
			}, {
				field: "itemCode",
				title: '项目代码',
				width: 120
			}, {
				field: "itemId",
				descField: 'itemDesc',
				title: '项目',
				width: 320,
				editor: ComboBoxEditor("skinTestItem"),
                formatter: function(value, rowData, index){
	                return rowData.itemDesc
	            }
			}, {
				field: "itemType",
				title: '项目类型',
				align: "center",
				width: 50,
				hidden: true
			}, {
				field: "validTime",
				title: '皮试时效(h)',
				align: "center",
				width: 90,
				editor: {
                    type: 'numberbox',
                    options: {
                        required: true
                    }
				}
			}, {
				field: "desensitFlag",
				title: '允许脱敏',
				align: "center",
				width: 70,
				editor: CheckBoxEditor(),
				formatter: CheckBoxFormatter
			}, {
				field: "noTestFlag",
				title: '允许免试',
				align: "center",
				width: 70,
				editor: CheckBoxEditor(),
				formatter: CheckBoxFormatter
			}, {
				field: "exceptionFlag",
				title: '控制例外',
				align: "center",
				width: 70,
				editor: CheckBoxEditor(),
				formatter: CheckBoxFormatter
			}, {
				field: "startDate",
				title: '开始日期',
				align: "center",
				width: 100,
				editor: {
					type: 'datebox'
				}
			}, {
				field: "endDate",
				title: '结束日期',
				align: "center",
				width: 100,
				editor: {
					type: 'datebox'
				}
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.SkinTest.Query',
			QueryName: 'PHAINSkinTest'
		},
		fit: true,
		border: false,
		rownumbers: false,
		displayMsg: "",
		pagination: false,
		columns: columns,
		fitColumns: false,
		onClickCell: function(index, field, value){
			if (field == 'itemCode') {
				QueryItm(index);
				return;
			}
			GridStartEdit({
				gridID: 'gridSkinTest',
				index: index,
				field: field
			});
		},
		onClickRow: function(rowIndex, rowData){
			OnSelectSkinTest(rowData);
		},
		toolbar: "#gridSkinTestBar"
	};
	PHA.Grid("gridSkinTest", dataGridOption);
}

/**
 * @description: 表格 - 皮试关联药品
 */
function InitGridSkinTestItm() {
	var columns = [
		[
			{
				field: "pisti",
				title: 'pisti',
				width: 100,
				hidden: true
			},
			{
				field: "admType",
				descField: 'admTypeDesc',
				title: '就诊类型',
				width: 100,
				editor: ComboBoxEditor("admType"),
                formatter: function(value, rowData, index){
	                return rowData.admTypeDesc
	            }
			}, {
				field: "locID",
				descField: 'locDesc',
				title: '科室',
				width: 180,
				editor: ComboBoxEditor("locID"),
                formatter: function(value, rowData, index){
	                return rowData.locDesc;
	            }
			}, {
				field: "itemType",
				descField: 'itemTypeDesc',
				title: '项目类型',
				width: 100,
				editor: ComboBoxEditor("ItemType"),
                formatter: function(value, rowData, index){
	                return rowData.itemTypeDesc;
	            }
			}, {
				field: "itemId",
				descField: 'itemDesc',
				title: '项目',
				width: 320,
				editor: ComboBoxEditor("skinTestItmItem"),
                formatter: function(value, rowData, index){
	                return rowData.itemDesc
	            }
			}, {
				field: "resultFlag",
				title: '结果标志',
				align: "center",
				width: 80,
				editor: CheckBoxEditor(),
				formatter: CheckBoxFormatter
			}, {
				field: "priID",
				descField: 'priDesc',
				title: '优先级',
				align: "center",
				width: 130,
				editor: ComboBoxEditor("priID"),
                formatter: function(value, rowData, index){
	                return rowData.priDesc;
	            }
			}, {
				field: "doseQty",
				title: '剂量',
				align: "center",
				width: 80,
				editor: {
                    type: 'numberbox',
                    options: {
	                    precision: 2
	                }
				}
			}, {
				field: "unitID",
				descField: 'unitDesc',
				title: '剂量单位',
				align: "center",
				width: 80,
				editor: ComboBoxEditor("unitID"),
                formatter: function(value, rowData, index){
	                return rowData.unitDesc;
	            }
			}, {
				field: "freqID",
				descField: 'freqDesc',
				title: '频次',
				align: "center",
				width: 130,
				editor: ComboBoxEditor("freqID"),
                formatter: function(value, rowData, rowIndex){
	                return rowData.freqDesc;
	            }
			}, {
				field: "instID",
				descField: 'instDesc',
				title: '用法',
				align: "center",
				width: 120,
				editor: ComboBoxEditor("instID"),
                formatter: function(value, rowData, index){
	                return rowData.instDesc;
	            }
			}, {
				field: "seqNo",
				title: '关联',
				align: "center",
				width: 80,
				editor: {
                    type: 'numberbox',
                    options: {}
				}
			}, {
				field: "autoInsFlag",
				title: '自动插入',
				align: "center",
				width: 80,
				editor: CheckBoxEditor(),
				formatter: CheckBoxFormatter
			}, {
				field: "startDate",
				title: '开始日期',
				align: "center",
				width: 120,
				editor: {
					type: 'datebox'
				}
			}, {
				field: "endDate",
				title: '截止日期',
				align: "center",
				width: 120,
				editor: {
					type: 'datebox'
				}
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.SkinTest.Query',
			QueryName: 'PHAINSkinTestItm'
		},
		fit: true,
		border: false,
		rownumbers: false,
		displayMsg: "",
		pagination: false,
		columns: columns,
		fitColumns: false,
		onClickCell: function(index, field, value){
			GridStartEdit({
				gridID: 'gridSkinTestItm',
				index: index,
				field: field
			});
		},
		toolbar: "#gridSkinTestItmBar"
	};
	PHA.Grid("gridSkinTestItm", dataGridOption);
}

/**
 * @description: 过敏原CRUD操作
 */
function QueryAlg(){
	$("#gridAlg").datagrid('reload');
}
function SaveAlg(){
	if (GridEndEidting("gridAlg") == false) {
		return;
	}
	var changeData = GetChangeData("gridAlg");
	if (changeData.length == 0) {
		return;
	}
	var jsonDataStr =  JSON.stringify(changeData);
	// 保存
	var retStr = $.cm({
		ClassName: 'PHA.IN.SkinTest.Save',
		MethodName: 'SaveAlgMulti',
		jsonDataStr: jsonDataStr,
		dataType: 'text'
	}, false);
	AfterRunServer(retStr, QueryAlg);
}

/**
 * @description: 皮试药品CRUD操作
 */
function Query() {
	// 获取医院
	var hospId = $('#_HospList').combogrid('getValue') || "";
	if (hospId == "") {
		return false;
	}
	var selectedRow = $("#gridAlg").datagrid("getSelected") || {};
	var alg = selectedRow.alg || "";
	if (alg == "") {
		return false;
	}
	var inputStr = alg;
	$("#gridSkinTest").datagrid('query', {
		inputStr: inputStr,
		hospId: hospId
	});
	// 单选
	var algMaintainType = tkMakeServerCall("PHA.IN.SkinTest.Query", "GetAlgMaintainType", (selectedRow.alg || ""));
	if (algMaintainType != "") {
		$("input[name='itemType']").radio('disable');
		$("input[name='itemType'][value='" + algMaintainType + "']").radio('setValue',true);
	} else {
		$("input[name='itemType']").radio('enable');
	}
}

function Add(){
	$("input[name='itemType']").radio('disable');
	var selectedRow = $("#gridAlg").datagrid("getSelected") || {};
	var alg = selectedRow.alg || "";
	if (alg == "") {
		PHA.Popover({
			msg: "请选择过敏原!",
			type: "alert"
		});
		return false;
	}
	var algDesc = selectedRow.algDesc || "";
	var itemType = GetItemType();
	if (itemType == false) {
		return;
	}
	var startDate = tkMakeServerCall("PHA.IN.SkinTest.Query", "GetDate", "t");
	AddNewRowCom({
		gridID: 'gridSkinTest',
		editField: 'itemId',
		defaultData: {
			pist: '',
			alg: alg,
			algDesc: '',
			itemId: '',
			itemDesc: '',
			itemType: itemType,
			validTime: '72',
			desensitFlag: 'N',
			noTestFlag: 'N',
			exceptionFlag: 'N',
			startDate: startDate,
			endDate: ''
		}
	});
}

function Save() {
	// 获取医院
	var hospId = $('#_HospList').combogrid('getValue') || "";
	if (hospId == "") {
		PHA.Popover({
			msg: "请选择需要医院!",
			type: "alert"
		});
		return false;
	}
	// 前台验证
	if (GridEndEidting("gridSkinTest") == false) {
		return;
	}
	var changeData = GetChangeData("gridSkinTest");
	if (changeData.length == 0) {
		return;
	}
	var jsonDataStr =  JSON.stringify(changeData);
	// 保存
	var retStr = $.cm({
		ClassName: 'PHA.IN.SkinTest.Save',
		MethodName: 'SaveMulti',
		jsonDataStr: jsonDataStr,
		hospId: hospId,
		dataType: 'text'
	}, false);
	AfterRunServer(retStr, function(){
		Query();
		OnSelectSkinTest({});
		$("#gridSkinTestItm").datagrid("clear");
	});
}

function Delete() {
	// 获取医院
	var hospId = $('#_HospList').combogrid('getValue') || "";
	if (hospId == "") {
		PHA.Popover({
			msg: "请选择需要医院!",
			type: "alert"
		});
		return false;
	}
	// 要删除的ID
	var selectedRow = $("#gridSkinTest").datagrid("getSelected");
	if (selectedRow == null) {
		PHA.Popover({
			msg: "请选择需要删除的项目!",
			type: "alert"
		});
		return;
	}
	var pist = selectedRow.pist || "";
	// 删除确认
	PHA.Confirm("删除提示", "是否确认删除该项目?", function () {
		if (pist == "") {
			var rowIndex = $("#gridSkinTest").datagrid('getRowIndex', selectedRow);
			$("#gridSkinTest").datagrid('deleteRow', rowIndex);
			var rowsData = $("#gridSkinTest").datagrid('getRows') || [];
			if (rowsData.length == 0) {
				Query();
			}
			return;
		}
		var retStr = $.cm({
			ClassName: 'PHA.IN.SkinTest.Save',
			MethodName: 'Delete',
			pist: pist,
			hospId: hospId,
			dataType: 'text'
		}, false);
		AfterRunServer(retStr, function(){
			Query();
			OnSelectSkinTest({});
			$("#gridSkinTestItm").datagrid("clear");
		});
	});
}

/**
 * @description: 关联皮试用药CRUD操作
 */
function QueryItm(rowIndex) {
	var pist = "";
	if (rowIndex >= 0) {
		var rowsData = $("#gridSkinTest").datagrid("getRows") || [];
		if (rowsData.length > rowIndex) {
			pist = rowsData[rowIndex]["pist"] || "";
		}
	} else {
		var selectedRow = $("#gridSkinTest").datagrid("getSelected") || {};
		pist = selectedRow.pist || "";
	}
	if (pist == "") {
		PHA.Popover({
			msg: "未选择项目或选择的项目没有保存!",
			type: "alert"
		});
		return;
	}
	var inputStr = pist;
	$("#gridSkinTestItm").datagrid('query', {
		inputStr: inputStr
	});
}

function AddItm() {
	var selectedRow = $("#gridSkinTest").datagrid("getSelected") || {};
	var pist = selectedRow.pist || "";
	if (pist == "") {
		PHA.Popover({
			msg: "未选择项目或选择的项目没有保存!",
			type: "alert"
		});
		return;
	}
	var startDate = tkMakeServerCall("PHA.IN.SkinTest.Query", "GetDate", "t");
	AddNewRowCom({
		gridID: 'gridSkinTestItm',
		editField: 'itemType',
		defaultData: {
			pisti : '',
			pist: pist,
			admType : '',
			admTypeDesc : '',
			locID : '',
			locDesc : '',
			itemType : '',
			itemTypeDesc : '',
			itemId : '',
			itemDesc : '',
			resultFlag : 'Y',
			priID : '',
			priDesc : '',
			doseQty : '',
			unitID : '',
			unitDesc : '',
			freqID : '',
			freqDesc : '',
			instID : '',
			instDesc : '',
			seqNo : '',
			autoInsFlag : 'Y',
			startDate : startDate,
			endDate : ''
		}
	});
}

function SaveItm() {
	// 前台验证
	if (GridEndEidting("gridSkinTestItm") == false) {
		return;
	}
	var changeData = GetChangeData("gridSkinTestItm");
	if (changeData.length == 0) {
		return;
	}
	// 取最大行数(用于后台验证关联序号)
	var rowsData = $("#gridSkinTestItm").datagrid('getRows');
	var maxRows = rowsData.length;
	for (var i = 0; i < changeData.length; i++) {
		changeData[i].maxRows = maxRows;
	}
	var jsonDataStr =  JSON.stringify(changeData);
	// 保存
	var retStr = $.cm({
		ClassName: 'PHA.IN.SkinTest.Save',
		MethodName: 'SaveItmMulti',
		jsonDataStr: jsonDataStr,
		dataType: 'text'
	}, false);
	AfterRunServer(retStr, QueryItm);
}

function DeleteItm() {
	// 要删除的ID
	var selectedRow = $("#gridSkinTestItm").datagrid("getSelected");
	if (selectedRow == null) {
		PHA.Popover({
			msg: "请选择需要删除的项目!",
			type: "alert"
		});
		return;
	}
	var pisti = selectedRow.pisti || "";
	// 删除确认
	PHA.Confirm("删除提示", "是否确认删除该项目?", function () {
		var rowIndex = $("#gridSkinTestItm").datagrid('getRowIndex', selectedRow);
		if (pisti == "") {
			$("#gridSkinTestItm").datagrid('deleteRow', rowIndex);
			return;
		}
		var retStr = $.cm({
			ClassName: 'PHA.IN.SkinTest.Save',
			MethodName: 'DeleteItm',
			pisti: pisti,
			rowIndex: rowIndex,
			dataType: 'text'
		}, false);
		AfterRunServer(retStr, QueryItm);
	});
}



/**
 * @description: 以下为公共过程方法
 */
function AddNewRowCom(_options){
	var _gridID = _options.gridID;
	var _defaultData = _options.defaultData;
	var _editField = _options.editField;
	var isEndEidting = $("#" + _gridID).datagrid("endEditing");
	if (!isEndEidting) {
		PHA.Popover({
			msg: "请先完成表格上一行编辑!",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	$("#" + _gridID).datagrid("appendRow", _defaultData);
	var rowsData = $("#" + _gridID).datagrid('getRows');
	GridStartEdit({
		gridID: _gridID,
		index: rowsData.length - 1,
		field: _editField
	});
}

function GetItemType(){
	var checkedRadioObj = $("input[name='itemType']:checked");
	var itemType = checkedRadioObj == undefined ? "" : checkedRadioObj.val();
	if (itemType == "" || itemType == undefined) {
		PHA.Popover({
			msg: "请选择保存类型!",
			type: "alert",
			timeout: 1000
		});
		return false;
	}
	return itemType;
}

function GridStartEdit(_options){
	var _gridID = _options.gridID;
	var _index = _options.index;
	var _field = _options.field;
	$("#" + _gridID).datagrid('beginEditCell', {
        index: _index,
        field: _field
    });
    
    var _thisEditor = $("#" + _gridID).datagrid('getEditor', {
		index: _index,
		field: _field
	});
	if (_thisEditor == null) {
		return;
	}
	if (_thisEditor.type == "combobox") {
		$(_thisEditor.target).combobox('showPanel');
		return;
	}
	if (_thisEditor.type == "combogrid") {
		$(_thisEditor.target).combogrid('showPanel');
		return;
	}
	if (_thisEditor.type == "combotree") {
		$(_thisEditor.target).combotree('showPanel');
		return;
	}
	if (_thisEditor.type == "datebox") {
		$(_thisEditor.target).datebox('showPanel');
		return;
	}
}

function GridEndEidting(_gridID){
	var isEndEidting = $("#" + _gridID).datagrid("endEditing");
	if (!isEndEidting) {
		PHA.Popover({
			msg: "未填入必填项,无法完成编辑!",
			type: "alert",
			timeout: 1000
		});
		return false;
	}
	return true;
}

function GetChangeData(_gridID){
	var changeData = $("#" + _gridID).datagrid("getChanges") || [];
	if (changeData.length == 0) {
		PHA.Popover({
			msg: "没有需要保存的数据!",
			type: "error",
			timeout: 1000
		});
		return [];
	}
	return changeData;
}

function AfterRunServer(retStr, succCallFn, errCallFn) {
	var retArr = retStr.split("^");
	var retVal = retArr[0];
	var retInfo = retArr[1];
	if (retVal < 0) {
		PHA.Alert("提示", retInfo, retVal);
		if (errCallFn) {
			errCallFn();
		}
	} else {
		PHA.Popover({
			msg: retInfo || "成功!",
			type: "success",
			timeout: 500
		});
		if (succCallFn) {
			succCallFn();
		}
	}
}

function OnSelectSkinTest(rowData){
	var curSelectedItem = "当前选择项目: ";
	var itemDesc = rowData.itemDesc || "";
	if (itemDesc != "") {
		curSelectedItem += itemDesc;
	}
	$("#curSelectedItem").text(curSelectedItem);
}

function ComboBoxEditor(type){
	if (type == "rlaAlg") {
		return {
	        type: 'combobox',
	        options: {
	            valueField: 'RowId',
	            textField: 'Description',
	            mode: 'remote',
	            url: $URL + '?ClassName=PHA.IN.SkinTest.Query&QueryName=RelaAlg&ResultSetType=array',
	            onBeforeLoad: function(param){
	                param.QText = param.q;
	            }
	        }
	    }
	}
	if (type == "skinTestItem") {
		return {
	        type: 'combobox',
	        options: {
	            valueField: 'RowId',
	            textField: 'Description',
	            required: true,
	            mode: 'remote',
	            url: $URL + '?ClassName=PHA.IN.SkinTest.Query&QueryName=QueryItem&ResultSetType=array',
	            onBeforeLoad: function(param){
	                var itemType = GetItemType();
	                if (itemType == false) {
	                    return;
	                }
	                var hospId = $('#_HospList').combogrid('getValue') || "";
					if (hospId == "") {
						return false;
					}
					param.hospId = hospId;
	                param.QText = param.q;
	                if (typeof (param.QText) == "undefined") {
	                    var selectedRow = $("#gridSkinTest").datagrid("getSelected") || {};
	                    param.QText = selectedRow.itemDesc || "";
	                }
	                param.inputStr = itemType;
	            }
	        }
	    }
	}
	if (type == "skinTestItmItem") {
		return {
            type: 'combobox',
            options: {
                valueField: 'RowId',
                textField: 'Description',
                required: true,
                mode: 'remote',
                url: $URL + '?ClassName=PHA.IN.SkinTest.Query&QueryName=QueryItem&ResultSetType=array',
                onBeforeLoad: function(param){
	                var hospId = $('#_HospList').combogrid('getValue') || "";
					if (hospId == "") {
						return false;
					}
					param.hospId = hospId;
                    param.QText = param.q;
                    var selectedRow = $("#gridSkinTestItm").datagrid("getSelected") || {};
                    if (typeof (param.QText) == "undefined") {
                        param.QText = selectedRow.itemDesc || "";
                    }
                    param.inputStr = selectedRow.itemType || "";
                }
            }
        }
	}
	if (type == "admType") {
		return {
            type: 'combobox',
            options: {
                valueField: 'RowId',
                textField: 'Description',
                panelHeight: 'auto',
                mode: 'remote',
                url: $URL + '?ClassName=PHA.IN.SkinTest.Query&QueryName=AdmType&ResultSetType=array'
            }
        }
	}
	if (type == "locID") {
		return {
	        type: 'combobox',
	        options: {
	            valueField: 'RowId',
	            textField: 'Description',
	            mode: 'remote',
	            url: PHA_STORE.CTLoc().url,
	            onBeforeLoad: function(param){
	                param.QText = param.q;
	            }
	        }
	    }
	}
	if (type == "ItemType") {
		return {
            type: 'combobox',
            options: {
                valueField: 'RowId',
                textField: 'Description',
                panelHeight: 'auto',
                required: true,
                mode: 'remote',
                editable: false,
                url: $URL + '?ClassName=PHA.IN.SkinTest.Query&QueryName=ItemType&ResultSetType=array',
                onSelect: function(record){
	                // 自动插入是否勾选
                    var rowData = $('#gridSkinTestItm').datagrid('getSelected');
                    var rowIndex = $('#gridSkinTestItm').datagrid('getRowIndex', rowData);
                    $('#gridSkinTestItm').datagrid('beginEditCell', {
				        index: rowIndex,
				        field: "autoInsFlag"
				    });
                    var _thisEditor = $("#gridSkinTestItm").datagrid('getEditor', {
						index: rowIndex,
						field: "autoInsFlag"
					});
					var target = _thisEditor.target;
					target.checkbox('setValue', record.RowId == "G" ? false : true);
					// 清空项目下拉
					$('#gridSkinTestItm').datagrid('beginEditCell', {
				        index: rowIndex,
				        field: "itemId"
				    });
					var _thisEditor = $("#gridSkinTestItm").datagrid('getEditor', {
						index: rowIndex,
						field: "itemId"
					});
					var target = _thisEditor.target;
					target.combobox('clear');
	            }
            }
        }
	}
	if (type == "priID") {
		return {
            type: 'combobox',
            options: {
                valueField: 'RowId',
                textField: 'Description',
                mode: 'remote',
                onBeforeLoad: function(param){
                    param.QText = param.q;
                },
                url: PHA_STORE.OECPriority().url
            }
        }
	}
	if (type == "unitID") {
		return {
            type: 'combobox',
            options: {
                valueField: 'RowId',
                textField: 'Description',
                mode: 'remote',
                panelHeight: 'auto',
                url: $URL + '?ClassName=PHA.IN.SkinTest.Query&QueryName=DoseUom&ResultSetType=array',
                onBeforeLoad: function(param) {
                    var selectedRow = $("#gridSkinTestItm").datagrid("getSelected") || {};
                    param.inputStr = selectedRow.itemId || "";
                }
            }
        }
	}
	if (type == "freqID") {
		return {
            type: 'combobox',
            options: {
                valueField: 'RowId',
                textField: 'Description',
                mode: 'remote',
                onBeforeLoad: function(param){
                    param.QText = param.q;
                },
                url: PHA_STORE.PHCFreq().url
            }
        }
	}
	if (type == "instID") {
		return {
            type: 'combobox',
            options: {
                valueField: 'RowId',
                textField: 'Description',
                mode: 'remote',
                onBeforeLoad: function(param){
                    param.QText = param.q;
                },
                url: PHA_STORE.PHCInstruc().url
            }
        }
	}
}

function CheckBoxEditor(){
	return {
		type: 'icheckbox',
	    options: { on: 'Y', off: 'N' }
	}
}

function CheckBoxFormatter(val, rowData, rowIndex){
	if (val == "Y"){
		return PHA_COM.Fmt.Grid.Yes.Chinese;
	} else {
		return PHA_COM.Fmt.Grid.No.Chinese;
	}
}

/*
* @description: 多院区配置 - 加载初始化医院
*/
function InitHosp(){
	var hospComp = GenHospComp("PHAIN_SkinTest");
	hospComp.options().onSelect = function(record){
		console.log(record);
		var selectedRow = $('#gridAlg').datagrid('getSelected');
		if (selectedRow == null) {
			var rowsData = $('#gridAlg').datagrid('getRows');
			if (rowsData.length == 0) {
				return;
			}
			$('#gridAlg').datagrid('selectRow', 0);
		}
		Query();
	}
}

/*
* @description: 帮助窗口信息
*/
function OpenHelpWin(helpInfo){
	if (helpInfo == 1) {
		helpInfo = GetSkinTestHelpHtml();
	}
	if (helpInfo == 2) {
		helpInfo = GetSkinTestItmHelpHtml();
	}
	var winId = "skintest_helpWin";
	var winContentId = "skintest_helpWin" + "_" + "content";
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		$('#' + winId).dialog({
			width: 600,
	    	height: 400,
	    	modal: true,
	    	title: '帮助',
	    	iconCls: 'icon-help',
	    	content: "<div id='" + winContentId + "'style='margin:20px;'></div>",
	    	closable: true
		});
		$('#' + winContentId).width($('#' + winContentId).parent().width() - 40);
		$('#' + winContentId).height($('#' + winContentId).parent().height() - 40);
	}
	$('#' + winContentId).html(helpInfo);
	$('#' + winId).dialog('open');
}

function GetSkinTestHelpHtml(){
	var skinTestHelpHtml = "";
	skinTestHelpHtml += GetTitle("1、项目名称：");
	skinTestHelpHtml += GetContent("过敏原下包含哪些药品，可以按医嘱项定义，也可以按通用名定义，但是只能按一种定义，不能同时定义。");
	skinTestHelpHtml += GetTitle("2、时效：");
	skinTestHelpHtml += GetContent("该药品判断多长时间内的皮试结果或用药记录。");
	skinTestHelpHtml += GetTitle("3、允许脱敏：");
	skinTestHelpHtml += GetContent("该药品是否可以脱敏治疗。");
	skinTestHelpHtml += GetTitle("4、允许免试：");
	skinTestHelpHtml += GetContent("该药品是否可以免试。");
	skinTestHelpHtml += GetTitle("5、控制例外：");
	skinTestHelpHtml += GetContent("勾选后治疗药品不置皮试结果仍可以缴费/发药。适用于破伤风类药品，取一只先做皮试，剩下的继续治疗。");
	return skinTestHelpHtml;
}

function GetSkinTestItmHelpHtml(){
	var skinTestHelpHtml = "";
	skinTestHelpHtml += GetTitle("1、就诊类型：");
	skinTestHelpHtml += GetContent("下拉框，可以选择“空/门诊/急诊/住院”,为空时代表此规则适用于全院，选择“门诊/急诊/住院”代表规则仅适用的就诊类型，“门诊/急诊/住院”和“空”的规则可以同时存在，但前者优先级更高。");
	skinTestHelpHtml += GetTitle("2、科室：");
	skinTestHelpHtml += GetContent("可以选择空（即全院），或者具体开单科室，如果维护了科室的优先取科室定义的皮试用药，否则取空的记录。");
	skinTestHelpHtml += GetTitle("3、类型：");
	skinTestHelpHtml += GetContent("包含医嘱项/通用名。");
	skinTestHelpHtml += GetTitle("4、项目名称：");
	skinTestHelpHtml += GetContent("字典型（医嘱项目或通用名），可以定义与上方通用名或医嘱项实现结果互认的通用名或医嘱项；也可以定义开治疗用药时自动插入的皮试用药。");
	skinTestHelpHtml += GetTitle("5、结果标志：");
	skinTestHelpHtml += GetContent("单选框，勾选的药品在自动产生时会置上“皮试标志”（OE_OrdItem - OEORI_AdministerSkinTest）,是护士操作置皮试结果的医嘱，用以解决溶媒（如：氯化钠注射液10ml）不需要置皮试结果。一个治疗用药每种就诊类型关联的皮试用药的“结果标志”不能为空，至少有一种药品维护。勾选了结果标志的才能和上方的通用名/医嘱项实现皮试结果的同步。");
	skinTestHelpHtml += GetTitle("6、医嘱优先级：");
	skinTestHelpHtml += GetContent("下拉框，可以选择“临时医嘱/临时嘱托”，自动产生皮试药品的医嘱优先级，皮试用药需要单独收费领药配置为“临时医嘱”，如果不需要则设置为“临时嘱托”。");
	skinTestHelpHtml += GetTitle("7、剂量：");
	skinTestHelpHtml += GetContent("数值型文本框，自动产生的皮试用药的剂量。");
	skinTestHelpHtml += GetTitle("8、单位：");
	skinTestHelpHtml += GetContent("下拉框，取配置药品的等效单位。");
	skinTestHelpHtml += GetTitle("9、频次：");
	skinTestHelpHtml += GetContent("下拉框，可以选择“ONCE/ST”，自动产生的皮试用药的频次。");
	skinTestHelpHtml += GetTitle("10、关联序号：");
	skinTestHelpHtml += GetContent("仅适用于同种“就诊类型”的配置，皮试药品多数需要糖盐稀释配置，用以解决自动产生的成组皮试用药的关联关系。");
	skinTestHelpHtml += GetTitle("11、自动插入：");
	skinTestHelpHtml += GetContent("只有医嘱项才能配置为自动插入。配置为自动插入的必须维护优先级、剂量、频次、用法、单位等。");
	return skinTestHelpHtml;
}

function GetTitle(str, falg){
	return "<b>" + str + "</b><br/>";
}

function GetContent(str){
	return "&nbsp;&nbsp;&nbsp;&nbsp;" + str + "<br/>";
}
