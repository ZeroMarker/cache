var SelectedRow=0
var oestr
var combo_CardType
var CardNoobj
var CardVerify=""
var m_CCMRowID="";
var m_SelectCardTypeRowID="";
var m_CardNoLength=0;

function ReadCardType(){
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
	}
}
function GetCardTypeRowId(){
	var CardTypeRowId="";
	//var CardTypeValue=DHCC_GetElementData("CardType");
	var CardTypeValue=combo_CardType.getActualValue();
	
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardTypeRowId=CardTypeArr[0];
	}
	return CardTypeRowId;
}

function GetCardEqRowId(){
	var CardEqRowId="";
	//var CardTypeValue=DHCC_GetElementData("CardType");
	var CardTypeValue=combo_CardType.getActualValue();
	
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardEqRowId=CardTypeArr[14];
	}
	return CardEqRowId;
}


function GetCardNoLength(){
	var CardNoLength="";
	//var CardTypeValue=DHCC_GetElementData("CardType");
	var CardTypeValue=combo_CardType.getActualValue();

	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^");
		CardNoLength=CardTypeArr[17];
	}
	return CardNoLength;
}

function FormatCardNo(){
	var CardNo=DHCC_GetElementData("CardNo");
	if (CardNo!='') {
		var CardNoLength=GetCardNoLength();
		if ((CardNo.length<CardNoLength)&&(CardNoLength!=0)) {
			for (var i=(CardNoLength-CardNo.length-1); i>=0; i--) {
				CardNo="0"+CardNo;
			}
		}
	}
	return CardNo
}
function SetCardNOLength(){
	var obj=document.getElementById('CardNo');
		if (obj.value!='') {
			if ((obj.value.length<m_CardNoLength)&&(m_CardNoLength!=0)) {
				for (var i=(m_CardNoLength-obj.value.length-1); i>=0; i--) {
					obj.value="0"+obj.value
				}
			}
		}
}
function combo_CardTypeKeydownHandler(){
	//var myoptval=combo_CardType.getActualValue();
	var myoptval=combo_CardType.getSelectedValue();
	
	var myary=myoptval.split("^");
	var myCardTypeDR=myary[0];
	m_SelectCardTypeRowID=myCardTypeDR
	
	if (myCardTypeDR=="")	{	return;	}
	m_CCMRowID=myary[14];
	m_CardNoLength=myary[17];
	///Read Card Mode
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("CardNo");
		if (myobj){myobj.readOnly = false;}
		DHCWeb_DisBtnA("ReadCard");
	}	else{
		//m_CCMRowID=GetCardEqRowId();
		
		var myobj=document.getElementById("CardNo");
		if (myobj){myobj.readOnly = true;}
		var obj=document.getElementById("ReadCard");
		if (obj){
			obj.disabled=false;
			obj.onclick=ReadHFMagCard_Click;
		}
	}
	
	//Set Focus
	if (myary[16]=="Handle"){
		DHCWeb_setfocus("CardNo");
	}else{
		DHCWeb_setfocus("ReadCard");
	}
	if (combo_CardType) websys_nexttab(combo_CardType.tabIndex);
}





function BodyLoadHandler() 
{
	 
     var obj=document.getElementById("invoice");
     if (obj) obj.onclick = add_in;
     
     obj=document.getElementById("Clear");
     if (obj) obj.onclick = Clear_Click;
     
     obj=document.getElementById("papno");
     if (obj) obj.onkeydown = papno_keydown;
     
     obj=document.getElementById("PatName");
     if (obj) obj.readOnly=true;
     
     obj=document.getElementById("AdmInfo");
     if (obj) obj.readOnly=true;
     
     obj=document.getElementById("PatInstype");
     if (obj) obj.readOnly=true;
     
	 obj=document.getElementById("Adm");
     if (obj) obj.readOnly=true;
     
     
    var obj=document.getElementById('CardTypeDefine');
	if (obj) {
	          ReadCardType();
	          obj.setAttribute("isDefualt","true");
	          combo_CardType=dhtmlXComboFromSelect("CardTypeDefine");
	          }
	          
	
	if (combo_CardType) {
		combo_CardType.enableFilteringMode(true);
		combo_CardType.selectHandle=combo_CardTypeKeydownHandler;
		combo_CardTypeKeydownHandler();
	}
	var readcardobj=document.getElementById('ReadCard');
	if (readcardobj) readcardobj.onclick = ReadHFMagCard_Click;
	CardNoobj=document.getElementById('CardNo');
	if (CardNoobj) CardNoobj.onkeydown = getpatbyCardNo;
	
     
}
function SelectRowHandler()	
{  
	var eSrc=window.event.srcElement;
	var rowobj=getRow(eSrc)
	Objtbl=document.getElementById('tUDHCJFsetappr');
	Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;

	if (selectrow!=SelectedRow) {
	   var SelRowObj=document.getElementById('Toeitmz'+selectrow);
	   var  oeitm=SelRowObj.innerText;
	        document.getElementById("oeid").value=oeitm
	   var SelRowObj=document.getElementById('checkz'+selectrow);
	   SelRowObj.innerText=true;
	  
	    SelectedRow=selectrow   
	}
	else{
		 var SelRowObj=document.getElementById('checkz'+selectrow);
	   SelRowObj.innerText=false;
		document.getElementById("oeid").value=""
		
		}
}
function getoeid(){
	oestr=""
	Objtbl=document.getElementById('tUDHCJFsetappr');
	Rows=Objtbl.rows.length;
	for (i=1;i<Rows;i++){

		 var SelRowObj=document.getElementById('checkz'+i)
		   if (SelRowObj.checked==true){
	
			    var oeobj=document.getElementById('Toeitmz'+i);
	            var  oeitm=oeobj.innerText;
	     
	            oestr=oestr+"^"+oeitm
			   }
		
		}
	
	
	}
function add_in(){
   
	

    var Guser=session['LOGON.USERID']

	getoeid()
	
	if (oestr=="") return;
	var P1=oestr
	 var putin=document.getElementById('setappr');
	if (putin) {var encmeth=putin.value} else {var encmeth=''};	
	var num=cspRunServerMethod(encmeth,P1,Guser)
     if (num==1)    {
	     alert(t['01']);
    
	    Clear_Click();
	
     }
	
	}

function papno_keydown()
{
	var key=event.keyCode;
	if (key!=13) return;
	getpatinfobypapno();
	
	}
function getpatinfobypapno()
{
	var obj=document.getElementById("GetPatInfoCLS");
	if (!obj) return;
	var encmeth=obj.value
	obj=document.getElementById("papno");
	var P1=obj.value
	if (P1=="") return;
	var rtn=cspRunServerMethod(encmeth,P1)
	if (rtn=="") {Clear_Click();return;}
	var myARR=rtn.split("^");
	obj.value=myARR[6]
	obj=document.getElementById("PatName");
	if (obj) obj.value=myARR[7]
	SetAdmInfo(rtn)
	obj=document.getElementById("find");
	if (obj) websys_setfocus("find");
	
	}

function Clear_Click()
{
	
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFsetappr"
}

function SetAdmInfo(Val)
{
	if (Val=="") return;
	var myARR=Val.split("^");
	var obj=document.getElementById("AdmInfo");
	if (obj) obj.value=myARR[1]+" "+myARR[2]+" "+myARR[3]
	obj=document.getElementById("PatInstype");
	if (obj) obj.value=myARR[4]
	obj=document.getElementById("Adm");
	if (obj) obj.value=myARR[0]
	
	}
	
function ReadHFMagCard_Click()
{
	
	var papnoobj=document.getElementById("papno");
	var CardTypeValue=combo_CardType.getSelectedValue();
	var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeRowID,CardTypeValue);
	
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0":
			///rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			
			///Account Can Pay
			
			CardNoobj.value=myary[1];
			CardVerify=myary[2];
			papnoobj.value=myary[5];
			getpatinfobypapno();
			break;
		case "-200":
			alert(t["-200"]);
			break;
		case "-201":
			CardNoobj.value=myary[1];
			CardVerify=myary[2];
			papnoobj.value=myary[5];
			getpatinfobypapno();
			break;
		default:
			///alert("");
	}
}
function getpatbyCardNo()
{
	var key=event.keyCode;
	if (key!=13) return;
	getpatinfobycard();
	
	}
function getpatinfobycard()
{
	SetCardNOLength();
	
	var myCardNo=DHCWebD_GetObjValue("CardNo");
	var mySecurityNo="";
	var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeRowID, myCardNo, mySecurityNo, "PatInfo");
	var myary=myrtn.split("^");
	if ((myary[0]=="0")||(myary[0]=="-201")){
	var myPAPMNo=myary[5];
	var obj=document.getElementById("papno");
	DHCWebD_SetListValueA(obj,myPAPMNo);
	getpatinfobypapno();
	}
	
	}
document.body.onload = BodyLoadHandler;