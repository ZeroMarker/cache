// 清洗不合格登记
var MainList, ItemListGrid, CurrMainId;
function CancelOrder(Id) {
	if (isEmpty(Id)) {
		$UI.msg('alert', '请选择要撤销的单据!');
		return false;
	}
	showMask();
	$.cm({
		ClassName: 'web.CSSDHUI.Clean.CleanFailed',
		MethodName: 'jsCancelOrder',
		Id: Id
	}, function(jsonData) {
		hideMask();
		if (jsonData.success === 0) {
			$UI.msg('success', jsonData.msg);
			CurrMainId = Id;
			$('#MainList').datagrid('reload');
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}

function SubmitOrder(Id) {
	if (isEmpty(Id)) {
		$UI.msg('alert', '请选择要提交的单据!');
		return false;
	}
	showMask();
	$.cm({
		ClassName: 'web.CSSDHUI.Clean.CleanFailed',
		MethodName: 'jsSubmitOrder',
		Id: Id
	}, function(jsonData) {
		hideMask();
		if (jsonData.success === 0) {
			$UI.msg('success', jsonData.msg);
			CurrMainId = Id;
			$('#MainList').datagrid('reload');
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}

var init = function() {
	var ReqLocParams = JSON.stringify(addSessionParams({ Type: 'Login', BDPHospital: gHospId }));
	$HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	// 选取不合格清洗单
	$UI.linkbutton('#CreateBT', {
		onClick: function() {
			UnRegisterCleanFailedWin(Query);
		}
	});

	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		$UI.clear(ItemListGrid);
		var ParamsObj = $UI.loopBlock('#MainCondition');
		if (isEmpty(ParamsObj.SupLoc)) {
			$UI.msg('alert', '请选择科室!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		MainList.load({
			ClassName: 'web.CSSDHUI.Clean.CleanFailed',
			QueryName: 'SelectAll',
			Params: Params
		});
	}
	
	function flagColor(val, row, index) {
		if (val === '1') {
			return 'color:white;background:' + GetColorCode('green');
		} else {
			return 'color:white;background:' + GetColorCode('red');
		}
	}
	
	var MainCm = [[
		{
			field: 'operate',
			title: '操作',
			align: 'center',
			width: 80,
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '';
				if (row.Status == 1) {
					str = str + '<div class="icon-back col-icon" href="#" title="撤销" onclick="CancelOrder(' + row.RowId + ')"></div>';
				} else {
					str = str + '<div class="icon-cancel col-icon"  href="#"  title="删除" onclick="MainList.commonDeleteRow(true,' + index + ');"></div>'
							+ '<div class="icon-submit col-icon" href="#" title="确认" onclick="SubmitOrder(' + row.RowId + ')"></div>';
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
				if (value == 1) {
					status = '确认';
				} else {
					status = '未确认';
				}
				return status;
			}
		}, {
			title: '单号',
			field: 'No',
			width: 110
		}, {
			title: '清洗批号',
			field: 'CleanNum',
			width: 130
		}, {
			title: '清洗科室',
			field: 'SupLocDesc',
			width: 120
		}, {
			title: '登记日期',
			field: 'RegistDate',
			width: 170
		}, {
			title: '登记人',
			field: 'RegisterName',
			width: 120
		}, {
			title: '清洗主表Dr',
			field: 'CleanMainId',
			width: 120,
			hidden: true
		}
	]];
	MainList = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanFailed',
			QueryName: 'SelectAll'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanFailed',
			MethodName: 'jsDelete'
		},
		columns: MainCm,
		sortName: 'RowId',
		sortOrder: 'desc',
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				var GridListIndex = 0;
				if (!isEmpty(CurrMainId)) {
					var Rows = $('#MainList').datagrid('getRows');
					$.each(Rows, function(index, item) {
						if (item.RowId == CurrMainId) {
							GridListIndex = index;
							return false;
						}
					});
				}
				CurrMainId = '';
				$('#MainList').datagrid('selectRow', GridListIndex);
			}
			GetMarkQty();
		},
		onClickRow: function(index, row) {
			MainList.commonClickRow(index, row);
		},
		onSelect: function(index, rowData) {
			var Id = rowData.RowId;
			if (!isEmpty(Id)) {
				FindItemByF(Id);
			}
		},
		afterDelFn: function() {
			$UI.clear(ItemListGrid);
		}
	});

	var ReasonParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	var ReasonBox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCleanReason&ResultSetType=array&Params=' + ReasonParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = ItemListGrid.getRows();
				var row = rows[ItemListGrid.editIndex];
				row.ReasonDesc = record.Description;
			}
		}
	};

	function AddCleanFailItm() {
		var MainRow = MainList.getSelected();
		if (isEmpty(MainRow)) {
			$UI.msg('alert', '请选择不合格登记单');
			return;
		}
		var CleanMainId = MainRow.CleanMainId;
		var PrdoId = MainRow.RowId;
		if (isEmpty(CleanMainId) || isEmpty(PrdoId)) {
			return false;
		}
		SelCleanFailPackage(Query);
	}
	
	function SaveFail() {
		var MainRow = MainList.getSelected();
		if (isEmpty(MainRow)) {
			$UI.msg('alert', '请选择不合格登记单');
			return;
		}
		if (MainRow.Status == 1) {
			$UI.msg('alert', '登记单已确认不能修改');
			return;
		}
		var Rows = ItemListGrid.getChangesData();
		if (isEmpty(Rows)) {
			$UI.msg('alert', '没有需要保存的单据明细');
			return;
		}
		if (Rows === false) {
			$UI.msg('alert', '单据明细为空，不能保存!');
			return;
		}
		for (var i = 0; i < Rows.length; i++) {
			var Num = Rows[i]['PkgNum'];
			var CodeDict = Rows[i]['CodeDict'];
			var MaxCleanQty = Rows[i]['MaxCleanQty'];
			if (isEmpty(CodeDict) && (Number(Num) <= 0)) {
				$UI.msg('alert', '输入数量必须大于0！');
				return;
			}
			if (Number(Num) > Number(MaxCleanQty)) {
				$UI.msg('alert', '输入数量超过了器械或消毒包数量，请核对！');
				return;
			}
		}
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Clean.CleanFailItem',
			MethodName: 'jsSaveSter',
			Params: JSON.stringify(Rows),
			MainId: MainRow.RowId
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				ItemListGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	var ItemCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			field: 'operate',
			title: '操作',
			align: 'center',
			width: 50,
			allowExport: false,
			formatter: function(value, row, index) {
				var rowMain = $('#MainList').datagrid('getSelected');
				if (rowMain.Status == 0) {
					var str = '<div class="icon-cancel col-icon"  href="#"  title="删除" onclick="ItemListGrid.commonDeleteRow(false,' + index + ');"></div>';
				}
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '消毒包Id',
			field: 'PkgId',
			width: 150,
			hidden: true
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 150
		}, {
			title: '标牌',
			field: 'CodeDict',
			width: 120
		}, {
			title: '标牌名称',
			field: 'CodeDictDesc',
			width: 150
		}, {
			title: '器械Id',
			field: 'ItmId',
			width: 150,
			hidden: true
		}, {
			title: '器械',
			field: 'ItmDesc',
			width: 100
		}, {
			title: '不合格数',
			field: 'PkgNum',
			width: 80,
			align: 'right',
			editor: { type: 'numberbox', options: { required: true }}
		}, {
			title: '数量',
			field: 'MaxCleanQty',
			align: 'right',
			width: 80
		}, {
			title: '器械规格',
			field: 'ItmSpec',
			width: 100
		}, {
			title: '不合格原因',
			field: 'ReasonId',
			width: 130,
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
		}, {
			title: '是否启用',
			field: 'IsUsed',
			width: 130,
			hidden: true
		}
	]];

	ItemListGrid = $UI.datagrid('#ItemList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanFailItem',
			QueryName: 'SelectByF'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanFailItem',
			MethodName: 'jsDelete'
		},
		columns: ItemCm,
		pagination: false,
		sortName: 'RowId',
		sortOrder: 'asc',
		singleSelect: false,
		checkField: 'PkgNum',
		toolbar: [{
			text: '不合格包',
			iconCls: 'icon-add',
			handler: function() {
				AddCleanFailItm();
			}
		}, {
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				SaveFail();
			}
		}, {
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() {
				ItemListGrid.commonDeleteRow(true);
			}
		}],
		onBeforeCellEdit: function() {
			var rowMain = $('#ItemList').datagrid('getSelected');
			if (rowMain.IsUsed.split('^')[0] == 'N') {
				$UI.msg('alert', '该明细的消毒包已禁用!');
				return false;
			}
			if (rowMain.IsUsed.split('^')[1] == 'N') {
				$UI.msg('alert', '该明细的器械已禁用!');
				return false;
			}
		},
		afterDelFn: function() {
			var rowMain = MainList.getSelected();
			var MainId = rowMain.RowId;
			CurrMainId = MainId;
			MainList.reload();
		},
		onClickRow: function(index, row) {
			var Id = row.RowId;
			var rowMain = $('#MainList').datagrid('getSelected');
			if (rowMain.Status === '1' && Id) {
				return false;
			}
			ItemListGrid.commonClickRow(index, row);
		},
		onBeforeEdit: function() {
			var rowMain = $('#MainList').datagrid('getSelected');
			if (rowMain.Status === 1) {
				return false;
			}
		}
	});
	
	function FindItemByF(Id) {
		$UI.clear(ItemListGrid);
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.Clean.CleanFailItem',
			QueryName: 'SelectByF',
			MainId: Id,
			rows: 9999999
		});
	}
	
	// 显示数量角标
	function GetMarkQty() {
		var ParamsObj = {};
		ParamsObj.StartDate = DefaultStDate();
		ParamsObj.EndDate = DefaultEdDate();
		var Params = JSON.stringify(addSessionParams(ParamsObj));
		var MarkQtyObj = $.cm({
			ClassName: 'web.CSSDHUI.Clean.CleanFailed',
			MethodName: 'GetMarkQty',
			Params: Params
		}, false);
		$('#UnRegisterNum').html(MarkQtyObj);
	}

	function SetDefault() {
		$UI.clearBlock('#MainCondition');
		$UI.clear(MainList);
		$UI.clear(ItemListGrid);
		var DefaultData = {
			SupLoc: gLocObj,
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate()
		};
		$UI.fillBlock('#MainCondition', DefaultData);
	}
	function AdjLayoutSize() {
		var EastWidth = $(window).width() * 0.45;
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