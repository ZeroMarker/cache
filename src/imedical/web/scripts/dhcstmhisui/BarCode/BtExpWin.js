var SaveBatExpWin=function(Fn){
	$HUI.dialog('#BatExpWin').open();
	$UI.clearBlock('#BatExpCondition');
	$UI.linkbutton('#BatExpSureBT',{
		onClick:function(){
			var ParamsObj=$CommonUI.loopBlock('#BatExpWin');
			var BatNo = ParamsObj.BatNo;
			if (isEmpty(BatNo)) {
				$UI.msg('alert','����������!');
				return false;
			}
			var ExpDate = ParamsObj.ExpDate;
			if (isEmpty(ExpDate)) {
				$UI.msg('alert','������Ч��!');
				return false;
			}
			Fn(ParamsObj);
			$HUI.dialog('#BatExpWin').close();
		}
	});
}