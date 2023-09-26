//DHCOPFin.JSTRefundINVDetail.js
//-----------Author: yanyubiao------2006-12-01------------
function BodyLoadHandler()
{
	var obj=document.getElementById("BPrint");
	if (obj)
	{
		obj.onclick=Print_Click;
	}
	/*
	alert(1232);
	var obj=document.getElementById("Find");
	if (obj)
	{	
		obj.onclick=Find_Click;
	}
	*/
	var obj=document.getElementById("BClear");
	if (obj)
	{	
		obj.onclick=BClear_Click;
	}

	
	IntDoc();
}

function BClear_Click()
{
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPFin.JSTRefundINVDetail";
	//document.location.href=lnk;
	var obj=document.getElementById("GroupDR");
	if (obj) var groupId=obj.value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOP.BackInvDetail&GroupDR="+groupId;
	document.location.href=lnk;
}
function Find_Click()
{
	var StDate,StTime,Enddate,EndTime="";
	
	var obj=document.getElementById("StDate");
	if (obj) StDate=obj.value;
	var obj=document.getElementById("StartTime");
	if (obj) StTime=obj.value;
	var obj=document.getElementById("EndDate");
	if (obj) Enddate=obj.value;
	var obj=document.getElementById("EndTime");
	if (obj) EndTime=obj.value;
	
	var obj=document.getElementById("uName");
	if (obj) uName=obj.value;
	
	uName=escape(uName);
	
	var obj=document.getElementById("sUser");
	if (obj) Guser=obj.value;
	var obj=document.getElementById("GroupDR");
	if (obj) var groupId=obj.value;

	var obj=document.getElementById("EndDate");
	if (obj) Enddate=obj.value;


	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOP.BackInvDetail&sUser="+Guser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime+"&GroupDR="+groupId;
	//alert(lnk);
	document.location.href=lnk;
	
}

function UserLookup(str)
{	
	var arr=str.split("^");
	var obj=document.getElementById("sUser");
	if (obj) obj.value=arr[2];

	
}

function IntDoc()
{

	var obj=document.getElementById("uName");
	if (obj)
	{
		obj.value=unescape(obj.value);    
	}
	
	var objtbl=document.getElementById("tUDHCJFOP_BackInvDetail");
	var Rows=objtbl.rows.length;
  
  	//alert(Rows)
  	var jid=""
  	if (Rows>1)
  	{ 
  		var listobj=document.getElementById("TTMPGIDz"+1);
		var myval=DHCWebD_GetCellValue(listobj);
		
		var obj=document.getElementById("TMPGID");
		if (obj){ obj.value=myval; }
		var jid=obj.value
		
	//	var obj=document.getElementById("ReadPrtData");
	//
	//	if (obj) {var encmeth=obj.value;  } else {var encmeth='';}
	//	var RowStr=cspRunServerMethod(encmeth,jid,"");
	//
	//  SetData(RowStr)
   } 
}
function SetData(RowStr)
{//INVNum_"^"_ParkInvNum_"^"_CashSum_"^"_CashNum_"^"_ChequeSum_"^"_ChequeNum_"^"_HuiPiaoSum_"^"_HuiPiaoNum_"^"_BankCardSum_"^"_BankCardNum_"^"_ParkCashSum_"^"_ParkCashNum_"^"_ParkChequeSum_"^"_ParkChequeNum_"^"_ParkHuiPiaoSum_"^"_ParkHuiPiaoNum_"^"_ParkBankCardSum_"^"_ParkBankCardNum

	var ary=RowStr.split("^")
	
	DHCWebD_SetObjValueA("INVNum",ary[1])
	DHCWebD_SetObjValueA("ParkInvNum",ary[2])
	DHCWebD_SetObjValueA("CashSUM",ary[3])
	DHCWebD_SetObjValueA("CashNUM",ary[4])
	DHCWebD_SetObjValueA("CheckSUM",ary[5])
	DHCWebD_SetObjValueA("CheckNUM",ary[6])
	DHCWebD_SetObjValueA("DraftSum",ary[7])
	DHCWebD_SetObjValueA("DraftNum",ary[8])
	DHCWebD_SetObjValueA("BankCardSum",ary[9])
	DHCWebD_SetObjValueA("BankCardNum",ary[10])
	DHCWebD_SetObjValueA("ParkCashSUM",ary[11])
	DHCWebD_SetObjValueA("ParkCashNUM",ary[12])
	DHCWebD_SetObjValueA("ParkCheckSUM",ary[13])
	DHCWebD_SetObjValueA("ParkCheckNUM",ary[14])
	DHCWebD_SetObjValueA("ParkDraftSum",ary[15])
	DHCWebD_SetObjValueA("ParkDraftNum",ary[16])
	DHCWebD_SetObjValueA("ParkBankCardSum",ary[17])
	DHCWebD_SetObjValueA("ParkBankCardNum",ary[18])
	DHCWebD_SetObjValueA("PrePayGatherSum",ary[19])
	DHCWebD_SetObjValueA("PrePayBackSum",ary[20])
}
function Print_Click()
{
	
	PrintClickHandlerINVRep();
}

function PrintClickHandlerINVRep()
{
	///AHSLYY  Hospital  INV State
	
	try {
		var GetPrescPath=document.getElementById("GetRepPath");
		
		if (GetPrescPath) 	{var encmeth=GetPrescPath.value} 
		else {var encmeth=''};
		if (encmeth!="") 
		{
			TemplatePath=cspRunServerMethod(encmeth);
		}
		
		//alert(TemplatePath);
        var BeginDate,EndDate,TotalSum,PatPaySum,PayorSum;
		var myencmeth="";
        
        var obj=document.getElementById("DateTrans");
        if (obj)
        {
	        myencmeth=obj.value;
        }
        
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCOPFin_JSTRefundINVDetail.xls";
	    var UserCode=""
	    var obj=document.getElementById("uName");
	    if (obj){   var UserCode=obj.value;    }
	    
	    ////var obj=document.getElementById("HSDate");
	    var obj=document.getElementById("StDate");
	    if (obj) {BeginDate=obj.value;}
	    if (myencmeth!="")
	    {   
	    	 BeginDate=cspRunServerMethod(myencmeth,BeginDate);
	    }
	    
	    ///var obj=document.getElementById("HEDate");
	    var obj=document.getElementById("EndDate");
	    if (obj) EndDate=obj.value;
	    if (myencmeth!=""){
		    EndDate=cspRunServerMethod(myencmeth,EndDate);
	    }
	    
		var obj=document.getElementById("CurDate");
		if (obj){	var PDate=obj.value;	}
		//alert("BeginDate"+BeginDate+"EndDate"+EndDate+"PDate"+PDate) 
	    
	    var obj=document.getElementById("StartTime");
		if (obj){	var stTime=obj.value;	}
	    
	    var obj=document.getElementById("EndTime");
		if (obj){	var endTime=obj.value;	}

	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
		
		var obj=document.getElementById("Title");
     	if (obj)
     	{
	   	   var title=obj.value;
	   	   xlsheet.cells(1,2)=title;
     	}

		
		//xlsheet.cells(2,6)=UserCode;	
		xlsheet.cells(2,6)=BeginDate+" "+stTime+t["zhi"] +EndDate+" "+endTime;	

		var myRows=Rows;
		
		var obj=document.getElementById('TMPGID')
		if (obj) {var jid=obj.value; }
		
		var obj=document.getElementById("GetRowNum");
		if (obj) {var encmeth=obj.value;  } 
		else {var encmeth='';}
		
		var Rows=cspRunServerMethod(encmeth,jid);
		var myRows=parseInt(Rows);
		
		var xlsrow=3;
		var xlsCurcol=0;
		
		for (var Row=0;Row<myRows;Row++)
		{
			xlsrow=xlsrow+1;

			var obj=document.getElementById("ReadPrtData");
			if (obj) {var encmeth=obj.value;  } else {var encmeth='';}
			var RowStr=cspRunServerMethod(encmeth,jid,Row);
			var ary=RowStr.split("^")
			//alert(RowStr)
			//$lb(PDRowid,AccPDBillNo,myPAPMNo,myPAName,PreSum,ParkPreSum,"",handflag,PrePayUser,myPreDate,myPreTime,PayModeDesc,AccmWoffDate,AccmWoffTime, "" , "",myTMPGID)
			//PRTrowid,PapmiNo,PapmiName,oldPRTNO,oldPRTAcount,oldPRTDate,oldPRTTime,newPRTNO,newPRTAcount,newPRTDate,newPRTTime,SsusrName,PayModeDesc,Abortflag,refundflag,myTMPGID)
			xlsheet.cells(xlsrow,xlsCurcol+1)=ary[2];	//PapmiNo
			xlsheet.cells(xlsrow,xlsCurcol+2)=ary[3];	//PapmiName
			xlsheet.cells(xlsrow,xlsCurcol+3)=ary[4];	//PreSum
			xlsheet.cells(xlsrow,xlsCurcol+4)=ary[5];	//ParkPreSum
			xlsheet.cells(xlsrow,xlsCurcol+5)=ary[8];	//PayModeDesc
			xlsheet.cells(xlsrow,xlsCurcol+6)=ary[9];	//AccPDBillNo
			xlsheet.cells(xlsrow,xlsCurcol+7)=ary[13];
			xlsheet.cells(xlsrow,xlsCurcol+8)=ary[6]+" "+ary[7];	//PRTDate,PRTTime
			//xlsheet.cells(xlsrow,xlsCurcol+9)=t["Yes"];	//WorkSum
			
			
			
		}
	    
	    gridlist(xlsheet,3,xlsrow,1,8);
		
		xlsrow=xlsrow+1;
		
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,xlsCurcol+1)=t["GatherPrePaySum"];
		xlsheet.cells(xlsrow,xlsCurcol+2)=DHCWebD_GetObjValue("PrePayGatherSum");
	
		xlsheet.cells(xlsrow,xlsCurcol+5)=t["BackPrePaySum"]
		xlsheet.cells(xlsrow,xlsCurcol+6)=" "+DHCWebD_GetObjValue("PrePayBackSum")
		
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,xlsCurcol+1)=t["qizhong"]
		
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,xlsCurcol+1)=t["CASH"]
		xlsheet.cells(xlsrow,xlsCurcol+2)=DHCWebD_GetObjValue("CashSUM")
		xlsheet.cells(xlsrow,xlsCurcol+3)=DHCWebD_GetObjValue("CashNUM")+t["zhang"]
		
		xlsheet.cells(xlsrow,xlsCurcol+5)=t["CASH"]
		xlsheet.cells(xlsrow,xlsCurcol+6)=DHCWebD_GetObjValue("ParkCashSUM")
		xlsheet.cells(xlsrow,xlsCurcol+7)=DHCWebD_GetObjValue("ParkCashNUM")+t["zhang"]
		
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,xlsCurcol+1)=t["CHEQUES"]
		xlsheet.cells(xlsrow,xlsCurcol+2)=DHCWebD_GetObjValue("ParkCheckSUM")
		xlsheet.cells(xlsrow,xlsCurcol+3)=DHCWebD_GetObjValue("CheckNUM")+t["zhang"]
		
		xlsheet.cells(xlsrow,xlsCurcol+5)=t["CHEQUES"]
		xlsheet.cells(xlsrow,xlsCurcol+6)=DHCWebD_GetObjValue("ParkCheckSUM")
		xlsheet.cells(xlsrow,xlsCurcol+7)=DHCWebD_GetObjValue("ParkCheckNUM")+t["zhang"]
	
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,xlsCurcol+1)=t["HUIPIAO"]
		xlsheet.cells(xlsrow,xlsCurcol+2)=DHCWebD_GetObjValue("DraftSum")
		xlsheet.cells(xlsrow,xlsCurcol+3)=DHCWebD_GetObjValue("DraftNum")+t["zhang"]
		
		xlsheet.cells(xlsrow,xlsCurcol+5)=t["HUIPIAO"]
		xlsheet.cells(xlsrow,xlsCurcol+6)=DHCWebD_GetObjValue("ParkDraftSum")
		xlsheet.cells(xlsrow,xlsCurcol+7)=DHCWebD_GetObjValue("ParkDraftNum")+t["zhang"]
		
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,xlsCurcol+1)=t["BANKCARD"]
		xlsheet.cells(xlsrow,xlsCurcol+2)=DHCWebD_GetObjValue("BankCardSum")
		xlsheet.cells(xlsrow,xlsCurcol+3)=DHCWebD_GetObjValue("BankCardNum")+t["zhang"]
		
		xlsheet.cells(xlsrow,xlsCurcol+5)=t["BANKCARD"]
		xlsheet.cells(xlsrow,xlsCurcol+6)=DHCWebD_GetObjValue("ParkBankCardSum")
		xlsheet.cells(xlsrow,xlsCurcol+7)=DHCWebD_GetObjValue("ParkBankCardNum")+t["zhang"]
		
		xlsrow=xlsrow+1;
		xlsheet.cells(xlsrow,xlsCurcol+1)=t["FPHJ"]
		xlsheet.cells(xlsrow,xlsCurcol+2)=DHCWebD_GetObjValue("INVNum")+t["zhang"]
		xlsheet.cells(xlsrow,xlsCurcol+5)=t["qizhong"]+t["FPZF"]+DHCWebD_GetObjValue("ParkInvNum")+t["zhang"]
		
		xlsrow=xlsrow+2;
		xlsheet.cells(xlsrow,xlsCurcol+1)=t["fu"];
		if (UserCode=="") UserCode=t["sky"];
		xlsheet.cells(xlsrow,xlsCurcol+2)=UserCode;
		xlsheet.cells(xlsrow,xlsCurcol+3)=t["zbr"]
		xlsheet.cells(xlsrow,xlsCurcol+4)=session['LOGON.USERNAME']+"  ";
		xlsheet.cells(xlsrow,xlsCurcol+7)=t["bt"];
		xlsheet.cells(xlsrow,xlsCurcol+8)=PDate;
	    
	    xlsrow=xlsrow+2;
		xlsheet.cells(xlsrow,xlsCurcol+1)=t["CHUNA"];
		xlsheet.cells(xlsrow,xlsCurcol+3)=t["fh"];
		xlsheet.cells(xlsrow,xlsCurcol+7)=t["KUAIJI"];
	    
	    xlsheet.printout; 
	    xlBook.Close (savechanges=false);
	    
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	} catch(e) {
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

function UnloadHandler()
{	
	
	var myEncrypt=DHCWebD_GetObjValue("DELPRTTMPDATA");
	var myTMPGID=DHCWebD_GetObjValue("TMPGID");
	if (myEncrypt!="")
	{
		var mytmp=cspRunServerMethod(myEncrypt, myTMPGID);
	}
	
}

document.body.onload = BodyLoadHandler;
document.body.onbeforeunload=UnloadHandler

//document.body.onunload =UnloadHandler;