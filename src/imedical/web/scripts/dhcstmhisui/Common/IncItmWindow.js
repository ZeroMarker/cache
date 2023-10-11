// ����:		���ʵ���
// ��д��:		lxt
// ��д����:	20201022
/**
Params
	StkGrpRowId������id
	StkGrpType���������ͣ�G������
	StkCat : ������
	Locdr:����id
	ToLoc:�������id(�������idΪ��ʱ��������ҿ����ʾΪ��)
	NotUseFlag�������ñ�־
	QtyFlag���Ƿ����0�����Ŀ
	ReqModeLimited��O��ʱ����C����ƻ�
	NoLocReq
	HV:��ֵ��־(Y:����ֵ,N:����ֵ,'':����)
	RequestNoStock��Y����δ��⣬N������
	SeachAllFlag:Y(���Բ����������Ϣ)��N���봫
	Vendor:��Ӧ��id
Others
	DefaUom��0��ⵥλ��1������λ
	MoreThanStockFlag:Y�����������ڿ�棬N������

Fn���ص�����
*/
var IncItmWindow = function(Params, Others, Fn) {
	var DefaUom = Others.DefaUom;
	var MoreThanStockFlag = Others.MoreThanStockFlag;
	
	$HUI.dialog('#IncItmWindow', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
	
	$UI.linkbutton('#IncItmSelBT', {
		onClick: function() {
			ReturnInciData();
		}
	});
	
	function ReturnInciData() {
		if (!IncItmGrid.endEditing()) {
			return;
		}
		var RowsData = IncItmGrid.getChecked();
		var Len = RowsData.length;
		if (Len == 0) {
			$UI.msg('alert', '��ѡ������һ����ϸ!');
			return false;
		}
		for (var i = 0; i < Len; i++) {
			var RowData = RowsData[i];
			var InciDesc = RowData['InciDesc'];
			var Qty = RowData['Qty'];
			if (isEmpty(Qty)) {
				$UI.msg('alert', InciDesc + ' ��������Ϊ�գ�');
				return false;
			}
		}
		Fn(RowsData);
		$HUI.dialog('#IncItmWindow').close();
	}
	
	function Query() {
		IncItmGrid.load({
			ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
			MethodName: 'GetPhaOrderItemInfo',
			StrParam: JSON.stringify(addSessionParams(Params)),
			page: 1,
			rows: 99999
		});
	}
	
	/* --Grid--*/
	var IncItmCm = [[{
		field: 'ck',
		checkbox: true
	}, {
		title: 'Incil',
		field: 'Incil',
		hidden: true
	}, {
		title: '����RowId',
		field: 'InciDr',
		hidden: true
	}, {
		title: '���ʴ���',
		field: 'InciCode',
		width: 100
	}, {
		title: '��������',
		field: 'InciDesc',
		width: 200
	}, {
		title: '���',
		field: 'Spec',
		width: 100
	}, {
		title: '�ͺ�',
		field: 'Model',
		width: 100
	}, {
		title: '��������id',
		field: 'Manfdr',
		width: 100,
		hidden: true
	}, {
		title: '��������',
		field: 'ManfName',
		width: 100
	}, {
		title: '����',
		field: 'Qty',
		width: 100,
		align: 'right',
		editor: {
			type: 'numberbox',
			options: {
				min: 0,
				precision: GetFmtNum('FmtQTY')
			}
		}
	}, {
		title: '������λid',
		field: 'BUomDr',
		width: 80,
		hidden: true
	}, {
		title: '������λ',
		field: 'BUomDesc',
		width: 80,
		hidden: (DefaUom != '0' ? false : true)
	}, {
		title: '����',
		field: 'BRp',
		width: 80,
		align: 'right',
		hidden: (DefaUom != '0' ? false : true)
	}, {
		title: '�ۼ�',
		field: 'BSp',
		width: 80,
		align: 'right',
		hidden: (DefaUom != '0' ? false : true)
	}, {
		title: '�����',
		field: 'BUomQty',
		width: 80,
		align: 'right',
		hidden: (DefaUom != '0' ? false : true)
	}, {
		title: '���ÿ��',
		field: 'BUomAvaQty',
		width: 80,
		align: 'right',
		hidden: (DefaUom != '0' ? false : true)
	}, {
		title: '������ҿ�棨������λ��',
		field: 'ReqBuomQty',
		width: 80,
		align: 'right',
		hidden: true
	}, {
		title: '��ⵥλid',
		field: 'PUomDr',
		width: 80,
		hidden: true
	}, {
		title: '��ⵥλ',
		field: 'PUomDesc',
		width: 80,
		hidden: (DefaUom == '0' ? false : true)
	}, {
		title: '����',
		field: 'PRp',
		width: 80,
		align: 'right',
		hidden: (DefaUom == '0' ? false : true)
	}, {
		title: '�ۼ�',
		field: 'PSp',
		width: 80,
		align: 'right',
		hidden: (DefaUom == '0' ? false : true)
	}, {
		title: '�����',
		field: 'PUomQty',
		width: 80,
		align: 'right',
		hidden: (DefaUom == '0' ? false : true)
	}, {
		title: '���ÿ��',
		field: 'PUomAvaQty',
		width: 80,
		align: 'right',
		hidden: (DefaUom == '0' ? false : true)
	}, {
		title: '������ҿ�棨��ⵥλ��',
		field: 'ReqPuomQty',
		width: 80,
		align: 'right',
		hidden: true
	}, {
		title: '��ע',
		field: 'Remarks',
		width: 80
	}, {
		title: '��ֵ',
		field: 'HVFlag',
		width: 40,
		formatter: BoolFormatter
	}, {
		title: '��λת��',
		field: 'PFac',
		width: 40,
		hidden: true
	}
	]];

	var IncItmGrid = $UI.datagrid('#IncItmGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
			QueryName: 'GetPhaOrderItemInfo',
			rows: 99999
		},
		checkOnSelect: true,
		selectOnCheck: true,
		pagination: false,
		columns: IncItmCm,
		singleSelect: false,
		onClickCell: function(index, filed, value) {
			IncItmGrid.commonClickCell(index, filed, value);
		},
		navigatingWithKey: true,
		onEndEdit: function(index, row, changes) {
			if (changes.hasOwnProperty('Qty')) {
				var Qty = Number(row.Qty);
				var PrvQty = '';
				if (DefaUom == '0') {
					PrvQty = Number(row.PUomAvaQty);
				} else {
					PrvQty = Number(row.BUomAvaQty);
				}
				if (!isEmpty(Qty)) {
					if (Qty <= 0) {
						$UI.msg('alert', '�����������0!');
						$(this).datagrid('updateRow', {
							index: index,
							row: { Qty: '' }
						});
						return false;
					} else {
						if ((!isEmpty(Params.ReqModeLimited)) && (MoreThanStockFlag != 'Y') && (PrvQty < Qty)) {
							$UI.msg('alert', '������������ڿ��ÿ��!');
							$(this).datagrid('updateRow', {
								index: index,
								row: { Qty: '' }
							});
							return false;
						} else {
							$('#IncItmGrid').datagrid('selectRow', index);
						}
					}
				}
			}
		}
	});
	
	Query();
};