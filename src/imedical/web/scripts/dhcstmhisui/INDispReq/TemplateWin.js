var TemplateWin = function(SelectFn, CreateFn) {
	$HUI.dialog('#TemplateWin', {
		height: gWinHeight,
		width: gWinWidth
	}).open();
	var FTLocParams = JSON.stringify(addSessionParams({
		Type: 'Login'
	}));
	var FTLocBox = $HUI.combobox('#FTLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FTLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onChange: function(e) {
			DispTempLoc(e);
		}
	});
	// רҵ��
	function DispTempLoc(FTLocId) {
		var FTUserGrpParams = JSON.stringify(addSessionParams({
			User: gUserId,
			SubLoc: FTLocId,
			ReqFlag: ''
		}));
		var FTUserGrpBox = $HUI.combobox('#FTUserGrp', {
			url: $URL + '?ClassName=web.DHCSTMHUI.DHCSubLocUserGroup&QueryName=GetUserGrp&ResultSetType=array&Params=' + FTUserGrpParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	}
	$UI.linkbutton('#FTQueryBT', {
		onClick: function() {
			TemplateQuery();
		}
	});
	
	function TemplateQuery() {
		$UI.clear(TemplateMainGrid);
		$UI.clear(TemplateItmGrid);
		var ParamsObj = $UI.loopBlock('#TemplateConditions');
		if (isEmpty(ParamsObj['LocId'])) {
			$UI.msg('alert', '���Ҳ���Ϊ��!');
			return;
		}
		ParamsObj['TemplateFlag'] = 'Y';
		var Params = JSON.stringify(ParamsObj);
		TemplateMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DispReqTemplate',
			QueryName: 'QueryTemplate',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	$UI.linkbutton('#FTClearBT', {
		onClick: function() {
			TemplateDafult();
		}
	});
	$UI.linkbutton('#FTSelectBT', {
		onClick: function() {
			var Row = TemplateMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ���ص�ģ��!');
				return;
			}
			SelectFn(Row.RowId);
			$HUI.dialog('#TemplateWin').close();
		}
	});
	$UI.linkbutton('#FTCreateBT', {
		onClick: function() {
			var Row = TemplateMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ���ص�ģ��!');
				return;
			}
			var DetailRows = TemplateItmGrid.getSelections();
			if (isEmpty(DetailRows)) {
				$UI.msg('alert', '��ѡ����Ҫ�Ƶ���ģ����ϸ����!');
				return;
			}
			var ReqItmArr = [];
			$.each(DetailRows, function(index, row) {
				var DspReqi = row['RowId'];
				ReqItmArr.push(DspReqi);
			});
			var DspReqiIdStr = ReqItmArr.join('^');
			CreateFn(Row['RowId'], DspReqiIdStr);
			$HUI.dialog('#TemplateWin').close();
		}
	});
    
	var TemplateMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '����',
			field: 'DsrqNo',
			width: 160
		}, {
			title: '������',
			field: 'ReqUser',
			width: 100
		}, {
			title: 'רҵ��',
			field: 'GrpDesc',
			width: 100
		}, {
			title: '����ģʽ',
			field: 'ReqMode',
			width: 80,
			hidden: true
		}, {
			title: '����ģʽ',
			field: 'ReqModeDesc',
			width: 100
		}, {
			title: '��ע',
			field: 'Remark',
			width: 100
		}
	]];
	
	var TemplateMainGrid = $UI.datagrid('#TemplateMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DispReqTemplate',
			QueryName: 'QueryTemplate',
			query2JsonStrict: 1
		},
		columns: TemplateMainCm,
		onSelect: function(index, row) {
			TemplateItmGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
				QueryName: 'DHCINDispReqItm',
				query2JsonStrict: 1,
				Parref: row.RowId
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				TemplateMainGrid.selectRow(0);
			}
		}
	});
	var TemplateItmCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 60,
			hidden: true
		}, {
			title: '����RowId',
			field: 'InciId',
			width: 100
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 100
		}, {
			title: '��������',
			field: 'InciDesc',
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
			title: '����',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 80
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 80,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '��ע',
			field: 'Remark',
			width: 150
		}
	]];
	
	var TemplateItmGrid = $UI.datagrid('#TemplateItmGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
			QueryName: 'DHCINDispReqItm',
			query2JsonStrict: 1
		},
		columns: TemplateItmCm,
		singleSelect: false,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				TemplateItmGrid.selectAll();
			}
		}
	});
	
	function TemplateDafult() {
		$UI.clearBlock('#TemplateConditions');
		$UI.clear(TemplateMainGrid);
		$UI.clear(TemplateItmGrid);
		var LocObj = { RowId: $('#LocId').combobox('getValue'), Descirption: $('#LocId').combobox('getText') };
		// Ĭ��������Ŀ���
		var FDafultValue = {
			LocId: LocObj
		};
		$UI.fillBlock('#TemplateConditions', FDafultValue);
	}
	TemplateDafult();
	TemplateQuery();
};