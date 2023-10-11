/**
 * ҩ��ҩ�⹫�� - �ӿ��б�ά��
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
		placeholder: '���������ҵ�����...'
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
				title: '�ӿ��ֵ�id',
				hidden: true,
				width: 100
			}, {
				field: 'faceCode',
				title: '�ӿڴ���',
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
				title: '�ӿ�����',
				width: 150,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				field: 'faceLocId',
				title: 'ʹ�ÿ���',
				descField: 'faceLocDesc',
				width: 150,
				editor: GridCmbPharmacy,
				formatter: function (value, row, index) {
					return row.faceLocDesc;
				}
			}, {
				field: 'className',
				title: '�ӿ���',
				width: 220,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				field: 'methodName',
				title: '�ӿڷ���',
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
				title: '��ע',
				width: 150,
				editor: {
					type: 'validatebox'

				}
			}, {
				field: 'activeFlag',
				title: '����',
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
				title: '�෽��',
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
				title: '����',
				width: 70,
				align: 'center',
				formatter: function(value, rowData, rowIndex){
					return LOG_COM.IconBtn('run.png', 'OpenRunFaceWin', rowIndex, '������Խ�����Ե���');
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
	/* ��֤���� */
	var $grid = $('#gridFaceDict');
	if ($grid.datagrid('endEditing') == false) {
		PHA.Popover({
			msg: '������ɱ�����',
			type: 'alert'
		});
		return;
	}
	var repeatObj = $grid.datagrid('checkRepeat', [['faceCode', 'faceLocId']]);
	if (typeof repeatObj.pos === 'number') {
		PHA.Popover({
			msg: '��' + (repeatObj.pos + 1) + '��' + (repeatObj.repeatPos + 1) + '��:' + repeatObj.titleArr.join('��') + '�ظ�',
			type: 'alert'
		});
		return;
	}
	/* ��ȡ�������޸ĵ����� */
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
			msg: 'û����Ҫ���������',
			type: 'alert'
		});
		return;
	}
	/* ��̨���� */
	var retJson = $.cm({
		ClassName: 'PHA.COM.DataApi',
		MethodName: 'HandleInOne',
		pClassName: 'PHA.SYS.LOG.Api',
		pMethodName: 'SaveFaceDict',
		pJsonStr: JSON.stringify(dataArr)
	}, false);
	if (retJson.success === 'N') {
		var msg = PHA_COM.DataApi.Msg(retJson);
		PHA.Alert('��ʾ', msg, 'warning');
		return;
	} else {
		PHA.Popover({
			msg: '����ɹ�',
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
			msg: '����ѡ����Ҫɾ������',
			type: 'alert',
			timeout: 1000
		});
		return;
	}
	var faceRowId = gridSelect.faceRowId || '';
	if (faceRowId !== '') {
		PHA.Popover({
			msg: '�ѱ������ݲ���ɾ����¼��',
			type: 'alert',
			timeout: 1000
		});
		return
	}
	PHA.Popover({
		msg: 'ɾ���ɹ�',
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
		title: '��Ƕ��ӿ�',
		trigger: 'hover',
		padding: '10px',
		width: 650,
		content: '<div>'
		 + '<p >101--���ʹ�������ҩ  </p >'
		 + '<p class="pha-row">110--��ҩ��  </p >'
		 + '<p class="pha-row">102--�շѺ󱨵�(��ѯ)  </p >'
		 + '<p class="pha-row">1021--�շѺ󱨵�(����)  </p >'
		 + '<p class="pha-row">103--�к�����  </p >'
		 + '<p class="pha-row">104--��ҩ���  </p >'
		 + '<p class="pha-row">105--ˢ������  </p >'
		 + '<p class="pha-row">106--��ҩ��ѯ�кŹ���  </p >'
		 + '<p class="pha-row">107--�к�����  </p >'
		 + '<p class="pha-row">108--��ҩʱ����  </p >'
		 + '<p class="pha-row">109--��ʱ����  </p >'
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
			msg: '����ӿ�֮����ܲ��ԣ�',
			type: 'alert',
			timeout: 1000
		});
		return;
	}
	LOG_COM.RunFaceWin({
		title: '���Խӿڷ���',
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