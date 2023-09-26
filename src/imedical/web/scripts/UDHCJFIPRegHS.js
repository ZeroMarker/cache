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
var Abortprt,DepositFlag,PatinFlag,AgeFlag,LinkDeposit,PapnoFlag,PapnoInFlag,ClearFlag
var PrintAdmFlag
var curdate
var diagnosdescobj
function BodyLoadHandler() {  
  
  RcptFlag="Y"
  PrtFlag="N"
  Abortprt="Y"
  DepositFlag="N"
  PatinFlag="Y"
  AgeFlag="Y"        //lrl  
  LinkDeposit="N"
  PapnoFlag="Y"      //lrl
  PapnoInFlag="Y"
  ClearFlag="1"
  PrintAdmFlag="Y"   //lrl
  Guser=session['LOGON.USERID']
  gusercode=session['LOGON.USERCODE']
  gusername=session['LOGON.USERNAME']
  UserLoc=session['LOGON.CTLOCID']
  usernameobj=document.getElementById('username');
  usernameobj.value=gusername
  usernameobj.readOnly=true;
  var WshNetwork = new ActiveXObject("WScript.NetWork");
  computername=WshNetwork.ComputerName; 
  
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
  diagnosdescobj=document.getElementById('Diagnosdesc');
  getcurdate()
  clear_click()
  
  papnoobj.onkeydown=getpatinfo;
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
 if (birthdateobj) birthdateobj.onkeydown=getage;
 var regsaveobj=document.getElementById('regsave');
 if (regsaveobj) regsaveobj.onclick=regsave_click
 var clearobj=document.getElementById('clear');
 if (clearobj) clearobj.onclick=clear_click 
 var clearadmobj=document.getElementById('clearadm');
 if (clearadmobj) clearadmobj.onclick=clearadm_click ;
 
 var btnyjobj=document.getElementById('BtnPrint');
 if (btnyjobj) 
 {  if (LinkDeposit=="N") 
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
 medicareobj.onkeydown=entermedicare
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
 FNotesobj.onkeydown=enterFNotes    //lrl
 provdescobj.onkeydown=enterProv    //lrl
 cityobj.onkeydown=enterCity        //lrl
 admdepobj.onkeydown=getadmdep
 admwardobj.onkeydown=getadmward
 admqkobj.onkeydown=getadmryqk
 SocSatdescobj.onkeydown=getSocSat
 yjamtobj.onkeydown=enteryjamt 
 ageobj.onkeydown=getbirday
 birthdateobj.onkeydown=getage
 nationdescobj.onkeydown=getnation
 deptcompobj.onkeydown=entercomp
 var getpath=document.getElementById('getpath');
 if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
 path=cspRunServerMethod(encmeth,'','');			
 var refdep=document.getElementById('refdep');
 if (refdep)  //lrl
 {refdep.onclick=refunddeposit_click
 elementformat()
 }
 var obj=document.getElementById('Print');               //lrl 2007-04-02 
 if (obj) obj.onclick=Print_click                        //lrl 2007-04-02
 DHCP_GetXMLConfig("InvPrintEncrypt","DHCIPRegInfo")     //lrl 2007-04-02
 }
 function Print_click()    //lrl 2007-04-02
 {   //alert(papnoobj.value)
	 if (papnoobj.value!=""&&papnameobj.value!="") Printadminfo("");
	 
	 }
 function enterpatname(){
 	 var key=websys_getKey(e);
	if (key==13) {
	   if (papnameobj==""){
		   alert(t['12']);
		   return;}
	  // websys_setfocus('Medicare');
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
				    //alert(t['63']);    	//lrl
				    birthdateobj.value=""
				    //paperidobj.value=""    //lrl
				    ageobj.value=""
				    birthdateobj.value=agebir	//lrl
			    	getage1()					//lrl
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
				    //alert(t['63']);			//lrl
				    birthdateobj.value=""
				    //paperidobj.value=""   //lrl
				    ageobj.value=""
				    birthdateobj.value=agebir	//lrl
			    	getage1()					//lrl
				 }
			  }			  
		  }
		else{
		   alert(t['62']);
		   //paperidobj.value=""    //lrl
		   websys_setfocus('paperid');
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
    getage1()
	DHCWeb_Nextfocus();
	}
 }
 function getage1(){
	 var p1=birthdateobj.value
     if (p1==""){
	     alert(t['09']);
	     return;
	 }else{
	 Birth_OnBlur();
	 var p2=birthdateobj.value
	var getageobj=document.getElementById('getage');
	if (getageobj) {var encmeth=getageobj.value} else {var encmeth=''};
	var agestr=cspRunServerMethod(encmeth,p2)
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
	   DHCWeb_Nextfocus();         //lrl
	   return;
	}
    var p1=ageobj.value
    var getbirthday=document.getElementById('getbirthday');
    if (getbirthday) {var encmeth=getbirthday.value} else {var encmeth=''};
	var birstr=cspRunServerMethod(encmeth,p1)
	birthdateobj.value=birstr
	var p2=birthdateobj.value
	var getageobj=document.getElementById('getage');
	if (getageobj) {var encmeth=getageobj.value} else {var encmeth=''};
	var agestr=cspRunServerMethod(encmeth,p2)
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
	       admdateobj.readOnly=false;     //lrl
	       admtimeobj.readOnly=false;     //lrl 
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
 curdate=curyear+"-"+curmon+"-"+curday
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
	//countryobj.value=t['65']
    //nationdescobj.value=t['66']
	}	
}
function getpatinfo1()
{if (papnoobj.value==""){
		alert(t['07']);
		return;}
	var p1=papnoobj.value;
	if (p1.length!=8)    //lrl
	{
		papnoobj.value="";
		return;
		}
	var getpatinfo=document.getElementById("getpatinfo")
	if (getpatinfo) {var encmeth=getpatinfo.value} else {var encmeth=''};
	var str=cspRunServerMethod(encmeth,p1);
	if (str!=""){
		var str1=str.split("^");
		if (str1[0]=="-1"){
			alert(t['07']);
		    return;
		}else if (str1[0]=="-2"){
			papmiidobj.value="";
			if (PapnoInFlag!="Y"){
			   alert(t['08']);
			   papnoobj.value="";
		       return;
		    }else{
			   var p1=papnoobj.value
			   var getpapno=document.getElementById("getpapno")
			   if (getpapno) {var encmeth=getpapno.value} else {var encmeth=''};
			   var papnostr=cspRunServerMethod(encmeth,p1);
			   papnoobj.value=papnostr
			   countryobj.value=t['65']       //lrl
    		   nationdescobj.value=t['66']    //lrl
			}   
		}
		else if (str1[0]=="-3"){
			alert(t['papnoerr2']);
			papnoobj.value="";
			papmiidobj.value="";    //lrl
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
		 if (str1[20]==""){
			 clearadm_click()			 
			 }
		 }		
	}
	elementformat1()
	//websys_setfocus('name');
	DHCWeb_Nextfocus()}
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
  var p1,p2,p3,p4
  clear_lookup()
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
  p1=papmiidobj.value+"^"+papnameobj.value+"^"+medicareobj.value+"^"+sexidobj.value
  p1=p1+"^"+paperidobj.value+"^"+birthdateobj.value+"^"+ageobj.value+"^"+ageyrobj.value
  p1=p1+"^"+agemthobj.value+"^"+agedayobj.value+"^"+mardescidobj.value+"^"+rlgdescidobj.value
  p1=p1+"^"+addressobj.value+"^"+hometelobj.value+"^"+zipidobj.value+"^"+companyobj.value
  p1=p1+"^"+worktelobj.value+"^"+providobj.value+"^"+emailobj.value+"^"+mobtelobj.value
  p1=p1+"^"+cityidobj.value+"^"+SocSatidobj.value+"^"+nationidobj.value
  p1=p1+"^"+cardtypeidobj.value+"^"+govcardnoobj.value+"^"+countryidobj.value+"^"+occuidobj.value
  p1=p1+"^"+eduidobj.value+"^"+languidobj.value+"^"+emptypeidobj.value+"^"+birprovobj.value
  p1=p1+"^"+bircityobj.value+"^"+ctrltidobj.value+"^"+ForeignIdobj.value+"^"+FPhoneobj.value
  p1=p1+"^"+FAddressobj.value+"^"+FNotesobj.value+"^"+cityareaidobj.value
  
  p2=admdepidobj.value+"^"+admwardidobj.value+"^"+roomidobj.value+"^"+bedidobj.value+"^"+admdocidobj.value
  p2=p2+"^"+admreaidobj.value+"^"+admepisidobj.value
  p2=p2+"^"+admdateobj.value+"^"+admtimeobj.value+"^"+Guser+"^"+admqkidobj.value+"^"+""
  //var myCardInfo=RegNoObj.value+"^"+PatientID+"^"+IDCardNo1Obj.value+"^"+CardNoObj.value+"^"+CardVerify+"^"+""+"^"+""+"^"+Guser+"^"+computername+"^"+CardID+"^"+mySecrityNo;
  if (opcardid!=""){
  p3=papnoobj.value+"^"+papmiidobj.value+"^"+paperidobj.value+"^"+opcardnoobj.value+"^"+cardCheckNo+"^"+""+"^"+""+"^"+Guser+"^"+computername+"^"+opcardid+"^"+cardCheckNo;
  }else{ 
  p3=""
  }
  if (PapnoInFlag=="Y"){
     p4="Y"+"^"+papnoobj.value
  }
  else{
	 p4="N"+"^" 
  }
  //return;
  var addpatinfo=document.getElementById("addpatinfo");
  if (addpatinfo) {var encmeth=addpatinfo.value} else {var encmeth=''};
  var tmp=cspRunServerMethod(encmeth,'','',p1,p2,p3,p4)
  
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
  else if (tmp1[0]=="papnoerr"){
	  alert(t['papnoerr']);
	  return;
	  }  	  
  else if (tmp1[0]=="papnoerr2"){
	  alert(t['papnoerr2']);
	  return;}
  else if (tmp1[0]=="0"){
    if (papmiidobj.value!=""){
	    admidobj.value=tmp1[3];
	    admvisitobj.value=tmp1[5];
	    admsearchobj.value=tmp1[4];
	    elementformat1()
	    alert(t['27']);
	  }else{
	    papnoobj.value=tmp1[1];
	    papmiidobj.value=tmp1[2];
	    admidobj.value=tmp1[3]
	    admvisitobj.value=tmp1[5];
	    admsearchobj.value=tmp1[4];
	    elementformat1()
	    alert(t['27']);
		  }
	  }	 
	 var adminfo=papnoobj.value+"^"+papnameobj.value+"^"+admdateobj.value+"^"+SexObj.value
	 adminfo=adminfo+"^"+hometelobj.value+"^"+ mardescobj.value+"^"+ageobj.value+"^"+addressobj.value
	 adminfo=adminfo+"^"+medicareobj.value+"^"+companyobj.value+"^"+admwardobj.value+"^"+admdepobj.value
	 if (PrintAdmFlag=="Y"){
	 Printadminfo(adminfo)}
	 if (DepositFlag=="Y"){
	 websys_setfocus('payamt');}
	 else{
		if (ClearFlag=="1"){
		   clear_click()
		}		 
	 }                         
	}  
  function clear_click()
  {clearpat_click()
   clearadm_click()
   if (DepositFlag=="Y"){   
   getyjinfo()           
   }                     
   if (PapnoFlag=="N"){
      websys_setfocus('name'); }
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
	var dep=deptype+"^"+payamt+"^"+moderowid+"^"+deptcomp+"^"+bankrowid+"^"+cardno+"^"+authno+"^"+Adm+"^"+CurNo+"^"+UserLoc+"^"+Guser+"^"+EndNo+"^"+Title+"^"+banksub+"^"+diagnosdescobj.value
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
		if (Abortprt=="Y"){
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
	   if (Abortprt=="N"){
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
   gettoday()   
   admqkobj.value=t['58']
   var p1=admqkobj.value
   var getryqkid=document.getElementById('getryqk');
   if (getryqkid) {var encmeth=getryqkid.value} else {var encmeth=''};
   var tmp2=cspRunServerMethod(encmeth,p1)
   admqkidobj.value=tmp2
   usernameobj.value=gusername
   AdmTimesobj.readOnly=true
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
}
function regupdate_click()
{ clear_lookup()
 if ((papnameobj.value=="")||(papmiidobj.value=="")){
	alert(t['39']);
	return;}
 var p1=papmiidobj.value
 var p2=papnameobj.value+"^"+medicareobj.value+"^"+sexidobj.value+"^"+paperidobj.value+"^"+birthdateobj.value
 p2=p2+"^"+ageobj.value+"^"+ageyrobj.value+"^"+agemthobj.value+"^"+agedayobj.value+"^"+mardescidobj.value
 p2=p2+"^"+rlgdescidobj.value+"^"+addressobj.value+"^"+hometelobj.value+"^"+zipidobj.value
 p2=p2+"^"+companyobj.value+"^"+worktelobj.value+"^"+cityidobj.value+"^"+providobj.value+"^"+mobtelobj.value+"^"+emailobj.value+"^"+Guser+"^"+SocSatidobj.value+"^"+nationidobj.value 
 p2=p2+"^"+cardtypeidobj.value+"^"+govcardnoobj.value+"^"+countryidobj.value+"^"+occuidobj.value
 p2=p2+"^"+eduidobj.value+"^"+languidobj.value+"^"+emptypeidobj.value+"^"+birprovobj.value
 p2=p2+"^"+bircityobj.value+"^"+ctrltidobj.value+"^"+ForeignIdobj.value+"^"+FPhoneobj.value
 p2=p2+"^"+FAddressobj.value+"^"+FNotesobj.value+"^"+cityareaidobj.value
 
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
 var p1=admidobj.value
 var p2=admreaidobj.value+"^"+admepisidobj.value+"^"+admqkidobj.value+"^"+Guser
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
	   if (govcardnoobj.value!=""){		   
	     if ((cardtypeobj.value!="")&(cardtypeidobj.value!="")){
		    if (cardtypeobj.value==t['60']){
			   if (paperidobj.value==""){
				  paperidobj.value=govcardnoobj.value
			   }else{
				   if (paperidobj.value!=govcardnoobj.value){
				      alert(t['61']);
				      paperidobj.value=""
				      govcardnoobj.value=""
				      websys_setfocus('GovCardno');
				      return
				   }
			   }
			}
		 }
	   }
	   DHCWeb_Nextfocus();	
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

function enterProv(){    //lrl
 	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;	   
	   PROVDesc_lookuphandler();
	   DHCWeb_Nextfocus();	
	}
}
function enterCity(){   //lrl
 	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;	   
	   CTCITDesc_lookuphandler();
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
	deposittype=t['04']
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
document.body.onload = BodyLoadHandler;