Import sqluser

/// 名称: 物资注册证信息导入
/// 编写者: tsr
/// 编写日期: 2017-08-22
Class web.DHCSTMHUI.Tools.ItmManfCertInputNew Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// 处理一行数据
/// 物资代码^物资名称^生产厂家^注册证号^注册证效期^注册证名称^注册证发证日期^注册证延期效期标志
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
	s Code=RowObj.%Get("物资代码")
	i Code="" d RtnObj.Err(-1,"","物资代码为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s Desc=RowObj.%Get("物资名称")
	i Desc="" d RtnObj.Err(-1,"","物资名称为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s IncId="",IncIdByDesc="",Manf=""
	;s IncId=$o(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(Code)_"Z",""))
	s IncId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("CODE",Code,"INC_Itm",HospId)
	i IncId="" d RtnObj.Err(-1,"","此物资代码无效!","",0)
	q:RtnObj.success'=0 RtnObj
	;s IncIdByDesc=$o(^INCI(0,"Desc1",$$ALPHAUP^SSUTIL4(Desc)_"Z",""))
	s IncIdByDesc=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("DESC",Desc,"INC_Itm",HospId)
	i IncIdByDesc="" d RtnObj.Err(-1,"","此物资名称无效","",0)
	q:RtnObj.success'=0 RtnObj
	i IncId'=IncIdByDesc d RtnObj.Err(-1,"","此物资代码与名称不匹配","",0)
	q:RtnObj.success'=0 RtnObj
	s Phmanf=RowObj.%Get("生产厂家")
	i Phmanf="" d RtnObj.Err(-1,"","生产厂家为空!","",0)
	q:RtnObj.success'=0 RtnObj	
	s Manf=..ValidManf(Phmanf,HospId)
	i +Manf<0 d RtnObj.Err(-1,"","插入生产厂家错误")
	q:RtnObj.success'=0 RtnObj		
	&sql(UPDATE DHC_ItmAddionInfo SET INFO_PbManf_DR = :Manf WHERE INFO_INCI_DR=:IncId)
	i SQLCODE'=0 d RtnObj.Err(-1,"","更新生产厂家错误:")
	q:RtnObj.success'=0 RtnObj		
	s CertNo=RowObj.%Get("注册证号")
	i CertNo="" d RtnObj.Err(-1,"","注册证号为空","",0)
	q:RtnObj.success'=0 RtnObj	
	s CertNoExpDate=RowObj.%Get("注册证效期")
	s CertItmDesc=RowObj.%Get("注册证名称")
	s CertDateOfIssue=RowObj.%Get("注册证发证日期")
	s CertExpDateExtended=RowObj.%Get("注册证延长效期标志")
	s CertExpDateExtended=$s((CertExpDateExtended="Y")||(CertExpDateExtended="是"):"Y",(CertExpDateExtended="N")||(CertExpDateExtended="否"):"N",1:"N") 
	s RtnObj=..InsertItmManfCert(IncId,Manf,CertNo,CertNoExpDate,CertItmDesc,CertDateOfIssue,CertExpDateExtended)	
	q RtnObj
}

/// 验证生产厂家
/// tsr
/// 2017-08-24
ClassMethod ValidManf(Manf As %String, HospId As %String) As %String
{
 	n (Manf,HospId)
	q:Manf="" ""
	s Type=..sssCode()
	s err=0,Rowid="",msg="",Ma=""

 	//&sql(select phmnf_rowid into :Rowid from ph_manufacturer where phmnf_name=:Manf)
 	s Rowid=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",Manf,"PH_Manufacturer",HospId)
	i +Rowid'>0 d
 	.&sql(insert into ph_manufacturer(phmnf_code,phmnf_name) values (:Manf,:Manf))
	.i SQLCODE'=0 d
	..s err=-1
	..s msg=err_"插入ph_manufacturer错误:"_SQLCODE
	.q:err'=0
	.s Rowid=$p($g(%ROWID),$c(1))
	q:err'=0 msg
 	
	&sql(select manf_rowid into :Ma from  dhc_manf_addioninfo where manf_phcmanf_dr=:Rowid)
	i SQLCODE d
 	.s Active="Y"
 	.&sql(insert into dhc_manf_addioninfo (manf_phcmanf_dr,manf_type,manf_active) values (:Rowid,:Type,:Active))
	.i SQLCODE'=0 d
	..s err=-2
	..s msg=err_"插入dhc_manf_addioninfo错误:"_SQLCODE
	.q:err'=0
	.s Ma=$p($g(%ROWID),$c(1))
	q:err'=0 msg
	s err=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("PH_Manufacturer",Rowid,HospId)
	i err'=0 s msg=err_"生产厂家院区授权失败"
	q:err'=0 msg
	q Rowid
}

ClassMethod InsertItmManfCert(IncId As %String, Manf As %String, CertNo As %String, CertNoExpDate As %String, CertItmDesc As %String, CertDateOfIssue As %String, CertExpDateExtended As %String) As %String
{
	n (IncId,Manf,CertNo,CertNoExpDate,CertItmDesc,CertDateOfIssue,CertExpDateExtended)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s:CertDateOfIssue'="" CertDateOfIssue=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(CertDateOfIssue)
	s:CertNoExpDate'="" CertNoExpDate=##class(web.DHCSTMHUI.Tools.CommonInput).vDate(CertNoExpDate)
	i +CertDateOfIssue<0 d RtnObj.Err(-21,"","注册证发证日期格式不正确!","",0)
	q:RtnObj.success'=0 RtnObj
	i +CertNoExpDate<0 d RtnObj.Err(-21,"","注册证效期格式不正确!","",0)
	q:RtnObj.success'=0 RtnObj
	;获取注册证Id
	s regTitle="MRCNo^MRCApprovalDate^MRCValidUntil^MRCInciDesc^MRCValidExtend^MRCMCDR"
	s regData=CertNo_"^"_CertDateOfIssue_"^"_CertNoExpDate_"^"_CertItmDesc_"^"_CertExpDateExtended_"^"_""
	s regObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(regData,regTitle)
	s paramstr=IncId_"^"_Manf
	s RtnObj=##class(web.DHCSTMHUI.DHCMatRegCert).save(regObj,paramstr)
	q:RtnObj.success'=0 RtnObj
	
	;DHC_ItmManfCert
	s Date=+$h
	s Time=$p($h,",",2)
	s Active="Y",user="demo",UserId=""
	&sql(SELECT SSUSR_RowId INTO:UserId FROM SS_User WHERE SSUSR_Initials=:user)
	s RowId=""
	&sql(select imc_rowid into :RowId from DHC_ItmManfCert where IMC_MANF_DR=:Manf and nvl(IMC_CertNo,'')=nvl(:CertNo,''))
	i 'SQLCODE d
	.&sql(update DHC_ItmManfCert set 
    	IMC_MANF_DR=:Manf,IMC_CertNo=:CertNo,IMC_CertExpDate=:CertNoExpDate,IMC_Date=:Date,
    	IMC_Time=:Time,IMC_SSUSR_DR=:UserId,IMC_Active=:Active where IMC_RowId=:RowId)
    e  d
    .&sql(insert into DHC_ItmManfCert
		(IMC_MANF_DR,IMC_CertNo,IMC_CertExpDate,IMC_Date,IMC_Time,IMC_SSUSR_DR,IMC_Active)
    	values (:Manf,:CertNo,:CertExpDate,:Date,:Time,:UserId,:Active))
    i SQLCODE'=0 d RtnObj.Err(-1,"","处理注册证信息失败:"_SQLCODE)
    q:RtnObj.success'=0 RtnObj
	q RtnObj
}

}
