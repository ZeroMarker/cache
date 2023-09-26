/**
 * FileName: dhcbill.ipbill.unusedeprcptlist.js
 * Anchor: ZhYW
 * Date: 2019-12-30
 * Description: 收费员未使用押金收据查询
 */

var GV = {
	RcptType: "I"  //票据类型
};

$(function () {
	//收费员
	$HUI.combobox("#guser", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCJFReceipt&QueryName=FindCashier&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		selectOnNavigation: false,
		onBeforeLoad: function (param) {
			param.type = GV.RcptType;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		onChange: function(newValue, oldValue) {
			GV.RcptList.load({
				ClassName: "web.UDHCJFReceipt",
				QueryName: "FindrcptNum",
				type: GV.RcptType,
				hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
				userId: newValue
			});
		}
	});
	
	GV.RcptList = $HUI.datagrid("#rcptList", {
		fit: true,
		striped: true,
		border: false,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		columns:[[{title: '收款员', field: 'TCashier', width: 150},
				  {title: '工号', field: 'TCasherNo', width: 150},
				  {title: '张数', field: 'TrcptNum', width: 150},
				  {title: '号段', field: 'TrcptNo', width: 600}
			]],
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCJFReceipt",
			QueryName: "FindrcptNum",
			type: GV.RcptType,
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
			userId: ""
		}
	});
});