///DHCWeb.OPMagCard.JS
///
///Read Card : obj.ReadMagCard("2");
///Write Card : obj.WriteMagCard("")

function DHCACC_ReadMagCard(){
	///Return Card No and PAADM
	var myCardNo="";
	var myCheckNo="";
	var rtn=-1;
	var obj=document.getElementById("ClsHFCard");
	if (obj){
		var rtn=obj.ReadMagCard("23");
		
		var myary=rtn.split("^");
		rtn=myary[0];
		
		if (myary[0]=="0"){
			rtn=0;
			myCardNo=myary[1];
			myCheckNo=myary[2];
		}
	}
	return rtn+"^"+myCardNo+"^"+myCheckNo;
}

function DHCACC_GetPAPMINo(CardNo){
	///Read PAPMINo by CardNo
	var obj=document.getElementById("ReadAccEncrypt");
	if (obj){var encmeth=obj.value;}
	if (encmeth!=""){
		var myCardNo=CardNo;
		var myCheckNo="";
		var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo)
		var myary=myrtn.split("^");
		rtn=myary[0];
		///var myAccRowID=myary[1];
		var myLeftM=myary[3];
		var myPAPMI=myary[7];
		var myPAPMNo=myary[8];
	}
	return rtn+"^"+myPAPMNo
}

function DHCACC_GetAccInfoFNoCard(CardNo,CheckNo){
	var encmeth="";
	myCardNo=CardNo;
	myCheckNo=CheckNo;
	var obj=document.getElementById("ReadAccEncrypt");
	if (obj){var encmeth=obj.value;}
	///var encmeth=DHCWebD_GetObjValue("ReadAccEncrypt");
	if (encmeth!=""){
		var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo)
		var myary=myrtn.split("^");
		rtn=myary[0];
		///var myAccRowID=myary[1];
		var myLeftM=myary[3];
		var myPAPMI=myary[7];
		var myPAPMNo=myary[8];
	}
	///alert(rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo);
	return rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
}

function DHCACC_GetAccInfo()
{
	////Read Patient Active Account Info for Show
	var myrtn =DHCACC_ReadMagCard()
	var rtn=0;
	var myLeftM=0;
	var myAccRowID="";
	var myPAPMI="";
	var myPAPMNo=""
	var myCardNo="";
	var myCheckNo="";
	
	var myary=myrtn.split("^");
	var encmeth="";
	if (myary[0]==0){
		rtn=myary[0];
		myCardNo=myary[1];
		myCheckNo=myary[2];
		var obj=document.getElementById("ReadAccEncrypt");
		if (obj){var encmeth=obj.value;}
		///var encmeth=DHCWebD_GetObjValue("ReadAccEncrypt");
		if (encmeth!=""){
			var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo)
			var myary=myrtn.split("^");
			rtn=myary[0];
			var myAccRowID=myary[1];
			var myLeftM=myary[3];
			var myPAPMI=myary[7];
			var myPAPMNo=myary[8];
			var myAccType=myary[10];
		}
	}else{
		rtn=myary[0];
	}
	///alert(rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo);
	return rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo+"^"+myAccType+"^"+myAccRowID;
}

function DHCACC_CheckMCFPayTest(PatSum){
	
	return "0^2^^"
}

function DHCACC_CheckMCFPayFNoCard(PatSum,CardNo){
	////Check Pay For No Card
	////CardNo=PAPMINo
	var rtn=0;
	var myAccRowID="";
	var myCheckNo="";
	var myAccPWD="";
	var myBalance=0;
	var myAccType="";
	
	var encmeth="";
	
	var myCardNo=CardNo;
	var myCheckNo=CardNo;
	if (myCardNo!=CardNo){
		rtn=-206;
	}
	///Get DHC_AccManager PWD
	///##class(web.UDHCAccManageCLS).getaccinfofromcardno(cardno, securityno)
	///ReadAccEncrypt
	var obj=document.getElementById("ReadAccEncrypt");
	if (obj){var encmeth=obj.value;}
	///var encmeth=DHCWebD_GetObjValue("ReadAccEncrypt");
	if (encmeth==""){rtn=-299;}
	if ((rtn==0)){
		var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo)
		var myary=myrtn.split("^");
		rtn=myary[0];
		///alert(myary[0])
		if (rtn==0){
			var myAccRowID=myary[1];
			var myLeftM=myary[3];
			var myAccPWD=myary[6];
			////myExpstr=PWDCount^^^^myCheckNo
			var myExpstr="0^^^^"+myCheckNo
			
			var obj=document.getElementById("ClsPWD");
			if (obj){
				var rtn=obj.CheckPWD(myAccPWD, myExpstr);	////Read 2 and 3
			}
			if (isNaN(PatSum)){PatSum=0;}
			if (isNaN(myLeftM)){myLeftM=0;}
			if (+PatSum>+myLeftM){
				myBalance=PatSum-myLeftM;
				rtn=-205;
			}
		}
	}else{
		
	}
	
	return rtn+"^"+myAccRowID+"^"+myCheckNo+"^"+myAccPWD+"^"+myBalance	
}

function DHCACC_CheckMCFPay(PatSum,CardNo){
	///check the Mag Card For Pay
	///return 0  ;for pay  and AccManRID  Info
	///return not 0  alert to user
	var rtn=0;
	var myAccRowID="";
	var myCheckNo="";
	var myAccPWD="";
	var myBalance=0;
	var myFactLeftM=0;
	
	alert(t["CardTip"]);
	var obj=document.getElementById("ClsHFCard");
	if (obj){
		var myrtn=obj.ReadMagCard("23");	////Read 2 and 3
	}
	var encmeth="";
	var myary=myrtn.split("^");
	if (myary[0]=="0"){
		var myCardNo=myary[1];
		var myCheckNo=myary[2];
		
		///Get DHC_AccManager PWD
		///##class(web.UDHCAccManageCLS).getaccinfofromcardno(cardno, securityno)
		///ReadAccEncrypt
		var obj=document.getElementById("ReadAccEncrypt");
		if (obj){var encmeth=obj.value;}
		///var encmeth=DHCWebD_GetObjValue("ReadAccEncrypt");
		if (encmeth==""){rtn=-299;}
		if ((rtn==0)){
			var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo)
			var myary=myrtn.split("^");
			rtn=myary[0];
			////Check Card
			if ((rtn==0)){
				var myAccType=myary[10];
				if ((myCardNo!=CardNo)&&(myAccType!="C")){
					rtn=-206;
				}
			}
			
			if (rtn==0){
				var myAccRowID=myary[1];
				var myLeftM=myary[3];
				var myAccPWD=myary[6];
				////myExpstr=PWDCount^^^^myCheckNo
				var myExpstr="0^^^^"+myCheckNo
				var myFactLeftM=myary[4];
				var myAccType=myary[10];
				
				var obj=document.getElementById("ClsPWD");
				if (obj){
					var rtn=obj.CheckPWD(myAccPWD, myExpstr);	////Read 2 and 3
				}
				if (isNaN(PatSum)){PatSum=0;}
				if (isNaN(myLeftM)){myLeftM=0;}
				if (+PatSum>+myLeftM){
					myBalance=PatSum-myLeftM;
					rtn=-205;
				}
			}
		}else{
			
		}
	}else{
		rtn=myary[0];
	}
	
	return rtn+"^"+myAccRowID+"^"+myCheckNo+"^"+myAccPWD+"^"+myBalance+"^"+myFactLeftM
}

function DHCACC_CheckMCFPayExp(PatSum,CardNo,ExpStr)
{
	///check the Mag Card Exp For Pay
	///return 0  ;for pay  and AccManRID  Info
	///return not 0  alert to user
	///ExpStr=AdmStr_String.FromCode(2)_
	///AdmStr=AdmRowID1^AdmRowID2^AdmRowID3
	
	var rtn=0;
	var myAccRowID="";
	var myCheckNo="";
	var myAccPWD="";
	var myBalance=0;
	var myFactLeftM=0;
	
	alert(t["CardTip"]);
	var obj=document.getElementById("ClsHFCard");
	if (obj){
		var myrtn=obj.ReadMagCard("23");	////Read 2 and 3
	}
	var encmeth="";
	var myary=myrtn.split("^");
	if (myary[0]=="0"){
		var myCardNo=myary[1];
		var myCheckNo=myary[2];
		if (myCardNo!=CardNo){
			rtn=-206;
		}
		
		///Get DHC_AccManager PWD
		///##class(web.UDHCAccManageCLS).getaccinfofromcardno(cardno, securityno)
		///ReadAccEncrypt
		var obj=document.getElementById("ReadAccExpEncrypt");
		if (obj){var encmeth=obj.value;}
		///var encmeth=DHCWebD_GetObjValue("ReadAccEncrypt");
		if (encmeth==""){rtn=-299;}
		if ((rtn==0)){
			var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo,ExpStr);
			var myary=myrtn.split("^");
			rtn=myary[0];
			if (rtn==0){
				var myAccRowID=myary[1];
				var myLeftM=myary[3];
				var myAccPWD=myary[6];
				////myExpstr=PWDCount^^^^myCheckNo
				var myExpstr="0^^^^"+myCheckNo
				var myFactLeftM=myary[5];
				
				var obj=document.getElementById("ClsPWD");
				if (obj){
					var rtn=obj.CheckPWD(myAccPWD, myExpstr);	////Read 2 and 3
				}
				if (isNaN(PatSum)){PatSum=0;}
				if (isNaN(myLeftM)){myLeftM=0;}
				if (isNaN(myFactLeftM)){myFactLeftM=0;}
				if (+PatSum>+myLeftM){
					myBalance=PatSum-myLeftM;
					rtn=-205;
				}
				///myFactLeftM=myFactLeftM-PatSum;
				///myFactLeftM=myFactLeftM.toFixed(2);
			}
		}else{
			
		}
	}else{
		rtn=myary[0];
	}
	
	return rtn+"^"+myAccRowID+"^"+myCheckNo+"^"+myAccPWD+"^"+myBalance+"^"+myFactLeftM
}


function DHCACC_ChangePWD(myAccPWDStr,myExpStr)
{
	///change the pwd
	///input the PWD Stored in DB
	///myExpStr=1^^^^00000001123456   checkNO
	var rtn="";
	var obj=document.getElementById("ClsPWD");
	if (obj){
		var rtn=obj.ChangePWD(myAccPWDStr, myExpStr);	////Read 2 and 3
	}
	return rtn;
}

function DHCACC_GetValidatePWD(myVPWD)
{
	///myVPWD=checkNo
	var rtn="";
	var obj=document.getElementById("ClsPWD");
	if (obj){
		var rtn=obj.GetValidatePWD(myVPWD);	////Read 2 and 3
	}
	
	return rtn;	
}

function DHCACC_SetAccPWD()
{
	///the first time set PWD
	var rtn="";
	var obj=document.getElementById("ClsPWD");
	if (obj){
		var rtn=obj.AccPWDSet("1^^^^");	////Read 2 and 3
	}
	
	return rtn;	
	
}

function DHCACC_WrtMagCard(WType,mystr2,mystr3)
{
	////write card 
	var rtn=""
	var obj=document.getElementById("ClsHFCard");
	if (obj){
		var rtn=obj.WriteMagCard(WType,mystr2,mystr3);	////Read 2 and 3
	}
	
	return rtn;
}

function DHCACC_ReadMagCardNew(WType)
{
	var myCardNo="";
	var myCheckNo="";
	var rtn="";
	var obj=document.getElementById("ClsHFCard");
	if (obj){
		var rtn=obj.ReadMagCard(WType);
		var myary=rtn.split("^");
		rtn=myary[0];
		if (myary[0]=="0"){
			rtn=0;
			myCardNo=myary[1];
			myCheckNo=myary[2];
		}
	}
	return rtn+"^"+myCardNo+"^"+myCheckNo;
}

function DHCACC_CheckForNOCard(CardNo,CheckNo){
	///return 0  ;for pay  and AccManRID  Info
	///return not 0  alert to user
	var rtn=0;
	var myAccRowID="";
	var myCheckNo="";
	var myAccPWD="";
	
	var myCardNo=CardNo;
	var myCheckNo=CheckNo;
	var obj=document.getElementById("ReadAccEncrypt");
	if (obj){var encmeth=obj.value;}
	///var encmeth=DHCWebD_GetObjValue("ReadAccEncrypt");
	if (encmeth==""){rtn=-299;}
	if ((rtn==0)){
		var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo)
		var myary=myrtn.split("^");
		rtn=myary[0];
		if (rtn==0){
			var myAccRowID=myary[1];
			var myLeftM=myary[3];
			var myAccPWD=myary[6];
			////myExpstr=PWDCount^^^^myCheckNo
			var myExpstr="0^^^^"+myCheckNo
			
			var obj=document.getElementById("ClsPWD");
			if (obj){
				//var rtn=obj.CheckPWD(myAccPWD, myExpstr);	////Read 2 and 3
				var rtn=obj.CheckPWDFSuspend(myAccPWD, myExpstr);
			}
		}
	}else{
		
	}
	
	return rtn+"^"+myAccRowID+"^"+myCheckNo+"^"+myAccPWD
}

function GetAccLeftByPAPMI(PAPMI,TolSum){
	////
	var obj=document.getElementById("GetAccByPAPMIEncrypt");
	if (obj){var encmeth=obj.value;}
	///var encmeth=DHCWebD_GetObjValue("ReadAccEncrypt");
	var myrtn=""
	if (encmeth!=""){
		var myrtn=cspRunServerMethod(encmeth,PAPMI,TolSum, "")
	}
	
	return myrtn;
}

function DHCACC_CheckCardNoForDeposit(CardNo){
	var myrtn=true;
	
	var myCardInfo =DHCACC_ReadMagCard()
	var myLeftM=0;
	var myPAPMI="";
	var myPAPMNo=""
	var myCardNo="";
	var myCheckNo="";
	
	var myary=myCardInfo.split("^");
	if (myary[0]=="0"){
		rtn=myary[0];
		myCardNo=myary[1];
		myCheckNo=myary[2];
		if (CardNo!=myCardNo){
			myrtn=false;
		}
	}else{
		myrtn=false;
	}
	
	return myrtn;
}

function DHCACC_WrtMagCard2(WType,mystr2,mystr3)
{
	////write card 
	//alert(WType);
	//alert(mystr2);
	//alert(mystr3);
	var rtn=""
	var obj=document.getElementById("ClsHFCard");
	//alert(obj)
	if (obj){
		var rtn=obj.takeCard(WType,mystr2,mystr3);	////Read 2 and 3
	}
	
	return rtn;
}
