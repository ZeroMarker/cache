//document.write("<object ID='ClsDHCPrint' WIDTH=0 HEIGHT=0 CLASSID='CLSID:FDBE454C-918A-4DEC-BFA6-1A797E3CAC9A' CODEBASE='../addins/client/DHCOPRegTMPrint.CAB#version=1,0,0,0'>");
//document.write("</object>");

var GSelectAdmRowid="" 
var SelectedRow=0
function DocumentLoadHandler() {
	
	//选择一行
	var Obj=document.getElementById('tDHCExamPatList');
	if(Obj)Obj.ondblclick=AdmSearchDBClickHander;
	//加入打印
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
	if ((session['LOGON.GROUPDESC']=='手术护士')&&(PatMed)){
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
	     if(SeeDoctor.innerHTML=="未就诊"){
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
		alert("请读卡")
		return;
	}
	if (admId==""){
		alert("请选择就诊记录")
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
	//读卡的时候没有必要非要查找账户信息
    //var CardInform=DHCACC_GetAccInfo(m_SelectCardTypeDR,myEquipDR)
    //var CardInform=DHCACC_ReadMagCard(myEquipDR.split("^")[0])
    var myrtn=DHCACC_GetAccInfo(CardTypeRowId,myoptval);
    var CardSubInform=myrtn.split("^");
    var rtn=CardSubInform[0];
	var CardNo=CardSubInform[1];
	//var ret=CheckIfUnite(CardNo,"");
    //alert(CardInform)
    switch (rtn){
	        case "0": //卡有效
	            document.getElementById('CardNo').value=CardNo
				CardNoKeydown();
				FindPatDetail()
				break;
	        case "-201": 
	            document.getElementById('CardNo').value=CardNo
				CardNoKeydown();
				FindPatDetail()
				break;
			case "-200": //卡无效
				alert("卡无效");
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
		WriteTimeToTXT("EpisodeID="+GSelectAdmRowid+",PatientID="+PatientID.value+",病人ID="+RegID.innerText);
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
 
 //------------------------------------------导出打印功能。
function Export_Click(){
	try {   
	    var obj=document.getElementById("FindFlag");
	    if ((obj)&&(obj.value=="")){
		    alert("请先点击查找后再打印!")
		    return false;
		}
		var GetPrescPath=document.getElementById("printpath");  
		if (GetPrescPath) {var encmeth=GetPrescPath.value} else {var encmeth=''};
		if (encmeth!="") {
			TemplatePath=cspRunServerMethod(encmeth);
		}
		//上边的方法是用来获取模板所在地址的
		//TemplatePath="http://192.192.10.123/TrakCare/App/Results/Template/"DHCEQSDepreLoc  DHCExamPatList1.xls
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCExamPatList1.xls";
	    
		//左右边距
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=15;  //lgl+
	    xlsheet.PageSetup.RightMargin=0;
		//获取页面数据
		Guser=session['LOGON.USERID']
		var obj=document.getElementById("GetPrintMessage");
		if (obj) {var encmeth=obj.value} else {var encmeth=''};
	    var ReturnValue=cspRunServerMethod(encmeth,Guser,1,"");
	    if (+ReturnValue==0){
		    alert("没有需要打印的数据!")
		    return false;
		}
		var myRows=ReturnValue;
		var vaild = window.confirm("确定要打印信息?")
		if(vaild){} else{return;}
		
		var xlsrow=2; //用来指定模板的开始行数位置
		var xlsCurcol=0;  //用来指定开始的列数位置
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
			        xlsheet.cells(1,1)=HospitalName+"患者查找单"
			     }else{
				    xlsheet.cells(1,1)="患者查找单"
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
			xlsrow=xlsrow+1; //从第三行开始
			var StrData=cspRunServerMethod(encmeth,Guser,2,Row);
            var DataValue=StrData.split("^")
            xlsheet.cells(xlsrow,xlsCurcol+1)=Row;
            xlsheet.cells(xlsrow,xlsCurcol+8)=DataValue[0]; //AdmDate 就诊日期
            xlsheet.cells(xlsrow,xlsCurcol+9)=DataValue[1];//AdmTime 就诊时间
            xlsheet.cells(xlsrow,xlsCurcol+11)=DataValue[2];//AdmDoC 医生
            xlsheet.cells(xlsrow,xlsCurcol+7)=DataValue[3];//AdmReasoc 费别
            xlsheet.cells(xlsrow,xlsCurcol+6)=DataValue[4];//AdmType  就诊类型
            xlsheet.cells(xlsrow,xlsCurcol+12)=DataValue[5];//PAAdmWard 病区
            xlsheet.cells(xlsrow,xlsCurcol+13)=DataValue[6];//PAAdmBed 病床
            xlsheet.cells(xlsrow,xlsCurcol+10)=DataValue[7];//AdmDept 就诊科室
            var RegIDz=cspRunServerMethod(GetRegID,DataValue[8]);
            var Str=cspRunServerMethod(GetPatientMes,DataValue[8]);
            var Message=Str.split("^");
            var PatientSex=cspRunServerMethod(GetPatientSex,DataValue[8]);
            xlsheet.cells(xlsrow,xlsCurcol+3)=RegIDz; //病人ID
            xlsheet.cells(xlsrow,xlsCurcol+2)=Message[0];//病案号
            xlsheet.cells(xlsrow,xlsCurcol+14)=DataValue[10];//AdmDischgDate 出院日期
            xlsheet.cells(xlsrow,xlsCurcol+4)=Message[1];// 病人姓名
            xlsheet.cells(xlsrow,xlsCurcol+5)=PatientSex// 病人性别
               
        }
        var name=""
    	//var Service=document.getElementById("Service");
		//if (Service.checked){name="检查"}
		//var CheckOut=document.getElementById("CheckOut");
		//if (CheckOut.checked){name="检验"}
        //xlsheet.cells(1,1)="北京协和医院患者查找单"
		var HospitalName=document.getElementById("HospitalName").value;
        if(HospitalName!=""){
	        xlsheet.cells(1,1)=HospitalName+"患者查找单"
	    }else{
		    xlsheet.cells(1,1)="患者查找单"
		}
		debugger;
		//gridlist(xlsheet,6,xlsrow,2,13)  //此处是画横向表格
		var d=new Date();
		var h=d.getHours();
		var m=d.getMinutes();
		var s=d.getSeconds()
	    // alert("文件将保存在您的C盘根目录下");
	    xlsheet.PrintOut;
	    //xlBook.SaveAs("C:\\"+"北京协和医院患者查找单"+h+m+s+".xls");   //lgl+
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
	writeStr="时间:"+mytime;
	/*    
	object.OpenTextFile(filename[, iomode[, create[, format]]])    
	参数object必选项。object 应为 FileSystemObject 的名称。    
	filename必选项。指明要打开文件的字符串表达式。    
	iomode可选项。可以是三个常数之一：ForReading 、 ForWriting 或 ForAppending 。    
	create可选项。Boolean 值，指明当指定的 filename 不存在时是否创建新文件。如果创建新文件则值为 True ，如果不创建则为 False 。如果忽略，则不创建新文件。    
	format可选项。使用三态值中的一个来指明打开文件的格式。如果忽略，那么文件将以 ASCII 格式打开。    
	设置iomode 参数可以是下列设置中的任一种：    
	常数      值  描述    
	ForReading 1 以只读方式打开文件。不能写这个文件。    
	ForWriting 2 以写方式打开文件    
	ForAppending 8 打开文件并从文件末尾开始写。    
	format 参数可以是下列设置中的任一种：    
	值              描述    
	TristateTrue 以 Unicode 格式打开文件。    
	TristateFalse 以 ASCII 格式打开文件。    
	TristateUseDefault 使用系统默认值打开文件。 
	-2系统默认、-1以Unicode 格式、0以ASCII 格式   
	*/     
	var filePath="c://"+userId+"searchLog.txt";
	var objFSO = new ActiveXObject("Scripting.FileSystemObject");
	var objStream;
	if (!objFSO.FileExists(filePath))
	{    // 检查文件是否存在
   		objStream=objFSO.CreateTextFile(filePath,8,true);
	}
	else
	{
		objStream=objFSO.OpenTextFile(filePath,8,false,-1);
	}
	objStream.Write(writeStr+"----"+i+"\r\n");
   	objStream.Close();  // 关闭文件
	
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
	var CardTypeValue=DHCC_GetElementData("CardTypeDefine"); //BY guorongyong 取所选卡类型传出字符串 2008-02-27
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
			case "-200": //卡无效
				alert("卡无效");
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
	//这边要与卡处理一致
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
		//根据科室重新获取病区信息
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

//选择对应的就诊切换-开住院证切换患者使用
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

