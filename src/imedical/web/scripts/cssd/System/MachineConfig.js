// 机器设置
var init = function() {
	var HospId = gHospId;
	var TableName = 'CSSD_MachineConfig';
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				Query();
			};
		}
		Query();
	}

	$HUI.tabs('#DetailTabs', {
		onSelect: function(title, index) {
			if (title === '灭菌器') {
				Query('sterilizer');
			} else if (title === '清洗机') {
				Query('washer');
			}
		}
	});

	// 灭菌方式
	var SterTypeCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterType&ResultSetType=array&isSter=Y',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = SterMachineGrid.getRows();
				var row = rows[SterMachineGrid.editIndex];
				row.TempTypeDesc = record.Description;
			},
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			}
		}
	};
	// 清洗方式
	var CleanTypeCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCleanType&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = CleanMachineGrid.getRows();
				var row = rows[CleanMachineGrid.editIndex];
				row.TempTypeDesc = record.Description;
			},
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ BDPHospital: HospId, IsManual: 'Y' }));
			}
		}
	};
	var SterSupLocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ Type: 'SupLoc' })),
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = SterMachineGrid.getRows();
				var row = rows[SterMachineGrid.editIndex];
				row.SupLocDesc = record.Description;
			}
		}
	};
	var CleanSupLocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ Type: 'SupLoc' })),
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = CleanMachineGrid.getRows();
				var row = rows[CleanMachineGrid.editIndex];
				row.SupLocDesc = record.Description;
			}
		}
	};
	// 灭菌架
	var SterCarBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllSterCar&ResultSetType=array&PackTypeDetail=' + 6,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = SterMachineGrid.getRows();
				var row = rows[SterMachineGrid.editIndex];
				row.SterCarName = record.Description;
			},
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			}
		}
	};
	// 厂商（不区分机器类型）
	var SterManfBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetFirm&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ BDPHospital: HospId, MachineType: 'SW' }));
			},
			onSelect: function(record) {
				var rows = SterMachineGrid.getRows();
				var row = rows[SterMachineGrid.editIndex];
				row.ManufactureDesc = record.Description;
			}
		}
	};
	var CleanManfBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetFirm&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			},
			onSelect: function(record) {
				var rows = CleanMachineGrid.getRows();
				var row = rows[CleanMachineGrid.editIndex];
				row.ManufactureDesc = record.Description;
			}
		}
	};
	// 灭菌器机器型号
	var SterModelBox = {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			onShowPanel: function() {
				$(this).combobox('loadData', SterilizerData);
			}
		}
	};
	// 清洗机机器型号
	var CleanModelBox = {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			onShowPanel: function() {
				$(this).combobox('loadData', WasherData);
			}
		}
	};
	// 测漏
	var LeakCombox = {
		type: 'combobox',
		options: {
			data: LeakData,
			valueField: 'RowId',
			textField: 'Description'
		}
	};

	var BioPeriodCombox = {
		type: 'combobox',
		options: {
			data: PeriodData,
			valueField: 'RowId',
			textField: 'Description'
		}
	};

	var Query = function(Tab) {
		var Params;
		Tab = Tab || 'sterilizer';		// 默认查询灭菌器
		if (Tab === 'sterilizer') {
			Params = JSON.stringify(addSessionParams({ BDPHospital: HospId, MachineType: 'sterilizer' }));
			SterMachineGrid.load({
				ClassName: 'web.CSSDHUI.System.MachineConfig',
				QueryName: 'QueryMachineInfo',
				Params: Params
			});
		} else if (Tab === 'washer') {
			Params = JSON.stringify(addSessionParams({ BDPHospital: HospId, MachineType: 'washer' }));
			CleanMachineGrid.load({
				ClassName: 'web.CSSDHUI.System.MachineConfig',
				QueryName: 'QueryMachineInfo',
				Params: Params
			});
		}
	};

	// 打印机器条码
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var rowMain = $('#SterMachineGrid').datagrid('getSelected');
			if (!isEmpty(rowMain)) {
				var Code = rowMain.MachineNum;
				var Description = rowMain.Alias;
				printCodeDict(Code, Description);
			}
		}
	});

	var SterMachineGrid = $UI.datagrid('#SterMachineGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.MachineConfig',
			QueryName: 'QueryMachineInfo'
		},
		beforeDelFn: function() {
			var rowMachine = $('#SterMachineGrid').datagrid('getSelected');
			if (!isEmpty(rowMachine) && !isEmpty(rowMachine.RowId)) {
				$UI.msg('alert', '已维护机器数据只能停用,不能删除');
			}
			return false;
		},
		beforeAddFn: function() {
			var DefaultData = { NotUseFlag: 'Y' };
			return DefaultData;
		},
		toolbar: [
			{
				text: '打印',
				iconCls: 'icon-print',
				handler: function() {
					var rowMain = $('#SterMachineGrid').datagrid('getSelected');
					if (!isEmpty(rowMain)) {
						var Code = rowMain.MachineNum;
						var Description = rowMain.Alias;
						printCodeDict(Code, Description);
					}
				}
			}, {
				text: '刷新',
				iconCls: 'icon-reload',
				handler: function() {
					Query('sterilizer');
				}
			}
		],
		saveDataFn: function() {
			var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId, MachineType: 'sterilizer' }));
			var Rows = SterMachineGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows === false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			showMask();
			$.cm({
				ClassName: 'web.CSSDHUI.System.MachineConfig',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows),
				Others: Others
			}, function(jsonData) {
				hideMask();
				if (jsonData.success === 0) {
					$UI.msg('success', '保存成功！');
					SterMachineGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		columns: [[
			{
				title: 'RowId',
				field: 'RowId',
				width: 60,
				hidden: true
			}, {
				title: '代码',
				align: 'center',
				field: 'MachineNum',
				width: 50,
				editor: { type: 'numberbox', options: { required: true, min: 1, max: 99 }}
			}, {
				title: '名称',
				field: 'Alias',
				width: 100,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '灭菌方式',
				align: 'left',
				field: 'TempType',
				width: 100,
				formatter: CommonFormatter(SterTypeCombox, 'TempType', 'TempTypeDesc'),
				editor: SterTypeCombox
			}, {
				title: '供应科室',
				field: 'SupLocId',
				width: 120,
				formatter: CommonFormatter(SterSupLocCombox, 'SupLocId', 'SupLocDesc'),
				editor: SterSupLocCombox
			}, {
				title: '灭菌架',
				align: 'left',
				field: 'SterCar',
				width: 100,
				formatter: CommonFormatter(SterCarBox, 'SterCar', 'SterCarName'),
				editor: SterCarBox
			}, {
				title: '装载数量',
				field: 'LoadNum',
				align: 'right',
				width: 80,
				editor: { type: 'numberbox', options: { min: 1 }}
			}, {
				title: '厂商',
				field: 'Manufacture',
				width: 150,
				formatter: CommonFormatter(SterManfBox, 'Manufacture', 'ManufactureDesc'),
				editor: SterManfBox
			}, {
				title: '机器型号',
				field: 'Model',
				width: 130,
				formatter: CommonFormatter(SterModelBox, 'Model', 'Model'),
				editor: SterModelBox
			}, {
				title: '文件前缀',
				field: 'FileNamePrefix',
				width: 80,
				editor: { type: 'validatebox', options: {}}
			}, {
				title: '测漏',
				align: 'center',
				field: 'IsLeak',
				width: 80,
				editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
				formatter: BoolFormatter,
				hidden: true
			}, {
				title: '测漏周期',
				align: 'center',
				field: 'LeakTime',
				width: 80,
				formatter: CommonFormatter(LeakCombox, 'LeakTime', 'LeakTimeDesc'),
				editor: LeakCombox
			}, {
				title: 'BD测试',
				align: 'center',
				field: 'IsBd',
				width: 80,
				editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
				formatter: BoolFormatter
			}, {
				title: '生物监测周期',
				align: 'center',
				field: 'BioTime',
				width: 110,
				formatter: CommonFormatter(BioPeriodCombox, 'BioTime', 'BioTimeDesc'),
				editor: BioPeriodCombox
			}, {
				title: '启用',
				align: 'center',
				field: 'NotUseFlag',
				width: 80,
				editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
				formatter: BoolFormatter
			}, {
				title: '扩展类型',
				field: 'ExtType',
				width: 80,
				hidden: true,
				editor: { type: 'validatebox', options: {}}
			}
		]],
		showAddSaveItems: true,
		pagination: false,
		remoteSort: false,
		fitColumns: true,
		onClickRow: function(index, row) {
			SterMachineGrid.commonClickRow(index, row);
		}
	});

	var CleanMachineGrid = $UI.datagrid('#CleanMachineGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.MachineConfig',
			QueryName: 'QueryMachineInfo'
		},
		beforeDelFn: function() {
			var rowMachine = $('#CleanMachineGrid').datagrid('getSelected');
			if (!isEmpty(rowMachine) && !isEmpty(rowMachine.RowId)) {
				$UI.msg('alert', '已维护机器数据只能停用,不能删除');
			}
			return false;
		},
		beforeAddFn: function() {
			var DefaultData = { NotUseFlag: 'Y' };
			return DefaultData;
		},
		toolbar: [
			{
				text: '打印',
				iconCls: 'icon-print',
				handler: function() {
					var rowMain = $('#CleanMachineGrid').datagrid('getSelected');
					if (!isEmpty(rowMain)) {
						var Code = rowMain.MachineNum;
						var Description = rowMain.Alias;
						printCodeDict(Code, Description);
					}
				}
			}, {
				text: '刷新',
				iconCls: 'icon-reload',
				handler: function() {
					Query('washer');
				}
			}
		],
		saveDataFn: function() {
			var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId, MachineType: 'washer' }));
			var Rows = CleanMachineGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows === false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			showMask();
			$.cm({
				ClassName: 'web.CSSDHUI.System.MachineConfig',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows),
				Others: Others
			}, function(jsonData) {
				hideMask();
				if (jsonData.success === 0) {
					$UI.msg('success', '保存成功！');
					CleanMachineGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		columns: [[
			{
				title: 'RowId',
				field: 'RowId',
				width: 60,
				hidden: true
			}, {
				title: '代码',
				align: 'center',
				field: 'MachineNum',
				width: 50,
				editor: { type: 'numberbox', options: { required: true, min: 1, max: 99 }}
			}, {
				title: '名称',
				field: 'Alias',
				width: 100,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '清洗方式',
				align: 'left',
				field: 'TempType',
				width: 100,
				formatter: CommonFormatter(CleanTypeCombox, 'TempType', 'TempTypeDesc'),
				editor: CleanTypeCombox
			}, {
				title: '供应科室',
				field: 'SupLocId',
				width: 120,
				formatter: CommonFormatter(CleanSupLocCombox, 'SupLocId', 'SupLocDesc'),
				editor: CleanSupLocCombox
			}, {
				title: '厂商',
				field: 'Manufacture',
				width: 150,
				formatter: CommonFormatter(CleanManfBox, 'Manufacture', 'ManufactureDesc'),
				editor: CleanManfBox
			}, {
				title: '机器型号',
				field: 'Model',
				width: 150,
				formatter: CommonFormatter(CleanModelBox, 'Model', 'Model'),
				editor: CleanModelBox
			}, {
				title: '文件前缀',
				field: 'FileNamePrefix',
				width: 80,
				editor: { type: 'validatebox', options: {}}
			}, {
				title: '多仓',
				align: 'center',
				field: 'MulBinFlag',
				width: 80,
				editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
				formatter: BoolFormatter
			}, {
				title: '启用',
				align: 'center',
				field: 'NotUseFlag',
				width: 80,
				editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
				formatter: BoolFormatter
			}, {
				title: '扩展类型',
				field: 'ExtType',
				width: 80,
				hidden: true,
				editor: { type: 'validatebox', options: {}}
			}
		]],
		showAddSaveItems: true,
		pagination: false,
		remoteSort: false,
		fitColumns: true,
		onClickRow: function(index, row) {
			CleanMachineGrid.commonClickRow(index, row);
		}
	});
	InitHosp();
};
$(init);