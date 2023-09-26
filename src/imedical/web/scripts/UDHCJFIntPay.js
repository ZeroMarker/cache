///UDHCJFIntPay.js

var BillNo, Guser, stdate, enddate, sttime, endtime, locid;
var ordcatobj, ordsubcatobj, arcitemobj, orderobj;
var ordcatidobj, ordsubcatidobj, arcitemidobj, orderidobj, orddateobj;
var ordcatstr, ordsubcatstr, arcitemstr, orderstr;
var SelectedRow = "-1";

function BodyLoadHandler() {
	Guser = session['LOGON.USERID'];
	//billno = document.getElementById('billno').value;
	var obj = document.getElementById("Collect");
	if (obj) {
		obj.onclick = Col_click;
	}
	var obj = document.getElementById("CreatBill");
	if (obj) {
		obj.onclick = Create_click;
	}
	var obj = document.getElementById("Add");
	if (obj) {
		obj.onclick = Add_click;
	}
	var obj = document.getElementById("Delete");
	if (obj) {
		obj.onclick = Delete_click;
	}
	ordcatobj = document.getElementById("ordcat");
	ordcatidobj = document.getElementById("ordcatid");
	ordsubcatobj = document.getElementById("ordsubcat");
	ordsubcatidobj = document.getElementById("ordsubcatid");
	arcitemobj = document.getElementById("arcitem");
	arcitemidobj = document.getElementById("arcitemid");
	orderobj = document.getElementById("order");
	orderidobj = document.getElementById("orderid");
	orddateobj = document.getElementById("orddate");
	ordcatobj.onkeyup = clearordcatid;
	ordsubcatobj.onkeyup = clearordsubcatid;
	arcitemobj.onkeyup = cleararcitemid;
	orderobj.onkeyup = clearorderid;

	var locObj = document.getElementById('loc');
	if (locObj) {
		locObj.onchange = LocOnChange;
	}
}

function LocOnChange() {
}

function Col_click() {
	//compute
	var Flag;
	var BabyAdm;
	stdate = document.getElementById('stdate').value;
	enddate = document.getElementById('enddate').value;
	sttime = document.getElementById('sttime').value;
	endtime = document.getElementById('endtime').value;

	var loc = document.getElementById('loc').value;
	if (loc == "") {
		locid = "";
	} else {
		locid = document.getElementById('locid').value;
	}
	BillNo = document.getElementById('BillNo').value;
	BabyAdm = document.getElementById('BabyAdm').value;
	if (document.getElementById('Flag').checked) {
		Flag = 1;
	} else {
		Flag = 0;
	}
	//按临床药理试验拆分医嘱标志
	var IsPilotFlag = 0;
	var pilotFlagObj = document.getElementById('IsPilotFlag');
	if ((pilotFlagObj) && (pilotFlagObj.checked)) {
		IsPilotFlag = 1;
	} else {
		IsPilotFlag = 0;
	}
	Getorder();
	var encmeth = DHCWebD_GetObjValue('col');
	var sum = cspRunServerMethod(encmeth, BillNo, stdate, enddate, ordcatstr, ordsubcatstr, arcitemstr, orderstr, sttime, endtime, locid, Flag, BabyAdm, IsPilotFlag);

	var obj = document.getElementById('sum');
	obj.value = sum;
}

function Create_click() {
	var Flag;
	var BabyAdm;
	stdate = document.getElementById('stdate').value;
	enddate = document.getElementById('enddate').value;
	sttime = document.getElementById('sttime').value;
	endtime = document.getElementById('endtime').value;
	var loc = document.getElementById('loc').value;
	if (loc == "") {
		locid = "";
	} else {
		locid = document.getElementById('locid').value;
	}
	BillNo = document.getElementById('BillNo').value;
	BabyAdm = document.getElementById('BabyAdm').value;
	if (document.getElementById('Flag').checked) {
		Flag = 1;
	} else {
		Flag = 0;
	}

	//按临床药理试验拆分医嘱标志
	var IsPilotFlag = 0;
	var pilotFlagObj = document.getElementById('IsPilotFlag');
	if ((pilotFlagObj) && (pilotFlagObj.checked)) {
		IsPilotFlag = 1;
	} else {
		IsPilotFlag = 0;
	}
	sum = DHCWebD_GetObjValue('sum');         //金额
	IntAmt = document.getElementById('IntAmt').value;   //指定金额
	var ChargeAmt = IntAmt - sum;
	ChargeAmt = Math.abs(ChargeAmt);
	if (+sum == 0) {
		alert("请先收集金额");
		return;
	}else {
		var jsonStr = tkMakeServerCall("web.DHCBillCommon", "GetClsPropValById", "User.DHCPatientBill", BillNo);
		var jsonObj = eval("(" + jsonStr + ")");
		if ((ChargeAmt == sum) && (sum == jsonObj.PBTotalAmount)) {
			alert("没有可拆的账单");
			return;
		}
	}
	if ((IntAmt != "") && (IntAmt != 0)) {
		var crtn = checkMoneyFormat(IntAmt);
		if (crtn == false) {
			alert("请填写数字!");
			document.getElementById('IntAmt').value = "";
			return;
		}
		var jrtn = tkMakeServerCall("web.UDHCJFIntBill", "JudgeINTBILLARC");
		if (jrtn == 0) {
			alert("没有维护指定价格自定价医嘱,不能按照指定金额拆分账单!");
			document.getElementById('IntAmt').value = "";
			return;
		}
		var pbsum = tkMakeServerCall("web.UDHCJFORDCHK", "getpatsharebypb", BillNo);
		if ((pbsum == 0) || (pbsum == "")) {
			alert("账单不存在或金额为0,不能按照指定金额拆分账单!");
			document.getElementById('IntAmt').value = "";
			return;
		} else {
			var pbsum = pbsum.split("^")[0];
			pbsum = eval(pbsum);
			if ((IntAmt > pbsum)) {
				alert("指定金额大于账单总金额,不能按照指定金额拆分账单!");
				document.getElementById('IntAmt').value = "";
				return;
			}
		}
	}
	if ((ChargeAmt > 10) && (IntAmt != "") && (IntAmt != 0) && (sum != "") && (sum != 0)) {
		alert("收集金额与拆分金额相差过大,请重新收集金额");
		return;
	}
	var datestr = stdate + "^" + enddate + "^" + sttime + "^" + endtime;
	Getorder();
	var Expstr = sum + "^" + IntAmt;
	var encmeth = DHCWebD_GetObjValue('create');
	var retval = cspRunServerMethod(encmeth, BillNo, datestr, "", Guser, "", ordcatstr, ordsubcatstr, arcitemstr, orderstr, locid, Flag, BabyAdm, IsPilotFlag, Expstr);
	var retval = retval.split("^");
	//alert(retval);
	var err = retval[0];
	if (err == 0) {
		alert(t['02'] + "拆分账单后请注意进行封账,否则不允许账单!");
		//modify 2015-2-28 hujunbin 新住院收费中途结算后跳转
		if (window.parent && window.parent.document.getElementById('chargeTabs')) {
			window.parent.setDefTabFromIframe();
		} else {
			window.opener.Find.click();
			window.close();
		}
	} else {
		alert(t['01']);
		return;
	}
}

function Add_click() {
	if (ordcatidobj.value == "" && ordsubcatidobj.value == "" && arcitemidobj.value == "" && orderidobj.value == "") {
		return false;
	}
	Addtabrow();
	//clearval();
}

function Addtabrow() {
	var objtbl = document.getElementById('tUDHCJFIntPay');
	tAddRow(objtbl);
	var rows = objtbl.rows.length;
	var LastRow = rows - 1;
	var Row = LastRow;
	if (orderidobj.value != "") {
		var Torderid = document.getElementById("Torderidz" + Row);
		Torderid.innerText = orderidobj.value;
		var Torder = document.getElementById("Torderz" + Row);
		Torder.innerText = orderobj.value;
		var Torddate = document.getElementById("Torddatez" + Row);
		Torddate.innerText = orddateobj.value;
		var Tarcitemid = document.getElementById("Tarcitemidz" + Row);
		Tarcitemid.innerText = "";
		var Tordsubcatid = document.getElementById("Tordsubcatidz" + Row);
		Tordsubcatid.innerText = "";
		var Tordcatid = document.getElementById("Tordcatidz" + Row);
		Tordcatid.innerText = "";
		orderidobj.value = "";
		orderobj.value = "";
		orddateobj.value = "";
		return;
	}
	if (arcitemidobj.value != "") {
		var Tarcitemid = document.getElementById("Tarcitemidz" + Row);
		Tarcitemid.innerText = arcitemidobj.value;
		var Tarcitem = document.getElementById("Tarcitemz" + Row);
		Tarcitem.innerText = arcitemobj.value;
		var Torderid = document.getElementById("Torderidz" + Row);
		Torderid.innerText = "";
		var Tordsubcatid = document.getElementById("Tordsubcatidz" + Row);
		Tordsubcatid.innerText = "";
		var Tordcatid = document.getElementById("Tordcatidz" + Row);
		Tordcatid.innerText = "";
		arcitemidobj.value = "";
		arcitemobj.value = "";
		return;
	}
	if (ordsubcatidobj.value != "") {
		var Tordsubcatid = document.getElementById("Tordsubcatidz" + Row);
		Tordsubcatid.innerText = ordsubcatidobj.value;
		var Tordsubcat = document.getElementById("Tordsubcatz" + Row);
		Tordsubcat.innerText = ordsubcatobj.value;
		var Torderid = document.getElementById("Torderidz" + Row);
		Torderid.innerText = "";
		var Tarcitemid = document.getElementById("Tarcitemidz" + Row);
		Tarcitemid.innerText = "";
		var Tordcatid = document.getElementById("Tordcatidz" + Row);
		Tordcatid.innerText = "";
		ordsubcatidobj.value = "";
		ordsubcatobj.value = "";
		return;
	}
	if (ordcatidobj.value != "") {
		var Tordcatid = document.getElementById("Tordcatidz" + Row);
		Tordcatid.innerText = ordcatidobj.value;
		var Tordcat = document.getElementById("Tordcatz" + Row);
		Tordcat.innerText = ordcatobj.value;
		var Torderid = document.getElementById("Torderidz" + Row);
		Torderid.innerText = "";
		var Tarcitemid = document.getElementById("Tarcitemidz" + Row);
		Tarcitemid.innerText = "";
		var Tordsubcatid = document.getElementById("Tordsubcatidz" + Row);
		Tordsubcatid.innerText = "";
		ordcatidobj.value = "";
		ordcatobj.value = "";
		return;
	}
}

function tAddRow(objtbl) {
	tk_ResetRowItemst(objtbl);
	var row = objtbl.rows.length;
	var objlastrow = objtbl.rows[row - 1];
	//make sure objtbl is the tbody element
	objtbl = websys_getParentElement(objlastrow);
	var objnewrow = objlastrow.cloneNode(true);
	var rowitems = objnewrow.all;    //IE only
	if (!rowitems) {
		rowitems = objnewrow.getElementsByTagName("*"); //N6
	}
	for (var j = 0; j < rowitems.length; j++) {
		if (rowitems[j].id) {
			var Id = rowitems[j].id;
			var arrId = Id.split("z");
			arrId[arrId.length - 1] = row;
			rowitems[j].id = arrId.join("z");
			rowitems[j].name = arrId.join("z");
			rowitems[j].value = "";
		}
	}
	objnewrow = objtbl.appendChild(objnewrow);
	if ((objnewrow.rowIndex) % 2 == 0) {
		objnewrow.className = "RowOdd";
	} else {
		objnewrow.className = "RowEven";
	}
}

function Delete_click() {
	var objtbl = document.getElementById('tUDHCJFIntPay');
	var rows = objtbl.rows.length;
	var lastrowindex = rows - 1;
	if (SelectedRow == "-1") {
		return;
	}
	if (lastrowindex == SelectedRow) {
		return;
	}
	objtbl.deleteRow(SelectedRow);
	tk_ResetRowItemst(objtbl);
	SelectedRow = "-1";
}

function tk_ResetRowItemst(objtbl) {
	for (var i = 0; i < objtbl.rows.length; i++) {
		var objrow = objtbl.rows[i]; {
			if ((i + 1) % 2 == 0) {
				objrow.className = "RowEven";
			} else {
				objrow.className = "RowOdd";
			}
		}
		var rowitems = objrow.all; //IE only
		if (!rowitems) {
			rowitems = objrow.getElementsByTagName("*"); //N6
		}
		for (var j = 0; j < rowitems.length; j++) {
			//alert(i+":"+j+":"+rowitems[j].id);
			if (rowitems[j].id) {
				var arrId = rowitems[j].id.split("z");
				//if (arrId[arrId.length-1]==i+1) break;   //break out of j loop
				arrId[arrId.length - 1] = i + 1;
				rowitems[j].id = arrId.join("z");
				rowitems[j].name = arrId.join("z");
			}
		}
	}
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	Objtbl = document.getElementById('tUDHCJFIntPay');
	Rows = Objtbl.rows.length;
	var lastrowindex = Rows - 1;
	var RowObj = getRow(eSrc);
	var selectrow = RowObj.rowIndex;
	if (lastrowindex == selectrow) {
		SelectedRow = "-1";
		return;
	}
	if (selectrow != SelectedRow) {
		SelectedRow = selectrow;
	} else {
		SelectedRow = "-1";
	}
}

function Getorder() {
	ordcatstr = "";
	ordsubcatstr = "";
	arcitemstr = "";
	orderstr = "";
	Objtbl = document.getElementById('tUDHCJFIntPay');
	Rows = Objtbl.rows.length - 1;
	var tmpstr;
	for (i = 2; i <= Rows; i++) {
		var Tordcatid = document.getElementById("Tordcatidz" + i);
		tmpstr = Tordcatid.innerText;
		if (tmpstr) {
			ordcatstr = ordcatstr + "^" + tmpstr;
			continue;
		}
		var Tordsubcatid = document.getElementById("Tordsubcatidz" + i);
		tmpstr = Tordsubcatid.innerText;
		if (tmpstr) {
			ordsubcatstr = ordsubcatstr + "^" + tmpstr;
			continue;
		}
		var Tarcitemid = document.getElementById("Tarcitemidz" + i);
		tmpstr = Tarcitemid.innerText;
		if (tmpstr) {
			arcitemstr = arcitemstr + "^" + tmpstr;
			continue;
		}
		var Torderid = document.getElementById("Torderidz" + i);
		tmpstr = Torderid.innerText;
		if (tmpstr) {
			orderstr = orderstr + "^" + tmpstr;
			continue;
		}
	}
	return;
}

function GetorderOLD() {
	ordcatstr = "";
	ordsubcatstr = "";
	arcitemstr = "";
	orderstr = "";
	Objtbl = document.getElementById('tUDHCJFIntPay');
	Rows = Objtbl.rows.length - 1;
	var tmpstr;
	for (i = 2; i <= Rows; i++) {
		var Tordcatid = document.getElementById("Tordcatidz" + i);
		tmpstr = Tordcatid.innerText;
		if (tmpstr) {
			ordcatstr = ordcatstr + " " + tmpstr;
			continue;
		}
		var Tordsubcatid = document.getElementById("Tordsubcatidz" + i);
		tmpstr = Tordsubcatid.innerText;
		if (tmpstr) {
			ordsubcatstr = ordsubcatstr + " " + tmpstr;
			continue;
		}
		var Tarcitemid = document.getElementById("Tarcitemidz" + i);
		tmpstr = Tarcitemid.innerText;
		if (tmpstr) {
			arcitemstr = arcitemstr + " " + tmpstr;
			continue;
		}
		var Torderid = document.getElementById("Torderidz" + i);
		tmpstr = Torderid.innerText;
		if (tmpstr) {
			orderstr = orderstr + " " + tmpstr;
			continue;
		}
	}
	return;
}

function clearval() {
	ordcatobj.value = "";
	ordsubcatobj.value = "";
	arcitemobj.value = "";
	orderobj.value = "";
	ordcatidobj.value = "";
	ordsubcatidobj.value = "";
	arcitemidobj.value = "";
	orderidobj.value = "";
	orddateobj.value = "";
}

function getordcatid(value) {
	var val = value.split("^");
	ordcatidobj.value = val[1];
}

function getordsubcatid(value) {
	var val = value.split("^");
	ordsubcatidobj.value = val[1];
}

function getarcitemid(value) {
	var val = value.split("^");
	arcitemidobj.value = val[1];
}

function getorderid(value) {
	var val = value.split("^");
	orderidobj.value = val[1];
	orddateobj.value = val[2];
}

function clearordcatid() {
	ordcatidobj.value = "";
}

function clearordsubcatid() {
	ordsubcatidobj.value = "";
}

function cleararcitemid() {
	arcitemidobj.value = "";
}

function clearorderid() {
	orderidobj.value = "";
	orddateobj.value = "";
}

function Getlocid(value) {
	var val = value.split("^");
	var obj = document.getElementById('locid');
	obj.value = val[1];
}

function checkMoneyFormat(val) {
	var reg = /^(([0-9]+)|([0-9]+\.[0-9]{1,2}))$/;
	var isMoneyFormatRight = reg.test(val);
	return isMoneyFormatRight;
}

document.body.onload = BodyLoadHandler;
