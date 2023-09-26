var iSeldRow=0;
var tmpChinese;
var OMrType = document.getElementById("OMrType").value;
var IMrType = document.getElementById("IMrType").value;
var sWorkItem= document.getElementById("sWorkItem").value;
var sReqType= document.getElementById("sReqType").value;
var PatientID="";
var EpisodeID="";

function BodyClick(){
	var PatientID="",EpisodeID="",ret="";
	var evtElement=event.srcElement.id;
	if (evtElement.lastIndexOf("cmdRequest")==0){
		var rowIndex=parseInt(evtElement.substr(11,evtElement.length-11));
		var ReqRowId="";
		var obj=document.getElementById("reqRowIdz"+rowIndex);
		if (obj){ReqRowId=obj.value;}
		var obj=document.getElementById("PatientIdz"+rowIndex);
		if (obj){PatientID=obj.value;}
		var obj=document.getElementById("Paadmz"+rowIndex);
		if (obj){EpisodeID=obj.value;}
		if (ReqRowId!==""){
			var obj=document.getElementById('MethodSetFirstFlag');
		    if (obj) {var encmeth=obj.value} else {var encmeth=''}
		    var ret=cspRunServerMethod(encmeth,ReqRowId);
		    if (ret<0){
			    alert(t["SetFirstFlag]"]);
			}
		}else if((PatientID!=="")&&(EpisodeID!=="")){
			//alert(PatientID+"  "+EpisodeID+"  "+OMrType+"  "+IMrType+"  "+sWorkItem+"  "+sReqType);
			WMR_NewRequest(PatientID,EpisodeID,OMrType,IMrType,sWorkItem,sReqType);
		}
		window.location.reload();
		
	}
}

function BodyLoadHandler() {
	
	var obj=document.getElementById("cmdPrintCard");
	if (obj){obj.onclick=PrintCard_click;}
	var obj=document.getElementById("cmdPrintReport");
	if (obj){obj.onclick=PrintReport_click;}
	iniForm();
}

function cmdRequest_click(){
	
}

function iniForm() {
	/*
	var tmpobj=document.getElementById('PatNamez1');
	var objTD=tmpobj.parentElement;
	var objTR=objTD.parentElement;
	objTR.bgColor="&ff0000";
	objTR.className="";
	*/
	 tmpChinese=GetChinese("MethodGetChinese","DHC.WMR.ReqFirstFlag.List");
	 
	 SetColor();
}
function PrintCard_click() {
	PrintCard();
}
function PrintReport_click() {
	PrintReport();
}

function PrintCard(){
  var objPatient = null;
  var objMrPatient = null;
  var intYPos = 0;
  var LeftMarge = 0.5;
  var TopMarge = 1.5;
  var LineHeight = 0.7;
  var PageHeight= 11;
  var strPapmi = "";
  var strMainID = "";
  var objArry = SortData();
  if (!objArry) return fasle;
  if (objArry.length<=0) return false;
  var obj = null;
  objPrinter = new ActiveXObject("DHCMedWebPackage.clsPrinter");
  if (objPrinter){
	intYPage=0;
	for(var i = 0; i < objArry.length; i ++)
	{
		objPrinter.Font = tmpChinese[0];
		objPrinter.FontBold  = true;
		objPrinter.FontSize = 15;
		
		intYPos = 1;
		objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[3]);
		intYPos ++;
		obj = objArry[i];
		if (obj.EmergencyDesc="Yes") {
			objPrinter.PrintContents(LeftMarge + 2, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[4]+" "+tmpChinese[17]);
		}else{
			objPrinter.PrintContents(LeftMarge + 2.4, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[4]);
		}
		intYPos ++;
		
		objPrinter.Font = tmpChinese[2];
		objPrinter.FontSize = 11; 
		objPrinter.FontBold = false;
		if (obj) {
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[5]+obj.CardNo);
			intYPos ++;
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[6]+obj.PatName);
			intYPos ++;
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[7]+obj.MrTypeDesc);
			intYPos ++;
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[8]+obj.MrNo);
			intYPos ++;
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[9]+obj.ReqLocDesc);
			intYPos ++;
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[10]+obj.ReqUserName);
			intYPos ++;
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[11]+obj.AimDate);
			intYPos ++;
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[12]+obj.ReqTypeDesc);
			intYPos ++;
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[13]+obj.WorkItemDesc);
			intYPos ++;
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[14]+obj.RegfeeDoc);
			intYPos ++;
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[15]+obj.RegDate+" "+obj.RegTime);
			intYPos ++;
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[16]+obj.RegTimeRange);
			intYPos ++;
		}
		intYPage ++;
	} 
	objPrinter.EndDoc();
  }
}

function PrintReport()
{
  var objPatient = null;
  var objMrPatient = null;
  var intYPos = 0;
  var LeftMarge = 0.5;
  var TopMarge = 1.5;
  var LineHeight = 0.7;
  var strPapmi = "";
  var strMainID = "";
  var objArry = SortData();
  if (!objArry) return fasle;
  if (objArry.length<=0) return false;
  var obj = null;
  objPrinter = new ActiveXObject("DHCMedWebPackage.clsPrinter");
  if (objPrinter){
	  objPrinter.Font = tmpChinese[0];
	  objPrinter.FontBold  = true;
	  objPrinter.FontSize = 15;
	  
	  objPrinter.PrintContents(LeftMarge + 2, TopMarge-0.5 + 0, tmpChinese[1]);
	   
	  objPrinter.Font = tmpChinese[2];
	  objPrinter.FontSize = 11; 
	  objPrinter.FontBold = false;
	  
	  intYPos = 1;
	  for(var i = 0; i < objArry.length; i ++)
	  {
		    obj = objArry[i];
	        objPrinter.PrintContents(LeftMarge + 0 , TopMarge + LineHeight * intYPos, obj.MrTypeDesc);
	        objPrinter.PrintContents(LeftMarge + 3, TopMarge + LineHeight * intYPos, obj.MrNo);
	        objPrinter.PrintContents(LeftMarge + 4, TopMarge + LineHeight * intYPos, obj.PatName);
	        
	        objPrinter.PrintContents(LeftMarge + 6, TopMarge + LineHeight * intYPos, obj.ReqTypeDesc);
	        objPrinter.PrintContents(LeftMarge + 8, TopMarge + LineHeight * intYPos, obj.WorkItemDesc);
	        objPrinter.PrintContents(LeftMarge + 10, TopMarge + LineHeight * intYPos, obj.AimDate);
	        objPrinter.PrintContents(LeftMarge + 12, TopMarge + LineHeight * intYPos, obj.ReqLocDesc);
	        objPrinter.PrintContents(LeftMarge + 14, TopMarge + LineHeight * intYPos, obj.ReqUserName);
	        objPrinter.PrintContents(LeftMarge + 16, TopMarge + LineHeight * intYPos, obj.PatientNo);
	        
	        intYPos ++;
	        if(intYPos >= 40)
	       {
	            objPrinter.NewPage();
	            intYPos = 0;
	       } 
	  }  
	  objPrinter.EndDoc();
  }
}

function SortData()
{	
	var objArry = new Array();
	var objtbl=document.getElementById('tDHC_WMR_Req_List');
	var rows=objtbl.rows.length;
	for (i=1;i<rows;i++)
	{
		var SelRowObj=document.getElementById('chkPrintz'+i);
		if (SelRowObj)
		{
			var val=SelRowObj.checked;
			if (val)
			{
				var obj = PrintReportItem();
				obj.MrTypeDesc = getElementValue("MrTypeDescz"+i);
				obj.MrNo = getElementValue("MrNoz"+i);
				obj.PatName = getElementValue("PatNamez"+i);
				obj.ReqTypeDesc = getElementValue("ReqTypeDescz"+i);
				obj.WorkItemDesc = getElementValue("WorkItemDescz"+i);
				obj.AimDate = getElementValue("AimDatez"+i);
				obj.ReqLocDesc = getElementValue("AimCtlocDescz"+i);
				obj.ReqUserName = getElementValue("AimUserNamez"+i);
				obj.PatientNo = getElementValue("PatNoz"+i);
				obj.EmergencyDesc=getElementValue("EmergencyDescz"+i);
				//2008-03-26 ZF Add
				obj.CardNo=getElementValue("CardNoz"+i); 
				obj.RegfeeDocId=getElementValue("RegfeeDocIdz"+i);
				obj.RegfeeDoc=getElementValue("RegfeeDocz"+i);
				obj.RegDate=getElementValue("RegDatez"+i);
				obj.RegTime=getElementValue("RegTimez"+i);
				obj.RegTimeRange=getElementValue("RegTimeRangez"+i);
				objArry.push(obj);
				}
			}
		
	  }
	return objArry;
}

function PrintReportItem()
{
	var obj = new Object();
	obj.MrTypeDesc = "";
	obj.MrNo = "";
	obj.PatName = "";
	obj.ReqTypeDesc = "";
	obj.WorkItemDesc = "";
	obj.AimDate = "";
	obj.ReqLocDesc = "";
	obj.ReqUserName = "";
	obj.PatientNo = "";
	return obj;
}
function SetColor(){
	var objtbl=document.getElementById('tDHC_WMR_ReqFirstFlag_List');
	if (objtbl) {
		var rows=objtbl.rows.length;
		for (i=1;i<rows;i++){
			var SelRowObj=document.getElementById('EmergencyDescz'+i);
			if (SelRowObj)
			{
				var txt=SelRowObj.innerText;
				if (txt=="Yes")
				{
					var objTD=SelRowObj.parentElement;
					if (objTD)
				   {
				   	 objTD.bgColor="&FF0000";
				   	}
				  }
			 }
			 
			var SelRowObj=document.getElementById('MrIsStayInz'+i);
			if (SelRowObj)
			{
				var txt=SelRowObj.innerText;
				if (txt=="No")
				{
					var objTD=SelRowObj.parentElement;
					if (objTD){objTD.bgColor="#999999";}
				}
			}
		}
	}
}
document.body.onload = BodyLoadHandler;
document.body.onclick = BodyClick;