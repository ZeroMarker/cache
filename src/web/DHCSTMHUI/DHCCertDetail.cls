Import sqluser

/// Description:资质相关处理(供应商,生产厂家等)
/// CreateDate:	2019-12-24
Class web.DHCSTMHUI.DHCCertDetail Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询证件类型
/// Creator:	lxt
/// CreateDate:	2020-8-18
/// Table:		DHC_CertDetail
/// Input:		类型，查询条件
/// Return：	资质
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCCertDetail","QueryCertDetail",^templxt("QueryCertDetail"))
Query QueryCertDetail(Params As %String) As Query(ROWSPEC = "RowId,OrgId,OrgType,CertType,CertTypeDesc,CertText,CertIssuedDept,CertIssuedDate,CertDateFrom,CertDateTo,CertBlankedFlag,CertDelayFlag,CertDelayDateTo,CertShowFlag,CertNum:%Float") [ SqlProc ]
{
}

ClassMethod QueryCertDetailExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)

	s pOrgType=PJObj.%Get("OrgType")	//Vendor,Manf
	s pOrgId=PJObj.%Get("OrgId")		//VendorId,ManfId
	q:pOrgType="" $$$OK
	q:pOrgId="" $$$OK
	s HospId=PJObj.%Get("HospId")

	s SqlStr = "SELECT ID AS RowId,CERT_OrgId AS OrgId,CERT_OrgType AS OrgType,Cert_Type AS CertType,"
		_"Cert_Text AS CertText,Cert_IssuedDept AS CertIssuedDept,Cert_IssuedDate AS CertIssuedDate,"
		_"Cert_DateFrom AS CertDateFrom,Cert_DateTo AS CertDateTo,Cert_BlankedFlag AS CertBlankedFlag,"
		_"Cert_DelayFlag AS CertDelayFlag,Cert_DelayDateTo AS CertDelayDateTo, Cert_ShowFlag AS CertShowFlag,"
		_"(select CT_Num from DHC_CertType where CT_Type='"_pOrgType_"' and CT_Code=DHC_CertDetail.Cert_Type) as CertNum "
 		_"FROM DHC_CertDetail where CERT_OrgId="_pOrgId_" and CERT_OrgType='"_pOrgType_"' order by CertNum asc"
	
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	s sc=Result.Execute()
	i $$$ISERR(sc) q $$$OK
	While(Result.Next())
	{
		s RowId = Result.Data("RowId")
		s OrgId = Result.Data("OrgId")
		s OrgType = Result.Data("OrgType")
		s CertType=Result.Data("CertType")
		s CertTypeDesc=..GetCertName(OrgType,CertType,HospId)
		s:CertTypeDesc="" CertTypeDesc=CertType
		s CertText=Result.Data("CertText")
		s CertIssuedDept=Result.Data("CertIssuedDept")
		s CertIssuedDate=Result.Data("CertIssuedDate")
		s CertDateFrom=Result.Data("CertDateFrom")
		s CertDateTo=Result.Data("CertDateTo")
		s CertBlankedFlag=Result.Data("CertBlankedFlag")
		s CertDelayFlag=Result.Data("CertDelayFlag")
		s CertDelayDateTo=Result.Data("CertDelayDateTo")
		s CertShowFlag=Result.Data("CertShowFlag")
		
		i CertBlankedFlag="" s CertBlankedFlag="N"
		i CertDelayFlag="" s CertDelayFlag="N"
		i CertShowFlag="" s CertShowFlag="N"
		s CertNum=Result.Data("CertNum")
		s CertIssuedDate=..DL2H(CertIssuedDate)
		s CertDateFrom=..DL2H(CertDateFrom)
		s CertDateTo=..DL2H(CertDateTo)
		s CertDelayDateTo=..DL2H(CertDelayDateTo)
		d OutPutRow1
	}
	Quit $$$OK
OutPutRow1
	s Data=$lb(RowId,OrgId,OrgType,CertType,CertTypeDesc,CertText,CertIssuedDept,CertIssuedDate,
	CertDateFrom,CertDateTo,CertBlankedFlag,CertDelayFlag,CertDelayDateTo,CertShowFlag,CertNum)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	查询资质信息
/// Creator:	lxt
/// CreateDate:	2020-8-18
/// Table:		DHC_CertDetail
/// Input:		资质id
/// Return：	资质
/// w ##class(web.DHCSTMHUI.DHCCertDetail).Select(18)
ClassMethod Select(Params As %String) As %String
{
	n (Params)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)

	s CertId=PJObj.%Get("CertId")
	s HospId=PJObj.%Get("HospId")
	q:+CertId=0 ""
	
	s CertDetail=^User.DHCCertDetailD(CertId)
	s CERTRowId=CertId
	s OrgType=$lg(CertDetail,3)
	s CERTTypeCode=$lg(CertDetail,4)
	s CERTTypeDesc=..GetCertName(OrgType,CERTTypeCode,HospId)
	s CERTText=$lg(CertDetail,6)
	s CERTDateFrom=$lg(CertDetail,14)
	s CERTDateTo=$lg(CertDetail,9)
	s CERTIssuedDept=$lg(CertDetail,7)
	s CERTIssuedDate=$lg(CertDetail,8)
	s CERTBlankedFlag=$lg(CertDetail,10)
	s CERTDelayFlag=$lg(CertDetail,11)
	s CERTDelayDateTo=$lg(CertDetail,12)
	s CERTShowFlag=$lg(CertDetail,15)
	
	s CERTIssuedDate=..DL2H(CERTIssuedDate)
	s CERTDateFrom=..DL2H(CERTDateFrom)
	s CERTDateTo=..DL2H(CERTDateTo)
	s CERTDelayDateTo=..DL2H(CERTDelayDateTo)
	s CERTType=..sssComboStr(CERTTypeCode,CERTTypeDesc)
	
	s Data=CERTRowId_"^"_CERTTypeCode_"^"_CERTTypeDesc_"^"_CERTType_"^"_CERTText_"^"_CERTDateFrom
	_"^"_CERTDateTo_"^"_CERTIssuedDept_"^"_CERTIssuedDate_"^"_CERTBlankedFlag
	_"^"_CERTDelayFlag_"^"_CERTDelayDateTo_"^"_CERTShowFlag

	s Title="CERTRowId^CERTTypeCode^CERTTypeDesc^CERTType^CERTText^CERTDateFrom"
	_"^CERTDateTo^CERTIssuedDept^CERTIssuedDate^CERTBlankedFlag"
	_"^CERTDelayFlag^CERTDelayDateTo^CERTShowFlag"

	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

/// w ##class(web.DHCSTMHUI.DHCCertDetail).SaveCertDetailList()
/// lihui 20200908 
/// 导入数据调用
/// CERTParams: 字符串,形如[{CertType:***,CertText:***,...},{...},{...},...]
ClassMethod SaveCertDetailList(OrgType, OrgId, CERTParams) As RtnObj
{
	n (OrgType,OrgId,CERTParams)
	s RtnObj=##class(RtnObj).%New()
	i (OrgType="")||(OrgId="") q RtnObj.Err(-1,"","入参必填项错误!")
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(CERTParams)
	i Sc'=0 q RtnObj.Err(-2,"","入参解析失败!")
	s CertIdStr=""
	While (RtnObj.success=0) {
		s CERTObj=PJObj.%Pop()
		q:CERTObj=""
		s CERTType=CERTObj.%Get("CERTType")
		s CERTRowId=CERTObj.%Get("CERTRowId")
		s CERTText=CERTObj.%Get("CERTText")
		s CERTIssuedDept=CERTObj.%Get("CERTIssuedDept")
		s CERTIssuedDate=CERTObj.%Get("CERTIssuedDate")
		s CERTDateFrom=CERTObj.%Get("CERTDateFrom")
		s CERTDateTo=CERTObj.%Get("CERTDateTo")
		s CERTBlankedFlag=CERTObj.%Get("CERTBlankedFlag")
		s CERTDelayFlag=CERTObj.%Get("CERTDelayFlag")
		s CERTDelayDateTo=CERTObj.%Get("CERTDelayDateTo")
		s CERTShowFlag=CERTObj.%Get("CERTShowFlag")
		s HospId=CERTObj.%Get("HospId")
		s CertId=""
		&sql(SELECT ID INTO :CertId FROM DHC_CertDetail WHERE CERT_OrgId=:OrgId AND CERT_OrgType=:OrgType AND CERT_Type=:CERTType)
		i 'SQLCODE  s CERTRowId=CertId
		s Data=CERTType_"^"_CERTRowId_"^"_CERTText_"^"_CERTIssuedDept_"^"_CERTIssuedDate_"^"_CERTDateFrom_"^"_CERTDateTo_"^"_CERTBlankedFlag_"^"_CERTDelayFlag_"^"_CERTDelayDateTo_"^"_CERTShowFlag_"^"_HospId
		s Title="CERTType^CERTRowId^CERTText^CERTIssuedDept^CERTIssuedDate^CERTDateFrom^CERTDateTo^CERTBlankedFlag^CERTDelayFlag^CERTDelayDateTo^CERTShowFlag^HospId"
		s Obj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
		s RtnObj=..SaveCertDetail(OrgType,OrgId,Obj)
		continue:RtnObj.success'=0
		s CertId=RtnObj.rowid
		i CertIdStr="" s CertIdStr=CertId
		e  s CertIdStr=CertIdStr_","_CertId
	}
	s RtnObj.rowid=CertIdStr
	q RtnObj
}

/// Descript:	新增资质
/// 对象类型数据
/// w ##class(web.DHCSTMHUI.DHCCertDetail).jsSaveCertDetail("Vendor","1","{""CERTType"":""insBusLic"",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""CERTShowFlag"":""Y"",""CERTBlankedFlag"":"""",""CERTRowId"":""368"",""CERTText"":""234234234234234234234"",""CERTDateFrom"":"""",""CERTDateTo"":"""",""CERTIssuedDept"":"""",""CERTIssuedDate"":"""",""CERTDelayDateTo"":"""",""HospId"":""2""}")
ClassMethod jsSaveCertDetail(OrgType As %String, OrgId As %String, CERTParams As %String) As %String
{
	n (OrgType,OrgId,CERTParams,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..SaveCertDetail(OrgType,OrgId,CERTParams)
	q RtnObj.Json()
}

/// w ##class(web.DHCSTMHUI.DHCCertDetail).SaveCertDetail()
/// CERTParams: 字符串,形如[{CertType:***,CertText:***,...},{...},{...},...]
ClassMethod SaveCertDetail(OrgType, OrgId, CERTParams) As RtnObj
{
	n (OrgType,OrgId,CERTParams,%session)
	d ..sssSetLogID()
	s RtnObj=##class(RtnObj).%New()
	i (OrgType="")||(OrgId="") q RtnObj.Err(-1,"","入参必填项错误!")
	
	s CERTObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=CERTObj.%FromJSON(CERTParams)
	i Sc'=0 q RtnObj.Err(-2,"","入参解析失败!")
		
	s CERTType=CERTObj.%Get("CERTType")
	i (CERTType="") q RtnObj.Err(-3,"","资质类型必填项错误!")
	
	s HospId=CERTObj.%Get("HospId")
	s CERTName=..GetCertName(OrgType,CERTType,HospId)
	s CERTRowId=CERTObj.%Get("CERTRowId")
	s CERTText=CERTObj.%Get("CERTText")
	s CERTIssuedDept=CERTObj.%Get("CERTIssuedDept")
	s CERTIssuedDate=CERTObj.%Get("CERTIssuedDate")
	s CERTDateFrom=CERTObj.%Get("CERTDateFrom")
	s CERTDateTo=CERTObj.%Get("CERTDateTo")
	s CERTBlankedFlag=CERTObj.%Get("CERTBlankedFlag")
	s CERTDelayFlag=CERTObj.%Get("CERTDelayFlag")
	s CERTDelayDateTo=CERTObj.%Get("CERTDelayDateTo")
	s CERTShowFlag=CERTObj.%Get("CERTShowFlag")
	s CERTIssuedDate=..DH2L(CERTIssuedDate)
	s CERTDateFrom=..DH2L(CERTDateFrom)
	s CERTDateTo=..DH2L(CERTDateTo)
	s CERTDelayDateTo=..DH2L(CERTDelayDateTo)
	
	s Rowid=""
	&sql(select ID into :Rowid from DHC_CertDetail where 
	CERT_OrgType=:OrgType and CERT_OrgId=:OrgId and CERT_Type=:CERTType and CERT_Text=:CERTText)
	q:('SQLCODE)&&(Rowid'=CERTRowId) RtnObj.Err(-3,"","当前证件编号已经存在！","",0)
	ts
	i CERTRowId="" d
	.s Obj=##class(User.DHCCertDetail).%New()
	.s Obj.CERTOrgType=OrgType
	.s Obj.CERTOrgId=OrgId
	.s Obj.CERTType=CERTType
	.s OldJsonStr=""
	.s LogType="A"
	e  d
	.s Obj=##class(User.DHCCertDetail).%OpenId(CERTRowId)
	.s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_CertDetail",CERTRowId)
	.s LogType="U"
	s Obj.CERTName=CERTName
	s Obj.CERTText=CERTText
	s Obj.CERTIssuedDept=CERTIssuedDept
	s Obj.CERTIssuedDate=CERTIssuedDate
	s Obj.CERTDateFrom=CERTDateFrom
	s Obj.CERTDateTo=CERTDateTo
	s Obj.CERTBlankedFlag=CERTBlankedFlag
	s Obj.CERTDelayFlag=CERTDelayFlag
	s Obj.CERTDelayDateTo=CERTDelayDateTo
	s Obj.CERTShowFlag=CERTShowFlag
	s Sc=Obj.%Save()
	i $$$ISERR(Sc) tro 1  q RtnObj.Err(-10,"","资质保存失败!")
	s CertId=Obj.%Id()
	
	s FileData=OrgType_"^"_OrgId_"^"_"Cert"_"^"_CERTType_"^"_CertId_"^"_CERTShowFlag
	s FileTitle="OrgType^OrgId^GrpType^PointerType^Pointer^ActiveFlag"
	s FileObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(FileData,FileTitle)
	s RtnObj=##class(web.DHCSTMHUI.UpLoadPic).UpdateFileActiveFlag(FileObj)
	i RtnObj.success'=0 tro 1  q RtnObj
	
	s RtnObj=##class(Log).SaveLog("DHC_CertDetail","User.DHCCertDetail","资质信息表",CertId,CERTName,LogType,"",OldJsonStr)
	i RtnObj.success'=0 tro 1  q RtnObj
	
	d ..sssKillLogID()
	tc
	s RtnObj.rowid=CertId
	q RtnObj
}

/// 获取资质类型对应的汉字描述
/// OrgType:资质类型
/// CERTType
ClassMethod GetCertName(OrgType, CERTType, HospId = "") As %String
{
	n (OrgType,CERTType,HospId)
	s OrgType=##class(web.DHCSTMHUI.DHCCertType).GetCertTypeShare(OrgType)
	s RowId="",CERTRowId=""
	f  s RowId=$o(^User.DHCCertTypeI("TypeCode",OrgType,CERTType,RowId)) q:(RowId="")||(CERTRowId'="")  d
	.s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_CertType",RowId,HospId)
	.i ShowDataFlag="Y" d
	..s CERTRowId=RowId
	
	q:CERTRowId="" ""
	
	s CERTInfo=^User.DHCCertTypeD(CERTRowId)
	s CERTName=$lg(CERTInfo,5)
	i CERTName="" s CERTName=CERTType
	q CERTName
}

/// 获取资质信息, 用于供应商,生产厂家等位置的界面信息返回
/// w ##class(web.DHCSTMHUI.DHCCertDetail).GetCertDetail("Vendor",2)
ClassMethod GetCertDetail(OrgType, OrgId) As %String
{
	n (OrgType,OrgId)
	
	s CertTypeList=""
	i (OrgType="Vendor") {
		;供应商
		s CertTypeList=$lb("comLic","taxLic","orgCode","insBusLic","agentAuth",
			"vendorAgreement","saleServComm","legalComm","qualityComm"
		)
	}
	i (OrgType="Manf") {
		;生产厂家
		s CertTypeList=$lb("insProLic","comLic","businessRegNo","orgCode","taxLic",
		"insBusLic","properRegform","prodEprsHygLic","GMP","socialCreditCode"
		)
	}
	
	s CertTitleStr=""
	s CertDataStr=""
	f i=1:1:$ll(CertTypeList) d
	.s CertType=$lg(CertTypeList,i)
	.q:CertType=""
	.s CertRowId=$o(^User.DHCCertDetailI("OrgType",OrgType,OrgId,CertType,""),-1)
	.q:CertRowId=""
	.
	.s Obj=##class(User.DHCCertDetail).%OpenId(CertRowId)
	.s CertText=Obj.CERTText
	.s CertIssuedDept=Obj.CERTIssuedDept
	.s CertIssuedDate=Obj.CERTIssuedDate
	.s CertDateTo=Obj.CERTDateTo
	.s CertBlankedFlag=Obj.CERTBlankedFlag
	.s CertDelayFlag=Obj.CERTDelayFlag
	.s CertDelayDateTo=Obj.CERTDelayDateTo
	.
	.s CertIssuedDate=..DL2H(CertIssuedDate)
	.s CertDateTo=..DL2H(CertDateTo)
	.s CertDelayDateTo=..DH2L(CertDelayDateTo)
	.s DataList=$lb(CertRowId,CertText,CertIssuedDept,CertIssuedDate,CertDateTo,CertBlankedFlag,CertDelayFlag,CertDelayDateTo)
	.s CertData=$lts(DataList,"^")
	.i CertDataStr="" s CertDataStr=CertData
	.e  s CertDataStr=CertDataStr_"^"_CertData
	.
	.s TRowId=CertType_"RowId"
	.s TText=CertType_"Text"
	.s TIssuedDept=CertType_"IssuedDept"
	.s TIssuedDate=CertType_"IssuedDate"
	.s TDateTo=CertType_"DateTo"
	.s TBlankedFlag=CertType_"BlankedFlag"
	.s TDelayFlag=CertType_"DelayFlag"
	.s TDelayDateTo=CertType_"DelayDateTo"
	.s TitleList=$lb(TRowId,TText,TIssuedDept,TIssuedDate,TDateTo,TBlankedFlag,TDelayFlag,TDelayDateTo)
	.s CertTitle=$lts(TitleList,"^")
	.i CertTitleStr="" s CertTitleStr=CertTitle
	.e  s CertTitleStr=CertTitleStr_"^"_CertTitle
	
	s Result=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(CertDataStr,CertTitleStr)
	q Result
}

/// Descript:	查询资质信息(物资信息维护界面展示使用)
/// Creator:	lxt
/// CreateDate:	2020-8-18
/// Table:		DHC_CertDetail
/// Input:		资质id
/// Return：	资质
/// w ##class(web.DHCSTMHUI.DHCCertDetail).GetCertInfo("Vendor",654)
ClassMethod GetCertInfo(OrgType, OrgId) As %String
{
	n (OrgType,OrgId)
	q:(OrgType="")||(OrgId="") "{}"
	s CertInfo=..GetCertInfoStr(OrgType,OrgId)
	s CertDataStr=$p(CertInfo,",",1)
	s CertTitleStr=$p(CertInfo,",",2)
	s Result=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(CertDataStr,CertTitleStr)
	q Result
}

/// Descript:	查询资质信息(物资信息维护界面展示使用)
/// Creator:	lxt
/// CreateDate:	2020-8-18
/// Table:		DHC_CertDetail
/// Input:		资质id
/// Return：	资质
/// w ##class(web.DHCSTMHUI.DHCCertDetail).GetCertInfo("Vendor",654)
ClassMethod GetCertInfoStr(OrgType, OrgId) As %String
{
	n (OrgType,OrgId)
	
	s CertTitleStr=""
	s CertDataStr=""
	s CertType=0
	f  s CertType=$o(^User.DHCCertTypeI("TypeCode",OrgType,CertType)) q:(CertType="")  d
	.s CertTypeRowId=$o(^User.DHCCertTypeI("TypeCode",OrgType,CertType,0))
	.s CertInfo=^User.DHCCertTypeD(CertTypeRowId)
	.s ShowFlag=$lg(CertInfo,7)
	.q:ShowFlag'="Y"
	.s CertRowId=$o(^User.DHCCertDetailI("OrgType",OrgType,OrgId,CertType,""),-1)
	.q:CertRowId=""
	.s Obj=##class(User.DHCCertDetail).%OpenId(CertRowId)
	.s CertText=Obj.CERTText
	.s CertIssuedDept=Obj.CERTIssuedDept
	.s CertIssuedDate=Obj.CERTIssuedDate
	.s CertDateFrom=Obj.CERTDateFrom
	.s CertDateTo=Obj.CERTDateTo
	.s CertBlankedFlag=Obj.CERTBlankedFlag
	.s CertDelayFlag=Obj.CERTDelayFlag
	.s CertDelayDateTo=Obj.CERTDelayDateTo
	.s CertShowFlag=Obj.CERTShowFlag
	.q:CertShowFlag'="Y"
	.
	.s CertIssuedDate=..DL2H(CertIssuedDate)
	.s CertDateFrom=..DL2H(CertDateFrom)
	.s CertDateTo=..DL2H(CertDateTo)
	.s CertDelayDateTo=..DH2L(CertDelayDateTo)
	.
	.s DataList=$lb(CertRowId,CertText,CertIssuedDept,CertIssuedDate,CertDateFrom,CertDateTo,CertBlankedFlag,CertDelayFlag,CertDelayDateTo)
	.s CertData=$lts(DataList,"^")
	.i CertDataStr="" s CertDataStr=CertData
	.e  s CertDataStr=CertDataStr_"^"_CertData
	.
	.s TRowId=CertType_"RowId"
	.s TText=CertType_"Text"
	.s TIssuedDept=CertType_"IssuedDept"
	.s TIssuedDate=CertType_"IssuedDate"
	.s TDateFrom=CertType_"DateFrom"
	.s TDateTo=CertType_"DateTo"
	.s TBlankedFlag=CertType_"BlankedFlag"
	.s TDelayFlag=CertType_"DelayFlag"
	.s TDelayDateTo=CertType_"DelayDateTo"
	.s TitleList=$lb(TRowId,TText,TIssuedDept,TIssuedDate,TDateFrom,TDateTo,TBlankedFlag,TDelayFlag,TDelayDateTo)
	.s CertTitle=$lts(TitleList,"^")
	.i CertTitleStr="" s CertTitleStr=CertTitle
	.e  s CertTitleStr=CertTitleStr_"^"_CertTitle
	
	q CertDataStr_","_CertTitleStr
}

/// Descript:	查询资质信息
/// Creator:	lxt
/// CreateDate:	2020-8-18
/// Table:		DHC_CertDetail
/// Input:		资质id
/// Return：	资质
/// w ##class(web.DHCSTMHUI.DHCCertDetail).GetCertDetailInfo("Vendor","781","secondBusLic")
ClassMethod GetCertDetailInfo(OrgType, OrgId, CertType) As %String
{
	n (OrgType,OrgId,CertType)
	q:(OrgType="")||(OrgId="")||(CertType="") ""
	s CertRowId=$o(^User.DHCCertDetailI("OrgType",OrgType,OrgId,CertType,""),-1)
	q:CertRowId="" ""
	s Obj=##class(User.DHCCertDetail).%OpenId(CertRowId)
	s CertShowFlag=Obj.CERTShowFlag
	q:CertShowFlag'="Y" ""
	s CertText=Obj.CERTText
	s CertIssuedDept=Obj.CERTIssuedDept
	s CertIssuedDate=Obj.CERTIssuedDate
	s CertDateFrom=Obj.CERTDateFrom
	s CertDateTo=Obj.CERTDateTo
	s CertBlankedFlag=Obj.CERTBlankedFlag
	s CertDelayFlag=Obj.CERTDelayFlag
	s CertDelayDateTo=Obj.CERTDelayDateTo
	s CertIssuedDate=..DL2H(CertIssuedDate)
	s CertDateFrom=..DL2H(CertDateFrom)
	s CertDateTo=..DL2H(CertDateTo)
	s CertDelayDateTo=..DH2L(CertDelayDateTo)
	s Data=CertText_"^"_CertIssuedDept_"^"_CertIssuedDate_"^"_CertDateFrom_"^"_CertDateTo_"^"_CertBlankedFlag_"^"_CertDelayFlag_"^"_CertDelayDateTo
	
	q Data
}

/// Descript:	根据资质信息获取资质表内数据rowid
/// Creator:	wangjiabin
/// CreateDate:	2020-09-27
/// Table:		DHC_CertDetail
/// Input:		
/// Return：	资质表id
/// w ##class(web.DHCSTMHUI.DHCCertDetail).GetCertId("Vendor",5,"comLic","冀食药监械经营许20200101")
ClassMethod GetCertId(OrgType, OrgId, CertType, CertText) As %String
{
	n (OrgType,OrgId,CertType,CertText)
	q:(OrgType="")||(OrgId="")||(CertType="")||(CertText="") ""
	
	s RowId=""
	s CertRowId=0
	f  s CertRowId=$o(^User.DHCCertDetailI("OrgType",OrgType,OrgId,CertType,CertRowId)) q:(CertRowId="")||(RowId'="")  d
	.s Cert=$lg(^User.DHCCertDetailD(CertRowId),6)
	.i Cert=CertText s RowId=CertRowId q
	
	q RowId
}

/// Description:根据供应商Id,库存项id,生产厂家id判断资质信息
/// Creator:    wangjiabin
/// CreateDate: 2021-08-18
/// Table:
/// Input:		CheckQualParams(供应商id,库存项id,生产厂家id)
/// Output:     Json型数据{Warn: ****, In:***, Out:***, Use: ****}
/// w ##class(web.DHCSTMHUI.DHCCertDetail).Check("{""Vendor"":""7"",""Inci"":""2"",""Manf"":""1174""}")
ClassMethod Check(Params As %String) As %Library.String
{
	n (Params)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!").Json()
	
	s Inci=PJObj.%Get("Inci")
	s Manf=PJObj.%Get("Manf")
	s Vendor=PJObj.%Get("Vendor")
	s Inclb=PJObj.%Get("Inclb")
	s HospId=PJObj.%Get("gHospId")
	i (Inci="")&&(Manf="")&&(Vendor="")&&(Inclb="") q RtnObj.Err(-2,"","入参有误").Json()
	
	i Inclb'="" d
	.s Inci=$p(Inclb,"||",1)
	.s ManfInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
	.s Manf=$p(ManfInfo,"^",1)
	.s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb)
	.s Vendor=$p(VendorInfo,"^",1)
	
	s ControlObj={}
	s ControlList=$lb("Warn","In","Out","Use")
	f i=1:1:$ll(ControlList) {
		s ControlType=$lg(ControlList,i)
		s Str=""
		
		i Inci'="" d
		.s InciRet=##class(web.DHCSTMHUI.DHCCertDetail).CheckInciCertDetail(Inci,Vendor,ControlType,HospId)
		.q:InciRet=""
		.s Str=Str_"  "_"医疗器械["_InciRet_"]"
		
		i (Manf'="") d
		.s ManfRet=##class(web.DHCSTMHUI.DHCCertDetail).CheckCertDetail("Manf",Manf,ControlType,HospId)
		.q:ManfRet=""
		.s Str=Str_"  "_"生产厂家["_ManfRet_"]"
		
		i (Vendor'="") d
		.s VendorRet=##class(web.DHCSTMHUI.DHCCertDetail).CheckCertDetail("Vendor",Vendor,ControlType,HospId)
		.q:VendorRet=""
		.s Str=Str_"  "_"供应商["_VendorRet_"]"
		
		d ControlObj.%Set(ControlType,Str)
	}
	q ControlObj.%ToJSON()
}

/// Descript:	获取过期或即将过期的供应商/生产厂家资质名称(逗号隔开)
/// CreateDate:	2021-07-19
/// Table:		DHC_CertDetail
/// Input:		机构类型(Vendor/Manf/等), 机构id, ControlType:控制类型(Warn/In/Out/Use)
/// Output:		
/// Return:		过期或即将过期的资质名称(逗号隔开)
/// w ##class(web.DHCSTMHUI.DHCCertDetail).CheckCertDetail("Vendor","2","","2")
ClassMethod CheckCertDetail(OrgType As %Integer, OrgId As %String, ControlType As %String = "", HospId As %String = "") As %String
{
	n (OrgType,OrgId,ControlType,HospId)
	q:(OrgType="")||(OrgId="") ""
	s:ControlType="" ControlType="Warn"
	s Str=""
	
	s CERTType=""
	f  s CERTType=$o(^User.DHCCertDetailI("OrgType",OrgType,OrgId,CERTType)) q:CERTType=""  d
	.s CertTypeId=""
	.f  s CertTypeId=$o(^User.DHCCertTypeI("TypeCode",OrgType,CERTType,CertTypeId)) q:CertTypeId=""  d
	..s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_CertType",CertTypeId,HospId)
	..q:ShowDataFlag'="Y"
	..s CertTypeInfo=$g(^User.DHCCertTypeD(CertTypeId))
	..s TypeName=$lg(CertTypeInfo,4)
	..s TypeFlag=$lg(CertTypeInfo,7)
	..s WarnDays=$lg(CertTypeInfo,8)
	..s ControlInDays=$lg(CertTypeInfo,9)
	..s ControlOutDays=$lg(CertTypeInfo,10)
	..s ControlUseDays=$lg(CertTypeInfo,11)
	..q:TypeFlag'="Y"
	..
	..;判断最后一条资质
	..s CERTRowid=$o(^User.DHCCertDetailI("OrgType",OrgType,OrgId,CERTType,""),-1)
	..q:CERTRowid=""
	..
	..s CertDetail=^User.DHCCertDetailD(CERTRowid)
	..;s TypeName=$lg(CertDetail,5)
	..s DateTo=$lg(CertDetail,9)
	..s BlankedFlag=$l(CertDetail,10)				;长期标记
	..s ShowFlag=$lg(CertDetail,15)
	..q:ShowFlag'="Y"
	..q:(BlankedFlag="Y")||(DateTo="")
	..
	..i ControlType="Warn" d
	...s AlarmDate=+$h+WarnDays
	..e  i ControlType="In" d
	...s AlarmDate=+$h+ControlInDays
	..e  i ControlType="Out" d
	...s AlarmDate=+$h+ControlOutDays
	..e  i ControlType="Use" d
	...s AlarmDate=+$h+ControlUseDays
	..
	..i (DateTo<=AlarmDate)&&(BlankedFlag'="Y") d
	...s WarnMessage=TypeName_"("_..DL2H(DateTo)_")"
	...s Str=Str_WarnMessage_","						;警示/控制资质信息
	s:Str'="" Str=$e(Str,1,$l(Str)-1)
	q Str
}

/// Descript:	获取过期或即将过期的产品资质名称(逗号隔开)-医疗器械注册证/供货合同等
/// 			库存项信息,只是使用dhc_certtype记录警示/控制天数,具体信息不存储在dhc_certdetail
/// CreateDate:	2021-08-18
/// Input:		Inci, ControlType:控制类型(Warn/In/Out/Use)
/// Output:		
/// Return:		过期或即将过期的资质名称(逗号隔开)
/// w ##class(web.DHCSTMHUI.DHCCertDetail).CheckInciCertDetail(2,2)
ClassMethod CheckInciCertDetail(Inci As %String, Vendor = "", ControlType As %String = "", HospId As %String = "") As %String
{
	n (Inci,Vendor,ControlType,HospId)
	q:Inci="" ""
	s:ControlType="" ControlType="Warn"
	
	s Str=""
	s CERTType=""
	f  s CERTType=$o(^User.DHCCertTypeI("TypeCode","Inci",CERTType)) q:CERTType=""  d
	.s CertTypeId=""
	.f  s CertTypeId=$o(^User.DHCCertTypeI("TypeCode","Inci",CERTType,CertTypeId)) q:CertTypeId=""  d
	..s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_CertType",CertTypeId,HospId)
	..q:ShowDataFlag'="Y"
	..s CertTypeInfo=$g(^User.DHCCertTypeD(CertTypeId))
	..s TypeName=$lg(CertTypeInfo,4)
	..s TypeFlag=$lg(CertTypeInfo,7)
	..s WarnDays=$lg(CertTypeInfo,8)
	..s ControlInDays=$lg(CertTypeInfo,9)
	..s ControlOutDays=$lg(CertTypeInfo,10)
	..s ControlUseDays=$lg(CertTypeInfo,11)
	..q:TypeFlag'="Y"
	..
	..i ControlType="Warn" d
	...s AlarmDate=+$h+WarnDays
	..e  i ControlType="In" d
	...s AlarmDate=+$h+ControlInDays
	..e  i ControlType="Out" d
	...s AlarmDate=+$h+ControlOutDays
	..e  i ControlType="Use" d
	...s AlarmDate=+$h+ControlUseDays
	..
	..i CERTType="regCert" d
	...;注册证
	...s InfoId=$o(^DHCITMINFO(0,"INCI",Inci,""))
	...q:InfoId=""
	...s MatRegCertDR=$p($g(^DHCITMINFO(InfoId,1)),"^",18)
	...q:MatRegCertDR=""
	...s RegCertInfo=^DHCMRCT(MatRegCertDR)
	...s CerExpDate=$p(RegCertInfo,"^",20)
	...q:CerExpDate=""
	...i (CerExpDate<=AlarmDate) d
	....s WarnMessage=TypeName_"("_..DL2H(CerExpDate)_")"
	....s Str=Str_WarnMessage_","
	...
	..e  i CERTType="contract" d
	...;合同
	...s ContractId=$o(^DHCSTMITMCONTRACK(0,"INCI",Inci,0))
	...q:ContractId=""
	...s ContractInfo=^DHCSTMCONTRACK(ContractId)
	...s ContractNo=$p(ContractInfo,"^",1)
	...s ConStartDate=$p(ContractInfo,"^",4)
	...s ConEndDate=$p(ContractInfo,"^",5)
	...s ConVendor=$p(ContractInfo,"^",8)
	...q:(Vendor'="")&&(ConVendor'=Vendor)
	...q:(ConEndDate="")
	...i (ConEndDate<=AlarmDate) d
	....s WarnMessage=TypeName_"("_..DL2H(ConEndDate)_")"
	....s Str=Str_WarnMessage_","
	s:Str'="" Str=$e(Str,1,$l(Str)-1)
	q Str
}

/// 将老版本(dhc_stvendor)供应商的资质数据, 迁移到DHC_CertDetail
/// w ##class(web.DHCSTMHUI.DHCCertDetail).TransVendorCertToCertDetail()
ClassMethod TransVendorCertToCertDetail(HospId = "")
{
	new (HospId)
	s StkType=..sssCode()

	s ret=0
	ts
	s VenId=0
	f  s VenId=$o(^APC("APCVM",VenId)) q:(VenId="")||(ret<0)  d
	.s STV=$o(^DHCSTV(0,VenId,0))
	.q:STV=""
	.s Type=$p(^APC("APCVM",VenId),"^",9)
	.q:(Type'=StkType)
	.
	.//营业执照
	.s ComLic=$p(^DHCSTV(STV),"^",1)
	.s ComLicDate=$p(^DHCSTV(STV),"^",2)
	.s ComLicIssuedDate=$p(^DHCSTV(STV),"^",62)
	.s ComLicIssuedDept=$p(^DHCSTV(STV),"^",63)
	.i ComLic'="" d
	..s ret=..insertCertDetail("Vendor",VenId,"comLic","营业执照",ComLic,"",ComLicDate,ComLicIssuedDate,ComLicIssuedDept,HospId)
	.q:ret<0
	.
	.//医疗器械经营许可证
	.s MatManLic=$p(^DHCSTV(STV),"^",14)
	.s MatManLicDate=$p(^DHCSTV(STV),"^",15)
	.s MatManLicIssuedDate=$p(^DHCSTV(STV),"^",70)
	.s MatManLicIssuedDept=$p(^DHCSTV(STV),"^",71)
	.i MatManLic'="" d
	..s ret=..insertCertDetail("Vendor",VenId,"insBusLic","医疗器械经营许可证",MatManLic,"",MatManLicDate,MatManLicIssuedDate,MatManLicIssuedDept,HospId)
	.q:ret<0
	.
	.//II类医疗器械经营备案
	.s secondBusLic=$p(^DHCSTV(STV),"^",82)
	.s secondBusLicDate=$p(^DHCSTV(STV),"^",83)			;备案日期
	.s secondBusLicIssuedDept=$p(^DHCSTV(STV),"^",84)	;发证机关
	.s secondBusLicIssuedDate=$p(^DHCSTV(STV),"^",85)	;发证日期
	.i secondBusLic'="" d
	..s ret=..insertCertDetail("Vendor",VenId,"secondBusLic","第二类医疗器械经营备案凭证",secondBusLic,"",secondBusLicDate,secondBusLicIssuedDate,secondBusLicIssuedDept,HospId)
	.q:ret<0
	.
	.//组织机构代码
	.s OrgCode=$p(^DHCSTV(STV),"^",18)
	.s OrgCodeDate=$p(^DHCSTV(STV),"^",19)
	.s OrgCodeIssuedDate=$p(^DHCSTV(STV),"^",66)
	.s OrgCodeIssuedDept=$p(^DHCSTV(STV),"^",67)
	.i OrgCode'="" d
	..s ret=..insertCertDetail("Vendor",VenId,"orgCode","组织机构代码",OrgCode,"",OrgCodeDate,OrgCodeIssuedDate,OrgCodeIssuedDept,HospId)
	.q:ret<0
	.
	.//税务登记证
	.s TaxLic=$p(^DHCSTV(STV),"^",23)
	.s TaxLicDate=$p(^DHCSTV(STV),"^",24)
	.s TaxLicIssuedDate=$p(^DHCSTV(STV),"^",64)
	.s TaxLicIssuedDept=$p(^DHCSTV(STV),"^",65)
	.i TaxLic'="" d
	..s ret=..insertCertDetail("Vendor",VenId,"taxLic","税务登记证",TaxLic,"",TaxLicDate,TaxLicIssuedDate,TaxLicIssuedDept,HospId)
	.q:ret<0
	.
	.//售后服务书
	.s Promises=$p(^DHCSTV(STV),"^",20)
	.i Promises'="" d
	..s ret=..insertCertDetail("Vendor",VenId,"saleServComm","售后服务书",Promises,"","","","",HospId)
	.q:ret<0
	.
	.//法人委托书
	.s TrustDeed=$p(^DHCSTV(STV),"^",27)
	.i TrustDeed'="" d
	..s ret=..insertCertDetail("Vendor",VenId,"legalComm","法人委托书",TrustDeed,"","","","",HospId)
	.q:ret<0
	.
	.//质量承诺书
	.s Quality=$p(^DHCSTV(STV),"^",29)
	.s QualityDate=$p(^DHCSTV(STV),"^",31)
	.i Quality'="" d
	..s ret=..insertCertDetail("Vendor",VenId,"qualityComm","质量承诺书",Quality,"",QualityDate,"","",HospId)
	.q:ret<0

	i ret<0  tro  q ret

	tc
	q 0
}

/// 将老版本(DHC_Manf_AddionInfo)生产厂家的资质数据, 迁移到DHC_CertDetail
/// w ##class(web.DHCSTMHUI.DHCCertDetail).TransManfCertToCertDetail()
ClassMethod TransManfCertToCertDetail(HospId = "")
{
	new (HospId)
	s StkType=..sssCode()

	s ret=0
	ts
	s ManfId=0
	f  s ManfId=$o(^PHMNF(ManfId)) q:(ManfId="")||(ret<0)  d
	.s DHCManfId=$o(^DHCMANF(0,"MANF",ManfId,0))
	.q:DHCManfId=""
	.
	.s Type=$p(^DHCMANF(DHCManfId),"^",7)
	.q:(Type'=StkType)
	.
	.//营业执照-老版本有几个概念重复
	.s ComLic=$p(^DHCMANF(DHCManfId),"^",8)
	.s ComLicDate=$p(^DHCMANF(DHCManfId),"^",9)
	.i ComLic="" d
	..s ComLic=$p(^DHCMANF(DHCManfId),"^",24)
	..s ComLicDate=$p(^DHCMANF(DHCManfId),"^",25)
	.i ComLic="" d
	..s ComLic=$p(^DHCMANF(DHCManfId),"^",11)
	..s ComLicDate=$p(^DHCMANF(DHCManfId),"^",12)
	.i ComLic'="" d
	..s ret=..insertCertDetail("Manf",ManfId,"comLic","营业执照",ComLic,"",ComLicDate,"","",HospId)
	.q:ret<0
	.
	.//医疗器械生产许可证
	.s InsProLic=$p(^DHCMANF(DHCManfId),"^",5)
	.s InsProLicDate=$p(^DHCMANF(DHCManfId),"^",6)
	.i InsProLic'="" d
	..s ret=..insertCertDetail("Manf",ManfId,"insProLic","医疗器械生产许可证",InsProLic,"",InsProLicDate,"","",HospId)
	.q:ret<0
	.
	.//组织机构代码
	.s OrgCode=$p(^DHCMANF(DHCManfId),"^",13)
	.s OrgCodeDate=$p(^DHCMANF(DHCManfId),"^",14)
	.i OrgCode'="" d
	..s ret=..insertCertDetail("Manf",ManfId,"orgCode","组织机构代码",OrgCode,"",OrgCodeDate,"","",HospId)
	.q:ret<0
	.
	.//税务登记证
	.s TaxLic=$p(^DHCMANF(DHCManfId),"^",15)
	.i TaxLic'="" d
	..s ret=..insertCertDetail("Manf",ManfId,"taxLic","税务登记证",TaxLic,"","","","",HospId)
	.q:ret<0
	.
	.//生产企业卫生许可证
	.s ProdHygLic=$p(^DHCMANF(DHCManfId),"^",21)
	.s ProdHygLicDate=$p(^DHCMANF(DHCManfId),"^",22)
	.i ProdHygLic'="" d
	..s ret=..insertCertDetail("Manf",ManfId,"prodEprsHygLic","生产企业卫生许可证",ProdHygLic,"",ProdHygLicDate,"","",HospId)
	.q:ret<0

	i ret<0  tro  q ret

	tc
	q 0
}

ClassMethod insertCertDetail(OrgType, OrgId, CERTType, CERTTypeDesc, CERTText, CERTDateFrom, CERTDateTo, CERTIssuedDate, CERTIssuedDept, HospId)
{
	n (OrgType, OrgId, CERTType, CERTTypeDesc, CERTText, CERTDateFrom, CERTDateTo, CERTIssuedDate,CERTIssuedDept,HospId)
	q:(OrgType="")||(OrgId="")||(CERTType="") -1
	
	q:$d(^User.DHCCertDetailI("OrgType",OrgType,OrgId,CERTType)) 0
	
	s ret=0
	s CERTName=..GetCertName(OrgType,CERTType,HospId)
	i CERTName="" d
	.&sql(insert into DHC_CertType(CT_Type,CT_Code,CT_FullName,CT_ShortName,CT_Num,CT_ShowFlag) 
		values(:OrgType,:CERTType,:CERTTypeDesc,:CERTTypeDesc,"",'Y'))
	.i SQLCODE'=0 s ret=-1
	.q:ret<0
	.s RowId=%ROWID
	.s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_CertType",RowId,HospId)
	q:ret<0 ret
	
	s CERTName=..GetCertName(OrgType,CERTType,HospId)
	
	s Obj=##class(User.DHCCertDetail).%New()
	s Obj.CERTOrgType=OrgType
	s Obj.CERTOrgId=OrgId
	s Obj.CERTType=CERTType
	s Obj.CERTName=CERTName
	s Obj.CERTText=CERTText
	s Obj.CERTIssuedDept=CERTIssuedDept
	s Obj.CERTIssuedDate=CERTIssuedDate
	s Obj.CERTDateFrom=CERTDateFrom
	s Obj.CERTDateTo=CERTDateTo
	s Obj.CERTShowFlag="Y"
	s Sc=Obj.%Save()
	i $$$ISERR(Sc) s ret=-2
	q:ret<0 ret
	
	s CertId=Obj.%Id()
	q CertId
}

}
