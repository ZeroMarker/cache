////DHCWeb.OPCommonManageCard.JS
///Read Card : obj.ReadMagCard("2");
///Write Card : obj.WriteMagCard("")
///
///Read Or Write Card
///Select Or Update Account
///

///Appoint Funciton for ReadCard
///Ver 1.0  no In parameter
///Ver 2.0  Add CardTypeRowID
///Use Function Example
///1.  DHCACC_ReadMagCard()
///2.  DHCACC_ReadMagCard(CardTypeDR)
function DHCACC_ReadMagCard()
{
	//Note:
	//arguments[0]		CardTypeRowID
	//
	var myrtn="";
	
	var myCount=0;
	for(var i=0;i <arguments.length;i++){
		myCount++;
	}
	//alert(myCount);
	switch (myCount){
		case 0:
			myrtn = DHCACC_ReadMagCard1();
			break;
		case 1:
			myrtn = DHCACC_ReadMagCard2(arguments[0],"","","")
			break;
		default:
			
			break;
	}
	
	return myrtn;
}
/*
function DHCACC_ReadMagCard1(){
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
*/
function DHCACC_ReadMagCard2(HardType, InPara1, InPara2, InPara3){
	///Return Card No and PAADM
	//alert("DHCACC_ReadMagCard2"+":"+HardType);
	var myCardNo="";
	var myCheckNo="";
	var rtn=-1;

	//var HardTypeCode=tkMakeServerCall("web.DHCBL.CARD.CardTypeDef","GetHardTypeCode",HardType);
	//alert("aaaaaa");
	var HardTypeCode=MyRunClassMethod("web.DHCBL.CARD.CardTypeDef","GetHardTypeCode",{"RowId":HardType});
	//alert(HardType+","+HardTypeCode)
	if(HardTypeCode=="Ò»¿¨Í¨"){
		//var rtn=DHCHardComm_RandomCardEquip(HardType,"R", InPara1, InPara2, InPara3)
		var rtn=DHCHardComm_RandomCardEquip(HardType,"R", "23", "", "");    //È±Ê§
		var myary=rtn.split("^");
		rtn=myary[0];
		
		if (myary[0]=="0"){
			rtn=0;
			myCardNo=myary[1];
			myCheckNo=myary[2];
			DHCACC_DisabledCardType("CardType",myCardNo);     
			DHCACC_DisabledCardType("CardTypeDefine",myCardNo);  //OK
		}
	}
	if(HardTypeCode=="¾©Ò½Í¨"){
		var ReadJYTCardInfo=GetPersonInfo();   //È±Ê§
		var ReadJYTCardInfo1=ReadJYTCardInfo.split("^");
		if (ReadJYTCardInfo1[0]=="Y") {
			rtn=0;
			myCardNo=ReadJYTCardInfo1[4];
		}else{alert(ReadJYTCardInfo1[3]);}
	}
	return rtn+"^"+myCardNo+"^"+myCheckNo;
}
/*
///Use Function Example
///1.  DHCACC_WrtMagCard(WType, mystr2, mystr3)
///2.  DHCACC_WrtMagCard(WType, mystr2, mystr3, CardTypeDR)
function DHCACC_WrtMagCard()
{
	///Ver 1.0  Input 3 parameters
	///Ver 2.0  Input 4 parameters
	///myWtype=arguments[0]
	///mystr2=arguments[1]
	///mystr3 = arguments[2]
	///myCTRowID=arguments[3];
	
	var myrtn=""
	var myCount=0;
	for(var i=0;i <arguments.length;i++){
		myCount++;
	}
	switch (myCount){
		case 3:
			var myWtype=arguments[0];
			var mystr2=arguments[1];
			var mystr3 = arguments[2];
			myrtn = DHCACC_WrtMagCard1(myWtype,mystr2,mystr3);
			break;
		case 4:
			var myWtype=arguments[0];
			var mystr2=arguments[1];
			var mystr3 = arguments[2];
			var myCTRowID=arguments[3];
			myrtn = DHCACC_WrtMagCard2(myWtype,mystr2,mystr3,myCTRowID);
			break;
		default:
			
			break;
	}
	return myrtn;
	
}

function DHCACC_WrtMagCard1(WType,mystr2,mystr3)
{
	////write card 
	var rtn=""
	var obj=document.getElementById("ClsHFCard");
	if (obj){
		var rtn=obj.WriteMagCard(WType,mystr2,mystr3);	////Read 2 and 3
	}
	
	return rtn;
}

function DHCACC_WrtMagCard2(WType,mystr2,mystr3, CardTypeRowID)
{
	////write card
	var rtn=""
	//alert(HardType+ " WType: " +WType + " mystr2: " + mystr2 + " mystr3: "+ mystr3);
	var rtn=DHCHardComm_RandomCardEquip(CardTypeRowID,"W", WType, mystr2, mystr3, "");
	
	return rtn;
}

function DHCACC_GetPAPMINo(CardNo){
	///Read PAPMINo by CardNo
	//var obj=document.getElementById("ReadAccEncrypt");
	//if (obj){var encmeth=obj.value;}
	//if (encmeth!=""){
		var myCardNo=CardNo;
		var myCheckNo="";
		//var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo)
		var myrtn=MyRunClassMethod("web.UDHCAccManageCLS","getaccinfofromcardno",{"cardno":myCardNo,"securityno":myCheckNo})
		//ClassMethod getaccinfofromcardno(cardno As %Library.String, securityno As %Library.String) As %Library.String
		var myary=myrtn.split("^");
		rtn=myary[0];
		///var myAccRowID=myary[1];
		var myLeftM=myary[3];
		var myPAPMI=myary[7];
		var myPAPMNo=myary[8];
	//}
	return rtn+"^"+myPAPMNo
}

function DHCACC_GetAccInfoFNoCard(CardNo,CheckNo){
	var encmeth="";
	myCardNo=CardNo;
	myCheckNo=CheckNo;
	//var obj=document.getElementById("ReadAccEncrypt");
	//if (obj){var encmeth=obj.value;}
	///var encmeth=DHCWebD_GetObjValue("ReadAccEncrypt");
	//if (encmeth!=""){
	//var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo)
	var myrtn=MyRunClassMethod("web.UDHCAccManageCLS","getaccinfofromcardno",{"cardno":myCardNo,"securityno":myCheckNo});
	var myary=myrtn.split("^");
	rtn=myary[0];
	///var myAccRowID=myary[1];
	var myLeftM=myary[3];
	var myPAPMI=myary[7];
	var myPAPMNo=myary[8];
	//}
	///alert(rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo);
	return rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
}
*/
///Use Function Example
///1. DHCACC_GetAccInfo()
///2. DHCACC_GetAccInfo(CardTypeDR)
///3. DHCACC_GetAccInfo(CardTypeDR, CardNo, SecurityNo)		///User by Handle
///4. 
///5. DHCACC_GetAccInfo(CardTypeDR, CardTypeValue)
function DHCACC_GetAccInfo()
{
	///arguments[0]   myCardTypeDR
	///arguments[1]		myCardNo
	///arguments[2]		mySecurityNo
	///arguments[3]		myCheckSecrityFlag
	var myrtn="";
	var myCount=0;
	for(var i=0;i <arguments.length;i++){
		myCount++;
	}
	//alert(myCount);
	switch (myCount){
		case 0:
			myrtn = DHCACC_GetAccInfo1();
			break;
		case 1:
			var myCardTypeDR=arguments[0];
			myrtn = DHCACC_GetAccInfo2(myCardTypeDR);
			break;
		case 2:
			var myCardTypeDR=arguments[0];
			//var myEquipDR=arguments[1];
			var myCardTypeVal=arguments[1];
			var myary=myCardTypeVal.split("^");
			var myEquipDR=myary[14];
			myrtn = DHCACC_GetAccInfo5(myCardTypeDR,myEquipDR);
			break;
		case 3:
			var myCardTypeDR=arguments[0];
			var myCardNo=arguments[1];
			var mySecurityNo=arguments[2];
			myrtn = DHCACC_GetAccInfo3(myCardTypeDR, myCardNo, mySecurityNo)
			break;
		case 4:
			var myCardTypeDR=arguments[0];
			var myCardNo=arguments[1];
			var mySecurityNo=arguments[2];
			var myCheckSecrityFlag=arguments[3];
			myrtn = DHCACC_GetAccInfo4(myCardTypeDR, myCardNo, mySecurityNo, myCheckSecrityFlag);
			break;
		default:
			break;
	}
	return myrtn;
}
/*
function DHCACC_GetAccInfo1()
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
	var myGetCardTypeDR="";
	var mySCTTip="";
	
	var myary=myrtn.split("^");
	var encmeth="";
	if (myary[0]==0){
		rtn=myary[0];
		myCardNo=myary[1];
		myCheckNo=myary[2];
		//var obj=document.getElementById("ReadAccEncrypt");
		//if (obj){var encmeth=obj.value;}
		///var encmeth=DHCWebD_GetObjValue("ReadAccEncrypt");
		//if (encmeth!=""){
		//var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo)
		var myrtn=MyRunClassMethod("web.UDHCAccManageCLS","getaccinfofromcardno",{"cardno":myCardNo,"securityno":myCheckNo});
		var myary=myrtn.split("^");
		rtn=myary[0];
		var myAccRowID=myary[1];
		var myLeftM=myary[3];
		var myPAPMI=myary[7];
		var myPAPMNo=myary[8];
		var myAccType=myary[10];
//		}
	}else{
		rtn=myary[0];
	}
	///alert(rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo);
	return rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo+"^"+myAccType+"^"+myAccRowID+"^"+myGetCardTypeDR+"^"+mySCTTip;
}
*/
function DHCACC_GetAccInfo5(CardTypeDR, EquipDR)
{
	////Read Patient Active Account Info for Show
	////(HardType, InPara1, InPara2, InPara3)
	///DHCACC_ReadMagCard(m_CCMRowID, "R", "23","","");
	//alert("DHCACC_GetAccInfo5");
	var myrtn =DHCACC_ReadMagCard(EquipDR);
	//alert("DHCACC_GetAccInfo5");
	//alert(myrtn);
	var rtn=0;
	var myLeftM=0;
	var myAccRowID="";
	var myPAPMI="";
	var myPAPMNo=""
	var myCardNo="";
	var myCheckNo="";
	var myGetCardTypeDR="";
	var mySCTTip="";
	var myary=myrtn.split("^");
	var encmeth="";
	if (myary[0]==0){
		rtn=myary[0];
		myCardNo=myary[1];
		myCheckNo=myary[2];
		//var obj=document.getElementById("ReadAccExpEncrypt");
		
		//if (obj){var encmeth=obj.value;}
		///var encmeth=DHCWebD_GetObjValue("ReadAccExpEncrypt");
		//if (encmeth!=""){
		///
		var myExpStr=""+String.fromCharCode(2)+CardTypeDR;
		//var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo, myExpStr)
		var myrtn = MyRunClassMethod("web.UDHCAccManageCLSIF","getaccinfofromcardno",{"cardno":myCardNo,"securityno":myCheckNo,"ExpStr":myExpStr});
		//ClassMethod getaccinfofromcardno(cardno As %Library.String, securityno As %Library.String, ExpStr As %String) As %Library.String
		var myary=myrtn.split("^");
		rtn=myary[0];
		var myAccRowID=myary[1];
		var myLeftM=myary[3];
		var myPAPMI=myary[7];
		var myPAPMNo=myary[8];
		var myAccType=myary[10];
		if (myary.length>12){
			myGetCardTypeDR=myary[12];
		}
		if (myary.length>13){
			mySCTTip = myary[13];
		}
	//}
	}else{
		rtn=myary[0];
	}
	///alert(rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo);
	return rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo+"^"+myAccType+"^"+myAccRowID+"^"+myGetCardTypeDR+"^"+mySCTTip;
}
/*
function DHCACC_GetAccInfo2(CardTypeDR)
{
	////Read Patient Active Account Info for Show
	////(HardType, InPara1, InPara2, InPara3)
	///DHCACC_ReadMagCard(m_CCMRowID, "R", "23","","");
	var myrtn =DHCACC_ReadMagCard(CardTypeDR);
	var rtn=0;
	var myLeftM=0;
	var myAccRowID="";
	var myPAPMI="";
	var myPAPMNo=""
	var myCardNo="";
	var myCheckNo="";
	var myGetCardTypeDR="";
	var mySCTTip="";
	
	var myary=myrtn.split("^");
	var encmeth="";
	if (myary[0]==0){
		rtn=myary[0];
		myCardNo=myary[1];
		myCheckNo=myary[2];
		//var obj=document.getElementById("ReadAccExpEncrypt");
		//if (obj){var encmeth=obj.value;}
		///var encmeth=DHCWebD_GetObjValue("ReadAccExpEncrypt");
		//if (encmeth!=""){
			///
			var myExpStr=""+String.fromCharCode(2)+CardTypeDR;
			
			//var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo, myExpStr)
			var myrtn = MyRunClassMethod("web.UDHCAccManageCLSIF","getaccinfofromcardno",{"cardno":myCardNo,"securityno":myCheckNo,"ExpStr":myExpStr});
			var myary=myrtn.split("^");
			rtn=myary[0];
			var myAccRowID=myary[1];
			var myLeftM=myary[3];
			var myPAPMI=myary[7];
			var myPAPMNo=myary[8];
			var myAccType=myary[10];
			if (myary.length>12){
				myGetCardTypeDR=myary[12];
			}
			if (myary.length>13){
				mySCTTip = myary[13];
			}
		//}
	}else{
		rtn=myary[0];
	}
	///alert(rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo);
	return rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo+"^"+myAccType+"^"+myAccRowID+"^"+myGetCardTypeDR+"^"+mySCTTip;
}

function DHCACC_GetAccInfo3(CardTypeDR, CardNo, SecurityNo)
{
	var rtn=0;
	var myLeftM=0;
	var myAccRowID="";
	var myPAPMI="";
	var myPAPMNo=""
	var myCardNo="";
	var myCheckNo="";
	var myGetCardTypeDR="";
	var mySCTTip="";
	
	myCardNo=CardNo;
	myCheckNo=SecurityNo;
	var myCardTypeDR = CardTypeDR;
	//var obj=document.getElementById("ReadAccExpEncrypt");
	//if (obj){var encmeth=obj.value;}
	///var encmeth=DHCWebD_GetObjValue("ReadAccExpEncrypt");
	//if (encmeth!=""){
	var myExpStr=""+String.fromCharCode(2)+CardTypeDR;
	//var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo, myExpStr);
	var myrtn = MyRunClassMethod("web.UDHCAccManageCLSIF","getaccinfofromcardno",{"cardno":myCardNo,"securityno":myCheckNo,"ExpStr":myExpStr});
	var myary=myrtn.split("^");
	rtn=myary[0];
	var myAccRowID=myary[1];
	var myLeftM=myary[3];
	var myPAPMI=myary[7];
	var myPAPMNo=myary[8];
	var myAccType=myary[10];
	if (myary.length>12){
		myGetCardTypeDR=myary[12];
	}
	if (myary.length>13){
		mySCTTip = myary[13];
	}
	//}
	///alert(rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo);
	return rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo+"^"+myAccType+"^"+myAccRowID +"^"+myGetCardTypeDR+"^"+mySCTTip;
}

function DHCACC_GetAccInfo4(CardTypeDR, CardNo, SecurityNo, CheckSecurityFlag)
{
	var rtn=0;
	var myLeftM=0;
	var myAccRowID="";
	var myPAPMI="";
	var myPAPMNo=""
	var myCardNo="";
	var myCheckNo="";
	var myGetCardTypeDR="";
	var mySCTTip="";
	
	myCardNo=CardNo;
	myCheckNo=SecurityNo;
	var myCardTypeDR = CardTypeDR;
	//var obj=document.getElementById("ReadAccExpEncrypt");
	//if (obj){var encmeth=obj.value;}
	///var encmeth=DHCWebD_GetObjValue("ReadAccExpEncrypt");
	//if (encmeth!=""){
		var myExpStr=""+String.fromCharCode(2)+CardTypeDR;
		myExpStr += String.fromCharCode(2) + CheckSecurityFlag;
		//var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo, myExpStr);
		var myrtn = MyRunClassMethod("web.UDHCAccManageCLSIF","getaccinfofromcardno",{"cardno":myCardNo,"securityno":myCheckNo,"ExpStr":myExpStr});
		var myary=myrtn.split("^");
		rtn=myary[0];
		var myAccRowID=myary[1];
		var myLeftM=myary[3];
		var myPAPMI=myary[7];
		var myPAPMNo=myary[8];
		var myAccType=myary[10];
		if (myary.length>12){
			myGetCardTypeDR=myary[12];
		}
		if (myary.length>13){
			mySCTTip = myary[13];
		//}
	}
	///alert(rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo);
	return rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo+"^"+myAccType+"^"+myAccRowID +"^"+myGetCardTypeDR+"^"+mySCTTip;
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
	//var obj=document.getElementById("ReadAccEncrypt");
	//if (obj){var encmeth=obj.value;}
	///var encmeth=DHCWebD_GetObjValue("ReadAccEncrypt");  
	//if (encmeth==""){rtn=-299;}
	if ((rtn==0)){
		//var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo)
		var myrtn=MyRunClassMethod("web.UDHCAccManageCLS","getaccinfofromcardno",{"cardno":myCardNo,"securityno":myCheckNo});
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

///Account Paying  Check Left Money
///User Function Example 
///DHCACC_CheckMCFPay(PatSum,CardNo)
///DHCACC_CheckMCFPay(PatSum,CardNo,AdmStr, CardTypeDR)
///DHCACC_CheckMCFPay(PatSum,CardNo,AdmStr, CardTypeDR, SecurityNo)    by Hand Input CardNo
function DHCACC_CheckMCFPay()
{
	///arguments[0]	= PatSum
	///arguments[1]	= CardNo   the Old Card No
	///arguments[2]	= AdmStr
	///arguments[3]	= CardTypeDR
	///arguments[4]	= SecurityNo
	
	var myrtn="";
	
	var myCount=0;
	for(var i=0;i <arguments.length;i++){
		myCount++;
	}
	switch (myCount){
		case 2:
			var myPatSum = arguments[0];
			var myCardNo = arguments[1];
			myrtn = DHCACC_CheckMCFPay1(myPatSum, myCardNo);
			break;
		case 4:
			var myPatSum = arguments[0];
			var myCardNo = arguments[1];
			var myAdmStr = arguments[2];
			var myCardTypeDR=arguments[3];
			
			myrtn = DHCACC_CheckMCFPay2(myPatSum, myCardNo, myAdmStr, myCardTypeDR);
			break;
		case 5:
			var myPatSum = arguments[0];
			var myCardNo = arguments[1];
			var myAdmStr = arguments[2];
			var myCardTypeDR=arguments[3];
			var mySecurityNo=arguments[4];
			myrtn = DHCACC_CheckMCFPayByHand(myPatSum, myCardNo, myAdmStr, myCardTypeDR, mySecurityNo);			
			break;
	}
	
	return myrtn;
}

function DHCACC_CheckMCFPay1(PatSum,CardNo){
	///check the Mag Card For Pay
	///return 0  ;for pay  and AccManRID  Info
	///return not 0  alert to user
	var rtn=0;
	var myAccRowID="";
	var myCheckNo="";
	var myAccPWD="";
	var myBalance=0;
	var myFactLeftM=0;
	
	//alert(t["CardTip"]);
	alert("Çë·Å¿¨!");
	//var obj=document.getElementById("ClsHFCard");
	//if (obj){
	//	var myrtn=obj.ReadMagCard("23");	////Read 2 and 3
	//}
	DHCACC_ReadMagCard();
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
		//var obj=document.getElementById("ReadAccEncrypt");
		//if (obj){var encmeth=obj.value;}
		///var encmeth=DHCWebD_GetObjValue("ReadAccEncrypt");
		//if (encmeth==""){rtn=-299;}
		if ((rtn==0)){
			//var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo)
			var myrtn=MyRunClassMethod("web.UDHCAccManageCLS","getaccinfofromcardno",{"cardno":myCardNo,"securityno":myCheckNo});
			var myary=myrtn.split("^");
			rtn=myary[0];
			if (rtn==0){
				var myAccRowID=myary[1];
				var myLeftM=myary[3];
				var myAccPWD=myary[6];
				////myExpstr=PWDCount^^^^myCheckNo
				var myExpstr="0^^^^"+myCheckNo
				var myFactLeftM=myary[4];
				
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

function DHCACC_CheckMCFPay2(PatSum,CardNo,AdmStr, CardTypeDR)
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
	
	alert('Çë²å¿¨!');
	//DHCACC_ReadMagCard(CardTypeDR);
	var myrtn=DHCACC_ReadMagCard(m_CCMRowID);
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
		//var obj=document.getElementById("ReadAccExpEncrypt");
		//if (obj){var encmeth=obj.value;}
		///var encmeth=DHCWebD_GetObjValue("ReadAccExpEncrypt");
		//if (encmeth==""){rtn=-299;}
		if ((rtn==0)){
			var myExpStr=AdmStr+String.fromCharCode(2)+CardTypeDR;
			//var myrtn=cspRunServerMethod(encmeth,myCardNo, myCheckNo, myExpStr);
			var myrtn = MyRunClassMethod("web.UDHCAccManageCLSIF","getaccinfofromcardno",{"cardno":myCardNo,"securityno":myCheckNo,"ExpStr":myExpStr});
			//alert(myrtn)
			var myary=myrtn.split("^");
			rtn=myary[0];
			if (rtn==0){
				var myAccRowID=myary[1];
				var myLeftM=myary[3];
				var myAccPWD=myary[6];
				////myExpstr=PWDCount^^^^myCheckNo
				var myExpstr="0^^^^"+myCheckNo
				var myFactLeftM=myary[5];
				if (myAccPWD=="670B14728AD9902AECBA32E22FA4F6BD")
				{
					//rtn=-208
					}
			else{
				var obj=document.getElementById("ClsPWD");
				if (obj){
					var rtn=obj.CheckPWD(myAccPWD, myExpstr);	////Read 2 and 3
				}
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

function DHCACC_CheckMCFPayByHand(PatSum,CardNo,AdmStr, CardTypeDR, SecurityNo)
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
	
	var encmeth="";
	
	var myCardNo=CardNo;
	var myCheckNo=SecurityNo;
	if (myCardNo!=CardNo){
		rtn=-206;
	}
		
		///Get DHC_AccManager PWD
		///##class(web.UDHCAccManageCLS).getaccinfofromcardno(cardno, securityno)
		///ReadAccEncrypt
		//var obj=document.getElementById("ReadAccExpEncrypt");
		//if (obj){var encmeth=obj.value;}
		///var encmeth=DHCWebD_GetObjValue("ReadAccExpEncrypt");
		//if (encmeth==""){rtn=-299;}
		if ((rtn==0)){
		
			var myExpStr=AdmStr+String.fromCharCode(2)+CardTypeDR;
			//var myrtn=cspRunServerMethod(encmeth,myCardNo, myCheckNo, myExpStr);
			var myrtn = MyRunClassMethod("web.UDHCAccManageCLSIF","getaccinfofromcardno",{"cardno":myCardNo,"securityno":myCheckNo,"ExpStr":myExpStr});
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
		//var obj=document.getElementById("ReadAccExpEncrypt");
		//if (obj){var encmeth=obj.value;}
		///var encmeth=DHCWebD_GetObjValue("ReadAccEncrypt");
		//if (encmeth==""){rtn=-299;}
		if ((rtn==0)){
			//var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo,ExpStr);
			var myrtn = MyRunClassMethod("web.UDHCAccManageCLSIF","getaccinfofromcardno",{"cardno":myCardNo,"securityno":myCheckNo,"ExpStr":myExpStr});
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
	var myrtn=DHCHardComm_PWDKeyPressEquip(myVPWD);
	return myrtn;
}

function DHCACC_GetValidatePWDOld(myVPWD)
{
	DHCHardComm_PWDKeyPressEquip();
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
	//var obj=document.getElementById("ReadAccEncrypt");
	//if (obj){var encmeth=obj.value;}
	///var encmeth=DHCWebD_GetObjValue("ReadAccEncrypt");
	//if (encmeth==""){rtn=-299;}
	if ((rtn==0)){
		//var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo)
		var myrtn=MyRunClassMethod("web.UDHCAccManageCLS","getaccinfofromcardno",{"cardno":myCardNo,"securityno":myCheckNo});
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

function DHCACC_CheckCardNoForDeposit(CardNo, CardTypeDR){
	var myrtn=true;
	
	var myCardInfo =DHCACC_ReadMagCard(CardTypeDR);
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

function DHCACC_WrtMagCard2Old(WType,mystr2,mystr3)
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

*/
function MyRunClassMethod(ClassName,MethodName,Datas){
   Datas=Datas||{};
   var RtnStr = "";
   runClassMethod(ClassName,MethodName,
   Datas,
   function (data){
	  	RtnStr=data;
	  },
	"text",false
	);
	return RtnStr;
}
