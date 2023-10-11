var SelectedRow = -1; ///Modify By QW 2018-10-11 HISUI改造
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//初始化
	KeyUp("UseLoc^Equip^Model^Service^Item");
	Muilt_LookUp("UseLoc^Equip^Model^Service^Item");
	fillData();
	RefreshData();
	initButtonWidth()  //hisui改造：修改界面按钮长度不一致 add by lmm 2018-08-20
	setButtonText();///Add By QW 2018-10-11 HISUI改造:按钮文字规范
}

function fillData()
{
	var vData=GetElementValue("vData")
	if (vData!="")
	{
		var list=vData.split("^");
		for (var i=1; i<list.length; i++)
		{
			Detail=list[i].split("=");
			switch (Detail[0])
			{
				default :
					SetElement(Detail[0],Detail[1]);
					break;
			}
		}
	}
	var val="";
	val=val+"equip=Equip="+GetElementValue("EquipDR")+"^";
	val=val+"dept=UseLoc="+GetElementValue("UseLocDR")+"^";
	val=val+"service=Service="+GetElementValue("ServiceDR")+"^";
	val=val+"masteritem=Item="+GetElementValue("ItemDR")+"^";
	val=val+"model=Model="+GetElementValue("ModelDR");
	var encmeth=GetElementValue("GetDRDesc");
	var result=cspRunServerMethod(encmeth,val);
	var list=result.split("^");
	for (var i=1; i<list.length; i++)
	{
		var Detail=list[i-1].split("=");
		SetElement(Detail[0],Detail[1]);
	}
}

function InitEvent() //初始化
{
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	//Modify By zx 2020-02-18 BUG ZX0074
	var obj=document.getElementById("BSaveExcel");
	if (obj) obj.onclick=BSaveExcel_Click;
}

function BFind_Click()
{
	var val="&vData="
	val=val+GetVData();
	val=val+"&StartDate="+GetElementValue("StartDate");
	val=val+"&EndDate="+GetElementValue("EndDate");
	val=val+"&UserDR="+GetElementValue("UserDR");
	val=val+"&QXType="+GetElementValue("QXType");
    //modified by cjt 20230420 需求号2888051 增加mwtoken
    var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQUseRecordFind"+val;
    if ('function'==typeof websys_getMWToken) {
        url=url+"&MWToken="+websys_getMWToken();
    }
    window.location.href=url;
	//window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQUseRecordFind"+val;  //modify by lmm 2018-09-02 hisui改造：修改hisui默认csp
}

function GetVData()
{
	var val="^Year="+GetElementValue("Year");
	val=val+"^Month="+GetElementValue("Month");
	val=val+"^EquipDR="+GetElementValue("EquipDR");
	val=val+"^ServiceDR="+GetElementValue("ServiceDR");
	val=val+"^ModelDR="+GetElementValue("ModelDR");
	val=val+"^PatientInfo="+GetElementValue("PatientInfo");
	val=val+"^UseLocDR="+GetElementValue("UseLocDR");
	val=val+"^ItemDR="+GetElementValue("ItemDR");
	return val;
}

function GetModel(value) {
	var type=value.split("^");
	var obj=document.getElementById("ModelDR");
	obj.value=type[1];
}

function GetServiceItem(value) {
	var type=value.split("^");
	var obj=document.getElementById("ServiceDR");
	obj.value=type[1];
}

function GetSourceID(value)
{
	var type=value.split("^");
	var obj=document.getElementById("EquipDR");
	obj.value=type[1];
}

function GetUseLoc(value)
{
	var type=value.split("^");
	var obj=document.getElementById("UseLocDR");
	obj.value=type[1];
}

function GetItem(value)
{
	var type=value.split("^");
	var obj=document.getElementById("ItemDR");
	obj.value=type[1];
}
function RefreshData()
{
	var vdata1=GetElementValue("vData");
	var vdata2=GetVData();
	if (vdata1!=vdata2) BFind_Click();
}
//Modify By zx 2020-02-18 BUG ZX0074
function BSaveExcel_Click()
{
	var Node="UseRecordListReport";
	var encmeth=GetElementValue("GetTempDataRows");
	var ObjTJob=$('#tDHCEQUseRecordFind').datagrid('getData');
	if (ObjTJob.rows[0]["TJob"])  TJob=ObjTJob.rows[0]["TJob"];
	if (TJob=="")  return;
	var TotalRows=cspRunServerMethod(encmeth,Node,TJob);
	var PageRows=TotalRows; //每页固定行数
	var Pages=parseInt(TotalRows / PageRows) //总页数-1  
	var ModRows=TotalRows%PageRows //最后一页行数
	if (ModRows==0) Pages=Pages-1
	try
	{
        var xlApp,xlsheet,xlBook;
        var encmeth=GetElementValue("GetRepPath");
		if (encmeth=="") return;
		var TemplatePath=cspRunServerMethod(encmeth);
	    var Template=TemplatePath+"DHCEQUseRecordList.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    var encmeth=GetElementValue("GetTempData");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=PageRows;
	    	if ((i==Pages)&&(ModRows!=0)) OnePageRow=ModRows;
	    	//xlsheet.cells(2,1)=xlsheet.cells(2,1) //+MonthStr;	//FormatDate(BeginDate)+"--"+FormatDate(EndDate);
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k
		    	var OneDetail=cspRunServerMethod(encmeth,Node,TJob,l);
		    	var OneDetailList=OneDetail.split("^");
		    	
		    	var j=k+3;
		    	
		    	xlsheet.Rows(j).Insert();
		    	var col=1;
		    	//  0            1               2             3            4             5            6              7                  8             9              10            11         12            13        14            15             16         17        18               19          20          21          22          23            24               25             26          27       28         29
				//TRowID_"^"_TSourceType_"^"_TSourceID_"^"_TUseDate_"^"_TStartTime_"^"_TEndDate_"^"_TEndTime_"^"_TWorkLoadNum_"^"_TWorkLoadUnit_"^"_TUseLoc_"^"_TPatientInfo_"^"_TPrice_"^"_TTotalFee_"^"_TYear_"^"_TMonth_"^"_TServiceItem_"^"_TExType_"^"_TExID_"^"_TIsInputFlag_"^"_TStatus_"^"_TRemark_"^"_TAddUser_"^"_TModel_"^"_TEquipNo_"^"_TCancelDate_"^"_TCancelUser_"^"_TStartDate_"^"_TRow_"^"_TBGCS_"^"_TBRYJLSH
		    	xlsheet.cells(j,col++)=OneDetailList[23];
		    	xlsheet.cells(j,col++)=OneDetailList[1];
		    	xlsheet.cells(j,col++)=OneDetailList[2];
		    	xlsheet.cells(j,col++)=OneDetailList[22];
		    	xlsheet.cells(j,col++)=OneDetailList[7];
		    	xlsheet.cells(j,col++)=OneDetailList[8];
		    	xlsheet.cells(j,col++)=OneDetailList[11];
		    	xlsheet.cells(j,col++)=OneDetailList[12];
		    	xlsheet.cells(j,col++)=OneDetailList[3];
		    	xlsheet.cells(j,col++)=OneDetailList[4];
		    	xlsheet.cells(j,col++)=OneDetailList[5];
		    	xlsheet.cells(j,col++)=OneDetailList[6];
		    	xlsheet.cells(j,col++)=OneDetailList[9];
		    	xlsheet.cells(j,col++)=OneDetailList[10];
		    	xlsheet.cells(j,col++)=OneDetailList[15];
		    	xlsheet.cells(j,col++)=OneDetailList[19];
			}
			xlsheet.Rows(j+1).Delete();
			//xlsheet.cells(j+1,1)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页"
			//xlsheet.cells(2,1)="时间范围:"+GetElementValue("StartDate")+"--"+GetElementValue("EndDate")
			//xlsheet.cells(2,4)="制表人:"+curUserName

			var savepath=GetFileName();
			xlBook.SaveAs(savepath);
	    	xlBook.Close (savechanges=false);
	       	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	    alertShow("导出完成!");
	} 
	catch(e)
	{
		messageShow("","","",e.message);
	}
}
//定义页面加载方法
document.body.onload = BodyLoadHandler;
