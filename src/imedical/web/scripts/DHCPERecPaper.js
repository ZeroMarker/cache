///	DHCPERecPaper.js
///	前台收表功能
///	20121114  
///	-----------------------
///	created by rxb 20121114
///	Description:    
var TFORM="tDHCPERecPaper"; 
var TFORM1="tDHCPERecGPaper"; 
var CurrentSel=0
function BodyLoadHandler(){
	var obj;  
	obj=document.getElementById("ConfirmRecPaper"); 
	if (obj) { obj.onkeydown=ConfirmRecPaper_KeyDown; 
	}  
	if (obj){obj.onfocus=txtfocus;}

	obj=document.getElementById("BFind");
	if (obj){ obj.onclick=BFind_click; }
	
	
	obj=document.getElementById("BPrint");
	if (obj){ obj.onclick=BPrint_click; }	
	
	obj=document.getElementById("txtRegNo");
	if (obj) { obj.onkeydown=RegNo_KeyDown; }
	
	//add 20121207
	obj=document.getElementById("BCancelRecPaper");
	if (obj){ obj.onclick=BCancelRecPaper_click; }
	 
	
	websys_setfocus("ConfirmRecPaper"); 
} 
function txtfocus()
{
    var obj;
	obj=document.getElementById("ConfirmRecPaper");
	/*active 代表输入法为中文
	inactive 代表输入法为英文
	auto 代表打开输入法 (默认)
	disable 代表关闭输入法
	*/
if(obj.style.imeMode ==  "disabled")
{                       
 }
else
{                      
	//alert(2);
	obj.style.imeMode   =   "disabled";    
	//obj.value   =   "";             
}      
  // alert(obj.style.imeMode);


}
//add 20121207
function BCancelRecPaper_click() {
	if (CurrentSel==0) return;
	var iPIADM="";
	var obj=document.getElementById("PIADMz"+CurrentSel);
	if (obj){ iPIADM=obj.value; }

	if (iPIADM=="")	{
		alert(t['01']);
		return false
	} 
	else{ 
		if (confirm(t['02'])) {
			var Ins=document.getElementById('CancelRecPaper');
			if (Ins) {var encmeth=Ins.value; } 
			else {var encmeth=''; };

			var flag=cspRunServerMethod(encmeth,iPIADM)
			if(flag=="-1"){alert("未收表不能取消");}
			else if (flag=='0') {alert("操作成功");}
			else{
				alert(t['03']+flag)
			}
		location.reload();
		}
	}
}

function BFind_click() {  
	var obj;
	var iRecBegDate="";
	var iRecEndDate=""; 
	var itxtRegNo=""; 
	var iArrivedFlag="",iALLPerson="",iALLGroup="";  
	var iVIPType="";
	
	/*obj=document.getElementById("TFORM");
	if (obj){ var tForm=obj.value; }
	else { return false; }*/
  
	obj=document.getElementById("RecBegDate");
	if (obj){ iRecBegDate=obj.value; } 
	obj=document.getElementById("RecEndDate");
	if (obj){ iRecEndDate=obj.value; }	
	obj=document.getElementById("ArrivedFlag");
	if (obj&&obj.checked){ iArrivedFlag="on"; }  
	obj=document.getElementById("ALLPerson");
	if (obj&&obj.checked){ iALLPerson="on"; }
	obj=document.getElementById("ALLGroup");
	if (obj&&obj.checked){ iALLGroup="on"; }

	
	obj=document.getElementById("txtRegNo");
	if (obj){ 
			itxtRegNo=obj.value; 
			if (itxtRegNo.length<8 && itxtRegNo.length>0) { itxtRegNo=RegNoMask(itxtRegNo);}
	}
	
	obj=document.getElementById("VIPLevel");
	if (obj){
		//alert(obj.value)
		var iVIPLevel=obj.value; }
		  
	/*
	var lnk1="websys.default.csp?WEBSYS.TCOMPONENT=DHCPERecGPaper"
			+"&RecBegDate="+iRecBegDate
			+"&RecEndDate="+iRecEndDate 
			+"&txtRegNo="+itxtRegNo
			+"&ArrivedFlag="+iArrivedFlag
	;  
	parent.frames["DHCPERecGPaper"].location.href=lnk1; 
	*/
	
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+tForm
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPERecPaper"
			+"&RecBegDate="+iRecBegDate
			+"&RecEndDate="+iRecEndDate 
			+"&txtRegNo="+itxtRegNo
			+"&ArrivedFlag="+iArrivedFlag
			+"&VIPLevel="+iVIPLevel
			+"&ALLPerson="+iALLPerson
			+"&ALLGroup="+iALLGroup
			;
	
	window.location.href=lnk; 
} 
function RegNo_KeyDown(e)
{
	var Key=websys_getKey(e); 
	if ((13==Key)) 
	{
		BFind_click(); 
	}
}
/*
function ConfirmRecPaper_KeyDown(e)
{
	
	var iReportDate="",iRegNo="";
	var Key=websys_getKey(e); 
	if ((13==Key)) 
	{
		obj=document.getElementById("ConfirmRecPaper");  
		if (obj){ iRegNo=obj.value; }	
		var PADMS=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetPIADMByRegNo",iRegNo);
		var PADM=PADMS.split("^")[1];
		if (PADM==""){return false;}
		
		var PAADM=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetPAADMByPADM",PADM);
		if (PAADM==""){return false;}
		var Flag=""
		if (PAADM!="")
		{
			var Flag=tkMakeServerCall("web.DHCPE.ResultEdit","GetUnAppedItems","",PAADM,"1","0");
			
		}
		ConfirmRecPaper_click(); 
		/*
		if (Flag!="")
		{
			ConfirmRecPaper_click(); 
		}
		else
		{
		obj=document.getElementById("RecBegDate");  
	    if (obj){ iReportDate=obj.value; }
		obj=document.getElementById("ConfirmRecPaper");  
		if (obj){ iRegNo=obj.value; }	  
		var Return=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetRecPaper",iRegNo,iReportDate);
		if (Return!=0)
		{   
		alert(Return);
   		}
   		BFind_click(); 
		websys_setfocus("ConfirmRecPaper");
		}*/
		
	//}
	
//}


//modified by xy 20180502
function ConfirmRecPaper_KeyDown(e)
{
	
	var iReportDate="",iRegNo="";
	var Key=websys_getKey(e); 
	if ((13==Key)) 
	{
		obj=document.getElementById("ConfirmRecPaper"); 
		if (obj){ iRegNo=obj.value; }
		
		
	  if (iRegNo=="") 
	   {
		   alert("请输入登记号")
		   return false;
	   }
		var PADMS=tkMakeServerCall("web.DHCPE.PreIADMEx","GetNoRecPaperRecord",iRegNo);
		if (PADMS.split("^")[0]!="0"){
			alert(PADMS.split("^")[1]);
			return false;
		}
		var PADM=PADMS.split("^")[1];
		if (PADM==""){
			alert("没有要收表的记录");
			return false;
			}
		var PADMArr=PADM.split("$");
		//alert(PADM)
		if (PADMArr.length>2){
			var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPESelectPIADMRecord&PIADMs="+PADM;
			var wwidth=700;
			var wheight=600;
			var xposition = (screen.width - wwidth) / 2;
			var yposition = (screen.height - wheight) / 2;
			var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			; 
	 
			var cwin=window.open(lnk,"_blank",nwin);
	
		}
		else{
		var PAADM=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetPAADMbyPreIADM",PADMArr[0]); 
		var Flag=""
		if (PAADM!="")
		{
			var Flag=tkMakeServerCall("web.DHCPE.ResultEdit","GetUnAppedItems","",PAADM,"1","0");
		}
     
		if (Flag!="")
		{
			ConfirmRecPaper_click(); 
		}
		else
		{
		obj=document.getElementById("RecBegDate"); 
	    if (obj){ iReportDate=obj.value; }
		obj=document.getElementById("ConfirmRecPaper"); 
		if (obj){ iRegNo=obj.value; } 
		var Return=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetRecPaper",iRegNo,iReportDate,"");
		if (Return!=0)
		{ 
		alert(Return);
   		}
   		
   		BFind_click(); 
		websys_setfocus("ConfirmRecPaper");
		}
		
			
		}
	}
			
	
}



function ConfirmRecPaper_click()
{
	var strPatNo=GetCtlValueById("ConfirmRecPaper");
  	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEReportDate"+"&RegNo="+strPatNo+"&RecLabFlag=1";
	
	var wwidth=700;
	var wheight=600;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			; 
	 
	var cwin=window.open(lnk,"_blank",nwin);
	
	////BFind_click(); 
    
}
function BPrint_click()
{  
	
    try{
	var obj;
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPERecPaper.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称
     
 
	var RowsLen=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetRowLength");  
	if(RowsLen==0){		
		alert("此次查询结果为空")
	   	return;
	} 
	var HosName=""
	var HosName=tkMakeServerCall("web.DHCPE.DHCPEUSERREPORT","GetHospitalName");
	xlsheet.cells(1,1)=HosName
	var k=3
	for(var i=1;i<=RowsLen;i++)
	{  
		var DataStr=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetRowData",i); 
		var tempcol=DataStr.split("^"); 
		k=k+1;
		xlsheet.Rows(k).insert(); 
		xlsheet.cells(k,1)=tempcol[0];
		xlsheet.cells(k,2)=tempcol[1];
		xlsheet.cells(k,3)=tempcol[2];
		xlsheet.cells(k,4)=tempcol[3];
		xlsheet.cells(k,5)=tempcol[4];
		xlsheet.cells(k,6)=tempcol[5];
		xlsheet.cells(k,7)=tempcol[6];
		xlsheet.cells(k,8)=tempcol[7]; 
		xlsheet.cells(k,9)=tempcol[8];
		xlsheet.cells(k,10)=tempcol[9]; 
		xlsheet.cells(k,11)=tempcol[10];

		
	}   
	///删除最后的空行
	xlsheet.Rows(k+1).Delete;
/*xlsheet.SaveAs("d:\\未回传结果项目.xls");
xlApp.Visible = true;
xlApp.UserControl = true;	 
idTmr   =   window.setInterval("Cleanup();",1);  
*/ 
    xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp.Quit();
	xlApp=null;
	xlsheet=null

	idTmr   =   window.setInterval("Cleanup();",1); 
	 
}
catch(e)
	{
		alert(e+"^"+e.message);
	}
}
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	if (selectrow==CurrentSel)
	{	    
	    CurrentSel=0;
	    return;
	}

	CurrentSel=selectrow;


}
document.body.onload = BodyLoadHandler;