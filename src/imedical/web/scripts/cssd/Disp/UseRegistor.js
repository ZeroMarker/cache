// 消毒包领用登记界面js
var init = function() {
	var ParamsUser = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('UsedTB');
		if (isEmpty(ParamsObj.FStartDate)) {
			$UI.msg('alert', '起始日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.FEndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		UsedGrid.load({
			ClassName: 'web.CSSDHUI.PackageDisp.UsedRegistor',
			QueryName: 'SelectAll',
			Params: JSON.stringify(ParamsObj)
		});
	}
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			DefaultData();
		}
	});
	
	$HUI.combobox('#UsedName', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + ParamsUser,
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'Code'
	});
	
	// 领用人
	$('#UsedName').keypress(function(event) {
		if (event.which == 13) {
			var v = $('#UsedName').val();
			var UserObj = $.cm({
				ClassName: 'web.CSSDHUI.Common.Dicts',
				MethodName: 'GetUserByCodeJson',
				userCode: v,
				Params: ParamsUser
			}, false);
			if (UserObj['RowId'] === '') {
				$UI.msg('alert', '未找到相关信息！');
				$('#UsedName').val('');
				$('#UsedName').combobox('setValue', '');
				$('#UsedName').combobox('textbox').focus();
				return;
			}
			$('#UsedName').val(UserObj['RowId']);
			$('#UsedName').combobox('setValue', UserObj['RowId']);
			$('#ReturnedName').focus();
		}
	});
	
	$HUI.combobox('#ReturnedName', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + ParamsUser,
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'Code'
	});
	
	// 还包人
	$('#ReturnedName').keypress(function(event) {
		if (event.which == 13) {
			var v = $('#ReturnedName').val();
			var UserObj = $.cm({
				ClassName: 'web.CSSDHUI.Common.Dicts',
				MethodName: 'GetUserByCodeJson',
				userCode: v,
				Params: ParamsUser
			}, false);
			if (UserObj['RowId'] === '') {
				$UI.msg('alert', '未找到相关信息！');
				$('#ReturnedName').val('');
				$('#ReturnedName').combobox('setValue', '');
				$('#ReturnedName').combobox('textbox').focus();
				return;
			}
			$('#ReturnedName').val(UserObj['RowId']);
			$('#ReturnedName').combobox('setValue', UserObj['RowId']);
			$('#Label').focus();
		}
	});
	
	// 扫码领动作
	$('#Label').keypress(function(event) {
		if (event.which == 13) {
			var ParamObj = $UI.loopBlock('UsedTB');
			if (isEmpty(ParamObj.Label)) {
				$UI.msg('alert', '未获取到扫描的标签,请重新扫描！');
				return;
			}
			if (isEmpty(ParamObj.UsedName) && isEmpty(ParamObj.ReturnedName)) {
				$UI.msg('alert', '请录入领用人或归还人！');
				return;
			}
			if (!isEmpty(ParamObj.UsedName) && !isEmpty(ParamObj.ReturnedName)) {
				$UI.msg('alert', '不能同时录入领用人或归还人！');
				return;
			}
			if (!isEmpty(ParamObj.UsedName)) {
				showMask();
				$.cm({
					ClassName: 'web.CSSDHUI.PackageDisp.UsedRegistor',
					MethodName: 'jsOprUseRegistor',
					Params: JSON.stringify(ParamObj)
				}, function(jsonData) {
					hideMask();
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						UsedGrid.reload();
					} else {
						$UI.msg('alert', jsonData.msg);
					}
					$('#Label').val('').focus();
				});
			} else {
				showMask();
				$.cm({
					ClassName: 'web.CSSDHUI.PackageDisp.UsedRegistor',
					MethodName: 'jsOprUseReturn',
					Params: JSON.stringify(ParamObj)
				}, function(jsonData) {
					hideMask();
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						UsedGrid.reload();
					} else {
						$UI.msg('alert', jsonData.msg);
					}
					$('#Label').val('').focus();
				});
			}
		}
	});
	
	var UsedCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			align: 'left',
			width: 100,
			hidden: true
		}, {
			title: '标签',
			field: 'Label',
			align: 'left',
			width: 200,
			sortable: true
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			align: 'left',
			width: 200,
			sortable: true
		}, {
			title: '使用科室',
			field: 'ToLocName',
			align: 'left',
			width: 150,
			sortable: true
		}, {
			title: '领包人',
			field: 'RegUserName',
			align: 'left',
			width: 120
		}, {
			title: '领包时间',
			field: 'RegDate',
			align: 'left',
			width: 170,
			sortable: true
		}, {
			title: '还包人',
			field: 'ReturnUserName',
			align: 'left',
			width: 120
		}, {
			title: '还包日期',
			field: 'ReturnDate',
			align: 'left',
			width: 170,
			sortable: true
		}, {
			title: '包装材料',
			field: 'MaterialDesc',
			align: 'left',
			width: 170
		}, {
			title: '包装日期',
			field: 'PackDate',
			align: 'left',
			width: 140
		}, {
			title: '失效日期',
			field: 'ValidDate',
			align: 'left',
			width: 140
		}
	]];
	var Params = JSON.stringify($UI.loopBlock('UsedTB'));
	var UsedGrid = $UI.datagrid('#UsedList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.UsedRegistor',
			QueryName: 'SelectAll',
			Params: Params
		},
		columns: UsedCm,
		fitColumns: true,
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#UsedList').datagrid('selectRow', 0);
			}
		}
	});
	
	function DefaultData() {
		$UI.clearBlock('UsedTB');
		$UI.clear(UsedGrid);
		$('#UsedName').focus();
		var Default = {
			FStartDate: DefaultStDate(),
			FEndDate: DefaultEdDate()
		};
		$UI.fillBlock('#UsedTB', Default);
	}
	DefaultData();
	Query();
};
$(init);