// 错误信息登记界面js
function deleteMain(mainRowId, PackageType) {
	if (isEmpty(mainRowId)) {
		$UI.msg('alert', '请选择要删除的单据!');
		return false;
	}
	$.messager.confirm('操作提示', '您确定要执行删除操作吗？', function(data) {
		if (data) {
			$.cm({
				ClassName: 'web.CSSDHUI.PackageInfo.Package',
				MethodName: 'DeleteMain',
				mainRowId: mainRowId,
				PackageType: PackageType
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$('#PackageList').datagrid('reload');
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
}

var init = function() {
	var PackageBox = $HUI.combobox('#package', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			PackageBox.clear();
			var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TypeDetail: '1,2,7', CreateLocId: gLocId }));
			var url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams;
			PackageBox.reload(url);
		}
	});
	// 灭菌方式下拉数据
	var TempTypeCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterType&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = ErrorRegistorGrid.getRows();
				var row = rows[ErrorRegistorGrid.editIndex];
				row.SCleanMethodName = record.Description;
			}
		}
	};
	// 清洗方式下拉数据
	var CleanTypeBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCleanType&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = ErrorRegistorGrid.getRows();
				var row = rows[ErrorRegistorGrid.editIndex];
				row.SCleanMethodName = record.Description;
			}
		}
	};
	// 供应科室
	var SupLocParams = JSON.stringify(addSessionParams({ Type: 'Login', BDPHospital: gHospId }));
	$HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function(data) { // 默认第一个值
			if (data.length == 1) {
				$('#SupLoc').combobox('setValue', data[0].RowId);
			}
		}
	});
	
	// 默认日期设置
	var Default = {
		SupLoc: gLocObj,
		FDate: DateFormatter(new Date()),
		FEndDate: DateFormatter(new Date())
	};
	$UI.fillBlock('#ErrorRegistorTB', Default);

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			if (isEmpty($('#SupLoc').combobox('getValue'))) {
				$UI.msg('alert', '供应科室不能为空！');
				return;
			}
			query();
		}
	});

	function query() {
		var Params = $UI.loopBlock('ErrorRegistorTB');
		ErrorRegistorGrid.load({
			ClassName: 'web.CSSDHUI.System.ErrorRegistror',
			QueryName: 'SelectAll',
			Params: JSON.stringify(Params)
		});
	}
	
	$UI.linkbutton('#AddBT', {
		onClick: function() {
			ErrorRegistorGrid.commonAddRow();
		}
	});
	// 保存单据
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			saveMast();
		}
	});
	// 导出单据
	$UI.linkbutton('#ExportBT', {
		onClick: function() {
			exportAll();
		}
	});
	var ParamsTB = JSON.stringify($UI.loopBlock('ErrorRegistorTB'));
	function saveMast(ParamsObj) {
		var Rows = ErrorRegistorGrid.getChangesData();
		if (isEmpty(Rows)) {
			return;
		}
		if (Rows == false) {
			$UI.msg('alert', '存在未填写的必填项，不能保存!');
			return;
		}
		$.cm({
			ClassName: 'web.CSSDHUI.System.ErrorRegistror',
			MethodName: 'jsSave',
			Params: JSON.stringify(Rows),
			Params2: ParamsTB
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				ErrorRegistorGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#DeleteBT', {
		onClick: function() {
			ErrorRegistorGrid.commonDeleteRow();
			Delete();
		}
	});
	function Delete() {
		var Rows = ErrorRegistorGrid.getSelectedData();
		if (isEmpty(Rows)) {
			return;
		}
		$.messager.confirm('操作提示', '您确定要执行删除操作吗？', function(data) {
			if (data) {
				$.cm({
				}, function(jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						ErrorRegistorGrid.reload();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		});
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('ErrorRegistorTB');
			$UI.fillBlock('#ErrorRegistorTB', Default);
			$UI.clear(ErrorRegistorGrid);
		}
	});

	var NotUseFlagData = [
		{ 'RowId': 'Y', 'Description': '是' },
		{ 'RowId': 'N', 'Description': '否' }
	];

	var NotUseFlagCombox = {
		type: 'combobox',
		options: {
			data: NotUseFlagData,
			valueField: 'RowId',
			textField: 'Description',
			editable: true
		}
	};
	var ErrorRegistorCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			align: 'left',
			width: 100,
			hidden: true
		},
		{
			title: 'TransDr',
			field: 'TransDr',
			align: 'left',
			width: 100,
			hidden: true
		}, {
			title: '清洗机',
			field: 'CleanMachineNo',
			align: 'left',
			width: 80,
			sortable: true
		}, {
			title: '灭菌器',
			field: 'SterMachineNo',
			align: 'left',
			width: 80,
			sortable: true
		}, {
			title: '日期',
			field: 'ErrorDate',
			align: 'left',
			width: 100,
			sortable: true
		}, {
			title: '时间',
			field: 'ErrorTime',
			align: 'left',
			width: 80,
			sortable: true
		}, {
			title: '消毒包',
			field: 'PackageName',
			align: 'left',
			width: 150,
			sortable: true
		}, {
			title: '清洗人Dr',
			field: 'CleanUser',
			align: 'left',
			width: 100,
			hidden: true
		}, {
			title: '清洗人',
			field: 'CleanUserName',
			align: 'left',
			width: 80,
			sortable: true
		}, {
			title: '清洗方式DR',
			field: 'CleanMethodDR',
			align: 'left',
			width: 100,
			hidden: true
		}, {
			title: '清洗方式',
			field: 'CleanMethodName',
			align: 'left',
			width: 100,
			sortable: true
		}, {
			title: '清洗单号',
			field: 'CleanNo',
			align: 'left',
			width: 130,
			sortable: true
		}, {
			title: '灭菌人DR',
			field: 'SterUser',
			align: 'left',
			width: 100,
			hidden: true
		}, {
			title: '灭菌人',
			field: 'SterUserName',
			align: 'left',
			width: 80,
			sortable: true
		}, {
			title: '灭菌单号',
			field: 'SterNo',
			align: 'left',
			width: 130,
			sortable: true
		}, {
			title: '灭菌方式DR',
			field: 'SterMethodDr',
			align: 'left',
			width: 100,
			hidden: true
		}, {
			title: '灭菌方式',
			field: 'SterMethodName',
			align: 'left',
			width: 100,
			sortable: true
		}, {
			title: '更正清洗方式',
			field: 'SCleanMethodDr',
			align: 'left',
			width: 100,
			sortable: true,
			formatter: CommonFormatter(CleanTypeBox, 'SCleanMethodDr', 'SCleanMethodName'),
			editor: CleanTypeBox
		}, {
			title: '更正灭菌方式',
			field: 'SSterMethodDr',
			align: 'left',
			width: 100,
			sortable: true,
			formatter: CommonFormatter(TempTypeCombox, 'SSterMethodDr', 'SSterMethodName'),
			editor: TempTypeCombox
		}, {
			title: '更正人',
			field: 'UpdateUserName',
			align: 'left',
			width: 80,
			sortable: true
		}, {
			title: '备注',
			field: 'Remark',
			align: 'left',
			width: 100,
			sortable: true,
			editor: { type: 'validatebox' }
		}
	]];
		
	var ErrorRegistorGrid = $UI.datagrid('#ErrorRegistorGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.ErrorRegistror',
			QueryName: 'SelectAll',
			Params: ParamsTB
		},
		columns: ErrorRegistorCm,
		showBar: true,
		showSaveItems: true,
		sortName: 'TransDr',
		sortOrder: 'desc',
		saveDataFn: function() {
			saveMast();
		},
		onClickRow: function(index, row) {
			ErrorRegistorGrid.commonClickRow(index, row);
		},
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#ErrorRegistorGrid').datagrid('selectRow', 0);
			}
		}
	});
	query();
};
$(init);