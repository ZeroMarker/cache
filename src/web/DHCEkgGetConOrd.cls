Import SQLUser

/// 程序名DHCNurConOrd,护士会诊医嘱查询与执行
Class web.DHCEkgGetConOrd Extends %Library.RegisteredObject
{

Parameter BUILD = 107;

/// d ##class(%ResultSet).RunQuery("web.DHCEkgGetConOrd","GetConOder","","","64635","64635","85","0","","","","","","","","")
Query GetConOder(EpisodeID As %String, PatRegNo As %String, StartDate As %String, EndDate As %String, LocId As %String, ExecFlage As %String, PatLocId As %String, OrdCatId As %String, ArcimId As %String, CurLocAdd As %String, MZPatDr As %String, InPatDr As %String, SelfFlag As %String, patientType = "") As %Query(ROWSPEC = "RegNo:%String,PatName:%String,BedCode:%String,ArcimDesc:%String,OeordId:%String,OrdStatDesc:%String,OrcatDesc:%String,ExecDateTime:%String,ExecCtcpDesc:%String,CtcpDesc:%String,RecLocDesc:%String,OrdDateTime:%String,AdmDep:%String,notes:%String,OrdUnitCost:%String,OrdQty:%String,OrdCost:%String,admId:%String,medcareno:%String,BillStatus:%String,Billed:%String,admType:%String,sex:%String,wardid:%String,age:%String,Diagnosis:%String,AdmReason:%String,dobDate:%String,FeeState:%String,PatStatus:%String,RptState:%String")
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

ClassMethod GetConOderExecute(ByRef qHandle As %Binary, EpisodeID As %String, PatRegNo As %String, StartDate As %String, EndDate As %String, LocId As %String, ExecFlage As %String = 0, PatLocId As %String = "", OrdCatId As %String = "", ArcimId As %String = "", CurLocAdd As %String = "", MZPatDr As %String, InPatDr As %String, SelfFlag As %String, patientType = "") As %Status
{
	;s ^zlj("GetConOderExecute")=EpisodeID_","_PatRegNo_","_StartDate_","_EndDate_","_LocId_","_ExecFlage_","_PatLocId_","_OrdCatId_","_ArcimId_","_CurLocAdd_","_MZPatDr_","_InPatDr
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i LocId="" s LocId=%session.Data("LOGON.CTLOCID")
 	s userId="2864"
 	//s userId=%session.Data("LOGON.USERID")
 	//s ssGroup=%session.Data("LOGON.GROUPID")
 	//s ssgroupdesc=%session.Data("LOGON.GROUPDESC")
 	s OrdQtys=0,OrdCosts=0
 	k ^TmpNurOrderPrint(userId)
 	;s ^EH("GetConOder")=EpisodeID_"^"_PatRegNo_"^"_StartDate_"^"_EndDate_"^"_LocId_"^"_ExecFlage_"^"_PatLocId_"^"_OrdCatId_"^"_ArcimId_"^"_CurLocAdd_"^"_MZPatDr_"^"_InPatDr
 	i LocId=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	i StartDate=""  s StartDate=+$H
 	i EndDate=""    s EndDate=+$H
 	i ExecFlage="" s ExecFlage=0
 	s mradm="",Diagnosis=""
 	i StartDate>EndDate   Set qHandle=$lb(0,repid,0) Quit $$$OK
 	i EpisodeID'="" s PatRegNo=##Class(web.DHCCLCom).GetRegNobyEpisodeID(EpisodeID)
 	i PatRegNo'="" d
 	.s papmiId=""
 	.s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatRegNo),""))
 	.q:papmiId=""
 	.s medcareno=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
 	.s admTypes(1)="O",admTypes(2)="E",admTypes(3)="I",admTypes(4)="H"
 	.f indexAdmType=1:1:4 d
 	..s admId="" f  s admId=$o(^PAPERdr(papmiId,"ADM",admTypes(indexAdmType),admId),-1) q:(admId="")  d
 	...s pavisit=$p($g(^PAADM(admId)),"^",20)
 	...s admType=$p($G(^PAADM(admId)),"^",2)
 	...q:(pavisit'="A")&(admType="I") ;pavisit="D"为出院
 	...q:(MZPatDr="1")&(InPatDr="0")&(admType="I")
 	...q:(InPatDr="1")&(MZPatDr="0")&(admType'="I")
 	...//门诊O急诊E住院I
 	...q:("OEIH")'[admType
 	...//q:(ssGroup=271)&(LocId=170)&(admType'="I")   //update gsb 20110810
 	...//q:((ssGroup=258)!(ssGroup=200))&(LocId=170)&(admType="I")
 	...s ctlocId=$p(^PAADM(admId),"^",4)
 	...q:(PatLocId'="")&(PatLocId'=ctlocId)
 	...s OrderId=$O(^OEORD(0,"Adm",admId,""))
 	...q:OrderId=""
 	...s OrderSub=0
 	...f  s OrderSub=$O(^OEORD(OrderId,"I",OrderSub)) q:OrderSub=""  d
 	....i OrderId="290047",OrderSub="48" s ^EH("jjj")=0
 	....s SttDat=$p($g(^OEORD(OrderId,"I",OrderSub,1)),"^",9)   //OEORI_SttDat
    ....q:(SttDat<StartDate)!(SttDat>EndDate)
    ....s OrditmType=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",13)
 	....q:(OrditmType'="1")&(OrditmType'="6")   //update gsb 2012-11-22
    ....;s Billed=$P($G(^OEORD(OrderId,"I",OrderSub,3)),"^",5)
    ....//q:(("OE")[admType)&(Billed'="P")  //门急诊未收费项目不显示
 	....s recLocId=$P($G(^OEORD(OrderId,"I",OrderSub,3)),"^",6)
	....q:(LocId'="")&(recLocId'=LocId)
	....s addlocid=$p($G(^OEORD(OrderId,"I",OrderSub,7)),"^",2)
	....;q:(+CurLocAdd=0)&(addlocid=LocId)    //默认本科室开的医嘱不显示， update gsb 20120625
	....s arcItemRowId=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",2)
	....//q:(arcItemRowId="11183||1")  //病历手册
	....q:(ArcimId'="")&&(ArcimId'=arcItemRowId)
	....s arcCatRowId=$P($G(^ARCIM(+arcItemRowId,$P(arcItemRowId,"||",2),1)),"^",10)
	....q:(arcCatRowId="191")&(arcCatRowId="194")  //挂号费，诊疗费 //EH
	....q:(OrdCatId'="")&&(OrdCatId'=arcCatRowId)
	....//-------过滤不需要的医嘱分类----------------
	....s OrdCatDr=$P(^ARC("IC",arcCatRowId),"^",8)
	....s OrdCatDrStr="^"_OrdCatDr_"^"
	....;q:(^DHCNeedExeOrdCat'[OrdCatDrStr)
	....//-------------------------------------------
	....s flage=..GetFlage(OrderId,OrderSub,ExecFlage)
	....q:flage=0
	....;s billed=$p(^OEORD(OrderId,"I",OrderSub,3),"^",5)
	....;i billed'="" s BillStatus=##class(web.DHCRisCommFunctionEx).GetBilledDesc(billed)
	....;//s billstr=##class(web.DHCRisWorkBenchDoEx).GetBillStatusStr(admId,OrderId,OrderSub)
	....;//s billed=$P(billstr,"^",1)
	....s billed=""
	....;//s BillStatus=$P(billstr,"^",2)
	....s OrdCost=0
	....s ExecCtcpDR=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",4)       // OEORI_UserExecuted
	....//lgl+只看本人执行的
	....q:(SelfFlag="1")&&(userId'=ExecCtcpDR)&&(ExecCtcpDR'="")

	....d GetOrderConSingle(OrderId,OrderSub)
	....d OutputRow
 	e  d
	.f OrdDate=StartDate:1:EndDate d
	..s OrdTime=""
	..f  s OrdTime=$O(^OEORDi(0,"LocStDtTm",LocId,OrdDate,OrdTime)) q:OrdTime=""  d
	...s OrderId=0
	...f  s OrderId=$O(^OEORDi(0,"LocStDtTm",LocId,OrdDate,OrdTime,OrderId)) q:OrderId=""  d
	....s OrderSub=0
	....s admId=$P($G(^OEORD(OrderId)),"^",1)
	....q:admId=""
	....s papmiId=+^PAADM(admId)
	....q:papmiId=""
	....s medcareno=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	....s pavisit=$p($g(^PAADM(admId)),"^",20)
 	....s admType=$p($G(^PAADM(admId)),"^",2)
 	....q:(pavisit'="A")&(admType="I")
 	....q:(MZPatDr="1")&(InPatDr="0")&(admType="I")
 	....q:(InPatDr="1")&(MZPatDr="0")&(admType'="I")
 	....//门诊O急诊E住院I体检H
 	....q:("OEIH")'[admType
 	....//q:(ssGroup=271)&(LocId=170)&(admType'="I")   //update gsb 20110810
 	....//q:((ssGroup=258)!(ssGroup=200))&(LocId=170)&(admType="I")
 	....s ctlocId=$p(^PAADM(admId),"^",4)
 	....q:(PatLocId'="")&(PatLocId'=ctlocId)
	....f  s OrderSub=$O(^OEORDi(0,"LocStDtTm",LocId,OrdDate,OrdTime,OrderId,OrderSub)) q:OrderSub=""  d
	.....;s Billed=$P($G(^OEORD(OrderId,"I",OrderSub,3)),"^",5)
 	.....//q:(("OE")[admType)&(Billed'="P")  //门急诊未收费项目不显示
 	.....s OrditmType=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",13)
 	.....q:(OrditmType'="1")&(OrditmType'="6")   //update gsb 2012-11-22
	.....s arcItemRowId=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",2)
	.....//q:(arcItemRowId="11183||1")  //病历手册
	.....q:(ArcimId'="")&&(ArcimId'=arcItemRowId)
	.....s arcCatRowId=$P($G(^ARCIM(+arcItemRowId,$P(arcItemRowId,"||",2),1)),"^",10)
	.....q:(arcCatRowId="191")!(arcCatRowId="194") //挂号费，诊疗费
	.....q:(OrdCatId'="")&&(OrdCatId'=arcCatRowId)
	.....//-------过滤不需要的医嘱分类----------------
	.....s OrdCatDr=$P(^ARC("IC",arcCatRowId),"^",8)
	.....s OrdCatDrStr="^"_OrdCatDr_"^"
	.....;q:(^DHCNeedExeOrdCat'[OrdCatDrStr)
	.....//-------------------------------------------
	.....s addlocid=$p($G(^OEORD(OrderId,"I",OrderSub,7)),"^",2)
	.....;q:(+CurLocAdd=0)&(addlocid=LocId)    //默认本科室开的医嘱不显示， update gsb 20120625
	.....s flage=..GetFlage(OrderId,OrderSub,ExecFlage)
	.....q:flage=0
	.....;//s billstr=##class(web.DHCRisWorkBenchDoEx).GetBillStatusStr(admId,OrderId,OrderSub)
	.....;//s billed=$P(billstr,"^",1)
	.....s billed=""
	.....;//s BillStatus=$P(billstr,"^",2)
	.....s OrdCost=0
	.....s ExecCtcpDR=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",4)       // OEORI_UserExecuted
	.....//lgl+只看本人执行的
	.....q:(SelfFlag="1")&&(userId'=ExecCtcpDR)&&(ExecCtcpDR'="")

	.....d GetOrderConSingle(OrderId,OrderSub)
	.....d OutputRow
	//s (RegNo,PatName,BedCode,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes,OrdUnitCost,OrdQty,OrdCost,admId,medcareno,BillStatus,billed,admType1,sex,wardid,age,Diagnosis,AdmReason)=""
	//s PatName="合计:"
	//s ArcimDesc=OrdQtys,OrdStatDesc=OrdCosts

    //d OutputRow2
 	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow

	//'(常规心电||动态心电||脑电||肌电||动态血压)
	;quit:((ArcimDesc'["心电")&(ArcimDesc'["脑电")&(ArcimDesc'["肌电")&(ArcimDesc'["动态血压"))
	if ((patientType'="") & (patientType'=admType)) quit
    i admType="I"  s admType1="住院病人"
    i admType="O"  s admType1="门诊病人"
    i admType="E"  s admType1="急诊病人"
    i admType="H"  s admType1="体检病人"
    s mradm=$P(^PAADM(admId),"^",61)
    s AdmReason=$P(^PAADM(admId,1),"^",7)
    q:AdmReason=""
    s AdmReason=$p($G(^PAC("ADMREA",AdmReason)),"^",2)
	Set Diagnosis=##class(web.DHCAdmOrderTree).GetMRAdmDiagnosis(mradm)
	s ^TmpNurOrderPrint(userId,ind)=RegNo_"^"_PatName_"^"_BedCode_"^"_ArcimDesc_"^"_OeordId_"^"_OrdStatDesc_"^"_OrcatDesc_"^"_ExecDateTime_"^"_ExecCtcpDesc_"^"_CtcpDesc_"^"_RecLocDesc_"^"_OrdDateTime_"^"_AdmDep_"^"_notes_"^"_OrdUnitCost_"^"_$g(OrdQty)_"^"_$g(OrdCost)_"^"_$g(admId)_"^"_$g(medcareno)_"^"_billed_"^"_Diagnosis_"^"_FeeState_"^"_PatState_"^"_RptState
	s Data=$lb(RegNo,PatName,BedCode,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes,OrdUnitCost,OrdQty,OrdCost,admId,medcareno,BillStatus,billed,admType1,sex,wardid,age,Diagnosis,AdmReason,dobDate,FeeState,PatState,RptState)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
OutputRow2
	s ^TmpNurOrderPrint(userId,ind)=RegNo_"^"_PatName_"^"_BedCode_"^"_ArcimDesc_"^"_OeordId_"^"_OrdStatDesc_"^"_OrcatDesc_"^"_ExecDateTime_"^"_ExecCtcpDesc_"^"_CtcpDesc_"^"_RecLocDesc_"^"_OrdDateTime_"^"_AdmDep_"^"_notes_"^"_OrdUnitCost_"^"_$g(OrdQty)_"^"_$g(OrdCost)_"^"_$g(admId)_"^"_$g(medcareno)_"^"_billed_"^"_Diagnosis_"^"_FeeState_"^"_PatState_"^"_RptState
	s Data=$lb(RegNo,PatName,BedCode,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes,OrdUnitCost,OrdQty,OrdCost,admId,medcareno,BillStatus,billed,admType1,sex,wardid,age,Diagnosis,AdmReason,dobDate,FeeState,PatState,RptState)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q

GetOrderConSingle(OrderId,OrderSub)
	s (RegNo,PatName,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes,AdmReason,FeeState,PatState,RptState)=""
	S OeordId=OrderId_"||"_OrderSub
	s AmdId=$P($G(^OEORD(OrderId)),"^",1)
	s papmiId=+^PAADM(AmdId)
	;获取计费状态
	s Billed=$P($G(^OEORD(OrderId,"I",OrderSub,3)),"^",5)
	s FeeState=Billed_"^未收费"
	i (Billed="P")  s FeeState="P^已收费"
	;获取报告状态
	s StudyNo="EKG||"_OeordId
	s ReportRowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,0))
	i (ReportRowid'="") d
	.;b ;ReportRowid
	.s ReportInfo=^DHCRBStudy("Report",ReportRowid)
	.q:(ReportInfo="")
	.s ReportDR=$p(ReportInfo,"^",4)
	.q:(ReportDR="")
	.s ReportStatusDesc=^DHCRBCStatus("ReportStatus",ReportDR)
	.q:(ReportStatusDesc="")
	.s RptState=$p(ReportStatusDesc,"^",2)
    s RegNo=..GetRegNobyEpisodeID(AmdId)
    s PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
 	s sexid=$p(^PAPER(papmiId,"ALL"),"^",7)
	s sex=$p(^CT("SEX",sexid),"^",2)
	s curDate=$zd($h,3)
	s dobDate=$zd($p($g(^PAPER(papmiId,"ALL")),"^",6),3)
    s age=##class(web.DHCDTHealthCommon).GetAgeDesc(dobDate,curDate)
    s curWardId=$p($g(^PAADM(AmdId)),"^",70)
	s patward=$p($g(^PAADM(AmdId)),"^",70) 
	i patward'=""  d  s wardid=$p(^PAWARD(patward),"^",1)
	e  s wardid=""
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
	s ExecCtcpDR=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",4)       // OEORI_UserExecuted
	i ExecCtcpDR'="" s ExecCtcpDesc=$P($G(^SSU("SSUSR",ExecCtcpDR)),"^",2)
	e  s ExecCtcpDesc=""
	s CtcpDR=$P($G(^OEORD(OrderId,"I",OrderSub,7)),"^",1)         //OEORI_UserAdd
	i CtcpDR'="" s CtcpDesc=$P(^SSU("SSUSR",CtcpDR),"^",2)
	e  s CtcpDesc=""
	i (ExecDate="")!(ExecTime="")!(CtcpDesc="") d // EH 取最近一条执行记录
	.s ordStatSub="",fd=0 f  s ordStatSub=$O(^OEORD(OrderId,"I",OrderSub,"ST",ordStatSub),-1),fd=$i(fd) q:(ordStatSub="")!(fd>1)  d
	..s ordStatStr=^OEORD(OrderId,"I",OrderSub,"ST",ordStatSub)
	..q:$p(ordStatStr,"^",3)=""
	..i ($p(^OEC("OSTAT",$p(ordStatStr,"^",3)),"^",1)="E") d
	...s ExecDate=$p(ordStatStr,"^",1)
	...s ExecTime=$p(ordStatStr,"^",2)
	...s xUserId=$p(ordStatStr,"^",4)
	...q:'$d(^SSU("SSUSR",+xUserId)) // 报错
	...s xCtcpId=$p(^SSU("SSUSR",+xUserId),"^",14)
	...i xCtcpId'="" s ExecCtcpDesc=$p($g(^CTPCP(xCtcpId,1)),"^",2)
	...e  s ExecCtcpDesc=""
	s ExecDateTime=$zd(ExecDate,3)_"  "_$zt(ExecTime)
    i ExecDate="" s ExecDateTime=""
	//s ExecCtcpDR=$P(^OEORD(OrderId,"I",OrderSub,8),"^",12)    // OEORI_UserUpdate
                                        
	s RecLocDR=$P(^OEORD(OrderId,"I",OrderSub,3),"^",6)       //OEORI_RecDep_DR
	s RecLocDesc=$p(^CTLOC(RecLocDR),"^",2)
	i $P(RecLocDesc,"-",2)'="" s RecLocDesc=$P(RecLocDesc,"-",2)                                        
    ;s OrdDate1=$p($g(^OEORD(OrderId,"I",OrderSub,3)),"^",7)   //OEORI_Date
    s OrdDate1=$p($g(^OEORD(OrderId,"I",OrderSub,1)),"^",9)
    s OrdTime1=$p($g(^OEORD(OrderId,"I",OrderSub,1)),"^",17)  //OEORI_TimeOrd
	s OrdDateTime=$zd(OrdDate1,3)_"  "_$zt(OrdTime1)
	i OrdStatDR=1 d
	.s ExecDateTime=""
	.s ExecCtcpDesc=""
    f rnum=1:1:$g(^OEORD(OrderId,"I",OrderSub,"DEP",0))  d    //OEORI_DepProcNotes
	.s notes=$g(notes)_$g(^OEORD(OrderId,"I",OrderSub,"DEP",rnum))
	s oeoriPrice=$p($g(^OEORD(OrderId,"I",OrderSub,3)),"^",25)
    s OrdUnitCost=+##CLASS(UDHCJFPRICE).GetOrderPrice("","",ArcimDR,OrdDate1,"","","",oeoriPrice)
	q:OrdUnitCost=0
	//s OrdUnitCost=$p($g(^OEORD(OrderId,"I",OrderSub,2)),"^",13)
	s OrdQty=$p($g(^OEORD(OrderId,"I",OrderSub,1)),"^",12)
	s OrdCost=OrdUnitCost*OrdQty
	s OrdQtys=OrdQtys+OrdQty
	s OrdCosts=OrdCosts+OrdCost
	
	q
}

/// d ##class(%ResultSet).RunQuery("web.DHCEkgGetConOrd","GetConOdrFee","","","64730","64740","85","","","","","","","","","","")
Query GetConOdrFee(EpisodeID As %String, PatRegNo As %String, StartDate As %String, EndDate As %String, LocId As %String, ExecFlage As %String, FeeFlage As %String, PatLocId As %String, OrdCatId As %String, ArcimId As %String, CurLocAdd As %String, MZPatDr As %String, InPatDr As %String, SelfFlag As %String, patientType = "") As %Query(ROWSPEC = "RegNo:%String,PatName:%String,BedCode:%String,ArcimDesc:%String,OeordId:%String,OrdStatDesc:%String,OrcatDesc:%String,ExecDateTime:%String,ExecCtcpDesc:%String,CtcpDesc:%String,RecLocDesc:%String,OrdDateTime:%String,AdmDep:%String,notes:%String,OrdUnitCost:%String,OrdQty:%String,OrdCost:%String,admId:%String,medcareno:%String,BillStatus:%String,Billed:%String,admType:%String,sex:%String,wardid:%String,age:%String,Diagnosis:%String,AdmReason:%String,dobDate:%String,FeeState:%String,RptState:%String")
{
}

ClassMethod GetConOdrFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConOderExecute ]
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

ClassMethod GetConOdrFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConOderExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetConOdrFeeExecute(ByRef qHandle As %Binary, EpisodeID As %String, PatRegNo As %String, StartDate As %String, EndDate As %String, LocId As %String, ExecFlage As %String = 0, FeeFlage As %String = 0, PatLocId As %String = "", OrdCatId As %String = "", ArcimId As %String = "", CurLocAdd As %String = "", MZPatDr As %String, InPatDr As %String, SelfFlag As %String, patientType = "") As %Status
{
	
	;s ^zlj("GetConOderExecute")=EpisodeID_","_PatRegNo_","_StartDate_","_EndDate_","_LocId_","_ExecFlage_","_PatLocId_","_OrdCatId_","_ArcimId_","_CurLocAdd_","_MZPatDr_","_InPatDr
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i LocId="" s LocId=%session.Data("LOGON.CTLOCID")
 	s userId="2864"
 	//s userId=%session.Data("LOGON.USERID")
 	//s ssGroup=%session.Data("LOGON.GROUPID")
 	//s ssgroupdesc=%session.Data("LOGON.GROUPDESC")
 	s OrdQtys=0,OrdCosts=0
 	k ^TmpNurOrderPrint(userId)
 	;s ^EH("GetConOder")=EpisodeID_"^"_PatRegNo_"^"_StartDate_"^"_EndDate_"^"_LocId_"^"_ExecFlage_"^"_PatLocId_"^"_OrdCatId_"^"_ArcimId_"^"_CurLocAdd_"^"_MZPatDr_"^"_InPatDr
 	i LocId=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	;b ;LocId
 	i StartDate=""  s StartDate=+$H
 	i EndDate=""    s EndDate=+$H
 	i ExecFlage="" s ExecFlage=0
 	s mradm="",Diagnosis=""
 	i StartDate>EndDate   Set qHandle=$lb(0,repid,0) Quit $$$OK
 	;b ;StartDate>EndDate 
 	i EpisodeID'="" s PatRegNo=##Class(web.DHCCLCom).GetRegNobyEpisodeID(EpisodeID)
 	;b ;EpisodeID
 	i PatRegNo'="" d
 	.s papmiId=""
 	.s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatRegNo),""))
 	.q:papmiId=""
 	.s medcareno=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
 	.s admTypes(1)="O",admTypes(2)="E",admTypes(3)="I",admTypes(4)="H"
 	.f indexAdmType=1:1:4 d
 	..s admId="" f  s admId=$o(^PAPERdr(papmiId,"ADM",admTypes(indexAdmType),admId),-1) q:(admId="")  d
 	...s pavisit=$p($g(^PAADM(admId)),"^",20)
 	...s admType=$p($G(^PAADM(admId)),"^",2)
 	...;b ;w pavisit_"\\"_admType,!
 	...
 	...;q:(pavisit'="A")&(admType="I")
 	...q:(MZPatDr="1")&(InPatDr="0")&(admType="I")
 	...q:(InPatDr="1")&(MZPatDr="0")&(admType'="I")
 	...
 	...//门诊O急诊E住院I
 	...q:("OEIH")'[admType
 	...//q:(ssGroup=271)&(LocId=170)&(admType'="I")   //update gsb 20110810
 	...//q:((ssGroup=258)!(ssGroup=200))&(LocId=170)&(admType="I")
 	...s ctlocId=$p(^PAADM(admId),"^",4)
 	...;w admId,!
 	...q:(PatLocId'="")&(PatLocId'=ctlocId)
 	...;b ;5555
 	...s OrderId=$O(^OEORD(0,"Adm",admId,""))
 	...q:OrderId=""
 	...s OrderSub=0
 	...f  s OrderSub=$O(^OEORD(OrderId,"I",OrderSub)) q:OrderSub=""  d
 	....w OrderId_"||"_OrderSub,!  ;64512,
 	....;i (OrderId=46894)&&(OrderSub=26) do
 	....;.b ;hh
 	....s SttDat=$p($g(^OEORD(OrderId,"I",OrderSub,1)),"^",9)   //OEORI_SttDat
    ....q:(SttDat<StartDate)!(SttDat>EndDate)
    ....s OrditmType=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",13)
 	....q:(OrditmType'="1")&(OrditmType'="6")   //update gsb 2012-11-22
    ....s Billed=$P($G(^OEORD(OrderId,"I",OrderSub,3)),"^",5)
    ....//q:(("OE")[admType)&(Billed'="P")  //门急诊未收费项目不显示
    ....;b ; w Billed_","_FeeFlage
    ....q:((FeeFlage="1")&(Billed'="P")) //查询已缴费医嘱
    ....q:((FeeFlage="0")&(Billed="P")) //查询未交费医嘱
 	....s recLocId=$P($G(^OEORD(OrderId,"I",OrderSub,3)),"^",6)
	....;w LocId_"\\"_recLocId,!
	....q:(LocId'="")&(recLocId'=LocId)
	....;b ;666
	....s addlocid=$p($G(^OEORD(OrderId,"I",OrderSub,7)),"^",2)
	....;q:(+CurLocAdd=0)&(addlocid=LocId)    //默认本科室开的医嘱不显示， update gsb 20120625
	....s arcItemRowId=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",2)
	....//q:(arcItemRowId="11183||1")  //病历手册
	....;b ; ArcimId_","_arcItemRowId
	....q:(ArcimId'="")&&(ArcimId'=arcItemRowId)
	....s arcCatRowId=$P($G(^ARCIM(+arcItemRowId,$P(arcItemRowId,"||",2),1)),"^",10)
	....;b ;arcCatRowId
	....q:(arcCatRowId="191")&(arcCatRowId="194")  //挂号费，诊疗费 //EH
	....q:(OrdCatId'="")&&(OrdCatId'=arcCatRowId)
	....//-------过滤不需要的医嘱分类----------------
	....s OrdCatDr=$P(^ARC("IC",arcCatRowId),"^",8)
	....s OrdCatDrStr="^"_OrdCatDr_"^"
	....;q:(^DHCNeedExeOrdCat'[OrdCatDrStr)
	....//-------------------------------------------
	....s flage=..GetFlage(OrderId,OrderSub,ExecFlage)
	....;w OrderId_"||"_OrderSub_"==>"_flage,!
	....q:flage=0
	....;s billed=$p(^OEORD(OrderId,"I",OrderSub,3),"^",5)
	....;i billed'="" s BillStatus=##class(web.DHCRisCommFunctionEx).GetBilledDesc(billed)
	....;//s billstr=##class(web.DHCRisWorkBenchDoEx).GetBillStatusStr(admId,OrderId,OrderSub)
	....;//s billed=$P(billstr,"^",1)
	....s billed=""
	....;//s BillStatus=$P(billstr,"^",2)
	....s OrdCost=0
	....s ExecCtcpDR=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",4)       // OEORI_UserExecuted
	....b ;//lgl+只看本人执行的
	....q:(SelfFlag="1")&&(userId'=ExecCtcpDR)&&(ExecCtcpDR'="")

	....;b ;777
	....d GetOrderConSingleFee(OrderId,OrderSub)
	....;b ;888
	....d OutputRowFee
	....;b ;999
	....;d GetOrderConSingle(OrderId,OrderSub)
	....;d OutputRow
 	e  d
	.f OrdDate=StartDate:1:EndDate d
	..s OrdTime=""
	..f  s OrdTime=$O(^OEORDi(0,"LocStDtTm",LocId,OrdDate,OrdTime)) q:OrdTime=""  d
	...s OrderId=0
	...f  s OrderId=$O(^OEORDi(0,"LocStDtTm",LocId,OrdDate,OrdTime,OrderId)) q:OrderId=""  d
	....s OrderSub=0
	....s admId=$P($G(^OEORD(OrderId)),"^",1)
	....q:admId=""
	....s papmiId=+^PAADM(admId)
	....q:papmiId=""
	....s medcareno=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	....s pavisit=$p($g(^PAADM(admId)),"^",20)
 	....s admType=$p($G(^PAADM(admId)),"^",2)
 	....;q:(pavisit'="A")&(admType="I")
 	....q:(MZPatDr="1")&(InPatDr="0")&(admType="I")
 	....q:(InPatDr="1")&(MZPatDr="0")&(admType'="I")
 	....//门诊O急诊E住院I
 	....q:("OEIH")'[admType
 	....//q:(ssGroup=271)&(LocId=170)&(admType'="I")   //update gsb 20110810
 	....//q:((ssGroup=258)!(ssGroup=200))&(LocId=170)&(admType="I")
 	....s ctlocId=$p(^PAADM(admId),"^",4)
 	....q:(PatLocId'="")&(PatLocId'=ctlocId)
	....f  s OrderSub=$O(^OEORDi(0,"LocStDtTm",LocId,OrdDate,OrdTime,OrderId,OrderSub)) q:OrderSub=""  d
	.....;w OrderId_"||"_OrderSub,!
	.....;b ;00
	.....s Billed=$P($G(^OEORD(OrderId,"I",OrderSub,3)),"^",5)
 	.....//q:(("OE")[admType)&(Billed'="P")  //门急诊未收费项目不显示
    .....q:((FeeFlage="1")&(Billed'="P")) //查询已缴费医嘱
    .....q:((FeeFlage="0")&(Billed="P")) //查询未交费医嘱
 	.....s OrditmType=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",13)
 	.....q:(OrditmType'="1")&(OrditmType'="6")   //update gsb 2012-11-22
	.....s arcItemRowId=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",2)
	.....//q:(arcItemRowId="11183||1")  //病历手册
	.....q:(ArcimId'="")&&(ArcimId'=arcItemRowId)
	.....s arcCatRowId=$P($G(^ARCIM(+arcItemRowId,$P(arcItemRowId,"||",2),1)),"^",10)
	.....q:(arcCatRowId="191")!(arcCatRowId="194") //挂号费，诊疗费
	.....q:(OrdCatId'="")&&(OrdCatId'=arcCatRowId)
	.....//-------过滤不需要的医嘱分类----------------
	.....s OrdCatDr=$P(^ARC("IC",arcCatRowId),"^",8)
	.....s OrdCatDrStr="^"_OrdCatDr_"^"
	.....;q:(^DHCNeedExeOrdCat'[OrdCatDrStr)
	.....//-------------------------------------------
	.....s addlocid=$p($G(^OEORD(OrderId,"I",OrderSub,7)),"^",2)
	.....;q:(+CurLocAdd=0)&(addlocid=LocId)    //默认本科室开的医嘱不显示， update gsb 20120625
	.....s flage=..GetFlage(OrderId,OrderSub,ExecFlage)
	.....;w OrderId_"||"_OrderSub_"==>"_flage,!
	.....q:flage=0
	.....;//s billstr=##class(web.DHCRisWorkBenchDoEx).GetBillStatusStr(admId,OrderId,OrderSub)
	.....;//s billed=$P(billstr,"^",1)
	.....s billed=""
	.....;//s BillStatus=$P(billstr,"^",2)
	.....s OrdCost=0
	.....s ExecCtcpDR=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",4)       // OEORI_UserExecuted
	.....//lgl+只看本人执行的
	.....q:(SelfFlag="1")&&(userId'=ExecCtcpDR)&&(ExecCtcpDR'="")
	.....;b ;777
	.....d GetOrderConSingleFee(OrderId,OrderSub)
	.....;b ;888
	.....d OutputRowFee
	.....;b ;999
	
 	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRowFee

	//'(常规心电||动态心电||脑电||肌电||动态血压)
	;quit:((ArcimDesc'["心电")&(ArcimDesc'["脑电")&(ArcimDesc'["肌电")&(ArcimDesc'["动态血压"))
	if ((patientType'="") & (patientType'=admType)) quit
    i admType="I"  s admType1="住院病人"
    i admType="O"  s admType1="门诊病人"
    i admType="E"  s admType1="急诊病人"
    i admType="H"  s admType1="体检病人"
    s mradm=$P(^PAADM(admId),"^",61)
    s AdmReason=$P(^PAADM(admId,1),"^",7)
    ;b ;AdmReason
    q:AdmReason=""
    s AdmReason=$p($G(^PAC("ADMREA",AdmReason)),"^",2)
	Set Diagnosis=##class(web.DHCAdmOrderTree).GetMRAdmDiagnosis(mradm)
	s ^TmpNurOrderPrint(userId,ind)=RegNo_"^"_PatName_"^"_BedCode_"^"_ArcimDesc_"^"_OeordId_"^"_OrdStatDesc_"^"_OrcatDesc_"^"_ExecDateTime_"^"_ExecCtcpDesc_"^"_CtcpDesc_"^"_RecLocDesc_"^"_OrdDateTime_"^"_AdmDep_"^"_notes_"^"_OrdUnitCost_"^"_$g(OrdQty)_"^"_$g(OrdCost)_"^"_$g(admId)_"^"_$g(medcareno)_"^"_billed_"^"_Diagnosis_"^"_FeeState_"^"_RptState
	s Data=$lb(RegNo,PatName,BedCode,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes,OrdUnitCost,OrdQty,OrdCost,admId,medcareno,BillStatus,billed,admType1,sex,wardid,age,Diagnosis,AdmReason,dobDate,FeeState,RptState)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
OutputRowFee2
	s ^TmpNurOrderPrint(userId,ind)=RegNo_"^"_PatName_"^"_BedCode_"^"_ArcimDesc_"^"_OeordId_"^"_OrdStatDesc_"^"_OrcatDesc_"^"_ExecDateTime_"^"_ExecCtcpDesc_"^"_CtcpDesc_"^"_RecLocDesc_"^"_OrdDateTime_"^"_AdmDep_"^"_notes_"^"_OrdUnitCost_"^"_$g(OrdQty)_"^"_$g(OrdCost)_"^"_$g(admId)_"^"_$g(medcareno)_"^"_billed_"^"_Diagnosis_"^"_FeeState_"^"_RptState
	s Data=$lb(RegNo,PatName,BedCode,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes,OrdUnitCost,OrdQty,OrdCost,admId,medcareno,BillStatus,billed,admType1,sex,wardid,age,Diagnosis,AdmReason,dobDate,FeeState,RptState)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q

GetOrderConSingleFee(OrderId,OrderSub)
	s (RegNo,PatName,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes,AdmReason,FeeState,RptState)=""
	s OeordId=OrderId_"||"_OrderSub
	s StudyNo="EKG||"_OeordId
	s ReportRowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,0))
	;w OrderId_"||"_OrderSub
	;b ;00
	i (ReportRowid'="") d
	.;b ;ReportRowid
	.s ReportInfo=^DHCRBStudy("Report",ReportRowid)
	.q:(ReportInfo="")
	.s ReportDR=$p(ReportInfo,"^",4)
	.q:(ReportDR="")
	.s ReportStatusDesc=^DHCRBCStatus("ReportStatus",ReportDR)
	.q:(ReportStatusDesc="")
	.s RptState=$p(ReportStatusDesc,"^",2)
	s AmdId=$P($G(^OEORD(OrderId)),"^",1)
	s papmiId=+^PAADM(AmdId)
    s RegNo=..GetRegNobyEpisodeID(AmdId)
    s PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
 	s sexid=$p(^PAPER(papmiId,"ALL"),"^",7)
	s sex=$p(^CT("SEX",sexid),"^",2)
	s curDate=$zd($h,3)
	s dobDate=$zd($p($g(^PAPER(papmiId,"ALL")),"^",6),3)
    s age=##class(web.DHCDTHealthCommon).GetAgeDesc(dobDate,curDate)
    s curWardId=$p($g(^PAADM(AmdId)),"^",70)
	s patward=$p($g(^PAADM(AmdId)),"^",70) 
	i patward'=""  d  s wardid=$p(^PAWARD(patward),"^",1)
	e  s wardid=""
    s bedId=$p($g(^PAADM(AmdId)),"^",73)
    s bedSub=$p(bedId,"||",2)
    s BedCode=""
    i bedSub'="" s BedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    s ctlocId=$p(^PAADM(AmdId),"^",4)
	s AdmDep=$p(^CTLOC(+ctlocId),"^",2)
	i $P(AdmDep,"-",2)'="" s AdmDep=$P(AdmDep,"-",2)
	s Billed=$P($G(^OEORD(OrderId,"I",OrderSub,3)),"^",5)
	s FeeState=Billed_"^未收费"
	i (Billed="P")  s FeeState="P^已收费"
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
	s ExecCtcpDR=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",4)       // OEORI_UserExecuted
	i ExecCtcpDR'="" s ExecCtcpDesc=$P($G(^SSU("SSUSR",ExecCtcpDR)),"^",2)
	e  s ExecCtcpDesc=""
	s CtcpDR=$P($G(^OEORD(OrderId,"I",OrderSub,7)),"^",1)         //OEORI_UserAdd
	i CtcpDR'="" s CtcpDesc=$P(^SSU("SSUSR",CtcpDR),"^",2)
	e  s CtcpDesc=""
	i (ExecDate="")!(ExecTime="")!(CtcpDesc="") d // EH 取最近一条执行记录
	.s ordStatSub="",fd=0 f  s ordStatSub=$O(^OEORD(OrderId,"I",OrderSub,"ST",ordStatSub),-1),fd=$i(fd) q:(ordStatSub="")!(fd>1)  d
	..s ordStatStr=^OEORD(OrderId,"I",OrderSub,"ST",ordStatSub)
	..q:$p(ordStatStr,"^",3)=""
	..i ($p(^OEC("OSTAT",$p(ordStatStr,"^",3)),"^",1)="E") d
	...s ExecDate=$p(ordStatStr,"^",1)
	...s ExecTime=$p(ordStatStr,"^",2)
	...s xUserId=$p(ordStatStr,"^",4)
	...q:'$d(^SSU("SSUSR",+xUserId)) // 报错
	...s xCtcpId=$p(^SSU("SSUSR",+xUserId),"^",14)
	...i xCtcpId'="" s ExecCtcpDesc=$p($g(^CTPCP(xCtcpId,1)),"^",2)
	...e  s ExecCtcpDesc=""
	s ExecDateTime=$zd(ExecDate,3)_"  "_$zt(ExecTime)
    i ExecDate="" s ExecDateTime=""
	//s ExecCtcpDR=$P(^OEORD(OrderId,"I",OrderSub,8),"^",12)    // OEORI_UserUpdate
                                        
	s RecLocDR=$P(^OEORD(OrderId,"I",OrderSub,3),"^",6)       //OEORI_RecDep_DR
	s RecLocDesc=$p(^CTLOC(RecLocDR),"^",2)
	i $P(RecLocDesc,"-",2)'="" s RecLocDesc=$P(RecLocDesc,"-",2)                                        
    s OrdDate1=$p($g(^OEORD(OrderId,"I",OrderSub,3)),"^",7)   //OEORI_Date
    s OrdTime1=$p($g(^OEORD(OrderId,"I",OrderSub,1)),"^",17)  //OEORI_TimeOrd
	s OrdDateTime=$zd(OrdDate1,3)_"  "_$zt(OrdTime1)
	i OrdStatDR=1 d
	.s ExecDateTime=""
	.s ExecCtcpDesc=""
    f rnum=1:1:$g(^OEORD(OrderId,"I",OrderSub,"DEP",0))  d    //OEORI_DepProcNotes
	.s notes=$g(notes)_$g(^OEORD(OrderId,"I",OrderSub,"DEP",rnum))
	s oeoriPrice=$p($g(^OEORD(OrderId,"I",OrderSub,3)),"^",25)
    s OrdUnitCost=+##CLASS(UDHCJFPRICE).GetOrderPrice("","",ArcimDR,OrdDate1,"","","",oeoriPrice)
	q:OrdUnitCost=0
	//s OrdUnitCost=$p($g(^OEORD(OrderId,"I",OrderSub,2)),"^",13)
	s OrdQty=$p($g(^OEORD(OrderId,"I",OrderSub,1)),"^",12)
	s OrdCost=OrdUnitCost*OrdQty
	s OrdQtys=OrdQtys+OrdQty
	s OrdCosts=OrdCosts+OrdCost
	
	q
}

/// d ##class(%ResultSet).RunQuery("web.DHCEkgGetConOrd","GetEkgOdrList","85","","65379","66053","","","","","","")
Query GetEkgOdrList(LocId As %String, PatRegNo As %String, StartDate As %String, EndDate As %String, examItemFilter As %String, ExecFlage As %String = 0, FeeFlage As %String = 0, patientType = "", examStateQ = "", rptState As %String) As %Query(ROWSPEC = "IsUrgent:%String,RegNo:%String,PatName:%String,BedCode:%String,ArcimDesc:%String,OeordId:%String,OrdStatDesc:%String,OrcatDesc:%String,ExecDateTime:%String,ExecCtcpDesc:%String,CtcpDesc:%String,RecLocDesc:%String,OrdDateTime:%String,AdmDep:%String,notes:%String,OrdUnitCost:%String,OrdQty:%String,OrdCost:%String,admId:%String,medcareno:%String,Billed:%String,admType:%String,sex:%String,wardid:%String,age:%String,Diagnosis:%String,AdmReason:%String,dobDate:%String,FeeState:%String,ExamState:%String")
{
}

ClassMethod GetEkgOdrListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConOderExecute ]
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

ClassMethod GetEkgOdrListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConOderExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetEkgOdrListExecute(ByRef qHandle As %Binary, LocId As %String, PatRegNo As %String, StartDate As %String, EndDate As %String, examItemFilter As %String, ExecFlage As %String = 0, FeeFlage As %String = 0, patientType = "", examStateQ = "", rptState As %String) As %Status
{
	s ^tmpDHCEKG("GetEkgOdrList","param")=LocId_","_PatRegNo_","_StartDate_","_EndDate_","_examItemFilter_","_ExecFlage_","_FeeFlage_","_patientType_","_examStateQ_","_rptState
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i LocId="" s LocId=%session.Data("LOGON.CTLOCID")
 	s userId="2864"
 	s OrdQtys=0,OrdCosts=0
 	k ^TmpNurOrderPrint(userId)
 	i LocId=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	;b ;LocId
 	i StartDate=""  s StartDate=+$H
 	i EndDate=""    s EndDate=+$H
 	;i ExecFlage="" s ExecFlage=0
 	s mradm="",Diagnosis=""
 	i StartDate>EndDate   Set qHandle=$lb(0,repid,0) Quit $$$OK
 	;b ;EpisodeID
 	i PatRegNo'="" d
 	.s papmiId=""
 	.s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatRegNo),""))
 	.q:papmiId=""
 	.s medcareno=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
 	.s admTypes(1)="O",admTypes(2)="E",admTypes(3)="I",admTypes(4)="H"
 	.f indexAdmType=1:1:4 d
 	..s admId="" f  s admId=$o(^PAPERdr(papmiId,"ADM",admTypes(indexAdmType),admId),-1) q:(admId="")  d
 	...s pavisit=$p($g(^PAADM(admId)),"^",20)
 	...s admType=$p($G(^PAADM(admId)),"^",2)
 	...//门诊O急诊E住院I
 	...q:("OEIH")'[admType
 	...s ctlocId=$p(^PAADM(admId),"^",4)
 	...s OrderId=$O(^OEORD(0,"Adm",admId,""))
 	...q:OrderId=""
 	...s OrderSub=0
 	...f  s OrderSub=$O(^OEORD(OrderId,"I",OrderSub)) q:OrderSub=""  d
 	....;w OrderId_"||"_OrderSub,! 
 	....s SttDat=$p($g(^OEORD(OrderId,"I",OrderSub,1)),"^",9)   //OEORI_SttDat
    ....q:(SttDat<StartDate)!(SttDat>EndDate)
    ....s OrditmType=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",13)
 	....q:(OrditmType'="1")&(OrditmType'="6")  
    ....s Billed=$P($G(^OEORD(OrderId,"I",OrderSub,3)),"^",5)
    ....q:((FeeFlage="1")&(Billed'="P")) //查询已缴费医嘱
    ....q:((FeeFlage="0")&(Billed="P")) //查询未交费医嘱
 	....s recLocId=$P($G(^OEORD(OrderId,"I",OrderSub,3)),"^",6)
	....q:(LocId'="")&(recLocId'=LocId)
	....;b ;666
	....s addlocid=$p($G(^OEORD(OrderId,"I",OrderSub,7)),"^",2)
	....s arcItemRowId=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",2)
	....s arcCatRowId=$P($G(^ARCIM(+arcItemRowId,$P(arcItemRowId,"||",2),1)),"^",10)
	....q:(arcCatRowId="191")&(arcCatRowId="194")  //挂号费，诊疗费 //EH
	....s OrdCatDr=$P(^ARC("IC",arcCatRowId),"^",8)
	....s OrdCatDrStr="^"_OrdCatDr_"^"
	....s flage=..GetFlage(OrderId,OrderSub,ExecFlage)
	....;w OrderId_"||"_OrderSub_"==>"_flage,!
	....q:flage=0
	....s billed=""
	....s OrdCost=0
	....s ExecCtcpDR=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",4)       // OEORI_UserExecuted
    ....s arcimid=$p(^OEORD(OrderId,"I",OrderSub,1),"^",2)
    ....s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2) ;医嘱名称
    ....q:(examItemFilter'="")&&(examItemFilter'[strOrderName)
    
    ....s OeordId=OrderId_"||"_OrderSub
	....s StudyNo="EKG||"_OeordId
	....s ReportInfo=""
	....s ReportDR=1
    ....s ReportRowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,0))
	....i (ReportRowid'="") d
	.....s ReportInfo=^DHCRBStudy("Report",ReportRowid)
	....i (ReportInfo'="") d
	.....s ReportDR=$p(ReportInfo,"^",4) 
    ....s ReportStatusDesc=^DHCRBCStatus("ReportStatus",ReportDR)
	....i (ReportStatusDesc'="") d
	.....s RptState=$p(ReportStatusDesc,"^",2)
    .....;s ^tmpDHCEKG("GetOrder",$zdt($h,3))=RptState_"  "_rptState
	.....q:((rptState'="")&&(RptState'=rptState))
    
	....d GetOrder(OrderId,OrderSub)
	....d OutputRowList
 	e  d
	.f OrdDate=StartDate:1:EndDate d
	..;f OrdDate=EndDate:-1:StartDate d
	..s OrdTime=""
	..f  s OrdTime=$O(^OEORDi(0,"LocStDtTm",LocId,OrdDate,OrdTime)) q:OrdTime=""  d
	...s OrderId=0
	...f  s OrderId=$O(^OEORDi(0,"LocStDtTm",LocId,OrdDate,OrdTime,OrderId)) q:OrderId=""  d
	....s OrderSub=0
	....s admId=$P($G(^OEORD(OrderId)),"^",1)
	....q:admId=""
	....s papmiId=+^PAADM(admId)
	....q:papmiId=""
	....s medcareno=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	....s pavisit=$p($g(^PAADM(admId)),"^",20)
 	....s admType=$p($G(^PAADM(admId)),"^",2)
 	....//门诊O急诊E住院I
 	....q:("OEIH")'[admType
 	....s ctlocId=$p(^PAADM(admId),"^",4)
	....f  s OrderSub=$O(^OEORDi(0,"LocStDtTm",LocId,OrdDate,OrdTime,OrderId,OrderSub)) q:OrderSub=""  d
	.....s Billed=$P($G(^OEORD(OrderId,"I",OrderSub,3)),"^",5)
 	.....q:((FeeFlage="1")&(Billed'="P")) //查询已缴费医嘱
    .....q:((FeeFlage="0")&(Billed="P")) //查询未交费医嘱
 	.....s OrditmType=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",13)
 	.....q:(OrditmType'="1")&(OrditmType'="6")   //update gsb 2012-11-22
	.....s arcItemRowId=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",2)
	.....s arcCatRowId=$P($G(^ARCIM(+arcItemRowId,$P(arcItemRowId,"||",2),1)),"^",10)
	.....q:(arcCatRowId="191")!(arcCatRowId="194") //挂号费，诊疗费
	.....//-------过滤不需要的医嘱分类----------------
	.....s OrdCatDr=$P(^ARC("IC",arcCatRowId),"^",8)
	.....s OrdCatDrStr="^"_OrdCatDr_"^"
	.....s addlocid=$p($G(^OEORD(OrderId,"I",OrderSub,7)),"^",2)
	.....s flage=..GetFlage(OrderId,OrderSub,ExecFlage)
	.....q:flage=0
	.....s billed=""
	.....s OrdCost=0
	.....s ExecCtcpDR=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",4)       // OEORI_UserExecuted
    .....s arcimid=$p(^OEORD(OrderId,"I",OrderSub,1),"^",2)
    .....s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2) ;医嘱名称
    .....q:(examItemFilter'="")&&(examItemFilter'[strOrderName)
    .....s ExamStateCode=""
    .....s OeordId=OrderId_"||"_OrderSub
	.....s ExamStateCode=##class(web.DHCEkgService).GetSystemStatus(OeordId)
	.....s ExamState="申请"
	.....if (ExamStateCode="CM") s ExamState="检查完成"
	.....else  if (ExamStateCode="RP") s ExamState="报告"
	.....else  if (ExamStateCode="SC") s ExamState="登记"
	.....else  if (ExamStateCode="CA") s ExamState="取消检查"
	.....else  if (ExamStateCode="AP") s ExamState="申请"
	.....else  if (ExamStateCode="RD") s ExamState="阅读"
	.....else  if (ExamStateCode'="") s ExamState=ExamStateCode
    .....q:(examStateQ'="")&&(examStateQ'=ExamState)
    
    .....s OeordId=OrderId_"||"_OrderSub
	.....s StudyNo="EKG||"_OeordId
	.....s ReportInfo=""
	.....s ReportDR=1
    .....s ReportRowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,0))
	.....i (ReportRowid'="") d
	......s ReportInfo=^DHCRBStudy("Report",ReportRowid)
	.....i (ReportInfo'="") d
	......s ReportDR=$p(ReportInfo,"^",4) 
    .....s ReportStatusDesc=^DHCRBCStatus("ReportStatus",ReportDR)
	.....i (ReportStatusDesc'="") d
	......s RptState=$p(ReportStatusDesc,"^",2)
    ......s ^tmpDHCEKG("GetOrder",$zdt($h,3))=RptState_"  "_rptState
	......q:((rptState'="")&&(RptState'=rptState))
    
	.....d GetOrder(OrderId,OrderSub)
	.....d OutputRowList	
 	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRowList
	if ((patientType'="") & (patientType'[admType)) quit
    i admType="I"  s admType1="住院病人"
    i admType="O"  s admType1="门诊病人"
    i admType="E"  s admType1="急诊病人"
    i admType="H"  s admType1="体检病人"
    s mradm=$P(^PAADM(admId),"^",61)
    s AdmReason=$P(^PAADM(admId,1),"^",7)
    ;b ;AdmReason
    i AdmReason'="" s AdmReason=$p($G(^PAC("ADMREA",AdmReason)),"^",2)
	Set Diagnosis=##class(web.DHCAdmOrderTree).GetMRAdmDiagnosis(mradm)
	s IsUrgent = $translate($g(IsUrgent),$c(0),"")
	s RegNo=$translate(RegNo,$c(0),"")
	s PatName=$translate(PatName,$c(0),"")
	s BedCode=$translate(BedCode,$c(0),"")
	s ArcimDesc=$translate(ArcimDesc,$c(0),"")
	s OeordId=$translate(OeordId,$c(0),"")
	s OrdStatDesc=$translate(OrdStatDesc,$c(0),"")
	s OrcatDesc=$translate(OrcatDesc,$c(0),"")
	s ExecDateTime=$translate(ExecDateTime,$c(0),"")
	s ExecCtcpDesc=$translate(ExecCtcpDesc,$c(0),"")
	s CtcpDesc=$translate(CtcpDesc,$c(0),"")
	s RecLocDesc=$translate(RecLocDesc,$c(0),"")
	s OrdDateTime=$translate(OrdDateTime,$c(0),"")
	s AdmDep=$translate(AdmDep,$c(0),"")
	s notes=$translate(notes,$c(0),"")
	s OrdUnitCost=$translate(OrdUnitCost,$c(0),"")
	s OrdQty=$translate($g(OrdQty),$c(0),"")
	s OrdCost=$translate(OrdCost,$c(0),"")
	s admId=$translate(admId,$c(0),"")
	s medcareno=$translate(medcareno,$c(0),"")
	s billed=$translate(billed,$c(0),"")
	s admType1=$translate(admType1,$c(0),"")
	s sex=$translate(sex,$c(0),"")
	s wardid=$translate(wardid,$c(0),"")
	s age=$translate(age,$c(0),"")
	;b ;2
	s Diagnosis=$translate(Diagnosis,$c(0),"")
	s AdmReason=$translate(AdmReason,$c(0),"")
	s dobDate=$translate(dobDate,$c(0),"")
	s FeeState=$translate(FeeState,$c(0),"")
	;s RptState=$translate(RptState,$c(0),"")
	s ExamState=$translate(ExamState,$c(0),"")
	s ^TmpNurOrderPrint(userId,ind)=IsUrgent_"^"_RegNo_"^"_PatName_"^"_BedCode_"^"_ArcimDesc_"^"_OeordId_"^"_OrdStatDesc_"^"_OrcatDesc_"^"_ExecDateTime_"^"_ExecCtcpDesc_"^"_CtcpDesc_"^"_RecLocDesc_"^"_OrdDateTime_"^"_AdmDep_"^"_notes_"^"_OrdUnitCost_"^"_$g(OrdQty)_"^"_$g(OrdCost)_"^"_$g(admId)_"^"_$g(medcareno)_"^"_billed_"^"_Diagnosis_"^"_FeeState_"^"_ExamState
	s Data=$lb(IsUrgent,RegNo,PatName,BedCode,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes,OrdUnitCost,OrdQty,OrdCost,admId,medcareno,billed,admType1,sex,wardid,age,Diagnosis,AdmReason,dobDate,FeeState,ExamState)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
GetOrder(OrderId,OrderSub)
	s (IsUrgent,RegNo,PatName,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes,AdmReason,FeeState,ExamState)=""
	s (IsUrgent,RegNo,PatName,BedCode,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes,OrdUnitCost,OrdQty,OrdCost,medcareno,billed,admType1,sex,wardid,age,Diagnosis,AdmReason,dobDate,FeeState,ExamState)=""
	s OeordId=OrderId_"||"_OrderSub
	s IsUrgent = ..GetUrgent(OeordId)
	;s IsUrgent=$case(IsUrgent,"Y":"急",:"")
	s StudyNo="EKG||"_OeordId
	/*s ReportRowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,0))
	s examStatus="A"   ;默认状态为申请
	s ReportDR=1 ;默认状态为未写报告
	i (ReportRowid'="") d
	.;b ;ReportRowid
	.s ReportInfo=^DHCRBStudy("Report",ReportRowid)
	.i (ReportInfo'="") d
	..s ReportDR=$p(ReportInfo,"^",4)
	..;q:(ReportDR="")
	s reginfoRowid=$o(^DHCPACRegInfoi("OEORI",OeordId,""))
	i (reginfoRowid'="") d
	.s examStatus="SC"  ;登记
	i (ReportRowid'="") d
	.s examStatus="RP"  ;已写报告
	.s StatusDR=$p(^DHCRBStudy("Report",ReportRowid),"^",4)
	.s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
	.i (StatusCode="S") d  ;发布后 检查完成
	..s examStatus="CM"
	s ExamState=..GetResultStatus(examStatus)
	s ReportStatusDesc=^DHCRBCStatus("ReportStatus",ReportDR)
	i (ReportStatusDesc'="") d
	.s RptState=$p(ReportStatusDesc,"^",2)*/	
	s ExamStateCode=""
	try{
		s ExamStateCode=##class(web.DHCEkgService).GetSystemStatus(OeordId)
	}
	catch
	{
	}
	s ExamState="申请"
	if (ExamStateCode="CM") s ExamState="检查完成"
	else  if (ExamStateCode="RP") s ExamState="报告"
	else  if (ExamStateCode="SC") s ExamState="登记"
	else  if (ExamStateCode="CA") s ExamState="取消检查"
	else  if (ExamStateCode="AP") s ExamState="申请"
	else  if (ExamStateCode="RD") s ExamState="阅读"
	else  if (ExamStateCode'="") s ExamState=ExamStateCode
	s AmdId=$P($G(^OEORD(OrderId)),"^",1)
	s papmiId=+^PAADM(AmdId)
    s RegNo=..GetRegNobyEpisodeID(AmdId)
    s PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
 	s sexid=$p(^PAPER(papmiId,"ALL"),"^",7)
	s sex=$p(^CT("SEX",sexid),"^",2)
	//住院号
	s medcareno=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	s curDate=$zd($h,3)
	s dobDate=$zd($p($g(^PAPER(papmiId,"ALL")),"^",6),3)
    s age=##class(web.DHCDTHealthCommon).GetAgeDesc(dobDate,curDate)
    s curWardId=$p($g(^PAADM(AmdId)),"^",70)
	s patward=$p($g(^PAADM(AmdId)),"^",70) 
	i patward'=""  d  s wardid=$p(^PAWARD(patward),"^",1)
	e  s wardid=""
    s bedId=$p($g(^PAADM(AmdId)),"^",73)
    s bedSub=$p(bedId,"||",2)
    s BedCode=""
    i bedSub'="" s BedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    s ctlocId=$p(^PAADM(AmdId),"^",4)
	s AdmDep=$p(^CTLOC(+ctlocId),"^",2)
	i $P(AdmDep,"-",2)'="" s AdmDep=$P(AdmDep,"-",2)
	s Billed=$P($G(^OEORD(OrderId,"I",OrderSub,3)),"^",5)
	//s FeeState=Billed_"^未收费"
	//i (Billed="P")  s FeeState="P^已收费"
	
	
    s ordStr=""
    i (admType="I") d ;住院病人
    .s OEOREExStDate=""
    .f  s OEOREExStDate=$o(^OEORDi(0,"OrdItem",OrderId,OrderSub,OEOREExStDate)) q:(OEOREExStDate="")  d
    ..s OEOREChildsub=""
    ..f  s OEOREChildsub=$o(^OEORDi(0,"OrdItem",OrderId,OrderSub,OEOREExStDate,OEOREChildsub)) q:(OEOREChildsub="")  d
    ...s exStr=OrderId_"||"_OrderSub_"||"_OEOREChildsub
    ...s ordStr=exStr
    ...;i (ordStr'="") s ordStr=ordStr_"^"_exStr
    ...;e  s ordStr=exStr
    e  d
    .s ordStr=OeordId
    ;s ^yyl(OeordId)=ordStr
	s FeeState=##class(web.DHCBillInterface).IGetOrdItmBilled(ordStr)
	//s FeeState=Billed_"^"_BilledDesc
	s ArcimDR=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",2)
	s ArcimSub=$P(ArcimDR,"||",1)
	s ArcimVer=$P(ArcimDR,"||",2)
	s ArcimDesc=$P(^ARCIM(ArcimSub,ArcimVer,1),"^",2)
	s OrcatDR=$P(^ARCIM(ArcimSub,ArcimVer,1),"^",10)
	s OrcatDesc=$P(^ARC("IC",OrcatDR),"^",2)	
	s OrdStatDR=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",13)
	i OrdStatDR'="" s OrdStatDesc=$P(^OEC("OSTAT",OrdStatDR),"^",2)
	e  s OrdStatDesc=""
	s ExecDate=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",2)   // OEORI_DateExecuted
	s ExecTime=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",3)   // OEORI_TimeExecuted
	s ExecCtcpDR=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",4)       // OEORI_UserExecuted
	i ExecCtcpDR'="" s ExecCtcpDesc=$P($G(^SSU("SSUSR",ExecCtcpDR)),"^",2)
	e  s ExecCtcpDesc=""
	s caredr=$p(^OEORD(OrderId,"I",OrderSub,1),"^",11) ;
    if caredr'="" d
    .s CtcpDesc=$p($g(^CTPCP(caredr,1)),"^",2)
    .i (($g(^DHCRisGetNameSet)="ID")&&($p($g(^CTPCP(caredr,1)),"^",3)'="")) s CtcpDesc=$p($g(^CTPCP(caredr,1)),"^",3)
	;s CtcpDR=$P($G(^OEORD(OrderId,"I",OrderSub,7)),"^",1)         //OEORI_UserAdd
	;i CtcpDR'="" s CtcpDesc=$P(^SSU("SSUSR",CtcpDR),"^",2)
	;e  s CtcpDesc=""
	i (ExecDate="")!(ExecTime="")!(CtcpDesc="") d // EH 取最近一条执行记录
	.s ordStatSub="",fd=0 f  s ordStatSub=$O(^OEORD(OrderId,"I",OrderSub,"ST",ordStatSub),-1),fd=$i(fd) q:(ordStatSub="")!(fd>1)  d
	..s ordStatStr=^OEORD(OrderId,"I",OrderSub,"ST",ordStatSub)
	..q:$p(ordStatStr,"^",3)=""
	..i ($p(^OEC("OSTAT",$p(ordStatStr,"^",3)),"^",1)="E") d
	...s ExecDate=$p(ordStatStr,"^",1)
	...s ExecTime=$p(ordStatStr,"^",2)
	...s xUserId=$p(ordStatStr,"^",4)
	...q:'$d(^SSU("SSUSR",+xUserId)) // 报错
	...s xCtcpId=$p(^SSU("SSUSR",+xUserId),"^",14)
	...i xCtcpId'="" s ExecCtcpDesc=$p($g(^CTPCP(xCtcpId,1)),"^",2)
	...e  s ExecCtcpDesc=""
	s ExecDateTime=$zd(ExecDate,3)_" "_$zt(ExecTime)
    i ExecDate="" s ExecDateTime=""
    
	s RecLocDR=$P(^OEORD(OrderId,"I",OrderSub,3),"^",6)       //OEORI_RecDep_DR
	s RecLocDesc=$p(^CTLOC(RecLocDR),"^",2)
	i $P(RecLocDesc,"-",2)'="" s RecLocDesc=$P(RecLocDesc,"-",2)                                        
    s OrdDate1=$p($g(^OEORD(OrderId,"I",OrderSub,3)),"^",7)   //OEORI_Date
    s OrdTime1=$p($g(^OEORD(OrderId,"I",OrderSub,1)),"^",17)  //OEORI_TimeOrd
	s OrdDateTime=$zd(OrdDate1,3)_"  "_$zt(OrdTime1)
	i OrdStatDR=1 d
	.s ExecDateTime=""
	.s ExecCtcpDesc=""
    f rnum=1:1:$g(^OEORD(OrderId,"I",OrderSub,"DEP",0))  d    //OEORI_DepProcNotes
	.s notes=$g(notes)_$g(^OEORD(OrderId,"I",OrderSub,"DEP",rnum))
	s oeoriPrice=$p($g(^OEORD(OrderId,"I",OrderSub,3)),"^",25)
    s OrdUnitCost=+##CLASS(UDHCJFPRICE).GetOrderPrice("","",ArcimDR,OrdDate1,"","","",oeoriPrice)
	q:OrdUnitCost=0
	s OrdQty=$p($g(^OEORD(OrderId,"I",OrderSub,1)),"^",12)
	s OrdCost=OrdUnitCost*OrdQty
	s OrdQtys=OrdQtys+OrdQty
	s OrdCosts=OrdCosts+OrdCost
	
	q
}

ClassMethod GetResultStatus(statusCode As %String) As %String
{
	q:(statusCode="") ""
	s StatusDesc=""
	&sql(SELECT RESST_Desc INTO :StatusDesc FROM OEC_ResultStatus WHERE RESST_Code=:statusCode)
	if (StatusDesc="Awaiting")  s StatusDesc="申请"
	q StatusDesc
}

ClassMethod GetRegNobyEpisodeID(EpisodeID)
{
 	//n (EpisodeID)
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
	//20101028不判断医嘱子类//i (OrcatType="N") s ret=1  //医嘱子类类型 C Consultation会诊//L检验子类类型//N检查医嘱子类类型//X其它的子类类型
	s ret=1
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
	.s ctlocType=$p(^CTLOC(ctlocId),"^",13)
	.q:ctlocType'="E"
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

/*ClassMethod OrdItmExecute(OrdIds As %String, UserId As %String, OrderStatus As %String, Notes As %String = "") As %String
{
	;s ^zlj("OrdItmExecute")=OrdIds_","_UserId_","_OrderStatus_","_Notes
	s ret=""
	i UserId="4973",OrdIds'="" s ^EH4973("4973","E",OrdIds)=""
	s orderId=+OrdIds
	s adm=+(^OEORD(orderId))
	s admType=$p(^PAADM(adm),"^",2)
	i admType="I" 
	{
		f k=1:1:$l(OrdIds,"^") d // EH 执行多条医嘱
		.s OrdRowId=$p(OrdIds,"^",k)
		.i '$l(OrdRowId) d
		..s ret=ret_"1"_"^"
		.e  d
		..s OrderId=$p(OrdRowId,"||",1)
		..s OrderSub=$p(OrdRowId,"||",2)
		..s curAdm=+(^OEORD(OrderId)) //there is problem in the outter section
		..s curAdmType=$p(^PAADM(curAdm),"^",2)
	    ..s Billed=$P($G(^OEORD(OrderId,"I",OrderSub,3)),"^",5)
   		..q:(("OE")[curAdmType)&(Billed'="P")  //门急诊未收费项目不显示
		..s rtemp=##class(appcom.OEOrdItem).Execute(OrdRowId,UserId)
		..;i rtemp=0 s rtemp=##class(appcom.OEOrdExec).UpdateStatus(OrdRowId_"||"_"1","F",UserId) // EH
		..;s rtemp=##class(appcom.OEOrdItem).ExecuteTempOrder(OrdRowId,UserId) // EH sign by nurse
		..i rtemp=0 s rtemp=##Class(web.UDHCJFBILL).BILLN(adm,UserId,"")
		..s ret=ret_rtemp_"^"
		i $l(ret) s ret=$p(ret,"^",1,$l(ret,"^")-1)
		//EH here if necessary is the work of accounting
		//s rtn=##Class(web.UDHCJFBILL).BILLN(adm,UserId,"")  //update gsb 2012-12-22
	}
	else
	{
		k PLIST
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
		..s OrderId=$p(OrdRowId,"||",1)
		..s OrderSub=$p(OrdRowId,"||",2)
		..s curAdm=+(^OEORD(OrderId)) //there is problem in the outter section
		..s curAdmType=$p(^PAADM(curAdm),"^",2)
	    ..s Billed=$P($G(^OEORD(OrderId,"I",OrderSub,3)),"^",5)
   		..q:(("OEH")[curAdmType)&(Billed'="P")  //门急诊未收费项目不显示
		..s PLIST(0)=OrdRowId
		..s PLIST(3)=UpdateDate
		..s PLIST(4)=UpdateTime
		..s PLIST(5)=OrdStatId
		..s PLIST(6)=UserId
		..&sql(Update OE_OrdItem set OEORI_DateExecuted=:UpdateDate,OEORI_TimeExecuted=:UpdateTime,OEORI_ItemStat_DR=:OrdStatId,OEORI_UserExecuted=:UserId where OEORI_RowId=:OrdRowId and OEORI_ItemStat_DR='1')
		..q:SQLCODE<0
		..i ($D(^OEORD($P(OrdRowId,"||"),"I",$P(OrdRowId,"||",2),"DEP",1))>0)&(Notes'="") d
		...s ^OEORD($P(OrdRowId,"||"),"I",$P(OrdRowId,"||",2),"DEP",1)=Notes
		..&sql(insert into oe_ordstatus values PLIST() )
		..i SQLCODE=0 d 
		...s rtemp=0
		..e  d 
		...s rtemp=1
		..s ret=ret_rtemp_"^"
		i $l(ret) s ret=$p(ret,"^",1,$l(ret,"^")-1)
	}
	q ret
}*/
ClassMethod GetLocDes(LocId) As %String
{
	q:LocId="" ""
	s CTLocDesc=$p(^CTLOC(LocId),"^",2)
	q CTLocDesc
}

ClassMethod UnDoExecOrd(OrdIds As %String, UserId As %String) As %String
{
	i UserId="4973",OrdIds'="" s ^EH4973("4973","C",OrdIds)=""
	s ret=""
	s UpdateDate=+$h
	s UpdateTime=$p($h,",",2)
	s OrdStatId="1"            //update gsb 20120625
	s orderId=+OrdIds
	s adm=+(^OEORD(orderId))
	s admType=$p(^PAADM(adm),"^",2)
	i admType="I"
	{
		//s ret=##class(appcom.OEOrdItem).Verify(OrdIds,UserId)
		f k=1:1:$l(OrdIds,"^") d // EH 执行多条医嘱
		.s OrdRowId=$p(OrdIds,"^",k)
		.i '$l(OrdRowId) d
		..s ret=ret_"1"_"^"
		.e  d
		..s rtemp=##class(appcom.OEOrdItem).Verify(OrdRowId,UserId)
		..;i rtemp=0 s rtemp=##class(appcom.OEOrdExec).UpdateStatus(OrdRowId_"||"_"1","C",UserId) // EH
		..;s rtemp=##class(appcom.OEOrdItem).VerifyTempOrder(OrdRowId,UserId)
		..s ret=ret_rtemp_"^"
		i $l(ret) s ret=$p(ret,"^",1,$l(ret,"^")-1)
	}
	else
	{
		k PLIST
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
	  	..&sql(Update OE_OrdItem set OEORI_DateExecuted=null,OEORI_TimeExecuted=null,OEORI_ItemStat_DR=:OrdStatId where OEORI_RowId=:OrdRowId and OEORI_ItemStat_DR='6')
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
  	}
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
	s ^TmpNurOrderPrint(userId,ind)=RegNo_"^"_PatName_"^"_BedCode_"^"_ArcimDesc_"^"_OeordId_"^"_OrdStatDesc_"^"_OrcatDesc_"^"_ExecDateTime_"^"_ExecCtcpDesc_"^"_CtcpDesc_"^"_RecLocDesc_"^"_OrdDateTime_"^"_AdmDep_"^"_notes_"^"_OrdUnitCost_"^"_$g(OrdQty)_"^"_OrdCost
	s Data=$lb(RegNo,PatName,BedCode,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes,OrdUnitCost,OrdQty,OrdCost)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow1
	s ^TmpNurOrderPrint(userId,ind)=RegNo_"^"_PatName_"^"_BedCode_"^"_ArcimDesc_"^"_OeordId_"^"_OrdStatDesc_"^"_OrcatDesc_"^"_ExecDateTime_"^"_ExecCtcpDesc_"^"_CtcpDesc_"^"_RecLocDesc_"^"_OrdDateTime_"^"_AdmDep_"^"_notes_"^"_OrdUnitCost_"^"_$g(OrdQty)_"^"_OrdCost
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
	s ExecDateTime=$zd(ExecDate,3)_"  "_$zt(ExecTime)
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
	s OrdDateTime=$zd(OrdDate1,3)_"  "_$zt(OrdTime1)
	i OrdStatDR=1 d
	.s ExecDateTime=""
	.s ExecCtcpDesc=""
    f rnum=1:1:$g(^OEORD(OrderId,"I",OrderSub,"DEP",0))  d    //OEORI_DepProcNotes
	.s notes=$g(notes)_$g(^OEORD(OrderId,"I",OrderSub,"DEP",rnum))
	s oeoriPrice=$p($g(^OEORD(OrderId,"I",OrderSub,3)),"^",25)
	s OrdQty=0,OrdUnitCost=0,OrdCost=0
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

/// d ##class(%ResultSet).RunQuery("web.DHCEkgGetConOrd","GetOrdList","","","64635","64635","85","内三科","1","","","","","","","","")
Query GetOrdList(EpisodeID As %String, PatRegNo As %String, StartDate As %String, EndDate As %String, LocId As %String, ZoneName As %String, ExecFlage As %String, PatLocId As %String, OrdCatId As %String, ArcimId As %String, CurLocAdd As %String, MZPatDr As %String, InPatDr As %String, SelfFlag As %String, patientType = "") As %Query(ROWSPEC = "RegNo:%String,PatName:%String,BedCode:%String,ArcimDesc:%String,OeordId:%String,OrdStatDesc:%String,OrcatDesc:%String,ExecDateTime:%String,ExecCtcpDesc:%String,CtcpDesc:%String,RecLocDesc:%String,OrdDateTime:%String,AdmDep:%String,notes:%String,OrdUnitCost:%String,OrdQty:%String,OrdCost:%String,admId:%String,medcareno:%String,BillStatus:%String,Billed:%String,admType:%String,sex:%String,wardid:%String,age:%String,Diagnosis:%String,AdmReason:%String,dobDate:%String")
{
}

ClassMethod GetOrdListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdListExecute ]
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

ClassMethod GetOrdListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdListExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetOrdListExecute(ByRef qHandle As %Binary, EpisodeID As %String, PatRegNo As %String, StartDate As %String, EndDate As %String, LocId As %String, ZoneName As %String, ExecFlage As %String = 0, PatLocId As %String = "", OrdCatId As %String = "", ArcimId As %String = "", CurLocAdd As %String = "", MZPatDr As %String, InPatDr As %String, SelfFlag As %String, patientType = "") As %Status
{
	s repid=$I(^CacheTemp)
 	i $g(ind)="" s ind=1
 	i LocId="" s LocId=%session.Data("LOGON.CTLOCID")
 	s userId="2864"
 	s OrdQtys=0,OrdCosts=0
 	k ^TmpNurOrderPrint(userId)
 	i LocId=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	i StartDate=""  s StartDate=+$H
 	i EndDate=""    s EndDate=+$H
 	i ExecFlage="" s ExecFlage=0
 	s mradm="",Diagnosis=""
 	i StartDate>EndDate   Set qHandle=$lb(0,repid,0) Quit $$$OK
 	i EpisodeID'="" s PatRegNo=##Class(web.DHCCLCom).GetRegNobyEpisodeID(EpisodeID)
 	i PatRegNo'="" d
 	.s papmiId=""
 	.s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatRegNo),""))
 	.q:papmiId=""
 	.s medcareno=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
 	.s admTypes(1)="O",admTypes(2)="E",admTypes(3)="I",admTypes(4)="H"
 	.f indexAdmType=1:1:4 d
 	..s admId="" f  s admId=$o(^PAPERdr(papmiId,"ADM",admTypes(indexAdmType),admId),-1) q:(admId="")  d
	...s patward=$p($g(^PAADM(admId)),"^",70) 
	...q:((ZoneName'="")&&(patward=""))
	...s wardid=""
	...i (patward'="") s wardid=$p(^PAWARD(patward),"^",1)
    ...q:((ZoneName'="")&&(wardid'=ZoneName))
 	...s pavisit=$p($g(^PAADM(admId)),"^",20)
 	...s admType=$p($G(^PAADM(admId)),"^",2)
 	...q:(pavisit'="A")&(admType="I") ;pavisit="D"为出院
 	...q:(MZPatDr="1")&(InPatDr="0")&(admType="I")
 	...q:(InPatDr="1")&(MZPatDr="0")&(admType'="I")
 	...//门诊O急诊E住院I
 	...q:("OEIH")'[admType
 	...s ctlocId=$p(^PAADM(admId),"^",4)
 	...q:(PatLocId'="")&(PatLocId'=ctlocId)
 	...s OrderId=$O(^OEORD(0,"Adm",admId,""))
 	...q:OrderId=""
 	...s OrderSub=0
 	...f  s OrderSub=$O(^OEORD(OrderId,"I",OrderSub)) q:OrderSub=""  d
 	....s SttDat=$p($g(^OEORD(OrderId,"I",OrderSub,1)),"^",9)   //OEORI_SttDat
    ....q:(SttDat<StartDate)!(SttDat>EndDate)
    ....s OrditmType=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",13)
 	....q:(OrditmType'="1")&(OrditmType'="6")   //update gsb 2012-11-22
 	....s recLocId=$P($G(^OEORD(OrderId,"I",OrderSub,3)),"^",6)
	....q:(LocId'="")&(recLocId'=LocId)
	....s addlocid=$p($G(^OEORD(OrderId,"I",OrderSub,7)),"^",2)
	....s arcItemRowId=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",2)
	....q:(ArcimId'="")&&(ArcimId'=arcItemRowId)
	....s arcCatRowId=$P($G(^ARCIM(+arcItemRowId,$P(arcItemRowId,"||",2),1)),"^",10)
	....q:(arcCatRowId="191")&(arcCatRowId="194")  //挂号费，诊疗费 //EH
	....q:(OrdCatId'="")&&(OrdCatId'=arcCatRowId)
	....//-------过滤不需要的医嘱分类----------------
	....s OrdCatDr=$P(^ARC("IC",arcCatRowId),"^",8)
	....s OrdCatDrStr="^"_OrdCatDr_"^"
	....//-------------------------------------------
	....s flage=..GetFlage(OrderId,OrderSub,ExecFlage)
	....q:flage=0
	....s billed=""
	....s OrdCost=0
	....s ExecCtcpDR=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",4)       // OEORI_UserExecuted
	....q:(SelfFlag="1")&&(userId'=ExecCtcpDR)&&(ExecCtcpDR'="")
	....d GetOrdInfo(OrderId,OrderSub)
	....d RecordRow
 	e  d
	.f OrdDate=StartDate:1:EndDate d
	..s OrdTime=""
	..f  s OrdTime=$O(^OEORDi(0,"LocStDtTm",LocId,OrdDate,OrdTime)) q:OrdTime=""  d
	...s OrderId=0
	...f  s OrderId=$O(^OEORDi(0,"LocStDtTm",LocId,OrdDate,OrdTime,OrderId)) q:OrderId=""  d
	....s OrderSub=0
	....s admId=$P($G(^OEORD(OrderId)),"^",1)
	....q:admId=""
	....s patward=$p($g(^PAADM(admId)),"^",70) 
	....q:((ZoneName'="")&&(patward=""))
	....s wardid=""
	....i (patward'="") s wardid=$p(^PAWARD(patward),"^",1)
    ....q:((ZoneName'="")&&(wardid'=ZoneName))
	....s papmiId=+^PAADM(admId)
	....q:papmiId=""
	....s medcareno=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	....s pavisit=$p($g(^PAADM(admId)),"^",20)
 	....s admType=$p($G(^PAADM(admId)),"^",2)
 	....q:(pavisit'="A")&(admType="I")
 	....q:(MZPatDr="1")&(InPatDr="0")&(admType="I")
 	....q:(InPatDr="1")&(MZPatDr="0")&(admType'="I")
 	....//门诊O急诊E住院I体检H
 	....q:("OEIH")'[admType
 	....s ctlocId=$p(^PAADM(admId),"^",4)
 	....q:(PatLocId'="")&(PatLocId'=ctlocId)
	....f  s OrderSub=$O(^OEORDi(0,"LocStDtTm",LocId,OrdDate,OrdTime,OrderId,OrderSub)) q:OrderSub=""  d
	.....s OrditmType=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",13)
 	.....q:(OrditmType'="1")&(OrditmType'="6")   //update gsb 2012-11-22
	.....s arcItemRowId=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",2)
	.....q:(ArcimId'="")&&(ArcimId'=arcItemRowId)
	.....s arcCatRowId=$P($G(^ARCIM(+arcItemRowId,$P(arcItemRowId,"||",2),1)),"^",10)
	.....q:(arcCatRowId="191")!(arcCatRowId="194") //挂号费，诊疗费
	.....q:(OrdCatId'="")&&(OrdCatId'=arcCatRowId)
	.....//-------过滤不需要的医嘱分类----------------
	.....s OrdCatDr=$P(^ARC("IC",arcCatRowId),"^",8)
	.....s OrdCatDrStr="^"_OrdCatDr_"^"
	.....s addlocid=$p($G(^OEORD(OrderId,"I",OrderSub,7)),"^",2)
	.....s flage=..GetFlage(OrderId,OrderSub,ExecFlage)
	.....q:flage=0
	.....s billed=""
	.....s OrdCost=0
	.....s ExecCtcpDR=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",4)       // OEORI_UserExecuted
	.....//lgl+只看本人执行的
	.....q:(SelfFlag="1")&&(userId'=ExecCtcpDR)&&(ExecCtcpDR'="")

	.....d GetOrdInfo(OrderId,OrderSub)
	.....d RecordRow
	
 	s qHandle=$lb(0,repid,0)
	q $$$OK
	
RecordRow
	if ((patientType'="") & (patientType'=admType)) quit
    i admType="I"  s admType1="住院病人"
    i admType="O"  s admType1="门诊病人"
    i admType="E"  s admType1="急诊病人"
    i admType="H"  s admType1="体检病人"
    s mradm=$P(^PAADM(admId),"^",61)
    s AdmReason=$P(^PAADM(admId,1),"^",7)
    q:AdmReason=""
    s AdmReason=$p($G(^PAC("ADMREA",AdmReason)),"^",2)
	Set Diagnosis=##class(web.DHCAdmOrderTree).GetMRAdmDiagnosis(mradm)
	s ^TmpNurOrderPrint(userId,ind)=RegNo_"^"_PatName_"^"_BedCode_"^"_ArcimDesc_"^"_OeordId_"^"_OrdStatDesc_"^"_OrcatDesc_"^"_ExecDateTime_"^"_ExecCtcpDesc_"^"_CtcpDesc_"^"_RecLocDesc_"^"_OrdDateTime_"^"_AdmDep_"^"_notes_"^"_OrdUnitCost_"^"_$g(OrdQty)_"^"_$g(OrdCost)_"^"_$g(admId)_"^"_$g(medcareno)_"^"_billed_"^"_Diagnosis_"^"_FeeState_"^"_PatState_"^"_RptState
	s Data=$lb(RegNo,PatName,BedCode,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes,OrdUnitCost,OrdQty,OrdCost,admId,medcareno,BillStatus,billed,admType1,sex,wardid,age,Diagnosis,AdmReason,dobDate,FeeState,PatState,RptState)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q

GetOrdInfo(OrderId,OrderSub)
	s (RegNo,PatName,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes,AdmReason)=""
	S OeordId=OrderId_"||"_OrderSub
	s AmdId=$P($G(^OEORD(OrderId)),"^",1)
	s papmiId=+^PAADM(AmdId)
    s RegNo=..GetRegNobyEpisodeID(AmdId)
    s PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
 	s sexid=$p(^PAPER(papmiId,"ALL"),"^",7)
	s sex=$p(^CT("SEX",sexid),"^",2)
	s curDate=$zd($h,3)
	s dobDate=$zd($p($g(^PAPER(papmiId,"ALL")),"^",6),3)
    s age=##class(web.DHCDTHealthCommon).GetAgeDesc(dobDate,curDate)
    s curWardId=$p($g(^PAADM(AmdId)),"^",70)
	s patward=$p($g(^PAADM(AmdId)),"^",70) 
	i patward'=""  d  s wardid=$p(^PAWARD(patward),"^",1)
	e  s wardid=""
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
	s ExecDate=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",2)   // OEORI_DateExecuted
	s ExecTime=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",3)   // OEORI_TimeExecuted
	s ExecCtcpDR=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",4)       // OEORI_UserExecuted
	i ExecCtcpDR'="" s ExecCtcpDesc=$P($G(^SSU("SSUSR",ExecCtcpDR)),"^",2)
	e  s ExecCtcpDesc=""
	s CtcpDR=$P($G(^OEORD(OrderId,"I",OrderSub,7)),"^",1)         //OEORI_UserAdd
	i CtcpDR'="" s CtcpDesc=$P(^SSU("SSUSR",CtcpDR),"^",2)
	e  s CtcpDesc=""
	i (ExecDate="")!(ExecTime="")!(CtcpDesc="") d // EH 取最近一条执行记录
	.s ordStatSub="",fd=0 f  s ordStatSub=$O(^OEORD(OrderId,"I",OrderSub,"ST",ordStatSub),-1),fd=$i(fd) q:(ordStatSub="")!(fd>1)  d
	..s ordStatStr=^OEORD(OrderId,"I",OrderSub,"ST",ordStatSub)
	..q:$p(ordStatStr,"^",3)=""
	..i ($p(^OEC("OSTAT",$p(ordStatStr,"^",3)),"^",1)="E") d
	...s ExecDate=$p(ordStatStr,"^",1)
	...s ExecTime=$p(ordStatStr,"^",2)
	...s xUserId=$p(ordStatStr,"^",4)
	...q:'$d(^SSU("SSUSR",+xUserId)) // 报错
	...s xCtcpId=$p(^SSU("SSUSR",+xUserId),"^",14)
	...i xCtcpId'="" s ExecCtcpDesc=$p($g(^CTPCP(xCtcpId,1)),"^",2)
	...e  s ExecCtcpDesc=""
	s ExecDateTime=$zd(ExecDate,3)_"  "_$zt(ExecTime)
    i ExecDate="" s ExecDateTime=""
                                        
	s RecLocDR=$P(^OEORD(OrderId,"I",OrderSub,3),"^",6)       //OEORI_RecDep_DR
	s RecLocDesc=$p(^CTLOC(RecLocDR),"^",2)
	i $P(RecLocDesc,"-",2)'="" s RecLocDesc=$P(RecLocDesc,"-",2)                                        
    s OrdDate1=$p($g(^OEORD(OrderId,"I",OrderSub,3)),"^",7)   //OEORI_Date
    s OrdTime1=$p($g(^OEORD(OrderId,"I",OrderSub,1)),"^",17)  //OEORI_TimeOrd
	s OrdDateTime=$zd(OrdDate1,3)_"  "_$zt(OrdTime1)
	i OrdStatDR=1 d
	.s ExecDateTime=""
	.s ExecCtcpDesc=""
    f rnum=1:1:$g(^OEORD(OrderId,"I",OrderSub,"DEP",0))  d    //OEORI_DepProcNotes
	.s notes=$g(notes)_$g(^OEORD(OrderId,"I",OrderSub,"DEP",rnum))
	s oeoriPrice=$p($g(^OEORD(OrderId,"I",OrderSub,3)),"^",25)
    s OrdUnitCost=+##CLASS(UDHCJFPRICE).GetOrderPrice("","",ArcimDR,OrdDate1,"","","",oeoriPrice)
	q:OrdUnitCost=0
	s OrdQty=$p($g(^OEORD(OrderId,"I",OrderSub,1)),"^",12)
	s OrdCost=OrdUnitCost*OrdQty
	s OrdQtys=OrdQtys+OrdQty
	s OrdCosts=OrdCosts+OrdCost
	
	q
}

/// d ##class(%ResultSet).RunQuery("web.DHCEkgGetConOrd","GetRegOrdList","功能检查科心电图^^^^^2022-10-31^2022-10-31^————;常规心电图检查(12导联);心电图阿托品试验;心电图心得安试验;频谱心电图检查;常规心电图检查(18导联);ecg exam;Procedure: Balke Protocol;Procedure: Ramp Protocol;Resting ECG;Diagnostic ECG ;Scanned Document Import;XRay: Ankle;US Procedure 2;心电图平板运动试验")
/// 入参：		LocCode^PatRegNo^PatInCode^CardNo^PatName^StdDate^EndDate
/// 			接收科室Code^登记号^住院号^卡号^姓名^开始日期^结束日期
Query GetRegOrdList(params As %String) As %Query(ROWSPEC = "RegNo:%String,PatName:%String,BedCode:%String,ArcimDesc:%String,OeordId:%String,OrdStatDesc:%String,OrcatDesc:%String,ExecDateTime:%String,ExecCtcpDesc:%String,CtcpDesc:%String,RecLocDesc:%String,OrdDateTime:%String,AdmDep:%String,notes:%String,OrdUnitCost:%String,OrdQty:%String,OrdCost:%String,admId:%String,medcareno:%String,Billed:%String,admType:%String,sex:%String,wardid:%String,age:%String,Diagnosis:%String,AdmReason:%String,dobDate:%String,FeeState:%String,ExamState:%String,RegisterTime:%String,RegisterUserId:%String,RegisterUserName:%String")
{
}

ClassMethod GetRegOrdListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConOderExecute ]
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

ClassMethod GetRegOrdListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConOderExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetRegOrdListExecute(ByRef qHandle As %Binary, params As %String) As %Status
{
	s ^tmpDHCEKG("GetRegOrdListExecute")=params
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s OrdQtys=0,OrdCosts=0
 	s userId="2864"
 	
 	s paramLocCode=$p(params,"^",1)
 	s paramPatRegNo=$p(params,"^",2)
 	s paramPatInCode=$p(params,"^",3)
 	s paramCardNo=$p(params,"^",4)
 	s paramPatName=$p(params,"^",5)
 	s paramStdDate=$p(params,"^",6)
 	s paramEndDate=$p(params,"^",7)
 	s examItemFilter=$p(params,"^",8)
 	
 	i paramStdDate["-" s paramStdDate=$zdh(paramStdDate,3)
	i paramEndDate["-" s paramEndDate=$zdh(paramEndDate,3)
	
	i paramStdDate["/" d
	.s paramStdDate=$replace(paramStdDate,"/","-") 
	.s paramStdDate=$zdh(paramStdDate,3)	
	i paramEndDate["/" d
	.s paramEndDate=$replace(paramEndDate,"/","-")
	.s paramEndDate=$zdh(paramEndDate,3)
	i (paramPatRegNo="")&&(paramPatInCode="")&&(paramCardNo'="") d ;无登记号和住院号，通过卡号获取登记号
	.s paramPatRegNo=##Class(web.DHCEkgNo).getRegNoByCardNo(paramCardNo)
	
	new $namespace
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	
	s examId="" 
	
	f  s examId=$o(^dbo.tblExaminationD(examId)) q:examId=""  d
	.s (examInfo,reqId,reqInfo,patId,ekgPatInCode,ekgPatCode,ekgName,registerTime,OeordId,ekgExeDeptCode)=""
	.s examInfo=$g(^dbo.tblExaminationD(examId)) //获取到examination表的信息
	.q:(examInfo="")
	.s registerTime=$listget(examInfo,42,"")
	.q:(registerTime="")
	.s registerDate=$zdh($p(registerTime," ",1),3)
	.i (examId=563) b ; w registerDate
	.q:((registerDate>paramEndDate)!(registerDate<paramStdDate))
	.s ekgStatusCode=+$listget(examInfo,20,"")
	.i (examId=563) b ; w ekgStatusCode
	.q:(ekgStatusCode>24)!(ekgStatusCode<10)
	.;b ; w ekgStatusCode
	.s reqId=$listget(examInfo,19,"")
	.q:(reqId="")
	.s reqInfo=$g(^dbo.tblRequestD(reqId))
	.q:(reqInfo="")
	.s ekgExeDeptCode=$listget(reqInfo,2,"")
	.i (examId=563) b ; w ekgExeDeptCode
	.q:((paramLocCode'="")&&(ekgExeDeptCode'=paramLocCode)) //如果ExecDeptCode不为空，且不相等的话，退出
	
	.//医嘱过滤
	.set examItemCode=$listget(reqInfo,11,"")
	.i (examId=563) b ; w examItemCode
	.quit:(examItemCode="")
	.set examItemCode=$zcvt(examItemCode,"u")
	.set examItemId=$o(^dbo.tblDictExamItemI("idxExamItemCode"," "_examItemCode,""))
	.quit:(examItemId="")
	.set examItemName=$listget($g(^dbo.tblDictExamItemD(examItemId)),6,"")
	.i (examId=563) b ; w examItemName
	.quit:((examItemFilter'="")&&(examItemFilter'[examItemName))
	
	.s patId=$li(reqInfo,16)
	.q:((patId="")!(patId="0"))
	.s patInfo=$g(^dbo.tblPatientD(patId))
	.q:(patInfo="")
	.s ekgPatCode=$listget(patInfo,20,"")
	.s ekgPatInCode=$listget(patInfo,11,"")
	.s ekgName=$listget(patInfo,16,"")
	.;q:(ekgPatCode="")!(ekgName="")
	.q:(paramPatRegNo'="")&&(ekgPatCode'[paramPatRegNo)
	.q:(paramPatInCode'="")&&(ekgPatInCode'[paramPatInCode)
	.q:(paramPatName'="")&&(ekgName'[paramPatName)
	.s OeordId=$listget(reqInfo,6,"")
	.i (OeordId="699||146") b ;699||146
	.q:((OeordId="")!(OeordId'["||"))
	.s OrderId=$p(OeordId,"||",1)
	.s OrderSub=$p(OeordId,"||",2)	
	.zn "dhc-app"
	.s hisOrdInfo=$G(^OEORD(OrderId,"I",OrderSub,1))
	.d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	.q:(hisOrdInfo="")
	.d GetRegOrder(OrderId,OrderSub)
	.d OutputRegRowList
	zn "dhc-app"
 	s qHandle=$lb(0,repid,0)
	q $$$OK
	

OutputRegRowList
	new $namespace
	zn "dhc-app"
	
    i admType="I"  s admType1="住院病人"
    i admType="O"  s admType1="门诊病人"
    i admType="E"  s admType1="急诊病人"
    i admType="H"  s admType1="体检病人"
    s mradm=$P(^PAADM(AmdId),"^",61)
    s AdmReason=$P(^PAADM(AmdId,1),"^",7)
    
    i AdmReason'="" d
    .s AdmReason=$p($G(^PAC("ADMREA",AdmReason)),"^",2)
	Set Diagnosis=##class(web.DHCAdmOrderTree).GetMRAdmDiagnosis(mradm)
	s RegNo=$translate(RegNo,$c(0),"")
	s PatName=$translate(PatName,$c(0),"")
	s BedCode=$translate(BedCode,$c(0),"")
	s ArcimDesc=$translate(ArcimDesc,$c(0),"")
	s OeordId=$translate(OeordId,$c(0),"")
	s OrdStatDesc=$translate(OrdStatDesc,$c(0),"")
	s OrcatDesc=$translate(OrcatDesc,$c(0),"")
	s ExecDateTime=$translate(ExecDateTime,$c(0),"")
	s ExecCtcpDesc=$translate(ExecCtcpDesc,$c(0),"")
	s CtcpDesc=$translate(CtcpDesc,$c(0),"")
	s RecLocDesc=$translate(RecLocDesc,$c(0),"")
	s OrdDateTime=$translate(OrdDateTime,$c(0),"")
	s AdmDep=$translate(AdmDep,$c(0),"")
	s notes=$translate(notes,$c(0),"")
	s OrdUnitCost=$translate(OrdUnitCost,$c(0),"")
	s OrdQty=$translate(OrdQty,$c(0),"")
	s OrdCost=$translate(OrdCost,$c(0),"")
	s AmdId=$translate(AmdId,$c(0),"")
	s medcareno=$translate(medcareno,$c(0),"")
	s billed=$translate(billed,$c(0),"")
	s admType1=$translate(admType1,$c(0),"")
	s sex=$translate(sex,$c(0),"")
	s wardid=$translate(wardid,$c(0),"")
	s age=$translate(age,$c(0),"")
	s Diagnosis=$translate(Diagnosis,$c(0),"")
	s AdmReason=$translate(AdmReason,$c(0),"")
	s dobDate=$translate(dobDate,$c(0),"")
	s FeeState=$translate(FeeState,$c(0),"")
	;s RptState=$translate(RptState,$c(0),"")
	s ExamState=$translate(ExamState,$c(0),"")
	s RegisterTime=$translate(RegisterTime,$c(0),"")
	s RegisterUserId=$translate(RegisterUserId,$c(0),"")
	s RegisterUserName=$translate(RegisterUserName,$c(0),"")
	
	
	s ^TmpNurOrderPrint(userId,ind)=RegNo_"^"_PatName_"^"_BedCode_"^"_ArcimDesc_"^"_OeordId_"^"_OrdStatDesc_"^"_OrcatDesc_"^"_ExecDateTime_"^"_ExecCtcpDesc_"^"_CtcpDesc_"^"_RecLocDesc_"^"_OrdDateTime_"^"_AdmDep_"^"_notes_"^"_OrdUnitCost_"^"_$g(OrdQty)_"^"_$g(OrdCost)_"^"_$g(AmdId)_"^"_$g(medcareno)_"^"_billed_"^"_Diagnosis_"^"_FeeState_"^"_ExamState_"^"_RegisterTime_"^"_RegisterUserId_"^"_RegisterUserName
	s Data=$lb(RegNo,PatName,BedCode,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes,OrdUnitCost,OrdQty,OrdCost,AmdId,medcareno,billed,admType1,sex,wardid,age,Diagnosis,AdmReason,dobDate,FeeState,ExamState,RegisterTime,RegisterUserId,RegisterUserName)
 	;b ; w Data
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
GetRegOrder(OrderId,OrderSub)
	new $namespace
	zn "dhc-app"
	s (RegNo,PatName,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes,OrdUnitCost,OrdQty,OrdCost,AmdId,medcareno,billed,admType1,sex,wardid,age,Diagnosis,AdmReason,FeeState,ExamState,RegisterTime,RegisterUserId,RegisterUserName)=""
	s OeordId=OrderId_"||"_OrderSub
	b ; w OeordId
	s StudyNo="EKG||"_OeordId
	;s ReportRowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,0))
	;s examStatus="A"   ;默认状态为申请
	;s ReportDR=1 ;默认状态为未写报告
	;i (ReportRowid'="") d
	;.s ReportInfo=^DHCRBStudy("Report",ReportRowid)
	;.i (ReportInfo'="") d
	;..s ReportDR=$p(ReportInfo,"^",4)
	;s reginfoRowid=$o(^DHCPACRegInfoi("OEORI",OeordId,""))
	;;i (reginfoRowid'="") d
	;.s examStatus="SC"  ;登记
	;i (ReportRowid'="") d
	;.s examStatus="RP"  ;已写报告
	;.s StatusDR=$p(^DHCRBStudy("Report",ReportRowid),"^",4)
	;.s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
	;.i (StatusCode="S") d  ;发布后 检查完成
	;..s examStatus="CM"
	s ExamStateCode=""
	try{
		s ExamStateCode=##class(web.DHCEkgService).GetSystemStatus(OeordId)
	}
	catch
	{
	}
	if (ExamStateCode="CM") s ExamState="检查完成"
	else  if (ExamStateCode="RP") s ExamState="报告"
	else  if (ExamStateCode="SC") s ExamState="登记"
	else  if (ExamStateCode="CA") s ExamState="取消检查"
	else  if (ExamStateCode="AP") s ExamState="申请"
	else  if (ExamStateCode="RD") s ExamState="阅读"
	else  if (ExamStateCode'="") s ExamState=ExamStateCode
	s AmdId=$P($G(^OEORD(OrderId)),"^",1)
	;s ReportStatusDesc=^DHCRBCStatus("ReportStatus",ReportDR)
	;i (ReportStatusDesc'="") d
	;.s RptState=$p(ReportStatusDesc,"^",2)	
	s AmdId=$P($G(^OEORD(OrderId)),"^",1)
 	s admType=$p($G(^PAADM(AmdId)),"^",2)
	s papmiId=+^PAADM(AmdId)
    s RegNo=..GetRegNobyEpisodeID(AmdId)
    s PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
 	s sexid=$p(^PAPER(papmiId,"ALL"),"^",7)
	s sex=$p(^CT("SEX",sexid),"^",2)
	s curDate=$zd($h,3)
	s dobDate=$zd($p($g(^PAPER(papmiId,"ALL")),"^",6),3)
    s age=##class(web.DHCDTHealthCommon).GetAgeDesc(dobDate,curDate)
    s curWardId=$p($g(^PAADM(AmdId)),"^",70)
	s patward=$p($g(^PAADM(AmdId)),"^",70) 
	i patward'=""  d  s wardid=$p(^PAWARD(patward),"^",1)
	e  s wardid=""
    s bedId=$p($g(^PAADM(AmdId)),"^",73)
    s bedSub=$p(bedId,"||",2)
    s BedCode=""
    i bedSub'="" s BedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    s ctlocId=$p(^PAADM(AmdId),"^",4)
	s AdmDep=$p(^CTLOC(+ctlocId),"^",2)
	i $P(AdmDep,"-",2)'="" s AdmDep=$P(AdmDep,"-",2)
	s Billed=$P($G(^OEORD(OrderId,"I",OrderSub,3)),"^",5)
	s FeeState=Billed_"^未收费"
	i (Billed="P")  s FeeState="P^已收费"
	s ArcimDR=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",2)
	i (ArcimDR'="") d
	.s ArcimSub=$P(ArcimDR,"||",1)
	.s ArcimVer=$P(ArcimDR,"||",2)
	.s ArcimDesc=$P($G(^ARCIM(ArcimSub,ArcimVer,1)),"^",2)
	.s OrcatDR=$P($G(^ARCIM(ArcimSub,ArcimVer,1)),"^",10)
	.s OrcatDesc=$P($G(^ARC("IC",OrcatDR)),"^",2)	
	.s OrdStatDR=$P($G(^OEORD(OrderId,"I",OrderSub,1)),"^",13)
	.i OrdStatDR'="" s OrdStatDesc=$P(^OEC("OSTAT",OrdStatDR),"^",2)
	.e  s OrdStatDesc=""
	.s ExecDate=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",2)   // OEORI_DateExecuted
	.s ExecTime=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",3)   // OEORI_TimeExecuted
	.s ExecCtcpDR=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",4)       // OEORI_UserExecuted
	.i ExecCtcpDR'="" s ExecCtcpDesc=$P($G(^SSU("SSUSR",ExecCtcpDR)),"^",2)
	.e  s ExecCtcpDesc=""
	.s caredr=$p(^OEORD(OrderId,"I",OrderSub,1),"^",11) ;
    .if caredr'="" d
    ..s CtcpDesc=$p($g(^CTPCP(caredr,1)),"^",2)
    ..i (($g(^DHCRisGetNameSet)="ID")&&($p($g(^CTPCP(caredr,1)),"^",3)'="")) s CtcpDesc=$p($g(^CTPCP(caredr,1)),"^",3)
	.;s CtcpDR=$P($G(^OEORD(OrderId,"I",OrderSub,7)),"^",1)         //OEORI_UserAdd
	.;i CtcpDR'="" s CtcpDesc=$P($G(^SSU("SSUSR",CtcpDR)),"^",2)
	.;e  s CtcpDesc=""
	.i (ExecDate="")!(ExecTime="")!(CtcpDesc="") d // EH 取最近一条执行记录
	..s ordStatSub="",fd=0 f  s ordStatSub=$O(^OEORD(OrderId,"I",OrderSub,"ST",ordStatSub),-1),fd=$i(fd) q:(ordStatSub="")!(fd>1)  d
	...s ordStatStr=^OEORD(OrderId,"I",OrderSub,"ST",ordStatSub)
	...q:$p(ordStatStr,"^",3)=""
	...i ($p($G(^OEC("OSTAT",$p(ordStatStr,"^",3))),"^",1)="E") d
	....s ExecDate=$p(ordStatStr,"^",1)
	....s ExecTime=$p(ordStatStr,"^",2)
	....s xUserId=$p(ordStatStr,"^",4)
	....q:'$d(^SSU("SSUSR",+xUserId)) // 报错
	....s xCtcpId=$p(^SSU("SSUSR",+xUserId),"^",14)
	....i xCtcpId'="" s ExecCtcpDesc=$p($g(^CTPCP(xCtcpId,1)),"^",2)
	....e  s ExecCtcpDesc=""
	.s ExecDateTime=$zd(ExecDate,3)_" "_$zt(ExecTime)
    .i ExecDate="" s ExecDateTime=""
    
	.s RecLocDR=$P(^OEORD(OrderId,"I",OrderSub,3),"^",6)       //OEORI_RecDep_DR
	.s RecLocDesc=$p(^CTLOC(RecLocDR),"^",2)
	.i $P(RecLocDesc,"-",2)'="" s RecLocDesc=$P(RecLocDesc,"-",2)                                        
    .s OrdDate1=$p($g(^OEORD(OrderId,"I",OrderSub,3)),"^",7)   //OEORI_Date
    .s OrdTime1=$p($g(^OEORD(OrderId,"I",OrderSub,1)),"^",17)  //OEORI_TimeOrd
	.s OrdDateTime=$zd(OrdDate1,3)_"  "_$zt(OrdTime1)
	.i OrdStatDR=1 d
	..s ExecDateTime=""
	..s ExecCtcpDesc=""
    .f rnum=1:1:$g(^OEORD(OrderId,"I",OrderSub,"DEP",0))  d    //OEORI_DepProcNotes
	..s notes=$g(notes)_$g(^OEORD(OrderId,"I",OrderSub,"DEP",rnum))
	.s oeoriPrice=$p($g(^OEORD(OrderId,"I",OrderSub,3)),"^",25)
    .s OrdUnitCost=+##CLASS(UDHCJFPRICE).GetOrderPrice("","",ArcimDR,OrdDate1,"","","",oeoriPrice)
	.i OrdUnitCost'=0 d
	..s OrdQty=$p($g(^OEORD(OrderId,"I",OrderSub,1)),"^",12)
	..s OrdCost=OrdUnitCost*OrdQty
	..s OrdQtys=OrdQtys+OrdQty
	..s OrdCosts=OrdCosts+OrdCost
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	
	s RegisterTime=$listget(examInfo,42,"")
	s RegisterUserId=$listget(examInfo,41,"")
	;b ; w RegisterUserId
	i (RegisterUserId'="") d
	.s userInfo=$g(^dbo.tblUserD(RegisterUserId))
	.i (userInfo'="") d
	..s RegisterUserName=$listget(userInfo,11,"")
	
	//w RegisterTime,!
	//w RegisterUserId,!
	//w RegisterUserName,!
	q
}

ClassMethod GetRegFlage(OrderId, OrderSub) As %String
{
	s rtn="1" ;未登记
	new $namespace
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s ordId=OrderId_"||"_OrderSub
	s (reqId,examId,examInfo)=""
	s reqId=$o(^dbo.tblRequestI("indexBarcode"," "_ordId,reqId))
	q:(reqId="")!(reqId="0") rtn
	s examId=$o(^dbo.tblExaminationI("idxRequestID",reqId,examId))
	q:(examId="")!(examId="0") rtn
	s examInfo=$g(^dbo.tblExaminationD(examId))
	q:(examInfo="") rtn
	s statusCode=+$listget(examInfo,20,"")
	i (ekgStatusCode<24)&&(ekgStatusCode>10) s rtn="0"
	q rtn
}

/// Creator：      xzy
/// CreatDate：    2018-07-26
/// Modify: 	   
/// ModifyDate：   
/// Description:   根据医嘱号获取加急描述
/// Table：        
/// Input：        医嘱号
/// Output：       如果加急，则返回"急",否则返回 ""
/// w ##class(web.DHCEkgService).getUrgent("41||80")
ClassMethod GetUrgent(OrdId As %String) As %String
{
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","GetUrgent",$zd($h,3),$zt($p($h,",",2),1),OrdId,"params")
	set rtnUrgent=""
	//set OEORINotifyClinician = $p($G(^OEORD(orderParref,"I",orderId,11)),"^",55)
	//set OEORINotifyClinician=$case(OEORINotifyClinician,"Y":"<font color=red>急</font>",:"")
	
	set orderParref=$p(OrdId,"||",1) //+OrdId
	set orderId=$p(OrdId,"||",2)
	set OEORINotifyClinician = $p($G(^OEORD(orderParref,"I",orderId,11)),"^",55)
	set rtnUrgent=$case(OEORINotifyClinician,"Y":"急",:"")

	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkgService","GetUrgent",$zd($h,3),$zt($p($h,",",2),1),rtnUrgent,"rtn")
	quit rtnUrgent
}

}
