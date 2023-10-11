var GridList;
var init = function() {
	var HospId = gHospId;
	var TableName = 'CSSD_CodeDict';
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

	var LocParams = JSON.stringify(sessionObj);
	var LocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = GridList.getRows();
				var row = rows[GridList.editIndex];
				row.LocDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	var SterTypeBox = $HUI.combobox('#SterType', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			SterTypeBox.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterType&ResultSetType=array&Params=' + Params;
			SterTypeBox.reload(url);
		}
	});

	var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: HospId, TypeDetail: '1', CreateLocId: gLocId }));
	$HUI.combobox('#PkgDesc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams
	});
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		var ParamsObj = $UI.loopBlock('Conditions');
		ParamsObj.OprFlag = 'Y';
		var Params = JSON.stringify(ParamsObj);
		GridList.load({
			ClassName: 'web.CSSDHUI.PackageInfo.CodeDict',
			QueryName: 'SelectAll',
			Params: Params,
			Others: Others
		});
	}
	function PrintCodeDict() {
		var Detail = GridList.getSelections();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '请选择要打印的数据!');
			return;
		}
		$.each(Detail, function(index, item) {
			printCodeDict(item.CodedictCode, item.CodedictDesc, item.SterTypeDesc, item.PkgItemCount);
		});
	}
	function PrintItm() {
		var Detail = GridList.getSelections();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '请选择要打印的数据!');
			return;
		}
		$.each(Detail, function(index, item) {
			printitmByCodeDict(item.CodedictCode, item.CodedictDesc, item.SterTypeDesc, item.PkgItemCount);
		});
	}
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('Conditions');
			$UI.clear(GridList);
		}
	});

	function ReloadData() {
		var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		$.cm({
			ClassName: 'web.CSSDHUI.PackageInfo.CodeDict',
			MethodName: 'UpdateCodeDictDesc',
			Others: Others
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				GridList.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	function ExportData() {
		var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		var Params = JSON.stringify($UI.loopBlock('Conditions'));
		var RaqName = 'CSSD_HUI_ExportCodeDict.raq';
		var fileName = '{' + RaqName + '(Params=' + Params + '&Others=' + Others + ')}';
		var transfileName = TranslateRQStr(fileName);
		CSSD_HUI_RQPrint(transfileName);
	}

	var Cm = [[
		{
			title: 'RowId',
			align: 'right',
			field: 'RowId',
			checkbox: true
		}, {
			title: '标牌',
			align: 'left',
			field: 'CodedictCode',
			width: 150
		}, {
			title: '标牌名称',
			align: 'left',
			field: 'CodedictDesc',
			width: 200,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '消毒包',
			align: 'left',
			field: 'PkgDesc',
			width: 200
		}, {
			title: '包属性',
			align: 'left',
			field: 'AttributeDesc',
			width: 100
		}, {
			title: '循环次数',
			align: 'right',
			field: 'CycleCount',
			width: 80
		}, {
			title: '科室',
			align: 'left',
			field: 'LocId',
			width: 150,
			formatter: CommonFormatter(LocCombox, 'LocId', 'LocDesc'),
			editor: LocCombox
		}, {
			title: '灭菌方式Id',
			align: 'right',
			field: 'SterTypeId',
			width: 100,
			hidden: true
		}, {
			title: '灭菌方式',
			align: 'left',
			field: 'SterTypeDesc',
			width: 100
		}, {
			title: '器械数量',
			align: 'right',
			field: 'PkgItemCount',
			width: 100,
			hidden: true
		}, {
			title: '是否启用',
			align: 'center',
			field: 'UseFlag',
			width: 70,
			editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}
	]];

	GridList = $UI.datagrid('#GridList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.CodeDict',
			QueryName: 'SelectAll'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.CodeDict',
			MethodName: 'jsDelete'
		},
		navigatingWithKey: true,
		columns: Cm,
		singleSelect: false,
		showDelSaveItems: true,
		fitColumns: true,
		toolbar: [{
			text: '生成标牌',
			iconCls: 'icon-add',
			handler: function() {
				$UI.clearBlock('FConditions');
				var PkgId = $('#PkgDesc').combobox('getValue');
				AddCodeDictWin(HospId, Query, PkgId);
			}
		}, {
			text: '打印标牌',
			iconCls: 'icon-print',
			handler: function() {
				PrintCodeDict();
			}
		}, {
			text: '打印器械明细',
			iconCls: 'icon-paper-print',
			handler: function() {
				PrintItm();
			}
		}, {
			text: '同步消毒包名称',
			iconCls: 'icon-reload',
			handler: function() {
				ReloadData();
			}
		}, {
			text: '导出数据',
			iconCls: 'icon-export',
			handler: function() {
				ExportData();
			}
		}],
		saveDataFn: function() { // 保存明细
			var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var Rows = GridList.getChangesData();
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
					GridList.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		onClickRow: function(index, row) {
			GridList.commonClickRow(index, row);
		}
	});
	InitHosp();
};
$(init);