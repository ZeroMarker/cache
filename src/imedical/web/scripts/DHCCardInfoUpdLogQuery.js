var comb_CardTypeDefine;
var combo_CardType;

document.body.onload = BodyLoadHandler;
var e=event;
function BodyLoadHandler()
{  
	 document.onkeydown=nextfocus1;
	 var obj=document.getElementById('Blank')
  	 obj.onclick=Blank_onclick;
  	 ReadCardType();
  	 var obj=document.getElementById('CardType');
	 if (obj) obj.setAttribute("isDefualt","true");
	 combo_CardType=dhtmlXComboFromSelect("CardType");
	 if (combo_CardType) {
		combo_CardType.enableFilteringMode(true);
		combo_CardType.selectHandle=combo_CardTypeKeydownHandler;
	}
	var obj=document.getElementById('UPCardNo');
	if (obj){obj.onkeydown=CardNoKeydownHandler}
	
}
function Blank_onclick()
{ 
  var obj=document.getElementById('UPCardNo')
  obj.value="";
  var obj=document.getElementById('UPRegNo')
  obj.value="";
  var obj=document.getElementById('UPPAPERName')
  obj.value="";
  var obj=document.getElementById('UPsPAPERName')
  obj.value="";
  var CurDate=""
  var CurDateObj=document.getElementById('CurDate')
  if (CurDateObj)  CurDate=CurDateObj.value
  var obj=document.getElementById('StartDate')
  obj.value=CurDate;
  var obj=document.getElementById('EndDate')
  obj.value=CurDate;	
  DHCC_ClearTable("tDHCCardInfoUpdLogQuery")
  Bsearch_click();
}
function nextfocus1() 
{  
  var eSrc=window.event.srcElement;
  var key=websys_getKey(e);
  if (key==13) 
  {
  	if (eSrc.name=='UPCardNo')
  		{ 
  			SetCardNoLength();
  		}
 	
 	Bsearch_click();
 	websys_nexttab(eSrc.tabIndex);
	}
}

function SetCardNoLength()
{ 
  m_CardNoLength=GetCardNoLength();
  var obj=document.getElementById('UPCardNo');
  var objValue=obj.value;
  objValue=objValue.replace(/(^\s*)|(\s*$)/g,"");
  if (objValue!='') 
  {
    if((objValue.length<m_CardNoLength)&&(m_CardNoLength!=0)) 
    {
     for (var i=(m_CardNoLength-objValue.length-1); i>=0; i--) 
      {
          objValue="0"+objValue
      }
     }
    var myCardobj=document.getElementById('UPCardNo');
    if (myCardobj)
    {
     myCardobj.value=objValue;
    }
   }
  ChangeCardTypeByCardNo('UPCardNo',comb_CardTypeDefine,'getcardtypeclassbycardno');
}
//-----------------------增加卡类型相关函数。卡号自动补全lxz
function ReadCardType(){
	DHCC_ClearList("CardType");
	var encmeth=DHCC_GetElementData("CardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardType");
	}
}
function combo_CardTypeKeydownHandler()
{
    var myCardobj=document.getElementById('UPCardNo');
    if (myCardobj)
    {
     myCardobj.value="";
    }
}
function CardNoKeydownHandler(e)
{
	
	if (evtName=='UPCardNo') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key==13) {
		 var myCardobj=document.getElementById('UPCardNo');
    	 if (myCardobj)
    		{
     		myCardobj.value=FormatCardNo();;
    		}
    	}
}
function GetCardNoLength(){
	var CardNoLength="";
	var CardTypeValue=DHCC_GetElementData("CardType");
	var CardTypeValue=combo_CardType.getSelectedValue();
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^");
		CardNoLength=CardTypeArr[17];
	}
	return CardNoLength;
}
function FormatCardNo(){
	var CardNo=DHCC_GetElementData("UPCardNo");
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
//-------------lxz