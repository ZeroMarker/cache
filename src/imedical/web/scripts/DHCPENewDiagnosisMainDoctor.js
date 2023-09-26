var UserId=session['LOGON.USERID'];
var CloseODSDivFlag=0;
var ResultWin;
document.body.onload = BodyLoadHandler;

function BodyLoadHandler()
{
	var objArr=document.getElementsByTagName("textarea");
	var objLength=objArr.length;
	for (var i=0;i<objLength;i++)
	{
		//setTareaAutoHeight(objArr[i]);
	}
//	alert(objLength);
	var GSSDetailObj=document.getElementById("GSSDetail");
	//	alert(GSSDetailObj)
		
}
//高危
function HighRiskReport()
{
	var iEpisodeID="";
	obj=document.getElementById("EpisodeID");
	if (obj) { iEpisodeID=obj.value; }
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPESendMessageNew"
			+"&PAADM="+iEpisodeID+"&OrderItemID=";
	var wwidth=600;
	var wheight=400;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin);
	return false;
}
function GetContrastWithLast()
{
	var obj;
	var iEpisodeID="";
	obj=document.getElementById("EpisodeID");
	if (obj) { iEpisodeID=obj.value; }
	//alert(iEpisodeID)
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEContrastWithLast"
			+"&PAADM="+iEpisodeID
	
		var wwidth=1000;
	var wheight=600; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes'
			+',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	window.open(lnk,"_blank",nwin)	
	//return true;
	return false;
}
function ShowLocResult(e)
{
	var StationID=e.id;
	var obj,iEpisodeID=""
	obj=document.getElementById("EpisodeID");
	if (obj) { iEpisodeID=obj.value; }
	var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewOneResult&StationID="+StationID+"&EpisodeID="+iEpisodeID;
  	var wwidth=550;
	var wheight=600; 
	var xposition = ((screen.width - wwidth) / 2)-20;
	var yposition = ((screen.height - wheight) / 2)-100;
	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes'
			+',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	if (ResultWin) ResultWin.close();
	ResultWin=window.open(url,"ResultWin",nwin)
}
function setTareaAutoHeight(e) {
    //e.style.height = e.scrollHeight + "px";
	if (e.scrollHeight<32){
		e.style.height=32+"px";
	}else{
		e.style.height = e.scrollHeight + "px";
	}
}
function SaveAdvice(e)
{
	SaveAdviceApp(0);
}
function PreviewReport()
{
	var obj;
	var iReportName="",iEpisodeID="";
	obj=document.getElementById("ReportNameBox");
	if (obj) { iReportName=obj.value; }
	obj=document.getElementById("EpisodeID");
	if (obj) { iEpisodeID=obj.value; }
	
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no'
		+',left=0'
		+',top=0'
		+',width='+window.screen.availWidth
		+',height='+window.screen.availHeight
		;
	var lnk=iReportName+"?PatientID="+iEpisodeID; //+"&OnlyAdvice=Y";
	open(lnk,"_blank",nwin);
	return false;
}
function Audit_click()
{
	//UpdateGSSDetail
	var MainDoctor="";
	var obj=document.getElementById("MainDoctor");
	if (obj) MainDoctor=obj.value;
	if (MainDoctor=="Y"){
		obj=document.getElementById("EditAdvice");
		if (obj){
			MainAuditFlag=1;
			SaveAdviceApp(0);
			MainAuditFlag=0;
		}else{
			SaveGSSDetail();
		}
	}else{
		//保存建议
		Save_click();
	}
	obj=document.getElementById("EditAdvice");
	if (obj){
		//生成总的建议
		var obj=document.getElementById("CreateGSSDetail");
		if (obj) var encmeth=obj.value;
		obj=document.getElementById("SSID");
		if (obj) GSID=obj.value;
		var ret=cspRunServerMethod(encmeth,GSID,MainDoctor);
		var ret=ShowResult_click(1);
		if (ret!=1) return false;
	}
	obj=document.getElementById("EpisodeID");
	if (obj) var PAADM=obj.value;
	//if (!ModifyAdviceApp("")) return false;
	obj=document.getElementById("AuditBox");
	if (obj) var encmeth=obj.value;
	var flag=cspRunServerMethod(encmeth,PAADM,"Submit","0",MainDoctor);
	if (flag=="0")
	{
		try
		{
			if (parent.frames("baseinfo"))
			{
				parent.frames("baseinfo").websys_setfocus("RegNo");
			}
		}catch(e){}
		window.location.reload();
		return false;
	}
	alert(t[flag]);
	return false;
}

function ShowResult_click(SaveFlag)
{
	var obj,GSID="",MainDoctor="";
	obj=document.getElementById("SSID");
	if (obj) GSID=obj.value;
	//alert(GSID)
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPENewGSSDetail&GSID="+GSID+"&ButtonFlag="+SaveFlag;
	var  iWidth=1000; //模态窗口宽度
  	var  iHeight=600;//模态窗口高度
  	var  iTop=(window.screen.height-iHeight)/2;
  	var  iLeft=(window.screen.width-iWidth)/2;
  	var ret=window.showModalDialog(lnk, "", "dialogwidth:800px;dialogheight:600px;center:1"); 
	//var ret=window.open(lnk, "", "");
	
	return ret;
}

function StationSCancelSub()
{
	StatusChange("Cancel","0");
}
function StatusChange(Type,QXType)
{
	obj=document.getElementById("EpisodeID");
	if (obj) var PAADM=obj.value;
	var MainDoctor="";
	var obj=document.getElementById("MainDoctor");
	if (obj) MainDoctor=obj.value;
	if(Type=="Cancel")
	{
		var AuditUser=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetAuditUserId",PAADM,MainDoctor);
		if (AuditUser==""){
			alert(t["NoAudit"]);
			return false;
		}
		if((AuditUser!=UserId)&&(UserId!="1177")&&(UserId!="2386")){
		//if(AuditUser!=UserId){
			alert("非本人提交不能放弃提交");
			return;	
		}
			
	}
	
	//电子签名
	try{
		if (!PESaveCASign("3",PAADM,"")) return false;
	}catch(e){}
    //
	obj=document.getElementById("AuditBox");
	if (obj) var encmeth=obj.value;
	var flag=cspRunServerMethod(encmeth,PAADM,Type,QXType,MainDoctor);
	if (flag=="0")
	{
		window.location.reload();
		return false;
	}
	alert(t[flag]);
	return false;
}
function SaveGSSDetail()
{
	var obj,encmeth,GSID,GSSDetail;
	var obj=document.getElementById("UpdateGSSDetail");
	if (obj) var encmeth=obj.value;
	obj=document.getElementById("SSID");
	if (obj) GSID=obj.value;
	obj=document.getElementById("GSSDetail");
	if (obj) GSSDetail=obj.value;
	var ret=cspRunServerMethod(encmeth,GSID,GSSDetail);

}
function ShowOneResult(e)
{
	var LocID=e.id;
	var obj=document.getElementById("EpisodeID");
	if (obj) PAADM=obj.value;
	var obj=document.getElementById("GetResultByLocID");
	if (obj) encmeth=obj.value;
	var Info=cspRunServerMethod(encmeth,PAADM,LocID);
	var obj=document.getElementById("ResultTD");
	if (obj) obj.innerHTML=Info;
	var Status="";
	var obj=document.getElementById("Status");
	if (obj) Status=obj.value;
	if ((Status==2)||(Status=="")) return false;  //已复检
	var MainDoctor="";
	var obj=document.getElementById("MainDoctor");
	if (obj) MainDoctor=obj.value;
	if ((Status==1)&&(MainDoctor=="N")) return false; //初检界面已初检
	if ((Status==0)&&(MainDoctor=="Y")) return false; //复检界面未初检
	var obj=document.getElementById("GetEDInfoByStation");
	if (obj) encmeth=obj.value;
	var Info=cspRunServerMethod(encmeth,LocID);
	
	var obj=document.getElementById("GetDCDesc");
	if (obj) encmeth=obj.value;
	var DCInfo=cspRunServerMethod(encmeth,PAADM);
	Info=Info+DCInfo;
	var obj=document.getElementById("EDInfo");
	
	if (obj) obj.innerHTML=Info;
	
}

function EDClick()
{
	//alert("ds");
	var eSrc=window.event.srcElement;
	var eSrcID=eSrc.id;
	var InfoArr=eSrcID.split("^");
	var StationID=InfoArr[0];
	var Desc=InfoArr[1];
	var obj=document.getElementById("GetEDInfoByDesc");
	if (obj) encmeth=obj.value;
	var Info=cspRunServerMethod(encmeth,StationID,Desc);
	if (Info=="") return false;
	CreateDiv(eSrc,Info)
}
function CreateDiv(obj,Info){  
   // alert("d");
    var el=obj;
	var div=document.getElementById("editBehaviorDiv");  
    if(div!=null)  
        document.body.removeChild(div);  
    div = document.createElement("div");   
    div.id="editBehaviorDiv";  
    div.style.position='absolute';  
    var op=getoffset(obj);  
    div.style.top=op[0];  
    div.style.left=op[1];  
    div.style.zIndex =100;  
    div.style.backgroundColor='#ecf1f6';  
    div.style.border="1px solid #666";  
    //div.className="td1";  
    var innerText="<TABLE border=1 width=200><TR align='left' bgcolor='lightblue'><TD><button onclick='RemoveAllDiv(1)'>关闭</button></TD></TR>" //<TR><button onclick=RemoveAllDiv(1)>关闭</button><TR/>
    var Char_2=String.fromCharCode(2);
    var Char_1=String.fromCharCode(1);
    var EDArr=Info.split(Char_2);
    var EDArrLength=EDArr.length
    for (var i=0;i<EDArrLength;i++)
    {
    	var OneEDArr=EDArr[i];
    	var OneArr=OneEDArr.split(Char_1);
    	innerText=innerText+"<TR><TD style='cursor:hand' value='"+OneArr[0]+"' ondblclick=EDDblClick(this)>"+OneArr[1]+"</TD></TR>"
    }
    innerText=innerText+"</TABLE>"
    div.innerHTML=innerText;
    document.body.appendChild(div);  
	ReShowDiv(div,el)
}
function ReShowDiv(div,el)
{
	//DivTop=div.style.top; 
	document.getElementById(div.id).style.display = "";
    divHeight=document.getElementById(div.id).offsetHeight;
    document.getElementById(div.id).style.display = "none";
	bodyHeight=window.screen.availHeight;
	var OldTop=(+div.style.top.split("px")[0])
	if ((divHeight + OldTop + el.offsetHeight+200)>screen.height){
		if (OldTop - divHeight>0){  //
			divTop=OldTop - divHeight
		}else{//上面显示不下,就让下面有滚动条显示
			divTop=(OldTop) + el.offsetHeight;
		}
	}else{
		divTop=OldTop + el.offsetHeight;
	}
	
	 div.style.top=divTop;
	 document.getElementById(div.id).style.display = "";
   
}
function detailClick(e)
{
 // alert("b");
	var Status="";
	var obj=document.getElementById("Status");
	if (obj) Status=obj.value;
	if ((Status==2)||(Status=="")) return false;  //已复检
	var MainDoctor="";
	var obj=document.getElementById("MainDoctor");
	if (obj) MainDoctor=obj.value;
	if ((Status==1)&&(MainDoctor=="N")) return false; //初检界面已初检
	if ((Status==0)&&(MainDoctor=="Y")) return false; //复检界面未初检
	

	var Info=e.id;
	var InfoArr=Info.split("^");
	var OEORIRowId=InfoArr[0];
	CurID=OEORIRowId;
	var ODRowid=InfoArr[1];
	var ChartID=InfoArr[2];
	var otherDesc="";
	var EpisodeID=""
  	var obj=document.getElementById("EpisodeID");
    	if (obj){
		EpisodeID=obj.value
	}
	var temIns=document.getElementById("GetEDInfo");
	if(temIns){
			temIns=temIns.value;
	}
	var Info=cspRunServerMethod(temIns,OEORIRowId,EpisodeID,ODRowid,ChartID,otherDesc);
	CreateEDDIv(e,Info,ChartID);
}
function CreateEDDIv(Parentobj,Info,ChartID){
	//alert("a")
	var OnlyRead="N";
	var obj=document.getElementById("OnlyRead");
	if (obj) OnlyRead=obj.value;
	if (OnlyRead=="Y") return false;

    RemoveAllDiv(1);  
	if (Info=="") return false;
	div = document.createElement("div");   
    div.id="EDDiv";  
    div.style.position='absolute';  
    var op=getoffset(Parentobj);
	//alert(op)
    div.style.top=op[0]+20;  
    div.style.left=op[1]+20;  
    div.style.zIndex =100;  
    div.style.backgroundColor='white';  
    div.style.border="1px solid #666";  
    //div.className="td1";  
    var innerText="<TABLE border=0.5 width=220><TR align='right' bgcolor='lightblue'><TD colspan=2><button onclick='RemoveAllDiv(1)'>关闭</button></TD></TR>"
    var Char_1=String.fromCharCode(1);
    var EDArr=Info.split(Char_1);
    var EDArrLength=EDArr.length;
	for (var i=0;i<EDArrLength;i++)
    {
    	var OneED=EDArr[i];
    	innerText=innerText+"<TR bgcolor='lightblue'><TD style='cursor:hand' width=110 value='"+OneED+"^"+ChartID+"' onclick=EDDescClick(this,1)>"+OneED+"</TD>"
		i=i+1;
		if (i<EDArrLength)
		{
			var OneED=EDArr[i];
			innerText=innerText+"<TD style='cursor:hand' width=110 value='"+OneED+"^"+ChartID+"' onclick=EDDescClick(this,1)>"+OneED+"</TD>"
		}
		innerText=innerText+"</TR>"
	}
    innerText=innerText+"</TABLE>"
    div.innerHTML=innerText;
    document.body.appendChild(div);  
}
function EDDescClick(e,CloseODSFlag,ChartID)
{
	//alert(1);
	CloseODSDivFlag=CloseODSFlag;
	var Desc=e.value;
	var ChartID=Desc.split("^")[1];
	var Desc=Desc.split("^")[0];
	var encmeth="";
	var obj=document.getElementById("GetEDInfoByDesc");
	if (obj) encmeth=obj.value;
	var Info=cspRunServerMethod(encmeth,ChartID,Desc);
	CreateEDDetailDiv(e,Info)
}
function CreateEDDetailDiv(obj,Info){  
	//alert(2);

    RemoveAllDiv(0);  
    div = document.createElement("div");   
    div.id="EDDetail";  
    div.style.position='absolute';  
    var op=getoffset(obj);  
    div.style.top=op[0]+20;  
    div.style.left=op[1];  
    div.style.zIndex =100;  
    div.style.backgroundColor='white';  
    div.style.border="1px solid #666";  
    //div.className="td1";  
    var innerText="<TABLE border=0.5 width=200><TR align='right' bgcolor='lightblue'><TD colspan=2><button onclick='RemoveAllDiv(0)'>关闭</button></TD></TR>"
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
}
function EDDblClick(e)
{

	//var EDID=e.value;
	var eSrc=window.event.srcElement;
	var EDID=event.srcElement.getAttribute("value");

	RemoveAllDiv(1);
	var obj=document.getElementById("EditAdvice");
	if (obj){
		AddDiagnosis(EDID);
	}else{
		AddEDInfo(EDID);
	}
	 var div=document.getElementById("editBehaviorDiv");  
    if(div!=null)  
        document.body.removeChild(div);  
}
function AddDiagnosis(EDID)
{
 
	var ID=EDID.split("^")[0];
	var SSIDObj=document.getElementById("SSID");
	if (SSIDObj) var SSID=SSIDObj.value;
	var obj=document.getElementById("AddEDClass");
	if (obj) var encmeth=obj.value;
	if (SSID=="") {alert(t["NoSS"]);return false;}
	var MainDoctor="";
	var obj=document.getElementById("MainDoctor");
	if (obj) MainDoctor=obj.value;
	var flag=cspRunServerMethod(encmeth,SSID,ID,"0",MainDoctor);
	var Arr=flag.split("^");
	if (Arr[0]==0){
		
		InsertNewRow(Arr[1],Arr[2],Arr[3],Arr[4]);
		DragRowsMove("EditAdvice");
		return false;
		//location.reload(); 
		var obj=document.getElementById("GetAdviceByStation");
		if (obj) encmeth=obj.value;
		//GSID,CurStation,MainDoctorFlag
		var ret=cspRunServerMethod(encmeth,SSID,CurID,MainDoctor);
		var Char_1=String.fromCharCode(1);
		var Arr=ret.split(Char_1);
		var ID=Arr[0];
		var Info=Arr[1];
		var obj=document.getElementById(ID);
		if (obj) obj.innerHTML=Info;
		return false;
	}
	alert(t[flag]);
	return false;
}
function AddEDInfo(EDID)
{

	var encmeth="",PAADM="";
	var obj=document.getElementById("GetEDInfoByID");
	if (obj) encmeth=obj.value;
	var obj=document.getElementById("EpisodeID");
	if (obj) PAADM=obj.value;
	var Info=cspRunServerMethod(encmeth,EDID,PAADM);
	obj=document.getElementById("GSSDetail");
	if (obj) GSSDetail=obj.value;
	var Length=GSSDetail.split("、[").length;
	obj.value=GSSDetail+String.fromCharCode(13,10)+String.fromCharCode(13,10)+Length+Info;
}
function InsertNewRow(SDID,Desc,Advice,Sort)
{
	var TableObj=document.getElementById("EditAdvice");
	var newTR = TableObj.insertRow(TableObj.rows.length);
	var newTD=newTR.insertCell(0);
	newTD.innerHTML = TableObj.rows.length-1;
	var newTD=newTR.insertCell(1);
	newTD.innerHTML = "<input type='checkbox' id="+SDID+"^MD checked>";
	var newTD=newTR.insertCell(3);
	newTD.innerHTML = "<textarea onpropertychange='setTareaAutoHeight(this)' style='width:100%;white-space:normal; word-break:break-all;' id='"+SDID+"^JL'>"+Desc+"</textarea>";
	var newTD=newTR.insertCell(4);
	newTD.innerHTML = "<textarea onpropertychange='setTareaAutoHeight(this)' style='width:100%;white-space:normal; word-break:break-all;' id='"+SDID+"^JY'>"+Advice+"</textarea>";
	var newTD=newTR.insertCell(2);
	newTD.innerHTML = "<input type='checkbox' name='Unite' id='"+SDID+"^HB'>";
	var newTD=newTR.insertCell(5);
	newTD.innerHTML = "<button onclick='DeleteAdvice(this,1)' name='DeleteButton' id='"+SDID+"'><font color=red>×</font></button>";
}
/*
function AddEDInfo(EDID)
{
	var encmeth="",PAADM="";
	var obj=document.getElementById("GetEDInfoByID");
	if (obj) encmeth=obj.value;
	var obj=document.getElementById("EpisodeID");
	if (obj) PAADM=obj.value;
	var Info=cspRunServerMethod(encmeth,EDID,PAADM);
	obj=document.getElementById("GSSDetail");
	if (obj) GSSDetail=obj.value;
	var Length=GSSDetail.split("、[").length;
	obj.value=GSSDetail+String.fromCharCode(13)+Length+Info;
}
*/
function RemoveAllDiv(Type)
{
		var div=document.getElementById("ODSDiv");  
		if (div!=null) document.body.removeChild(div);
		var div=document.getElementById("editBehaviorDiv");  
		if (div!=null) document.body.removeChild(div);
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
function ShowCheckResult()
{
	var iEpisodeID="",obj;
	obj=document.getElementById("EpisodeID");
	if (obj) { iEpisodeID=obj.value; }
  	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisclinicQueryOEItem"
   	+"&EpisodeID="+iEpisodeID;
  	var wwidth=600;
  	var wheight=400;
  	var xposition = (screen.width - wwidth) / 2;
  	var yposition = (screen.height - wheight) / 2;
  	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
   	+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
   	;
 	var cwin=window.open(lnk,"_blank",nwin);
 	return false;
}
function QMManager()
{
	var iEpisodeID="",obj;
	obj=document.getElementById("EpisodeID");
	if (obj) { iEpisodeID=obj.value; }
  	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEQualityManager"
   	+"&PAADM="+iEpisodeID;
  	var wwidth=600;
  	var wheight=400;
  	var xposition = (screen.width - wwidth) / 2;
  	var yposition = (screen.height - wheight) / 2;
  	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
   	+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
   	;
 	var cwin=window.open(lnk,"_blank",nwin);
 	return false;
}

function QueryED_KeyDown(e,loc)
{
	var Key=websys_getKey(e); 
	if ((13==Key)) 
	{
		var ret=tkMakeServerCall("web.DHCPE.MainDiagnosisNew","GetEDInfoByStation",loc,"",e.value);
		document.getElementById("edprefix").innerHTML = ret;
	}
	
}