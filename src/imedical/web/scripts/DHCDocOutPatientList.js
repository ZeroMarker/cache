var ComponentID=""
var fso = new ActiveXObject("WScript.NetWork");
var fs = new ActiveXObject("Scripting.FileSystemObject");
var m_CardNoLength=0;
var m_SelectCardTypeDR="";
var AllocMode="M" //"S" 表示一次分诊,"M"表示二次分诊
var CallSum=1 // 一次呼叫病人的数量?目前呼叫病人只能为1
var SubCallSum=4 //一次候诊病人的数量
var GNextCallStatus="N" //是否点击?下一个?舶磁?
var Tselected="";
var m_PatientNoLength=8;
var CheckMutually="Report^AllPatient^ArrivedQue^RegQue^Consultation" //互斥的Check勾选
if (document.getElementById("PatientNoLen")){
	m_PatientNoLength=document.getElementById("PatientNoLen").value;
}
var selectedRow=""
window.setTimeout(Find_click,120000);
function findHandler() {
	return Find_click();
}

function ListDocCurrentLoadHandler() {
	//
	
	
	var obj=document.getElementById("IPAddress");
	//alert(obj.value)
	var obj=document.getElementById("CardNo");
	if(obj) obj.onkeydown=CardNoclick;
	var obj=document.getElementById("PatientNo");
	if(obj) obj.onkeydown=PatientNoCheck;
	//
	var obj=document.getElementById("NextPatient");
	if(obj) obj.onclick=CallNextPatient;
	//
	var obj=document.getElementById("callButton");
	if(obj) obj.onclick=NewCallPatient;
	var obj=document.getElementById("recallButton");
	if(obj) obj.onclick=ReCallPatient;
	//
	var obj=document.getElementById("Find");
	if(obj) obj.onclick=findHandler;
	//
	var obj=document.getElementById("Arrived");
	if(obj) obj.onclick=ArrivedHandler;
	//
	var obj=document.getElementById("ClinicalDept");
	if(obj) obj.onkeypress=ClinicalDept_OnKeyPress;
	//
	var obj=document.getElementById("Doctor");
	if(obj) obj.onkeypress=Doctor_OnKeyPress;
	//
	var obj=document.getElementById("AdmType");
	if(obj) obj.onkeypress=AdmType_OnKeyPress;
	//
	var obj=document.getElementById("Ward");
	if(obj) obj.onkeypress=Ward_OnKeyPress;
	//
	var obj=document.getElementById("Bed");
	if(obj) obj.onkeypress=Bed_OnKeyPress;
	//
	var tbl=document.getElementById("tDHCDocOutPatientList");
	if(tbl) tbl.ondblclick=DHC_SelectPat;
	
	var tbl=document.getElementById("tDHCDocOutPatientList");
	//if(tbl) tbl.onmousedown=DHCGetSelectRow;

	var obj=document.getElementById("ArrivedQue");
	if (obj){
		//到达队列
		obj.onclick=CheckBox_OnClick;
	}
	var obj=document.getElementById("RegQue");
	if (obj){
		//挂号队列
		obj.onclick=CheckBox_OnClick;
	}
	var obj=document.getElementById("AllPatient");
	if (obj){
		//全部
		obj.onclick=CheckBox_OnClick;
	}
	var obj=document.getElementById("Consultation");
	if (obj){
		//会诊
		obj.onclick=CheckBox_OnClick;
	}
	var obj=document.getElementById("Report");
	if (obj){
		//报到
		obj.onclick=CheckBox_OnClick;
	}
	
	var buttonHidden=document.getElementById('buttonHidden');
	if (buttonHidden) {var encmeth=buttonHidden.value} else {var encmeth=''};
	if (encmeth!=""){
		var IPAddress=GetComputerIp()
		if((IPAddress!="Exception")&&(IPAddress!=""))
		{
			var IPFlag=cspRunServerMethod(encmeth,IPAddress);
		}
		else
		{
			var IPFlag=cspRunServerMethod(encmeth);
		}
		if (IPFlag!=0){
			var callObj=document.getElementById("callButton");
			if(callObj) callObj.style.display="none"
			var recallObj=document.getElementById("recallButton")
			if(recallObj) recallObj.style.display="none"
		}else{
			var nextPatObj=document.getElementById("NextPatient");
			if(nextPatObj) nextPatObj.style.display="none"
		}
	}
	ColorTblColumn(tbl,'PAPMINO','PAAdmReason','PaySit');
	//
	//preferences exist...
	//
	//var ComponentID="";
	var WorkComponent=document.getElementById("WorkComponent");
	if (WorkComponent) {ComponentID=WorkComponent.value;}
	//
	//
	var PrefParams=document.getElementById("PrefParams");
	var aryParams = PrefParams.value.split("^");
	if (aryParams.length > 21) {
		var obj=document.getElementById("StartDate");
		if (obj && (obj.value=="")) {
			if ((aryParams[20]!="") ) {obj.value = aryParams[20];}
		}
		var obj=document.getElementById("EndDate");
		if (obj && (obj.value=="")) {
			if ((aryParams[21]!="") ) {obj.value = aryParams[21];}
		}
		//
		if (aryParams[8]!="")	{
			var LocStr = aryParams[8].split('\001');
			var ids = "";
			for (var tmploc = 0; tmploc < LocStr.length; tmploc++) {
				var LocItem = LocStr[tmploc].split('\002')
				if (LocItem.length > 2) {
					if (ids !="" ) { ids+= "\001";}
					ids+= LocItem[2];
				}
			}
			var CurrentDept=document.getElementById("CurrentDept");			
			CurrentDept.value = ids;
		}
		//
		if (aryParams[4]!="")	{
			var AdmTypeStr = aryParams[4];
			var ids = "";
			ids = AdmTypeStr;
			var CurrentAdmType=document.getElementById("CurrentAdmType");			
			CurrentAdmType.value = ids;
		}
		//
		if (aryParams[16]!="")	{
			var WardStr = aryParams[16].split('\001');
			var ids = "";
			for (var tmpward = 0; tmpward < WardStr.length; tmpward++) {
				var WardItem = WardStr[tmpward].split('\002')
				if (WardItem.length > 2) {
					if (ids !="" ) { ids+= "\001";}
					ids+= WardItem[2];
				}
			}
			var CurrentWard=document.getElementById("CurrentWard");			
			CurrentWard.value = ids;
		}
		if (aryParams[6]!="")	{
			var DocStr = aryParams[6].split('\001');
			var ids = "";
			for (var tmpdoc = 0; tmpdoc < DocStr.length; tmpdoc++) {
				var DocItem = DocStr[tmpdoc].split('\002')
				if (DocItem.length > 1) {
					if (ids !="" ) { ids+= "\001";}
					//alert(DocItem[0]+"^"+DocItem[1]);	
					ids+= DocItem[0];
				}
			}
			var CurrentDoctor=document.getElementById("CurrentDoctor");			
			CurrentDoctor.value = ids;
		}
		
	}

		//**************读卡,xp add,20080421**********************
		var Obj=document.getElementById('B_ReadMagCard');
		if (Obj) Obj.onclick = B_ReadCard;
		
		var myobj=document.getElementById('CardTypeDefine');
		if (myobj){
			myobj.onchange=CardTypeDefine_OnChange;
			myobj.size=1;
			myobj.multiple=false;
		}
		loadCardType()
		CardTypeDefine_OnChange()
		//**************读卡,xp add,20080421**********************  

	CheckQuePriority(tbl);
	CheckCallStatus(tbl,"");	
	
	///初始化号别
	var Obj=document.getElementById('DocList');
	if (Obj){
		Obj.size=1;
		Obj.multiple=false;
		Obj.onchange=DocListChenge
		 var varItem = new Option("","");
	     	Obj.options.add(varItem);
		 var ObjMeth=document.getElementById('GetResDocEncrypt');
		 if (ObjMeth) {var encmeth=ObjMeth.value}else{var encmeth=""}
		 if (encmeth!=""){
		 var Str=cspRunServerMethod(encmeth,session['LOGON.USERID'],session['LOGON.CTLOCID'])
		 if (Str!=""){
			 var StrArry=Str.split("^");
			 var CodeSub=String.fromCharCode(1);
			 var ArryLength=StrArry.length;
			 for (var i=0;i<ArryLength;i++)
			 {
				 var varItem = new Option(StrArry[i].split(CodeSub)[1],StrArry[i].split(CodeSub)[0]);
				 Obj.options.add(varItem);
				
				}
	  		}
		 }
	  var ObjMark=document.getElementById('MarkID');
		if (ObjMark){
			Obj.value=ObjMark.value;
			if (Obj.value=="") {
				var UserID=session['LOGON.USERID'];
				var LogonLocID=session['LOGON.CTLOCID']
				var SessionName=UserID+"Z"+LogonLocID;
				var encmeth=DHCC_GetElementData("GetSessionData");
				var SessionMarkID=cspRunServerMethod(encmeth,SessionName);
				if (SessionMarkID!="") {
					Obj.value=SessionMarkID;
					ObjMark.value=SessionMarkID;
				}
			}
		}
	}		

}
function DocListChenge()
{
	var ObjDoc=document.getElementById('DocList');
	var Obj=document.getElementById('MarkID');
	if (Obj){
		Obj.value=ObjDoc.value;
		//记录到Session中,下次在查询的时候使用
		var UserID=session['LOGON.USERID'];
		var LogonLocID=session['LOGON.CTLOCID']
		var SessionName=UserID+"Z"+LogonLocID;
		var encmeth=DHCC_GetElementData("SetSessionData");
		cspRunServerMethod(encmeth,SessionName,ObjDoc.value);
		}
	return findHandler();
}

//*******************读卡,xp add,20080421********************************************

function CheckBox_OnClick(){
	try{
	var Obj=GetEventElementObj()
	if(Obj.name=="Report") CheckMutually="Report^AllPatient^ArrivedQue^RegQue"
	if(Obj.name=="Consultation") CheckMutually="AllPatient^ArrivedQue^RegQue^Consultation"
	var CheckMutuallyArry=CheckMutually.split("^")
	for (var i=0;i<CheckMutuallyArry.length;i++)
	{
		if (Obj.name!=CheckMutuallyArry[i])
		{
			var ObjCheck=document.getElementById(CheckMutuallyArry[i]);
			if (ObjCheck){ObjCheck.checked=false}
		}
		
	}
	var ObjName=document.getElementById("CheckName");
	if (ObjName){
		var obj1=document.getElementById(Obj.name);
		if(obj1.checked)ObjName.value=Obj.name
		else ObjName.value=""
	}
	CheckMutually="Report^AllPatient^ArrivedQue^RegQue^Consultation" //互斥的Check勾选
	return findHandler();
	}catch(e){}
}
function DHCGetSelectRow(e){
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	if (rowObj) {
		//Simulate to click a row for sending Parameter to MENU BAR
		rowObj.click();
		var selectrow=rowObj.rowIndex;
	}
	Tselected=selectrow;
}

function loadCardType(){
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=DHCWebD_GetObjValue("CardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
	}
}

function CardTypeDefine_OnChange()
{
	var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	
	var myary=myoptval.split("^");
	
	var myCardTypeDR=myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	if (myCardTypeDR=="")
	{
		return;
	}
	///Read Card Mode
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("ReadCard");
	}
	else
	{
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = true;
		}
		var obj=document.getElementById("ReadCard");
		if (obj){
			obj.disabled=false;
			obj.onclick=ReadHFMagCard_Click;
		}
	}
	
	//Set Focus
	if (myary[16]=="Handle"){
		DHCWeb_setfocus("CardNo");
	}else{
		DHCWeb_setfocus("B_ReadMagCard");
	}
	
	m_CardNoLength=myary[17];
	
}

function SetCardNOLength(){
	var obj=document.getElementById('RCardNo');
		if (obj.value!='') {
			if ((obj.value.length<m_CardNoLength)&&(m_CardNoLength!=0)) {
				for (var i=(m_CardNoLength-obj.value.length-1); i>=0; i--) {
					obj.value="0"+obj.value
				}
			}
			var myCardobj=document.getElementById('CardNo');
			if (myCardobj){
				myCardobj.value=obj.value;
			}
		}
}

function B_ReadCard()
{
	var myEquipDR=DHCWeb_GetListBoxValue("CardTypeDefine");
	//var myEquipDR=combo_CardType.getActualValue();
    var CardInform=DHCACC_GetAccInfo(m_SelectCardTypeDR,myEquipDR)
	CardInform=CardInform.toString()
   
    var myary=CardInform.split("^");
    //alert(CardInform);
    var rtn=myary[0];
    var CardNo=myary[1];
    var PatientNo=myary[5];
	switch (rtn){
		case "-200": //卡无效
			alert("卡无效");
			DHCC_SetElementData('PatientNo','');
			DHCC_SetElementData('CardNo','');
			break;
		default:
			DHCC_SetElementData('PatientNo',PatientNo);
			DHCC_SetElementData('CardNo',CardNo);
			//alert(myary[5])
			return Find_click();
			break;
	}
		
}
//*******************读卡,xp add,20080421********************************************
function GetCardTypeRowId(){
	var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	var myary=myoptval.split("^");
	var myCardTypeDR=myary[0];
	var CardTypeRowId = myCardTypeDR;
	return CardTypeRowId;
}
function CardNoclick(e) {
	//这边要与卡处理一致
	if (evtName=='CardNo') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key==13) {
			var CardNo=document.getElementById('CardNo').value
		if (CardNo=="") return;
		if ((CardNo.length<m_CardNoLength)&&(m_CardNoLength!=0)) {
			for (var i=(m_CardNoLength-CardNo.length-1); i>=0; i--) {
				CardNo="0"+CardNo;
				//alert(CardNo)
			}
		}
		document.getElementById('CardNo').value=CardNo
		var CardTypeRowId=GetCardTypeRowId();
		var myrtn=DHCACC_GetAccInfo(CardTypeRowId,CardNo,"","PatInfo");
		//var myrtn=DHCACC_GetAccInfo("",CardNo,"","PatInfo");
		var myary=myrtn.split("^");
		var rtn=myary[0];
		AccAmount=myary[3];
		//alert(myrtn)

		switch (rtn){
			case "-200": //卡无效
				alert("卡无效");
				document.getElementById('PatientNo').value=""
				websys_setfocus('CardNo');
				break;
			default:
				//alert(myrtn)
				document.getElementById('PatientNo').value=myary[5]
				return Find_click()
				break;
		}
		
	}
}



function PatientNoCheck(e)	{
	//
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='keydown')&&(key==9)) {
		var PatientNo=document.getElementById('PatientNo');
		if (PatientNo.value.length<m_PatientNoLength) {
			for (var i=(m_PatientNoLength-PatientNo.value.length-1); i>=0; i--) {
				PatientNo.value="0"+PatientNo.value
			}
		}
		websys_nextfocusElement(PatientNo);
	}
	if ((type=='keydown')&&(key==13)) {
		var PatientNo=document.getElementById('PatientNo');
		if (PatientNo.value.length<m_PatientNoLength) {
			for (var i=(m_PatientNoLength-PatientNo.value.length-1); i>=0; i--) {
				PatientNo.value="0"+PatientNo.value
			}
		}
		return Find_click();
	}
}

function ColorTblColumn(tbl,ColName1,ColName2,ColName3)	{
	var row=tbl.rows.length;
	var firstRow=tbl.rows[0];
	var RowItems=firstRow.all;
	//for (var j=1;j<RowItems.length;j++) {
	//	if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH')) {
	//		alert(RowItems[j].style.color)
	//		RowItems[j].style.color="red";
	//	}
	//}
	row=row-1;
	for (var j=1;j<row+1;j++) {
		var ArriveRow=0;
		var sLable1=document.getElementById(ColName1+'z'+j);
		var sLable2=document.getElementById(ColName2+'z'+j);
		var sLable3=document.getElementById(ColName3+'z'+j);
		var sLable4=document.getElementById('WalkStatus'+'z'+j);
		if (sLable1.innerText.indexOf("完成就诊:")!=-1){
			tbl.rows[j].className="clsRowPre";
			tbl.rows[j].onclick="";
			ArriveRow=j;
		}else if (sLable1.innerText.indexOf("正在就诊:")!=-1){
			tbl.rows[j].className="clsRowPre";
			tbl.rows[j].onclick="";
			ArriveRow=j;
		}else if (sLable1.innerText.indexOf("未报到病人:")!=-1){
			tbl.rows[j].className="clsRowPre";
			tbl.rows[j].onclick="";
			ArriveRow=j;
		}else if (sLable1.innerText.indexOf("已看病人:")!=-1){
			tbl.rows[j].className="blue";
			tbl.rows[j].onclick="";
			ArriveRow=j;
		}
		
		if (ArriveRow){
			var CallPat=document.getElementById("CallPat"+'z'+j);
			var Arrived=document.getElementById("Arrived"+'z'+j);
			var SkipNumber=document.getElementById("SkipNumber"+'z'+j);
			var CancelAdmiss=document.getElementById("CancelAdmiss"+'z'+j);
			if (CallPat) CallPat.style.visibility="hidden";
			if (Arrived) Arrived.style.visibility="hidden";
			if (SkipNumber) SkipNumber.style.visibility="hidden";
			if (CancelAdmiss) CancelAdmiss.style.visibility="hidden";
		}
		if (sLable2&&(sLable2.innerText.indexOf("_")!=-1)) {
			DHCC_SetColumnData(ColName2,j,sLable2.innerText.split("_")[1]);
			sLable2.style.color="red";
		}
		/*
		if (PatType=='Govement') {sTD2.className="Govement"};
		if (PatType=='Insurance') {sTD2.className="Insurance"};
		if (PatType=='Private') {sTD2.className="Private"};
		*/
	}
}

function CheckQuePriority(tbl)	{
	var row=tbl.rows.length;
	var firstRow=tbl.rows[0];
	var RowItems=firstRow.all;
	row=row-1;
	for (var j=1;j<row+1;j++) {
		var sLable1=document.getElementById('StatusCodez'+j);
		var sLable2=document.getElementById('PriorityCodez'+j);
		var tLable1=document.getElementById('WalkStatusz'+j);
		var tLable2=document.getElementById('PAAdmPriorityz'+j);		
		var sTD1=tLable1.parentElement;
		var sTD2=tLable2.parentElement;
		if (sLable1.value=='01') {sTD1.className='Govement';}
		if (sLable2.value=='01') {sTD2.className='Govement';}
	}
}
function CheckCallStatus(tbl,CallLable)	{
	var row=tbl.rows.length;
	row=row-1; 
	CurCount=0;
	for (var j=1;j<row+1;j++) {
		//
		var CurRow=tbl.rows[j];
		var WalkStatus=document.getElementById('StatusCode'+'z'+j);
		var DocDr=document.getElementById('PAAdmDocCodeDR'+'z'+j);
		var Called=document.getElementById('Called'+'z'+j);
		if ((DocDr.innerText!="")&&(DocDr.innerText!=" ")&&(WalkStatus.value!='04')) {
			if (WalkStatus.value=="01")	{
				CurRow.className='clsRowAgain';
			}
			if (CallLable=="")	{
				if (Called.value=="1")	{
					CurRow.className='clsRowCalled';
					CurCount=CurCount+1;
				}
				if (Called.value=="2")	{
					CurRow.className='clsRowCalledWait';
					CurCount=CurCount+1;
				}
				
			}				
		}
	}
	return CurCount;
}


function GetNextRow(tbl)	{
	var row=tbl.rows.length;
	row=row-1;
	for (var j=1;j<row+1;j++) {
		//
		var WalkStatus=document.getElementById('StatusCode'+'z'+j);
		var EpisodeID=document.getElementById('EpisodeID'+'z'+j).value;
		var Called=document.getElementById('Called'+'z'+j);
		if (AllocMode="S"){
			var GetQueDoc=document.getElementById('GetQueDoc');
			if (GetQueDoc) {var encmeth=GetQueDoc.value} else {var encmeth=''};
			var QueDoc=cspRunServerMethod(encmeth,EpisodeID)
			if ((QueDoc=="")) {
				return j;}
			else  {
				if ((QueDoc!="")&&(Called.value==""))	{
					return j;
				}
			}
		}
	}
	return false;
}


function GetCallRow(tbl)	{
	var row=tbl.rows.length;
	row=row-1;
	for (var j=1;j<row+1;j++) {
		//
		var WalkStatus=document.getElementById('StatusCode'+'z'+j);
		var EpisodeID=document.getElementById('EpisodeID'+'z'+j).value;
		var Called=document.getElementById('Called'+'z'+j);
		if (Called.value=="1"){
			return j
		}else if (Called.value=="2"){
			return j
		}
	}
	if ((row>=1)&&(AllocMode="M")){return 1}
	return false;
}

function GetWaitRow(tbl)	{
	var row=tbl.rows.length;
	row=row-1;
	var SumWaitRow=0
	for (var j=1;j<row+1;j++) {
		//
		var WalkStatus=document.getElementById('StatusCode'+'z'+j);
		var EpisodeID=document.getElementById('EpisodeID'+'z'+j).value;
		var Called=document.getElementById('Called'+'z'+j);
		if ((Called.value=="1")||(Called.value=="2")){
			SumWaitRow=SumWaitRow+1
		}else if (Called.value==""){
			return SumWaitRow+"^"+j
		}
	}
	return false;
}

function CallNextPatient()	{
	GNextCallStatus="Y"
	var tbl=document.getElementById("tDHCDocOutPatientList");
	var tblrow=tbl.rows.length-1;
	if (AllocMode=="S"){
		if(tbl) {var NextRow=GetNextRow(tbl);} else {var NextRow=0}
		if (NextRow>0) {
			PatName=document.getElementById('PAPMINamez'+NextRow);
			if (PatName) {PatName.click();}
		}
	}else if (AllocMode=="M"){
			//先插入候诊记录
			var NextRow=GetWaitRow(tbl)
			if(!NextRow){
				CallPatient(tbl)
				return
			}
			var myary=NextRow.split("^");
			var WaitRows=myary[0];
			var StartRow=myary[1];
			var DocDr=document.getElementById('DocDr');
			if (DocDr) {var DoctorId=DocDr.value}
			else {var DoctorId=""};
			for (var i = 0; i < (SubCallSum-WaitRows); i++) {
				if(i>=(tblrow-WaitRows)){break}
				var CurRow=eval(i)+eval(StartRow)
				EpisodeID=document.getElementById('EpisodeIDz'+CurRow).value;
								//alert(EpisodeID)

				var SetSubCallStatus=document.getElementById('SetSubCallStatus');
				if (SetSubCallStatus) {var encmeth=SetSubCallStatus.value} else {var encmeth=''};
				var Stat=cspRunServerMethod(encmeth,EpisodeID,DoctorId);
				//
				
				if (Stat=='0')	{alert(t['StatusFailure']);	break;}
				if (Stat=='102') {alert(t['HasArrived']);	break;}
				if (Stat=='103') {alert("该患者不能呼叫候诊");	break;}
				document.getElementById("Calledz"+CurRow).value="2";
				document.getElementById('CheckStatusz'+CurRow).value="1"; //dj090401
				
	  			//
			}
		//插入呼叫状态?然后呼叫
		CallPatient(tbl)
			
	}
}
function CallPatient(tbl){
//插入呼叫状态?然后呼叫
	if(tbl) {var NextRow=GetCallRow(tbl);} else {var NextRow=0}
	if (NextRow>0) {
		PatName=document.getElementById('PAPMINamez'+NextRow);
		if (PatName) {PatName.click();}
	}
}
function ClinicalDept_OnKeyPress(e) {
	if (evtName=='ClinicalDept') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='keypress')&&(key==13)) {
		var url='websys.lookup.csp';
		url += "?ID=d"+ComponentID+"iClinicalDept";
		url += "&CONTEXT=Kweb.RBResource:LookUpLocationByRes";
		var obj=document.getElementById('Doctor');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		var obj=document.getElementById('ClinicalDept');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		url += "&P3=" + 'E';
		var obj=document.getElementById('AdmType');
		if (obj) url += "&P4=" + websys_escape(obj.value);
		url += "&P5=" + '';
		url += "&P6=" + '';
		url += "&P7=" + '';
		url += "&P8=" + '1';
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
function ClinicalDept_lookupsel(value) {
	try {
		var obj=document.getElementById('ClinicalDept');
		if (obj) {
			var GetLocRowIdByCode=document.getElementById('GetLocRowIdByCode');
			if (GetLocRowIdByCode) {var encmeth=GetLocRowIdByCode.value} else {var encmeth=''};
			var Code=cspRunServerMethod(encmeth,'','',value)
  			var Loc=Code.split("^")
  			obj.value=unescape(Loc[2]);
  			var CurrentDept=document.getElementById('CurrentDept')
  			if (CurrentDept) CurrentDept.value=Loc[0]
  			var CurrentWard=document.getElementById('CurrentWard');
  			if (CurrentWard) CurrentWard.value="";
  			var CurrentBed=document.getElementById('CurrentBed');
  			if (CurrentBed) CurrentBed.value="";
  			var Ward=document.getElementById('Ward');  			
  			if (Ward) Ward.value="";
  			var Bed=document.getElementById('Bed');  			
  			if (Bed) Bed.value="";
			//obj.className='';
			websys_nextfocusElement(obj);
		}
	} catch(e) {};
}

function Doctor_OnKeyPress(e) {
	if (evtName=='Doctor') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='keypress')&&(key==13)) {
		var url='websys.lookup.csp';
		url += "?ID=d"+ComponentID+"iDoctor";
		url += "&CONTEXT=Kweb.RBResource:LookUpByPartialCareProv";
		var obj=document.getElementById('Doctor');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		var obj=document.getElementById('ClinicalDept');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		url += "&P3=" + '';
		url += "&P4=" + '';
		url += "&P5=" + '1';
		url += "&P6=" + '';
		url += "&P7=" + '';
		var obj=document.getElementById('AdmType');
		if (obj) url += "&P8=" + websys_escape(obj.value);
		url += "&P9=" + 'E';
		url += "&P10=" + '';
		url += "&P11=" + '';
		url += "&P12=" + '';
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
function Doctor_lookupsel(value) {
	try {
		var obj=document.getElementById('Doctor');
		if (obj) {
			var GetDocRowIdByCode=document.getElementById('GetDocRowIdByCode');
			if (GetDocRowIdByCode) {var encmeth=GetDocRowIdByCode.value} else {var encmeth=''};
			var Code=cspRunServerMethod(encmeth,'','',value)
  			var Doc=Code.split("^")
  			obj.value=unescape(Doc[2]);
  			var CurrentDept=document.getElementById('CurrentDoctor')
  			if (CurrentDept) CurrentDept.value=Doc[0]
			//obj.className='';
			websys_nextfocusElement(obj);
		}
	} catch(e) {};
}

function Ward_OnKeyPress(e) {
	if (evtName=='Ward') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='keypress')&&(key==13)) {
		var url='websys.lookup.csp';
		url += "?ID=d"+ComponentID+"iWard";
		url += "&CONTEXT=Kweb.PACWard:FindWardResUserID";
		var obj=document.getElementById('Ward');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		var obj=document.getElementById('UserID');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		var obj=document.getElementById('AdmType');
		if (obj) url += "&P3=" + websys_escape(obj.value);
		url += "&P4=" + '';
		url += "&P5=" + '';
		url += "&P6=" + '';
		url += "&P7=" + '';
		url += "&P8=" + '';
		url += "&P9=" + '';
		var obj=document.getElementById('ClinicalDept');
		if (obj) url += "&P10=" + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
function Ward_lookupsel(value) {
	try {
		var obj=document.getElementById('Ward');
		if (obj) {
			var GetWardRowIdByCode=document.getElementById('GetWardRowIdByCode');
			if (GetWardRowIdByCode) {var encmeth=GetWardRowIdByCode.value} else {var encmeth=''};
			var Code=cspRunServerMethod(encmeth,'','',value)
  			var Ward=Code.split("^")
  			obj.value=unescape(Ward[2]);
  			var CurrentWard=document.getElementById('CurrentWard');
  			if (CurrentWard) CurrentWard.value=Ward[0];
  			var CurrentBed=document.getElementById('CurrentBed');
  			if (CurrentBed) CurrentBed.value="";
  			var Bed=document.getElementById('Bed');  			
  			if (Bed) Bed.value="";
  			var CurrentDept=document.getElementById('CurrentDept');
  			if (CurrentDept) CurrentDept.value="";
  			var ClinicalDept=document.getElementById('ClinicalDept');
  			if (ClinicalDept) ClinicalDept.value="";	
			//obj.className='';
			websys_nextfocusElement(obj);
		}
	} catch(e) {};
}

function Bed_OnKeyPress(e) {
	if (evtName=='Bed') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='keypress')&&(key==13)) {
		var url='websys.lookup.csp';
		url += "?ID=d"+ComponentID+"iBed";
		url += "&CONTEXT=Kweb.PACBed:FindAllBInWardRes";
		var obj=document.getElementById('Ward');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		url += "&P2=" + '';
		var obj=document.getElementById('Bed');
		if (obj) url += "&P3=" + websys_escape(obj.value);
		url += "&P4=" + '';
		url += "&P5=" + '';
		url += "&P6=" + '';
		url += "&P7=" + '';
		url += "&P8=" + '';
		url += "&P9=" + '';
		var obj=document.getElementById('AdmType');
		if (obj) url += "&P10=" + websys_escape(obj.value);
		var obj=document.getElementById('ClinicalDept');
		if (obj) url += "&P11=" + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
	}
}

function Bed_lookupsel(value) {
	try {
		var obj=document.getElementById('Bed');
		if (obj) {
  			obj.value=unescape(value);
			obj.className='';
			var CurrentBed=document.getElementById('CurrentBed');
  			if (CurrentBed) CurrentBed.value=value;
			websys_nextfocusElement(obj);
		}
	} catch(e) {};
}
function AdmType_OnKeyPress(e) {
	if (evtName=='AdmType') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='keypress')&&(key==13)) {
		var url='websys.lookup.csp';
		url += "?ID=d"+ComponentID+"iAdmType";
		url += "&CONTEXT=Kwebsys.StandardTypeItem:LookUpByType";
		url += "&P1=" + 'AdmType';
		var obj=document.getElementById('AdmType');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
	}
}

function AdmType_lookupsel(value) {
	try {
		var obj=document.getElementById('AdmType');
		if (obj) {
  			obj.value=unescape(value);
			obj.className='';
			var CurrentAdmType=document.getElementById('CurrentAdmType');
  			if (CurrentAdmType) {
	  			if (value=='Inpatient') CurrentAdmType.value='I';
	  			if (value=='Outpatient') CurrentAdmType.value='O';
	  			if (value=='Emergency') CurrentAdmType.value='E';	  			
  			}
			websys_nextfocusElement(obj);
		}
	} catch(e) {};
}

function DHC_SelectPat()	{
	//
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	if (rowObj) {
		//Simulate to click a row for sending Parameter to MENU BAR
		rowObj.click();
		var selectrow=rowObj.rowIndex;
	}
	if (!selectrow) return;
	if (selectrow !=0) {
		selectedRow=selectrow
		var PatientID="";		
		var EpisodeID="";
		var mradm=""
		var PatientObj=document.getElementById("PatientIDz"+selectrow);
		var EpisodeObj=document.getElementById("EpisodeIDz"+selectrow);
		var mradmObj=document.getElementById("mradmz"+selectrow);
		var SelectObj=document.getElementById("Selectz"+selectrow);
		var StatusObj=document.getElementById("WalkStatusz"+selectrow);
		EpisodeID=EpisodeObj.value
		///tanjishan 2016-05-07
		var WinOpenFlagObj=document.getElementById('WinOpenFlag');
		if (WinOpenFlagObj) {var WinOpenFlag=WinOpenFlagObj.value} else {var WinOpenFlag=''};
		if (WinOpenFlag=="1"){
			if (!opener || !opener.switchPatient) return;
		      opener.switchPatient(PatientObj.value,EpisodeObj.value,mradmObj.value);
		      window.close();
		      return
		}
		//
		//Simulate to click a row for sending Parameter to MENU BAR
		//var frm =parent.frames[0].document.forms["fEPRMENU"];
		//modify by zzq 2010-08-31
		//var frm =parent.frames[0].document.forms["fEPRMENU"];
		var frm=parent.parent.parent.document.forms['fEPRMENU'];
		var frmEpisodeID=frm.EpisodeID;
		var frmPatientID=frm.PatientID;
		var frmmradm=frm.mradm;
		if (PatientObj) frmPatientID.value=PatientObj.value;
		if (EpisodeObj) frmEpisodeID.value=EpisodeObj.value;
		if (mradmObj) frmmradm.value=mradmObj.value ; 

		if (!CheckIsAdmissions(EpisodeID))  return false;
		
		//
		var GetWorkflowID=document.getElementById('GetWorkflowID');
		if (GetWorkflowID) {var encmeth=GetWorkflowID.value} else {var encmeth=''};
		var TWKFL=cspRunServerMethod(encmeth,'DHC EPR OP OrderEntry')

		//alert(SelectObj.id+'  '+SelectObj.checked);
		//if (SelectObj.checked)	{
			//
			var AdmDate=document.getElementById("PAAdmDatez"+selectrow).innerText
			/*if (CheckAdmDate(AdmDate)==false) {
				alert(t['AdmDateOver'])
				return false;
			}*/
			/*
			var StatusCode=document.getElementById("StatusCodez"+selectrow).value;
			if ((StatusCode=='02')||(StatusCode=='03')) {
				var StatusDesc=document.getElementById("WalkStatusz"+selectrow).innerText;
				alert(t['CurrentStatus']+StatusDesc)
				return;
			}
			*/
			//
			if (PatientObj) PatientID=PatientObj.value;
			if (EpisodeObj) EpisodeID=EpisodeObj.value;
			if (mradmObj) mradm=mradmObj.value ;
			//
			//if (session['LOGON.GROUPID']=='160')	{  
			//	var lnk="websys.csp?a=a&TMENU=266&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;
			//} else {
			//	var lnk="websys.csp?TWKFL="+TWKFL+"&TWKFLI=&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;;
			//}
			//
			PageJumpControl();
			//var lnk="websys.csp?a=a&TMENU=50147&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;
			//window.location=lnk;
		//}
	}
}

function GetSelectRow(tbl)	{
	var row=tbl.rows.length;
	var row=row-1;
	var RowRef=0;
	for (var j=1;j<row+1;j++) {
		//
		var CurRow=tbl.rows[j];
		var SelectStatus=document.getElementById('Selectz'+j);
		if (SelectStatus.checked) {
			RowRef=j;
			return RowRef;
		}
	}
	return RowRef;
}
function ArrivedHandler()	{
		var tbl=document.getElementById("tDHCDocOutPatientList");
		var selectrow=GetSelectRow(tbl)
		if (selectrow==0) {
			alert(t['AdmDateOver'])
			return false;
		}
		//
		var PatientID="";
		var EpisodeID="";
		var mradm=""
		var PatientObj=document.getElementById("PatientIDz"+selectrow);
		var EpisodeObj=document.getElementById("EpisodeIDz"+selectrow);
		var mradmObj=document.getElementById("mradmz"+selectrow);
		if (PatientObj) PatientID=PatientObj.value;
		if (EpisodeObj) EpisodeID=EpisodeObj.value;
		if (mradmObj) mradm=mradmObj.value ;  
		//
		//
		var DocDr=document.getElementById('DocDr');
		if (DocDr) {var DoctorId=DocDr.value}
		else {var DoctorId=""};
		//
		var obj=document.getElementById('UserID');
		if (obj) {var UserId=obj.value}
		else {var UserId=""};
		//		
		var obj=document.getElementById('LocID');
		if (obj) {var LocId=obj.value}
		else {var LocId=""};
		//
		var AdmDate=document.getElementById("PAAdmDatez"+selectrow).value;
		//alert(AdmDate)
		//Check the Patient is current admit
		if (CheckAdmDate(AdmDate)==false) {
			alert(t['AdmDateOver'])
			return false;
		}
		//
		var SetArrivedStatus=document.getElementById('SetArrivedStatus');
		if (SetArrivedStatus) {var encmeth=SetArrivedStatus.value} else {var encmeth=''};
		var Stat=cspRunServerMethod(encmeth,EpisodeID,DoctorId,LocId,UserId);
		if (Stat!='1')	{
			alert(t['StatusFailure']);
			return false;
		}
		var GetWorkflowID=document.getElementById('GetWorkflowID');
		if (GetWorkflowID) {var encmeth=GetWorkflowID.value} else {var encmeth=''};
		var TWKFL=cspRunServerMethod(encmeth,'DHC EPR OP OrderEntry')
		//
		//if (session['LOGON.GROUPID']=='160')	{  
		//	var lnk="websys.csp?a=a&TMENU=1332&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;
		//} else {
		//	var lnk="websys.csp?TWKFL="+TWKFL+"&TWKFLI=&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;;
		//}
		//
		/*var OutDocEntryMTRFlag=document.getElementById("OutDocEntryMTRFlag").value
		if(OutDocEntryMTRFlag==1){
			var lnk="websys.csp?a=a&TMENU=55139&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;
		}else{
			var lnk="websys.csp?a=a&TMENU=50147&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;
		}*/
		PageJumpControl();
		return false;
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var WinOpenFlagObj=document.getElementById('WinOpenFlag');
	if (WinOpenFlagObj) {var WinOpenFlag=WinOpenFlagObj.value} else {var WinOpenFlag=''};
	if (WinOpenFlag=="1"){
		return	
	}
	if (selectrow !=0) {
		selectedRow=selectrow
		//
		var PatientID="";
		var EpisodeID="";
		var mradm=""
		var PatientObj=document.getElementById("PatientIDz"+selectrow);
		var EpisodeObj=document.getElementById("EpisodeIDz"+selectrow);
		var mradmObj=document.getElementById("mradmz"+selectrow);
		if (PatientObj) PatientID=PatientObj.value;
		if (EpisodeObj) {
			EpisodeID=EpisodeObj.value;
			if (EpisodeID=="") return false;
		}
		if (mradmObj) mradm=mradmObj.value ;  
		//
		//Simulate to click a row for sending Parameter to MENU BAR
		//var frm =parent.frames[0].document.forms["fEPRMENU"];
		//modify by zzq 2010-08-31
		//var frm =parent.frames[0].document.forms["fEPRMENU"];
		var frm=parent.parent.parent.document.forms['fEPRMENU'];

		var frmEpisodeID=frm.EpisodeID;
		var frmPatientID=frm.PatientID;
		var frmmradm=frm.mradm;
		frmPatientID.value=PatientID;
		frmEpisodeID.value=EpisodeID;
		frmmradm.value=mradm;
		
		if (eSrc.id!="") {
			if (!CheckIsAdmissions(EpisodeID)) return false;
		}
		
		//转诊
		//var ReferralObj=document.getElementById("Referralz"+selectrow);
		//if (ReferralObj.checked==true){
		var ReferralLink='Referralz'+selectrow;
		if (eSrc.id==ReferralLink)	{
			var UserID=session['LOGON.USERID'];
			var LocID=session['LOGON.CTLOCID'];
			var tkClass='web.DHCDocOutPatientList';
		  var tkMethod='CheckReferral';
		  var Checkret=tkMakeServerCall(tkClass,tkMethod,LocID);
		  if (Checkret=='NoReferral'){
				alert("您好,您的登陆科室不能转诊");
				return false;
			}
			var Papmino="";
			var PapminoObj=document.getElementById("PAPMINOz"+selectrow);
			if (PapminoObj){
				Papmino=PapminoObj.innerText;
			}
			//alert("Papmino:"+Papmino)
			var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCDoc.Transfer&EpisodeID="+EpisodeID+"&LocID="+LocID+"&UserID="+UserID;
			//var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCDoc.Transfer&Papmino="+Papmino+"&LocID="+LocID+"&UserID="+UserID;
			win=open(lnk,"Referral","status=1,top=80,left=50,width=900,height=490,scrollbars=Yes");
			//ReferralObj.checked=false;
			return false;
		}
		
		
		
		//		//
		var PAPMINameObj=document.getElementById("PAPMINamez"+selectrow);
		var PAPMINOObj=document.getElementById("PAPMINOz"+selectrow);
		var Patient=PAPMINOObj.innerText+' '+PAPMINameObj.innerText;
		var CheckStatus=document.getElementById("CheckStatusz"+selectrow);
		var CalledStatus=document.getElementById('Called'+'z'+selectrow).value;
		var PAPMINameLink='PAPMINamez'+selectrow;
		var SubWaitLink='SubWaitz'+selectrow;
		var ArrivedLink='Arrivedz'+selectrow;
		var SkipNumberLink='SkipNumberz'+selectrow;
		var CancelAdmissLink='CancelAdmissz'+selectrow;
		//
		//Patient Message
		var SeqNo=document.getElementById("LocSeqNoz"+selectrow).innerText;
		var PatNo=PAPMINOObj.innerText;
		var PatName=PAPMINameObj.innerText;
		var RegDoctor=document.getElementById("RegDoctorz"+selectrow).innerText;
		var Room=document.getElementById('RoomDesc').value;
		var AdmDate=document.getElementById("PAAdmDatez"+selectrow).innerText;
		var RegDocDr=document.getElementById("RegDocDrz"+selectrow).value;

		//
		var DocDr=document.getElementById('DocDr');
		if (DocDr) {var DoctorId=DocDr.value}
		else {var DoctorId=""};
		//
		var obj=document.getElementById('UserID');
		if (obj) {var UserId=obj.value}
		else {var UserId=""};
		//		
		var obj=document.getElementById('LocID');
		if (obj) {var LocId=obj.value}
		else {var LocId=""};
		//
		//---------------------------------------------
		//Call a patient
		if (eSrc.id==PAPMINameLink)	{
			//Check the Patient is current admit
			
			//判断上一个患者接口文件是否已处理
			if (InFileIsExist()){
				alert("上一个患者还没有呼叫?A请稍候再呼叫")
				return false
			}
			//
			
			if (CheckAdmDate(AdmDate)==false) {
				alert(t['AdmDateOver'])
				return false;
			}
			DHCAMSCall(EpisodeID);
			return false;
			//If this table have two patients which status are 'Called'
			//Doctor cann't call third patient
			var tbl=document.getElementById("tDHCDocOutPatientList");
			var LineCount=CheckCallStatus(tbl,"1");
			if ((LineCount>=CallSum)&&(CalledStatus!='1'))	
			{
				alert(t['LineCount']+' '+LineCount+t['UOM']);
				return false;				
			}
			//Check Doc Time
			//var CheckDocTime=document.getElementById('CheckDocTime');
			//if (CheckDocTime) {var encmeth=CheckDocTime.value} else {var encmeth=''};
			//var TimeStat=cspRunServerMethod(encmeth,RegDocDr);
			//alert(TimeStat);
			//
			//Call next patient
			//alert(t['CallPatient']+' '+Patient+'......');
			var Ans=confirm(t['CallPatient']+' '+Patient+'......')
			if (Ans==false) {return false;}
			var SetCallStatus=document.getElementById('SetCallStatus');
			if (SetCallStatus) {var encmeth=SetCallStatus.value} else {var encmeth=''};
			var Stat=cspRunServerMethod(encmeth,EpisodeID,DoctorId);
			//
			if (Stat=='101')	{alert(t['HasCalled']);	return false;}
			if (Stat=='0')	{alert(t['StatusFailure']);	return false;}
			if (Stat=='102') {alert(t['HasArrived']);	return false;}
			
			//一次分诊
			if(AllocMode=="S")
			{ 
				var SeqNo=document.getElementById("LocSeqNoz"+selectrow).innerText;
				var PatName=document.getElementById("PAPMINamez"+selectrow).innerText;
				var PatNo=document.getElementById("PAPMINOz"+selectrow).innerText;
			  var PAAdmNo=document.getElementById("PAAdmNoz"+j).innerText;        //dj090401	
				var PAAdmDepCode=document.getElementById("PAAdmDepCodeDRz"+j).innerText;
				var ConsultArea=document.getElementById("ConsultAreaz"+j).innerText; 
			  
				var RegDoctor=document.getElementById("RegDoctorz"+selectrow).innerText;
				var Room=document.getElementById('RoomDesc').value;
				var AdmDate=document.getElementById("PAAdmDatez"+selectrow).innerText;
				var RegDocDr=document.getElementById("RegDocDrz"+selectrow).value;
				var Called=document.getElementById('Calledz'+selectrow).value;
			
				var FilePath=document.getElementById('FilePath').value;
				var RoomCode=document.getElementById('RoomCode').value;
				var FileStr=FilePath+'\\'+RoomCode+'.TXT';
				
				try{
		  		var PatString='0'+','+PAAdmNo+','+SeqNo+','+PatName+','+Room+','+RegDoctor+','+PAAdmDepCode+','+ConsultArea;  //dj090331
	  			fw=fs.CreateTextFile(FileStr, true);
	  			fw.WriteLine(PatString);
	  			fw.Close();
	  		}catch(e){
	  			alert(t['CreateCallFileFail'])
	  		}
	  		
			}
	  		//二次分诊?如果是直接点击病人呼叫?需要置?0?脖曛?表示需要发音
	  		if(AllocMode="M"){	
	  			if(GNextCallStatus=="N")
	  			{
		  			document.getElementById('CheckStatusz'+selectrow).value="0";
		  			
	  			
	  			}else{
		  			if (LineCount>=CallSum)
		  			{
			  			alert("超出呼叫人次,如果需要重复呼叫,请点击病人姓名呼叫!")
			  			GNextCallStatus="N"
			  			return false
		  			}
	  			}
	  			document.getElementById('Calledz'+selectrow).value="1"
	  			SaveToFileMulti(tbl);
	  		}
			var TWKFLobj=document.getElementById("TWKFL");
			if (TWKFLobj) {var TWKFL=TWKFLobj.value;} else {var TWKFL='';}
			if (TWKFL=='')	{
				var lnk="epr.default.csp";
				window.location=lnk;
				return false;
			} else {
				var lnk="websys.csp?TWKFL="+TWKFL+"&TWKFLI=";
				window.location=lnk;
				return false;
			}
			
		}
		//----------------------------------------------
		
		if (eSrc.id==ArrivedLink)	{
			//Check the Patient is current admit
			if (CheckAdmDate(AdmDate)==false) {
				alert(t['AdmDateOver'])
				return false;
			}
			//2006-04-17
			//var PAAdmDoc=document.getElementById("PAAdmDocCodeDRz"+selectrow).innerText;
			var callObj=document.getElementById("callButton");
			if(callObj)
			{
				if(callObj.style.display!="none")
				{
					if (CalledStatus!='1') {
						var StatusDesc=document.getElementById("WalkStatusz"+selectrow).innerText;
						//alert(t['CurrentStatus']+StatusDesc)
						//return false;
					}
				}
			}

			
			//2006-04-17 Mask alert when set a patient arrived
			//alert(Patient+' '+t['HasArrived']);
			var SetArrivedStatus=document.getElementById('SetArrivedStatus');
			if (SetArrivedStatus) {var encmeth=SetArrivedStatus.value} else {var encmeth=''};
			var Stat=cspRunServerMethod(encmeth,EpisodeID,DoctorId,LocId,UserId);
			if (Stat!='1')	{
				alert(t['StatusFailure']);
				return false;
			}
			var GetWorkflowID=document.getElementById('GetWorkflowID');
			if (GetWorkflowID) {var encmeth=GetWorkflowID.value} else {var encmeth=''};
			var TWKFL=cspRunServerMethod(encmeth,'DHC EPR OP OrderEntry')
			//
			//if (session['LOGON.GROUPID']=='160')	{  
			//	var lnk="websys.csp?a=a&TMENU=1332&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;
			//} else {
			//	var lnk="websys.csp?TWKFL="+TWKFL+"&TWKFLI=&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;;
			//}
			//
			/*var OutDocEntryMTRFlag=document.getElementById("OutDocEntryMTRFlag").value
			if(OutDocEntryMTRFlag==1){
				var lnk="websys.csp?a=a&TMENU=55139&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;
			}else{
				var lnk="websys.csp?a=a&TMENU=50147&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;
			}*/
			PageJumpControl();
			//window.location=lnk;
			return false;
		}
		if (eSrc.id==SkipNumberLink) {
			//Check the Patient is current admit
			if (CheckAdmDate(AdmDate)==false) {
				alert(t['AdmDateOver'])
				return false;
			}
			Rtn=confirm(Patient+' '+t['SkipNumberMsg']);
			if (!Rtn){
				return false;
			}
				
			//alert(Patient+' '+t['SkipNumberMsg']);
			var SetSkipStatus=document.getElementById('SetSkipStatus');
			if (SetSkipStatus) {var encmeth=SetSkipStatus.value} else {var encmeth=''};
			var Stat=cspRunServerMethod(encmeth,EpisodeID,DoctorId);
			if (Stat!='1')	{
				alert(t['StatusFailure']);
				return false;
			}
			var TWKFLobj=document.getElementById("TWKFL");
			if (TWKFLobj) {var TWKFL=TWKFLobj.value;} 
			else {var TWKFL='';}
			if (TWKFL=='')	{
				var lnk="epr.default.csp";
				window.location=lnk;
				return false;

			}
			else {
				var lnk="websys.csp?TWKFL="+TWKFL+"&TWKFLI=";
				window.location=lnk;
				return false;
			}			
		}
		if (eSrc.id==CancelAdmissLink) {
			//Check the Patient is current admit
			if (CheckAdmDate(AdmDate)==false) {
				alert(t['AdmDateOver'])
				return false;
			}
			var Rtn=confirm(Patient+' '+t['CancelAdmiss']);
			if (!Rtn){
				return false;
			}
			var CancelAdmissObj=document.getElementById('CancelAdmissMethod');
			if (CancelAdmissObj) {var encmeth=CancelAdmissObj.value} else {var encmeth=''};
			var myrtn=cspRunServerMethod(encmeth,EpisodeID,DoctorId);
			if (myrtn!='0')	{
				if (myrtn=="NoToday"){
					alert(t['CancelAdmissFailure']+',只能取消当日就诊的接诊.');
				}else if (myrtn=="NoAdmiss") {
					alert(t['CancelAdmissFailure']+',未接诊的就诊不能取消.');
				}else if (myrtn=="NoSelf") {
					alert(t['CancelAdmissFailure']+',只能取消本人接诊的就诊记录.');
				}else if (myrtn=="NoInitData") {
					alert(t['CancelAdmissFailure']+',未得到接诊状态改变记录.');
				}else if (myrtn=="InsertFail") {
					alert(t['CancelAdmissFailure']+',队列表记录更新失败.');
				}else if (myrtn=="UpdateAdmDocFail") {
					alert(t['CancelAdmissFailure']+',更新就诊科室与医生失败.');
				}else if (myrtn=="diagnos") {
					alert("患者已经录入诊断或者存在有效的医嘱不可取消接诊!")
				}else if (myrtn=="AddMark") {
					alert("加号患者不能取消接诊!")
				}
				else {
					alert(t['CancelAdmissFailure']);
				}
				return false;
			}else{
				alert(t['CancelAdmissSeccess']);
			}
			return findHandler();
			/*
			var TWKFLobj=document.getElementById("TWKFL");
			if (TWKFLobj) {var TWKFL=TWKFLobj.value;} 
			else {var TWKFL='';}
			if (TWKFL=='')	{
				var lnk="epr.default.csp";
				window.location=lnk;
				return false;

			}else {
				var lnk="websys.csp?TWKFL="+TWKFL+"&TWKFLI=";
				window.location=lnk;
				return false;
			}	
			*/
		}
		
	}
}

function GetIPAddress()	{
			var SetSkipStatus=document.getElementById('SetSkipStatus');
			if (SetSkipStatus) {var encmeth=SetSkipStatus.value} else {var encmeth=''};
			var Stat=cspRunServerMethod(encmeth,EpisodeID);
}

function UnLoadHandler()	{
	alert('Now unload Window!!');
}
//判断是否可以接诊
function CheckIsAdmissions(EpisodeID) {
	if (EpisodeID=="") return false;
	var UserID=session['LOGON.USERID'];
	var ret=tkMakeServerCall("web.DHCDocOutPatientList","CheckIsAdmissions",EpisodeID,UserID);
	if (ret!="") {
		alert("接诊失败,"+ret);
		return false;
	}
	return true;
}

function CheckAdmDate(AdmDate)	{
	//return true;    //when don't need check AdmDate, return true
	var ToDay= new Date();
	var Year=ToDay.getFullYear();
	var Month=ToDay.getMonth();
	Month=Month+1;
	if (Month<10) {Month='0'+Month;}
	var Day=ToDay.getDate();
	if (Day<10) Day='0'+Day;
	if (dtformat=="DMY")  var StrDate=Day+"/"+Month+"/"+Year
	if (dtformat=="YMD")  var StrDate=Year+'-'+Month+'-'+Day
	if (StrDate==AdmDate) {return true}
	else  {return false;}	
}
function SaveToFileMulti(tbl){
	//var tbl=document.getElementById("tDHCDocOutPatientList");
	var row=tbl.rows.length;
	row=row-1; 
	CurCount=0;
	var CallStr=""
	var WaitStr=""
	var SumStr=""
	
	for (var j=1;j<row+1;j++) {
			var SeqNo=document.getElementById("LocSeqNoz"+j).innerText;
			var PatName=document.getElementById("PAPMINamez"+j).innerText;
			var PatNo=document.getElementById("PAPMINOz"+j).innerText;
			var PAAdmNo=document.getElementById("PAAdmNoz"+j).innerText;    //dj090401
			var PAAdmDepCode=document.getElementById("PAAdmDepCodeDRz"+j).innerText;
			var ConsultArea=document.getElementById("ConsultAreaz"+j).innerText;  
		
			var RegDoctor=document.getElementById("RegDoctorz"+j).innerText;
			var Room=document.getElementById('RoomDesc').value;
			var AdmDate=document.getElementById("PAAdmDatez"+j).innerText;
			var RegDocDr=document.getElementById("RegDocDrz"+j).value;
			var Called=document.getElementById('Calledz'+j).value;
			
			var CheckStatus=document.getElementById('CheckStatusz'+j).value;
			if(Called=="1"){CheckStatus="0"}  //dj090401
            else{CheckStatus="1"}
            //alert(CheckStatus)

            if (CheckStatus!="0") (Room="");  //dj090410
			var PatString=CheckStatus+','+PAAdmNo+','+SeqNo+','+PatName+','+Room+','+RegDoctor+','+PAAdmDepCode+','+ConsultArea;  //dj090331
			
			//alert(SeqNo)
			if (Called=="1"){
				if(CallStr=="") 
				{
					CallStr=PatString
				}else{
					CallStr=CallStr+"#"+PatString
				}
			}
			if (Called=="2"){
				if(WaitStr=="") 
				{
					WaitStr=PatString
				}else{
					WaitStr=WaitStr+"#"+PatString
				}
			}
	}
	

		if((WaitStr!="")&&(CallStr!="")){SumStr=CallStr+"#"+WaitStr}
		if((WaitStr=="")&&(CallStr!="")){SumStr=CallStr}
		if((WaitStr!="")&&(CallStr=="")){SumStr=WaitStr}
		
		IPAddress=document.getElementById('IPAddress').value;
		var FilePath=document.getElementById('FilePath').value;
		var RoomCode=document.getElementById('RoomCode').value;
    
    try{
			if((FilePath!="")&(SumStr!="")){
				var FileStr=FilePath+'\\'+IPAddress+'.TXT';
					
		  		fw=fs.CreateTextFile(FileStr, true);
		  		fw.WriteLine(SumStr);
		  		fw.Close();
			}
		}catch(e){
			alert(t['CreateCallFileFail']);
		}	
}
function InFileIsExist(){
			var IPAddress=document.getElementById('IPAddress').value;
			var FilePath=document.getElementById('FilePath').value;
			var RoomCode=document.getElementById('RoomCode').value;
			if(AllocMode=="S"){
				var FileStr=FilePath+'\\'+RoomCode+'.TXT';
			}
			if(AllocMode=="M"){
				var FileStr=FilePath+'\\'+IPAddress+'.TXT';
			}
			var fso=new ActiveXObject('Scripting.FileSystemObject');  
			if(fso.FileExists(FileStr)) {
			 var Rtn=true
			}else{
			 var Rtn=false
			}
			return Rtn
}
function NewCallPatient()	{
	var nextButtonJs=document.getElementById('nextButtonJs');
	if (nextButtonJs) {var encmeth=nextButtonJs.value} else {var encmeth=''};
	var IPAddress=GetComputerIp()
	if((IPAddress!="Exception")&&(IPAddress!=""))
	{
		var alertCode=cspRunServerMethod(encmeth,"","",IPAddress)
	}
	else
	{
	  var alertCode=cspRunServerMethod(encmeth)
	}
	}
function ReCallPatient()	{
	var recall=document.getElementById('recall');
	if (recall) {var encmeth=recall.value} else {var encmeth=''};
	var IPAddress=GetComputerIp()
	if((IPAddress!="Exception")&&(IPAddress!=""))
	{
		var alertCode=cspRunServerMethod(encmeth,"","",IPAddress)
	}
	else
	{
	  var alertCode=cspRunServerMethod(encmeth)
	}
	}
function DHCAMSCall(EpisodeID)
{
	if(EpisodeID=="Exception")
	{
		alert("没有选择病人!");
		return;
	}
	var frontCall=document.getElementById('frontCall');
	if (frontCall) {var encmeth=frontCall.value} else {var encmeth=''};
	var IPAddress=GetComputerIp()
	if((IPAddress!="Exception")&&(IPAddress!=""))
	{
		var alertCode=cspRunServerMethod(encmeth,EpisodeID,"","",IPAddress)
	}
	else
	{
	  var alertCode=cspRunServerMethod(encmeth,EpisodeID)
	}
}
function GetComputerIp()
{
	var ipAddr;
	try
	{
	   var obj = new ActiveXObject("rcbdyctl.Setting");
	   ipAddr=obj.GetIPAddress;
	   obj = null;
	}
	catch(e)
	{
	   alert("Exception");
	}
	return ipAddr;
}
document.body.onload=ListDocCurrentLoadHandler;
document.body.onunload=UnLoadHandler;

function CheckLinkDetails(lnk,newwin) {
	//alert("Check Deceased");
	//var frm =parent.frames[0].document.forms["fEPRMENU"];
	var frm=parent.parent.parent.document.forms['fEPRMENU'];
	var EID=frm.EpisodeID.value;
	if(isNaN(EID)){
		alert(t['NoEpisode']);
		return;
	}

	if (frm.EpisodeID.value == "") {
		alert(t['NoEpisode']);
		return;
	}
	
	var pattern=new RegExp("Y","i");
	if (pattern.test(frm.Decease.value)) {
		var choice3=confirm(t['PAT_DECEASED'])
		if(choice3==false) return;
	}
	//PassDetails(lnk,newwin);
	PassDetails(lnk,newwin);
}
function PassDetails(lnk,newwin) {
	var frm = parent.frames[0].document.forms["fEPRMENU"];
	if (frm.MultipleIDs.value) lnk += "&TWKFLL="+frm.MultipleIDs.value;
	lnk += "&PatientID="+frm.PatientID.value + "&EpisodeID="+frm.EpisodeID.value + "&mradm="+frm.mradm.value;

	if (frm.WaitingListID.value) lnk += "&WaitingListID=" + frm.WaitingListID.value;
	if (frm.WardID.value) lnk += "&WardID="+frm.WardID.value;
	if (frm.PAAdmCodingID.value) lnk += "&PAAdmCodingID=" + frm.PAAdmCodingID.value;
	if (frm.MultiEpisodeID.value) lnk += "&MultiEpisodeID=" + frm.MultiEpisodeID.value;
	if (frm.OEOrdItemID.value) lnk+= "&OEOrdItemID=" + frm.OEOrdItemID.value;
	if (frm.apptID.value) lnk+= "&apptID=" + frm.apptID.value;
	if (frm.OperRoomID.value) lnk+= "&OperRoomID=" + frm.OperRoomID.value;
	if (frm.NokID.value) lnk+= "&NokID=" + frm.NokID.value;	//cjb 22/02/2006 56793
	if (frm.AnaesthesiaID.value) lnk+= "&AnaesthesiaID=" + frm.AnaesthesiaID.value; //TN:58239

	//shouldn't need to pass codes nor desc nor flags, just ids
	//for backwards compatibilty keep these 3, but no more should be added
	if (frm.WLWaitListStatusDR.value) lnk += "&WLWaitListStatusDR=" + frm.WLWaitListStatusDR.value; //rqg,log25929
	if (frm.SinglePatientFlag.value) lnk += "&SinglePatientFlag=" + frm.SinglePatientFlag.value;
	if (frm.ARCIMDesc.value) lnk += "&ARCIMDesc=" + frm.ARCIMDesc.value;

	//alert(lnk);
	if (newwin == "TRAK_hidden")
		top.frames["TRAK_hidden"].location = lnk;
	else if (newwin != "")
		websys_lu(lnk,0,newwin);
	else
		top.frames["TRAK_main"].location = lnk;
}
function LookupSelect(str){
	var surname=document.getElementById("SurName")
	if ((str.split("^").length>0)&&surname)
	surname.value=str.split("^")[4];
}
///获取响应事件的对象
function GetEventElementObj(){
	var isIE=document.all ? true : false;  
	var obj = null;  
	if(isIE==true){  
		obj = document.elementFromPoint(event.clientX,event.clientY);  
	}else{  
		e = arguments.callee.caller.arguments[0] || window.event;   
		obj = document.elementFromPoint(e.clientX,e.clientY);  
	}
	return obj
}
function PageJumpControl(){
	var PatientID="";
	var EpisodeID="";
	var mradm=""
	var PatientObj=document.getElementById("PatientIDz"+selectedRow);
	var EpisodeObj=document.getElementById("EpisodeIDz"+selectedRow);
	var mradmObj=document.getElementById("mradmz"+selectedRow);
	if (PatientObj) PatientID=PatientObj.value;
	if (EpisodeObj) EpisodeID=EpisodeObj.value;
	if (mradmObj) mradm=mradmObj.value ; 
	var PageCheckMutually="OutDocEntryMTR^NewOutPatList"
	var PageCheckMutuallyArry=PageCheckMutually.split("^")
	var find=0
	for (var i=0;i<PageCheckMutuallyArry.length;i++){
		var value=tkMakeServerCall("web.DHCDocConfig","GetConfigNode1",PageCheckMutuallyArry[i],session['LOGON.GROUPID']);
		if(value==1){
			if(PageCheckMutuallyArry[i]=="OutDocEntryMTR"){
				find=1
				var lnk="websys.csp?a=a&TMENU=55139&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;
			}
			if(PageCheckMutuallyArry[i]=="NewOutPatList"){
				find=1
				var lnk="websys.csp?a=a&TMENU=56395&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;
			}
		}
	}
	if(find==0){
	  var lnk="websys.csp?a=a&TMENU=50147&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;
	}

    window.location=lnk;
}