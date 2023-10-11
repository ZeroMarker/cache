var SaveBatExpWin = function(Fn) {
	$HUI.dialog('#BatExpWin').open();
	var IngrLocParams = JSON.stringify(addSessionParams({ Type: 'All', Element: 'IngrLoc' }));
	$HUI.combobox('#IngrLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + IngrLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#FillBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#FillConditions');
			var IngrLoc = ParamsObj['IngrLoc'];
			var IngrLocDesc = $('#IngrLoc').combobox('getText');
			ParamsObj.IngrLocDesc = IngrLocDesc;
			if (isEmpty(ParamsObj['IngrLoc'])) {
				$UI.msg('alert', '请选择补录入库科室!');
				return;
			}
			Fn(ParamsObj);
			$HUI.dialog('#BatExpWin').close();
		}
	});
	var BatClear = function() {
		$UI.clearBlock('#FillConditions');
		var DefaRecLoc = ItmTrackParamObj.DefaRecLoc;
		var Params = JSON.stringify(addSessionParams());
		var RecLocStr = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon', 'LocToRowID', DefaRecLoc, Params);
		var RecLocObj = { RowId: RecLocStr.split('^')[0], Description: RecLocStr.split('^')[1] };
		// /设置初始值 考虑使用配置
		var DefaultData = {
			IngrLoc: RecLocObj
		};
		$UI.fillBlock('#FillConditions', DefaultData);
	};
	BatClear();
};