/**
 * ����:	 ҩ��ҩ�� - Ƥ��ҩƷ����
 * ��д��:   Huxt
 * ��д����: 2020-03-19
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
 * @description: �¼��󶨳�ʼ��
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
 * @description: ��ʼ���ֵ�
 */
function InitDict(){
	
}

/**
 * @description: ��� - ����ԭ
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
				title: '����ԭ����',
				width: 160
			}, {
				field: "rlaAlg",
				descField: 'rlaAlgDesc',
				title: '��Ŀ',
				title: '��������ԭ',
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
				title: '����',
				width: 80
			}, {
				field: 'startDate',
				title: '��ʼ����',
				width: 100
			}, {
				field: 'endDate',
				title: '��ֹ����',
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
 * @description: ��� - Ƥ��ҩƷ
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
				title: '����ԭ',
				width: 100,
				hidden: true
			}, {
				field: "itemCode",
				title: '��Ŀ����',
				width: 120
			}, {
				field: "itemId",
				descField: 'itemDesc',
				title: '��Ŀ',
				width: 320,
				editor: ComboBoxEditor("skinTestItem"),
                formatter: function(value, rowData, index){
	                return rowData.itemDesc
	            }
			}, {
				field: "itemType",
				title: '��Ŀ����',
				align: "center",
				width: 50,
				hidden: true
			}, {
				field: "validTime",
				title: 'Ƥ��ʱЧ(h)',
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
				title: '��������',
				align: "center",
				width: 70,
				editor: CheckBoxEditor(),
				formatter: CheckBoxFormatter
			}, {
				field: "noTestFlag",
				title: '��������',
				align: "center",
				width: 70,
				editor: CheckBoxEditor(),
				formatter: CheckBoxFormatter
			}, {
				field: "exceptionFlag",
				title: '��������',
				align: "center",
				width: 70,
				editor: CheckBoxEditor(),
				formatter: CheckBoxFormatter
			}, {
				field: "startDate",
				title: '��ʼ����',
				align: "center",
				width: 100,
				editor: {
					type: 'datebox'
				}
			}, {
				field: "endDate",
				title: '��������',
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
 * @description: ��� - Ƥ�Թ���ҩƷ
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
				title: '��������',
				width: 100,
				editor: ComboBoxEditor("admType"),
                formatter: function(value, rowData, index){
	                return rowData.admTypeDesc
	            }
			}, {
				field: "locID",
				descField: 'locDesc',
				title: '����',
				width: 180,
				editor: ComboBoxEditor("locID"),
                formatter: function(value, rowData, index){
	                return rowData.locDesc;
	            }
			}, {
				field: "itemType",
				descField: 'itemTypeDesc',
				title: '��Ŀ����',
				width: 100,
				editor: ComboBoxEditor("ItemType"),
                formatter: function(value, rowData, index){
	                return rowData.itemTypeDesc;
	            }
			}, {
				field: "itemId",
				descField: 'itemDesc',
				title: '��Ŀ',
				width: 320,
				editor: ComboBoxEditor("skinTestItmItem"),
                formatter: function(value, rowData, index){
	                return rowData.itemDesc
	            }
			}, {
				field: "resultFlag",
				title: '�����־',
				align: "center",
				width: 80,
				editor: CheckBoxEditor(),
				formatter: CheckBoxFormatter
			}, {
				field: "priID",
				descField: 'priDesc',
				title: '���ȼ�',
				align: "center",
				width: 130,
				editor: ComboBoxEditor("priID"),
                formatter: function(value, rowData, index){
	                return rowData.priDesc;
	            }
			}, {
				field: "doseQty",
				title: '����',
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
				title: '������λ',
				align: "center",
				width: 80,
				editor: ComboBoxEditor("unitID"),
                formatter: function(value, rowData, index){
	                return rowData.unitDesc;
	            }
			}, {
				field: "freqID",
				descField: 'freqDesc',
				title: 'Ƶ��',
				align: "center",
				width: 130,
				editor: ComboBoxEditor("freqID"),
                formatter: function(value, rowData, rowIndex){
	                return rowData.freqDesc;
	            }
			}, {
				field: "instID",
				descField: 'instDesc',
				title: '�÷�',
				align: "center",
				width: 120,
				editor: ComboBoxEditor("instID"),
                formatter: function(value, rowData, index){
	                return rowData.instDesc;
	            }
			}, {
				field: "seqNo",
				title: '����',
				align: "center",
				width: 80,
				editor: {
                    type: 'numberbox',
                    options: {}
				}
			}, {
				field: "autoInsFlag",
				title: '�Զ�����',
				align: "center",
				width: 80,
				editor: CheckBoxEditor(),
				formatter: CheckBoxFormatter
			}, {
				field: "startDate",
				title: '��ʼ����',
				align: "center",
				width: 120,
				editor: {
					type: 'datebox'
				}
			}, {
				field: "endDate",
				title: '��ֹ����',
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
 * @description: ����ԭCRUD����
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
	// ����
	var retStr = $.cm({
		ClassName: 'PHA.IN.SkinTest.Save',
		MethodName: 'SaveAlgMulti',
		jsonDataStr: jsonDataStr,
		dataType: 'text'
	}, false);
	AfterRunServer(retStr, QueryAlg);
}

/**
 * @description: Ƥ��ҩƷCRUD����
 */
function Query() {
	// ��ȡҽԺ
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
	// ��ѡ
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
			msg: "��ѡ�����ԭ!",
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
	// ��ȡҽԺ
	var hospId = $('#_HospList').combogrid('getValue') || "";
	if (hospId == "") {
		PHA.Popover({
			msg: "��ѡ����ҪҽԺ!",
			type: "alert"
		});
		return false;
	}
	// ǰ̨��֤
	if (GridEndEidting("gridSkinTest") == false) {
		return;
	}
	var changeData = GetChangeData("gridSkinTest");
	if (changeData.length == 0) {
		return;
	}
	var jsonDataStr =  JSON.stringify(changeData);
	// ����
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
	// ��ȡҽԺ
	var hospId = $('#_HospList').combogrid('getValue') || "";
	if (hospId == "") {
		PHA.Popover({
			msg: "��ѡ����ҪҽԺ!",
			type: "alert"
		});
		return false;
	}
	// Ҫɾ����ID
	var selectedRow = $("#gridSkinTest").datagrid("getSelected");
	if (selectedRow == null) {
		PHA.Popover({
			msg: "��ѡ����Ҫɾ������Ŀ!",
			type: "alert"
		});
		return;
	}
	var pist = selectedRow.pist || "";
	// ɾ��ȷ��
	PHA.Confirm("ɾ����ʾ", "�Ƿ�ȷ��ɾ������Ŀ?", function () {
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
 * @description: ����Ƥ����ҩCRUD����
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
			msg: "δѡ����Ŀ��ѡ�����Ŀû�б���!",
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
			msg: "δѡ����Ŀ��ѡ�����Ŀû�б���!",
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
	// ǰ̨��֤
	if (GridEndEidting("gridSkinTestItm") == false) {
		return;
	}
	var changeData = GetChangeData("gridSkinTestItm");
	if (changeData.length == 0) {
		return;
	}
	// ȡ�������(���ں�̨��֤�������)
	var rowsData = $("#gridSkinTestItm").datagrid('getRows');
	var maxRows = rowsData.length;
	for (var i = 0; i < changeData.length; i++) {
		changeData[i].maxRows = maxRows;
	}
	var jsonDataStr =  JSON.stringify(changeData);
	// ����
	var retStr = $.cm({
		ClassName: 'PHA.IN.SkinTest.Save',
		MethodName: 'SaveItmMulti',
		jsonDataStr: jsonDataStr,
		dataType: 'text'
	}, false);
	AfterRunServer(retStr, QueryItm);
}

function DeleteItm() {
	// Ҫɾ����ID
	var selectedRow = $("#gridSkinTestItm").datagrid("getSelected");
	if (selectedRow == null) {
		PHA.Popover({
			msg: "��ѡ����Ҫɾ������Ŀ!",
			type: "alert"
		});
		return;
	}
	var pisti = selectedRow.pisti || "";
	// ɾ��ȷ��
	PHA.Confirm("ɾ����ʾ", "�Ƿ�ȷ��ɾ������Ŀ?", function () {
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
 * @description: ����Ϊ�������̷���
 */
function AddNewRowCom(_options){
	var _gridID = _options.gridID;
	var _defaultData = _options.defaultData;
	var _editField = _options.editField;
	var isEndEidting = $("#" + _gridID).datagrid("endEditing");
	if (!isEndEidting) {
		PHA.Popover({
			msg: "������ɱ����һ�б༭!",
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
			msg: "��ѡ�񱣴�����!",
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
			msg: "δ���������,�޷���ɱ༭!",
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
			msg: "û����Ҫ���������!",
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
		PHA.Alert("��ʾ", retInfo, retVal);
		if (errCallFn) {
			errCallFn();
		}
	} else {
		PHA.Popover({
			msg: retInfo || "�ɹ�!",
			type: "success",
			timeout: 500
		});
		if (succCallFn) {
			succCallFn();
		}
	}
}

function OnSelectSkinTest(rowData){
	var curSelectedItem = "��ǰѡ����Ŀ: ";
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
	                // �Զ������Ƿ�ѡ
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
					// �����Ŀ����
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
* @description: ��Ժ������ - ���س�ʼ��ҽԺ
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
* @description: ����������Ϣ
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
	    	title: '����',
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
	skinTestHelpHtml += GetTitle("1����Ŀ���ƣ�");
	skinTestHelpHtml += GetContent("����ԭ�°�����ЩҩƷ�����԰�ҽ����壬Ҳ���԰�ͨ�������壬����ֻ�ܰ�һ�ֶ��壬����ͬʱ���塣");
	skinTestHelpHtml += GetTitle("2��ʱЧ��");
	skinTestHelpHtml += GetContent("��ҩƷ�ж϶೤ʱ���ڵ�Ƥ�Խ������ҩ��¼��");
	skinTestHelpHtml += GetTitle("3������������");
	skinTestHelpHtml += GetContent("��ҩƷ�Ƿ�����������ơ�");
	skinTestHelpHtml += GetTitle("4���������ԣ�");
	skinTestHelpHtml += GetContent("��ҩƷ�Ƿ�������ԡ�");
	skinTestHelpHtml += GetTitle("5���������⣺");
	skinTestHelpHtml += GetContent("��ѡ������ҩƷ����Ƥ�Խ���Կ��Խɷ�/��ҩ�����������˷���ҩƷ��ȡһֻ����Ƥ�ԣ�ʣ�µļ������ơ�");
	return skinTestHelpHtml;
}

function GetSkinTestItmHelpHtml(){
	var skinTestHelpHtml = "";
	skinTestHelpHtml += GetTitle("1���������ͣ�");
	skinTestHelpHtml += GetContent("�����򣬿���ѡ�񡰿�/����/����/סԺ��,Ϊ��ʱ����˹���������ȫԺ��ѡ������/����/סԺ�������������õľ������ͣ�������/����/סԺ���͡��ա��Ĺ������ͬʱ���ڣ���ǰ�����ȼ����ߡ�");
	skinTestHelpHtml += GetTitle("2�����ң�");
	skinTestHelpHtml += GetContent("����ѡ��գ���ȫԺ�������߾��忪�����ң����ά���˿��ҵ�����ȡ���Ҷ����Ƥ����ҩ������ȡ�յļ�¼��");
	skinTestHelpHtml += GetTitle("3�����ͣ�");
	skinTestHelpHtml += GetContent("����ҽ����/ͨ������");
	skinTestHelpHtml += GetTitle("4����Ŀ���ƣ�");
	skinTestHelpHtml += GetContent("�ֵ��ͣ�ҽ����Ŀ��ͨ�����������Զ������Ϸ�ͨ������ҽ����ʵ�ֽ�����ϵ�ͨ������ҽ���Ҳ���Զ��忪������ҩʱ�Զ������Ƥ����ҩ��");
	skinTestHelpHtml += GetTitle("5�������־��");
	skinTestHelpHtml += GetContent("��ѡ�򣬹�ѡ��ҩƷ���Զ�����ʱ�����ϡ�Ƥ�Ա�־����OE_OrdItem - OEORI_AdministerSkinTest��,�ǻ�ʿ������Ƥ�Խ����ҽ�������Խ����ý���磺�Ȼ���ע��Һ10ml������Ҫ��Ƥ�Խ����һ��������ҩÿ�־������͹�����Ƥ����ҩ�ġ������־������Ϊ�գ�������һ��ҩƷά������ѡ�˽����־�Ĳ��ܺ��Ϸ���ͨ����/ҽ����ʵ��Ƥ�Խ����ͬ����");
	skinTestHelpHtml += GetTitle("6��ҽ�����ȼ���");
	skinTestHelpHtml += GetContent("�����򣬿���ѡ����ʱҽ��/��ʱ���С����Զ�����Ƥ��ҩƷ��ҽ�����ȼ���Ƥ����ҩ��Ҫ�����շ���ҩ����Ϊ����ʱҽ�������������Ҫ������Ϊ����ʱ���С���");
	skinTestHelpHtml += GetTitle("7��������");
	skinTestHelpHtml += GetContent("��ֵ���ı����Զ�������Ƥ����ҩ�ļ�����");
	skinTestHelpHtml += GetTitle("8����λ��");
	skinTestHelpHtml += GetContent("������ȡ����ҩƷ�ĵ�Ч��λ��");
	skinTestHelpHtml += GetTitle("9��Ƶ�Σ�");
	skinTestHelpHtml += GetContent("�����򣬿���ѡ��ONCE/ST�����Զ�������Ƥ����ҩ��Ƶ�Ρ�");
	skinTestHelpHtml += GetTitle("10��������ţ�");
	skinTestHelpHtml += GetContent("��������ͬ�֡��������͡������ã�Ƥ��ҩƷ������Ҫ����ϡ�����ã����Խ���Զ������ĳ���Ƥ����ҩ�Ĺ�����ϵ��");
	skinTestHelpHtml += GetTitle("11���Զ����룺");
	skinTestHelpHtml += GetContent("ֻ��ҽ�����������Ϊ�Զ����롣����Ϊ�Զ�����ı���ά�����ȼ���������Ƶ�Ρ��÷�����λ�ȡ�");
	return skinTestHelpHtml;
}

function GetTitle(str, falg){
	return "<b>" + str + "</b><br/>";
}

function GetContent(str){
	return "&nbsp;&nbsp;&nbsp;&nbsp;" + str + "<br/>";
}
