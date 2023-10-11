/**
 * FileName: dhcbill.reconciliations.js
 * Author: ZhYW
 * Date: 2018-03-23
 * Description: 第三方交易明细
 */

$(function () {
	$(".datebox-f").datebox("setValue", CV.DefDate); //初始化日期为昨天

	$HUI.linkbutton("#btnFind", {
		onClick: function () {
			loadSelDetails();
		}
	});

	$HUI.combobox("#hospital", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBL.CT.CTHospital&QueryName=GetDataForCmb1&ResultSetType=array',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		value: PUBLIC_CONSTANT.SESSION.HOSPID
	});

	$HUI.combobox("#payChannel", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillReconciliations&QueryName=FindPayChannel&ResultSetType=array',
		valueField: 'id',
		textField: 'desc'
	});

	$HUI.combobox("#transType", {
		panelHeight: 'auto',
		data: [{value: '', text: $g('全部')},
			   {value: 'O', text: $g('门诊')},
			   {value: 'I', text: $g('住院')}],
		editable: false,
		valueField: 'value',
		textField: 'text'
	});

	$HUI.combobox("#result", {
		panelHeight: 'auto',
		data: [{value: 'B', text: $g('平'), selected: true},
			   {value: 'H', text: $g('HIS多')},
			   {value: 'T', text: $g('第三方多')}],
		editable: false,
		valueField: 'value',
		textField: 'text'
	});
});

/**
 * Creator: ZhYW
 * CreatDate: 2018-03-15
 * Description: 加载iframe页签明细内容
 */
function loadSelDetails() {
	var iframe = $("#tabMain")[0].contentWindow;
	if (iframe) {
		iframe.loadSelTabsContent();
	}
}