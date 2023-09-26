var listvar = new Array();
var queryTypeCode = document.getElementById("queryTypeCode").value;
var HospitalRowId = document.getElementById("HospitalRowId").value;
var mthgetvar = document.getElementById("getvar").value;
var str = cspRunServerMethod(mthgetvar, queryTypeCode, HospitalRowId)
var listvar = str.split("^");
var curRow = 0,
	tableRows = 1,
	accountInfo, prePlacerNo = "";
var PatientID;
if (!document.getElementsByClassName) {
	document.getElementsByClassName = function (className, element) {
		var children = (element || document).getElementsByTagName('*');
		var elements = new Array();
		for (var i = 0; i < children.length; i++) {
			var child = children[i];
			var classNames = child.className.split(' ');
			for (var j = 0; j < classNames.length; j++) {
				if (classNames[j] == className) {
					elements.push(child);
					break;
				}
			}
		}
		return elements;
	};
}

function BodyLoadHandler() {
	initHLYY();
	var td = document.getElementsByClassName("selectalltd");
	if (td.length > 0) {
		td[0].style.width = "50px"
	}
	SearchSubOrder();
	accountInfo = "!";
	var objtbl = document.getElementById('tDHCNurOPExec');

	var i = 0,
		ps = -1
	if (listvar.length > 1) {
		for (var j = 1; j < objtbl.rows(i).cells.length; j++) {
			var labl = objtbl.rows(i).cells(j).innerText;
			var lval = objtbl.rows(i).cells(j).Name;
			var index = -1;
			for (var k = 0; k < listvar.length; k++) {
				var inx = labl.indexOf(listvar[k], 0);
				//if(inx!=-1) index=1; //070308 rem
				if ((inx == 0) && (labl.length == listvar[k].length + 1)) {
					index = 1;
					break;
				} //ypz 070308
			}
			//alert(j+"/"+labl+"/"+index+"/"+lval+"/"+listvar);
			if (index == -1) {
				switch (labl) {
					case "合理用药 ":
						{

							if (hlyyFlag == 1) {
								break;
							} else {
								objtbl.rows(0).cells(j).style.display = "none";
								hidcol(j, objtbl); // hide col
							}
						}
					case t['val:select']:
						break;
					case "oeoriId ":
						break;
					case "EpisodeID ":
						break;
					case "placerCode ":
						break; //ypz placerno
					case "disposeStatCode ":
						break;
					case t['val:printFlag']:
						break; //printFlag:
					case "tmpSeqNo ":
						break;
					default:
						objtbl.rows(0).cells(j).style.display = "none";
						hidcol(j, objtbl); // hide col
				}
			}
		}
	}
	var labArray=[];
	for (i = 1; i < objtbl.rows.length; i++) {
		var eSrc = objtbl.rows[i];
		var RowObj = getRow(eSrc);
		insertHLYYLight(i);
		var item = document.getElementById("disposeStatCodez" + i);
		var notes = document.getElementById("notesz" + i).innerText;
		var method = document.getElementById("phcinDescz" + i).innerText;
		var ordstat = document.getElementById("ordStatDescz" + i).innerText; //"D/C (Discontinued)")
		//------xin-------
		var obj = document.getElementById('placerNoz' + i);
		if (obj) obj.onkeydown = ReplyKeydown; //ypz placer
		//obj.style.backgroundcolor="#00ff00";
		//obj.style.color="#00ff00";
		////if (i==1){obj.setfocus;}
		var objArcimDesc = document.getElementById("arcimDescz" + i);
		var labNo = document.getElementById("labNoz" + i).innerText;
		if (queryTypeCode.indexOf("JYD") > -1) {
			if(labArray.indexOf(labNo)<0){
				labArray.push(labNo);  
			}
		}
		//objArcimDesc.style.backgroundcolor="#00ff00";
		//objArcimDesc.style.color="#00ff00";
		//-----------xin end---------- 
		if (ordstat != t['var:dischOrder']) //discontinue
		{
			ps = MatchDemo(notes);
			if (ps != t['val:skinTest']) {
				ps = MatchDemo(method);
				//alert(method)
			}
		}
		//RowObj.className="Needless";
		//ypz 061113 for placerCode
		var objArcim = objArcimDesc.parentElement;
		var objPlacerCode = document.getElementById('placerCodez' + i);
		var placerCode = "";
		if (objPlacerCode) {
			placerCode = objPlacerCode.innerText;
		}
		var placerCodeColor = placerCode.replace(" ", "");
		if (placerCodeColor != "") {
			document.getElementById('arcimDescz' + i).parentElement.style.backgroundColor = placerCodeColor;
		}
		/*
		switch (placerCode) //ypz061113 (item.innerText)
		{
			case "A":
				objArcim.className = "Purple";
				break; //"Black"; break;
			case "C":
				objArcim.className = "Gray";
				break;
			case "R":
				objArcim.className = "Red";
				break; //objArcimDesc.style.color="Red";break;
			case "P":
				objArcim.className = "Fuchsia";
				break;
			case "Y":
				objArcim.className = "Yellow";
				break; //"#ffff80";objArcimDesc.style.FONTWEIGHT="bold";break;//"Yellow";break;
			case "G":
				objArcim.className = "Green";
				break;
			case "H":
				objArcim.className = "Black";
				break;
			case "B":
				objArcim.className = "Blue";
				break;
			case "W":
				objArcim.className = "White";
				break;
			case "O":
				objArcim.className = "Brown";
				break;
			case "Q":
				objArcim.className = "Orange";
				break;



			default: //"Exec"
		}
		*/
		//if (ps==t['val:skinTest']) RowObj.className="PSColor"; //skintest ypz 060618
		if (item.innerText.length > 3) RowObj.className = item.innerText;
		if(item.innerText=='SkinTestAbnorm') RowObj.className ="SkinTest";
		var objPlacerNo1 = document.getElementById('placerNoz1');
		if (item.innerText == "Temp") document.getElementById("seleitemz" + i).checked = true;
	}
	if (queryTypeCode.indexOf("JYD") > -1&&labArray.length>0) {
		var cLabCountObj=document.getElementById("cLabCount");
		if(cLabCountObj){
			cLabCountObj.style.display = "block";
			cLabCountObj.innerHTML="共<span style='color:red'>"+labArray.length+"</span>个标本";
		}
	}
	var objSelectAll = document.getElementById("SelectAll");
	if (objSelectAll) {
		objSelectAll.onclick = SelectAll_Click;
	}
	objSelectAll.checked = false;
	var objExecute = document.getElementById("OrdExecute");
	if (objExecute) {
		objExecute.onclick = ExecuteAndPrint; //ExecuteClick;
		//objExecute.onKeydown=ExecuteKeyDown; //ypz 061115
	}
	var objExecuteOnly = document.getElementById("executeOnly");
	if (objExecuteOnly) objExecuteOnly.onclick = ExecuteOnly;

	var objExecCancel = document.getElementById("CancelEx");
	if (objExecCancel) {
		objExecCancel.onclick = CancelClick;
	}
	var objPrint = document.getElementById("print");
	if (objPrint) {
		objPrint.onclick = PrintClick;
	}
	var objPrintSeat = document.getElementById("printSeat");
	if (objPrintSeat) {
		objPrintSeat.onclick = PrintSeatClick;
	}
	var objReturn = document.getElementById("btnRetDispensing")
	if (objReturn) {
		objReturn.onclick = RetDispensing;
	} //ypz 060606
	var objBtnSetPlacerNo = document.getElementById("btnSetPlacerNo"); //ypz 060613
	if (objBtnSetPlacerNo) {
		objBtnSetPlacerNo.onclick = SetPlacerNo;
	} //ypz 060613
	var objPlacerNo = document.getElementById("curPlacerNo");
	var objSetLabNo = document.getElementById("SetLabNo");
	if (objSetLabNo) objSetLabNo.onkeydown = PlacerNoLinkLabNo;
	if (queryTypeCode.indexOf("JYDO") > 0) {
		objSetLabNo.style.display = "block"; 4
	}
	var objCplacerNo = document.getElementById("ccurPlacerNo");
	var objSkinTestAbnormal = document.getElementById("skinTestAbnormal"); //ypz 070612
	if (objSkinTestAbnormal) {
		objSkinTestAbnormal.onclick = SkinTestAbnormal
	} //ypz 070612
	var objSkinTestNormal = document.getElementById("skinTestNormal"); //ypz 070612
	if (objSkinTestNormal) {
		objSkinTestNormal.onclick = SkinTestNormal
	} //ypz 070612
	var objTreatQueue = document.getElementById("btnTreatQueue");
	if (objTreatQueue) {
		objTreatQueue.onclick = TreatQueueFn;
	}
	var obj = document.getElementById("SelBtnPrint");
	// if (obj) {obj.onclick=PrintSelect;}
	var objPrintTPQ = document.getElementById("PrintTPQ");
	if (objPrintTPQ) {
		objPrintTPQ.onclick = PrintTPQ;
	}

	var GetUserGroupAccess = document.getElementById("GetUserGroupAccess").value;
	var userId = session['LOGON.USERID'];
	//document.getElementById("userid").value=userId;
	var disReturn = true,
		disPlacerNo = true,
		disExecCancel = true;
	var disSkinTest = true,
		disExec = true,
		disPrint = true;
	//preset value

	var ret = cspRunServerMethod(GetUserGroupAccess, session['LOGON.GROUPID'], userId,"oldSheet","",session['LOGON.CTLOCID']); 

	var tmpList = ret.split("!");
	if ((tmpList[2] != "true") && (tmpList[2] != "1")) {
		disExecCancel = false;
		disReturn = false;
	}

	queryTypeCode = document.getElementById("queryTypeCode").value;
	var disFlag = document.getElementById("disFlag").value
	var exeFlag = false;
	var objexeFlag = parent.frames["NurseTop"].document.getElementById("exeFlag")
	if (objexeFlag) {
		exeFlag = objexeFlag.checked;
	}
	var regNo = "";
	var objRegNo = document.getElementById("regNo");
	if (objRegNo) regNo = objRegNo.value;
	if (queryTypeCode.indexOf("SYDO") > -1) {
		disReturn = true;
		if (objPrintSeat) objPrintSeat.style.display = "block";
		if (objPrintTPQ) objPrintTPQ.style.display = "block";
	}
	if (queryTypeCode != "PSDO") disSkinTest = false;
	if (queryTypeCode.indexOf("JYDO") < 0) disPlacerNo = false;
	if (queryTypeCode == "Default") {
		disExec = false;
		disExecCancel = false;
		disPrint = false;
	}
	if (exeFlag == true) {
		disExec = false;
		disSkinTest = false;
		disReturn = false;
	} else {
		disExecCancel = false;
	}
	//if (disFlag==0) disExec=false;//objExecute.style.display ="none";//keep temp

	if (regNo.length < parent.frames["NurseTop"].regNoLength) {
		disExec = false;
		disPrint = false;
	} //if ((regNo.length<10)&&(queryTypeCode.indexOf("JYDO")>-1)){disExec=false;disPrint=false;}
	//if((queryTypeCode.indexOf("JYDO")<0)){disExec=false;disPrint=false;}

	if (disExec) {
		objExecute.style.display = "block";
		objExecuteOnly.style.display = "block";
	}
	if (disPrint) objPrint.style.display = "block";
	if (disReturn) {
		if (objReturn) objReturn.style.display = "block";
	}
	if (disExecCancel) objExecCancel.style.display = "block";
	if (disPlacerNo) {
		if (objPlacerNo) objPlacerNo.style.display = "block";
		if (objBtnSetPlacerNo) objBtnSetPlacerNo.style.display = "block";
		if (objCplacerNo) objCplacerNo.style.display = "block";
	}
	if (disSkinTest) {
		if (objSkinTestAbnormal) objSkinTestAbnormal.style.display = "block";
		if (objSkinTestNormal) objSkinTestNormal.style.display = "block";
	}
	if ((queryTypeCode != "PSDO") && (queryTypeCode != "BLDO")) {


		if (exeFlag == true) {
			objExecute.style.display = "none";
		} else {
			objExecute.style.display = "block";
		}
	}
	if (queryTypeCode == "PSDO") {
		//var objExecuteOnly=document.getElementById("executeOnly");
		//objExecuteOnly.style.display ="none"; 
		if (objPrint) objPrint.style.display = "block";
	}
	if (objPrint) objPrint.style.display = "block";
	if ((queryTypeCode.indexOf("SYDO") > -1) || (queryTypeCode.indexOf("ZSDO") > -1) || (queryTypeCode.indexOf("BLDO") > -1)) {
		if (exeFlag == true) {
			objExecuteOnly.style.display = "none";
		} else {
			objExecuteOnly.style.display = "block";
		}
	}
	var Objtbl = document.getElementById('tDHCNurOPExec');
	tableRows = Objtbl.rows.length
	if ((disExec) && (tableRows > 1)) {
		objExecute.style.display = "block";
		objExecuteOnly.style.display = "block";
	}
	// if ((disPrint)&&(tableRows<2)) objPrint.style.display ="none";
	if ((tableRows > 0) && (queryTypeCode.indexOf("JYDO") > -1)) {
		var obj = document.getElementById('placerNoz1');
		if (obj) {
			websys_setfocus('placerNoz1');
			prePlacerNo = obj.value;
		}
	}
	if ((queryTypeCode.indexOf("JYDO") > -1) && (tableRows > 1)) {
		var unPaidoriIdStr = GetLabOrdStr(false);
		var checkAccount = document.getElementById('CheckAccount').value;
		accountInfo = cspRunServerMethod(checkAccount, unPaidoriIdStr);
	}
	var objPatMainInfo = parent.frames["NurseTop"].document.getElementById("patMainInfo"); // + wxl 090301
	var objDrugCell = document.getElementById("DrugCell");
	if ((objPatMainInfo) && (objPatMainInfo.value != "")) {
		var DrugCell = objPatMainInfo.value.split(":")[1];
		if (objDrugCell) objDrugCell.value = DrugCell;
	}
	if ((queryTypeCode.indexOf("SYDO") > -1) || (queryTypeCode.indexOf("ZSDO") > -1)) // + wxl 090301
	{
		if (objDrugCell) {
			objDrugCell.style.display = "block";
			document.getElementById('cDrugCell').style.display = "block";
		}

	}

	if (queryTypeCode == "Default") {
		objExecute.style.display = "none";
		objPrint.style.display = "none";
	}
	if (queryTypeCode == "PSDO") {
		objExecute.style.display = "none";
		objExecuteOnly.style.display = "none";
	}
	var seatFlag = "";
	if (parent.parent.frames["TreatLeft"]) {
		if(parent.parent.frames["TreatLeft"].document.getElementById("seatFlag")){
			seatFlag = parent.parent.frames["TreatLeft"].document.getElementById("seatFlag").value;
		}
	}
	if ((seatFlag == 3)||(seatFlag=="")) {
		//objTreatQueue.style.display="none";
		if (objTreatQueue) objTreatQueue.style.display = "none";
		//if (objTreatResult) objTreatResult.style.display="none";
		var Obj = document.getElementById("ClientList");
		if (Obj) Obj.style.display = "none";
		var Obj = document.getElementById("cClientList");
		if (Obj) Obj.style.display = "none";
	} else {
		LoadClientList();
	}
	/*
	if((tableRows<1)||(queryTypeCode.indexOf("Default")>-1))
	{
		if (objTreatQueue) objTreatQueue.style.display="none";
		if (objTreatResult) objTreatResult.style.display="none";
		var Obj=document.getElementById("ClientList");
		if (Obj) Obj.style.display="none";
		var Obj=document.getElementById("cClientList");
		if (Obj) Obj.style.display="none";
	}
	else
	{
		LoadClientList();
	}
	*/

}

function GetLabOrdStr(allFlag) {
	var labOrdIdStr = "^",
		labOriIdStr = "^",
		oeoriId;
	//alert(tableRows);
	for (var i = 1; i < tableRows; i++) {
		var oeoriIdExt = document.getElementById('oeoriIdz' + i).innerText;
		var disposeStatCode = document.getElementById('disposeStatCodez' + i).innerText;
		if ((allFlag) || (disposeStatCode == "UnPaid")) {
			var tmpList = oeoriIdExt.split("||");
			var oeordId = tmpList[0];
			oeoriId = tmpList[0] + "||" + tmpList[1]
			tmpList = labOrdIdStr.split("^" + oeordId + "^");
			//alert(tmpList.length+"/"+labOrdIdStr+"/"+oeordId);
			if (tmpList.length < 2) labOrdIdStr = labOrdIdStr + oeordId + "^"
			//alert(tmpList[0]+"/"+tmpList[tmpList.length-1])
			tmpList = labOriIdStr.split("^" + oeoriId + "^");
			if (tmpList.length < 2) labOriIdStr = labOriIdStr + oeoriId + "^"
		}
	}
	//return (labOrdIdStr+"!"+labOriIdStr)
	return labOriIdStr
}

function ExecuteKeyDown() {
	/*if (event.keyCode==13){
		if ((tableRows>0)&&(queryTypeCode.indexOf("JYDO")>-1)){
				var obj=document.getElementById('placerNoz'+1);
				if (obj){obj.setfocus;obj.value=1}
				objCplacerNo.setfocus;
		}
	}*/
}

function MatchDemo(str) {
	var r, re;
	//alert(str);                   // delclar var
	re = new RegExp(t['val:skintest']); //"皮试" 创建正则表达式对象create expression
	r = str.match(re); //在字符串 s 中查找匹配search
	return (r);
}

function hidcol(col, objtbl) {
	for (var i = 1; i < objtbl.rows.length; i++) {
		objtbl.rows(i).cells(col).style.display = "none";
	}
}

function DHCWeb_GetRowIdx(wobj) {
	try {
		var eSrc = wobj.event.srcElement;
		//alert(wobj.name);
		if (eSrc.tagName == "IMG") eSrc = wobj.event.srcElement.parentElement;
		var rowObj = getRow(eSrc);
		var selectrow = rowObj.rowIndex;
		return selectrow
	} catch (e) {
		alert(e.toString());
		return -1;
	}
}

function SelectRowHandler() {
	//var getfalg=document.getElementById("getflag").value;
	var i;
	var selrow = DHCWeb_GetRowIdx(window);
	curRow = selrow;
	var item = document.getElementById("seleitemz" + selrow); //arcimDesc
	var flag = item.checked;
	var selOriId = document.getElementById("oeoriIdz" + selrow).innerText;
	//alert(selOriId)
	var sqno = document.getElementById("tmpSeqNoz" + selrow).innerText; //cspRunServerMethod(getfalg,selOriId);
	var EpisodeID = document.getElementById("EpisodeIDz" + selrow).innerText;
	var frm = parent.parent.parent.document.forms['fEPRMENU'];
	frm.EpisodeID.value = EpisodeID;
	var getPatientID = document.getElementById("GetPatientID").value;
	PatientID = cspRunServerMethod(getPatientID, EpisodeID);

	var win = top.frames['eprmenu'];
	if (win) {
		var frm = win.document.forms['fEPRMENU'];
		if (frm) {
			frm.PatientID.value = PatientID; ///ypz 070312
		}
	}

	//ypz begin 060613
	var objCurPlacerNo = document.getElementById("curPlacerNo")

	if (objCurPlacerNo) {
		var getPlacerNo = document.getElementById("getPlacerNo").value;
		var resStr = cspRunServerMethod(getPlacerNo, selOriId);
		objCurPlacerNo.value = resStr;
	}

	//ypz end
	var tmpList = selOriId.split("||");
	var patOrder = tmpList[0]; //ypz 061225 select other pat order
	var mainOriSub = tmpList[1];
	var mainOreSub = "";
	if (tmpList[2]) mainOreSub = tmpList[2];
	var selectRow = getRow(document.getElementById("seleitemz" + selrow))
	if (selectRow) {
		if (selectRow.className == "clsRowSelected") {
			//debugger
			SearchSubOrder(selOriId);
		} else {
			SearchSubOrder();
		}
	}
	var objtbl = document.getElementById('tDHCNurOPExec');
	//alert(curRow)
	for (j = curRow; j >= 1; j--) {
		var item = document.getElementById("seleitemz" + j);
		var Arc = document.getElementById("arcimDescz" + j).innerText; //



		var oeoriId = document.getElementById("oeoriIdz" + j).innerText;

		var sqno1 = document.getElementById("tmpSeqNoz" + j).innerText;
		if (sqno1 == sqno) {
			item.checked = flag;
		}
		/* var tmpArcList=Arc.split("____");
			tmpList=oeoriId.split("||");
	
		if (mainOreSub=="") item.checked=flag;
		else{
			if (tmpList[2]){
				if (mainOreSub==tmpList[2]) item.checked=flag;
			}
		}
		alert(tmpArcList.length)
	if (tmpArcList.length<2)
	{
		break;
	}*/
	}
	for (i = curRow + 1; i < objtbl.rows.length; i++) {
		var item = document.getElementById("seleitemz" + i); //arcimDesc
		var Arc = document.getElementById("arcimDescz" + i).innerText; //

		var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
		//var OrdCheck=Arc.split(mainOriSub);
		//alert("Arc="+Arc+"/"+mainOriSub+"len"+OrdCheck.length)
		var sqno1 = document.getElementById("tmpSeqNoz" + i).innerText;
		if (sqno1 == sqno) {
			item.checked = flag;
		} else break;
		/* var tmpList=Arc.split("____");
			var tmpOreList=oeoriId.split("||");
			if (tmpList.length>1) //ypz rem if (OrdCheck[0]=="____")
			{
					 if (mainOreSub=="") item.checked=flag;
					 else{
				 
								if (tmpOreList[2]){
										if (mainOreSub==tmpOreList[2]) item.checked=flag;
								}
					 }
			}*/

	}
	// alert(queryTypeCode)
	if (queryTypeCode.indexOf("JYD") > -1) {
		var labNo = document.getElementById("labNoz" + selrow).innerText;
		//alert(labNo)
		for (i = selrow - 1; i >= 1; i--) {
			var item = document.getElementById("seleitemz" + i);
			var labNo1 = document.getElementById("labNoz" + i).innerText;
			if ((labNo1 == labNo) && (Number(labNo) != 0)) {
				item.checked = flag;
			}
		}

		for (i = selrow + 1; i < objtbl.rows.length; i++) {
			var item = document.getElementById("seleitemz" + i);
			var labNo1 = document.getElementById("labNoz" + i).innerText;
			if ((labNo1 == labNo) && (Number(labNo) != 0)) {
				item.checked = flag;
			}
		}
	}
}

function SelectRowHandler_20140110() {

	var i;
	var selrow = DHCWeb_GetRowIdx(window);
	curRow = selrow;
	//alert(curRow)
	//selrow
	var item = document.getElementById("seleitemz" + selrow); //arcimDesc
	var flag = item.checked;
	var selOriId = document.getElementById("oeoriIdz" + selrow).innerText;

	var EpisodeID = document.getElementById("EpisodeIDz" + selrow).innerText;
	var getPatientID = document.getElementById("GetPatientID").value;
	PatientID = cspRunServerMethod(getPatientID, EpisodeID);

	var win = top.frames['eprmenu'];
	if (win) {
		var frm = win.document.forms['fEPRMENU'];
		if (frm) {
			frm.PatientID.value = PatientID; ///ypz 070312
		}
	}

	//ypz begin 060613
	var objCurPlacerNo = document.getElementById("curPlacerNo")

	if (objCurPlacerNo) {
		var getPlacerNo = document.getElementById("getPlacerNo").value;
		var resStr = cspRunServerMethod(getPlacerNo, selOriId);
		objCurPlacerNo.value = resStr;
	}

	//ypz end
	var tmpList = selOriId.split("||");
	var patOrder = tmpList[0]; //ypz 061225 select other pat order
	var mainOriSub = tmpList[1];
	var mainOreSub = "";
	if (tmpList[2]) mainOreSub = tmpList[2];

	var selectRow = getRow(document.getElementById("seleitemz" + selrow))
	if (selectRow) {
		if (selectRow.className == "clsRowSelected") {
			SearchSubOrder(selOriId);
		} else {
			SearchSubOrder();
		}
	}
	var objtbl = document.getElementById('tDHCNurOPExec');
	for (j = curRow; j >= 1; j--) {
		var item = document.getElementById("seleitemz" + j);
		var Arc = document.getElementById("arcimDescz" + j).innerText; //
		var oeoriId = document.getElementById("oeoriIdz" + j).innerText;
		var tmpArcList = Arc.split("____");
		tmpList = oeoriId.split("||");

		if (mainOreSub == "") item.checked = flag;
		else {
			if (tmpList[2]) {
				if (mainOreSub == tmpList[2]) item.checked = flag;
			}
		}
		if (tmpArcList.length < 2) {
			break;
		}
	}
	for (i = curRow + 1; i < objtbl.rows.length; i++) {
		var item = document.getElementById("seleitemz" + i); //arcimDesc
		var Arc = document.getElementById("arcimDescz" + i).innerText; //

		var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
		//var OrdCheck=Arc.split(mainOriSub);
		//alert("Arc="+Arc+"/"+mainOriSub+"len"+OrdCheck.length)
		var tmpList = Arc.split("____");
		var tmpOreList = oeoriId.split("||");
		if (tmpList.length > 1) //ypz rem if (OrdCheck[0]=="____")
		{
			if (mainOreSub == "") item.checked = flag;
			else {

				if (tmpOreList[2]) {
					if (mainOreSub == tmpOreList[2]) item.checked = flag;
				}
			}
		} else break;
	}
}



function SearchSubOrder(selOrdId) {
	var ordId = ""
	if (selOrdId) {
		ordId = selOrdId
	} else {
		parent.frames['OrdAttach'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurOPExecAttach";
		return;
	}
	if (selOrdId.indexOf("^") > -1) {
		return;
	}
	var OrdList = parent.frames["NurseTop"];
	var wardId = OrdList.document.getElementById("wardId").value;
	var regNo = OrdList.document.getElementById("regNo").value;
	//if (EpisodeID!="") regNo=regNo+"^"+EpisodeID;
	var locId = OrdList.document.getElementById("locId").value;
	var queryTypeCode = OrdList.document.getElementById("queryTypeCode").value;
	var HospitalRowId = OrdList.document.getElementById("HospitalRowId").value;
	var stdate = OrdList.document.getElementById("startDate").value;
	var edate = OrdList.document.getElementById("endDate").value;
	var wardDesc = OrdList.document.getElementById("PacWard").value;
	var Dept = OrdList.document.getElementById("Dept").value;
	var ExeCheck = OrdList.document.getElementById("exeFlag").checked;
	var exeFlag;
	var gap = "";
	if (ExeCheck == false) {
		exeFlag = 0;
	} else {
		exeFlag = 1;
	}
	if (Dept == "") {
		locId = "";
	}
	if (queryTypeCode == "") return;
	var userId = session['LOGON.USERID'];
	var reportType = OrdList.document.getElementById("ReportList").value;
	var admType = OrdList.document.getElementById("admType").value;
	parent.frames['OrdAttach'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurOPExecAttach" + "&wardId=-1&regNo=" + regNo + "&userId=" + userId + "&startDate=" + stdate + "&endDate=" + edate + "&queryTypeCode=" + queryTypeCode + "&admType=" + admType + "&exeFlag=" + ExeCheck + "&ReportType=" + reportType + "&ordId=" + ordId + "&DetailFlag=on";
}


function SelectRowHandler0424() {
	var i;
	var selrow = DHCWeb_GetRowIdx(window);
	curRow = selrow;
	//alert(curRow)
	//selrow
	var item = document.getElementById("seleitemz" + selrow); //arcimDesc
	var flag = item.checked;
	var selOriId = document.getElementById("oeoriIdz" + selrow).innerText;

	var EpisodeID = document.getElementById("EpisodeIDz" + selrow).innerText;
	var getPatientID = document.getElementById("GetPatientID").value;
	PatientID = cspRunServerMethod(getPatientID, EpisodeID);

	var win = top.frames['eprmenu'];
	if (win) {
		var frm = win.document.forms['fEPRMENU'];
		if (frm) {
			frm.PatientID.value = PatientID; ///ypz 070312
		}
	}

	//ypz begin 060613
	var objCurPlacerNo = document.getElementById("curPlacerNo")
	if (objCurPlacerNo) {
		var getPlacerNo = document.getElementById("getPlacerNo").value;
		var resStr = cspRunServerMethod(getPlacerNo, selOriId);
		objCurPlacerNo.value = resStr;
	}
	//ypz end
	var tmpList = selOriId.split("||");
	var patOrder = tmpList[0]; //ypz 061225 select other pat order
	var mainOriSub = tmpList[1];
	var mainOreSub = "";
	if (tmpList[2]) mainOreSub = tmpList[2];

	var objtbl = document.getElementById('tDHCNurOPExec');
	for (i = curRow + 1; i < objtbl.rows.length; i++) {
		var item = document.getElementById("seleitemz" + i); //arcimDesc
		var Arc = document.getElementById("arcimDescz" + i).innerText; //

		var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
		//var OrdCheck=Arc.split(mainOriSub);
		//alert("Arc="+Arc+"/"+mainOriSub+"len"+OrdCheck.length)
		var tmpList = Arc.split("____");
		var tmpOreList = oeoriId.split("||");
		//alert(i+" len="+tmpList.length)
		if (tmpList.length > 1) //ypz rem if (OrdCheck[0]=="____")
		{
			if (mainOreSub == "") item.checked = flag;
			else {
				if (tmpOreList[2]) {
					if (mainOreSub == tmpOreList[2]) item.checked = flag;
				}
			}
		} else return;
	}
}

function CancelClick() {
	var objCancelEx = document.getElementById("CancelEx");
	if (objCancelEx) {
		objCancelEx.disabled = true;
		objCancelEx.onclick = function () {
			return false;
		}
	}

	var objtbl = document.getElementById('tDHCNurOPExec');
	var change = false;
	for (var i = 1; i < objtbl.rows.length; i++) {
		var item = document.getElementById("seleitemz" + i);
		if (item.checked == true) {
			var dispose = document.getElementById("disposeStatCodez" + i).innerText;
			if ((dispose != "Exec") && (dispose != "ExecDiscon") && (dispose != "Needless")) { } else {
				change = true;
				var userId = session['LOGON.USERID'];
				var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
				var ordstat = document.getElementById("ordStatDescz" + i).innerText; //stop//"D/C (Discontinued)")
				var unexemth = document.getElementById("UndoDisconOrder").value;

				if (ordstat == t['var:dischOrder']) { //discharged order
					if (cspRunServerMethod(unexemth, oeoriId, userId) == '0') { }
				} else //discharge executed order
				{
					var oecprDesc = document.getElementById("oecprDescz" + i).innerText;
					//var UndoUpdateExecStat=document.getElementById("UndoUpdateExecStat").value;
					var updateOrdGroup = document.getElementById("UpdateOrdGroup").value;
					//alert(oeoriId+"/"+oecprDesc+"/"+userId);
					var DateTime = document.getElementById("sttDateTimez" + i).innerText;
					var flag;
					flag = 0;
					change = false;
					var resStr = cspRunServerMethod(updateOrdGroup, DateTime, oeoriId, userId, flag);
					//alert(resStr)
					if (resStr == '0') {
						var execDateTime = document.getElementById("execDateTimez" + i);
						var execCtcpDesc = document.getElementById("execCtcpDescz" + i);
						var execStat = document.getElementById("execStatz" + i);
						execDateTime.innerText = "";
						execCtcpDesc.innerText = "";
						execStat.innerText = "";
						change = true;
					} else alert(resStr)
					//if(resStr=="-2")  alert(t['alert:cancelByOneself']); ///must do by oneself
				}
			}
		}
	}
	if (change) {
		alert(t['alert:success']);
	}
	//else alert(t['alert:error'])
	self.location.reload();
}

function ExecuteAndPrint() {
	ExecuteClick(true)
}

function ExecuteOnly() {
	ExecuteClick(false)
}

function ExecuteClick(needPrint) {
	var DrugCell = ""; // + wxl 090301
	var objDrugCell = document.getElementById("DrugCell");
	if (objDrugCell) DrugCell = objDrugCell.value;
	if (((queryTypeCode == "SYDO") || (queryTypeCode == "ZSDO")) && (DrugCell == "")) {
		//alert(t['alert:shouldFillDrugCell']);
		//return;
	}
	var obj = document.getElementById("OrdExecute");
	if (obj) {
		obj.disabled = true;
		obj.onclick = function () {
			return false;
		}
	}
	var obj = document.getElementById("executeOnly");
	if (obj) {
		obj.disabled = true;
		obj.onclick = function () {
			return false;
		}
	}
	//alert("ok");return;
	if (queryTypeCode == "Default") return;
	var userId = session['LOGON.USERID'];
	var ctlocId = session["LOGON.CTLOCID"];
	/*if (queryTypeCode.indexOf("JYDO")>-1)
	{	oeoriIdStr=GetLabOrdStr(false);
	var userGroupId=session['LOGON.GROUPID']
	var logLocId=session['LOGON.CTLOCID']
		var billLabOrd=document.getElementById('BillLabOrd').value;
		resStr=cspRunServerMethod(billLabOrd,oeoriIdStr,userId,userGroupId,logLocId);
	}*/

	var objtbl = document.getElementById('tDHCNurOPExec');
	var updateOrdGroup = document.getElementById("UpdateOrdGroup").value;
	var oeoreParaStr, flag, oeoriIdStr = "",
		exeResult = false;
	var objPrintSeat = document.getElementById("printSeat");
	var objSeatNo = parent.frames["NurseTop"].document.getElementById("SeatNo");
	if (objSeatNo) var SeatNo = objSeatNo.value;
	else var SeatNo = "";
	oeoreParaStr = "";
	var excuteAndPrintFlag = "";
	if (needPrint == true) {
		excuteAndPrintFlag = 1
	}
	for (var i = 1; i < objtbl.rows.length; i++) {
		var item = document.getElementById("seleitemz" + i);
		var execDateTime = document.getElementById("execDateTimez" + i).innerText;
		if ((item.checked == true) && (execDateTime == " ")) {
			disposeStatCode = document.getElementById("disposeStatCodez" + i).innerText
			if (disposeStatCode == "UnPaid") {
				alert(t['alert:ExecPaid']);
				self.location.reload();
				return;
			} else if (disposeStatCode == "SkinTestAbnorm") {
				var oeoriIdCode = document.getElementById("oeoriIdz" + i).innerText;
				testResult = tkMakeServerCall("web.DHCNurCom", "SkinTestResult", oeoriIdCode); //
				if (testResult == "Y") {
					alert("皮试阳性，不允许执行！！");
					self.location.reload();
					return;
				}
			} else {
				var oeoriIdCode = document.getElementById("oeoriIdz" + i).innerText;
				var disposeCode = tkMakeServerCall("web.DHCNurCom", "IsUnPaid", oeoriIdCode, disposeStatCode); //
				if (disposeCode == "UnPaid") {
					alert(t['alert:ExecPaid']);
					self.location.reload();
					return;
				}
			}

			var arcimDesc = document.getElementById("arcimDescz" + i).innerText;
			var tmpList = arcimDesc.split("____");
			if (tmpList.length < 2) {
				if ((queryTypeCode.indexOf("JYDO") > -1)) {
					var obj = document.getElementById("placerNoz" + i);
					if (obj) {
						var placerNo = obj.value;
						//if (placerNo.length<10) {alert(t['alert:tooShort']);return;}
					}
				}
				var basedose = "";
				var obj = document.getElementById("doseQtyUnitz" + i)
				if (obj) basedose = obj.innerText;
				var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
				var sttDateTime = document.getElementById("sttDateTimez" + i).innerText;
				if ((sttDateTime == " ")) {
					alert(t['alert:setSttDateTime']);
					return false;
				} //ypz 060430
				oeoreParaStr = oeoreParaStr + "^" + basedose + "!" + oeoriId + "!!" + i;
				if (oeoriIdStr.length == 0) {
					oeoriIdStr = oeoriId;
				} else {
					oeoriIdStr = oeoriIdStr + "^" + oeoriId
				}
				flag = 1
				if ((queryTypeCode != "SYDO") || (!objPrintSeat)) {
					var resStr, printed = false;

					var userId = session['LOGON.USERID'];
					var curExecStatDesc = t['val:finish']; //stat.options[index].text;
					if ((disposeStatCode != "Immediate") && (disposeStatCode != "LongNew") && (disposeStatCode != "Temp") && (disposeStatCode != "TempTest") && (disposeStatCode != "Discontinue") && (disposeStatCode != "Needless") && (disposeStatCode != "SkinTestNorm") && (disposeStatCode != "SkinTest")) { } else {
						var ordstat = document.getElementById("ordStatDescz" + i).innerText;
						if (ordstat == t['var:dischOrder']&&disposeStatCode!="Temp") { } //
						else {
							var flag = 1; //SeatNo="";

							//resStr=cspRunServerMethod(updateOrdGroup,sttDateTime,oeoriId+"^"+SeatNo+"^"+ctlocId+"^^"+queryTypeCode,userId,flag);
							var currWARD = session['LOGON.WARDID'];
							resStr = cspRunServerMethod(updateOrdGroup, sttDateTime, oeoriId + "^" + SeatNo + "^" + ctlocId + "^^" + queryTypeCode + "^^^" + DrugCell, userId, flag, 1,ctlocId,currWARD); //+ wxl 090301
							if (resStr == "0") {
								exeResult = true;
							} else {
								alert(resStr);
								exeResult = false;
							}
						}
					}

				}
			}
		}
	}
	if (oeoreParaStr == "") return;
	//alert(oeoreParaStr)
	/*if ((queryTypeCode.indexOf("JYDO")>-1)&&(oeoriIdStr!="")) //print lab note
	{	
			Card= new ActiveXObject("PrintBar.PrnBar");
			var ordPrintInfo=document.getElementById("OrdPrintInfo").value;
				var str=cspRunServerMethod(ordPrintInfo,oeoriIdStr,"false");
		Card.xtprint="xiaotiao";//printer name
		Card.OrderString=str;
			Card.SetPrint();
		Card.PrintLabNote();
	//PrintBar();//print barcode//ypz placer unuse
		return;//placerno: keep to see result, not refresh
}*/
	var objRegNo = parent.frames["NurseTop"].document.getElementById("regNo")
	var objPatMainInfo = parent.frames["NurseTop"].document.getElementById("patMainInfo")
	if ((queryTypeCode != "SYDO") || (!objPrintSeat)) {
		if (exeResult) {
			alert(t['alert:success']);
			if (needPrint) {
				PrintClick();
				self.location.reload()
				// setTimeout('parent.frames["NurseTop"].ClearScreen();',1000); //ypz 081216
			} else self.location.reload();
		}
		self.location.reload();
		return;
	}
	oeoreParaStr = escape(oeoreParaStr);
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurOPExecAdmin" + "&execData=" + oeoreParaStr;
	//window.open(lnk,"Order_Exec","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=300,width=400,top=100,left=300");
	var ifSuccess = window.showModalDialog(lnk, window, "dialogWidth:400px;status:no;dialogHeight:300px");
	//alert(ifSuccess)
	if ((ifSuccess) && (needPrint)) PrintClick();

	if (needPrint) {
		if (objRegNo) objRegNo.value = "";
		if (objPatMainInfo) objPatMainInfo.value = "";
		parent.frames["NurseTop"].ClearScreen();
	}
	self.location.reload();
}

function getallord(patStr) {
	var tmpList = new Array;
	var patList = new Array;
	var i;
	var stdate = document.getElementById("StartDate").value;
	var enddate = document.getElementById("EndDate").value;
	var rptyp = document.getElementById("ReportList").value;
	var userId = session['LOGON.USERID']
	var wardno = document.getElementById("wardid").value;
	var mthallorditem = document.getElementById("allorditem").value;
	var patList = patStr.split("^");
	//  alert(patStr);
	for (i = 0; i < patList.length; i++) {
		tmpList = patList[i].split("!")
		//   alert(patList[i]);
		if (cspRunServerMethod(mthallorditem, 'schorditem', '', tmpList[0], stdate, enddate, userId, wardno, "Default", "") == '0') { }
		//  alert("i---"+i);
	}
	return;

}

function schorditem(ordItems) {

	var mthgetdata = document.getElementById("getdata").value;
	for (var j = 1; j <= ordItems; j++) {
		if (cspRunServerMethod(mthgetdata, 'inserttable', '', j) == '0') { }
	}
	return;
}

function inserttable(itemData) {
	//alert("itemdata=" + itemData)
	var tmpList = new Array();
	var varstr = new Array();
	var i, j;
	var tmpList = (itemData).split("!");
	var objtbl = document.getElementById('tDHCNurOPExec');
	// alert(itemData);
	var rows = objtbl.rows.length;
	var LastRow = rows - 1;
	// alert(rows);
	var eSrc = objtbl.rows[LastRow];
	var RowObj = getRow(eSrc);
	var rowitems = RowObj.all;
	if (!rowitems) rowitems = RowObj.getElementsByTagName("label");
	for (var j = 0; j < rowitems.length; j++) {
		if (rowitems[j].id) {
			//alert(rowitems[j].id);
			var Id = rowitems[j].id;
			var arrId = Id.split("z");
			//alert(arrId.length);
			var Row = arrId[arrId.length - 1];
			//	alert(Row);
		}
	}
	var typ = document.getElementById("ReportList").value;
	for (i = 0; i < listvar.length; i++) {
		if (listvar[i] != "") {
			// alert(i+"_"+listvar[i]+"z"+Row);
			varstr[i] = document.getElementById(listvar[i] + "z" + Row);
			// alert(i+"_"+varstr[i].name)
		}
	}
	for (i = 0; i < 32; i++) {
		//  alert(i);
		varstr[i].innerText = tmpList[i];
	}
	// RowObj.className="red";
	AddRowToList(objtbl);
	return;
}

function AddRowToList(objtbl) {
	var objlastrow = objtbl.rows[objtbl.rows.length - 1];
	var varstr = new Array();
	//make sure objtbl is the tbody element
	objtbl = tk_getTBody(objlastrow);
	var objnewrow = objlastrow.cloneNode(true);
	var rowitems = objnewrow.all; //IE only
	//alert(rowitems.length+"|"+objlastrow);
	if (!rowitems) rowitems = objnewrow.getElementsByTagName("*"); //N6
	for (var j = 0; j < rowitems.length; j++) {
		if (rowitems[j].id) {
			var Id = rowitems[j].id;
			var arrId = Id.split("z");
			arrId[arrId.length - 1] = arrId[arrId.length - 1] + 1;
			rowitems[j].id = arrId.join("z");
			rowitems[j].name = arrId.join("z");
			//rowitems[j].value="";
			//alert(rowitems[j].value+"||"+rowitems[i].type);
			if (rowitems[j].value == "on") {
				rowitems[j].checked = true;
			} else {
				rowitems[j].innerText = "";
			}
		}
	}
	objnewrow = objtbl.appendChild(objnewrow); {
		if ((objnewrow.rowIndex) % 2 == 0) {
			objnewrow.className = "RowEven";
		} else {
			objnewrow.className = "RowOdd";
		}
	}
}

function savetyp(str) {
	var obj = document.getElementById('queryTypeCode');
	var tmpList = str.split("^");
	obj.value = tmpList[1];
	self.location.reload();
	return;
}

function RetDispensing() //ypz 060606
{
	var confirmed = window.confirm(t['alert:onlyOnce']);
	if (!confirmed) return;
	var objReturnDispensing = document.getElementById("returnDispensing");
	if (objReturnDispensing) {
		objReturnDispensing.disabled = true;
		objReturnDispensing.onclick = function () {
			return false;
		}
	}
	var objtbl = document.getElementById('tDHCNurOPExec');
	var retDispensing = document.getElementById("returnDispensing").value;
	var userId = session['LOGON.USERID'];
	var oeoreParaStr;
	oeoreStr = "";
	for (var i = 1; i < objtbl.rows.length; i++) {
		var item = document.getElementById("seleitemz" + i);
		if (item.checked == true) {
			var disposeStatCode = document.getElementById("disposeStatCodez" + i).innerText;
			//alert(disposeStatCode);return;
			if (disposeStatCode == "UnPaid") {
				alert(t['alert:ExecPaid']);
				return;
			}

			var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
			if (oeoreStr.length > 0) oeoreStr = oeoreStr + "^"
			oeoreStr = oeoreStr + oeoriId;
		}
	}
	if (oeoreStr == "") return;
	resStr = cspRunServerMethod(retDispensing, oeoreStr);
	if (resStr == 0) {
		alert(t['alert:success']);
		self.location.reload();
	} else alert(resStr); //alert(t['alert:error']);
}

function SetPlacerNo() //ypz 060613
{
	//if (curRow<1) return;
	var count = 0;
	////var Objtbl=document.getElementById('tDHCNurOPExec');
	////var Rows=Objtbl.rows.length;	
	for (var i = 1; i < tableRows; i++) {
		var check = document.getElementById('seleitemz' + i);
		if (check.checked == true) {
			count = count + 1, selRow = i;
			var selOriId = document.getElementById("oeoriIdz" + i).innerText;
		}
	}
	if (count != 1) {
		alert(t['alert:selectSingle']);
		return;
	}

	var setPlacerNo = document.getElementById("setPlacerNo").value;
	var objCurPlacerNo = document.getElementById("curPlacerNo");
	if (!objCurPlacerNo) return;
	var userId = session['LOGON.USERID']; //add var userId,061113
	//alert(selOriId+" / "+placerNo)
	var resStr = cspRunServerMethod(setPlacerNo, userId, selOriId, objCurPlacerNo.value);
	if (resStr != 0) {
		alert(resStr)
	} else {
		alert(t['alert:success']); //!!
		document.getElementById("placerNoz" + selRow).value = objCurPlacerNo.value;
	}
}

function ReplyKeydown() {
	var i, placerNo;
	var userId = session['LOGON.USERID'];
	if (event.keyCode == 13) {
		var eSrc = window.event.srcElement;
		//eSrc.style.backgroundcolor="#00ff00";
		//eSrc.style.color="#00ff00";
		var rowObj = getRow(eSrc);
		var selectrow = rowObj.rowIndex;

		if (eSrc.value.length > 9) {
			var selOriId = document.getElementById("oeoriIdz" + selectrow).innerText;
			var setPlacerNo = document.getElementById("setPlacerNo").value;
			placerNo = eSrc.value;
			var resStr = cspRunServerMethod(setPlacerNo, userId, selOriId, placerNo); //add var userId 061113
			if (resStr != 0) {
				eSrc.value = prePlacerNo;
				alert(resStr);
				self.location.reload();
			} else {
				prePlacerNo = eSrc.value;
				var check = document.getElementById('seleitemz' + selectrow);
				check.checked = true
				var labNo = document.getElementById("labNoz" + selectrow).innerText;
				//alert(labNo)
				for (i = 1; i < tableRows; i++) {
					var curLabNo = document.getElementById("labNoz" + i).innerText;
					if ((i != selectrow) && (curLabNo == labNo)) {
						//alert(curLabNo)
						check = document.getElementById('seleitemz' + i);
						check.checked = true
						document.getElementById("placerNoz" + i).innerText = placerNo;
					}
				}
			}
			if (selectrow == tableRows - 1) websys_setfocus("OrdExecute");
			for (i = selectrow + 1; i < tableRows; i++) {
				placerNo = document.getElementById("placerNoz" + i).value;
				if (placerNo.length < 1) {
					var obj = document.getElementById("placerNoz" + i);
					obj.focus();
					prePlacerNo = obj.value;
					return;
				}
			}
		} else {
			eSrc.value = prePlacerNo;
			alert(t['alert:tooShort'])
		}
	}
}

function SkinTestAbnormal() {
	SetSkinTest(true)
}

function SkinTestNormal() {
	SetSkinTest(false)
}

function SetSkinTest(skinTestAbnormal) {
	//if (curRow<1) return;
	var count = 0;
	//var Objtbl=document.getElementById('tDHCNurOPExec');
	//var Rows=Objtbl.rows.length;	
	for (var i = 1; i < tableRows; i++) {
		var check = document.getElementById('seleitemz' + i);
		if (check.checked == true) {
			count = count + 1
			var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
		}
	}
	if (count != 1) {
		alert(t['alert:selectSingle']);
		return;
	}

	var setSkinTestResult = document.getElementById("setSkinTestResult").value;
	//var	skinTestAbnormal=document.getElementById("skinTestAbnormal").checked;
	var userId = session['LOGON.USERID'];
	var abnormalFlag;
	if (skinTestAbnormal == true) {
		abnormalFlag = "Y";
	} else {
		abnormalFlag = "N";
	}
	var resStr = cspRunServerMethod(setSkinTestResult, oeoriId, userId, abnormalFlag);
	//alert(resStr); //display result
	//var ysFlag = tkMakeServerCall("web.DHCNurCom","IsSTSolution",oeoriId);
	// if(resStr=="操作成功!"){
	// 	var ysFlag = tkMakeServerCall("web.DHCNurCom","IsSTSolution",oeoriId);
	// 	if(ysFlag=="Y"){
	// 		ExecuteClick(false);		
	// 		self.location.reload();
	// 	}
	// 	else{
	// 		alert(resStr);
	// 		self.location.reload();
	// 		return ;
	// 	}		
	// }
	// else{
	// 	alert(resStr);
	// 	self.location.reload();
	// 	return ;
	// }
	alert(resStr);
	self.location.reload();
	return;

}

function transINVStr(myINVStr) { }

function PlacerNoLinkLabNo1() {
	if (event.keyCode == 13) {
		PlacerNoLinkLabNo("")
		self.location.reload()
	}
}

function PlacerNoLinkLabNo20140217(curRow) {
	if (queryTypeCode.indexOf("JYDO") > -1) {
		var labNo = ""
		var objPlacerNo = document.getElementById('curPlacerNo');
		var objtbl = document.getElementById('tDHCNurOPExec');
		if ((objPlacerNo) && (curRow == "")) {
			placerNo = objPlacerNo.value;
			curRow = ""
			for (var i = 1; i < objtbl.rows.length; i++) {
				var objLabNo = document.getElementById('labNoz' + i);
				if (objLabNo.innerText == objPlacerNo.value) {
					labNo = objPlacerNo.value;
					curRow = i
					break;
				}
			}
		}
		if (curRow == "") return;
		var objLabNo = document.getElementById('labNoz' + curRow);
		if (!objLabNo) return;
		labNo = objLabNo.innerText;
		if ((labNo == " ") || (labNo.length < 2)) return;
		//var objPlacerNoz=document.getElementById("placerNoz"+curRow);
		//if (! objPlacerNoz) return;
		//if (objPlacerNoz.value.length>0) return;

		var setPlacerNo = document.getElementById("setPlacerNo").value;
		var userId = session['LOGON.USERID']; //add var userId,061113
		var selOriId = document.getElementById("oeoriIdz" + curRow).innerText;
		//alert(userId+"/"+selOriId+"/"+objPlacerNo.value)
		var ifPlacerNo = document.getElementById("ifPlacerNo").value; //xuqy 20080514
		var restrunStr = cspRunServerMethod(ifPlacerNo, labNo);
		if (restrunStr == "1") return;
		var resStr = cspRunServerMethod(setPlacerNo, userId, selOriId, labNo);
		if (resStr != 0) {
			alert(resStr)
		} else {
			//alert(t['alert:success']);//!!
			for (var i = 1; i < objtbl.rows.length; i++) {
				var objLabNo = document.getElementById('labNoz' + i);
				if (objLabNo.innerText == labNo) {
					//labNo=objPlacerNo.value;
					//document.getElementById("placerNoz"+i).value=labNo;
				}
			}
			if (objPlacerNo) objPlacerNo.value = "";
		}
	}
}

function PlacerNoLinkLabNo() {

	if (event.keyCode == 13) {
		//debugger;
		if (queryTypeCode.indexOf("JYDO") > -1) {
			var labNo = ""
			var objPlacerNo = document.getElementById('SetLabNo');
			var objtbl = document.getElementById('tDHCNurOPExec');
			if ((objPlacerNo)) { //&&(curRow=="")
				placerNo = objPlacerNo.value;
				curRow = ""
				for (var i = 1; i < objtbl.rows.length; i++) {
					var objLabNo = document.getElementById('labNoz' + i);
					if (objLabNo.innerText == objPlacerNo.value) {
						labNo = objPlacerNo.value;
						curRow = i
						break;
					}
				}
			}
			if (curRow == "") return;
			var objLabNo = document.getElementById('labNoz' + curRow);
			if (!objLabNo) return;
			labNo = objLabNo.innerText;
			if ((labNo == " ") || (labNo.length < 2)) return;
			//var objPlacerNoz=document.getElementById("placerNoz"+curRow);
			//if (! objPlacerNoz) return;
			//if (objPlacerNoz.value.length>0) return;

			var setPlacerNo = document.getElementById("setPlacerNo").value;
			var userId = session['LOGON.USERID']; //add var userId,061113
			var selOriId = document.getElementById("oeoriIdz" + curRow).innerText;
			//alert(userId+"/"+selOriId+"/"+objPlacerNo.value)
			//var ifPlacerNo=document.getElementById("ifPlacerNo").value;   //xuqy 20080514
			// var restrunStr=cspRunServerMethod(ifPlacerNo,labNo);
			//	if (restrunStr=="1") return;
			var resStr = cspRunServerMethod(setPlacerNo, userId, selOriId, labNo);
			if (resStr != 0) {
				alert(resStr)
			} else {
				//alert(t['alert:success']);//!!
				for (var i = 1; i < objtbl.rows.length; i++) {
					var objLabNo = document.getElementById('labNoz' + i);
					if (objLabNo.innerText == labNo) {
						labNo = objPlacerNo.value;
						document.getElementById("placerNoz" + i).value = labNo;
					}
				}
				if (objPlacerNo) objPlacerNo.value = "";
			}
		}
	}
}

function SelectAll_Click() {
	var obj = document.getElementById("SelectAll");
	var Objtbl = document.getElementById('tDHCNurOPExec');
	var Rows = Objtbl.rows.length;
	for (var i = 1; i < Rows; i++) {
		var selobj = document.getElementById('seleitemz' + i);
		selobj.checked = obj.checked;
	}
}

function SearchSubOrder(selOrdId) {
	var ordId = ""
	if (selOrdId) {
		ordId = selOrdId
	} else {
		return;
	}
	if (selOrdId.indexOf("^") > -1) {
		return;
	}
	var OrdList = parent.frames["NurseTop"];
	var wardId = OrdList.document.getElementById("wardId").value;
	var regNo = OrdList.document.getElementById("regNo").value;
	var frm = parent.parent.parent.document.forms['fEPRMENU'];
	var EpisodeID = frm.EpisodeID.value;
	if (EpisodeID != "") regNo = regNo + "^" + EpisodeID;
	var locId = OrdList.document.getElementById("locId").value;
	var queryTypeCode = OrdList.document.getElementById("queryTypeCode").value;
	var HospitalRowId = OrdList.document.getElementById("HospitalRowId").value;
	var stdate = OrdList.document.getElementById("startDate").value;
	var edate = OrdList.document.getElementById("endDate").value;
	var wardDesc = OrdList.document.getElementById("PacWard").value;
	var Dept = OrdList.document.getElementById("Dept").value;
	var ExeCheck = OrdList.document.getElementById("exeFlag").checked;
	var exeFlag;
	var gap = "";
	if (ExeCheck == false) {
		exeFlag = 0;
	} else {
		exeFlag = 1;
	}
	if (Dept == "") {
		locId = "";
	}
	if (queryTypeCode == "") return;
	var userId = session['LOGON.USERID'];
	var reportType = OrdList.document.getElementById("ReportList").value;
	var admType = OrdList.document.getElementById("admType").value;
	var DetailFlag = "on"
	parent.frames['OrdAttach'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurOPExecAttach" + "&wardId=-1&regNo=" + regNo + "&userId=" + userId + "&startDate=" + stdate + "&endDate=" + edate + "&queryTypeCode=" + queryTypeCode + "&admType=" + admType + "&exeFlag=" + ExeCheck + "&ReportType=" + reportType + "&DetailFlag=" + DetailFlag + "&ordId=" + ordId;
}

function StartSkinTest() {
	var count = 0;
	var TestAdmDr = "",
		TestOeoriDr = "";
	for (var i = 1; i < tableRows; i++) {
		var check = document.getElementById('seleitemz' + i);
		if (check.checked == true) {
			count = count + 1
			TestAdmDr = document.getElementById("EpisodeIDz" + i).innerText;
			TestOeoriDr = document.getElementById("oeoriIdz" + i).innerText;
		}
	}
	if (count != 1) {
		alert(t['alert:selectSingle']);
		return;
	}
	if (TestAdmDr == "") return;
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurOPSkinTest" + "&EpisodeID=" + TestAdmDr + "&oeoriStr=" + TestOeoriDr;
	window.open(lnk, "DHCNurOPSkinTest", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=280,width=800,top=100,left=300");
	return;
}

function TreatQueueFn() {
	var ClientId = ""
	var ClientObj = document.getElementById("ClientId");
	if (ClientObj) var ClientId = ClientObj.value;
	var TreatAdmDr = "";
	for (var i = 1; i < tableRows; i++) {
		if (TreatAdmDr != "") break;
		var check = document.getElementById('seleitemz' + i);
		if (check.checked == true) {
			TreatAdmDr = document.getElementById("EpisodeIDz" + i).innerText;
		}
	}
	if (TreatAdmDr == "") {
		alert(t['alert:selectSingle']);
		return;
	}
	var objTreatSave = document.getElementById("TreatSave");
	if (objTreatSave) {
		var userId = session['LOGON.USERID'];
		var locId = session['LOGON.CTLOCID'];
		var queryTypeCode = document.getElementById("queryTypeCode").value
		var regNo = parent.frames["NurseTop"].document.getElementById("regNo").value;
		var seatFlag = parent.parent.frames["TreatLeft"].document.getElementById("seatFlag").value;
		var serverIP = parent.parent.frames["TreatLeft"].document.getElementById("serverIP").value;
		var parr = "TreatLocDr|" + locId + "^TreatRecUser|" + userId + "^TreatAdmDr|" + TreatAdmDr + "^TreatQueState|Wait^TreatQuePrior|2^TreatQueDate|^TreatQueTime|" + "^TreatQueueCat|" + ClientId + "^TreatReportType|" + queryTypeCode + "^RegNo|" + regNo + "^SeatFlag|" + seatFlag + "^TreatServerIP|" + serverIP;
		var resStr = cspRunServerMethod(objTreatSave.value, "", parr);
		if (resStr != 0) {
			alert(resStr);
			return;
		} else {
			PrintQueueNo(TreatAdmDr, locId, ClientId)
			if (parent.parent.frames["TreatLeft"]) {
				parent.parent.frames["TreatLeft"].RefreshFn();
				//parent.parent.frames["TreatLeft"].location.reload();
			}
		}
	}
}
document.write("<object ID='clsPrinter' CLASSID='CLSID:A1B74B65-F54C-45B3-9618-A938C4DE113C' CODEBASE='../addins/client/DHCVBPrinter.CAB#version=1,0,0,3'>");
document.write("</object>");

function PrintQueueNo(TreatAdmDr, locId, ClientId) {
	return;
	var PrintInfo = tkMakeServerCall("web.DHCVISTreatQueue", "GetPrintInfo", TreatAdmDr, locId, ClientId);
	var InfoList = PrintInfo.split("^")
	if (InfoList.length > 4) {
		QueueType = InfoList[0]
		WaitRoom = InfoList[1]
		QueueNo = InfoList[2]
		PatName = InfoList[3]
		WaitSum = InfoList[4]
	} else {
		alert("获取打印信息错误!")
		return;
	}
	var PrintObj = new ActiveXObject("DHCVBPrinter.clsPrinter");
	PrintObj.FontSize = 20;
	PrintObj.FontBold = true;
	PrintObj.PrintContents(18, 0, "排队取号系统");
	PrintObj.FontSize = 12;
	PrintObj.FontBold = true;
	PrintObj.PrintContents(0, 10, "队列类型:" + QueueType);
	if (WaitRoom != "") {
		PrintObj.PrintContents(0, 17, "等候诊室:" + WaitRoom);
		PrintObj.PrintContents(0, 24, "患者姓名:" + PatName);
		PrintObj.PrintContents(40, 24, "排队号:" + QueueNo + "号");
		PrintObj.PrintContents(0, 31, "当前等候人数:" + WaitSum + "人")
		PrintObj.FontSize = 10;
		PrintObj.FontBold = false;
		PrintObj.PrintContents(0, 40, "取号后请不要远离,过号请重新取号!");
	} else {
		PrintObj.PrintContents(0, 17, "患者姓名:" + PatName);
		PrintObj.PrintContents(40, 17, "排队号:" + QueueNo + "号");
		PrintObj.PrintContents(0, 24, "当前等候人数:" + WaitSum + "人")
		PrintObj.FontSize = 10;
		PrintObj.FontBold = false;
		PrintObj.PrintContents(0, 32, "取号后请不要远离,过号请重新取号!");
	}
	PrintObj.EndDoc()
	PrintObj = null;
}

function FinishTreatFn(TreatAdmDr) {
	var objTreatSave = document.getElementById("TreatSave");
	if (objTreatSave) {
		var userId = session['LOGON.USERID'];
		var locId = session['LOGON.CTLOCID'];
		//var parr="TreatLocDr|"+locId+"^TreatRecUser|"+userId+"^TreatAdmDr|"+TreatAdmDr+"^TreatQueState|Finish";
		//var resStr=cspRunServerMethod(objTreatSave.value,"",parr);
		var IPAddress = GetComputerName()
		var QueueState = "Finish"
		if ((IPAddress == "Exception") || (IPAddress == "")) {
			IPAddress = ""
		}
		var resStr = tkMakeServerCall("web.DHCVISTreatQueue", "UpdateQueueState", IPAddress, TreatAdmDr, QueueState, locId, userId);
		if (resStr != 0) {
			alert(resStr);
			return;
		} else {
			if (parent.parent.frames["TreatLeft"]) {
				parent.parent.frames["TreatLeft"].RefreshFn();
				//parent.parent.frames["TreatLeft"].location.reload();
			}
		}
	}
}

function TreatResultFn() {
	var count = 0;
	var oeoriId = "";
	for (var i = 1; i < tableRows; i++) {
		var check = document.getElementById('seleitemz' + i);
		if (check.checked == true) {
			count = count + 1
			oeoriId = document.getElementById("oeoriIdz" + i).innerText;
		}
	}
	if (count != 1) {
		alert(t['alert:selectSingle']);
		return;
	}
	if (oeoriId == "") return;
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurOPTreatResult" + "&oeoriStr=" + oeoriId;
	window.open(lnk, "DHCNurOPTreatResult", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=100,width=200,top=260,left=600");
	return;
}

function GetOrderDspStatus(curRow) {
	//判断关联医嘱中有无未发药医嘱
	//curRow主医嘱ID
	//retFlag0:无,1:有
	var retFlag = 0;
	if ((!curRow) || (curRow == "")) return retFlag;
	var objDspStat = document.getElementById("DspStatz" + curRow);
	if (!objDspStat) return retFlag;
	if (objDspStat.innerText == "未发") {
		retFlag = 1;
		return retFlag;
	}
	var objtbl = document.getElementById('tDHCNurOPExec');
	//alert(objtbl.rows.length);
	for (var j = curRow + 1; j < objtbl.rows.length; j++) {
		var curArcimDesc = document.getElementById("arcimDescz" + j).innerText;
		var curArcimArr = curArcimDesc.split("____");
		if (curArcimArr.length > 1) {
			//关联医嘱	
			var objSeleitem = document.getElementById("seleitemz" + j);
			var objExecDateTime = document.getElementById("execDateTimez" + j);
			if ((objSeleitem.checked == true) && (objExecDateTime.innerText == " ")) {
				var objDspStat = document.getElementById("DspStatz" + j).innerText;
				if (objDspStat == "未发") {
					retFlag = 1;
					break;
				}
			}
		} else {
			//主医嘱
			break;
		}
	}
	return retFlag;
}
var ClientTyp = "";

function LoadClientList() {
	var ClientStr = ""
	var IPAddress = GetComputerName()
	ClientTyp = "";
	if ((IPAddress != "Exception") && (IPAddress != "")) {
		var ClientStr = tkMakeServerCall("web.DHCVISTreatQueue", "GetClientStr", IPAddress)
		ClientTyp = tkMakeServerCall("web.DHCVISQueueManage", "GetClientQueueType", IPAddress)
	} else {
		var ClientStr = tkMakeServerCall("web.DHCVISTreatQueue", "GetClientStr");
	}

	if (ClientStr != "") {
		combo_ClientList = dhtmlXComboFromStr("ClientList", ClientStr);
		combo_ClientList.enableFilteringMode(true);
		combo_ClientList.selectHandle = combo_ClientListKeydownhandler;
		combo_ClientList.keyenterHandle = combo_ClientListKeyenterhandler;
		combo_ClientList.attachEvent("onKeyPressed", combo_ClientListKeyenterhandler)
		combo_ClientList.selectOption(0, false, true)
		combo_ClientList.setComboText(combo_ClientList.optionsArr[0].text)
		var ClientId = combo_ClientList.getActualValue();
		DHCC_SetElementData('ClientId', ClientId);
		var Obj = document.getElementById("btnTreatQueue");
		if (Obj) Obj.style.display = "block";
	} else {
		var Obj = document.getElementById("ClientList");
		if (Obj) Obj.style.display = "none";
		var Obj = document.getElementById("cClientList");
		if (Obj) Obj.style.display = "none";
		var Obj = document.getElementById("btnTreatQueue");
		if (Obj) Obj.style.display = "none";
	}
}

function combo_ClientListKeydownhandler() {
	var obj = combo_ClientList;
	var ClientId = obj.getActualValue();
	var ClientDesc = obj.getSelectedText();
	DHCC_SetElementData('ClientId', ClientId);
}

function combo_ClientListKeyenterhandler(e) {
	try {
		keycode = websys_getKey(e);
	} catch (e) {
		keycode = websys_getKey();
	}
	if (keycode == 13) {
		combo_ClientListKeydownhandler();
	}
}

function DHCC_GetElementData(ElementName) {
	var obj = document.getElementById(ElementName);
	if (obj) {
		if (obj.tagName == 'LABEL') {
			return obj.innerText;
		} else {
			if (obj.type == 'checkbox') return obj.checked;
			return obj.value;
		}
	}
	return "";
}

function DHCC_SetElementData(ElementName, value) {
	var obj = document.getElementById(ElementName);
	if (obj) {
		obj.value = value;
	}
	return "";
}

function GetComputerIp() {
	var ip = tkMakeServerCall("web.DHCNurTreatQueue", "getComputerIp")
	return ip;
	// var ipAddr;
	// try
	// {
	//    var obj = new ActiveXObject("rcbdyctl.Setting");
	//    ipAddr=obj.GetIPAddress;
	//    obj = null;
	// }
	// catch(e)
	// {
	//    ipAddr="Exception";
	// }
	// return ipAddr;
}

function GetComputerName() {
	var computerName;
	try {
		var WshNetwork = new ActiveXObject("WScript.Network");
		computerName = WshNetwork.ComputerName;
		WshNetwork = null;
	} catch (e) {
		computerName = "Exception";
	}
	return computerName;
}

function OrdBook_Click() {
	var count = 0;
	var oeoriId = "";
	var arimDesc = "";
	for (var i = 1; i < tableRows; i++) {
		var check = document.getElementById('seleitemz' + i);
		arimDesc = document.getElementById("arcimDescz" + i).innerText;
		if (arimDesc.indexOf("____") > -1) {
			continue;
		}
		if (check.checked == true) {
			count = count + 1
			oeoriId = document.getElementById("oeoriIdz" + i).innerText;

		}
	}
	if (count != 1) {
		alert("请选择一组医嘱!");
		return;
	}
	if (oeoriId == "") return;
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurBooked" + "&ordStr=" + oeoriId;
	window.open(lnk, "DHCNurOPTreatResult", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=250,width=750,top=260,left=500");
	return;
}
document.body.onload = BodyLoadHandler;