var xls=null;
var xlBook=null;
var xlSheet=null;
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);

function GetWebConfig(encmeth){
	var objWebConfig=new Object();
	if (encmeth!=""){
		if (encmeth!=""){
			var TempFileds=encmeth.split(String.fromCharCode(1));
			objWebConfig.CurrentNS=TempFileds[0];
			objWebConfig.MEDDATA=TempFileds[1];
			objWebConfig.LABDATA=TempFileds[2];
			objWebConfig.Server="cn_iptcp:"+TempFileds[3]+"[1972]";
			objWebConfig.Path=TempFileds[4];
			objWebConfig.LayOutManager=TempFileds[5];
		}
	}else{
		objWebConfig=null;
	}
	return objWebConfig;
}


function ExportDataToExcel(ReportID,strFileName)
{
	var TemplatePath = $m({                  
		ClassName:"DHCMed.EPDService.EpidemicReportExport",
		MethodName:"GetTemplatePath"
	},false);
	var FileName=TemplatePath+"\\\\"+"DHCMed.EPD.Referral.xls";
	
	try {
		xls = new ActiveXObject ("Excel.Application");
	}catch(e) {
		$.messager.alert("��ʾ","����ExcelӦ�ö���ʧ��!\n\n�����ȷ�����ĵ������Ѿ���װ��Excel��"+"��ô�����IE�İ�ȫ����\n\n���������\n\n"+"���� �� Internetѡ�� �� ��ȫ �� �Զ��弶�� �� ��û�б��Ϊ��ȫ��ActiveX���г�ʼ���ͽű����� �� ����",'info');
		return false;
	}
	xls.visible=false;
	xlBook=xls.Workbooks.Add(FileName);
	xlSheet=xlBook.Worksheets.Item(1);
	var flg = tkMakeServerCall("DHCMed.EPDService.ReferralRepSrv","ExportReferralRep","fillxlSheet",ReportID);
	
	var fname = xls.Application.GetSaveAsFilename("�ν��ת�ﵥ("+strFileName+")","Excel Spreadsheets (*.xls), *.xls");
	xlBook.SaveAs(fname);
   
	xlSheet=null;
	xlBook.Close (savechanges=true);
	xls.Quit();
	xlSheet=null;
	xlBook=null;
	xls=null;
	xlSheet=true;
	idTmr=window.setInterval("Cleanup();",1);

	return true;
}

function PrintDataToExcel(ReportID,CardType,strFileName)
{
	var TemplatePath = $m({                  
		ClassName:"DHCMed.EPDService.EpidemicReportExport",
		MethodName:"GetTemplatePath"
	},false);
	var FileName=TemplatePath+"\\\\"+"DHCMed.EPD.Referral.xls";
	
	try {
		xls = new ActiveXObject ("Excel.Application");
	}catch(e) {
		$.messager.alert("��ʾ","����ExcelӦ�ö���ʧ��!\n\n�����ȷ�����ĵ������Ѿ���װ��Excel��"+"��ô�����IE�İ�ȫ����\n\n���������\n\n"+"���� �� Internetѡ�� �� ��ȫ �� �Զ��弶�� �� ��û�б��Ϊ��ȫ��ActiveX���г�ʼ���ͽű����� �� ����",'info');
		return false;
	}
	xls.visible=false;
	xlBook=xls.Workbooks.Add(FileName);
	xlSheet=xlBook.Worksheets.Item(1);
	var flg = tkMakeServerCall("DHCMed.EPDService.ReferralRepSrv","ExportReferralRep","fillxlSheet",ReportID);
    xlSheet.printout();
	
	xlSheet=null;
	xlBook.Close (savechanges=false);
	xls.Quit();
	xlSheet=null;
	xlBook=null;
	xls=null;
	xlSheet=true;
	idTmr=window.setInterval("Cleanup();",1);

	return true;
}

function fillxlSheet(xlSheet,cData,cRow,cCol)
{
	var cells = xlSheet.Cells;
	if ((cRow=="")||(typeof(cRow)=="undefined")){cRow=1;}
	if ((cCol=="")||(typeof(cCol)=="undefined")){cCol=1;}
	var arryDataX=cData.split(CHR_2);
	for(var i=0; i<arryDataX.length; ++i)
	{
		var arryDataY=arryDataX[i].split(CHR_1);
		for(var j=0; j<arryDataY.length; ++j)
		{
			cells(cRow+i,cCol+j).Value = arryDataY[j];
			//cells(cRow+i,cCol+j).Borders.Weight = 1;
		}
	}
	return cells;
}

function Cleanup(){
	window.clearInterval(idTmr);
	CollectGarbage();
}

//����Ԫ��
function AddCells(objSheet,fRow,fCol,tRow,tCol,xTop,xLeft)
{
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(1).LineStyle=1 ;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(2).LineStyle=1;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(3).LineStyle=1 ;
   objSheet.Range(objSheet.Cells(xTop, xLeft), objSheet.Cells(xTop + tRow - fRow, xLeft + tCol - fCol)).Borders(4).LineStyle=1 ;
}

//��Ԫ��ϲ�
function MergCells(objSheet,fRow,fCol,tRow,tCol)
{
    objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).MergeCells =1;
}

//��Ԫ�����
//-4130 �����
//-4131 �Ҷ���
//-4108 ���ж���
function HorizontCells(objSheet,fRow,fCol,tRow,tCol,HorizontNum)
{
   objSheet.Range(objSheet.Cells(fRow, fCol), objSheet.Cells(tRow,tCol)).HorizontalAlignment=HorizontNum;
}