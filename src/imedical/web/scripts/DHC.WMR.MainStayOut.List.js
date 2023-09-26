/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.MainStayOut.List

AUTHOR: wuqk , Microsoft
DATE  : 2007-7
========================================================================= */
function BodyLoadHandler()
{
	IniForm();
	//alert("0");	
	//alert(location.href);
	//location.reload();
	//ReLoadForm();
}
function IniForm()
{
	/*var MrTypeDr="", IsStayIn=""
	
	var obj=document.getElementById("MrTypeDr");
	if (obj){
				MrTypeDr=obj.value;
		}
	var obj=document.getElementById("IsStayIn");
	if (obj){
				IsStayIn=obj.value;
		}
	
	objMrType = GetDHCWMRDictionaryByID("MethodGetDicItem", MrTypeDr);
	if(objMrType != null)
	{
		setElementValue("txtMrType", objMrType.Description);
	}*/
	//location.reload();
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.MainStayOut.List"+"&DateFrom=" +cDateFrom+ "&DateTo=" +cDateTo+"&UserFrom="+cUserFrom+"&UserTo="+cUserTo+"&WorkItem="+cWorkItem+"&Flg=2";
  //location.href=lnk;
  
  //document.getElementById("btnPrint").onclick = PrintTable;
  document.getElementById("btnPrint").onclick = Print_Table;
}

function PrintTable()
{
	var objPrinter = new ActiveXObject("DHCMedWebPackage.clsPrinter"); 
	if(objPrinter == null)
	{
		window.alert("fail to init Printer Control");
		return;	
	}
	var objTable = document.getElementById("tDHC_WMR_MainStayOut_List");
	var obj = null;
	var intRow = 0;
	var intCol = 0
	var objArry = new Array();
	objPrinter.fontSize = 11;
	for(var i = 0; i < objTable.rows.length; i ++)
	{
		objArry.push(
			{	 
				MrNo:getElementValue("MRNOz"+i), 
				PatName:getElementValue("Namez"+i), 
				Dep:getElementValue("AimCtLocDescz"+i),
				OutDate:getElementValue("ResponseDatez"+i)
			}
			);
	}
	//a();
	objPrinter.FontSize = 15;
	objPrinter.FontBold = true;
	objPrinter.PrintContents(8, 1, t["ReportTitle"]);	
	objPrinter.fontSize = 11
	objPrinter.FontBold = false;
	for(var i = 1; i < objArry.length; i ++)
	{
		obj = objArry[i];
		PrintRow(objPrinter, intCol, intRow, obj);
		intCol ++;
		if(intCol > 1)
		{
			intRow ++;
			intCol = 0;
			if(intRow > 40)
			{
				intRow = 0;
				objPrinter.NewPage();
			}	
		}
	}
	objPrinter.EndDoc();
}

function PrintRow(objPrinter, intCol, intRow, obj)
{
		var leftM = 1;
		var topM = 2;
		objPrinter.PrintContents(leftM + intCol * 10 + 5, topM + intRow * 0.6, obj.MrNo);
		objPrinter.PrintContents(leftM + intCol * 10 + 7, topM + intRow * 0.6, obj.PatName);
		objPrinter.PrintContents(leftM + intCol * 10 + 0.0, topM + intRow * 0.6, obj.Dep);
		objPrinter.PrintContents(leftM + intCol * 10 + 9, topM + intRow * 0.6, obj.OutDate);
}

BodyLoadHandler();
window.PrintTable = PrintTable;


//***************************by zf add 2008-04-09*****************************

function Print_Table()
{
	var objPrinter = new ActiveXObject("DHCMedWebPackage.clsPrinter"); 
	if(objPrinter == null)
	{
		window.alert("fail to init Printer Control");
		return;	
	}
	var objTable = document.getElementById("tDHC_WMR_MainStayOut_List");
	var obj = null;
	var objArry = new Array();
	for(var i = 0; i < objTable.rows.length; i ++)
	{
		objArry.push(
			{	
				Dep:getElementValue("AimCtLocDescz"+i), 
				MrNo:getElementValue("MRNOz"+i), 
				PatName:getElementValue("Namez"+i), 
				ReqUser:getElementValue("AimUserNamez"+i), 
				OutDate:getElementValue("ResponseDatez"+i),
				OutTime:getElementValue("ResponseTimez"+i),
				RegfeeDoc:getElementValue("RegfeeDocz"+i)
			}
			);
	}
	
	var pLeft=1,pTop=1,rowHeight=0.6;	
	var intRow = 0, CurrLeft = 0, CurrTop = 0;
	objPrinter.FontSize = 15;
	objPrinter.FontBold = true;
	CurrLeft = pLeft + 7, CurrTop = pTop + 0;
	objPrinter.PrintContents(CurrLeft, CurrTop, t["ReportTitle"]);
	CurrLeft = pLeft, CurrTop = CurrTop + 1;
	
	objPrinter.fontSize = 11;
	objPrinter.FontBold = false;
	Print_Title(objPrinter,CurrLeft,CurrTop);
	CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
	
	for(var i = 1; i < objArry.length; i ++)
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
			CurrLeft = pLeft + 6, CurrTop = pTop + 0;
			objPrinter.PrintContents(CurrLeft, CurrTop, t["ReportTitle"]);
			CurrLeft = pLeft, CurrTop = CurrTop + 1;
			
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
	objPrinter.PrintContents(CurrLeft,CurrTop, obj.Dep);
	CurrLeft=CurrLeft + 3.5;
	objPrinter.PrintContents(CurrLeft,CurrTop, obj.MrNo);
	CurrLeft=CurrLeft + 2.5;
	objPrinter.PrintContents(CurrLeft,CurrTop, obj.PatName);
	CurrLeft=CurrLeft + 2.5;
	objPrinter.PrintContents(CurrLeft,CurrTop, obj.RegfeeDoc);
	CurrLeft=CurrLeft + 2.5;
	objPrinter.PrintContents(CurrLeft,CurrTop, obj.OutDate);
	CurrLeft=CurrLeft + 2.5;
	objPrinter.PrintContents(CurrLeft,CurrTop, obj.OutTime); 
}

function Print_Title(objPrinter,CurrLeft,CurrTop)
{
	objPrinter.PrintContents(CurrLeft,CurrTop, t['Dep']);
	CurrLeft=CurrLeft + 3.5;
	objPrinter.PrintContents(CurrLeft,CurrTop, t['MrNo']);
	CurrLeft=CurrLeft + 2.5;
	objPrinter.PrintContents(CurrLeft,CurrTop, t['PatName']);
	CurrLeft=CurrLeft + 2.5;
	objPrinter.PrintContents(CurrLeft,CurrTop, t['RegfeeDoc']);
	CurrLeft=CurrLeft + 2.5;
	objPrinter.PrintContents(CurrLeft,CurrTop, t['OutDate']);
	CurrLeft=CurrLeft + 2.5;
	objPrinter.PrintContents(CurrLeft,CurrTop, t['OutTime']); 
}

//************************************end***********************************