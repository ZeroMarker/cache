/**
 * 药房药库公共 - 接口列表维护
 * csp: csp/pha.sys.v1.facedict.csp
 * js:  scripts/pha/sys/v1/facedict.js
 */
var GridCmbPharmacy = '';
var Com_HospId = session['LOGON.HOSPID'];
$(function () {
	InitHosp();
	InitGridDict();
	InitFaceDictGrid();

	InitEvent();
	HelpInfo();
	
	QueryFaceDict();
});

function InitGridDict() {
	$HUI.validatebox('#conAlias', {
		placeholder: '输入您想找的内容...'
	});
	GridCmbPharmacy = PHA.EditGrid.ComboBox({
		required: false,
		tipPosition: 'top',
		url: PHA_STORE.Pharmacy().url,
		defaultFilter: 5,
		mode: 'remote',
		onSelect: function (index, rowData) {
			var editIndex = $('#gridFaceDict').datagrid('options').editIndex;
			if (editIndex == undefined) {
				return;
			}
			var faceLocId = $(this).combobox('getValue');
			if ((faceLocId == '') || (faceLocId == null)) {
				return;
			}
			var gridSelect = $('#gridFaceDict').datagrid('getSelected');
			gridSelect.faceLocId = faceLocId;
		},
		onBeforeLoad: function (param) {
			if (param.q == undefined) {
				param.q = $('#gridFaceDict').datagrid('getSelected').faceUseLoc;
			}
			param.QText = param.q;
			param.HospId = Com_HospId;
		}
	});
}
function InitEvent() {
	$('#btnFind').on('click', QueryFaceDict);
	$('#btnClean').on('click', Clean);
	$('#btnAdd').on('click', function () {
		$('#gridFaceDict').datagrid('addNewRow', {
			editField: 'faceCode',
			defaultRow: {
				activeFlag: 'Y'
			}
		});
	});
	$('#btnSave').on('click', SaveFaceDict);
	$('#btnDelete').on('click', DelFaceDict);
	$('#conAlias').on('keydown', function(e){
		if (e.keyCode == 13) {
			QueryFaceDict();
		}
	});
}
function InitHosp() {
	var hospComp = GenHospComp('PHA-OP-LocConfig');
	hospComp.options().onSelect = function (record) {
		Com_HospId = $('#_HospList').combogrid('getValue') || ''; ;
		QueryFaceDict();
	}
}
function InitFaceDictGrid() {
	var columns = [[{
				field: 'faceRowId',
				title: '接口字典id',
				hidden: true,
				width: 100
			}, {
				field: 'faceCode',
				title: '接口代码',
				descField: 'faceCode',
				width: 80,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				field: 'faceDesc',
				title: '接口描述',
				width: 150,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				field: 'faceLocId',
				title: '使用科室',
				descField: 'faceLocDesc',
				width: 150,
				editor: GridCmbPharmacy,
				formatter: function (value, row, index) {
					return row.faceLocDesc;
				}
			}, {
				field: 'className',
				title: '接口类',
				width: 220,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				field: 'methodName',
				title: '接口方法',
				descField: 'methodName',
				width: 150,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				field: 'remarks',
				title: '备注',
				width: 150,
				editor: {
					type: 'validatebox'

				}
			}, {
				field: 'activeFlag',
				title: '启用',
				width: 70,
				align: 'center',
				formatter: FormatterCheck,
				editor: {
					type: 'icheckbox',
					options: {
						on: 'Y',
						off: 'N'
					}
				}
			}, {
				field: 'runMethod',
				title: '类方法',
				width: 200,
				formatter: function(value, rowData, rowIndex){
					var className = rowData.className || '';
					var methodName = rowData.methodName || '';
					var methodArg = rowData.methodArg || '';
					if (className == '' || methodName == '') {
						return '';
					}
					return LOG_COM.FmtMethodStr(className, methodName, methodArg);
				}
			}, {
				field: 'runTest',
				title: '测试',
				width: 70,
				align: 'center',
				formatter: function(value, rowData, rowIndex){
					return LOG_COM.IconBtn('run.png', 'OpenRunFaceWin', rowIndex, '点击测试进入测试弹窗');
				}
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			pClassName: 'PHA.SYS.LOG.Api',
			pMethodName: 'FaceDict',
			pPlug: 'datagrid'
		},
		pagination: false,
		columns: columns,
		toolbar: '#gridFaceDictBar',
		enableDnd: false,
		fitColumns: false,
		rownumbers: true,
		exportXls: false,
		onClickRow: function (rowIndex, rowData) {
			$(this).datagrid('endEditing');
		},
		onDblClickCell: function (index, field, value) {
			var fieldOpts = $(this).datagrid('getColumnOption', field);
			if (fieldOpts.editor) {
				$(this).datagrid('beginEditRow', {
					rowIndex: index,
					editField: field
				});
			}
		},
		onLoadSuccess: function (data) {
			$(this).datagrid('autoSizeColumn', 'runMethod');
		}
	};
	PHA.Grid('gridFaceDict', dataGridOption);
}

function QueryFaceDict() {
	var pJson = {};
	pJson.hospId = Com_HospId;
	pJson.QText = $('#conAlias').val() || '';
	
	$('#gridFaceDict').datagrid('options').url = PHA.$URL;
	$('#gridFaceDict').datagrid('load', {
		pClassName: 'PHA.SYS.LOG.Api',
		pMethodName: 'FaceDict',
		pPlug: 'datagrid',
		pJsonStr: JSON.stringify(pJson)
	});
}

function SaveFaceDict() {
	/* 验证数据 */
	var $grid = $('#gridFaceDict');
	if ($grid.datagrid('endEditing') == false) {
		PHA.Popover({
			msg: '请先完成必填项',
			type: 'alert'
		});
		return;
	}
	var repeatObj = $grid.datagrid('checkRepeat', [['faceCode', 'faceLocId']]);
	if (typeof repeatObj.pos === 'number') {
		PHA.Popover({
			msg: '第' + (repeatObj.pos + 1) + '、' + (repeatObj.repeatPos + 1) + '行:' + repeatObj.titleArr.join('、') + '重复',
			type: 'alert'
		});
		return;
	}
	/* 获取新增或修改的数据 */
	var dataArr = [];
	var gridUpdated = $grid.datagrid('getChanges', 'updated') || [];
	for (var i = 0; i < gridUpdated.length; i++) {
		dataArr.push(gridUpdated[i]);
	}
	var gridInserted = $grid.datagrid('getChanges', 'inserted') || [];
	for (var i = 0; i < gridInserted.length; i++) {
		dataArr.push(gridInserted[i]);
	}
	if (dataArr.length === 0) {
		PHA.Popover({
			msg: '没有需要保存的数据',
			type: 'alert'
		});
		return;
	}
	/* 后台保存 */
	var retJson = $.cm({
		ClassName: 'PHA.COM.DataApi',
		MethodName: 'HandleInOne',
		pClassName: 'PHA.SYS.LOG.Api',
		pMethodName: 'SaveFaceDict',
		pJsonStr: JSON.stringify(dataArr)
	}, false);
	if (retJson.success === 'N') {
		var msg = PHA_COM.DataApi.Msg(retJson);
		PHA.Alert('提示', msg, 'warning');
		return;
	} else {
		PHA.Popover({
			msg: '保存成功',
			type: 'success'
		});
	}
	$grid.datagrid('reload');
}

function DelFaceDict() {
	var $grid = $('#gridFaceDict');
	var gridSelect = $grid.datagrid('getSelected') || '';
	if (gridSelect == '') {
		PHA.Popover({
			msg: '请先选中需要删除的行',
			type: 'alert',
			timeout: 1000
		});
		return;
	}
	var faceRowId = gridSelect.faceRowId || '';
	if (faceRowId !== '') {
		PHA.Popover({
			msg: '已保存数据不能删除记录！',
			type: 'alert',
			timeout: 1000
		});
		return
	}
	PHA.Popover({
		msg: '删除成功',
		type: 'success'
	});
	var rowIndex = $grid.datagrid('getRowIndex', gridSelect);
	$grid.datagrid('deleteRow', rowIndex);
}

function Clean() {
	$('#conAlias').val('');
	$('#gridFaceDict').datagrid('loadData', []);
}

function FormatterCheck(value, row, index) {
	if (value === 'Y' || value === '1') {
		return PHA_COM.Fmt.Grid.Yes.Chinese;
	} else {
		return PHA_COM.Fmt.Grid.No.Chinese;
	}
}

function HelpInfo() {
	$('#btnHelp').popover({
		title: '已嵌入接口',
		trigger: 'hover',
		padding: '10px',
		width: 650,
		content: '<div>'
		 + '<p >101--发送处方到摆药  </p >'
		 + '<p class="pha-row">110--发药机  </p >'
		 + '<p class="pha-row">102--收费后报到(查询)  </p >'
		 + '<p class="pha-row">1021--收费后报到(保存)  </p >'
		 + '<p class="pha-row">103--叫号亮灯  </p >'
		 + '<p class="pha-row">104--发药灭灯  </p >'
		 + '<p class="pha-row">105--刷卡亮灯  </p >'
		 + '<p class="pha-row">106--发药查询叫号功能  </p >'
		 + '<p class="pha-row">107--叫号上屏  </p >'
		 + '<p class="pha-row">108--发药时下屏  </p >'
		 + '<p class="pha-row">109--何时上屏  </p >'
		 + '</div>'
	});
}

function OpenRunFaceWin(rowIndex){
	var rowsData = $('#gridFaceDict').datagrid('getRows');
	var rowData = rowsData[rowIndex];
	if (rowData == null) {
		return;
	}
	if (!rowData.faceRowId || rowData.faceRowId == '') {
		PHA.Popover({
			msg: '保存接口之后才能测试！',
			type: 'alert',
			timeout: 1000
		});
		return;
	}
	LOG_COM.RunFaceWin({
		title: '测试接口方法',
		editParam: true,
		ClassName: rowData.className,
		MethodName: rowData.methodName,
		MethodParams: {},
		faceLoc: rowData.faceLocId,
		faceCode: rowData.faceCode,
		runType: 'Test',
		relaLogId: '',
		runRet: ''
	});
}