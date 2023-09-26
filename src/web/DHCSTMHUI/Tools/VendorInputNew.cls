Import sqluser

/// 供应商信息导入程序
///   Author:zhangxiao
///   Date:2013-12-26
Class web.DHCSTMHUI.Tools.VendorInputNew Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// "代码^名称^电话^联系人^账号^采购限额^供应商分类^合同截止日期^传真^法人代表 ^地址^工商执照^工商执照有效期^税务登记^税务登记效期^医疗器械经营许可证^医疗器械经营许可证效期^医疗器械注册证^医疗器械注册证有效期^卫生许可证^卫生许可证有效期^组织机构代码^组织机构代码有效期^Gsp^Gsp效期^医疗器械生产许可证^医疗器械生产许可证有效期^生产制造认可表^生产制造认可表有效期^进口医疗器械注册证^效期^进口注册登记表^效期^代理销售授权书^效期^售后服务承诺书^法人委托书^质量承诺书^质量承诺书有效期^业务员姓名^业务员授权书有效期^业务员电话"
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
	s Desc=RowObj.%Get("名称")
	i Desc="" d RtnObj.Err(-1,"","名称为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s Type=..sssCode()
	s Tel=RowObj.%Get("电话") ;电话
	s ConPerson=RowObj.%Get("联系人")
	s CtrlAcct=RowObj.%Get("开户账号")
	s CrLimit=RowObj.%Get("采购限额")
	s Category=RowObj.%Get("供应商分类")
	s tmpCategoryId=""
	i Category'="" d
	.&sql(select APCVC_RowId into :tmpCategoryId from APC_VendCat where APCVC_Desc=:Category and APCVC_StkType=:Type)
	.i tmpCategoryId'="" d
	..s Category=tmpCategoryId
	s CrAvail=""
	s LstPoDate=RowObj.%Get("合同截止日期")
	i LstPoDate'="" s LstPoDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(LstPoDate)
	i +LstPoDate<0 d RtnObj.Err(-21,"","合同截至日期格式不正确!","",0)
	q:RtnObj.success'=0 RtnObj
	s Fax=RowObj.%Get("传真")
	s President=RowObj.%Get("法人代表")
	s Status="A"
	i Code="" s Code=Desc
	
	s vendoridtmp=##class(web.DHCSTMHUI.APCVenNew).CheckVendor("CODE",Code,"",HospId)
	i +vendoridtmp>0 d RtnObj.Err(-2,"","供应商代码重复!","",0)
	q:RtnObj.success'=0 RtnObj
	s vendoridtmp=##class(web.DHCSTMHUI.APCVenNew).CheckVendor("DESC",Desc,"",HospId)
	i +vendoridtmp>0 d RtnObj.Err(-1,"","供应商已存在!","",0)
	q:RtnObj.success'=0 RtnObj
	
	&sql(Insert into APC_Vendor(APCVM_Code,APCVM_Name,APCVM_Tel,APCVM_ContPerson,
	APCVM_Type,APCVM_CtrlAcct_DR,APCVM_CrLimit,APCVM_Category_DR,APCVM_CrAvail,
	APCVM_LstPoDate,APCVM_Fax,APCVM_President,APCVM_ShName,APCVM_Status)
	values(:Code,:Desc,:Tel,:ConPerson,:Type,:CtrlAcct,:CrLimit,:Category,:CrAvail,
	:LstPoDate,:Fax,:President,:Desc,:Status))
	i SQLCODE'=0 d 
	.d RtnObj.Err(-1,"","插入主表失败")
	e  d
	.s VendorId=$g(%ROWID)
	q:RtnObj.success'=0 RtnObj

	//保存供应商附加资质表信息
	s Address=RowObj.%Get("地址")
	s ComLic=RowObj.%Get("工商执照")
	s ComLicDate=RowObj.%Get("工商执照效期")
	s RevReg=RowObj.%Get("税务登记号")
	s RevRegDate=RowObj.%Get("税务登记号效期")
	i ComLicDate'="" s ComLicDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(ComLicDate) ;工商执照效期
	i +ComLicDate<0 d RtnObj.Err(-21,"","工商执照效期格式不正确!","",0)
	q:RtnObj.success'=0 RtnObj
	i RevRegDate'="" s RevRegDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(RevRegDate) ;税务登记号效期
	i +RevRegDate<0 d RtnObj.Err(-21,"","税务登记号效期格式不正确!","",0)
	q:RtnObj.success'=0 RtnObj
	s DrugManLic=""
	s DrugManLicDate=""
	s MatManLic=RowObj.%Get("医疗器械经营许可证")
	s MatManLicDate=RowObj.%Get("医疗器械经营许可证效期")
	s MatEnrol=RowObj.%Get("医疗器械注册证")
	s MatEnrolDate=RowObj.%Get("医疗器械注册证效期")
	s Sanitation=RowObj.%Get("卫生许可证")
	s SanitationDate=RowObj.%Get("卫生许可证效期")
	i MatManLicDate'="" s MatManLicDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(MatManLicDate) ;医疗器械经营许可证有效期
	i MatEnrolDate'="" s MatEnrolDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(MatEnrolDate) ;医疗器械注册证有效期
	i SanitationDate'="" s SanitationDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(SanitationDate) ;卫生许可证有效期
	i +MatManLicDate<0 d RtnObj.Err(-21,"","医疗器械经营许可证有效期格式不正确!","",0)
	q:RtnObj.success'=0 RtnObj
	i +MatEnrolDate<0 d RtnObj.Err(-21,"","医疗器械注册证有效期格式不正确!","",0)
	q:RtnObj.success'=0 RtnObj
	i +SanitationDate<0 d RtnObj.Err(-21,"","卫生许可证有效期格式不正确!","",0)
	q:RtnObj.success'=0 RtnObj
	s OrgCode=RowObj.%Get("组织机构代码")
	s OrgCodeDate=RowObj.%Get("组织机构代码效期")
	s Gsp=RowObj.%Get("Gsp")
	s GspDate=RowObj.%Get("Gsp效期")
	s MatPro=RowObj.%Get("医疗器械生产许可证")
	s MatProDate=RowObj.%Get("医疗器械生产许可证效期")
	i OrgCodeDate'="" s OrgCodeDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(OrgCodeDate) ;组织机构代码有效期
	i GspDate'="" s GspDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(GspDate)             ;GSP认证有效期
	i MatProDate'="" s MatProDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(MatProDate)  ;医疗器械生产许可证有效期
	i +OrgCodeDate<0 d RtnObj.Err(-21,"","组织机构代码有效期格式不正确!","",0)
	q:RtnObj.success'=0 RtnObj
	i +GspDate<0 d RtnObj.Err(-21,"","GSP认证有效期格式不正确!","",0)
	q:RtnObj.success'=0 RtnObj
	i +MatProDate<0 d RtnObj.Err(-21,"","卫医疗器械生产许可证有效期格式不正确!","",0)
	q:RtnObj.success'=0 RtnObj
	s ProPermit=RowObj.%Get("生产制造认可表")
	s ProPermitDate=RowObj.%Get("生产制造认可表效期")
	s ImportEnrol=RowObj.%Get("进口医疗器械注册证")
	s ImportEnrolDate=RowObj.%Get("进口医疗器械注册证效期")
	s ImportLic=RowObj.%Get("进口注册登记表")
	s ImportLicDate=RowObj.%Get("进口注册登记表效期")
	i ProPermitDate'="" s ProPermitDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(ProPermitDate) ;生产制造认可表有效期
	i ImportEnrolDate'="" s ImportEnrolDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(ImportEnrolDate) ;进口医疗器械注册证有效期
	i ImportLicDate'="" s ImportLicDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(ImportLicDate) ;进口注册登记表有效期
	i +ProPermitDate<0 d RtnObj.Err(-21,"","生产制造认可有效期格式不正确!","",0)
	q:RtnObj.success'=0 RtnObj
	i +ImportEnrolDate<0 d RtnObj.Err(-21,"","进口医疗器械注册证有效期格式不正确!","",0)
	q:RtnObj.success'=0 RtnObj
	i +ImportLicDate<0 d RtnObj.Err(-21,"","进口注册登记表有效期格式不正确!","",0)
	q:RtnObj.success'=0 RtnObj
	s AgentLic=RowObj.%Get("代理销售授权书")
	s AgentLicDate=RowObj.%Get("代理销售授权书效期")
	i AgentLicDate'="" s AgentLicDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(AgentLicDate) 
	i +AgentLicDate<0 d RtnObj.Err(-21,"","代理销售授权书效期格式不正确!","",0)
	q:RtnObj.success'=0 RtnObj
	s Promises=RowObj.%Get("售后服务承诺书")
	s TrustDeed=RowObj.%Get("法人委托书")
	s Quality=RowObj.%Get("质量承诺书")
	s QualityDate=RowObj.%Get("质量承诺书效期")
	i QualityDate'="" s QualityDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(QualityDate)
	i +QualityDate<0 d RtnObj.Err(-21,"","质量承诺书效期格式不正确!","",0)
	q:RtnObj.success'=0 RtnObj	
	s SalesName=RowObj.%Get("业务员姓名")
	s SalesNameDate=RowObj.%Get("业务员授权书效期")
	i SalesNameDate'="" s SalesNameDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(SalesNameDate)
	i +SalesNameDate<0 d RtnObj.Err(-21,"","业务员授权书效期格式不正确!","",0)
	q:RtnObj.success'=0 RtnObj	
	s SalesTel=RowObj.%Get("业务员电话")
	d ..SaveAddress(Address,VendorId)
	s QuanYinAlias=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(Desc,3,"",50)
	s Alias=Code_"/"_Desc_"/"_##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(Desc,4)_"/"_QuanYinAlias
	&sql(Insert into DHC_STVendor(STV_Vendor_DR,STV_SalesName,
	STV_SalesDate,STV_SalesTel,STV_Type,STV_Alias)
	values(:VendorId,
	:SalesName,:SalesNameDate,:SalesTel,:Type,:Alias))
	i SQLCODE'=0  d
	.d RtnObj.Err(-1,"","插入供应商附加表错误:","",0)
	q:RtnObj.success'=0 RtnObj
	;处理院区
	s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("APC_Vendor",VendorId,HospId)
	i ret<0 d RtnObj.Err(-1,"","处理院区授权失败")
	q:RtnObj.success'=0 RtnObj
	
	s qualityinfo=""
	s Title="CERTType^CERTText^CERTDateTo^CERTIssuedDept^CERTIssuedDate^HospId"
	;工商执照
	s comLicType="comLic"
	s comLicText=ComLic
	s comLicDateTo=ComLicDate
	s comLicIssuedDept=""
	s comLicIssuedDate=""
	s comLicData=comLicType_"^"_comLicText_"^"_comLicDateTo_"^"_comLicIssuedDept_"^"_comLicIssuedDate_"^"_HospId
	s comLicObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(comLicData,Title)
	s qualityinfo=comLicObj
	;税务执照
	s taxLicType="taxLic"
	s taxLicText=RevReg
	s taxLicDateTo=RevRegDate
	s taxLicIssuedDept=""
	s taxLicIssuedDate=""
	s taxLicData=taxLicType_"^"_taxLicText_"^"_taxLicDateTo_"^"_taxLicIssuedDept_"^"_taxLicIssuedDate_"^"_HospId
	s taxLicObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(taxLicData,Title)
	s qualityinfo=qualityinfo_","_taxLicObj
	;器械经营许可证
	s insBusLicType="insBusLic"
	s insBusLicText=MatManLic
	s insBusLicDateTo=MatManLicDate
	s insBusLicIssuedDept=""
	s insBusLicIssuedDate=""
	s insBusLicData=insBusLicType_"^"_insBusLicText_"^"_insBusLicDateTo_"^"_insBusLicIssuedDept_"^"_insBusLicIssuedDate_"^"_HospId
	s insBusLicObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(insBusLicData,Title)
	s qualityinfo=qualityinfo_","_insBusLicObj
	;医疗器械注册证
	s insRegLicType="insRegLic"
	s insRegLicText=MatEnrol
	s insRegLicDateTo=MatEnrolDate
	s insRegLicIssuedDept=""
	s insRegLicIssuedDate=""
	s insRegLicData=insRegLicType_"^"_insRegLicText_"^"_insRegLicDateTo_"^"_insRegLicIssuedDept_"^"_insRegLicIssuedDate_"^"_HospId
	s insRegLicObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(insRegLicData,Title)
	s qualityinfo=qualityinfo_","_insRegLicObj
	;卫生许可证
	s SanitationType="Sanitation"
	s SanitationText=Sanitation
	s SanitationDateTo=SanitationDate
	s SanitationIssuedDept=""
	s SanitationIssuedDate=""
	s SanitationData=SanitationType_"^"_SanitationText_"^"_SanitationDateTo_"^"_SanitationIssuedDept_"^"_SanitationIssuedDate_"^"_HospId
	s SanitationObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(SanitationData,Title)
	s qualityinfo=qualityinfo_","_SanitationObj
	;组织机构代码
	s orgCodeType="orgCode"
	s orgCodeText=OrgCode
	s orgCodeDateTo=OrgCodeDate
	s orgCodeIssuedDept=""
	s orgCodeIssuedDate=""
	s orgCodeData=orgCodeType_"^"_orgCodeText_"^"_orgCodeDateTo_"^"_orgCodeIssuedDept_"^"_orgCodeIssuedDate_"^"_HospId
	s orgCodeObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(orgCodeData,Title)
	s qualityinfo=qualityinfo_","_orgCodeObj
	; GSP认证
	s gspLicType="gspLic"
	s gspLicText=Gsp
	s gspLicDateTo=GspDate
	s gspLicIssuedDept=""
	s gspLicIssuedDate=""
	s gspLicData=gspLicType_"^"_gspLicText_"^"_gspLicDateTo_"^"_gspLicIssuedDept_"^"_gspLicIssuedDate_"^"_HospId
	s gspLicObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(gspLicData,Title)
	s qualityinfo=qualityinfo_","_gspLicObj
	; 医疗器械生产许可证
	s insProLicType="insProLic"
	s insProLicText=MatPro
	s insProLicDateTo=MatProDate
	s insProLicIssuedDept=""
	s insProLicIssuedDate=""
	s insProLicData=insProLicType_"^"_insProLicText_"^"_insProLicDateTo_"^"_insProLicIssuedDept_"^"_insProLicIssuedDate_"^"_HospId
	s insProLicObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(insProLicData,Title)
	s qualityinfo=qualityinfo_","_insProLicObj
	; 生产制造认可表
	s proPermitType="proPermit"
	s proPermitText=ProPermit
	s proPermitDateTo=ProPermitDate
	s proPermitIssuedDept=""
	s proPermitIssuedDate=""
	s proPermitData=proPermitType_"^"_proPermitText_"^"_proPermitDateTo_"^"_proPermitIssuedDept_"^"_proPermitIssuedDate_"^"_HospId
	s proPermitObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(proPermitData,Title)
	s qualityinfo=qualityinfo_","_proPermitObj
	;进口医疗器械注册证
	s inletRLicType="inletRLic"
	s inletRLicText=ImportEnrol
	s inletRLicDateTo=ImportEnrolDate
	s inletRLicIssuedDept=""
	s inletRLicIssuedDate=""
	s inletRLicData=inletRLicType_"^"_inletRLicText_"^"_inletRLicDateTo_"^"_inletRLicIssuedDept_"^"_inletRLicIssuedDate_"^"_HospId
	s inletRLicObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(inletRLicData,Title)
	s qualityinfo=qualityinfo_","_inletRLicObj
	;进口注册登记表
	s inletRegLicType="inletRegLic"
	s inletRegLicText=ImportLic
	s inletRegLicDateTo=ImportLicDate
	s inletRegLicIssuedDept=""
	s inletRegLicIssuedDate=""
	s inletRegLicData=inletRegLicType_"^"_inletRegLicText_"^"_inletRegLicDateTo_"^"_inletRegLicIssuedDept_"^"_inletRegLicIssuedDate_"^"_HospId
	s inletRegLicObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(inletRegLicData,Title)
	s qualityinfo=qualityinfo_","_inletRegLicObj
	;代理销售授权书
	s agentAuthType="agentAuth"
	s agentAuthText=AgentLic
	s agentAuthDateTo=AgentLicDate
	s agentAuthIssuedDept=""
	s agentAuthIssuedDate=""
	s agentAuthData=agentAuthType_"^"_agentAuthText_"^"_agentAuthDateTo_"^"_agentAuthIssuedDept_"^"_agentAuthIssuedDate_"^"_HospId
	s agentAuthObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(agentAuthData,Title)
	s qualityinfo=qualityinfo_","_agentAuthObj
	; 售后服务承诺书
	s saleServCommType="saleServComm"
	s saleServCommText=Promises
	s saleServCommDateTo=""
	s saleServCommIssuedDept=""
	s saleServCommIssuedDate=""
	s saleServCommData=saleServCommType_"^"_saleServCommText_"^"_saleServCommDateTo_"^"_saleServCommIssuedDept_"^"_saleServCommIssuedDate_"^"_HospId
	s saleServCommObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(saleServCommData,Title)
	s qualityinfo=qualityinfo_","_saleServCommObj
	; 法人委托书
	s legalCommType="legalComm"
	s legalCommText=TrustDeed
	s legalCommDateTo=""
	s legalCommIssuedDept=""
	s legalCommIssuedDate=""
	s legalCommData=legalCommType_"^"_legalCommText_"^"_legalCommDateTo_"^"_legalCommIssuedDept_"^"_legalCommIssuedDate_"^"_HospId
	s legalCommObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(legalCommData,Title)
	s qualityinfo=qualityinfo_","_legalCommObj
	; 质量承诺书
	s qualityCommType="qualityComm"
	s qualityCommText=Quality
	s qualityCommDateTo=QualityDate
	s qualityCommIssuedDept=""
	s qualityCommIssuedDate=""
	s qualityCommData=qualityCommType_"^"_qualityCommText_"^"_qualityCommDateTo_"^"_qualityCommIssuedDept_"^"_qualityCommIssuedDate_"^"_HospId
	s qualityCommObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(qualityCommData,Title)
	s qualityinfo=qualityinfo_","_qualityCommObj
	s qualityinfo="["_qualityinfo_"]" ;新版资质维护
	s RtnObj=##class(web.DHCSTMHUI.DHCCertDetail).SaveCertDetailList("Vendor",VendorId,qualityinfo)
	q:RtnObj.success'=0 RtnObj

  q RtnObj
}

/// Descript:   保存供应商地址信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-15
/// Table:APC_Vendor
/// Input:地址,供应商id
/// Output:     
/// Return：
ClassMethod SaveAddress(add As %String, rowid As %String) As %Library.String
{

 n (add,rowid)
 s linenum=$l(add,$c(13,10))
 k ^APC("APCVM",rowid,"ADDR")
 s ^APC("APCVM",rowid,"ADDR",0)=linenum 
 f i=1:1:linenum d
 .s ^APC("APCVM",rowid,"ADDR",i)=$p(add,$c(13,10),i) 
 q
}

}
