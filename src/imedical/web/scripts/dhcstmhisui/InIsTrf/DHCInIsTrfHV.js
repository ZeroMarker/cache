// 双签字标志变量
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
			totalFooter: '"InciCode":"合计"',
			totalFields: 'RpAmt,SpAmt'
		});
	}
	
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var MainObj = $UI.loopBlock('#Conditions');
			if (MainObj['InitComp'] == 'Y') {
				$UI.msg('alert', '该单据已经完成,不可重复保存!');
				return;
			}
			if (isEmpty(MainObj['InitFrLoc'])) {
				$UI.msg('alert', '出库科室不可为空!');
				return;
			}
			if (isEmpty(MainObj['InitToLoc'])) {
				$UI.msg('alert', '接收科室不可为空!');
				return;
			}
			if (MainObj['InitFrLoc'] == MainObj['InitToLoc']) {
				$UI.msg('alert', '出库科室不允许与接收科室相同!');
				return;
			}
			MainObj['InitState'] = '10';
			MainObj['InitType'] = 'T';
			var Main = JSON.stringify(MainObj);
			var Detail = DetailGrid.getChangesData('Inclb');
			if (Detail === false) {	// 未完成编辑或明细为空
				return;
			}
			// 判断
			var ifChangeMain = $UI.isChangeBlock('#MainObj');
			if (!ifChangeMain && (isEmpty(Detail))) {	// 主单和明细不变
				$UI.msg('alert', '没有需要保存的信息!');
				return;
			}
			var InStkTkParamObj = GetAppPropValue('DHCSTINSTKTKM');
			if (InStkTkParamObj.AllowBusiness != 'Y') {
				var IfFrLocExistInStkTk = tkMakeServerCall('web.DHCSTMHUI.INStkTk', 'CheckInStkTkByLoc', MainObj['InitFrLoc']);
				if (IfFrLocExistInStkTk == 'Y') {
					$UI.msg('alert', '出库科室存在未完成的盘点单不允许保存!');
					return false;
				}
				var IfToLocExistInStkTk = tkMakeServerCall('web.DHCSTMHUI.INStkTk', 'CheckInStkTkByLoc', MainObj['InitToLoc']);
				if (IfToLocExistInStkTk == 'Y') {
					$UI.msg('alert', '接收科室存在未完成的盘点单不允许保存!');
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
				$UI.msg('alert', '请输入明细!');
				return false;
			}
			if (((RowsData.length - 1) > count)) {
				$UI.msg('alert', '有明细无条码,或者批次信息错误!');
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
						$UI.confirm('是否完成?', '', '', Complete);
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
			$UI.msg('alert', '该单据已完成,不可重复操作!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		var AutoAuditFlag = gHVSignFlag == 'Y' ? 'N' : '';	// 双签字功能,不进行自动审核
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
				// 完成后自动打印 或 完成后自动出库审核，出库审核后自动打印
				if ((InitParamObj.AutoPrintAfterComp == 'Y') || (InitParamObj.AutoAckOutAfterCompleted == 'Y' && InitParamObj.AutoPrintAfterAckOut == 'Y')) {
					PrintInIsTrf(InitId, 'Y');
				}
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	// 完成前控额判断提示
	function CheckDataBeforeComplete() {
		var MainObj = $UI.loopBlock('#Conditions');
		var InitId = MainObj.RowId;
		if (isEmpty(InitId)) {
			$UI.msg('alert', '无需要处理的单据');
			return false;
		}
		var rowData = DetailGrid.getRows();
		var rowCount = rowData.length;
		if (rowCount < 1) {
			$UI.msg('alert', '该单据没有明细!');
			return false;
		}
		// 判断限额
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
				Msg = Msg + '科室:(' + ResultLoc + ')超过总限额！';
			}
			if (!isEmpty(ResultScg)) {
				Msg = Msg + '类组:(' + ResultScg + ')超过限额！';
			}
			if (!isEmpty(ResultCat)) {
				Msg = Msg + '库存分类:(' + ResultCat + ')超过限额！';
			}
			if (!isEmpty(ResultInci)) {
				Msg = Msg + '品种:(' + ResultInci + ')超过限额！';
			}
			if (!isEmpty(ResultInciQty)) {
				Msg = Msg + '品种:(' + ResultInciQty + ')超过限量！';
			}
			if (!isEmpty(ResultInciOnceQty)) {
				Msg = Msg + '(品种:' + ResultInciOnceQty + ')超过单次限量！';
			}
			if (!isEmpty(Msg)) {
				$UI.confirm('本时间段内 ' + Msg + ' 是否继续?', '', '', Complete);
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
				$UI.msg('alert', '该单据不是完成状态,不可操作!');
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
				$UI.msg('alert', '该单据已经完成,不可删除!');
				return;
			}
			$UI.confirm('您将要删除单据,是否继续?', '', '', Delete);
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
				$UI.msg('alert', '请选择需要打印的单据!');
				return;
			}
			if (InitParamObj['PrintNoComplete'] == 'N' && ParamsObj['InitComp'] != 'Y') {
				$UI.msg('warning', '不允许打印未完成的转移单!');
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
				$UI.msg('alert', '请选择需要打印的单据!');
				return;
			}
			if (InitParamObj['PrintNoComplete'] == 'N' && ParamsObj['InitComp'] != 'Y') {
				$UI.msg('warning', '不允许打印未完成的转移单!');
				return;
			}
			PrintInIsTrfHVCol(InitId);
		}
	});
	
	$UI.linkbutton('#SelReqBT', {
		onClick: function() {
			SelReq(QueryTrans, getlistReq, 'Y'); // 高值标志
		}
	});
	function getlistReq(MainObj, ReqId) {
		SetEditDisable();
		var MainParamObj = $UI.loopBlock('#Conditions');
		if (MainParamObj.ReqId == ReqId) {
			$UI.msg('alert', '该请领单已存在!');
			return;
		}
		if ((!isEmpty(MainParamObj.ReqId)) && (MainParamObj.ReqId != ReqId)) { // 新的请领单重新填充
			Clear();
		}
		// 请求单明细数据
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
				$UI.msg('alert', '没有满足出库条件的批次!');
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
				$UI.msg('alert', '请选择审核的转移单!');
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
			$UI.msg('alert', '转移单尚未完成!');
			return;
		}
		// 检查高值材料标签录入情况
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
				$UI.msg('success', '审核成功!');
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
				$UI.msg('alert', '请选择接收的转移单');
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
				$UI.msg('alert', row.HVBarCode + '条码不可重复录入!');
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
				$UI.msg('alert', '接收科室缺少明细物资的类组权限,不允许修改');
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
	// 判断是否可以修改接收科室
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
				$UI.msg('alert', '已存在物资明细,不允许修改');
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
			{ RowId: '10', Description: '未完成' },
			{ RowId: '11', Description: '已完成' },
			{ RowId: '20', Description: '出库审核不通过' },
			{ RowId: '21', Description: '出库审核通过' },
			{ RowId: '30', Description: '拒绝接收' },
			{ RowId: '31', Description: '已接收' }
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
			title: '物资代码',
			field: 'InciCode',
			width: 120
		}, {
			title: '物资名称',
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
			title: '高值条码',
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
			title: '规格',
			field: 'Spec',
			width: 80
		}, {
			title: 'Inclb',
			field: 'Inclb',
			saveCol: true,
			width: 80,
			hidden: true
		}, {
			title: '批号~效期',
			field: 'BatExp',
			width: 200
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 160
		}, {
			title: '批次库存',
			field: 'InclbQty',
			align: 'right',
			width: 80
		}, {
			title: '出库数量',
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
			title: '单位Id',
			field: 'UomId',
			saveCol: true,
			width: 50,
			hidden: true
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 50
		}, {
			title: '进价',
			field: 'Rp',
			align: 'right',
			width: 80
		}, {
			title: '售价',
			field: 'Sp',
			align: 'right',
			saveCol: true,
			width: 80
		}, {
			title: '进价金额',
			field: 'RpAmt',
			align: 'right',
			width: 80
		}, {
			title: '售价金额',
			field: 'SpAmt',
			align: 'right',
			width: 80
		}, {
			title: '国家医保编码',
			field: 'MatInsuCode',
			width: 160
		}, {
			title: '国家医保名称',
			field: 'MatInsuDesc',
			width: 160
		}, {
			title: '灭菌批号',
			field: 'SterilizedBat',
			width: 160
		}, {
			title: '请求数量',
			field: 'ReqQty',
			align: 'right',
			width: 80
		}, {
			title: '请求方库存',
			field: 'ReqLocStkQty',
			align: 'right',
			width: 100
		}, {
			title: '占用数量',
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
			title: '具体规格',
			field: 'SpecDesc',
			width: 80,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '限额方式',
			field: 'LimitType',
			width: 100,
			align: 'right',
			hidden: LimitAmtCol
		}, {
			title: '限额',
			field: 'ReqAmt',
			width: 100,
			align: 'right',
			hidden: LimitAmtCol
		}, {
			title: '剩余限额',
			field: 'LeftAmt',
			width: 130,
			align: 'right',
			hidden: LimitAmtCol
		}, {
			title: '条码类型',
			field: 'OriginalStatus',
			width: 80,
			formatter: OriginalStatusFormatter
		}, {
			title: '入库明细Id',
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
			totalFooter: '"InciCode":"合计"',
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
				$UI.msg('alert', '单据已完成, 不可增加');
				return false;
			}
			if (isEmpty($HUI.combobox('#InitToLoc').getValue())) {
				$UI.msg('alert', '接收科室不可为空!');
				return false;
			}
			var OperateType = $HUI.combobox('#OperateType').getValue();
			if (InitParamObj.OutTypeNotNull == 'Y' && isEmpty(OperateType)) {
				$UI.msg('alert', '请选择出库类型!');
				return false;
			}
			if (isEmpty($HUI.combotree('#InitScg').getValue())) {
				$UI.msg('alert', '类组不可为空!');
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
			// 增加完成情况字数输入限制
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
							// NoLocReq:'N', 禁止请领的,仍可以出库
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
								$UI.msg('alert', '条码不可重复录入!');
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
								Inclb = tkMakeServerCall('web.DHCSTMHUI.DHCItmTrack', 'GetInclbByBarCode', LocId, BarCode); // 获取正确的inclb
							}
							
							var CheckMsg = '';
							if (!CheckScgRelation(InitScg, ScgStk)) {
								CheckMsg = '条码' + BarCode + '属于' + ScgStkDesc + '类组,与当前不符!';
							} else if (Inclb == '') {
								CheckMsg = '该高值材料没有相应库存记录,不能制单!';
							} else if (IsAudit != 'Y' && OriginalStatus != 'NotUnique') {
								CheckMsg = '该高值材料有未审核的' + OperNo + ',请核实!';
							} else if (Type == 'T' && OriginalStatus != 'NotUnique') {
								CheckMsg = '该高值材料已经出库,不可制单!';
							} else if ('alert', Status != 'Enable') {
								CheckMsg = '该高值条码处于不可用状态,不可制单!';
							} else if (RecallFlag == 'Y') {
								CheckMsg = '该高值条码处于锁定状态,不可制单!';
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
								$UI.msg('alert', BarCode + '没有相应库存记录,不能制单!');
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
			$UI.msg('alert', '可用库存不足');
			return;
		}
		// 资质不满足的,退出
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
	
	// 设置缺省值
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