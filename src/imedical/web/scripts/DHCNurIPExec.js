var listvar = new Array();
var HospitalRowId = "";
var vartyp = "" //document.getElementById("vartyp").value;
var mthgetvar = "" //document.getElementById("getvar").value;
	//var str=cspRunServerMethod(mthgetvar,vartyp);
var listvar; //=str.split("^");

var queryTypeCode = "" //document.getElementById("vartyp").value;
var longNewOrdAdd = false;
var hospitalName = "" //document.getElementById("hospitalName").value;

//var GetTitle=""; //document.getElementById("GetTitle").value;
var titleStr = ""; //cspRunServerMethod(GetTitle,queryTypeCode);
//if (titleStr.length=0) {alert(t['val:setVar']);}
var titleList; //=titleStr.split("^")
var myColumns; //=titleList[1].split("!")
var varList; //=titleList[2].split("!")
var ordStatDescInd; //=GetArrayIndex(varList,"ordStatDesc");
var execXDateTimeInd; //=GetArrayIndex(varList,"execXDateTime");
var execXUserDescInd; //=GetArrayIndex(varList,"execXUserDesc");
var oeoriIdInd; //=parseInt(titleList[0])
var disposeStatInd; //=oeoriIdInd+2;

var disposeStatDescInd; //=GetArrayIndex(varList,"disposeStatDesc");
var arcimDescInd; //=GetArrayIndex(varList,"arcimDesc");
var doseQtyUnitInd; //=GetArrayIndex(varList,"doseQtyUnit");
var phOrdQtyUnitInd; //=GetArrayIndex(varList,"phOrdQtyUnit");
var execStatInd; //=GetArrayIndex(varList,"execStat");
var execDateTimeInd; //=GetArrayIndex(varList,"execDateTime");
var execCtcpDescInd; //=GetArrayIndex(varList,"execCtcpDesc");
var prtFlagInd; //=GetArrayIndex(varList,"prtFlag");
var oecprDescInd; //=GetArrayIndex(varList,"oecprDesc");
var labNoInd; //=GetArrayIndex(varList,"labNo");
var freqInd; //=GetArrayIndex(varList,"phcfrCode");
var reclocDescInd; //=GetArrayIndex(varList,"reclocDesc")
var preSelectRow = 0;
var prePlacerNo = ""

function BodyLoadHandler() {
	checkData.length = serverOrderData.length;
	var hospitalObj = document.getElementById("hospitalName").value;
	if (hospitalObj) hospitalName = hospitalObj.value;
	obj = document.getElementById("btnMergeLab");
	if (obj) {
		obj.onclick = MergeLab;
	}
	queryTypeCode = document.getElementById("vartyp").value;
	vartyp = document.getElementById("vartyp").value;
	var objHospitalRowId = document.getElementById("HospitalRowId");
	if (objHospitalRowId) HospitalRowId = objHospitalRowId.value;
	else HospitalRowId = "0";
	var mthgetvar = document.getElementById("getvar").value;
	var str = cspRunServerMethod(mthgetvar, vartyp, HospitalRowId);
	var listvar = str.split("^");
	var longNewOrdAdd = false;
	var objlongNewOrdAdd = document.getElementById("longNewOrdAdd");
	if (objlongNewOrdAdd) longNewOrdAdd = objlongNewOrdAdd.value;
	var onlyNewOrd = false; //+ wxl 090325 
	var objOnlyNewOrd = document.getElementById("longNewOrd");
	if (objOnlyNewOrd) onlyNewOrd = objOnlyNewOrd.value; //+

	objExec = document.getElementById("OrdExcute")
	if (objExec) {
		if (longNewOrdAdd) objExec.style.visibility = "hidden";
		else objExec.style.visibility = "visible";
	}
	objCancelEx = document.getElementById("CancelEx")
	objGetIfCancel = document.getElementById("GetIfCancel");
	if (objCancelEx) {
		if (objGetIfCancel) {
			var flage = cspRunServerMethod(objGetIfCancel.value, session['LOGON.GROUPID'])
		}
		if (flage == '0') {
			objCancelEx.style.visibility = "hidden";
		} else {
			objCancelEx.style.visibility = "visible"
		}
	}
	var objtbl = document.getElementById('tDHCNurIPExec');
	tableRows = objtbl.rows.length; //ypz placerno
	obj = document.getElementById("SelectAll");
	if (obj) {
		obj.onclick = SelectAll_Click;
	}
	var OrdExcuteobj = document.getElementById("OrdExcute");
	if (OrdExcuteobj) {
		OrdExcuteobj.onclick = OrdExcute_click;
	}
	var CancelExobj = document.getElementById("CancelEx");
	if (CancelExobj) {
		CancelExobj.onclick = CancelEx_click;
	}
	obj = document.getElementById("sycbtn");
	if (obj) {
		obj.onclick = PrintSelSYCARD;
	} //print inject card
	obj = document.getElementById("insertBatch");
	if (obj) {
		obj.onclick = insertBatchClick;
	}
	obj = document.getElementById("skinTestAllergy"); //ypz 060924
	if (obj) {
		obj.onclick = SkinTestAllergy
	} //ypz 060924
	//ypz temp//if (obj) {obj.onclick=PrintSelSYCARD;} //ypz 060924
	var objPrintbut = document.getElementById("printbut");
	if (objPrintbut) {
		objPrintbut.onclick = PrintClick;
	}
	var obj = document.getElementById("printbarbut");
	if (obj) {
		obj.onclick = PrintbarClick;
	}
	var objBtnSetPlacerNo = document.getElementById("btnSetPlacerNo"); //ypz 060613
	if (objBtnSetPlacerNo) {
		objBtnSetPlacerNo.onclick = SetPlacerNo;
	}; //ypz 060613
	var objPlacerNo = document.getElementById("curPlacerNo");
	if (objPlacerNo) objPlacerNo.onkeydown = PlacerNoLinkLabNo;
	var obj = document.getElementById("skinTestNormal"); //ypz 060924
	if (obj) {
		obj.onclick = SkinTestNormal
	} //ypz 060924
	var obj = document.getElementById("SetSkinTest");
	if (obj) {
		obj.onclick = SetSkinTestClick
	}
	var obj = document.getElementById("skinTestAudit");
	if (obj) {
		obj.onclick = skinTestAuditClick
	}
	obj = document.getElementById("bedBtn");
	if (obj) {
		obj.onclick = PrintBedCard;
	}
	obj = document.getElementById("OrdSee");
	if (obj) {
		obj.onclick = OrdSee_Click;
	}
	obj = document.getElementById("UnOrdSee");
	if (obj) {
		obj.onclick = UnOrdSee_Click;
	}
	var objAddLock = document.getElementById("AddLock");
	if (objAddLock) {
		objAddLock.onclick = AddLock_Click;
		objAddLock.style.visibility = "hidden";
	}
	var objUnLock = document.getElementById("UnLock");
	if (objUnLock) {
		objUnLock.onclick = UnLock_Click;
		objUnLock.style.visibility = "hidden";
	}
	var useridobj = document.getElementById("userId");
	useridobj.value = session['LOGON.USERID'];
	var isPdaExec = false;
	var objPdaExec = document.getElementById("pdaExec");
	if (objPdaExec) {
		if (objPdaExec.value) {
			isPdaExec = true;
			if (OrdExcuteobj) OrdExcuteobj.style.visibility = "hidden";
		} else {
			if (OrdExcuteobj) OrdExcuteobj.style.visibility = "visible";
		}
	}
	var UnOrdSeeobj = document.getElementById("UnOrdSee");
	if (UnOrdSeeobj) {
		if (excute == true) {
			UnOrdSeeobj.style.visibility = "visible";
		} else {
			UnOrdSeeobj.style.visibility = "hidden";
		}
	}
	var OrdSeeobj = document.getElementById("OrdSee");
	if (OrdSeeobj) {
		if (excute == true) {
			OrdSeeobj.style.visibility = "hidden";
		} else {
			OrdSeeobj.style.visibility = "visible";
		}
	}
	if ((tableRows > 1) && (vartyp == "JYD")) //ypz placerno 
	{
		var obj = document.getElementById('placerNoz1');
		if (obj) {
			websys_setfocus('placerNoz1');
			prePlacerNo = obj.value;
		}
	} else {
		var objPlacerNo = document.getElementById('curPlacerNo');
		if (objPlacerNo) {
			objPlacerNo.style.display = "none";
			document.getElementById('ccurPlacerNo').style.display = "none";
		}
		var ObjbtnSetPlacerNo = document.getElementById("btnSetPlacerNo")
		if (ObjbtnSetPlacerNo) {
			ObjbtnSetPlacerNo.style.display = "none";
		}
	}
	//if (((vartyp!="LSPYD")&&(vartyp!="CQPYD"))||isPdaExec)
	if (vartyp.indexOf("SYD") < 0) {
		document.getElementById('sycbtn').style.display = "none";
		document.getElementById('bedBtn').style.display = "none";
	}

	if (((vartyp != "PSD") && (vartyp != "PSDO")) || isPdaExec) {
		var Obj = document.getElementById('skinTestNormal')
		if (Obj) Obj.style.display = "none";
		var Obj = document.getElementById('skinTestAllergy')
		if (Obj) Obj.style.display = "none";
	}
	if (vartyp.indexOf("PSD") > -1) {
		var userid = session['LOGON.USERID'];
		var excuteflag = document.getElementById('excuteflag').value;
		var psflag = cspRunServerMethod(excuteflag, userid);
		if (psflag == "true") {
			var Obj = document.getElementById('skinTestNormal')
			if (Obj) Obj.style.display = "none";
			var Obj = document.getElementById('skinTestAllergy')
			if (Obj) Obj.style.display = "none";
		}
	}
	if ((vartyp == "Default") || (vartyp == "") || (vartyp == "BLD") || (vartyp == "SXD") || (vartyp == "PSD") || (vartyp == "jyd") || (vartyp == "JYDOU")) {
		var Obj = document.getElementById('OrdExcute')
		if (Obj) Obj.style.display = "none";
		var Obj = document.getElementById('CancelEx')
		if (Obj) Obj.style.display = "none";
	}
	if (vartyp == "YZXYZ") {
		var Obj = document.getElementById('OrdExcute')
		if (Obj) Obj.style.display = "none";

	}
	if (vartyp != "DefaultSee") {
		var Obj = document.getElementById('UnOrdSee')
		if (Obj) Obj.style.display = "none";
		var Obj = document.getElementById('OrdSee')
		if (Obj) Obj.style.display = "none";
	}
	if ((vartyp == "WZX") || (vartyp == "XYZ")) {
		var Obj = document.getElementById('CancelEx')
		if (Obj) Obj.style.display = "none";
		if (objPrintbut) objPrintbut.style.display = "none";
	}

	if (isPdaExec) {
		if (objPrintbut) objPrintbut.style.display = "none";
	}
	document.getElementById('btnMergeLab').style.display = "none";
	// if (vartyp.indexOf("JYD") < 0) {

	// }
	if ((vartyp == "DefaultSee") || (vartyp == "Default")) {
		document.getElementById('OrdExcute').style.display = "none";
		document.getElementById('CancelEx').style.display = "none";
		if (objPrintbut) objPrintbut.style.display = "none";
	}
	if (vartyp == "YZXYZ") {

		if (objPrintbut) objPrintbut.style.display = "none";
	}
	if (vartyp == "TZXZX") {

		document.getElementById('OrdExcute').style.display = "none";
		document.getElementById('CancelEx').style.visibility = "visible"
		document.getElementById('CancelEx').style.display = "block";
	}

	if (queryTypeCode != "") {
		var GetTitle = document.getElementById("GetTitle").value;
		var titleStr = cspRunServerMethod(GetTitle, queryTypeCode, HospitalRowId);
		if (titleStr.length = 0) {
			alert(t['val:setVar']);
		}
		titleList = titleStr.split("^")
		myColumns = titleList[1].split("!")
		varList = titleList[2].split("!")
		ordStatDescInd = GetArrayIndex(varList, "ordStatDesc");
		ExecXDateTimeInd = GetArrayIndex(varList, "execXDateTime");
		ExecXUserDescInd = GetArrayIndex(varList, "execXUserDesc");
		oeoriIdInd = parseInt(titleList[0])
		disposeStatInd = oeoriIdInd + 2;
		disposeStatDescInd = GetArrayIndex(varList, "disposeStatDesc");
		arcimDescInd = GetArrayIndex(varList, "arcimDesc");
		doseQtyUnitInd = GetArrayIndex(varList, "doseQtyUnit");
		phOrdQtyUnitInd = GetArrayIndex(varList, "phOrdQtyUnit");
		execStatInd = GetArrayIndex(varList, "execStat");
		execDateTimeInd = GetArrayIndex(varList, "execDateTime");
		execCtcpDescInd = GetArrayIndex(varList, "execCtcpDesc");
		prtFlagInd = GetArrayIndex(varList, "prtFlag");
		oecprDescInd = GetArrayIndex(varList, "oecprDesc");
		labNoInd = GetArrayIndex(varList, "labNo");
		freqInd = GetArrayIndex(varList, "phcfrCode");
		reclocDescInd = GetArrayIndex(varList, "reclocDesc")
		var GetVarType = document.getElementById("GetVarType");
		var str = cspRunServerMethod(GetVarType.value, queryTypeCode, HospitalRowId);
		var tmpList = str.split("^");
		if (tmpList[3] == "Y") {
			//document.getElementById("printbut").style.display="block";
		} else {
			document.getElementById("Copies").style.display = "none";
			document.getElementById("cCopies").style.display = "none";
			//document.getElementById("cchkSelPrint").style.display="none";
			//document.getElementById("chkSelPrint").style.display="none";
			document.getElementById("printbut").style.display = "none";
		}
	}
	for (i = 1; i < objtbl.rows.length; i++) {
		var eSrc = objtbl.rows[i];
		var RowObj = getRow(eSrc);
		var obj = document.getElementById('placerNoz' + i);
		if (obj) obj.onkeydown = ReplyKeydown;
	}
	IntVar();
	//添加合理用药  和 采集注意事项  pjf 2016-3-2
	positionMouse = {};
	$("#tDHCNurIPExec tr").on("mouseenter", function(event) {
		positionMouse.left = event.pageX;
		positionMouse.top = event.pageY;
	})
	$(document).tooltip({
		items: "#tDHCNurIPExec tr",
		position: {
			my: "center center",
			at: "left top",
			using: function(position, feedback) {
				position.left = positionMouse.left
				position.top = positionMouse.top
				$(this).css(position);
			}
		},
		content: function() {
			var tdOeordId = $(this).children("td[id^='oeoriIdz']");
			if (tdOeordId.length != 0) {
				
				var oeordId = tdOeordId.html();
				var ret = tkMakeServerCall("Nur.DHCNurKnowledgeBase", "CheckOrdLibPha", oeordId, session['LOGON.USERID'], session['LOGON.CTLOCID'], session['LOGON.GROUPID']);
				var libJosn = eval(ret);
				var groupInfo = "";
				if(libJosn.length>0){
					var jsonObj = libJosn[0];
					var passFlag = jsonObj.passFlag;
					var infoArray=jsonObj.retMsg;
					var info ="";
					if(infoArray.length>0){
						for (var k = 0; k < infoArray.length; k++) {
								if (infoArray[k].chlidren.length <1) {
									continue;
								}
								info = "<b>" + infoArray[k].geneDesc;
								for(var j = 0; j < infoArray.length; j++){
									info = info + "<br></br><b>" + infoArray[k].chlidren[j].alertMsg;
								}
							}
							if (groupInfo == "") {
								groupInfo = info;
							} else {
								groupInfo = groupInfo + "<br></br>" + info;
							}
					}
					return groupInfo;
				}
				/*debugger;
				if (ret != null) {
					var alertInfoArray = ret.split("^")
					if (alertInfoArray[0] != 0) {
						var groupInfo = ""
						for (var i = 1; i < alertInfoArray.length; i++) {
							var info = "";
							var infoArray = alertInfoArray[i].split("!");
							for (var k = 0; k < infoArray.length; k++) {
								if (infoArray[k] == "") {
									continue;
								}
								if (infoArray[k].indexOf("/$") < 0) {
									var detailInfoArray = infoArray[k].split("@")
									if (info == "") {
										info = "<b>" + detailInfoArray[0];
									} else {
										info = info + "<br></br><b>" + detailInfoArray[0];
									}
									if (detailInfoArray[1] != "") {
										info = info + "---" + detailInfoArray[1] + "</b>"
									} else {
										info = info + "</b>"
									}
								} else { //采集注意事项
									var detailInfoArray = infoArray[k].split("@")
									if (info == "") {
										info = "<b>" + detailInfoArray[0] + "</b>";
									} else {
										info = info + "<br></br><b>" + detailInfoArray[0] + "</b>";
									}
									if (detailInfoArray[1] != "") {
										var detailInfoLabArray = detailInfoArray[1].split("/*");
										for (var j = 0; j < detailInfoLabArray.length; j++) {
											if (detailInfoLabArray[j] == "") {
												continue;
											}
											var detailInfoLabContentArray = detailInfoLabArray[j].split("/$");
											info = info + "<br></br><b>" + detailInfoLabContentArray[0] + "</b>";
											info = info + "<br></br><b>" + detailInfoLabContentArray[1].replace(/\/n/g, "<br></br>") + "</b>";
										}
									}
								}

							}
							if (groupInfo == "") {
								groupInfo = info;
							} else {
								groupInfo = groupInfo + "<br></br>" + info;
							}

						}
						return groupInfo;

					}
				}*/
			}
		}
	});



}



function MatchDemo(str) {
	var r, re;
	//alert(str);                   //
	re = new RegExp(t['val:skinTest']); // 
	r = str.match(re); //
	return (r); //
}

function SelectAll_Click() {
	var obj = document.getElementById("SelectAll");
	var Objtbl = document.getElementById('tDHCNurIPExec');
	var Rows = Objtbl.rows.length;
	for (var i = 1; i < Rows; i++) {
		var selobj = document.getElementById('seleitemz' + i);
		selobj.checked = obj.checked;
		checkData[i] = obj.checked;
	}
}

function DHCWeb_GetRowIdx(wobj) {
	try {
		var eSrc = wobj.event.srcElement;
		if (eSrc.tagName == "IMG") eSrc = wobj.event.srcElement.parentElement;
		var rowObj = getRow(eSrc);
		var selectrow = rowObj.rowIndex;
		if (selectrow < 1) return 0;
		var disposeStatCode = "";
		if (preSelectRow > 0) disposeStatCode = document.getElementById("disposeStatCodez" + preSelectRow).innerText;
		if (preSelectRow != selectrow) {
			rowObj.className = "clsRowSelected";
			if (preSelectRow > 0) {
				var objTbl = document.getElementById("tDHCNurIPExec");
				var preESrc = objTbl.rows[preSelectRow];
				var preRowObj = getRow(preESrc);
				preRowObj.className = disposeStatCode;
			}
		} else {
			if (rowObj.className != "clsRowSelected") rowObj.className = "clsRowSelected"
			else rowObj.className = disposeStatCode
		}
		preSelectRow = selectrow
		return selectrow
	} catch (e) {
		alert(e.toString());
		return -1;
	}
}

function SelectRow(selectrow) {
	var i, tmpList;
	if (selectrow < 1) return;
	var item = document.getElementById("seleitemz" + selectrow);
	var RowId = document.getElementById("oeoriIdz" + selectrow).innerText;
	var getPlacerNo = document.getElementById("getPlacerNo").value;
	var resStr = cspRunServerMethod(getPlacerNo, RowId);
	var curPlacerObj = document.getElementById("curPlacerNo")
	if (curPlacerObj) curPlacerObj.value = resStr;
	tmpList = RowId.split("||");
	var patOrder = tmpList[0];
	var mainOriSub = tmpList[1];
	var mainOreSub = "";
	if (tmpList[2]) mainOreSub = tmpList[2];

	var eSrc = window.event.srcElement;
	var objtbl = document.getElementById('tDHCNurIPExec');
	Rows = objtbl.rows.length;
	var rowObj = getRow(eSrc);
	var obj = document.getElementById("SelectAll");
	if (!obj.checked) {
		SelRowObj = document.getElementById('seleitemz' + selectrow);
		if (eSrc.id != 'seleitemz' + selectrow) {
			if (SelRowObj.checked == 1) {
				SelRowObj.checked = 0;
			} else {
				SelRowObj.checked = 1;
			}
		}
	}
	var flag = item.checked;
	checkData[selectrow] = flag;
	var mainSeqNo = document.getElementById("tmpSeqNoz" + selectrow).innerText;
	if (mainOriSub != mainSeqNo) {
		for (i = selectrow - 1; i >= 1; i--) {
			var item = document.getElementById("seleitemz" + i);
			var Arc = document.getElementById("arcimDescz" + i).innerText; //
			var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
			tmpList = oeoriId.split("||");
			if (tmpList[0] == patOrder) {
				var tmpSeqNo = document.getElementById("tmpSeqNoz" + i).innerText;
				if (tmpSeqNo == mainSeqNo) {
					item.checked = flag;
					checkData[i] = flag;
					//if (mainOreSub=="") item.checked=flag;
					// else{
					// if (tmpList[2])
					// {
					// if (mainOreSub==tmpList[2]) item.checked=flag;
					// }
					// }
				} else break;
			} else break;
		}
	}
	for (i = selectrow + 1; i < objtbl.rows.length; i++) {
		var item = document.getElementById("seleitemz" + i);
		var Arc = document.getElementById("arcimDescz" + i).innerText; //
		var oeoriId = document.getElementById("oeoriIdz" + i).innerText;

		tmpList = oeoriId.split("||");
		if (tmpList[0] == patOrder) {

			var tmpSeqNo = document.getElementById("tmpSeqNoz" + i).innerText;
			if (tmpSeqNo == mainSeqNo) {
				item.checked = flag;
				checkData[i] = flag;
				//  if (mainOreSub=="") item.checked=flag;
				//else{
				//     if (tmpList[2]){

				// if (mainOreSub==tmpList[2]) item.checked=flag;
				//   }
				//}
			} else break;
		} else break;
	}
	var queryTypeCode = document.getElementById("vartyp").value;
	if ((queryTypeCode == "JYD") || (queryTypeCode.indexOf("Default") > -1) || (queryTypeCode == "WZX") || (queryTypeCode == "YZXYZ") || (queryTypeCode == "YZXYZ") || (queryTypeCode == "XYZ")) {
		var labNo = document.getElementById("labNoz" + selectrow).innerText;
		for (i = selectrow - 1; i >= 1; i--) {
			var item = document.getElementById("seleitemz" + i);
			var labNo1 = document.getElementById("labNoz" + i).innerText;
			if ((labNo1 == labNo) && (labNo != "") && (labNo != " ")) {

				item.checked = flag;
				checkData[i] = flag;


			}
		}

		for (i = selectrow + 1; i < objtbl.rows.length; i++) {
			var item = document.getElementById("seleitemz" + i);
			//var Arc=document.getElementById("arcimDescz"+i).innerText;//
			//var oeoriId=document.getElementById("oeoriIdz"+i).innerText;
			var labNo1 = document.getElementById("labNoz" + i).innerText;
			//tmpList=oeoriId.split("||");
			if ((labNo1 == labNo) && (labNo != "") && (labNo != " ")) {
				item.checked = flag;
				checkData[i] = flag;
			}
		}
	}
}

function SelectRowHandler() {
	var i, tmpList;
	var selectrow = DHCWeb_GetRowIdx(window);
	if (selectrow < 1) return; //ypz 080926
	var item = document.getElementById("seleitemz" + selectrow); //arcimDesc//ypz 080926
	var RowId = document.getElementById("oeoriIdz" + selectrow).innerText; //ypz 080926
	//ypz begin 060613
	var getPlacerNo = document.getElementById("getPlacerNo").value;
	var resStr = cspRunServerMethod(getPlacerNo, RowId);
	var placerNo = document.getElementById("curPlacerNo").value = resStr;
	//ypz end
	tmpList = RowId.split("||");
	var patOrder = tmpList[0]; //ypz 061225 select other pat order
	var mainOriSub = tmpList[1];
	var mainOreSub = "";
	if (tmpList[2]) mainOreSub = tmpList[2];
	//2007-03-05 cjb begin
	var eSrc = window.event.srcElement;
	var objtbl = document.getElementById('tDHCNurIPExec');
	Rows = objtbl.rows.length;
	var rowObj = getRow(eSrc); //
	//ypz 080926//var selectrow=rowObj.rowIndex;
	//ypz 080926//if (!selectrow) return;
	var obj = document.getElementById("SelectAll");
	if (!obj.checked) {
		SelRowObj = document.getElementById('seleitemz' + selectrow);
		if (eSrc.id != 'seleitemz' + selectrow) { //avoid selected col 'seleitemz'+selectrow
			if (SelRowObj.checked == 1) {
				SelRowObj.checked = 0;
			} else {
				SelRowObj.checked = 1;
			}
		}
	}
	//070305 
	var flag = item.checked;
	var mainSeqNo = document.getElementById("tmpSeqNoz" + selectrow).innerText;
	if (mainOriSub != mainSeqNo) return;
	for (i = selectrow + 1; i < objtbl.rows.length; i++) //ypz 080926
	{
		var item = document.getElementById("seleitemz" + i); //arcimDesc
		var Arc = document.getElementById("arcimDescz" + i).innerText; //
		var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
		tmpList = oeoriId.split("||");
		if (tmpList[0] == patOrder) //ypz 061225 select other pat order
		{
			//var OrdCheck=Arc.split(mainOriSub);
			//if (OrdCheck[0]=="____")
			var tmpSeqNo = document.getElementById("tmpSeqNoz" + i).innerText;
			if (tmpSeqNo == mainSeqNo) {
				if (mainOreSub == "") item.checked = flag;
				else {
					if (tmpList[2]) {
						if (mainOreSub == tmpList[2]) item.checked = flag;
					}
				}
			} else break; //ypz 080926
		} else break; //ypz 080926
	}
}

function hidcol(col, objtbl) //hide col
	{
		for (var i = 1; i < objtbl.rows.length; i++) {
			objtbl.rows(i).cells(col).style.display = "none";
		}
	}

function OrdSee_Click() {
	var count = 0;
	var oeoriStr = "";
	var Objtbl = document.getElementById('tDHCNurIPExec');
	var tableRows = Objtbl.rows.length;
	for (var i = 1; i < tableRows; i++) {
		var check = document.getElementById('seleitemz' + i);
		if (check.checked == true) {
			count++;
		}
	}
	if (count == 0) {
		alert("请选择医嘱");
		return;
	}
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurOrdSee";
	window.open(lnk, "DHCNurOrdSee", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=300,width=300,top=100,left=400");
	return;
	var count = 0;
	var oeoriStr = "";
	var Objtbl = document.getElementById('tDHCNurIPExec');
	var tableRows = Objtbl.rows.length;
	for (var i = 1; i < tableRows; i++) {
		var check = document.getElementById('seleitemz' + i);
		if (check.checked == true) {
			count = count + 1;
			var arcimDesc = document.getElementById("arcimDescz" + i).innerText; //ypz 070126
			if (arcimDesc.indexOf("____") > -1) continue;
			var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
			if (oeoriStr == "") oeoriStr = oeoriId
			else oeoriStr = oeoriStr + "^" + oeoriId
		}
	}
	if (count < 1) {
		alert("请选择医嘱");
		return;
	}
	var ret = tkMakeServerCall("web.DHCLCNUREXCUTE", "SeeOrder", oeoriStr, session['LOGON.USERID'])
	if (ret == 0) {
		alert("处理成功")
		self.location.reload();
	} else {
		alert(ret)
	}
}

function UnOrdSee_Click() {
	var count = 0;
	var oeoriStr = "";
	var Objtbl = document.getElementById('tDHCNurIPExec');
	var tableRows = Objtbl.rows.length;
	for (var i = 1; i < tableRows; i++) {
		var check = document.getElementById('seleitemz' + i);
		if (check.checked == true) {
			var ordstat = document.getElementById("ordStatDescz" + i).innerText;
			var dispose = document.getElementById("disposeStatCodez" + i).innerText;
			if ((ordstat == t['val:dischOrd']) && (dispose == "ExecDiscon")) {
				alert("不能撤销已处理停止医嘱")
				return;
			}
			count = count + 1
			var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
			if (oeoriStr == "") oeoriStr = oeoriId
			else oeoriStr = oeoriStr + "^" + oeoriId
		}
	}

	if (count < 1) {
		alert("请选择医嘱");
		return;
	}
	var ret = tkMakeServerCall("web.DHCLCNUREXCUTE", "UnSeeOrder", oeoriStr, session['LOGON.USERID'])
	if (ret == 0) {
		alert("撤销成功")
		self.location.reload();
	} else {
		alert(ret)
	}
}

function CancelEx_click() //cancel
	{
		var objtbl = document.getElementById('tDHCNurIPExec');
		var rowid;
		var change = false;
		rowid = "";
		var resStr = "";
		for (i = 1; i < objtbl.rows.length; i++) {
			var item = document.getElementById("seleitemz" + i);
			if (item.checked == true) {

				var arcimDesc = document.getElementById("arcimDescz" + i).innerText; //ypz 070126
				if (arcimDesc.indexOf("____") > -1) continue;
				var dispose = document.getElementById("disposeStatCodez" + i).innerText;
				if ((dispose != "Exec") && (dispose != "ExecDiscon") && (dispose != "Needless") && (dispose != "LackOfFee") && (dispose != "SkinTest") && (dispose != "PreDiscon") && (dispose != "SkinTestNorm")) {} else {
					var userid = session['LOGON.USERID'];
					var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
					var ordstat = document.getElementById("ordStatDescz" + i).innerText; // ) //"D/C (Discontinued)")
					var unexemth = document.getElementById("UndoDisconOrder").value;

					if ((ordstat == t['val:dischOrd']) && (dispose == "ExecDiscon")) {
						alert("不能撤销已经停止处理的医嘱")
						continue;
						var execCtcpDesc = document.getElementById("execCtcpDescz" + i).innerText;
						if (execCtcpDesc == " ") {
							if (cspRunServerMethod(unexemth, oeoriId, userid) == '0') {}
						} else {
							// var truthBeTold = window.confirm("comfirm exec or cancel");
							// if (truthBeTold){chexiaoExcute(i);}
							//else {
							if (cspRunServerMethod(unexemth, oeoriId, userid) == '0') {}
							// }
						}
					} else //cancel exec
					{
						change = true;
						resStr = chexiaoExcute(i);
						if (resStr != "0") {
							return;
						}
					}
				}
			}
		}
		if (change == true) {
			alert(t['alert:success']);
			self.location.reload();
		}
	}

function chexiaoExcute(i) {
	var userId = session['LOGON.USERID'];
	var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
	var ordstat = document.getElementById("ordStatDescz" + i).innerText;
	var arcicId = "";
	var updateOrdGroup = document.getElementById("UpdateOrdGroup").value;
	var ordstat = document.getElementById("ordStatDescz" + i).innerText;

	var ifNewInspect = tkMakeServerCall("web.DHCEMInterface","GetOrdExecDesc",oeoriId);
	if ((ordstat == t['val:exec'])&&(ifNewInspect==""))
	{
		alert(t['alert:noCancelExecOrd']);
		return;
	}
	// var sttDateTime=document.getElementById("sttDateTimez"+i).innerText;
	var flag = 0
	var skinTestFlag = ""
	var execStatusDr = "C" //撤销执行
	var ctlocId = session['LOGON.CTLOCID'];
	var queryTypeCode = ""
	var exedate = ""
	var exetime = ""
	var changeReasonDr = ""
	var resStr = cspRunServerMethod(updateOrdGroup, skinTestFlag, oeoriId, execStatusDr, userId, ctlocId, queryTypeCode, exedate, exetime, changeReasonDr);
	if (resStr == '0') {
		var execDateTime = document.getElementById("execDateTimez" + i);
		var execCtcpDesc = document.getElementById("execCtcpDescz" + i);
		var execStat = document.getElementById("execStatz" + i);
		if (execDateTime) execDateTime.innerText = "";
		if (execCtcpDesc) execCtcpDesc.innerText = "";
		if (execStat) execStat.innerText = "";
		return resStr;
	} else {
		alert(resStr);
		return resStr;
	}
}

function OrdExcute_click() {
	var objtbl = document.getElementById('tDHCNurIPExec');
	var rowid;
	rowid = "";
	for (var i = 1; i < objtbl.rows.length; i++) {
		var item = document.getElementById("seleitemz" + i);
		if (item.checked == true) {
			var arcimDesc = document.getElementById("arcimDescz" + i).innerText; //ypz 070126
			if (arcimDesc.indexOf("____") > -1) continue; //070126
			//var disposeStatDesc = document.getElementById("disposeStatDescz" + i).innerText;
			var disposeStatCode = document.getElementById("disposeStatCodez" + i).innerText;
			if(disposeStatCode=="ExecDiscon"){
				alert("不能执行已经停止处理的医嘱【"+arcimDesc+"】!!");
				return ;
			}
			//var basedose = document.getElementById("doseQtyUnitz" + i).innerText;
			var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
			var arcicId = ""; //ypz 061113//document.getElementById("arcicIdz"+i).innerText;
			rowid = rowid + "^"  + "!" + oeoriId + "!" + arcicId + "!" + i;
			if (vartyp == "JYD") { //ypz placerno
				var objPlacerNo = document.getElementById("placerNoz" + i)
				if (objPlacerNo) {
					var placerNo = document.getElementById("placerNoz" + i).value;
					//if (placerNo.length<10) {alert(t['alert:tooShort']);return;}
				}
			}
		}
	}
	if (rowid == "") return;
	rowid = escape(rowid) //ypz 061019
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCORDEXCUTE" + "&AAA=1&BBB=" //+rowid;
	window.open(lnk, "OrdExec", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=300,width=350,top=100,left=300");
}

function SearCH_click() {
	var method = document.getElementById("schord");
	var wardno = document.getElementById("wardid").value;
	var regno = document.getElementById("RegNo").value;
	var userid = session['LOGON.USERID'];
	var mthallpatient = document.getElementById("getallpatient");
	if (method) {
		var encmeth = method.value
	} else {
		var encmeth = ''
	};
	if (cspRunServerMethod(encmeth, '', '', wardno, regno, userid) == '0') {}
	if (mthallpatient) {
		var encmeth = mthallpatient.value
	} else {
		var encmeth = ''
	};
	if (cspRunServerMethod(encmeth, 'getallord', '', userid) == '0') {}
}

function getallord(patStr) {
	var tmpList = new Array;
	var patList = new Array;
	var i;
	var stdate = document.getElementById("StartDate").value;
	var enddate = document.getElementById("EndDate").value;
	var rptyp = document.getElementById("ReportList").value;
	var userid = session['LOGON.USERID']
	var wardno = document.getElementById("wardid").value;
	var mthallorditem = document.getElementById("allorditem").value;
	var patList = patStr.split("^");
	//  alert(patStr);
	for (i = 0; i < patList.length; i++) {
		tmpList = patList[i].split("!")
			//   alert(patList[i]);
		if (cspRunServerMethod(mthallorditem, 'schorditem', '', tmpList[0], stdate, enddate, userid, wardno, "Default", "") == '0') {}
		//  alert("i---"+i);
	}
	return;

}

function schorditem(ordItems) {

	var mthgetdata = document.getElementById("getdata").value;
	for (var j = 1; j <= ordItems; j++) {
		if (cspRunServerMethod(mthgetdata, 'inserttable', '', j) == '0') {}
	}
	return;
}

function inserttable(itemData) {
	//alert("itemdata=" + itemData)
	var tmpList = new Array();
	var varstr = new Array();
	var i, j;
	var tmpList = (itemData).split("!");
	var objtbl = document.getElementById('tDHCNurIPExec');
	// alert(itemData);
	var rows = objtbl.rows.length;
	// var Row=rows-1 ;
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
	var row = objtbl.rows.length;
	var objlastrow = objtbl.rows[row - 1];
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

function getwardid(str) {
		var obj = document.getElementById('wardid');
		var tem = str.split("^");
		obj.value = tem[1];
		var obj = document.getElementById('PacWard');
		obj.value = tem[0];
		return;
	} //PacWard
function savetyp(str) {
	var obj = document.getElementById('vartyp');
	var tem = str.split("^");
	obj.value = tem[1];
	return;
}

function PrintBarbak() //print lab barcode
	{
		var execDateTimeInd = GetArrayIndex(varList, "execDateTime");
		var Bar, i, j;
		//test//Bar= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN

		var queryTypeCode = document.getElementById('vartyp').value;
		if ((queryTypeCode.indexOf("JYD") < 0)) return;
		var objtbl = document.getElementById('tDHCNurIPExec');
		var oeoriIdStr = "",
			printedLabNoStr = "^";
		////for (i=1;i<objtbl.rows.length;i++)
		for (i = 0; i < myData.length; i++) {
			////var check=document.getElementById('seleitemz'+i);
			var oeoriId = myData[i][oeoriIdInd]; ////document.getElementById('oeoriIdz'+i).innerText;
			////var PrintFlag=document.getElementById('tmpPrtFlagz'+i).innerText;
			//var disposeStatCode=document.getElementById('disposeStatCodez'+i).innerText;
			var SpecNo = document.getElementById('labNoz' + i).innerText; //ypz 061026
			//if ((check.checked==true)&&(disposeStatCode=="UnPaid")) alert(t['alert:unPaidOrd'])
			var tmpList = printedLabNoStr.split("^" + SpecNo + "^") //ypz 061026
				//if ((check.checked==true)&&(PrintFlag!="Y")&&(disposeStatCode!="UnPaid")&&(tmpList.length<2))
			if ((check.checked == true) && (PrintFlag != "Y") && (tmpList.length < 2)) {
				if (oeoriIdStr.length == 0) {
					oeoriIdStr = oeoriId
				} else {
					oeoriIdStr = oeoriIdStr + "^" + oeoriId
				}
				var pos;
				//alert (myData[i]);
				var PatInfo = document.getElementById("PatInfo").value;
				var str = cspRunServerMethod(PatInfo, oeoriId);
				var arr = str.split("^"); //regNo_"^"_ctloc_"^"_room_"^"_sex_"^"_pagName
				var regNo = arr[0];
				var ctloc = arr[1];
				var room = arr[2];
				var PreOrdSet;
				var GetOrdSet = document.getElementById("GetOrdSet");
				var OrdSet = cspRunServerMethod(GetOrdSet.value, oeoriId);
				if ((PreOrdSet != "") && (OrdSet == PreOrdSet)) {} else {
					var GetSpecName = document.getElementById("SpecName").value;
					var RecLoc = document.getElementById('reclocDescz' + i).innerText;
					var SpecName = cspRunServerMethod(GetSpecName, oeoriId);
					var OrdName = "" ///reclocDesc
					var Sex = arr[3];
					//var PatName=document.getElementById('patNamez'+i).innerText;
					var PatName = regNo + " " + arr[4]
						//var Age=document.getElementById('agez'+i).innerText;
					var Age = arr[7]
					var patLoc = arr[1]
					var tmpList = arr[1].split("-")
					if (tmpList.length > 1) patLoc = tmpList[1]
						//alert(tmpList+"/"+tmpList.length+"/"+patLoc);return;
					if (OrdSet == "") {
						OrdName = document.getElementById('arcimDescz' + i).innerText;
					} else {
						OrdName = OrdSet;
					}
					//alert(RecLoc+"^"+SpecNo+"^"+SpecName+"^"+arr[1]+"^"+OrdName);

					//ypz 061026 begin
					for (j = i + 1; j < objtbl.rows.length; j++) {
						var addSpecNo = document.getElementById('labNoz' + j).innerText;
						var addCheck = document.getElementById('seleitemz' + j);
						var addPrintFlag = document.getElementById('tmpPrtFlagz' + j).innerText;
						//var addDisposeStatCode=document.getElementById('disposeStatCodez'+j).innerText;

						//if ((addCheck.checked==true)&&(addPrintFlag!="Y")&&(addDisposeStatCode!="UnPaid")&&(addSpecNo==SpecNo))
						if ((addCheck.checked == true) && (addPrintFlag != "Y") && (addSpecNo == SpecNo)) {
							addOrdName = document.getElementById('arcimDescz' + j).innerText;
							OrdName = OrdName + "," + addOrdName
						}
					}
					printedLabNoStr = printedLabNoStr + SpecNo + "^"
						//ypz 061026 end
						//alert(OrdSet+"/"+SpecNo+"/"+RecLoc+"/"+patLoc+"/"+OrdName+"/"+PatName+"/"+Sex+"/"+Age)
						//test//
						/*PreOrdSet=OrdSet;
	            Bar.PrintName="tiaoma";//printer name
                Bar.SpecNo=SpecNo;
                Bar.RecLoc=RecLoc;
                Bar.SpecName=SpecName;
                Bar.PatLoc=patLoc;
                Bar.OrdName=OrdName;
                Bar.PatName=PatName;
                Bar.Sex=Sex;
                Bar.Age=Age;
                Bar.PrintOut();*/

				}
			}
		}
		// Bar.PrintOut(SpecNo, SpecName, OrdName, Sex, PatName, Age);
		if (oeoriIdStr.length > 0) {
			////   SetPrintFlag(oeoriIdStr)  //060915
		}

		/*
   var Bar;  
   Bar= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
   var VarTyp=document.getElementById('vartyp').value; 
   if (VarTyp!="JYD") return;
   var objtbl=document.getElementById('tDHCNurIPExec');
   var oeoriIdStr="";
   var PreLabno="";
   var labnum=0;
        for (i=1;i<objtbl.rows.length;i++)
        {
            var check=document.getElementById('seleitemz'+i);
	        var oeori=document.getElementById('oeoriIdz'+i).innerText;
	        var orpar=oeori.split("||");
	        var oeoriId=orpar[0]
	        var PrintFlag=document.getElementById('tmpPrtFlagz'+i).innerText;
	        if ((check.checked==true)&&(PrintFlag!="Y"))
	        {           
	            if (oeoriIdStr.length==0){oeoriIdStr=oeori}
                else{oeoriIdStr=oeoriIdStr+"^"+oeori}
                var pos;
                //alert (myData[i]);
                var PatInfo=document.getElementById("PatInfo").value;
                var str=cspRunServerMethod(PatInfo,oeori);
                var arr=str.split("^");//regno_"^"_ctloc_"^"_room_"^"_sex_"^"_pagName
                var regno=arr[0];
                var ctloc=arr[1]; var room=arr[2];
                var res;
		        var PreOrdSet;
                var GetOrdSet=document.getElementById("LabNoOrdItem");
                var GetSpecName=document.getElementById("SpecName").value;
		        var SpecNo=document.getElementById('labNoz'+i).innerText;
               // var RecLoc=document.getElementById('reclocDescz'+i).innerText;
                //var SpecName=cspRunServerMethod(GetSpecName,oeori);
                var OrdName=""  ///reclocDesc
                var Sex=arr[3];
                var PatName=document.getElementById('patNamez'+i).innerText;
                var Age=document.getElementById('agez'+i).innerText;
                //alert(PreLabno+" "+SpecNo)
                if (((PreLabno!=SpecNo)||(labnum=0))&&(SpecNo!=" "))
                {
	             labnum=labnum+1
	             var OrdSet=cspRunServerMethod(GetOrdSet.value,oeori,SpecNo);
		         PreLabno=SpecNo;
	           //  Bar.DetailsPrinter="BarPrinter";//printer name
                 Bar.SpecNo=SpecNo;
                // Bar.RecLoc=RecLoc;
                // Bar.SpecName=SpecName;
                 Bar.PatLoc=arr[1];
                 Bar.RegNo=arr[0];
                 Bar.OrdName=OrdSet;
                 Bar.PatName=PatName;
                 Bar.Sex=Sex;
                 Bar.Age=Age;
                 Bar.PrintZebraBar();
               }
	         }
	    }
 
  // Bar.PrintOut(SpecNo, SpecName, OrdName, Sex, PatName, Age);
   if (oeoriIdStr.length>0){
      // SetPrintFlag(oeoriIdStr)
    }
*/
	}

function PSH(lnk, nwin) //skintest
	{
		var ward = parent.frames["NurseTop"].document.getElementById("PacWard").value;
		var wardid = parent.frames["NurseTop"].document.getElementById("wardid").value;
		if (wardid == "") {
			alert(t['alert:selWard']);
			return;
		}
		lnk += "&Ward=" + wardid + "&warddes=" + ward;
		window.open(lnk, '_blank', nwin);
	}

function NurFaYao(lnk, nwin) //
	{
		var ward = parent.frames["NurseTop"].document.getElementById("PacWard").value;
		var wardid = parent.frames["NurseTop"].document.getElementById("wardid").value;
		if (wardid == "") {
			alert(t['alert:selWard']);
			return;
		}
		lnk += "&ward=" + wardid + "&warddes=" + ward;
		window.open(lnk, '_blank', nwin);
	}

function LingYao(lnk, nwin) {
	var ward = parent.frames["NurseTop"].document.getElementById("PacWard").value;
	var wardid = parent.frames["NurseTop"].document.getElementById("wardid").value;
	var stdate = parent.frames["NurseTop"].document.getElementById("StartDate").value;
	var edate = parent.frames["NurseTop"].document.getElementById("EndDate").value;
	var ifloc = document.getElementById("ifloc").value
	var sessloc = session['LOGON.CTLOCID'];
	var ret = cspRunServerMethod(ifloc, sessloc);
	var loc;
	if (ret == 1) {
		loc = sessloc;
	} else {
		loc = ""
	}

	if ((wardid == "")) //&&(loc=="")
	{
		alert(t['alert:selWard']);
		return;
	}
	var typ = "on"; //!!typ=-1 lack of fee
	//var typdes=""
	lnk += "&ward=" + wardid + "&warddes=" + ward + "&StDate=" + stdate + "&EDate=" + edate + "&typ=" + typ + "&dep=" + loc; //+"&typdes="+typdes;
	window.open(lnk, '_blank', nwin);
}

function QfLingYao(lnk, nwin) {
	var ward = parent.frames["NurseTop"].document.getElementById("PacWard").value;
	var wardid = parent.frames["NurseTop"].document.getElementById("wardid").value;
	var stdate = parent.frames["NurseTop"].document.getElementById("StartDate").value;
	var edate = parent.frames["NurseTop"].document.getElementById("EndDate").value;
	if (wardid == "") {
		alert(t['alert:selWard']);
		return;
	}
	var typ = -1; //typ=-1  lack of fee
	var typdes = "" //!!chinese char lack of fee
		//alert("in")
	lnk += "&ward=" + wardid + "&warddes=" + ward + "&StDate=" + stdate + "&EDate=" + edate + "&typ=" + typ + "&typdes=" + typdes;
	window.open(lnk, '_blank', nwin);
}

function PrintTemp() {
	var Temp;
	//Temp= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
	var GetServerNameSpace = document.getElementById("GetServerNameSpace").value;
	var ward = parent.frames["NurseTop"].document.getElementById("wardid").value;
	//var serverIp=cspRunServerMethod(GetServerNameSpace);
	if (GetServerNameSpace == "") return;
	if (ward == "") {
		alert(t['alert:selWard']);
		return;
	}
	Temp = new ActiveXObject("ThreeColor.CLSMAIN"); //TestAx.CLSMAIN
	Temp.ward = ward;
	Temp.UserId = session['LOGON.USERID'];
	Temp.ConnectString = GetServerNameSpace;
	////ypz
	Temp.Regno = ""
		//alert(ward+"/"+Temp.ConnectString+"/"+Temp.UserId)
		///ypz
	Temp.Show();
	// return;
}

function SkinTestAllergy() {
	SetSkinTest(true)
}

function SkinTestNormal() {
	SetSkinTest(false)
}

function SetSkinTest(skinTestAbnormal) {
	var count = 0;
	var Objtbl = document.getElementById('tDHCNurIPExec');
	var tableRows = Objtbl.rows.length;
	for (var i = 1; i < tableRows; i++) {
		var check = document.getElementById('seleitemz' + i);
		if (check.checked == true) {
			count = count + 1
			var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
		}
	}
	if (count != 1) {
		alert("请选择一条皮试医嘱！！！");//t['alert:selectSingle']
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

	var ctlocId = session["LOGON.CTLOCID"];
	var userId = session['LOGON.USERID'];
	var execStatusCode = "F";
	var resStr = cspRunServerMethod(setSkinTestResult, oeoriId, userId, abnormalFlag, execStatusCode, ctlocId, queryTypeCode, "", "", "");
	alert(resStr); //display result
	self.location.reload();
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
			} //!! 
			else {
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
			if (selectrow == tableRows - 1) {
				websys_setfocus("seleitemz" + selectrow);
			} //{websys_setfocus("OrdExcute");}
			for (i = selectrow + 1; i < tableRows; i++) {
				placerNo = document.getElementById("placerNoz" + i).value;
				if (placerNo.length < 1) {
					var obj = document.getElementById("placerNoz" + i);
					obj.focus();
					prePlacerNo = obj.value
					return;
				}
			}
		} else {
			eSrc.value = prePlacerNo;
			alert(t['alert:tooShort'])
		}
	}
}

function SetPlacerNo() //ypz 060613
	{
		//if (curRow<1) return;
		var count = 0;
		var flag = new Array();
		////var Objtbl=document.getElementById('tDHCNurIPExec');
		////var Rows=Objtbl.rows.length;	
		for (var i = 1; i < tableRows; i++) {
			var check = document.getElementById('seleitemz' + i);
			if (check.checked == true) {
				var LabNo = document.getElementById("labNoz" + i).innerText;
				if (flag[LabNo] == true) continue;
				count = count + 1, selRow = i;
				flag[LabNo] = true;
				var selOriId = document.getElementById("oeoriIdz" + i).innerText;
			}
		}
		if (count != 1) {
			alert(t['alert:selectSingle']);
			return;
		}

		var setPlacerNo = document.getElementById("setPlacerNo").value;
		var objPlacerNo = document.getElementById("curPlacerNo");
		var userId = session['LOGON.USERID']; //add var userId,061113
		//alert(selOriId+" / "+placerNo)
		var resStr = cspRunServerMethod(setPlacerNo, userId, selOriId, objPlacerNo.value, "Y");
		if (resStr != 0) {
			alert(resStr)
		} else {
			alert(t['alert:success']); //!!
			document.getElementById("placerNoz" + selRow).value = objPlacerNo.value;
			self.location.reload();
		}
	}

function PlacerNoLinkLabNo() {
	if (event.keyCode == 13) {
		if (vartyp.indexOf("JYD") > -1) {
			var labNo = ""
			var objPlacerNo = document.getElementById('curPlacerNo');
			if (objPlacerNo) {
				curRow = ""
				var objtbl = document.getElementById('tDHCNurIPExec');
				for (var i = 1; i < objtbl.rows.length; i++) {
					var objLabNo = document.getElementById('labNoz' + i);
					if (objLabNo.innerText == objPlacerNo.value) {
						labNo = objPlacerNo.value;
						curRow = i
						break;
					}
				}
				if (curRow == "") return;
				var setPlacerNo = document.getElementById("setPlacerNo").value;
				var objPlacerNo = document.getElementById("curPlacerNo");
				var userId = session['LOGON.USERID']; //add var userId,061113
				var selOriId = document.getElementById("oeoriIdz" + curRow).innerText;
				//alert(userId+"/"+selOriId+"/"+objPlacerNo.value)
				var resStr = cspRunServerMethod(setPlacerNo, userId, selOriId, objPlacerNo.value);
				if (resStr != 0) {
					alert(resStr);
				} else {
					alert(t['alert:success']); //!!
					for (var i = 1; i < objtbl.rows.length; i++) {
						var objLabNo = document.getElementById('labNoz' + i);
						if (objLabNo.innerText == objPlacerNo.value) {
							labNo = objPlacerNo.value;
							document.getElementById("placerNoz" + i).value = objPlacerNo.value;
						}
					}
					objPlacerNo.value = "";
				}
			}
		}
	}
}

function insertBatchClick() {
	var count = 0;
	var oeoriStr = "";
	var Objtbl = document.getElementById('tDHCNurIPExec');
	var tableRows = Objtbl.rows.length;
	for (var i = 1; i < tableRows; i++) {
		var check = document.getElementById('seleitemz' + i);
		if (check.checked == true) {
			count = count + 1
			var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
			if (oeoriStr == "") oeoriStr = oeoriId
			else oeoriStr = oeoriStr + "!" + oeoriId
		}
	}
	if (count < 1) {
		alert(t['alert:selOrder']);
		return;
	}
	var batchStr = prompt("请输入批次:", "8:00,16:00");
	if (batchStr == null) return
	var batchStrList = batchStr.split(",")
		//var patrn=/^(\d|[0,1]\d|2[0-3]):([0-5]\d|[0-5]\d:[0-5]\d)$/g
	for (var i = 0; i < batchStrList.length; i++) {
		var patrn = /^(\d|[0,1]\d|2[0-3]):([0-5]\d|[0-5]\d:[0-5]\d)$/g
		if (!patrn.exec(batchStrList[i])) {
			alert("Time format is error!")
			return
		}
	}

	var BatchObj = document.getElementById("updateBatch")
	if (BatchObj) updateBatchObj = BatchObj.value;
	var resStr = cspRunServerMethod(updateBatchObj, oeoriStr, batchStr);
	if (resStr != 0) alert(resStr);
	return
	//self.location.reload();

}

function SetSkinTestClick() {
	var count = 0;
	var oeoriStr = "";
	var Objtbl = document.getElementById('tDHCNurIPExec');
	var tableRows = Objtbl.rows.length;
	for (var i = 1; i < tableRows; i++) {
		var check = document.getElementById('seleitemz' + i);
		if (check.checked == true) {
			count = count + 1
			var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
			if (oeoriStr == "") oeoriStr = oeoriId
			else oeoriStr = oeoriStr + "!" + oeoriId
		}
	}
	//if(oeoriStr=="") return
	if (count != 1) {
		alert(t['alert:selectSingle']);
		return;
	}
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurSkinTest" + "&oeoriStr=" + oeoriStr + "&btnType=" + "SetSkinTest";
	window.open(lnk, "DHCNurSkinTest", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=230,width=400,top=100,left=300");
}

function skinTestAuditClick() {
	var count = 0;
	var oeoriStr = "";
	var Objtbl = document.getElementById('tDHCNurIPExec');
	var tableRows = Objtbl.rows.length;
	for (var i = 1; i < tableRows; i++) {
		var check = document.getElementById('seleitemz' + i);
		if (check.checked == true) {
			count = count + 1
			var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
			if (oeoriStr == "") oeoriStr = oeoriId
			else oeoriStr = oeoriStr + "!" + oeoriId
		}
	}
	//if(oeoriStr=="") return
	if (count != 1) {
		alert(t['alert:selectSingle']);
		return;
	}
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurSkinTest" + "&oeoriStr=" + oeoriStr + "&btnType=" + "skinTestAudit";
	window.open(lnk, "DHCNurSkinTest", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=230,width=400,top=100,left=300");
}

function MergeLab() {
	var Objtbl = document.getElementById('tDHCNurIPExec');
	var Rows = Objtbl.rows.length;
	var mergeLabStr = "";
	var patReg = "";
	var recLoc = "";
	for (var i = 1; i < Rows; i++) {
		var selobj = document.getElementById('seleitemz' + i);
		if (selobj.checked) {
			var tmpReg = document.getElementById("regNoz" + i).innerText;
			if (patReg == "") patReg = tmpReg;
			if (patReg != tmpReg) {
				alert("请选择同一个病人的检验医嘱");
				return;
			}
			var recLocElement = document.getElementById("reclocDescz" + i)
			if (recLocElement != null) {
				var tmpRecLoc = document.getElementById("reclocDescz" + i).innerText;
				if (recLoc == "") recLoc = tmpRecLoc;
				if (recLoc != tmpRecLoc) {
					alert("请选择同一个接受科室的检验医嘱");
					return;
				}
			}


			var tempoeoriId = document.getElementById("oeoriIdz" + i).innerText;
			var ret = tkMakeServerCall("web.DHCNurCom", "GetLabOrdStatCode", tempoeoriId);
			if (ret == "E") {
				alert("医嘱已执行不能合并");
				return;
			}
			ret = tkMakeServerCall("web.DHCNurCom", "GetPlacerNo", tempoeoriId);
			if (ret != "") {
				alert("医嘱无瓶号不能合并");
				return;
			}
			if (mergeLabStr == "") {
				mergeLabStr = tempoeoriId;
			} else {
				mergeLabStr = mergeLabStr + "^" + tempoeoriId;
			}
		}
	}

	if (mergeLabStr != "") {

		var ret = tkMakeServerCall("appcom.OEOrdItem", "GenLabEpisodeNo", mergeLabStr)
		if (ret != "") {
			alert("合并成功");
		} else {
			alert(ret)
		}
		self.location.reload();
	}


}

function AddLock_Click() {
	var count = 0;
	var oeoriStrArr = [];
	var userId = session['LOGON.USERID'];
	var Objtbl = document.getElementById('tDHCNurIPExec');
	var tableRows = Objtbl.rows.length;
	for (var i = 1; i < tableRows; i++) {
		var check = document.getElementById('seleitemz' + i);
		if (check.checked == true) {
			count = count + 1;
			//var arcimDesc=document.getElementById("arcimDescz"+i).innerText;
			//if (arcimDesc.indexOf("____")>-1) continue;	
			var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
			oeoriStrArr[oeoriStrArr.length] = oeoriId;
		}
	}
	if (count == 0) {
		alert("请选择医嘱")
		return;
	}
	var ret = tkMakeServerCall("web.DHCLCNUREXCUTE", "LockOrders", oeoriStrArr.join("^"), userId)
	if (ret == "0") {
		alert("加锁成功")
		self.location.reload();
	} else {
		alert(ret)
		return false;
	}
}

function UnLock_Click() {
	var count = 0;
	var oeoriStrArr = [];
	var userId = session['LOGON.USERID'];
	var Objtbl = document.getElementById('tDHCNurIPExec');
	var tableRows = Objtbl.rows.length;
	for (var i = 1; i < tableRows; i++) {
		var check = document.getElementById('seleitemz' + i);
		if (check.checked == true) {
			count = count + 1;
			var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
			oeoriStrArr[oeoriStrArr.length] = oeoriId;
		}
	}
	if (count == 0) {
		alert("请选择医嘱")
		return;
	}
	var ret = tkMakeServerCall("web.DHCLCNUREXCUTE", "UnLockOrders", oeoriStrArr.join("^"), userId)
	if (ret == "0") {
		alert("解锁成功")
		self.location.reload();
	}

}