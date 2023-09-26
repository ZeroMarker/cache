
//DHCRisWriteReport.js
var StudyNo;
var TemplatePath;

function BodyLoadHandler()
{
	var paadmdr=document.getElementById("EpisodeID").value;
	var OEOrdItemID=document.getElementById("OEOrdItemID").value;
	if(OEOrdItemID!="")
	{
	   StudyNo=GetStudyNoFun(OEOrdItemID);
	   
	}
	
	if(StudyNo=="")
	{
		alert("检查号为空")
		return;
	}
	else
	{
		GetReportData(OEOrdItemID,StudyNo)
		document.getElementById("StudyNo").value=StudyNo;
		
	}
	
	var SaveRpeortObj=document.getElementById("SaveRpeort");
    if (SaveRpeortObj)
    {
	    SaveRpeortObj.onclick=FunSaveRpeort;
	}
	
	var PrintObj=document.getElementById("PrintReport");
	if(PrintObj)
	{
		PrintObj.onclick=PrintClick;
	}
	
	var GetPathFunction=document.getElementById("GetPath").value;
 	TemplatePath=cspRunServerMethod(GetPathFunction);

}




function FunSaveRpeort()
{
	var StudyNo,ReportID,Version,StatusDR,ExamDesc;
	var ResultDesc,Result,ReportDocDR,OeordItmDR;
	var Info=""; 
	var Code="R";
	
	StudyNo=document.getElementById("StudyNo").value;
	ReportID="1";
	Version="1";
	StatusDR=GetRptStatus(Code);
	ExamDesc=document.getElementById("ExamDesc").value;
	ResultDesc=document.getElementById("ResultDesc").value;
	Result="Y";
	ReportDocDR=session['LOGON.USERID'];
	var OEOrdItemID=document.getElementById("OEOrdItemID").value;
	OeordItmDR=OEOrdItemID
	
	Info=StudyNo+"^"+ReportID+"^"+Version+"^"+StatusDR+"^"+ExamDesc+"^"+ResultDesc+"^"+Result;
	Info=Info+"^"+ReportDocDR+"^"+OeordItmDR;
	
	var SetRpeortDataFun=document.getElementById("SetRpeortData").value;
	var value=cspRunServerMethod(SetRpeortDataFun,Info,"I");
	
	if(value=="0")
	{
		GetReportData(OEOrdItemID,StudyNo);
		alert("保存成功");
	}
	else
	{
		alert("保存失败");
	}	
	
	 
	
}




function GetStudyNoFun(OEOrdItemID)
{
	var GetStudyNoFunction=document.getElementById("GetStudyNoFun").value;
	var StudyNo=cspRunServerMethod(GetStudyNoFunction,OEOrdItemID);	
	return StudyNo;	
}



function GetReportData(OEOrdItemID,StudyNo)
{
	var Info=StudyNo+"^"+OEOrdItemID
	var GetPatInfoFunction=document.getElementById("GetPatInfoFunction").value;
	var value=cspRunServerMethod(GetPatInfoFunction,Info);
	if(value=="")
	{
		return;
	}
	else
	{
		var Item;
		Item=value.split("^");
		document.getElementById("RegNo").value=Item[0];
		document.getElementById("Name").value=Item[1];
		document.getElementById("Age").value=Item[2];
		document.getElementById("Sex").value=Item[3];
		document.getElementById("wardname").value=Item[4];
		document.getElementById("bedname").value=Item[5];
		document.getElementById("ExamDesc").value=ReplaceInfo(Item[6]);
		document.getElementById("ResultDesc").value=ReplaceInfo(Item[7]);
		document.getElementById("ReportDoc").value=Item[9];
		document.getElementById("RptDate").value=Item[10];
		document.getElementById("RptTime").value=Item[11];
			
	}
	
}


function PrintClick()
{
   onprint();	
}	
	
	
function onprint()
{
	
	try 
	{
		var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCRisCheckReport.xls";
	    var CellRows ; //
	    var Isprint=1;
	    var Pageindex=0;
	    var PrintedRows=0;
	    
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    
	    xlsheet.cells(2,4)=document.getElementById("Name").value;
	    xlsheet.cells(2,6)=document.getElementById("Sex").value;
	    xlsheet.cells(2,11)=document.getElementById("Age").value;
	    xlsheet.cells(3,4)=document.getElementById("StudyNo").value;
	    xlsheet.cells(3,6)=document.getElementById("RegNo").value;
	    xlsheet.cells(3,11)=document.getElementById("wardname").value;
	    xlsheet.cells(4,4)=document.getElementById("bedname").value;
	    xlsheet.cells(5,4)=document.getElementById("ExamDesc").value;
	    xlsheet.cells(6,4)=document.getElementById("ResultDesc").value;
	    xlsheet.cells(7,4)=document.getElementById("RptDate").value
	    xlsheet.cells(7,6)=document.getElementById("RptTime").value;
	    xlsheet.cells(7,11)=document.getElementById("ReportDoc").value
	    
       
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

function ReplaceInfo(Strtmp)
{
   Info=Strtmp.replace(new RegExp("X000b","g"),"\r");
   Info=Info.replace(new RegExp("X000a","g"),"\n");
   return Info ;
}

function GetRptStatus(Code)
{
	var GetRptStatusFunction=document.getElementById("GetRptStatus").value;
	var value=cspRunServerMethod(GetRptStatusFunction,Code);
	return value;
}

document.body.onload = BodyLoadHandler;