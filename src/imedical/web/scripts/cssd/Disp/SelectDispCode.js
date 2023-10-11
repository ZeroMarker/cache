var gFn, gDispMainRowid, gType, gApplyType, gExcludeExt;
var SelectDispCode = function(Fn, DispMainRowid, Type, ApplyType, ExcludeExt) {
	gFn = Fn;
	gDispMainRowid = DispMainRowid;
	gType = Type;
	gApplyType = ApplyType;
	gExcludeExt = ExcludeExt;
	$HUI.dialog('#SelectDispWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
};

var initSelectDispCode = function() {
	$UI.linkbutton('#SelectDispQuery', {
		onClick: function() {
			SelectDispQuery(gDispMainRowid, gType);
		}
	});
	function SelectDispQuery(gDispMainRowid, gType) {
		var ParamsObj = $UI.loopBlock('#SelectDispConditions');
		ParamsObj.DispMainId = gDispMainRowid;
		ParamsObj.Type = gType;
		ParamsObj.PackageMatch = PackageMatch;
		// 借包单不进行精确过滤,否则查不到数据
		ParamsObj.ExactMatchFlag = gApplyType === '1' ? 'N' : ExactMatchFlag;
		ParamsObj.ExcludeExt = gExcludeExt;
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(SelectDispGrid);
		SelectDispGrid.load({
			ClassName: 'web.CSSDHUI.PackageDisp.DispDetail',
			QueryName: 'SelectAllSter',
			Params: Params,
			rows: 9999
		});
	}
	
	$HUI.combobox('#PMachineNo', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetMachineNoComBo&ResultSetType=array&type=sterilizer&Params=' + JSON.stringify(addSessionParams({ BDPHospital: gHospId })),
		valueField: 'RowId',
		textField: 'Description'
	});

	var PackageMatch = 'Y';
	$HUI.switchbox('#PackageSwitch', {
		onText: '开',
		offText: '关',
		animated: true,
		onClass: 'primary',
		offClass: 'gray',
		onSwitchChange: function(e, obj) {
			PackageMatch = obj.value ? 'Y' : 'N';
			SelectDispQuery(gDispMainRowid, gType);
		}
	});
	
	var ExactMatchFlag = 'Y';
	$HUI.switchbox('#ExactMatchSwitch', {
		onText: '开',
		offText: '关',
		animated: true,
		onClass: 'primary',
		offClass: 'gray',
		onSwitchChange: function(e, obj) {
			if (obj.value === true) {
				$HUI.switchbox('#PackageSwitch').setValue(true);
				PackageMatch = 'Y';
				ExactMatchFlag = 'Y';
			} else {
				ExactMatchFlag = 'N';
			}
			SelectDispQuery(gDispMainRowid, gType);
		}
	});
	// 添加消毒包
	$UI.linkbutton('#SelectDispCodeCreateBT', {
		onClick: function() {
			SaveItem();
		}
	});
	// 保存到明细里面
	function SaveItem() {
		var Detail = SelectDispGrid.getSelections();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '请选择要添加的数据!');
			return;
		}
		$('#SelectDispWin').window('close');
		gFn(Detail);
	}

	var SelectDispCm = [[
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
			width: 40,
			formatter: function(value, row, index) {
				var str = '';
				if (row.LevelFlag === '1') {
					str = str + '<div class="icon-emergency col-icon" href="#" title="紧急"></div>';
				}
				return str;
			}
		}, {
			title: '标签',
			field: 'Label',
			width: 180,
			sortable: true
		}, {
			title: '消毒包',
			field: 'PackageName',
			width: 150,
			sortable: true
		}, {
			title: '包装材料',
			align: 'left',
			field: 'PackMaterial',
			width: 80
		}, {
			title: '消毒包属性Dr',
			field: 'PackageTypeDetail',
			width: 100,
			align: 'left',
			sortable: true,
			hidden: true
		}, {
			title: '消毒包属性',
			field: 'PackageTypeDetailName',
			width: 100,
			align: 'left',
			sortable: true
		}, {
			title: '日期',
			field: 'CSSDTDate',
			width: 100,
			sortable: true
		}, {
			title: '失效日期',
			field: 'ExpDate',
			width: 100,
			sortable: true
		}, {
			title: '科室',
			field: 'LocDesc',
			width: 120,
			sortable: true
		}, {
			title: '紧急状态',
			field: 'LevelFlag',
			width: 60,
			hidden: true
		}
	]];

	var SelectDispGrid = $UI.datagrid('#SelectDispGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageDisp.DispDetail',
			QueryName: 'SelectAllSter',
			rows: 9999
		},
		columns: SelectDispCm,
		singleSelect: false,
		pagination: false,
		fitColumns: true
	});
	function SelReqDefa() {
		$UI.clearBlock('#SelectDispConditions');
		if (gApplyType === '1') {
			$('#Switch').hide();
		} else {
			$('#Switch').show();
		}
		var Default = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate()
		};
		$UI.fillBlock('#SelectDispConditions', Default);
	}

	$HUI.dialog('#SelectDispWin', {
		onOpen: function() {
			SelReqDefa();
			SelectDispQuery(gDispMainRowid, gType);
		}
	});
};
$(initSelectDispCode);