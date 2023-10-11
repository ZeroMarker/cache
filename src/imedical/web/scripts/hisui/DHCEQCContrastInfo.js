//设备对照类型表
var SelectedRow = -1; //hisui改造 add by zc 2018-08-31
var rowid=0;
var num=0;
function BodyLoadHandler() 
{	
    InitUserInfo(); 					//系统参数
	InitEvent();
	disabled(true);						//灰化
	initButtonWidth()  //hisui改造 add by zc 2018-08-31
	SetElement("Flag",GetElementValue("FlagValue"));
	SetElement("DataType",GetElementValue("DataType"));  //hisui改造： add by zc 2018-09-04
	LookupDataType(GetElementValue("DataType"))	   //hisui改造：初始化描述下拉框 add by zc 2018-09-04
	//singlelookup("SysDesc","PLAT.L.Origin","",GetCTOrigin)  //hisui改造：初始化来源下拉框 add by zc 2018-09-04
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
	//hisui改造 modify by zc 2018-08-31 begin
	//var obj=document.getElementById("SysDesc");
	//if (obj) obj.onkeydown=SysDesc_KeyDown;
	//var obj=document.getElementById(GetLookupName("SysDesc"));
	//if (obj) obj.onclick=LookupDataType;
	//hisui改造 modify by zc 2018-08-31 end
}
function BAdd_Click() 					//增加
{
	if (condition()) return;
	if (GetElementValue("SysID")=="")
	{
		alertShow("请选择<描述>信息.");
		return;
	}
	var encmeth=GetElementValue("SaveData");
	var plist=CombinData(); 			// 列表信息
	var result=cspRunServerMethod(encmeth,'','',plist,'0');
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		messageShow("","","",t[-3001])
		return
	}
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCContrastInfo&DataType="+GetElementValue("DataType")+"&ContrastTypeDR="+GetElementValue("ContrastTypeDR")//+"&SysDesc="+GetElementValue("SysDesc");
	if (result>0)
	{
		alertShow("新增完成!");
		window.location.href=lnk;
	}
}
function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("SaveData");
	var plist=CombinData();
	var result=cspRunServerMethod(encmeth,'','',plist,'0');
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		messageShow("","","",t[-3001])
		return
	}
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCContrastInfo&DataType="+GetElementValue("DataType")+"&ContrastTypeDR="+GetElementValue("ContrastTypeDR")//+"&SysDesc="+GetElementValue("SysDesc");
	if (result>0)
	{
		alertShow("更新成功!")
		window.location.href=lnk;
	}
}
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	if (rowid=="") return;
	var encmeth=GetElementValue("SaveData");
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		messageShow("","","",t[-3001])
		return
	}
	else
	{
		alertShow("删除成功!")
		location.reload();
	}
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}
function BFind_Click()
{
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCContrastInfo&DataType="+GetElementValue("DataType")+"&ContrastTypeDR="+GetElementValue("ContrastTypeDR")+"&SysDesc="+GetElementValue("SysDesc")+"&Flag="+GetElementValue("Flag")+"&ExID="+GetElementValue("ExID")+"&ExCode="+GetElementValue("ExCode")+"&ExDesc="+GetElementValue("ExDesc")+"&FromDate="+GetElementValue("FromDate")+"&ToDate="+GetElementValue("ToDate");  //modifed by kdf 2016-11-09
}
function BSaveExcel_Click()
{
	if (GetElementValue("ChromeFlag")=="1")
	{
		BSaveChrome_Click()
	}
	else
	{
		BSaveExcel_IE()
	}
}
function BSaveChrome_Click()
{
	GetNum()
	if (num<1)
	{
		alertShow("表没值");
		return;
	}
	
	var FileName=GetFileName();
	if (FileName=="") {return;}
	var NewFileName=filepath(FileName,"\\","\\\\")
	var NewFileName=NewFileName.substr(0,NewFileName.length-4)
		
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
	
	var AllListInfo=new Array();
	for (Row=1;Row<=num;Row++)
    { 
   		var list=document.getElementById('GetList');
	 	if (list) {var encmeth=list.value} else {var encmeth=''};
		var OneDetail=cspRunServerMethod(encmeth,'','',Row);
		var OneDetailList=OneDetail.split("^");
		AllListInfo.push(OneDetail)
    }
    
	///Chrome兼容性处理
	var Str ="(function test(x){"
	Str +="var xlApp,xlsheet,xlBook;"
	Str +="var Template='"+TemplatePath+"DHCEQContrastInfo.xls';";
	Str +="xlApp = new ActiveXObject('Excel.Application');"
	Str +="xlBook = xlApp.Workbooks.Add(Template);"
	Str +="xlsheet = xlBook.ActiveSheet;"
	Str +="var AllListInfoStr='"+AllListInfo+"';"
	Str +="var AllListInfo=AllListInfoStr.split(',');"
	Str +="for (Row=1;Row<="+num+";Row++){"
	Str +="var OneDetailList=AllListInfo[Row-1].split('^');"
	Str +="xlsheet.Rows(Row+1).Insert();"
	Str +="xlsheet.cells(Row+1,1)=OneDetailList[0];"					//类型
	Str +="xlsheet.cells(Row+1,2)=OneDetailList[1];"					//SYSID
	Str +="xlsheet.cells(Row+1,3)=OneDetailList[2];"					//编码
	Str +="xlsheet.cells(Row+1,4)=OneDetailList[3];"					//描述
	Str +="xlsheet.cells(Row+1,5)=OneDetailList[4];"					//EXID
	Str +="xlsheet.cells(Row+1,6)=OneDetailList[5];"					//扩展编码
	Str +="xlsheet.cells(Row+1,7)=OneDetailList[6];"					//扩展描述
	Str +="xlsheet.cells(Row+1,8)=OneDetailList[7];"
	Str +="xlsheet.cells(Row+1,9)=OneDetailList[8];"
	Str +="xlsheet.cells(Row+1,10)=OneDetailList[9];}"				//备注
	Str +="var savefile='"+NewFileName+".xls';"
	Str +="xlBook.SaveAs(savefile);"
	Str +="xlBook.Close (savechanges=false);"
	Str +="xlApp.Quit();"
	Str +="xlApp=null;"
	Str +="xlsheet.Quit;"
	Str +="xlsheet=null;"
	Str +="return 1;}());";
	//以上为拼接Excel打印代码为字符串
	CmdShell.notReturn = 0;   //设置无结果调用，不阻塞调用
	var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序
	alertShow("导出完成!");
}
function BSaveExcel_IE() 
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
	    
	    for (Row=1;Row<=num;Row++)
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
				//xlsheet.cells(Row+1,8)=inDay[2]+"-"+inDay[1]+"-"+inDay[0];
				xlsheet.cells(Row+1,8)=List[7];  //hisui改造 modify by zc 2018-08-31
			}
			if(List[8]!="")
			{
				var inDay=List[8].split("/");				//结束日期
				//xlsheet.cells(Row+1,9)=inDay[2]+"-"+inDay[1]+"-"+inDay[0];
				xlsheet.cells(Row+1,9)=List[8];  //hisui改造 modify by zc 2018-08-31
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
		messageShow("","","",e.message);
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
///modify by by zc 2018-08-31
///描述：hisui改造 更改值获取方式 并添加入参
///入参：index 行号
///      rowdata 行json数据
function SelectRowHandler(index,rowdata)
{
	if (SelectedRow==index)
	{
		Clear();
		disabled(true);					//灰化	
		SelectedRow=-1;  //hisui改造 add by zc 2018-08-31
		$('#tDHCEQCContrastInfo').datagrid('unselectAll');  //hisui改造 add by zc 2018-08-31
	}
	else
	{
		SelectedRow=index;
		rowid=rowdata.TRowID;			//hisui改造 add by zc 2018-08-31
		SetData(rowid);					//调用函数
		disabled(false);				//反灰化
	}
}
function Clear()
{
	SetElement("RowID","");
	//SetElement("ContrastTypeDR","");
	SetElement("SysID","");
	SetElement("SysCode","");
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
	SetElement("SysCode",list[3]);			// SYSCODE
	SetElement("SysDesc",list[4]);			// SYSDESC
	SetElement("ExID",list[5]);				// EXID
	SetElement("ExCode",list[6]);			// EXCODE
	SetElement("ExDesc",list[7]);			// EXDESC
	SetElement("FromDate",list[8]);			// FromDate
	SetElement("ToDate",list[9]);			// ToDate
	SetElement("Remark",list[10]);			// Remark
	SetElement("Flag",list[11]);			// Flag
}

//hisui改造 add by zc 2018-09-03
function LookupDataType(DataType)
{
	if(DataType=="dept")
	{
		//LookUpCTLoc("GetCTLoc","0,SysDesc");
		singlelookup("SysDesc","PLAT.L.Loc","",GetCTLoc)  //hisui改造：初始化描述下拉框 add by zc 2018-09-03
	}
	if(DataType=="cou")
	{
		//LookUpCTCountry("GetCTCountry","SysDesc");
		singlelookup("SysDesc","PLAT.L.Country","",GetCTLoc)  //hisui改造：初始化描述下拉框 add by zc 2018-09-03
	}
	if(DataType=="user")
	{
		//LookUpCTUser("GetCTUser","SysDesc");
		singlelookup("SysDesc","PLAT.L.SSUser","",GetCTUser)  //hisui改造：初始化描述下拉框 add by zc 2018-09-03  // modied by kdf 2018-12-29 需求号790219
	}
	if(DataType=="prov")
	{
		//LookUpCTVendor("GetCTVendor","SysDesc");
		singlelookup("SysDesc","PLAT.L.Vendor","",GetCTLoc)  //hisui改造：初始化描述下拉框 add by zc 2018-09-03
	}
	if(DataType=="uom")
	{
		//LookUpCTUom("GetCTUom","SysDesc,UnitType");
		singlelookup("SysDesc","PLAT.L.UOM","",GetCTLoc)  //hisui改造：初始化描述下拉框 add by zc 2018-09-03
	}
	if(DataType=="orign")
	{
		//LookUpCTOrigin("GetCTOrigin","SysDesc");
		singlelookup("SysDesc","PLAT.L.Origin","",GetCTLoc)  //hisui改造：初始化描述下拉框 add by zc 2018-09-03
	}
	if(DataType=="buy")
	{
		//LookUpCTBuyType("GetCTBuyType","SysDesc");
		singlelookup("SysDesc","PLAT.L.BuyType","",GetCTLoc)	//hisui改造：初始化描述下拉框 add by zc 2018-09-03
	}
	if(DataType=="cat")
	{
		//LookUpCTEquipCat("GetCTEquipCat","SysDesc");
		singlelookup("SysDesc","EM.L.EquipCat","",GetCTLoc)	//hisui改造：初始化描述下拉框 add by zc 2018-09-03
	}
}

//hisui改造：初始化描述下拉框 add by zc 2018-09-03
function GetCTLoc(item)
{
	SetElement("SysDesc",item.TName);			// SYSDESC
	SetElement("SysID",item.TRowID); 			// SYSID
	SetElement("SysCode",item.TCode);			// SYSCODE
}

//hisui改造：初始化描述下拉框 add by kdf 2018-12-29 需求号790219
function GetCTUser(item)
{
	SetElement("SysDesc",item.TUserName);			// SYSDESC
	SetElement("SysID",item.TRowID); 			// SYSID
	SetElement("SysCode",item.TInitials);			// SYSCODE
}

function condition()//条件
{
	//if (CheckMustItemNull()) return true;
	//if (CheckItemNull(0,"Code")) return true;
	if (CheckItemNull(0,"SysDesc")) return true;

	return false;
}
document.body.style.padding="10px 10px 10px 5px"  // hisui-调整 add by kdf 2018-11-09 设置面板内边距 
document.body.onload = BodyLoadHandler;