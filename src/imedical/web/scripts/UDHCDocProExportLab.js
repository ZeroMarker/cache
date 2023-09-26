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
			alert("��ѡ���ٴ�������Ŀ");
			return;
		}
		if (StartScreenNo=="") {
			alert("��¼�뿪ʼɸѡ��");
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
			alert("û�пɵ����ļ�¼.");
			return;
		}
		
		var xlApp,xlsheet,xlBook
    var Template=TemplatePath+"UDHCDocProExportLab.xlsx";
    
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Template);
    xlsheet = xlBook.ActiveSheet;
    xlsheet.PageSetup.LeftMargin=0;
    xlsheet.PageSetup.RightMargin=0;
    
		xlsheet.cells(3,1)="ɸѡ�Ŵ�"+StartScreenNo+"��"+EndScreenNo+"�Ĳ��˼�������¼";
		//alert(parseFloat(Totle))
		for (var i=1;i <= parseFloat(Totle);i++) {
			var ExportOneMethod=DHCC_GetElementData("ExportOneMethod");
			var LabResultStr=cspRunServerMethod(ExportOneMethod,session["LOGON.USERID"],Job,i);
			for (var j=0;j<LabResultStr.split("$").length;j++) {
				xlsheet.cells(i+5,j+1)=LabResultStr.split("$")[j];
			}
			
		}

    //xlsheet.save
    //xlBook.SaveAs("C:\\ȡ��ԤԼ��¼"+h+m+s+".xls");
    //xlBook.Close (savechanges=false);
    //xlApp.UserControl=true;
    //gridlist(xlsheet,6,xlsrow,2,13)
		var d=new Date();
		var h=d.getHours();
		var m=d.getMinutes();
		var s=d.getSeconds()

	    //alert("C:\\����ҽ����־"+h+m+s+".xls")
	    //xlsheet.save   //printout
	   
	    xlBook.SaveAs("E:\\��������¼"+h+m+s+".xlsx");   //lgl+
	    xlBook.Close (savechanges=false);
     alert("�ļ�������������E�̸�Ŀ¼��");
    xlApp=null;
    xlBook=null;
    xlsheet.Quit;
    xlsheet=null;
	} catch(e) {
		alert(e.message);
	};
}