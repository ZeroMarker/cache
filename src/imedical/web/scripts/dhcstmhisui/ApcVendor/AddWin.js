var AddVendor = function(HospId, Fn1, Fn2) {
	$HUI.dialog('#AddWin').open();
	
	var AStatus = $HUI.combobox('#AStatus', {
		data: [{ 'RowId': 'A', 'Description': 'ʹ��' }, { 'RowId': 'S', 'Description': 'ͣ��' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	
	/* --��ť����--*/
	$UI.linkbutton('#ASaveBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#AddConditions');
			if (isEmpty(ParamsObj.VendorDesc)) {
				$UI.msg('alert', '���Ʋ���Ϊ��');
				return;
			}
			ParamsObj.BDPHospital = HospId;
			var Params = JSON.stringify(ParamsObj);
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.APCVenNew',
				MethodName: 'Save',
				Basic: Params
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
		// /���ó�ʼֵ ����ʹ������
		var DefaultValue = {
			AVendorCode: '',
			AVendorDesc: ''
		};
		$('#AStatus').combobox('setValue', 'A');
		$UI.fillBlock('#AddConditions', DefaultValue);
	};
	Default();
};