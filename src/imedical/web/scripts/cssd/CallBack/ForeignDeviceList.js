// 外来器械登记界面js
var init = function() {
	// 消毒包下拉数据
	var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, ExtFlag: 'Y' }));
	$HUI.combobox('#package', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('ForeignDeviceTB');
		if (isEmpty(ParamsObj.RecDateValue) || isEmpty(ParamsObj.RecEndDateValue)) {
			$UI.msg('alert', '接收日期不能为空!');
			return;
		}
		MainGrid.load({
			ClassName: 'web.CSSDHUI.CallBack.ForeignPkgRegister',
			QueryName: 'GetDeviceRegister',
			Params: JSON.stringify(ParamsObj)
		});
	}
	// 外来器械新增
	function Add() {
		if (CallBackParamObj.ExtAddType == '2') {
			EditDetailWin('', Query);
		} else {
			BatchAddWin(Query);
		}
	}

	var Default = function() {
		$UI.clearBlock('ForeignDeviceTB');
		$UI.clearBlock('ConditionTransfer');
		$UI.clear(MainGrid);
		var DefaultData = {
			RecDateValue: DefaultBeforeDate(),
			RecEndDateValue: DefaultEdDate()
		};
		$UI.fillBlock('#ForeignDeviceTB', DefaultData);
	};

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Default();
		}
	});

	$UI.linkbutton('#UpdateTransferBT', {
		onClick: function() {
			CheckUpdateTransfer();
		}
	});
	
	// 移交,默认医院移交人为当前登录人
	function CheckUpdateTransfer() {
		var Params = $UI.loopBlock('ConditionTransfer');
		if (isEmpty(Params.TransferRec)) {
			$UI.msg('alert', '请输入外来器械厂商接收人！');
			$('#TransferRec').focus();
			return;
		}
		var CBLabelStr = '';
		var Isflag = false;
		var CheckState = true;
		var rows = MainGrid.getChecked();
		if (rows.length <= 0) {
			$UI.msg('alert', '请选择需要移交的外来器械！');
			return;
		}
		for (var i = 0; i < rows.length; i++) {
			if (rows[i].IsTransfer == 'Y') {
				Isflag = true;
			}
			if ((rows[i].NowStatus != 'SW') && (rows[i].NowStatus != 'SS') && (rows[i].NowStatus != 'C')) {
				CheckState = false;
			}
			if (rows[i].NowStatus == 'C') {
				CBLabelStr = CBLabelStr + ',' + rows[i].Label;
			}
		}
		if (Isflag == true) {
			$UI.msg('alert', '所选的器械包中存在已移交的器械，请核对后移交！');
			return;
		}
		if (CheckState == false) {
			$UI.msg('alert', '所选的器械包中存在未二次清洗、高水平消毒或回收！');
			return;
		}
		if (!isEmpty(CBLabelStr)) {
			var CheckFlag = tkMakeServerCall('web.CSSDHUI.CallBack.ForeignPkgRegister', 'CheckUse', CBLabelStr);
			if (CheckFlag == 'Y') {
				$UI.msg('alert', '存在已使用过器械包，必须进行二次清洗或高水平消毒后才能移交！');
				return;
			} else {
				$UI.confirm('没有二次清洗或高水平消毒，是否移交?', '', '', UpdateTransfer, '', '', '', '', '');
			}
		} else {
			UpdateTransfer();
		}
	}
	function UpdateTransfer() {
		var Params = $UI.loopBlock('ConditionTransfer');
		var rows = MainGrid.getChecked();
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.CallBack.ForeignPkgRegister',
			MethodName: 'jsUpdateTransfer',
			Detail: JSON.stringify(rows),
			Main: JSON.stringify(Params)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				MainGrid.reload();
				$('#TransferRec').val('');
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	function flagColor(val, row, index) {
		if (val === '0') {
			return 'color:white;background:' + GetColorCode('green');
		} else {
			return 'color:white;background:' + GetColorCode('red');
		}
	}
	
	// 器械患者信息打印
	function Print() {
		var row = $('#ExtralList').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择需要打印的信息！');
		}
		var InstruName = row.InstruName;
		var InstruCode = row.InstruCode;
		var ExtLocDesc = row.ExtLocDesc;
		var RecNum = row.RecNum;
		var SickerName = row.SickerName;
		var BedNo = row.BedNo;
		var HospitalNo = row.HospitalNo;
		var UseDate = row.UseDate;
		printInfo(InstruName, InstruCode, ExtLocDesc, RecNum, SickerName, BedNo, HospitalNo, UseDate);
	}

	$UI.linkbutton('#ViewPicBT', {
		onClick: function() {
			var Row = MainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择登记记录！');
				return;
			}
			var RowId = Row.RowId;
			ViewPic('Ext', RowId);
		}
	});

	// 拍照
	$UI.linkbutton('#TakePhotoBT', {
		onClick: function() {
			var Row = MainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择登记记录！');
				return;
			}
			var RowId = Row.RowId;
			TakePhotoWin('Ext', RowId);
		}
	});

	var MainCm = [[
		{
			title: '',
			field: 'ck',
			checkbox: true,
			width: 50
		}, {
			title: 'id',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '消毒包',
			field: 'InstruName',
			width: 150,
			sortable: true,
			showTip: true,
			tipWidth: 200
		}, {
			title: '标牌',
			field: 'InstruCode',
			width: 100,
			sortable: true
		}, {
			title: '当前状态',
			field: 'NowStatus',
			width: 80,
			sortable: true,
			formatter: PkgStatusRenderer
		}, {
			title: '使用科室',
			field: 'ExtLocDesc',
			width: 100,
			sortable: true
		}, {
			title: '接收数量',
			field: 'RecNum',
			align: 'right',
			width: 80,
			sortable: true
		}, {
			title: '接收日期',
			field: 'RecDate',
			align: 'left',
			width: 100,
			sortable: true
		}, {
			title: '接收人',
			field: 'RecManName',
			width: 70,
			sortable: true
		}, {
			title: '器械数量',
			field: 'InstruNum',
			align: 'right',
			width: 70,
			sortable: true
		}, {
			title: '植入物件数',
			field: 'Implants',
			width: 80,
			align: 'right',
			sortable: true
		}, {
			title: '收费单号',
			field: 'Receipt',
			width: 100,
			sortable: true
		}, {
			title: '是否移交',
			field: 'IsTransfer',
			align: 'center',
			width: 80,
			sortable: true,
			formatter: UseFlagRenderer
		}, {
			title: '患者姓名',
			field: 'SickerName',
			width: 80,
			sortable: true
		}, {
			title: '床号',
			field: 'BedNo',
			width: 50,
			sortable: true
		}, {
			title: '登记号',
			field: 'HospitalNo',
			width: 100,
			sortable: true
		}, {
			title: '患者性别',
			field: 'PatientSex',
			width: 70,
			sortable: true,
			formatter: SexRenderer
		}, {
			title: '患者年龄',
			field: 'PatientAge',
			width: 70,
			sortable: true
		}, {
			title: '手术类型',
			field: 'OperatorType',
			width: 80,
			align: 'center',
			sortable: true,
			formatter: OperatorTypRenderer,
			styler: flagColor
		}, {
			title: '手术医生',
			field: 'UseDoctor',
			width: 100,
			sortable: true
		}, {
			title: '使用时间',
			field: 'UseDate',
			width: 150,
			sortable: true
		}, {
			title: '厂商',
			field: 'FirmName',
			width: 130,
			sortable: true
		}, {
			title: '电话',
			field: 'Tel',
			width: 100,
			sortable: true
		}, {
			title: '送包人',
			field: 'SerMan',
			width: 100,
			sortable: true
		}, {
			title: '动力器械',
			field: 'PowerInstru',
			width: 80,
			sortable: true
		}, {
			title: '医院Dr',
			field: 'HospitalDr',
			width: 100,
			sortable: true,
			hidden: true
		}, {
			title: '医院',
			field: 'HospitalName',
			width: 100,
			sortable: true,
			hidden: true
		}, {
			title: '器械功能检查',
			field: 'FunctionalCheck',
			align: 'center',
			width: 100,
			sortable: true,
			formatter: function(value) {
				var Desc = value;
				if (value === '1') {
					Desc = $g('完好');
				} else if (value === '2') {
					Desc = $g('异常');
				}
				return Desc;
			}
		}, {
			title: '灭菌参数',
			field: 'SterParameter',
			width: 100,
			sortable: true,
			hidden: true
		}, {
			title: '高温选项',
			field: 'SterTemp',
			width: 100,
			sortable: true,
			hidden: true
		}, {
			title: '是否反洗',
			field: 'BackWash',
			align: 'center',
			width: 100,
			sortable: true,
			hidden: true
		}, {
			title: '标签',
			field: 'Label',
			width: 150,
			sortable: true
		}, {
			title: '移交人',
			field: 'Transfer',
			width: 80,
			sortable: true
		}, {
			title: '移交接收人',
			field: 'TransferRec',
			width: 90,
			sortable: true
		}, {
			title: '移交日期',
			field: 'TransferDate',
			width: 150,
			sortable: true
		}, {
			title: '备注',
			field: 'Remark',
			width: 100,
			sortable: true
		}
	]];

	var MainGrid = $UI.datagrid('#ExtralList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.CallBack.ForeignPkgRegister',
			QueryName: 'GetDeviceRegister'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.CallBack.ForeignPkgRegister',
			MethodName: 'jsDelete'
		},
		navigatingWithKey: true,
		columns: MainCm,
		singleSelect: false,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#ExtralList').datagrid('selectRow', 0);
			}
		},
		toolbar: [{
			text: '新增',
			iconCls: 'icon-add',
			handler: function() {
				Add();
			}
		}, {
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() {
				MainGrid.commonDeleteRow(true);
			}
		}, {
			text: '打印',
			iconCls: 'icon-print',
			handler: function() {
				Print();
			}
		}],
		sortName: 'RowId',
		sortOrder: 'desc',
		onClickRow: function(index, row) {
			MainGrid.commonClickRow(index, row);
		},
		onDblClickRow: function(index, row) {
			var RowId = row.RowId;
			var NowStatus = row.NowStatus;
			if (NowStatus != 'B') {
				$UI.msg('alert', '非登记状态，不能修改');
				return;
			}
			EditDetailWin(RowId, Query);
		}
	});
	Default();
	Query();
};
$(init);