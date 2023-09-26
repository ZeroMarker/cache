var SaveInvWin=function(Fn){
	$HUI.dialog('#InvWin').open();
	
	$UI.linkbutton('#InvSaveBT',{
		onClick:function(){
			var ParamsObj=$CommonUI.loopBlock('#InvWin');
			var InvNo = ParamsObj.InvNo;
			if (isEmpty(InvNo)) {
				$UI.msg('alert','请输入发票号!');
				return false;
			}
			var InvDate = ParamsObj.InvDate;
			if (isEmpty(InvDate)) {
				$UI.msg('alert','请输入发票日期!');
				return false;
			}
			Fn(ParamsObj);
			$HUI.dialog('#InvWin').close();
		}
	});
}