Import SQLUser

Include Nur.DateFormat

/// 程序名DHCNurConOrd,护士会诊医嘱查询与执行
Class web.DHCNurConsultation Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 107;

Query GetConOder(EpisodeID As %String, PatRegNo As %String, StartDate As %String, EndDate As %String, LocId As %String, ExecFlage As %String, PatLocId As %String, OrdCatId As %String, ArcimId As %String) As %Query(ROWSPEC = "RegNo:%String,PatName:%String,BedCode:%String,ArcimDesc:%String,OeordId:%String,OrdStatDesc:%String,OrcatDesc:%String,ExecDateTime:%String,ExecCtcpDesc:%String,CtcpDesc:%String,RecLocDesc:%String,OrdDateTime:%String,AdmDep:%String,notes:%String,OrdUnitCost:%String,OrdQty:%String,OrdCost:%String")
{
}

ClassMethod GetConOderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConOderExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetConOderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConOderExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetConOderExecute(ByRef qHandle As %Binary, EpisodeID As %String, PatRegNo As %String, StartDate As %String, EndDate As %String, LocId As %String, ExecFlage As %String = 0, PatLocId As %String = "", OrdCatId As %String = "", ArcimId As %String = "") As %Status
{
   //##class(%ResultSet).RunQuery("web.DHCNurConsultation","GetConOder","","0000000070",63605,64336,83,1,"","","")
   ;s ^sctmpv1("GetConOder") =  EpisodeID_","_ PatRegNo _","_StartDate_","_EndDate _","_LocId _","_ ExecFlage _","_PatLocId_","_OrdCatId _","_ArcimId 
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i LocId="" s LocId=%session.Data("LOGON.CTLOCID")
 	s userId= "687" ;%session.Data("LOGON.USERID")
 	SEt ^Wanghc("conorder")=EpisodeID_","_PatRegNo_","_StartDate_","_EndDate_","_LocId_","_ ExecFlage_","_ PatLocId_","_ OrdCatId_","_ ArcimId 
 	k ^TmpNurOrderPrint(userId)
 	i LocId=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	i StartDate=""  s StartDate=+$H
 	i EndDate=""    s EndDate=+$H
 	i ExecFlage="" s ExecFlage=0
 	i StartDate>EndDate   Set qHandle=$lb(0,repid,0) Quit $$$OK
 	i EpisodeID'="" s PatRegNo=##Class(web.DHCCLCom).GetRegNobyEpisodeID(EpisodeID)
 	i PatRegNo'="" d
 	.s papmiId=""
 	.s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatRegNo),""))
 	.q:papmiId=""
 	.s admId="" f  s admId=$o(^PAPERdr(papmiId,"ADM","I",admId),-1) q:(admId="")  d
 	..s pavisit=$p($g(^PAADM(admId)),"^",20)
 	..q:pavisit'="A"
 	..s admType=$p($G(^PAADM(admId)),"^",2)
 	..q:admType'="I"
 	..s ctlocId=$p(^PAADM(admId),"^",4)
 	..q:(PatLocId'="")&(PatLocId'=ctlocId)
 	..s OrderId=$O(^OEORD(0,"Adm",admId,""))
 	..q:OrderId=""
 	..s OrderSub=0
 	..f  s OrderSub=$O(^OEORD(OrderId,"I",OrderSub)) q:OrderSub=""  d
 	...s recLocId=$P($G(^OEORD(OrderId,"I",OrderSub,3)),"^",6)
	...q:(LocId'="")&(recLocId'=LocId)
	...s arcItemRowId=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",2)
	...q:(ArcimId'="")&&(ArcimId'=arcItemRowId)
	...s arcCatRowId=$P($G(^ARCIM(+arcItemRowId,$P(arcItemRowId,"||",2),1)),"^",10)
	...q:(OrdCatId'="")&&(OrdCatId'=arcCatRowId)
	...s flage=..GetFlage(OrderId,OrderSub,ExecFlage)
	...q:flage=0
	...d GetOrderConSingle(OrderId,OrderSub)
	...q:(OrdDate1'="")&&(OrdDate1<StartDate)
	...q:(OrdDate1'="")&&(OrdDate1>EndDate)
	...d OutputRow
 	e  d
	.f OrdDate=StartDate:1:EndDate d
	..s OrdTime=""
	..f  s OrdTime=$O(^OEORDi(0,"LocStDtTm",LocId,OrdDate,OrdTime)) q:OrdTime=""  d
	...s OrderId=0
	...f  s OrderId=$O(^OEORDi(0,"LocStDtTm",LocId,OrdDate,OrdTime,OrderId)) q:OrderId=""  d
	....s OrderSub=0
	....s admId=$P($G(^OEORD(OrderId)),"^",1)
	....q:admId=""
 	....s admType=$p($G(^PAADM(admId)),"^",2)
 	....q:admType'="I"
 	....s ctlocId=$p(^PAADM(admId),"^",4)
 	....q:(PatLocId'="")&(PatLocId'=ctlocId)
	....f  s OrderSub=$O(^OEORDi(0,"LocStDtTm",LocId,OrdDate,OrdTime,OrderId,OrderSub)) q:OrderSub=""  d
	.....s arcItemRowId=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",2)
	.....q:(ArcimId'="")&&(ArcimId'=arcItemRowId)
	.....s arcCatRowId=$P($G(^ARCIM(+arcItemRowId,$P(arcItemRowId,"||",2),1)),"^",10)
	.....q:(OrdCatId'="")&&(OrdCatId'=arcCatRowId)
	.....s flage=..GetFlage(OrderId,OrderSub,ExecFlage)
	.....q:flage=0
	.....d GetOrderConSingle(OrderId,OrderSub)
	.....d OutputRow

 	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow
	s ^TmpNurOrderPrint(userId,ind)=RegNo_"^"_PatName_"^"_BedCode_"^"_ArcimDesc_"^"_OeordId_"^"_OrdStatDesc_"^"_OrcatDesc_"^"_ExecDateTime_"^"_ExecCtcpDesc_"^"_CtcpDesc_"^"_RecLocDesc_"^"_OrdDateTime_"^"_AdmDep_"^"_notes_"^"_OrdUnitCost_"^"_OrdQty_"^"_OrdCost
	s Data=$lb(RegNo,PatName,BedCode,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes,OrdUnitCost,OrdQty,OrdCost)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
GetOrderConSingle(OrderId,OrderSub)
	s (RegNo,PatName,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes)=""
	S OeordId=OrderId_"||"_OrderSub
	s AmdId=$P($G(^OEORD(OrderId)),"^",1)
	s papmiId=+^PAADM(AmdId)
    s RegNo=..GetRegNobyEpisodeID(AmdId)
    s PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    s curWardId=$p($g(^PAADM(AmdId)),"^",70)  
    s bedId=$p($g(^PAADM(AmdId)),"^",73)
    s bedSub=$p(bedId,"||",2)
    s BedCode=""
    i bedSub'="" s BedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    s ctlocId=$p(^PAADM(AmdId),"^",4)
	s AdmDep=$p(^CTLOC(+ctlocId),"^",2)
	i $P(AdmDep,"-",2)'="" s AdmDep=$P(AdmDep,"-",2)
	s ArcimDR=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",2)
	s ArcimSub=$P(ArcimDR,"||",1)
	s ArcimVer=$P(ArcimDR,"||",2)
	s ArcimDesc=$P(^ARCIM(ArcimSub,ArcimVer,1),"^",2)
	s OrcatDR=$P(^ARCIM(ArcimSub,ArcimVer,1),"^",10)
	s OrcatDesc=$P(^ARC("IC",OrcatDR),"^",2)	
	s OrdStatDR=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",13)
	i OrdStatDR'="" s OrdStatDesc=$P(^OEC("OSTAT",OrdStatDR),"^",2)
	e  s OrdStatDesc=""
	//s ExecDate=$P($G(^OEORD(OrderId,"I",OrderSub,11)),"^",4)   // OEORI_UpdateDate
	s ExecDate=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",2)   // OEORI_DateExecuted
	//s ExecTime=$P($G(^OEORD(OrderId,"I",OrderSub,11)),"^",5)   // OEORI_UpdateTime
	s ExecTime=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",3)   // OEORI_TimeExecuted
	s ExecDateTime=$$$zd(ExecDate,3)_"  "_$zt(ExecTime)
    i ExecDate="" s ExecDateTime=""
	//s ExecCtcpDR=$P(^OEORD(OrderId,"I",OrderSub,8),"^",12)    // OEORI_UserUpdate
	s ExecCtcpDR=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",4)       // OEORI_UserExecuted
	i ExecCtcpDR'="" s ExecCtcpDesc=$P($G(^SSU("SSUSR",ExecCtcpDR)),"^",2)
	e  s ExecCtcpDesc=""
	i ExecCtcpDesc="" d
	.s STChildsub=""
	.f  s STChildsub = $o(^OEORD(OrderId,"I",OrderSub,"ST",STChildsub),-1) q:(STChildsub="")||($p($g(^OEORD(OrderId,"I",OrderSub,"ST",STChildsub)),"^",3)'=6)  d
	..s ExecCtcpDescID = $p($g(^OEORD(OrderId,"I",OrderSub,"ST",STChildsub)),"^",4)
	..s ExecCtcpDesc=$P($G(^SSU("SSUSR",ExecCtcpDescID)),"^",2)  
	..s ExecDate= $p($g(^OEORD(OrderId,"I",OrderSub,"ST",STChildsub)),"^",1)
	..s ExecTime=$p($g(^OEORD(OrderId,"I",OrderSub,"ST",STChildsub)),"^",2)             
	..s ExecDateTime=$$$zd(ExecDate,3)_"  "_$zt(ExecTime)
	s CtcpDR=$P(^OEORD(OrderId,"I",OrderSub,7),"^",1)         //OEORI_UserAdd
	i CtcpDR'="" s CtcpDesc=$P(^SSU("SSUSR",CtcpDR),"^",2)
	e  s CtcpDesc=""                                        
	s RecLocDR=$P(^OEORD(OrderId,"I",OrderSub,3),"^",6)       //OEORI_RecDep_DR
	s RecLocDesc=$p(^CTLOC(RecLocDR),"^",2)
	i $P(RecLocDesc,"-",2)'="" s RecLocDesc=$P(RecLocDesc,"-",2)                                        
    s OrdDate1=$p($g(^OEORD(OrderId,"I",OrderSub,3)),"^",7)   //OEORI_Date
    s OrdTime1=$p($g(^OEORD(OrderId,"I",OrderSub,1)),"^",17)  //OEORI_TimeOrd
	s OrdDateTime=$$$zd(OrdDate1,3)_"  "_$zt(OrdTime1)
	i OrdStatDR=1 d
	.s ExecDateTime=""
	.s ExecCtcpDesc=""
    f rnum=1:1:$g(^OEORD(OrderId,"I",OrderSub,"DEP",0))  d    //OEORI_DepProcNotes
	.s notes=$g(notes)_$g(^OEORD(OrderId,"I",OrderSub,"DEP",rnum))
	s oeoriPrice=$p($g(^OEORD(OrderId,"I",OrderSub,3)),"^",25)
    s OrdUnitCost=+##CLASS(UDHCJFPRICE).GetOrderPrice("","",ArcimDR,OrdDate1,"","","",oeoriPrice)
	//s OrdUnitCost=$p($g(^OEORD(OrderId,"I",OrderSub,2)),"^",13)
	s OrdQty=$p($g(^OEORD(OrderId,"I",OrderSub,1)),"^",12)
	s OrdCost=OrdUnitCost*OrdQty
	q
}

ClassMethod GetRegNobyEpisodeID(EpisodeID)
{
 	n (EpisodeID)
 	q:$g(EpisodeID)="" ""
 	q:'$d(^PAADM(EpisodeID)) ""
 	s PaitentID=$p(^PAADM(EpisodeID),"^",1)
 	s admType=$p(^PAADM(EpisodeID),"^",2)
 	
 	q:$g(PaitentID)="" ""
 	q:'$D(^PAPER(PaitentID,"PAT",1)) ""
 	q:admType="I" $p(^PAPER(PaitentID,"PAT",1),"^",1)
 	q $p(^PAPER(PaitentID,"PAT",1),"^",2)
}

ClassMethod GetFlage(OrderId, OrderSub, ExecFlage) As %String
{
	s ret=0
	s OrdStatDR=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",13)
	q:OrdStatDR="" 0
	s OrdStatCodec=$P(^OEC("OSTAT",OrdStatDR),"^",1)
	q:(OrdStatCodec="D") 0
	q:(OrdStatCodec="E")&(ExecFlage=0) 0
	q:(OrdStatCodec'="E")&(ExecFlage=1) 0
	//s OrdStatDesc=$P(^OEC("OSTAT",OrdStatDR),"^",2)
	//q:(OrdStatDesc="停止") 0
	//q:(OrdStatDesc="执行")&(ExecFlage=0) 0
	//q:(OrdStatDesc'="执行")&(ExecFlage=1) 0
	s ArcimDR=$P(^OEORD(OrderId,"I",OrderSub,1),"^",2)
	s ArcimSub=$P(ArcimDR,"||",1)
	s ArcimVer=$P(ArcimDR,"||",2)
	s ArcimDesc=$P(^ARCIM(ArcimSub,ArcimVer,1),"^",2)
	s OrcatDR=$P(^ARCIM(ArcimSub,ArcimVer,1),"^",10)
	s OrcatType=$p($g(^ARC("IC",OrcatDR)),"^",7)
	i (OrcatType="L")!(OrcatType="X") s ret=1      //医嘱子类类型 C Consultation
	q ret
}

Query LookUpCtloc(desc As %String) As %Query(ROWSPEC = "ctlocDesc:%String,ctlocId:%String")
{
}

ClassMethod LookUpCtlocExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s desc=$$ALPHAUP^SSUTIL4(desc)
	/*s admlocId=0
	f  s admlocId=$o(^PAC("ADMLOC",admlocId)) q:admlocId=""  d
	.s ctlocId=$p(^PAC("ADMLOC",admlocId),"^",2)
	.q:'$D(^CTLOC(ctlocId))*/
	s ctlocId=0
	f  s ctlocId=$O(^CTLOC(ctlocId)) q:ctlocId=""  d
	.s ctlocDesc=$$ALPHAUP^SSUTIL4($p(^CTLOC(ctlocId),"^",2))
	.i (desc'="")&($p(ctlocDesc,desc,1)'="") q
	.s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
	.i $P(ctlocDesc,"-",2)'="" s ctlocDesc=$P(ctlocDesc,"-",2)
	.d OutputRow4
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow4
	s Data=$lb(ctlocDesc,ctlocId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpCtlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpCtlocExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpCtlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpCtlocExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod OrdItmExecute(OrdIds As %String, UserId As %String, OrderStatus As %String, Notes As %String = "") As %String
{
  k PLIST
  s ret=""
  s OrdStatId=""
  i OrderStatus="" s OrderStatus="E"
  s OrdStatId=$o(^OEC("OSTAT",0,"Code",OrderStatus,OrdStatId),-1)
  q:OrdStatId="" -1
  s UpdateDate=+$h
  s UpdateTime=$p($h,",",2)
  f k=1:1:$l(OrdIds,"^") d
  .s OrdRowId=$p(OrdIds,"^",k)
  .i '$l(OrdRowId) d
  ..s ret=ret_"1"_"^"
  .e  d
  ..s PLIST(0)=OrdRowId
  ..s PLIST(3)=UpdateDate
  ..s PLIST(4)=UpdateTime
  ..s PLIST(5)=OrdStatId
  ..s PLIST(6)=UserId
  ..;&sql(Update OE_OrdItem set OEORI_DateExecuted=:UpdateDate,OEORI_TimeExecuted=:UpdateTime,OEORI_ItemStat_DR=:OrdStatId,OEORI_UserExecuted=:UserId where OEORI_RowId=:OrdRowId and OEORI_ItemStat_DR='1')
  ..;q:SQLCODE<0
  ..;7.0后调用新接口
  ..s executeRet=##class(appcom.OEOrdItem).Execute(OrdRowId,UserId)
  ..q:executeRet'=0
  ..i ($D(^OEORD($P(OrdRowId,"||"),"I",$P(OrdRowId,"||",2),"DEP",1))>0)&(Notes'="") d
  ...s ^OEORD($P(OrdRowId,"||"),"I",$P(OrdRowId,"||",2),"DEP",1)=Notes
  ..;&sql(insert into oe_ordstatus values PLIST() )
  ..;i SQLCODE=0 d 
  ..;.s rtemp=0
  ..;e  d 
  ..;.s rtemp=1
  ..s rtemp=0
  ..s ret=ret_rtemp_"^"
  i $l(ret) s ret=$p(ret,"^",1,$l(ret,"^")-1)
  q ret
}

ClassMethod GetLocDes(LocId) As %String
{
	q:LocId="" ""
	s CTLocDesc=$p(^CTLOC(LocId),"^",2)
	q CTLocDesc
}

ClassMethod UnDoExecOrd(OrdIds As %String, UserId As %String) As %String
{
  k PLIST
  s ret=""
  s UpdateDate=+$h
  s UpdateTime=$p($h,",",2)
  f k=1:1:$l(OrdIds,"^") d
  .s OrdRowId=$p(OrdIds,"^",k)
  .i '$l(OrdRowId) d
  ..s ret=ret_"1"_"^"
  .e  d
  ..s PLIST(0)=OrdRowId
  ..s PLIST(3)=UpdateDate
  ..s PLIST(4)=UpdateTime
  ..s PLIST(5)=1
  ..s PLIST(6)=UserId
  ..&sql(Update OE_OrdItem set OEORI_DateExecuted=null,OEORI_TimeExecuted=null,OEORI_ItemStat_DR=1 where OEORI_RowId=:OrdRowId and OEORI_ItemStat_DR='6')
  ..q:SQLCODE<0
  ..i ($D(^OEORD($P(OrdRowId,"||"),"I",$P(OrdRowId,"||",2),"DEP",1))>0) d
  ...s ^OEORD($P(OrdRowId,"||"),"I",$P(OrdRowId,"||",2),"DEP",1)=""
  ..&sql(insert into oe_ordstatus values PLIST() )
  ..i SQLCODE=0 d 
  ...s rtemp=0
  ..e  d 
  ...s rtemp=1
  ..s ret=ret_rtemp_"^"
  i $l(ret) s ret=$p(ret,"^",1,$l(ret,"^")-1)
  q ret
}

ClassMethod GetPrintOrderNum() As %String
{
	s orderNum=0
 	s userId=%session.Data("LOGON.USERID")
 	s orderNum=$O(^TmpNurOrderPrint(userId,""),-1)
 	q orderNum
}

ClassMethod GetPrintOrder(index As %String = "") As %String
{
	q:index="" ""
 	s userId=%session.Data("LOGON.USERID")
 	q $G(^TmpNurOrderPrint(userId,index))
}

Query GetPrintOder(EpisodeID As %String, PatRegNo As %String, StartDate As %String, EndDate As %String, LocId As %String, ExecFlage As %String) As %Query(ROWSPEC = "RegNo:%String,PatName:%String,BedCode:%String,ArcimDesc:%String,OeordId:%String,OrdStatDesc:%String,OrcatDesc:%String,ExecDateTime:%String,ExecCtcpDesc:%String,CtcpDesc:%String,RecLocDesc:%String,OrdDateTime:%String,AdmDep:%String,notes:%String,OrdUnitCost:%String,OrdQty:%String,OrdCost:%String")
{
}

ClassMethod GetPrintOderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintOderExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetPrintOderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintOderExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetPrintOderExecute(ByRef qHandle As %Binary, EpisodeID As %String, PatRegNo As %String, StartDate As %String, EndDate As %String, LocId As %String, ExecFlage As %String = 0) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i LocId="" s LocId=%session.Data("LOGON.CTLOCID")
 	s userId=%session.Data("LOGON.USERID")
 	k ^TmpNurOrderPrint(userId)
 	i LocId=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	i StartDate=""  s StartDate=+$H
 	i EndDate=""    s EndDate=+$H
 	i ExecFlage="" s ExecFlage=0
 	i StartDate>EndDate   Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s OrdSum=0,CostSum=0
 	i EpisodeID'="" s PatRegNo=##Class(web.DHCCLCom).GetRegNobyEpisodeID(EpisodeID)
 	i PatRegNo'="" d
 	.s papmiId=""
 	.s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatRegNo),""))
 	.q:papmiId=""
 	.s admId="" f  s admId=$o(^PAPERdr(papmiId,"ADM","I",admId),-1) q:(admId="")  d
 	..s pavisit=$p($g(^PAADM(admId)),"^",20)
 	..q:pavisit'="A"
 	..s admType=$p($G(^PAADM(admId)),"^",2)
 	..q:admType'="I"
 	..s OrderId=$O(^OEORD(0,"Adm",admId,""))
 	..q:OrderId=""
 	..s OrderSub=0
 	..f  s OrderSub=$O(^OEORD(OrderId,"I",OrderSub)) q:OrderSub=""  d
 	...s recLocId=$P($G(^OEORD(OrderId,"I",OrderSub,3)),"^",6)
	...q:(LocId'="")&(recLocId'=LocId)
	...s OrdStatDR=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",13)
	...q:OrdStatDR=""
	...s OrdStatCodec=$P(^OEC("OSTAT",OrdStatDR),"^",1)
	...q:(OrdStatCodec="D")
	...s ArcimDR=$P(^OEORD(OrderId,"I",OrderSub,1),"^",2)
	...s ArcimSub=$P(ArcimDR,"||",1)
	...s ArcimVer=$P(ArcimDR,"||",2)
	...s ArcimDesc=$P(^ARCIM(ArcimSub,ArcimVer,1),"^",2)
	...s OrcatDR=$P(^ARCIM(ArcimSub,ArcimVer,1),"^",10)
	...s OrcatType=$p($g(^ARC("IC",OrcatDR)),"^",7)
	...q:((OrcatType="L")!(OrcatType="X"))&&(OrdStatCodec'="E")
	...d GetOrderConSingle1(OrderId,OrderSub)
	...d OutputRow1
 	e  d
	.f OrdDate=StartDate:1:EndDate d
	..s OrdTime=""
	..f  s OrdTime=$O(^OEORDi(0,"LocStDtTm",LocId,OrdDate,OrdTime)) q:OrdTime=""  d
	...s OrderId=0
	...f  s OrderId=$O(^OEORDi(0,"LocStDtTm",LocId,OrdDate,OrdTime,OrderId)) q:OrderId=""  d
	....s OrderSub=0
	....s admId=$P($G(^OEORD(OrderId)),"^",1)
	....q:admId=""
 	....s admType=$p($G(^PAADM(admId)),"^",2)
 	....q:admType'="I"
	....f  s OrderSub=$O(^OEORDi(0,"LocStDtTm",LocId,OrdDate,OrdTime,OrderId,OrderSub)) q:OrderSub=""  d
	.....s OrdStatDR=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",13)
	.....q:OrdStatDR=""
	.....s OrdStatCodec=$P(^OEC("OSTAT",OrdStatDR),"^",1)
	.....q:(OrdStatCodec="D")
	.....s ArcimDR=$P(^OEORD(OrderId,"I",OrderSub,1),"^",2)
	.....s ArcimSub=$P(ArcimDR,"||",1)
	.....s ArcimVer=$P(ArcimDR,"||",2)
	.....s ArcimDesc=$P(^ARCIM(ArcimSub,ArcimVer,1),"^",2)
	.....s OrcatDR=$P(^ARCIM(ArcimSub,ArcimVer,1),"^",10)
	.....s OrcatType=$p($g(^ARC("IC",OrcatDR)),"^",7)
	.....q:((OrcatType="L")!(OrcatType="X"))&&(OrdStatCodec'="E")
	.....d GetOrderConSingle1(OrderId,OrderSub)
	.....d OutputRow1
	
	s (RegNo,PatName,BedCode,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes,OrdUnitCost,OrdQty,OrdCost)=""
	s RegNo="总计:"
	s OrdQty=OrdSum
	s OrdCost=CostSum
	s ^TmpNurOrderPrint(userId,ind)=RegNo_"^"_PatName_"^"_BedCode_"^"_ArcimDesc_"^"_OeordId_"^"_OrdStatDesc_"^"_OrcatDesc_"^"_ExecDateTime_"^"_ExecCtcpDesc_"^"_CtcpDesc_"^"_RecLocDesc_"^"_OrdDateTime_"^"_AdmDep_"^"_notes_"^"_OrdUnitCost_"^"_OrdQty_"^"_OrdCost
	s Data=$lb(RegNo,PatName,BedCode,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes,OrdUnitCost,OrdQty,OrdCost)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow1
	s ^TmpNurOrderPrint(userId,ind)=RegNo_"^"_PatName_"^"_BedCode_"^"_ArcimDesc_"^"_OeordId_"^"_OrdStatDesc_"^"_OrcatDesc_"^"_ExecDateTime_"^"_ExecCtcpDesc_"^"_CtcpDesc_"^"_RecLocDesc_"^"_OrdDateTime_"^"_AdmDep_"^"_notes_"^"_OrdUnitCost_"^"_OrdQty_"^"_OrdCost
	i OrdSum=0 s OrdSum=OrdQty
	e  s OrdSum=OrdSum+OrdQty
	i CostSum=0 s CostSum=OrdCost
	e  s CostSum=OrdCost+CostSum
	s Data=$lb(RegNo,PatName,BedCode,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes,OrdUnitCost,OrdQty,OrdCost)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
GetOrderConSingle1(OrderId,OrderSub)
	s (RegNo,PatName,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes)=""
	S OeordId=OrderId_"||"_OrderSub
	s AmdId=$P($G(^OEORD(OrderId)),"^",1)
	s papmiId=+^PAADM(AmdId)
    s RegNo=..GetRegNobyEpisodeID(AmdId)
    s PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    s curWardId=$p($g(^PAADM(AmdId)),"^",70)  
    s bedId=$p($g(^PAADM(AmdId)),"^",73)
    s bedSub=$p(bedId,"||",2)
    s BedCode=""
    i bedSub'="" s BedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    s ctlocId=$p(^PAADM(AmdId),"^",4)
	s AdmDep=$p(^CTLOC(+ctlocId),"^",2)
	i $P(AdmDep,"-",2)'="" s AdmDep=$P(AdmDep,"-",2)
	s ArcimDR=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",2)
	s ArcimSub=$P(ArcimDR,"||",1)
	s ArcimVer=$P(ArcimDR,"||",2)
	s ArcimDesc=$P(^ARCIM(ArcimSub,ArcimVer,1),"^",2)
	s OrcatDR=$P(^ARCIM(ArcimSub,ArcimVer,1),"^",10)
	s OrcatDesc=$P(^ARC("IC",OrcatDR),"^",2)	
	s OrdStatDR=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",13)
	i OrdStatDR'="" s OrdStatDesc=$P(^OEC("OSTAT",OrdStatDR),"^",2)
	e  s OrdStatDesc=""
	//s ExecDate=$P($G(^OEORD(OrderId,"I",OrderSub,11)),"^",4)   // OEORI_UpdateDate
	s ExecDate=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",2)   // OEORI_DateExecuted
	//s ExecTime=$P($G(^OEORD(OrderId,"I",OrderSub,11)),"^",5)   // OEORI_UpdateTime
	s ExecTime=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",3)   // OEORI_TimeExecuted
	s ExecDateTime=$$$zd(ExecDate,3)_"  "_$zt(ExecTime)
    i ExecDate="" s ExecDateTime=""
	//s ExecCtcpDR=$P(^OEORD(OrderId,"I",OrderSub,8),"^",12)    // OEORI_UserUpdate
	s ExecCtcpDR=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",4)       // OEORI_UserExecuted
	i ExecCtcpDR'="" s ExecCtcpDesc=$P($G(^SSU("SSUSR",ExecCtcpDR)),"^",2)
	e  s ExecCtcpDesc=""
	s CtcpDR=$P(^OEORD(OrderId,"I",OrderSub,7),"^",1)         //OEORI_UserAdd
	i CtcpDR'="" s CtcpDesc=$P(^SSU("SSUSR",CtcpDR),"^",2)
	e  s CtcpDesc=""                                        
	s RecLocDR=$P(^OEORD(OrderId,"I",OrderSub,3),"^",6)       //OEORI_RecDep_DR
	s RecLocDesc=$p(^CTLOC(RecLocDR),"^",2)
	i $P(RecLocDesc,"-",2)'="" s RecLocDesc=$P(RecLocDesc,"-",2)                                        
    s OrdDate1=$p($g(^OEORD(OrderId,"I",OrderSub,3)),"^",7)   //OEORI_Date
    s OrdTime1=$p($g(^OEORD(OrderId,"I",OrderSub,1)),"^",17)  //OEORI_TimeOrd
	s OrdDateTime=$$$zd(OrdDate1,3)_"  "_$zt(OrdTime1)
	i OrdStatDR=1 d
	.s ExecDateTime=""
	.s ExecCtcpDesc=""
    f rnum=1:1:$g(^OEORD(OrderId,"I",OrderSub,"DEP",0))  d    //OEORI_DepProcNotes
	.s notes=$g(notes)_$g(^OEORD(OrderId,"I",OrderSub,"DEP",rnum))
	s oeoriPrice=$p($g(^OEORD(OrderId,"I",OrderSub,3)),"^",25)
    s OrdUnitCost=+##CLASS(UDHCJFPRICE).GetOrderPrice("","",ArcimDR,OrdDate1,"","","",oeoriPrice)
	//s OrdUnitCost=$p($g(^OEORD(OrderId,"I",OrderSub,2)),"^",13)
	s OrdQty=$p($g(^OEORD(OrderId,"I",OrderSub,1)),"^",12)
	s OrdCost=OrdUnitCost*OrdQty
	q
}

Query GetArcic(ArcicDesc As %String = "") As %Query(ROWSPEC = "desc:%String,rowId:%String")
{
}

ClassMethod GetArcicExecute(ByRef qHandle As %Binary, ArcicDesc As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	s rowId=0  f  s rowId=$o(^ARC("IC",rowId))  q:rowId=""  d
 		.s desc=$p(^ARC("IC",rowId),"^",2)
 		.q:(ArcicDesc'="")&(desc'[ArcicDesc)
 		.d Outputcat
    s qHandle=$lb(0,repid,0)
	q $$$OK
Outputcat
	s Data=$lb(desc,rowId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetArcicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetArcicExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetArcicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetArcicExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

Query FindMasterItem(OrdCatId As %String, ARCIMDesc As %String) As %Query(ROWSPEC = "ArcimDesc:%String,ArcimDR:%String")
{
}

ClassMethod FindMasterItemExecute(ByRef qHandle As %Binary, OrdCatId As %String = "", ARCIMDesc As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    i (ARCIMDesc'="") s ARCIMDesc=$$ALPHAUP^SSUTIL4(ARCIMDesc)
 	s ArcimID=0 
 	f  s ArcimID=$o(^ARCIM(ArcimID)) q:ArcimID=""  d
	.s ArcimSubID=0 f  s ArcimSubID=$o(^ARCIM(ArcimID,ArcimSubID)) q:ArcimSubID=""  d
	..s ItemCatDr=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",10)
	..q:(OrdCatId'="")&&(OrdCatId'=ItemCatDr)
	..s ArcimDR=ArcimID_"||"_ArcimSubID
	..s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",ArcimDR,""))
	..q:AlisDR=""
	..s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
	..s ArcimDesc=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",2)
	..s ArcimDesc=AlisDesc_"-"_ArcimDesc
	..q:ArcimDesc'[ARCIMDesc
	..Do OutputRow5
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(ArcimDesc,ArcimDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindMasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
