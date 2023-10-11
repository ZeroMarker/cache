var AddCert = function(OrgType, OrgId, CERTRowId, Fn, HospId) {
	$HUI.dialog('#AddCertWin').open();
	
	var CERTShowFlag = $HUI.combobox('#CERTShowFlag', {
		data: [{ 'RowId': 'Y', 'Description': '是' }, { 'RowId': 'N', 'Description': '否' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var CERTType = $HUI.combobox('#CERTType', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCertType&ResultSetType=array&Params=' + JSON.stringify(addSessionParams({ BDPHospital: HospId, Type: OrgType })),
		valueField: 'RowId',
		textField: 'Description'
	});
	
	/* --按钮功能--*/
	$UI.linkbutton('#ACertSaveBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#AddCertConditions');
			var StartDate = ParamsObj.CERTDateFrom;
			var EndDate = ParamsObj.CERTDateTo;
			if (isEmpty(ParamsObj.CERTType)) {
				$UI.msg('alert', '类型不能为空');
				return;
			}
			if (isEmpty(ParamsObj.CERTText)) {
				$UI.msg('alert', '编号不能为空');
				return;
			}
			if (isEmpty(ParamsObj.CERTShowFlag)) {
				$UI.msg('alert', '展示标志不能为空');
				return;
			}
			if ((!isEmpty(StartDate)) && (!isEmpty(EndDate)) && compareDate(StartDate, EndDate)) {
				$UI.msg('alert', '截至日期不能小于开始日期!');
				return false;
			}
			ParamsObj.HospId = HospId;
			var Params = JSON.stringify(ParamsObj);
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCCertDetail',
				MethodName: 'jsSaveCertDetail',
				OrgType: OrgType,
				OrgId: OrgId,
				CERTParams: Params
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					var RowId = jsonData.rowid;
					Fn(OrgId);
					$HUI.dialog('#AddCertWin').close();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	function Select(RowId) {
		if (isEmpty(RowId)) {
			$UI.clearBlock('#AddCertConditions');
			$('#CERTShowFlag').combobox('select', 'Y');
			$HUI.combobox('#CERTType').enable();
		} else {
			$UI.clearBlock('#AddCertConditions');
			var ParamsObj = {
				CertId: CERTRowId,
				HospId: HospId
			};
			var Params = JSON.stringify(ParamsObj);
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCCertDetail',
				MethodName: 'Select',
				Params: Params
			}, function(jsonData) {
				$UI.fillBlock('#AddCertConditions', jsonData);
				$HUI.combobox('#CERTType').disable();
			});
		}
	}
	
	$HUI.checkbox('#CERTBlankedFlag', {
		onCheckChange: function(e, value) {
			if (value) {
				$('#CERTDelayDateTo').attr('disabled', 'disabled');
				$('#CERTDateTo').attr('disabled', 'disabled');
				$('#CERTDateTo').val('');
			} else {
				$('#CERTDelayDateTo').removeAttr('disabled');
				$('#CERTDateTo').removeAttr('disabled');
			}
		}
	});
	
	Select(CERTRowId);
};