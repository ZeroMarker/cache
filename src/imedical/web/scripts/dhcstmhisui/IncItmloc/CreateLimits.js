
function CreateLimit(Fn, ItmLoc) {
	var Clear = function() {
		$UI.clearBlock('#CreateLimitEdit');
		var LocId = $('#FItmLoc').combobox('getValue');
		var LocDesc = $('#FItmLoc').combobox('getText');
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			maxlimts: 1.25,
			minlimts: 0.25,
			FItmLoc: { RowId: ItmLoc }
		};
		$UI.fillBlock('#CreateLimitEdit', DefaultData);
	};
	var ItmLocParams = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: gHospId }));
	var ItmLocBox = $HUI.combobox('#FItmLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ItmLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	function DefaultStDate() {
		var Today = new Date();
		var DefaStartDate = -35;
		if (isEmpty(DefaStartDate)) {
			return DateFormatter(Today);
		}
		var EdDate = DateAdd(Today, 'd', parseInt(DefaStartDate));
		return DateFormatter(EdDate);
	}
	function DefaultEdDate() {
		var Today = new Date();
		var DefaEndDate = -1;
		if (isEmpty(DefaEndDate)) {
			return DateFormatter(Today);
		}
		var EdDate = DateAdd(Today, 'd', parseInt(DefaEndDate));
		return DateFormatter(EdDate);
	}

	function createlimits() {
		var MainObj = $UI.loopBlock('#condition');
		var maxLimt = $('#maxlimts').val();
		var minLimt = $('#minlimts').val();
		if ((maxLimt == '') || (maxLimt == null) || (maxLimt < 0)) {
			$UI.msg('alert', '请填写正确上限系数!');
			return false;
		}
		if ((minLimt == '') || (minLimt == null) || (minLimt < 0)) {
			$UI.msg('alert', '请填写正确下限系数!');
			return false;
		}
		if (isEmpty(MainObj.TransType)) {
			$UI.msg('alert', '请选择业务类型!');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INCItmLoc',
			MethodName: 'jsAutoSetloclimqty',
			Params: JSON.stringify(MainObj)
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				$HUI.dialog('#CreateLimitEdit').close();
				Fn();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	var StoreConSaveBT = {
		id: 'StoreConSaveBT',
		iconCls: 'icon-w-save',
		text: '保存',
		handler: function() {
			createlimits();
		}
	};
	$HUI.dialog('#CreateLimitEdit', {
		buttons: [StoreConSaveBT],
		onOpen: function() {
			Clear();
		}
	}).open();
}