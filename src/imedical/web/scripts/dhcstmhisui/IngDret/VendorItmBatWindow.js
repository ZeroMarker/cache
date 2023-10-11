// ����:	�˻���Ӧ�����ε���
// ��д��:	XuChao
// ��д����:	2018-08-28

/**
 Input: ���ʱ���¼��ֵ
 StkGrpRowId������id
 StkGrpType����������,G/M
 Locdr: ����id
 Vendor: ��Ӧ��id
 VendorName: ��Ӧ������
 NotUseFlag�������ñ�־
 QtyFlag���Ƿ����0�����Ŀ,1-������/0-����
 HospID��ҽԺid
 ReqLoc: �������id(�������idΪ��ʱ��������ҿ����ʾΪ��)
 Fn���ص�����
 */

var VendorIncItmBatWindow = function(Input, Params, Fn) {
	var BarCodeInfo = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCUDI',
		MethodName: 'UDIInfo',
		Code: Input
	}, false);
	// /"OrgBarCode^InciBarCode^Inci^Incib^BatchNo^ExpDate^ProduceDate^SerialNo"	
	$HUI.dialog('#VendorIncItmBatWindow', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
	var Loc = Params.Locdr, Vendor = Params.InclbVendor, ZeroFlag = Params.ZeroFlag;

	var IncItmBatMasterCm = [[
		{ field: 'ck', checkbox: true },
		{ title: 'Incil', field: 'Incil', width: 80, hidden: true, editor: 'text' },
		{ title: '����', field: 'InciCode', width: 140,
			formatter: function(value, rec) {
				var btn = '<a style="opacity:0.0;border:none;" class="editcls" href="javascript:void(0)"></a>' + value;
				return btn;
			}
		},
		{ title: '����', field: 'InciDesc', width: 200 },
		{ title: '���', field: 'Spec', width: 100 },
		{ title: '��������', field: 'ManfName', width: 160 },
		{ title: '��ⵥλ', field: 'PUomDesc', width: 70 },
		{ title: '����(��ⵥλ)', field: 'PRp', width: 110, align: 'right' },
		{ title: '�ۼ�(��ⵥλ)', field: 'PSp', width: 110, align: 'right' },
		{ title: '����(��ⵥλ)', field: 'PUomQty', width: 110, align: 'right' },
		{ title: '������λ', field: 'BUomDesc', width: 80 },
		{ title: '����(������λ)', field: 'BRp', width: 110, align: 'right' },
		{ title: '�ۼ�(������λ)', field: 'BSp', width: 110, align: 'right' },
		{ title: '����(������λ)', field: 'BUomQty', width: 110, align: 'right' },
		{ title: '�˵���λ', field: 'BillUomDesc', width: 80 },
		{ title: '����(�˵���λ)', field: 'BillRp', width: 110, align: 'right' },
		{ title: '�ۼ�(�˵���λ)', field: 'BillSp', width: 110, align: 'right' },
		{ title: '����(�˵���λ)', field: 'BillUomQty', width: 110, align: 'right' },
		{ title: '������', field: 'NotUseFlag', width: 80, formatter: BoolFormatter },
		{ title: '����ҽ������', field: 'MatInsuCode', width: 100 },
		{ title: '����ҽ������', field: 'MatInsuDesc', width: 100 }
	]];
	var StrParam;
	if (BarCodeInfo.Inci) {
		var _options = jQuery.extend(true, {}, { BarCode: BarCodeInfo.InciBarCode }, addSessionParams(Params));
		StrParam = JSON.stringify(_options);
		Input = '';
	} else {
		StrParam = JSON.stringify(addSessionParams(Params));
	}
	var IncItmBatMasterGrid = $UI.datagrid('#IncItmBatMasterGrid', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
			MethodName: 'GetPhaOrderItemInfo',
			StrParam: StrParam,
			q: Input
		},
		columns: IncItmBatMasterCm,
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
				$(IncItmBatMasterGrid.getPanel().find('div.datagrid-body .editcls')[0]).focus();
			}
		},
		onSelect: function(index, row) {
			$UI.clear(IncItmBatDetailGrid);
			var Inci = row['InciDr'];
			var BatchNo = '', ExpDate = '';
			if (BarCodeInfo.Inci) {
				BatchNo = BarCodeInfo.BatchNo;
				ExpDate = BarCodeInfo.ExpDate;
			}
			var ParamsObj = { Inci: Inci, Loc: Loc, ZeroFlag: ZeroFlag, Vendor: Vendor, BatchNo: BatchNo, ExpDate: ExpDate };
			IncItmBatDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRet',
				QueryName: 'GdRecItmToRet',
				query2JsonStrict: 1,
				Params: JSON.stringify(ParamsObj)
			});
		},
		navigateHandler: {
			up: function(targetIndex) {},
			down: function(targetIndex) {},
			enter: function(selectedData) {
				if (IncItmBatDetailGrid.getRows().length > 0) {
					IncItmBatDetailGrid.selectRow(0);
				}
			}
		}
	});

	var IncItmBatDetailCm = [[
		{ field: 'Code', title: '����', width: 120,
			formatter: function(value, rec) {
				var btn = '<a style="opacity:0.0;border:none;" class="editcls" href="javascript:void(0)"></a>' + value;
				return btn;
			}
		},
		{ field: 'Description', title: '����', width: 150 },
		{ field: 'Inci', title: 'Inci', width: 60, hidden: true },
		{ field: 'ManfName', title: '��������', width: 120 },
		{ field: 'BatNo', title: '����', width: 100 },
		{ field: 'ExpDate', title: 'Ч��', width: 100 },
		{ field: 'SpecDesc', title: '������', width: 100, hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true },
		{ field: 'Ingri', title: 'Ingri', width: 60, hidden: true },
		{ field: 'Inclb', title: 'Inclb', width: 100, hidden: true },
		{ field: 'RecQty', title: '�������', width: 80, align: 'right' },
		{ field: 'IDate', title: '���ʱ��', width: 100 },
		// { field: 'StkQty', title: '�������', width: 100, align: 'right' },		//�������,������=��������,��ʾ����
		{ field: 'IngriLeftQty', title: '��������', width: 80, align: 'right' },
		{ field: 'Uom', title: '��λId', width: 100, hidden: true },
		{ field: 'UomDesc', title: '��λ', width: 60 },
		{ field: 'Rp', title: '����', width: 80, align: 'right' },
		{ field: 'Sp', title: '�ۼ�', width: 80, align: 'right' },
		{ field: 'InvNo', title: '��Ʊ��', width: 100 },
		{ field: 'InvDate', title: '��Ʊ����', width: 100 },
		{ field: 'InvAmt', title: '��Ʊ���', width: 80 },
		{ field: 'VendorDesc', title: '��Ӧ��', width: 100 },
		{ field: 'ConFac', title: 'ת��ϵ��', width: 80, hidden: true },
		{ field: 'BUom', title: 'BUom', width: 80, hidden: true },
		{ field: 'PConFac', title: 'PConFac', width: 80, hidden: true },
		{ title: 'ҽ�úĲĴ���', field: 'MatInsuCode', width: 100 }
	]];

	var IncItmBatDetailGrid = $UI.datagrid('#IncItmBatDetailGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRet',
			QueryName: 'GdRecItmToRet',
			query2JsonStrict: 1
		},
		idField: 'Inclb',
		columns: IncItmBatDetailCm,
		navigatingWithKey: true,
		onSelect: function(index, row) {
			if (index == 0) {
				var MainRow = $('#IncItmBatMasterGrid').datagrid('getSelected');
				var MainIndex = $('#IncItmBatMasterGrid').datagrid('getRowIndex', MainRow);
				$(IncItmBatMasterGrid.getPanel().find('div.datagrid-body .editcls')[MainIndex]).blur();
				$(IncItmBatDetailGrid.getPanel().find('div.datagrid-body .editcls')[0]).focus();
			}
		},
		navigateHandler: {
			up: function(targetIndex) {},
			down: function(targetIndex) {},
			enter: function(selectedData) {
				ReturnInclbData();
			}
			
		},
		onClickRow: function(index, row) {
			IncItmBatDetailGrid.commonClickRow(index, row);
		},
		onDblClickRow: function(index, row) {
			var InciRow = IncItmBatMasterGrid.getSelected();
			$.extend(row, InciRow);
			Fn(row);
			$HUI.dialog('#VendorIncItmBatWindow').close();
		}
	});

	$UI.linkbutton('#IncItmBatSelBT', {
		onClick: function() {
			ReturnInclbData();
		}
	});

	function ReturnInclbData() {
		var InciRow = IncItmBatMasterGrid.getSelected();
		var row = IncItmBatDetailGrid.getSelected();
		if (isEmpty(row)) {
			$UI.msg('alert', '��ѡ�����������Ϣ!');
			return;
		}
		$.extend(row, InciRow);
		Fn(row);
		$HUI.dialog('#VendorIncItmBatWindow').close();
	}
};