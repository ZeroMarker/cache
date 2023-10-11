// 此js,多界面共用,通过type参数控制进行的操作(IN-灭菌; CAR-灭菌上架)
// 灭菌---待灭菌包弹框
var gFn, gCarLabel, gMachineNoDR, gType;
function SelBarcode(Fn, CarLabel, MachineNoDR, Type) {
	gFn = Fn;
	gCarLabel = CarLabel;
	gMachineNoDR = MachineNoDR;
	gType = Type;
	$HUI.dialog('#SelReqWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
}
var initSelBarcode = function() {
	// 开关显示当前灭菌器的标签
	var ExactMatchFlag = 'Y';
	$HUI.switchbox('#ExactMatchSwitch', {
		onText: '开',
		offText: '关',
		animated: true,
		onClass: 'primary',
		offClass: 'gray',
		size: 'large',
		onSwitchChange: function(e, obj) {
			if (obj.value === true) { ExactMatchFlag = 'Y'; }
			if (obj.value === false) { ExactMatchFlag = 'N'; }
			SelReqQuery();
		}
	});
	var LineParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	$HUI.combobox('#LineCode', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetLine&ResultSetType=array&Params=' + LineParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#PMachineNo', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterMachine&ResultSetType=array&type=sterilizer&Params=' + JSON.stringify(addSessionParams({ BDPHospital: gHospId })),
		valueField: 'RowId',
		textField: 'Description'
	});

	$UI.linkbutton('#SelAddQuery', {
		onClick: function() {
			SelReqQuery();
		}
	});
	function SelReqQuery() {
		var ParamsObj = $UI.loopBlock('#SelReqConditions');
		ParamsObj.CarLabel = gCarLabel;
		ParamsObj.MachineNoDR = gMachineNoDR;
		ParamsObj.ExactMatchFlag = ExactMatchFlag;
		var Params = JSON.stringify(addSessionParams(ParamsObj));
		$UI.clear(SelReqMasterGrid);
		SelReqMasterGrid.load({
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeCar',
			QueryName: 'SelectAllWaitingSter',
			Params: Params,
			rows: 99999
		});
	}
	// 添加消毒包
	$UI.linkbutton('#SelBarCodeCreateBT', {
		onClick: function() {
			if (gType === 'IN') {
				SaveItem();
			} else if (gType === 'CAR') {
				SaveCar();
			}
		}
	});
	// 装车
	function SaveCar() {
		var Detail = SelReqMasterGrid.getSelectedData();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '请选择要添加的数据!');
			return;
		}
		if (isEmpty(gCarLabel)) {
			$UI.msg('alert', '请选择灭菌架!');
			return;
		}
		$.cm({
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeCar',
			MethodName: 'jsAddCarByLabel',
			Detail: JSON.stringify(Detail),
			CarLabel: gCarLabel
		}, function(jsonData) {
			if (jsonData.success === 0) {
				gFn();
				$UI.msg('success', jsonData.msg);
				$('#SelReqWin').window('close');
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	// 保存到明细里面
	function SaveItem() {
		var Detail = SelReqMasterGrid.getSelectedData();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '请选择要添加的数据!');
			return;
		}
		gFn(Detail);
	}

	var SelReqMasterCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			saveCol: true,
			width: 60,
			sortable: true,
			hidden: true
		}, {
			field: 'operate',
			title: '标识',
			align: 'center',
			width: 60,
			formatter: function(value, row, index) {
				var str = '';
				if (row.LevelFlag == '1') {
					str = '<div class="col-icon icon-emergency" title="紧急" ></div>';
				}
				return str;
			}
		}, {
			title: '标签',
			field: 'Label',
			width: 160,
			align: 'left',
			saveCol: true,
			sortable: true
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 180,
			align: 'left',
			sortable: true,
			styler: function(value, row, index) {
				return 'background-color:' + row.SterTypeColor + ';' + 'color:' + GetFontColor(row.SterTypeColor);
			}
		}, {
			title: '消毒包属性Dr',
			field: 'AttributeId',
			width: 100,
			align: 'right',
			sortable: true,
			hidden: true
		}, {
			title: '包装材料',
			field: 'MaterialDesc',
			width: 100,
			align: 'left'
		}, {
			title: '消毒包属性',
			field: 'AttributeDesc',
			width: 100,
			align: 'left',
			sortable: true
		}, {
			title: '审核人',
			field: 'PackChkUserName',
			width: 80,
			align: 'left',
			sortable: true
		}, {
			title: '包装人',
			field: 'PackUserName',
			width: 80,
			align: 'left',
			sortable: true
		}, {
			title: '配包人',
			field: 'PackerName',
			width: 80,
			align: 'left',
			sortable: true,
			hidden: true
		}, {
			title: '是否生物监测',
			field: 'BioFlag',
			width: 120,
			align: 'center',
			sortable: true,
			saveCol: true,
			hidden: true
		}, {
			title: '紧急状态',
			field: 'LevelFlag',
			align: 'center',
			width: 100,
			hidden: true
		}, {
			title: '灭菌器',
			field: 'MachineDesc',
			width: 100,
			align: 'left'
		}, {
			title: '批次',
			field: 'HeatNo',
			width: 80,
			align: 'left'
		}, {
			title: '申请单号',
			field: 'ApplyNo',
			width: 120,
			align: 'left'
		}, {
			title: '回收单号',
			field: 'CallBackNo',
			width: 120,
			align: 'left'
		}, {
			title: '灭菌方式',
			field: 'SterTypeDesc',
			width: 100,
			sortable: true,
			hidden: true
		}, {
			title: '灭菌方式颜色',
			field: 'SterTypeColor',
			width: 100,
			sortable: true,
			hidden: true
		}
	]];
	
	var SelReqMasterGrid = $UI.datagrid('#SelReqMasterGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeCar',
			QueryName: 'SelectAllWaitingSter'
		},
		columns: SelReqMasterCm,
		singleSelect: false,
		pagination: false
	});
	$HUI.dialog('#SelReqWin', {
		onOpen: function() {
			$UI.clearBlock('#SelReqConditions');
			var DefaultData = {
				StartDate: DefaultStDate(),
				EndDate: DefaultEdDate()
			};
			$UI.fillBlock('#SelReqConditions', DefaultData);
			SelReqQuery();
		}
	});
};
$(initSelBarcode);