/// 创建时间		2006.04.12
/// 创建人		xuwm
/// 主要功能		
/// 对应表		
/// 最后修改时间
/// 最后修改人	

var CurrentSel=0;
document.write("<object ID='DealWord' CLASSID='CLSID:0C9F8A5C-C272-4BA0-9DAC-42FDF048BBC6' CODEBASE='../addins/client/DealWord.CAB#version=1,0,0,10'>");

document.write("</object>");
var CurrentSel=0;
var Char_1="#"
var Char_2="^"
function BodyLoadHandler() {

	var obj;
	
	//审核按钮
	obj=document.getElementById("BAudit");
	//if (obj){ obj.onclick=Update_click; }	
	if (obj){ obj.onclick=CancelAudit_click; }	
	//打印按钮
	obj=document.getElementById("BPrint");
	if (obj){ obj.onclick=Update_click; }

	//发送按钮
	obj=document.getElementById("BSend");
	if (obj){ obj.onclick=Update_click; }
	
	//发送短信
	obj=document.getElementById("BSendSMS");
	if (obj){ obj.onclick=BSend_click; }

	//查询按钮
	obj=document.getElementById("BQuery");
	if (obj){ obj.onclick=BQuery_click; }

	//清除条件按钮
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }
	
	//打印测试按钮
	obj=document.getElementById("BPrintGReport");
	if (obj){  obj.onclick=PrintTest; }
 
 	
 	obj=document.getElementById("ExportGroupResult");
	if (obj){ obj.onclick=ExportGroupResult_click; }
 	
 	obj=document.getElementById("ExportGroupILLInfo");
	if (obj){  obj.onclick=ExportGroupILLInfo_click; }

  obj=document.getElementById("ExportGroupAbnormity");
	if (obj){  obj.onclick=ExportGroupAbnormity_click; }
	//团体诊断
	obj=document.getElementById("BGDiagnosis");
	if (obj){  obj.onclick=GDiagnosis_click; }
     obj=document.getElementById("BPartPrint");    //add by zhouli
	if (obj){ obj.onclick=PPUpdate_click; }        //add by zhouli
	iniForm();
	//wordcontorl();
}
function wordcontorl(){ 
alert("小孟佳的宝贝"); 
var WordApp=new ActiveXObject("Word.Application"); 
var wdCharacter=1 
var wdOrientLandscape = 1 
WordApp.Application.Visible=true; //执行完成之后是否弹出已经生成的word 
var myDoc=WordApp.Documents.Add();//创建新的空文档 
WordApp.ActiveDocument.PageSetup.Orientation = wdOrientLandscape//页面方向设置为横向 
WordApp. Selection.ParagraphFormat.Alignment=1 //1居中对齐,0为居右 
WordApp. Selection.Font.Bold=true 
WordApp. Selection.Font.Size=20 
WordApp. Selection.TypeText("孟佳烧香"); 
WordApp. Selection.MoveRight(wdCharacter);　　　　//光标右移字符 
WordApp.Selection.TypeParagraph() //插入段落 
WordApp. Selection.Font.Size=12 
WordApp. Selection.TypeText("-----朱漪编写"); //分行插入日期 
WordApp.Selection.TypeParagraph() //插入段落 
var myTable=myDoc.Tables.Add (WordApp.Selection.Range, 8,7) //8行7列的表格 
//myTable.Style="网格型" 
var aa = "孟佳标题" 
var TableRange; //以下为给表格中的单元格赋值 
for (i= 0;i<7;i++) 
{ 
with (myTable.Cell(1,i+1).Range) 
{ 
font.Size = 12; 
InsertAfter(aa); 
if (i==2){
	ColumnWidth =8
}else{
	ColumnWidth =4
}
} 
} 
for (n =0;n<7;n++) 
{ 
for (i =0;i<7 ;i++) 
{ 
with (myTable.Cell(i+2,n+1).Range) 
{font.Size = 12; 
InsertAfter("孟佳小可爱"); 
} 
} 
} 
row_count = 0; 
col_count = 0 
myDoc.Protect(1) 
}
function iniForm() {
	
	
	var iReportStatus="";
	var obj;
	
	ShowCurRecord(1);
	
	obj=document.getElementById("ReportStatus");
	if (obj) { iReportStatus=obj.value; }

	//条件 未审核
	var obj=document.getElementById("STatusIsNoAudit");
	if (obj && (iReportStatus.indexOf("NA^")>-1)) { obj.checked=true; }
	else{ obj.checked=false; }	
	if (""==iReportStatus) { obj.checked=true; }
	
	//条件 审核
	obj=document.getElementById("STatusIsCheched");
	if (obj && (iReportStatus.indexOf("Audited^")>-1)) { obj.checked=true; }
	else{ obj.checked=false; }

	//条件 打印
 	obj=document.getElementById("STatusIsPrint");
	if (obj && (iReportStatus.indexOf("PRINTED^")>-1)) { obj.checked=true; }
	else{ obj.checked=false; }
	
	//条件 发送
 	obj=document.getElementById("STatusIsSend");
	if (obj && (iReportStatus.indexOf("SEND^")>-1)) { obj.checked=true; }
	else{ obj.checked=false; }
	
	
	
}

function trim(s) {
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

function ExportGroupResult_click()
{
	var obj;
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintPositiveStatistic.xls';
	}else{
		alert("无效模板路径");
		return;
	}
    
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称
	
  	var obj=document.getElementById("GADM_DR");
	if (obj) var GADM=obj.value;
	var Ins=document.getElementById('GroupResultBox');
	if (Ins) { var encmeth=Ins.value; } 
	else { var encmeth=''; };
	
	var UserID=session['LOGON.USERID'];
	var flag=cspRunServerMethod(encmeth,GADM+"^"+UserID);
 	if (flag!=""){
	 	var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData","-2",UserID);
 		xlsheet.Range(xlsheet.Cells(1,1),xlsheet.Cells(1,(+Info))).mergecells=true;
 		xlsheet.cells(1,1).value = "团体结果导出";
        //xlApp.Selection.Merge();
        
        var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData","-1",UserID);
 		var Arr=Info.split("$");
 		var ArrLength=Arr.length;
 		
 		if ((ArrLength=="2")&&(Arr[1]=="")){
	 		alert("没有细项");
	 		return false;
 		}

 		var Merge=0;
 		for (var i=0;i<ArrLength;i++)
 		{
	 		var OneInfo=Arr[i];
	 		var OneArr=OneInfo.split("^");
	 		var Desc=OneArr[0];
	 		var MergeCount=OneArr[1];
	 		var StartCell=Merge+1;
	 		Merge=Merge+(+MergeCount);
	 		xlsheet.Range(xlsheet.Cells(2,StartCell),xlsheet.Cells(2,Merge)).mergecells=true;
 		
	 		//xlsheet.Range(xlsheet.cells(2,StartCell),xlsheet.cells(2,Merge)).select();
	 		//xlApp.Selection.HorizontalAlignment = 3;
        	xlsheet.cells(2,StartCell).value = Desc;
        	//xlApp.Selection.MergeCells = true;
		}
 		
        var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData","0",UserID);
 		var Arr=Info.split("^");
 		var ArrLength=Arr.length;
 		for (var i=0;i<ArrLength;i++)
 		{
	 		var OneInfo=Arr[i];
	 		xlsheet.cells(3,i+1).value = OneInfo;
        	
		}
         
 	}
 	var IADMInfo=flag.split("#");
 	var IADMLength=IADMInfo.length;
 	var GName=""
 	var ExprtProgress=document.getElementById("ExportProgress");
 	for (var i=0;i<IADMLength;i++)
 	{
	 	var PAADM=IADMInfo[i]
	 	var Info=tkMakeServerCall("web.DHCPE.Report.PositiveStatisticReport","GetGroupData",PAADM,UserID);
 		var Arr=Info.split("^");
 		var ArrLength=Arr.length;
 		for (var j=0;j<ArrLength;j++)
 		{
	 		var OneInfo=Arr[j];
	 		xlsheet.cells(4+i,j+1).value = OneInfo;
        	
		}
		if (ExprtProgress) ExprtProgress.value="共"+(IADMLength+1)+"个,第"+(i+1)+"个"
	}
    /*
    var fdir="d:\\导出结果"
    var fso = new ActiveXObject("Scripting.FileSystemObject");
	if(!fso.FolderExists(fdir)){
		fso.CreateFolder(fdir);
	}
	*/
	xlsheet.SaveAs("d:\\团体结果汇总.xls");
    xlApp.Visible = true;
    xlApp.UserControl = true;
	xlsheet=null;
	xlApp=null;
	
	
}

function BSend_click() {

	var iGADMDR='';
	var iReceiveType="G"; //DHC_PE_SendMessage.{ SM_ReceiveType }接收方类型
	var iSendType="ReportComplete"; 
	
	//报告编码	
	obj=document.getElementById("GADM_DR");  
	if (obj) { iGADMDR=obj.value; }


	var lnk='websys.default.csp?WEBSYS.TCOMPONENT='+'DHCPESendMessage'
			+"&ReceiveID="+iGADMDR
			+"&SMSType="+iSendType
			+"&ReceiveType="+iReceiveType
			;

	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=680,height=400,left=150,top=150';
	window.open(lnk,"_blank",nwin);
	
}
function CancelAudit_click()
{
	obj=document.getElementById("GADM_DR");
	if (obj) var GADM=obj.value;
	obj=document.getElementById("AuditBox");
	if (obj) var encmeth=obj.value;
	var flag=cspRunServerMethod(encmeth,GADM,"Cancel");
	if (flag==0)
	{
		location.reload();
	}
	else(alert(t["02"]+":"+flag))
	return false;
}
// *****************************************************
// 报告状态设置 
function Update_click(){
	 
	var iRowId=""
	var iUserUpdateDR="", iDateUpdate="",iStatus="";
	var obj;

	//灰化状态?退出
	var eSrc=window.event.srcElement;
	if (eSrc.disabled) { return false; }
	
	//报告编码	
	obj=document.getElementById("RowId");  
	if (obj) { iRowId=obj.value; }

	//用户编码	取网页上的(会话 session )用户编码 
	iUserUpdateDR=session['LOGON.USERID'];
  	
  	//取服务器时间
  	iDateUpdate="";
  	if ("BAudit"==eSrc.id) { iStatus="A"; }
  	if ("BPrint"==eSrc.id) { iStatus="P"; }
  	if ("BSend"==eSrc.id) { iStatus="S"; }
  	if ("BSendSMS"==eSrc.id) { iStatus="S"; }
  	
	//输入数据验证
 	if ((""==iRowId)||(""==iStatus)){
		//alert("Please entry all information.");
		alert(t['01']);
		return false
	}  

	var Instring=trim(iRowId)
			+"^"+trim(iStatus)
			+"^"+trim(iUserUpdateDR)
			+"^"+trim(iDateUpdate)
			;
	
	var Ins=document.getElementById('ClassBox');
	if (Ins) { var encmeth=Ins.value; } 
	else { var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring);

 	if ('0'==flag) {}
	else{
		//alert("Insert error.ErrNo="+flag)
		alert(t['02']+flag);
	}
	
	if ("P"==iStatus) {
		NewPrint();
		//ShowPrintWindows()
		return true;
	}	
	
	
	location.reload(); 
}
function NewPrint()
{
	var DealWord;
    var tkclass="web.DHCPE.GroupReportNew"
    var iGADMDR="";
    obj=document.getElementById("GADM_DR");
	if (obj){ iGADMDR=obj.value; }
    
	var ret=tkMakeServerCall(tkclass,"GetGroupInfo",iGADMDR);
	DealWord= new ActiveXObject("WordSet.DealWord");
	DealWord.CreateNewWordApp("C:\\DHCPEGroupReport.doc");
	//书签内容
	var ret=tkMakeServerCall(tkclass,"GetBaseInfo");
	var Arr=ret.split(Char_2)
	for (var i=0;i<Arr.length;i++)
	{
		var OneInfo=Arr[i];
		var OneArr=OneInfo.split(Char_1);
		DealWord.SetTextValue(OneArr[0],OneArr[1]);
	}
    //第一个表格
    var TableIndex=1;
    var ret=tkMakeServerCall(tkclass,"GetSexAgeCount");
    var TableRet=Char_2+ret;
    
	DealWord.SetTableValue(TableRet,TableIndex);
	var ChartRet=""+Char_1+"男"+Char_1+"女"
	var Arr=ret.split(Char_2)
	for (var i=0;i<Arr.length;i++)
	{
		var OneInfo=Arr[i];
		var OneArr=OneInfo.split(Char_1);
		var ChartRet=ChartRet+Char_2+OneArr[0]+Char_1+OneArr[1]+Char_1+OneArr[3]
	}
	//数据、第几个表格、图表名称、图表类型、图表上是否显示数值（2显示 1不显示）
    DealWord.SetChart(ChartRet, TableIndex, "各年龄组性别分布情况", 51,2);
    //第二个表格
	TableIndex=TableIndex+1;
	var ret=tkMakeServerCall(tkclass,"GetILLInfo");
	var TableRet=Char_2+ret;
	DealWord.SetTableValue(TableRet,TableIndex);
	var ChartRet=""+Char_1+"疾病"
	var Arr=ret.split(Char_2)
	for (var i=0;i<Arr.length;i++)
	{
		var OneInfo=Arr[i];
		var OneArr=OneInfo.split(Char_1);
		var ChartRet=ChartRet+Char_2+OneArr[0]+Char_1+OneArr[1];
	}
    //数据、第几个表格、图表名称、图表类型、图表上是否显示数值（2显示 1不显示）
    DealWord.SetChart(ChartRet, TableIndex, "异常指标检出率", 51,2);
	//第三个表格
	TableIndex=TableIndex+1;
	var ret=tkMakeServerCall(tkclass,"GetILLHistoryInfo");
	var TableRet=Char_2+ret;
	DealWord.SetTableValue(TableRet,TableIndex);
	var ChartRet=""+Char_1+"本次"+Char_1+"上次"+Char_1+"再上次"
	var Arr=ret.split(Char_2)
	for (var i=0;i<Arr.length;i++)
	{
		var OneInfo=Arr[i];
		var OneArr=OneInfo.split(Char_1);
		var ChartRet=ChartRet+Char_2+OneArr[0]+Char_1+OneArr[2]+Char_1+OneArr[4]+Char_1+OneArr[6];
	}
    //数据、第几个表格、图表名称、图表类型、图表上是否显示数值（2显示 1不显示）
    DealWord.SetChart(ChartRet, TableIndex, "历史数据比较", 51,1);
	//第四个表格
	TableIndex=TableIndex+1;
	var ret=tkMakeServerCall(tkclass,"GetILLAgeSexMax");
	var TableRet=Char_2+ret;
	DealWord.SetTableValue(TableRet,TableIndex);
	//疾病分类解释
	var ret=tkMakeServerCall(tkclass,"GetAllILL");
	var ILLArr=ret.split("^");
	for (var i=0;i<ILLArr.length;i++)
	{
		var OneILL=ILLArr[i];
		TableIndex=TableIndex+1;
		var ret=tkMakeServerCall(tkclass,"GetOneILLInfo",OneILL);
		DealWord.SetTableValue(ret,TableIndex);
		var Arr=ret.split(Char_2)
		var SexFlag=Arr[0];
		if (SexFlag=="N"){
			var ChartRet=""+Char_1+"男"+Char_1+"女"
		}else{
			var ChartRet=""+Char_1+"人数"
		}
		for (var j=1;j<Arr.length;j++)
		{
			var OneInfo=Arr[j];
			var OneArr=OneInfo.split(Char_1);
			if (SexFlag=="N"){
				var ChartRet=ChartRet+Char_2+OneArr[0]+Char_1+OneArr[1]+Char_1+OneArr[3];	
			}else{
				var ChartRet=ChartRet+Char_2+OneArr[0]+Char_1+OneArr[1];
			}
		}
		//数据、第几个表格、图表名称、图表类型、图表上是否显示数值（2显示 1不显示）
		DealWord.SetChart(ChartRet, TableIndex,"",51,2);
	}
	DealWord.SaveWordDoc("D:\\bb.doc");
	DealWord.CloseWordApp();
    return false;
}
function SetStyle(obj,Status) {
	if ("H"==Status){ 
		obj.disabled=true;
	   obj.style.color = "gray";
	}
	else{ 
		obj.disabled=false;
	 	obj.style.color = "blue";
	}	
}

//根据当前患者的状态?显示可以进行的操作
function SetUpdateStatus(aStatus){
	var obj;
	obj=document.getElementById("BAudit");
	if (obj) { SetStyle(obj,"H"); }
	obj=document.getElementById("BPrint");
	if (obj) { SetStyle(obj,"H"); }
	obj=document.getElementById("BSend");
	if (obj) { SetStyle(obj,"H"); }
	obj=document.getElementById("BSendSMS");
	if (obj) { SetStyle(obj,"H"); }
	obj=document.getElementById("BGDiagnosis");
	if (obj) { SetStyle(obj,"H"); }
	
	
	
	obj=document.getElementById("BGDiagnosis");
	if (("NA"==aStatus)) { 
		if (obj) { SetStyle(obj,"V"); }
		return true;
	}
	obj=document.getElementById("BAudit");
	if (("NA"!=aStatus)) { 
		if (obj) { SetStyle(obj,"V"); }
	}
	obj=document.getElementById("BPrint");
	if (("A"==aStatus)||("P"==aStatus)||("S"==aStatus)) {
		if (obj) { SetStyle(obj,"V"); }
	}

	obj=document.getElementById("BSend");
	if (("P"==aStatus)||("S"==aStatus)) { 
		if (obj) { SetStyle(obj,"V"); }
	}
	
	obj=document.getElementById("BSendSMS");
	if (("P"==aStatus)||("S"==aStatus)) {
		if (obj) { SetStyle(obj,"V"); }
	}
	
}

///////////////////////////////////////////////////////////////////////
//获取单位信息 单位名称
function SearchDHCPEGBaseInfo(value) {
	var aiList=value.split("^");
	if (""==value){return false}
	else{
		var obj;
		obj=document.getElementById("GDesc");
		if (obj) { obj.value=aiList[0]; }
		
		//obj=document.getElementById("GDR");
		//if (obj) { obj.value=aiList[2]; }
	}	
}

//获取操作用户信息 用户名称?
function SearchSSUSR(value) {
	var aiList=value.split("^");
	if (""==value){return false}
	else{
		var obj;
		
		obj=document.getElementById("AduitUserName");
		if (obj) { obj.value=aiList[0]; }
		
		obj=document.getElementById("AduitUser");
		if (obj) { obj.value=aiList[1]; }
	}	
}

// *************************************************************
/// //////		根据指定的组合条件 显示符合条件团体人员的报告情况	////////
///web.DHCPE.DHCPEGAdm	bGADMQuery
function BQuery_click() {
	var iGDesc="";				//单位编码
	var iAduitUser="";		//审核人
	var iReportStatus="";	//默认显示未审核	
	var iDateFrom="",iDateTo="";
	var obj;
	
  	obj=document.getElementById("GDesc");
    if (obj){ iGDesc=obj.value; }	
    
	obj=document.getElementById("AduitUser");
	if (obj){ iAduitUser=obj.value; }

	obj=document.getElementById("DateFrom");
	if (obj){ iDateFrom=obj.value; }


 	obj=document.getElementById("DateTo");
	if (obj){ iDateTo=obj.value; }

 	obj=document.getElementById("STatusIsNoAudit");
	if ((obj)&&(true==obj.checked)) { iReportStatus=iReportStatus+"^"+"NA"+"^"+"NoAudit"+"^"+"UNCHECKED"+"^"; }

 	obj=document.getElementById("STatusIsCheched");
	if ((obj)&&(true==obj.checked)) {  iReportStatus=iReportStatus+"Audited"+"^"+"A"+"^"+"CHECKED"+"^"; }
	
 	obj=document.getElementById("STatusIsPrint");
	if ((obj)&&(true==obj.checked)) {  iReportStatus=iReportStatus+"PRINTED"+"^"+"P"+"^"; }

 	obj=document.getElementById("STatusIsSend");
	if ((obj)&&(true==obj.checked)) {  iReportStatus=iReportStatus+"SEND"+"^"+"S"+"^"; }

	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEGReport"
			+"&GDesc="+iGDesc
			+"&AduitUser="+iAduitUser
			+"&DateFrom="+iDateFrom
			+"&DateTo="+iDateTo
			+"&ReportStatus="+iReportStatus
			;
    location.href=lnk; 

}


function Clear_click() {
	var obj;
	
  	obj=document.getElementById("GDesc");
    if (obj) { obj.value=""; }
    
	obj=document.getElementById("AduitUserName");
	if (obj) { obj.value=""; }

	obj=document.getElementById("AduitUser");
	if (obj) { obj.value=""; }

	obj=document.getElementById("DateFrom");
	if (obj) { obj.value=""; }


 	obj=document.getElementById("DateTo");
	if (obj) { obj.value=""; }
	
	//报告状态
 	obj=document.getElementById("ReportStatus");
	if (obj) { obj.value=""; }
	
 		obj=document.getElementById("STatusIsNoAudit");
		if (obj) { obj.checked=true; }
		
 		obj=document.getElementById("STatusIsCheched");
		if (obj) { obj.checked=false; }
 		
 		obj=document.getElementById("STatusIsPrint");
		if (obj) { obj.checked=false; }
 		
 		obj=document.getElementById("STatusIsSend");
		if (obj) { obj.checked=false; }


}
// 
function PrintTest() {
	
	ShowPrintWindows()
		return true;
	
	var IsPrintView=true;
	var ISPrintTitle=false;
	var iGADMDR="";	 	
	var obj;

	//obj=document.getElementById("GADMDR");
	//if (obj) { iGADMDR=obj.value; }
	
	//alert("PrintTest Begin");
	
	try {	
		var ReportDll = new ActiveXObject("GReportPrintDll.CPrint");
		ReportDll.printreport(0,IsPrintView,1,ISPrintTitle);
	}
	catch (e) {
		alert(unescape(t['XLAYOUTERR']));
	}
	
	//alert("PrintTest End");
	
}

function ShowPrintWindows() {

	var iGADMDR="",iGADMDRName="";
	
	obj=document.getElementById("GADM_DR");
	if (obj){ iGADMDR=obj.value; }

	obj=document.getElementById("GADM_DR_Name");
	if (obj){ iGADMDRName=obj.value; }
		
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPECallGRpt"
			+"&GADMDR="+iGADMDR
			+"&GADMDRName="+iGADMDRName
			;
			
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=400,height=300,left=100,top=100';

	window.open(lnk,"_blank",nwin)	

}
// *******************************************************
//以便本页面的子页面有正确的传入参数
function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;

	SelRowObj=document.getElementById('RPT_RowId'+'z'+selectrow);
	obj=document.getElementById("RowId");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }	

	SelRowObj=document.getElementById('RPT_GADM_DR'+'z'+selectrow);
	obj=document.getElementById("GADM_DR");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }
	
	SelRowObj=document.getElementById('RPT_GADM_DR_Name'+'z'+selectrow);
	obj=document.getElementById("GADM_DR_Name");
	if (SelRowObj && obj) { obj.value=SelRowObj.innerText; }	

	SelRowObj=document.getElementById('RPT_Status'+'z'+selectrow);
	obj=document.getElementById("Status");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.value); }
	
	SetUpdateStatus(obj.value);

}
function GDiagnosis_click()
{
	var iGADMDR="";
	obj=document.getElementById("GADM_DR");
	if (obj){ iGADMDR=obj.value; }
	
	
	
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no'
			//+',FullScreen=yes';
			+',left=0'
			+',top=0'
			+',width='+window.screen.availWidth
			+',height='+window.screen.availHeight
			;
	var lnk='dhcpegdiagnosis.csp'+"?GID="+iGADMDR;
	open(lnk,"_blank",nwin);
		
}
function SelectRowHandler() {

	var eSrc=window.event.srcElement;

	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById(tForm);	
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	if (selectrow==CurrentSel) {
		CurrentSel=0
		return;
	}

	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}


function ExportGroupILLInfo_click()
{  
   
	var obj;
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEGroupIllGather.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称
	

    var obj=document.getElementById("GADM_DR");
    if(obj)  {var PGADMDR=obj.value;} 
    var obj=document.getElementById("GADM_DR_Name");
    if(obj)  {var PGADMName=obj.value;} 
    
    if ((""==PGADMDR)){
		alert(t['03']);
		return false;	}
    

  
    var obj=document.getElementById("DateBox");
    if (obj) {var encmeth=obj.value} else{var encmeth=""}
    var value=cspRunServerMethod(encmeth,PGADMDR);
   
    var str=value; //[0]
    //alert(str)
	var temprow=str.split("^");
    var k=1; 
    var tmp=0
   
  
   xlsheet.cells(1,1)=PGADMName+"体检疾病汇总"
   encmeth=document.getElementById("GetGPatInfoBox").value;
 
   
         
	for(i=0;i<=(temprow.length-1);i++)
	{  
	    var row=cspRunServerMethod(encmeth,temprow[i]);
	    
		var tempcol=row.split("^");
	    
		Position=tempcol[6];
	 
		//本次组rowid不等于上次组rowid并且不是第一组时则行加2
		if((Position != tmp))
		
		{ 
		 
		    count=0;
			k=k+1;
			xlsheet.Rows(k+1).insert();
			k=k+1;
			xlsheet.Rows(k+1).insert(); 
			xlsheet.cells(k-1,1)=tempcol[6]; //写组名
			xlsheet.cells(k,1)="序号"
			xlsheet.cells(k,2)="体检日期" 
			xlsheet.cells(k,3)="姓名" 
			xlsheet.cells(k,4)="性别"
			xlsheet.cells(k,5)="年龄"
			xlsheet.cells(k,6)="疾病汇总"
			//var Range=xlsheet.Cells(k-1,1);
	        xlsheet.Range(xlsheet.Cells(k-1,1),xlsheet.Cells(k-1,6)).mergecells=true; //合并单元格
			xlsheet.Rows(k-1).Font.Name = "黑体"
			

			
			xlsheet.Columns(1).NumberFormatLocal="@";  //设置登记号为文本型 
			xlsheet.Columns(2).NumberFormatLocal="@"; 
			xlsheet.Columns(5).NumberFormatLocal="@";
		                          
		}
		
	     count=count+1
		 xlsheet.Rows(k+1).insert()
		
		//循环列
		for(j=0;j<=tempcol.length-2;j++)
			{    
				xlsheet.cells(k+1,j+1).Value=tempcol[j];	
			}
       xlsheet.cells(k+1,1).Value=count	
	   tmp=Position;   //将本次组rowid赋给一个临时变量?待与下次取得的组rowid比较
	   k=k+1;
	 
	  
	}
///删除最后的空行
//xlsheet.Rows(k+1).Delete;
///删除最后的空行
//xlsheet.Rows(k+1).Delete;
///删除最后的空行
//xlsheet.Rows(k+1).Delete;
///删除最后的空行
//xlsheet.Rows(k+1).Delete;
	//xlsheet.printout;
	xlsheet.SaveAs("d:\\团体疾病汇总.xls");
	//xlBook.Close (savechanges=false);
	//xlApp=null;
	//xlsheet=null;
   xlApp.Visible = true;
   xlApp.UserControl = true;
 

}
 function ExportGroupAbnormity_click()
{	
	var obj;
	
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEGroupAbnormity.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称
	var obj=document.getElementById("GADM_DR");
    if(obj)  {var PGADMDR=obj.value;} 
    var obj=document.getElementById("GADM_DR_Name");
    if(obj)  {var PGADMName=obj.value;} 
    
    if ((""==PGADMDR)){
		alert(t['03']);
		return false;	}
    
  
    var obj=document.getElementById("DateBox");
    if (obj) {var encmeth=obj.value} else{var encmeth=""}
    var iadms=cspRunServerMethod(encmeth,PGADMDR);
  	var obj=document.getElementById("GetResultBox");
  	if (obj){var encmeth1=obj.value}
	else{var encmeth1=""}
	var StationID="";
	var obj=document.getElementById("StationID");
	if (obj) StationID=obj.value;
    var patInfo=cspRunServerMethod(encmeth1,iadms,StationID);
	var patArray=patInfo.split("&");
	Array.prototype.name="";
	var array=new Array;  //其元素为数组对象,用于按部门存放人员信息,每个数组元素对应一个部门
	
	/*以下循环是对服务器传来的数据按部门分类存放处理*/
	for(var i=0;i<patArray.length;i++)
	{
		if(i==0)
		{
			var arr=new Array(patArray[0]);
			arr.name=patArray[0].split('$')[0].split('^')[2]; //指定数组name属性为部门名称
			array.push(arr);
			continue;
		}
		for(var j=0;j<array.length;j++)  
		{
			if(array[j].name==patArray[i].split('$')[0].split('^')[2])  //array数组中若已有此部门,则人员信息添加到此部门中
			{
				array[j].push(patArray[i]);
				break;
			}
			if(j==(array.length-1)) //array中无此部门,则添加
			{
				var arr=new Array(patArray[i]);
				arr.name=patArray[i].split('$')[0].split('^')[2];
				array.push(arr);
			}
		}
	}
	
	var k=1;
	xlsheet.cells(k,1)=PGADMName+"异常值汇总";
	xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,5)).mergecells=true;
	xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,5)).HorizontalAlignment= -4108;
	xlsheet.Rows(k).Font.Name = "黑体";
	xlsheet.Columns(1).NumberFormatLocal="@";
	/*以下循环将数据按格式导出到Excel*/
	for(var i=0;i<array.length;i++)
	{
		k+=2;		
		xlsheet.cells(k,1)=array[i].name;
		xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,5)).HorizontalAlignment= -4108;
		xlsheet.Range(xlsheet.Cells(k,1),xlsheet.Cells(k,5)).mergecells=true;
		xlsheet.Rows(k).Font.Name = "黑体";
		for(var j=0;j<array[i].length;j++)
		{
			k+=2;
			xlsheet.Cells(k,1)="登记号:"+array[i][j].split('$')[0].split('^')[0];  //登记号
			xlsheet.Cells(k,2)="姓名:"+array[i][j].split('$')[0].split('^')[1];  //姓名
			xlsheet.Rows(k).Font.Name = "黑体";
			k+=1
			xlsheet.Cells(k,1)="医嘱名称";
			xlsheet.Cells(k,2)="细项名称";
			xlsheet.Cells(k,5)="检查结果";
			for(var m=1;m<array[i][j].split('$').length;m++)
			{
				
			
				k+=1;
				
				xlsheet.Cells(k,1)=array[i][j].split('$')[m].split('^')[0];
				xlsheet.Cells(k,2)=array[i][j].split('$')[m].split('^')[1];
				xlsheet.Cells(k,5)=array[i][j].split('$')[m].split('^')[2];
			
			}
		}
	}
	xlsheet.SaveAs("d:\\团体异常值汇总.xls");
	//xlBook.Close (savechanges=false);
	//xlApp=null;
	//xlsheet=null;
    xlApp.Visible = true;
    xlApp.UserControl = true;
}
/*
function ExportGroupAbnormity_click()
{  
    try{
	var obj;
	var currow=2;
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEGroupAbnormity.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称
	

    var obj=document.getElementById("GADM_DR");
    if(obj)  {var PGADMDR=obj.value;} 
 
    
    if ((""==PGADMDR)){
		alert(t['03']);
		return false;	}
    
  
  
    var obj=document.getElementById("GetPatInfo");
    if (obj) {var encmeth=obj.value} else{var encmeth=""}
    var value=cspRunServerMethod(encmeth,PGADMDR);
    var InfoStr=value.split(";")
    var str=InfoStr[0];
    var PGADMName=InfoStr[1];
    var TName=InfoStr[2],TPosition=InfoStr[3],TNotNormal=InfoStr[4],TRange=InfoStr[5];
	var temprow=str.split("^");
   
   xlsheet.cells(1,7)=PGADMName
   xlsheet.Rows(1).Font.Name = "黑体"; 
   //xlsheet.Rows(1).mergecells=true; //合并单元格
   var encmeth=document.getElementById("GetItemData").value;
 
        
	for(i=0;i<=(temprow.length-1);i++)
	{                      //序号
	    xlsheet.cells(currow,1)=temprow[i];
	    xlsheet.Rows(currow).Font.Name = "黑体";
	    xlsheet.Rows(currow).mergecells=true;
	    //xlsheet.Rows(currow,1).Font.ColorIndex = 3;
	   
	    currow=currow+1;
	 
	    var row=cspRunServerMethod(encmeth,temprow[i]);
	    var ItemStr="",ItemNameStr="";
		var TotalStr=row.split("^");
		for(var h=0;h<TotalStr.length;h++)
		{ 
		
			if(ItemStr=="") ItemStr=TotalStr[h].split("!")[0];
			else ItemStr=ItemStr+"^"+TotalStr[h].split("!")[0];
			if(ItemNameStr=="") ItemNameStr=TotalStr[h].split("!")[1];
			else ItemNameStr=ItemNameStr+"^"+TotalStr[h].split("!")[1];
		}
		
		 for(var j=0;j<ItemNameStr.split("^").length;j++)
		 {
			xlsheet.cells(currow,(j+1)*2)=ItemNameStr.split("^")[j];
		    xlsheet.Rows(currow).Font.Name = "黑体"; 
		    xlsheet.Rows(currow).HorizontalAlignment =-4108
		    xlsheet.Range(xlsheet.Cells(currow,(j+1)*2),xlsheet.Cells(currow,(j+1)*2+1)).mergecells=true
			xlsheet.Range(xlsheet.Cells(currow,(j+1)*2),xlsheet.Cells(currow,(j+1)*2+1)).HorizontalAlignment =-4108;//居中
			xlsheet.cells(currow+1,1)=TName;
			xlsheet.cells(currow+1,1).Font.Name = "黑体"; 
			xlsheet.Range(xlsheet.Cells(currow,1),xlsheet.Cells(currow+1,1)).mergecells=true
			xlsheet.cells(currow+1,(j+1)*2)="不正常值";
			xlsheet.cells(currow+1,(j+1)*2+1)="正常值";
			xlsheet.Range(xlsheet.Cells(currow+1,(j+1)*2),xlsheet.Cells(currow+1,(j+1)*2+1)).HorizontalAlignment =-4108;//居中
		 }
		  currow=currow+2;
		  var GetPositionIAdm=document.getElementById("GetPositionIAdm").value;
		  var AllPat=cspRunServerMethod(GetPositionIAdm,temprow[i]);
		  
		  var Person=AllPat.split("^");
		  var iloop=Person.length;
		  var PersonCurrCol=0;PersonCurrRow=0;
		  var array=new Array();
		  var AbnormityCount=0
		  var ItemStrTmp=ItemStr.split("^");
		  for(var n=0;n<ItemStrTmp.length;n++)  //医嘱
		  {
			  PersonCurrCol=(n+1)*2;
			  PersonCurrRow=currow;
		     for(k=0;k<iloop;k++)     //人
		     {
			    var GetIAdmRlt=document.getElementById("GetIAdmRlt").value; 
				var AbnormityData=cspRunServerMethod(GetIAdmRlt,ItemStrTmp[n],Person[k]);
		        if(AbnormityData=="")continue;
		        var ODInfo=AbnormityData.split("!");
             
		       xlsheet.cells(PersonCurrRow,1)=ODInfo[0].split("^")[2];
		      
		      
		        for(var m=0;m<ODInfo.length;m++)
		        {
			    
			       xlsheet.cells(PersonCurrRow+m,PersonCurrCol)=ODInfo[m].split("^")[0];
		           xlsheet.cells(PersonCurrRow+m,PersonCurrCol+1)=ODInfo[m].split("^")[1];

			    }
			    PersonCurrRow=PersonCurrRow+ODInfo.length;
			    
			    //取最大行?将最大行减ODInfo.length 所有单元格付空
			    var GetAbnormityData=document.getElementById("GetAbnormityData").value; 
		        AbnormityCount=cspRunServerMethod(GetAbnormityData,temprow[i],Person[k]);
		        for(var m=0;m<(parseInt(AbnormityCount)-ODInfo.length);m++)
		        {    
			        xlsheet.cells(PersonCurrRow+m,PersonCurrCol)="";
		            xlsheet.cells(PersonCurrRow+m,PersonCurrCol+1)="";
			    }
			    PersonCurrRow=PersonCurrRow+parseInt(AbnormityCount)-ODInfo.length;
			   // xlsheet.Range(xlsheet.Cells(PersonCurrRow-parseInt(AbnormityCount),1),xlsheet.Cells(PersonCurrRow,1)).mergecells=true
			 }
			 array[n]=PersonCurrRow-currow;
		  }
		  var MaxLength=0;
		  for(var L=0;L<array.length;L++)
		  {
			  
			  if(array[L]>MaxLength)MaxLength=array[L];
		  }
		  currow=currow+MaxLength+1;         //每次将最大的行赋给当前行?待循环到下一个部门的时候从当前行开始走
		  array=null;
		}	       
	
	//xlsheet.printout;
	xlsheet.SaveAs("d:\\团体异常值汇总.xls");
	//xlBook.Close (savechanges=false);
	//xlApp=null;
	//xlsheet=null;
   xlApp.Visible = true;
   xlApp.UserControl = true;
 
}
catch(e)
	{
		alert(e+"^"+e.message);
	}
}  
*/
 function PPUpdate_click() {
	var eSrc=window.event.srcElement;
	if (eSrc.disabled) { return false;}
	var iGADMDR="";
		
	var obj=document.getElementById("GADM_DR");
  
	if (obj) { iGADMDR=obj.value; }
	if (""==iGADMDR) { return false;}
	
   	var obj=document.getElementById("GADM_DR_Name");
	if (obj) { iGADMName=obj.value; }
 
	var lnk="dhcpepartprint.csp?"+"&GADMDR="+iGADMDR+"&GADMName="+iGADMName	

	var wwidth=800;
	var wheight=600;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	var cwin=window.open(lnk,"_blank",nwin)	
	return true;
}

function BExprtXRay_click()
{
	var obj;
	var Template="DHCPEXRayReport.xls";
	obj=document.getElementById("prnpath");
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+Template;
	}else{
		alert("无效模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("Sheet1");     //Excel下标的名称
	
	var obj=document.getElementById("GADM_DR");
    if(obj)  {var PGADMDR=obj.value;} 
    var obj=document.getElementById("GADM_DR_Name");
    if(obj)  {var PGADMName=obj.value;} 
    xlsheet.cells(2,3).value=PGADMName;
    if ((""==PGADMDR)){
		alert(t['03']);
		return false;	}
    var DepartName=""
	var obj=document.getElementById("DepartName");
    if (obj) {var DepartName=obj.value}
  
    var obj=document.getElementById("DateBox");
    if (obj) {var encmeth=obj.value} else{var encmeth=""}
    var value=cspRunServerMethod(encmeth,PGADMDR,DepartName);
   	var temprow=value.split("^");
	var Length=temprow.length
	for(j=0;j<Length;j++)
	{
		var IADM=temprow[j];
		var Data=tkMakeServerCall("web.DHCPE.Report.GroupIllGather","GetSpecialReportInfo",IADM,Template);
		if (Data=="") continue;
		var char_2=String.fromCharCode(2);
		var DataArr=Data.split("^");
			
		var DataLength=DataArr.length;
		var Row=5+j;
		xlsheet.Rows(Row+1).insert();
		xlsheet.cells(Row,1).value=j+1;
		for (i=0;i<DataLength;i++)
		{
			var OneInfo=DataArr[i];
			var OneArr=OneInfo.split(char_2);
			var Result=OneArr[1];
			var Position=OneArr[0];
			if (Position=="") continue;
			var PositionArr=Position.split(";");
			//var Row=+PositionArr[0];
			var Col=+PositionArr[1];
			//alert(Row+"^"+Col+Result)
			xlsheet.cells(Row,Col).value=Result;
		}
	}
	xlsheet.Rows(Row+1).Delete;
	var fdir="d:\\导出放射结果"
    var fso = new ActiveXObject("Scripting.FileSystemObject");
	if(!fso.FolderExists(fdir)){
		fso.CreateFolder(fdir);
	}
	var obj=document.getElementById("GADM_DR_Name");
    if(obj)  {var PGADMName=obj.value;} 
	xlsheet.SaveAs(fdir+"\\"+PGADMName+"放射.xls");
    xlApp.Visible = true;
    xlApp.UserControl = true;
	xlsheet=null;
	xlApp=null;
}

document.body.onload = BodyLoadHandler;
