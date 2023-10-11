/**
 * 名称:	 药房药库-药学首页-卡片内容字典维护
 * 编写人:	 Huxt
 * 编写日期: 2020-04-13
 * csp:  	 pha.sys.v1.cardcontent.csp
 * js:		 pha/sys/v1/cardcontent.js
 */
PHA_COM.App.Csp = "pha.sys.v1.cardcontent.csp"
PHA_COM.App.CspDesc = "卡片内容维护"
PHA_COM.App.ProDesc = "公共业务"

$(function() {
    InitFormData();
    InitGridCardContent();
    InitGridCardContentItm();
    
    $('#btnFind').on("click", Query);
    $('#btnAdd').on("click", Add);
    $('#btnSave').on("click", Save);
    $('#btnDel').on('click', Delete);
    
    $('#btnFindItm').on("click", QueryItm);
    $('#btnAddItm').on("click", AddItm);
    $('#btnSaveItm').on("click", SaveItm);
    $('#btnDelItm').on('click', DeleteItm);
});

// 表单元素
function InitFormData() {}

// 卡片内容类型
function InitGridCardContent() {
    var columns = [[
    	{ field: "picc", title: 'picc', width: 80, hidden:true},
		{ field: "piccCode", title: '内容代码', width: 120, editor: GridEditors.notNullText},
		{ field: 'piccDesc', title: '内容名称', width: 100, editor: GridEditors.notNullText},
		{ field: 'piccFormFlag', title: '是否表单', width: 70, align: 'center', editor: GridEditors.checkBox, formatter: PHA.CheckBoxFormatter},
		{ field: 'piccActiveFlag', title: '是否可用', width: 70, align: 'center', editor: GridEditors.checkBox, formatter: PHA.CheckBoxFormatter}
    ]];
    var dataGridOption = {
        url: $URL,
		queryParams: {
			ClassName: 'PHA.SYS.CardContent.Query',
			QueryName: 'PHAINCardContent'
		},
        fitColumns: true,
        border: false,
        rownumbers: true,
        columns: columns,
        pagination: false,
        singleSelect: true,
        toolbar: '#gridCardContentBar',
        isAutoShowPanel: true,
        editFieldSort: ["piccCode", "piccDesc"],
	    onSelect: function(rowIndex, rowData) {},
	    onClickRow: function(rowIndex, rowData) {
            $('#gridCardContent').datagrid('endEditing');
            QueryItm();
        },
        onDblClickCell: function(index, field, value) {
            PHA_GridEditor.Edit({
				gridID: "gridCardContent",
				index: index,
				field: field
			});
        },
        onLoadSuccess: function(data) {
	        if (data.total > 0) {
		        $('#gridCardContent').datagrid('selectRow', 0);
		        QueryItm();
		    }
	    }
    };
    PHA.Grid("gridCardContent", dataGridOption);
}

// 卡片内容类型属性
function InitGridCardContentItm() {
    var columns = [[
    	{ field: "picc", title: 'picc', width: 80, hidden:true},
    	{ field: "picci", title: 'picci', width: 80, hidden:true},
		{ 
			field: "picciCode",
			title: '属性代码',
			width: 150,
			editor: GridEditors.notNullText
		}, { 
			field: 'picciDesc',
			title: '属性名称',
			width: 150,
			editor: GridEditors.notNullText
		}, { 
			field: 'picciComFlag',
			title: '公共属性',
			width: 70,
			align: 'center',
			editor: GridEditors.checkBox,
			formatter: PHA.CheckBoxFormatter
		},
		{ 
			field: 'picciHUIFlag',
			title: 'HISUI属性',
			width: 85,
			align: 'center',
			editor: GridEditors.checkBox,
			formatter: PHA.CheckBoxFormatter
		}, { 
			field: 'picciRequiredFlag',
			title: '是否必填',
			width: 70,
			align: 'center',
			editor: GridEditors.checkBox,
			formatter: PHA.CheckBoxFormatter
		}, {
			field: 'picciActiveFlag',
			title: '是否有效',
			width: 70,
			align: 'center',
			editor: GridEditors.checkBox,
			formatter: PHA.CheckBoxFormatter
		}, { 
			field: 'picciValType',
			title: '取值类型',
			width: 100,
			editor: GridEditors.ValType,
        	formatter: function(value, rowData, index){
            	return rowData.picciValType
        	}
		}, { 
			field: 'picciValRange',
			title: '取值范围', width: 150,
			editor: GridEditors.comText,
			showTip: true,
			tipWidth: 180
		}, {
	        field: 'picciFormType',
	        title: '表单类型',
	        width: 120,
	        editor: GridEditors.FormType,
	        formatter: function(value, rowData, index){
	            return rowData.picciFormType;
	        }
	    }, {
	        field: 'picciFormSort',
	        title: '表单顺序',
	        width: 80,
	        hidden: true
	    }, {
	        field: 'picciFormVal',
	        title: '表单默认值',
	        width: 120,
	        editor: GridEditors.comText,
	    }, { 
	    	field: 'picciMemo',
	    	title: '使用说明',
	    	width: 300,
			editor: GridEditors.comText,
			showTip: true,
			tipWidth: 180
		}
    ]];
    var dataGridOption = {
        url: $URL,
		queryParams: {
			ClassName: 'PHA.SYS.CardContent.Query',
			QueryName: 'PHAINCardContentItm'
		},
        fitColumns: false,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: false,
        singleSelect: true,
        toolbar: '#gridCardContentItmBar',
        isAutoShowPanel: true,
        editFieldSort: ["picciCode","picciDesc","picciComFlag","picciHUIFlag","picciRequiredFlag","picciActiveFlag","picciValType","picciValRange","picciFormType","picciFormVal","picciMemo"],
        onSelect: function(rowIndex, rowData) {},
        onClickRow: function(rowIndex, rowData) {
            PHA_GridEditor.End("gridCardContentItm");
            InitUpAndDown();
        },
        onDblClickCell: function(index, field, value) {
            PHA_GridEditor.Edit({
				gridID: "gridCardContentItm",
				index: index,
				field: field
			});
        },
        onLoadSuccess: function() {}
    };
    PHA.Grid("gridCardContentItm", dataGridOption);
}


// 查询
function Query() {
	$("#gridCardContent").datagrid("query", {
		iinputStr: ''
	});
}

// 新增
function Add() {
	PHA_GridEditor.Add({
		gridID: 'gridCardContent',
		field: 'piccCode',
		rowData: {piccActiveFlag: 'Y'}
	});
	$('#gridCardContentItm').datagrid('clear');
}

// 保存
function Save() {
	// 获取值
    $('#gridCardContent').datagrid('endEditing');
	var changedRows = PHA.GridChangedRows("gridCardContent");
	if (changedRows.length == 0) {
		return;
	}
	// 前台验证
    var chkRetStr = PHA_GridEditor.CheckValues('gridCardContent');
	if (chkRetStr != "") {
		PHA.Popover({msg: chkRetStr, type: "alert"});
		return;
	}
	var saveRows = RowsAddRowIndex('gridCardContent', changedRows);
	var jsonDataStr =  JSON.stringify(saveRows);
	
	// 保存
	var retStr = $.cm({
		ClassName: 'PHA.SYS.CardContent.Save',
		MethodName: 'SaveMulti',
		jsonDataStr: jsonDataStr,
		dataType: 'text'
	}, false);
	PHA.AfterRunServer(retStr, Query);
}

// 删除
function Delete() {
	var selectedRow = $("#gridCardContent").datagrid("getSelected");
	if (selectedRow == null) {
		PHA.Popover({
			msg: "请选择需要删除的属性!",
			type: "alert"
		});
		return;
	}
	var picc = selectedRow.picc || "";
	PHA.Confirm("删除提示", "是否确认删除？", function () {
		if (picc == "") {
			var rowIndex = $("#gridCardContent").datagrid('getRowIndex', selectedRow);
			$("#gridCardContent").datagrid('deleteRow', rowIndex);
			return;
		}
		var retStr = $.cm({
			ClassName: 'PHA.SYS.CardContent.Save',
			MethodName: 'Delete',
			ID: picc,
			dataType: 'text'
		}, false);
		PHA.AfterRunServer(retStr, Query);
	});
}

// 查询属性
function QueryItm() {
	var selectedRow = $("#gridCardContent").datagrid("getSelected");
    if (selectedRow == null) {
        return;
    }
    var picc = selectedRow.picc || "";
	$("#gridCardContentItm").datagrid("query", {
		inputStr: picc
	});
}

// 新增属性
function AddItm() {
    var selectedRow = $("#gridCardContent").datagrid("getSelected") || {};
    var picc = selectedRow.picc || "";
    if (picc == "" || picc == 0) {
        PHA.Popover({
            msg: "请选择左侧卡片内容!",
            type: "alert"
        });
        return;
    }
    PHA_GridEditor.Add({
		gridID: 'gridCardContentItm',
		field: 'picciCode',
		rowData: {
			picc: picc,
			picciComFlag: 'Y', //都作为公共属性吧
			picciActiveFlag: 'Y',
			picciValType: 'string',
		}
	});
}

// 保存属性
function SaveItm() {
	// 获取值
    $('#gridCardContentItm').datagrid('endEditing');
	var changedRows = PHA.GridChangedRows("gridCardContentItm");
	if (changedRows.length == 0) {
		return;
	}
	// 前台验证
    var chkRetStr = PHA_GridEditor.CheckValues('gridCardContentItm');
	if (chkRetStr != "") {
		PHA.Popover({msg: chkRetStr, type: "alert"});
		return;
	}
	var saveRows = RowsAddRowIndex('gridCardContentItm', changedRows);
	var jsonDataStr =  JSON.stringify(saveRows);
	
	// 保存
	var retStr = $.cm({
		ClassName: 'PHA.SYS.CardContent.Save',
		MethodName: 'SaveItmMulti',
		jsonDataStr: jsonDataStr,
		dataType: 'text'
	}, false);
	PHA.AfterRunServer(retStr, QueryItm);
}

// 删除属性
function DeleteItm() {
	var selectedRow = $("#gridCardContentItm").datagrid("getSelected");
	if (selectedRow == null) {
		PHA.Popover({
			msg: "请选择需要删除的内容属性!",
			type: "alert"
		});
		return;
	}
	var picci = selectedRow.picci || "";
	PHA.Confirm("删除提示", "是否确认删除？", function () {
		if (picci == "") {
			var rowIndex = $("#gridCardContentItm").datagrid('getRowIndex', selectedRow);
			$("#gridCardContentItm").datagrid('deleteRow', rowIndex);
			return;
		}
		var retStr = $.cm({
			ClassName: 'PHA.SYS.CardContent.Save',
			MethodName: 'DeleteItm',
			ID: picci,
			dataType: 'text'
		}, false);
		PHA.AfterRunServer(retStr, QueryItm);
	});
}

function InitUpAndDown(){
	PHA_GridEditor.GridAtive({
		gridID: "gridCardContentItm",
		type: 'exchange',
		gridKeyEvent: function(e, chkRet){
			if (e.keyCode == 38 || e.keyCode == 40) {
				if (chkRet == false) {
					return;
				}
				var seletedRow = $("#gridCardContentItm").datagrid('getSelected');
				var rowIndex = $('#gridCardContentItm').datagrid('getRowIndex', seletedRow);
				var newRowIndex = e.keyCode == 38 ? rowIndex + 1 : rowIndex - 1;
				var rowsData = $("#gridCardContentItm").datagrid('getRows');
				var rowData = rowsData[rowIndex];
				var newRowData = rowsData[newRowIndex];
				rowData.picaFormSort = rowIndex + 1;
				newRowData.picaFormSort = newRowIndex + 1;
				var jsonArr = [rowData, newRowData];
				var jsonDataStr = JSON.stringify(jsonArr);
				// 保存
			    var retStr = $.cm({
			        ClassName: 'PHA.SYS.CardContent.Save',
			        MethodName: 'SaveItmMulti',
			        jsonDataStr: jsonDataStr,
			        dataType: 'text'
			    }, false);
			    PHA.AfterRunServer(retStr);
			}
		}
	});
}

/*
* Grid Editors for this page
*/
var GridEditors = {
	// 普通文本
	comText: {
		type: 'validatebox',
        options: {
	        onEnter: function() {
		        PHA_GridEditor.Next();
		    }
	    }
	},
	// 非空文本
	notNullText: {
		type: 'validatebox',
        options: {
	        required: true,
	        regExp: /\S/,
			regTxt: '不能为空',
			checkOnBlur: false,
	        onEnter: function() {
		        PHA_GridEditor.Next();
		    }
	    }
	},
	// 复选
	checkBox: {
		type: 'icheckbox',
	    options: {
		    on: 'Y',
		    off: 'N'
		}
	},
	// 值类型下拉
	ValType: {
		type: 'combobox',
		options: {
			required: true,
			valueField: 'RowId',
			textField: 'Description',
			mode: 'remote',
			panelHeight: 'auto',
			url: $URL + '?ClassName=PHA.SYS.Store&QueryName=ValTypeList&ResultSetType=array',
			onBeforeLoad: function(param) {
				param.QText = param.q
			},
			onShowPanel: function(){
				PHA_GridEditor.Show();
			},
			onHidePanel: function(){
				PHA_GridEditor.Next();
			}
		}
	},
	// 表单类型
	FormType: {
		type: 'combobox',
		options: {
			required: true,
			valueField: 'RowId',
			textField: 'Description',
			mode: 'remote',
			panelHeight: 'auto',
			url: $URL + '?ClassName=PHA.SYS.Store&QueryName=FormTypeList&ResultSetType=array',
			onBeforeLoad: function(param) {
				param.QText = param.q
			},
			onShowPanel: function(){
				PHA_GridEditor.Show();
			},
			onHidePanel: function(){
				PHA_GridEditor.Next();
			}
		}
	}
}

// 给每一条数据添加行号
function RowsAddRowIndex(gridID, rowsData, k){
	var rowIndexKey = k || "rowIndex";
	var newRowsData = [];
	for (var i = 0; i < rowsData.length; i++) {
		var oneRow = rowsData[i];
		oneRow[rowIndexKey] = GetRowIndex(gridID, oneRow) + 1;
		newRowsData.push(oneRow);
	}
	return newRowsData;
}
// 根据数据获取行号
function GetRowIndex(gridID, rowData){
	var rowIndex = $("#" + gridID).datagrid('getRowIndex', rowData);
	return rowIndex;
}