/// DHCEQAffixDetailFind.js
/// Mozy	2010-4-26
/// 设备附件查询
/// -------------------------------
function BodyLoadHandler()
{
	InitPage();
	//SetTableItem();		//HISUI改造 modified by czf 20180815
	initButtonWidth();
	KeyUp("UseLoc","N");
	Muilt_LookUp("UseLoc")
	initButtonWidth()  //hisui改造：修改界面按钮长度 add by lmm 2018-08-20
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
	if (num<1) {alertShow("没有符合条件的数据"+num)}    //modified by czf 2016-11-12 需求号：279602
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
				xlsheet.cells(Row+1,1)=List[2]; //主设备
				xlsheet.cells(Row+1,2)=List[3]; //设备编号
				xlsheet.cells(Row+1,3)=List[4]; //设备原值
				xlsheet.cells(Row+1,4)=List[5]; //追加款
				xlsheet.cells(Row+1,5)=List[6]; //附件名称
				xlsheet.cells(Row+1,6)=List[7]; //附件出厂编号
				xlsheet.cells(Row+1,7)=List[8]; //附件单价
				xlsheet.cells(Row+1,8)=List[12]; //设备使用科室
			}
	   		xlBook.SaveAs(FileName);
		    //xlBook.SaveAs("D:\\cgeqipsq.xls");
		    xlBook.Close (savechanges=false);
		    xlApp.Quit();
		    xlApp=null;
		    xlsheet.Quit;
		    xlsheet=null;
		    messageShow("","","","导出完成!");
		}
 		catch(e)
		{
			messageShow("","","",e.message);
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

///打印条码 HISUI改造
///add by czf 20180815
///modify by wl 2019-12-16 WL0028采用新版条码打印
function TBPrintBarHandler(rowData,rowIndex)
{
	var TEquipDR=rowData.TEquipDR;
	var TRowID=rowData.TRowID;
	printBarStandard(TEquipDR,"tiaoma",TRowID);
}
document.body.onload = BodyLoadHandler;