//DHCOutPhPYSure
//配药确认
var tblobj=document.getElementById("tDHCOutPhPYSure");
var evtName;
var doneInit=0;
var focusat=null;
var SelectedRow = 0;
var pmiobj,pnameobj;
var stdateobj,enddateobj;
var phlobj,phwobj,locdescobj,phwdescobj,pydrobj,fydrobj,pynameobj,fynameobj;
var ctlocobj,useridobj;
var BResetobj,BPrintobj;
var printobj;
var GPhl
var ctloc=document.getElementById('ctloc').value
 
function BodyLoadHandler() {
	BResetobj=document.getElementById("BReset");
	if (BResetobj) BResetobj.onclick=Reset_click;
	var BPrescobj=document.getElementById("rPrescNo");
	if (BPrescobj) BPrescobj.onkeypress=Presc_KeyPress;

	var BPrescobj=document.getElementById("CUserCode");
	//if (BPrescobj) BPrescobj.onblur=BPrescBlur;
	if (BPrescobj) BPrescobj.onkeypress=UserCode_KeyPress;


	var BSureobj=document.getElementById("BSure");
	if (BSureobj) BSureobj.onclick=Presc_Sure;

	ctlocobj=document.getElementById("ctloc");
	tblobj=document.getElementById("tDHCOutPhPYSure");
	if (tblobj.rows.length>1)
	{
		DHCMZYF_setfocus("CUserCode");
	}
	else
	{
		DHCMZYF_setfocus("rPrescNo");

	}
	var ctloc=document.getElementById('ctloc').value
	var getmethod=document.getElementById('getphl');
	if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
	GPhl=cspRunServerMethod(encmeth,ctloc)
}




function Reset_click()
{
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhPYSure";
 }
 
 
function UserCode_KeyPress(){
	
	var rows=tblobj.rows.length
	if (rows==1){alert("处方信息为空,请输入信息后重试!"); return;}
	var ctloc=document.getElementById('ctloc').value
	var usercode=document.getElementById('CUserCode').value;

	var key=websys_getKey(event);
	if (key==13){
		if (usercode=='') {
			alert("用户工号不能为空,请输入工号后重试！");    ///修改提示 bianshuai 2015-12-08
			return ;
		}	 

		var getmethod=document.getElementById('getpydr');
		if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
		var retval=cspRunServerMethod(encmeth,usercode,ctloc)
		if (retval==0){
			alert(t['notpydr']);return;	    
		}else{
			document.getElementById('pydr').value =retval
			Presc_Sure()
		}   
	}
}


function Presc_KeyPress()
{
	var prescno=document.getElementById('rPrescNo').value;
	var ctloc=document.getElementById('ctloc').value
	 var key=websys_getKey(event);
	 if (key==13)
	 {
	  if (prescno=='') {alert(t['isnull']);document.getElementById('rPrescNo').value=""; return ;}	 
		 
	 var getmethod=document.getElementById('getphdrow');
     if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};

     var retval=cspRunServerMethod(encmeth,prescno,ctloc)
     if (retval==0){
	     alert(t['nopresc']);
	     document.getElementById('rPrescNo').value=""
	     return;
	    
	     }
	  else
	  {
	 var  phdrow=retval
	 document.getElementById('rPhd').value=phdrow;
	// alert(retval)
	  location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhPYSure&rPhd="+phdrow+"&rCtloc="+ctloc;    
	  }
	
}
}
function BPrescBlur(){

	var rows=tblobj.rows.length
	if (rows==1){alert("处方信息为空,请输入信息后重试!"); return;}
	var ctloc=document.getElementById('ctloc').value
	var usercode=document.getElementById('CUserCode').value;
	if (usercode==''){ 
		alert("用户工号不能为空,请输入工号后重试！");    ///修改提示 bianshuai 2015-12-08
		return false;
	}	 

	var getmethod=document.getElementById('getpydr');
	if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
	var retval=cspRunServerMethod(encmeth,usercode,ctloc)
	if (retval==0){
		alert(t['notpydr']);
		return false;}
	else{
		document.getElementById('pydr').value =retval
		//Presc_Sure()
		//  DHCMZYF_setfocus("BSure");
	}
	return true;
}

function Presc_Sure()
{
	if(!BPrescBlur()){    ///增加判断 bianshuai 2015-12-08
		return;            
	}	
	var phdrow=document.getElementById('rPhd').value
	var pydr=document.getElementById('pydr').value 
	var ctloc=document.getElementById('ctloc').value 
	if (pydr=='') {alert(t['notpydr']);return ;}	

	var getmethod=document.getElementById('sure');
	if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
	var retval=cspRunServerMethod(encmeth,phdrow,ctloc,pydr)
	if (retval=="0"){alert("确认成功!")}
	else {alert("确认失败!"+retval)}
	Reset_click();
	return;
	 ///如下为上屏叫号操作,如有需要再进行调试
	 if (retval=='0')
	 {
  
	   var getmethod=document.getElementById('getscpath');
	   if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
	   var scpath=cspRunServerMethod(encmeth,GPhl)
   
  
	   if (scpath!="-1")
	   {
	   	var getmethod=document.getElementById('SendDHCall');
	    if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
	    var retcall=cspRunServerMethod(encmeth,phdrow,"")
	    Reset_click();
	     
	     }
     
     
	    else
	    {
		    alert(t['qrerr']);
		    document.getElementById("CUserCode").value="";
		    DHCMZYF_setfocus("CUserCode"); 
	    }	
	 }	
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
