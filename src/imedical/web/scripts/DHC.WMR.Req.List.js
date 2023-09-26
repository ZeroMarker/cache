var iSeldRow=0
var tmpChinese
//var TransferItemDr = GetParam(window, "TransferItemDr")


function BodyClick(){
	var evtElement=event.srcElement.id;
	
	if (evtElement.lastIndexOf("cmdTransfer")==0){
		  var rowIndex=parseInt(evtElement.substr(12,evtElement.length-12));
		  var obj=document.getElementById("reqRowIdz"+rowIndex);
		  var ReqRowId=""
		  if (obj){
			   ReqRowId=obj.value;
			   }
			if (ReqRowId=="") return false;
			if (getElementValue("MrIsStayInz"+rowIndex)!="No"){
				alert(t["IsStayIn"]);
				return false;
				}
		  var TransferItemDr=getElementValue("TransferItemDr");
			var UserId=session['LOGON.USERID'];
		  var ret=TransferReq("MTransfer", ReqRowId, TransferItemDr, UserId)
		  if (parseInt(ret)>=0){
		  	window.location.reload(); // 2009-08-06
		  	}
		  else{
		  	alert(t["TransferFalse"]+ret);
		  	}
		}
	}
function BodyLoadHandler() {
	
	var obj=document.getElementById("cmdPrintCard");
	if (obj){obj.onclick=PrintCard_click;}
	var obj=document.getElementById("cmdPrintReport");
	if (obj){obj.onclick=PrintReport_click;}
	var obj=document.getElementById("chkAll");
	if (obj){obj.onclick=chkAll_click;}
	var obj=document.getElementById("chkStayIn");
	if (obj){obj.onclick=chkStayIn_click;}
	var obj=document.getElementById("chkNotStayIn");
	if (obj){obj.onclick=chkNotStayIn_click;}
		
	iniForm();
	
	// Add By LiYang 2009-7-23 automaically print request slip
	document.getElementById("chkStayIn").checked = true;
	chkStayIn_click();
	Print_Card();
}
function iniForm() {
	/*
	var tmpobj=document.getElementById('PatNamez1');
	var objTD=tmpobj.parentElement;
	var objTR=objTD.parentElement;
	objTR.bgColor="&ff0000";
	objTR.className="";
	*/
	 tmpChinese=GetChinese("MethodGetChinese","DHC.WMR.Req.List");
	var objTable = document.getElementsByTagName("table")[1];
	var strBGM = "<BGSOUND id=BGM src=''/>";
	 var strPrinter = "<OBJECT ID='clsWMRBarCode' CLASSID='CLSID:A4CB0799-8BBD-41E4-ABC3-CD1FC62B7338' CODEBASE='../addins/client/DHCMedVBPrinter.CAB#version=1,0,0,0'>aaasssssssss</OBJECT>";
         objTable.rows[0].cells[0].appendChild(document.createElement(strPrinter));	
         objTable.rows[0].cells[0].appendChild(document.createElement(strBGM));	
         SetColor();
}
function PrintCard_click() {
	Print_Card();
}
function PrintReport_click() {
	Print_Table();
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
  objPrinter = new ActiveXObject("DHCMedVBPrinter.clsPrinter");
  if (objPrinter){
	intYPage=0;
	for(var i = 0; i < objArry.length; i ++)
	{
		objPrinter.Font = tmpChinese[0];
		objPrinter.FontBold  = true;
		objPrinter.FontSize = 13;
		
		intYPos = 1;
		objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[3]);
		intYPos ++;
		obj = objArry[i];
		if (obj.EmergencyDesc=="Yes") {
			objPrinter.PrintContents(LeftMarge + 2, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[4]+" "+tmpChinese[17]);
		}else{
			objPrinter.PrintContents(LeftMarge + 2.4, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[4]);
		}
		intYPos ++;
		
		objPrinter.Font = tmpChinese[2];
		objPrinter.FontSize = 11; 
		objPrinter.FontBold = false;
		if (obj) {
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[5]+":"+obj.CardNo);
			intYPos ++;
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[6]+":"+obj.PatName);
			intYPos ++;
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[8]+":"+obj.MrNo);
			intYPos ++;
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[9]+":"+obj.ReqLocDesc);
			intYPos ++;
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[14]+":"+obj.RegfeeDoc);
			intYPos ++;
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[15]+":"+obj.RequestDate+" "+obj.RequestTime);
			intYPos ++;
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[15]+":"+obj.RegDate+" "+obj.RegTime);
			intYPos ++;
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[18]+":"+obj.ReqUpLocDesc);
			intYPos ++;
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[12]+":"+obj.ReqTypeDesc);
			intYPos ++;
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[13]+":"+obj.WorkItemDesc);
			intYPos ++;
			
			/*
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[11]+":"+obj.AimDate);
			intYPos ++;
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[10]+":"+obj.ReqUserName);
			intYPos ++;
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[16]+":"+obj.RegTimeRange);
			intYPos ++;
			objPrinter.PrintContents(LeftMarge + 0, TopMarge + PageHeight * intYPage + LineHeight * intYPos, tmpChinese[7]+":"+obj.MrTypeDesc);
			intYPos ++;
			*/
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


function ClearSendOut(i)
{
	if( getElementValue("MrIsStayInz"+i) != "Yes")
	{
		var objbtn = document.getElementById("cmdTransferz"+i);
		//window.alert(objbtn);
		objbtn.click();
	}
}

function SortData()
{	
	var objArry = new Array();
	var objtbl=document.getElementById('tDHC_WMR_Req_List');
	var rows=objtbl.rows.length;
	for (i=1;i<rows;i++)
	{
		//ClearSendOut(i);
		var SelRowObj=document.getElementById('chkPrintz'+i);
		if (SelRowObj)
		{
			var val=SelRowObj.checked;
			if (val)
			{
				var obj = PrintReportItem();
				obj.ReqID = getElementValue("reqRowIdz" + i);
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
				//add by zf 2008-03-26
				obj.CardNo=getElementValue("CardNoz"+i);
				obj.RegfeeDocId=getElementValue("RegfeeDocIdz"+i);
				obj.RegfeeDoc=getElementValue("RegfeeDocz"+i);
				obj.RegDate=getElementValue("RegDatez"+i);
				obj.RegTime=getElementValue("RegTimez"+i);
				obj.RegTimeRange=getElementValue("RegTimeRangez"+i);
				obj.ReqUpLocDesc=getElementValue("AimUpCtlocDescz"+i);
				obj.RequestDate=getElementValue("RequestDatez"+i);
				obj.RequestTime=getElementValue("RequestTimez"+i);
				obj.PatientID=getElementValue("PatientIdz"+i);
				obj.PrintFlag=getElementValue("PrintFlagz"+i);
				obj.IsStayIn = getElementValue("MrIsStayInz"+i);
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
	var objtbl=document.getElementById('tDHC_WMR_Req_List');
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

//by zf 2008-04-07
function chkStayIn_click()
{
	var obj=document.getElementById('chkAll');
	if (obj){obj.checked=false;}
	var obj=document.getElementById('chkNotStayIn');
	if (obj){obj.checked=false;}
	var obj=document.getElementById('chkStayIn');
	if (obj){
		if (obj.checked==true){
			SetchkPring("1");
		}else{
			SetchkPring("4");
		}
	}
}

function chkNotStayIn_click()
{
	var obj=document.getElementById('chkAll');
	if (obj){obj.checked=false;}
	var obj=document.getElementById('chkStayIn');
	if (obj){obj.checked=false;}
	var obj=document.getElementById('chkNotStayIn');
	if (obj){
		if (obj.checked==true){
			SetchkPring("2");
		}else{
			SetchkPring("4");
		}
	}
}

function chkAll_click()
{
	var obj=document.getElementById('chkNotStayIn');
	if (obj){obj.checked=false;}
	var obj=document.getElementById('chkStayIn');
	if (obj){obj.checked=false;}
	var obj=document.getElementById('chkAll');
	if (obj){
		if (obj.checked==true){
			SetchkPring("3");
		}else{
			SetchkPring("4");
		}
	}
}

function SetchkPring(flg)
{ 
	var objtbl=document.getElementById('tDHC_WMR_Req_List');
	if (objtbl) {
		var rows=objtbl.rows.length;
		for (i=1;i<rows;i++){
			var SelRowObj=document.getElementById('MrIsStayInz'+i);
			var SelRowObj1=document.getElementById('chkPrintz'+i);
			var PrintFlag=document.getElementById('PrintFlagz'+i).value;
			if ((SelRowObj)&&(SelRowObj1)){
				var txt=SelRowObj.innerText;
				//if (((txt=="Yes")&&(flg=="1")&&(PrintFlag!="Y"))||((txt=="No")&&(flg=="2"))||(flg==3)){
				if (((true)&&(flg=="1")&&(PrintFlag!="Y"))||((txt=="No")&&(flg=="2"))||(flg==3)){
					SelRowObj1.checked=true;
				}else{
					SelRowObj1.checked=false;
				}
			}
		}
	}
}

document.body.onload = BodyLoadHandler;
document.body.onclick = BodyClick;

//***************************by zf add 2008-04-09*****************************

function Print_Table()
{
	var objPrinter = new ActiveXObject("DHCMedWebPackage.clsPrinter"); 
	if(objPrinter == null)
	{
		window.alert("fail to init Printer Control");
		return;	
	}
	
	var objArry = SortData();
	if (!objArry) return fasle;
	if (objArry.length<=0) return false;
	var obj = null;
	
	var pLeft=0.5,pTop=1.5,rowHeight=0.6,titleHeight=1;
	var intRow = 0, CurrLeft = 0, CurrTop = 0;
	objPrinter.FontSize = 15;
	objPrinter.FontBold = true;
	CurrLeft = pLeft + 5, CurrTop = pTop + 0;
	objPrinter.PrintContents(CurrLeft, CurrTop, t["ReportTitle"]);
	CurrLeft = pLeft, CurrTop = CurrTop + titleHeight;
	
	objPrinter.fontSize = 11;
	objPrinter.FontBold = false;
	Print_Title(objPrinter,CurrLeft,CurrTop);
	CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
	
	for(var i = 0; i < objArry.length; i ++)
	{
		obj = objArry[i];
		Print_Row(objPrinter,CurrLeft, CurrTop,obj);
		CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
		intRow ++;
		if ((intRow > 40)&&(i < objArry.length))
		{
			objPrinter.NewPage();
			intRow = 0, CurrLeft = 0, CurrTop = 0;
			objPrinter.FontSize = 15;
			objPrinter.FontBold = true;
			CurrLeft = pLeft + 7, CurrTop = pTop + 0;
			objPrinter.PrintContents(CurrLeft, CurrTop, t["ReportTitle"]);
			CurrLeft = pLeft, CurrTop = CurrTop + titleHeight;
			
			objPrinter.fontSize = 11;
			objPrinter.FontBold = false;
			Print_Title(objPrinter,CurrLeft,CurrTop);
			intRow= intRow + 1;
			CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
		}
	}
	objPrinter.EndDoc();
}

function Print_Row(objPrinter,CurrLeft,CurrTop,obj)
{	
	objPrinter.PrintContents(CurrLeft,CurrTop, obj.ReqLocDesc);
	CurrLeft=CurrLeft + 3.5;
	objPrinter.PrintContents(CurrLeft,CurrTop, obj.MrNo);
	CurrLeft=CurrLeft + 2.5;
	objPrinter.PrintContents(CurrLeft,CurrTop, obj.PatName);
	CurrLeft=CurrLeft + 2;
	objPrinter.PrintContents(CurrLeft,CurrTop, obj.RegfeeDoc);
	CurrLeft=CurrLeft + 3;
	objPrinter.PrintContents(CurrLeft,CurrTop, obj.RequestDate+" "+obj.RequestTime);
	CurrLeft=CurrLeft + 4;
	objPrinter.PrintContents(CurrLeft,CurrTop, obj.ReqUpLocDesc); 
}

function Print_Title(objPrinter,CurrLeft,CurrTop)
{
	objPrinter.PrintContents(CurrLeft,CurrTop, t['ReqDep']);
	CurrLeft=CurrLeft + 3.5;
	objPrinter.PrintContents(CurrLeft,CurrTop, t['MrNo']);
	CurrLeft=CurrLeft + 2.5;
	objPrinter.PrintContents(CurrLeft,CurrTop, t['PatName']);
	CurrLeft=CurrLeft + 2;
	objPrinter.PrintContents(CurrLeft,CurrTop, t['RegfeeDoc']);
	CurrLeft=CurrLeft + 3;
	objPrinter.PrintContents(CurrLeft,CurrTop, t['ReqDate']);
	CurrLeft=CurrLeft + 4;
	objPrinter.PrintContents(CurrLeft,CurrTop, t['ProDep']);
}

function Print_Card(){
{

	var objPrinter = new ActiveXObject("DHCMedVBPrinter.clsPrinter"); 
	if(objPrinter == null)
	{
		window.alert("fail to init Printer Control");
		return;	
	}
	//get date array
	var objArry = SortData();
	if (!objArry) return fasle;
	if (objArry.length<=0) return false;
	var obj = null;
	var objBGM = document.getElementById("BGM"); //Background music
	if(objArry.length > 0)
	{
		objBGM.src = "../images/tada.wav";
	}
	
	for(var i = 0; i < objArry.length; i ++)
	{
		var pLeft=0.5,pTop=1,rowHeight=0.6,titleHeight=1;
		var intRow = 0, CurrLeft = pLeft, CurrTop = pTop;
		obj = objArry[i];
		//if (i>0) {
		//	CurrLeft = pLeft;
		//	CurrTop = CurrTop + pTop;
		//}
		
		//Title
		objPrinter.FontSize = 13;
		objPrinter.FontBold = true;
		var OMrType=GetParam(window.parent, "OMrType");//add by liuxuefeng 2010-01-17
		var IMrType=GetParam(window.parent, "IMrType");//add by liuxuefeng 2010-01-17
		//alert("OMrType="+OMrType+";IMrType="+IMrType);
		var objInPatMrNo = GetDHCWMRMainByPapmi("MethodGetMainByPapmi", IMrType,obj.PatientID); //InPatient Mr No
		var objOutPatMrNo = GetDHCWMRMainByPapmi("MethodGetMainByPapmi", OMrType,obj.PatientID); //OutPatient Mr No
		if(objOutPatMrNo == null)
		{
			objOutPatMrNo = new DHCWMRMain();
		}
		if(objInPatMrNo == null)
		{
			objInPatMrNo = new DHCWMRMain();
		}		
		//objPrinter.PrintContents(CurrLeft + 0, CurrTop, t["cCardTitle"]);   //comment by LiYang 2009-07-22
		//CurrLeft = pLeft, CurrTop = CurrTop + titleHeight;
		
		//Sub Title
		if (obj.EmergencyDesc=="Yes") {
			objPrinter.PrintContents(CurrLeft + 1,CurrTop, t['cCardSubTitle'] + " " + t['cCardEmergencyDesc']);
		}else{
			objPrinter.PrintContents(CurrLeft + 1.5,CurrTop, t['cCardSubTitle']);
		}
		CurrLeft = pLeft, CurrTop = CurrTop + titleHeight;
		
		//Card Info
		objPrinter.FontSize = 11;
		objPrinter.FontBold = false;
		//objPrinter.PrintContents(CurrLeft,CurrTop, t['cCardNo']+":"+obj.CardNo);
		//CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
		objPrinter.FontBold = true;
		objPrinter.FontSize = 15;		
		objPrinter.PrintContents(CurrLeft,CurrTop, t['cPatName']+":"+obj.PatName);
		CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
		objPrinter.PrintContents(CurrLeft,CurrTop, t['cMrNo']+":   "+formatMrNo(objOutPatMrNo.MRNO));
		CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
		objPrinter.PrintContents(CurrLeft,CurrTop, "类别: " + objOutPatMrNo.ResumeText);
		CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
		if(objOutPatMrNo.MRNO!="")
			objPrinter.PrintContents(CurrLeft,CurrTop, "病案状态:"+(objOutPatMrNo.IsStayIn ? "在架" : "已送出"));
		else
			objPrinter.PrintContents(CurrLeft,CurrTop, "病案状态:");
		CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
		///////////
		objPrinter.PrintContents(CurrLeft,CurrTop, t['InPatMrNo']+":   "+formatMrNo(objInPatMrNo.MRNO)); //Add By LiYang 2009-7-22 Print Inpatient No to slip
		CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
		objPrinter.PrintContents(CurrLeft,CurrTop, "类别: " + objInPatMrNo.ResumeText);
		CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
		if(objInPatMrNo.MRNO!="")
			objPrinter.PrintContents(CurrLeft,CurrTop, "病案状态:"+(objInPatMrNo.IsStayIn ? "在架" : "已送出"));
		else
			objPrinter.PrintContents(CurrLeft,CurrTop, "病案状态:");	
		CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;						
		objPrinter.PrintContents(CurrLeft,CurrTop, t['cReqLocDesc']+":"+obj.ReqLocDesc);
		CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
		objPrinter.PrintContents(CurrLeft,CurrTop, t['cRegfeeDoc']+":"+obj.RegfeeDoc);
		/////		
		objPrinter.FontSize = 11;
		objPrinter.FontBold = false;			
		CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
		objPrinter.PrintContents(CurrLeft,CurrTop, t['cReqDateTime']+":"+obj.RequestDate+" "+obj.RequestTime);
		CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
		objPrinter.PrintContents(CurrLeft,CurrTop, t['cRegDateTime']+":"+obj.RegDate+" "+obj.RegTime);
		CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
		objPrinter.PrintContents(CurrLeft,CurrTop, t['cReqUpLocDesc']+":"+obj.ReqUpLocDesc);
		CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
		objPrinter.PrintContents(CurrLeft,CurrTop, t['cReqTypeDesc']+":"+obj.ReqTypeDesc);
		CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
		objPrinter.PrintContents(CurrLeft,CurrTop, t['cWorkItemDesc']+":"+obj.WorkItemDesc);
		CurrLeft = pLeft, CurrTop = CurrTop + rowHeight + rowHeight;
		
		objPrinter.EndDoc();
		cspRunServerMethod(
			getElementValue("MethodUpdatePrintFlag"),
			obj.ReqID);  //Add By LiYang 2009-07-24  update print flag so every slip will be printed only once.
	}
  }
}
//************************************end***********************************

function formatMrNo(No)
{
	var tmp = "";
	for(var i = 0; i < No.length ; i ++)
	{
		tmp += No.substr(i,1) + " ";
	}
	return tmp;
}