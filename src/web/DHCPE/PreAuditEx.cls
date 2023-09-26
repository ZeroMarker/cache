Class web.DHCPE.PreAuditEx Extends %RegisteredObject
{

/// 金额拆分
/// w ##class(web.DHCPE.PreAuditEx).SplitAudit("","G","296","","信息中心")
ClassMethod SplitAudit(PreAuditID, AdmType, PreAdmID, PreStatus, DepartName)
{
	s ^temp("DHCPE","SplitAudit")=$lb(PreAuditID, AdmType, PreAdmID, PreStatus, DepartName)
	i AdmType="G" d
	.s AdmID=$O(^DHCPEGADM(0,"CRMGADM",PreAdmID,0))
	e  d
	.s AdmID=$O(^DHCPEIADM(0,"CRMADM",PreAdmID,0))
	s SplitAmt=$P(DepartName,"^",2)
	s DepartName=$P(DepartName,"^",1)
	s Remark=..GetAuditRemark(PreStatus, DepartName)
	s:+SplitAmt'=0 Remark="定额拆分"_SplitAmt_","_Remark
	s SplitAmt=+SplitAmt
	
	s $ZT="SplitErr"
	TSTART
	&SQL(Insert Into Sqluser.DHC_PE_PreAudit (PA_ADMType,PA_CRMADM,PA_GIADM,PA_AuditedStatus,PA_ChargedStatus,PA_Remark,PA_PrivilegeMode,PA_Type,PA_Status) values
			(:AdmType,:PreAdmID,:AdmID,'NoAudited','UNCHARGED',:Remark,'NP','PRE','U'))
	i SQLCODE'=0{
		TROLLBACK
		q "-1^插入预约类型的审核记录失败"_SQLCODE
	}
	s PreAudit=%ROWID
	&SQL(Insert Into Sqluser.DHC_PE_PreAudit (PA_ADMType,PA_CRMADM,PA_GIADM,PA_AuditedStatus,PA_ChargedStatus,PA_Remark,PA_PrivilegeMode,PA_Type,PA_Status) values
			(:AdmType,:PreAdmID,:AdmID,'NoAudited','UNCHARGED',:Remark,'NP','ADD','U'))
	i SQLCODE'=0{
		TROLLBACK
		q "-1^插入加项类型的审核记录失败"_SQLCODE
	}
	s AddAudit=%ROWID
	
	s QFlag=0
	s TotalAmt=0
	s Audit=0
	f  s Audit=$O(^DHCPEPreA(0,"CRMADM",AdmType,PreAdmID,Audit)) q:(Audit="")||(SQLCODE'=0)||(QFlag=1)  d
	.q:Audit=PreAudit
	.q:Audit=AddAudit
	.q:(PreAuditID'="")&&(PreAuditID'=Audit)
	.s OldRemark=$P($g(^DHCPEPreA(Audit)),"^",18)
	.s ChargedStatus=$P($g(^DHCPEPreA(Audit)),"^",14)
	.q:ChargedStatus="CHARGED"
	.s Status=$P($g(^DHCPEPreA(Audit)),"^",21)
	.q:Status="NU"
	.q:OldRemark["定额拆分"
	.s AuditType=$P($g(^DHCPEPreA(Audit)),"^",20)
	.i AuditType="PRE" d
	..s NewAudit=PreAudit
	.e  d
	..s NewAudit=AddAudit
	.s preAdmId=0
	.f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",Audit,preAdmId)) q:(preAdmId="")||(SQLCODE'=0)||(QFlag=1)  d
	..s Status=$P($g(^DHCPEPreIADM(preAdmId)),"^",8)
	..q:(PreStatus'="")&&(PreStatus'[("^"_Status_"^"))
	..s Depart=##class(web.DHCPE.PreCommon).GetPosition("PreADM",preAdmId)
	..q:(DepartName'="")&&(DepartName'=Depart)
	..s childsub=0
	..f  s childsub=$o(^DHCPEPreIADM(0,"PAORDITEM",Audit,preAdmId,childsub)) q:(childsub="")||(SQLCODE'=0)||(QFlag=1)  d
	...;q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",2)'=""	//判断是否是套餐中的项目
	...q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",16)'=1	//判断是否有效
	...//按项目拆分时可以增加判断
	...s FSub=0
	...f  s FSub=$o(^DHCPEPreIADM(0,"PAORDITEM",Audit,preAdmId,childsub,FSub)) q:(FSub="")||(SQLCODE'=0)||(QFlag=1)  d
	....s FeeID=preAdmId_"||"_childsub_"||"_FSub
	....s FeeAmt=$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub,"FEE",FSub)),"^",2)
	....s TotalAmt=TotalAmt+FeeAmt
	....i (SplitAmt=0)||(TotalAmt<=SplitAmt) d
	.....&SQL(update Sqluser.DHC_PE_PreIOrdItemFee set PIOIF_PAudit_DR=:NewAudit where PIOIF_RowID=:FeeID)
	.....s:(SplitAmt'=0)&&(TotalAmt=SplitAmt) QFlag=1
	....e  d
	.....k NewPLIST
	.....s NewAmt=TotalAmt-SplitAmt
	.....&SQL(Select * into :NewPLIST() from Sqluser.DHC_PE_PreIOrdItemFee where PIOIF_RowID=:FeeID)
	.....k NewPLIST(1)
	.....k NewPLIST(2)
	.....s NewPLIST(7)=NewAudit
	.....&SQL(update Sqluser.DHC_PE_PreIOrdItemFee set PIOIF_FactAmount=:NewAmt,PIOIF_AccountAmount=:NewAmt where PIOIF_RowID=:FeeID)
	.....q:SQLCODE'=0
	.....s ReAmt=NewPLIST(4)-NewAmt
	.....s NewPLIST(4)=$FN(ReAmt,"",2)
	.....s NewPLIST(11)=$FN(ReAmt,"",2)
	.....&SQL(insert into Sqluser.DHC_PE_PreIOrdItemFee values :NewPLIST())
	.....q:SQLCODE'=0
	.....s QFlag=1
	.q:SQLCODE'=0
	.s preAdmId=0
	.f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDENT",Audit,preAdmId)) q:(preAdmId="")||(SQLCODE'=0)||(QFlag=1)  d
	..s Status=$P(^DHCPEPreIADM(preAdmId),"^",8)
	..q:(PreStatus'="")&&(PreStatus'[("^"_Status_"^"))
	..s Depart=##class(web.DHCPE.PreCommon).GetPosition("PreADM",preAdmId)
	..q:(DepartName'="")&&(DepartName'=Depart)
	..s childsub=0
	..f  s childsub=$o(^DHCPEPreIADM(0,"PAORDENT",Audit,preAdmId,childsub)) q:(childsub="")||(SQLCODE'=0)||(QFlag=1)  d
	...q:$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",9)'=1	//判断是否有效
	...//按项目拆分时可以增加判断
	...s FSub=0
	...f  s FSub=$o(^DHCPEPreIADM(0,"PAORDENT",Audit,preAdmId,childsub,FSub)) q:(FSub="")||(SQLCODE'=0)||(QFlag=1)  d
	....s FeeID=preAdmId_"||"_childsub_"||"_FSub
	....s FeeAmt=$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub,"FEE",FSub)),"^",2)
	....s TotalAmt=TotalAmt+FeeAmt
	....i (SplitAmt=0)||(TotalAmt<=SplitAmt) d
	.....&SQL(update Sqluser.DHC_PE_PreIOrdEntFee set PIOEF_PAudit_DR=:NewAudit where PIOEF_RowID=:FeeID)
	.....s:(SplitAmt'=0)&&(TotalAmt=SplitAmt) QFlag=1
	....e  d
	.....k NewEntPLIST
	.....s NewAmt=TotalAmt-SplitAmt
	.....&SQL(Select * into :NewEntPLIST() from Sqluser.DHC_PE_PreIOrdEntFee where PIOEF_RowID=:FeeID)
	.....k NewEntPLIST(1)
	.....k NewEntPLIST(2)
	.....s NewEntPLIST(7)=NewAudit
	.....&SQL(update Sqluser.DHC_PE_PreIOrdEntFee set PIOEF_FactAmount=:NewAmt,PIOEF_AccountAmount=:NewAmt where PIOEF_RowID=:FeeID)
	.....q:SQLCODE'=0
	.....s ReAmt=NewEntPLIST(4)-NewAmt
	.....s NewEntPLIST(4)=$FN(ReAmt,"",2)
	.....s NewEntPLIST(11)=$FN(ReAmt,"",2)
	.....&SQL(insert into Sqluser.DHC_PE_PreIOrdEntFee values :NewEntPLIST())
	.....q:SQLCODE'=0
	.....s QFlag=1
	i SQLCODE'=0{
		TROLLBACK
		q "-1^更新费用记录失败"_SQLCODE
	}
	i AdmType="G"{
		d ##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(PreAdmID,"1")
	}else{
		d ##class(web.DHCPE.PreIADM).UpdatePersonAuditAmount(PreAdmID)
	}
	TCOMMIT
	q "0^拆分成功"
SplitErr
	TROLLBACK
	q "-1^错误" //_$System.Status.DisplayError(status)
}

// w ##class(web.DHCPE.PreAuditEx).GetAuditRemark("","信息中心")

ClassMethod GetAuditRemark(PreStatus, DepartName)
{
	s Length=$L(PreStatus,"^")
	s Status=""
	f i=1:1:Length d
	.s OneStatu=$P(PreStatus,"^",i)
	.q:OneStatu=""
	.s OneStatu=##Class(web.DHCPE.PreCommon).TransStatus(OneStatu)
	.i Status="" d
	..s Status=OneStatu
	.e  d
	..s Status=Status_","_OneStatu
	q:DepartName="" Status
	i Status="" d
	.s Status=DepartName
	e  d
	.s Status=DepartName_","_Status
	q Status
}

}
