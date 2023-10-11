var gFn, BExtDetailGrid;
var BatchAddWin = function(Fn) {
	gFn = Fn;
	$HUI.dialog('#BatchAddWin').open();
};

var initBatchAddWin = function() {
	// 消毒包下拉数据
	var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, ExtFlag: 'Y' }));
	$HUI.combobox('#BPkgDesc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	var ExtLocParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	$HUI.combobox('#BExtLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ExtLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	var UserParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	$HUI.combobox('#BRecManDr', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + UserParams,
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'Code'
	});

	$('#BRecManDr').combobox('textbox').keyup(function(event) {
		if (event.keyCode == 13) {
			var userCode = $('#BRecManDr').combobox('getText');
			if (userCode != '') {
				var UserObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetUserByCodeJson',
					userCode: userCode,
					Params: ParamsTB
				}, false);
				if (UserObj['RowId'] == '') {
					$UI.msg('alert', '未获取接收人相关信息！');
					$('#BRecManDr').combobox('setValue', '');
					$('#BRecManDr').combobox('textbox').focus();
					return;
				}
				$('#BRecManDr').combobox('setValue', UserObj['RowId']);
				$('#BRecDate').focus();
			}
		}
	});

	var FirmParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, MachineType: 'WL' }));
	$HUI.combobox('#BExtFirm', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetFirm&ResultSetType=array&Params=' + FirmParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var RowId = record['RowId'];
			getFirmData(RowId);
		}
	});
	function getFirmData(RowId) {
		var Ret = tkMakeServerCall('web.CSSDHUI.Common.Dicts', 'GetFirmInfo', RowId);
		if (!isEmpty(Ret)) {
			$('#BExtSerMan').val(Ret.split('^')[0]);
			$('#BExtTel').val(Ret.split('^')[1]);
			$('#BExtReceipt').focus();
		} else {
			$UI.msg('alert', '未找到厂商相关信息!');
			$('#BExtFirm').focus();
		}
	}

	$('#BHospitalNo').keyup(function(event) {
		if (event.which == 13) {
			var v = $('#BHospitalNo').val();
			var PatNo = leftPad(v.toString(), '0', 10);
			var PatObj = $.cm({
				ClassName: 'web.CSSDHUI.CallBack.ForeignPkgRegister',
				MethodName: 'GetAdmListByHospitalNo',
				Params: JSON.stringify(addSessionParams({ PatNo: PatNo }))
			}, false);
			if (!isEmpty(PatObj['PatName'])) {
				var PatName = PatObj['PatName'], Age = PatObj['Age'], SexId = PatObj['SexId'], Sex = PatObj['Sex'], BedNo = PatObj['BedNo'],
					DeptId = PatObj['DeptId'], DeptDesc = PatObj['DeptDesc'];
				$('#BHospitalNo').val(PatNo);
				$('#BSickerName').val(PatName);
				$('#BExtPatientAge').val(Age);
				AddComboData($('#BExtPatientSex'), SexId, Sex);
				$('#BExtPatientSex').combobox('setValue', SexId);
				$('#BBedNo').val(BedNo);
				AddComboData($('#BExtLoc'), DeptId, DeptDesc);
				$('#BExtLoc').combobox('setValue', DeptId);
				$('#BUseDoctor').focus();
			} else {
				$UI.msg('alert', '未找到相关信息!');
				$('#BHospitalNo').val('');
				$('#BHospitalNo').focus();
			}
		}
	});
	
	// 扫码动作
	$('#BarCode').keyup(function(event) {
		$('#BPkgDesc').combobox('setValue', '');
		if (event.which == 13) {
			AddBarcode();
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
			AddBarcode();
		}
	}).focus(function(enent) {
		InitScanIcon();
	}).blur(function(event) {
		InitScanIcon();
	});
	// 控制标签是否允许编辑
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
	
	$('#BRecDate').keyup(function(event) {
		if (event.which == 13) {
			$('#BHospitalNo').focus();
		}
	});
	
	$('#BUseDoctor').keyup(function(event) {
		if (event.which == 13) {
			$('#BUseDate').focus();
		}
	});
	
	$('#BUseDate').keyup(function(event) {
		if (event.which == 13) {
			$('#BRemark').focus();
		}
	});
	
	$('#BRemark').keyup(function(event) {
		if (event.which == 13) {
			AddBarcode();
		}
	});
	
	function AddBarcode(Barcode) {
		BExtDetailGrid.endEditing();
		$('#BExtDetailGrid').datagrid('unselectAll');
		if (isEmpty(Barcode)) {
			Barcode = $('#BarCode').val();
		}
		if (isEmpty(Barcode)) {
			$UI.msg('alert', '请录入标牌信息!');
			return;
		}
		var MainObj = $UI.loopBlock('BatchConditions');
		var RecManDr = MainObj.RecManDr;
		var RecDate = MainObj.RecDate;
		var ExtFirm = MainObj.ExtFirm;
		var ExtFirmName = $('#BExtFirm').combobox('getText');
		var ExtSerMan = MainObj.ExtSerMan;
		var ExtTel = MainObj.ExtTel;
		if (isEmpty(RecManDr)) {
			$UI.msg('alert', '请录入接收人信息!');
			return;
		}
		if ((!isEmpty(MainObj.HospitalNo)) && (isEmpty(MainObj.SickerName))) {
			$UI.msg('alert', '请录入患者信息!');
			return;
		}
		var RowData = BExtDetailGrid.getRows();
		var Len = RowData.length;
		for (var i = 0; i < Len; i++) {
			var Row = RowData[i];
			var ExtInstruCode = Row['ExtInstruCode'];
			if (ExtInstruCode == Barcode) {
				$UI.msg('alert', '已扫描!');
				return;
			}
		}
		var ExtInfo = $.cm({
			ClassName: 'web.CSSDHUI.CallBack.ForeignPkgRegister',
			MethodName: 'GetExtInfo',
			Params: JSON.stringify(addSessionParams({ Label: Barcode, RecDate: RecDate }))
		}, false);
		if (!isEmpty(ExtInfo['Err'])) {
			$('#BarCode').val('');
			$('#BarCode').focus();
			$UI.msg('alert', ExtInfo['Err']);
			return;
		}
		var rowObj = {};
		rowObj.ExtInstruName = ExtInfo['PackageId'];
		rowObj.CodeDictId = ExtInfo['CodeDictId'];
		rowObj.CodeDictName = ExtInfo['CodeDictName'];
		rowObj.ExtInstruCode = ExtInfo['CodeDict'];
		if (isEmpty(ExtFirm)) {
			rowObj.ExtFirm = ExtInfo['Firm'];
			rowObj.FirmDesc = ExtInfo['FirmDesc'];
			rowObj.ExtTel = ExtInfo['Tel'];
			rowObj.ExtSerMan = ExtInfo['SerMan'];
		} else {
			rowObj.ExtFirm = ExtFirm;
			rowObj.FirmDesc = ExtFirmName;
			rowObj.ExtTel = ExtTel;
			rowObj.ExtSerMan = ExtSerMan;
		}
		rowObj.ExtReceipt = MainObj.ExtReceipt;
		rowObj.ExtRecManDr = MainObj.RecManDr;
		rowObj.RecMan = $('#BRecManDr').combobox('getText');
		rowObj.ExtRecDate = MainObj.RecDate;
		rowObj.ExtHospitalNo = MainObj.HospitalNo;
		rowObj.ExtSickerName = MainObj.SickerName;
		rowObj.ExtPatientSex = MainObj.PatientSex;
		rowObj.ExtPatientAge = MainObj.PatientAge;
		rowObj.ExtPatientLoc = MainObj.ExtLoc;
		rowObj.ExtLocDesc = $('#BExtLoc').combobox('getText');
		rowObj.ExtBedNo = MainObj.BedNo;
		rowObj.ExtUseDoctor = MainObj.UseDoctor;
		rowObj.ExtUseDate = MainObj.UseDate;
		rowObj.ExtOperatorType = MainObj.OperatorType;
		rowObj.ExtFunctionalCheck = MainObj.FunctionalCheck;
		rowObj.ExtPowerInstru = MainObj.ExtPowerInstru;
		rowObj.ExtRecNum = MainObj.ExtRecNum;
		rowObj.ExtRemark = MainObj.Remark;
		BExtDetailGrid.commonAddRow(rowObj);
		$('#BarCode').val('');
		$('#BarCode').focus();
	}
	
	// 清空
	$UI.linkbutton('#BAddClearBT', {
		onClick: function() {
			DefaultData();
		}
	});
	
	$UI.linkbutton('#BAddCancelBT', {
		onClick: function() {
			var DetailRows = BExtDetailGrid.getRows();
			if (!isEmpty(DetailRows)) {
				$UI.confirm('存在未保存的登记信息，是否继续取消？', '', '', Cancel, '', '', '', '', '');
			} else {
				Cancel();
			}
		}
	});
	function Cancel() {
		$HUI.dialog('#BatchAddWin').close();
	}
	
	$UI.linkbutton('#BAddSaveBT', {
		onClick: function() {
			BExtDetailGrid.endEditing();
			var DetailRows = BExtDetailGrid.getRows();
			if (isEmpty(DetailRows)) {
				$UI.msg('alert', '没有需要保存的标牌信息！');
				return;
			}
			var Main = JSON.stringify(addSessionParams({}));
			var Details = JSON.stringify(DetailRows);
			$.cm({
				ClassName: 'web.CSSDHUI.CallBack.ForeignPkgRegister',
				MethodName: 'jsBatchSave',
				Main: Main,
				Details: Details
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$HUI.dialog('#BatchAddWin').close();
					gFn();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	// 新增标牌
	$UI.linkbutton('#BAddDictBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('BatchConditions');
			var PkgId = ParamsObj.PkgDesc;
			if (isEmpty(PkgId)) {
				$UI.msg('alert', '请选择消毒包');
				return;
			}
			BExtDetailGrid.endEditing();
			var DetailRows = BExtDetailGrid.getRows();
			var Details = '';
			for (var i = 0; i < DetailRows.length; i++) {
				var CodeDict = DetailRows[i].ExtInstruCode;
				if (Details == '') {
					Details = CodeDict;
				} else {
					Details = Details + ',' + CodeDict;
				}
			}
			var Ret = tkMakeServerCall('web.CSSDHUI.CallBack.ForeignPkgRegister', 'ExistCodeDict', PkgId, Details);
			if (Ret != 0) {
				$UI.msg('alert', '存在可用标牌:' + Ret);
				return;
			}
			ParamsObj.Qty = 1;
			$.cm({
				ClassName: 'web.CSSDHUI.PackageInfo.CodeDict',
				MethodName: 'CreateCodeDict',
				Params: JSON.stringify(ParamsObj),
				Others: JSON.stringify(addSessionParams({ BDPHospital: gHospId }))
			}, function(jsonData) {
				if (jsonData.success === 0) {
					var Barcode = jsonData.rowid;
					AddBarcode(Barcode);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	var ExtDetailCm = [[
		{
			title: '操作',
			field: 'MachineN',
			width: 80,
			frozen: true,
			align: 'center',
			formatter: function(val, row, index) {
				var str = '<div class="icon-cancel col-icon"  href="#"  title="删除" onclick="BExtDetailGrid.commonDeleteRow(true,' + index + ');"></div>';
				return str;
			}
		}, {
			title: 'CodeDictId',
			field: 'CodeDictId',
			width: 100,
			hidden: true
		}, {
			title: '消毒包id',
			field: 'ExtInstruName',
			width: 80,
			hidden: true
		}, {
			title: '标牌名称',
			field: 'CodeDictName',
			width: 200,
			showTip: true,
			tipWidth: 400
		}, {
			title: '标牌',
			field: 'ExtInstruCode',
			width: 150
		}, {
			title: '接收包数',
			field: 'ExtRecNum',
			align: 'right',
			width: 80,
			editor: { type: 'numberbox' }
		}, {
			title: '器械数量',
			field: 'ExtInstruNum',
			align: 'right',
			width: 80,
			editor: { type: 'numberbox' }
		}, {
			title: '植入物件数',
			field: 'ExtImplantsNum',
			align: 'right',
			width: 80,
			editor: { type: 'numberbox' }
		}, {
			title: '接收人DR',
			field: 'ExtRecManDr',
			width: 150,
			hidden: true
		}, {
			title: '接收人',
			field: 'RecMan',
			width: 100
		}, {
			title: '接收日期',
			field: 'ExtRecDate',
			width: 100
		}, {
			title: '厂商',
			field: 'ExtFirm',
			width: 150,
			hidden: true
		}, {
			title: '厂商',
			field: 'FirmDesc',
			width: 150
		}, {
			title: '电话',
			field: 'ExtTel',
			width: 120
		}, {
			title: '送包人',
			field: 'ExtSerMan',
			width: 100
		}, {
			title: '单据',
			field: 'ExtReceipt',
			width: 100
		}, {
			title: '患者登记号',
			field: 'ExtHospitalNo',
			width: 100
		}, {
			title: '患者姓名',
			field: 'ExtSickerName',
			width: 100
		}, {
			title: '患者性别',
			field: 'ExtPatientSex',
			width: 70,
			formatter: SexRenderer
		}, {
			title: '患者年龄',
			field: 'ExtPatientAge',
			width: 70
		}, {
			title: '患者科室',
			field: 'ExtPatientLoc',
			width: 150,
			hidden: true
		}, {
			title: '患者科室',
			field: 'ExtLocDesc',
			width: 150
		}, {
			title: '床号',
			field: 'ExtBedNo',
			width: 80
		}, {
			title: '手术医生',
			field: 'ExtUseDoctor',
			width: 100
		}, {
			title: '使用时间',
			field: 'ExtUseDate',
			width: 100
		}, {
			title: '手术类型',
			field: 'ExtOperatorType',
			align: 'center',
			width: 80,
			formatter: function(value, row, index) {
				var str = '';
				if (value == 0) {
					str = '择期手术';
				} else if (value == 1) {
					str = '急诊手术';
				}
				return str;
			}
		}, {
			title: '器械功能检查',
			field: 'ExtFunctionalCheck',
			align: 'center',
			width: 100,
			formatter: function(value, row, index) {
				var str = '';
				if (value == 1) {
					str = '完好';
				} else if (value == 2) {
					str = '异常';
				}
				return str;
			}
		}, {
			title: '动力器械',
			field: 'ExtPowerInstru',
			width: 100
		}, {
			title: '备注',
			field: 'ExtRemark',
			width: 150
		}
	]];
	BExtDetailGrid = $UI.datagrid('#BExtDetailGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.CallBack.ForeignPkgRegister',
			QueryName: 'GetExtDetail'
		},
		columns: ExtDetailCm,
		pagination: false,
		singleSelect: true,
		onClickRow: function(index, row) {
			BExtDetailGrid.commonClickRow(index, row);
		}
	});

	function DefaultData() {
		$UI.clearBlock('#BatchConditions');
		var DefaultValue = {
			RecManDr: gUserObj,
			RecDate: DateFormatter(new Date()),
			UseDate: DateFormatter(new Date()),
			OperatorType: 0,
			FunctionalCheck: 1
		};
		$UI.fillBlock('#BatchConditions', DefaultValue);
		$('#BarCode').focus();
	}
	$HUI.dialog('#BatchAddWin', {
		width: gWinWidth,
		height: gWinHeight,
		onOpen: function() {
			$UI.clear(BExtDetailGrid);
			DefaultData();
		}
	});
};
$(initBatchAddWin);