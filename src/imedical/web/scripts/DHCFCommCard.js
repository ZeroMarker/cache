function loadCardType(){
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth!="")
	{
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
	}
}

/*loadXComboData
[����]������е�Item(encryptObjSt)����value=##Class(%CSP.Page).Encrypt($lb("web.UDHCOPOtherLB.ReadCredTypeExp"))
[����]��ִ�н��������ΪshowObjStr�Ķ���
[Ҫ��]��showObjΪListBox
[����]��
	$('RLCredTypeList').size=1;
	$('RLCredTypeList').multiple=false;
	loadXComboData("RLCredTypeList","getcredtypeClass");
	combo_RLCredTypeList=dhtmlXComboFromSelect("RLCredTypeList");
	combo_RLCredTypeList.enableFilteringMode(true);
*///���¸�������:2007-11-30
function loadXComboData(showObjStr,encryptObjStr){
	showObj=document.getElementById(showObjStr);
	encryptObj=document.getElementById(encryptObjStr);
	if(!showObj||!encryptObj) return;
	try
	{
		DHCWebD_ClearAllListA(showObjStr);
		var encmeth=DHCWebD_GetObjValue(encryptObjStr);
		if (encmeth!="")
		{
			var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA",showObjStr);
		}
	}catch(e){};
}
/*loadXComboDataGroup
*/
function loadXComboDataGroup(showObjStr,encryptObjStr,GroupID){
	showObj=document.getElementById(showObjStr);
	encryptObj=document.getElementById(encryptObjStr);
	if(!showObj||!encryptObj) {return;}
	if(!GroupID) {return;}
	try
	{
		DHCWebD_ClearAllListA(showObjStr);
		var encmeth=DHCWebD_GetObjValue(encryptObjStr);
		if (encmeth!="")
		{
			var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA",showObjStr,GroupID);
		}
	}catch(e){};
}
function CardTypeDefine_OnChange(){
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
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("ReadCard");
	}
	else
	{
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = true;
		}
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
	
	m_CardNoLength=myary[17];
	
	
}
function SetCardNOLength(){
	var obj=document.getElementById('RCardNo');
		if (obj.value!='') {
			if ((obj.value.length<m_CardNoLength)&&(m_CardNoLength!=0)) {
				for (var i=(m_CardNoLength-obj.value.length-1); i>=0; i--) {
					obj.value="0"+obj.value
				}
			}
			var myCardobj=document.getElementById('CardNo');
			if (myCardobj){
				myCardobj.value=obj.value;
			}
		}
}

/*Card_GetEntityClassInfoToXML
[����]:���������л��ۿ���ָ�������л��Ľڵ�
[����]:$V(a)Ϊȡָ������a��ֵ���൱��documeng.getElementById(a).value;
var CardInvprt=["CardFareCost="+$V("CardFareCost"),
								"PayMode="+combo_PayMode.value.split("^")[0],
								"ReceiptNO="+$V("ReceiptNO")];
var CardInvprtInfo=GetEntityClassInfoToXML(CardInvprt,"CardINVPRT");
*///���¸�������:2007-12-1
function Card_GetEntityClassInfoToXML(ParseInfo,xmlNode){
	var m_XmlNode="TransContent";
	if(xmlNode){
		if(xmlNode!=""){
			
			m_XmlNode=xmlNode;
		}
	}
	var myxmlstr="";
	try
	{
		var xmlobj=new XMLWriter();
		xmlobj.BeginNode(m_XmlNode);
		for(var i=0;i<ParseInfo.length;i++)
		{
				xmlobj.BeginNode(ParseInfo[i].split("=")[0]);
				xmlobj.WriteString(ParseInfo[i].split("=")[1]);
				xmlobj.EndNode();
		}
		xmlobj.EndNode();
		xmlobj.Close();
		myxmlstr = xmlobj.ToString();
			
	}catch(Err)
	{
		alert("Error: " + Err.description);
	}
	
	return myxmlstr;
}
/*ͨ������ˢ�¿�����
׼���۽���һ������item(����"getcardtypeclassbycardno")�B����valuegetֵΪs val=##Class(%CSP.Page).Encrypt($lb("web.DHCBL.CARD.CardManager.getcardtypeinfoByCardNo"))
���ø�ʽ���ڿ��Żس��¼������ChangeCardTypeByCardNo(����item���ۿ����������ؼ����������item��)
�����ChangeCardTypeByCardNo('CardNo',combo_CardTypeDefine,'getcardtypeclassbycardno');
*///����2007-12-11
function ChangeCardTypeByCardNo(cardNoObjStr,cardTypeObj,getcardtypeObjstr){
	if (!cardTypeObj) return;
	var getcardnoobj=document.getElementById(cardNoObjStr);
	var getcardtypeobj=document.getElementById(getcardtypeObjstr);
	if (!getcardnoobj) {return};
	if (!getcardtypeobj) {return};
	var cardvalue=getcardnoobj.value;
	var cardtypevalue=getcardtypeobj.value;
	if (cardtypevalue=="") return;
	if (cardvalue=="") return;
	var retValue=cspRunServerMethod(cardtypevalue,cardvalue);
	if (retValue=="") return;
	cardTypeObj.setComboText("");
	var myary=retValue.split("^");
	cardTypeObj.setComboValue(myary[0]);
}