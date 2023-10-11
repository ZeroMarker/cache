// ����:		���ε���
// ��д��:	wangjiabin
// ��д����:	2018-05-19

/**
 Input:���ʱ���¼��ֵ
 StkGrpRowId������id
 StkGrpType���������ͣ�G������
 Locdr:����id
 NotUseFlag�������ñ�־
 QtyFlag���Ƿ����0�����Ŀ
 HospID��ҽԺid
 ReqLoc:�������id(�������idΪ��ʱ��������ҿ����ʾΪ��)
 Fn���ص�����
 IntrType : ҵ������(��Ӧ̨��type) 2014-08-31���
 StkCat : ������id 2016-11-29���
 QtyFlagBat:�Ƿ����0�������
 HV:��ֵ��־(Y:����ֵ,N:����ֵ,'':����)
*/
var gSelColor = '#51AD9D';
var IncItmBathvWindow = function(Input, Params, Fn) {
	$HUI.dialog('#IncItmBathvWindow').open();
	var gRowArr = [];
	var ProLocId = Params['Locdr'], ReqLocId = Params['ToLoc'];
	var IntrType = Params['IntrType'] || '';
	var QtyFlagBat = Params['QtyFlagBat'] || '0';
	var gInciRowIndex, gInciRow;
	$UI.linkbutton('#IncItmBathvSelBT', {
		onClick: function() {
			ReturnInclbHVData();
		}
	});
	
	$UI.linkbutton('#IncItmBathvSearchBT', {
		onClick: function() {
			var SelectedRow = IncItmBathvMasterGrid.getSelected();
			var InciDr = SelectedRow['InciDr'];
			var ParamsObj1 = { InciDr: InciDr, ProLocId: ProLocId, ReqLocId: ReqLocId, QtyFlag: QtyFlagBat };
			var ParamsObj2 = $UI.loopBlock('#HVWinConditions');
			var Params = JSON.stringify(jQuery.extend(true, ParamsObj1, ParamsObj2));
			IncItmBathvDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
				MethodName: 'GetDrugHVBatInfo',
				Params: Params
			});
		}
	});

	var IncItmBatHvMasterCm = [[
		// {field: 'ck', checkbox: true },
		{ title: 'Incil', field: 'Incil', width: 80, hidden: true, editor: 'text' },
		{ title: 'InciDr', field: 'InciDr', hidden: true, width: 140 },
		{ title: '����', field: 'InciCode', width: 140 },
		{ title: '����', field: 'InciDesc', width: 200 },
		{ title: '���', field: 'Spec', width: 100 },
		{ title: '�ͺ�', field: 'Model', width: 100 },
		{ title: '��������', field: 'ManfName', width: 160 },
		{ title: '��ⵥλ', field: 'PUomDesc', width: 70 },
		{ title: '����(��ⵥλ)', field: 'PRp', width: 100, align: 'right' },
		{ title: '�ۼ�(��ⵥλ)', field: 'PSp', width: 100, align: 'right' },
		{ title: '����(��ⵥλ)', field: 'PUomQty', width: 100, align: 'right' },
		{ title: '������λ', field: 'BUomDesc', width: 80 },
		{ title: '����(������λ)', field: 'BRp', width: 100, align: 'right' },
		{ title: '�ۼ�(������λ)', field: 'BSp', width: 100, align: 'right' },
		{ title: '����(������λ)', field: 'BUomQty', width: 100, align: 'right' },
		{ title: '�˵���λ', field: 'BillUomDesc', width: 80 },
		{ title: '����(�˵���λ)', field: 'BillRp', width: 100, align: 'right' },
		{ title: '�ۼ�(�˵���λ)', field: 'BillSp', width: 100, align: 'right' },
		{ title: '����(�˵���λ)', field: 'BillUomQty', width: 100, align: 'right' },
		{ title: '������', field: 'NotUseFlag', hidden: true, width: 50, align: 'center', formatter: BoolFormatter },
		{ title: '����ҽ������', field: 'MatInsuCode', width: 100 },
		{ title: '����ҽ������', field: 'MatInsuDesc', width: 100 }
	]];
	var StrParam = JSON.stringify(addSessionParams(Params));
	var IncItmBathvMasterGrid = $UI.datagrid('#IncItmBathvMasterGrid', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
			MethodName: 'GetPhaOrderItemInfo',
			StrParam: StrParam,
			q: Input
		},
		columns: IncItmBatHvMasterCm,
		onSelect: function(index, row) {
			gInciRowIndex = index, gInciRow = row;
			var InciDr = row['InciDr'];
			var ParamsObj = { InciDr: InciDr, ProLocId: ProLocId, ReqLocId: ReqLocId, QtyFlag: QtyFlagBat };
			IncItmBathvDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
				MethodName: 'GetDrugHVBatInfo',
				Params: JSON.stringify(ParamsObj)
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				IncItmBathvMasterGrid.selectRow(0);
			}
		}
	});

	var IncItmBathvDetailCm = [[{ field: 'ck', checkbox: true },
		{ title: '����RowID', field: 'Inclb', width: 100, hidden: true, editor: 'text' },
		{ title: 'InciDr', field: 'InciDr', width: 200, hidden: true, align: 'left' },
		{ title: 'dhcit', field: 'dhcit', width: 200, hidden: true, align: 'left' },
		{ title: '����~Ч��', field: 'BatExp', width: 200, align: 'left' },
		{ title: '��ֵ����', field: 'HVBarCode', width: 200, align: 'left' },
		{ title: '������', field: 'SpecDesc', width: 100, align: 'left' },
		{ title: 'ҵ������', field: 'OperQty', width: 90, align: 'right' },
		{ title: '��Ӧ��', field: 'VendorName', width: 120 },
		{ title: '��������', field: 'Manf', width: 180 },
		{ title: '��λ', field: 'PurUomDesc', width: 80 },
		{ title: '�����ۼ�', field: 'BatSp', width: 60, align: 'right' },
		{ title: '��������', field: 'ReqQty', width: 80, align: 'right' },
		{ title: '������λRowId', field: 'BUomId', width: 80, hidden: true },
		{ title: '������λ', field: 'BUomDesc', width: 80 },
		{ title: '����', field: 'Rp', width: 60, align: 'right' },
		{ title: '��λ��', field: 'StkBin', width: 100 },
		{ title: '��Ӧ�����', field: 'SupplyStockQty', width: 100, align: 'right' },
		{ title: '��Ӧ�����ÿ��', field: 'SupplyAvaStockQty', width: 100, align: 'right' },
		{ title: '���󷽿��', field: 'RequrstStockQty', width: 100, align: 'right' },
		{ title: 'ת����', field: 'ConFac', width: 60, align: 'center' },
		{ title: '��ֵ��־', field: 'HVFlag', width: 60, align: 'center' },
		{ title: '������־', field: 'RecallFlag', width: 60, align: 'center' },
		{ title: '�������', field: 'SterilizedBat', width: 100 }
	]];
	var IncItmBathvDetailGrid = $UI.datagrid('#IncItmBathvDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
			MethodName: 'GetDrugHVBatInfo'
		},
		singleSelect: false,
		columns: IncItmBathvDetailCm,
		onDblClickRow: function(index, row) {
			ReturnInclbHVData();
		}
	});

	function ReturnInclbHVData() {
		var rows = IncItmBathvDetailGrid.getSelections();
		if (rows.length == 0) {
			$UI.msg('alert', '��ѡ����Ҫ�������ϸ��');
		} else {
			Fn(rows);
			$HUI.dialog('#IncItmBathvWindow').close();
		}
	}
};