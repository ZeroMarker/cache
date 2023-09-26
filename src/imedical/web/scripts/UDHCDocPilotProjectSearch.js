//UDHCDocPilotProjectSearch.js
var SelectedRow=0;
function BodyLoadHandler() {
	ShowTotal();
	ClickFormRow();  //add by nk
	var obj=document.getElementById("LookDA");
if (obj)obj.onclick=LookDA_Click;
	
	}
function ShowTotal()
{
	var objtbl=document.getElementById('tUDHCDocPilotProjectSearch');
	var rows=objtbl.rows.length;
	if (rows>1) {
		var index=rows-1
		var TobjTotal=document.getElementById("RecordSumz"+1);
		
		var objTotal=document.getElementById('Total');
    	if (objTotal) objTotal.value=TobjTotal.value;
	}
}
function Export(){
	try {
		var GetPrescPath=document.getElementById("printpath");  
		if (GetPrescPath) {var encmeth=GetPrescPath.value} else {var encmeth=''};
		if (encmeth!="") {
			TemplatePath=cspRunServerMethod(encmeth);
		}
	
        var myTotlNum=0;
        var myencmeth="";
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCDOCPILOTPROJECT.xlsx";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    xlsheet.PageSetup.RightMargin=0;
	    
		var ProcesNo=document.getElementById("Jobz"+1).value
		var GetProjectNum=document.getElementById("GetProjectNum").value;
		var myRows=cspRunServerMethod(GetProjectNum,ProcesNo);
		var GetProject=document.getElementById("GetProject").value;
		
		var xlsrow=1;
		var xlsCurcol=0;
		for (var Row=1;Row<=myRows;Row++)
		{
			var res=cspRunServerMethod(GetProject,ProcesNo,Row);
			var arr=res.split("^") 
			xlsrow=xlsrow+1;
			xlsheet.cells(xlsrow,1)=arr[0];
			xlsheet.cells(xlsrow,2)=arr[1];
			xlsheet.cells(xlsrow,3)=arr[2];
			xlsheet.cells(xlsrow,4)=arr[3];
			xlsheet.cells(xlsrow,5)=arr[4];
			xlsheet.cells(xlsrow,6)=arr[5];
			xlsheet.cells(xlsrow,7)=arr[6];
			xlsheet.cells(xlsrow,8)=arr[7];
			xlsheet.cells(xlsrow,9)=arr[8];
			xlsheet.cells(xlsrow,10)=arr[9];
			xlsheet.cells(xlsrow,11)=arr[10];
			xlsheet.cells(xlsrow,12)=arr[11];
			xlsheet.cells(xlsrow,13)=arr[12];
			xlsheet.cells(xlsrow,14)=arr[13];
			xlsheet.cells(xlsrow,15)=arr[14];
			xlsheet.cells(xlsrow,16)=arr[15];
			xlsheet.cells(xlsrow,17)=arr[16];
			xlsheet.cells(xlsrow,18)=arr[17];
			xlsheet.cells(xlsrow,19)=arr[18];
			xlsheet.cells(xlsrow,20)=arr[19];
			xlsheet.cells(xlsrow,21)=arr[20];
			xlsheet.cells(xlsrow,22)=arr[21];
			xlsheet.cells(xlsrow,23)=arr[22];
			xlsheet.cells(xlsrow,24)=arr[23];
			xlsheet.cells(xlsrow,25)=arr[24];
			xlsheet.cells(xlsrow,26)=arr[25];
			xlsheet.cells(xlsrow,27)=arr[26];
			xlsheet.cells(xlsrow,28)=arr[27];
			xlsheet.cells(xlsrow,29)=arr[28];
			xlsheet.cells(xlsrow,30)=arr[29];
			xlsheet.cells(xlsrow,31)=arr[30];
			xlsheet.cells(xlsrow,32)=arr[31];
			xlsheet.cells(xlsrow,33)=arr[71];
		
				    }
	gridlist(xlsheet,1,xlsrow,1,33)
		//xlsheet.printout;
	   xlBook.Close ;
	   xlApp.Quit();
	   xlApp=null;
	   xlsheet=null;
	} catch(e) {
		alert(e.message);
	};
}
function ExportDA(){
	try {
		var GetPrescPath=document.getElementById("printpath");  
		if (GetPrescPath) {var encmeth=GetPrescPath.value} else {var encmeth=''};
		if (encmeth!="") {
			TemplatePath=cspRunServerMethod(encmeth);
		}
	
        var myTotlNum=0;
        var myencmeth="";
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCDOCPILOTPROJECTDA.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    xlsheet.PageSetup.RightMargin=0;
	    
		var ProcesNo=document.getElementById("Jobz"+1).value
		var GetProjectNum=document.getElementById("GetProjectNum").value;
		var myRows=cspRunServerMethod(GetProjectNum,ProcesNo);
		var GetProject=document.getElementById("GetProject").value;
		
		var xlsrow=2;
		var xlsCurcol=0;
		for (var Row=1;Row<=myRows;Row++)
		{
			var res=cspRunServerMethod(GetProject,ProcesNo,Row);
			var arr=res.split("^") 
			xlsrow=xlsrow+1;
			xlsheet.cells(xlsrow,1)=arr[32];
			xlsheet.cells(xlsrow,2)=arr[33];
			xlsheet.cells(xlsrow,3)=arr[0];
			xlsheet.cells(xlsrow,4)=arr[34];
			xlsheet.cells(xlsrow,5)=arr[10];
			xlsheet.cells(xlsrow,6)=arr[11];
			xlsheet.cells(xlsrow,7)=arr[1];
			xlsheet.cells(xlsrow,8)=arr[8];
			xlsheet.cells(xlsrow,9)=arr[7];
			xlsheet.cells(xlsrow,10)=arr[6];
			xlsheet.cells(xlsrow,11)=arr[12];
			xlsheet.cells(xlsrow,12)=arr[3]+arr[5];
			xlsheet.cells(xlsrow,13)=arr[9];
			xlsheet.cells(xlsrow,14)=arr[27];
			xlsheet.cells(xlsrow,15)=arr[28];
			xlsheet.cells(xlsrow,16)=arr[2];
			xlsheet.cells(xlsrow,17)=arr[35];
			xlsheet.cells(xlsrow,18)=arr[36];
			xlsheet.cells(xlsrow,19)=arr[29];
			xlsheet.cells(xlsrow,20)=arr[37];
			xlsheet.cells(xlsrow,21)=arr[38];
			xlsheet.cells(xlsrow,22)=arr[19];
			xlsheet.cells(xlsrow,23)=arr[39];
			xlsheet.cells(xlsrow,24)=arr[40];
			xlsheet.cells(xlsrow,25)=arr[41];
			xlsheet.cells(xlsrow,26)=arr[42];
			xlsheet.cells(xlsrow,27)=arr[43];
			xlsheet.cells(xlsrow,28)=arr[44];
			xlsheet.cells(xlsrow,29)=arr[45];
			xlsheet.cells(xlsrow,30)=arr[46];
			xlsheet.cells(xlsrow,31)=arr[47];
			xlsheet.cells(xlsrow,32)=arr[48];
			xlsheet.cells(xlsrow,33)=arr[49];
			xlsheet.cells(xlsrow,34)=arr[72];
			xlsheet.cells(xlsrow,35)=arr[50];
			xlsheet.cells(xlsrow,36)=arr[51];
			xlsheet.cells(xlsrow,37)=arr[52];
			xlsheet.cells(xlsrow,38)=arr[53];
			xlsheet.cells(xlsrow,39)=arr[54];
			xlsheet.cells(xlsrow,40)=arr[55];
			xlsheet.cells(xlsrow,41)=arr[56];
			xlsheet.cells(xlsrow,42)=arr[57];
			xlsheet.cells(xlsrow,43)=arr[58];
			xlsheet.cells(xlsrow,44)=arr[59];
			xlsheet.cells(xlsrow,45)=arr[60];
			xlsheet.cells(xlsrow,46)=arr[61];
			xlsheet.cells(xlsrow,47)=arr[62];
			xlsheet.cells(xlsrow,48)=arr[63];
			xlsheet.cells(xlsrow,49)=arr[64];
			xlsheet.cells(xlsrow,54)=arr[65];
			xlsheet.cells(xlsrow,55)=arr[66];
			xlsheet.cells(xlsrow,56)=arr[67];
			xlsheet.cells(xlsrow,57)=arr[68];
			xlsheet.cells(xlsrow,58)=arr[69];
			xlsheet.cells(xlsrow,59)=arr[70];
			
			
		
				    }
	gridlist(xlsheet,1,xlsrow,1,59)
		//xlsheet.printout;
	   xlBook.Close ;
	   xlApp.Quit();
	   xlApp=null;
	   xlsheet=null;
	} catch(e) {
		alert(e.message);
	};
}
function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).Weight=3
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).Weight=3
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).Weight=3
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).Weight=3
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow){
		SelectedRow=0
		return;
	}

	if (selectrow!=SelectedRow){
		
		SelectedRow = selectrow;
		
	
		
	}else{
		//alert("2")
		SelectedRow=0;
		
	}
}
function LookDA_Click(){
	if (SelectedRow==0)
	{
		alert("请选择一行！")
		return false;
	}
	var PPRowId=DHCC_GetColumnData("TPPRowId",SelectedRow)
	if(PPRowId=="") return false;
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProFileManage&PPRowId="+PPRowId
	win=window.open(lnk,"Settle","status=1,scrollbars=1,top=10,left=10,width=1350,height=600");
}

//add by nk ----start

function SelectRowHandlers(){  
	var eSrc=window.event.srcElement;	
	///把表格中被选中的那一行赋值到rowObj中
	var rowObj=getRow(eSrc);
	///得到选中行的序号selectrow它是一个全局变量
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;	
	var TPPDesc=document.getElementById('TPPDescz'+selectrow).innerText;
	var TPPCode=document.getElementById('TPPCodez'+selectrow).innerText;
	var TPPCreateDepartment=document.getElementById('TPPCreateDepartmentz'+selectrow).innerText;
	var TPPStartUser=document.getElementById('TPPStartUserz'+selectrow).innerText;
	var PlanNonow=document.getElementById('PlanNonowz'+selectrow).innerText;
	var Indication=document.getElementById('Indicationz'+selectrow).innerText;
	var PilotCategory=document.getElementById('PilotCategoryz'+selectrow).innerText;
	var ApplyMatter=document.getElementById('ApplyMatterz'+selectrow).innerText;
	var Job=document.getElementById('Jobz'+selectrow).value;
	var ApplicationUnitnow=document.getElementById('ApplicationUnitnowz'+selectrow).innerText;
	var ApplyStage=document.getElementById('ApplyStagez'+selectrow).innerText;
	var ApprovalNonow=document.getElementById('ApprovalNonowz'+selectrow).innerText;
	var PlanNamenow=document.getElementById('PlanNamenowz'+selectrow).innerText;
	var IsHeadman=document.getElementById('IsHeadmanz'+selectrow).innerText;
	var FileSubmitDate=document.getElementById('FileSubmitDatez'+selectrow).innerText;
	var EthicsMeetDate=document.getElementById('EthicsMeetDatez'+selectrow).innerText;
	var EthicsMeetAduitDate=document.getElementById('EthicsMeetAduitDatez'+selectrow).innerText;
	var TEndDate=document.getElementById('TEndDatez'+selectrow).innerText;
	var FirstPatDate=document.getElementById('FirstPatDatez'+selectrow).innerText;
	var ArchivesFilesNo=document.getElementById('ArchivesFilesNoz'+selectrow).innerText;
	var CollectCompany=document.getElementById('CollectCompanyz'+selectrow).innerText;
	var ProState=document.getElementById('ProStatez'+selectrow).innerText;
	var YearCheckDate=document.getElementById('YearCheckDatez'+selectrow).innerText;
	var ProjectFilesState=document.getElementById('ProjectFilesStatez'+selectrow).innerText;
	var EthicsFilesState=document.getElementById('EthicsFilesStatez'+selectrow).innerText;
	var EthicsFilesNextState=document.getElementById('EthicsFilesNextStatez'+selectrow).innerText;
	var EthicsFilesOffDate=document.getElementById('EthicsFilesOffDatez'+selectrow).innerText;
	var SignProtocolDate=document.getElementById('SignProtocolDatez'+selectrow).innerText;
	var LeaderCompany=document.getElementById('LeaderCompanyz'+selectrow).innerText;
	var LeaderCompanyPI=document.getElementById('LeaderCompanyPIz'+selectrow).innerText;
	var CROCompany=document.getElementById('CROCompanyz'+selectrow).innerText;
	var PPRemark=document.getElementById('PPRemarkz'+selectrow).innerText;
	var CheckPerson=document.getElementById('CheckPersonz'+selectrow).innerText;
	var EndYear=document.getElementById('EndYearz'+selectrow).innerText;
	var Filingstatus=document.getElementById('Filingstatusz'+selectrow).innerText;
	var BriefDate=document.getElementById('BriefDatez'+selectrow).innerText;
	var CenterDate=document.getElementById('CenterDatez'+selectrow).innerText;
	var SaveLastDate=document.getElementById('SaveLastDatez'+selectrow).innerText;
	var CPRCApproveDate=document.getElementById('CPRCApproveDatez'+selectrow).innerText;
	var ToalAgree=document.getElementById('ToalAgreez'+selectrow).innerText;
	var RecordSum=document.getElementById('RecordSumz'+selectrow).value;
	var InfoStr=TPPDesc+"^"+TPPCode+"^"+TPPCreateDepartment+"^"+TPPStartUser+"^"+PlanNonow+"^"+Indication+"^"+PilotCategory+"^"+ApplyMatter+"^"+Job+"^"+ApplicationUnitnow;
	var InfoStr=InfoStr+"^"+ApplyStage+"^"+ApprovalNonow+"^"+PlanNamenow+"^"+IsHeadman+"^"+FileSubmitDate+"^"+EthicsMeetDate+"^"+EthicsMeetAduitDate+"^"+TEndDate+"^"+FirstPatDate+"^"+ArchivesFilesNo;
	var InfoStr=InfoStr+"^"+CollectCompany+"^"+ProState+"^"+YearCheckDate+"^"+ProjectFilesState+"^"+EthicsFilesState+"^"+EthicsFilesNextState+"^"+EthicsFilesOffDate+"^"+SignProtocolDate+"^"+LeaderCompany+"^"+LeaderCompanyPI;
 	var InfoStr=InfoStr+"^"+CROCompany+"^"+PPRemark+"^"+CheckPerson+"^"+RecordSum+"^"+EndYear+"^"+Filingstatus;
 	var InfoStr=InfoStr+"^"+BriefDate+"^"+CenterDate+"^"+SaveLastDate+"^"+CPRCApproveDate+"^"+ToalAgree;
	//alert(">>>>>>>>"+InfoStr)
	var url="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocClickRowDetail&InfoStr="+InfoStr;
	websys_createWindow(url,"UDHCDocClickRowDetail","top=100,left=200,width=1300,height=400,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes"); 
}

function ClickFormRow(){	
	var objtbl=document.getElementById('tUDHCDocPilotProjectSearch');
	if(objtbl)	objtbl.ondblclick=SelectRowHandlers;
}
//    --------end
	

document.body.onload = BodyLoadHandler;
