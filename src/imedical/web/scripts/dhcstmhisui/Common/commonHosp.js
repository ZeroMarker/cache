var hospAutFlag = tkMakeServerCall('web.DHCSTMHUI.MatForBDPData', 'GetHospAutFlag');
// �ǹ���tablename�ش����ܿ�tablename��datagrid����
function InitHospCombo(tablename, session, datagrid, callback) {
	var genObj = '';
	var tableType = tkMakeServerCall('web.DHCSTMHUI.MatForBDPData', 'GetTableType', tablename); // 20200514���ӱ������ж�
	if ((tableType != 'G') && (hospAutFlag === 'Y')) {
		if (tablename == '') {
			$UI.msg('alert', '����ϵ������Աά��Ժ������');
			return false;
		}
		var setHospBtnCss = 'display:none';
		if (tableType == 'C') {
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
			'<div id="hospconditions" style="padding-left:5px;padding-top:10px;">'
				+ '<table>'
					+ '<tr>'
						+ '<td><label id="_HospListLabel" style="padding-right:10px;">ҽԺ</label></td>'
						+ '<td><input id="_HospList" class="hisui-combobox"></td>'
						+ '<td><a href="#" id="_HospBtn" class="hisui-linkbutton" style="' + setHospBtnCss + '">���ݹ���ҽԺ</a></td>'
					+ '</tr>'
				+ '</table>'
			+ '</div>'
		});
		try {
			genObj = GenHospComp(tablename, session);
			if (tableType == 'C') {
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
function InitHospResize() {
	var c = $('body');
	var pc = $('body').layout('panel', 'center');
	var cheight = pc.panel('panel').outerHeight();
	pc.panel('resize', { height: cheight - 45 });
	var pe = $('body').layout('panel', 'east');
	if (pe[0]) {
		var eheight = pe.panel('panel').outerHeight();
		pe.panel('resize', { height: eheight - 45 });
	}
	var pw = $('body').layout('panel', 'west');
	if (pw[0]) {
		var wheight = pw.panel('panel').outerHeight();
		pw.panel('resize', { height: wheight - 45 });
	}
	c.layout('resize');
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
			if (rowData === null) {
				$UI.msg('alert', '��ѡ����Ҫ��Ȩ�ļ�¼��');
				return false;
			}
			InitHospWin(tablename, rowData.RowId, callback, { singleSelect: false });
		};
	} catch (e) {}
}
function InitHospWin(objectName, objectId, callback, opt) {
	if ($('#_HospListWin').length == 0) {
		$('<div id="_HospListWin" />').prependTo('body');
	}
	var singleSelect = false;
	if (opt) {
		singleSelect = opt.singleSelect || false;
	}
	var gridObj = '';
	var obj = $HUI.dialog('#_HospListWin', {
		width: 550,
		modal: true,
		height: 350,
		title: 'ҽԺȨ�޷���',
		content: '<table id="_HospListGrid"></table>',
		buttons: [{
			text: 'ȷ��',
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
				// ����ҽԺ����
				var ret = '';
				if (objectName == 'INC_Itm') {
					ret = tkMakeServerCall('web.DHCSTMHUI.AuthorBasicInfoHosp', '', objectId, HospIDs);
				} else {
					ret = tkMakeServerCall('web.DHCBL.BDP.BDPMappingHOSP', 'UpdateHOSP', objectName, objectId, HospIDs);
				}
				var retcode = ret.split('^')[0];
				var retmsg = ret.split('^')[1];
				if (retcode < 0) {
					$UI.msg('error', retmsg);
				} else {
					$UI.msg('success', '�����ɹ���');
				}
				
				if ('function' === typeof callback) callback(); // //callback(checkRow);
				$HUI.dialog('#_HospListWin').close();
			}
		}, {
			text: 'ȡ��',
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
					{ field: 'LinkFlag', title: '��Ȩ���', align: 'center', width: 100, checkbox: true },
					{ field: 'HOSPRowId', title: 'HOSPRowId', align: 'left', hidden: true, width: 100 },
					{ field: 'HOSPDesc', title: 'ҽԺ����', align: 'left', width: 300 },
					{ field: 'MappingID', title: 'ObjectId', align: 'left', hidden: true, width: 100 }
				]],
				onLoadSuccess: function(row) {
					var rowData = row.rows;
					$.each(rowData, function(idx, val) {
						if (val.LinkFlag == 'Y') {
							$('#_HospListGrid').datagrid('selectRow', idx);
						}
					});
				}
			});
		}
	});
}