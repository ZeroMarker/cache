/*
点评不合理
*/
var ComRefuse = function(DetailId, Fn) {
	$HUI.dialog('#ComRefuseWin', { width: gWinWidth, height: gWinHeight }).open();
	$UI.linkbutton('#CFSaveBT', {
		onClick: function() {
			Save();
		}
	});
	function Save() {
		var CheckedNodes = $('#ComReasonTree').tree('getChecked');
		if (CheckedNodes.length == 0) {
			$UI.msg('alert', '请选择不合理原因!');
			return false;
		}
		var ReasonId = '';
		for (var i = 0; i < CheckedNodes.length; i++) {
			var Node = CheckedNodes[i];
			var Reaid = Node.id.split('-')[1];
			if (ReasonId == '') {
				ReasonId = Reaid;
			} else {
				ReasonId = ReasonId + ',' + Reaid;
			}
		}
		var AdviceRowsData = AdviceGrid.getSelections();
		var AdviceId = '';
		for (var i = 0; i < AdviceRowsData.length; i++) {
			var RowId = AdviceRowsData[i].RowId;
			if (AdviceId == '') {
				AdviceId = RowId;
			} else {
				AdviceId = AdviceId + ',' + RowId;
			}
		}
		var Remark = $('#ComRemark').val();
		var Params = JSON.stringify(addSessionParams({
			Result: 'N',
			Advice: AdviceId,
			Reason: ReasonId,
			Remark: Remark
		}));
		$.cm({
			ClassName: 'web.DHCSTMHUI.Comment',
			MethodName: 'SaveLogItm',
			DetailId: DetailId,
			Params: Params
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				$('#ComRefuseWin').window('close');
				var ComRowid = jsonData.rowid;
				Fn(ComRowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
		$UI.clearBlock('#ComTB');
	}
	var AdviceGrid = $UI.datagrid('#AdviceGrid', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.CommentAdvice',
			QueryName: 'SelectAll',
			query2JsonStrict: 1,
			rows: 9999
		},
		fitColumns: true,
		singleSelect: false,
		columns: [[
			{ field: 'ck', checkbox: true },
			{ title: '建议ID', field: 'RowId', width: 50, hidden: true },
			{ title: '点评建议描述', field: 'Description', width: 200 }
		]],
		pagination: false,
		onClickRow: function(index, row) {
			AdviceGrid.commonClickRow(index, row);
		}
	});

	$('#ComReasonTree').tree({
		lines: true,
		checkbox: true,
		onlyLeafCheck: true
	});
	
	function GetComReasonTree() {
		$.cm({
			wantreturnval: 0,
			ClassName: 'web.DHCSTMHUI.CommentReason',
			MethodName: 'GetComReasonInfo',
			ParentId: ''
		}, function(data) {
			$('#ComReasonTree').tree({
				data: data
			});
		});
	}
	GetComReasonTree();
};