// ����:������Ϣ����
var IncRegInfoWin = function(Inci) {
	$HUI.dialog('#IncRegInfoWindow', { width: gWinWidth, height: gWinHeight }).open();
	var RegInfoCm = [[
		{
			title: '��������',
			field: 'MainInfo',
			width: 200
		}, {
			title: '������ϸ����',
			field: 'ItemName',
			width: 150
		}, {
			title: '������ϸֵ',
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
		rownumbers: false,	// �����к�
		nowrap: false,		// �Զ�����
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