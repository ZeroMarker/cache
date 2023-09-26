/// DHCEQAffixDetailFind.js
/// Mozy	2010-4-26
/// �豸������ѯ
/// -------------------------------
function BodyLoadHandler()
{
	InitPage();
	SetTableItem();
	KeyUp("UseLoc","N");
	Muilt_LookUp("UseLoc")
}

function InitPage()
{
	var obj=document.getElementById("BSaveExcel");
	if (obj) obj.onclick=BSaveExcel_Click;
}

function BSaveExcel_Click()
{
	var encmeth=GetElementValue("GetNum");
	var num=cspRunServerMethod(encmeth);
	if (num<1) {alertShow("û�з�������������"+num)}    //modified by czf 2016-11-12 ����ţ�279602
	else
	{
		try
		{
	    	var FileName=GetFileName();
	    	///var FileName="d:\equip.xls";
	    	if (FileName=="") return;
			var	TemplatePath=GetElementValue("GetRepPath");
	        var Template=TemplatePath+"DHCEQAffixDetail.xls";
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
		    alertShow("�������!");
		}
 		catch(e)
		{
			alertShow(e.message);
		}
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
function BPrintBarClick()
{
	var selectrow=GetTableCurRow();
	DHCEQPrintAFQrcode(GetElementValue("TEquipDRz"+selectrow),"tiaoma",GetElementValue("TRowIDz"+selectrow));
}
document.body.onload = BodyLoadHandler;