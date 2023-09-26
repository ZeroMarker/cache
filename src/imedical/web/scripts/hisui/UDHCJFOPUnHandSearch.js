/// UDHCJFOPUnHandSearch.js

$(function () {
	init_Layout();
	
	$HUI.linkbutton('#BPrint', {
		onClick: function () {
			PrtDetail();
		}
	});
	$HUI.linkbutton('#BFindDEtail', {
		onClick: function () {
			FindDetail();
		}
	});
	
	$("#UserName").combobox({
		panelHeight: 180,
		url: $URL + '?ClassName=web.DHCOPBillUnHand&QueryName=FindOPCashier&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.hospId = session['LOGON.HOSPID'];
		},
		onChange: function(newValue, oldValue) {
			setValueById("UserDr", (newValue || ""));
		}
	});
});

function PrtDetail() {
	var UserId = getValueById("UserDr");
	var HospId = getValueById("HospId");
	var fileName = "DHCBILL-OPBILL-UnHandDetail.rpx&UserDr=" + UserId + "&HospId=" + HospId;
	DHCCPM_RQPrint(fileName, 1200, 800);
}

function FindDetail() {
	var row = $HUI.datagrid("#tUDHCJFOPUnHandSearch").getSelected();
	if (!row) {
		DHCWeb_HISUIalert("请选择一条记录");
		return;
	}
	var UserRowid = row.TUserRowid;
	var Job = row.Tjob;
	var str = 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCOPBillUnHanInvDetail&UserRowid=' + UserRowid + '&Job=' + Job;
	DHCWeb_initDatagrid("", "发票明细", "icon-w-list", "880", "580", str, "", "", 2);
}

function init_Layout() {
	$('td.i-tableborder>table').css("border-spacing", "0px 8px");
}