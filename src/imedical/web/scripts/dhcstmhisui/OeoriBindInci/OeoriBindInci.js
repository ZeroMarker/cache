/* ����շѹ���*/
var init = function() {
	var Clear = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(IOeoriMainGrid);
		$UI.clear(InciMainGrid);
		$UI.clear(IOeoriDetailGrid);
		// /���ó�ʼֵ ����ʹ������
		var DefaultData = {
			StartDate: new Date(),
			EndDate: new Date()
		};
		$UI.fillBlock('#FindConditions', DefaultData);
	};
	var FRecLocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	var FRecLocBox = $HUI.combobox('#LocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FRecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var OeorcatParams = JSON.stringify(addSessionParams());
	var OeorcatBox = $HUI.combobox('#oeorcat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrdSubCat&ResultSetType=array&Params=' + OeorcatParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#FindConditions');
			var Params = JSON.stringify(ParamsObj);
			var Select = IOeoriMainGrid.getSelected();
			if (isEmpty(Select.Oeori)) {
				$UI.msg('alert', '��ѡ����Ҫ�����ҽ����Ϣ!');
				return;
			}
			var Detail = IOeoriDetailGrid.getChangesData('inci');
			if (Detail === false) {	// δ��ɱ༭����ϸΪ��
				return;
			}
			if (isEmpty(Detail)) {	// ��ϸ����
				$UI.msg('alert', 'û����Ҫ�������ϸ!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.OeoriBindInci',
				MethodName: 'Save',
				Params: Params,
				Oeori: Select.Oeori,
				ListDetail: JSON.stringify(Detail)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					IOeoriDetailGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	$UI.linkbutton('#DelBT', {
		onClick: function() {
			var Row = IOeoriDetailGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ����Ҫɾ������ϸ!');
				return;
			}
			var orirowid = Row.orirowid;
			if (isEmpty(orirowid)) {
				IOeoriDetailGrid.commonDeleteRow();
			} else {
				var IngrFlag = Row.IngrFlag;
				if (IngrFlag == 'Y') {
					$UI.msg('alert', '��������ⵥ,������ɾ��!');
					return;
				}
				$.cm({
					ClassName: 'web.DHCSTMHUI.OeoriBindInci',
					MethodName: 'Delete',
					hvm: orirowid
				}, function(jsonData) {
					if (jsonData.success === 0) {
						$UI.msg('success', jsonData.msg);
						IOeoriDetailGrid.reload();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}
	});

	$('#BarCode').bind('keypress', function(event) {
		if (event.keyCode == '13') {
			Query();
		}
	});
	$('#PapmiNo').bind('keypress', function(event) {
		if (event.keyCode == '13') {
			var PapmiNo = $(this).val();
			if (PapmiNo == '') {
				$UI.msg('alert', '������ǼǺ�!');
				return;
			}
			var patinfostr = tkMakeServerCall('web.DHCSTMHUI.HVMatOrdItm', 'Pa', PapmiNo);
			var patinfoarr = patinfostr.split('^');
			var newPaAdmNo = patinfoarr[0];
			var patinfo = patinfoarr[1] + ',' + patinfoarr[2];
			$('#PapmiNo').val(newPaAdmNo);
		}
	});
	var OeoriMainCm = [[
		{
			title: 'Oeori',
			field: 'Oeori',
			width: 100,
			hidden: true
		}, {
			title: 'ҽ�������',
			field: 'ArcimCode',
			width: 120
		}, {
			title: 'ҽ��������',
			field: 'ArcimDesc',
			width: 150
		}, {
			title: '���ߵǼǺ�',
			field: 'PaAdmNo',
			width: 150
		}, {
			title: '��������',
			field: 'PaAdmName',
			width: 200
		}, {
			title: '���տ���id',
			field: 'RecLoc',
			width: 200,
			hidden: true
		}, {
			title: '���տ���',
			field: 'RecLocDesc',
			width: 70
		}, {
			title: 'ҽ������',
			field: 'OeoriDate',
			width: 90,
			hidden: true
		}, {
			title: 'ҽ��¼����',
			field: 'UserAddName',
			width: 70
		}, {
			title: '����',
			field: 'BarCode',
			width: 450
		}, {
			title: 'Inci',
			field: 'Inci',
			width: 70,
			hidden: 'true'
		}
	]];
	var IOeoriMainGrid = $UI.datagrid('#IOeoriMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.OeoriBindBarcode',
			QueryName: 'QueryOeori',
			query2JsonStrict: 1
		},
		columns: OeoriMainCm,
		showBar: false,
		onSelect: function(index, row) {
			var Params = JSON.stringify({ Oeori: row.Oeori });
			IOeoriDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.OeoriBindInci',
				QueryName: 'QueryItem',
				query2JsonStrict: 1,
				Params: Params
			});
			InciMainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
				QueryName: 'GetDetail',
				query2JsonStrict: 1,
				Pack: row.Inci
			});
		},
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	var InciMainCm = [[
		{
			title: 'PCL',
			field: 'PCL',
			width: 100,
			hidden: true
		}, {
			title: 'Inci',
			field: 'Inci',
			width: 120,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 150
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 150
		}, {
			title: '���',
			field: 'Spec',
			width: 200
		}, {
			title: '����',
			field: 'PbRp',
			width: 200
		}
	]];
	var InciMainGrid = $UI.datagrid('#InciMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
			QueryName: 'GetDetail',
			query2JsonStrict: 1
		},
		columns: InciMainCm,
		showBar: false,
		onDblClickRow: function(index, row) {
			var inci = row.Inci;
			var incicode = row.InciCode;
			var incidesc = row.InciDesc;
			var qty = 1;
			var record = {
				inci: inci,
				desc: incidesc,
				qty: 1,
				code: incicode
				
			};
			IOeoriDetailGrid.appendRow(record);
		}
	});
	var OeoriDetailCm = [[
		{
			title: 'orirowid',
			field: 'orirowid',
			width: 100,
			hidden: true
		}, {
			title: 'oeori',
			field: 'oeori',
			width: 80,
			hidden: true
		}, {
			title: 'inci',
			field: 'inci',
			width: 80,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'code',
			width: 80
		}, {
			title: '��������',
			field: 'desc',
			width: 80
		}, {
			title: '����',
			field: 'qty',
			width: 80
		}, {
			title: '��λ',
			field: 'uomdesc',
			width: 80
		}, {
			title: '����',
			field: 'batno',
			width: 200,
			editor: {
				type: 'text'
			}
		}, {
			title: 'Ч��',
			field: 'expdate',
			width: 100,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '�Դ���',
			field: 'originalcode',
			width: 200,
			editor: {
				type: 'text'
			}
		}, {
			title: '���',
			field: 'specdesc',
			width: 80
		}, {
			title: 'dhcit',
			field: 'dhcit',
			width: 80,
			hidden: 'true'
		}, {
			title: '��ֵ����',
			field: 'barcode',
			width: 180
		}, {
			title: '��¼���',
			field: 'IngrFlag',
			width: 80
		}, {
			title: '����',
			field: 'rp',
			width: 80
		}, {
			title: '�ۼ�',
			field: 'sp',
			width: 80
		}, {
			title: '��Ʊ���',
			field: 'invamt',
			width: 80
		}, {
			title: '��Ʊ��',
			field: 'invno',
			width: 80
		}, {
			title: '��Ʊ����',
			field: 'invdate',
			width: 80
		}, {
			title: '����״̬',
			field: 'feestatus',
			width: 80
		}, {
			title: '�����ܶ�',
			field: 'feeamt',
			width: 80
		}, {
			title: '��������',
			field: 'dateofmanu',
			width: 80
		}, {
			title: '��Ӧ��',
			field: 'vendor',
			width: 80
		}, {
			title: '��������',
			field: 'manf',
			width: 80
		}
		
	]];
	
	var IOeoriDetailGrid = $UI.datagrid('#IOeoriDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.OeoriBindInci',
			QueryName: 'QueryItem',
			query2JsonStrict: 1
		},
		columns: OeoriDetailCm,
		pagination: false,
		showBar: false,
		toolbar: '#OeoriTB',
		onClickRow: function(index, row) {
			IOeoriDetailGrid.commonClickRow(index, row);
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('#FindConditions');
		ParamsObj.packFlag = 'Y';
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
		$UI.clear(IOeoriMainGrid);
		$UI.clear(IOeoriDetailGrid);
		$UI.clear(InciMainGrid);
		IOeoriMainGrid.load({
			ClassName: 'web.DHCSTMHUI.OeoriBindBarcode',
			QueryName: 'QueryOeori',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	Clear();
	Query();
};
$(init);