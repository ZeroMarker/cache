var admType;
var preRegNo="";
var EpisodeID=document.getElementById("EpisodeID").value; //ypz 060726

function BodyLoadHandler()
{
	var objRegNo=document.getElementById("regNo");
	if (objRegNo) 
	{
		objRegNo.onblur=RegNoBlur;
	    if (EpisodeID!="")
	    {
		   var getRegNoFromAdm=document.getElementById("getRegNoFromAdm").value;
		   var retStr=cspRunServerMethod(getRegNoFromAdm,EpisodeID);
		   if (retStr!="")	{objRegNo.value=retStr;preRegNo=retStr;BasPatinfo(retStr)}
		   else {document.getElementById("EpisodeID").value="";EpisodeID=""}
	     }
	    var objSearch=document.getElementById("find");
	    if (objSearch) {objSearch.onclick=SearchClick;}
    }
	admType=document.getElementById("admType").value;
	var clearScreenObj=document.getElementById("clearScreen");
	if (clearScreenObj) {clearScreenObj.onclick=ClearScreen;}
	var fDate=document.getElementById("fromDate");
	//if (fDate) {fDate.onblur=Adjust_TDate;fDate.onchange=Adjust_TDate}
    var tDate=document.getElementById("toDate");
	//if (tDate) {tDate.onblur=Adjust_FDate;tDate.onchange=Adjust_FDate;}
    var GetDate=document.getElementById("getDate").value;
    var rets=cspRunServerMethod(GetDate);
    var tem=rets.split("^");
    if (fDate.value=="") fDate.value=tem[0];
    if (tDate.value=="") tDate.value=tem[1];
	var obj=document.getElementById('ReadCard');
	if (obj) obj.onclick=ReadCard_Click;

    var userId=session['LOGON.USERID'];
    loadCardType();
    CardTypeDefine_OnChange();
	var myobj=document.getElementById('CardTypeDefine');
	if (myobj){
		myobj.onchange=CardTypeDefine_OnChange;
		myobj.size=1;
		myobj.multiple=false;
	}
	//if (EpisodeID!="") {Search(true);}
    //alert("ok")
	//DHCP_GetXMLConfig("InvPrintEncrypt","AHHFOPCCardPayPrt");
	
	//alert("last")
}
function SearchClick()
{
	Search(true);
}

function Search(searchFlag)
{   	Find_click();

}
function GetEpisode(str)
{
	var obj=document.getElementById('EpisodeID');
	var tem=str.split("^");
	obj.value=tem[6];
	Find_click();
}
function RegNoKeyDown()
{
	if ((event.keyCode==13)||(event.keyCode==119)) RegNoBlur()
}
function RegNoBlur()
{
	var i;
    var obj=document.getElementById("patMainInfo");
    obj.value=""
    var objRegNo=document.getElementById("regNo");
    if (objRegNo.value==preRegNo) return;
	var isEmpty=(objRegNo.value=="");
    var oldLen=objRegNo.value.length;
	if (!isEmpty) {  //add 0 before regno
	    //for (i=0;i<8-oldLen;i++)
	    for (i=0;i<10-oldLen;i++)
	    {
	    	objRegNo.value="0"+objRegNo.value  
	    }
	}
    preRegNo=objRegNo.value;
   	BasPatinfo(objRegNo.value);
   	document.getElementById("CardNo").value="";
    document.getElementById("EpisodeID").value="";EpisodeID="";
   	//Search(true);
}

function BasPatinfo(regNo)
{//    s str=regno_"^"_$P(ctloc,"-",2)_"^"_$G(room)_"^"_$G(sex)_"^"_$G(patName)_"^"_$G(Bah)_"^"_$G(bedCode)_"^"_$G(age)_"^"_$G(WardDes)_"^"_homeaddres_"^"_hometel_"  "_worktel_"  "_handtel
   
	if (regNo=="") return;
 	var patinfo=document.getElementById("patinfo").value;
 	var str=cspRunServerMethod(patinfo,regNo);
   	if (str=="") return;
    var tem=str.split("^");

	var obj=document.getElementById("patMainInfo");
	obj.value=tem[4]+","+tem[3]+","+tem[7]    //+t['val:yearsOld'] 
}

function GetDate(dateStr)
{
	var tmpList=dateStr.split("/")
	if (tmpList<3) return 0;
	return tmpList[2]*1000+tmpList[1]*100+tmpList[0]
}
function Adjust_TDate()
{
	var fDate=document.getElementById("fromDate");
    var tDate=document.getElementById("toDate");
	//alert(fDate.value+" "+tDate.value)
	if (GetDate(fDate.value)>GetDate(tDate.value)) tDate.value=fDate.value ;
}
function Adjust_FDate()
{
	var fDate=document.getElementById("fromDate");
    var tDate=document.getElementById("toDate");
	if (GetDate(fDate.value)>GetDate(tDate.value)) fDate.value=tDate.value ;
}
function ClearScreen()
{
	document.getElementById("regNo").value="";
	document.getElementById("CardNo").value="";
	document.getElementById("EpisodeID").value="";
	document.getElementById("patMainInfo").value=""
	document.getElementById("fromDate").value=""
	document.getElementById("toDate").value=""
	document.getElementById("visitStat").value=""
	Search(false);
}
function GetVisitStat(str)
{	var obj=document.getElementById('visitStat');
	var tem=str.split("^");
	obj.value=tem[1];
}

function ReadCard_Click()
{
	//var CardTypeRowId=document.getElementById('CardTypeDefine').value;
	var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	var CardTypeRowId=myoptval.split("^")[0];//combo_CardType.getSelectedValue();
	//通过读卡按钮时调用函数需要这个
	var myrtn=DHCACC_GetAccInfo(CardTypeRowId,myoptval);
	//var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR);
	var myary=myrtn.split("^");
	var rtn=myary[0];
	var leftmon=myary[3];
	var RegNoObj=document.getElementById('regNo');
	switch (rtn){
		case "0": //卡有效
			var obj=document.getElementById("regNo");
			obj.value=myary[5];
			event.keyCode=13;
    		RegNoKeyDown(event);
			break;
		case "-200": //卡无效
			alert(t['alert:cardinvalid']);
            websys_setfocus('regNo');
			break;
		default:
	}
}
function loadCardType(){
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
	}
}
var m_CardNoLength=0;
var m_SelectCardTypeDR="";
var m_CCMRowID=""
function CardTypeDefine_OnChange()
{
	var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	
	var myary=myoptval.split("^");
	
	var myCardTypeDR=myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	m_CCMRowID=myary[14];
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
		//DHCWeb_DisBtnA("ReadCard");
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
			obj.onclick=ReadCard_Click;
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
function Doc_OnKeyDown(){
	if ((event.keyCode==119)){
		ReadCard_Click();
	}
}
document.onkeydown=Doc_OnKeyDown;
document.body.onload = BodyLoadHandler;