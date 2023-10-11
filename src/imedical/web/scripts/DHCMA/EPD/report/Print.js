var xls=null;
var xlBook=null;
var xlSheet=null;
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var RepString ="";  //����������ݱ�������
var HIVString ="";  //�������HIV��������
var STDString ="";  //�������STD��������
var HBVString ="";  //�������HBV��������

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


function ExportDataToExcel(ReportID,CardType,strFileName)
{
	var SignImg = GetUserImg(ReportID);   //ȡǩ��ͼƬ
	
	if ("undefined"===typeof EnableLocalWeb || 0===EnableLocalWeb||(BrowserVer=="isIE11"))  {

		var TemplatePath = $m({                  
			ClassName:"DHCMed.EPDService.EpidemicReportExport",
			MethodName:"GetTemplatePath"
		},false);
		var FileName=TemplatePath+"\\\\"+"DHCMedEpidemicReportNew.xls";
		
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			$.messager.alert("��ʾ","����ExcelӦ�ö���ʧ��!\n\n�����ȷ�����ĵ������Ѿ���װ��Excel��"+"��ô�����IE�İ�ȫ����\n\n���������\n\n"+"���� �� Internetѡ�� �� ��ȫ �� �Զ��弶�� �� ��û�б��Ϊ��ȫ��ActiveX���г�ʼ���ͽű����� �� ���á�\n\n�����ǰΪChrome������������м���Ƿ����á����У�",'info');
			return false;
		}
		xls.visible=false;
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);
		var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportEpidemic","fillxlSheet",ReportID);
		if (SignImg) {
		   	xlSheet.Shapes.AddPicture(SignImg,'1','1','60','688','50','17'); //����ͼƬ����(�ļ��������ӡ�saveWithDocument����ࡢ��������ȡ��߶�)
	   	}        
		if (CardType=='HIV') {
			xlSheet=xlBook.Worksheets.Item(2);
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportHIVEpd","fillxlSheet",ReportID);
		}  
		if(CardType=='STD'){
			xlSheet=xlBook.Worksheets.Item(3);
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportSTDEpd","fillxlSheet",ReportID);
		}
		if(CardType=='HBV'){
			xlSheet=xlBook.Worksheets.Item(4);
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportHBVEpd","fillxlSheet",ReportID);
		}
		
		var fname = xls.Application.GetSaveAsFilename("��Ⱦ������("+strFileName+")","Excel Spreadsheets (*.xls), *.xls");
		xlBook.SaveAs(fname);
	   
		xlSheet=null;
		xlBook.Close (savechanges=true);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		xlSheet=true;
		idTmr=window.setInterval("Cleanup();",1);
	}else{
	   //�м������
	   	var TemplatePath = $m({                  
			ClassName:"DHCMed.EPDService.EpidemicReportExport",
			MethodName:"GetTemplatePath"
		},false);
			
		var FileName=TemplatePath+"DHCMedEpidemicReportNew.xls"
		FileName=FileName.replace(/\\/g,"/");
			
		var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportEpidemic","fillxlSheetStr",ReportID);
        if (CardType=='HIV') {
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportHIVEpd","fillxlSheetHIV",ReportID);
		}  
		if(CardType=='STD'){
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportSTDEpd","fillxlSheetSTD",ReportID);
		}
		if(CardType=='HBV'){
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportHBVEpd","fillxlSheetHBV",ReportID);
		}		

		var Str ="(function test(x){"
			Str += "var xlApp = new ActiveXObject('Excel.Application');"
			Str += "var xlBook = xlApp.Workbooks.Add('" +FileName+ "');"  //�����ź���Ҫ��ֵ����''����������ʹ��
			Str += "var xlSheet = xlBook.Worksheets.Item(1);"
		    Str += RepString 	  //����һ��������;
		    Str +=((SignImg)?("xlSheet.Shapes.AddPicture('" +SignImg+ "','1','1','60','688','50','17');"):"")            //����ͼƬ����(�ļ��������ӡ�saveWithDocument����ࡢ��������ȡ��߶�)
			Str += ((CardType=="HIV")?("var xlSheet = xlBook.Worksheets.Item(2);"+HIVString) : "")   //����һ��������;һ��ʹ��˫����
		    Str += ((CardType=="STD")?("var xlSheet = xlBook.Worksheets.Item(3);"+STDString) : "")
		    Str += ((CardType=="HBV")?("var xlSheet = xlBook.Worksheets.Item(4);"+HBVString) : "")
	    	//Str += "var fname = xlApp.Application.GetSaveAsFilename('��Ⱦ������("+strFileName+")"+","+"Excel Spreadsheets (*.xls), *.xls"+"');"
	    	//Str += "xlBook.SaveAs(fname);"
	    	Str += "xlBook.SaveAs('��Ⱦ������("+strFileName+").xls');"
		    Str += "xlApp.Visible = false;"
		    Str += "xlApp.UserControl = false;"
		    Str += "xlBook.Close(savechanges=false);"
		    Str += "xlApp.Quit();"
		    Str += "xlSheet=null;"
		    Str += "xlBook=null;"
		    Str += "xlApp=null;"
		    Str += "return 1;}());";
		
		//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
		CmdShell.notReturn =1;   //�����޽�����ã�����������
		var rtn = CmdShell.CurrentUserEvalJs(Str);   //ͨ���м�����д�ӡ���� 
	}	

	return true;
}

function PrintDataToExcel(ReportID,CardType,strFileName)
{   
	var SignImg = GetUserImg(ReportID);   //ȡǩ��ͼƬ

	if ("undefined"===typeof EnableLocalWeb || 0===EnableLocalWeb || (BrowserVer=="isIE11")) {
		var TemplatePath = $m({                  
			ClassName:"DHCMed.EPDService.EpidemicReportExport",
			MethodName:"GetTemplatePath"
		},false);
		var FileName=TemplatePath+"\\\\"+"DHCMedEpidemicReportNew.xls";
		
		try {
			xls = new ActiveXObject ("Excel.Application");
		}catch(e) {
			$.messager.alert("��ʾ","����ExcelӦ�ö���ʧ��!\n\n�����ȷ�����ĵ������Ѿ���װ��Excel��"+"��ô�����IE�İ�ȫ����\n\n���������\n\n"+"���� �� Internetѡ�� �� ��ȫ �� �Զ��弶�� �� ��û�б��Ϊ��ȫ��ActiveX���г�ʼ���ͽű����� �� ���á�\n\n�����ǰΪChrome������������м���Ƿ����á����У�",'info');
			return false;
		}
		xls.visible=false;
		xlBook=xls.Workbooks.Add(FileName);
		xlSheet=xlBook.Worksheets.Item(1);
		var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportEpidemic","fillxlSheet",ReportID);
	   	if (SignImg) {
		   	xlSheet.Shapes.AddPicture(SignImg,'1','1','60','688','50','17'); //����ͼƬ����(�ļ��������ӡ�saveWithDocument����ࡢ��������ȡ��߶�)
	   	}           
	    xlSheet.printout();
		if (CardType=='HIV') {
			xlSheet=xlBook.Worksheets.Item(2);
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportHIVEpd","fillxlSheet",ReportID);
			xlSheet.printout();
		}  
		if(CardType=='STD'){
			xlSheet=xlBook.Worksheets.Item(3);
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportSTDEpd","fillxlSheet",ReportID);
			xlSheet.printout();
		}
		if(CardType=='HBV'){
			xlSheet=xlBook.Worksheets.Item(4);
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportHBVEpd","fillxlSheet",ReportID);
			xlSheet.printout();
		}
		
		xlSheet=null;
		xlBook.Close (savechanges=false);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		xlSheet=true;
		idTmr=window.setInterval("Cleanup();",1);
	}else{
	   //�м������
	   	var TemplatePath = $m({                  
			ClassName:"DHCMed.EPDService.EpidemicReportExport",
			MethodName:"GetTemplatePath"
		},false);
			
		var FileName=TemplatePath+"DHCMedEpidemicReportNew.xls";
		FileName=FileName.replace(/\\/g,"/");
		var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportEpidemic","fillxlSheetStr",ReportID);
        if (CardType=='HIV') {
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportHIVEpd","fillxlSheetHIV",ReportID);
		}  
		if(CardType=='STD'){
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportSTDEpd","fillxlSheetSTD",ReportID);
		}
		if(CardType=='HBV'){
			var flg = tkMakeServerCall("DHCMed.EPDService.EpidemicReportExport","ExportHBVEpd","fillxlSheetHBV",ReportID);
		}		

	    var Str="(function test(x){"
			Str +="var xlApp = new ActiveXObject('Excel.Application');"
			Str +="var xlBook = xlApp.Workbooks.Add('" +FileName+ "');"  //�����ź���Ҫ��ֵ����''����������ʹ��
			Str +="var xlSheet = xlBook.Worksheets.Item(1);"
			Str +=RepString 	  //����һ��������;
			Str +=((SignImg)?("xlSheet.Shapes.AddPicture('" +SignImg+ "','1','1','60','688','50','17');"):"")            //����ͼƬ����(�ļ��������ӡ�saveWithDocument����ࡢ��������ȡ��߶�)
			Str +="xlSheet.PrintOut();"
			Str +=((CardType=="HIV")?("var xlSheet = xlBook.Worksheets.Item(2);"+HIVString+"xlSheet.PrintOut();") : "")   //����һ��������;һ��ʹ��˫����
			Str +=((CardType=="STD")?("var xlSheet = xlBook.Worksheets.Item(3);"+STDString+"xlSheet.PrintOut();") : "")
			Str +=((CardType=="HBV")?("var xlSheet = xlBook.Worksheets.Item(4);"+HBVString+"xlSheet.PrintOut();") : "")
			Str +="xlApp.Visible = false;"
			Str +="xlApp.UserControl = false;"
			Str +="xlBook.Close(savechanges=false);"
			Str +="xlApp.Quit();"
			Str +="xlSheet=null;"
			Str +="xlBook=null;"
			Str +="xlApp=null;"
			Str +="return 1;}());";
		//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
		CmdShell.notReturn =1;   //�����޽�����ã�����������
		var rtn = CmdShell.CurrentUserEvalJs(Str);   //ͨ���м�����д�ӡ���� 
	}

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


function fillxlSheetStr(cxlSheet,cData,cRow,cCol)
{
	if ((cRow=="")||(typeof(cRow)=="undefined")){cRow=1;}
	if ((cCol=="")||(typeof(cCol)=="undefined")){cCol=1;}
	var arryDataX=cData.split(CHR_2);
	for(var i=0; i<arryDataX.length; ++i)
	{
		
		var arryDataY=arryDataX[i].split(CHR_1);
		for(var j=0; j<arryDataY.length; ++j)
		{
			RepString=RepString+ "xlSheet.Cells("+ (cRow+i) +","+ (cCol+j) +").Value='"+arryDataY[j]+"';"  //�����ź���Ҫ��һ����������
		}
	}
	 
	return RepString; 
}

function fillxlSheetHIV(cxlSheet,cData,cRow,cCol)
{
	if ((cRow=="")||(typeof(cRow)=="undefined")){cRow=1;}
	if ((cCol=="")||(typeof(cCol)=="undefined")){cCol=1;}
	var arryDataX=cData.split(CHR_2);
	for(var i=0; i<arryDataX.length; ++i)
	{
		
		var arryDataY=arryDataX[i].split(CHR_1);
		for(var j=0; j<arryDataY.length; ++j)
		{
			HIVString=HIVString+ "xlSheet.Cells("+ (cRow+i) +","+ (cCol+j) +").Value='"+arryDataY[j]+"';"  //�����ź���Ҫ��һ����������
		}
	}
	 
	return HIVString; 
}

function fillxlSheetSTD(cxlSheet,cData,cRow,cCol)
{
	if ((cRow=="")||(typeof(cRow)=="undefined")){cRow=1;}
	if ((cCol=="")||(typeof(cCol)=="undefined")){cCol=1;}
	var arryDataX=cData.split(CHR_2);
	for(var i=0; i<arryDataX.length; ++i)
	{
		
		var arryDataY=arryDataX[i].split(CHR_1);
		for(var j=0; j<arryDataY.length; ++j)
		{
			STDString=STDString+ "xlSheet.Cells("+ (cRow+i) +","+ (cCol+j) +").Value='"+arryDataY[j]+"';"  //�����ź���Ҫ��һ����������
		}
	}
	 
	return STDString; 
}

function fillxlSheetHBV(cxlSheet,cData,cRow,cCol)
{
	if ((cRow=="")||(typeof(cRow)=="undefined")){cRow=1;}
	if ((cCol=="")||(typeof(cCol)=="undefined")){cCol=1;}
	var arryDataX=cData.split(CHR_2);
	for(var i=0; i<arryDataX.length; ++i)
	{
		
		var arryDataY=arryDataX[i].split(CHR_1);
		for(var j=0; j<arryDataY.length; ++j)
		{
			HBVString=HBVString+ "xlSheet.Cells("+ (cRow+i) +","+ (cCol+j) +").Value='"+arryDataY[j]+"';"  //�����ź���Ҫ��һ���������٣�Ҳ���ܶ�
		}
	}
	 
	return HBVString; 
}


function GetUserImg(ReportID) {
	var SignImg="";
	var SignID = tkMakeServerCall("DHCMed.CA.SignVerify","GetRepSignID","EPD","EPD",ReportID,"S");
	if (SignID != "") {
		SignImg = $m({
			ClassName:"DHCMed.CA.SignVerify",
			MethodName:"SaveSignImg",
			aSignID: SignID
		},false);
		if (SignImg!='') {
			var ImgUrl = window.location.href;
			ImgUrl = ImgUrl.substring(0,ImgUrl.lastIndexOf('/'));
			ImgUrl = ImgUrl.substring(0,ImgUrl.lastIndexOf('/'));
			SignImg = ImgUrl + SignImg + SignID + '.gif';
		}
	}
	return SignImg;
}

function GetUserSignImg(aUserID) {	
	var ImgBase64 = tkMakeServerCall("CA.BICAService","GetImageByUserID",aUserID);

	if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE�����
		var BaseImg= new ActiveXObject("Base64IMGSave.ClsSaveBase64IMG");
		var sReigstNo = aUserID;
		var sFiletype= "gif"
	    var rtn=BaseImg.WriteFile(sReigstNo,ImgBase64,sFiletype);   //C��λ�����ܹ����ʣ�����ͼƬ����Ŀ¼����C://Ŀ¼
	    if(!rtn){
	          //alert("ǩ��ͼƬת������");
	          return false;
	     }  
		return true;
	}else{	
		if (EnableLocalWeb==1) {  //��IE��������������м��
			var sReigstNo = aUserID;
			var sFiletype= "gif"
			var Str ="(function test(x){"
	    	Str +="var BaseImg= new ActiveXObject('Base64IMGSave.ClsSaveBase64IMG');"
	    	Str +="var rtn=BaseImg.WriteFile('"+sReigstNo+"','"+ImgBase64+"','"+sFiletype+"');"
		    Str += "return 1;}());";
			CmdShell.notReturn =0;   
			var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ����
			if (rtn.status=="200") {
				return true;
			}else {
				return false;
			}
		}
	}
}
    
