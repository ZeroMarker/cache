// 双签字标志变量
gHVSignFlag = typeof (gHVSignFlag) === 'undefined' ? '' : gHVSignFlag;
var ToLocNewValue = '', ToLocOldValue = '', ScgValue = '', FrLocId = '', ScgTipFlag = '';

var init = function() {
	var LimitAmtCol = (InitParamObj.UseLocLimitAmt == 'Y' ? false : true);
	
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			FindWin(QueryTrans, gHVSignFlag, 'N');
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
			var IsChange = $UI.isChangeBlock('#Conditions');
			var Detail = DetailGrid.getChangesData('Inclb');
			if (Detail === false) {	// 未完成编辑或明细为空
				return;
			}
			if (!IsChange && isEmpty(Detail)) {	// 明细不变
				$UI.msg('alert', '没有需要保存的信息!');
				return;
			}
			if (MainObj['InitComp'] == 'Y') {
				$UI.msg('alert', '该单据已经完成,不可重复保存!');
				return;
			}
			if (InitParamObj['RequestNeeded'] == 'Y' && isEmpty(MainObj['ReqId'])) {
				$UI.msg('alert', '只能根据请求单转移制单,不可保存新记录!');
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
			MainObj['InitState'] = '10';
			MainObj['InitType'] = 'T';
			var Main = JSON.stringify(MainObj);
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
				var RowIndex = MasterGrid.find('RowId', InitId);
				if (RowIndex != -1) {
					MasterGrid.updateRow({
						index: RowIndex,
						row: { 'StatusCode': '已完成' }			// 如此自动审核,这里??
					});
				}
				//					var BtnEnaleObj = {'#SaveBT':false, '#DeleteBT':false, '#CompleteBT':false,
				//						'#CancelCompBT':true, '#AuditOutYesBT':true, '#AuditInYesBT':false};
				//					ChangeButtonEnable(BtnEnaleObj);
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
			var rowData = DetailGrid.getRows();
			if (rowData.length < 1) {
				$UI.msg('alert', '该单据没有明细!');
				return false;
			}
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
					var RowIndex = MasterGrid.find('RowId', InitId);
					if (RowIndex != -1) {
						MasterGrid.updateRow({
							index: RowIndex,
							row: { 'StatusCode': '未完成' }
						});
					}
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
		var InitId = ParamsObj['RowId'];
		var Params = JSON.stringify(ParamsObj);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'jsDelete',
			Params: Params
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				var RowIndex = MasterGrid.find('RowId', InitId);
				if (RowIndex != -1) {
					MasterGrid.deleteRow(RowIndex);
				}
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
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		SetDefaValues();
		ScgTipFlag = '';
		var BtnEnaleObj = { '#SaveBT': true, '#DeleteBT': false, '#CompleteBT': false,
			'#CancelCompBT': false, '#AuditOutYesBT': false, '#AuditInYesBT': false };
		ChangeButtonEnable(BtnEnaleObj);
		SetEditEnable();
		$('#InitScg').combotree('options')['setDefaultFun']();
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
	
	$UI.linkbutton('#SelReqBT', {
		onClick: function() {
			SelReq(QueryTrans, '', 'N');
		}
	});
	
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
	
	var MasterCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 80,
			hidden: true
		}, {
			title: '单号',
			field: 'InitNo',
			align: 'left',
			width: 150,
			sortable: true
		}, {
			title: '接收科室',
			field: 'ToLocDesc',
			width: 150
		}, {
			title: '科室Id',
			field: 'FrLoc',
			width: 100,
			hidden: true
		}, {
			title: '科室',
			field: 'FrLocDesc',
			width: 150,
			sortable: true
		}, {
			title: '制单时间',
			field: 'InitDateTime',
			width: 150
		}, {
			title: '单据状态',
			field: 'StatusCode',
			width: 70
		}
	]];
	
	var MasterGrid = $UI.datagrid('#MasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'QueryTrans',
			query2JsonStrict: 1
		},
		columns: MasterCm,
		showBar: false,
		pagination: false,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				MasterGrid.selectRow(0);
			}
		},
		onSelect: function(index, row) {
			var Init = row['RowId'];
			Select(Init);
		}
	});
	
	var UomCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			editable: false,
			onBeforeLoad: function(param) {
				var Select = DetailGrid.getRows()[DetailGrid.editIndex];
				if (!isEmpty(Select)) {
					var Inci = Select.Inclb.split('||')[0];
					param.Inci = Inci;
				}
			},
			onSelect: function(record) {
				var rows = DetailGrid.getRows();
				var row = rows[DetailGrid.editIndex];
				row.UomDesc = record.Description;
				var NewUomid = record.RowId;
				var OldUomid = row.UomId;
				if (isEmpty(NewUomid) || (NewUomid == OldUomid)) {
					return false;
				}
				var BUomId = row.BUomId;
				
				var Rp = row.Rp;
				var InclbQty = row.InclbQty;
				var Qty = row.Qty;
				var Sp = row.Sp;
				var RpAmt = row.RpAmt;
				var SpAmt = row.SpAmt;
				var ReqQty = row.ReqQty;
				var InclbDirtyQty = row.InclbDirtyQty;
				var DirtyQty = row.DirtyQty;
				var InclbAvaQty = row.InclbAvaQty;
				var confac = row.ConFac;
				if (NewUomid == BUomId) { // 入库单位转换为基本单位
					row.Rp = Number(Rp).div(confac);
					row.Sp = Number(Sp).div(confac);
					if (InclbQty != '') {
						row.InclbQty = Number(InclbQty).mul(confac);
					}
					if (Qty != '') {
						row.Qty = Number(Qty).mul(confac);
					}
					if (ReqQty != '') {
						row.ReqQty = Number(ReqQty).mul(confac);
					}
					if (InclbDirtyQty != '') {
						row.InclbDirtyQty = Number(InclbDirtyQty).mul(confac);
					}
					if ((DirtyQty != '') && (DirtyQty != undefined)) {
						row.DirtyQty = Number(DirtyQty).mul(confac);
					}
					if (InclbAvaQty != '') {
						row.InclbAvaQty = Number(InclbAvaQty).mul(confac);
					}
				} else { // 基本单位转换为入库单位
					row.Rp = Number(Rp).mul(confac);
					row.Sp = Number(Sp).mul(confac);
					if (InclbQty != '') {
						row.InclbQty = Number(InclbQty).div(confac);
					}
					if (Qty != '') {
						row.Qty = Number(Qty).div(confac);
					}
					if (ReqQty != '') {
						row.ReqQty = Number(ReqQty).div(confac);
					}
					if (InclbDirtyQty != '') {
						row.InclbDirtyQty = Number(InclbDirtyQty).div(confac);
					}
					if (DirtyQty != '') {
						row.DirtyQty = Number(DirtyQty).div(confac);
					}
					if (InclbAvaQty != '') {
						row.InclbAvaQty = Number(InclbAvaQty).div(confac);
					}
				}
				row.UomId = NewUomid;
				setTimeout(function() {
					DetailGrid.refreshRow();
				}, 0);
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	
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
			jump: false,
			editor: {
				type: 'validatebox',
				options: {
					required: true,
					tipPosition: 'bottom'
				}
			},
			width: 180
		}, {
			title: '规格',
			field: 'Spec',
			width: 80
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 80,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '型号',
			field: 'Model',
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
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			},
			align: 'right',
			width: 80
		}, {
			title: '单位',
			field: 'UomId',
			saveCol: true,
			formatter: CommonFormatter(UomCombox, 'UomId', 'UomDesc'),
			editor: UomCombox,
			width: 80
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
			title: '物资条码',
			field: 'BarCode',
			jump: false,
			editor: {
				type: 'validatebox',
				options: {
				}
			},
			width: 160
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
			title: '本次占用',
			field: 'DirtyQty',
			align: 'right',
			width: 80
		}, {
			title: '可用数量',
			field: 'InclbAvaQty',
			align: 'right',
			width: 100
		}, {
			title: 'Inrqi',
			field: 'Inrqi',
			width: 80,
			saveCol: true,
			hidden: true
		}, {
			title: '请求备注',
			field: 'ReqRemark',
			width: 100
		}, {
			title: 'BUomId',
			field: 'BUomId',
			width: 100,
			hidden: true
		}, {
			title: 'ConFac',
			field: 'ConFac',
			width: 100,
			hidden: true
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
			title: '备注',
			field: 'Remark',
			saveCol: true,
			width: 100,
			editor: {
				type: 'text'
			}
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
		checkField: 'Inclb',
		remoteSort: false,
		showBar: true,
		showFooter: true,
		showAddDelItems: true,
		pagination: false,
		beforeAddFn: function() {
			if (InitParamObj['RequestNeeded'] == 'Y') {
				$UI.msg('alert', '只能根据请求单转移制单,不可新增记录!');
				return;
			}
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
			if (isEmpty($HUI.combotree('#InitScg').getValue()) && isEmpty(ScgTipFlag)) {
				$UI.msg('alert', '类组未选择,请谨慎核实数据!');
				ScgTipFlag = 'Y';
			}
			return true;
		},
		afterAddFn: function() {
			$HUI.combobox('#InitFrLoc').disable();
			var BtnEnaleObj = { '#SaveBT': true, '#DeleteBT': false, '#CompleteBT': true, '#CancelCompBT': false };
			ChangeButtonEnable(BtnEnaleObj);
		},
		onClickRow: function(index, row) {
			DetailGrid.commonClickRow(index, row);
		},
		onBeforeEdit: function(index, row) {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitComp = ParamsObj['InitComp'];
			if (InitComp == 'Y') {
				return false;
			}
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
							var HV = 'N';
							// NoLocReq:'N', 禁止请领的,仍可以出库
							var ParamsObj = { StkGrpRowId: InitScg, StkGrpType: 'M', Locdr: InitFrLoc, NotUseFlag: 'N', QtyFlag: '1',
								ToLoc: InitToLoc, HV: HV, QtyFlagBat: '1' };
							IncItmBatWindow(Input, ParamsObj, ReturnInfoFunc);
						}
					});
				} else if (e.field == 'Qty') {
					$(e.target).bind('keyup', function(event) {
						if (event.keyCode == 13) {
							DetailGrid.commonAddRow();
						}
					});
				} else if (e.field == 'BarCode') {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var BarCode = $(this).val();
							var InitScg = $('#InitScg').combotree('getValue');
							var InitFrLoc = $('#InitFrLoc').combobox('getValue');
							var InitToLoc = $('#InitToLoc').combobox('getValue');
							var HV = 'N';
							var ParamsObj = { StkGrpRowId: InitScg, StkGrpType: 'M', Locdr: InitFrLoc, NotUseFlag: 'N', QtyFlag: '1',
								ToLoc: InitToLoc, NoLocReq: 'N', HV: HV, QtyFlagBat: '1', BarCode: BarCode };
							// 共用,物资名称传''
							IncItmBatWindow('', ParamsObj, ReturnInfoFunc);
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
			var Editors = $(this).datagrid('getEditors', index);
			for (var i = 0; i < Editors.length; i++) {
				var Editor = Editors[i];
				if (Editor.field == 'Qty') {
					var Qty = row.Qty;
					var UomId = row.UomId;
					var ConFac = row.ConFac;
					var BUomId = row.BUomId;
					if (UomId == BUomId) {
						if (!CheckFmtQty(ConFac, 'BUom', Qty)) {
							DetailGrid.checked = false;
							return false;
						}
					} else {
						if (!CheckFmtQty(ConFac, 'PUom', Qty)) {
							DetailGrid.checked = false;
							return false;
						}
					}
				}
			}
		},
		onAfterEdit: function(index, row, changes) {
			if (changes.hasOwnProperty('Qty')) {
				var Qty = Number(changes['Qty']);
				var InclbAvaQty = Number(row['InclbAvaQty']);
				var InclbDirtyQty = Number(row['InclbDirtyQty']);
				if (accSub(Qty, InclbDirtyQty) > InclbAvaQty) {
					$UI.msg('alert', '数量不可大于可用库存!');
					$(this).datagrid('updateRow', {
						index: index,
						row: {
							Qty: '',
							RpAmt: 0,
							SpAmt: 0
						}
					});
					DetailGrid.checked = false;
					return;
				}
				var Rp = Number(row['Rp']), Sp = Number(row['Sp']);
				$(this).datagrid('updateRow', {
					index: index,
					row: {
						RpAmt: accMul(Qty, Rp),
						SpAmt: accMul(Qty, Sp)
					}
				});
			}
			DetailGrid.setFooterInfo();
		}
	});
	
	function ReturnInfoFunc(rows) {
		rows = [].concat(rows);
		$.each(rows, function(index, row) {
			// 资质不满足的,退出
			var CheckCertObj = addSessionParams({
				Inclb: row['Inclb']
			});
			var CheckCertRet = Common_CheckCert(CheckCertObj, 'Out');
			if (!CheckCertRet) {
				return true;
			}
			
			var RowIndex = DetailGrid.editIndex;
			var FindIndex = DetailGrid.find('Inclb', row.Inclb);
			if (FindIndex >= 0 && FindIndex != RowIndex) {
				$UI.msg('alert', '物资批次不可重复选择!');
				$(this).focus();
				DetailGrid.stopJump();
				return false;
			}
			var ed = $('#DetailGrid').datagrid('getEditor', { index: RowIndex, field: 'UomId' });
			AddComboData(ed.target, row.PurUomId, row.PurUomDesc);
			DetailGrid.updateRow({
				index: RowIndex,
				row: {
					InciId: row.InciDr,
					InciCode: row.InciCode,
					InciDesc: row.InciDesc,
					Spec: row.Spec,
					Inclb: row.Inclb,
					ManfDesc: row.Manf,
					BatExp: row.BatExp,
					Qty: row.OperQty,
					UomId: row.PurUomId,
					UomDesc: row.PurUomDesc,
					Rp: row.Rp,
					Sp: row.Sp,
					BUomId: row.BUomId,
					ConFac: row.ConFac,
					RpAmt: accMul(row.OperQty, row.Rp),
					SpAmt: accMul(row.OperQty, row.Sp),
					InclbQty: row.InclbQty,
					InclbDirtyQty: row.DirtyQty,
					InclbAvaQty: row.AvaQty,
					Model: row.Model,
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
			
			DetailGrid.setFooterInfo();
			if (index < rows.length) {
				DetailGrid.commonAddRow();
			}
		});
		DetailGrid.startEditingNext();
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
		$HUI.combobox('#OperateType').setValue(OperateTypeId);
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
				SelReq(QueryTrans, '', 'N');
			} else if (TabType == 'Search') {
				FindWin(QueryTrans, gHVSignFlag, 'N');
			}
		} else if (InitParamObj['AutoLoadRequest'] == 'Y') {
			var InitFrLoc = $('#InitFrLoc').combobox('getValue');
			if (!isEmpty(InitFrLoc)) {
				SelReq(QueryTrans, 'N');
			}
		}
		CheckLocationHref(1);
	}
	SelectDefa();
};
$(init);