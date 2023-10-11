/*
 * ����:	 ҩ������ - ҩƷͼ������
 * ��д��:	 Huxt
 * ��д����: 2021-05-06
 * csp:      pha.in.v1.drugicon.csp
 * js:       pha/in/v1/drugicon.js
 */

PHA_COM.VAR = {
	callQuery: false
};

$(function () {
	InitLayout();
	InitDict();
	InitGridDrugIcon();
	InitGridDrugIconItm();
	InitGridNotUsedIcon();
	InitEvents();
	// ��ѯ
	PHA_COM.VAR.callQuery = true;
	QueryDrugIcon();
});
function InitLayout() {
	// ����
	PHA_COM.ResizePanel({
		layoutId: 'layout-right',
		region: 'north',
		height: 0.6
	});
	// ��ʼ������Tab
	var fixedTitle = $g("ͼ����������");
	$('#drugIconSetType').tabs({
		fit: true,
		border: false,
		headerWidth: 100,
		isBrandTabs: false,
		border: false,
		onSelect: function (title) {
			if (title == fixedTitle) {
				return;
			}
			var tabOpts = $('#drugIconSetType').tabs('options')
			if (!tabOpts.callOnSelect) {
				return;
			}
			var _stOpts = $('#drugIconSetType').tabs('getTab', title).panel('options');
			if (_stOpts.TCode == 'OtherProp') {
				Clear();
				var selRowData = $('#' + _stOpts.gridId).datagrid('getSelected');
				if (selRowData) {
					SetTypeData({
						TCode: selRowData.TCode,
						TName: tkMakeServerCall('PHA.IN.DrugIcon.Com', 'Get', selRowData.TName) // $g(selRowData.TName)
					});
					if (PHA_COM.VAR.callQuery) {
						QueryDrugIcon();
					}
				}
			} else {
				SetTypeData({
					TCode: _stOpts.TCode,
					TName:  tkMakeServerCall('PHA.IN.DrugIcon.Com', 'Get', _stOpts.TName) // $g(_stOpts.TName)
				});
				if (PHA_COM.VAR.callQuery) {
					QueryDrugIcon();
				}
			}
		}
	});
	$('#drugIconSetType').tabs('add', {
		title: fixedTitle,
		iconCls: 'icon-img'
	});
	// ��̬���Tab
	var initTabData = tkMakeServerCall('PHA.IN.DrugIcon.Query', 'InitTabData');
	var initTabJson = eval('(' + initTabData + ')');
	for (var i = 0; i < initTabJson.length; i++) {
		var oneTabData = initTabJson[i];
		var tabTitle = oneTabData.tabTitle;
		var gridType = oneTabData.gridType;
		var clsQuery = oneTabData.clsQuery;
		var className = clsQuery.split(':')[0];
		var queryName = clsQuery.split(':')[1];
		var tOpts = {
			TName: tabTitle, // ����
			TCode: queryName,
			gridId: queryName,
			gridBarId: (queryName + 'Bar'),
			gridType: gridType,
			className: className,
			queryName: queryName,
			title: ('��' + tabTitle), // �ڲ�������$g()
			content: ('<table id="' + queryName + '"></table>')
		}
		$('#drugIconSetType').tabs('add', tOpts);
		if (gridType == 'datagrid') {
			InitGrid_Com(tOpts);
		}
		if (gridType == 'treegrid') {
			InitTreeGrid_Com(tOpts);
		}
	}
	$('#drugIconSetType').tabs('options').callOnSelect = true;
	$('#drugIconSetType').tabs('disableTab', 0);
	$('#drugIconSetType').tabs('select', '��ҩƷ');
}
// ��ʼ�� - ��
function InitDict() {}

// ��ʼ�� - �¼�
function InitEvents() {
	$('#btnFind').on('click', QueryDrugIcon);
	$('#btnClear').on('click', function(){
		Clear(true);
		QueryDrugIcon();
	});
	$('#btnAdd').on('click', Add);
	$('#btnSave').on('click', Save);
	$('#btnDelete').on('click', Delete);
	$('#TValueDesc').on('keydown', function(e){
		var tVal = $(this).val();
		if (tVal == '') {
			$('#TValue').val('');
			// QueryDrugIcon();
			// return;
		}
		if (e.keyCode == 13) {
			QueryDrugIcon();
		}
	});
	$('#btnPreview').on('click', DrugIconPreview);
}

// ��ʼ�� - ͼ�����ñ��
function InitGridDrugIcon() {
	var columns = [[{
				field: "pidi",
				title: 'pidi',
				width: 90,
				hidden: true
			}, {
				field: 'TCode',
				title: '���ʹ���',
				width: 90,
				hidden: true
			}, {
				field: 'TName',
				title: '����',
				fixed: true,
				width: 180
			}, {
				field: 'TValue',
				title: '����ֵID',
				width: 120,
				hidden: true
			}, {
				field: 'TValueDesc',
				title: '����ֵ',
				width: 120
			}, {
				field: "Color",
				title: '������ɫ',
				width: 100,
				fixed: true,
				styler: function(value, rowData, rowIndex){
					return 'color: ' + value + ';';
				},
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				field: 'BackColor',
				title: '������ɫ',
				width: 100,
				fixed: true,
				styler: function(value, rowData, rowIndex){
					return 'background-color:' + value + ';';
				},
				editor: PHA_GridEditor.ValidateBox({})
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.IN.DrugIcon.Query',
			QueryName: 'DrugIcon',
			hospId: session['LOGON.HOSPID']
		},
		fitColumns: true,
		border: false,
		rownumbers: true,
		columns: columns,
		pagination: true,
		singleSelect: true,
		toolbar: "#gridDrugIconBar",
		allowEnd: true,
		isAutoShowPanel: true,
		editFieldSort: ['Color', 'BackColor'],
		onSelect: function (rowIndex, rowData) {
			QueryDrugIconItm();
			QueryNotUsedIcon();
		},
		onClickCell: function(){
			PHA_GridEditor.End('gridDrugIcon');
		},
		onDblClickCell: function (index, field, value) {
			PHA_GridEditor.Edit({
				gridID: 'gridDrugIcon',
				index: index,
				field: field
			});
		},
		onLoadSuccess: function (data) {
			if (data.total == 0) {
				$('#gridDrugIconItm').datagrid('clear');
				$('#gridNotUsedIcon').datagrid('clear');
			} else {
				$(this).datagrid('selectRow', 0);
			}
		}
	};
	PHA.Grid("gridDrugIcon", dataGridOption);
}
// ��ѯ
function QueryDrugIcon() {
	var tData = GetTypeData();
	if (tData.TCode == '') {
		PHA.Popover({
			msg: '��ѡ��ͼ���������ͣ�',
			type: 'alert'
		});
		return;
	}
	$('#gridDrugIcon').datagrid('options').url = $URL;
	$('#gridDrugIcon').datagrid('query', {
		QText: (tData.TValueDesc || ""),
		pJsonStr: JSON.stringify({
			TCode: (tData.TCode || ""),
			hospId: session['LOGON.HOSPID']
		})
	});
}

function Add(){
	// ȡ���ͼ�����ֵ
	var selectedTab = $('#drugIconSetType').tabs('getSelected');
	if (!selectedTab) {
		PHA.Popover({
			msg: '��ѡ�����ͣ�',
			type: 'alert'
		});
		return;
	}
	var _tOpts = selectedTab.panel('options');
	if (_tOpts.TCode == "") {
		PHA.Popover({
			msg: '�������ѡ��ͼ���������ͣ�',
			type: 'alert'
		});
		return;
	}
	var gridType = _tOpts.gridType;
	var selRow = $('#' + _tOpts.gridId)[gridType]('getSelected');
	if (!selRow) {
		PHA.Popover({
			msg: '�������ѡ��ͼ�����������б��е����ݣ�',
			type: 'alert'
		});
		return;
	}
	var TCode = selRow.TCode || "";
	var TName = selRow.TName || "";
	var TNameOld = selRow.TNameOld || "";
	var TValue = selRow.RowId || "";
	var TValueDesc = selRow.Description || "";
	if (TCode == "" || TName == "") {
		PHA.Popover({
			msg: '��̨Queryδ���TCode��TName�У�',
			type: 'alert'
		});
		return;
	}
	if (TValue == "") {
		PHA.Popover({
			msg: '�������ѡ��ͼ�����������б��е����ݣ�',
			type: 'alert'
		});
		return;
	}
	// ��֤�ظ�
	var rowsData = $('#gridDrugIcon').datagrid('getRows');
	for (var i = 0; i < rowsData.length; i++) {
		var rowData = rowsData[i];
		if (rowData.TCode == TCode && rowData.TValue == TValue) {
			PHA.Popover({
				msg: '������ֵ���б����Ѵ��ڣ�',
				type: 'alert'
			});
			return;
		}
	}
	// �����
	PHA_GridEditor.Add({
		gridID: 'gridDrugIcon',
		field: 'Color',
		rowData: {
			TCode: TCode,
			TName: TName,
			TNameOld: TNameOld,
			TValue: TValue,
			TValueDesc: TValueDesc
		},
		checkRow: true,
		firstRow: false
	});
}

function Save(){
	PHA_GridEditor.End('gridDrugIcon');
	var changesData = $('#gridDrugIcon').datagrid('getChanges') || [];
	if (changesData.length == 0) {
		PHA.Popover({
			msg: 'û����Ҫ��������ݣ�',
			type: 'alert'
		});
		return;
	}
	var pJsonStr = JSON.stringify(changesData);
	var retStr = tkMakeServerCall('PHA.IN.DrugIcon.Save', 'SaveMulti', pJsonStr);
	var retArr = retStr.split('^');
	if (parseFloat(retArr[0]) < 0) {
		PHA.Alert("��ʾ", retArr[1], retArr[0]);
		return;
	}
	PHA.Popover({
		msg: '����ɹ���',
		type: 'success'
	});
	QueryDrugIcon();
}

function Delete(){
	// Ҫɾ����ID
	var selectedRow = $("#gridDrugIcon").datagrid("getSelected");
	if (selectedRow == null) {
		PHA.Popover({
			msg: "��ѡ����Ҫɾ��������!",
			type: "alert"
		});
		return;
	}
	var pidi = selectedRow.pidi || "";

	// ɾ��ȷ��
	PHA.Confirm("ɾ����ʾ", "�Ƿ�ȷ��ɾ��?", function () {
		var rowIndex = $("#gridDrugIcon").datagrid('getRowIndex', selectedRow);
		if (pidi == "") {
			$("#gridDrugIcon").datagrid('deleteRow', rowIndex);
			return;
		}
		var retStr = tkMakeServerCall('PHA.IN.DrugIcon.Save', 'Delete', pidi);
		var retArr = retStr.split('^');
		if (parseFloat(retArr[0]) < 0) {
			PHA.Alert("��ʾ", retArr[1], retArr[0]);
			return;
		}
		PHA.Popover({
			msg: 'ɾ���ɹ���',
			type: 'success'
		});
		QueryDrugIcon();
	});
}

function Clear(notClearType){
	ClearTypeData();
	if (notClearType === true) {
		// �����
	} else {
		$('#TName').val('');
		$('#TCode').val('');
	}
	$("#gridDrugIcon").datagrid('clear');
	$("#gridDrugIconItm").datagrid('clear');
	$("#gridNotUsedIcon").datagrid('clear');
}

// ��ʼ�� - ͼ�����ñ����ϸ
function InitGridDrugIconItm() {
	var columns = [[{
				field: "pidii",
				title: 'pidii',
				width: 100,
				hidden: true
			}, {
				field: "pii",
				title: 'pii',
				width: 100,
				hidden: true
			}, {
				field: 'OP',
				title: '����',
				fixed: true,
				width: 50,
				align: 'center',
				formatter: function (value, rowData, rowIndex) {
					return '<a title="' + $g('ɾ��ͼ��') + '" onclick=DelDrugIconItm("' + rowIndex + '") style="border:0px;cursor:pointer;text-decoration:underline">' + $g('ɾ��') + '</a>';
				}
			}, {
				field: 'IconPreviwe',
				title: 'ͼ��',
				width: 50,
				fixed: true,
				align: 'center',
				formatter: function (value, rowData, rowIndex) {
					return "<img src='" + (rowData.VirtualPath + "/" + rowData.Code) + "' title='" + (rowData.Tips) + "' class='pha-drugicon' />";
				}
			}, {
				field: 'IconInfo',
				title: 'ͼ������',
				width: 90,
				formatter: function (value, rowData, rowIndex) {
					return rowData.Name + " <label style='color:gray;'>[" + rowData.Code + "]</label>";
				}
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.IN.DrugIcon.Query',
			QueryName: 'DrugIconItm',
			page: 1,
			rows: 9999
		},
		fitColumns: true,
		border: false,
		rownumbers: false,
		columns: columns,
		pagination: false,
		singleSelect: true,
		toolbar: [],
		onSelect: function (rowIndex, rowData) {},
		onLoadSuccess: function () {
			PHA_COM.Drug.Tips();
		}
	};
	PHA.Grid("gridDrugIconItm", dataGridOption);
}
// ��ѯ
function QueryDrugIconItm() {
	var selRow = $('#gridDrugIcon').datagrid('getSelected') || {};
	var pidi = selRow.pidi || "";

	$('#gridDrugIconItm').datagrid('options').url = $URL;
	$('#gridDrugIconItm').datagrid('query', {
		QText: '',
		pJsonStr: JSON.stringify({
			pidi: pidi
		})
	});
}

// ��ʼ�� - δʹ��ͼ��
function InitGridNotUsedIcon() {
	var columns = [[{
				field: "pii",
				title: 'pii',
				width: 200,
				hidden: true
			}, {
				field: 'OP',
				title: '����',
				width: 50,
				fixed: true,
				align: 'center',
				formatter: function (value, rowData, rowIndex) {
					return '<a title="' + $g('��ӵ���ࡾ��ά��ͼ�꡿�б�') + '" onclick=AddDrugIconItm("' + rowIndex + '") style="border:0px;cursor:pointer;text-decoration:underline">' + $g('���') + '</a>';
				}
			}, {
				field: 'IconPreviwe',
				title: 'ͼ��',
				width: 50,
				fixed: true,
				align: 'center',
				formatter: function (value, rowData, rowIndex) {
					return "<img src='" + (rowData.VirtualPath + "/" + rowData.Code) + "' title='" + (rowData.Tips) + "' class='pha-drugicon' />";
				}
			}, {
				field: 'IconInfo',
				title: 'ͼ������',
				width: 90,
				formatter: function (value, rowData, rowIndex) {
					return rowData.Name + " <label style='color:gray;'>[" + rowData.Code + "]</label>";
				}
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.IN.DrugIcon.Query',
			QueryName: 'NotUsedIcon',
			page: 1,
			rows: 9999
		},
		fitColumns: true,
		border: false,
		rownumbers: false,
		columns: columns,
		pagination: false,
		singleSelect: true,
		toolbar: [],
		onSelect: function (rowIndex, rowData) {},
		onLoadSuccess: function () {
			PHA_COM.Drug.Tips();
		}
	};
	PHA.Grid("gridNotUsedIcon", dataGridOption);
}
// ��ѯ
function QueryNotUsedIcon() {
	var selRow = $('#gridDrugIcon').datagrid('getSelected') || {};
	var pidi = selRow.pidi || "";

	$('#gridNotUsedIcon').datagrid('options').url = $URL;
	$('#gridNotUsedIcon').datagrid('query', {
		QText: '',
		pJsonStr: JSON.stringify({
			pidi: pidi
		})
	});
}

// ���
function AddDrugIconItm(rowIndex) {
	var selRow = $('#gridDrugIcon').datagrid('getSelected');
	if (!selRow) {
		PHA.Popover({
			msg: '����ѡ��ҩƷͼ�����ã�',
			type: 'alert'
		});
		return;
	}
	var pidi = selRow.pidi || "";
	if (pidi == "") {
		PHA.Popover({
			msg: '����ѡ��ҩƷͼ������IDΪ�գ�',
			type: 'alert'
		});
		return;
	}
	var rowsData = $('#gridNotUsedIcon').datagrid('getRows');
	var rowData = rowsData[rowIndex] || {};
	var pii = rowData.pii;
	if (pii == "") {
		PHA.Popover({
			msg: 'δ��ȡ��ͼ�꣡',
			type: 'alert'
		});
		return;
	}
	var pJsonStr = JSON.stringify({
		pidi: pidi,
		pii: pii
	});

	var retStr = tkMakeServerCall('PHA.IN.DrugIcon.Save', 'SaveItm', '', pJsonStr);
	var retArr = retStr.split('^');
	if (parseFloat(retArr[0]) < 0) {
		PHA.Alert("��ʾ", retArr[1], retArr[0]);
		return;
	}
	PHA.Popover({
		msg: '��ӳɹ���',
		type: 'success'
	});
	QueryDrugIconItm();
	QueryNotUsedIcon();
}

function DelDrugIconItm(rowIndex) {
	var rowsData = $('#gridDrugIconItm').datagrid('getRows');
	var rowData = rowsData[rowIndex];
	var pidii = rowData.pidii;

	var retStr = tkMakeServerCall('PHA.IN.DrugIcon.Save', 'DeleteItm', pidii);
	var retArr = retStr.split('^');
	if (parseFloat(retArr[0]) < 0) {
		PHA.Alert("��ʾ", retArr[1], retArr[0]);
		return;
	}
	PHA.Popover({
		msg: 'ɾ���ɹ���',
		type: 'success'
	});
	QueryDrugIconItm();
	QueryNotUsedIcon();
}

// ======================
// ��ʼ�� - �ֵ���
function InitGrid_Com(_tOpts) {
	InitGridBar(_tOpts);
	var columns = [[{
				field: 'TCode',
				title: 'TCode',
				width: 120,
				hidden: true
			}, {
				field: 'TName',
				title: 'TName',
				width: 120,
				hidden: true
			}, {
				field: 'RowId',
				title: 'RowId',
				width: 80,
				hidden: true
			}, {
				field: 'Description',
				title: '����',
				width: 600
			}, {
				field: 'Code',
				title: '����',
				width: 200,
				hidden: false
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: _tOpts.className,
			QueryName: _tOpts.queryName,
			hospId: session['LOGON.HOSPID']
		},
		fitColumns: true,
		border: false,
		rownumbers: true,
		columns: columns,
		pagination: true,
		singleSelect: true,
		toolbar: '#' + _tOpts.gridBarId,
		onSelect: function (rowIndex, rowData) {
			SetTypeData(rowData);
			QueryDrugIcon();
		},
		onLoadSuccess: function () {}
	};
	PHA.Grid(_tOpts.gridId, dataGridOption);
}

// ��ʼ�� - ���α��
function InitTreeGrid_Com(_tOpts) {
	InitGridBar(_tOpts);
	var treeColumns = [
		[{
				field: 'TCode',
				title: 'TCode',
				width: 120,
				hidden: true
			}, {
				field: 'TName',
				title: 'TName',
				width: 120,
				hidden: true
			}, {
				field: 'RowId',
				title: 'RowId',
				width: 80,
				hidden: true
			}, {
				field: 'Description',
				title: '����',
				width: 600
			}, {
				field: 'Code',
				title: '����',
				width: 200,
				hidden: false
			}, {
				field: '_parentId',
				title: 'parentId',
				hidden: true
			}
		]
	];
	var dataOptions = {
		idField: 'RowId',
		treeField: 'Description',
		rownumbers: false,
		columns: treeColumns,
		queryParams: {
			ClassName: _tOpts.className,
			QueryName: _tOpts.queryName,
			hospId: session['LOGON.HOSPID'],
			pJsonStr: '{}',
			page: 1,
			rows: 9999
		},
		toolbar: '#' + _tOpts.gridBarId,
		onClickRow: function (rowId, rowData) {
			SetTypeData(rowData);
			QueryDrugIcon();
		},
		onExpand: function () {},
		onLoadSuccess: function () {}
	};
	PHA.TreeGrid(_tOpts.gridId, dataOptions);
}

function InitGridBar(_tOpts) {
	var barHtml = '';
	barHtml += '<div id="' + _tOpts.gridBarId + '">';
	barHtml += '	<div class="pha-row">';
	barHtml += '        <div class="pha-col">';
	barHtml += '            <input id="' + ('txt' + _tOpts.gridBarId) + '" placeholder="' + $g('ģ����ѯ����') + '..." class="hisui-validatebox" style="width:200px;"/>';
	barHtml += '        </div>';
	barHtml += '        <div class="pha-col">';
	barHtml += '            <a id="' + ('btn' + _tOpts.gridBarId) + '" class="hisui-linkbutton" iconCls="icon-w-find">' + $g('��ѯ') + '</a>';
	barHtml += '        </div>';
	barHtml += '	</div>';
	barHtml += '</div>';
	$('body').append(barHtml);
	$.parser.parse('#' + _tOpts.gridBarId);

	var _queryFn = function () {
		var QText = $('#' + 'txt' + _tOpts.gridBarId).val();
		if (_tOpts.gridType == 'datagrid') {
			$('#' + _tOpts.gridId).datagrid('query', {
				hospId: session['LOGON.HOSPID'],
				QText: QText
			});
		}
		if (_tOpts.gridType == 'treegrid') {
			var gOpts = $('#' + _tOpts.gridId).treegrid('options');
			var oldQueryParams = gOpts.queryParams;
			var newQueryParams = {};
			for (var k in oldQueryParams) {
				newQueryParams[k] = oldQueryParams[k];
			}
			newQueryParams.QText = QText;
			$('#' + _tOpts.gridId).treegrid('reload', newQueryParams);
		}
	}
	$('#' + 'btn' + _tOpts.gridBarId).on('click', function () {
		_queryFn();
	});
	$('#' + 'txt' + _tOpts.gridBarId).on('keydown', function (e) {
		if (e.keyCode == 13) {
			_queryFn();
		}
	});
}

// ҩƷͼ����ʽԤ��
function DrugIconPreview(){
	var winId = "drug_icon_preview";
	if ($('#' + winId).length == 0) {
		// �򿪴���
		$("<div id='" + winId + "'></div>").appendTo("body");
		var cHtml = "";
		cHtml += '<div class="hisui-layout" fit="true" border="false">';
		cHtml += '	<div data-options="region:\'center\',border:false" class="pha-body">';
		cHtml += '		<div class="hisui-layout" fit="true">';
		cHtml += '			<div data-options="region:\'center\', split:true,border:false">';
		cHtml += '				<div class="hisui-panel" data-options="iconCls:\'icon-house\',headerCls:\'panel-header-gray\',fit:true">';
		cHtml += '					<table id="gridIconPreview"></table>';
		cHtml += '				</div>';
		cHtml += '			</div>';
		cHtml += '		</div>';
		cHtml += '	</div>';
		cHtml += '</div>';
		$('#' + winId).dialog({
			width: 800,
			height: 500,
			modal: true,
			title: 'ҩƷͼ��Ԥ��',
			iconCls: 'icon-w-find',
			content: cHtml,
			closable: true,
			onClose: function () {}
		});
		// ��ʼ�����
		InitGridIconPreview({
			gridId: 'gridIconPreview',
			gridBarId: 'gridIconPreviewBar',
			gridType: 'datagrid'
		});
	}
	$('#gridIconPreview').datagrid('clear');
	$('#txtgridIconPreviewBar').val('');
	$('#' + winId).dialog('open');
}
function InitGridIconPreview(_tOpts) {
	InitGridBar(_tOpts);
	var columns = [[{
				field: 'TCode',
				title: 'TCode',
				width: 120,
				hidden: true
			}, {
				field: 'TName',
				title: 'TName',
				width: 120,
				hidden: true
			}, {
				field: 'RowId',
				title: 'RowId',
				width: 80,
				hidden: true
			}, {
				field: 'drugIcon',
				title: 'ͼ��',
				width: 200,
				formatter: PHA_COM.Drug.Icon
			}, {
				field: 'Description',
				title: '����',
				width: 600,
				styler: PHA_COM.Drug.Color
			}, {
				field: 'Code',
				title: '����',
				width: 200
			}, {
				field: 'Spec',
				title: '���',
				width: 200
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.IN.DrugIcon.Query',
			QueryName: 'INCItm',
			hospId: session['LOGON.HOSPID']
		},
		fitColumns: true,
		border: false,
		rownumbers: true,
		columns: columns,
		pagination: true,
		singleSelect: true,
		toolbar: '#' + _tOpts.gridBarId,
		onSelect: function (rowIndex, rowData) {},
		onLoadSuccess: function () {
			PHA_COM.Drug.Tips();
		}
	};
	PHA.Grid(_tOpts.gridId, dataGridOption);
	$('#' + _tOpts.gridId).datagrid('options').url = $URL;
}

// ����ֵ����
function SetTypeData(_data){
	$('#TName').val(_data.TName || "");
	$('#TCode').val(_data.TCode || "");
	$('#TValueDesc').val(_data.Description || "");
	$('#TValue').val(_data.RowId || "");
}
function GetTypeData(_data){
	return {
		TName: ($('#TName').val() || ""),
		TCode: ($('#TCode').val() || ""),
		TValueDesc: ($('#TValueDesc').val() || ""),
		TValue: ($('#TValue').val() || "")
	}
}
function ClearTypeData(){
	$('#TValueDesc').val("");
	$('#TValue').val("");
}
