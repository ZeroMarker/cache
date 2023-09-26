document.body.onload = BodyLoadHandler;

function BodyLoadHandler(){
	LoadProjectList();
}

function LoadProjectList(){
	var PPDesc=DHCC_GetElementData('PPDesc');
	if (document.getElementById('PPDesc')){
		var GetDefineDataStr=document.getElementById('GetProjectStr')
		if(GetDefineDataStr){
		//var encmeth=
		var PPDescStr=GetDefineDataStr.value
		combo_PPDesc=dhtmlXComboFromStr("PPDesc",PPDescStr);
		combo_PPDesc.enableFilteringMode(true);
		combo_PPDesc.selectHandle=combo_PPDescKeydownhandler;
		combo_PPDesc.setComboText(PPDesc)
		}
	}
	
	var obj=document.getElementById("Export");
	if (obj) obj.onclick=ExportClickHandler;
}
function combo_PPDescKeydownhandler(){
	var PPRowId=combo_PPDesc.getSelectedValue();
	DHCC_SetElementData('PPRowId',PPRowId);
}

function ExportClickHandler() {
	try {
		var GetPrescPath=document.getElementById("printpath");  //s val=##Class(%CSP.Page).Encrypt($lb("web.UDHCJFCOMMON.getpath"))
		if (GetPrescPath) {var encmeth=GetPrescPath.value} else {var encmeth=''};
		var TemplatePath="";
		if (encmeth!="") {
			TemplatePath=cspRunServerMethod(encmeth);
		}
		var PPRowId=combo_PPDesc.getSelectedValue();
		var StartScreenNo=DHCC_GetElementData("StartScreenNo");
		var EndScreenNo=DHCC_GetElementData("EndScreenNo");
		if (PPRowId=="") {
			alert("请选择临床试验项目");
			return;
		}
		if (StartScreenNo=="") {
			alert("请录入开始筛选号");
			return;
		}
		if (Trim(EndScreenNo)=="") EndScreenNo=StartScreenNo;

		var ExportMethod=DHCC_GetElementData("ExportMethod");
		var RtnStr=cspRunServerMethod(ExportMethod,PPRowId,StartScreenNo,EndScreenNo,session["LOGON.USERID"]);
		var Totle=0,Job="";
		if (RtnStr!=0) {
			Totle=RtnStr.split("@")[0];
			Job=RtnStr.split("@")[1];
		}
		if (parseFloat(Totle) < 1) {
			alert("没有可导出的记录.");
			return;
		}
		
		var xlApp,xlsheet,xlBook
    var Template=TemplatePath+"UDHCDocProExportLab.xlsx";
    
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Template);
    xlsheet = xlBook.ActiveSheet;
    xlsheet.PageSetup.LeftMargin=0;
    xlsheet.PageSetup.RightMargin=0;
    
		xlsheet.cells(3,1)="筛选号从"+StartScreenNo+"至"+EndScreenNo+"的病人检验结果记录";
		//alert(parseFloat(Totle))
		for (var i=1;i <= parseFloat(Totle);i++) {
			var ExportOneMethod=DHCC_GetElementData("ExportOneMethod");
			var LabResultStr=cspRunServerMethod(ExportOneMethod,session["LOGON.USERID"],Job,i);
			for (var j=0;j<LabResultStr.split("$").length;j++) {
				xlsheet.cells(i+5,j+1)=LabResultStr.split("$")[j];
			}
			
		}

    //xlsheet.save
    //xlBook.SaveAs("C:\\取消预约记录"+h+m+s+".xls");
    //xlBook.Close (savechanges=false);
    //xlApp.UserControl=true;
    //gridlist(xlsheet,6,xlsrow,2,13)
		var d=new Date();
		var h=d.getHours();
		var m=d.getMinutes();
		var s=d.getSeconds()

	    //alert("C:\\门诊医生日志"+h+m+s+".xls")
	    //xlsheet.save   //printout
	   
	    xlBook.SaveAs("E:\\检验结果记录"+h+m+s+".xlsx");   //lgl+
	    xlBook.Close (savechanges=false);
     alert("文件将保存在您的E盘根目录下");
    xlApp=null;
    xlBook=null;
    xlsheet.Quit;
    xlsheet=null;
	} catch(e) {
		alert(e.message);
	};
}