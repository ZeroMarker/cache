var LabelGrid;

var init = function() {
	var LocParams = JSON.stringify(addSessionParams({ Type: 'Login', BDPHospital: gHospId }));
	$HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			$('#BarCode').val('').focus();
		}
	});
	
	var CallBackLocParams = JSON.stringify(addSessionParams({ Type: 'RecLoc' }));
	var CallBackCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + CallBackLocParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = LabelGrid.getRows();
				var row = rows[LabelGrid.editIndex];
				row.ReqLocDesc = record.Description;
			}
		}
	};
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	function Clear() {
		DefaultData();
	}
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			SaveLabel();
		}
	});
	function SaveLabel() {
		var Main = $UI.loopBlock('#Conditions');
		if (isEmpty(Main.SupLoc)) {
			$UI.msg('alert', '供应科室不能为空');
			return;
		}
		var Detail = LabelGrid.getRowsData();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '请录入要回收的标签信息');
			$('#BarCode').val('').focus();
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.CallBack.CallBack',
			MethodName: 'jsCallBackOPRByLabel',
			Main: JSON.stringify(Main),
			Detail: JSON.stringify(Detail)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Clear();
				var MainIdsStr = jsonData.rowid;
				Common_AddTab('回收制单', 'cssdhui.callback.packagecallback.csp?RowIdStr=' + MainIdsStr);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	// 扫码动作
	$('#BarCode').keyup(function(event) {
		if (event.which == 13) {
			ReturnInfoFunc();
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
			ReturnInfoFunc();
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
	
	// 返回值的处理
	function ReturnInfoFunc() {
		var ParamObj = $UI.loopBlock('#Conditions');
		if (isEmpty(ParamObj.SupLoc)) {
			$UI.msg('alert', '供应科室不能为空');
			return;
		}
		var Label = $('#BarCode').val();
		if (isEmpty(Label)) {
			return;
		}
		var RowData = LabelGrid.getRows();
		var Len = RowData.length;
		for (var i = 0; i < Len; i++) {
			var row = RowData[i];
			var DictLabel = row['DictLabel'];
			var PackageLabel = row['PackageLabel'];
			if (Label == DictLabel) {
				$UI.msg('alert', '已扫描!');
				return;
			} else if (Label == PackageLabel) {
				$UI.msg('alert', '已扫描!');
				return;
			}
		}
		ParamObj.Label = Label;
		var LabelInfo = $.cm({
			ClassName: 'web.CSSDHUI.CallBack.CallBack',
			MethodName: 'GetCallBackLabelInfo',
			Params: JSON.stringify(ParamObj)
		}, false);
		if (!isEmpty(LabelInfo['Err'])) {
			$('#BarCode').val('');
			$('#BarCode').focus();
			$UI.msg('alert', LabelInfo['Err']);
			return;
		}
		var DefaData = {
			ReqLocId: LabelInfo['ReqLocId'],
			ReqLocDesc: LabelInfo['ReqLocDesc'],
			PackageLabel: LabelInfo['PackageLabel'],
			PackageName: LabelInfo['PackageName'],
			packageDesc: LabelInfo['packageDesc'],
			PackageDR: LabelInfo['PackageDR'],
			DictLabel: LabelInfo['DictLabel'],
			Qty: LabelInfo['Qty'],
			oprDoctor: LabelInfo['oprDoctor'],
			instNurse: LabelInfo['instNurse'],
			circNurse: LabelInfo['circNurse'],
			infectName: LabelInfo['infectName'],
			PackTypeDetail: LabelInfo['PackTypeDetail'],
			oprDt: LabelInfo['oprDt']
		};
		LabelGrid.commonAddRow(DefaData);
		$('#SupLoc').combobox('disable');
		$('#BarCode').val('').focus();
	}
	
	var LabelGridCm = [[
		{
			field: 'operate',
			title: '操作',
			frozen: true,
			align: 'center',
			width: 50,
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '';// 此处commonDeleteRow不能通过传index删除行
				str = str + '<div href="#" class="col-icon icon-cancel" title="删除" onclick="LabelGrid.commonDeleteRow(true)"></div>';
				return str;
			}
		}, {
			title: '回收科室',
			field: 'ReqLocId',
			width: 130,
			formatter: CommonFormatter(CallBackCombox, 'ReqLocId', 'ReqLocDesc'),
			editor: CallBackCombox
		}, {
			title: '消毒包名称',
			field: 'PackageName',
			width: 150
		}, {
			title: '消毒包名称',
			field: 'packageDesc',
			width: 150,
			hidden: true
		}, {
			title: '消毒包rowid',
			field: 'PackageDR',
			width: 130,
			hidden: true
		}, {
			title: '标牌',
			field: 'DictLabel',
			width: 100,
			align: 'left'
		}, {
			title: '标签',
			field: 'PackageLabel',
			width: 150,
			align: 'left'
		}, {
			title: '回收数量',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '手术医生',
			field: 'oprDoctor',
			width: 80
		}, {
			title: '清点护士',
			field: 'instNurse',
			width: 80
		}, {
			title: '巡回护士',
			field: 'circNurse',
			width: 80
		}, {
			title: '感染信息',
			field: 'infectName',
			width: 150
		}, {
			title: '清点时间',
			field: 'oprDt',
			width: 160
		}, {
			title: '包属性',
			field: 'PackTypeDetail',
			width: 80,
			hidden: true
		}
	]];
	LabelGrid = $UI.datagrid('#LabelGrid', {
		columns: LabelGridCm,
		queryParams: {
			ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
			QueryName: 'SelectByF',
			rows: 99999
		},
		onClickRow: function(index, row) {
			var Id = row.RowId;
			if ((row.PackageLabel != '') && (Id)) {
				return false;
			}
			LabelGrid.commonClickRow(index, row);
		},
		pagination: false
	});
	
	var DefaultData = function() {
		$UI.clearBlock('#Conditions');
		$UI.clear(LabelGrid);
		$('#SupLoc').combobox('enable');
		var DefaultValue = {
			SupLoc: gLocId
		};
		$UI.fillBlock('#Conditions', DefaultValue);
		$('#BarCode').val('').focus();
	};
	InitScanIcon();
	DefaultData();
};
$(init);