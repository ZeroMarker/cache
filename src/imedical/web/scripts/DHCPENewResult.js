//DHCPENewResult.js
var CurObj;
var CurID;
var EDDesc="";
var CloseODSDivFlag="1";

document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	SetRoomInfo();
	try{
		//alert('a')
		//alert('b')
		SetRoomInfo();
		CreateRoomRecordList();
		//alert('c')
	}catch(e){}
	
	//提交
	//var obj=document.getElementById("DBRAudit");
	//if (obj) obj.onclick=Audit_click;
	//添加建议
	var obj=document.getElementById("DBAddResult");
	if (obj) obj.onclick=AddDefaultEDID;
	//跳转建议
	var obj=document.getElementById("DBAddRecommResult");
	if (obj) obj.onclick=AddRecommEDID;
	//打印病理申请
	var ObjArr=document.getElementsByName("PisRequest");
	if (ObjArr){
		var ArrLength=ObjArr.length;
		for (var j=0;j<ArrLength;j++){
			ObjArr[j].onclick=PrintPisRequest_click;
		}
	}

	var obj=document.getElementById("DBUpdate");
	if (obj) obj.onclick=DBUpdate_click;

	var objArr=document.getElementsByTagName("textarea");
	if (objArr[0])
	{
		try
		{
			//alert(objArr[0].readonly)
			if (!objArr[0].readOnly){
				objArr[0].focus();
			}
			if (objArr.length==1){
				CurID=objArr[0].id;
				CurObj=objArr[0];
			}
		}catch(e){
		
		}
	}
	
	var ObjArr=document.getElementsByName("Update");
	if (ObjArr){
		var ArrLength=ObjArr.length;
		for (var j=0;j<ArrLength;j++){
			ObjArr[j].onclick=SavePEResult_click;
		}
	}
	var ObjArr=document.getElementsByName("HighRiskText");
	if (ObjArr){
		var ArrLength=ObjArr.length;
		for (var j=0;j<ArrLength;j++){
			ObjArr[j].onclick=SendHighRisk_click;
		}
	}
	var ObjArr=document.getElementsByName("SetNoramText");
	if (ObjArr){
		var ArrLength=ObjArr.length;
		for (var j=0;j<ArrLength;j++){
			ObjArr[j].onclick=SetNormalText_click;
		}
	}

	
	var ObjArr=document.getElementsByName("Advice");
	if (ObjArr){
		var ArrLength=ObjArr.length;
		for (var j=0;j<ArrLength;j++){
			var ID=ObjArr[j].id;
			var ssid=ID.split("^")[0];
			var ret= tkMakeServerCall("web.DHCPE.ResultNew","getDiagAdvice",ssid);
			var ValueArr=ret.split("^");
			ObjArr[j].value=ValueArr[1];
			var obj=document.getElementById(ssid+"^Desc")
			if (obj) obj.value=ValueArr[0];
		}
	}
	var EpisodeID=document.getElementById("EpisodeID").value;
	var ObjArr=document.getElementsByName("Update");
	if (ObjArr){
		var ArrLength=ObjArr.length;
		for (var j=0;j<ArrLength;j++){
			var OrderID=ObjArr[j].id;
			var ObjResultArr=document.getElementsByName(OrderID);
			if (ObjResultArr){
				var ResultArrLength=ObjResultArr.length;
				for (var i=0;i<ResultArrLength;i++){
					var InputType=ObjResultArr[i].type;
					if (InputType=="button") continue;
					var ResultID=ObjResultArr[i].id;
					var ResultArr=ResultID.split("^");
					var EyeSeeObj=document.getElementsByName(ResultID+"^EyeSee");
					if (EyeSeeObj){
						var EyeSeeFlag=1;
					}else{
						var EyeSeeFlag=0;
					}
					
					var ret= tkMakeServerCall("web.DHCPE.ResultNew","GetResultItem",EpisodeID,ResultArr[0],ResultArr[1],EyeSeeFlag);
					
					if (EyeSeeFlag==1){
						var Arr=ret.split("^");
						ObjResultArr[i].value=Arr[0];
						EyeSeeObj.value=Arr[1];
					}else{
						ObjResultArr[i].value=ret;
					}
				}
			}
		}
	}
  
	
	var RLTOEType=DHCWeb_GetValue('RLTOEType');
	var tObj=document.getElementById("TOutResult");
	if (!tObj) return false;
	var EpisodeID=document.getElementById("EpisodeID").value;
	var rows=tObj.rows.length;
	for (var i=1; i<rows; i++){
		var RowItemID="";
		var rowitems=tObj.rows[i].all;
		if (!rowitems) {
		   //rowitems=rowobj.getElementsByTagName("input");
			rowitems=tObj.rows[i].getElementsByTagName("input");
		}
		for (var j=0;j<rowitems.length;j++) {
			if (rowitems[j].id) {
				var Id=rowitems[j].id;
				var arrId=Id.split("z");
				var Columnid=arrId[0];
				if (Columnid=="DocName"){
					RowItemID=arrId[1];
					break;
				}
			}
		}
		if (RLTOEType!="Lab") LoadDocList(RowItemID)
		var obj=document.getElementById("CheckDatez"+RowItemID);
		if (obj) obj.onchange=CheckDateChgHandler;
		
		
	}
	document.onkeydown=Doc_OnKeyDown;
	var StationID=document.getElementById("StationID").value;
	var ret= tkMakeServerCall("web.DHCPE.ResultNew","GetAuditStatus",StationID,EpisodeID);
	var PatientID=tkMakeServerCall("web.DHCPE.ResultNew","GetPatientID",EpisodeID);
	//alert(PatientID)   
	PEShowPicByPatientID(PatientID,"imgPic")  //DHCPECommon.js
	if(ret==1)
	{
		if (parent.frames("query")){
			parent.frames("query").websys_setfocus("RegNo");
		}
	}	
}
function LoadDocList(RowItemID) {
	if (RowItemID=="") return;
	var RowDocElName='DocNamez'+RowItemID;
	if (document.getElementById(RowDocElName)){
		var combo_DocName=dhtmlXComboFromStr(RowDocElName,"");
		combo_DocName.enableFilteringMode(false);
		combo_DocName.selectHandle=combo_DocNameSelecthandler;
		combo_DocName.DOMelem_input.onkeypress=combo_DocNameKeydownhandler;
		//置默认
		var RowDefDocElName='DefaultDocStrz'+RowItemID;
		var DefaultDocStr=DHCWeb_GetValue(RowDefDocElName);
		var Arr=StrToArray(DefaultDocStr);
		combo_DocName.addOption(Arr);
		if (Arr.length==1) combo_DocName.setComboValue(Arr[0][0]);
		
		//赋值全局对象
		var RowItemIDStr=RowItemID.split("||")[0]+"z"+RowItemID.split("||")[1];
		eval("combo_DocName"+RowItemIDStr+"=combo_DocName");
		//eval("combo_DocName"+RowItemIDStr+'.attachEvent("onKeyPressed",combo_DocNameKeydownhandler)');
		//alert(eval("combo_DocName"+RowItemIDStr+".type"))
	}
}

function CheckDateChgHandler(e) {
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var myCheckDate = DHCWeb_GetValue(eSrc.id);
	if ((myCheckDate != "") && ((myCheckDate.length != 8) && ((myCheckDate.length != 10)))) {
		alert("请输入正确的日期");
		return websys_cancel();
	}
	var obj = document.getElementById(eSrc.id);
	if (myCheckDate.length == 8) {
		var myCheckDate = myCheckDate.substring(0, 4) + "-" + myCheckDate.substring(4, 6) + "-" + myCheckDate.substring(6, 8)
			if (obj) obj.value=myCheckDate;
	}
	
	if (myCheckDate != "") {
		var reg = /^(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)$/;
		var ret = myCheckDate.match(reg);
		if (ret == null) {
			alert("请输入正确的日期");
			return websys_cancel();
		}
		var myrtn = DHCWeb_IsDate(myCheckDate, "-")
		if (!myrtn) {
			alert("请输入正确的日期");
			return websys_cancel();
		}
	}
}
function combo_DocNameSelecthandler(e){
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	if (eSrc.id!="") {
		var Desc=DHCWeb_GetValue(eSrc.id);
		//alert("id:"+eSrc.id+"Desc:"+Desc)
		if (Desc=="") return;
		var RowItemID=eSrc.id.split("z")[1];
		var RowItemIDStr=RowItemID.split("||")[0]+"z"+RowItemID.split("||")[1];
		eval("var Obj="+"combo_DocName"+RowItemIDStr);
		Obj.clearAll();
		var encmeth=DHCWeb_GetValue('GetAllUserDocEncrypt');
		if (encmeth!="") {
			var AllDocStr=cspRunServerMethod(encmeth,Desc,session['LOGON.USERID']);
			if (AllDocStr!=""){
				var Arr=StrToArray(AllDocStr);
				if (Obj) {
					Obj.clearAll();
					Obj.addOption(Arr);
				}
			}
		}
	}
}
function combo_DocNameKeydownhandler(e) {
	var keycode=websys_getKey(e);
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement
	if ((eSrc.id!="")&&(keycode==13)) {
		combo_DocNameSelecthandler(e);
		return false;
	}
	/*
	var DocUserId=combo_DocName.getSelectedValue();
	if (document.getElementById("DocUserId")) {
		document.getElementById("DocUserId").value=DocUserId;
	}
	*/
	
}
function StrToArray(str){
	var x=new Array();
	var Arr=str.split('^');
	for(var i=0;i<Arr.length;i++){
		var Arr1=Arr[i].split(String.fromCharCode(1));
		var label=Arr1[1];
		var val=Arr1[0];
		if((typeof(val)=="undefined")||(val===null))val=label;
		x[i]=[val,label];
	}
	return x;
}
function Doc_OnKeyDown(){
	if(event.keyCode==13){return false;}
	if (event.keyCode==115)
	{
		
		var obj=document.getElementById("AuditDate")
		//StationSCancelSub()
		//Audit_click
		if (obj) {var Date=obj.value}
		if (Date==""){Audit_click()}
		else {StationSCancelSub()}
		////F2
		//document.onkeydown=function(){return false;}
		//alert('dacc')
		document.onkeydown=Doc_OnKeyDown;
	}
	if (event.keyCode==120)
	{
		
		//alert(event.keyCode)
		BComplete();
		
		}
}
function ShowAllResult(e)
{
	var EpisodeID="";
	var obj=document.getElementById("EpisodeID");
    	if (obj){
		EpisodeID=obj.value
	}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewDiagnosis"
			+"&EpisodeID="+EpisodeID
			+"&ChartID="
			+"&OnlyRead=Y";
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes';
	window.open(lnk,"_blank",nwin)	

	return true;
}
function GetPreElement(CurElementID)
{
	var IDStr="";
	var obj=document.getElementById("IDStr");
	if (obj) IDStr=obj.value;
	if (IDStr=="") return IDStr;
	var Arr=IDStr.split("&");
	var ArrLength=Arr.length;
	var j="",Element="";
	for (var i=0;i<ArrLength;i++)
	{
		var Element=Arr[i];
		if (Element==CurElementID)
		{
			j=i;
			break;
		}
	}
	if (j==0){
		Element=Arr[ArrLength-1];
	}else{
		Element=Arr[j-1];
	}
	return Element;
}

function GetAftElement(CurElementID)
{
	var IDStr="";
	var obj=document.getElementById("IDStr");
	if (obj) IDStr=obj.value;
	if (IDStr=="") return IDStr;
	var Arr=IDStr.split("&");
	var ArrLength=Arr.length;
	var j="",Element="";
	for (var i=0;i<ArrLength;i++)
	{
		var Element=Arr[i];
		if (Element==CurElementID)
		{
			j=i;
			break;
		}
	}
	if (j==0){
		Element=Arr[1];
	}else{
		Element=Arr[j+1];
	}
	return Element;
}

function MoveFocus(e,NumFlag) 
{
	//alert(event.keyCode)
	if ((e.readOnly)&&(event.keyCode==8)) window.event.returnValue = false;
	if ((event.keyCode==13)||(event.keyCode==40)){
		//event.keyCode=9;
		var ElementID=GetAftElement(e.id);
		if (ElementID!=""){
			var obj=document.getElementById(ElementID);
			if (obj) obj.focus();
		}
		return false;
	}
	if (event.keyCode==38){
		var ElementID=GetPreElement(e.id);
		if (ElementID!=""){
			var obj=document.getElementById(ElementID);
			if (obj) obj.focus();
		}
		return false;
	}
	if (NumFlag=="1"){
		return false;
		if ((event.keyCode==190)||(event.keyCode==110)||(event.keyCode==8)||(event.keyCode==46)||(event.keyCode==37)||(event.keyCode==39))
		{
			return false;
		}
		if ((!((event.keyCode>=96)&&(event.keyCode<=105)))&&(!((event.keyCode>=48)&&(event.keyCode<=57))))
		{
			window.event.returnValue = false;
			return true;
		}
		
	}
}
function detailClick(e)
{
	var Info=e.id;
	CurID=Info;
	var InfoArr=Info.split("^");
	var OEORIRowId=InfoArr[0];
	var ODRowid=InfoArr[1];
	var otherDesc="";
	var EpisodeID=""
  	var obj=document.getElementById("EpisodeID");
    	if (obj){
		EpisodeID=obj.value
	}
	var obj=document.getElementById("StationID");
	var ChartID=""
	if (obj) ChartID=obj.value;
	var temIns=document.getElementById("GetEDInfo");
	if(temIns){
			temIns=temIns.value;
	}
	var Info=cspRunServerMethod(temIns,OEORIRowId,EpisodeID,ODRowid,ChartID,otherDesc);
	CreateEDDIv(e,Info);
}
function CreateEDDIv(obj,Info){  
    RemoveAllDiv(1);  
	if (Info=="") return false;
	div = document.createElement("div");   
    div.id="EDDiv";  
    div.style.position='absolute';  
    var op=getoffset(obj);  
    div.style.top=op[0]+20;  
    div.style.left=op[1]+40;  
    div.style.zIndex =100;  
    div.style.backgroundColor='white';  
    div.style.border="1px solid #666";  
    //div.className="td1";  
    var innerText="<TABLE border=0.5 width=220><TR align='right' bgcolor='lightblue'><TD colspan=2><button onclick='RemoveAllDiv(1)'>关闭</button></TD></TR>"
    var Char_1=String.fromCharCode(1);
    var EDArr=Info.split(Char_1);
    var EDArrLength=EDArr.length
    for (var i=0;i<EDArrLength;i++)
    {
    	var OneED=EDArr[i];
    	innerText=innerText+"<TR bgcolor='lightblue'><TD style='cursor:hand' width=110 value='"+OneED+"' onclick=EDDescClick(this,1)>"+OneED+"</TD>"
		i=i+1;
		if (i<EDArrLength)
		{
			var OneED=EDArr[i];
			innerText=innerText+"<TD style='cursor:hand' width=110 value='"+OneED+"' onclick=EDDescClick(this,1)>"+OneED+"</TD>"
		}
		innerText=innerText+"</TR>"
	}
    innerText=innerText+"</TABLE>"
    div.innerHTML=innerText;
    document.body.appendChild(div);  
}
function EDDescClick(e,CloseODSFlag)
{
	CloseODSDivFlag=CloseODSFlag;
	var Desc=e.innerText;
	var encmeth="";
	var obj=document.getElementById("GetEDInfoByDesc");
	if (obj) encmeth=obj.value;
	var obj=document.getElementById("StationID");
	var ChartID=""
	if (obj) ChartID=obj.value;
	var EpisodeID="";
	var obj=document.getElementById("EpisodeID");
	if (obj) var EpisodeID=obj.value;
	
	EDDesc=Desc;
	var Info=cspRunServerMethod(encmeth,ChartID,Desc,EpisodeID);
	if (Info=="") return false;
	CreateEDDetailDiv(e,Info)
}
function CreateEDDetailDiv(obj,Info){
	var el=obj;
    RemoveAllDiv(0);  
    div = document.createElement("div");   
    div.id="EDDetail";  
    div.style.position='absolute';  
    var op=getoffset(obj);  
    div.style.top=op[0]+20;  
    div.style.left=op[1]+50;  
    div.style.zIndex =100;  
    div.style.backgroundColor='white';  
    div.style.border="1px solid #666";  
    //div.className="td1";  
    var innerText="<TABLE border=0.5 width=200><TR align='right' bgcolor='lightblue'><TD colspan=2>添加结论<input type='checkbox' id='AddEDCol'><button onclick='RemoveAllDiv(0)'>关闭</button></TD></TR>"
    var Char_2=String.fromCharCode(2);
    var Char_1=String.fromCharCode(1);
    var EDArr=Info.split(Char_2);
    var EDArrLength=EDArr.length
    for (var i=0;i<EDArrLength;i++)
    {
    	var OneEDArr=EDArr[i];
    	var OneArr=OneEDArr.split(Char_1);
    	innerText=innerText+"<TR bgcolor='lightblue'><TD style='cursor:hand' value='"+OneArr[0]+"' ondblclick=EDDblClick(this)>"+OneArr[1]+"</TD></TR>"
    }
    innerText=innerText+"</TABLE>"
    div.innerHTML=innerText;
    document.body.appendChild(div);
    ReShowDiv(div,el);  
}
function EDDblClick(e)
{
	//var EDID=e.value;
	var eSrc=window.event.srcElement;
	var EDID=event.srcElement.getAttribute("value");

	AddDiagnosis(EDID);				
	if (!CurID) return false;
	var Arr=CurID.split("^");
	var OrderID=Arr[0];
	var ODID=Arr[1];
	var RObj=document.getElementById(OrderID+"^"+ODID);
	var NObj=document.getElementById(OrderID+"^"+ODID+"S");
	if (RObj&&NObj){
		if (RObj.readOnly==true) return false;
		if ((RObj.value=="")||(RObj.value==NObj.innerText)){
			RObj.value=EDDesc;
		}else{
			var obj=GetObj("AddEDCol");
			if (obj&&obj.checked){
				RObj.value=RObj.value+","+EDDesc;
			}
		}
	}
	/*
	var CurID;
var EDDesc="";
	*/
}
function contextmenu()
{
	if (document.all) window.event.returnValue = false;// for IE
	else event.preventDefault();

}
function AllEDDescDBLClick(e)
{
	if (event.button == 2) {
		RemoveAllDiv(1);
		if (!CurObj) return false;
		setCaret(CurObj);
		EDDescDBLClick(e.innerText);
	}
}
function EDDEscOnDBLClick(e)
{
	RemoveAllDiv(1);
	if (!CurObj) return false;
	setCaret(CurObj);
	EDDescDBLClick(e.innerText);
}
function EDDescDBLClick(EDDesc)
{
	if (!CurObj) return false;
	if (CurObj.readOnly) return false;
	var NObj=document.getElementById(CurObj.id+"S");
	if (CurObj&&NObj){
		if ((CurObj.value=="")||(CurObj.value==NObj.innerText)){
			CurObj.value=EDDesc;
		}else{
			CurObj.value=CurObj.value+"，"+EDDesc;
		}
	}
}
function resultchange(e)
{
	CurObj=e;
	CurID=e.id;
	setCaret(CurObj);
}
function resultSelectStart(e)
{
	CurObj=e;
	CurID=e.id;
	setCaret(CurObj);
}
function resultClick(e)
{
	CurObj=e;
	CurID=e.id;
	setCaret(CurObj);
}
function detailStandard(e)
{
	if (e.readOnly) return false;
	CurID=e.id;
	setCaret(CurObj);
	var IDInfo=e.id;
	var encmeth="";
	var obj=document.getElementById("GetODSStr");
	if (obj) encmeth=obj.value;
	var ODStr=cspRunServerMethod(encmeth,IDInfo);
	CreateODSDiv(e,ODStr);
}
function ResumeDefault()
{
	var obj=document.getElementById(CurID);
	if (obj){
		if (obj.readOnly) return false;
		var SObj=document.getElementById(CurID+"S");
		obj.value=SObj.innerText;
	}
}
function CreateODSDiv(obj,Info){  
    
	//var OldDiv=document.getElementById("ODSDiv");
	//if (OldDiv){
	//	var DivTop=OldDiv.style.top;
	//	var Divleft=OldDiv.style.left;
	//}else{
		var el=obj;
		var op=getoffset(obj);
		var DivTop=op[0];
		var Divleft=op[1]+40;
	//}
	 var stationid=obj.id.split("^")[1].split("||")[0]
	//牙科站点
	var stationDesc=tkMakeServerCall("web.DHCPE.Station","GetStaionDesc",stationid);
	if(stationDesc.indexOf("口腔")>-1) {
	var innerText="<TABLE border=0.5 width=360><TR align='left' bgcolor='lightblue'><TD colspan=3><button onclick='RemoveAllDiv(1)'>关闭</button>&nbsp;&nbsp;<button onclick='ResumeDefault()'>恢复默认</button>&nbsp;&nbsp;<button onclick='OpenTooth()'>牙位图</button></TD></TR>"
	}
   else {
	   var innerText="<TABLE border=0.5 width=360><TR align='left' bgcolor='lightblue'><TD colspan=3><button onclick='RemoveAllDiv(1)'>关闭</button>&nbsp;&nbsp;<button onclick='ResumeDefault()'>恢复默认</button></TD></TR>"
   }
	RemoveAllDiv(1);
	
    //if (Info=="") return false;
	div = document.createElement("div");   
    div.id="ODSDiv";  
    div.style.position='absolute';  
    //var op=getoffset(obj);  
    div.style.top=DivTop;  
    div.style.left=Divleft;  
    div.style.zIndex =100;  
    div.style.backgroundColor='white';  
    div.style.border="1px solid #666";  
    //div.className="td1"; 
	//alert(obj.id)
    //var innerText="<TABLE border=0.5 width=360><TR align='left' bgcolor='lightblue'><TD colspan=3><button onclick='RemoveAllDiv(1)'>关闭</button>&nbsp;&nbsp;<button onclick='ResumeDefault()'>恢复默认</button></TD></TR>"
    var Char_2=String.fromCharCode(2);
    var Char_1=String.fromCharCode(1);
    var ODSArr=Info.split(Char_2);
    var ODSArrLength=ODSArr.length
    for (var i=0;i<ODSArrLength;i++)
    {
    	var OneODSArr=ODSArr[i];
    	var OneArr=OneODSArr.split(Char_1);
    	innerText=innerText+"<TR bgcolor='lightblue'><TD style='cursor:hand' width=33% value='"+OneArr[1]+"' onclick=ODSDblClick(this)>"+OneArr[0]+"</TD>"
		i=i+1;
		if (i<ODSArrLength)
		{
			var OneODSArr=ODSArr[i];
			var OneArr=OneODSArr.split(Char_1);
			innerText=innerText+"<TD style='cursor:hand' width=33% value='"+OneArr[1]+"' onclick=ODSDblClick(this)>"+OneArr[0]+"</TD>"
		}
		
		i=i+1;
		if (i<ODSArrLength)
		{
			var OneODSArr=ODSArr[i];
			var OneArr=OneODSArr.split(Char_1);
			innerText=innerText+"<TD style='cursor:hand' value='"+OneArr[1]+"' onclick=ODSDblClick(this)>"+OneArr[0]+"</TD>"
		}
		
		innerText=innerText+"</TR>"
	}
    var ReportFromatObj=document.getElementById("ReportFormat")
    if (ReportFromatObj) ReportFromat=ReportFromatObj.value;
    if (ReportFromat<3){
    //加入对应的建议内容
	Info=obj.id;
	CurID=Info;
	var InfoArr=Info.split("^");
	var OEORIRowId=InfoArr[0];
	var ODRowid=InfoArr[1];
	var otherDesc="";
	var EpisodeID=""
  	var obj=document.getElementById("EpisodeID");
    	if (obj){
		EpisodeID=obj.value
	}
	var obj=document.getElementById("StationID");
	var ChartID=""
	if (obj) ChartID=obj.value;
	var temIns=document.getElementById("GetEDInfo");
	if(temIns){
			temIns=temIns.value;
	}
	var Info=cspRunServerMethod(temIns,OEORIRowId,EpisodeID,ODRowid,ChartID,otherDesc);
	if (Info!=""&&ChartID!=4){
		var Char_1=String.fromCharCode(1);
		var EDArr=Info.split(Char_1);
		var EDArrLength=EDArr.length
		var innerText=innerText+"<TR bgcolor='lightgreen'><TD colspan=3><b>以下为建议内容<b></TD></TR>"
		for (var i=0;i<EDArrLength;i++)
		{
			var OneED=EDArr[i];
			innerText=innerText+"<TR bgcolor='lightblue'><TD style='cursor:hand' width=110 value='"+OneED+"' onclick=EDDescClick(this,0)>"+OneED+"</TD>"
			i=i+1;
			if (i<EDArrLength)
			{
				var OneED=EDArr[i];
				innerText=innerText+"<TD style='cursor:hand' width=110 value='"+OneED+"' onclick=EDDescClick(this,0)>"+OneED+"</TD>"
			}	
			i=i+1;
			if (i<EDArrLength)
			{
				var OneED=EDArr[i];
				innerText=innerText+"<TD style='cursor:hand' width=110 value='"+OneED+"' onclick=EDDescClick(this,0)>"+OneED+"</TD>"
			}
			innerText=innerText+"</TR>"
		}
	}
    }
    
   
	innerText=innerText+"</TABLE>"
    div.innerHTML=innerText;
    document.body.appendChild(div);
	rDrag.init(div);
	ReShowDiv(div,el);
}
function ReShowDiv(div,el)
{
	//DivTop=div.style.top; 
	document.getElementById(div.id).style.display = "";
    divHeight=document.getElementById(div.id).offsetHeight;
    document.getElementById(div.id).style.display = "none";
	bodyHeight=window.screen.availHeight-parent.BottomHeight;
	var OldTop=(+div.style.top.split("px")[0])
	if ((divHeight + OldTop + el.offsetHeight +60)>bodyHeight){
		if (OldTop - divHeight>0){  //
			divTop=OldTop - divHeight
		}else{//上面显示不下,就让下面有滚动条显示
			divTop=(OldTop) + el.offsetHeight +60;
		}
	}else{
		divTop=OldTop + el.offsetHeight+60;
	}
	
	 div.style.top=divTop;
	 document.getElementById(div.id).style.display = "";
   
}
function ODSDblClick(e)
{
	var NatureDesc="";
	if (CurObj=="") return false;
	if (!CurObj) return false;
	var Strs=e.innerText;
	var CurObjID=CurObj.id;
	var IDArr=CurObjID.split("^");
	var NatureObj=document.getElementById(IDArr[0]+"^"+IDArr[1]+"S");
	if (NatureObj) NatureDesc=NatureObj.innerText;
	var EyeSeeObjID=IDArr[0]+"^"+IDArr[1]+"^EyeSee";
	//alert(EyeSeeObjID)
	var EyeSeeObj=document.getElementById(EyeSeeObjID)
	if (EyeSeeObj){
		var ZDObjID=IDArr[0]+"^"+IDArr[1];
		var ZDObj=document.getElementById(ZDObjID)
		var EyeSeeStr="";
		EyeSeeStr=tkMakeServerCall("web.DHCPE.ODStandard","GetEyeSeeInfo",IDArr[1],Strs);
		if (Strs==NatureDesc){
			ZDObj.value=Strs;
			EyeSeeObj.value="";
		}else if (ZDObj.value==NatureDesc){
			ZDObj.value=Strs;
			EyeSeeObj.value=EyeSeeStr;
		}else{
			if (EyeSeeStr!=""){
				if (EyeSeeObj.value!=""){
					EyeSeeObj.value=EyeSeeObj.value+"\n"+EyeSeeStr
				}else{
					EyeSeeObj.value=EyeSeeStr;
				}
			}
			if (ZDObj.value!=""){
				ZDObj.value=ZDObj.value+"\n"+Strs
			}else{
				ZDObj.value=Strs;
			}
			
		}
		
	}else{
		if (Strs==NatureDesc){
			CurObj.value=Strs;
		}else if (CurObj.value==NatureDesc){
			CurObj.value="";
			insertAtCaret(CurObj, Strs);
		}else{
			insertAtCaret(CurObj, Strs);
		}
	}
	
	return false;
}
function getoffset(elem)   
{
	if ( !elem ) return {left:0, top:0};

    var top = 0, left = 0;

    if ( "getBoundingClientRect" in document.documentElement ){

        //jquery方法

        var box = elem.getBoundingClientRect(), 

        doc = elem.ownerDocument, 

        body = doc.body, 

        docElem = doc.documentElement,

        clientTop = docElem.clientTop || body.clientTop || 0, 

        clientLeft = docElem.clientLeft || body.clientLeft || 0,

        top  = box.top  + (self.pageYOffset || docElem && docElem.scrollTop  || body.scrollTop ) - clientTop,

        left = box.left + (self.pageXOffset || docElem && docElem.scrollLeft || body.scrollLeft) - clientLeft;

    }else{

        do{

            top += elem.offsetTop || 0;

            left += elem.offsetLeft || 0;

            elem = elem.offsetParent;

        } while (elem);

	}
	var rec = new Array(1);   
	rec[0] = top;   
	rec[1] = left;   
	return rec 
}
function setCaret(textObj) {
	if (textObj.createTextRange) {
		 if(window.navigator.appVersion.indexOf("rv:11") > -1) {}
		  else {textObj.caretPos = document.selection.createRange().duplicate();}

	    //if(websys_isIE) textObj.caretPos = document.selection.createRange().duplicate();
    }
}
function insertAtCaret(textObj, textFeildValue) {
    if (document.all) {
		if (textObj.createTextRange && textObj.caretPos) {
            var caretPos = textObj.caretPos;
            caretPos.text = caretPos.text.charAt(caretPos.text.length - 1) == '   ' ? textFeildValue + '   ' : textFeildValue;
        } else {
            textObj.value = textFeildValue;
        }
    } else {
		if (textObj.setSelectionRange) {
            var rangeStart = textObj.selectionStart;
            var rangeEnd = textObj.selectionEnd;
            var tempStr1 = textObj.value.substring(0, rangeStart);
            var tempStr2 = textObj.value.substring(rangeEnd);
            textObj.value = tempStr1 + textFeildValue + tempStr2;
            textObj.setSelectionRange(textObj.value.length,textObj.value.length)
        } else {
            alert("This   version   of   Mozilla   based   browser   does   not   support   setSelectionRange");
        }
    }
}
function InsertString(tbid, str){
    var tb = document.getElementById(tbid);
    tb.focus();
    if (document.all){
    	var r = document.selection.createRange();
        document.selection.empty();
        r.text = str;
        r.collapse();
        r.select();
    }
    else{
        var newstart = tb.selectionStart+str.length;
        tb.value=tb.value.substr(0,tb.selectionStart)+str+tb.value.substring(tb.selectionEnd);
        tb.selectionStart = newstart;
        tb.selectionEnd = newstart;
    }
}
function GetSelection(tbid){
    var sel = '';
    if (document.all){
        var r = document.selection.createRange();
        document.selection.empty();
        sel = r.text;
    }
    else{
    var tb = document.getElementById(tbid);
      // tb.focus();
        var start = tb.selectionStart;
        var end = tb.selectionEnd;
        sel = tb.value.substring(start, end);
    }
    return sel;
}
function ShowSelection(tbid){
var sel = GetSelection(tbid);
    if (sel)
        alert('选中的文本是：'+sel);
    else
        alert('未选择文本！');
}
function RemoveAllDiv(Type)
{
	if (CloseODSDivFlag=="1"){
		var div=document.getElementById("ODSDiv");  
		if (div!=null) document.body.removeChild(div);
	}else{
		CloseODSDivFlag="1";
	}
	var div=document.getElementById("EDDetail");  
    if (div!=null) document.body.removeChild(div);
	var div=document.getElementById("ALLEDDesc");  
    if (div!=null) document.body.removeChild(div);
	if (Type=="1")
	{
		var div=document.getElementById("EDDiv");  
		if (div!=null) document.body.removeChild(div);
	}
}
function SavePEResult_click()
{
	var eSrc=window.event.srcElement;
	SavePEResult(eSrc,0);
	return false;
}

function SavePEResult(e,CompleteFlag)
{
	var ButtonID=e.id;
	var CompleteFlag=ButtonID.split("^")[1];
	var WriteFlag=ButtonID.split("^")[2];
	var ButtonID=ButtonID.split("^")[0];
	var ObjArr=document.getElementsByName(ButtonID);
	var ArrLength=ObjArr.length;
	if(WriteFlag=="N"){
		alert("医生没有该站点下的可写权限");
		
	}

	if (e.innerText=="修改结果")
	{
		for (var i=0;i<ArrLength;i++)
		{
			//if (ObjArr[i].type=='button') continue;
			//ObjArr[i].disabled=false;
			ObjArr[i].readOnly=false;
			
			if(WriteFlag=="N"){
				ObjArr[i].disabled=true;
				ObjArr[i].readOnly=true;
			}

			var EyeSeeID=ObjArr[i].id+"^EyeSee";
			var EyeSeeObj=document.getElementById(EyeSeeID);
			if (EyeSeeObj){
				EyeSeeObj.disabled=false;
				EyeSeeObj.readOnly=false;
			}
		}
		//var encmeth=GetValue("CancelExecuteClass",1);
		//var ret=cspRunServerMethod(encmeth,ButtonID)
		e.innerText="保存结果"
		return false;
	}
	
	
	var ResultInfo="";
	var Char_1=String.fromCharCode(1);
	for (var i=0;i<ArrLength;i++)
	{
		var ResultID=ObjArr[i].id;
		var EyeSeeObj=document.getElementById(ResultID+"^EyeSee");
		if (EyeSeeObj){
			var EyeSee=EyeSeeObj.value;
			var ZDInfo=ObjArr[i].value;
			var Value="临床诊断:;检查所见:"+EyeSee+";诊断意见:"+ZDInfo;
		}else{
			var Value=ObjArr[i].value;
		}
		
		var OneInfo=ResultID+"^"+Value;
		if (ResultInfo==""){
			ResultInfo=OneInfo;
		}else{
			ResultInfo=ResultInfo+Char_1+OneInfo;
		}
	}
	//保存医生和日期
	
	var BaseEntryInfo=""
	var RowItemIDStr=ButtonID.split("||")[0]+"z"+ButtonID.split("||")[1];
	//eval("var DocNameObj=combo_DocName"+RowItemIDStr);
	eval("var DocNameObj="+"combo_DocName"+RowItemIDStr);
	var DocUserId="";
	if (DocNameObj) DocUserId=DocNameObj.getSelectedValue();
	
	//var DocUserId=session['LOGON.USERID'];
	var CheckDate=DHCWeb_GetValue('CheckDatez'+ButtonID);
	
	BaseEntryInfo=CheckDate;
	var encmeth="";
	var obj=document.getElementById("SaveResult");
	if (obj) encmeth=obj.value;
	if (DocUserId==""){
		var obj=document.getElementById("AuditUser");
		if (obj) DocUserId=obj.value;
	}
	
	try{
		if (!PESaveCASign("0",ButtonID,ResultInfo)) return false;
	}catch(e){}

	var ret=cspRunServerMethod(encmeth,ResultInfo,DocUserId,"",BaseEntryInfo);
	//alert(ret)
	var RetArr=ret.split("^");
	if (RetArr[0]==0){
		if (CompleteFlag=="1")  //保存时科室确认
		{
			BComplete();
		}
		e.innerText="修改结果";
		for (var i=0;i<ArrLength;i++)
		{
			if (ObjArr[i].type=='button') continue;
			ObjArr[i].readOnly=true;
			var EyeSeeID=ObjArr[i].id+"^EyeSee";
			var EyeSeeObj=document.getElementById(EyeSeeID);
			if (EyeSeeObj){
				EyeSeeObj.readOnly=true;
			}
		}
		e.disabled=false;
		if (RetArr[2]!="NA"){
			window.location.reload();
		}else{
			if (parent.frames["query"])
			{
				parent.frames["query"].SetCheckInfo();
				parent.frames["query"].websys_setfocus("RegNo");
			}
		}
	}else{
		alert(RetArr[1]);
	}
		//window.location.reload();
}
function SendHighRisk_click()
{
	var eSrc=window.event.srcElement;
	SendHighRisk(eSrc);
	return false;

}

function SendHighRisk(e)
{
	var OrdItemID=e.id;
	var PAADM="";
	var obj=document.getElementById("EpisodeID");
	if (obj) PAADM=obj.value;
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPESendMessageNew"
			+"&PAADM="+PAADM+"&OrderItemID="+OrdItemID;
	var wwidth=600;
	var wheight=400;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)
	//window.location.reload();
	return false;
}
/*
function PrintPisRequest_click()
{
	
	var eSrc=window.event.srcElement;
	var OrdItemID=eSrc.id;
	var PAADM="";
	var obj=document.getElementById("EpisodeID");
	if (obj) PAADM=obj.value;
	var CTLOCID="",CurUserID="";
	var CTLOCID=session['LOGON.CTLOCID'];
	var CurUserID=session['LOGON.USERID'];
	 var DataStr=tkMakeServerCall("web.DHCPE.ResultNew","GetPisCode",OrdItemID);
	 var Data=DataStr.split("^");
	 var flag=Data[0];
	 
	 if(flag=="-1"){
		 alert(Data[1]);
		 return false;
	 }else{
	 var PisCode=Data[1];
	 if(PisCode=="20"){
      lnk="dhcpisapp.tjcell.csp"
          +"?OrderID="+OrdItemID+"&EpisodeID="+PAADM+"&SSUSERGROUPDESC="+CurUserID+"&DEPARTMENT="+CTLOCID;
	 }
	else if(PisCode=="23"){
		 
	lnk="dhcpisapp.tjtct.csp"
          +"?OrderID="+OrdItemID+"&EpisodeID="+PAADM+"&SSUSERGROUPDESC="+CurUserID+"&DEPARTMENT="+CTLOCID;
	 }else{
		 alert("没有设置病理标本号")
		 return false;
	 }
	 }
         
          
      window.open(lnk) 
    	return false;
}
*/

/*
function PrintPisRequest_click()
{
	var eSrc=window.event.srcElement;
	PrintPisRequest(eSrc);
	return false;
}
*/

function PrintPisRequest_click()
{
	
	var eSrc=window.event.srcElement;
	var OrdItemID=eSrc.id;
	var PAADM="";
	var obj=document.getElementById("EpisodeID");
	if (obj) PAADM=obj.value;
	var CTLOCID="",CurUserID="";
	var CTLOCID=session['LOGON.CTLOCID'];
	var CurUserID=session['LOGON.USERID'];
	var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSendPisInterface");
	var itmmasID=tkMakeServerCall("web.DHCPE.DHCPECommon","GetArcItmByOrdItem",OrdItemID);
	if(flag=="1"){
		//新产品组
		//alert("PAADM:"+PAADM+",itmmasID:"+itmmasID+",OrdItemID:"+OrdItemID)
		lnk=tkMakeServerCall("web.DHCAPPPisInterface","GetPisLinkUrl",PAADM,itmmasID,OrdItemID);
		//alert(lnk)
    
	}else{
	 var DataStr=tkMakeServerCall("web.DHCPE.ResultNew","GetPisCode",OrdItemID);
	 var Data=DataStr.split("^");
	 var flag=Data[0];
	 
	 if(flag=="-1"){
		 alert(Data[1]);
		 return false;
	 }else{
	 var PisCode=Data[1];
	 if(PisCode=="20"){
      lnk="dhcpisapp.tjcell.csp"
          +"?OrderID="+OrdItemID+"&EpisodeID="+PAADM+"&SSUSERGROUPDESC="+CurUserID+"&DEPARTMENT="+CTLOCID;
	 }
	else if(PisCode=="23"){
		 
	lnk="dhcpisapp.tjtct.csp"
          +"?OrderID="+OrdItemID+"&EpisodeID="+PAADM+"&SSUSERGROUPDESC="+CurUserID+"&DEPARTMENT="+CTLOCID;
	 }else{
		 alert("没有设置病理标本号")
		 return false;
	 }
	 }
       
	} 
          
      window.open(lnk) 
    	return false;
}

function PrintPisRequest(e)
{

	var UpdateArr=document.getElementsByName("Update");
	var ID=e.id;
	for (var i=0;i<UpdateArr.length;i++)
	{
		if ((UpdateArr[i].id==ID)&&(UpdateArr[i].innerText=="保存结果"))
		{
			SavePEResult(UpdateArr[i],0);
		}
	}
	
	var PAADM="";
	var obj=document.getElementById("EpisodeID");
	if (obj) PAADM=obj.value;
	PrintByTemplate(PAADM);
	if (parent.frames["query"])
	{
		parent.frames["query"].websys_setfocus("RegNo");
	}
	return false;
}
function PrintByTemplate(iPAADMDR)
{
	var Template="DHCPEPISRequest"
	var Data=tkMakeServerCall("web.DHCPE.ReportGetInfor","GetSpecialReportInfo",iPAADMDR,Template);
	if (Data==""){
		alert("没有打印的数据");
		return false;
	}
	if (Data!=""){
		PrintReportByXml(Data,Template);
		return false;
	}else{
		alert("没有设置打印格式对应的数据");
		return false;
	}	
}
function PrintReportByXml(ReportData,Template)
{
	DHCP_GetXMLConfig("InvPrintEncrypt",Template);
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,ReportData,"");
	return false
}
function DealPEExe(e)
{
	var obj=document.getElementById("EpisodeID");
	if (obj) PAADM=obj.value;
	var obj=document.getElementById("SetDealExeClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,PAADM)
	if (ret=="1"){
		if (!confirm("已经采集过图像，是否继续")) return false;
	}
	var DealExe=new ActiveXObject("DealExeP.DealExe");
	//Exe名称  参数  Exe's Title名称
	//DealExe.OpenExe("D:\ExeTest\\工程1.exe","aaaaa","ExeTest");
	var PIADM="";
	var obj=document.getElementById("PIADM");
	if (obj) PIADM=obj.value;
	//alert('a')
	DealExe.OpenExe("D:\\pb90\\主程序.exe",PIADM,"图文信息管理系统");
}

function SetNormalText_click()
{
	var eSrc=window.event.srcElement;
	SetNormalText(eSrc);
	return false;

}

function SetNormalText(e)
{
	var OrderID=e.id;
	var ObjArr=document.getElementsByName(OrderID);
	var ArrLength=ObjArr.length;
	for (var i=0;i<ArrLength;i++)
	{
		if (ObjArr[i].readOnly) return false;
		var ID=ObjArr[i].id;
		var obj=document.getElementById(ID+"S");
		if (obj)
		{
			if ((obj.innerText.split("-").length)>1){
				ObjArr[i].value="";
			}else{
				ObjArr[i].value=obj.innerText;
			}
		}
	}
	
	var encmeth=GetValue("CancelExecuteClass",1);
	var ret=cspRunServerMethod(encmeth,OrderID)
	
	
	var DeleteObj=document.getElementsByName("DeleteED");
	var ArrLength=DeleteObj.length;
	for (var i=ArrLength;i>0;i--)
	{
		DeleteEDInfo(DeleteObj[i-1],0);
	}
	
	var EpisodeID=document.getElementById("EpisodeID").value;
	
	var DelResult=tkMakeServerCall("web.DHCPE.ResultNew","DeleteResultByOrder",OrderID,EpisodeID);
	// window.location.reload();
	return false;
}

function PrintBChaoApp(e)
{
	var PAADM="";
	var obj=document.getElementById("EpisodeID");
	if (obj) PAADM=obj.value;
	if (PAADM=="") return false;
	
	var ObjArr=document.getElementsByName("PrintFlag");
	var ArrLength=ObjArr.length;
	for (var i=0;i<ArrLength;i++)
	{
		var OneObj=ObjArr[i];
		if (OneObj.checked){
			var OneID=OneObj.id;
			OneID=OneID.split("Print")[1];
			PrintBChaoReport(PAADM,OneID);
		}
	}
	//PrintBChaoReport(PAADM,"");
}

function GetEqData(e)
{
	var ComputeName=GetComputeInfo("");
	var ButtonID=e.id;
	var ObjArr=document.getElementsByName(ButtonID);
	var ArrLength=ObjArr.length;
	var Char_1=String.fromCharCode(1);
	for (var i=0;i<ArrLength;i++)
	{
		var ResultID=ObjArr[i].id;
		var OneArr=ResultID.split("^");
		if (OneArr.length==1) continue;
		if (OneArr[1]=="") continue;
		var EqData=tkMakeServerCall("web.DHCPE.EquipmentData","GetData",ComputeName,OneArr[1]);
		if (EqData!=""){
			ObjArr[i].value=EqData;
		}
	}
	window.location.reload();
}
function OpenTooth()
{
	var eSrc=window.event.srcElement;
	
	ToothMap(eSrc);
	return false;

}
function ToothMap(e)
{
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEToothMap"
			+"&eSrc="+CurObj.id;
	var wwidth=600;
	var wheight=400;
	var xposition = (screen.width - wwidth);
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)
	return false;
}

function QueryED_KeyDown(e,stid,adm)
{
	var Key=websys_getKey(e); 
	if ((13==Key)) 
	{
		var ret=tkMakeServerCall("web.DHCPE.DocPatientFind","OutEDInfobyPrefix",stid,"",adm,"1",e.value);
		document.getElementById("edprefix").innerHTML = ret;
	}
	
}
function AddRecommEDID()
{
	var EpisodeID=document.getElementById("EpisodeID").value;
	var StationID=document.getElementById("StationID").value;
	var ret= tkMakeServerCall("web.DHCPE.ResultEdit","GenAdmGeneralRecommLR",EpisodeID,StationID);
	
	if(ret=="") 
	{
		alert("没有自动匹配的建议");
		return false;
	}

	if(ret.indexOf("^")>=0){
	var str=ret.split("^")
	for(var i=0;i<str.length;i++)
	{
		if(str[i]=="")
		continue;
		AddDiagnosis(str[i])
		
	}
	}
		return false;
}