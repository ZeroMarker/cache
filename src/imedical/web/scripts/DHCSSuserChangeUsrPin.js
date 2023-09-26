function BodyLoadHandler() {
	//alert("sdds")

	websys_setTitleBar("OutPatient  Registeration");
	var obj=document.getElementById('Confirm');
	if (obj) obj.onclick=Confirm_Click;
}

function Confirm_Click()
{
 //alert("888")
 //var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPReg";
 //var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCExaBorDep";
 //win=open(lnk,"CallDoc","scrollbars=1,status=1,top=50,left=10,width=800,height=630");	
		var obj=document.getElementById('NewPin1');
		if (obj) p2=obj.value;
		var obj=document.getElementById('NewPin2');
		if (obj) p4=obj.value;
		if (p2!=p4){
			alert(t["newpwderror"])
			return
		}
		var obj=document.getElementById('OldPin');
		if (obj) p3=obj.value;
		if (p2==p3){
			alert(t["pwdrepeat"])
			return
		}
		p1=session['LOGON.USERCODE']
		//alert(p1+"^"+p2)
		var GetDetail=document.getElementById('GetUsePin');
		if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
		if (cspRunServerMethod(encmeth,'ChangeUsrPin','',p1,p2,p3)=='0') {
		obj.className='clsInvalid';
		//websys_setfocus('RegNo');
		return websys_cancel();
		}
}

function ChangeUsrPin(value) {
	try {
		  //var Patdetail=value.split("^");		
		  // alert(value)
		  if (value=="99"){
				alert(t["oldpwderror"])
				return	  
		  } 
		  if (value!="0"){
		  	    alert(t["updatefailed"])
		  	    return
		  }
		  alert(t["ok"])
		  var obj=document.getElementById('NewPin1');
			if (obj) obj.value="";
			var obj=document.getElementById('NewPin2');
			if (obj) obj.value="";
			var obj=document.getElementById('OldPin');
			if (obj) obj.value="";
		   //websys_setfocus('NewPin1');
		} catch(e) {};
}

document.body.onload = BodyLoadHandler;
//document.body.onunload = BodyUnLoadHandler;
