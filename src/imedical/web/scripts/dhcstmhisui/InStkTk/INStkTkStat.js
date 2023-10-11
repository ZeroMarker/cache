var init = function() {
	/* --按钮事件--*/
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var StartDate = ParamsObj.FStartDate;
			var EndDate = ParamsObj.FEndDate;
			if (isEmpty(ParamsObj.FLoc)) {
				$UI.msg('alert', '盘点科室不能为空!');
				return;
			}
			if (isEmpty(StartDate)) {
				$UI.msg('alert', '开始日期不能为空!');
				return;
			}
			if (isEmpty(EndDate)) {
				$UI.msg('alert', '截止日期不能为空!');
				return;
			}
			
			if (compareDate(StartDate, EndDate)) {
				$UI.msg('alert', '截止日期不能小于开始日期!');
				return;
			}
			ParamsObj.FInstComp = 'Y';	// 账盘完成标志
			ParamsObj.FStkTkComp = 'Y';	// 实盘完成标志
			ParamsObj.FAdjComp = 'Y';		// 调整完成标志
			var Params = JSON.stringify(ParamsObj);
			MainGrid.load({
				ClassName: 'web.DHCSTMHUI.INStkTk',
				QueryName: 'jsDHCSTINStkTk',
				query2JsonStrict: 1,
				Params: Params
			});
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Default();
		}
	});
	
	$HUI.radio("[name='LossFlag']", {
		onChecked: function(e, value) {
			loadIFrame();
		}
	});
	
	$HUI.tabs('#DetailTabs', {
		onSelect: function(title, index) {
			loadIFrame();
		}
	});
	
	function loadIFrame() {
		var DTTabed = $('#DetailTabs').tabs('getSelected');
		var DTTabed = $('#DetailTabs').tabs('getTabIndex', DTTabed);
		var Row = MainGrid.getSelected();
		if (isEmpty(Row)) {
			$UI.msg('alert', '请选择盘点单!');
			return;
		}
		var Inst = Row.RowId;
		// var LossFlagRadioObj = $("input[name='LossFlag']:checked");
		var LossFlagRadioObj = $UI.loopBlock('#LossFlagRadioConditions');
		var LossFlag = LossFlagRadioObj.StatFlag;
		var Params = JSON.stringify(addSessionParams({ StatFlag: LossFlag, Inst: Inst }));
		Params = encodeUrlStr(Params);
		if (DTTabed == '0') {
			var p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_instktkstat-detail.raq' + '&Params=' + Params;
			$('#DetailIFrame').attr('src', CommonFillUrl(p_URL));
		} else if (DTTabed == '1') {
			var p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_instktkstat-inc.raq' + '&Params=' + Params;
			$('#IncIFrame').attr('src', CommonFillUrl(p_URL));
		} else if (DTTabed == '2') {
			var p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_instktkstat_barcode.raq' + '&Params=' + Params;
			$('#IncWithBarcodeIFrame').attr('src', CommonFillUrl(p_URL));
		} else if (DTTabed == '3') {
			var p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_instktkstat_scgsum.raq' + '&Params=' + Params;
			$('#ScgSumIFrame').attr('src', CommonFillUrl(p_URL));
		}
	}
	
	var MainGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '盘点单号',
			field: 'InstNo',
			width: 150
		}, {
			title: '盘点日期',
			field: 'FreezeDate',
			width: 90,
			align: 'right'
		}, {
			title: '盘点时间',
			field: 'FreezeTime',
			width: 80,
			align: 'right'
		}, {
			title: '盘点人',
			field: 'FreezeUserName',
			width: 80,
			align: 'right'
		}, {
			title: '盘点完成',
			field: 'CompFlag',
			width: 80,
			align: 'right',
			formatter: function(value, row, index) {
				if (row.CompFlag == 'Y') {
					return '已完成';
				} else {
					return '未完成';
				}
			}
		}, {
			title: '实盘录入完成',
			field: 'StkTkCompFlag',
			width: 120,
			align: 'right',
			formatter: function(value, row, index) {
				if (row.StkTkCompFlag == 'Y') {
					return '已完成';
				} else {
					return '未完成';
				}
			}
		}, {
			title: '调整完成',
			field: 'AdjCompFlag',
			width: 80,
			align: 'right',
			formatter: function(value, row, index) {
				if (row.AdjCompFlag == 'Y') {
					return '已完成';
				} else {
					return '未完成';
				}
			}
		}, {
			title: '重点关注标志',
			field: 'ManaFlag',
			width: 120,
			align: 'right',
			hidden: true
		}, {
			title: '类组',
			field: 'StkScgDesc',
			width: 100,
			align: 'right'
		}, {
			title: '库存分类',
			field: 'StkCatDesc',
			width: 100,
			align: 'right'
		}, {
			title: '开始货位码',
			field: 'FrSbDesc',
			width: 100,
			align: 'right'
		}, {
			title: '结束货位码',
			field: 'ToSbDesc',
			width: 100,
			align: 'right'
		}, {
			title: '输入类型',
			field: 'InputType',
			width: 100,
			align: 'right',
			hidden: true
		}
	]];
	var MainGrid = $UI.datagrid('#MainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk',
			query2JsonStrict: 1
		},
		columns: MainGridCm,
		onSelect: function(index, row) {
			loadIFrame();
		},
		pagination: false
	});
	
	/* --绑定控件--*/
	var LocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var LocBox = $HUI.combobox('#FLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	/* --设置初始值--*/
	// /return:起始日期
	function DefaultStDate() {
		var Today = new Date();
		var StDate = DateAdd(Today, 'd', parseInt(-7));
		return DateFormatter(StDate);
	}
	var Default = function() {
		$UI.clearBlock('#Conditions');
		$UI.clearBlock('#ReportConditions');
		$UI.clear(MainGrid);
		// /设置初始值 考虑使用配置
		var DefaultValue = {
			FStartDate: DefaultStDate(),
			FEndDate: DateFormatter(new Date()),
			FLoc: gLocObj
		};
		$UI.fillBlock('#Conditions', DefaultValue);
		$('#DetailIFrame').attr('src', '');
		$('#IncIFrame').attr('src', '');
		$('#IncWithBarcodeIFrame').attr('src', '');
		GetReportStyle('#DetailIFrame');
		GetReportStyle('#IncIFrame');
		GetReportStyle('#IncWithBarcodeIFrame');
	};
	Default();
};
$(init);