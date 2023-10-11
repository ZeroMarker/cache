///----------------------------------------------
/// add by zy 2011-09-25 ZY0080
/// Description:数据调整
///----------------------------------------------
///hisui 改造 add by wy 2019-10-30
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
	initPanelHeaderStyle();
	initButtonColor();//cjc 2023-01-18 设置极简积极按钮颜色
	hidePanelTitle();//cjc 2023-02-01 隐藏标题面版
}
function InitElementValue()
{
	SetChkElement("ReportFlag","1")
	SetChkElement("DisplayFlag","1")
	if (GetElementValue("UserFlag")=="true")
	{
		HiddenObj("DisplayFlag",1)
		HiddenObj("cDisplayFlag",1)
		//modfied by wy 2019-12-16 需求1135725
		//HiddenObj("Type",1)
		//HiddenObj("cType",1)
		DisableElement("Type",true)
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
	var obj=document.getElementById("BPrint")	//czf 2021-01-24
	if (obj) obj.onclick=BPrint_Click;
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
		DisableBElement("BPrint",true)	//czf 2022-01-24
	}
	else if (Status=="0")
	{
		DisableBElement("BInvalid",true)
		if (UserFlag=="true") DisableBElement("BImport",true)
		if ((UserFlag!="true")&&(ImportFlag!="Yes")) DisableBElement("BExecute",true)
		DisableBElement("BPrint",true)	//czf 2022-01-24
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
		DisableBElement("BPrint",true)	//czf 2022-01-24
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
					var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+Component+"&RowID="+GetElementValue("RowID")+"&UserFlag="+GetElementValue("UserFlag") ;
					if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
						url += "&MWToken="+websys_getMWToken()
					}
					window.location.href=url;
				}
			}
			else
			{
				//add by HHM 20150910 HHM0013
				//添加操作成功是否提示
				ShowMessage("更新成功");
				var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+Component+"&RowID="+GetElementValue("RowID")+"&UserFlag="+GetElementValue("UserFlag") ;
				if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
					url += "&MWToken="+websys_getMWToken()
				}
				window.location.href=url;
			}
		}
		else
		{
			//add by HHM 20150910 HHM0013
			//添加操作成功是否提示
			ShowMessage("更新成功");
			var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+Component+"&RowID="+GetElementValue("RowID")+"&UserFlag="+GetElementValue("UserFlag")+"&vType="+vType ;
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				url += "&MWToken="+websys_getMWToken()
			}
			window.location.href=url
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
		var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+Component+"&UserFlag="+GetElementValue("UserFlag")+"&vType="+vType ;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href=url;
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
		var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+Component+"&UserFlag="+GetElementValue("UserFlag")+"&RowID="+GetElementValue("RowID")+"&vType="+vType ;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href=url;
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
		var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+Component+"&RowID="+GetElementValue("RowID")+"&UserFlag="+GetElementValue("UserFlag")+"&vType="+vType ;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href=url;
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
///add by mwz 20211115 mwz0053 
///增加chrome浏览器导入方法
function BImport_Click()
{
	var ChromeFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo", "991109")
	if (ChromeFlag==1)
	{
		BImportChrome_Click()
	}
	else
	{
		BImportIE_Click()
	}
}
///add by mwz 20211115 mwz0053 
///增加chrome浏览器导入方法
function BImportChrome_Click()
{
	var RowInfos=EQReadExcel('','','调整数据');
	var Error=""
	var Type=GetElementValue("Type");
	if (Type=="") return;
	var RowInfo=RowInfos[0]   //取第一个页签的数组
	if ((RowInfo=="")||(RowInfo.length<=1))		
	{
		alertShow("没有数据导入！")
		return -1;
	}
	for (var Row=2;Row<=RowInfo.length;Row++)
	{	
	 	var Col=0;
	    var Name=trim(RowInfo[Row-1][Col++]);
	    if (Name==undefined) Name=""
	    var No=trim(RowInfo[Row-1][Col++]);
	    if (No==undefined) No=""
	    var Status=trim(RowInfo[Row-1][Col++]);
	    if (Status==undefined) Status=""
	    var OriginalFee=trim(RowInfo[Row-1][Col++]);
	    if (OriginalFee==undefined) OriginalFee=""
	    var DepreTotal=trim(RowInfo[Row-1][Col++]);
	    if (DepreTotal==undefined) DepreTotal=""
	    var NetFee=trim(RowInfo[Row-1][Col++]);
	    if (NetFee==undefined) NetFee=""
	    
	    var FromLoc=trim(RowInfo[Row-1][Col++]);
	    if (FromLoc==undefined) FromLoc=""
	    var FromLocDR=""
	    var FromEquipType=trim(RowInfo[Row-1][Col++]);
	    if (FromEquipType==undefined) FromEquipType=""
	    var FromEquipTypeDR=""
	    var FromStatCat=trim(RowInfo[Row-1][Col++]);
	    if (FromStatCat==undefined) FromStatCat=""
	    var FromStatCatDR="";
	    var FromOrigin=trim(RowInfo[Row-1][Col++]); 
	    if (FromOrigin==undefined) FromOrigin=""
	    var FromOriginDR="";
	    var ToLoc=trim(RowInfo[Row-1][Col++]);
	    if (ToLoc==undefined) ToLoc=""
	    var ToLocDR="";
	    var ToEquipType=trim(RowInfo[Row-1][Col++]);
	    if (ToEquipType==undefined) ToEquipType=""
	    var ToEquipTypeDR=""
	    var ToStatCat=trim(RowInfo[Row-1][Col++]);
	    if (ToStatCat==undefined) ToStatCat=""
	    var ToStatCatDR="";
	    var ToOrigin=trim(RowInfo[Row-1][Col++]); 
	    if (ToOrigin==undefined) ToOrigin=""
	    var ToOriginDR="";
	    if (Type==5)                                
	    {
		    var MainFlag=trim(RowInfo[Row-1][Col++]);
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
		}                                          
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
	if (Type==5)              
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
	}         
	if (result!=0)
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
		if (result==0)
		{
			var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT='+Component+"&UserFlag="+GetElementValue("UserFlag")+"&RowID="+GetElementValue("RowID") ;
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				url += "&MWToken="+websys_getMWToken()
			}
			window.location.href= url;
		}
	}
	else
	{
		return;
	}
}

function BImportIE_Click()
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
		if (result==0)
		{
			var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT='+Component+"&UserFlag="+GetElementValue("UserFlag")+"&RowID="+GetElementValue("RowID") ;
			if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
				url += "&MWToken="+websys_getMWToken()
			}
			window.location.href= url;
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

function BPrint_Click()
{
	var RowID=GetElementValue("RowID");
	var LRowID=GetElementValue("LRowID");
	if ((LRowID=="")&&(RowID=="")) return
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,RowID);
	var list=gbldata.split("^");
	var sort=24
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCEQAdjustData");
	var LODOP = getLodop();
	var c2=String.fromCharCode(2);
	//var Img="data:image/png;base64,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"
	var curSSHospitalName=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990003")
	var inpara="EQTitle"+c2+curSSHospitalName+"数据调整单";
	inpara+="^EQName"+c2+GetElementValue("LEquip");
	inpara+="^EQNo"+c2+GetElementValue("LNo");
	inpara+="^EQStatus"+c2+GetElementValue("LEQStatus");
	inpara+="^OriginalFee"+c2+GetElementValue("LOriginalFee");
	inpara+="^NetFee"+c2+GetElementValue("LNetFee");
	inpara+="^DepreTotalFee"+c2+GetElementValue("LDepreTotal");
	inpara+="^FromLoc"+c2+GetElementValue("LFromLoc");
	inpara+="^FromEquipType"+c2+GetElementValue("LFromEquipType");
	inpara+="^FromStatCat"+c2+GetElementValue("LFromStatCat");
	inpara+="^ToLoc"+c2+GetElementValue("LToLoc");
	inpara+="^ToEquipType"+c2+GetElementValue("LToEquipType");
	inpara+="^ToStatCat"+c2+GetElementValue("LToStatCat");
	inpara+="^FromOrigin"+c2+GetElementValue("LFromOrigin");
	inpara+="^ToOrigin"+c2+GetElementValue("LToOrigin");
	inpara+="^RequestUser"+c2+GetElementValue("RequestUser");
	inpara+="^AdjustDate"+c2+list[2];
	inpara+="^AdjustContent"+c2+GetElementValue("Content");
	inpara+="^Remark"+c2+GetElementValue("Remark");
	inpara+="^AdjustUser"+c2+list[sort+2];
	inpara+="^PrintDate"+c2+GetCurrentDate(2);
	DHC_PrintByLodop(LODOP,inpara,"","","",{printListByText:true});
}
document.body.onload = BodyLoadHandler;
