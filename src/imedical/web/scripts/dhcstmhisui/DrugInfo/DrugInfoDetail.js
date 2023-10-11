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
			$UI.clearBlock('#InciData');
			$UI.clearBlock('#ArcimData');
			$UI.fillBlock('#InciData', jsonData.InciData);
			$UI.fillBlock('#ArcimData', jsonData.ArcimData);
			if (isEmpty(jsonData.ArcimData.Arc)) {
				$('#ArcCode').val($('#InciCode').val());
				$('#TariCode').val($('#InciCode').val());
				$('#ArcDesc').val($('#InciDesc').val());
				$('#TariDesc').val($('#InciDesc').val());
			}
			var UseFlag = $HUI.checkbox('#UseFlag').getValue();		// 是否已经使用 1 使用 0 未使用
			ChangeState(UseFlag, jsonData.ArcimData.Arc);
			// 设置医嘱项页签是否可编辑
			var ChargeFlag = $HUI.checkbox('#ChargeFlag').getValue();
			if (ChargeFlag) {
				$('#tabs').tabs('enableTab', '医嘱项');
			} else {
				$('#tabs').tabs('disableTab', '医嘱项');
			}
		}
	});
}

// 保存方法
var Save;

var initDetail = function() {
	$HUI.tabs('#tabs', {
		onSelect: function(title, index) {
			$('#BillUomBox').combobox('disable');
			$('#PurType').combobox('disable');
			
			if (title == '医嘱项') {
				if ($('#_HospList').length != 0) {
					InitHospResize();
				}
				if ((CodeMainParamObj['ScMap'] == 'G') && (isEmpty($('#Arc').val()))) {
					var HV = $HUI.checkbox('#HighPrice').getValue();
					var HVFlag = HV ? 'Y' : 'N';
					$.cm({
						ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
						MethodName: 'MapArcByHv',
						HvFlag: HVFlag,
						Params: JSON.stringify(addSessionParams({ Hospital: GetHospId() }))
					}, function(ArcimData) {
						if (ArcimData.hasOwnProperty('BillCat')) {
							$UI.fillBlock('#ArcimData', ArcimData);
							$UI.msg('alert', '医嘱项计费项信息按高值/低值配置做了重置!');
						}
					});
				}
				if ((isEmpty($('#Arc').val()) && (CodeMainParamObj['ScMap'] == 'Y'))) {
					var StkCatId = $('#StkCatBox').combo('getValue');
					$.cm({
						ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
						MethodName: 'MapArc',
						StkCatId: StkCatId
					}, function(ArcimData) {
						if (ArcimData.hasOwnProperty('BillCat')) {
							$UI.fillBlock('#ArcimData', ArcimData);
							$UI.msg('alert', '医嘱项计费项信息按库存分类配置做了重置!');
						}
					});
				}
			}
		}
	});
	
	/*
	 * 保存方法
	 */
	Save = function() {
		var TipMsg = '';
		var InciObj = $UI.loopBlock('#InciData');
		if (!$UI.checkMustInput('#InciData', InciObj)) {
			var retname = $UI.returnMustInputName('#InciData', InciObj);
			$UI.msg('alert', '请先填写必填项！' + retname);
			return;
		}
		var inci = InciObj.Inci;
		var oldNotUseFlag = tkMakeServerCall('web.DHCSTMHUI.Common.DrugInfoCommon', 'GetNotUseFlag', inci);
		var NotUseFlag = InciObj.NotUseFlag;
		if ((NotUseFlag == 'Y') && (oldNotUseFlag != NotUseFlag)) {
			var LocStr = tkMakeServerCall('web.DHCSTMHUI.LocItmStk', 'IsLocStock', inci);
			if (LocStr != '') {
				$UI.msg('alert', LocStr + '这些科室还有库存，请注意！');
			}
		}
		if (isEmpty(inci) && (!isEmpty(InciObj.StkCat)) && (CodeMainParamObj.NotAllowUpdateIncsc == 'Y')) {
			if (!confirm('若该物资开始使用,将不允许修改库存分类信息,是否继续?')) {
				return false;
			}
		}
		var IncData = JSON.stringify(InciObj);
		
		var ArcTabDisableFlag = $('#tabs').tabs('getTab', '医嘱项').panel('options').tab.hasClass('tabs-disabled');
		var ArcObj = $UI.loopBlock('#ArcimData');
		if (!ArcTabDisableFlag && !$UI.checkMustInput('#ArcimData', ArcObj)) {
			var retname = $UI.returnMustInputName('#ArcimData', ArcObj);
			$UI.msg('alert', '请先填写必填项！' + retname);
			return;
		}
		if (!isEmpty(ArcObj.Arc) && isEmpty(InciObj.ChargeFlag)) {
			$UI.msg('alert', '已关联医嘱项不允许取消收费标志勾选!');
			return;
		}
		var Buom = InciObj.BUom;
		var Puom = InciObj.PUom;
		var BillUom = ArcObj.BillUom;
		var HVFlag = InciObj.HighPrice;
		var HighRiskFlag = InciObj.HighRiskFlag;	// 跟台标志
		var WoStock = ArcObj.WoStock;	// 无库存标志
		
		if ((!ArcTabDisableFlag) && (BillUom != Buom)) {
			TipMsg = '账单单位与基本单位不一致!';
		}
		if ((HVFlag == 'Y') && (HighRiskFlag != 'Y') && (WoStock == 'Y')) {
			$UI.msg('alert', '非跟台高值必须去掉<无库存医嘱>的勾选!');
			return;
		}
		if ((HVFlag == 'Y') && (HighRiskFlag == 'Y') && (WoStock != 'Y')) {
			$UI.msg('alert', '跟台高值需勾选<无库存医嘱>!');
			return;
		}
		if ((HVFlag != 'Y') && (HighRiskFlag == 'Y')) {
			$UI.msg('alert', '跟台耗材需勾选<高值标志>!');
			return;
		}
		var oldHighRiskFlag = tkMakeServerCall('web.DHCSTMHUI.Common.DrugInfoCommon', 'GetTableFlag', inci);
		var IfExistEnableLabel = tkMakeServerCall('web.DHCSTMHUI.INCITM', 'IfExistEnableLabel', inci);
		if ((HVFlag != 'Y') && (IfExistEnableLabel == 'Y')) {
			$UI.msg('alert', '该耗材还存在未使用高值条码,不允许取消高值标志!');
			return;
		}
		if ((oldHighRiskFlag != 'Y') && (HighRiskFlag == 'Y') && (HVFlag == 'Y') && ((IfExistEnableLabel == 'Y'))) {
			$UI.msg('alert', '该耗材还存在未使用高值条码,不允许更改跟台标志!');
			return;
		}
		var ExpireLen = InciObj.ExpireLen;
		var ExpireCheckLen = InciObj.ExpireCheckLen;
		if ((!isEmpty(ExpireLen)) && (!isEmpty(ExpireCheckLen)) && (ExpireCheckLen <= ExpireLen)) {
			$UI.msg('alert', '效期验证长度必须大于效期长度!');
			return;
		}
		var ArcData = JSON.stringify(ArcObj);
		var SearchDataObj = $UI.loopBlock('#Conditions');
		var SearchData = JSON.stringify(jQuery.extend(true, SearchDataObj, { BDPHospital: GetHospId() }));
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
			MethodName: 'SaveData',
			ArcData: ArcData,
			IncData: IncData,
			SearchData: SearchData
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg + ' ' + TipMsg);
				GetDetail(jsonData.rowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	};

	InitCompStat();
	ReSetMustInput('#InciData');
	ReSetMustInput('#ArcimData');
};
$(initDetail);

// 根据配置控制界面控件
function InitCompStat() {
	if (CodeMainParamObj['SameCode'] == 'Y') {
		$('#ArcCode').attr('disabled', 'disabled').addClass('pageauthorno');
	}
	if (CodeMainParamObj['SameDesc'] == 'Y') {
		$('#ArcDesc').attr('disabled', 'disabled').addClass('pageauthorno');
	}
	if (CodeMainParamObj['ModifyBillCode'] == 'N') {
		$('#TariCode').attr('disabled', 'disabled').addClass('pageauthorno');
		$('#TariDesc').attr('disabled', 'disabled').addClass('pageauthorno');
	}

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
	// 设置医嘱项页签是否可编辑
	var ChargeFlag = $HUI.checkbox('#ChargeFlag').getValue();
	if (ChargeFlag) {
		$('#tabs').tabs('enableTab', '医嘱项');
	} else {
		$('#tabs').tabs('disableTab', '医嘱项');
	}
	
	// 界面元素按授权设置
	ReSetElementAuthor('#InciData');
	ReSetElementAuthor('#ArcimData');
}