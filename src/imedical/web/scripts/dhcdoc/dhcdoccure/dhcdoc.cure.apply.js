var cureItemList;
var cureAppId="";
var PrintData="";
$(function(){
	var DCARowId=$('#DCARowId').val();
	if(DCARowId=="")return;
	initCureApplyInfo(DCARowId)
	$('#btnSave').bind("click",function(){
		SaveCureApply();	
	});
	
	$('#btnPrint').bind("click",function(){
		btnPrint();	
	}); 
});
function initCureApplyInfo(DCARowId){
	PrintData="";
	var ret=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",DCARowId);
	if (ret=="") return;
	var TempArr=ret.split(String.fromCharCode(1));
	var PatientArr=TempArr[0].split("^");
	var PatNo=PatientArr[1];
	var PatName=PatientArr[2];
	var PatSex=PatientArr[3];
	var PatAge=PatientArr[4];
	var PatType=PatientArr[6];
	var PatTel=PatientArr[24];
	var PatAddress=PatientArr[10];
	$("#patNo").prop("innerText",PatNo);
	$("#patName").prop("innerText",PatName);
	$("#patSex").prop("innerText",PatSex);
	$("#patAge").prop("innerText",PatAge);
	$("#patType").prop("innerText",PatType);
	$("#patTel").prop("innerText",PatTel);
	$("#patAddress").prop("innerText",PatAddress);
	var CureApplyArr=TempArr[1].split("^");
	var ArcimDesc=CureApplyArr[0];
	var OrderQty=CureApplyArr[2];
	var BillingUOM=CureApplyArr[3];
	var OrderReLoc=CureApplyArr[4];
	var ApplyStatus=CureApplyArr[6];
	var ApplyUser=CureApplyArr[7];
	var ApplyDate=CureApplyArr[8];
	var ApplyRemarks=CureApplyArr[13];
	var ApplyPlan=CureApplyArr[14];
	$("#ArcimDesc").prop("innerText",ArcimDesc);
	$("#OrderQty").prop("innerText",OrderQty);
	$("#BillingUOM").prop("innerText",BillingUOM);
	$("#OrderReLoc").prop("innerText",OrderReLoc);
	$("#ApplyStatus").prop("innerText",ApplyStatus);
	$("#ApplyUser").prop("innerText",ApplyUser);
	$("#ApplyDate").prop("innerText",ApplyDate);
	$("#ApplyRemark").val(ApplyRemarks);
	$("#ApplyPlan").val(ApplyPlan);
	PrintData=PatNo+"^"+PatName+"^"+PatSex+"^"+PatAge+"^"+PatType+"^"+PatTel+"^"+PatAddress+"^"+ArcimDesc+"^"+OrderQty+"^"+BillingUOM+"^"+OrderReLoc+"^"+ApplyUser+"^"+ApplyDate+"^"+ApplyRemarks+"^"+ApplyPlan;
}
function SaveCureApply()
{
    var DCARowId=$('#DCARowId').val();
    if(DCARowId=="")return;
	var ApplyPlan=$("#ApplyPlan").val();
	if (ApplyPlan=="")
	{
		$.messager.alert("��ʾ","���Ʒ�������Ϊ��");
		return;
	}
	var ApplyRemark=$("#ApplyRemark").val();
	var ret=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","SaveCureApply",DCARowId,ApplyPlan,ApplyRemark,session['LOGON.USERID']);
	if(ret==0)
	{
		$.messager.alert('Warning','����ɹ�');
	}else{
		$.messager.alert('Warning','����ʧ��');
	}
}
function PrintCureApply()
{
    DHCP_GetXMLConfig("InvPrintEncrypt","DHCDocCureApply");
    if(PrintData=="")return;
    var TempArrApply=PrintData.split("^");
    var PatNo=TempArrApply[0];
    var PatName=TempArrApply[1];
    var PatSex=TempArrApply[2];
    var PatAge=TempArrApply[3];
    var PatType=TempArrApply[4];
    var PatTel=TempArrApply[5];
    var PatAddress=TempArrApply[6];
    var ArcimDesc=TempArrApply[7];
    var OrderQty=TempArrApply[8];
    var BillingUOM=TempArrApply[9];
    var OrderReLoc=TempArrApply[10];
    var ApplyUser=TempArrApply[11];
    var ApplyDate=TempArrApply[12];
    var ApplyRemarks=TempArrApply[13];
    var ApplyPlan=TempArrApply[14];
    var PDlime=String.fromCharCode(2);
    var MyPara="ArcimDesc"+PDlime+ArcimDesc
    var MyPara=MyPara+"^"+"PatNo"+PDlime+PatNo
    var MyPara=MyPara+"^"+"PatName"+PDlime+PatName
    var MyPara=MyPara+"^"+"PatSex"+PDlime+PatSex
    var MyPara=MyPara+"^"+"PatAge"+PDlime+PatAge
    var MyPara=MyPara+"^"+"PatType"+PDlime+PatType
    var MyPara=MyPara+"^"+"PatTel"+PDlime+PatTel
    var MyPara=MyPara+"^"+"PatAddress"+PDlime+PatAddress
    var MyPara=MyPara+"^"+"ArcimDesc"+PDlime+ArcimDesc
    var MyPara=MyPara+"^"+"OrderQty"+PDlime+OrderQty
    var MyPara=MyPara+"^"+"BillingUOM"+PDlime+BillingUOM
    var MyPara=MyPara+"^"+"OrderReLoc"+PDlime+OrderReLoc
    var MyPara=MyPara+"^"+"ApplyUser"+PDlime+ApplyUser
    var MyPara=MyPara+"^"+"ApplyDate"+PDlime+ApplyDate
    var MyPara=MyPara+"^"+"ApplyRemarks"+PDlime+ApplyRemarks
    var MyPara=MyPara+"^"+"ApplyPlan"+PDlime+ApplyPlan
    //alert(MyPara);
    var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,MyPara,"");
}


function btnPrint()
{
	
		var DCARowId=$('#DCARowId').val()
		if (DCARowId==""){
			$.messager.alert("��ʾ","��ѡ����Ҫ��ӡ�����뵥��")
			return false
		}
		var getpath=tkMakeServerCall("web.UDHCJFCOMMON","getpath")
	
		var Template=getpath+"DHCDocCurApplay.xls";
		var xlApp,xlsheet,xlBook
	 
		//���ұ߾�
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    xlsheet.PageSetup.RightMargin=0;
	 
		
		var xlsrow=2; //����ָ��ģ��Ŀ�ʼ����λ��
		var xlsCurcol=1;  //����ָ����ʼ������λ��
		
		
		var RtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",DCARowId)
		var RtnStrArry=RtnStr.split(String.fromCharCode(1));
		var PatientArr=RtnStrArry[0].split("^"); //���߻�����Ϣ
		var CureApplyArr=RtnStrArry[1].split("^"); //ԤԼ����Ϣ
		
		
		
		var PatID=PatientArr[0]
		var PatNo=PatientArr[1];
		var PatName=PatientArr[2];
		var PatSex=PatientArr[3];
		var PatAge=PatientArr[4];
		var PatType=PatientArr[6];
		var PatTel=PatientArr[24];
		var PatAddress=PatientArr[10];
		
		var AdmID=CureApplyArr[15]
		var AppLoc=CureApplyArr[16]
		var AppInsertDate=CureApplyArr[17]
		var AppInsertTime=CureApplyArr[18]
		var ArcimID=CureApplyArr[20]
		var ApplyStatus=CureApplyArr[6]
		var ApplyUser=CureApplyArr[7]
		var ApplyDate=CureApplyArr[8]
		var InsertDate=CureApplyArr[17]
		var InsertTime=CureApplyArr[18]
		var DocCurNO=CureApplyArr[19]
		var ApplyRemarks=CureApplyArr[13]
		var ApplyPlan=CureApplyArr[14]
		var ArcimDesc=CureApplyArr[0]
		var AppLocDr=CureApplyArr[22]
		var RelocID=CureApplyArr[5]
		var AppReloc=CureApplyArr[4]
		
		
		xlsheet.cells(xlsrow,xlsCurcol+8)=DocCurNO
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=PatName
		xlsheet.cells(xlsrow,xlsCurcol+4)=PatSex
		xlsheet.cells(xlsrow,xlsCurcol+6)=PatTel
		xlsheet.cells(xlsrow,xlsCurcol+8)=PatNo
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=PatAddress
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=AppLoc
		xlsheet.cells(xlsrow,xlsCurcol+6)=ApplyUser
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=AppReloc
		xlsheet.cells(xlsrow,xlsCurcol+6)=ArcimDesc
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=ApplyDate
		xlsrow=xlsrow+1
		xlsheet.cells(xlsrow,xlsCurcol+2)=ApplyRemarks
		xlsrow=xlsrow+2
		xlsheet.cells(xlsrow,xlsCurcol+2)=ApplyPlan
		xlsrow=xlsrow+2
		xlsheet.cells(xlsrow,xlsCurcol+6)=AppInsertDate+" "+AppInsertTime
	
		var d=new Date();
		var h=d.getHours();
		var m=d.getMinutes();
		var s=d.getSeconds()

	    xlBook.printout()
	    xlBook.Close (savechanges=false);
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	
}
//��excel����л��ߵķ�����
function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
}

