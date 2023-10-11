/**
 * @Author      yaojining
 * @DateTime    2020-02-25
 * @description 护理病历外部数据源配置
 */
FileReader.prototype.readAsBinaryString = function (fileData) {
	var binary = "";
	var pt = this;
	var reader = new FileReader();
	reader.onload = function (e) {
		var bytes = new Uint8Array(reader.result);
		var length = bytes.byteLength;
		for (var i = 0; i < length; i++) {
			binary += String.fromCharCode(bytes[i]);
		}
		pt.content = binary;
		pt.onload(pt); //页面内data取pt.content文件内容
	}
	reader.readAsArrayBuffer(fileData);
}
var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	ConfigTableName: 'Nur_IP_DHCNurEmrInfoMethod'
};

$(initUI);

/**
 * @description 初始化界面
 */
function initUI() {
	initHosp(function(){
		findDataSource();
		initParamGrid();
		initFieldGrid();
	});
	initCondition();
	passwd_init();
	
	initEvents();
}

/**
 * @description 初始化条件
 */
function initCondition() {
	$HUI.combobox('#workway', {
		valueField: 'workwayDR',
		textField: 'workway',
		url: $URL + '?ClassName=Nur.DHCNurEmrInfoMethod&QueryName=FindConfigworkway&ResultSetType=array',
	});
	$HUI.combobox('#type', {
		valueField: 'TypeDR',
		textField: 'Type',
		url: $URL + '?ClassName=Nur.DHCNurEmrInfoMethod&QueryName=FindConfigType&ResultSetType=array',
	});
	$HUI.combobox('#paramType', {
		valueField: 'id',
		textField: 'text',
		value: 1,
		data: [{ id: 1, text: 'String' }]
	});
	$HUI.combobox('#fieldType', {
		valueField: 'id',
		textField: 'text',
		value: 1,
		data: [{ id: 1, text: 'String' }]
	});
	$HUI.radio('#createPic', {
		onCheckChange: function (e, value) {
			if (value) {
				$('#picEmrCode').next(".combo").show();
			} else {
				$('#picEmrCode').next(".combo").hide();
			}
			$('#picEmrCode').combobox('setValue', '');
		}
	});
	$HUI.combobox("#picEmrCode", {
		valueField: 'EmrCode',
		textField: 'Name',
		url: $URL + "?ClassName=NurMp.Service.Image.History&MethodName=getAllPrintModel&HospitalID=" + GLOBAL.HospitalID,
		defaultFilter: 4
	});
	var ifCreatePic = $('#createPic').radio('getValue');
	if (!ifCreatePic) {
		$('#picEmrCode').next(".combo").hide();
	}
}
/**
 * @description 查询数据
 */
function findDataSource() {
	$('#dataSourceGrid').datagrid({
		url: $URL,
		queryParams: {
			ClassName: 'Nur.DHCNurEmrInfoMethod',
			QueryName: 'getDataSource',
			Parr: $('#name').val() + '^' + $('#desc').val() + '^' + $('#workway').combobox('getText') + '^' + $('#className').val() + '^' + $('#methodName').val() + '^' + $('#type').combobox('getText') + '^' + GLOBAL.HospitalID
		},
		toolbar: '#DIV_toolbar',
		rownumbers: true,
		singleSelect: true,
		pagination: true,
		pageSize: 10,
		pageList: [10, 30, 50, 100],
		onClickRow: dataSourceGridClickRow,
		onLoadSuccess: function(data) {
			$('#dataSourceGrid').datagrid('unselectAll');
		}
	});
}
/**
 * @description 初始化参数表格
 */
function initParamGrid() {
	$('#paramGrid').datagrid({
		url: $URL,
		queryParams: {
			ClassName: 'Nur.DHCNurEmrInfoPar',
			QueryName: 'getParameters',
			ItemDR: ''
		},
		toolbar: [{
			iconCls: 'icon-add',
			text: '增加',
			handler: addParamItem
		}, {
			iconCls: 'icon-edit',
			text: '修改',
			handler: editParamItem
		}, {
			iconCls: 'icon-remove',
			text: '删除',
			handler: deleteParamItem
		}
		],
		rownumbers: true,
		singleSelect: true,
		pagination: true,
		pageSize: 3,
		pageList: [3, 10, 20, 30],
		onClickRow: paramGridClickRow
	});
}
/**
 * @description 初始化字段表格
 */
function initFieldGrid() {
	$('#fieldGrid').datagrid({
		url: $URL,
		queryParams: {
			ClassName: 'Nur.DHCNurEmrInfoReturn',
			QueryName: 'getFields',
			ItemDR: ''
		},
		toolbar: [{
			iconCls: 'icon-add',
			text: '增加',
			handler: function () {
				addFieldItem();
			}
		}, {
			iconCls: 'icon-edit',
			text: '修改',
			handler: function () {
				editFieldItem();
			}
		}, {
			iconCls: 'icon-remove',
			text: '删除',
			handler: function () {
				deleteFieldItem();
			}
		}
		],
		rownumbers: true,
		singleSelect: true,
		pagination: true,
		pageSize: 5,
		pageList: [5, 10, 20, 30],
		onClickRow: fieldGridClickRow
	});
}
/**
 * @description 数据源表格点击事件
 */
function dataSourceGridClickRow(rowIndex, rowData) {
	clearInput();
	setCommonInfo(rowData);
	var dataSourceRow = $('#dataSourceGrid').datagrid('getSelected');
	$('#paramGrid').datagrid('reload', {
		ClassName: 'Nur.DHCNurEmrInfoPar',
		QueryName: 'getParameters',
		ItemDR: dataSourceRow.id
	});
	$('#fieldGrid').datagrid('reload', {
		ClassName: 'Nur.DHCNurEmrInfoReturn',
		QueryName: 'getFields',
		ItemDR: dataSourceRow.id
	});
}
/**
 * @description 参数表格点击事件
 */
function paramGridClickRow(rowIndex, rowData) {
	setCommonInfo(rowData);
}
/**
 * @description 字段表格点击事件
 */
function fieldGridClickRow(rowIndex, rowData) {
	setCommonInfo(rowData);
}
/**
 * @description 加载表格的行信息
 */
function setCommonInfo(rowData) {
	for (var item in rowData) {
		var domID = "#" + item;
		var domType = $(domID).attr('class');
		if (!!domType) {
			if (domType.indexOf('combobox') > -1) {
				if (domID == "#picEmrCode") {
					if (rowData['createPic'] == 'true') {
						$(domID).next(".combo").show();
						$(domID).combobox('select', rowData[item]);
					} else {
						$(domID).next(".combo").hide();
					}
				} else {
					$(domID).combobox('setValue', rowData[item]);
				}
			} else if (domType.indexOf('radio') > -1) {
				$(domID).radio('setValue', rowData[item] == 'true');
			} else {
				$(domID).val(rowData[item]);
			}
		}
	}
}
/**
 * @description 增加数据源条目
 */
function addDataItem() {
	var dataName = $('#name').val();
	if (!dataName) {
		$.messager.popover({ msg: '请输入名称!', type: 'error' });
		return;
	}
	var dataDesc = $('#desc').val();
	if (!dataDesc) {
		$.messager.popover({ msg: '请输入描述!', type: 'error' });
		return;
	}
	// var dataWorkway = $('#workway').combobox('getValue');
	var dataWorkway = $('#workway').combobox('getText');  //兼容旧版类方法
	if (!dataWorkway) {
		$.messager.popover({ msg: '请选择传输方式!', type: 'error' });
		return;
	}
	var className = $('#className').val();
	if (!className) {
		$.messager.popover({ msg: '请输入类名!', type: 'error' });
		return;
	}
	var methodName = $('#methodName').val();
	if (!methodName) {
		$.messager.popover({ msg: '请输入方法名!', type: 'error' });
		return;
	}
	// var dataType = $('#type').combobox('getValue');
	var dataType = $('#type').combobox('getText');
	if (!dataType) {
		$.messager.popover({ msg: '请选择类型!', type: 'error' });
		return;
	}

	var picEmrCode = '';
	var createPic = $('#createPic').radio('getValue');
	if (createPic) {
		picEmrCode = $('#picEmrCode').combobox('getValue');
		if (!picEmrCode) {
			$.messager.popover({ msg: '请选择生成图片所对应的打印模板!', type: 'error' });
			return;
		}
	} else {
		$('#picEmrCode').combobox('setValue', '');
	}

	var parr = dataName + "^" + dataDesc + "^" + className + "^" + methodName + "^" + dataType + "^" + dataWorkway + "^" + GLOBAL.HospitalID + "^" + createPic + "^" + picEmrCode;
	$m({
		ClassName: "Nur.DHCNurEmrInfoMethod",
		MethodName: "save",
		parr: parr
	}, function (result) {
		if (result == 0) {
			$.messager.popover({ msg: '添加成功！', type: 'success' });
			$('#dataSourceGrid').datagrid('reload');
		} else {
			$.messager.popover({ msg: result, type: 'error' });
		}
	});
}
/**
 * @description 修改数据源条目
 */
function editDataItem() {
	var dataSourceRow = $('#dataSourceGrid').datagrid('getSelected');
	if (!dataSourceRow) {
		$.messager.popover({ msg: '请选择一条数据源!', type: 'info' });
		return;
	}
	var dataName = $('#name').val();
	if (!dataName) {
		$.messager.popover({ msg: '请输入名称!', type: 'error' });
		return;
	}
	var dataDesc = $('#desc').val();
	if (!dataDesc) {
		$.messager.popover({ msg: '请输入描述!', type: 'error' });
		return;
	}
	// var dataWorkway = $('#workway').combobox('getValue');
	var dataWorkway = $('#workway').combobox('getText');  //兼容旧版类方法
	if (!dataWorkway) {
		$.messager.popover({ msg: '请选择传输方式!', type: 'error' });
		return;
	}
	var className = $('#className').val();
	if (!className) {
		$.messager.popover({ msg: '请输入类名!', type: 'error' });
		return;
	}
	var methodName = $('#methodName').val();
	if (!methodName) {
		$.messager.popover({ msg: '请输入方法名!', type: 'error' });
		return;
	}
	// var dataType = $('#type').combobox('getValue');
	var dataType = $('#type').combobox('getText');
	if (!dataType) {
		$.messager.popover({ msg: '请选择类型!', type: 'error' });
		return;
	}
	var picEmrCode = '';
	var createPic = $('#createPic').radio('getValue');
	if (createPic) {
		picEmrCode = $('#picEmrCode').combobox('getValue');
		if (!picEmrCode) {
			$.messager.popover({ msg: '请选择生成图片所对应的打印模板!', type: 'error' });
			return;
		}
	} else {
		$('#picEmrCode').combobox('setValue', '');
	}
	var parr = dataSourceRow.id + "^" + dataName + "^" + dataDesc + "^" + className + "^" + methodName + "^" + dataType + "^" + dataWorkway + "^" + GLOBAL.HospitalID + "^" + createPic + "^" + picEmrCode;
	$m({
		ClassName: "Nur.DHCNurEmrInfoMethod",
		MethodName: "update",
		parr: parr
	}, function (result) {
		if (result == 0) {
			$.messager.popover({ msg: '修改成功！', type: 'success' });
			$('#dataSourceGrid').datagrid('reload');
		} else {
			$.messager.popover({ msg: result, type: 'error' });
		}
	});
}
/**
 * @description 删除数据源条目
 */
function deleteDataItem() {
	var dataSourceRows = $('#dataSourceGrid').datagrid('getSelections');
	if (dataSourceRows == 0) {
		$.messager.popover({ msg: '请选择一条数据源!', type: 'info' });
		return;
	}
	$.messager.confirm("警告", "确定要删除选择的数据源？", function (r) {
		if (r) {
			var pars = "";
			$.each(dataSourceRows, function (index, row) {
				pars = !!pars ? pars + '^' + row.id : row.id;
			});
			$m({
				ClassName: "Nur.DHCNurEmrInfoMethod",
				MethodName: "deleteItems",
				Pars: pars
			}, function (result) {
				if (result == 0) {
					$.messager.popover({ msg: '删除成功！', type: 'success' });
					clearInput();
					$('#dataSourceGrid').datagrid('reload');
					$('#paramGrid').datagrid('reload', {
						ClassName: 'Nur.DHCNurEmrInfoPar',
						QueryName: 'getParameters',
						ItemDR: ''
					});
					$('#fieldGrid').datagrid('reload', {
						ClassName: 'Nur.DHCNurEmrInfoReturn',
						QueryName: 'getFields',
						ItemDR: ''
					});
				} else {
					$.messager.popover({ msg: result, type: 'error' });
				}
			});
		} else {
			return;
		}
	});
}
/**
 * @description 查询数据源条目
 */
function searchDataItem() {
	$('#dataSourceGrid').datagrid('reload', {
		ClassName: 'Nur.DHCNurEmrInfoMethod',
		QueryName: 'getDataSource',
		Parr: $('#name').val() + '^' + $('#desc').val() + '^' + $('#workway').combobox('getText') + '^' + $('#className').val() + '^' + $('#methodName').val() + '^' + $('#type').combobox('getText') + '^' + GLOBAL.HospitalID
	});
}
/**
 * @description 清屏
 */
function clearInput() {
	$('#name').val('');
	$('#desc').val('');
	$('#className').val('');
	$('#methodName').val('');
	$('#workway').combobox('clear');
	$('#type').combobox('clear');
	$('#createPic').radio('setValue', false);
	$('#picEmrCode').combobox('setValue', '');
	$('#paramName').val('');
	$('#paramDesc').val('');
	$('#paramValue').val('');
	$('#paramType').combobox('clear');
	$('#fieldName').val('');
	$('#fieldDesc').val('');
	$('#fieldValue').val('');
	$('#fieldType').combobox('clear');
}
/**
 * @description 增加参数条目
 */
function addParamItem() {
	var dataSourceRow = $('#dataSourceGrid').datagrid('getSelected');
	if (!dataSourceRow) {
		$.messager.popover({ msg: '请选择一条数据源!', type: 'info' });
		return;
	}
	var paramName = $('#paramName').val();
	if (!paramName) {
		$.messager.popover({ msg: '请输入参数名称!', type: 'error' });
		return;
	}
	var paramDesc = $('#paramDesc').val();
	if (!paramDesc) {
		$.messager.popover({ msg: '请输入参数描述!', type: 'error' });
		return;
	}
	var paramValue = $('#paramValue').val();
	if (!paramValue) {
		$.messager.popover({ msg: '请输入参数!', type: 'error' });
		return;
	}
	var paramType = $('#paramType').combobox('getText');
	if (!paramType) {
		$.messager.popover({ msg: '请选择参数类型!', type: 'error' });
		return;
	}
	var parr = dataSourceRow.id + "^" + paramName + "^" + paramDesc + "^" + paramValue + "^" + paramType;
	$m({
		ClassName: "Nur.DHCNurEmrInfoPar",
		MethodName: "save",
		parr: parr
	}, function (result) {
		if (result == 1) {
			$.messager.popover({ msg: '参数已经存在，请勿重复添加！', type: 'error' });
		}
		if (result == 0) {
			$.messager.popover({ msg: '参数添加成功！', type: 'success' });
			$('#paramGrid').datagrid('reload');
		}
	});
}
/**
 * @description 修改参数条目
 */
function editParamItem() {
	var dataSourceRow = $('#dataSourceGrid').datagrid('getSelected');
	if (!dataSourceRow) {
		$.messager.popover({ msg: '请选择一条数据源!', type: 'info' });
		return;
	}
	var paramRow = $('#paramGrid').datagrid('getSelected');
	if (!paramRow) {
		$.messager.popover({ msg: '请选择一条参数!', type: 'info' });
		return;
	}
	var paramID = paramRow.paramId;
	var paramName = $('#paramName').val();
	if (!paramName) {
		$.messager.popover({ msg: '请输入参数名称!', type: 'error' });
		return;
	}
	var paramDesc = $('#paramDesc').val();
	if (!paramDesc) {
		$.messager.popover({ msg: '请输入参数描述!', type: 'error' });
		return;
	}
	var paramValue = $('#paramValue').val();
	if (!paramValue) {
		$.messager.popover({ msg: '请输入参数!', type: 'error' });
		return;
	}
	var paramType = $('#paramType').combobox('getText');
	if (!paramType) {
		$.messager.popover({ msg: '请选择参数类型!', type: 'error' });
		return;
	}
	var parr = paramID + "^" + paramName + "^" + paramDesc + "^" + paramValue + "^" + paramType;
	$m({
		ClassName: "Nur.DHCNurEmrInfoPar",
		MethodName: "update",
		parr: parr
	}, function (result) {
		if (result == 1) {
			$.messager.popover({ msg: '该参数已被引用，无法修改！', type: 'error' });
		}
		if (result == 0) {
			$.messager.popover({ msg: '参数修改成功！', type: 'success' });
			$('#paramGrid').datagrid('reload');
		}
	});
}
/**
 * @description 删除参数条目
 */
function deleteParamItem() {
	var dataSourceRow = $('#dataSourceGrid').datagrid('getSelected');
	if (!dataSourceRow) {
		$.messager.popover({ msg: '请选择一条数据源!', type: 'info' });
		return;
	}
	var paramRow = $('#paramGrid').datagrid('getSelected');
	if (!paramRow) {
		$.messager.popover({ msg: '请选择一条参数!', type: 'info' });
		return;
	}
	$.messager.confirm("提示", "确定要删除吗？", function (r) {
		if (r) {
			$m({
				ClassName: "Nur.DHCNurEmrInfoPar",
				MethodName: "delete",
				rw: paramRow.paramId
			}, function (result) {
				if (result == 1) {
					$.messager.popover({ msg: '该参数已被引用，无法删除！', type: 'error' });
				}
				if (result == 0) {
					$.messager.popover({ msg: '参数删除成功！', type: 'success' });
					$('#paramGrid').datagrid('reload');
				}
			});
		} else {
			return;
		}
	});
}

/**
 * @description 增加字段条目
 */
function addFieldItem() {
	var dataSourceRow = $('#dataSourceGrid').datagrid('getSelected');
	if (!dataSourceRow) {
		$.messager.popover({ msg: '请选择一条数据源!', type: 'info' });
		return;
	}
	var fieldName = $('#fieldName').val();
	if (!fieldName) {
		$.messager.popover({ msg: '请输入字段名称!', type: 'error' });
		return;
	}
	var fieldDesc = $('#fieldDesc').val();
	if (!fieldDesc) {
		$.messager.popover({ msg: '请输入字段描述!', type: 'error' });
		return;
	}
	var fieldValue = $('#fieldValue').val();
	if (!fieldValue) {
		$.messager.popover({ msg: '请输入字段!', type: 'error' });
		return;
	}
	var fieldType = $('#fieldType').combobox('getText');
	if (!fieldType) {
		$.messager.popover({ msg: '请选择字段类型!', type: 'error' });
		return;
	}
	var parr = dataSourceRow.id + "^" + fieldName + "^" + fieldDesc + "^" + fieldValue + "^" + fieldType;
	$m({
		ClassName: "Nur.DHCNurEmrInfoReturn",
		MethodName: "save",
		parr: parr
	}, function (result) {
		if (result == 1) {
			$.messager.popover({ msg: '字段已经存在，请勿重复添加！', type: 'error' });
		}
		if (result == 0) {
			$.messager.popover({ msg: '字段添加成功！', type: 'success' });
			$('#fieldGrid').datagrid('reload');
		}
	});
}
/**
 * @description 修改字段条目
 */
function editFieldItem() {
	var dataSourceRow = $('#dataSourceGrid').datagrid('getSelected');
	if (!dataSourceRow) {
		$.messager.popover({ msg: '请选择一条数据源!', type: 'info' });
		return;
	}
	var fieldRow = $('#fieldGrid').datagrid('getSelected');
	if (!fieldRow) {
		$.messager.popover({ msg: '请选择一条字段!', type: 'info' });
		return;
	}
	var fieldID = fieldRow.fieldId;
	var fieldName = $('#fieldName').val();
	if (!fieldName) {
		$.messager.popover({ msg: '请输入字段名称!', type: 'error' });
		return;
	}
	var fieldDesc = $('#fieldDesc').val();
	if (!fieldDesc) {
		$.messager.popover({ msg: '请输入字段描述!', type: 'error' });
		return;
	}
	var fieldValue = $('#fieldValue').val();
	if (!fieldValue) {
		$.messager.popover({ msg: '请输入字段!', type: 'error' });
		return;
	}
	var fieldType = $('#fieldType').combobox('getText');
	if (!fieldType) {
		$.messager.popover({ msg: '请选择字段类型!', type: 'error' });
		return;
	}
	var parr = fieldID + "^" + fieldName + "^" + fieldDesc + "^" + fieldValue + "^" + fieldType;
	$m({
		ClassName: "Nur.DHCNurEmrInfoReturn",
		MethodName: "update",
		parr: parr
	}, function (result) {
		if (result == 1) {
			$.messager.popover({ msg: '该字段已被引用，无法修改！', type: 'error' });
		}
		if (result == 0) {
			$.messager.popover({ msg: '字段修改成功！', type: 'success' });
			$('#fieldGrid').datagrid('reload');
		}
	});
}
/**
 * @description 删除字段条目
 */
function deleteFieldItem() {
	var dataSourceRow = $('#dataSourceGrid').datagrid('getSelected');
	if (!dataSourceRow) {
		$.messager.popover({ msg: '请选择一条数据源!', type: 'info' });
		return;
	}
	var fieldRow = $('#fieldGrid').datagrid('getSelected');
	if (!fieldRow) {
		$.messager.popover({ msg: '请选择一条字段!', type: 'info' });
		return;
	}
	$.messager.confirm("提示", "确定要删除吗？", function (r) {
		if (r) {
			$m({
				ClassName: "Nur.DHCNurEmrInfoReturn",
				MethodName: "delete",
				rw: fieldRow.fieldId
			}, function (result) {
				if (result == 1) {
					$.messager.popover({ msg: '该字段已被引用，无法删除！', type: 'error' });
				}
				if (result == 0) {
					$.messager.popover({ msg: '字段删除成功！', type: 'success' });
					$('#fieldGrid').datagrid('reload');
				}
			});
		} else {
			return;
		}
	});
}

function initEvents() {
	$('#parseField').bind('click', parseField);
	$('#ifMultiple').bind('change', changeGridCheck);
	$('#addDataItem').bind('click', addDataItem);
	$('#editDataItem').bind('click', editDataItem);
	$('#deleteDataItem').bind('click', deleteDataItem);
	$('#searchDataItem').bind('click', searchDataItem);
	$('#exportDataAll').bind('click', exportDataAll);
	$('#exportDataSub').bind('click', exportDataSub);
	$('#exportAllByCsv').bind('click', exportAllByCsv);
	$('#exportPartByCsv').bind('click', exportPartByCsv);
	$('#importData').bind('click', importData);
	$('#clearInput').bind('click', clearInput);
	$('#updateDataSource').bind('click', updateSource);
}
function changeGridCheck(e, val) {
	var ifMultiple = $('#ifMultiple').checkbox("getValue")
	if (ifMultiple) {
		$("#dataSourceGrid").datagrid({ singleSelect: false, })
	} else {
		$("#dataSourceGrid").datagrid({ singleSelect: true, })
	}
}
/**
 * @description 部分导出
 */
function exportDataSub() {
	var ids = '';
	var records = $('#dataSourceGrid').datagrid('getSelections');
	if (records.length == 0) {
		$.messager.popover({ msg: '请选择记录!', type: 'error' });
		return;
	}
	$.each(records, function (index, record) {
		var id = record.id;
		ids = !!ids ? ids + '^' + id : id;
	});

	$cm({
		ResultSetType: "ExcelPlugin",
		localDir: "Self",
		ExcelName: "部分外部数据源",
		PageName: "nurseExtenalConfig",
		ClassName: "Nur.DHCNurEmrInfoMethod",
		QueryName: "exportDataSource",
		hospitalID: GLOBAL.HospitalID,
		parr: ids
	}, function (result) {
		console.log('部分导出成功!')
	});
}
/**
 * @description 全部导出
 */
function exportDataAll() {
	$.messager.progress({
		title: '提示',
		msg: '正在导出...',
		text: '导出中....'
	});
	$cm({
		ResultSetType: "ExcelPlugin",
		localDir: "Self",
		ExcelName: "全部外部数据源",
		PageName: "nurseExtenalConfig",
		ClassName: "Nur.DHCNurEmrInfoMethod",
		QueryName: "exportDataSource",
		hospitalID: GLOBAL.HospitalID,
		parr: ''
	}, function (result) {
		$.messager.progress('close');
	});
	
}

/**
* @description: 部分导出 CSV
*/
function exportPartByCsv() {
	var ids = '';
	var records = $('#dataSourceGrid').datagrid('getSelections');
	if (records.length == 0) {
		$.messager.popover({ msg: '请选择记录!', type: 'error' });
		return;
	}
	$.each(records, function (index, record) {
		var id = record.id;
		ids = !!ids ? ids + '^' + id : id;
	});
	var rtn = $cm({
		dataType: 'text',
		ResultSetType: "Excel",
		ExcelName: "部分外部数据源",
		ClassName: "Nur.DHCNurEmrInfoMethod",
		QueryName: "exportDataSource",
		hospitalID: GLOBAL.HospitalID,
		parr: ids
	}, false);
	location.href = rtn;
}

/**
* @description: 全部导出 CSV
*/
function exportAllByCsv() {
	var rtn = $cm({
		dataType: 'text',
		ResultSetType: "Excel",
		ExcelName: "全部外部数据源",
		ClassName: "Nur.DHCNurEmrInfoMethod",
		QueryName: "exportDataSource",
		hospitalID: GLOBAL.HospitalID,
		parr: ''
	}, false);
	location.href = rtn;
}

/**
 * @description 导入
 */
function importData() {
	$('#importDialog').dialog({
		title: '导入文件',
		width: 400,
		height: 200,
		closed: false,
		modal: true,
		buttons: [{
			text: '导入',
			handler: importHandler,
		}, {
			text: '取消',
			handler: function () {
				$('#importDialog').dialog("close");
			}
		}]

	});
}
/**
 * @description 导入 --兼容Chrome
 */
function importHandler() {
	var file = $('#file').filebox('files')[0];
	var type = file.name.split('.');
	if (type[type.length - 1] !== 'xlsx' && type[type.length - 1] !== 'xls' && type[type.length - 1] !== 'csv') {
		$.messager.popover({ msg: '请选择.xls、.xlsx、csv格式的文件！', type: 'error' });
		return;
	}
	$('#importDialog').dialog("close");
	$.messager.progress({
		title: "提示",
		msg: '正在导入数据',
		text: '导入中....'
	});
	var rows = new Array();
	var reader = new FileReader();
	reader.readAsBinaryString(file);
	reader.onload = function (e) {
		//var data = e.target.result;
		var data = e.content;
		var workbook = window.XLS.read(data, { type: 'binary', codepage: 936 });
		$.each(workbook.Sheets, function (index, sheet) {
			$.each(sheet, function (key, obj) {
				var word = key[0];  //A
				var num = parseInt(key.substr(1));  //1
				if (num > 1) {
					var row = num - 2;
					var typeVal = word + '|' + obj.v;
					rows[row] = !rows[row] ? typeVal : rows[row] + ',' + typeVal;
				}
			});
			var datasourceCode = "";
			var result1 = '';
			for (var i = 0; i < rows.length; i++) {
				var objRec = new Object();
				var record = rows[i];
				var recordArr = record.split(',');
				for (var j = 0; j < recordArr.length; j++) {
					var item = recordArr[j];
					var typ = item.split('|')[0];
					var val = item.split('|')[1];
					objRec[typ] = val;
				}
				if (!!objRec['A']) {
					datasourceCode = objRec['A'];
				}
				if (objRec.hasOwnProperty('A')) {
					result1 = importDataSource(datasourceCode, objRec['A'], objRec['B'], objRec['C'], objRec['D'], objRec['E'], objRec['F'], objRec['G'], objRec['H'], objRec['I']);
				}
				if (objRec.hasOwnProperty('J') && !!result1) {
					var result2 = importParams(objRec['J'], objRec['K'], objRec['L'], objRec['M'], objRec['N'], result1);
				}
				if (objRec.hasOwnProperty('O') && !!result1) {
					var result3 = importField(objRec['O'], objRec['P'], objRec['Q'], objRec['R'], objRec['S'], result1);
				}
			}
		});
		$.messager.progress('close');
		$('#dataSourceGrid').datagrid('reload');
		$.messager.popover({ msg: '导入完成!', type: 'success' });
	};
}
function importDataSource(datasourceCode, name, desc, workway, className, methodName, type, createPic, picEmrCode, linkCode) {
	var parr = name + "^" + desc + "^" + workway + "^" + className + "^" + methodName + "^" + type + "^" + createPic + "^" + picEmrCode + "^" + linkCode + "^" + GLOBAL.HospitalID;
	var ret = tkMakeServerCall("Nur.DHCNurEmrInfoMethod", "import", parr);
	ID = tkMakeServerCall("Nur.DHCNurEmrInfoMethod", "getIdByCode", datasourceCode, GLOBAL.HospitalID);
	return ID;
}
function importParams(paramName, paramDesc, paramValue, paramType, paramLinkNo, par) {
	var parr = par + "^" + paramName + "^" + paramDesc + "^" + paramValue + "^" + paramType + "^" + paramLinkNo;
	var ret = tkMakeServerCall("Nur.DHCNurEmrInfoPar", "import", parr);
	return ret;
}
function importField(fieldName, fieldDesc, fieldValue, fieldType, fieldLinkNo, par) {
	var parr = par + "^" + fieldName + "^" + fieldDesc + "^" + fieldValue + "^" + fieldType + "^" + fieldLinkNo + "^" + par;
	var ret = tkMakeServerCall("Nur.DHCNurEmrInfoReturn", "import", parr);
	return ret;
}

function updateSource() {
	$cm({
		ClassName: 'NurMp.Service.Source.Handle',
		MethodName: 'GetNeedUpdateSources'
	},function(result){
		$.messager.confirm('提示', '您确定要更新以下数据源? <br><span style="color:red;">' + result.join(';<br>') + "</span>", function (r) {
	        if (r) {
	            $m({
					ClassName: 'NurMp.Service.Source.Handle',
					MethodName: 'UpdateSource',
					HospitalID: GLOBAL.HospitalID
				},function(result){
					if (result == 0) {
						searchDataItem();
						$.messager.popover({ msg: '数据源更新成功,可点击查看!', type: 'success' });
					} else {
						$.messager.popover({ msg: '数据源更新失败!', type: 'error' });
					}
				});
	        } else {
	            return;
	        }
	    });
	});
}

function passwd_init(){
    document.getElementById("fieldString").addEventListener("focus", function(){
        document.getElementById("tips").style.display =  "block";
    })
    document.getElementById("fieldString").addEventListener("blur", function(){
        document.getElementById("tips").style.display =  "none";
    })
}

/**
 * @description 解析字段
 */
function parseField(){
	var fieldString = $('#fieldString').val();
	var dataSourceRow = $('#dataSourceGrid').datagrid('getSelected');
	if (!dataSourceRow) {
		$.messager.popover({ msg: '请选择一条数据源!', type: 'info' });
		return;
	}
	if (!fieldString) {
		$.messager.popover({ msg: '请输入解析字段!', type: 'error' });
		return;
	}
	console.log(fieldString, dataSourceRow);
	var formula = fieldString;
	$m({
		ClassName: "NurMp.Service.Source.Handle",
		MethodName: "ParseField",
		id:dataSourceRow.id,
		formula: formula
	}, function (result) {
		if (result == 0) {
			$.messager.popover({ msg: '字段添加成功！', type: 'success' });
			$('#fieldGrid').datagrid('reload');
		} else if (result == 2) {
			$.messager.popover({ msg: '表达式错误！', type: 'error' });
			$('#fieldGrid').datagrid('reload');
		} else {
			$.messager.popover({ msg: result, type: 'error' });
		}
	});
}