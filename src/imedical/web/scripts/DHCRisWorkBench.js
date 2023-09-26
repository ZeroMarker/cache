
//document.write("<OBJECT ID='CPrintExamItem' CLASSID='CLSID:54C13357-859D-4C53-BC5A-DB5B9980530F' CODEBASE='../addins/client/PrintPaidItem.CAB#version=2,0,0,3'>");
//document.write("</object>");

//document.write("<OBJECT ID='ReportDLLReg' CLASSID='CLSID:9FB1732D-28E5-4426-ADD8-A452B365FB69' CODEBASE='../addins/client/ReportDLLReg.CAB#version=1,0,0,0'>")
//document.write("</object>");
//
//
//document.write("<OBJECT ID='ExamList' CLASSID='CLSID:9F8C49CE-4559-4B2B-8852-C5165DFFEC32' CODEBASE='../addins/client/ExamList.CAB#version=1,0,0,0'>");
//document.write("</object>");

//document.write("<OBJECT ID='ClsCacheDBFactory' CLASSID='CLSID:089BC67E-12F1-49CA-AE89-BF48253D038C' CODEBASE='../addins/client/ExamList.CAB#version=1,0,0,0'>")
//document.write("</object>");

var gLocID;
var allowbill="";
var Lookupstr="";

var gPaadm="";
function BodyLoadHandler()
{

   DisplayCondition();
    GetLocName();
        //var LocID=document.getElementById("LocDr");
	
	var StdateObj=document.getElementById("StdDate");
	var eddateObj=document.getElementById("endDate");
	
	
	
	if (StdateObj.value=="")
	{
		//alert(StdateObj.value);
		StdateObj.value=DateDemo();
		eddateObj.value=DateDemo();
	}
	
	/*var InputFeeObj=document.getElementById("InputFee");
    if (InputFeeObj)
    {
	    InputFeeObj.onclick=FunInputFee;
	}
	*/
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
	CheckPaidStatus();
	
	
}

function QueryFee_click1()
{
  var ordtab=document.getElementById("tDHCRisWorkBench");
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
	GetCondition();
	var SetConditionFunction=document.getElementById("SeConditionInfo").value;
	var value=cspRunServerMethod(SetConditionFunction,Lookupstr,userid);

	
}
function GetCondition()
{
	Lookupstr="";
	var Name=document.getElementById("Name").value;
   	var RegNo=document.getElementById("RegNo").value;
  	//var studyno=document.getElementById("StudyNo").value;
   	var ReportDoc=document.getElementById("ReportDoc").value;
  	var VerifyDoc=document.getElementById("VerifyDoc").value;
  	var StatusDesc=document.getElementById("Status").value;
 	var StatusCode=document.getElementById("StatusCode").value;
 	var typecode=document.getElementById("type").value;
 	var typename=document.getElementById("PatientType").value;
 	var ResourceDesc=document.getElementById("Resource").value;
 	var ResourceCode=document.getElementById("ResourceID").value;
 	var RegEQDesc=document.getElementById("RegEQ").value;
	var RegEQCode=document.getElementById("RegEQID").value;
	var StDate=document.getElementById("StdDate").value;
    var endDate=document.getElementById("enddate").value;

    var Sex=document.getElementById("Sex").value;	
    var DOB=document.getElementById("DOB").value;
    var AppObj=document.getElementById("AppLoc").value;
    var byObj=document.getElementById("OrderByIndex");
    var OrderByIndex="",VList="",EList="",BList=""
    if (byObj.checked)
    {
	    OrderByIndex="on"
	} 
	
	var Vobj=document.getElementById("VerfiedOrdList");
	var Eobj=document.getElementById("RegList");
	var Bobj=document.getElementById("BookedList");
	
    if (Vobj.checked)
    {
	    VList="on"
	}
	if (Eobj.checked)
	{
		EList="on"
	} 
	if (Bobj.checked)
	{
		BList="on"
	}
		  
	Lookupstr=RegNo+"^"+Name+"^"+ReportDoc+"^"+VerifyDoc+"^"+StatusDesc+"^"+StatusCode+"^"+typecode+"^"+typename;
	Lookupstr=Lookupstr+"^"+ResourceDesc+"^"+ResourceCode+"^"+RegEQDesc+"^"+RegEQCode+"^"+StDate+"^"+endDate;
	Lookupstr=Lookupstr+"^"+Sex+"^"+DOB+"^"+AppObj+"^"+OrderByIndex+"^"+VList+"^"+BList+"^"+EList;
	
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
	//document.getElementById("StudyNo").value=Item[0];
	document.getElementById("RegNo").value=Item[0];
	document.getElementById("Name").value=Item[1];
	document.getElementById("ReportDoc").value=Item[2];
	document.getElementById("VerifyDoc").value=Item[3];
	document.getElementById("Status").value=Item[4];
	document.getElementById("StatusCode").value=Item[5];
	document.getElementById("type").value=Item[6];
	document.getElementById("PatientType").value=Item[7];
	document.getElementById("Resource").value=Item[8];
	document.getElementById("ResourceID").value=Item[9];
	document.getElementById("RegEQ").value=Item[10];
	document.getElementById("RegEQID").value=Item[11];
	document.getElementById("StdDate").value=Item[12];
	document.getElementById("enddate").value=Item[13];
	document.getElementById("Sex").value=Item[14];	
	document.getElementById("DOB").value=Item[15];
	document.getElementById("AppLoc").value=Item[16];
	//alert(Item[17]);
	var byObj=document.getElementById("OrderByIndex");
	if (Item[17]=="on")
		byObj.checked=true;
	else
		byObj.checked=false;
	var VObj=document.getElementById("VerfiedOrdList");
	if (Item[18]=="on")
		VObj.checked=true;
	else
		VObj.checked=false;

	var BObj=document.getElementById("BookedList");
	if (Item[19]=="on")
		BObj.checked=true;
	else
		BObj.checked=false;
	var EObj=document.getElementById("RegList");
	if (Item[20]=="on")
		EObj.checked=true;
	else
		EObj.checked=false;
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
    var myrtn=DHCACC_GetAccInfo();
    //alert(myrtn);
	var myary=myrtn.split("^");
	var rtn=myary[0];
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
			alert(t["cardvaliderr"])
		default:
	}
	
}

function paiditem_click1()
{
	//allowbill=myary[5];
	var obj=document.getElementById("CardNo");
	allowbill=obj.value;
	if (allowbill=="")
	{
		alert(t["InputCard"]);
	}
	else
    {
		ReLoadOPFoot("Bill");
	}
	
	
}
/*
function FunInputFee()
{
	var myrtn=DHCACC_GetAccInfo();
    var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn)
	{
		case "0":
			var obj=document.getElementById("RegNo");
			obj.value=myary[5];
			var obj=document.getElementById("CardNo");
			obj.value=myary[1];
		
			gPAPATMASDR=myary[4];
		
			GetPatientInfo();
			if (myary[5]!="")
			{
				ReLoadOPFoot("App");
			}			
			break;
		case "-200":
			alert(t["cardinvalid"]);
			break;
		case "-201":
			alert(t["cardvaliderr"])
		default:
	}
}
*/
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
		//alert(gPaadm);
		//var gPaadm=2441;
		if ((gPaadm=="")||(gPAPATMASDR==""))
		{
			var lnk="udhcopbillif.csp?PatientIDNo="+RegNo+"&CardNo="+card;
			//alert(lnk);
			var NewWin=open(lnk,"udhcopbillif","scrollbars=yes,resizable=yes,top=6,left=6,width=1000,height=680");
		}
		else
		{
			//alert("paadm");
			var lnk="udhcopbillforadmif.csp?CardNo="+card+"&SelectAdmRowId="+gPaadm+"&SelectPatRowId="+gPAPATMASDR;
			//alert(lnk);
			var NewWin=open(lnk,"udhcopbillif","scrollbars=no,resizable=no,top=6,left=6,width=1000,height=680");

		}
		

	}
	
}
	


function RegNo_keyDown()
{
	var key =websys_getKey(e)
	if (key==13)
	{
		GetPatientInfo();
		FindClickHandler();
		
	}
	
	
}
function StudyNo_keyDown()
{
	var key =websys_getKey(e)
	if (key==13)
	{
		GetPatientInfo();
		FindClickHandler();
		
	}
}


function GetPatientInfo()
{
	var NameObj=document.getElementById("Name");
    var SexObj=document.getElementById("Sex");	
    var DOBObj=document.getElementById("DOB");
    var AppObj=document.getElementById("AppLoc");
  	var RegNo=document.getElementById("RegNo").value;
	if (RegNo=="")
	{
		NameObj.value="";
  		SexObj.value="";
    	DOBObj.value="";
	    AppObj.value="";	
    }
	else
	{
		var zero="";
		for (var i=0;i<8-RegNo.length;i++)
	 	{
			 zero=zero+"0";
	 	}
	 	RegNo=zero+RegNo;
	 	document.getElementById("RegNo").value=RegNo;
	 	var obj=document.getElementById("CardNo");
		//if (obj.value=="")
		//   obj.value=RegNo;
		
		var FunctionGetPatient=document.getElementById("GetPatient").value;
		var Info=cspRunServerMethod(FunctionGetPatient,RegNo);
    	var Infolist=Info.split("^");
 	  	NameObj.value=Infolist[0];
  		SexObj.value=Infolist[1];
    	DOBObj.value=Infolist[3];
	    AppObj.value=Infolist[4];	
	}
  
  	
	
}

function DateDemo()
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

function GetStatus(Info)
{
	var item=Info.split("^");
	document.getElementById("Status").value=item[0];
	document.getElementById("StatusCode").value=item[1];
	
	 var VObj=document.getElementById("VerfiedOrdList");
     VObj.checked=false;
     var BObj=document.getElementById("BookedList");
	 BObj.checked=false;
	 var EObj=document.getElementById("RegList");
     EObj.checked=false;
	 	
	//FindClickHandler();

	
}

function GetResource(Info)
{
	var item=Info.split("^");
	document.getElementById("Resource").value=item[0];
	document.getElementById("ResourceID").value=item[1];
	//FindClickHandler();

}

function GetTypeDesc(Info)
{
	var item=Info.split("^");
	document.getElementById("PatientType").value=item[0];
	document.getElementById("type").value=item[1];
	//FindClickHandler();

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
	if ((days>7)&&(regNo=="")&&(Name=="")&&(StudyNo==""))
	{
		alert(t['toolong']);
		return;
	}
	
	var LockObj=document.getElementById("Lock");
 	if (LockObj.checked)
 	{
	 	setCondition();
	}
	return  Find_click();
}

function Clickclear(e)
{
	document.getElementById("RegNo").value="";
	document.getElementById("Name").value="";
    document.getElementById("Sex").value="";	
    document.getElementById("DOB").value="";
    document.getElementById("AppLoc").value="";
    document.getElementById("StudyNo").value="";
    document.getElementById("ReportDoc").value="";
  	document.getElementById("VerifyDoc").value="";
  	document.getElementById("ResourceID").value="";
  	document.getElementById("Resource").value=""
  	
  	
  	document.getElementById("Status").value="";
 	document.getElementById("StatusCode").value="";
 	document.getElementById("type").value="";
 	document.getElementById("PatientType").value="";
 	document.getElementById("RegEQ").value="";
	document.getElementById("RegEQID").value="";
	
	 var VObj=document.getElementById("VerfiedOrdList");
     VObj.checked=false;
     var BObj=document.getElementById("BookedList");
	 BObj.checked=false;
	 var EObj=document.getElementById("RegList");
	 EObj.checked=false;
	 var gPaadm="";
	 var gPAPATMASDR="";
	 var obj=document.getElementById("CardNo");
	 obj.value="";


	 //FindClickHandler();    
    
  	
}



function BookedList_click1()
{
	document.getElementById("Name").value="";
    document.getElementById("Sex").value="";	
    document.getElementById("DOB").value="";
    document.getElementById("AppLoc").value="";
  	document.getElementById("RegNo").value="";
  	
 	document.getElementById("Status").value="";
 	document.getElementById("StatusCode").value="";
 
  	
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
    document.getElementById("Sex").value="";	
    document.getElementById("DOB").value="";
    document.getElementById("AppLoc").value="";
  	document.getElementById("RegNo").value="";
  	
  	document.getElementById("Status").value="";
 	document.getElementById("StatusCode").value="";
 
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

function RegList_click()
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
function Oderby_click()
{
    document.getElementById("Name").value="";
    document.getElementById("Sex").value="";	
    document.getElementById("DOB").value="";
    document.getElementById("AppLoc").value="";
  	document.getElementById("RegNo").value="";
	document.getElementById("StudyNo").value="";
	
	var eddateObj=document.getElementById("endDate");
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
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisWorkBench');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
     
    var regno=document.getElementById("PatientIDz"+selectrow).innerText;
    var name=document.getElementById("TPatientNamez"+selectrow).innerText;
  	//var studyno=document.getElementById("TStudyNoz"+selectrow).innerText;
    var Sex=document.getElementById("TSexz"+selectrow).innerText;
    var DOB=document.getElementById("TDOBz"+selectrow).innerText;
    var LocName=document.getElementById("TLocNamez"+selectrow).innerText;
    
    var ReportDoc=document.getElementById("TReportDocz"+selectrow).innerText;
    var VerifyDoc=document.getElementById("TVerifyDocz"+selectrow).innerText;
    var selectedobj=document.getElementById("TSelectedz"+selectrow);
   // if ((selectedobj)&&(selectedobj.checked))
   // {
    //	gPaadm=document.getElementById("EpisodeIDz"+selectrow).value;
    //	alert(gPaadm);
    //}
   //lgl+令只可单选
    //var lval=objtbl.rows(i).cells(j).Name;
    for (var j=1; j < rows; j++)  
    {
	  var selectedobj=document.getElementById("TSelectedz"+j);
	  if ((selectedobj)&&(j!=selectrow))
	  {
		selectedobj.checked=0; 
	  }
	  else
	  {
		selectedobj.checked=1; 
      }
    }
     //lgl 移至此处 
    var selectedobj=document.getElementById("TSelectedz"+selectrow);
    //alert(selectedobj.checked);
      if ((selectedobj)&&(selectedobj.checked))
    {
    	gPaadm=document.getElementById("EpisodeIDz"+selectrow).value;
    	//alert(gPaadm);
    }

    /*document.getElementById("Name").value=name;
    document.getElementById("Sex").value=Sex;	
    document.getElementById("DOB").value=DOB;
    document.getElementById("AppLoc").value=LocName;
  	document.getElementById("RegNo").value=regno;
  	//document.getElementById("StudyNo").value=studyno;
  	document.getElementById("ReportDoc").value=ReportDoc;
  	document.getElementById("VerifyDoc").value=VerifyDoc;
  	document.getElementById("CardNo").value=regno;
	*/	
  
    //call patient when patient arrived 
   	var status=document.getElementById("TStatusz"+selectrow).innerText;
   	var PAPMINameLink='TPatientNamez'+selectrow;
   	if (eSrc.id==PAPMINameLink)
  	{
	  	if (status==t['Execute'])
	  	{
	  	  var Ans=confirm(t['CallPatient']+' '+name+'......')
		  if (Ans==false) {return false;}
		  var room=document.getElementById("TRegResourcez"+selectrow).innerText;
	      var RegDoctor=session['LOGON.USERNAME'];
   		  var AdmDep=document.getElementById("LocName").value;
    	  var LocID=document.getElementById("LocDr").value;
    	  var SeqNo=document.getElementById("RegNoIndexz"+selectrow).innerText;
    	  var PatString=regno+'^'+SeqNo+'^'+name+'^'+room+'^'+RegDoctor+'^'+AdmDep+'^'+LocID;
   		  var SendPatient=document.getElementById('SendPatient');
		  if (SendPatient) {var encmeth=SendPatient.value} else {var encmeth=''};
		  var SendStatus=cspRunServerMethod(encmeth,PatString);
		  return false;
	  	}
		return false;
   	 }
  	 var AppointmentLink='TBookedTimez'+selectrow;
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

function GetReportInfo(Info)
{
	Item=Info.split("^");
	
	document.getElementById("ReportDoc").value=Item[0];
	
	//FindClickHandler();
		
  
	
}

function GetVerifiedDoc(Info)
{
	Item=Info.split("^");
	document.getElementById("VerifyDoc").value=Item[0];
 	//FindClickHandler();
		
}

function GetRegInfo(Info)
{
	Item=Info.split("^");
	document.getElementById("RegEQ").value=Item[0];
	document.getElementById("RegEQID").value=Item[1];
  	//FindClickHandler();
		
}


function CheckPaidStatus()
{
	//lgl+ 未计费颜色
	var tbl=document.getElementById("tDHCRisWorkBench");
	var row=tbl.rows.length;
	row=row-1;
	for (var j=1;j<row+1;j++)
	{
		var PaidStatus=document.getElementById('TBillStatus'+'z'+j);
		if (PaidStatus.innerText!="P")
		{   
		   // alert(PaidStatus.innerText);
			tbl.rows[j].style.backgroundColor="#D0FFFF";  //"Green";	
		 }
	}
}

function GetSelectedLocInfo(Info)
{
  Item=Info.split("^");
  document.getElementById("LocName").value=Item[0];
  document.getElementById("LocDr").value=Item[1];
  
  //put selected locid into session
   var SetSessionLocid=document.getElementById("SetLocsession").value;
   cspRunServerMethod(SetSessionLocid,"SelLocID",Item[1]);
          
  
  
	

}


document.body.onload = BodyLoadHandler;