Class web.UDHCOEORDOP1 Extends %RegisteredObject
{

/// Creator: ZhYW
/// CreatDate: 2019-10-12
/// Description: 获取成组医嘱的组符号
/// Input: OEItmRowID: OE_OrdItem.RowId
/// Return: 
/// Debug: w ##class(web.UDHCOEORDOP1).ReadOEGrpFlag("3873||3")
ClassMethod ReadOEGrpFlag(OEItmRowID As %String) As %String
{
	set myMainRowID=""
	
	//是否存在组医嘱
	set myOEORIDR=0
	while(($o(^OEORDi(0,"OEORI",+OEItmRowID,myOEORIDR))'="")&&(myMainRowID="")) {
		set myOEORIDR=$o(^OEORDi(0,"OEORI",+OEItmRowID,myOEORIDR))
		set:(OEItmRowID=myOEORIDR) myMainRowID=myOEORIDR			//如果是主医嘱，标志为成组医嘱
		set myGrpSub=0
		while(($o(^OEORDi(0,"OEORI",+OEItmRowID,myOEORIDR,myGrpSub))'="")&&(myMainRowID="")) {
			set myGrpSub=$o(^OEORDi(0,"OEORI",+OEItmRowID,myOEORIDR,myGrpSub))
			set:(OEItmRowID=(+OEItmRowID_"||"_myGrpSub)) myMainRowID=myOEORIDR
		}
	}
	
	set myGrpSign=""
	if (myMainRowID'="") {
		//传入医嘱是主医嘱时显示"┓"
		if (OEItmRowID=myMainRowID) {
			set myGrpSign="┓"
		}else {
			//传入医嘱是最后一条子医嘱时显示"┛"，否则显示"┃"
			set myGrpSign=$s((($o(^OEORDi(0,"OEORI",+OEItmRowID,myMainRowID,""),-1))=$p(OEItmRowID,"||",2)):"┛", 1:"┃")
		}
	}
	
	quit myGrpSign_"^"_myMainRowID
}

/// Description: 根据RowID查询发票的医嘱项目
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCOEORDOP1","ReadOEByINVRowID","195464","PRT")
Query ReadOEByINVRowID(invRowId As %String, invType As %String, langId As %String = "") As websys.Query(ROWSPEC = "TOrder:%String:医嘱名称,TOrderSum:%Float:金额,TOrderQty:%String:数量,TPackUOM:%String:单位,TRecloc:%String:接收科室,TOrderRowid:%String:医嘱ID,TStatDesc:%String:医嘱状态,TCareProDesc:%String:开单医生,TAdmDoc:%String:就诊医生,TDiscSum:%Float:折扣金额,TPayorSum:%Float:记账金额,TOEORIStDate:%String:医嘱开始日期,TOEORIStTime:%String:医嘱开始时间,TOEORILabNo:%String:处方/标本号,TCoverMainIns:%String:是否医保")
{
}

ClassMethod ReadOEByINVRowIDExecute(ByRef qHandle As %Binary, invRowId As %String, invType As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	if (+invRowId=0) quit $$$OK
	
	
	if (invType="API") {
		set myACPRowID=0
		while($o(^DHCINVPRTCAPi(0,"APINVDR",invRowId,myACPRowID))) {
			set myACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",invRowId,myACPRowID))
			set myINVRowID=$p($g(^DHCINVPRTCAP(myACPRowID)),"^",1)
			continue:(myINVRowID="")
			do BillConInv
		}
		quit $$$OK
	}
	
	if (invType="PE") {
		set PB=$p($g(^DHCPEINVPRT(invRowId)),"^",3)
		if (+PB=0) quit $$$OK
		do GetOutput
		quit $$$OK
	}
	
	if (invType="PRT") {
		set myINVRowID=invRowId
		do BillConInv
		quit $$$OK
	}
	
	quit $$$OK
	
BillConInv
	set BillConInv=0
	while($o(^DHCBCI(0,"INV",myINVRowID,BillConInv))) {
		set BillConInv=$o(^DHCBCI(0,"INV",myINVRowID,BillConInv))
		set PB=$p($g(^DHCBCI(BillConInv)),"^",2)
		do GetOutput
	}
	quit
GetOutput
	set PBO=0
	while($o(^DHCPB(PB,"O",PBO))) {
		set PBO=$o(^DHCPB(PB,"O",PBO))
		set PBOData=$g(^DHCPB(PB,"O",PBO))
		continue:(PBOData="")
		set Arcim=$p(PBOData,"^",3)
		set ArcimDesc=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",2)   //名称
		set ArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", ArcimDesc, langId)
		set OEORI=$p(PBOData,"^",4)
		set IsAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(OEORI)
		if (IsAppRep="Y") {
			set PartDesc=##class(web.DHCAPPInterface).GetExaReqPartDesc(OEORI)
			set ArcimDesc=ArcimDesc_PartDesc            //名称 + 部位
		}
		set StatDR=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",13)
		set StatDesc=$s((+StatDR'=0):$p($g(^OEC("OSTAT",StatDR)),"^",2),1:"")
		set StatDesc=##class(User.OECOrderStatus).GetTranByDesc("OSTATDesc", StatDesc, langId)
		set OEORIStDate=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",9)
		set OEORIStDate=##class(websys.Conversions).DateLogicalToHtml(OEORIStDate)
		set OEORIStTime=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",10)
		set OEORIStTime=##class(websys.Conversions).TimeLogicalToHtml(OEORIStTime)
		set OEORIPresNo=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",14)
		set OrderType=##class(web.UDHCJFBaseCommon).GetOrdCateType(Arcim, 0)
		if (OrderType="L") {
			set OEORILabNo=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),3),"^",20)
		}else {
			set OEORILabNo=OEORIPresNo
		}
		set Adm=$p(^OEORD(+OEORI),"^",1)
		set AdmDepDR=$p(^PAADM(Adm),"^",4)
		set AdmDocDR=$p(^PAADM(Adm),"^",9)
		set AdmDoc=$s((+AdmDocDR'=0):$p($g(^CTPCP(AdmDocDR,1)),"^",2),1:"")
		set AdmDoc=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc", AdmDoc, langId)
		set UserAddDR=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),7)),"^",1)    //开医嘱医生
		set CareProDesc=$s((+UserAddDR'=0):$p($g(^SSU("SSUSR",UserAddDR)),"^",2),1:"")
		set CareProDesc=##class(User.SSUser).GetTranByDesc("SSUSRName", CareProDesc, langId)
		set OrdPrice=$p(PBOData,"^",7)	            //PBO_UnitPrice
		set OrdRefQty=+$p(PBOData,"^",6)		    //PBO_RefundQty
		set OrdBillQty=$p(PBOData,"^",5)		    //PBO_BillQty
		set ConFac=##class(web.DHCBillCommon).GetUomConvFactor(Arcim, OEORI)
		set BillQty=(OrdBillQty+OrdRefQty)/ConFac
		set BillQty=$fn(BillQty,"N")
		set PackUOM=##class(web.DHCBillCommon).GetPackUom(Arcim, OEORI)
		set PackUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc", PackUOM, langId)
		set DiscSum=$p(PBOData,"^",9)
		set DiscSum=$fn(DiscSum,"",2)
		set PayorSum=$p(PBOData,"^",10)
		set PayorSum=$fn(PayorSum,"",2)
		set PatSum=$p(PBOData,"^",11)
		set PatSum=$fn(PatSum,"",2)
		set ReclocDR=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),3)),"^",6)   //接收科室
		set Recloc=$s((+ReclocDR'=0):$p($g(^CTLOC(ReclocDR)),"^",2),1:"")
		set Recloc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", Recloc, langId)
		set CoverMainIns=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),3),"^",3)    //OEORI_CoverMainIns
		do OutputOEItmList
	}
	
	quit
	
OutputOEItmList
	set Data=$lb(ArcimDesc,PatSum,BillQty,PackUOM,Recloc,OEORI,StatDesc,CareProDesc,AdmDoc,DiscSum,PayorSum,OEORIStDate,OEORIStTime,OEORILabNo,CoverMainIns)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// Debug: w ##class(web.UDHCOEORDOP1).ReadOECPriorityFlag("29||1")
ClassMethod ReadOECPriorityFlag(OEORIDR As %String) As %String
{
	set myPRFlag=0
	
	quit:(OEORIDR="") myPRFlag
	
	set myPriorDR=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),1)),"^",8)
	quit:(myPriorDR="") myPRFlag
	set myPriorCode=$p($g(^OECPR(myPriorDR)),"^",1)
	if (myPriorCode["OM") {
		set myPRFlag=1
	}
	
	quit myPRFlag
}

/// Description: 规则：成组医嘱中有一条皮试医嘱就不收费
/// Debug: w ##class(web.UDHCOEORDOP1).ReadSkinRtnFlag("48995||31")
ClassMethod ReadSkinRtnFlag(OEItmRowID As %String) As %String
{
	set mySkinOERowID=""			;皮试医嘱的rowID
	set myGrpFlag="N"				;表示本医嘱在此组标志
	set myOEORIDR=0
	for  set myOEORIDR=$o(^OEORDi(0,"OEORI",+OEItmRowID,myOEORIDR)) quit:((myOEORIDR="")||(myGrpFlag="Y"))  do
	.set mySkinOERowID=""			;皮试医嘱的rowID
	.set myGrpFlag="N"			;表示本医嘱在此组标志
	.set:(OEItmRowID=myOEORIDR) myGrpFlag="Y"			;如果是主医嘱，标志为成组医嘱
	.set myGrpSkinTest=$p($g(^OEORD(+myOEORIDR,"I",$p(myOEORIDR,"||",2),5)),"^",2)		;皮试标志
	.set:(myGrpSkinTest="Y") mySkinOERowID=myOEORIDR
	.set myGrpSub=0
	.for  set myGrpSub=$o(^OEORDi(0,"OEORI",+OEItmRowID,myOEORIDR,myGrpSub)) quit:(myGrpSub="")  do
	..set:(myGrpSkinTest'="Y") myGrpSkinTest=$p($g(^OEORD(+OEItmRowID,"I",myGrpSub,5)),"^",2)
	..set:(OEItmRowID=(+OEItmRowID_"||"_myGrpSub)) myGrpFlag="Y"
	..quit:(myGrpSkinTest'="Y")
	..quit:(mySkinOERowID'="")
	..set mySkinOERowID=+OEItmRowID_"||"_myGrpSub
	
	set:(myGrpFlag="N") mySkinOERowID=""
	set:(mySkinOERowID="") mySkinOERowID=OEItmRowID
	
	set myFlag=""
	set OrderRowid=+mySkinOERowID
	set itemsub=$p(mySkinOERowID,"||",2)
	set mySkinTest=$p($g(^OEORD(OrderRowid,"I",itemsub,5)),"^",2)
	
	quit:(mySkinTest'="Y") ""   //非皮试医嘱退出
	
	set mySkinRtn=$p($g(^OEORD(OrderRowid,"I",itemsub,11)),"^",3)
	quit:(mySkinRtn="N") ""
	
	set myFlag="Y"
	
	quit myFlag
}

/// Creator: ZhYW
/// CreatDate: 2018-10-16
/// Description: 判断是否发药
/// Input: oeitm:医嘱RowID
/// Return: rtn(0:未发，1:已发)
/// Debug: w ##class(web.UDHCOEORDOP1).CheckPhDispRet("15||4")
ClassMethod CheckPhDispRet(oeitm As %String) As %String
{
	set rtn=0
	
	set dsp=0
	while($o(^DHCOEDISQTY(0,"OEORI",oeitm,dsp))&&(rtn=0)) {
		set dsp=$o(^DHCOEDISQTY(0,"OEORI",oeitm,dsp))
		set disp=$g(^DHCOEDISQTY(dsp))
		set dspStatus=$p(disp,"^",7)
		set rtn=(dspStatus="C")
	}
	
	quit rtn
}

}
