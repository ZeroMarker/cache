Import sqluser

/// Descript:	字典公共类
/// Creater:	徐超
/// CreateDate:	2018-04-13
Class web.DHCSTMHUI.Common.Dicts Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	单位
/// Creater:	徐超
/// CreateDate:	2018-04-13
Query GetCTUom() As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetCTUomExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	 
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "select CTUOM_RowID AS RowId, CTUOM_DESC AS Description from CT_UOM order by CTUOM_RowID"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Description = Result.Data("Description")
		d OutPutUomRow
	}
	d Result.Close()
	Quit $$$OK
OutPutUomRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	供应商
/// Creater:	徐超
/// CreateDate:	2018-04-13
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetVendor",^templxt("Vendor"),"")
Query GetVendor(Params As %String, ScgId As %String = "") As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetVendorExecute(ByRef qHandle As %Binary, Params As %String, ScgId As %String = "") As %Status
{
	n (qHandle,Params,ScgId,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s APCType=PJObj.%Get("APCType")
	s:APCType="" APCType=..sssCode()
	s UserId=PJObj.%Get("gUserId")
	s LocId=PJObj.%Get("gLocId")
	s GroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s PLocId=PJObj.%Get("LocId")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s Param=GroupId_"^"_LocId_"^"_UserId_"^"_pHospId
	s Filter=""
	s Result = ##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s AppName="DHCSTCOMMONM"
	;是否根据供应商类组授权进行取值
	s VendorByHosp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"VendorByHosp",Param)
	s ApcScg=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"ApcScg",Param)
	i ApcScg="S" d
	.i ScgId="" d
	..s ScgId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(UserId,APCType,LocId,ScgId,pHospId)
	..s ScgId=$tr(ScgId,"^",",")
	.s sqlStr = "SELECT distinct(a.ACG_APCVM_Dr) RowId,a.ACG_APCVM_Dr->APCVM_NAME Description FROM DHC_ApcCatGroup as a left join DHC_STVendor as b  on a.ACG_APCVM_Dr=b.STV_Vendor_DR  where a.ACG_SCG_Dr in ("_ScgId_") and a.ACG_UseFlag='Y' and (%ALPHAUP(a.ACG_APCVM_Dr->APCVM_NAME) LIKE '%"_Filter_"%' or %ALPHAUP(b.STV_Alias) LIKE '%"_Filter_"%')"
	else  if (ApcScg="L")&&(PLocId'="") d
	.s count=0
	.&sql(SELECT count(1) into :count FROM DHC_ApcCatGroup WHERE ACG_Loc_DR=:PLocId)
	.i count>0 d
	..s sqlStr = "SELECT distinct(a.ACG_APCVM_Dr) RowId,a.ACG_APCVM_Dr->APCVM_NAME Description FROM DHC_ApcCatGroup as a left join DHC_STVendor as b  on a.ACG_APCVM_Dr=b.STV_Vendor_DR  where a.ACG_Loc_DR="_PLocId_" and a.ACG_UseFlag='Y' and (%ALPHAUP(a.ACG_APCVM_Dr->APCVM_NAME) LIKE '%"_Filter_"%' or %ALPHAUP(b.STV_Alias) LIKE '%"_Filter_"%')"
	.e  d
	..s sqlStr = "SELECT a.APCVM_ROWID AS RowId, a.APCVM_NAME AS Description FROM APC_Vendor as a left join DHC_STVendor as b on a.APCVM_ROWID=b.STV_Vendor_DR WHERE %ALPHAUP(APCVM_NAME) LIKE '%"_Filter_"%' or %ALPHAUP(b.STV_Alias) LIKE '%"_Filter_"%'"
	e  d
	.s sqlStr = "SELECT a.APCVM_ROWID AS RowId, a.APCVM_NAME AS Description FROM APC_Vendor as a left join DHC_STVendor as b on a.APCVM_ROWID=b.STV_Vendor_DR WHERE %ALPHAUP(APCVM_NAME) LIKE '%"_Filter_"%' or %ALPHAUP(b.STV_Alias) LIKE '%"_Filter_"%'"
	s sqlStr=sqlStr_" order by Description"
	d Result.Prepare(sqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("APC_Vendor",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		;sql中含有distinct时,sql结果中desc是大写的,所以这里根据global取值
		s Description=$p(^APC("APCVM",RowId),"^",3)
		s APCStkType=$p(^APC("APCVM",RowId),"^",9)
		continue:APCStkType'=APCType
		s APCStatus=$p(^APC("APCVM",RowId),"^",18)
		continue:APCStatus'="A"
		d OutPutVendorRow
	}
	d Result.Close()
	Quit $$$OK
OutPutVendorRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:配送商
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetDealer","")
Query GetDealer(Params As %String) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetDealerExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,ScgId,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s PHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(PHospId,gHospId)
	
	s Result = ##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s sqlStr="SELECT DL_RowId as RowId, DL_Name FROM DHC_Dealer"
	d Result.Prepare(sqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_Dealer",RowId,gHospId)
		continue:ShowDataFlag'="Y"
		s Description=$lg(^User.DHCDealerD(RowId),4)
		s Status=$lg(^User.DHCDealerD(RowId),32)
		continue:Status'="A"
		d OutPutDealerRow
	}
	d Result.Close()
	Quit $$$OK
OutPutDealerRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:XuChao
/// Date:2018-4-18
/// Description: 库存分类
/// Input:  StkGrpId
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetStkCat",31,^litmp("GetStkCat"))
Query GetStkCat(StkGrpId As %String, Params = "") As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetStkCatExecute(ByRef qHandle As %Binary, StkGrpId As %String, Params = "") As %Status
{
	n (qHandle,StkGrpId,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:StkGrpId="" $$$OK
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s User=PJobj.%Get("gUserId")
	s LocId=PJobj.%Get("gLocId")
	s gHospId=PJobj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJobj.%Get("BDPHospital") ;选择的医院ID
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s ScgStr=""
	s ssStkgrptype=..sssCode()
	i Params="" d
	.s ScgStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).ChildScgStr(StkGrpId,pHospId)
	e  d
	.s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(User,ssStkgrptype,LocId,StkGrpId,pHospId)
	.s ScgStr=$tr(ScgStr,"^",",")
	q:ScgStr="" $$$OK
	f i=1:1:$l(ScgStr,",") d
	.s StkGrpId=$p(ScgStr,",",i)
	.s Chl=0
	.f  s Chl=$o(^DHCSCG(StkGrpId,"RE",Chl)) q:Chl=""  d
	..s StkCatId=$p(^DHCSCG(StkGrpId,"RE",Chl),"^",1)
	..q:'$d(^INC("SC",StkCatId))
	..s StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
	..d OutPutCatRow
	Quit $$$OK
OutPutCatRow
	s Data=$lb(StkCatId,StkCatDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	医院
/// Creater:	tsr
/// CreateDate:	2018-04-20
Query GetHosp() As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetHospExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "select HOSP_RowId as RowId, HOSP_Desc as Description ,HOSP_DateTo , HOSP_DateFrom from CT_Hospital"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Description = Result.Data("Description")
		s dateFrom = Result.Data("HOSP_DateFrom")
		s dateTo = Result.Data("HOSP_DateTo")
		s date =+$h
		continue:(dateFrom'="")&&(date<dateFrom)
		continue:(dateTo'="")&&(date>dateTo)
		d OutPutHospRow
	}
	d Result.Close()
	Quit $$$OK
OutPutHospRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	科室
/// Creater:	徐超
/// CreateDate:	2018-04-13
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetCTLoc","{""Type"":""Trans"",""LocId"":""163"",""TransLocType"":""T"",""Element"":""InitFrLoc"",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""MENUID"":""57776""}","")
Query GetCTLoc(Params As %String, q As %String = "") As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description,Contact") [ SqlProc ]
{
}

ClassMethod GetCTLocExecute(ByRef qHandle As %Binary, Params As %String, q As %String = "") As %Status
{
	n (qHandle,Params,q,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gUserId=PJObj.%Get("gUserId")
	s gGroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJObj.%Get("BDPHospital") ;选择的医院ID
	s StrParam=gGroupId_"^"_gLocId_"^"_gUserId
	s pShowAllHospFlag=##class(web.DHCSTMHUI.Common.AppCommon).GetCommPropValue("ShowAllHospFlag",StrParam)
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s pType=PJObj.%Get("Type")
	s pDesc=PJObj.%Get("Desc")
	s pLocId=PJObj.%Get("LocId")
	s LoginLocType=PJObj.%Get("LoginLocType")	;LoginLocType=2取当前登录人、安全组有登录权限的科室,否则取安全组库存授权科室
	s TransLocType=PJObj.%Get("TransLocType")
	s MENUID=PJObj.%Get("MENUID")
	s Element=PJObj.%Get("Element")
	s:TransLocType="" TransLocType="T"
	s MenuType=##class(web.DHCSTMHUI.LocControl).GetMenuLimit(gGroupId,MENUID,Element)
	s:MenuType'="" pType=MenuType
	s:pType="" pType="All"
	s pDesc=$$ALPHAUP^SSUTIL4(pDesc)
	s Date=+$h
	s Sort="Description"
	;s Sort="RowId"
	s Order="ASC"
	i Order="DESC" s Order=-1  //倒序
	e  d  s Order=1
	s pid=..NewPid()
	k ^TempCTLOC(pid)
	s gLocDesc=$p(^CTLOC(gLocId),"^",2)
	
	i pType="Login" d
	.i Sort="RowId" d
	..s ^TempCTLOC(pid,gLocId,gLocId)=gLocId_"^"_gLocDesc
	.e  d
	..s ^TempCTLOC(pid,gLocDesc,gLocId)=gLocId_"^"_gLocDesc
	.i LoginLocType=2 d
	..&sql(declare LoginDeptCursor cursor for
		select OTHLL_CTLOC_DR RowId,OTHLL_CTLOC_DR->CTLoc_Desc Description from SS_UserOtherLogonLoc 
		where OTHLL_ParRef=:gUserId and OTHLL_UserGroup_DR=:gGroupId
		and OTHLL_StartDate IS NOT NULL and OTHLL_StartDate<=+$H
		and (OTHLL_EndDate IS NULL OR OTHLL_EndDate >+$H)
		union 
		select SSUSR_DefaultDept_DR RowId,SSUSR_DefaultDept_DR->CTLoc_Desc Description from SS_User
		where SSUSR_RowId=:gUserId and SSUSR_Group=:gGroupId)
	..&sql(open LoginDeptCursor)
	..f  &sql(fetch LoginDeptCursor into :RowId,:Description) q:SQLCODE  d 
	...i Sort="RowId" d
	....s ^TempCTLOC(pid,RowId,RowId)=RowId_"^"_Description
	...e  d
	....s ^TempCTLOC(pid,Description,RowId)=RowId_"^"_Description
	..&sql(close LoginDeptCursor)
	.e  d
	..&sql(declare LoginLocCursor cursor for
		select st_ctloc_dr RowId,st_ctloc_dr->ctloc_desc Description,ST_Childsub Childsub from ss_groupstocklocations
		where st_parref=:gGroupId and st_ctloc_dr<>:gLocId order by :Sort ASC)
	..&sql(open LoginLocCursor)
	..f  &sql(fetch LoginLocCursor into :RowId,:Description,:Childsub) q:SQLCODE  d 
	...s StActiveFlag=$p(^SSU("SSGRP",gGroupId,"ST",Childsub),"^",2)
	...q:(RowId'=gLocId)&&(StActiveFlag="N")	;增加库存授权激活状态过滤
	...i Sort="RowId" d
	....s ^TempCTLOC(pid,RowId,RowId)=RowId_"^"_Description
	...e  d
	....s ^TempCTLOC(pid,Description,RowId)=RowId_"^"_Description
	..&sql(close LoginLocCursor)
	e  i pType="LinkLoc" d
	.i Sort="RowId" d
	..s ^TempCTLOC(pid,gLocId,gLocId)=gLocId_"^"_gLocDesc
	.e  d
	..s ^TempCTLOC(pid,gLocDesc,gLocId)=gLocId_"^"_gLocDesc
	.&sql(declare LinkLocCursor cursor for
		select link_ctloc_dr RowId,link_ctloc_dr->ctloc_Desc Description from CT_LocLinkLocation
		where link_parref=:gLocId and link_ctloc_dr<>:gLocId order by :Sort ASC)
	.&sql(open LinkLocCursor)
	.f  &sql(fetch LinkLocCursor into :RowId,:Description) q:SQLCODE  d
	..i Sort="RowId" d
	...s ^TempCTLOC(pid,RowId,RowId)=RowId_"^"_Description
	..e  d
	...s ^TempCTLOC(pid,Description,RowId)=RowId_"^"_Description
	.&sql(close LinkLocCursor)
	e  i pType="Trans" d
	.q:pLocId=""
	.
	.&sql(declare TransLocCursor cursor for
		select STLOC_FrLoc_DR RowId,STLOC_FrLoc_DR->CTLOC_DESC Description from DHC_StockTransferLocConf
		where (STLOC_CtLoc_DR=:pLocId or STLOC_Group_DR=:gGroupId) and STLOC_Type=:TransLocType)
	.&sql(open TransLocCursor)
	.f  &sql(fetch TransLocCursor into :RowId,:Description) q:SQLCODE  d
	..i Sort="RowId" d
	...s ^TempCTLOC(pid,RowId,RowId)=RowId_"^"_Description
	..e  d
	...s ^TempCTLOC(pid,Description,RowId)=RowId_"^"_Description
	.&sql(close TransLocCursor)
	.q:$d(^TempCTLOC(pid))
	.q:TransLocType="T"		;T类型(接收科室),不按库存类型取值
	.
	.//供给科室未配置按库房类别取值
	.&sql(declare DHCLocTypeCursor cursor for 
		SELECT DHCLoc_Ctloc_dr RowId,DHCLoc_Ctloc_dr->CTLOC_Desc Description FROM DHCST_CtLoc WHERE DHCLoc_Type='A')
	.&sql(open DHCLocTypeCursor)
	.f  &sql(fetch DHCLocTypeCursor into :RowId,:Description) q:SQLCODE  d
	..i Sort="RowId" d
	...s ^TempCTLOC(pid,RowId,RowId)=RowId_"^"_Description
	..e  d
	...s ^TempCTLOC(pid,Description,RowId)=RowId_"^"_Description
	.&sql(close DHCLocTypeCursor)
	e  i pType="LeadLoc" d
	.i Sort="RowId" d
	..s ^TempCTLOC(pid,gLocId,gLocId)=gLocId_"^"_gLocDesc
	.e  d
	..s ^TempCTLOC(pid,gLocDesc,gLocId)=gLocId_"^"_gLocDesc
	.q:pLocId=""
	.&sql(declare LeadLocCursor cursor for
		select OTHLL_CTLOC_DR RowId,OTHLL_CTLOC_DR->CTLoc_Desc Description from SS_UserOtherLogonLoc 
		where OTHLL_ParRef=:gUserId and OTHLL_UserGroup_DR=:gGroupId 
		union
		select DLOC_Sub_DR RowId,DLOC_Sub_DR->CTLoc_Desc Description from DHC_DefLoc
		where DLOC_Lead_DR=:pLocId)
	.&sql(open LeadLocCursor)
	.f  &sql(fetch LeadLocCursor into :RowId,:Description) q:SQLCODE  d
	..i Sort="RowId" d
	...s ^TempCTLOC(pid,RowId,RowId)=RowId_"^"_Description
	..e  d
	...s ^TempCTLOC(pid,Description,RowId)=RowId_"^"_Description
	.&sql(close LinkLocCursor)
	;供应科室(Trans-F类型),如无配置,不取所有
	i '$d(^TempCTLOC(pid))&&'((pType="Trans")&&(TransLocType="F")) d
	.s pType="All"
	
	i pType="All" d
	.&sql(declare AllLocCursor cursor for
		select CTLOC_ROWID RowId,CTLOC_DESC Description FROM CT_Loc
		order by :Sort ASC)
	.&sql(open AllLocCursor)
	.f  &sql(fetch AllLocCursor into :RowId,:Description) q:SQLCODE  d
	..i Sort="RowId" d
	...s ^TempCTLOC(pid,RowId,RowId)=RowId_"^"_Description
	..e  d
	...s ^TempCTLOC(pid,Description,RowId)=RowId_"^"_Description
	.&sql(close AllLocCursor)

	s temp=""
	f  s temp=$o(^TempCTLOC(pid,temp),Order)  q:(temp="")  d
	.s tmprowid="" 
	.f  s tmprowid=$o(^TempCTLOC(pid,temp,tmprowid)) q:tmprowid=""  d
	..s RowId=$p(^TempCTLOC(pid,temp,tmprowid),"^",1)
	..s Description=$p(^TempCTLOC(pid,temp,tmprowid),"^",2)
	..q:(RowId'=gLocId)&&(pShowAllHospFlag'="Y")&&(##class(web.DHCSTMHUI.CTLOC).LocOfHosp(RowId,pHospId)'=0)
	..s DhcLocRowId=$o(^DHCLOC(0,"LOC",RowId,""))
	..s ActiveFlag="Y"
	..s:DhcLocRowId'="" ActiveFlag=$p(^DHCLOC(DhcLocRowId),"^",4)	;激活标识
	..q:(ActiveFlag'="Y")&&(pType'="Login")
	..q:(ActiveFlag'="Y")&&(pType="Login")&&(RowId'=gLocId)
	..s FromDate=$p(^CTLOC(RowId),"^",24)
	..s ToDate=$p(^CTLOC(RowId),"^",25)
	..q:(ToDate'="")&&(Date>ToDate)
	..q:(FromDate'="")&&(Date<FromDate)
	..s ContactName=$p(^CTLOC(RowId),"^",43)
	..q:(pDesc'="")&&($$ALPHAUP^SSUTIL4(Description)'[pDesc)&&($$ALPHAUP^SSUTIL4(ContactName)'[pDesc)	
	..q:(q'="")&&($$ALPHAUP^SSUTIL4(Description)'[q)&&($$ALPHAUP^SSUTIL4(ContactName)'[q)	
	..s Description=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(Description)
	..d OutPutLocRow
	k ^TempCTLOC(pid)
	
	Quit $$$OK
OutPutLocRow
	s Data=$lb(RowId,Description,ContactName)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	人员
/// Creater:	徐超
/// CreateDate:	2018-04-28
Query GetUser(Params As %String) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetUserExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJObj.%Get("BDPHospital") ;选择的医院ID
	s pShowAllHospFlag=PJObj.%Get("ShowAllHospFlag") ;范围取所有医院
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr="SELECT SSUSR_RowId AS RowId, SSUSR_Name AS Description  FROM SS_User"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("SS_User",RowId,pHospId,"","",pShowAllHospFlag)
		continue:ShowDataFlag'="Y"
		s Description = Result.Data("Description")
		d OutPutUserRow
	}
	d Result.Close()
	Quit $$$OK
OutPutUserRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// description: 取得出入库的操作类别
/// creator: lihui
/// date: 20180507
/// input:  type(入库出库类型：IM,OM)
/// output: String "RowId^Description"
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetOperateType",^tmpli("GetOperateType"))
Query GetOperateType(Params As %String) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetOperateTypeExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pType=PJObj.%Get("Type")
	s gHospId=PJObj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJObj.%Get("BDPHospital") ;选择的医院ID
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s Id=0
	f  s Id=$o(^DHCOPTYPE(0,"TYPE",pType,Id)) q:+Id'>0  d
	.s Code=$p(^DHCOPTYPE(Id),"^",1)
	.s RowId=Id
	.s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_OperateType",RowId,pHospId)
	.q:ShowDataFlag'="Y"
	.s Description=$p(^DHCOPTYPE(Id),"^",2)
	.d OutPutOperateTypeRow
	
	Quit $$$OK
OutPutOperateTypeRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 获取默认入库出库类型值(第一条记录)20181123lihui
ClassMethod GetDefaOPtype(TYPE As %String, HospId) As %Library.String
{
	n (TYPE,HospId)
	q:TYPE="" ""
	q:HospId="" ""
	s OperTypid="",retid=""
	f  s OperTypid=$o(^DHCOPTYPE(0,"TYPE",TYPE,OperTypid)) q:(OperTypid="")!(retid'="")  d
	.s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_OperateType",OperTypid,HospId)
	.q:ShowDataFlag'="Y"
	.s Defflag=$p(^DHCOPTYPE(OperTypid),"^",4)
	.i Defflag="Y" d
	..s retid=OperTypid
	.q:retid'=""
	s OperDesc=""
	i retid'="" s OperDesc=$p(^DHCOPTYPE(retid),"^",2)
	q retid_"^"_OperDesc
}

/// 获取默认采购人20211009litongxun
///  w ##class(web.DHCSTMHUI.Common.Dicts).GetDefaPurUser(163)
ClassMethod GetDefaPurUser(LocId) As %Library.String
{
	n (LocId)
	q:LocId="" ""
	s LppId="",retid="",PurUserName=""
	f  s LppId=$o(^DHCLOCPPUSER(0,"LOC",LocId,LppId)) q:(LppId="")!(retid'="")  d
	.s Defflag=$p(^DHCLOCPPUSER(LppId),"^",4)
	.i Defflag="Y" d
	..s retid=LppId
	.q:retid'=""
	s PurUserId=""
	s:retid'="" PurUserId=$p(^DHCLOCPPUSER(retid),"^",2)
	s:PurUserId'="" PurUserName=$p(^SSU("SSUSR",PurUserId),"^",2)
	q PurUserId_"^"_PurUserName
}

/// creator: lihui
/// date: 2015-06-16
/// description: 科室下维护的采购人员(采购员ComboBox)
/// input:  科室id
/// output: RowId,Description,Default
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetLocPPLUser",^tmpli("GetLocPPLUser"))
Query GetLocPPLUser(Params As %String) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description,Default") [ SqlProc ]
{
}

ClassMethod GetLocPPLUserExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	;s ^tmpli("GetLocPPLUser")=Params
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s UseAllUserAsPur=PJObj.%Get("UseAllUserAsPur")
	s pLocDr=PJObj.%Get("LocDr")
	i pLocDr="" d
	.s pLocDr=PJObj.%Get("gLocId")
	s Result = ##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	i UseAllUserAsPur="Y" d
	.s sqlStr="SELECT SSUSR_RowId AS RowId, SSUSR_Name AS Description  FROM SS_User"
	e  d
	.s sqlStr = "select LPP_RowId as LPPRowId,LPP_SSUSR_DR as RowId,LPP_SSUSR_DR->SSUSR_Name as Description,LPP_Active as Active,LPP_Default from DHC_LocPurPlanUser where LPP_CTLOC_DR="_pLocDr
	d Result.Prepare(sqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Description = Result.Data("Description")
		s (Active,Default)=""
		i UseAllUserAsPur="Y" s Active="Y",Default="N"
		i UseAllUserAsPur'="Y" d
		.s Active = Result.Data("Active")
		.s Default = Result.Data("LPP_Default")
		continue:Active'="Y"
		d OutPutLocPPLUserRow
	}
	d Result.Close()
	Quit $$$OK
OutPutLocPPLUserRow
	s Data=$lb(RowId,Description,Default)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	科室下人员
/// Creater:	lihui
/// CreateDate:	20180507
/// input:  科室id
/// output: RowId,Description
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetLocUser",^tmpli("GetLocUser"))
Query GetDeptUser(Params As %String, q As %String = "") As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetDeptUserExecute(ByRef qHandle As %Binary, Params As %String, q As %String = "") As %Status
{
	n (qHandle,Params,q)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pLocId=PJObj.%Get("LocDr")
	i pLocId="" d
	.s pLocId=PJObj.%Get("gLocId")
	s Filter=""
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "SELECT SSUSR_RowId AS RowId, SSUSR_Name AS Name FROM SS_User where SSUSR_DefaultDept_DR="_pLocId_"  and SSUSR_Name like '%"_Filter_"%'"
	s SqlStr1 = "select othll_parref as RowId,othll_parref->ssusr_name as Name From SS_UserOtherLogonLoc  where othll_ctloc_dr="_pLocId_" and othll_parref->ssusr_name like '%"_Filter_"%'"
	s SqlStr =SqlStr_" union "_SqlStr1 
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Description = Result.Data("Name")
		s Initial=$p(^SSU("SSUSR",RowId),"^",1)
		//s Description=Description_"["_Initial_"]"
		continue:(q'="")&&($$ALPHAUP^SSUTIL4(Description)'[$$ALPHAUP^SSUTIL4(q))
		s active = $p(^SSU("SSUSR",RowId),"^",19)
		;continue:active'="Y"
		s dateFrom = $p(^SSU("SSUSR",RowId),"^",96)
		s dateTo = $p(^SSU("SSUSR",RowId),"^",97)
		s date = +$h
		continue:(dateFrom'="")&&(date<dateFrom)
		continue:(dateTo'="")&&(date>dateTo)
		s childsub="",dataZFrom="",dateZTo=""
		f  s childsub=$o(^SSU("SSUSR",RowId,"OTHLL",childsub)) q:(childsub="")  d
		.s dataZFrom=$p(^SSU("SSUSR",RowId,"OTHLL",childsub),"^",4)
		.s dateZTo=$p(^SSU("SSUSR",RowId,"OTHLL",childsub),"^",5)
		.s loc=$p(^SSU("SSUSR",RowId,"OTHLL",childsub),"^",1)
		.q:(dataZFrom'="")&&(date<dataZFrom)&&(loc=pLocId)
		.q:(dateZTo'="")&&(date>dateZTo)&&(loc=pLocId)
		continue:(dataZFrom'="")&&(date<dataZFrom)&&(loc=pLocId)
		continue:(dateZTo'="")&&(date>dateZTo)&&(loc=pLocId)
		d OutPutLocUserRow
	}
	d Result.Close()
	Quit $$$OK
OutPutLocUserRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator: lihui
/// date: 20180509
/// description: 资金来源ComboBox
/// input:  
/// output: String "RowId^Description"
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetSourceOfFund",^tmpli("GetSourceOfFund"))
Query GetSourceOfFund(Params As %String) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetSourceOfFundExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	;s ^tmpli("GetSourceOfFund")=Params
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJobj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJobj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJobj.%Get("BDPHospital") ;选择的医院ID
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	;s pFilter=""
	s Result = ##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	;s SqlStr = "SELECT SOF_RowId AS RowId, SOF_Desc AS Description FROM DHC_SourceOfFund where SOF_Desc LIKE '%"_pFilter_"%'"
	s SqlStr = "SELECT SOF_RowId AS RowId, SOF_Desc AS Description FROM DHC_SourceOfFund"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Description = Result.Data("Description")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_SourceOfFund",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		d OutPutSourceOfFundRow
	}
	d Result.Close()
	Quit $$$OK
OutPutSourceOfFundRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	物资单位
/// Creater:	徐超
/// CreateDate:	2018-04-13
Query GetInciUom(Inci As %String) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetInciUomExecute(ByRef qHandle As %Binary, Inci As %String) As %Status
{
	n (qHandle,Inci)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Inci="" $$$OK 
	s Inci=+Inci   //部分传的Inclb
	q:'$d(^INCI(Inci)) $$$OK
	s (BUomDesc,PurUomDesc)=""
	s BUomId=$p(^INCI(Inci,1),"^",10)
	s:BUomId'="" BUomDesc=$p($g(^CT("UOM",BUomId)),"^",2)
	s PurUomId=$p(^INCI(Inci,3),"^",6)
	s:PurUomId'="" PurUomDesc=$p($g(^CT("UOM",PurUomId)),"^",2)
	s RowId=BUomId
	s Description=BUomDesc
	d OutPutInciUomRow
	i PurUomId'=BUomId  d
	.s RowId=PurUomId
	.s Description=PurUomDesc
	.d OutPutInciUomRow
	Quit $$$OK
OutPutInciUomRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	物资具体规格
/// Creater:	徐超
/// CreateDate:	2018-05-13
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetSpecDesc","2950","","{""gUserId"":""6423"",""gLocId"":""326"",""gGroupId"":""277"",""gHospId"":""2""}")
Query GetSpecDesc(Inci As %String, q As %String = "", Params As %String) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetSpecDescExecute(ByRef qHandle As %Binary, Inci As %String, q As %String = "", Params As %String) As %Status
{
	s ^bintmp(520)=$lb(Inci,q,Params)
	n (qHandle,Inci,q,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Inci="" $$$OK 
	s Inci=+Inci	//有时候Inclb
	q:'$d(^INCI(Inci)) $$$OK
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s GroupId=PJObj.%Get("gGroupId")
	s LocId=PJObj.%Get("gLocId")
	s UserId=PJObj.%Get("gUserId")
	s StrParam=GroupId_"^"_LocId_"^"_UserId
	s AllowEnterSpec=##class(web.DHCSTMHUI.Common.AppCommon).GetCommPropValue("AllowEnterSpec",StrParam)
	
	s UpperQ=$$UPPER^SSUTIL4(q)
	s ExistFlag=""
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "select SPEC_RowId as RowId,SPEC_Desc as SpecDesc FROM DHC_ItmSpecList where SPEC_INCI_DR="_Inci
		_" order by SPEC_Desc"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Description = Result.Data("SpecDesc")
		s UpperDesc=$$UPPER^SSUTIL4(Description)
		s DescCNCode=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(Description,4,"")
		continue:(UpperQ'="")&&(UpperDesc'[UpperQ)&&(DescCNCode'[UpperQ)
		i UpperDesc=UpperQ s ExistFlag="Y"
		d OutPutSpecDescRow
	}
	i (q'="")&&(ExistFlag'="Y")&&(AllowEnterSpec="Y") d
	.s RowId=""
	.s Description=q
	.d OutPutSpecDescRow
	d Result.Close()
	Quit $$$OK
OutPutSpecDescRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator: lihui
/// date: 20180509
/// description: 定价类型ComboBox
/// input:  
/// output: String "RowId^Description"
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetMarkType",^tmpli("GetMarkType"))
Query GetMarkType(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetMarkTypeExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s gHospId=PJobj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJobj.%Get("BDPHospital") ;选择的医院ID
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s pFilter=""
	s Result = ##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "SELECT MT_RowId as RowId,  MT_Desc as Description FROM DHC_MarkType where MT_UseFlag='Y' and MT_Type='M' ORDER BY MT_RowId"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Description = Result.Data("Description")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_MarkType",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		d OutPutMarkTypeRow
	}
	d Result.Close()
	Quit $$$OK
OutPutMarkTypeRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator: lihui
/// date: 20180509
/// description: 招标级别ComboBox
/// input:  
/// output: String "RowId^Description"
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetPBLevel",)
Query GetPBLevel(Params As %String = "") As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetPBLevelExecute(ByRef qHandle As %Binary, Params As %String = "") As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s:Params="" Params="{}"
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s PDesc=PJObj.%Get("Desc")
	s Pb=PJObj.%Get("Pb")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s Nowdate=+$h
	s Result = ##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	i Pb'="" d
	.s SqlStr = "SELECT DHCPBL_Level as RowId, DHCPBL_Level->PBL_Desc as Description, DHCPBL_Level->PBL_DateFrom as DateFrom,DHCPBL_Level->PBL_DateTo as DateTo FROM DHC_PublicBiddingList WHERE DHCPBL_Rowid="_Pb
	e  d
	.s SqlStr = "SELECT PBL_Rowid as RowId, PBL_Desc as Description,PBL_DateFrom as DateFrom,PBL_DateTo as DateTo FROM DHC_ItmPBLevel order by RowId"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		continue:+RowId'>0
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_ItmPBLevel",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = Result.Data("Description")
		continue:(PDesc'="")&&(Description'[PDesc)
		s DateFrom=Result.Data("DateFrom")
		s DateTo=Result.Data("DateTo")
		continue:(DateFrom'="")&&(DateFrom>Nowdate)
		continue:(DateTo'="")&&(DateTo<Nowdate)
		d OutPutPBLevelRow
	}
	d Result.Close()
	Quit $$$OK
OutPutPBLevelRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator: lihui
/// date: 20180509
/// description: 医保类别ComboBox
/// input:  
/// output: String "RowId^Description"
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetInsuCat",^tmpli("GetInsuCat"))
Query GetInsuCat(Params As %String) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetInsuCatExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	;s ^tmpli("GetInsuCat")=Params
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pFilter=""
	s Nowdate=+$h
	s Result = ##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "SELECT IC_Rowid as RowId, IC_Desc as Description FROM DHC_ItmInsuCategory"_
	"  where IC_DateFrom<="_Nowdate_" and IC_DateTo>="_Nowdate_" order by RowId"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Description = Result.Data("Description")
		d OutPutInsuCatRow
	}
	d Result.Close()
	Quit $$$OK
OutPutInsuCatRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	生产厂家ComboBox
/// Creater:	lihui
/// CreateDate:	20180510
/// input:  生产厂家描述,StkType,类组rowid,科室rowid,人员rowid,安全组rowid
/// output: String "RowId^Description"
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetPhManufacturer",^litmp("GetPhManufacturer"))
Query GetPhManufacturer(Params As %String, ScgId As %String = "") As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetPhManufacturerExecute(ByRef qHandle As %Binary, Params As %String, ScgId As %String = "") As %Status
{
	n (qHandle,Params,ScgId,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pStkType=PJObj.%Get("StkType")
	s:pStkType="" pStkType=..sssCode()
	s UserId=PJObj.%Get("gUserId")
	s LocId=PJObj.%Get("gLocId")
	s GroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s Param=GroupId_"^"_LocId_"^"_UserId_"^"_pHospId
	s Result = ##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s AppName="DHCSTCOMMONM"
	s ManfByHosp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"ManfByHosp",Param)
	s ManfScg=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"ManfScg",Param)
	
	s pid=..NewPid()
	k ^DHCSTMMANFQUERY("MANFQUERY",pid)
	i ManfScg="Y" d
	.i ScgId="" d
	..s ScgId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(UserId,pStkType,LocId,ScgId,pHospId)
	..s ScgId=$tr(ScgId,"^",",")
	..s len=$l(ScgId,",")
	..f i=1:1:len  d
	...s tmpScgid=$p(ScgId,",",i)
	...s MCGRowId=""
	...f  s MCGRowId=$o(^DHCMCG(0,"SCG",tmpScgid,MCGRowId)) q:MCGRowId=""  d
	....q:'$d(^DHCMCG(MCGRowId))
	....s info=^DHCMCG(MCGRowId)
	....
	....s RowId=$p(info,"^",1)
	....s ManfType="",ManfActive=""
	....&sql(select MANF_Type,MANF_Active into :ManfType,:ManfActive from DHC_Manf_AddionInfo
		where MANF_PhcManf_DR=:RowId)
	....q:(pStkType'="")&&(ManfType'=pStkType)
	....q:ManfActive'="Y"
	....
	....s MCGUseFlag=$p(info,"^",3)
	....q:MCGUseFlag'="Y"
	....i '$d(^DHCSTMMANFQUERY("MANFQUERY",pid,RowId)) d
	.....s ^DHCSTMMANFQUERY("MANFQUERY",pid,RowId)=RowId
	e  d
	.s RowId=""
	.f  s RowId=$o(^PHMNF(RowId)) q:RowId=""  d
	..s ManfType="",ManfActive=""
	..&sql(select MANF_Type,MANF_Active into :ManfType,:ManfActive from DHC_Manf_AddionInfo
		where MANF_PhcManf_DR=:RowId)
	..q:(pStkType'="")&&(ManfType'=pStkType)
	..q:ManfActive'="Y"
	..
	..i '$d(^DHCSTMMANFQUERY("MANFQUERY",pid,RowId)) d
	...s ^DHCSTMMANFQUERY("MANFQUERY",pid,RowId)=RowId
	..
	s RowId="" 
	f  s RowId=$o(^DHCSTMMANFQUERY("MANFQUERY",pid,RowId)) q:RowId=""  d
	.s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("PH_Manufacturer",RowId,pHospId)
	.q:ShowDataFlag'="Y"
	.s Description=$p(^PHMNF(RowId),"^",2)
	.d OutPutManufRow
	k ^DHCSTMMANFQUERY("MANFQUERY",pid)
	Quit $$$OK
OutPutManufRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/*
Query GetPhManufacturer1(Params As %String, ScgId As %String = "") As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetPhManufacturer1Execute(ByRef qHandle As %Binary, Params As %String, ScgId As %String = "") As %Status
{
	n (qHandle,Params,ScgId,%session)

	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pStkType=PJObj.%Get("StkType")
	s:pStkType="" pStkType=..sssCode()
	s UserId=PJObj.%Get("gUserId")
	s LocId=PJObj.%Get("gLocId")
	s GroupId=PJObj.%Get("gGroupId")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s Param=GroupId_"^"_LocId_"^"_UserId_"^"_pHospId
	s Filter=""
	s Result = ##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s AppName="DHCSTCOMMONM"
	s Filter=$$ALPHAUP^SSUTIL4(Filter)
	s ManfByHosp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"ManfByHosp",Param)
	s ManfScg=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"ManfScg",Param)
	i ManfScg="Y" d
	.i ScgId="" d
	..s ScgId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(UserId,pStkType,LocId,ScgId,pHospId)
	..s ScgId=$tr(ScgId,"^",",")
	.s SqlStr="select distinct(a.MCG_MANF_Dr) RowId,a.MCG_MANF_Dr->PHMNF_Name Description from DHC_ManfCatGroup as a left join DHC_Manf_AddionInfo as b on a.MCG_MANF_Dr=b.MANF_PhcManf_DR where a.MCG_UseFlag='Y' and a.MCG_SCG_Dr in ("_ScgId_") and (%ALPHAUP(a.MCG_MANF_Dr->PHMNF_Name) like '%"_Filter_"%' or %ALPHAUP(b.MANF_Alias) like '%"_Filter_"%')"
	e  d
	.s SqlStr = "select a.PHMNF_RowId RowId,a.PHMNF_Name Description from ph_manufacturer a left join DHC_Manf_AddionInfo b on a.phMnf_rowid=b.MANF_PhcManf_DR where %ALPHAUP(a.PHMNF_Name) like '%"_Filter_"%' or %ALPHAUP(b.MANF_Alias) like '%"_Filter_"%'"
	s SqlStr=SqlStr_" order by Description"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("PH_Manufacturer",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		;sql中含有distinct时,sql结果中desc是大写的,所以这里根据global取值
		s Description=$p(^PHMNF(RowId),"^",2)
		s ManfType="",ManfActive=""
		&sql(select MANF_Type,MANF_Active into :ManfType,:ManfActive from DHC_Manf_AddionInfo
			where MANF_PhcManf_DR=:RowId)
		continue:(pStkType'="")&&(ManfType'=pStkType)
		continue:ManfActive'="Y"
		d OutPutManufRow1
	}
	d Result.Close()
	Quit $$$OK
OutPutManufRow1
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}
*/
/// Descript:	配送商ComboBox
/// Creater:	lxt
/// CreateDate:	2018-5-14
/// input:  供应商描述,StkType,类组rowid,科室rowid,人员rowid,安全组rowid
/// output: String "RowId^Description"
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetCarrier","")
Query GetCarrier(Params As %String) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetCarrierExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gGroupId=PJObj.%Get("gGroupId")
	s pHospId=PJObj.%Get("BDPHospital")
	s PLocId=PJObj.%Get("LocId")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s type=..sssCode()
	s Filter=""
	s AppName="DHCSTCOMMONM"
	;是否根据配送商科室授权进行取值
	s Param=gGroupId_"^"_gLocId_"^"_gUserId_"^"_pHospId
	s CarrierRange=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"CarrierRange",Param)
	s Result = ##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	i (CarrierRange="L")&&(PLocId'="") d
	.s count=0
	.&sql(SELECT count(1) into :count FROM CF_HRP_MAT.CarrierLoc WHERE MCT_Loc_DR=:PLocId)
	.i count>0 d
	..s sqlStr = "SELECT distinct(MCT_Carrier_DR) RowId,MCT_Carrier_DR->Ca_Desc Description FROM CF_HRP_MAT.CarrierLoc where MCT_Loc_DR="_PLocId_" and MCT_UseFlag='Y' and MCT_Carrier_DR->CA_Type ="_"'"_type_"'"
	.e  d
	..s sqlStr = "SELECT Ca_RowId as RowId,Ca_Desc as Description,CA_Hospital_DR FROM DHC_Carrier WHERE Ca_Desc LIKE '%"_Filter_"%' and CA_Type ="_"'"_type_"'"
	e  d
	.s sqlStr = "SELECT Ca_RowId as RowId,Ca_Desc as Description,CA_Hospital_DR FROM DHC_Carrier WHERE Ca_Desc LIKE '%"_Filter_"%' and CA_Type ="_"'"_type_"'"
	s sqlStr=sqlStr_" order by Description"
	d Result.Prepare(sqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_Carrier",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = Result.Data("Description")
		d OutPutCarrierRow
	}
	d Result.Close()
	Quit $$$OK
OutPutCarrierRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	用户可登录安全组
/// Creater:	tsr
/// CreateDate:	2018-04-27
/// Input:		用户Id
Query GetUserGroup(UserId As %String) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetUserGroupExecute(ByRef qHandle As %Binary, UserId As %String) As %Status
{
	n (qHandle,UserId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr1 = "SELECT SSGRP_RowId AS RowId, SSGRP_Desc AS Description FROM ss_group WHERE ssgrp_rowid IN ( SELECT OTHLL_UserGroup_DR FROM SS_UserOtherLogonLoc WHERE OTHLL_ParRef ="_UserId_")"
	s SqlStr2 = "SELECT SSGRP_RowId AS RowId, SSGRP_Desc AS Description FROM ss_group WHERE ssgrp_rowid IN ( SELECT SSUSR_Group FROM SS_User WHERE SSUSR_RowId ="_UserId_")"
	s SqlStr = SqlStr1_" union "_SqlStr2
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Description = Result.Data("Description")
		d OutPutGroupRow
	}
	Quit $$$OK
OutPutGroupRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	退货原因
/// Creater:	徐超
/// CreateDate:	2018-05-28
Query GetRetReason(Params = "") As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetRetReasonExecute(ByRef qHandle As %Binary, Params = "") As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJObj.%Get("BDPHospital") ;选择的医院ID
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "select RET_Rowid AS RowId, RET_Desc AS Description, RET_StkType AS StkType from INC_ReasonForReturn where RET_StkType='M'"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("INC_ReasonForReturn",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = Result.Data("Description")
		d OutPutRetReasonRow
	}
	d Result.Close()
	Quit $$$OK
OutPutRetReasonRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	调价原因
/// Creater:	张枭
/// CreateDate:	2018-06-06
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetAdjPriceReason")
Query GetAdjPriceReason(Params = "") As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetAdjPriceReasonExecute(ByRef qHandle As %Binary, Params = "") As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJObj.%Get("BDPHospital") ;选择的医院ID
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "select REA_RowId AS RowId, REA_Desc AS Description, REA_StkType AS StkType from DHC_ReasonForAdjustPrice where REA_StkType='M'"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_ReasonForAdjustPrice",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = Result.Data("Description")
		d OutPutAdjPriceReasonRow
	}
	d Result.Close()
	Quit $$$OK
OutPutAdjPriceReasonRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	支付方式
/// Creater:	tsr
/// CreateDate:	2018-05-24
Query GetPayMode(Params = "") As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetPayModeExecute(ByRef qHandle As %Binary, Params = "") As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJObj.%Get("BDPHospital") ;选择的医院ID
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	//付款方式由dhc_paymode改为ct_paymode
	;s SqlStr = "SELECT PayMode_RowID RowId, PayMode_Desc Description FROM DHC_PayMode"
	s SqlStr = "SELECT CTPM_RowId RowId, CTPM_Desc Description FROM CT_PayMode"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("CT_PayMode",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = Result.Data("Description")
		d OutPutPayModeRow
	}
	Quit $$$OK
OutPutPayModeRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:qiushengxin
/// date:2018-05-29
/// description: 报损原因ComboBox
/// input: 
/// output: String "RowId^Description"
/// others:
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetReasonForScrap","{""Type"":""M"",""gUserId"":""5140"",""gLocId"":""8"",""gGroupId"":""98"",""gHospId"":""2""}")
Query GetReasonForScrap(Params As %String) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetReasonForScrapExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s Type=PJObj.%Get("Type")
	s gHospId=PJObj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJObj.%Get("BDPHospital") ;选择的医院ID
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s Result = ##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "select REASON_ScrapRowID AS RowId, REASON_ScrapDesc AS Description,REASON_ScrapType As SType  from DHC_IncReasonForStockScrap ORDER BY REASON_ScrapRowID"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_IncReasonForStockScrap",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = Result.Data("Description")
		s SType = Result.Data("SType")
		continue:SType'=Type
		d OutGetReasonForScrapRow
	}
	d Result.Close()
	Quit $$$OK
OutGetReasonForScrapRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	货位
/// Creater:	wfg
/// CreateDate:	2018-06-28
/// Input:		
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetLocStkBin","")
Query GetLocStkBin(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetLocStkBinExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s Result = ##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s pLocDr=PJObj.%Get("LocDr")
	s date=+$h
	s stknull="空"
	s sqlStr = "SELECT INCSB_Rowid as RowId, INCSB_Desc as Description FROM INC_StkBin "_
	" where INCSB_Desc <> '"_stknull_"' and INCSB_Code like '"_pLocDr_"P%' order by Description"
	d Result.Prepare(sqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Description = Result.Data("Description")
		d OutPutLocStkBinRow
	}
	d Result.Close()
	Quit $$$OK
OutPutLocStkBinRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:liuhui
/// date:2018-06-28
/// description: 调整原因ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetForAdjustReason")
Query GetForAdjustReason(Params = "") As web.DHCSTMHUI.Query(ROWSPEC = "Rowid,Description") [ SqlProc ]
{
}

ClassMethod GetForAdjustReasonExecute(ByRef qHandle As %Binary, Params = "") As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJObj.%Get("BDPHospital") ;选择的医院ID
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s sqlStr = "SELECT ADJ_RowId as RowId, ADJ_Desc as Description FROM INC_ReasonForAdjustment where ADJ_StkType='M' order by ADJ_RowId "
	d Result.Prepare(sqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s Rowid = Result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("INC_ReasonForAdjustment",Rowid,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = Result.Data("Description")
		d OutPutAdjForRow
	}
	Quit $$$OK
OutPutAdjForRow
	s Data=$lb(Rowid,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	实盘窗口
/// Creater:	wfg
/// CreateDate:	2018-04-13
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetInStkTkWindow",153)
Query GetInStkTkWindow(LocId) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetInStkTkWindowExecute(ByRef qHandle As %Binary, LocId) As %Status
{
	n (qHandle,LocId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	 
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "SELECT STTKW_RowID AS RowId, STTKW_Desc AS Description FROM dhc_instktkwindow WHERE STTKW_CTLOC_DR="_LocId
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Description = Result.Data("Description")
		d OutPutInStkTkWindowRow
	}
	d Result.Close()
	Quit $$$OK
OutPutInStkTkWindowRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	管理组
/// Creater:	wfg
/// CreateDate:	2018-04-13
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetLocManGrp",153)
Query GetLocManGrp(LocId) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetLocManGrpExecute(ByRef qHandle As %Binary, LocId) As %Status
{
	n (qHandle,LocId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	Quit:LocId="" $$$OK
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "SELECT LMG_Rowid AS RowId, LMG_Desc AS Description FROM DHC_LocManGrp WHERE LMG_CTLOC_DR="_LocId_" ORDER BY Description"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Description = Result.Data("Description")
		d OutPutInStkTkWindowRow
	}
	d Result.Close()
	Quit $$$OK
OutPutLocManGrpRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	安全组
/// Creater:	zx
/// CreateDate:	2018-07-26
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetGroup",""{""ShowAllHospFlag"":""Y"",""gUserId"":""6423"",""gLocId"":""326"",""gGroupId"":""277"",""gHospId"":""2""}"")
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetGroup","")
Query GetGroup(Params = "") As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetGroupExecute(ByRef qHandle As %Binary, Params = "") As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s gHospId=PJobj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJobj.%Get("BDPHospital") ;选择的医院ID
	s pShowAllHospFlag=PJobj.%Get("ShowAllHospFlag") ;范围取所有医院
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "SELECT SSGRP_RowId AS RowId, SSGRP_Desc AS Description FROM SS_Group"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("SS_Group",RowId,pHospId,"","",pShowAllHospFlag)
		continue:ShowDataFlag'="Y"
		s Description = Result.Data("Description")
		d OutPutRowGroup
	}
	d Result.Close()
	Quit $$$OK
OutPutRowGroup
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	采购审核级别
/// Creater:	zx
/// CreateDate:	2018-07-26
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetPlanStatus")
Query GetPlanStatus(Params = "") As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Code,Description") [ SqlProc ]
{
}

ClassMethod GetPlanStatusExecute(ByRef qHandle As %Binary, Params = "") As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s gHospId=PJobj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJobj.%Get("BDPHospital") ;选择的医院ID
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "select * from DHC_PlanStatus where DHCPS_StkType='M'" 
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("DHCPS_RowId")
		//判断医院权限
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_PlanStatus",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Code = Result.Data("DHCPS_Code")
		s Description = Result.Data("DHCPS_Desc")
		d OutPutPlanStatusRow
	}
	d Result.Close()
	Quit $$$OK
OutPutPlanStatusRow
	s Data=$lb(RowId,Code,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:XuChao
/// date:2018-07-30
/// description: 取和已知单位存在转换关系的单位
/// input: 已知单位id
Query GetConUom(UomId As %String) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetConUomExecute(ByRef qHandle As %Binary, UomId As %String) As %Status
{
	n (qHandle,UomId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:UomId="" $$$OK
	s FrUomId=0
	f  s FrUomId=$o(^CT("CTCF",0,"UOM",FrUomId)) q:FrUomId=""  d
	.q:'$d(^CT("CTCF",0,"UOM",FrUomId,UomId))
	.q:'$d(^CT("UOM",FrUomId))
	.s RowId=FrUomId
	.s UomDesc=$p(^CT("UOM",FrUomId),"^",2)
	.d OutPutConUomRow
	i '$d(^CT("CTCF",0,"UOM",UomId,UomId)) d   //自身不存在转换时,把该单位自身加到结果集中
	.s RowId=UomId
	.s UomDesc=$p($G(^CT("UOM",UomId)),"^",2)
	.d OutPutConUomRow
	Quit $$$OK
OutPutConUomRow
	s Data=$lb(RowId,UomDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:XuChao
/// date:2018-7-30
/// description: 帐薄分类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
Query GetBookCat(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetBookCatExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s gHospId=PJobj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJobj.%Get("BDPHospital") ;选择的医院ID
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	s sqlStr = "SELECT BC_RowId as RowId, BC_Desc as Description FROM DHCST_BookCat order by BC_RowId"
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s Description = result.Data("Description")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHCST_BookCat",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		d OutPutBookCatRow
	}
	d result.Close()
	Quit $$$OK
OutPutBookCatRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:XuChao
/// date:2018-07-30
/// description: 收费类型
/// input:  
/// output: String "RowId^Description"
/// others:
Query GetChargeType(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetChargeTypeExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s gHospId=PJobj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJobj.%Get("BDPHospital") ;选择的医院ID
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	s sqlStr = "SELECT ICT_RowId as RowId,ICT_Desc as Description FROM DHC_ItmChargeType"
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s Description = result.Data("Description")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_ItmChargeType",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		d OutPutChargeTypeRow
	}
	d result.Close()
	Quit $$$OK
OutPutChargeTypeRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:XuChao
/// date:2018-07-30
/// description: 招标名称ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetPublicBidding","{""BDPHospital"":""2"",""gUserId"":""6423"",""gLocId"":""326"",""gGroupId"":""277"",""gHospId"":""2""}")
Query GetPublicBidding(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetPublicBiddingExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s PDesc=PJObj.%Get("Desc")
	s Pb=PJObj.%Get("Pb")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	s stype=..sssCode()
	s sqlStr = "SELECT DHCPBL_RowId as RowId, DHCPBL_Desc as Description,DHCPBL_EfficDateFrom as df,DHCPBL_EfficDateTo as dt,DHCPBL_Level FROM DHC_PublicBiddingList where DHCPBL_Desc is not null and DHCPBL_ActiveFlag='Y' and DHCPBL_Type="_"'"_stype_"'"_" order by DHCPBL_RowId"
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s df=result.Data("df")
		s dt=result.Data("dt")
		i df>0 continue:+$H<df
		i dt>0 continue:+$H>dt
		s RowId = result.Data("RowId")
		s Description = result.Data("Description")
		s DHCPBLLevelId= result.Data("DHCPBL_Level")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_PublicBiddingList",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		d OutPutPublicBiddingRow
	}
	d result.Close()
	Quit $$$OK
OutPutPublicBiddingRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:XuChao
/// date:2018-07-30
/// description:产地ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
Query GetOrigin(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetOriginExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	s type=..sssCode()
	s sqlStr = "SELECT Orig_RowId as RowId, Orig_Name as Description FROM DHC_STOrigin WHERE Orig_Type='"_type_"'"
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_STOrigin",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = result.Data("Description")
		d OutPutOriginRow
	}
	d result.Close()
	Quit $$$OK
OutPutOriginRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:XuChao
/// date:2018-07-30
/// description:灭菌类型ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
Query GetSterileCat(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetSterileCatExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	s type=..sssCode()
	s sqlStr="select SCAT_Rowid as RowId,SCAT_Desc as Description from INC_SterileCategory "
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s Description = result.Data("Description")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("INC_SterileCategory",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		d OutPutSterileCatRow
	}
	d result.Close()
	Quit $$$OK
OutPutSterileCatRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:XuChao
/// date:2018-07-30
/// description:质量层次ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
Query GetQualityLevel(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetQualityLevelExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	s date=+$h
	s sqlStr = "SELECT QL_Rowid as RowId, QL_Desc as Description FROM DHC_ItmQualityLevel"_
	"  where QL_DateFrom<="_date_" and QL_DateTo>="_date_" order by RowId"
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s Description = result.Data("Description")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_ItmQualityLevel",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		d OutPutQualityLevelRow
	}
	d result.Close()
	Quit $$$OK
OutPutQualityLevelRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:XuChao
/// date:2018-07-30
/// description:不可用ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
Query GetNotUseReason(Params = "") As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetNotUseReasonExecute(ByRef qHandle As %Binary, Params = "") As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s gHospId=PJobj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJobj.%Get("BDPHospital") ;选择的医院ID
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	s sqlStr = "SELECT DIUR_Rowid as RowId, DIUR_Desc as Description FROM DHC_ItmNotUseReason"
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_ItmNotUseReason",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = result.Data("Description")
		d OutPutNotUseReasonRow
	}
	d result.Close()
	Quit $$$OK
OutPutNotUseReasonRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:XuChao
/// date:2018-07-30
/// description:医嘱大类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
Query GetOrdCat(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetOrdCatExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	i $o(^ARC("IC",0,"OrderType","M",""))>0 d
	.s sqlStr="select distinct arcic_ordcat_dr->orcat_rowid as RowId,arcic_ordcat_dr->orcat_desc as Description from ARC_ItemCat  where arcic_ordertype="_"'"_"M"_"'"
	e  d
	.//下面的检索适用于较早的版本,即 ARC_ItemCat.ARCIC_OrderType 没有"M"的情况
	.s sqlStr = "select ORCAT_RowId as RowId, ORCAT_Desc as Description from OEC_OrderCategory where orcat_desc like '%材料%'  ORDER BY ORCAT_RowId"
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("OEC_OrderCategory",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = result.Data("Description")
		d OutPutOrdCatRow
	}
	d result.Close()
	Quit $$$OK
OutPutOrdCatRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:XuChao
/// date:2018-07-30
/// description:医嘱子类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
Query GetOrdSubCat(OrdCat As %String, Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetOrdSubCatExecute(ByRef qHandle As %Binary, OrdCat As %String, Params) As %Status
{
	n (qHandle,OrdCat,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	i OrdCat'="" d
	.s sqlStr = "SELECT ARCIC_RowId as RowId, ARCIC_Desc as Description FROM ARC_ItemCat where  ARCIC_OrdCat_DR="_OrdCat
	e  d
	.s sqlStr = "SELECT ARCIC_RowId as RowId, ARCIC_Desc as Description from ARC_ItemCat where arcic_ordertype="_"'"_"M"_"'"
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("ARC_ItemCat",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = result.Data("Description")
		d OutPutOrdSubCatRow
	}
	d result.Close()
	Quit $$$OK
OutPutOrdSubCatRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:XuChao
/// date:2018-07-30
/// description:费用大类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
Query GetBillCat(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetBillCatExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s sqlStr = "select ARCBG_RowId AS RowId, ARCBG_DESC AS Description from ARC_BillGrp ORDER BY ARCBG_RowId"
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("ARC_BillGrp",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = result.Data("Description")
		d OutPutBillCatRow
	}
	d result.Close()
	Quit $$$OK
OutPutBillCatRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:XuChao
/// date:2018-07-30
/// description:费用子类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetBillSubCat")
Query GetBillSubCat(BillCat As %String, Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetBillSubCatExecute(ByRef qHandle As %Binary, BillCat As %String, Params) As %Status
{
	n (qHandle,BillCat,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s sqlStr = "select ARCSG_RowId AS RowId, ARCSG_DESC AS Description from ARC_BillSub WHERE ARCSG_ARCBG_ParRef = "_BillCat
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("ARC_BillSub",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = result.Data("Description")
		d OutPutBillSubCatRow
	}
	d result.Close()
	Quit $$$OK
OutPutBillSubCatRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:XuChao
/// date:2018-07-31
/// description: 医嘱优先级ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetOECPriority")
Query GetOECPriority() As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetOECPriorityExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s sqlStr = "select OECPR_RowId as RowId, OECPR_Desc as Description from OEC_Priority ORDER BY OECPR_RowId"
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s Description = result.Data("Description")
		d OutPutOECPriorityRow
	}
	d result.Close()
	Quit $$$OK
OutPutOECPriorityRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:XuChao
/// date:2018-07-31
/// description: 子分类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
Query GetTarSubCat(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetTarSubCatExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s sqlStr = "select TARSC_RowId as RowId,TARSC_Desc as Description from DHC_TarSubCate"
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_TarSubCate",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = result.Data("Description")
		d OutPutTarSubCatRow
	}
	d result.Close()
	Quit $$$OK
OutPutTarSubCatRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:XuChao
/// date:2018-07-31
/// description: 住院子分类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
Query GetTarInpatCat(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetTarInpatCatExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s sqlStr = "select TARIC_RowId as RowId,TARIC_Desc as Description from DHC_TarInpatCate"
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_TarInpatCate",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = result.Data("Description")
		d OutPutTarInpatCatRow
	}
	d result.Close()
	Quit $$$OK
OutPutTarInpatCatRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:XuChao
/// date:2018-07-31
/// description: 门诊子分类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
Query GetTarOutpatCat(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetTarOutpatCatExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s sqlStr = "select TAROC_RowId as RowId,TAROC_Desc as Description from DHC_TarOutpatCate"
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_TarOutpatCate",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = result.Data("Description")
		d OutPutTarOutpatCatRow
	}
	d result.Close()
	Quit $$$OK
OutPutTarOutpatCatRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:XuChao
/// date:2018-07-31
/// description: 核算子分类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
Query GetTarEMCCat(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetTarEMCCatExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s sqlStr = "select TAREC_RowId as RowId,TAREC_Desc as Description from DHC_TarEMCCate"
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_TarEMCCate",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = result.Data("Description")
		d OutPutTarEMCCatRow
	}
	d result.Close()
	Quit $$$OK
OutPutTarEMCCatRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:XuChao
/// date:2018-07-31
/// description: 会计子分类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
Query GetTarAcctCat(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetTarAcctCatExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s sqlStr = "select TARAC_RowId as RowId,TARAC_Desc as Description from DHC_TarAcctCate"
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_TarAcctCate",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = result.Data("Description")
		d OutPutTarAcctCatRow
	}
	d result.Close()
	Quit $$$OK
OutPutTarAcctCatRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:XuChao
/// date:2018-07-31
/// description: 病历子分类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
Query GetTarMRCat(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetTarMRCatExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s sqlStr = "select TARMC_RowId as RowId,TARMC_Desc as Description from DHC_TarMRCate"
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_TarMRCate",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = result.Data("Description")
		d OutPutTarMRCatRow
	}
	d result.Close()
	Quit $$$OK
OutPutTarMRCatRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:XuChao
/// date:2018-07-31
/// description: 新病历首页ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
Query GetTarNewMRCat(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetTarNewMRCatExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s RowId=0
	f  s RowId=$o(^DHCTarC("MCNew",RowId)) q:(RowId="")  d
	.s Description=$p(^DHCTarC("MCNew",RowId),"^",2)
	.s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_TarMCCateNew",RowId,pHospId)
	.q:ShowDataFlag'="Y"
	.d OutPutTarNewMRCatRow
	Quit $$$OK
OutPutTarNewMRCatRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:lxt
/// date:2018-07-28
/// description: 订单取消原因ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetForInPoReasonForCancel")
Query GetForInPoReasonForCancel(Params = "") As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetForInPoReasonForCancelExecute(ByRef qHandle As %Binary, Params = "") As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s sqlStr = "SELECT CFR_RowId as RowId,CFR_Desc as Description FROM INC_POCanc_FullFillReason where CFR_StkType='M' order by CFR_RowId "
	d Result.Prepare(sqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("INC_POCanc_FullFillReason",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = Result.Data("Description")
		d OutPutInPoRow
	}
	Quit $$$OK
OutPutInPoRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	科室
/// Creater:	liuhui
/// CreateDate:	2018-08-08
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetAllLoc")
Query GetAllLoc() As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Code,Description") [ SqlProc ]
{
}

ClassMethod GetAllLocExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	 
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "select CTLOC_RowId as RowId,CTLOC_Code as Code, CTLOC_Desc as Description from CT_Loc"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Code =Result.Data("Code")
		s Description = Result.Data("Description")
		d OutPutLocDescRow
	}
	d Result.Close()
	Quit $$$OK
OutPutLocDescRow
	s Data=$lb(RowId,Code,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:zx
/// date:2018-08-24
/// description:带材料的医嘱子类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetOrdSubCatM")
Query GetOrdSubCatM(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetOrdSubCatMExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s sqlStr = "SELECT ARCIC_RowId as RowId, ARCIC_Desc as Description FROM ARC_ItemCat  where ARCIC_OrdCat_DR->orcat_desc like '%材料%' ORDER BY Description"
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("ARC_ItemCat",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = result.Data("Description")
		d OutPutOrdSubCatMRow
	}
	d result.Close()
	Quit $$$OK
OutPutOrdSubCatMRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:zx
/// date:2018-08-24
/// description:费用子类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetBillSubCatAll")
Query GetBillSubCatAll(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetBillSubCatAllExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s sqlStr = "select ARCSG_RowId AS RowId, ARCSG_DESC AS Description from ARC_BillSub "
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s RowId = result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("ARC_BillSub",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = result.Data("Description")
		d OutPutBillSubCatAllRow
	}
	d result.Close()
	Quit $$$OK
OutPutBillSubCatAllRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	科室组
/// Creator:	lxt
/// CreateDate:	2018-08-30
/// Table:		DHC_StkLocGroup
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetLocGroup",^litmp("GetLocGroup"))
Query GetLocGroup(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetLocGroupExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s sqlStr = "SELECT SLG_RowId as RowId,SLG_Desc as Description FROM DHC_StkLocGroup where SLG_Type='M' order by SLG_RowId "
	d Result.Prepare(sqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_StkLocGroup",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = Result.Data("Description")
		d OutPutLocGroupRow
	}
	Quit $$$OK
OutPutLocGroupRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 项目组
Query GetLocItemGrp(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetLocItemGrpExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s sqlStr = "SELECT LIG_RowID as RowId,LIG_Desc as Description from DHC_LocItemGrp"
		_" where LIG_Flag='Y'"
	d Result.Prepare(sqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_LocItemGrp",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = Result.Data("Description")
		d OutPutSIGRow
	}
	Quit $$$OK
OutPutSIGRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:XuChao
/// Date:2018-4-18
/// Description: 库存分类
Query GetAllStkCat(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetAllStkCatExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s sqlStr = "SELECT INCSC_RowId as RowId, INCSC_Desc as Description FROM INC_StkCat WHERE INCSC_StkType='M'" 
	d Result.Prepare(sqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("INC_StkCat",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = Result.Data("Description")
		d OutPutAllCatRow
	}
	Quit $$$OK
OutPutAllCatRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:wfg
/// date:2018-09-28
/// description: 小数规则ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetStkDecimal")
Query GetStkDecimal(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetStkDecimalExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s gHospId=PJobj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJobj.%Get("BDPHospital") ;选择的医院ID
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	 
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "SELECT SD_RowID as RowId, SD_Desc as Description FROM DHC_StkDecimal WHERE SD_UseFlag='Y' and SD_Type='M'"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_StkDecimal",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = Result.Data("Description")
		d OutPutStkDecimalRow
	}
	d Result.Close()
	Quit $$$OK
OutPutStkDecimalRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// creator:xuchao
/// date:2019-08-29
/// description: 官方分类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetOffice")
Query GetOfficial(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetOfficialExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr = "SELECT MCO_Rowid as RowId, MCO_Desc as Description FROM DHC_MatCatOfficial"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Description = Result.Data("Description")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_MatCatOfficial",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		d OutPutOfficeRow
	}
	d Result.Close()
	Quit $$$OK
OutPutOfficeRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	68分类combotree取值
/// Creater:	wxj
/// CreateDate:	20230418
/// Table: 		DHC_MatCatOfficial
/// Input: 
/// Output:
/// w ##class(web.DHCSTMHUI.Common.Dicts).GetMCOChildNode("AllMCO","2^2")
ClassMethod GetMCOChildNode(NodeId As %String, Params As %String) As %String
{
	n (NodeId,Params,%session)
	s NodeType=$p(NodeId,"-",1)
	s NodeRowId=$p(NodeId,"-",2)
	s gHospId=$p(Params,"^",1)
	s pHospId=$p(Params,"^",2)
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s result = ##class(%Library.ResultSet).%New()
	i NodeType="AllMCO" d
	.s sqlStr="Select 'MCO-'||MCO_Rowid as Id,MCO_Code as Code, MCO_Desc as Description From DHC_MatCatOfficial where MCO_Uplevel_DR IS Null"
	e  i NodeType="MCO" d
	.s sqlStr="Select 'MCO-'||MCO_Rowid as Id, MCO_Code as Code, MCO_Code as Description From DHC_MatCatOfficial where MCO_Uplevel_DR="_NodeRowId
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s ResultStr=""
	While(result.Next())
	{
		s Id=result.Data("Id")
		s Token=$p(Id,"-",1)
		s RowId=+$p(Id,"-",2)
		continue:RowId=0
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_MatCatOfficial",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		
		s Description=result.Data("Description")
		//拼接Json
		s:(ResultStr'="") ResultStr=ResultStr_","
		s ResultStr=ResultStr_"{"
		s ResultStr=ResultStr_"""id"":"""_""_RowId_""",""text"":"""_Description_""""
		s ChildStr=..GetMCOChildNode(Id,Params)
		i ChildStr'="[]"  d
		.s ResultStr=ResultStr_",""children"":"
		.s ResultStr=ResultStr_ChildStr
		s ResultStr=ResultStr_"}"
	}
	s ResultStr="["_ResultStr_"]"
	q ResultStr
}

/// description: 临床分类ComboBox
/// input:  
/// output: String "RowId^Description"
/// others:
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetClinicCat","{""gHospId"":2}")
Query GetClinicCat(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetClinicCatExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s Result=##class(%Library.ResultSet).%New()
	s SqlStr = "SELECT MCC_Rowid as RowId, MCC_Desc as Description FROM DHC_MatCatClinical"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Description = Result.Data("Description")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_MatCatClinical",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		d OutPutClinicRow
	}
	d Result.Close()
	Quit $$$OK
OutPutClinicRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	查询证件类型
/// Creator:	lxt
/// CreateDate:	2020-8-18
/// Table:		DHC_CertType
/// Input:		类型，查询条件
/// Return：	资质类型
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetCertType","{""BDPHospital"":""2"",""Type"":""Vendor"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2""}")
Query GetCertType(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetCertTypeExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pType=PJObj.%Get("Type")
	s pType=##class(web.DHCSTMHUI.DHCCertType).GetCertTypeShare(pType)
	i pType="" q $$$OK
	
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s SqlStr = "select CT_RowId as RowId,CT_Code as Code,CT_FullName as FullName,"
		_"CT_ShortName as ShortName,CT_ShowFlag as ShowFlag "
		_" from DHC_CertType where CT_Type='"_pType_"' and  CT_ShowFlag='Y'order by CT_Num asc"
		
	s Result=##class(%Library.ResultSet).%New()
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId=Result.Data("RowId")
		s Code = Result.Data("Code")
		s FullName = Result.Data("FullName")
		s ShortName = Result.Data("ShortName")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_CertType",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		d OutPutCertTypeRow
	}
	d Result.Close()
	Quit $$$OK
OutPutCertTypeRow
	s Data=$lb(Code,ShortName)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	物资注册证信息
/// Creater:	徐超
/// CreateDate:	2018-05-13
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetRegCert","8","","{""gUserId"":""6423"",""gLocId"":""326"",""gGroupId"":""277"",""gHospId"":""2""}")
Query GetRegCert(Inci As %String, q As %String = "", Params As %String) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description,MRCManfId,MRCManfDesc,MRCExpDate") [ SqlProc ]
{
}

ClassMethod GetRegCertExecute(ByRef qHandle As %Binary, Inci As %String, q As %String = "", Params As %String) As %Status
{
	n (qHandle,Inci,q,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Inci="" $$$OK 
	s Inci=+Inci	//有时候Inclb
	
	q:'$d(^INCI(Inci)) $$$OK
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s GroupId=PJObj.%Get("gGroupId")
	s LocId=PJObj.%Get("gLocId")
	s UserId=PJObj.%Get("gUserId")
	
	s ExistFlag=""
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "select IRR_RegCert_DR as RowId from DHC_ItmRegRelations where IRR_INCI_DR="_Inci
		_" order by IRR_RowId"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s (MRCManfDesc)=""
		s RowId = Result.Data("RowId")
		s MRCNo=$p(^DHCMRCT(RowId),"^",12)
		s MRCExpDate=$p(^DHCMRCT(RowId),"^",20)
		s MRCManfId=$p(^DHCMRCT(RowId),"^",2)
		s:MRCManfId'="" MRCManfDesc=$P(^PHMNF(MRCManfId),"^",2)
		s:MRCExpDate'="" MRCExpDate=..DL2H(MRCExpDate)
		i MRCNo=q s ExistFlag="Y"
		s Description=MRCNo
		d OutPutRegCertRow
	}
	i (q'="")&&(ExistFlag'="Y") d
	.s RowId=""
	.s Description=q
	.d OutPutRegCertRow
	d Result.Close()
	Quit $$$OK
OutPutRegCertRow
	s Data=$lb(RowId,Description,MRCManfId,MRCManfDesc,MRCExpDate)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	查询图片类型
/// Creator:	lxt
/// CreateDate:	2020-8-18
/// Table:		DHC_CertType
/// Input:		类型，查询条件
/// Return：	资质类型
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetFileType","{""BDPHospital"":""2"",""OrgType"":""Vendor"",""GrpType"":""Person"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2""}")
Query GetFileType(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetFileTypeExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pOrgType=PJObj.%Get("OrgType")
	i pOrgType="" q $$$OK
	
	s pGrpType=PJObj.%Get("GrpType")
	
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s SqlStr=""
	i (pGrpType="Cert")||(pGrpType="") d
	.s SqlStr="select CT_Code as RowId,CT_ShortName as Description "
	.s SqlStr=SqlStr_" from DHC_CertType where CT_Type='"_pOrgType_"' and CT_ShowFlag='Y'"
	.s SqlStr=SqlStr_"order by CT_Num asc"	
	s Result=##class(%Library.ResultSet).%New()
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId=Result.Data("RowId")
		s Description = Result.Data("Description")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_CertType",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		d OutPutFileTypeRow
	}
	d Result.Close()
	i (pGrpType="Person")||(pGrpType="") d
	.s RowId="SaleMan"
	.s Description="业务员"
	.d OutPutFileTypeRow
	Quit $$$OK
OutPutFileTypeRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	查询人员图片类型
/// Creator:	lxt
/// CreateDate:	2020-8-18
/// Table:		DHC_CertType
/// Input:		类型，查询条件
/// Return：	资质类型
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetPersonFileType")
Query GetPersonFileType() As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetPersonFileTypeExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s RowIdStr="PersonLic^PersonPhoto^PersonCard"
	s DescStr="授权书^照片^身份证"
	
	f i=1:1:$l(RowIdStr,"^") d
	.s RowId=$p(RowIdStr,"^",i)
	.s Description=$p(DescStr,"^",i)
	.d OutPutPersonFileTypeRow
	Quit $$$OK
OutPutPersonFileTypeRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	盘点损益原因
/// Creater:	lihui
/// CreateDate:	20201221
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetStktkReason")
Query GetStktkReason(Params = "") As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetStktkReasonExecute(ByRef qHandle As %Binary, Params = "") As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJObj.%Get("BDPHospital") ;选择的医院ID
	s Type=PJObj.%Get("Type") ;
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "SELECT ISR_RowId AS RowId, ISR_Code AS Code, ISR_Desc AS Description, ISR_Type FROM DHC_InStktkReason WHERE ISR_Type='"_Type_"'"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_InStktkReason",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description = Result.Data("Description")
		d OutPutStktkReasonRow
	}
	d Result.Close()
	Quit $$$OK
OutPutStktkReasonRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	获取顶层类组
/// Creator:	wangjiabin
/// CreateDate:	2020-12-28
/// Return：	
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetTopScg")
Query GetTopScg() As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetTopScgExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s StkType=..sssCode()
	s ScgId=0
	f  s ScgId=$o(^DHCSCG(ScgId)) q:ScgId=""  d
	.q:+ScgId'>0
	.s ScgType=$p(^DHCSCG(ScgId),"^",3)
	.s ParScg=$p(^DHCSCG(ScgId),"^",4)
	.q:ScgType'=StkType
	.q:ParScg'=""
	.s ScgDesc=$p(^DHCSCG(ScgId),"^",2)
	.d OutPutTopScgRow
	Quit $$$OK
OutPutTopScgRow
	s Data=$lb(ScgId,ScgDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	卡类型
/// Creator:	lxt
/// CreateDate:	2021-3-16
/// Return：	
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetCardType")
Query GetCardType() As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description,Default") [ SqlProc ]
{
}

ClassMethod GetCardTypeExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s TypeID=0
	f  s TypeID=$o(^DHCCARDTYPEDef(TypeID)) q:(TypeID="")  d
	.s TypeDesc=$p(^DHCCARDTYPEDef(TypeID),"^", 2)
	.s ActiveFlag=$p(^DHCCARDTYPEDef(TypeID),"^", 11)
	.q:(ActiveFlag'="IE")
	.s DateTo=+$p(^DHCCARDTYPEDef(TypeID),"^", 10)
	.q:((+DateTo'=0)&(DateTo<+$h))	;失效日
	.s DateFrom=+$p(^DHCCARDTYPEDef(TypeID),"^", 9)
	.q:((+DateFrom'=0)&(DateFrom>+$h))	;生效日
	.s DefaultFlag=$p(^DHCCARDTYPEDef(TypeID),"^", 8)
	.d OutPutCardTypeRow
	Quit $$$OK
OutPutCardTypeRow
	s Data=$lb(TypeID,TypeDesc,DefaultFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	病区类科室
/// Creator:	lxt
/// CreateDate:	2021-3-16
/// Return：	
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetWardLoc","{""gUserId"":""6423"",""gLocId"":""264"",""gGroupId"":""277"",""gHospId"":""10""}")
Query GetWardLoc(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetWardLocExecute(ByRef qHandle As %Binary, Params) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJObj.%Get("BDPHospital") ;选择的医院ID
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	
	s Date=+$h
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr="SELECT CTLOC_RowID AS RowId,CTLOC_Desc AS Description FROM CT_Loc WHERE CTLOC_Type='W'"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Description = Result.Data("Description")
		continue:##class(web.DHCSTMHUI.CTLOC).LocOfHosp(RowId,pHospId)'=0
		s WardId=$o(^PAWARD(0,"WARD_LocationDR",RowId,""))
		continue:WardId=""
		s FromDate=$p(^CTLOC(RowId),"^",24)
		s ToDate=$p(^CTLOC(RowId),"^",25)
		continue:(ToDate'="")&&(Date>ToDate)
		continue:(FromDate'="")&&(Date<FromDate)
		s Description=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(Description)
		d OutPutWardRow
	}
	Quit $$$OK
OutPutWardRow
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	打印规则
/// Creater:	zx
/// CreateDate:	2021-10-8
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetPrintRules")
Query GetPrintRules() As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Code,Description") [ SqlProc ]
{
}

ClassMethod GetPrintRulesExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	 
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	s SqlStr = "select MATPR_RowId AS RowId, MATPR_Code AS Code, MATPR_Desc AS Description from MAT_PrintRules"
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s Code = Result.Data("Code")
		s Description = Result.Data("Description")
		d OutPutPrintRulesRow
	}
	d Result.Close()
	Quit $$$OK
OutPutPrintRulesRow
	s Data=$lb(RowId,Code,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	带量采购编号
/// Creater:	wxj
/// CreateDate:	20220222
/// Table: 
/// Input: 
/// Output:
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetPurInfo")
Query GetPurInfo() As web.DHCSTMHUI.Query(ROWSPEC = "RowId:%Integer,Description,PurTypeId,PurType,PurStartDate,PurEndDate,PurQty:%Float,PurCompletedQty:%Float,PurDesc") [ SqlProc ]
{
}

ClassMethod GetPurInfoExecute(ByRef qHandle As %Binary) As %Status
{
	
	n (qHandle,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s RowId=0
	f  s RowId=$o(^CT.HRP.MAT.PurchaseInfoD(RowId)) q:RowId=""  d
	.s PurInfo=^CT.HRP.MAT.PurchaseInfoD(RowId)
	.s PurTypeId=$lg(PurInfo,3)
	.s:PurTypeId'="" PurType=$lg(^CT.HRP.MAT.ComDictValueD(PurTypeId),4)
	.s PurNo=$lg(PurInfo,4)
	.s PurStartDate=$lg(PurInfo,5)
	.s PurEndDate=$lg(PurInfo,6)
	.s PurQty=$lg(PurInfo,7)
	.s PurCompletedQty=$lg(PurInfo,8)
	.s PurDesc=$lg(PurInfo,9)
	.s PurStartDate=..DL2H(PurStartDate)
	.s PurEndDate=..DL2H(PurEndDate)
	.d OutPutPurInfo
	Quit $$$OK
OutPutPurInfo
	s Data=$lb(RowId,PurNo,PurTypeId,PurType,PurStartDate,PurEndDate,PurQty,PurCompletedQty,PurDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	公共字典类型值
/// Creater:	lxt
/// CreateDate:	20230216
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Common.Dicts","GetDictVal")
Query GetDictVal(Params) As web.DHCSTMHUI.Query(ROWSPEC = "RowId,Description") [ SqlProc ]
{
}

ClassMethod GetDictValExecute(ByRef qHandle As %Binary, Params) As %Status
{
	
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s gHospId=PJObj.%Get("gHospId") ;登陆医院ID
	s pHospId=PJObj.%Get("BDPHospital") ;选择的医院ID
	s pType=PJObj.%Get("Type")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	q:pType="" $$$OK
	
	s SqlStr="SELECT ID,ComDI_ValDesc "
		_" FROM CT_HRP_MAT.ComDictValue WHERE ComDI_ValType='"_pType_"'"
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	s sc=Result.Execute()
	i $$$ISERR(sc) q $$$OK
	While(Result.Next())
	{
		s RowId = Result.Data("ID")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("CT_HRP_MAT.ComDictValue",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s Description=Result.Data("ComDI_ValDesc")
		d OutPutDictVal
	}
	Quit $$$OK
OutPutDictVal
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
