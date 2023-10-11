var ParamObj = GetAppPropValue('CSSDPACK');
var init = function() {
	Default();
	var ParamsBDP = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	var IsPackUser = ParamObj.IsPackUser;
	if (IsPackUser !== 'Y') {
		$('#Packer').combobox({ disabled: true });
	}

	var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TypeDetail: '7' }));
	$HUI.combobox('#Pkg', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(row) {
			if (!isEmpty(row)) {
				$HUI.combobox('#Material', {
					url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetBindMaterials&ResultSetType=array&packageDr=' + row.RowId,
					valueField: 'RowId',
					textField: 'Description',
					onLoadSuccess: function(data) { // 默认第一个值
						$('#Material').combobox('setValue', '');
					}
				});
			}
		}
	});

	var LocParams = JSON.stringify(addSessionParams({ Type: 'RecLoc', BDPHospital: gHospId }));
	$HUI.combobox('#ToLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
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
			param.Params = ParamsBDP;
		}
	});

	// 审核人回车
	$('#PackChkUser').combobox('textbox').keyup(function(event) {
		var curKey = event.which;
		if (curKey === 13) {
			var userCode = $('#PackChkUser').combobox('getText');
			if (!isEmpty(userCode)) {
				var UserObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetUserByCodeJson',
					userCode: userCode,
					Params: ParamsBDP
				}, false);
				if (!isEmpty(UserObj['RowId'])) {
					$('#PackChkUser').combobox('clear');
					$('#PackChkUser').combobox('setValue', UserObj['RowId']);
					$('#PackUser').combobox('textbox').focus();
				} else {
					var PackChkUserId = $('#PackChkUser').combobox('getValue');
					if (isEmpty(PackChkUserId)) {
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
			param.Params = ParamsBDP;
		}
	});

	// 包装人回车
	$('#PackUser').combobox('textbox').keyup(function(event) {
		var curKey = event.which;
		if (curKey === 13) {
			var userCode = $('#PackUser').combobox('getText');
			if (!isEmpty(userCode)) {
				var UserObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetUserByCodeJson',
					userCode: userCode,
					Params: ParamsBDP
				}, false);
				if (!isEmpty(UserObj['RowId'])) {
					$('#PackUser').combobox('clear');
					$('#PackUser').combobox('setValue', UserObj['RowId']);
					if (IsPackUser === 'Y') {
						$('#Packer').combobox('textbox').focus();
					} else {
						$('#CreateQty').focus();
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
			param.Params = ParamsBDP;
		}
	});

	// 配包人回车
	$('#Packer').combobox('textbox').keyup(function(event) {
		var curKey = event.which;
		if (curKey === 13) {
			var userCode = $('#Packer').combobox('getText');
			if (!isEmpty(userCode)) {
				var UserObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetUserByCodeJson',
					userCode: userCode,
					Params: ParamsBDP
				}, false);
				if (!isEmpty(UserObj['RowId'])) {
					$('#Packer').combobox('clear');
					$('#Packer').combobox('setValue', UserObj['RowId']);
					$('#CreateQty').focus();
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
			param.Params = ParamsBDP;
		}
	});

	// 灭菌人回车
	$('#SterUser').combobox('textbox').keyup(function(event) {
		var curKey = event.which;
		if (curKey === 13) {
			var userCode = $('#SterUser').combobox('getText');
			if (!isEmpty(userCode)) {
				var UserObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetUserByCodeJson',
					userCode: userCode,
					Params: ParamsBDP
				}, false);
				if (!isEmpty(UserObj['RowId'])) {
					$('#SterUser').combobox('clear');
					$('#SterUser').combobox('setValue', UserObj['RowId']);
				} else {
					var SterUserId = $('#SterUser').combobox('getValue');
					if (isEmpty(SterUserId)) {
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
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterMachine&ResultSetType=array&type=sterilizer&Params=' + ParamsBDP,
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'MachineNo'
	});

	$('#SterMachine').combobox('textbox').keyup(function(event) {
		if (event.which === 13) {
			var SterMachineId = $('#SterMachine').combobox('getValue');
			if (isEmpty(SterMachineId)) {
				var SterMachineDesc = $('#SterMachine').combobox('getText');
				var Params = ParamsBDP;
				var MachineObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetSterMachineInfo',
					MachineNo: SterMachineDesc,
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

	// 包装材料下拉框
	$HUI.combobox('#Material', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetMaterials&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});

	// 查询
	$UI.linkbutton('#query', {
		onClick: function() {
			$UI.clear(ItemSListGrid);
			query();
		}
	});

	function query() {
		var Params = JSON.stringify($UI.loopBlock('Condition'));
		GridList.load({
			ClassName: 'web.CSSDHUI.Pack.FabricLbl',
			QueryName: 'QueryFabricPkgs',
			Params: Params,
			rows: 999
		});
	}

	/**
	 * 生成标签
	 * @param {*} AutoPrintFlag 是否自动打印
	 * @returns
	 */
	function CheckCreateLabel(AutoPrintFlag) {
		AutoPrintFlag = AutoPrintFlag || false;
		var ParamsObj = $UI.loopBlock('Condition');
		if (isEmpty(ParamsObj.Pkg)) {
			$UI.msg('alert', '请选择消毒包');
			return;
		}
		if (isEmpty(ParamsObj.PackChkUser)) {
			$UI.msg('alert', '请输入审核人');
			$('#PackChkUser').combobox('textbox').focus();
			return;
		}
		if (isEmpty(ParamsObj.PackUser)) {
			$UI.msg('alert', '请输入包装人');
			$('#PackUser').combobox('textbox').focus();
			return;
		}
		if (isEmpty(ParamsObj.Packer) && (IsPackUser === 'Y')) {
			$UI.msg('alert', '请输入配包人');
			$('#Packer').combobox('textbox').focus();
			return;
		}
		if (!isEmpty(ParamsObj.SterDate)) {
			var Today = DateFormatter(new Date());
			if (compareDate(Today, ParamsObj.SterDate)) {
				$UI.msg('alert', '灭菌日期不可早于今天！');
				return;
			}
		}
		if (isEmpty(ParamsObj.CreateQty)) {
			$UI.msg('alert', '请输入数量');
			$('#CreateQty').focus();
			return;
		}
		if (isEmpty(ParamsObj.ToLoc)) {
			$UI.confirm('接收科室未选择,是否继续?', '', '', CreateLabel, '', '', '', '', AutoPrintFlag);
		} else {
			CreateLabel(AutoPrintFlag);
		}
	}
	function CreateLabel(AutoPrintFlag) {
		AutoPrintFlag = AutoPrintFlag || false;
		var ParamsObj = $UI.loopBlock('Condition');
		var Params = JSON.stringify(ParamsObj);
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Pack.FabricLbl',
			MethodName: 'jsGenFabricPkgs',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				FindNew(jsonData.rowid);
				if (AutoPrintFlag) {
					var Qty = ParamsObj['CreateQty'];
					for (var i = 0; i < Qty; i++) {
						var RowId = jsonData.rowid.split(',')[i];
						var Label = tkMakeServerCall('web.CSSDHUI.Pack.FabricLbl', 'GetFabricLbl', RowId);
						printoutnotitm(Label, Params);
					}
				}
				Default();
			} else {
				$UI.msg('alert', jsonData.msg);
			}
		});
	}

	// 标签生成
	$UI.linkbutton('#LabelGen', {
		onClick: function() {
			CheckCreateLabel(false);
		}
	});
	// 标签生成并打印
	$UI.linkbutton('#GenLabelAndPrint', {
		onClick: function() {
			CheckCreateLabel(true);
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			clear();
		}
	});

	$UI.linkbutton('#UpdateBT', {
		onClick: function() {
			var Detail = GridList.getChecked();
			if (isEmpty(Detail)) {
				$UI.msg('alert', '请选择需要修改的消毒包');
				return;
			}
			var PackIdStr = '';
			$.each(Detail, function(index, item) {
				if (!isEmpty(item.PackId)) {
					if (!isEmpty(PackIdStr)) {
						PackIdStr = PackIdStr + ',' + item.PackId;
					} else {
						PackIdStr = item.PackId;
					}
				}
			});
			LabelInfoEdit(PackIdStr, query);
		}
	});
	
	// 打印
	function Print() {
		var Detail = GridList.getSelectedData();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '请选择要打印的数据!');
		}
		if (!isEmpty(Detail)) {
			var Obj = $UI.loopBlock('#cleantable');
			var MainParams = JSON.stringify(Obj);
			$.each(Detail, function(index, item) {
				printoutnotitm(item.Label, MainParams);
			});
		}
	}
	// 标签打印(带明细)
	function PrintWithItm() {
		var Detail = GridList.getSelections();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '请选择需要打印的消毒包');
			return;
		}
		if (!isEmpty(Detail)) {
			var Obj = $UI.loopBlock('#cleantable');
			var MainParams = JSON.stringify(Obj);
			$.each(Detail, function(index, item) {
				printout(item.Label, MainParams);
			});
		}
	}
	// 删除
	function DeleteLabel() {
		var Detail = GridList.getSelections();
		var DetailParams = JSON.stringify(Detail);
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Pack.FabricLbl',
			MethodName: 'jsDeleteLabel',
			Params: DetailParams
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				query();
			} else {
				$UI.msg('alert', jsonData.msg);
			}
		});
	}

	var Cm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: '标签',
			field: 'Label',
			width: 200
		}, {
			title: '打包表Id',
			field: 'PackId',
			width: 60,
			hidden: true
		}, {
			title: 'PkgId',
			field: 'PkgId',
			width: 60,
			hidden: true
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 160,
			showTip: true,
			tipWidth: 200
		}, {
			title: '包装材料',
			field: 'MaterialDesc',
			width: 120
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
			title: '审核人',
			field: 'PackChkUserName',
			width: 100
		}, {
			title: '包装人',
			field: 'PackUserName',
			width: 100
		}, {
			title: '配包人',
			field: 'PackerName',
			width: 100
		}, {
			title: '灭菌人',
			field: 'SterUserName',
			width: 100
		}, {
			title: '灭菌日期',
			field: 'SterDate',
			width: 120
		}, {
			title: '失效日期',
			field: 'ExpDate',
			width: 120
		}, {
			title: '科室',
			field: 'ToLocDesc',
			width: 160
		}, {
			title: '灭菌器',
			field: 'SterMachineDesc',
			width: 80,
			align: 'center'
		}, {
			title: '批次',
			field: 'HeatNo',
			width: 60,
			align: 'center'
		}, {
			title: '备注',
			field: 'Remark',
			width: 160,
			editor: {
				type: 'text'
			}
		}
	]];
	var GridList = $UI.datagrid('#GridList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Pack.FabricLbl',
			QueryName: 'QueryFabricPkgs',
			Params: JSON.stringify($UI.loopBlock('Condition'))
		},
		navigatingWithKey: true,
		columns: Cm,
		fitColumns: true,
		singleSelect: false,
		pagination: false,
		sortName: 'RowId',
		sortOrder: 'desc',
		onSelect: function(index, row) {
			var Id = row.PkgId;
			if (!isEmpty(Id)) {
				FindPkgDetail(Id);
			}
		},
		toolbar: [
			{
				text: '打印',
				iconCls: 'icon-print',
				handler: function() {
					Print();
				}
			}, {
				text: '带明细打印',
				iconCls: 'icon-print',
				handler: function() {
					PrintWithItm();
				}
			}, {
				text: '删除',
				iconCls: 'icon-cancel',
				handler: function() {
					var Detail = GridList.getSelections();
					if (isEmpty(Detail)) {
						$UI.msg('alert', '请选择需要删除的消毒包');
						return;
					}
					$UI.confirm('您将删除选中的标签, 是否继续?', '', '', DeleteLabel);
				}
			}
		],
		onClickRow: function(index, row) {
			GridList.commonClickRow(index, row);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#GridList').datagrid('selectRow', 0);
			}
		}
	});
	
	//器械明细
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
	
	function FindNew(RowIdStr) {
		var ParamsObj = { RowIdStr: RowIdStr };
		var Params = JSON.stringify(ParamsObj);
		GridList.load({
			ClassName: 'web.CSSDHUI.Pack.FabricLbl',
			QueryName: 'QueryFabricPkgs',
			Params: Params,
			rows: 999
		});
	}
	function Default() {
		// /设置初始值 考虑使用配置
		$('#StartDate').datebox('setValue', DateFormatter(new Date()));
		$('#EndDate').datebox('setValue', DateFormatter(new Date()));
	}
	// 人员信息不清除
	function clear() {
		$UI.clearBlock('#Condition');
		$UI.clear(GridList);
		$UI.clear(ItemSListGrid);
		Default();
	}
	query();
};
$(init);