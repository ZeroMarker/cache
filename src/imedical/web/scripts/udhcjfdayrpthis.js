///udhcjfdayrpthis.js

var SelectedRow = 0;
var Guser, job;
function BodyLoadHandler() {
	job = document.getElementById('job').value;
	Guser = session['LOGON.USERID'];
}
function SelectRowHandler() {
	var stdate,
	enddate;
	var eSrc = window.event.srcElement;
	Objtbl = document.getElementById('tUDHCJFDayRptHis');
	Rows = Objtbl.rows.length;

	var lastrowindex = Rows - 1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow)
		return;

	SelRowObj = document.getElementById('RowIdz' + selectrow);
	stdate = document.getElementById('Tstdatez' + selectrow).innerText;
	enddate = document.getElementById('Tenddatez' + selectrow).innerText;
	stTime = document.getElementById('TStTimez' + selectrow).innerText;
	endTime = document.getElementById('TEndTimez' + selectrow).innerText;

	var year,
	mon,
	day;
	var str = stdate.split("-");
	year = str[0];
	mon = str[1];
	day = str[2];
	var jsrowid = SelRowObj.innerText;
	var flag = document.getElementById("findflag").value;
	if (flag == "YJ") {
		window.opener.parent.frames('UDHCJFDepositSearch').document.getElementById("stdate").value = stdate;
		window.opener.parent.frames('UDHCJFDepositSearch').document.getElementById("enddate").value = enddate;
		window.opener.parent.frames('UDHCJFDepositSearch').document.getElementById("guser").innerText = Guser;
		window.opener.parent.frames('UDHCJFDepositSearch').document.getElementById("job").innerText = job;
		window.opener.parent.frames('UDHCJFDepositRpt').location.href = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFDepositRpt&stdate=" + stdate + "&enddate=" + enddate + "&handin=" + "N" + "&Guser=" + Guser + "&jsflag=" + "Y" + "&jkdr=" + jsrowid + "&flag=" + "1" + "&job=" + job;
	} else if (flag == "FP") {
		window.opener.parent.frames('UDHCJFSearch').document.getElementById("stdate").value = stdate;
		window.opener.parent.frames('UDHCJFSearch').document.getElementById("enddate").value = enddate;

		window.opener.parent.frames('UDHCJFSearch').document.getElementById("JKStTime").value = stTime;
		window.opener.parent.frames('UDHCJFSearch').document.getElementById("JKEndTime").value = ""; /// endTime
		window.opener.parent.frames('UDHCJFSearch').document.getElementById("guser").innerText = Guser;
		window.opener.parent.frames('UDHCJFSearch').document.getElementById("job").innerText = job;
		window.opener.parent.frames('UDHCJFSearch').document.getElementById("jkdr").innerText = jsrowid;
		window.opener.parent.frames('UDHCJFdayInvRpt').location.href = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFdayInvRpt&stdate=" + stdate + "&enddate=" + enddate + "&handin=" + "" + "&Guser=" + Guser + "&jsflag=" + "Y" + "&jkdr=" + jsrowid + "&flag=" + "1" + "&job=" + job;
	} else {
		window.opener.parent.frames('UDHCJFSearch').document.getElementById("stdate").value = stdate;
		window.opener.parent.frames('UDHCJFSearch').document.getElementById("enddate").value = enddate;
		window.opener.parent.frames('UDHCJFSearch').document.getElementById("JKStTime").value = stTime;
		window.opener.parent.frames('UDHCJFSearch').document.getElementById("JKEndTime").value = endTime;
		window.opener.parent.frames('UDHCJFSearch').document.getElementById("guser").innerText = Guser;
		window.opener.parent.frames('UDHCJFSearch').document.getElementById("job").innerText = job;
		//window.opener.parent.frames('UDHCJFSearch').document.getElementById("jkdr").innerText=jsrowid;
		window.opener.parent.frames('UDHCJFDepositRpt').location.href = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFDepositRpt&stdate=" + stdate + "&enddate=" + enddate + "&handin=" + "N" + "&Guser=" + Guser + "&jsflag=" + "Y" + "&jkdr=" + jsrowid + "&job=" + job;
		//window.opener.parent.frames('UDHCJFdayInvRpt').location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFdayInvRpt&stdate="+stdate+"&enddate="+enddate+"&handin="+"Y"+"&Guser="+Guser+"&jsflag="+"Y"+"&jkdr="+jsrowid+"&job="+job;
		window.opener.parent.frames('UDHCJFdayInvRpt').location.href = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFdayInvRpt&stdate=" + stdate + "&enddate=" + enddate + "&handin=" + "" + "&Guser=" + Guser + "&jsflag=" + "Y" + "&jkdr=" + jsrowid + "&flag=" + "3" + "&job=" + job;

	}
	window.close();
	//
}
document.body.onload = BodyLoadHandler;