//设备对照类型表	Mzy0018	2009-07-20
var SelectedRow = 0;
var rowid=0;
var num=0;
function BodyLoadHandler() 
{	
    InitUserInfo(); 					//系统参数
	InitEvent();	
	disabled(true);						//灰化
	SetElement("Flag",GetElementValue("FlagValue"));
}

function InitEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
	var obj=document.getElementById("BFind")
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BSaveExcel")
	if (obj) obj.onclick=BSaveExcel_Click;
	
	var obj=document.getElementById("SysDesc");
	if (obj) obj.onkeydown=SysDesc_KeyDown;
}
function BAdd_Click() 					//增加
{
	if (condition()) return;
	var encmeth=GetElementValue("SaveData");
	var plist=CombinData(); 			// 列表信息
	var result=cspRunServerMethod(encmeth,'','',plist,'0');
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		alertShow(t[-3001])
		return
	}
	alertShow("新增完成");
	//location.reload();
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQContrastInfo&TypeCode="+GetElementValue("TypeCode")+"&ContrastTypeDR="+GetElementValue("ContrastTypeDR")+"&SysDesc="+GetElementValue("SysDesc");
	if (result>0) window.location.href=lnk;
}
function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("SaveData");
	var plist=CombinData(); 			// 列表信息
	var result=cspRunServerMethod(encmeth,'','',plist,'0');
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		alertShow(t[-3001])
		return
	}
	//location.reload();
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQContrastInfo&TypeCode="+GetElementValue("TypeCode")+"&ContrastTypeDR="+GetElementValue("ContrastTypeDR")+"&SysDesc="+GetElementValue("SysDesc");
	if (result>0) window.location.href=lnk;
}
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	if (rowid=="") return;
	var encmeth=GetElementValue("SaveData");
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	//alertShow("result="+result)
	if(result=="")
	{
		alertShow(t[-3001])
		return
	}
	location.reload();
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}
function BFind_Click()
{
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQContrastInfo&TypeCode="+GetElementValue("TypeCode")+"&ContrastTypeDR="+GetElementValue("ContrastTypeDR")+"&SysDesc="+GetElementValue("SysDesc")+"&Flag="+GetElementValue("Flag");
}

function BSaveExcel_Click() 
{
	GetNum()
	if (num<1)
	{
		alertShow("表没值");
		return;
	}
	
    try
    {
	    var FileName=GetFileName();
	    //var FileName="d:\\equip.xls";
	    if (FileName=="") {return;}
      	var GetPrescPath=document.getElementById("GetRepPath");
		if (GetPrescPath)
		{
			 var encmeth=GetPrescPath.value
		} 
		else 
		{
			var encmeth=''
		}
		if (encmeth!="") 
		{
			var	TemplatePath=cspRunServerMethod(encmeth);
		}
        var xlApp,xlsheet,xlBook
	    var Template=TemplatePath+"DHCEQContrastInfo.xls";
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet;
	    
	    for (Row=1;Row<num;Row++)
	    { 
	   		var list=document.getElementById('GetList');
		 	if (list) {var encmeth=list.value} else {var encmeth=''};
			var str=cspRunServerMethod(encmeth,'','',Row);
			//alertShow("GetList="+str);
			var List=str.split("^");
			xlsheet.Rows(Row+1).Insert();
			//TContrastTypeDR_"^"_TSysID_"^"_TSysCode_"^"_TSysDesc_"^"_TExID_"^"_TExCode_"^"_TExDesc_"^"_TFromDate_"^"_TToDate_"^"_TRemark_"^"_TUnmatchFlag

			xlsheet.cells(Row+1,1)=List[0];					//类型
			xlsheet.cells(Row+1,2)=List[1];					//SYSID
			xlsheet.cells(Row+1,3)=List[2];					//编码
			xlsheet.cells(Row+1,4)=List[3];					//描述
			xlsheet.cells(Row+1,5)=List[4];					//EXID
			xlsheet.cells(Row+1,6)=List[5];					//扩展编码
			xlsheet.cells(Row+1,7)=List[6];					//扩展描述
			if(List[7]!="")
			{
				var inDay=List[7].split("/");				//开始日期
				xlsheet.cells(Row+1,8)=inDay[2]+"-"+inDay[1]+"-"+inDay[0];
			}
			if(List[8]!="")
			{
				var inDay=List[8].split("/");				//结束日期
				xlsheet.cells(Row+1,9)=inDay[2]+"-"+inDay[1]+"-"+inDay[0];
			}
			xlsheet.cells(Row+1,10)=List[9];				//备注
		}		    
	    xlBook.SaveAs(FileName);
	    //xlBook.SaveAs("D:\\cgeqipsq.xls");
	    xlBook.Close (savechanges=false);
	    xlApp.Quit();
	    xlApp=null;
	    xlsheet.Quit;
	    xlsheet=null;
	    alertShow('保存成功!');
	}
 	catch(e)
	{
		alertShow(e.message);
	}
}
function GetNum()
{
    var getnum=document.getElementById('GetNum');
	if (getnum) {var encmeth=getnum.value} else {var encmeth=''};
	num=cspRunServerMethod(encmeth,'','')
}

function disabled(value)//灰化
{
	InitEvent();
	DisableBElement("BAdd",!value);
	DisableBElement("BUpdate",value);
	DisableBElement("BDelete",value);
}

// Creator:Mozy
// Date:2009-03-21
// 增加拼音转化功能
// PYCode = GetSpellCode(ShName)
function CombinData()
{
	//TRowID^TContrastTypeDR^TSysID^TSysCode^TSysDesc^TExID^TExCode^TExDesc^TFromDate^TToDate^TRemark
	var combindata="";
    combindata=GetElementValue("RowID");
	combindata=combindata+"^"+GetElementValue("ContrastTypeDR");
  	combindata=combindata+"^"+GetElementValue("SysID");
  	combindata=combindata+"^"+GetElementValue("SysCode");
  	combindata=combindata+"^"+GetElementValue("SysDesc");
  	combindata=combindata+"^"+GetElementValue("ExID");
  	combindata=combindata+"^"+GetElementValue("ExCode");
  	combindata=combindata+"^"+GetElementValue("ExDesc");
  	combindata=combindata+"^"+GetElementValue("FromDate");
  	combindata=combindata+"^"+GetElementValue("ToDate");
  	combindata=combindata+"^"+GetElementValue("Remark");
  	
  	return combindata;
}

///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQContrastInfo');	//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)
	{
		Clear();
		disabled(true);					//灰化	
		SelectedRow=0;
	}
	else
	{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);					//调用函数
		disabled(false);				//反灰化
	}
}
function Clear()
{
	SetElement("RowID","");
	SetElement("ContrastTypeDR","");
	SetElement("SysID","");
	SetElement("SysCODE","");
	SetElement("SysDesc","");
	SetElement("ExID","");
	SetElement("ExCode","");
	SetElement("ExDesc","");
	SetElement("FromDate","");
	SetElement("ToDate","");
	SetElement("Remark","");
	SetElement("Flag","");
	SetElement("FlagValue","");
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	var list=gbldata.split("^");
	//alertShow("list="+list);
	
	SetElement("RowID",list[0]); 			// rowid
	SetElement("ContrastTypeDR",list[1]); 	// ContrastTypeDR
	SetElement("SysID",list[2]); 			// SYSID
	SetElement("SysCODE",list[3]);			// SYSCODE
	SetElement("SysDESC",list[4]);			// SYSDESC
	SetElement("ExID",list[5]);				// EXID
	SetElement("ExCODE",list[6]);			// EXCODE
	SetElement("ExDESC",list[7]);			// EXDESC
	SetElement("FromDate",list[8]);			// FromDate
	SetElement("ToDate",list[9]);			// ToDate
	SetElement("Remark",list[10]);			// Remark
	SetElement("Flag",list[11]);			// Flag
}
function SysDesc_KeyDown()
{
	if (event.keyCode==13)
	{
		//alertShow(GetElementValue("TypeCode"))
		var tmpStr=GetElementValue("TypeCode").split("-");
		if(tmpStr[1]=="Loc")
		{
			LookUpCTLoc("GetCTLoc","0,SysDesc");
		}
		if(tmpStr[1]=="Country")
		{
			LookUpCTCountry("GetCTCountry","SysDesc");
		}
	}
}
function GetCTLoc(value)
{
	//alertShow("GetCTLoc="+value);
	var list=value.split("^");
	SetElement("SysDESC",list[0]);			// SYSDESC
	SetElement("SysID",list[1]); 			// SYSID
	SetElement("SysCODE",list[2]);			// SYSCODE
}
function GetCTCountry(value)
{
	//alertShow("GetCTCountry="+value);
	var	list=value.split("^");
	SetElement("SysDESC",list[0]);			// SYSDESC
	SetElement("SysID",list[1]); 			// SYSID
	SetElement("SysCODE",list[2]);			// SYSCODE
}

function condition()//条件
{
	//if (CheckMustItemNull()) return true;
	//if (CheckItemNull(0,"Code")) return true;
	if (CheckItemNull(0,"SysDesc")) return true;

	return false;
}
document.body.onload = BodyLoadHandler;