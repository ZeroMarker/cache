
function BodyLoadHandler() 
{
	var obj=document.getElementById("StartTime");
	if (!(obj.value)) obj.value="00:00:00";
	var obj=document.getElementById("EndTime");
	if (!(obj.value)) obj.value="23:59:59";
	var obj=document.getElementById("BPrint");
	
	if (obj)
	{
		obj.onclick=Print_Click;
	}
	
	InitDocument();
}

function InitDocument()
{
	  //	var obj=document.getElementById('GroupDR');
	  //	if (obj)  alert(obj.value);
	 var obj=document.getElementById('InvStat');
	 if (obj) 
	 {
		var objA=document.getElementById('HeadTitle');
	  	if (objA) 
	  	{
		  	var flag=obj.value;
		  	if (flag=="CPP") objA.value=t["jz"];
		  	else objA.value=t["mz"];
		}
	 }
	 


  	var listobj=document.getElementById("TTMPJIDz"+1);
	if (listobj)
	{
		var myval=DHCWebD_GetCellValue(listobj);
		var obj=document.getElementById("TMPJID");
		if (obj) obj.value=myval; //alert(obj.value)
	}
 
}

function GetUserInfoByUserCode(value)
{	
	
	var str=value.split("^");
	var obj=document.getElementById("OperName");
	if (obj) obj.value=str[0]
	var obj=document.getElementById("UserRowId");
	if (obj) obj.value=str[1]
	var obj=document.getElementById("GroupName");
	if (obj) obj.value=str[2]
	
}


function Print_Click()
{	
	PrintClickHandler();
	
}

function PrintClickHandler()
{
	try{
		
		var encmeth=""
		var obj=document.getElementById('GetRepPath');
		if (obj) encmeth=obj.value;
		if (encmeth) var TemplatePath=cspRunServerMethod(encmeth);
		
		var StDate="",EndDate="",StartTime="",EndTime="",CurDate="";
		var obj=document.getElementById("StDate");
		if (obj) StDate=obj.value;
		var obj=document.getElementById("EndDate");
		if (obj) EndDate=obj.value;
		var obj=document.getElementById("StartTime");
		if (obj) StartTime=obj.value;
		var obj=document.getElementById("EndTime");
		if (obj) EndTime=obj.value;
		var obj=document.getElementById("CurDate");
		if (obj) CurDate=obj.value;
		
		encmeth=""
		var obj=document.getElementById("DateTrans");
		if (obj) encmeth=obj.value;
		

		var RepDate=StDate+" "+StartTime+t["zhi"]+EndDate+" "+EndTime
		//alert(StDate+"   "+EndDate+"   "+StartTime+"   "+EndTime+"   "+CurDate)
		
		var OperName=""
		var obj=document.getElementById("OperName");
		if (obj) OperName=obj.value;
		var ZBR=session['LOGON.USERNAME'];
		

		var Template=TemplatePath+"JFOP_SFYWorkStat.xls";
		
		encmeth=""
		var obj=document.getElementById('TMPJID')
		if (obj) var jid=obj.value; 
		var obj=document.getElementById("GetRowNum");
		if (obj) encmeth=obj.value; 
		var Rows=parseInt(cspRunServerMethod(encmeth,jid));
		
		//OutPutExel
	    var xlApp = new ActiveXObject("Excel.Application");
	    var xlBook = xlApp.Workbooks.Add(Template);
	    var xlsheet = xlBook.ActiveSheet;
		//Title
		//var obj=document.getElementById('HeadTitle');
	  	//if (obj) xlsheet.cells(1,2)=obj.value;

		xlsheet.cells(2,5)=RepDate;
		
		var xlsRow=3;
		var xlsCol=0;
		//Data
		for (var i=1; i<=Rows; i++)
		{ 
			encmeth="";
			var obj=document.getElementById("ReadPrtData");
			if (obj) var encmeth=obj.value;
			
			var RowStr=cspRunServerMethod(encmeth,jid,i-1);
	
			var ary=RowStr.split("^");
			var Cols=ary.length; 
			
			for (var j=2; j<12; j++)
			{
				xlsheet.cells(xlsRow+i,xlsCol+j-1)=ary[j];
			}
		}
		gridlist(xlsheet,xlsRow,xlsRow+i-1,1,j-2);
		
		//Other
		i++;
		xlsheet.cells(xlsRow+i,xlsCol+1)=t["ZBR"];
		xlsheet.cells(xlsRow+i,xlsCol+2)=ZBR;
		xlsheet.cells(xlsRow+i,xlsCol+3)=t["shr"];
		xlsheet.cells(xlsRow+i,xlsCol+5)=t["BT"];
		xlsheet.cells(xlsRow+i,xlsCol+6)=CurDate;

		i++;
		xlsheet.cells(xlsRow+i,xlsCol+1)=t["JKR"];
		xlsheet.cells(xlsRow+i,xlsCol+6)=t["QZ"];
		i++;
		xlsheet.cells(xlsRow+i,xlsCol+1)=t["SHR"];
		xlsheet.cells(xlsRow+i,xlsCol+6)=t["KJS"];
		//OutPutExcel
		
		xlsheet.printout; 
	    xlBook.Close (savechanges=false);
	    
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
		
		
	} catch(e){
			alert(e.message);
		};
	
	
}

function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
}


function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
}

function UnloadHandler()
{	
	
	var myEncrypt=DHCWebD_GetObjValue("DELPRTTMPDATA");
	var myTMPGID=DHCWebD_GetObjValue("TMPJID");
	if (myEncrypt!="")
	{
		var mytmp=cspRunServerMethod(myEncrypt, myTMPGID);
	}
	
}

document.body.onload = BodyLoadHandler;
document.body.onbeforeunload=UnloadHandler