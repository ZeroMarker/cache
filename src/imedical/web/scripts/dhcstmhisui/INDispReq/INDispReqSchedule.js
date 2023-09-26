var init = function () {
	var LocParams = JSON.stringify(addSessionParams({
				Type: 'Login'
			}));
	var LocBox = $HUI.combobox('#LocId', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
			valueField: 'RowId',
			textField: 'Description'
		});

	//专业组
	var UserGrpParams = JSON.stringify(addSessionParams({
				User: gUserId,
				SubLoc: gLocId,
				ReqFlag: ""
			}));
	var UserGrpBox = $HUI.combobox('#UserGrp', {
			url: $URL + '?ClassName=web.DHCSTMHUI.DHCSubLocUserGroup&QueryName=GetUserGrp&ResultSetType=array&Params=' + UserGrpParams,
			valueField: 'RowId',
			textField: 'Description'
		});

	var MainCm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: "单号",
				field: 'DsrqNo',
				width: 150
			}, {
				title: "进度",
				field: 'DispSchedule',
				width: 100,
				formatter: function (value, row, index) {
					if (value == 0) {
						return "未发放";
					} else if (value == 1) {
						return "部分发放";
					} else if (value == 2) {
						return "全部发放";
					}
				}
			}, {
				title: "请领人",
				field: 'ReqUser',
				width: 100
			}, {
				title: "专业组",
				field: 'GrpDesc',
				width: 100
			}, {
				title: "制单日期",
				field: 'CreateDate',
				width: 100
			}, {
				title: "制单时间",
				field: 'CreateTime',
				width: 100
			}, {
				title: "完成",
				field: 'Comp',
				width: 100,
				formatter: function (value, row, index) {
					if (value == "Y") {
						return "是";
					} else {
						return "否";
					}
				}
			}, {
				title: "状态",
				field: 'Status',
				width: 100,
				formatter: function (value, row, index) {
					if (value == "O") {
						return "待处理";
					} else if (value == "C") {
						return "已处理";
					} else if (value == "X") {
						return "已作废";
					} else if (value == "R") {
						return "已拒绝";
					}
				}
			}, {
				title: "备注",
				field: 'Remark',
				width: 100
			}
		]];

	var MainGrid = $UI.datagrid('#MainGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCINDispReq',
				QueryName: 'DHCINDispReq'
			},
			columns: MainCm,
			onSelect: function (index, row) {
				$UI.clear(DetailGrid);
				DetailGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
					QueryName: 'DHCINDispReqItm',
					Parref: row.RowId,
					rows: 99999
				});
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					MainGrid.selectRow(0);
				}
			}
		});

	var DetailCm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				hidden: true
			}, {
				title: "IncId",
				field: 'IncId',
				width: 50,
				hidden: true
			}, {
				title: "物资代码",
				field: 'InciCode',
				width: 150
			}, {
				title: "物资名称",
				field: 'InciDesc',
				width: 200
			}, {
				title: "规格",
				field: 'Spec',
				width: 100
			}, {
				title: "数量",
				field: 'Qty',
				width: 80,
				align: 'right'
			}, {
				title: "已发数量",
				field: 'DispedQty',
				width: 80,
				align: 'right'
			}, {
				title: "单位",
				field: 'UomDesc',
				width: 80
			}, {
				title: "售价",
				field: 'Sp',
				width: 80,
				align: 'right'
			}, {
				title: "售价金额",
				field: 'SpAmt',
				width: 80,
				align: 'right'
			}, {
				title: "厂商",
				field: 'Manf',
				width: 200
			}, {
				title: "状态",
				field: 'Status',
				width: 100,
				formatter: function (value, row, index) {
					if (value == "G") {
						return "待处理";
					} else if (value == "D") {
						return "已处理";
					} else if (value == "X") {
						return "已作废";
					} else if (value == "R") {
						return "已拒绝";
					}
				}
			}, {
				title: "备注",
				field: 'Remark',
				width: 100
			}
		]];

	var DetailGrid = $UI.datagrid('#DetailGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
				QueryName: 'DHCINDispReqItm',
				rows: 99999
			},
			pagination:false,
			columns: DetailCm
		});

	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#Conditions');
			if (isEmpty(ParamsObj.LocId)) {
				$UI.msg('alert', '科室不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert', '起始日期不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert', '截止日期不能为空!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			MainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINDispReq',
				QueryName: 'DHCINDispReq',
				Params: Params
			});
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			$UI.clearBlock('#Conditions');
			$UI.clear(MainGrid);
			$UI.clear(DetailGrid);
			SetDefaValues();
		}
	});

	SetDefaValues();
}
$(init);
