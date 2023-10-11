// 根据RowId查询
function GetHospId() {
	var HospId = '';
	if ($('#_HospList').length != 0) {
		HospId = $HUI.combogrid('#_HospList').getValue();
	} else {
		HospId = gHospId;
	}
	return HospId;
}
function GetDetail(RowId) {
	$.cm({
		ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
		MethodName: 'GetDetail',
		InciId: RowId,
		HospId: GetHospId()
	}, function(jsonData) {
		if (jsonData.success != 0) {
			$UI.msg('error', jsonData.msg);
		} else {
			$UI.clearBlock('#BasicInciData');
			$UI.fillBlock('#BasicInciData', jsonData.InciData);
			var UseFlag = $('#UseFlag').val();	// 是否已经使用 1 使用, 0 未使用
			ChangeState(UseFlag, jsonData.ArcimData.Arc);
		}
	});
}

// 保存方法
var Save;

var initDetail = function() {
	Save = function() {
		var InciObj = $UI.loopBlock('#BasicInciData');
		if(!$UI.checkMustInput('#BasicInciData', InciObj)){
			var retname=$UI.returnMustInputName('#BasicInciData', InciObj);
			$UI.msg('alert', '请先填写必填项！'+retname);
			return;
		}
		var IncData = JSON.stringify(InciObj);
		var SearchDataObj = $UI.loopBlock('#Conditions');
		var SearchData = JSON.stringify(jQuery.extend(true, SearchDataObj, { BDPHospital: GetHospId() }));
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
			MethodName: 'SaveData',
			IncData: IncData,
			SearchData: SearchData
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				GetDetail(jsonData.rowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	};
	
	InitCompStat();
	ReSetMustInput('#BasicInciData');
};
$(initDetail);

// 根据配置控制界面控件
function InitCompStat() {
	if (CodeMainParamObj['SetInitStatusNotUse'] == 'Y') {
		$HUI.checkbox('#NotUseFlag').setValue(true);
	} else {
		$HUI.checkbox('#NotUseFlag').setValue(false);
	}
	if (CodeMainParamObj['INCIBatchReq']) {
		$HUI.combobox('#BatchNoReq').setValue(CodeMainParamObj['INCIBatchReq']);
	}
	if (CodeMainParamObj['INCIExpReq']) {
		$HUI.combobox('#ExpDateReq').setValue(CodeMainParamObj['INCIExpReq']);
	}
	if (DefMarkType) {
		$('#MarkTypeBox').combobox('select', DefMarkType);
	}
	// 界面元素按授权设置
	ReSetElementAuthor('#InciData');
}