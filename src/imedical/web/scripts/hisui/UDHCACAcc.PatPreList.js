/// ﻿UDHCACAcc.PatPreList.js

$(function() {
	$("#tUDHCACAcc_PatPreList").datagrid("load", {
		ClassName: "web.UDHCAccAddDeposit",
		QueryName: "AccDepDetail",
		AccMRowID: getValueById("AccMRowID"),
		HospId: getValueById("HospId")
	});
});