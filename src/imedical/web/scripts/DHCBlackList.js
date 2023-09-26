document.body.onload=ListDocCurrentLoadHandler;
var SelectedRow=0;
function ListDocCurrentLoadHandler()
{   var myobj=document.getElementById('CardTypeDefine');
	if (myobj){
			myobj.onchange=CardTypeDefine_OnChange;
			myobj.size=1;
			myobj.multiple=false;
		}
    loadCardType();
    CardTypeDefine_OnChange();
	var obj=document.getElementById("Modify");
	if(obj) obj.onclick=ModifyHandler;
	var obj=document.getElementById("CardNo1")
	if(obj) obj.onkeydown=CardNoKeydownHandler;
	var RegNoObj=document.getElementById('RegNo1');
	if (RegNoObj) RegNoObj.onkeydown = RegNoObj_keydown;
	var Obj=document.getElementById('ReadCard');
	if (Obj) Obj.onclick = ReadCardHandle;
	var obj=document.getElementById('Clear');
	if(obj) obj.onclick=btnClear_click;
}
function btnClear_click(){
	document.getElementById('CardNo1').value="";
	document.getElementById('RegNo1').value="";
	document.getElementById('Name').value="";
	var CurrentDate=document.getElementById('CurrentDate').value;
	document.getElementById('SttDate').value=CurrentDate;
	document.getElementById('EndDate').value=CurrentDate;
	
	Find_click();
}
function FormatCardNo(){
	var CardNo1=DHCC_GetElementData("CardNo1");
	if (CardNo1!='') {
		var CardNoLength=GetCardNoLength();
		if ((CardNo1.length<CardNoLength)&&(CardNoLength!=0)) {
			for (var i=(CardNoLength-CardNo1.length-1); i>=0; i--) {
				CardNo1="0"+CardNo1;
			}
		}
	}
	return CardNo1
}
function ReadCardHandle()
{
	var myEquipDR=DHCWeb_GetListBoxValue("CardTypeDefine");
    var CardInform=DHCACC_ReadMagCard(myEquipDR.split("^")[0],"R","23")
    var CardSubInform=CardInform.split("^");
    var rtn=CardSubInform[0];
	var CardNo=CardSubInform[1];
    switch (rtn){
			case rtn<0:
				alert("卡无效");
				break;
			default:
				document.getElementById('CardNo1').value=CardNo
				CardNoKeydown();
				break;
		}
}
function CardNoKeydownHandler(e) {
	if (evtName=='CardNo1') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key==13) {
		CardNoKeydown();
	}
}
function CardTypeDefine_OnChange()
{
	var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	var myary=myoptval.split("^");
	var myCardTypeDR=myary[0];
	if (myCardTypeDR=="")
	{
		return;
	}
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("CardNo1");
		if (myobj)
		{
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("ReadCard");
		DHCWeb_setfocus("CardNo1");
	}
	else
	{
		var myobj=document.getElementById("CardNo1");
		if (myobj)
		{
			myobj.readOnly = true;
		}
		var obj=document.getElementById('ReadCard');
		if (obj) {
			obj.disabled=false;
			DHCC_AvailabilityBtn(obj)
			obj.onclick = ReadCardHandle;
		}
		DHCWeb_setfocus("ReadCard");
	}
}
function CardNoKeydown(){
	var CardNo=document.getElementById("CardNo1").value
	CardNo1=FormatCardNo();
	document.getElementById('CardNo1').value=CardNo1
	Find_click();
		
}
function GetCardNoLength(){
	var CardNoLength="";
	var CardTypeValue=DHCC_GetElementData("CardTypeDefine");
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^");
		CardNoLength=CardTypeArr[17];
	}
	return CardNoLength;
}
function loadCardType(){
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=DHCWebD_GetObjValue("CardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
	}
}
function RegNoObj_keydown(e) {
	if (evtName=='RegNo1') 
	{
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key==13) {
		var obj=document.getElementById('RegNo1');
		if (obj.value!='') {
			
			if (obj.value.length<10) {
				for (var i=(10-obj.value.length-1); i>=0; i--) {
					obj.value="0"+obj.value
				}
			}
		}
	}
	document.getElementById('RegNo1').value=obj.value
	Find_click();
}
function ModifyHandler()
{
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCBlackDateConfig';
    websys_lu(str,"",'location=yes,width=500,height=200,left=200,top=200')
	
}
function SelectRowHandler()	
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	SelectedRow=selectrow;
	if (!selectrow) return;
	var updateLink='updatez'+selectrow;
	if (selectrow !=0) {
		if (eSrc.id==updateLink)	{
		var PBRowId=""
		var PBRowIdObj=document.getElementById("PBRowIdz"+selectrow);
		if (PBRowIdObj) PBRowId=PBRowIdObj.value;
		var UpdateLink='updatez'+selectrow;
		var Status=document.getElementById("InfoFlagz"+selectrow).innerText;
	    if(Status=='无效'){
		alert("已经失效的黑名单不能更新")
		return false
	    }
	    var SetBlackStatus=document.getElementById('SetBlackStatus');
		if (SetBlackStatus) {var encmeth=SetBlackStatus.value} else {var encmeth=''};
		var Stat=cspRunServerMethod(encmeth,PBRowId);
		if (Stat!='0')	{
			alert("状态更新失败");
			return false;
		}
		location.reload()
		}
	}
}