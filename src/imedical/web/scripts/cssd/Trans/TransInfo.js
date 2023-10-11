// 消毒包追踪明细弹窗
var TransInfoWin = function(Label) {
	$HUI.dialog('#TransInfoWin', {
		height: gWinHeight,
		width: gWinWidth,
		onOpen: function() {
			if (isEmpty(Label)) {
				return;
			}
			var ParamsObj = { Label: Label };
			var Params = JSON.stringify(ParamsObj);
			GetDetail(Params);
		}
	}).open();
};

function GetDetail(Params) {
	$('#Trans_hstep').vstep({
		items: []
	});
	$('#Trans_hstep')[0].innerHTML = '';
	
	var DetailArray = $.cm({
		ClassName: 'web.CSSDHUI.Trans.TransInfo',
		MethodName: 'QueryInfo',
		Params: Params
	}, false);
	
	$('#Trans_hstep').vstep({
		stepHeight: 100,
		titlePostion: 'top',
		currentInd: DetailArray.length,
		items: DetailArray
	});
}