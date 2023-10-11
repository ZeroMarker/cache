var init = function() {
	$('#Iscmt').val('1');
	var Params = JSON.stringify($UI.loopBlock('cleantable'));
	var ParamsTB = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	var GridListIndex = '';
	var GridListIndexId = '';
	
	var CleanLocParams = JSON.stringify(addSessionParams({ Type: 'Login', BDPHospital: gHospId }));
	$HUI.combobox('#CleanLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + CleanLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, SupLocId: record.RowId }));
			var Url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetMachineNoComBo&ResultSetType=array&type="washer"&Params=' + LocParams;
			$('#CleanMachine').combobox('reload', Url).combobox('clear');
		}
	});

	$HUI.combobox('#CleanMachine', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetMachineNoComBo&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'MachineNo',
		onSelect: function(record) {
		},
		onBeforeLoad: function(param) {
			param.type = 'washer';
			var SupLocId = $('#CleanLoc').combobox('getValue');
			param.Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId, SupLocId: SupLocId }));
		}
	});

	$('#CleanMachine').combobox('textbox').keyup(function(event) {
		if (event.which === 13) {
			var MachineVal = $('#CleanMachine').combobox('getText');
			if (isEmpty(MachineVal)) {
				$UI.msg('alert', '请录入清洗机！');
				return;
			}
			var SupLocId = $('#CleanLoc').combobox('getValue');
			var MachineParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, SupLocId: SupLocId }));
			var MachineObj = $.cm({
				ClassName: 'web.CSSDHUI.Common.Dicts',
				MethodName: 'GetMachineNo',
				Type: 'washer',
				MachineNo: MachineVal,
				Params: MachineParams
			}, false);
			var MachineId = MachineObj['ID'];
			if (isEmpty(MachineId)) {
				$UI.msg('alert', '请录入可用的清洗机!');
				$('#CleanMachine').combobox('setValue', '');
				$('#CleanMachine').combobox('textbox').focus();
				return;
			}
			$('#CleanMachine').combobox('setValue', MachineId);
		}
	});
	
	$HUI.combobox('#CleanType', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCleanType&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'Code',
		onBeforeLoad: function(param) {
			param.Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
		}
	});
	
	$('#CleanType').combobox('textbox').keyup(function(event) {
		var curKey = event.which;
		if (curKey === 13) {
			var CleanTypeVal = $('#CleanType').combobox('getText');
			if (isEmpty(CleanTypeVal)) {
				$UI.msg('alert', '请录入清洗方式!');
				return;
			}
			var TypeParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
			var CleanTypeObj = $.cm({
				ClassName: 'web.CSSDHUI.Clean.CleanInfo',
				MethodName: 'GetCleanType',
				CleanCode: CleanTypeVal,
				Params: TypeParams
			}, false);
			var CleanTypeId = CleanTypeObj['CleanTypeId'];
			if (isEmpty(CleanTypeId)) {
				$UI.msg('alert', '请录入可用的清洗方式!');
				$('#CleanType').combobox('setText', '');
				$('#CleanType').combobox('textbox').focus();
				return;
			}
			$('#CleanType').combobox('setValue', CleanTypeId);
		}
	});
	
	// 不合格原因下拉框
	$HUI.combobox('#UnqualifiedReason', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCleanReason&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var ReasonComData = $.cm({
		ClassName: 'web.CSSDHUI.Common.Dicts',
		QueryName: 'GetCleanReason',
		ResultSetType: 'array'
	}, false);

	var ReasonCombox = {
		type: 'combobox',
		options: {
			data: ReasonComData,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = GridList.getRows();
				var row = rows[GridList.editIndex];
				row.ReasonDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	
	$HUI.combobox('#Checker', {
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
	// 验收人回车
	$('#Checker').combobox('textbox').keyup(function(event) {
		if (event.keyCode === 13) {
			var userCode = $('#Checker').combobox('getText');
			if (userCode !== '') {
				var UserObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetUserByCodeJson',
					userCode: userCode,
					Params: ParamsTB
				}, false);
				if (UserObj['RowId'] === '') {
					$UI.msg('alert', '未获取到清洗人相关信息！');
					$('#Checker').val('');
					$('#Checker').focus();
					return;
				}
				$('#Checker').combobox('setValue', UserObj['RowId']);
			} else {
				if (CleanParamObj.IsGetCleanCheckUserByLogin === 'Y') {
					$('#Checker').combobox('setValue', gUserId);
				} else {
					$UI.msg('alert', '请录入验收人!');
					$('#Checker').combobox('setValue', '');
					$('#Checker').combobox('textbox').focus();
					return;
				}
			}
		}
	});

	$UI.linkbutton('#Check', {
		onClick: function() {
			var Rows = GridList.getSelected();
			if (isEmpty(Rows)) {
				$UI.msg('alert', '请选择需要验收的记录！');
				return;
			}
			var ParamsObj = $UI.loopBlock('cleantable');
			ParamsObj.ID = Rows.ID;
			if (Rows.IsResult) {
				$UI.msg('alert', '已经验收数据不能重复验收！');
				return;
			}
			if (ItemListGrid.getRows() === '') {
				$UI.msg('alert', '没有明细不能进行验收！');
				return;
			}
			GridListIndex = GridList.getRowIndex(Rows);
			GridListIndexId = Rows.ID;
			$UI.confirm('您确定要执行操作吗？', '', '', CheckPass, '', '', '', '', ParamsObj);
		}
	});

	function CheckPass(ParamsObj) {
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			MethodName: 'CleanCheck',
			Params: JSON.stringify(ParamsObj)
		},
		function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				GridList.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	// 验收不合格
	$UI.linkbutton('#CheckNPass', {
		onClick: function() {
			var Rows = GridList.getSelected();
			if (isEmpty(Rows)) {
				$UI.msg('alert', '请选择需要验收的记录！');
				return;
			}
			if (Rows.IsResult) {
				$UI.msg('alert', '已经验收数据不能重复验收！');
				return;
			}
			var ParamsObj = $UI.loopBlock('cleantable');
			ParamsObj.ID = Rows.ID;
			var ReasonDr = ParamsObj.UnqualifiedReason;
			if (isEmpty(ReasonDr)) {
				$UI.msg('alert', '不合格原因不能为空！');
				$('#UnqualifiedReason').combobox('textbox').focus();
				return;
			}
			GridListIndex = GridList.getRowIndex(Rows);
			GridListIndexId = Rows.ID;
			$UI.confirm('您确定要执行操作吗？', '', '', CheckNPass, '', '', '', '', ParamsObj);
		}
	});
	
	function CheckNPass(ParamsObj) {
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			MethodName: 'jsCleanCheckNPass',
			Params: JSON.stringify(ParamsObj)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				$('#UnqualifiedReason').combobox('setValue', '');
				GridList.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$UI.linkbutton('#CancelBT', {
		onClick: function() {
			var Rows = GridList.getSelected();
			if (isEmpty(Rows)) {
				$UI.msg('alert', '请选择需要取消验收的记录！');
				return;
			}
			if (isEmpty(Rows.IsResult)) {
				$UI.msg('alert', '未验收数据，不能取消验收！');
				return;
			}
			var ParamsObj = $UI.loopBlock('cleantable');
			ParamsObj.ID = Rows.ID;
			GridListIndex = GridList.getRowIndex(Rows);
			GridListIndexId = Rows.ID;
			$UI.confirm('您确定要执行取消验收操作吗？', '', '', CleanCheckCancel, '', '', '', '', ParamsObj);
		}
	});
	
	function CleanCheckCancel(ParamsObj) {
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			MethodName: 'jsCleanCheckCancel',
			Params: JSON.stringify(ParamsObj)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				GridList.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	// 单个明细验收不合格
	function CheckFailBT() {
		ItemListGrid.endEditing();
		var Rows = GridList.getSelected();
		if (isEmpty(Rows)) {
			$UI.msg('alert', '请选择需要验收的记录！');
			return;
		}
		if (Rows.IsResult) {
			$UI.msg('alert', '已经验收数据不能重复验收！');
			return;
		}
		var ParamsObj = $UI.loopBlock('cleantable');
		ParamsObj.ID = Rows.ID;
		var ReasonId = ParamsObj.UnqualifiedReason;
		if (isEmpty(ReasonId)) {
			$UI.msg('alert', '不合格原因不能为空！');
			$('#UnqualifiedReason').combobox('textbox').focus();
			return;
		}
		GridListIndex = GridList.getRowIndex(Rows);
		GridListIndexId = Rows.ID;
		var Details = ItemListGrid.getChecked();
		if (isEmpty(Details)) {
			$UI.msg('alert', '请选择清洗不合格的明细信息！');
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			MethodName: 'jsCleanCheckNPass',
			Params: JSON.stringify(ParamsObj),
			Details: JSON.stringify(Details)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success >= 0) {
				$('#UnqualifiedReason').combobox('setValue', '');
				$UI.msg('success', jsonData.msg);
				GridList.commonReload();
			} else {
				$('#UnqualifiedReason').combobox('setValue', '');
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	// 外来器械二次消毒
	function ExtSterlize() {
		var Details = ItemListGrid.getChecked();
		if (isEmpty(Details)) {
			$UI.msg('alert', '请选择数据！');
			return;
		}
		var Flag = false;
		$.each(Details, function(index, item) {
			if (item.PkgFlag !== 'Y') {
				Flag = true;
			}
		});
		if (Flag) {
			$UI.msg('alert', '存在状态不是二次清洗的包,不能进行高水平消毒！');
			return;
		}
		$UI.confirm('您确定要执行外来器械移交前消毒？', '', '', IsExtSterlize, '', '', '', '', Details);
	}
	function IsExtSterlize(Details) {
		var MainRow = GridList.getSelected();
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			MethodName: 'jsExtSterlize',
			Params: JSON.stringify(addSessionParams({ ID: MainRow.ID })),
			Details: JSON.stringify(Details)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success >= 0) {
				$UI.msg('success', jsonData.msg);
				ItemListGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$UI.linkbutton('#Query', {
		onClick: function() {
			if (isEmpty($('#CleanLoc').combobox('getValue'))) {
				$UI.msg('alert', '科室不能为空！');
				return;
			} else {
				Query();
			}
		}
	});
	
	function Query() {
		$UI.clear(ItemListGrid);
		GridListIndex = '';
		var MainParams = JSON.stringify($UI.loopBlock('cleantable'));
		GridList.load({
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			QueryName: 'SelectAllCleanCheck',
			Params: MainParams
		});
	}

	function packageFlagColor(val, row, index) {
		if (val === 'SS') {
			return 'color:white;background:' + GetColorCode('green');
		} else if (val === 'Y') {
			return 'color:white;background:' + GetColorCode('red');
		}
	}
	
	$UI.linkbutton('#FileMatchBT', {
		onClick: function() {
			var Row = GridList.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选操作数据！');
				return;
			}
			var Obj = $UI.loopBlock('#cleantable');
			if (isEmpty(Obj.FileSel)) {
				$UI.msg('alert', '请选择要匹配的文件！');
				return;
			}
			var RowId = Row.ID;
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
					var FileParams = JSON.stringify(addSessionParams({ RowId: RowId, FileName: SelFileName, Type: 'washer' }));
					if (isEmpty(Row.MachineFileName)) {
						ReFileMatch(FileParams);
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
		var FileMatchParams = JSON.stringify(addSessionParams({ RowIdStr: RowId, Type: 'washer' }));
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.MachineData.DataDeal',
			MethodName: 'jsFileMatch',
			Params: FileMatchParams
		}, function(jsonData) {
			hideMask();
			$UI.msg('alert', jsonData.msg);
			Query();
		});
	}
	
	function ReFileMatch(FileParams) {
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.MachineData.DataDeal',
			MethodName: 'jsReFileMatch',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
			$('#FileSel').filebox('clear');
		});
	}

	$UI.linkbutton('#ViewPicBT', {
		onClick: function() {
			var Row = GridList.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择清洗记录！');
				return;
			}
			var RowId = Row.ID;
			ViewPic('Clean', RowId);
		}
	});

	// 拍照
	$UI.linkbutton('#TakePhotoBT', {
		onClick: function() {
			var Row = GridList.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择清洗记录！');
				return;
			}
			var RowId = Row.ID;
			TakePhotoWin('Clean', RowId);
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			SetDefault();
		}
	});

	function flagColor(val, row, index) {
		if (val === '1') {
			return 'color:white;background:' + GetColorCode('green');
		} else if (val === '0') {
			return 'color:white;background:' + GetColorCode('red');
		} else {
			return 'color:white;background:' + GetColorCode('yellow');
		}
	}

	var Cm = [[
		{
			field: 'Operate',
			title: '标识',
			align: 'center',
			width: 70,
			formatter: function(value, row, index) {
				var str = '';
				if (row.LevelFlag === '1') {
					str = '<div class="col-icon icon-emergency" href="#" title="紧急"></div>';
				}
				if (row.BeInfected === 'Y') {
					str = str + '<div href="#" class="icon-virus col-icon" title="感染"></div>';
				}
				return str;
			}
		}, {
			title: '验收标记',
			field: 'IsResult',
			width: 70,
			align: 'center',
			styler: flagColor,
			formatter: function(value) {
				var status = '';
				if (value === '1') {
					status = '合格';
				} else if (value === '0') {
					status = '不合格';
				} else {
					status = '未验收';
				}
				return status;
			}
		}, {
			title: '清洗科室',
			field: 'CleanLoc',
			width: 100
		}, {
			title: 'ID',
			field: 'ID',
			width: 50,
			hidden: true
		}, {
			title: '清洗机',
			field: 'MachineNo',
			align: 'center',
			width: 60
		}, {
			title: '清洗批号',
			field: 'CleanNum',
			width: 150
		}, {
			title: '清洗时间',
			field: 'CleanDate',
			width: 160
		}, {
			title: '时间',
			field: 'CleanTime',
			width: 70,
			hidden: true
		}, {
			title: '清洗人',
			field: 'CleanerName',
			width: 60
		}, {
			title: '清洗方式',
			field: 'CleanType',
			width: 100
		}, {
			title: '清洗程序',
			field: 'CleanPro',
			width: 100
		}, {
			title: '验收时间',
			field: 'CheckDateTime',
			width: 160
		}, {
			title: '验收人',
			field: 'ChkerName',
			width: 100
		}, {
			title: '紧急状态',
			field: 'LevelFlag',
			width: 50,
			hidden: true
		}, {
			title: '机器存储文件',
			field: 'MachineFileName',
			align: 'center',
			width: 160
		}]];
	var GridList = $UI.datagrid('#tabDrugList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			QueryName: 'SelectAllCleanCheck',
			Params: Params
		},
		columns: Cm,
		sortName: 'ID',
		sortOrder: 'desc',
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				if (!isEmpty(GridListIndex)) {
					$('#tabDrugList').datagrid('selectRow', GridListIndex);
				} else if (CommParObj.SelectFirstRow == 'Y') {
					$('#tabDrugList').datagrid('selectRow', 0);
				}
			}
		},
		onSelect: function(index, rowData) {
			var Id = rowData.ID;
			if (!isEmpty(Id)) {
				FindItemByF(Id);
			}
		},
		onClickRow: function(index, row) {
			GridList.commonClickRow(index, row);
		},
		onDblClickRow: function(index, row) {
			var Row = GridList.getRows()[index];
			var RowId = Row.ID;
			if (!isEmpty(RowId)) {
				SterChart('washer', RowId, gHospId);
			}
		}
	});

	function FindItemByF(Id) {
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			QueryName: 'SelectCleanDetail',
			Params: Id,
			rows: 9999
		});
	}
	
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
			field: 'Operate',
			title: '标识',
			align: 'center',
			width: 70,
			formatter: function(value, row, index) {
				var str = '';
				if (row.LevelFlag === '1') {
					str = '<div class="col-icon icon-emergency" href="#" title="紧急"></div>';
				}
				if (row.BeInfected === 'Y') {
					str = str + '<div href="#" class="icon-virus col-icon" title="感染"></div>';
				}
				return str;
			}
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 140
		}, {
			title: '标牌',
			field: 'CodeDictId',
			width: 100
		}, {
			title: '清洗总数',
			field: 'TotalQty',
			align: 'right',
			width: 100
		}, {
			title: '消毒包数',
			field: 'Qty',
			align: 'right',
			width: 100
		}, {
			title: '不合格总数',
			field: 'UnPassQty',
			align: 'right',
			width: 100
		}, {
			title: '不合格数量',
			field: 'UnPassQtyEdit',
			align: 'right',
			width: 100,
			editor: { type: 'numberbox' }
		}, {
			title: '不合格原因',
			field: 'ReasonId',
			width: 179,
			formatter: CommonFormatter(ReasonCombox, 'ReasonId', 'ReasonDesc')
		}, {
			title: '清洗状态',
			field: 'PkgFlag',
			width: 80,
			styler: packageFlagColor,
			formatter: function(value) {
				var status = '';
				if (value === 'SS') {
					status = '高水平消毒';
				} else if (value === 'Y') {
					status = '二次清洗';
				} else {
					status = '常规清洗';
				}
				return status;
			}
		}, {
			title: '申请单',
			field: 'ApplyNo',
			width: 120
		}, {
			title: '科室',
			field: 'BackLocDesc',
			width: 100
		}, {
			title: '是否验收',
			field: 'IsResult',
			width: 100,
			hidden: true
		}, {
			title: '紧急程度',
			field: 'LevelFlag',
			width: 80,
			hidden: true
		}, {
			title: '感染标志',
			field: 'BeInfected',
			width: 80,
			hidden: true
		}
	]];
	var ItemListGrid = $UI.datagrid('#ItemList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			MethodName: 'SelectCleanDetail'
		},
		columns: ItemCm,
		pagination: false,
		singleSelect: false,
		selectOnCheck: true,
		sortName: 'RowId',
		sortOrder: 'asc',
		toolbar: [
			{
				text: '验收不合格',
				iconCls: 'icon-no',
				handler: function() {
					CheckFailBT();
				}
			}, {
				text: '高水平消毒',
				iconCls: 'icon-ster-again',
				handler: function() {
					ExtSterlize();
				}
			}
		],
		onClickRow: function(index, row) {
			ItemListGrid.commonClickRow(index, row);
		},
		onBeforeEdit: function() {
			var rowMain = $('#tabDrugList').datagrid('getSelected');
			if (rowMain.IsResult !== '') return false;
		}
	});
	
	function SetDefault() {
		$UI.clearBlock('#cleantable');
		$UI.clear(GridList);
		$UI.clear(ItemListGrid);
		$('#FileSel').filebox('clear');
		var Default = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			CleanLoc: gLocId
		};
		$UI.fillBlock('#cleantable', Default);
	}
	function AdjLayoutSize() {
		var EastWidth = $(window).width() * 0.4;
		$('#Layout').layout('panel', 'east').panel('resize', { width: EastWidth });
		$('#Layout').layout();
	}
	window.onresize = function() {
		AdjLayoutSize();
	};
	AdjLayoutSize();
	SetDefault();
	Query();
};

$(init);