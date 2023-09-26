//UDHCJFBillNum
var SelectedRow = 0;
var BillNo = "", Adm, flag;
var detailobj, qdobj, guser, admreason
function BodyLoadHandler() {
	gusername = session['LOGON.USERNAME']
		detailobj = document.getElementById("Print");
	if (detailobj)
		detailobj.onclick = Printdetail;
	qdobj = document.getElementById("Printqd");
	if (qdobj)
		qdobj.onclick = Printqd;
	var Admobj = document.getElementById("Adm");
	Adm = Admobj.value;
	guser = session['LOGON.USERID']
		getpatinfo()
}
function Printdetail() {
	flag = "detail"
		Print()
}
function Printqd() {
	flag = "qd"
		Print()
}
function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	var Objtbl = document.getElementById('tUDHCJFBillNum');
	var Rows = Objtbl.rows.length;
	var lastrowindex = Rows - 1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow)
		return;
	var SelRowObj = document.getElementById('Tbillnoz' + selectrow);
	BillNo = SelRowObj.innerText;
	document.getElementById("BillNo").value = BillNo;
	SelectedRow = selectrow;
}
function Print() {
	if ((Adm == "")||(BillNo == "")) {
		alert(t['billno']);
		return;
	}
	if (Adm != "") { //var WshNetwork = new ActiveXObject("WScript.NetWork");
		//var computername=WshNetwork.ComputerName;
		//var getbill=document.getElementById('getbill');
		//if (getbill) {var encmeth=getbill.value} else {var encmeth=''};
		//var num=cspRunServerMethod(encmeth,'','',Adm,guser,BillNo,computername)
		//if (num=='0')
		//{
		if (BillNo == "") {
			alert(t['billno']);
			return;
		}
		if (flag == "detail") {
			var str = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFBillDetail&BillNo=' + BillNo
				window.open(str, '_blank', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=780,height=520,left=0,top=0')
		}
		if (flag == "qd") {
			if (admreason == t['ybdesc']) {
				CommonPrint('UDHCJFIPcybrjsqdyh')
			} else {
				CommonPrint('UDHCJFIPcybrjsqd')
			}
		}
		//}
	}
}
function getpatinfo() {
	var infro = document.getElementById('getpatinfo');
	if (infro) {
		var encmeth = infro.value
	} else {
		var encmeth = ''
	};
	var returnvalue = cspRunServerMethod(encmeth, "", "", Adm)
		var sub = returnvalue.split("^")
		admreason = sub[11]
}
document.body.onload = BodyLoadHandler;
