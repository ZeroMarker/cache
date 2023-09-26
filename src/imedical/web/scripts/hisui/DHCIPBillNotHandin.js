/// DHCIPBillNotHandin.js

$(function() {
	init_Layout();

	setValueById('EndDate', getDefStDate(-1));
	
	$("#User").combobox({
		panelHeight: 200,
		url: $URL + '?ClassName=web.UDHCJFDailyHand&QueryName=FindCashier&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.hospId = session['LOGON.HOSPID'];
		},
		onChange: function (newValue, oldValue) {
			setValueById("UserId", (newValue || ""));
		}
	});
});

function init_Layout() {
	$('td.i-tableborder>table').css("border-spacing", "0px 8px");
	$('#cEndDate').parent().parent().css("width", "70px");
}