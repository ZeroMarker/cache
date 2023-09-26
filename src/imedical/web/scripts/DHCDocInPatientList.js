var ComponentID="";
var PACWard;
var m_PatientNoLength=8;
if (document.getElementById("PatientNoLen")){
	m_PatientNoLength=document.getElementById("PatientNoLen").value;
}
var fso = new ActiveXObject("WScript.NetWork");
var fs = new ActiveXObject("Scripting.FileSystemObject");

function findHandler() {
	var eSrc=window.event.srcElement;
	var srcId=eSrc.id;
	var ArrivedQueobj=document.getElementById("ArrivedQue");
	var MedUnitobj=document.getElementById("MedUnit");
	if (ArrivedQueobj&&MedUnitobj){
		if (srcId=="ArrivedQue"){
			if (MedUnitobj.checked==true)MedUnitobj.checked=false;
		}
		if (srcId=="MedUnit"){
			if (ArrivedQueobj.checked==true)ArrivedQueobj.checked=false;
		}
	}
	
	return Find_click();
}
function SetPACWardList(text,value){
	var obj=document.getElementById("PACWard");
	if (obj){
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option(text,value);
	}
}
function PACWardListChanged(e){
	
	var WardID=websys_getSrcElement(e).value;
	var myoptval=DHCWeb_GetListBoxValue("PACWard");
	var ret=tkMakeServerCall("web.DHCDocInPatientList","GetPACWardDescById",myoptval);
	var PACWardDescobj=document.getElementById("PACWardDesc")
	if (PACWardDescobj) PACWardDescobj.value=ret
    document.getElementById("Bed").value=""
    document.getElementById("BedId").value=""
	
	if (WardID!="" ) {
		//Find_click();
	}
}
///add in BJXHYY 初始化科室病房下拉列表
function InitPACWard() {
	var WardID="";
  var obj=document.getElementById("WardID");
  if (obj) WardID=obj.value;
  
	var cobj=document.getElementById("CheckWard");
	if(cobj)  cobj.onclick=DisableWardList;
	
	var obj=document.getElementById("PACWard");
	if (obj) {
		obj.onchange=PACWardListChanged;
		CTLOCID=session['LOGON.CTLOCID'];
		
		
	var getlistCount=document.getElementById("wardListCount");
	if(getlistCount) 	{var encmeth=getlistCount.value} else {var encmeth=''};
	if (encmeth!="") {
	var count=cspRunServerMethod(encmeth,session['LOGON.CTLOCID'])
	
	 if(count==1) {
		 obj.style.display="none";
		 cobj.style.display="none";
		 lobj=document.getElementById("cPACWard")
		  if(lobj){		 
		   lobj.style.display="none";
		  }	
        return;		  
		 }
      }
		
		
		obj.multiple=false;
		obj.size=1
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option("","");
		var GetPrescList=document.getElementById("GetPACWard") //为调用后台查询数值的方法。
		if (GetPrescList) {var encmeth=GetPrescList.value} else {var encmeth=''};
		if (encmeth!="") var WardID=cspRunServerMethod(encmeth,'SetPACWardList',CTLOCID)
		if (WardID=="") {
			if (cobj) cobj.checked=false;
			obj.value="";
			obj.disabled=true;
		}else{	
			//DHCC_SelectOptionByValue("PACWard",WardID);
		}		
	}
}

function ListDocCurrentLoadHandler() {
	
	InitPACWard()
	//
	var obj=document.getElementById("ReadCard");
	if(obj) obj.onclick=ReadCard_Click;
	//
	var obj=document.getElementById("MRRequest");
	if(obj) obj.onclick=MRRequestOnClick;
	//
	var obj=document.getElementById("PatientNo");
	if(obj) obj.onkeydown=PatientNoCheck;
	SetPatientNoLen();
	//
	var obj=document.getElementById("NextPatient");
	if(obj) obj.onclick=CallNextPatient;
	//
	var obj=document.getElementById("Find");
	if(obj) obj.onclick=findHandler;
	//
	var obj=document.getElementById("ArrivedQue");
	if(obj) obj.onclick=findHandler;
	//
	var obj=document.getElementById("MedUnit");
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
	var obj=document.getElementById("Bed");
	if(obj) obj.onpropertychange=Bed_Change;
	
	var obj=document.getElementById("ld55177iBed");
	if(obj) obj.onclick=Bed_OnKeyPress;
	
	
	//
	var tbl=document.getElementById("tDHCDocInPatientList");
	if(tbl) tbl.ondblclick=DHC_SelectPat;
	//
	//ColorTblColumn(tbl,'PAAdmReasonCode','PAAdmReason');
	//CheckQuePriority(tbl);
	//CheckCallStatus(tbl);	
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
}
	
function SetPatientNoLen(){
	var Obj=document.getElementById("PatientNoLen");
	if (Obj)m_PatientNoLength=Obj.value;
}
function ReadCard_Click()
{
	var myrtn=DHCACC_GetAccInfo();
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0":
			///rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			var obj=document.getElementById("PatientNo");
			if(obj) obj.value=myary[5];
			Find_click()
			break;
		case "-200":
			alert(t["alert:cardinvalid"]);
			break;
		case "-201":alert(t["alert:cardvaliderr"])
		default:
	}
	
}

function MRRequestOnClick(){
	var tbl=document.getElementById("tDHCDocInPatientList");
	var selectrow=GetSelectRow(tbl)
	var PatientID=""
	var EpisodeID=""
	if (!selectrow) return;
	if (selectrow !=0) {
		var PatientID="";		
		var EpisodeID="";
		var mradm=""
		var PatientObj=document.getElementById("PatientIDz"+selectrow)
		PatientID=PatientObj.value
		var EpisodeObj=document.getElementById("EpisodeIDz"+selectrow);
		EpisodeID=EpisodeObj.value
		var PAPMINameObj=document.getElementById("PAPMINamez"+selectrow);
		PAPMIName=PAPMINameObj.innerText
	}
		UserId=session['LOGON.USERID']
		
		if (!confirm(PAPMIName+" "+t['Confirm:MRRequest'])) {
      		return
   		}
		//alert(EpisodeID+","+PatientID+","+UserId+","+PAPMIName)
			
		var GetDetail=document.getElementById('GetMethodMRRequest');
		if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
		var RetCode=cspRunServerMethod(encmeth,PatientID,EpisodeID,UserId)
		if (RetCode=="-1"){
			alert(t["ResaultDup:MRRequest"])
			return
		}
		if (RetCode=="-2"){
			alert(t["ResaultFail:MRRequest"])
			return
		}
		if (RetCode=="0"){
			alert(t["ResaultNull:MRRequest"])
			return
		}
		alert(t["ResaultSuccess:MRRequest"])	
		
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

function ColorTblColumn(tbl,ColName1,ColName2)	{
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
		var sLable1=document.getElementById(ColName1+'z'+j);
		var sLable2=document.getElementById(ColName2+'z'+j);
		var sTD2=sLable2.parentElement;
		var PatType=sLable1.value;
		if (PatType=='Govement') {sTD2.className="Govement"};
		if (PatType=='Insurance') {sTD2.className="Insurance"};
		if (PatType=='Private') {sTD2.className="Private"};
		//
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
function CheckCallStatus(tbl)	{
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
			if (Called.value=="1")	{
				CurRow.className='clsRowCalled';
				CurCount=CurCount+1;
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
		var GetQueDoc=document.getElementById('GetQueDoc');
		if (GetQueDoc) {var encmeth=GetQueDoc.value} else {var encmeth=''};
		var QueDoc=cspRunServerMethod(encmeth,EpisodeID)
		if ((QueDoc=="")||(QueDoc==" ")) {
			return j;}
		else  {
			if ((QueDoc!="")&&(WalkStatus.value=='01')&&(Called.value==""))	{
				return j;
			}
		}
	}
	return false;
}

function CallNextPatient()	{
	var tbl=document.getElementById("tDHCDocEmergencyPatientList");
	if(tbl) {var NextRow=GetNextRow(tbl);} else {var NextRow=0}
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
	if (((type=='keypress')&&(key==13))||((type=='click'))) {
		var url='websys.lookup.csp';
		url += "?ID=d"+ComponentID+"iBed";
		url += "&CONTEXT=Kweb.PACBed:FindAllBInWardRes";
		url += "&TLUJSF=BedSelect";
		///PACWardDesc,CurrentWard,Bed,'','','','','','',AdmType,ClinicalDept
		///lxz INBED描述中传入INBED查询的是已经被使用的床位
		var obj=document.getElementById('PACWardDesc');
		if (obj){if(obj.value==""){alert("请选择相应的病房.!");return;}}
		if (obj) url += "&P1=" + websys_escape(obj.value+"^"+"INBED");
		var obj=document.getElementById('CurrentWard');
		if (obj) url += "&P2=" + websys_escape(obj.value);	
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
		var PatientID="";		
		var EpisodeID="";
		var mradm=""
		var PatientObj=document.getElementById("PatientIDz"+selectrow);
		var EpisodeObj=document.getElementById("EpisodeIDz"+selectrow);
		var mradmObj=document.getElementById("mradmz"+selectrow);
		var SelectObj=document.getElementById("Selectz"+selectrow);
		var StatusObj=document.getElementById("WalkStatusz"+selectrow);
		//
		//Simulate to click a row for sending Parameter to MENU BAR
		//modify by wuqk 2010-06-02
		//var frm =top.document.forms["fEPRMENU"]; //parent.frames[0].document.forms["fEPRMENU"];
		//modify by zzq 2010-08-31
		var frm =dhcsys_getmenuform();
		var frmEpisodeID=frm.EpisodeID;
		var frmPatientID=frm.PatientID;
		var frmmradm=frm.mradm;
		if (PatientObj) frmPatientID.value=PatientObj.value;
		if (EpisodeObj) frmEpisodeID.value=EpisodeObj.value;
		if (mradmObj) frmmradm.value=mradmObj.value ;  
		//
		var GetWorkflowID=document.getElementById('GetWorkflowID');
		if (GetWorkflowID) {var encmeth=GetWorkflowID.value} else {var encmeth=''};
		var TWKFL=cspRunServerMethod(encmeth,'DHC EPR IP OrderEntry')
		//alert(SelectObj.id+'  '+SelectObj.checked);
		if (SelectObj.checked)	{
			//
			//var AdmDate=document.getElementById("PAAdmDatez"+selectrow).innerText
			//if (CheckAdmDate(AdmDate)==false) {
			//	alert(t['AdmDateOver'])
			//	return;
			//}
			//var StatusCode=document.getElementById("StatusCodez"+selectrow).value;
			//if ((StatusCode=='02')||(StatusCode=='03')) {
			//	var StatusDesc=document.getElementById("WalkStatusz"+selectrow).innerText;
			//	alert(t['CurrentStatus']+StatusDesc)
			//	return;
			//}
			//
			if (PatientObj) PatientID=PatientObj.value;
			if (EpisodeObj) EpisodeID=EpisodeObj.value;
			if (mradmObj) mradm=mradmObj.value ;  

			var lnk="websys.csp?a=a&TMENU=51627&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;
			//var lnk="websys.csp?TWKFL="+TWKFL+"&TWKFLI=&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;;
			window.location=lnk;
		}
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
		var tbl=document.getElementById("tDHCDocEmergencyPatientList");
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
		var AdmDate=document.getElementById("PAAdmDatez"+selectrow).innerText;
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
		var lnk="websys.csp?TWKFL="+TWKFL+"&TWKFLI=&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;;
		window.location=lnk;
		return false;
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow !=0) {
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
		//Simulate to click a row for sending Parameter to MENU BAR
		//modify by wuqk 2010-06-02
		//var frm =top.document.forms["fEPRMENU"]; //parent.frames[0].document.forms["fEPRMENU"];
		//modify by zzq 2010-08-31
		var frm =dhcsys_getmenuform();
		var frmEpisodeID=frm.EpisodeID;
		var frmPatientID=frm.PatientID;
		var frmmradm=frm.mradm;
		frmPatientID.value=PatientID;
		frmEpisodeID.value=EpisodeID;
		frmmradm.value=mradm; 
		//		//
		var PAPMINameObj=document.getElementById("PAPMINamez"+selectrow);
		var PAPMINOObj=document.getElementById("PAPMINOz"+selectrow);
		var Patient=PAPMINOObj.innerText+' '+PAPMINameObj.innerText;
		///var CheckStatus=document.getElementById("CheckStatusz"+selectrow);
		///var CalledStatus=document.getElementById('Called'+'z'+selectrow).value;
		var PAPMINameLink='PAPMINamez'+selectrow;
		///var ArrivedLink='Arrivedz'+selectrow;
		///var SkipNumberLink='SkipNumberz'+selectrow;
		//
		//Patient Message
		///var SeqNo=document.getElementById("LocSeqNoz"+selectrow).innerText;
		var PatNo=PAPMINOObj.innerText;
		var PatName=PAPMINameObj.innerText;
		///var RegDoctor=document.getElementById("RegDoctorz"+selectrow).innerText;
		///var Room=document.getElementById('RoomDesc').value;
		var AdmDate=document.getElementById("PAAdmDatez"+selectrow).innerText;
		///var RegDocDr=document.getElementById("RegDocDrz"+selectrow).value;
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
		/*
		if (eSrc.id==PAPMINameLink)	{
			//Check the Patient is current admit
			///if (CheckAdmDate(AdmDate)==false) {
			///	alert(t['AdmDateOver'])
			///	return false;
			///}
			//If this table have two patients which status are 'Called'
			//Doctor cann't call third patient
			///var tbl=document.getElementById("tDHCDocEmergencyPatientList");
			///var LineCount=CheckCallStatus(tbl);
			///if ((LineCount>=2)&&(CalledStatus!='1'))	{
			///	alert(t['LineCount']+' '+LineCount+t['UOM']);
			///	return false;				
			///}
			//Check Doc Time
			//var CheckDocTime=document.getElementById('CheckDocTime');
			//if (CheckDocTime) {var encmeth=CheckDocTime.value} else {var encmeth=''};
			//var TimeStat=cspRunServerMethod(encmeth,RegDocDr);
			//alert(TimeStat);
			//
			//Call next patient
			//alert(t['CallPatient']+' '+Patient+'......');
			////var Ans=confirm(t['CallPatient']+' '+Patient+'......')
			////if (Ans==false) {return false;}
			///var SetCallStatus=document.getElementById('SetCallStatus');
			///if (SetCallStatus) {var encmeth=SetCallStatus.value} else {var encmeth=''};
			///var Stat=cspRunServerMethod(encmeth,EpisodeID,DoctorId);
			//
			///if (Stat=='101')	{alert(t['HasCalled']);	return false;}
			///if (Stat=='0')	{alert(t['StatusFailure']);	return false;}
			///if (Stat=='102') {alert(t['HasArrived']);	return false;}
			//
			///var FilePath=document.getElementById('FilePath').value;
			///var RoomCode=document.getElementById('RoomCode').value;
			///var FileStr=FilePath+'\\'+RoomCode+'.TXT';
			//-------------------------------------------
		  	///var PatString='0'+','+PatNo+','+SeqNo+','+PatName+','+Room+','+RegDoctor;
	  		///fw=fs.CreateTextFile(FileStr, true);
	  		///fw.WriteLine(PatString);
	  		///fw.Close();
	  		//
			///var TWKFLobj=document.getElementById("TWKFL");
			///if (TWKFLobj) {var TWKFL=TWKFLobj.value;} else {var TWKFL='';}
			///if (TWKFL=='')	{
			///	var lnk="epr.default.csp";
			///	window.location=lnk;
			///	return false;
			///} else {
			///	var lnk="websys.csp?TWKFL="+TWKFL+"&TWKFLI=";
			///	window.location=lnk;
			///	return false;
			///}
			///
			///var StatusDesc=document.getElementById("WalkStatusz"+selectrow).innerText;
			///alert(t['CurrentStatus']+StatusDesc)
			///	return false;
			
			//2006-04-17 Mask alert when set a patient arrived
			//alert(Patient+' '+t['HasArrived']);
			//var SetArrivedStatus=document.getElementById('SetArrivedStatus');
			//if (SetArrivedStatus) {var encmeth=SetArrivedStatus.value} else {var encmeth=''};
			//var Stat=cspRunServerMethod(encmeth,EpisodeID,DoctorId,LocId,UserId);
			//if (Stat!='1')	{
			//	alert(t['StatusFailure']);
			//	return false;
			//}
			//var GetWorkflowID=document.getElementById('GetWorkflowID');
			//if (GetWorkflowID) {var encmeth=GetWorkflowID.value} else {var encmeth=''};
			//var TWKFL=cspRunServerMethod(encmeth,'DHC EPR IP OrderEntry')
			//
			var lnk="websys.csp?a=a&TMENU=51627&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;
			//var lnk="websys.csp?TWKFL="+TWKFL+"&TWKFLI=&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;;
			window.location=lnk;
			return false;
		}
		*/
		//----------------------------------------------
		//
		//if (eSrc.id==ArrivedLink)	{
		//	//Check the Patient is current admit
		//	if (CheckAdmDate(AdmDate)==false) {
		//		alert(t['AdmDateOver'])
		//		return false;
		//	}
		//	//2006-04-17
		//	var PAAdmDoc=document.getElementById("PAAdmDocCodeDRz"+selectrow).innerText;
		//	if ((PAAdmDoc=='')||(PAAdmDoc==' ')) {
		//		var StatusDesc=document.getElementById("WalkStatusz"+selectrow).innerText;
		//		alert(t['CurrentStatus']+StatusDesc)
		//		return false;
		//	}
		//	
		//	//2006-04-17 Mask alert when set a patient arrived
		//	//alert(Patient+' '+t['HasArrived']);
		//	var SetArrivedStatus=document.getElementById('SetArrivedStatus');
		//	if (SetArrivedStatus) {var encmeth=SetArrivedStatus.value} else {var encmeth=''};
		//	var Stat=cspRunServerMethod(encmeth,EpisodeID,DoctorId,LocId,UserId);
		//	if (Stat!='1')	{
		//		alert(t['StatusFailure']);
		//		return false;
		//	}
		//	var GetWorkflowID=document.getElementById('GetWorkflowID');
		//	if (GetWorkflowID) {var encmeth=GetWorkflowID.value} else {var encmeth=''};
		//	var TWKFL=cspRunServerMethod(encmeth,'DHC EPR OP OrderEntry')
		//	//
		//	var lnk="websys.csp?TWKFL="+TWKFL+"&TWKFLI=&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;;
		//	window.location=lnk;
		//	return false;
		//}
		/*
		if (eSrc.id==SkipNumberLink) {
			//Check the Patient is current admit
			if (CheckAdmDate(AdmDate)==false) {
				alert(t['AdmDateOver'])
				return false;
			}
			alert(Patient+' '+t['SkipNumber']);
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
		*/			
	}
}

function GetIPAddress()	{
			var SetSkipStatus=document.getElementById('SetSkipStatus');
			if (SetSkipStatus) {var encmeth=SetSkipStatus.value} else {var encmeth=''};
			var Stat=cspRunServerMethod(encmeth,EpisodeID);
}

function UnLoadHandler()	{
	//alert('Now unload Window!!');
}

function CheckAdmDate(AdmDate)	{
	//return true;    //when don't need check AdmDate, return true
	var ToDay= new Date();
	var Year=ToDay.getYear();
	var Month=ToDay.getMonth();
	Month=Month+1;
	if (Month<10) {Month='0'+Month;}
	var Day=ToDay.getDate();
	if (Day<10) Day='0'+Day;
	var StrDate=Year+'-'+Month+'-'+Day
	if (StrDate==AdmDate) {return true}
	else  {return false;}	
}
function DisableWardList(e){	
	var obj=document.getElementById("PACWard");
	if (obj) {
		if (!websys_getSrcElement(e).checked) {
			obj.disabled=true;
			obj.value=""; 

		}else{
			obj.disabled=false;
			var ArrivedQueobj=document.getElementById("ArrivedQue");
			var MedUnitobj=document.getElementById("MedUnit");
			if (ArrivedQueobj) ArrivedQueobj.checked=false;
			if (MedUnitobj) MedUnitobj.checked=false;
		}
	}	
}
//lxz 床位
function BedSelect(Str)
{
	if (Str!=""){
	var StrArry=Str.split("^")
	var BedIDObj=document.getElementById("BedId");
	if (BedIDObj){BedIDObj.value=StrArry[5]}
	}
}
function Bed_Change()
{
	var obj=document.getElementById("Bed");
	if (obj){
		if (obj.value=="")
		{
		 var BedIDObj=document.getElementById("BedId");
		 if (BedIDObj){BedIDObj.value=""}
		}
	}
	
	}
document.body.onload=ListDocCurrentLoadHandler;
document.body.onunload=UnLoadHandler;

