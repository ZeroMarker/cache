function getcleandtail(Id, PkgId) {
	FindDetail(Id, PkgId);
}
function getpackageitem(PkgId) {
	FindPackageItem(PkgId, '');
}

var CurrentIds = '';
var CleanList;
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
	var AfterPrintClearUser = PackParamObj.AfterPrintClearUser;
	var IsPackUser = PackParamObj.IsPackUser;

	function Default() {
		var StartDate = getQueryVariable('StartDate');
		$UI.clearBlock('#CleanTable');
		$UI.clearBlock('#Usertb');
		$UI.clear(CleanList);
		$UI.clear(ItmList);
		if (IsPackUser !== 'Y') {
			$('#Packer').combobox({ disabled: true });
		}
		// 包属性
		var PackAttributeCode = GetLocalStorage('PackAttributeCode');
		if (PackAttributeCode == '1') {
			$HUI.radio('#Attribute_1').setValue(true);
		} else if (PackAttributeCode == '2') {
			$HUI.radio('#Attribute_2').setValue(true);
		} else {
			$HUI.radio('#Attribute').setValue(true);
		}
		// 外来器械
		var PackExtFlag = GetLocalStorage('PackExtFlag');
		if (!isEmpty(PackExtFlag)) {
			$('#ExtFlag').keywords('select', PackExtFlag);
		}
		var DefaultValue = {
			CleanStartDate: StartDate,
			CleanEndDate: DateFormatter(new Date())
		};
		$UI.fillBlock('#CleanTable', DefaultValue);
	}

	$('#ExtFlag').keywords({
		singleSelect: true,
		items: [
			{ text: '全部', id: '' }, { text: '是', id: 'Y' }, { text: '否', id: 'N' }
		],
		onSelect: function(v) {
			SetLocalStorage('PackExtFlag', v.id);
			ReloadPkgCombobox();
		}
	});
	
	$HUI.radio("[name='AttributeCode']", {
		onChecked: function(e, value) {
			var AttributeCode = $(e.target).attr('value');
			SetLocalStorage('PackAttributeCode', AttributeCode);	// 记录默认值
			if (AttributeCode == 2) {
				$('#ExtFlag').keywords('clearAllSelected');
				SetLocalStorage('PackExtFlag', '');
			}
			ReloadPkgCombobox();
		}
	});

	function ReloadPkgCombobox() {
		var ParamsObj = $UI.loopBlock('CleanTable');
		var AttributeCode = ParamsObj.AttributeCode;
		var ExtFlag = ParamsObj.ExtFlag;
		var DataParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TypeDetail: AttributeCode, ExtFlag: ExtFlag, CreateLocId: gLocId }));
		$('#Pkg').combobox('clear');
		$('#Pkg').combobox('reload', $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + DataParams);
	}

	// 清洗机的下拉数据加载
	$HUI.combobox('#CleanMachine', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetMachineNoComBo&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'MachineNo',
		onBeforeLoad: function(param) {
			param.type = 'washer';
			param.Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
		}
	});

	$('#CleanMachine').combobox('textbox').keyup(function(event) {
		if (event.which === 13) {
			var ClreanMachineNo = $('#CleanMachine').combobox('getText');
			if (isEmpty(ClreanMachineNo)) {
				$UI.msg('alert', '请录入清洗机！');
				return;
			}
			var Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
			var MachineObj = $.cm({
				ClassName: 'web.CSSDHUI.Common.Dicts',
				MethodName: 'GetMachineNo',
				Type: 'washer',
				MachineNo: ClreanMachineNo,
				Params: Params
			}, false);
			var MachineId = MachineObj['ID'];
			if (isEmpty(MachineId)) {
				$UI.msg('alert', '请录入可用的清洗机!');
				$('#CleanMachine').combobox('clear');
				$('#CleanMachine').combobox('textbox').focus();
				return;
			}
			$('#CleanMachine').combobox('setValue', MachineId);
		}
	});

	var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, AttributeCode: '1,2', CreateLocId: gLocId }));
	$HUI.combobox('#Pkg', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			
		}
	});

	// 灭菌方式
	$HUI.combobox('#SterTypeId', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterType&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});

	function Query() {
		var ParamsObj = $UI.loopBlock('CleanTable');
		if (isEmpty(ParamsObj.CleanStartDate)) {
			$UI.msg('alert', '起始日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.CleanEndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		$UI.clear(CleanList);
		$UI.clear(ItmList);
		var Params = JSON.stringify(ParamsObj);
		CleanList.load({
			ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
			QueryName: 'SelectAllCheck',
			Params: Params
		});
	}

	// 审核人员
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
	$('#PackChkUser').combobox('textbox').keyup(function(event) {
		if (event.keyCode === 13) {
			var userCode = $('#PackChkUser').combobox('getText');
			if (!isEmpty(userCode)) {
				var UserObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetUserByCodeJson',
					userCode: userCode,
					Params: JSON.stringify(addSessionParams({ BDPHospital: gHospId }))
				}, false);
				if (isEmpty(UserObj['RowId'])) {
					$UI.msg('alert', '未获取审核人相关信息！');
					$('#PackChkUser').combobox('clear').combobox('hidePanel');
					$('#PackChkUser').combobox('textbox').focus();
					return;
				}
				$('#PackChkUser').combobox('clear');
				$('#PackChkUser').combobox('setValue', UserObj['RowId']).combobox('hidePanel');
				$('#PackUser').combobox('textbox').focus();
			}
		}
	});

	// 包装人员
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
	$('#PackUser').combobox('textbox').keyup(function(event) {
		if (event.keyCode === 13) {
			var userCode = $('#PackUser').combobox('getText');
			if (!isEmpty(userCode)) {
				var UserObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetUserByCodeJson',
					userCode: userCode,
					Params: JSON.stringify(addSessionParams({ BDPHospital: gHospId }))
				}, false);
				if (isEmpty(UserObj['RowId'])) {
					$UI.msg('alert', '未获取到包装人相关信息!');
					$('#PackUser').combobox('clear').combobox('hidePanel');
					$('#PackUser').combobox('textbox').focus();
					return;
				}
				$('#PackUser').combobox('clear');
				$('#PackUser').combobox('setValue', UserObj['RowId']).combobox('hidePanel');
				if (IsPackUser === 'Y') {
					$('#Packer').combobox('textbox').focus();
				} else {
					$('#LabelQty').focus();
				}
			}
		}
	});

	// 配包人员
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
	$('#Packer').combobox('textbox').keyup(function(event) {
		if (event.keyCode === 13) {
			var userCode = $('#Packer').combobox('getText');
			if (!isEmpty(userCode)) {
				var UserObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetUserByCodeJson',
					userCode: userCode,
					Params: JSON.stringify(addSessionParams({ BDPHospital: gHospId }))
				}, false);
				if (isEmpty(UserObj['RowId'])) {
					$UI.msg('alert', '未获取到配包人相关信息!');
					$('#Packer').combobox('clear').combobox('hidePanel');
					$('#Packer').combobox('textbox').focus();
					return;
				}
				$('#Packer').combobox('clear');
				$('#Packer').combobox('setValue', UserObj['RowId']).combobox('hidePanel');
				$('#LabelQty').focus();
			}
		}
	});

	// 灭菌人
	$HUI.combobox('#SterUser', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'Code',
		onBeforeLoad: function(param) {
			param.Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
		}
	});
	$('#SterUser').combobox('textbox').keyup(function(event) {
		if (event.keyCode === 13) {
			var userCode = $('#SterUser').combobox('getText');
			if (!isEmpty(userCode)) {
				var UserObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetUserByCodeJson',
					userCode: userCode,
					Params: JSON.stringify(addSessionParams({ BDPHospital: gHospId }))
				}, false);
				if (isEmpty(UserObj['RowId'])) {
					$UI.msg('alert', '未获取审核人相关信息！');
					$('#SterUser').combobox('clear').combobox('hidePanel');
					$('#SterUser').combobox('textbox').focus();
					return;
				}
				$('#SterUser').combobox('clear');
				$('#SterUser').combobox('setValue', UserObj['RowId']).combobox('hidePanel');
			}
		}
	});

	$('#SterDate').bind('keyup', function(event) {
		if (event.keyCode === 13) {
			$('#MaterialId').combobox('textbox').focus();
		}
	});

	// 包装材料
	$HUI.combobox('#MaterialId', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetMaterials&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#MaterialId').combobox('textbox').keyup(function(event) {
		if (event.keyCode === 13) {
			$('#ToLoc').combobox('textbox').focus();
		}
	});

	$HUI.combobox('#ToLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onBeforeLoad: function(param) {
			param.Params = JSON.stringify(addSessionParams({ Type: 'RecLoc', BDPHospital: gHospId }));
		}
	});
	$('#ToLoc').combobox('textbox').keyup(function(event) {
		if (event.keyCode === 13) {
			$('#SterMachine').combobox('textbox').focus();
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
			var SterMachineId = $('#SterMachine').combobox('getValue');
			if (isEmpty(SterMachineId)) {
				var SterMachineNo = $('#SterMachine').combobox('getText');
				var Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
				var MachineObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetSterMachineInfo',
					MachineNo: SterMachineNo,
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

	$('#HeatNo').keyup(function(event) {
		if (event.which === 13) {
			$('#LabelQty').focus();
		}
	});

	/**
	 * 审核人、包装人、配包人有效性检查
	 * @returns {Boolean} true;false
	 */
	function CheckUserData() {
		var PackChkUserName = $('#PackChkUser').combobox('getText');
		var PackUserName = $('#PackUser').combobox('getText');
		var PackerName = $('#Packer').combobox('getText');
		if (isEmpty(PackChkUserName)) {
			$UI.msg('alert', '请输入审核人！');
			$('#PackChkUser').combobox('textbox').focus();
			return false;
		}
		if (isEmpty(PackUserName)) {
			$UI.msg('alert', '请输入包装人！');
			$('#PackUser').combobox('textbox').focus();
			return false;
		}
		if ((isEmpty(PackerName)) && (IsPackUser === 'Y')) {
			$UI.msg('alert', '请输入配包人');
			$('#Packer').combobox('textbox').focus();
			return false;
		}
		return true;
	}

	// 设置组合标志，以哪个包为主
	$UI.linkbutton('#ordSetUp', {
		onClick: function() {
			if (!CheckUserData()) return;
			var Main = JSON.stringify($UI.loopBlock('Usertb'));
			var Rows = ItmList.getSelections();
			if (isEmpty(Rows)) {
				$UI.msg('alert', '请选择需要设定的消毒包！');
				return;
			}
			if (Rows.length !== 1) {
				$UI.msg('alert', '设定的消毒包只能为一个！');
				return;
			}
			var DetailParams = JSON.stringify(Rows);
			var num = 1;
			$.cm({
				ClassName: 'web.CSSDHUI.Pack.ComposePackLabel',
				MethodName: 'jsSetUpComposeOrd',
				Main: Main,
				Detail: DetailParams,
				num: num
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					ItmList.commonReload();
				} else {
					$UI.msg('alert', jsonData.msg);
				}
			});
		}
	});
	
	// 合并生成一个标签
	$UI.linkbutton('#ordCompose', {
		onClick: function() {
			var Rows = ItmList.getSelections();
			if (isEmpty(Rows)) {
				$UI.msg('alert', '请选择需要组合的消毒包！');
				return;
			}
			var detailComposeID = '';
			$.each(Rows, function(index, item) {
				var AttributeCode = item.AttributeCode;
				if (AttributeCode != 2) {
					$UI.msg('alert', '请选择普通循环包进行组合');
					return;
				}
				if ((item.ComposeFlag === 'Y')) {
					detailComposeID = item.CleanItmId;
				}
			});
			if (detailComposeID === '') {
				$UI.msg('alert', '请选择设定的消毒包！');
				return;
			}
			var DetailParams = JSON.stringify(Rows);
			$.cm({
				ClassName: 'web.CSSDHUI.Pack.ComposePackLabel',
				MethodName: 'ComposeOrdLabel',
				Detail: DetailParams,
				detailComposeID: detailComposeID
			}, function(jsonData) {
				if (jsonData.success === 0) {
					ItmList.commonReload();
				} else {
					$UI.msg('alert', jsonData.msg);
				}
			});
		}
	});

	// 取消合并生成一个标签
	$UI.linkbutton('#CancelCompose', {
		onClick: function() {
			var Rows = ItmList.getSelections();
			if (isEmpty(Rows)) {
				$UI.msg('alert', '请选择需要取消组合的消毒包！');
				return;
			}
			var detailComposeID = '';
			$.each(Rows, function(index, item) {
				if (item.ComposeFlag === 'Y') {
					detailComposeID = item.CleanItmId;
				}
			});
			if (detailComposeID === '') {
				$UI.msg('alert', '请选择设定的消毒包！');
				return;
			}
			var DetailParams = JSON.stringify(Rows);
			$.cm({
				ClassName: 'web.CSSDHUI.Pack.ComposePackLabel',
				MethodName: 'CancelComposeOrdLabel',
				Detail: DetailParams,
				detailComposeID: detailComposeID
			}, function(jsonData) {
				if (jsonData.success === 0) {
					ItmList.commonReload();
				} else {
					$UI.msg('alert', jsonData.msg);
				}
			});
		}
	});
	
	var Cm = [[
		{
			title: '',
			field: 'ck',
			checkbox: true,
			width: 50
		}, {
			title: 'ID',
			field: 'ID',
			width: 60,
			hidden: true
		}, {
			title: '标识',
			field: 'Operate',
			align: 'center',
			width: 50,
			formatter: function(value, row, index) {
				var str = '';
				if (row.LevelFlag === '1') {
					str = '<div class="col-icon icon-emergency" href="#" title="紧急"></div>';
				}
				return str;
			}
		}, {
			title: '标签生成',
			field: 'IsFinished',
			width: 80,
			styler: flagColor,
			formatter: function(value) {
				var status = '';
				if (value === '1') {
					status = '已完成';
				} else {
					status = '未完成';
				}
				return status;
			}
		}, {
			title: '清洗机',
			field: 'CleanMachineDesc',
			width: 80
		}, {
			title: '日期',
			field: 'CleanDate',
			width: 100
		}, {
			title: '时间',
			field: 'CleanTime',
			width: 100
		}, {
			title: '清洗批号',
			field: 'CleanNo',
			width: 150

		}, {
			title: '清洗人',
			field: 'CleanUserName',
			width: 100

		}, {
			title: '验收人',
			field: 'CleanChkUserName',
			width: 100

		}, {
			title: '紧急程度',
			field: 'LevelFlag',
			width: 80,
			hidden: true
		}
	]];

	function flagColor(val, row, index) {
		if ((val === '1') || (val === 'Y')) {
			return 'color:white;background:' + GetColorCode('green');
		} else {
			return 'color:white;background:' + GetColorCode('red');
		}
	}

	CleanList = $UI.datagrid('#CleanList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
			QueryName: 'SelectAllCheck'
		},
		columns: Cm,
		remoteSort: false,
		sortName: 'CleanDate',
		sortOrder: 'desc',
		selectOnCheck: false,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				if (!isEmpty(CurrentIds)) {
					CurrentIds = ',' + CurrentIds + ',';
					var Rows = $('#CleanList').datagrid('getRows');
					$.each(Rows, function(index, item) {
						var RowId = item.ID;
						RowId = ',' + RowId + ',';
						if (CurrentIds.indexOf(RowId) > -1) {
							GridListIndex = index;
							$('#CleanList').datagrid('selectRow', GridListIndex);
						}
					});
				} else if ((CommParObj.SelectFirstRow == 'Y')) {
					$('#CleanList').datagrid('selectRow', 0);
				}
				CurrentIds = '';
			}
		},
		onCheck: function(rowIndex, rowData) {
			QueryPack('');
		},
		onCheckAll: function(rowIndex, rowData) {
			QueryPack('');
		},
		onUncheck: function(rowIndex, rowData) {
			QueryPack('');
		},
		onUncheckAll: function(rowIndex, rowData) {
			QueryPack('');
		}
	});

	// 显示右边普通循环包和标牌追溯包
	function QueryPack(Id) {
		$UI.clear(ItmList);
		if (isEmpty(Id)) {
			var CheckData = CleanList.getChecked();
			for (var i = 0; i < CheckData.length; i++) {
				var CheckItem = CheckData[i];
				var RowId = CheckItem.ID;
				if (Id === '') {
					Id = RowId;
				} else {
					Id = Id + ',' + RowId;
				}
			}
		}
		if (isEmpty(Id)) {
			return;
		}
		CurrentIds = Id;
		var MainObj = $UI.loopBlock('CleanTable');
		var SterTypeId = MainObj.SterTypeId;
		var PkgId = MainObj.Pkg;
		var AttributeCode = MainObj.AttributeCode;
		var Label = MainObj.Label;
		var Params = JSON.stringify(addSessionParams({ CleanID: Id, PkgId: PkgId, SterTypeId: SterTypeId, Label: Label, AttributeCode: AttributeCode }));
		ItmList.load({
			ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
			QueryName: 'SelectAllLabel',
			Params: Params,
			rows: 9999
		});
	}

	// 标签生成
	$UI.linkbutton('#GenLabel', {
		onClick: function() {
			if (!CheckUserData()) return;
			var LabelQty = $('#LabelQty').val();
			if (!isEmpty(LabelQty) && LabelQty <= 0) {
				$UI.msg('alert', '请输入正确的个数！');
				$('#LabelQty').numberbox('setValue', '');
				$('#LabelQty').focus();
				return;
			}
			var MainObj = $UI.loopBlock('Usertb');
			var Main = JSON.stringify(MainObj);
			var Rows = ItmList.getSelections();
			if (isEmpty(Rows)) {
				$UI.msg('alert', '请选择需要生成的消毒包！');
				return;
			}
			var DetailParams = JSON.stringify(Rows);
			if ((LabelQty > 0) && (Rows.length > 1)) {
				$UI.msg('alert', '标签部分生成,只能选择某一个消毒包!');
				return;
			}
			var CompFlag = false;
			$.each(Rows, function(index, item) {
				if (item.unCreatedQty <= 0) {
					CompFlag = true;
					return false;
				}
			});
			if (CompFlag) {
				$UI.msg('alert', '无法重复生成标签!');
				return;
			}
			if (parseInt(Rows[0].unCreatedQty) < parseInt(LabelQty)) {
				$UI.msg('alert', '生成数量不能多于未生成数量！');
				$('#LabelQty').focus();
				return;
			}
			showMask();
			$.cm({
				ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
				MethodName: 'jsGenLabel',
				Main: Main,
				Detail: DetailParams
			}, function(jsonData) {
				hideMask();
				if (jsonData.success === 0) {
					$UI.msg('success', '标签生成成功！');
					CleanList.commonReload();
				} else {
					$UI.msg('alert', jsonData.msg);
				}
			});
			$('#LabelQty').numberbox('setValue', '');
		}
	});

	// 标签打印
	$UI.linkbutton('#LabelPrintBT', {
		onClick: function() {
			var WithDetail = 'Y';
			LabelPrint(WithDetail);
		}
	});
	$UI.linkbutton('#LabelPrintWithoutBT', {
		onClick: function() {
			var WithDetail = 'N';
			LabelPrint(WithDetail);
		}
	});
	function LabelPrint(WithDetail) {
		var Rows = ItmList.getSelections();
		if (isEmpty(Rows)) {
			$UI.msg('alert', '请选择需要打印的消毒包！');
			return;
		}
		var DetailIds = '';
		for (var i = 0, Len = Rows.length; i < Len; i++) {
			var CleanItmId = Rows[i]['CleanItmId'];
			var CreatedQty = Rows[i]['CreatedQty'];
			if (CreatedQty == 0) {
				$UI.msg('alert', '存在未生成标签消毒包，请重新选择!');
				return;
			}
			if (DetailIds === '') {
				DetailIds = CleanItmId;
			} else {
				DetailIds = DetailIds + ',' + CleanItmId;
			}
		}
		$.cm({
			ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
			MethodName: 'GetPackageLabels',
			details: DetailIds
		}, function(jsonData) {
			if (!isEmpty(jsonData)) {
				var MainParams = JSON.stringify($UI.loopBlock('#Usertb'));
				$.each(jsonData, function(index, item) {
					if (WithDetail == 'Y') {
						// 打印明细
						if (item.ComposeFlag === 'Y') {
							printoutCompose(item.label, MainParams);
						} else if (item.IsExt == 'Y') {
							printExt(item.label, MainParams);
						} else {
							if (item.IsLowerSter === 'Y') {	// 低温灭菌打印
								printlower(item.label, MainParams);
							} else if (item.IsSter === 'N') {	// 消毒类
								printoutXD(item.label, MainParams);
							} else {	// 高温灭菌打印
								printout(item.label, MainParams);
							}
						}
					} else {
						if (item.IsExt == 'Y') {
							printExtNotDetail(item.label, MainParams);
						} else {
							// 无打印明细
							printoutnotitm(item.label, MainParams);
						}
					}
				});
			}
			ItmList.commonReload();
			if (AfterPrintClearUser === 'Y') {
				ClearUser();
			}
		});
	}

	$UI.linkbutton('#CodeDictPrintBT', {
		onClick: function() {
			var Detail = ItmList.getSelections();
			if (isEmpty(Detail)) {
				$UI.msg('alert', '请选择需要打印的消毒包!');
				return;
			}
			if (!isEmpty(Detail)) {
				$.each(Detail, function(index, item) {
					var PkgDesc = item.PkgDesc;
					var CodeDict = item.CodeDict;
					if (isEmpty(CodeDict)) {
						$UI.msg('alert', '不存在对应标牌，不能打印');
						return;
					}
					printCodeDict(CodeDict, PkgDesc, '', 1);
				});
			}
		}
	});

	// 固定标签回车查询
	$('#CodeDict').keyup(function(e) {
		var curKey = e.which;
		if (curKey === 13) {
			var val = $('#CodeDict').val();
			if (!isEmpty (val)) {
				var Ret = tkMakeServerCall('web.CSSDHUI.Pack.CleanPackLabel', 'GetCleanInfoByCodeDict', val);
				if (isEmpty(Ret.split('^')[1])) {
					$UI.msg('alert', '未找到相关信息!');
					$('#CodeDict').val('');
					$('#CodeDict').focus();
					return;
				}
				if (!isEmpty(Ret)) {
					var rows = $('#CleanList').datagrid('getRows');
					$.each(rows, function(index, item) {
						if (item.ID === Ret.split('^')[0]) {
							$('#CleanList').datagrid('selectRow', index);
							QueryPack(Ret.split('^')[0]);
						}
					});
				} else {
					$UI.msg('alert', '未找到相关信息!');
					$('#CodeDict').val('');
					$('#CodeDict').focus();
				}
			}
		}
	});

	var ItmCm = [[
		{
			title: '',
			field: 'ck',
			checkbox: true,
			width: 50
		}, {
			title: 'ID',
			field: 'CleanItmId',
			saveCol: true,
			width: 100,
			hidden: true
		}, {
			title: '操作',
			field: 'Icon',
			width: 120,
			align: 'center',
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '';
				if (row.LevelFlag === '1') {
					str = '<div class="col-icon icon-emergency" href="#" title="紧急"></div>';
				}
				str = str + '<div class="col-icon icon-img" href="#" title="查看图片" onclick="ViewPic(' + row.PkgId + ')"></div>'
					+ '<div class="col-icon icon-paper-info" href="#" title="查看包明细" onclick="getpackageitem(' + row.PkgId + ')"></div>'
					+ '<div class="col-icon icon-gen-barcode" href="#" title="查看标签" onclick="getcleandtail(' + row.CleanItmId + ',' + row.PkgId + ')"></div>';
				return str;
			}
		}, {
			title: '打印',
			field: 'IsPrint',
			width: 50,
			styler: flagColor,
			formatter: BoolFormatter
		}, {
			title: '科室',
			field: 'LocDesc',
			width: 100
		}, {
			title: '消毒包Id',
			field: 'PkgId',
			width: 150,
			hidden: true
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 150,
			showTip: true,
			tipWidth: 200
		}, {
			title: '组合名称',
			field: 'ComposePkgDr',
			align: 'left',
			width: 90,
			hidden: true
		}, {
			title: '组合名称',
			field: 'ComposePkgName',
			align: 'left',
			width: 150,
			hidden: true
		}, {
			title: '标牌',
			field: 'CodeDict',
			align: 'left',
			width: 100
		}, {
			title: '标签',
			field: 'OprLabel',
			align: 'left',
			width: 100,
			hidden: true
		}, {
			title: '清洗数量',
			field: 'Qty',
			width: 80,
			align: 'right',
			hidden: false
		}, {
			title: '生成数量',
			field: 'CreatedQty',
			align: 'right',
			width: 80
		}, {
			title: '未生成数量',
			field: 'unCreatedQty',
			align: 'right',
			width: 80
		}, {
			title: '组合打包标志',
			field: 'ComposeFlag',
			align: 'right',
			width: 100,
			hidden: true
		}, {
			title: '灭菌方式Dr',
			field: 'SterTypeId',
			width: 100,
			hidden: true
		}, {
			title: '灭菌方式',
			field: 'SterTypeDesc',
			width: 100,
			hidden: true
		}, {
			title: '是否为低温灭菌方式',
			field: 'IsLowerSter',
			width: 100,
			hidden: true
		}, {
			title: '是否灭菌',
			field: 'IsSter',
			width: 100,
			hidden: true
		}, {
			title: '包装材料DR',
			field: 'MaterialId',
			width: 100,
			hidden: true
		}, {
			title: '紧急程度',
			field: 'LevelFlag',
			width: 80,
			hidden: true
		}, {
			title: '包属性',
			field: 'AttributeCode',
			width: 80,
			hidden: true
		}, {
			title: '包属性',
			field: 'AttributeDesc',
			align: 'left',
			width: 100
		}, {
			title: '外来器械',
			field: 'IsExt',
			width: 80
		}
	]];

	var ItmList = $UI.datagrid('#ItmList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
			QueryName: 'SelectAllLabel'
		},
		columns: ItmCm,
		pagination: false,
		sortName: 'CleanItmId',
		sortOrder: 'asc',
		singleSelect: false
	});
	
	function ClearUser() {
		$('#PackChkUser').combobox('setValue', '');
		$('#PackUser').combobox('setValue', '');
		$('#Packer').combobox('setValue', '');
	}

	function AdjustLayoutSize() {
		var EastWidth = '';
		if ($(window).width() * 0.45 >= 725) {
			EastWidth = $(window).width() * 0.45;
		} else {
			EastWidth = 725;
		}
		$('#Layout').layout('panel', 'east').panel('resize', { width: EastWidth });
		$('#Layout').layout();
	}
	window.onresize = function() {
		AdjustLayoutSize();
	};
	AdjustLayoutSize();
	Default();
	Query();
};
$(init);