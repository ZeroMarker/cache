var gHospId, gPkgId, gFn;
var AddCodeDictWin = function(HospId, PkgId, Fn) {
	gHospId = HospId;
	gPkgId = PkgId;
	gFn = Fn;
	$HUI.dialog('#AddCodeDictWin').open();
};

var initAddCodeDictWin = function() {
	$UI.linkbutton('#CreateBT', {
		onClick: function() {
			Save();
		}
	});
	function Save() {
		var Others = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
		var ParamsObj = $UI.loopBlock('FConditions');
		if (isEmpty(ParamsObj.Qty)) {
			$UI.msg('alert', '请输入数量');
			$('#Qty').focus();
			return;
		}
		ParamsObj.PkgDesc = gPkgId;
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
				gFn(gPkgId);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
};
$(initAddCodeDictWin);