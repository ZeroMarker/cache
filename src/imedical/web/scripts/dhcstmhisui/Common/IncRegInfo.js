// 名称:资质信息弹窗
var IncRegInfoWin = function(Inci) {
	$HUI.dialog('#IncRegInfoWindow', { width: gWinWidth, height: gWinHeight }).open();
	var RegInfoCm = [[
		{
			title: '资质类型',
			field: 'MainInfo',
			width: 200
		}, {
			title: '资质明细类型',
			field: 'ItemName',
			width: 150
		}, {
			title: '资质明细值',
			field: 'ItemValue',
			width: 600
		}
	]];
	var RegInfoGrid = $UI.datagrid('#RegInfoGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DicGroup',
			MethodName: 'GetItmDetail'
		},
		columns: RegInfoCm,
		fitColumns: true,
		remoteSort: true,
		rownumbers: false,	// 隐藏行号
		nowrap: false,		// 自动换行
		pagination: false
	});
	function GetItmDetail() {
		RegInfoGrid.load({
			ClassName: 'web.DHCSTMHUI.DicGroup',
			MethodName: 'GetItmDetail',
			Inci: Inci
		});
	}
	GetItmDetail();
};