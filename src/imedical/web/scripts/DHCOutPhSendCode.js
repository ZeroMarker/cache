//DHCOutPhSendCode
var SelectedRow = 0;
var tbl=document.getElementById('tDHCOutPhSendCode');
var ctloc=document.getElementById('ctloc').value

function BodyLoadHandler() {
	var baddobj=document.getElementById("BAdd");
	if (baddobj) baddobj.onclick=Badd_click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=Bupdate_click;
	var obj=document.getElementById("BReset");
	if (obj) obj.onclick=BReset_click;
	var obj=document.getElementById("CSendFlag");
	if (obj) obj.checked=true
	var obj=document.getElementById("BRetrieve");
	if (obj) obj.onclick=Retrieve;
	
	var obj=document.getElementById("BUpdateKC");
	if (obj) obj.onclick=BUpdateDateKC;

	 DHCMZYF_setfocus('CPhDesc');
	
	var obj=document.getElementById("CPhDesc"); 
	 
	 	if (obj){	
		obj.onkeydown=popCPhDesc;
		//obj.onblur=CPhDescCheck;		
	}
	
	
}

function popCPhDesc()
{
	if (window.event.keyCode==13){
		window.event.isLookup=true;
	  	CPhDesc_lookuphandler(window.event);  ///bianshuai 2015-12-02 修改 IE11无法弹出放大镜 
	    return false;  ///bianshuai 2015-12-02 一直切界面,没找到原因，故此返回false
	}
}
function CPhDescCheck()
{
}

function SelectRowHandler()	{
	
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	SelectedRow = selectrow;
	var row=SelectedRow;
	var TPhDesc=document.getElementById("TPhDescz"+row);
	var TPhInci=document.getElementById("TIncz"+row);
	var tsend=document.getElementById("TSendFlagz"+row);
	var tphsrow=document.getElementById("TPhsRowz"+row);
	
    var CPhDesc=document.getElementById('CPhDesc')
    var CInci=document.getElementById('cinci')
    var csend=document.getElementById('CSendFlag')
    var cphsrow=document.getElementById('cphsrow')
    
    CPhDesc.value=TPhDesc.innerText
   CInci.value=TPhInci.value
   
   if (tsend.innerText==t['yes']){csend.checked=true;}
   else
   {csend.checked=false;} 
  cphsrow.value=tphsrow.value
}
function BReset_click()
{
  
  var phdesc=document.getElementById('CPhDesc');
  var inci=document.getElementById('cinci');
  phdesc.value="";
  inci.value="";
  DHCMZYF_setfocus('CPhDesc');
  
  	
}
function Bupdate_click()	
{  
	 if (SelectedRow==0) return;
     var sendobj=document.getElementById('CSendFlag');
     if (sendobj.checked==true){var send="1";}
     else {var send="";}
     var phsrow=document.getElementById('cphsrow').value;
	 var getmethod=document.getElementById('up');
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     var retval=cspRunServerMethod(encmeth,phsrow,send)
     if (retval!="0") {alert(t['uperr']);return;}
	  Retrieve()

}
function Badd_click()	
{  

var inc=document.getElementById('cinci').value;
    if (inc==''){return;}
 var sendobj=document.getElementById('CSendFlag')
 var sendflag=""
 if (sendobj) {
	 if (sendobj.checked==true)  sendflag="1"
	 
 }
   var getmethod=document.getElementById('ins');
   if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
 var retval=cspRunServerMethod(encmeth,ctloc,inc,sendflag)
 if (retval=="-99") {alert("已存在相同记录,不能重复增加!");return;}
 if (retval!="0") {alert(t['adderr']);return;}
  //window.location.reload();

   Retrieve()
      
}
function BUpdateDateKC()
{
 var getmethod=document.getElementById('putup');
   if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
 var retval=cspRunServerMethod(encmeth,ctloc)
	
	
}
function Retrieve()
{
  var inc=document.getElementById("cinci").value

   location.href= "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhSendCode&ctloc="+ctloc+"&cinci="+inc
}

function GInci(value) 
{ 
  if (value=="") {return;}
  var sstr=value.split("^")
  var phinci=document.getElementById("cinci")
     phinci.value=sstr[1]
     //^PACPAQUE1(prescrow,"DHC")24
  DHCMZYF_setfocus('BAdd');
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
