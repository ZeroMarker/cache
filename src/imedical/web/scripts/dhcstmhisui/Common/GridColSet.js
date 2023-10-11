var GridColSet = function(gridObj) {
	var StrParam = gGroupId + '^' + gLocId + '^' + gUserId + '^' + gHospId;
	var GridColSetPer = tkMakeServerCall('web.DHCSTMHUI.Common.AppCommon', 'GetCommPropValue', 'GridColSetPer', StrParam);
	if (GridColSetPer == 'N') {
		$UI.msg('error', '您没有权限打开列设置！');
		return;
	}

	var colsetcm = DeepClone(gridObj.jdata.options.columns);
	var frozencol = DeepClone(gridObj.jdata.options.frozenColumns);
	for (var i = 0, Len = colsetcm[0].length; i < Len; i++) {
		var ColObj = colsetcm[0][i];
		delete ColObj.editor;
	}
	var colsetid = gridObj.jqselector;
	var CommonObj = {
		AppName: 'DHCSTCOMMONM',
		CspName: App_MenuCspName,
		GridId: colsetid
	};
	var ColSetClear = function() {
		$UI.clearBlock('#ColSetConditions');
		$UI.clear(ColSetGrid);
		var ColSetDefaultData = {
			SaveModule: 'SITE'
		};
		$UI.fillBlock('#ColSetConditions', ColSetDefaultData);
	};
	$UI.linkbutton('#ColSetSaveBT', {
		onClick: function() {
			var MainObj = $UI.loopBlock('#ColSetConditions');
			MainObj = $.extend(MainObj, CommonObj);
			var Main = JSON.stringify(MainObj);
			var Detail = ColSetGrid.getRowsData();
			if (Detail === false) { return; } // 验证未通过  不能保存
			$.cm({
				ClassName: 'web.DHCSTMHUI.StkSysGridSet',
				MethodName: 'Save',
				Main: Main,
				Detail: JSON.stringify(Detail)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					ColSetGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#ColSetInitBT', {
		onClick: function() {
			var MainObj = $UI.loopBlock('#ColSetConditions');
			MainObj = $.extend(MainObj, CommonObj);
			var Main = JSON.stringify(addSessionParams(MainObj));
			function del() {
				$.cm({
					ClassName: 'web.DHCSTMHUI.StkSysGridSet',
					MethodName: 'Delete',
					Main: Main
				}, function(jsonData) {
					if (jsonData.success === 0) {
						$UI.msg('success', jsonData.msg);
						ColSetClear();
						// ColSetFind();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
			$UI.confirm('确定要删除吗?', '', '', del);
		}
	});
	var Alignbox = {
		type: 'combobox',
		options: {
			data: [{
				RowId: 'left',
				Description: 'left'
			}, {
				RowId: 'right',
				Description: 'right'
			}, {
				RowId: 'center',
				Description: 'center'
			}],
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	var ColSetGridCm = [[
		{ title: 'RowId', field: 'RowId', hidden: true },
		{ title: '名称', field: 'Header', width: 100 },
		{ title: '标题', field: 'Name', width: 150, editor: { type: 'text' }},
		{ title: '宽度', field: 'Width', width: 100, align: 'right', editor: { type: 'text' }},
		{ title: '对齐方式', field: 'Align', width: 100, align: 'center', editor: Alignbox },
		{ title: '回车跳转顺序', field: 'EnterSort', width: 100, align: 'right', editor: {
			type: 'numberbox',
			options: {
				min: 0,
				precision: 0
			}
		}},
		{ title: '隐藏标志', field: 'Hidden', editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }}, width: 100, align: 'center' },
		{ title: '必要标志', field: 'Necessary', editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }}, width: 100, align: 'center' },
		{ title: '冻结', field: 'Frozen', editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }}, width: 100, align: 'center' }
	]];
	
	var ColSetGrid = $UI.datagrid('#ColSetGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.StkSysGridSet',
			QueryName: 'GetGridSet',
			query2JsonStrict: 1
		},
		columns: ColSetGridCm,
		pagination: false,
		navigatingWithKey: true,
		onClickCell: function(index, filed, value) {
			ColSetGrid.commonClickCell(index, filed, value);
		},
		onLoadSuccess: function() {
			$(this).datagrid('enableDnd');
		}
	});
	$('#ColSetWin').window({
		width: 1000,
		height: 500,
		modal: true
	});
	$HUI.window('#ColSetWin').open();
	
	var ColSetFind = function() {
		var Main = JSON.stringify(addSessionParams(CommonObj));
		var Mod = $.m({
			ClassName: 'web.DHCSTMHUI.StkSysGridSet',
			MethodName: 'JsGetSaveMod',
			Main: Main
		}, false);
		if (!isEmpty(Mod)) {
			var Module = Mod.split('^')[0];
			$HUI.radio('#' + Module).setValue(true);
		} else {
			$HUI.radio('#SITE').setValue(true);
			// 仅在存储为空时进行初始化
			var Detail = (colsetcm[0].reverse()).concat(frozencol[0].reverse());
			// var Detail=JSON.stringify(colsetcm[0].reverse());
			// colsetcm[0].reverse();
			$.cm({
				ClassName: 'web.DHCSTMHUI.StkSysGridSet',
				MethodName: 'Query',
				Main: Main,
				Detail: JSON.stringify(Detail)
			}, false);
		}
		ColSetGrid.load({
			ClassName: 'web.DHCSTMHUI.StkSysGridSet',
			QueryName: 'GetGridSet',
			query2JsonStrict: 1,
			Main: Main,
			rows: 9999
		});
	};
	ColSetClear();
	ColSetFind();
};