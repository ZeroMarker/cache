/**
 * FileName: dhcbill.opbill.workload.js
 * Author: LUANZH
 * Date: 2023-03-1
 * Description: �����շ�Ա������ͳ��
 */

$(function () {
	initQueryMenu();
});

function initQueryMenu() {
	$(".datebox-f").datebox("setValue", CV.DefDate);
	setValueById('stTime', '00:00:00');
	setValueById('endTime', '23:59:59');
	
	$HUI.linkbutton("#btnFind", {
		onClick: function () {
			loadSelDetails();
		}
	});
	
	$HUI.combobox("#userCombo", {
		panelHeight: 180,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryInvUser&ResultSetType=array&invType=O&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		blurValidValue: true
	});

	$HUI.combobox('#selType', {
		panelHeight: 'auto',
		editable: false,
		valueField: 'id',
		textField: 'text',
		data: [{id: 'N', text: $g('��Ȼ��'), selected:true},
		       {id: 'Y', text: $g('������')}
		      ]
	});
}

/**
 * Creator: ZhYW
 * CreatDate: 2018-03-15
 * Description: ����iframeҳǩ��ϸ����
 */
function loadSelDetails() {
	var iframe = $("#tabMain")[0].contentWindow;
	if (iframe) {
		iframe.loadSelTabsContent();
	}
}
