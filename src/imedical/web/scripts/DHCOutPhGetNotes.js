//DHCOutPhGetNotes
var evtName;
var doneInit=0;
var focusat=null;
var ctlocobj,useridobj;
var BResetobj,BDispobj,BPrintobj,BReprintobj;
var m_CardNoLength=0;
var m_SelectCardTypeDR="";
var ctloc=document.getElementById("ctloc").value
function BodyLoadHandler() {
  var BResetobj=document.getElementById("BSure");
  if (BResetobj) BResetobj.onclick=Insert_click;
   ctlocobj=document.getElementById("ctloc");
  var ReadCardobj=document.getElementById("CReadCard");
  if (ReadCardobj) ReadCardobj.onclick= ReadHFMagCard_Click;
var BResetobj=document.getElementById("BCancel");
  if (BResetobj) BResetobj.onclick=Reset_click;
 var myobj=document.getElementById("CardTypeDefine");
	if (myobj){
		myobj.onchange=CardTypeDefine_OnChange;
		myobj.size=1;
		myobj.multiple=false;
    loadCardType();
    CardTypeDefine_OnChange();}
 var myobj=document.getElementById("CSerialNo");
		if (myobj)
		{
			myobj.readOnly = true;
		}
var myobj=document.getElementById("CWinDesc");
		if (myobj)
		{
			myobj.readOnly = true;
		}	
var myobj=document.getElementById("CPatName");
		if (myobj)
		{
			myobj.readOnly = true;
		}		
	
var ReadCardobj=document.getElementById("CReadCard");
if (ReadCardobj) {DHCMZYF_setfocus('CReadCard');}

}
function OnKeyDownHandler(e){
  var key=websys_getKey(e);
 // var patname=document.getElementById('CPatName');
}
function loadCardType(){
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=document.getElementById("ReadCardTypeEncrypt").value;
	
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
		DHCWeb_DisBtnA("CReadCard");
	}
	else
	{
		
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = true;
		}
		var obj=document.getElementById("CReadCard");
		if (obj){
			obj.disabled=false;
			obj.onclick=ReadHFMagCard_Click;
		}
	}
	
	
		DHCMZYF_setfocus("CReadCard");

	
	m_CardNoLength=myary[17];
	
}




function PrintPresc()
{
 
}

function ReadHFMagCard_Click()
{
		var myCardTypeValue=DHCWeb_GetListBoxValue("CardTypeDefine");
  	if (m_SelectCardTypeDR==""){
		var myrtn=DHCACC_GetAccInfo();
	}else{
		var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR,myCardTypeValue);
		//var myrtn=DHCACC_GetAccInfo("1","1");
		
	}
	

	var myary=myrtn.split("^");
	var rtn=myary[0];
	
	if (rtn=="-1") {alert(t['ReadErr']);return ;}
	else
	{	var obj=document.getElementById("CPmiNo");
			if (obj) obj.value=myary[5];
		var obj=document.getElementById("CardNo");
			if (obj) obj.value=myary[1];
	 var getmethod=document.getElementById('getpatinf');
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     var retval=cspRunServerMethod(encmeth,ctloc,myary[5])	
     if (retval=="-1") {alert(t['GetCodeErr']);return;}
     if (retval=="-2") {alert(t['GetCodeRep']);obj.value='';return;}
     var sstr=retval.split("^")
     //patname_"^"_phwdesc_"^"_xh_"^"_pmidr_"^"_phw 
     
     document.getElementById('CSerialNo').value=sstr[2];
     document.getElementById('CPatName').value=sstr[0];
     document.getElementById('CWinDesc').value=sstr[1];
     document.getElementById('pmidr').value=sstr[3];
     document.getElementById('phw').value=sstr[4];
     DHCMZYF_setfocus("BSure")
     
	}
}

function Reset_click()
{
     document.getElementById('CSerialNo').value="";
     document.getElementById('CPatName').value="";
     document.getElementById('CWinDesc').value="";
     document.getElementById('pmidr').value="";
     document.getElementById('phw').value="";
     document.getElementById('CardNo').value="";
  	 DHCMZYF_setfocus("CReadCard");
}
 

function Insert_click()
{
	//pmi, ctloc, phw, xh)
  var pmi= document.getElementById('pmidr').value
  if (pmi=='') {alert(t['ReadErr']);return }
  var phw= document.getElementById('phw').value
  var xh= document.getElementById('CSerialNo').value
  
	 var getmethod=document.getElementById('ins');
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     var retval=cspRunServerMethod(encmeth,pmi,ctloc,phw,xh)	
     if (retval!="0"){alert(t['infail']);return;}
     else
        {alert(t['insuess']);}
 var name=document.getElementById('CPatName').value
 var windesc=document.getElementById('CWinDesc').value
 var getmethod=document.getElementById('getsysdatetime');
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
 var retval=cspRunServerMethod(encmeth)	
 var sstr=retval.split("^")
 var curdate=sstr[0]
 var curtime=sstr[1]
 PrintNote(xh,name,windesc,curdate,curtime)
  Reset_click()

}

function PrintNote(xh,patname,windesc,curdate,curtime)
{
  DHCP_GetXMLConfig("InvPrintEncrypt","DHCPhGetCodeNote");	 
	//DHCPhGetCodeNote
 
  var MyPara="";
      var MyList=""  
	    //MyPara=MyPara+"PrescNo"+String.fromCharCode(2)+prescno;
	    MyPara=MyPara+"SerialNo"+String.fromCharCode(2)+xh;
	    MyPara=MyPara+"^WinDesc"+String.fromCharCode(2)+windesc;
	    MyPara=MyPara+"^PatName"+String.fromCharCode(2)+patname;
	    MyPara=MyPara+"^CurrDate"+String.fromCharCode(2)+curdate;
	    MyPara=MyPara+"^CurrTime"+String.fromCharCode(2)+curtime;
		var myobj=document.getElementById("ClsBillPrint");
		DHCP_PrintFun(myobj,MyPara,MyList);	

	
	
}

function DHCMZYF_setfocus(objName) {
	window.setTimeout('DHCMZYF_setfocus2(\''+objName+'\')',300);
}

function DHCMZYF_setfocus2(objName) {
	var obj=document.getElementById(objName);
	if (obj) {
		try {obj.focus();obj.select();	} catch(e) {}  }
    }

document.body.onload = BodyLoadHandler;
