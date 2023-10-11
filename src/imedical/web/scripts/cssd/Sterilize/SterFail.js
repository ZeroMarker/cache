var CurrId = '';
function CancelOrder(SterFailId) {
	if (isEmpty(SterFailId)) {
		$UI.msg('alert', '请选择要撤销的单据!');
		return false;
	}
	$.messager.confirm('操作提示', '您确定要执行操作吗？', function(data) {
		if (data) {
			showMask();
			$.cm({
				ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeFail',
				MethodName: 'jsCancelOrder',
				SterFailId: SterFailId
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					CurrId = SterFailId;
					$('#MainList').datagrid('reload');
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
}
function SubmitOrder(SterFailId) {
	if (isEmpty(SterFailId)) {
		$UI.msg('alert', '请选择要提交的单据!');
		return false;
	}
	showMask();
	$.cm({
		ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeFail',
		MethodName: 'jsSubmitOrder',
		SterFailId: SterFailId
	}, function(jsonData) {
		hideMask();
		if (jsonData.success == 0) {
			$UI.msg('success', jsonData.msg);
			CurrId = SterFailId;
			$('#MainList').datagrid('reload');
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}

var init = function() {
	// 科室
	var ReqLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	$HUI.combobox('#DeptLocID', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	// 查询
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#MainCondition');
			if (isEmpty(ParamsObj.DeptLocID)) {
				$UI.msg('alert', '科室不能为空！');
				return;
			} else if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert', '开始日期不能为空！');
				return;
			} else if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert', '截止日期不能为空！');
				return;
			} else {
				Query();
			}
		}
	});
	function Query(SterFailId) {
		$UI.clear(ItemListGrid);
		var ParamsObj = $UI.loopBlock('#MainCondition');
		ParamsObj.SterFailId = SterFailId;
		var Params = JSON.stringify(ParamsObj);
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeFail',
			QueryName: 'SelectAll',
			Params: Params
		});
	}

	// 设置默认值
	function setDefault() {
		var Default = {
			DeptLocID: gLocObj,
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate()
		};
		$UI.fillBlock('#MainCondition', Default);
	}

	var MainCm = [[
		{
			field: 'operate',
			title: '操作',
			frozen: true,
			align: 'center',
			width: 50,
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '';
				if (row.Status === '1') {
					str = '<div class="icon-back col-icon" href="#" title="撤销" onclick="CancelOrder(' + row.RowId + ')"></div>';
				} else {
					str = '<div class="icon-submit col-icon" href="#" title="提交" onclick="SubmitOrder(' + row.RowId + ')"></div>';
				}
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '确认标记',
			field: 'Status',
			width: 70,
			align: 'center',
			styler: flagColor,
			formatter: function(value) {
				var status = '';
				if (value === '1') {
					status = '确认';
				} else {
					status = '未确认';
				}
				return status;
			}
		}, {
			title: '单号',
			field: 'CSSDSPNo',
			width: 110
		}, {
			title: '灭菌批号',
			field: 'SterNo',
			width: 130
		}, {
			title: '科室',
			field: 'CSSDSPLoc',
			width: 150
		}, {
			title: '登记日期',
			field: 'CSSDSPDate',
			width: 150
		}, {
			title: '登记人',
			field: 'Register',
			width: 150
		}
	]];
	function flagColor(val, row, index) {
		if (val === '1') {
			return 'color:white;background:' + GetColorCode('green');
		} else {
			return 'color:white;background:' + GetColorCode('red');
		}
	}
	var MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeFail',
			QueryName: 'SelectAll'
		},
		columns: MainCm,
		sortName: 'RowId',
		sortOrder: 'desc',
		singleSelect: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				var GridListIndex = '';
				if (!isEmpty(CurrId)) {
					var Rows = $('#MainList').datagrid('getRows');
					$.each(Rows, function(index, item) {
						if (item.RowId == CurrId) {
							GridListIndex = index;
							return false;
						}
					});
					CurrId = '';
				} else if (CommParObj.SelectFirstRow === 'Y') {
					GridListIndex = 0;
				}
				if (!isEmpty(GridListIndex)) {
					$('#MainList').datagrid('selectRow', GridListIndex);
				}
			}
		},
		onClickRow: function(index, row) {
			MainListGrid.commonClickRow(index, row);
		},
		onSelect: function(index, rowData) {
			var SterFailId = rowData.RowId;
			$UI.clear(ItemListGrid);
			if (!isEmpty(SterFailId)) {
				ItemListGrid.load({
					ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeFailItem',
					QueryName: 'SelectByF',
					SterFailId: SterFailId,
					rows: 9999
				});
			}
		}
	});
	// 不合格原因下拉
	var ReasonData = $.cm({
		ClassName: 'web.CSSDHUI.Common.Dicts',
		QueryName: 'GetRetReason',
		ResultSetType: 'array'
	}, false);
	var ReasonBox = {
		type: 'combobox',
		options: {
			data: ReasonData,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = ItemListGrid.getRows();
				var row = rows[ItemListGrid.editIndex];
				row.ReasonDesc = record.Description;
			}
		}
	};

	var ItemCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '标签',
			field: 'Label',
			width: 160
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 150
		}, {
			title: '不合格原因',
			field: 'ReasonId',
			width: 160,
			formatter: CommonFormatter(ReasonBox, 'ReasonId', 'ReasonDesc'),
			editor: ReasonBox
		}, {
			title: '分析',
			field: 'ReasonAnalysis',
			width: 200,
			editor: { type: 'validatebox' }
		}, {
			title: '改进措施',
			field: 'Improve',
			width: 200,
			editor: { type: 'validatebox' }
		}
	]];

	var ItemListGrid = $UI.datagrid('#ItemList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeFailItem',
			QueryName: 'SelectByF'
		},
		columns: ItemCm,
		pagination: false,
		checkField: 'Label',
		showSaveItems: true,
		sortName: 'RowId',
		sortOrder: 'desc',
		saveDataFn: function() { // 保存明细
			var Rows = ItemListGrid.getChangesData();
			if (isEmpty(Rows)) return;
			if (Rows === false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			var rowMain = $('#MainList').datagrid('getSelected');
			showMask();
			$.cm({
				ClassName: 'web.CSSDHUI.PackageSterilize.SterilizeFailItem',
				MethodName: 'jsSaveSterFailItm',
				Params: JSON.stringify(Rows),
				SterFailId: rowMain.RowId
			}, function(jsonData) {
				hideMask();
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					ItemListGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		onBeforeEdit: function() {
			var rowMain = $('#MainList').datagrid('getSelected');
			if (rowMain.Status === '1') {
				return false;
			}
		},
		onClickRow: function(index, row) {
			ItemListGrid.commonClickRow(index, row);
		}
	});
	
	setDefault();
	Query();
};
$(init);