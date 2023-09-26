//DHCRisAppointInfoStatics

function BodyLoadHandler()
{
	//alert("Load")
	var stdate=document.getElementById("StartDate");
	var eddate=document.getElementById("EndDate");
	
	if (stdate.value=="")
	{
		stdate.value=tkMakeServerCall("web.DHCRisCommFunctionEx","getDateHtml","-2");
		eddate.value=tkMakeServerCall("web.DHCRisCommFunctionEx","getDateHtml","0");
	}
 	
    /*var Staticsobj=document.getElementById("Statics");
	if (Staticsobj)
	{
	   Staticsobj.onclick=StaticsobjClick;
	}
	*/
	

	var Printobj=document.getElementById("Print");
	if(Printobj)
	{
		Printobj.onclick=PrintClick;
	}
	


  	var GetPathFunction=document.getElementById("GetPath").value;
 	TemplatePath=cspRunServerMethod(GetPathFunction);
	
}


function StaticsobjClick()
{
	SetFindData();
}

function SetFindData()
{
	var ward=document.getElementById("ward").value;
	var WardName=document.getElementById("WardName").value
	var startdate=document.getElementById("startdate").value;
	var enddate=document.getElementById("enddate").value;
	var InRegNo=document.getElementById("InRegNo").value;
	var RisStatusCode=document.getElementById("RisStatusCode").value;
	var InStudyNo=document.getElementById("InStudyNo").value;
	var ArcItemRowid=document.getElementById("ArcItemRowid").value;
	var ArcItemName=document.getElementById("ArcItemName").value
	var RecLocId=document.getElementById("RecLocId").value;
    var RecLocName=document.getElementById("RecLocName").value;
	
	if(WardName=="")
	{
		ward="";
	}
	
	if (ArcItemName=="")
	{
		ArcItemRowid="";
	}
	
	if (RecLocName=="")
	{
		RecLocId="";
	}
	
	if(InRegNo!="")
	{
		var zero="";
		for (var i=0;i<8-InRegNo.length;i++)
		{
		   zero=zero+"0";
		}
		InRegNo=zero+InRegNo;
		document.getElementById("InRegNo").value=InRegNo;
	}
	
	if(document.getElementById("IsPrint").checked)
	{
		var IsPrint="Y";
	}   
	else
	{
		var IsPrint="N";
	}
	
	if (document.getElementById("IsBedOrd").checked)
	{ 
	    var IsBedOrd="Y";
	}
	else
	{
		var IsBedOrd="N";
	}
	
	var strCondition=ward+"^"+ArcItemRowid+"^"+InRegNo+"^"+InStudyNo+"^"+RisStatusCode+"^"+RecLocId+"^"+IsPrint+"^"+IsBedOrd+"^"+gUserID;
	var Info="&ward="+ward+"&WardName="+WardName+"&ArcItemRowid="+ArcItemRowid+"&InRegNo="+InRegNo+"&InStudyNo="+InStudyNo+"&RisStatusCode="+RisStatusCode+"&RecLocId="+RecLocId+"&RecLocName="+RecLocName+"&ArcItemName="+ArcItemName+"&IsPrint="+IsPrint+"&IsBedOrd="+IsBedOrd;
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisWardNurseQuery&strCondition="+strCondition+"&startdate="+startdate+"&enddate="+enddate+Info;
	
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
   
   sYear  = d.getFullYear();	
   s = sDay + "/" + sMonth + "/" + sYear;            
   return(s); 
                            
}

function RegNo_keyDown()
{
	var key =websys_getKey(e)
	if (key==13)
	{
		FindClickHandler();
		
	}
}

function StudyNo_keyDown()
{
	var key =websys_getKey(e)
	if (key==13)
	{
		FindClickHandler();
		
	}
}

function FindClickHandler(e)
{
	SetFindData();
}

function ClearCLICK()
{
	document.getElementById("RisStatusCode").value="";
	document.getElementById("InRegNo").value="";
	combo_Use.setComboText('');
	document.getElementById("startdate").value=DateDemo();
	document.getElementById("enddate").value=DateDemo();
	document.getElementById("InStudyNo").value="";
	document.getElementById("ArcItemName").value="";
    document.getElementById("ArcItemRowid").value="";
    document.getElementById("WardName").value="";
    document.getElementById("ward").value="";
    document.getElementById("RecLocId").value="";
    document.getElementById("RecLocName").value="";
    document.getElementById("IsPrint").checked=false;
    document.getElementById("IsAllCheck").checked=false;
    document.getElementById("IsBedOrd").checked=false;
   	
}




function SetPrintData(OeItemID)
{
	var SetPrintDateTimeFun=document.getElementById("SetPrintDateTime").value;
 	var PrintData=cspRunServerMethod(SetPrintDateTimeFun,OeItemID);
 	return PrintData
}


//打印所有数据
function PrintClick()
{
	try 
	{
		var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCRisWaiqinPrintYD.xls";
	    var CellRows ;
	    var Isprint=1;
	    var Pageindex=0;
	    var PrintedRows=0;
	    var Count=0;
	   
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	   
	    var ward=document.getElementById("ward").value;
	    var WardName=document.getElementById("WardName").value;
	    if(WardName="")
	    {
		    ward=""
		}
	    
	    var GetPrintCountFunction=document.getElementById("GetPrintCount").value;
 	    Count=cspRunServerMethod(GetPrintCountFunction,gUserID);
 	    
 	    for(var i=1;i<=Count;i++)
 	    {
	 	     var GetParintDataFunction=document.getElementById("GetParintData").value;
 	         GetParintData=cspRunServerMethod(GetParintDataFunction,gUserID,i);
 	         
 	         if(GetParintData!="")
 	         {
		 	      	 	    
		 	         xlsheet.cells(2,2)=GetCurrentDate();
		 	         xlsheet.cells(2,8)=session['LOGON.USERNAME'];
		 	 
			 	   
				 	  Items=GetParintData.split("^");
				 	  var OeItemID=Items[0]; 
				 	  var depname=Items[2];
				 	  var BedNo=Items[3];
				 	  var RegNo=Items[4];
				 	  var Name=Items[5];
				 	  var Sex=Items[6];
				 	  var Age=Items[7];
				 	  var ItemName=Items[8];
				 	  var Date=Items[9];
				 	  var Time=Items[10];
				 	  var AppointDate=Items[11];
				 	  var AppointstTime=Items[12];
				 	  var RegDate=Items[13];
				 	  var RegTime=Items[14];
				 	  var StudyNo=Items[15];
				 	  var ReportDoc=Items[16];
				 	  var ReportVerifyDoc=Items[17];
				 	  var RisStatusDesc=Items[18];
				 	  var WardName=Items[19];
				 	  var ResDesc=Items[20];
				 	  var PrintFlag=Items[21];
				 	  
				 	  
				 	  
				 	  if(OeItemID!="" && PrintFlag=="")   
				 	  {
				 	    var SetPrintFlagFun=document.getElementById("SetPrintFlag").value;
	 	                ret=cspRunServerMethod(SetPrintFlagFun,OeItemID);
	 	                var PrintData=SetPrintData(OeItemID);
	 	                var Item=PrintData.split("^"); 
			 	        var PrintDate=Item[0];
			 	        var PrintTime=Item[1];
				 	  }
				 	  
				 	
				 	
				 	  xlsheet.cells(i+3,1)=WardName;
				 	  xlsheet.cells(i+3,2)=RegNo;
				 	  xlsheet.cells(i+3,3)=StudyNo;
				 	  xlsheet.cells(i+3,4)=Name;
				 	  xlsheet.cells(i+3,5)=Sex;
				 	  xlsheet.cells(i+3,6)=Age;
				 	  xlsheet.cells(i+3,7)=BedNo;
				 	  xlsheet.cells(i+3,8)=ItemName; 
				 	  xlsheet.cells(i+3,9)=depname; 
				 	  xlsheet.cells(i+3,10)=AppointDate+"  "+AppointstTime;
				 	  xlsheet.cells(i+3,11)=AppointstTime;
				 	  xlsheet.cells(i+3,12)=ResDesc;
				 	  xlsheet.cells(i+3,13)=RegDate;
				 	  xlsheet.cells(i+3,14)=RegTime;
				 	  xlsheet.cells(i+3,15)=ReportDoc;
				 	  xlsheet.cells(i+3,16)=ReportVerifyDoc;
				 	  xlsheet.cells(i+3,17)=RisStatusDesc;
				 	  xlsheet.cells(i+3,18)=Date;
				 	  xlsheet.cells(i+3,19)=Time;
				 	  
	 	   }
	 	}
	    
	   
      
        SetFindData();
	    xlsheet.printout;
		xlBook.Close (savechanges=false);
        xlApp=null;
        xlsheet=null;
        
	}
	catch(e) 
	{
		alert(e.message);
	};
}


//打印选中数据
function PrintSelClick()
{
	try 
	{
		var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCRisWaiqinPrintYD.xls";
	    var CellRows ; 
	    var Isprint=1;
	    var Pageindex=0;
	    var PrintedRows=0;
	    
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
		   
	  
	    var ordtab=document.getElementById("tDHCRisWardNurseQuery");
	    var Nums=ordtab.rows.length;
	    
	    
        if (ordtab) 
        {
		    xlsheet.cells(2,2)=GetCurrentDate();
	 	    xlsheet.cells(2,8)=session['LOGON.USERNAME'];
		    var j=0;
		    
		    for (var i=1;i<Nums;i++)
     	    {
		        var selectedobj=document.getElementById("TSelectz"+i);
		        
		        
                if ((selectedobj)&&(selectedobj.checked))
		          {
			          j=j+1;
				      var OeItemID=document.getElementById("OEOrdItemIDz"+i).value;
				 	  var depname=document.getElementById("LocNamez"+i).innerText;
				 	  var BedNo=document.getElementById("bednoz"+i).innerText;
				 	  var RegNo=document.getElementById("regnoz"+i).innerText;
				 	  var Name=document.getElementById("Namez"+i).innerText;
				 	  var Sex=document.getElementById("Sexz"+i).innerText;
				 	  var Age=document.getElementById("TAgez"+i).innerText;
				 	  var ItemName=document.getElementById("ItemNamez"+i).innerText;
				 	  var Date=document.getElementById("Datez"+i).innerText;
				 	  var Time=document.getElementById("Timez"+i).innerText;
				 	  var AppointDate=document.getElementById("AppDatez"+i).innerText;
				 	  var AppointstTime=document.getElementById("AppointTimez"+i).innerText;
				 	  var ResDesc=document.getElementById("AppEQz"+i).innerText;
				 	  var PrintFalg=document.getElementById("PrintFalgz"+i).innerText;
				 	  var wardname=document.getElementById("Twarddescz"+i).innerText;
				 	  var RegDate=document.getElementById("TstrRegDatez"+i).innerText;
				 	  var RegTime=document.getElementById("TstrRegTimez"+i).innerText;
				 	  var StudyNo=document.getElementById("TStudyNoz"+i).innerText;
				 	  var ReportDoc=document.getElementById("ReportDocz"+i).innerText;
				 	  var ReportVerifyDoc=document.getElementById("VerifyDocz"+i).innerText;
				 	  var RisStatusDesc=document.getElementById("RisStatusDescz"+i).innerText;
				 	  
				 	  
				 	  
				 	  if(OeItemID!="" && PrintFalg!="Y")
			 	      {
					 	    var SetPrintFlagFun=document.getElementById("SetPrintFlag").value;
		 	                ret=cspRunServerMethod(SetPrintFlagFun,OeItemID);
		 	                var PrintData=SetPrintData(OeItemID);
		 	                var Item=PrintData.split("^"); 
				 	        var PrintDate=Item[0];
				 	        var PrintTime=Item[1];
			 	      }
			 	      
				     xlsheet.cells(j+3,1)=wardname;
			 	     xlsheet.cells(j+3,2)=RegNo;
			 	     xlsheet.cells(j+3,3)=StudyNo;
			 	     xlsheet.cells(j+3,4)=Name;
			 	     xlsheet.cells(j+3,5)=Sex;
			 	     xlsheet.cells(j+3,6)=Age;
			 	     xlsheet.cells(j+3,7)=BedNo;
			 	     xlsheet.cells(j+3,8)=ItemName; 
			 	     xlsheet.cells(j+3,9)=depname; 
			 	     xlsheet.cells(j+3,10)=AppointDate+"  "+AppointstTime;
			 	     xlsheet.cells(j+3,11)=AppointstTime;
			 	     xlsheet.cells(j+3,12)=ResDesc;
			 	     xlsheet.cells(j+3,13)=RegDate;
			 	     xlsheet.cells(j+3,14)=RegTime;
			 	     xlsheet.cells(j+3,15)=ReportDoc;
			 	     xlsheet.cells(j+3,16)=ReportVerifyDoc;
			 	     xlsheet.cells(j+3,17)=RisStatusDesc;
			 	     xlsheet.cells(j+3,18)=Date;
			 	     xlsheet.cells(j+3,19)=Time;
				 	 
		          }
		       
			} 
		    
		    xlsheet.printout;
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




function GetSelectedWardInfo(Info)
{
  Item=Info.split("^");
  document.getElementById("Ward").value=Item[0];
  document.getElementById("WardId").value=Item[1]; 
}



function IsAllCheckClick()
{
	var ordtab=document.getElementById("tDHCRisWardNurseQuery");
	var Nums=ordtab.rows.length;
	if (ordtab) 
	 {
		    for (i=1;i<Nums;i++)
		    {
			    var selectedobj=document.getElementById("TSelectz"+i);
			    if (document.getElementById("IsAllCheck").checked)
			    {
		           selectedobj.checked=true;
			    }
			    else
			    {
				  selectedobj.checked=false;  
				}
		        
		    }
	 }
	
}




document.body.onload = BodyLoadHandler;


