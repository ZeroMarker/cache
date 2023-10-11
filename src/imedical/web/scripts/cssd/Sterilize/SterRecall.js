var init = function() {
	// 召回不合格原因下拉框
	$HUI.combobox('#RecallReasonDesc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetRecallReason&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: gHospId })),
		valueField: 'RowId',
		textField: 'Description'
	});
	// 查询
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			$UI.clear(ItemListGrid);
			var ParamsObj = $UI.loopBlock('#MainCondition');
			if (isEmpty(ParamsObj.SterNo)) {
				$UI.msg('alert', '请输入灭菌批号');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			ItemListGrid.load({
				ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeRecall',
				QueryName: 'GetTraceInfoBySteBatNo',
				Params: Params,
				rows: 99999
			});
		}
	});
	// 召回
	$UI.linkbutton('#ReCall', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#MainCondition');
			var RecallReasonDesc = ParamsObj.RecallReasonDesc;
			if (isEmpty(RecallReasonDesc)) {
				$UI.msg('alert', '请输入召回原因');
				return;
			}
			var MainParams = JSON.stringify(ParamsObj);
			var Detail = ItemListGrid.getSelections();
			if (isEmpty(Detail)) {
				$UI.msg('alert', '请选择需要召回的消毒包');
				return;
			}
			for (var i = 0; i < Detail.length; i++) {
				var RecallFlag = Detail[i].RecallFlag;
				if (RecallFlag == 'Y') {
					$UI.msg('alert', '已经召回,不能再次召回');
					return;
				}
			}
			var DetailParams = JSON.stringify(Detail);
			showMask();
			$.cm({
				ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeRecall',
				MethodName: 'jsSteReCall',
				Main: MainParams,
				Detail: DetailParams
			}, function(jsonData) {
				hideMask();
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					ItemListGrid.reload();
				} else {
					$UI.msg('alert', jsonData.msg);
				}
			});
		}
	});

	var ItemCm = [[
		{
			field: 'ck',
			checkbox: true
		},
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '标签',
			field: 'Label',
			width: 200
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 150
		}, {
			title: '状态',
			field: 'Status',
			formatter: PkgStatusRenderer,
			width: 100
		}, {
			title: '当前位置',
			field: 'LocDesc',
			width: 150
		}, {
			title: '召回标志',
			field: 'RecallFlag',
			align: 'center',
			width: 100
		}, {
			title: '召回原因',
			field: 'RecallReasonDesc',
			width: 200
		}, {
			title: '召回人',
			field: 'RecallUserName',
			width: 100
		}, {
			title: '召回时间',
			field: 'RecallDateTime',
			width: 150
		}, {
			title: '灭菌科室Id',
			field: 'LocId',
			width: 150,
			hidden: true
		}
	]];

	var ItemListGrid = $UI.datagrid('#GridList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeRecall',
			MethodName: 'GetTraceInfoBySteBatNo',
			rows: 99999
		},
		navigatingWithKey: true,
		columns: ItemCm,
		pagination: false,
		singleSelect: false,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#GridList').datagrid('selectRow', 0);
			}
		}
	});
};
$(init);