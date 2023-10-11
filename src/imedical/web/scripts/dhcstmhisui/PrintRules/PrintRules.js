// ����:��ӡ����ά��
// ��д����:2021-8-27
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
			if (Rows === false) {	// δ��ɱ༭����ϸΪ��
				return;
			}
			if (isEmpty(Rows)) {	// ��ϸ����
				$UI.msg('alert', 'û����Ҫ�������ϸ!');
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
			title: '����',
			field: 'Code',
			width: 50,
			fitColumns: true
		}, {
			title: '����',
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