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
			$UI.msg('alert', '��Ӧ���Ҳ���Ϊ��');
			return;
		}
		var Detail = LabelGrid.getRowsData();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '��¼��Ҫ���յı�ǩ��Ϣ');
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
				Common_AddTab('�����Ƶ�', 'cssdhui.callback.packagecallback.csp?RowIdStr=' + MainIdsStr);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	// ɨ�붯��
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
	// �����Ƿ�����༭
	$('#BarCodeSwitchBT').linkbutton({
		iconCls: 'icon-w-switch',
		// plain: true,
		// iconCls: 'icon-key-switch',
		onClick: function() {
			var ReadOnly = $('#BarCode').attr('readonly');		// ֻ��ʱ,��ֵΪ'readonly'
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
	// ����ɨ��ͼ��
	function InitScanIcon() {
		var ElementId = document.activeElement.id;
		var ReadOnly = $('#BarCode').attr('readonly');
		if (ElementId == 'BarCodeHidden') {
			// ɨ��icon
			$('#UseBarCodeBT').linkbutton({ iconCls: 'icon-scanning' });
		} else if (ReadOnly == 'readonly') {
			// ֻ��icon
			$('#UseBarCodeBT').linkbutton({ iconCls: 'icon-gray-edit' });
		} else {
			// �ɱ༭icon
			$('#UseBarCodeBT').linkbutton({ iconCls: 'icon-blue-edit' });
		}
	}
	if (GetLocalStorage('BarCodeHidden') == 'Y') {
		$('#BarCode').attr({ 'readonly': true });
	} else {
		$('#BarCode').attr({ 'readonly': false });
	}
	
	// ����ֵ�Ĵ���
	function ReturnInfoFunc() {
		var ParamObj = $UI.loopBlock('#Conditions');
		if (isEmpty(ParamObj.SupLoc)) {
			$UI.msg('alert', '��Ӧ���Ҳ���Ϊ��');
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
				$UI.msg('alert', '��ɨ��!');
				return;
			} else if (Label == PackageLabel) {
				$UI.msg('alert', '��ɨ��!');
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
			title: '����',
			frozen: true,
			align: 'center',
			width: 50,
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '';// �˴�commonDeleteRow����ͨ����indexɾ����
				str = str + '<div href="#" class="col-icon icon-cancel" title="ɾ��" onclick="LabelGrid.commonDeleteRow(true)"></div>';
				return str;
			}
		}, {
			title: '���տ���',
			field: 'ReqLocId',
			width: 130,
			formatter: CommonFormatter(CallBackCombox, 'ReqLocId', 'ReqLocDesc'),
			editor: CallBackCombox
		}, {
			title: '����������',
			field: 'PackageName',
			width: 150
		}, {
			title: '����������',
			field: 'packageDesc',
			width: 150,
			hidden: true
		}, {
			title: '������rowid',
			field: 'PackageDR',
			width: 130,
			hidden: true
		}, {
			title: '����',
			field: 'DictLabel',
			width: 100,
			align: 'left'
		}, {
			title: '��ǩ',
			field: 'PackageLabel',
			width: 150,
			align: 'left'
		}, {
			title: '��������',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '����ҽ��',
			field: 'oprDoctor',
			width: 80
		}, {
			title: '��㻤ʿ',
			field: 'instNurse',
			width: 80
		}, {
			title: 'Ѳ�ػ�ʿ',
			field: 'circNurse',
			width: 80
		}, {
			title: '��Ⱦ��Ϣ',
			field: 'infectName',
			width: 150
		}, {
			title: '���ʱ��',
			field: 'oprDt',
			width: 160
		}, {
			title: '������',
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