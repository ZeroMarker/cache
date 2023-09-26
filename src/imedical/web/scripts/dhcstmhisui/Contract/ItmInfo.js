var AddWin = function (ContId, Fn,HospId) {
	$HUI.dialog('#AddWin').open();

	var FVendorParams = JSON.stringify(addSessionParams({
				APCType: "M",
				RcFlag: "Y"
			}));
	var FVendorBox = $HUI.combobox('#FVendor', {
			//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVendorParams,
			valueField: 'RowId',
			textField: 'Description',
			onShowPanel: function(){
				var Params = JSON.stringify(addSessionParams({APCType: "M",RcFlag: "Y",BDPHospital:HospId}));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+Params;
				FVendorBox.reload(url);
			}
		});

	$UI.linkbutton('#SaveBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var Params = JSON.stringify(ParamsObj);
			if(isEmpty(ParamsObj.ContractNo)){
				$UI.msg('alert', '请输入合同号!');
				return;
			}
			if(isEmpty(ParamsObj.Remark)){
				$UI.msg('alert', '请输入备注!');
				return;
			}
			if(isEmpty(ParamsObj.Vendor)){
				$UI.msg('alert', '请选择供应商!');
				return;
			}
			if(isEmpty(ParamsObj.EndDate)){
				$UI.msg('alert', '请选择截止日期!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
				MethodName: 'SaveCont',
				ContId: ContId,
				Params: Params
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Fn();
					$HUI.dialog('#AddWin').close();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#CloseBT', {
		onClick: function () {
			$HUI.dialog('#AddWin').close();
		}
	});

	SetDefault(ContId);
}
function SetDefault(ContId) {
	if (ContId == "") {
		$UI.clearBlock('#Conditions');
		return;
	}
	$.cm({
		ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
		MethodName: 'SelectCont',
		ContId: ContId
	}, function (jsonData) {
		$UI.fillBlock('#Conditions', jsonData);
		$("#FContractNo").validatebox("validate");
		$("#FRemark").validatebox("validate");
	});
}
