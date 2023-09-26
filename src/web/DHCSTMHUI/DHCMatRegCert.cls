Import sqluser

/// 维护注册注册证信息
Class web.DHCSTMHUI.DHCMatRegCert Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// 根据注册证号获取注册证信息
/// w ##class(web.DHCSTMHUI.DHCMatRegCert).getByRegNo("11")
ClassMethod getByRegNo(No) As %String
{
	n (No)
	s Ret="{}"
	i No="" q Ret
	
	s (RowId,RegNo,InciDesc,ApprovalDate,ValidUntil,MRCCategory,MRCRegName,MRCRegPerAddress)=""
	s (MRCSpecForm,MRCStructure,MRCAppliedRange,MRCRemark,MRCRegAgent,MRCAgentAddress,MRCManfId,MRCManfDesc)=""
	&sql(SELECT MRC_RowID, MRC_No, MRC_InciDesc, MRC_ApprovalDate, MRC_ValidUntil,
		MRC_Category, MRC_RegName, MRC_RegPerAddress, MRC_SpecForm,
		MRC_Structure, MRC_AppliedRange , MRC_Remark, MRC_RegAgent,
		MRC_AgentAddress,MRC_ValidLong,MRC_ValidExtend,MRC_PHManf_DR 
		into
		:RowId,:RegNo,:InciDesc,:ApprovalDate,:ValidUntil,
		:MRCCategory,:MRCRegName,:MRCRegPerAddress,:MRCSpecForm,
		:MRCStructure,:MRCAppliedRange,:MRCRemark,:MRCRegAgent,
		:MRCAgentAddress,:MRCValidLong,:MRCValidExtend,:MRCManfId 
		FROM DHC_MatRegCert WHERE MRC_No=:No)
	q:SQLCODE'=0 Ret
	
	s:(MRCManfId'="") MRCManfDesc=$P($g(^PHMNF(MRCManfId)),"^",2)
	s MRCManf=..sssComboStr(MRCManfId,MRCManfDesc)
	
	s Data=RowId_"^"_RegNo_"^"_InciDesc_"^"_..DL2H(ApprovalDate)_"^"_..DL2H(ValidUntil)
		_"^"_MRCCategory_"^"_MRCRegName_"^"_MRCRegPerAddress_"^"_MRCSpecForm
		_"^"_MRCStructure_"^"_MRCAppliedRange_"^"_MRCRemark_"^"_MRCRegAgent_"^"_MRCAgentAddress
		_"^"_MRCValidLong_"^"_MRCValidExtend_"^"_MRCManf_"^"_MRCManfId_"^"_MRCManfDesc
	s Title="MRCRowID^MRCNo^MRCInciDesc^MRCApprovalDate^MRCValidUntil"
		_"^MRCCategory^MRCRegName^MRCRegPerAddress^MRCSpecForm"
		_"^MRCStructure^MRCAppliedRange^MRCRemark^MRCRegAgent^MRCAgentAddress"
		_"^MRCValidLong^MRCValidExtend^MRCManf^MRCManfId^MRCManfDesc"
	s Ret=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Ret
}

/// 保存注册证信息
/// w ##class(web.DHCSTMHUI.DHCMatRegCert).jsSave(^templxt("save1"),^templxt("save2"))
ClassMethod jsSave(Params, ParamStr, RelaFlag As %String = "") As %String
{
	n (Params,ParamStr,RelaFlag)
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..save(Params, ParamStr,RelaFlag)
	i RtnObj.success'=0 q RtnObj.Json()
	q RtnObj.Json()
}

/// 保存注册证信息
ClassMethod save(Params, ParamStr, RelaFlag As %String = "") As RtnObj
{
	n (Params,ParamStr,RelaFlag)
	
	s RtnObj=##class(RtnObj).%New()
	s InciId=$p(ParamStr,"^",1)
	s ManfId=$p(ParamStr,"^",2)
	s HospId=$p(ParamStr,"^",3)
	i (InciId="") q RtnObj.Err(-2,"","库存项不存在!","",0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	
	s MRCRowID=PJObj.%Get("MRCRowID")
	s MRCNo=PJObj.%Get("MRCNo")
	s MRCCategory=PJObj.%Get("MRCCategory")
	s MRCRegName=PJObj.%Get("MRCRegName")
	s MRCRegPerAddress=PJObj.%Get("MRCRegPerAddress")
	s MRCRegAgent=PJObj.%Get("MRCRegAgent")
	s MRCAgentAddress=PJObj.%Get("MRCAgentAddress")
	s MRCInciDesc=PJObj.%Get("MRCInciDesc")
	s MRCSpecForm=PJObj.%Get("MRCSpecForm")
	s MRCStructure=PJObj.%Get("MRCStructure")
	s MRCAppliedRange=PJObj.%Get("MRCAppliedRange")
	s MRCRemark=PJObj.%Get("MRCRemark")
	s MRCApprovalDate=PJObj.%Get("MRCApprovalDate")
	s MRCValidUntil=PJObj.%Get("MRCValidUntil")
	s MRCValidExtend=PJObj.%Get("MRCValidExtend")
	s MRCMCDR=PJObj.%Get("MRCMCDR")
	s MRCSADR=PJObj.%Get("MRCSADR")
	s MRCManfId=PJObj.%Get("MRCManf")
	s:MRCManfId="" MRCManfId=ManfId
	s:MRCApprovalDate'="" MRCApprovalDate=..DH2L(MRCApprovalDate)
	s:MRCValidUntil'="" MRCValidUntil=..DH2L(MRCValidUntil)
	q:MRCNo="" RtnObj
	s MRCRowID=$o(^DHCMRCT(0,"NO",MRCNo,""),-1)
	ts
	i MRCRowID="" d
	.s obj=##class(User.DHCMatRegCert).%New()
	.s obj.MRCNo=MRCNo
	e   d
	.s obj=##class(User.DHCMatRegCert).%OpenId(MRCRowID)
	s obj.MRCCategory=MRCCategory
	s obj.MRCRegName=MRCRegName
	s obj.MRCRegPerAddress=MRCRegPerAddress
	s obj.MRCRegAgent=MRCRegAgent
	s obj.MRCAgentAddress=MRCAgentAddress
	s obj.MRCInciDesc=MRCInciDesc
	s obj.MRCSpecForm=MRCSpecForm
	s obj.MRCStructure=MRCStructure
	s obj.MRCAppliedRange=MRCAppliedRange
	s obj.MRCRemark=MRCRemark
	s obj.MRCApprovalDate=MRCApprovalDate
	s obj.MRCValidUntil=MRCValidUntil
	s obj.MRCValidExtend=MRCValidExtend
	d obj.MRCPHManfDRSetObjectId(MRCManfId)
	s sc=obj.%Save()
	i $$$ISERR(sc) d RtnObj.Err(-3,"","保存失败")
	q:RtnObj.success'=0 RtnObj
	s MRCRowID=obj.%Id()
	
	i RelaFlag="Y" d
	.s RelaRowId=$o(^User.DHCItmRegRelationsI("InciReg",InciId,MRCRowID,0))
	.i RelaRowId="" d
	..&sql(insert into DHC_ItmRegRelations(IRR_RegCert_DR,IRR_INCI_DR,IRR_MC_DR,IRR_SA_DR) values (:MRCRowID,:InciId,:MRCMCDR,:MRCSADR))
	..i SQLCODE'=0 tro  d RtnObj.Err(-4,"","注册证信息与物资关联失败")
	..s RelaRowId=%ROWID
	.q:RtnObj.success'=0
	.
	.i (MRCMCDR'="")||(MRCSADR'="") d
	..&sql(update DHC_ItmRegRelations set IRR_MC_DR=:MRCMCDR,IRR_SA_DR=:MRCSADR where %ID=:RelaRowId)
	..i SQLCODE'=0 tro  d RtnObj.Err(-5,"","注册证信息与物资关联失败")
	.q:RtnObj.success'=0
	.	
	.s AddInci=$o(^DHCITMINFO(0,"INCI",InciId,0))
	.i AddInci'="" d
	..&sql(update DHC_ItmAddionInfo set info_pbmanf_dr=:MRCManfId,INFO_MatRegCert_DR=:MRCRowID where info_inci_dr=:InciId)
	..i SQLCODE'=0 tro  d RtnObj.Err(-6,"","更新库存项生产厂家信息失败")
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	tc
	
	d ##class(web.DHCSTMHUI.ServiceForECS).updateHosInvCert(MRCRowID,HospId)
	
	s RtnObj.rowid=MRCRowID
	q RtnObj
}

/// 保存注册证信息与库存项的关联关系
ClassMethod saveItmRegRelations(Params) As RtnObj
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!")
	
	s MRCNo=PJObj.%Get("MRCNo")
	s InciId=PJObj.%Get("InciId")
	i (InciId="") q RtnObj.Err(-2,"","库存项不存在!","",0)
	s ManfId=PJObj.%Get("PbManfId")
	s HospId=PJObj.%Get("Hosp")
	q:MRCNo="" RtnObj
	ts
	s MRCRowID=$o(^DHCMRCT(0,"NO",MRCNo,""),-1)
	s RelaRowId=$o(^User.DHCItmRegRelationsI("InciReg",InciId,MRCRowID,0))
	i RelaRowId="" d
	.&sql(insert into DHC_ItmRegRelations(IRR_RegCert_DR,IRR_INCI_DR) values (:MRCRowID,:InciId))
	.i SQLCODE'=0 tro  d RtnObj.Err(-4,"","注册证信息与物资关联失败")
	.s RelaRowId=%ROWID
	q:RtnObj.success'=0 RtnObj
	
	s AddInci=$o(^DHCITMINFO(0,"INCI",InciId,0))
	i AddInci'="" d
	.&sql(update DHC_ItmAddionInfo set info_pbmanf_dr=:MRCManfId,INFO_MatRegCert_DR=:MRCRowID where info_inci_dr=:InciId)
	.i SQLCODE'=0 tro  d RtnObj.Err(-6,"","更新库存项生产厂家信息失败")
	q:RtnObj.success'=0 RtnObj
	
	tc
	d ##class(web.DHCSTMHUI.ServiceForECS).updateHosInvCert(MRCRowID,HospId)
	
	s RtnObj.rowid=MRCRowID
	q RtnObj
}

/// Descript:	查询物资历史注册证信息
/// Creator:	lxt
/// CreateDate:	2020-9-1
/// Table:		DHC_CertType
/// Input:		类型，查询条件
/// Return：	资质类型
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCMatRegCert","QueryInciRegHistory","8")
Query QueryInciRegHistory(Inci As %String) As Query(ROWSPEC = "Inci,RowId,MRCRowID,MRCNo,MRCInciDesc,MRCApprovalDate,MRCValidUntil,MRCCategory,MRCRegName,MRCRegPerAddress,MRCSpecForm,MRCStructure,MRCAppliedRange,MRCRemark,MRCRegAgent,MRCAgentAddress,MRCValidLong,MRCValidExtend,MRCManfId,MRCManfDesc") [ SqlProc ]
{
}

ClassMethod QueryInciRegHistoryExecute(ByRef qHandle As %Binary, Inci As %String) As %Status
{
	n (qHandle,Inci)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Inci="" $$$OK
	
	s RowId=0
	f  s RowId=$o(^User.DHCItmRegRelationsI("Inci",Inci,RowId)) q:RowId=""  d
	.s RelaInfo=^User.DHCItmRegRelationsD(RowId)
	.s MRCRowID=$lg(RelaInfo,2)
	.s MRCNo=$p(^DHCMRCT(MRCRowID),"^",12)
	.s MRCInciDesc=$p(^DHCMRCT(MRCRowID),"^",16)
	.s MRCApprovalDate=$p(^DHCMRCT(MRCRowID),"^",19)
	.s MRCValidUntil=$p(^DHCMRCT(MRCRowID),"^",20)
	.s MRCCategory=$p(^DHCMRCT(MRCRowID),"^",21)
	.s MRCRegName=$p(^DHCMRCT(MRCRowID),"^",13)
	.s MRCRegPerAddress=$p(^DHCMRCT(MRCRowID),"^",14)
	.s MRCSpecForm=$p(^DHCMRCT(MRCRowID),"^",17)
	.s MRCStructure=$p(^DHCMRCT(MRCRowID),"^",11)
	.s MRCAppliedRange=$p(^DHCMRCT(MRCRowID),"^",4)
	.s MRCRemark=$p(^DHCMRCT(MRCRowID),"^",18)
	.s MRCRegAgent=$p(^DHCMRCT(MRCRowID),"^",8)
	.s MRCAgentAddress=$p(^DHCMRCT(MRCRowID),"^",15)
	.s MRCValidLong=$p(^DHCMRCT(MRCRowID),"^",22)
	.s MRCValidExtend=$p(^DHCMRCT(MRCRowID),"^",23)
	.s (MRCManfDesc)=""
	.s MRCManfId=$p(^DHCMRCT(MRCRowID),"^",2)
	.s:(MRCManfId'="") MRCManfDesc=$P($g(^PHMNF(MRCManfId)),"^",2)
	.s MRCApprovalDate=..DL2H(MRCApprovalDate)
	.s MRCValidUntil=..DL2H(MRCValidUntil)
	.d OutPutRow1
	Quit $$$OK
OutPutRow1
	s Data=$lb(Inci,RowId,MRCRowID,MRCNo,MRCInciDesc,MRCApprovalDate,MRCValidUntil,MRCCategory,MRCRegName,
	MRCRegPerAddress,MRCSpecForm,MRCStructure,MRCAppliedRange,MRCRemark,MRCRegAgent,MRCAgentAddress,MRCValidLong,
	MRCValidExtend,MRCManfId,MRCManfDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 解除库存项与注册证关联
/// w ##class(web.DHCSTMHUI.DHCMatRegCert).jsDeleteRelation(^templxt("save1"),^templxt("save2"))
ClassMethod jsDeleteRelation(RowId) As %String
{
	n (RowId)
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..DeleteRelation(RowId)
	i RtnObj.success'=0 q RtnObj.Json()
	q RtnObj.Json()
}

/// 解除库存项与注册证关联
ClassMethod DeleteRelation(RowId) As RtnObj
{
	n (RowId)
	
	s RtnObj=##class(RtnObj).%New()
	q:RowId="" RtnObj.Err(-1,"","请选择关联","",0)
	
	&sql(delete from DHC_ItmRegRelations where %ID=:RowId)
	q:SQLCODE'=0 RtnObj.Err(-2,"","解除库存项与注册证关联失败")
	
	q RtnObj
}

/// 保存注册证信息
ClassMethod Update(InciId, MRCManfId, MRCNo, MRCValidUntil, UpdItmCertFlag) As RtnObj
{
	n (InciId, MRCManfId, MRCNo, MRCValidUntil,UpdItmCertFlag)
	s RtnObj=##class(RtnObj).%New()
	q:InciId="" RtnObj
	q:MRCNo="" RtnObj
	
	s MRCRowID=$o(^DHCMRCT(0,"NO",MRCNo,""),-1)
	i MRCRowID="" d
	.s obj=##class(User.DHCMatRegCert).%New()
	.s obj.MRCNo=MRCNo
	e   d
	.s obj=##class(User.DHCMatRegCert).%OpenId(MRCRowID)
	s obj.MRCValidUntil=MRCValidUntil
	d obj.MRCPHManfDRSetObjectId(MRCManfId)
	s sc=obj.%Save()
	i $$$ISERR(sc) d RtnObj.Err(-3,"","保存注册证信息失败")
	q:RtnObj.success'=0 RtnObj
	s MRCRowID=obj.%Id()
	
	s RelaRowId=$o(^User.DHCItmRegRelationsI("InciReg",InciId,MRCRowID,0))
	i RelaRowId="" d
	.&sql(insert into DHC_ItmRegRelations(IRR_RegCert_DR,IRR_INCI_DR,IRR_MC_DR,IRR_SA_DR) values (:MRCRowID,:InciId,:MRCMCDR,:MRCSADR))
	.i SQLCODE'=0 tro  d RtnObj.Err(-4,"","注册证信息与物资关联失败")
	.s RelaRowId=%ROWID
	q:RtnObj.success'=0 RtnObj
	
	s AddInci=$o(^DHCITMINFO(0,"INCI",InciId,0))
	q:AddInci="" RtnObj
	
	s TmpRegId=$p($g(^DHCITMINFO(AddInci,1)),"^",18)
	q:(TmpRegId'="")&&(UpdItmCertFlag'="Y") RtnObj
	
	&sql(update DHC_ItmAddionInfo set INFO_MatRegCert_DR=:MRCRowID,info_pbmanf_dr=:MRCManfId where info_inci_dr=:InciId)
	i SQLCODE'=0 tro  d RtnObj.Err(-6,"","更新库存项注册证信息失败")
	q:RtnObj.success'=0 RtnObj
	
	s RtnObj.rowid=MRCRowID
	q RtnObj
}

}
