
//装载页面  函数名称固定
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//初始化
	KeyUp("MasterItem^EquipCat^UseLoc^EquipType^StatCat");	//清空选择	
	Muilt_LookUp("MasterItem^EquipCat^UseLoc^EquipType^StatCat");
}

function InitEvent() //初始化
{
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
	var obj=document.getElementById(GetLookupName("EquipCat"));
	if (obj) obj.onclick=EquipCat_Click;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
}

function BClear_Click() //清空按钮
{
	SetElement("MasterItem","");  
	SetElement("MasterItemDR","");
	SetElement("MinValue","");
	SetElement("MaxValue","");
	SetElement("StatCat","");
	SetElement("StatCatDR","");
	SetElement("EquipType","");
	SetElement("EquipTypeDR","");
	SetElement("EquipCat","");
	SetElement("EquipCatDR","");
	SetElement("UseLoc","");
	SetElement("UseLocDR","");
	SetChkElement("IncludeFlag","");
}
///打印报表
function BPrint_Click()
{
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	var encmeth=GetElementValue("GetEquipDistributionReport");
	var TotalRows=cspRunServerMethod(encmeth,0);
	var PageRows=30                          //每页固定行数
	var Pages=parseInt(TotalRows/PageRows)   //总页数  
	var ModRows=TotalRows%PageRows           //最后一页行数
	if (ModRows==0) Pages=Pages-1		
    try {
		var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQEquipDistribution.xls";
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
		    	xlsheet.cells(j,1)=OneDetailList[1];	///设备名称
		    	xlsheet.cells(j,2)=OneDetailList[2];	///设备项
		    	xlsheet.cells(j,3)=OneDetailList[3];	///设备类组	    	
		    	xlsheet.cells(j,4)=OneDetailList[4];	///设备分类
		    	xlsheet.cells(j,5)=OneDetailList[5];	///设备类型	
		    	xlsheet.cells(j,6)=OneDetailList[6];	///设备原值		    	
		    	xlsheet.cells(j,7)=OneDetailList[7];	///使用科室		    	
			}	
			if (GetElementValue("EquipType")=="") //设备类组
			{
				if (GetElementValue("StatCat")=="") ///设备类型
			   {
				    xlsheet.cells(1,1)="在用设备分布统计报表"
			   }
			    else
			   {
				    xlsheet.cells(1,1)="在用设备分布统计报表("+GetElementValue("StatCat")+")"
			   }	
			}
			else
			{
				if (GetElementValue("StatCat")=="") 
			   {
				    xlsheet.cells(1,1)="在用设备分布统计报表("+GetElementValue("EquipType")+")"
			   }
			    else
			   {
				    xlsheet.cells(1,1)="在用设备分布统计报表("+GetElementValue("EquipType")+"-"+GetElementValue("StatCat")+")"
			   }
			}	
			if (GetElementValue("EquipCat")=="") ///设备分类
			{
				 if (GetElementValue("MasterItem")=="") //设备项
			    {
				    xlsheet.cells(2,1)=""
			    }
			    else
			    {
				    xlsheet.cells(2,1)="设备项:"
				    xlsheet.cells(2,2)=GetElementValue("MasterItem")
			    }	
			}
			else
			{
				 if (GetElementValue("MasterItem")=="") //设备项
			    {
				    xlsheet.cells(2,1)="设备分类:"
				    xlsheet.cells(2,2)=GetElementValue("EquipCat")
			    }
			    else
			    {
				    xlsheet.cells(2,1)="设备分类/设备项:"
				    xlsheet.cells(2,2)=GetElementValue("EquipCat")+"/"+GetElementValue("MasterItem")
			    }
			}
			if (GetElementValue("UseLoc")=="") //使用科室
			{
				xlsheet.cells(2,4)=""
			}
			else
			{
				xlsheet.cells(2,4)="使用科室:"+GetElementValue("UseLoc")
			}			
			if (GetElementValue("MinValue")=="") //设备原值范围
			{
				if (GetElementValue("MaxValue")=="") //设备原值范围
			    {
				xlsheet.cells(2,6)=""
			    }
			    else
			    {				    
				xlsheet.cells(2,6)="金额范围:"
				xlsheet.cells(2,7)="<="+GetElementValue("MaxValue")
			    }
			}
			else
			{
				if (GetElementValue("MaxValue")=="") //设备原值范围
			    {
				xlsheet.cells(2,6)="金额范围:"
				xlsheet.cells(2,7)=">="+GetElementValue("MinValue")
			    }
			    else
			    {				    
				xlsheet.cells(2,6)="金额范围:"
				xlsheet.cells(2,7)="从"+GetElementValue("MinValue")+"到"+GetElementValue("MaxValue")
			    }
			}		
			xlsheet.Rows(j+1).Delete();	
			xlsheet.cells(j+1,1)="制表人:"+curUserName			
			xlsheet.cells(j+1,4)="制表日期:"+FormatDate(GetCurrentDate())			
			xlsheet.cells(j+1,7)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页"
	    	xlsheet.printout; //打印输出
	    	//xlsheet.PrintPreview 	
	    	//xlBook.SaveAs("D:\DHCEQCEmployeeType.xls");    	
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
///取得设备箱rowid
function GetMasterItem(value)
{
	var obj=document.getElementById("MasterItemDR");
	var val=value.split("^");
	if (obj) obj.value=val[1];
}
///取得设备类组rowid
function GetEquipType(value)
{
	var obj=document.getElementById("EquipTypeDR");
	var val=value.split("^");
	if (obj) obj.value=val[1];
}
function EquipCat_Click()
{
	var CatName=GetElementValue("EquipCat")
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCEquipCatTree&Type=SelectTree&CatName="+CatName;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
}

function SetEquipCat(id,text)
{
	SetElement("EquipCat",text);
	SetElement("EquipCatDR",id);
}
//取得设备分类rowid
function GetEquipCat(value)
{
	var obj=document.getElementById("EquipCatDR");
	var val=value.split("^");
	if (obj) obj.value=val[1];
}


///取得设备类型rowid
function GetStatCat(value) 
{	
	var obj=document.getElementById("StatCatDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}
///取得设备使用科室rowid
function GetUseLoc(value)
{
	var obj=document.getElementById("UseLocDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}


function BFind_Click()
{
	var flag=GetChkElementValue("IncludeFlag")
	if (flag==false)
	{
		flag=""
	}
	else
	{
		flag=1
	}
	var val="&MasterItemDR="+GetElementValue("MasterItemDR");
	val=val+"&EquipTypeDR="+GetElementValue("EquipTypeDR");
	val=val+"&UseLocDR="+GetElementValue("UseLocDR");
	val=val+"&EquipCatDR="+GetElementValue("EquipCatDR");
	val=val+"&StatCatDR="+GetElementValue("StatCatDR");
	val=val+"&MinValue="+GetElementValue("MinValue");
	val=val+"&MaxValue="+GetElementValue("MaxValue");
	val=val+"&IncludeFlag="+flag;
	val=val+"&QXType="+GetElementValue("QXType");
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQEquipDistribution"+val;
}


//定义页面加载方法
document.body.onload = BodyLoadHandler;
