var TFORM="tDHCPEIReportPHistory"
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("btnExport")
	if (obj) {obj.onclick=ExpPrtHistory;}
	obj=document.getElementById("btnPrint")
	if (obj) {obj.onclick=PrintPrtHistory;}
	
	//obj=document.getElementById("btnFind")
	//if (obj) {obj.onclick=FindPrtHistory;}
	obj=document.getElementById("ID")
	if (obj) {
		obj.onchange=FindPrtHistory;
		obj.onkeydown=IDKeyDown;
		}
		
	obj=document.getElementById("GroupDesc");
	if (obj) { obj.onchange=GroupDesc_Change; }	
}
function GroupDesc_Change()
{
	var obj=document.getElementById("GroupID");
	if (obj) { obj.value=""; }
	var obj=document.getElementById("GroupDesc");
	if (obj) { obj.value=""; }

}
function ExpPrtHistory()
{
	ExportPrtHistory(0)
}
function ExportPrtHistory(Prtflag)
{
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEIRptPrintHistory.xls'; // 模版文件
	}else{
		alert("无效模板路径");
		return;
	}
	objExcel= new DHCPEExcel(Templatefilepath, true);
	if (objExcel)
	{
		// 设置导出文件(另村文件名,标题)
		PrtHistoryFileChange(objExcel);
		//objExcel.xlApp.Visible = false;
		objExcel.xlApp.visible = true; //显示
		ImportPrtHiyDetail(objExcel);
		
		
		if (Prtflag==0){
			var IsPreview=false;
			/*
			objExcel.SaveTo('d:\\'+'已打报告客户'+'.xls');
			//var IsSave=false; // 
			//objExcel.Colse(IsSave);
			objExcel.xlApp.Visible= true;
   			objExcel.xlApp.UserControl = true;
			*/
		var IsSave=true; 
		objExcel.Colse(IsSave);
	    objExcel.xlApp.Quit();
	    objExcel.xlApp= null;

		}
		if (Prtflag==1){
			var IsPreview=false;
			objExcel.Print(IsPreview);
			var IsSave=false; // 
			objExcel.Colse(IsSave);
		}
		objExcel=null;
		}
	FRow=1;

}
function PrtHistoryFileChange(objExcel) {
	
	
	objExcel.GetSheet('Sheet1');
    
}
function ImportPrtHiyDetail(objExcel) {
	FExcel=objExcel
	var obj=document.getElementById("TPrintDatez1");
	var PrintDate="";
	if (obj) PrintDate=obj.value;
	WriteStrToExcel(PrintDate);
	var headStr=tkMakeServerCall("web.DHCPE.PrintIAdmInfo","GetIPrtIAdmInfoImport","Header",""); 
	WriteStrToExcel(headStr);
	var RowStr=tkMakeServerCall("web.DHCPE.PrintIAdmInfo","GetIPrtIAdmInfoImport","ColStr",""); 
   	if (""==RowStr) { return false; }
   	else {
	   	var row=RowStr.split("^")
	   	for (var i=0;i<row.length;i++){
	   		var RowStr=tkMakeServerCall("web.DHCPE.PrintIAdmInfo","GetIPrtIAdmInfoImport","RowStr",row[i],i); 
			WriteStrToExcel(RowStr)
	   	}
   	}
	
}
var FRow=1;
function WriteStrToExcel(Datas) {
	
	var DayDatas=Datas.split("^");
	var iCol=0,iRow=FRow;
	for (var iCol=1;iCol<=DayDatas.length;iCol++) {
		FExcel.writeData(iRow, iCol, DayDatas[iCol-1]);
		objExcel.Borders(iRow,iCol,'LEFT^'+'TOP^'+'BOTTOM^'+'RIGHT^')
	}
	FRow=FRow+1;
}
function PrintPrtHistory()
{
	ExportPrtHistory(1);
}
function IDKeyDown()
{
	var Key=websys_getKey(e);
	if ((13==Key)) {
	FindPrtHistory();
	}
}
function FindPrtHistory()
{
	var obj;
	var iID="";
	var iPDateFrom="";
	var iPDateTo="";
	var iGroupID=""
	var iTeamID=""
	var iDepartName=""
	
	obj=document.getElementById("TFORM");
	if (obj){ var tForm=obj.value; }
	else { return false; }
	
	obj=document.getElementById("ID");
	if (obj){ 
		iID=obj.value;
		if (iID.length<8 && iID.length>0) { iID=RegNoMask(iID); }
	}

	obj=document.getElementById("PDateFrom");
	if (obj){ iPDateFrom=obj.value; }

	obj=document.getElementById("PDateTo");
	if (obj){ iPDateTo=obj.value; }	

	obj=document.getElementById("GroupID");
	if (obj) iGroupID=obj.value;
	obj=document.getElementById("TeamID");
	if (obj) iTeamID=obj.value;
	obj=document.getElementById("VIPLevel");
	if (obj){ iVIP=obj.value; }
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+tForm
			+"&ID="+iID
			+"&PDateFrom="+iPDateFrom
			+"&PDateTo="+iPDateTo
			+"&GroupID="+iGroupID
			+"&TeamID="+iTeamID
			+"&VIPLevel="+iVIP
	;
	//alert(lnk)
	location.href=lnk;
}
function SelectGruop(value)
{
	if (value=="") return;
	var ValueArr=value.split("^");
	var obj=document.getElementById("GroupDesc");
	if (obj) obj.value=ValueArr[0];
	var obj=document.getElementById("GroupID");
	if (obj) obj.value=ValueArr[1];
}
function SelectTeam(value)
{
	if (value=="") return;
	var ValueArr=value.split("^");
	var obj=document.getElementById("TeamDesc");
	if (obj) obj.value=ValueArr[0];
	var obj=document.getElementById("TeamID");
	if (obj) obj.value=ValueArr[1];
}
document.body.onload = BodyLoadHandler;