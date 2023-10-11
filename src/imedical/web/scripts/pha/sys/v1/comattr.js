/**
 * 名称:	 药房药库-药学首页-公共属性字典维护
 * 编写人:	 Huxt
 * 编写日期: 2020-04-16
 * csp:  	 pha.sys.v1.comattr.csp
 * js:		 pha/sys/v1/comattr.js
 */
PHA_COM.App.Csp = "pha.sys.v1.comattr.csp"
PHA_COM.App.CspDesc = "公共属性字典维护"
PHA_COM.App.ProDesc = "公共业务"
PHA_COM.Temp = {}
PHA_COM.Temp.IsUpdate = false;
PHA_COM.Temp.PwdCode = (function(){
	var pwdCodeStr = tkMakeServerCall('PHA.SYS.ComAttr.Query', 'GetPwdCodeStr');
	return pwdCodeStr.split('|');
})();

$(function() {
    InitFormData();
    InitGridComAttr();
    InitGridComAttrItm();

    $('#btnFind').on("click", Query);
    $('#btnAdd').on("click", Add);
    $('#btnSave').on("click", Save);
    $('#btnDel').on('click', Delete);

    $('#btnAddItm').on("click", AddItm);
    $('#btnSaveItm').on("click", SaveItm);
    $('#btnDelItm').on('click', DeleteItm);
});

// 表单元素
function InitFormData() {}

// 卡片内容类型
function InitGridComAttr() {
    var columns = [[{
        field: "pica",
        title: 'pica',
        width: 80,
        hidden: true
    }, {
        field: "picaParDR",
        title: 'picaParDR',
        width: 80,
        hidden: true
    }, {
        field: "picaCode",
        title: '类型代码',
        width: 80,
        editor: GridEditors.notNullText
    }, {
        field: 'picaDesc',
        title: '类型名称',
        width: 100,
        editor: GridEditors.notNullText
    }, {
        field: 'picaActiveFlag',
        title: '是否可用',
        width: 70,
        align: 'center',
        editor: GridEditors.checkBox,
        formatter: PHA.CheckBoxFormatter
    }]];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.SYS.ComAttr.Query',
            QueryName: 'PHAINComAttr',
            inputStr: 0
        },
        fitColumns: true,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: false,
        singleSelect: true,
        toolbar: '#gridComAttrBar',
        isAutoShowPanel: true,
        editFieldSort: ["picaCode", "picaDesc", "picaActiveFlag"],
        onSelect: function(rowIndex, rowData) {},
	    onClickRow: function(rowIndex, rowData) {
            $('#gridComAttr').datagrid('endEditing');
            QueryItm();
        },
        onDblClickCell: function(index, field, value) {
            PHA_GridEditor.Edit({
				gridID: "gridComAttr",
				index: index,
				field: field
			});
        },
        onLoadSuccess: function(data) {
	        if (data.total > 0) {
		        $('#gridComAttr').datagrid('selectRow', 0);
		        QueryItm();
		    }
	    }
    };
    PHA.Grid("gridComAttr", dataGridOption);
}

// 卡片内容类型属性
function InitGridComAttrItm() {
    var columns = [[{
        field: "pica",
        title: 'pica',
        width: 80,
        hidden: true
    }, {
        field: "picaCode",
        title: '属性代码',
        width: 150,
        editor: GridEditors.notNullText
    }, {
        field: 'picaDesc',
        title: '属性名称',
        width: 150,
        editor: GridEditors.notNullText
    }, {
        field: 'picaParDR',
        title: 'picaParDR',
        width: 80,
        hidden: true
    }, {
        field: 'picaComFlag',
        title: '公共属性',
        width: 70,
        align: 'center',
        editor: GridEditors.checkBox,
        formatter: PHA.CheckBoxFormatter
    }, {
        field: 'picaHUIFlag',
        title: 'HISUI属性',
        width: 85,
        align: 'center',
        editor: GridEditors.checkBox,
        formatter: PHA.CheckBoxFormatter
    }, {
        field: 'picaRequiredFlag',
        title: '必填属性',
        width: 70,
        align: 'center',
        editor: GridEditors.checkBox,
        formatter: PHA.CheckBoxFormatter
    }, {
        field: 'picaActiveFlag',
        title: '是否有效',
        width: 70,
        align: 'center',
        editor: GridEditors.checkBox,
        formatter: PHA.CheckBoxFormatter
    }, {
        field: 'picaValType',
		descField: 'picaValType',
        title: '属性值类型',
        width: 100,
        editor: GridEditors.picaValType,
        formatter: function(value, rowData, index){
            return rowData.picaValType
        }
    }, {
        field: 'picaValRange',
        title: '属性值范围',
        width: 120,
        editor: GridEditors.comText,
        showTip: true,
		tipWidth: 180
    }, {
        field: 'picaFormType',
        title: '表单类型',
        width: 120,
        editor: GridEditors.picaFormType,
        formatter: function(value, rowData, index){
            return rowData.picaFormType
        }
    }, {
        field: 'picaFormSort',
        title: '表单顺序',
        width: 80,
        hidden: true
    }, {
        field: 'picaFormVal',
        title: '表单默认值',
        width: 120,
        editor: GridEditors.comText,
        formatter: function(value, rowData, index){
			if (PHA_COM.Temp.PwdCode.indexOf(rowData.picaCode) >= 0) {
				return GetPassword(value);
			}
			return value;
		}
    }, {
        field: 'picaMemo',
        title: '使用说明',
        width: 180,
        editor: GridEditors.comText,
        showTip: true,
		tipWidth: 180
    }]];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.SYS.ComAttr.Query',
            QueryName: 'PHAINComAttr'
        },
        fitColumns: false,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: false,
        singleSelect: true,
        toolbar: '#gridComAttrItmBar',
        isAutoShowPanel: true,
        editFieldSort: ["picaCode","picaDesc","picaComFlag","picaHUIFlag","picaRequiredFlag","picaActiveFlag","picaValType","picaValRange","picaFormType","picaFormVal","picaMemo"],
        onSelect: function(rowIndex, rowData) {},
        onClickRow: function(rowIndex, rowData) {
            PHA_GridEditor.End("gridComAttrItm");
            InitUpAndDown();
        },
        onDblClickCell: function(index, field, value) {
	        // 开始编辑
            PHA_GridEditor.Edit({
				gridID: "gridComAttrItm",
				index: index,
				field: field
			});
			// 判断是否需要修改为密码框
			if (field == "picaFormVal") {
				var rowsData = $('#gridComAttrItm').datagrid('getRows');
				var rowData = rowsData[index];
				if (PHA_COM.Temp.PwdCode.indexOf(rowData.picaCode) >= 0) {
					var ed = $('#gridComAttrItm').datagrid('getEditor', {index:index, field:field});
					var edTargets = ed.target;
					if (edTargets.length > 0) {
						var edTarget = edTargets[0];
						edTarget.type = "password";
					}
				}
			}
        },
        onLoadSuccess: function() {}
    };
    PHA.Grid("gridComAttrItm", dataGridOption);
}

// 查询
function Query() {
    $("#gridComAttr").datagrid("query", {
        inputStr: 0
    });
}

// 新增
function Add() {
	PHA_GridEditor.Add({
		gridID: 'gridComAttr',
		field: 'picaCode',
		rowData: {picaParDR:0, picaActiveFlag: 'Y'}
	});
	$('#gridComAttrItm').datagrid('clear');
}

// 保存
function Save() {
	$('#gridComAttr').datagrid('endEditing');
    var changedRows = PHA.GridChangedRows("gridComAttr");
    if (changedRows.length == 0) {
        return;
    }
    // 前台验证
    var chkRetStr = PHA_GridEditor.CheckValues('gridComAttr');
	if (chkRetStr != "") {
		PHA.Popover({msg: chkRetStr, type: "alert"});
		return;
	}
	var saveRows = RowsAddRowIndex('gridComAttr', changedRows);
    var jsonDataStr = JSON.stringify(saveRows);
    // 保存
    var retStr = $.cm({
        ClassName: 'PHA.SYS.ComAttr.Save',
        MethodName: 'SaveMulti',
        jsonDataStr: jsonDataStr,
        dataType: 'text'
    }, false);
    PHA.AfterRunServer(retStr, Query);
}

// 删除
function Delete() {
    // 要删除的ID
    var selectedRow = $("#gridComAttr").datagrid("getSelected");
    if (selectedRow == null) {
        PHA.Popover({
            msg: "请选择需要删除的属性!",
            type: "alert"
        });
        return;
    }
    var pica = selectedRow.pica || "";
    // 删除确认
    PHA.Confirm("删除提示", "是否确认删除该属性类型?", function() {
        if (pica == "") {
            var rowIndex = $("#gridComAttr").datagrid('getRowIndex', selectedRow);
            $("#gridComAttr").datagrid('deleteRow', rowIndex);
            return;
        }
        var retStr = $.cm({
            ClassName: 'PHA.SYS.ComAttr.Save',
            MethodName: 'Delete',
            ID: pica,
            dataType: 'text'
        }, false);
        PHA.AfterRunServer(retStr, Query);
    });
}

// 查询属性
function QueryItm() {
	var selectedRow = $("#gridComAttr").datagrid("getSelected");
    if (selectedRow == null) {
        return;
    }
    var pica = selectedRow.pica || "";
    $("#gridComAttrItm").datagrid("query", {
        inputStr: pica
    });
}

// 新增属性
function AddItm() {
    // 选择的ID
    var selectedRow = $("#gridComAttr").datagrid("getSelected") || {};
    var pica = selectedRow.pica || "";
    if (pica == "" || pica == 0) {
        PHA.Popover({
            msg: "请选择属性类型!",
            type: "alert"
        });
        return;
    }
    var rowsData = $("#gridComAttr").datagrid("getRows");
    PHA_GridEditor.Add({
		gridID: 'gridComAttrItm',
		field: 'picaCode',
		rowData: {
			picaParDR: pica,
			picaActiveFlag: 'Y',
			picaFormSort: rowsData.length,
			picaValType: 'string'
		}
	});
}

// 保存属性
function SaveItm() {
	$('#gridComAttrItm').datagrid('endEditing');
    var changedRows = PHA.GridChangedRows("gridComAttrItm");
    if (changedRows.length == 0) {
        return;
    }
    // 前台验证
    var chkRetStr = PHA_GridEditor.CheckValues('gridComAttrItm');
	if (chkRetStr != "") {
		PHA.Popover({msg: chkRetStr, type: "alert"});
		return;
	}
	var saveRows = RowsAddRowIndex('gridComAttrItm', changedRows);
    var jsonDataStr = JSON.stringify(saveRows);
    
    // 保存
    var retStr = $.cm({
        ClassName: 'PHA.SYS.ComAttr.Save',
        MethodName: 'SaveMulti',
        jsonDataStr: jsonDataStr,
        dataType: 'text'
    }, false);
    PHA.AfterRunServer(retStr, QueryItm);
}

// 删除属性
function DeleteItm() {
    // 要删除的ID
    var selectedRow = $("#gridComAttrItm").datagrid("getSelected");
    if (selectedRow == null) {
        PHA.Popover({
            msg: "请选择属性!",
            type: "alert"
        });
        return;
    }
    var pica = selectedRow.pica || "";
    
    // 删除确认
    PHA.Confirm("删除提示", "是否确认删除？", function() {
        if (pica == "") {
            var rowIndex = $("#gridComAttrItm").datagrid('getRowIndex', selectedRow);
            $("#gridComAttrItm").datagrid('deleteRow', rowIndex);
            return;
        }
        var retStr = $.cm({
            ClassName: 'PHA.SYS.ComAttr.Save',
            MethodName: 'Delete',
            ID: pica,
            dataType: 'text'
        }, false);
        PHA.AfterRunServer(retStr, QueryItm);
    });
}

function InitUpAndDown(){
	PHA_GridEditor.GridAtive({
		gridID: "gridComAttrItm",
		type: 'exchange',
		gridKeyEvent: function(e, chkRet){
			if (e.keyCode == 38 || e.keyCode == 40) {
				if (chkRet == false) {
					return;
				}
				var seletedRow = $("#gridComAttrItm").datagrid('getSelected');
				var rowIndex = $('#gridComAttrItm').datagrid('getRowIndex', seletedRow);
				var newRowIndex = e.keyCode == 38 ? rowIndex + 1 : rowIndex - 1;
				var rowsData = $("#gridComAttrItm").datagrid('getRows');
				var rowData = rowsData[rowIndex];
				var newRowData = rowsData[newRowIndex];
				rowData.picaFormSort = rowIndex + 1;
				newRowData.picaFormSort = newRowIndex + 1;
				var jsonArr = [rowData, newRowData];
				var jsonDataStr = JSON.stringify(jsonArr);
				// 保存
			    var retStr = $.cm({
			        ClassName: 'PHA.SYS.ComAttr.Save',
			        MethodName: 'SaveMulti',
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
	picaValType: {
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
	picaFormType: {
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

function GetPassword(val){
	val = val || "";
	var vl = val.toString().length;
	var pwdStr = "";
	for (var i = 0; i < vl; i++) {
		if (pwdStr == "") {
			pwdStr = "·";
		} else {
			pwdStr = pwdStr + "·";
		}
	}
	return "<b>" + pwdStr + "</b>"
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