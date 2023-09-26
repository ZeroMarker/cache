//UDHCJFYjAcount.js
var Guser, flag, job, path, lastenddate, gusercode;
var jsstdate, jsenddate, acctrowid, jsflag, err;
var stdate, enddate,curdate;
var stdateobj, enddateobj;
function BodyLoadHandler() {

	stdateobj = document.getElementById('stdate');
	enddateobj = document.getElementById('enddate');
	
	var getstdate = document.getElementById('getstdate');
	if (getstdate) {
		var encmeth = getstdate.value;
	} else {
		var encmeth = '';
	};
	stdate = cspRunServerMethod(encmeth, "YJACOUNT");
	if (stdate == "") {
		alert(t['hxey01']);
		return;
	}
	lastenddate = stdate;

	
	Guser = session['LOGON.USERID'];
	gusercode = session['LOGON.USERCODE'];
	var obj = document.getElementById("Balance");
	if (obj)
		obj.onclick = Insert_click;
	var obj = document.getElementById("Print");
	if (obj)
		//obj.onclick = PrintDepAcount_click;
		obj.onclick = PrintdeptHZ_click;
	var obj = document.getElementById("PrtDetail");
	if (obj)
		obj.onclick = Printdept_click;
		

	var cancel = document.getElementById("btncancel");
	if (cancel) {
		cancel.onclick = Cancel_click;
	}
	gettoday();
	var jsflag = document.getElementById("jsflag");
	jsflag.onclick = gethandin_Click;
	if (jsflag.checked == false) {
		document.getElementById('stdate').value = stdate;
		NotHandinCheck();
	}
	var findobj = document.getElementById("Find");
	if (findobj) {
		findobj.onclick=Find_OcClick;
	}
}

function Find_OcClick(){
	var stdate = document.getElementById('stdate').value;
	var enddate = document.getElementById('enddate').value;
	//alert(stdate+","+enddate);
	Find_click();
}

function setdate() {
	var getstdate = document.getElementById('getstdate');
	if (getstdate) {
		var encmeth = getstdate.value;
	} else {
		var encmeth = '';
	};
	stdate = cspRunServerMethod(encmeth, "YJACOUNT");
	lastenddate = stdate;
	document.getElementById('stdate').value = stdate;
	// Find_click()
}
function Insert_click() {

	getdate();
	if (err == -1) {
		alert(t['jst06']);
		return;
	}
	if (err == -2) {
		alert("不能结算到当天.");
		return;
	}
	if (jsflag == "Y") {
		alert(t['jst05']);
		return;
	}
	if (stdate > enddate) { //alert(t['08'])
		//return
	}
	///alert(lastenddate + "  " + document.getElementById('stdate').value);
	if (lastenddate != document.getElementById('stdate').value) {
		alert(t['05']);
		document.getElementById('stdate').value = lastenddate;
		return;
	}
	var Add = document.getElementById('Add');
	if (Add) {
		var encmeth = Add.value;
	} else {
		var encmeth = '';
	};
	flag = "YJACOUNT";
	var SelRowObj = document.getElementById('Tjobz' + 1);
	job = SelRowObj.innerText;
	var rtn = cspRunServerMethod(encmeth, Guser, flag, job,session['LOGON.HOSPID']);

		if (rtn == '0') {
			alert(t['01']);
		} else {
			alert(t['02']+":"+rtn);
		}
}
function getpath() {
	var getpath = document.getElementById('getpath');
	if (getpath) {
		var encmeth = getpath.value;
	} else {
		var encmeth = '';
	};
	path = cspRunServerMethod(encmeth, '', '');
}
function Cancel_click() {
	getdate()
	var tmp = t['jst01'] + jsstdate + "--" + jsenddate + t['jst02']
		var truthBeTold = window.confirm(tmp);
	if (!truthBeTold) {
		return;
	}
	var cancel = document.getElementById('cancel');
	if (cancel) {
		var encmeth = cancel.value;
	} else {
		var encmeth = '';
	};
	var err = (cspRunServerMethod(encmeth, acctrowid))
	if (err == 0) {
		alert(t['jst03']);
		return
	} else {
		alert(t['jst04']+":"+err);
	}
}
function getdate() {
	stdate = document.getElementById('stdate').value;
	enddate = document.getElementById('enddate').value;
	var laststr = document.getElementById('getlastdate');
	if (laststr) {
		var encmeth = laststr.value;
	} else {
		var encmeth = '';
	};
	
	var laststr1 = (cspRunServerMethod(encmeth, "YJACOUNT", stdate, enddate));
	lastjsdate1 = laststr1.split("^");
	jsstdate = lastjsdate1[0];
	jsenddate = lastjsdate1[1];
	acctrowid = lastjsdate1[2];
	jsflag = lastjsdate1[3];
	err = lastjsdate1[4];
}
function gethandin_Click() {
	var handinobj = document.getElementById("jsflag");
	var handin = handinobj.checked;
	if (handin == true) {
		HandinCheck();
	 
	}
	if (handin == false) {
		
		NotHandinCheck();
		enddateobj.value = curdate;
	}

}
function gettoday() {
	var gettoday = document.getElementById('gettoday');
	if (gettoday) {
		var encmeth = gettoday.value
	} else {
		var encmeth = ''
	};

	if (cspRunServerMethod(encmeth, 'setdate_val', '', '') == '1') {};
}
function setdate_val(value) {
	curdate = value;
}
function getnotjkdate() {
	var getstdate = document.getElementById('getstdate');
	if (getstdate) {
		var encmeth = getstdate.value;
	} else {
		var encmeth = '';
	};
	document.getElementById('stdate').value = cspRunServerMethod(encmeth, "YJACOUNT");
}

function PrintdeptOld_click() {

	getpath()
	var xlApp,
	obook,
	osheet,
	xlsheet,
	xlBook,
	temp,
	str,
	vbdata,
	i,
	j,
	deposit,
	myData1;
	var Template;
	Template = path + "DHCIPBILL_BillDetailHBFP.xls";

	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet
		var flag = document.getElementById("jsflag").value;

	var SelRowObj = document.getElementById('Tjobz' + 1);
	job = SelRowObj.innerText;
	var getnum = document.getElementById('getprtnum');
	if (getnum) {
		var encmeth = getnum.value
	} else {
		var encmeth = ''
	};
	var num = cspRunServerMethod(encmeth, "YJACOUNT", job);
	var getprtinfo = document.getElementById('getprtinfo');
	if (getprtinfo) {
		var encmeth = getprtinfo.value;
	} else {
		var encmeth = '';
	};
	var prtinfo = cspRunServerMethod(encmeth, "YJACOUNT", job, num);

	var columns = prtinfo.split("^");

	var stdate = columns[0];
	var enddate = columns[2];
	var enddateobj = document.getElementById('enddate').value;
	var getprint = document.getElementById('getprint');
	if (getprint) {
		var encmeth = getprint.value;
	} else {
		var encmeth = '';
	};
	//alert(stdate+"^"+enddate);
	var YJStr = cspRunServerMethod(encmeth, stdate, "", enddate, "", "");
	var YJStr1 = YJStr.split("^");
	var job = YJStr1[0];

	if (job == -110) {
		alert("没有选择日期的余额帐.")
		return
	}
	var GetPrtNum = document.getElementById('PrtNum');
	if (GetPrtNum) {
		var encmeth = GetPrtNum.value
	} else {
		var encmeth = ''
	};
	var PrtNum = cspRunServerMethod(encmeth, job)
		PrtNum = eval(PrtNum)
		if (PrtNum == "")
			return

			xlsheet.cells(1, 1).value = "预交金明细帐"
				xlsheet.cells(2, 1) = "统计日期:" + YJStr1[2] + " " + "00:00:00" + "--" + " " + YJStr1[3] + " " + "23:59:59"

				var GetPrtData = document.getElementById('PrtData');
		if (GetPrtData) {
			var encmeth = GetPrtData.value
		} else {
			var encmeth = ''
		};

	for (i = 1; i <= PrtNum; i++) {
		var PrtData = cspRunServerMethod(encmeth, job, i)
			if (PrtNum != "") {
				var str = PrtData.split("^");
				xlsheet.cells(3 + i, 1) = str[0];
				xlsheet.cells(3 + i, 2) = str[1];
				xlsheet.cells(3 + i, 3) = str[2];
				xlsheet.cells(3 + i, 4) = str[3];
				xlsheet.cells(3 + i, 5) = str[4];
				xlsheet.cells(3 + i, 6) = str[5];
				xlsheet.cells(3 + i, 7) = str[6];
				xlsheet.cells(3 + i, 8) = str[7];
			}
	}
	var PrtNum1 = PrtNum - 1
		AddGrid(xlsheet, 0, 0, PrtNum, 2, 3, 1); //画格
	//xlsheet.cells(4+i,1).value=t['jst07']+gusercode
	//xlsheet.cells(4+i,6).value=t['jst09']
	//xlsheet.cells(4+i,7).value=curdate
	//xlsheet.cells(4+i,4).HorizontalAlignment=-4131
	/// xlsheet.cells(6+i,1).value=t['jst10']
	//xlsheet.cells(6+i,6).value=t['jst11']
	xlApp.Visible = true
		xlsheet.PrintPreview();
	xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null
}

function AddGrid(objSheet, fRow, fCol, tRow, tCol, xlsTop, xlsLeft) {
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(1).LineStyle = 1;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(2).LineStyle = 1;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(3).LineStyle = 1;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(4).LineStyle = 1;
}

function PrintdeptHZ_click(){
	
	var stdateobj = document.getElementById('stdate');
	var enddateobj = document.getElementById('enddate');
	var fileName = "DHCBILL-IPBILL-住院预交金账汇总.raq&stDate=" + stdateobj.value + "&endDate=" + enddateobj.value ;
	DHCCPM_RQPrint(fileName, 800, 500);
	
}

function Printdept_click(){
	
	var stdateobj = document.getElementById('stdate');
	var enddateobj = document.getElementById('enddate');
	var fileName = "DHCBILL-IPBILL-住院预交金账明细报表.raq&stDate=" + stdateobj.value + "&endDate=" + enddateobj.value ;
	DHCCPM_RQPrint(fileName, 800, 500);
	
}
function NotHandinCheck()
{
	var stdateobj = document.getElementById('stdate');
	var enddateobj = document.getElementById('enddate');
	var Myobj = document.getElementById('Myid');
	if (Myobj) {
		var imgname = "ld" + Myobj.value + "i" + "stdate";
		var stdateobj1 = document.getElementById(imgname);
		var imgname = "ld" + Myobj.value + "i" + "enddate";
		var enddateobj1 = document.getElementById(imgname);
	}
	getnotjkdate();
	if (stdateobj.value == "") {
	stdateobj.value = curdate;
	enddateobj.value = curdate;
	}
	
	stdateobj1.style.display = "none";
	//stdateobj.disabled=true;
	stdateobj.readOnly = true;
	stdateobj.onkeydown=function(){return false;};
	///2016-05-03 chenxi 查找历史结算记录时将结算按钮变亮
	var Balanceobj = document.getElementById("Balance");
	if (Balanceobj) {
	DHCWeb_AvailabilityBtnA(Balanceobj, Insert_click);
	}	
	
}
function HandinCheck()
{
	
	var stdateobj = document.getElementById('stdate');
	var enddateobj = document.getElementById('enddate');
	var Myobj = document.getElementById('Myid');
	if (Myobj) {
		var imgname = "ld" + Myobj.value + "i" + "stdate";
		var stdateobj1 = document.getElementById(imgname);
		var imgname = "ld" + Myobj.value + "i" + "enddate";
		var enddateobj1 = document.getElementById(imgname);
	}
	//stdateobj.value=curdate1
	//enddateobj.value=curdate1
	stdateobj1.style.display = "";
	stdateobj.readOnly = false;
	enddateobj1.style.display = "";
	enddateobj.readOnly = false;
	///2016-05-03 chenxi 查找历史结算记录时将结算按钮变灰
	var Balanceobj = document.getElementById("Balance");
	if (Balanceobj) {
		DHCWeb_DisBtn(Balanceobj);
	}
	var lastInfo=tkMakeServerCall("web.UDHCJFAcount","getlastAcctInfo","YJACOUNT",session['LOGON.HOSPID']);
	enddateobj.value=lastInfo.split("^")[0];
	stdateobj.value=lastInfo.split("^")[1];
	
	
}
document.body.onload = BodyLoadHandler;