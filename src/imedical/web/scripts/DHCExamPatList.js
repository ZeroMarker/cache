//document.write("<object ID='ClsDHCPrint' WIDTH=0 HEIGHT=0 CLASSID='CLSID:FDBE454C-918A-4DEC-BFA6-1A797E3CAC9A' CODEBASE='../addins/client/DHCOPRegTMPrint.CAB#version=1,0,0,0'>");
//document.write("</object>");

var GSelectAdmRowid="" 
var SelectedRow=0
function DocumentLoadHandler() {
	
	//ѡ��һ��
	var Obj=document.getElementById('tDHCExamPatList');
	if(Obj)Obj.ondblclick=AdmSearchDBClickHander;
	//�����ӡ
	var obj=document.getElementById("Print");
	if (obj){
		obj.onclick=Export_Click;
	}
	
	
	var RegNoObj=document.getElementById('PatNo');
	if (RegNoObj) RegNoObj.onkeydown = RegNoObj_keydown;
	var obj=document.getElementById("CardNo")
	if(obj) obj.onkeydown=CardNoKeydownHandler;
	var Obj=document.getElementById('PatMed');
	if (Obj) Obj.onkeydown = PatMedicare_keydown;
	var Obj=document.getElementById('ReadCard');
	if (Obj) Obj.onclick = ReadCardHandle;
	var Obj=document.getElementById('ReadCardApp');
	if (Obj) Obj.onclick = ReadCardAppHandle;
	obj=document.getElementById("WardDesc");
    if(obj) obj.onkeydown=GetWard;  
	var cobj=document.getElementById("InStatus");
	cobj.onclick=DisablInStatus;
	
	var cobj=document.getElementById("InStatus");
	cobj.onclick=DisablInStatus;
	var myObj=document.getElementById("InStatusFlag");
	if(myObj){myObj.value=0}
	if (cobj.checked){myObj.value=1}
	var cobj=document.getElementById("OutStatus");
	cobj.onclick=DisablOutStatus;
	var myObj=document.getElementById("OutStatusFlag");
    if(myObj){myObj.value=0}
    if (cobj.checked){myObj.value=1}
	var cobj=document.getElementById("DisInStatus");
	cobj.onclick=DisablDisInStatus;
	var myObj=document.getElementById("DisInStatusFlag");
	if(myObj){myObj.value=0}
	if (cobj.checked){myObj.value=1}
	
	var  wardObj=document.getElementById("WardDesc");
	if (wardObj) {
	wardObj.onchange=WardDescChangeHanler;	
	}
	var  obj=document.getElementById("CTLoc");
	if (obj) {
		obj.onchange=CTLocChangeHanler;	
	}
	var obj=document.getElementById("AdmDoc");
	if (obj){
		obj.onchange=AdmDocChangeHanler;	
	}
	
	var myobj=document.getElementById('CardTypeDefine');
	if (myobj){
		myobj.onchange=CardTypeDefine_OnChange;
		myobj.size=1;
		myobj.multiple=false;
	}
	loadCardType()
	CardTypeDefine_OnChange()
	
	var Obj=document.getElementById("Find");
	if (Obj) {
	Obj.onclick=FindClickHandler;
	
	}
	var obj=document.getElementById('Name');
	if(obj) {
		//obj.onkeydown=PatName_keydown;
		obj.onblur=function(){
		 var patNO=document.getElementById('PatNo').value;
		 var wardDesc=document.getElementById("WardDesc").value;
		 var name=document.getElementById('Name').value;
		 if ((patNO=="")&&(name!="")&&(wardDesc=="")) {
		   /*if(!websys_$V("OutStatus").checked){
				alert(t['selectWard']);
			}*/
		 
		 }
	}
	
	}
	var obj=document.getElementById("clear");
	if (obj) {
	    obj.onclick=function ()	{
		  var obj=document.getElementById("FindFlag");
		  if (obj){
			 obj.value="";
		  }
		  var obj=document.getElementById('CardNo');
	      obj.value="";
	      var obj=document.getElementById('Name');
	      obj.value="";
	      obj=document.getElementById("PatNo");
	      obj.value="";
	      obj=document.getElementById("PatMed")
	      obj.value="";
	      obj=document.getElementById("Sex");
	      obj.value="";
	      obj=document.getElementById("Birth");
	      obj.value="";
	      obj=document.getElementById("WardDesc");
	      obj.value="";
	      obj=document.getElementById("WardID");
	      obj.value="";
	      obj=document.getElementById("CTLoc");
	      obj.value="";
	      obj=document.getElementById("luloc");
	      obj.value="";
	      obj=document.getElementById("PAAdmRowId");
	      obj.value="";
	      obj=document.getElementById("OutStatus");
	      obj.checked=false;
	      obj=document.getElementById("InStatus");
	      obj.checked=false;
	      obj=document.getElementById("DisInStatus");
	      obj.checked=false;
	      obj=document.getElementById("AdmDoc");
	      obj.value="";
	      obj=document.getElementById("AdmDocId");
	      obj.value="";
          SetDefaultDate();
		  var objtbl=document.getElementById("tDHCExamPatList");
		  if (objtbl){
				var rows=objtbl.rows.length;
				var lastrowindex=rows-1;
				for (var j=0;j<lastrowindex;j++) {objtbl.deleteRow(1);}
				if (lastrowindex>=1){
					var objtbody=tk_getTBody(objtbl.rows[1]);
					DHCC_ClearTableRow(objtbl.rows[1]);
					tk_ResetRowItems(objtbody);
				}
				
		  }
	      return false;	      
	    }
	}

	 var objName=document.getElementById('Name');
	 var objPatNo=document.getElementById("PatNo");
	 var objWard=document.getElementById("WardDesc");
	 var objWardID=document.getElementById("WardID");
    if  ((objName.value=="")&&(objPatNo.value=="")&&(objWard.value=="")) {
	var rtn="";
	var encmeth=document.getElementById("GetDefaultWard").value;
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"","","");
		if (rtn!="") {
		objWard.value=rtn.split("^")[0];
		objWardID.value=rtn.split("^")[1];
		
		}
	 }
	}
	var PatMed=document.getElementById("PatMed");
	if ((session['LOGON.GROUPDESC']=='������ʿ')&&(PatMed)){
		PatMed.focus();
	}
	SetRedColor();
	var myobj=document.getElementById("luloc")
	if ((myobj)&&(myobj.value!="")&&(objWardID.value="")) {
		var obj=document.getElementById("WardDesc")
		if(obj){
			obj.value=""
			document.getElementById("WardID").value="";
		}
		AddWardDesc(myobj.value);
	}
}

function SetDefaultDate(){
	var DefaultDate=DHCC_GetElementData("DefaultDate");
	if (DefaultDate!=""){
		//var AppDate=DefaultAppDate.substring(0,8);
		DHCC_SetElementData('Startdate',DefaultDate)
		DHCC_SetElementData('Enddate',DefaultDate)
	}	
}

function SetRedColor(){
	var table=websys_$("tDHCExamPatList");
	var row=table.rows;
	var Length=table.rows.length;
	for(var i=0;i<Length;i++){
	   var SeeDoctor=websys_$("SeeDoctorz"+i);
	   if(SeeDoctor){
	     if(SeeDoctor.innerHTML=="δ����"){
			SeeDoctor.style.color='red';
            SeeDoctor.style.fontWeight='bold';			
		 }
	   }
	}
}
function FindPatInfoByName(){
	var Name=document.getElementById('Name');
	if(Name){							   
		var GetDetail=document.getElementById('GetMethodByPatName');
		if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
		if(encmeth!=""){
			var PatNoStr=cspRunServerMethod(encmeth,Name.value)
			if (PatNoStr!=""){
				var Str=""
				var Str=PatNoStr.split("^")
				if (Str.length>1){
					  var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCDocExamGetPatList&PatNoStr="+PatNoStr; 
					  var PatNo=window.showModalDialog(url,"","dialogwidth:50em;dialogheight:30em;center:1");
					  var PatNoValue=PatNo;
				}else{
					  var PatNoValue=Str[0];
				}
				var tmp=document.getElementById('PatNo');
				if (tmp){
					tmp.value=PatNoValue;
					FindPatDetail()
				}			    
			}
	    }
	}
}

function PatName_keydown(e){
var key=websys_getKey(e);
	if (key==13) {
	    FindPatInfoByName();
	}
}
function DisablDisInStatus(e){	
	var obj=document.getElementById("DisInStatus");
	if (obj) {
		if (!websys_getSrcElement(e).checked) {
			var myObj=document.getElementById("DisInStatusFlag");
			if(myObj){myObj.value=0}
			//obj.disabled=true;
			//obj.value=""; 
		}else{
			var myObj=document.getElementById("OutStatusFlag");
			if(myObj){myObj.value=0}
			var myObj=document.getElementById("InStatusFlag");
			if(myObj){myObj.value=0}
			var myObj=document.getElementById("DisInStatusFlag");
			if(myObj){myObj.value=1}
			obj.disabled=false;
			var ArrivedQueobj=document.getElementById("InStatus");
			var MedUnitobj=document.getElementById("OutStatus");
			if (ArrivedQueobj) ArrivedQueobj.checked=false;
			if (MedUnitobj) MedUnitobj.checked=false;
		}
	}	
}

function DisablOutStatus(e){	
	var obj=document.getElementById("OutStatus");
	if (obj) {
		if (!websys_getSrcElement(e).checked) {
			var myObj=document.getElementById("OutStatusFlag");
			if(myObj){myObj.value=0}
			//obj.disabled=true;
			//obj.value=""; 
		}else{
			var myObj=document.getElementById("OutStatusFlag");
			if(myObj){myObj.value=1}
			var myObj=document.getElementById("InStatusFlag");
			if(myObj){myObj.value=0}
			var myObj=document.getElementById("DisInStatusFlag");
			if(myObj){myObj.value=0}
			obj.disabled=false;
			var ArrivedQueobj=document.getElementById("InStatus");
			var MedUnitobj=document.getElementById("DisInStatus");
			if (ArrivedQueobj) ArrivedQueobj.checked=false;
			if (MedUnitobj) MedUnitobj.checked=false;
		}
	}	
}

function DisablInStatus(e){	
	var obj=document.getElementById("InStatus");
	if (obj) {
		if (!websys_getSrcElement(e).checked) {
			var myObj=document.getElementById("InStatusFlag");
			if(myObj){myObj.value=0}
			//obj.disabled=true;
			//obj.value=""; 
		}else{
			var myObj=document.getElementById("OutStatusFlag");
			if(myObj){myObj.value=0}
			var myObj=document.getElementById("InStatusFlag");
			if(myObj){myObj.value=1}
			var myObj=document.getElementById("DisInStatusFlag");
			if(myObj){myObj.value=0}
			obj.disabled=false;
			var ArrivedQueobj=document.getElementById("OutStatus");
			var MedUnitobj=document.getElementById("DisInStatus");
			if (ArrivedQueobj) ArrivedQueobj.checked=false;
			if (MedUnitobj) MedUnitobj.checked=false;
		}
	}	
}

function ReadCardAppHandle()
{	var card=document.getElementById('CardNo').value 
	var admId=GSelectAdmRowid
	var papmiId=document.getElementById('PapmiDr').value
	//alert(papmiId)
	if (card==""){
		alert("�����")
		return;
	}
	if (admId==""){
		alert("��ѡ������¼")
		return;		
	}
	//return
	var lnk="udhcopbillforadmif.csp?CardNo="+card+"&SelectAdmRowId="+admId+"&SelectPatRowId="+papmiId;
	var NewWin=open(lnk,"udhcopbillif","scrollbars=yes,resizable=yes,top=6,left=6,width=1024,height=760");
	
}
function ReadCardHandle()
{
	var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	var myary=myoptval.split("^");
	var CardTypeRowId=myary[0];
	//var myEquipDR=DHCWeb_GetListBoxValue("CardTypeDefine");
	//var myEquipDR=combo_CardType.getActualValue();
	//������ʱ��û�б�Ҫ��Ҫ�����˻���Ϣ
    //var CardInform=DHCACC_GetAccInfo(m_SelectCardTypeDR,myEquipDR)
    //var CardInform=DHCACC_ReadMagCard(myEquipDR.split("^")[0])
    var myrtn=DHCACC_GetAccInfo(CardTypeRowId,myoptval);
    var CardSubInform=myrtn.split("^");
    var rtn=CardSubInform[0];
	var CardNo=CardSubInform[1];
	//var ret=CheckIfUnite(CardNo,"");
    //alert(CardInform)
    switch (rtn){
	        case "0": //����Ч
	            document.getElementById('CardNo').value=CardNo
				CardNoKeydown();
				FindPatDetail()
				break;
	        case "-201": 
	            document.getElementById('CardNo').value=CardNo
				CardNoKeydown();
				FindPatDetail()
				break;
			case "-200": //����Ч
				alert("����Ч");
				PapmiNoObj=document.getElementById("PatNo");
    			PapmiNoObj.value="";
				break;
			default:
				break;
		}
	GSelectAdmRowid=""	
    
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
			DHCC_AvailabilityBtn(obj)
			obj.onclick=ReadCardHandle;
		}
	}
	
	//Set Focus
	if (myary[16]=="Handle"){
		DHCWeb_setfocus("CardNo");
	}else{
		DHCWeb_setfocus("ReadCard");
	}
	
	m_CardNoLength=myary[17];
	
}


function RegNoObj_keydown(e) {
	

	if (evtName=='PatNo') 
	{
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key==13) {
		var obj=document.getElementById('PatNo');
		if (obj.value!='') {
			
			if (obj.value.length<10) {
				for (var i=(10-obj.value.length-1); i>=0; i--) {
					obj.value="0"+obj.value
				}
			}
		}
		FindPatDetail();
		var CardNo=tkMakeServerCall("web.DHCOPAdmReg","GetCardNumber",obj.value);
		if(CardNo!=""){
		    CardNo=CardNo.split(",")[0];
			//var ret=CheckIfUnite(CardNo,"");
			
		}
	}
	
	GSelectAdmRowid=""
}

function FindPatDetail(){
		var obj=document.getElementById('PatNo');
		if (obj.value!='') {	
			/*if (obj.value.length<10) {
				for (var i=(10-obj.value.length-1); i>=0; i--) {
					obj.value="0"+obj.value
			}}
		*/
			var tmp=document.getElementById('PatNo');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			var GetDetail=document.getElementById('GetMethodByPatNo');
			if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
			if (cspRunServerMethod(encmeth,'SetPatient_Sel','',p1)=='0') {
				return websys_cancel();
			}
			var patNO=document.getElementById('PatNo').value;
			var wardDesc=document.getElementById("WardDesc").value;
			var CTLoc=document.getElementById("CTLoc").value
			var name=document.getElementById('Name').value;
			var med=document.getElementById("PatMed");
			if ((med.value!="")&&(patNO=="")) {
			    FindPatByMedicare();
			}
			var obj=document.getElementById("FindFlag");
			if (obj){
				 obj.value="1";
			}
		    Find_click();
		}
		
		obj.className='';
}

function SetPatient_Sel(value) {
	try {
		if (value=="0"){
				return
		}
		//alert(value)
		var Split_Value=value.split("^")
		var obj_Name=document.getElementById('Name');
		var obj_Sex=document.getElementById('Sex');
		var obj_Birth=document.getElementById('Birth');
		var obj_RegNo=document.getElementById('PatNo');
		var obj_PatMed=document.getElementById('PatMed');
		var obj_PapmiDr=document.getElementById('PapmiDr');

		if (obj_Name) {
  			obj_Name.value=unescape(Split_Value[0]);
			obj_Name.className='';
			//websys_nexttab('6');		
		}
		if (obj_Sex) {
  			obj_Sex.value=unescape(Split_Value[2]);
			obj_Sex.className='';
			//websys_nexttab('6');
		}
		if (obj_Birth) {
  			obj_Birth.value=unescape(Split_Value[1]);
			obj_Birth.className='';
			//websys_nexttab('6');
		}
		if (obj_PatMed) {
  			obj_PatMed.value=unescape(Split_Value[5]);
			obj_PatMed.className='';
			//websys_nexttab('6');
		}
		if (obj_RegNo) {
  			obj_RegNo.value=unescape(Split_Value[3]);
			obj_RegNo.className='';
			if(obj_RegNo.value==""){
				websys_setfocus("ID")
			}
			//websys_nexttab('6');
		}
		if (obj_PapmiDr){
			obj_PapmiDr.value=unescape(Split_Value[23]);
			//alert(obj_PapmiDr.value)
		}
			
		
	} catch(e) {};
}

function PatMedicare_keydown(e) {
	//
	if (evtName=='PatMed') 
	{
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key==13) {
		FindPatByMedicare()
		//websys_setfocus('PatRegNo');
	}
	GSelectAdmRowid=""
}

function FindPatByMedicare(){
	/*
			var tmp=document.getElementById('PatMed');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			var GetDetail=document.getElementById('GetMethodByPatMed');
			if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
			
			var PatNo=cspRunServerMethod(encmeth,p1)
			if (PatNo!=""){
				var tmp=document.getElementById('PatNo');
				if (tmp){
					tmp.value=PatNo
					FindPatDetail()
				}
			}
	*/
			var tmp=document.getElementById('PatMed');
			if (tmp) {var p1=tmp.value } else {var p1=''};
			//s val=##Class(web.DHCOPReg).GetEncrypt("web.DHCExamPatList.GetPatInfoByInMedNo") 
			var GetDetail=document.getElementById('GetMethodByPatMed');
			if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
			var PatNoStr=cspRunServerMethod(encmeth,p1)
			if (PatNoStr!=""){
				var Str=""
				var Str=PatNoStr.split("^")
			if (Str.length>1){
				    //DHCDocExamGetPatList
				   var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCDocExamGetPatList&PatNoStr="+PatNoStr; 
			       var PatNo=window.showModalDialog(url,"","dialogwidth:50em;dialogheight:30em;center:1");
				   var PatNoValue=PatNo;
				   //
			  }
			else{var PatNoValue=Str[0];}
				var tmp=document.getElementById('PatNo');
				if (tmp){
					tmp.value=PatNoValue;
					FindPatDetail()
				}
			    
			}
				
				
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (SelectedRow!=selectrow) { 
		//
		SelectedRow=selectrow
		var PatientID="";
		var EpisodeID="";
		var mradm=""
		var PatientObj=document.getElementById("EpisodeIDz"+selectrow);
		GSelectAdmRowid=PatientObj.value
		var PatientID=document.getElementById("PatientIDz"+selectrow);		
		var RegID=document.getElementById("RegIDz"+selectrow);
		if(session['LOGON.GROUPID']=='105')
		WriteTimeToTXT("EpisodeID="+GSelectAdmRowid+",PatientID="+PatientID.value+",����ID="+RegID.innerText);
	}else{
		SelectedRow=0
	}
}

function WardChangeHandler(str)
{
 wardArray=str.split("^");
 var wardID=wardArray[2];
 document.getElementById("WardID").value=wardID;

}

function WardDescChangeHanler()
{
  	var  wardObj=document.getElementById("WardDesc");
	if  ((wardObj)&&(wardObj.value=="")) {
	document.getElementById("WardID").value="";
	}
}
function CTLocChangeHanler()
{
  	var  obj=document.getElementById("CTLoc");
	if  ((obj)&&(obj.value=="")) {
		document.getElementById("luloc").value="";
	}
	var obj=document.getElementById("PAAdmRowId")
	var patNO=document.getElementById('PatNo').value;
	if ((obj)&&(patNO=="")){obj.value="";}
}
function AdmDocChangeHanler(){
	var  obj=document.getElementById("AdmDoc");
	if  ((obj)&&(obj.value=="")) {
		document.getElementById("AdmDocId").value="";
	}
}

 function GetWard()
 {
  if(document.getElementById("WardDesc").value=="") {
  //window.console&&console.info(document.getElementById("WardDesc").value);
  document.getElementById("WardID").value="";
}
    if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		WardDesc_lookuphandler();
	}
 }
  function FindClickHandler()
 {
     var patNO=document.getElementById('PatNo').value;
	 var wardDesc=document.getElementById("WardDesc").value;
	 var CTLoc=document.getElementById("CTLoc").value
	 var name=document.getElementById('Name').value;
	 var med=document.getElementById("PatMed");
	 if ((med.value!="")&&(patNO=="")) {
	     FindPatByMedicare();
	 }
	 if ((patNO=="")&&(name!="")&&(wardDesc=="")) {
	      /*if(!websys_$("OutStatus").checked){
				alert(t['selectWard']);
				 return false;
			}*/
	
	 }
	 var obj=document.getElementById("FindFlag");
	 if (obj){
		 obj.value="1";
	 }
     Find_click();
 }
 
 //------------------------------------------������ӡ���ܡ�
function Export_Click(){
	try {   
	    var obj=document.getElementById("FindFlag");
	    if ((obj)&&(obj.value=="")){
		    alert("���ȵ�����Һ��ٴ�ӡ!")
		    return false;
		}
		var GetPrescPath=document.getElementById("printpath");  
		if (GetPrescPath) {var encmeth=GetPrescPath.value} else {var encmeth=''};
		if (encmeth!="") {
			TemplatePath=cspRunServerMethod(encmeth);
		}
		//�ϱߵķ�����������ȡģ�����ڵ�ַ��
		//TemplatePath="http://192.192.10.123/TrakCare/App/Results/Template/"DHCEQSDepreLoc  DHCExamPatList1.xls
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCExamPatList1.xls";
	    
		//���ұ߾�
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=15;  //lgl+
	    xlsheet.PageSetup.RightMargin=0;
		//��ȡҳ������
		Guser=session['LOGON.USERID']
		var obj=document.getElementById("GetPrintMessage");
		if (obj) {var encmeth=obj.value} else {var encmeth=''};
	    var ReturnValue=cspRunServerMethod(encmeth,Guser,1,"");
	    if (+ReturnValue==0){
		    alert("û����Ҫ��ӡ������!")
		    return false;
		}
		var myRows=ReturnValue;
		var vaild = window.confirm("ȷ��Ҫ��ӡ��Ϣ?")
		if(vaild){} else{return;}
		
		var xlsrow=2; //����ָ��ģ��Ŀ�ʼ����λ��
		var xlsCurcol=0;  //����ָ����ʼ������λ��
		var obj=document.getElementById("GetRegID");
		if (obj) {var GetRegID=obj.value} else {var GetRegID=''};
		var obj=document.getElementById("GetPatientMes");
		if (obj) {var GetPatientMes=obj.value} else {var GetPatientMes=''};
		var obj=document.getElementById("GetPatientSex");
		if (obj) {var GetPatientSex=obj.value} else {var GetPatientSex=''};
		var NO=myRows/48
	    NO=parseInt(NO)+1;
		var Flag=1
		//AdmDate_"^"_AdmTime_"^"_AdmDoc_"^"_AdmReason_"^"_AdmType_"^"_PAAdmWard
		//_"^"_PAAdmBed_"^"_AdmDept_"^"_PatientID_"^"_EpisodeID_"^"_AdmDischgDate
		for (var Row=1;Row<=myRows;Row++)
		{   
		    if (xlsrow==(50*Flag))
		    {
			     Flag=Flag+1
			     var HospitalName=document.getElementById("HospitalName").value;
		         if(HospitalName!=""){
			        xlsheet.cells(1,1)=HospitalName+"���߲��ҵ�"
			     }else{
				    xlsheet.cells(1,1)="���߲��ҵ�"
				}
				 xlsheet.PrintOut;
				 var xlsrow=2;
			     var xlsCurcol=0;
			     xlApp = new ActiveXObject("Excel.Application");
			     xlBook = xlApp.Workbooks.Add(Template);
			     xlsheet = xlBook.ActiveSheet; 
			     xlsheet.PageSetup.LeftMargin=15;  //lgl+
		    	 xlsheet.PageSetup.RightMargin=0;
		    	
			}
			xlsrow=xlsrow+1; //�ӵ����п�ʼ
			var StrData=cspRunServerMethod(encmeth,Guser,2,Row);
            var DataValue=StrData.split("^")
            xlsheet.cells(xlsrow,xlsCurcol+1)=Row;
            xlsheet.cells(xlsrow,xlsCurcol+8)=DataValue[0]; //AdmDate ��������
            xlsheet.cells(xlsrow,xlsCurcol+9)=DataValue[1];//AdmTime ����ʱ��
            xlsheet.cells(xlsrow,xlsCurcol+11)=DataValue[2];//AdmDoC ҽ��
            xlsheet.cells(xlsrow,xlsCurcol+7)=DataValue[3];//AdmReasoc �ѱ�
            xlsheet.cells(xlsrow,xlsCurcol+6)=DataValue[4];//AdmType  ��������
            xlsheet.cells(xlsrow,xlsCurcol+12)=DataValue[5];//PAAdmWard ����
            xlsheet.cells(xlsrow,xlsCurcol+13)=DataValue[6];//PAAdmBed ����
            xlsheet.cells(xlsrow,xlsCurcol+10)=DataValue[7];//AdmDept �������
            var RegIDz=cspRunServerMethod(GetRegID,DataValue[8]);
            var Str=cspRunServerMethod(GetPatientMes,DataValue[8]);
            var Message=Str.split("^");
            var PatientSex=cspRunServerMethod(GetPatientSex,DataValue[8]);
            xlsheet.cells(xlsrow,xlsCurcol+3)=RegIDz; //����ID
            xlsheet.cells(xlsrow,xlsCurcol+2)=Message[0];//������
            xlsheet.cells(xlsrow,xlsCurcol+14)=DataValue[10];//AdmDischgDate ��Ժ����
            xlsheet.cells(xlsrow,xlsCurcol+4)=Message[1];// ��������
            xlsheet.cells(xlsrow,xlsCurcol+5)=PatientSex// �����Ա�
               
        }
        var name=""
    	//var Service=document.getElementById("Service");
		//if (Service.checked){name="���"}
		//var CheckOut=document.getElementById("CheckOut");
		//if (CheckOut.checked){name="����"}
        //xlsheet.cells(1,1)="����Э��ҽԺ���߲��ҵ�"
		var HospitalName=document.getElementById("HospitalName").value;
        if(HospitalName!=""){
	        xlsheet.cells(1,1)=HospitalName+"���߲��ҵ�"
	    }else{
		    xlsheet.cells(1,1)="���߲��ҵ�"
		}
		debugger;
		//gridlist(xlsheet,6,xlsrow,2,13)  //�˴��ǻ�������
		var d=new Date();
		var h=d.getHours();
		var m=d.getMinutes();
		var s=d.getSeconds()
	    // alert("�ļ�������������C�̸�Ŀ¼��");
	    xlsheet.PrintOut;
	    //xlBook.SaveAs("C:\\"+"����Э��ҽԺ���߲��ҵ�"+h+m+s+".xls");   //lgl+
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	} catch(e) {
		//alert(e.message);
	};
}

function WriteTimeToTXT(i)
{
	var writeStr;
	var userId=session['LOGON.USERID'];
	var myDate = new Date();
	
	var mytime=myDate.toLocaleTimeString()+":"+myDate.getMilliseconds();
	writeStr="ʱ��:"+mytime;
	/*    
	object.OpenTextFile(filename[, iomode[, create[, format]]])    
	����object��ѡ�object ӦΪ FileSystemObject �����ơ�    
	filename��ѡ�ָ��Ҫ���ļ����ַ������ʽ��    
	iomode��ѡ���������������֮һ��ForReading �� ForWriting �� ForAppending ��    
	create��ѡ�Boolean ֵ��ָ����ָ���� filename ������ʱ�Ƿ񴴽����ļ�������������ļ���ֵΪ True �������������Ϊ False ��������ԣ��򲻴������ļ���    
	format��ѡ�ʹ����ֵ̬�е�һ����ָ�����ļ��ĸ�ʽ��������ԣ���ô�ļ����� ASCII ��ʽ�򿪡�    
	����iomode �������������������е���һ�֣�    
	����      ֵ  ����    
	ForReading 1 ��ֻ����ʽ���ļ�������д����ļ���    
	ForWriting 2 ��д��ʽ���ļ�    
	ForAppending 8 ���ļ������ļ�ĩβ��ʼд��    
	format �������������������е���һ�֣�    
	ֵ              ����    
	TristateTrue �� Unicode ��ʽ���ļ���    
	TristateFalse �� ASCII ��ʽ���ļ���    
	TristateUseDefault ʹ��ϵͳĬ��ֵ���ļ��� 
	-2ϵͳĬ�ϡ�-1��Unicode ��ʽ��0��ASCII ��ʽ   
	*/     
	var filePath="c://"+userId+"searchLog.txt";
	var objFSO = new ActiveXObject("Scripting.FileSystemObject");
	var objStream;
	if (!objFSO.FileExists(filePath))
	{    // ����ļ��Ƿ����
   		objStream=objFSO.CreateTextFile(filePath,8,true);
	}
	else
	{
		objStream=objFSO.OpenTextFile(filePath,8,false,-1);
	}
	objStream.Write(writeStr+"----"+i+"\r\n");
   	objStream.Close();  // �ر��ļ�
	
}
 function FormatCardNo(){
	var CardNo=DHCC_GetElementData("CardNo");
	if (CardNo!='') {
		var CardNoLength=GetCardNoLength();
		if ((CardNo.length<CardNoLength)&&(CardNoLength!=0)) {
			for (var i=(CardNoLength-CardNo.length-1); i>=0; i--) {
				CardNo="0"+CardNo;
			}
		}
	}
	return CardNo
}
function GetCardNoLength(){
	var CardNoLength="";
	var CardTypeValue=DHCC_GetElementData("CardTypeDefine"); //BY guorongyong ȡ��ѡ�����ʹ����ַ��� 2008-02-27
    //var CardTypeValue=tempclear
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^");
		CardNoLength=CardTypeArr[17];
	}
	return CardNoLength;
}
function CardNoKeydown(){
	var CardNo=document.getElementById("CardNo").value
	CardNo=FormatCardNo();
	var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR,CardNo,"","PatInfo");
	//alert(myrtn)
	var myary=myrtn.split("^");
	var rtn=myary[0];
    //alert(CardInform)
    switch (rtn){
			case "-200": //����Ч
				alert("����Ч");
				PapmiNoObj=document.getElementById("PatNo");
    			PapmiNoObj.value="";
				break;
			default:
				//alert(myrtn)
				document.getElementById('PatNo').value=myary[5]
				document.getElementById('CardNo').value=myary[1]
				FindPatDetail()
				break;
		}
	GSelectAdmRowid=""	
}
function CardNoKeydownHandler(e) {
	//���Ҫ�뿨����һ��
	if (evtName=='CardNo') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key==13) {
		CardNoKeydown();
	}
	
}
function getAdmDoc(str){
	var obj=document.getElementById("AdmDocId");
	if (obj) obj.value=str.split("^")[1];
}
function getloc(str)
{ 
		var loc=str.split("^");
		var locdes=document.getElementById("CTLoc")
		locdes.value=loc[1];
		var obj=document.getElementById("luloc")
		obj.value=loc[0];
		var obj=document.getElementById("WardDesc")
		if(obj){
			obj.value=""
			document.getElementById("WardID").value="";
		}
		var obj=document.getElementById("AdmDocId");
	    if (obj) obj.value="";
	    var obj=document.getElementById("AdmDoc");
	    if (obj) obj.value="";
		//���ݿ������»�ȡ������Ϣ
		AddWardDesc(loc[0]);
		//alert(loc[1]);
	
}
function AddWardDesc(DepRowId){
    var obj=document.getElementById('GetWardDescEncrypt');
	if (obj) {
	    var encmeth=obj.value;
		if (encmeth!=''){
			var retDetail=cspRunServerMethod(encmeth,"AddToWardDescList","","",DepRowId);
			if (retDetail==1) return true;
		}
	}	
}
function AddToWardDescList(val){	
	var WardArray=val.split("^");
	if (WardArray.length>0){
		var obj=document.getElementById('WardDesc');
	    var myobj=document.getElementById('WardID');		
	    myobj.value=WardArray[0].split(String.fromCharCode(1))[0];
	    obj.value=WardArray[0].split(String.fromCharCode(1))[1];					
	}	
}

//ѡ���Ӧ�ľ����л�-��סԺ֤�л�����ʹ��
function AdmSearchDBClickHander()
{
	if (SelectedRow==0) return;
	if (window.name=="BookCreat"){
		var Parobj=window.opener
		var AdmObj=document.getElementById("EpisodeIDz"+SelectedRow);
		var AdmID=AdmObj.value
		self.close();
		Parobj.ChangePerson(AdmID)
	}
	if ("function" === typeof window.parent.ChangePerson){
		var AdmObj=document.getElementById("EpisodeIDz"+SelectedRow);
		var AdmID=AdmObj.value;
		window.parent.ChangePerson(AdmID);
		window.parent.destroyDialog("BookCreat");
	}
}

function PatNameSelect(str){
	var patname=document.getElementById("Name")
	var PatNo=document.getElementById("PatNo")
	var PAAdmRowId=document.getElementById("PAAdmRowId")
	if (str.split("^").length>0){
		PAAdmRowId.value=str.split("^")[0];
		PatNo.value=str.split("^")[1];
		patname.value=str.split("^")[2];
	}	
	if (PatNo.value!=""){
	    var GetDetail=document.getElementById('GetMethodByPatNo');
	    if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
		if (cspRunServerMethod(encmeth,'SetPatient_Sel','',PatNo.value)=='0') {
			return websys_cancel();
		}
	}
}
document.body.onload = DocumentLoadHandler;

