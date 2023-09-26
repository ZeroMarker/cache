/// Created by SongDeBo 2006/6/25
/// Description: 对团体/个人的审核
Class web.DHCPE.PreAdmAudit Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

/// 获取团体或个人的 应收金额、打折金额、最终金额
/// parameter:
/// 			AdmType:"PERSON"/"GROUP"
/// 			查看类型: "个人"/"团体"
/// return:		AccountAmount^DiscountAmount^aactAmount
/// test:		w ##class(web.DHCPE.PreAdmAudit).IGetAdmAmount(4,"GROUP")
ClassMethod IGetAdmAmount(AdmId, AdmType)
{
	;s ^Bob("temp",$zn,2)=AdmId_"  "_AdmType
	q:((AdmId="")||(AdmType="")) "^^"
	s accountAmount=0,discountAmount=0,factAmount=0,SaleAmount=0
	s strSql=""
	if AdmType="PERSON" {
		//s accountAmount=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Person(AdmId)
		s objAdm=##class(User.DHCPEPreIADM).%OpenId(AdmId)
		/*0331
		s accountAmount=objAdm.PIADMAccountAmount
		s discountAmount=objAdm.PIADMDiscountedAmount
		s SaleAmount=objAdm.PIADMSaleAmount
		s factAmount=objAdm.PIADMFactAmount
		*/
		
	}elseif AdmType="GROUP"{
		//s accountAmount=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Grp(AdmId)
		s objAdm=##class(User.DHCPEPreGADM).%OpenId(AdmId)
		/*0331
		s accountAmount=objAdm.PGADMAccountAmount
		s discountAmount=objAdm.PGADMDiscountedAmount
		s SaleAmount=objAdm.PGADMSaleAmount
		s factAmount=objAdm.PGADMFactAmount
		*/
	}
	
	s accountAmount=(+accountAmount), discountAmount=+discountAmount, factAmount=+factAmount

	s retVal=accountAmount_"^"_discountAmount_"^"_SaleAmount_"^"_factAmount
	
	;s ^Bob("temp",$zn,1)=retVal
	q retVal
}

/* 宋德波 写
ClassMethod IDoAudit(AdmId, AdmType, FactAmount, AuditUserId)
{
	q:((AdmId="")||(AdmType="")||(FactAmount="")) "ERROR:The arguments are not complete in "_$zn
	s retVal=""
	TSTART
	if AdmType="PERSON"{
		s objAdm=##class(User.DHCPEPreIADM).%OpenId(AdmId)
		//q:objAdm.PIADMStatus'="PREREG" "ERROR: The Status is not preReg of person "_AdmId_ "  "_$zn
		s objAdm.PIADMFactAmount=FactAmount
		s objAdm.PIADMStatus="CHECKED"
		s objAdm.PIADMAuditUserDR=AuditUserId //PIADMAuditUserDR
		s objAdm.PIADMAuditDate=+$H
		d objAdm.%Save()
	}elseif AdmType="GROUP"{
		s objAdm=##class(User.DHCPEPreGADM).%OpenId(AdmId)
		q:objAdm.PGADMStatus'="PREREG" "ERROR: The Status is not preReg of GROUP "_AdmId_ "  "_$zn
		s today=+$h
		s objAdm.PGADMFactAmount=FactAmount
		s objAdm.PGADMStatus="CHECKED"
		s objAdm.PGADMAuditUserDR=AuditUserId
		s objAdm.PGADMAuditDate=today
		d objAdm.%Save()
		&sql(update SQLUSER.dhc_pe_preiadm 
				set PIADM_AuditUser_dr=:AuditUserId, piadm_AuditDate=:today, piadm_status='CHECKED' 
				where  piadm_pgadm_dr=:AdmId)
		i ((SQLCODE'=0)&&(SQLCODE'=100))  s retVal="Update dhc_pe_PreIAdm wrong, SQLCODE="_SQLCODE  goto ErrorHandler
	}
	TCOMMIT
	q ""
ErrorHandler
	TROLLBACK
	q retVal
}
*/
/// 审核 团体/个人预约	
/// parameter: 
/// 		AdmType:"TEAM"/"GROUP"
/// 	Return: ""-OK, else: ErrorInformation
/// 	test: w ##class(web.DHCPE.PreAdmAudit).IDoAudit(31,"PERSON",55,1)
ClassMethod IDoAudit(AdmId, AdmType, FactAmount, AuditUserId)
{
	q:((AdmId="")||(AdmType="")||(FactAmount="")) "ERROR:The arguments are not complete in "_$zn
	
	s retVal=""

	if AdmType="PERSON" d
	.s retVal=##class(web.DHCPE.PreIADM).AuditAdm(AdmId,"",FactAmount,AuditUserId)

	if AdmType="GROUP" d
	.b //IDoAudit.GROUP
	.s retVal=##class(web.DHCPE.PreGADM).AuditAdm(AdmId,FactAmount,AuditUserId)
	
	Q retVal
}

/// 	放弃审核 团体/个人预约
/// parameter: 
/// 		AdmType:"TEAM"/"GROUP"
/// 	Return: ""-OK, else: ErrorInformation
/// 	test: w ##class(web.DHCPE.PreAdmAudit).ICancelAudit(31,"PERSON",55,1)
ClassMethod ICancelAudit(AdmId, AdmType, AuditUserId)
{
	q:((AdmId="")||(AdmType="")||(AuditUserId="")) "ERROR:The arguments are not complete in "_$zn
	s retStr=""
	TSTART
	if AdmType="PERSON"{
		s objAdm=##class(User.DHCPEPreIADM).%OpenId(AdmId)
		q:objAdm.PIADMStatus'="CHECKED" "ERROR: The Status is not preReg of person "_AdmId_ "  "_$zn
		s objAdm.PIADMStatus="PREREG"
		d objAdm.%Save()
	}elseif AdmType="GROUP"{
		s objAdm=##class(User.DHCPEPreGADM).%OpenId(AdmId)
		q:objAdm.PGADMStatus'="CHECKED" "ERROR: The Status is not preReg of GROUP "_AdmId_ "  "_$zn
		s objAdm.PGADMStatus="PREREG"
		d objAdm.%Save()
		&sql(update SQLUSER.dhc_pe_preiadm 
				set piadm_status='PREREG' 
				where  piadm_pgadm_dr=:AdmId)
		i ((SQLCODE'=0)&&(SQLCODE'=100))  s retVal="Update dhc_pe_PreIAdm wrong, SQLCODE="_SQLCODE  goto ErrorHandler
	}
	TCommit
	q ""
	
ErrorHandler
	Trollback
	q retVal
}

}
