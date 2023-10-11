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
	var width = $(window).width() * 0.8;
	var height  = $(window).height() * 0.8;
	DHCCPM_RQPrint(fileName, width, height);
}

function FindDetail() {
	var row = $HUI.datagrid("#tUDHCJFOPUnHandSearch").getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择一条记录", type: "info"});
		return;
	}
	var UserRowid = row.TUserRowid;
	var Job = row.Tjob;
	var url = 'websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCOPBillUnHanInvDetail&UserRowid=' + UserRowid + '&Job=' + Job;
	websys_showModal({
		url: url,
		title: '发票明细',
		iconCls: 'icon-w-list',
		width: '80%',
		height: '80%'
	});
}

function init_Layout() {
	$('td.i-tableborder>table').css("border-spacing", "0px 8px");
}