// 清洗架/灭菌架维护界面
var MainGrid, CodeDictGrid;
function EditDetail(RowId, HospId) {
	AddPkgWin(RowId, HospId, queryMain);
}

function queryMain() {
	$('#PackageList').datagrid('reload');
}

var init = function() {
	var HospId = gHospId;
	var TableName = 'CSSD_Package';
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			QueryPkgInfo();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				QueryPkgInfo();
			};
		} else {
			QueryPkgInfo();
		}
	}
	// /===========================初始化条件======================

	$HUI.combobox('#FNotUse', {
		valueField: 'RowId',
		textField: 'Description',
		data: NotUseData,
		onLoadSuccess: function(data) {
			$('#FNotUse').combobox('setValue', 'Y');
		}
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			QueryPkgInfo();
		}
	});
	function QueryPkgInfo(PkgId) {
		$UI.clear(CodeDictGrid);
		var OthersParams = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		var ParamsObj = $UI.loopBlock('#Conditions');
		if (!isEmpty(PkgId)) {
			ParamsObj.PkgId = PkgId;
		}
		var QueryParams = JSON.stringify(ParamsObj);
		MainGrid.load({
			ClassName: 'web.CSSDHUI.PackageInfo.Package',
			QueryName: 'QueryPkgInfo',
			Params: QueryParams,
			Others: OthersParams
		});
	}
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			ClearPkgInfo();
		}
	});
	function ClearPkgInfo() {
		$UI.clearBlock('#Conditions');
		$UI.clear(MainGrid);
	}
	
	var MainCm = [[
		{
			field: 'operate',
			title: '操作',
			frozen: true,
			align: 'center',
			width: 80,
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '<div class="col-icon icon-write-order" href="#" title="编辑" onclick="EditDetail(' + row.RowId + ',' + HospId + ')"></div>';
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			align: 'left',
			width: 100,
			hidden: true
		}, {
			title: '代码',
			field: 'PkgCode',
			align: 'left',
			width: 80,
			sortable: true
		}, {
			title: '架名称',
			field: 'PkgDesc',
			align: 'left',
			width: 160,
			sortable: true
		}, {
			title: '别名',
			field: 'PkgAlias',
			align: 'left',
			width: 100,
			hidden: true,
			sortable: true
		}, {
			title: '类别',
			field: 'AttributeId',
			align: 'left',
			width: 80,
			sortable: true,
			hidden: true
		}, {
			title: '类别',
			field: 'AttributeDesc',
			align: 'left',
			width: 120,
			sortable: true
		}, {
			title: '灭菌方式',
			field: 'SterTypeDesc',
			width: 100,
			align: 'left',
			sortable: true
		}, {
			title: '单位',
			field: 'UomDesc',
			align: 'left',
			width: 50,
			hidden: true,
			sortable: true
		}, {
			title: '是否可用',
			field: 'NotUseFlag',
			width: 100,
			align: 'center',
			sortable: true,
			formatter: BoolFormatter
		}, {
			title: '备注',
			field: 'Remark',
			align: 'left',
			width: 120,
			sortable: true
		}
	]];

	MainGrid = $UI.datagrid('#PackageList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.Package',
			QueryName: 'QueryPkgInfo'
		},
		columns: MainCm,
		checkField: 'PkgDesc',
		showBar: true,
		toolbar: [
			{
				text: '新增',
				iconCls: 'icon-add',
				handler: function() {
					AddPkgWin('', HospId, QueryPkgInfo);
				}
			}
		],
		singleSelect: true,
		onSelect: function(index, rowData) {
			var PkgId = rowData.RowId;
			if (!isEmpty(PkgId)) {
				FindItemByF(PkgId);
			}
		},
		onLoadSuccess: function(data) {
			$UI.clear(CodeDictGrid);
			if (data.rows.length > 0) {
				$('#PackageList').datagrid('selectRow', 0);
			}
		},
		onBeforeLoad: function(param) {
			param.Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		},
		onDblClickRow: function(index, row) {
			var RowId = row.RowId;
			if (!isEmpty(RowId)) {
				EditDetail(RowId, HospId);
			}
		}
	});
	
	var CodeDictCm = [[
		{
			title: 'RowId',
			align: 'right',
			field: 'RowId',
			checkbox: true
		}, {
			title: '标牌',
			align: 'left',
			field: 'CodedictCode',
			width: 120
		}, {
			title: '标牌名称',
			align: 'left',
			field: 'CodedictDesc',
			width: 200,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '是否可用',
			align: 'center',
			field: 'UseFlag',
			width: 80,
			editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}
	]];

	CodeDictGrid = $UI.datagrid('#CodeDictGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.CodeDict',
			QueryName: 'SelectAll'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.CodeDict',
			MethodName: 'jsDelete'
		},
		navigatingWithKey: true,
		columns: CodeDictCm,
		singleSelect: false,
		showDelSaveItems: true,
		fitColumns: true,
		toolbar: [{
			text: '生成标牌',
			iconCls: 'icon-add',
			handler: function() {
				var Selected = MainGrid.getSelected();
				var RowId = Selected.RowId;
				AddCodeDictWin(HospId, RowId, FindItemByF);
			}
		}],
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#CodeDictList').datagrid('selectRow', 0);
			}
		},
		saveDataFn: function() { // 保存明细
			var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var Rows = CodeDictGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows == false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.PackageInfo.CodeDict',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows),
				Others: Others
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					CodeDictGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		onClickRow: function(index, row) {
			CodeDictGrid.commonClickRow(index, row);
		}
	});
	function FindItemByF(PkgId) {
		var Others = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
		var ParamsObj = $UI.loopBlock('Conditions');
		ParamsObj.PkgDesc = PkgId;
		var Params = JSON.stringify(ParamsObj);
		CodeDictGrid.load({
			ClassName: 'web.CSSDHUI.PackageInfo.CodeDict',
			QueryName: 'SelectAll',
			Params: Params,
			Others: Others
		});
	}
	InitHosp();
	QueryPkgInfo();
};
$(init);