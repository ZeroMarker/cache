var AddWin = function(ContId, Fn, HospId) {
	$HUI.dialog('#AddWin').open();

	var FConLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	$HUI.combobox('#FConLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FConLocParams,
		onSelect: function(record) {
			var LocId = record['RowId'];
			if (CommParObj.ApcScg == 'L') {
				$('#FVendor').combobox('clear');
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				$('#FVendor').combobox('reload',url);
			}
		}
	});
	
	var FVendorParams = JSON.stringify(addSessionParams({
		APCType: 'M'
		
	}));
	$HUI.combobox('#FVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVendorParams
	});

	$UI.linkbutton('#ISaveBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var Params = JSON.stringify(ParamsObj);
			if (isEmpty(ParamsObj.ConLoc)) {
				$UI.msg('alert', '科室不可为空!');
				return;
			}
			if (isEmpty(ParamsObj.ContractNo)) {
				$UI.msg('alert', '请输入合同号!');
				return;
			}
			if (isEmpty(ParamsObj.Remark)) {
				$UI.msg('alert', '请输入备注!');
				return;
			}
			if (isEmpty(ParamsObj.Vendor)) {
				$UI.msg('alert', '请选择供应商!');
				return;
			}
			if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert', '请选择截止日期!');
				return;
			}
			if ((!isEmpty(ParamsObj.StartDate)) && (!isEmpty(ParamsObj.EndDate)) && compareDate(ParamsObj.StartDate, ParamsObj.EndDate)) {
				$UI.msg('alert', '截至日期不能小于生效日期!');
				return false;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
				MethodName: 'SaveCont',
				ContId: ContId,
				Params: Params
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					var RowId = jsonData['rowid'];
					Fn(RowId);
					$HUI.dialog('#AddWin').close();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#ICloseBT', {
		onClick: function() {
			$HUI.dialog('#AddWin').close();
		}
	});
	
	SetDefault(ContId);
};
function SetDefault(ContId) {
	$UI.clearBlock('#Conditions');
	if (ContId == '') {
		$UI.fillBlock('#Conditions', { ConLoc: gLocObj });
		return;
	} else {
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
			MethodName: 'SelectCont',
			ContId: ContId
		}, function(jsonData) {
			$UI.fillBlock('#Conditions', jsonData);
		});
	}
}