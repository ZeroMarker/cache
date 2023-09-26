/// dhcpha.seekpharetreqitmtoret.js

function BodyLoadHandler() {

	var obj = document.getElementById("RetReason");
	if (obj) {
		obj.onkeydown = popRetReason;
		obj.onblur = CheckRetReason;
	}
	var obj = document.getElementById("SelectAll")
	if (obj) obj.onclick = SelectAll;
	var obj = document.getElementById("SelectNone")
	if (obj) obj.onclick = SelectNone;

	var obj = document.getElementById("ExecuteReturn")
	if (obj) obj.onclick = ExecuteReturn;

	var obj = document.getElementById("t" + "dhcpha_seekpharetreqitmtoret")
    if (obj) {
		//obj.onkeydown=CheckRetFlag;
		obj.onmouseup = CheckRetQty;
		obj.onkeyup = CheckRetQty;
	}

    var obj = document.getElementById("print")
    if (obj) obj.onclick = PrintRetInfo;

    LoadRequestSum();
    SelectAll();

}
function LoadRequestSum() {
	var obj = document.getElementById("Tpid" + "z" + 1)
    if (obj) var pid = obj.value
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.seekpharetrequestsum=" +
		"&pid=" + pid
	parent.frames['dhcpha.seekpharetrequestsum'].location.href = lnk;
}
function SelectNone() {
	var rowcnt;
	var objtbl = document.getElementById("t" + "dhcpha_seekpharetreqitmtoret")
	if (objtbl) {
		rowcnt = getRowcount(objtbl)
	}
	if (rowcnt > 0) {
		for (i = 1; i <= rowcnt; i++) {
			var obj = document.getElementById("Select" + "z" + i)
			if (obj) obj.checked = false;
		}
	}
}

function SelectAll() {
	var rowcnt;
	var objtbl = document.getElementById("t" + "dhcpha_seekpharetreqitmtoret")
	if (objtbl) {
		rowcnt = getRowcount(objtbl)
	}
	if (rowcnt > 0) {
		for (i = 1; i <= rowcnt; i++) {
			var obj = document.getElementById("Select" + "z" + i)
			//if (obj) obj.checked=(!obj.checked) ;
			if (obj) obj.checked = true;
			///2012-09-28 注释 zhouyg 改为都可以修改但进行附加收费判断,20150106 zhouyg 修改，避免多次退药情况下无法退费
			/*var OECPRCode=DHCWeb_GetValue("TOECPRCodez"+i);
			if((OECPRCode!="OUT")&&(OECPRCode!="ONE"))
			{
				var obj=document.getElementById("TRetQty"+"z"+i)
				if (obj)
				{
					obj.readOnly=true;
				}
			}*/
			var PartFlag = DHCWeb_GetValue("TRetPartFlagz" + i);
			if (PartFlag == "0") {
				var obj = document.getElementById("TRetQty" + "z" + i);
				if (obj) {
					obj.readOnly = true; //20141219 zhouyg 改为有附加收费不允许修改
				}
			}
		}
	}
}

function SelectRowHandler() {
	var row = DHCWeb_GetRowIdx(window);
	var obj = document.getElementById("currentRow");
	if (obj) obj.value = row;

}
function popRetReason() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		RetReason_lookuphandler();
	}
}

function CheckRetReason() {
	var obj = document.getElementById("RetReason");
	var obj2 = document.getElementById("retreasonrowid");
	if (obj)
	{ if (obj.value == "") obj2.value = "" }

}

function UpdateQty() {
    var obj = document.getElementById("t" + "dhcpha_seekpharetreqitm")
    if (obj) {
		var rowcnt = getRowcount(obj)
		if (rowcnt <= 0) {
			alert(t['NO_ANY_ROW']);
			return;
		}
    }
    else {
		return;
	}
	var obj = document.getElementById("currentRow");
	if (obj) var currentRow = obj.value;
	if (currentRow <= 0) {
		alert(t['SELECT_ONEROW']);
		return;
	}
	var obj = document.getElementById("Status" + "z" + currentRow);
	if (obj) var status = obj.innerText
	if (status != "Prove") {
		alert(t['MODIFY_NOT_ALLOWED']);
		return;
	}
	//update qty
	var qty = window.prompt(t['INPUT_QTY'], "")
	if (qty == null) return;
	if (isNaN(qty)) {
		alert(t['NOT_VALID_NUMBER']);
		return;
	}

	var obj = document.getElementById("retrqrowid" + "z" + currentRow)
	if (obj) var retrq = obj.value;
	var obj = document.getElementById("mCheckAllowReturn");
	if (obj) { var encmeth = obj.value; } else { var encmeth = ''; }

	var result = cspRunServerMethod(encmeth, '', '', retrq, qty);
	if (result == 0) {
		alert(t['QTY_NOT_ALLOWED']);
		return;
	}

	var user = session['LOGON.USERID']
	var obj = document.getElementById("mUpdateQty");
	if (obj) { var encmeth = obj.value; } else { var encmeth = ''; }
	var result = cspRunServerMethod(encmeth, '', '', retrq, qty, user);
    if (result < 0) {
		alert['UPDATE_OK'];
		return;
    }
    else
    { alert['UPDATE_FAILED']; }

}

function DeleteReq() {
    var obj = document.getElementById("t" + "dhcpha_seekpharetreqitm")
    if (obj) {
		var rowcnt = getRowcount(obj)
		if (rowcnt <= 0) {
			alert(t['NO_ANY_ROW']);
			return;
		}
    }
    else {
		return;
	}
	var obj = document.getElementById("currentRow");
	if (obj) var currentRow = obj.value;
	if (currentRow <= 0) {
		alert(t['SELECT_ONEROW']);
		return;
	}
	var obj = document.getElementById("Status" + "z" + currentRow);
	if (obj) var status = obj.innerText
	if (status != "Prove") {
		alert(t['DEL_NOT_ALLOWED']);
		return;
	}

	var ret = confirm(t['REALLY_DEL']);
	if (ret == false) return;
	//
	var obj = document.getElementById("retrqrowid" + "z" + currentRow)
	if (obj) var retrq = obj.value;
	var obj = document.getElementById("mDelRetReq");
	if (obj) { var encmeth = obj.value; } else { var encmeth = ''; }

	var result = cspRunServerMethod(encmeth, '', '', retrq);

}
function RetReasonLookUpSelect(str) {
	var reason = str.split("^");
	if (reason.length > 0) {
		var reasonrowid = reason[1];
		var obj = document.getElementById("retreasonrowid");
		if (obj) {
			obj.value = reasonrowid;
		}
		else
			obj.value = "";
	}
}
function ExecuteReturn() {
	// the code for returning 
	// 1.save the return data
	// 2.handle the stock changing 

	//check the data
	var reasonid;
	//
	if (CheckBeforeExeReturn() == false) return;

	/*
 	// check reason
 	var obj=document.getElementById("retreasonrowid")
 	if (obj) reasonid=obj.value;
 	if (reasonid==""){
	 	alert(t['NO_RETREASON']) ;
	 	return ;  }
	*/
	var reasonid = ""
	//create the No of return ;
	// 
	//var RetNo=getRetNewNo();
	//if (RetNo=="") return ;
	//
	var h = 0;
	var rowcnt;
	var objtbl = document.getElementById("t" + "dhcpha_seekpharetreqitmtoret");
	if (objtbl) rowcnt = getRowcount(objtbl);

	var Reclocdr = "";
	if (rowcnt > 0) {
		var obj = document.getElementById("TRECLOCDR" + "z" + 1);
		if (obj) Reclocdr = obj.value
	}
	var UserDR = session['LOGON.USERID']
	var datastr = "";
	for (var i = 1; i <= rowcnt; i++) {
		var obj = document.getElementById("TRetQty" + "z" + i)
		if (obj) {
			var retqty = trim(obj.value);
			if (retqty == "") {
				alert("数量不能为空!")
				return;
			}
			if (retqty > 0) {
				var incicode=document.getElementById("TCodez"+i).value;
				var refrefuseflag=tkMakeServerCall("web.DHCST.ARCALIAS","GetRefReasonByCode",incicode);
				if (refrefuseflag!=""){
					if (refrefuseflag.split("^")[3]!=""){
						alert("第"+i+"行药品"+refrefuseflag.split("^")[1]+",在药品基础数据中目前为不可退药状态,不能申请!\n不可退药原因:"+refrefuseflag.split("^")[3]);
						canreq=4;
						return;
					}			
				}
				var obj = document.getElementById("Select" + "z" + i)
				if (obj.checked == true) {
					var obj = document.getElementById("Tretrqrowid" + "z" + i);
					if (obj) var RetRqDR = obj.value;
					var obj = document.getElementById("TRetQty" + "z" + i);
					if (obj) var Qty = trim(obj.value);
					if (datastr == "") {
						datastr = RetRqDR + "^" + Qty;
					}
					else {
						datastr = datastr + "," + RetRqDR + "^" + Qty;
					}
					h = h + 1;
				}
			}
		}
	}

    if (h == 0) { return; }
    var RetNo = "";
	var execRet = document.getElementById('mExecuteReturn');
	if (execRet) { var encmeth = execRet.value } else { var encmeth = '' };
	var result = cspRunServerMethod(encmeth, '', '', Reclocdr, UserDR, 'RT', datastr)
	var msg = result.split(",");
	//alert(result)
	if (msg[0] == "failure") {
		if (msg[1] == -3) {  //alert(desc+" "+"不允许退药:退药数量超过发药数量,或未发药") ;
			alert("不允许退药:退药数量超过发药数量,或未发药");

		} else if (msg[1] == -2) {
			alert("存在申请记录已经退药或拒绝退药!");

		} else if (msg[1] == -4) {
			alert("患者已最终结算,不允许退药,请联系结算处");
		}
		else if (msg[1] == -5) {
			alert("保存退药明细失败");
		}
		else if ((msg[1] == -6)) {
			alert("更新申请单状态失败");
		}
		else if ((msg[1] == -7)) {
			alert("审核退药单失败");
		}
		else if ((msg[1] == -10)) {
			alert("有附加收费项目执行记录不允许部分退药");
		}
		else if ((msg[1] == -11)) {
			alert("不允许退药:已经中途结算,不能退药!");
		}
		else if (msg[1] != 0) {
			alert("退药失败:" + result);

		}

		return;
	}
	else {
		RetNo = msg[1];
		alert(t['SAVE_SUCCEED']);
	}
    //sendMessageToHX(RetNo);   ///Description: 传退药数量至华西老HIS



	//if auditing process is needed,execute the following statemetns,or remove it ....
	//RetAuditAfterSave(RetNo)      //华西二院不需要审核
	//
	if (confirm(t['ASKPRINT']) == true) {
		var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.printphareturn&PhaRetNo=" + RetNo
		parent.frames['dhcpha.printphareturn'].window.document.location.href = lnk;
	}
	refreshDisplayAfterSave();
}
function CheckBeforeExeReturn() {
	var rowcnt;
	var objtbl = document.getElementById("t" + "dhcpha_seekpharetreqitmtoret");
	if (objtbl) rowcnt = getRowcount(objtbl);
	if (rowcnt < 1) {
		alert(t['NO_ROWS']);
		return false;
	}

	for (var i = 1; i <= rowcnt; i++) {
		var obj = document.getElementById("Select" + "z" + i)
		if (obj.checked == true) return true;
	}
	alert(t['NO_SELECTED']);
	return false;
}

function sendMessageToHX(RetNo) {
	///description:传退药数量至华西老HIS

	var obj = document.getElementById("SendMssage");
	if (obj) { var encmeth = obj.value; } else { var encmeth = ''; }
	var message = cspRunServerMethod(encmeth, RetNo);

}

function getRetNewNo() {
	//create and get return No 
    var getRetNo = document.getElementById('mCreateRetNo');
	if (getRetNo) { var encmeth = getRetNo.value } else { var encmeth = '' };
	var newRetNo = cspRunServerMethod(encmeth, '', '', 'RT')
	if (newRetNo == "") {
		alert(t['CANNOT_CREATENO']);
		return "";
	}
	return newRetNo
}
function refreshDisplayAfterSave() {
	var obj = document.getElementById("RetReqNo")
	var RetReqNo = obj.value;
	location.href = "websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.seekpharetreqitmtoret&RetReqNo=" + RetReqNo;
}

function RetAuditAfterSave(retno) {
	var ret = confirm(t['IF_AUDIT'])
	if (ret == false) return;
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.pharetaudit&RetNo=" + retno
	window.showModalDialog(lnk, "_target", "windth=500,height=100")

}
function CheckRetQty(e) {
	var obj = websys_getSrcElement(e)
	var selindex = obj.id;
	var reqqty = 0;
	var retqty = 0;
	var ss
	ss = selindex.split("z")
	if (ss.length > 0) {
		if (ss[0] == "TRetQty") {
			var row = ss[1];
			var objretqty = document.getElementById("TRetQty" + "z" + row);
			if (objretqty) retqty = objretqty.innerText;
			var objreqqty = document.getElementById("TSurqty" + "z" + row); //document.getElementById("TQty"+"z"+row) ;
			var objdodis = document.getElementById("TDodis" + "z" + row);
			var objRetPartFlag = document.getElementById("TRetPartFlag" + "z" + row);
			if (objreqqty) reqqty = objreqqty.innerText;
			var dspid = "";
			if (objdodis) {
				dspid = objdodis.value;
			}

			if (objRetPartFlag) {
				if (objRetPartFlag.value == "0") {
					alert("此记录有附加收费项目，不允许修改退药数量!")
					objretqty.value = reqqty;
					objretqty.readOnly = true;
					return;
				}
			}
			var PartFlag = CheckRetPart(dspid)
			if (PartFlag == "0") {
				alert("此记录有附加收费项目，不允许修改退药数量!")
				objretqty.value = reqqty;
				objretqty.readOnly = true;
				return;
			}
			/*
			var IfONE=CheckPrioirty(dspid);
			if((IfONE!=1)&&(parseFloat(reqqty)!=parseFloat(retqty)))
			{
				alert("只有取药医嘱和出院带药才能修改退药数量！");
				objretqty.value=reqqty;
				objretqty.readOnly=true;
				return ;
			}*/
			if (objretqty) {
				//retqty=objretqty.value;
				if (isNaN(objretqty.value)) {
				objretqty.value = ""
					alert("非法数字!")
					return;
				}
			}
			if (objreqqty) {
				if (parseFloat(objreqqty.innerText) < parseFloat(objretqty.value)) {
					objretqty.value = ""
					alert("退药数量大于未退数量，请修改!")
					return;
				}

			}

		}

	   }

}
///是否允许部分退药
///1-可以修改退药，0-不可以修改退药
function CheckRetPart(dodis) {
	var objmPartFlag = document.getElementById("mGetRetPartFlag");
	if (objmPartFlag) { var encmeth = objmPartFlag.value; } else { var encmeth = ''; }
	var Retflag = cspRunServerMethod(encmeth, dodis);     //是否取药医嘱
	return Retflag;
}

function CheckPrioirty(dodis) {
	var objPriority = document.getElementById("mCheckPriority");
	if (objPriority) { var encmeth = objPriority.value; } else { var encmeth = ''; }
	var oneflag = cspRunServerMethod(encmeth, dodis)     //是否取药医嘱
	return oneflag
}

function PrintRetInfo() {
	var obj = document.getElementById("RetReqNo")
	if (obj) var RetReqNo = obj.value;
	if (RetReqNo == "") return;
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.printphareturn&RetReqNo=" + RetReqNo
	parent.frames['dhcpha.printphareturn'].window.document.location.href = lnk;
}
document.body.onload = BodyLoadHandler;