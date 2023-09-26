
var selectedrows;
var curPrintObject;
var LastCheckIndex=-1;
var gPrintTemplate="";

 

function BodyLoadHandler()
 {	
 	GetLocID();
   
    var Locobj=document.getElementById("LocID");
    //alert(Locobj.value);
    var AdmOBJ=document.getElementById("EpisodeID");
    //alert(AdmOBJ.value);
   	var paadmrowid=AdmOBJ.value;
    //alert(paadmrowid);
    
    var OEOrdItemIDOBJ=document.getElementById("OEOrdItemID");
    
    
	var obj=document.getElementById("Booking");
	if (obj)
	{
		obj.onclick=Bookingclick1;
	}
	
	var Findobj=document.getElementById("Find1");
	if (Findobj)
	{
	   Findobj.onclick=FindClick1;
	}
	 var AppStDate=document.getElementById("AppStDate").value;
	if (AppStDate=="")
	{
		document.getElementById("AppStDate").value=DateDemo();
	}
	
	 var todayobj=document.getElementById("today");
	if (todayobj)
	{
	   todayobj.onclick=todayclick1;
	}
	 var tommrrowobj=document.getElementById("tommorrow");
	if (tommrrowobj)
	{
	   tommrrowobj.onclick=tommrrowobjclick1;
	}
	var aftertommorrowobj=document.getElementById("aftertommorrow");
	if (aftertommorrowobj)
	{
	   aftertommorrowobj.onclick=aftertommorrowobjclick1;
	}
	
	var UnCheckObj=document.getElementById("UnCheck");
	if (UnCheckObj)
	{
	   UnCheckObj.onclick=UnCheckClick;
	}
	
	var GetPatientName=document.getElementById("Name").value;
	var Info=cspRunServerMethod(GetPatientName,paadmrowid);
	//s Info=RegNo_"^"_Name_"^"_strDOB_"^"_strAge_"^"_$g(SexDesc)_"^"_patienttype_"^"_typedesc_"^"_$g(LocName)_"^"_IPNO_"^"_wardname_"^"_bedname_"^"_$g(Locdr)_"^"_SexDr_"^"_WardDr_"^"_roomdesc_"^"_feetype_"^"_Docdr_"^"_DocName_"^"_Telphone_"^"_Height_"^"_Weight_"^"_Adress_"^"_SafetynetCardNo_"^"_papatmasmdr

	var patinfo=Info.split("^");
	document.getElementById("Name").value=patinfo[1];
	document.getElementById("PatientID1").value=patinfo[0];
	document.getElementById("Sex").value=patinfo[4];
	document.getElementById("birthday").value=patinfo[2];
	document.getElementById("WardName").value=patinfo[9];
	document.getElementById("BedNo").value=patinfo[10];
	var oeorditemrowid=document.getElementById("OEOrdItemID").value;
	if (oeorditemrowid!="")
	{
		var OrdItem=oeorditemrowid.split("||");
		var GetItemNameFunction=document.getElementById("ItemName").value;
    	var ItemNameInfo=cspRunServerMethod(GetItemNameFunction,OrdItem[0],OrdItem[1]);
    	var ListInfo=ItemNameInfo.split("^");
    	document.getElementById("ItemName").value=ListInfo[0];
	}
    	//document.getElementById("TotalPrice").value=ListInfo[1];
     CheckSelectStatus();
     
     GetLocPrintTemplate();
     
	
 }
 //////////////////
function CheckSelectStatus()
{
	//lgl+ 未计费颜色
	var tbl=document.getElementById("tDHCRisAppointment");
	var row=tbl.rows.length;
	row=row-1;
	var totalLength=0;
	for (var j=1;j<row+1;j++)
	{
		var selectedobj=document.getElementById("Selectedz"+j);
		if ((selectedobj)&&(selectedobj.checked))
		{
		   // alert(PaidStatus.innerText);
			tbl.rows[j].style.backgroundColor="#D0FFFF";  //"Green";
			var perlength=document.getElementById("Lengthz"+j).innerText;
			perlength=eval(perlength);
			totalLength=totalLength+perlength;	
		 }
	}
	    document.getElementById("AppLength").value=totalLength;
}

//get location Booked print template
function GetLocPrintTemplate()
{
   var locdr=document.getElementById("LocID").value;
   var GetRegTempFunction=document.getElementById("GetLocPrintTemp").value;
   gPrintTemplate=cspRunServerMethod(GetRegTempFunction,locdr);	

	
}

function GetEQPrintTemplate(EQDr)
{
   var locdr=document.getElementById("LocID").value;
   var GetEQTempFunction=document.getElementById("GetEQPrintTemplate").value;
   var PrintTemplate=cspRunServerMethod(GetEQTempFunction,EQDr);
   if (PrintTemplate!="") gPrintTemplate=PrintTemplate;
   	
}

function GetLocID()
{
	//alert("ID");
	var LocID=document.getElementById("LocID");
	var GetLocSessionFunction=document.getElementById("GetLocSession").value;
	 var Getlocicvalue=cspRunServerMethod(GetLocSessionFunction,"SelLocID");
	 if (Getlocicvalue=="")
                 LocID.value=session['LOGON.CTLOCID'];
         else 
 		LocID.value=Getlocicvalue;
 	//alert(LocID.value);
 	}
 function todayclick1()
 {
	  
	var GetDayFunction=document.getElementById("offsetdays").value;
    var value=cspRunServerMethod(GetDayFunction,"0");
    document.getElementById("AppStDate").value=value;
    
    FindClick1();
 }
 
 function tommrrowobjclick1()
 {
	 
    var GetDayFunction=document.getElementById("offsetdays").value;
    var value=cspRunServerMethod(GetDayFunction,"1");
    document.getElementById("AppStDate").value=value;
    
    FindClick1();
 }
 
 function aftertommorrowobjclick1()
 {
	 
    var GetDayFunction=document.getElementById("offsetdays").value;
    var value=cspRunServerMethod(GetDayFunction,"2");
    document.getElementById("AppStDate").value=value;
    
    FindClick1();
 }
 
 function UnCheckClick()
 {
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisAppointment');
	var rows=objtbl.rows.length;
	var rowObj=getRow(eSrc);
	
	for (var j=1; j < rows; j++)  
    {
		var selectedobj=document.getElementById("Selectedz"+j);
		if ((selectedobj)&&(selectedobj.checked))
		{
			selectedobj.checked=0;
		}
    }
    LastCheckIndex!=-1;
 }
 
 function FindClick1()
 {
	 var ResourceID=document.getElementById("ResourceID").value;
	 var Resource=document.getElementById("Resource").value;
	 var OEOrdItemID=document.getElementById("OEOrdItemID").value;
	 var LocID=document.getElementById("LocID").value;
     var AppStDate=document.getElementById("AppStDate").value;
	 var EpisodeID=document.getElementById("EpisodeID").value;
	 //alert(AppStDate);
     //+"&Resource="+Resource+
	 //location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisAppointment&ResourceID="+ResourceID+"&OEOrdItemID="+OEOrdItemID+"&LocID="+LocID+"&AppStDate="+AppStDate+"&EpisodeID="+EpisodeID;
	 //alert(location.href);
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisAppointment&ResourceID="+ResourceID+"&OEOrdItemID="+OEOrdItemID+"&LocID="+LocID+"&AppStDate="+AppStDate+"&EpisodeID="+EpisodeID;

	 
     //document.getElementById("EpisodeID").value=EpisodeID
	 //alert("Click");
 }
 
 
 function Bookingclick1()
 {
	var Selectedrow=0;
	var tabobj=document.getElementById("tDHCRisAppointment");
	if (tabobj)
	{
		var HasSelected=0;
		var ApptSchDr,SelApptSchDr="";
		var IsSequnceSel=0,LastSelRow=-1;
		for (var i=1; i<tabobj.rows.length; i++)
		{
			var obj=document.getElementById("Selectedz"+i);
			if ((obj)&&(obj.checked)&&(!HasSelected))
			{
			  	Selectedrow=i;
			  	HasSelected=1;
			}
			if ((obj)&&(obj.checked))
			{
				if ((LastSelRow!=-1)&&(i-LastSelRow!=1))
				{
					alert(t['SequenceSel']);
					return;
				}
				LastSelRow=i;
				ApptSchDr=document.getElementById("ApptSchDrz"+i).value;
	            if (SelApptSchDr=="")
	            {
		           SelApptSchDr=ApptSchDr
	            }
	            else
	            {
		            SelApptSchDr=SelApptSchDr+"^"+ApptSchDr
		        }
			}
		}
		if (Selectedrow!=0)
		{
			var ResDesc=document.getElementById("TResourcez"+Selectedrow).innerText
			var BookedDate=document.getElementById("AppointDatez"+Selectedrow).innerText;
			var BookedStTime=document.getElementById("StTimez"+Selectedrow).innerText;
			var BookedEdTime=document.getElementById("EndTimez"+Selectedrow).innerText;
			var MaxBookingNum=document.getElementById("MaxAppointNumz"+Selectedrow).innerText;
			var CurBookedNum=document.getElementById("CurrentAppNumz"+Selectedrow).innerText;
			var MaxLoad=document.getElementById("MaxLoadz"+Selectedrow).innerText;
			var OperID=session['LOGON.USERID'];
			//var Lenght=document.getElementById("Lengthz"+Selectedrow).innerText;
			var Lenght=document.getElementById("AppLength").value;
			var OEOrdItemID=document.getElementById("OEOrdItemID").value;
			var EpisodeID=document.getElementById("EpisodeID").value
			var EQDr=document.getElementById("EQDRz"+Selectedrow).value;
			if (EQDr!="") GetEQPrintTemplate(EQDr); 
		
			var GetUpdateBooking=document.getElementById("UpdateBooking").value;
			//alert(SelApptSchDr);
		   	var value1=cspRunServerMethod(GetUpdateBooking,EpisodeID,OEOrdItemID,BookedDate,BookedStTime,OperID,Lenght,SelApptSchDr);
	   		if (value1!="0")
	   		{
	    		alert(t['BookingFailure']);
	   		}
			else
	   		{
	    		alert(t['BookedSucess']);
	    		if (gPrintTemplate!="")
				{
			   		DHCP_GetXMLConfig("InvPrintEncrypt",gPrintTemplate);
			   		var PatientName=document.getElementById("Name").value;
					var PatientID=document.getElementById("PatientID1").value;
					var Sex=document.getElementById("Sex").value;
					var WardName=document.getElementById("WardName").value;
					var bedNo=document.getElementById("BedNo").value;
			   		var MyPara="PatientName"+String.fromCharCode(2)+PatientName;
			   		MyPara=MyPara+"^RegNo"+String.fromCharCode(2)+PatientID;
			   		MyPara=MyPara+"^Sex"+String.fromCharCode(2)+Sex;
			   		MyPara=MyPara+"^WardName"+String.fromCharCode(2)+WardName;
			   		MyPara=MyPara+"^bedNo"+String.fromCharCode(2)+bedNo;
			   		MyPara=MyPara+"^BookedDate"+String.fromCharCode(2)+BookedDate+" "+BookedStTime;
			   		//MyPara=MyPara+"^BookedStTime"+String.fromCharCode(2)+BookedStTime;
			   		PrintBookedBill(MyPara,"");
				}
	    		//printbookedItem(ResDesc,BookedDate,BookedStTime,OEOrdItemID);
	   		}
	   		var mode=document.getElementById("mode").value;
	       	Booking_click();
	    }
		else
		{
			alert(t['Selectitem']);
		}
	}
}
 
 function printbookedItem(ResDesc,BookedDate,BookedTime,OEOrdItemID)
 {
	 
	var printinfo="";
	var GetBookingTitle=document.getElementById("GetBookedTitle").value;
	var Title=cspRunServerMethod(GetBookingTitle); 
	 
    if (!curPrintObject)
    	curPrintObject= new ActiveXObject("RISPrint.CPrintExamItem");
 
	var Item=OEOrdItemID.split("^");
	
	var nums=Item.length;

	for (i=0;i<nums;i++)
	{
		var GetBookingInfo=document.getElementById("getorditeminfo").value;
	    var Info=cspRunServerMethod(GetBookingInfo,Item[i]);
	    
	    var BookedInfo=Info.split("^");
	    if (printinfo=="")
	    {
		    printinfo=BookedInfo[0]+"^"+BookedInfo[1]+"^"+BookedInfo[5]+"^"+ResDesc+"^"+BookedDate+"^"+BookedTime
	    }
	    else 
	    {
		    printinfo=printinfo+"&"+BookedInfo[0]+"^"+BookedInfo[1]+"^"+BookedInfo[5]+"^"+ResDesc+"^"+BookedDate+"^"+BookedTime
	    }
	}
	if ((printinfo!="")&&(curPrintObject))
	{
		//alert(printinfo);
		curPrintObject.PrintBookedItem(Title,printinfo);
	}
	    

 }
 
 /*function printbookedItem(ResDesc,BookedDate,BookedTime,OEOrdItemID)
 {
	 
	var printinfo="";
	var GetBookingTitle=document.getElementById("GetBookedTitle").value;
	var Title=cspRunServerMethod(GetBookingTitle); 
	 
    if (!curPrintObject)
    	curPrintObject= new ActiveXObject("RISPrint.CPrintExamItem");
 
	var Item=OEOrdItemID.split("^");
	var nums=Item.length;

	for (i=0;i<nums;i++)
	{
		var GetBookingInfo=document.getElementById("getorditeminfo").value;
	    var Info=cspRunServerMethod(GetBookingInfo,Item[i]);
	    var BookedInfo=Info.split("^");
	    
	    if (BookedTime>="12:00:00"){   //lgl+
		    BookedTime="下午";
	    }
	    else{
		    BookedTime="上午";
	    }
	    if (printinfo=="")
	    {
		    printinfo=BookedInfo[0]+"^"+BookedInfo[1]+"^"+BookedInfo[5]+"^"+ResDesc+"^"+BookedDate+"^"+BookedTime
	    }
	    else 
	    {
		    printinfo=printinfo+"&"+BookedInfo[0]+"^"+BookedInfo[1]+"^"+BookedInfo[5]+"^"+ResDesc+"^"+BookedDate+"^"+BookedTime
	    }
	}
	if (printinfo!="")
	{   
	    //alert("print");
		//lgl+修改打印方式为excel?
		var DT=GetDateTime();  //临时取本机日期时间作打印时间
		tblobj=document.getElementById("tDHCRisAppointment");
        var oXL = new ActiveXObject("Excel.Application"); 
        var oWB = oXL.Workbooks.Add(); 
        var oSheet = oWB.ActiveSheet; 
        oSheet.PageSetup.LeftHeader = ""
        oSheet.PageSetup.CenterHeader = ""
        oSheet.PageSetup.RightHeader = ""
        oSheet.PageSetup.LeftFooter = ""
        oSheet.PageSetup.CenterFooter = ""
        oSheet.PageSetup.RightFooter = ""
        oSheet.PageSetup.LeftMargin = oXL.InchesToPoints(0)
        oSheet.PageSetup.RightMargin = oXL.InchesToPoints(0)
        oSheet.PageSetup.TopMargin = oXL.InchesToPoints(0)
        oSheet.PageSetup.BottomMargin = oXL.InchesToPoints(0)
        oSheet.PageSetup.HeaderMargin = oXL.InchesToPoints(0)
        oSheet.PageSetup.FooterMargin = oXL.InchesToPoints(0)


   		oXL.Cells.Select; 
		oXL.Selection.Font.Name = t['font']; 
		oXL.Selection.Font.Size = 12;
		oXL.Columns("A:A").ColumnWidth = 100;
		var printinfo2=printinfo.split("^")
		oXL.Cells(1,1).Select;
		oXL.Selection.Font.Size = 14;
		oSheet.cells(1,1).value=t['Title']; 
		oSheet.cells(2,1).value=t['regNo']+printinfo2[0];
		oSheet.cells(3,1).value=t['Name']+printinfo2[1];
		oSheet.cells(4,1).value=t['ItemName']+printinfo2[2];
		oSheet.cells(5,1).value=t['EQ']+printinfo2[3];
		oSheet.cells(6,1).value=t['AppDate']+printinfo2[4];
		oSheet.cells(7,1).value=t['AppTime']+ printinfo2[5];
		oSheet.cells(8,1).value=t['printTime']+ DT;
		oXL.Visible = false; //true; lgl 0609+ 
		oSheet.printout;
	 	oWB.Close(savechanges=false);
	 	oXL=null;
	 	oSheet=null;
	 	
	 //		curPrintObject.PrintBookedItem(Title,printinfo);
	}
 }
 */
 
 function GetSelectedResource(Info)
 {
	 var item=Info.split("^");
	 ResourceOBJ=document.getElementById("Resource");
	 ResourceOBJ.value=item[0];
	 ResourceIDOBJ=document.getElementById("ResourceID");
	 ResourceIDOBJ.value=item[1];
	 
	 FindClick1();
	 
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
   
   sYear  = d.getYear();		// 获取年份?
   s = sDay + "/" + sMonth + "/" + sYear;            
   return(s); 
                                 // 返回日期?
}
function GetDateTime()
{
	var t = "";
	var d = new Date();
	t += d.getYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate()+ " " + d.getHours()+":"+d.getMinutes()+":"+d.getSeconds();
	return t;
}

function CloseWindow() {
	close();
	return true;
}

function SelectRowHandler()
{
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisAppointment');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
     
    var selectedobj=document.getElementById("Selectedz"+selectrow);
    var resname=document.getElementById("TResourcez"+selectrow).innerText;
    var lastselresname="";
    if (LastCheckIndex!=-1)
    {
    	lastselresname=document.getElementById("TResourcez"+LastCheckIndex).innerText;
    }
    
	/*if ((selectedobj)&&(selectedobj.checked))
	{
		selectedobj.checked=0; 
	}
	else
	{
		var Diffrows=selectrow-LastCheckIndex;
		if ((Diffrows>=0)&&((resname==lastselresname)||(lastselresname=="")))
		{
		   	if (LastCheckIndex!=-1)
			{
				for (i=LastCheckIndex;i<=selectrow;i++)
				{
					var selectedobj=document.getElementById("Selectedz"+i);
 					selectedobj.checked=1;
				} 
				LastCheckIndex=selectrow;
			}
			else
			{
				selectedobj.checked=1;
				LastCheckIndex=selectrow;
				
			}
		}
		
    }
    */
    
    // calculate total times of current appointment
    var totalLength=0;
    var hasSel=0; // has selected  false
    var hasSelCount=0;
    for (var j=1; j < rows; j++)  
    {
	    
		var selectedobj=document.getElementById("Selectedz"+j);
		if ((selectedobj)&&(selectedobj.checked))
		{
			var perlength=document.getElementById("Lengthz"+j).innerText;
			perlength=eval(perlength);
			totalLength=totalLength+perlength;
			hasSelCount++;
			hasSel=1;
		}
    }
    if (hasSel==0)
    {
	    LastCheckIndex=-1;
	}
    document.getElementById("AppLength").value=totalLength;
}

function PrintBookedBill(TxtInfo,ListInfo)
{
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
} 

document.body.onload = BodyLoadHandler;