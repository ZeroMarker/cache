/* ��ֵ����*/
var init = function() {
	var Clear = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(BarMainGrid);
		$UI.clear(BarDetailGrid);
		// /���ó�ʼֵ ����ʹ������
		var DefaultData = {
			StartDate: TrackDefaultStDate(),
			EndDate: TrackDefaultEdDate(),
			FRecLoc: gLocObj,
			AuditFlag: 'N',
			FStatusBox: 'Y'
		};
		$UI.fillBlock('#FindConditions', DefaultData);
	};
	var FRecLocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	var FRecLocBox = $HUI.combobox('#LocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FRecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var VendorBoxParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	$HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorBoxParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	$('#Status').simplecombobox({
		data: [
			{ RowId: 'Reg', Description: 'ע��' },
			{ RowId: 'Enable', Description: '����' },
			{ RowId: 'Used', Description: '����' },
			{ RowId: 'Else', Description: '����' }
		]
	});
	$('#wardno').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			var PapmiNo = $(this).val();
			if (isEmpty(PapmiNo)) {
				$UI.msg('alert', '������ǼǺ�!');
				return false;
			}
			try {
				var patinfostr = tkMakeServerCall('web.DHCSTMHUI.HVMatOrdItm', 'Pa', PapmiNo);
				var patinfoarr = patinfostr.split('^');
				var newPaAdmNo = patinfoarr[0];
				var patinfo = patinfoarr[1] + ',' + patinfoarr[2];
				$('#wardno').val(newPaAdmNo);
			} catch (e) {}
		}
	});
	$('#BarCode').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			var BarCode = $(this).val();
			if (isEmpty(BarCode)) {
				$UI.msg('alert', '������������Ϣ!');
				return false;
			}
			Query();
		}
	});
	$('#OrgianlBarCode').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			var OrgianlBarCode = $(this).val();
			if (isEmpty(OrgianlBarCode)) {
				$UI.msg('alert', '������������Ϣ!');
				return false;
			}
			Query();
		}
	});
	var HandlerParams = function() {
		var Obj = { Hv: 'Y', StkGrpType: 'M' };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#InciId'));
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('#FindConditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
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
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(BarDetailGrid);
		$UI.clear(BarMainGrid);
		BarMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'Query',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	// ��ӡ��ť��Ӧ����
	var PrintBtn = $('#Print').menubutton({ menu: '#mm-Print' });
	$(PrintBtn.menubutton('options').menu).menu({
		onClick: function(item) {
			var BtnName = item.name;		// div������name����
			if (BtnName == 'PrintBarCode') {
				var rowsData = BarMainGrid.getSelections();
				if (rowsData.length <= 0) {
					$UI.msg('alert', 'û��Ҫ��ӡ�ĸ�ֵ����!');
					return;
				}
				var count = rowsData.length;
				for (var rowIndex = 0; rowIndex < count; rowIndex++) {
					var row = rowsData[rowIndex];
					var BarCode = row.BarCode;
					PrintBarcode(BarCode, 1);
				}
			} else if (BtnName == 'PrintBarCode2') {
				var rowsData = BarMainGrid.getSelections();
				if (rowsData.length <= 0) {
					$UI.msg('alert', 'û��Ҫ��ӡ�ĸ�ֵ����!');
					return;
				}
				var count = rowsData.length;
				for (var rowIndex = 0; rowIndex < count; rowIndex++) {
					var row = rowsData[rowIndex];
					var BarCode = row.BarCode;
					PrintBarcode(BarCode, 2);
				}
			} else if (BtnName == 'PrintPage') {
				var rowsData = BarMainGrid.getRows();
				if (rowsData.length <= 0) {
					$UI.msg('alert', 'û��Ҫ��ӡ�ĸ�ֵ����!');
					return;
				}
				var count = rowsData.length;
				for (var rowIndex = 0; rowIndex < count; rowIndex++) {
					var row = rowsData[rowIndex];
					var BarCode = row.BarCode;
					PrintBarcode(BarCode, 1);
				}
			} else if (BtnName == 'PrintPage2') {
				var rowsData = BarMainGrid.getRows();
				if (rowsData.length <= 0) {
					$UI.msg('alert', 'û��Ҫ��ӡ�ĸ�ֵ����!');
					return;
				}
				var count = rowsData.length;
				for (var rowIndex = 0; rowIndex < count; rowIndex++) {
					var row = rowsData[rowIndex];
					var BarCode = row.BarCode;
					PrintBarcode(BarCode, 2);
				}
			}
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var rowsData = BarMainGrid.getSelections();
			if (isEmpty(rowsData)) {
				$UI.msg('alert', '��ѡ����Ҫ��ӡ�ĸ�ֵ��Ϣ!');
				return;
			}
			for (var i = 0, Len = rowsData.length; i < Len; i++) {
				var row = rowsData[i];
				var TrackId = row['RowId'];
				var RaqName = 'DHCSTM_HUI_ItmTrack_Common.raq';
				var HospDesc = session['LOGON.HOSPDESC'];
				var fileName = '{' + RaqName + '(TrackId=' + TrackId + ';HospDesc=' + HospDesc + ')}';
				if (ItmTrackParamObj.IndirPrint != 'N') {
					var transfileName = TranslateRQStr(fileName);
					DHCCPM_RQPrint(transfileName);
				} else {
					DHCCPM_RQDirectPrint(fileName);
				}
			}
		}
	});
	
	var BarMainCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: 'InciId',
			field: 'InciId',
			width: 120,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 100
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 150
		}, {
			title: '���',
			field: 'Spec',
			width: 90
		}, {
			title: '������',
			field: 'SpecDesc',
			width: 120,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '����',
			field: 'BarCode',
			width: 200
		}, {
			title: '�Դ�����',
			field: 'OriginalCode',
			width: 200,
			hidden: hiddenOrigiBarCode
		}, {
			title: '����~Ч��',
			field: 'BatExp',
			width: 150,
			hidden: true
		}, {
			title: '����',
			field: 'BatNo',
			width: 100
		}, {
			title: 'Ч��',
			field: 'ExpDate',
			width: 100
		}, {
			title: '����',
			field: 'Rp',
			width: 60
		}, {
			title: '״̬',
			field: 'Status',
			formatter: StatusFormatter,
			width: 70
		}, {
			title: '��ǰλ��',
			field: 'CurrentLoc',
			width: 150
		}, {
			title: '��ӡ���',
			field: 'PrintFlag',
			formatter: BoolFormatter,
			align: 'center',
			width: 80
		}, {
			title: 'Incib',
			field: 'Incib',
			width: 90,
			hidden: true
		}, {
			title: 'Inclb',
			field: 'Inclb',
			width: 100,
			hidden: true
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 80
		}, {
			title: '��Ӧ��',
			field: 'VendorDesc',
			width: 160
		}, {
			title: '��������',
			field: 'ManfDesc',
			width: 160
		}, {
			title: '��������(ע��)ʱ��',
			field: 'DateTime',
			width: 160
		}, {
			title: '������',
			field: 'DhcitUser',
			width: 100
		}, {
			title: '�Դ�������',
			field: 'BatchCode',
			width: 200
		}, {
			title: '������Ϣ',
			field: 'UsedPatInfo',
			width: 160
		}, {
			title: 'ʹ��ʱ��',
			field: 'UsedDateTime',
			width: 160
		}
	]];
	var BarMainGrid = $UI.datagrid('#BarMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'Query',
			query2JsonStrict: 1
		},
		columns: BarMainCm,
		showBar: true,
		checkOnSelect: false,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				BarMainGrid.selectRow(0);
			}
		},
		onSelect: function(index, row) {
			BarDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCItmTrack',
				QueryName: 'QueryItmTrackItem',
				query2JsonStrict: 1,
				Parref: row['RowId'],
				rows: 99999
			});
		},
		onDblClickRow: function(index, row) {
			var RowId = row['RowId'];
			if (isEmpty(RowId)) {
				return;
			}
			var BarCode = row['BarCode'];
			var InciDesc = row['InciDesc'];
			var InfoStr = BarCode + ' : ' + InciDesc;
			BarCodePackItm(RowId, InfoStr);
		}
	});
	
	var BarDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '����',
			field: 'Type',
			formatter: TypeRenderer,
			width: 120
		}, {
			title: 'Pointer',
			field: 'Pointer',
			width: 80,
			hidden: true
		}, {
			title: '̨�˱��',
			field: 'IntrFlag',
			formatter: BoolFormatter,
			align: 'center',
			width: 80
		}, {
			title: '̨������',
			field: 'IntrQty',
			align: 'right',
			width: 80
		}, {
			title: '�����',
			field: 'OperNo',
			width: 150
		}, {
			title: 'ҵ��������',
			field: 'Date',
			hidden: true,
			width: 120
		}, {
			title: 'ҵ����ʱ��',
			field: 'Time',
			formatter: function(value, row, index) {
				return row['Date'] + ' ' + value;
			},
			width: 160
		}, {
			title: 'ҵ�������',
			field: 'User',
			width: 80
		}, {
			title: 'λ����Ϣ',
			field: 'OperOrg',
			width: 300
		}
	]];
	
	var BarDetailGrid = $UI.datagrid('#BarDetailGrid', {
		height: gGridHeight,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'QueryItmTrackItem',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: BarDetailCm,
		showBar: true,
		fitColumns: true
	});
	
	Clear();
};
$(init);