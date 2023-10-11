var hospAutFlag = tkMakeServerCall('web.CSSDHUI.HospMap', 'GetHospAutFlag');
// 非公有tablename必传，管控tablename和datagrid必填
function InitHospCombo(tablename, session, datagrid, callback) {
	var genObj = '';
	var tableType = tkMakeServerCall('web.CSSDHUI.HospMap', 'GetTableType', tablename); // 20200514增加表类型判断
	if ((tableType !== 'G') && (hospAutFlag === 'Y')) {
		if (tablename === '') {
			$UI.msg('alert', '请联系开发人员维护院区功能');
			return false;
		}
		var setHospBtnCss = 'display:none';
		if (tableType === 'C') {
			setHospBtnCss = 'display:block';
			if (isEmpty(datagrid)) {
				setHospBtnCss = 'display:none';
			}
		}
		$($('.hisui-layout')[0]).layout('add', {
			region: 'north',
			border: false,
			height: 45,
			split: false,
			content:
			'<div id="hospconditions" style="padding-left:5px;padding-top:10px;">' +
				'<table>' +
					'<tr>' +
						'<td><label id="_HospListLabel" style="padding-right:10px;">医院</label></td>' +
						'<td><input id="_HospList" class="hisui-combobox"></td>' +
						'<td><a href="#" id="_HospBtn" class="hisui-linkbutton" style="' + setHospBtnCss + '">数据关联医院</a></td>' +
					'</tr>' +
				'</table>' +
			'</div>'
		});
		try {
			genObj = GenHospComp(tablename, session);
			if (tableType === 'C') {
				InitHospButton(datagrid, tablename, callback);
			}
		} catch (e) {}
	} else {
		if ($('#hospconditions').length) {
			$('#_HospList').combobox('setValue', '');
			$HUI.combobox('#_HospList').disable();
			$('#_HospBtn').hide();
		}
	}
	return genObj;
}

function InitHospButton(datagrid, tablename, callback) {
	if (isEmpty(datagrid)) { return; }
	try {
		var btnObj = GenHospWinButton(tablename);
		if (!btnObj) {
			return;
		}
		btnObj.options().onClick = function() {
			var rowData = datagrid.getSelected();
			if (rowData == null) {
				$UI.msg('alert', '请选择需要授权的记录！');
				return false;
			}
			InitHospWin(tablename, rowData.RowId, callback, { singleSelect: false });
		};
	} catch (e) {}
}
function InitHospWin(objectName, objectId, callback, opt) {
	if ($('#_HospListWin').length == 0) {
		$('<div id=\"_HospListWin\" />').prependTo('body');
	}
	var singleSelect = false;
	if (opt) {
		singleSelect = opt.singleSelect || false;
	}
	var gridObj = '';
	$HUI.dialog('#_HospListWin', {
		width: 550,
		modal: true,
		height: 350,
		title: '医院权限分配',
		content: '<table id="_HospListGrid"></table>',
		buttons: [{
			text: '确定',
			handler: function() {
				var HospIDs = '';
				var rows = gridObj.getData().rows;
				var checkRow = gridObj.getChecked();
				if (rows.length > 0) {
					for (var i = 0; i < rows.length; i++) {
						if ($.hisui.indexOfArray(checkRow, 'HOSPRowId', rows[i]['HOSPRowId']) == -1) {
							HospIDs += '^' + rows[i]['HOSPRowId'] + '$N';
						} else {
							HospIDs += '^' + rows[i]['HOSPRowId'] + '$Y';
						}
					}
				}
				// 保存医院关联
				var ret = tkMakeServerCall('web.DHCBL.BDP.BDPMappingHOSP', 'UpdateHOSP', objectName, objectId, HospIDs);
				var retcode = ret.split('^')[0];
				var retmsg = ret.split('^')[1];
				if (retcode < 0) {
					$UI.msg('error', retmsg);
				} else {
					$UI.msg('success', '关联成功！');
				}
				
				if ('function' === typeof callback) callback(); // //callback(checkRow);
				$HUI.dialog('#_HospListWin').close();
			}
		}, {
			text: '取消',
			handler: function() {
				$HUI.dialog('#_HospListWin').close();
			}
		}],
		onOpen: function() {
			gridObj = $HUI.datagrid('#_HospListGrid', {
				mode: 'remote',
				fit: true,
				border: false,
				pagination: false,
				showPageList: false,
				showRefresh: false,
				singleSelect: singleSelect,
				queryParams: { ClassName: 'web.DHCBL.BDP.BDPMappingHOSP', QueryName: 'GetHospDataForCloud', tablename: objectName, dataid: objectId },
				url: $URL,
				columns: [[
					{ field: 'LinkFlag', title: '授权情况', align: 'center', width: 100, checkbox: true },
					{ field: 'HOSPRowId', title: 'HOSPRowId', align: 'left', hidden: true, width: 100 },
					{ field: 'HOSPDesc', title: '医院名称', align: 'left', width: 300 },
					{ field: 'MappingID', title: 'ObjectId', align: 'left', hidden: true, width: 100 }
				]],
				onLoadSuccess: function(row) {
					var rowData = row.rows;
					$.each(rowData, function(idx, val) {
						if (val.LinkFlag === 'Y') {
							$('#_HospListGrid').datagrid('selectRow', idx);
						}
					});
				}
			});
		}
	});
}