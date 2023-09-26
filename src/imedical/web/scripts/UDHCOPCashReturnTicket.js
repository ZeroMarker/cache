/// UDHCOPCashReturnTicket.js

function BodyLoadHandler() {
	var PrtReDetailobj = document.getElementById("PrtReDetail");
	if (PrtReDetailobj) {
		PrtReDetailobj.onclick = PrtReDetail_click;
	}
	var PrtReHZobj = document.getElementById("PrtReHZ");
	if (PrtReHZobj) {
		PrtReHZobj.onclick = PrtReHZ_click;
	}
}

function getlookuserid(value) {
	var str = value.split("^");
	document.getElementById("LookUser").value = str[0];
	document.getElementById("LookUserid").value = str[1];
}

function PrtReDetail_click() {
	//格式:1. {报表名称.raq}没有参数调用
	//格式:2. {报表名称.raq(par1=val1;par2=val2)}有参数调用
	//a
	var stdate = document.getElementById('startDate').value;
	var enddate = document.getElementById('endDate').value;
	var MyUserid = document.getElementById("LookUserid").value;
	var MyUser = document.getElementById("LookUser").value;
	stdate = stdate.split("/");
	enddate = enddate.split("/");
	stdate = stdate[2] + "-" + stdate[1] + "-" + stdate[0];
	enddate = enddate[2] + "-" + enddate[1] + "-" + enddate[0];
	//var fileName="{DHCIPBILLUDHCJFSearch.raq(Guser="+Guser+";job="+job+")}"
	//b
	//从//a至//b中间?是拼写所要打印的报表和报表中的参数
	//DHCCPM_RQDirectPrint(fileName);// DHCCPM_RQDirectPrint是负责直接打印的js方法?js方法所在的位置,数据库/scripts/ DHCCPMRQCommon.js
	var fileName1 = "DHCOPBILLDHCOPCashReturnTicket.raq&StDate=" + stdate + "&EndDate=" + enddate + "&LookUserid=" + MyUserid + "LookUser" + MyUser;
	DHCCPM_RQPrint(fileName1);
}

function PrtReHZ_click() {
	//格式:1. {报表名称.raq}没有参数调用
	//格式:2. {报表名称.raq(par1=val1;par2=val2)}有参数调用
	//a
	var stdate = document.getElementById('startDate').value;
	var enddate = document.getElementById('endDate').value;
	//var MyUserid = document.getElementById("LookUserid").value;
	//var MyUser = document.getElementById("LookUser").value;
	stdate = stdate.split("/");
	enddate = enddate.split("/");
	stdate = stdate[2] + "-" + stdate[1] + "-" + stdate[0];
	enddate = enddate[2] + "-" + enddate[1] + "-" + enddate[0];
	//var fileName = "{DHCIPBILLUDHCJFSearch.raq(Guser="+Guser+";job="+job+")}"
	//b
	//从//a至//b中间?是拼写所要打印的报表和报表中的参数
	//DHCCPM_RQDirectPrint(fileName);// DHCCPM_RQDirectPrint是负责直接打印的js方法?js方法所在的位置,数据库/scripts/ DHCCPMRQCommon.js
	var fileName1 = "DHCOPBILLDHCOPCashReturnTicket1.raq&StDate=" + stdate + "&EndDate=" + enddate;
	DHCCPM_RQPrint(fileName1);
}

document.body.onload = BodyLoadHandler;