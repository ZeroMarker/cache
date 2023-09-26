var CurObj;
var CurID;
var EDDesc="";
var CloseODSDivFlag="1";

document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	//alert("1")
	SetRoomInfo();
	//alert("2")
	CreateRoomRecordList();
	//alert("33")
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
	document.onkeydown=Doc_OnKeyDown;
		
}

function Doc_OnKeyDown(){
	//alert(event.keyCode+"lllyyyaaa")
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

function MoveFocus(e,NumFlag) 
{
	//alert(e.readOnly)
	//alert(event.keyCode)
	if ((e.readOnly)&&(event.keyCode==8)) window.event.returnValue = false;
	if ((event.keyCode==13)||(event.keyCode==40)){
		event.keyCode=9;
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
    div.style.left=op[1]+20;  
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
	EDDesc=Desc;
	var Info=cspRunServerMethod(encmeth,ChartID,Desc);
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
	var EDID=e.value;
	AddDiagnosis(EDID);				
	if (!CurID) return false;
	var Arr=CurID.split("^");
	var OrderID=Arr[0];
	var ODID=Arr[1];
	var RObj=document.getElementById(OrderID+"^"+ODID);
	var NObj=document.getElementById(OrderID+"^"+ODID+"S");
	if (RObj&&NObj){
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
	//setCaret(CurObj);
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
		var Divleft=op[1]+20;
	//}
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
    var innerText="<TABLE border=0.5 width=360><TR align='left' bgcolor='lightblue'><TD colspan=3><button onclick='RemoveAllDiv(1)'>关闭</button>&nbsp;&nbsp;<button onclick='ResumeDefault()'>恢复默认</button></TD></TR>"
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
	if (Info!=""){
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
	var NatureObj=document.getElementById(CurObj.id+"S");
	if (NatureObj) NatureDesc=NatureObj.innerText;
	if (Strs==NatureDesc){
		CurObj.value=Strs;
	}else if (CurObj.value==NatureDesc){
		CurObj.value="";
		insertAtCaret(CurObj, Strs);
	}else{
		insertAtCaret(CurObj, Strs);
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
	    textObj.caretPos = document.selection.createRange().duplicate();
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
function SavePEResult(e,CompleteFlag)
{
	var ButtonID=e.id;
	var ObjArr=document.getElementsByName(ButtonID);
	var ArrLength=ObjArr.length;
	if (e.innerText=="修改结果")
	{
		for (var i=0;i<ArrLength;i++)
		{
			//if (ObjArr[i].type=='button') continue;
			ObjArr[i].disabled=false;
			ObjArr[i].readOnly=false;
		}
		var encmeth=GetValue("CancelExecuteClass",1);
		var ret=cspRunServerMethod(encmeth,ButtonID)
		e.innerText="保存结果"
		return false;
	}
	
	
	var ResultInfo="";
	var Char_1=String.fromCharCode(1);
	for (var i=0;i<ArrLength;i++)
	{
		var ResultID=ObjArr[i].id;
		var Value=ObjArr[i].value;
		var OneInfo=ResultID+"^"+Value;
		if (ResultInfo==""){
			ResultInfo=OneInfo;
		}else{
			ResultInfo=ResultInfo+Char_1+OneInfo;
		}
	}
	
	var encmeth="";
	var obj=document.getElementById("SaveResult");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,ResultInfo,"","");
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
		}
		e.disabled=false;
		if (RetArr[2]!="NA"){
			window.location.reload();
		}else{
			if (parent.frames("query"))
			{
				parent.frames("query").websys_setfocus("RegNo");
			}
		}
	}else{
		alert(RetArr[1]);
	}
}
//function SendPEMessage(e)
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
	var DeleteObj=document.getElementsByName("DeleteED");
	var ArrLength=DeleteObj.length;
	for (var i=ArrLength;i>0;i--)
	{
		DeleteEDInfo(DeleteObj[i-1],0);
	}
	
}


