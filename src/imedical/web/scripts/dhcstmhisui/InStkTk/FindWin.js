var FindWin = function(LocId, Fn) {
	$UI.clearBlock('#FindWin');
	var FRecLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	if (InStkTkParamObj.AllLoc == 'Y') {
		FRecLocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	}
	var FRecLocBox = $HUI.combobox('#FLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FRecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var CompBox = $HUI.combobox('#FInstComp', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': 'N', 'Description': '未完成' }, { 'RowId': 'Y', 'Description': '已完成' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var DefaultData = {
		FLoc: LocId,
		FStartDate: DateFormatter(new Date()),
		FEndDate: DateFormatter(new Date()),
		FInstComp: 'N',
		FStkTkComp: 'N',
		FAdjComp: 'N'
	};
	$UI.fillBlock('#FindWin', DefaultData);
	$HUI.dialog('#FindWin').open();
	$UI.linkbutton('#FCancelBT', {
		onClick: function() {
			$HUI.dialog('#FindWin').close();
		}
	});
	$UI.linkbutton('#FSuerBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#FindWin');
			
			if (isEmpty(ParamsObj.FStartDate)) {
				$UI.msg('alert', '起始日期不能为空!');
				return false;
			}
			if (isEmpty(ParamsObj.FEndDate)) {
				$UI.msg('alert', '截止日期不能为空!');
				return false;
			}
			Fn(ParamsObj);
			$HUI.dialog('#FindWin').close();
		}
	});
};