var SelectModel = function(row, Fn) {
	var InputType = row.InputType;
	var LocId = row.LocId;
	var HVFlag = row.HVFlag;
	if (HVFlag == '是') { HVFlag = 'Y'; }
	var InStkTkWin = $HUI.combobox('#InStkTkWin', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInStkTkWindow&ResultSetType=array&LocId=' + LocId,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.dialog('#SelectModel').open();
	$UI.linkbutton('#FCancelBT', {
		onClick: function() {
			$UI.clearBlock('#SelectModelConditions');
			$HUI.dialog('#SelectModel').close();
		}
	});
	$UI.linkbutton('#FSuerBT', {
		onClick: function() {
			ReturnData();
		}
	});
	function ReturnData() {
		var CheckedInputTypeRadioJObj = $("input[name='InputType']:checked");
		var SelectModel = CheckedInputTypeRadioJObj.val();
		if (isEmpty(SelectModel)) {
			$UI.msg('alert', '请选择录入方式!');
		} else {
			var InstWin = $('#InStkTkWin').combobox('getValue');
			Fn(SelectModel, InstWin);
			$HUI.dialog('#SelectModel').close();
		}
	}
	
	function Init() {
		$UI.clearBlock('#SelectModelCondition');
		$HUI.radio('#systel1').enable();
		$HUI.radio('#systel2').enable();
		$HUI.radio('#systel3').enable();
		$HUI.radio('#systel4').enable();
		if (InputType == 3 || (HVFlag == 'Y')) {
			$('#InStkTkWin').combobox({ disabled: true });
		} else {
			$('#InStkTkWin').combobox({ disabled: false });
		}
		if ((isEmpty(InputType) || InputType == 1) && (HVFlag != 'Y')) {
			$HUI.radio('#systel1').setValue(true);
		} else if (InputType == 2) {
			$HUI.radio('#systel3').setValue(true);
		} else if (InputType == 3 || (HVFlag == 'Y')) {
			$HUI.radio('#systel4').setValue(true);
		}
		if ((!isEmpty(InputType) && InputType != 1) || (HVFlag == 'Y')) {
			$HUI.radio('#systel1').disable();
			$HUI.radio('#systel2').disable();
		}
		if ((!isEmpty(InputType) && InputType != 2) || (HVFlag == 'Y')) {
			$HUI.radio('#systel3').disable();
		}
		if (InputType != 3 && HVFlag != 'Y') {
			$HUI.radio('#systel4').disable();
		}
	}
	Init();
};