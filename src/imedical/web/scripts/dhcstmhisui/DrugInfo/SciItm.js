function GetSciItm() {
	var Clear = function() {
		$UI.clearBlock('#SciConditions');
		$UI.clear(SciGrid);
		var DefaultData = {
			SciStartDate: DateFormatter(new Date()),
			SciEndDate: DateFormatter(new Date()),
			CreatedFlag: 'N'
		};
		$UI.fillBlock('#SciWin', DefaultData);
	};
	$HUI.dialog('#SciWin', { width: gWinWidth, height: gWinHeight }).open();
	$UI.linkbutton('#SciQueryBT', {
		onClick: function() {
			NewItmSearch();
		}
	});
	
	function NewItmSearch() {
		var ParamsObj = $UI.loopBlock('#SciConditions');
		var Params = JSON.stringify(ParamsObj);
		SciGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCNewItm',
			QueryName: 'GetNewItm',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#SciPickBT', {
		onClick: function() {
			SciPickFun();
		}
	});
	function SciPickFun() {
		if (isEmpty(SciGrid.getSelected())) {
			return;
		}
		var NIRowId = SciGrid.getSelected().NIRowId;
		var Inci = SciGrid.getSelected().Inci;
		if (!isEmpty(Inci)) {
			$UI.msg('alert', '已生成库存项，不可重复生成！');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCNewItm',
			MethodName: 'GetItmDetail',
			RowId: NIRowId,
			HospId: GetHospId()
		}, function(jsonData) {
			$UI.clearBlock('#InciData');
			$UI.clearBlock('#ArcimData');
			$UI.fillBlock('#InciData', jsonData);
			// 注意, 此处如果给#ArcimData赋值, 可能会和ScMap配置冲突;同时这个地方似乎不好明确是否屏蔽ScMap功能;
			// 如果需要,建议通过全局变量,或者表单上添加一个类似于Inci的元素,用以控制
			$HUI.dialog('#SciWin').close();
		});
	}
	
	$UI.linkbutton('#SciClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#NewItmSynSCIBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#SciConditions');
			ParamsObj.BDPHospital = GetHospId();
			var Params = JSON.stringify(ParamsObj);
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCNewItm',
				MethodName: 'jsGetSpecifications',
				Params: Params
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					NewItmSearch();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	var SciCm = [[
		{
			title: 'NIRowId',
			field: 'NIRowId',
			width: 150,
			hidden: true
		}, {
			title: 'Inci',
			field: 'Inci',
			width: 150,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 150,
			hidden: true
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 150,
			hidden: true
		}, {
			title: '名称',
			field: 'NIDesc',
			width: 100
		}, {
			title: '规格',
			field: 'NISpec',
			width: 55
		}, {
			title: '型号',
			field: 'NIModel',
			width: 55
		}, {
			title: '品牌',
			field: 'NIBrand',
			width: 55
		}, {
			title: '基本单位',
			field: 'NIBUomDesc',
			width: 75
		}, {
			title: '入库单位',
			field: 'NIPUomDesc',
			width: 75
		}, { title: '进价',
			field: 'NIRpPUom',
			width: 55,
			align: 'right'
		}, {
			title: '进口标志',
			field: 'NIImportFlag',
			width: 75,
			align: 'cenrer'
		}, {
			title: '供应商',
			field: 'NIVendorDesc',
			width: 70
		}, {
			title: '生产厂家',
			field: 'NIManfDesc',
			width: 75
		}, {
			title: '一次性标志',
			field: 'NIBAflag',
			width: 90,
			align: 'cenrer'
		}, {
			title: '临采标志',
			field: 'TemPurchase',
			width: 75,
			align: 'cenrer'
		}, {
			title: '集采标志',
			field: 'CentralPurFlag',
			width: 75,
			align: 'cenrer'
		}, {
			title: '批号要求',
			field: 'BatchReq',
			width: 75,
			align: 'cenrer'
		}, {
			title: '效期要求',
			field: 'ExpReq',
			width: 75,
			align: 'cenrer'
		}
	]];
	var SciGrid = $UI.datagrid('#SciGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCNewItm',
			QueryName: 'GetNewItm',
			query2JsonStrict: 1
		},
		columns: SciCm,
		onDblClickRow: function(index, row) {
			SciPickFun();
		}
	});
	Clear();
	NewItmSearch();
}