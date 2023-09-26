Class web.DHCPE.PreAudit Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 144;

/// Debug: w ##class(web.DHCPE.PreAudit).GetAPAmountByIADM("G","169")
ClassMethod GetAPAmountByIADM(Type, IADM)
{
	q:IADM="" ""
	
	i Type="I" d
	.s ID=$p(^DHCPEIADM(IADM),"^",4)
	.s BaseID=$P($G(^DHCPEPreIADM(ID)),"^",1)
	.s RegNo=$P($G(^DHCPEPreIBI(BaseID)),"^",1)
	e  d
	.s ID=$p(^DHCPEGADM(IADM),"^",2)
	.s BaseID=$P($G(^DHCPEPreGADM(ID)),"^",1)
	.s RegNo=$P($G(^DHCPEPreGBI(BaseID)),"^",13)
	//s APID=$O(^DHCPEAP(0,"RegNo",RegNo,0))
	s Amount="0.00"
	s APID=0
	f  s APID=$O(^DHCPEAP(0,"RegNo",RegNo,APID)) q:APID=""  d
	.q:APID="" 
	.q:1=##class(web.DHCPE.AdvancePayment).IsCurLocCard(APID) 
	.s Amount=$P($G(^DHCPEAP(APID)),"^",4)
	.i ((Amount[".")&&(Amount'="")) d
	..i $p(Amount,".",1)="" s Amount=0_Amount

	q "余"_Amount
}

ClassMethod GetDJAmount(CardNo, LocID As %Library.String = "")
{
	i LocID="" d
	.s:$D(%session) LocID=%session.Get("LOGON.CTLOCID")
	.s:'$D(%session) LocID=304
	q:CardNo="" ""
	s APID=$O(^DHCPEAP(0,"CardNo",CardNo,0))
	q:APID="" "0.00"
	s IsCurLocCard=##class(web.DHCPE.AdvancePayment).IsCurLocCard(APID,LocID)
	q:IsCurLocCard="1" "-1^该卡在本科室没使用权限!"
	s EndLineDate=$P($G(^DHCPEAP(APID)),"^",14)
	q:(EndLineDate'="")&&(EndLineDate<+$H) "-1^该卡已过截止日期，不允许结算!"
	s Amount=$P($G(^DHCPEAP(APID)),"^",4)
	i ((Amount[".")&&(Amount'="")) d
	.i $p(Amount,".",1)="" s Amount=0_Amount
	s Rebate=$P($G(^DHCPEAP(APID)),"^",15)
	i Rebate'="" s Amount=Amount_"/"_Rebate_"%"

	q "0^余"_Amount
}

ClassMethod GetPreAuditInfo(AuditID)
{
	new AInfo
	i AuditID="" q ""
	s AInfo=$g(^DHCPEPreA(AuditID))
	q AInfo
}

/// Description:  更新体检审核表数据
/// Input:        Type(Update:更新,Audited:审核,CancelAudited:取消审核), RowId(审核ID)
///               AInfo(待更新的审核信息串)
/// Return：      0(成功),非0(失败)
/// Dubug:  d ##class(web.DHCPE.PreAudit).UpdatePreAudit()
ClassMethod UpdatePreAudit(Type, RowId, AInfo)
{
	new PLIST,i,OldPriMode,OldRebate,PriMode,Rebate,Return
	s (OldPriMode,OldRebate,PriMode,Rebate)=""
	s PriModeNew="",SaleAmount=""
	i Type'="Update"
	{
		i Type="Audited" s i=0
		i Type="CancelAudited" s i=4
		s PLIST(11)=Type
		s PLIST(12+i)=%session.Get("LOGON.USERID")
		s PLIST(13+i)=+$H
		s PLIST(14+i)=$p($h,",",2)
	}
	else
	{
		//s OldRebate=$p($G(^DHCPEPreAudit(RowId)),"^",5)
		//s OldPriMode=$p($G(^DHCPEPreAudit(RowId)),"^",19)
		s OldRebate=$p($G(^DHCPEPreA(RowId)),"^",5)
		s OldPriMode=$p($G(^DHCPEPreA(RowId)),"^",19)
		s PLIST(5)=$p(AInfo,"^",1)
		s PLIST(6)=$p(AInfo,"^",2)
		s Rebate=PLIST(6)
		s PLIST(9)=$p(AInfo,"^",3)
		s PLIST(10)=$p(AInfo,"^",4)
		s PLIST(19)=$p(AInfo,"^",5)
		s PriModeNew=$p(AInfo,"^",6)
		s PLIST(20)=$p(AInfo,"^",6)
		i PLIST(20)="OS" s PLIST(20)="OR"
		s PriMode=PLIST(20)
	}  
	TSTART
	s SQLCODE=0
	&SQL(update sqluser.DHC_PE_PreAudit values :PLIST() where PA_RowId=:RowId)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	if Type="Update"
	{
		i (PriMode'=OldPriMode)||((PriMode="OR")&&(OldRebate'=Rebate))
		{
			s SQLCODE=..UpdateGItem(RowId,PriMode,Rebate)
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
			///如果是项目优惠不修改价格
			///s SQLCODE=..UpdateAmount(RowId,PriMode,Rebate)
			i PriMode'="OP" s SQLCODE=..UpdateAmount(RowId,PriMode,Rebate)
		}
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		//s PLIST(7)=$p(Return,"^",3)
		//s PLIST(8)=$p(Return,"^",2)
		//i PLIST(8)=0 s PLIST(8)=""
		//i (PriMode'="TP") s PLIST(10)=PLIST(8)
		//i PLIST(7)=PLIST(10) s PLIST(11)="NoAudited"
		//优惠方式为总价优惠或折扣优惠自动设置状态为  审核
		//i (PriMode'="TP"||PriMode'="RP") s PLIST(11)="Audited"
	}

	s AType=$p($g(^DHCPEPreA(RowId)),"^",1)
	s GID=$p($g(^DHCPEPreA(RowId)),"^",2)
	s PGID=$p($g(^DHCPEPreA(RowId)),"^",3)
	
	s CRMTeam=$p($g(^DHCPEPreA(RowId)),"^",22)
	s:CRMTeam="" CRMTeam=RowId
	
	if Type="Update"{
		i (PriMode'=OldPriMode)||((PriMode="OR")&&(OldRebate'=Rebate)){
			i AType="G" d ##class(web.DHCPE.GAdmRecordManager).Insert(PGID,"I","TeamDisCount","",CRMTeam_"^"_Rebate_"^"_RowId_"^"_PriModeNew)
			i AType="I" d ##class(web.DHCPE.AdmRecordManager).Insert(PGID,"I","Discount","",Rebate_"^"_PriModeNew_"^"_RowId)
	
		}
	}
	
	i AType="G"
	{
		i GID="" s GID=$p($g(^DHCPEGADM(PGID)),"^",2)
		s SQLCODE=##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(GID,"1")
		//d ..UpdateGroupAuditWuCha(GID)
	}
	else
	{
		i GID="" s GID=$p($g(^DHCPEIADM(PGID)),"^",6)
		s SQLCODE=##class(web.DHCPE.PreIADM).UpdatePersonAuditAmount(GID) 
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	i PriModeNew="OS"{
		s SaleAmount=$p($g(^DHCPEPreA(RowId)),"^",8)
		s FactAmount=$p($g(^DHCPEPreA(RowId)),"^",9)
		s WUCha=FactAmount-SaleAmount
		&SQL(update sqluser.DHC_PE_PreAudit set PA_FactAmount=PA_SaleAmount,PA_DiscountedAmount=PA_SaleAmount where PA_RowID=:RowId)
		s QFlag=0
		s preAdmId=0
		f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",RowId,preAdmId)) q:((preAdmId="")||(QFlag=1))  d
		.s childsub=0
		.f  s childsub=$o(^DHCPEPreIADM(0,"PAORDITEM",RowId,preAdmId,childsub)) q:((childsub="")||(QFlag=1))  d
		..//注：iMedical8.5套餐价格已存在项目价格表，需注释掉该行代码；iMedical8.5以前的版本不需要注释
		..//q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",2)'=""	//判断是否是套餐中的项目
		..q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",16)'=1	//判断是否有效
		..s FSub=0
		..f  s FSub=$o(^DHCPEPreIADM(0,"PAORDITEM",RowId,preAdmId,childsub,FSub)) q:((FSub="")||(QFlag=1))  d
		...s FactAmount=+$p($G(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub,"FEE",FSub)),"^",2)
		...q:FactAmount=0
		...i FactAmount-WUCha>0 d
		....s $p(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub,"FEE",FSub),"^",2)=FactAmount-WUCha
		....s QFlag=1
		
				
		/***注：iMedical8.5及以后版本套餐价格已存在体检医嘱项目价格表DHC_PE_PreIOrdItemFee，索引^DHCPEPreIADM(0,"PAORDENT")没数据，不走下面的代码；***/
		/***注: iMedical8.5以前的版本，索引^DHCPEPreIADM(0,"PAORDENT")有数据，走下面的代码***/
		s preAdmId=0
		f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDENT",RowId,preAdmId)) q:((preAdmId="")||(QFlag=1))  d
		.s childsub=0
		.f  s childsub=$o(^DHCPEPreIADM(0,"PAORDENT",RowId,preAdmId,childsub)) q:((childsub="")||(QFlag=1))  d
		..//q:$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",1)'=""	//判断是否是套餐中的项目
		..q:$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",childsub)),"^",9)'=1	//判断是否有效
		..s FSub=0
		..f  s FSub=$o(^DHCPEPreIADM(0,"PAORDENT",RowId,preAdmId,childsub,FSub)) q:((FSub="")||(QFlag=1))  d
		...s FactAmount=+$p($G(^DHCPEPreIADM(preAdmId,"ORDENT",childsub,"FEE",FSub)),"^",2)
		...q:FactAmount=0
		...i FactAmount-WUCha>0 d
		....s $p(^DHCPEPreIADM(preAdmId,"ORDENT",childsub,"FEE",FSub),"^",2)=FactAmount-WUCha
		....s QFlag=1
	}
	
	
	TCOMMIT
	q SQLCODE
}

// d ##class(web.DHCPE.PreAudit).UpdateAmount("1613","OR","80")

/// 修改费用纪录
ClassMethod UpdateAmount(ARowID, PrivilegeMode1, Rebate1)
{
	n (ARowID, PrivilegeMode1, Rebate1)
	
	i PrivilegeMode1="" s PrivilegeMode1=$p(^DHCPEPreA(ARowID),"^",19)
    i Rebate1="" s Rebate1=$p(^DHCPEPreA(ARowID),"^",5)
	s Job=$J
	k ^TempDHCPE("UpdateAmount",Job)
	s SQLCODE=0
	s iAdm=0
	f  s iAdm=$o(^DHCPEPreIADM(0,"PAORDITEM",ARowID,iAdm)) q:(iAdm="")||(SQLCODE'=0)  d
	.s tSub=0
	.f  s tSub=$o(^DHCPEPreIADM(0,"PAORDITEM",ARowID,iAdm,tSub)) q:(tSub="")||(SQLCODE'=0)  d
	..///排除无效的
	..s Flag=$p(^DHCPEPreIADM(iAdm,"ORDITEM",tSub),"^",16)
	..q:Flag'=1
	..s ARCItemMast=$p(^DHCPEPreIADM(iAdm,"ORDITEM",tSub),"^",1)  //取医嘱项id
	..s ARCIMSubscript=$p(ARCItemMast,"||",1)
	..s ARCIMVersion=$p(ARCItemMast,"||",2)
	..s ARCItemDesc=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",2)
	..s ARCIMItemCat=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",10)   //医嘱子分类
	../***不打折项目 start***/
	..;s ADMLocID=$p($g(^DHCPEPreIADM(iAdm)),"^",26)
	..;s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCItemMast,ADMLocID)
    ..;s StatOrderSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_ADMLocID,StatOrderID,0)) 
    ..;s NoDiscount="N" 
    ..;i StatOrderSetID'="" s NoDiscount=$lg($g(^CF.PE.StationOrderSetD(StatOrderSetID)),36)
    ..;q:NoDiscount="Y"
    ../***不打折项目 end***/
	..s fSub=0
	..f  s fSub=$o(^DHCPEPreIADM(0,"PAORDITEM",ARowID,iAdm,tSub,fSub)) q:(fSub="")||(SQLCODE'=0)  d
	...s ^TempDHCPE("UpdateAmount",Job,iAdm)=""
	...s fItemId=iAdm_"||"_tSub_"||"_fSub
	...s AccountAmount=$p(^DHCPEPreIADM(iAdm,"ORDITEM",tSub,"FEE",fSub),"^",9)
	...s FactAmount=..GetFactAmount(PrivilegeMode1,AccountAmount,Rebate1)
	...&SQL(update sqluser.DHC_PE_PreIOrdItemFee set PIOIF_FactAmount=:FactAmount where PIOIF_RowId=:fItemId)
	..q:SQLCODE'=0
	..d ##class(web.DHCPE.TransAdmInfo).UpdateOrdItemPrice(iAdm_"||"_tSub,"OrdItem")
	
	s iAdm=0
	f  s iAdm=$o(^DHCPEPreIADM(0,"PAORDENT",ARowID,iAdm)) q:(iAdm="")||(SQLCODE'=0)  d
	.s tSub=0
	.f  s tSub=$o(^DHCPEPreIADM(0,"PAORDENT",ARowID,iAdm,tSub)) q:(tSub="")||(SQLCODE'=0)  d
	..///排除无效的
	..s Flag=$p(^DHCPEPreIADM(iAdm,"ORDENT",tSub),"^",9)
	..q:Flag'=1
	..s fSub=0
	..f  s fSub=$o(^DHCPEPreIADM(0,"PAORDENT",ARowID,iAdm,tSub,fSub)) q:(fSub="")||(SQLCODE'=0)  d
	...s ^TempDHCPE("UpdateAmount",Job,iAdm)=""
	...s fItemId=iAdm_"||"_tSub_"||"_fSub
	...s AccountAmount=$p(^DHCPEPreIADM(iAdm,"ORDENT",tSub,"FEE",fSub),"^",9)
	...s FactAmount=..GetFactAmount(PrivilegeMode1,AccountAmount,Rebate1)
	...&SQL(update sqluser.DHC_PE_PreIOrdEntFee set PIOEF_FactAmount=:FactAmount where PIOEF_RowId=:fItemId)
	..q:SQLCODE'=0
	..d ##class(web.DHCPE.TransAdmInfo).UpdateOrdItemPrice(iAdm_"||"_tSub,"OrdSets")
	
	i SQLCODE'=0{
		k ^TempDHCPE("UpdateAmount",Job)
		q SQLCODE
	}
	s aType=$p(^DHCPEPreA(ARowID),"^",20)
	s AdmType=$p(^DHCPEPreA(ARowID),"^",1)
	i (aType="ADD")&&(AdmType="G") d
	.s iAdm=""
	.f  s iAdm=$O(^TempDHCPE("UpdateAmount",Job,iAdm)) q:(iAdm="")||(SQLCODE'=0)  d
	..s SQLCODE=..UpdateFeeRecord(iAdm,"Audit",ARowID)
	q SQLCODE
}

ClassMethod IsPartIFee(fId, AuditId, Type)
{
	new Flag,iAdm,tSub,Sub,i
	s iAdm=$p(fId,"||",1)
	s tSub=$p(fId,"||",2)
	s Sub=0
	s i=0
	s AType=$p(^DHCPEPreA(AuditId),"^",1)
	f  s Sub=$o(^DHCPEPreIADM(iAdm,Type,tSub,"FEE",Sub)) q:Sub=""  d
	.s i=i+1
	i (i>1)&&(AType="I") q 1
	q 0
}

/// 修改分组项目
ClassMethod UpdateGItem(ARowID, PrivilegeMode, Rebate)
{
	new Items,GADM,GTSub,Sub,ID,Info,ItemID,AccountAmount,PLIST,FactAmount
	s Items=""
	s GADM=0,Sub=0
	s SQLCODE=0
	f  s GADM=$o(^DHCPEPreGADM(0,"PGTOIPAudit",ARowID,GADM)) q:(GADM=""||SQLCODE'=0)  d
	.s GTSub=0
	.f  s GTSub=$o(^DHCPEPreGADM(0,"PGTOIPAudit",ARowID,GADM,GTSub)) q:(GTSub=""||SQLCODE'=0)  d
	..s Sub=0
	..f  s Sub=$o(^DHCPEPreGADM(0,"PGTOIPAudit",ARowID,GADM,GTSub,Sub)) q:(Sub=""||SQLCODE'=0)  d
	...s ID=GADM_"||"_GTSub_"||"_Sub
	...s Info=$g(^DHCPEPreGADM(GADM,"Team",GTSub,"ORDITEM",Sub))
	...///排除无效
	...s UFlag=$p(Info,"^",13)
	...q:UFlag'=1
	...s ItemID=$p(Info,"^",2)
	...s AccountAmount=$P(Info,"^",11)
	...s PLIST(7)=PrivilegeMode
	...
	...///修改为项目优惠不更新原来价格
	...i PrivilegeMode="OP" d
	....s OldFact=$P(Info,"^",4)
	....s FactAmount=OldFact
	...e  d
	....s FactAmount=..GetFactAmount(PrivilegeMode,AccountAmount,Rebate)
	...s PLIST(8)=Rebate
	...s PLIST(6)=FactAmount
	...&SQL(update sqluser.DHC_PE_PreGTOrdItem values :PLIST() where PGTOI_RowId=:ID)
	...q:SQLCODE'=0
	...i ItemID'="" d
	....q:..StringIsInStrs(Items,ItemID)
	....s Items=Items_"^"_ItemID
	....s SQLCODE=..UpdateGTOrdEnt(ItemID,PrivilegeMode, Rebate)
	q SQLCODE
}

ClassMethod StringIsInStrs(Strs, Str)
{
	new i,j,Arg,Flag
	s Flag=0
	s i=$l(Strs,"^")
	for j=1:1:i
	{
		s Arg=$p(Strs,"^",j)
		i Arg=Str s Flag=1
		q:Flag
	}
	q Flag
}

ClassMethod UpdateGTOrdEnt(ItemID, PrivilegeMode, Rebate)
{
	new PLIST,Info,GADM,TSub,Sub,AccountAmount
	s SQLCODE=0
	s GADM=$p(ItemID,"||",1)
	s TSub=$p(ItemID,"||",2)
	s Sub=$p(ItemID,"||",3)
	s Info=$G(^DHCPEPreGADM(GADM,"Team",TSub,"ORDENT",Sub))
	////如果修改为项目优惠不更新原来最终金额
	i PrivilegeMode="OP" d
	.
	e  d
	.s AccountAmount=$p(Info,"^",6)
	.//s PLIST(7)=PrivilegeMode
	.s PLIST(7)=..GetFactAmount(PrivilegeMode,AccountAmount,Rebate)
	.&SQL(update sqluser.DHC_PE_PreGTOrdEnt values :PLIST() where PGTOE_RowId=:ItemID)
	q SQLCODE
}

ClassMethod UpdateIOrdEnt(ItemID, PrivilegeMode, Rebate)
{
	new PLIST,Info,GADM,TSub,Sub,AccountAmount
	s SQLCODE=0
	s GADM=$p(ItemID,"||",1)
	s TSub=$p(ItemID,"||",2)
	s Info=$G(^DHCPEPreIADM(GADM,"ORDENT",TSub))
	s AccountAmount=$p(Info,"^",7)
	i AccountAmount="" s AccountAmount=0
	//s PLIST(7)=PrivilegeMode
	s PLIST(8)=..GetFactAmount(PrivilegeMode,AccountAmount,Rebate)
	&SQL(update sqluser.DHC_PE_PreIOrdEnt values :PLIST() where PIOE_RowId=:ItemID)
	q SQLCODE_"^"_PLIST(8)_"^"_AccountAmount
}

ClassMethod GetFactAmount(PrivilegeMode, AccountAmount, Rebate)
{
	new (PrivilegeMode, AccountAmount, Rebate)
	s FactAmount=AccountAmount
	i AccountAmount="" s AccountAmount=0
	i Rebate="" s Rebate=0
	i PrivilegeMode="NP" s FactAmount=AccountAmount
	i PrivilegeMode="OR" s FactAmount=(AccountAmount*Rebate)/100
	i PrivilegeMode="OP" s FactAmount=AccountAmount
	i PrivilegeMode="TP" s FactAmount=""
	q FactAmount
}

/*
ClassMethod GetOneInfo(RowID)
{
	new Info
	s Info=$G(^DHCPEPreA(RowID))
	s ADMType=$P(Info,"^",1)
	S PreGAdm=$P(Info,"^",2)
	s PGADMContractNo=""
	I ADMType="G"  d
	.s TContract=$p($g(^DHCPEPreGADM(PreGAdm)),"^",25)
	.i +TContract'=0 d
	..s PGADMContractNo=$LG(^User.DHCPEContractD(TContract),2)
	q Info_"^"_PGADMContractNo
	//q Info
	
	
}*/
ClassMethod GetOneInfo(RowID)
{
	new Info
	s Info=$G(^DHCPEPreA(RowID))
    i ($p($p(Info,"^",5),".",1)="")&&($p(Info,"^",5)'="") s $p(Info,"^",5)=0_$p(Info,"^",5)
	s ADMType=$P(Info,"^",1)
	S PreGAdm=$P(Info,"^",2)

    
	s AccountAmount=$P(Info,"^",6)
	i $d(AccountAmount) d
	.i $p(AccountAmount,".",1)="" s AccountAmount=0_AccountAmount
	.s AccountAmount=$fn(AccountAmount,"",2)
	
	s SaleAmount=$P(Info,"^",7)
	i $d(SaleAmount) d
	.i $p(SaleAmount,".",1)="" s SaleAmount=0_SaleAmount
	.s SaleAmount=$fn(SaleAmount,"",2)
	
	S DiscountedAmount=$P(Info,"^",8)
	i DiscountedAmount'="" d
	.i $p(DiscountedAmount,".",1)="" s DiscountedAmount=0_DiscountedAmount
	.s DiscountedAmount=$fn(DiscountedAmount,"",2)
	
	s FactAmount=$P(Info,"^",9)
	i $d(FactAmount) d
	.i $p(FactAmount,".",1)="" s FactAmount=0_FactAmount
	.s FactAmount=$fn(FactAmount,"",2)
	
	s InfoNew=$p(Info,"^",1)
	for i=2:1:5  d
	.s InfoNew=InfoNew_"^"_$p(Info,"^",i)
	s InfoNew=InfoNew_"^"_AccountAmount_"^"_SaleAmount_"^"_DiscountedAmount_"^"_FactAmount
	
	for i=10:1:$l(Info,"^")  d
	.s InfoNew=InfoNew_"^"_$p(Info,"^",i)


	s PGADMContractNo=""
	I ADMType="G"  d
	.s TContract=$p($g(^DHCPEPreGADM(PreGAdm)),"^",25)
	.i +TContract'=0 d
	..s PGADMContractNo=$LG(^User.DHCPEContractD(TContract),2)
	
	s ChargedType=$p($g(^DHCPEPreA("AsCharged",RowID)),"^",3)
	s ChargedRemark=$p($g(^DHCPEPreA("AsCharged",RowID)),"^",4)

	 i $d(^DHCPEPreA("AsCharged",RowID)) s AsCharged="Y"
    E  s AsCharged="N"
    
	q InfoNew_"^"_PGADMContractNo_"^"_ChargedType_"^"_ChargedRemark_"^"_AsCharged
}

Query SerchPreAudit(ADMType As %String = "", CRMADM As %String = "", GIADM As %String = "", AppType As %String = "", PayedFlag As %String = "") As %Query(ROWSPEC = "TRowId:%String, TADMType:%String, TCRMADM:%String, TGIADM:%String, TContractNo:%String, TRebate:%String,TAccountAmount:%String, TDiscountedAmount:%String, TSaleAmount:%String,TFactAmount:%String, TAuditedStatus:%String, TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TChargedStatus:%String, TCancelUserDR:%String,TCancelDate:%String,TCancelTime:%String, TRemark:%String, TPrivilegeMode:%String, TType:%String,TTeamName:%String,TChargedType:%String,TAsCharged:%String,TNoDiscount")
{
}

ClassMethod SerchPreAuditExecute(ByRef qHandle As %Binary, ADMType As %String = "", CRMADM As %String = "", GIADM As %String = "", AppType As %String = "", PayedFlag As %String = "") As %Status
{
	//s ^tempdhcpe("CRMADM")=ADMType_"^"_CRMADM_"^"_GIADM
    Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	s m=1
 	while(m<=$l(GIADM,",")){
    s GIADMi=$p(GIADM,",",m)

 	
 	s id=0
 	s GlobalLength=23
 	new PreADM,ADM,ArgType,CRM
 	
 	//w ..GetIFee(Type,CRMADM,GIADM)
 	s ArgType=""
 	s (PreADM,ADM)=""
 	
 	i ADMType="G"
 	{
	 	i CRMADM'=""
	 	{
		 	s PreADM=CRMADM
		 	//s ADM=$o(^DHCPEGADM(0,"CRMADM",CRMADM,0))
		 	s ADM=$o(^DHCPEGADM(0,"CRMGADM",CRMADM,0))
	 	}
	 	elseif GIADMi'=""
	 	{
		 	s ADM=GIADMi	
		 	s PreADM=$p($G(^DHCPEGADM(GIADMi)),"^",2)
		 	d ##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(PreADM,1)
	 	}
 	}
 	i ADMType="I"
 	{
	 	i CRMADM'=""
	 	{
		 	s PreADM=CRMADM
		 	s ADM=$o(^DHCPEIADM(0,"CRMADM",CRMADM,0))
	 	}
	 	elseif GIADMi'=""
	 	{
		 	s ADM=GIADMi
		 	s PreADM=$p($G(^DHCPEIADM(GIADMi)),"^",4)
	 	}
	 	
	 	q:ADM=""

	 	s PaadmRowid=$P($G(^DHCPEIADM(ADM)),"^",1)
	 	// 如果有PET则会产生门诊药费,其他特殊情况也会产生门诊药费,此时应则提示需要到门诊收费界面收取药费
 		s PapmiDR=$P($g(^PAADM(PaadmRowid)),"^",1)
 		s UnPayedFlag=$$GetOPUnPayedFlag(PapmiDR)
 		//i UnPayedFlag=1	W "<font color = red size=4 >     存在门诊费用未结算,请到门诊收费页面收取"

 	}
 	//w ##class(web.DHCPE.PreAudit).GetAPAmount(Type,PreADM)
 	i CRMADM'="" s ArgType="CRM"
 	i ADM'=""
 	{
	 	f  s id=$o(^DHCPEPreA(0,"GIADM",ADMType,ADM,id)) q:id=""  d
	 	.s CRM=$p($G(^DHCPEPreA(id)),"^",2)
	 	.q:((ArgType="CRM")&&(CRM'=""))
	 	.d GetOnePreAudit
 	}
 	s id=0
 	i PreADM'=""
 	{
	 	f  s id=$o(^DHCPEPreA(0,"CRMADM",ADMType,PreADM,id)) q:id=""  d
	 	.s CRM=$p($G(^DHCPEPreA(id)),"^",3)
	 	.q:((ArgType="")&&(CRM'=""))
	 	.d GetOnePreAudit
 	}
 	s m=m+1
 	}

 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK


GetOPUnPayedFlagByAdm(PaadmRowid)
	s UnPayedFlag=0
	s OrderRowid=$o(^OEORD(0,"Adm",PaadmRowid,0))
	q:OrderRowid="" UnPayedFlag
	s ChildSub=0
	f  s ChildSub=$o(^OEORD(OrderRowid,"I",ChildSub)) q:((ChildSub="")||(UnPayedFlag=1))  d
	.s ItemStatDR=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",13)
	.q:ItemStatDR'=1
	.//q:(ItemStatDR'=1)&&(ItemStatDR'=10)
	.s Billed=$p($g(^OEORD(OrderRowid,"I",ChildSub,3)),"^",5)
	.q:Billed="B"
	.s ArcimRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",2)
	.s FeeType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimRowid)
	.q:FeeType'="Other"
	.s UnPayedFlag=1
	q UnPayedFlag
	
 // 取得病人当然就诊未结算的门诊医嘱
GetOPUnPayedFlag(PapmiDR)
	q:PapmiDR="" 0
	s UnPayedFlag=0
	s PaadmRowid=0
	f  s PaadmRowid=$o(^PAPERdr(PapmiDR,"ADM","O",PaadmRowid)) q:PaadmRowid=""  d
	.s AdmDate=$p($g(^PAADM(PaadmRowid)),"^",6)
	.q:AdmDate'=+$h
	.s UnPayedFlag=$$GetOPUnPayedFlagByAdm(PaadmRowid)
	q UnPayedFlag
	
	
GetOnePreAudit
	k PLIST
	s AInfo=$G(^DHCPEPreA(id))
	s PLIST(1)=id
	for i=1:1:GlobalLength
	{
		s PLIST(i+1)=$p(AInfo,"^",i)
	}
	//Q:(AppType="Fee")&&((PLIST(10)="")||(PLIST(10)=0))
    Q:(AppType="Fee")&&((PLIST(10)=""))       //Add 20080707
    Q:(AppType="Fee")&&((PLIST(10)=0)&&(##class(web.DHCPE.Cashier).CheckAuditHasList(id)=0))   //Add 20080707
	q:PLIST(22)="NU"
	q:((PayedFlag'="")&&(PayedFlag'=PLIST(15)))
	//Q:(AppType="Fee")&&(PLIST(15)="CHARGED")
	s PLIST(11)=..GetAuditStatu(PLIST(11))
	s PLIST(15)=..GetChargedStatu(PLIST(15),id)
	s PLIST(20)=..GetPrivilegeMode(PLIST(20))
	if (PLIST(9)>0) s PLIST(20)="销售金额"
	s PLIST(21)=..GetAuditType(PLIST(21))
	s:PLIST(23)'="" PLIST(23)=$P($g(^DHCPEPreGADM(+PLIST(23),"Team",$P(PLIST(23),"||",2))),"^",1)
	s ChargedTypeInfo=$G(^DHCPEPreA("AsCharged",id))
	s ChargedType=$P(ChargedTypeInfo,"^",3)
	s ChargedType=..GetChargedTypeDesc(ChargedType)
	s ChargedRemak=$P(ChargedTypeInfo,"^",4)
	s:ChargedRemak'="" ChargedType=ChargedType_"("_ChargedRemak_")"
	;q:($FN(PLIST(10),",",2)="0.00")&&(PLIST(15)="未收费")
	q:('$d(^DHCPEPreIADM(0,"PAORDITEM",id)))&&('$d(^DHCPEPreIADM(0,"PAORDENT",id)))
	i ((PLIST(6)'="" )&&($p(PLIST(6),".",1)="")) s PLIST(6)=0_PLIST(6)
	i (PLIST(6)'="") s PLIST(6)=PLIST(6)_"%"
	i (PLIST(6)="") s PLIST(6)=PLIST(6)
	i $d(^DHCPEPreA("AsCharged",id)) s AsCharged="是"
    e  s AsCharged="否"
    s NoDiscount=$p($g(^DHCPEPreA(id)),"^",24)
    i NoDiscount="" s NoDiscount="N"

	d Build
	q
Build
	/***翻译 start***/
    s PLIST(15)=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpepreauditlist.hiui.csp",PLIST(15))  //收费状态
    s PLIST(11)=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpepreauditlist.hiui.csp",PLIST(11))  //审核状态
    s PLIST(20)=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpepreauditlist.hiui.csp",PLIST(20))  //优惠方式
    s PLIST(21)=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpepreauditlist.hiui.csp",PLIST(21))  //类型
    s AsCharged=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpepreauditlist.hiui.csp",AsCharged)  //定额卡支付
    /***翻译 end***/
	set Data=$lb( PLIST(1), PLIST(2), PLIST(3), PLIST(4), PLIST(5), PLIST(6),$FN(PLIST(7),",",2), $FN(PLIST(8),",",2), $FN(PLIST(9),",",2),$FN(PLIST(10),",",2), PLIST(11), PLIST(12),PLIST(13),PLIST(14),PLIST(15), PLIST(16),PLIST(17),PLIST(18), PLIST(19), PLIST(20), PLIST(21),PLIST(23),ChargedType,AsCharged,NoDiscount)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SerchPreAuditFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SerchPreAuditExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SerchPreAuditClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SerchPreAuditExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 得到团体报告发送状态
ClassMethod GetGReportSend(GSStatu)
{
	i GSStatu="" q ""
	i GSStatu="AC" q "挂帐可取"
	i GSStatu="DC" q "结帐取"
	q "没有设定"
}

/// 得到ADM状态
ClassMethod GetADMStatus(Status)
{
	i Status="PREREG" q "预约"
	i Status="REGISTERED" q "登记"
	i Status="ARRIVED" q "到达"
	i Status="COMPLETED" q "完成"
	i Status="" q ""

	q "没有设定"
}

/// 得到结算方式状态
ClassMethod GetDisChargedMode(DisChargedMode)
{
	i DisChargedMode="" q ""
	i DisChargedMode="GD" q "统结"
	i DisChargedMode="ID" q "自结"
	q "没有设定"
}

/// 根据审核状态的简码得到审核状态
ClassMethod GetAuditStatu(StatusType)
{
	i StatusType="" q ""
	i StatusType="UnAudited" q "未审核"
	i StatusType="Audited" q "已审核"
	i StatusType="NoAudited" q "不需审核"
	i StatusType="CancelAudited" q "取消审核"
}

/// 得到收费状态
ClassMethod GetChargedStatu(ChargedStatu, auditId = "")
{
	i ChargedStatu="" q ""
	i ChargedStatu="CHARGED" 
	{
		s yjf=""
		s:auditId'="" yjf=##class(web.DHCPE.CashierEx).IsYJSByAuditDr(auditId)
		q:yjf=1 "预结算"
		q "已收费"
	}
	i ChargedStatu="UNCHARGED" q "未收费"
}

/// 得到优惠方式
/// w ##class(web.DHCPE.PreAudit).GetPrivilegeMode()
ClassMethod GetPrivilegeMode(PrivilegeMode)
{
	i PrivilegeMode="" q ""
	i PrivilegeMode="NP" q "无优惠"
	i PrivilegeMode="TP" q "总价优惠"
	i PrivilegeMode="OR" q "折扣"
	i PrivilegeMode="OP" q "项目优惠"
	i PrivilegeMode="OS" q "销售金额"
}

/// 得到类型
ClassMethod GetAuditType(AuditType)
{
	i AuditType="" q ""
	i AuditType="PRE" q "预约"
	i AuditType="ADD" q "加项"
}

/// d ##class(web.DHCPE.PreAudit).UpdateFeeRecord("637","OPAmount")
/// 根据限额确定哪些是公费加项 Type "LimitFee":修改预约限额
ClassMethod UpdateFeeRecord(IID, Type As %String = "", GDefaultAuditID As %String = "")
{
    K ^DHCPETMP("TwoRecordIForIFee")
	n (IID, Type,GDefaultAuditID,%session)
	i $D(%session)&&(%session.Get("LOGON.USERID")'=""){
		s User=%session.Get("LOGON.USERID")
	}else{
		s User=1
	}
	s Date=+$H
	s Time=$P($H,",",2)
	s SQLCODE=0
	s GID=$p($g(^DHCPEPreIADM(IID)),"^",2)
	i GID="" q 0
	s GTeamID=$p($g(^DHCPEPreIADM(IID)),"^",3) 
	i GDefaultAuditID="" d
	.b ;GTeamID
	.s gAudit=+##class(web.DHCPE.PreItemList2).GetPARowId("G",IID,"ADD")
	e  d
	.s gAudit=GDefaultAuditID
	b ;5
	s iAudit=+##class(web.DHCPE.PreItemList2).GetPARowId("I",IID,"ADD")
	s (IRebate,GRebate)=""
	s GPrivilegeMode=$p(^DHCPEPreA(gAudit),"^",19)
	s:GPrivilegeMode="OR" GRebate=$p(^DHCPEPreA(gAudit),"^",5)
	s IPrivilegeMode=$p(^DHCPEPreA(iAudit),"^",19)
	s:IPrivilegeMode="OR" IRebate=$p(^DHCPEPreA(iAudit),"^",5)
	s Sub=0
	//获取某个人的限额金额
	s LimitFee=$p(^DHCPEPreIADM(IID),"^",12)
	s AddOrdItem=$p(^DHCPEPreIADM(IID),"^",10)
	s AddOrdItemLimit=$p(^DHCPEPreIADM(IID),"^",11)
	i AddOrdItem="N" d
	.s LimitFee=0
	e  d
	.i AddOrdItemLimit="N" d
	..s LimitFee=""  //不控制公费限额
	.e  d
	..i LimitFee="" s LimitFee=0
	//处理套餐金额
	s EntSub=0
	f  s EntSub=$O(^DHCPEPreIADM(IID,"ORDENT",EntSub)) q:EntSub=""  d
	.s ItemStat=$P($G(^DHCPEPreIADM(IID,"ORDENT",EntSub)),"^",9)
	.q:ItemStat'="1"
	.s PreOrAdd=$P($G(^DHCPEPreIADM(IID,"ORDENT",EntSub)),"^",8)
	.q:PreOrAdd'="ADD" //不是加项退出
	.s FristFeeSub=""
	.s FristFeeID=""
	.s FristAccountAmount=0
	.s FristFactAmount=0
	.s ItemId=IID_"||"_EntSub
	.s FeeSub=0
	.f  s FeeSub=$O(^DHCPEPreIADM(IID,"ORDENT",EntSub,"FEE",FeeSub)) q:FeeSub=""  d
	..s PAuditID=$P(^DHCPEPreIADM(IID,"ORDENT",EntSub,"FEE",FeeSub),"^",5)
	..q:PAuditID="" //审核记录为空退出
	..s AuditUseFlag=$p(^DHCPEPreA(PAuditID),"^",21)
	..q:AuditUseFlag="NU"  //已退费的退出
	..s ChargedStatus=$p(^DHCPEPreA(PAuditID),"^",14)
	..q:ChargedStatus="CHARGED" //已付费退出
	..s FeeID=IID_"||"_EntSub_"||"_FeeSub
	..i FristFeeSub'="" d  //一个套餐仅保留一个可用的费用记录
	...s CurAccountAmount=$P(^DHCPEPreIADM(IID,"ORDENT",EntSub,"FEE",FeeSub),"^",9)
	...s CurFactAmount=$P(^DHCPEPreIADM(IID,"ORDENT",EntSub,"FEE",FeeSub),"^",2)
	...s FristAccountAmount=FristAccountAmount+CurAccountAmount
	...s FristFactAmount=FristFactAmount+CurFactAmount
	...&SQL(Delete sqluser.DHC_PE_PreIOrdEntFee where PIOEF_RowID=:FeeID)
	...q:SQLCODE'=0
	...&SQL(update sqluser.DHC_PE_PreIOrdEntFee set PIOEF_AccountAmount=:FristAccountAmount,PIOEF_FactAmount=:FristFactAmount where PIOEF_RowID=:FristFeeID)
	..e  d
	...s FristFeeSub=FeeSub
	...s FristAccountAmount=$P(^DHCPEPreIADM(IID,"ORDENT",EntSub,"FEE",FristFeeSub),"^",9)
	...s FristFactAmount=$P(^DHCPEPreIADM(IID,"ORDENT",EntSub,"FEE",FristFeeSub),"^",2)
	...s FristFeeID=IID_"||"_EntSub_"||"_FristFeeSub
	.q:FristFeeSub=""
	.//按照团体限额得到团体折后金额
	.i +FristAccountAmount=0 d  //如果原价为0，就取原来实收金额
	..s GFactAmount=FristFactAmount
	.e  d 
	..i GRebate="" d //不是打折优惠，就取原优惠价格
	...s GFactAmount=FristFactAmount
	..e  d //按照团体折扣从新计算费用
	...s GFactAmount=(FristAccountAmount*GRebate)/100
	.i (LimitFee="") d  //未设置限额、全公费
	..&SQL(update sqluser.DHC_PE_PreIOrdEntFee set PIOEF_FactAmount=:GFactAmount,PIOEF_PAudit_DR=:gAudit where PIOEF_RowID=:FristFeeID)
	.e  d
	..i (LimitFee-GFactAmount)>=0 d //全公费
	...s LimitFee=LimitFee-GFactAmount
	...&SQL(update sqluser.DHC_PE_PreIOrdEntFee set PIOEF_FactAmount=:GFactAmount,PIOEF_PAudit_DR=:gAudit where PIOEF_RowID=:FristFeeID)
	..e  d
	...i LimitFee<=0 d //全自费
	....i +FristAccountAmount=0 d  //如果原价为0，就取原来实收金额
	.....s IFactAmount=FristFactAmount
	....e  d 
	.....i IRebate="" d //不是打折优惠，就取原优惠价格
	......s IFactAmount=FristFactAmount
	.....e  d //按照团体折扣从新计算费用
	......s IFactAmount=(FristAccountAmount*IRebate)/100
	....&SQL(update sqluser.DHC_PE_PreIOrdEntFee set PIOEF_FactAmount=:IFactAmount,PIOEF_PAudit_DR=:iAudit where PIOEF_RowID=:FristFeeID)
	...e  d  //公费+自费
	....///公费金额是  LimitFee
	....s NewGFactAmount=LimitFee
	....i +FristAccountAmount=0 d
	.....s NewGAcountAmount=0
	.....s NewIAcountAmount=0
	.....s NewIFactAmount=GFactAmount-LimitFee
	....e  d
	.....s NewGAcountAmount=FristAccountAmount*(NewGFactAmount/GFactAmount)
	.....s NewIAcountAmount=FristAccountAmount-NewGAcountAmount
	.....i IRebate="" d //不是打折优惠，就取原优惠价格
	......s NewIFactAmount=NewIAcountAmount
	.....e  d
	......s NewIFactAmount=(NewIAcountAmount*IRebate)/100
	....&SQL(update sqluser.DHC_PE_PreIOrdEntFee set PIOEF_AccountAmount=:NewGAcountAmount,PIOEF_FactAmount=:NewGFactAmount where PIOEF_RowID=:FristFeeID)
	....q:SQLCODE'=0
	....&SQL(insert into sqluser.DHC_PE_PreIOrdEntFee (PIOEF_ParRef,PIOEF_AccountAmount,PIOEF_FactAmount,PIOEF_PAudit_DR,PIOEF_UpdateUser_DR,PIOEF_UpdateDate,PIOEF_UpdateTime) values (:ItemId,:NewIAcountAmount,:NewIFactAmount,:iAudit,:User,:Date,:Time))
	....q:SQLCODE'=0
	....s LimitFee=LimitFee-GFactAmount
	.d ##class(web.DHCPE.TransAdmInfo).UpdateOrdItemPrice(ItemId,"OrdSets")
	
	//处理项目金额
	s EntSub=0
	f  s EntSub=$O(^DHCPEPreIADM(IID,"ORDITEM",EntSub)) q:EntSub=""  d
	.s ItemStat=$P($G(^DHCPEPreIADM(IID,"ORDITEM",EntSub)),"^",16)
	.q:ItemStat'="1"
	.s PreOrAdd=$P($G(^DHCPEPreIADM(IID,"ORDITEM",EntSub)),"^",15)
	.q:PreOrAdd'="ADD" //不是加项退出
	.s arcItemId=$P($G(^DHCPEPreIADM(IID,"ORDITEM",EntSub)),"^",1)
	.s IFDiscountFlag=0
	.i ((arcItemId'="")&&($g(^DHCPEDataEx("DHCPEStationOrder","IFDiscountFlag",arcItemId))="Y")) s IFDiscountFlag="1"
	.s FristFeeSub=""
	.s FristFeeID=""
	.s FristAccountAmount=0
	.s FristFactAmount=0
	.s ItemId=IID_"||"_EntSub
	.s FeeSub=0
	.f  s FeeSub=$O(^DHCPEPreIADM(IID,"ORDITEM",EntSub,"FEE",FeeSub)) q:FeeSub=""  d
	..s PAuditID=$P(^DHCPEPreIADM(IID,"ORDITEM",EntSub,"FEE",FeeSub),"^",5)
	..q:PAuditID="" //审核记录为空退出
	..s AuditUseFlag=$p(^DHCPEPreA(PAuditID),"^",21)
	..q:AuditUseFlag="NU"  //已退费的退出
	..s ChargedStatus=$p(^DHCPEPreA(PAuditID),"^",14)
	..q:ChargedStatus="CHARGED" //已付费退出
	..s FeeID=IID_"||"_EntSub_"||"_FeeSub
	..i FristFeeSub'="" d  //一个套餐仅保留一个可用的费用记录
	...s CurAccountAmount=$P(^DHCPEPreIADM(IID,"ORDITEM",EntSub,"FEE",FeeSub),"^",9)
	...s CurFactAmount=$P(^DHCPEPreIADM(IID,"ORDITEM",EntSub,"FEE",FeeSub),"^",2)
	...s FristAccountAmount=FristAccountAmount+CurAccountAmount
	...s FristFactAmount=FristFactAmount+CurFactAmount
	...&SQL(Delete sqluser.DHC_PE_PreIOrdItemFee where PIOIF_RowID=:FeeID)
	...q:SQLCODE'=0
	...&SQL(update sqluser.DHC_PE_PreIOrdItemFee set PIOIF_AccountAmount=:FristAccountAmount,PIOIF_FactAmount=:FristFactAmount where PIOIF_RowID=:FristFeeID)
	..e  d
	...s FristFeeSub=FeeSub
	...s FristAccountAmount=$P(^DHCPEPreIADM(IID,"ORDITEM",EntSub,"FEE",FristFeeSub),"^",9)
	...s FristFactAmount=$P(^DHCPEPreIADM(IID,"ORDITEM",EntSub,"FEE",FristFeeSub),"^",2)
	...s FristFeeID=IID_"||"_EntSub_"||"_FristFeeSub
	.q:FristFeeSub=""
	.//按照团体限额得到团体折后金额
	.i +FristAccountAmount=0 d  //如果原价为0，就取原来实收金额
	..s GFactAmount=FristFactAmount
	.e  d 
	..i GRebate="" d //不是打折优惠，就取原优惠价格
	...s GFactAmount=FristFactAmount
	..e  d //按照团体折扣从新计算费用
	...s:IFDiscountFlag=1 GFactAmount=FristAccountAmount
	...s:IFDiscountFlag=0 GFactAmount=(FristAccountAmount*GRebate)/100
	.b ;LimitFee
	.i (LimitFee="") d  //未设置限额、全公费
	..&SQL(update sqluser.DHC_PE_PreIOrdItemFee set PIOIF_FactAmount=:GFactAmount,PIOIF_PAudit_DR=:gAudit where PIOIF_RowID=:FristFeeID)
	.e  d
	..i (LimitFee-GFactAmount)>=0 d //全公费
	...s LimitFee=LimitFee-GFactAmount
	...&SQL(update sqluser.DHC_PE_PreIOrdItemFee set PIOIF_FactAmount=:GFactAmount,PIOIF_PAudit_DR=:gAudit where PIOIF_RowID=:FristFeeID)
	..e  d
	...i LimitFee<=0 d //全自费
	....i +FristAccountAmount=0 d  //如果原价为0，就取原来实收金额
	.....s IFactAmount=FristFactAmount
	....e  d 
	.....i IRebate="" d //不是打折优惠，就取原优惠价格
	......s IFactAmount=FristFactAmount
	.....e  d //按照团体折扣从新计算费用
	......s:IFDiscountFlag=1 IFactAmount=FristAccountAmount
	......s:IFDiscountFlag=0 IFactAmount=(FristAccountAmount*IRebate)/100
	....&SQL(update sqluser.DHC_PE_PreIOrdItemFee set PIOIF_FactAmount=:IFactAmount,PIOIF_PAudit_DR=:iAudit where PIOIF_RowID=:FristFeeID)
	...e  d  //公费+自费
	....///公费金额是  LimitFee
	....s NewGFactAmount=LimitFee
	....i +FristAccountAmount=0 d
	.....s NewGAcountAmount=0
	.....s NewIAcountAmount=0
	.....s NewIFactAmount=GFactAmount-LimitFee
	....e  d
	.....s NewGAcountAmount=FristAccountAmount*(NewGFactAmount/GFactAmount)
	.....s NewIAcountAmount=FristAccountAmount-NewGAcountAmount
	.....i IRebate="" d //不是打折优惠，就取原优惠价格
	......s NewIFactAmount=NewIAcountAmount
	.....e  d
	......s:IFDiscountFlag=0 NewIFactAmount=(NewIAcountAmount*IRebate)/100
	......s:IFDiscountFlag=1 NewIFactAmount=NewIAcountAmount
	....&SQL(update sqluser.DHC_PE_PreIOrdItemFee set PIOIF_AccountAmount=:NewGAcountAmount,PIOIF_FactAmount=:NewGFactAmount,PIOIF_PAudit_DR=:gAudit where PIOIF_RowID=:FristFeeID)
	....q:SQLCODE'=0
	....&SQL(insert into sqluser.DHC_PE_PreIOrdItemFee (PIOIF_ParRef,PIOIF_AccountAmount,PIOIF_FactAmount,PIOIF_PAudit_DR,PIOIF_UpdateUser_DR,PIOIF_UpdateDate,PIOIF_UpdateTime) values (:ItemId,:NewIAcountAmount,:NewIFactAmount,:iAudit,:User,:Date,:Time))
	....q:SQLCODE'=0
	....s LimitFee=LimitFee-GFactAmount
	.d ##class(web.DHCPE.TransAdmInfo).UpdateOrdItemPrice(ItemId,"OrdItem")
	
	q SQLCODE
}

/// 根据项目id,还有Type  "G":得到公费计费id  "I":得到自费计费id
ClassMethod GetPartItemFeeID(Itemid, Type)
{
	new tSub,Sub,iADM,auditId,Flag
	s Flag=""
	s iADM=$p(Itemid,"||",1)
	s tSub=$p(Itemid,"||",2)
	s Sub=0
	f  s Sub=$o(^DHCPEPreIADM(iADM,"ORDITEM",tSub,"FEE",Sub)) q:(Sub="")||(Flag'="")  d
	.s auditId=$p(^DHCPEPreIADM(iADM,"ORDITEM",tSub,"FEE",Sub),"^",5)
	.s aType=$p(^DHCPEPreA(auditId),"^",1)
	.i aType=Type s Flag=Itemid_"||"_Sub
	q Flag
}

/// 根据套餐id,还有Type  "G":得到公费计费id  "I":得到自费计费id
ClassMethod GetPartOrdFeeID(Itemid, Type)
{
	new tSub,Sub,iADM,auditId,Flag
	s Flag=""
	s iADM=$p(Itemid,"||",1)
	s tSub=$p(Itemid,"||",2)
	i $D(^DHCPEPreIADM(iADM,"ORDENT",tSub,"FEE")){
	s Sub=0
	f  s Sub=$o(^DHCPEPreIADM(iADM,"ORDENT",tSub,"FEE",Sub)) q:(Sub="")||(Flag'="")  d
	.s auditId=$p(^DHCPEPreIADM(iADM,"ORDENT",tSub,"FEE",Sub),"^",5)
	.s aType=$p(^DHCPEPreA(auditId),"^",1)
	.i aType=Type s Flag=Itemid_"||"_Sub_"||Ent"
	}else{
		s ItemSub=0
		s PreIADM=+ItemID
		f  s ItemSub=$O(^DHCPEPreIADM(0,"OrdEnt",ItemID,PreIADM,ItemSub)) q:(ItemSub="")||(Flag'="")  d
		.s ItemStat=$P(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub),"^",16)
		.q:ItemStat'="1"
		.s PreItemID=PreIADM_"||"_ItemSub
		.s Flag=..GetPartItemFeeID(PreItemID, Type)
		
	}
	q Flag
}

/// 根据个人ID得到具有两种计费的项目(套餐)id 
ClassMethod GetPartItem(IID)
{
	new Flag,ISub,Sub,i
	
	s Flag=""
	s ISub=0
	f  s ISub=$o(^DHCPEPreIADM(IID,"ORDITEM",ISub)) q:(ISub="")||(Flag'="")  d
	.///排除无效
	.s UFlag=$p($G(^DHCPEPreIADM(IID,"ORDITEM",ISub)),"^",16)
	.q:UFlag'=1
	.
	.s Sub=0
	.s i=0
	.f  s Sub=$o(^DHCPEPreIADM(IID,"ORDITEM",ISub,"FEE",Sub)) q:(Sub="")||(Flag'="")  d
	..s PAuditDR=$p($g(^DHCPEPreIADM(IID,"ORDITEM",ISub,"FEE",Sub)),"^",5)
	..s ChargedStatus=$p($g(^DHCPEPreA(PAuditDR)),"^",14)
	..q:ChargedStatus="CHARGED"
	..s i=i+1
	..i i>1 s Flag="Item^"_IID_"||"_ISub
	q:Flag'="" Flag
	s i=0
	s ISub=0
	f  s ISub=$o(^DHCPEPreIADM(IID,"ORDENT",ISub)) q:(ISub="")||(Flag'="")  d
	.///排除无效的
	.s UFlag=$p($g(^DHCPEPreIADM(IID,"ORDENT",ISub)),"^",9)
	.q:UFlag'=1
	.s Sub=0
	.s i=0
	.f  s Sub=$o(^DHCPEPreIADM(IID,"ORDENT",ISub,"FEE",Sub)) q:(Sub="")||(Flag'="")  d
	..s i=i+1
	..i i>1 s Flag="Ord^"_IID_"||"_ISub
	q Flag
}

/// 得到团体中个人应付金额
ClassMethod GetIFee(ADMType As %String = "", CRMID As %String = "", PEID As %String = "")
{
	n (CRMID,PEID,ADMType)
	s TotalFee=""
	i ADMType="I" q TotalFee
	i PEID'="" s CRMID=$p($G(^DHCPEGADM(PEID)),"^",2)
	q:CRMID="" TotalFee
	s IADM=0
	f  s IADM=$o(^DHCPEPreIADM(0,"PGADM",CRMID,IADM)) q:IADM=""  d
	.s AuditID=0
	.f  s AuditID=$o(^DHCPEPreA(0,"CRMADM","I",IADM,AuditID)) q:AuditID=""  d
	..s Status=$p(^DHCPEPreA(AuditID),"^",21)
	..q:Status="NU"
	..s OneFee=+$p(^DHCPEPreA(AuditID),"^",9)
	..q:OneFee=0
	..s TotalFee=+TotalFee+OneFee
	
	q "团体中个人另外应付为"_+TotalFee_"元"
	//q "<font color = red>团体中个人另外应付为"_+TotalFee_"元!</font>"
}

// 2009-07-24  汪庆权

// 设置打印分类

ClassMethod updateInvPrintCatInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "") As %String
{
	s printflag=$g(InString)
	s Data="aa"
	if (printflag="")
	{
	 
	}
    if printflag="true"
    {
	    s ^DHCPESetting("DHCPE","InvPrintCatInfo")="Y"
	   
    }
    if (printflag="false")
    {
	     s ^DHCPESetting("DHCPE","InvPrintCatInfo")="N"
	     
	 }
	 q Data
}

// Type I,G

// ID   PreADM

// w ##class(web.DHCPE.PreAudit).GetAPAmount(Type,ID)

ClassMethod GetAPAmount(Type, ID)
{
	q:ID="" ""
	i Type="I" d
	.s BaseID=$P($G(^DHCPEPreIADM(ID)),"^",1)
	.s RegNo=$P($G(^DHCPEPreIBI(BaseID)),"^",1)
	e  d
	.s BaseID=$P($G(^DHCPEPreGADM(ID)),"^",1)
	.s RegNo=$P($G(^DHCPEPreGBI(BaseID)),"^",13)
	s APID=$O(^DHCPEAP(0,"RegNo",RegNo,0))
	//q:APID="" "<font color=red>没有预缴金</font>"
	q:APID="" "没有预缴金"
	s Amount=$P($G(^DHCPEAP(APID)),"^",4)
	//q "<font color=red>剩余预缴金"_Amount_"元</font>"
	q "剩余预缴金"_Amount_"元"
}

ClassMethod GetPayAmountInfo(Type, ID)
{
	i Type="I" d
	.s BaseID=$P($G(^DHCPEPreIADM(ID)),"^",1)
	.s Name=$P(^DHCPEPreIBI(BaseID),"^",2)
	e  d
	.s BaseID=$P($G(^DHCPEPreGADM(ID)),"^",1)
	.s Name=$P(^DHCPEPreGBI(BaseID),"^",2)
	s id=0
	s amountTotal=0
	f  s id=$o(^DHCPEPreA(0,"CRMADM",Type,ID,id)) q:id=""  d
	.s useFlag=$p(^DHCPEPreA(id),"^",21)
	.q:useFlag="NU"
	
	.s chargeFlag=$p(^DHCPEPreA(id),"^",14)
	.q:chargeFlag'="UNCHARGED"
	.s Amount=$P($G(^DHCPEPreA(id)),"^",9)
	.s amountTotal=+Amount+amountTotal
	q "请收取"_Name_"体检费"_amountTotal_"元。"
}

/// 判断医嘱是否是定额卡支付
/// w ##class(web.DHCPE.PreAudit).IsAsCharged("548||1")
ClassMethod IsAsCharged(CRMORI)
{
   s flag=0
	s SSub=0
	f  s SSub=$o(^DHCPEPreIADM($p(CRMORI,"||",1),"ORDITEM",$p(CRMORI,"||",2),"FEE",SSub)) q:SSub=""  d 
	.s PreAuditID=$p($g(^DHCPEPreIADM($p(CRMORI,"||",1),"ORDITEM",$p(CRMORI,"||",2),"FEE",SSub)),"^",5)
	.q:PreAuditID=""
	.s Flag=$p($g(^DHCPEPreA(PreAuditID)),"^",21)
    .q:Flag="NU"
    .i $d(^DHCPEPreA("AsCharged",PreAuditID)) s flag=1
   
   
    s OrdEntDR=$p($g(^DHCPEPreIADM($p(CRMORI,"||",1),"ORDITEM",$p(CRMORI,"||",2))),"^",2) 
    i OrdEntDR'="" d
    .s EntSSub=0
	.f  s EntSSub=$o(^DHCPEPreIADM($p(OrdEntDR,"||",1),"ORDENT",$p(OrdEntDR,"||",2),"FEE",EntSSub)) q:EntSSub=""  d 
	..s PreAuditID=$p($g(^DHCPEPreIADM($p(OrdEntDR,"||",1),"ORDENT",$p(OrdEntDR,"||",2),"FEE",EntSSub)),"^",5)
	..q:PreAuditID=""
	..s Flag=$p($g(^DHCPEPreA(PreAuditID)),"^",21)
    ..q:Flag="NU"
    ..i $d(^DHCPEPreA("AsCharged",PreAuditID)) s flag=1
    q flag
}

/// 定额卡支付（相当于已经付费）
ClassMethod AsCharged(PreAuditID, UserID)
{
	q:PreAuditID="" "-1^请选择操作记录"
	s ChargedType=$P(PreAuditID,"^",2)
	s ChargedRemark=$P(PreAuditID,"^",3)
	s PreAuditID=$P(PreAuditID,"^",1)
	s UseFlag=$P(^DHCPEPreA(PreAuditID),"^",21)
	q:UseFlag="NU" "-1^记录不是有效状态"
	s ChargedStatus=$P(^DHCPEPreA(PreAuditID),"^",14)
	q:ChargedStatus="CHARGED" "-1^记录已经是付费状态"
	TSTART
	&SQL(Update Sqluser.DHC_PE_PreAudit Set PA_ChargedStatus='CHARGED' Where PA_RowID=:PreAuditID)
	i SQLCODE'=0{
		TROLLBACK
		q "-1^更新记录失败:"_SQLCODE
	}
	d ..Insert(PreAuditID,UserID,ChargedType,ChargedRemark)
	s DatTime=$H
	s ^DHCPEPreA("AsCharged",PreAuditID)=DatTime_"^"_UserID_"^"_ChargedType_"^"_ChargedRemark
	s ^DHCPEPreAI(DatTime,UserID,PreAuditID)=""
	
	s errs=""
	s preAdmId=""
	f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",PreAuditID,preAdmId)) q:((preAdmId="")||(errs'=""))  d
	.s Status=$p($g(^DHCPEPreIADM(preAdmId)),"^",8)
    .q:(Status'="ARRIVED")&&(Status'="REGISTERED")
	.s childsub=""
	.f  s childsub=$o(^DHCPEPreIADM(0,"PAORDITEM",PreAuditID,preAdmId,childsub)) q:((childsub="")||(errs'=""))  d
	..q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",16)'=1	//判断是否有效
	..s preOrderId=preAdmId_"||"_childsub
	..s peOrderId=$o(^DHCPECRMO(0,"CRMORI",preOrderId,""))
	..q:peOrderId=""
	..;q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",9)="Y"
	..s CRMBillStatus="",OEOrdBilled=""
	..s CRMBillStatus=$P(^DHCPECRMO(peOrderId),"^",4)
	..s ^DHCPEPreA("AsCharged",PreAuditID,"CRMOrder",peOrderId)=CRMBillStatus
	..&SQL(Update Sqluser.DHC_PE_CRMOrder Set CRMO_BillStatus='P' Where CRMO_RowId=:peOrderId)
	..if SQLCODE'=0 s errs="更新体检项目表状态失败!"
	..q:SQLCODE'=0
	..s OEORDRowId=$p($g(^DHCPECRMO(peOrderId)),"^",1)
	..q:OEORDRowId=""
	..s OEOrdBilled=$p($G(^OEORD(+OEORDRowId,"I",$P(OEORDRowId,"||",2),3)),"^",5)
	..s ^DHCPEPreA("AsCharged",PreAuditID,"OEOrder",OEORDRowId)=OEOrdBilled
	..&SQL(Update sqluser.OE_OrdItem set Oeori_Billed='P' where oeori_rowid=:OEORDRowId)
	..if SQLCODE'=0  s errs="更新医瞩状态失败!"
	..q:SQLCODE'=0
	..d ##class(web.DHCPE.CRM.RisGateway).SendInfo("R",OEORDRowId)
	.//插入定额卡支付日志
	.i SQLCODE=0 d ##class(web.DHCPE.AdmRecordManager).Insert(preAdmId,"P","AsCharged",UserID,PreAuditID)
	
	s preAdmId=""
	f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDENT",PreAuditID,preAdmId)) q:((preAdmId="")||(errs'=""))  d
	.s Status=$p($g(^DHCPEPreIADM(preAdmId)),"^",8)
    .q:(Status'="ARRIVED")&&(Status'="REGISTERED")
	.;套餐
   .s Entchildsub=""
   .f  s Entchildsub=$o(^DHCPEPreIADM(0,"PAORDENT",PreAuditID,preAdmId,Entchildsub)) q:(Entchildsub="")  d
   ..q:$p($g(^DHCPEPreIADM(preAdmId,"ORDENT",Entchildsub)),"^",9)'=1 //判断是否有效
   ..s preEntId=preAdmId_"||"_Entchildsub
   ..s preItmSub=""
   ..f  s preItmSub=$o(^DHCPEPreIADM(0,"OrdEnt",preEntId,preAdmId,preItmSub)) q:(preItmSub="")  d
   ...q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",preItmSub)),"^",16)'=1 //判断是否有效
   ...s peOrderId=$o(^DHCPECRMO(0,"CRMORI",preAdmId_"||"_preItmSub,""))
   ...q:peOrderId=""
   ...&SQL(Update Sqluser.DHC_PE_CRMOrder Set CRMO_BillStatus="P" Where CRMO_RowId=:peOrderId)   //更新CRMOrder表为收费
   ...if SQLCODE'=0 s errs="更新体检项目表状态失败!"
   ...q:SQLCODE'=0
   ...s OEORDRowId=$p($g(^DHCPECRMO(peOrderId)),"^",1)
   ...&SQL(Update sqluser.OE_OrdItem set Oeori_Billed="P" where oeori_rowid=:OEORDRowId)  //更新医嘱表为收费
   ...if SQLCODE'=0  s errs="更新医瞩状态失败!"
   ...q:SQLCODE'=0
   ...d ##class(web.DHCPE.CRM.RisGateway).SendInfo("R",OEORDRowId)
  
	i SQLCODE'=0{
		TROLLBACK
		q "-1^"_errs
	}
	TCOMMIT
	q 0
}

// 撤销定额卡支付

ClassMethod UnAsCharged(PreAuditID, UserID)
{
	q:PreAuditID="" "-1^请选择操作记录"
	s UseFlag=$P(^DHCPEPreA(PreAuditID),"^",21)
	q:UseFlag="NU" "-1^记录不是有效状态"
	s ChargedStatus=$P(^DHCPEPreA(PreAuditID),"^",14)
	q:ChargedStatus="UNCHARGED" "-1^记录不是付费状态"
	q:'$D(^DHCPEPreA("AsCharged",PreAuditID)) "-1^记录没有定额卡支付记录"
	TSTART
	&SQL(Update Sqluser.DHC_PE_PreAudit Set PA_ChargedStatus='UNCHARGED' Where PA_RowID=:PreAuditID)
	i SQLCODE'=0 {
		TROLLBACK
		q "-1^更新记录失败:"_SQLCODE
	}
	s peOrderId=""
	f  s peOrderId=$O(^DHCPEPreA("AsCharged",PreAuditID,"CRMOrder",peOrderId)) q:(peOrderId="")||(SQLCODE'=0)  d
	.s BillStatus=$G(^DHCPEPreA("AsCharged",PreAuditID,"CRMOrder",peOrderId))
	.&SQL(Update Sqluser.DHC_PE_CRMOrder Set CRMO_BillStatus=:BillStatus Where CRMO_RowId=:peOrderId)
	.s preAdmId=+$p($g(^DHCPECRMO(peOrderId)),"^",2) 
	i SQLCODE'=0 {
		TROLLBACK
		q "-1^更新CRMOrder错误:"_SQLCODE
	}
	s OEORDRowId=""
	f  s OEORDRowId=$O(^DHCPEPreA("AsCharged",PreAuditID,"OEOrder",OEORDRowId)) q:(OEORDRowId="")||(SQLCODE'=0)  d
	.s Billed=$G(^DHCPEPreA("AsCharged",PreAuditID,"OEOrder",OEORDRowId))
	.&SQL(Update sqluser.OE_OrdItem set Oeori_Billed=:Billed where oeori_rowid=:OEORDRowId)
	i SQLCODE'=0 {
		TROLLBACK
		q "-1^更新OEOrdItem错误:"_SQLCODE
	}
	s ret=..DeleteAsCharged(PreAuditID)
	s OldInfo=$G(^DHCPEPreA("AsCharged",PreAuditID))
	k ^DHCPEPreA("AsCharged",PreAuditID)
	k ^DHCPEPreAI($P(OldInfo,"^",1),$P(OldInfo,"^",2),PreAuditID)
	//插入撤销定额卡支付日志
	d ##class(web.DHCPE.AdmRecordManager).Insert(preAdmId,"P","DeleteAsCharged",UserID,PreAuditID)
	TCOMMIt
	q 0
}

ClassMethod OutChargedType(ContrlWidth As %String = "")
{
	;d ##class(web.DHCPE.PreAudit).OutChargedType(125)
	s:(""=ContrlWidth) ContrlWidth="125"
	;w "<select name='ChargedType' id='ChargedType' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	 w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("ChargedType","")
	w "<option value='1'>"_..GetChargedTypeDesc(1)_"</option>",!
	;w "<option value='2'>"_..GetChargedTypeDesc(2)_"</option>",!
	;w "<option value='3'>"_..GetChargedTypeDesc(3)_"</option>",!
	w "<option value='4'>"_..GetChargedTypeDesc(4)_"</option>",!
	;w "<option value='5'>"_..GetChargedTypeDesc(5)_"</option>",!
	w "</select>",!
}

ClassMethod OutprivilegeMode(ContrlWidth As %String = "", DefaultValue As %String = "")
{
	
	s:(""=ContrlWidth) ContrlWidth="125"
	 w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("privilegeMode","")
	 w "<option value=''> </option>",!
	 w "<option value='OR'>折扣</option>",!
	w "<option value='NP'>无优惠</option>",!
	w "<option value='OP'>项目优惠</option>",!
	w "<option value='OS'>销售金额</option>",!
	w "</select>",!
}

ClassMethod OutTypeToHTML(ContrlWidth As %String = "")
{
	
	s:(""=ContrlWidth) ContrlWidth="125"
	 w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("Type","")
	w "<option value='PRE'>预约</option>",!
	w "<option value='ADD'>加项</option>",!
	w "</select>",!
}

ClassMethod GetChargedTypeDesc(ChargedType)
{
	q:ChargedType="1" "定额卡"
	q:ChargedType="2" "遗留数据"
	q:ChargedType="3" "西院缴费"
	q:ChargedType="4" "其它"
	q:ChargedType="4" "团体换人"
	q ""
}

ClassMethod UpdateGroupAuditWuCha(GID)
{
	i PriModeNew="OS" d
	.s wucha=0
	.s GPersonID=""
	.s SaleAmount=""
	.s AuditID=0
	.f  s AuditID=$o(^DHCPEPreA(0,"CRMADM","G",GID,AuditID)) q:(AuditID="")  d
	..s UseFlag=$p($G(^DHCPEPreA(AuditID)),"^",21)
	..q:UseFlag="NU"
	..s stutas=$p(^DHCPEPreA(AuditID),"^",14)
	..q:stutas="CHARGED"
	..s IADM=0
	..f  s IADM=$o(^DHCPEPreIADM(0,"PAORDITEM",AuditID,IADM)) q:(IADM="")  d
	...q:SQLCODE'=0
	...s Sub=0
	...f  s Sub=$o(^DHCPEPreIADM(0,"PAORDITEM",AuditID,IADM,Sub)) q:(Sub="")  d
	....///排除无效的
	....s UFlag=$p($G(^DHCPEPreIADM(IADM,"ORDITEM",Sub)),"^",16)
	....q:UFlag'=1
	....q:GPersonID'=""
	....i GPersonID="" s GPersonID=IADM
	..s SaleAmount=$p($G(^DHCPEPreA(AuditID)),"^",8)
	..q:SaleAmount=""
	..q:SaleAmount=0
	..s FactAmountTotal=$p($G(^DHCPEPreA(AuditID)),"^",9)
	..s wucha=SaleAmount-FactAmountTotal
	..i (wucha'=0)&&(GPersonID'="") d
	...s UserID=%session.Get("LOGON.USERID")
	...s ArcCode="PE011" ////体检调整费
	...s ArcimID=$O(^ARCIM(0,"Code",ArcCode,0))
	...q:ArcimID=""
	...s ArcimID=ArcimID_"||1"
	...q:UserID=""
	...d ##class(web.DHCPE.PreItemList).IInsertItem(GPersonID,"PERSON","PRE",ArcimID_"&"_wucha_"&4&","",UserID)
	
	q "0"
}

/// d ##class(web.DHCPE.PreAudit).InsertItemFactAmount("14010||4")
ClassMethod InsertItemFactAmount(PIOIRowID)
{
	new FactAmount
	s PreIADM=+PIOIRowID
	s ChildSub=$p(PIOIRowID,"||",2)
	q:($p(^DHCPEPreIADM(PreIADM,"ORDITEM",ChildSub),"^",16)'=1)
	s FactAmountTotal=0
	s Sub=0
	f  s Sub=$o(^DHCPEPreIADM(PreIADM,"ORDITEM",ChildSub,"FEE",Sub)) q:Sub=""  d
	.s PAuditDR=$p(^DHCPEPreIADM(PreIADM,"ORDITEM",ChildSub,"FEE",Sub),"^",5)
	.q:PAuditDR=""
	.s PAStatus=$p($G(^DHCPEPreA(PAuditDR)),21)
	.q:PAStatus="NU"
	.s FactAmount=$p(^DHCPEPreIADM(PreIADM,"ORDITEM",ChildSub,"FEE",Sub),"^",2)
	.s FactAmountTotal=FactAmountTotal+FactAmount
	&SQL(update sqluser.DHC_PE_PreIOrdItem set PIOI_FactAmount=:FactAmountTotal where PIOI_RowId=:PIOIRowID)
	i SQLCODE=0 d
	.s ^DHCPEFactAmount("ItemAmount",PIOIRowID)=FactAmountTotal_"^"_$H
}

/// d ##class(web.DHCPE.PreAudit).InsertEntFactAmount("14010||1")
ClassMethod InsertEntFactAmount(PIOERowID)
{
	n (PIOERowID)
	q:PIOERowID'["||"
	s PreIADM=+PIOERowID
	s OrdSetSub=$p(PIOERowID,"||",2)
	q:($p(^DHCPEPreIADM(PreIADM,"ORDENT",OrdSetSub),"^",9)'=1)
	d ##class(web.DHCPE.OrdSetsPrice).SplitOrdSetPrice(PIOERowID)
	s PreIADM=""
	f  s PreIADM=$o(^DHCPEPreIADM(0,"OrdEnt",PIOERowID,PreIADM)) q:PreIADM=""  d
	.s sub=0
	.f  s sub=$o(^DHCPEPreIADM(0,"OrdEnt",PIOERowID,PreIADM,sub)) q:sub=""  d
	..s ItemID=PreIADM_"||"_sub
	..s FactAmount=$G(^DHCPEDataEx("DHC_PE_PreIOrdItemFee","PIOEFEE",PIOERowID,ItemID))
	..&SQL(update sqluser.DHC_PE_PreIOrdItem set PIOI_FactAmount=:FactAmount where PIOI_RowId=:ItemID)
	..i SQLCODE=0 d
	...s ^DHCPEFactAmount("ItemAmount",ItemID)=FactAmount_"^"_$H
}

/// d ##class(web.DHCPE.PreAudit).UpdatePOIFactAmount("2019-08-29","2019-08-29")
ClassMethod UpdatePOIFactAmount(BeginDate As %Library.String = "", EndDate As %Library.String = "")
{
	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
	i EndDate'=""  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	i BeginDate="" s BeginDate=0
	i EndDate="" s EndDate=+$H
	k ^TempDHCPE("OrdEnt")
	
	//插入项目实际金额
	s Date=BeginDate-1
	f  s Date=$o(^DHCPEPreIADM(0,"UpdateDateTime",Date)) q:Date=""  d
	.s Time=0
	.f  s Time=$o(^DHCPEPreIADM(0,"UpdateDateTime",Date,Time)) q:Time=""  d
	..s PreIADM=""
	..f  s PreIADM=$o(^DHCPEPreIADM(0,"UpdateDateTime",Date,Time,PreIADM)) q:PreIADM=""  d
	...s PIOISub=0
	...f  s PIOISub=$o(^DHCPEPreIADM(0,"UpdateDateTime",Date,Time,PreIADM,PIOISub)) q:PIOISub=""  d
	....s OrdEntDR=$p(^DHCPEPreIADM(PreIADM,"ORDITEM",PIOISub),"^",2)
	....i OrdEntDR'="" d
	.....s ^TempDHCPE("OrdEnt",PreIADM,OrdEntDR)=""
    ....e  d
    .....d ##class(web.DHCPE.PreAudit).InsertItemFactAmount(PreIADM_"||"_PIOISub)
    
    s PIADM=0
    f  s PIADM=$o(^TempDHCPE("OrdEnt",PIADM)) q:PIADM=""  d
    .s OrdEnt=0
    .f  s OrdEnt=$o(^TempDHCPE("OrdEnt",PIADM,OrdEnt)) q:OrdEnt=""  d
    ..d ##class(web.DHCPE.PreAudit).InsertEntFactAmount(OrdEnt)
    
    q "0"
}

/// function :判断团体人员是否存在自费的项目
///  w ##Class(web.DHCPE.PreAudit).IsExsistIItem(2471)
ClassMethod IsExsistIItem(PIADM As %String = "")
{
	S flag=0
	S PARowId=""
	f  s PARowId=$o(^DHCPEPreA(0,"CRMADM","I",PIADM,PARowId)) q:PARowId=""  d
	.s PAStatus=$p($G(^DHCPEPreA(PARowId)),"^",21)
	.q:PAStatus="NU"
	.q:('$d(^DHCPEPreIADM(0,"PAORDITEM",PARowId)))&&('$d(^DHCPEPreIADM(0,"PAORDENT",PARowId)))
	.s flag=1
  	q flag
}

ClassMethod Insert(PreAudit, User As %String = "", Type, Remark As %String = "", Date As %String = "", Time As %String = "")
{
	;d ##class(web.DHCPE.PreAudit).Insert(78,"P","PRE","1","备注")
	s obj=##class(User.DHCPEAsCharged).%New()
	d obj.ACAuditDRSetObjectId(PreAudit)
	s:User="" User=%session.Get("LOGON.USERID")
	s:Date="" Date=+$H
	s:Time="" Time=$P($H,",",2)
	
	s obj.ACUser=User
	s obj.ACDate=Date
	s obj.ACTime=Time
	s obj.ACType=Type
	s obj.ACRemark=Remark
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

ClassMethod DeleteAsCharged(PreAuditID)
{
	;w ##class(web.DHCPE.PreAudit).DeleteAsCharged("")
	s ID=$o(^User.DHCPEAsChargedI("ACIndex",PreAuditID,0))
	q:ID="" ""
	s obj=##class(User.DHCPEAsCharged).%New()
	s sc=obj.%DeleteId(ID)
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
}

/// 更新历史数据
/// w ##class(web.DHCPE.PreAudit).Update()
ClassMethod Update()
{
	s Num=0
	s PreAuditID=""
	f  s PreAuditID=$o(^DHCPEPreA("AsCharged",PreAuditID)) q:PreAuditID=""  d
	.s Info=$G(^DHCPEPreA("AsCharged",PreAuditID))
	.s DateTime=$p(Info,"^",1)
	.s Date=$p(DateTime,",",1)
	.s Time=$p(DateTime,",",2)
	.s User=$p(Info,"^",2)
	.s Type=$p(Info,"^",3)
	.s Remark=$p(Info,"^",4)
	.d ##class(web.DHCPE.PreAudit).Insert(PreAuditID,User,Type,Remark,Date,Time)
	.s Num=Num+1
	
	q Num
}

}
