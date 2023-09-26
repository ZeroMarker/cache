Import sqluser

Class web.DHCSTMHUI.DicGroup Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Creater:	zx
/// CreateDate:	2018-09-21
/// Table:		DHC_DicGroup
/// Input:		 
/// Return：	消息Json串
/// w ##class(web.DHCSTMHUI.DicGroup).Save(2,"{""DGCode"":""Y"",""gUserId"":""4668"",""gLocId"":""392"",""gGroupId"":""97"",""gHospId"":""2"",""DGDesc"":""Y"",""DGChargeType"":""Y"",""DGSp"":""Y"",""DGPbRp"":""Y"",""DGSpec"":""Y"",""DGScg"":""Y"",""DGStkcat"":""Y"",""DGBrand"":""Y"",""DGUom"":""Y"",""DGPbManf"":""Y"",""DGPbVendor"":""Y"",""DGHVFlag"":""Y"",""DGCertNo"":""Y"",""DGProvLoc"":""Y"",""DGPruPic"":""Y"",""DGPruCommonPic"":""Y"",""DGPruDocumentPic"":""Y"",""DGItmSA"":""Y"",""DGHospAllowed"":""Y""}","{""DGMCert"":""Y"",""gUserId"":""4668"",""gLocId"":""392"",""gGroupId"":""97"",""gHospId"":""2"",""DGMMatProduct"":"""",""DGMComLic"":"""",""DGMBusinessReg"":""Y"",""DGMOrgCode"":"""",""DGMMatManLic"":""""}","{""DGVLic"":""Y"",""gUserId"":""4668"",""gLocId"":""392"",""gGroupId"":""97"",""gHospId"":""2"",""DGVComlic"":"""",""DGVRevreg"":"""",""DGVMatmanlic"":"""",""DGVMatenrol"":"""",""DGVSanitation"":"""",""DGVOrgcode"":"""",""DGVGsp"":"""",""DGVMatpro"":"""",""DGVPropermit"":"""",""DGVQuality"":"""",""DGVSales"":""""}")
ClassMethod Save(GroupId, IncData, PhamnfData, VendorData) As %Library.String
{
	n (GroupId,IncData,PhamnfData,VendorData,%session)
	;s ^zx(1)=GroupId
	;s ^zx(2)=IncData
	;s ^zx(3)=PhamnfData
	;s ^zx(4)=VendorData
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	
	i GroupId="" d
	.s Sc=RtnObj.Err(-1,"","安全组为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s InciObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=InciObj.%FromJSON(IncData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-2,"","基础信息入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s DGCode=InciObj.%Get("DGCode")
	s DGDesc=InciObj.%Get("DGDesc")
	s DGChargeType=InciObj.%Get("DGChargeType")
	s DGSp=InciObj.%Get("DGSp")
	s DGPbRp=InciObj.%Get("DGPbRp")
	s DGSpec=InciObj.%Get("DGSpec")
	s DGScg=InciObj.%Get("DGScg")
	s DGStkcat=InciObj.%Get("DGStkcat")
	s DGBrand=InciObj.%Get("DGBrand")
	
	s DGUom=InciObj.%Get("DGUom")
	s DGPbManf=InciObj.%Get("DGPbManf")
	s DGPbVendor=InciObj.%Get("DGPbVendor")
	s DGHVFlag=InciObj.%Get("DGHVFlag")
	s DGCertNo=InciObj.%Get("DGCertNo")
	s DGProvLoc=InciObj.%Get("DGProvLoc")
	s DGPruPic=InciObj.%Get("DGPruPic")
	s DGPruCommonPic=InciObj.%Get("DGPruCommonPic")
	s DGPruDocumentPic=InciObj.%Get("DGPruDocumentPic")
	
	s DGItmSA=InciObj.%Get("DGItmSA")
	s DGHospAllowed=InciObj.%Get("DGHospAllowed")
	
	
	s PhamnfObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PhamnfObj.%FromJSON(PhamnfData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-2,"","生产厂家信息入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s DGMCert=PhamnfObj.%Get("DGMCert")
	s DGMMatProduct=PhamnfObj.%Get("DGMMatProduct")
	s DGMComLic=PhamnfObj.%Get("DGMComLic")
	s DGMBusinessReg=PhamnfObj.%Get("DGMBusinessReg")
	s DGMOrgCode=PhamnfObj.%Get("DGMOrgCode")
	s DGMMatManLic=PhamnfObj.%Get("DGMMatManLic")
	
	s VendorObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=VendorObj.%FromJSON(VendorData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-3,"","供应商信息入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	s DGVLic=VendorObj.%Get("DGVLic")
	s DGVComlic=VendorObj.%Get("DGVComlic")
	s DGVRevreg=VendorObj.%Get("DGVRevreg")
	s DGVMatmanlic=VendorObj.%Get("DGVMatmanlic")
	s DGVMatenrol=VendorObj.%Get("DGVMatenrol")
	s DGVSanitation=VendorObj.%Get("DGVSanitation")
	s DGVOrgcode=VendorObj.%Get("DGVOrgcode")
	s DGVGsp=VendorObj.%Get("DGVGsp")
	
	s DGVMatpro=VendorObj.%Get("DGVMatpro")
	s DGVPropermit=VendorObj.%Get("DGVPropermit")
	s DGVQuality=VendorObj.%Get("DGVQuality")
	s DGVSales=VendorObj.%Get("DGVSales")
	s DGVAgentlic=""
	s DGVImpenrol=""
	s DDGVQuality=""
	s DGVImplic=""
	
	&sql(select %id into :RowId from DHC_DicGroup where DG_Group_DR=:GroupId)
	i SQLCODE=0  d
    .s ObjDicGroup=##class(User.DHCDicGroup).%OpenId(RowId) 
    .d ObjDicGroup.%Reload()
    e  d
    .s ObjDicGroup=##class(User.DHCDicGroup).%New()
    
    d ObjDicGroup.DGGroupDRSetObjectId(GroupId)
    s ObjDicGroup.DGBrand=DGBrand
    s ObjDicGroup.DGCertNo=DGCertNo
    s ObjDicGroup.DGChargeType=DGChargeType
    s ObjDicGroup.DGCode=DGCode
    s ObjDicGroup.DGDesc=DGDesc
    s ObjDicGroup.DGHVFlag=DGHVFlag
    s ObjDicGroup.DGItmSA=DGItmSA
    s ObjDicGroup.DGMBusinessReg=DGMBusinessReg
    s ObjDicGroup.DGMCert=DGMCert
    s ObjDicGroup.DGMComLic=DGMComLic
    s ObjDicGroup.DGMMatManLic=DGMMatManLic
    s ObjDicGroup.DGMMatProduct=DGMMatProduct
    s ObjDicGroup.DGMOrgCode=DGMOrgCode
    s ObjDicGroup.DGPbManf=DGPbManf
    s ObjDicGroup.DGPbRp=DGPbRp
    s ObjDicGroup.DGPbVendor=DGPbVendor
    s ObjDicGroup.DGProvLoc=DGProvLoc
    s ObjDicGroup.DGPruPic=DGPruPic
    s ObjDicGroup.DGScg=DGScg
    s ObjDicGroup.DGSp=DGSp
    s ObjDicGroup.DGSpec=DGSpec
    s ObjDicGroup.DGStkcat=DGStkcat
    s ObjDicGroup.DGUom=DGUom
    s ObjDicGroup.DGVAgentlic=DGVAgentlic
    s ObjDicGroup.DGVComlic=DGVComlic
    s ObjDicGroup.DGVGsp=DGVGsp
    s ObjDicGroup.DGVImpenrol=DGVImpenrol
    s ObjDicGroup.DGVImplic=DGVImplic
    s ObjDicGroup.DGVLic=DGVLic
    s ObjDicGroup.DGVMatenrol=DGVMatenrol
    s ObjDicGroup.DGVMatmanlic=DGVMatmanlic
    s ObjDicGroup.DGVMatpro=DGVMatpro
    s ObjDicGroup.DGVOrgcode=DGVOrgcode
    s ObjDicGroup.DGVPropermit=DGVPropermit
    s ObjDicGroup.DGVQuality=DDGVQuality
    s ObjDicGroup.DGVRevreg=DGVRevreg
    s ObjDicGroup.DGVSales=DGVSales
    s ObjDicGroup.DGVSanitation=DGVSanitation
    s ObjDicGroup.DGHospAllowed=DGHospAllowed
    s ObjDicGroup.DGPruCommonPic=DGPruCommonPic
    s ObjDicGroup.DGPruDocumentPic=DGPruDocumentPic
    s sc=ObjDicGroup.%Save()
    i $$$ISERR(sc) d
    .s Sc=RtnObj.Err(-2,"","生产厂家信息入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	
	q RtnObj.Json()
}

/// 查询
/// Author:XuChao
/// Date:2015-11-4
/// Argu:
///   data - DGGroupDR
/// Return:
ClassMethod LoadData(DGGroupDR As %String) As %String
{
 n (DGGroupDR)
 &sql(select %id into :RowId from DHC_DicGroup where DG_Group_DR=:DGGroupDR)
 i SQLCODE=0  d
 .s DicGroup=##class(User.DHCDicGroup).%OpenId(RowId) 
 .d DicGroup.%Reload()
 e  d
 .s DicGroup=##class(User.DHCDicGroup).%New()
 
 s DGBrand=DicGroup.DGBrand
 s DGCertNo=DicGroup.DGCertNo
 s DGChargeType=DicGroup.DGChargeType
 s DGCode=DicGroup.DGCode
 s DGDesc=DicGroup.DGDesc
 s DGHVFlag=DicGroup.DGHVFlag
 s DGItmSA=DicGroup.DGItmSA
 s DGMBusinessReg=DicGroup.DGMBusinessReg
 s DGMCert=DicGroup.DGMCert
 s DGMComLic=DicGroup.DGMComLic
 s DGMMatManLic=DicGroup.DGMMatManLic
 s DGMMatProduct=DicGroup.DGMMatProduct
 s DGMOrgCode= DicGroup.DGMOrgCode
 s DGPbManf=DicGroup.DGPbManf
 s DGPbRp=DicGroup.DGPbRp
 s DGPbVendor=DicGroup.DGPbVendor
 s DGProvLoc=DicGroup.DGProvLoc
 s DGPruPic=DicGroup.DGPruPic
 s DGScg=DicGroup.DGScg
 s DGSp=DicGroup.DGSp
 s DGSpec=DicGroup.DGSpec
 s DGStkcat=DicGroup.DGStkcat
 s DGUom=DicGroup.DGUom
 s DGVAgentlic=DicGroup.DGVAgentlic
 s DGVComlic=DicGroup.DGVComlic
 s DGVGsp=DicGroup.DGVGsp
 s DGVImpenrol=DicGroup.DGVImpenrol
 s DGVImplic=DicGroup.DGVImplic
 s DGVLic=DicGroup.DGVLic
 s DGVMatenrol=DicGroup.DGVMatenrol
 s DGVMatmanlic=DicGroup.DGVMatmanlic
 s DGVMatpro=DicGroup.DGVMatpro
 s DGVOrgcode=DicGroup.DGVOrgcode
 s DGVPropermit=DicGroup.DGVPropermit
 s DGVQuality=DicGroup.DGVQuality
 s DGVRevreg= DicGroup.DGVRevreg
 s DGVSales=DicGroup.DGVSales
 s DGVSanitation=DicGroup.DGVSanitation
 s DGHospAllowed=DicGroup.DGHospAllowed
 s DGPruCommonPic=DicGroup.DGPruCommonPic
 s DGPruDocumentPic=DicGroup.DGPruDocumentPic
 s dataStr=DGBrand_"^"_DGCertNo_"^"_DGChargeType_"^"_DGCode_"^"_DGDesc_"^"_
 		   DGHVFlag_"^"_DGItmSA_"^"_DGMBusinessReg_"^"_DGMCert_"^"_DGMComLic_"^"_
 		   DGMMatManLic_"^"_DGMMatProduct_"^"_DGMOrgCode_"^"_DGPbManf_"^"_DGPbRp_"^"_
 		   DGPbVendor_"^"_DGProvLoc_"^"_DGPruPic_"^"_DGScg_"^"_DGSp_"^"_
 		   DGSpec_"^"_DGStkcat_"^"_DGUom_"^"_DGVAgentlic_"^"_DGVComlic_"^"_
 		   DGVGsp_"^"_DGVImpenrol_"^"_DGVImplic_"^"_DGVLic_"^"_DGVMatenrol_"^"_
 		   DGVMatmanlic_"^"_DGVMatpro_"^"_DGVOrgcode_"^"_DGVPropermit_"^"_DGVQuality_"^"_
 		   DGVRevreg_"^"_DGVSales_"^"_DGVSanitation_"^"_DGHospAllowed_"^"_DGPruCommonPic
 		   _"^"_DGPruDocumentPic
 s titleStr="DGBrand^DGCertNo^DGChargeType^DGCode^DGDesc^"
 		   _"DGHVFlag^DGItmSA^DGMBusinessReg^DGMCert^DGMComLic^"
 		   _"DGMMatManLic^DGMMatProduct^DGMOrgCode^DGPbManf^DGPbRp^"
 		   _"DGPbVendor^DGProvLoc^DGPruPic^DGScg^DGSp^"
 		   _"DGSpec^DGStkcat^DGUom^DGVAgentlic^DGVComlic^"
 		   _"DGVGsp^DGVImpenrol^DGVImplic^DGVLic^DGVMatenrol^"
 		   _"DGVMatmanlic^DGVMatpro^DGVOrgcode^DGVPropermit^DGVQuality^"
 		   _"DGVRevreg^DGVSales^DGVSanitation^DGHospAllowed^DGPruCommonPic"
 		   _"^DGPruDocumentPic"
 s result=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(dataStr,titleStr)
 q "{"_$c(34)_"success"_$c(34)_":"_$c(34)_0_$c(34)_","_$c(34)_"Data"_$c(34)_":"_result_"}"
}

/// 获取物资注册证、生产厂家、供应商资质信息(物资代码链接用)
/// Creater:wxj
/// CreateDate:	2020-11-06
/// w ##class(web.DHCSTMHUI.DicGroup).GetItmDetail(1715)
ClassMethod GetItmDetail(Inci As %String) As %String
{
	n (Inci)
	s RtnObj=##class(RtnObj).%New()	
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s InciCode=$p(^INCI(Inci,1),"^",1)
	s InciDesc=$p(^INCI(Inci,1),"^",2)
	s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(Inci)
	s ManfId=$p(ManfInfo,"^",1)
	s ManfCode=$p(ManfInfo,"^",2)
	s ManfDesc=$p(ManfInfo,"^",3)
	s VenInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbVendor(Inci)
	s VendorId=$p(VenInfo,"^",1)
	s VenDesc=$p(VenInfo,"^",2)
	s VenCode=$p(VenInfo,"^",3)
	s (CerNo,CerExpDate,CertItmDesc,IRRegCertDateOfIssue,RegExpExtended,RegValidLong,MRCRegName)=""
	s (MRCRegPerAddress,MRCRegAgent,MRCAgentAddress,MRCAppliedRange,MRCSpecForm,MRCRemark,MRCApprovalDate)=""
	s CertStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(Inci)
	i CertStr'="" d
	.s CerNo=$p(CertStr,"^",1)					;注册证号
	.s CerExpDate=$p(CertStr,"^",2)				;有效期
	.s CertItmDesc=$p(CertStr,"^",3)			;产品名称
	.s IRRegCertDateOfIssue=$p(CertStr,"^",5)	;注册证发证日期
	.s RegExpExtended=$p(CertStr,"^",6)			;注册证延长效期标志
	.s RegValidLong=$p(CertStr,"^",7)			;注册证长期标志
	.s MRCRegName=$p(CertStr,"^",17)			;注册人名称 生产厂家
	.s MRCRegPerAddress=$p(CertStr,"^",18)		;注册人地址 生产厂家地址
	.s MRCRegAgent=$p(CertStr,"^",15)			;注册代理人名称
	.s MRCAgentAddress=$p(CertStr,"^",19)		;代理人住所
	.s MRCAppliedRange=$p(CertStr,"^",14)		;适用范围
	.s MRCSpecForm=$p(CertStr,"^",20)			;规格型号
	.s MRCRemark=$p(CertStr,"^",21)				;备注
	.s MRCApprovalDate=$p(CertStr,"^",22)		;批准日期
	//一类备案:进口第三个字为备,境内第4个字为备
	i (CerNo'="") d
	.i ($e(CerNo,2,3)="械备")||($e(CerNo,3,4)="械备") d	
	..s CertInfo($i(CertInfo))="医疗器械一类备案信息^^"
	..s CertInfo($i(CertInfo))="^物资代码^"_InciCode
	..s CertInfo($i(CertInfo))="^物资名称^"_InciDesc
	..s CertInfo($i(CertInfo))="^备案号^"_CerNo
	..s CertInfo($i(CertInfo))="^备案人名称^"_MRCRegName
	..s CertInfo($i(CertInfo))="^备案人注册地址^"_MRCRegPerAddress
	..s CertInfo($i(CertInfo))="^代理人名称^"_MRCRegAgent
	..s CertInfo($i(CertInfo))="^代理人住所^"_MRCAgentAddress
	..s CertInfo($i(CertInfo))="^产品名称^"_CertItmDesc
	..s CertInfo($i(CertInfo))="^规格型号^"_MRCSpecForm
	..s CertInfo($i(CertInfo))="^预期用途^"_MRCAppliedRange
	..s CertInfo($i(CertInfo))="^备案日期^"_MRCApprovalDate
	..s CertInfo($i(CertInfo))="^有效期至^"_CerExpDate
	..s CertInfo($i(CertInfo))="^长期标志^"_RegValidLong
	..s CertInfo($i(CertInfo))="^延长效期标志^"_RegExpExtended
	..s CertInfo($i(CertInfo))="医疗器械生产企业一类备案^^"
	..s ManfCertInfo=..GetOrgCertInfo("Manf","firstProdLic",ManfId)
	..s CertInfo($i(CertInfo))="^生产厂家代码^"_ManfCode
	..s CertInfo($i(CertInfo))="^生产厂家名称^"_ManfDesc
	..s CertInfo($i(CertInfo))="^备案凭证编号^"_$p(ManfCertInfo,"^",2)
	..s CertInfo($i(CertInfo))="^备案日期^"_$p(ManfCertInfo,"^",4)
	..s CertInfo($i(CertInfo))="^备案部门^"_$p(ManfCertInfo,"^",3)
	.e  d
	..s CertInfo($i(CertInfo))="医疗器械注册证信息^^"
	..s CertInfo($i(CertInfo))="^物资代码^"_InciCode
	..s CertInfo($i(CertInfo))="^物资名称^"_InciDesc
	..s CertInfo($i(CertInfo))="^注册证编号^"_CerNo
	..s CertInfo($i(CertInfo))="^注册人名称^"_MRCRegName
	..s CertInfo($i(CertInfo))="^注册人住所^"_MRCRegPerAddress
	..s CertInfo($i(CertInfo))="^代理人名称^"_MRCRegAgent
	..s CertInfo($i(CertInfo))="^代理人注册地址^"_MRCAgentAddress
	..s CertInfo($i(CertInfo))="^产品名称^"_CertItmDesc
	..s CertInfo($i(CertInfo))="^规格型号^"_MRCSpecForm
	..s CertInfo($i(CertInfo))="^适用范围^"_MRCAppliedRange
	..s CertInfo($i(CertInfo))="^批准日期^"_MRCApprovalDate
	..s CertInfo($i(CertInfo))="^有效期至^"_CerExpDate
	..s CertInfo($i(CertInfo))="^长期标志^"_RegValidLong
	..s CertInfo($i(CertInfo))="^延长效期标志^"_RegExpExtended
	..s CertInfo($i(CertInfo))="医疗器械生产企业许可^^"
	..s ManfCertInfo=..GetOrgCertInfo("Manf","insProLic",ManfId)
	..s CertInfo($i(CertInfo))="^生产厂家代码^"_ManfCode
	..s CertInfo($i(CertInfo))="^生产厂家名称^"_ManfDesc
	..s CertInfo($i(CertInfo))="^许可证编号^"_$p(ManfCertInfo,"^",2)
	..s CertInfo($i(CertInfo))="^发证日期^"_$p(ManfCertInfo,"^",4)
	..s CertInfo($i(CertInfo))="^发证部门^"_$p(ManfCertInfo,"^",3)
	..s CertInfo($i(CertInfo))="^效期开始^"_$p(ManfCertInfo,"^",5)
	..s CertInfo($i(CertInfo))="^效期截止^"_$p(ManfCertInfo,"^",6)
	..s CertInfo($i(CertInfo))="^是否长期^"_$p(ManfCertInfo,"^",7)
	..s CertInfo($i(CertInfo))="^是否延期^"_$p(ManfCertInfo,"^",8)
	..s CertInfo($i(CertInfo))="^延期至^"_$p(ManfCertInfo,"^",9)
	..i ($e(CerNo,9))=2 d
	...s CertInfo($i(CertInfo))="医疗器械经营企业二类备案^^"
	...s VenCertInfo=..GetOrgCertInfo("Vendor","secondBusLic",VendorId)
	...s CertInfo($i(CertInfo))="^供应商代码^"_VenCode
	...s CertInfo($i(CertInfo))="^供应商名称^"_VenDesc
	...s CertInfo($i(CertInfo))="^备案编号^"_$p(VenCertInfo,"^",2)
	...s CertInfo($i(CertInfo))="^备案日期^"_$p(VenCertInfo,"^",4)
	...s CertInfo($i(CertInfo))="^备案部门^"_$p(VenCertInfo,"^",3)
	..e  d
	...s CertInfo($i(CertInfo))="医疗器械经营企业许可^^"
	...s VenCertInfo=..GetOrgCertInfo("Vendor","insBusLic",VendorId)
	...s CertInfo($i(CertInfo))="^供应商代码^"_VenCode
	...s CertInfo($i(CertInfo))="^供应商名称^"_VenDesc
	...s CertInfo($i(CertInfo))="^许可证编号^"_$p(VenCertInfo,"^",2)
	...s CertInfo($i(CertInfo))="^发证日期^"_$p(VenCertInfo,"^",4)
	...s CertInfo($i(CertInfo))="^发证部门^"_$p(VenCertInfo,"^",3)
	...s CertInfo($i(CertInfo))="^效期开始^"_$p(VenCertInfo,"^",5)
	...s CertInfo($i(CertInfo))="^效期截止^"_$p(VenCertInfo,"^",6)
	...s CertInfo($i(CertInfo))="^是否长期^"_$p(VenCertInfo,"^",7)
	...s CertInfo($i(CertInfo))="^是否延期^"_$p(VenCertInfo,"^",8)
	...s CertInfo($i(CertInfo))="^延期至^"_$p(VenCertInfo,"^",9)
	/*e  d
	.s CertInfo($i(CertInfo))="物资信息^^"
	.s CertInfo($i(CertInfo))="^物资代码^"_InciCode
	.s CertInfo($i(CertInfo))="^物资名称^"_InciDesc*/
	f Index=1:1:CertInfo {
		s DataStr=CertInfo(Index)
		d json.InsertRowData(DataStr)
	}
	s TitleStr="MainInfo^ItemName^ItemValue"
	d json.getJsonData(TitleStr,CertInfo)
	k json
	q ""
}

/// w ##class(web.DHCSTMHUI.DicGroup).GetOrgCertInfo("Manf","firstProdLic",1245)
ClassMethod GetOrgCertInfo(OrgType, CertType, OrgId) As %String
{
	n (OrgType,CertType,OrgId)
	q:OrgType="" ""
	q:CertType="" ""
	q:OrgId="" ""
	s CertTypeId=$o(^User.DHCCertTypeI("TypeCode",OrgType,CertType,0))
	s CertInfo=^User.DHCCertTypeD(CertTypeId)
	s ShowFlag=$lg(CertInfo,7)
	q:ShowFlag'="Y"
	s CertId=$o(^User.DHCCertDetailI("OrgType",OrgType,OrgId,CertType,""),-1)
	q:CertId="" ""
	s Obj=##class(User.DHCCertDetail).%OpenId(CertId)
	s CertText=Obj.CERTText					//证件编号
	s CertIssuedDept=Obj.CERTIssuedDept		//发证机关
	s CertIssuedDate=Obj.CERTIssuedDate		//发证日期
	s CertDateFrom=Obj.CERTDateFrom			//效期开始
	s CertDateTo=Obj.CERTDateTo				//效期截止
	s CertBlankedFlag=Obj.CERTBlankedFlag	//是否长期
	s CertDelayFlag=Obj.CERTDelayFlag		//是否延期
	s CertDelayDateTo=Obj.CERTDelayDateTo	//延期至
	s CertShowFlag=Obj.CERTShowFlag			//是否展示
	q:CertShowFlag'="Y" ""
	
	s CertIssuedDate=..DL2H(CertIssuedDate)
	s CertDateFrom=..DL2H(CertDateFrom)
	s CertDateTo=..DL2H(CertDateTo)
	s CertDelayDateTo=..DL2H(CertDelayDateTo)
	s Data1=CertId_"^"_CertText_"^"_CertIssuedDept_"^"_CertIssuedDate_"^"_CertDateFrom
	s Data2=CertDateTo_"^"_CertBlankedFlag_"^"_CertDelayFlag_"^"_CertDelayDateTo
	q Data1_"^"_Data2
}

}
