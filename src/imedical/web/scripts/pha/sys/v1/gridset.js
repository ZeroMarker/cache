/**
 * @description: 药库的列设置 -- 暂时改为hisui的界面,后台程序不变
 * @creator: 	 Huxt
 * @createDate:  2020-09-02
 * @csp: 		 pha.sys.v1.gridset.csp
 * @js: 		 pha/sys/v1/gridset.js
 */

var curHospId = session['LOGON.HOSPID'];
var curGroupId = session['LOGON.GROUPID'];
var curUserId = session['LOGON.USERID'];
var curLocId = session['LOGON.CTLOCID'];

$(function() {
	PHA_COM.ResizePanel({
	    layoutId: 'layout-main',
	    region: 'south',
	    height: 0.5
	});
	
	InitFormData();
	InitGridApp();
	InitGridGridSet();
	InitGridGridColSet();
	InitEvents();
});

// 初始化 - 事件
function InitEvents() {
	$('#btnFind').on('click', function(){
		$('#gridApp').datagrid("options").selectedRowIndex = 0;
		QueryApp();
	});
	$('#btnDelete').on('click', Delete);
	$('#btnSave').on('click', Save);
}

// 初始化 - 表单
function InitFormData() {}

// 初始化 - 表格
function InitGridApp() {
    var columns = [[
		{ field: "RowId", title: 'RowId', width: 80, hidden: true },
		{ field: 'Code', title: '代码', width: 150 },
		{ field: 'Description', title: '名称', width: 150 },
		{ field: 'ModuType', title: '类型', width: 100, hidden: true }
    ]];
    var dataGridOption = {
        url: $URL,
        queryParams: {
	        ClassName: 'web.DHCST.DHCStkSysApp',
	        MethodName: 'HisuiSelectAll'
	    },
        columns: columns,
        loadMsg: '正在加载信息...',
        border: false,
        rownumbers: true,
        singleSelect: true,
        fit: true,
        fitColumns: true,
        pagination: false,
        toolbar: '#gridAppBar',
        onSelect: function(rowIndex, rowData) {
	        $('#gridGridSet').datagrid('query', {
		        AppName: rowData.Code || ""
		    });
	        $(this).datagrid("options").selectedRowIndex = rowIndex;
	    },
        onLoadSuccess: function(data) {
	        if (data.total > 0) {
				var selRowIdx = $(this).datagrid("options").selectedRowIndex;
				if (selRowIdx >= 0 && selRowIdx < data.rows.length) {
					$(this).datagrid("selectRow", selRowIdx);
				} else {
					$(this).datagrid("selectRow", 0);
				}
			}
        }
    };
    PHA.Grid("gridApp", dataGridOption);
}

// 初始化 - 表格
function InitGridGridSet() {
    var columns = [[
    	{ field: 'CspName', title: '菜单', width: 120 },
		{ field: "GridId", title: 'Grid', width: 120},
		{ field: 'SaveMod', title: '保存模式code', width: 100, hidden: true },
		{ field: 'SaveModDesc', title: '保存模式', width: 100},
		{ field: 'SaveValue', title: '保存模式值id', width: 120, hidden: true },
		{ field: 'SaveValueDesc', title: '保存模式值', width: 120 }
    ]];
    var dataGridOption = {
        url: $URL,
        queryParams: {
	        ClassName: 'web.DHCST.StkSysGridSet',
	        MethodName: 'HisuiGetVsfgInfo'
	    },
        columns: columns,
        loadMsg: '正在加载信息...',
        border: false,
        rownumbers: true,
        singleSelect: true,
        fit: true,
        fitColumns: true,
        pagination: false,
        toolbar: '#gridGridSetBar',
        onSelect: function(rowIndex, rowData) {
	        QueryGridColSet();
	        $(this).datagrid("options").selectedRowIndex = rowIndex;
	    },
        onLoadSuccess: function(data) {
	        if (data.total > 0) {
				var selRowIdx = $(this).datagrid("options").selectedRowIndex;
				if (selRowIdx >= 0 && selRowIdx < data.rows.length) {
					$(this).datagrid("selectRow", selRowIdx);
				} else {
					$(this).datagrid("selectRow", 0);
				}
			} else {
				$('#gridGridColSet').datagrid('clear');
			}
        }
    };
    PHA.Grid("gridGridSet", dataGridOption);
}

// 初始化 - 表格
function InitGridGridColSet() {
    var columns = [[
    	{ field: "rowid", title: 'rowid', width: 80, hidden: true },
    	{ field: "id", title: 'id', width: 80, hidden: true },
		{ field: "name", title: '列名', width: 100, editor: GridEditors.notNullText, },
		{ field: 'header', title: '列显示名称', width: 150, editor: GridEditors.notNullText },
		{ field: 'width', title: '列宽', width: 100, editor: GridEditors.number },
		{ field: 'align', title: '对齐方式', width: 100, editor: GridEditors.alignCombobox },
		{ field: 'format', title: '数字格式', width: 100, editor: GridEditors.text },
		{ field: 'hidden', title: '是否隐藏', width: 80, align:'center',
			editor: GridEditors.checkbox,
			formatter: function(value, rowData, index){
                if (value == "Y"){
					return PHA_COM.Fmt.Grid.Yes.Chinese;
				} else {
					return PHA_COM.Fmt.Grid.No.Chinese;
				}
            }
	    },
		{ field: 'sortable', title: '是否排序', width: 80, align:'center',
			editor: GridEditors.checkbox,
			formatter: function(value, rowData, index){
                if (value == "Y"){
					return PHA_COM.Fmt.Grid.Yes.Chinese;
				} else {
					return PHA_COM.Fmt.Grid.No.Chinese;
				}
            }
		},
		{ field: 'entersort', title: '回车跳转', width: 80, align:'center',
			editor: GridEditors.checkbox,
			formatter: function(value, rowData, index){
                if (value == "Y"){
					return PHA_COM.Fmt.Grid.Yes.Chinese;
				} else {
					return PHA_COM.Fmt.Grid.No.Chinese;
				}
            }
		},
		{ field: 'seqno', title: '列序号', width: 80, editor: GridEditors.number },
		{ field: 'datatype', title: '数据类型', width: 120, editor: GridEditors.dataTypeCombobox }
    ]];
    var dataGridOption = {
        url: $URL,
        queryParams: {
	        ClassName: 'web.DHCST.StkSysGridSet',
	        MethodName: 'HisuiQuery'
	    },
        columns: columns,
        loadMsg: '正在加载信息...',
        border: false,
        rownumbers: true,
        singleSelect: true,
        fit: true,
        fitColumns: true,
        pagination: false,
        toolbar: '#gridGridColSetBar',
        isAutoShowPanel: true,
		editFieldSort: ["name", "header", "width", "align", "format", "hidden", "sortable", "entersort", "seqno", "datatype"],
        onClickCell: function(index, field, value){
	        $('#gridGridColSet').datagrid('endEditing');
	    },
        onDblClickCell: function(index, field, value){
	        PHA_GridEditor.Edit({
				gridID: "gridGridColSet",
				index: index,
			    field: field
			});
	    },
        onSelect: function(rowIndex, rowData) {
	    },
        onLoadSuccess: function() {
        }
    };
    PHA.Grid("gridGridColSet", dataGridOption);
}

function QueryApp(){
	$('#gridApp').datagrid('reload');
}

function QueryGridColSet(){
	var mainData = GetMainData();
	if (mainData == null) {
		return;
	}
    $('#gridGridColSet').datagrid('query', {
        ClassName: 'web.DHCST.StkSysGridSet',
    	MethodName: 'HisuiQuery',
        AppName: mainData.AppName,
        GridId: mainData.GridId,
        SaveMod: mainData.SaveMod,
        SaveValue: mainData.SaveValue,
        CspName: mainData.CspName
    });
}

function Delete(){
	var mainData = GetMainData();
	if (mainData == null) {
		return;
	}
	
	PHA.Confirm('温馨提示', '是否确认删除？', function(){
		var delRetStr = tkMakeServerCall(
			'web.DHCST.StkSysGridSet',
			'Delete', 
			mainData.AppId,
			mainData.GridId,
			mainData.SaveMod,
			mainData.SaveValue,
			mainData.CspName
		);
		var delRetArr = delRetStr.split('^');
		if (delRetArr[0] < 0) {
			PHA.Alert("提示", delRetArr[1], delRetArr[0]);
		} else {
			PHA.Popover({
				msg: '删除成功!',
				type: "success"
			});
			QueryApp();
		}
	});
}

function Save(){
	var mainData = GetMainData();
	if (mainData == null) {
		return;
	}
	// 明细
	$('#gridGridColSet').datagrid('endEditing');
	var rowsData = $('#gridGridColSet').datagrid('getRows');
	if (rowsData == null || rowsData.length == 0) {
		PHA.Popover({msg: '没有需要保存的列信息!', type: "alert"});
		return;
	}
	// 验证值
	var chkRetStr = PHA_GridEditor.CheckValues('gridGridColSet');
	if (chkRetStr != "") {
		PHA.Popover({msg: chkRetStr, type: "alert"});
		return;
	}
	
	var listData = "";
	for (var i = 0; i < rowsData.length; i++) {
		var oneRow = rowsData[i];
		var rowid = oneRow.rowid;
		var seqno = oneRow.seqno;
		var id = oneRow.id;
		var header = oneRow.header;
		var width = oneRow.width;
		var align = oneRow.align;
		var sortable = oneRow.sortable;
		var hidden = oneRow.hidden;
		var name = oneRow.name;
		var format = oneRow.format;
		var dataType = oneRow.datatype;
		var entersort = oneRow.entersort;
		var dataRow = rowid+"^"+seqno+"^"+id+"^"+header+"^"+width+"^"+align+"^"+sortable+"^"+hidden+"^"+name+"^"+format+"^"+dataType+"^"+entersort;
		if(listData == ""){
			listData = dataRow;
		}else{
			listData = listData + String.fromCharCode(1) + dataRow;
		}
	}
	
	var saveRetStr = tkMakeServerCall(
		'web.DHCST.StkSysGridSet',
		'Save', 
		mainData.AppName,
		mainData.GridId,
		mainData.SaveMod,
		mainData.SaveValue,
		mainData.CspName,
		listData
	);
	var saveRetArr = saveRetStr.split('^');
	if (saveRetArr[0] < 0) {
		PHA.Alert("提示", saveRetArr[1], saveRetArr[0]);
	} else {
		PHA.Popover({
			msg: '保存成功!',
			type: "success"
		});
		QueryGridColSet();
	}
}

function GetMainData(){
	var selGridApp = $('#gridApp').datagrid('getSelected');
	var AppName = (selGridApp || {}).Code || "";
	var AppId = (selGridApp || {}).RowId || "";
	if (AppName == "" || AppId == "") {
		PHA.Popover({msg: '请选择产品模块!', type: "info"});
		return null;
	}
	var selGridSet = $('#gridGridSet').datagrid('getSelected') || {};
	var GridId = selGridSet.GridId || "";
	if (GridId == "") {
		PHA.Popover({msg: 'Grid不能为空!', type: "info"});
		return null;
	}
	var SaveMod = selGridSet.SaveMod || "";
	if (SaveMod == "") {
		PHA.Popover({msg: '保存模式不能为空!', type: "info"});
		return null;
	}
	var SaveValue = selGridSet.SaveValue || "";
	if (SaveValue == "") {
		PHA.Popover({msg: '保存模式值不能为空!', type: "info"});
		return null;
	}
	var CspName = selGridSet.CspName || "";
	if (CspName == "") {
		PHA.Popover({msg: '菜单不能为空!', type: "info"});
		return null;
	}
	return {
		AppId: AppId,
		AppName: AppName,
		GridId: GridId,
		SaveMod: SaveMod,
		SaveValue: SaveValue,
		CspName: CspName
	}
}

/*
* Grid Editors for this page
*/
var GridEditors = {
	// 数字
	number: {
		type: 'validatebox',
        options: {
	        regExp: /^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$/,
			regTxt: '只能为大于0的数字!',
	        onEnter: function() {
		        PHA_GridEditor.Next();
		    }
	    }
	},
	// 文本
	notNullText: {
		type: 'validatebox',
        options: {
	        regExp: /\S/,
			regTxt: '不能为空!',
	        onEnter: function(){
		        PHA_GridEditor.Next();
		    }
	    }
	},
	// 文本
	text: {
		type: 'validatebox',
        options: {
	        onEnter: function(){
		        PHA_GridEditor.Next();
		    }
	    }
	},
	// 复选
	checkbox: {
		type: 'icheckbox',
	    options: {
		    on: 'Y',
		    off: 'N'
		}
	},
	// 下拉
	alignCombobox: {
        type: 'combobox',
        options: {
	        regExp: /\S/,
			regTxt: '不能为空!',
            valueField: 'RowId',
            textField: 'Description',
            mode: 'local',
            data: [
            	{RowId:'left', Description:'left'},
            	{RowId:'right', Description:'right'},
            	{RowId:'center', Description:'center'}
            ],
            onShowPanel: function(){
				PHA_GridEditor.Show();
			},
            onHidePanel: function(){
				PHA_GridEditor.Next();
			}
        }
    },
    // 下拉
	dataTypeCombobox: {
        type: 'combobox',
        options: {
            valueField: 'RowId',
            textField: 'Description',
            mode: 'local',
            data: [
            	{RowId:'any', Description:'any'},
            	{RowId:'String', Description:'String'},
            	{RowId:'Currency', Description:'Currency'},
            	{RowId:'Double', Description:'Double'},
            	{RowId:'Single', Description:'Single'},
            	{RowId:'Long', Description:'Long'},
            	{RowId:'Short', Description:'Short'},
            	{RowId:'Date', Description:'Date'},
            	{RowId:'Boolean', Description:'Boolean'}
            ],
            onShowPanel: function(){
				PHA_GridEditor.Show();
			},
            onHidePanel: function(){
				PHA_GridEditor.Next();
			}
        }
    }
}

//动态设置高度
function ResetPanelHeight(_options){
	if(_options.height < 1){
		var vWidth = document.documentElement.clientWidth;
		var vHeight = document.documentElement.clientHeight;
		_options.height = _options.height * vHeight;
	}
	$('#'+_options.layoutId).layout('panel', _options.region).panel('resize',{height: _options.height});
	$('#'+_options.layoutId).layout('resize');
}