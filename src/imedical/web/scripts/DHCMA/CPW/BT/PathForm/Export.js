//��ӡ�������˵��
//MethodGetServer s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRMedBaseCtl.GetServerInfo"))
//MethodGetData   s val=##Class(%CSP.Page).Encrypt($LB("�෽��"))
//DHC.WMR.CommonFunction.js,DHC.WMR.ExcelPrint.JS,
//btnPrint  ��ӡ  websys/print_compile.gif
//btnExport ��ӡ  websys/print_compile.gif
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
function ExportFormOrder(PathFormID,PathFormDesc)
{
	var TemplatePath= $m({                  
		ClassName:"DHCMA.CPW.CPS.PrintSrv",
		MethodName:"GetTemplatePath"
	},false);
	var FileName=TemplatePath+"\\\\"+"DHCMA.CPW.PathFormOrd.xls";

	try {	
		xls = new ActiveXObject ("Excel.Application");
		
	}catch(e) {
		$.messager.alert("��ʾ","����ExcelӦ�ö���ʧ��!",'info');
		return false;
	}finally{
	xls.visible=false;

	xlBook=xls.Workbooks.Add(FileName);
	xlSheet=xlBook.Worksheets.Item(1);
	var flg = tkMakeServerCall("DHCMA.CPW.CPS.PrintSrv","ExportForm","fillxlSheet",PathFormID);
	xlSheet.Cells.EntireColumn.AutoFit;  //�п�����Ӧ
	
	if (PathFormDesc){
		PathFormDesc = PathFormDesc + ".xls"
	} else {
		PathFormDesc = "*.xls";
	}
	var fname = xls.Application.GetSaveAsFilename(PathFormDesc, "Excel Spreadsheets (*.xls), *.xls");
	if (fname != false){
		//Ŀ¼�д����������ļ����ڴ򿪵���ʱѡ�񡰷񡱡���ȡ�������б���
		//��֪��ѡ�񡰷񡱵Ĵ������д����ʱ������
		try {
			xlBook.SaveAs(fname);
		}catch(e){
			//alert(e.message);
			return false;
		}
	}
	xlSheet=null;
	xlBook.Close (savechanges=false);
	xls.Quit();
	xlSheet=null;
	xlBook=null;
	xls=null;
	idTmr=window.setInterval("Cleanup();",1);

	return true;
	}
}
function ExportDataToExcel(PathFormID,PathFormDesc)
{
	var TemplatePath= $m({                  
		ClassName:"DHCMA.CPW.CPS.PrintSrv",
		MethodName:"GetTemplatePath"
	},false);
	var FileName=TemplatePath+"\\\\"+"DHCMA.CPW.PathForm.xls";

	try {	
		xls = new ActiveXObject ("Excel.Application");
		
	}catch(e) {
		$.messager.alert("��ʾ","����ExcelӦ�ö���ʧ��!",'info');
		return false;
	}finally{
	xls.visible=false;

	xlBook=xls.Workbooks.Add(FileName);
	xlSheet=xlBook.Worksheets.Item(1);
	var flg = tkMakeServerCall("DHCMA.CPW.CPS.PrintSrv","ExportFormHead","fillxlSheet",PathFormID);
	xlSheet=xlBook.Worksheets.Item(2);
	var flg = tkMakeServerCall("DHCMA.CPW.CPS.PrintSrv","ExportFormContent","fillxlSheet",PathFormID);
	xlSheet.Cells.EntireColumn.AutoFit;  //�п�����Ӧ
	
	if (PathFormDesc){
		PathFormDesc = PathFormDesc + ".xls"
	} else {
		PathFormDesc = "*.xls";
	}
	var fname = xls.Application.GetSaveAsFilename(PathFormDesc, "Excel Spreadsheets (*.xls), *.xls");
	if (fname != false){
		//Ŀ¼�д����������ļ����ڴ򿪵���ʱѡ�񡰷񡱡���ȡ�������б���
		//��֪��ѡ�񡰷񡱵Ĵ������д����ʱ������
		try {
			xlBook.SaveAs(fname);
		}catch(e){
			//alert(e.message);
			return false;
		}
	}
	xlSheet=null;
	xlBook.Close (savechanges=false);
	xls.Quit();
	xlSheet=null;
	xlBook=null;
	xls=null;
	idTmr=window.setInterval("Cleanup();",1);

	return true;
	}
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