////UDHCAccCol.CardQuery.js

function BodyLoadHandler(){
	var obj=document.getElementById("CardStatusList");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.onchange=CardStatusList_Change;
	}

	var myReadFlag="Y";
	var myReadObj=document.getElementById("ReadOnly");
	if (myReadObj){
		var myReadFlag=myReadObj.value;
	}
	
	var obj=document.getElementById("UserCode");
	if ((obj)&&(myReadFlag!="N")){
		///obj.value=session['LOGON.USERCODE'];
		obj.readOnly=true;
	}else{
		///obj.value=session['LOGON.USERCODE'];
		///obj.value="";
	}
	var obj=document.getElementById("CardNo");
	if (obj){obj.onkeydown=CardNo_KeyDown}
}

function CardStatusList_Change(){
	var myValue=DHCWeb_GetListBoxValue("CardStatusList");
	var myary=myValue.split("^");
	DHCWebD_SetObjValueB("CardStatus",myary[0]);
}
function CardNo_KeyDown()
{
	var Key=websys_getKey(e);
	if ((13==Key)) {
    var Obj=document.getElementById("DefaultCardType");
    if (Obj){
	    var DefaultCardTypeValue=Obj.value;
	    var CardNoLength=DefaultCardTypeValue.split("^")[17];
	    var CardNo=""
		var objCardNo=document.getElementById("CardNo");
		if (objCardNo){CardNo=objCardNo.value;}
		if (CardNo!='') {
			if ((CardNo.length<CardNoLength)&&(CardNoLength!=0)) {
			for (var i=(CardNoLength-CardNo.length-1); i>=0; i--) {
				CardNo="0"+CardNo;
				}
			}
			}
		if (objCardNo){objCardNo.value=CardNo}
		}
    }	
}

///document.onkeydown = DHCWeb_EStopSpaceKey;
document.body.onload = BodyLoadHandler;
