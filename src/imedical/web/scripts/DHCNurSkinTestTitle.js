//DHCNurSkinTestTitle.js
var preRegNo="",tableRows=1,curAdmId,curPapmiId;
var admType=document.getElementById("admType").value;
var EpisodeID=document.getElementById("EpisodeID").value;
var regNoLength=8;
var objGetPatConfig=document.getElementById("GetPatConfig");
if (objGetPatConfig)
{
	var patConfig=cspRunServerMethod(objGetPatConfig.value);
	var tmpList=patConfig.split("^");
	if (tmpList[0]>8) regNoLength=tmpList[0];
}
function BodyLoadHandler()
{
	var objRegNo=document.getElementById("regNo");
	if (objRegNo) {
	    objRegNo.onkeydown=RegNoKeyDown;//objRegNo.onblur=RegNoBlur;
		if (EpisodeID!="")
		{   
			var getRegNoFromAdm=document.getElementById("getRegNoFromAdm").value;
			var retStr=cspRunServerMethod(getRegNoFromAdm,EpisodeID);
			if (retStr!="")	{objRegNo.value=retStr;preRegNo=retStr}
			else {document.getElementById("EpisodeID").value="";EpisodeID=""}
		}
	}
	var objSearch=document.getElementById("SearCH");
	if (objSearch) {objSearch.onclick=SearchClick;}
	var clearScreenObj=document.getElementById("clearScreen");
	if (clearScreenObj) {clearScreenObj.onclick=ClearScreen;}
    var readcard=document.getElementById("readcard");
    if (readcard) {readcard.onclick=FunReadCard;}
	var obj=document.getElementById('ReadCard');
    if (obj) obj.onclick=ReadCard_Click;	
    var obj=document.getElementById("CardNo");
	if (obj){
		if (obj.type!="Hiden"){
			obj.onkeydown=CardNo_KeyDown;
		}
	}
	loadCardType();
	CardTypeDefine_OnChange();	
	var myobj=document.getElementById('CardTypeDefine');
	if (myobj){
		myobj.onchange=CardTypeDefine_OnChange;
		myobj.size=1;
		myobj.multiple=false;
	}
	if (EpisodeID!="") {Search(true);}
}

function SearchClick()
{
	RegNoBlur(true);
}

function Search(searchFlag)
{    
	//wardId_","_regNo_","_userId_","_startDate_","_endDate_","_queryTypeCode_","_gap_","_locId_","_admType_","_exeFlag_","_HospitalRowId
	var wardId="";
    var regNo=document.getElementById("regNo").value;
    if (regNo!="") BasPatinfo(regNo);
	//if (EpisodeID!="") regNo=regNo+"^"+EpisodeID;
    var userId=session['LOGON.USERID'];
    var stdate=document.getElementById("startDate").value;
    var edate=document.getElementById("endDate").value;
    var queryTypeCode="PSDO";
    var HospitalRowId="0";
    var gap="";
	var locId=document.getElementById("locId").value;
    var Dept=document.getElementById("Dept").value;
    if (Dept=="")   {locId="";}
    //admType="OE";
   	var exeFlag;
    var ExeCheck=document.getElementById("exeFlag").checked;
    if (ExeCheck==false) {exeFlag=0;}
    else{ exeFlag=1;} 
    //alert("&wardId="+wardId+"&regNo="+regNo+"&userId="+userId+"&startDate="+stdate+"&endDate="+edate+"&queryTypeCode="+queryTypeCode+"&gap="+gap+"&locId="+locId+"&admType="+admType+"&exeFlag="+exeFlag+"&HospitalRowId="+HospitalRowId)
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurSkinTestOrder"+"&wardId="+wardId+"&regNo="+regNo+"&userId="+userId+"&startDate="+stdate+"&endDate="+edate+"&queryTypeCode="+queryTypeCode+"&gap="+gap+"&locId="+locId+"&admType="+admType+"&exeFlag="+exeFlag+"&HospitalRowId="+HospitalRowId;
    parent.frames['NurseBottom'].location.href=lnk;
}
function getloc(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("locId");
	if (obj) obj.value=loc[1];
}
function RegNoKeyDown()
{    
	if ((event.keyCode==13)||(event.keyCode==9)) { RegNoBlur(false) };
}

function RegNoBlur(queryFlag)
{  
	var i;
    var objRegNo=document.getElementById("regNo");
    if ((objRegNo.value==preRegNo)&&(queryFlag==false)) return;
    var obj=document.getElementById("patMainInfo");
    if (obj) obj.value=""
	var isEmpty=(objRegNo.value=="");
    var oldLen=objRegNo.value.length;    
	if (!isEmpty) {
	    for (i=0;i<regNoLength-oldLen;i++)
	    {
	    	objRegNo.value="0"+objRegNo.value;
	    }
	}	
    preRegNo=objRegNo.value;
   	BasPatinfo(objRegNo.value);
   	//document.getElementById("CardNo").value="";
   	//DHCWeb_setfocus("CardNo");
    document.getElementById("EpisodeID").value="";
    EpisodeID="";
   	Search(true);
}

function FunReadCard()
{
	
    var myCardTypeValue=DHCWeb_GetListBoxValue("CardTypeDefine");
	if (m_SelectCardTypeDR==""){
		var myrtn=DHCACC_GetAccInfo();
	}else{
		var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR,myCardTypeValue);
	}
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0":
			///rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			document.getElementById("EpisodeID").value="";EpisodeID="";
			var obj=document.getElementById("regNo");
			obj.value=myary[5];
			var obj=document.getElementById("CardNo");
			obj.value=myary[1];
			if (myary[5]!=""){
				BasPatinfo(myary[5]);
			}
			break;
		case "-200":
			alert(t["alert:cardinvalid"]);
			break;
		case "-201":alert(t["alert:cardvaliderr"]);
		default:
	}
}
function BasPatinfo(regNo)
{
	if (regNo=="") return;
 	var patinfo=document.getElementById("patinfo").value;
 	var str=cspRunServerMethod(patinfo,regNo);
	var obj=document.getElementById("patMainInfo");
   	obj.value="";
   	if (str=="") return;
    var tem=str.split("^");
	obj.value=tem[4]+","+tem[3]+","+tem[7];

obj.value=tem[4]+","+tem[3]+","+tem[7]+","+tem[25]+","+tem[26];
}

function ClearScreen()
{
	document.getElementById("regNo").value="";
	document.getElementById("CardNo").value="";
	document.getElementById("patMainInfo").value="";
	document.getElementById("Dept").value="";
	document.getElementById("locId").value="";
	preRegNo="";
	Search(false);
	DHCWeb_setfocus("CardNo");
	//DHCWeb_setfocus("readcard"); //websys_setfocus("regNo");
}

function ReadCard_Click()
{
	var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR);
	var myary=myrtn.split("^");
	var rtn=myary[0];
	var leftmon=myary[3];
	var RegNoObj=document.getElementById('regNo');
	switch (rtn){
		case "0": //卡有效
			var obj=document.getElementById("regNo");
			obj.value=myary[5];
			var obj=document.getElementById("CardNo");
			obj.value=myary[1];
			event.keyCode=13;
    		RegNoKeyDown(event);
			break;
		case "-200": //卡无效
			alert(t['alert:cardinvalid']);
            //websys_setfocus('regNo');
			break;
		case "-201":   //卡有效,账户无效
			var obj=document.getElementById("regNo");
			obj.value=myary[5];
		
			var obj=document.getElementById("CardNo");
			obj.value=myary[1];
			event.keyCode=13;
    		RegNoKeyDown(event);
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
	//Read Card Mode
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = false;
		}
	}
	else
	{
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			//myobj.readOnly = true;
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
	//F8
	if ((event.keyCode==119)){
		ReadCard_Click();
	}
}
function CardNo_KeyDown(e){
	var key = websys_getKey(e);
	if ((key==13)){
		SetCardNOLength();
		var myCardNo=DHCWebD_GetObjValue("CardNo");
		var mySecurityNo=""
		var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardNo, mySecurityNo, "PatInfo");
		
		var myary=myrtn.split("^");
		
		if ((myary[0]=="0")||(myary[0]=="-201")){
			var myPAPMNo=myary[5];
			var RegNoObj=document.getElementById('regNo');
			if (RegNoObj) RegNoObj.value=myPAPMNo
			document.getElementById("EpisodeID").value="";
			EpisodeID="";
			//Search(true);
			RegNoBlur(true);
		}else{
			alert("Not Validate Card No");
		}
		
	}
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
document.onkeydown=Doc_OnKeyDown;
document.body.onload = BodyLoadHandler;