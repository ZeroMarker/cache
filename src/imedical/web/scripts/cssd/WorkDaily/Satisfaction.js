var MainListGrid = '';
// 满意度调查
function cancelOrder(MainId) {
	$.messager.confirm('操作提示', '您确定要执行操作吗？', function(data) {
		if (data) {
			var Params = JSON.stringify(addSessionParams({ MainId: MainId }));
			$.cm({
				ClassName: 'web.CSSDHUI.System.SatisfactionSurvey',
				MethodName: 'jsCancelOrder',
				Params: Params
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					$('#MainList').datagrid('reload');
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
}
function submitOrder(MainId) {
	var Params = JSON.stringify(addSessionParams({ MainId: MainId }));
	$.cm({
		ClassName: 'web.CSSDHUI.System.SatisfactionSurvey',
		MethodName: 'jsSubmitOrder',
		Params: Params
	}, function(jsonData) {
		if (jsonData.success === 0) {
			$UI.msg('success', jsonData.msg);
			$('#MainList').datagrid('reload');
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}

var init = function() {
	var LocParams = JSON.stringify(addSessionParams({ Type: 'Login', BDPHospital: gHospId }));
	var LocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			onSelect: function(record) {
				var rows = MainListGrid.getRows();
				var row = rows[MainListGrid.editIndex];
				row.LocDesc = record.Description;
			}
		}
	};
	
	$HUI.combobox('#LocId', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function(data) { // 默认第一个值
			if (data.length === 1) {
				$('#LocId').combobox('setValue', data[0].RowId);
			}
		}
	});
	
	// 查询
	var Params = JSON.stringify($UI.loopBlock('#MainCondition'));
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			query();
		}
	});
	function query(MainId) {
		clear();
		var ParamsObj = $UI.loopBlock('#MainCondition');
		if (isEmpty(ParamsObj.FStartDate)) {
			$UI.msg('alert', '起始日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.FEndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (!isEmpty(MainId)) {
			ParamsObj.MainId = MainId;
		}
		MainListGrid.load({
			ClassName: 'web.CSSDHUI.System.SatisfactionSurvey',
			QueryName: 'SelectAll',
			Params: JSON.stringify(ParamsObj)
		});
	}
	function clear() {
		document.getElementById('InputItem').innerHTML = '';
		$UI.clear(ItemListGrid);
	}
	function setDefault() {
		var Default = {
			FStartDate: DateFormatter(new Date()),
			FEndDate: DateFormatter(new Date()),
			LocId: gLocObj
		};
		$UI.fillBlock('#MainCondition', Default);
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
				if (row.Flag === 'Y') {
					str = str + '<div class="col-icon icon-back" title="' + $g('撤销') + '" onclick="cancelOrder(' + row.RowId + ')"></div>';
				} else {
					str = str + '<div class="col-icon icon-cancel" title="' + $g('删除') + '" onclick="MainListGrid.commonDeleteRow(true,' + index + ');"></div>'
							+ '<div class="col-icon icon-submit"  title="' + $g('提交') + '" onclick="submitOrder(' + row.RowId + ')"></div>';
				}
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '提交标记',
			field: 'Flag',
			width: 70,
			align: 'center',
			styler: flagColor,
			formatter: function(value) {
				if (value === 'Y') return $g('提交');
				else return $g('未提交');
			}
		}, {
			title: '单号',
			field: 'No',
			width: 130
		}, {
			title: '科室',
			field: 'LocId',
			width: 120,
			formatter: CommonFormatter(LocCombox, 'LocId', 'LocDesc'),
			editor: LocCombox
		}, {
			title: '调查时间',
			field: 'CreateDate',
			width: 160
		}, {
			title: '调查人',
			field: 'CreateUserName',
			width: 100
		}, {
			title: '提交时间',
			field: 'SubmitDate',
			width: 160
		}, {
			title: '提交人',
			field: 'SubmitUserName',
			width: 100
		}
	]];
	function flagColor(val, row, index) {
		if (val === 'Y') {
			return 'color:white;background:' + GetColorCode('green');
		} else {
			return 'color:white;background:' + GetColorCode('red');
		}
	}
	MainListGrid = $UI.datagrid('#MainList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.SatisfactionSurvey',
			QueryName: 'SelectAll',
			Params: Params
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.System.SatisfactionSurvey',
			MethodName: 'jsDelete'
		},
		columns: MainCm,
		showAddSaveItems: true,
		sortName: 'RowId',
		sortOrder: 'desc',
		beforeAddFn: function() {
			var DefLocId = $('#LocId').combo('getValue');
			var DefLocDesc = $('#LocId').combo('getText');
			if (isEmpty(DefLocId)) { return; }
			var DefaultData = { LocId: DefLocId, LocDesc: DefLocDesc };
			return DefaultData;
		},
		saveDataFn: function() {
			var Rows = MainListGrid.getChangesData();
			if (isEmpty(Rows)) {
				$UI.msg('alert', '没有需要保存的数据!');
				return;
			}
			if (Rows === false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.System.SatisfactionSurvey',
				MethodName: 'jsSave',
				Params: Params,
				MainParams: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					query(jsonData.rowid);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				if (CommParObj.SelectFirstRow == 'Y') {
					$('#MainList').datagrid('selectRow', 0);
				}
			}
		},
		onClickRow: function(index, row) {
			if (row.Flag === 'Y') {
				return false;
			}
			MainListGrid.commonClickRow(index, row);
		},
		onSelect: function(index, rowData) {
			clear();
			var Id = rowData.RowId;
			if (!isEmpty(Id)) {
				FindItemByF(Id);
			}
			if (rowData.Flag === 'Y') {
				$('#SaveBT').linkbutton('disable');
			} else {
				$('#SaveBT').linkbutton('enable');
			}
		},
		afterDelFn: function() {
			clear();
		}
	});
	
	var ItemCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '调查项目Id',
			field: 'SatisfactionId',
			width: 100,
			hidden: true
		}, {
			title: '调查项目',
			field: 'SatisfactionDesc',
			width: 283
		}, {
			title: '满意',
			align: 'center',
			field: 'Satisfied',
			width: 80,
			formatter: function(value, row, index) {
				if (row.Result === 'S') {
					return '<input name="isSatisfied' + index + '" type="radio" checked="checked" /> ';
				} else {
					return '<input name="isSatisfied' + index + '" type="radio" /> ';
				}
			}
		}, {
			title: '较满意',
			align: 'center',
			field: 'RelativelySatisfied',
			width: 80,
			formatter: function(value, row, index) {
				if (row.Result === 'RS') {
					return '<input name="isRelativelySatisfied' + index + '" type="radio" checked="checked" /> ';
				} else {
					return '<input name="isRelativelySatisfied' + index + '" type="radio" /> ';
				}
			}
		}, {
			title: '不满意',
			align: 'center',
			field: 'DisSatisfied',
			width: 80,
			formatter: function(value, row, index) {
				if (row.Result === 'DS') {
					return '<input name="isDisSatisfied' + index + '" type="radio" checked="checked" /> ';
				} else {
					return '<input name="isDisSatisfied' + index + '" type="radio" /> ';
				}
			}
		}, {
			title: '结果',
			field: 'Result',
			width: 80,
			hidden: true
		}, {
			title: '类型',
			field: 'Type',
			width: 100,
			hidden: true
		}
	]];
	var ItemListGrid = $UI.datagrid('#ItemList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.SatisfactionSurvey',
			QueryName: 'SelectByF'
		},
		columns: ItemCm,
		pagination: false,
		sortName: 'SatisfactionId',
		sortOrder: 'asc',
		toolbar: [
			{
				id: 'SaveBT',
				text: '保存',
				iconCls: 'icon-save',
				handler: function() {
					SaveDetail();
				}
			}
		],
		onClickCell: function(index, filed, value) {
			if (filed === 'Satisfied') {
				ItemListGrid.updateRow({
					index: index,
					row: {
						Result: 'S'
					}
				});
			} else if (filed === 'RelativelySatisfied') {
				ItemListGrid.updateRow({
					index: index,
					row: {
						Result: 'RS'
					}
				});
			} else if (filed === 'DisSatisfied') {
				ItemListGrid.updateRow({
					index: index,
					row: {
						Result: 'DS'
					}
				});
			}
			ItemListGrid.commonClickCell(index, filed);
		}
	});
	function SaveDetail() {
		var Rows = ItemListGrid.getRows();
		var rowMain = $('#MainList').datagrid('getSelected');
		if (isEmpty(Rows)) {
			$UI.msg('alert', '没有需要保存的数据!');
			return;
		}
		if (Rows === false) {
			$UI.msg('alert', '存在未填写的必填项，不能保存!');
			return;
		}
		if (rowMain.Flag === 'Y') {
			$UI.msg('alert', '单据已提交不能修改调查结果!');
			return false;
		}
		var IsValueFlag = '';
		var checkList = $('#ItemListInput').find('td[name="tdInput"]');
		$.each(checkList, function(index, item) {
			var InputValue = $(item).find('input[class="textbox"]').val();
			var SatisfactionRowid = $(item).find('input[class="textbox"]')[0].name;
			var SatisfactionId = SatisfactionRowid.substr(0, SatisfactionRowid.indexOf('_'));
			var RowId = SatisfactionRowid.substr(SatisfactionRowid.indexOf('_') + 1, SatisfactionRowid.length);
			if (isEmpty(InputValue)) {
				IsValueFlag = 'N';
				return false;
			} else {
				Rows.push({ RowId: RowId, SatisfactionId: SatisfactionId, Type: 'I', Result: InputValue });
			}
		});
		if (IsValueFlag === 'N') {
			$UI.msg('alert', '请填写完整调查明细!');
			return false;
		}
		var mainId = rowMain.RowId;
		$.cm({
			ClassName: 'web.CSSDHUI.System.SatisfactionSurvey',
			MethodName: 'jsSaveDetail',
			Params: JSON.stringify(Rows),
			MainId: mainId
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				clear();
				FindItemByF(mainId);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function FindItemByF(MainId) {
		var ItmParams = JSON.stringify(addSessionParams({ MainId: MainId, SatisfactionType: 'R' }));
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.System.SatisfactionSurvey',
			QueryName: 'SelectByF',
			Params: ItmParams,
			rows: 9999999
		});
		ItmParams = JSON.stringify(addSessionParams({ MainId: MainId, SatisfactionType: 'I' }));
		$.cm({
			ClassName: 'web.CSSDHUI.System.SatisfactionSurvey',
			QueryName: 'SelectByF',
			Params: ItmParams,
			rows: 9999999
		}, function(jsonData) {
			document.getElementById('InputItem').innerHTML = '';
			$('#InputItem').append('<table id="ItemListInput"></table>');
			for (var i = 0; i < jsonData.total; i++) {
				var row = jsonData.rows[i];
				var Result = row.Result;
				var innerHTML = '';
				if (isEmpty(Result)) {
					innerHTML = '<tr class="InputText"><td style="padding-left:10px;" align="right"><label>' + row.SatisfactionDesc
						+ '</label></td><td style="padding-left:10px;" name="tdInput"><input id=' + row.SatisfactionId
						+ ' name=' + row.SatisfactionId + '_' + row.RowId + ' class="textbox" style="width:270px" ></td></tr>';
				} else {
					innerHTML = '<tr class="InputText"><td style="padding-left:10px;" align="right"><label>' + row.SatisfactionDesc
						+ '</label></td><td style="padding-left:10px;" name="tdInput"><input id=' + row.SatisfactionId
						+ ' name=' + row.SatisfactionId + '_' + row.RowId + ' class="textbox" style="width:270px" value=' + Result + ' ></td></tr>';
				}
				$('#ItemListInput').append(innerHTML);
			}
		});
	}
	function AdjLayoutSize() {
		var EastWidth = $(window).width() * 0.47;
		$('#LayOut').layout('panel', 'east').panel('resize', { width: EastWidth });
		$('#LayOut').layout();
		var NorthHeight = $(window).height() * 0.6;
		$('#LayOutItem').layout('panel', 'north').panel('resize', { height: NorthHeight });
		$('#LayOutItem').layout();
	}
	window.onresize = function() {
		AdjLayoutSize();
	};
	AdjLayoutSize();
	setDefault();
	query();
};
$(init);