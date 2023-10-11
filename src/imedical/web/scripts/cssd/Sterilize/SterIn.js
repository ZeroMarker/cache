// 删除明细
var MainListGrid, ItemListGrid, ItemListSum;
var tabTitle = '灭菌详情';
var init = function() {
	// 获取页面传参
	function getQueryVariable(variable) {
		var query = window.location.search.substring(1);
		var vars = query.split('&');
		for (var i = 0; i < vars.length; i++) {
			var pair = vars[i].split('=');
			if (pair[0] === variable) {
				return pair[1];
			}
		}
		return (false);
	}
	var PackTypeDetail = '6';		// 代表灭菌架
	var SterType = '2001';			// 灭菌方式
	var CurrId = '';
	var IsGetUserByLoginVal = SterParamObj.IsGetUserByLogin;	// 灭菌人是否取登录人

	// 灭菌科室
	var SterLocParams = JSON.stringify(addSessionParams({ Type: 'Login', BDPHospital: gHospId }));
	$HUI.combobox('#SterLocId', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SterLocParams,
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
		spellField: 'MachineNo',
		onSelect: function(record) {
			var MachineNo = record['MachineNo'];
			MachineEnter(MachineNo);
		}
	});
	$('#MachineNoValue').combobox('textbox').keyup(function(event) {
		if (event.which === 13) {
			var Value = $('#MachineNoValue').combobox('getValue');
			if (isEmpty(Value)) {
				var MachineVal = $('#MachineNoValue').combobox('getText');
				MachineEnter(MachineVal);
			}
			SetFocusAdd();
		}
	});
	function MachineEnter(MachineVal) {
		var SupLocId = $('#SterLocId').combobox('getValue');
		var MachineParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, SupLocId: SupLocId }));
		var MachineObj = $.cm({
			ClassName: 'web.CSSDHUI.Common.Dicts',
			MethodName: 'GetSterMachineInfo',
			MachineNo: MachineVal,
			Params: MachineParams
		}, false);
		var machineNoDr = MachineObj['ID'], SterWay = MachineObj['TempType'],
			SterCarDr = MachineObj['SterCarDr'], SterCarName = MachineObj['CarName'],
			Msg = MachineObj['Msg'];
		if (!isEmpty(Msg)) {
			$UI.msg('alert', Msg);
			$('#MachineNoValue').combobox('setValue', '');
			return;
		}

		// 选择灭菌器的时候，重新加载灭菌车
		$('#SterCarValue').combobox('clear');
		var Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId, SterWay: SterWay }));
		var url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllSterCar&ResultSetType=array&PackTypeDetail=' + PackTypeDetail + '&Params=' + Params;
		$('#SterCarValue').combobox('reload', url);
		// 选择灭菌器的时候，重新加载灭菌程序
		$('#SterProValue').combobox('clear');
		url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetProCom&ResultSetType=array&type=' + SterType + '&Params=' + Params;
		$('#SterProValue').combobox('reload', url);

		$('#MachineNoValue').combobox('setValue', machineNoDr).combobox('hidePanel');
		$('#MachineNoSterType').val(SterWay);

		if (SterParamObj.IsMachineBindCar === 'Y') {
			if (isEmpty(SterCarDr)) {
				$UI.msg('alert', '灭菌器未与灭菌架进行绑定，请先绑定！');
				return;
			}
			AddComboData($('#SterCarValue'), SterCarDr, SterCarName);
			$('#SterCarValue').combobox('setValue', SterCarDr);
		}
	}

	// 灭菌架
	$HUI.combobox('#SterCarValue', {
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'Code'
	});
	$('#SterCarValue').combobox('textbox').keyup(function(event) {
		if (event.which === 13) {
			var Value = $('#SterCarValue').combobox('getValue');
			if (!isEmpty(Value)) {
				// SetFocusAdd();
			} else {
				var SterCarValue = $('#SterCarValue').combobox('getText');
				SterCarEnter(SterCarValue);
			}
			SetFocusAdd();
		}
	});
	var ParamsCarTB = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	function SterCarEnter(SterCarText) {
		if (isEmpty(SterCarText)) {
			return;
		}
		var SterProObj = $.cm({
			ClassName: 'web.CSSDHUI.Common.Dicts',
			MethodName: 'GetSterCar',
			type: PackTypeDetail,
			SterCar: SterCarText,
			Params: ParamsCarTB
		}, false);
		var DictId = SterProObj['DictId'];
		var Ret = SterProObj['Ret'];
		var CarSterType = SterProObj['SterType'];
		if (DictId === '') {
			$UI.msg('alert', '未获取到灭菌架相关信息！');
			$('#SterCarValue').combobox('setValue', '');
			return;
		}
		if (Ret === 'N') {
			$UI.msg('alert', '错误的灭菌架标牌!');
			$('#SterCarValue').combobox('setValue', '');
			return;
		}
		if (CarSterType === '') {
			$UI.msg('alert', '该灭菌架未维护灭菌方式，请先维护！');
			$('#SterCarValue').combobox('setValue', '');
			return;
		}
		$('#SterCarValue').combobox('setValue', DictId).combobox('hidePanel');
	}

	// 灭菌程序
	$HUI.combobox('#SterProValue', {
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'Code',
		onLoadSuccess: function(data) {
			if (data.length == 1) {
				var Value = data[0][$(this).combobox('options')['valueField']];
				$(this).combobox('select', Value);
			}
		}
	});
	$('#SterProValue').combobox('textbox').keyup(function(event) {
		if (event.which === 13) {
			var Value = $('#SterProValue').combobox('getValue');
			if (isEmpty(Value)) {
				var SterProValue = $('#SterProValue').combobox('getText');
				SterProEnter(SterProValue);
			}
			SetFocusAdd();
		}
	});

	var ParamsProTB = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	function SterProEnter(SterProStr) {
		if (SterProStr === '') {
			return;
		}
		var SterProObj = $.cm({
			ClassName: 'web.CSSDHUI.Common.Dicts',
			MethodName: 'GetSterPro',
			type: '2001',
			SterPro: SterProStr,
			Params: ParamsProTB
		}, false);
		var SterProID = SterProObj['SterProID'];
		var ProSterWay = SterProObj['SterWay'];
		var SterCode = SterProObj['SterCode'];
		var SterWayDesc = SterProObj['SterWayDesc'];
		if (SterProID === '') {
			$UI.msg('alert', '未获取到可用灭菌程序信息！');
			$('#SterProValue').combobox('setValue', '');
			return;
		}

		if (ProSterWay === '') {
			$UI.msg('alert', '该灭菌程序未维护灭菌方式，请先维护！');
			$('#SterProValue').combobox('setValue', '');
			return;
		}
		var MachineNoSterType = $('#MachineNoSterType').val();
		if (MachineNoSterType === '') {
			$UI.msg('alert', '请先录入灭菌器！');
			$('#SterProValue').combobox('setValue', '');
			return;
		}
		if (ProSterWay !== MachineNoSterType) {
			$UI.msg('alert', '灭菌程序' + SterCode + '为' + SterWayDesc + ',灭菌程序与灭菌器的灭菌方式不匹配！');
			$('#SterProValue').combobox('setValue', '').combobox('hidePanel');
		} else {
			$('#SterProValue').combobox('setValue', SterProID).combobox('hidePanel');
		}
	}

	$('#SterTime').focus(function(enent) {
		var value = $('#SterTime').timespinner('getValue');
		if (isEmpty(value)) {
			var Time = GetNowTime();
			$('#SterTime').timespinner('setValue', Time);
		}
	});

	$('#SterTime').keyup(function(event) {
		if (event.keyCode == 13) {
			SetFocusAdd();
		}
	});
	// 灭菌人员
	$HUI.combobox('#SterUserValue', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: gHospId })),
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		defaultFilter: 6,
		spellField: 'Code'
	});
	$('#SterUserValue').combobox('textbox').keyup(function(event) {
		if (event.which === 13) {
			var Value = $('#SterUserValue').combobox('getValue');
			if (isEmpty(Value)) {
				var SterUserValue = $('#SterUserValue').combobox('getText');
				SterUserEnter(SterUserValue);
			}
			SetFocusAdd();
		}
	});

	var ParamsUserTB = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	function SterUserEnter(UserCode) {
		if (isEmpty(UserCode)) {
			$UI.msg('alert', '请录入灭菌人！');
			return;
		}
		var UserObj = $.cm({
			ClassName: 'web.CSSDHUI.Common.Dicts',
			MethodName: 'GetUserByCodeJson',
			userCode: UserCode,
			Params: ParamsUserTB
		}, false);
		if (UserObj['RowId'] === '') {
			$UI.msg('alert', '未获取灭菌人相关信息！');
			$('#SterUserValue').combobox('setValue', '').combobox('hidePanel');
			return;
		}
		$('#SterUserValue').combobox('setValue', UserObj['RowId']).combobox('hidePanel');
	}

	// 保存生成灭菌单据
	function SaveMain() {
		var ParamsObj = $UI.loopBlock('#MainCondition');
		if (isEmpty(ParamsObj.SterLocId)) {
			$UI.msg('alert', '请选择灭菌科室！');
			$('#SterLocId').combobox('textbox').focus();
			return;
		}
		if (isEmpty(ParamsObj.MachineNoValue)) {
			$UI.msg('alert', '请录入灭菌器！');
			$('#MachineNoValue').combobox('textbox').focus();
			return;
		}
		if (isEmpty(ParamsObj.SterProValue)) {
			$UI.msg('alert', '请录入灭菌程序！');
			$('#SterProValue').combobox('textbox').focus();
			return;
		}
		if (isEmpty(ParamsObj.SterUserValue)) {
			if (IsGetUserByLoginVal == 'Y') {
				ParamsObj.SterUserValue = gUserId;
			} else {
				$UI.msg('alert', '请录入灭菌人！');
				$('#SterUserValue').combobox('textbox').focus();
				return;
			}
		}

		var Params = JSON.stringify(ParamsObj);
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsSave',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				CurrId = jsonData.rowid;
				if (!isEmpty(CurrId)) {
					Query(CurrId);
				}
				var MainObj = $UI.loopBlock('#MainCondition');
				var MainData = {
					FStartDate: MainObj['FStartDate'],
					FEndDate: MainObj['FEndDate'],
					SterLocId: MainObj['SterLocId']
				};
				$UI.clearBlock('#MainCondition');
				$UI.fillBlock('#MainCondition', MainData);

				$('#BarCode').focus();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function SetFocusAdd() {
		var ParamsObj = $UI.loopBlock('#MainCondition');
		var MachineNoValue = ParamsObj['MachineNoValue'], SterCarValue = ParamsObj['SterCarValue'],
			SterProValue = ParamsObj.SterProValue, SterUserValue = ParamsObj['SterUserValue'];

		if (isEmpty(MachineNoValue)) {
			$('#MachineNoValue').combobox('textbox').focus();
			return;
		}
		if (isEmpty(SterCarValue)) {
			$('#SterCarValue').combobox('textbox').focus();
			return;
		}
		if (isEmpty($('#SterTime').timespinner('getValue'))) {
			$('#SterTime').focus();
			return;
		}
		if (isEmpty(SterProValue)) {
			$('#SterProValue').combobox('textbox').focus();
			return;
		}
		if (isEmpty(SterUserValue)) {
			if (IsGetUserByLoginVal == 'Y') {
				$('#SterUserValue').combobox('setValue', gUserId);
			}
			$('#SterUserValue').combobox('textbox').focus();
			return;
		}
		SaveMain();
	}

	$UI.linkbutton('#CreateBT', {
		onClick: function() {
			SaveMain();
		}
	});
	// 查询
	$UI.linkbutton('#FQueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#MainCondition');
			if (isEmpty(ParamsObj.SterLocId)) {
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
	// 取消灭菌
	$UI.linkbutton('#NotOKBT', {
		onClick: function() {
			var Row = $('#MainList').datagrid('getSelected');
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择需要确认取消灭菌的单据！');
				return false;
			}
			if (!isEmpty(Row.IsCHK)) {
				$UI.msg('alert', '已验收无法取消灭菌！');
				return;
			} else if (Row.ComplateFlag === 'N') {
				$UI.msg('alert', '未确认灭菌，不能撤销灭菌！');
				return;
			}
			$UI.confirm('您将要取消灭菌,是否继续?', 'question', '', NotOk);
		}
	});

	// 测漏
	$UI.linkbutton('#LeakTest', {
		onClick: function() {
			Leak();
		}
	});
	// BDTest
	$UI.linkbutton('#BDTest', {
		onClick: function() {
			BD();
		}
	});
	// 修改温度压强
	function Save() {
		var Rows = MainListGrid.getChangesData();
		if (isEmpty(Rows)) return;
		if (Rows == false) {
			$UI.msg('alert', '存在未填写的必填项，不能保存!');
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsUpdateSterInfo',
			Params: JSON.stringify(Rows)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				MainListGrid.reload();
			} else {
				$UI.msg('alert', jsonData.msg);
			}
		});
	}
	// 灭菌器信息打印
	function PotPrint() {
		var row = $('#MainList').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择需要打印的灭菌信息！');
		}
		var CheckType = $g('否');
		var IsBioLabel = $g('否');
		var IsCheLabel = $g('否');
		var IsPhyLabel = $g('否');
		var SterName = row.MachineNo;
		var SterDateTime = row.SterDate + ' ' + row.SterTime;
		var SterPackageNum = row.SterPackageNum + $g('包');
		var SterNo = row.No;
		var BDLabelFlag = row.BDLabelFlag;
		if (!isEmpty(BDLabelFlag)) {
			CheckType = $g('是');
		}
		var IsBio = row.IsBio;
		if ((!isEmpty(IsBio)) && (IsBio === 'Y')) {
			IsBioLabel = $g('是');
		}
		var IsChe = row.IsChe;
		if ((!isEmpty(IsChe)) && (IsChe === 'Y')) {
			IsCheLabel = $g('是');
		}
		var IsPhy = row.IsPhy;
		if ((!isEmpty(IsPhy)) && (IsPhy === 'Y')) {
			IsPhyLabel = $g('是');
		}
		printSterPotInfo(SterName, SterDateTime, SterNo, SterPackageNum, CheckType, IsBioLabel, IsCheLabel, IsPhyLabel);
	}

	function Query(RowId) {
		$UI.clear(ItemListGrid);
		var ParamsObj = $UI.loopBlock('#MainCondition');
		if (!isEmpty(RowId)) {
			ParamsObj['RowId'] = RowId;
		}
		var Params = JSON.stringify(ParamsObj);
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			QueryName: 'SelectAll',
			Params: Params
		});
	}
	function SterRepeatIn() {
		var ParamsObj = $UI.loopBlock('#MainCondition');
		var row = $('#MainList').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择需要重新灭菌的批次！');
			return false;
		}
		if (row.IsCHK !== '2') {
			$UI.msg('alert', '只有灭菌不合格的批次，才能重新灭菌！');
			return false;
		}
		if (row.WorkStatus === 'Y') {
			$UI.msg('alert', '已重新灭菌，不能再次重新灭菌！');
			return false;
		}
		var firstMachineNoType = row.TempType;
		var machineNoType = ParamsObj.MachineNoSterType;
		if (firstMachineNoType !== machineNoType) {
			$UI.msg('alert', '当前灭菌与原有灭菌方式不一致，请重新输入灭菌器！');
			return false;
		}
		ParamsObj['OriginalRowId'] = row['RowId'];
		var Params = JSON.stringify(ParamsObj);
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsRepeatSave',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				CurrId = jsonData.rowid;
				MainListGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	// 更换灭菌器
	function SterChange() {
		var ParamsObj = $UI.loopBlock('#MainCondition');
		if (isEmpty(ParamsObj.SterLocId)) {
			$UI.msg('alert', '请选择灭菌科室！');
			$('#SterLocId').combobox('textbox').focus();
			return;
		}
		if (isEmpty(ParamsObj.MachineNoValue)) {
			$UI.msg('alert', '请录入灭菌器！');
			$('#MachineNoValue').combobox('textbox').focus();
			return;
		}
		if (isEmpty(ParamsObj.SterProValue)) {
			$UI.msg('alert', '请录入灭菌程序！');
			$('#SterProValue').combobox('textbox').focus();
			return;
		}
		if (isEmpty(ParamsObj.SterUserValue)) {
			if (IsGetUserByLoginVal == 'Y') {
				ParamsObj.SterUserValue = gUserId;
			} else {
				$UI.msg('alert', '请录入灭菌人！');
				$('#SterUserValue').combobox('textbox').focus();
				return;
			}
		}

		var row = $('#MainList').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择需要更换的批次！');
			return false;
		}
		if (row.ComplateFlag === 'Y' || row.ComplateFlag === 'F') {
			$UI.msg('alert', '该灭菌单据已经确认灭菌，不允许更换灭菌器!');
			return;
		}
		var firstMachineNoType = row.TempType;
		var machineNoType = ParamsObj.MachineNoSterType;
		if (firstMachineNoType !== machineNoType) {
			$UI.msg('alert', '当前灭菌与原有灭菌方式不一致，请重新输入灭菌器！');
			return false;
		}
		ParamsObj['OriginalRowId'] = row['RowId'];
		var Params = JSON.stringify(ParamsObj);
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsChange',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				if (!isEmpty(jsonData.rowid)) {
					CurrId = jsonData.rowid;
					Query(jsonData.rowid);
				}
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#OKBT', {
		onClick: function() {
			Ok();
		}
	});
	function Ok() {
		var SterMainRow = $('#MainList').datagrid('getSelected');
		if (isEmpty(SterMainRow)) {
			$UI.msg('alert', '请选择需要确认灭菌的灭菌单据！');
			return false;
		}
		var SterPkgNum = SterMainRow.SterPackageNum;
		var Params = $UI.loopBlock('#MainCondition');
		var SterTime = Params.SterTime;
		var LeakLabelFlag = SterMainRow.LeakLabelFlag;
		var BDLabelFlag = SterMainRow.BDLabelFlag;
		var IsBio = SterMainRow.IsBio;
		var RowId = SterMainRow.RowId;
		var RetBat = tkMakeServerCall('web.CSSDHUI.PackageSterilize.SterilizeItem', 'IsBioBat', RowId);
		if ((IsBio === 'N') && (RetBat === '1') && (SterParamObj.IsBioTest !== 'Y')) {
			$UI.msg('alert', '该单需要进行生物监测的消毒包,请选择生物监测！');
			return;
		}
		if (SterMainRow.ComplateFlag === 'Y') {
			$UI.msg('alert', '无法重复确认灭菌！');
			return;
		}
		if (SterMainRow.ComplateFlag === 'F') {
			$UI.msg('alert', '已灭菌完成！');
			return;
		}
		var ParamsObj = { SterMainId: RowId, SterTime: SterTime };
		ParamsObj = addSessionParams(ParamsObj);
		if (((LeakLabelFlag !== '1') && (BDLabelFlag !== '1')) && (SterPkgNum === '0')) {
			$UI.confirm('明细为空,是否继续执行灭菌操作?', '', '', IsSetComplete, '', '', '', '', ParamsObj);
		} else {
			IsSetComplete(ParamsObj);
		}
	}
	function IsSetComplete(ParamsObj) {
		var CurTime = GetNowTime();
		var SterTime = ParamsObj.SterTime;
		if (!isEmpty(SterTime) && (SterTime > CurTime)) {
			$UI.confirm('所选灭菌时间晚于当前时间，是否继续执行？', '', '', SetComplete, '', '', '', '', ParamsObj);
		} else if (isEmpty(SterTime)) {
			$UI.confirm('灭菌时间为空，是否继续执行灭菌操作?', '', '', SetComplete, '', '', '', '', ParamsObj);
		} else {
			SetComplete(ParamsObj);
		}
	}
	function SetComplete(ParamsObj) {
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsSetComplete',
			Params: JSON.stringify(ParamsObj)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				CurrId = ParamsObj.SterMainId;
				MainListGrid.reload();
				$('#SterTime').val('');
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	// 取消灭菌
	function NotOk() {
		var Row = $('#MainList').datagrid('getSelected');
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsNotComplete',
			SterMainId: Row.RowId
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				CurrId = Row.RowId;
				MainListGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	// 灭菌完成
	function SterFinish() {
		var Row = $('#MainList').datagrid('getSelected');
		if (isEmpty(Row)) {
			$UI.msg('alert', '请选择灭菌完成的单据！');
			return false;
		}
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsSetFinish',
			SterMainId: Row.RowId
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				CurrId = Row.RowId;
				MainListGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	// 测漏
	function Leak() {
		var ParamsObj = $UI.loopBlock('#MainCondition');
		if (isEmpty(ParamsObj.SterUserValue)) {
			if (IsGetUserByLoginVal == 'Y') {
				ParamsObj.SterUserValue = gUserId;
			} else {
				$UI.msg('alert', '请录入灭菌人！');
				$('#SterUserValue').combobox('textbox').focus();
				return;
			}
		}

		var Params = JSON.stringify(ParamsObj);
		if (isEmpty(ParamsObj.MachineNoValue) || isEmpty(ParamsObj.SterProValue) || isEmpty(ParamsObj.SterUserValue)) {
			$UI.msg('alert', '请填写完整!');
			SetFocusAdd();
			return;
		}
		var LeakObj = $.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'ConfirmLeakOrBD',
			MachineId: ParamsObj.MachineNoValue,
			Type: 'Leak'
		}, false);
		var Ret = LeakObj['Ret'];
		var Message = LeakObj['Message'];
		if (Ret === 'Y') {
			$UI.confirm(Message, '', '', NeedLeak, '', '', '', '', Params);
		} else {
			NeedLeak(Params);
		}
	}

	function NeedLeak(Params) {
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsLeakTest',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				CurrId = jsonData.rowid;
				if (!isEmpty(jsonData.rowid)) {
					Query(CurrId);
				}
				$('#SterUserValue').combobox('setValue', '');
				$('#SterTime').val('');
				$('#SterUserValue').combobox('textbox').focus();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	// BD监测
	function BD() {
		var ParamsObj = $UI.loopBlock('#MainCondition');
		if (isEmpty(ParamsObj.SterUserValue)) {
			if (IsGetUserByLoginVal == 'Y') {
				ParamsObj.SterUserValue = gUserId;
			} else {
				$UI.msg('alert', '请录入灭菌人！');
				$('#SterUserValue').combobox('textbox').focus();
				return;
			}
		}
		var Params = JSON.stringify(ParamsObj);
		if (isEmpty(ParamsObj.MachineNoValue) || isEmpty(ParamsObj.SterProValue) || isEmpty(ParamsObj.SterUserValue)) {
			$UI.msg('alert', '请填写完整!');
			SetFocusAdd();
			return;
		}
		var BDObj = $.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'ConfirmLeakOrBD',
			MachineId: ParamsObj.MachineNoValue,
			Type: 'BD'
		}, false);
		var Ret = BDObj['Ret'];
		var Message = BDObj['Message'];
		if (Ret === 'Y') {
			$UI.confirm(Message, '', '', NeedBD, '', '', '', '', Params);
		} else {
			NeedBD(Params);
		}
	}

	function NeedBD(Params) {
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsBDTest',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				CurrId = jsonData.rowid;
				if (!isEmpty(jsonData.rowid)) {
					Query(CurrId);
				}
				$('#SterTime').val('');
				$('#SterUserValue').combobox('setValue', '');
				$('#SterUserValue').combobox('textbox').focus();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	// 物理监测
	function Physic() {
		var SterMainRow = $('#MainList').datagrid('getSelected');
		if (isEmpty(SterMainRow)) {
			$UI.msg('alert', '请选择需要处理的单据!');
			return false;
		}
		if (SterMainRow.ComplateFlag !== 'N') {
			$UI.msg('alert', '已开始灭菌,无法进行物理监测!');
			return;
		}
		if (SterMainRow.IsPhy === 'Y') {
			$UI.msg('alert', '已经选择物理监测');
			return;
		}
		var SterMainId = SterMainRow['RowId'];
		var ParamsObj = {
			SterMainId: SterMainId,
			MonitorType: 'Phy'
		};
		var Params = JSON.stringify(addSessionParams(ParamsObj));
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsSetMonitor',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				CurrId = SterMainId;
				MainListGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	// 生物监测
	function Bio() {
		var row = $('#MainList').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择需要处理的单据!');
			return false;
		}
		if (row.ComplateFlag !== 'N') {
			$UI.msg('alert', '已开始灭菌,无法进行生物监测!');
			return;
		}
		if (row.IsBio === 'Y') {
			$UI.msg('alert', '已经选择生物监测!');
			return;
		}
		var SterMainId = row['RowId'];
		var ParamsObj = {
			SterMainId: SterMainId,
			MonitorType: 'Bio'
		};
		var Params = JSON.stringify(addSessionParams(ParamsObj));
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsSetMonitor',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				CurrId = SterMainId;
				MainListGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	// 化学监测
	function Che() {
		var row = $('#MainList').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择需要处理的单据!');
			return false;
		}
		if (row.ComplateFlag !== 'N') {
			$UI.msg('alert', '已开始灭菌，无法进行化学监测');
			return;
		}
		if (row.IsChe === 'Y') {
			$UI.msg('alert', '已经选择化学监测,请勿重复选择');
			return;
		}
		var SterMainId = row['RowId'];
		var ParamsObj = {
			SterMainId: SterMainId,
			MonitorType: 'Che'
		};
		var Params = JSON.stringify(addSessionParams(ParamsObj));
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsSetMonitor',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				CurrId = SterMainId;
				MainListGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	var NotUseFlagData = [
		{ 'RowId': 'Y', 'Description': $g('合格') },
		{ 'RowId': 'N', 'Description': $g('不合格') }
	];
	var NotUseFlagCombox = {
		type: 'combobox',
		options: {
			data: NotUseFlagData,
			valueField: 'RowId',
			textField: 'Description',
			editable: true
		}
	};
	function flagColor(val, row, index) {
		if (val === 'N' || val === '2') {
			return 'color:white;background:' + GetColorCode('red');
		}
	}
	var MainCm = [[
		{
			field: 'operate',
			title: '操作',
			frozen: true,
			align: 'center',
			width: 60,
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '';
				if (row.ComplateFlag === 'N') {
					str = '<div class="col-icon icon-cancel" title="' + $g('删除') + '" onclick="MainListGrid.commonDeleteRow(true,' + index + ');"></div>';
				}
				if (row.LevelFlag === '1') {
					str = str + '<div class="col-icon icon-emergency" title="' + $g('紧急') + '"></div>';
				}
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '灭菌科室',
			field: 'CreateLoc',
			width: 100
		}, {
			title: '灭菌器',
			field: 'MachineNo',
			width: 90
		}, {
			title: '灭菌器Dr',
			field: 'MachineNoDR',
			width: 60,
			hidden: true
		}, {
			title: '灭菌状态',
			field: 'ComplateFlag',
			align: 'center',
			width: 70,
			styler: function(value, row, index) {
				if (value === 'N') {
					return 'color:white;background:' + GetColorCode('red');
				} else {
					return 'color:white;background:' + GetColorCode('green');
				}
			},
			formatter: function(value, row, index) {
				if (row.ComplateFlag === 'Y') {
					return $g('灭菌中');
				} else if (row.ComplateFlag === 'N') {
					return $g('否');
				} else if (row.ComplateFlag === 'F') {
					return $g('灭菌');
				}
			}
		}, {
			title: '验收结果',
			field: 'IsCHK',
			width: 70,
			align: 'center',
			formatter: function(value, row, index) {
				if (row.IsCHK === '1') {
					return $g('合格');
				} else if (row.IsCHK === '2') {
					return $g('不合格');
				} else if (row.IsCHK === '') {
					return $g('未验收');
				}
			},
			styler: function(value, row, index) {
				if (value === '1') {
					return 'color:white;background:' + GetColorCode('green');
				} else if (value === '2') {
					return 'color:white;background:' + GetColorCode('red');
				}
			}
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
			title: '灭菌程序Dr',
			field: 'ProgressDR',
			width: 100,
			hidden: true
		}, {
			title: '灭菌人',
			field: 'SterName',
			width: 100
		}, {
			title: '灭菌日期',
			field: 'SterDate',
			width: 100
		}, {
			title: '灭菌时间',
			field: 'SterTime',
			width: 100
		}, {
			title: '温度',
			field: 'Temperature',
			align: 'center',
			width: 60,
			editor: { type: 'numberbox', options: { min: 1, max: 10000 }}
		}, {
			title: '压强',
			field: 'Pressure',
			align: 'center',
			width: 60,
			editor: { type: 'numberbox', options: { min: 1, max: 10000 }}
		}, {
			title: '灭菌耗时',
			field: 'UsedTime',
			align: 'center',
			width: 60,
			editor: { type: 'numberbox', options: { min: 1, max: 10000 }}
		}, {
			title: '指示条结果',
			field: 'NotUseFlag',
			align: 'center',
			width: 80,
			formatter: CommonFormatter(NotUseFlagCombox, 'NotUseFlag', 'NotUseFlagDesc'),
			editor: NotUseFlagCombox
		}, {
			title: '测漏标志',
			field: 'LeakLabelFlag',
			width: 100,
			align: 'center',
			styler: flagColor,
			formatter: function(value, row, index) {
				if (row.LeakLabelFlag === '1') {
					return $g('是');
				}
			},
			hidden: true
		}, {
			title: 'BD测试',
			field: 'BDLabelFlag',
			width: 100,
			align: 'center',
			styler: flagColor,
			formatter: function(value, row, index) {
				if (row.BDLabelFlag === '1') {
					return $g('是');
				}
			},
			hidden: true
		}, {
			title: 'BD验收时间',
			field: 'CHKTime',
			width: 100,
			hidden: true
		}, {
			title: '物理监测',
			field: 'IsPhy',
			width: 100,
			align: 'center',
			formatter: function(value, row, index) {
				if (row.IsPhy === 'Y') {
					return $g('是');
				}
			},
			hidden: true
		}, {
			title: '生物监测',
			field: 'IsBio',
			width: 100,
			align: 'center',
			formatter: function(value, row, index) {
				if (row.IsBio === 'Y') {
					return $g('是');
				}
			},
			hidden: true
		}, {
			title: '化学监测',
			field: 'IsChe',
			width: 100,
			align: 'center',
			formatter: function(value, row, index) {
				if (row.IsChe === 'Y') {
					return $g('是');
				}
			},
			hidden: true
		}, {
			title: '物理验收人',
			field: 'PhyName',
			width: 100,
			hidden: true
		}, {
			title: '物理验收时间',
			field: 'PhyCHKTime',
			width: 100,
			hidden: true
		}, {
			title: '物理监测结果',
			field: 'PhyResult',
			align: 'center',
			width: 100,
			styler: flagColor,
			formatter: function(value, row, index) {
				if (row.PhyResult === '1') {
					return $g('合格');
				} else if (row.PhyResult === '2') {
					return $g('不合格');
				}
			}
		}, {
			title: '生物验收人',
			field: 'BioCHKName',
			width: 100,
			hidden: true
		}, {
			title: '生物验收时间',
			field: 'BioCHKTime',
			width: 100,
			hidden: true
		}, {
			title: '生物监测结果',
			field: 'BatLabel',
			align: 'center',
			width: 100,
			styler: flagColor,
			formatter: function(value, row, index) {
				if (row.BatLabel === '1') {
					return $g('合格');
				} else if (row.BatLabel === '2') {
					return $g('不合格');
				}
			}
		}, {
			title: '化学验收人',
			field: 'CheCHKName',
			width: 100,
			hidden: true
		}, {
			title: '化学验收时间',
			field: 'CheCHKTime',
			width: 100,
			hidden: true
		}, {
			title: '化学监测结果',
			field: 'CheResult',
			align: 'center',
			width: 100,
			styler: flagColor,
			formatter: function(value, row, index) {
				if (row.CheResult === '1') {
					return $g('合格');
				} else if (row.CheResult === '2') {
					return $g('不合格');
				}
			}
		}, {
			title: '验收人',
			field: 'chkame',
			width: 100,
			hidden: true
		}, {
			title: '温度类型',
			field: 'TempType',
			width: 100,
			hidden: true
		}, {
			title: '灭菌架',
			field: 'carLabel',
			width: 100
		}, {
			title: '重新灭菌状态',
			field: 'WorkStatus',
			width: 100,
			hidden: true
		}, {
			title: '灭菌包数',
			field: 'SterPackageNum',
			width: 100,
			hidden: true
		}, {
			title: '紧急状态',
			field: 'LevelFlag',
			width: 100,
			hidden: true
		}
	]];
	MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			QueryName: 'SelectAll'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'jsDelete'
		},
		columns: MainCm,
		toolbar: [{
			id: 'PhysicTest',
			text: '物理监测',
			iconCls: 'icon-physics-monitor',
			handler: function() {
				Physic();
			}
		}, {
			id: 'BioTest',
			text: '生物监测',
			iconCls: 'icon-ster-bio',
			handler: function() {
				Bio();
			}
		}, {
			id: 'CheTest',
			text: '化学监测',
			iconCls: 'icon-ster-bat',
			handler: function() {
				Che();
			}
		}, {
			id: 'SterRepeat',
			text: '重新灭菌',
			iconCls: 'icon-ster-again',
			handler: function() {
				SterRepeatIn();
			}
		}, {
			id: 'SterRepeat',
			text: '更换灭菌器',
			iconCls: 'icon-change-x-virus',
			handler: function() {
				SterChange();
			}
		}, {
			id: 'SterOver',
			text: '灭菌完成',
			iconCls: 'icon-ster-finish',
			handler: function() {
				SterFinish();
			}
		}, {
			id: 'SaveBT',
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				Save();
			}
		}, {
			id: 'PotPrint',
			text: '打印',
			iconCls: 'icon-print',
			handler: function() {
				PotPrint();
			}
		}],
		singleSelect: true,
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
				GetMarkQty();
			}
		},
		onClickRow: function(index, row) {
			MainListGrid.commonClickRow(index, row);
		},
		onSelect: function(index, row) {
			var SterMainId = row.RowId;
			if (!isEmpty(SterMainId)) {
				quertItm();
				$('#BarCode').focus();
				GetMarkQty();
			}
			if ((row.ComplateFlag === 'Y') || (row.ComplateFlag === 'F') || (row.LeakLabelFlag === '1') || (row.BDLabelFlag === '1')) {
				$('#BarCode').attr('disabled', 'disabled');
				$('#DeleteAll').linkbutton('disable');
			}
			if ((row.ComplateFlag === 'N') && (row.LeakLabelFlag !== '1') && (row.BDLabelFlag !== '1')) {
				$('#BarCode').attr('disabled', false);
				// $('#AddItemBT').linkbutton('enable');
				$('#DeleteAll').linkbutton('enable');
			}
		},
		afterDelFn: function() {
			Query();
		}
	});

	$HUI.tabs('#SterTabs', {
		onSelect: function(title, index) {
			tabTitle = title;
			quertItm();
		}
	});

	function quertItm() {
		var row = $('#MainList').datagrid('getSelected');
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
	// 扫码动作
	$('#BarCode').keyup(function(event) {
		if (event.which === 13) {
			AddSterilizeItem();
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
			AddSterilizeItem();
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

	function AddSterilizeItem() {
		var label = $('#BarCode').val();
		var row = $('#MainList').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择需要添加的灭菌单据!');
			return;
		}
		if (isEmpty(label)) {
			$UI.msg('alert', '未获取到扫描的标签!');
			return;
		}
		if (isEmpty(row.RowId)) {
			$UI.msg('alert', '请选择主单据!');
			return;
		}
		if (row.BDLabelFlag === '1') {
			$UI.msg('alert', 'BD测试不允许添加明细!');
			return;
		}
		if (row.LeakLabelFlag === '1') {
			$UI.msg('alert', '测漏不允许添加明细!');
			return;
		}
		var SterMainId = row['RowId'];
		var BarCodeArray = [{ Label: label }];
		SaveDetail(BarCodeArray, SterMainId);
	}

	// 保存明细
	function SaveDetail(BarCodeArray, SterMainId) {
		var Params = JSON.stringify(addSessionParams({ SterMainId: SterMainId }));
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeItem',
			MethodName: 'jsSaveSterDetail',
			Params: Params,
			Detail: JSON.stringify(BarCodeArray)
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				CurrId = SterMainId;
				MainListGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
			$('#BarCode').val('');
			$('#BarCode').focus();
		});
	}

	$UI.linkbutton('#AddItemBT', {
		onClick: function() {
			AddItem();
		}
	});

	// 选取待灭菌包
	function AddItem() {
		var row = $('#MainList').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择需要灭菌的批次!');
			return;
		}
		var MachineNoDR = '';
		var carLabel = '';
		if (row.ComplateFlag !== 'Y' && row.ComplateFlag !== 'F') {
			MachineNoDR = row.MachineNoDR;
			carLabel = row.carLabel;
		}
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择需要添加的批次!');
			return;
		}
		if (isEmpty(row.RowId)) {
			$UI.msg('alert', '参数错误!');
			return;
		}
		SelBarcode(AddItms, carLabel, MachineNoDR, 'IN');
	}
	// 删除明细多条
	function DeleteAll() {
		ItemListGrid.commonDeleteRow(true);
	}
	function AddItms(BarCodeArray) {
		var Row = MainListGrid.getSelected();
		var RowId = Row['RowId'];
		if (Row.BDLabelFlag === '1') {
			$UI.msg('alert', 'BD测试不允许添加明细!');
			return;
		}
		if (Row.LeakLabelFlag === '1') {
			$UI.msg('alert', '测漏不允许添加明细!');
			return;
		}
		SaveDetail(BarCodeArray, RowId);
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

	ItemListSum = $UI.datagrid('#ItemListSum', {
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
			field: 'ck',
			checkbox: true,
			frozen: true,
			width: 50
		}, {
			field: 'operate',
			title: '操作',
			frozen: true,
			align: 'center',
			width: 80,
			formatter: function(value, row, index) {
				var rowMain = $('#MainList').datagrid('getSelected');
				var str = '';
				if (rowMain.ComplateFlag === 'N') {
					str = '<div class="col-icon icon-cancel" title="' + $g('删除') + '" onclick="ItemListGrid.commonDeleteRow(false,' + index + ');"></div>';
				}
				if (row.LevelFlag === '1') {
					str = str + '<div class="col-icon icon-emergency" title="' + $g('紧急') + '"></div>';
				}
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
			width: 170
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 160
		}, {
			title: '数量',
			field: 'Qty',
			width: 60,
			hidden: true,
			align: 'right'
		}, {
			title: '紧急状态',
			field: 'LevelFlag',
			width: 100,
			hidden: true
		}
	]];

	ItemListGrid = $UI.datagrid('#ItemList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeItem',
			QueryName: 'SelectByF'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeItem',
			MethodName: 'jsDelete'
		},
		toolbar: [{
			id: 'DeleteAll',
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() {
				DeleteAll();
			}
		}],
		columns: ItemCm,
		singleSelect: false,
		sortName: 'RowId',
		sortOrder: 'desc',
		pageSize: 100,
		afterDelFn: function() {
			GetMarkQty();
		}
	});

	// 显示数量角标
	function GetMarkQty() {
		var Row = $('#MainList').datagrid('getSelected');
		if (isEmpty(Row)) {
			return;
		}
		var MachineId = Row.MachineNoDR;
		var ParamsObj = $UI.loopBlock('#MainCondition');
		var SterQty = $.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.Sterilize',
			MethodName: 'GetMarkQty',
			Params: JSON.stringify(ParamsObj),
			MachineId: MachineId
		}, false);
		$('#AddItemNum').html(SterQty);
	}

	var Default = function() {
		var StartDate = getQueryVariable('StartDate');
		var DefaultData = {
			FStartDate: StartDate,
			FEndDate: DefaultEdDate(),
			SterLocId: gLocId
		};
		$UI.fillBlock('#MainCondition', DefaultData);
		if (SterParamObj.IsSterFinish === 'N') {
			$('#SterOver').hide();
		}
		$('#MachineAlias').focus();
	};
	Default();
	Query();
};
$(init);