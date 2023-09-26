Import sqluser

/// Descript:	供应商科室授权
/// Creater:	wxj
/// CreateDate:	2022-12-01
Class web.DHCSTMHUI.ApcVenLoc Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	获取科室信息
/// Creater:	wxj
/// CreateDate:	2022-12-01
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.ApcVenLoc","GeLoc","{""gUserId"":""4668"",""gLocId"":""392"",""gGroupId"":""264"",""gHospId"":""2""}","")
Query GeLoc(Params As %String) As Query(ROWSPEC = "LocId,LocCode,LocDesc") [ SqlProc ]
{
}

ClassMethod GeLocExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	 
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s pLocName=PJobj.%Get("LocName")
	s pLocName=$$ALPHAUP^SSUTIL4(pLocName)
	s gHospId=PJobj.%Get("gHospId")
	s pHospId=PJobj.%Get("BDPHospital")
	s pGroupId=PJobj.%Get("GroupId")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	i pGroupId'="" d
	.s SqlStr= "SELECT ST_CTLOC_DR AS LocId,ST_CTLOC_DR->CTLOC_Code AS LocCode,ST_CTLOC_DR->CTLOC_DESC AS LocDesc FROM SS_GroupStockLocations"_" WHERE ST_ParRef='"_pGroupId_"'"
	.i pLocName'="" d
	..s SqlStr=SqlStr_" and( %ALPHAUP(ST_CTLOC_DR->CTLOC_Desc) like '%"_pLocName_"%' or %ALPHAUP(ST_CTLOC_DR->CTLOC_Code) like '%"_pLocName_"%' or %ALPHAUP(ST_CTLOC_DR->CTLOC_ContactName) like '%"_pLocName_"%')"
	e  d
	.s SqlStr="select CTLOC_RowId as LocId,CTLOC_Code as LocCode,CTLOC_Desc LocDesc from CT_Loc where 1=1"
	.i pLocName'="" d
	..s SqlStr=SqlStr_" and( %ALPHAUP(CTLOC_Desc) like '%"_pLocName_"%' or %ALPHAUP(CTLOC_Code) like '%"_pLocName_"%' or %ALPHAUP(CTLOC_ContactName) like '%"_pLocName_"%')"
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	s sc=Result.Execute()
	s err=$$$ISERR(sc)
	If err  q $$$OK
	While(Result.Next())
	{	
		s LocId = Result.Data("LocId")
		s ret=##class(web.DHCSTMHUI.CTLOC).LocOfHosp(LocId, pHospId)
		continue:(ret'=0)
		s LocCode = Result.Data("LocCode")
		s LocDesc = Result.Data("LocDesc")
		d OutPutLocRow
	}
	Quit $$$OK
OutPutLocRow
	s Data=$lb(LocId,LocCode,LocDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	获取供应商
/// Creater:	wxj
/// CreateDate:	2022-12-01
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.ApcVenLoc","GetVendor","{""Status"":""A"",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""MENUID"":""60015"",""VendorDesc"":""新疆博泰"",""BDPHospital"":""2"",""LocId"":""2"",""LinkFlag"":""N""}")
Query GetVendor(Params As %String) As Query(ROWSPEC = "RowId:%Integer,LinkId:%Integer,VendorCode,VendorDesc") [ SqlProc ]
{
}

ClassMethod GetVendorExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s ^tempxj=Params
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s pLocId=PJObj.%Get("LocId")
	s pVendorDesc=PJObj.%Get("VendorDesc")
	s pStatus=PJObj.%Get("Status")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pLink=PJObj.%Get("LinkFlag")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s VendorByHosp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTCOMMONM","VendorByHosp","")	//是否按医院过滤供应商
	s StkType=..sssCode()
	s SqlStr="SELECT APCVM_RowId, APCVM_Code, APCVM_Name,APCVM_Status,APCVM_Type"
		_" FROM SQLUser.APC_Vendor"
		_" WHERE APCVM_Status='A'"
	i pVendorDesc'="" d
	.s pVendorDesc=$$ALPHAUP^SSUTIL4(pVendorDesc)
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("APCVM_RowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("APC_Vendor",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s STV=$o(^DHCSTV(0,RowId,0))
		s Type=xrs.Data("APCVM_Type")
		CONTINUE:Type'=StkType
		s LinkId=..GetLinkRowId(RowId,pLocId)
		CONTINUE:(pLink'="Y")&&(LinkId'="")
		CONTINUE:(pLink="Y")&&(LinkId="")
		s VendorCode=xrs.Data("APCVM_Code")
		s VendorDesc=xrs.Data("APCVM_Name")
		s STVAlias=$p(^DHCSTV(STV),"^",46)
		CONTINUE:(pVendorDesc'="")&&(($$ALPHAUP^SSUTIL4(VendorDesc)'[pVendorDesc)
			&&($$ALPHAUP^SSUTIL4(VendorCode)'[pVendorDesc)
			&&($$ALPHAUP^SSUTIL4(STVAlias)'[pVendorDesc))
		d OutPutVenRow 
	}
	d xrs.Close()
	Quit $$$OK
OutPutVenRow
	s Data=$lb(RowId,LinkId,VendorCode,VendorDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	获取供应商科室关联表ID
/// Creater:	wxj
/// CreateDate:	2022-12-01
/// Table:		DHC_ApcCatGroup
/// Input:		供应商ID,科室ID
/// Return:		供应商科室关联表ID
/// w ##class(web.DHCSTMHUI.ApcVenLoc).GetLinkRowId(1,2)
ClassMethod GetLinkRowId(VendorId As %String, LocId As %String) As %Library.String
{
    n (VendorId,LocId)
    q:(VendorId="")||(LocId="") ""
    s LinkId=""
    s RowId=""
    f  s RowId=$o(^DHCACG(0,"APCVM",VendorId,RowId)) q:(RowId="")||(LinkId'="")  d
    .s LinkLocId=$p(^DHCACG(RowId),"^",4)
    .s:LinkLocId=LocId LinkId=RowId
    q LinkId
}

/// Descript:	保存供应商科室授权
/// Creater:	wxj
/// CreateDate:	2022-12-01
/// Table:		DHC_ApcCatGroup
/// w ##class(web.DHCSTMHUI.ApcVenLoc).jsSave(1,"[{""RowId"":""1"",""LinkId"":"""",""VendorCode"":""AM00001"",""VendorDesc"":""44江苏润辉康尔医疗器械有限公司""}]")
ClassMethod jsSave(LocId As %String, VenStr As %String) As %String
{
	n (LocId,VenStr)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(VenStr)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	ts
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s VendorId=Obj.%Get("RowId")
		s RtnObj=..Save(VendorId,LocId)
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tcommit
	q RtnObj.Json()
}

/// Descript:	保存供应商科室授权
/// Creater:	wxj
/// CreateDate:	2022-12-01
/// Table:		DHC_ApcCatGroup
/// 
ClassMethod Save(VendorId As %String, LocId As %String) As RtnObj
{
	n (VendorId,LocId)
	s RtnObj=##class(RtnObj).%New()
	i VendorId="" q RtnObj.Err(-1,VendorId,"供应商Id不能为空!")
	i LocId="" q RtnObj.Err(-1,LocId,"科室Id不能为空!")
	s RowId=""
	&sql(select ACG_RowId into:RowId from SQLUser.DHC_ApcCatGroup where ACG_APCVM_Dr=:VendorId and ACG_Loc_DR=:LocId)
	i RowId'="" q RtnObj.Err(-2,"","供应商科室已关联，无需重复授权!")
	&sql(insert into SQLUser.DHC_ApcCatGroup (ACG_APCVM_Dr, ACG_Loc_DR, ACG_UseFlag)
		values (:VendorId,:LocId,'Y'))
	i SQLCODE'=0 q RtnObj.Err(-3,Vendor,Vendor_"科室授权失败!")
	q RtnObj
}

/// Descript:	删除供应商科室授权
/// Creater:	wxj
/// CreateDate:	2022-12-01
/// Table:		DHC_ApcCatGroup
/// w ##class(web.DHCSTMHUI.ApcVenLoc).jsSave()
ClassMethod jsDelete(LinkIdStr As %String) As %String
{
	n (LinkIdStr)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(LinkIdStr)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	ts
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s LinkId=Obj.%Get("LinkId")
		s RtnObj=..Delete(LinkId)
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tcommit
	q RtnObj.Json()
}

/// Descript:	删除供应商科室授权
/// Creater:	wxj
/// CreateDate:	2022-12-01
/// Table:		DHC_ApcCatGroup
ClassMethod Delete(LinkId As %String) As RtnObj
{
	n (LinkId)
	s RtnObj=##class(RtnObj).%New()
	i LinkId="" q RtnObj.Err(-1,LinkId,"入参不能为空!")
	&sql(Delete from DHC_ApcCatGroup where ACG_RowId=:LinkId) 
	i SQLCODE'=0 q RtnObj.Err(-2,"","取消授权失败!")
	q RtnObj
}

}
