// DHCRisWorkBenchEx.JS
//document.write("<OBJECT ID='CPrintExamItem' CLASSID='CLSID:54C13357-859D-4C53-BC5A-DB5B9980530F' CODEBASE='../addins/client/PrintPaidItem.CAB#version=2,0,0,4'>");
//document.write("</object>");

//document.write("<OBJECT ID='CHZtoPin' CLASSID='CLSID:023BDCF4-D87F-4915-8517-BA1BC4EC6D02' CODEBASE='../addins/client/HZPIN.CAB#version=1,2,0,2'>")
//document.write("</object>");
//
//CHL7
//document.write("<OBJECT ID='HL7Com' CLASSID='CLSID:0FC82ED2-1DF5-4D4D-AF10-CBF9C7BBF8EE' CODEBASE='../addins/client/DHCRis.cab#version=1,0,1,1'>");
///document.write("</object>");


//document.write("<OBJECT ID='aa1' CLASSID='CLSID:B2C2C2F6-226D-42DB-97F7-F7A0FF629A2F' CODEBASE='../addins/client/testalt1.CAB#version=1,0,0,1'>")
//document.write("</object>");

//CHL7
//document.write("<OBJECT ID='RptPrint' CLASSID='CLSID:225ABCE7-5EBD-405A-9273-271EB776E8E2' id='ReportPrintOcx' name='ReportPrintOcx'  CODEBASE='../addins/client/RptPrint.CAB#version=1,0,0,1',width='0' height='0'>");
//document.write("</object>");


//document.write("<OBJECT ID='ReportPrint' CLASSID='CLSID:C8336DD8-A958-42EC-A13E-120CFB541306' CODEBASE='../addins/client/ReportPrint.CAB#version=1,0,0,0',width='0' height='0'>");
//document.write("</object>");

//document.write("<OBJECT ID='RptPrint' CLASSID='CLSID:225ABCE7-5EBD-405A-9273-271EB776E8E2' width='0' height='0' >");
//document.write("</object>");

//document.write("<div onmouseover=f_s('div1') onmouseout=closeW('div1') style=' position:absolute;background:green; left: 20px; top: 20px; width:120px; height:10px;padding:8px;color:white;font-size:9pt;'>详细介绍</div>")
//document.write("<div id='div1' style='position:absolute;background:aqua;padding:8px;font-size:9pt;left:20px;overflow:hidden;top:68px;width:330px;display:none' onmouseover=showDiv() onmouseout=closeW('div1')>一年之计在于春一天之计在于晨抓紧每一分一秒努力奋斗</div>")

var PrinttObj;
var gLocID;
var allowbill="";
var Lookupstr="";
var gSetConditon="";
var RowsperPage=21;
var colsperPage=7;
var TemplatePath;
var gPaadm="";
var m_CardNoLength=0;
var m_SelectCardTypeDR="";
var PrintRisReportObj;
var SelectedPatientType="";
var SelectedOrdItemRowid="";
var gPrintTemp;
var flag=0;
var LastGroupDR="";

//var SelectedRow="-1"
	
function BodyLoadHandler()
{   
	//InitGridView();
	SetGridStyle();
	DisplayCondition();
    GetLocName();
  	
	var StdateObj=document.getElementById("StdDate");
	var eddateObj=document.getElementById("enddate");
	
	if (StdateObj.value=="")
	{
		StdateObj.value=getRelaDate(-2);
		eddateObj.value=DateDemo();
	}
	
	if(eddateObj)
	{
		eddateObj.onchange=EndDateFind;
    }
	var InputFeeObj=document.getElementById("InputFee");
    if (InputFeeObj)
    {
	    InputFeeObj.onclick=FunInputFee;
	}
	var readcardObj=document.getElementById("ReadCard");
    if (readcardObj)
    {
	    readcardObj.onclick=FunReadCard;
	}

   	var obj=document.getElementById("Find");
	if (obj) obj.onclick=FindClickHandler;
	
	var clearobj=document.getElementById("Clear");
	if (clearobj) clearobj.onclick=Clickclear;
	
	var NoObj=document.getElementById("StudyNo");
	if (NoObj)
	{
		NoObj.onkeydown=StudyNo_keyDown;
	}
	
	var RegNoObj=document.getElementById("RegNo");
	if (RegNoObj)
	{
		RegNoObj.onkeydown=RegNo_keyDown;
	}
	var CardNoObj=document.getElementById("CardNo");
	if (CardNoObj)
	{
		CardNoObj.onkeydown=CardNoObj_keyDown;
	}
	var NameObj=document.getElementById("Name");
	if (NameObj)
	{
		NameObj.onkeydown=Name_keyDown;
	}
	
	var PNObj=document.getElementById("InPatientNo");
	if (PNObj)
	{
		PNObj.onkeydown=InPatientNo_keyDown;
	}
	
	NOOBJ=document.getElementById("NO");
	if (NOOBJ)
	{
		NOOBJ.onkeydown=No_keyDown;
	}
   /*
	var byObj=document.getElementById("OrderByIndex");
	if (byObj)
	{
		byObj.onclick=Oderby_click;
	} 
	
	var EObj=document.getElementById("RegList");
	if (EObj)
	{
		EObj.onclick=RegList_click;
	} 
	
	var BookedListObj=document.getElementById("BookedList");
	if (BookedListObj)
	{
		BookedListObj.onclick=BookedList_click1;
	} 
	
	var VerfiedOrdListObj=document.getElementById("VerfiedOrdList");
	if (VerfiedOrdListObj)
	{
		VerfiedOrdListObj.onclick=VerfiedOrdList_click1;
	}
	*/ 
	var obj=document.getElementById("PaidItem");
	if (obj)
	{
		obj.onclick=paiditem_click1;
	}
	var LockObj=document.getElementById("Lock");
	if (LockObj)
	{
		LockObj.onclick=LockObj_click1;
	}
	
	var QueryFeeObj=document.getElementById("QueryFee");
	if (QueryFeeObj)
	{
		QueryFee.onclick=QueryFee_click1;
	}
	var PrintListobj=document.getElementById("PrintList");
	if (PrintListobj)
	{
		PrintListobj.onclick=ExportList_onclick //PrintList_click;
	}
	
	var PaidItemIobj=document.getElementById("PaidItemI");
	if (PaidItemIobj)
	{
		PaidItemIobj.onclick=paiditemI_click;
	}
	var ExportObj=document.getElementById("ExportList");
	if (ExportObj)
	{
		ExportObj.onclick=ExportList_onclick;
	}
	
	
	var EqSObj=document.getElementById("EqStatics");
	if (EqSObj)
	{
		EqSObj.onclick=EqStatics_click;
	}
	
	CheckPaidStatus();
	
	//Set Query Condition
	GetInputCondition();
	
	var GetPathFunction=document.getElementById("GetPath").value;
 	TemplatePath=cspRunServerMethod(GetPathFunction);
 	//alert(TemplatePath);
    //FindClickHandler();
	
	
	
	////////////////////////////////////////////add by new card 
	loadCardType();
	
	var myobj=document.getElementById('CardTypeDefine');
	if (myobj){
		
		myobj.onchange=CardTypeDefine_OnChange;
		myobj.size=1;
		myobj.multiple=false;
	}
	
	
	var PrintAppBillobj=document.getElementById('PrintAppBill');
	if (PrintAppBillobj){
		
		PrintAppBillobj.onclick=PrintAppBill;
	
	}
	var PrintAppNoteObj=document.getElementById("PrintAppNote");
	if(PrintAppNoteObj)
	{
		PrintAppNoteObj.onclick=PrintNote_click;
	}
	
	var Clinicobj=document.getElementById("Clinic");
	if (Clinicobj)
	{
		Clinicobj.onclick=Clinic_click;
	}
	
	//DoActionFind("");
}

function EndDateFind()
{
	FindClickHandler();
}
function PrintList_click()
{
	onprint();
	
}

function QueryFee_click1()
{
  var ordtab=document.getElementById("tDHCRisWorkBenchEx");
  var paadmdr="";
  var num=0;
  if (ordtab) 
  {
     for (var i=1; i<ordtab.rows.length; i++)
     {
        var selectedobj=document.getElementById("TSelectedz"+i);
        if ((selectedobj)&&(selectedobj.checked))
        {
	       num=num+1;
	       paadmdr=document.getElementById("EpisodeIDz"+i).value;
	    }
	  } 
    }
    if (paadmdr=="")
    {
		alert(t['selectedpatient']);
        return;
    }
    var locid=session['LOGON.CTLOCID'];
    var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisQueryFee"+"&paadmdr="+paadmdr+"&LocOEORDITEM=on"+"&LocID="+locid;    
    var mynewlink=open(link,"DHCRisQueryFee","scrollbars=yes,resizable=yes,top=6,left=6,width=1000,height=680");
 }

function LockObj_click1()
{
   var userid=session['LOGON.USERID'];
 var LockObj=document.getElementById("Lock");
 if (LockObj.checked)
 {
	 setCondition();
 }
 else
 {
	var CancelConditionFunction=document.getElementById("CancelConditionInfo").value;
	var value=cspRunServerMethod(CancelConditionFunction,userid);
 }

	
}
function setCondition()
{
	var userid=session['LOGON.USERID'];
	//alert(userid);
	GetInputCondition();
	var SetConditionFunction=document.getElementById("SeConditionInfo").value;
    var value=cspRunServerMethod(SetConditionFunction,gSetConditon,userid);
}

function DisplayCondition()
{ 
  var Item;
  var LockObj=document.getElementById("Lock");
  var userid=session['LOGON.USERID'];
  var GetConditionFunction=document.getElementById("GetCondition").value;
  var value=cspRunServerMethod(GetConditionFunction,userid);
  
  if (value!="")
  {
	Item=value.split("^");
   	document.getElementById("type").value=Item[0];
	document.getElementById("RegNo").value=Item[1];
    document.getElementById("StudyNo").value=Item[2];
 	document.getElementById("LocDr").value=Item[3];
    document.getElementById("StatusCode").value=Item[4];
	document.getElementById("Name").value=Item[7];
   	document.getElementById("ResourceID").value=Item[8];
  	document.getElementById("RegEQID").value=Item[9];
	document.getElementById("RoomDR").value=Item[10];
	document.getElementById("InPatientNo").value=Item[11];
	
	if (Item[12]=="true")
	  document.getElementById("CheckDate").checked=true;
	else
	  document.getElementById("CheckDate").checked=false;
	  
	if (Item[13]=="Y")
	  document.getElementById("ckAppointment").checked=true;
	else
	  document.getElementById("ckAppointment").checked=false;
    if (Item[14]=="Y")
      document.getElementById("ckbedOrder").checked=true;
	else
      document.getElementById("ckbedOrder").checked=false;
	 
 	document.getElementById("EQGroupDR").value=Item[15];
 	
	document.getElementById("NO").value=Item[17];
	if (Item[18]=="false")
	  document.getElementById("ckSentFilm").checked=false;
	else
	  document.getElementById("ckSentFilm").checked=true;
	if (Item[19]=="false")
		document.getElementById("Lock").checked=false;
	else
	    document.getElementById("Lock").checked=true;
	
	if (document.getElementById("ChkNotLoc"))
	{
		if (Item[20]=="Y")
			document.getElementById("ChkNotLoc").checked=true;
		else
		    document.getElementById("ChkNotLoc").checked=false;
	}
	
	if (Item[21]=="Y")
		document.getElementById("ckRegDate").checked=true;
	else
	    document.getElementById("ckRegDate").checked=false;
	
	if(document.getElementById("ChkUItem"))
	{
		if (Item[30]=="Y")
	    	document.getElementById("ChkUItem").checked=true;
		else
		    document.getElementById("ChkUItem").checked=false;
	}
	
	if(document.getElementById("ItemCostRecords"))
	{
		if(Item[31]=="Y")
		   document.getElementById("ItemCostRecords").checked=true;
		else
		   document.getElementById("ItemCostRecords").checked=false;    
	}

	 document.getElementById("Resource").value=Item[22];
	 document.getElementById("EQGroup").value=Item[23];
	 document.getElementById("Room").value=Item[24];
	 document.getElementById("Status").value=Item[25];
	 document.getElementById("PatientType").value=Item[26];
	 document.getElementById("RegEQ").value=Item[27];
	 document.getElementById("StdDate").value=Item[28];
	 document.getElementById("enddate").value=Item[29];
	 document.getElementById("AppLocID").value=Item[32];
	 LockObj.checked=true;
  }
  else
  {
	 LockObj.checked=false;
  }
}

function GetLocName()
{
	var LocID=document.getElementById("LocDr");
    if (LocID.value=="")
    {
         var GetLocSessionFunction=document.getElementById("GetLocSession").value;
	     var Getlocicvalue=cspRunServerMethod(GetLocSessionFunction,"SelLocID");
	    //alert(Getlocicvalue);
	     if (Getlocicvalue=="")
                 LocID.value=session['LOGON.CTLOCID'];
         else 
 		   LocID.value=Getlocicvalue;
             	
	    
	}
	//alert(LocID.value);
    var LocName=document.getElementById("LocName").value;
	if (LocName=="")
	{
	   var GetLocNameFunction=document.getElementById("FunLocName").value;
	   var value=cspRunServerMethod(GetLocNameFunction,LocID.value);
           var LocName=document.getElementById("LocName");
           LocName.value=value;
	}
}


function FunReadCard()
{
	//alert("FunReadCard");
	allowbill="";
	gPaadm="";
    //var myrtn=DHCACC_GetAccInfo();
    var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
    
    var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR,myoptval);
	var myary=myrtn.split("^");
	var rtn=myary[0];
	//alert(rtn);
	switch (rtn)
	{
		case "0":
			///rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			var obj=document.getElementById("RegNo");
			obj.value=myary[5];
			var obj=document.getElementById("CardNo");
			obj.value=myary[1];
			
			var obj=document.getElementById("PAPATMASDR");
			obj.value=myary[4];
		    GetPatientInfo();
		
			/*if (myary[5]!=""){
				ReLoadOPFoot("Bill");
			}
			*/
			FindClickHandler();		
			break;
		case "-200":
			alert(t["cardinvalid"]);
			break;
		case "-201":
			//alert(t["cardvaliderr"]);
			var obj=document.getElementById("RegNo");
			obj.value=myary[5];
			var obj=document.getElementById("CardNo");
			obj.value=myary[1];
			
			var obj=document.getElementById("PAPATMASDR");
			obj.value=myary[4];
		  GetPatientInfo();
		default:
	}
	
}

function paiditem_click1()
{
	//allowbill=myary[5];
	var obj=document.getElementById("CardNo");
	allowbill=obj.value;
	if (SelectedPatientType=="住院病人")
	{
		alert("住院病人不允许门诊费用录入");
		return ;
	}
		
	if (allowbill=="")
	{
		alert(t["InputCard"]);
	}
	else
    {   
        //alert("bill");
		ReLoadOPFoot("Bill");
	}
	
	
}

function ReLoadOPFoot(ParCallType)
{
   var RegNo=document.getElementById("RegNo").value;
   var group=session['LOGON.GROUPID'];
   var ctlocid=session['LOGON.CTLOCID']
   //var ctloc=document.getElementById("ctloc").value;
   //var stdate=document.getElementById("CDateSt").value;
	//var enddate=document.getElementById("CDateEnd").value;
	//var pmi=document.getElementById("CPmiNo").value;
	var card=document.getElementById("CardNo").value;
	var billStatus=document.getElementById("BillStatus").value;
	var bill=cspRunServerMethod(billStatus,RegNo,group,ctlocid);
	var obj=document.getElementById("PAPATMASDR");
	var gPAPATMASDR=obj.value;
    //alert(gPAPATMASDR+"^"+gPaadm+"^"+bill);
	
	//if (((bill=="Y") && (ParCallType=="Bill")) || (ParCallType=="App"))
	{
		if ((gPaadm=="")||(gPAPATMASDR==""))
		{
			var lnk="udhcopbillif.csp?PatientIDNo="+RegNo+"&CardNo="+card;
			var NewWin=open(lnk,"udhcopbillif","scrollbars=yes,resizable=yes,top=6,left=6,width=1000,height=680");
		}
		else
		{
			var lnk="udhcopbillforadmif.csp?CardNo="+card+"&SelectAdmRowId="+gPaadm+"&SelectPatRowId="+gPAPATMASDR;
			var NewWin=open(lnk,"udhcopbillif","scrollbars=no,resizable=no,top=6,left=6,width=1000,height=680");

		}
		

	}
	
}
	


function RegNo_keyDown(e)
{
	var key =websys_getKey(e)
	if (key==13)
	{
		//alert("find");
		GetPatientInfo();
		FindClickHandler();
		
	}
	 
	
}

function CardNoObj_keyDown(e)
{
	var key =websys_getKey(e)
	if (key==13)
	{
		//alert("find");
		GetPatientInfo();
		FindClickHandler();
		
	}
	
}

function StudyNo_keyDown(e)
{
	var key =websys_getKey(e)
	if (key==13)
	{
		//GetPatientInfo();
		FindClickHandler();
		
	}
}
function Name_keyDown(e)
{
	var key =websys_getKey(e)
	if (key==13)
	{
		FindClickHandler();
		
	}
	
}
function InPatientNo_keyDown(e)
{
	var key =websys_getKey(e)
	if (key==13)
	{
		FindClickHandler();
	}
	
}
function No_keyDown(e)
{
	var key =websys_getKey(e)
	if (key==13)
	{
		FindClickHandler();
	}
	
}

function GetPatientInfo()
{
	var NameObj=document.getElementById("Name");
  	var RegNo=document.getElementById("RegNo").value;
  	var CarNo=document.getElementById("CardNo").value;
  	
  	if (CarNo!="")
  	{
	  	var zero="";
		for (var j=0;j<12-CarNo.length;j++)  //10
	 	{
			 zero=zero+"0";
	 	}
	 	CarNo=zero+CarNo;
	 	
	    document.getElementById("CardNo").value=CarNo;
	  	RegNo=GetRegNofromCardNo(CarNo);
	}
	if (RegNo=="")
	{
		NameObj.value="";
  		//SexObj.value="";
    }
	else
	{
		var zero="";
		for (var i=0;i<10-RegNo.length;i++)  //10
	 	{
			 zero=zero+"0";
	 	}
	 	RegNo=zero+RegNo;
	 	document.getElementById("RegNo").value=RegNo;
	 
	 	var FunctionGetPatient=document.getElementById("GetPatient").value;
		var Info=cspRunServerMethod(FunctionGetPatient,RegNo);
  		var Infolist=Info.split("^");
 	  	NameObj.value=Infolist[0];
  	    	
	}
  
  	
	
}

function DateDemo()
{
   var d, s="";           // 声明变量?
   d = new Date(); 
   var sDay="",sMonth="",sYear="";
   sDay = d.getDate();			// 获取日?
   if(sDay < 10)
   sDay = "0"+sDay;
    
   sMonth = d.getMonth()+1;		// 获取月份?
   if(sMonth < 10)
   sMonth = "0"+sMonth;
   
   sYear  = d.getFullYear();		// 获取年份?
   s = sDay + "/" + sMonth + "/" + sYear;
   //s  =  sYear+"-"+ sMonth + "-" + sDay          
   return(s); 
   
}


function transINVStr(myINVStr)
{
	
	/*ItemList=myINVStr.split("^");
	Userid=session['LOGON.USERID'];
	
	if (ItemList[0]==0)  //结算成功
	{
				
		//执行医嘱
		//alert(myINVStr+"^"+Userid);
		var GetUpdateOrdStatus=document.getElementById("UpdateOrdStatus").value;
		var Info=cspRunServerMethod(GetUpdateOrdStatus,myINVStr,Userid);
				
		
	}
	*/
	
	FindClickHandler();
}



function FindClickHandler(e)
{
	var regNo=document.getElementById("RegNo").value;
	var Name=document.getElementById("Name").value;
	var StudyNo=document.getElementById("StudyNo").value
	var Nst=document.getElementById("StdDate").value;
	var Ned=document.getElementById("enddate").value;
	var GetdaysFunction=document.getElementById("Getdays").value;
	var days=cspRunServerMethod(GetdaysFunction,Nst,Ned);
	if ((days>30)&&(regNo=="")&&(Name=="")&&(StudyNo==""))
	{
		alert(t['toolong']);
		return;
	}
 	GetInputCondition();
    var LockObj=document.getElementById("Lock");
 
 	if (LockObj.checked)
 	{
		 setCondition();
 	}

    
	return  Find_click();

	/*var StdDate=document.getElementById("StdDate").value;
	var endDate=document.getElementById("endDate").value;
	var strCondition=document.getElementById("strCondition").value;
 
	var para=" &strCondition="+strCondition+" &StdDate="+StdDate+" &enddate="+endDate;
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisWorkBenchEx="+para;
	*/

}

function GetInputCondition()
{
	var IsBedOrder="";
	var IsAppointmentOrder="";
	var QueryByRegDate;
	var IsUItem="";
	var IsCostRecords="";
	
	if (document.getElementById("Resource").value=="")
	{
	   ResourceDR=document.getElementById("ResourceID").value="";
	}
  	if (document.getElementById("EQGroup").value=="")
  	{
	  	document.getElementById("EQGroupDR").value="";
  	}
	if (document.getElementById("Room").value=="")
	{
		document.getElementById("RoomDR").value="";
	}
	if (document.getElementById("Status").value=="")
	{
		document.getElementById("StatusCode").value="";
  	}
 	if (document.getElementById("PatientType").value=="")
 	{
	 	document.getElementById("type").value="";
 	}
 	if (document.getElementById("RegEQ").value=="")
 	{
	 	RegEQDR=document.getElementById("RegEQID").value="";
 	}
 	if (document.getElementById("AppLocDesc").value=="")
 	{
	 	document.getElementById("AppLocID").value="";
 	}
	
	var RegNo=document.getElementById("RegNo").value;
	var Name=document.getElementById("Name").value;
    var StudyNo=document.getElementById("StudyNo").value;
    var ReportDoc="";
    //document.getElementById("ReportDoc").value;
  	var VerifyDoc="";
  	//document.getElementById("VerifyDoc").value;
  	var ResourceDR=document.getElementById("ResourceID").value;
    var StatusCode=document.getElementById("StatusCode").value;
   	var typeDR=document.getElementById("type").value;
 	var RegEQDR=document.getElementById("RegEQID").value;
 	var LocDr=document.getElementById("LocDr").value;
 	//var Stdate=document.getElementById("StdDate").value;
	//var eddate=document.getElementById("endDate").value;
	var EQGroupDR=document.getElementById("EQGroupDR").value;
	var RoomDR=document.getElementById("RoomDR").value;
	var InPatientNo=document.getElementById("InPatientNo").value;
	var No=document.getElementById("NO").value;
	var IsSetFilm=document.getElementById("ckSentFilm").checked;
	var Islock=document.getElementById("Lock").checked;
	var IsFindbyDate=document.getElementById("CheckDate").checked;
	if (document.getElementById("ckAppointment").checked)
	  IsAppointmentOrder="Y";
	else
	 IsAppointmentOrder="";
	if (document.getElementById("ckbedOrder").checked)
	  IsBedOrder="Y";
	else
	  IsBedOrder="";
	
	IsNotLoc="N";
	if(document.getElementById("ChkNotLoc"))
	{
		if (document.getElementById("ChkNotLoc").checked)
		  IsNotLoc="Y";
	}
	  
	if (document.getElementById("ckRegDate").checked)
	  QueryByRegDate="Y";
	else
	  QueryByRegDate="N";
    
    IsUItem="N";
    if(document.getElementById("ChkUItem"))
    {
	    if (document.getElementById("ChkUItem").checked)
		  IsUItem="Y";
    }
    
	IsCostRecords="N";
	if(document.getElementById("ItemCostRecords")) 
	{ 
		if (document.getElementById("ItemCostRecords").checked)
		  IsCostRecords="Y";    
	}
	
	var Resource=document.getElementById("Resource").value;
	var EQGroup=document.getElementById("EQGroup").value;
	var Room=document.getElementById("Room").value;
	var Status=document.getElementById("Status").value;
	var Patienttype=document.getElementById("PatientType").value;
	var RegDevice=document.getElementById("RegEQ").value;
	
	var StdDate=document.getElementById("StdDate").value;
	var endDate=document.getElementById("enddate").value;
	var AppLocID=document.getElementById("AppLocID").value;
     

    // IsAppointmentOrder+"^"+IsBedOrder
	var strConditionObj=document.getElementById("strCondition");
    var Condition1=typeDR+"^"+RegNo+"^"+StudyNo+"^"+LocDr+"^"+StatusCode+"^"+ReportDoc+"^"+VerifyDoc+"^"+Name+"^"+ResourceDR;
    var Condition2=RegEQDR+"^"+RoomDR+"^"+InPatientNo+"^"+IsFindbyDate+"^"+IsAppointmentOrder+"^"+IsBedOrder+"^"+EQGroupDR+"^^"+No+"^"+IsSetFilm+"^"+Islock+"^"+IsNotLoc+"^"+QueryByRegDate;
    var Condition3=Resource+"^"+EQGroup+"^"+Room+"^"+Status+"^"+Patienttype+"^"+RegDevice+"^"+StdDate+"^"+endDate+"^"+IsUItem+"^"+IsCostRecords+"^"+AppLocID;
    
     gSetConditon=Condition1+"^"+Condition2+"^"+Condition3;
	 strConditionObj.value=gSetConditon;
	 
   
    //alert( strConditionObj.value);

}

function Clickclear(e)
{
	document.getElementById("RegNo").value="";
	document.getElementById("Name").value="";
    document.getElementById("StudyNo").value="";
    document.getElementById("Resource").value=""
  	document.getElementById("NO").value="";
	document.getElementById("EQGroup").value="";
	document.getElementById("Room").value="";
	document.getElementById("InPatientNo").value="";
  	document.getElementById("Status").value="";
 	document.getElementById("PatientType").value="";
 	document.getElementById("RegEQ").value="";
 	
 	document.getElementById("ResourceID").value="";
    document.getElementById("StatusCode").value="";
   	document.getElementById("type").value="";
 	document.getElementById("RegEQID").value="";
	document.getElementById("EQGroupDR").value="";
	document.getElementById("RoomDR").value="";
	document.getElementById("AppLocDesc").value="";
 	document.getElementById("AppLocID").value="";
 	
	
	/*
	var VObj=document.getElementById("VerfiedOrdList");
    VObj.checked=false;
    var BObj=document.getElementById("BookedList");
	BObj.checked=false;
	var EObj=document.getElementById("RegList");
	EObj.checked=false;
	
	*/
	var gPaadm="";
	var gPAPATMASDR="";
	var obj=document.getElementById("CardNo");
	obj.value="";
	
	var userid=session['LOGON.USERID'];
    var LockObj=document.getElementById("Lock");
 
    if (LockObj.checked)
    {
	   setCondition();
    }
	//FindClickHandler();    
    
}



function BookedList_click1()
{
	document.getElementById("Name").value="";
  	document.getElementById("RegNo").value="";
  	
 	document.getElementById("Status").value="";
 
  	
  	var BObj=document.getElementById("BookedList");
	if (BObj.checked)
	{	
  		var byObj=document.getElementById("OrderByIndex");
		if (byObj)
		{
			byObj.checked=false;
		} 
	}
  	SetWorklist();
}

function VerfiedOrdList_click1()
{
	document.getElementById("Name").value="";
    //document.getElementById("Sex").value="";	
    //document.getElementById("DOB").value="";
    document.getElementById("AppLoc").value="";
  	document.getElementById("RegNo").value="";
  	
  	document.getElementById("Status").value="";
 	//document.getElementById("StatusCode").value="";
 
    var VObj=document.getElementById("VerfiedOrdList");
    if (VObj.checked)
    {
   		var byObj=document.getElementById("OrderByIndex");
		if (byObj)
		{
			byObj.checked=false;
		}
	}	 
   	SetWorklist();
  	
}

function RegList_click(e)
{
	document.getElementById("Name").value="";
    document.getElementById("Sex").value="";	
    document.getElementById("DOB").value="";
    document.getElementById("AppLoc").value="";
  	document.getElementById("RegNo").value="";
 	document.getElementById("Status").value="";
 	document.getElementById("StatusCode").value="";
   
    var EObj=document.getElementById("RegList");
	if (EObj.checked)
	{
	 	var byObj=document.getElementById("OrderByIndex");
		if (byObj)
		{
			byObj.checked=false;
		}
	} 
   	SetWorklist();
	
}
function Oderby_click(e)
{
    document.getElementById("Name").value="";
    //document.getElementById("Sex").value="";	
    //document.getElementById("DOB").value="";
    //document.getElementById("AppLoc").value="";
  	document.getElementById("RegNo").value="";
	document.getElementById("StudyNo").value="";
	
	var eddateObj=document.getElementById("enddate");
	if (eddateObj)
	{
		eddateObj.value=DateDemo();
	}
	
	var byObj=document.getElementById("OrderByIndex");
	if (byObj)
	{
	  if (byObj.checked)
	  {
		 var VObj=document.getElementById("VerfiedOrdList");
    	 VObj.checked=false;
    	 var BObj=document.getElementById("BookedList");
		 BObj.checked=false;
	     var EObj=document.getElementById("RegList");
		 EObj.checked=false;
	 	
      }
   }
   //FindClickHandler(); 
}

function SelectRowHandler()
{
	var Selected=false;
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisWorkBenchEx');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var LastRegNo="";
    var LastRecLocDR="";
    var k=0;
    
	SelectedPatientType=document.getElementById("TPatientTypez"+selectrow).innerText;
	//var selectedobj1=document.getElementById("TSelectedz"+selectrow);
	
    for (i=1;i<rows;i++)
    {
	    var selectedobj=document.getElementById("TSelectedz"+i);
        if ((selectedobj)&&(selectedobj.checked))
        {     
          	var OEorditemID=document.getElementById("OEOrdItemIDz"+i).value;
          	SelectedOrdItemRowid=OEorditemID;
          	
            LocDR=document.getElementById("RecLocIdz"+i).value;
     		var regno=document.getElementById("PatientIDz"+i).innerText;
     		var SGroupDR=document.getElementById("SGroupDRz"+i).value;
     		
     		k=k+1;
     		
     		if ((LastRegNo!="")&&(LastRegNo!=regno))
	        {
		        alert("不同病人不能一起选择!")
		        return false;
		    }
		    else
		    {
			    LastRegNo=regno;
		    }
		     
		    if ((LastRecLocDR!="")&&(LastRecLocDR!=LocDR))
	        {
		        alert("不同接收科室不能一起选择!");
		        return false;
		    }
		    else
		    {
			    LastRecLocDR=LocDR;
		    }
		            
		    if ((LastGroupDR!="")&&(LastGroupDR!=SGroupDR))
	        { 
	            var array=GetSert(LastGroupDR,SGroupDR)
	            var arrauInfo=""
	            for (j=0;j<array.length;j++)
	            {
		            if (arrauInfo==""){
			            arrauInfo=array[j];
			        }else{
				        arrauInfo=arrauInfo+","+array[j];
				    }
		        }
		        
		        LastGroupDR=arrauInfo
		        if (LastGroupDR=="")
		        {
		           alert("不同服务组不能一起选择!")
		           return false;
		        }
		    }else
		    {
		         LastGroupDR=SGroupDR;
		    }
		    
		    //alert("LastGroupDR="+LastGroupDR)
		     
   			var name=document.getElementById("TPatientNamez"+i).innerText;
  			//var studyno=document.getElementById("TStudyNoz"+selectrow).innerText;
    		var Sex=document.getElementById("TSexz"+i).innerText;
    		var DOB=document.getElementById("TDOBz"+i).innerText;
    		var LocName=document.getElementById("TLocNamez"+i).innerText;
    
   			var ReportDoc=document.getElementById("TReportDocz"+i).innerText;
    		var VerifyDoc=document.getElementById("TVerifyDocz"+i).innerText;
    		var selectedobj=document.getElementById("TSelectedz"+i);
  
    		var paadmdr=document.getElementById("EpisodeIDz"+i).value;
    		    gPaadm=paadmdr;
            //alert(paadmdr);
    		var Weight=document.getElementById("TWeightz"+i).innerText;
    		var EQGroup=document.getElementById("TEQGroupz"+i).innerText;
   
    		var EQ=document.getElementById("TRegResourcez"+i).innerText;
    		var Room=document.getElementById("TRoomz"+i).innerText;
    		var RegIndex=document.getElementById("RegNoIndexz"+i).innerText;
    		var MainDoc=document.getElementById("TMainDocz"+i).innerText;
    		var OptionDoc=document.getElementById("TOperationDocz"+i).innerText;
    		var TelNo=document.getElementById("TTelNoz"+i).innerText;
    		var ipno=document.getElementById("TIPNOz"+i).innerText;
    
    		var regDate=document.getElementById("TRegDatez"+i).value;
    		var regTime=document.getElementById("TRegTimez"+i).value;
    		
    		PatientStatusCode=document.getElementById("OEORIItemStatusz"+i).value;
    		
    		Selected=true;
    		if (i==selectrow)
    		{
	    		LocDR=document.getElementById("RecLocIdz"+i).value;
    			break;	
    		}
        }
    }
    
    if (k==0)
    {
	    LastGroupDR="";
	}
      
    //var LocDR=document.getElementById("LocDr").value;	
    /*var BookedType=document.getElementById("BookedType").value;
    if(Selected)
    {
	    if (BookedType=="1")
	    {
		    
		    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisBooked&LocId="+LocDR+"&OrditemRowid="+OEorditemID;
       		parent.frames['Booking'].location.href=lnk; 
       		
    		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisBookedItem&EpsodeId="+gPaadm;
       		parent.frames['ListBookItem'].location.href=lnk; 
      
	    }
	    else
	    {
        	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisRegisterPatientEx"+"&LocDR="+LocDR+"&PaadmDR="+paadmdr+"&OeorditemID="+OEorditemID;
       		parent.frames['PatientRegister'].location.href=lnk; 
	    }
    }*/
      
 
    //call patient when patient arrived 
   	var status=document.getElementById("TStatusz"+selectrow).innerText;
   	var PAPMINameLink='TPatientNamez'+selectrow;
   	if (eSrc.id==PAPMINameLink)
  	{
	  	//if (status==t['Execute'])
	  	{
	  	  /*var Ans=confirm(t['CallPatient']+' '+name+'......')
		  if (Ans==false) {return false;}
		  var room=document.getElementById("TRegResourcez"+selectrow).innerText;
	      var RegDoctor=session['LOGON.USERNAME'];
   		  var AdmDep=document.getElementById("LocName").value;
    	  var LocID=document.getElementById("LocDr").value;
    	  var SeqNo=document.getElementById("RegNoIndexz"+selectrow).innerText;
    	  var PatString=regno+'^'+SeqNo+'^'+name+'^'+room+'^'+RegDoctor+'^'+AdmDep+'^'+LocID;
   		  var SendPatient=document.getElementById('SendPatient');
		  if (SendPatient) {var encmeth=SendPatient.value} else {var encmeth=''};
		  var SendStatus=cspRunServerMethod(encmeth,PatString);*/
		  var EpisodeID=document.getElementById("EpisodeIDz"+selectrow).value;
	  	  var lnk="dhc.ris.admlist.show.csp?"+"&EpisodeID="+EpisodeID;
		  var NewWin=open(lnk,"dhcrisappbill","scrollbars=yes,resizable=yes,top=6,left=6,width=1000,height=680");  
		  return false;
	  	}
		return false;
   	 }
   	 
   	  /*websys.default.csp
       DHCRisAppointment
      "&ResourceID="_"&OEOrdItemID="_rs.GetDataByName("TOeorditemdr")_"&LocID="_"&AppStDate="_"&mode=1"_"&EpisodeID="_rs.GetDataByName("Tpaadmdr")*/
      
  	 /*var AppointmentLink='TBookedTimez'+selectrow;
   	 if (eSrc.id==AppointmentLink)
  	{
	  	if (status==t['Booked'])
	  	{
		  	//oeorditemdr=document.getElementById("OEOrdItemIDz"+selectrow).value;
		  	//Location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisAppointment&ResourceID="+"&OEOrdItemID="+oeorditemdr+"&LocID="+"&AppStDate="+"&mode=1";
            return true;
		}
		else
		{
			alert(t['CantModiBooked']);
			return false;
		}
   	 }*/
   	 
   	 var ItemDetailLink='ItemDetailz'+selectrow;
   	 if(eSrc.id==ItemDetailLink)
  	 {
	  	var OEorditemID=document.getElementById("OEOrdItemIDz"+selectrow).value;
	  	var GetArcItmRowidFun=document.getElementById("GetArcItmRowid").value;
	    var ARCItmRowid=cspRunServerMethod(GetArcItmRowidFun,OEorditemID);
	  	window.showModalDialog("websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFArcimPrice1&ArcimRowid="+ARCItmRowid,"","dialogwidth:800px;dialogheight:500px;status:no;center:1;resizable:yes");
	  	return false;
  	 }
   	 
   	 var ReasonLink='RejectAppReasonz'+selectrow;
   	 if(eSrc.id==ReasonLink)
  	 {
	  	if(status==t['RejectApp'])
	  	{
		  	var EpisodeID=document.getElementById("EpisodeIDz"+selectrow).value;
		  	var OEOrdItemID=document.getElementById("OEOrdItemIDz"+selectrow).value;
		  	window.showModalDialog("websys.default.csp?WEBSYS.TCOMPONENT=DHCRisQueryRejectReason&EpisodeID="+EpisodeID+"&OEOrdItemID="+OEOrdItemID,"","dialogwidth:800px;dialogheight:400px;status:no;center:1;resizable:yes");
		  	return false;
	  	}
	  	else
	  	{
		  	alert(t['NoRejApp']);
	  	    return false
	  	}
  	 }	
  	 
  	 var AppBillLink='TAppBillViewz'+selectrow;
   	 if(eSrc.id==AppBillLink)
  	 {
	  	var OEOrdItemID=document.getElementById("OEOrdItemIDz"+selectrow).value;
	    window.showModalDialog("websys.default.csp?WEBSYS.TCOMPONENT=DHCRisAppBillBrowse&OEOrdItemID="+OEOrdItemID,"","dialogwidth:950px;dialogheight:600px;status:no;center:1;resizable:yes");
	  	return false;
	  	//test
	  	/*var EpisodeID=document.getElementById("EpisodeIDz"+selectrow).value;
	  	var OEOrdItemID=document.getElementById("OEOrdItemIDz"+selectrow).value;
	  	var PatientID=document.getElementById("PatientIDz"+selectrow).innerText;
	  	var lnk="dhcrisappbill.csp?PatientID="+PatientID+"&OEorditemID="+OEOrdItemID+"&EpisodeID="+EpisodeID+"&AppRowID=";
		var NewWin=open(lnk,"dhcrisappbill","scrollbars=yes,resizable=yes,top=6,left=6,width=1000,height=680");
		return false;*/
  	 }	
  	 
  	var ToDayOeItemLink='ToDayOeItemz'+selectrow;
   	if(eSrc.id==ToDayOeItemLink)
  	{
	  	var EpisodeID=document.getElementById("EpisodeIDz"+selectrow).value;
	  	var LocDr=document.getElementById("RecLocIdz"+selectrow).value;
	  	window.showModalDialog("websys.default.csp?WEBSYS.TCOMPONENT=DHCRisToDayOrder&EpisodeID="+EpisodeID+"&LocDr="+LocDr,"","dialogwidth:950px;dialogheight:400px;status:no;center:1;resizable:yes");
	  	return false;
  	}	
  	 
  	var BookedType=document.getElementById("BookedType").value;
    if (Selected)
    {
	   if (BookedType=="1")
	    {
       		
       		/*var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisBookedItem&EpsodeId="+gPaadm;
 	   		parent.frames['ListBookItem'].location.href=lnk; */
			var lnk= "dhcrisbookRegister.csp?LocDR="+LocDR+"&EpisodeID="+paadmdr+"&OeorditemID="+OEorditemID+"&PatientStatusCode="+PatientStatusCode+"&SGroupDR="+LastGroupDR //SGroupDR;
			//alert(lnk);
       		parent.frames['RegisterBooking'].location.href=lnk;

	    }
	    else
	    {
        	/*var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisRegisterPatientEx"+"&LocDR="+LocDR+"&PaadmDR="+paadmdr+"&OeorditemID="+OEorditemID;
       		parent.frames['PatientRegister'].location.href=lnk; */
	    }
	    
	    return true;
    }
}



function SetWorklist()
{
	var Vobj=document.getElementById("VerfiedOrdList");
	var Eobj=document.getElementById("RegList");
	var Bobj=document.getElementById("BookedList");
	
	document.getElementById("StatusCode").value="";
	
	if (Vobj.checked)
	{
		document.getElementById("StatusCode").value="V";
	}
    if (Eobj.checked)
	{
		document.getElementById("StatusCode").value=document.getElementById("StatusCode").value+"E";
	}
	
	if (Bobj.checked)
	{
		document.getElementById("StatusCode").value=document.getElementById("StatusCode").value+"S";
	}

    //alert(document.getElementById("StatusCode").value);
	
	//FindClickHandler();
	
}

function CheckPaidStatus()
{
	var tbl=document.getElementById("tDHCRisWorkBenchEx");
	var row=tbl.rows.length;
	row=row-1;
	for (var j=1;j<row+1;j++)
	{
		var PatType = document.getElementById('TPatientType'+'z'+j);
		var PaidStatus=document.getElementById('TBillStatus'+'z'+j);
		var AutoInputFee=document.getElementById('AutoInputFeez'+j).innerText;
		var EndInputFee=document.getElementById('EndInputFeez'+j).innerText;
		var UrgentFlag=document.getElementById('Urgentz'+j).innerText;
		
		
		var strPatType=PatType.innerText.slice(0,1);
		//alert(strPatType);
		var charPatType = strPatType.charCodeAt(0);
		//alert(charPatType)
	
		if(charPatType=='20303')
		{
			var PatStatus=document.getElementById('TStatus'+'z'+j);
			var strPatStatus = PatStatus.innerText.slice(0,1);
			var charPatStatus=strPatStatus.charCodeAt(0);
		
			if(charPatStatus=='27491')
			{
				tbl.rows[j].style.backgroundColor="#D0FFFF";  //"Green";
			}
			
		} //OutPat
		
	    if (PaidStatus.innerText!="P")
		{   
		  	    //alert(PaidStatus.innerText);
				tbl.rows[j].style.backgroundColor="#D0FFFF";  //"Green";	
		}
		
		if ((AutoInputFee=="Y")&&(EndInputFee!="Y"))
		{
			tbl.rows[j].style.backgroundColor="#FF99FF";
		}
		if (UrgentFlag=="Y")
		{
			tbl.rows[j].style.backgroundColor="#00CC00";
		}
		
	}

}


//select special location 
function GetSelectedLocInfo(Info)
{
  Item=Info.split("^");
  document.getElementById("LocName").value=Item[0];
  document.getElementById("LocDr").value=Item[1];
  //put selected locid into session
   var SetSessionLocid=document.getElementById("SetLocsession").value;
   cspRunServerMethod(SetSessionLocid,"SelLocID",Item[1]);
 
}

// select equipment group (jian cha shi )
function GetEQGroup(EQGroupInfo)
{
  Item=EQGroupInfo.split("^");
  document.getElementById("EQGroup").value=Item[0];
  document.getElementById("EQGroupDR").value=Item[1];
}

// select room 
function GetRoom(RoomInfo)
{
  Item=RoomInfo.split("^");
  document.getElementById("Room").value=Item[2];
  document.getElementById("RoomDR").value=Item[0];
}

//select booked resource 
function GetResource(Info)
{
	var item=Info.split("^");
	document.getElementById("Resource").value=item[0];
	document.getElementById("ResourceID").value=item[1];
	//FindClickHandler();

}

//select patient type (ip,op,etc..)
function GetTypeDesc(Info)
{
	var item=Info.split("^");
	document.getElementById("PatientType").value=item[0];
	document.getElementById("type").value=item[1];
	//FindClickHandler();
}


// select register equipment 
function GetRegInfo(Info)
{
	Item=Info.split("^");
	document.getElementById("RegEQ").value=Item[2];
	document.getElementById("RegEQID").value=Item[0];
  	//FindClickHandler();
		
}

//select report verified doctor
function GetVerifiedDoc(Info)
{
	Item=Info.split("^");
	document.getElementById("VerifyDoc").value=Item[0];
 	//FindClickHandler();
}

function  GetBodyPart(info)
{
	Item=info.split("^");
		
}

/*function GetReportStatus(Info)
{
	Item=Info.split("^");
	document.getElementById("ReportStatus").value=Item[2];
}
*/

function GetStatus(Info)
{
	var item=Info.split("^");
	document.getElementById("Status").value=item[2];
	document.getElementById("StatusCode").value=item[1];
	/*var VObj=document.getElementById("VerfiedOrdList");
    //VObj.checked=false;
     //var BObj=document.getElementById("BookedList");
	 BObj.checked=false;
	 var EObj=document.getElementById("RegList");
     EObj.checked=false;
	*/	
	//FindClickHandler();
}

function transINVStr(myINVStr)
{
	
	/*ItemList=myINVStr.split("^");
	Userid=session['LOGON.USERID'];
	
	if (ItemList[0]==0)  //结算成功
	{
				
		//执行医嘱
		//alert(myINVStr+"^"+Userid);
		var GetUpdateOrdStatus=document.getElementById("UpdateOrdStatus").value;
		var Info=cspRunServerMethod(GetUpdateOrdStatus,myINVStr,Userid);
				
		
	}
	*/
	
	FindClickHandler();
}

function ClearPage(xlsheet)
 {
	 for (var i=1; i<=RowsperPage;i++)
	 {
		 for(var j=1;j<=colsperPage;j++)
		 {
			 xlsheet.cells(i+2,j)="";
			 
		 }
	 }
 }
 
function onprint()
{
	
	try 
	{
		var xlApp,xlsheet,xlBook
	    //var Template=TemplatePath+"DHCRis_WorkList.xls";
	    var Template=TemplatePath+"DHCRis_WorkListNew.xls";
	    var CellRows ;
	    var Isprint=1;
	    var Pageindex=0;
	    var PrintedRows=0;
	    
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    
	    var SetPrintFunction=document.getElementById("SetPrintFlag").value;
	  

	    ClearPage(xlsheet);
	    
	    
	    var ordtab=document.getElementById("tDHCRisWorkBenchEx");
	    var Nums=ordtab.rows.length;
	   
        if (ordtab) 
        {
     		for (var i=1;i<Nums;i++)
     	    {
	     	   var IsPrint=document.getElementById("Printz"+i).innerText;
	     	   var RegID=document.getElementById("PatientIDz"+i).innerText;
		       var Name=document.getElementById("TPatientNamez"+i).innerText;
		       var Sex=document.getElementById("TSexz"+i).innerText;
		       var TAge=document.getElementById("TAgez"+i).innerText;
		       var WardName=document.getElementById("WardNamez"+i).innerText;
		       var TBedCode=document.getElementById("TBedCodez"+i).innerText;
		       var StudyNo=document.getElementById("TStudyNoz"+i).innerText;
		       var RecLoc=document.getElementById("RecLocz"+i).innerText;
		       var TIPNO=document.getElementById("TIPNOz"+i).innerText;
		       var BookedDate=document.getElementById("TBookedDatez"+i).innerText;
		       var BookedTime=document.getElementById("TBookedTimez"+i).innerText;
		       var TotalFee=document.getElementById("TotalFeez"+i).innerText;
		       var BodyDesc=document.getElementById("RegBodyPartz"+i).innerText;
		
	     	   if (IsPrint=="Y")
	     	   {
		     	  var Ans=confirm(RegID+" "+Name+" "+t['IsPrint']);
		          if (Ans==true)		     	   
	     	      {
	     	  	     PrintedRows=PrintedRows+1
		     	     xlsheet.cells(PrintedRows+2,1)=StudyNo;
		     	     xlsheet.cells(PrintedRows+2,2)=RegID;
		       	     xlsheet.cells(PrintedRows+2,3)=Name;
		     	     xlsheet.cells(PrintedRows+2,4)=Sex;
		     	     xlsheet.cells(PrintedRows+2,5)=TAge;
		     	     xlsheet.cells(PrintedRows+2,6)=WardName;
		     	     xlsheet.cells(PrintedRows+2,7)=TBedCode;
		     	     xlsheet.cells(PrintedRows+2,8)=TIPNO;
		     	     xlsheet.cells(PrintedRows+2,9)=BookedDate;
		     	     xlsheet.cells(PrintedRows+2,10)=BookedTime;
		     	     xlsheet.cells(PrintedRows+2,11)=RecLoc;
		     	     xlsheet.cells(PrintedRows+2,12)=TotalFee;
		     	     xlsheet.cells(PrintedRows+2,13)=BodyDesc;
		     	     
		     	     CellRows=PrintedRows%RowsperPage;
		     	     if ((CellRows==0))
				     {   
				       Pageindex=Pageindex+1
				       //alert(t['PrintDate'])
		     	       xlsheet.cells(RowsperPage+3,3)=t['PrintDate']+GetCurrentTime();
		     	       //xlsheet.cells(RowsperPage+3,3)="第"+Pageindex+"页";
		    	       xlsheet.printout;
				       ClearPage(xlsheet);
				       PrintedRows=PrintedRows%RowsperPage
				       Isprint=1;
			         }
			         else
			         { 
				        Isprint=0; 
			         }
			         
		             var printdata=cspRunServerMethod(SetPrintFunction,StudyNo);
	     	       }
	     	     }
	     	     else
	     	     {
		     	     PrintedRows=PrintedRows+1
		     	     xlsheet.cells(PrintedRows+2,1)=StudyNo;
		     	     xlsheet.cells(PrintedRows+2,2)=RegID;
		       	     xlsheet.cells(PrintedRows+2,3)=Name;
		     	     xlsheet.cells(PrintedRows+2,4)=Sex;
		     	     xlsheet.cells(PrintedRows+2,5)=TAge;
		     	     xlsheet.cells(PrintedRows+2,6)=WardName;
		     	     xlsheet.cells(PrintedRows+2,7)=TBedCode;
		     	     xlsheet.cells(PrintedRows+2,8)=TIPNO;
		     	     xlsheet.cells(PrintedRows+2,9)=BookedDate;
		     	     xlsheet.cells(PrintedRows+2,10)=BookedTime;
		     	     xlsheet.cells(PrintedRows+2,11)=RecLoc;
		     	     xlsheet.cells(PrintedRows+2,12)=TotalFee;
		     	     xlsheet.cells(PrintedRows+2,13)=BodyDesc;
		     	    
		     	     CellRows=PrintedRows%RowsperPage;
		     	     if ((CellRows==0))
				     {   
				       Pageindex=Pageindex+1
				       //alert(t['PrintDate'])
		     	       xlsheet.cells(RowsperPage+3,3)=t['PrintDate']+GetCurrentTime();
		     	       //xlsheet.cells(RowsperPage+3,3)="第"+Pageindex+"页";
		    	       xlsheet.printout;
				       ClearPage(xlsheet);
				       PrintedRows=PrintedRows%RowsperPage
				       Isprint=1;
			         }
			         else
			         { 
				        Isprint=0; 
			         }
		             var printdata=cspRunServerMethod(SetPrintFunction,StudyNo);
     
	     	     }
	     	   }
	     	   if (Isprint==0)
               {
		  			Pageindex=Pageindex+1;
		  			var CurrTime=GetCurrentTime();
		  		     xlsheet.cells(RowsperPage+3,6)='打印时间:'+CurrTime;
		  			//xlsheet.cells(RowsperPage+3,3)="第"+Pageindex+"页";
		  			xlsheet.printout;
	    	    }
	    	    //xlsheet.printout;
		        xlBook.Close (savechanges=false);
	            xlApp=null;
	            xlsheet=null;
        }
	} 
	catch(e) 
	{
		alert(e.message);
	};
}

function GetCurrentTime()
{
	var d, s="";         
    d = new Date(); 
    var sDay="",sMonth="",sYear="";
    sDay = d.getDate();		
    if(sDay < 10)
    sDay = "0"+sDay;
    
    sMonth = d.getMonth()+1;		
    if(sMonth < 10)
    sMonth = "0"+sMonth;
   
    sYear  = d.getYear();		
    
    var sHoure=d.getHours();
    var sMintues=d.getMinutes();
    
    
    s = sYear +"-"+sMonth+"-"+sDay +" "+sHoure+":"+sMintues;
    return s;

}

/////////////////////////////////////////////////////add by new card program 
function loadCardType()
{
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
	}
	var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	var myary=myoptval.split("^");
	m_SelectCardTypeDR=myary[0];
}

function CardTypeDefine_OnChange()
{
	var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	var myary=myoptval.split("^");
	
	var myCardTypeDR=myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	if (myCardTypeDR=="")
	{
		return;
	}
	///Read Card Mode
	if(1==1){
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = false;
			//alert("1");
		}
		///DHCWeb_DisBtnA("ReadCard");
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
			obj.onclick=FunReadCard;  //ReadHFMagCard_Click;
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

function printRisReport()
{
		if (!PrintRisReportObj)
		{
			PrintRisReportObj = document.getElementById("RptPrint"); // new ActiveXObject("ReportPrintOcx.ocx");
			PrintRisReportObj.PrintReport("77128");
		}
		
		
			
}

function PrintAppBill()
{
	if (SelectedOrdItemRowid!="")
	{
	    GetPrintTemp(SelectedOrdItemRowid)
		var GetPrintAppContentFunction=document.getElementById("GetPrintAppContent").value;
		var PrintContent=cspRunServerMethod(GetPrintAppContentFunction,SelectedOrdItemRowid);
		if (PrintContent=="")
		{
			alert("没有发送申请单不能打印!");
			return
		}
  		InvPrintNew(PrintContent,"");
  
	}
	else
	{
		alert("请选择医嘱");
	}
		

	
}

 function GetPrintTemp(OEorditemID)
 {
	var GetPrintTempFun=document.getElementById("GetAppPrintTemp").value;
  	var value=cspRunServerMethod(GetPrintTempFun,OEorditemID)
  	var Item=value.split("^");
   	if (Item[1]!="")
  	{
	   gPrintTemp=Item[1];
	   gHtmlTemp=Item[3];
  	   DHCP_GetXMLConfig("InvPrintEncrypt",gPrintTemp);
  	}
 
 }
  function InvPrintNew(TxtInfo,ListInfo)
 {
	var myobj=document.getElementById("ClsBillPrint");
 	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	//call xml print from zhaochangzhong
 	//DHCP_PrintFunHDLP(myobj,TxtInfo,ListInfo);
 } 

function paiditemI_click()
{
	var objtbl=document.getElementById('tDHCRisWorkBenchEx');
	var rows=objtbl.rows.length;
	
	var LocID=session['LOGON.CTLOCID'];
	var ChartBookID="39"
	var EpisodeID="";
	
    for (i=1;i<rows;i++)
    {
	    var selectedobj=document.getElementById("TSelectedz"+i);

        if ((selectedobj)&&(selectedobj.checked))
        {   
            SelectedPatientType=document.getElementById("TPatientTypez"+i).innerText;
            var AutoInputFee=document.getElementById("AutoInputFeez"+i).innerText;
		    var EndInputFee=document.getElementById("EndInputFeez"+i).innerText;
            
            if(SelectedPatientType!="住院病人")
          	{
	            alert("不是住院病人!");
	            return;
	        }
	        
	        if(AutoInputFee!="Y")
	        {
		        alert("此医嘱不需划价!");
		        return;
		    }
	      
          	var EpisodeID=document.getElementById("EpisodeIDz"+i).value;
            var OEorditemID=document.getElementById("OEOrdItemIDz"+i).value;
            //var GetItemGroupFun=document.getElementById("GetItemGroup").value;
            var PatientID=document.getElementById("tpapatmasdrz"+i).value;
  	        //var ItemGroupID=cspRunServerMethod(GetItemGroupFun,OEorditemID)
  	        
  	        /*if(ItemGroupID=="")
  	        {
	  	      alert("另划价医嘱的组号为空!")
	  	      return;
	  	    }*/
		  	  
        }
    }
    
    if (EpisodeID=="")
    {
		alert(t['selectedpatient']);
        return;
    }
    var mradm=tkMakeServerCall("web.DHCRisCommFunction","GetMradm",EpisodeID);
    var link="oeorder.entrysinglelogon.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&mradm="+mradm;
    //alert(link);
    //var link="oeorder.oplistcustom.csp?SingleOEWIN=1&CTLOC="+LocID+"&EpisodeID="+EpisodeID+"&PatientID="+PatientID;      
    var mynewlink=open(link,"RAOEWIN","status=yes,scrollbars=yes,resizable=yes,top=6,left=6,width=1000,height=680");
         	
}


//打印便条
function PrintNote_click()
{
	var objtbl=document.getElementById('tDHCRisWorkBenchEx');
	var rows=objtbl.rows.length;
	var EpisodeID="";

    for (i=1;i<rows;i++)
    {
	    var selectedobj=document.getElementById("TSelectedz"+i);
        if((selectedobj)&&(selectedobj.checked))
        {   
            var EpisodeID=document.getElementById("EpisodeIDz"+i).value;
            var Name=document.getElementById("TPatientNamez"+i).innerText;
			var BedCode=document.getElementById("TBedCodez"+i).innerText;
			var Sex=document.getElementById("TSexz"+i).innerText;
			var Age=document.getElementById("TAgez"+i).innerText;
			var AppDate=document.getElementById("AppDatez"+i).innerText;
			var ReqDoc=document.getElementById("ReqDocz"+i).innerText;
			var Diagnoise=document.getElementById("Diagnoisez"+i).innerText; 
			var WardName=document.getElementById("WardNamez"+i).innerText;
			var LocName=document.getElementById("TLocNamez"+i).innerText;
			var IPNO=document.getElementById("TIPNOz"+i).innerText;
			var OrdName=document.getElementById("ARCIMDescz"+i).innerText;
			var RegNo=document.getElementById("PatientIDz"+i).innerText;
			var PrintDate=GetCurrentDate();
			
			
			DHCP_GetXMLConfig("InvPrintEncrypt","DHCRisAppTest");
			
			
			var MyPara="PatientName"+String.fromCharCode(2)+Name;
		    MyPara=MyPara+"^BedCode"+String.fromCharCode(2)+BedCode;
		    MyPara=MyPara+"^Sex"+String.fromCharCode(2)+Sex;
		    MyPara=MyPara+"^Age"+String.fromCharCode(2)+Age;
		    MyPara=MyPara+"^AppDate"+String.fromCharCode(2)+AppDate;
		    MyPara=MyPara+"^ReqDoc"+String.fromCharCode(2)+ReqDoc;
		    MyPara=MyPara+"^Diagnoise"+String.fromCharCode(2)+Diagnoise;
		    MyPara=MyPara+"^WardName"+String.fromCharCode(2)+WardName;
		    MyPara=MyPara+"^LocName"+String.fromCharCode(2)+LocName;
	        MyPara=MyPara+"^IPNO"+String.fromCharCode(2)+IPNO;
	        MyPara=MyPara+"^OrdName"+String.fromCharCode(2)+OrdName;
	        MyPara=MyPara+"^RegNo"+String.fromCharCode(2)+RegNo;
	        MyPara=MyPara+"^PrintDate"+String.fromCharCode(2)+PrintDate;
	        
		    var myobj=document.getElementById("ClsBillPrint");
	        DHCP_PrintFun(myobj,MyPara,"");
	        return;
	        
        }
    }
    
    if (EpisodeID=="")
    {
		alert(t['selectedpatient']);
        return;
    }
    
   
}

//test
function EqStatics_click()
{
	var objtbl=document.getElementById('tDHCRisWorkBenchEx');
	var rows=objtbl.rows.length;
	var EpisodeID="";

    for (i=1;i<rows;i++)
    {
	    var selectedobj=document.getElementById("TSelectedz"+i);
        if((selectedobj)&&(selectedobj.checked))
        {   
            var EpisodeID=document.getElementById("EpisodeIDz"+i).value;
            LocDR=document.getElementById("RecLocIdz"+i).value;
			var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisLocEQStatics&LocID="+LocDR+"&Date1=";
            var NewWin=open(lnk,"dhcrisappbill","scrollbars=yes,resizable=yes,top=6,left=6,width=500,height=680");  
		    return false;
        }
    }
    
    if (EpisodeID=="")
    {
		alert(t['selectedpatient']);
        return;
    }
    
   
}



function GetCurrentDate()
{
	var d, s="";         
    d = new Date(); 
    var sDay="",sMonth="",sYear="";
    sDay = d.getDate();		
    if(sDay < 10)
    sDay = "0"+sDay;
    
    sMonth = d.getMonth()+1;		
    if(sMonth < 10)
    sMonth = "0"+sMonth;
    
    sYear  = d.getYear();	
    
    var sHoure=d.getHours();
    var sMintues=d.getMinutes();
    	
    s=sYear +"-"+sMonth+"-"+sDay+"    "+sHoure+":"+sMintues ;
    
    return s;

}

function DoActionFind(Action)
{
	var AllowAutoQueryFunction=document.getElementById("AllowAutoQuery").value;
	var ret=cspRunServerMethod(AllowAutoQueryFunction,Action);
	if (ret=="Y")
	{	
		FindClickHandler();
	}
}

function GetRegNofromCardNo(CarNo)
{
	var GetRegNofromCardNoFun=document.getElementById("GetRegNofromCardNo").value;
	var value=cspRunServerMethod(GetRegNofromCardNoFun,CarNo);
	return value;
}

//获取发布报告影响路径
function GetRptParm(cLocDr,StudyNo,OEOrdItem)
{
	RptParm = "";
	var userid=session['LOGON.USERID'];
	var Ins=document.getElementById('GetClinicSet');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var Info=cspRunServerMethod(encmeth,cLocDr);
	var Infolist=Info.split("^");
	
	var ReportFullFil,RhasReg,RRegParam,RhasStudyNo,RStuyParam,RDelim,RhasOParam,ROtherParam
 	ReportFullFil=Infolist[0];
  	RhasReg=Infolist[1];
    RRegParam=Infolist[2];
	RhasStudyNo=Infolist[3];
	RStuyParam=Infolist[4];
	RDelim=Infolist[5];
	RhasOParam=Infolist[12];
	ROtherParam=Infolist[13];
	
	
	if (RhasReg=="Y")
	{
		RptParm = RRegParam+PatientID;
	}
	if (RDelim!="")
	{
		RptParm = RptParm + RDelim;
	}
	if (RhasStudyNo=="Y")
	{
	    RptParm="&SID="+StudyNo;
	}
	
	if(RhasOParam=="Y")
	{
	   var OElist1=OEOrdItem.split("||")[0]
	   var OElist2=OEOrdItem.split("||")[1]
	   if(ROtherParam=="DHCC")
	   {
	      RptParm="&LID="+cLocDr+"&SID="+StudyNo+"&OID="+OEOrdItem+"&USERID="+userid;
	   }
	   else if (ROtherParam!="")
	   {
		   
		    RptParm=ROtherParam+OEOrdItem
		   
	   }
	   else
	   {
		    RptParm=OEOrdItem
	   }	   
	}
	
	RptParm = ReportFullFil + RptParm;
	
	if(ReportFullFil=="RptView.DLL")
	{
		RptParm = "RptView.DLL";
	}
	if(ReportFullFil=="PISRptView.DLL")
	{
		RptParm = "PISRptView.DLL";
	}
	
	return RptParm;
}

function Clinic_click()
{
	try
	{
		var objtbl=document.getElementById('tDHCRisWorkBenchEx');
		var rows=objtbl.rows.length;
		
		var LastStudyNo="";
	
	    for (i=1;i<rows;i++)
	    {
		    var selectedobj=document.getElementById("TSelectedz"+i);
	        if((selectedobj)&&(selectedobj.checked))
	        {   
				 var GetStudyNo=document.getElementById("TStudyNoz"+i).innerText;
				 var LocDR=document.getElementById("RecLocIdz"+i).value;
				 var OEorditemID=document.getElementById("OEOrdItemIDz"+i).value;
				 var Status=document.getElementById("TStatusz"+i).innerText;
				 
				 if (Status!="检查结束")
				 {
					 alert("报告未完成不能浏览");
					 return false;
				 }
				 
				 if ((GetStudyNo=="")||(GetStudyNo==" "))
				 {
					 alert(t['NotStudyNo']);
					 return false;
				 }
		         else if ((LastStudyNo!="")&&(LastStudyNo!=GetStudyNo))
		         {
			        alert(t['NotSamePatient']);
			        return false;
			     }
			     else
			     {
				     LastStudyNo=GetStudyNo;
			     }    
		    }    
		    		
		}
		
		if ((GetStudyNo!="")&(LocDR!="")&(OEorditemID!=""))
		{
		  
	       var RptParm=GetRptParm(LocDR,GetStudyNo,OEorditemID);
	           
	       if((RptParm!="")&&(RptParm!=" "))
	       {
			    var Item=RptParm.split(":")
			    if (Item[0]=="http")
			    {
			       window.open(RptParm, "", "scrollbars=yes,resizable=yes, height=600, width=800, toolbar=no, menubar=no,location=no,status=no,top=100,left=300");
			    }
			    else 
			    {
				 	var curRptObject = new ActiveXObject("wscript.shell");
					//var ret=curRptObject.Exec(RptParm);
					curRptObject.run(RptParm);
			    }
		    
	            return false;
	        } 
	        else
	        {
		        alert(t['NotSetClinic']);  
		        return false;  
		    }  
	        
	  	 }
     }
  catch(e) 
	 {
		//alert("1");
		//alert(e.message);
	
		alert("请选择医嘱!")
		
	 }
	
}




function f_s(id){
       var obj=document.getElementById(id);
       obj.style.display="block";
       obj.style.height="1px"; 
	         
       var changeW=function(){ 	 		
              var obj_h=parseInt(obj.style.height);
              if(obj_h<=335){ 
                     obj.style.height=(obj_h+Math.ceil((335-obj_h)/10))+"px";
              }
              else{ 
              clearInterval(bw1);
              }
       }       
       bw1= setInterval(changeW,1);
	   if(flag>0){
	   	 clearInterval(bw2);
	   }
}
function closeW(id){
		flag++;
       var obj=document.getElementById(id);
       var closeDiv=function(){
	   		 
	   		  clearInterval(bw1);
              var obj_h=parseInt(obj.style.height);
              if(obj_h>1){ 
                     obj.style.height=(obj_h-Math.ceil(obj_h)/10)+"px";
					
              }
              else{
              clearInterval(bw2);
              obj.style.display="none";
              }
       }         
      bw2= setInterval(closeDiv,1);

}
function showDiv(){ 
	var ele = document.getElementById("div1");
	clearInterval(bw1);
	clearInterval(bw2);
	ele.style.display = "block";
	ele.style.height = 335 + "px";

}

function ExportList_onclick()
{
	try 
	{
		var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCRisWorklistExport.xls";
	    var CellRows ;
	    var Isprint=1;
	    var Pageindex=0;
	    var PrintedRows=0;
	    var j=0;
	   
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	   
	    //alert("1");
	    var UserID=session['LOGON.USERID'];
	    //alert("2");
	    var PrintCount=document.getElementById("PrintCountFun").value;
 	    var Nums=cspRunServerMethod(PrintCount,UserID);
 	    //alert("3");
 	    if (Nums==0)
 	    {
	 	    alert("请查询记录后在导出!");
	 	    return ;
	 	}
        /*GetRegNo_"^"_GetName_"^"_GetSexDesc_"^"_GetstrAge_"^"_GetstrDOB_"^"_GetIDCDesc_"^"_GetStudyNo_"^"_GetstrOrderName_"^"_Getrequestdoc_"^"_GetstrAccessionNum_"^"_
    	 	        0             1            2             3             4             5               6             7                    8                   9
    	 	      GetstrDate_"^"_GetstrTime_"^"_strRppDate_"^"_strRppTime_"^"_$g(GetBookedDuration)_"^"_GetstrRegDate_"^"_GetstrRegTime_"^"_$g(GetRptDocName)_"^"_$g(GetVerifyDocName)_"^"_GetPatientStatus_"^"_paadmdr_"^"_Oeorditemdr_"^"_GetLocName_"^"_GetTotalPrice_"^"_GetPatientStatusCode_"^"_Getbilled_"^"_Gettypedesc_"^"_GetNum_"^"_
    	 	        10                 11          12             13                14                      15               16                  17                       18                     19               20            21              22              23                   24                  25              26          27    
    	 	      Getprice_"^"_GetIndex_"^"_GetEQDesc_"^"_GetResDesc_"^"_Getifbed_"^"_GetReportStatus_"^"_GetMainDoc_"^"_GetAssDoc_"^"_
    	 	        28            29           30             31            32               33               34            35
    	 	      GetRoomDesc_"^"_GetEQGroupDesc_"^"_GetWardName_"^"_$g(GetOldNo)_"^"_$g(Required)_"^"_strXDate_"^"_GetItemStatusCode_"^"_PapatmasDR_"^"_BodyDesc_"^"_Weight_"^"_TelNo_"^"_GetIPNo_"^"_FileSent_"^"_GetBedNo_"^"_$g(ReportSend)_"^"_$g(HaveImage)_"^"_RecLocId_"^"_RecLoc_"^"_$g(AutoInputFee)_"^"_
    	 	          36                37               38               39                40            41               42                43               44        45         46          47         48           49              50                 51              52          53             54
    	
    	 	      $g(EndInputFee)_"^"_Detail_"^"_RejectAppReason_"^"_BilledDesc_"^"_PinYin_"^"_ToDayOeItem_"^"_CostRecords_"^"_AppDate_"^"_Urgentflag_"^"_$g(RegDoc)_"^"_Epissubtype_"^"_$g(GetSGroupDesc)_"^"_GetSGroupDR
    	 	          55                 56            57               58           59            60               61           62            63              64           65                 66                67*/
	 	for (var i=1;i<=Nums;i++)
	 	{
		 	var PrintDFun=document.getElementById("SetPrintDataFun").value;
 	        var PrintData=cspRunServerMethod(PrintDFun,UserID,i);
 	        
 	        if (PrintData!="")
 	        {
	 	        j=j+1
	 	        var tmpary=PrintData.split("^");
	 	        
    	 	   
    	 	      var RegNo=tmpary[0];
    	 	      var Name=tmpary[1];
    	 	      var Sex=tmpary[2];
    	 	      var Age=tmpary[3];
    	 	      var DOB=tmpary[4];
    	 	      var IDCDesc=tmpary[5];
    	 	      var StudyNo=tmpary[6];
    	 	      var OrderName=tmpary[7];
    	 	      var requestdoc=tmpary[8];
    	 	      var AccessionNum=tmpary[9];
    	 	      var OEIDate=tmpary[10];
    	 	      var OEITime=tmpary[11];
    	 	      var RppDate=tmpary[12];
    	 	      var RppTime=tmpary[13];
    	 	      var BookedDuration=tmpary[14];
    	 	      var RegDate=tmpary[15];
    	 	      var RegTime=tmpary[16];
    	 	      var RptDocName=tmpary[17];
    	 	      var VerifyDocName=tmpary[18];
    	 	      var PatientStatus=tmpary[19];
    	 	      var LocName=tmpary[22];
    	 	      var TotalPrice=tmpary[23];
    	 	      var billed=tmpary[25];
    	 	      var typedesc=tmpary[26];
    	 	      var Num=tmpary[27];
    	 	      var price=tmpary[28];
    	 	      var Index=tmpary[29];
    	 	      var EQDesc=tmpary[30];
    	 	      var ResDesc=tmpary[31];
    	 	      var ifbed=tmpary[32];
    	 	      var ReportStatus=tmpary[33];
    	 	      var MainDoc=tmpary[34];
    	 	      var AssDoc=tmpary[35];
    	 	      var RoomDesc=tmpary[36];
    	 	      var EQGroupDesc=tmpary[37];
    	 	      var WardName=tmpary[38];
    	 	      var OldNo=tmpary[39];
    	 	      var Required=tmpary[40];
    	 	      var XDate=tmpary[41];
    	 	      var BodyDesc=tmpary[44];
    	 	      var Weight=tmpary[45];
    	 	      var TelNo=tmpary[46];
    	 	      var IPNo=tmpary[47];
    	 	      var FileSent=tmpary[48];
    	 	      var BedNo=tmpary[49];
    	 	      var ReportSend=tmpary[50];
    	 	      var HaveImage=tmpary[51];
    	 	      var RecLoc=tmpary[53];
    	 	      var AutoInputFee=tmpary[54];
    	 	      var EndInputFee=tmpary[55];
    	 	      var Detail=tmpary[56];
    	 	      var BilledDesc=tmpary[58];
    	 	      var PinYin=tmpary[59];
    	 	      var CostRecords=tmpary[61];
    	 	      var AppDate=tmpary[62];
    	 	      var Urgentflag=tmpary[63];
    	 	      var RegDoc=tmpary[64];
    	 	      var Epissubtype=tmpary[65];
    	 	      var SGroupDesc=tmpary[66];
    	 	      
    	 	      
    	 	      xlsheet.cells(j+3,1)=Name;
			 	  xlsheet.cells(j+3,2)=Sex;
			 	  xlsheet.cells(j+3,3)=Age;
			 	  xlsheet.cells(j+3,4)=DOB;
			 	  xlsheet.cells(j+3,5)=IDCDesc;
			 	  xlsheet.cells(j+3,6)=StudyNo;
			 	  xlsheet.cells(j+3,7)=OrderName;
			 	  xlsheet.cells(j+3,8)=requestdoc; 
			 	  xlsheet.cells(j+3,9)=AccessionNum; 
			 	  xlsheet.cells(j+3,10)=OEIDate;
			 	  xlsheet.cells(j+3,11)=OEITime;
			 	  xlsheet.cells(j+3,12)=RppDate;
			 	  xlsheet.cells(j+3,13)=RppTime;
			 	  xlsheet.cells(j+3,14)=BookedDuration; 
			 	  xlsheet.cells(j+3,15)=RegDate
			 	  xlsheet.cells(j+3,16)=RegTime;
			 	  xlsheet.cells(j+3,17)=RptDocName;
			 	  xlsheet.cells(j+3,18)=VerifyDocName;
			 	  xlsheet.cells(j+3,19)=PatientStatus;
			 	  xlsheet.cells(j+3,20)=LocName;
			 	  xlsheet.cells(j+3,21)=TotalPrice;
			 	  xlsheet.cells(j+3,22)=billed;
			 	  xlsheet.cells(j+3,23)=typedesc; 
			 	  xlsheet.cells(j+3,24)=Num; 
    	 	      xlsheet.cells(j+3,25)=price;
			 	  xlsheet.cells(j+3,26)=Index;
			 	  xlsheet.cells(j+3,27)=EQDesc;
			 	  xlsheet.cells(j+3,28)=ResDesc;
			 	  xlsheet.cells(j+3,29)=ifbed;
			 	  xlsheet.cells(j+3,30)=ReportStatus;
			 	  xlsheet.cells(j+3,31)=MainDoc;
			 	  xlsheet.cells(j+3,32)=AssDoc; 
			 	  xlsheet.cells(j+3,33)=RoomDesc; 
    	 	      xlsheet.cells(j+3,34)=EQGroupDesc; 
    	 	      xlsheet.cells(j+3,35)=WardName; 
    	 	      xlsheet.cells(j+3,36)=OldNo; 
    	 	      xlsheet.cells(j+3,37)=Required; 
    	 	      xlsheet.cells(j+3,38)=XDate; 
    	 	      xlsheet.cells(j+3,39)=BodyDesc; 
    	 	      xlsheet.cells(j+3,40)=Weight; 
    	 	      xlsheet.cells(j+3,41)=TelNo; 
    	 	      xlsheet.cells(j+3,42)=IPNo; 
    	 	      xlsheet.cells(j+3,43)=FileSent; 
    	 	      xlsheet.cells(j+3,44)=BedNo; 
    	 	      xlsheet.cells(j+3,45)=ReportSend; 
    	 	      xlsheet.cells(j+3,46)=HaveImage; 
    	 	      xlsheet.cells(j+3,47)=RecLoc; 
    	 	      xlsheet.cells(j+3,48)=AutoInputFee; 
    	 	      xlsheet.cells(j+3,49)=EndInputFee; 
    	 	      xlsheet.cells(j+3,50)=Detail; 
    	 	      xlsheet.cells(j+3,51)=BilledDesc; 
    	 	      xlsheet.cells(j+3,52)=PinYin; 
    	 	      xlsheet.cells(j+3,53)=CostRecords; 
    	 	      xlsheet.cells(j+3,54)=AppDate; 
    	 	      xlsheet.cells(j+3,55)=Urgentflag; 
    	 	      xlsheet.cells(j+3,56)=RegDoc; 
    	 	      xlsheet.cells(j+3,57)=Epissubtype; 
    	 	      xlsheet.cells(j+3,58)=SGroupDesc; 
    	 	         
     
	 	    }
		}
	 	
 	   
      
        var fname = xlApp.Application.GetSaveAsFilename("save.xls", "Excel Spreadsheets (*.xls), *.xls");
		if (fname!="false") 
		{
		   xlsheet.SaveAs(fname);
	    }
		xlBook.Close (savechanges=false);
        xlApp=null;
        xlsheet=null;
        
	}
	catch(e) 
	{
		alert(e.message);
	};
}

function GetLoc(Info)
{
	var Item=Info.split("^");
	document.getElementById('AppLocDesc').value=Item[0];
	document.getElementById('AppLocID').value=Item[1];
}

/////////////////////////////////////////////TEST///////////////////////
function SetGridStyle()
{
	//$("a").css("color","yellow");
	//$("a").hide();
	//$(document.body).css("background","yellow");
	//$("TD").css("color","red");
	//document.getElementById("EqStatics").style.display='none';
} 
function SetTable()
{
	var t, n, c;
	t = document.getElementById("tDHCRisWorkBenchEx");
    //t.rows[0].style.height="10px"  //在这里设置高度
    var tr = t.getElementsByTagName("th");
    for(var i=0;i<tr.length;i++){
        tr[i].style.height="10px"
    }
   
} 
function InitGridView()
{
        var div_Head1 = document.getElementById("dDHCRisWorkBenchEx");
        var tableBody1 = document.getElementById("tDHCRisWorkBenchEx");
        var tableHead1 = tableBody1.cloneNode(true);
        for(var i=tableHead1.rows.length-1; i>0; i--)
        {
            tableHead1.deleteRow(i);
        }
        tableBody1.deleteRow(0);
        div_Head1.appendChild(tableHead1);
}

function GetSert(LastGroupDR,SGroupDR)
{
	 var c=[];
	 var a=LastGroupDR.split(",");
	 var b=SGroupDR.split(",");
     c=a.intersect(b)
     return c
}
Array.prototype.intersect = function(b) 
{   var flip = {};   
    var res = [];   
    for(var i=0; i< b.length; i++)  flip[b[i]] = i;
    for(i=0; i<this.length; i++)     
    if(flip[this[i]] != undefined) res.push(this[i]);   
    return res; 
}   

///////////////////////////////////////////////////////

document.body.onload = BodyLoadHandler;