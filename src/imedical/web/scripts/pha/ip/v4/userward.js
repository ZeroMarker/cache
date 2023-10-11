/**
 * ����:	 סԺ�ƶ�ҩ��-�û���������
 * ��д��:	 yunhaibao
 * ��д����: 2020-08-25
 */

$(function () {
	InitGridWardLoc();
	InitGridUser();
	PHA.SearchBox('conUserAlias', {
		width: 265,
		searcher: QueryUser,
		placeholder: '����������س���ѯ...'
	});
	$('#conWardAlias').on('keydown', function (e) {
		if (e.keyCode == 13) {
			QueryWardLoc();
		}
	});
	$('#btnFind').on('click', QueryWardLoc);
	$('#btnSave').on('click', Save);

	AddTips();
});
function InitGridUser() {
	var columns = [
		[{
				field: 'user',
				title: 'user',
				width: 125,
				hidden: true
			}, {
				field: 'userCode',
				title: '��Ա����',
				width: 100
			}, {
				field: 'userName',
				title: '��Ա����',
				width: 100
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IP.UserWard.Query',
			QueryName: 'SSUserData',
			pJsonStr: JSON.stringify({
				loc: session['LOGON.CTLOCID']
			})
		},
		fitColumns: true,
		toolbar: '#gridUserBar',
		columns: columns,
		pagination: false,
		onClickRow: function (rowIndex, rowData) {
			QueryWardLoc();
		},
		onLoadSuccess: function () {}
	};
	PHA.Grid('gridUser', dataGridOption);
}

function InitGridWardLoc() {
	var columns = [
		[{
				field: 'itmChk',
				checkbox: true
			}, {
				field: 'wardLoc',
				title: '����',
				width: 200,
				hidden: true
			}, {
				field: 'wardLocDesc',
				title: '����',
				width: 400
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IP.UserWard.Query',
			QueryName: 'WardLocData',
			rows: 9999,
			pJsonStr: "{}"
		},
		pagination: false,
		columns: columns,
		fitColumns: false,
		rownumbers: true,
		singleSelect: false,
		toolbar: '#gridWardLocBar',
		onRowContextMenu: function () {},
		onLoadSuccess: function (data) {
			$(this).datagrid('uncheckAll');
			var row0Data = data.rows[0];
			if (row0Data) {
				var rows = $(this).datagrid('getRows');
				var rowsLen = rows.length;
				for (var index = rowsLen - 1; index >= 0; index--) {
					var rowData = rows[index];
					var ipuw = rowData.ipuw;
					if (ipuw != '') {
						$(this).datagrid('checkRow', index);
					}
				}
			}
		}
	};
	PHA.Grid('gridWardLoc', dataGridOption);
}

function QueryUser() {
	var pJson = {
		alias: $('#conUserAlias').searchbox('getValue'),
		loc: session['LOGON.CTLOCID']
	};
	$('#gridUser').datagrid('query', {
		rows: 9999,
		pJsonStr: JSON.stringify(pJson)
	});
}
function QueryWardLoc() {
	var gridSelect = $('#gridUser').datagrid('getSelected');
	if (gridSelect === null) {
		PHA.Popover({
			msg: '����ѡ���û���',
			type: 'alert'
		});
		return;
	}
	var pJson = {
		alias: $('#conWardAlias').val(),
		loc: session['LOGON.CTLOCID'],
		user: gridSelect.user
	};
	$('#gridWardLoc').datagrid('query', {
		ClassName: 'PHA.IP.UserWard.Query',
		QueryName: 'WardLocData',
		rows: 9999,
		pJsonStr: JSON.stringify(pJson)
	});
}

function Save() {
	var gridSelect = $('#gridUser').datagrid('getSelected');
	if (gridSelect === null) {
		PHA.Popover({
			msg: '����ѡ���û���¼',
			type: 'alert',
			timeout: 1000
		});
		return;
	}
	var user = gridSelect.user;
	var loc = session['LOGON.CTLOCID'];

	var $grid = $('#gridWardLoc');
	var gridRows = $grid.datagrid('getRows');
	var gridChecked = $grid.datagrid('getChecked');
	var dataArr = [];
	for (var i = 0; i < gridRows.length; i++) {
		var chkFlag = '';
		var rowData = gridRows[i];
		if (gridChecked.indexOf(rowData) >= 0) {
			chkFlag = 'Y';
		} else {
			chkFlag = 'N';
		}
		var ipuw = rowData.ipuw;
		var wardLoc = rowData.wardLoc;
		var iJson = {
			user: user,
			loc: loc,
			ipuw: ipuw,
			wardLoc: wardLoc,
			chkFlag: chkFlag
		};
		dataArr.push(iJson);
	}
	var retJson = $.cm({
		ClassName: 'PHA.IP.Data.Api',
		MethodName: 'HandleInAll',
		pClassName: 'PHA.IP.UserWard.Save',
		pMethodName: 'SaveHandler',
		pJsonStr: JSON.stringify(dataArr)
	}, false);

	if (retJson.success === 'N') {
		PHA.Alert('��ʾ', PHAIP_COM.DataApi.Msg(retJson), 'warning');
	} else {
		PHA.Popover({
			msg: '����ɹ�!',
			type: 'success'
		});
	}
	$grid.datagrid('reload');
}

function AddTips() {
	$Tips = $('#panel-user').prev().find('.panel-tool').find('.icon-tip');
	$Tips.attr('title', '���޷���ѯ���û���<br/>���ȵ�������ҩ������-����ҩ����������-��ԱȨ�ޡ�<br/>����ӵ�ǰ��¼���ҵ�ҩ����Ա��');
	$Tips.tooltip({
		position: 'bottom'
	}).show();
}
