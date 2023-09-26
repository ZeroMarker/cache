/// 取消体检   wrz  080327
Class web.DHCPE.CancelPE Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Description: 撤销取消体检
/// Input: id:个人/分组/团体预约ID, Type:I/T/G（个人/分组/团体）
/// Debug:d ##class(web.DHCPE.CancelPE).UnCancelPE("312","I")
ClassMethod UnCancelPE(id, Type)
{
	s SQLCODE=0
	s Date=+$H
	s RtnStr=""
	s ReturnStr=""
	b ;id Type
	TSTART
	i Type="I" d
	.s Status=$p($g(^DHCPEPreIADM(id)),"^",8)
	
	.i Status'="CANCELPE" d
	..s RtnStr="不是取消体检状态"
	.e  d
	..d UnCancelPEPerson(id)
	e  i Type="T" d
	.d UnCancelPETeam(id)
	e  i Type="G" d
	.d UnCancelPEGroup(id)
	d UnUpdateAmount
	i SQLCODE'=0
	{
		TROLLBACK
		s ReturnStr="更新错误"
	}else{
		TCOMMIT
		s ReturnStr="撤销完成"
	}
	Q SQLCODE_"^"_$G(ReturnStr)

	//q:SQLCODE'=0 SQLCODE_"^更新错误"
	//q 0_"^撤销完成"
UnUpdateAmount
	q:SQLCODE'=0
	i Type="I" d
	.s GID=$p($g(^DHCPEPreIADM(id)),"^",2)
	.i GID="" d
	..s SQLCODE= ##class(web.DHCPE.PreIADM).UpdatePersonAuditAmount(id)
	.e  d
	..s SQLCODE= ##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(GID)
	e  d
	.s SQLCODE= ##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(+id)
	q	
UnCancelPEGroup(GID)
	s TeamSub=0
	f  s TeamSub=$o(^DHCPEPreGADM(GID,"Team",TeamSub)) q:(TeamSub="")||(SQLCODE'=0)  d
	.s TeamID=GID_"||"_TeamSub
	.d UnCancelPETeam(TeamID)
	q:SQLCODE'=0
	q:'$D(^DHCPEPreGADM(GID,"CancelPE"))
	s OldInfo=$G(^DHCPEPreGADM(GID,"CancelPE"))
	k ^DHCPEPreGADM(GID,"CancelPE")
	s OldStatus=$P(OldInfo,"^",1)
	s OldUser=$P(OldInfo,"^",2)
	s OldDate=$P(OldInfo,"^",3)
	&SQL(update sqluser.DHC_PE_PreGADM set PGADM_Status=:OldStatus,PGADM_UpdateUser_DR=:OldUser,PGADM_UpdateDate=:OldDate where PGADM_RowId=:GID)
	q:SQLCODE'=0
	d ##class(web.DHCPE.GAdmRecordManager).Insert(GID,"P","UNCANCELPE",%session.Get("LOGON.USERID"),"")
	s PEGADMId=$o(^DHCPEGADM(0,"CRMGADM",GID,0))
	q:PEGADMId=""
	&SQL(update sqluser.DHC_PE_GADM set GADM_Status=:OldStatus,GADM_UpdateUser_DR=:OldUser,GADM_UpdateDate=:OldDate where GADM_RowId=:PEGADMId)
	
	q
UnCancelPETeam(TID)
	s PIADMID=0
	f  s PIADMID=$o(^DHCPEPreIADM(0,"PGTeam",TID,PIADMID)) q:(PIADMID="")||(SQLCODE'=0)  d
	.d UnCancelPEPerson(PIADMID)
	q	
	
UnCancelPEPerson(PreIADM)
	
	q:SQLCODE'=0
	q:'$D(^DHCPEPreIADM(PreIADM,"CancelPE"))
	q:$p(^DHCPEPreIADM(PreIADM,"CancelPE"),"^",1)="CANCELPE"
	s OldInfo=$G(^DHCPEPreIADM(PreIADM,"CancelPE"))
	s OldStatus=$P(OldInfo,"^",1)
	s ADMLocID=$P($g(^DHCPEPreIADM(PreIADM)),"^",26) //就诊科室ID
	s IType="0"
	s ItemSub=0
	f  s ItemSub=$o(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub)) q:(ItemSub="")||(SQLCODE'=0)  d
	.s ItemStatus=$p($g(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub)),"^",16)
	.q:ItemStatus'="3"
	.s arcimID=$p($g(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub)),"^",1)
	.;s stationID=$O(^DHCPEST(0,"STORD_ARCIM",arcimID,0))
	.s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(arcimID,ADMLocID)
	.s stationID=+StatOrderID
	.s FeeSub=0
	.f  s FeeSub=$o(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub,"FEE",FeeSub)) q:(FeeSub="")||(SQLCODE'="0")  d
	..q:'$D(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub,"FEE",FeeSub,"CancelPE")) //=PreAudit
	..s PreAudit=$G(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub,"FEE",FeeSub,"CancelPE"))
	..s auditStatus=$p($g(^DHCPEPreA(PreAudit)),"^",21)
	..;q:auditStatus="NU"
	..s ChargedStatus=$p($g(^DHCPEPreA(PreAudit)),"^",14)
	..i (ChargedStatus="CHARGED")||(auditStatus="NU") d
	...s CRMADMType=$p($g(^DHCPEPreA(PreAudit)),"^",1)
	...s PACRMADM=$p($g(^DHCPEPreA(PreAudit)),"^",2)
	...s PACRMTeam=$p($g(^DHCPEPreA(PreAudit)),"^",22)
	...s:PACRMTeam'="" PACRMADM=PACRMTeam
	...s PreOrAdd=$p($g(^DHCPEPreA(PreAudit)),"^",20)
	...s SeleAuditRowid=""
	...s PAInfo=##class(web.DHCPE.PreItemList).GetPARowId(CRMADMType,PACRMADM,PreOrAdd,SeleAuditRowid)
	...s PreAudit=$P(PAInfo,"^",1)
	..s FeeID=PreIADM_"||"_ItemSub_"||"_FeeSub
	..&SQL(update sqluser.DHC_PE_PreIOrdItemFee set PIOIF_PAudit_DR=:PreAudit where PIOIF_RowID=:FeeID)
	.q:SQLCODE'="0"
	.s PreItemID=PreIADM_"||"_ItemSub
	.s CrmOrderID=$o(^DHCPECRMO(0,"CRMORI",PreItemID,0))
	.//更新OE_OrdItem
	.i CrmOrderID'=""  d
	..s OeordId=$p($g(^DHCPECRMO(CrmOrderID)),"^",1)
	..q:OeordId=""
	..&SQL(update sqluser.oe_orditem set oeori_itemstat_dr='1' where oeori_rowid=:OeordId)
	..i OeordId'="" d ##class(RISService.InvokeRISService).InsertAppPACS(OeordId) //撤销pacs申请
	.q:SQLCODE'=0
	.&SQL(update sqluser.DHC_PE_PreIOrdItem set PIOI_ItemStat='1' where PIOI_RowId=:PreItemID)
	.q:SQLCODE'=0
	.d ##class(web.DHCPE.PreItemList).UnItemDelDataEx(PreItemID,"")
	.d:OldStatus="ARRIVED" ##class(web.DHCPE.ItemDetailRecord).Insert(OeordId,"A","","")
	.//如果是套餐下的项目、更新套餐实际金额、优惠金额
	.//s PreOrdId=$p(^DHCPEPreIADM(PID,"ORDITEM",ItemSub),"^",2)
	.s PreOrdId=$p($g(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub)),"^",2)
	.q:PreOrdId=""
	.//s CurAmount=+$p(^DHCPEPreIADM(PID,"ORDITEM",ItemSub),"^",14)
	.s CurAmount=+$p($g(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub)),"^",14)
	.s SQLCODE=..UpdateOrdEntFee(PreOrdId,CurAmount,-1)
	q:SQLCODE'=0
	
	//判断这个人套餐中的是否还包含未删除的项目，如果没有删除套餐
	//如果是定价套餐恢复套餐价格
	 s SQLCODE=..UnUpdateOrdEntStatus(PreIADM)	
	//s SQLCODE=..UpdateIADMOrdEntStatus(PreIADM)	
	
	//q:SQLCODE'=0
	q:+SQLCODE'=0
	S PreIADM=$P(SQLCODE,"^",2)

	s OldInfo=$G(^DHCPEPreIADM(PreIADM,"CancelPE"))
	k ^DHCPEPreIADM(PreIADM,"CancelPE")
	s OldStatus=$P(OldInfo,"^",1)
	s OldUser=$P(OldInfo,"^",2)
	s OldDate=$P(OldInfo,"^",3)
	&SQL(update sqluser.DHC_PE_PreIADM set PIADM_Status=:OldStatus where PIADM_RowId=:PreIADM) ;,PIADM_UpdateUser_DR=:OldUser,PIADM_UpdateDate=:OldDate
	q:SQLCODE'=0
	s PEIADM=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	q:PEIADM=""
	&SQL(update sqluser.DHC_PE_IADM set IADM_Status=:OldStatus,IADM_UpdateUser_DR=:OldUser,IADM_UpdateDate=:OldDate where IADM_RowId=:PEIADM)
	d ##class(web.DHCPE.AdmRecordManager).Insert(PreIADM,"P","UNCANCELPE",%session.Get("LOGON.USERID"),"")
	q
}

ClassMethod UnUpdateOrdEntStatus(PID)
{
	s ^tempdhcpe("OrdEntStatus")=PID
	s SQLCODE=0
	s OrdEntSub=0
	f  s OrdEntSub=$o(^DHCPEPreIADM(PID,"ORDENT",OrdEntSub)) q:(OrdEntSub="")||(SQLCODE'=0)  d
	.s OrdEntId=PID_"||"_OrdEntSub
	.s ItemSub=0
	.s CurIADM=+OrdEntId
	.s Status=""
	.s User=%session.Get("LOGON.USERID")
	.s Date=+$H
	.f  s ItemSub=$o(^DHCPEPreIADM(0,"OrdEnt",OrdEntId,CurIADM,ItemSub)) q:(ItemSub="")||(Status="1")  d
	..s Status=$p($g(^DHCPEPreIADM(CurIADM,"ORDITEM",ItemSub)),"^",2)
	.i Status'="" d
	..d ##class(web.DHCPE.PreItemList).ItemDelDataEx("",OrdEntId,User)
	..s PreAudit=$G(^DHCPEPreIADMMark(PID,"CancelPE",1))
	..q:PreAudit=""
	..s auditStatus=$p($g(^DHCPEPreA(PreAudit)),"^",21)
	..;q:auditStatus="NU"
	..s ChargedStatus=$p($g(^DHCPEPreA(PreAudit)),"^",14)
	..i (ChargedStatus="CHARGED")||(auditStatus="NU") d
	...s CRMADMType=$p($g(^DHCPEPreA(PreAudit)),"^",1)
	...s PACRMADM=$p($g(^DHCPEPreA(PreAudit)),"^",2)
	...s PACRMTeam=$p($g(^DHCPEPreA(PreAudit)),"^",22)
	...s:PACRMTeam'="" PACRMADM=PACRMTeam
	...s PreOrAdd=$p($g(^DHCPEPreA(PreAudit)),"^",20)
	...s SeleAuditRowid=""
	...s PAInfo=##class(web.DHCPE.PreItemList).GetPARowId(CRMADMType,PACRMADM,PreOrAdd,SeleAuditRowid)
	...s PreAudit=$P(PAInfo,"^",1)
	..s FactAmount=$p($g(^DHCPEPreIADM(+PID,"ORDENT",$p(OrdEntId,"||",2))),"^",7)
	..&SQL(update sqluser.DHC_PE_PreIOrdEnt set PIOE_ItemStat='1' where PIOE_RowId=:OrdEntId)
    ..&SQL(update sqluser.DHC_PE_PreIOrdEntFee set PIOEF_PAudit_DR=:PreAudit,PIOEF_FactAmount=:FactAmount where PIOEF_ParRef=:OrdEntId)
	//q SQLCODE
	q SQLCODE_"^"_PID
}

/// Description: 取消体检、并且不计费用。如果有项目已收费、已执行则只是删除对应的未收费,未执行的项目，不修改状态
/// Debug: w ##class(web.DHCPE.CancelPE).CancelPE("128","G","0","18853","105")
ClassMethod CancelPE(id, Type, UnCancelFlag As %String = 0, UserID As %String = "", LocID As %String = "")
{
	s ^tempdhcpe("CancelPE")=$lb(id, Type, UnCancelFlag, UserID, LocID)
	i UnCancelFlag=1 q ..UnCancelPE(id,Type)
	s SQLCODE=0
	s ReturnType=0
	
	i UserID="" d
    .s User=%session.Get("LOGON.USERID")
    e  d
    .s User=UserID
    
	i LocID="" d
	.s CurLoc=%session.Get("LOGON.CTLOCID")
	e  d
	.s CurLoc=LocID
	
	s Date=+$H
	//TSTART
	s ReturnPerm=..GetItemPerm(Type,id,User)
	q:ReturnPerm="1" "^已到达,没有取消权限"
	q:ReturnPerm="3" "^已经取消体检,不能再取消"
	i Type="G" d GroupCancelPE(id)
	i Type="T" d TeamCancelPE(id)
	i Type="I" d PersonCancelPE(id)
	d UpdateAmount
	//修改团体状态为取消体检状态
	i (ReturnType=0)&&(Type="G") d UpdateGroupStatus
	i SQLCODE'=0
	{
		//TROLLBACK
		s ReturnStr="发生错误，没有完成取消体检"_SQLCODE_";"_$G(PIADMID)
	}
	else
	{
		s ^DHCPEDataEx("CancelPE",Type,id)=User_"^"_$H
	
		
		//TCOMMIT
		i ReturnType=0 s ReturnStr="完成取消体检操作"
		i ReturnType=1 s ReturnStr="存在已收费或者已执行项目的个人"   //"未收费、未执行的项目都已删除"
	}
	q SQLCODE_"^"_$G(ReturnStr)
GroupCancelPE(GID)
	s TeamSub=0
	f  s TeamSub=$o(^DHCPEPreGADM(GID,"Team",TeamSub)) q:(TeamSub="")||(SQLCODE'=0)  d
	.s TeamID=GID_"||"_TeamSub
	.d TeamCancelPE(TeamID)
	d ##class(web.DHCPE.GAdmRecordManager).Insert(GID,"P","CANCELPE",User, "")
	q
TeamCancelPE(TID)
	s PIADMID=0
	f  s PIADMID=$o(^DHCPEPreIADM(0,"PGTeam",TID,PIADMID)) q:(PIADMID="")||(SQLCODE'=0)  d
	.d PersonCancelPE(PIADMID)
	d:Type="T" ##class(web.DHCPE.GAdmRecordManager).Insert(+TID,"P","CANCELPE",User, TID)
	q
PersonCancelPE(PID)
	//判断是否存在已收费、已执行的项目
	//存在的话退出
	s CancelFlag=..CheckIAdmCanCancel(PID)
	i CancelFlag'="0" s ReturnType=CancelFlag
	s CancelPEType=$G(^DHCPESetting("DHCPE","CancelPEType",CurLoc))
	S PGADM=$P($G(^DHCPEPreIADM(PID)),"^",2)
	//【取消体检不删除未检】:对团体有效，对个人无效
	q:(CancelFlag="1")&&(PGADM="")
	q:(CancelFlag="1")&&(CancelPEType="1")&&(PGADM'="")
	//q:(CancelFlag="1")&&(CancelPEType="1")
	//删除项目、注释部分是上面不判断的时候把所有的未收费未执行的项目删除
	TSTART
	s OldStatus=$P($g(^DHCPEPreIADM(PID)),"^",8)
	s ADMLocID=$P($g(^DHCPEPreIADM(PID)),"^",26) //就诊科室ID
	k ^TMPDHCPEOrdSets("OrdSets","Status")
	s IType="0"
	s ItemSub=0
	f  s ItemSub=$o(^DHCPEPreIADM(PID,"ORDITEM",ItemSub)) q:(ItemSub="")||(SQLCODE'=0)  d
	.s ItemStatus=$p($G(^DHCPEPreIADM(PID,"ORDITEM",ItemSub)),"^",16)
	.q:ItemStatus'="1"
	.s arcimID=$p($g(^DHCPEPreIADM(PID,"ORDITEM",ItemSub)),"^",1)
	.;s stationID=$O(^DHCPEST(0,"STORD_ARCIM",arcimID,0))
	.;q:(CancelFlag=1)&&(stationID=$G(^DHCPESetting("DHCPE","StationId_Other")))
	.s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(arcimID,ADMLocID)
	.s stationID=+StatOrderID
	.q:(CancelFlag=1)&&(stationID=$G(^DHCPESetting("DHCPE","StationId_Other",ADMLocID)))
	.s CurrentType="0"
	.s OrdEntDR=""
	.s OrdEntDR=$p(^DHCPEPreIADM(PID,"ORDITEM",ItemSub),"^",2)
	.s FeeSub=0
	.f  s FeeSub=$o(^DHCPEPreIADM(PID,"ORDITEM",ItemSub,"FEE",FeeSub)) q:(FeeSub="")||(CurrentType="1")  d
	..s PreAudit=$p(^DHCPEPreIADM(PID,"ORDITEM",ItemSub,"FEE",FeeSub),"^",5)
	..q:PreAudit=""
	..s auditStatus=$p(^DHCPEPreA(PreAudit),"^",21)
	..q:auditStatus="NU"
	..s ChargedStatus=$p(^DHCPEPreA(PreAudit),"^",14)
	..i ChargedStatus="CHARGED" d
	...b ;ChargedStatus
	...s CurrentType="1"
	...s ReturnType="1"
	...s IType="1"
	..e  d
	...s ^DHCPEPreIADM(PID,"ORDITEM",ItemSub,"FEE",FeeSub,"CancelPE")=PreAudit
	.i OrdEntDR'="" d
	..s FeeSub=0
	..f  s FeeSub=$o(^DHCPEPreIADM(+OrdEntDR,"ORDENT",$P(OrdEntDR,"||",2),"FEE",FeeSub)) q:(FeeSub="")||(CurrentType="1")  d
	...s PreAudit=$p(^DHCPEPreIADM(+OrdEntDR,"ORDENT",$P(OrdEntDR,"||",2),"FEE",FeeSub),"^",5)
	...q:PreAudit=""
	...s auditStatus=$p(^DHCPEPreA(PreAudit),"^",21)
	...q:auditStatus="NU"
	...s ChargedStatus=$p(^DHCPEPreA(PreAudit),"^",14)
	...i ChargedStatus="CHARGED" d
	....s CurrentType="1"
	....s ReturnType="1"
	....s IType="1"
	...e  d
	....s ^DHCPEPreIADM(+OrdEntDR,"ORDENT",$P(OrdEntDR,"||",2),"FEE",FeeSub,"CancelPE")=PreAudit
	.q:CurrentType="1"
	.s PreItemID=PID_"||"_ItemSub
	.
	.s CrmOrderID=$o(^DHCPECRMO(0,"CRMORI",PreItemID,0))
	
	.//更新OE_OrdItem
	.i CrmOrderID'=""  d
	..s OeordId=$p(^DHCPECRMO(CrmOrderID),"^",1)
	..s ARCIMDR=$P($G(^OEORD(+OeordId,"I",$p(OeordId,"||",2),1)),"^",2)
	..q:ARCIMDR=""
	..;s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",ARCIMDR,0))
	..s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIMDR,ADMLocID)
	..s STRowId=+StatOrderID
	..s OeordIdStat=$p($G(^OEORD(+OeordId,"I",$p(OeordId,"||",2),1)),"^",13)
	..i (OrdEntDR'="")&&(OeordIdStat="6") s ^TMPDHCPEOrdSets("OrdSets","Status",OrdEntDR)=1
	..i OeordIdStat="6" d
	...s CurrentType="1"
	...s ReturnType="1"
	...s IType="1"
	..e  d
	...;i (STRowId=$g(^DHCPESetting("DHCPE","StationId_Medical"))) d
	...i (STRowId=$g(^DHCPESetting("DHCPE","StationId_Medical",ADMLocID))) d
    ....s OEDId=$o(^DHCOEDISQTY(0,"OEORI",OeordId,""),-1)
	....i OEDId'="" d
	.....s OEDStatus=$p(^DHCOEDISQTY(OEDId),"^",7)
	.....i OEDStatus="C" d
	......s CurrentType="1"
	......s ReturnType="1"
	......s IType="1"
	.....e  d
	......;d:OldStatus="ARRIVED" ##class(web.DHCPE.ItemDetailRecord).Insert(OeordId,"D",User,"")
	......&SQL(update sqluser.oe_orditem set oeori_itemstat_dr='4' where oeori_rowid=:OeordId)
	......//减药品库存
	......d ##class(web.DHCOEDispensing).Return(OeordId) 
	...e  d  
	....q:((OrdEntDR'="")&&($d(^TMPDHCPEOrdSets("OrdSets","Status",OrdEntDR)))) //added 套餐有执行的不删除医嘱
	....d ##class(web.DHCPE.CRM.RisGateway).SendInfo("D",OeordId,User) 
	....;d:OldStatus="ARRIVED" ##class(web.DHCPE.ItemDetailRecord).Insert(OeordId,"D",User,"")
	....d ##Class(RISService.InvokeRISService).DiscontinueAppInfoPACS(OeordId,"","D") //停医嘱时,撤销pacs的申请
	....&SQL(update sqluser.oe_orditem set oeori_itemstat_dr='4' where oeori_rowid=:OeordId)

	.s:SQLCODE=100 SQLCODE=0
	.q:SQLCODE'=0
	
	.//更新预约项目
	.q:CurrentType="1"
	.s DeleteInfo=##class(web.DHCPE.PreItemList2).IDeleteItem(PID, "PERSON", PreItemID, "", "0", User,"3")
	.i DeleteInfo="" d
	..s SQLCODE=0
	.e  d
	..s SQLCODE=DeleteInfo
	/*
	.&SQL(update sqluser.DHC_PE_PreIOrdItem set PIOI_ItemStat='3' where PIOI_RowId=:PreItemID)
	.s:SQLCODE=100 SQLCODE=0
	.q:SQLCODE'=0
	.s PreOrdId=$p(^DHCPEPreIADM(PID,"ORDITEM",ItemSub),"^",2)
	.i PreOrdId="" &SQL(update sqluser.DHC_PE_PreIOrdItemFee set PIOIF_PAudit_DR=null where PIOIF_ParRef=:PreItemID and PIOIF_PAudit_DR->PA_Status='U')
	.s:SQLCODE=100 SQLCODE=0
	.q:SQLCODE'=0
	.
	.d ##class(web.DHCPE.PreItemList).ItemDelDataEx(PreItemID,"",User)
	.//如果是套餐下的项目、更新套餐实际金额、优惠金额
	.s PreOrdId=$p(^DHCPEPreIADM(PID,"ORDITEM",ItemSub),"^",2)
	.q:PreOrdId=""
	.s CurAmount=+$p(^DHCPEPreIADM(PID,"ORDITEM",ItemSub),"^",14)
	.s SQLCODE=..UpdateOrdEntFee(PreOrdId,CurAmount)
	.s:SQLCODE=100 SQLCODE=0
	q:SQLCODE'=0
	*/
	TROLLBACK:SQLCODE'=0
	q:SQLCODE'=0
	//判断这个人套餐中的是否还包含未删除的项目，如果没有删除套餐
	s SQLCODE=..UpdateIADMOrdEntStatus(PID,User)
	TROLLBACK:SQLCODE'=0	
	s:SQLCODE=100 SQLCODE=0
	//看是否需要更改人员状态
	i IType="0" d
	.s OldStatus=$P(^DHCPEPreIADM(PID),"^",8)
	.s OldUser=$P(^DHCPEPreIADM(PID),"^",21)
	.s OldDate=$P(^DHCPEPreIADM(PID),"^",22)
	.s ^DHCPEPreIADM(PID,"CancelPE")=OldStatus_"^"_OldUser_"^"_OldDate
	.&SQL(update sqluser.DHC_PE_PreIADM set PIADM_Status='CANCELPE' where PIADM_RowId=:PID) ;,PIADM_UpdateUser_DR=:User,PIADM_UpdateDate=:Date
	.s:SQLCODE=100 SQLCODE=0
	.q:SQLCODE'=0
	.s PEIADM=$o(^DHCPEIADM(0,"CRMADM",PID,0))
	.q:PEIADM=""
	.&SQL(update sqluser.DHC_PE_IADM set IADM_Status='CANCELPE',IADM_UpdateUser_DR=:User,IADM_UpdateDate=:Date where IADM_RowId=:PEIADM) 
	
	TROLLBACK:SQLCODE'=0
	TCOMMIT:SQLCODE=0
	d ##class(web.DHCPE.AdmRecordManager).Insert(PID,"P","CANCELPE",User,"")
	q
	
UpdateAmount
	q:SQLCODE'=0
	i Type="I" d
	.s GID=$p(^DHCPEPreIADM(id),"^",2)
	.i GID="" d
	..s SQLCODE= ##class(web.DHCPE.PreIADM).UpdatePersonAuditAmount(id)
	.e  d
	..s SQLCODE= ##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(GID,1)
	e  d
	.s SQLCODE= ##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(+id,1)
	s:SQLCODE=100 SQLCODE=0
	q
UpdateGroupStatus
	q:SQLCODE'=0
	s OldStatus=$P(^DHCPEPreGADM(id),"^",6)
	s OldUser=$P(^DHCPEPreGADM(id),"^",19)
	s OldDate=$P(^DHCPEPreGADM(id),"^",20)
	s ^DHCPEPreGADM(id,"CancelPE")=OldStatus_"^"_OldUser_"^"_OldDate
	&SQL(update sqluser.DHC_PE_PreGADM set PGADM_Status='CANCELPE',PGADM_UpdateUser_DR=:User,PGADM_UpdateDate=:Date where PGADM_RowId=:id)
	s:SQLCODE=100 SQLCODE=0
	q:SQLCODE'=0
	s PEGADMId=$o(^DHCPEGADM(0,"CRMGADM",id,0))
	q:PEGADMId=""
	&SQL(update sqluser.DHC_PE_GADM set GADM_Status='CANCELPE',GADM_UpdateUser_DR=:User,GADM_UpdateDate=:Date where GADM_RowId=:PEGADMId)
	q
}

/// Description: 按照比例更新套餐中的实收、应收金额
/// Debug：d ##class(web.DHCPE.CancelPE).UpdateOrdEntFee()
ClassMethod UpdateOrdEntFee(OrdEntId, Amount, FHType As %String = 1)
{
	s CurOrdEntAmount=$p($g(^DHCPEPreIADM(+OrdEntId,"ORDENT",$p(OrdEntId,"||",2))),"^",7)
	s CurOrdEntFactAmount=##class(web.DHCPE.HandlerPreOrds).GetFactAmountByOrd(OrdEntId,"","")
	i ((+CurOrdEntAmount'=0)||(+CurOrdEntAmount'=0.00)) d
	.s Percent=CurOrdEntFactAmount/CurOrdEntAmount
	e  d
	.s Percent=0
	s UFactAmount=FHType*Amount*Percent
	s UAmount=(+CurOrdEntAmount)-(FHType*Amount)
	&SQL(update sqluser.DHC_PE_PreIOrdEnt set PIOE_AccountAmount=:UAmount where PIOE_RowId=:OrdEntId)
	q:SQLCODE'=0 SQLCODE
	s CurOdEntFeeSub=0
	d UpdateOrdEntFactFee
	q SQLCODE
UpdateOrdEntFactFee
	s CurOdEntFeeSub=$o(^DHCPEPreIADM(+OrdEntId,"ORDENT",$p(OrdEntId,"||",2),"FEE",CurOdEntFeeSub))
	q:CurOdEntFeeSub=""
	s CurFactAmount=$p($g(^DHCPEPreIADM(+OrdEntId,"ORDENT",$p(OrdEntId,"||",2),"FEE",CurOdEntFeeSub)),"^",2)
	s CurUFactAmount=CurFactAmount-UFactAmount
	i CurUFactAmount<0 d
	.s UFactAmount=-CurUFactAmount
	.s CurUFactAmount=0
	e  d
	.s UFactAmount=0
	s OrdFeeId=OrdEntId_"||"_CurOdEntFeeSub
	&SQL(update sqluser.DHC_PE_PreIOrdEntFee set PIOEF_FactAmount=:CurUFactAmount where PIOEF_RowId=:OrdFeeId)
	q:SQLCODE'=0
	i UFactAmount>0 d UpdateOrdEntFactFee
}

ClassMethod UpdateIADMOrdEntStatus(PID, User As %String = "")
{
	s SQLCODE=0
	s OrdEntSub=0
	f  s OrdEntSub=$o(^DHCPEPreIADM(PID,"ORDENT",OrdEntSub)) q:(OrdEntSub="")||(SQLCODE'=0)  d
	.s OrdEntId=PID_"||"_OrdEntSub
	.s SQLCODE=..UpdateOrdEntStatus(OrdEntId,User)
	q SQLCODE
}

ClassMethod UpdateOrdEntStatus(OrdEntId, User As %String = "")
{
	s SQLCODE=0
	s ItemSub=0
	s CurIADM=+OrdEntId
	s Status=""
	s:User="" User=%session.Get("LOGON.USERID")
	s Date=+$H
	f  s ItemSub=$o(^DHCPEPreIADM(0,"OrdEnt",OrdEntId,CurIADM,ItemSub)) q:(ItemSub="")||(Status="1")  d
	.s Status=$p(^DHCPEPreIADM(CurIADM,"ORDITEM",ItemSub),"^",16)
	i Status'="1" d
	.d ##class(web.DHCPE.PreItemList).ItemDelDataEx("",OrdEntId,User)
	.S ^DHCPEPreIADMMark(CurIADM,"CancelPE",1)=$p($g(^DHCPEPreIADM(CurIADM,"ORDENT",1,"FEE",1)),"^",5)
	.&SQL(update sqluser.DHC_PE_PreIOrdEnt set PIOE_ItemStat='3' where PIOE_RowId=:OrdEntId)
	.//&SQL(update sqluser.DHC_PE_PreIOrdEnt set PIOE_ItemStat='3',PIOE_UpdateUser_DR=:User,PIOE_UpdateDate=:Date where PIOE_RowId=:OrdEntId)
    .
    .&SQL(update sqluser.DHC_PE_PreIOrdEntFee set PIOEF_PAudit_DR=null where PIOEF_ParRef=:OrdEntId and PIOEF_PAudit_DR->PA_Status='U')
	q SQLCODE
}

/// Creator:		jinlei	
/// CreatDate:		2019-12-20
/// Description:	判断批量分组是否可以取消体检
/// Table:		
/// Input:		PIADMStr
/// Output:		
/// Return:		
/// Debug:		w ##class(web.DHCPE.test).wDoc("")        
ClassMethod CheckIAdmsCanCancel(PIADMStr)
{
	s ret=0
	s pats=""
    s Len=$L(PIADMStr,"^")
    for i=1:1:Len d
    .s PID=$P(PIADMStr,"^",i)
    .s oneflag=..CheckIAdmCanCancel(PID)
    .i oneflag=1 d
    ..s PIBI=+$P(^DHCPEPreIADM(PID),"^",1)
    ..s PatName=$P(^DHCPEPreIBI(PIBI),"^",2)
    ..i pats'="" s pats=pats_","_PatName
    ..e  s pats=PatName
   	
   	s flag=0
   	s:pats'="" flag=1
   	q flag_"^"_pats
}

// 1不能取消体检

ClassMethod CheckIAdmCanCancel(PID)
{

	s CurReturnType="0"
	s ADMLocID=$P($g(^DHCPEPreIADM(PID)),"^",26) //就诊科室ID
	s ItemSub=0
	f  s ItemSub=$o(^DHCPEPreIADM(PID,"ORDITEM",ItemSub)) q:(ItemSub="")||(CurReturnType="1")  d
	.s ItemStatus=$p($g(^DHCPEPreIADM(PID,"ORDITEM",ItemSub)),"^",16)
	.q:ItemStatus'="1"
	.s OrdEntDR=$p($g(^DHCPEPreIADM(PID,"ORDITEM",ItemSub)),"^",2)      //add by zhouli
	.//判断是否收费
	.s FeeSub=0
	.f  s FeeSub=$o(^DHCPEPreIADM(PID,"ORDITEM",ItemSub,"FEE",FeeSub)) q:(FeeSub="")||(CurReturnType="1")  d
	..s PreAudit=$p($g(^DHCPEPreIADM(PID,"ORDITEM",ItemSub,"FEE",FeeSub)),"^",5)
	..q:PreAudit=""
	..s UseFlag=$p($g(^DHCPEPreA(PreAudit)),"^",21)
	..q:UseFlag="NU"
	..s ChargedStatus=$p($g(^DHCPEPreA(PreAudit)),"^",14)
	..i (ChargedStatus="CHARGED") d
	...s CurReturnType="1"
	.//当只有医嘱套时 判断是否收费           //add by zhouli start
	.i OrdEntDR'=""   d
	..s OrdEntFeeSub=0
	..f  s OrdEntFeeSub=$o(^DHCPEPreIADM($p(OrdEntDR,"||",1),"ORDENT",$p(OrdEntDR,"||",2),"FEE",OrdEntFeeSub))  q:OrdEntFeeSub=""  d
	...s PreAudit=$p($g(^DHCPEPreIADM($p(OrdEntDR,"||",1),"ORDENT",$p(OrdEntDR,"||",2),"FEE",OrdEntFeeSub)),"^",5)
	...q:PreAudit=""
	...s UseFlag=$p($g(^DHCPEPreA(PreAudit)),"^",21)
	...q:UseFlag="NU"
	...s ChargedStatus=$p($g(^DHCPEPreA(PreAudit)),"^",14)
	...i (ChargedStatus="CHARGED") d
	....s CurReturnType="1"                        //add by zhouli end
	.q:CurReturnType="1"
	.s PreItemID=PID_"||"_ItemSub
	.s CrmOrderID=$o(^DHCPECRMO(0,"CRMORI",PreItemID,0))
	.//判断是否执行
	.i CrmOrderID'=""  d
	..s OeordId=$p($g(^DHCPECRMO(CrmOrderID)),"^",1)
	..s OeordIdStat=$p($g(^OEORD(+OeordId,"I",$p(OeordId,"||",2),1)),"^",13)
	..s ARCIMDR=$P($g(^OEORD(+OeordId,"I",$p(OeordId,"||",2),1)),"^",2)
	..;s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",ARCIMDR,0))
	..s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ARCIMDR,ADMLocID)
	..s STRowId=+StatOrderID
	..i OeordIdStat="6" d
	...s CurReturnType="1"
	..;i ((OeordIdStat="1")&&(STRowId=$g(^DHCPESetting("DHCPE","StationId_Medical")))) d
	..i ((OeordIdStat="1")&&(STRowId=$g(^DHCPESetting("DHCPE","StationId_Medical",ADMLocID)))) d
    ... s OEDId=$o(^DHCOEDISQTY(0,"OEORI",OeordId,""),-1)
	...i OEDId'="" d
	....s OEDStatus=$p($g(^DHCOEDISQTY(OEDId)),"^",7)
	....i OEDStatus="C" s CurReturnType="1" //已发药

	/*
	.i CrmOrderID'=""  d
	..s OeordId=$p(^DHCPECRMO(CrmOrderID),"^",1)
	..s OeordIdStat=$p($G(^OEORD(+OeordId,"I",$p(OeordId,"||",2),1)),"^",13)
	..i OeordIdStat="6" d
	...s CurReturnType="1"
   */
	q CurReturnType
}

ClassMethod GetItemPerm(Type, ID, User)
{
	i Type="TEAM" S Type="T"
	i Type="PERSON" s Type="I"
	s PermFlag=""
	i Type="G" d 
	.s Status=$p(^DHCPEPreGADM(ID),"^",6)
	i Type="T" d
	.s PIADMRowId=0
	.s Status=""
	.f  s PIADMRowId=$o(^DHCPEPreIADM(0,"PGTeam",ID,PIADMRowId))  q:PIADMRowId=""  d
	..s PIADMStatus=$p(^DHCPEPreIADM(PIADMRowId),"^",8)
	..i PIADMStatus="ARRIVED" s Status="ARRIVED"
	..i PIADMStatus="CANCELPE" s Status="CANCELPE"
	..i PIADMStatus="PREREG" s Status="PREREG"
	..i PIADMStatus="REGISTERED" s Status="REGISTERED"

	i Type="I" d 
	.s Status=$p(^DHCPEPreIADM(ID),"^",8)
	q:Status="CANCELPE" "3"
	q:Status'="ARRIVED" ""
	
	Set UserID=%session.Get("LOGON.USERID")
	Set LocID=%session.Get("LOGON.CTLOCID")
	Set UserStr=$G(^DHCPESetting("DHCPE","ItemContralPerm",LocID))
	if ((UserStr'="")&&(("^"_UserStr_"^")'[("^"_UserID_"^"))) s PermFlag=1
	q PermFlag
}

ClassMethod DealData()
{
	;w ##class(web.DHCPE.CancelPE).DealData()
	s TeamID="1422||1"
	s SQLCODE=0
	TSTART
	s PID=0
	f  s PID=$O(^DHCPEPreIADM(0,"PGTeam",TeamID,PID)) q:(PID="")||(SQLCODE'=0)  d
	.s SQLCODE=..DealOneData(PID)
	.w PID_"^"_SQLCODE,!
	i SQLCODE=0
	{
		d ##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(+TeamID)
		TCOMMIT
		q SQLCODE
	}
	TROLLBACK
	q SQLCODE
}

ClassMethod DealOneData(PID)
{
	;w ##class(web.DHCPE.CancelPE).DealOneData("77254")
	;TSTART
	s PreAuditID="161466"
	s Price=1500
	
	s SQLCODE=0
	s IADM=$O(^DHCPEIADM(0,"CRMADM",PID,0))
	&sql(Update Sqluser.DHC_PE_preIordEnt set PIOE_AccountAmount=:Price,PIOE_ItemStat='1' where PIOE_ParRef=:PID)
	q:SQLCODE'=0 SQLCODE
	&sql(Update Sqluser.DHC_PE_preIordEntFee set PIOEF_PAudit_DR=:PreAuditID where +PIOEF_ParRef=:PID)
	q:SQLCODE'=0 SQLCODE
	&sql(Update Sqluser.DHC_PE_preIordItemFee set PIOIF_PAudit_DR=:PreAuditID where +PIOIF_ParRef=:PID)
	q:SQLCODE'=0 SQLCODE
	&sql(Update Sqluser.DHC_PE_preIordItem set PIOI_ItemStat='1' where PIOI_ParRef=:PID)
	q:SQLCODE'=0 SQLCODE
	i IADM'="" d
	.&SQL(Update Sqluser.DHC_PE_PreIADM set PIADM_Status='REGISTERED' where PIADM_rowid=:PID)
	.q:SQLCODE'=0
	.&SQL(Update Sqluser.DHC_PE_IADM set IADM_Status='REGISTERED' where IADM_rowid=:IADM)
	.q:SQLCODE'=0
	.s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	.&SQL(Update Sqluser.OE_OrdItem set OEORI_ItemStat_DR='1' where OEORI_OEORD_ParRef->OEORD_Adm_dr=:PAADM)
	e  d
	.&SQL(Update Sqluser.DHC_PE_PreIADM set PIADM_Status='PREREG' where PIADM_rowid=:PID)
	;TROLLBACK
	
	q SQLCODE
}

ClassMethod UpdateData()
{
	;d ##class(web.DHCPE.CancelPE).UpdateData()
	s GID=1210
	tstart
	s $ZT="Err"
	s SQLCODE=0
	s TeamSub=0
	f  s TeamSub=$o(^DHCPEPreGADM(GID,"Team",TeamSub)) q:(TeamSub="")  d
	.s TeamID=GID_"||"_TeamSub
	.s:TeamSub=2 Fee=1500
	.s:TeamSub=3 Fee=1500
	.s:TeamSub=4 Fee=1000
	.q:TeamSub="1"
	.q:TeamSub="5"
	.s PIADMID=0
	.f  s PIADMID=$o(^DHCPEPreIADM(0,"PGTeam",TeamID,PIADMID)) q:(PIADMID="")  d
	..s Status=$p(^DHCPEPreIADM(PIADMID),"^",8)
	..q:Status'="ARRIVED"
	..s ItemSub=0
	..f  s ItemSub=$o(^DHCPEPreIADM(PIADMID,"ORDITEM",ItemSub)) q:(ItemSub="")  d
	...s ItemStatus=$p(^DHCPEPreIADM(PIADMID,"ORDITEM",ItemSub),"^",16)
	...q:ItemStatus'="3"
	...s EntID=$p(^DHCPEPreIADM(PIADMID,"ORDITEM",ItemSub),"^",2)
	...i EntID="" d
	....
	...e  d
	....s ItemPrice=$p(^DHCPEPreIADM(PIADMID,"ORDITEM",ItemSub),"^",14)
	....s PreItemID=PIADMID_"||"_ItemSub
	....s CrmOrderID=$o(^DHCPECRMO(0,"CRMORI",PreItemID,0))
	....//更新OE_OrdItem
	....i CrmOrderID'=""  d
	.....s OeordId=$p(^DHCPECRMO(CrmOrderID),"^",1)
	.....q:OeordId=""
	.....&SQL(update sqluser.oe_orditem set oeori_itemstat_dr='1' where oeori_rowid=:OeordId)
	.....w:SQLCODE'=0 SQLCODE,!
	....q:SQLCODE'=0
	....&SQL(update sqluser.DHC_PE_PreIOrdItem set PIOI_ItemStat='1' where PIOI_RowId=:PreItemID)
	....w:SQLCODE'=0 SQLCODE,!
	....q:SQLCODE'=0
	....d ##class(web.DHCPE.PreItemList).UnItemDelDataEx(PreItemID,"")
	....s EntFeeSub=0
	....s EntFeeSub=$O(^DHCPEPreIADM(PIADMID,"ORDENT",$P(EntID,"||",2),"FEE",0))
	....&sql(update sqluser.DHC_PE_PreIordEnt Set PIOE_AccountAmount=:Fee where PIOE_RowID=:EntID)
	....w:SQLCODE'=0 SQLCODE,!
	....s EntFeeID=EntID_"||"_EntFeeSub
	....;w EntFeeID,!
	....&sql(update sqluser.DHC_PE_PreIordEntFee Set PIOEF_FactAmount=:Fee where PIOEF_RowID=:EntFeeID)
	....w:SQLCODE'=0 SQLCODE,!
	s SQLCODE= ##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(GID)
	trollback:SQLCODE'=0
	TCOMMIT
	w "OK"
	q
Err
	trollback
	w "Err"
}

ClassMethod UpdateCancelPEStatus(PAADM, User)
{
	
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	s PID=$P(^DHCPEIADM(IADM),"^",4)
	s Status=$P(^DHCPEPreIADM(PID),"^",8)
	q:Status'="REGISTERED" "不是登记状态，不允许被替换"
	q:Status="ARRIVED" "已经到达，不允许被替换"
	s NewStatus="CANCELPE"
	s:Status="CANCELPE" NewStatus="REGISTERED"
	s SQLCODE=0
	TSTART
	&SQL(update sqluser.DHC_PE_PreIADM set PIADM_Status=:NewStatus where PIADM_RowId=:PID) ;,PIADM_UpdateUser_DR=:User,PIADM_UpdateDate=:Date
	TROLLBACK:SQLCODE'=0
	q:SQLCODE'=0 "更新PreIADM错误:"_SQLCODE
	s PEIADM=$o(^DHCPEIADM(0,"CRMADM",PID,0))
	q:PEIADM="" 0
	s Date=+$H
	s NewStatus="CANCELPE"
	s:Status="CANCELPE" NewStatus="ARRIVED"
	&SQL(update sqluser.DHC_PE_IADM set IADM_Status=:NewStatus,IADM_UpdateUser_DR=:User,IADM_UpdateDate=:Date where IADM_RowId=:PEIADM) 
	TROLLBACK:SQLCODE'=0
	q:SQLCODE'=0 "更新IADM错误:"_SQLCODE
	TCOMMIT
	q 0
}

// d ##class(web.DHCPE.CancelPE).AutoCancelPE("2502")

ClassMethod AutoCancelPE(UserID)
{
	s Date=+$H-1
	s EndDate=""
	f  s EndDate=$O(^DHCPEPreIADM(0,"BookDateTime",Date,EndDate)) q:EndDate=""  d
	.s Time=""
	.f  s Time=$O(^DHCPEPreIADM(0,"BookDateTime",Date,EndDate,Time)) q:Time=""  d
	..s PreIADMID=""
	..f  s PreIADMID=$O(^DHCPEPreIADM(0,"BookDateTime",Date,EndDate,Time,PreIADMID)) q:PreIADMID=""  d
	...;b ;105145 PreIADMID
	...s Status=$P(^DHCPEPreIADM(PreIADMID),"^",8)
	...q:Status="CANCELPE"
	...s QZFlag=0
	...s:Status'="ARRIVED" QZFlag=1
	...s GID=$P(^DHCPEPreIADM(PreIADMID),"^",2)
	...q:GID'=""
	...d ..CancelPE(PreIADMID,"I",0,UserID)
}

Storage Default
{
<Data name="CancelPEDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCP.CancelPED</DataLocation>
<DefaultData>CancelPEDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCP.CancelPED</IdLocation>
<IndexLocation>^web.DHCP.CancelPEI</IndexLocation>
<StreamLocation>^web.DHCP.CancelPES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
