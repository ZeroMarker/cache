// 消毒供应中心包装质量日常监测存在的问题记录js
var init = function() {
	var Query = function() {
		$UI.clear(DailySurveyGrid);
		var Params = JSON.stringify($UI.loopBlock('DailySurveyTB'));
		DailySurveyGrid.load({
			ClassName: 'web.CSSDHUI.System.DailySurvey',
			QueryName: 'SelectAll',
			Params: Params
		});
	};
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clear(DailySurveyGrid);
		}
	});
	
	setDefault();
	
	// 设置默认值
	function setDefault() {
		var Default = {
			FStartDate: DateFormatter(new Date()),
			FEndDate: DateFormatter(new Date())
		};
		$UI.fillBlock('#DailySurveyTB', Default);
	}
	
	// 消毒包下拉列表
	var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TypeDetail: '1,2,7' }));
	var PkgData = $.cm({
		ClassName: 'web.CSSDHUI.Common.Dicts',
		QueryName: 'GetPkg',
		ResultSetType: 'array',
		Params: PkgParams
	}, false);
	
	var PkgBox = {
		type: 'combobox',
		options: {
			data: PkgData,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = DailySurveyGrid.getRows();
				var row = rows[DailySurveyGrid.editIndex];
				row.PkgDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	
	var UserParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	var UserCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + UserParams,
			valueField: 'RowId',
			textField: 'Description',
			required: false,
			onSelect: function(record) {
				var rows = DailySurveyGrid.getRows();
				var row = rows[DailySurveyGrid.editIndex];
				row.PackUserName = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	
	// /包装材料下拉数据
	var MaterialsBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetMaterials&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: false,
			onSelect: function(record) {
				var rows = DailySurveyGrid.getRows();
				var row = rows[DailySurveyGrid.editIndex];
				row.MaterialDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	
	var PackCheckBox = {
		type: 'combobox',
		options: {
			data: PackCheckData,
			required: true,
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	
	var PropertyBox = {
		type: 'combobox',
		options: {
			data: PropertyData,
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	
	var CheckMaterialBox = {
		type: 'combobox',
		options: {
			data: CheckMaterialData,
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	
	var PreciseProtectBox = {
		type: 'combobox',
		options: {
			data: PreciseProtectData,
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	
	var CardoProtectBox = {
		type: 'combobox',
		options: {
			data: CardoProtectData,
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	
	var CheCardBox = {
		type: 'combobox',
		options: {
			data: CheCardData,
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	
	var WidthBox = {
		type: 'combobox',
		options: {
			data: WidthData,
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	
	var DistanceBox = {
		type: 'combobox',
		options: {
			data: DistanceData,
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	
	var TapeTooShortBox = {
		type: 'combobox',
		options: {
			data: TapeTooShortData,
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	
	var IncompleteCloseBox = {
		type: 'combobox',
		options: {
			data: IncompleteCloseData,
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	
	var SixMarksBox = {
		type: 'combobox',
		options: {
			data: SixMarksData,
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	
	var VolumeBox = {
		type: 'combobox',
		options: {
			data: VolumeData,
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	var WeightInstrusBox = {
		type: 'combobox',
		options: {
			data: WeightInstrusData,
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	
	// /消毒包分类
	var PkgClassCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackageClass&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = DailySurveyGrid.getRows();
				var row = rows[DailySurveyGrid.editIndex];
				row.PkgClassDesc = record.Description;
			},
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
			}
		}
	};
	
	// /包装材料下拉数据
	var SpecBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackageSpec&ResultSetType=array&Params=' + UserParams,
			valueField: 'RowId',
			textField: 'Description',
			required: false,
			onSelect: function(record) {
				var rows = DailySurveyGrid.getRows();
				var row = rows[DailySurveyGrid.editIndex];
				row.SpecDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	
	var DailySurveyCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			align: 'left',
			width: 100,
			hidden: true
		}, {
			title: '监测日期',
			field: 'DailyDate',
			align: 'left',
			width: 120,
			sortable: true,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '消毒包',
			field: 'PkgId',
			align: 'left',
			width: 140,
			sortable: true,
			formatter: CommonFormatter(PkgBox, 'PkgId', 'PkgDesc'),
			editor: PkgBox
		}, {
			title: '消毒包分类',
			field: 'PkgClassId',
			align: 'left',
			width: 120,
			sortable: true,
			formatter: CommonFormatter(PkgClassCombox, 'PkgClassId', 'PkgClassDesc'),
			editor: PkgClassCombox
		}, {
			title: '规格',
			field: 'SpecId',
			align: 'left',
			width: 80,
			sortable: true,
			formatter: CommonFormatter(SpecBox, 'SpecId', 'SpecDesc'),
			editor: SpecBox
		}, {
			title: '包装质量',
			field: 'PackCheckId',
			align: 'left',
			width: 100,
			sortable: true,
			formatter: CommonFormatter(PackCheckBox, 'PackPackCheckIdCheck', 'PackCheckDesc'),
			editor: PackCheckBox
		}, {
			title: '数量',
			field: 'Qty',
			align: 'left',
			width: 80,
			sortable: true,
			editor: { type: 'validatebox' }
		}, {
			title: '包装材料选择',
			field: 'MaterialId',
			align: 'left',
			width: 100,
			sortable: true,
			formatter: CommonFormatter(MaterialsBox, 'MaterialId', 'MaterialDesc'),
			editor: MaterialsBox
		}, {
			title: '性能',
			field: 'PropertyId',
			align: 'left',
			width: 80,
			sortable: true,
			formatter: CommonFormatter(PropertyBox, 'PropertyId', 'PropertyDesc'),
			editor: PropertyBox
		}, {
			title: '包装材料检查',
			field: 'CheckMaterialId',
			align: 'left',
			width: 100,
			sortable: true,
			formatter: CommonFormatter(CheckMaterialBox, 'CheckMaterialId', 'CheckMaterialDesc'),
			editor: CheckMaterialBox
		}, {
			title: '精密锐利器械保护',
			field: 'PreciseProtectId',
			align: 'left',
			width: 130,
			sortable: true,
			formatter: CommonFormatter(PreciseProtectBox, 'PreciseProtectId', 'PreciseProtectDesc'),
			editor: PreciseProtectBox
		}, {
			title: '轴节器械保护',
			field: 'CardoProtectId',
			align: 'left',
			width: 100,
			sortable: true,
			formatter: CommonFormatter(CardoProtectBox, 'CardoProtectId', 'CardoProtectDesc'),
			editor: CardoProtectBox
		}, {
			title: '包内化学指示卡',
			field: 'CheCardId',
			align: 'left',
			width: 120,
			sortable: true,
			formatter: CommonFormatter(CheCardBox, 'CheCardId', 'CheCardDesc'),
			editor: CheCardBox
		}, {
			title: '密封宽度',
			field: 'WidthId',
			align: 'left',
			width: 100,
			sortable: true,
			formatter: CommonFormatter(WidthBox, 'WidthId', 'WidthDesc'),
			editor: WidthBox
		}, {
			title: '密封距离',
			field: 'DistanceId',
			align: 'left',
			width: 100,
			sortable: true,
			formatter: CommonFormatter(DistanceBox, 'DistanceId', 'DistanceDesc'),
			editor: DistanceBox
		}, {
			title: '闭合胶带',
			field: 'TapeTooShortId',
			align: 'left',
			width: 100,
			sortable: true,
			formatter: CommonFormatter(TapeTooShortBox, 'TapeTooShortId', 'TapeTooShortDesc'),
			editor: TapeTooShortBox
		}, {
			title: '闭合性',
			field: 'IncompleteCloseId',
			align: 'left',
			width: 100,
			sortable: true,
			formatter: CommonFormatter(IncompleteCloseBox, 'IncompleteCloseId', 'IncompleteCloseDesc'),
			editor: IncompleteCloseBox
		}, {
			title: '六项标识',
			field: 'SixMarksId',
			align: 'left',
			width: 100,
			sortable: true,
			formatter: CommonFormatter(SixMarksBox, 'SixMarksId', 'SixMarksDesc'),
			editor: SixMarksBox
		}, {
			title: '体积',
			field: 'VolumeId',
			align: 'left',
			width: 80,
			sortable: true,
			formatter: CommonFormatter(VolumeBox, 'VolumeId', 'VolumeDesc'),
			editor: VolumeBox
		}, {
			title: '器械包重量',
			field: 'WeightInstrusId',
			align: 'left',
			width: 100,
			sortable: true,
			formatter: CommonFormatter(WeightInstrusBox, 'WeightInstrusId', 'WeightInstrusDesc'),
			editor: WeightInstrusBox
		}, {
			title: '包装人',
			field: 'PackUserId',
			align: 'left',
			width: 80,
			sortable: true,
			formatter: CommonFormatter(UserCombox, 'PackUserId', 'PackUserName'),
			editor: UserCombox
		}, {
			title: '质检人员',
			field: 'CheckUserId',
			align: 'left',
			width: 80,
			sortable: true,
			formatter: CommonFormatter(UserCombox, 'CheckUserId', 'CheckUserName'),
			editor: UserCombox
		}
	]];
		
	var DailySurveyGrid = $UI.datagrid('#DailySurveyGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.DailySurvey',
			QueryName: 'SelectAll'
			
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.System.DailySurvey',
			MethodName: 'jsDelete'
		},
		saveDataFn: function() {
			var Rows = DailySurveyGrid.getChangesData();
			if (isEmpty(Rows)) {
				// $UI.msg('alert','没有需要保存的信息!');
				return;
			}
			if (Rows === false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.System.DailySurvey',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					DailySurveyGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		columns: DailySurveyCm,
		showAddSaveDelItems: true,
		sortName: 'RowId',
		sortOrder: 'desc',
		checkField: 'PkgId',
		onClickRow: function(index, row) {
			DailySurveyGrid.commonClickRow(index, row);
		},
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#DailySurveyGrid').datagrid('selectRow', 0);
			}
		}
	});
	Query();
};

$(init);