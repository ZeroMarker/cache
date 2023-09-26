/// UDHCJFOP.SFYWorkStat.js

$(function() {
	init_Layout();
	
	var defDate = getDefStDate(0);
	setValueById("StDate", defDate);
	setValueById("EndDate", defDate);
	setValueById("StartTime", "00:00:00");
	setValueById("EndTime", "23:59:59");
	$("#OperName").combobox({
		panelHeight: 180,
		url: $URL + '?ClassName=web.DHCJFOPworkstat9&QueryName=FindOPCashier&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.hospId = session['LOGON.HOSPID'];
		},
		onChange: function(newValue, oldValue) {
			setValueById("UserRowId", (newValue || ""));
		}
	});
	
	$("#BPrint").click(Print_Click);
});

function init_Layout() {
	$('.datagrid-sort-icon').text('');
	$('td.i-tableborder>table').css("border-spacing","0px 8px");
}

/// tangzf 2019-5-18
function Print_Click() {
	var StDate = getValueById("StDate");
	var EndDate = getValueById("EndDate");
	var StartTime = getValueById("StartTime");
	var EndTime = getValueById("EndTime");
	var UserRowId = getValueById("UserRowId");
	var HospId = getValueById("HospId");
	fileName = "DHCBILL-OPBILL-SFYGZLTJ.rpx" + "&UserRowId=" + UserRowId + "&StDate=" + StDate+ "&EndDate=" + EndDate+ "&StartTime=" + StartTime+ "&EndTime=" + EndTime;
	fileName += "&HospId=" + HospId;
	DHCCPM_RQPrint(fileName, 1200, 750);
}