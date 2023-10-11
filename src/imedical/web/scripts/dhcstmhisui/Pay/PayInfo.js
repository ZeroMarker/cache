var AccAckWin = function(Row, Fn) {
	$HUI.dialog('#AccAckWin').open();

	var PayModeBox = $HUI.combobox('#FPayMode', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPayMode&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function() {
			var PayModeId = Row.PayModeId;
			$('#FPayMode').combobox('select', PayModeId);
		}
	});
	
	$UI.linkbutton('#ConfirmBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#FindConditions');
			if (isEmpty(ParamsObj.CheckAmt)) {
				$UI.msg('alert', '支付金额不能为空!');
				return;
			}
			if (ParamsObj.CheckAmt != ParamsObj.PayAmt) {
				$UI.msg('alert', '支付金额不等于付款金额!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCPayQuery',
				MethodName: 'AccConfirm',
				Pay: Row.RowId,
				Params: Params
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$HUI.dialog('#AccAckWin').close();
					Fn();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#CancelBT', {
		onClick: function() {
			$HUI.dialog('#AccAckWin').close();
		}
	});
	$('#PayNo').val(Row.PayNo);
	$('#FVendor').val(Row.VendorDesc);
	$('#PayAmt').val(Row.PayAmt);
};