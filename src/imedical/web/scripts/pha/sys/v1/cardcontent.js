/**
 * ����:	 ҩ��ҩ��-ҩѧ��ҳ-��Ƭ�����ֵ�ά��
 * ��д��:	 Huxt
 * ��д����: 2020-04-13
 * csp:  	 pha.sys.v1.cardcontent.csp
 * js:		 pha/sys/v1/cardcontent.js
 */
PHA_COM.App.Csp = "pha.sys.v1.cardcontent.csp"
PHA_COM.App.CspDesc = "��Ƭ����ά��"
PHA_COM.App.ProDesc = "����ҵ��"

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

// ��Ԫ��
function InitFormData() {}

// ��Ƭ��������
function InitGridCardContent() {
    var columns = [[
    	{ field: "picc", title: 'picc', width: 80, hidden:true},
		{ field: "piccCode", title: '���ݴ���', width: 120, editor: GridEditors.notNullText},
		{ field: 'piccDesc', title: '��������', width: 100, editor: GridEditors.notNullText},
		{ field: 'piccFormFlag', title: '�Ƿ��', width: 70, align: 'center', editor: GridEditors.checkBox, formatter: PHA.CheckBoxFormatter},
		{ field: 'piccActiveFlag', title: '�Ƿ����', width: 70, align: 'center', editor: GridEditors.checkBox, formatter: PHA.CheckBoxFormatter}
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

// ��Ƭ������������
function InitGridCardContentItm() {
    var columns = [[
    	{ field: "picc", title: 'picc', width: 80, hidden:true},
    	{ field: "picci", title: 'picci', width: 80, hidden:true},
		{ 
			field: "picciCode",
			title: '���Դ���',
			width: 150,
			editor: GridEditors.notNullText
		}, { 
			field: 'picciDesc',
			title: '��������',
			width: 150,
			editor: GridEditors.notNullText
		}, { 
			field: 'picciComFlag',
			title: '��������',
			width: 70,
			align: 'center',
			editor: GridEditors.checkBox,
			formatter: PHA.CheckBoxFormatter
		},
		{ 
			field: 'picciHUIFlag',
			title: 'HISUI����',
			width: 85,
			align: 'center',
			editor: GridEditors.checkBox,
			formatter: PHA.CheckBoxFormatter
		}, { 
			field: 'picciRequiredFlag',
			title: '�Ƿ����',
			width: 70,
			align: 'center',
			editor: GridEditors.checkBox,
			formatter: PHA.CheckBoxFormatter
		}, {
			field: 'picciActiveFlag',
			title: '�Ƿ���Ч',
			width: 70,
			align: 'center',
			editor: GridEditors.checkBox,
			formatter: PHA.CheckBoxFormatter
		}, { 
			field: 'picciValType',
			title: 'ȡֵ����',
			width: 100,
			editor: GridEditors.ValType,
        	formatter: function(value, rowData, index){
            	return rowData.picciValType
        	}
		}, { 
			field: 'picciValRange',
			title: 'ȡֵ��Χ', width: 150,
			editor: GridEditors.comText,
			showTip: true,
			tipWidth: 180
		}, {
	        field: 'picciFormType',
	        title: '������',
	        width: 120,
	        editor: GridEditors.FormType,
	        formatter: function(value, rowData, index){
	            return rowData.picciFormType;
	        }
	    }, {
	        field: 'picciFormSort',
	        title: '��˳��',
	        width: 80,
	        hidden: true
	    }, {
	        field: 'picciFormVal',
	        title: '��Ĭ��ֵ',
	        width: 120,
	        editor: GridEditors.comText,
	    }, { 
	    	field: 'picciMemo',
	    	title: 'ʹ��˵��',
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


// ��ѯ
function Query() {
	$("#gridCardContent").datagrid("query", {
		iinputStr: ''
	});
}

// ����
function Add() {
	PHA_GridEditor.Add({
		gridID: 'gridCardContent',
		field: 'piccCode',
		rowData: {piccActiveFlag: 'Y'}
	});
	$('#gridCardContentItm').datagrid('clear');
}

// ����
function Save() {
	// ��ȡֵ
    $('#gridCardContent').datagrid('endEditing');
	var changedRows = PHA.GridChangedRows("gridCardContent");
	if (changedRows.length == 0) {
		return;
	}
	// ǰ̨��֤
    var chkRetStr = PHA_GridEditor.CheckValues('gridCardContent');
	if (chkRetStr != "") {
		PHA.Popover({msg: chkRetStr, type: "alert"});
		return;
	}
	var saveRows = RowsAddRowIndex('gridCardContent', changedRows);
	var jsonDataStr =  JSON.stringify(saveRows);
	
	// ����
	var retStr = $.cm({
		ClassName: 'PHA.SYS.CardContent.Save',
		MethodName: 'SaveMulti',
		jsonDataStr: jsonDataStr,
		dataType: 'text'
	}, false);
	PHA.AfterRunServer(retStr, Query);
}

// ɾ��
function Delete() {
	var selectedRow = $("#gridCardContent").datagrid("getSelected");
	if (selectedRow == null) {
		PHA.Popover({
			msg: "��ѡ����Ҫɾ��������!",
			type: "alert"
		});
		return;
	}
	var picc = selectedRow.picc || "";
	PHA.Confirm("ɾ����ʾ", "�Ƿ�ȷ��ɾ����", function () {
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

// ��ѯ����
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

// ��������
function AddItm() {
    var selectedRow = $("#gridCardContent").datagrid("getSelected") || {};
    var picc = selectedRow.picc || "";
    if (picc == "" || picc == 0) {
        PHA.Popover({
            msg: "��ѡ����࿨Ƭ����!",
            type: "alert"
        });
        return;
    }
    PHA_GridEditor.Add({
		gridID: 'gridCardContentItm',
		field: 'picciCode',
		rowData: {
			picc: picc,
			picciComFlag: 'Y', //����Ϊ�������԰�
			picciActiveFlag: 'Y',
			picciValType: 'string',
		}
	});
}

// ��������
function SaveItm() {
	// ��ȡֵ
    $('#gridCardContentItm').datagrid('endEditing');
	var changedRows = PHA.GridChangedRows("gridCardContentItm");
	if (changedRows.length == 0) {
		return;
	}
	// ǰ̨��֤
    var chkRetStr = PHA_GridEditor.CheckValues('gridCardContentItm');
	if (chkRetStr != "") {
		PHA.Popover({msg: chkRetStr, type: "alert"});
		return;
	}
	var saveRows = RowsAddRowIndex('gridCardContentItm', changedRows);
	var jsonDataStr =  JSON.stringify(saveRows);
	
	// ����
	var retStr = $.cm({
		ClassName: 'PHA.SYS.CardContent.Save',
		MethodName: 'SaveItmMulti',
		jsonDataStr: jsonDataStr,
		dataType: 'text'
	}, false);
	PHA.AfterRunServer(retStr, QueryItm);
}

// ɾ������
function DeleteItm() {
	var selectedRow = $("#gridCardContentItm").datagrid("getSelected");
	if (selectedRow == null) {
		PHA.Popover({
			msg: "��ѡ����Ҫɾ������������!",
			type: "alert"
		});
		return;
	}
	var picci = selectedRow.picci || "";
	PHA.Confirm("ɾ����ʾ", "�Ƿ�ȷ��ɾ����", function () {
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
				// ����
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
	// ��ͨ�ı�
	comText: {
		type: 'validatebox',
        options: {
	        onEnter: function() {
		        PHA_GridEditor.Next();
		    }
	    }
	},
	// �ǿ��ı�
	notNullText: {
		type: 'validatebox',
        options: {
	        required: true,
	        regExp: /\S/,
			regTxt: '����Ϊ��',
			checkOnBlur: false,
	        onEnter: function() {
		        PHA_GridEditor.Next();
		    }
	    }
	},
	// ��ѡ
	checkBox: {
		type: 'icheckbox',
	    options: {
		    on: 'Y',
		    off: 'N'
		}
	},
	// ֵ��������
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
	// ������
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

// ��ÿһ����������к�
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
// �������ݻ�ȡ�к�
function GetRowIndex(gridID, rowData){
	var rowIndex = $("#" + gridID).datagrid('getRowIndex', rowData);
	return rowIndex;
}