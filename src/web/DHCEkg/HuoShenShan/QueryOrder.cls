Import SQLUser

Class web.DHCEkg.HuoShenShan.QueryOrder Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCEkg.HuoShenShan.QueryOrder","GetEkgOdrList","269","","65379","65408","","","","","","","内分泌科护理单元")
Query GetEkgOdrList(LocId As %String, PatRegNo As %String, StartDate As %String, EndDate As %String, examItemFilter As %String, ExecFlage As %String = 0, FeeFlage As %String = 0, patientType = "", examStateQ = "", rptState As %String, ordDeptCode As %String) As %Query(ROWSPEC = "RegNo:%String,PatName:%String,BedCode:%String,ArcimDesc:%String,OeordId:%String,OrdStatDesc:%String,OrcatDesc:%String,ExecDateTime:%String,ExecCtcpDesc:%String,CtcpDesc:%String,RecLocDesc:%String,OrdDateTime:%String,AdmDep:%String,notes:%String,OrdUnitCost:%String,OrdQty:%String,OrdCost:%String,admId:%String,medcareno:%String,Billed:%String,admType:%String,sex:%String,wardid:%String,age:%String,Diagnosis:%String,AdmReason:%String,dobDate:%String,FeeState:%String,ExamState:%String,Wardname:%String")
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

ClassMethod GetEkgOdrListExecute(ByRef qHandle As %Binary, LocId As %String, PatRegNo As %String, StartDate As %String, EndDate As %String, examItemFilter As %String, ExecFlage As %String = 0, FeeFlage As %String = 0, patientType = "", examStateQ = "", rptState As %String, ordDeptCode As %String) As %Status
{
	s ^tmpDHCEKG("web.DHCEkg.HuoShenShan.QueryOrder")=LocId_","_PatRegNo_","_StartDate_","_EndDate_","_examItemFilter_","_ExecFlage_","_FeeFlage_","_patientType_","_examStateQ_","_rptState_","_ordDeptCode
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
 	i ExecFlage="" s ExecFlage=0
 	s mradm="",Diagnosis=""
 	i StartDate>EndDate   Set qHandle=$lb(0,repid,0) Quit $$$OK
 	;b ;EpisodeID
 	i (PatRegNo'="")&&(PatRegNo'=$c(0)) d
 	.;b ; w PatRegNo
 	.s papmiId=""
 	.s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatRegNo),""))
 	.q:papmiId=""
 	.s medcareno=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
 	.s admTypes(1)="O",admTypes(2)="E",admTypes(3)="I",admTypes(4)="H"
 	.f i=1:1:4 d
 	..s admId="" f  s admId=$o(^PAPERdr(papmiId,"ADM",admTypes(i),admId),-1) q:(admId="")  d
 	...s pavisit=$p($g(^PAADM(admId)),"^",20)
 	...s admType=$p($G(^PAADM(admId)),"^",2)
 	...//门诊O急诊E住院I
 	...q:("OEIH")'[admType
 	...s ctlocId=$p(^PAADM(admId),"^",4)
	...;s AdmDep=$p(^CTLOC(+ctlocId),"^",2)
    ...s WardDr=$p(^PAADM(admId),"^",70)
    ...s wardname=""
    ...i WardDr'=""  d
    ....s wardCode=$p($g(^PAWARD(WardDr)),"^",1)
    ....;i (wardname["-") do
    ....;.s wardname=$p(wardname,"-",2)
    ...;w wardname_","_ordDeptName,!
	...q:((ordDeptCode'="")&&(ordDeptCode'=wardCode))
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
	....;s AdmDep=$p(^CTLOC(+ctlocId),"^",2)
	....;q:((ordDeptName'="")&&(ordDeptName'=AdmDep))
    ....s WardDr=$p(^PAADM(admId),"^",70)
    ....s wardCode=""
    ....;b ; w WardDr
    ....i WardDr'=""  d
    .....s wardCode=$p($g(^PAWARD(WardDr)),"^",1)
    .....;i (wardname["-") do
    .....;.s wardname=$p(wardname,"-",2)
    ....;w wardname_","_ordDeptName,!
	....q:((ordDeptCode'="")&&(ordDeptCode'=wardCode))
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
	s admId=$translate(admId,$c(0),"")
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
	s Wardname=$translate(Wardname,$c(0),"")
	s ^TmpNurOrderPrint(userId,ind)=RegNo_"^"_PatName_"^"_BedCode_"^"_ArcimDesc_"^"_OeordId_"^"_OrdStatDesc_"^"_OrcatDesc_"^"_ExecDateTime_"^"_ExecCtcpDesc_"^"_CtcpDesc_"^"_RecLocDesc_"^"_OrdDateTime_"^"_AdmDep_"^"_notes_"^"_OrdUnitCost_"^"_$g(OrdQty)_"^"_$g(OrdCost)_"^"_$g(admId)_"^"_$g(medcareno)_"^"_billed_"^"_Diagnosis_"^"_FeeState_"^"_ExamState_"^"_Wardname
	s Data=$lb(RegNo,PatName,BedCode,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes,OrdUnitCost,OrdQty,OrdCost,admId,medcareno,billed,admType1,sex,wardid,age,Diagnosis,AdmReason,dobDate,FeeState,ExamState,Wardname)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
GetOrder(OrderId,OrderSub)
	s (RegNo,PatName,ArcimDesc,OeordId,OrdStatDesc,OrcatDesc,ExecDateTime,ExecCtcpDesc,CtcpDesc,RecLocDesc,OrdDateTime,AdmDep,notes,AdmReason,FeeState,ExamState,Wardname)=""
	s OeordId=OrderId_"||"_OrderSub
	s StudyNo="EKG||"_OeordId
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
	else  if (ExamStateCode'="") s ExamState=ExamStateCode
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
    s WardDr=$p(^PAADM(admId),"^",70)
    s wardname=""
    i WardDr'=""  d
    .s Wardname=$p($g(^PAWARD(WardDr)),"^",2)
    .i (Wardname["-") do
    ..s Wardname=$p(Wardname,"-",2)
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
	s ExecDate=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",2)   // OEORI_DateExecuted
	s ExecTime=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",3)   // OEORI_TimeExecuted
	s ExecCtcpDR=$P($G(^OEORD(OrderId,"I",OrderSub,6)),"^",4)       // OEORI_UserExecuted
	i ExecCtcpDR'="" s ExecCtcpDesc=$P($G(^SSU("SSUSR",ExecCtcpDR)),"^",2)
	e  s ExecCtcpDesc=""
	s caredr=$p(^OEORD(OrderId,"I",OrderSub,1),"^",11) ;
    if caredr'="" d
    .s CtcpDesc=$p($g(^CTPCP(caredr,1)),"^",2)
    .i $g(^DHCRisGetNameSet)="ID" s CtcpDesc=$p($g(^CTPCP(caredr,1)),"^",3)
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
    s OrdUnitCost=+##CLASS(web.UDHCJFPRICE).GetOrderPrice("","",ArcimDR,OrdDate1,"","","",oeoriPrice)
	q:OrdUnitCost=0
	s OrdQty=$p($g(^OEORD(OrderId,"I",OrderSub,1)),"^",12)
	s OrdCost=OrdUnitCost*OrdQty
	s OrdQtys=OrdQtys+OrdQty
	s OrdCosts=OrdCosts+OrdCost
	
	q
}

ClassMethod GetRegNobyEpisodeID(EpisodeID)
{
 	;n (EpisodeID)
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

}
