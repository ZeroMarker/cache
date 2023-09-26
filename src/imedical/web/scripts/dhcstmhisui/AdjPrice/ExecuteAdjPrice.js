// /����: ���۵���Ч
// /����: ���۵���Ч
// /��д�ߣ�zhangxiao
// /��д����: 2018.06.12
var init = function () {
	var InciHandlerParams = function () {
		var Scg = $("#ScgId").combotree('getValue');
		var Obj = {
			StkGrpRowId: Scg,
			StkGrpType: "M",
			BDPHospital:gHospId
		};
		return Obj;
	}
	$("#InciDesc").lookup(InciLookUpOp(InciHandlerParams, '#InciDesc', '#Inci'));
	var Clear = function () {
		$UI.clearBlock('#Conditions');
		$UI.clear(AdjPriceGrid);
		var Dafult = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date()),
			Status: "Audit"
		}
		$UI.fillBlock('#Conditions', Dafult);
		$('#ScgId').combotree('options')['setDefaultFun']();
	}
	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			Clear();
		}
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			Query()
		}
	});
	function Query() {
		if (isEmpty($HUI.combobox("#Status").getValue())) {
			$UI.msg('alert', '���۵�״̬����Ϊ��!');
			return false;
		};
		var ParamsObj = $UI.loopBlock('Conditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(AdjPriceGrid);
		AdjPriceGrid.load({
			ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
			QueryName: 'QueryAspInfo',
			Params: Params
		});
	}
	$UI.linkbutton('#ExeBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#Conditions')
			var Params = JSON.stringify(ParamsObj)
			var Rows = AdjPriceGrid.getSelectedData();
			if (Rows === false) { return }; //��֤δͨ��  ���ܱ���
			if (Rows == "") {
				$UI.msg('alert', '��ѡ����Ҫ��Ч�ĵ��۵�!');
				return
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
				MethodName: 'SetExe',
				Params: Params,
				Rows: JSON.stringify(Rows)
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$UI.clear(AdjPriceGrid);
					Query()
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#Conditions')
			var Params = JSON.stringify(ParamsObj)
			var Rows = AdjPriceGrid.getChangesData();
			if (Rows === false) { return; }; //��֤δͨ��  ���ܱ���
			if (isEmpty(Rows)) {
				$UI.msg('alert', 'û����Ҫ����ĵ��۵���Ϣ!');
				return;
			}
			for (var i = 0; i < Rows.length; i++) {
				var Status = Rows[i].Status;
				var InciDesc = Rows[i].InciDesc;
				var row = i + 1;
				if (Status == "�����") {
					$UI.msg('alert', '��' + row + '��' + InciDesc + '�ĵ��۵������,��ȡ����˺��޸�!');
					return;
				}
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
				MethodName: 'BatUpdatePrice',
				Params: Params,
				Rows: JSON.stringify(Rows)
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$UI.clear(AdjPriceGrid);
					Query();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	var AdjPriceCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			saveCol: true,
			hidden: true
		}, {
			title: "���۵���",
			field: 'AspNo',
			width: 180
		}, {
			title: "״̬",
			field: 'Status',
			saveCol: true,
			width: 100
		}, {
			title: "������",
			field: 'StkCatDesc',
			width: 100,
			align: 'left'
		}, {
			title: '����RowId',
			field: 'Inci',
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 100
		}, {
			title: '��������',
			field: 'InciDesc',
			saveCol: true,
			width: 150
		}, {
			title: "���",
			field: 'Spec',
			width: 100
		}, {
			title: "���۵�λ",
			field: 'AspUomDesc',
			width: 100,
			align: 'right'
		}, {
			title: "��ǰ�ۼ�",
			field: 'PriorSpUom',
			width: 100,
			align: 'right'
		}, {
			title: "�����ۼ�",
			field: 'ResultSpUom',
			width: 100,
			align: 'right',
			saveCol: true,
			editor: { type: 'numberbox', options: { required: true } }
		}, {
			title: "���(�ۼ�)",
			field: 'DiffSpUom',
			width: 100,
			align: 'right'
		}, {
			title: "��ǰ����",
			field: 'PriorRpUom',
			width: 100,
			align: 'right'
		}, {
			title: "�������",
			field: 'ResultRpUom',
			width: 100,
			align: 'right',
			saveCol: true,
			editor: { type: 'numberbox', options: { required: true } }
		}, {
			title: "���(����)",
			field: 'DiffRpUom',
			width: 100,
			align: 'right'
		}, {
			title: "�Ƶ�����",
			field: 'AdjDate',
			width: 120,
			align: 'left'
		}, {
			title: "�ƻ���Ч����",
			field: 'PreExecuteDate',
			width: 120,
			align: 'left'
		}, {
			title: "ʵ����Ч����",
			field: 'ExecuteDate',
			width: 120,
			align: 'left'
		}, {
			title: "����ԭ��",
			field: 'AdjReason',
			width: 120,
			align: 'left'
		}, {
			title: "������",
			field: 'AdjUserName',
			width: 100,
			align: 'left'
		}, {
			title: "��������",
			field: 'MarkTypeDesc',
			width: 120,
			align: 'left'
		}, {
			title: "����ۼ�",
			field: 'MaxSp',
			width: 100,
			align: 'right'
		}, {
			title: "����ļ���",
			field: 'WarrentNo',
			width: 120,
			align: 'left'
		}, {
			title: "����ļ�����",
			field: 'WnoDate',
			width: 120,
			align: 'left'
		}, {
			title: "��Ʊ��",
			field: 'InvNo',
			width: 120,
			align: 'left'
		}, {
			title: "��Ʊ����",
			field: 'InvDate',
			width: 120,
			align: 'left'
		}
	]];
	var AdjPriceGrid = $UI.datagrid('#AdjPriceGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INAdjSalePrice',
			QueryName: 'QueryAspInfo'
		},
		columns: AdjPriceCm,
		singleSelect: false,
		remoteSort: false,
		showBar: true,
		onClickCell: function (index, filed, value) {
			AdjPriceGrid.commonClickCell(index, filed, value);
		}
	})

	Clear()

}
$(init);