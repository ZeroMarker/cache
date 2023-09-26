//装载页面  函数名称固定
function BodyLoadHandler() {
	KeyUp("Equip");
	Muilt_LookUp("Equip");
	InitEvent();	//初始化
}

function InitEvent() //初始化
{
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
}

function GetSourceID(value)
{
	var type=value.split("^");
	SetElement("Equip",type[0]);
	SetElement("EquipDR",type[1]);
}
function BPrint_Click()
{
	var Job=GetElementValue("TJobz1");
	if (Job=="") 
	{
		alertShow("没有数据!")
		return;
	}
	var encmeth=GetElementValue("GetDataList");
	if (encmeth=="")  return;
	var Rtn=cspRunServerMethod(encmeth,Job,"");
	var rows=Rtn;  //总行数	
	var PageRows=rows;
	var Pages=parseInt(rows / PageRows); //总页数?1  3为每页固定行数
	var ModRows=rows%PageRows; //最后一页行数
	if (ModRows==0) {Pages=Pages-1;}
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	try {
	    var xlApp,xlsheet,xlBook;
	    var Template=TemplatePath+"DHCEQCVPAnaly.xls";
	    xlApp = new ActiveXObject("Excel.Application");	  
	    var FileName=GetFileName();
	    ///var FileName="d:\equip.xls";
	    if (FileName=="") {return;}
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=0;
	    	if (ModRows==0)
	    	{
		    	OnePageRow=PageRows;
	    	}
	    	else
	    	{
	    		if (i==Pages)
	    		{
		    		OnePageRow=ModRows;
	    		}
		    	else
		    	{
			    	OnePageRow=PageRows;
		    	}
	    	}
	    	for (var Row=1;Row<=OnePageRow;Row++)
			{
				var encmeth=GetElementValue("GetDataList");
				if (encmeth=="")  return;
				var ListInfo=cspRunServerMethod(encmeth,Job,Row);
				var List=ListInfo.split("^");
				var TempRow=Row+2
				xlsheet.Rows(TempRow).Insert();
				xlsheet.cells(TempRow,1)=List[0];//
				xlsheet.cells(TempRow,2)=List[2];//设备名称
				xlsheet.cells(TempRow,3)=List[3];//No
				xlsheet.cells(TempRow,4)=List[21];//Loc
				xlsheet.cells(TempRow,5)=List[5];//总收入
				xlsheet.cells(TempRow,6)=List[14];//总支出
				xlsheet.cells(TempRow,7)=List[8];//GY
				xlsheet.cells(TempRow,8)=List[9];//GL
				xlsheet.cells(TempRow,9)=List[10];//YF	
				xlsheet.cells(TempRow,10)=List[11];//ZJ
				xlsheet.cells(TempRow,11)=List[6];//TConsumableFee
				xlsheet.cells(TempRow,12)=List[13];//TDepreFee
				xlsheet.cells(TempRow,13)=List[12];//TPerson
				xlsheet.cells(TempRow,14)=List[21];//TMaintFee
				xlsheet.cells(TempRow,15)=List[7];//ZJ
				xlsheet.cells(TempRow,16)=List[4];//TFactualWorkLoad
				xlsheet.cells(TempRow,17)=List[16];//ZJ
				xlsheet.cells(TempRow,18)=List[17];//ZJ
				xlsheet.cells(TempRow,19)=List[15];//ZJ
				xlsheet.cells(TempRow,20)=List[18];//ZJ
				xlsheet.cells(TempRow,21)=List[19];//ZJ
				xlsheet.cells(TempRow,22)=List[20];//ZJ
	    	}
		    xlBook.SaveAs(FileName);		    
		    xlBook.Close (savechanges=false);
		    xlApp.Quit();
		    xlApp=null;
		    xlsheet.Quit;
		    xlsheet=null;
		    alertShow("导出完成!");
	    }
	    xlApp=null;	    
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}
document.body.onload = BodyLoadHandler;
