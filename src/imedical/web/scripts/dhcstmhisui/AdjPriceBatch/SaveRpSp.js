var SaveRpSp=function(Fn){
	$HUI.dialog('#SaveRpSp').open();
	//var AdjReasonParams=JSON.stringify(addSessionParams());
	var AdjReasonBox = $HUI.combobox('#AdjReason', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetAdjPriceReason&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
			}
		);
	$UI.linkbutton('#RpSpSureBT',{
		onClick:function(){
			var ParamsObj=$CommonUI.loopBlock('#SaveRpSp');
			var Rp = ParamsObj.Rp;
			if (isEmpty(Rp)) {
				$UI.msg('alert','请输入进价!');
				return false;
			}
			var Sp = ParamsObj.Sp;
			if (isEmpty(Sp)) {
				$UI.msg('alert','请输入售价!');
				return false;
			}
			var AdjReason = ParamsObj.AdjReason;
			if (isEmpty(AdjReason)) {
				$UI.msg('alert','请选择调价原因!');
				return false;
			}
			Fn(ParamsObj);
			$HUI.dialog('#SaveRpSp').close();
		}
	});
}