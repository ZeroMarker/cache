Import sqluser

/// Descript:	配送商科室授权
/// Creater:	wxj
/// CreateDate:	2022-12-05
Class web.DHCSTMHUI.CarrierLoc Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	获取科室信息
/// Creater:	wxj
/// CreateDate:	2022-12-01
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.CarrierLoc","GeLoc","{""gUserId"":""4668"",""gLocId"":""392"",""gGroupId"":""264"",""gHospId"":""2""}","")
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

/// Descript:	获取配送商
/// Creater:	wxj
/// CreateDate:	2022-12-05
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.CarrierLoc","GetCarrier","{""Description"":""gy"",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""MENUID"":""60016"",""BDPHospital"":""2"",""LocId"":""1"",""LinkFlag"":""N""}")
Query GetCarrier(Params As %String) As Query(ROWSPEC = "RowId:%Integer,LinkId:%Integer,CarrierCode,CarrierDesc") [ SqlProc ]
{
}

ClassMethod GetCarrierExecute(ByRef qHandle As %Binary, Params As %String) As %Status
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
	s pDesc=PJObj.%Get("Description")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pLink=PJObj.%Get("LinkFlag")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s Type=..sssCode()
	s SqlStr="SELECT CA_Rowid, CA_Code, CA_Desc"
		_" FROM SQLUser.DHC_Carrier"
		_" WHERE CA_Type = '"_Type_"'"
	i pDesc'="" d
	.s pDesc=$$ALPHAUP^SSUTIL4(pDesc)
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(SqlStr)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s RowId=xrs.Data("CA_Rowid")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_Carrier",RowId,pHospId)
		continue:ShowDataFlag'="Y"
		s LinkId=..GetLinkRowId(RowId,pLocId)
		CONTINUE:(pLink'="Y")&&(LinkId'="")
		CONTINUE:(pLink="Y")&&(LinkId="")
		s CarrierCode=xrs.Data("CA_Code")
		s CarrierDesc=xrs.Data("CA_Desc")
		s Alias=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(CarrierDesc,4)
		CONTINUE:(pDesc'="")&&(($$ALPHAUP^SSUTIL4(CarrierDesc)'[pDesc)
			&&($$ALPHAUP^SSUTIL4(CarrierCode)'[pDesc)
			&&($$ALPHAUP^SSUTIL4(Alias)'[pDesc))
		d OutPutRow 
	}
	d xrs.Close()
	Quit $$$OK
OutPutRow
	s Data=$lb(RowId,LinkId,CarrierCode,CarrierDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	获取配送商科室关联表ID
/// Creater:	wxj
/// CreateDate:	2022-12-01
/// Table:		CF_HRP_MAT.CarrierLoc
/// Input:		供应商ID,科室ID
/// Return:		供应商科室关联表ID
/// w ##class(web.DHCSTMHUI.CarrierLoc).GetLinkRowId(1,2)
ClassMethod GetLinkRowId(CarrierId As %String, LocId As %String) As %Library.String
{
    n (CarrierId,LocId)
    q:(CarrierId="")||(LocId="") ""
    s LinkId=""
    s RowId=""
    f  s RowId=$o(^CF.HRP.MAT.CarrierLocI("Carrier",CarrierId,RowId)) q:(RowId="")||(LinkId'="")  d
    .s LinkLocId=$lg(^CF.HRP.MAT.CarrierLocD(RowId),5)
    .s:LinkLocId=LocId LinkId=RowId
    q LinkId
}

/// Descript:	保存配送商科室授权
/// Creater:	wxj
/// CreateDate:	2022-12-05
/// Table:		CF_HRP_MAT.CarrierLoc
/// w ##class(web.DHCSTMHUI.CarrierLoc).jsSave()
ClassMethod jsSave(LocId As %String, CarrierStr As %String) As %String
{
	n (LocId,CarrierStr)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(CarrierStr)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	ts
	while(RtnObj.success=0)
	{
		s Obj=PJObj.%Pop()
		q:Obj=""
		s CarrierId=Obj.%Get("RowId")
		s RtnObj=..Save(CarrierId,LocId)
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tcommit
	q RtnObj.Json()
}

/// Descript:	保存配送商科室授权
/// Creater:	wxj
/// CreateDate:	2022-12-05
/// Table:		CF_HRP_MAT.CarrierLoc
/// 
ClassMethod Save(CarrierId As %String, LocId As %String) As RtnObj
{
	n (CarrierId,LocId)
	s RtnObj=##class(RtnObj).%New()
	i CarrierId="" q RtnObj.Err(-1,CarrierId,"配送商Id不能为空!")
	i LocId="" q RtnObj.Err(-1,LocId,"科室Id不能为空!")
	s RowId=""
	&sql(select %Id into:RowId from CF_HRP_MAT.CarrierLoc where MCT_Carrier_DR=:CarrierId and MCT_Loc_DR=:LocId)
	i RowId'="" q RtnObj.Err(-2,"","供应商科室已关联，无需重复授权!")
	&sql(insert into CF_HRP_MAT.CarrierLoc (MCT_Carrier_DR, MCT_Loc_DR, MCT_UseFlag)
		values (:CarrierId,:LocId,'Y'))
	i SQLCODE'=0 q RtnObj.Err(-3,CarrierId,CarrierId_"科室授权失败!")
	q RtnObj
}

/// Descript:	删除配送商科室授权
/// Creater:	wxj
/// CreateDate:	2022-12-05
/// Table:		CF_HRP_MAT.CarrierLoc
/// w ##class(web.DHCSTMHUI.CarrierLoc).jsDelete()
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

/// Descript:	删除配送商科室授权
/// Creater:	wxj
/// CreateDate:	2022-12-05
/// Table:		CF_HRP_MAT.CarrierLoc
ClassMethod Delete(LinkId As %String) As RtnObj
{
	n (LinkId)
	s RtnObj=##class(RtnObj).%New()
	i LinkId="" q RtnObj.Err(-1,LinkId,"入参不能为空!")
	&sql(Delete from CF_HRP_MAT.CarrierLoc where %Id=:LinkId) 
	i SQLCODE'=0 q RtnObj.Err(-2,"","取消授权失败!")
	q RtnObj
}

}
