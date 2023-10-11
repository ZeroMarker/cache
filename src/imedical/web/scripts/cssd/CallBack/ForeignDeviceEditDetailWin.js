var gFn, gRowId, EditExtDetailGrid;
var EditDetailWin = function(RowId, Fn) {
	gFn = Fn;
	gRowId = RowId;
	$HUI.dialog('#AddDetailWin').open();
};

var initEditDetailWin = function() {
	var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, ExtFlag: 'Y' }));
	$HUI.combobox('#ExtInstruName', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			if (isEmpty(gRowId)) {
				var pkgDr = record['RowId'];
				$('#ExtInstruCode').combobox('clear');
				$('#ExtInstruCode').combobox('reload',
					$URL + '?ClassName=web.CSSDHUI.CallBack.ForeignPkgRegister&QueryName=GetExistCodeDict&ResultSetType=array&PkgDr=' + pkgDr);
				var FirmId = $('#ExtFirm').combobox('getValue');
				if (isEmpty(FirmId)) {
					$('#ExtFirm').combobox('setValue', record['FirmId']);
					getFirmData(record['FirmId']);
				}
			}
		}
	});
	
	$HUI.combobox('#ExtInstruCode', {
		url: $URL + '?ClassName=web.CSSDHUI.CallBack.ForeignPkgRegister&QueryName=GetExistCodeDict&ResultSetType=array&PkgDr=""',
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function() {
			var data = $('#ExtInstruCode').combobox('getData');
			if (!isEmpty(data)) {
				$('#AddDictBT').linkbutton('disable');
			} else {
				$('#AddDictBT').linkbutton('enable');
			}
		}
	});

	var ReqLocParams = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: gHospId }));
	$HUI.combobox('#ExtPatientLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var FirmParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, MachineType: 'WL' }));
	$HUI.combobox('#ExtFirm', {
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
			$('#ExtSerMan').val(Ret.split('^')[0]);
			$('#ExtTel').val(Ret.split('^')[1]);
			$('#ExtReceipt').focus();
		} else {
			$UI.msg('alert', '未找到厂商相关信息!');
			$('#ExtFirm').focus();
		}
	}
	$('#ExtHospitalNo').keyup(function(event) {
		if (event.which == 13) {
			var value = $('#ExtHospitalNo').val();
			var PatNo = PrefixInteger(value, 10);
			var PatObj = $.cm({
				ClassName: 'web.CSSDHUI.CallBack.ForeignPkgRegister',
				MethodName: 'GetAdmListByHospitalNo',
				Params: JSON.stringify(addSessionParams({ PatNo: PatNo }))
			}, false);
			if (!isEmpty(PatObj['PatName'])) {
				var PatName = PatObj['PatName'], Age = PatObj['Age'], SexId = PatObj['SexId'], Sex = PatObj['Sex'], BedNo = PatObj['BedNo'],
					DeptId = PatObj['DeptId'], DeptDesc = PatObj['DeptDesc'];
				$('#ExtHospitalNo').val(PatNo);
				$('#ExtSickerName').val(PatName);
				$('#ExtPatientAge').val(Age);
				AddComboData($('#ExtPatientSex'), SexId, Sex);
				$('#ExtPatientSex').combobox('setValue', SexId);
				$('#ExtBedNo').val(BedNo);
				AddComboData($('#ExtPatientLoc'), DeptId, DeptDesc);
				$('#ExtPatientLoc').combobox('setValue', DeptId);
				$('#ExtFirm').focus();
			} else {
				$UI.msg('alert', '未找到相关信息!');
				$('#ExtHospitalNo').val('').focus();
			}
		}
	});
	function PrefixInteger(num, length) {
		return (Array(length).join('0') + num).slice(-length);
	}
	
	// 接收人回车操作
	var ParamsTB = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	$HUI.combobox('#ExtRecManDr', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + ParamsTB,
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'Code'
	});

	$('#ExtRecManDr').combobox('textbox').keyup(function(event) {
		if (event.keyCode == 13) {
			var userCode = $('#ExtRecManDr').combobox('getText');
			if (userCode != '') {
				var UserObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetUserByCodeJson',
					userCode: userCode,
					Params: ParamsTB
				}, false);
				if (UserObj['RowId'] == '') {
					$UI.msg('alert', '未获取接收人相关信息！');
					$('#ExtRecManDr').combobox('setValue', '');
					$('#ExtRecManDr').combobox('textbox').focus();
					return;
				}
				$('#ExtRecManDr').combobox('setValue', UserObj['RowId']);
				$('#ExtHospitalNo').focus();
			}
		}
	});
	
	$UI.linkbutton('#ExtCancelBT', {
		onClick: function() {
			$HUI.dialog('#AddDetailWin').close();
		}
	});

	$UI.linkbutton('#ExtAddSaveBT', {
		onClick: function() {
			Save();
		}
	});
	function Save() {
		var ParamsObj = $UI.loopBlock('#SelConditions');
		if (isEmpty(ParamsObj.ExtInstruName)) {
			$UI.msg('alert', '请选择消毒包！');
			$('#ExtInstruName').focus();
			return;
		}
		if (isEmpty(ParamsObj.ExtInstruCode)) {
			$UI.msg('alert', '请选择标牌');
			$('#ExtInstruCode').focus();
			return;
		}
		if (isEmpty(ParamsObj.ExtFirm)) {
			$UI.msg('alert', '请选择厂商！');
			$('#ExtFirm').focus();
			return;
		}
		if (isEmpty(ParamsObj.ExtRecManDr)) {
			$UI.msg('alert', '请选择接收人！');
			$('#ExtRecManDr').focus();
			return;
		}
		if (isEmpty(ParamsObj.ExtRecNum)) {
			$UI.msg('alert', '请输入接收包数！');
			$('#ExtRecNum').focus();
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		var Others = JSON.stringify(sessionObj);
		$.cm({
			ClassName: 'web.CSSDHUI.CallBack.ForeignPkgDetail',
			MethodName: 'jsSave',
			Params: Params,
			Others: Others
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				$('#ExtInstruName').combobox('disable');
				$('#ExtInstruCode').combobox('disable');
				gRowId = jsonData.rowid;
				Select(jsonData.rowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	// 新增标牌
	$UI.linkbutton('#AddDictBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('SelConditions');
			var PkgId = ParamsObj.ExtInstruName;
			if (isEmpty(PkgId)) {
				$UI.msg('alert', '请选择消毒包');
				return;
			}
			var Ret = tkMakeServerCall('web.CSSDHUI.CallBack.ForeignPkgRegister', 'ExistCodeDict', PkgId, '');
			if (Ret != 0) {
				$UI.msg('alert', '存在可用标牌:' + Ret);
				return;
			}
			ParamsObj.PkgDesc = PkgId;
			ParamsObj.Qty = 1;
			$.cm({
				ClassName: 'web.CSSDHUI.PackageInfo.CodeDict',
				MethodName: 'CreateCodeDict',
				Params: JSON.stringify(ParamsObj),
				Others: JSON.stringify(addSessionParams({ BDPHospital: gHospId }))
			}, function(jsonData) {
				if (jsonData.success === 0) {
					var Barcode = jsonData.rowid;
					$('#ExtInstruCode').combobox('reload');
					$('#ExtInstruCode').combobox('setValue', Barcode);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	function getExtDetail(ExtId) {
		EditExtDetailGrid.load({
			ClassName: 'web.CSSDHUI.CallBack.ForeignPkgDetail',
			QueryName: 'SelectByF',
			ExtId: ExtId,
			rows: 999999
		});
	}

	var SelectRow = function(row) {
		var EditIndex = EditExtDetailGrid.editIndex;
		var Rows = EditExtDetailGrid.getRows();
		var itmDr = row.RowId;
		var Desc = row.ItemDescription;
		var Spec = row.ItemSpec;
		for (var i = 0; i < Rows.length; i++) {
			if ((Rows[i].itmDr == itmDr) && (i != EditIndex)) {
				$UI.msg('alert', '器械重复!');
				itmDr = '', Desc = '', Spec = '';
			}
		}
		EditExtDetailGrid.updateRow({
			index: EditIndex,
			row: {
				Spec: Spec,
				Desc: Desc,
				itmDr: itmDr
			}
		});
		EditExtDetailGrid.refreshRow();
	};
	var ExtDetailCm = [[
		{
			field: 'ck',
			checkbox: true,
			frozen: true
		}, {	field: 'operate',
			title: '操作',
			align: 'center',
			width: 80,
			formatter: function(value, row, index) {
				var str = '<div class="icon-cancel col-icon"  href="#"  title="删除" onclick="EditExtDetailGrid.commonDeleteRow(false,' + index + ');"></div>';
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '器械Dr',
			field: 'itmDr',
			width: 150,
			hidden: true
		}, {
			title: '器械',
			field: 'Desc',
			width: 250,
			editor: PackageItemEditor('', SelectRow)
		}, {
			title: '器械规格',
			field: 'Spec',
			width: 150
		}, {
			title: '数量',
			field: 'Qty',
			align: 'right',
			width: 80,
			editor: { type: 'numberbox', options: { required: true, min: 1 }}
		}, {
			title: '是否植入物',
			field: 'IsImplants',
			align: 'center',
			width: 100,
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}, {
			title: '分包数',
			field: 'PkgNum',
			align: 'right',
			width: 80,
			editor: { type: 'numberbox', options: { required: true, min: 1 }}
		}, {
			title: '缺失数量',
			field: 'ConsumeQty',
			align: 'right',
			width: 100
		}, {
			title: '缺失原因',
			field: 'ConsumeName',
			width: 120
		}
	]];

	EditExtDetailGrid = $UI.datagrid('#EditExtDetailGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.CallBack.ForeignPkgDetail',
			QueryName: 'SelectByF',
			rows: 99999
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.CallBack.ForeignPkgDetail',
			MethodName: 'jsDeleteDetail'
		},
		columns: ExtDetailCm,
		pagination: false,
		singleSelect: false,
		showAddSaveDelItems: true,
		checkField: 'itmDr',
		saveDataFn: function() {
			var Rows = EditExtDetailGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows == false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			if (isEmpty(gRowId)) {
				$UI.msg('alert', '请先保存外来器械信息，再添加明细!');
				return false;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.CallBack.ForeignPkgDetail',
				MethodName: 'jsSaveDetail',
				MainId: gRowId,
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					getExtDetail(gRowId);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		beforeAddFn: function() {
			if (isEmpty(gRowId)) {
				$UI.msg('alert', '请先保存消毒包信息!');
				return false;
			}
		},
		onClickRow: function(index, row) {
			EditExtDetailGrid.commonClickRow(index, row);
		}
	});

	$HUI.dialog('#AddDetailWin', {
		width: gWinWidth,
		height: gWinHeight,
		onOpen: function() {
			$UI.clearBlock('#SelConditions');
			$('#ExtInstruCode').combobox('clear');
			$('#ExtInstruCode').combobox('reload',
				$URL + '?ClassName=web.CSSDHUI.CallBack.ForeignPkgRegister&QueryName=GetExistCodeDict&ResultSetType=array&PkgDr=' + '');
			$('#ExtInstruName').combobox('disable');
			$('#ExtInstruCode').combobox('disable');
			if (!isEmpty(gRowId)) {
				Select(gRowId);
			} else {
				$('#ExtInstruName').combobox('enable');
				$('#ExtInstruCode').combobox('enable');
				var DefaultData = {
					ExtRecDate: DefaultEdDate(),
					ExtUseDate: DateFormatter(DateAdd(new Date(), 'd', 1)),
					ExtOperatorType: 0,
					ExtRecManDr: gUserObj,
					ExtFunctionalCheck: 1
				};
				$UI.fillBlock('#AddDetailWin', DefaultData);
				getExtDetail();
			}
		},
		onClose: function() {
			gFn();
		}
	});
	function Select(RowId) {
		$.cm({
			ClassName: 'web.CSSDHUI.CallBack.ForeignPkgRegister',
			MethodName: 'Select',
			RowId: RowId
		}, function(jsonData) {
			$UI.fillBlock('#SelConditions', jsonData);
		});
		getExtDetail(RowId);
	}
};
$(initEditDetailWin);