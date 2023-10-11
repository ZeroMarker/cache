var AddPerson = function(OrgType, OrgId, PersonRowId, Fn) {
	var PersonType = 'SaleMan', PersonTypeDesc = '业务员';
	$HUI.dialog('#AddPersonWin').open();
	
	var PersonShowFlag = $HUI.combobox('#PersonShowFlag', {
		data: [{ 'RowId': 'Y', 'Description': '是' }, { 'RowId': 'N', 'Description': '否' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	
	/* --按钮功能--*/
	$UI.linkbutton('#PersonSaveBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#AddPersonConditions');
			var StartDate = ParamsObj.PersonStartDate;
			var EndDate = ParamsObj.PersonEndDate;
			if (isEmpty(ParamsObj.PersonName)) {
				$UI.msg('alert', '姓名不能为空');
				return;
			}
			if (isEmpty(ParamsObj.PersonCarrTel)) {
				$UI.msg('alert', '手机不能为空');
				return;
			}
			if (isEmpty(ParamsObj.PersonShowFlag)) {
				$UI.msg('alert', '展示标志不能为空');
				return;
			}
			
			if ((!isEmpty(StartDate)) && (!isEmpty(EndDate)) && compareDate(StartDate, EndDate)) {
				$UI.msg('alert', '截止日期不能小于开始日期!');
				return;
			}
			
			ParamsObj.PersonType = PersonType;
			ParamsObj.PersonTypeDesc = PersonTypeDesc;
			var Params = JSON.stringify(ParamsObj);
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCPersonDetail',
				MethodName: 'jsSavePersonDetail',
				OrgType: OrgType,
				OrgId: OrgId,
				Params: Params
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					var RowId = jsonData.rowid;
					Fn(OrgId);
					$HUI.dialog('#AddPersonWin').close();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	function Select(RowId) {
		if (isEmpty(RowId)) {
			$UI.clearBlock('#AddPersonConditions');
			$('#PersonShowFlag').combobox('select', 'Y');
		} else {
			$UI.clearBlock('#AddPersonConditions');
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCPersonDetail',
				MethodName: 'Select',
				PersonId: PersonRowId
			}, function(jsonData) {
				$UI.fillBlock('#AddPersonConditions', jsonData);
			});
		}
	}
	
	Select(PersonRowId);
};