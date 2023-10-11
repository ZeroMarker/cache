var tabTitle = '灭菌详情';
var init = function() {
	var ParamsTB = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	var IsSterFinish = SterParamObj.IsSterFinish;						// 确定是否默认灭菌完成
	var IsGetUserCheckByLoginVal = SterParamObj.IsGetUserCheckByLogin;	// 验收人是否取登录人
	var AtuoPhyCheckOk = SterParamObj.AtuoPhyCheckOk;					// 验收时是否默认物理监测合格
	var AtuoCheCheckOk = SterParamObj.AtuoCheCheckOk;					// 验收时是否默认化学监测合格
	var CurrId = '';

	// 灭菌科室
	var SterInLocParams = JSON.stringify(addSessionParams({ Type: 'Login', BDPHospital: gHospId }));
	$HUI.combobox('#SterInLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SterInLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId, SupLocId: record.RowId }));
			var Url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterMachine&ResultSetType=array&type="sterilizer"&Params=' + Params;
			$('#MachineNoValue').combobox('reload', Url).combobox('clear');
		}
	});
	// 灭菌器
	$HUI.combobox('#MachineNoValue', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterMachine&ResultSetType=array&type=sterilizer&Params=' + JSON.stringify(addSessionParams({ BDPHospital: gHospId })),
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'MachineNo'
	});
	$('#MachineNoValue').combobox('textbox').keyup(function(event) {
		if (event.which === 13) {
			var Value = $('#MachineNoValue').combobox('getValue');
			if (isEmpty(Value)) {
				var MachineVal = $('#MachineNoValue').combobox('getText');
				var SupLocId = $('#SterInLoc').combobox('getValue');
				var Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId, SupLocId: SupLocId }));
				var MachineObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetSterMachineInfo',
					MachineNo: MachineVal,
					Params: Params
				}, false);
				var MachineId = MachineObj['ID'], Msg = MachineObj['Msg'];
				if (!isEmpty(Msg)) {
					$UI.msg('alert', Msg);
					$('#MachineNoValue').combobox('setValue', '');
					return;
				}
				$('#MachineNoValue').combobox('setValue', MachineId).combobox('hidePanel');
			}
		}
	});

	// 灭菌程序
	$HUI.combobox('#SterProValue', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetProCom&ResultSetType=array&type=2001&Params=' + JSON.stringify(addSessionParams({ BDPHospital: gHospId })),
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'Code'
	});
	$('#SterProValue').combobox('textbox').keyup(function(event) {
		if (event.which === 13) {
			var Value = $('#SterProValue').combobox('getValue');
			if (isEmpty(Value)) {
				var SterProValue = $('#SterProValue').combobox('getText');
				SterProEnter(SterProValue);
			}
		}
	});
	function SterProEnter(SterProText) {
		if (SterProText === '') {
			return;
		}
		var SterProObj = $.cm({
			ClassName: 'web.CSSDHUI.Common.Dicts',
			MethodName: 'GetSterPro',
			type: '2001',
			SterPro: SterProText,
			Params: ParamsTB
		}, false);
		if (SterProObj['SterProID'] === '') {
			$UI.msg('alert', '未获取到灭菌程序相关信息！');
			$('#SterPro').val('');
			$('#SterPro').focus();
			return;
		}
		if (SterProObj['Ret'] === 'Y') {
			$('#SterPro').val(SterProObj['SterName']);
			$('#SterProValue').val(SterProObj['SterProID']);
			// $("#SterUserValue").focus();
		} else {
			$UI.msg('alert', '未找到相关信息！');
			$('#SterPro').val('');
			$('#SterPro').focus();
			return;
		}
	}

	// 灭菌验收人
	$HUI.combobox('#CheckUserValue', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: gHospId })),
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		defaultFilter: 6,
		spellField: 'Code'
	});
	$('#CheckUserValue').combobox('textbox').keyup(function(event) {
		if (event.which === 13) {
			var Value = $('#CheckUserValue').combobox('getValue');
			var UserStr = $('#CheckUserValue').combobox('getText');
			if (!isEmpty(Value) || isEmpty(UserStr)) {
				return;
			}
			var UserObj = $.cm({
				ClassName: 'web.CSSDHUI.Common.Dicts',
				MethodName: 'GetUserByCodeJson',
				userCode: UserStr,
				Params: ParamsTB
			}, false);
			if (UserObj['RowId'] !== '') {
				$('#CheckUserValue').combobox('setValue', UserObj['RowId']);
			} else {
				$UI.msg('alert', '未找到相关信息!');
				$('#CheckUserValue').combobox('setValue', '');
				$('#CheckUserValue').focus();
			}
		}
	});

	// 查询
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#MainCondition');
			if (isEmpty(ParamsObj.SterInLoc)) {
				$UI.msg('alert', '科室不能为空！');
				return;
			} else if (isEmpty(ParamsObj.FStartDate)) {
				$UI.msg('alert', '开始日期不能为空！');
				return;
			} else if (isEmpty(ParamsObj.FEndDate)) {
				$UI.msg('alert', '截止日期不能为空！');
				return;
			} else {
				Query();
			}
		}
	});
	function Query() {
		$UI.clear(MainListGrid);
		$UI.clear(ItemListGrid);
		var ParamsObj = $UI.loopBlock('#MainCondition');
		SetLocalStorage('QueryState', ParamsObj.QueryState);
		var Params = JSON.stringify(ParamsObj);
		$('#UnqualifiedReason').combobox('setValue', '');
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			QueryName: 'SelectAll',
			Params: Params
		});
	}

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('#MainCondition');
			$UI.clearBlock('#MonitorCondition');
			$('#FileSel').filebox('clear');
			$UI.clear(MainListGrid);
			$UI.clear(ItemListGrid);
			var DefaultValue = {
				FStartDate: DefaultStDate(),
				FEndDate: DefaultEdDate(),
				SterInLoc: gLocId,
				QueryState: '',
				QueryCheck: ''
			};
			$UI.fillBlock('#MainCondition', DefaultValue);
		}
	});
	$UI.linkbutton('#MonitorOK', {
		onClick: function() {
			var row = $('#MainList').datagrid('getSelected');
			if (isEmpty(row)) {
				$UI.msg('alert', '请选择需要操作的单据!');
				return false;
			}
			if (row.IsCHK === '2') {
				$UI.msg('alert', '已验收不合格，不能进行监测合格操作!');
				return false;
			}
			var ParamsObj = $UI.loopBlock('#MonitorCondition');
			var Check = ParamsObj.Check;
			if (isEmpty(Check)) {
				$UI.msg('alert', '请选择需要监测合格的类型!');
				return false;
			}
			$.messager.confirm('操作提示', '您确定要执行监测合格操作吗？', function(data) {
				if (data) {
					if (Check === '1') {
						BioOK();
					} else if (Check === '2') {
						CheOK();
					} else if (Check === '3') {
						PhyOK();
					}
					$('#Check').keywords('clearAllSelected');
				}
			});
		}
	});
	$UI.linkbutton('#MonitorFail', {
		onClick: function() {
			var row = $('#MainList').datagrid('getSelected');
			if (isEmpty(row)) {
				$UI.msg('alert', '请选择需要操作的单据!');
				return false;
			}
			var ParamsObj = $UI.loopBlock('#MonitorCondition');
			var Check = ParamsObj.Check;
			if (isEmpty(Check)) {
				$UI.msg('alert', '请选择需要监测不合格的类型!');
				return false;
			}
			var CheckTime = ParamsObj.CheckTime;
			$.messager.confirm('操作提示', '您确定要执行监测不合格操作吗？', function(data) {
				if (data) {
					if (Check === '1') {
						BioFail(CheckTime);
					} else if (Check === '2') {
						CheFail(CheckTime);
					} else if (Check === '3') {
						PhyFail(CheckTime);
					}
					$('#Check').keywords('clearAllSelected');
				}
			});
		}
	});

	$UI.linkbutton('#CancelMonitorBT', {
		onClick: function() {
			var row = $('#MainList').datagrid('getSelected');
			if (isEmpty(row)) {
				$UI.msg('alert', '请选则需要操作的单据!');
				return false;
			}
			var ParamsObj = $UI.loopBlock('#MonitorCondition');
			ParamsObj.SterMainId = row.RowId;
			var Check = ParamsObj.Check;
			if (isEmpty(Check)) {
				$UI.msg('alert', '请选择需要监测合格的类型!');
				return false;
			}
			$UI.confirm('您确定要执行取消监测操作吗？', '', '', CancelMonitor, '', '', '', '', ParamsObj);
		}
	});
	function CancelMonitor(ParamsObj) {
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsCancelMonitor',
			Params: JSON.stringify(ParamsObj)
		}, function(jsonData) {
			if (jsonData.success >= 0) {
				$UI.msg('success', jsonData.msg);
				CurrId = ParamsObj.SterMainId;
				$UI.clear(ItemListGrid);
				$('#Check').keywords('clearAllSelected');
				MainListGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$UI.linkbutton('#CancelBT', {
		onClick: function() {
			var row = $('#MainList').datagrid('getSelected');
			if (isEmpty(row)) {
				$UI.msg('alert', '请选则需要操作的单据!');
				return false;
			}
			if (row.IsCHK === '') {
				$UI.msg('alert', '该灭菌未验收，不能进行取消验收操作!');
				return false;
			}
			var ParamsObj = $UI.loopBlock('#MainCondition');
			ParamsObj.SterMainId = row.RowId;
			$UI.confirm('您确定要执行取消验收操作吗？', '', '', CancelCheck, '', '', '', '', ParamsObj);
		}
	});
	function CancelCheck(ParamsObj) {
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsCancel',
			Params: JSON.stringify(ParamsObj)
		}, function(jsonData) {
			if (jsonData.success >= 0) {
				$UI.msg('success', jsonData.msg);
				CurrId = ParamsObj.SterMainId;
				$UI.clear(ItemListGrid);
				MainListGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#OKBT', {
		onClick: function() {
			$.messager.confirm('操作提示', '您确定要执行灭菌合格操作吗？', function(data) {
				if (data) {
					SteOK();
				}
			});
		}
	});
	// 合格
	function SteOK() {
		var SterMainRow = MainListGrid.getSelectedData();
		if (isEmpty(SterMainRow)) {
			$UI.msg('alert', '请选则需要操作的单据!');
			return false;
		}
		var ParamsObj = $UI.loopBlock('#MonitorCondition');
		ParamsObj.SterMainId = SterMainRow[0].RowId;
		ParamsObj.IsSterFinish = IsSterFinish;
		ParamsObj.Remark = SterMainRow[0].Remark;
		var Params = JSON.stringify(ParamsObj);
		var CheckUserValue = $('#CheckUserValue').combobox('getValue');
		if (IsGetUserCheckByLoginVal === 'N') {
			if (CheckUserValue === '') {
				$UI.msg('alert', '验收人不能为空！');
				$('#CheckUserValue').focus();
				return;
			}
		}
		if (SterMainRow[0].IsCHK === '1') {
			$UI.msg('alert', '已验收合格，不能进行验收合格操作!');
			return false;
		} else if (SterMainRow[0].IsCHK === '2') {
			$UI.msg('alert', '已验收不合格，不能进行验收合格操作!');
			return false;
		} else {
			$.cm({
				ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
				MethodName: 'jsOK',
				Params: Params
			}, function(jsonData) {
				if (jsonData.success >= 0) {
					$UI.msg('success', jsonData.msg);
					CurrId = SterMainRow[0].RowId;
					$UI.clear(ItemListGrid);
					if ((AtuoPhyCheckOk === 'Y') && (isEmpty(SterMainRow[0].PhyResult)) && (SterMainRow[0].IsPhy === 'Y')) {
						PhyOK(false);
					}
					if ((AtuoCheCheckOk === 'Y') && (isEmpty(SterMainRow[0].CheResult)) && (SterMainRow[0].IsChe === 'Y')) {
						setTimeout(function() {
							CheOK();
						}, 100);
					}
					MainListGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	}

	$UI.linkbutton('#FailBT', {
		onClick: function() {
			var Row = MainListGrid.getSelectedData();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选则需要操作的单据!');
				return false;
			}
			var ReasonId = $('#UnqualifiedReason').combobox('getValue');
			if (Row[0].IsCHK === '1') {
				$UI.msg('alert', '已验收合格，不能进行验收不合格操作!');
				return false;
			} else if (Row[0].IsCHK === '2') {
				$UI.msg('alert', '已验收不合格，不能进行验收不合格操作!');
				return false;
			} else {
				if (isEmpty(ReasonId)) {
					$UI.msg('alert', '请选择原因!');
					$('#UnqualifiedReason').combobox('textbox').focus();
					return false;
				}
			}
			var CheckUserValue = $('#CheckUserValue').combobox('getValue');
			if (IsGetUserCheckByLoginVal === 'N') {
				if (CheckUserValue === '') {
					$UI.msg('alert', '验收人不能为空！');
					$('#CheckUserValue').focus();
					return;
				}
			}
			var CheckTime = $('#CheckTime').val();
			var ParamsObj = addSessionParams({ SterMainId: Row[0].RowId, ReasonId: ReasonId, IsSterFinish: IsSterFinish, Remark: Row[0].Remark, CheckUserValue: CheckUserValue, CheckTime: CheckTime });
			$.messager.confirm('操作提示', '您确定要执行灭菌不合格操作吗？', function(data) {
				if (data) {
					SteFail(ParamsObj);
				}
			});
		}
	});

	// 不合格
	function SteFail(ParamsObj) {
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsFail',
			Params: JSON.stringify(ParamsObj)
		}, function(jsonData) {
			if (jsonData.success >= 0) {
				$UI.msg('success', jsonData.msg);
				CurrId = ParamsObj.SterMainId;
				$UI.clear(ItemListGrid);
				MainListGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	// 物理验收合格
	function PhyOK(ReloadFlag) {
		if (isEmpty(ReloadFlag)) {
			ReloadFlag = true;
		}
		var Row = $('#MainList').datagrid('getSelected');
		if (isEmpty(Row)) {
			$UI.msg('alert', '请选操作数据!');
			return false;
		}
		var SterMainId = Row['RowId'];
		if (Row.PhyResult === '1') {
			$UI.msg('alert', '已监测合格，不能进行此操作!');
			return false;
		} else if (Row.PhyResult === '2') {
			$UI.msg('alert', '已监测不合格，不能进行此操作!');
			return false;
		}
		var ConditionObj = $UI.loopBlock('#MainCondition');
		var CheckUserId = ConditionObj['CheckUserValue'], CheckTime = ConditionObj['CheckTime'];
		var ParamsObj = {
			MonitorType: 'Phy',
			CheckResult: '1',		// 1-合格, 2-不合格
			SterMainId: SterMainId,
			CheckUserId: CheckUserId,
			CheckTime: CheckTime
		};
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsCheckMonitor',
			Params: JSON.stringify(addSessionParams(ParamsObj))
		}, function(jsonData) {
			if (jsonData.success >= 0) {
				$UI.msg('success', jsonData.msg);
				CurrId = SterMainId;
				if (ReloadFlag) {
					MainListGrid.reload();
				}
			} else {
				$UI.msg('alert', jsonData.msg);
			}
		});
	}

	// 物理验收不合格
	function PhyFail() {
		var Row = $('#MainList').datagrid('getSelected');
		if (isEmpty(Row)) {
			$UI.msg('alert', '请选操作数据!');
			return false;
		}
		var SterMainId = Row['RowId'];
		if (Row.PhyResult === '1') {
			$UI.msg('alert', '已监测合格，不能进行此操作!');
			return false;
		} else if (Row.PhyResult === '2') {
			$UI.msg('alert', '已监测不合格，不能进行此操作!');
			return false;
		}
		var ConditionObj = $UI.loopBlock('#MonitorCondition');
		var CheckUserId = ConditionObj['CheckUserValue'], CheckTime = ConditionObj['CheckTime'];
		var ParamsObj = {
			MonitorType: 'Phy',
			CheckResult: '2',		// 1-合格, 2-不合格
			SterMainId: SterMainId,
			CheckUserId: CheckUserId,
			CheckTime: CheckTime
		};
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsCheckMonitor',
			Params: JSON.stringify(addSessionParams(ParamsObj))
		}, function(jsonData) {
			if (jsonData.success >= 0) {
				$UI.msg('success', jsonData.msg);
				CurrId = SterMainId;
				MainListGrid.reload();
			} else {
				$UI.msg('alert', jsonData.msg);
			}
		});
	}

	// 生物验收合格
	function BioOK() {
		var Row = $('#MainList').datagrid('getSelected');
		if (isEmpty(Row)) {
			$UI.msg('alert', '请选操作数据!');
			return false;
		}
		var SterMainId = Row['RowId'];
		if (Row.BatLabel === '1') {
			$UI.msg('alert', '已监测合格，不能进行此操作!');
			return false;
		} else if (Row.BatLabel === '2') {
			$UI.msg('alert', '已监测不合格，不能进行此操作!');
			return false;
		}
		var ConditionObj = $UI.loopBlock('#MainCondition');
		var CheckUserId = ConditionObj['CheckUserValue'], CheckTime = ConditionObj['CheckTime'];
		var ParamsObj = {
			MonitorType: 'Bio',
			CheckResult: '1',		// 1-合格, 2-不合格
			SterMainId: SterMainId,
			CheckUserId: CheckUserId,
			CheckTime: CheckTime
		};
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsCheckMonitor',
			Params: JSON.stringify(addSessionParams(ParamsObj))
		}, function(jsonData) {
			if (jsonData.success >= 0) {
				$UI.msg('success', jsonData.msg);
				CurrId = SterMainId;
				MainListGrid.reload();
			} else {
				$UI.msg('alert', jsonData.msg);
			}
		});
	}

	// 生物验收不合格
	function BioFail() {
		var Row = $('#MainList').datagrid('getSelected');
		if (isEmpty(Row)) {
			$UI.msg('alert', '请选操作数据!');
			return false;
		}
		var SterMainId = Row['RowId'];
		if (Row.BatLabel === '1') {
			$UI.msg('alert', '已监测合格，不能进行此操作!');
			return false;
		} else if (Row.BatLabel === '2') {
			$UI.msg('alert', '已监测不合格，不能进行此操作!');
			return false;
		}
		var ConditionObj = $UI.loopBlock('#MonitorCondition');
		var CheckUserId = ConditionObj['CheckUserValue'], CheckTime = ConditionObj['CheckTime'];
		var ParamsObj = {
			MonitorType: 'Bio',
			CheckResult: '2',		// 1-合格, 2-不合格
			SterMainId: SterMainId,
			CheckUserId: CheckUserId,
			CheckTime: CheckTime
		};
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsCheckMonitor',
			Params: JSON.stringify(addSessionParams(ParamsObj))
		}, function(jsonData) {
			if (jsonData.success >= 0) {
				if (SterParamObj.IsBioFailReCall === 'Y') {
					$UI.msg('alert', '生物监测不合格,请召回该批次包！');
				}
				CurrId = SterMainId;
				MainListGrid.reload();
			} else {
				$UI.msg('alert', jsonData.msg);
			}
		});
	}

	// 化学验收合格
	function CheOK() {
		var Row = $('#MainList').datagrid('getSelected');
		if (isEmpty(Row)) {
			$UI.msg('alert', '请选操作数据!');
			return false;
		}
		var SterMainId = Row['RowId'];
		if (Row.CheResult === '1') {
			$UI.msg('alert', '已监测合格，不能进行此操作!');
			return false;
		} else if (Row.CheResult === '2') {
			$UI.msg('alert', '已监测不合格，不能进行此操作!');
			return false;
		}
		var ConditionObj = $UI.loopBlock('#MainCondition');
		var CheckUserId = ConditionObj['CheckUserValue'], CheckTime = ConditionObj['CheckTime'];
		var ParamsObj = {
			MonitorType: 'Che',
			CheckResult: '1',		// 1-合格, 2-不合格
			SterMainId: SterMainId,
			CheckUserId: CheckUserId,
			CheckTime: CheckTime
		};
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsCheckMonitor',
			Params: JSON.stringify(addSessionParams(ParamsObj))
		}, function(jsonData) {
			if (jsonData.success >= 0) {
				$UI.msg('success', jsonData.msg);
				CurrId = SterMainId;
				MainListGrid.reload();
			} else {
				$UI.msg('alert', jsonData.msg);
			}
		});
	}
	// 化学验收不合格
	function CheFail() {
		var Row = $('#MainList').datagrid('getSelected');
		if (isEmpty(Row)) {
			$UI.msg('alert', '请选操作数据!');
			return false;
		}
		var SterMainId = Row['RowId'];
		if (Row.CheResult === '1') {
			$UI.msg('alert', '已监测合格，不能进行此操作!');
			return false;
		} else if (Row.CheResult === '2') {
			$UI.msg('alert', '已监测不合格，不能进行此操作!');
			return false;
		}
		var ConditionObj = $UI.loopBlock('#MonitorCondition');
		var CheckUserId = ConditionObj['CheckUserValue'], CheckTime = ConditionObj['CheckTime'];
		var ParamsObj = {
			MonitorType: 'Che',
			CheckResult: '2',		// 1-合格, 2-不合格
			SterMainId: SterMainId,
			CheckUserId: CheckUserId,
			CheckTime: CheckTime
		};
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsCheckMonitor',
			Params: JSON.stringify(addSessionParams(ParamsObj))
		}, function(jsonData) {
			if (jsonData.success >= 0) {
				$UI.msg('success', jsonData.msg);
				CurrId = SterMainId;
				MainListGrid.reload();
			} else {
				$UI.msg('alert', jsonData.msg);
			}
		});
	}

	$UI.linkbutton('#FileMatchBT', {
		onClick: function() {
			var Row = $('#MainList').datagrid('getSelected');
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选操作数据!');
				return false;
			}
			var RowId = Row.RowId;
			var filelist = $('#FileSel').filebox('files');
			var SelFileName = '';
			if (filelist.length > 0) {
				SelFileName = filelist[0].name;
			}
			if ((isEmpty(SelFileName)) && (isEmpty(Row.MachineFileName))) {
				FileMatch(RowId);
			} else if (!isEmpty(SelFileName)) {
				var DataFtpIP = MachineFtpObj.FtpIp;
				if (DataFtpIP === gClientIP) {
					var Params = JSON.stringify(addSessionParams({ RowId: RowId, FileName: SelFileName, Type: 'sterilizer' }));
					if (isEmpty(Row.MachineFileName)) {
						ReFileMatch(Params);
					} else {
						$UI.confirm('已关联文件，是否重新匹配?', 'question', '', ReFileMatch, '', '', '', '', Params);
					}
				} else {
					$UI.msg('alert', '请在存放机器数据的电脑上进行重新匹配!');
					return;
				}
			} else {
				$UI.msg('alert', '请选择文件后再匹配!');
				return;
			}
		}
	});

	function FileMatch(RowId) {
		var Params = JSON.stringify(addSessionParams({ RowIdStr: RowId, Type: 'sterilizer' }));
		$.cm({
			ClassName: 'web.CSSDHUI.MachineData.DataDeal',
			MethodName: 'jsFileMatch',
			Params: Params
		}, function(jsonData) {
			$UI.msg('alert', jsonData.msg);
			CurrId = RowId;
			MainListGrid.reload();
		});
	}

	function ReFileMatch(Params) {
		$.cm({
			ClassName: 'web.CSSDHUI.MachineData.DataDeal',
			MethodName: 'jsReFileMatch',
			Params: Params
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('alert', jsonData.msg);
			}
			$('#FileSel').filebox('clear');
		});
	}

	$UI.linkbutton('#ViewPicBT', {
		onClick: function() {
			var Row = MainListGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择灭菌记录！');
				return;
			}
			var RowId = Row.RowId;
			ViewPic('Ster', RowId);
		}
	});

	// 拍照
	$UI.linkbutton('#TakePhotoBT', {
		onClick: function() {
			var Row = MainListGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择灭菌记录！');
				return;
			}
			var RowId = Row.RowId;
			TakePhotoWin('Ster', RowId);
		}
	});

	var ReasonCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetRetReason&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: gHospId })),
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = MainListGrid.getRows();
				var row = rows[MainListGrid.editIndex];
				row.ReasonDesc = record.Description;
			}
		}
	};

	$('#Check').keywords({
		singleSelect: true,
		items: [
			{ text: '生物', id: '1' }, { text: '化学', id: '2' }, { text: '物理', id: '3' }
		]
	});

	var MainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			field: 'operate',
			title: '标识',
			align: 'center',
			width: 50,
			formatter: function(value, row, index) {
				var str = '';
				if (row.LevelFlag === '1') {
					str = '<div class="col-icon icon-emergency" title="紧急" ></div>';
				}
				return str;
			}
		}, {
			title: '验收结果',
			field: 'IsCHK',
			width: 100,
			align: 'center',
			formatter: function(value, row, index) {
				if (row.IsCHK === '1') {
					return '合格';
				} else if (row.IsCHK === '2') {
					return '不合格';
				} else if (row.IsCHK === '') {
					return '未验收';
				}
			},
			styler: function(value, row, index) {
				if (value === '1') {
					return 'color:white;background:' + GetColorCode('green');
				} else if (value === '2') {
					return 'color:white;background:' + GetColorCode('red');
				} else {
					return 'color:white;background:' + GetColorCode('yellow');
				}
			}
		}, {
			title: '灭菌器',
			field: 'MachineNo',
			width: 80
		}, {
			title: '灭菌批号',
			field: 'No',
			width: 140
		}, {
			title: '灭菌程序',
			field: 'Progress',
			width: 80
		}, {
			title: '单据类型',
			field: 'SterType',
			width: 150,
			styler: function(value, row, index) {
				if (row.LeakLabelFlag === '1') {
					return 'color:' + GetFontColorCode('yellow');
				} else if (row.BDLabelFlag === '1') {
					return 'color:' + GetFontColorCode('red');
				} else if (row.IsBio === 'Y') {
					return 'color:' + GetFontColorCode('blue');
				}
			}
		}, {
			title: '灭菌人',
			field: 'SterName',
			width: 80
		}, {
			title: '灭菌时间',
			field: 'SterDateTime',
			width: 160
		}, {
			title: '不合格原因',
			field: 'ReasonDesc',
			width: 160
		}, {
			title: '验收人',
			field: 'chkame',
			width: 80
		}, {
			title: '验收时间',
			field: 'CheckDateTime',
			width: 160
		}, {
			title: '物理验收人',
			field: 'PhyName',
			width: 80
		}, {
			title: '物理验收时间',
			field: 'PhyCHKDateTime',
			width: 160
		}, {
			title: '物理监测结果',
			field: 'PhyResult',
			align: 'center',
			width: 100,
			styler: flagColor,
			formatter: function(value, row, index) {
				if (row.PhyResult === '1') {
					return '合格';
				} else if (row.PhyResult === '2') {
					return '不合格';
				}
			}
		}, {
			title: '生物验收人',
			field: 'BioCHKName',
			width: 80
		}, {
			title: '生物验收时间',
			field: 'BioCHKDateTime',
			width: 160
		}, {
			title: '生物监测结果',
			field: 'BatLabel',
			align: 'center',
			width: 100,
			styler: flagColor,
			formatter: function(value, row, index) {
				if (row.BatLabel === '1') {
					return '合格';
				} else if (row.BatLabel === '2') {
					return '不合格';
				}
			}
		}, {
			title: '化学验收人',
			field: 'CheCHKName',
			width: 80
		}, {
			title: '化学验收时间',
			field: 'CheCHKDateTime',
			width: 160
		}, {
			title: '化学监测结果',
			field: 'CheResult',
			align: 'center',
			width: 100,
			styler: flagColor,
			formatter: function(value, row, index) {
				if (row.CheResult === '1') {
					return '合格';
				} else if (row.CheResult === '2') {
					return '不合格';
				}
			}
		}, {
			title: '紧急状态',
			field: 'LevelFlag',
			width: 100,
			hidden: true
		}, {
			title: '机器存储文件',
			field: 'MachineFileName',
			align: 'center',
			width: 160
		}, {
			title: '路径',
			field: 'MachineUrl',
			width: 200,
			hidden: true
		}, {
			title: '备注',
			field: 'Remark',
			width: 200,
			editor: { type: 'validatebox' }
		}
	]];

	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			QueryName: 'SelectAll'
		},
		columns: MainCm,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				var GridListIndex = '';
				if (!isEmpty(CurrId)) {
					var Rows = $('#MainList').datagrid('getRows');
					$.each(Rows, function(index, item) {
						if (item.RowId == CurrId) {
							GridListIndex = index;
							return false;
						}
					});
					CurrId = '';
				} else if (CommParObj.SelectFirstRow === 'Y') {
					GridListIndex = 0;
				}
				if (!isEmpty(GridListIndex)) {
					$('#MainList').datagrid('selectRow', GridListIndex);
				}
			}
		},
		onClickRow: function(index, row) {
			var IsCHK = row.IsCHK;
			if (isEmpty(IsCHK)) {
				MainListGrid.commonClickRow(index, row);
			}
		},
		onSelect: function(index, rowData) {
			var SterMainId = rowData.RowId;
			if (!isEmpty(SterMainId)) {
				QuerySterItm();
			}
		},
		onDblClickRow: function(index, row) {
			var Row = MainListGrid.getRows()[index];
			var RowId = Row.RowId;
			if (!isEmpty(RowId)) {
				SterChart('sterilizer', RowId, gHospId);
			}
		}
	});

	$HUI.tabs('#SterCheckTabs', {
		onSelect: function(title, index) {
			tabTitle = title;
			QuerySterItm();
		}
	});

	function QuerySterItm() {
		var row = $('#MainList').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择灭菌数据!');
			return false;
		}
		var SterMainId = row.RowId;
		var Label = $('#Label').val();
		if (tabTitle === '灭菌详情') {
			$UI.clear(ItemListGrid);
			ItemListGrid.load({
				ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeItem',
				QueryName: 'SelectByF',
				SterMainId: SterMainId,
				Label: Label,
				rows: 9999
			});
		} else if (tabTitle === '灭菌汇总') {
			$UI.clear(ItemListSum);
			ItemListSum.load({
				ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeItem',
				QueryName: 'SelectSumItms',
				SterMainId: SterMainId,
				Label: Label,
				rows: 9999
			});
		}
	}

	// 标签过滤
	$('#Label').keyup(function(event) {
		if (event.which === 13) {
			var Row = $('#MainList').datagrid('getSelected');
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择灭菌数据!');
				return false;
			}
			var SterMainId = Row.RowId;
			FindItemByF(SterMainId);
		}
	});
	// 不合格原因
	$HUI.combobox('#UnqualifiedReason', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetRetReason&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: gHospId })),
		valueField: 'RowId',
		textField: 'Description'
	});
	// 单个明细验收不合格
	$UI.linkbutton('#CheckFailBT', {
		onClick: function() {
			var SterMainRow = MainListGrid.getSelected();
			if (isEmpty(SterMainRow)) {
				$UI.msg('alert', '请选择需要验收的灭菌单据!');
				return;
			}
			var SterMainId = SterMainRow.RowId;
			if (!isEmpty(SterMainRow.IsCHK)) {
				$UI.msg('alert', '该灭菌单据已验收,无法重复验收');
				return;
			}
			var Detail = ItemListGrid.getChecked();
			if (isEmpty(Detail)) {
				$UI.msg('alert', '请选择不合格的灭菌明细');
				return;
			}
			var ReasonId = $('#UnqualifiedReason').combobox('getValue');
			if (isEmpty(ReasonId)) {
				$UI.msg('alert', '请选择不合格原因');
				return;
			}
			var ItmIds = '';
			$.each(Detail, function(index, item) {
				if (ItmIds === '') {
					ItmIds = item.RowId;
				} else {
					ItmIds = ItmIds + ',' + item.RowId;
				}
			});
			var Params = JSON.stringify(addSessionParams({ SterMainId: SterMainId, ReasonId: ReasonId, ItmIds: ItmIds, IsSterFinish: IsSterFinish }));
			$.cm({
				ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
				MethodName: 'jsSingleFail',
				Params: Params
			}, function(jsonData) {
				if (jsonData.success >= 0) {
					$('#UnqualifiedReason').combobox('setValue', '');
					$UI.msg('success', jsonData.msg);
					CurrId = SterMainId;
					MainListGrid.reload();
				} else {
					$('#UnqualifiedReason').combobox('setValue', '');
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	function flagColor(val, row, index) {
		if (val === '2') {
			return 'color:white;background:' + GetColorCode('red');
		} else if (val === '1') {
			return 'color:white;background:' + GetColorCode('green');
		}
	}

	var ItemSumCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 200
		}, {
			title: '合计数量',
			field: 'Qty',
			width: 80,
			align: 'right'
		}
	]];

	var ItemListSum = $UI.datagrid('#ItemListSum', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeItem',
			QueryName: 'SelectSumItms'
		},
		columns: ItemSumCm,
		fitColumns: true,
		pagination: false
	});

	var ItemCm = [[
		{
			title: '',
			field: 'ck',
			checkbox: true,
			width: 30
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			field: 'operate',
			title: '标识',
			align: 'center',
			width: 50,
			formatter: function(value, row, index) {
				if (row.LevelFlag === '1') {
					var str = '<div class="col-icon icon-emergency" title="紧急" ></div>';
				}
				return str;
			}
		}, {
			title: '标签',
			field: 'Label',
			width: 155
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 130
		}, {
			title: '数量',
			field: 'Qty',
			width: 50
		}, {
			title: '不合格原因',
			field: 'ReasonId',
			width: 130,
			formatter: CommonFormatter(ReasonCombox, 'ReasonId', 'ReasonDesc')
		}, {
			title: '紧急状态',
			field: 'LevelFlag',
			width: 50,
			hidden: true
		}
	]];

	var ItemListGrid = $UI.datagrid('#ItemList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeItem',
			QueryName: 'SelectByF'
		},
		columns: ItemCm,
		pagination: false,
		singleSelect: false,
		selectOnCheck: false,
		sortName: 'RowId',
		sortOrder: 'desc'
	});

	function FindItemByF(SterMainId) {
		$UI.clear(ItemListGrid);
		$('#UnqualifiedReason').combobox('setValue', '');
		var Label = $('#Label').val();
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeItem',
			QueryName: 'SelectByF',
			SterMainId: SterMainId,
			PLabel: Label,
			rows: 9999
		});
	}

	// 设置默认值
	function setDefault() {
		$UI.clearBlock('#MainCondition');
		var FComplateFlag = 'Y';
		if (IsSterFinish === 'Y') {
			FComplateFlag = 'F';
		}
		var Default = {
			FStartDate: DefaultStDate(),
			FEndDate: DefaultEdDate(),
			FComplateFlag: FComplateFlag,
			SterInLoc: gLocId,
			QueryState: GetLocalStorage('QueryState')
		};
		$UI.fillBlock('#MainCondition', Default);
	}
	setDefault();
	Query();
};
$(init);