document.write("<script language='javascript' src='../scripts/nurse/DHCNUR/DHCNurPrintClickOnce.js'></script>");

//var setstr=tkMakeServerCall("Nur.DHCMGNurseSet","getSet")
// webIP=setstr.split("^")[1]
//document.write("<OBJECT id='DHCCNursePrintComm'  width='0' height='0' classid='"+webIP+"/dhcmg/DHCCNursePrintComm.dll#DHCCNursePrintComm.WebInterface'  IEWASTEXT></OBJECT>");
//alert("<OBJECT id='DHCCNursePrintComm'  width='0' height='0' classid='"+webIP+"/dhcmg/DHCCNursePrintComm.dll#DHCCNursePrintComm.WebInterface'  IEWASTEXT></OBJECT>")
function BodyLoadHandler() {
	//AddAbnormalNote();
	AddTestMethodSel();
	var objtbl = document.getElementById('tDHCNurSkinTestOrder');
	var tableRows = objtbl.rows.length;
	for (i = 1; i < tableRows; i++) {
		var eSrc = objtbl.rows[i];
		var RowObj = getRow(eSrc);
		var TestResult = document.getElementById("TestResultz" + i).innerText;
		if (TestResult.indexOf("阳性") > -1) {
			if (RowObj) RowObj.className = "SkinTest";
		}
		if (TestResult.indexOf("阴性") > -1) {
			if (RowObj) RowObj.className = "Immediate";
		}
		var SkinTestFlag = document.getElementById("SkinTestFlagz" + i).innerText;
		if (SkinTestFlag == "Y") {
			if ((TestResult == "") || (TestResult == " ")) {
				var obj = document.getElementById("seleitemz" + i);
				
				//if (obj) obj.checked = true;
				var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
				SetDefaultValue(oeoriId);
				//obj.onclick = selectClick;
			}
		}
		var objarcimDesc = document.getElementById("arcimDescz" + i);
		objarcimDesc.style.fontWeight = "bold";
		objarcimDesc.style.fontSize = "20px";
	}


	//SetAbnormalNote("N");
	var objStartSkinTest = document.getElementById("btnStartSkinTest");
	if (objStartSkinTest) {
		websys_setfocus("btnStartSkinTest");
		objStartSkinTest.onclick = StartSkinTest;
	}
	var skinTestNormal = document.getElementById("skinTestNormal");
	if (skinTestNormal) {
		skinTestNormal.onclick = skinTestNormalFn;
	}
	var skinTestAllergy = document.getElementById("skinTestAllergy");
	if (skinTestAllergy) {
		skinTestAllergy.onclick = skinTestAllergyFn
	}
	var Observe10Min = document.getElementById("Observe10Min");
	if (Observe10Min) {
		Observe10Min.onclick = ObserveTimeFn
	}
	var Observe15Min = document.getElementById("Observe15Min");
	if (Observe15Min) {
		Observe15Min.onclick = ObserveTimeFn
	}
	var Observe20Min = document.getElementById("Observe20Min");
	if (Observe20Min) {
		Observe20Min.onclick = ObserveTimeFn
	}
	var Observe48H = document.getElementById("Observe48H");
	if (Observe48H) {
		Observe48H.onclick = ObserveTimeFn
	}
	var Observe72H = document.getElementById("Observe72H");
	if (Observe72H) {
		Observe72H.onclick = ObserveTimeFn
	}
	var ObserveDefine = document.getElementById("ObserveDefine");
	if (ObserveDefine) {
		ObserveDefine.onkeyup = ObserveTimeFn;
	} //onclick=ObserveTimeFn}
	var butUpdate = document.getElementById("butUpdate");
	if (butUpdate) {
		butUpdate.onclick = butUpdateFn
	}
	// var btnPrint = document.getElementById("btnPrint");
	// if (btnPrint) {
	// 	btnPrint.onclick = btnPrintFn
	// }

	var objBtnPrint=document.getElementById("btnPrint");
    if (objBtnPrint) {
		objBtnPrint.onclick=printExecSheet;	
	}

	var objuserCode = document.getElementById("userCode");
	if (objuserCode) objuserCode.focus();
	if (objuserCode) objuserCode.onkeydown = getuserCode;
	var objpassWord = document.getElementById("passWord")
	if (objpassWord) objpassWord.onkeydown = getpassWord;
	var objuserCodeAudit = document.getElementById("userCodeAudit");
	if (objuserCodeAudit) objuserCodeAudit.onkeydown = getuserCodeAudit;
	var objpassWordAudit = document.getElementById("passWordAudit");
	if (objpassWordAudit) objpassWordAudit.onkeydown = getpassWordAudit;
	var objAbnormalNoteText = document.getElementById("AbnormalNoteText");
	if (objAbnormalNoteText) {
		objAbnormalNoteText.onkeydown = getAbnormalNoteText;
		objAbnormalNoteText.onblur = calculate ;//calculateResult;
	}
	var objAbnormalNoteText2 = document.getElementById("AbnormalNoteText2");
	if (objAbnormalNoteText2) {
		objAbnormalNoteText2.onkeydown = getAbnormalNoteText2;
		objAbnormalNoteText2.onblur = calculate ;//calculateResult;
	}
	var objAbnormalNote1Text1 = document.getElementById("AbnormalNote1Text1");
	if (objAbnormalNote1Text1) 
	{
		objAbnormalNote1Text1.onkeydown = getAbnormalNote1Text1;
		objAbnormalNote1Text1.onblur = calculate ;//calculateResultOther;
	}
	var objAbnormalNote1Text2 = document.getElementById("AbnormalNote1Text2");
	if (objAbnormalNote1Text2)
	{
		objAbnormalNote1Text2.onkeydown = getAbnormalNote1Text2;
		objAbnormalNote1Text2.onblur = calculate ;//calculateResultOther;
	}		
	var objAbnormalNote4Text1 = document.getElementById("AbnormalNote4Text1");
	if (objAbnormalNote4Text1) 
	{
		objAbnormalNote4Text1.onkeydown = getAbnormalNote4Text1;
		objAbnormalNote4Text1.onblur = objAbnormalNote4Text1_isNum ;//calculateResultOther;
	}
	var objAbnormalNote4Text2 = document.getElementById("AbnormalNote4Text2");
	if (objAbnormalNote4Text2) 
	{
		objAbnormalNote4Text2.onblur = objAbnormalNote4Text2_isNum ;//calculateResultOther;
	}
	var AbnormalNote2 = document.getElementById("AbnormalNote2");
	if (AbnormalNote2) 
	{
		AbnormalNote2.onclick = AbnormalNote2_click;
	}
	var AbnormalNote3 = document.getElementById("AbnormalNote3");
	if (AbnormalNote3) 
	{
		AbnormalNote3.onclick = AbnormalNote3_click;
	}
	var butSave = document.getElementById("butSave");
	if (butSave) {
		butSave.onclick = butSaveFn
	}
	var Observe20Min=document.getElementById("Observe20Min");
	Observe20Min.checked=true;
	
	var AbnormalNote1Check1 =document.getElementById("AbnormalNote1Check1")
	if(AbnormalNote1Check1) AbnormalNote1Check1.onclick = AbnormalNote1Check1_click;
	var AbnormalNote1Check2 =document.getElementById("AbnormalNote1Check2")
	if(AbnormalNote1Check2) AbnormalNote1Check2.onclick = AbnormalNote1Check2_click;
	isCanInsertPPD("");
}

function objAbnormalNote4Text1_isNum(){
	var AbnormalNote4Text1 = document.getElementById("AbnormalNote4Text1").value;
	if(isNaN(AbnormalNote4Text1)){
		alert("请输入数字！");
	}
}
function objAbnormalNote4Text2_isNum(){
	var AbnormalNote4Text2 = document.getElementById("AbnormalNote4Text2").value;
	if(isNaN(AbnormalNote4Text2)){
		alert("请输入数字！");
	}
}
function AbnormalNote1Check1_click(){
	var AbnormalNote1Check2 = document.getElementById("AbnormalNote1Check2");
	if (AbnormalNote1Check2) AbnormalNote1Check2.checked = false;
}
function AbnormalNote1Check2_click(){
	var AbnormalNote1Check1 = document.getElementById("AbnormalNote1Check1");
	if (AbnormalNote1Check1) AbnormalNote1Check1.checked = false;
}
function AbnormalNote2_click(){
	var AbnormalNote2 = document.getElementById("AbnormalNote2").checked;
	var PPDCalculte = document.getElementById("PPDCalculte");
	if(AbnormalNote2){
		PPDCalculte.value="(++++)";
	}
	else{
		calculateResult();
		calculateResultOther();
		//PPDCalculte.value="";
	}
}
function AbnormalNote3_click(){
	var AbnormalNote3 = document.getElementById("AbnormalNote3").checked;
	var PPDCalculte = document.getElementById("PPDCalculte");
	if(AbnormalNote3){
		PPDCalculte.value="(++++)";
	}
	else{
		calculateResult();
		calculateResultOther();
		//PPDCalculte.value="";
	}
}
/**/
//ppd可录入性
function isCanInsertPPD(oeoriStr){
	var IfPPDOrder = 0;
	var GetIfPPDOrder = document.getElementById("GetIfPPDOrder");
	if (GetIfPPDOrder) {
		IfPPDOrder = cspRunServerMethod(GetIfPPDOrder.value, oeoriStr);
	}
	var readOnlyFlag=true;
	if(IfPPDOrder==0){
		readOnlyFlag = true;
	}else{
		readOnlyFlag = false;
		
	}
	var objAbnormalNoteText = document.getElementById("AbnormalNoteText");
		if (objAbnormalNoteText) objAbnormalNoteText.disabled=readOnlyFlag;
		var objAbnormalNoteText2 = document.getElementById("AbnormalNoteText2");
		if (objAbnormalNoteText2)  objAbnormalNoteText2.disabled=readOnlyFlag;
		var objAbnormalNote1Text1 = document.getElementById("AbnormalNote1Text1");
		if (objAbnormalNote1Text1)  objAbnormalNote1Text1.disabled=readOnlyFlag;
		var objAbnormalNote1Text2 = document.getElementById("AbnormalNote1Text2");
		if (objAbnormalNote1Text2)  objAbnormalNote1Text2.disabled=readOnlyFlag;
		var objAbnormalNote4Text1 = document.getElementById("AbnormalNote4Text1");
		if (objAbnormalNote4Text1)  objAbnormalNote4Text1.disabled=readOnlyFlag;
		var objAbnormalNote4Text2 = document.getElementById("AbnormalNote4Text2");
		if (objAbnormalNote4Text2)  objAbnormalNote4Text2.disabled=readOnlyFlag;
		var AbnormalNote2 = document.getElementById("AbnormalNote2");
		if (AbnormalNote2)  AbnormalNote2.disabled=readOnlyFlag;
		var AbnormalNote3 = document.getElementById("AbnormalNote3");
		if (AbnormalNote3)  AbnormalNote3.disabled=readOnlyFlag;
		var AbnormalNote1Check1 = document.getElementById("AbnormalNote1Check1");
		if (AbnormalNote1Check1)  AbnormalNote1Check1.disabled=readOnlyFlag;
		var AbnormalNote1Check2 = document.getElementById("AbnormalNote1Check2");
		if (AbnormalNote1Check2)  AbnormalNote1Check2.disabled=readOnlyFlag;
		var skinTestNormal = document.getElementById("skinTestNormal");
		if(skinTestNormal) skinTestNormal.disabled=(!readOnlyFlag);
		var skinTestAllergy = document.getElementById("skinTestAllergy");
		if(skinTestAllergy) skinTestAllergy.disabled=(!readOnlyFlag);
		
}
function calculate(){
	
	//取PPD试验结果
	var AbnormalNoteText = document.getElementById("AbnormalNoteText"); //皮肤硬结
	if(isNaN(AbnormalNoteText.value)){
		alert("请输入数字！");
		return ;
	}
	var AbnormalNoteText2 = document.getElementById("AbnormalNoteText2");
	if(isNaN(AbnormalNoteText2.value)){
		alert("请输入数字！");
		return ;
	}
	if ((AbnormalNoteText.value != "") || (AbnormalNoteText2.value != "")) {
		var objcAbnormalNote = document.getElementById("cAbnormalNote");
		if (objcAbnormalNote) {
			var skinNote = objcAbnormalNote.innerText;
			if (AbnormalNoteText.value != "") skinNote = skinNote + " " + AbnormalNoteText.value + "mm";
			if (AbnormalNoteText2.value != "") skinNote = skinNote + "*" + AbnormalNoteText2.value + "mm";
			if (skinNote != "") skinNote = skinNote + ";";
		}
	}
	//var AbnormalNote1=GetCheckValue("AbnormalNote1");	//局部水泡
	//if (AbnormalNote1!="") skinNote=skinNote+" "+AbnormalNote1;
	var AbnormalNote1Text1 = document.getElementById("AbnormalNote1Text1"); //局部水泡
	if(isNaN(AbnormalNote1Text1.value)){
		alert("请输入数字！");
		return ;
	}
	var AbnormalNote1Text2 = document.getElementById("AbnormalNote1Text2");
	if(isNaN(AbnormalNote1Text2.value)){
		alert("请输入数字！");
		return ;
	}
	if ((AbnormalNote1Text1.value != "") || (AbnormalNote1Text2.value != "")) {
		var objcAbnormalNote1 = document.getElementById("cAbnormalNote1");
		if (objcAbnormalNote1) {
			var skinNote = skinNote + " " + objcAbnormalNote1.innerText;
			if (AbnormalNote1Text1.value != "") skinNote = skinNote + " " + AbnormalNote1Text1.value + "mm";
			if (AbnormalNote1Text2.value != "") skinNote = skinNote + "*" + AbnormalNote1Text2.value + "mm";
			var AbnormalNote1Check1 = document.getElementById("AbnormalNote1Check1");
			var objcAbnormalNote1Check1 = document.getElementById("cAbnormalNote1Check1");
			if ((AbnormalNote1Check1) && (AbnormalNote1Check1.checked == true)) {
				skinNote = skinNote + " " + objcAbnormalNote1Check1.innerText;
			}
			var AbnormalNote1Check2 = document.getElementById("AbnormalNote1Check2");
			var objcAbnormalNote1Check2 = document.getElementById("cAbnormalNote1Check2");
			if ((AbnormalNote1Check2) && (AbnormalNote1Check2.checked == true)) {
				skinNote = skinNote + " " + objcAbnormalNote1Check2.innerText;
			}
			if (skinNote != "") skinNote = skinNote + ";";
		}
	}
	var AbnormalNote2 = GetCheckValue("AbnormalNote2"); //坏死
	if (AbnormalNote2 != "") {
		skinNote = skinNote + " " + AbnormalNote2;
		if (skinNote != "") skinNote = skinNote + ";";
	}
	var AbnormalNote3 = GetCheckValue("AbnormalNote3"); //淋巴管炎
	if (AbnormalNote3 != "") {
		skinNote = skinNote + " " + AbnormalNote3;
		if (skinNote != "") skinNote = skinNote + ";";
	}
	var AbnormalNote4Text1 = document.getElementById("AbnormalNote4Text1"); //红肿
	var AbnormalNote4Text2 = document.getElementById("AbnormalNote4Text2");
	if ((AbnormalNote4Text1.value != "") || (AbnormalNote4Text2.value != "")) {
		var objcAbnormalNote4 = document.getElementById("cAbnormalNote4");
		if (objcAbnormalNote4) {
			var skinNote = skinNote + " " + objcAbnormalNote4.innerText;
			if (AbnormalNote4Text1.value != "") skinNote = skinNote + " " + AbnormalNote4Text1.value + "mm";
			if (AbnormalNote4Text2.value != "") skinNote = skinNote + "*" + AbnormalNote4Text2.value + "mm";
			if (skinNote != "") skinNote = skinNote + ";";
		}
	}
	var TestResult = GetPPDStandard(skinNote, AbnormalNoteText.value);
	var skinTestAllergy = document.getElementById("skinTestAllergy");
	var skinTestNormal = document.getElementById("skinTestNormal");
	if(TestResult=="(-)"){
		skinTestAllergy.checked=false;
		skinTestNormal.checked=true;
	}
	else{
		skinTestAllergy.checked=true;
		skinTestNormal.checked=false;
	}
	document.getElementById("PPDCalculte").value = TestResult;
}
//硬结计算阳性结果
function calculateResult(){
	//("+++		");
	var PPDCalculte = document.getElementById("PPDCalculte");
	var skinTestAllergy = document.getElementById("skinTestAllergy");
	var skinTestNormal = document.getElementById("skinTestNormal");
	if(!(calculateResultOther())){
		var AbnormalNoteText = document.getElementById("AbnormalNoteText").value; //皮肤硬结
		if (AbnormalNoteText < 5)
		{
			retStr = "(-)";
			skinTestNormal.checked=true;
			skinTestAllergy.checked=false;
		}
		else{
			skinTestAllergy.checked=true;
			skinTestNormal.checked=false;
		}
		if ((AbnormalNoteText >= 5) && (AbnormalNoteText <=10)) retStr = "(+)";
		if ((AbnormalNoteText > 10) && (AbnormalNoteText <=20)) retStr = "(++)";
		if (AbnormalNoteText > 20) retStr = "(+++)";
		PPDCalculte.value = retStr;
	}
	
	
}

//红肿水泡坏死淋巴结阳性结果
function calculateResultOther(){
	//alert("++++");
	var objAbnormalNote1Text1 = document.getElementById("AbnormalNote1Text1").value;
	var objAbnormalNote1Text2 = document.getElementById("AbnormalNote1Text2").value;
	var objAbnormalNote4Text1 = document.getElementById("AbnormalNote4Text1").value; //皮肤硬结
	var objAbnormalNote4Text2 = document.getElementById("AbnormalNote4Text1").value;
	
	var PPDCalculte = document.getElementById("PPDCalculte");
	var skinTestAllergy = document.getElementById("skinTestAllergy");
	var skinTestNormal = document.getElementById("skinTestNormal");
	if(objAbnormalNote1Text1!=""||objAbnormalNote1Text2!=""||objAbnormalNote4Text1!=""||objAbnormalNote4Text2!="")
	{
		PPDCalculte.value = "(++++)";
		skinTestAllergy.checked=true;
		skinTestNormal.checked=false;
		return true;
	}else{
		skinTestAllergy.checked=false;
		return false;
	}
	
}

function SetAbnormalNote(flag) {
	var cAbnormalNote = document.getElementById("cAbnormalNote");
	var AbnormalNote = document.getElementById("AbnormalNote");
	var AbnormalNoteText = document.getElementById("AbnormalNoteText");
	var cAbnormalNoteText = document.getElementById("cAbnormalNoteText");
	var AbnormalNoteText2 = document.getElementById("AbnormalNoteText2");
	var cAbnormalNoteText2 = document.getElementById("cAbnormalNoteText2");
	if (flag == "Y") {

		if (cAbnormalNote) cAbnormalNote.style.visibility = 'visible';
		if (AbnormalNote) AbnormalNote.style.visibility = 'visible';
		if (AbnormalNoteText) AbnormalNoteText.style.visibility = 'visible';
		if (cAbnormalNoteText) cAbnormalNoteText.style.visibility = 'visible';
		if (AbnormalNoteText2) AbnormalNoteText.style.visibility = 'visible';
		if (cAbnormalNoteText2) cAbnormalNoteText.style.visibility = 'visible';
	} else {
		if (cAbnormalNote) cAbnormalNote.style.visibility = 'hidden';
		if (AbnormalNote) AbnormalNote.style.visibility = 'hidden';
		if (AbnormalNoteText) AbnormalNoteText.style.visibility = 'hidden';
		if (cAbnormalNoteText) cAbnormalNoteText.style.visibility = 'hidden';
		if (AbnormalNoteText2) AbnormalNoteText.style.visibility = 'hidden';
		if (cAbnormalNoteText2) cAbnormalNoteText.style.visibility = 'hidden';
	}
}

function skinTestAllergyFn() {
	var skinTestNormal = document.getElementById("skinTestNormal");
	if (skinTestNormal) skinTestNormal.checked = false;
	//SetAbnormalNote("Y");
}

function skinTestNormalFn() {
	var skinTestAllergy = document.getElementById("skinTestAllergy");
	if (skinTestAllergy) skinTestAllergy.checked = false;
	//SetAbnormalNote("N");
}

function ObserveTimeFn() {
	var eSrc = window.event.srcElement;
	var eSrcStr = eSrc.name;
	var Observe10Min = document.getElementById("Observe10Min");
	if ((eSrcStr != "Observe10Min") && (Observe10Min)) Observe10Min.checked = false;
	var Observe15Min = document.getElementById("Observe15Min");
	if ((eSrcStr != "Observe15Min") && (Observe15Min)) Observe15Min.checked = false;
	var Observe20Min = document.getElementById("Observe20Min");
	if ((eSrcStr != "Observe20Min") && (Observe20Min)) Observe20Min.checked = false;
	var Observe48H = document.getElementById("Observe48H");
	if ((eSrcStr != "Observe48H") && (Observe48H)) Observe48H.checked = false;
	var Observe72H = document.getElementById("Observe72H");
	if ((eSrcStr != "Observe72H") && (Observe72H)) Observe72H.checked = false;
	var ObserveDefine = document.getElementById("ObserveDefine");
	if ((eSrcStr != "ObserveDefine") && (ObserveDefine)) ObserveDefine.value = "";
}

function AddAbnormalNote() {

	var resStr = "0|^1|皮肤硬结^2|局部水泡^3|坏死^4|淋巴管炎";
	var selobj = document.getElementById("AbnormalNote");
	selobj.options.length = 0;
	resList = resStr.split("^");
	for (i = 0; i < resList.length; i++) {
		var tmpList = resList[i].split("|")
		selobj.add(new Option(tmpList[1], tmpList[0]));
	}
	selobj.size = 1;
	selobj.multiple = false;
}

function AddTestMethodSel() {
	var selobj = document.getElementById("TestMethodSel");
	if (selobj) {
		//selobj.options.length=0;
		selobj.size = 1;
		selobj.multiple = false;
	}
}

function StartSkinTest() {
	var count = 0;
	var TestAdmDr = "",
		TestOeoriDr = "";
	var objtbl = document.getElementById('tDHCNurSkinTestOrder');
	var tableRows = objtbl.rows.length;
	for (var i = 1; i < tableRows; i++) {
		var check = document.getElementById('seleitemz' + i);
		if (check.checked == true) {
			count = count + 1
			TestAdmDr = document.getElementById("EpisodeIDz" + i).innerText;
			TestOeoriDr = document.getElementById("oeoriIdz" + i).innerText;
			if (TestOeoriDr != "") {
				var tmpTestOeoriDr = TestOeoriDr.split("||");
				TestOeoriDr = tmpTestOeoriDr[0] + "!!" + tmpTestOeoriDr[1];
			}
		}
	}
	if (count != 1) {
		alert(t['alert:selectSingle']);
		return;
	}
	if (TestAdmDr == "") return;
	var objSave = document.getElementById("Save");
	if (objSave) {
		var userId = session['LOGON.USERID'];
		var locId = session['LOGON.CTLOCID'];
		var ObserveTime = GetObserveTime();
		if (ObserveTime == "") {
			alert("时间为空")
			return;
		}
		var TestMethod = ""
		var TestMethodSel = document.getElementById("TestMethodSel");
		if (TestMethodSel) {
			var Index = TestMethodSel.selectedIndex;
			if (Index > -1) {
				TestMethod = TestMethodSel.options[Index].text;
			}
		}
		var parr = "TestAdmDr|" + TestAdmDr + "^TestStartDate|" + "^TestStartTime|" + "^RecUser|" + userId + "^TestOeoriDr|" + TestOeoriDr + "^ObserveTime|" + ObserveTime + "^TestLocDr|" + locId + "^TestMethod|" + TestMethod;
		var resStr = cspRunServerMethod(objSave.value, "", parr, "count");
		if (resStr != 0) {
			alert(resStr);
			return;
		} else {
			if (parent.parent.frames["NurseLeft"]) {
				parent.parent.frames["NurseLeft"].RefreshFn();
			}
			self.location.reload();
		}
	}
}

function GetObserveTime() {
	var retTime = "";
	var Observe10Min = document.getElementById("Observe10Min");
	if ((Observe10Min) && (Observe10Min.checked == true)) retTime = "10分钟";
	var Observe15Min = document.getElementById("Observe15Min");
	if ((Observe15Min) && (Observe15Min.checked == true)) retTime = "15分钟";
	var Observe20Min = document.getElementById("Observe20Min");
	if ((Observe20Min) && (Observe20Min.checked == true)) retTime = "20分钟";
	var Observe48H = document.getElementById("Observe48H");
	if ((Observe48H) && (Observe48H.checked == true)) retTime = "48小时";
	var Observe72H = document.getElementById("Observe72H");
	if ((Observe72H) && (Observe72H.checked == true)) retTime = "72小时";
	var ObserveDefine = document.getElementById("ObserveDefine");
	//if ((ObserveDefine)&&(ObserveDefine.value!="")) retTime=ObserveDefine.value+"分钟";
	var aa = isNaN(ObserveDefine.value)
	if ((ObserveDefine) && (ObserveDefine.value != "") && (aa == false) && (ObserveDefine.value > 0)) retTime = ObserveDefine.value + "分钟";
	return retTime;
}

function GetCheckValue(element) {
	var retValue = "";
	var obj = document.getElementById(element);
	if ((obj) && (obj.checked == true)) {
		var objc = document.getElementById("c" + element);
		if (objc) retValue = objc.innerText;
	}
	return retValue;
}

function butUpdateFn() {
	var count = 0,
		oeoriStr = "";
	var TestAdmDr = "",
		TestOeoriDr = "";
	var objtbl = document.getElementById('tDHCNurSkinTestOrder');
	var tableRows = objtbl.rows.length;
	for (var i = 1; i < tableRows; i++) {
		var check = document.getElementById('seleitemz' + i);
		if (check.checked == true) {
			count = count + 1
			oeoriStr = document.getElementById("oeoriIdz" + i).innerText;
			TestAdmDr = document.getElementById("EpisodeIDz" + i).innerText;
			TestOeoriDr = document.getElementById("oeoriIdz" + i).innerText;
			oeoriStr = TestOeoriDr;
			if (TestOeoriDr != "") {
				var tmpTestOeoriDr = TestOeoriDr.split("||");
				TestOeoriDr = tmpTestOeoriDr[0] + "!!" + tmpTestOeoriDr[1];
			}
		}
	}
	var ret = tkMakeServerCall("User.DHCNurSkinTestList", "IfPatPSEnd", TestAdmDr)
	if (ret == "1") {
		alert("时间未到不能置皮试结果")
		return;
	}
	if (count != 1) {
		alert(t['alert:selectSingle']);
		return;
	}
	var skinTest = "",
		skinNote = "";
	var obj = document.getElementById("skinTestNormal");
	if (obj.checked == true) skinTest = "N";
	var obj = document.getElementById("skinTestAllergy");
	if (obj.checked == true) skinTest = "Y";
	var IfPPDOrder = 0;
	var GetIfPPDOrder = document.getElementById("GetIfPPDOrder");
	if (GetIfPPDOrder) {
		IfPPDOrder = cspRunServerMethod(GetIfPPDOrder.value, oeoriStr);
	}
	//IfPPDOrder = 1;
	if ((IfPPDOrder == 0) && (skinTest == "")) {
		alert(t['alert:selectresult']);
		return;
	}

	//取PPD试验结果
	var AbnormalNoteText = document.getElementById("AbnormalNoteText"); //皮肤硬结
	var AbnormalNoteText2 = document.getElementById("AbnormalNoteText2");
	if ((AbnormalNoteText.value != "") || (AbnormalNoteText2.value != "")) {
		var objcAbnormalNote = document.getElementById("cAbnormalNote");
		if (objcAbnormalNote) {
			var skinNote = objcAbnormalNote.innerText;
			if (AbnormalNoteText.value != "") skinNote = skinNote + " " + AbnormalNoteText.value + "mm";
			if (AbnormalNoteText2.value != "") skinNote = skinNote + "*" + AbnormalNoteText2.value + "mm";
			if (skinNote != "") skinNote = skinNote + ";";
		}
	}
	//var AbnormalNote1=GetCheckValue("AbnormalNote1");	//局部水泡
	//if (AbnormalNote1!="") skinNote=skinNote+" "+AbnormalNote1;
	var AbnormalNote1Text1 = document.getElementById("AbnormalNote1Text1"); //局部水泡
	var AbnormalNote1Text2 = document.getElementById("AbnormalNote1Text2");
	if ((AbnormalNote1Text1.value != "") || (AbnormalNote1Text2.value != "")) {
		var objcAbnormalNote1 = document.getElementById("cAbnormalNote1");
		if (objcAbnormalNote1) {
			var skinNote = skinNote + " " + objcAbnormalNote1.innerText;
			if (AbnormalNote1Text1.value != "") skinNote = skinNote + " " + AbnormalNote1Text1.value + "mm";
			if (AbnormalNote1Text2.value != "") skinNote = skinNote + "*" + AbnormalNote1Text2.value + "mm";
			var AbnormalNote1Check1 = document.getElementById("AbnormalNote1Check1");
			var objcAbnormalNote1Check1 = document.getElementById("cAbnormalNote1Check1");
			if ((AbnormalNote1Check1) && (AbnormalNote1Check1.checked == true)) {
				skinNote = skinNote + " " + objcAbnormalNote1Check1.innerText;
			}
			var AbnormalNote1Check2 = document.getElementById("AbnormalNote1Check2");
			var objcAbnormalNote1Check2 = document.getElementById("cAbnormalNote1Check2");
			if ((AbnormalNote1Check2) && (AbnormalNote1Check2.checked == true)) {
				skinNote = skinNote + " " + objcAbnormalNote1Check2.innerText;
			}
			if (skinNote != "") skinNote = skinNote + ";";
		}
	}
	var AbnormalNote2 = GetCheckValue("AbnormalNote2"); //坏死
	if (AbnormalNote2 != "") {
		skinNote = skinNote + " " + AbnormalNote2;
		if (skinNote != "") skinNote = skinNote + ";";
	}
	var AbnormalNote3 = GetCheckValue("AbnormalNote3"); //淋巴管炎
	if (AbnormalNote3 != "") {
		skinNote = skinNote + " " + AbnormalNote3;
		if (skinNote != "") skinNote = skinNote + ";";
	}
	var AbnormalNote4Text1 = document.getElementById("AbnormalNote4Text1"); //红肿
	var AbnormalNote4Text2 = document.getElementById("AbnormalNote4Text2");
	if ((AbnormalNote4Text1.value != "") || (AbnormalNote4Text2.value != "")) {
		var objcAbnormalNote4 = document.getElementById("cAbnormalNote4");
		if (objcAbnormalNote4) {
			var skinNote = skinNote + " " + objcAbnormalNote4.innerText;
			if (AbnormalNote4Text1.value != "") skinNote = skinNote + " " + AbnormalNote4Text1.value + "mm";
			if (AbnormalNote4Text2.value != "") skinNote = skinNote + "*" + AbnormalNote4Text2.value + "mm";
			if (skinNote != "") skinNote = skinNote + ";";
		}
	}
	var TestResult = "";
	if (skinTest == "Y") TestResult = "(+)";
	if (skinTest == "N") TestResult = "(-)";
	//PPD试验结果判读/自动置皮试阴阳性
	//IfPPDOrder=1;
	if (IfPPDOrder == 1) {
		if (skinNote != "") {
			TestResult = GetPPDStandard(skinNote, AbnormalNoteText.value);
			if (TestResult == "(-)") skinTest = "N";
			else skinTest = "Y";
		} else {
			alert(t['alert:selectppdresult']);
			return;
		}
	}
	//皮试用户
	var userCode = "";
	var obj = document.getElementById("userCode");
	if (obj) var userCode = obj.value;
	else retrun;
	if (userCode == "") {
		alert(t['alert:enteruserCode']);
		return;
	}
	//var userId=session['LOGON.USERID'];	
	var obj = document.getElementById("passWord");
	if (obj) var passWord = obj.value
	else return;
	if (passWord == "") {
		alert(t['alert:enterpassWord']);
		return;
	}
	//复核用户
	var obj = document.getElementById("userCodeAudit");
	if (obj) var userCodeAudit = obj.value;
	else retrun;
	if (userCodeAudit == "") {
		alert(t['alert:enteruserCodeAudit']);
		return;
	}
	var obj = document.getElementById("passWordAudit");
	if (obj) var passWordAudit = obj.value
	else return;
	if (passWordAudit == "") //xuqy
	//if ((passWordAudit=="")&&(IfPPDOrder==0)) 
	{
		alert(t['alert:enterpassWordAudit']);
		return;
	}
	//if((userCode!="")&&(userCodeAudit!="")&&(userCode==userCodeAudit)) {alert("皮试用户与复核用户不能相同!");return;}
	//xuqy
	var obj = document.getElementById("ConfirmPassWord");
	if (obj) encmeth = obj.value
	else return;
	var retStr = cspRunServerMethod(encmeth, userCode, passWord);
	if (retStr.split("^")[0] != 0) {
		alert("皮试用户:" + retStr);
		return;
	} else {
		var userId = retStr.split("^")[1];
	}

	//if (IfPPDOrder==0)   //xuqy
	//{
	var retStr = cspRunServerMethod(encmeth, userCodeAudit, passWordAudit);
	if (retStr.split("^")[0] != 0) {
		alert("复核用户:" + retStr);
		return;
	}
	//}
	//置皮试结果
	var setSkinTestResult = document.getElementById("setSkinTestResult").value;
	//alert(oeoriStr+","+userId+","+skinTest+","+skinNote)
	var resStr = cspRunServerMethod(setSkinTestResult, oeoriStr, userId, skinTest, "", "", skinNote);
	//alert(resStr); //display result
	if (resStr == t['alert:success']) {
		//self.close();
		//opener.parent.frames["OrdList"].location.reload();
		//置复核用户
		if (userCodeAudit != "") {
			var obj = document.getElementById("updateAudit");
			if (obj) {
				//alert(userCodeAudit+","+passWordAudit+","+oeoriStr+","+skinTest)
				var flag = cspRunServerMethod(obj.value, userCodeAudit, passWordAudit, oeoriStr, skinTest);
				if (flag != 0) {
					if (flag == "-1") {
						alert(t["alert:passWord"]);
						return;
					} else {
						alert(flag);
						return;
					}
				} else {
					//alert(t['alert:success']);
					//self.close();
					//opener.parent.frames["OrdList"].location.reload();
				}
			}
		}
		//向DHCNurSkinTestList表中置皮试时间/皮试结果/皮试结果描述
		var objSave = document.getElementById("Save");
		if (objSave) {
			var userId = session['LOGON.USERID'];
			var PPDResult = document.getElementById('PPDCalculte').value;
			var parr = "TestAdmDr|" + TestAdmDr + "^TestDate|" + "^TestTime|" + "^RecUser|" + userId + "^TestOeoriDr|" + TestOeoriDr + "^TestResult|" + TestResult + "^TestResultDesc|" + skinNote;
			//alert(parr)
			var resStr = cspRunServerMethod(objSave.value, "", parr, "test");
			if (resStr != 0) {
				alert(resStr);
				return;
			} else {
				if (parent.parent.frames["NurseLeft"]) {
					parent.parent.frames["NurseLeft"].RefreshFn();
				}
			}
		}
		butSaveFn();
		self.location.reload();
	} else {
		alert(resStr);
		return;
	}
}

function GetFilePath() {
	var GetPath = document.getElementById("GetPath").value;
	var path = cspRunServerMethod(GetPath);
	return path;
}

function btnPrintFn() {

	var xlsExcel, xlsSheet, xlsBook;
	var titleRows, titleCols, LeftHeader, CenterHeader, RightHeader;
	var LeftFooter, CenterFooter, RightFooter, frow, fCol, tRow, tCol;
	var strList, tmpList, tmpStr, i, j, k, xlsTop, xlsLeft, typeInd, typeDesc;
	var path, fileName = "";
	path = GetFilePath();
	var queryTypeCode = document.getElementById("queryTypeCode").value;
	var HospitalRowId = document.getElementById("HospitalRowId").value;
	var GetVarType = document.getElementById("GetVarType");
	var str = cspRunServerMethod(GetVarType.value, queryTypeCode, HospitalRowId);
	tmpList = str.split("^");
	if (tmpList.length > 2) {
		fileName = tmpList[1];
		typeDesc = tmpList[0];
	}
	if (fileName.length < 2) {
		alert(t['alert:noExcelFile']);
		return false
	}
	fileName = path + fileName
	xlsExcel = new ActiveXObject("Excel.Application");
	xlsBook = xlsExcel.Workbooks.Add(fileName);
	xlsSheet = xlsBook.ActiveSheet;
	xlsTop = 1;
	xlsLeft = 1;
	titleRows = 0, titleCols = 0;
	LeftHeader = "";
	RightHeader = "";
	LeftFooter = "";
	CenterFooter = "";
	RightFooter = "";
	ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter)

	var getPrintTitle = document.getElementById("GetPrintTitle").value;
	var printTitleStr = cspRunServerMethod(getPrintTitle, HospitalRowId + "@" + queryTypeCode);
	if (printTitleStr.length == 0) {
		alert(t['val:setVar']);
	}
	var printTitleList = printTitleStr.split("^")
	var printDescList = printTitleList[0].split("|")
	var printLenList = printTitleList[1].split("|")
	var printVarList = printTitleList[2].split("|")
	var hospitalName = "北京协和医院"; //document.getElementById("hospitalName").value;
	//1 Print Excel Head
	xlsSheet.cells(1, 1) = hospitalName; //+"  "+typeDesc;
	xlcenter(xlsSheet, 1, 1, printDescList.length);
	mergcell(xlsSheet, 1, 1, printDescList.length);
	FontStyle(xlsSheet, 1, 1, 6, 18);
	xlsSheet.cells(2, 1) = typeDesc
	xlcenter(xlsSheet, 2, 1, printDescList.length)
	mergcell(xlsSheet, 2, 1, printDescList.length)
	FontStyle(xlsSheet, 2, 1, 6, 12)
		//var PatInfo=document.getElementById("PatInfo").value;
		//var regNo=document.getElementById("regNo").value;
		//var str=cspRunServerMethod(PatInfo,regNo);
		//var arr=str.split("^");
		//var titleDesc=arr[0]+"   "+arr[4]+"   "+arr[3]+"   "+arr[7]+"   "+arr[1];
		//mergcell(xlsSheet,2,1,printDescList.length);
		//xlsSheet.cells(2,1)=titleDesc;

	//2 Print Table Head
	for (var k = 0; k < printVarList.length; k++) {
		var printDesc = printDescList[k];
		xlsSheet.cells(5, k + 1) = printDesc;
	}
	gridlistRow(xlsSheet, 5, 5, 1, printDescList.length);
	//3 Print Table Body
	var i, j, oeoriIdStr = "",
		row = 6,
		firstRow = 0;
	var objtbl = document.getElementById('tDHCNurSkinTestOrder');
	if (objtbl.rows.length < 1) {
		alert(t['alert:selOrder']);
		return;
	}
	for (i = 1; i < objtbl.rows.length; i++) {
		var check = document.getElementById('seleitemz' + i);
		if (check.checked == true) {
			firstRow = firstRow + 1;
			var oeoriId = document.getElementById('oeoriIdz' + i).innerText;
			if (oeoriIdStr.length == 0) {
				oeoriIdStr = oeoriId
			} else {
				oeoriIdStr = oeoriIdStr + "^" + oeoriId;
			}
			//4.Print Title
			if (firstRow == 1) setFrameTitle(xlsSheet, oeoriId);
			for (j = 0; j < printVarList.length; j++) {
				var printVar = printVarList[j];
				var printVarObj = document.getElementById(printVar + 'z' + i);
				if (printVarObj) {
					//alert(printVar);
					if (printVar == "arcimDesc") {
						//alert(printVarObj.innerText);
						if ((printVarObj.innerText.indexOf("( )") > -1) || (printVarObj.innerText.indexOf("(阴性)") > -1) || (printVarObj.innerText.indexOf("(阳性)") > -1) || (printVarObj.innerText.indexOf("(++)") > -1) || (printVarObj.innerText.indexOf("(+++)") > -1) || (printVarObj.innerText.indexOf("(++++)") > -1)) {
							//if ((printVarObj.innerText.indexOf("( )")>-1)||(printVarObj.innerText.indexOf("(-)")>-1)||(printVarObj.innerText.indexOf("(+)")>-1)||(printVarObj.innerText.indexOf("(++)")>-1)||(printVarObj.innerText.indexOf("(+++)")>-1)||(printVarObj.innerText.indexOf("(++++)")>-1)){
							//alert(printVarObj.innerText);
							var arcimDescList = printVarObj.innerText.split("____");
							if (arcimDescList.length > 1) {
								var tmpVal = "____" + String.fromCharCode(9650) + arcimDescList[1];
							} else {
								var tmpVal = String.fromCharCode(9650) + arcimDescList[0];
							}
						}
						//alert(1);
						xlsSheet.cells(row, j + 1) = tmpVal;
					} else {
						xlsSheet.cells(row, j + 1) = printVarObj.innerText;
					}
				} else {
					xlsSheet.cells(row, j + 1) = "";
					if (j == 3) {
						var TestStartTime = document.getElementById('TestStartTimez' + i).innerText;
						xlsSheet.cells(row, j + 1) = TestStartTime;
					}
					if (j == 4) {
						var TestStartTime = document.getElementById('ObserveTimez' + i).innerText;
						if ((TestStartTime != "") && (TestStartTime != " ")) xlsSheet.cells(row, j + 1) = "请过" + TestStartTime + "看结果";
					}
				}
			}
			row = row + 1;
		}
	}
	//gridlistRow(xlsSheet,row-1,2,1,printDescList.length);
	gridlistRowMergy(xlsSheet, row - 1, 5, 1, printDescList.length);
	xlsSheet.cells(row, 1) = "注:药品前注有" + String.fromCharCode(9650) + "表示必须做皮试";
	if (oeoriIdStr.length > 0) {
		SetPrintFlag(oeoriIdStr);
	}
	xlsSheet.printout
		//xlsExcel.Visible = true;
		//xlsSheet.PrintPreview ;
	xlsSheet = null;
	xlsBook.Close(savechanges = false);
	xlsBook = null;
	xlsExcel.Quit();
	xlsExcel = null;
}

function setFrameTitle(xlsSheet, oeoriId) {
	var prescNo = "",
		prescDate = "",
		presCP = "",
		printDate = "";
	var objGetPrescInfo = document.getElementById("GetPrescInfo");
	if (objGetPrescInfo) {
		var str = cspRunServerMethod(objGetPrescInfo.value, oeoriId);
		var strArr = str.split("^");
		if (strArr.length > 2) {
			prescNo = strArr[0];
			prescDate = strArr[1];
			presCP = strArr[2];
			printDate = strArr[3];
		}
	}
	var PatInfo = document.getElementById("PatInfo").value;
	var regNo = document.getElementById("regNo").value;
	var str = cspRunServerMethod(PatInfo, regNo);
	var arr = str.split("^"); //regNo_"^"_ctloc_"^"_room_"^"_sex_"^"_pagName
	xlsSheet.cells(3, 1) = arr[0];
	xlsSheet.cells(3, 2) = arr[0];
	mergcell(xlsSheet, 3, 3, 4)
	xlsSheet.cells(3, 3) = "处方号:" + prescNo;
	//xlsSheet.cells(3,4)=prescNo;
	xlsSheet.cells(3, 5) = "处方日期:";
	xlsSheet.cells(3, 6) = prescDate;
	xlsSheet.cells(3, 7) = "打印日期:";
	xlsSheet.cells(3, 8) = printDate;
	xlsSheet.cells(3 + 1, 1) = "姓名:" + arr[4] + "         性别:" + arr[3];
	xlsSheet.cells(3 + 1, 2) = "年龄:" + arr[7];
	xlsSheet.cells(3 + 1, 4) = "处方医生:";
	xlsSheet.cells(3 + 1, 5) = presCP; //arr[11];
	xlsSheet.cells(3 + 1, 7) = "就诊科室:";
	xlsSheet.cells(3 + 1, 8) = arr[1];
}

function SetPrintFlag(oeoriIdStr) {
	var queryTypeCode = document.getElementById("queryTypeCode").value;
	var wardId = session['LOGON.CTLOCID']; //document.getElementById("wardid").value;
	var userId = session['LOGON.USERID'];
	var SetPrintFlag = document.getElementById("SetPrintFlag").value;
	if (oeoriIdStr != "") {
		resStr = cspRunServerMethod(SetPrintFlag, wardId, userId, queryTypeCode, oeoriIdStr);
	}
}

function getuserCode() {
	if (window.event.keyCode == 13) {
		var objuserCode = document.getElementById("userCode")
		if (objuserCode) {
			if (objuserCode.value == "") {
				objuserCode.focus();
				return;
			} else {
				var objpassWord = document.getElementById("passWord");
				if (objpassWord) objpassWord.focus();
			}
		}
	}
}

function getpassWord() {
	if (window.event.keyCode == 13) {
		var objpassWord = document.getElementById("passWord")
		if (objpassWord) {
			if (objpassWord.value == "") {
				objpassWord.focus();
				return;
			} else {
				var objuserCodeAudit = document.getElementById("userCodeAudit");
				if (objuserCodeAudit) objuserCodeAudit.focus();
			}
		}
	}
}

function getuserCodeAudit() {
	if (window.event.keyCode == 13) {
		var objuserCodeAudit = document.getElementById("userCodeAudit")
		if (objuserCodeAudit) {
			if (objuserCodeAudit.value == "") {
				objuserCodeAudit.focus();
				return;
			} else {
				var objpassWordAudit = document.getElementById("passWordAudit");
				if (objpassWordAudit) objpassWordAudit.focus();
			}
		}
	}
}

function getpassWordAudit() {
	if (window.event.keyCode == 13) {
		var objpassWordAudit = document.getElementById("passWordAudit")
		if (objpassWordAudit) {
			if (objpassWordAudit.value == "") {
				objpassWordAudit.focus();
				return;
			} else {
				var objbutUpdate = document.getElementById("butUpdate");
				if (objbutUpdate) objbutUpdate.focus();
			}
		}
	}
}
/// PPD皮试结果判读标准
function GetPPDStandard(AbnormalNote, AbnormalNoteText) {
	var retStr = "";
	if (AbnormalNote.indexOf("皮肤硬结") > -1) {
		AbnormalNoteText = eval(AbnormalNoteText);
		if (AbnormalNoteText < 5) retStr = "(-)";
		if ((AbnormalNoteText >= 5) && (AbnormalNoteText <= 10)) retStr = "(+)";
		if ((AbnormalNoteText > 10) && (AbnormalNoteText <= 20)) retStr = "(++)";
		if (AbnormalNoteText > 20) retStr = "(+++)";
	}
	if ((AbnormalNote.indexOf("局部水泡") > -1) || (AbnormalNote.indexOf("坏死") > -1) || (AbnormalNote.indexOf("淋巴管炎") > -1)) {
		retStr = "(++++)";
	}
	return retStr;
}

function SetSelOption(element, setvalue) {
	var obj = document.getElementById(element)
	if (obj) {
		for (var i = 0; i < obj.options.length; i++) {
			var text = obj.options[i].text;
			if (text == setvalue) {
				//alert(i+","+text+","+setvalue);
				obj.options[i].selected = true;
				//var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
				//isCanInsertPPD(oeoriId);
			}
		}
	}
}

function SetDefaultValue(TestOeoriDr) {
	if (TestOeoriDr != "") {
		isCanInsertPPD(TestOeoriDr);
		var objGetInfoByOrder = document.getElementById("GetInfoByOrder");
		if (objGetInfoByOrder) {
			var resStr = cspRunServerMethod(objGetInfoByOrder.value, TestOeoriDr);
			if (resStr != "") {
				arrStr = resStr.split("^");
				if (arrStr.length > 1) {
					SetObserveTime("DHCNurSkinTestOrder", arrStr[0]);
					SetSelOption("TestMethodSel", arrStr[1]);
				}
			}
		}
	}
}
///设置医嘱项对应的观察时间
function SetObserveTime(CompoentName, SetValue) {
	var flag = 0;
	var objdiv = document.getElementById("d" + CompoentName);
	var objdivtable = objdiv.getElementsByTagName("table");
	if ((objdivtable) && (objdivtable.length > 0)) {
		var objdivtabletr = objdivtable[0].getElementsByTagName("input");
		for (var i = 0; i < objdivtabletr.length; i++) {
			//alert(objdivtabletr[i].type+","+objdivtabletr[i].id);
			if (objdivtabletr[i].type == "checkbox") {
				var checkLable = document.getElementById("c" + objdivtabletr[i].id);
				if ((checkLable)&&(checkLable.innerText == SetValue)) {
					objdivtabletr[i].checked = true;
					flag = 1;
					if (objdivtabletr[i].id != "Observe20Min") {
						var Observe20Min = document.getElementById("Observe20Min");
						if (Observe20Min.checked == true) Observe20Min.checked = false;
					}
					break;
				}
			}
		}
	}
	if (flag == 0) {
		var ArrValue = SetValue.split("分钟");
		if (ArrValue.length > 1) {
			var ObserveDefine = document.getElementById("ObserveDefine");
			if (ObserveDefine) ObserveDefine.value = ArrValue[0];
			var Observe20Min = document.getElementById("Observe20Min");
			if (Observe20Min.checked == true) Observe20Min.checked = false;
		}
	} else {
		var ObserveDefine = document.getElementById("ObserveDefine");
		if (ObserveDefine) ObserveDefine.value = "";
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
	//alert(1)
	var selrow = DHCWeb_GetRowIdx(window);
	if ((!selrow) || (selrow < 1)) return;
	var EpisodeID = document.getElementById("EpisodeIDz" + selrow).innerText;
	var win = top.frames['eprmenu'];
	if (win) {
		var frm = win.document.forms['fEPRMENU'];
	} else {
		var frm = top.document.forms['fEPRMENU'];
	}
	if (frm) frm.EpisodeID.value = EpisodeID;
	var selOriId = document.getElementById("oeoriIdz" + selrow).innerText;
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=GetSkinPPD&Ordid=" + selOriId
	parent.frames['NurseBottomlast'].document.location.href = lnk;
	SetDefaultValue(selOriId);
	var obj = document.getElementById("seleitemz" + selrow);
	var selCss = document.getElementById("tDHCNurSkinTestOrder").rows[selrow].className;
	if(selCss=="clsRowSelected"){
		if (obj) obj.checked = true;
	}
	else{
		if (obj) obj.checked = false;
	}
	isCanInsertPPD(selOriId);
}

function getAbnormalNoteText() {
	if (window.event.keyCode == 13) {
		var objAbnormalNoteText = document.getElementById("AbnormalNoteText2")
		if (objAbnormalNoteText) objAbnormalNoteText.focus();
	}
}

function getAbnormalNoteText2() {
	if (window.event.keyCode == 13) {
		var objAbnormalNote1Text1 = document.getElementById("AbnormalNote1Text1")
		if (objAbnormalNote1Text1) objAbnormalNote1Text1.focus();
	}
}

function getAbnormalNote1Text1() {
	if (window.event.keyCode == 13) {
		var objAbnormalNote1Text2 = document.getElementById("AbnormalNote1Text2")
		if (objAbnormalNote1Text2) objAbnormalNote1Text2.focus();
	}
}

function getAbnormalNote1Text2() {
	if (window.event.keyCode == 13) {
		var objAbnormalNote4Text1 = document.getElementById("AbnormalNote4Text1")
		if (objAbnormalNote4Text1) objAbnormalNote4Text1.focus();
	}
}

function getAbnormalNote4Text1() {
	if (window.event.keyCode == 13) {
		var objAbnormalNote4Text2 = document.getElementById("AbnormalNote4Text2")
		if (objAbnormalNote4Text2) objAbnormalNote4Text2.focus();
	}
}

function butSaveFn() {
	//return;  //ggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
	var userId = session['LOGON.USERID'];
	var objsaveppd = document.getElementById("saveppd");
	//alert(userId)
	var count = 0,
		oeoriStr = "";
	var objtbl = document.getElementById('tDHCNurSkinTestOrder');
	var tableRows = objtbl.rows.length;
	for (var i = 1; i < tableRows; i++) {
		var check = document.getElementById('seleitemz' + i);
		if (check.checked == true) {
			count = count + 1
			oeoriStr = document.getElementById("oeoriIdz" + i).innerText;
			TestAdmDr = document.getElementById("EpisodeIDz" + i).innerText;
			TestOeoriDr = document.getElementById("oeoriIdz" + i).innerText;
			oeoriStr = TestOeoriDr;
			if (TestOeoriDr != "") {
				var tmpTestOeoriDr = TestOeoriDr.split("||");
				TestOeoriDr = tmpTestOeoriDr[0] + "!!" + tmpTestOeoriDr[1];
			}
		}
	}
	if (count != 1) {
		alert(t['alert:selectSingle']);
		return;
	}
	var AbnormalNoteText = document.getElementById("AbnormalNoteText"); //皮肤硬结
	var AbnormalNoteText2 = document.getElementById("AbnormalNoteText2");
	var TestSkinSityOne = AbnormalNoteText.value; //硬结1
	var TestSkinSityTwo = AbnormalNoteText2.value; //硬结2
	var AbnormalNote1Text1 = document.getElementById("AbnormalNote1Text1"); //局部水泡
	var AbnormalNote1Text2 = document.getElementById("AbnormalNote1Text2");
	var TestSkinVclOne = AbnormalNote1Text1.value; //水泡1
	var TestSkinVclTwo = AbnormalNote1Text2.value; //水泡2
	var AbnormalNote2 = document.getElementById("AbnormalNote2"); //坏死
	var AbnormalNote3 = document.getElementById("AbnormalNote3"); //淋巴管炎
	var AbnormalNote3 = AbnormalNote3.checked;
	if (AbnormalNote3 == true) {
		TestSkinInflam = "1";
	} else {
		TestSkinInflam = "";
	}
	var AbnormalNote4Text1 = document.getElementById("AbnormalNote4Text1"); //红肿
	var AbnormalNote4Text2 = document.getElementById("AbnormalNote4Text2");
	var TestSkinSwoOne = AbnormalNote4Text1.value; //红肿1
	var TestSkinSwoTwo = AbnormalNote4Text2.value; //红肿2
	var AbnormalNote1Check1 = document.getElementById("AbnormalNote1Check1"); //单个
	var SkinSing = AbnormalNote1Check1.checked;
	if (SkinSing == true) {
		TestSkinSing = "1"
	} else {
		TestSkinSing = ""
	}
	var AbnormalNote1Check2 = document.getElementById("AbnormalNote1Check2"); //散在
	var SkinSpora = AbnormalNote1Check2.checked;
	if (SkinSpora == true) {
		TestSkinSpora = "1"
	} else {
		TestSkinSpora = ""
	}
	var AbnormalNote2 = document.getElementById("AbnormalNote2"); //坏死
	var SkinNecrosis = AbnormalNote2.checked;
	if (SkinNecrosis == true) {
		TestSkinNecrosis = "1"
	} else {
		TestSkinNecrosis = ""
	}
	//alert(AbnormalNote2.checked)
	if ((TestSkinSityOne == "") && (TestSkinVclOne == "") && (TestSkinSwoOne == "") && (TestSkinNecrosis == "") && (TestSkinInflam == "") && (TestSkinSing == "") && (TestSkinSpora == "")) return;
	var PPDResult = document.getElementById('PPDCalculte').value;
	var parr = "TestAdmDr|" + TestAdmDr + "^TestDate|" + "^TestTime|" + "^RecUser|" + userId + "^TestOeoriDr|" + TestOeoriDr + "^TestSkinSityOne|" + TestSkinSityOne + "^TestSkinSityTwo|" + TestSkinSityTwo + "^TestSkinVclOne|" + TestSkinVclOne + "^TestSkinVclTwo|" + TestSkinVclTwo + "^TestSkinSwoOne|" + TestSkinSwoOne + "^TestSkinSwoTwo|" + TestSkinSwoTwo + "^TestSkinNecrosis|" + TestSkinNecrosis + "^TestSkinInflam|" + TestSkinInflam + "^TestSkinSing|" + TestSkinSing + "^TestSkinSpora|" + TestSkinSpora+ "^PPDResult|" + PPDResult
	var ret = cspRunServerMethod(objsaveppd.value, "", parr);
	if (ret == "0") {
		alert("保存成功")
	} else {
		alert(ret)
	}
	var ordid = TestOeoriDr.replace(/!!/, "||")
		//alert(ordid)
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=GetSkinPPD&Ordid=" + ordid
	parent.frames['NurseBottomlast'].document.location.href = lnk;
	return;
}

function printExecSheet()
{
	var queryTypeCode = document.getElementById('queryTypeCode').value;
	var objtbl = document.getElementById('tDHCNurSkinTestOrder');
	var oeoriIdStr = "",seqNoStr = "";
	var printedId = new Array();
	for (i = 1; i < objtbl.rows.length; i++) {
		var check = document.getElementById('seleitemz' + i);
		var oeoriId = document.getElementById('oeoriIdz' + i).innerText;
		var oeoriIdArray=oeoriId.split("||")
		seqNo=tkMakeServerCall("web.DHCCLCom","GetSeqNo",oeoriIdArray[0],oeoriIdArray[1])+"||"+oeoriIdArray[2]
		//var seqNo = document.getElementById('tmpSeqNoz' + i).innerText;
		//var PrintFlag = document.getElementById('prtFlagz' + i).innerText;
		if (check.checked == true) {
			
			var orderStrList = oeoriId.split("||");
			
			/*if(printedId[orderStrList[0]+"||"+orderStrList[1]])
	    	{
		    	continue;
	    	}*/
	    	
			if (oeoriIdStr.length == 0) {
				oeoriIdStr = oeoriId;
			} else {
				oeoriIdStr = oeoriIdStr + "^" + oeoriId;
			}
			if (seqNoStr.length == 0) {
				seqNoStr = seqNo;
			} else {
				seqNoStr = seqNoStr + "^" + seqNo;
			}
			printedId[orderStrList[0] + "||" + orderStrList[1]] = 1;
		}
	}
	if (oeoriIdStr == "") {
		alert("请选择医嘱！");
		return;
	}
	//												oeoriIdStr, seqNoStr, "T", queryTypeCode, session['WebIP'], "true", 1, "NurseOrderOP.xml")
	//DHCCNursePrintComm.
	showNurseExcuteSheetPreview(oeoriIdStr, seqNoStr, "PAT", queryTypeCode, "", "true", 1, "NurseOrderOP.xml");
	//if (DHCCNursePrintComm.saveFlag == 1) {
		SetPrintFlag(oeoriIdStr, "Y",queryTypeCode);
		SavePrintRecord("PAT", queryTypeCode, oeoriIdStr, session['LOGON.USERID']);
	//}
	self.location.reload();
}

function SetPrintFlag(oeoriIdStr, printFlag,queryTypeCode) {
	if (oeoriIdStr != "") {
		if (!printFlag) {
			printFlag = "Y";
		}
		var Wardid = tkMakeServerCall("web.PACWard", "GetWardFromLoc", session['LOGON.CTLOCID']); //
		resStr = tkMakeServerCall("web.DHCNurCom", "SetPrintFlagNew", Wardid, session['LOGON.USERID'], queryTypeCode, oeoriIdStr, printFlag);

	}
}

function SavePrintRecord(printType, queryTypeCode, OrderStr, UserId) {
	var ModelName;
	if (printType == "P") {
		ModelName = "DHCNurOPExecP"; ///模块代码，DHC_EventModel表中Code
	} else if (printType == "PAT") {
		ModelName = "DHCNurOPExecPAT";
	} else if (printType == "S") {
		ModelName = "DHCNurOPExecS";
	} else if (printType == "T") {
		ModelName = "DHCNurOPExecT";
	}
	var SecretCode = ""
	var ret = tkMakeServerCall("web.DHCCLCom", "SaveRecord", ModelName, OrderStr, printType, queryTypeCode, SecretCode, UserId);
	
}
document.body.onload = BodyLoadHandler;
