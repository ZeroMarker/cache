var WinHospId, WinFn;
var AddCodeDictWin = function(HospId, Fn, PkgId) {
	WinHospId = HospId;
	WinFn = Fn;
	WinPkgId = PkgId;
	$HUI.dialog('#AddCodeDictWin').open();
};

var initAddCodeDictWin = function() {
	var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: WinHospId, TypeDetail: '1', CreateLocId: gLocId }));
	$HUI.combobox('#FPkgDesc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			Save();
		}
	});
	function Save() {
		var Others = JSON.stringify(addSessionParams({ BDPHospital: WinHospId }));
		var ParamsObj = $UI.loopBlock('FConditions');
		if (isEmpty(ParamsObj.FPkgDesc)) {
			$UI.msg('alert', '请选择消毒包');
			return;
		}
		if (isEmpty(ParamsObj.Qty)) {
			$UI.msg('alert', '请输入数量');
			$('#Qty').focus();
			return;
		}
		ParamsObj.PkgDesc = ParamsObj.FPkgDesc;
		var Params = JSON.stringify(ParamsObj);
		$.cm({
			ClassName: 'web.CSSDHUI.PackageInfo.CodeDict',
			MethodName: 'CreateCodeDict',
			Params: Params,
			Others: Others
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				$UI.clearBlock('FConditions');
				$HUI.dialog('#AddCodeDictWin').close();
				$('#AttributeDesc').combobox('setValue', ParamsObj.FAttributeDesc);
				$('#PkgDesc').combobox('setValue', ParamsObj.FPkgDesc);
				WinFn();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	$HUI.dialog('#AddCodeDictWin', {
		onOpen: function() {
			$UI.clearBlock('#FConditions');
			var DefaultValue = {
				FPkgDesc: WinPkgId
			};
			$UI.fillBlock('#FConditions', DefaultValue);
		}
	});
};
$(initAddCodeDictWin);