var ASARowId="",opId="",surgeonId="",assistantId="",scrubNurseId="",circulNurseId="",anaMethodId="",anaesthetistId="",theatreTransToId="",intExtId="",intAnTypeId="",intTermId="",intRouteId="",intVisionId=""
var anaSupervisorId="",anaLevelId="",anaAssistId="",fluidInfuseCatCode="",bloodTransCatCode=""
function BodyLoadHandler()
{   
    //var objtbl=document.getElementById('tDHCANOPStat');
    //var i;
    //var firstEsrc=objtbl.rows[1]
    //var lastEsrc=objtbl.rows[objtbl.rows.length-1];
    //var firstRowObj=getRow(firstEsrc);
   // firstRowObj.className="Temp";
    //var lastRowObj=getRow(lastEsrc);
    //lastEsrc.className="Immediate";
    var today=document.getElementById("getToday").value;
    var startDate=document.getElementById("startDate");
    if (startDate.value=="") {startDate.value=today;}
    var endDate=document.getElementById("endDate"); 
    if (endDate.value=="") {endDate.value=today;}
    var locDescObj=document.getElementById("locDesc")
    if(locDescObj)locDescObj.onkeydown=GetLocDesc;
    var sexObj=document.getElementById("sex");   
    if(sexObj) sexObj.onkeydown=GetSex;
    var ASAObj=document.getElementById("ASA");
    if(ASAObj) ASAObj.onkeydown=GetASA;
    var operNameObj=document.getElementById("operName");
    if(operNameObj) operNameObj.onkeydown=GetOperName;
    var surgeonObj=document.getElementById("surgeon");
    if(surgeonObj) surgeonObj.onkeydown=GetSurgeon;
    var assistantObj=document.getElementById("assistant");
    if(assistantObj) assistantObj.onkeydown=GetAssistant; 
    var scrubNurseObj=document.getElementById("scrubNurse");
    if(scrubNurseObj) scrubNurseObj.onkeydown=GetScrubNurse;
    var circulNurseObj=document.getElementById("circulNurse");
    if(circulNurseObj) circulNurseObj.onkeydown=GetCirculNurse;
    var anaMethodObj=document.getElementById("anaMethod");
    if(anaMethodObj) anaMethodObj.onkeydown=GetAnaMethod;
    var anaesthetistObj=document.getElementById("anaesthetist");
    if(anaesthetistObj) anaesthetistObj.onkeydown=GetAnaesthetist;
    var anaSupervisorObj=document.getElementById("anaSupervisor");
    if(anaSupervisorObj) anaSupervisorObj.onkeydown=GetAnaSupervisor;
    var anaLevelObj=document.getElementById("anaLevel");
    if(anaLevelObj) anaLevelObj.onkeydown=GetAnaLevel;
    var anaAssistObj=document.getElementById("anaAssist");
    if(anaAssistObj) anaAssistObj.onkeydown=GetAnaAssist;
    var guardianshipItemObj=document.getElementById("guardianshipItem")
    if(guardianshipItemObj) guardianshipItemObj.onkeydown=GetGuardianship
    var medicineObj=document.getElementById("medicine")
    if(medicineObj)medicineObj.onkeydown=GetMed
    var obj=document.getElementById("btnQuery");
    if (obj) {obj.onclick=btnQuery_Click;}
    var GetDocLoc=document.getElementById("GetDocLoc").value
   var obj=document.getElementById("bloodTransCatList");
   if(obj)obj.ondblclick=bloodTransCat_DubClick;
   var obj=document.getElementById("anaMethodList");
   if(obj)obj.ondblclick=anaMethod_DubClick;
   var obj=document.getElementById("guardianshipItemList");
   if(obj)obj.ondblclick=guardianshipItem_DubClick;
   var obj=document.getElementById("medicineList");
   if(obj)obj.ondblclick=medicine_DubClick;
   var obj=document.getElementById("viewCatList");
   if(obj)obj.ondblclick=viewCat_DubClick;
   //var obj=document.getElementById("theatreTransToList");
   //if(obj)obj.ondblclick=theatreTransTo_DubClick;
   var obj=document.getElementById("recoveryList");
   if(obj)obj.ondblclick=recovery_DubClick;
   var obj=document.getElementById("intExtList");
   if(obj)obj.ondblclick=intExt_DubClick;
   //var obj=document.getElementById("intAnTypeList");
   //if(obj)obj.ondblclick=intAnType_DubClick;
   //var obj=document.getElementById("intRouteList");
   //if(obj)obj.ondblclick=intRoute_DubClick;
   SetCombo("ageList",t['val:year']+"^"+t['val:month']+"^"+t['val:day']);
   SetCombo("opTimeList",t['val:hour']+"^"+t['val:minute']);
   SetCombo("anTimeList",t['val:hour']+"^"+t['val:minute']);
   //btnQuery_Click()
}
function btnQuery_Click()
{
var startDate=document.getElementById("startDate").value;
var endDate=document.getElementById("endDate").value;
var locDesc=document.getElementById("locDesc").value;
var anaSourceTypeObj=document.getElementById("anaSourceType");
if(anaSourceTypeObj)
{
 if(anaSourceTypeObj.checked==true){ var anaSourceType="E"}
 else anaSourceType="B"
}
var paadmTypeObj=document.getElementById("paadmType");
if(paadmTypeObj)
{
 if(paadmTypeObj.checked==true){ var paadmType="O"}
 else paadmType=""
}
var loc=document.getElementById("loc").value;
//var ifloc=document.getElementById("ifloc").value;
var sessloc=session['LOGON.CTLOCID'];
var UserId=session['LOGON.USERID'];
if (locDesc=="") loc="";
//var UserType="";
//var objGetUserType=document.getElementById("getUserType");
//if (objGetUserType) var UserType=cspRunServerMethod(objGetUserType.value,UserId); 
//var LogUserType=""; //lonon user type: ANDOCTOR,ANNURSE,OPNURSE
//var ret=cspRunServerMethod(ifloc,sessloc);
/*if ((ret!=1)&&(ret!=2)&&(locDesc==""))
{
	//alert(ret)
	//ward nurse:link location's operatoin apply
	//ward doctor: logon location's operatoin apply
	if (UserType=="NURSE") //+ wxl 090305
	{
		if(locDesc==""){
			var objGetLinkLocId=document.getElementById("getLinkLocId");
			if (objGetLinkLocId) var loc=cspRunServerMethod(objGetLinkLocId.value,sessloc);
			alert(loc)
		}
	}
	else {
		loc=sessloc;
	} 
}*/
var userLocId=session['LOGON.CTLOCID'];
var strUser=loc+"^"+userLocId+"^"+anaSourceType;
var fromAgeObj=document.getElementById("fromAge");
if(fromAgeObj)var fromAge=fromAgeObj.value;
else fromAge="";
var toAge=document.getElementById("toAge").value
var fromPatWeight=document.getElementById("fromPatWeight").value
var toPatWeight=document.getElementById("toPatWeight").value
var fromPatHeight=document.getElementById("fromPatHeight").value
var toPatHeight=document.getElementById("toPatHeight").value
var sex=document.getElementById("sex").value
var ageFlag=document.getElementById("ageList").value
var postOpCondIdStr=GetListData("postOpCondList")
var theatreTransTo=document.getElementById("theatreTransTo").value;
if(theatreTransTo=="")theatreTransToId="";
var recoveryIdStr=GetListData("recoveryList");
var intExtIdStr=GetListData("intExtList");
var intAnType=document.getElementById("intAnType").value;
if(intAnType=="")intAnTypeId="";
var intRoute=document.getElementById("intRoute").value;
if(intRoute=="")intRouteId="";
var intTerm=document.getElementById("intTerm").value;
if(intTerm=="")intTermId="";
var intVision=document.getElementById("intVision").value;
if(intVision=="")intVisionId="";
var strPat=fromAge+"^"+toAge+"^"+sex+"^"+ASARowId+"^"+paadmType+"^"+fromPatWeight+"^"+toPatWeight+"^"+fromPatHeight+"^"+toPatHeight+"^"+ageFlag+"^"+theatreTransToId+"^"+recoveryIdStr+"^"+intExtIdStr+"^"+intAnTypeId+"^"+intRouteId+"^"+intTermId+"^"+intVisionId
//var operName=document.getElementById("operName").value;
var fromOperTime=document.getElementById("fromOperTime").value;
var toOperTime=document.getElementById("toOperTime").value;
var operName=document.getElementById("operName").value;
if(operName=="")opId=""
var surgeon=document.getElementById("surgeon").value;
if(surgeon=="")surgeonId=""
var operDocIdStr=GetListData("operDocList")
//var assistant=document.getElementById("assistant").value;
//if(assistant=="")assistantId=""
var scrubNurse=document.getElementById("scrubNurse").value;
if(scrubNurse=="")scrubNurseId=""
var circulNurse=document.getElementById("circulNurse").value;
if(circulNurse=="")circulNurseId=""
var opTimeFlag=document.getElementById("opTimeList").value
var strOp=opId+"^"+fromOperTime+"^"+toOperTime+"^"+surgeonId+"^"+assistantId+"^"+scrubNurseId+"^"+circulNurseId+"^"+opTimeFlag+"^"+operDocIdStr
var obj=document.getElementById('anaMethodList')
if(obj.length>0)
{for(i=0;i<obj.length;i++)anaMethodId=anaMethodId+obj.options[i].value+"|"}
var fromAnaTime=document.getElementById('fromAnaTime').value;
var toAnaTime=document.getElementById('toAnaTime').value;
var anaesthetist=document.getElementById('anaesthetist').value;
if(anaesthetist=="")anaesthetistId="";
var anaDocIdStr=GetListData("anaDocList")
//var anaSupervisor=document.getElementById('anaSupervisor').value;
//if(anaSupervisor=="")anaSupervisorId=""
var anaLevel=document.getElementById('anaLevel').value;
if(anaLevel=="")anaLevelId=""
//var anaAssist=document.getElementById('anaAssist').value;
//if(anaAssist=="")anaAssistId=""
var anTimeFlag=document.getElementById("anTimeList").value
var strAna=anaMethodId+"^"+fromAnaTime+"^"+toAnaTime+"^"+anaesthetistId+"^"+anaSupervisorId+"^"+anaLevelId+"^"+anaAssistId+"^"+anTimeFlag+"^"+anaDocIdStr
var fluidInfuseCat=document.getElementById('fluidInfuseCat').value;
if(fluidInfuseCat=="")fluidInfuseCatCode=""
var obj=document.getElementById('bloodTransCatList');
if(obj.length>0)
{for(i=0;i<obj.length;i++)bloodTransCatCode=bloodTransCatCode+obj.options[i].value+"|"}
var fromUrineAmount=document.getElementById('fromUrineAmount').value;
var toUrineAmount=document.getElementById('toUrineAmount').value;
var fromBloodLoss=document.getElementById('fromBloodLoss').value;
var toBloodLoss=document.getElementById('toBloodLoss').value;
var strIO=fluidInfuseCatCode+"^"+bloodTransCatCode+"^"+fromUrineAmount+"^"+toUrineAmount+"^"+fromBloodLoss+"^"+toBloodLoss
var guardianshipItemStr=GetListData("guardianshipItemList")
var medicineStr=GetListData("medicineList")
var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPStatDetails&startDate="+startDate+"&endDate="+endDate+"&strUser="+strUser+"&strPat="+strPat+"&strOp="+strOp+"&strAna="+strAna+"&strIO="+strIO+"&guardianshipItemStr="+guardianshipItemStr+"&medicineStr="+medicineStr
//window.location.href=lnk;
parent.frames['anopbottom'].location.href=lnk 
}
function bloodTransCat_DubClick()
{
  List_DublClick("bloodTransCatList")
}
function anaMethod_DubClick()
{
  List_DublClick("anaMethodList")
}
function guardianshipItem_DubClick()
{
  List_DublClick("guardianshipItemList")
}
function medicine_DubClick()
{
  List_DublClick("medicineList")
}
function viewCat_DubClick()
{
  List_DublClick("viewCatList")
  var obj=document.getElementById("viewCat")
  if(obj)obj.value=""
}
function theatreTransTo_DubClick()
{
  List_DublClick("theatreTransToList")
  var obj=document.getElementById("theatreTransTo")
  if(obj)obj.value=""
}  
function recovery_DubClick()
{
  List_DublClick("recoveryList")
  var obj=document.getElementById("recovery")
  if(obj)obj.value=""
}   
function intExt_DubClick()
{
  List_DublClick("intExtList")
  var obj=document.getElementById("intExt")
  if(obj)obj.value=""
}   
function intAnType_DubClick()
{
  List_DublClick("intAnTypeList")
  var obj=document.getElementById("intAnType")
  if(obj)obj.value=""
} 
function getLoc(str)
{
	var loc=str.split("^");
	//alert(loc)
	var obj=document.getElementById("loc")
	if (obj) obj.value=loc[0];
	obj=document.getElementById("locDesc");
	if (obj) obj.value=loc[1];
}
function getASA(str)
{  
	var ret=str.split("^");
	ASARowId=ret[0];
	var obj=document.getElementById("ASA")
	obj.value=ret[1];
}
function getOper(str)
{  
	var ret=str.split("^");
	opId=ret[1];
}
function getOperDoc(str)
{  
  var obj=document.getElementById('operDoc')
  obj.value=""
  AddListRowBySecond("operDocList",str)
}
function getSurgeon(str)
{  
    var ret=str.split("^");
	surgeonId=ret[0];
	var obj=document.getElementById("surgeon")
	obj.value=ret[1];
}
function getAssistant(str)
{  
	var ret=str.split("^");
	assistantId=ret[0];
	var obj=document.getElementById("assistant")
	obj.value=ret[1];
}
function getScrub(str)
{  
	var ret=str.split("^");
	scrubNurseId=ret[0];
	var obj=document.getElementById("scrubNurse")
	obj.value=ret[1];
}
function getCircul(str)
{  
	var ret=str.split("^");
	circulNurseId=ret[0];
	var obj=document.getElementById("circulNurse")
	obj.value=ret[1];
}
function getAnaMthod(str)
{  
 var obj=document.getElementById('anaMethod')
 obj.value=""
 AddListRowByFirst("anaMethodList",str)
}
function getPostOpCond(str)
{  
 var obj=document.getElementById('postOpCond')
 obj.value=""
 AddListRowBySecond("postOpCondList",str)
}
function getTheatreTransTo(str)
{  
 var ret=str.split("^");
	theatreTransToId=ret[0];
	var obj=document.getElementById("theatreTransTo")
	obj.value=ret[1];
}
function getRecovery(str)
{  
 var obj=document.getElementById('recovery')
 obj.value=""
 AddListRowBySecond("recoveryList",str)
}
function getIntExt(str)
{  
    var obj=document.getElementById('intExt')
 obj.value=""
 AddListRowBySecond("intExtList",str)
}
function getIntAnType(str)
{  
    var ret=str.split("^");
	intAnTypeId=ret[0];
	var obj=document.getElementById("intAnType")
	obj.value=ret[1];
}  
function getIntTerm(str)
{  
 var ret=str.split("^");
	intTermId=ret[0];
	var obj=document.getElementById("intTerm")
	obj.value=ret[1];
}   
function getIntRoute(str)
{  
var ret=str.split("^");
	intRouteId=ret[0];
	var obj=document.getElementById("intRoute")
	obj.value=ret[1];
}    
function getIntVision(str)
{  
var ret=str.split("^");
	intVisionId=ret[0];
	var obj=document.getElementById("intVision")
	obj.value=ret[1];
} 
function GetGuardianshipItem(str)
{  
 var obj=document.getElementById('guardianshipItem')
 obj.value=""
 AddListRowBySecond("guardianshipItemList",str)
}
function GetViewCat(str)
{  
 var obj=document.getElementById('viewCat')
 AddListRowBySecond("viewCatList",str)
}
function GetMedicine(str)
{  
 var obj=document.getElementById('medicine')
 obj.value=""
 AddListRowBySecond("medicineList",str)
}

function getAnaesthetist(str)
{  
   var ret=str.split("^");
	anaesthetistId=ret[0];
	var obj=document.getElementById("anaesthetist")
	obj.value=ret[1];
}
function getAnaDoc(str)
{  
 var obj=document.getElementById('anaDoc')
 obj.value=""
 AddListRowBySecond("anaDocList",str)
}
function getAnaSupervisor(str)
{  
	var ret=str.split("^");
	anaSupervisorId=ret[0];
	var obj=document.getElementById("anaSupervisor")
	obj.value=ret[1];
}
function getAnaLevel(str)
{  
	var ret=str.split("^");
	anaLevelId=ret[0];
	var obj=document.getElementById("anaLevel")
	obj.value=ret[1];
}
function getAnaAssist(str)
{  
	var ret=str.split("^");
	anaAssistId=ret[0];
	var obj=document.getElementById("anaAssist")
	obj.value=ret[1];
}
function getFluidInfuseCat(str)
{  
	var ret=str.split("^");
	fluidInfuseCatCode=ret[0];
	var obj=document.getElementById("fluidInfuseCat")
	obj.value=ret[1];
}
function getBloodTransCat(str)
{  
	var obj=document.getElementById("bloodTransCat")
	obj.value="";
	AddListRowBySecond("bloodTransCatList",str)
}
function GetLocDesc()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		locDesc_lookuphandler();
	}
}

function GetSex()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		sex_lookuphandler();
	}
}
function GetASA()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		ASA_lookuphandler();
	}
}
function GetOperStat()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		operStat_lookuphandler();
	}
}
function GetOperName()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		operName_lookuphandler();
	}
}
function GetSurgeon()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		surgeon_lookuphandler();
	}
}   
function GetAssistant()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		assistant_lookuphandler();
	}
} 
function GetScrubNurse()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		scrubNurse_lookuphandler();
	}
}   
function GetCirculNurse()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		circulNurse_lookuphandler();
	}
} 
function GetAnaMethod()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		anaMethod_lookuphandler();
	}
}   
function GetAnaesthetist()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		anaesthetist_lookuphandler();
	}
}  
function GetAnaSupervisor()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		anaSupervisor_lookuphandler();
	}
}  
function GetAnaLevel()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		anaLevel_lookuphandler();
	}
} 
function GetAnaAssist()
{
	if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		anaAssist_lookuphandler();
	}
}
function GetGuardianship()
{
if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		guardianshipItem_lookuphandler();
	}
}  
function GetMed()
{
if(window.event.keyCode==13)
	{
		window.event.keyCode=117;
		medicine_lookuphandler();
	}
} 
function AddListRowByFirst(elementName,dataValue)
{
 var valueList=dataValue.split("^");
 var obj=document.getElementById(elementName)
 if((obj)&&(valueList.length>1))
 {
  var addListValue=new Option(valueList[0],valueList[1])
  obj.options[obj.options.length]=addListValue
 }
}
function AddListRowBySecond(elementName,dataValue)
{
 var valueList=dataValue.split("^");
 var obj=document.getElementById(elementName)
 if((obj)&&(valueList.length>1))
 {
  var addListValue=new Option(valueList[1],valueList[0])
  obj.options[obj.options.length]=addListValue
 }
 }
function GetListData(elementName)
{   
	var retString
	retString=""
	var objList=document.getElementById(elementName);
	if(objList){
		for (var i=0;i<objList.options.length;i++)
	   	{
		   if (objList.options[i].value!="")
		   {
			   if(retString==""){
				   retString=objList.options[i].value
			   }
			   else if((elementName=="medicineList")||(elementName=="guardianshipItemList")){retString=retString+"*"+objList.options[i].value;}
			   else{retString=retString+"|"+objList.options[i].value;}
		   }
		}
	}
	return retString
}
function List_DublClick(elementName)
{
	var objList=document.getElementById(elementName);
	var objSelected=objList.selectedIndex;
	objList.remove(objSelected);
}

function SetCombo(elementName,dataValue)
{
	var objList=document.getElementById(elementName);
	var listData=dataValue.split("^");
	if (objList)
	{
	    for (var i=0;i<listData.length;i++)
			{
			if (listData[i]!="")
			{
				var listRowItem=listData[i].split("!");
				var sel=new Option(listRowItem[0],listRowItem[1]);
				objList.options[objList.options.length]=sel;
			}
			}
		objList.size=1; 
		objList.multiple=false;
		objList.options[0].selected=true;
    }
}
          
document.body.onload = BodyLoadHandler;
