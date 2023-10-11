var init = function() {
	var Clear = function() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(ConsumeGrid);
		var DefaultData = {
			ReqLoc: gLocObj,
			ReqType: 'O',
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			Days: 30
		};
		$UI.fillBlock('#MainConditions', DefaultData);
	};
	var UomCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	var ReqLocParams = JSON.stringify(addSessionParams({
		Type: INREQUEST_LOCTYPE,
		Element: 'ReqLoc'
	}));
	var ReqLocBox = $HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$('#SupLoc').combobox('clear');
			$('#SupLoc').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
				+ JSON.stringify(addSessionParams({
					Type: 'Trans',
					LocId: LocId,
					TransLocType: 'F',
					Element: 'ReqLoc'
				})));
			var DefaInfo = tkMakeServerCall('web.DHCSTMHUI.DHCTransferLocConf', 'GetDefLoc', LocId, gGroupId);
			var SupLocId = DefaInfo.split('^')[0], SupLocDesc = DefaInfo.split('^')[1];
			if (SupLocId && SupLocDesc) {
				AddComboData($('#SupLoc'), SupLocId, SupLocDesc);
				$('#SupLoc').combobox('setValue', SupLocId);
				SupLocParamsObj = GetAppPropValue('DHCSTINREQM', provLoc);
			}
			var requestLoc = ReqLocBox.getValue();
			var provLoc = SupLocBox.getValue();
			$HUI.combotree('#ScgStk').setFilterByLoc(requestLoc, provLoc);
		}
	});
	var SupLocParams = JSON.stringify(addSessionParams({
		Type: 'Trans',
		Element: 'SupLoc'
	}));
	var SupLocBox = $HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var requestLoc = ReqLocBox.getValue();
			var provLoc = SupLocBox.getValue();
			$HUI.combotree('#ScgStk').setFilterByLoc(requestLoc, provLoc);
			
			SupLocParamsObj = GetAppPropValue('DHCSTINREQM', provLoc);
		}
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			var StartDate = ParamsObj.StartDate;
			var EndDate = ParamsObj.EndDate;
			if (isEmpty(ParamsObj.SupLoc)) {
				$UI.msg('alert', '供应科室不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.ReqLoc)) {
				$UI.msg('alert', '请求科室不能为空!');
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
			if (isEmpty(ParamsObj.Days)) {
				$UI.msg('alert', '备货天数不能为空!');
				return;
			}
			if (InRequestParamObj.NoScgLimit != 'Y' && isEmpty($HUI.combobox('#ScgStk').getValue())) {
				$UI.msg('alert', '类组不能为空!');
				return false;
			}
			var Params = JSON.stringify(ParamsObj);
			ConsumeGrid.load({
				ClassName: 'web.DHCSTMHUI.INRequestAuxByConsume',
				QueryName: 'LocItmForReq',
				query2JsonStrict: 1,
				Params: Params,
				rows: 9999
			});
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var MainObj = $UI.loopBlock('#MainConditions');
			var Main = JSON.stringify(MainObj);
			var Detail = ConsumeGrid.getRowsData();
			if (isEmpty(Detail)) {
				$UI.msg('alert', '请选择相应的辅助请求');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.INRequest',
				MethodName: 'Save',
				Main: Main,
				Detail: JSON.stringify(Detail)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.clear(ConsumeGrid);
					$UI.msg('success', jsonData.msg);
					var Req = jsonData.rowid;
					var HvFlagRadioJObj = $("input[name='HvFlag']:checked");
					if (HvFlagRadioJObj.val() == 'N') {
						var UrlStr = 'dhcstmhui.inrequest.csp?RowId=' + Req;
					} else {
						var UrlStr = 'dhcstmhui.inrequesthv.csp?RowId=' + Req;
					}
					Common_AddTab('请求', UrlStr);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	var ConsumeGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '物资RowId',
			field: 'Inci',
			hidden: true,
			width: 60
		}, {
			title: '代码',
			field: 'Code',
			width: 100
		}, {
			title: '描述',
			field: 'Description',
			width: 150
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 150
		}, {
			title: '库存数量',
			field: 'StkQty',
			width: 100,
			align: 'right',
			hidden: true
		}, {
			title: '可用数量',
			field: 'AvaQty',
			width: 100,
			align: 'right'
		}, {
			title: '日发放量',
			field: 'DailyDispQty',
			width: 100,
			align: 'right'
		}, {
			title: '请求数量',
			field: 'Qty',
			width: 100,
			align: 'right'
		}, {
			title: '日期范围内发放总量',
			field: 'DispQtyAll',
			width: 100,
			align: 'right'
		}, {
			title: '单位',
			field: 'Uom',
			width: 100,
			formatter: CommonFormatter(UomCombox, 'Uom', 'UomDesc')
		}, {
			title: '高值标志',
			field: 'HvFlag',
			width: 80,
			align: 'center',
			formatter: BoolFormatter
		}
	]];
	
	var ConsumeGrid = $UI.datagrid('#ConsumeGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INRequestAuxByLim',
			QueryName: 'LocItmForReq',
			query2JsonStrict: 1,
			rows: 9999
		},
		pagination: false,
		columns: ConsumeGridCm,
		showBar: true,
		fitColumns: true
	});
	Clear();
};
$(init);