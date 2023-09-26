/// DHCWeb.OPCommonManageCard.js

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

var m_CCMRowID = "";
var m_ReadCardMode = "";
var m_IsCardNoCheck = "";
var m_Hospital_DR = session['LOGON.HOSPID'];

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
	switch (myCount){
		case 0:
			myrtn = DHCACC_ReadMagCard1();
			break;
		case 1:
			myrtn = DHCACC_ReadMagCard2(arguments[0],"","","")
			break;
        case 3:
			myrtn = DHCACC_ReadMagCard3(arguments[0],arguments[1],arguments[2],"")
			break;			
		default:
			
			break;
	}
	//ȥ����ֹ�ַ�
	myrtn=myrtn.replace(String.fromCharCode(0),"");
	return myrtn;
}

function DHCACC_ReadMagCard1(){
	///Return Card No and PAADM
	var myCardNo="";
	var myCheckNo="";
	var rtn=-1;
	//alert("aaa");
	var obj=document.getElementById("ClsHFCard");
	//alert("bbb");
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

function DHCACC_ReadMagCard2(HardType, InPara1, InPara2, InPara3){
	///Return Card No and PAADM
	var myCardNo="";
	var myCheckNo="";
	var rtn=-1;
	//var rtn=DHCHardComm_RandomCardEquip(HardType,"R", InPara1, InPara2, InPara3)
	var rtn=DHCHardComm_RandomCardEquip(HardType,"R", "23", "", "");
	var myary=rtn.split("^");
	rtn=myary[0];
		
	if (myary[0]=="0"){
		rtn=0;
		myCardNo=myary[1];
		myCheckNo=myary[2];
		//HardType ���豸����
		var tmprtn=DHCACC_DisabledCardType("CardType",myCardNo,"");
		if (tmprtn!=true) {
			rtn=tmprtn;
		}
		var tmprtn=DHCACC_DisabledCardType("CardTypeDefine",myCardNo,"");
		if (tmprtn!=true) {
			rtn=tmprtn;
		}
	}
	return rtn+"^"+myCardNo+"^"+myCheckNo;
}

function DHCACC_ReadMagCard3(HardType, InPara1, InPara2, InPara3){
	///Return Card No and PAADM
	var myCardNo="";
	var myCheckNo="";
	var rtn=-1;

	//var rtn=DHCHardComm_RandomCardEquip(HardType,"R", InPara1, InPara2, InPara3)
	var rtn=DHCHardComm_RandomCardEquip(HardType,InPara1, InPara2, "", "");

	var myary=rtn.split("^");
	rtn=myary[0];
		
	if (myary[0]=="0"){
		rtn=0;
		myCardNo=myary[1];
		myCheckNo=myary[2];
	}
	return rtn+"^"+myCardNo+"^"+myCheckNo;
}
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
    
	try {
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
				//alert("123:"+myCardTypeDR);
				//alert("234:"+myEquipDR);
				myrtn = DHCACC_GetAccInfo5(myCardTypeDR, myEquipDR);
				//alert("456:"+myrtn);
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
			case 5: //HISUI�汾 ��ȡ����Ӧ��Ϣ
				var myCardTypeDR=arguments[0];
				var myCardNo=arguments[1];
				var mySecurityNo=arguments[2];
				var myCheckSecrityFlag=arguments[3];
				var callBackFun=arguments[4];
				myrtn = DHCACC_GetAccInfo6(myCardTypeDR, myCardNo, mySecurityNo, myCheckSecrityFlag,callBackFun);
				break;
			default:
				break;
		}
	}catch(e){
		myrtn="-200";
	}
	return myrtn;
}

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
	return rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo+"^"+myAccType+"^"+myAccRowID+"^"+myGetCardTypeDR+"^"+mySCTTip;
}

function DHCACC_GetAccInfo5(CardTypeDR, EquipDR)
{
	////Read Patient Active Account Info for Show
	////(HardType, InPara1, InPara2, InPara3)
	///DHCACC_ReadMagCard(m_CCMRowID, "R", "23","","");
	var myrtn =DHCACC_ReadMagCard(EquipDR);
	var rtn=0;
	var myLeftM=0;
	var myAccRowID="";
	var myPAPMI="";
	var myPAPMNo=""
	var myCardNo="";
	var myCheckNo="";
	var myGetCardTypeDR="";
	var mySCTTip="";
	var myHospitalDR="";
	var myary=myrtn.split("^");
	var encmeth="";
	if (myary[0]==0){
		rtn=myary[0];
		myCardNo=myary[1];
		myCheckNo=myary[2];
		//alert(myary);
		
		var myHospitalDR=DHCACC_GetHospitalDR();
		
		var obj=document.getElementById("ReadAccExpEncrypt");
		if (obj){var encmeth=obj.value;}
		///var encmeth=DHCWebD_GetObjValue("ReadAccExpEncrypt");
		if (encmeth!=""){
			///
			var myExpStr=""+String.fromCharCode(2)+CardTypeDR;
			myExpStr += String.fromCharCode(2) + "";
			myExpStr += String.fromCharCode(2) + myHospitalDR;
			var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo, myExpStr);
			//alert("myrtn:"+myrtn)
			var myary=myrtn.split("^");
			rtn=myary[0];
			var myAccRowID=myary[1];
			var myLeftM=myary[3];
			var myPAPMI=myary[7];
			var myPAPMNo=myary[8];
			var myAccType=myary[10];
			var myAccGrpLeftM=myary[17]  //�����˻����  yyx 2010-07-07
			if (myary.length>12){
				myGetCardTypeDR=myary[12];
			}
			if (myary.length>13){
				mySCTTip = myary[13];
			}
		}
	}else{
		rtn=myary[0];
	}
	return rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo+"^"+myAccType+"^"+myAccRowID+"^"+myGetCardTypeDR+"^"+mySCTTip+"^"+myAccGrpLeftM;
}

function DHCACC_GetAccInfo2(CardTypeDR)
{
	////Read Patient Active Account Info for Show
	////(HardType, InPara1, InPara2, InPara3)
	///DHCACC_ReadMagCard(m_CCMRowID, "R", "23","","");
	
	var myrtn =DHCACC_ReadMagCard(m_CCMRowID);
	var rtn=0;
	var myLeftM=0;
	var myAccRowID="";
	var myPAPMI="";
	var myPAPMNo=""
	var myCardNo="";
	var myCheckNo="";
	var myGetCardTypeDR="";
	var myHospitalDR="";
	var mySCTTip="";
	
	var myary=myrtn.split("^");
	var encmeth="";
	if (myary[0]==0){
		rtn=myary[0];
		myCardNo=myary[1];
		myCheckNo=myary[2];
		
		var myHospitalDR=DHCACC_GetHospitalDR();
		var obj=document.getElementById("ReadAccExpEncrypt");
		if (obj){var encmeth=obj.value;}
		///var encmeth=DHCWebD_GetObjValue("ReadAccExpEncrypt");
		if (encmeth!=""){
			///
			var myExpStr=""+String.fromCharCode(2)+CardTypeDR;
			myExpStr += String.fromCharCode(2) + "";
			myExpStr += String.fromCharCode(2) + myHospitalDR;
			var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo, myExpStr)
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
		}
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
	var myHospitalDR="";
	var mySCTTip="";
	
	myCardNo=CardNo;
	myCheckNo=SecurityNo;
	var myCardTypeDR = CardTypeDR;
	
	var myHospitalDR=DHCACC_GetHospitalDR();
	
	var obj=document.getElementById("ReadAccExpEncrypt");
	if (obj){var encmeth=obj.value;}
	///var encmeth=DHCWebD_GetObjValue("ReadAccExpEncrypt");
	if (encmeth!=""){
		var myExpStr=""+String.fromCharCode(2)+CardTypeDR;
		myExpStr += String.fromCharCode(2) + "";
		myExpStr += String.fromCharCode(2) + myHospitalDR;
		var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo, myExpStr);
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
	}
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
	var myHospitalDR="";
	var mySCTTip="";
	
	myCardNo=CardNo;
	myCheckNo=SecurityNo;
	var myCardTypeDR = CardTypeDR;
	
	var myHospitalDR=DHCACC_GetHospitalDR();
	
	var obj=document.getElementById("ReadAccExpEncrypt");
	if (obj){var encmeth=obj.value;}
	///var encmeth=DHCWebD_GetObjValue("ReadAccExpEncrypt");
	if (encmeth!=""){
		var myExpStr=""+String.fromCharCode(2)+CardTypeDR;
		myExpStr += String.fromCharCode(2) + CheckSecurityFlag;
		myExpStr += String.fromCharCode(2) + myHospitalDR;
		var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo, myExpStr);
		//alert(myrtn);
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
	var obj=document.getElementById("ReadAccEncrypt");
	if (obj){var encmeth=obj.value;}
	///var encmeth=DHCWebD_GetObjValue("ReadAccEncrypt");
	if (encmeth==""){rtn=-299;}
	if ((rtn==0)){
		var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo)
		var myary=myrtn.split("^");
		rtn=myary[0];
		//alert(myary[0])
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
	alert("��ſ�!");
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
	var myHospitalDR="";
	//var myrtn="0"+"^"+CardNo+"^"+"";  //DHCACC_ReadMagCard(23);     //modify by zhn 20141125
	//alert('��忨!');
	
	DHCACC_GetCardTypeInfo(CardTypeDR);
	if((m_ReadCardMode == "Handle") || (m_CCMRowID == "")) {
		if(m_IsCardNoCheck == "Y") {
			var myrtn = DHCACC_HandleMagCard();
		}else{
			var tmpCardNo = CardNo;
			var tmpCheckNo = "";
			var myrtn = 0 + "^" + tmpCardNo + "^" + tmpCheckNo;	
		}
	}else{
		var myrtn = DHCACC_ReadMagCard(m_CCMRowID);	
	}
	var encmeth="";
	var myary=myrtn.split("^");
	if (myary[0]=="0"){
		var myCardNo=myary[1];
		var myCheckNo=myary[2];
		if (myCardNo!=CardNo){
			rtn=-206;
		}
		
		var myHospitalDR=DHCACC_GetHospitalDR();
		
		var obj=document.getElementById("ReadAccExpEncrypt");
		if (obj){var encmeth=obj.value;}
		if (encmeth==""){rtn=-299;}
		if ((rtn==0)){
			var myExpStr=AdmStr+String.fromCharCode(2)+CardTypeDR;
			myExpStr += String.fromCharCode(2) + "";
			myExpStr += String.fromCharCode(2) + myHospitalDR;
			var myrtn=cspRunServerMethod(encmeth,myCardNo, myCheckNo, myExpStr);
			//alert(myrtn)
			var myary=myrtn.split("^");
			rtn=myary[0];
			if (rtn==0){
				var myAccRowID=myary[1];
				var myLeftM=myary[3];			
				var myAccPWD=myary[6];
				//myExpstr=PWDCount^^^^myCheckNo
				var myExpstr="0^^^^"+myCheckNo
				var myFactLeftM=myary[5];
				if (myAccPWD=="670B14728AD9902AECBA32E22FA4F6BD") {
					//rtn=-208
				}else{
					var obj=document.getElementById("ClsPWD");
					if (obj){
						var rtn=obj.CheckPWD(myAccPWD, myExpstr);	//Read 2 and 3
					}
				}
				if (isNaN(PatSum)){PatSum=0;}
				if (isNaN(myLeftM)){myLeftM=0;}
				if (isNaN(myFactLeftM)){myFactLeftM=0;}
			
				if (+PatSum>(eval(+myLeftM))){
					myBalance=PatSum-myLeftM;
					rtn=-205;
				}
				//myFactLeftM=myFactLeftM-PatSum;
				//myFactLeftM=myFactLeftM.toFixed(2);
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
	var m_Hospital_DR="";
	
	var encmeth="";
	
	var myCardNo=CardNo;
	var myCheckNo=SecurityNo;
	if (myCardNo!=CardNo){
		rtn=-206;
	}
		
	var myHospitalDR=DHCACC_GetHospitalDR();
		
		var obj=document.getElementById("ReadAccExpEncrypt");
		if (obj){var encmeth=obj.value;}
		///var encmeth=DHCWebD_GetObjValue("ReadAccExpEncrypt");
		if (encmeth==""){rtn=-299;}
		if ((rtn==0)){
			var myExpStr=AdmStr+String.fromCharCode(2)+CardTypeDR;
			myExpStr += String.fromCharCode(2) + "";
			myExpStr += String.fromCharCode(2) + myHospitalDR;
			var myrtn=cspRunServerMethod(encmeth,myCardNo, myCheckNo, myExpStr);
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
		
		var myHospitalDR=DHCACC_GetHospitalDR();
		
		var obj=document.getElementById("ReadAccExpEncrypt");
		if (obj){var encmeth=obj.value;}
		///var encmeth=DHCWebD_GetObjValue("ReadAccEncrypt");
		if (encmeth==""){rtn=-299;}
		if ((rtn==0)){
			var myExpStr=AdmStr+String.fromCharCode(2)+"";
			myExpStr += String.fromCharCode(2) + "";
			myExpStr += String.fromCharCode(2) + myHospitalDR;
			var myrtn=cspRunServerMethod(encmeth,myCardNo,myCheckNo,myExpStr);
			var myary=myrtn.split("^");
			rtn=myary[0];
			if (rtn==0){
				var myAccRowID=myary[1];
				var myLeftM=myary[3];
			    var myLeftMOther=myary[3]   //yyx 2010-07-07
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
	
	return rtn+"^"+myAccRowID+"^"+myCheckNo+"^"+myAccPWD+"^"+myBalance+"^"+myFactLeftM;
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

function DHCACC_CheckCardNoForDeposit(CardNo,CardTypeDR){
	var myrtn=true;
	//var myCardTypeData=tkMakeServerCall("web.UDHCJFBaseCommon","GetCardTypeDefineData",CardTypeDR);
	//var tmpAry=myCardTypeData.split("^");
	//var HardComDR=tmpAry[14];
	//var ReadCardMode=tmpAry[16];
	
	DHCACC_GetCardTypeInfo(CardTypeDR);
	
	if((m_ReadCardMode=="Handle")||(m_CCMRowID=="")){
		if(m_IsCardNoCheck=="Y"){
			var myCardInfo =DHCACC_HandleMagCard();
		}else{
			return true;	//ˢ����ʽ������Ҫ�ٴ�У��
		}
	}else{
		var myCardInfo =DHCACC_ReadMagCard(m_CCMRowID);
	}
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

//add by guorongyong ��������ģʽ�Զ�����ҳ�濨����
function DHCACC_DisabledCardType(ElementName,CardNo,CardTypeRowId){
	var rtn=true;
	/*if (typeof CardTypeRowId=="undefined"){
		CardTypeRowId="";
	}
	var obj=document.getElementById(ElementName);
	if (obj) {
		rtn=DHCACC_ChangeCardTypeByCardNo(CardNo,obj,CardTypeRowId);
	}*/
	return rtn;
}
/*ͨ������ˢ�¿�����
׼��������һ������item(����"getcardtypeclassbycardno")������valuegetֵΪs val=##Class(%CSP.Page).Encrypt($lb("web.DHCBL.CARD.CardManager.getcardtypeinfoByCardNo"))
���ø�ʽ���ڿ��Żس��¼������ChangeCardTypeByCardNo(����item���������������ؼ���������item��)
���磺ChangeCardTypeByCardNo('CardNo',combo_CardTypeDefine,'getcardtypeclassbycardno');
*///����2007-12-11
function DHCACC_ChangeCardTypeByCardNo(CardNo,cardTypeObj,CardTypeRowId){
	if (!cardTypeObj) return true;
	if (CardNo=="")  return true;
	if (typeof CardTypeRowId=="undefined"){
		CardTypeRowId="";
	}
	var retValue=tkMakeServerCall("web.DHCBL.CARD.CardManager","getcardtypeinfoByCardNoNew",CardNo,CardTypeRowId);
	//alert(retValue+","+CardNo)
	if (retValue==""){
		return true;
	}else if(retValue=="-1"){
		$.messager.alert("��ʾ","�����ڶ��ֿ��������ظ�,��ѡ������!");
		return retValue;
	}else if (retValue=="-2"){
		$.messager.alert("��ʾ","û���ҵ����õĿ���¼!");
		return retValue;
	}
	
	var myary=retValue.split("^");
	if (cardTypeObj.className=="dhx_combo_input") {
		if (typeof combo_CardType!="undefined"){
			combo_CardType.setComboText(myary[2]);
		}else{
			/*if (typeof myCombAry["CardTypeDefine"]!="undefined"){
				myCombAry["CardTypeDefine"].setComboText(myary[2]);
			}else{
				cardTypeObj.setComboText(myary[2]);
			}*/
		}
	}else{
		for (var i=0;i<cardTypeObj.length;i++) {
			if ((cardTypeObj.options[i].text)==myary[2]){cardTypeObj.options[i].selected=true;}
		}
	}
	cardTypeObj.disabled=true;
	return true
}


function DHCACC_CheckMCFPay3(PatSum,PatientID){
	var rtn=0;
	var myAccRowID="";
	var myCheckNo="";
	var myAccPWD="";
	var myBalance=0;
	var myFactLeftM=0;
	var myHospitalDR="";
	
	//alert('��忨!');
	//DHCACC_ReadMagCard(CardTypeDR);
	var myrtn=DHCACC_ReadMagCard(m_CCMRowID);
	var encmeth="";
	var myary=myrtn.split("^");
	if (myary[0]=="0"){
		var myCardNo=myary[1];
		var myCheckNo=myary[2];
		
		var myHospitalDR=DHCACC_GetHospitalDR();
		
		var obj=document.getElementById("ReadAccExpEncrypt");
		if (obj){var encmeth=obj.value;}
		///var encmeth=DHCWebD_GetObjValue("ReadAccExpEncrypt");
		if (encmeth==""){rtn=-299;}
		if ((rtn==0)){
			var myExpStr=AdmStr+String.fromCharCode(2)+CardTypeDR;
			myExpStr += String.fromCharCode(2) + "";
			myExpStr += String.fromCharCode(2) + myHospitalDR;
			var myrtn=cspRunServerMethod(encmeth,myCardNo, myCheckNo, myExpStr);
			//alert(myrtn)
			var myary=myrtn.split("^");
			rtn=myary[0];
			if (rtn==0){
				var myAccRowID=myary[1];
				var myLeftM=myary[3];			
				var myAccPWD=myary[6];
				var myPapmi=myary[7];
				if(myPapmi!=PatientID){
					rtn=-207	//��ͬһ������
					return rtn+"^"+myAccRowID+"^"+myCheckNo+"^"+myAccPWD+"^"+myBalance+"^"+myFactLeftM;
				}
				////myExpstr=PWDCount^^^^myCheckNo
				var myExpstr="0^^^^"+myCheckNo
				var myFactLeftM=myary[5];
				if (myAccPWD=="670B14728AD9902AECBA32E22FA4F6BD")
				{
					//rtn=-208
				}else{
					var obj=document.getElementById("ClsPWD");
					if (obj){
						var rtn=obj.CheckPWD(myAccPWD, myExpstr);	////Read 2 and 3
					}
				}
				if (isNaN(PatSum)){PatSum=0;}
				if (isNaN(myLeftM)){myLeftM=0;}
				if (isNaN(myFactLeftM)){myFactLeftM=0;}
			
				if (+PatSum>(eval(+myLeftM))){
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
function DHCACC_CheckMCFPay4(PatSum,PatientID,AdmStr, CardTypeDR)
{
	var rtn=0;
	var myAccRowID="";
	var myCheckNo="";
	var myAccPWD="";
	var myBalance=0;
	var myFactLeftM=0;
	var myHospitalDR="";
	
	DHCACC_GetCardTypeInfo(CardTypeDR);
	
	if(m_ReadCardMode=="Handle"){
		if(m_IsCardNoCheck=="Y"){
			var myrtn=DHCACC_HandleMagCard();
		}else{
			//�˺���û�����û�п��ţ��˴���ʱ������	
		}
	}else{
		var myrtn=DHCACC_ReadMagCard(m_CCMRowID);
	}
	
	var encmeth="";
	var myary=myrtn.split("^");
	if (myary[0]=="0"){
		var myCardNo=myary[1];
		var myCheckNo=myary[2];
		
		var myHospitalDR=DHCACC_GetHospitalDR();
		
		var obj=document.getElementById("ReadAccExpEncrypt");
		if (obj){var encmeth=obj.value;}
		///var encmeth=DHCWebD_GetObjValue("ReadAccExpEncrypt");
		if (encmeth==""){rtn=-299;}
		if ((rtn==0)){
			var myExpStr=AdmStr+String.fromCharCode(2)+CardTypeDR;
			myExpStr += String.fromCharCode(2) + "";
			myExpStr += String.fromCharCode(2) + myHospitalDR;
			var myrtn=cspRunServerMethod(encmeth,myCardNo, myCheckNo, myExpStr);
			var myary=myrtn.split("^");
			rtn=myary[0];
			if (rtn==0){
				var myAccRowID=myary[1];
				var myLeftM=myary[3];			
				var myAccPWD=myary[6];
				var myPapmi=myary[7];
				if(myPapmi!=PatientID){
					rtn=-207	//��ͬһ������
					return rtn+"^"+myAccRowID+"^"+myCheckNo+"^"+myAccPWD+"^"+myBalance+"^"+myFactLeftM;
				}
				////myExpstr=PWDCount^^^^myCheckNo
				var myExpstr="0^^^^"+myCheckNo
				var myFactLeftM=myary[5];
				if (myAccPWD=="670B14728AD9902AECBA32E22FA4F6BD")
				{
					//rtn=-208
				}else{
					var obj=document.getElementById("ClsPWD");
					if (obj){
						var rtn=obj.CheckPWD(myAccPWD, myExpstr);	////Read 2 and 3
					}
				}
				if (isNaN(PatSum)){PatSum=0;}
				if (isNaN(myLeftM)){myLeftM=0;}
				if (isNaN(myFactLeftM)){myFactLeftM=0;}
			
				if (+PatSum>(eval(+myLeftM))){
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
	//alert(rtn+"^"+myAccRowID+"^"+myCheckNo+"^"+myAccPWD+"^"+myBalance+"^"+myFactLeftM);
	return rtn+"^"+myAccRowID+"^"+myCheckNo+"^"+myAccPWD+"^"+myBalance+"^"+myFactLeftM
}
///Lid
///2016-06-29
///ȡǰ��Ժ��ָ��.
///		��Ӧ�ĵ��������Ҫ�ӡ�HospitalDR��Ԫ��,���Բο����˻�������ѯ(UDHCACPatQ.AccPListQuery)������ġ�HospitalDR��Ԫ�ء�
///		��������û�У�Ĭ��ȡsession��Ժ��.
function DHCACC_GetHospitalDR(){
	m_Hospital_DR=session['LOGON.HOSPID'];
	var myHospitalDR="";
	var obj=document.getElementById("HospitalDR");
	if(obj){
		myHospitalDR=obj.value;
	}else{
		myHospitalDR=m_Hospital_DR;	//Ĭ��ȡsession��Ժ��ָ��
	}
	return myHospitalDR;
}

///ˢ���뿨
function DHCACC_HandleMagCard() {
	var url = "dhcopbillcardverification.csp";
	var rtn = window.showModalDialog(url, "", 'dialogWidth:320px;dialogHeight:120px;center:yes');   //HTML��ʽ��ģ̬�Ի���
	if (!rtn) {
		rtn = "-210^^";
	}
	return rtn;
}

///��ȡ��������Ϣ
function DHCACC_GetCardTypeInfo(cardTypeDr) {
	var rtn = tkMakeServerCall("web.UDHCOPOtherLB","ReadCardTypeDefineListBroker1",cardTypeDr);
	//�ڴ�����һЩ�����͵�ȫ�ֱ���
	var myary = rtn.split("^");
	m_CCMRowID = myary[14];
	m_ReadCardMode = myary[16];	     //ȫ�ֱ��� -- ����ģʽ
	m_IsCardNoCheck = myary[37];	 //֧���Ƿ���ҪУ��(Y:��Ҫˢ����֤��N:����Ҫ)����ҪҪӵ�����뿨��֧������д�����Ժ��ڡ����������á������һ��������
	return rtn;
}

function DHCACC_GetAccInfo6(CardTypeDR, CardNo, SecurityNo, CheckSecurityFlag, callBackFun)
{
	var obj=document.getElementById("GetCardTypeEncrypt");
	if (obj){var encmeth=obj.value;}
	var list=cspRunServerMethod(encmeth, CardNo);
	list=eval('(' + list + ')'); 
	if ((!list)||(list.length==0)){
		var rtn="-200^^^^^^^^";
		var errMsg="û���ҵ���Ӧ�Ŀ���¼!";
		$('#CardNo').focus();
		eval('(' + callBackFun + ')')(rtn,errMsg);
		return false;
	}
	if(list.length==1){
		var SelectedCardType=list[0]["cardTypeId"];
		var SelectedCardNo=list[0]["checkdValue"];
		var SecurityNo=list[0]["SecurityNo"];
		$("#CardTypeNew").val(list[0]["cardDesc"]);
		var rtn=DHCACC_GetAccInfo4(SelectedCardType, SelectedCardNo, SecurityNo, CheckSecurityFlag);
		eval('(' + callBackFun + ')')(rtn);
		return rtn;
	}
	var id="CardTypeDialog";
	$("body").append("<div id='"+id+"' class='hisui-dialog'></div><span id='selCardTypeInfo'></span>");
	var tmplist="";
	for(var i=0,len=list.length;i<len;++i){
		var CardTypeId=list[i]["cardTypeId"];
		var cardDesc=list[i]["cardDesc"];
		var CardNo=list[i]["checkdValue"];
		var papmiNo=list[i]["papmiNo"];
		var SecurityNo=list[i]["SecurityNo"];
		if (tmplist=="") tmplist=CardTypeId+"^"+cardDesc+"^"+CardNo+"^"+papmiNo+"^"+SecurityNo;
		else  tmplist=tmplist+"!"+CardTypeId+"^"+cardDesc+"^"+CardNo+"^"+papmiNo+"^"+SecurityNo;
	}
	var src='opdoc.cardtypelist.csp?CardTypeList='+tmplist;
	$("#"+id).dialog({
		autoOpen : true,   // �Ƿ��Զ���������
		title: "��ѡ������",
        width: 400,
        height: 320,
        cache: false,
        iconCls: "icon-add-note",
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: true,
        closable: true,
        content:"<iframe id='CardTypeFrame' width='100%' height='98.7%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>",
	    onClose:function(){
		    var selCardInfo=$("#selCardTypeInfo").val();
		    if (selCardInfo==""){
			    return false;
			}
			var selCardInfoArr=selCardInfo.split("-"); //������id-����-������
		    var SelectedCardType=selCardInfoArr[0];
			var SelectedCardNo=selCardInfoArr[1];
			var SecurityNo=selCardInfoArr[3];
			$("#CardTypeNew").val(selCardInfoArr[2]);
			var rtn=DHCACC_GetAccInfo4(SelectedCardType, SelectedCardNo, SecurityNo, CheckSecurityFlag);
			eval('(' + callBackFun + ')')(rtn);
			return true;
		}
	});
	$("#"+id).dialog("open");
}
function CloseCardTypeListDialog(){
	$("#CardTypeDialog").dialog('close');
	$("body").remove("#CardTypeDialog"); //�Ƴ����ڵ�Dialog
	$("#CardTypeDialog").dialog('destroy');
}
function setSelCardType(selCardInfo){
	$("#selCardTypeInfo").val(selCardInfo);
}
//ѭ������
function DHCACC_GetAccInfo7(callBackFun){
	var obj=document.getElementById("ReadCardTypeEncrypt");
	if (obj){var encmeth=obj.value;}
	if (encmeth!=""){
		var myrtn=cspRunServerMethod(encmeth,"GetCardTypeToHUIJson","","");
		myrtn=eval('(' + myrtn + ')');
		for (var k=0;k<myrtn.length;k++){
			var myoptval=myrtn[k]["id"];
			var myEquipDR=myoptval.split("^")[14];
			if ((myoptval.split("^")[16]=="Handle")||(myEquipDR=="")) continue;
			var CardTypeRowId=myoptval.split("^")[0];
			var Infortn=DHCACC_GetAccInfo(CardTypeRowId,myoptval);
			var myary=Infortn.split("^");
			var rtn=myary[0];
			if ((rtn=="0")||(rtn=="-201")){
				$("#CardTypeNew").val(myoptval.split("^")[2]);
				eval('(' + callBackFun + ')')(Infortn);
				break;
			}else if(rtn=="-200"){
				//�Ѿ������ɹ�,���ǿ�����Ч��
				//$.messager.alert("��ʾ","����Ч!");
				eval('(' + callBackFun + ')')(Infortn);
				break;
			}else if(rtn=="-1"){
				//û�ſ�
				eval('(' + callBackFun + ')')(Infortn);
				break;
			}
		}
	}else{
		$.messager.alert("��ʾ","�����������Ԫ��ReadCardTypeEncrypt");
		return false;
	}
}