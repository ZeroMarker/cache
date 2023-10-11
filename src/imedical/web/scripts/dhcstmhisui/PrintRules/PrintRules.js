// 名称:打印规则维护
// 编写日期:2021-8-27
// 
var init = function() {
	function Query() {
		var ParamsObj = $UI.loopBlock('Conditions');
		var Params = JSON.stringify(ParamsObj);
		MATPrintRulesGrid.load({
			ClassName: 'web.DHCSTMHUI.PrintRules',
			QueryName: 'SelectAll',
			query2JsonStrict: 1,
			Params: Params,
			rows: 99999
		});
	}
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			Query();
		}
	});
	$UI.linkbutton('#AddBT', {
		onClick: function() {
			MATPrintRulesGrid.commonAddRow();
		}
	});

	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var Rows = MATPrintRulesGrid.getChangesData();
			if (Rows === false) {	// 未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)) {	// 明细不变
				$UI.msg('alert', '没有需要保存的明细!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.PrintRules',
				MethodName: 'Save',
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Query();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	var MATPrintRulesCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '代码',
			field: 'Code',
			width: 50,
			fitColumns: true
		}, {
			title: '描述',
			field: 'Description',
			width: 400,
			fitColumns: true,
			editor: { type: 'text' }
		}
	]];
	var MATPrintRulesGrid = $UI.datagrid('#MATPrintRulesList', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.PrintRules',
			QueryName: 'SelectAll',
			query2JsonStrict: 1,
			rows: 99999
		},
		columns: MATPrintRulesCm,
		pagination: false,
		onClickRow: function(index, row) {
			MATPrintRulesGrid.commonClickRow(index, row);
		}
	});
	Query();
};
$(init);