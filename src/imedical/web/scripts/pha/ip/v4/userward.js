/**
 * 名称:	 住院移动药房-用户关联病区
 * 编写人:	 yunhaibao
 * 编写日期: 2020-08-25
 */

$(function () {
	InitGridWardLoc();
	InitGridUser();
	PHA.SearchBox('conUserAlias', {
		width: 265,
		searcher: QueryUser,
		placeholder: '请输入别名回车查询...'
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
				title: '人员工号',
				width: 100
			}, {
				field: 'userName',
				title: '人员姓名',
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
				title: '病区',
				width: 200,
				hidden: true
			}, {
				field: 'wardLocDesc',
				title: '病区',
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
			msg: '请先选择用户！',
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
			msg: '请先选中用户记录',
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
		PHA.Alert('提示', PHAIP_COM.DataApi.Msg(retJson), 'warning');
	} else {
		PHA.Popover({
			msg: '保存成功!',
			type: 'success'
		});
	}
	$grid.datagrid('reload');
}

function AddTips() {
	$Tips = $('#panel-user').prev().find('.panel-tool').find('.icon-tip');
	$Tips.attr('title', '若无法查询到用户，<br/>请先到【门诊药房配置-门诊药房科室配置-人员权限】<br/>中添加当前登录科室的药房人员。');
	$Tips.tooltip({
		position: 'bottom'
	}).show();
}
