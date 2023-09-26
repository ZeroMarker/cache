/**
 * FileName: dhcbill.reconciliations.js
 * Anchor: ZhYW
 * Date: 2018-03-23
 * Description: 第三方交易明细
 */

$(function () {
	var defDate = getDefStDate(-1);
	$('#stDate, #endDate').datebox('setValue', defDate); //初始化日期为昨天

	$HUI.linkbutton('#btnFind', {
		onClick: function () {
			loadSelDetails();
		}
	});

	$HUI.combobox('#hospital', {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBL.CT.CTHospital&QueryName=GetDataForCmb1&ResultSetType=array',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		value: PUBLIC_CONSTANT.SESSION.HOSPID
	});

	$HUI.combobox('#payChannel', {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillReconciliations&QueryName=FindPayChannel&ResultSetType=array',
		valueField: 'id',
		textField: 'desc'
	});

	$HUI.combobox('#transType', {
		panelHeight: 'auto',
		data: [{id: '', text: '全部'},
			   {id: 'O', text: '门诊'},
			   {id: 'I', text: '住院'}],
		editable: false,
		valueField: 'id',
		textField: 'text'
	});

	$HUI.combobox('#result', {
		panelHeight: 'auto',
		data: [{id: 'B', text: '平'},
			   {id: 'H', text: 'HIS多'},
			   {id: 'T', text: '第三方多'}],
		editable: false,
		valueField: 'id',
		textField: 'text',
		value: 'B'
	});
});

/**
 * Creator: ZhYW
 * CreatDate: 2018-03-15
 * Description: 加载iframe页签明细内容
 */
function loadSelDetails() {
	var iframe = $('#tabMain')[0].contentWindow;
	if (iframe) {
		iframe.loadSelTabsContent();
	}
}