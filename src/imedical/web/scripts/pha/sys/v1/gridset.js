/**
 * @description: ҩ��������� -- ��ʱ��Ϊhisui�Ľ���,��̨���򲻱�
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

// ��ʼ�� - �¼�
function InitEvents() {
	$('#btnFind').on('click', function(){
		$('#gridApp').datagrid("options").selectedRowIndex = 0;
		QueryApp();
	});
	$('#btnDelete').on('click', Delete);
	$('#btnSave').on('click', Save);
}

// ��ʼ�� - ��
function InitFormData() {}

// ��ʼ�� - ���
function InitGridApp() {
    var columns = [[
		{ field: "RowId", title: 'RowId', width: 80, hidden: true },
		{ field: 'Code', title: '����', width: 150 },
		{ field: 'Description', title: '����', width: 150 },
		{ field: 'ModuType', title: '����', width: 100, hidden: true }
    ]];
    var dataGridOption = {
        url: $URL,
        queryParams: {
	        ClassName: 'web.DHCST.DHCStkSysApp',
	        MethodName: 'HisuiSelectAll'
	    },
        columns: columns,
        loadMsg: '���ڼ�����Ϣ...',
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

// ��ʼ�� - ���
function InitGridGridSet() {
    var columns = [[
    	{ field: 'CspName', title: '�˵�', width: 120 },
		{ field: "GridId", title: 'Grid', width: 120},
		{ field: 'SaveMod', title: '����ģʽcode', width: 100, hidden: true },
		{ field: 'SaveModDesc', title: '����ģʽ', width: 100},
		{ field: 'SaveValue', title: '����ģʽֵid', width: 120, hidden: true },
		{ field: 'SaveValueDesc', title: '����ģʽֵ', width: 120 }
    ]];
    var dataGridOption = {
        url: $URL,
        queryParams: {
	        ClassName: 'web.DHCST.StkSysGridSet',
	        MethodName: 'HisuiGetVsfgInfo'
	    },
        columns: columns,
        loadMsg: '���ڼ�����Ϣ...',
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

// ��ʼ�� - ���
function InitGridGridColSet() {
    var columns = [[
    	{ field: "rowid", title: 'rowid', width: 80, hidden: true },
    	{ field: "id", title: 'id', width: 80, hidden: true },
		{ field: "name", title: '����', width: 100, editor: GridEditors.notNullText, },
		{ field: 'header', title: '����ʾ����', width: 150, editor: GridEditors.notNullText },
		{ field: 'width', title: '�п�', width: 100, editor: GridEditors.number },
		{ field: 'align', title: '���뷽ʽ', width: 100, editor: GridEditors.alignCombobox },
		{ field: 'format', title: '���ָ�ʽ', width: 100, editor: GridEditors.text },
		{ field: 'hidden', title: '�Ƿ�����', width: 80, align:'center',
			editor: GridEditors.checkbox,
			formatter: function(value, rowData, index){
                if (value == "Y"){
					return PHA_COM.Fmt.Grid.Yes.Chinese;
				} else {
					return PHA_COM.Fmt.Grid.No.Chinese;
				}
            }
	    },
		{ field: 'sortable', title: '�Ƿ�����', width: 80, align:'center',
			editor: GridEditors.checkbox,
			formatter: function(value, rowData, index){
                if (value == "Y"){
					return PHA_COM.Fmt.Grid.Yes.Chinese;
				} else {
					return PHA_COM.Fmt.Grid.No.Chinese;
				}
            }
		},
		{ field: 'entersort', title: '�س���ת', width: 80, align:'center',
			editor: GridEditors.checkbox,
			formatter: function(value, rowData, index){
                if (value == "Y"){
					return PHA_COM.Fmt.Grid.Yes.Chinese;
				} else {
					return PHA_COM.Fmt.Grid.No.Chinese;
				}
            }
		},
		{ field: 'seqno', title: '�����', width: 80, editor: GridEditors.number },
		{ field: 'datatype', title: '��������', width: 120, editor: GridEditors.dataTypeCombobox }
    ]];
    var dataGridOption = {
        url: $URL,
        queryParams: {
	        ClassName: 'web.DHCST.StkSysGridSet',
	        MethodName: 'HisuiQuery'
	    },
        columns: columns,
        loadMsg: '���ڼ�����Ϣ...',
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
	
	PHA.Confirm('��ܰ��ʾ', '�Ƿ�ȷ��ɾ����', function(){
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
			PHA.Alert("��ʾ", delRetArr[1], delRetArr[0]);
		} else {
			PHA.Popover({
				msg: 'ɾ���ɹ�!',
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
	// ��ϸ
	$('#gridGridColSet').datagrid('endEditing');
	var rowsData = $('#gridGridColSet').datagrid('getRows');
	if (rowsData == null || rowsData.length == 0) {
		PHA.Popover({msg: 'û����Ҫ���������Ϣ!', type: "alert"});
		return;
	}
	// ��ֵ֤
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
		PHA.Alert("��ʾ", saveRetArr[1], saveRetArr[0]);
	} else {
		PHA.Popover({
			msg: '����ɹ�!',
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
		PHA.Popover({msg: '��ѡ���Ʒģ��!', type: "info"});
		return null;
	}
	var selGridSet = $('#gridGridSet').datagrid('getSelected') || {};
	var GridId = selGridSet.GridId || "";
	if (GridId == "") {
		PHA.Popover({msg: 'Grid����Ϊ��!', type: "info"});
		return null;
	}
	var SaveMod = selGridSet.SaveMod || "";
	if (SaveMod == "") {
		PHA.Popover({msg: '����ģʽ����Ϊ��!', type: "info"});
		return null;
	}
	var SaveValue = selGridSet.SaveValue || "";
	if (SaveValue == "") {
		PHA.Popover({msg: '����ģʽֵ����Ϊ��!', type: "info"});
		return null;
	}
	var CspName = selGridSet.CspName || "";
	if (CspName == "") {
		PHA.Popover({msg: '�˵�����Ϊ��!', type: "info"});
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
	// ����
	number: {
		type: 'validatebox',
        options: {
	        regExp: /^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$/,
			regTxt: 'ֻ��Ϊ����0������!',
	        onEnter: function() {
		        PHA_GridEditor.Next();
		    }
	    }
	},
	// �ı�
	notNullText: {
		type: 'validatebox',
        options: {
	        regExp: /\S/,
			regTxt: '����Ϊ��!',
	        onEnter: function(){
		        PHA_GridEditor.Next();
		    }
	    }
	},
	// �ı�
	text: {
		type: 'validatebox',
        options: {
	        onEnter: function(){
		        PHA_GridEditor.Next();
		    }
	    }
	},
	// ��ѡ
	checkbox: {
		type: 'icheckbox',
	    options: {
		    on: 'Y',
		    off: 'N'
		}
	},
	// ����
	alignCombobox: {
        type: 'combobox',
        options: {
	        regExp: /\S/,
			regTxt: '����Ϊ��!',
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
    // ����
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

//��̬���ø߶�
function ResetPanelHeight(_options){
	if(_options.height < 1){
		var vWidth = document.documentElement.clientWidth;
		var vHeight = document.documentElement.clientHeight;
		_options.height = _options.height * vHeight;
	}
	$('#'+_options.layoutId).layout('panel', _options.region).panel('resize',{height: _options.height});
	$('#'+_options.layoutId).layout('resize');
}