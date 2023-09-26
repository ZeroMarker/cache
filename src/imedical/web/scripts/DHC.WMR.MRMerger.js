
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);

var m_CardNoLength=0;
var m_SelectCardTypeDR="";

function loadCardType()
{
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=DHCWebD_GetObjValue("CardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
	}
}

function CardTypeDefineOnChange()
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
		var myobj=document.getElementById("FCardNo");
		if (myobj)
		{
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("FReadCard");
		
		var myobj=document.getElementById("TCardNo");
		if (myobj)
		{
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("TReadCard");
	}
	else
	{
		var myobj=document.getElementById("FCardNo");
		if (myobj)
		{
			myobj.readOnly = true;
		}
		var obj=document.getElementById("FReadCard");
		if (obj){
			obj.disabled=false;
			obj.onclick=FReadCard_Click;
		}
		
		var myobj=document.getElementById("TCardNo");
		if (myobj)
		{
			myobj.readOnly = true;
		}
		var obj=document.getElementById("TReadCard");
		if (obj){
			obj.disabled=false;
			obj.onclick=TReadCard_Click;
		}
	}
	
	//Set Focus
	if (myary[16]=="Handle"){
		DHCWeb_setfocus("FCardNo");
	}else{
		DHCWeb_setfocus("FReadCard");
	}
	
	m_CardNoLength=myary[17];
	
}

function SetCardNoLength(ItemName){
	var obj=document.getElementById(ItemName);
	if (obj.value!='') 
	{
		if ((obj.value.length<m_CardNoLength)&&(m_CardNoLength!=0)) 
		{
			for (var i=(m_CardNoLength-obj.value.length-1); i>=0; i--)
			{
				obj.value="0"+obj.value;
			}
		}
	}
}

function SetPatNoLength(ItemName)
{
	var obj=document.getElementById(ItemName);
	if (obj) {
		var PatNo=obj.value;
		if (PatNo!==""){
			var objM=document.getElementById('MethodRegNoCon');
		    if (objM) {var encmeth=objM.value} else {var encmeth=''}
		    var ret=cspRunServerMethod(encmeth,PatNo);
		    obj.value=ret;
		}
	}
}

function initForm()
{
	var obj=document.getElementById('MrType');
	if (obj){
		obj.size=1;
		obj.multiple=false;
		
		var tmpMrType=GetParam(window,"MrType");
		if (tmpMrType!==""){
			for (var i=0;i<obj.options.length;i++){
				if (obj.options[i].value==tmpMrType) {
					obj.options.selectedIndex=i;
				}
			}
		}else{
			if (obj.options.length>0) {
				obj.options.selectedIndex=0;
			}
		}
	}
	document.getElementById('MrType').disabled=true;
	loadCardType();
	var obj=document.getElementById('CardTypeDefine');
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.onchange=CardTypeDefineOnChange;
		CardTypeDefineOnChange();
	}
	
	var obj=document.getElementById('FCardNo');
	if (obj){
		obj.onkeydown=FCardNoOnKeyDown;
	}
	
	var obj=document.getElementById('TCardNo');
	if (obj){
		obj.onkeydown=TCardNoOnKeyDown;
	}
	
	var obj=document.getElementById('FPatNo');
	if (obj){
		obj.onkeydown=FPatNoOnKeyDown;
	}
	
	var obj=document.getElementById('TPatNo');
	if (obj){
		obj.onkeydown=TPatNoOnKeyDown;
	}
	
	var obj=document.getElementById('FMrNo');
	if (obj){
		obj.onkeydown=FMrNoOnKeyDown;
	}
	
	var obj=document.getElementById('TMrNo');
	if (obj){
		obj.onkeydown=TMrNoOnKeyDown;
	}
	
	var obj=document.getElementById('cmdMRMerger');
	if (obj){
		obj.onclick=cmdMRMerger_Click;
	}
	
	var obj=document.getElementById('cmdMRChange');
	if (obj){
		obj.onclick=cmdMRChange_Click;
	}
	
	var obj=document.getElementById('FReadCard');
	if (obj){
		obj.onkeydown=FReadCard_Click;
	}
	
	var obj=document.getElementById('TReadCard');
	if (obj){
		obj.onkeydown=TReadCard_Click;
	}
	
	var obj=document.getElementById('cmdMRNoUpdate');
	if (obj){
		obj.onclick=cmdMRNoUpdate_Click;
	}
}

//add by zf 2008-05-29
function DisplayPromptInfo(xDisInfo)
{
	var OldNo=getElementValue("FMrNo",null);
	var FPatNo=getElementValue("FPatNo",null);
	var FPatName=getElementValue("FName",null);
	var NewNo=getElementValue("TMrNo",null);
	var TPatNo=getElementValue("TPatNo",null);
	var TPatName=getElementValue("TName",null);
	
	xDisInfo=xDisInfo.replace(/OldNo/gi,OldNo);
	xDisInfo=xDisInfo.replace(/FPatNo/gi,FPatNo);
	xDisInfo=xDisInfo.replace(/FPatName/gi,FPatName);
	xDisInfo=xDisInfo.replace(/NewNo/gi,NewNo);
	xDisInfo=xDisInfo.replace(/TPatNo/gi,TPatNo);
	xDisInfo=xDisInfo.replace(/TPatName/gi,TPatName);
	if(!confirm(xDisInfo)) {
		return false;
	}else{
		return true;
	}
}

function cmdMRNoUpdate_Click()
{
	var MrType=getElementValue("MrType",null);
	var OldNo=getElementValue("FMrNo",null);
	var NewNo=getElementValue("TMrNo",null);
	var Ctloc=session['LOGON.CTLOCID'];
	var UserId=session['LOGON.USERID'];
	if ((MrType=="")||(!MrType)) return;
	if ((OldNo=="")||(!OldNo)) return;
	if ((NewNo=="")||(!NewNo)) return;
	if ((Ctloc=="")||(!Ctloc)) return;
	if ((UserId=="")||(!UserId)) return;
	
	
	var xDisInfo=t["MRNoUpdate"];
	if (!DisplayPromptInfo(xDisInfo)) return false;
	
	var obj=document.getElementById('MethodMRNoUpdate');
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var ret=-100;
    ret=cspRunServerMethod(encmeth,MrType,OldNo,NewNo,UserId,Ctloc);
    if (ret<0){
		alert(t["MRNoUpdateFalse"]+ret);
		return;
	}else{
		alert(t["MRNoUpdateTrue"]);
	}
	
	var MrType=getElementValue("MrType",null);
	var MrNo=getElementValue("FMrNo",null);
	DisplayFMRInfo(MrType,MrNo,"","");
	var MrNo=getElementValue("TMrNo",null);
	DisplayTMRInfo(MrType,MrNo,"","");
}

function cmdMRMerger_Click()
{
	var UserId=session['LOGON.USERID'];
	var FMainId=getElementValue("FMainId",null);
	var TMainId=getElementValue("TMainId",null);
	var FPapmi=getElementValue("FPapmi",null);
	var TPapmi=getElementValue("TPapmi",null);
	var TName=getElementValue("TName",null);
	var NameSpell=GetPinYin(TName);
	if ((FMainId!=="")&&(TMainId!=="")&&((FMainId==TMainId))) return;
	if ((FPapmi!=="")&&(TPapmi!=="")&&(FPapmi==TPapmi)) return;
	if ((FMainId=="")||(TMainId=="")) return;
	
	var xDisInfo=t["MRMerger"];
	if (!DisplayPromptInfo(xDisInfo)) return false;
	
	var obj=document.getElementById('MethodMRMerger');
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var ret=-100;
    ret=cspRunServerMethod(encmeth,FMainId,TMainId,UserId,NameSpell);
    if (ret<0){
		alert(t["MRMergerFalse"]+ret);
		return;
	}else{
		alert(t["MRMergerTrue"]);
	}
	
	var MrType=getElementValue("MrType",null);
	var FPatNo=getElementValue("FPatNo",null);
	DisplayFMRInfo(MrType,"",FPatNo,"");
	
	var TPatNo=getElementValue("TPatNo",null);
	DisplayTMRInfo(MrType,"",TPatNo,"");
}

function cmdMRChange_Click()
{
	var FMainId=getElementValue("FMainId",null);
	var TMainId=getElementValue("TMainId",null);
	var FPapmi=getElementValue("FPapmi",null);
	var TPapmi=getElementValue("TPapmi",null);
	var TName=getElementValue("TName",null);
	var NameSpell=GetPinYin(TName);
	var UserId=session['LOGON.USERID'];
	if ((FMainId!=="")&&(TMainId!=="")&&((FMainId==TMainId))) return;
	if ((FPapmi!=="")&&(TPapmi!=="")&&(FPapmi==TPapmi)) return;
	if (TMainId!=="") return;
	if ((FMainId=="")||(TPapmi=="")) return;
	if ((UserId=="")||(!UserId)) return;
	
	var xDisInfo=t["MRChange"];
	if (!DisplayPromptInfo(xDisInfo)) return false;
	
	var obj=document.getElementById('MethodMRChange');
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var ret=-100;
    ret=cspRunServerMethod(encmeth,FMainId,TPapmi,NameSpell,UserId);
    if (ret<0){
		alert(t["MRChangeFalse"]+ret);
		return;
	}else{
		alert(t["MRChangeTrue"]);
	}
	var MrType=getElementValue("MrType",null);
	var FPatNo=getElementValue("FPatNo",null);
	DisplayFMRInfo(MrType,"",FPatNo,"");
	
	var TPatNo=getElementValue("TPatNo",null);
	DisplayTMRInfo(MrType,"",TPatNo,"");
}


function FReadCard_Click()
{
	setElementValue("CardNo","",null);
	var myEquipDR=DHCWeb_GetListBoxValue("CardTypeDefine");
    var CardInform=DHCACC_GetAccInfo(m_SelectCardTypeDR,myEquipDR)
    var CardSubInform=CardInform.split("^");
    var rtn=CardSubInform[0];
    switch (rtn){
		case "-200":                    //Card Invalid
			alert(t["CardInvalid"]);
			break;
		default:                        //rtn is 0 or -201
			var CardNo=CardSubInform[1];
			var PatNo=CardSubInform[5];
			setElementValue("CardNo",CardNo,null);
			break;
	}
	var CardNo=getElementValue("CardNo",null);
	setElementValue("FCardNo",CardNo,null);
	SetCardNoLength("FCardNo");
	CardNo=getElementValue("FCardNo",null);
	var MrType=getElementValue("MrType",null);
	DisplayFMRInfo(MrType,"","",CardNo);
}


function TReadCard_Click()
{
	setElementValue("CardNo","",null);
	var myEquipDR=DHCWeb_GetListBoxValue("CardTypeDefine");
    var CardInform=DHCACC_GetAccInfo(m_SelectCardTypeDR,myEquipDR)
    var CardSubInform=CardInform.split("^");
    var rtn=CardSubInform[0];
    switch (rtn){
		case "-200":                    //Card Invalid
			alert(t["CardInvalid"]);
			break;
		default:                        //rtn is 0 or -201
			var CardNo=CardSubInform[1];
			var PatNo=CardSubInform[5];
			setElementValue("CardNo",CardNo,null);
			break;
	}
	var CardNo=getElementValue("CardNo",null);
	setElementValue("TCardNo",CardNo,null);
	SetCardNoLength("TCardNo");
	CardNo=getElementValue("TCardNo",null);
	var MrType=getElementValue("MrType",null);
	DisplayTMRInfo(MrType,"","",CardNo);
	document.getElementById("TCardNo").focus();
}

function FMrNoOnKeyDown()
{
	if(window.event.keyCode != 13)
		return;
	var MrNo=getElementValue("FMrNo",null);
	var MrType=getElementValue("MrType",null);
	DisplayFMRInfo(MrType,MrNo,"","");
	document.getElementById("FPatNo").focus();
}


function TMrNoOnKeyDown()
{
	if(window.event.keyCode != 13)
		return;
	var MrNo=getElementValue("TMrNo",null);
	var MrType=getElementValue("MrType",null);
	DisplayTMRInfo(MrType,MrNo,"","");
	document.getElementById("TPatNo").focus();
}

function FPatNoOnKeyDown()
{
	if(window.event.keyCode != 13)
		return;
	SetPatNoLength("FPatNo");
	var PatNo=getElementValue("FPatNo",null);
	var MrType=getElementValue("MrType",null);
	DisplayFMRInfo(MrType,"",PatNo,"");
	document.getElementById("FPatNo").focus();
}


function TPatNoOnKeyDown()
{
	if(window.event.keyCode != 13)
		return;
	SetPatNoLength("TPatNo");
	var PatNo=getElementValue("TPatNo",null);
	var MrType=getElementValue("MrType",null);
	DisplayTMRInfo(MrType,"",PatNo,"");
	document.getElementById("TPatNo").focus();
}

function FCardNoOnKeyDown()
{
	if(window.event.keyCode != 13)
		return;
	SetCardNoLength("FCardNo");
	var CardNo=getElementValue("FCardNo",null);
	var MrType=getElementValue("MrType",null);
	DisplayFMRInfo(MrType,"","",CardNo);
	document.getElementById("FCardNo").focus();
}

function TCardNoOnKeyDown()
{
	if(window.event.keyCode != 13)
		return;
	SetCardNoLength("TCardNo");
	var CardNo=getElementValue("TCardNo",null);
	var MrType=getElementValue("MrType",null);
	DisplayTMRInfo(MrType,"","",CardNo);
	document.getElementById("TCardNo").focus();
}

function DisplayFMRInfo(MrType,MrNo,PatNo,CardNo)
{
	ClearFMRInfo();
	ClearTMRInfo();
	setElementValue("FCardNo",CardNo);
	setElementValue("FPatNo",PatNo);
	setElementValue("FMrNo",MrNo);
	if ((!MrType)&&(!MrNo)&&(!PatNo)&&(!CardNo)) return;
	
	var obj=document.getElementById('MethodGetMRInfo');
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var ret=cspRunServerMethod(encmeth,MrType,MrNo,PatNo,CardNo);
    if (ret){
    	var xList=ret.split(CHR_1);
    	var xSubList0,xSubList1;
    	if (xList[0]){xSubList0=xList[0].split("^");}
    	if (xList[1]){xSubList1=xList[1].split("^");}
    	//Patient Info
    	if (xSubList0){
			setElementValue("FPatNo",xSubList0[26]);
			setElementValue("FName",xSubList0[1]);
			setElementValue("FSex",xSubList0[3]);
			setElementValue("FBirthday",xSubList0[4]);
			setElementValue("FIdentityCode",xSubList0[12]);
			setElementValue("FCompany",xSubList0[13]);
			setElementValue("FHomeAddress",xSubList0[16]);
			setElementValue("FPapmi",xSubList0[25]);
    	}
    	
    	//MR Main Info
    	if (xSubList1){
			setElementValue("FMainId",xSubList1[0]);
			setElementValue("FMrNo",xSubList1[2]);
			
			//MR Volume Info
			var obj=document.getElementById('MethodGetMRVolume');
			if (obj) {var encmeth=obj.value} else {var encmeth=''}
			var ret=cspRunServerMethod(encmeth,xSubList1[0]);
			var yList=ret.split(CHR_1);
			var ySubList;
			for (var i=0;i<yList.length;i++){
				ySubList=yList[i].split("^");
				AddListItem("FVolume","VolID:"+ySubList[0]+"  "+"ADMID:"+ySubList[2],"",i);
			}
	    }
    }
}

function DisplayTMRInfo(MrType,MrNo,PatNo,CardNo)
{
	ClearTMRInfo();
	
	setElementValue("TCardNo",CardNo);
	setElementValue("TPatNo",PatNo);
	setElementValue("TMrNo",MrNo);
	
	if ((!MrType)&&(!MrNo)&&(!PatNo)&&(!CardNo)) return;
	
	var obj=document.getElementById('MethodGetMRInfo');
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var ret=cspRunServerMethod(encmeth,MrType,MrNo,PatNo,CardNo);
    if (ret){
    	var xList=ret.split(CHR_1);
    	var xSubList0,xSubList1;
    	if (xList[0]){xSubList0=xList[0].split("^");}
    	if (xList[1]){xSubList1=xList[1].split("^");}
    	//Patient Info
    	if (xSubList0){
			setElementValue("TPatNo",xSubList0[26]);
			setElementValue("TName",xSubList0[1]);
			setElementValue("TSex",xSubList0[3]);
			setElementValue("TBirthday",xSubList0[4]);
			setElementValue("TIdentityCode",xSubList0[12]);
			setElementValue("TCompany",xSubList0[13]);
			setElementValue("THomeAddress",xSubList0[16]);
			setElementValue("TPapmi",xSubList0[25]);
    	}
    	
    	//MR Main Info
    	if (xSubList1){
			setElementValue("TMainId",xSubList1[0]);
			setElementValue("TMrNo",xSubList1[2]);
			
			//MR Volume Info
			var obj=document.getElementById('MethodGetMRVolume');
			if (obj) {var encmeth=obj.value} else {var encmeth=''}
			var ret=cspRunServerMethod(encmeth,xSubList1[0]);
			var yList=ret.split(CHR_1);
			var ySubList;
			for (var i=0;i<yList.length;i++){
				ySubList=yList[i].split("^");
				AddListItem("TVolume","VolID:"+ySubList[0]+"  "+"ADMID:"+ySubList[2],"",i);
			}
	    }
    }
}

function ClearFMRInfo()
{
	setElementValue("FCardNo","");
	setElementValue("FPatNo","");
	setElementValue("FMrNo","");
	setElementValue("FName","");
	setElementValue("FSex","");
	setElementValue("FBirthday","");
	setElementValue("FIdentityCode","");
	setElementValue("FCompany","");
	setElementValue("FHomeAddress","");
	setElementValue("FPapmi","");
	setElementValue("FMainId","");
	ClearListBox("FVolume");
}

function ClearTMRInfo()
{
	setElementValue("TCardNo","");
	setElementValue("TPatNo","");
	setElementValue("TMrNo","");
	setElementValue("TName","");
	setElementValue("TSex","");
	setElementValue("TBirthday","");
	setElementValue("TIdentityCode","");
	setElementValue("TCompany","");
	setElementValue("THomeAddress","");
	setElementValue("TPapmi","");
	setElementValue("TMainId","");
	ClearListBox("TVolume");
}

initForm();