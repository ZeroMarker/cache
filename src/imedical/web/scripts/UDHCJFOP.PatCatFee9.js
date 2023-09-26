

var aryCatDesc="";
var aryPMDesc ="";
function BodyLoadHandler() 
{
	
	var obj=document.getElementById("BFind");
	if (obj)
	{
		obj.onclick=BFind_Click;
	}
		
	var obj=document.getElementById("BPrint");
	if (obj)
	{
		obj.onclick=Print_Click;
	}
	var obj=document.getElementById("InsType");
	if (obj){
		obj.size=1;
		obj.multiple=false;
	}
	
	var obj=document.getElementById("StatFlag");
	if (obj){
		obj.size=1;
		obj.multiple=false;
	}
	var obj=document.getElementById("test");
	if (obj){
		obj.size=1;
		obj.multiple=false;
	}
	
	InitDocument();
}

function DHCWebRep_ChangeListValue(ListName,val)
{
	var obj=document.getElementById(ListName);
	for (var i=obj.options.length-1; i>=0; i--)
	{
	
		if(obj.options[i].value==val)
		{
			obj.selectedIndex=i;
		}
		
	}
}
function DHCWebRep_GetListTextValue(objName)
{
		var myval=""
		var obj=document.getElementById(objName);
		if (obj)
		{
			var myidx=obj.selectedIndex;
			if (myidx!=-1)
			{
				myval=obj.options[myidx].text;	
			}
		
		}	
		return myval;
}

function InitDocument()
{
	
	var obj=document.getElementById("StatFlagHidden")
	if (obj)
	{
		DHCWebRep_ChangeListValue("StatFlag",obj.value);
	}
	var obj=document.getElementById("InsTypeHidden")
	if (obj)
	{
		DHCWebRep_ChangeListValue("InsType",obj.value);
	}
	

	InitOPCat();
	InitPMCat();

  	var listobj=document.getElementById("TTMPJIDz"+1);
	if (listobj)
	{
		var myval=DHCWebD_GetCellValue(listobj);
		var obj=document.getElementById("TMPJID");
		if (obj) obj.value=myval; 
		
	}
 

}

function BFind_Click()
{
	
	var StDate="",StartTime="",EndDate="",EndTime="";
	var obj=document.getElementById("EndDate")
	if (obj){ var EndDate=obj.value; }
	var obj=document.getElementById("StDate")
	if (obj){ var StDate=obj.value; }
	var obj=document.getElementById("StartTime")
	if (obj){ var StartTime=obj.value; }
	var obj=document.getElementById("EndTime")
	if (obj){ var EndTime=obj.value; }
	var obj=document.getElementById("TMPJID")
	if (obj){ var TMPJID=obj.value; }
	
	var UserRowId="";
	var InsType=""	;
	var StatFlag="";
	var obj=document.getElementById("InsType");
	if (obj){
		var myidx=obj.selectedIndex;
		if (myidx!=-1){
			InsType=obj.options[myidx].value;	
		}
		
	}
	var obj=document.getElementById("StatFlag");
	if (obj){
		var myidx=obj.selectedIndex;
		if (myidx!=-1){
			StatFlag=obj.options[myidx].value;	
		}
		
	}
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOP.PatCatFee9&TMPJID="+TMPJID+"&EndDate="+EndDate+"&StDate="+StDate+"&StartTime="+StartTime+"&EndTime="+EndTime+"&StatFlag="+StatFlag+"&PatTypeStat="+InsType+"&UserRowId="+UserRowId;
 //   alert(lnk)
  	document.location.href=lnk;


	
}


function InitPMCat()
{	
	
	
	var catobj=document.getElementById("getPMCat");
	if (catobj) {var encmeth=catobj.value} else {var encmeth=''};
	var catinfo=cspRunServerMethod(encmeth);
	aryPMDesc=catinfo.split("^");
	var objtbl=document.getElementById("tUDHCJFOP_PatCatFee9");
	var Rows=objtbl.rows.length;

	var firstRow=objtbl.rows[0];
	var RowItems=firstRow.all;

	var cattmp =catinfo.split("^");
	var catnum=cattmp.length;
	if (RowItems.length<catnum)
	{
		alert("exceeded the max num!");	
		return;
	}
	for (var i=1;i<=catnum;i++)
	{
		var ColName="pm"+i;
		for (var j=0;j<RowItems.length;j++) 
		{ 
			if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH'))
			{
				RowItems[j].innerHTML=cattmp[i-1];
			}
		}
	}
	
	for (var i=6;i<=10;i++){
		HiddenTblColumnA(objtbl,"pm"+i,i);
	}
}

function InitOPCat()
{	
	
	var obj=document.getElementById("StatFlagHidden")
	var catobj;
	if (obj)
	{
		if(obj.value=="AC"){
			 catobj=document.getElementById("getTarACCat");	
		}else{
			 catobj=document.getElementById("getTarOCCat");
		}
	}
	

	if (catobj) {var encmeth=catobj.value} else {var encmeth=''};
	var catinfo=cspRunServerMethod(encmeth);
	aryCatDesc=catinfo.split("^");
	var objtbl=document.getElementById("tUDHCJFOP_PatCatFee9");
	var Rows=objtbl.rows.length;

	var firstRow=objtbl.rows[0];
	var RowItems=firstRow.all;

	var cattmp =catinfo.split("^");
	var catnum=cattmp.length;
	if (RowItems.length<catnum)
	{
		alert("exceeded the max num!");	
		return;
	}
	for (var i=1;i<=catnum;i++)
	{
		var ColName="cat"+i;
		for (var j=0;j<RowItems.length;j++) 
		{ 
			if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH'))
			{
				RowItems[j].innerHTML=cattmp[i-1];
			}
		}
	}
	
	for (var i=catnum+1;i<=20;i++){
		HiddenTblColumn(objtbl,"cat"+i,i);
	}
}

function HiddenTblColumnA(tbl,ColName,ColIdx){
	var row=tbl.rows.length;
	var firstRow=tbl.rows[0];
	var RowItems=firstRow.all;
	
	for (var j=0;j<RowItems.length;j++) {
		///alert(RowItems[j].childNodes.length);
		///if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH')) {
		if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH')) {
			RowItems[j].style.display="none";
		} else {
		}
	}

	row=row-1;
	for (var j=1;j<row+1;j++) {
		var sLable=document.getElementById("TPM"+ColIdx+'z'+j);
		var sTD=sLable.parentElement;
		sTD.style.display="none";
	}
}

function HiddenTblColumn(tbl,ColName,ColIdx){
	var row=tbl.rows.length;
	var firstRow=tbl.rows[0];
	var RowItems=firstRow.all;
	//alert("ColName= "+ColName+" row= "+row+""+""+"");
	for (var j=0;j<RowItems.length;j++) {
		///alert(RowItems[j].childNodes.length);
		///if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH')) {
		if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH')) {
			RowItems[j].style.display="none";
		} else {
		}
	}

	row=row-1;
	for (var j=1;j<row+1;j++) {
		var sLable=document.getElementById("TCAT"+ColIdx+'z'+j);
		var sTD=sLable.parentElement;
		sTD.style.display="none";
	}
}

function GetUserInfoByUserCode(value)
{	
	var str=value.split("^");
	var obj=document.getElementById("OperName");
	if (obj) obj.value=str[0]
	var obj=document.getElementById("UserRowId");
	if (obj) obj.value=str[2]
	var obj=document.getElementById("GroupName");
	if (obj) obj.value=str[3]
	
}


function Print_Click()
{
	var StatFlag="";
	var obj=document.getElementById("StatFlag");
	if (obj){
		var myidx=obj.selectedIndex;
		if (myidx!=-1){
			StatFlag=obj.options[myidx].value;	
		}
		
	}	
	// i have no choice
	if(StatFlag=="AC"){
		PrintClickHandler();	
	}else{
		PrintClickHandlerOC();	
	}
	
	
}
function PrintClickHandlerOC()
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
		
		if (""!=StDate) StDate=cspRunServerMethod(encmeth,StDate)
		if (""!=EndDate) EndDate=cspRunServerMethod(encmeth,EndDate)
		var RepDate=StDate+" "+StartTime+t["zhi"]+EndDate+" "+EndTime
		//alert(StDate+"   "+EndDate+"   "+StartTime+"   "+EndTime+"   "+CurDate)
		
		var OperName=""
		var obj=document.getElementById("OperName");
		if (obj) OperName=obj.value;
		var ZBR=session['LOGON.USERNAME'];
		

		var Template=TemplatePath+"JFOP_BJYKYZLPatCatFeeOC.xls";
		
		encmeth=""
		var obj=document.getElementById('TMPJID')
		if (obj) var jid=obj.value; 
		var obj=document.getElementById("GetRowNum");
		if (obj) encmeth=obj.value; 
		var Rows=parseInt(cspRunServerMethod(encmeth,jid));
		//alert("Rows"+Rows)
		//OutPutExel
	    var xlApp = new ActiveXObject("Excel.Application");
	    var xlBook = xlApp.Workbooks.Add(Template);
	    var xlsheet = xlBook.ActiveSheet;
		//Title
		var InsType=DHCWebRep_GetListTextValue("InsType");
		var StatFlag=DHCWebRep_GetListTextValue("StatFlag");
		xlsheet.cells(1,2)=t['title']+"("+StatFlag+") ---"+InsType;

		xlsheet.cells(2,5)=RepDate;
		
		var xlsRow=2;
		var xlsCol=0;
		var i=1;
		//title
		
		//CellMerge(xlsheet,xlsRow,xlsRow,xlsCol+9,xlsCol+aryCatDesc.length+8);
		for(var k=0;k<aryCatDesc.length; k++){
			xlsheet.cells(xlsRow+i,xlsCol+5+k)=aryCatDesc[k];	
	/*
			if(k==3){
				xlsheet.cells(xlsRow+i,xlsCol+5+k)=t["XJYP"];
			}else{
				xlsheet.cells(xlsRow+i,xlsCol+5+k)=aryCatDesc[k];	
			}
	*/		
		}
	//	xlsheet.cells(xlsRow+i,xlsCol+5+k)=t["XJYL"];	k++;
		xlsheet.cells(xlsRow+i,xlsCol+5+k)=t["HJ"];		k++;
		//xlsheet.cells(xlsRow+i,xlsCol+5+k)=t["QZZF"];	k++;
		xlsheet.cells(xlsRow+i,xlsCol+5+k)=t["QZJZ"];	k++;
		//prt pm
		for(var k=0;k<aryPMDesc.length; k++){
			xlsheet.cells(xlsRow+i,xlsCol+7+k+aryCatDesc.length)=aryPMDesc[k];		
		}
		
		var lineLength=aryCatDesc.length+7+aryPMDesc.length-2;
		gridlist(xlsheet,xlsRow+2,xlsRow+i,2,lineLength+1);
		i++;
		
		//Data
		for (j=1; j<=Rows; j++)
		{ 
			encmeth="";
			var obj=document.getElementById("ReadPrtData");
			if (obj) var encmeth=obj.value;
			
			var RowStr=cspRunServerMethod(encmeth,jid,j-1);
			//alert(RowStr)
			var ary=RowStr.split("^");
			var Cols=ary.length; 
			
			for (var k=2; k<ary.length; k++)
			{
				xlsheet.cells(xlsRow+i,xlsCol+k)=ary[k];
			}
			i++;
		}
		
		gridlist(xlsheet,xlsRow+2,xlsRow+i-1,2,lineLength+1);
		
		
		//Other
		i++;
		xlsheet.cells(xlsRow+i,xlsCol+3)=t["ZBR"];
		xlsheet.cells(xlsRow+i,xlsCol+4)=session['LOGON.USERCODE'];
		xlsheet.cells(xlsRow+i,xlsCol+9)=t["shr"];
		xlsheet.cells(xlsRow+i,xlsCol+14)=t["BT"];
		xlsheet.cells(xlsRow+i,xlsCol+15)=CurDate;
		/*
		i++;
		xlsheet.cells(xlsRow+i,xlsCol+1)=t["JKR"];
		xlsheet.cells(xlsRow+i,xlsCol+6)=t["QZ"];
		i++;
		xlsheet.cells(xlsRow+i,xlsCol+1)=t["SHR"];
		xlsheet.cells(xlsRow+i,xlsCol+6)=t["KJS"];
		*/
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
		
		if (""!=StDate) StDate=cspRunServerMethod(encmeth,StDate)
		if (""!=EndDate) EndDate=cspRunServerMethod(encmeth,EndDate)
		var RepDate=StDate+" "+StartTime+t["zhi"]+EndDate+" "+EndTime
		//alert(StDate+"   "+EndDate+"   "+StartTime+"   "+EndTime+"   "+CurDate)
		
		var OperName=""
		var obj=document.getElementById("OperName");
		if (obj) OperName=obj.value;
		var ZBR=session['LOGON.USERNAME'];
		

		var Template=TemplatePath+"JFOP_BJYKYZLPatCatFee.xls";
		
		encmeth=""
		var obj=document.getElementById('TMPJID')
		if (obj) var jid=obj.value; 
		var obj=document.getElementById("GetRowNum");
		if (obj) encmeth=obj.value; 
		var Rows=parseInt(cspRunServerMethod(encmeth,jid));
		//alert("Rows"+Rows)
		//OutPutExel
	    var xlApp = new ActiveXObject("Excel.Application");
	    var xlBook = xlApp.Workbooks.Add(Template);
	    var xlsheet = xlBook.ActiveSheet;
		//Title
		var InsType=DHCWebRep_GetListTextValue("InsType");
		var StatFlag=DHCWebRep_GetListTextValue("StatFlag");
		xlsheet.cells(1,2)=t['title']+"("+StatFlag+") ---"+InsType;

		xlsheet.cells(2,5)=RepDate;
		
		var xlsRow=3;
		var xlsCol=0;
		var i=1;
		//title
		
		CellMerge(xlsheet,xlsRow,xlsRow,xlsCol+9,xlsCol+aryCatDesc.length+6);
		for(var k=0;k<aryCatDesc.length; k++){
		//	xlsheet.cells(xlsRow+i,xlsCol+5+k)=aryCatDesc[k];	
			if(k<3){
				xlsheet.cells(xlsRow+i,xlsCol+5+k)=aryCatDesc[k];	
			}
			if(k==3){
				xlsheet.cells(xlsRow+i,xlsCol+5+k)=t["XJYP"]; 
			}
			if(k>3){
				
				xlsheet.cells(xlsRow+i,xlsCol+5+k)=aryCatDesc[k-1];	
			}
			
		}
		xlsheet.cells(xlsRow+i,xlsCol+5+k)=aryCatDesc[k-1];	k++;
		xlsheet.cells(xlsRow+i,xlsCol+5+k)=t["XJYL"];	k++;
		xlsheet.cells(xlsRow+i,xlsCol+5+k)=t["HJ"];		k++;
		//xlsheet.cells(xlsRow+i,xlsCol+5+k)=t["QZZF"];	k++;
		xlsheet.cells(xlsRow+i,xlsCol+5+k)=t["QZJZ"];	k++;
		//prt pm
		for(var k=0;k<aryPMDesc.length; k++){
			xlsheet.cells(xlsRow+i,xlsCol+9+k+aryCatDesc.length)=aryPMDesc[k];		
		}
		
		var lineLength=aryCatDesc.length+8+aryPMDesc.length;
		gridlist(xlsheet,xlsRow,xlsRow+i,2,lineLength);
		i++;
		
		//Data
		for (j=1; j<=Rows; j++)
		{ 
			encmeth="";
			var obj=document.getElementById("ReadPrtData");
			if (obj) var encmeth=obj.value;
			
			var RowStr=cspRunServerMethod(encmeth,jid,j-1);
			var ary=RowStr.split("^");
			var Cols=ary.length; 
			
			for (var k=2; k<ary.length; k++)
			{
				xlsheet.cells(xlsRow+i,xlsCol+k)=ary[k];
			}
			i++;
		}
		
		gridlist(xlsheet,xlsRow,xlsRow+i-1,2,lineLength);
		
		i++;
		xlsheet.cells(xlsRow+i,xlsCol+3)=t["ZBR"];
		xlsheet.cells(xlsRow+i,xlsCol+4)=session['LOGON.USERCODE'];
		xlsheet.cells(xlsRow+i,xlsCol+9)=t["shr"];
		xlsheet.cells(xlsRow+i,xlsCol+14)=t["BT"];
		xlsheet.cells(xlsRow+i,xlsCol+15)=CurDate;
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

function CellMerge(objSheet,r1,r2,c1,c2)
{
	var range= objSheet.Range(objSheet.Cells(r1, c1),objSheet.Cells(r2,c2))
	range.MergeCells ="True"
}

function CellLine(objSheet,row1,row2,c1,c2,Style)
{     
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(Style).LineStyle=1;
}

document.body.onload = BodyLoadHandler;
document.body.onbeforeunload=UnloadHandler