var admType;
var preRegNo="";
var EpisodeID=document.getElementById("EpisodeID").value; //ypz 060726

function BodyLoadHandler()
{
	var objRegNo=document.getElementById("regNo");
	if (objRegNo) {objRegNo.onblur=RegNoBlur;
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
	var fDate=document.getElementById("fDate");
	if (fDate) {fDate.onblur=Adjust_TDate;fDate.onchange=Adjust_TDate}
    var tDate=document.getElementById("tDate");
	if (tDate) {tDate.onblur=Adjust_FDate;tDate.onchange=Adjust_FDate;}
    var GetDate=document.getElementById("GetDate").value;
    var rets=cspRunServerMethod(GetDate);
    var tem=rets.split("^");
    if (fDate.value=="") fDate.value=tem[0];
    if (tDate.value=="") tDate.value=tem[1];
    var readcard=document.getElementById("readcard");
    //alert("start")
    if (readcard) {readcard.onclick=FunReadCard;}

    var userId=session['LOGON.USERID'];
    
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
{
    Find_click();
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
	if (event.keyCode==13) RegNoBlur()
}
function RegNoBlur()
{
	var i;
    var obj=document.getElementById("patMainInfo");
    if (obj) obj.value=""
    var objRegNo=document.getElementById("regNo");
    if (objRegNo.value==preRegNo) return;
	var isEmpty=(objRegNo.value=="");
    var oldLen=objRegNo.value.length;
	if (!isEmpty) {  //add 0 before regno
	    for (i=0;i<8-oldLen;i++)
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

function FunReadCard()
{
    var myrtn=DHCACC_GetAccInfo();
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0":
			///rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			document.getElementById("EpisodeID").value="";EpisodeID=""
			var obj=document.getElementById("regNo");
			obj.value=myary[5];
			var obj=document.getElementById("CardNo");
			obj.value=myary[1];
			if (myary[5]!=""){
				BasPatinfo(myary[5]);
				ReLoadOPFoot("Bill","","");  //only read pat base info,no fee
			}
			break;
		case "-200":
			alert(t["alert:cardinvalid"]);
			break;
		case "-201":alert(t["alert:cardvaliderr"])
		default:
	}
}
function BasPatinfo(regNo)
{
	if (regNo=="") return;
 	var patinfo=document.getElementById("patinfo").value;
 	var str=cspRunServerMethod(patinfo,regNo);
   	if (str=="") return;
    var tem=str.split("^");

	var obj=document.getElementById("patMainInfo");
	if (obj) obj.value=tem[4]+","+tem[3]+","+tem[7] 
}

function GetDate(dateStr)
{
	var tmpList=dateStr.split("/")
	if (tmpList<3) return 0;
	return tmpList[2]*1000+tmpList[1]*100+tmpList[0]
}
function Adjust_TDate()
{
	var fDate=document.getElementById("fDate");
    var tDate=document.getElementById("tDate");
	//alert(fDate.value+" "+tDate.value)
	if (GetDate(fDate.value)>GetDate(tDate.value)) tDate.value=fDate.value ;
}
function Adjust_FDate()
{
	var fDate=document.getElementById("fDate");
    var tDate=document.getElementById("tDate");
	if (GetDate(fDate.value)>GetDate(tDate.value)) fDate.value=tDate.value ;
}
function ClearScreen()
{
	document.getElementById("regNo").value="";
	document.getElementById("CardNo").value="";
	document.getElementById("EpisodeID").value="";
	document.getElementById("patMainInfo").value=""
	document.getElementById("fDate").value=""
	document.getElementById("tDate").value=""
	document.getElementById("visitStat").value=""
	Search(false);
}
function GetLoc(str)
{
	var tem=str.split("^");
	var obj=document.getElementById('locId');
	if ((obj)&&(tem[1]))
	{ 
		obj.value=tem[1];
		obj=document.getElementById('ctcpId');
		if (obj) obj.value="";
		obj=document.getElementById('ctcpDesc');
		if (obj) obj.value="";
	}
}
function GetCtcp(str)
{
	var tem=str.split("^");
	var obj=document.getElementById('ctcpId');
	if ((obj)&&(tem[1])) obj.value=tem[1];
}

document.body.onload = BodyLoadHandler;