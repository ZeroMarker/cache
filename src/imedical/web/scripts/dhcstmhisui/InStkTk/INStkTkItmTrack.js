// ����:		ʵ�̣�¼�뷽ʽ��(��ֵɨ���̵�)
var init = function() {
	// =======================������ʼ��start==================
	// ������
	var StkCatBox = $HUI.combobox('#StkCat', {
		valueField: 'RowId',
		textField: 'Description'
	});
	
	// ����
	$('#StkScg').stkscgcombotree({
		onSelect: function(node) {
			StkCatBox.clear();
			$.cm({
				ClassName: 'web.DHCSTMHUI.Common.Dicts',
				QueryName: 'GetStkCat',
				ResultSetType: 'array',
				StkGrpId: node.id
			}, function(data) {
				StkCatBox.loadData(data);
			});
		}
	});
	
	$('#BarCode').bind('keypress', function(event) {
		if (event.keyCode == 13) {
			var BarCode = $('#BarCode').val();
			if (!isEmpty(BarCode)) {
				HVINStkTk(BarCode);
				$('#BarCode').val('');
			}
		}
	});
	// ===========================������ʼend===========================
	// ======================tbar�����¼�start=========================
	// ����
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(DetailGrid);
		var DefaultData = {
			ScgStk: '',
			LocManaGrp: '',
			InstNo: '',
			StkCatBox: '',
			LocStkBin: '',
			InStkTkWin: ''
		};
		$UI.fillBlock('#Conditions', DefaultData);
		Select(gRowId);
	}
	// ��ѯ
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			QueryDetail();
		}
	});
	
	var Select = function(Inst) {
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			MethodName: 'jsSelect',
			Inst: Inst
		},
		function(jsonData) {
			var SupLocId = jsonData.SupLocId;
			LoadData(SupLocId);
			$UI.fillBlock('#Conditions', jsonData);
			QueryDetail();
		});
	};
	
	function LoadData(LocId) {
		$HUI.combobox('#LocManGrp', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocManGrp&ResultSetType=array&LocId=' + LocId,
			valueField: 'RowId',
			textField: 'Description'
		});
		// ��λ
		var LocStkBinParams = JSON.stringify(addSessionParams({ LocDr: LocId }));
		$HUI.combobox('#LocStkBin', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocStkBin&ResultSetType=array&Params=' + LocStkBinParams,
			valueField: 'RowId',
			textField: 'Description'
		});
		// ʵ�̴���
		$HUI.combobox('#InStkTkWin', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInStkTkWindow&ResultSetType=array&LocId=' + LocId,
			valueField: 'RowId',
			textField: 'Description',
			editable: false
		});
		$('#InStkTkWin').combobox('setValue', gInstwWin);
	}
	
	function QueryDetail() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var Params = JSON.stringify(ParamsObj);
		var Inst = ParamsObj.Inst;
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTkItm',
			QueryName: 'jsDHCSTInStkTkItm',
			query2JsonStrict: 1,
			Inst: Inst,
			Others: Params,
			rows: 99999
		});
	}
	
	function loadHVBarCodeInfoGrid() {
		var row = $('#DetailGrid').datagrid('getSelected');
		if ((isEmpty(row)) || (isEmpty(row.RowId))) {
			$UI.msg('alert', '��ѡ������!');
			return;
		}
		HVBarCodeInfoGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTkItmTrack',
			QueryName: 'jsItmTrackDetail',
			query2JsonStrict: 1,
			Insti: row.RowId,
			Others: '',
			rows: 99999
		});
	}
	
	// ����ʵ��
	function HVINStkTk(HVBarCode) {
		if (isEmpty(HVBarCode)) {
			return false;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTkItmTrack',
			MethodName: 'jsINStkTkItmTrack',
			HVBarCode: HVBarCode,
			Inst: gRowId,
			UserId: gUserId
		}, function(jsonData) {
			hideMask();
			if (jsonData.success >= 0) {
				var CountQty = jsonData.rowid;
				var RowIndex = DetailGrid.getRowIndex(DetailGrid.getSelected());
				if (RowIndex != -1) {
					DetailGrid.updateRow({
						index: RowIndex,
						row: {
							'CountQty': CountQty
						}
					});
				}
				loadHVBarCodeInfoGrid();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	// ======================tbar�����¼�end============================
	var DetailGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: 'Inclb',
			field: 'Inclb',
			width: 50,
			hidden: true
		}, {
			title: 'InciId',
			field: 'InciId',
			width: 50,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 120
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 150
		}, {
			title: '��������',
			field: 'FreezeQty',
			width: 80,
			align: 'right'
		}, {
			title: 'ʵ������',
			field: 'CountQty',
			width: 80,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					min: 0,
					precision: 0
				}
			}
		}, {
			title: 'UomId',
			field: 'uom',
			hidden: true,
			width: 60
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 60
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '����',
			field: 'BatNo',
			width: 100
		}, {
			title: '��Ч��',
			field: 'ExpDate',
			width: 100
		}, {
			title: '��������',
			field: 'ManfDesc',
			width: 100
		}, {
			title: '����',
			field: 'Rp',
			width: 100,
			align: 'right'
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 100,
			align: 'right',
			hidden: true
		}, {
			title: 'ʵ������',
			field: 'CountDate',
			width: 100
		}, {
			title: 'ʵ��ʱ��',
			field: 'CountTime',
			width: 80
		}, {
			title: 'ʵ����',
			field: 'CountUserName',
			width: 100
		}, {
			title: '��λ',
			field: 'StkBinDesc',
			width: 60,
			hidden: true
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTkItm',
			QueryName: 'jsDHCSTInStkTkItm',
			query2JsonStrict: 1
		},
		columns: DetailGridCm,
		sortName: 'InciCode',
		sortOrder: 'asc',
		showBar: true,
		rows: 99999,
		pagination: false,
		onSelect: function(index, row) {
			loadHVBarCodeInfoGrid();
		}
	});
	var HVBarCodeInfoGridCm = [[
		{
			title: 'Instit',
			field: 'Instit',
			hidden: true,
			width: 50
		}, {
			title: '����ID',
			field: 'Dhcit',
			hidden: true,
			width: 50
		}, {
			title: '��ֵ����',
			field: 'BarCode',
			width: 200
		}, {
			title: '�̵��־',
			field: 'CountFlag',
			width: 100
		}]];
		
	var HVBarCodeInfoGrid = $UI.datagrid('#HVBarCodeInfoGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTkItmTrack',
			MethodName: 'jsItmTrackDetail'
		},
		columns: HVBarCodeInfoGridCm,
		rows: 99999,
		pagination: false,
		onClickRow: function(index, row) {
			HVBarCodeInfoGrid.commonClickRow(index, row);
		}
	});
	Select(gRowId);
};
$(init);