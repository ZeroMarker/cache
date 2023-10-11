// ˫ǩ�ֱ�־����
gHVSignFlag = typeof (gHVSignFlag) === 'undefined' ? '' : gHVSignFlag;
var ToLocNewValue = '', ToLocOldValue = '', ScgValue = '', FrLocId = '';

var init = function() {
	var LimitAmtCol = (InitParamObj.UseLocLimitAmt == 'Y' ? false : true);
	
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			var HvFlag = 'Y';
			FindWin(Select, gHVSignFlag, HvFlag);
		}
	});
	
	function Select(RowId) {
		$UI.clearBlock('#Conditions');
		$UI.clear(DetailGrid);
		ScgValue = '';
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'Select',
			Init: RowId
		}, function(jsonData) {
			$UI.fillBlock('#Conditions', jsonData);
			SetEditDisable();
			var InitComp = jsonData['InitComp'];
			var InitState = jsonData['InitState'];
			if (InitComp == 'Y') {
				if (InitState == '21') {
					var BtnEnaleObj = { '#SaveBT': false, '#DeleteBT': false, '#CompleteBT': false,
						'#CancelCompBT': false, '#AuditOutYesBT': false, '#AuditInYesBT': true };
				} else if (InitState == '31') {
					var BtnEnaleObj = { '#SaveBT': false, '#DeleteBT': false, '#CompleteBT': false,
						'#CancelCompBT': false, '#AuditOutYesBT': false, '#AuditInYesBT': false };
				} else {
					var BtnEnaleObj = { '#SaveBT': false, '#DeleteBT': false, '#CompleteBT': false,
						'#CancelCompBT': true, '#AuditOutYesBT': true, '#AuditInYesBT': false };
				}
			} else {
				var BtnEnaleObj = { '#SaveBT': true, '#DeleteBT': true, '#CompleteBT': true,
					'#CancelCompBT': false, '#AuditOutYesBT': false, '#AuditInYesBT': false };
			}
			ChangeButtonEnable(BtnEnaleObj);
		});
		
		var ParamsObj = { Init: RowId };
		var Params = JSON.stringify(ParamsObj);
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD',
			query2JsonStrict: 1,
			Params: Params,
			rows: 99999,
			totalFooter: '"InciCode":"�ϼ�"',
			totalFields: 'RpAmt,SpAmt'
		});
	}
	
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var MainObj = $UI.loopBlock('#Conditions');
			if (MainObj['InitComp'] == 'Y') {
				$UI.msg('alert', '�õ����Ѿ����,�����ظ�����!');
				return;
			}
			if (isEmpty(MainObj['InitFrLoc'])) {
				$UI.msg('alert', '������Ҳ���Ϊ��!');
				return;
			}
			if (isEmpty(MainObj['InitToLoc'])) {
				$UI.msg('alert', '���տ��Ҳ���Ϊ��!');
				return;
			}
			if (MainObj['InitFrLoc'] == MainObj['InitToLoc']) {
				$UI.msg('alert', '������Ҳ���������տ�����ͬ!');
				return;
			}
			MainObj['InitState'] = '10';
			MainObj['InitType'] = 'T';
			var Main = JSON.stringify(MainObj);
			var Detail = DetailGrid.getChangesData('Inclb');
			if (Detail === false) {	// δ��ɱ༭����ϸΪ��
				return;
			}
			// �ж�
			var ifChangeMain = $UI.isChangeBlock('#MainObj');
			if (!ifChangeMain && (isEmpty(Detail))) {	// ��������ϸ����
				$UI.msg('alert', 'û����Ҫ�������Ϣ!');
				return;
			}
			var InStkTkParamObj = GetAppPropValue('DHCSTINSTKTKM');
			if (InStkTkParamObj.AllowBusiness != 'Y') {
				var IfFrLocExistInStkTk = tkMakeServerCall('web.DHCSTMHUI.INStkTk', 'CheckInStkTkByLoc', MainObj['InitFrLoc']);
				if (IfFrLocExistInStkTk == 'Y') {
					$UI.msg('alert', '������Ҵ���δ��ɵ��̵㵥��������!');
					return false;
				}
				var IfToLocExistInStkTk = tkMakeServerCall('web.DHCSTMHUI.INStkTk', 'CheckInStkTkByLoc', MainObj['InitToLoc']);
				if (IfToLocExistInStkTk == 'Y') {
					$UI.msg('alert', '���տ��Ҵ���δ��ɵ��̵㵥��������!');
					return false;
				}
			}
			var RowsData = DetailGrid.getRows();
			var count = 0;
			for (var i = 0; i < RowsData.length; i++) {
				var HVBarCode = RowsData[i].HVBarCode;
				var inclb = RowsData[i].Inclb;
				if (!isEmpty(HVBarCode) && (!isEmpty(inclb))) {
					count++;
				}
			}
			if ((RowsData.length <= 0 || count <= 0)) {
				$UI.msg('alert', '��������ϸ!');
				return false;
			}
			if (((RowsData.length - 1) > count)) {
				$UI.msg('alert', '����ϸ������,����������Ϣ����!');
				return false;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
				MethodName: 'jsSave',
				Main: Main,
				Detail: JSON.stringify(Detail)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					var InitId = jsonData.rowid;
					Select(InitId);
					if (InitParamObj['AutoPrintAfterSave'] == 'Y') {
						PrintInIsTrf(InitId, 'Y');
					}
					if (InitParamObj['ConfirmCompAfterSave'] == 'Y') {
						$UI.confirm('�Ƿ����?', '', '', Complete);
					}
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	function Complete() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var InitId = ParamsObj['RowId'];
		if (isEmpty(InitId)) {
			return;
		}
		var InitComp = ParamsObj['InitComp'];
		if (InitComp == 'Y') {
			$UI.msg('alert', '�õ��������,�����ظ�����!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		var AutoAuditFlag = gHVSignFlag == 'Y' ? 'N' : '';	// ˫ǩ�ֹ���,�������Զ����
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'jsSetCompleted',
			Params: Params,
			AutoAuditFlag: AutoAuditFlag
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				var InitId = jsonData.rowid;
				Select(InitId);
				// $('#InitComp').checkbox('setValue', true);
				//				var BtnEnaleObj = {'#SaveBT':false, '#DeleteBT':false, '#CompleteBT':false,
				//					'#CancelCompBT':true, '#AuditOutYesBT':true, '#AuditInYesBT':false};
				//				ChangeButtonEnable(BtnEnaleObj);
				// ��ɺ��Զ���ӡ �� ��ɺ��Զ�������ˣ�������˺��Զ���ӡ
				if ((InitParamObj.AutoPrintAfterComp == 'Y') || (InitParamObj.AutoAckOutAfterCompleted == 'Y' && InitParamObj.AutoPrintAfterAckOut == 'Y')) {
					PrintInIsTrf(InitId, 'Y');
				}
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	// ���ǰ�ض��ж���ʾ
	function CheckDataBeforeComplete() {
		var MainObj = $UI.loopBlock('#Conditions');
		var InitId = MainObj.RowId;
		if (isEmpty(InitId)) {
			$UI.msg('alert', '����Ҫ����ĵ���');
			return false;
		}
		var rowData = DetailGrid.getRows();
		var rowCount = rowData.length;
		if (rowCount < 1) {
			$UI.msg('alert', '�õ���û����ϸ!');
			return false;
		}
		// �ж��޶�
		if (InitParamObj.UseLocLimitAmt == 'Y') {
			var LimitAmtInfo = $.cm({
				ClassName: 'web.DHCSTMHUI.LocLimitAmt',
				MethodName: 'GetLimitAmtByInit',
				InitId: InitId
			}, false);
			if (!isEmpty(LimitAmtInfo.success) && LimitAmtInfo.success != 0) {
				return true;
			}
			var ResultLoc = LimitAmtInfo.ResultLoc;
			var ResultScg = LimitAmtInfo.ResultScg;
			var ResultCat = LimitAmtInfo.ResultCat;
			var ResultInci = LimitAmtInfo.ResultInci;
			var ResultInciQty = LimitAmtInfo.ResultInciQty;
			var ResultInciOnceQty = LimitAmtInfo.ResultInciOnceQty;
			var Msg = '';
			if (!isEmpty(ResultLoc)) {
				Msg = Msg + '����:(' + ResultLoc + ')�������޶';
			}
			if (!isEmpty(ResultScg)) {
				Msg = Msg + '����:(' + ResultScg + ')�����޶';
			}
			if (!isEmpty(ResultCat)) {
				Msg = Msg + '������:(' + ResultCat + ')�����޶';
			}
			if (!isEmpty(ResultInci)) {
				Msg = Msg + 'Ʒ��:(' + ResultInci + ')�����޶';
			}
			if (!isEmpty(ResultInciQty)) {
				Msg = Msg + 'Ʒ��:(' + ResultInciQty + ')����������';
			}
			if (!isEmpty(ResultInciOnceQty)) {
				Msg = Msg + '(Ʒ��:' + ResultInciOnceQty + ')��������������';
			}
			if (!isEmpty(Msg)) {
				$UI.confirm('��ʱ����� ' + Msg + ' �Ƿ����?', '', '', Complete);
			} else {
				Complete();
			}
		} else {
			Complete();
		}
	}
	$UI.linkbutton('#CompleteBT', {
		onClick: function() {
			CheckDataBeforeComplete();
		}
	});
	$UI.linkbutton('#CancelCompBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if (isEmpty(InitId)) {
				return;
			}
			var InitComp = ParamsObj['InitComp'];
			if (InitComp != 'Y') {
				$UI.msg('alert', '�õ��ݲ������״̬,���ɲ���!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
				MethodName: 'jsCancelComplete',
				Params: Params
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					var InitId = jsonData.rowid;
					Select(InitId);
					// $('#InitComp').checkbox('setValue', false);
					//					var BtnEnaleObj = {'#SaveBT':true, '#DeleteBT':true, '#CompleteBT':true,
					//						'#CancelCompBT':false, '#AuditOutYesBT':false, '#AuditInYesBT':false};
					//					ChangeButtonEnable(BtnEnaleObj);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#DeleteBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if (isEmpty(InitId)) {
				return;
			}
			var InitComp = ParamsObj['InitComp'];
			if (InitComp == 'Y') {
				$UI.msg('alert', '�õ����Ѿ����,����ɾ��!');
				return;
			}
			$UI.confirm('����Ҫɾ������,�Ƿ����?', '', '', Delete);
		}
	});
	function Delete() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var Params = JSON.stringify(ParamsObj);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'jsDelete',
			Params: Params
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				Clear();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(DetailGrid);
		SetDefaValues();
		var BtnEnaleObj = { '#SaveBT': true, '#DeleteBT': false, '#CompleteBT': false,
			'#CancelCompBT': false, '#AuditOutYesBT': false, '#AuditInYesBT': false };
		ChangeButtonEnable(BtnEnaleObj);
		SetEditEnable();
	}
	function SetEditDisable() {
		$HUI.combobox('#InitFrLoc').disable();
		$HUI.combobox('#InitToLoc').disable();
		$HUI.combobox('#InitScg').disable();
	}
	function SetEditEnable() {
		$HUI.combobox('#InitFrLoc').enable();
		$HUI.combobox('#InitToLoc').enable();
		$HUI.combobox('#InitScg').enable();
	}
	
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if (isEmpty(InitId)) {
				$UI.msg('alert', '��ѡ����Ҫ��ӡ�ĵ���!');
				return;
			}
			if (InitParamObj['PrintNoComplete'] == 'N' && ParamsObj['InitComp'] != 'Y') {
				$UI.msg('warning', '�������ӡδ��ɵ�ת�Ƶ�!');
				return;
			}
			PrintInIsTrf(InitId);
		}
	});
	
	$UI.linkbutton('#PrintHVColBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if (isEmpty(InitId)) {
				$UI.msg('alert', '��ѡ����Ҫ��ӡ�ĵ���!');
				return;
			}
			if (InitParamObj['PrintNoComplete'] == 'N' && ParamsObj['InitComp'] != 'Y') {
				$UI.msg('warning', '�������ӡδ��ɵ�ת�Ƶ�!');
				return;
			}
			PrintInIsTrfHVCol(InitId);
		}
	});
	
	$UI.linkbutton('#SelReqBT', {
		onClick: function() {
			SelReq(QueryTrans, getlistReq, 'Y'); // ��ֵ��־
		}
	});
	function getlistReq(MainObj, ReqId) {
		SetEditDisable();
		var MainParamObj = $UI.loopBlock('#Conditions');
		if (MainParamObj.ReqId == ReqId) {
			$UI.msg('alert', '�����쵥�Ѵ���!');
			return;
		}
		if ((!isEmpty(MainParamObj.ReqId)) && (MainParamObj.ReqId != ReqId)) { // �µ����쵥�������
			Clear();
		}
		// ������ϸ����
		var DetailParamsObj = { ReqId: ReqId };
		var DetailParams = JSON.stringify(DetailParamsObj);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfFromReq',
			query2JsonStrict: 1,
			Params: DetailParams,
			rows: 99999
		}, function(jsonData) {
			if (jsonData.total == 0) {
				$UI.msg('alert', 'û�������������������!');
				return false;
			} else {
				DetailGrid.loadData(jsonData);
				$UI.fillBlock('#Conditions', MainObj);
			}
		});
	}
	function QueryTrans(InitStr) {
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'QueryTrans',
			query2JsonStrict: 1,
			InitStr: InitStr,
			rows: 99999
		});
	}
	
	$UI.linkbutton('#AuditOutYesBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if (isEmpty(InitId)) {
				$UI.msg('alert', '��ѡ����˵�ת�Ƶ�!');
				return;
			}
			var LocId = $HUI.combobox('#InitFrLoc').getValue();
			var UserCode = session['LOGON.USERCODE'];
			var ParamsObj = { LocId: LocId, UserId: gUserId, UserCode: UserCode };
			VerifyPassWord(ParamsObj, AuditOutYes);
		}
	});
	function AuditOutYes(OperUserId) {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var InitId = ParamsObj['RowId'];
		if (isEmpty(InitId)) {
			return;
		}
		var InitComp = ParamsObj['InitComp'];
		if (InitComp == false) {
			$UI.msg('alert', 'ת�Ƶ���δ���!');
			return;
		}
		// ����ֵ���ϱ�ǩ¼�����
		if (CheckHighValueLabels('T', InitId) == false) {
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'jsTransOutAuditYesStr',
			InitStr: InitId,
			UserId: OperUserId,
			GroupId: gGroupId,
			AutoAuditInFlag: 'N'
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', '��˳ɹ�!');
				Select(InitId);
				if (InitParamObj['AutoPrintAfterAckOut'] == 'Y') {
					PrintInIsTrf(InitId, 'Y');
				}
			} else {
				$UI.msg('error', jsonData.msg);
			}
			hideMask();
		});
	}
	
	$UI.linkbutton('#AuditInYesBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if (isEmpty(InitId)) {
				$UI.msg('alert', '��ѡ����յ�ת�Ƶ�');
				return;
			}
			var LocId = $HUI.combobox('#InitToLoc').getValue();
			var UserId = $HUI.combobox('#InitReqUser').getValue();
			var UserName = $HUI.combobox('#InitReqUser').getText();
			var UserCode = '';
			if (!isEmpty(UserId) && !isEmpty(UserName)) {
				try {
					UserCode = UserName.split('[')[1].split(']')[0];
				} catch (e) {}
				if (UserCode == '') {
					UserId = '';
				}
			}
			var ParamObj = { LocId: LocId, UserId: UserId, UserCode: UserCode };
			VerifyPassWord(ParamObj, AuditInYes);
		}
	});
	function AuditInYes(OperUserId) {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var InitId = ParamsObj['RowId'];
		if (isEmpty(InitId)) {
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'jsTransInAuditYes',
			Init: InitId,
			UserId: OperUserId
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				Select(InitId);
				if (InitParamObj['AutoPrintAfterAckIn'] == 'Y') {
					PrintInIsTrf(InitId, 'Y');
				}
			} else {
				$UI.msg('error', jsonData.msg);
			}
			hideMask();
		});
	}
	
	function ReturnInfoFuncInci(rows) {
		rows = [].concat(rows);
		if (rows == null || rows == '') {
			return;
		}
		$.each(rows, function(index, row) {
			var RowIndex = DetailGrid.editIndex;
			var FindIndex = DetailGrid.find('HVBarCode', row.HVBarCode);
			if (FindIndex >= 0 && FindIndex != RowIndex) {
				$UI.msg('alert', row.HVBarCode + '���벻���ظ�¼��!');
				return;
			}
			DetailGrid.updateRow({
				index: DetailGrid.editIndex,
				row: {
					HVBarCode: row.HVBarCode,
					dhcit: row.dhcit,
					InciId: row.InciDr,
					InciCode: row.InciCode,
					InciDesc: row.InciDesc,
					Spec: row.Spec,
					Inclb: row.Inclb,
					BatExp: row.BatExp,
					UomId: row.PurUomId,
					UomDesc: row.PurUomDesc,
					SterilizedBat: row.SterilizedBat,
					Rp: row.Rp,
					Sp: row.Sp,
					RpAmt: row.Rp,
					SpAmt: row.Sp,
					ReqLocStkQty: row.RequrstStockQty,
					InclbQty: row.InclbQty,
					InclbDirtyQty: row.DirtyQty,
					Qty: 1,
					ManfDesc: row.Manf,
					SpecDesc: row.SpecDesc,
					MatInsuCode: row.MatInsuCode,
					MatInsuDesc: row.MatInsuDesc
				}
			});
			$('#DetailGrid').datagrid('refreshRow', RowIndex);
			DetailGrid.setFooterInfo();
			if (index < rows.length) {
				DetailGrid.commonAddRow();
			}
		});
	}
	
	var InitFrLoc = $HUI.combobox('#InitFrLoc', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({ Type: 'Login', Element: 'InitFrLoc' })),
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			FrLocId = record['RowId'];
			$('#InitToLoc').combobox('clear');
			$('#InitToLoc').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
				+ JSON.stringify(addSessionParams({
					Type: 'Trans',
					LocId: FrLocId,
					TransLocType: 'T',
					Element: 'InitFrLoc'
				})));
			var ToLoc = InitToLoc.getValue();
			$HUI.combotree('#InitScg').setFilterByLoc(FrLocId, ToLoc);
		}
	});
	$('#InitFrLoc').combobox('setValue', session['LOGON.CTLOCID']);
	
	var VirtualFlag = $HUI.checkbox('#VirtualFlag', {
		onCheckChange: function(e, value) {
			if (value) {
				var FrLoc = $('#InitFrLoc').combobox('getValue');
				var Info = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon', 'GetMainLoc', FrLoc);
				var InfoArr = Info.split('^');
				var VituralLoc = InfoArr[0], VituralLocDesc = InfoArr[1];
				AddComboData($('#InitFrLoc'), VituralLoc, VituralLocDesc);
				$('#InitFrLoc').combobox('setValue', VituralLoc);
			} else {
				$('#InitFrLoc').combobox('setValue', gLocId);
			}
		}
	});
	
	var InitToLoc = $HUI.combobox('#InitToLoc', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({ Type: 'Trans', LocId: FrLocId, TransLocType: 'T', Element: 'InitToLoc' })),
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var AllowFlag = AllowToLocChange(ToLocNewValue);
			if (AllowFlag == false) {
				$UI.msg('alert', '���տ���ȱ����ϸ���ʵ�����Ȩ��,�������޸�');
				$('#InitToLoc').combobox('setValue', ToLocOldValue);
			} else {
				var FrLoc = InitFrLoc.getValue();
				var ToLoc = InitToLoc.getValue();
				$('#InitReqUser').combobox('clear');
				$('#InitReqUser').combobox('reload', $URL
					+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=Array&Params='
					+ JSON.stringify({ LocDr: ToLoc })
				);
				var InitScg = $('#InitScg').combotree('getValue');
				$HUI.combotree('#InitScg').setFilterByLoc(FrLoc, ToLoc);
				if (DetailGrid.getRows().length > 0) {
					$('#InitScg').combotree('setValue', InitScg);
				}
			}
		},
		onChange: function(newValue, oldValue) {
			ToLocNewValue = newValue;
			ToLocOldValue = oldValue;
		}
	});
	// �ж��Ƿ�����޸Ľ��տ���
	function AllowToLocChange(newLocId) {
		var RowData = DetailGrid.getRows();
		var RowLength = RowData.length;
		var inciStr = '';
		for (var i = 0; i < RowLength; i++) {
			var Inci = RowData[i].InciId;
			if (isEmpty(Inci)) { continue; }
			if (inciStr == '') { inciStr = Inci; } else { inciStr = inciStr + ',' + Inci; }
		}
		if (inciStr != '') {
			var AllowFlag = tkMakeServerCall('web.DHCSTMHUI.Common.DrugInfoCommon', 'CheckLocIncludeInciScg', newLocId, inciStr);
			if (AllowFlag != 0) { return false; }
		}
		return true;
	}
	
	$('#InitScg').combotree({
		onSelect: function(record) {
			if (ScgValue != '') {
				var tmpScg = ScgValue.split('-')[1];
				ScgValue = '';
				$UI.msg('alert', '�Ѵ���������ϸ,�������޸�');
				$('#InitScg').combotree('setValue', tmpScg);
			}
		}
	});
	
	var InitReqUser = $HUI.combobox('#InitReqUser', {
		url: '',
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var OperateType = $HUI.combobox('#OperateType', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOperateType&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({ Type: 'OM' })),
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var InitState = $('#InitState').simplecombobox({
		data: [
			{ RowId: '10', Description: 'δ���' },
			{ RowId: '11', Description: '�����' },
			{ RowId: '20', Description: '������˲�ͨ��' },
			{ RowId: '21', Description: '�������ͨ��' },
			{ RowId: '30', Description: '�ܾ�����' },
			{ RowId: '31', Description: '�ѽ���' }
		]
	});
	
	var DetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			saveCol: true,
			width: 80,
			hidden: true
		}, {
			title: 'InciId',
			field: 'InciId',
			width: 80,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 120
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 180,
			jump: false,
			editor: (InitParamObj.SelBarcodeByInci != 'Y' ? true : false) ? null : {
				type: 'validatebox',
				options: {
					
				}
			}
		}, {
			title: 'dhcit',
			field: 'dhcit',
			width: 80,
			hidden: true
		}, {
			title: '��ֵ����',
			field: 'HVBarCode',
			saveCol: true,
			jump: false,
			editor: {
				type: 'validatebox',
				options: {
					required: true,
					tipPosition: 'bottom'
				}
			},
			width: 150
		}, {
			title: '���',
			field: 'Spec',
			width: 80
		}, {
			title: 'Inclb',
			field: 'Inclb',
			saveCol: true,
			width: 80,
			hidden: true
		}, {
			title: '����~Ч��',
			field: 'BatExp',
			width: 200
		}, {
			title: '��������',
			field: 'ManfDesc',
			width: 160
		}, {
			title: '���ο��',
			field: 'InclbQty',
			align: 'right',
			width: 80
		}, {
			title: '��������',
			field: 'Qty',
			saveCol: true,
			align: 'right',
			width: 80,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					min: 0,
					precision: 0
				}
			}
		}, {
			title: '��λId',
			field: 'UomId',
			saveCol: true,
			width: 50,
			hidden: true
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 50
		}, {
			title: '����',
			field: 'Rp',
			align: 'right',
			width: 80
		}, {
			title: '�ۼ�',
			field: 'Sp',
			align: 'right',
			saveCol: true,
			width: 80
		}, {
			title: '���۽��',
			field: 'RpAmt',
			align: 'right',
			width: 80
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			align: 'right',
			width: 80
		}, {
			title: '����ҽ������',
			field: 'MatInsuCode',
			width: 160
		}, {
			title: '����ҽ������',
			field: 'MatInsuDesc',
			width: 160
		}, {
			title: '�������',
			field: 'SterilizedBat',
			width: 160
		}, {
			title: '��������',
			field: 'ReqQty',
			align: 'right',
			width: 80
		}, {
			title: '���󷽿��',
			field: 'ReqLocStkQty',
			align: 'right',
			width: 100
		}, {
			title: 'ռ������',
			field: 'InclbDirtyQty',
			align: 'right',
			width: 100
		}, {
			title: 'Inrqi',
			field: 'Inrqi',
			width: 80,
			saveCol: true,
			hidden: true
		}, {
			title: '������',
			field: 'SpecDesc',
			width: 80,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '�޶ʽ',
			field: 'LimitType',
			width: 100,
			align: 'right',
			hidden: LimitAmtCol
		}, {
			title: '�޶�',
			field: 'ReqAmt',
			width: 100,
			align: 'right',
			hidden: LimitAmtCol
		}, {
			title: 'ʣ���޶�',
			field: 'LeftAmt',
			width: 130,
			align: 'right',
			hidden: LimitAmtCol
		}, {
			title: '��������',
			field: 'OriginalStatus',
			width: 80,
			formatter: OriginalStatusFormatter
		}, {
			title: '�����ϸId',
			field: 'Ingri',
			width: 80,
			saveCol: true,
			hidden: true
		}
	]];
	
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD',
			query2JsonStrict: 1,
			rows: 99999,
			totalFooter: '"InciCode":"�ϼ�"',
			totalFields: 'RpAmt,SpAmt'
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			MethodName: 'jsDelete'
		},
		columns: DetailCm,
		checkField: 'InciId',
		remoteSort: false,
		showBar: true,
		showFooter: true,
		showAddDelItems: true,
		pagination: false,
		beforeAddFn: function() {
			if ($('#InitComp').val() == 'Y') {
				$UI.msg('alert', '���������, ��������');
				return false;
			}
			if (isEmpty($HUI.combobox('#InitToLoc').getValue())) {
				$UI.msg('alert', '���տ��Ҳ���Ϊ��!');
				return false;
			}
			var OperateType = $HUI.combobox('#OperateType').getValue();
			if (InitParamObj.OutTypeNotNull == 'Y' && isEmpty(OperateType)) {
				$UI.msg('alert', '��ѡ���������!');
				return false;
			}
			if (isEmpty($HUI.combotree('#InitScg').getValue())) {
				$UI.msg('alert', '���鲻��Ϊ��!');
				return false;
			}
			return true;
		},
		afterAddFn: function() {
			$HUI.combobox('#InitFrLoc').disable();
			var BtnEnaleObj = { '#SaveBT': true, '#DeleteBT': false, '#CompleteBT': true, '#CancelCompBT': false };
			ChangeButtonEnable(BtnEnaleObj);
		},
		onClickCell: function(index, field, value) {
			var Row = DetailGrid.getRows()[index];
			if ((!isEmpty(Row.Inclb) && (field == 'Qty') && (Row.OriginalStatus != 'NotUnique'))) {
				return false;
			}
			DetailGrid.commonClickCell(index, field);
		},
		onBeforeCellEdit: function(index, field) {
			var InitComp = $('#InitComp').val();
			if (InitComp == 'Y') {
				return false;
			}
			var RowData = $(this).datagrid('getRows')[index];
			if (field == 'HVBarCode' && !isEmpty(RowData['RowId'])) {
				return false;
			}
			return true;
		},
		onBeginEdit: function(index, row) {
			// ����������������������
			$('#DetailGrid').datagrid('beginEdit', index);
			var ed = $('#DetailGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == 'InciDesc') {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var Input = $(this).val();
							if (isEmpty(Input)) {
								return;
							}
							var InitScg = $('#InitScg').combotree('getValue');
							var InitFrLoc = $('#InitFrLoc').combobox('getValue');
							var InitToLoc = $('#InitToLoc').combobox('getValue');
							var HV = 'Y';
							// NoLocReq:'N', ��ֹ�����,�Կ��Գ���
							var ParamsObj = { StkGrpRowId: InitScg, StkGrpType: 'M', Locdr: InitFrLoc, NotUseFlag: 'N', QtyFlag: '1',
								ToLoc: InitToLoc, HV: HV, QtyFlagBat: '1' };
							
							IncItmBathvWindow(Input, ParamsObj, ReturnInfoFuncInci);
						}
					});
				} else if (e.field == 'HVBarCode') {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var BarCode = $(this).val();
							if (isEmpty(BarCode)) {
								DetailGrid.stopJump();
								return false;
							}
							var FindIndex = DetailGrid.find('HVBarCode', BarCode);
							if (FindIndex >= 0 && FindIndex != index) {
								$UI.msg('alert', '���벻���ظ�¼��!');
								$(this).val('');
								$(this).focus();
								DetailGrid.stopJump();
								return false;
							}
							var BarCodeData = $.cm({
								ClassName: 'web.DHCSTMHUI.DHCItmTrack',
								MethodName: 'GetItmByBarcode',
								BarCode: BarCode
							}, false);
							
							if (!isEmpty(BarCodeData.success) && BarCodeData.success != 0) {
								$UI.msg('alert', BarCodeData.msg);
								$(this).val('');
								$(this).focus();
								DetailGrid.stopJump();
								return false;
							}
							var ScgStk = BarCodeData['ScgStk'];
							var ScgStkDesc = BarCodeData['ScgStkDesc'];
							var Inclb = BarCodeData['Inclb'];
							var IsAudit = BarCodeData['IsAudit'];
							var OperNo = BarCodeData['OperNo'];
							var Type = BarCodeData['Type'];
							var Status = BarCodeData['Status'];
							var RecallFlag = BarCodeData['RecallFlag'];
							var Inci = BarCodeData['Inci'];
							var dhcit = BarCodeData['dhcit'];
							var OriginalStatus = BarCodeData['OriginalStatus'];
							var InitScg = $('#InitScg').combobox('getValue');
							if (OriginalStatus == 'NotUnique') {
								var LocId = $('#InitFrLoc').combobox('getValue');
								Inclb = tkMakeServerCall('web.DHCSTMHUI.DHCItmTrack', 'GetInclbByBarCode', LocId, BarCode); // ��ȡ��ȷ��inclb
							}
							
							var CheckMsg = '';
							if (!CheckScgRelation(InitScg, ScgStk)) {
								CheckMsg = '����' + BarCode + '����' + ScgStkDesc + '����,�뵱ǰ����!';
							} else if (Inclb == '') {
								CheckMsg = '�ø�ֵ����û����Ӧ����¼,�����Ƶ�!';
							} else if (IsAudit != 'Y' && OriginalStatus != 'NotUnique') {
								CheckMsg = '�ø�ֵ������δ��˵�' + OperNo + ',���ʵ!';
							} else if (Type == 'T' && OriginalStatus != 'NotUnique') {
								CheckMsg = '�ø�ֵ�����Ѿ�����,�����Ƶ�!';
							} else if ('alert', Status != 'Enable') {
								CheckMsg = '�ø�ֵ���봦�ڲ�����״̬,�����Ƶ�!';
							} else if (RecallFlag == 'Y') {
								CheckMsg = '�ø�ֵ���봦������״̬,�����Ƶ�!';
							}
							if (CheckMsg != '') {
								$UI.msg('alert', CheckMsg);
								$(this).val('');
								$(this).focus();
								DetailGrid.stopJump();
								return false;
							}

							var ProLocId = $('#InitFrLoc').combobox('getValue');
							var ReqLocId = $('#InitToLoc').combobox('getValue');
							var ParamsObj = { InciDr: Inci, ProLocId: ProLocId, ReqLocId: ReqLocId, QtyFlag: 1, Inclb: Inclb };
							var Params = JSON.stringify(ParamsObj);
							var InclbData = $.cm({
								ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
								MethodName: 'GetDrugBatInfo',
								page: 1,
								rows: 1,
								Params: Params
							}, false);
							if (!InclbData || InclbData.rows.length < 1) {
								$UI.msg('alert', BarCode + 'û����Ӧ����¼,�����Ƶ�!');
								$(this).val('');
								$(this).focus();
								DetailGrid.stopJump();
								return false;
							}
							$(this).val(BarCode).validatebox('validate');
							var InclbInfo = $.extend(InclbData.rows[0], { InciDr: Inci, dhcit: dhcit, HVBarCode: BarCode, OriginalStatus: OriginalStatus });
							ReturnInfoFunc(index, InclbInfo);
						}
					});
				}
			}
		},
		onEndEdit: function(index, row, changes) {
			var CheckCertObj = addSessionParams({
				Inclb: row['Inclb']
			});
			var CheckCertRet = Common_CheckCert(CheckCertObj, 'Out');
			if (!CheckCertRet) {
				DetailGrid.checked = false;
				return false;
			}
		}
	});
	
	function ReturnInfoFunc(RowIndex, row) {
		if (row.AvaQty < 1) {
			$UI.msg('alert', '���ÿ�治��');
			return;
		}
		// ���ʲ������,�˳�
		var CheckCertObj = addSessionParams({
			Inclb: row['Inclb']
		});
		var CheckCertRet = Common_CheckCert(CheckCertObj, 'Out');
		if (!CheckCertRet) {
			return true;
		}
		DetailGrid.updateRow({
			index: RowIndex,
			row: {
				HVBarCode: row.HVBarCode,
				OriginalStatus: row.OriginalStatus,
				dhcit: row.dhcit,
				InciId: row.InciDr,
				InciCode: row.InciCode,
				InciDesc: row.InciDesc,
				Spec: row.Spec,
				Inclb: row.Inclb,
				BatExp: row.BatExp,
				UomId: row.PurUomId,
				UomDesc: row.PurUomDesc,
				Rp: row.Rp,
				Sp: row.Sp,
				RpAmt: row.Rp,
				SpAmt: row.Sp,
				InclbQty: row.InclbQty,
				InclbDirtyQty: row.DirtyQty,
				Qty: 1,
				ManfDesc: row.Manf,
				SpecDesc: row.SpecDesc,
				MatInsuCode: row.MatInsuCode,
				MatInsuDesc: row.MatInsuDesc
			}
		});
		$('#DetailGrid').datagrid('refreshRow', RowIndex);
		var OldScg = $('#InitScg').combotree('getValue');
		var RowData = DetailGrid.getRows();
		var RowLength = RowData.length;
		if (RowLength > 0) {
			var Inci = RowData[0].InciId;
			if (!isEmpty(Inci)) {
				ScgValue = 'Scg-' + OldScg;
			}
		}
		var tmprows = $('#DetailGrid').datagrid('getRows');
		if (tmprows.length != (RowIndex + 1)) {
			var tmprow = tmprows[RowIndex + 1];
			var HVBarCode = tmprow.HVBarCode;
			var inclb = tmprow.Inclb;
			if (isEmpty(HVBarCode) && !isEmpty(inclb)) {
				var index = RowIndex + 1;
				$('#DetailGrid').datagrid('beginEdit', index);
				var ed = $('#DetailGrid').datagrid('getEditor', { index: index, field: 'HVBarCode' });
				$(ed.target).focus();
			}
		} else {
			DetailGrid.commonAddRow();
		}
	}
	
	// ����ȱʡֵ
	function SetDefaValues() {
		var OperateTypeInfo = GetInitTypeDefa();
		var OperateTypeId = OperateTypeInfo.split('^')[0];
		var DefaultData = {
			InitDate: DateFormatter(new Date()),
			InitFrLoc: gLocObj
		};
		$UI.fillBlock('#Conditions', DefaultData);
		$('#InitScg').combotree('options')['setDefaultFun']();
		$HUI.combobox('#OperateType').setValue(OperateTypeId);
		if (ItmTrackParamObj.AutoVirFlag == 'Y') {
			$('#VirtualFlag').checkbox('setValue', true);
		} else {
			$('#VirtualFlag').checkbox('setValue', false);
		}
	}
	
	var BtnEnaleObj = { '#SaveBT': false, '#DeleteBT': false, '#CompleteBT': false,
		'#CancelCompBT': false, '#AuditOutYesBT': false, '#AuditInYesBT': false };
	ChangeButtonEnable(BtnEnaleObj);
	
	function SelectDefa() {
		Clear();
		if (gInitId > 0) {
			Select(gInitId);
			gInitId = '';
		} else if (!isEmpty(gTabParams)) {
			var TalParamsObj = JSON.parse(gTabParams);
			var TabType = TalParamsObj.TabType;
			if (TabType == 'SearchReq') {
				SelReq(QueryTrans, getlistReq, 'Y');
			} else if (TabType == 'Search') {
				FindWin(Select, gHVSignFlag, HvFlag);
			}
		} else if (InitParamObj['AutoLoadRequest'] == 'Y') {
			var InitFrLoc = $('#InitFrLoc').combobox('getValue');
			if (!isEmpty(InitFrLoc)) {
				SelReq(QueryTrans, getlistReq, 'Y');
			}
		}
		CheckLocationHref(1);
	}
	SelectDefa();
};
$(init);