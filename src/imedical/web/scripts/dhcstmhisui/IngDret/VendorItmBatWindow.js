// ����:		�˻���Ӧ�����ε���
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

var VendorIncItmBatWindow = function (Input, Params, Fn) {
	var BarCodeInfo=$.cm({
		ClassName: 'web.DHCSTMHUI.DHCUDI',
		MethodName: 'UDIInfo',
		Code:Input
	},false);
	///"OrgBarCode^InciBarCode^Inci^Incib^BatchNo^ExpDate^ProduceDate^SerialNo"	
	$HUI.dialog('#VendorIncItmBatWindow').open();
	var Loc = Params.Locdr, Vendor = Params.InclbVendor, ZeroFlag = Params.ZeroFlag;

	var IncItmBatMasterCm = [[
		{ checkbox: true },
		{ title: 'Incil', field: 'Incil', width: 80, hidden: true, editor: 'text' },
		{ title: '����', field: 'InciCode', width: 140 },
		{ title: '����', field: 'InciDesc', width: 200 },
		{ title: '���', field: 'Spec', width: 100 },
		{ title: '����', field: 'ManfName', width: 160 },
		{ title: '��ⵥλ', field: 'PUomDesc', width: 70 },
		{ title: '����(��ⵥλ)', field: 'PRp', width: 100, align: 'right' },
		{ title: '�ۼ�(��ⵥλ)', field: 'PSp', width: 100, align: 'right' },
		{ title: '����(��ⵥλ)', field: 'PUomQty', width: 100, align: 'right' },
		{ title: '������λ', field: 'BUomDesc', width: 80 },
		{ title: '����(������λ)', field: 'BRp', width: 100, align: 'right' },
		{ title: '�ۼ�(������λ)', field: 'BSp', width: 100, align: 'right' },
		{ title: '����(������λ)', field: 'BUomQty', width: 100, align: 'right' },
		{ title: '�Ƽ۵�λ', field: 'BillUomDesc', width: 80 },
		{ title: '����(�Ƽ۵�λ)', field: 'BillRp', width: 100, align: 'right' },
		{ title: '�ۼ�(�Ƽ۵�λ)', field: 'BillSp', width: 100, align: 'right' },
		{ title: '����(�Ƽ۵�λ)', field: 'BillUomQty', width: 100, align: 'right' },
		{ title: '������', field: 'NotUseFlag', width: 45,formatter:function(value){
		if(value==0)
		return '��';
		else
		return '��';} 
		}
	]];
	var StrParam;
	if(BarCodeInfo.Inci){
		var _options=jQuery.extend(true,{},{BarCode:BarCodeInfo.InciBarCode},addSessionParams(Params));
		StrParam=JSON.stringify(_options)
		Input=""
	}else{
		StrParam=JSON.stringify(addSessionParams(Params))
	}
	var IncItmBatMasterGrid = $UI.datagrid('#IncItmBatMasterGrid', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
			MethodName: 'GetPhaOrderItemInfo',
			StrParam:StrParam,
			q: Input
		},
		columns: IncItmBatMasterCm,
		onSelect: function (index, row) {
			var Inci = row['InciDr'];
			var ParamsObj = { Inci: Inci, Loc: Loc, ZeroFlag: ZeroFlag, Vendor: Vendor,BatchNo:BarCodeInfo.BatchNo,ExpDate:BarCodeInfo.ExpDate  };
			IncItmBatDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRet',
				QueryName: 'GdRecItmToRet',
				Params: JSON.stringify(ParamsObj)
			});
		}
	});

	var IncItmBatDetailCm = [[
		{ field: 'Code', title: '����', width: 120 },
		{ field: 'Description', title: '����', width: 150 },
		{ field: 'Inci', title: 'Inci', width: 60, hidden: true },
		{ field: 'ManfName', title: '����', width: 120 },
		{ field: 'BatNo', title: '����', width: 100 },
		{ field: 'ExpDate', title: 'Ч��', width: 100 },
		{ field: 'Ingri', title: 'Ingri', width: 60, hidden: true },
		{ field: 'Inclb', title: 'Inclb', width: 100, hidden: true },
		{ field: 'RecQty', title: '�������', width: 60 },
		{ field: 'IDate', title: '���ʱ��', width: 100 },
		{ field: 'StkQty', title: '�������', width: 100 },
		{ field: 'Uom', title: '��λId', width: 100, hidden: true },
		{ field: 'UomDesc', title: '��λ', width: 60 },
		{ field: 'Rp', title: '����', width: 100 },
		{ field: 'Sp', title: '�ۼ�', width: 60 },
		{ field: 'InvNo', title: '��Ʊ��', width: 100 },
		{ field: 'InvDate', title: '��Ʊ����', width: 60 },
		{ field: 'InvAmt', title: '��Ʊ���', width: 100 },
		{ field: 'VendorDesc', title: '��Ӧ��', width: 100 },
		{ field: 'ConFac', title: 'ת��ϵ��', width: 100 },
		{ field: 'SpecDesc', title: '������', width: 100 }
	]]

	var IncItmBatDetailGrid = $UI.datagrid('#IncItmBatDetailGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRet',
			QueryName: 'GdRecItmToRet'
		},
		idField: 'Inclb',
		columns: IncItmBatDetailCm,
		onClickCell: function (index, field, value) {
			IncItmBatDetailGrid.commonClickCell(index, field);
		},
		onDblClickRow: function (index, row) {
			var InciRow = IncItmBatMasterGrid.getSelected();
			$.extend(row, InciRow);
			Fn(row);
			$HUI.dialog('#VendorIncItmBatWindow').close();
		}
	});

	$UI.linkbutton('#IncItmBatSelBT', {
		onClick: function () {
			ReturnInclbData();
		}
	});

	function ReturnInclbData() {
		var InciRow = IncItmBatMasterGrid.getSelected();
		var row = IncItmBatDetailGrid.getSelected();
		if(isEmpty(row)){
			$UI.msg("alert", "��ѡ�����������Ϣ!");
			return;
		}
		$.extend(row, InciRow);
		Fn(row);
		$HUI.dialog('#VendorIncItmBatWindow').close();
	}
}
