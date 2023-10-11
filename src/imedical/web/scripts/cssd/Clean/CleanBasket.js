var MainListGrid;
var init = function() {
	var ParamsTB = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	var PackTypeDetail = '3';
	$HUI.combobox('#CleanBasket', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllSterCar&ResultSetType=array&PackTypeDetail=' + PackTypeDetail + '&Params=' + ParamsTB,
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'Code',
		onSelect: function(record) {
			Query();
		}
	});

	$('#CleanBasket').combobox('textbox').keyup(function(event) {
		if (event.which === 13) {
			var BasketVal = $('#CleanBasket').combobox('getText');
			if (BasketVal !== '') {
				var CleanObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetSterCar',
					type: '3',
					SterCar: BasketVal,
					Params: ParamsTB
				}, false);
				if (isEmpty(CleanObj['DictId'])) {
					$UI.msg('alert', '未获取到可用的清洗架！');
					$('#CleanBasket').combobox('setValue', '');
					$('#CleanBasket').combobox('textbox').focus();
					return;
				}
				$('#CleanBasket').combobox('setValue', CleanObj['DictId']);
				Query();
			}
		}
	});
	
	var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TypeDetail: '2' }));
	$HUI.combobox('#CommonPkg', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams,
		valueField: 'RowId',
		textField: 'Description',
		spellField: 'Code'
	});

	// 回收单
	$UI.linkbutton('#AddCallBackBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var BasketLabel = ParamsObj['CleanBasket'];
			var Params = JSON.stringify(addSessionParams(ParamsObj));
			if (isEmpty(BasketLabel)) {
				$UI.msg('alert', '请输入清洗架！');
				return;
			}
			CallBackCleanOrdWin(Query, Params);
		}
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	
	$UI.linkbutton('#ComPkgCreateBT', {
		onClick: function() {
			CommonPackageAdd();
		}
	});
	
	function CommonPackageAdd() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var BasketLabel = ParamsObj['CleanBasket'];
		var PackageId = ParamsObj['CommonPkg'];
		var Num = ParamsObj['ComPkgNum'];
		var Params = JSON.stringify(addSessionParams(ParamsObj));
		if (isEmpty(BasketLabel)) {
			$UI.msg('alert', '请输入清洗架！');
			return;
		}
		if (isEmpty(PackageId)) {
			$UI.msg('alert', '请选择需要添加的普通循环包!');
			return;
		}
		if (parseInt(Num) <= 0) {
			$UI.msg('alert', '请输入合适的数量!');
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Clean.CleanBasket',
			MethodName: 'JsSaveCommonPackage',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				MainListGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
			$('#CommonPkg').combobox('setValue', '');
			$('#ComPkgNum').numberbox('setValue', '');
		});
	}
	// 扫码动作
	$('#BarCode').keyup(function(event) {
		if (event.which === 13) {
			SaveBasketDetail();
		}
	}).focus(function(event) {
		$('#BarCode').val('');
		$('#BarCodeHidden').val('');
		var ReadOnly = $('#BarCode').attr('readonly');
		if (ReadOnly === 'readonly') {
			$('#BarCodeHidden').focus();
		}
		InitScanIcon();
	}).blur(function(event) {
		InitScanIcon();
	});

	$('#BarCodeHidden').keyup(function(event) {
		if (event.which === 13) {
			var HiddenVal = $('#BarCodeHidden').val();
			$('#BarCode').val(HiddenVal);
			$('#BarCodeHidden').val('');
			SaveBasketDetail();
		}
	}).focus(function(enent) {
		InitScanIcon();
	}).blur(function(event) {
		InitScanIcon();
	});

	// 控制是否允许编辑
	$('#BarCodeSwitchBT').linkbutton({
		iconCls: 'icon-w-switch',
		onClick: function() {
			var ReadOnly = $('#BarCode').attr('readonly');
			if (ReadOnly === 'readonly') {
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
		if (ElementId === 'BarCodeHidden') {
			// 扫描icon
			$('#UseBarCodeBT').linkbutton({ iconCls: 'icon-scanning' });
		} else if (ReadOnly === 'readonly') {
			// 只读icon
			$('#UseBarCodeBT').linkbutton({ iconCls: 'icon-gray-edit' });
		} else {
			// 可编辑icon
			$('#UseBarCodeBT').linkbutton({ iconCls: 'icon-blue-edit' });
		}
	}
	if (GetLocalStorage('BarCodeHidden') === 'Y') {
		$('#BarCode').attr({ 'readonly': true });
	} else {
		$('#BarCode').attr({ 'readonly': false });
	}
	InitScanIcon();
	
	function SaveBasketDetail() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var basketLabel = ParamsObj['CleanBasket'];
		var Params = JSON.stringify(addSessionParams(ParamsObj));
		if (isEmpty(basketLabel)) {
			$UI.msg('alert', '请输入清洗架！');
			return;
		}
		if (isEmpty(ParamsObj.BarCode)) {
			$UI.msg('alert', '未获取到扫描的标牌！');
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Clean.CleanBasket',
			MethodName: 'jsSaveCleanBasket',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				MainListGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
			$('#BarCode').val('');
		});
	}
	
	function saveMast() {
		var Rows = MainListGrid.getChangesData();
		if (isEmpty(Rows)) {
			return;
		}
		if (Rows === false) {
			$UI.msg('alert', '存在未填写的必填项，不能保存!');
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Clean.CleanBasket',
			MethodName: 'jsSave',
			Params: JSON.stringify(Rows)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				MainListGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	function Query() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var CleanBasketLabel = ParamsObj['CleanBasket'];
		if (isEmpty(CleanBasketLabel)) {
			$UI.msg('alert', '请选择清洗架！');
			return;
		}
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.Clean.CleanBasket',
			QueryName: 'SelectCleanBasketInfo',
			BasketLabel: CleanBasketLabel,
			rows: 9999999999
		});
		$('#BarCode').focus();
	}

	var MainCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			field: 'operate',
			title: '操作',
			align: 'center',
			width: 50,
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '<div class="icon-cancel col-icon"  href="#"  title="删除" onclick="MainListGrid.commonDeleteRow(true,' + index + ');"></div>';
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '清洗架',
			field: 'BasketDesc',
			width: 150
		}, {
			title: '标牌',
			field: 'PkgLabel',
			width: 150
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 200
		}, {
			title: '数量',
			field: 'Qty',
			width: 100,
			align: 'right',
			editor: { type: 'numberbox', options: { min: 1 }}
		}, {
			title: '回收单号',
			field: 'BackNo',
			width: 200
		}, {
			title: '科室',
			field: 'BackLocDesc',
			width: 200
		}
	]];
	
	MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanBasket',
			QueryName: 'SelectCleanBasketInfo'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanBasket',
			MethodName: 'jsDelete'
		},
		navigatingWithKey: true,
		columns: MainCm,
		pagination: false,
		singleSelect: false,
		toolbar: [{
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() {
				MainListGrid.commonDeleteRow();
			}
		}, {
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				saveMast();
			}
		}],
		afterDelFn: function() {
			$('#BarCode').focus();
		},
		onClickRow: function(index, row) {
			var Id = row.RowId;
			if (row.BackNo !== '' && Id) {
				return false;
			}
			if (row.PkgLabel !== '' && Id) {
				return false;
			}
			MainListGrid.commonClickRow(index, row);
		},
		onBeforeEdit: function(index, row) {
			if (row.BackNo !== '' && row.RowId) {
				return false;
			}
			if (row.PkgLabel !== '' && row.RowId) {
				return false;
			}
		},
		onLoadSuccess: function(data) {
			$('#BarCode').focus();
			GetMarkQty();
		}
	});
	function GetMarkQty() {
		var ParamsObj = {};
		ParamsObj.StartDate = DefaultStDate();
		ParamsObj.EndDate = DefaultEdDate();
		var Params = JSON.stringify(addSessionParams(ParamsObj));
		var MarkQtyObj = $.cm({
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			MethodName: 'GetMarkQty',
			Params: Params
		}, false);
		$('#CallBackNum').html(MarkQtyObj.CallBackNum);
	}
	
	var Default = function() {
		$('#CleanBasket').focus();
	};
	Default();
	GetMarkQty();
};
$(init);