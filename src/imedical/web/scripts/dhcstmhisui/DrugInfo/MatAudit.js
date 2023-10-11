/*
������Ϣ���
*/
var init = function() {
	var AllowAuditObj = $.cm({
		ClassName: 'web.DHCSTMHUI.InciParamRecord',
		MethodName: 'GetAuditFlagStr'
	}, false);
	// �س��¼�
	$('#Conditions').bind('keydown', function(e) {
		var theEvent = e || window.event;
		var code = theEvent.keyCode || theEvent.which || theEvent.charCode;
		if (code == 13) {
			QueryAuditInfo();
		}
	});
	
	$('#QueryBT').on('click', QueryAuditInfo);
	$('#ClearBT').on('click', ClearAuditInfo);
	
	var StkCatBox = $HUI.combobox('#StkCatBox', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			var scg = $('#StkGrpBox').combotree('getValue');
			var Params = JSON.stringify(addSessionParams());
			StkCatBox.clear();
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId=' + scg + '&Params=' + Params;
			StkCatBox.reload(url);
		}
	});

	/* var VendorBox = $HUI.combobox('#VendorBox', {
			valueField: 'RowId',
			textField: 'Description',
			onShowPanel : function () {
				VendorBox.clear();
				var VendorParams=JSON.stringify(addSessionParams({APCType:"M",ScgId:""}));
				var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams;
				VendorBox.reload(url);
			}
		});

	var ManfBox = $HUI.combobox('#ManfBox', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel : function () {
			ManfBox.clear();
			var ManfParams = JSON.stringify(addSessionParams({
				StkType: "M"
			}));
			var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + ManfParams;
			ManfBox.reload(url);
		}
	});*/
	var HandlerParams = function() {
		var Scg = $('#StkGrpBox').combotree('getValue');
		var Obj = { StkGrpRowId: Scg, StkGrpType: 'M', BDPHospital: gHospId };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	var MatAuditCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			sortable: true,
			width: 100,
			hidden: true
		}, {
			title: 'ChangeTypeid',
			field: 'ChangeTypeid',
			sortable: true,
			width: 100,
			hidden: true
		}, {
			title: '��¼',
			field: 'ChangeType',
			sortable: true,
			width: 100
		}, {
			title: '�ܾ�����',
			field: 'RefuseReason',
			width: 80,
			editor: { type: 'text', options: {}}
		}, {
			title: '���״̬',
			field: 'LastDWALFlag',
			sortable: true,
			width: 100
		}, {
			title: '����������',
			field: 'LastDWALDate',
			sortable: true,
			width: 100
		}, {
			title: '������ʱ��',
			field: 'LastDWALTime',
			sortable: true,
			width: 100
		}, {
			title: '��������',
			field: 'LastDWALUser',
			sortable: true,
			width: 100
		}, {
			title: '�����id',
			field: 'Incid',
			width: 100,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'AudIncicode',
			sortable: true,
			width: 100
		}, {
			title: '��������',
			field: 'AudIncidesc',
			width: 150
		}, {
			title: '���',
			field: 'AudSpec',
			width: 100,
			hidden: (AllowAuditObj['INFOSpec'] == 'Y' ? false : true)
		}, {
			title: '�ͺ�',
			field: 'Model',
			width: 100,
			hidden: (AllowAuditObj['INFOModel'] == 'Y' ? false : true)
		}, {
			title: 'Ʒ��',
			field: 'Brand',
			width: 100,
			hidden: (AllowAuditObj['INFOBrand'] == 'Y' ? false : true)
		}, {
			title: '��������',
			width: 150,
			field: 'Manf',
			hidden: (AllowAuditObj['INFOPHMNFDR'] == 'Y' ? false : true)
		}, {
			title: '����',
			width: 100,
			field: 'Origin',
			hidden: (AllowAuditObj['INFOOrigin'] == 'Y' ? false : true)
		}, {
			title: '��ⵥλ',
			width: 80,
			field: 'AudPuom',
			hidden: (AllowAuditObj['INCICTUOMPurchDR'] == 'Y' ? false : true)
		}, {
			title: '������λ',
			width: 80,
			field: 'AudBaseUOM',
			hidden: (AllowAuditObj['INCICTUOMDR'] == 'Y' ? false : true)
		}, {
			title: '������',
			width: 100,
			field: 'AudIncsc',
			hidden: (AllowAuditObj['INCIINCSCDR'] == 'Y' ? false : true)
		}, {
			title: '������',
			width: 60,
			field: 'AudNotUseFlag',
			formatter: BoolFormatter,
			hidden: (AllowAuditObj['INFONotUseReasonDr'] == 'Y' ? false : true)
		}, {
			title: '��Ӧ��rowid',
			field: 'VendorId',
			width: 100,
			hidden: true
		}, {
			title: '��Ӧ��',
			width: 150,
			field: 'VendorName',
			hidden: (AllowAuditObj['INFOPbVendorDR'] == 'Y' ? false : true)
		}, {
			title: 'ע��֤��',
			width: 100,
			field: 'RegisterNo',
			hidden: (AllowAuditObj['IRRegCertNo'] == 'Y' ? false : true)
		}, {
			title: 'ע��֤Ч��',
			width: 100,
			field: 'RegisterNoExpDate',
			hidden: (AllowAuditObj['IRRegCertExpDate'] == 'Y' ? false : true)
		}, {
			title: 'ע��֤����',
			width: 100,
			field: 'RegItmDesc',
			hidden: true
		}, {
			title: '��ֵ��־',
			field: 'HighPrice',
			width: 80,
			align: 'center',
			formatter: BoolFormatter,
			hidden: (AllowAuditObj['INFOHighPrice'] == 'Y' ? false : true)
		}, {
			title: 'ֲ���־',
			field: 'Implantation',
			width: 80,
			align: 'center',
			formatter: BoolFormatter,
			hidden: (AllowAuditObj['INFOImplantationMat'] == 'Y' ? false : true)
		}
	]];

	var MatAuditGrid = $UI.datagrid('#MatAuditGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.MatAudit',
			QueryName: 'GetMatAuditInfo',
			query2JsonStrict: 1
		},
		columns: MatAuditCm,
		remoteSort: true,
		showBar: true,
		singleSelect: false,
		onClickRow: function(index, row) {
			MatAuditGrid.commonClickRow(index, row);
		},
		onBeforeEdit: function(index, row) {
			if (row.ChangeTypeid == 0) {
				$UI.msg('alert', '�����޸ļ�¼����д�ܾ����ɣ�');
				return false;
			}
		},
		onLoadSuccess: function(data) {
			$.each(data.rows, function(index, row) {
				var LastDWALDate = row['LastDWALDate'];
				var ChangeTypeid = row['ChangeTypeid'];
				if (ChangeTypeid == 0) {
					$("input[type='checkbox']")[index + 1].hidden = true;
				}
				if ((ChangeTypeid == 2) && (isEmpty(LastDWALDate))) {
					SetGridBgColor(MatAuditGrid, index, 'RowId', 'red');
				}
				if ((ChangeTypeid == 1) && (isEmpty(LastDWALDate))) {
					SetGridBgColor(MatAuditGrid, index, 'RowId', 'yellow');
				}
				if (!isEmpty(LastDWALDate)) {
					SetGridBgColor(MatAuditGrid, index, 'RowId', 'green');
				}
			});
		}
	});

	function QueryAuditInfo() {
		var SessionParmas = addSessionParams();
		var Paramsobj = $UI.loopBlock('Conditions');
		var StartDate = Paramsobj.StartDate;
		var EndDate = Paramsobj.EndDate;
		if (isEmpty(StartDate)) {
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		if (compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���С�ڿ�ʼ����!');
			return;
		}
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		$UI.clear(MatAuditGrid);
		MatAuditGrid.load({
			ClassName: 'web.DHCSTMHUI.MatAudit',
			QueryName: 'GetMatAuditInfo',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	// ���
	$UI.linkbutton('#AuditYesBT', {
		onClick: function() {
			MatAudit();
		}
	});
	function MatAudit() {
		var RowsData = MatAuditGrid.getChecked();
		var RowIdStr = '';
		for (var i = 0; i < RowsData.length; i++) {
			var RowId = RowsData[i].RowId;
			var Incid = RowsData[i].Incid;
			var ChangeTypeid = RowsData[i].ChangeTypeid;
			if (ChangeTypeid == 0) {
				continue;
			}
			if (RowIdStr == '') { RowIdStr = Incid + '@' + RowId; } else { RowIdStr = RowIdStr + '^' + Incid + '@' + RowId; }
		}
		if (RowIdStr == '') {
			$UI.msg('alert', '��ѡ����Ҫ��˵ļ�¼��');
			return false;
		}
		var Params = JSON.stringify(addSessionParams({ RowIdStr: RowIdStr }));
		
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.MatAudit',
			MethodName: 'jsAudit',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				QueryAuditInfo();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	// �ܾ�
	$UI.linkbutton('#AuditNoBT', {
		onClick: function() {
			MatAuditNo();
		}
	});
	function MatAuditNo() {
		if (!MatAuditGrid.endEditing()) {
			return;
		}
		var RowsData = MatAuditGrid.getChecked();
		var RowIdStr = '';
		var refusecount = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var ChangeTypeid = RowsData[i].ChangeTypeid;
			var RefuseReason = RowsData[i].RefuseReason;
			if (ChangeTypeid == 0) {
				continue;
			}
			if ((ChangeTypeid == 2) && (isEmpty(RefuseReason))) {
				refusecount = refusecount + 1;
			}
			if ((ChangeTypeid == 1) && (isEmpty(RefuseReason))) {
				refusecount = refusecount + 1;
			}
			var RowId = RowsData[i].RowId;
			var Incid = RowsData[i].Incid;
			if (RowIdStr == '') { RowIdStr = Incid + '@' + RowId + '@' + RefuseReason; } else { RowIdStr = RowIdStr + '^' + Incid + '@' + RowId + '@' + RefuseReason; }
		}
		if (RowIdStr == '') {
			$UI.msg('alert', '��ѡ����Ҫ����ļ�¼��');
			return false;
		}
		if (refusecount > 0) {
			$UI.msg('alert', '���� �޸� ���� ���� �ļ�¼�ľܾ����ɿ�����д����,û�еĻ�����д�ޣ�');
			return false;
		}
		var Params = JSON.stringify(addSessionParams({ RowIdStr: RowIdStr }));
		
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.MatAudit',
			MethodName: 'jsAuditNo',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				QueryAuditInfo();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function ClearAuditInfo() {
		$UI.clearBlock('Conditions');
		$UI.clear(MatAuditGrid);
		var DefaultData = {
			AuditFlag: 'N',
			TypeFlag: ''
		};
		$UI.fillBlock('#Conditions', DefaultData);
		$('#StkGrpBox').combotree('options')['setDefaultFun']();
	}
	ClearAuditInfo();
};
$(init);