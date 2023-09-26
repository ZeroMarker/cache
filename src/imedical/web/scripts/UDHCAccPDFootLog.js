        var Guser;
	var GuserCode;
	var GuserName;
	var RegNo;
	var PatientID;
	var PatName;
	var CardNo;
	var CardVerify;
	var ExchCardVerify;
	var IDCardNo;
	var UserIDobj;
	var StartDateobj;
	var StartTimeobj;
	var EndDateobj;
	var EndTimeobj;
	var AmtSumobj;
	var ReceiptsNumobj;
	var RefundNumobj;
	var ReceiptsFieldobj;
	var CashAmtobj;
	var ChequeAmtobj;
	var OtherAmtobj;
	var Footobj;
	var Printobj;
	var Findobj;
	var PDFootDetailobj;
	var Pamtobj;
	var Ramtobj;
	var today;
	
function BodyLoadHandler() {
	Guser=session['LOGON.USERID']
	GuserCode=session["LOGON.USERCODE"];
	GuserName=session['LOGON.USERNAME']
	UserIDobj=document.getElementById('UserID');
	UserIDobj.value=Guser
	StartDateobj=document.getElementById('StartDate');
	StartTimeobj=document.getElementById('StartTime');
	EndDateobj=document.getElementById('EndDate');
	EndTimeobj=document.getElementById('EndTime');
	AmtSumobj=document.getElementById('AmtSum');
	ReceiptsNumobj=document.getElementById('ReceiptsNum');
	RefundNumobj=document.getElementById('RefundNum');
	ReceiptsFieldobj=document.getElementById('ReceiptsField');
	CashAmtobj=document.getElementById('CashAmt');
	ChequeAmtobj=document.getElementById('ChequeAmt');
	OtherAmtobj=document.getElementById('OtherAmt');
	Footobj=document.getElementById('Foot');
	Printobj=document.getElementById('Print');
	Findobj=document.getElementById('Find');
	PDFootDetailobj=document.getElementById('PDFootDetail');
	Pamtobj=document.getElementById('Pamt');
	Ramtobj=document.getElementById('Ramt');
	today=document.getElementById('ToDay').value;
	if (Findobj) Findobj.onclick = Find_Click;
	if (Footobj) Footobj.onclick = Foot_Click;
	if (Printobj) Printobj.onclick = Print_Click;
	if (PDFootDetailobj) PDFootDetailobj.onclick = PDFootDetail_Click;
	
	
	//getpath();
	//gettoday();
	
    setreadonly();
    DHCP_GetXMLConfig("InvPrintEncrypt","UDHCAccPDFootLog");
    
     
    
}

function setreadonly()
{
	StartDateobj.readOnly=true;
	StartTimeobj.readOnly=true;
	EndDateobj.readOnly=true;
	EndTimeobj.readOnly=true;
	AmtSumobj.readOnly=true;
	ReceiptsNumobj.readOnly=true;
	RefundNumobj.readOnly=true;
	ReceiptsFieldobj.readOnly=true;
	CashAmtobj.readOnly=true;
	ChequeAmtobj.readOnly=true;
	OtherAmtobj.readOnly=true;
	Pamtobj.readOnly=true;
	Ramtobj.readOnly=true;
	getPDbyUser();
	}
function Find_Click()
{
    getPDbyUser();	
	}
function Foot_Click()
{
	if (ReceiptsNumobj.value<1)
	{
	    alert("no deposit data");
		return;	
		}
	DHCWeb_DisBtn(Footobj);
	if (Guser!=""){
			p1=Guser
			p2=ReceiptsNumobj.value
			p3=AmtSumobj.value
			var getregno=document.getElementById('FootClass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				var rtn=cspRunServerMethod(encmeth,p1,p2,p3)
				//alert(rtn)
				if (rtn=="-2"){
					alert(t[2048]);
					Footobj.disabled=false;
					Footobj.onclick = Foot_Click;
					return;
					}
				if (rtn=="-3"){
					alert(t[2049]);
					Footobj.disabled=false;
					Footobj.onclick = Foot_Click;
					return;
					}
				if (rtn=="0"){
					alert(t[2050]);
					return;
					}
				else
				{
					alert(rtn + t[2015]);
					Footobj.disabled=false;
					Footobj.onclick = Foot_Click;
					return;
					}
			    
			}
	}
function Print_Click()
{
	var TxtInfo,ListInfo
	var c=String.fromCharCode(2)
	TxtInfo="StartDate"+c+StartDateobj.value+"^"+"StartTime"+c+StartTimeobj.value+"^"+"EndDate"+c+EndDateobj.value+"^"+"EndTime"+c+EndTimeobj.value+"^"
	TxtInfo=TxtInfo+"AmtSum"+c+AmtSumobj.value+"^"+"CashAmt"+c+CashAmtobj.value+"^"+"Pamt"+c+Pamtobj.value+"^"+"Ramt"+c+Ramtobj.value+"^"
	TxtInfo=TxtInfo+"ChequeAmt"+c+ChequeAmtobj.value+"^"+"OtherAmt"+c+OtherAmtobj.value+"^"+"ReceiptsNum"+c+ReceiptsNumobj.value+"^"+"RefundNum"+c+RefundNumobj.value+"^"
	TxtInfo=TxtInfo+"GuserName"+c+GuserName+"^"+"PrintDate"+c+today
	//alert(TxtInfo)
	//return
	ListInfo=""
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
	}
function PDFootDetail_Click()
{	
	var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccPDDetail&USERID='+Guser+'&FOOTID=0';
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=780,height=520,left=0,top=0')
	//location.href='websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccPDDetail&USERID='+Guser+'&FOOTID=0';
}
	
function getPDbyUser()
{
    
		if (Guser!=""){
			p1=Guser
			var getregno=document.getElementById('FindClass');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				var rtn=cspRunServerMethod(encmeth,'','',p1)
				if (rtn=="-2"){
					alert(t[2047]);
					return;
					}
			    setpdinfo_val(rtn);
			}
	
	}

function setpdinfo_val(value)
	{
		//footnum_"^"_refundnum_"^"_footsum_"^"_pdsum_"^"_refundsum_"^"_cashsum_"^"_chequesum_"^"_othersum_"^"_stdate_"^"_sttime_"^"_enddate_"^"_endtime_"^"_rcptstr
	//	alert(value)
		
		var val=value.split("^");
		if (val[0]=="0"){
			alert(t[2047])
			return;
			}
	StartDateobj.value=val[8];
	StartTimeobj.value=val[9];
	EndDateobj.value=val[10];
	EndTimeobj.value=val[11];
	AmtSumobj.value=val[2];
	ReceiptsNumobj.value=val[0];
	RefundNumobj.value=val[1];
	ReceiptsFieldobj.value=val[12];
	CashAmtobj.value=val[5];
	ChequeAmtobj.value=val[6];
	OtherAmtobj.value=val[7];
	Pamtobj.value=val[3];
	Ramtobj.value=val[4];
		
		}

document.body.onload = BodyLoadHandler;