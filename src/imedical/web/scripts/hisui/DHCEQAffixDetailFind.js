/// DHCEQAffixDetailFind.js
/// Mozy	2010-4-26
/// �豸������ѯ
/// MZY0145	3081069		2022-11-30
var num=0;
var TJob="";
var FileName="";
var Template=GetElementValue("GetRepPath")+"DHCEQAffixDetail.xls";
function BodyLoadHandler()
{
	InitPage();
	//SetTableItem();
	initButtonWidth();
	KeyUp("UseLoc","N");
	Muilt_LookUp("UseLoc")
	InitUserInfo();
	initPanelHeaderStyle();		// MZY0151	2023-02-01
}

function InitPage()
{
	var obj=document.getElementById("BSaveExcel");
	if (obj) obj.onclick=BSaveExcel_Click;
}
// MZY0145	3081069		2022-11-30
function BSaveExcel_Click()
{
	var encmeth=GetElementValue("GetNum");
	num=cspRunServerMethod(encmeth);
	if (num<1)
	{
		alertShow("û�з�������������");
		return;
	}
	var PrintFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",'990062');	//��ӡ���ݲ��÷�ʽ:0Excel	1��Ǭ
	if (PrintFlag=="1")
	{
		if (!CheckColset("EQAffixDetail"))
		{
			messageShow('popover','alert','��ʾ',"����������δ����!")
			return;
		}
		var ObjTJob=$('#tDHCEQAffixDetailFind').datagrid('getData');
		if (ObjTJob.rows[0]["TJob"]) TJob=ObjTJob.rows[0]["TJob"];
		if (TJob=="") return;
		var url="dhccpmrunqianreport.csp?reportName=DHCEQAffixListExport.raq&CurTableName=EQAffixDetail&CurUserID="+session['LOGON.USERID']+"&CurGroupID="+session['LOGON.GROUPID']+"&Job="+TJob;
    	window.open(url,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
	}
	else
	{
		BExportByExcel();
	}
}
	
function SetTableItem()
{
	var objtbl=document.getElementById('tDHCEQAffixDetailFind');
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		obj=document.getElementById("TBPrintBarz"+i);
		if (obj)
		{
			obj.onclick=BPrintBarClick;
		}
	}
}

///��ӡ���� HISUI����
///add by czf 20180815
///modify by wl 2019-12-16 WL0028�����°������ӡ
function TBPrintBarHandler(rowData,rowIndex)
{
	var TEquipDR=rowData.TEquipDR;
	var TRowID=rowData.TRowID;
	//printBarStandard(TEquipDR,"tiaoma",TRowID);
	//DHCEQPrintAFQrcode(TEquipDR,"tiaoma",TRowID);
	var gbldata=tkMakeServerCall("web.DHCEQAffix","GetAffixByID",'','',TRowID); 
	if (gbldata=="") return;
	var list=gbldata.split("^");
	var num=parseInt(list[6]);
	for (var i = 1; i <= num; i++)
	{
		var affixData=tkMakeServerCall("web.DHCEQAffix","GetOneAffix",TRowID,i,TEquipDR);	// MZY0098	2165971		2021-10-15
		affixData=jQuery.parseJSON(affixData);
		if (affixData.SQLCODE<0) {messageShow('alert','error','��ʾ',affixData.Data,'','','');return;}
		var objAffix=affixData.Data;
		var BarMark=objAffix.AFNo;	//��ǩ����Ϣ
		printBarStandard(1, TEquipDR, {}, objAffix, BarMark);
	}
}
// MZY0145	3081069		2022-11-30
function BExportByExcel()
{
	FileName=GetFileName();
	if (FileName=="") return;
	if (tkMakeServerCall("web.DHCEQCommon","GetSysInfo",991109)=="1")
	{
		BSaveExcel_Chrome();
	}
	else
	{
		BSaveExcel_IE();
	}
}

function BSaveExcel_Chrome()
{
	var NewFileName=filepath(FileName,"\\","\\\\")
	var NewFileName=NewFileName.substr(0,NewFileName.length-4)
	var encmeth=GetElementValue("GetList");
	var AllListInfo=new Array();
   	for (var k=1;k<=num;k++)
   	{
    	var OneDetails=cspRunServerMethod(encmeth,k);
    	var OneDetail=OneDetails.replace(",","��");
    	AllListInfo.push(OneDetail)
   	}
	//alert(AllListInfo)
	//Chorme����������Դ���
	var Str ="(function test(x){"
	Str +="var xlApp,xlsheet,xlBook;"
	Str +="xlApp = new ActiveXObject('Excel.Application');"
	Str +="xlBook = xlApp.Workbooks.Add('"+Template+"');"
	Str +="xlsheet = xlBook.ActiveSheet;"
	Str +="xlsheet.PageSetup.TopMargin=0;"
	Str +="for (var Row=1;Row<=num;Row++){"
	Str +="var AllListInfoStr='"+AllListInfo+"';"
	Str +="var AllListInfo=AllListInfoStr.split(',');"
	Str +="var OneDetailList=AllListInfo[Row-1].split('^');"
	Str +="xlsheet.cells(Row+1,1)=OneDetailList[2];"
	Str +="xlsheet.cells(Row+1,2)=OneDetailList[3];"
	Str +="xlsheet.cells(Row+1,3)=OneDetailList[4];"
	Str +="xlsheet.cells(Row+1,4)=OneDetailList[5];"
	Str +="xlsheet.cells(Row+1,5)=OneDetailList[6];"
	Str +="xlsheet.cells(Row+1,6)=OneDetailList[7];"
	Str +="xlsheet.cells(Row+1,7)=OneDetailList[8];"
	Str +="xlsheet.cells(Row+1,8)=OneDetailList[12];}"
	//Str +="xlsheet.Rows(j+1).Delete();"
	Str +="var savefile='"+NewFileName+".xls';"
	Str +="xlBook.SaveAs(savefile);"
	Str +="xlBook.Close (savechanges=false);"
	Str +="xlsheet.Quit;"
	Str +="xlsheet=null;}"
	Str +="xlApp=null;"
	Str +="return 1;}());";
	alert(Str)
	
	//����Ϊƴ��Excel��ӡ����Ϊ�ַ���
	CmdShell.notReturn = 0;   //�����޽�����ã�����������
	var rtn = CmdShell.EvalJs(Str);   //ͨ���м�����д�ӡ����
    alertShow("�������!");
}
function BSaveExcel_IE()
{
	try
	{
	    var xlApp,xlsheet,xlBook;
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    for (Row=1;Row<=num;Row++)
	    {
		    var list=document.getElementById('GetList');
		 	if (list) {var encmeth=list.value} else {var encmeth=''};
			var str=cspRunServerMethod(encmeth,Row);
			var List=str.split("^");
			//alertShow("GetList="+str);
			if (Row<num) xlsheet.Rows(Row+2).Insert();
			//TRowID_"^"_TEquipDR_"^"_TEQName_"^"_TEQNo_"^"_TOriginalFee_"^"_TChangeFee_"^"_TAffixName_"^"_TAffixLeaveFacNo_"^"_TAffixFee_"^"_TAffixModel_"^"_TLeaveDate_"^"_TProvider_"^"_TUseLoc
			xlsheet.cells(Row+1,1)=List[2]; //���豸
			xlsheet.cells(Row+1,2)=List[3]; //�豸���
			xlsheet.cells(Row+1,3)=List[4]; //�豸ԭֵ
			xlsheet.cells(Row+1,4)=List[5]; //׷�ӿ�
			xlsheet.cells(Row+1,5)=List[6]; //��������
			xlsheet.cells(Row+1,6)=List[7]; //�����������
			xlsheet.cells(Row+1,7)=List[8]; //��������
			xlsheet.cells(Row+1,8)=List[12]; //�豸ʹ�ÿ���
		}
		xlBook.SaveAs(FileName);
	    //xlBook.SaveAs("D:\\cgeqipsq.xls");
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	    messageShow("","","","�������!");
	}
 	catch(e)
	{
		messageShow("","","",e.message);
	}
}
document.body.onload = BodyLoadHandler;
