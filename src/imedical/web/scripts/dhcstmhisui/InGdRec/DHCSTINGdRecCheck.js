/*入库单查询与验收*/
var init = function () {
	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			QueryIngrInfo();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			IngrClear();
		}
	});
	$UI.linkbutton('#AcceptBT', {
		onClick: function () {
			AcceptData();
		}
	});
	$UI.linkbutton('#EvaluateBT', {
		onClick: function () {
			var Row = InGdRecMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要进行评价的入库单!');
				return false;
			}
			VendorEvaluateWin(Row.IngrId);
		}
	});
	var FRecLocParams = JSON.stringify(addSessionParams({ Type: "Login" }));
	var FRecLocBox = $HUI.combobox('#FRecLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FRecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var FVendorBoxParams = JSON.stringify(addSessionParams({ APCType: "M", RcFlag: "Y" }));
	var FVendorBox = $HUI.combobox('#FVendorBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVendorBoxParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var InGdRecMainCm = [[{
		title: "RowId",
		field: 'IngrId',
		width: 100,
		hidden: true
	}, {
		title: "入库单号",
		field: 'IngrNo',
		width: 120
	}, {
		title: "供应商",
		field: 'Vendor',
		width: 200
	}, {
		title: '订购科室',
		field: 'ReqLocDesc',
		width: 150
	}, {
		title: '验收人',
		field: 'AcceptUser',
		width: 70
	}, {
		title: '到货日期',
		field: 'CreateDate',
		width: 90
	}, {
		title: '采购员',
		field: 'PurchUser',
		width: 70
	}, {
		title: "完成标志",
		field: 'Complete',
		width: 70
	}, {
		title: "进价金额",
		field: 'RpAmt',
		width: 100,
		align: 'right'
	}, {
		title: "售价金额",
		field: 'SpAmt',
		width: 100,
		align: 'right'
	}
	]];

	var InGdRecMainGrid = $UI.datagrid('#InGdRecMainGrid', {
		url: '',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query'
		},
		columns: InGdRecMainCm,
		showBar: true,
		//plugins: [ProdCertif],
		onSelect: function (index, row) {
			$UI.setUrl(InGdRecDetailGrid)
			InGdRecDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
				QueryName: 'QueryDetail',
				Parref: row.IngrId,
				rows: 99999
			});
		}
	})
	var AcceptConCombox = {
		type: 'combobox',
		options: {
			data: [{ 'RowId': '合格', 'Description': '合格' }, { 'RowId': '不合格', 'Description': '不合格' }],
			//data:[['合格','合格'],['不合格','不合格']],
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var rows = InRequestGrid.getRows();
				var row = rows[InRequestGrid.editIndex];
				row.UomDesc = record.Description;

			},
			onShowPanel: function () {
				$(this).combobox('reload');
			}
		}
	};
	var InGdRecDetailCm = [[{
		title: "RowId",
		field: 'RowId',
		width: 100,
		hidden: true
	}, {
		title: '物资代码',
		field: 'IncCode',
		width: 80
	}, {
		title: '物资名称',
		field: 'IncDesc',
		width: 230
	}, {
		title: "规格",
		field: 'Spec',
		width: 180
	}, {
		title: "具体规格",
		field: 'SpecDesc',
		width: 180
	}, {
		title: "厂商",
		field: 'Manf',
		width: 180
	}, {
		title: "批号",
		field: 'BatchNo',
		width: 90
	}, {
		title: "有效期",
		field: 'ExpDate',
		width: 100
	}, {
		title: "单位",
		field: 'IngrUom',
		width: 80
	}, {
		title: "数量",
		field: 'RecQty',
		width: 80,
		align: 'right'
	}, {
		title: "外包装完好",
		field: 'PackGood',
		width: 60,
		align: 'center',
		editor: {
			type: 'checkbox',
			options: {
				on: 'Y',
				off: 'N'
			}
		}
	}, {
		title: "有合格证",
		field: 'ProdCertif',
		width: 60,
		align: 'center',
		editor: {
			type: 'checkbox',
			options: {
				on: 'Y',
				off: 'N'
			}
		}
	}, {
		title: "检测报告",
		field: 'CheckRepNo',
		width: 60,
		align: 'center',
		editor: {
			type: 'checkbox',
			options: {
				on: 'Y',
				off: 'N'
			}
		}
	}, {
		title: "产品标识",
		field: 'Token',
		width: 60,
		align: 'center',
		editor: {
			type: 'checkbox',
			options: {
				on: 'Y',
				off: 'N'
			}
		}
	}, {
		title: "中文标识",
		field: 'LocalToken',
		width: 60,
		align: 'center',
		editor: {
			type: 'checkbox',
			options: {
				on: 'Y',
				off: 'N'
			}
		}
	}, {
		title: "到货温度",
		field: 'AOGTemp',
		width: 80,
		editor: {
			type: 'numberbox',
		}
	}, {
		title: "验收结论",
		field: 'AcceptCon',
		width: 80,
		formatter: CommonFormatter(AcceptConCombox, 'AcceptCon', 'AcceptCon'),
		editor: AcceptConCombox
	}, {
		title: "检测口岸",
		field: 'CheckPort',
		width: 80,
		editor: {
			type: 'text'
		}
	}, {
		title: "报告日期",
		field: 'CheckRepDate',
		width: 80,
		editor: {
			type: 'datebox'
		}
	}, {
		title: "验收备注",
		field: 'CheckRemarks',
		width: 80,
		editor: {
			type: 'text'
		}
	}, {
		title: "注册证号",
		field: 'AdmNo',
		width: 80,
		editor: {
			type: 'text'
		}
	}, {
		title: "注册证有效期",
		field: 'AdmExpdate',
		width: 80,
		editor: {
			type: 'datebox',
			options: {
			}
		}
	}, {
		title: "摘要",
		field: 'Remark',
		width: 80,
		editor: {
			type: 'text'
		}
	}, {
		title: "进价",
		field: 'Rp',
		width: 60,
		align: 'right'
	}, {
		title: "售价",
		field: 'Sp',
		width: 60,
		align: 'right'
	}, {
		title: "发票号",
		field: 'InvNo',
		width: 80
	}, {
		title: "发票日期",
		field: 'InvDate',
		width: 100
	}, {
		title: "进价金额",
		field: 'RpAmt',
		width: 100,
		align: 'right'
	}, {
		title: "售价金额",
		field: 'SpAmt',
		width: 100,
		align: 'right'
	}, {
		title: '高值条码',
		field: 'HVBarCode',
		width: 80
	}, {
		title: '自带条码',
		field: 'OrigiBarCode',
		width: 80
	}
	]];

	var InGdRecDetailGrid = $UI.datagrid('#InGdRecDetailGrid', {
		url: '',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryDetail',
			rows: 99999
		},
		pagination:false,
		columns: InGdRecDetailCm,
		showBar: true,
		onClickCell: function (index, filed, value) {
			InGdRecDetailGrid.commonClickCell(index, filed, value);
		}
	})
	function QueryIngrInfo() {
		var ParamsObj = $UI.loopBlock('#FindConditions')
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '开始日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.FRecLoc)) {
			$UI.msg('alert', '入库科室不能为空!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(InGdRecDetailGrid);
		$UI.setUrl(InGdRecMainGrid)
		InGdRecMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query',
			Params: Params
		});

	}
	function AcceptData() {
		var Row = InGdRecMainGrid.getSelected();
		if (isEmpty(Row)) {
			$UI.msg('alert', '请选择要验收的入库单!');
			return false;
		}
		if (Row.AcceptUser != "") {
			$UI.msg('alert', '此入库单已验收，请重新选择！')
			return false;
		}
		var IngrId = Row.IngrId;
		var Main = JSON.stringify(addSessionParams({ IngrId: IngrId }));
		var DetailObj = InGdRecDetailGrid.getRowsData();
		if (DetailObj.length == 0) {
			$UI.msg('alert', '验收单无明细!');
			return false;
		}
		var Detail = JSON.stringify(DetailObj);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'SaveAcceptInfo',
			MainInfo: Main,
			ListData: Detail
		}, function (jsonData) {
			$UI.msg('alert', jsonData.msg);
			if (jsonData.success == 0) {
				QueryIngrInfo();
			}
		});
	}
	function IngrClear() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(InGdRecMainGrid);
		$UI.clear(InGdRecDetailGrid);
		var Dafult = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			FRecLoc: gLocObj,
			FStatusBox: "Y"
		}
		$UI.fillBlock('#FindConditions', Dafult);

	}
	IngrClear();
}
$(init);