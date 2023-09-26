/// ----------------------------------
/// 修改：HZY 2011-09-26 HZY0012
/// 修改方法：GetTrakNameByID ,在最后判断不存在时,返回空.
/// ----------------------------------
/// 修改:zy 2009-12-02  No ZY0018
/// 添加方法:GetSysInfo,GetDefaultOrigin 取系统配置参数
/// --------------------------------------------------
/// Modified by jdl 2009-08-04 JDL0021
/// Add method IdInIds判断Id是否存在于Ids中
/// --------------------------------------------------
/// Modified by jdl 2009-06-04 JDL0009
/// Add method GetCurTime增加公共函数获取当前服务器时间
/// -------------------------------------------------
Class web.DHCEQCommon Extends %RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 245;

/// WriteFile(fileName As %String, content As %String)
/// Replace(expression As %String, find As %String, replacewith As %String)
/// EndWith(expression As %String, find As %String)	
/// ClassMethod GetTrakNameByID(tablename As %Library.String, id As %Library.String)
ClassMethod EndWith(expression As %String, find As %String)
{
	
	if ($FIND(expression,find,$LENGTH(expression)-$LENGTH(find)+1)>0) Quit 1
	Quit 0
}

ClassMethod Replace(expression As %String, find As %String, replacewith As %String) As %String [ Language = basic ]
{
	return Replace(expression,find,replacewith)
}

ClassMethod Trim(expression As %String) As %String [ Language = basic ]
{
	return Trim(expression)
}

ClassMethod WriteFile(fileName As %String, content As %String, isNew As %String)
{
	new results,opentype
	///If ##class(%File).Exists(fileName) Write "It exists",!
	Set file=##class(%File).%New(fileName)
	set opentype="WS"
	if (isNew=1) set opentype="WSN"
	Do file.Open(opentype)
	set results = file.Write(content)
	if (results'=1) d ##class(%File).Delete(fileName)
	d file.Close()
	q results
}

ClassMethod ReadFile(fileName As %String)
{
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=fileName
	While 'stream.AtEnd {
	Set line=stream.ReadLine()
	w line,!
	; Process the line here
	}
}

/// modified by zy 2017-06-28 ZY163 通过系统参数来控制是否调用日期时间转换函数
/// add by zx2017-03-02 日期时间转换调用通用方法
/// w ##Class(web.DHCEQCommon).TransValueFromPage("16/11/2019 12:40:32","datetime")
ClassMethod TransValueFromPage(fromvalue As %String, vtype As %String)
{
	i fromvalue="" q ""
	//add by zy 2017-06-28
	s IsNotValidMethodFlag=##class(web.DHCEQCommon).GetSysInfo("990056")
	if (vtype="bool")
	{		
		i fromvalue="false"  q "N"
		i fromvalue="0"  q "N"
		i fromvalue="N"  q "N"	//Mozy	1064169	2019-10-26	Mozy0227
		q "Y"
	}
	elseif (vtype="date")
	{
		i IsNotValidMethodFlag=1
		{
			q ##class(websys.Conversions).DateHtmlToLogical(fromvalue) 
		}
		else
		{
			i $L(fromvalue,"-")>1
			{
				q $ZDH(fromvalue,3)
			}
			else
			{
				q $ZDH(fromvalue,4)
			}
		}
	}
	elseif (vtype="time")
	{
		i IsNotValidMethodFlag=1
		{
			q ##class(websys.Conversions).TimeHtmlToLogical(fromvalue)
		}
		else
		{
			q $ZTH(fromvalue,1)
		}
	}
	elseif (vtype="datetime")
	{
		i IsNotValidMethodFlag=1
		{
			q ##class(websys.Conversions).DateHtmlToLogical($p(fromvalue," ",1))_","_##class(websys.Conversions).TimeHtmlToLogical($p(fromvalue," ",2))
		}
		else
		{
			i $L(fromvalue,"-")>1
			{
				q $ZDH($p(fromvalue," ",1),3)_","_$ZTH($p(fromvalue," ",2),1)
			}
			else
			{
				q $ZDH($p(fromvalue," ",1),4)_","_$ZTH($p(fromvalue," ",2),1)
			}
		}
	}
}

/// modified by zy 2017-06-28  ZY163  通过系统参数来控制是否调用日期时间转换函数
/// add by zx2017-03-02 日期时间转换调用通用方法
/// w ##Class(web.DHCEQCommon).TransValueToPage("65333,45632","datetime")
/// Modify By DJ 2022-08-30 增加fixedFormat固定格式参数(当vtype为"date","time","datetime"时使用，且存在固定格式时不根据参数进行平台转换),
/// 						vtype为"date"或"time"时,fixedFormat参数与系统格式保持一致。date时默认为4, time时默认为1.
/// 						vtype为"datetime"时fixedFormat参数格式为"日期格式,时间格式",日期格式默认为4,时间格式默认为1
ClassMethod TransValueToPage(fromvalue As %String, vtype As %String, fixedFormat As %String = "")
{
	i fromvalue="" q ""
	s IsNotValidMethodFlag=##class(web.DHCEQCommon).GetSysInfo("990056")
	i fixedFormat'="" s IsNotValidMethodFlag=0
	if (vtype="bool")
	{		
		i (fromvalue="Y")
		{	q 1	}
		else
		{	q 0	}
	}
	elseif (vtype="date")
	{
		i IsNotValidMethodFlag=1
		{
			s fromvalue=##class(websys.Conversions).DateLogicalToHtml(fromvalue) 
			if $l(fromvalue)=8 
			{
				q $E(fromvalue,1,6)_"19"_$E(fromvalue,7,8)}
			else
			{
				q fromvalue
			}
		}
		else
		{
			i fixedFormat="" s fixedFormat=4
			q $zd(fromvalue,fixedFormat)
		}
	}
	elseif (vtype="time")
	{
		i IsNotValidMethodFlag=1
		{
			q ##class(websys.Conversions).TimeLogicalToHtml(fromvalue)
		}
		else
		{
			i fixedFormat="" s fixedFormat=1
			q $zt(fromvalue,fixedFormat)
		}
	}
	elseif (vtype="CHNDate")
	{
		Quit $Piece($ZD(fromvalue,3),"-",1)_"年"_$Piece($ZD(fromvalue,3),"-",2)_"月"_$Piece($ZD(fromvalue,3),"-",3)_"日"
	}
	elseif (vtype="datetime")
	{
		i IsNotValidMethodFlag=1
		{
			q ##class(websys.Conversions).DateLogicalToHtml($p(fromvalue,",",1))_" "_##class(websys.Conversions).TimeLogicalToHtml($p(fromvalue,",",2))
		}
		else
		{
			s dateFormat=4
			s timeFormat=1
			i $p(fixedFormat,",",1)'="" s dateFormat=$p(fixedFormat,",",1)
			i $p(fixedFormat,",",2)'="" s timeFormat=$p(fixedFormat,",",2)
			q $ZD($p(fromvalue,",",1),dateFormat)_","_$ZT($p(fromvalue,",",2),timeFormat)
		}
	}
}

/// w ##Class(web.DHCEQCommon).GetTrakNameByID("service", 1162)
ClassMethod GetTrakNameByID(tablename As %Library.String, id As %Library.String)
{
	i id=""  q ""
	if (tablename="dept")
		{	q ##class(web.DHCEQCommon).GetSplitDataByFlag($p($g(^DHCEQCCode("DHCEQCDepartment",id)),"^",2),"-")	}
	elseif (tablename="deptcode")
		{	q $p($g(^DHCEQCCode("DHCEQCDepartment",id)),"^",1)	}
	elseif(tablename="depttel")	//Modify by zx 2022-08-26 根据科室ID取科室电话
		{	q $p($g(^DHCEQCCode("DHCEQCDepartment",id)),"^",5)	}
	elseif(tablename="user")
		{	q $p($g(^DHCEQCCode("DHCEQCUser",id)),"^",4)	}
	elseif(tablename="usertel")  ;add by WY 2022-9-14 人员电话
		{	q $p($g(^DHCEQCCode("DHCEQCUser",id)),"^",6)	}	
	elseif(tablename="uom")	
		{	;q $p($g(^CT("UOM",id)),"^",2)	;Modified By jdl 20150906 v4.1.0 取消使用CT_UOM
			q $p($g(^DHCEQCCode("DHCEQCUOM",id)),"^",4)
		}
	elseif(tablename="cou")
		{	q $p($g(^CT("COU",id)),"^",2)	}
	elseif(tablename="cur")
		{	q $p($g(^CT("CUR",id)),"^",2)	}
	elseif(tablename="ctpm")
		{	q $p($g(^CT("CTPM",id)),"^",2)	}
	elseif(tablename="prov")
		{	
			;q ##class(web.DHCEQCommon).GetSplitDataByFlag($P($G(^APC("APCVM",id)),"^",3),"-")
			q $p($g(^DHCEQCCode("DHCEQCVendor",id)),"^",2)
		}
	elseif(tablename="grp")
		{	q $P($G(^SSU("SSGRP",id)),"^",1)}
	elseif(tablename="equip")
		{	q $p($g(^DHCEQEquip(id)),"^",1)}
	elseif(tablename="masteritem")
		{	q $p($g(^DHCEQCCode("DHCEQCMasterItem",id)),"^",1)}
	elseif(tablename="model")
		{	q $p($g(^DHCEQCCode("DHCEQCModel",id)),"^",2)}
	elseif(tablename="serviceitem")  //modified by LMH 20220815 2769584 service名称重复 
		{	q $p($g(^DHCEQCCode("DHCEQCServiceItem",id)),"^",1)}
	elseif(tablename="resourcetype")
		{	q $p($g(^DHCEQCCode("DHCEQCResourceType",id)),"^",2)}
	elseif(tablename="consumableitem")
		{	q $p($g(^DHCEQCCode("DHCEQCConsumableItem",id)),"^",1)}
	elseif(tablename="equiptype")
		{	q $p($g(^DHCEQCCode("DHCEQCEquipType",id)),"^",2)}
	elseif(tablename="statcat")
		{	q $p($g(^DHCEQCCode("DHCEQCStatCat",id)),"^",2)}
	elseif(tablename="equipcat")
		{	q $p($g(^DHCEQCCode("DHCEQCEquipeCat",id)),"^",2)}
	elseif(tablename="outtype")
		{	q $p($g(^DHCEQCCode("DHCEQCOutType",id)),"^",2)}
	elseif(tablename="role")
		{	q $p($g(^DHCEQCCode("DHCEQCApproveRole",id)),"^",2)}
	elseif(tablename="fundstype")
		{	q $p($g(^DHCEQCCode("DHCEQCFundsType",id)),"^",2)}
	elseif(tablename="origin")
		{	q $p($g(^DHCEQCCode("DHCEQCOrigin",id)),"^",2)}
	elseif(tablename="purchase")
		{	q $p($g(^DHCEQCCode("DHCEQCPurchaseType",id)),"^",2)}
	elseif(tablename="AccessoryType")	//Add By DJ 2014-09-12
		{	q $p($g(^DHCEQCCode("DHCEQCAccessoryType",id)),"^",2)}
	elseif(tablename="MaintPlan")
		{	q $p($g(^DHCEQMaintPlan(id)),"^",1)}
	elseif(tablename="service")    //modified by LMH 20220815 2769584  cservice改为service  
		{	
			//q $p($g(^DHCEQCCode("DHCEQCService",id)),"^",1)
			q $p($g(^DHCEQCCode("DHCEQCVendor",id)),"^",2)		//modified by CZF0093 供应商、生产厂商、服务商三商合一
		}
	elseif(tablename="manufacturer")
		{	
			//q $p($g(^DHCEQCCode("DHCEQCManufacturer",id)),"^",1)	//modified by CZF0093 供应商、生产厂商、服务商三商合一
			q $p($g(^DHCEQCCode("DHCEQCVendor",id)),"^",2)
		}
	elseif(tablename="manufacturercode")
		{	
			//q $p($g(^DHCEQCCode("DHCEQCManufacturer",id)),"^",2)	//modified by CZF0093 供应商、生产厂商、服务商三商合一
			q $p($g(^DHCEQCCode("DHCEQCVendor",id)),"^",1)
		}	
	elseif(tablename="maintgroup")
		{	q $p($g(^DHCEQCCode("DHCEQMCMaintGroup",id)),"^",2)}
	elseif(tablename="location")
		{	q $p($g(^DHCEQCCode("DHCEQCLocation",id)),"^",2)}
	elseif(tablename="AccessoryCat")
		{	q $p($g(^DHCEQCCode("DHCEQCAccessoryCat",id)),"^",3)}
	elseif(tablename="disusetype")           //add by czf 2018-02-26
		{	q $p($g(^DHCEQCCode("DHCEQCDisuseType",id)),"^",2)}
	elseif(tablename="financetype")           //add by czf 2018-02-26
		{	q $p($g(^DHCEQCCode("DHCEQCFinanceType",id)),"^",2)}
	elseif(tablename="risdev") //Add By QW20181031 需求号:737359
		{
			zn "PACS"
			s pacsid=$o(^User.MODALITYI("MODALITYPK",id,0))
			s name=$LIST($g(^User.MODALITYD(pacsid)),5)
			zn "DHC-APP"
			q name
		}
	elseif(tablename="lisdev") 
		{
			q $p($g(^TMIF(id)),"\",1)
		} //End By QW20181031 需求号:737359
	elseif(tablename="purposetype")
		{	q $p($g(^DHCEQCCode("DHCEQCPurposeType",id)),"^",2)}
	elseif(tablename="brand")  //modified by LMH 20220815  2769584
		{	q $p($g(^DHCEQCCode("DHCEQCBrand",id)),"^",3)}
	elseif(tablename="todept")
		{	q $p($g(^DHCEQCCode("DHCEQCFromToDept",id)),"^",2)}
	elseif(tablename="mobilephone")	//add by csj 2020-05-18 根据UserID取手机号
		{	q $p($g(^DHCEQCCode("DHCEQCUser",id)),"^",6)	}	
	elseif(tablename="expense")	//经费来源 add by czf 20200910
		{	q $p($g(^DHCEQCCode("DHCEQCExpenditures",id)),"^",2)	}
	elseif(tablename="country")	//国别
		{	q $p($g(^CT("COU",id)),"^",2)	}
	elseif(tablename="buytype")	//采购方式
		{	q $p($g(^DHCEQCCode("DHCEQCBuyType",id)),"^",2)}
	elseif(tablename="purchasetype")
		{	q $p($g(^DHCEQCCode("DHCEQCPurchaseType",id)),"^",2)}
	elseif(tablename="depremethod")
		{	q $p($g(^DHCEQCCode("DHCEQCDepreMethod",id)),"^",2)}
		///add by BY ZY0247 2020-12-14 服务细项
	elseif(tablename="servdetitem")
		{	q $p($g(^DHCEQCCode("DHCEQCServDetItem",id)),"^",1)}	
	elseif(tablename="isprint") ;Add By QW20210422 bug:QW0100
		{	q $CASE(id,"0":"否","1":"是")}
	elseif(tablename="hos") ;Add By QW20210629 BUG:QW0131
		{	q $Piece($Get(^CT("HOSP",id)),"^",2)	}
	elseif(tablename="cycleunit")	;czf 2021-06-28 周期单位
		{	q $p($g(^DHCEQCCode("DHCEQCCycleUnit",id)),"^",2)}
	elseif(tablename="CTHospital")	;czf 2021-11-17 医院
		{	q $p($g(^CT("HOSP",id)),"^",2)}
    ///add by ZY 20220913 2907381、2907386、2907390
    elseif(tablename="authorizedept")  ;add by zy  2022-09-08 DHC_EQCAuthorizeDept 配置授权单位
        {   q $p($g(^DHCEQCCode("DHCEQCAuthorizeDept",id)),"^",2)}
    elseif(tablename="usesubject")  ;add by zy  2022-09-08 DHC_EQCUseSubject 使用责任主体
        {   q $p($g(^DHCEQCCode("DHCEQCUseSubject",id)),"^",2)}
    elseif(tablename="buymode")  ;add by zy  2022-09-08 DHC_EQCBuyMode 采购组织形式
        {   q $p($g(^DHCEQCCode("DHCEQCBuyMode",id)),"^",2)}
    elseif(tablename="Action")	;WY 2022-8-22 动作
		{	q $p($g(^DHCEQCCode("DHCEQCAction",id)),"^",2)}
	else
		{ 	q ""}	//2011-09-26 HZY0012. 在最后判断不存在时,返回空.
}

/// 日期计算函数：
/// unit：单位 年为"YYYY",月为"M",天为"D"
/// fromdate:格式为dd/mm/yyyy
ClassMethod DateAdd(unit As %String, qty As %String, fromdate As %String) As %String
{
	i fromdate="" q ""
	s FromDate=##Class(web.DHCEQCommon).TransValueFromPage(fromdate,"date")  //add by zx 2017-03-03
	s ReturnDate=..DateAddInt(unit,qty,FromDate)
	s ReturnDate=##Class(web.DHCEQCommon).TransValueToPage(ReturnDate,"date")  //add by zx 2017-03-03
	q ReturnDate
}

ClassMethod DateAddApp(unit As %String, qty As %String, fromdate As %String) As %String [ Language = basic ]
{
	return DateAdd(unit,qty,fromdate)
}

ClassMethod GetEditStatusDisplay(status As %Library.String) As %Status
{
	i status=""  q ""
	i +status=0  q "新增"
	i +status=1  q "提交"
	i +status=2  q "审核"
	i +status=3  q "作废"
	q "未定义"
}

ClassMethod GetComponentID(name As %Library.String) As %String
{
	q ##Class(web.DHCEQCommonEX).GetComponentID(name)
}

ClassMethod GetCurDate() As %String
{
	q ##Class(web.DHCEQCommon).TransValueToPage(+$H,"date")
}

/*
ClassMethod GetPath() As %String
{
	&sql(select id,pathtoreports into :ID,:path from websys.configuration)
	q path
}
*/
ClassMethod LocIsInEQ(vType, vLocID, CTLocID As %String = "", CurGroupID As %String = "", CurHosptailID As %String = "")
{
	n locid,Flag,GroupID,StoreLocDR
	
	//Flag=0可以显示GROUPID
	//需要加条件的地方加入q:(..LocIsInEQ(,QXType,TLocDR))即可
	
	Set locid=CTLocID	//Mozy0037	2010-12-28	润乾报表传递参数
	If locid="" Set locid=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	i (locid=vLocID) q "0"
	s Flag=1
	//add by zy 2015-04-09  ZY0125 分院区管理,通过科室的医院属性来管理.  需要注意两点
	//1.每个科室的医院属性是否有空值;
	//2.如果有人需要看到所有院区的数据,可以通过两种方式,一是安全组访问医院,二是医院树;
	s HospitalIsInclude=##Class(web.DHCEQCommon).HospitalIsInclude(vLocID,CurGroupID,CurHosptailID)
	if HospitalIsInclude'=1 quit 1
	
	i vLocID="" q Flag   ///Modified By QW20181203 需求号:760414
	if (vType="0")||(vType="")
	{
		s Flag=0
	}
	if vType="1"  //在安全组
	{
		;s GroupID=%session.Get("LOGON.GROUPID")
		;s locid=0
		;f  s locid=$o(^SSU("SSGRP",GroupID,"ST",0,"Loc",locid)) q:(locid="")||(Flag="0")  d
		;.i (locid=vLocID) s Flag="0"
		Set GroupID=CurGroupID		//Mozy0037	2010-12-28	润乾报表传递参数
		Set CTLocID=$p($g(^DHCEQCCode("DHCEQCDepartment",vLocID)),"^",11)
		If GroupID="" Set GroupID=%session.Get("LOGON.GROUPID")
		;是否在安全组访问库房中
		i $o(^SSU("SSGRP",GroupID,"ST",0,"Loc",CTLocID,0))'=""
		{
			s Flag=0
		}
		else
		{
			;s vLocHospitalDR=$p($g(^CTLOC(vLocID)),"^",22) //modify by jyp 2019-10-18 CTLOC调整
			s vLocHospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(vLocID) //modify by jyp 2019-10-18 CTLOC调整
			s GroupHospIDs=..GetHospIDSByGroup(GroupID)
			i ##class(web.DHCEQCommon).GetSysInfo("990033")'="1"  d		//未启用库房管理科室
			.s Flag=0
			e  d
			.;未在安全组访问库房中，是否在安全组访问库房所管理的科室中
			.s StoreLocDR=0
			.f  s StoreLocDR=$o(^DHCEQCCode("DHCEQCStoreManageLoc",0,"Loc",vLocID,StoreLocDR)) q:((StoreLocDR="")||(Flag=0))  d
			..i (locid=StoreLocDR) s Flag=0
			..Set CTLocID=$p($g(^DHCEQCCode("DHCEQCDepartment",StoreLocDR)),"^",11)
			..i $o(^SSU("SSGRP",GroupID,"ST",0,"Loc",CTLocID,0))'="" s Flag=0
			..i GroupHospIDs[("^"_vLocHospitalDR_"^") s Flag=0
		}
	}
	if vType="2"  //只显示自己科室
	{
		;s locid=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
		i (locid=vLocID) s Flag="0" 
	}
	q Flag
}

/// IncludeFlag:是否包含无效类组	0:不包含  其他:包含
/// FacilityFlag:是否包含简易台账资产类组 0  和 空 在账资产类组;  1  简易资产类组;  2  全部类组;  add by zx 2017-03-17 BUG ZX0036
ClassMethod EquipTypeIsIn(vEquipType, CurGroupID As %String = "", IncludeFlag As %String = "0", FacilityFlag As %String = "0")
{
	//Flag=0可以显示
	//需要加条件的地方加入q:(##Class(web.DHCEQCommon).EquipTypeIsIn(VEquipType))即可
	new GroupID,Flag,ClassEquipType
	set GroupID=CurGroupID
	if GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	s Flag=1
	//2019年新财务制度调整,有权限但无效类组受影响。Modify DJ 2019-01-10
	Quit:(IncludeFlag=0)&($Piece($Get(^DHCEQCCode("DHCEQCEquipType",vEquipType)),"^",4)'="N") 1	;过滤无效类组,不可显示 2013-11-11  Mozy0112
	s FacilityEquipType=##class(web.DHCEQCommon).GetSysInfo("990053") ;获取系统中简易类组配置
	Quit:(+FacilityFlag=1)&&((","_FacilityEquipType_",")'[(","_vEquipType_",")) 1  ;只显示简易资产类组
	Quit:(+FacilityFlag=0)&&((","_FacilityEquipType_",")[(","_vEquipType_",")) 1  ;只显示在账资产类组
	i $d(^DHCEQCCode("DHCEQCGroupEquipType",0,"Group",GroupID,vEquipType)) s Flag=0 
	q Flag
}

ClassMethod GetFileName()
{
	w "<input type=file id='GetFileName'>"
}

ClassMethod GetDataByName(data, name)
{
	s startindex=$f(data,"^"_name_"=",1)
	i (startindex<1)	q ""
	s data=$e(data,startindex,$l(data))
	s endindex=$f(data,"^",1)-2
	i (endindex>=0) s data=$e(data,1,endindex)
	q data
}

/// modified by csj 2020-06-28 添加Job参数 需求号：1387689
/// czf 2021-10-15 添加User参数
ClassMethod KillTempGlobal(str, Job As %String = "")
{
	new PreDate,Date
	i Job="" s Job=$J
	k ^DHCEQTemp(str,+$H,Job)
	s PreDate=+$H
	s Date=0
	f  s Date=$o(^DHCEQTemp(str,Date)) q:Date=""  d
	.i Date<PreDate d
	.. k ^DHCEQTemp(str,Date)
}

/// czf 2021-10-15 清除台账临时global
ClassMethod KillEQTempGlobal(str, Job As %String = "", User As %String = "")
{
	new PreDate,Date
	i Job="" s Job=$J
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	k ^DHCEQTemp(str,+$H,Job,User)
	s PreDate=+$H
	s Date=0
	f  s Date=$o(^DHCEQTemp(str,Date)) q:Date=""  d
	.i Date<PreDate d
	.. k ^DHCEQTemp(str,Date)
}

/// 根据类组权限，返回默认类组编号1，类组名称2  类组代码3
/// w ##class(web.DHCEQCommon).GetDefaultEquipType(1)
ClassMethod GetDefaultEquipType(vType)
{
	n tmpGETRowID
	s valEquipType=..GetEquipTypesByGroup()
	i valEquipType="" q ""
	s DefaultEquipTypeDR=$P(valEquipType,"^",1)
	// MZY0056	1506422		2020-09-29
	s tmpGETRowID=$o(^DHCEQCCode("DHCEQCGroupEquipType",0,"Group",%session.Get("LOGON.GROUPID"),DefaultEquipTypeDR,0))
	i $p(^DHCEQCCode("DHCEQCGroupEquipType",tmpGETRowID),"^",3)'="Y" q ""
	i vType="1" q DefaultEquipTypeDR
	i vType="2" q $P($G(^DHCEQCCode("DHCEQCEquipType",DefaultEquipTypeDR)),"^",2)
	i vType="3" q $P($G(^DHCEQCCode("DHCEQCEquipType",DefaultEquipTypeDR)),"^",1)
	//s DefaultEquipType=$P($G(^DHCEQCCode("DHCEQCEquipType",DefaultEquipTypeDR)),"^",2)
	//i vType="2" q DefaultEquipType
}

/// IncludeFlag:是否包含无效类组	0:不包含  其他:包含
/// FacilityFlag:是否包含简易台账资产类组 0  和 空 在账资产类组;  1  简易资产类组;  2  全部类组;  add by zx 2017-03-17 BUG ZX0036
/// w ##Class(web.DHCEQCommon).GetEquipTypesByGroup(85)
ClassMethod GetEquipTypesByGroup(GroupID As %Library.String = "", IncludeFlag As %String = "0", FacilityFlag As %String = "0")
{
	new EquipType,Flag,Equips
	if GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	s GETRowID=0
	s Equips=""
	s DefaultEquip=""
	s FacilityEquipType=##class(web.DHCEQCommon).GetSysInfo("990053") ;获取系统中简易类组配置
	s EquipType=0
	f  s EquipType=$o(^DHCEQCCode("DHCEQCGroupEquipType",0,"Group",GroupID,EquipType)) q:EquipType=""  d
	.Quit:(IncludeFlag=0)&($Piece(^DHCEQCCode("DHCEQCEquipType",EquipType),"^",4)'="N")	;过滤无效类组 2013-11-11  Mozy0112
	.Quit:(+FacilityFlag=1)&&((","_FacilityEquipType_",")'[(","_EquipType_","))  ;只显示简易资产类组
	.Quit:(+FacilityFlag=0)&&((","_FacilityEquipType_",")[(","_EquipType_","))  ;只显示在账资产类组
	.s GETRowID=$o(^DHCEQCCode("DHCEQCGroupEquipType",0,"Group",GroupID,EquipType,0))
	.q:GETRowID=""
	.;s EquipType=$p(^DHCEQCCode("DHCEQCGroupEquipType",GETRowID),"^",2)
	.s Flag=$p(^DHCEQCCode("DHCEQCGroupEquipType",GETRowID),"^",3)
	.i Flag="Y" s DefaultEquip=EquipType
	.q:Flag="Y"
	.s Equips=Equips_"^"_EquipType
	i DefaultEquip'="" q DefaultEquip_Equips
	q $P(Equips,"^",2,$L(Equips,"^"))
}

/// 人民币大小写转化
/// ##Class(web.DHCEQCommon).RMBDXXZH('','',num)
ClassMethod RMBDXXZH(itmjs As %Library.String = "", itmjsex As %Library.String = "", numstr As %Library.String = "")
{
    ;RMB DAXIAOXIE CONVERSION,
	k P1
	s numstr=$tr(numstr," ","")
	s i=0,lendec=0,lenint=0
	S a="",b="",c="",d="",bbak="",bs=""
	s numstr=+numstr
	i $p(numstr,".",1)=""  s numstr="0"_numstr
	s lenint=$l($p(numstr,".",1))
	s lendec=2
	i $p(numstr,".",2)="00" s lendec=0  
	s dxint(13)="",dxdec(2)="",sz(13)=""
	s dxstr="万|仟|佰|拾|亿|仟|佰|拾|万|仟|佰|拾|元"
	s szstr="零|壹|贰|叁|肆|伍|陆|柒|捌|玖"
	s lendxstr=$l(dxstr,"|")+1
	s lenszstr=$l(szstr,"|")+1
	f i=1:1:lendxstr d
	.s dxint(i)=$p(dxstr,"|",lendxstr-i)
	.s sz(i)=" "
	.i i<11  s sz(i)=$p(szstr,"|",i)  
	s dxdec(1)="角",dxdec(2)="分",dxstr=" "
	;**整数部分**
	f i=1:1:lenint d
	.s a=$e($e(numstr,1,lenint),i,i)
	.s b=sz(a+1)
	.s c=dxint(lenint-i+1)
	.s d=" "
	.i dxstr'=" "  s d=$e(dxstr,$l(dxstr)-1,($l(dxstr)-1)+2-1)  
	.i a="0"  s b="",bs="零"
	.i (b="零")&((d="零")!(b=bbak)!(c="元")!(c="万")!(c="亿"))  s b=""
	.i (a="0")&(c'="元")&(c'="万")&(c'="亿") s c=""
	.i ((c="元")!(c="万")!(c="亿"))&(d="零")&(a="0")  d 
	..s dxstr=$e(dxstr,1,1+($l(dxstr)-2)-1)
	.s d=$e(dxstr,$l(dxstr)-1,($l(dxstr)-1)+2-1)
	.i (c="元")&(d="万")&(c="万")&(d="亿")  s c=""
	.i (bs="零")&(a'=0)&(a'="") s b=bs_b,bs=""
	.s dxstr=dxstr_b_c,bbak=b
	;
	;**小数部分**
	i ($p(numstr,".",2)=0)!(lendec=0)!($p(numstr,".",2)="")  s dxstr=dxstr_"整" 
	i $p(numstr,".",2)>0  d
	.f i=1:1:lendec d
	..s a=$e($p(numstr,".",2),i,i)
	..s b=sz(a+1)
	..i (a="0")&(dxdec(i)="分")  s b=""  
	..i a="0"  s dxstr=dxstr_b
	..i a'="0"  s dxstr=dxstr_b_dxdec(i)   
	i numstr<1 s dxstr=$e(dxstr,3,$l(dxstr))
	i numstr<0.1 s dxstr=$e(dxstr,3,$l(dxstr))
	i numstr=0 s dxstr=""
	s P1=dxstr
	s retcode=dxstr
	q retcode
}

ClassMethod Logon(userid, pinnumber) As %String
{
	s userid=..Replace(userid,"_","") //add by zx 2016-11-23 下划线登录不了处理 ZX0036
    	s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
  	s User=$O(^SSU("SSUSR",0,"SSUSR_Initials",$ZCVT(userid,"U"),""),-1)
  	if User=""{
	  	 zn oldnamespace
         q "-3"
	  	} 
  	s pin=$$ENCR^SSUTIL2(pinnumber)
  	if pin=""{
	  	 zn oldnamespace
         q "-4"
	  	} 
	i pin'=$p(^SSU("SSUSR",User),"^",3) {	//将原来的15改为3. Modified 2014-4-25 HZY0054
	  	 zn oldnamespace
		 q "-4"
	}
	s DefLoc=$p(^SSU("SSUSR",User),"^",4)
	zn oldnamespace
	s LogonDep=""    
	///s LogonDep=##class(web.DHCNURPDAQUEXCUTE).Getlogonctloc(User)
	s UserName=$p($g(^SSU("SSUSR",User)),"^",2)  //返回用户名  add by zx 2016-06-23 ZX0036
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",User) ;QW20191017 BUG:QW0031
	q User_"^"_DefLoc_"^"_UserName_"^"_"@"_LogonDep
}

Query logonctloc(userid As %String) As %Query(ROWSPEC = "LocDesc:%String,rowid:%String")
{
}

ClassMethod logonctlocExecute(ByRef qHandle As %Binary, userid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s chl=""  f  s chl=$O(^SSU("SSUSR",userid,"OTHLL",chl)) q:chl=""  d
    .s loc=$P(^SSU("SSUSR",userid,"OTHLL",chl),"^",1)
    .s locdes=$p($G(^CTLOC(loc)),"^",2)
    .q:locdes=""
    .s tm(loc)=locdes
    s loc=""  f  s loc=$O(tm(loc)) q:loc=""  d
    .s locdes=tm(loc)
    .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(locdes,loc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod logonctlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = logonctlocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod logonctlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = logonctlocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// modified by ZY 20220927  修改global
/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQCommon","LogonLocGrp","3938")
/// Add By QW20170309 增加医院id输出
Query LogonLocGrp(userid As %String = "") As %Query(ROWSPEC = "LocDesc:%String,LocID:%String,GrpDesc:%String,GrpID:%String,HospitalID:%String")
{
}

ClassMethod LogonLocGrpExecute(ByRef qHandle As %Binary, userid As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    k ^TempDHCEQ("LogonLocGrp",$j)  //add by zx 2016-11-24 选择时过滤重复安全组 ZX0036
    if userid="" Quit $$$OK
    s userid=$p($g(^DHCEQCCode("DHCEQCUser",userid)),"^",19) ;Modified By QW20191017 BUG:QW0031
    s (LocDesc,GrpDesc)=""
    s LocID= $p(^SSU("SSUSR",userid),"^",4)
    s GrpID= $p(^SSU("SSUSR",userid),"^",5)
    s ^TempDHCEQ("LogonLocGrp",$j,LocID,GrpID)=GrpID
    d OutRowLocGrp
    s chl=""  
    f  s chl=$O(^SSU("SSUSR",userid,"OTHLL",chl)) q:chl=""  d
    .s (LocDesc,GrpDesc)=""
    .s LocID=$P(^SSU("SSUSR",userid,"OTHLL",chl),"^",1)
    .s GrpID=$P(^SSU("SSUSR",userid,"OTHLL",chl),"^",2)
    .q:(GrpID="")||(LocID="")
    .q:$d(^TempDHCEQ("LogonLocGrp",$j,LocID,GrpID))
    .s ^TempDHCEQ("LogonLocGrp",$j,LocID,GrpID)=GrpID
    .d OutRowLocGrp
    
    k ^TempDHCEQ("LogonLocGrp",$j)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowLocGrp
	q:LocID=""
	q:GrpID=""
	;Modified By QW20191017 BUG:QW0031
	if LocID'="" s HospitalID=$p($g(^CTLOC(LocID)),"^",22) ;Add By QW20170309 增加医院id输出
	s LocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",LocID)  
	if LocID'="" s LocDesc=##class(web.DHCEQCommon).GetTrakNameByID("dept",LocID)  //s LocDesc=$p($G(^CTLOC(LocID)),"^",2) add by zx 2017-01-03 选择安全组时科室不显示前缀 ZX0036
	if GrpID'="" s GrpDesc=$p($G(^SSU("SSGRP",GrpID)),"^",1)
	;End By QW20191017 BUG:QW0031
	set Data=$lb(LocDesc,LocID,GrpDesc,GrpID,HospitalID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LogonLocGrpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LogonLocGrpExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LogonLocGrpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LogonLocGrpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CheckFunction(GrpID, FunctionName) As %String
{
	s VBEXRowID=""
	s FunctionID=""  
    f  s FunctionID=$O(^SSU("SSGRP",GrpID,"VBEX",FunctionID)) q:((FunctionID="")||(VBEXRowID'=""))  d
    .q:FunctionName'=$p($g(^SS("SSVBE",FunctionID)),"^",3)
    .s VBEXRowID=FunctionID
    // add by zx 2015-08-02 根据安全组信息获取菜单权限
    s Menus =##Class(web.DHCEQCommon).GetMenusInfo(GrpID)
	q VBEXRowID_Menus
}

/// Creator:zhaoym
/// CreatDate:2008-10-14
/// Description: 解密JS加密字符串
/// Input:  需解密字符串
/// Return: 解密后的字符串
/// Others: 为了解决P8版本汉字模糊查询翻页后无法正常显示的问题
///         在在组件使用该类方法得到值及Query中执行查询前进行该转换            
ClassMethod UnEscape(InStr As %String) As %String
{
	n (InStr)
	s num=1,retStr="",tmpNum=1	
	f num=1:1:$l(InStr,"%") d
	.s char=$p(InStr,"%",num) 
	.i num=1 d
	..s retStr=$e(char,1,$l(char))
	.e  d
	..i $e(char,1,1)'="u" d
	...s retStr=retStr_$char($zhex($e(char,1,2)))_$e(char,3,$l(char))
	..e  d
	...s retStr=retStr_$char($zhex($e(char,2,5)))_$e(char,6,$l(char))
	q retStr
}

/// Craetor:Mozy
/// Date:2009-05-06
/// 按照指定分隔符截取后半段字符
/// w ##class(web.DHCEQCommon).GetSplitDataByFlag("HNHCYYYXGS-BB-湖南和盛医药有限公司-本部","-") 返回“湖南和盛医药有限公司-本部”
ClassMethod GetSplitDataByFlag(str As %String, flag As %String)
{
	New len
	Set str=##Class(web.DHCEQCommon).Trim(str)
	Set len=$Length(str,flag)
	Quit $Piece(str,flag,len\2+1,len)
}

/// Add by DJ 2009-05-20  DJ0002
/// 数据打包及解析
ClassMethod ExistsElement(data, name)
{
 	s startindex=$f(data,"^"_name_"=",1)
 	i (startindex<1) q 0
 	q 1
}

/// Add by JDL 2009-06-04 JDL0009
/// 获取指定格式的当前时间,dateformat为空,则不带日期，timeformat为空则不带时间。
ClassMethod GetCurTime(dateformat As %Library.String = "3", timeformat As %Library.String = "1") As %String
{
	s curTime=""
	if dateformat'="" s curTime=$ZD(+$H,dateformat)
	if timeformat'=""  d
	.if curTime'="" s curTime=curTime_" "
	.s curTime=curTime_$ZT($p($H,",",2),timeformat)
	q curTime
}

/// ----------------------------------
/// 创建：jdl 2009-08-4 JDL0021
/// 描述：判断Id是否存在于Ids中
/// 访问表:无
/// 输入：Id:
/// 	  Ids:月
/// 	  EmptyFlag:当Ids为空时，EmptyFlag=1返回1，否则返回0
/// 输出：无
/// 返回：存在返回1，否则返回0
/// 备注：
/// w ##Class(web.DHCEQCommon).IdInIds("12","123,213,231")
ClassMethod IdInIds(Id, Ids, EmptyFlag As %String = "1")
{
	new i,len,result
	if ((Ids="")&&(EmptyFlag="1")) q 1
	s len=$l(Ids,",")
	s result=0
	for i=1:1:len
	{
		if Id=$p(Ids,",",i)
		{ 
			s result=1
			quit
		}
	}
	q result
}

/// 2009-07-24 党军
ClassMethod GetEditLifeTypeDisplay(status As %Library.String) As %Status
{
	i status=""  q ""
	i status="I"  q "收入"
	i status="P"  q "支出"
	i status="C"  q "变动"
	i status="O"  q "其他"
	q "未定义"
}

/// 2009-07-24 党军
ClassMethod GetEditLifeSourceTypeDisplay(status As %Library.String) As %Status
{
	i status=""  q ""
	i +status="91"  q "采购申请"
	i +status="92"  q "采购计划"
	i +status="93"  q "招标记录"
	i +status="94"  q "合同"	//add by ZY0165 2018-04-26  生命周期增加合同的节点
	i +status="11"  q "开箱验收"
	i +status="12"  q "安装调试验收"
	i +status="21"  q "入库"
	i +status="22"  q "转移"
	i +status="23"  q "减少"
	i +status="31"  q "维修"
	i +status="32"  q "保养"
	i +status="33"  q "检查"
	i +status="34"  q "报废"
	i +status="35"  q "折旧"
	i +status="41"  q "停用/启用"
	i +status="51"  q "设备调账"
	i +status="61"  q "数据调整"	//Add By HZY 2012-07-24 HZY0034
	i +status="82"  q "报废预警鉴定"	//Mozy0226	2019-9-22
	i +status="55"  q "拆分"		//czf 2021-07-28 2014955
	q "未定义"
}

ClassMethod GetEditCheckTypeDisplay(status As %Library.String) As %Status
{
	i status=""  q ""
	i +status=0  q "新设备验收"
	i +status=1  q "维修验收"
	i +status=2  q "改造验收"
	q "未定义"
}

/// 2009-08-10 JDL  
/// 字符串补位
/// Str原字符串,Sub补位字符,Len定长,IsPre补位位置,1补前面,0补后面,IsFixLen是否定长,0不是,1是
/// w ##Class(web.DHCEQCommon).LPAD("123","0",6,0) 将输出:123000
ClassMethod LPAD(Str, Sub, Len, IsPre As %Library.String = "0", IsFixLen As %Library.String = "0")
{
	new Result,Pad,PadLen
	s Result=""
	if (Sub="")
	{	s Result=Str	}
	elseif ('$g(Len)||(+Len<1))
	{	s Result=Str	}
	else
	{
		if $l(Str)>=Len
		{	s Result=Str	}
		else
		{
			s Pad=""
			s PadLen=Len-$l(Str)
			for i=1:1:PadLen
			{
				s Pad=Pad_Sub
			}
			if IsPre="1"
			{	s Result=Pad_Str	}
			else
			{	s Result=Str_Pad	}
		}
	}
	if (($g(Len))&&(+Len>0)&&(IsFixLen="1"))
	{
		if IsPre="1"
		{	if ($l(Result)>+Len) s Result=$e(Result,$l(Result)-Len+1,$l(Result))	}
		else
		{	if ($l(Result)>+Len) s Result=$e(Result,1,Len)	}
	}
	q Result
}

/// add by jdl 2010-02-24		JDL0042
/// 获取对照表中定义的对照信息
/// 输入参数：
/// 	cAppName：应用程序名称，如久其系统可用"jq"表示
/// 	cDataType：数据类型，指是什么代码表：有如下一些类型：
/// 		"dept","uom","user","prov","orign","cou"
/// 	cID:本系统中的相应记录的ID值
/// 	cReturnType:为空时返回ID^Code^Desc,为1时返回ID,为2时返回Code,为3时返回Desc
/// 	cIneralFlag:1表示cID为系统ID，即根据本系统字典ID获取对照的外部代码信息；0表示cID为非系统ID，即根据外部键值获取对照的本系统字典信息
/// 返回值：当该字典表没有设置对照则返回$c(0)
/// 		当该字典有对照，而该记录未作对照，则返回"没有对照"
/// 		其他情况返回对照信息
/// w ##Class(web.DHCEQCommon).GetContrastInfo(cAppName,cDataType,cID,cReturnType)
ClassMethod GetContrastInfo(cAppName, cDataType, cID, cReturnType, cIneralFlag As %Library.String = "1")
{
	new (cAppName, cDataType, cID, cReturnType,cIneralFlag)
	if ((cAppName="")||(cDataType="")) q $c(0)
	new contrastTypeID,contrastInfoID,rtn,rowid
	
	//修改获取对照信息的方法,增加无效的过滤 JDL0136 2014-12-17
	s contrastTypeID=""
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCContrastType",0,"DataType",cAppName,cDataType,rowid))  quit:((rowid="")||(contrastTypeID'=""))  d
	.q:$p($g(^DHCEQCCode("DHCEQCContrastType",rowid)),"^",13)'="N"
	.s contrastTypeID=rowid
	
	if contrastTypeID="" q $c(0)
	if ((cID="")) q ""
	
	s node="SYSID"
	i cIneralFlag=0 s node="EXID"
	
	s rowid=""
	s contrastInfoID=""
	f  s rowid=$o(^DHCEQCCode("DHCEQCContrastInfo",0,node,contrastTypeID,cID,rowid)) q:((rowid="")||(contrastInfoID'=""))  d
	.q:$p($g(^DHCEQCCode("DHCEQCContrastInfo",rowid)),"^",16)="Y"
	.s contrastInfoID=rowid
	if contrastInfoID="" q "没有对照"
	s rtn=$g(^DHCEQCCode("DHCEQCContrastInfo",contrastInfoID))
	
	i cIneralFlag=0  d
	.if (cReturnType=1) s rtn= $p(rtn,"^",2)
	.if (cReturnType=2) s rtn= $p(rtn,"^",3)
	.if (cReturnType=3) s rtn= $p(rtn,"^",4)
	e  d
	.if (cReturnType=1) s rtn= $p(rtn,"^",5)
	.if (cReturnType=2) s rtn= $p(rtn,"^",6)
	.if (cReturnType=3) s rtn= $p(rtn,"^",7)
	
	q rtn
}

/// add by jdl 2010-4-21
/// 根据传入的编号,将连续的号码用合并显示（如1001，1002，1003，1004，1008转换显示为1001-1004，1008）
/// w ##Class(web.DHCEQCommon).GetContinueNo("A1001,A1002,A1003,A1004,A1008","A")
ClassMethod GetContinueNo(Nos As %Library.String, prefix As %String = "") As %Status
{
	n (Nos,prefix)
	s ContinueNos=""
	s BeginNo=""
	s PreNo=""
	i Nos=""  q ContinueNos
	i prefix'="" s Nos=..Replace(Nos,prefix,"99999")		//czf 2022-04-21
	k DHCEQPrintNo
	s len=$l(Nos,",")
	for i=1:1:len
	{
		s PerNo=$p(Nos,",",i)
		s DHCEQPrintNo(PerNo)=1
	}
	s Nos=""
	s EachNo=""
	f  s EachNo=$o(DHCEQPrintNo(EachNo)) q:EachNo=""  d
	.i Nos'="" s Nos=Nos_","
	.s Nos=Nos_EachNo
	for i=1:1:len
	{
		i $p(Nos,",",i)'=""
		{
			if PreNo=""
			{
				s PreNo=$p(Nos,",",i)
				s ContinueNos=PreNo
				s BeginNo=PreNo
			}
			else
			{
				if (PreNo'=($p(Nos,",",i)-1))
				{
					if (BeginNo'=PreNo)
					{
						s ContinueNos=ContinueNos_"-"_PreNo
					}
					s PreNo=$p(Nos,",",i)
					s BeginNo=PreNo
					s ContinueNos=ContinueNos_","_PreNo
				}
				else
				{
					s PreNo=$p(Nos,",",i)
				}
			}
		}
	}
	i PreNo'=BeginNo s ContinueNos=ContinueNos_"-"_PreNo
	i prefix'="" s ContinueNos=..Replace(ContinueNos,"99999",prefix)	//czf 2022-04-21
	q ContinueNos
}

/// Function:Funds	2012-2-16 生成资金来源信息
/// add by jdl 2010-5-7
/// 获取两个日期差
/// interval, date1, date2 [,firstdayofweek[, firstweekofyear]]
/// interval：yyyy Year
/// 			 q Quarter
/// 			 m Month 
/// 			 y Day of Year 
/// 			 d Day
/// 			 w Weekday
/// 			 ww Week of Year
/// 			 h Hour
/// 			 n Minute
/// 			 s Second
/// 	date1,date2格式："7/15/2010"
/// 	返回date2-date1
/// 	w ##Class(web.DHCEQCommon).DateDiff("m","7/15/2010","7/23/2009")
ClassMethod DateDiff(interval, date1, date2) As %String [ Language = basic ]
{
	return DateDiff(interval, date1, date2)
}

/// Function:Funds	2012-2-16 生成资金来源信息
/// add by jdl 2010-5-7
/// 获取该日期的某个部分，如日期、月份或年份等
/// interval, date1, date2 [,firstdayofweek[, firstweekofyear]]
/// interval：yyyy Year
/// 			 q Quarter
/// 			 m Month 
/// 			 y Day of Year 
/// 			 d Day
/// 			 w Weekday
/// 			 ww Week of Year
/// 			 h Hour
/// 			 n Minute
/// 			 s Second
/// 	vdate格式："7/15/2010"
/// 	w ##Class(web.DHCEQCommon).DatePart("d","7/15/2010")
ClassMethod DatePart(interval, vdate) As %String [ Language = basic ]
{
	return DatePart(interval, vdate)
}

/// 新增:2010-07-14 党军
/// 描述:解析消耗资源定价方式
ClassMethod GetEditResourceType(Type As %Library.String) As %Status
{
	i Type=""  q ""
	i +Type=1  q "固定单价"
	i +Type=2  q "无固定单价"
	i +Type=3  q "根据接口获取单价"
	q "未定义"
}

/// ----------------------------------
/// 修改:zy 2009-12-02  No ZY0018
/// 描述:取系统设置参数
/// 访问表:DHC_EQCSysSet
/// w ##class(web.DHCEQCommon).GetSysInfo("301004",2,"")
/// ----------------------------------
/// CZF0138 多院区修改：gHospId：登录医院ID  BDPHospId：平台医院组件选择医院ID
ClassMethod GetSysInfo(code, gHospId As %Library.String = "", BDPHospId As %Library.String = "")
{
	new rowid,Info,%session
	s Info=""
	s findrowid=""
	i code="990051"		;是否开启平台医院权限
	{
		s findrowid=$o(^DHCEQCCode("DHCEQCSysSet",0,"Code",code,0))
	}
	else
	{
		;获取院区Id(多院区)
		s vHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId(BDPHospId,gHospId)
		i vHospID="" s vHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetCurrentSYSHospitalId()
		s rowid=0
		f  s rowid=$o(^DHCEQCCode("DHCEQCSysSet",0,"Code",code,rowid)) q:(rowid="")||(findrowid'="")  d
		.q:##class(web.DHCEQ.Util.BDPCommonUtil).GetHospShowDataFlag("DHC_EQCSysSet",rowid,vHospID)'="Y"
		.s findrowid=rowid
	}
	
	i findrowid'="" s Info=$p($g(^DHCEQCCode("DHCEQCSysSet",findrowid)),"^",2)
	q Info
}

/// ----------------------------------
/// 修改:zy 2009-12-02  No ZY0018
/// 描述:取系统设置参数Origin
/// 访问表:DHC_EQCSysSet,DHC_EQCOrigin
/// d ##Class(web.DHCEQCommon).GetDefaultOrigin("301008")
ClassMethod GetDefaultOrigin(code)
{
	s Info=..GetSysInfo(code)
	i Info'=""  s Info=$p($g(^DHCEQCCode("DHCEQCOrigin",Info)),"^",2)
	q Info
}

/// ----------------------------------
/// 修改:zy 2009-12-02  No ZY0018
/// 描述:标准表解析函数
/// w ##Class(web.DHCEQCommon).GetStandardDesc("DHCEQCOrigin","1")
ClassMethod GetStandardDesc(codetable, id)
{
	i ((id="")||(codetable="")) q ""
	q $p($g(^DHCEQCCode(codetable,id)),"^",2)
}

/// ----------------------------------
/// 修改:zy 2009-12-02  No ZY0018
/// 描述: 根据分类获取使用年限
/// w ##Class(web.DHCEQCommon).GetYearsByEquipCat("")
ClassMethod GetYearsByEquipCat(EquipCatID)
{
	new YearsNum
	i EquipCatID="" q ""
	s YearsNum=$P(^DHCEQCCode("DHCEQCEquipeCat",EquipCatID),"^",6)
	i YearsNum=""
	{
		s EquipCatID=$P(^DHCEQCCode("DHCEQCEquipeCat",EquipCatID),"^",4)
		s YearsNum=..GetYearsByEquipCat(EquipCatID)
	}
	q YearsNum
}

/// ----------------------------------
/// 修改:zy 2009-12-02  No ZY0018
/// 描述:根据设备项获取相应的使用年限
/// w ##Class(web.DHCEQCommon).GetLimitYearsNum("")
ClassMethod GetLimitYearsNum(MastItemID)
{
	new YearsNum
	new EquipCatDR
	i MastItemID="" q ""
	s EquipCatDR=$P(^DHCEQCCode("DHCEQCMasterItem",MastItemID),"^",4)
	s YearsNum=..GetYearsByEquipCat(EquipCatDR)
	i YearsNum=""
	{
		s StatCatDR=$P(^DHCEQCCode("DHCEQCMasterItem",MastItemID),"^",5)
		s YearsNum=$P(^DHCEQCCode("DHCEQCStatCat",StatCatDR),"^",3)
		i YearsNum'="" s YearsNum=..Trim(YearsNum)
	}
	i YearsNum=$C(0) s YearsNum=""
	q YearsNum
}

/// ----------------------------------
/// czf 增加type入参，type=1时判断当前日期
/// 修改:zy 2010-07-01  
/// 描述:根据月份取得月份的最后一天
/// w ##Class(web.DHCEQCommon).GetMonthEndDate("2021-11",1)
ClassMethod GetMonthEndDate(str, type As %String = "")
{
	n (str,type)
	q:str="" ""
	s (Year,Month,EndDate)=""
	s Year=$p(str,"-",1)
	s Month=$p(str,"-",2)
	if (Month="01")||(Month="03")||(Month="05")||(Month="07")||(Month="08")||(Month="10")||(Month="12")
	{
		s EndDate="31"
	}
	elseif (Month="04")||(Month="06")||(Month="09")||(Month="11")
	{
		s EndDate="30"
	}
	elseif (Month="02")
	{
		i (Year'="")&&((Year#400=0)||((Year#4=0) && (Year#100'=0)))	//闰年
		{
			s EndDate="29"
		}
		else
		{
			s EndDate="28"
		}
	}
	i type=1
	{
		s CurMonth=$p($zd(+$h,3),"-",1,2)
		i $zdh(str_"-01",3)>$zdh(CurMonth_"-01",3) q 0
		i $zdh(str_"-01",3)=$zdh(CurMonth_"-01",3) q +$p($ZD($h,3),"-",3)
		i $zdh(str_"-01",3)<$zdh(CurMonth_"-01",3) q EndDate
	}
	q EndDate
}

/// ----------------------------------
/// 修改:zy 2010-07-09
/// 描述:根据组件ID取table列表的ID
/// w ##Class(web.DHCEQCommon).GetColumnID("50926","TRequestNo")
ClassMethod GetColumnID(compid, valname)
{
	q:compid="" ""
	q:valname="" ""
	s count=0
	s sub=0
	s find=0
	f  s sub=$o(^websys.ComponentTableItemsD(compid,sub)) q:(sub="")||(find'=0)  d 
	.s count=count+1
	.s id=compid_"||"_sub
	.s tableItem=##class(websys.ComponentTableItems).%OpenId(id)
	.i ($ZCONVERT(..Trim(tableItem.Name),"U")=$ZCONVERT(..Trim(valname),"U")) s find=1
	q count
}

/// 描述:根据组件ID取table列表的描述
/// w ##Class(web.DHCEQCommon).GetColumnCaption("51972","TRemark")
ClassMethod GetColumnCaption(compid, valname)
{
	n (compid, valname)
	i compid="" q ""
	i valname="" q ""
	s valname=..Trim(valname)
	s valname=$ZConvert(valname,"U")
	s valname=" "_valname
	s caption=""
	s sub=$o(^websys.ComponentTableItemsI("Name",compid,valname,0))
	i sub'=""  d
	.s id=compid_"||"_sub
	.s tableItem=##class(websys.ComponentTableItems).%OpenId(id)
	.s caption=tableItem.Caption
	q caption
}

/// 判断是否为该类型科室
/// 入参：
/// 		LGTCode:科室类型代码
/// 		LocDR:科室
/// 返回:0是,-1不是
ClassMethod CheckLocType(LGTCode, LocDR)
{
	n LGTRowID,Flag		//czf 2022-01-07
	s LGTRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code",LGTCode,0))
	i LGTRowID="" q -1
	s Flag=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTRowID,LocDR,0))
	i Flag="" q -1
	q 0
}

/// Creator:czf
/// CreateDate:2021-06-08
/// Description:获取科室类型
/// OutPut:1：库房 2：科室
ClassMethod CheckLocTypeNew(locid) As %String
{
	i locid="" q ""
	s (StoreFlag,LocFlag)=""
	s LGTStoreRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0101",0))
	s LGTLocRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0102",0))
	i LGTStoreRowID'="" s StoreFlag=$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTStoreRowID,locid))
	i LGTLocRowID'="" s LocFlag=$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTLocRowID,locid))
	i LocFlag'="" q 2
	i StoreFlag'="" q 1
	q ""
}

ClassMethod GetDRDesc(value)
{
	s Count=$L(value,"^")
	s Str=""
	f i=1:1:Count
	{
		s Table=$p($p(value,"^",i),"=",1)
		s Desc=$p($p(value,"^",i),"=",2)
		s DRRowID=$p($p(value,"^",i),"=",3)
		s DRDesc=""
		i DRRowID'=""
		{
			s DRDesc=..GetTrakNameByID(Table,DRRowID)
			/*
			i Table="ctloc"
			{
				s DRDesc=..GetTrakNameByID("dept",DRRowID)
			}
			else
			{
				s DRDesc=..GetTrakNameByID(Table,DRRowID)
			}
			*/
		}
		s Str=Str_Desc_"="_DRDesc_"^"
	}
	q Str
}

/// No:接口类型序号，从1开始，顺序排列
/// Type:0：解析用 1：服务项处用，2：设备对照用
ClassMethod GetInterfaceInfo(No, Type)
{
	s Name=""
	if (No=1)
	{
		if Type="1"  s Name="DHC-HIS"
	}
	elseif (No=2)
	{
		if Type="2" s Name="DHC-RIS"
	}
	elseif (No=3)
	{
		if Type="2" s Name="DHC-LIS"
	}
	elseif (No=4)	;add by zy 2011-11-11 ZY0085 地坛锐珂Pacs
	{
		;if Type="2" s Name="Pacs"
	}
	elseif (No=5)
	{
		;if Type="1" s Name="Pacs"
	}
	elseif (No=6)
	{
		;if Type="1" s Name="AKF"	;爱克发 医大一院
		;if Type="2" s Name="AKF"
	}
	elseif (No=7)
	{
	;	if Type="1" s Name="LY"		;蓝韵 医大一院
	;	if Type="2" s Name="LY"
	}
	elseif (No=8)
	{
	;	if Type="1" s Name="LN"		;雷鸟 医大一院
	;	if Type="2" s Name="LN"
	}
	elseif (No=9)
	{
	;	if Type="1" s Name="MDK"	;麦迪康 医大一院	
	;	if Type="2" s Name="MDK"
	}
	elseif (No=10)
	{
		;if Type="1" s Name="DHC-ST"  ;Modified BY QW20181029 需求号:590075 不应该有DHC-ST
	}
	else
	{
		s Name="-1"
	}
	q Name
}

/// Add By DJ 2010-10-22
/// 判断设备分类是否选择最末级节点
/// 返回值: 0表示不是最末级节点  1表示不限制或是最末级节点  2表示非最末级提示但不限制
ClassMethod CheckEqCatIsEnd(CatID)
{
	i CatID="" q 1
	s Flag=##class(web.DHCEQCommon).GetSysInfo("990014") ;0:不限制  1:限制  2:提示
	i +Flag=0 q 1
	s Find='$d(^DHCEQCCode("DHCEQCEquipeCat",0,"ECParCatDR",CatID))
	i (+Flag=2)&&(Find=0) q 2
	q Find
}

/// 获取临时Global中的数据
ClassMethod GetTempData(TempNode, Job, Index)
{
	q $g(^DHCEQTemp(TempNode,+$H,Job,Index))
}

/// 获取临时Global中的数据行数
ClassMethod GetTempDataRows(TempNode, Job)
{
	q $o(^DHCEQTemp(TempNode,+$H,Job,""),-1)
}

/// Add by Jdl 2011-11-05 JDL0056
ClassMethod GetTempList(node, job, gnum, rows As %Library.String = "")
{
	s str=$g(^DHCEQTemp(node,+$H,job,gnum))
	if rows'=""
	{		
		for i=1:1:rows-1
		{
			s str=str_$c(2)_^DHCEQTemp(node,+$H,job,gnum+i)
		}
	}
 	q str
}

ClassMethod GetTempNum(node, job)
{
	s gnum=$o(^DHCEQTemp(node,+$H,job,""),-1)
  	q gnum
}

ClassMethod Abs(expression As %String) As %String [ Language = basic ]
{
		return Abs(expression)
}

/// Modified by JDL 2011-6-15 JDL0083
/// 获取当前登录的医院
/// 如果系统参数：是否区分医院 为否时，返回空，为是时，返回当前登录科室所属医院
/// w ##Class(web.DHCEQCommon).GetHospital()
ClassMethod GetHospital()
{
	n HospitalFlag,Hospital,Loc
	s HospitalFlag=##class(web.DHCEQCommon).GetSysInfo("990019")
	i HospitalFlag'="1" q ""
	s LocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	i LocDR="" q ""
	s Hospital=$p($g(^DHCEQCCode("DHCEQCDepartment",LocDR)),"^",8)
	q Hospital
}

/// Add By DJ 2011-07-13
/// 获取医院名称
/// w ##Class(web.DHCEQCommon).GetHospitalDesc()
ClassMethod GetHospitalDesc(vLocDR As %String = "")
{
	n HospitalDR,Hospital
	s Hospital=""
	s HospitalDR=""
	;i vLocDR'="" s HospitalDR=$p($g(^DHCEQCCode("DHCEQCDepartment",vLocDR)),"^",8)
	i vLocDR'="" s HospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(vLocDR)    //modify by jyp 2019-10-18 CTLOC调整
	i (($d(%session)=0)&(HospitalDR="")) q Hospital
	
	i HospitalDR="" s HospitalDR=%session.Data("LOGON.HOSPID")
	i HospitalDR="" s HospitalDR=$p($g(^CTLOC(##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID")))),"^",22)
	i HospitalDR="" s HospitalDR=$o(^CT("HOSP",0))
	i HospitalDR'="" s Hospital=$p($g(^CT("HOSP",HospitalDR)),"^",2)
	i Hospital'="" s Hospital=$TR(Hospital," ","")
	q Hospital
}

ClassMethod GetTitleInfo(TableCode As %String = "")
{
	i TableCode="" q ""
	s TableCode=$ZConvert(TableCode,"U")
	s ID=$o(^DHCEQCCode("DHCEQCTableData",0,"Code",TableCode,0))
	i ID'="" s ID=$p($g(^DHCEQCCode("DHCEQCTableData",ID)),"^",6)
	q ID
}

/// Add by JDL 2011-08-30 JDL0095
/// 记录数据总条目
/// 入参:	Node类方法名称
/// 		Job 任务号
/// 		RowsNum记录总条目
/// 返回:总页数
ClassMethod SetPageInfo(Node, Job, RowsNum)
{
	s ^DHCEQTemp(Node,"PageInfo",Job,"Rows")=RowsNum
}

/// Add by JDL 2011-08-30 JDL0095
/// 获取数据有多少页
/// 入参:	Node类方法名称
/// 		Job 任务号
/// 		RowsPerPage当第一页时传入每页行数,用于计算总页数
/// 返回:总页数
ClassMethod GetPageInfo(Node, Job, RowsPerPage As %String = "")
{
	new RowsNum,PagesNum	
	i (Job="") q 0	
	s RowsNum=$g(^DHCEQTemp(Node,"PageInfo",Job,"Rows"))
	
	s PagesNum=0
	i RowsNum>0
	{
		s PagesNum=1
		i RowsPerPage'=""
		{
			s ^DHCEQTemp(Node,"PageInfo",Job,"RowsPerPage")=RowsPerPage
			if (RowsNum>RowsPerPage)
			{
				s PagesNum=(RowsNum)\(RowsPerPage)
				if ((RowsNum)/(RowsPerPage))>PagesNum s PagesNum=PagesNum+1
			}
			s ^DHCEQTemp(Node,"PageInfo",Job,"PagesNum")=PagesNum
		}
		else
		{
			s PagesNum=$g(^DHCEQTemp(Node,"PageInfo",Job,"PagesNum"))
		}
	}
	q PagesNum
}

/// 日期计算函数：
/// Unit：单位 年为"YYYY",月为"M"
/// MonthStr:格式为"YYYY-MM"
/// w ##Class(web.DHCEQCommon).MonthStrAdd("M",2,"2012-1")
ClassMethod MonthStrAdd(Unit As %String, Qty As %String, MonthStr As %String) As %String
{
	n Year,Month
	i MonthStr="" q ""
	
	s Year=+$p(MonthStr,"-",1)
	s Month=+$p(MonthStr,"-",2)
	i Unit="YYYY"
	{
		s Year=Year+Qty
	}
	elseif Unit="M"
	{		
		s Year=Year+(Qty\12)
		i ((Qty<0)&&((Qty#12)'=0)) s Year=Year-1
		s Month=Month+(Qty#12)
		i Month>12
		{
			s Year=Year+1
			s Month=Month-12
		}		
	}
	else
	{
		q ""
	}
	q Year_"-"_$E("00",1,2-$L(Month))_Month
}

/// 查找substring是否在string里面
/// string：value,value,value...
/// substring:value
/// type:"Y", =; "N",[
/// 返回flag：0，没有找到；1，找到
/// w ##Class(web.DHCEQCommon).Find("1,2,3,4","2","Y")
ClassMethod Find(string, substring, type)
{
	new flag,length,value
	s flag=0
	i substring="" q flag
	s length=$l(string,",")
	f i=1:1:length
	{
		q:flag=1
		s value=$p(string,",",i)
		i (type="Y")&&(substring=value) s flag=1
		i (type="N")&&(value[substring) s flag=1  ;Modified By QW20210129 BUG:QW0089 错误修正
	}
	q flag
}

/// Mozy0145	20141017
ClassMethod AssetTypeList(name, width, type As %String = "") As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	i type="" w "<option value=0></option>"
	w "<option value=1>土地资产</option>"
	w "<option value=2>房屋资产</option>"
	w "<option value=3>构筑物资产</option>"
	w "<option value=4>车辆资产</option>"
	w "<option value=5>专用设备</option>"
	w "<option value=6>通用设备</option>"
	w "<option value=7>家具用具装具</option>"
	w "<option value=8>文物及陈列品</option>"
	w "<option value=9>特种动植物</option>"
	w "<option value=10>图书档案</option>"
	w "<option value=11>无形资产</option>"
	w "</select>",!
}

/// Mozy0145	20141017
/// w ##class(web.DHCEQCommon).GetAssetType(10)
ClassMethod GetAssetType(Type As %String = "")
{
	new AssetType
	
	if (+Type=0)
	{
		Set AssetType=""
	}
	elseif (Type=1)
	{
		Set AssetType="土地资产"
	}
	elseif (Type=2)
	{
		Set AssetType="房屋资产"
	}
	elseif (Type=3)
	{
		Set AssetType="构筑物资产"
	}
	elseif (Type=4)
	{
		Set AssetType="车辆资产"
	}
	elseif (Type=5)
	{
		Set AssetType="专用设备"
	}
	elseif (Type=6)
	{
		Set AssetType="通用设备"
	}
	elseif (Type=7)
	{
		Set AssetType="家具用具装具"
	}
	elseif (Type=8)
	{
		Set AssetType="文物及陈列品"
	}
	elseif (Type=9)
	{
		Set AssetType="特种动植物"
	}
	elseif (Type=10)
	{
		Set AssetType="图书档案"
	}
	elseif (Type=11)
	{
		Set AssetType="无形资产"
	}
	else
	{
		Set AssetType=""
	}
	Quit AssetType
}

/// Mozy0145	20141017
/// Type	0:验收单组件	其他:台账组件
/// w ##class(web.DHCEQCommon).GetAssetTypeComponent(10,0)
ClassMethod GetAssetTypeComponent(val As %String = "", Type As %String = "0")
{
	new AssetTypeComponent
	
	if (val=0)
	{
		Set AssetTypeComponent=""
	}
	elseif (val=1)
	{
		Set AssetTypeComponent="DHCEQLandAssets"	//GR0019 2014-12-15 土地资产
		If Type'=0 Set AssetTypeComponent="DHCEQLandAssetsCard"
	}
	elseif (val=2)
	{
		Set AssetTypeComponent="DHCEQBuildingAssets"          //modified by GR0014 2014-11-18 房屋资产验收
		If Type'=0 Set AssetTypeComponent="DHCEQBuildingAssetsCard"
	}
	elseif (val=3)
	{
		Set AssetTypeComponent="DHCEQStructuresAssets"			//modified by GR0021 2014-12-29 构筑物资产卡片
		If Type'=0 Set AssetTypeComponent="DHCEQStructuresAssetsCard"
	}
	elseif (val=4)
	{
		Set AssetTypeComponent="DHCEQVehicle"        //ZC0019 车辆资产卡片
		If Type'=0 Set AssetTypeComponent="DHCEQVehicleCard"
	}
	elseif (val=5)
	{
		Set AssetTypeComponent="DHCEQOpenCheckRequest"
		If Type'=0 Set AssetTypeComponent="DHCEQEquip"
	}
	elseif (val=6)
	{
		Set AssetTypeComponent=""
	}
	elseif (val=7)
	{
		Set AssetTypeComponent=""
	}
	elseif (val=8)
	{
		Set AssetTypeComponent="DHCEQExhibits"
		If Type'=0 Set AssetTypeComponent="DHCEQExhibitsCard"
	}
	elseif (val=9)
	{
		Set AssetTypeComponent="DHCEQSpecialPlant"
		If Type'=0 Set AssetTypeComponent="DHCEQSpecialPlantCard"
	}
	elseif (val=10)
	{
		Set AssetTypeComponent=""
	}
	elseif (val=11)
	{
		Set AssetTypeComponent="DHCEQIntangibleAssets"
		If Type'=0 Set AssetTypeComponent="DHCEQIntangibleAssetsCard"
	}
	else
	{
		Set AssetTypeComponent=""
	}
	If AssetTypeComponent=""
	{
		Set AssetTypeComponent="DHCEQOpenCheckRequest"
		If Type'=0 Set AssetTypeComponent="DHCEQEquip"
	}
	Quit AssetTypeComponent
}

/// Mozy0145	20141017
/// w ##class(web.DHCEQCommon).GetAssetTypeComponentByStat(10)
ClassMethod GetAssetTypeComponentByStat(StatDR As %String = "", Type As %String = "")
{
	//If StatDR="" Quit ""
	New AssetType
	//Set AssetType=$Piece($Get(^DHCEQCCode("DHCEQCStatCat",StatDR)),"^",10)
	s AssetType=""		//Modify DJ 2015-07-28 DJ0151
	i StatDR'="" Set AssetType=$Piece($Get(^DHCEQCCode("DHCEQCStatCat",StatDR)),"^",5) //GR0015 2014-11-25 兼容卫计委，使用EQType作为资产类型标志位
	Quit ##class(web.DHCEQCommon).GetAssetTypeComponent(AssetType,Type)
}

/// Mozy0145	20141017
/// d ##Class(web.DHCEQCommon).ValueTypeList("ValueTypeList",155)
ClassMethod ValueTypeList(name, width, type As %String = "") As %String
{
	;;下拉列表 ////
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	;i type="" w "<option value=0></option>"
	w "<option value=0>原值</option>"
	w "<option value=1>暂估值</option>"
	w "<option value=2>评估值</option>"
	w "<option value=3>重置值</option>"
	w "<option value=4>无价值</option>"
	
	w "</select>",!
}

/// Mozy0145	20141017
/// d ##Class(web.DHCEQCommon).DirectionsUseList("DirectionsUseList",155)
ClassMethod DirectionsUseList(name, width, type As %String = "") As %String
{
	;;下拉列表 ////
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	;i type="" w "<option value=0></option>"
	w "<option value=0>自用</option>"
	w "<option value=1>其他</option>"
	
	w "</select>",!
}

/// Mozy0145	20141017
/// d ##Class(web.DHCEQCommon).AccountShapeList("AccountShapeList",155)
/// Modified By QW0008 修改已入账:1  未入账:0
ClassMethod AccountShapeList(name, width, type As %String = "") As %String
{
	;;下拉列表 ////
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	;i type="" w "<option value=0></option>"
	w "<option value=1>已入账</option>"
	w "<option value=0>未入账</option>"
	
	w "</select>",!
}

/// ----------------------------------
/// 修改:JDL 2014-12-17  JDL
/// 描述:标准表解析代码函数
/// 入参：codetable:字典表名
/// 			 id:ID值
/// 	返回：字典数据代码		
/// w ##Class(web.DHCEQCommon).GetStandardCode("DHCEQCOrigin","1")
ClassMethod GetStandardCode(codetable, id)
{
	i ((id="")||(codetable="")) q ""
	q $p($g(^DHCEQCCode(codetable,id)),"^",1)
}

/// ----------------------------------
/// 修改:JDL 2014-12-17  JDL
/// 描述:用于标准代码表，根据代码获取ID   解析代码函数
/// 入参：codetable:字典表名
/// 		   code:代码
/// 	返回：字典数据ID
/// w ##Class(web.DHCEQCommon).GetStandardIDByCode("DHCEQCOrigin","01")
ClassMethod GetStandardIDByCode(codetable, code)
{
	n id,rowid
	i ((code="")||(codetable="")) q ""
	
	s id=""
	s rowid=0
	f  s rowid=$o(^DHCEQCCode(codetable,rowid))  quit:((rowid="")||(id'=""))  d
	.q:$p($g(^DHCEQCCode(codetable,rowid)),"^",4)'="N"
	.i $p($g(^DHCEQCCode(codetable,rowid)),"^",1)=code s id=rowid
	
	q id
}

/// Add By DJ 2015-02-10
ClassMethod KillTempGlobalNew(str, i)
{
	new PreDate,Date
	k ^DHCEQTemp(str,+$H,i)
	s PreDate=+$H
	s Date=0
	f  s Date=$o(^DHCEQTemp(str,Date)) q:Date=""  d
	.i Date<PreDate d
	.. k ^DHCEQTemp(str,Date)
}

/// Add By DJ 2015-02-11
/// w ##Class(web.DHCEQCommon).NoToGroupNo("",",")
/// 描述:字符串自动分组合并相同前缀和后缀数据取第一个和最后一个
ClassMethod NoToGroupNo(StrInfo As %String = "", SplitFlag As %String = "")
{
	//测试数据
	;s StrInfo="201201020001,201201020002,201201020003,201201020008,201201020009,201201020010,201301020011,ABCDE0001,ABCDE0002,ABCDE0003,ABCDE0003EF,ABCDF0001CD"
	i StrInfo="" q ""
	i SplitFlag="" s SplitFlag=","
	s StrCount=$L(StrInfo,SplitFlag)
	//清空历史Global
	s CurID=$I(^DHCEQTemp("StrGroup",+$H))
	d ##Class(web.DHCEQCommon).KillTempGlobalNew("StrGroup",CurID)
	//按照数据长度分组写入临时Global
	f i=1:1:StrCount  d
	.s CurStr=$p(StrInfo,SplitFlag,i)
	.q:CurStr=""
	.s CurLen=$L(CurStr)
	.s ^DHCEQTemp("StrGroup",+$H,CurID,CurLen,CurStr)=""
	.s ^DHCEQTemp("StrGroup",+$H,CurID,CurLen)=1+$g(^DHCEQTemp("StrGroup",+$H,CurID,CurLen))
	
	//相同长度字符串获取前缀
	s ReturnStr=""
	s LenID=0
	f  s LenID=$o(^DHCEQTemp("StrGroup",+$H,CurID,LenID))  q:LenID=""  d
	.s Count=$g(^DHCEQTemp("StrGroup",+$H,CurID,LenID))
	.s FirstStr=$o(^DHCEQTemp("StrGroup",+$H,CurID,LenID,0))
	.s LastStr=$o(^DHCEQTemp("StrGroup",+$H,CurID,LenID,""),-1)
	.s ConnectFlag=0
	.i Count'=1  d		//当前长度存在多个字符串
	..s CurStr=FirstStr
	..f  s CurStr=$o(^DHCEQTemp("StrGroup",+$H,CurID,LenID,CurStr))  q:CurStr=""  d
	...i ($ISVALIDNUM(FirstStr)&&$ISVALIDNUM(CurStr))  d	//两个字符串都是数字
	....s PreFix=""
	....f i=1:1:LenID  d
	.....i $E(FirstStr,1,i)=$E(CurStr,1,i)  d
	......s PreFix=$E(FirstStr,1,i)
	.....e  d
	......s i=LenID+1
	....i PreFix=""  d
	.....s ConnectStr=FirstStr
	.....d ConnectInfo
	.....s FirstStr=CurStr
	.....s ConnectFlag=0
	....e  d
	.....i ..LPAD(+$E(FirstStr,$L(PreFix)+1,LenID)+1,0,LenID-$L(PreFix))=$E(CurStr,$L(PreFix)+1,LenID)  d	//连续字符
	......i ConnectFlag=0  d
	.......s ConnectStr=FirstStr_"-"
	.......d ConnectInfo
	.......s ConnectFlag=1
	......s FirstStr=CurStr
	.....e  d
	......s ConnectStr=FirstStr
	......d ConnectInfo
	......s FirstStr=CurStr
	......s ConnectFlag=0
	...e  d
	....i ('$ISVALIDNUM(FirstStr)&&'$ISVALIDNUM(CurStr))  d		//两字符串都不是数字
	.....i ($ISVALIDNUM($E(FirstStr,LenID,LenID))&&$ISVALIDNUM($E(CurStr,LenID,LenID)))  d		//两字符串后面部分是数字
	......s PreFix=""
	......f i=1:1:LenID  d
	.......i $E(FirstStr,1,i)=$E(CurStr,1,i)  d
	........s PreFix=$E(FirstStr,1,i)
	.......e  d
	........s i=LenID+1
	......i PreFix=""  d
	.......s ConnectStr=FirstStr
	.......d ConnectInfo
	.......s FirstStr=CurStr
	.......s ConnectFlag=0
	......e  d
	.......i ..LPAD(+$E(FirstStr,$L(PreFix)+1,LenID)+1,0,LenID-$L(PreFix))=$E(CurStr,$L(PreFix)+1,LenID)  d	//连续字符
	........i ConnectFlag=0  d
	.........s ConnectStr=FirstStr_"-"
	.........d ConnectInfo
	.........s ConnectFlag=1
	........s FirstStr=CurStr
	.......e  d
	........s ConnectStr=FirstStr
	........d ConnectInfo
	........s FirstStr=CurStr
	........s ConnectFlag=0
	.....e  d	//两字符串是纯字符串
	......s ConnectStr=FirstStr
	......d ConnectInfo
	......s FirstStr=CurStr
	......s ConnectFlag=0
	....e  d	//两字符串一个是数字,一个字符串
	.....s ConnectStr=FirstStr
	.....d ConnectInfo
	.....s FirstStr=CurStr
	.....s ConnectFlag=0
	..s ConnectStr=LastStr
	..d ConnectInfo
	.e  d
	..s ConnectStr=FirstStr
	..d ConnectInfo
	
	K ^DHCEQTemp("StrGroup",+$H,CurID)
	
	q ReturnStr
	
ConnectInfo
	i ReturnStr=""  d
	.s ReturnStr=ConnectStr
	e  d
	.i ConnectFlag=0  d
	..s ReturnStr=ReturnStr_","_ConnectStr
	.e  d
	..s ReturnStr=ReturnStr_ConnectStr
	s ConnectStr=""
}

/// Add By DJ 2015-02-15
/// 描述:计算器--根据优先规则定义计算优先级别
ClassMethod Calculator(Str)
{
	i $ISVALIDNUM(Str) q Str
	
	s Len=$L(Str)
	s RightFlag=0
	s LeftFlag=0
	f i=Len:-1:1  d
	.q:LeftFlag'=0
	.i $E(Str,i,i)=")" s RightFlag=i
	.i $E(Str,i,i)="(" s LeftFlag=i
	
	i LeftFlag'=0  d
	.s SplitStr=$E(Str,LeftFlag+1,RightFlag-1)
	.i '$ISVALIDNUM(SplitStr)  d
	..s SplitLen=$L(SplitStr)
	..f j=2:1:SplitLen  d
	...i '$ISVALIDNUM($E(SplitStr,j,j))&&$ISVALIDNUM($E(SplitStr,1,j-1))&&$ISVALIDNUM($E(SplitStr,j+1,SplitLen))  d
	....i $E(SplitStr,j,j)="+"  d
	.....s SplitStr=+$E(SplitStr,1,j-1)+$E(SplitStr,j+1,SplitLen)
	....i $E(SplitStr,j,j)="-"  d
	.....s SplitStr=+$E(SplitStr,1,j-1)-$E(SplitStr,j+1,SplitLen)
	....i $E(SplitStr,j,j)="*"  d
	.....s SplitStr=+$E(SplitStr,1,j-1)*$E(SplitStr,j+1,SplitLen)
	....i $E(SplitStr,j,j)="/"  d
	.....s SplitStr=+$E(SplitStr,1,j-1)/$E(SplitStr,j+1,SplitLen)
	....i $E(SplitStr,j,j)="\"  d
	.....s SplitStr=+$E(SplitStr,1,j-1)\$E(SplitStr,j+1,SplitLen)
	....i $E(SplitStr,j,j)="#"  d
	.....s SplitStr=+$E(SplitStr,1,j-1)#$E(SplitStr,j+1,SplitLen)
	....s j=SplitLen+1
	.s Str=$E(Str,1,LeftFlag-1)_SplitStr_$E(Str,RightFlag+1,Len)
	e  d
	.s LeftFlag=0
	.s RightFlag=0
	.s SplitStr=""
	.f i=1:1:Len  d
	..i $ISVALIDNUM($E(Str,1,i))  d
	...s LeftFlag=i
	.f j=(LeftFlag+2):1:Len  d
	..i $ISVALIDNUM($E(Str,LeftFlag+2,j))  d
	...s RightFlag=j
	.i $E(Str,LeftFlag+1,LeftFlag+1)="+"  d
	..s SplitStr=+$E(Str,1,LeftFlag)+$E(Str,LeftFlag+2,RightFlag)
	.i $E(Str,LeftFlag+1,LeftFlag+1)="-"  d
	..s SplitStr=+$E(Str,1,LeftFlag)-$E(Str,LeftFlag+2,RightFlag)
	.i $E(Str,LeftFlag+1,LeftFlag+1)="*"  d
	..s SplitStr=+$E(Str,1,LeftFlag)*$E(Str,LeftFlag+2,RightFlag)
	.i $E(Str,LeftFlag+1,LeftFlag+1)="/"  d
	..s SplitStr=+$E(Str,1,LeftFlag)/$E(Str,LeftFlag+2,RightFlag)
	.i $E(Str,LeftFlag+1,LeftFlag+1)="\"  d
	..s SplitStr=+$E(Str,1,LeftFlag)\$E(Str,LeftFlag+2,RightFlag)
	.i $E(Str,LeftFlag+1,LeftFlag+1)="#"  d
	..s SplitStr=+$E(Str,1,LeftFlag)#$E(Str,LeftFlag+2,RightFlag)
	.s Str=SplitStr_$E(Str,RightFlag+1,Len)
	
	s Result=..Calculator(Str)
	
	q Result
}

/// add by ZY 2015-4-27 ZY0125
/// 判断科室所在院区是否是当前安全组可以访问的院区
/// 入参：LocID  科室id
/// 	  CurGroupID   当前安全组
/// 返回值: 1:可以访问;0:不能访问
/// w ##Class(web.DHCEQCommon).HospitalIsInclude(1,90)
ClassMethod HospitalIsInclude(LocID, CurGroupID As %String = "", CurHosptailID As %String = "")
{
	//add by zy 2015-04-09  分院区管理,通过科室的医院属性来管理.  需要注意两点
	//1.每个科室的医院属性是否有空值;
	//2.如果有人需要看到所有院区的数据,可以通过两种方式,一是安全组访问医院,二是医院树;
	//3.不传CurHosptailID这些回话变量,不方便以后润乾报表;
	new Flag,HospitalDR,HosptailID,HosptailIDS
	s ManyHosFlag=##class(web.DHCEQCommon).GetSysInfo("990051")	//Add By DJ 2016-11-29
	i ManyHosFlag=0	q 1
	s Flag=1
	s HospitalDR=""		//Add By DJ 2015-07-14 DJ0147
	///modified by zy 20181025 ZY0172  LocID是DHCEQCDepartment表中的ID
	//i LocID'="" s HospitalDR=$p($g(^CTLOC(LocID)),"^",22)   
	/*if LocID'=""//modify by jyp 2019-10-18 CTLOC调整
	{
		s OrganizeType=$p($g(^DHCEQCCode("DHCEQCDepartment",LocID)),"^",7)
		i OrganizeType=1 s HospitalDR=$p($g(^DHCEQCCode("DHCEQCDepartment",LocID)),"^",8)
		if (HospitalDR="")
		{
			s ExType=$p($g(^DHCEQCCode("DHCEQCDepartment",LocID)),"^",10)
			if ExType="DHC_HIS"
			{
				s EXID=$p($g(^DHCEQCCode("DHCEQCDepartment",LocID)),"^",11)
				s HospitalDR=$p($g(^CTLOC(EXID)),"^",22)
			}
		}
	}*///modify by jyp 2019-10-18 CTLOC调整
	i LocID'="" s HospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(LocID)
	I (CurGroupID="")&($d(%session)'=0) Set CurGroupID=%session.Get("LOGON.GROUPID")
	I (CurHosptailID="")&($d(%session)'=0) Set CurHosptailID=%session.Get("LOGON.HOSPID")
	//s CurHosptailID=2
	//s HosptailID=%session.Data("LOGON.HOSPID")
	//根据CurGroupID取当前安全组可以访问到的院区
	//添加HosptailID是否可以访问HospitalDR数据的判断;可以通过安全组可以访问的院?蛘咭皆菏鞯姆绞?
	s HosptailIDS=..GetHospIDSByGroup(CurGroupID)
	
	///modified by ZY0175  没有设置的时候少了一个符号
	i HosptailIDS="" s HosptailIDS="^"
	s HosptailIDS=HosptailIDS_CurHosptailID_"^"
	i (HospitalDR'="")&&(HosptailIDS'[("^"_HospitalDR_"^")) s Flag=0
	quit Flag
}

/// 新增:2009-09-19 党军
/// 描述:用户名称拼音码维护
ClassMethod UserNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = UserNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod UserNameExecute(ByRef qHandle As %Binary, FName As %Library.String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetUserName
	Quit $$$OK
BuildDataGetUserName
	f  s rowid=$o(^SSU("SSUSR",rowid))  quit:rowid=""  d
	.d ResetVariablesGetUserName
	.s TRowID = rowid	//rowid
	.s TName=$p($g(^SSU("SSUSR",rowid)),"^",2) //姓名
	.s TPYCode=$p($g(^DHCEQUserPYTemp(rowid)),"^",2)
	.q:(FName'="")&&($e(TName,1,$l(FName))'=FName)&&($e(TPYCode,1,$l(FName))'=FName)
	.s UserName=$p($g(^DHCEQUserPYTemp(rowid)),"^",1)
	.d OutputRowGetUserName
	quit
OutputRowGetUserName
	s Data=$lb(TRowID,TName,TPYCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetUserName
	s (TRowID,TName,TPYCode)=""
	quit
}

ClassMethod UserNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UserNameExecute ]
{
	
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query UserName(FName As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TPYCode:%String")
{
}

/// 新增:2009-09-19 党军
/// 描述:根据用户RowID,取用户姓名
ClassMethod GetUser(rowid)
{
	s Name=$p($g(^SSU("SSUSR",rowid)),"^",2)
	s PYCode=$p($g(^DHCEQUserPYTemp(rowid)),"^",2)
	q Name_"^"_PYCode
}

/// 新增:2009-09-19 党军
/// 描述:保存用户姓名拼音码
ClassMethod SaveUserPYCode(val As %Library.String = "")
{
 	s rowid=$p(val,"^",1)
 	s Name=$p(val,"^",2)
 	s PYCode=$ZCONVERT($p(val,"^",3),"U")
 	s ^DHCEQUserPYTemp(rowid)=Name_"^"_PYCode
 	q 1
}

/// 简单加密QW-2015-0728
ClassMethod Encrypt(x As %Library.String) As %Library.String
{
	n (x)
	s const=27,out=""
	 f piece=1:1:$l(x) s char=$e(x,piece) d
	 . s num=$a(char)
	 . s num=(num+const)#255
	 . s out=out_num_"%"     
	 q out
}

// w ##class(web.DHCEQEquip).decrypt("55%52%52%48%53%")

/// 简单解密QW-2015-0728
ClassMethod decrypt(x As %Library.String) As %Library.String
{
	n (x)
	s const=27,out=""
	s length=$l(x,"%")-1
	 f piece=1:1:length s num=$P(x,"%",piece) d
	 . s num=(num-const)#255
	 . s char=$c(num)
	 . s out=out_char     
	 q out
}

/// Add By JDL   JDL0137 20150729
/// 根据系统参数，格式化数字，主要用于格式化金额，系统中所有返回金额值，都需调用此函数。
/// 	入参：	Num:		要格式化的数字
///       		IsReport:	是否用于报表，1：用于报表，其他用于非报表
/// 				vDecimal:	指定小数点位数，未指定时，取系统参数设置小数点位数。
/// 				vEmptyFlag:  1:空值不转换，保留空
/// 返回：格式化后的数字
/// w ##Class(web.DHCEQCommon).FormatNumber(8000,1)
ClassMethod FormatNumber(Num As %Library.String, IsReport As %Library.String = "", vDecimal As %Library.String = "", vEmptyFlag As %Library.String = "") As %Library.String
{
	n (Num,IsReport,vDecimal,vEmptyFlag)
	if (Num="")&&(vEmptyFlag=1) q ""
	i vDecimal=""
	{
		;小数位数，系统参数未设置时，系统默认为两位小数
		s Decimal=##class(web.DHCEQCommon).GetSysInfo("990030")
	}
	else
	{
		s Decimal=vDecimal
	}
	i Decimal="" s Decimal=2
	;仅当报表中，才用到千分位符号
	i IsReport=1
	{	
		s ThousandsSymbol=##class(web.DHCEQCommon).GetSysInfo("990031")	
		if ThousandsSymbol="." s ThousandsSymbol=""
		if (ThousandsSymbol'="") s Num=..Replace(Num,ThousandsSymbol,"")
	}
	else
	{	s ThousandsSymbol=""		}
	
	s Num=$Fn(Num,ThousandsSymbol,Decimal)
	q Num
}

/// GR0033 图片上传，可编辑表格用json取数据方法
/// 作用：从json格式数据中获取指定数据值
/// s data=[{"TPicSourceTypeDR":"","TPicTypeDR":"1","TCode":"1","TDesc":"设备外观","TAccess":"N"
/// w ##Class(web.DHCEQCommon).GetJsonDataByName(data,"TAccess",1)
ClassMethod GetJsonDataByName(data, name, index)
{
	s startindex=$f(data,""""_name_""":""",index)
	i (startindex<1)	q ""
	s data=$e(data,startindex,$l(data))
	s endindex=$f(data,"""",index)-2
	//s endindex2=$f(data,"}",index)-2
	//s:(endindex>endindex2) endindex=endindex2
	i (endindex>=0) s data=$e(data,1,endindex)
	q data
}

/// Add By DJ 2015-08-07
/// 描述:获取组件元素信息
/// 参数:vComponentName:组件名
/// 		vItemNames:元素名(为空时取组件所有元素)
/// 		vItemColum:元素信息列
/// 		vItemType:0表示组件元素, 1表示组件列表元素
/// 返回值:元素名1=元素类型1&元素名2=元素类型2&元素名3=元素类型3&
/// d ##Class(web.DHCEQCommon).GetComponentItemInfo("DHCEQInStockNew","TOriginalFee","DataType","1")
ClassMethod GetComponentItemInfo(vComponentName, vItemNames, vItemColum, vItemType)
{
	i vComponentName="" q ""
	&SQL(SELECT ID INTO :vComponentID FROM websys.Component WHERE Name=:vComponentName)
	i vComponentID="" q ""
	s ReturnStr=""
	s ElementID=0
	i vItemType=0  d
	.f  s ElementID=$o(^websys.ComponentItemsD(vComponentID,ElementID))  q:ElementID=""  d
	..s ElementInfo=##class(websys.ComponentItems).%OpenId(vComponentID_"||"_ElementID)
	..s ElementName=ElementInfo.Name
	..q:(vItemNames'="")&&(ElementName'=vItemNames)
	..s ElementType=ElementInfo.DataType
	..s ReturnStr=ReturnStr_ElementName_"="_ElementType_"&"
	e  d
	.f  s ElementID=$o(^websys.ComponentTableItemsD(vComponentID,ElementID))  q:ElementID=""  d
	..s ElementInfo=##class(websys.ComponentTableItems).%OpenId(vComponentID_"||"_ElementID)
	..s ElementName=ElementInfo.Name
	..q:(vItemNames'="")&&(ElementName'=vItemNames)
	..s ElementType=ElementInfo.DataType
	..s ReturnStr=ReturnStr_ElementName_"="_ElementType_"&"
	
	q ReturnStr
}

/// Add By zx 2015-08-02
/// 入参为安全组RowID
/// 获取安全组对应的移动端菜单权限,输出为业务定义的代码的字符串,
/// 移动端代码对应菜单对象里初始化菜单数组中菜单的位置
/// w ##Class(web.DHCEQCommon).GetMenusInfo("85")   add by zx 2015-08-28 Bug0031
ClassMethod GetMenusInfo(CurGroupID)
{
	i CurGroupID ="" q ""
	s (GMMenuDR, BussTypeDR, BussTypeCode)=""
	s Menu="@"
	s SysGroupMenusID =0
	f  s SysGroupMenusID =$o(^DHCEQCCode("DHCEQCSysGroupMenu",0,"GMGroupDR",CurGroupID,SysGroupMenusID)) q:SysGroupMenusID=""  d
	.s GMMenuDR =$p($g(^DHCEQCCode("DHCEQCSysGroupMenu",SysGroupMenusID)),"^",2)
	.q:GMMenuDR=""
	.s Menu=Menu_GMMenuDR_"^"
	
	q Menu
}

/// 20150825  Mozy0163	调整新增通用获取审批意见方法
/// 获取审批意见
/// w ##Class(web.DHCEQCommon).GetApproveInfo(8,5)
ClassMethod GetApproveInfo(SourceType As %Library.String = "", SourceID As %Library.String = "")
{
	If (SourceType="") || (SourceID="") Quit ""
	new list
	Set ApproveInfo=""
	Set list=0
	For  Set list=$Order(^DHCEQApproveList(0,"Source",SourceType,SourceID,list)) Quit:list=""  Do
	.Set Opinion=$Piece($Get(^DHCEQApproveList(list)),"^",3)
	.Set ApproveRole=##class(web.DHCEQCommon).GetTrakNameByID("role",$Piece($Get(^DHCEQApproveList(list)),"^",5))
	.Set ApproveUser=##class(web.DHCEQCommon).GetTrakNameByID("user",$Piece($Get(^DHCEQApproveList(list)),"^",6))
	.Set ApproeeUserDate=##class(web.DHCEQCommon).TransValueToPage($Piece(^DHCEQApproveList(list),"^",7),"date")
	.If ApproveInfo'="" Set ApproveInfo=ApproveInfo_"_"
	.Set ApproveInfo=ApproveInfo_ApproveRole_","_Opinion_","_ApproveUser_","_ApproeeUserDate
	
	Quit ApproveInfo
}

/// Mozy	2015-11-25
/// 用户权限范围限定
/// 返回值:		0用户有权操作 	非0时没有权限
/// 需要加条件的地方加入 Quit:(##Class(web.DHCEQCommon).CheckManageLimitNew())即可
/// w ##Class(web.DHCEQCommon).CheckManageLimit(2623,77,"",2,21,2690,79,109,"")
ClassMethod CheckManageLimit(CurUserID As %Library.String = "", CurGroupID As %Library.String = "", RoleDR As %Library.String = "", EquipTypeDR As %Library.String = "", StatCatDR As %Library.String = "", EquipCatDR As %Library.String = "", LocDR As %Library.String = "", EquipDR As %Library.String = "", ItemDR As %Library.String = "")
{
	n UserID, GroupID, mlrowid, mllrowid, CheckFlag,SourceType,SourceID
	s UserID = CurUserID
	i UserID ="" s UserID = ##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s GroupID=CurGroupID
	i GroupID ="" s GroupID = %session.Get("LOGON.GROUPID")
	;s ^DHCEQMozy("CheckManageLimit")=UserID_","_GroupID_","_RoleDR_","_EquipTypeDR_","_StatCatDR_","_EquipCatDR_","_LocDR_","_EquipDR_","_ItemDR
	
	s mlrowid = $Order(^DHCEQCCode("DHCEQCManageLimit",0,"User",+UserID,GroupID,+RoleDR,0))
	i mlrowid="" s mlrowid = $Order(^DHCEQCCode("DHCEQCManageLimit",0,"User",+UserID,GroupID,0,0))
	i mlrowid="" Quit 0		;未设置权限则不限制访问范围
	;w mlrowid,!	.s accessflag=$p($g(^DHCEQCCode("DHCEQCManageLimitList",mrowid)),"^",4)
	Set CheckFlag=0
	if (EquipDR'="")&&($Piece($Get(^DHCEQCCode("DHCEQCManageLimit",mlrowid)),"^",8)="Y")
	{
		Set SourceType=5,SourceID=EquipDR
		d CheckLimitSourceType
		If CheckFlag'=2 Quit CheckFlag
		Set CheckFlag=0
	}
	
	if (EquipTypeDR'="")&($Piece($Get(^DHCEQCCode("DHCEQCManageLimit",mlrowid)),"^",4)="Y")
	{
		Set SourceType=1,SourceID=EquipTypeDR
		d CheckLimitSourceType
		If CheckFlag=1 Quit CheckFlag
	}
	if (StatCatDR'="")&($Piece($Get(^DHCEQCCode("DHCEQCManageLimit",mlrowid)),"^",5)="Y")
	{
		Set SourceType=2,SourceID=StatCatDR
		d CheckLimitSourceType
		If CheckFlag=1 Quit CheckFlag
		
	}
	if (EquipCatDR'="")&($Piece($Get(^DHCEQCCode("DHCEQCManageLimit",mlrowid)),"^",6)="Y")
	{
		Set SourceType=3,SourceID=EquipCatDR
		d CheckLimitSourceType
		If CheckFlag=1 Quit CheckFlag
	}
	if (LocDR'="")&($Piece($Get(^DHCEQCCode("DHCEQCManageLimit",mlrowid)),"^",7)="Y")
	{
		Set SourceType=4,SourceID=LocDR
		d CheckLimitSourceType
		If CheckFlag=1 Quit CheckFlag
	}
	if (ItemDR'="")&($Piece($Get(^DHCEQCCode("DHCEQCManageLimit",mlrowid)),"^",9)="Y")
	{
		Set SourceType=6,SourceID=ItemDR
		d CheckLimitSourceType
		If CheckFlag=1 Quit CheckFlag
	}
	
	Quit CheckFlag
CheckLimitSourceType
	i $d(^DHCEQCCode("DHCEQCManageLimitList",0,"LimitValue",mlrowid,SourceType))	//存在配置
	{
		s mllrowid=$o(^DHCEQCCode("DHCEQCManageLimitList",0,"LimitValue",mlrowid,SourceType,SourceID,""))
		i mllrowid'=""		//当前类范围有限定配置
		{
			i $p($g(^DHCEQCCode("DHCEQCManageLimitList",mllrowid)),"^",4)'="Y" s CheckFlag=1	
		}
		else
		{
			i SourceType=5
			{
				s CheckFlag=2
			}
			else
			{
				i $d(^DHCEQCCode("DHCEQCManageLimitList",0,"AccessFlag",mlrowid,SourceType,"Y")) Set CheckFlag=1
			}
		}
	}
	else
	{
		i SourceType=5
		{
			s CheckFlag=2
		}
		else
		{
			s CheckFlag=1		//当前类范围有限定但无明细配置
		}
	}
	Quit
}

/// Descript:格式化Json数据串
ClassMethod getJsonData(Title As %String, DataList As %String, Deli As %String = "^") As %String
{
	N (Title,DataList,Deli)
	S del=""""
	S jsonStr=""
	S HLen=$L(Title,Deli)  //列
	S DLen=$L(DataList,Deli) //值
	F i=1:1:HLen  d
	.S Name=$p(Title,Deli,i)
	.S Value=$p(DataList,Deli,i)
	.S Value=$tr(Value,$c(10))   ;替换换行符
	.S Value=$tr(Value,$c(13))	;替换回车符
	.S Value=##Class(web.DHCEQCommon).Replace(Value,"\","\\")
	.S Value=##Class(web.DHCEQCommon).Replace(Value,"'","\'")
	.i i=1 d
	..S jsonStr="{"_del_Name_del_":"_del_Value_del
	.e  d
	..S jsonStr=jsonStr_","_del_Name_del_":"_del_Value_del
	S jsonStr=jsonStr_"}"
	S jsonStr=$tr(jsonStr,$c(13,10))
	Q jsonStr
}

/// Add By DJ 2016-05-24
/// 描述:补登消息功能(受理动作时补登派单消息,组长审核补登消息)
ClassMethod ReissueMessage(vJob, vBussType, vBussID, vNextActionDR, vNextRoleDR, vUserDR, ApproveSet)
{
	i ((vNextActionDR="")||(vNextRoleDR="")||(ApproveSet="")) q ""
	s NextActionCode=$p($g(^DHCEQCCode("DHCEQCAction",vNextActionDR)),"^",1)
	i ((NextActionCode="WX_Accept")||(NextActionCode="WX_Maint"))  d		//获取派单审批流
	.s vNextActionDR=""
	.s vNextRoleDR=""
	.s AssignDR=$o(^DHCEQCCode("DHCEQCAction",0,"Code","WX_Assign",0))
	.i AssignDR'=""  d
	..s AFRowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"Action",ApproveSet,AssignDR,0))
	..i AFRowID'=""  d
	...s AssignRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AFRowID)),"^",2)
	...s vNextActionDR=AssignDR
	...s vNextRoleDR=AssignRoleDR
	
	i ((NextActionCode="WX_Accept")&&(vNextActionDR="")&&(vNextRoleDR="")) q ""		//无派单审批流设置
	i ((NextActionCode="WX_Maint")&&(vNextActionDR="")&&(vNextRoleDR="")) q ""		//无派单审批流设置
	
	s vCurUserDR=vUserDR
	i ((NextActionCode="WX_Accept")||(NextActionCode="WX_Maint")||(NextActionCode="WX_Evaluate"))  d		//受理补登派单业务,维修补登派单业务,组长审核
	.i vBussType=31  d
	..i NextActionCode="WX_Evaluate" s vCurUserDR=$p($g(^DHCEQMMaintRequest(vBussID)),"^",26)
	..q:vCurUserDR=""
	..s MGLRowID=0
	..f  s MGLRowID=$o(^DHCEQCCode("DHCEQMCMaintGroupList",0,"MaintMember","N",vCurUserDR,MGLRowID))  q:MGLRowID=""  d
	...s MGRowID=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",MGLRowID)),"^",1)
	...s MGInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",9)
	...q:MGInvalidFlag="Y"
	...s LeaderUserDR=$p($g(^DHCEQCCode("DHCEQMCMaintGroup",MGRowID)),"^",5)
	...d SetReissueMessage
	
	q
	
SetReissueMessage
	i $d(^DHCEQTemp("MessagesRecieveUser",vJob,vBussType,vBussID,LeaderUserDR,0))  d
	.i (","_^DHCEQTemp("MessagesRecieveUser",vJob,vBussType,vBussID,LeaderUserDR,0,"Role")_",")'[(","_vNextRoleDR_",")  d
	..s ^DHCEQTemp("MessagesRecieveUser",vJob,vBussType,vBussID,LeaderUserDR,0,"Role")=^DHCEQTemp("MessagesRecieveUser",vJob,vBussType,vBussID,LeaderUserDR,0,"Role")_","_vNextRoleDR
	..s ^DHCEQTemp("MessagesRecieveUser",vJob,vBussType,vBussID,LeaderUserDR,0,"Action")=^DHCEQTemp("MessagesRecieveUser",vJob,vBussType,vBussID,LeaderUserDR,0,"Action")_","_vNextActionDR
	e  d
	.s ^DHCEQTemp("MessagesRecieveUser",vJob,vBussType,vBussID,LeaderUserDR,0,"Role")=vNextRoleDR
	.s ^DHCEQTemp("MessagesRecieveUser",vJob,vBussType,vBussID,LeaderUserDR,0,"Action")=vNextActionDR
}

/// Add By DJ 2016-06-07
/// 描述:根据科室类型代码获取该科室类型下第一个ID号
/// 入参:vLocType科室类型代码, vDescFlag返回名称标志
ClassMethod GetFirstIDByLocType(vLocType As %String = "", vDescFlag As %String = "")
{
	i vLocType="" q ""
	s LocTypeID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code",vLocType,0))
	i LocTypeID="" q ""
	s ReturnID=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeID,0))
	i vDescFlag="Y" q ##Class(web.DHCEQCommon).GetTrakNameByID("dept",ReturnID)
	q ReturnID
}

ClassMethod GetBussinessType(name, width, type As %String = "") As %String
{
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	i type="" w "<option value=></option>"
	w "<option value=RK>入库</option>"
	w "<option value=ZY>转移</option>"
	w "<option value=TH>退货</option>"
	w "<option value=JS>减少</option>"
	w "<option value=BF>报废</option>"
	;w "<option value=TZ>台帐</option>"
	w "<option value=CA>调账</option>"
	w "<option value=ZJ>折旧</option>"
	w "</select>",!
}

ClassMethod GetBussinessTypeDisplay(type As %Library.String) As %Status
{
	i type=""  q ""
	i type="RK"  q "入库"
	i type="ZY"  q "转移"
	i type="TH"  q "退货"
	i type="JS"  q "减少"
	i type="BF"  q "报废"
	;i type="TZ"  q "台帐"
	i type="ZJ"  q "折旧"
	i type="CA"  q "调账"
	q "未定义"
}

Query DHCEQEquipType() As %SQLQuery(ROWSPEC = "Code:%String,Name:%String,Source:%String,Bend:%String,EQFlag:%String") [ SqlProc ]
{
}

ClassMethod DHCEQEquipTypeExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	s RowID=0
 	f  s RowID=$o(^DHCEQCCode("DHCEQCEquipType",RowID))  q:RowID=""  d
 	.d ResetDHCEQEquipType
 	.s Code=RowID
 	.s Name=$p($g(^DHCEQCCode("DHCEQCEquipType",RowID)),"^",2)
 	.s Source=""
 	.s Bend="1"
 	.s EQFlag="1"
 	.i RowID=10 s EQFlag="0"		//无形资产
 	.d OutPutDHCEQEquipType
 	
	Quit $$$OK
OutPutDHCEQEquipType
	s Data=$lb(Code,Name,Source,Bend,EQFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetDHCEQEquipType
	s (Code,Name,Source,Bend,EQFlag)=""
	quit
}

ClassMethod DHCEQEquipTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCEQEquipTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DHCEQEquipTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCEQEquipTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// Add By HHM 2016-05-16 
/// 微信调用后台方法：方法参数转为XML格式
/// 返回值：封装为XML格式
/// parameterinfo:后台返回值串格式："TRowID^TName^TNo^TModel^TLeaveFactoryNo^TUseLoc^TUseLocDR^TOriginalFee^TFileNo^TEquipTypeDR^TStatCatDR"
/// strinfo:后台类返回值："7^颅内压监护仪^3220199000003^LY-II^02023^SJWK-神经外科^89^2380^N2078^2^7"
/// d ##Class(web.DHCEQCommon).OutputToXml()
ClassMethod OutputToXml(parameterinfo, strinfo)
{
	s result=""
	q:parameterinfo=""
	q:strinfo=""
	s len=$l(parameterinfo,"^")
	s i=0
	f i=1:1:len d
	.s result=result_"<"_$p(parameterinfo,"^",i)_">"_$p(strinfo,"^",i)_"</"_$p(parameterinfo,"^",i)_">"	
	q "<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData>"_result_"</DirectorData></ResultList></Response>"
}

/// add by HHM 2016-05-17
/// Desc:用于解析字符串格式，再转为xml格式
/// info:字符串格式："DHCEQCFaultReason"
/// 返回值:XML格式的字符串
/// w ##Class(web.DHCEQCommon).doFormatToXML("DHCEQCFaultReason")
ClassMethod doFormatToXML(tablename)
{
	s result=""
	i tablename="DHCEQMCMaintProcess" s info="0-维修中&1-等待配件&2-返厂维修&3-其他&4-保内维修" 
	e  s info=##class(web.DHCEQM.DHCEQMaintForService).GetMaintBasisData(tablename)
	s code=""
	s desc=""

	s i=0
	s len=$l(info,"&")
	f i=1:1:len
	{
		s code=$p($p(info,"&",i),"-",1)
		s desc=$p($p(info,"&",i),"-",2)
		s temp="<code>"_code_"</code>"_"<desc>"_desc_"</desc>"
		s result=result_temp
	}
	s result="<Response><ResultCode>0</ResultCode><ResultDesc></ResultDesc><ResultList><DirectorData>"_result_"</DirectorData></ResultList></Response>"	
	q result
}

ClassMethod GetMenuInfo(MenuID As %String = "", ColumName As %String = "")
{
	i ((MenuID="")||(ColumName="")) q ""
	i ColumName="Name" q $LIST(^websys.MenuD(MenuID),1)
	q ""
}

/// Add By DJ 2016-11-14
/// 描述:检测业务图片是否上传
/// 入参:vBussCode  业务代码   vBussRowID   业务RowID    vPicTypeDR  图片类型DR
/// 返回值:0未上传  1已上传
ClassMethod CheckBussPicUpload(vBussCode As %String = "", vBussRowID As %String = "", vPicTypeDR As %String = "")
{
	i (vBussCode="")||(vBussRowID="")||(vPicTypeDR="")  q 0
	s UpLoadFlag=0
	s PRowID=0
	f  s PRowID=$o(^DHCEQPicture(0,"Source",vBussCode,vBussRowID,PRowID))  q:(PRowID="")||(UpLoadFlag'=0)  d
	.s PInvalidFlag=$p($g(^DHCEQPicture(PRowID)),"^",7)
	.q:PInvalidFlag=2			//过滤已删除图片
	.s PTypeDR=$p($g(^DHCEQPicture(PRowID)),"^",5)
	.q:PTypeDR'=vPicTypeDR
	.s UpLoadFlag=1
	
	q UpLoadFlag
}

/// Add By JDL 20161221
/// 方法说明：计算 日期时间2 与 日期时间1的 时间差，并返回时间差描述。
/// 入参：	date1：日期1
/// 			time1：时间1
/// 			date2：日期2
/// 			time2：时间2
/// 			descFlag:是否返回时间差描述，0否 1是	
/// 返回值： 日期相差值， 表示日期时间2大于日期时间1 相差秒数^天,时,分,秒
/// 			例如：w ##Class(web.DHCEQCommon).TimeDiff(64273,32437,64283,52437)  
/// 						时间1(12/21/2016 09:00:37),时间2(12/31/2016 14:33:57)
/// 				返回值：884000,10天5小时33分钟20秒
ClassMethod TimeDiff(date1, time1, date2, time2, descFlag As %Library.String = "1") As %String
{
	n vDiffValue,vDiffDesc,vDay,vHour,vMinute,vSecond
	s vDay=date2-date1
	s vSecond=time2-time1
	;差值单位为秒
	s vDiffValue=vDay*86400+vSecond
	i descFlag'=1 q vDiffValue_"^"
	
	s vSecond=vDiffValue
	if (vSecond<0) s vSecond=(-1)*vSecond
	
	s vDiffDesc=""
	s vDay=vSecond\86400
	s vSecond=vSecond-(vDay*86400)
	s vHour=vSecond\3600
	s vSecond=vSecond-(vHour*3600)
	s vMinute=vSecond\60
	s vSecond=vSecond-(vMinute*60)
	if vDay>0 s vDiffDesc=vDay_"天"
	if vDiffDesc'=""
	{	s vDiffDesc=vDiffDesc_vHour_"小时"	}
	else
	{	if vHour>0 s vDiffDesc=vHour_"小时"}
	
	if vDiffDesc'=""
	{	s vDiffDesc=vDiffDesc_vMinute_"分钟"	}
	else
	{	if vMinute>0 s vDiffDesc=vMinute_"分钟"}
	
	s vDiffDesc=vDiffDesc_vSecond_"秒"
	if vDiffValue<0 s vDiffDesc="-"_vDiffDesc
	q vDiffValue_","_vDiffDesc
}

/// 日期计算函数： add by jdl 2017-3-6
/// 入参
/// 	unit：单位 年为"YYYY",月为"M",天为"D"
/// 	fromdate:数字格式的日期///		
/// 返回值：
/// 		返回计算结果的日期值（数字格式）
/// w ##Class(web.DHCEQCommon).DateAddInt("YYYY",1,64348)
ClassMethod DateAddInt(unit As %String, qty As %String, fromdate As %String) As %String
{
	n ReturnDate
	if (fromdate="") q ""
	s fromdate=$zd(fromdate,1)
	s ReturnDate=..DateAddApp(unit,qty,fromdate)
	i $E(ReturnDate,1,5)="02/29" //检测是否为2月29日
	{
		s Year=$E(ReturnDate,7,10) //年份
		i '((Year#400=0)||((Year#4=0) && (Year#100'=0))) //非闰年
		{
			s ReturnDate="02/28/"_$E(ReturnDate,7,10)
		}
	}	
	s ReturnDate=$zdh(ReturnDate,1)
	q ReturnDate
}

/// Add By JDL 2017-03-17
ClassMethod CreateCombox(name, width, type As %String = "", valuelist, desclist) As %String
{
	w "<select name='"_name_"' id='"_name_"' style='width:130' HEIGHT=0>"
	s valueCount=$L(valuelist,",")
	f i=1:1:valueCount
	{
		s CurValue=$p(valuelist,",",i)
		s CurText=$p(desclist,",",i)
		w "<option value='"_CurValue_"'>"_CurText_"</option>"
	}
	w "</select>",!
}

/// Add By DJ 2017-03-21
ClassMethod GetHospIDSByGroup(vGroupDR As %String = "")
{
	i vGroupDR="" q ""
	s HospIDs=""
	s HospRowID=0
	f  s HospRowID=$o(^DHCEQCCode("DHCEQCGroupHospital",0,"GroupHospital",vGroupDR,HospRowID))  q:HospRowID=""  d
	.i HospIDs="" s HospIDs="^"
	.s HospIDs=HospIDs_HospRowID_"^"
	
	q HospIDs
}

/// Add By DJ 2017-04-07
/// w ##class(web.DHCEQCommon).IsValidMethodName("websys.Conversions","DateHtmlToLogical")
/// 备注:来源与websys.Conversions.cls
ClassMethod IsValidMethodName(classname As %Library.String, methodname As %Library.String) As %Library.Boolean
{
	n (classname, methodname)
	s $ZT="ERROR^DHCSSERR"
	q:((classname="")||(methodname="")) 0
	s myobj=##class(%Dictionary.CompiledMethod).%OpenId(classname_"||"_methodname)
	s myrtn=0
	i ($IsObject(myobj)){
		s myobj=""
		s myrtn = 1
	}
	q myrtn
}

/// 获取两个日期差
/// interval, date1, date2 [,firstdayofweek[, firstweekofyear]]
/// interval：yyyy Year
/// 			 q Quarter
/// 			 m Month 
/// 			 y Day of Year 
/// 			 d Day
/// 			 w Weekday
/// 			 ww Week of Year
/// 			 h Hour
/// 			 n Minute
/// 			 s Second
/// 	date1,date2格式：数字型
/// 	返回date2-date1
/// 	w ##Class(web.DHCEQCommon).DateDiffInt("d","7/15/2010","7/23/2009")
ClassMethod DateDiffInt(interval, date1, date2) As %String
{
	q ..DateDiff(interval, $zd(date1), $zd(date2))
}

/// add by czf 2017-08-02
/// 返回日期加上某一月份数之后的日期
/// 入参：Date:格式"yyyy-mm",Num：月份数
/// w ##Class(web.DHCEQCommon).GetCurYearMonth("2016-10","")
ClassMethod GetYearMonth(Date, Num)
{
    ///add by zy 20221107  BugNo=2953817
    new DateYear,DateMonth,Months,CurMonth,CurYear,CurDate
	i Date="" q ""
	i Num<0 q ""
	s DateYear=$p(Date,"-",1)
	s DateMonth=$p(Date,"-",2)
	s Months=DateMonth+Num
	s CurMonth=Months#12
	s CurYear=Months\12+DateYear
	i CurMonth=0 d
	.s CurMonth=12
	.s CurYear=CurYear-1
	s CurDate=CurYear_"-"_CurMonth
	q CurDate
}

ClassMethod DateFormat()
{
	n
	s dateformat=$lg(^websys.ConfigurationD(1),10)
	s datesper=$lg(^websys.ConfigurationD(1),4)
	i (dateformat="DMY")&&(datesper="/") Quit 4
	i (dateformat="YMD")&&(datesper="-") Quit 3
	i (dateformat="MDY")&&(datesper="/") Quit 1
	Quit 4
}

ClassMethod WriteDateFormat()
{
	Set format = ##class(web.DHCEQCommon).DateFormat()
	w "<script type='text/javascript'>",!
	w "if ($.fn.datebox){",!
	w "$.fn.datebox.defaults.formatter = function(date){",!
	w "	var y = date.getFullYear();",!
	w "	var m = date.getMonth()+1;",!
	w "	var d = date.getDate();",!
	w:format=3 "	return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);",!
	w:format=4 "	return (d<10?('0'+d):d)+'/'+(m<10?('0'+m):m)+'/'+y;",!
	w "};",!
	w "$.fn.datebox.defaults.parser = function(s){",!
	w "	if (!s) return new Date();",!
	if (format=3){	
		w "	var ss = s.split('-');",!
		w "	var y = parseInt(ss[0],10);",!
		w "	var m = parseInt(ss[1],10);",!
		w "	var d = parseInt(ss[2],10);",!
	}elseif(format=4){
		w "	var ss = s.split('/');",!
		w "	var y = parseInt(ss[2],10);",!
		w "	var m = parseInt(ss[1],10);",!
		w "	var d = parseInt(ss[0],10);",!
	}
	w "	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){",!
	w "		return new Date(y,m-1,d);",!
	w "	} else {",!
	w "		return new Date();",!
	w "	}",!
	w "};",!
	w "}",!
	w "</"_"script>",!
}

ClassMethod GetDefaultStyle(name, width, promtinfo As %String = "")
{
	if (width="")||(width=0) s width=155	//modified by czf 20181211
	q "<select name='"_name_"' id='"_name_"' style='width:"_width_"px;HEIGHT:30px;' class='hisui-combobox' data-options='prompt:"""_promtinfo_"""' >"   //modified by myl   1805950   20210318
}

/*
 *Description 通过his基础数据id获取EQ对照表id
 *param tableName:对照关系类型
 *param ID:his基础数据id
 *author zouxuan 2018-08-10
 *return 对照表rowid^code^desc,不存在时返回空
*/

// w ##Class(web.DHCEQCommon).getMapIDBySource("user","393")

ClassMethod getMapIDBySource(tableName As %Library.String, ID As %Library.String)
{
	//Modify by zx 2021-12-01 变量初始化 需求号:2310000
	n result,locID,userID,userCode,userName
	i ID=""  q ""
	if (tableName="dept")
	{
		s result=$o(^DHCEQCCode("DHCEQCDepartment","0","ExID","Y","1",ID,""))
		q result
	}
	if (tableName="deptinfo")
	{
		s locID=$o(^DHCEQCCode("DHCEQCDepartment","0","ExID","Y","1",ID,""))
		i locID="" q "^"
		s result=$p($g(^DHCEQCCode("DHCEQCDepartment",locID)),"^",2)
		q locID_"^"_result
	}
	if (tableName="deptname")
	{
		s locID=$o(^DHCEQCCode("DHCEQCDepartment","0","ExID","Y","1",ID,""))
		i locID="" q ""
		s result=$p($g(^DHCEQCCode("DHCEQCDepartment",locID)),"^",2)
		q result
	}
	elseif (tableName="user")
	{
		s userID=$o(^DHCEQCCode("DHCEQCUser",0,"ExID","Y",ID,""))
		q userID
	}
	elseif (tableName="userinfo")
	{
		s userID=$o(^DHCEQCCode("DHCEQCUser",0,"ExID","Y",ID,""))
		i userID="" q "^^"
		s userCode=$p($g(^DHCEQCCode("DHCEQCUser",userID)),"^",1)
		s userName=$p($g(^DHCEQCCode("DHCEQCUser",userID)),"^",4)
		q userID_"^"_userCode_"^"_userName
	}
	elseif (tableName="usercode")
	{
		s userID=$o(^DHCEQCCode("DHCEQCUser",0,"ExID","Y",ID,""))
		i userID="" q ""
		s userCode=$p($g(^DHCEQCCode("DHCEQCUser",userID)),"^",1)
		q userCode
	}
	elseif (tableName="username")
	{
		s userID=$o(^DHCEQCCode("DHCEQCUser",0,"ExID","Y",ID,""))
		i userID="" q ""
		s userName=$p($g(^DHCEQCCode("DHCEQCUser",userID)),"^",4)
		q userName
	}
}

/// Modify by zx 2020-07-08 登陆调整
/// w ##Class(web.DHCEQCommon).InnerLogon("demo","p@s94")
ClassMethod InnerLogon(LogonName, LogonPassword) As %String
{
	s (result,LogonLocDesc)=""
	//Modify by zx 2021-07-08 处理登录用户名不区分大小写
	s UserID=$O(^DHCEQCCode("DHCEQCUser",0,"ULoginName","Y",$ZCVT(LogonName,"U"),""),-1)
	if UserID="" q "-3"
	s ExType=$p($g(^DHCEQCCode("DHCEQCUser",UserID)),"^",18)
	s LogonID=$p($g(^DHCEQCCode("DHCEQCUser",UserID)),"^",19)
	i ExType="1" d
	.s result=##Class(web.DHCEQCommon).Logon(LogonName, LogonPassword)
	e  d
	.s Password=$p($g(^DHCEQCCode("DHCEQCUser",UserID)),"^",2)
	.if (Password="")||(Password'=LogonPassword) s result="-4"
	.q:result'=""
	.s UserName=$p($g(^DHCEQCCode("DHCEQCUser",UserID)),"^",4)
	.s LogonLoc=$p($g(^DHCEQCCode("DHCEQCUser",UserID)),"^",14)
	.i LogonLoc'="" s LogonLocDesc=##class(web.DHCEQCommon).GetTrakNameByID("dept",LogonLoc)
	.s LogonGroup=$p($g(^DHCEQCCode("DHCEQCUser",UserID)),"^",15)
	.s LogonGroup=LogonGroup_","_LogonLoc
	.s result=LogonID_"^"_UserName_"^"_LogonLocDesc_"^"_LogonGroup_"^"_ExType
	q result
}

/// add by jyp 2019-01-11
/// 根据参数（990039）所对应的日期和保修期自动计算保修结束日期保存到台帐表中
/// 入参：Date:格式"yyyy-mm",Num：月份数
/// D ##Class(web.DHCEQCommon).UpdateGuaranteeEndDate(2)
ClassMethod UpdateGuaranteeEndDate(EquipID)
{
	s GuaranteeEndDate = ..TransValueToPage($p($g(^DHCEQEquip(EquipID)),"^",51),"date")
	s GuaranteePeriodNum=$p($g(^DHCEQEquip(EquipID)),"^",73)
	i ((GuaranteeEndDate="")&&(GuaranteePeriodNum'=""))  d
	.s BeginFlag=..GetSysInfo("990039")
	.if BeginFlag=0  d
	..s BeginDate=$p($g(^DHCEQEquip(EquipID)),"^",13)
	.e  d
	..s BeginDate=$p($g(^DHCEQEquip(EquipID)),"^",45)
	.
	.s GuaranteeEndDate=..DateAddInt("M",$p($g(^DHCEQEquip(EquipID)),"^",73),BeginDate)
	&SQL(update SQLUSER.DHC_EQEquip set EQ_GuaranteeEndDate=:GuaranteeEndDate where EQ_RowID = :EquipID)
}

/// add by jyp 2019-01-11
/// 根据参数（990039）所对应的日期和保修期自动计算所有台账内的保修结束日期保存到台帐表中
/// 入参：Date:格式"yyyy-mm",Num：月份数
/// D ##Class(web.DHCEQCommon).UpdateAllGuaranteeEndDate()
ClassMethod UpdateAllGuaranteeEndDate()
{
	s rowid=0
	f  s rowid=$o(^DHCEQEquip(rowid))  quit:rowid=""  d
	.D ##Class(web.DHCEQCommon).UpdateGuaranteeEndDate(rowid)
}

/// FromType	0:验收明细 1:设备 2:附件 3:入库明细 4:转移明细 5:退货明细 6:报废明细 7:调账明细 9:调整数据设备 10:配件入库 11:配件出库 12:配件库存
/// FromID		来源ID
/// IncludeFlag:是否包含无效资金类型	0:不包含  其他:包含
/// FacilityFlag:是否包含简易台账资产类组 0  和 空 在账资产类组;  1  简易资产类组;  2  全部类组
/// Flag=0可以显示
/// 需要加条件的地方加入q:(##Class(web.DHCEQCommon).FundsTypeIsIn(Type,ID))即可
/// w ##Class(web.DHCEQCommon).FundsTypeIsIn(0,97,85)
/// w ##Class(web.DHCEQCommon).FundsTypeIsIn(1,121,85)
/// w ##Class(web.DHCEQCommon).FundsTypeIsIn(3,221,85)
/// w ##Class(web.DHCEQCommon).FundsTypeIsIn(12,73,85)
ClassMethod FundsTypeIsIn(FromType, FromID, CurGroupID As %String = "")
{
	new GroupID,Flag,tmpFTDR,tmpValue,EQCount,EQID
	set GroupID=CurGroupID
	
	if GroupID="" s GroupID=%session.Get("LOGON.GROUPID")
	s Flag=0
	;s ^DHCEQMozy(FromType, FromID)=GroupID
	/// ^DHCEQCCode("DHCEQCGroupFundsType","0","Group","85","2","1")
	i FromType=0 //验收单
	{
		s FTDR=0
		f  s FTDR=$o(^DHCEQFunds("0","CheckListType",FromID,FTDR)) q:(FTDR="")||(Flag'=0)  d
		.s FRowID=0
		.f  s FRowID=$o(^DHCEQFunds("0","CheckListType",FromID,FTDR,FRowID)) q:(FRowID="")||(Flag'=0)  d
		..q:$p($g(^DHCEQFunds(FRowID)),"^",10)="Y"
		..s FFee=+$p($g(^DHCEQFunds(FRowID)),"^",3)
		..d CheckType
	}
	i FromType=1 //设备
	{
		s FTDR=0
		f  s FTDR=$o(^DHCEQFunds("0","EquipType",FromID,FTDR)) q:FTDR=""  d
		.s FRowID=0
		.f  s FRowID=$o(^DHCEQFunds("0","EquipType",FromID,FTDR,FRowID)) q:FRowID=""  d
		..q:$p($g(^DHCEQFunds(FRowID)),"^",10)="Y"
		..s FFee=+$p($g(^DHCEQFunds(FRowID)),"^",3)
		..d CheckType
	}
	i FromType=2 //附件
	{
		//设备
	}
	i FromType=3 //入库明细
	{
#;		s tmpValue=$Piece($Get(^DHCEQInStockList(FromID)),"^",18)	;ISLSourceType
#;		i tmpValue=2
#;		{
#;			s tmpValue=$Piece($Get(^DHCEQInStockList(FromID)),"^",19)	;ISLSourceID
#;			s Flag=##Class(web.DHCEQCommon).FundsTypeIsIn(0,tmpValue,GroupID)
#;		}
		//add by csj 2020-02-11 标准版-安全组访问资金来源入库单资金来源过滤
		s FundsRowID=0
		f  s FundsRowID=$o(^DHCEQFunds("0","Source",FromType,FromID,FundsRowID))  q:((FundsRowID="")||(Flag'=0))  d
		.q:$p($g(^DHCEQFunds(FundsRowID)),"^",10)="Y"
		.s FTDR=$p($g(^DHCEQFunds(FundsRowID)),"^",2)
		.s FFee=+$p($g(^DHCEQFunds(FundsRowID)),"^",3)
		.d CheckType
	}
	i FromType=4 //转移明细
	{
		s tmpValue=$g(^DHCEQStoreMoveList(FromID,"EX","RowIDs"))
		s EQCount=$L(tmpValue,",")
		for j=1:1:EQCount
		{
			q:Flag'=0
			s EQID=$p(tmpValue,",",j)			
			s Flag=##Class(web.DHCEQCommon).FundsTypeIsIn(1,EQID,GroupID)
		}
	}
	i FromType=5 //退货明细
	{
	}
	i FromType=10 //配件入库
	{
		s FFee=+$p($g(^DHCEQAInStockList(FromID)),"^",10)
		s FTDR=$p($g(^DHCEQAInStockList(FromID)),"^",23)
		d CheckType
	}
	i FromType=11 //配件出库
	{
		s tmpValue=$p($g(^DHCEQAMoveStockList(FromID)),"^",14)	;DHC_EQAStockDetail
		s Flag=##Class(web.DHCEQCommon).FundsTypeIsIn(12,tmpValue,GroupID)
	}
	i FromType=12 //配件库存
	{
		s FFee=+$p($g(^DHCEQAStockDetail(FromID)),"^",8)
		s FTDR=$p($g(^DHCEQAStockDetail(FromID)),"^",30)	
		d CheckType
	}
	q Flag
CheckType
	i $d(^DHCEQCCode("DHCEQCGroupFundsType","0","Group",GroupID)) d
	.s Flag=1		;存在安全组设置则默认不能访问
	.q:FTDR=""
	.q:FFee=0
	.s tmpFTDR=0
	.f  s tmpFTDR=$o(^DHCEQCCode("DHCEQCGroupFundsType","0","Group",GroupID,tmpFTDR)) q:(tmpFTDR="")||(Flag=0)  d
	..i FTDR=tmpFTDR s Flag=0
	
	q
}

/// 描述：获取导出行数量
/// 创建：add by CZF0085 2020-03-05
/// 入参：node：导出临时global节点名称
/// 				合同明细:"ContractList",设备台账:"EquipList",转移明细:"StoreMoveStat"
/// 命令：w ##Class(web.DHCEQCommon).GetNum("ContractList",25772)
ClassMethod GetNum(node As %Library.String = "", job)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	q $o(^DHCEQTemp(node,User,job,""),-1)
}

/// 描述：获取导出行信息
/// 创建：add by CZF0085 2020-03-05
/// 入参：node：导出临时global节点名称
/// 				合同明细:"ContractList",设备台账:"EquipList",转移明细:"StoreMoveStat"
/// 命令：w ##Class(web.DHCEQCommon).GetList("ContractList",25772,1)
ClassMethod GetList(node As %Library.String = "", job, gnum, rows As %Library.String = "")
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s str=$g(^DHCEQTemp(node,User,job,gnum))
	if rows'=""
	{
		for i=1:1:rows-1
		{
			s str=str_$c(2)_^DHCEQTemp(node,User,job,gnum+i)
		}
	}
	q str
}

/// 描述：判断是当前登录安全组否有院区权限
/// 创建：add by QW20200507
/// 入参：HosptailID：院区ID
///       CurGroupID: 当前登录安全组ID
/// 返回值: 1:安全组有该院区权限 2:安全组没有改院区权限
/// 命令：w ##Class(web.DHCEQCommon).CheckHOSLimit(2,85)
ClassMethod CheckHOSLimit(HosptailID As %String = "", CurGroupID As %String = "")
{
	s ManyHosFlag=##class(web.DHCEQCommon).GetSysInfo("990051")
	i (ManyHosFlag=0)||(HosptailID="") q 1
	s Flag=1
	I (CurGroupID="")&($d(%session)'=0) Set CurGroupID=%session.Get("LOGON.GROUPID")
	s SessHosptailID=""
	I $d(%session)'=0 Set SessHosptailID=%session.Get("LOGON.HOSPID")
	s HosptailIDS=..GetHospIDSByGroup(CurGroupID)
	
	i (HosptailID'="")&&((HosptailIDS_"^"_SessHosptailID_"^")'[("^"_HosptailID_"^")) s Flag=0
	q Flag
}

/// 描述：判断是当前登录科室是否有访问权限 1:是,0:否
/// 创建：add by QW20200907 BUG:QW0078
/// 命令：w ##Class(web.DHCEQCommon).ISPreLoc(214,3)
/// Modified By QW20200922 BUG:QW0081 优化访问权限
ClassMethod ISPreLoc(LocDR As %String = "", CurLocDR As %String = "")
{
	i LocDR=CurLocDR 
	{
		q 1
	}else
	{
		q +##Class(web.DHCEQCTreeMap).IsChildPar(1, CurLocDR, LocDR)
		
	}
}

/*ClassMethod InsertOperateInfo(val As %Library.String = "")
{
	;Modified By QW20210913 BUG:  更改表 begin
	new User,RowID,OLSourceType,OLSourceID,times
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s OLSourceType=$Piece(val,"^",2)
	s OLSourceID=$Piece(val,"^",3)
	s times=##Class(web.DHCEQCommon).GetPrintNum(OLSourceType,OLSourceID)+1
	Set RowID=$Piece(val,"^",1)    				;OL_RowID
	Set PLIST(2) = 	OLSourceType				;OL_SourceType
 	Set PLIST(3) = 	OLSourceID					;OL_SourceID
 	Set PLIST(5) = times						;OL_Times
 	Set PLIST(6) = +$H							;OL_OperaDate
 	Set PLIST(7) = $P($H,",",2)					;OL_OperateTime
 	Set PLIST(8) = User							;OL_OperateUser
 	Set PLIST(9) = $Piece(val,"^",4)			;OL_Remark
 	&SQL(insert into sqluser.DHC_EQOperateLog values :PLIST())
 	;Modified By QW20210913 BUG:  更改表 end
	Quit SQLCODE
}*/

/*ClassMethod GetPrintNum(OLSourceType, OLSourceID)
{
	new TPrintNum
	s TPrintNum=0
	;Modified By QW20210913 BUG:  更改表 begin
	&SQL(SELECT OL_Times Into:TPrintNum from SQLUSER.DHC_EQOperateLog Where OL_SourceType=:OLSourceType and OL_SourceID=:OLSourceID)
	q TPrintNum
}*/
/// Add By QW20210422 bug:QW0100
/// 打印标记
/// d ##class(%ResultSet).RunQuery("web.DHCEQCommon","GetJudgeList")
Query GetJudgeList() As %Query(ROWSPEC = "Desc:%String:描述,Hidden:%String")
{
}

ClassMethod GetJudgeListExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Length=1
	f ID=0:1:Length d
	.;"0":"否","1":"是"
	.S TDesc=$CASE(ID,"0":"否","1":"是")
	.d OutputRowGetJudgeList
	
	Quit $$$OK
OutputRowGetJudgeList
	Set Data=$lb(TDesc,ID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetJudgeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetJudgeListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetJudgeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetJudgeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:czf
/// CreateDate:2021-04-28
/// Descrip:获取查询框
ClassMethod SearchBox(name, width) As %String
{
	w "<input id='"_name_"' href='#' class='textbox hisui-searchbox' style='width:"_width_"'>"
}

/// modified by ZY 20220927  修改global
/// Add By QW2021518 BUG:QW0111
/// w ##Class(web.DHCEQCommon).GetBussApproveFlow(31)
ClassMethod GetBussApproveFlow(Buss, Type As %String = "0")
{
	new (Buss,Type)
	i (Buss="") q ""
	Set ApproveType=##class(web.DHCEQMessages).GetApproveTypeByBussType(Buss)
	s rsult=""
	s ApproveSet=0
	f  s ApproveSet=$o(^DHCEQCCode("DHCEQCApproveSet",0,"ApproveType",ApproveType,ApproveSet))  q:(ApproveSet="")  d	
	.d GetApproveFlowInfo
	q rsult
GetApproveFlowInfo
	
		if (Type="1")
	{
		i $d(^DHCEQCCode("DHCEQCApproveFlow",0,"Action",ApproveSet))
		{
			;通过动作配置流获取审批流信息
			
			;设置步骤临时节点
			s job=$job
            k ^TempDHCEQ("GetBussApproveFlow",job)
			
			s ActionID=""
			f  s ActionID=$o(^DHCEQCCode("DHCEQCAction",0,"SourceType",ApproveType,ActionID)) q:ActionID=""  d
			.q:$p($g(^DHCEQCCode("DHCEQCAction",ActionID)),"^",5)'="N"
			.i $p($g(^DHCEQCCode("DHCEQCAction",ActionID)),"^",3)="" d
            ..s ^TempDHCEQ("GetBussApproveFlow",job,ActionID)=ActionID
            .e  d
            ..s ^TempDHCEQ("GetBussApproveFlow",job,$p($g(^DHCEQCCode("DHCEQCAction",ActionID)),"^",3))=ActionID
             
            s Step=""
            f  s Step=$o(^TempDHCEQ("GetBussApproveFlow",job,Step)) q:Step=""  d
            .s ActionID=$g(^TempDHCEQ("GetBussApproveFlow",job,Step))
            .s rowid=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"Action",ApproveSet,ActionID,""))
            .q:rowid=""
            .d SetApproveFlowInfo
            k ^TempDHCEQ("GetBussApproveFlow",job)
		}
	}
	else
	{
		s Step=""
		f  s Step=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,Step)) quit:Step=""  d
		.s rowid=0
		.f  s rowid=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",ApproveSet,Step,rowid)) quit:rowid=""  d
		..d SetApproveFlowInfo
	}
	
	q
	
SetApproveFlowInfo
	s (id,code,text)=""

	s TApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",rowid)),"^",2)
	s THold3=+$p($g(^DHCEQCCode("DHCEQCApproveFlow",rowid)),"^",9)
	if ((Type="1")&&(THold3>0)) d
	.s id=THold3
	.s code=$p($g(^DHCEQCCode("DHCEQCAction",THold3)),"^",1)
	.s text=$p($g(^DHCEQCCode("DHCEQCAction",THold3)),"^",2)
	e  i ((Type="0")&&(TApproveRoleDR'="")) d
	.s text=$p($g(^DHCEQCCode("DHCEQCApproveRole",TApproveRoleDR)),"^",2)
	.s code=$p($g(^DHCEQCCode("DHCEQCApproveRole",TApproveRoleDR)),"^",1)
	.s id=TApproveRoleDR
	s resultlist=id_","_code_","_text
	q:(rsult'="")&&(("&"_rsult_"&")[("&"_resultlist_"&")) 
	i rsult'="" s rsult=rsult_"&"
	s rsult=rsult_resultlist


	q
}

/// Add By QW2021518 BUG:QW0111
/// w ##Class(web.DHCEQCommon).ActionFilter(46,"31","1")
ClassMethod ActionFilter(rowid, Buss, Type As %String = "0")
{
	new (rowid,Type,Buss)
	s (Result,date,ApproveType)=""
	i (Buss="") q ""
	Set ApproveType=##class(web.DHCEQMessages).GetApproveTypeByBussType(Buss)
	Set id=$Order(^DHCEQApproveList(0,"Source",ApproveType,rowid,""),-1)
	i id="" q ""
	if (Type="1")
	{
		s Result=$p($g(^DHCEQApproveList(id)),"^",11)
	}else{
		Set Result=$Piece($Get(^DHCEQApproveList(id)),"^",5)
	}
	Set date=$Piece($Get(^DHCEQApproveList(id)),"^",7)
    ///modified by ZY 2738278 20220817
    Set time=$Piece($Get(^DHCEQApproveList(id)),"^",8)
    q Result_","_date_","_time
}

/// add by czf 1880419 2021-07-08
/// 根据科室ID串获取科室名称
/// w ##class(web.DHCEQCommon).GetLocDescByIDs("1,2,3")
ClassMethod GetLocDescByIDs(LocIDs)
{
	n (LocIDs,i,LocStr,LocDesc)
	s LocStr=""
	f i=1:1:$l(LocIDs,",") d
	.q:$p(LocIDs,",",i)=""
	.s LocDesc=##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(LocIDs,",",i))
	.i LocStr'="" s LocStr=LocStr_","
	.s LocStr=LocStr_LocDesc
	q LocStr
}

/// czf 2021-09-08
/// 根据公司名称获取公司ID
/// Input:Name:公司名称 FirmType:2:供应商 3:生产厂商 4:服务商
/// Output:公司ID^对照表ID
/// w ##Class(web.DHCEQCommon).GetVendorIDByName("康乐保",3)
ClassMethod GetVendorIDByName(Name As %String = "", FirmType As %String = "")
{
	n (Name,FirmType,VRowid,FCRowid,FindID,FindFCID)
	i Name="" q ""
	i FirmType="" s FirmType=2
	s FindID=""
	s FindFCID=""
	
	s VRowid=""
	f  s VRowid=$o(^DHCEQCCode("DHCEQCVendor",VRowid)) q:(VRowid="")||(FindFCID'="")  d
	.q:$p($g(^DHCEQCCode("DHCEQCVendor",VRowid)),"^",19)="Y"
	.s TName=$p($g(^DHCEQCCode("DHCEQCVendor",VRowid)),"^",2)
	.q:TName'=Name
	.s FindID=VRowid
	.s FCRowid=""
	.f  s FCRowid=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmType",FirmType,VRowid,FCRowid)) q:(FCRowid="")||(FindFCID'="")  d
	..q:$p($g(^DHCEQCCode("DHCEQCFirmContrast",FCRowid)),"^",3)="Y"
	..s FindFCID=FCRowid
	
	q FindID_"^"_FindFCID
}

/// 根据月份取第一天
/// 入参：YYYY-MM
/// add by ZY0279 20210907
/// w ##Class(web.DHCEQCommon).MonthFirstDate()
ClassMethod MonthFirstDate(value As %String = "")
{
	i value'=""
	{
		s value=$ZDH(value_"-01",3)
	}
	else
	{
		s value=0
	}
	q value
}

/// 根据月份取第一天
/// 入参：YYYY-MM
/// add by ZY0279 20210907
/// w ##Class(web.DHCEQCommon).MonthLastDate()
ClassMethod MonthLastDate(value As %String = "")
{
	new (value)
	i value=""
	{
		s value=+$H
	}
	else
	{
		s Year=$p(value,"-",1)
		s Month=+$p(value,"-",2)+1
		i Month>12
		{
			s Year=Year+1
			s Month=1
		}
		s value=$ZDH(Year_"-"_Month_"-01",3)-1
	}
	q value
}

/// Creator:czf
/// CreateDate:2021-04-28
/// Description:根据业务单号获取资产信息
/// Input:SourceType:21:入库 22:转移 23:退货	SourceID:业务ID  MainFlag:是否主单	
/// 	  DataType:"EquipNo","EquipName","LeavefactoryNo"
/// OutPut:根据DataType输出对应数据
/// w ##class(web.DHCEQCommon).GetEquipNos(22,13,"Y","EquipNo")
ClassMethod GetEquipNos(SourceType As %Library.String, SourceID As %Library.String, MainFlag As %String = "", DataType As %String = "EquipNo") As %Status
{
	n (SourceType,SourceID,MainFlag,DataType)
	i (SourceType="")||(SourceID="") q ""
	s EquipNos=""
	s EquipNames=""
	s LeavefactoryNos=""
	s SortNo=0
	if SourceType="21"
	{
		i MainFlag="Y"
		{
			s ISLListID=0
			f  s ISLListID=$o(^DHCEQInStockList(0,"InStock",SourceID,ISLListID)) q:ISLListID=""  d
			.d GetInStockListEquipInfo
		}
		else
		{
			s ISLListID=SourceID
			d GetInStockListEquipInfo
		}
	}
	elseif SourceType="22"
	{
		i MainFlag="Y"
		{
			s SMLListID=0
			f  s SMLListID=$o(^DHCEQStoreMoveList(0,"StoreMove",SourceID,SMLListID)) q:SMLListID=""  d
			.d GetStoreMoveListEquipInfo
		}
		else
		{
			s SMLListID=SourceID
			d GetStoreMoveListEquipInfo
		}
	}
	elseif SourceType="23"
	{
		i MainFlag="Y"
		{
			s RLListID=0
			f  s RLListID=$o(^DHCEQReturnList(0,"Return",SourceID,RLListID)) q:RLListID=""  d
			.d GetReturnListEquipInfo
		}
		else
		{
			s RLListID=SourceID
			d GetReturnListEquipInfo
		}
	}
	i DataType="EquipName" q EquipNames
	e  i DataType="LeavefactoryNo" q LeavefactoryNos
	q ##Class(web.DHCEQCommon).NoToGroupNo(EquipNos,",")
	 
GetStoreMoveListEquipInfo
	s EQIDs=$g(^DHCEQStoreMoveList(SMLListID,"EX","RowIDs"))		//czf 2022-04-24 begin
	q:EQIDs=""
	s Len=$l(EQIDs,",")
	f i=1:1:Len d
	.s EquipDR=$p(EQIDs,",",i)
	.q:EquipDR=""
	.s EquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
 	.s EquipName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
 	.s LeavefactoryNo=$p($g(^DHCEQEquip(EquipDR)),"^",10)
 	.s SortNo=SortNo+1
 	.i EquipNos'="" s EquipNos=EquipNos_","
 	.s EquipNos=EquipNos_EquipNo
 	.i EquipNames="" s EquipNames=EquipName
 	.e  i ((";"_EquipNames_";")'[(";"_EquipName_";")) s EquipNames=EquipNames_";"_EquipName
 	.i LeavefactoryNos'="" s LeavefactoryNos=LeavefactoryNos_","
 	.s LeavefactoryNos=LeavefactoryNos_LeavefactoryNo				//czf 2022-04-24 end

 	quit
 	
GetInStockListEquipInfo
	i $d(^DHCEQEquip(0,"InStockList",ISLListID))
	{
		s EQStoreLocDR=0
		f  s EQStoreLocDR=$o(^DHCEQEquip(0,"InStockList",ISLListID,EQStoreLocDR)) q:EQStoreLocDR=""  d
		.s EquipDR=0
		.f  s EquipDR=$o(^DHCEQEquip(0,"InStockList",ISLListID,EQStoreLocDR,EquipDR)) q:EquipDR=""  d
		..s EquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
		..s EquipName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
		..s LeavefactoryNo=$p($g(^DHCEQEquip(EquipDR)),"^",10)
	 	..s SortNo=SortNo+1
	 	..i EquipNos'="" s EquipNos=EquipNos_","
	 	..s EquipNos=EquipNos_EquipNo
	 	..i EquipNames="" s EquipNames=EquipName
	 	..e  i ((";"_EquipNames_";")'[(";"_EquipName_";")) s EquipNames=EquipNames_";"_EquipName
	 	..i LeavefactoryNos'="" s LeavefactoryNos=LeavefactoryNos_","
	 	..s LeavefactoryNos=LeavefactoryNos_LeavefactoryNo
	}
	else
	{
		s OCLSourceType=$p($g(^DHCEQInStockList(ISLListID)),"^",18)
		s OCLSourceID=$p($g(^DHCEQInStockList(ISLListID)),"^",19)
		if (OCLSourceType="2")&&(OCLSourceID'="")
		{
			s EquipDR=0
			f  s EquipDR=$o(^DHCEQEquip(0,"OpenCheckList",OCLSourceID,EquipDR)) q:EquipDR=""  d
			.s EquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
			.s EquipName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
			.s LeavefactoryNo=$p($g(^DHCEQEquip(EquipDR)),"^",10)
		 	.s SortNo=SortNo+1
		 	.i EquipNos'="" s EquipNos=EquipNos_","
		 	.s EquipNos=EquipNos_EquipNo
		 	.i EquipNames="" s EquipNames=EquipName
		 	.e  i ((";"_EquipNames_";")'[(";"_EquipName_";")) s EquipNames=EquipNames_";"_EquipName
		 	.i LeavefactoryNos'="" s LeavefactoryNos=LeavefactoryNos_","
		 	.s LeavefactoryNos=LeavefactoryNos_LeavefactoryNo
		}
	}
 	 	
 	quit
 	
GetReturnListEquipInfo
	s EQIDs=$g(^DHCEQReturnList(RLListID,"EX","RowIDs"))		//czf 2022-07-05 begin
	q:EQIDs=""
	s Len=$l(EQIDs,",")
	f i=1:1:Len d
	.s EquipDR=$p(EQIDs,",",i)
	.q:EquipDR=""
	.s EquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
 	.s EquipName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
 	.s LeavefactoryNo=$p($g(^DHCEQEquip(EquipDR)),"^",10)
 	.s SortNo=SortNo+1
 	.i EquipNos'="" s EquipNos=EquipNos_","
 	.s EquipNos=EquipNos_EquipNo
 	.i EquipNames="" s EquipNames=EquipName
 	.e  i ((";"_EquipNames_";")'[(";"_EquipName_";")) s EquipNames=EquipNames_";"_EquipName
 	.i LeavefactoryNos'="" s LeavefactoryNos=LeavefactoryNos_","
 	.s LeavefactoryNos=LeavefactoryNos_LeavefactoryNo				//czf 2022-07-05 end

 	quit
}

/// czf 2021-11-29
/// 描述:取得一段区间内实际天数
/// vStartMonth:开始月份，vEndMonth：结束月份，格式:yyyy-mm
/// type:1为实际天数之和 0为月份天数之和
/// w ##Class(web.DHCEQCommon).GetMonthDateNum("2021-01","2021-12")
ClassMethod GetMonthDateNum(vStartMonth As %String = "", vEndMonth As %String = "", type As %String = "")
{
	n (vStartMonth,vEndMonth,type)
	i vStartMonth="" q 0
	i (vEndMonth'="")&&(vStartMonth>vEndMonth) q 0
	i vEndMonth="" s vEndMonth=vStartMonth
	s DaysCount=0
	s CurMonth=$p($zd(+$h,3),"-",1,2)
	f ID=$ZDH(vStartMonth_"-01",3):1:$ZDH(vEndMonth_"-01",3)  d
	.s Month=$p($ZD(ID,3),"-",1,2)
	.s MonthDays=..GetMonthEndDate(Month,type)
	.s DaysCount=DaysCount+MonthDays
	.s vYear=$E($ZD(ID,3),1,4)
	.s vMonth=$E($ZD(ID,3),6,7)
	.i vMonth=12  d
	..s vYear=vYear+1
	..s vMonth=1
	.e  d
	..s vMonth=vMonth+1
	.s ID=$ZDH(vYear_"-"_vMonth_"-01",3) - 1
	q DaysCount
}

/// czf 2022-01-22
/// 加载Lodop打印插件及js
/// 入参：NeedCLodop（1：使用CLodop打印，可有效解决打印img导致iMedical超时问题）
/// d ##class(web.DHCEQCommon).InitLodopPrint()
ClassMethod InitLodopPrint(NeedCLodop As %String = "0")
{
	;获取XML模板
	i ##class(websys.Conversions).IsValidClassName("websys.Page") d
	.w "<input id='InvPrintEncrypt' name='InvPrintEncrypt' type='hidden' value='"_##Class(websys.Page).Encrypt($lb("web.DHCXMLIO.ReadXML"))_"'>",$C(13,10)
	e  d
	.w "<input id='InvPrintEncrypt' name='InvPrintEncrypt' type='hidden' value='"_##Class(%CSP.Page).Encrypt($lb("web.DHCXMLIO.ReadXML"))_"'>",$C(13,10)
	
	;加载Lodop插件
	i ##class(websys.Conversions).IsValidClassName("web.DHCXMLPConfig") d
	.d ##class(web.DHCXMLPConfig).LODOPInit()
	
	w "<script type='text/javascript' src='../scripts/DHCPrtComm.js'></script>"
	q ""
}

/// add by zc0112 2022-01-06
/// 根据条件将消息通过平台消息发送给对应人员
/// 如果成功返回值:0
/// w ##class(web.DHCEQCommon).MessageSend(31,36,1,"WX2022030005")
ClassMethod MessageSend(BussType, FromUserDR, ToUserDR, BussNo)
{
	n (BussType,FromUserDR,ToUserDR,BussNo)
	s vFlag=0
	s vBussInfo=""
	s MSActionCode=$case(BussType,11:"1021",22:"1023",31:"1020",94:"1022",:"")	// MZY0126	2647787		2022-06-13	增加设备保修
	i MSActionCode="" q vFlag
	i BussType=11 d
	.s vBussInfo="您好!在HIS系统中,您有一张需要处理的验收单,单号为"_BussNo_",请注意查阅."
	e  i BussType=22 d
	.s vBussInfo="您好!在HIS系统中,您有一张需要处理的转移申请单,单号为"_BussNo_",请注意查阅."
	e  i BussType=31 d
	.s vBussInfo="您好!在HIS系统中,您有一张需要处理的维修申请单,单号为"_BussNo_",请注意查阅."
	e  i BussType=94 d	// MZY0126	2647787		2022-06-13	增加设备保修
	.s vBussInfo="您好!在HIS系统中,您有一张需要处理的保修合同,单号为"_BussNo_",请注意查阅."
	s vFlag=$p(##Class(websys.DHCMessageInterface).Send(vBussInfo,MSActionCode,$p($g(^DHCEQCCode("DHCEQCUser",FromUserDR)),"^",19),"","",$p($g(^DHCEQCCode("DHCEQCUser",ToUserDR)),"^",19),"","","",""),"^",1)
	q:vFlag>0 0		;;; MZY0117	2528139		2022-03-21	修正返回值
	q vFlag
}

/// czf 2022-04-20
/// 比较字符串大小
/// 返回值：0相等，1是大于，-1小于
/// w ##class(web.DHCEQCommon).CompareStr("B00001","B00003")
ClassMethod CompareStr(Param1, Param2)
{
	n len,Str,Sign
	k Compare
	i Param1=""
	{
		i Param2="" q 0
		e  q -1
	}
	else
	{
		i Param2="" q 1
	}
	s Compare(Param1)=1
	s Compare(Param2)=1
	
	s Str="", len=0,Sign="1"
	for {
		s Str=$o(Compare(Str))
		Q:Str=""
		i (len=0)&&(Str=Param1) s Sign="-1"
		s len=len+1
	}
	s:len=1 Sign="0"
	q Sign
}

/// 获取发票号
/// IMType:1：入库明细
/// pSourceID:入库明细ID
/// MainFlag:是否主单
/// w ##class(web.DHCEQCommon).GetInvoiceNo(1,11)
ClassMethod GetInvoiceNo(IMType, pSourceID, MainFlag As %String = "")
{
	n (IMType,pSourceID,MainFlag)
	s InvoiceNos=""
	
	i IMType=1
	{
		i MainFlag'="Y"
		{
			s SourceID=pSourceID
			d GetInvoiceNos
			
		}
		else
		{
			s SourceID=0
			f  s SourceID=$o(^DHCEQInStockList(0,"InStock",pSourceID,SourceID)) q:SourceID=""  d
			.d GetInvoiceNos
		}
	}
	
	q InvoiceNos
	
GetInvoiceNos
	s InvoiceInfo=##Class(web.DHCEQInvoice).GetInvoiceInfos(IMType,SourceID)
	s InvoiceLen=$l(InvoiceInfo,"&")
	for i=1:1:InvoiceLen d
	.s Invoice=$p(InvoiceInfo,"&",i)
	.s PerInvoiceNo=$p(Invoice,"^",1)
	.s PerInvoiceNo=##class(web.DHCEQCommon).Replace(PerInvoiceNo," ","")
	.q:PerInvoiceNo=""
	.i (InvoiceNos'="")&&((","_InvoiceNos_",")'[(","_PerInvoiceNo_",")) s InvoiceNos=InvoiceNos_","_PerInvoiceNo
	.i InvoiceNos="" s InvoiceNos=PerInvoiceNo
}

/// czf 2022-07-05
/// 明细查询界面合计行
/// w ##class(web.DHCEQCommon).sumTotal("sumTotal","")
ClassMethod sumTotal(name As %String, Desc As %String = "")
{
	i Desc=""
	{
	//w "<span id='"_name_"' class='eq-total-sum' style='position:relative;right:10px;top:5px;padding-bottom:10px;'></span>"
		w "<div class='messager-popover info' style='position:relative;right:0px;float:right;font-weight:normal;margin:2px 5px 0px 0;padding:5px 10px;'><span id='sumTotalicon' class='messager-popover-icon info'></span><span id='"_name_"'>合计&nbsp;&nbsp;&nbsp;总数量:0&nbsp;&nbsp;&nbsp;总金额:0元</span></div>"
	}
	
	else
	{
		w "<div class='messager-popover info' style='position:relative;right:0px;float:right;font-weight:normal;margin:2px 5px 0px 0;padding:5px 10px;'><span  class='messager-popover-icon info'></span><span>"_Desc_"</span></div>"
	}
}

/// w ##class(web.DHCEQCommon).GetManageCatByID("")
ClassMethod GetManageCatByID(ID As %String = "")
{
	q $CASE(ID,"1":"类别1","2":"类别2","3":"类别3","0":"其他","":"")
}

}
