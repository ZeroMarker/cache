document.body.onload = BodyLoadHandler;

function BodyLoadHandler() 
{
	InitUserInfo();
	InitPage();	
	FillSourceData();
	FillData();
	SetEnabled();
	OtherSet();	//说明:此函数请定义在组件对应JS文件中
}
function SetEnabled()
{
	var SourceStatus=GetElementValue("SourceStatus")
	if (SourceStatus>=1)
	{
		DisableBElement("BUpdate",true);
	}
}

function InitPage()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Clicked;
	var obj=document.getElementById("BPrint1");
	if (obj) obj.onclick=BPrint1_Clicked;
	var obj=document.getElementById("BPrint2");
	if (obj) obj.onclick=BPrint2_Clicked;
	var obj=document.getElementById("BPrint3");
	if (obj) obj.onclick=BPrint3_Clicked;
}

function FillSourceData()
{
	var SourceListID=GetElementValue("SourceListID")
	if (SourceListID=="") return
	var SourceType=GetElementValue("SourceType")
	if (SourceType=="") return
  	var encmeth=GetElementValue("FillSourceData")
  	if (encmeth=="") return;
	var ReturnStr=cspRunServerMethod(encmeth,SourceType,SourceListID);
	ReturnStr=ReturnStr.replace(/\\n/g,"\n");
	RefreshData(ReturnStr)
}

function FillData()
{
	var UserDefinedCode=GetElementValue("UserDefinedCode")
	if (UserDefinedCode=="") return
	var SourceType=GetElementValue("SourceType")
	var SourceListID=GetElementValue("SourceListID")
  	var encmeth=GetElementValue("FillData")
  	if (encmeth=="") return;
	var ReturnStr=cspRunServerMethod(encmeth,UserDefinedCode,SourceType,SourceListID);
	ReturnStr=ReturnStr.replace(/\\n/g,"\n");
	//根据元素名写元素值
	RefreshData(ReturnStr)
}

function RefreshData(ReturnStr)
{
	var FiledStr=ReturnStr.split("&")
	for (var i=0;i<FiledStr.length;i++)
	{
		var OneFiledStr=FiledStr[i]
		var FiledInfo=OneFiledStr.split("^")
		var FiledName=FiledInfo[0]
		var FiledType=FiledInfo[1]
		var FiledValue=FiledInfo[2]
		var obj=document.getElementById(FiledName);
		if (obj)
		{
			if (FiledType==3)
			{
				SetChkElement(FiledName,FiledValue)
			}
			else
			{
				SetElement(FiledName,FiledValue)
			}
		}
	}
}

function BUpdate_Clicked()
{
	if (CheckMustItemNull()) return;
	var Return=CheckData();
	if (Return==1) return
	var UserDefinedCode=GetElementValue("UserDefinedCode")
	if (UserDefinedCode=="")
	{
		alertShow("请先定义UserDefinedCode对应记录!")
		return
	}
	//总单信息
	var combindata="";
  	combindata=GetElementValue("SourceType") ;
  	combindata=combindata+"^"+GetElementValue("SourceListID") ;
  	combindata=combindata+"^"+curUserID ;
  	//明细信息
  	var encmeth=GetElementValue("GetFiledData")
  	if (encmeth=="") return;
	var ReturnStr=cspRunServerMethod(encmeth,UserDefinedCode);
	if (ReturnStr=="")
	{
		alertShow("请检查DHCEQCUserDefined和DHCEQCUserDefinedList表定义!")
		return
	}
	var valList=GetFiledData(ReturnStr)
	if (valList=="")
	{
		alertShow("无需要存储信息!")
		return
	}
  	var encmeth=GetElementValue("SaveData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,UserDefinedCode,combindata,valList);
	if (Rtn==0)
    {
	    alertShow("更新成功!")
	    var SourceID=GetElementValue("SourceID")
	    var SourceListID=GetElementValue("SourceListID")
	    var SourceStatus=GetElementValue("SourceStatus")
	    var ComponentName=GetElementValue("ComponentName")
	    var SourceType=GetElementValue("SourceType")
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT='+ComponentName+'&SourceID='+SourceID+'&SourceListID='+SourceListID+'&SourceStatus='+SourceStatus+'&SourceType='+SourceType;
	}
    else
    {
	    alertShow(t[Rtn]+"更新失败!");
	    return
    }
}

function GetFiledData(ListStr)
{
	var ReturnStr=""
	var FiledStr=ListStr.split("&")
	for (var i=0;i<FiledStr.length;i++)
	{
		var OneFiledStr=FiledStr[i]
		var FiledInfo=OneFiledStr.split("^")
		var FiledName=FiledInfo[0]
		var FiledType=FiledInfo[1]
		var obj=document.getElementById(FiledName);
		if (obj)
		{
			if (ReturnStr!="") ReturnStr=ReturnStr+"&"
			if (FiledType==3)	//选择框
			{
				ReturnStr=ReturnStr+FiledName+"^"+GetChkElementValue(FiledName)
			}
			else
			{
				ReturnStr=ReturnStr+FiledName+"^"+GetElementValue(FiledName)
			}
		}
	}
	return ReturnStr
}

function UserDefinedPrint(vUserDefinedCode,TemplateName)
{
	if (vUserDefinedCode=="")
	{
		alertShow("未定义打印vUserDefinedCode");
		return
	}
	var SourceType=GetElementValue("SourceType")
	var SourceListID=GetElementValue("SourceListID")
	if (SourceType=="")
	{
		alertShow(未定义SourceType);
		return
	}
	var encmeth=GetElementValue("GetRepPath");
	if (encmeth=="") return;
	var	TemplatePath=cspRunServerMethod(encmeth);
	
	//获取业务单据来源数据
  	var encmeth=GetElementValue("FillSourceData")
  	if (encmeth=="") return;
	var SourceDataStr=cspRunServerMethod(encmeth,SourceType,SourceListID);
	SourceDataStr=SourceDataStr.replace(/\\n/g,"\n");
	
	//获取业务单据对应自定义数据
  	var encmeth=GetElementValue("FillData")
  	if (encmeth=="") return;
	var UserDefinedStr=cspRunServerMethod(encmeth,vUserDefinedCode,SourceType,SourceListID);
	UserDefinedStr=UserDefinedStr.replace(/\\n/g,"\n");
	var xlApp,xlsheet,xlBook;
	var Template=TemplatePath+TemplateName;
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	//开始替换
	var FiledStr=SourceDataStr.split("&")
	for (var i=0;i<FiledStr.length;i++)
	{
		var OneFiledStr=FiledStr[i]
		var FiledInfo=OneFiledStr.split("^")
		var FiledName=FiledInfo[0]
		var FiledType=FiledInfo[1]
		var FiledValue=FiledInfo[2]
		var FindFlag=xlsheet.cells.find("["+FiledName+"]")
		if (FindFlag!=null)
		{
			if (FiledType==3)	//复选框
			{
				if (FiledValue==1)
				{
					FiledValue="V"
				}
				else
				{
					FiledValue="口"
				}
			}
			if (FiledType!=5)
			{
				FiledValue=GetShortName(FiledValue,"-");
			}
			if (FiledType==1)	//日期
			{
				FiledValue=ChangeDateFormat(FiledValue);
			}
			xlsheet.cells.replace("["+FiledName+"]",FiledValue);
		}
	}
	var FiledStr=UserDefinedStr.split("&")
	for (var i=0;i<FiledStr.length;i++)
	{
		var OneFiledStr=FiledStr[i]
		var FiledInfo=OneFiledStr.split("^")
		var FiledName=FiledInfo[0]
		var FiledType=FiledInfo[1]
		var FiledValue=FiledInfo[2]
		var FindFlag=xlsheet.cells.find("["+FiledName+"]")
		if (FindFlag!=null)
		{
			if (FiledType==3)	//复选框
			{
				if (FiledValue==1)
				{
					FiledValue="V"
				}
				else
				{
					FiledValue="口"
				}
			}
			if (FiledType!=5)
			{
				FiledValue=GetShortName(FiledValue,"-");
			}
			if (FiledType==1)	//日期
			{
				FiledValue=ChangeDateFormat(FiledValue);
			}
			xlsheet.cells.replace("["+FiledName+"]",FiledValue);
		}
	}
	
	var FindFlag=xlsheet.cells.find("[Hospital]");
	if (FindFlag!=null)
	{
		xlsheet.cells.replace("[Hospital]",GetElementValue("GetHospitalDesc"));
	}
	
	//xlsheet.printout; 	//打印输出
	xlApp.Visible=true
    xlsheet.PrintPreview();
	xlBook.Close (savechanges=false);
	xlsheet.Quit;
	xlsheet=null;
	xlApp=null;
}