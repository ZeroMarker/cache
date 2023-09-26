//FileName: DHCPEPreItemList.JS
//Description: ԤԼ��Ŀ
var UserId=session['LOGON.USERID'];
var LocId=session['LOGON.CTLOCID'];
var ItemMap = new Map();
var SetMap = new Map();
function GetCtlsValue(CtlsSpec, Splitor)
{	
	var arrCtls=CtlsSpec.split(Splitor);
	var returnData=GetCtlValueById(arrCtls[0], true);
	for(var i=1;i<arrCtls.length;i++)
	{
		returnData=returnData + Splitor + GetCtlValueById(arrCtls[i], true);		
	}
	return returnData;
}
function SendRequest()
{
	var obj,encmeth="";
	obj=document.getElementById("txtAdmId");
	var iRowId="";
	if (obj && ""!=obj.value) { iRowId=obj.value; }
	var obj,encmeth="";
	obj=document.getElementById("GetPAADMID");
	if (obj) encmeth=obj.value;
	var Info=cspRunServerMethod(encmeth,iRowId);
	if (Info=="") return false;
	var Arr=Info.split("^");
	var PAADM=Arr[0];
	var PatID=Arr[1];
	//var url="dhcmrdiagnosnew.csp?EpisodeID="+PAADM+"&PatientID="+PatID;
  	//var ret=window.showModalDialog(url, "", "dialogwidth:1000px;dialogheight:600px;center:1"); 
	//var url="dhcrisappbill.csp?EpisodeID="+PAADM+"&PatientID="+PatID;
	var url="diagnosentry.csp?PatientID="+PatID+"&EpisodeID="+PAADM+"&mradm="+"";
	var wwidth=1250;
	var wheight=650;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = ((screen.height - wheight) / 2)-10;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	window.open(url,"_blank",nwin)
	
}
function SetCtlValueById(ctlID, ctlValue, withAlert){
	SetCtlValueByID(ctlID, ctlValue, withAlert)
}
function SetCtlValueByID(ctlID, ctlValue, withAlert)
{
	var myObject=document.getElementById(ctlID);
	if (myObject)
		myObject.value=ctlValue;
	else if (withAlert)
		alert("�ؼ�: " + ctlID + "  ������?");
}


function GetCtlValueById(ctlID, withAlert)
{
	if (ctlID=="")
		return "";
	var myObject=document.getElementById(ctlID);
	if (myObject){
		if (myObject.type=="checkbox") return myObject.status;
		//if (myObject.tag=="label") return myObject.innerText;
		return myObject.value;
		}
	else {
		if (withAlert) alert("�ؼ�: " + ctlID + "  ������?");
		return "";
	}
}



var gMyName="DHCPEPreItemList";
var gUserId=session['LOGON.USERID']
var gAdmId="", gIsGroup="", gAdmType="", gTargetFrame="", gPreOrAdd=""
var gRowIndex=""

var IsExec=false; // �Ƿ�����ִ�в���
var row=0;
var Rows;
function IniMe(){
	//SendRequest();
	var obj;
	
	obj=document.getElementById("txtItemDesc");
	if (obj) obj.onkeydown=txtItemDesc_KeyDown;
	obj=document.getElementById("txtItemSetDesc");
	if (obj) obj.onkeydown=txtItemSetDesc_KeyDown;
	// ��ʾҽ����Ŀ�б�
	var obj=document.getElementById("btnShowItem");
	if (obj) { obj.onclick=btnShowItem_Click; }
	
	// ��ʾ��Ŀ���б�
	var obj=document.getElementById("btnShowItemSet");
	if (obj) { obj.onclick=btnShowItemSet_Click; }
	// ��ʾҽ����Ŀ�б�
	
	// ɾ����Ŀ
	var obj=document.getElementById("btnDeleteItem");
    if (obj){
    	obj.onclick=btnDeleteItem_click;
		obj.disabled=true;	
    }
	// ɾ����Ŀ��
	var obj=document.getElementById("btnDeleteSet");
	if (obj){
		obj.onclick=btnDeleteSet_click;
		obj.disabled=true;
	}
	// ɾ����Ŀ���Ӽ�����
	var obj=document.getElementById("btnDeleteItemAddAmount");
    if (obj){
    	obj.onclick=btnDeleteItemAddAmount_click;
		obj.disabled=true;	
    }
	// ɾ����Ŀ�����Ӽ�����
	var obj=document.getElementById("btnDeleteSetAddAmount");
	if (obj){
		obj.onclick=btnDeleteSetAddAmount_click;
		obj.disabled=true;
	}
	
	// ɾ��ѡ����Ŀ
	var obj=document.getElementById("BDeleteSelect");
	if (obj){
		obj.onclick=BDeleteSelect_click;
		//obj.disabled=true;
	}
	// �˳�
	var obj=document.getElementById("btnExit");
	if (obj) obj.onclick=btnExit_Click;

	// Confirm Add Order
	var obj=document.getElementById("ConfirmOrdItem");
	if (obj) obj.onclick=ConfirmOrdItem_Click;

	//var obj=document.getElementById("btnSaveFactAmount");
	//obj.onclick=btnSaveFactAmount_onClick;	
	
	var obj=document.getElementById("BPreOverReg");          //add by zl 20100208
	if (obj){                                               //add by zl 20100208
		obj.onclick=BPreOverReg_click;                     //add by zl 20100208
	}
	var obj=document.getElementById("BArrived");          
	if (obj){                                             
		obj.onclick=BArrived_click;                     
	} 
	var obj=document.getElementById("BAddOtherFee");         
	if (obj){                                             
		obj.onclick=BAddOtherFee_click;                     
	} 
	var VipFlag=GetCtlValueById("VipFlag",1);
	if (VipFlag=="") {
		var obj=document.getElementById("BEndanger");
		if (obj) obj.style.visibility = "hidden";
	}
	// �Ƿ����������BAddOtherFee
	gIsGroup=GetCtlValueById("txtIsGroup",1)
	if (gIsGroup=="1"){
		var obj=document.getElementById("BEndanger");
		if (obj) obj.style.visibility = "hidden";
	}
	gAdmType=(gIsGroup=="1"?"TEAM":"PERSON")
    if (gAdmType=="PERSON"){
		var obj=document.getElementById("GEndanger");
		if (obj) obj.style.visibility = "hidden";
	}

	// ����ԤԼID/����ԤԼID
	gAdmId=GetCtlValueById("txtAdmId",1)

	// ԤԼ����  ����(PERSON)/����(TEAM)
	gAdmType=(gIsGroup=="1"?"TEAM":"PERSON")
	var GADM=GetCtlValueById("GADM",1)
	if ((gAdmType=="TEAM")||(GADM==""))
	{
		var obj=document.getElementById("btnDeleteItemAddAmount");
		if (obj) obj.style.visibility = "hidden";
		var obj=document.getElementById("btnDeleteSetAddAmount");
		if (obj) obj.style.visibility = "hidden";
	}
	var StatusObj=document.getElementById("ADMStatus");
	var Status="";
	if (StatusObj) Status=StatusObj.value;
	if ((gAdmType!="PERSON")||((Status!="PREREG")&&(Status!="PREREGED")))                                           //add by zl 20100208 start
	{
		var obj=document.getElementById("BPreOverReg");
		if (obj) obj.style.visibility = "hidden";
		var obj=document.getElementById("BArrived");
		if (obj) obj.style.visibility = "hidden";
	} 

	gTargetFrame=GetCtlValueById("TargetFrame",1)
	//����-�Ƿ񹫷�AddOrdItem
	gPreOrAdd=GetCtlValueById("txtPreOrAdd",1)
	// ����Ŀ��?��Ŀ/����
	if (gTargetFrame==""){
		obj=document.getElementById("btnShowItemSet")
		if (obj) obj.style.visibility = "hidden";
		obj=document.getElementById("btnShowItem")
		if (obj) obj.style.visibility = "hidden";		
	}
	
	
	if ((gIsGroup=="")||(gAdmId=="")){
		alert("Please tranfer AdmId to this component");
		return;		
	}
		
	// ���ø�����(ԤԼҳ��) ��Ӧ�ս��
	SaveAmount();
	///����Ŀ�Żݵ�ʱ����½��
	var ShowFlag=GetCtlValueById("ShowFlag",1)
	var obj=document.getElementById("btnSaveAmount");
	if(ShowFlag=="F"){obj.style.visibility = "hidden";}
	if (obj) obj.onclick=UpdateOPAmount;
	//�������ս�����״̬
	//ContractFactAmountEnabled()
	//����������
	var obj=document.getElementById("BSaveFeeType");
	if (obj) obj.onclick=ChangeItemFeeType;
	
	var obj=document.getElementById("SelectALL");
	if (obj) { obj.onclick=SelectALL_Click; }
	//�����ԷѼ����Ƿ���ͬ�շ�Add 3.5
	var obj=document.getElementById("IFeeAsCharged");
	if (obj) { 
		if((gAdmType=="PERSON")&&(GADM=="") ){websys_disable(obj);}
		obj.onchange=IFeeAsCharged_change;
	}
	var obj=document.getElementById("cIFeeAsCharged");
	if (obj) { 
		if((gAdmType=="PERSON")&&(GADM=="") ){websys_disable(obj);}	
		}

	
	var obj=document.getElementById("OpenCharge");         
	if (obj){obj.onchange=OpenCharge_change; }
	
	//�����Է�ת��
    var ObjArr=document.getElementsByName("BChangeFee");
	if (ObjArr){
		var ArrLength=ObjArr.length;
		for (var j=0;j<ArrLength;j++){
			ObjArr[j].onclick=ChangeFeeTypeFuction;
		}
	}

	ColorTblColumn()
	Rows=GetTotalRows();
	InsertNetSets();
	//parent.ItemType.value=GetCtlValueById("SelectType",1);
	parent.frames['GetItemType'].ItemType.value=GetCtlValueById("SelectType",1);
	
	obj=document.getElementById("CShowType_Item");
	if (obj) { 
		obj.onclick=ShowType_Click;
		//if (("Item"==parent.ItemType.value)) { obj.checked=true; }
		if (("Item"==parent.frames['GetItemType'].ItemType.value)) { obj.checked=true; }
	}
	// ��ʾ��Ŀ���б�
	obj=document.getElementById("CShowType_ItemSet");
	if (obj) {
		//if ("ItemSet"==parent.ItemType.value) { obj.checked=true; }
		if ("ItemSet"==parent.frames['GetItemType'].ItemType.value) { obj.checked=true; }
		obj.onclick=ShowType_Click;
	}
	//��ʾ������Ŀ
	obj=document.getElementById("CShowType_Lab");
	if (obj) {
		//if ("Lab"==parent.ItemType.value) { obj.checked=true; }
		if ("Lab"==parent.frames['GetItemType'].ItemType.value) { obj.checked=true; }
		obj.onclick=ShowType_Click;
	}
	//��ʾ������Ŀ
	obj=document.getElementById("CShowType_Other");
	if (obj) {
		//if ("Other"==parent.ItemType.value) { obj.checked=true; }
		if ("Other"==parent.frames['GetItemType'].ItemType.value) { obj.checked=true; }
		obj.onclick=ShowType_Click;
	}
	//��ʾ������Ŀ
	obj=document.getElementById("CShowType_Medical");
	if (obj) {
		//if ("Medical"==parent.ItemType.value) { obj.checked=true; }
		if ("Medical"==parent.frames['GetItemType'].ItemType.value) { obj.checked=true; }
		obj.onclick=ShowType_Click;
	}
	//PrintAllApp(gAdmId,"CRM")
	//SetChoiceRecLoc();
	
	//btnShow_Click();
	//InitInsuFlag()
	
}


function ChangeFeeTypeFuction()
{
	var eSrc = window.event.srcElement;

	var gIsGroup=GetCtlValueById("txtIsGroup",1)
	var gAdmType=(gIsGroup=="1"?"TEAM":"PERSON")
	var GADM=GetCtlValueById("GADM",1)

	if((gAdmType=="PERSON")&&(GADM=="")){
		alert("����������Ա,���������");
			window.location.reload();
		return false;
	}
	var ret=tkMakeServerCall("web.DHCPE.PreItemListEx","ChangeFeeType",eSrc.id);
	if (ret=="0"){
		var Arr=eSrc.id.split("^")
		if (Arr[2]=="G"){
			eSrc.innerText="ת�Է�";
			eSrc.id=Arr[0]+"^"+Arr[1]+"^"+"I";
		}else{
			eSrc.innerText="ת����";
			eSrc.id=Arr[0]+"^"+Arr[1]+"^"+"G";
		}
		alert("ת���ɹ�")
		window.location.reload();
		return false;
	}
	alert("ת��ʧ��:"+ret)
	  window.location.reload();
	  return false; 
}

function OpenCharge_change()
{
	var e=window.event.srcElement;
	var Flag=0
	if (e.checked) Flag=1;
	var ret=tkMakeServerCall("web.DHCPE.PreItemList","SetOpenChargeFlag",Flag); 
}

/*
function OpenCharge()
{

	var obj=document.getElementById("OpenCharge");
	if ((obj&&obj.checked)){
	if (gAdmType=="TEAM") return false;
		var GIADM=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetIADMbyPreIADM",gAdmId);
		if (GIADM=="") return false;
		var lnk='dhcpepreauditpay.csp?AppType=Fee&ADMType=I&CRMADM=&CloseFlag=1&GIADM='+GIADM;
		
		var wwidth=1250;
		var wheight=650;
	
	
		var xposition = (screen.width - wwidth) / 2;
		var yposition = ((screen.height - wheight) / 2)-10;
		var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+400+',width='+800+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	}
}
*/
function OpenCharge()
{
	var obj=document.getElementById("txtTotalAmount");
	if(obj){
		var TotalAmount=tkMakeServerCall("web.DHCPE.PreItemList","IGetGZAmount",gAdmId,gAdmType);
		}

	var ZFTotalAmount=TotalAmount.split("�Է�:");
	
	var obj=document.getElementById("OpenCharge");
	if ((obj&&obj.checked)){
	if (gAdmType=="TEAM") return false;
		var GIADM=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetIADMbyPreIADM",gAdmId);
		if (GIADM=="") return false;
		if(ZFTotalAmount[1]>0){
		var lnk='dhcpepreauditpay.csp?AppType=Fee&ADMType=I&CRMADM=&CloseFlag=1&GIADM='+GIADM;
		
		
		var wwidth=1250;
		var wheight=650;
	
	
		var xposition = (screen.width - wwidth) / 2;
		var yposition = ((screen.height - wheight) / 2)-10;
		var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+400+',width='+800+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin) 
		}
	}
}

function IFeeAsCharged_change()
{
	var e=window.event.srcElement;
	var AsCharged="N";
	if (e.checked) AsCharged="Y";
	var encmeth=GetCtlValueById("SetAsCharged",1);
	
	var ret=cspRunServerMethod(encmeth,gAdmId,AsCharged);
	if (ret!=""){
		alert(ret)
	}
}
function InsertNetSets()
{
	var NetSetsID=GetCtlValueById("NetSetsID",1);
	if (NetSetsID=="") return false;
	if ((""==gAdmId)||(""==gAdmType)) {
		return false;
	}
	var AdmIdStr=gAdmId.split("^");
  	var Rows=AdmIdStr.length;
  	for(i=0;i<Rows;i++)
 	{ 
 	  	var AdmId=AdmIdStr[i];
    	var flag="";
		var encmeth=GetCtlValueById("txtAddBox",1);
    	var flag=cspRunServerMethod(encmeth,AdmId, gAdmType,gPreOrAdd,"", NetSetsID,gUserId);
  		if (flag!="") alert(flag)
  	}
 	var lnk=window.location.href;
  	lnk=lnk.split("&NetSetsID")[0];
  	window.location.href=lnk;
}
function SetFocus()
{
	var AddType=GetCtlValueById("AddType",1)
	if (AddType=="Set")
	{
		websys_setfocus("txtItemSetDesc");
	}
	else
	{
		websys_setfocus("txtItemDesc");
	}
}
function GetTotalRows() {
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCPEPreItemList');	
	if (objtbl) { var rows=objtbl.rows.length; }
	return rows-1
}

function SetChoiceRecLoc()
{
	for (var j=1;j<Rows+1;j++) {
		var sLable=document.getElementById('TRecLocz'+j);
		var obj=document.getElementById('TOrderEntIdz'+j);
		var OrderEntId="";
		if (obj) OrderEntId=obj.value;
		obj=document.getElementById('TItemStatz'+j);
		var ItemStat=4;
		if (obj) ItemStat=obj.value;
		if (OrderEntId==""&&ItemStat==1)
		{
			if (sLable) sLable.onkeydown = ChoiceRecLoc;
		}
		else
		{
			if (sLable) sLable.disabled=true;
		}
		sLable=document.getElementById('TSpecNamez'+j);
		obj=document.getElementById('TItemIdz'+j);
		var ItemID="";
		if (obj) ItemID=obj.value;
		if ((ItemID!="")&&(ItemStat==1))
		{
			if (sLable) sLable.onkeydown = ChoiceSpecName;
		}
		else
		{
			if (sLable) sLable.disabled=true;
		}
	}
}
function ChoiceRecLoc()
{
	if (event.keyCode==13)
	{ 
	
		var eSrc=window.event.srcElement;
		payModeName=eSrc.id;
		row=payModeName.substr(8,payModeName.length)
		if (row==0) return;
		var obj=document.getElementById('TOrderEntIdz'+row);
		var OrderEntId="";
		if (obj) OrderEntId=obj.value;
		if (OrderEntId!="") return;
		var obj=document.getElementById('TItemIdz'+row);
		var ItemID="";
		if (obj) ItemID=obj.value;
		var obj=document.getElementById('PAADM');
		var PAADM=""
		if (obj) PAADM=obj.value;
		//var PAADM="1"
		var url='websys.lookup.csp';
		url += "?ID=&CONTEXT=K"+"web.DHCOPItemMast:AIMRecLoc";
		url += "&TLUJSF=SetRecLoc";
		url += "&P1="+PAADM+"&P2="+ItemID;
		websys_lu(url,1,"");
		return websys_cancel();
	}

}
function SetRecLoc(value)
{
	var RecStr=value.split("^");
	var LocID=RecStr[1];
	var obj=document.getElementById('TRowIdz'+row);
	if (obj) var RowID=obj.value;
	obj=document.getElementById('UpdateRecLoc');
	if (obj) var encmeth=obj.value;
	var Flag=cspRunServerMethod(encmeth,LocID,RowID,gAdmType)
	if (Flag!=0)
	{
		alert(Flag);
		return;
	}
	var obj=document.getElementById('TRecLocz'+row);
	if (obj) obj.value=RecStr[0];
}
function ChoiceSpecName()
{
	if (event.keyCode==13)
	{
		var eSrc=window.event.srcElement;
		payModeName=eSrc.id;
		row=payModeName.substr(10,payModeName.length)
		if (row==0) return;
		var obj=document.getElementById('TItemIdz'+row);
		var ItemID="";
		if (obj) ItemID=obj.value;
		if (ItemID=="") return;
		var url='websys.lookup.csp';
		url += "?ID=&CONTEXT=K"+"web.DHCPE.BarPrint:SerchSpecName";
		url += "&TLUJSF=SetSpecName";
		url += "&P1="+ItemID;
		websys_lu(url,1,"");
		return websys_cancel();
	}

}
function SetSpecName(value)
{
	var RecStr=value.split("^");
	var SpecID=RecStr[0];
	var SpecName=RecStr[1];
	var obj=document.getElementById('TRowIdz'+row);
	if (obj) var RowID=obj.value;
	obj=document.getElementById('UpdateSpecName');
	if (obj) var encmeth=obj.value;
	var Flag=cspRunServerMethod(encmeth,SpecID+"^"+SpecName,RowID,gAdmType)
	if (Flag!=0)
	{
		alert(Flag);
		return;
	}
	var obj=document.getElementById('TSpecNamez'+row);
	if (obj) obj.value=SpecName;
}
function ColorTblColumn(){
	var tbl=document.getElementById('tDHCPEPreItemList');	//ȡ���Ԫ��?����
	var row=tbl.rows.length;
	row=row-1;
	var obj,Data="";
	ItemMap.clear();
	SetMap.clear();
	var obj=document.getElementById("GetItemDesc");
	if (obj) encmeth=obj.value;
	var ItemInfo=cspRunServerMethod(encmeth,gAdmId,gAdmType);
	var Char_1=String.fromCharCode(1);
	var Char_2=String.fromCharCode(2);
	var SetInfo=ItemInfo.split(Char_1)[1];
	var ItemInfo=ItemInfo.split(Char_1)[0];
	if (ItemInfo!=""){
		var ItemArr=ItemInfo.split("^")
		var i=ItemArr.length;
		for (var j=0;j<i;j++){
			var ItemDescArr=ItemArr[j].split(Char_2);
			var ItemDesc=ItemDescArr[0];
			var ItemFlag=ItemDescArr[1];
			
			if ((ItemMap.get(ItemDesc)==null)&&(ItemDesc!="")) ItemMap.put(ItemDesc,ItemFlag);
		}
	}
	
	if (SetInfo!=""){
		var SetArr=SetInfo.split("^")
		var i=SetArr.length;
		for (var j=0;j<i;j++){
			var SetDesc=SetArr[j];
			if ((SetMap.get(SetDesc)==null)&&(SetDesc!="")) SetMap.put(SetDesc,"");
		}	
	}
	for (var j=1;j<row+1;j++) {
		var sLable=document.getElementById('TItemStatz'+j);
		var sItemStat=sLable.parentElement;
		var strCell=sLable.value;
		strCell=strCell.replace(" ","")
		if (strCell!='1') {
			var obj=document.getElementById("TInsuFlagz"+j);
			if (obj){obj.disabled=true;}
			tbl.rows[j].style.background="#FF88AA";		
		}
		obj=document.getElementById("TModifiedFlagz"+j);
		if (obj) Data=obj.value;

		if ((Data!="1")||(strCell!="1"))
		{
			obj=document.getElementById("TFactAmountz"+j);
			if (obj) obj.disabled=true;
		}
		var MedicalFlag="0";
		obj=document.getElementById("TIsMedicalz"+j);
		if (obj) MedicalFlag=obj.value;
		if ((MedicalFlag!="1")||(strCell!="1"))
		{
			obj=document.getElementById("TQtyz"+j);
			if (obj) obj.disabled=true;
		}
		
		var sLable=document.getElementById('TRecLocz'+j);
		var obj=document.getElementById('TOrderEntIdz'+j);
		var OrderEntId="";
		if (obj) OrderEntId=obj.value;
		obj=document.getElementById('TItemStatz'+j);
		var ItemStat=4;
		if (obj) ItemStat=obj.value;
		
		if (OrderEntId==""&&ItemStat==1)
		{
			if (sLable) sLable.onkeydown = ChoiceRecLoc;
		}
		else
		{
			if (sLable) sLable.disabled=true;
		}
		sLable=document.getElementById('TSpecNamez'+j);
		obj=document.getElementById('TItemIdz'+j);
		var ItemID="";
		if (obj) ItemID=obj.value;
		if ((ItemID!="")&&(ItemStat==1))
		{
			if (sLable) sLable.onkeydown = ChoiceSpecName;
		}
		else
		{
			if (sLable) sLable.disabled=true;
		}
		
	}
}
// ////////////////////////////////////////////////////////////////////////
function txtItemSetDesc_KeyDown()
{
	var Key=websys_getKey(e);
	if ((13==Key)) {
		var ComponentObj=document.getElementById("ComponentID");
		if (ComponentObj){var ComponentID=ComponentObj.value
		var obj=document.getElementById("ld"+ComponentID+"itxtItemSetDesc");
		if (obj) obj.click();}
	}
}
function txtItemDesc_KeyDown()
{
	var Key=websys_getKey(e);
	if ((13==Key)) {
		var ComponentObj=document.getElementById("ComponentID");
		if (ComponentObj){var ComponentID=ComponentObj.value
		var obj=document.getElementById("ld"+ComponentID+"itxtItemDesc");
		if (obj) obj.click();}
	}
}

function AddOrder(){
	//alert('s')
	var ItemSetId=GetCtlValueById("txtItemSetId",1)
	var ItemId=GetCtlValueById("txtItemId",1)
	if ((ItemId=="")&&(ItemSetId=="")){
		alert(t['NoSelected']);
		return false;
	}
	var AddType="Set"
	if (ItemId!="") AddType="Item"
	if ((""==gAdmId)||(""==gAdmType)) {
		return false;
	}
	var obj=document.getElementById("GeneralAdviceAudited");
	if (obj) var Flag=obj.value;
	if (Flag=="1"){
		alert(t["GeneralAdviceAudited"]);
		return false;
	}
	Status="REG"
	var obj=document.getElementById("Status");
	if (obj) Status=obj.value;
	// �鿴�Ƿ���Ŀ�Ѵ��� 
	var AdmIdStr=gAdmId.split("^");
    var Rows=AdmIdStr.length;
	var PreOrAdd=GetCtlValueById('txtPreOrAdd',1);
   for(i=0;i<Rows;i++)
 	{ 
 	var AdmId=AdmIdStr[i]
	if(AddType=="Item"){
	   var IsAddPhc=tkMakeServerCall("web.DHCPE.PreItemList","IsAddPhcItem",gAdmId,gAdmType,ItemId,PreOrAdd)
 	   if(IsAddPhc=="1") {
	 	    if("PERSON"==gAdmType){
	 	   alert("���˲������ҩ");
	 	   return false;
	 	   }
	 	    if("TEAM"==gAdmType){
	 	   alert("���鲻�����ҩ");
	 	   return false;
	 	   }

 	   }
	}
 
  //�ײ��Ա��ж�
	var SetSexFlag;
	if(AddType=="Set") {
 	SetSexFlag=tkMakeServerCall("web.DHCPE.PreItemList","IsSetSex",AdmId,gAdmType,ItemSetId)
	var SetSexCanFlag=SetSexFlag.split("^")
	if(SetSexCanFlag[0]=="1"){
		alert(SetSexCanFlag[1]);
		return false;
	
	}
	}

 	var isetid="";
 	var ItemCT
 	ItemCT=tkMakeServerCall("web.DHCPE.PreItemList","IsCT",AdmId,gAdmType,ItemId)
 	//alert("AdmId"+AdmId)
 	//alert("ItemId"+ItemId)
 	//alert("ItemCT"+ItemCT)
 	//if (ItemCT=="1"){ if (!(confirm("���з��䣬�Ƿ�������?"))) {  return false; }}
 	
 	if (ItemSetId!="") {isetid=tkMakeServerCall("web.DHCPE.PreItemList","IsExistItems",AdmId,gAdmType,ItemSetId) }
 	if ("1"==isetid) {
	 	//alert("������������ײͣ����ܼ�����ӣ�"+(i+1)); 
	 	alert("������������ײͣ����ܼ�����ӣ�");
	 	return false;
	 	}
		
	//�Ƿ������ظ������Ŀ  1 ����  0 ������
	var encmeth=GetCtlValueById('txtIsExistItem',1);
	var flagret=cspRunServerMethod(encmeth,AdmId, gAdmType, ItemId, ItemSetId)
	var flagArr=flagret.split("^");
	var flag=flagArr[0];

	    if ("1"==flag) {
    	
    	  if (flagArr[1]=="1"){
    		if (!(confirm("��Ŀ���ײ��Ѵ���?�Ƿ�������?"+(i+1)))) { return false; }
    	}else{
			//alert("��Ŀ���ײ��Ѵ���,����������."+(i+1));
			 alert("��Ŀ���ײ��Ѵ���,����������.");
			return false;
    	}
    }else if("2"==flag){
	    alert("��Ŀ�еĻ�����Ŀ,��������Ŀ���ظ�,�Ƿ�������?"+(i+1))
	    return false;
		//if (!(confirm("��Ŀ�еĻ�����Ŀ,��������Ŀ���ظ�,�Ƿ�������?"+(i+1)))) { return false; }
	}else if('3'==flag){
		if(!(confirm("�����ڿƻ������ڿ�?�Ƿ�������?"+(i+1)))){return false;}
		}
	

    //�����ײ�ά���ķ������ͣ����Ƿ���·�������
    if (AddType=="Set")
    {
	    //AdmId,gAdmType,ItemSetId
	    var encmeth=GetCtlValueById('IsSameFeeType',1);
	    var ret=cspRunServerMethod(encmeth,AdmId, gAdmType, ItemSetId)
	    var Arr=ret.split("^");
	    if (Arr[0]=="0"){
		    if (confirm("�ײͷѱ������߷ѱ�һ��,�Ƿ���·ѱ�"+(i+1))) {
				var encmeth=GetCtlValueById('ChangeFeeType',1);
				var ret=cspRunServerMethod(encmeth,AdmId,gAdmType,Arr[1]);
				if (ret!=0){
					alert("��������߷��ô���"+(i+1));
					return false;
				}
			}
	    }
    }
    
	//�������������ǿ��
	var ItemFlag;
 	ItemFlag=tkMakeServerCall("web.DHCPE.PreItemList","ItemCanPreInfo",AdmId,gAdmType,ItemId)
 	//alert(ItemFlag)
	var ItemCanFlag=ItemFlag.split(",")
 	if (ItemCanFlag[0]==-1)
 	{
	 	if (!(confirm(ItemCanFlag[1])))
	 	{
		 	return false;
		} 
	}

    var flag=""
	var encmeth=GetCtlValueById('txtAddBox',1);
    var flag=cspRunServerMethod(encmeth,AdmId, gAdmType,gPreOrAdd,ItemId, ItemSetId,gUserId)
	if (flag=="Notice"){
		alert("�����,���˼�����ȡ�����!"+(i+1));
		return false;
	}
    if (flag!="") {
	   	alert(t['ErrSave']+":"+flag);
	   	return false;
    }
 	}
   	
   	var SelectType="ItemSet"
   	var obj=document.getElementById("CShowType_ItemSet");
   	if (obj&&obj.checked) SelectType="ItemSet"
   	var obj=document.getElementById("CShowType_Other");
   	if (obj&&obj.checked) SelectType="Other"
   	var obj=document.getElementById("CShowType_Medical");
   	if (obj&&obj.checked) SelectType="Medical"
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList&TargetFrame=PreItemList.Qry&AdmType="+gAdmType+"&AdmId="+AdmId+"&PreOrAdd="+gPreOrAdd+"&SelectType="+SelectType; //+"&ShowFlag=#(ShowFlag)#"
	//alert(lnk);
	window.location.href=lnk;
   	
}
// ���� ,δ��
function btnAdd_Click(){
	AddOrder();
}

/// AddType= "ITEM/ITEMSET"
/// ���Ӳ���?�ṩ����ҳ��
function IAdd(AddType, Id,AddAmount){
	//alert("IAdd:"+AddType+";"+Id+";"+AddAmount);	
	if (IsExec) { return false; } 
	else {
		IsExec=true;
		var obj=document.getElementById("btnShowItem");
		if (obj) { obj.disabled=true; }
		var obj=document.getElementById("btnShowItemSet");
		if (obj) { obj.disabled=true; }
	}
	var PreOrAdd=GetCtlValueById('txtPreOrAdd',1);
	
	var IADM=GetCtlValueById('txtAdmId',1);
	var obj=document.getElementById("GeneralAdviceAudited");
	if (obj) var Flag=obj.value;
	if (Flag=="1"){
		alert(t["GeneralAdviceAudited"]);
		IsExec=false;
		return false;
	}
	if (PreOrAdd=="ADD")
	{
		var encmeth=GetCtlValueById('IsOverLimit',1);
		var Flag=cspRunServerMethod(encmeth,IADM,AddAmount);
		Flag=Flag.split("^");
		if (Flag[0]=="1")
		{
			if (parent.frames['PreItemList.Qry2'].AlertFlag=="0")
			{
				if (!(confirm(t["03"])))
				{
					
					IsExec=false;
					return false;
				}
			}
			parent.frames['PreItemList.Qry2'].AlertFlag="1";
		}
	}
	
	SetCtlValueByID("txtItemId","",1);
	SetCtlValueByID("txtItemSetId","",1);
	if (AddType=="ITEM"){SetCtlValueByID("txtItemId",Id,1);}
	else {SetCtlValueByID("txtItemSetId",Id,1);}
	//if (""==AddType) { alert("AddType"+AddType) }
	var ret=AddOrder();
	{
		IsExec=false;
		var obj=document.getElementById("btnShowItem");
		if (obj) { obj.disabled=false; }
		var obj=document.getElementById("btnShowItemSet");
		if (obj) { obj.disabled=false; }
	}
	return ret;
}

// ////////////////////////////////////////////////////////////////////////
//orderType="ORDERENT/ORDERITEM"

function DeleteOrder(OrderType,AddAmountFlag){
 	
	var ordItemId=GetCtlValueById("TRowIdz"+gRowIndex);
	var ordEntId=GetCtlValueById("TOrderEntIdz"+gRowIndex);
	var isBreakable=GetCtlValueById("TIsBreakablez"+gRowIndex);
	
	if ((gRowIndex<=0)||(ordItemId=="")) {
		alert(t['NoSelected']);
		return false;
	}
	if ((OrderType=="ORDERITEM")&&(isBreakable=="N")&&(ordEntId!="")){
		alert(t['Unbreakable']);
		return false;
	}
	if ((OrderType=="ORDERENT")&&(ordEntId=="")){
		alert(t["NotASet"]);
		return false;
	}
	if (OrderType=="ORDERITEM") {ordEntId=""};
	if (OrderType=="ORDERENT") {ordItemId=""};
	//add by zl 20100624 ����������������ɾ����Ŀ���ײ�
    if (OrderType=="ORDERITEM") {ordEntIdNew=""};
	if (OrderType=="ORDERENT") {ordItemIdNew=""};
	var AdmIdStr=gAdmId.split("^");

    var Rows=AdmIdStr.length;
    for(i=0;i<Rows;i++)
 	{ 
 	   var AdmId=AdmIdStr[i]
 	   var encmeth=GetCtlValueById('GetARCIMbyOEOrd'); 
 	
		if (gAdmType=="PERSON"){
			   
			if (ordItemId!="")
			{   
				var ordItemIdNew=cspRunServerMethod(encmeth,AdmId,ordItemId,"Item");
				var ordEntIdNew="";
			}
			if (ordEntId!="")
			{
				var ordEntIdNew=cspRunServerMethod(encmeth,AdmId,ordEntId,"Ent");
				var ordItemIdNew="";
			}
		}
		else 
		{    
			ordItemIdNew=ordItemId;
			ordEntIdNew=ordEntId
		}

		var encmeth1=GetCtlValueById('txtDeleteBox',1); 
		//alert(AdmId+"^"+ordItemIdNew+"^"+ordEntIdNew)
		var flag=cspRunServerMethod(encmeth1,AdmId, gAdmType,ordItemIdNew,ordEntIdNew,AddAmountFlag)
		if ((flag==1)||(flag==2)||(flag==3)||(flag==4))
		{
			alert(t[flag]+";"+(i+1));
			return false;
		}
		else if(flag!="") {
			//alert(t['ErrSave']+"  "+flag+";"+(i+1));
			var fflag="";
			var fflag=flag.split("^")[0];
			if(fflag=="1"){var fflag="����Ŀ�ѽ���!";}
			if(fflag=="3"){var fflag="����Ŀ��ִ��!";}
			alert(t['ErrSave']+" "+fflag);

			return false;
		}
 	}
    window.location.reload();
	if (parent.frames("PreItemList.Qry")){
		//lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QrySet&TargetFrame=PreItemList&Type=ItemSet&AdmId="+Rets[1];
		parent.frames("PreItemList.Qry").location.reload();
	}
	if (parent.frames("PreItemList.Qry2")){
		//lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QryItm&TargetFrame=PreItemList&Type=Item&PreIADMID="+Rets[1];
		parent.frames("PreItemList.Qry2").location.reload();
	}
	if (parent.frames("PreItemList.Qry3")){
		//lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QryItm&TargetFrame=PreItemList&Type=Lab&PreIADMID="+Rets[1];
		parent.frames("PreItemList.Qry3").location.reload();
	}
	
	
}
   
   /*
   function DeleteOrder(OrderType,AddAmountFlag){
	var ordItemId=GetCtlValueById("TRowIdz"+gRowIndex);
	var ordEntId=GetCtlValueById("TOrderEntIdz"+gRowIndex);
	var isBreakable=GetCtlValueById("TIsBreakablez"+gRowIndex);
	
	if ((gRowIndex<=0)||(ordItemId=="")) {
		alert(t['NoSelected']);
		return false;
	}
	if ((OrderType=="ORDERITEM")&&(isBreakable=="N")&&(ordEntId!="")){
		alert(t['Unbreakable']);
		return false;
	}
	if ((OrderType=="ORDERENT")&&(ordEntId=="")){
		alert(t["NotASet"]);
		return false;
	}
	if (OrderType=="ORDERITEM") {ordEntId=""};
	if (OrderType=="ORDERENT") {ordItemId=""};
	
	var encmeth=GetCtlValueById('txtDeleteBox',1); 
	var flag=cspRunServerMethod(encmeth,gAdmId, gAdmType,ordItemId, ordEntId,AddAmountFlag)
    if ((flag==1)||(flag==2)||(flag==3)||(flag==4))
    {
	    alert(t[flag]);
	    return false;
    }
    else if(flag!="") {
	    alert(t['ErrSave']+"  "+flag);
	    return false;
    }
    alert("gAdmId1:"+gAdmId)
    location.reload();
}
*/      
function btnDeleteItem_click(){
	 var obj=document.getElementById("btnDeleteItem");
	 if (obj.disabled) return ;
	
	 DeleteOrder("ORDERITEM","0");
}
function btnDeleteItemAddAmount_click(){
	 var obj=document.getElementById("btnDeleteItemAddAmount");
	 if (obj.disabled) return ;
	 if (!confirm(t["DeleteAdd"])) return;
	 DeleteOrder("ORDERITEM","1");
}        
function btnDeleteSet_click(){

	var obj=document.getElementById("btnDeleteSet");
	if (obj.disabled) return ;
	DeleteOrder("ORDERENT");
}
function btnDeleteSetAddAmount_click(){

	var obj=document.getElementById("btnDeleteSetAddAmount");
	if (obj.disabled) return ;
	if (!confirm(t["DeleteAdd"])) return;
	DeleteOrder("ORDERENT","1");
}
function btnExit_Click(){
	//var encmeth=GetCtlValueById('CreatePrescNoBox'); 
	//alert(gAdmId);
	//var flag=cspRunServerMethod(encmeth,gAdmId)
	return false;
}

function ConfirmOrdItem_Click(){
	if (gAdmType=="PERSON")
	{
		var encmeth=GetCtlValueById('ConfirmOrdItemBox'); 
	}
	else if(gAdmType=="TEAM")
	{
		var encmeth=GetCtlValueById('ConfirmOrdItemGTBox'); 
	}
	var AdmIdStr=gAdmId.split("^");
    var Rows=AdmIdStr.length;
   for(i=0;i<Rows;i++)
 	{ 
 	var AdmId=AdmIdStr[i]
	var flag=cspRunServerMethod(encmeth,AdmId,gUserId)
 	}
 	
 	var val=tkMakeServerCall("web.DHCPE.PreItemList","GetConfirmInfoStatus",AdmId,gAdmType) 
 	if(val==""){
	 	    alert("����Ҫȷ�ϼ���");
	 	    //window.parent.opener.DHCPEPreIADMTeam_Load();
			try{
	 	    window.parent.opener.DHCPEPreIADMTeam_Load();
	 	    }catch(e){}

	 	    //window.parent.close();
			window.location.reload();
	 	    return false;
 		   }

	if ((flag=="")||(flag==0)){
		if (gAdmType=="PERSON"){
			OpenCharge();
		}
		alert(t['ConfirmSuccess']);
	}
	
	SendRequest();
	//window.parent.opener.DHCPEPreIADMTeam_Load();
	try{
	 	    window.parent.opener.DHCPEPreIADMTeam_Load();
	 	    }catch(e){}

	//window.parent.close();
	window.location.reload();

	return false;
}
// ////////////////////////////////////////////////////////////////////////

function btnRefresh_Click(){
	
	gIsGroup=GetCtlValueById("txtIsGroup",1)
	gAdmId=GetCtlValueById("txtAdmId",1)	
	gAdmType=(gIsGroup=="1"?"TEAM":"PERSON")
	//if (""==gAdmType) { alert("btnRefresh_Click"); }
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+gMyName +
			"&AdmId="+gAdmId +"&AdmType=" + gAdmType + 
			"&TargetFrame="+GetCtlValueById("TargetFrame",1);
			
	location.href=lnk;
}
// ////////////////////////////////////////////////////////////////////////

//���ø�ҳ��(ԤԼҳ��)��Ӧ�ս��
function SaveAmount() {
	
	try{
		if (parent && parent.opener) {
			var obj=document.getElementById("txtTotalAmount");		
			if (obj && ""!=obj.value) { parent.opener.SetAmount(obj.value); }
			}
	}
	catch(e){ return false;}
	return true;
}

function btnShow_Click()
{
	return false;
	if (parent.ItemType.value=="Item")
	{
		btnShowItem_Click()
	}
	if (parent.ItemType.value=="ItemSet")
	{
		btnShowItemSet_Click()
	}
	if (parent.ItemType.value=="Lab")
	{
		btnShowLab_Click()
	}
	if (parent.ItemType.value=="Other")
	{
		btnShowOther_Click()
	}
	if (parent.ItemType.value=="Medical")
	{
		btnShowMedical_Click()
	}
}
// ////////////////////////////////////////////////////////////////////////
function ShowType_Click() {
	var eSrc = window.event.srcElement;	//�����¼���
	obj=document.getElementById("CShowType_Item");
	if (obj) {
		if (obj.id==eSrc.id && obj.checked) {
		    parent.frames['GetItemType'].ItemType.value="Item";
			//parent.ItemType.value="Item";
			btnShowItem_Click();
		}
		else { obj.checked=false; }
		
	}
	
	// ��ʾ��Ŀ���б�
	obj=document.getElementById("CShowType_ItemSet");
	if (obj) {
		if (obj.id==eSrc.id && obj.checked) {
			parent.frames['GetItemType'].ItemType.value="ItemSet";
			//parent.ItemType.value="ItemSet";
			btnShowItemSet_Click();
		}
		else { obj.checked=false; }
		
	}
	//��ʾ������Ŀ
	obj=document.getElementById("CShowType_Lab");
	if (obj) {
		if (obj.id==eSrc.id && obj.checked) {
			parent.frames['GetItemType'].ItemType.value="Lab";
			//parent.ItemType.value="Lab";
			btnShowLab_Click();
		}
		else { obj.checked=false; }
		
	}
	//��ʾ������Ŀ
	obj=document.getElementById("CShowType_Other");
	if (obj) {
		if (obj.id==eSrc.id && obj.checked) {
			parent.frames['GetItemType'].ItemType.value="Other";
			//parent.ItemType.value="Other";
			btnShowOther_Click();
		}
		else { obj.checked=false; }
		
	}
	//��ʾҩƷ
	obj=document.getElementById("CShowType_Medical");
	if (obj) {
		if (obj.id==eSrc.id && obj.checked) {
			parent.frames['GetItemType'].ItemType.value="Medical";
			//parent.ItemType.value="Medical";
			btnShowMedical_Click();
		}
		else { obj.checked=false; }
		
	}
}

// ��ʾ��Ŀ�б�
function btnShowItem_Click(){
	//var queryDesc=GetCtlValueById("txtItemDesc",1)
	var queryDesc="";
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QryItm&Desc="+queryDesc+"&TargetFrame="+window.frameElement.name+"&Type=Item"  ;
    parent.frames[gTargetFrame].location.href=lnk;	
}
// ��ʾҽ�����б�
function btnShowItemSet_Click(){
	///var queryDesc=GetCtlValueById("txtItemSetDesc",1);
	var queryDesc="";
	var gAdmId=GetCtlValueById("txtAdmId",1)
	//var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QrySet&orderSetDesc="+queryDesc+"&TargetFrame="+window.frameElement.name+"&Type=ItemSet"  ;
     var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QrySet&orderSetDesc="+queryDesc+"&TargetFrame="+window.frameElement.name+"&Type=ItemSet"+"&AdmId="+gAdmId ;
    parent.frames[gTargetFrame].location.href=lnk;	
}
//��ʾ������Ŀ
function btnShowLab_Click(){
	///var queryDesc=GetCtlValueById("txtItemSetDesc",1);
	var queryDesc="";
	var TrakVerison=GetCtlValueById("TrakVerison",1);
	if (TrakVerison=="MedTrak")
	{
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QrySet&orderSetDesc="+queryDesc+"&TargetFrame="+window.frameElement.name+"&Type=Lab"  ;
	}
	else
	{
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QryItm&Desc="+queryDesc+"&TargetFrame="+window.frameElement.name+"&Type=Lab"  ;
	}
    parent.frames[gTargetFrame].location.href=lnk;	
}
//��ʾ������Ŀ
function btnShowOther_Click(){
	//var queryDesc=GetCtlValueById("txtItemDesc",1)
	var queryDesc="";
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QryItm&Desc="+queryDesc+"&TargetFrame="+window.frameElement.name+"&Type=Other"  ;
    parent.frames[gTargetFrame].location.href=lnk;	
}
//��ʾҩƷ
function btnShowMedical_Click(){
	//var queryDesc=GetCtlValueById("txtItemDesc",1)
	var queryDesc="";
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QryItm&Desc="+queryDesc+"&TargetFrame="+window.frameElement.name+"&Type=Medical"  ;
    parent.frames[gTargetFrame].location.href=lnk;	
}
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//�����¼���
	var objtbl=document.getElementById('t'+gMyName);	//ȡ���Ԫ��?����
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;
	var obj;
	var rowObj=getRow(eSrc);
	var Row=rowObj.rowIndex;
	obj=document.getElementById("btnDeleteItemAddAmount");
	if (obj) obj.disabled=true;
	obj=document.getElementById("btnDeleteSetAddAmount");
	if (obj) obj.disabled=true;
	obj=document.getElementById("btnDeleteItem");
	if (obj) obj.disabled=true;
	obj=document.getElementById("btnDeleteSet");
	if (obj) obj.disabled=true;
	//add by 20110905
	if (eSrc.id=="TInsuFlagz"+Row)
	{	
	
    var InsuFlag=""
	var obj=document.getElementById("TInsuFlagz"+Row);
	if (obj&&obj.checked){var InsuFlag="Y"}
	var obj=document.getElementById("TRowIdz"+Row);
	if (obj){var iRowId=obj.value}
	var obj=document.getElementById("TOrderEntIdz"+Row);
	if (obj){var iOrderEntId=obj.value}
	var obj=document.getElementById("TItemTypez"+Row);
	if (obj) var ItemType=obj.value;
	var encmeth=document.getElementById('SaveInsuFlag');
	if (encmeth) encmeth=encmeth.value;
	var flag=cspRunServerMethod(encmeth,iRowId,iOrderEntId,gAdmType,ItemType,InsuFlag);
	if (flag=="1")
	{
		alert("��Ŀ���ײ����շ�,�����޸�")
	location.reload();
		
	}
	}
	if (Row==gRowIndex)
	{
		gRowIndex=0
		
		return;
	}
	gRowIndex=Row
	if (gRowIndex==0) return;
	var obj=document.getElementById("TItemTypez"+gRowIndex);
	if (obj) var ItemType=obj.value;
	var obj=document.getElementById("TPreOrAddz"+gRowIndex);
	var PreOrAdd="ԤԼ"
	if (obj) PreOrAdd=obj.innerText;
	var sLable=document.getElementById('TItemStatz'+gRowIndex);
	var strCell=sLable.value;
	strCell=strCell.replace(" ","")
 
	if (strCell!='1')
	{
	obj=document.getElementById("TInsuFlagz"+gRowIndex);
	if (obj) obj.disabled=true; 
	return;}
	if (ItemType=="Item")
	{
		obj=document.getElementById("btnDeleteItem");
		if (obj) obj.disabled=false;
		obj=document.getElementById("btnDeleteItemAddAmount");
		if (obj&&PreOrAdd=="ԤԼ") obj.disabled=false;
		obj=document.getElementById("btnDeleteSet");
		if (obj) obj.disabled=true;
		obj=document.getElementById("btnDeleteSetAddAmount");
		if (obj) obj.disabled=true;
	}
	else
	{
		obj=document.getElementById("btnDeleteItem");
		if (obj) obj.disabled=true;
		obj=document.getElementById("btnDeleteItemAddAmount");
		if (obj) obj.disabled=true;
		obj=document.getElementById("btnDeleteSet");
		if (obj) obj.disabled=false;
		obj=document.getElementById("btnDeleteSetAddAmount");
		if (obj&&PreOrAdd=="ԤԼ") obj.disabled=false;
	}

}

// ���?��Ŀ?ѡ���б� 
function SelectedItem(value){
	var aiList=value.split("^");
	if (""==value){return false}
	var ItemId=aiList[2];
	var ItemDesc=aiList[1];
	var AddAmount=aiList[3];
	SetCtlValueByID("txtItemId",ItemId,1);
	SetCtlValueByID("txtItemDesc",ItemDesc,1);
	SetCtlValueByID("txtItemSetId","",1);
	SetCtlValueByID("txtItemSetDesc","",1);
	if (""==ItemId) { return ;}
	IAdd("ITEM",ItemId,AddAmount);
}

function SelectedItemSet(value){
	var aiList=value.split("^");
	if (""==value){return false;}
	var ItemSetId=aiList[0];
	var ItemSetDesc=aiList[1];
	var AddAmount=aiList[3];
	SetCtlValueByID("txtItemId","",1);
	SetCtlValueByID("txtItemDesc","",1);
	SetCtlValueByID("txtItemSetId",ItemSetId,1);
	SetCtlValueByID("txtItemSetDesc",ItemSetDesc,1);
	
	if (""==ItemSetId) { return ;}
	IAdd("ITEMSET",ItemSetId,AddAmount);

}
// ////////////////////////////////////////////////////////////////////////

function btnSaveFactAmount_onClick(){
	DAlert("entered btnSaveFactAmount_onClick");
	var factAmount=GetCtlValueById("txtFactAmount");
	var serveCode=GetCtlValueById("txtSaveFactAmountBox");
	factAmount=Val(factAmount);
	admType=(gAdmType="TEAM"?"GROUP":"PERSON");
	//if (""==gAdmType) { alert("btnRefresh_Click"); }
	admId=(gAdmType="TEAM"?Val(gAdmId):gAdmId);
    var flag=cspRunServerMethod(serveCode,admId, admType,factAmount)
    if (flag!="") {
	    alert(t['ErrSave']+"  "+flag);
	    return false;
    }
	
}

///�����б���Ŀ����
function ContractFactAmountEnabled()
{
	var objtbl=document.getElementById('tDHCPEPreItemList');
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	var i,obj,Data;
	
	for (i=1;i<rows;i++)
	{
		obj=document.getElementById("TModifiedFlagz"+i);
		if (obj) Data=obj.value;
		if (Data!="1")
		{
			obj=document.getElementById("TFactAmountz"+i);
			if (obj) obj.disabled=true;
		}
		var MedicalFlag="0";
		obj=document.getElementById("TIsMedicalz"+i);
		if (obj) MedicalFlag=obj.value;
		if ((MedicalFlag!="1"))
		{
			obj=document.getElementById("TQtyz"+i);
			if (obj) obj.disabled=true;
		}
	}
}
function BPreOverReg_click()
{  
   
   	var Src=window.event.srcElement;
	if (Src.disabled) { return false; }
	Register(2);
	
	
}
function BArrived_click()
{
  
   	var Src=window.event.srcElement;
	if (Src.disabled) { return false; }
	Register(3);
	
}
function Register(type)
{ 
	var encmeth=document.getElementById('GetDataBox');
	if (encmeth) encmeth=encmeth.value;
	obj=document.getElementById("txtAdmId");
	var iRowId="";
	if (obj && ""!=obj.value) { iRowId=obj.value; }
	if (iRowId=="") return;
	var ret=tkMakeServerCall("web.DHCPE.PreIADMEx","getReheckFlag",iRowId);
	Rows=GetTotalRows();
	if (Rows==0){
		alert("��ѡ����Ŀ��");
		return;
	}
	/*
	if (ret=="1")
	{
			alert("������˲�Ӧѡ�ײͣ�������ȥ������ѡ�");
			return;
	
	}
	if (ret=="2")
	{
		alert("�Ǹ������Ӧѡ�ײ�,�����빴ѡ����ѡ�");
		return;
	}
	*/
	//alert('s')
	//if (type==3){
	//	var ArrivedFlag=JudgeArrivedNum(iRowId);
	//	if (!ArrivedFlag) return false;
	//}
	var flag=cspRunServerMethod(encmeth,iRowId,type);
	if (flag!='0') {
    	alert(t['FailsTrans']+"  error="+flag);
    	return false
    }
    else {
	   if(type==2){alert("�Ǽǳɹ�")}
	    if (type==3){
		    var RoomDesc=tkMakeServerCall("web.DHCPE.RoomManager","GetAdmCurRoom",iRowId,"PRE")
			if (RoomDesc!=""){
				alert("�뵽"+RoomDesc+"����");
			}
	    }
		SendRequest();
		PrintAllApp(iRowId,"CRM");  //DHCPEPrintCommon.js
		try
		{
			OpenCharge();
			if (parent.frames["PreIADM.Edit"]){
				parent.frames["PreIADM.Edit"].Clear_click();
				return false;
			}
		}catch(e)
		{
		
		}
		if (parent.opener)
	    {
		    parent.close();
		    return true
	    }
    }

}
///����Ŀ�Żݵ�ʱ����½��
function UpdateOPAmount()
{  
    
	var objtbl=document.getElementById('tDHCPEPreItemList');	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	var i,obj,Data,MedicalFlag,CanChange;
	var ID,FactAmount,Strings="",AccountAmount,Qty="";
	for (i=1;i<rows;i++)
	{
		obj=document.getElementById("PrivilegeModeIDz"+i);
		if (obj) Data=obj.value;
		obj=document.getElementById("TIsMedicalz"+i);
		if (obj) MedicalFlag=obj.value;
		obj=document.getElementById("TModifiedFlagz"+i);
		if (obj) CanChange=obj.value;
		if ((CanChange=="1")||((Data=="OP")||(MedicalFlag=="1")))
		{
			obj=document.getElementById("TFactAmountz"+i);
			if (obj) FactAmount=obj.value;

			obj=document.getElementById("TRowIdz"+i);
			if (obj) ID=obj.value;
			///Modified by wrz 2009-01-06
			obj=document.getElementById("TAccountAmountz"+i);
			if (obj) AccountAmount=obj.value;
			
			obj=document.getElementById("TQtyz"+i);
			if (obj) Qty=obj.value;
			///Modified End
			
			if (Strings=="")
			{
				Strings=ID+","+FactAmount+","+Qty+","+AccountAmount
			}
			else
			{
				Strings=Strings+"^"+ID+","+FactAmount+","+Qty+","+AccountAmount
			}
		}
	}
	if (Strings=="") return false;
	obj=document.getElementById("UpdateAmount");
	if (obj){ var encmeth=obj.value;}
	else{return false;}
	var Flag=cspRunServerMethod(encmeth,Strings,gAdmType);
	if (Flag!=0)
	{
		alert(t["01"]);
		return false;
	}
	alert(t["02"]);
	
	location.reload();
}


function InsertItemByGBK()
{
	InsertItem("I");
}
function InsertItemByZKK()
{
	InsertItem("O");
}
function InsertItem(KType)
{
	var obj=document.getElementById("GeneralAdviceAudited");
	if (obj) var Flag=obj.value;
	if (Flag=="1"){
		alert(t["GeneralAdviceAudited"]);
		return false;
	}
	var encmeth=GetCtlValueById("InsertItemByCard");
	if (encmeth=="") return false;
	var Ret=cspRunServerMethod(encmeth,gAdmId,gAdmType,KType);
	if (Ret=="0")
	{
		window.location.reload();
		return false;
	}
	alert(Ret)
}
function BAddOtherFee_click()
{
	var obj=document.getElementById("AddOtherFee");
	var encmeth="";
	if (obj) encmeth=obj.value;
	if (encmeth=="") return;
	var ret=cspRunServerMethod(encmeth,gAdmId,gAdmType)
	if (ret!=""){
		alert(ret)
		return;
	}
	window.location.reload();
	return false;
}
/*
function onbeforeunload () //author:   meizz   
{   
  var n = window.event.screenX   -   window.screenLeft;   
  var   b   =   n   >   document.documentElement.scrollWidth-20;   
  if(b   &&   parent.event.clientY   <   0   ||   parent.event.altKey)   
  {   
 ??alert("bye   bye!");   //������������ҳ,   �����ж��Ƿ�Ϊˢ��   
 ?}   
}  */ 
function BDeleteSelect_click()
{
	var objtbl=document.getElementById('tDHCPEPreItemList');
	var FlagTotal=0
	if (objtbl) { var rows=objtbl.rows.length; }
	for (i=1;i<rows;i++)
	{
		var obj=document.getElementById("TSelectz"+i);
		if ((!obj)||(!obj.checked)) continue;
		var ordItemId=GetCtlValueById("TRowIdz"+i);
		var ordEntId=GetCtlValueById("TOrderEntIdz"+i);
		var isBreakable=GetCtlValueById("TIsBreakablez"+i);
		var OrderType="ORDERITEM";
		var AddAmountFlag="0";
		if (ordEntId!="")  OrderType="ORDERENT";
		if ((OrderType=="ORDERITEM")&&(isBreakable=="N")&&(ordEntId!="")){
			alert(t['Unbreakable']);
			return false;
		}
		if ((OrderType=="ORDERENT")&&(ordEntId=="")){
			alert(t["NotASet"]);
			return false;
		}
		if (OrderType=="ORDERITEM") {ordEntId=""};
		if (OrderType=="ORDERENT") {ordItemId=""};
		var GetItemEncmeth=GetCtlValueById('GetARCIMbyOEOrd');
		var encmeth=GetCtlValueById('txtDeleteBox',1); 
		if (gAdmType=="PERSON"){
			var AdmArr=gAdmId.split("^");
			var AdmLength=AdmArr.length;
			if (AdmLength>1){ //�ж��Ƿ���������
				for(j=0;j<AdmLength;j++){
					var OneAdm=AdmArr[j];
					if (ordItemId!="")
					{   
						var ordItemIdNew=cspRunServerMethod(GetItemEncmeth,OneAdm,ordItemId,"Item");
						var ordEntIdNew="";
					}
					if (ordEntId!="")
					{
						var ordEntIdNew=cspRunServerMethod(GetItemEncmeth,OneAdm,ordEntId,"Ent");
						var ordItemIdNew="";
					}
					var flag=cspRunServerMethod(encmeth,OneAdm, gAdmType,ordItemIdNew, ordEntIdNew,AddAmountFlag);
					FlagTotal=FlagTotal+flag;
				}
			}
			else{
				var flag=cspRunServerMethod(encmeth,gAdmId, gAdmType,ordItemId, ordEntId,AddAmountFlag);
			}
			
		}else{
			var flag=cspRunServerMethod(encmeth,gAdmId, gAdmType,ordItemId, ordEntId,AddAmountFlag);
		}
    	FlagTotal=FlagTotal+flag;
	}
	if (FlagTotal!=0)
	{
		alert("���ڲ���ɾ������Ŀ,��ɾ�����Ѿ�ɾ��")
	}
	window.location.reload();
	if (parent.frames("PreItemList.Qry")){
		//lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QrySet&TargetFrame=PreItemList&Type=ItemSet&AdmId="+Rets[1];
		parent.frames("PreItemList.Qry").location.reload();
	}
	if (parent.frames("PreItemList.Qry2")){
		//lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QryItm&TargetFrame=PreItemList&Type=Item&PreIADMID="+Rets[1];
		parent.frames("PreItemList.Qry2").location.reload();
	}
	if (parent.frames("PreItemList.Qry3")){
		//lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreItemList.QryItm&TargetFrame=PreItemList&Type=Lab&PreIADMID="+Rets[1];
		parent.frames("PreItemList.Qry3").location.reload();
	}
}
function unload()
{
	var encmeth=GetCtlValueById('CreatePrescNoBox'); 
	var flag=cspRunServerMethod(encmeth,gAdmId)
	return false;
}
function ChangeItemFeeType()
{  
	var obj=""
	var objtbl=document.getElementById('tDHCPEPreItemList');	
	if (objtbl) { var rows=objtbl.rows.length; }
	var lastrowindex=rows - 1;
	var obj,ItemFeeType="",OrdItemDR="",Strings="",ItemType="",AccountAmount="",Qty="",OrderEntDR="";

	for (i=1;i<rows;i++)
	{
	obj=document.getElementById("TRowIdz"+i);
	if (obj) OrdItemDR=obj.value;
	obj=document.getElementById("TItemFeeTypez"+i);
	if (obj) ItemFeeType=obj.value;
	obj=document.getElementById("TItemTypez"+i);
	if (obj) ItemType=obj.value;
	obj=document.getElementById("TAccountAmountz"+i);
	if (obj) AccountAmount=obj.value;
	obj=document.getElementById("TQtyz"+i);
	if (obj) Qty=obj.value;
    	obj=document.getElementById("TOrderEntIdz"+i);
	if (obj) OrderEntDR=obj.value;
	obj=document.getElementById('TItemStatz'+i);
	if (obj) 
	{ 
	if(obj.value!=1) continue;  
	}
	if (Strings=="")
	{
	Strings=OrdItemDR+","+gAdmType+","+ItemType+","+ItemFeeType+","+Qty+","+OrderEntDR
	}
	else
	{
	Strings=Strings+"^"+OrdItemDR+","+gAdmType+","+ItemType+","+ItemFeeType+","+Qty+","+OrderEntDR
	} 
	
	}
	obj=document.getElementById("UpdateItemFeeType");
	if (obj){ var encmeth=obj.value;}
	else{return false;}
	var Flag=cspRunServerMethod(encmeth,Strings);
  
	if (Flag!=0)
	{   alert(Flag)
		
	}

	location.reload();
}
function InitInsuFlag()
{

	var tbl=document.getElementById('tDHCPEPreItemList');	//ȡ���Ԫ��?����
	var row=tbl.rows.length;
	row=row-1;
	var obj;
	for (var j=1;j<row+1;j++)
	{

	var obj=document.getElementById('TItemStatz'+j);
	var ItemStat=obj.value;

	if (ItemStat!="1")
	{
	var obj=document.getElementById("TInsuFlagz"+j);
	if (obj){obj.disabled=true;}
	}
	
	}


}
function SelectALL_Click() 
{
	var Src=window.event.srcElement;
	
	var tbl=document.getElementById('tDHCPEPreItemList');	//ȡ���Ԫ��?����
	var row=tbl.rows.length;
	
	for (var iLLoop=1;iLLoop<=row;iLLoop++) {
		var obj=document.getElementById('TSelect'+'z'+iLLoop);
		if (obj) { obj.checked=Src.checked; }
	}
	
}

function Map() {
    this.elements = new Array();

    //��ȡMAPԪ�ظ���
    this.size = function() {
        return this.elements.length;
    };

    //�ж�MAP�Ƿ�Ϊ��
    this.isEmpty = function() {
        return (this.elements.length < 1);
    };

    //ɾ��MAP����Ԫ��
    this.clear = function() {
        this.elements = new Array();
    };

    //��MAP������Ԫ�أ�key, value)
    this.put = function(_key, _value) {
        this.elements.push( {
            key : _key,
            value : _value
        });
    };

    //ɾ��ָ��KEY��Ԫ�أ��ɹ�����True��ʧ�ܷ���False
    this.remove = function(_key) {
        var bln = false;
        try {
            for (i = 0; i < this.elements.length; i++) {
                if (this.elements[i].key == _key) {
                    this.elements.splice(i, 1);
                    return true;
                }
            }
        } catch (e) {
            bln = false;
        }
        return bln;
    };

    //��ȡָ��KEY��Ԫ��ֵVALUE��ʧ�ܷ���NULL
    this.get = function(_key) {
        try {
            for (i = 0; i < this.elements.length; i++) {
                if (this.elements[i].key == _key) {
                    return this.elements[i].value;
                }
            }
        } catch (e) {
            return null;
        }
    };

    //��ȡָ��������Ԫ�أ�ʹ��element.key��element.value��ȡKEY��VALUE����ʧ�ܷ���NULL
    this.element = function(_index) {
        if (_index < 0 || _index >= this.elements.length) {
            return null;
        }
        return this.elements[_index];
    };

    //�ж�MAP���Ƿ���ָ��KEY��Ԫ��
    this.containsKey = function(_key) {
        var bln = false;
        try {
            for (i = 0; i < this.elements.length; i++) {
                if (this.elements[i].key == _key) {
                    bln = true;
                }
            }
        } catch (e) {
            bln = false;
        }
        return bln;
    };

    //�ж�MAP���Ƿ���ָ��VALUE��Ԫ��
    this.containsValue = function(_value) {
        var bln = false;
        try {
            for (i = 0; i < this.elements.length; i++) {
                if (this.elements[i].value == _value) {
                    bln = true;
                }
            }
        } catch (e) {
            bln = false;
        }
        return bln;
    };

    //��ȡMAP������VALUE�����飨ARRAY��
    this.values = function() {
        var arr = new Array();
        for (i = 0; i < this.elements.length; i++) {
            arr.push(this.elements[i].value);
        }
        return arr;
    };

    //��ȡMAP������KEY�����飨ARRAY��
    this.keys = function() {
        var arr = new Array();
        for (i = 0; i < this.elements.length; i++) {
            arr.push(this.elements[i].key);
        }
        return arr;
    };
}
function CheckMoreAdm(AdmStr)
{
	if ((AdmStr.split("^").length)>1) return false;
	return true;
}

function CopyItem(PreIADMID)
{
	var obj=document.getElementById("txtAdmId");
	var CurID=""
	if (obj) CurID=obj.value;
	if (PreIADMID==CurID) return false;
	var tbl=document.getElementById('tDHCPEPreItemList');	//ȡ���Ԫ��?����
	var row=tbl.rows.length;
	for (var iLLoop=1;iLLoop<=row;iLLoop++) {
		var ItemID="",SetsID="";
		var obj=document.getElementById('TItemId'+'z'+iLLoop);
		if (obj) { ItemID=obj.value; }
		//var obj=document.getElementById('TOrderEntId'+'z'+iLLoop);
		//if (obj) { SetsID=obj.value; }
		var obj=document.getElementById('TItemSetId'+'z'+iLLoop);
		if (obj) { SetsID=obj.value; }
		//�����ײ�ʱ�������Ĭ��vip�ȼ��󶨵��ײͣ����ظ�����
		var OrdSet=tkMakeServerCall("web.DHCPE.PreIADM","IsExistDefaultOrdSet",PreIADMID);
        if((OrdSet==SetsID)&&(OrdSet!=""))continue;

		var encmeth=GetCtlValueById('txtAddBox',1);
		if ((ItemID=="")&&(SetsID=="")) continue;
    		var flag=cspRunServerMethod(encmeth,PreIADMID, gAdmType,gPreOrAdd,ItemID, SetsID,gUserId);
	}
	var flag=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","CopyOrdSet",CurID,PreIADMID);
}

document.body.onload = IniMe;
parent.document.body.onunload = unload;