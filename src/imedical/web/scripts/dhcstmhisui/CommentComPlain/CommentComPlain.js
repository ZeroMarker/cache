// 名称:高值点评申诉处理
// 编写日期:2019-11-05

var init = function() {
	var ComResultBox = $HUI.combobox('#ComResultBox', {
		data: [{ 'RowId': '0', 'Description': '点评不合格' }, { 'RowId': '2', 'Description': '已申诉' }, { 'RowId': '3', 'Description': '已接受' }],
		editable: false,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(selData) {
			QueryOrdInfo();
		}
	});
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			QueryOrdInfo();
		}

	});
	function QueryOrdInfo() {
		$UI.clear(OrdItmList);
		$UI.clear(ComLogGrid);
		var ParamsObj = $UI.loopBlock('#Conditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(StartDate)) {
			$UI.msg('alert', '开始日期不能为空!');
			return;
		}
		if (isEmpty(EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '截止日期不能小于开始日期!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		OrdItmList.load({
			ClassName: 'web.DHCSTMHUI.CommentComPlain',
			QueryName: 'QueryOrdInfo',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	var OrdItmListCm = [[
		{
			title: 'ComitmId',
			field: 'ComitmId',
			width: 80,
			hidden: true
		}, {
			title: 'OrdReCheckId',
			field: 'OrdReCheckId',
			width: 80,
			hidden: true
		}, {
			title: '点评明细状态',
			field: 'CurrRet',
			width: 100,
			hidden: true,
			formatter: function(value, row, index) {
				if (row.CurrRet == 0) {
					return '不合理';
				} else if (row.CurrRet == 1) {
					return '合理';
				} else if (row.CurrRet == 2) {
					return '已申诉';
				} else if (row.CurrRet == 3) {
					return '已接受';
				} else if (row.CurrRet == 4) {
					return '未点评';
				} else {
					return '';
				}
			}
		}, {
			title: '医嘱名称',
			field: 'Arcim',
			width: 150
		}, {
			title: '数量',
			field: 'OrdItmQty',
			width: 150
		}, {
			title: 'OeoriUseradd',
			field: 'OeoriUseradd',
			width: 100,
			hidden: true
		}, {
			title: '医生',
			field: 'Doctor',
			width: 100
		}, {
			title: '开医嘱时间',
			field: 'OeoriDate',
			width: 100
		}
	]];
	var OrdItmList = $UI.datagrid('#OrdItmList', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.CommentComPlain',
			QueryName: 'QueryOrdInfo',
			query2JsonStrict: 1
			
		},
		columns: OrdItmListCm,
		onSelect: function(index, row) {
			var ComitmId = row['ComitmId'];
			ComLogGrid.load({
				ClassName: 'web.DHCSTMHUI.CommentComPlain',
				QueryName: 'QueryLog',
				query2JsonStrict: 1,
				DetailId: ComitmId
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				OrdItmList.selectRow(0);
			}
		}
	});
	var ComLogCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 80,
			hidden: true
		}, {
			title: '点评结果',
			field: 'ComResult',
			width: 100,
			formatter: function(value, row, index) {
				if (row.ComResult == 'N') {
					return '不合理';
				} else if (row.ComResult == 'Y') {
					return '合理';
				} else {
					return '';
				}
			}
		}, {
			title: '点评人',
			field: 'ComUser',
			width: 150
		}, {
			title: '点评日期',
			field: 'ComDate',
			width: 150
		}, {
			title: '点评时间',
			field: 'ComTime',
			width: 100
		}, {
			title: '不合格原因',
			field: 'ComReason',
			width: 100
		}, {
			title: '点评建议',
			field: 'ComAdvice',
			width: 100
		}, {
			title: '点评备注',
			field: 'ComRemark',
			width: 100
		}
	]];
	var ComLogGrid = $UI.datagrid('#ComLogGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.CommentComPlain',
			QueryName: 'QueryLog',
			query2JsonStrict: 1
		},
		columns: ComLogCm,
		remoteSort: false
	});
	$UI.linkbutton('#AcceptBT', {
		onClick: function() {
			var Row = OrdItmList.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择接受的医嘱明细!');
				return;
			}
			var OrdReCheckId = Row.OrdReCheckId;
			var ComitmId = Row.ComitmId;
			var CurrRet = Row.CurrRet;
			if (CurrRet != 0) {
				$UI.msg('alert', '医嘱已申诉(接受)处理,无需继续处理!');
				return;
			}
			var Params = JSON.stringify(addSessionParams({
				OrdReCheckId: OrdReCheckId,
				ComitmId: ComitmId
			}));
			$.cm({
				ClassName: 'web.DHCSTMHUI.CommentComPlain',
				MethodName: 'jsSave',
				Params: Params,
				DocNote: 'Accept'
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					DocNote = $('#DocNote').val('');
					QueryOrdInfo();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$('#ComplainBT').on('click', function() {
		var Row = OrdItmList.getSelected();
		if (isEmpty(Row)) {
			$UI.msg('alert', '请选择申诉的医嘱明细!');
			return;
		}
		var OrdReCheckId = Row.OrdReCheckId;
		var ComitmId = Row.ComitmId;
		var CurrRet = Row.CurrRet;
		if (CurrRet != 0) {
			$UI.msg('alert', '医嘱已申诉(接受)处理,无需继续处理!');
			return;
		}
		var Params = JSON.stringify(addSessionParams({
			OrdReCheckId: OrdReCheckId,
			ComitmId: ComitmId
		}));
		var DocNote = $('#DocNote').val();
		if (DocNote == '') {
			$UI.msg('alert', '请在下方原因录入中填写申诉原因');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.CommentComPlain',
			MethodName: 'jsSave',
			Params: Params,
			DocNote: DocNote
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				DocNote = $('#DocNote').val('');
				QueryOrdInfo();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	});
	function SetDefValue() {
		var DefaultValue = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date())
		};
		$UI.fillBlock('#Conditions', DefaultValue);
		$('#ComResultBox').combobox('setValue', 0);
	}
	SetDefValue();
};
$(init);