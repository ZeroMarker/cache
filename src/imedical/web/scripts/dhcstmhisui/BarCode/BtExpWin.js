var SaveBatExpWin=function(Fn){
	$HUI.dialog('#BatExpWin').open();
	$UI.clearBlock('#BatExpCondition');
	$UI.linkbutton('#BatExpSureBT',{
		onClick:function(){
			var ParamsObj=$CommonUI.loopBlock('#BatExpWin');
			var BatNo = ParamsObj.BatNo;
			if (isEmpty(BatNo)) {
				$UI.msg('alert','请输入批号!');
				return false;
			}
			var ExpDate = ParamsObj.ExpDate;
			if (isEmpty(ExpDate)) {
				$UI.msg('alert','请输入效期!');
				return false;
			}
			Fn(ParamsObj);
			$HUI.dialog('#BatExpWin').close();
		}
	});
}