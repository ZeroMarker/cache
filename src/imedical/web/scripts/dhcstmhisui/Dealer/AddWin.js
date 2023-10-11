var AddDealer = function(HospId, Fn1, Fn2) {
	$HUI.dialog('#AddWin').open();
	
	var AStatus = $HUI.combobox('#AStatus', {
		data: [{ 'RowId': 'A', 'Description': '使用' }, { 'RowId': 'S', 'Description': '停用' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	
	/* --按钮功能--*/
	$UI.linkbutton('#ASaveBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#AddConditions');
			if (isEmpty(ParamsObj.DealerCode)) {
				$UI.msg('alert', '代码不能为空');
				return;
			}
			if (isEmpty(ParamsObj.DealerDesc)) {
				$UI.msg('alert', '名称不能为空');
				return;
			}
			ParamsObj.BDPHospital = HospId;
			var Params = JSON.stringify(ParamsObj);
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCDealer',
				MethodName: 'jsSave',
				Params: Params
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					var RowId = jsonData.rowid;
					Fn1(RowId);
					Fn2();
					$HUI.dialog('#AddWin').close();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	var Default = function() {
		// /设置初始值 考虑使用配置
		var DefaultValue = {
			Status: 'A',
			DealerCode: '',
			DealerDesc: ''
		};
		$UI.fillBlock('#AddConditions', DefaultValue);
	};
	Default();
};