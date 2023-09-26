/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.Discharge.Qry

AUTHOR: LiYang , Microsoft
DATE  : 2007-5-8
========================================================================= */
var objArry = new Array();//
var objSortArry = new Array();//
var objSortRule = new Array();//
var btn_BatchRecover=document.getElementById("BatchRecover");
var myType=7;
var tmpChinese;
function GetChinese(MethodName,Ind)
{
	var strMethod = document.getElementById(MethodName).value;
	var ret = cspRunServerMethod(strMethod,Ind);
	var tmp=ret.split("^");
	return tmp;
}
tmpChinese=GetChinese("MethodGetChinese","DischargeList");
//alert(tmpChinese[0]+"||"+tmpChinese[1]+"||"+tmpChinese[2]);


function DHCWMRDischarge()
{
	var obj = new Object();
	obj.MrNO = "";
	obj.DisDep = "";
	obj.Department = "";
	obj.PatientName = "";
	obj.RegNo = "";
	obj.DisDate = "";
	return obj;
}

function SortRule()
{
	objSortRule.push(tmpChinese[3]);
	objSortRule.push(tmpChinese[4]);
	objSortRule.push(tmpChinese[5]);
	objSortRule.push(tmpChinese[6]);
	objSortRule.push(tmpChinese[7]);
	objSortRule.push(tmpChinese[8]);
	objSortRule.push(tmpChinese[9]);
	objSortRule.push(tmpChinese[10]);
	objSortRule.push(tmpChinese[11]);
	objSortRule.push(tmpChinese[12]);
	objSortRule.push(tmpChinese[13]);
	objSortRule.push(tmpChinese[14]);
	objSortRule.push(tmpChinese[15]);
	objSortRule.push(tmpChinese[16]);
	objSortRule.push(tmpChinese[17]);
	objSortRule.push(tmpChinese[18]);
	objSortRule.push(tmpChinese[19]);
	objSortRule.push(tmpChinese[20]);
	objSortRule.push(tmpChinese[21]);
	objSortRule.push(tmpChinese[22]);
	objSortRule.push(tmpChinese[23]);
	objSortRule.push(tmpChinese[24]);
	objSortRule.push(tmpChinese[25]);
	objSortRule.push(tmpChinese[26]);
	objSortRule.push(tmpChinese[27]);
	objSortRule.push(tmpChinese[28]);
	objSortRule.push(tmpChinese[29]);
	objSortRule.push(tmpChinese[30]);
	objSortRule.push(tmpChinese[31]);
	objSortRule.push(tmpChinese[32]);
	objSortRule.push(tmpChinese[33]);
	objSortRule.push(tmpChinese[34]);
	objSortRule.push(tmpChinese[35]);
	objSortRule.push(tmpChinese[36]);
	objSortRule.push(tmpChinese[37]);
	objSortRule.push(tmpChinese[38]);
	objSortRule.push(tmpChinese[39]);
	objSortRule.push(tmpChinese[40]);
	objSortRule.push(tmpChinese[41]);
	objSortRule.push(tmpChinese[42]);
	objSortRule.push(tmpChinese[43]);
	objSortRule.push(tmpChinese[44]);
	objSortRule.push(tmpChinese[45]);
	objSortRule.push(tmpChinese[46]);
	
	//alert(tmpChinese[46]);
	objSortRule.push("");
}

//Get data from table to collection.
function GetDisChargeList()
{
	var obj = null;
	var objTable = document.getElementById("tDHC_WMR_Discharge_List");
	for(var i = 1; i < objTable.rows.length; i ++)
	{
		obj = DHCWMRDischarge();
		obj.MrNO = getElementValue("MrNOz" + i);
		obj.DisDep = getElementValue("WardDescz" + i);
		obj.PatientName = getElementValue("PatNamez" + i);
		obj.DisDate = getElementValue("DischgDatez" + i);
		obj.Department  = getElementValue("LocDescz" + i);
		objArry[i - 1] = obj;
	}
}

function GetDisPatientList(dep)
{
	var arry = new Array();
	var obj = null;
	var objArryDate = getElementValue("txtFilter").split("/");
	var strDate = objArryDate[2] + "-" + objArryDate[1] + "-" + objArryDate[0];
	var objTable = document.getElementById("tDHC_WMR_Discharge_List");
	for(var i = 0; i < objArry.length; i ++)
	{
		obj = objArry[i];
		if((GetDesc(obj.DisDep, "-") == dep) && (obj.DisDate < strDate))
			arry.push(obj);
	}
	return arry;
}

function PrintDischargeList()
{
	var strCurrentWardDesc = "";
	var arry = null;
	var intLine = 0;
	var intXPos = 0;
	var intLeft = 1;
	var intTop = 1;
	var fltLineHeight = 0.5;
	var objItem = null;
	objPrinter = new ActiveXObject("DHCMedWebPackage.clsPrinter");
	for(var i = 0; i < objSortRule.length; i ++)
	{
		arry = GetDisPatientList(objSortRule[i]);
		if(objSortRule[i] != strCurrentWardDesc)
		{
			objPrinter.Font = tmpChinese[0];
			objPrinter.FontBold = true;
			objPrinter.FontSize = 11;
			intLine ++;
			objPrinter.PrintContents(
				intLeft,
				intTop + intLine * fltLineHeight,
				objSortRule[i]);
			strCurrentWardDesc = objSortRule[i];
			intLine ++;
			intXPos = 0;
			objPrinter.Font = tmpChinese[1];
			objPrinter.FontBold = false;
			objPrinter.FontSize = 11;
		}		
		
		for(var counter = 0; counter < arry.length; counter ++)
		{
			objItem = arry[counter];
			objPrinter.PrintContents(
				intLeft + intXPos * 6,
				intTop + intLine * fltLineHeight,
				objItem.MrNO);
			objPrinter.PrintContents(
				intLeft + intXPos * 6 + 1.5,
				intTop + intLine * fltLineHeight,
				objItem.PatientName);
			objPrinter.PrintContents(
				intLeft + intXPos * 6 + 3,
				intTop + intLine * fltLineHeight,
				objItem.DisDate);
			if(intXPos >= 2)
			{
				intLine ++;
				intXPos = 0;
			}else
			{
				intXPos ++;
			}
			if(intLine >= 50)
			{
				intLine = 0;
				intXPos = 0;
				objPrinter.NewPage();
			}
		}
	}
	objPrinter.EndDoc();
}

function SortByPinYin()
{
		var objArryNo = new Array()
	var obj = null;
	var obj1 = null;
	for(var i = 0; i < objArry.length; i ++)
	{
		obj = objArry[i];
		if(obj.DisDate == FormatDateString(getElementValue("txtFilter")))
		{
			objArryNo.push(obj);
		}
	}
	for(var i = 0; i < objArryNo.length; i ++)
	{
		for(var j = 0; j < objArryNo.length -1; j ++)
		{
			obj = objArryNo[j];
			obj1 = objArryNo[j + 1];
			if(GetPinYin(obj.PatientName) > GetPinYin(obj1.PatientName))
			{
				objArryNo[j] = obj1;
				objArryNo[j + 1] = obj;
			}
		}
	}
	return objArryNo;
}

function SortByMrNo()
{
	var objArryNo = new Array()
	var obj = null;
	var obj1 = null;
	for(var i = 0; i < objArry.length; i ++)
	{
		obj = objArry[i];
		if(obj.DisDate == FormatDateString(getElementValue("txtFilter")))
		{
			objArryNo.push(obj);
		}
	}
	for(var i = 0; i < objArryNo.length; i ++)
	{
		for(var j = 0; j < objArryNo.length -1; j ++)
		{
			obj = objArryNo[j];
			obj1 = objArryNo[j + 1];
			if(new Number(obj.MrNO) > new Number(obj1.MrNO))
			{
				objArryNo[j] = obj1;
				objArryNo[j + 1] = obj;
			}
		}
	}
	return objArryNo;
}

function PrintList(objArryDischarge)
{
	var objItem = null;
	var objPrinter = new ActiveXObject("DHCMedWebPackage.clsPrinter");
	var LeftMarge = 1.5;
	var TopMarge = 1.5;
	var ColWidth = 6;
	var LinePerCol = 50;
	var LineHeight = 0.5;
	var intCol = 0;
	var XPos = 0;
	objPrinter.Font = tmpChinese[1];
	objPrinter.FontBold = false;
	objPrinter.FontSize = 11;
	objPrinter.PrintContents(
		1,1,	tmpChinese[2] + getElementValue("txtFilter"));
	for(var i = 0; i < objArryDischarge.length; i ++)
	{
		objItem = objArryDischarge[i];
		objPrinter.PrintContents(
			LeftMarge + intCol *  ColWidth,
			TopMarge + XPos * LineHeight,
			objItem.MrNO);
		objPrinter.PrintContents(
			LeftMarge + intCol *  ColWidth + 1.5,
			TopMarge + XPos * LineHeight,
			objItem.PatientName);
		objPrinter.PrintContents(
			LeftMarge + intCol *  ColWidth + 3,
			TopMarge +  XPos  * LineHeight,
			GetDesc(objItem.DisDep, "-"));		
		XPos ++;	
		if(XPos >= LinePerCol) 
		{
			XPos = 0;
			intCol ++;
			if(intCol >= 4)
			{
				objPrinter.NewPage();
				XPos = 0;
				intCol = 0;
			}	
		}
	}
	objPrinter.EndDoc();
}


function cmdFilterOnClick()
{
	var objArry = getElementValue("txtFilter").split("/");
	var strDate = objArry[2] + "-" + objArry[1] + "-" + objArry[0];
	var objTable = window.parent.frames[1].document.getElementById("tDHC_WMR_Discharge_List");
	for(var i = 1 ; i < objTable.rows.length; i ++)
	{
		if(getElementValue("DischgDatez"+ i)   < strDate)
		{
			objTable.rows[i].style.backgroundColor = "hotpink";
		}
		else
		{
			objTable.rows[i].style.backgroundColor = "";
		}
	}
	
}

function cmdPrintOnClick()
{
	//var objArry = GetDischargeList("MethodGetDischargeList", 
	//		"MethodGetDataBy", 
	//		getElementValue("cType"));
	/*for(var i = 0; i < 500; i ++)
	{
		objArry.push(objArry[0]);
	}*/
	var objTable = window.parent.frames[1].document.getElementById("tDHC_WMR_Discharge_List");
	if(objTable.rows.length > 1)
	{
		//PrintDischargeList();				//delete by Liuxuef 20080904
		Print_Table();								//add by Liuxuef 20080904
	}
	else
	{
		window.alert(t["EmptyList"]);
	}
	
}

function cmdPrintDischargeListOnClick()
{
	PrintList(SortByMrNo());
}

function cmdPrintDischargeList1OnClick()
{
	PrintList(SortByPinYin());
}

function cmdQueryOnClick()
{
	var cType="",StartDate="",EndDate="",LocRowid="",WardRowid="",DispalyFlag="",PrintFlag="";
	cType=getElementValue("cType");
	StartDate=getElementValue("StartDate");
	EndDate=getElementValue("EndDate");
	LocRowid=getElementValue("cLocRowid");
	WardRowid=getElementValue("cWardRowid");
	MrDoctor=getElementValue("MrDoctor");
	DispalyFlag=document.getElementById("DispalyFlag").checked;//add by liuxuefeng 2010-04-16
	if(DispalyFlag==false)
	{ 
	  DispalyFlag="A";
	  if(btn_BatchRecover){
		btn_BatchRecover.disabled=true;	  
	  }
	}else {
	  DispalyFlag="N";
	  if(btn_BatchRecover){
      	btn_BatchRecover.disabled=false;
      }
	}
  var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.Discharge.List" + "&cType=" +cType + "&StartDate=" +StartDate + "&EndDate=" +EndDate + "&LocId=" +LocRowid + "&WardId=" +WardRowid + "&DispalyFlag="+DispalyFlag+"&PrintFlag="+PrintFlag;
  parent.RPbottom.location.href=lnk;
}

function InitForm()
{
//	document.write(GetVBPrinterObjectString("MethodGetVBPrinter"));
	//GetDisChargeList(); ooo
	//SortRule(); ooo
	document.getElementById("DispalyFlag").checked=true;//add by liuxuefeng 2010-04-16
	document.getElementById("BatchRecover").disabled=false;
	var linkObj=window;
	myType=GetParam(linkObj,"MrType");
	if(myType<0){myType=7;}
}

function InitEvents()
{
	var obj=document.getElementById("cmdExport");
	if (obj) {obj.onclick=cmdExport_onclick;}
	var obj=document.getElementById("cmdPrint");
	if (obj) {obj.onclick=cmdPrint_onclick;}
	var obj=document.getElementById("cmdPrintVB");
	if (obj) {obj.onclick=cmdPrintOnClick;}
	var obj=document.getElementById("cmdFilter");
	if (obj){obj.onclick = cmdFilterOnClick;}
	var obj=document.getElementById("cmdExportSign");
	if (obj){obj.onclick = cmdExportSign_onclick;}
	

	var obj=document.getElementById("cmdPrintDischargeList");
	if (obj) {obj.onclick = cmdPrintDischargeListOnClick;}
	var obj=document.getElementById("cmdPrintDischargeList1");
	if (obj) {obj.onclick = cmdPrintDischargeList1OnClick;}
	var obj=document.getElementById("cmdQuery");
	if (obj) {obj.onclick = cmdQueryOnClick;}
	var objLocDesc=document.getElementById("cLocDesc");
	if (objLocDesc){objLocDesc.onchange=LocDesc_onChange;}
	var objWardDesc=document.getElementById("cWardDesc");
	if (objWardDesc){objWardDesc.onchange=WardDesc_onChange;}
	/*
	var displayFlag=document.getElementById("DispalyFlag");
	if (displayFlag){displayFlag.onclick=ChkDisplayFlag_Click;}
	*/
	var btn_BatchRecover=document.getElementById("BatchRecover");
	if (btn_BatchRecover){
		btn_BatchRecover.onclick=BatchRecover_Click;	
	}
}
function BatchRecover_Click(){
	    if(btn_BatchRecover.disabled==true){
		    alert("请选中只显示回收并查询后再做批量回收操作");
		   return;    
		}
		if(window.confirm("是否批量执行回收操作?") != true)
		{
			return false;
		}
		//var objLnk=parent.RPbottom;
		//alert(objLnk.location.href);
		//var MrType=GetParam(objLnk,"MrTypeDr");
		var MrType=myType;
		var CurrStatus=1;
		var UserID=session['LOGON.USERID'];
		var LocID=session['LOGON.CTLOCID'];
	    var objTable = parent.RPbottom.document.getElementById("tDHC_WMR_Discharge_List"); 
	    var VolRowidStr="";
	    var objItm=null;
	    var VolRowid="";
	  if (objTable.rows.length<2) 
	  {
	  	alert("请您首先选择条件进行查询!");
	  	return false;
	  }
    for(var i = 1; i < objTable.rows.length; i ++)
    {
    		objItm=parent.RPbottom.document.getElementById("chkitemz" + i);
    		if (objItm.checked==true)
    		{
    			VolRowid=parent.RPbottom.document.getElementById("VolRowidz" + i).value;
    			VolRowidStr = VolRowidStr + VolRowid + "*";
    		}
    } 
  if (VolRowidStr=="")
  {
  	alert("请选择您要处理的病案卷项目!");
  	return false;
  }
	var ret=tkMakeServerCall("web.DHCWMRVolumeCtl","BatchUpdateVolStatus",MrType, CurrStatus, UserID, LocID, VolRowidStr);
	if (ret<0){
		alert("批量处理错误!");
	}else{
		alert("批量处理成功!");
	}
	parent.RPbottom.location.reload();
}
function ChkDisplayFlag_Click(){
	var displayFlag=document.getElementById("DispalyFlag");
	var btnBatchRecover=document.getElementById("BatchRecover");
	if (displayFlag){
		if (btnBatchRecover){
			if (displayFlag.checked){
				btnBatchRecover.disabled=false;
			}else{
				btnBatchRecover.disabled=true;
			}
		}
	}
}
InitForm();
InitEvents();
//***************************add by Liuxuefeng 2008-09-04*****************************
//打印格式调整（打印内容：科室LocDesc，病案号MrNO，病人姓名PatName，出院日期DischgDate , 出院天数DischgDays）
function Print_Table()
{
	var objPrinterNew = new ActiveXObject("DHCMedWebPackage.clsPrinter");
	if(objPrinterNew == null)
	{
		window.alert("fail to init Printer Control");
		return;	
	}
	var objTable = window.parent.frames[1].document.getElementById("tDHC_WMR_Discharge_List");
	var obj = null;
	var objArry = new Array();
	for(var i = 0; i < objTable.rows.length; i ++)
	{
		objArry.push(
			{	
				LocDesc:getElementValue("WardDescz"+i,window.parent.frames[1].document), 			//Modify by liuxuefeng 2009-06-06
				MrNO:getElementValue("MrNOz"+i,window.parent.frames[1].document), 						//Modify by liuxuefeng 2009-06-06
				PatName:getElementValue("PatNamez"+i,window.parent.frames[1].document), 			//Modify by liuxuefeng 2009-06-06
				DischgDate:getElementValue("DischgDatez"+i,window.parent.frames[1].document),	//Modify by liuxuefeng 2009-06-06
				DischgDays:getElementValue("DischgDaysz"+i,window.parent.frames[1].document)	//Modify by liuxuefeng 2009-12-05
			}
			);
	}
	
	var pLeft=1,pTop=0.1,rowHeight=0.5;	
	var intRow = 0, CurrLeft = 0, CurrTop = 0;
	objPrinterNew.FontSize = 11;
	objPrinterNew.FontBold = true;
	CurrLeft = pLeft + 6, CurrTop = pTop + 0;
	objPrinterNew.PrintContents(CurrLeft, CurrTop, t["ReportTitle"]);
	intRow ++;																															//add by liuxuefeng 2009-07-29
	CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
	
	objPrinterNew.fontSize = 11;
	objPrinterNew.FontBold = true;
	Print_Title(objPrinterNew,CurrLeft,CurrTop);
	intRow ++;																															//add by liuxuefeng 2009-07-29
	CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
	var EachWardNo=0;																												//add by liuxuefeng 2009-07-29
	for(var i = 1; i < objArry.length; i ++)
	{

		obj = objArry[i];
		Print_Row(objPrinterNew,CurrLeft, CurrTop,obj);
		CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
		intRow ++;
		EachWardNo++;																													//add by liuxuefeng 2009-07-29
		//////////////////////add by liuxuefeng 2009-06-15/////////////////
		if (i < objArry.length-1){
			var dep=objArry[i].LocDesc;
			var depNext=objArry[i+1].LocDesc;
			if ((depNext!=dep)){
				
				objPrinterNew.FontSize = 11;
				objPrinterNew.FontBold = true;
				CurrLeft = pLeft+1, CurrTop = CurrTop;															//add by liuxuefeng 2009-07-29
				objPrinterNew.PrintContents(CurrLeft, CurrTop, "---- 小计 "+EachWardNo+" 人 ----");	//add by liuxuefeng 2009-07-29
				intRow ++;																													//add by liuxuefeng 2009-07-29
				CurrLeft = pLeft + 6, CurrTop = CurrTop + rowHeight;								//Modify by liuxuefeng 2009-07-29
				objPrinterNew.PrintContents(CurrLeft, CurrTop, t["ReportTitle"]);
				CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
				intRow ++;
				
				objPrinterNew.fontSize = 11;
				objPrinterNew.FontBold = true;
				Print_Title(objPrinterNew,CurrLeft,CurrTop);
				CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
				intRow ++;
				EachWardNo=0;																												//add by liuxuefeng 2009-07-29
			}
		}
		///////////////////////////////////////////////////////////////////
		
		if ((intRow > 50)&&(i < objArry.length))
		{
			objPrinterNew.NewPage();
			intRow = 0, CurrLeft = 0, CurrTop = 0;
			/*
			objPrinterNew.FontSize = 15;
			objPrinterNew.FontBold = true;
			CurrLeft = pLeft + 6, CurrTop = pTop + 0;

			objPrinterNew.PrintContents(CurrLeft, CurrTop, t["ReportTitle"]);
			CurrLeft = pLeft, CurrTop = CurrTop + 1;
			
			objPrinterNew.fontSize = 11;
			objPrinterNew.FontBold = true;
			Print_Title(objPrinterNew,CurrLeft,CurrTop);
			*/
			intRow= intRow + 1;
			CurrLeft = pLeft, CurrTop = CurrTop + rowHeight;
			
		}
		
	}
	objPrinterNew.PrintContents(CurrLeft+1, CurrTop, "---- 小计 "+EachWardNo+" 人 ----");	//add by liuxuefeng 2009-07-29
	objPrinterNew.EndDoc();
}

function Print_Row(objPrinterNew,CurrLeft,CurrTop,obj)
{
	//var depArray=obj.LocDesc.split("-");
	//var dep=depArray[1];
	CurrLeft=CurrLeft + 1;
	objPrinterNew.PrintContents(CurrLeft,CurrTop, obj.LocDesc);
	CurrLeft=CurrLeft + 4;
	objPrinterNew.PrintContents(CurrLeft,CurrTop, obj.MrNO);
	CurrLeft=CurrLeft + 3.5;
	objPrinterNew.PrintContents(CurrLeft,CurrTop, obj.PatName);
	CurrLeft=CurrLeft + 3.5;
	objPrinterNew.PrintContents(CurrLeft,CurrTop, obj.DischgDate);
	CurrLeft=CurrLeft + 3.5;
	objPrinterNew.PrintContents(CurrLeft,CurrTop, obj.DischgDays);
}

function Print_Title(objPrinterNew,CurrLeft,CurrTop)
{
	CurrLeft=CurrLeft + 1;
	objPrinterNew.PrintContents(CurrLeft,CurrTop, t["WardDesc"]);
	CurrLeft=CurrLeft + 4;
	objPrinterNew.PrintContents(CurrLeft,CurrTop, t["MrNO"]);
	CurrLeft=CurrLeft + 3.5;
	objPrinterNew.PrintContents(CurrLeft,CurrTop, t["PatName"]);
	CurrLeft=CurrLeft + 3.5;
	objPrinterNew.PrintContents(CurrLeft,CurrTop, t["DischgDate"]);
	CurrLeft=CurrLeft + 3.5;
	objPrinterNew.PrintContents(CurrLeft,CurrTop, "出院天数");
}

//************************************end***********************************

function LookUpLocDesc(tmp)
{
	var tmpList=tmp.split("^");
	var objLocDesc=document.getElementById("cLocDesc");
	if (objLocDesc){objLocDesc.value=tmpList[0];}
	var objLocRowid=document.getElementById("cLocRowid");
	if (objLocRowid){objLocRowid.value=tmpList[1];}
}

function LookUpWardDesc(tmp)
{
	var tmpList=tmp.split("^");
	var objWardDesc=document.getElementById("cWardDesc");
	if (objWardDesc){objWardDesc.value=tmpList[0];}
	var objWardRowid=document.getElementById("cWardRowid");
	if (objWardRowid){objWardRowid.value=tmpList[1];}
}

function LocDesc_onChange()
{
	var objWardDesc=document.getElementById("cWardDesc");
	if (objWardDesc){objWardDesc.innerText="";}
	var objWardRowid=document.getElementById("cWardRowid");
	if (objWardRowid){objWardRowid.value="";}
	
	var objLocRowid=document.getElementById("cLocRowid");
	if (objLocRowid){objLocRowid.value="";}
}

function WardDesc_onChange()
{
	//var objWardDesc=document.getElementById("cWardDesc");
	//if (objWardDesc){objWardDesc.innerText="";}
	var objWardRowid=document.getElementById("cWardRowid");
	if (objWardRowid){objWardRowid.value="";}
}

function cmdExport_onclick()
{
	var objLnk=parent.RPbottom;
	var cType=GetParam(objLnk,"cType");
	var StartDate=GetParam(objLnk,"StartDate");
	if (StartDate=="")	return false;
	var EndDate=GetParam(objLnk,"EndDate");
	var LocId=GetParam(objLnk,"LocId");
	var WardId=GetParam(objLnk,"WardId");
	var MrDoctor=GetParam(objLnk,"MrDoctor");
	var DispalyFlag=GetParam(objLnk,"DispalyFlag");
	var PrintFlag="";
	var cArguments=cType+"^"+StartDate+"^"+EndDate+"^"+LocId+"^"+WardId+"^"+DispalyFlag+"^"+PrintFlag;
	//alert(cArguments);
	var flg=ExportDataToExcel("MethodGetServer","MethodGetData","DHCWMRDischargeList.xls",cArguments);
	//var flg=ExportDataToExcelApp("MethodGetServer","MethodGetData","DHCWMRDischargeList.xls",cArguments);
}

function cmdPrint_onclick()
{
	var objLnk=parent.RPbottom;
	var cType=GetParam(objLnk,"cType");
	var StartDate=GetParam(objLnk,"StartDate");
	if (StartDate=="")	return false;
	var EndDate=GetParam(objLnk,"EndDate");
	var LocId=GetParam(objLnk,"LocId");
	var WardId=GetParam(objLnk,"WardId");
	var DispalyFlag=GetParam(objLnk,"DispalyFlag");
	var PrintFlag="";
	var cArguments=cType+"^"+StartDate+"^"+EndDate+"^"+LocId+"^"+WardId+"^"+DispalyFlag+"^"+PrintFlag;
	//alert(cArguments);
	var flg=PrintDataByExcel("MethodGetServer","MethodGetData","DHCWMRDischargeList.xls",cArguments);
}

function ExportDataToExcelApp(strMethodGetServer,strMethodGetData,strTemplateName,strArguments)
{   
	var strMethod = document.getElementById(strMethodGetData).value;
	if (strMethod=="") return false;
		//var FileName="E:/trakcarelive/app/trak/med/Results/Template/DHCWMRDischargeList.xls"；
		//var FileName="http://172.22.6.101/trakcarelive/trak/med/results/template/DHCWMRCirculMROP.xls"
		var FileName="http://127.0.0.1/trakcare/med/Templates/DHCWMRDischargeList.xls"
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			alert("创建Excel应用对象失败!");
			return false;
		}
		xls.visible=false;
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);
		var flg=cspRunServerMethod(strMethod,"fillxlSheet",strArguments);
		var fname = xls.Application.GetSaveAsFilename(strTemplateName, "Excel Spreadsheets (*.xls), *.xls");
		xlBook.SaveAs(fname);
		xlSheet=null;
		xlBook.Close (savechanges=false);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		idTmr=window.setInterval("Cleanup();",1);
	return true;
}


function cmdExportSign_onclick()
{
	var objLnk=parent.RPbottom;
	var cType=GetParam(objLnk,"cType");
	var StartDate=GetParam(objLnk,"StartDate");
	if (StartDate=="")	return false;
	var EndDate=GetParam(objLnk,"EndDate");
	var LocId=GetParam(objLnk,"LocId");
	var WardId=GetParam(objLnk,"WardId");
	var MrDoctor=GetParam(objLnk,"MrDoctor");
	var DispalyFlag=GetParam(objLnk,"DispalyFlag");
	var PrintFlag="";
	var cArguments=cType+"^"+StartDate+"^"+EndDate+"^"+LocId+"^"+WardId+"^"+DispalyFlag+"^"+PrintFlag;
	//alert(cArguments);
	var flg=ExportDataToExcel("MethodGetServer","MethodGetDataSign","DHCWMRDisSignList.xls",cArguments);
	//var flg=ExportDataToExcelApp("MethodGetServer","MethodGetData","DHCWMRDischargeList.xls",cArguments);
}
