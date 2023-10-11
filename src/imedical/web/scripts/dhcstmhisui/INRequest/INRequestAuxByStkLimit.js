var init = function() {
	var Clear = function() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(LimitGrid);
		var DefaultData = {
			ReqLoc: gLocObj,
			ReqType: 'O'
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
	var Manager = $HUI.combobox('#Manager', {
		data: [{ 'RowId': '', 'Description': 'ȫ��' }, { 'RowId': 'Y', 'Description': '�ص��ע' }, { 'RowId': 'N', 'Description': '���ص��ע' }],
		valueField: 'RowId',
		textField: 'Description'
	});
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
		TransLocType: 'F',
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
			if (isEmpty(ParamsObj.SupLoc)) {
				$UI.msg('alert', '��Ӧ���Ҳ���Ϊ��!');
				return;
			}
			if (isEmpty(ParamsObj.ReqLoc)) {
				$UI.msg('alert', '������Ҳ���Ϊ��!');
				return;
			}
			if (InRequestParamObj.NoScgLimit != 'Y' && isEmpty($HUI.combobox('#ScgStk').getValue())) {
				$UI.msg('alert', '���鲻��Ϊ��!');
				return false;
			}
			var Params = JSON.stringify(ParamsObj);
			LimitGrid.load({
				ClassName: 'web.DHCSTMHUI.INRequestAuxByLim',
				QueryName: 'LocItmForReq',
				query2JsonStrict: 1,
				Params: Params,
				rows: 99999
			});
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var MainObj = $UI.loopBlock('#MainConditions');
			var Main = JSON.stringify(MainObj);
			var Detail = LimitGrid.getRowsData();
			if (isEmpty(Detail)) {
				$UI.msg('alert', '��ѡ����Ӧ�ĸ�������');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.INRequest',
				MethodName: 'Save',
				Main: Main,
				Detail: JSON.stringify(Detail)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.clear(LimitGrid);
					$UI.msg('success', jsonData.msg);
					var Req = jsonData.rowid;
					var HvFlagRadioJObj = $("input[name='HvFlag']:checked");
					var UrlStr;
					if (HvFlagRadioJObj.val() == 'N') {
						UrlStr = 'dhcstmhui.inrequest.csp?RowId=' + Req;
					} else {
						UrlStr = 'dhcstmhui.inrequesthv.csp?RowId=' + Req;
					}
					Common_AddTab('����', UrlStr);
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
	var LimitGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '����RowId',
			field: 'Inci',
			hidden: true,
			width: 60
		}, {
			title: '����',
			field: 'Code',
			width: 100
		}, {
			title: '����',
			field: 'Description',
			width: 150
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '��������',
			field: 'Manf',
			width: 150
		}, {
			title: '������������',
			field: 'ReqQty',
			width: 100,
			align: 'right',
			hidden: true
		}, {
			title: '��������',
			field: 'Qty',
			width: 100,
			align: 'right'
		}, {
			title: '��������',
			field: 'AvaQty',
			width: 100,
			align: 'right'
		}, {
			title: '�������',
			field: 'MaxQty',
			width: 100,
			align: 'right'
		}, {
			title: '�������',
			field: 'MinQty',
			width: 100,
			align: 'right'
		}, {
			title: '��׼���',
			field: 'RepQty',
			width: 100,
			align: 'right'
		}, {
			title: '��λ',
			field: 'Uom',
			width: 100,
			formatter: CommonFormatter(UomCombox, 'Uom', 'UomDesc')
		}, {
			title: '��ֵ��־',
			field: 'HvFlag',
			width: 80,
			align: 'center',
			formatter: BoolFormatter
		}
	]];
	
	var LimitGrid = $UI.datagrid('#LimitGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INRequestAuxByLim',
			QueryName: 'LocItmForReq',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: LimitGridCm,
		showBar: true,
		fitColumns: true
	});
	Clear();
};
$(init);