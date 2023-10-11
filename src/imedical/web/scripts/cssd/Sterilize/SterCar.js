var MainListGrid;
var init = function() {
	// 灭菌架
	var AttributeId = '6';
	var Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	$HUI.combobox('#SterCarDesc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllSterCar&ResultSetType=array&PackTypeDetail=' + AttributeId + '&Params=' + Params,
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'Code',
		onSelect: function(record) {
			Query();
		}
	});
	$('#SterCarDesc').combobox('textbox').keyup(function(event) {
		if (event.which == 13) {
			var SterCarDesc = $('#SterCarDesc').combobox('getText');
			if (SterCarDesc != '') {
				var SterCarObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetSterCar',
					type: AttributeId,
					SterCar: SterCarDesc,
					Params: Params
				}, false);
				var DictId = SterCarObj['DictId'];
				var Ret = SterCarObj['Ret'];
				if (DictId == '') {
					$UI.msg('alert', '未获取到灭菌架相关信息！');
					$('#SterCarDesc').combobox('setValue', '');
					$('#SterCarDesc').combobox('textbox').focus();
					return;
				}
				if (Ret == 'N') {
					$UI.msg('alert', '错误的灭菌架标牌');
					$('#SterCarDesc').combobox('setValue', '');
					$('#SterCarDesc').combobox('textbox').focus();
					return;
				}
				$('#SterCarDesc').combobox('setValue', DictId);
				Query();
			}
		}
	});

	// 扫码动作
	$('#BarCode').keyup(function(event) {
		if (event.which == 13) {
			SaveCarDetail();
		}
	}).focus(function(event) {
		$('#BarCode').val('');
		$('#BarCodeHidden').val('');
		var ReadOnly = $('#BarCode').attr('readonly');
		if (ReadOnly == 'readonly') {
			$('#BarCodeHidden').focus();
		}
		InitScanIcon();
	}).blur(function(event) {
		InitScanIcon();
	});
	$('#BarCodeHidden').keyup(function(event) {
		if (event.which == 13) {
			var HiddenVal = $('#BarCodeHidden').val();
			$('#BarCode').val(HiddenVal);
			$('#BarCodeHidden').val('');
			SaveCarDetail();
		}
	}).focus(function(enent) {
		InitScanIcon();
	}).blur(function(event) {
		InitScanIcon();
	});
	// 控制是否允许编辑
	$('#BarCodeSwitchBT').linkbutton({
		iconCls: 'icon-w-switch',
		// plain: true,
		// iconCls: 'icon-key-switch',
		onClick: function() {
			var ReadOnly = $('#BarCode').attr('readonly');		// 只读时,此值为'readonly'
			if (ReadOnly == 'readonly') {
				$('#BarCode').attr({ readonly: false });
				SetLocalStorage('BarCodeHidden', '');
			} else {
				$('#BarCode').attr({ readonly: true });
				SetLocalStorage('BarCodeHidden', 'Y');
			}
			$('#BarCode').focus();
		}
	});
	// 控制扫码图标
	function InitScanIcon() {
		var ElementId = document.activeElement.id;
		var ReadOnly = $('#BarCode').attr('readonly');
		if (ElementId == 'BarCodeHidden') {
			// 扫描icon
			$('#UseBarCodeBT').linkbutton({ iconCls: 'icon-scanning' });
		} else if (ReadOnly == 'readonly') {
			// 只读icon
			$('#UseBarCodeBT').linkbutton({ iconCls: 'icon-gray-edit' });
		} else {
			// 可编辑icon
			$('#UseBarCodeBT').linkbutton({ iconCls: 'icon-blue-edit' });
		}
	}
	if (GetLocalStorage('BarCodeHidden') == 'Y') {
		$('#BarCode').attr({ 'readonly': true });
	} else {
		$('#BarCode').attr({ 'readonly': false });
	}
	InitScanIcon();

	// 装车
	function SaveCarDetail() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var CarLabel = ParamsObj['SterCarDesc'];
		var Label = ParamsObj['BarCode'];
		if (isEmpty(CarLabel) || isEmpty(Label)) {
			return;
		}
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeCar',
			MethodName: 'jsSaveSterCar',
			CarLabel: CarLabel,
			Label: Label
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				MainListGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
			$('#BarCode').val('');
			$('#BarCode').focus();
		});
	}

	// 选取待灭菌包
	function AddItem() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var CarLabel = ParamsObj['SterCarDesc'];
		if (isEmpty(CarLabel)) {
			$UI.msg('alert', '请选择灭菌架!');
			return;
		}
		SelBarcode(Query, CarLabel, '', 'CAR');
	}
	function Query() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var CarLabel = ParamsObj['SterCarDesc'];
		if (isEmpty(CarLabel)) {
			$UI.msg('alert', '请选择灭菌架!');
			return;
		}
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeCar',
			QueryName: 'SelectByCarLabel',
			CarLabel: CarLabel,
			rows: 9999
		});
		$('#BarCode').focus();
	}

	var MainCm = [[
		{
			title: '',
			field: 'ck',
			checkbox: true,
			frozen: true
		}, {
			field: 'operate',
			title: '操作',
			frozen: true,
			align: 'center',
			width: 50,
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '<div class="col-icon icon-cancel" href="#" title="删除" onclick="MainListGrid.commonDeleteRow(false,' + index + ');"></a>';
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '标签',
			field: 'Label',
			width: 200,
			align: 'left'
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 200,
			align: 'left'
		}, {
			title: '数量',
			field: 'Qty',
			width: 80,
			align: 'right'
		}
	]];

	MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeCar',
			QueryName: 'SelectByCarLabel'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeCar',
			MethodName: 'jsDelete'
		},
		afterDelFn: function() {
			$('#BarCode').focus();
		},
		navigatingWithKey: true,
		columns: MainCm,
		pagination: false,
		singleSelect: false,
		showDelItems: true,
		toolbar: [{
			text: '待灭菌包',
			iconCls: 'icon-add',
			handler: function() {
				AddItem();
			}
		}, {
			text: '刷新',
			iconCls: 'icon-reload',
			handler: function() {
				Query();
			}
		}],
		onLoadSuccess: function(data) {
			$('#BarCode').focus();
		}
	});
	$('#SterCarDesc').combobox('textbox').focus();
};
$(init);