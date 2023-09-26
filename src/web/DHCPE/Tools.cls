Import sqluser

Class web.DHCPE.Tools Extends %RegisteredObject
{

// d ##class(web.DHCPE.Tools).UnCancelPE(GroupID)

ClassMethod UnCancelPE(GroupID)
{
	s $ZT="UnCancelPE"
	q:GroupID="" "NOGROUP"
	TSTART
	s GID=$O(^DHCPEGADM(0,"CRMGADM",GroupID,0))
	&SQL(Update Sqluser.DHC_PE_PreGADM set PGADM_Status="REGISTERED" where PGADM_RowID=:GroupID)
	i SQLCODE'=0{
		TROLLBACK
		q "PreGADMErr"
	}
	&SQL(Update Sqluser.DHC_PE_GADM set GADM_Status="REGISTERED" where GADM_RowID=:GID)
	i SQLCODE'=0{
		TROLLBACK
		q "PreGADMErr"
	}
	s TeamSub=0
	f  s TeamSub=$o(^DHCPEPreGADM(GroupID,"Team",TeamSub)) q:(TeamSub="")||(SQLCODE'=0)  d
	.s TeamID=GroupID_"||"_TeamSub
	.s PIADMID=0
	..f  s PIADMID=$o(^DHCPEPreIADM(0,"PGTeam",TeamID,PIADMID)) q:(PIADMID="")||(SQLCODE'=0)  d
	...s Status=$P(^DHCPEPreIADM(PIADMID),"^",8)
	...q:Status'="CANCELPE"
	...&SQL(Update Sqluser.DHC_PE_PreIADM Set PIADM_Status="REGISTERED" where PIADM_RowID=:PIADMID)
	...q:SQLCODE'=0
	...s PreIADM=PIADMID
	...s ItemSub=0
	...f  s ItemSub=$o(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub)) q:(ItemSub="")||(SQLCODE'=0)  d
	....s PreItemID=PreIADM_"||"_ItemSub
	....s ItemStatus=$p(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub),"^",16)
	....q:ItemStatus'="3"
	....s arcimID=$p(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub),"^",1)
	....s stationID=$O(^DHCPEST(0,"STORD_ARCIM",arcimID,0))
	....s FeeSub=0
	....f  s FeeSub=$o(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub,"FEE",FeeSub)) q:(FeeSub="")||(SQLCODE'="0")  d
	.....s SeleAuditRowid=""
	.....s PAInfo=##class(web.DHCPE.PreItemList).GetPARowId("G",GroupID,"PRE",SeleAuditRowid)
	.....s PreAudit=$P(PAInfo,"^",1)
	.....s FeeID=PreIADM_"||"_ItemSub_"||"_FeeSub
	.....&SQL(update sqluser.DHC_PE_PreIOrdItemFee set PIOIF_PAudit_DR=:PreAudit where PIOIF_RowID=:FeeID)
	....q:SQLCODE'=0
	....&SQL(update sqluser.DHC_PE_PreIOrdItem set PIOI_ItemStat='1' where PIOI_RowId=:PreItemID)
	....q:SQLCODE'=0
	....s CrmOrderID=$o(^DHCPECRMO(0,"CRMORI",PreItemID,0))
	....//更新OE_OrdItem
	....i CrmOrderID'=""  d
	.....s OeordId=$p(^DHCPECRMO(CrmOrderID),"^",1)
	.....q:OeordId=""
	.....&SQL(update sqluser.oe_orditem set oeori_itemstat_dr='1' where oeori_rowid=:OeordId)
	....q:SQLCODE'=0
	...s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADMID,0))
	...q:IADM=""
	...&SQL(update sqluser.DHC_PE_IADM set IADM_Status="REGISTERED" where IADM_RowId=:IADM)
	...q:SQLCODE'=0
	i SQLCODE'=0
	{
		TROLLBACK
		q "UPIADMErr"
	}
	s SQLCODE= ##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(GroupID)
	i SQLCODE'=0
	{
		TROLLBACK
		q "FeeUP"
	}
	TCOMMIT
	q "OVER"
	
UnCancelPE
	TROLLBACK
	q "ErrInfo"
}

ClassMethod UpdateAuditDocBySpec()
{
	;d ##class(web.DHCPE.Tools).UpdateAuditDocBySpec()
	s labspec="8010000000"
	f  s labspec=$O(^TEPI(labspec)) q:labspec=""  d
	.d OneSpec
	q
OneSpec
	s Ord=$O(^OEORD(0,"EpisNo",+labspec,0))
	s Sub=0
	f  s Sub=$O(^OEORD(0,"EpisNo",+labspec,Ord,Sub)) q:Sub=""  d
	.s OEORI=Ord_"||"_Sub
	.q:'$D(^DHCPERLT(0,"OEORI",OEORI))
	.s LabItemCode=""
	.s LabItemCode=$O(^TEPI(labspec,1,LabItemCode))
	.q:LabItemCode=""
	.s AuditUser=$p($g(^TEPI(labspec,1,LabItemCode,1)),"\",6)
	.s ReportUser=$p($g(^TEPI(labspec,1,LabItemCode,1)),"\",3)
	.s ^DHCPEDataEx("Report","DHCPEIReport","LisAuditUser",OEORI)=AuditUser
	.&SQL(Update Sqluser.DHC_PE_Result set RLT_User_DR=:ReportUser where RLT_OEORI_DR=:OEORI)
	.w OEORI_"^"_SQLCODE,!
}

ClassMethod UpdateAuditDoc()
{
	;d ##class(web.DHCPE.Tools).UpdateAuditDoc()
	
	s OEORI=""
	f  s OEORI=$O(^DHCPERLT(0,"OEORI",OEORI)) q:(OEORI="")  d
	.s labspec=$P($G(^OEORD(+OEORI,"I",$P(OEORI,"||",2),3)),"^",20)
	.q:labspec=""
	.;^DHCPEDataEx("Report","DHCPEIReport","LisAuditUser",ordItmId)
	.;s $p($g(^TEPI(episodeNo,1,labItemCode,1)),"\",3)
	.s LabItemCode=""
	.s LabItemCode=$O(^TEPI(labspec,1,LabItemCode))
	.q:LabItemCode=""
	.s AuditUser=$p($g(^TEPI(labspec,1,LabItemCode,1)),"\",6)
	.s ReportUser=$p($g(^TEPI(labspec,1,LabItemCode,1)),"\",3)
	.s ^DHCPEDataEx("Report","DHCPEIReport","LisAuditUser",OEORI)=AuditUser
	.&SQL(Update Sqluser.DHC_PE_Result set RLT_User_DR=:ReportUser where RLT_OEORI_DR=:OEORI)
	.w OEORI_"^"_SQLCODE,!
}

ClassMethod GetAdmInfo2(PreIADMID)
{
	//CT^MRI
	//w ##class(web.DHCPE.PreItemListEx).GetAdmInfo2(58909)
	//s WinType=##class(web.DHCPE.PrintIAdmInfo).GetWinSetType("")
	
	q:WinType'=1 ""
	s SendSTID="^13^14^"
	q:PreIADMID="" ""
	q:$L(PreIADMID,"||")>1 ""
	s IADM=$O(^DHCPEIADM(0,"CRMADM",PreIADMID,0))
	q:IADM="" ""
	s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	;s PatID=$P(^PAADM(PAADM),"^",1)
	;q PAADM_"^"_PatID
	b ;PAADM
	q:PAADM="" ""
	
	s OrderID=$O(^OEORD(0,"Adm",PAADM,0))
	b ;OrderID
	q:OrderID="" ""
	s OrderSub=0
	s Flag=0
	f  s OrderSub=$O(^OEORD(OrderID,"I",OrderSub)) q:(OrderSub="")||(Flag=1)  d
	.s ItemStat=$P(^OEORD(OrderID,"I",OrderSub,1),"^",13)
	.q:ItemStat'="1"
	.s ArcimID=$P(^OEORD(OrderID,"I",OrderSub,1),"^",2)
	.s STID=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
	.q:SendSTID'[("^"_STID_"^")
	.b ;SendSTID
	.q:"Y"=##class(web.DHCRisApplicationBill).IsSendAppBill(OrderID_"||"_OrderSub)
	.s Flag=1
	q:Flag=0 ""
	s PatID=$P(^PAADM(PAADM),"^",1)
	q PAADM_"^"_PatID
}

ClassMethod SetReCheckFlag(VIPLevel)
{
	;d ##class(web.DHCPE.Tools).SetReCheckFlag(2)
	s PIADM=58402
	f  s PIADM=$O(^DHCPEPreIADM(PIADM)) q:(PIADM="")  d
	.s Status=$P(^DHCPEPreIADM(PIADM),"^",8)
	.q:(Status="CANCELPE")
	.s OrdSetFlag=0
	.s sub=0
	.f  s sub=$O(^DHCPEPreIADM(PIADM,"ORDENT",sub)) q:sub=""  d
	..s Stat=$P(^DHCPEPreIADM(PIADM,"ORDENT",sub),"^",9)
	..q:Stat'="1"
	..s OrdSetFlag=1
	.q:OrdSetFlag="1"
	.s PreID=PIADM_"||"_sub
	.&sql(Update Sqluser.DHC_PE_PreIADM set PIADM_ReCheckFlag="Y" where PIADM_RowID=:PreID)
	.w SQLCODE,!
	q
	;d ##class(web.DHCPE.Tools).SetReCheckFlag(2)
	s VIPStr="^FSKPF0208T^FSKPF0086T^DCSK000309^DCSK000315^DXNK000100^DCSK000308^FSKPF0187T^"
	s PTStr="^FSKPF0208^FSKPF0086^DCSK000314^DXNK000045^DCSK000311^FSKPF0187^"
	s:VIPLevel=1 ItemStr=VIPStr
	s:VIPLevel=2 ItemStr=PTStr
	s PIADM=0
	f  s PIADM=$O(^DHCPEPreIADM(PIADM)) q:(PIADM="")||(PIADM>58402)  d
	.s Status=$P(^DHCPEPreIADM(PIADM),"^",8)
	.q:(Status="ARRIVED")||(Status="CANCELPE")
	.q:+##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",PIADM)'=VIPLevel
	.s sub=0
	.f  s sub=$O(^DHCPEPreIADM(PIADM,"ORDITEM",sub)) q:sub=""  d
	..s Sets=$P(^DHCPEPreIADM(PIADM,"ORDITEM",sub),"^",2)
	..q:Sets'=""
	..s ArcimID=$P(^DHCPEPreIADM(PIADM,"ORDITEM",sub),"^",1)
	..s ArcimCode=$P(^ARCIM(+ArcimID,1,1),"^",1)
	..q:ArcimCode'="0000001828"
	..s ItemSub=$I(^TempDHCPEItemInfo(PIADM,sub))
	..s RelateCode="0000001914" ;..GetArcimCodeRelate(ArcimCode,VIPLevel)
	..s PreID=PIADM_"||"_sub
	..s CrmOrder=$O(^DHCPECRMO(0,"CRMORI",PreID,0))
	..q:CrmOrder=""
	..s OEORI=$P(^DHCPECRMO(CrmOrder),"^",1)
	..s Stat=$p($G(^OEORD(+OEORI,"I",$P(OEORI,"||",2),1)),"^",13)
	..q:Stat'="1"
	..s Arc=$O(^ARCIM(0,"Code",RelateCode,0))
	..w:Arc="" "ArcNull:"_PreID,!
	..q:Arc=""
	..;w PreID_"^"_Arc,!
	..;q 
	..s NewID=Arc_"||1"
	..&SQL(Update Sqluser.DHC_PE_PreIOrdItem Set PIOI_ItmMast_DR=:NewID where PIOI_RowID=:PreID)
	..w:SQLCODE'=0 "PreOrd:"_PreID,!
	..q:SQLCODE'=0
	..&SQL(Update Sqluser.OE_OrdItem set OEORI_ItmMast_DR=:NewID where OEORI_RowId=:OEORI)
	..w:SQLCODE'=0 "OEORd:"_PreID,!
	..q:SQLCODE'=0
	..s ^TempDHCPEItemInfo(PIADM,sub,ItemSub)=ArcimCode_"^"_RelateCode
}

ClassMethod GetArcimCodeRelate(ArcimCode, VIPLevel)
{
	s VIPStr="FSKPF0208T^FSKPF0086T^DCSK000309^DCSK000315^DXNK000100^DCSK000308^FSKPF0187T"
	s PTStr="FSKPF0208^FSKPF0086^DCSK000310^DCSK000314^DXNK000045^DCSK000311^FSKPF0187"
	s Length=$L(VIPStr,"^")
	s ret=""
	i VIPLevel="1"
	{
		f i=1:1:Length
		{
			s OneCode=$P(VIPStr,"^",i)
			s:OneCode=ArcimCode ret=$P(PTStr,"^",i)
			q:OneCode=ArcimCode
		}
	}
	else
	{
		f i=1:1:Length
		{
			s OneCode=$P(PTStr,"^",i)
			s:OneCode=ArcimCode ret=$P(VIPStr,"^",i)
			q:OneCode=ArcimCode
		}
	}
	q ret
}

ClassMethod DeleteCXF()
{
	;d ##class(web.DHCPE.Tools).DeleteCXF()
	s PIADM=0
	f  s PIADM=$O(^DHCPEPreIADM(PIADM)) q:(PIADM="")||(PIADM>58402)  d
	.q:+##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",PIADM)'=2
	.s OrdSetFlag=0
	.s sub=0
	.f  s sub=$O(^DHCPEPreIADM(PIADM,"ORDENT",sub)) q:sub=""  d
	..s Stat=$P(^DHCPEPreIADM(PIADM,"ORDENT",sub),"^",9)
	..q:Stat'="1"
	..s OrdSetFlag=1
	.s sub=0
	.f  s sub=$O(^DHCPEPreIADM(PIADM,"ORDITEM",sub)) q:sub=""  d
	..s Sets=$P(^DHCPEPreIADM(PIADM,"ORDITEM",sub),"^",2)
	..q:Sets'=""
	..s ArcimID=$P(^DHCPEPreIADM(PIADM,"ORDITEM",sub),"^",16)
	..q:ArcimID'="1"
	..s ArcimID=$P(^DHCPEPreIADM(PIADM,"ORDITEM",sub),"^",1)
	..s ArcimDesc=$P(^ARCIM(+ArcimID,1,1),"^",2)
	..q:((ArcimDesc'["静脉采血")&&(ArcimDesc'["静脉抽血"))
	..
	..s ret=##class(web.DHCPE.PreItemList).IDeleteItem(52987,"PERSON",PIADM_"||"_sub,"")
	..w:ret'="" ret_"^"_PIADM_"||"_sub,!
}

ClassMethod UpdateAmt()
{
	;d ##class(web.DHCPE.Tools).UpdateAmt()
	
	&SQL(update sqluser.DHC_PE_PreIOrdEnt set PIOE_AccountAmount=5540 where pioe_OrderSets_dr=21609)
	&SQL(update DHC_PE_PreIOrdEntFee set PIOEF_FactAmount=5540 where PIOEF_ParRef->pioe_OrderSets_dr=21609)
	&SQL(update sqluser.DHC_PE_PreIOrdEnt set PIOE_AccountAmount=4940 where pioe_OrderSets_dr=21414)
	&SQL(update DHC_PE_PreIOrdEntFee set PIOEF_FactAmount=4940 where PIOEF_ParRef->pioe_OrderSets_dr=21414)
	s GIADM=0
	f  s GIADM=$O(^DHCPEPreGADM(GIADM)) q:GIADM=""  d
	.s SQLCODE=##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(GIADM)
	
	s PIADM=0
	f  s PIADM=$O(^DHCPEPreIADM(PIADM)) q:PIADM=""  d
	.;s gAdm=$p(^DHCPEPreIADM(PIADM),"^",2)
	.;i gAdm="" d
	.s SQLCODE=##class(web.DHCPE.PreIADM).UpdatePersonAuditAmount(PIADM)
	q
	
	
	s PIADM=0
	f  s PIADM=$O(^TempDHCPEItemInfo(PIADM)) q:PIADM=""  d
	.s Sub=0
	.f  s Sub=$O(^TempDHCPEItemInfo(PIADM,Sub)) q:Sub=""  d
	..s PreID=PIADM_"||"_Sub
	..s CrmOrder=$O(^DHCPECRMO(0,"CRMORI",PreID,0))
	..q:CrmOrder=""
	..s OEORI=$P(^DHCPECRMO(CrmOrder),"^",1)
	..s ItemSub=""
	..f  s ItemSub=$O(^TempDHCPEItemInfo(PIADM,Sub,ItemSub)) q:ItemSub=""  d
	...s ArcimID=$P(^DHCPEPreIADM(PIADM,"ORDITEM",Sub),"^",1)
	...s ArcimCode=$P(^ARCIM(+ArcimID,1,1),"^",1)
	...q:ArcimCode'="0000001914"
	...;s NewArcimID=$O(^ARCIM(0,"Code","FSKPF0086C",0))
	...;s NewID=NewArcimID_"||1"
	...;&SQL(Update Sqluser.DHC_PE_PreIOrdItem Set PIOI_ItmMast_DR=:NewID where PIOI_RowID=:PreID)
	...;w:SQLCODE'=0 "SQLCODE:"_SQLCODE,!
	...;&SQL(Update Sqluser.OE_OrdItem set OEORI_ItmMast_DR=:NewID where OEORI_RowId=:OEORI)
	...;w:SQLCODE'=0 "SQLCODE2:"_SQLCODE,!
	...;s $P(^TempDHCPEItemInfo(PIADM,Sub,ItemSub),"^",2)="FSKPF0086C"
	...;q
	...s AdmType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",PIADM_"||"_Sub))
	...s Price=+##class(web.UDHCJFPRICE).GetOrderPrice(AdmType,"",ArcimID,+$H,"","","","")
	...s $P(^DHCPEPreIADM(PIADM,"ORDITEM",Sub),"^",14)=Price
	...s FeeSub=$O(^DHCPEPreIADM(PIADM,"ORDITEM",Sub,"FEE",0))
	...s $P(^DHCPEPreIADM(PIADM,"ORDITEM",Sub,"FEE",FeeSub),"^",2)=Price
	...w Price_"^"_PIADM_"^"_$P(^DHCPEPreIADM(PIADM,"ORDITEM",Sub),"^",14)_"^"_$P(^DHCPEPreIADM(PIADM,"ORDITEM",Sub,"FEE",FeeSub),"^",2),!
	
	...s gAdm=$p(^DHCPEPreIADM(PIADM),"^",2)
	...i gAdm="" d
	....s SQLCODE=##class(web.DHCPE.PreIADM).UpdatePersonAuditAmount(PIADM)
	...e  d
	....s SQLCODE=##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(gAdm)
}

ClassMethod ReAmt()
{
	;d ##class(web.DHCPE.Tools).ReAmt()
	/*
	s ID=0
	f  s ID=$O(^DHCPEPreGADM(ID)) q:ID=""  d
	.w "G:"_ID,!
	.d ##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(ID)
	*/
	
	s AID=""
	f  s AID=$O(^DHCPEUpdateAuditRecord(AID)) q:AID=""  d
	.&sql(update sqluser.DHC_PE_PreAudit set PA_ChargedStatus="UNCHARGED" where PA_RowID=:AID)
	.w SQLCODE,!
	q
	s ID=0
	f  s ID=$O(^DHCPEPreIADM(ID)) q:(ID="")||(ID>58402)  d
	.s AID=""
	.f  s AID=$O(^DHCPEPreA(0,"CRMADM","I",ID,AID)) q:AID=""  d
	..s Status=$P(^DHCPEPreA(AID),"^",21)
	..q:Status="NU"
	..s Amt=$P(^DHCPEPreA(AID),"^",9)
	..q:+Amt=0
	..s Charged=$P(^DHCPEPreA(AID),"^",14)
	..q:Charged="CHARGED"
	..&sql(update sqluser.DHC_PE_PreAudit set PA_ChargedStatus="CHARGED" where PA_RowID=:AID)
	..w:SQLCODE'=0 "SQL:"_AID_"^"_SQLCODE
	..s ^DHCPEUpdateAuditRecord(AID)=""
}

ClassMethod UpdateLabData(ARCIM As %String)
{
 &SQL(Select rlt_result,rlt_normal into :result1,:normal1 from dhc_pe_result where rlt_oeori_dr=:ARCIM and rlt_od_dr='42||127')
 &SQL(Select rlt_result,rlt_normal into :result2,:normal2 from dhc_pe_result where rlt_oeori_dr=:ARCIM and rlt_od_dr='42||166')
 &SQL(Select rlt_result,rlt_normal into :result3,:normal3 from dhc_pe_result where rlt_oeori_dr=:ARCIM and rlt_od_dr='42||167')
 &SQL(Select rlt_result,rlt_normal into :result4,:normal4 from dhc_pe_result where rlt_oeori_dr=:ARCIM and rlt_od_dr='42||168')
 &SQL(Select rlt_result,rlt_normal into :result5,:normal5 from dhc_pe_result where rlt_oeori_dr=:ARCIM and rlt_od_dr='42||169')
 Set Labtrakcode1=$p(^DHCPEST("42","OD",127),"^",10)
 Set Labtrakcode2=$p(^DHCPEST("42","OD",166),"^",10)
 Set Labtrakcode3=$p(^DHCPEST("42","OD",167),"^",10)
 Set Labtrakcode4=$p(^DHCPEST("42","OD",168),"^",10)
 Set Labtrakcode5=$p(^DHCPEST("42","OD",169),"^",10)
 //Set a1=$p(^TTAB("TC",Labtrakcode1),"\",7)
 //If a1="Y" Do 
 If normal1=1 Set Ex1=^TTAB("TC",Labtrakcode1,2,0,1)
 If normal1=0 Set Ex1=^TTAB("TC",Labtrakcode1,2,1,1)

 If normal2=1 Set Ex2=^TTAB("TC",Labtrakcode2,2,0,1)
 If normal2=0 Set Ex2=^TTAB("TC",Labtrakcode2,2,1,1)
 If normal3=1 Set Ex3=^TTAB("TC",Labtrakcode3,2,0,1)
 If normal3=0 Set Ex3=^TTAB("TC",Labtrakcode3,2,1,1)
 If normal4=1 Set Ex4=^TTAB("TC",Labtrakcode4,2,0,1)
 If normal4=0 Set Ex4=^TTAB("TC",Labtrakcode4,2,1,1)
 If normal5=1 Set Ex5=^TTAB("TC",Labtrakcode5,2,0,1)
 If normal5=0 Set Ex5=^TTAB("TC",Labtrakcode5,2,1,1)

 Set ResultEx1=result1_"("_Ex1_")"

 Set ResultEx2=result2_"("_Ex2_")"
 Set ResultEx3=result3_"("_Ex3_")"
 Set ResultEx4=result4_"("_Ex4_")"
 Set ResultEx5=result5_"("_Ex5_")"
 if result1'["(" Do
 .&SQL(UPDATE dhc_pe_result set RLT_Result=:ResultEx1 where rlt_oeori_dr=:ARCIM and rlt_od_dr='42||127')
 if result2'["(" Do
 .&SQL(UPDATE dhc_pe_result set RLT_Result=:ResultEx2 where rlt_oeori_dr=:ARCIM and rlt_od_dr='42||166')
 if result3'["(" Do
 .&SQL(UPDATE dhc_pe_result set RLT_Result=:ResultEx3 where rlt_oeori_dr=:ARCIM and rlt_od_dr='42||167')
 if result4'["(" Do
 .&SQL(UPDATE dhc_pe_result set RLT_Result=:ResultEx4 where rlt_oeori_dr=:ARCIM and rlt_od_dr='42||168')
 if result5'["(" Do
 .&SQL(UPDATE dhc_pe_result set RLT_Result=:ResultEx5 where rlt_oeori_dr=:ARCIM and rlt_od_dr='42||169')
}

// d ##class(web.DHCPE.Tools).ExportRelate("/tmp/DHCPEIDRelate.txt")

ClassMethod ExportRelate(fileName)
{
	s f=##class(%File).%New(fileName)
	d f.Open("WSN")
	s ID=0
	f  s ID=$O(^DHCPEIDR(ID)) q:ID=""  d
	.s EDID=$P($G(^DHCPEIDR(ID)),"^",1)
	.s EDcode=$P($G(^DHCPEED(EDID,1)),"^",6)
	.s EDname=$P($G(^DHCPEED(EDID,1)),"^",1)
	.s JBID=$P($G(^DHCPEIDR(ID)),"^",2)
	.s JBcode=$P($G(^DHCPEILLS(JBID)),"^",1)
	.s JBname=$P($G(^DHCPEILLS(JBID)),"^",2)
	.s OneSt=EDcode_$c(9)_EDname_$c(9)_JBcode_$c(9)_JBname
 	.d f.WriteLine(OneSt)
 	d f.Close()
}

// d ##class(web.DHCPE.Tools).ExportJB("/tmp/DHCPEIllnessStandard.txt")

ClassMethod ExportJB(fileName)
{
	s f=##class(%File).%New(fileName)
	d f.Open("WSN")
	s ID=0
	f  s ID=$O(^DHCPEILLS(ID)) q:ID=""  d
	.s code=$P($G(^DHCPEILLS(ID)),"^",1)
	.s name=$P($G(^DHCPEILLS(ID)),"^",2)
	.s detail=$P($G(^DHCPEILLS(ID)),"^",3)
	.s Alias=..GetJBAlias(ID)
	.s OneSt=code_$c(9)_name_$c(9)_detail_$c(9)_Alias
 	.d f.WriteLine(OneSt)
 	d f.Close()
}

ClassMethod GetJBAlias(EDID)
{
	s sql="select ILLSA_Text from sqluser.DHC_PE_ILLSAlias where ILLSA_ILLS_DR="_EDID
	s rset = ##class(%ResultSet).%New()
	d rset.Prepare(sql)
 	d rset.Execute()
 	s Str=""
 	While (rset.Next(.sc)) 
 	{
 		If ($SYSTEM.Status.IsOK(sc)) 
 		{
	 		s OneStr=rset.GetData(1)
	 		if Str="" d
	 		.s Str=OneStr
	 		e  d
	 		.s Str=Str_","_OneStr
	 		
 		}
 		Else // if there was an error, break out of the While loop
 		{
	        s err="err"
 			q
 		}
 	}
 	q Str
}

// d ##class(web.DHCPE.Tools).ExportEX("/tmp/DHCPEExpertDiagnosis.txt")

ClassMethod ExportEX(fileName)
{
	s f=##class(%File).%New(fileName)
	d f.Open("WSN")
	s ID=0
	f  s ID=$O(^DHCPEED(ID)) q:ID=""  d
	.Quit:($g(^DHCPECTDataEx("BaseData","DHCPEExpertDiagnosis","Active",ID))="N")
	.s code=$P($G(^DHCPEED(ID,1)),"^",6)
	.s name=$P($G(^DHCPEED(ID,1)),"^",1)
	.s station=$P($G(^DHCPEED(ID,1)),"^",7)
	.i station'="" d
	..s station=$P($G(^DHCPEST(station)),"^",2)
	.s detail=$P($G(^DHCPEED(ID,"Detail")),"^",1)
	.s Alias=..GetEXAlias(ID)
	.s OneSt=code_$c(9)_name_$c(9)_detail_$c(9)_station_$c(9)_Alias
 	.d f.WriteLine(OneSt)
 	d f.Close()
}

ClassMethod GetEXAlias(EDID)
{
	s sql="select EDA_Text from sqluser.DHC_PE_EDAlias where EDA_ED_DR="_EDID
	s rset = ##class(%ResultSet).%New()
	d rset.Prepare(sql)
 	d rset.Execute()
 	s Str=""
 	While (rset.Next(.sc)) 
 	{
 		If ($SYSTEM.Status.IsOK(sc)) 
 		{
	 		s OneStr=rset.GetData(1)
	 		if Str="" d
	 		.s Str=OneStr
	 		e  d
	 		.s Str=Str_","_OneStr
	 		
 		}
 		Else // if there was an error, break out of the While loop
 		{
	        s err="err"
 			q
 		}
 	}
 	q Str
}

// d ##class(web.DHCPE.Tools).AddCardItems()

ClassMethod AddCardItems()
{
	d ..AddReadCardItem(52695) // DHCPEIReport
	//q  
	d ..AddReadCardItem(52698) // DHCPEPreIBaseInfo.Edit 
	//q
	d ..AddReadCardItem(52700) // DHCPEPreGBaseInfo.Edit 
	d ..AddReadCardItem(52704) // DHCPEPreIADM.Find 
	d ..AddReadCardItem(52707) // DHCPEPreGADM.Edit 
	d ..AddReadCardItem(52711) // DHCPEPreIADM.Team 
	d ..AddReadCardItem(52714) // DHCPEGCashier 
	d ..AddReadCardItem(52715) // DHCPEICashier 
	d ..AddReadCardItem(52718) // DHCPEIRegister 
	d ..AddReadCardItem(52760) // DHCPEDocPatientList 
	d ..AddReadCardItem(52761) // DHCPEIAdmItemStatusAdms 
	d ..AddReadCardItem(52821) // DHCPEDietManager 
	d ..AddReadCardItem(52834) // DHCPEGiftManager 
	d ..AddReadCardItem(52852) // DHCPEInvList 
	d ..AddReadCardItem(52859) // DHCPEAdvancePayment 
	d ..AddReadCardItem(52860) // DHCPEAdvancePayment.Find 
	d ..AddReadCardItem(52861) // DHCPEAPAC.Find 
	d ..AddReadCardItem(52863) // DHCPEAPSC.Find 
	d ..AddReadCardItem(52874) // DHCPEPreIADM.Edit
}

ClassMethod AddReadCardItem(ComponentID)
{
	s ParObj=##class(websys.Component).%OpenId(ComponentID)
	
	s ItemObj=##class(websys.ComponentItems).%New()
	s ItemObj.Name="CardTypeDefine"
	s ItemObj.Caption="卡类型"
	s ItemObj.DisplayType="L"
	d ParObj.Items.Insert(ItemObj)
	s ItemObj1=##class(websys.ComponentItems).%New()
	s ItemObj1.Name="getcardtypeclassbycardno"
	//s ItemObj1.Caption="getcardtypeclassbycardno"
	s ItemObj1.DisplayType="T"
	s ItemObj1.Hidden="1"
	s ItemObj1.ValueGet="s val=##Class(websys.Page).Encrypt($lb("_""""_"web.DHCBL.CARD.CardManager.getcardtypeinfoByCardNo"_""""_"))"
	d ParObj.Items.Insert(ItemObj1)
	s ItemObj2=##class(websys.ComponentItems).%New()
	s ItemObj2.Name="InitCardHardCommunation"
	//s ItemObj2.Caption="InitCardHardCommunation"
	s ItemObj2.DisplayType="S"
	s ItemObj2.Hidden="1"
	s ItemObj2.CustomExpression="d ##class(web.UDHCCardCommLinkRegister).GetCardHardJSFunction()"
	d ParObj.Items.Insert(ItemObj2)
	s ItemObj3=##class(websys.ComponentItems).%New()
	s ItemObj3.Name="ReadAccExpEncrypt"
	//s ItemObj3.Caption="InitCardHardCommunation"
	s ItemObj3.DisplayType="T"
	s ItemObj3.Hidden="1"
	s ItemObj3.ValueGet="s val=##Class(websys.Page).Encrypt($lb("_""""_"web.UDHCAccManageCLSIF.getaccinfofromcardno"_""""_"))"
	d ParObj.Items.Insert(ItemObj3)
	s ItemObj4=##class(websys.ComponentItems).%New()
	s ItemObj4.Name="ReadCardTypeEncrypt"
	//s ItemObj4.Caption="InitCardHardCommunation"
	s ItemObj4.DisplayType="T"
	s ItemObj4.Hidden="1"
	s ItemObj4.ValueGet="s val=##Class(websys.Page).Encrypt($lb("_""""_"web.UDHCOPOtherLB.ReadCardTypeDefineListBroker"_""""_"))"
	d ParObj.Items.Insert(ItemObj4)
	
	s ParObj.LastUpdateDate=+$H
	s ParObj.OtherScripts=ParObj.OtherScripts_",DHCWeb.COMMHardManager.JS,dhtmlXCommon.js,dhtmlXCombo.js,DHCWeb.OPOEData.js,DHCWeb.OPCommon.JS"
	s mysc=ParObj.%Save()
	If $$$ISERR(mysc)
	{
		Do $System.Status.DisplayError(mysc)
	}
	
	q $$$OK
}

ClassMethod ExportExpress()
{
	;d ##class(web.DHCPE.Tools).ExportExpress()
	s f=##class(%File).%New("/tmp/dhcpe/ExpressData.txt")
	d f.Open("WSN")
	s SourceID=""
	f  s SourceID=$O(^User.DHCPEExpressI("SourceIDIndex","ED",SourceID))  q:SourceID=""  d
	.s EDDesc=$P(^DHCPEED(SourceID,1),"^",1)
	.s ID=""
	.f  s ID=$O(^User.DHCPEExpressI("SourceIDIndex","ED",SourceID,ID))  q:ID=""  d
	..s ItemID=$LG(^User.DHCPEExpressD(ID),5)
	..q:+ItemID'=7
	..s Desc=$P(^DHCPEST(+ItemID,"OD",$P(ItemID,"||",2)),"^",1)
	..s DescIndex=$$ALPHAUP^SSUTIL4(Desc)
	..s ItemSub=0
	..f  s ItemSub=$O(^DHCPEST(0,"OD_Desc",DescIndex,7,ItemSub)) q:ItemSub=""  d
	...s RowID="7||"_ItemSub
	...s UseFlag="N"
	...s:RowID=ItemID UseFlag="Y"
	...s Code=$P(^DHCPEST(+ItemID,"OD",ItemSub),"^",11)
	...s Desc=$P(^DHCPEST(+ItemID,"OD",ItemSub),"^",1)
	...s OneInfo=EDDesc_$C(9)_RowID_$C(9)_Code_$C(9)_Desc_$C(9)_UseFlag
	...d f.WriteLine(OneInfo)
	d f.Close()
	q
}

}
