/// UDHCACFinBR.PFBQuery.js

$(function () {
	init_Layout();
	initQueryMenu();
});

function initQueryMenu() {
	var defDate = getDefStDate(-1);
	$(".datebox-f").datebox("setValue", defDate);
}

function init_Layout() {
	$("td.i-tableborder>table").css("border-spacing", "0px 9px");
}
