var SelectedRow=-1

function BodyLoadHandler()
{
	var tbl=document.getElementById("tDHCPEInvList");
	if(tbl) tbl.ondblclick=DHC_SelectPat;

	var RPFlagValue=GetCtlValueById("RPFlagValue");	
	SetCtlValueById("RPFlag",RPFlagValue,0);
	
	obj=document.getElementById('Print');
	if (obj) { obj.onclick = Print_click; }
	
	
	obj=document.getElementById("Find");
	if (obj) {obj.onclick=Find_Click;}

	obj=document.getElementById('RegNo');
	if (obj) {obj.onkeydown=RegNo_keydown; }
	obj=document.getElementById('InvNo');
	if (obj) {obj.onkeydown=RegNo_keydown; }
	obj=document.getElementById('PatName');
	if (obj) {obj.onkeydown=RegNo_keydown; }
	
	obj=document.getElementById("CardNo");
	if (obj) {obj.onchange=CardNo_Change;
	obj.onkeydown=CardNo_KeyDown;}
	obj=document.getElementById('BGREPrint');
	if (obj) {obj.onclick=BGREPrint_Click; }
	///xml print requird  PEInvPrint
	//DHCP_GetXMLConfig("InvPrintEncrypt","PEInvRePrint");
	DHCP_GetXMLConfig("InvPrintEncrypt","PEInvPrint");
	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}
	obj=document.getElementById("BPrintProve");
	if (obj) {obj.onclick=BPrintProve_Click;}
	initialReadCardButton()
	document.onkeydown=ShortKeyDown;
	websys_setfocus("InvNo");
}
function ShortKeyDown()
{
	if (event.keyCode==115)
	{
		obj=document.getElementById("BReadCard");
		if (obj) obj.click();
	}
}
function CardNo_Change()
{
	CardNoChangeApp("RegNo","CardNo","Find_Click()","Clear_click()","0");
}
function ReadCard_Click()
{
	ReadCardApp("RegNo","Find_Click()","CardNo");
	
}

function SelectRowHandler(){ 
	var objTemp =document.getElementById("isApplyTemp")
	if(objTemp){
		isApply=objTemp.value.split("$")[0];
		objTemp.value=isApply+"$0"
		
	} 
	var eSrc=window.event.srcElement;
	if (eSrc.id.split("TInvNo").length>1) return false;
	var objtbl=document.getElementById('tDHCPEInvList');
	if (objtbl){ var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	var rowid=""
	var admtype="";
	var giadm="";
	if (!selectrow) return;
	
	if (selectrow!=SelectedRow) {
		//ShowCurRecord(selectrow);
		SelectedRow = selectrow;
		rowid=GetCtlValueById("TRowIdz"+selectrow);
		admtype=GetCtlValueById("TAdmTypez"+selectrow);
		giadm=GetCtlValueById("TGIAdmz"+selectrow);
		
		var obj=document.getElementById('RPFRowId');
		if (obj) { obj.value = rowid; }
		
		var iInvNo=""
		var obj=document.getElementById("TInvNoz"+selectrow);
		if(obj){var iInvNo=obj.innerText }
		var obj=document.getElementById("InvNo");
		if (obj) { obj.value = iInvNo; } 

	}
	else{ SelectedRow=0; }
	RefreshDropItem(rowid,admtype,giadm)
	
	
}

function RefreshDropItem(rowid,admtype,giadm)
{
	var isApply=""
  	var obj=document.getElementById("isApply");
	if (obj) { isApply=obj.value};
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT=DHCPEDropItem&InvPrtId='+rowid+'&ADMType='+admtype+'&GIADM='+giadm+'&isApply='+isApply;
	var obj=parent.frames["DHCPEDropItem"];
	if (obj) obj.location.href=lnk;
}
function Print_click()
{
	PrintInvDetail();
	return false;
	var aInvRptDR="";
	var obj=document.getElementById('RPFRowId');
	if (obj && ""!=obj.value) {
		aInvRptDR=obj.value;
		//alert(aInvRptDR);return;
		InvItemFeeListPrint(aInvRptDR); // DHCPEInvItemFeeListPrint.js
		                                   //DHCPEInvItemFeeListPrint.js
	}
}
function RegNo_keydown(e){
	
	var Key=websys_getKey(e);
	if ((13==Key)) {
		Find_Click();
	}
}


function Find_Click()
{   
   var iRegNo="",iPatName="",iBeginDate="",iEndDate="",iInvNo="",iRPFlag="",iUser="",iEntryLoc="";
   var obj
    
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	obj=document.getElementById("RegNo");
	if (obj){ 
		iRegNo=obj.value;
		if (iRegNo.length<RegNoLength && iRegNo.length>0) { iRegNo=RegNoMask(iRegNo);}
	}

	
	obj=document.getElementById("PatName");
    if (obj) { iPatName=obj.value};
    
    
    obj=document.getElementById("BeginDate");
    if (obj) { iBeginDate=obj.value};
	
	obj=document.getElementById("EndDate");
    if (obj) { iEndDate=obj.value};
    
    obj=document.getElementById("InvNo");
    if (obj) { iInvNo=obj.value};

    
    obj=document.getElementById("RPFlag");
    if (obj) { iRPFlag=obj.value};
    
	obj=document.getElementById("User");
    if (obj) { iUser=obj.value};
    obj=document.getElementById("EntryLoc");
    if (obj) { iEntryLoc=obj.value};
    
	var isApply=""
  	obj=document.getElementById("isApply");
	if (obj) { isApply=obj.value};

	var SelfOnlyFlag=GetCtlValueById("SelfOnlyFlag"); 
     
  var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEInvList"
			+"&RegNo="+iRegNo
			+"&PatName="+iPatName
			+"&BeginDate="+iBeginDate
			+"&EndDate="+iEndDate
			+"&InvNo="+iInvNo
			+"&RPFlag="+iRPFlag
			+"&isApply="+isApply
			+"&SelfOnlyFlag="+SelfOnlyFlag
            +"&User="+iUser
            +"&EntryLoc="+iEntryLoc;
    location.href=lnk; 

}
function PrintInvDetail()
{
	var obj=document.getElementById('RPFRowId');
	if (obj && ""!=obj.value) {
		var PEINVDR=obj.value;
		var obj=document.getElementById('GetAdmType');
		if (obj) 
		{
			encmeth=obj.value;
			var peAdmType=cspRunServerMethod(encmeth,PEINVDR);
			
			var obj=document.getElementById("InvNo");
			if(obj && ""==obj.value){
		     alert("发票为退费的负记录,不能打印");
		     return ;
			}

		}
	}else{	
			//alert(t['NOADMTYPE']);
    	    alert("请选择要打印清单的记录");
	    	return ;
	}
    
	var listFlag=GetListFlag(peAdmType);
	DHCP_GetXMLConfig("InvPrintEncrypt","PEINVPRTLIST");
	var encmeth=GetCtlValueById("GetInvoiceInfo");
	var TxtInfo=cspRunServerMethod(encmeth,peAdmType,PEINVDR,"List")

	var encmeth=GetCtlValueById("GetInvoiceList");
	var ListInfo=cspRunServerMethod(encmeth,peAdmType,PEINVDR,1,"1")
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}
/*function BGREPrint_Click()
{
	DHCP_GetXMLConfig("InvPrintEncrypt","PEInvPrint");
	var obj=document.getElementById('RPFRowId');
	if (obj && ""!=obj.value) {
		var PEINVDR=obj.value;
		var obj=document.getElementById('GetAdmType');
		if (obj) 
		{
			encmeth=obj.value;
			var peAdmType=cspRunServerMethod(encmeth,PEINVDR);
		}
    		else
    		{	
    			alert(t['NOADMTYPE']);
	    		return ;
	    	}
    
		var listFlag=GetListFlag(peAdmType);
		
		var encmeth=GetCtlValueById("GetInvoiceInfo");
		var TxtInfo=cspRunServerMethod(encmeth,peAdmType,PEINVDR)
	    var encmeth=GetCtlValueById("GetInvoiceList");
		var ListInfo=cspRunServerMethod(encmeth,peAdmType,PEINVDR,listFlag)
		var myobj=document.getElementById("ClsBillPrint");
		DHCP_PrintFun(myobj,TxtInfo,ListInfo);
	}
}
*/
function BGREPrint_Click()
{
	DHCP_GetXMLConfig("InvPrintEncrypt","PEInvPrint");
	
	var obj=document.getElementById('RPFRowId');
	
	if (obj && ""!=obj.value) {
		var PEINVDR=obj.value;
		var obj=document.getElementById('GetAdmType');
		if (obj) 
		{
			encmeth=obj.value;
			var peAdmType=cspRunServerMethod(encmeth,PEINVDR);
			
			var obj=document.getElementById("InvNo");
			if(obj && ""==obj.value){
		     alert("发票为退费的负记录,不能打印");
		     return ;
	     }

		}
	}else
    		{ 
    			//alert(t['NOADMTYPE']);
    			 alert("请选择要重打发票的记录");
	    		return ;
	    	}
    
		var listFlag=GetListFlag(peAdmType);
		
		var encmeth=GetCtlValueById("GetInvoiceInfo");
		var TxtInfo=cspRunServerMethod(encmeth,peAdmType,PEINVDR)
	    var encmeth=GetCtlValueById("GetInvoiceList");
		var ListInfo=cspRunServerMethod(encmeth,peAdmType,PEINVDR,listFlag)
		var myobj=document.getElementById("ClsBillPrint");
		DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}

function GetListFlag(admtype)
{
	if (admtype!="I") return 0;
	obj= document.getElementById("HiddenListFlag");		
	if (!obj) return 0;
	if (obj.value=="1") return 1;
	return 0;
	
}
function DHC_SelectPat()
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj,InvNo="",RfInvNo="";
	var obj=document.getElementById("TInvNoz"+selectrow);
	if (obj) InvNo=trim(obj.innerText);
	var TopObj=parent.frames["ModifyPayMode"];
	if (!TopObj) return false;
	if (InvNo!=""){
		if(InvNo.indexOf("(")>-1){var InvNo=InvNo.split("(")[0];}
		var obj=TopObj.document.getElementById("InvNo");
			if (obj) obj.value=InvNo;
		TopObj.InvNo_Change();
	}else{
		var obj=document.getElementById("TRInvNoz"+selectrow);
		if (obj) RfInvNo=trim(obj.innerText);
		if (RfInvNo!=""){
			var obj=TopObj.document.getElementById("RInvNo");
			if (obj) obj.value=RfInvNo;
			TopObj.RInvNo_Change();
		}
	}
	
	//var obj=GetObj("TInvNoz"+selectrow);
}
function trim(str)
{
	if(!str || typeof str != 'string') return null;
	return str.replace(/^[\s]+/,'').replace(/[\s]+$/,'').replace(/[\s]{2,}/,' ');
}
function BPrintProve_Click()
{
	var obj=document.getElementById('RPFRowId');
	if (obj && ""!=obj.value) {
		var PEINVDR=obj.value;
		var obj,encmeth;
		obj=document.getElementById("prnpath");
		if (obj&& ""!=obj.value) {
			var prnpath=obj.value;
			var Templatefilepath=prnpath+'DHCPEProvePrt.xls';
		}else{
			alert("无效模板路径");
			return;
		}
		
		var obj=document.getElementById("InvNo");
	     if(obj && ""==obj.value){
		     alert("发票为退费的负记录,不能打印");
		     return ;
	     }

		obj=document.getElementById("GetProveInfoClass");
		if (obj) encmeth=obj.value;
		var PrintData=cspRunServerMethod(encmeth,PEINVDR);
		xlApp= new ActiveXObject("Excel.Application"); //固定
		xlBook= xlApp.Workbooks.Add(Templatefilepath); //固定
		xlsheet= xlBook.WorkSheets("Sheet1"); //Excel下标的名称
		var Char_3=String.fromCharCode(3);
		var Char_2=String.fromCharCode(2);
		var DataArr=PrintData.split(Char_3);
		var BaseInfo=DataArr[0];
		var BaseArr=BaseInfo.split("^");
		//xlsheet.cells(5,4)=BaseArr[0];
		//xlsheet.cells(5,8)=BaseArr[1];
		
		var Str="经查询"+BaseArr[0]+"同志在我院开出的收据号为"+BaseArr[1];
		var Length=Str.length
		if(Length>31) {
			var m=1;
			xlsheet.cells(5,3)=Str.substr(0,30);
			xlsheet.Rows(6).insert();
			 xlsheet.Range(xlsheet.Cells(6,2),xlsheet.Cells(6,8)).mergecells=true
			xlsheet.cells(6,2)=Str.substr(30,Length);
			
			
		}else{
			var m=0;
			xlsheet.cells(5,3)="经查询"+BaseArr[0]+"同志在我院开出的收据号为"+BaseArr[1];
		}
        //xlsheet.cells(7,5)=BaseArr[2];
        xlsheet.cells(7+m,5)=BaseArr[2];
		//var Rows=7;
		var Rows=7+m;

		var CatInfo=DataArr[1];
		var CatArr=CatInfo.split(Char_2);
		var CatLength=CatArr.length;
		for (var i=0;i<CatLength;i++)
		{
			var OneCatInfo=CatArr[i];
			var OneArr=OneCatInfo.split("^");
			Rows=Rows+1;
			xlsheet.cells(Rows,4)=OneArr[0];
			xlsheet.cells(Rows,6)=OneArr[1];
		}
		Rows=Rows+1;
		xlsheet.cells(Rows,4)="实付";
		xlsheet.cells(Rows,6)=BaseArr[4];
		Rows=Rows+1;
		xlsheet.cells(Rows,4)="合计";
		xlsheet.cells(Rows,6)=BaseArr[3];
		Rows=Rows+1;
		xlsheet.cells(Rows,4)="大写";
		xlsheet.cells(Rows,6)=BaseArr[5];
		Rows=Rows+2;
		var ItemFeeInfo=DataArr[2];
		var ItemFeeArr=ItemFeeInfo.split(Char_2)
		var ItemFeeLength=ItemFeeArr.length;
		for (var i=0;i<ItemFeeLength;i++)
		{
			Rows=Rows+1;
			xlsheet.cells(Rows,1)=(i+1);
			var OneInfo=ItemFeeArr[i];
			var OneArr=OneInfo.split("^");
			xlsheet.cells(Rows,2)=OneArr[0];
			xlsheet.cells(Rows,5)=OneArr[1];
			xlsheet.cells(Rows,6)=OneArr[2];
			xlsheet.cells(Rows,7)=OneArr[3];
			xlsheet.cells(Rows,8)=OneArr[4];
		}
		Rows=Rows+1;
		xlsheet.cells(Rows,2)="合计";
		xlsheet.cells(Rows,8)=BaseArr[4];
		Rows=Rows+3;
		xlsheet.cells(Rows,2)="特此证明";
		xlsheet.cells(Rows+1,7)=BaseArr[6];
		var HosName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",session['LOGON.HOSPID'])
		xlsheet.cells(Rows,7)=HosName;
		xlsheet.cells(Rows,7).HorizontalAlignment=1;
		xlsheet.cells(Rows+1,7).HorizontalAlignment=1;

		xlsheet.printout;
		//xlsheet.SaveAs("d:\\团体异常值汇总.xls");
		xlBook.Close (savechanges=false);
		xlApp=null;
		xlsheet=null;
	}else{
		        alert("请选择要打印收据证明的记录");
	    		return ;
	}
	
}

document.body.onload = BodyLoadHandler;