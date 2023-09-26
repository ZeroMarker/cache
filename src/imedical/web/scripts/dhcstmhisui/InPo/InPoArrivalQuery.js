var init = function () {

	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#MainConditions')
			if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg("alert", "开始日期不能为空!");
				return;
			}
			if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg("alert", "截止日期不能为空!");
				return;
			}
			if (isEmpty(ParamsObj.PoLoc)) {
				$UI.msg("alert", "订单科室不能为空!");
				return;
			}
			var Status = ""
			if ($HUI.checkbox("#AllImp").getValue() == true) { Status = Status + '2' + ',' }
			if ($HUI.checkbox("#PartImp").getValue() == true) { Status = Status + '1' + ',' }
			if ($HUI.checkbox("#NoImp").getValue() == true) { Status = Status + '0' + ',' }
			ParamsObj.Status = Status
			ParamsObj.CompFlag = "Y"
			ParamsObj.ApproveFlag = ""
			$UI.clear(PoDetailGrid);
			var Params = JSON.stringify(ParamsObj);
			PoMainGrid.load({
				ClassName: 'web.DHCSTMHUI.INPO',
				QueryName: 'QueryMain',
				Params: Params
			});
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			DefaultClear();
		}
	});
	$UI.linkbutton('#SendInPoBT', {
		onClick: function () {
			SendInPo();
		}
	});
	function DefaultClear() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(PoMainGrid);
		$UI.clear(PoDetailGrid);
		Default();
	}
	function SendInPo() {
		var emflag=$HUI.combobox("#EmFlag").getValue();
		var Rows = PoMainGrid.getSelections();
		if (Rows.length <= 0) {
			$UI.msg('alert', '请选择要推送的订单!');
			return;
		}
		var Detail = PoMainGrid.getSelectedData();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPO',
			MethodName: 'SendInPo',
			Detail: JSON.stringify(Detail),
			emflag:emflag
		}, function (jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', '推送成功!');
				PoMainGrid.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#ReminderBT', {
		onClick: function () {
			ReminderInPo();
		}
	});
    function ReminderInPo() {
		
		var Rows = PoMainGrid.getSelections();
		if (Rows.length <= 0) {
			$UI.msg('alert', '请选择要推送的订单!');
			return;
		}
		var Detail = PoMainGrid.getSelectedData();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPO',
			MethodName: 'ReminderInPo',
			Detail: JSON.stringify(Detail)
		}, function (jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', '催单成功!');
				PoMainGrid.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var PoLocBox = $HUI.combobox('#PoLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PoLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var StkCatBox = $HUI.combobox('#StkCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#StkScg').combotree({
		onChange: function (newValue, oldValue) {
			StkCatBox.clear();
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId=' + newValue;
			StkCatBox.reload(url);
		}
	});
	$('#SendFlag').simplecombobox({
		data: [
			{RowId: '', Description: '全部'},
			{RowId: 'Y', Description: '已推送'},
			{RowId: 'N', Description: '未推送'}
		]
	});
	$('#EmFlag').simplecombobox({
		data: [
			{RowId: '0', Description: '普通'},
			{RowId: '1', Description: '加急'},
			{RowId: '2', Description: '特急'}
		]
	});
	
	$HUI.tabs("#DetailTabs", {
		onSelect: function (title, index) {
			var Row = PoMainGrid.getSelected()
			if (isEmpty(Row)) {
				$UI.msg("alert", "请选择订单!");
				return;
			}
			var PoId = Row.RowId
			if (title == "物资明细") {
				loadIncDetailIFrame(PoId)
			}
			else if (title == "科室请领明细") {
				loadReqDetailIFrame(PoId);
			}
		}
	});

	function loadPoDetailGrid(PoId) {
		PoDetailGrid.load({
			ClassName: 'web.DHCSTMHUI.INPOItm',
			QueryName: 'Query',
			PoId: PoId,
			rows: 99999
		});
	}
	function loadIncDetailIFrame(PoId) {
		var p_URL = PmRunQianUrl + "?reportName=DHCSTM_HUI_INPO_ReqInfo.raq" + "&Parref=" + PoId;
		$("#IncDetailIFrame").attr("src", p_URL);
	}
	function loadReqDetailIFrame(PoId) {
		var p_URL = PmRunQianUrl + "?reportName=DHCSTM_HUI_INPO_ReqLocInfo.raq" + "&Parref=" + PoId;
		$("#ReqDetailIFrame").attr("src", p_URL);
	}
	function createFrame(url) {
		var s = '<iframe scrolling="auto" frameborder="0"  src="' + url + '" style="width:100%;height:100%;"></iframe>';
		return s;
	}
	
	var PoDetailCm = [[{
		title: "RowId",
		field: 'RowId',
		hidden: true
	}, {
		title: "物资ID",
		dataIndex: 'InciId',
		width: 100,
		hidden: true
	}, {
		title: "代码",
		field: 'InciCode',
		width: 100
	}, {
		title: "名称",
		field: 'InciDesc',
		width: 100
	}, {
		title: "规格",
		field: 'Spec',
		width: 100
	}, {
		title: "具体规格",
		field: 'SpecDesc',
		width: 100
	}, {
		title: "单位",
		field: 'UomDesc',
		width: 80
	}, {
		title: "进价",
		field: 'Rp',
		width: 80,
		align: 'right'
	}, {
		title: "进价金额",
		field: 'RpAmt',
		width: 80,
		align: 'right'
	}, {
		title: "到货数量",
		field: 'ImpQty',
		width: 100,
		align: 'right'
	}, {
		title: "未到货数量",
		field: 'AvaQty',
		width: 100,
		align: 'right'
	}, {
		title: "是否撤销",
		field: 'CancleFlag',
		width: 100
	}
	]];

	var PoDetailGrid = $UI.datagrid('#PoDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPOItm',
			QueryName: 'Query',
			rows: 99999
		},
		pagination:false,
		columns: PoDetailCm,
		sortName: 'RowId',
		sortOrder: 'Desc'
	})

	var PoMainCm = [[{
			field: 'ck',
			checkbox: true
		}, {
			title: "RowId",
			field: 'RowId',
			hidden: true
		}, {
			title: "订单号",
			field: 'PoNo',
			width: 100
		}, {
			title: "订单科室",
			field: 'PoLocDesc',
			width: 100
		}, {
			title: "供应商",
			field: 'VendorDesc',
			width: 150
		}, {
			title: "订单状态",
			field: 'PoStatus',
			width: 100,
			formatter: function (value) {
				var PoStatus = '';
				if (value == 0) {
					PoStatus = '未入库';
				} else if (value == 1) {
					PoStatus = '部分入库';
				} else if (value == 2) {
					PoStatus = '全部入库';
				}
				return PoStatus;
			}
		}, {
			title: "订单日期",
			field: 'CreateDate',
			width: 100
		}, {
			title: "完成",
			field: 'CompFlag',
			width: 100
		}
	]];

	var PoMainGrid = $UI.datagrid('#PoMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPO',
			QueryName: 'QueryMain'
		},
		columns: PoMainCm,
		singleSelect: false,
		onSelect: function (index, row) {
			var DTTabed = $('#DetailTabs').tabs('getSelected');
			var DTTabed = $('#DetailTabs').tabs('getTabIndex', DTTabed);
			if (DTTabed == 0) {
				loadPoDetailGrid(row.RowId);
			} else if (DTTabed == 1) {
				loadIncDetailIFrame(row.RowId);
			} else if (DTTabed == 2) {
				loadReqDetailIFrame(row.RowId);
			}
		}
	});

	/*--设置初始值--*/
	var Default = function () {
		///设置初始值 考虑使用配置
		var DefaultValue = {
			StartDate: DateAdd(new Date(), 'd', parseInt(-7)),
			EndDate: new Date(),
			PoLoc: gLocObj,
			AllImp: "Y",
			PartImp: "Y",
			NoImp: "Y",
			SendFlag: '',
			EmFlag: '0'
		};
		$UI.fillBlock('#MainConditions', DefaultValue);
		$("#IncDetailIFrame").attr("src", "");
		$("#ReqDetailIFrame").attr("src", "");
	}
	Default();
}
$(init);