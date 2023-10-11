/**
 * description: ǰ̨�������� - ͨ����ά��
 * creator:     Huxt 2021-08-01
 * csp:         pha.sys.v1.comcol.csp
 * js:          pha/sys/v1/comcol.js
 */
PHA_COM.App.ProCode = 'SYS';
PHA_COM.App.ProDesc = $g('ϵͳ����');
PHA_COM.App.Csp = 'pha.sys.v1.comcol.csp';
PHA_COM.App.Name = $g('ͨ����ά��');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};
PHA_GridEditor.AutoUpd = true;

$(function () {
	if (PHA_COM.IsTabsMenu()){
		$('#panelMain').panel({
			title: '',
			iconCls: 'icon-set-col',
			headerCls: 'panel-header-gray',
			fit: true
		});
	}
	
	InitDict();
	InitGridComCol();
	InitEvents();
	
	Query();
});

// ��ʼ�� - �¼�
function InitEvents() {
	// ��ť
	$('#btnRefresh').on('click', Query);
	$('#btnAdd').on('click', Add);
	$('#btnSave').on('click', Save);
	$('#btnDelete').on('click', Delete);
	$('#btnMoveUp').on('click', UpAndDown);
	$('#btnMoveDown').on('click', UpAndDown);
	$('#btnHelp').on('click', ShowHelp);
}

// ��ʼ�� - ��
function InitDict() {
	InitDictVal();
}
function InitDictVal(){
}

// ��ʼ�� - ���
function InitGridComCol() {
	var columns = [[{
				field: 'ColId',
				title: 'ColId',
				hidden: true,
				width: 100
			}, {
				field: 'ColTableName',
				title: 'ColTableName',
				hidden: true,
				width: 100
			}, {
				field: 'ColPointer',
				title: 'ColPointer',
				hidden: true,
				width: 100
			}, {
				field: 'ColSort',
				title: '��˳��',
				hidden: true,
				width: 70,
				align: 'center'
			}, {
				field: 'ColField',
				title: '�ֶ�',
				width: 110,
				editor: PHA_GridEditor.ValidateBox({
					required: true
				})
			}, {
				field: 'ColTitle',
				title: '����',
				width: 110,
				editor: PHA_GridEditor.ValidateBox({
					required: true
				})
			}, {
				field: 'ColWidth',
				title: '���',
				width: 70,
				align: 'left',
				editor: PHA_GridEditor.ValidateBox({
					checkValue: function(val, chkRet){
						if (!val) {
							return true;
						}
						if (isNaN(val)) {
							chkRet.msg = '����������';
							return false;
						}
						val = parseFloat(val);
						if (val <= 20) {
							chkRet.msg = '���������20������';
							return false;
						}
						return true;
					}
				})
			}, {
				field: 'ColAlign',
				title: '����',
				width: 88,
				align: 'left',
				editor: PHA_GridEditor.ComboBox({
					panelHeight: 'auto',
					data: [{
							RowId: 'left',
							Description: 'left'
						}, {
							RowId: 'center',
							Description: 'center'
						}, {
							RowId: 'right',
							Description: 'right'
						}
					]
				})
			}, {
				field: 'ColTipWidth',
				title: '��ʾ���',
				width: 70,
				align: 'left',
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				field: 'ColValExp',
				title: 'ȡֵ���ʽ',
				width: 300,
				rowHeight: 28,
				editor: PHA_GridEditor.ComboGrid({
					url: $URL + '?ResultSetType=Json&ClassName=PHA.SYS.Col.Query&QueryName=ValExp',
					panelWidth: 500,
					fitColumns: true,
					idField: 'RowId',
					textField: 'RowId',
					pageSize: 30,
					qLen: 0,
					columns: [[{
							field: 'RowId',
							title: '���ʽ',
							width: 150,
						}, {
							field: 'Description',
							title: '���ʽ����',
							width: 100,
						}
					]],
					onBeforeNext: function(cmbRowData, gridRowData, gridRowIndex){
						gridRowData.ColValExpDesc = cmbRowData.Description;
					}
				})
			}, {
				field: 'ColValExpDesc',
				title: 'ȡֵ���ʽ����',
				width: 160
			}, {
				field: 'ColValConvert',
				title: 'ֵת�����ʽ',
				width: 140,
				editor: PHA_GridEditor.ComboGrid({
					url: $URL + '?ResultSetType=Json&ClassName=PHA.SYS.Col.Query&QueryName=ValConvert',
					panelWidth: 410,
					fitColumns: true,
					idField: 'RowId',
					textField: 'RowId',
					pageSize: 30,
					qLen: 0,
					columns: [[{
							field: 'RowId',
							title: '���ʽ',
							width: 100,
						}, {
							field: 'Description',
							title: '���ʽ����',
							width: 150,
						}
					]],
					onBeforeNext: function(cmbRowData, gridRowData, gridRowIndex){
						gridRowData.ColValConvertDesc = cmbRowData.Description;
					}
				})
			}, {
				field: 'ColValConvertDesc',
				title: 'ֵת�����ʽ����',
				width: 160
			}, {
				field: 'ColSortable',
				title: '����',
				width: 60,
				align: 'center',
				formatter: PHA_GridEditor.CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}, {
				field: 'ColHidden',
				title: '����',
				width: 60,
				align: 'center',
				formatter: PHA_GridEditor.CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}, {
				field: 'ColIfExport',
				title: '����',
				width: 60,
				align: 'center',
				formatter: PHA_GridEditor.CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}, {
				field: 'ColIsCheckbox',
				title: '��ѡ��',
				width: 62,
				align: 'center',
				formatter: PHA_GridEditor.CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}, {
				field: 'ColFrozen',
				title: '�ж���',
				width: 62,
				align: 'center',
				formatter: PHA_GridEditor.CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}, {
				field: 'ColFixed',
				title: '�п�̶�',
				width: 70,
				align: 'center',
				formatter: PHA_GridEditor.CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}
		]
	];
	var dgOptions = {
		url: '',
		queryParams: {
			ClassName: 'PHA.SYS.Col.Query',
			QueryName: 'PHAINCol'
		},
		fitColumns: false,
		rownumbers: false,
		columns: columns,
		pagination: true,
		singleSelect: true,
		gridSave: true,
		isCellEdit: true,
		editFieldSort: ['ColField', 'ColTitle', 'ColWidth', 'ColAlign', 'ColTipWidth', 'ColValExp', 'ColValConvert'],
		toolbar: '#gridComColBar',
		onSelect: function (rowIndex, rowData) {},
		onLoadSuccess: function(data){
			$('#btnMoveUp').prop('disabled', '');
			$('#btnMoveDown').prop('disabled', '');
			var selectedRowIndex = $(this).datagrid('options').selectedRowIndex;
			if (selectedRowIndex >= 0 && data.total > selectedRowIndex) {
				$(this).datagrid('selectRow', selectedRowIndex);
			}
		},
		onClickCell: function(index, field, value){
			PHA_GridEditor.Edit({
				gridID: 'gridComCol',
				index: index,
				field: field
			});
		}
	};
	PHA.Grid('gridComCol', dgOptions);
}

// ��ѯ
function Query() {
	var comColStr = GetCOMColStr();
	$('#gridComCol').datagrid('options').url = $URL;
	$('#gridComCol').datagrid('load', {
		ClassName: 'PHA.SYS.Col.Query',
		QueryName: 'PHAINCol',
		inputStr: comColStr,
		includeAllFlag: ''
	});
}

// ����
function Add(){
	var comColStr = GetCOMColStr();
	var comColArr = comColStr.split('^');
	PHA_GridEditor.Add({
		gridID: 'gridComCol',
		field: 'ColField',
		rowData: {
			ColId: '',
			ColTableName: comColArr[0],
			ColPointer: comColArr[1],
			ColSort: 'N',
			ColField: '',
			ColTitle: '',
			ColWidth: 100,
			ColAlign: 'left',
			ColTipWidth: '',
			ColValExp: '',
			ColValExpDesc: '',
			ColValConvert: '',
			ColValConvertDesc: '',
			ColSortable: 'N',
			ColHidden: 'N',
			ColIfExport: 'Y',
			ColIsCheckbox: 'N',
			ColFrozen: 'N',
			ColFixed: 'N'
		},
		checkRow: true
	});
}

// ����
function Save(){
	PHA_GridEditor.End('gridComCol');
	var rowsData = $('#gridComCol').datagrid('getRows');
	if ((rowsData == null || rowsData.length == 0)) {
		PHA.Popover({
			msg: "û����Ҫ���������!",
			type: "alert"
		});
		return;
	}
	var chkRetStr = PHA_GridEditor.CheckDistinct({
		gridID: 'gridComCol',
		fields: ['ColField']
	});
	if (chkRetStr != '') {
		PHA.Popover({
			msg: '�ֶ�' + ':' + chkRetStr,
			type: 'alert'
		});
		return;
	}
	var chkRetStr = PHA_GridEditor.CheckValues('gridComCol');
	if (chkRetStr != '') {
		PHA.Popover({
			msg: chkRetStr,
			type: 'alert'
		});
		return;
	}
	
	var jsonColStr = JSON.stringify(rowsData);
	var jsonCol = JSON.parse(jsonColStr);
	for (var i = 0; i < jsonCol.length; i++) {
		var iCol = jsonCol[i];
		if (iCol.ColValConvert && iCol.ColValConvert != '') {
			iCol.ColValExp = iCol.ColValExp + '-' + iCol.ColValConvert;
		}
	}
	jsonColStr = JSON.stringify(jsonCol);
	
	var retText = tkMakeServerCall('PHA.SYS.Col.Save', 'SaveForPIPIS', jsonColStr);
	var retArr = retText.split('^');
	if (retArr[0] < 0) {
		PHA.Alert("��ܰ��ʾ", retArr[1], retArr[0]);
		return;
	}
	PHA.Popover({
		msg: "����ɹ�!",
		type: "success"
	});
	Query();
}

// ɾ����
function Delete() {
	var gridSelect = $('#gridComCol').datagrid('getSelected') || "";
	if (gridSelect == "") {
		PHA.Popover({
			msg: "��ѡ��Ҫɾ������",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var colId = gridSelect.ColId || '';
	PHA.Confirm("��ܰ��ʾ", '�Ƿ�ȷ��ɾ�����У�', function () {
		if (colId == '') {
			var rowIndex = $('#gridComCol').datagrid('getRowIndex', gridSelect);
			$('#gridComCol').datagrid('deleteRow', rowIndex);
			return;
		}
		
		var saveRet = $.cm({
			ClassName: 'PHA.SYS.Col.Save',
			MethodName: 'Delete',
			Id: colId,
			dataType: 'text'
		}, false);
		var saveArr = saveRet.split('^');
		var saveVal = saveArr[0];
		var saveInfo = saveArr[1];
		if (saveVal < 0) {
			PHA.Alert('��ܰ��ʾ', saveInfo, saveVal);
			return;
		} else {
			PHA.Popover({
				msg: 'ɾ���ɹ�!',
				type: 'success'
			});
			Query();
		}
	});
}

// �����ƶ�
function UpAndDown(e){
	PHA_GridEditor.End('gridComCol');
	var chkRetStr = PHA_GridEditor.CheckDistinct({
		gridID: 'gridComCol',
		fields: ['ColField']
	});
	if (chkRetStr != '') {
		PHA.Popover({
			msg: '�ֶ�' + ':' + chkRetStr,
			type: 'alert'
		});
		return;
	}
	var chkRetStr = PHA_GridEditor.CheckValues('gridComCol');
	if (chkRetStr != '') {
		PHA.Popover({
			msg: chkRetStr,
			type: 'alert'
		});
		return;
	}
	
	var ret = PHA_GridEditor.__UpAndDown_Exchange({
		gridID: 'gridComCol',
		ifUp: (e.currentTarget.id.indexOf('Up') > 0 ? true : false)
	});
	if (!ret) {
		return;
	}
	var selectedRow = $('#gridComCol').datagrid('getSelected') || {};
	var selectedRowIndex = $('#gridComCol').datagrid('getRowIndex', selectedRow);
	$('#gridComCol').datagrid('options').selectedRowIndex = selectedRowIndex;
	
	$('#btnMoveUp').prop('disabled', 'disabled');
	$('#btnMoveDown').prop('disabled', 'disabled');
	var rowsData = $('#gridComCol').datagrid('getRows');
	var jsonColStr = JSON.stringify(rowsData);
	var saveRet = tkMakeServerCall('PHA.SYS.Col.Save', 'SaveForPIPIS', jsonColStr);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('��ܰ��ʾ', saveInfo, saveVal);
		return;
	} else {
		PHA.Popover({
			msg: '�����ɹ�!',
			type: 'success'
		});
		Query();
	}
}

// ��ȡ�ַ���
function GetCOMColStr(){
	if (PHA_COM.VAR.COMColStr) {
		return PHA_COM.VAR.COMColStr;
	}
	PHA_COM.VAR.COMColStr = tkMakeServerCall('PHA.SYS.Col.Query', 'GetCOMColStr');
	return PHA_COM.VAR.COMColStr;
}

// ��������
function ShowHelp(){
	/* �������� */
	var winId = "comcol_help_win";
	var winContentId = winId + "_" + "content";
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		$('#' + winId).dialog({
			width: 650,
			height: 480,
			modal: true,
			title: 'ͨ����ά������',
			iconCls: 'icon-w-list',
			content: "<div id='" + winContentId + "'style='margin:10px;'></div>",
			closable: true
		});
		$('#' + winContentId).html(GetInitHtml());
	}
	$('#' + winId).dialog('open');
	
	/* �������� */
	function GetInitHtml(){
		var helpHtml = '';
		helpHtml += GetItemTitle('ͨ����');
		helpHtml += GetItemContent('ͨ������ָ�����ڸ�����ÿ�������ʾ���У�������Ա��Ҫ�ٵ�����ÿ�������������Ϣ��');
		helpHtml += GetItemTitle('ͨ���е�ά��');
		helpHtml += GetItemContent('ͨ������Ϣ��ά����Ҫ�����ֶκ��ֶε�ȡֵ��');
		helpHtml += GetItemTitle('��̨��ѯ����');
		helpHtml += GetItemContent('ά����ͨ������Ϣ֮����Ҫ�ڶ�Ӧ�ķ����е���һ��ͨ�õ�ȡֵ���������ܸ���ȡֵ���ʽȡֵ��ͨ�õ�ȡֵ�������£�');
		helpHtml += GetItemContent('s colVals = ##class(PHA.SYS.Col.Value).%New()');
		helpHtml += GetItemContent('s colVals.inci = inci');
		helpHtml += GetItemContent('s colVals.arcim = arcim');
		helpHtml += GetItemContent('s colVals...');
		helpHtml += GetItemContent('s rowData = colVals.GetRowJson(.outVal)');
		helpHtml += GetItemTitle('ͨ���е���ʾ');
		helpHtml += GetItemContent('ά����ͨ���У������ں�̨���ö�Ӧ��ȡֵ����֮������н����ϵ�ĳ�������Ҫ��ʾ��Щ�У�������ڡ������õ�������ѡ��ʾͨ���л����ڡ�ҳ�����á�����������ʾͨ���С�');
		return helpHtml;
	}
	function GetItemTitle(title){
		return '<div style="margin-top:10px;"><b>' + trans(title) + '��</b></div>';
	}
	function GetItemContent(content){
		return '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + trans(content) + '</p>';
	}
	function trans(val){
		try {
			return $g(val);
		} catch(ex){
			return val;
		}
	}
}