Import sqluser

/// 生产厂家信息导入程序
///   Author:zhangxiao
///   Date:2014-01-20
Class web.DHCSTMHUI.Tools.PhManfInputNew Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// 处理一行数据
ClassMethod InputItm(RowObj) As %String
{
	n (RowObj,%session)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s gHospId=$p(..sssParamStr(),"^",4)
	s Hospital=RowObj.%Get("医院")
	s HospId=""
	i Hospital'="" d
	.&sql(SELECT HOSP_RowId INTO:HospId FROM CT_Hospital WHERE HOSP_Desc=:Hospital)
	s:HospId="" HospId=gHospId
	s Code=RowObj.%Get("代码")
	s Desc=RowObj.%Get("名称") ;描述
	s Address=RowObj.%Get("地址") ;地址
	s Tel=RowObj.%Get("电话")   ;电话
	i Desc="" d RtnObj.Err(-1,"","没有输入生产厂家名称","",0)
	q:RtnObj.success'=0 RtnObj 
	i Code="" s Code=Desc
	
	s ManfTmpId=##class(web.DHCSTMHUI.ItmManfNew).CheckManf("CODE",Code,"",HospId)
	i +ManfTmpId>0	d RtnObj.Err(-1,"","代码已经存在","",0)
	q:RtnObj.success'=0 RtnObj	
	s existName=##class(web.DHCSTMHUI.ItmManfNew).CheckManf("DESC",Desc,"",HospId)
	i +existName>0 d RtnObj.Err(-1,"","名称已经存在","",0)
	q:RtnObj.success'=0 RtnObj
	
	&sql(Insert into PH_Manufacturer(PHMNF_Code,PHMNF_Name,PHMNF_Tel)
	values(:Code,:Desc,:Tel))
	i SQLCODE'=0 d 
	.d RtnObj.Err(-1,"","保存失败:"_SQLCODE)
	e  d
	.s PhManfId=$g(%ROWID)
	q:RtnObj.success'=0 RtnObj	
	d ..SaveAddress(Address,PhManfId)
	;院区处理
	s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("PH_Manufacturer",PhManfId,HospId)
	i ret<0 d RtnObj.Err(-1,"","院区授权失败")
	q:RtnObj.success'=0 RtnObj
	
	//插入生产厂家附加信息表
	s ParManf=RowObj.%Get("上级生产厂家")
	s ParManfId=""
	i ParManf'="" d
	.s ParManfId=##class(web.DHCSTMHUI.ItmManfNew).GetManfId("DESC",ParManf,HospId)
	
	s MatProductP=RowObj.%Get("材料生产许可证")  ;材料生产许可证
	s MatProductExp=RowObj.%Get("材料生产许可证效期")
	i MatProductExp'="" s MatProductExp=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(MatProductExp)
	i +MatProductExp<0 d RtnObj.Err(-21,"","材料生产许可证效期格式不正确!","",0)
	q:RtnObj.success'=0 RtnObj
	s ManfId=PhManfId
	s Type=..sssCode()
	s Active="Y"
	
	s ComLic=RowObj.%Get("工商执照许可")   ;工商执照许可
	s ComLicDate=RowObj.%Get("工商执照许可效期")
	i ComLicDate'="" s ComLicDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(ComLicDate)
	i +ComLicDate<0 d RtnObj.Err(-21,"","工商执照许可效期格式不正确!","",0)
	q:RtnObj.success'=0 RtnObj
	s BusinessRegNo=RowObj.%Get("工商注册号")  ;工商注册号
	s BusinessRegExpDate=RowObj.%Get("工商注册号效期")
	i BusinessRegExpDate'="" s BusinessRegExpDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(BusinessRegExpDate)
	i +BusinessRegExpDate<0 d RtnObj.Err(-21,"","工商注册号效期格式不正确!","",0)
	q:RtnObj.success'=0 RtnObj
	s OrgCode=RowObj.%Get("组织机构代码") ;组织机构代码
	s OrgCodeExpDate=RowObj.%Get("组织机构代码效期")
	i OrgCodeExpDate'="" s OrgCodeExpDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(OrgCodeExpDate)
	i +OrgCodeExpDate<0 d RtnObj.Err(-21,"","组织机构代码效期格式不正确!","",0)
	q:RtnObj.success'=0 RtnObj
	s TaxRegNo=RowObj.%Get("税务登记号") ;税务登记号

	s MatManLic=RowObj.%Get("器械经营许可证")  ;器械经营许可证
	s MatManLicDate=RowObj.%Get("器械经营许可证效期")
	i MatManLicDate'="" s MatManLicDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(MatManLicDate)
	i +MatManLicDate<0 d RtnObj.Err(-21,"","器械经营许可证效期格式不正确!","",0)
	q:RtnObj.success'=0 RtnObj
	s QuanPinAlias=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(Desc,3,"",50)
	s Alias=Code_"/"_Desc_"/"_##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(Desc,4)_"/"_QuanPinAlias

	&sql(Insert into DHC_Manf_AddionInfo(MANF_ParManf_DR,
	MANF_PhcManf_DR,MANF_Type,MANF_Active,MANF_Alias)
	values(:ParManfId,:ManfId,:Type,:Active,:Alias))
	i SQLCODE'=0  d RtnObj.Err(-1,"","插入生产厂家附加表错误")
	q:RtnObj.success'=0 RtnObj
	
	s ManfTitle="CERTType^CERTText^CERTDateTo^CERTIssuedDept^CERTIssuedDate^HospId"
	s ManfQualityinfo=""
	;器械生产许可证
	s insProLicType="insProLic"
	s insProLicText=MatProductP
	s insProLicDateTo=MatProductExp
	s insProLicIssuedDept=""
	s insProLicIssuedDate=""
	s insProLicData=insProLicType_"^"_insProLicText_"^"_insProLicDateTo_"^"_insProLicIssuedDept_"^"_insProLicIssuedDate_"^"_HospId
	s insProLicObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(insProLicData,ManfTitle)
	s ManfQualityinfo=insProLicObj
	;工商执照许可
	s comLicType="comLic"
	s comLicText=ComLic
	s comLicDateTo=ComLicDate
	s comLicIssuedDept=""
	s comLicIssuedDate=""
	s comLicData=comLicType_"^"_comLicText_"^"_comLicDateTo_"^"_comLicIssuedDept_"^"_comLicIssuedDate_"^"_HospId
	s comLicObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(comLicData,ManfTitle)
	s ManfQualityinfo=ManfQualityinfo_","_comLicObj
	;工商注册号
	s businessRegNoType="businessRegNo"
	s businessRegNoText=BusinessRegNo
	s businessRegNoDateTo=BusinessRegExpDate
	s businessRegNoIssuedDept=""
	s businessRegNoIssuedDate=""
	s businessRegNoData=businessRegNoType_"^"_businessRegNoText_"^"_businessRegNoDateTo_"^"_businessRegNoIssuedDept_"^"_businessRegNoIssuedDate_"^"_HospId
	s businessRegNoObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(businessRegNoData,ManfTitle)
	s ManfQualityinfo=ManfQualityinfo_","_businessRegNoObj
	;组织机构代码
	s orgCodeType="orgCode"
	s orgCodeText=OrgCode
	s orgCodeDateTo=OrgCodeExpDate
	s orgCodeIssuedDept=""
	s orgCodeIssuedDate=""
	s orgCodeData=orgCodeType_"^"_orgCodeText_"^"_orgCodeDateTo_"^"_orgCodeIssuedDept_"^"_orgCodeIssuedDate_"^"_HospId
	s orgCodeObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(orgCodeData,ManfTitle)
	s ManfQualityinfo=ManfQualityinfo_","_orgCodeObj
	;税务登记号
	s taxLicType="taxLic"
	s taxLicText=TaxRegNo
	s taxLicDateTo=""
	s taxLicIssuedDept=""
	s taxLicIssuedDate=""
	s taxLicData=taxLicType_"^"_taxLicText_"^"_taxLicDateTo_"^"_taxLicIssuedDept_"^"_taxLicIssuedDate_"^"_HospId
	s taxLicObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(taxLicData,ManfTitle)
	s ManfQualityinfo=ManfQualityinfo_","_taxLicObj
	;器械经营许可证
	s insBusLicType="insBusLic"
	s insBusLicText=MatManLic
	s insBusLicDateTo=MatManLicDate
	s insBusLicIssuedDept=""
	s insBusLicIssuedDate=""
	s insBusLicData=insBusLicType_"^"_insBusLicText_"^"_insBusLicDateTo_"^"_insBusLicIssuedDept_"^"_insBusLicIssuedDate_"^"_HospId
	s insBusLicObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(insBusLicData,ManfTitle)
	s ManfQualityinfo=ManfQualityinfo_","_insBusLicObj
	
	s ManfQualityinfo="["_ManfQualityinfo_"]"
	
	s RtnObj=##class(web.DHCSTMHUI.DHCCertDetail).SaveCertDetailList("Manf",PhManfId,ManfQualityinfo)
	i RtnObj.success'=0 d RtnObj.Err(-1,"","更新供应商资质失败")
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:   取生产厂家地址信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-08
/// Table:PH_Manufacturer
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败
ClassMethod SaveAddress(add As %String, rowid As %String) As %Library.String
{

 n (add,rowid)
 s linenum=$l(add,$c(13,10))
 k ^PHMNF(rowid,"Address")
 s ^PHMNF(rowid,"Address",0)=linenum 
 f i=1:1:linenum d
 .s ^PHMNF(rowid,"Address",i)=$p(add,$c(13,10),i) 
 .
 q
}

}
