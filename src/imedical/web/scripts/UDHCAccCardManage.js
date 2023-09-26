        var Guser;
	var GuserCode;
	var RegNo;
	var PatientID;
	var PatName;
	var CardNo;
	var CardVerify;
	var ExchCardVerify;
	var IDCardNo;
	var RegNoobj;
	var CardNoobj;
	var CardIDobj;
	var PatNameobj;
	var PatientIDobj;
	var IDCardNoobj;
	var ActiveFlagobj;
	var Flagobj;
	var DateFromobj;
	var DateToobj;
	var ExchangeCardNoobj;
	var CredTypeobj;
	var ExchangeCardobj;
	var getpatclassobj;
	var Grantobj;
	var Exchangeobj;
	var ReportTheLossobj;
	var Cancelobj;
	var Clearobj;
	var readcardobj;
	var computername
	var today;
function BodyLoadHandler() {
	
	Guser=session['LOGON.USERID']
	GuserCode=session["LOGON.USERCODE"];
	RegNoobj=document.getElementById('RegNo');
	CardNoobj=document.getElementById('CardNo');
	CardIDobj=document.getElementById('CardID');
	PatNameobj=document.getElementById('PatName');
	PatientIDobj=document.getElementById('PatientID');
	IDCardNoobj=document.getElementById('IDCardNo');
	ActiveFlagobj=document.getElementById('ActiveFlag');
	Flagobj=document.getElementById('Flag');
	DateFromobj=document.getElementById('DateFrom');
	DateToobj=document.getElementById('DateTo');
	ExchangeCardNoobj=document.getElementById('ExchangeCardNo');
	CredTypeobj=document.getElementById('CredType');
	ExchangeCardobj=document.getElementById('ExchangeCard');
	getpatclassobj==document.getElementById('getpatclass');
	Grantobj=document.getElementById('GrantCard');
	Exchangeobj=document.getElementById('ExchCard');
	ReportTheLossobj=document.getElementById('ReportTheLoss');
	Cancelobj=document.getElementById('Cancel');
	Clearobj=document.getElementById('Clear');
	readcardobj=document.getElementById('readcard');
	if (readcardobj) readcardobj.onclick = ReadMagCard_Click
	if (Grantobj) Grantobj.onclick = Grant_Click;
	if (Exchangeobj) Exchangeobj.onclick = Exchange_Click;
	if (ReportTheLossobj) ReportTheLossobj.onclick = ReportTheLoss_Click;
	if (Cancelobj) Cancelobj.onclick = Cancel_Click;
	if (Clearobj) Clearobj.onclick = Clear_Click;
	if (ExchangeCardobj) ExchangeCardobj.onclick = ExchangeCard_Click;
	if (RegNoobj) RegNoobj.onkeydown = getpatbyRegNo;
	if (CardNoobj) CardNoobj.onkeydown = getpatbyCardNo;
	if (IDCardNoobj) IDCardNoobj.onkeydown = getpatbyIDCardNo;
	
	//getpath();
	//gettoday();
    CardNoobj.readOnly=true;
    ActiveFlagobj.readOnly=true;
    Flagobj.readOnly=true;
    ExchangeCardNoobj.readOnly=true;
    PatNameobj.readOnly=true;
    CardVerify="";
    ExchCardVerify="";
    var WshNetwork = new ActiveXObject("WScript.NetWork");
	computername=WshNetwork.ComputerName;
    websys_setfocus('RegNo');
    if (RegNoobj.value!=""){
			getpatbyregno1(RegNoobj.value);
		}
}

function Clear_Click()
{	
	//Grant_Click()
	//Exchange_Click()
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccCardManage";
	}	
function getpatbyRegNo()
{
    var key=websys_getKey(e);
	if (key==13) {
		if (RegNoobj.value!=""){
			getpatbyregno1(RegNoobj.value)
		}
	}
function getpatbyregno1(regno)
{
	if (regno=="") return;
	p1=regno
	
			var getregno=document.getElementById('getpatclass');
		
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				if (cspRunServerMethod(encmeth,'setpatinfo_val','',p1,"","","","")=='1'){
			
				}
			
			}
	}
function setpatinfo_val(value)
	{
		//RegNo_"^"_papmi_"^"_name_"^"_IDCardNo_"^"_CardNo_"^"_SecurityNO_"^"_ActiveFlag_"^"_DateFrom_"^"_DateTo
		
		var val=value.split("^");
		
		if (val[0]==""){
			alert("no regno!")
			 websys_setfocus('RegNo');
			 return;
			}
		
		RegNoobj.value=val[0];
	
		RegNo=val[0];
		PatientIDobj.value=val[1];
		PatNameobj.value=val[2];
		IDCardNoobj.value=val[3];
		if (val[4]!=""){
		CardNoobj.value=val[4];
		CardVerify=val[5];
		ActiveFlagobj.value=val[6];
		DateFromobj.value=val[7];
		DateToobj.value=val[8];
		CardIDobj.value=val[9];
		Flagobj.value=val[10];
		}
		else{
			//CardNoobj.value="";
			CardIDobj.value="";
		    //CardVerify="";
		    ActiveFlagobj.value="";
		    Flagobj.value="";
			websys_setfocus('CardNo');
		}
		
		}
function getpatbycard()
{
	if (CardNoobj.value!=""){
			p1=CardNoobj.value
			p2=CardVerify
			
			var getregno=document.getElementById('getpatclass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				if (cspRunServerMethod(encmeth,'setpatinfo_val2','',"","",p1,p2,"")=='1'){
			
				}
			
			}
	}
function getpatbyCardNo()
{
	
	var key=websys_getKey(e);
	if (key==13) {
		getpatbycard();
		}
	}	
function setpatinfo_val2(value)
	{
		//RegNo_"^"_papmi_"^"_name_"^"_IDCardNo_"^"_CardNo_"^"_SecurityNO_"^"_ActiveFlag_"^"_DateFrom_"^"_DateTo
		//alert(value)
		var val=value.split("^");
		
		
		if (val[4]!=""){
		//CardNoobj.value=val[4];
		//CardVerify=val[5];
		RegNoobj.value=val[0];
		RegNo=val[0];
		PatientIDobj.value=val[1];
		PatNameobj.value=val[2];
		IDCardNoobj.value=val[3];
		ActiveFlagobj.value=val[6];
		DateFromobj.value=val[7];
		DateToobj.value=val[8];
		CardIDobj.value=val[9];
		}
		else{
			//CardNoobj.value="";
			CardIDobj.value="";
		    //CardVerify="";
		    ActiveFlagobj.value="";
			websys_setfocus('RegNo');
		}
		
		}
function getpatbyIDCardNo()
{
	
	}	

function ExchangeCard_Click() {
	 if (ExchangeCardobj.checked){
		 ExchangeCardNoobj.readOnly=false; 
		 }
	 else{
		 ExchangeCardNoobj.value="";
		 ExchCardVerify="";
	     ExchangeCardNoobj.readOnly=true;
	 
	 }
	}

function Exchange_Click() {
	 
	if (CardIDobj.value=="")
	 {
		alert("no card no!")
			 
			 return;
		 }
	if (ExchangeCardNoobj.value=="")
	 {
		alert("no Exchange Card No!")
			 websys_setfocus('ExchangeCardNo');
			 return;
		 }

	if (ActiveFlagobj.value!="N"&&ActiveFlagobj.value!="S")
	 {
		alert("no normal card no!")
			
			 return;
		 }
	
	ExchCardVerify=""
	//str=CardID_"^"_CardNo_"^"_SecurityNO_"^"_user_"^"_IP
	p1=CardIDobj.value+"^"+ExchangeCardNoobj.value+"^"+ExchCardVerify+"^"+Guser+"^"+computername
	  //alert(p1)
			var getregno=document.getElementById('exchangeclass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				
				var ren=cspRunServerMethod(encmeth,'','',p1)
				//alert(ren)
				var myary=ren.split("^");
				
				if (myary[0]=='0'){
					CardIDobj.value=myary[2]
					CardNoobj.value=myary[3]
					window.status="save ok,write card..."
					ren=DHCACC_WrtMagCard("23",ExchangeCardNoobj.value,myary[1])
					//alert(ren);
					//alert("grant card ok");
					if (ren=='-5') {alert("save ok,user cancel write card");return;}
					if (ren=='1'){ alert("write card ok");
									Clear_Click();
					}
					else
					{ alert("write card failed")}
				}
				else
				{alert("save failed");}
		 
	}
function ReportTheLoss_Click() {
	 if (CardIDobj.value=="")
	 {
		alert("no card no!")
			 
			 return;
		 }
	if (ActiveFlagobj.value!="N")
	 {
		alert("no normal card no!")
			
			 return;
		 }
	var truthBeTold = window.confirm("report the loss a card "+CardNoobj.value+" ,yes or no?");
     				if (!truthBeTold) {return;}
	//str=CardID_"^"_user_"^"_IP
	p1=CardIDobj.value+"^"+Guser+"^"+computername
	 // alert(p1)
			var getregno=document.getElementById('reportthelossclass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				
				var ren=cspRunServerMethod(encmeth,'','',p1)
				//alert(ren)
				if (ren=='0'){
			       alert("report the loss card ok")
				}
		        else
				{
					alert("report the loss card failed")
					}
	}
function Cancel_Click() {
	 
	
	
	 if (CardIDobj.value=="")
	 {
		alert("no card no!")
			 
			 return;
		 }
	if (ActiveFlagobj.value!="N")
	 {
		alert("no normal card no!")
			
			 return;
		 }
		var truthBeTold = window.confirm("cancel a card "+CardNoobj.value+" ,yes or no?");
     				if (!truthBeTold) {return;}
	//str=CardID_"^"_user_"^"_IP
	p1=CardIDobj.value+"^"+Guser+"^"+computername
	  //alert(p1)
			var getregno=document.getElementById('Cancelclass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				
				var ren=cspRunServerMethod(encmeth,'','',p1)
				//alert(ren)
				if (ren=='0'){
			     alert("Cancel card ok")
				}
			     else
			     {
				     alert(ren + " Cancel card failed ")
				}
	}
function Grant_Click() {
	
	 if (RegNoobj.value==""||PatientIDobj.value=="")
	 {
		 alert("no regno")
			 websys_setfocus('RegNo');
			 return;
		 }
	if (CardNoobj.value=="")
	 {
		alert("no card no!")
			 //websys_setfocus('CardNo');
			 return;
		 }
	if (CardIDobj.value!="")
	 {
		alert("card has exist!")
			 //websys_setfocus('CardNo');
			 return;
		 }
	  //RegNo_"^"_papmi_"^"_IDCardNo_"^"_CardNo_"^"_SecurityNO_"^"_DateFrom_"^"_DateTo
	  p1=RegNoobj.value+"^"+PatientIDobj.value+"^"+IDCardNoobj.value+"^"+CardNoobj.value+"^"+CardVerify+"^"+DateFromobj.value+"^"+DateToobj.value+"^"+Guser+"^"+computername
	 // alert(p1)
			var getregno=document.getElementById('grantclass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				
				var ren=cspRunServerMethod(encmeth,'','',p1)
				//alert(ren)
				var myary=ren.split("^");
				
				if (myary[0]=='0'){
					window.status="save ok,write card..."
					ren=DHCACC_WrtMagCard("3","",myary[1])
					//alert(ren);
					//alert("grant card ok");
					if (ren=='-5') {alert("save ok,user cancel write card");return;}
					if (ren=='1'){ 
							var truthBeTold = window.confirm("write card ok,new a account?");
     				if (truthBeTold) {
	     				location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccManage&RegNo="+RegNoobj.value;
	     				return;
	     				}
     				else
						{	//alert("write card ok");
							Clear_Click();
						}
					}
					else
					{ alert("write card failed")}
				}
				else if (myary[0]=='-302')
				{alert("patient has a card");}
				else if (myary[0]=='-303')
				{alert("no card no");}
				else if (myary[0]=='-304')
				{alert("card has exist");}
				else
				{alert("save failed");}
	}
function rtncard_val(value)
{
	
	}
function ReadMagCard_Click(){
	var obj=document.getElementById("ClsHFCard");
	if (obj){
		
		var rtn=obj.ReadMagCard("23");
		//obj.DHCACC_ReadMagCard("2");
		//obj.DHCACC_ReadMagCard("3");
		//obj.DHCACC_WrtMagCard("");
		//alert(rtn)
		var myary=rtn.split("^");
		if (myary[0]=="0"){
			if (ExchangeCardobj.checked==true){
			    ExchangeCardNoobj.value=myary[1];
			    ExchCardVerify=myary[2];	
				}
			else
			{
			//CardNo=myary[1];
			CardNoobj.value=myary[1];
			CardVerify=myary[2];
			//websys_setfocus('CardNo');
			getpatbycard();}
		}
	//	alert(rtn);
	}
	
	
}

///document.onkeydown = DHCWeb_EStopSpaceKey;

document.body.onload = BodyLoadHandler;