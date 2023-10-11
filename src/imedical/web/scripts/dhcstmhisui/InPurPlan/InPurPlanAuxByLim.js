var init = function() {
	/* --��ť�¼�--*/
	$UI.linkbutton('#TipBT', {
		onClick: function() {
			$.messager.alert(
				'��ʾ��Ϣ',
				'<p>1.������׼ ���ڻ���� 1,�Ҳ�����׼ȡ�� ������Ϊ�գ�����ɹ���=������׼*N,N=M+R</p>'
				+ '<p>ע�⣺M=(��׼���-���ҿ��)/������׼��ȡ��������;</p>'
				+ '<p>((��׼���-���ҿ��)#������׼)/������׼ С�� ������׼ȡ������ʱ��R=0,����R=1,#����ȡ��.</p>'
				+ '<p>2.������׼ С�� 1,�򲹻���׼ȡ������Ϊ�գ�����ɹ���=��׼���-���ҿ��.</p>',
				'info').window({ width: 720, height: 172 });
		}
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			if (isEmpty(ParamsObj.PurLoc)) {
				$UI.msg('alert', '�ɹ����Ҳ���Ϊ��!');
				return;
			}
			var Fac = ParamsObj.RepLevFac;
			if (Fac < 0 || Fac > 1) {
				$UI.msg('alert', '��׼����ȡ������Ӧ����0-1֮�����!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			PurGrid.load({
				ClassName: 'web.DHCSTMHUI.INPurPlanAuxByLim',
				QueryName: 'QueryLocItmForPurch',
				query2JsonStrict: 1,
				Params: Params,
				rows: 99999
			});
		}
	});
	
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			Save();
		}
	});
	function Save() {
		if (savecheck() == true) {
			var MainObj = $UI.loopBlock('#MainConditions');
			var Main = JSON.stringify(MainObj);
			var DetailObj = PurGrid.getRowsData();
			if (DetailObj == '') {
				$UI.msg('alert', 'û����Ҫ�������ϸ!');
				return;
			}
			var Detail = JSON.stringify(DetailObj);
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.INPurPlan',
				MethodName: 'Save',
				Main: Main,
				Detail: Detail
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.clear(PurGrid);
					$UI.msg('success', jsonData.msg);
					var purId = jsonData.rowid;
					var UrlStr = 'dhcstmhui.inpurplan.csp?gPurId=' + purId;
					Common_AddTab('�ɹ�', UrlStr);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	}
	// ���ݼ��
	function savecheck() {
		var rowsData = PurGrid.getRows();
		for (var i = 0; i < rowsData.length; i++) {
			var row = rowsData[i];
			var InciId = row.InciId;
			var UomId = row.UomId;
			var Qty = row.Qty;
			if ((UomId == '') && (InciId != '')) {
				$UI.msg('alert', '��' + (i + 1) + '�е�λΪ��');
				return false;
			}
			if (InciId != '' && Qty < 0) {
				$UI.msg('alert', '��' + (i + 1) + '����������С��0');
				return false;
			}
		}
		return true;
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Default();
		}
	});
	
	/* --�󶨿ؼ�--*/
	var PurLocBox = $HUI.combobox('#PurLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PurLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#StkScg').setFilterByLoc(LocId);
		}
	});
	var UomCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			editable: false,
			onBeforeLoad: function(param) {
				var rows = PurGrid.getRows();
				var row = rows[PurGrid.editIndex];
				if (!isEmpty(row)) {
					param.Inci = row.InciId;
				}
			},
			onSelect: function(record) {
				var rows = PurGrid.getRows();
				var row = rows[PurGrid.editIndex];
				var seluom = record.RowId;
				var rp = row.Rp;
				var buom = row.BUomId;
				var confac = row.ConFac;
				var uom = row.UomId; // �ɵ�λ
				if (seluom != uom) {
					if (seluom != buom) {		// ԭ��λ�ǻ�����λ��Ŀǰѡ�������ⵥλ
						Rp = Number(rp).mul(confac);
					} else {					// Ŀǰѡ����ǻ�����λ��ԭ��λ����ⵥλ
						Rp = Number(rp).div(confac);
					}
				}
				PurGrid.updateRow({
					index: PurGrid.editIndex,
					row: {
						UomDesc: record.Description,
						UomId: record.RowId,
						Rp: Rp
					}
				});
				// $('#PurGrid').datagrid('refreshRow', PurGrid.editIndex);
				setTimeout(function() { PurGrid.refreshRow(); }, 0);
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	/* --Grid--*/
	var PurCm = [[
		{
			title: '����RowId',
			field: 'InciId',
			hidden: true,
			width: 60
		}, {
			title: '����',
			field: 'InciCode',
			width: 100
		}, {
			title: '����',
			field: 'InciDesc',
			width: 150
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '����ɹ���',
			field: 'PurQty',
			width: 100,
			align: 'right'
		}, {
			title: 'ʵ�ʲɹ���',
			field: 'Qty',
			width: 100,
			align: 'right',
			necessary: true,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			}
		}, {
			title: '��λ',
			field: 'UomId',
			width: 80,
			necessary: true,
			formatter: CommonFormatter(UomCombox, 'UomId', 'UomDesc'),
			editor: UomCombox
		}, {
			title: '��Ӧ��Id',
			field: 'VendorId',
			width: 80,
			hidden: true
		}, {
			title: '��Ӧ��',
			field: 'VendorDesc',
			width: 150
		}, {
			title: '��������Id',
			field: 'ManfId',
			width: 80,
			hidden: true
		}, {
			title: '��������',
			field: 'ManfDesc',
			width: 150
		}, {
			title: '����',
			field: 'Rp',
			width: 100,
			align: 'right'
		}, {
			title: '�ɹ����ҿ��',
			field: 'StkQty',
			width: 100,
			align: 'right'
		}, {
			title: '�������',
			field: 'MaxQty',
			width: 100,
			align: 'right'
		}, {
			title: '�������',
			field: 'MinQty',
			width: 100,
			align: 'right'
		}, {
			title: '��׼���',
			field: 'RepQty',
			width: 80,
			align: 'right'
		}, {
			title: '�ο����',
			field: 'LevelQty',
			width: 80,
			align: 'right'
		}, {
			title: '������׼',
			field: 'RepLev',
			width: 80,
			align: 'right'
		}, {
			title: '�����Id',
			field: 'CarrierId',
			width: 80,
			hidden: true
		}, {
			title: '�����',
			field: 'CarrierDesc',
			width: 80
		}, {
			title: '������Ϣ',
			field: 'ApcWarn',
			width: 80
		}, {
			title: '������λ',
			field: 'BUomId',
			width: 80,
			hidden: true
		}, {
			title: 'ת��ϵ��',
			field: 'ConFac',
			width: 80,
			hidden: true
		}
	]];
	
	var PurGrid = $UI.datagrid('#PurGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPurPlanAuxByLim',
			QueryName: 'QueryLocItmForPurch',
			query2JsonStrict: 1,
			rows: 99999
		},
		columns: PurCm,
		pagination: false,
		showBar: true,
		onClickRow: function(index, row) {
			PurGrid.commonClickRow(index, row);
		}
	});
	/* --���ó�ʼֵ--*/
	var Default = function() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(PurGrid);
		// /���ó�ʼֵ ����ʹ������
		var DefaultValue = {
			PurLoc: gLocObj
		};
		$UI.fillBlock('#MainConditions', DefaultValue);
	};
	Default();
	$('#QueryBT').click();
};
$(init);