function getfldetail(Id) {
	FindFlApplytDetail(Id);
}

// 记录勾选的敷料包, 生成标签后保持勾选
var SelFlPackArray = [];

var init = function() {
	var ParamObj = GetAppPropValue('CSSDPACK');
	var ParamsTB = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	var IsPackUser = ParamObj.IsPackUser;
	if (IsPackUser !== 'Y') {
		$('#Packer').combobox({ disabled: true });
	}

	// 申请科室
	var ReqLocParams = JSON.stringify(addSessionParams({ Type: 'RecLoc', BDPHospital: gHospId }));
	$HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	// 发放科室
	var SupLocParams = JSON.stringify(addSessionParams({ Type: 'Login', BDPHospital: gHospId }));
	$HUI.combobox('#ToLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId, SupLocId: record.RowId }));
			var Url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterMachine&ResultSetType=array&type="sterilizer"&Params=' + Params;
			var LUrl = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetLine&ResultSetType=array&Params=' + Params;
			$('#SterMachine').combobox('reload', Url).combobox('clear');
			$('#LineCode').combobox('reload', LUrl).combobox('clear');
		}
	});

	// 线路
	$HUI.combobox('#LineCode', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetLine&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});

	// 审核人员下拉框
	$HUI.combobox('#PackChkUser', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		defaultFilter: 6,
		spellField: 'Code',
		onBeforeLoad: function(param) {
			param.Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
		}
	});

	// 审核人回车
	$('#PackChkUser').combobox('textbox').keyup(function(event) {
		if (event.which === 13) {
			var userCode = $('#PackChkUser').combobox('getText');
			if (!isEmpty(userCode)) {
				var UserObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetUserByCodeJson',
					userCode: userCode,
					Params: ParamsTB
				}, false);
				if (!isEmpty(UserObj['RowId'])) {
					$('#PackChkUser').combobox('clear');
					$('#PackChkUser').combobox('setValue', UserObj['RowId']);
					$('#PackUser').combobox('textbox').focus();
				} else {
					var PackChkUserId = $('#PackChkUser').combobox('getValue');
					if (!isEmpty(PackChkUserId)) {
						$UI.msg('alert', '错误的审核人!');
						$('#PackChkUser').val('');
						$('#PackChkUser').combobox('setValue', '');
						$('#PackChkUser').combobox('textbox').focus();
						return;
					} else {
						$('#PackUser').combobox('textbox').focus();
					}
				}
			}
		}
	});

	// 包装人员下拉框
	$HUI.combobox('#PackUser', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		defaultFilter: 6,
		spellField: 'Code',
		onBeforeLoad: function(param) {
			param.Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
		}
	});

	// 包装人回车
	$('#PackUser').combobox('textbox').keyup(function(event) {
		if (event.which === 13) {
			var userCode = $('#PackUser').combobox('getText');
			if (!isEmpty(userCode)) {
				var UserObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetUserByCodeJson',
					userCode: userCode,
					Params: ParamsTB
				}, false);
				if (!isEmpty(UserObj['RowId'])) {
					$('#PackUser').combobox('clear');
					$('#PackUser').combobox('setValue', UserObj['RowId']);
					if (IsPackUser === 'Y') {
						$('#Packer').combobox('textbox').focus();
					} else {
						$('#SterMachine').combobox('textbox').focus();
					}
				} else {
					$UI.msg('alert', '错误的审核人!');
					$('#PackUser').combobox('setValue', '');
					$('#PackUser').combobox('textbox').focus();
					return;
				}
			}
		}
	});

	// 配包人员下拉框
	$HUI.combobox('#Packer', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		defaultFilter: 6,
		spellField: 'Code',
		onBeforeLoad: function(param) {
			param.Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
		}
	});

	// 配包人回车
	$('#Packer').combobox('textbox').keyup(function(event) {
		if (event.which === 13) {
			var userCode = $('#Packer').combobox('getText');
			if (!isEmpty(userCode)) {
				var UserObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetUserByCodeJson',
					userCode: userCode,
					Params: ParamsTB
				}, false);
				if (!isEmpty(UserObj['RowId'])) {
					$('#Packer').combobox('clear');
					$('#Packer').combobox('setValue', UserObj['RowId']);
					$('#SterMachine').combobox('textbox').focus();
				} else {
					$UI.msg('alert', '错误的审核人!');
					$('#Packer').combobox('setValue', '');
					$('#Packer').combobox('textbox').focus();
					return;
				}
			}
		}
	});

	// 灭菌人下拉框
	$HUI.combobox('#SterUser', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		defaultFilter: 6,
		spellField: 'Code',
		onBeforeLoad: function(param) {
			param.Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
		}
	});

	// 灭菌人回车
	$('#SterUser').combobox('textbox').keyup(function(event) {
		if (event.which === 13) {
			var userCode = $('#SterUser').combobox('getText');
			if (!isEmpty(userCode)) {
				var UserObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetUserByCodeJson',
					userCode: userCode,
					Params: ParamsTB
				}, false);
				if (!isEmpty(UserObj['RowId'])) {
					$('#SterUser').combobox('clear');
					$('#SterUser').combobox('setValue', UserObj['RowId']);
				} else {
					var UserId = $('#SterUser').combobox('getValue');
					if (!isEmpty(UserId)) {
						$UI.msg('alert', '错误的审核人!');
						$('#SterUser').val('');
						$('#SterUser').combobox('setValue', '');
						$('#SterUser').combobox('textbox').focus();
						return;
					}
				}
			}
		}
	});

	// 灭菌器
	$HUI.combobox('#SterMachine', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterMachine&ResultSetType=array&type=sterilizer&Params=' + JSON.stringify(addSessionParams({ BDPHospital: gHospId })),
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'MachineNo'
	});
	$('#SterMachine').combobox('textbox').keyup(function(event) {
		if (event.which === 13) {
			var Value = $('#SterMachine').combobox('getValue');
			if (isEmpty(Value)) {
				var MachineVal = $('#SterMachine').combobox('getText');
				var SupLocId = $('#ToLoc').combobox('getValue');
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
					$('#SterMachine').combobox('setValue', '');
					return;
				}
				$('#SterMachine').combobox('setValue', MachineId).combobox('hidePanel');
				$('#HeatNo').focus();
			}
		}
	});

	$HUI.combobox('#Material', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetMaterials&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			$UI.clear(GridList);
			$UI.clear(GridDetailList);
			$UI.clear(ItemSListGrid);
			query();
		}
	});
	function query() {
		var Params = JSON.stringify($UI.loopBlock('#SelReqConditions'));
		GridList.load({
			ClassName: 'web.CSSDHUI.Pack.FabricApplyPackLabel',
			QueryName: 'SelectFlApply',
			Params: Params
		});
	}
	var Default = {
		ToLoc: gLocObj,
		StartDate: DefaultStDate(),
		EndDate: DefaultEdDate()
	};
	$UI.fillBlock('#SelReqConditions', Default);
	$UI.fillBlock('#Usertb', { SterDate: DateFormatter(new Date()) });

	// 标签生成 PrintFlag:Boolean 是否打印
	function PrintLabel(PrintFlag) {
		PrintFlag = PrintFlag || false; // 默认不打印
		var Rows = GridList.getChecked();
		if (isEmpty(Rows)) {
			$UI.msg('alert', '请选择需要生成的消毒包');
			return;
		}

		var ParamsObj = $UI.loopBlock('Usertb');
		var Main = JSON.stringify(addSessionParams($UI.loopBlock('Usertb')));
		if (isEmpty(ParamsObj.PackChkUser)) {
			$UI.msg('alert', '请输入审核人');
			$('#PackChkUser').focus();
			return;
		}
		if (isEmpty(ParamsObj.PackUser)) {
			$UI.msg('alert', '请输入包装人');
			$('#PackUser').focus();
			return;
		}
		if (isEmpty(ParamsObj.Packer) && (IsPackUser === 'Y')) {
			$UI.msg('alert', '请输入配包人');
			$('#Packer').focus();
			return;
		}
		if (!isEmpty(ParamsObj.SterDate)) {
			var DiffDay = (new Date() - new Date(ParamsObj.SterDate)) / (1000 * 3600 * 24);
			if ((DiffDay < 0) || (DiffDay > 2)) {
				$UI.msg('alert', '灭菌日期不能晚于当前2天，不能早于今天');
				return;
			}
		}

		if (Rows[0].IsGen === 'Y') {
			var message = '该非循环包申请单已生成标签，请核对！';
			if (Rows.length > 1) {
				message = '存在已生成的非循环包申请单，请核对！';
			}
			$UI.msg('alert', message);
			return;
		}
		SelFlPackArray = DeepClone(Rows);
		var DetailParams = JSON.stringify(Rows);
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Pack.FabricApplyPackLabel',
			MethodName: 'jsGenFlLabel',
			Main: Main,
			Detail: DetailParams
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				FindDetail(jsonData.rowid);
				GridList.reload();
				if (PrintFlag) {
					Print(jsonData.rowid);
				}
			} else {
				$UI.msg('alert', jsonData.msg);
			}
		});
	}

	// 标签生成
	$UI.linkbutton('#LabelGen', {
		onClick: function() {
			PrintLabel(false);
		}
	});

	// 标签生成并打印
	$UI.linkbutton('#GenLabelAndPrint', {
		onClick: function() {
			PrintLabel(true);
		}
	});

	function Print(details) {
		$.cm({
			ClassName: 'web.CSSDHUI.Pack.FabricApplyPackLabel',
			MethodName: 'GetPackageLabels',
			CBItmIds: details
		}, function(jsonData) {
			if (!isEmpty(jsonData)) {
				var Obj = $UI.loopBlock('#SelReqConditions');
				var MainParams = JSON.stringify(Obj);
				$.each(jsonData, function(index, item) {
					printoutnotitm(item.label, MainParams);
				});
			}
		});
	}
	$UI.linkbutton('#Print', {
		onClick: function() {
			var Rows = GridList.getChecked();
			if (isEmpty(Rows)) {
				$UI.msg('alert', '请选择需要打印的消毒包');
			}
			var DetailIds = '';
			for (var i = 0, Len = Rows.length; i < Len; i++) {
				var DetailId = Rows[i]['RowId'];
				if (DetailIds === '') {
					DetailIds = DetailId;
				} else {
					DetailIds = DetailIds + ',' + DetailId;
				}
			}
			$.cm({
				ClassName: 'web.CSSDHUI.Pack.FabricApplyPackLabel',
				MethodName: 'GetPackageLabels',
				CBItmIds: DetailIds
			}, function(jsonData) {
				if (!isEmpty(jsonData)) {
					var Obj = $UI.loopBlock('#SelReqConditions');
					var MainParams = JSON.stringify(Obj);
					$.each(jsonData, function(index, item) {
						printoutnotitm(item.label, MainParams);
					});
				}
			});
		}
	});
	// 带明细打印
	function PrintDetail() {
		var Detail = GridDetailList.getChecked();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '请选择需要打印的消毒包');
		}
		if (!isEmpty(Detail)) {
			var Obj = $UI.loopBlock('#Usertb');
			var MainParams = JSON.stringify(Obj);
			$.each(Detail, function(index, item) {
				if (!isEmpty(item.Label)) {
					printout(item.Label, MainParams);
				}
			});
		}
	}

	function PrintNotDetail() {
		var Detail = GridDetailList.getChecked();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '请选择需要打印的消毒包');
		}
		if (!isEmpty(Detail)) {
			var Obj = $UI.loopBlock('#SelReqConditions');
			var MainParams = JSON.stringify(Obj);
			$.each(Detail, function(index, item) {
				if (!isEmpty(item.Label)) {
					printoutnotitm(item.Label, MainParams);
				}
			});
		}
	}

	$UI.linkbutton('#UpdateBT', {
		onClick: function() {
			var Detail = GridDetailList.getChecked();
			if (isEmpty(Detail)) {
				$UI.msg('alert', '请选择需要修改的消毒包');
				return;
			}
			var PackIdStr = '';
			$.each(Detail, function(index, item) {
				if (!isEmpty(item.RowId)) {
					if (!isEmpty(PackIdStr)) {
						PackIdStr = PackIdStr + ',' + item.RowId;
					} else {
						PackIdStr = item.RowId;
					}
				}
			});
			LabelInfoEdit(PackIdStr, FindDetail);
		}
	});

	function flagColor(val, row, index) {
		if (val === 'Y') {
			return 'color:white;background:' + GetColorCode('green');
		} else {
			return 'color:white;background:' + GetColorCode('red');
		}
	}
	var Cm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			field: 'operate',
			title: '标识',
			align: 'center',
			width: 50,
			formatter: function(value, row, index) {
				var str = '';
				if (row.LevelFlag === '1') {
					str = '<div href="#" title="紧急" class="col-icon icon-emergency"></div>';
				}
				str = str + '<div class="col-icon icon-img" href="#" title="查看图片" onclick="ViewPic(' + row.PkgId + ')"></div>';
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 60,
			hidden: true
		}, {
			title: '是否生成',
			field: 'IsGen',
			width: 80,
			align: 'center',
			styler: flagColor,
			formatter: function(value) {
				var status = '';
				if (value === 'Y') {
					status = '已完成';
				} else {
					status = '未完成';
				}
				return status;
			}
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 160
		}, {
			title: '数量',
			field: 'Qty',
			align: 'right',
			width: 60,
			editor: { type: 'validatebox' }
		}, {
			title: '申请单号',
			field: 'ApplyNo',
			width: 100
		}, {
			title: '申请时间',
			field: 'SubmitDate',
			width: 150
		}, {
			title: '申请科室',
			field: 'ReqLocDesc',
			width: 160
		}, {
			title: '紧急状态',
			field: 'LevelFlag',
			width: 100,
			hidden: true
		}
	]];
	var GridList = $UI.datagrid('#GridList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Pack.FabricApplyPackLabel',
			QueryName: 'SelectFlApply',
			Params: JSON.stringify($UI.loopBlock('SelReqConditions'))
		},
		columns: Cm,
		sortName: 'RowId',
		sortOrder: 'desc',
		showSaveItems: true,
		singleSelect: false,
		saveDataFn: function() { // 保存明细
			var ItemRows = GridList.getChangesData();
			if (isEmpty(ItemRows)) return;
			if (ItemRows === false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.Pack.FabricApplyPackLabel',
				MethodName: 'jsUpdateQty',
				Params: JSON.stringify(ItemRows)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					GridList.reload();
				} else {
					$UI.msg('alert', jsonData.msg);
				}
			});
		},
		onClickRow: function(index, row) {
			GridList.commonClickRow(index, row);
		},
		onSelectChangeFn: function() {
			FindDetail();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				if (!isEmpty(SelFlPackArray)) {
					$.each(data.rows, function(Index, Row) {
						$.each(SelFlPackArray, function(ArrIndex, ArrRow) {
							if (ArrRow['RowId'] === Row['RowId']) {
								$('#GridList').datagrid('checkRow', Index);
							}
						});
					});
				} else if (CommParObj.SelectFirstRow == 'Y') {
					$('#GridList').datagrid('selectRow', 0);
				}
			}
			SelFlPackArray = [];
		}
	});
	var detailCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			field: 'RowId',
			title: 'RowId',
			width: 60,
			hidden: true
		}, {
			field: 'operate',
			title: '标识',
			align: 'center',
			width: 50,
			formatter: function(value, row, index) {
				var str = '';
				if (row.LevelFlag === '1') {
					str = '<div href="#" title="紧急" class="col-icon icon-emergency"></div>';
				}
				return str;
			}
		}, {
			title: '标签',
			field: 'Label',
			width: 160
		}, {
			title: '消毒包Id',
			field: 'PkgId',
			width: 160,
			hidden: true
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 160,
			showTip: true,
			tipWidth: 200
		}, {
			title: '紧急状态',
			field: 'LevelFlag',
			width: 100,
			hidden: true
		}, {
			title: '当前状态',
			field: 'StatusDesc',
			width: 100
		}, {
			title: '状态',
			field: 'Status',
			width: 100,
			hidden: true
		}, {
			title: 'PackId',
			field: 'PackId',
			width: 100,
			hidden: true
		}, {
			title: '审核人',
			field: 'PackChkUserName',
			width: 100
		}, {
			title: 'PackChkUserId',
			field: 'PackChkUserId',
			width: 100,
			hidden: true
		}, {
			title: '包装人',
			field: 'PackUserName',
			width: 100
		}, {
			title: 'PackUserId',
			field: 'PackUserId',
			width: 100,
			hidden: true
		}, {
			title: '配包人',
			field: 'PackerName',
			width: 100
		}, {
			title: '灭菌人',
			field: 'SterUserName',
			width: 100
		}, {
			title: '失效日期',
			field: 'ExpDate',
			width: 90
		}, {
			title: '包装材料',
			field: 'MaterialDesc',
			width: 100
		}, {
			title: '灭菌器',
			field: 'MachineDesc',
			width: 90
		}, {
			title: '批次',
			field: 'HeatNo',
			width: 100
		}, {
			title: '备注',
			field: 'Remark',
			width: 160
		}
	]];
	
	var GridDetailList = $UI.datagrid('#ItemList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Pack.FabricApplyPackLabel',
			MethodName: 'QueryFabricPkgsByCallBackId'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.Pack.FabricApplyPackLabel',
			MethodName: 'jsDelete'
		},
		singleSelect: false,
		columns: detailCm,
		pagination: false,
		onClickRow: function(index, row) {
			GridDetailList.commonClickRow(index, row);
		},
		afterDelFn: function() {
			GridList.commonReload();
			$UI.clear(ItemSListGrid);
		},
		onSelect: function(index, row) {
			var Id = row.PkgId;
			if (!isEmpty(Id)) {
				FindPkgDetail(Id);
			}
		},
		toolbar: [{
			text: '标签打印',
			iconCls: 'icon-print',
			handler: function() {
				PrintNotDetail();
			}
		}, {
			text: '带明细打印',
			iconCls: 'icon-paper-print',
			handler: function() {
				PrintDetail();
			}
		}, {
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() {
				GridDetailList.commonDeleteRow(true);
			}
		}]
	});
	// /标签明细
	function FindDetail() {
		$UI.clear(ItemSListGrid);
		var Rows = GridList.getSelections();
		if (!isEmpty(Rows)) {
			var DetailIds = '';
			for (var i = 0; i < Rows.length; i++) {
				var DetailId = Rows[i].RowId;
				DetailIds = DetailIds === '' ? DetailId : DetailIds + ',' + DetailId;
			}
			GridDetailList.load({
				ClassName: 'web.CSSDHUI.Pack.FabricApplyPackLabel',
				QueryName: 'QueryFabricPkgsByCallBackId',
				Params: DetailIds,
				rows: 9999
			});
		}
	}
	// 器械明细
	function FindPkgDetail(Id) {
		ItemSListGrid.load({
			ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
			QueryName: 'SelectByF',
			PkgId: Id,
			rows: 99999
		});
	}
	
	var ItemSCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '器械名称',
			field: 'ItmDesc',
			width: 140,
			styler: function(value, row, index) {
				return 'background-color:' + row.OneOffColor + ';';
			}
		}, {
			title: '规格',
			field: 'ItmSpec',
			width: 60
		}, {
			title: '数量',
			field: 'Qty',
			align: 'right',
			width: 60
		}
	]];
	var ItemSListGrid = $UI.datagrid('#ItemSListGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
			QueryName: 'SelectByF'
		},
		columns: ItemSCm,
		pagination: false,
		sortName: 'RowId',
		sortOrder: 'desc'
	});
	
	function AdjustLayoutSize() {
		var NorthWidth = $(window).width() * 0.5;
		var DispWestWidth = $(window).width() * 0.3;
		$('#OrdLayout').layout('panel', 'east').panel('resize', { width: NorthWidth });
		$('#OrdLayout').layout();
		$('#FLApplyLayout').layout('panel', 'west').panel('resize', { width: DispWestWidth });
		$('#FLApplyLayout').layout();
	}
	window.onresize = function() {
		AdjustLayoutSize();
	};
	AdjustLayoutSize();
	query();
};
$(init);