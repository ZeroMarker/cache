Class web.UDHCPRTOEAuth1 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 96;

/// /合肥专用
/// /按照配置判断票据是否被审批
/// 读取票据级别的是否需要审批
ClassMethod ReadINVAuthFlag(PRTRowID As %String, GLocDR As %String, ULocDR As %String) As %String
{
	n (PRTRowID, GLocDR, ULocDR)
	
	;w ##class(web.UDHCPRTOEAuth1).ReadINVAuthFlag(3824)
	
	;s ^TMPDDDDDDD=PRTRowID
	;return 审批标志^
	;Y   审批
	;N   未审批
	
	;医嘱的混合状态；
	;药物医嘱
	;非药物医嘱
	
	;默认审批不受限医嘱标志,受限是按照接收科室来受限的
	s myAuditLimit="N"
	
	s myRecLocStr=""
	i (GLocDR'="")&(ULocDR'="") d
	.;如果有配置表示为受限
	.s myAuditLimit="Y"
	.s myRecLocStr=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(GLocDR,ULocDR)
	
	s Verifyflag=$p($g(^DHCINVPRT(PRTRowID)),"^",22)			;审批标志
	;判断是否需要审批  医院基本配置表中   
	;myConAppFlag=1    不需要审批
	;myConAppFlag=0    需要审批，默认的值
	;myConAppFlag=2		需要审批到医嘱  需要在审批时，判断
	s myConAppFlag=$p($g(^DHCSOPFCON(1)),"^",14)			;OPFC_AppFlag
	i +myConAppFlag=1 d
	.s Verifyflag="Y"
	
	;需要医嘱的审批,DHC_INVPRT 审批，同时：有医嘱项被审批
	i +myConAppFlag=2 d
	.;^DHCINVPRT({DHC_INVPRT.PRT_Rowid},"OA",{IOA_Sub})
	.s mySub=0
	.s mySub=$o(^DHCINVPRT(PRTRowID,"OA",mySub))
	.i +mySub'=0  d
	..s Verifyflag="Y"
	
	;对于合肥医院,如果医嘱中包含药物医嘱，隐含为被审批,默认
	;如果是含有药物医嘱，DHC_INVPRT属于审批的支付票据
	;对于包含药物和非药物医嘱的，在明细中包含那个被审批
	s myOETypeDrug=0
	s myOETypeItem=0

	;!(Verifyflag="Y")
	s conRowid=0 f  s conRowid=$o(^DHCBCI(0,"INV",PRTRowID,conRowid)) q:(conRowid="")  d
	.s bill=$p($g(^DHCBCI(conRowid)),"^",2)
	.s selflag=1
	.s confac=""
	.s PBOChildsub=0  
	.f  s PBOChildsub=$o(^DHCPB(bill,"O",PBOChildsub)) q:(PBOChildsub="")  d
	..s Arcim=$p(^DHCPB(bill,"O",PBOChildsub),"^",3) ;DHC_PatBillOrder->PBO_ARCIM_DR
	..s myOEORI=$p(^DHCPB(bill,"O",PBOChildsub),"^",4) ;DHC_PatBillOrder->PBO_OEORI_DR
	..s ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
	..s ARCOrdType=$p(^ARC("IC",ARCCATRowid),"^",7)
	..i ARCOrdType="R"  d
	...s Verifyflag="Y"
	...s myOETypeDrug=1
	..;判断是否混合医嘱
	..i ARCOrdType'="R"  d
	...s myOETypeItem=1
	..s recdepcode=$p($g(^OEORD(+myOEORI,"I",+$p(myOEORI,"||",2),3)),"^",6) ;接收科室
	..q:((myRecLocStr'="")&(myRecLocStr'[("^"_recdepcode_"^")))
	..s myAuditLimit="N"
	
	;判断是否混合医嘱
	s myOETypeDI=""
	i (myOETypeDrug=1)&(myOETypeItem=1) d
	.s myOETypeDI="M"
	
	if Verifyflag="" d
	.s Verifyflag="N"
	
	s myrtn=Verifyflag_"^"_myOETypeDI_"^"_myAuditLimit_"^"
	
	q myrtn
}

ClassMethod InsertAuthInfo(PRTRowID As %String, UserDR As %String, OEAuthInfo As %String) As %String
{
	n (PRTRowID, UserDR, OEAuthInfo)
	s myrtn=0
	
	s mylen=$l(OEAuthInfo,$c(2))
	
	f i=1:1:mylen  q:(myrtn'=0)  d
	.s myOEInfo=$p(OEAuthInfo,$c(2),i)
	.q:(myOEInfo="")
	.s myAuthLen=$l(myOEInfo,"^")
	.k PLIST
	.s PLIST(0)=PRTRowID
	.f j=3:1:myAuthLen d
	..s PLIST(j-1)=$p(myOEInfo,"^",j)
	.k PLIST(1)
	.k PLIST(2)
	.s PLIST(5)=+$h
	.s PLIST(6)=$p($h,",",2)
	.s myrtn=##class(web.UDHCINVOEItemAuthorize).INSERT()
	.q:(+myrtn)
	.
	
	
	q myrtn
}

/// 按照安全组配置,查询DHC_INVPRT是否能够被查询到
ClassMethod ReadINVLimit(PRTRowID As %String, GLocDR As %String, ULocDR As %String) As %String
{
	n (PRTRowID, GLocDR, ULocDR)
	s myrtn=""
}

ClassMethod ReadOEORDAuthFlag(PRTRowID As %String, OEORDDR As %String = "", ExpStr As %String) As %String
{
	;对每条医嘱的审批标志
	n (PRTRowID, OEORDDR, ExpStr)
	s myrtn=""
	s Verifyflag="N"
	
	;myConAppFlag=1    不需要审批
	;myConAppFlag=0    需要审批，默认的值
	;myConAppFlag=2		需要审批到医嘱  需要在审批时，判断
	s myConAppFlag=$p($g(^DHCSOPFCON(1)),"^",14)			;OPFC_AppFlag
	i +myConAppFlag=1 d
	.s Verifyflag="Y"
	
	s myAuditCheckDis="N"
	
	;药物医嘱，自动变为审批标志Y
	;非药物医嘱，需要找审批项目
	q:(OEORDDR="") Verifyflag_"^^^^"
	
	s myPhRet=0
	
	;^OEORD({OE_Order.OEORD_RowId},"I",{OEORI_Childsub})
	;$p(^OEORD(+OEORDDR,"I",$p(OEORDDR,"||",2),1),"^",2)
	s Arcim=$p(^OEORD(+OEORDDR,"I",$p(OEORDDR,"||",2),1),"^",2)		;OE
	s ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
	s ARCOrdType=$p(^ARC("IC",ARCCATRowid),"^",7)
	i ARCOrdType="R"  d
	.s myPhRet=##class(web.udhcOPRefund).CheckPhDispRet(OEORDDR)
	.s Verifyflag="Y"
	e  d
	.s mySub=0
	.;
	.f  s mySub=$o(^DHCINVPRT(PRTRowID,"OA",mySub))  q:((mySub="")!(Verifyflag="Y"))  d
	..s myOEORIDR=$p(^DHCINVPRT(PRTRowID,"OA",mySub),"^",1)
	..i (OEORDDR=myOEORIDR) d
	...s Verifyflag="Y"
	
	s AuditSelFlag=0				;默认=0  不选中
	if ((Verifyflag="Y")&(ARCOrdType'="R")) d
	.s AuditSelFlag=1			;被审批的一定要选中
	
	if ((Verifyflag="Y")&(ARCOrdType="R")&(+myPhRet'=1)) d
	.s AuditSelFlag=0			;被审批的一定要选中
	
	s myAuditCheckDis="Y"			;使界面的Check  disable
	
	;药物医嘱,收费后没有发药，设置myAuditCheckDis="N"
	i ((ARCOrdType="R")&(+myPhRet'=1)) d
	.s myAuditCheckDis="N"

	;审批到发票，而不控制医嘱项
	i +myConAppFlag=0 d
	.s myAuditCheckDis="N"
	
	s myrtn=Verifyflag_"^"_myAuditCheckDis_"^"_AuditSelFlag
	
	q myrtn
}

ClassMethod SaveAuthInfo(PRTRowID As %String, UserDR As %String, OEORDStr As %String, OEAuthInfo As %String, RefAuditLocDR As %String, RefundReason As %String, ExpStr As %String) As %String
{
	n (PRTRowID, UserDR, OEORDStr, OEAuthInfo, RefAuditLocDR, RefundReason, ExpStr)
	;(PRTRowID,  UserDR, OEORDStr, OEAuthInfo, RefAuditLocDR, RefundReason, ExpStr)
	
	s myrtn=0
	
	s myrtn=##class(web.UDHCPRTOEAuth1).InsertAuthInfo(PRTRowID, UserDR, OEAuthInfo)
	b	;;;InsertAuthInfo
	i (+myrtn=0) d
	.s myrtn=##class(web.UDHCPRTOEAuth1).UpdateOEItmFAuth(OEORDStr, UserDR, RefAuditLocDR, RefundReason)
	b	;;;UpdateOEItmFAuth
	q myrtn
}

/// 更新医嘱表的审批
ClassMethod UpdateOEItmFAuth(OEORDStr As %String, UserDR As %String, RefAuditLocDR As %String, RefundReason As %String) As %String
{
	n (OEORDStr, UserDR, RefAuditLocDR, RefundReason)
	
	s myrtn=0
	s mylen=$l(OEORDStr,"^")
	
	f i=1:1:mylen  q:(+myrtn'=0)  d
	.s myOEORI=$p(OEORDStr,"^",i)
	.q:(myOEORI="")
	.;^DHCORDItem(0,{DHCORI_OEORI_Dr},{DHCORI_RowId})
	.s myExpOERowID=$o(^DHCORDItem(0,myOEORI,0))
	.b	;;;
	.i (myExpOERowID'="") d
	..k PLIST
	..s myrtn=##class(web.UDHCOEOrdItem).SELECT(myExpOERowID)
	..q:(+myrtn'=0)
	..s PLIST(6)="A"
	..s PLIST(7)=UserDR
	..s PLIST(8)=+$h
	..s PLIST(9)=$p($h,",",2)
	..s PLIST(10)=RefundReason			;DHCORI_RefundReason
	..i RefAuditLocDR'="" d
	...s PLIST(11)=RefAuditLocDR		;DHCORI_RefAuditLoc_DR
	..s myrtn=##class(web.UDHCOEOrdItem).UPDATE(myExpOERowID)
	..q:(+myrtn'=0)
	.e  d
	..;Insert Table
	..k PLIST
	..s PLIST(2)=myOEORI
	..s PLIST(6)="A"
	..s PLIST(7)=UserDR
	..s PLIST(8)=+$h
	..s PLIST(9)=$p($h,",",2)
	..s PLIST(10)=RefundReason			;DHCORI_RefundReason
	..i RefAuditLocDR'="" d
	...s PLIST(11)=RefAuditLocDR		;DHCORI_RefAuditLoc_DR
	..b		;INsert
	..s myrtn=##class(web.UDHCOEOrdItem).INSERT()
	..q:(+myrtn'=0)
	.
	
	b		;UDHCOEOrdItem
	q myrtn
}

ClassMethod CancleOEAuthInfo(PRTRowID As %String, UserDR As %String, OEORDStr As %String) As %String
{
	n (PRTRowID, UserDR, OEORDStr)
	;取消审批功能
	;增加判断只有正常的医嘱才能取消退费审批
	s myrtn=0
	
	q:(PRTRowID="")
	
	s myPRTFlag=$p($g(^DHCINVPRT(PRTRowID)),"^",8)
	q:(myPRTFlag'="A") 2600
	q:(myPRTFlag'="S") 2601
	
	d ..tb()
	
	;删除审批子表
	;^DHCINVPRT({DHC_INVPRT.PRT_Rowid},"OA",{IOA_Sub})
	s myOASub=0
	f  s myOASub=$o(^DHCINVPRT(PRTRowID,"OA",myOASub)) q:((myOASub="")!(+myrtn'=0))  d
	.s myrtn=##class(web.UDHCINVOEItemAuthorize).DELETE(PRTRowID_"||"_myOASub)
	.
	
	;取消审批医嘱项
	i (+myrtn=0) d
	.s mylen=$l(OEORDStr,"^")
	.f i=1:1:mylen  q:(+myrtn'=0)  d
	..s myOEORI=$p(OEORDStr,"^",i)
	..q:(myOEORI="")
	..;^DHCORDItem(0,{DHCORI_OEORI_Dr},{DHCORI_RowId})
	..s myExpOERowID=$o(^DHCORDItem(0,myOEORI,0))
	..b	;;;
	..i (myExpOERowID'="") d
	...k PLIST
	...s myrtn=##class(web.UDHCOEOrdItem).SELECT(myExpOERowID)
	...q:(+myrtn'=0)
	...s PLIST(6)="C"
	...s PLIST(7)=""
	...s PLIST(8)=""
	...s PLIST(9)=""
	...s PLIST(10)=""
	...;i RefAuditLocDR'="" d
	...s PLIST(11)=""		;DHCORI_RefAuditLoc_DR
	...s myrtn=##class(web.UDHCOEOrdItem).UPDATE(myExpOERowID)
	...q:(+myrtn'=0)
	
	;取消发票审批
	i (+myrtn=0) d
	.s myExpStr=""
	.s myrtn=##class(web.UDHCINVPRT).CancleINVAudit(PRTRowID,myExpStr)
	
	b		;;;
	
	i (+myrtn=0) d
	.d ..tc()
	e  d
	.trollback
	
	q myrtn
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
 n SQLCODE
	TCOMMIT  s SQLCODE=$zu(34)
	q
}

}
