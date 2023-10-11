// 待清洗紧急包弹框
var gPackIdStr, gFn;
function LabelInfoEdit(PackIdStr, Fn) {
	gPackIdStr = PackIdStr;
	gFn = Fn;
	$HUI.dialog('#LabelInfoEditWin', {
		// width: gWinWidth,
		// height: gWinHeight
	}).open();
}

var initLabelInfoEdit = function() {
	var HospParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	// 审核人员下拉框
	$HUI.combobox('#EditChkUser', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + HospParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			$HUI.checkbox('#EditChkUserFlag').setValue(true);
		}
	});

	// 包装人员下拉框
	$HUI.combobox('#EditPackUser', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + HospParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			$HUI.checkbox('#EditPackUserFlag').setValue(true);
		}
	});

	// 配包人员下拉框
	$HUI.combobox('#EditPacker', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + HospParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			$HUI.checkbox('#EditPackerFlag').setValue(true);
		}
	});

	// 灭菌人下拉框
	$HUI.combobox('#EditSterUser', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + HospParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			$HUI.checkbox('#EditSterUserFlag').setValue(true);
		}
	});
	
	// 灭菌器
	$HUI.combobox('#EditMachine', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterMachine&ResultSetType=array&type=sterilizer&Params=' + HospParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			$HUI.checkbox('#EditMachineFlag').setValue(true);
		}
	});

	$HUI.combobox('#EditMaterial', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetMaterials&ResultSetType=array&Params=' + HospParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			$HUI.checkbox('#EditMaterialFlag').setValue(true);
		}
	});

	var LocParams = JSON.stringify(addSessionParams({ Type: 'RecLoc', BDPHospital: gHospId }));
	$HUI.combobox('#EditToLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			$HUI.checkbox('#EditToLocFlag').setValue(true);
		}
	});

	$('#EditSterDate').datebox({
		onSelect: function(date) {
			$HUI.checkbox('#EditSterDateFlag').setValue(true);
		}
	});

	$('#EditMaterial').bind('change', function() {
		var val = $('#EditMaterial').val();
		if (!isEmpty(val)) {
			$HUI.checkbox('#EditMaterialFlag').setValue(true);
		}
	});

	$('#EditHeatNo').bind('change', function() {
		var val = $('#EditHeatNo').val();
		if (!isEmpty(val)) {
			$HUI.checkbox('#EditHeatNoFlag').setValue(true);
		}
	});

	$('#EditRemark').bind('change', function() {
		var val = $('#EditRemark').val();
		if (!isEmpty(val)) {
			$HUI.checkbox('#EditRemarkFlag').setValue(true);
		}
	});

	$UI.linkbutton('#UpdateLabelBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#LabelConditions');
			if ((ParamsObj.EditChkUserFlag != 'Y') && (ParamsObj.EditPackUserFlag != 'Y') && (ParamsObj.EditPackerFlag != 'Y') && (ParamsObj.EditToLocFlag != 'Y') && (ParamsObj.EditSterDateFlag != 'Y') && (ParamsObj.EditMaterialFlag != 'Y') && (ParamsObj.EditMachineFlag != 'Y') && (ParamsObj.EditHeatNoFlag != 'Y') && (ParamsObj.EditSterUserFlag != 'Y') && (ParamsObj.EditRemarkFlag != 'Y')) {
				$UI.msg('alert', '没有需要保存的信息!');
				return;
			}
			if ((ParamsObj.EditChkUserFlag == 'Y') && (isEmpty(ParamsObj.EditChkUser))) {
				$UI.msg('alert', '审核人为必填项不能为空!');
				return;
			}
			if ((ParamsObj.EditPackUserFlag == 'Y') && (isEmpty(ParamsObj.EditPackUser))) {
				$UI.msg('alert', '包装人为必填项不能为空!');
				return;
			}
			if ((ParamsObj.EditPackerFlag == 'Y') && (isEmpty(ParamsObj.EditPacker))) {
				$UI.msg('alert', '配包人为必填项不能为空!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			showMask();
			$.cm({
				ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
				MethodName: 'jsUpdateLabelInfo',
				Main: Params,
				PackIdStr: gPackIdStr
			}, function(jsonData) {
				hideMask();
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					$('#LabelInfoEditWin').window('close');
					gFn();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$HUI.dialog('#LabelInfoEditWin', {
		onOpen: function() {
			$UI.clearBlock('#LabelConditions');
			var EditPackParamObj = GetAppPropValue('CSSDPACK');
			var IsPackUser = EditPackParamObj.IsPackUser;
			if (IsPackUser !== 'Y') {
				$('#EditPacker').combobox({ disabled: true });
				$('#EditPackerFlag').checkbox({ disabled: true });
			}
		}
	});
};
$(initLabelInfoEdit);