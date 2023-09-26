
function BodyLoadHandler(){		
	InitPage();
	SetStatus();
	Muilt_LookUp("FromLoc^ToLoc^Model");
	SetElement("MoveType",GetElementValue("MoveTypeID"));
}

function SetStatus()
{
	SetElement("Status",GetElementValue("StatusDR"))
}
function InitPage()
{
	KeyUp("FromLoc^ToLoc^Model^EquipType^EquipCat");
	var obj=document.getElementById(GetLookupName("EquipCat"));
	if (obj) obj.onclick=EquipCat_Click;
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
}
function BPrint_Click()
{
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	var encmeth=GetElementValue("GetOneStoreMoveDetail");
	var TotalRows=cspRunServerMethod(encmeth,0);
	
	var PageRows=43 //每页固定行数
	var Pages=parseInt(TotalRows / PageRows) //总页数-1  
	var ModRows=TotalRows%PageRows //最后一页行数
	if (ModRows==0) Pages=Pages-1
	
	try {
		//   0            1             2            3             4         5          6             7               8             9              10            11          12         13             14           15                16             17          18         19            20              
		//TSMRowID_"^"_TFromLocDR_"^"_TFromLoc_"^"_TToLocDR_"^"_TToLoc_"^"_TSMNo_"^"_TMoveDate_"^"_TStatCatDR_"^"_TStatCat_"^"_TEquipTypeDR_"^"_TEquipType_"^"_TStatus_"^"_TEquipName_"^"_TModelDR_"^"_TModel_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TUnitDR_"^"_TUnit_"^"_TTotalFee_"^"_TEquipCat
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQStoreMoveDetailSP.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    
	    for (var i=0;i<=Pages;i++)
	    {
	    	xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	//xlsheet.PageSetup.LeftMargin=0;  //lgl+
	    	//xlsheet.PageSetup.RightMargin=0;
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
		    	xlsheet.cells(j,1)=OneDetailList[12];
		    	if (l==TotalRows) xlsheet.cells(j,1)="总计:";
		    	var ToLocList=OneDetailList[4].split("-");
		    	if (ToLocList[1]!="")
		    	{
			    	var ToLoc=ToLocList[1];
		    	}
		    	else
		    	{
			    	var ToLoc=OneDetailList[4]
		    	}
		    	xlsheet.cells(j,2)=ToLoc;
		    	xlsheet.cells(j,3)=OneDetailList[14];
		    	xlsheet.cells(j,4)=OneDetailList[15];
		    	xlsheet.cells(j,5)=OneDetailList[16];
		    	xlsheet.cells(j,6)=OneDetailList[19];
			}
			xlsheet.Rows(j+1).Delete();
			xlsheet.cells(j+1,1)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页"
			xlsheet.cells(2,1)="时间范围:"+GetElementValue("StartDate")+"--"+GetElementValue("EndDate")
			xlsheet.cells(2,4)="制表人:"+curUserName
	    	xlsheet.printout; //打印输出
	    	//xlBook.SaveAs("D:\\DHCEQStoreMoveDetailSP"+i+".xls");   //lgl+
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
function GetFromLoc(value)
{
	GetLookUpID("FromLocDR",value);
}

function GetModel(value)
{
	GetLookUpID("ModelDR",value);
}
function GetToLoc(value)
{
	GetLookUpID("ToLocDR",value);
}
function GetEquipType(value)
{
	GetLookUpID("EquipTypeDR",value);
}
function GetStatCat(value)
{
	GetLookUpID("StatCatDR",value);
}
function GetEquipCat(value)
{
	GetLookUpID("EquipCatDR",value);
}
document.body.onload = BodyLoadHandler;