function IniMe()
{
	//alert('s')
	obj=document.getElementById("RegNo");
	if (obj) { obj.onkeydown=Reg_No_keydown; }	
	var obj=document.getElementById("StatusDR")
	if (obj){
		var SObj=document.getElementById("Status");
		if (SObj) SObj.value=obj.value;
	}
	var obj=document.getElementById("ItemDR")
	if (obj){
		var SObj=document.getElementById("Item");
		if (SObj) SObj.value=obj.value;
	}
	var obj=document.getElementById("StationID");
	if (obj) {var StationDesc=obj.value;}
	
	obj=document.getElementById("BOutPutToEXL");
	if (obj){obj.onclick=OutPut_click;}
	
	obj=document.getElementById("PreDate");
	if (obj) obj.onclick=PreDate_onclick;
	
	obj=document.getElementById("ExamDate");
	if (obj) obj.onclick=ExamDate_onclick
	
	websys_setfocus("RegNo");
	
}

function ArcimAfterSelect(value)
{
	
	if (value=="") return false;
	var Arr=value.split("^");
	SetValue("Item",Arr[1]);
	//SetValue("ItemDesc",Arr[0]);
	
}

function OutPut_click()
{
	var obj;
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+'DHCPEExportCommon.xls';
	var ExportName="DHCPESpecial"
	var obj=document.getElementById("GetExportInfo");
	if (obj) {var encmeth=obj.value} else{var encmeth=""}
	xlApp= new ActiveXObject("Excel.Application"); //固定
	xlApp.UserControl = true;
    xlApp.visible = true; //显示
	xlBook= xlApp.Workbooks.Add(Templatefilepath); //固定
	xlsheet= xlBook.WorkSheets("Sheet1"); //Excel下标的名称
	var Info=cspRunServerMethod(encmeth,"",ExportName);
	
	var Row=1;
	while (Info!="")
	{
		var DataArr=Info.split("^");
		var DataLength=DataArr.length;
		for (i=1;i<DataLength;i++)
		{
			xlsheet.cells(Row,i).value=DataArr[i];
		}
		var Sort=DataArr[0];
		if (Sort=="") break;
		Row=Row+1;
		Info=cspRunServerMethod(encmeth,Sort,ExportName);
	}
	/*
	xlsheet.SaveAs("d:\\"+ExportName+".xls");	
	xlApp.Visible= true;
	xlApp.UserControl= true;
	*/
	xlBook.Close(savechanges = true);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;

}

function OutPussst_click()
{
	
	var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	var Templatefilepath=prnpath+"DHCPESpecialInfo.xlsx";
	
	var obj,StartDate="",EndDate="";
	obj=document.getElementById("StartDate");
	if (obj) StartDate=obj.value;
	obj=document.getElementById("EndDate");
	if (obj) EndDate=obj.value;
	obj=document.getElementById("ItemDR");
	if (obj) var ItemDR=obj.value;
	obj=document.getElementById("PreDate");
	if (obj) var PreDate=obj.value;
	obj=document.getElementById("RegNo");
	if (obj) var RegNo=obj.value;
	obj=document.getElementById("ShowCollect");
	if (obj) var ShowCollect=obj.value;
	obj=document.getElementById("StationDesc");
	if (obj) var StationDesc=obj.value;
	obj=document.getElementById("StatusDR");
	if (obj) var StatusDR=obj.value;
	obj=document.getElementById("VIPLevel");
	if (obj) var VIPLevel=obj.value;
	
	var info=tkMakeServerCall("web.DHCPE.FetchReport","OutPutSpecial",StartDate,EndDate,ItemDR,StatusDR,ShowCollect,PreDate,VIPLevel,RegNo,StationDesc);
	alert(info)
	
}

function Reg_No_keydown(e){
	
	var Key=websys_getKey(e);
	if(Key!=13) return;
	var Obj=document.getElementById("RegNo");
	if (Obj) CurRegNo=Obj.value;
	if(CurRegNo=="") {
		alert("登记号不能为空");
		return;
		}
	var Status=tkMakeServerCall("web.DHCPE.PreIADM","GetStatusByRegNo",CurRegNo);
	if(Status=="REGISTERED"){
		var url="dhcpecustomconfirmbox.csp?Type=Arrived";   
  		var  iWidth=300; //模态窗口宽度
  		var  iHeight=130;//模态窗口高度
  		var  iTop=(window.screen.height-iHeight)/2;
  		var  iLeft=(window.screen.width-iWidth)/2;
  		var dialog=window.showModalDialog(url, CurRegNo, "dialogwidth:300px;dialogheight:130px;center:1"); 
		//alert(dialog)
 		if(dialog){
			var PIADM=tkMakeServerCall("web.DHCPE.PreIADM","GetPIADMByRegNo",CurRegNo);
			if(PIADM==""){return false}
			var ArriveFlag=tkMakeServerCall("web.DHCPE.DHCPEIAdm","UpdateIADMInfo",PIADM,"3");
			if(ArriveFlag!="0"){alert("到达失败")}
		}
	}
	//var Key=websys_getKey(e);
	BFind_click();
}

function CompleteItem()
{
	var eSrc = window.event.srcElement;
	UpdateComplete(eSrc.id,"1");
}
function UnCompleteItem()
{
	var eSrc = window.event.srcElement;
	UpdateComplete(eSrc.id,"0");
}
function UpdateComplete(OEID,Type)
{
	var encmeth="",Date="";
	var obj=document.getElementById("CompleteClass");
	if (obj) encmeth=obj.value;
	var obj=document.getElementById("D"+OEID);
	if (obj) Date=obj.value;
	//alert(OEID+"^"+Date)
	//alert(Type)
	var ret=cspRunServerMethod(encmeth,OEID+"^"+Date,Type);
	if (ret!=""){
		alert(ret);
		return false;
	}
	BFind_click();
}
function ReportItem()
{
	var eSrc = window.event.srcElement;
	UpdateReport(eSrc.id,"1");
}
function UnReportItem()
{
	var eSrc = window.event.srcElement;
	UpdateReport(eSrc.id,"0");
}
function UpdateReport(OEID,Type)
{
	var encmeth="",Date="";
	var obj=document.getElementById("ReportClass");
	if (obj) encmeth=obj.value;
	var obj=document.getElementById("R"+OEID);
	if (obj) Date=obj.value;
	var ret=cspRunServerMethod(encmeth,OEID+"^"+Date,Type);
	if (ret!=""){
		alert(ret);
		return false;
	}
	BFind_click();
}
function PreDate_onclick(){
	objPreDate=document.getElementById("PreDate");
	objExamDate=document.getElementById("ExamDate");
	if (objPreDate.checked){
		objExamDate.checked=false;
	}
}

function ExamDate_onclick(){
	objPreDate=document.getElementById("PreDate");
	objExamDate=document.getElementById("ExamDate");
	if (objExamDate.checked){
		objPreDate.checked=false;
	}
}

document.body.onload = IniMe;