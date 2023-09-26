var papnoobj,papmiidobj,papnameobj,medicareobj,paperidobj;
var birthdateobj,ageobj,adressobj,companyobj;
var hometelobj,worktelobj,mobtelobj,emailobj;
var SexObj,admdateobj,admtimeobj,usernameobj,deposittypeobj,pyobj,bankobj;
var admreasonobj,admepisobj,mardescobj,rlgdescobj,admdocobj;
var admidobj,admvisitobj,admdocidobj,bankidobj,admreaidobj;
var admepisidobj,pyidobj,deptypeobj,moderowidobj,bankrowidobj;
var admsearchobj,admdepobj,admdepidobj,admwardobj,admwardidobj;
var sexidobj,mardescidobj,rlgdescid;
var zipcodeobj,zipidobj,cityobj,cityidobj,provdescobj,providobj;
var ageyrobj,agemthobj,agedayobj;
var bedobj,bedidobj,roomobj,roomidobj;
var yjamtobj,admqkobj,admqkidobj;
var Guser,gusername,gusercode,UserLoc;
var AskedForSaveAddress=0;
var CurNo,EndNo,Title;
var Adm,path,returnval;
var curyear,curmon,curday;
var cardCheckNo,opcardnoobj,computername;
var opcardid=""
var SocSatdescobj,SocSatidobj,admqkobj,admqkidobj;
var nationdescobj,nationidobj,deptcompobj,cardnoobj,banksubobj;
var cardtypeobj,cardtypeidobj,govcardnoobj,countryobj,countryidobj;
var occuobj,occuidobj,eduobj,eduidobj,languobj,languidobj;
var emptypeobj,emptypeidobj,homeplaceobj,birprovobj,bircityobj;
var ctrltdescobj,ctrltidobj,ForeignIdobj,FPhoneobj,FAddressobj;
var FNotesobj,AdmTimesobj,cityareaobj,cityareaidobj;
var AbortYJprtFlag,DepositFlag,PatinFlag,AgeFlag,LinkDepositFlag,PapnoFlag
var babybirobj
var babydob1,babydob2
var diagnosobj,diagnosidobj,diagnosdescobj,digtypeobj,digtypeidobj
var newcardnoobj
function BodyLoadHandler() { 
  babydob1=""
  babydob2=""
  RcptFlag="Y"
  PrtFlag="N"    
  AgeFlag="N"    
  getzyjfconfig()  
  AbortYJprtFlag="Y" 
  Guser=session['LOGON.USERID']
  gusercode=session['LOGON.USERCODE']
  gusername=session['LOGON.USERNAME']
  UserLoc=session['LOGON.CTLOCID']
  usernameobj=document.getElementById('username');
  usernameobj.value=gusername
  usernameobj.readOnly=true;
  var WshNetwork = new ActiveXObject("WScript.NetWork");
  computername=WshNetwork.ComputerName; 
  
  newcardnoobj=document.getElementById('newcardno');
  opcardnoobj=document.getElementById('opcardno');
  papnoobj=document.getElementById('Regno');
  papmiidobj=document.getElementById('papmiid');
  papnameobj=document.getElementById('name');
  medicareobj=document.getElementById('Medicare');
  SexObj=document.getElementById('sex');
  sexidobj=document.getElementById('sexid');
  paperidobj=document.getElementById('paperid');
  birthdateobj=document.getElementById('birthdate');
  ageobj=document.getElementById('age');
  mardescobj=document.getElementById('mardesc');
  mardescidobj=document.getElementById('mardescid');
  rlgdescobj=document.getElementById('rlgdesc');
  rlgdescidobj=document.getElementById('rlgdescid');
  addressobj=document.getElementById('address');
  hometelobj=document.getElementById('hometel');
  zipcodeobj=document.getElementById('zipcode');
  zipidobj=document.getElementById('zipid');
  companyobj=document.getElementById('company');
  worktelobj=document.getElementById('worktel');
  cityobj=document.getElementById('CTCITDesc');
  cityidobj=document.getElementById('cityid');
  provdescobj=document.getElementById('PROVDesc');
  providobj=document.getElementById('provid');
  mobtelobj=document.getElementById('mobtel');
  emailobj=document.getElementById('email');
  ageyrobj=document.getElementById('ageyr');
  agemthobj=document.getElementById('agemth');
  agedayobj=document.getElementById('ageday');
  SocSatdescobj=document.getElementById('SocSatdesc');
  SocSatidobj=document.getElementById('SocSatid');
  nationdescobj=document.getElementById('nationdesc');
  nationidobj=document.getElementById('nationid');
  cardtypeobj=document.getElementById('CardType');
  cardtypeidobj=document.getElementById('CardTypeid');
  govcardnoobj=document.getElementById('GovCardno');
  countryobj=document.getElementById('Country');
  babybirobj=document.getElementById('babybir');
  var agehourobj=document.getElementById('agehour');
  var ageMinutesobj=document.getElementById('ageMinutes');
  
  countryidobj=document.getElementById('Countryid');
  occuobj=document.getElementById('Occupation');
  occuidobj=document.getElementById('Occuid');
  eduobj=document.getElementById('Education');
  eduidobj=document.getElementById('Educatid');
  languobj=document.getElementById('Language');
  languidobj=document.getElementById('Languid');
  emptypeobj=document.getElementById('EmployeeType');
  emptypeidobj=document.getElementById('EmpTypeid');
  homeplaceobj=document.getElementById('HomePlace');
  birprovobj=document.getElementById('BirthProvid');
  bircityobj=document.getElementById('BirthCityid');
  ctrltdescobj=document.getElementById('Ctrltdesc');
  ctrltidobj=document.getElementById('Ctrltid');
  ForeignIdobj=document.getElementById('ForeignId');
  FPhoneobj=document.getElementById('ForeignPhone');
  FAddressobj=document.getElementById('ForeignAddress');
  FNotesobj=document.getElementById('ForeignNotes');
  cityareaobj=document.getElementById('cityarea');
  cityareaidobj=document.getElementById('cityareaid');
    
  admsearchobj=document.getElementById('admsearch');
  admidobj=document.getElementById('admid');
  admvisitobj=document.getElementById('admvisit');
  admdepobj=document.getElementById('admdep');
  admdepidobj=document.getElementById('admdepid');
  admwardobj=document.getElementById('admward');
  admwardidobj=document.getElementById('admwardid');
  bedobj=document.getElementById('admbedno');
  bedidobj=document.getElementById('bedrowid');
  roomobj=document.getElementById('ROOMDesc');
  roomidobj=document.getElementById('roomrowid');
  admdocobj=document.getElementById('admdoc');
  admdocidobj=document.getElementById('admdocid');
  admreasonobj=document.getElementById('admreason');
  admreaidobj=document.getElementById('admreasonid');
  admepisobj=document.getElementById('admepis');
  admepisidobj=document.getElementById('admepisid');
  admdateobj=document.getElementById("admdate");
  admtimeobj=document.getElementById("admtime");
  admqkobj=document.getElementById("admqingk");
  admqkidobj=document.getElementById("admqkid");
  AdmTimesobj=document.getElementById('AdmTimes');
  diagnosobj=document.getElementById('Diagnos');
  diagnosidobj=document.getElementById('Diagnosid');
  diagnosdescobj=document.getElementById('Diagnosdesc');
  digtypeobj=document.getElementById('DiagnosType');
  digtypeidobj=document.getElementById('DiagnosTypeid');
  var RefDocListobj=document.getElementById('RefDocList');
  if (RefDocListobj) RefDocListobj.onkeydown=getrefdoc
    
  deposittypeobj=document.getElementById('deposittype');
  deptypeobj=document.getElementById('deptype');
  pyobj=document.getElementById('paymode');
  moderowidobj=document.getElementById('moderowid');
  bankobj=document.getElementById('bank');
  bankrowidobj=document.getElementById('bankrowid');
  yjamtobj=document.getElementById('payamt');
  deptcompobj=document.getElementById('deptcomp')
  cardnoobj=document.getElementById('cardno')
  banksubobj=document.getElementById('banksub')
  getcurdate()
  clear_click()
  
  papnoobj.onkeydown=getpatinfo;
  medicareobj.onkeydown=getpatinfo    //yyx2007-04-02
  zipcodeobj.onkeydown=getzipcode;
  deposittypeobj.onkeydown=getdeptype;
  pyobj.onkeydown=getpy;
  bankobj.onkeydown=getbank;
  cardnoobj.onkeydown=entercardno;
  banksubobj.onkeydown=enterbanksub; 
  cityareaobj.onkeydown=entercityarea
  //add 2007 01 25 for Insurance
  INSURegObj=document.getElementById('INSUReg');
  if (INSURegObj) INSURegObj.onclick=INSUReg_click
    
  admreasonobj.onkeydown=getadmreason
 if (SexObj) SexObj.onkeydown=getsex;
 if (mardescobj) mardescobj.onkeydown=getmardesc; 
 if (rlgdescobj) rlgdescobj.onkeydown=getrlgdesc;
 if (admdocobj) admdocobj.onkeydown=getadmdoc;
 if (admepisobj) admepisobj.onkeydown=getadmepis;
 birthdateobj.onkeydown=getage;
 var regsaveobj=document.getElementById('regsave');
 if (regsaveobj) regsaveobj.onclick=regsave_click
 var clearobj=document.getElementById('clear');
 if (clearobj) clearobj.onclick=clear_click 
 var clearadmobj=document.getElementById('clearadm');
 if (clearadmobj) clearadmobj.onclick=clearadm_click ;
 
 var btnyjobj=document.getElementById('BtnPrint');

 if (btnyjobj) 
 {  if (LinkDepositFlag=="N") 
    {  btnyjobj.onclick=Add_click;	 }
    else
    {  btnyjobj.onclick=LinkaddDeposit_click }
 }
 var yjsearch=document.getElementById('yjsearch');
 if (yjsearch) yjsearch.onclick=yjsearch_click; 
 
 //yjsearch.style.visibility = "hidden"

 var admfin=document.getElementById('admfin');
 if (admfin) admfin.onclick=admfin_click; 
 var readcard=document.getElementById('readcard');
 if (readcard) readcard.onclick=readcard_click; 
 var regupdate=document.getElementById('regupdate');
 if (regupdate) regupdate.onclick=regupdate_click; 
 var admupdate=document.getElementById('admupdate');
 if (admupdate) admupdate.onclick=admupdate_click; 
 var patupsearch=document.getElementById('patupsearch');
 if (patupsearch) patupsearch.onclick=patupsearch_click; 
 var admcancel=document.getElementById('admcancel');
 if (admcancel) admcancel.onclick=admcancel_click;
 if (PatinFlag=="N"){
    admdateobj.onkeydown=getadmdate
 }
 //enter event
 papnameobj.onkeydown=enterpatname
 //medicareobj.onkeydown=entermedicare   yyx2007-04-02
 paperidobj.onkeydown=enterpaperid
 addressobj.onkeydown=enteraddress
 hometelobj.onkeydown=enterhometel
 companyobj.onkeydown=entercompany
 worktelobj.onkeydown=enterworktel
 emailobj.onkeydown=enteremail
 mobtelobj.onkeydown=entermobtel
 cardtypeobj.onkeydown=entercardtype
 govcardnoobj.onkeydown=entergovcardno
 countryobj.onkeydown=entercountry
 occuobj.onkeydown=enteroccu
 eduobj.onkeydown=enteredu
 languobj.onkeydown=enterlangu
 emptypeobj.onkeydown=enteremptype
 homeplaceobj.onkeydown=enterhomeplace
 ctrltdescobj.onkeydown=enterctrlt
 ForeignIdobj.onkeydown=enterForeignId
 FPhoneobj.onkeydown=enterFPhone
 FAddressobj.onkeydown=enterFAddress
 FNotesobj.onkeydown=enterFNotes
 babybirobj.onkeydown=enterbaby;
 agehourobj.onkeydown=enterbaby;
 ageMinutesobj.onkeydown=enterbaby;
 
 admdepobj.onkeydown=getadmdep
 admwardobj.onkeydown=getadmward
 admqkobj.onkeydown=getadmryqk
 SocSatdescobj.onkeydown=getSocSat
 diagnosobj.onkeydown=getdiagnos
 digtypeobj.onkeydown=getdigtype
 yjamtobj.onkeydown=enteryjamt 
 ageobj.onkeydown=getbirday
 birthdateobj.onkeydown=getage
 nationdescobj.onkeydown=getnation
 deptcompobj.onkeydown=entercomp
 var getpath=document.getElementById('getpath');
 if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
 path=cspRunServerMethod(encmeth,'','');			
 var refdep=document.getElementById('refdep');
 refdep.onclick=refunddeposit_click
 elementformat()
 //add 2007-03-19
  FindObj=document.getElementById('FindPatInfo');
  if (FindObj) FindObj.onclick=Find_click
//
//insert by cx 2007.10.23
if (newcardnoobj) newcardnoobj.onkeydown=getnewcardinfo
 }
function Find_click()
{
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPRegFind";
	win=open(lnk,"NewWin","scrollbars=1,top=150,left=10,width=1000,height=400");
}
 function enterpatname(){
 	 var key=websys_getKey(e);
	if (key==13) {
	   if (papnameobj==""){
		   alert(t['12']);
		   return;}	 
	  else{
		var namestr=papnameobj.value;		
		var namestr1=GetSpellCode(namestr)		
		document.getElementById('pycode').value=namestr1		
	  }
	  DHCWeb_Nextfocus()	   
	}
  }
 function entermedicare(){
 	 var key=websys_getKey(e);
	if (key==13) {
	  DHCWeb_Nextfocus();	   
	}
  }
 function enterpaperid(){
    var ageyear,agemon,ageday
    var agebir
    var key=websys_getKey(e);
	if (key==13) {
	  if (paperidobj.value!=""){
		  var paperidlen=(paperidobj.value).length
		  if (eval(paperidlen)==15){
		     var tmp=paperidobj.value
			 ageyear=tmp.substring(6,8)
			 agemon=tmp.substring(8,10)
			 ageday=tmp.substring(10,12)
			 agebir="19"+ageyear+"-"+agemon+"-"+ageday
			 
			 if (birthdateobj.value==""){
			    birthdateobj.value=agebir
			    getage1()
			 }else{
				 if (birthdateobj.value!=agebir){
				    alert(t['63']);
				    birthdateobj.value=""
				    paperidobj.value=""
				    ageobj.value=""
				 }
			 }
		  }
		  else if (eval(paperidlen)==18){
			  var tmp=paperidobj.value
			  ageyear=tmp.substring(6,10)
			  agemon=tmp.substring(10,12)
			  ageday=tmp.substring(12,14)
			  agebir=ageyear+"-"+agemon+"-"+ageday
			  
			  if (birthdateobj.value==""){
			    birthdateobj.value=agebir
			    getage1()
			  }else{
				 if (birthdateobj.value!=agebir){
				    alert(t['63']);
				    birthdateobj.value=""
				    paperidobj.value=""
				    ageobj.value=""
				 }
			  }			  
		  }
		else{
		   alert(t['62']);
		   paperidobj.value=""
		   return;
		   
		}  	     
	  }
	  DHCWeb_Nextfocus();	   
	}
  }
 function enteraddress(){
 	 var key=websys_getKey(e);
	if (key==13) {
	  DHCWeb_Nextfocus();	   
	}
  }
  function enterhometel(){
 	 var key=websys_getKey(e);
	if (key==13) {
	  DHCWeb_Nextfocus();	   
	}
  }
  function entercompany(){
 	 var key=websys_getKey(e);
	if (key==13) {
	  DHCWeb_Nextfocus();	   
	}
  }
  function enteremail(){
 	 var key=websys_getKey(e);
	if (key==13) {
	  DHCWeb_Nextfocus();	   
	}
  }
 function entermobtel(){
 	 var key=websys_getKey(e);
	if (key==13) {
	  DHCWeb_Nextfocus();	   
	}
  }  
 function enterworktel(){
 	 var key=websys_getKey(e);
	if (key==13) {
	  DHCWeb_Nextfocus();	   
	}
  } 
 function enteryjamt(){
 	var key=websys_getKey(e);
	if (key==13) {
	   var payamt=document.getElementById('payamt').value;
	   var getamtdx=document.getElementById('getamtdx');
	   if (getamtdx) {var encmeth=getamtdx.value} else {var encmeth=''};
	   var amtdx=cspRunServerMethod(encmeth,"","",payamt)
	   document.getElementById('amtdx').value=amtdx	
	   DHCWeb_Nextfocus();	   	   
	}
  }
  function getnation(){
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   nationdesc_lookuphandler();
	   DHCWeb_Nextfocus();
		}	     
	  }    
 function getage()
 {  var key=websys_getKey(e);
	if (key==13) {
    var p1=birthdateobj.value
     if (p1==""){
	     alert(t['09']);
	     websys_setfocus('birthdate');
	     return;
	 }    
    getage1()
	DHCWeb_Nextfocus();
	}
 }
 function getage1(){
	 var p1=birthdateobj.value
     if (p1==""){
	     alert(t['09']);
	     websys_setfocus('birthdate');
	     return;
	 }else{
	 Birth_OnBlur();
	 var p2=birthdateobj.value
	 var p3=admdateobj.value
	 var getageobj=document.getElementById('getage');
	if (getageobj) {var encmeth=getageobj.value} else {var encmeth=''};
	var agestr=cspRunServerMethod(encmeth,p2,p3)
	var agestr1=agestr.split("^");
	
	ageobj.value=agestr1[0];
	ageyrobj.value=agestr1[1];
	agemthobj.value=agestr1[2];
	agedayobj.value=agestr1[3]; }
	
 }
 function getbirday()
 {var key=websys_getKey(e);
 if (key==13) {
    if (AgeFlag=="Y"){
	   return;
	}
    var p1=ageobj.value
    var getbirthday=document.getElementById('getbirthday');
    if (getbirthday) {var encmeth=getbirthday.value} else {var encmeth=''};
	var birstr=cspRunServerMethod(encmeth,p1)
    if (birthdateobj.value=="")
    {birthdateobj.value=birstr   }
	var p2=birthdateobj.value
	var getageobj=document.getElementById('getage');
	var p3=admdateobj.value
	if (getageobj) {var encmeth=getageobj.value} else {var encmeth=''};
	var agestr=cspRunServerMethod(encmeth,p2,p3)
	var agestr1=agestr.split("^");
	
	//ageobj.value=agestr1[0];
	ageyrobj.value=agestr1[1];
	agemthobj.value=agestr1[2];
	agedayobj.value=agestr1[3]; 	
	DHCWeb_Nextfocus();
 }
 }
 function GetRcptNo(value)
{  
    var sub = value.split("^")
	var rcptrowid=sub[0]
	if (rcptrowid=="")
	{
	   alert(t['24']);
	   return false
    }
	EndNo=sub[1]
	CurNo=sub[2]
	Title=sub[3]
	var obj=document.getElementById('currentno');
	obj.value=CurNo
}
 function getsex()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   sex_lookuphandler();
	   DHCWeb_Nextfocus();	
		}
	} 
function getmardesc()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   mardesc_lookuphandler();
	   DHCWeb_Nextfocus();
		}
	} 
function getrlgdesc()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   rlgdesc_lookuphandler();
	   DHCWeb_Nextfocus();
		}
	} 
function getzipcode()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   zipcode_lookuphandler();
	   DHCWeb_Nextfocus();
		}
	} 
function getadmdep()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   admdep_lookuphandler();
	   DHCWeb_Nextfocus();
		}
	} 
function getadmward()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   admward_lookuphandler();
	   DHCWeb_Nextfocus();
		}
	} 
function getadmdoc()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   admdoc_lookuphandler();
	   DHCWeb_Nextfocus();
		}
} 
function getadmreason()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   admreason_lookuphandler();
	   DHCWeb_Nextfocus();
		}
} 
function getadmepis()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   admepis_lookuphandler();
	   DHCWeb_Nextfocus();
		}
} 
function getadmryqk()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   admqingk_lookuphandler();
	   DHCWeb_Nextfocus();
		}
	} 
function getdeptype()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  deposittype_lookuphandler();
		}
	}
function getpy()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  paymode_lookuphandler();
	  elementformat()
    }  
}
function getbank()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  bank_lookuphandler();
	  DHCWeb_Nextfocus();
		}
	}
function enterbanksub(){
 	 var key=websys_getKey(e);
	if (key==13) {
	  DHCWeb_Nextfocus();	   
	}
  }
function getSocSat()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   SocSatdesc_lookuphandler();
	   DHCWeb_Nextfocus();	
		}
} 
function LookUpsex(str)
{
	var obj=document.getElementById('sexid');
	var tem=str.split("^");
	obj.value=tem[2];	
}
function nationlookup(str)
{   var obj=document.getElementById('nationid');
    var tem=str.split("^");
	obj.value=tem[1];
	}
function LookUpadmdep(str)
{
	var obj=document.getElementById('admdepid');
	var tem=str.split("^");
	obj.value=tem[1];	
}
function LookUpadmbed(str)
{var obj=document.getElementById('bedrowid');
 var obj1=document.getElementById('roomrowid');
 var tem=str.split("^");
 obj.value=tem[8];
 obj1.value=tem[7]; 
	}
function LookUpadmward(str)
{var obj=document.getElementById('admwardid');
	var tem=str.split("^");
	obj.value=tem[1];	
 
	}
function gettypeid(value)	{
	var val=value.split("^");
	var obj=document.getElementById('admreasonid');
	obj.value=val[1];

}
function getepisid(value)	{
	var val=value.split("^");
	var obj=document.getElementById('admepisid');
	obj.value=val[1];  	 
}
function ryqklookup(str)
{
 var obj=document.getElementById('admqkid');
 var tem=str.split("^");
 obj.value=tem[1]; 
}
function LookUpType(str)
{
	var obj=document.getElementById('deptype');
	var tem=str.split("^");
	obj.value=tem[1];
}
function LookUpPayMode(str)
{
	var obj=document.getElementById('moderowid');
	var tem=str.split("^");
	obj.value=tem[1];
	if (pyobj.value==t['02']){
		 websys_setfocus('BtnPrint');
	 }else{
		 elementformat()
	     websys_setfocus('bank');
	 }
}
function LookUpBank(str)
{
	var obj=document.getElementById('bankrowid');
	var tem=str.split("^");
	obj.value=tem[1];
}
function mardesclookup(str)
{
	var obj=document.getElementById('mardescid');
	var tem=str.split("^");
	obj.value=tem[1];	
}
function rlgdesclookup(str)
{
	var obj=document.getElementById('rlgdescid');
	var tem=str.split("^");
	obj.value=tem[1];	
}
function admdoclookup(str)
{
	var obj=document.getElementById('admdocid');
	var tem=str.split("^");
	obj.value=tem[1];	
}
function admrealookup(str)
{
	var obj=document.getElementById('admreasonid');
	var tem=str.split("^");
	obj.value=tem[1];
	var p1=obj.value
	var getsocsatobj=document.getElementById('getSocSatid');
	if (getsocsatobj) {var encmeth=getsocsatobj.value} else {var encmeth=''};
	var socsatstr=cspRunServerMethod(encmeth,p1) 
	var socsatstr1=socsatstr.split("^")
	if (opcardnoobj.value!=""){
	   if ((SocSatidobj.value=="")||(SocSatidobj.value!=socsatstr1[0])){
		SocSatidobj.value=socsatstr1[0]
		SocSatdescobj.value=socsatstr1[1]
		}}	
}
function gettoday()
{   var stdatetimeobj=document.getElementById("getdatetime");
	if (stdatetimeobj) {var encmeth=stdatetimeobj.value} else {var encmeth=''};
	var stdatetime=cspRunServerMethod(encmeth) 
    if (stdatetime!=""){
	    var str1=stdatetime.split("^")
	    admdateobj.value=str1[0];
	    admtimeobj.value=str1[1];
	    if (PatinFlag=="Y"){
	       admdateobj.readOnly=true;
	       admtimeobj.readOnly=true;
	    }else{
		   admdateobj.readOnly=false;	       
		}  
	}	
}
function getcurdate()
{var d=new Date();
 curday=d.getDate()
 curmon=d.getMonth()+1
 curyear=d.getYear();
	}
function ZipLookupSelect(str) {	
 	var lu = str.split("^");
	var obj1=document.getElementById("zipcode")
	if (obj1) obj1.value = lu[1];
 	var obj=document.getElementById("cityarea")
 	if (obj) obj.value = lu[2]
 	var obj=document.getElementById("CTCITDesc")
	if (obj) obj.value = lu[3];
	var obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[4];
	if (lu[5]=="0"){
        lu[5]=""	
	}	
	var obj=document.getElementById("zipid")
	if (obj) obj.value = lu[5];
	var obj=document.getElementById("cityareaid")
	if (obj) obj.value = lu[6];
	var obj=document.getElementById("cityid")
	if (obj) obj.value = lu[7];
	var obj=document.getElementById("provid")
	if (obj) obj.value = lu[8];				
}
function CityLookupSelect(str) {
        
	var lu = str.split("^");
	var obj1=document.getElementById("CTCITDesc")
	if (obj1) obj1.value = lu[0];
	var obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[1];
	if (lu[2]=="0"){
	   lu[2]=""}
	var obj1=document.getElementById("cityid")
	if (obj1) obj1.value = lu[2];
	var obj=document.getElementById("provid")
	if (obj) obj.value = lu[3];	
	var obj1=document.getElementById("zipcode")
	if (obj1) obj1.value="";
	var obj=document.getElementById("zipid")
	if (obj) obj.value="";	
}
function ProvinceLookupSelect(str) {
 	var lu = str.split("^");
	var obj=document.getElementById("PROVDesc")
	if (obj) obj.value = lu[0];
	if (lu[1]=="0"){
	   lu[1]=""
	}
	var obj=document.getElementById("provid")
	if (obj) obj.value = lu[1];
	var obj1=document.getElementById("zipcode")
	if (obj1) obj1.value="";
	var obj=document.getElementById("zipid")
	if (obj) obj.value="";
	var obj=document.getElementById("CTCITDesc")
	if (obj) obj.value="";
	var obj=document.getElementById("cityid")
	if (obj) obj.value="";
			
}
function LookUpadmsearch(str)
{  var tmp1 = str.split("^");
   admsearchobj.value=tmp1[0]  , admidobj.value=tmp1[9]
   admvisitobj.value=tmp1[8]  
   admdateobj.value=tmp1[3],      admtimeobj.value=tmp1[4] 
   var p2=tmp1[9]
   var getadminfo=document.getElementById("getadminfo")
   if (getadminfo) {var encmeth=getadminfo.value} else {var encmeth=''};
   var adminfo=cspRunServerMethod(encmeth,p2)
   var adminfo1=adminfo.split("^");
   if (adminfo1[0]=="-1"){
	   alert(t['42']);
	   return;}
   else if (adminfo1[0]=="-2"){
	   alert(t['43']);
	   return;}
   else{
   var depstr=adminfo1[1].split("@");	   
   admdepobj.value=depstr[1],       admdepidobj.value=depstr[0]
   var wardstr=adminfo1[2].split("@");
   admwardobj.value=wardstr[1],      admwardidobj.value=wardstr[0]
   var docstr=adminfo1[5].split("@");
   admdocobj.value=docstr[1],       admdocidobj.value=docstr[0]
   var reastr=adminfo1[6].split("@");
   admreasonobj.value=reastr[1],    admreaidobj.value=reastr[0]
   var episstr=adminfo1[7].split("@");
   admepisobj.value=episstr[1],      admepisidobj.value=episstr[0]
   var bedstr=adminfo1[4].split("@");
   bedobj.value=bedstr[1] ,         bedidobj.value=bedstr[0]
   var roomstr=adminfo1[3].split("@");
   roomobj.value=roomstr[1],         roomidobj.value=roomstr[0]
   var ryqkstr=adminfo1[8].split("@");
   admqkobj.value=ryqkstr[1]  ,      admqkidobj.value=ryqkstr[0]
   usernameobj.value=adminfo1[9]
   AdmTimesobj.value=adminfo1[10]
   var admrefdocstr=adminfo1[11]
   
   if (adminfo1[11]!=""){
    var RefDocListdrobj=document.getElementById('RefDocListdr');
    var RefDocListobj=document.getElementById('RefDocList');
    var admrefdocstr=adminfo1[11].split("@");
    RefDocListdrobj.value=admrefdocstr[0];
    RefDocListobj.value=admrefdocstr[1];      
   } 
   }    
   elementformat1()
}
function SocSatlookup(str)
{var tmp1 = str.split("^");
 SocSatidobj.value=tmp1[1]
}
function getpatinfo(){
	var key=websys_getKey(e);
	if (key==13) {
	getpatinfo1()
    if (countryobj.value==""){
      countryobj.value=t['65']
      var getcountryidobj=document.getElementById("getcountryid")
	  if (getcountryidobj) {var encmeth=getcountryidobj.value} else {var encmeth=''};
	  var getcountryid=cspRunServerMethod(encmeth,'','',t['65']);
	  countryidobj.value=getcountryid}
    if (nationdescobj.value==""){
       nationdescobj.value=t['66']
       var getnationidobj=document.getElementById("getnationid")
	   if (getnationidobj) {var encmeth=getnationidobj.value} else {var encmeth=''};
	   var getnationid=cspRunServerMethod(encmeth,'','',t['66']);
	   nationidobj.value=getnationid}
	}	
}
function getpatinfo1()
{ //if (papnoobj.value==""){
	//	alert(t['07']);
	//	return;}
	var p1=papnoobj.value;
	var p2=medicareobj.value
	var getpatinfo=document.getElementById("getpatinfo")
	if (getpatinfo) {var encmeth=getpatinfo.value} else {var encmeth=''};
	var str=cspRunServerMethod(encmeth,p1,p2);
	
	if (str!=""){
		var str1=str.split("^");
		if (str1[0]=="-1"){
			alert(t['07']);
		    return;
		}else if (str1[0]=="-2"){
			alert(t['08']);
			papnoobj.value="";
		    return;
		}else{
		 papmiidobj.value=str1[0], papnoobj.value=str1[2];
		 papnameobj.value=str1[3], medicareobj.value=str1[4];
		 var sexstr=str1[5].split("@");
		 SexObj.value=sexstr[1] , sexidobj.value=sexstr[0];
		 paperidobj.value=str1[6];		 
		 birthdateobj.value=str1[7], ageobj.value=str1[8] ;
		 var marstr=str1[9].split("@");
		 mardescobj.value=marstr[1], mardescidobj.value=marstr[0];
		 var rlgstr=str1[10].split("@");
		 rlgdescobj.value=rlgstr[1], rlgdescidobj.value=rlgstr[0];
		 addressobj.value=str1[11], companyobj.value=str1[14];
		 hometelobj.value=str1[12], worktelobj.value=str1[15];
		 var zipstr=str1[13].split("@");
		 zipcodeobj.value=zipstr[1], zipidobj.value=zipstr[0];
		 var provstr=str1[16].split("@"); 
		 provdescobj.value=provstr[1], providobj.value=provstr[0];
		 emailobj.value=str1[17], mobtelobj.value=str1[18];
		 var citystr=str1[19].split("@");
		 cityobj.value=citystr[1], cityidobj.value=citystr[0]; 
		 admidobj.value=str1[20], admsearchobj.value=str1[21];
		 admvisitobj.value=str1[22] ;
		 var deptstr=str1[23].split("@");
		 admdepobj.value=deptstr[1],admdepidobj.value=deptstr[0];
		 var wardstr=str1[24].split("@");
		 admwardobj.value=wardstr[1],admwardidobj.value=wardstr[0];
		 var bedstr=str1[25].split("@");
		 bedobj.value=bedstr[1],bedidobj.value=bedstr[0];
		 var roomstr=str1[32].split("@");
		 roomobj.value=roomstr[1],roomidobj.value=roomstr[0];
		 var docstr=str1[26].split("@");
		 admdocobj.value=docstr[1],admdocidobj.value=docstr[0];
		 var admreastr=str1[27].split("@");
		 admreasonobj.value=admreastr[1],admreaidobj.value=admreastr[0];
		 var admepisstr=str1[28].split("@");
		 admepisobj.value=admepisstr[1],admepisidobj.value=admepisstr[0];
		 admdateobj.value=str1[29],admtimeobj.value=str1[30];
		 usernameobj.value=str1[31];
		 var socsatstr=str1[33].split("@");
		 SocSatdescobj.value=socsatstr[1],SocSatidobj.value=socsatstr[0]
		 var admryqkstr=str1[34].split("@");
		 admqkobj.value=admryqkstr[1],admqkidobj.value=admryqkstr[0]
		 var nationstr=str1[35].split("@");
		 nationdescobj.value=nationstr[1],nationidobj.value=nationstr[0]
		 var cardtypestr=str1[36].split("@");
		 cardtypeobj.value=cardtypestr[1],cardtypeidobj.value=cardtypestr[0]
		 govcardnoobj.value=str1[37]
		 var countrystr=str1[38].split("@");
		 countryobj.value=countrystr[1],countryidobj.value=countrystr[0]
		 var occustr=str1[39].split("@");
		 occuobj.value=occustr[1],occuidobj.value=occustr[0]
		 var edustr=str1[40].split("@");
		 eduobj.value=edustr[1],eduidobj.value=edustr[0]
		 var langustr=str1[41].split("@");
		 languobj.value=langustr[1],languidobj.value=langustr[0]
		 var emptypestr=str1[42].split("@");
		 emptypeobj.value=emptypestr[1], emptypeidobj.value=emptypestr[0]
		 var hplacestr=str1[43].split("@");
		 homeplaceobj.value=hplacestr[0],bircityobj.value=hplacestr[1]
		 birprovobj.value=hplacestr[2]
		 var ctrltstr=str1[45].split("@");
		 ctrltdescobj.value=ctrltstr[1],ctrltidobj.value=ctrltstr[0]
		 ForeignIdobj.value=str1[44],FPhoneobj.value=str1[46]
		 FAddressobj.value=str1[47],FNotesobj.value=str1[48]
		 AdmTimesobj.value=str1[49]
		 var cityareastr=str1[50].split("@");
		 cityareaobj.value=cityareastr[1],cityareaidobj.value=cityareastr[0]
		 var pycodeobj=document.getElementById('pycode');
         pycodeobj.value=str1[51]
		 var dig1str=str1[52].split("@")
		 diagnosobj.value=dig1str[1],diagnosidobj.value=dig1str[0]
		 var dig2str=str1[53].split("@")
		 digtypeobj.value=dig2str[1],digtypeidobj.value=dig2str[0]
		 diagnosdescobj.value=str1[54]
		 
		 if (str1[55]!="")  {
		    var agehourobj=document.getElementById('agehour');
            var ageMinutesobj=document.getElementById('ageMinutes');
		    babybirobj.value=str1[56]
		    agehourobj.value=str1[57] 
		    ageMinutesobj.value=str1[58]
		 }
		
		 if (str1[59]!=""){
		    var refdocstr=str1[59].split("@")
		    var RefDocListdrobj=document.getElementById('RefDocListdr');
            var RefDocListobj=document.getElementById('RefDocList');
            RefDocListdrobj.value=refdocstr[0]
            RefDocListobj.value=refdocstr[1]            
		 }
		 
		 if (str1[20]==""){
			 clearadm_click()			 
		 }
		 if (str1[22]!=t['16']){
			 clearadm_click()
		 }
		 }		
	}
	elementformat1()
	websys_setfocus('name');
	//DHCWeb_Nextfocus()
	}
function Birth_OnBlur(){
	var mybirth=DHCWebD_GetObjValue("birthdate");
	if ((mybirth=="")||((mybirth.length!=8)&&((mybirth.length!=10)))){
		var obj=document.getElementById("birthdate");
		obj.className='clsInvalid';
		websys_setfocus("birthdate");
		return websys_cancel();
	}else{
		var obj=document.getElementById("birthdate");
		obj.className='clsvalid';
	}
	if ((mybirth.length==8)){
		var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8)
		DHCWebD_SetObjValueA("birthdate",mybirth);
	}
	////alert(mybirth);
	var myrtn=DHCWeb_IsDate(mybirth,"-")
	if (!myrtn){
		var obj=document.getElementById("birthdate");
		obj.className='clsInvalid';
		websys_setfocus("birthdate");
		return websys_cancel();
	}else{
		var obj=document.getElementById("birthdate");
		obj.className='clsvalid';
	}	
}
function regsave_click()
{
  clear_lookup()  
  /*modify by cx 2007.12.12
  if (newcardnoobj.value==""){
     alert(t['HXEY08']);
     return;
  }else{     
     var lnewcardno=newcardnoobj.value.length
     if (eval(lnewcardno)!=10){
	     alert(t['HXEY10']);
	     return;
     }
     var p1=newcardnoobj.value  
	 var getnewcardinfo=document.getElementById("getnewcardinfo")
	 if (getnewcardinfo) {var encmeth=getnewcardinfo.value} else {var encmeth=''}; 
     var newcardinfo=cspRunServerMethod(encmeth,p1)
     if (newcardinfo!=""){
	    var tmp=newcardinfo.split("^");
	    if (papmiidobj.value==""){
		   alert(t['HXEY09']); 
	       papnoobj.value=tmp[2]
	       getpatinfo1()	    
	       return; }
	     if ((papmiidobj.value!="")&&(papmiidobj.value!=tmp[1])){
		   alert(t['HXEY12']);
		   newcardnoobj.value=""
    		   return; 
		 }    
	 }
	   
  }
  */
  if (countryobj.value==""){
      countryobj.value=t['65']
      var getcountryidobj=document.getElementById("getcountryid")
	  if (getcountryidobj) {var encmeth=getcountryidobj.value} else {var encmeth=''};
	  var getcountryid=cspRunServerMethod(encmeth,'','',t['65']);
	  countryidobj.value=getcountryid}
    if (nationdescobj.value==""){
       nationdescobj.value=t['66']
       var getnationidobj=document.getElementById("getnationid")
	   if (getnationidobj) {var encmeth=getnationidobj.value} else {var encmeth=''};
	   var getnationid=cspRunServerMethod(encmeth,'','',t['66']);
	   nationidobj.value=getnationid}   	
  if (papnameobj.value==""){
	  alert(t['12']);
	  return;}
  if ((SexObj.value=="")||(sexidobj.value=="")){
	  alert(t['13']);
	  return;}
  if ((admdepobj.value=="")||(admdepidobj.value=="")){
	  alert(t['55']);
	  return;}
  if ((admwardobj.value=="")||(admwardidobj.value=="")){
	  alert(t['10']);
	  return;}
  if ((admreasonobj.value=="")||(admreaidobj.value=="")){
	  alert(t['11']);
	  return;}
  if (admvisitobj.value==t['16']){
	  alert(t['14']);
	  return}
  if (PapnoFlag=="Y"){
     if ((papmiidobj.value=="")&(papnoobj.value=="")){
	  alert(t['64'])
	  return;}	  
  }
  //yyx
  var patstatus=document.getElementById("getpatstatus");
  if (patstatus) {var encmeth=patstatus.value} else {var encmeth=''};
  var qfstatus=cspRunServerMethod(encmeth,papnoobj.value) 
  if (qfstatus=="-1")
  { var trueorfalse=window.confirm(t['67'])
  if (!trueorfalse) {return} 
  }   
  if (qfstatus=="-2")
  { var trueorfalse=window.confirm(t['68'])
  if (!trueorfalse) {return} 
  }  
  //insert by cx 2007.05.21 insert pycode
  var pycode=document.getElementById("pycode").value;  	  	  	  	  	  
  var RefDocListdrobj=document.getElementById('RefDocListdr');
  var p1=papmiidobj.value+"^"+papnameobj.value+"^"+medicareobj.value+"^"+sexidobj.value
  p1=p1+"^"+paperidobj.value+"^"+birthdateobj.value+"^"+ageobj.value+"^"+ageyrobj.value
  p1=p1+"^"+agemthobj.value+"^"+agedayobj.value+"^"+mardescidobj.value+"^"+rlgdescidobj.value
  p1=p1+"^"+addressobj.value+"^"+hometelobj.value+"^"+zipidobj.value+"^"+companyobj.value
  p1=p1+"^"+worktelobj.value+"^"+providobj.value+"^"+emailobj.value+"^"+mobtelobj.value
  p1=p1+"^"+cityidobj.value+"^"+SocSatidobj.value+"^"+nationidobj.value
  p1=p1+"^"+cardtypeidobj.value+"^"+govcardnoobj.value+"^"+countryidobj.value+"^"+occuidobj.value
  p1=p1+"^"+eduidobj.value+"^"+languidobj.value+"^"+emptypeidobj.value+"^"+birprovobj.value
  p1=p1+"^"+bircityobj.value+"^"+ctrltidobj.value+"^"+ForeignIdobj.value+"^"+FPhoneobj.value
  p1=p1+"^"+FAddressobj.value+"^"+FNotesobj.value+"^"+cityareaidobj.value+"^"+pycode+"^"+babydob1+"^"+babydob2
  p1=p1+"^"+Medicareflag+"^"+newcardnoobj.value+"^"+RefDocListdrobj.value
  
  var p2=admdepidobj.value+"^"+admwardidobj.value+"^"+roomidobj.value+"^"+bedidobj.value+"^"+admdocidobj.value
  p2=p2+"^"+admreaidobj.value+"^"+admepisidobj.value
  p2=p2+"^"+admdateobj.value+"^"+admtimeobj.value+"^"+Guser+"^"+admqkidobj.value+"^"+""+"^"+diagnosidobj.value+"^"+diagnosdescobj.value+"^"+digtypeidobj.value+"^"+digtypeobj.value
  //var myCardInfo=RegNoObj.value+"^"+PatientID+"^"+IDCardNo1Obj.value+"^"+CardNoObj.value+"^"+CardVerify+"^"+""+"^"+""+"^"+Guser+"^"+computername+"^"+CardID+"^"+mySecrityNo;
  if (opcardid!=""){
  var p3=papnoobj.value+"^"+papmiidobj.value+"^"+paperidobj.value+"^"+opcardnoobj.value+"^"+cardCheckNo+"^"+""+"^"+""+"^"+Guser+"^"+computername+"^"+opcardid+"^"+cardCheckNo;
  }else{ 
  p3=""
  }
  //return;
  var addpatinfo=document.getElementById("addpatinfo");
  if (addpatinfo) {var encmeth=addpatinfo.value} else {var encmeth=''};
  var tmp=cspRunServerMethod(encmeth,'','',p1,p2,p3)  
  var tmp1=tmp.split("^");
  if (tmp1[0]=="paterror"){
	  alert(t['38']);
	  return;}
  else if (tmp1[0]=="admerr"){
	  alert(t['14']);
	  return;
	  }
  else if (tmp1[0]=="admdep"){
	  alert(t['35']);
	  return;}
  else if (tmp1[0]=="admward"){
	  alert(t['36']);
	  return;}
  else if (tmp1[0]=="admreadr"){
	  alert(t['37']);
	  return;}
  else if (tmp1[0]=="beddiff"){
	  alert(t['39']);
	  return;}
  else if (tmp1[0]=="opcarderror"){
	  alert(t['46']);
	  return;}
  else if (tmp1[0]=="0"){
    if (papmiidobj.value!=""){
	    admidobj.value=tmp1[3];
	    admvisitobj.value=tmp1[5];
	    admsearchobj.value=tmp1[4];
	    medicareobj.value=tmp1[6];
	    elementformat1()
	    alert(t['27']);
	  }else{
	    papnoobj.value=tmp1[1];
	    papmiidobj.value=tmp1[2];
	    admidobj.value=tmp1[3]
	    admvisitobj.value=tmp1[5];
	    admsearchobj.value=tmp1[4];
	    medicareobj.value=tmp1[6];
	    elementformat1()
	    alert(t['27']);
		  }
	  }	 
	 var adminfo=papnoobj.value+"^"+papnameobj.value+"^"+admdateobj.value+"^"+SexObj.value
	 adminfo=adminfo+"^"+hometelobj.value+"^"+ mardescobj.value+"^"+ageobj.value+"^"+addressobj.value
	 adminfo=adminfo+"^"+medicareobj.value+"^"+companyobj.value
	// Printadminfo(adminfo)
	// websys_setfocus('payamt');	   
	}  
  function clear_click()
  {clearpat_click()
   clearadm_click()
   if (DepositFlag=="Y"){   
   getyjinfo()}
   if (PapnoFlag=="N"){
      websys_setfocus('name');
      //websys_setfocus('newcardno');
       }
   if (PapnoFlag=="Y"){
      websys_setfocus('Regno');}       
 }
function Add_click()	
{ Adm=admidobj.value
  if (deposittypeobj.value==""){deptypeobj.value=""}
  if (pyobj.value==""){moderowidobj.value=""}
  if (bankobj.value==""){bankrowidobj.value=""}
	
	if (Adm==""){
		alert(t['25']);
		return;}
	if (PrtFlag=="Y")
    { alert(t['20']);
      return;}
	var deptype=document.getElementById('deptype').value;
	if (deptype=="") {
		alert(t['21']);
		return;}
    var payamt=document.getElementById('payamt').value;
    if ((payamt=="")||(!payamt)) {
		alert(t['22']);
		return;}
	var moderowid=document.getElementById('moderowid').value;
    if (moderowid=="") {
		alert(t['23']);
		return;}	
	if (CurNo=="")
	{
	   alert(t['24']);
	   return ;
    }
    var deptcomp=document.getElementById('deptcomp').value;
    var bankrowid=document.getElementById('bankrowid').value;
    var cardno=document.getElementById('cardno').value;
    //var authno=document.getElementById('authno').value;
    var authno=""
    var banksub=document.getElementById('banksub').value;
    var Add=document.getElementById('Add');
	if (Add) {var encmeth=Add.value} else {var encmeth=''};
	var dep=deptype+"^"+payamt+"^"+moderowid+"^"+deptcomp+"^"+bankrowid+"^"+cardno+"^"+authno+"^"+Adm+"^"+CurNo+"^"+UserLoc+"^"+Guser+"^"+EndNo+"^"+Title+"^"+banksub
	if (cspRunServerMethod(encmeth,'SetPid','',dep)=='0') {
			}    
}
function SetPid(value) 
{   var sub
    var str=value.split("^")
    var retcode=str[0]
    var yjrowid=str[1]
    var rcptrowid=str[2]
	if ((retcode!="0")&(retcode!="100"))
	{alert(t['26']);
	return;}
	if (retcode=="100"){
     alert(t['30']);
    }
	if (retcode=="0") 
	{	//alert(t['30']);
		PrtFlag="Y"
		var yjdetail=document.getElementById('getyjdetail');
		if (yjdetail) {var encmeth=yjdetail.value} else {var encmeth=''};
		returnval=cspRunServerMethod(encmeth,'','',yjrowid);
		printYJ()
		if (AbortYJprtFlag=="Y"){
		   var truthBeTold = window.confirm(t['59']);
           if (!truthBeTold) {
	          if (RcptFlag=="Y")
	             {var rcptno=document.getElementById('getrcptno');
	             if (rcptno) {var encmeth=rcptno.value} else {var encmeth=''};
	             if (cspRunServerMethod(encmeth,'GetRcptNo','',Guser)=='0') {
			     } 
	          }
	          PrtFlag="N"	          
	          abort(yjrowid,rcptrowid)     
	       }
	       if (truthBeTold){
		     clear_click()
		   }    
	   }
	   if (AbortYJprtFlag=="N"){
	     clear_click()
	   }
		//getyjinfo()
		if (PapnoFlag=="N"){
          websys_setfocus('name'); }
        if (PapnoFlag=="Y"){
          websys_setfocus('Regno');}		
	}	
}
function getyjinfo()
{
   PrtFlag="N"
   deposittypeobj.value="",  deptypeobj.value=""
   pyobj.value="",           moderowidobj.value=""
   bankobj.value="",         bankrowidobj.value=""   
   banksubobj.value="",      cardnoobj.value=""   
   deptcompobj.value=""
   document.getElementById('deposittype').value=t['01'];
   var typeid=document.getElementById('gettyperowid');
   if (typeid) {var encmeth=typeid.value} else {var encmeth=''};
   var tmp=cspRunServerMethod(encmeth,'','',t['01'])
   document.getElementById('deptype').value=tmp

   document.getElementById('paymode').value=t['02']
   var modeid=document.getElementById('getpaymodeid');
   if (modeid) {var encmeth=modeid.value} else {var encmeth=''};
   var tmp1=cspRunServerMethod(encmeth,'','')
   document.getElementById('moderowid').value=tmp1    
   document.getElementById('currentno').readOnly=true;
   var payamtobj=document.getElementById('payamt');
   payamtobj.value=""
   elementformat()
   if (RcptFlag=="Y")
	{var rcptno=document.getElementById('getrcptno');
	if (rcptno) {var encmeth=rcptno.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'GetRcptNo','',Guser)=='0') {
			} 
	}	
}
function yjsearch_click()
{  Adm=admidobj.value
	if (Adm==""){
		alert(t['25']);
		return;}
   var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFFindDeposit&Adm='+Adm
          window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0')
 
 }
 function elementformat1()
 { var imgname
   var Myobj=document.getElementById('Myid');
   if (Myobj){   
   imgname="ld"+Myobj.value+"i"+"admdep"
   var admdep1obj=document.getElementById(imgname);
   imgname="ld"+Myobj.value+"i"+"admward"
   var admward1obj=document.getElementById(imgname);
   //imgname="ld"+Myobj.value+"i"+"admbedno"
  // var admbedno1obj=document.getElementById(imgname);
   imgname="ld"+Myobj.value+"i"+"admdoc"
   var admdoc1obj=document.getElementById(imgname);     
   if (admidobj.value!=""){
     admdep1obj.style.display="none";
	 admdepobj.readOnly=true;
	 admward1obj.style.display="none";
	 admwardobj.readOnly=true;
	 //admbedno1obj.style.display="none";
	 //bedobj.readOnly=true;
	 admdoc1obj.style.display="none";
	 admdocobj.readOnly=true;
	 }else{
	 admdep1obj.style.display="";
	 admdepobj.readOnly=false;
	 admward1obj.style.display="";
	 admwardobj.readOnly=false;
	// admbedno1obj.style.display="";
	// bedobj.readOnly=false;
	 admdoc1obj.style.display="";
	 admdocobj.readOnly=false;	 
		 }	 
	 }
	 }
function admfin_click()
{var stdatetimeobj=document.getElementById("getdatetime");
 if (stdatetimeobj) {var encmeth=stdatetimeobj.value} else {var encmeth=''};
 var stdatetime=cspRunServerMethod(encmeth) 
 var str1=stdatetime.split("^")
 var stdate=str1[0]
 var datestr=stdate.split("-")
 var stdate1=datestr[2]+"/"+datestr[1] +"/"+datestr[0]
 var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFinfro=&stdate='+stdate1+'&enddate='+stdate1+'&stdate1='+stdate+'&enddate1='+stdate
 window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=900,height=650,left=0,top=0')
	}
function readcard_click()
{ clear_click()
  var rtn=DHCACC_GetAccInfo()
  var str=rtn.split("^")
  if ((str[0]=="0")||(str[0]=="-201")){
	  papnoobj.value=str[5]
	  papmiidobj.value=str[4]
	  cardCheckNo=str[2]
	  opcardnoobj.value=str[1]
	  getpatinfo1()
	  }
  if (str[0]=="-200"){
	  cardCheckNo=str[2]
	  opcardnoobj.value=str[1]
	  getpatbycard()
	  }	  
	}
function clearadm_click()
{admsearchobj.value="",    admidobj.value=""
   admvisitobj.value=""
   admdepobj.value="",       admdepidobj.value=""
   admwardobj.value="",      admwardidobj.value=""
   admdocobj.value="",       admdocidobj.value=""
   admreasonobj.value="",    admreaidobj.value=""
   admepisobj.value="",      admepisidobj.value=""
   bedobj.value="" ,         bedidobj.value=""
   roomobj.value="",         roomidobj.value=""
   admdateobj.value="",      admtimeobj.value="" 
   admqkobj.value=""  ,      admqkidobj.value=""
   AdmTimesobj.value="" 
   diagnosobj.value="",      diagnosidobj.value=""
   diagnosdescobj.value=""
   gettoday()   
   admqkobj.value=t['58']
   var p1=admqkobj.value
   var getryqkid=document.getElementById('getryqk');
   if (getryqkid) {var encmeth=getryqkid.value} else {var encmeth=''};
   var tmp2=cspRunServerMethod(encmeth,p1)
   admqkidobj.value=tmp2
   usernameobj.value=gusername
   AdmTimesobj.readOnly=true
   digtypeobj.value=t['HXEY04']
   var getdigtypeid=document.getElementById('getdigtypeid');
   if (getdigtypeid) {var encmeth=getdigtypeid.value} else {var encmeth=''};
   var tmp3=cspRunServerMethod(encmeth,'','',t['HXEY04'])
   if (tmp3!=""){
	   var tmp3str=tmp3.split("^");
	   digtypeobj.value=tmp3str[1]
	   digtypeidobj.value=tmp3str[0]}
    var RefDocListdrobj=document.getElementById('RefDocListdr');
    var RefDocListobj=document.getElementById('RefDocList');
    RefDocListdrobj.value="",RefDocListobj.value=""
   elementformat1() 
}
function clearpat_click(){
   opcardid=""
   opcardnoobj.value=""
   papnoobj.value="",       papmiidobj.value=""
   papnameobj.value="",      medicareobj.value=""
   SexObj.value=""    ,      sexidobj.value=""
   paperidobj.value="" ,     birthdateobj.value=""
   ageobj.value=""   
   mardescobj.value="" ,     mardescidobj.value=""
   rlgdescobj.value="",      rlgdescidobj.value=""
   addressobj.value="",      hometelobj.value=""
   zipcodeobj.value="",      zipidobj.value=""
   companyobj.value="",      worktelobj.value=""
   cityobj.value=""  ,       cityidobj.value=""
   provdescobj.value="",     providobj.value=""
   mobtelobj.value="",       emailobj.value=""
   ageyrobj.value="",        agemthobj.value=""
   agedayobj.value=""  
   SocSatdescobj.value="" ,  SocSatidobj.value=""
   nationdescobj.value="",   nationidobj.value=""
   cardtypeobj.value="",     cardtypeidobj.value=""
   govcardnoobj.value=""
   countryobj.value="",      countryidobj.value=""
   occuobj.value="",         occuidobj.value=""
   eduobj.value="",          eduidobj.value=""
   languobj.value="",        languidobj.value=""
   emptypeobj.value="",      emptypeidobj.value=""
   homeplaceobj.value="",    birprovobj.value=""
   bircityobj.value=""
   ctrltdescobj.value="",    ctrltidobj.value=""
   ForeignIdobj.value="",    FPhoneobj.value=""
   FAddressobj.value="",     FNotesobj.value=""
   cityareaobj.value="",     cityareaidobj.value=""
   var pycodeobj=document.getElementById('pycode');
   pycodeobj.value="",       babybirobj.value=""
   var agehourobj=document.getElementById('agehour');
   var ageMinutesobj=document.getElementById('ageMinutes');
   agehourobj.value="",      ageMinutesobj.value=""
   newcardnoobj.value=""
}
function regupdate_click()
{ clear_lookup()
 if ((papnameobj.value=="")||(papmiidobj.value=="")){
	alert(t['39']);
	return;}
 var p1=papmiidobj.value
 var pycodeobj=document.getElementById('pycode');
 var p2=papnameobj.value+"^"+medicareobj.value+"^"+sexidobj.value+"^"+paperidobj.value+"^"+birthdateobj.value
 p2=p2+"^"+ageobj.value+"^"+ageyrobj.value+"^"+agemthobj.value+"^"+agedayobj.value+"^"+mardescidobj.value
 p2=p2+"^"+rlgdescidobj.value+"^"+addressobj.value+"^"+hometelobj.value+"^"+zipidobj.value
 p2=p2+"^"+companyobj.value+"^"+worktelobj.value+"^"+cityidobj.value+"^"+providobj.value+"^"+mobtelobj.value+"^"+emailobj.value+"^"+Guser+"^"+SocSatidobj.value+"^"+nationidobj.value 
 p2=p2+"^"+cardtypeidobj.value+"^"+govcardnoobj.value+"^"+countryidobj.value+"^"+occuidobj.value
 p2=p2+"^"+eduidobj.value+"^"+languidobj.value+"^"+emptypeidobj.value+"^"+birprovobj.value
 p2=p2+"^"+bircityobj.value+"^"+ctrltidobj.value+"^"+ForeignIdobj.value+"^"+FPhoneobj.value
 p2=p2+"^"+FAddressobj.value+"^"+FNotesobj.value+"^"+cityareaidobj.value+"^"+pycodeobj.value+"^"+babydob1+"^"+babydob2
 
 var p3=admidobj.value
 var getupreginfo=document.getElementById('getupreginfo');
 if (getupreginfo) {var encmeth=getupreginfo.value} else {var encmeth=''};
 var tmp2=cspRunServerMethod(encmeth,'','',p1,p2,p3)
 
 return tmp2 
}
function admupdate_click()
{var tmp2
 tmp2=0
 tmp2=regupdate_click();
 
 clear_lookup()
 if (admidobj.value==""){
	alert(t['42']);
	return;}
 var RefDocListdrobj=document.getElementById('RefDocListdr');
 var p1=admidobj.value
 var p2=admreaidobj.value+"^"+admepisidobj.value+"^"+admqkidobj.value+"^"+Guser+"^"+RefDocListdrobj.value    //modufy by cx 2007.12.12
 
 var p3=papmiidobj.value
 var getupadminfo=document.getElementById('getupadminfo');
 if (getupadminfo) {var encmeth=getupadminfo.value} else {var encmeth=''};
 
 var tmp3=cspRunServerMethod(encmeth,'','',p1,p2,p3)
 
 if ((tmp2=="patvalno")&&(tmp3=="admvalno")){
	 alert(t['44']);
	 return;}
 if ((tmp2=="patiderror")||(tmp2=="patvalerror")){
	alert(t['39']);
	return; }
 else{
	if ((tmp3=="admiderror")||(tmp3=="admvalerror")){
	alert(t['43']);
	return; }
 }
 if ((tmp2=="0")||(tmp2=="patvalno")){
    if ((tmp3=="0")||(tmp3=="admvalno")){
	alert(t['56']);
	clear_click();
	}else{
	alert(t['57']);
	return;	
		}
	}	
}
function patupsearch_click()
{var stdatetimeobj=document.getElementById("getdatetime");
 if (stdatetimeobj) {var encmeth=stdatetimeobj.value} else {var encmeth=''};
 var stdatetime=cspRunServerMethod(encmeth) 
 var str1=stdatetime.split("^")
 var stdate=str1[0]
 var datestr=stdate.split("-")
 var stdate1=datestr[2]+"/"+datestr[1] +"/"+datestr[0]
 
 var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFUpPatInfo&stdate='+stdate+'&enddate='+stdate+'&stdate1='+stdate1+'&enddate1='+stdate1+'&username='+gusername+'&userid='+Guser
 //var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFUpPatInfo'
 window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=780,height=520,left=0,top=0')
	}
function getpatbycard()
{
	if (opcardnoobj.value=="") {alert("no card no");return;}
	var encmeth=DHCWebD_GetObjValue("getpatbyCardNoClass");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,opcardnoobj.value,cardCheckNo);
		var myary=rtn.split("^");
		//rtn_"^"_RegNo_"^"_Papmi_"^"_name_"^"_CardNo_"^"_SecurityNO_"^"_CardID
		if (myary[0]=='0')
		{
			papnoobj.value=myary[1]
			papmiidobj.value=myary[2]
			papnameobj.value=myary[3]
			//cardCheckNo=myary[5]
			opcardid=myary[6]
			if (PapnoFlag=="N"){
              websys_setfocus('name') }
            if (PapnoFlag=="Y"){
              websys_setfocus('Regno')}
		}
		else
		{
			if (myary[0]=='-341')
			{alert(t[2024]);}
			if (myary[0]=='-340')
			{alert(t[2003]);}
			
			//Clear_click();
		}
	}
	}
function admcancel_click()
{if (papmiidobj.value==""){
	alert(t['47']);
	return;
	}
 if (admidobj.value==""){
	 alert(t['42']);
	 return;}
 if (admvisitobj.value==""){
	 alert(t['48']);
	 return;}
 var truthBeTold = window.confirm(t['HXEY11']);
 if (!truthBeTold) {return; } 
 var p1=admidobj.value
 var p2=Guser
 var getadmcancel=document.getElementById('getadmcancel');
 if (getadmcancel) {var encmeth=getadmcancel.value} else {var encmeth=''}; 
 var tmp2=cspRunServerMethod(encmeth,'','',p1,p2)
 if (tmp2=="100"){
	 alert(t['42']);
	 return;}
 else if (tmp2=="1"){
	 alert(t['49']);
	 return;}
 else if (tmp2=="2"){
	 alert(t['48']);
	 return;}
 else if (tmp2=="3"){
	 alert(t['50']);
	 return;}
 else if (tmp2=="4"){
	 alert(t['51']);
	 return;}
 else if (tmp2=="5"){
	 alert(t['54']);
	 return;}
 else if (tmp2=="0"){
	 alert(t['52']);
	 clear_click()
	 return;}
 else{
	 alert(t['53']);	 
	 return;}
}
function clear_lookup()
{if (SexObj.value==""){ sexidobj.value=""}
 if (mardescobj.value==""){ mardescidobj.value=""}
 if (rlgdescobj.value==""){ rlgdescidobj.value=""}
 if (zipcodeobj.value==""){ zipidobj.value=""}
 if (provdescobj.value==""){ providobj.value=""}
 if (cityobj.value==""){ cityidobj.value=""} 
 if (admdepobj.value==""){admdepidobj.value=""}
 if (admwardobj.value==""){admwardidobj.value=""}
 if (bedobj.value==""){bedidobj.value=""}
 if (roomobj.value==""){roomidobj.value=""}
 if (admdocobj.value==""){admdocidobj.value=""}
 if (admreasonobj.value==""){admreaidobj.value=""}
 if (admepisobj.value==""){admepisidobj.value=""}
 if (SocSatdescobj.value==""){SocSatidobj.value=""}
 if (admqkobj.value==""){admqkidobj.value=""}
 if (nationdescobj.value==""){nationidobj.value=""}
 if (cardtypeobj.value=""){cardtypeidobj.value=""}
 if (countryobj.value==""){countryidobj.value=""}
 if (occuobj.value==""){occuidobj.value=""}
 if (eduobj.value==""){eduidobj.value=""}
 if (languobj.value==""){languidobj.value=""}
 if (emptypeobj.value==""){emptypeidobj.value=""}
 if (homeplaceobj.value==""){
    birprovobj.value=""
    bircityobj.value=""}
 if (ctrltdescobj.value==""){ctrltidobj.value=""}
 if (cityareaobj.value==""){cityareaidobj.value=""}  
 if (diagnosobj.value==""){diagnosidobj.value=""}
 if (digtypeobj.value==""){digtypeidobj.value=""}
 var RefDocListdrobj=document.getElementById('RefDocListdr');
 var RefDocListobj=document.getElementById('RefDocList');
 if (RefDocListobj.value=="") {RefDocListdrobj.value=""} 
}	
function INSUReg_click()
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=INSUZydjCom&zyh='+papnoobj.value
    //window.open(str,'_blank','fullscreen=3,toolbar=Yes,location=no,directories=no,status=yes,menubar=yes,scrollbars=yes,resizable=yes,copyhistory=Yes,width=900,height=650,left=0,top=0')
	var result;
	
	result=window.showModalDialog(str,null,'dialogHeight:1000px;dialogWidth:1000px');
	if (result!= null)
	{if (result!= "") 
	  {location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFCASHIER";}
	}
	
}
function refunddeposit_click(){
	Adm=admidobj.value;
	if (Adm=="") {alert(t['42']);return}
	var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFRefundDeposit&Adm='+Adm
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=600,left=0,top=60')
}
function abort(yjrowid,rcptrowid){
   var abortobj
   var p1=yjrowid
   var p2=rcptrowid
   var p3=Guser
   abortobj=document.getElementById('Abort');   
   if (abortobj) {var encmeth=abortobj.value} else {var encmeth=''};
   if (cspRunServerMethod(encmeth,'SetPid1','',p1,p2,p3)=='0') {
			} 
}
function SetPid1(value){
   if (value!="0")
	{alert(t['12']);
	return;}
	else{
	 Add_click()
		}
}
function entercomp(){
 	var key=websys_getKey(e);	
	if (key==13) {
	   websys_setfocus('BtnPrint');	   
	}
}
function entercardno(){
 	 var key=websys_getKey(e);
	if (key==13) {
	  DHCWeb_Nextfocus();	   
	}
}
function elementformat(){
	var compobj=document.getElementById("deptcomp")
	var Myobj=document.getElementById('Myid');
    
    if (Myobj){
	    var imgname="ld"+Myobj.value+"i"+"bank"
	    var bankobj1=document.getElementById(imgname);  }	
	if (pyobj.value==t['02']){
	   if (bankobj) bankobj.readOnly=true;	   
	   if (compobj) compobj.readOnly=true;	   
	   if (cardnoobj) cardnoobj.readOnly=true;
	   if (banksubobj) banksubobj.readOnly=true;
	   if (bankobj1) bankobj1.style.display="none"
	}else{
	   if (bankobj) bankobj.readOnly=false;	   
	   if (compobj) compobj.readOnly=false;	   
	   if (cardnoobj) cardnoobj.readOnly=false;
	   if (banksubobj) banksubobj.readOnly=false;
	   if (bankobj1) bankobj1.style.display=""	
	}
}
function CardTypelookup(str){
   var tmp1 = str.split("^");
   cardtypeidobj.value=tmp1[1]
}
function entercardtype(){
   if (window.event.keyCode==13) 
	{  window.event.keyCode=117;	   
	   CardType_lookuphandler();
	   DHCWeb_Nextfocus();	
	}
}
function entergovcardno(){
   if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   DHCWeb_Nextfocus();	
	  // if (govcardnoobj.value!=""){		   
	  //   if ((cardtypeobj.value!="")&(cardtypeidobj.value!="")){
		//    if (cardtypeobj.value==t['60']){
		//	   if (paperidobj.value==""){
		//		  paperidobj.value=govcardnoobj.value
		//	   }else{
		//		   if (paperidobj.value!=govcardnoobj.value){
		//		      alert(t['61']);
		//		      paperidobj.value=""
		//		      govcardnoobj.value=""
		//		      websys_setfocus('GovCardno');
		//		      return
		//		   }
		//	   }
		//	}
		// }
	   //}
	  // DHCWeb_Nextfocus();	
	}
}
function Countrylookup(str){
   var tmp1 = str.split("^");
   countryidobj.value=tmp1[1]
}
function entercountry(){
   if (window.event.keyCode==13) 
	{  window.event.keyCode=117;	   
	   Country_lookuphandler();
	   DHCWeb_Nextfocus();	
	}
}
function Occulookup(str){
   var tmp1 = str.split("^");
   occuidobj.value=tmp1[1]
}
function enteroccu(){
   if (window.event.keyCode==13) 
	{  window.event.keyCode=117;	   
	   Occupation_lookuphandler();
	   DHCWeb_Nextfocus();	
	}
}
function Edulookup(str){
   var tmp1 = str.split("^");
   eduidobj.value=tmp1[1]
}
function enteredu(){
   if (window.event.keyCode==13) 
	{  window.event.keyCode=117;	   
	   Education_lookuphandler();
	   DHCWeb_Nextfocus();	
	}
}
function langulookup(str){
   var tmp1 = str.split("^");
   languidobj.value=tmp1[1]
}
function enterlangu(){
   if (window.event.keyCode==13) 
	{  window.event.keyCode=117;	   
	   Language_lookuphandler();
	   DHCWeb_Nextfocus();	
	}
}
function emptypelookup(str){
   var tmp1 = str.split("^");
   emptypeidobj.value=tmp1[1]
}
function enteremptype(){
   if (window.event.keyCode==13) 
	{  window.event.keyCode=117;	   
	   EmployeeType_lookuphandler();
	   DHCWeb_Nextfocus();	
	}
}
function homeplacelookup(str){
   var tmp1 = str.split("^");
   birprovobj.value=tmp1[1]
   bircityobj.value=tmp1[2]   
}
function enterhomeplace(){
   if (window.event.keyCode==13) 
	{  window.event.keyCode=117;	   
	   HomePlace_lookuphandler();
	   DHCWeb_Nextfocus();	
	}
}
function ctrltlookup(str){
   var tmp1 = str.split("^");
   ctrltidobj.value=tmp1[1]   
}
function enterctrlt(){
   if (window.event.keyCode==13) 
	{  window.event.keyCode=117;	   
	   Ctrltdesc_lookuphandler();
	   DHCWeb_Nextfocus();	
	}
}
function enterForeignId(){
 	 var key=websys_getKey(e);
	if (key==13) {
	  DHCWeb_Nextfocus();	   
	}
}
function enterFPhone(){
 	 var key=websys_getKey(e);
	if (key==13) {
	  DHCWeb_Nextfocus();	   
	}
}
function enterFAddress(){
 	 var key=websys_getKey(e);
	if (key==13) {
	  DHCWeb_Nextfocus();	   
	}
}
function enterFNotes(){
 	 var key=websys_getKey(e);
	if (key==13) {
	  DHCWeb_Nextfocus();	   
	}
}
function getadmdate(){
  var key=websys_getKey(e);
  if (key==13) { 
	var mybirth=DHCWebD_GetObjValue("admdate");
	if ((mybirth=="")||((mybirth.length!=8)&&((mybirth.length!=10)))){
		var obj=document.getElementById("admdate");
		obj.className='clsInvalid';
		websys_setfocus("admdate");
		return websys_cancel();
	}else{
		var obj=document.getElementById("admdate");
		obj.className='clsvalid';
	}
	if ((mybirth.length==8)){
		var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8)
		DHCWebD_SetObjValueA("admdate",mybirth);
	}
	////alert(mybirth);
	var myrtn=DHCWeb_IsDate(mybirth,"-")
	if (!myrtn){
		var obj=document.getElementById("admdate");
		obj.className='clsInvalid';
		websys_setfocus("birthdate");
		return websys_cancel();
	}else{
		var obj=document.getElementById("admdate");
		obj.className='clsvalid';
	}
  }		
}
function LinkaddDeposit_click(){
	Adm=admidobj.value
	if (Adm=="") {alert(t['25']);return}
	//var str='UDHCJFDEPOSIT.csp?Adm='+Adm
	deposittype=""
	var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFDeposit&Adm='+Adm+'&deposittype='+t['01']
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=700,left=0,top=0')
}
function cityarealookup(str){
   var tmp1 = str.split("^");
   if (tmp1[3]=="0"){
      cityareaidobj.value=""
   }
   var obj=document.getElementById("CTCITDesc")
   if (obj) obj.value = tmp1[1];
   var obj=document.getElementById("PROVDesc")
   if (obj) obj.value = tmp1[2];	
   var obj=document.getElementById("cityareaid")
   if (obj) obj.value = tmp1[3];
   var obj=document.getElementById("cityid")
   if (obj) obj.value = tmp1[4];
   var obj=document.getElementById("provid")
   if (obj) obj.value = tmp1[5];
      
}
function entercityarea(){
   if (window.event.keyCode==13) 
	{  window.event.keyCode=117;	   
	   cityarea_lookuphandler();
	   DHCWeb_Nextfocus();	
	}
}

function enterbaby(){ 	
 	 var key=websys_getKey(e);	
	if (key==13) {	  
	  var agehourobj=document.getElementById('agehour');
      var ageMinutesobj=document.getElementById('ageMinutes');
	  var babybirstr=babybirobj.value+t['HXEY05']+agehourobj.value+t['HXEY06']+ageMinutesobj.value+t['HXEY07']
	  if (ageMinutesobj.value!=""){
	     if (eval(ageMinutesobj.value)>59){
		     ageMinutesobj.value=""
		     return;
		 }
	  }
	  if (agehourobj.value!=""){
	     if (eval(agehourobj.value)>23){
		     agehourobj.value=""
		     return;
		 }
	  }
	  if ((babybirobj.value!="")||(agehourobj.value!="")||(ageMinutesobj.value!="")){
	     var p2=admdateobj.value
	     var p3=admtimeobj.value
	     var p1=babybirstr	     
	     
	     var getbabyobj=document.getElementById("getbabybirday")
	     if (getbabyobj) {var encmeth=getbabyobj.value} else {var encmeth=''}; 
         var tmp2=cspRunServerMethod(encmeth,p1,p2,p3)
         
         if (tmp2!=""){
	        if (tmp2=="1"){
		       alert(t['HXEY01']);
		       return;
		    }
		    else if (tmp2=="2"){
		       alert(t['HXEY02']);
		       return;
		    }
		    else if (tmp2=="3"){
		       alert(t['HXEY03']);
		       return;
		    }
		    else{
			   var babystr=tmp2.split("^")
			   babydob1=babystr[0]
			   babydob2=babystr[1]
			   var babybirthday=babystr[2]
			   birthdateobj.value=babybirthday
			   
			   if (birthdateobj.value!="")  {
				   getage1()}
			   }
	     }
	  }
	  
	  //if (babybirobj.value!=""){
		//  alert(babybirobj.value+"!!");
		  //agedayobj.value=babybirobj.value}
	  DHCWeb_Nextfocus();	   
	}
  }
function getdiagnos()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   Diagnos_lookuphandler();
	   DHCWeb_Nextfocus();	
		}
}
function LookUpWithAlias(str)
{  
	var tmp1 = str.split("^");
   diagnosidobj.value=tmp1[1]
   
}
function getdigtype()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   DiagnosType_lookuphandler();
	   DHCWeb_Nextfocus();	
		}
}
function digtypelookup(str)
{
   var tmp1 = str.split("^");
   digtypeidobj.value=tmp1[1]	
}

function refdoclookup(str)
{  var RefDocListdrobj=document.getElementById('RefDocListdr');
   var tmp1 = str.split("^");
   RefDocListdrobj.value=tmp1[1]
	
}
function getrefdoc()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   RefDocList_lookuphandler();
	   DHCWeb_Nextfocus();	
		}
}

function getnewcardinfo()
{
   var key=websys_getKey(e);	
   if (key==13) {
	   if (newcardnoobj.value==""){
	       alert(t['HXEY08']);
	       return;
	   }else{
		 var lnewcardno=newcardnoobj.value.length
         if (eval(lnewcardno)!=10){
	         alert(t['HXEY10']);
	         return;
         }
		 var p1=newcardnoobj.value  
	     var getnewcardinfo=document.getElementById("getnewcardinfo")
	     if (getnewcardinfo) {var encmeth=getnewcardinfo.value} else {var encmeth=''}; 
         var newcardinfo=cspRunServerMethod(encmeth,p1)         
         if (newcardinfo!=""){
	        var tmp=newcardinfo.split("^");
	        papnoobj.value=tmp[2]
	        getpatinfo1()   
	     }
	     if (newcardinfo==""){
		    websys_setfocus('name');
		 }   
	   }	
   }
}   
document.body.onload = BodyLoadHandler;