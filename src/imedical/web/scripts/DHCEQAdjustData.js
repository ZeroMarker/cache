///----------------------------------------------
/// add by zy 2011-09-25 ZY0080
/// Description:数据调整
///----------------------------------------------

var Component="DHCEQAdjustDataA"
function BodyLoadHandler() 
{
	if (GetElementValue("UserFlag")=="false")
	{
		Component="DHCEQAdjustDataB"
		if (GetElementValue("vType")=="5")
		{
			Component="DHCEQAdjustDataC"
		}
	}
	InitUserInfo(); //系统参数
    InitElementValue();
	InitEvent();
	FillData();
	SetEnabled();
	KeyUp("LToLoc^LToEquipType^LToEquipType^LToOrigin","N");
	Muilt_LookUp("LToLoc^LToEquipType^LToEquipType^LToOrigin","N");
}
function InitElementValue()
{
	SetChkElement("ReportFlag","1")
	SetChkElement("DisplayFlag","1")
	if (GetElementValue("UserFlag")=="true")
	{
		HiddenObj("DisplayFlag",1)
		HiddenObj("cDisplayFlag",1)
		HiddenObj("Type",1)
		HiddenObj("cType",1)
		SetElement("Type","1")
	}
}
function InitEvent()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BExecute");
	if (obj) obj.onclick=BExecute_Click;
	var obj=document.getElementById("BInvalid");
	if (obj) obj.onclick=BInvalid_Click;
	var obj=document.getElementById("BImport")
	if (obj) obj.onclick=BImport_Click;
}
function SetEnabled()//灰化
{
	if (Component=="DHCEQAdjustDataA")
	{
		ReadOnlyElements("LNo^LEQStatus^LOriginalFee^LDepreTotal^LNetFee^LFromLoc^LFromEquipType^LFromStatCat^LFromOrigin^LFromInfo",true)
	}	
	var UserFlag=GetElementValue("UserFlag")   //区分普通用户和管理员界面 yes 是普通用户界面?no是管理员界面,可以批量操作
	var ImportFlag=GetElementValue("ImportFlag")  //标识批量调整的数据是否导入?Yes,是已经导入
	var Type=GetElementValue("Type")			//调整类型是新增数据时,没有作废功能
	var Status=GetElementValue("Status")
	if (Status=="")
	{
		DisableBElement("BExecute",true)
		DisableBElement("BDelete",true)
		DisableBElement("BInvalid",true)
		DisableBElement("BImport",true)
	}
	else if (Status=="0")
	{
		DisableBElement("BInvalid",true)
		if (UserFlag=="true") DisableBElement("BImport",true)
		if ((UserFlag!="true")&&(ImportFlag!="Yes")) DisableBElement("BExecute",true)
	}
	else if (Status=="1")
	{
		DisableBElement("BUpdate",true)
		DisableBElement("BDelete",true)
		DisableBElement("BExecute",true)
		DisableBElement("BImport",true)
	}
	else
	{
		DisableBElement("BUpdate",true)
		DisableBElement("BDelete",true)
		DisableBElement("BExecute",true)
		DisableBElement("BInvalid",true)
		DisableBElement("BImport",true)
	}
	if (Type=="2")
	{
		DisableBElement("BInvalid",true)
	}
	//Add By DJ 2014-12-26 DJ0133
	var vType=GetElementValue("vType");
	if (vType!="")
	{
		SetElement("Type",vType)
		if (vType=="5")
		{
			SetChkElement("ReportFlag",false);
			DisableElement("ReportFlag",true)
		}
	}
}	
function ADCombinData()
{
	var combindata="";
    combindata=GetElementValue("Type") ;							//调整类型
  	combindata=combindata+"^"+GetChkElementValue("ReportFlag") ; 	//是否影响报表
  	combindata=combindata+"^"+GetElementValue("SQL") ;				//执行命令
  	combindata=combindata+"^"+GetElementValue("SourceFile") ;		//文件
  	combindata=combindata+"^"+GetElementValue("Content") ;			//内容
  	combindata=combindata+"^"+GetElementValue("RequestUser") ; 		//要求调整人
  	combindata=combindata+"^"+GetElementValue("Remark") ; 			//备注
  	combindata=combindata+"^"+GetChkElementValue("DisplayFlag") ; 	//是否显示
  	combindata=combindata+"^"+GetElementValue("Hold1") ; 
  	combindata=combindata+"^"+GetElementValue("Hold2") ; 
  	combindata=combindata+"^"+GetElementValue("Hold3") ; 
  	combindata=combindata+"^"+GetElementValue("Hold4") ; 
  	combindata=combindata+"^"+GetElementValue("Hold5") ; 
  	return combindata;
}

function ADLCombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;						//调整记录ID
  	combindata=combindata+"^"+GetElementValue("LEquipDR") ; 	//设备
  	combindata=combindata+"^"+GetElementValue("LFromInfo") ;    //原其他信息
  	combindata=combindata+"^"+GetElementValue("LToLocDR") ;		//到科室
  	combindata=combindata+"^"+GetElementValue("LToEquipTypeDR") ;//到类组
  	combindata=combindata+"^"+GetElementValue("LToStatCatDR") ;	//到类型
  	combindata=combindata+"^"+GetElementValue("LToOriginDR") ; 	//到原值
  	combindata=combindata+"^"+GetElementValue("LToInfo") ; 		//到其他信息
  	combindata=combindata+"^"+GetElementValue("LHold1") ; 
  	combindata=combindata+"^"+GetElementValue("LHold2") ; 
  	combindata=combindata+"^"+GetElementValue("LHold3") ; 
  	combindata=combindata+"^"+GetElementValue("LHold4") ; 
  	combindata=combindata+"^"+GetElementValue("LHold5") ; 
  	combindata=combindata+"^"+GetElementValue("LHold6") ; 
  	return combindata;
}

function BUpdate_Click()
{
	if (condition()) return;
	var RowID=GetElementValue("RowID");
	var vType=GetElementValue("vType");
	var ADlist=ADCombinData();
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,RowID,ADlist);
	if (result>0) 
	{
		SetElement("RowID",result);
		if (Component=="DHCEQAdjustDataA")  //用户界面
		{
			if (GetElementValue("LEquipDR")!="")
			{
				LRowID=GetElementValue("LRowID");
				var ADLlist=ADLCombinData();
				var encmeth=GetElementValue("GetUpdateList");
				if (encmeth=="") return;
				var result=cspRunServerMethod(encmeth,LRowID,ADLlist,"0");
				if (result!=0)
				{
					alertShow("更新失败")
				}
				else
				{
					//add by HHM 20150910 HHM0013
					//添加操作成功是否提示
					ShowMessage("更新成功");
					window.location.href="websys.default.csp?WEBSYS.TCOMPONENT="+Component+"&RowID="+GetElementValue("RowID")+"&UserFlag="+GetElementValue("UserFlag") ;
				}
			}
			else
			{
				//add by HHM 20150910 HHM0013
				//添加操作成功是否提示
				ShowMessage("更新成功");
				window.location.href="websys.default.csp?WEBSYS.TCOMPONENT="+Component+"&RowID="+GetElementValue("RowID")+"&UserFlag="+GetElementValue("UserFlag") ;
			}
		}
		else
		{
			//add by HHM 20150910 HHM0013
			//添加操作成功是否提示
			ShowMessage("更新成功");
			window.location.href="websys.default.csp?WEBSYS.TCOMPONENT="+Component+"&RowID="+GetElementValue("RowID")+"&UserFlag="+GetElementValue("UserFlag")+"&vType="+vType ;
		}
	}
	else
	{
		alertShow("更新失败")
	}
}
function BDelete_Click()
{
	var truthBeTold = window.confirm("您确认要删除该记录吗?");
	if (!truthBeTold) return
	var RowID=GetElementValue("RowID");
    if (RowID=="") return;
    var vType=GetElementValue("vType");
	var encmeth=GetElementValue("GetDelete");
	if (encmeth=="")   return;
	var result=cspRunServerMethod(encmeth,RowID);
	if (result!=0)
	{
		alertShow("操作失败")
	}
	else
	{
		window.location.href="websys.default.csp?WEBSYS.TCOMPONENT="+Component+"&UserFlag="+GetElementValue("UserFlag")+"&vType="+vType ;
	}
}
function BExecute_Click() 
{
	var RowID=GetElementValue("RowID");
    if (RowID=="") return;
    var vType=GetElementValue("vType");
	var ImportFlag=GetElementValue("ImportFlag");
    if (ImportFlag!="Yes")
    {
	 	alertShow("请先导入要调整的数据!")
	 	return;   
	}
	var encmeth=GetElementValue("GetExecute");
	if (encmeth=="")   return;
	var result=cspRunServerMethod(encmeth,RowID);
	if (result!=0)
	{
		if (result=="-1000")
		{
			alertShow("设备信息已经变动,不能直接作废")
		}
		else
		{
			alertShow("操作失败")
		}
	}
	else
	{
		window.location.href="websys.default.csp?WEBSYS.TCOMPONENT="+Component+"&UserFlag="+GetElementValue("UserFlag")+"&RowID="+GetElementValue("RowID")+"&vType="+vType ;
	}
}
function BInvalid_Click() 
{
	var RowID=GetElementValue("RowID");
    if (RowID=="") return;
    var vType=GetElementValue("vType");
	var InvalidReason=GetElementValue("InvalidReason");
    if (InvalidReason=="")
    {
	    alertShow("作废原因不能为空")
	    SetFocus("InvalidReason")
	    return;
	}
	var encmeth=GetElementValue("GetInvalid");
	if (encmeth=="")   return;
	var result=cspRunServerMethod(encmeth,RowID,InvalidReason);
	if (result!=0)
	{
		if (result=="-1000")
		{
			alertShow("设备信息已经变动,不能直接作废")
		}
		else
		{
			alertShow("操作失败")
		}
	}
	else
	{
		window.location.href="websys.default.csp?WEBSYS.TCOMPONENT="+Component+"&RowID="+GetElementValue("RowID")+"&UserFlag="+GetElementValue("UserFlag")+"&vType="+vType ;
	}
}
function Clear()
{
	SetElement("RowID","");
	SetElement("Type","");
	SetElement("ReportFlag","");
	SetElement("Date","");
	SetElement("Time","");
	SetElement("SQL","");
	SetElement("SourceFile","");
	SetElement("Content","");
	SetElement("RequestUser","");
	SetElement("User","");
	SetElement("Remark","");
	SetElement("Status","");
	SetElement("DisplayFlag","");
	SetElement("UpdateUserDR","");
	SetElement("UpdateDate","");
	SetElement("UpdateTime","");
	SetElement("InvalidUserDR","");
	SetElement("InvalidDate","");
	SetElement("InvalidTime","");
	SetElement("InvalidReason","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
	
	SetElement("LRowID","");
	SetElement("LEquipDR","");
	SetElement("LFromLocDR","");
	SetElement("LFromEquipTypeDR","");
	SetElement("LFromStatCatDR","");
	SetElement("LFromOriginDR","");
	SetElement("LFromInfo","");
	SetElement("LToLocDR","");
	SetElement("LToEquipTypeDR","");
	SetElement("LToStatCatDR","");
	SetElement("LToOriginDR","");
	SetElement("LToInfo","");
	SetElement("LEQStatus","");
	SetElement("LOriginalFee","");
	SetElement("LDepreTotal","");
	SetElement("LNetFee","");
	SetElement("LHold1","");
	SetElement("LHold2","");
	SetElement("LHold3","");
	SetElement("LHold4","");
	SetElement("LHold5","");
	SetElement("LHold6","");
}

function condition()//条件
{
	if (CheckMustItemNull()) return true;
	return false;
}
function FillData()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="") return;
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,RowID);
	var list=gbldata.split("^");
	var sort=24
	SetElement("RowID",RowID);
	SetElement("Type",list[0]);
	SetChkElement("ReportFlag",list[1]);
	SetElement("Date",list[2]);
	SetElement("Time",list[3]);
	SetElement("SQL",list[4]);
	SetElement("SourceFile",list[5]);
	SetElement("Content",list[6]);
	SetElement("RequestUser",list[7]);
	SetElement("UserDR",list[8]);
	SetElement("Remark",list[9]);
	SetElement("Status",list[10]);
	SetChkElement("DisplayFlag",list[11]);
	SetElement("UpdateUserDR",list[12]);
	SetElement("UpdateDate",list[13]);
	SetElement("UpdateTime",list[14]);
	SetElement("InvalidUserDR",list[15]);
	SetElement("InvalidDate",list[16]);
	SetElement("InvalidTime",list[17]);
	SetElement("InvalidReason",list[18]);
	SetElement("Hold1",list[19]);
	SetElement("Hold2",list[20]);
	SetElement("Hold3",list[21]);
	SetElement("Hold4",list[22]);
	SetElement("Hold5",list[23]);
	
	SetElement("ImportFlag",list[24]);  //标识批量调整的数据是否导入?Yes,是已经导入
	
	SetElement("User",list[sort+2]);
	SetElement("UpdateUser",list[sort+3]);
	SetElement("InvalidUser",list[sort+4]);
	
	if (Component=="DHCEQAdjustDataB") return;  //管理员界面不用显示明细信息
	
	var LRowID=GetElementValue("LRowID");
	if ((LRowID=="")&&(RowID=="")) return
	var encmethA=GetElementValue("GetDataList");
	if (encmethA=="") return;
	var gbldata=cspRunServerMethod(encmethA,LRowID,RowID);
	if ((gbldata!="")&&((gbldata!=null)))
	{
		var list=gbldata.split("^");
		var sort=22
		SetElement("LRowID",list[0]);
		SetElement("LEquipDR",list[2]);
		SetElement("LFromLocDR",list[3]);
		SetElement("LFromEquipTypeDR",list[4]);
		SetElement("LFromStatCatDR",list[5]);
		SetElement("LFromOriginDR",list[6]);
		SetElement("LFromInfo",list[7]);
		SetElement("LToLocDR",list[8]);
		SetElement("LToEquipTypeDR",list[9]);
		SetElement("LToStatCatDR",list[10]);
		SetElement("LToOriginDR",list[11]);
		SetElement("LToInfo",list[12]);
		SetElement("LEQStatus",list[13]);
		SetElement("LOriginalFee",list[14]);
		SetElement("LDepreTotal",list[15]);
		SetElement("LNetFee",list[16]);
		SetElement("LHold1",list[17]);
		SetElement("LHold2",list[18]);
		SetElement("LHold3",list[19]);
		SetElement("LHold4",list[20]);
		SetElement("LHold5",list[21]);
		SetElement("LHold6",list[22]);
		
		SetElement("LEquip",list[sort+1]);
		SetElement("LFromLoc",list[sort+2]);
		SetElement("LFromEquipType",list[sort+3]);
		SetElement("LFromStatCat",list[sort+4]);
		SetElement("LFromOrigin",list[sort+5]);
		SetElement("LToLoc",list[sort+6]);
		SetElement("LToEquipType",list[sort+7]);
		SetElement("LToStatCat",list[sort+8]);
		SetElement("LToOrigin",list[sort+9]);	
		SetElement("LEQStatus",list[sort+10]);
		SetElement("LNo",list[sort+11]);	
	}
	
}
function GetLEquipID(value)
{
	var list=value.split("^");
	SetElement("LEquip",list[0]);
	SetElement("LEquipDR",list[1]);
	var LEquipDR=GetElementValue("LEquipDR");
	if (LEquipDR=="") return;
	var encmeth=GetElementValue("GetEquipByID");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,"","",LEquipDR);
	var list=gbldata.split("^");
	var sort=EquipGlobalLen;
	
	SetElement("LFromLocDR",list[66]);
	SetElement("LFromEquipTypeDR",list[62]);
	SetElement("LFromStatCatDR",list[4]);
	SetElement("LFromOriginDR",list[19]);
	//SetElement("LFromInfo",list[6]);
	SetElement("LToLocDR",list[66]);
	SetElement("LToEquipTypeDR",list[62]);
	SetElement("LToStatCatDR",list[74]);
	SetElement("LToOriginDR",list[19]);
	//SetElement("LToInfo","");
	SetElement("LEQStatus",list[sort+29]);
	SetElement("LOriginalFee",list[26]);
	SetElement("LDepreTotal",list[34]);
	SetElement("LNetFee",list[27]);
	SetElement("LHold1",list[16]);
	SetElement("LHold2",list[17]);
	SetElement("LHold3",list[18]);
	SetElement("LHold4",list[19]);
	SetElement("LHold5",list[20]);
	SetElement("LHold6",list[21]);
	
	SetElement("LFromLoc",list[sort+26]);
	SetElement("LFromEquipType",list[sort+22]);
	SetElement("LFromStatCat",list[sort+31])
	SetElement("LFromOrigin",list[sort+8]);
	SetElement("LToLoc",list[sort+26]);
	SetElement("LToEquipType",list[sort+22]);
	SetElement("LToStatCat",list[sort+31])
	SetElement("LToOrigin",list[sort+8]);
	SetElement("LNo",list[70]);
}
function GetLToOriginID(value)
{
	GetLookUpID("LToOriginDR",value)
}
function GetLToLocID(value)
{
	GetLookUpID("LToLocDR",value)
}

function GetLToStatCatID(value)
{
	GetLookUpID("LToStatCatDR",value)
}

function GetLToEquipTypeID(value)
{
	GetLookUpID("LToEquipTypeDR",value)
}


function BImport_Click()
{
	var Result=ImportAdjustList();
	if (Result!=0)
	{
		var encmeth=GetElementValue("KillTEMPEQ");
		if (encmeth=="") return;
		var result=cspRunServerMethod(encmeth,"0","");
		return;
	}
	var truthBeTold = window.confirm("信息无误,确定导入?");
	if (truthBeTold)
	{
		var RowID=GetElementValue("RowID");
		if (RowID=="") return;
		var encmeth=GetElementValue("KillTEMPEQ");
		if (encmeth=="") return;
		var result=cspRunServerMethod(encmeth,"1",RowID);
		var encmeth=GetElementValue("GetUpdateList");
		if (encmeth=="") return;
		var result=cspRunServerMethod(encmeth,"","","2");
		if (Result==0)
		{
			window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT='+Component+"&UserFlag="+GetElementValue("UserFlag")+"&RowID="+GetElementValue("RowID") ;
		}
	}
	else
	{
		return;
	}
}

function ImportAdjustList()
{
	var FileName=GetFileName();
    if (FileName=="") return 1;
    
	var Type=GetElementValue("Type");
	if (Type=="") return;
    var xlApp,xlsheet,xlBook
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(FileName);
    xlsheet =xlBook.Worksheets("调整数据");
    var MaxRow=xlsheet.UsedRange.Cells.Rows.Count;
    
    var count=0
	for (var Row=2;Row<=MaxRow;Row++)
	{
	    var Col=1;
	    var Name=xlsheet.cells(Row,Col++).value;
	    if (Name==undefined) Name=""
	    var No=xlsheet.cells(Row,Col++).value;
	    if (No==undefined) No=""
	    var Status=xlsheet.cells(Row,Col++).value;
	    if (Status==undefined) Status=""
	    var OriginalFee=xlsheet.cells(Row,Col++).value;
	    if (OriginalFee==undefined) OriginalFee=""
	    var DepreTotal=xlsheet.cells(Row,Col++).value;
	    if (DepreTotal==undefined) DepreTotal=""
	    var NetFee=xlsheet.cells(Row,Col++).value;
	    if (NetFee==undefined) NetFee=""
	    
	    var FromLoc=xlsheet.cells(Row,Col++).value;
	    if (FromLoc==undefined) FromLoc=""
	    var FromLocDR=""
	    var FromEquipType=xlsheet.cells(Row,Col++).value;
	    if (FromEquipType==undefined) FromEquipType=""
	    var FromEquipTypeDR=""
	    var FromStatCat=xlsheet.cells(Row,Col++).value;
	    if (FromStatCat==undefined) FromStatCat=""
	    var FromStatCatDR="";
	    var FromOrigin=xlsheet.cells(Row,Col++).value; 
	    if (FromOrigin==undefined) FromOrigin=""
	    var FromOriginDR="";
	    var ToLoc=xlsheet.cells(Row,Col++).value;
	    if (ToLoc==undefined) ToLoc=""
	    var ToLocDR="";
	    var ToEquipType=xlsheet.cells(Row,Col++).value;
	    if (ToEquipType==undefined) ToEquipType=""
	    var ToEquipTypeDR=""
	    var ToStatCat=xlsheet.cells(Row,Col++).value;
	    if (ToStatCat==undefined) ToStatCat=""
	    var ToStatCatDR="";
	    var ToOrigin=xlsheet.cells(Row,Col++).value; 
	    if (ToOrigin==undefined) ToOrigin=""
	    var ToOriginDR="";
	    if (Type==5)                                //modified by czf 2017-10-09 begin
	    {
		    var MainFlag=xlsheet.cells(Row,Col++).value;
		    if ((MainFlag=="是")||(MainFlag=="Y")) 
		    {
			    MainFlag="Y"
			}
		    else
		    {
			    MainFlag=""
			}
		    SetElement("LHold1",MainFlag);
		    if (MainFlag=="Y")
			{
				count=count+1;
			}
		}                                           //modified by czf 2017-10-09 end
	    if (No=="")
	    {
		    alertShow("第"+Row+"行"+"设备编号为空!");
		    return 1;
	    }
	    var encmeth=GetElementValue("GetEquipIDByNo");
		var EquipID=cspRunServerMethod(encmeth,No);
		if (EquipID=="")
		{
			alertShow("第"+Row+"行"+Name+"不存在!");
		    return 1;
		}
		else
		{
			SetElement("LEquipDR",EquipID);
		}
	    var encmeth=GetElementValue("CheckEquipInfo");
		if (OriginalFee!="")
		{
			result=cspRunServerMethod(encmeth,EquipID,"OriginalFee",OriginalFee);
			if (result=="0")
			{
				alertShow("第"+Row+"行"+No+"原值信息不正确:"+OriginalFee);
				return 1;
			}
		}
		if (Status!="")
		{
			result=cspRunServerMethod(encmeth,EquipID,"Status",Status);
			if (result=="0")
			{
				alertShow("第"+Row+"行"+No+"状态信息不正确:"+Status);
				return 1;
			}
		}
		if (DepreTotal!="")
		{
			result=cspRunServerMethod(encmeth,EquipID,"DepreTotal",DepreTotal);
			if (result=="0")
			{
				alertShow("第"+Row+"行"+No+"累计折旧信息不正确:"+DepreTotal);
				return 1;
			}
		}
		if (NetFee!="")
		{
			result=cspRunServerMethod(encmeth,EquipID,"NetFee",NetFee);
			if (result=="0")
			{
				alertShow("第"+Row+"行"+No+"净值信息不正确:"+NetFee);
				return 0;
			}
		}
		if (DepreTotal!="")
		{
			result=cspRunServerMethod(encmeth,EquipID,"DepreTotal",DepreTotal);
			if (result=="0")
			{
				alertShow("第"+Row+"行"+No+"累计折旧信息不正确:"+DepreTotal);
				return 1;
			}
		}
		if ((Type=="1")||(Type=="3")||(Type=="4")||(Type=="5"))
		{
			if (FromLoc!="")
			{
				result=cspRunServerMethod(encmeth,EquipID,"StoreLoc",FromLoc);
				if (result=="0")
				{
					alertShow("第"+Row+"行"+No+"原科室信息不正确:"+FromLoc);
					return 1;
				}
			}
			else
			{
				alertShow("第"+Row+"行"+No+"原科室信息为空!");
				return 1;
			}
			if (FromEquipType!="")
			{
				result=cspRunServerMethod(encmeth,EquipID,"EquipType",FromEquipType);
				if (result=="0")
				{
					alertShow("第"+Row+"行"+No+"原类组信息不正确:"+FromEquipType);
					return 1;
				}
			}
			else
			{
				alertShow("第"+Row+"行"+No+"原类组信息为空!");
				return 1;
			}
			if (FromStatCat!="")
			{
				result=cspRunServerMethod(encmeth,EquipID,"StatCat",FromStatCat);
				if (result=="0")
				{
					alertShow("第"+Row+"行"+No+"原类型信息不正确:"+FromStatCat);
					return 1;
				}
			}
			else
			{
				alertShow("第"+Row+"行"+No+"原类型信息为空!");
				return 1;
			}
			if (FromOrigin!="")
			{
				result=cspRunServerMethod(encmeth,EquipID,"Origin",FromOrigin);
				if (result=="0")
				{
					alertShow("第"+Row+"行"+No+"原来源信息不正确:"+FromOrigin);
					return 1;
				}
			}
			else
			{
				alertShow("第"+Row+"行"+No+"原来源信息为空!");
				return 1;
			}
		}
		if ((Type=="1")||(Type=="2")||(Type=="5"))
		{
			var encmeth=GetElementValue("GetIDByDesc");	
			ToLoc=trim(ToLoc)
			if (ToLoc!="")
			{
				ToLocDR=cspRunServerMethod(encmeth,"CTLoc",ToLoc);
				if (ToLocDR=="")
				{
					alertShow("第"+Row+"行"+"到科室的信息不正确:"+ToLoc);
					return 1;
				}
				else
				{
					SetElement("LToLocDR",ToLocDR);
				}
			}
			else
			{
				alertShow("第"+Row+"行"+No+"到科室信息为空!");
				return 1;
			}
			ToEquipType=trim(ToEquipType)
			if (ToEquipType!="")
			{
				ToEquipTypeDR=cspRunServerMethod(encmeth,"DHCEQCEquipType",ToEquipType);
				if (ToEquipTypeDR=="")
				{
					alertShow("第"+Row+"行"+"到类组的信息不正确:"+ToEquipType);
					return 1;
				}
				else
				{
					SetElement("LToEquipTypeDR",ToEquipTypeDR);
				}
			}
			else
			{
				alertShow("第"+Row+"行"+No+"到类组信息为空!");
				return 1;
			}
			ToStatCat=trim(ToStatCat)
			if (ToStatCat!="")
			{
				ToStatCatDR=cspRunServerMethod(encmeth,"DHCEQCStatCat",ToStatCat);
				if (ToStatCatDR=="")
				{
					alertShow("第"+Row+"行"+"到类型的信息不正确:"+ToStatCat);
					return 1;
				}
				else
				{
					SetElement("LToStatCatDR",ToStatCatDR);
				}
			}
			else
			{
				alertShow("第"+Row+"行"+No+"到类型息为空!");
				return 1;
			}
			ToOrigin=trim(ToOrigin)
			if (ToOrigin!="")
			{
				ToOriginDR=cspRunServerMethod(encmeth,"DHCEQCOrigin",ToOrigin);
				if (ToOriginDR=="")
				{
					alertShow("第"+Row+"行"+"到来源的信息不正确:"+ToOrigin);
					return 1;
				}
				else
				{
					SetElement("LToOriginDR",ToOriginDR);
				}
			}
			else
			{
				alertShow("第"+Row+"行"+No+"到来源息为空!");
				return 1;
			}
		}
		var ADLlist=ADLCombinData();
		var encmeth=GetElementValue("GetUpdateList");
		if (encmeth=="") return;
		var result=cspRunServerMethod(encmeth,"",ADLlist,"1");
		//alertShow(result)
		if (result!=0)
		{
			var encmeth=GetElementValue("KillTEMPEQ");
			if (encmeth=="") return;
			var Rtn=cspRunServerMethod(encmeth,"0","");
			alertShow("第"+Row+"行写入失败!")
			return result
		}
	}
	if (Type==5)               //modified by czf 2017-10-09 begin
	{
		if (count==0) 
		{
			alertShow("未设置主设备");
			return 1;
		}
		if (count>1) 
		{
			alertShow("主设备不唯一");
			return 1;
		}
	}                         //modified by czf 2017-10-09 end
    xlBook.Close (savechanges=false);
    xlApp.Quit();
    xlApp=null;
    xlsheet.Quit;
    xlsheet=null;
    return 0
}
document.body.onload = BodyLoadHandler;
