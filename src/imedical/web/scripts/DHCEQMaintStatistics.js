var SelectedRow = 0;
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//初始化
	KeyUp("UseLoc");	//清空选择
	KeyUp("Equip");
	KeyUp("MaintUser");
	Muilt_LookUp("UseLoc");
	Muilt_LookUp("Equip");
	Muilt_LookUp("MaintUser");
	SetElement("MaintType",GetElementValue("MaintTypeDR"))
}

function InitEvent() //初始化
{
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
}

function BPrint_Click() //打印按钮
{
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	var encmeth=GetElementValue("GetOneMaintStatistics");
	var TotalRows=cspRunServerMethod(encmeth,0);
	if (TotalRows<=1)
	{
		alertShow(t["01"])
		return;
	}
	var PageRows=24 //每页固定行数
	var Pages=parseInt(TotalRows / PageRows) //总页数-1 
	var ModRows=TotalRows%PageRows //最后一页行数
	if (ModRows==0) Pages=Pages-1
	
	try {
		var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQMaintStatistics.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	xlsheet.PageSetup.TopMargin=0;
	    	var OnePageRow=0
	    	if (ModRows==0)
	    	{
		    	OnePageRow=PageRows
	    	}
	    	else
	    	{
	    		if (i==Pages)
	    		{
		    		OnePageRow=ModRows
	    		}
		    	else
		    	{
			    	OnePageRow=PageRows
		    	}
	    	}
	    	for (var k=1;k<=OnePageRow;k++)
	    	{
		    	var l=i*PageRows+k
		    	var OneDetail=cspRunServerMethod(encmeth,l);
		    	var OneDetailList=OneDetail.split("^");
		    	var j=k+3;
		    	xlsheet.Rows(j).Insert();
		    	xlsheet.cells(j,1)=GetShortName(OneDetailList[1],"-"); //申请科室
		    	xlsheet.cells(j,2)=OneDetailList[2]; //申请单号
		    	xlsheet.cells(j,3)=OneDetailList[3]; //设备名称
		    	xlsheet.cells(j,4)=OneDetailList[4]; //设备编号
		    	xlsheet.cells(j,5)=OneDetailList[5]; //规格型号
		    	xlsheet.cells(j,6)=FormatDate(OneDetailList[6]); //申请日期
		    	if (OneDetailList[7]=="维护总次数:")
		    	{
			    	xlsheet.cells(j,7)=OneDetailList[7]; //维修日期
		    	}
		    	else
		    	{
			    	xlsheet.cells(j,7)=FormatDate(OneDetailList[7]); //维修日期
		    	}
		    	xlsheet.cells(j,8)=OneDetailList[8]; //维修员
		    	xlsheet.cells(j,9)=GetShortName(OneDetailList[9],"-"); //使用科室
		    	xlsheet.cells(j,10)=OneDetailList[10]; //费用
		    	xlsheet.cells(j,11)=OneDetailList[11]; //费用
			}
			if (GetElementValue("UseLoc")=="") //使用科室
			{
				xlsheet.cells(2,1)=""
			}
			else
			{
				xlsheet.cells(2,2)=GetElementValue("UseLoc")
			}
			xlsheet.cells(2,5)=FormatDate(GetElementValue("StartDate"))+"至"+FormatDate(GetElementValue("EndDate")) //维修日期
			if (GetElementValue("MaintUser")=="") //维修员
			{
				xlsheet.cells(2,9)=""
				xlsheet.cells(2,10)=""
			}
			else
			{
				xlsheet.cells(2,10)=GetElementValue("MaintUser")
			}
			xlsheet.Rows(j+1).Delete();
			xlsheet.cells(j+1,2)=curUserName
			xlsheet.cells(j+1,6)=FormatDate(GetCurrentDate())
			xlsheet.cells(j+1,10)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页"
	    	xlsheet.printout; //打印输出
	    	xlBook.Close (savechanges=false);
	    	
	    	xlsheet.Quit;
	    	xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}

function BClear_Click() //清空按钮
{
	SetElement("UseLoc","");
	SetElement("UseLocDR","")
	SetElement("Equip","");
	SetElement("EquipDR","");
	SetElement("MaintUser","");
	SetElement("MaintUserDR","");
	SetElement("StartDate","");
	SetElement("EndDate","");
}

function GetUseLoc(value) {
	var user=value.split("^");
	var obj=document.getElementById("UseLocDR");
	obj.value=user[1];
}

function GetEquip(value) {
	var type=value.split("^");
	var obj=document.getElementById("EquipDR");
	obj.value=type[1];
}

function GetMaintUser(value) {
	var type=value.split("^");
	var obj=document.getElementById("MaintUserDR");
	obj.value=type[1];
}

function FormatDate(DateStr,FromFormat,ToFormat)
{
	if (DateStr=="") return "";
	var year,month,day		
	var DateList=DateStr.split("/");
	year=DateList[2];
	month=DateList[1];
	day=DateList[0]
	var NewDateStr=DateList[2]+"-"+DateList[1]+"-"+DateList[0];
	return NewDateStr;
		
}

//定义页面加载方法
document.body.onload = BodyLoadHandler;
