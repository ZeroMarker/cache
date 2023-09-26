Include webimport

IncludeGenerator webimport

/// //////^OEORD(+OrderItemRowId,"I",$P(OrderItemRowId,"||",2),"INSUTMP",1)保存是否控制剩余药量
Class web.DHCDocOrderMedLeft Extends DHCDoc.Util.RegisteredObject
{

ClassMethod FindPatByID(PAPMINo)
{
 q:PAPMINo="" ""
 s PAPMI=$o(^PAPERi("PAPMI_PatNo",PAPMINo,""))
 i (PAPMI'="") s PatName=$p(^PAPER(PAPMI,"ALL"),"^",1) q PatName
 e  q ""
}

Query GetOrder(AdmId As %String, HospId As %String = "") As %Query(ROWSPEC = "OEItemID:%String,PatInfo:%String,OrdStartDate:%String,OrdStartTime:%String,QtyPackUOM:%String,ArcimDesc:%String,MedLeft:%String,BBExtCode:%String,PriorityDesc:%String,OrdPrescNo:%String,LimitOrdInfo:%String,CoverMainIns:%String")
{
}

ClassMethod GetOrderClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetOrderExecute ]
{
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query GetOrderLimit(OrderStr As %String, HospId As %String = "", AdmReasonDr As %String = "") As websys.Query(ROWSPEC = "OEItemID:%String,ArcimDesc:%String,LimitOrdInfo:%String")
{
}

/// /d ##class(%ResultSet).RunQuery("web.DHCDocOrderMedLeft","GetOrderLimit","1549||1",2)
ClassMethod GetOrderLimitExecute(ByRef QHandle As %Binary, OrderStr As %String = "", HospId As %String = "", AdmReasonDr As %String = "") As %Status
{
   Set repid=$I(^CacheTemp)
   Set ind=1
   s del="^",AdmType=""
   Set QHandle=$lb(0,repid,0)
   for i=1:1:$l(OrderStr,"^") {
		s ORORIRowId=$p(OrderStr,"^",i)
		q:ORORIRowId=""
		s ArcimId=$p($g(^OEORD(+ORORIRowId,"I",$P(ORORIRowId,"||",2),1)),del,2)
		s ArcStr=##class(web.DHCFBArcimGet).GetArcimById(ArcimId)
		q:ArcStr=""
		s ArcimDesc=$p(ArcStr,del,3)
		s OrdPrescNo=$p($g(^OEORD(+ORORIRowId,"I",$p(ORORIRowId,"||",2),1)),"^",14)
		s LimitOrdInfo=##class(web.DHCDocInPatPortalCommon).GetInsuLimitInfo(ArcimId,AdmReasonDr,HospId)
		d OutputOrderLimit
	}
   
   Set QHandle=$lb(0,repid,0)
   Quit $$$OK
OutputOrderLimit
 set Data=$lb(OEItemID,ArcimDesc,LimitOrdInfo)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetOrderExecute(ByRef QHandle As %Binary, AdmId As %String = "", HospId As %String = "") As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCDocOrderMedLeft","GetOrder","1669",2)
 Set repid=$I(^CacheTemp)
  Set ind=1
   s del="^",AdmType=""
   Set QHandle=$lb(0,repid,0)
	if (AdmId="")  Quit $$$OK
	s paperDr=$P(^PAADM(AdmId),"^",1)
	s PatName=$p(^PAPER(paperDr,"ALL"),"^",1)   ;姓名
	s sex=$p(^PAPER(paperDr,"ALL"),"^",7)       ;性别
	i sex'="" s sex=$p(^CT("SEX",sex),"^",2)
	s patNo=$p(^PAPER(paperDr,"PAT",1),"^",1)   ;病人ID
	s PatInfo="姓名："_PatName_"性别："_sex_"患者ID："_patNo
	q:'$d(^OEORD(0,"Adm",AdmId)) $$$OK
	s OrdId1=$o(^OEORD(0,"Adm",AdmId,0))
	s PatientID=$P(^PAADM(AdmId),"^",1)
	q:OrdId1="" $$$OK
	s OrdId2=0
	s OrdCreateDate="",OrdCreateTime="",OrdStartDate="",OrdStartTime="",ArcimDesc=""
	f  s OrdId2=$o(^OEORD(OrdId1,"I",OrdId2)) q:OrdId2=""  d
	.s UserAdd=$p($g(^OEORD(+OrdId1,"I",OrdId2,7)),"^",1) ;下医嘱人
	.s LinkOrderItem=$p($g(^OEORD(+OrdId1,"I",OrdId2,11)),"^",39)
	.i LinkOrderItem'="" s MainUserAdd=$p($g(^OEORD(+LinkOrderItem,"I",$p(LinkOrderItem,"||",2),7)),"^",1) ;下医嘱人
	.Q:(LinkOrderItem'="")&&(UserAdd=$g(MainUserAdd)) //过滤掉子医嘱,防止主子医嘱费别和日期修改后不一致
	.s OEItemID=OrdId1_"||"_OrdId2
	.s ordstr1=$g(^OEORD(OrdId1,"I",OrdId2,1))
	.s ordstr2=$g(^OEORD(OrdId1,"I",OrdId2,2))
	.s ordstr3=$g(^OEORD(OrdId1,"I",OrdId2,3))
	.s ordstr5=$g(^OEORD(OrdId1,"I",OrdId2,5))
	.s ordstr9=$g(^OEORD(OrdId1,"I",OrdId2,9))
	.s ordstr11=$g(^OEORD(OrdId1,"I",OrdId2,11))
	.s ArcimId=$p(ordstr1,del,2)
	.s ArcStr=##class(web.DHCFBArcimGet).GetArcimById(ArcimId)
	.q:ArcStr=""
	.s arctpdr=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)
	.s ArcimCode=$p(ArcStr,del,2),ArcimDesc=$p(ArcStr,del,3)
	.s ReqPartDesc=##Class(web.DHCAPPInterface).GetExaReqPartDesc(OrdId1_"||"_OrdId2)
	.i ReqPartDesc'="" s ArcimDesc=ArcimDesc_"["_ReqPartDesc_"]"
	.s OrdStartDate=$p(ordstr1,del,9),OrdStartDate=..%ZD(OrdStartDate) //$zd(OrdStartDate,3)
	.s OrdStartTime=$p(ordstr1,del,10),OrdStartTime=..%ZT(OrdStartTime,1)
	.s PrescNo=$p(ordstr1,del,14)
	.s QtyPackUOM=$p(ordstr9,del,4)
	.i (QtyPackUOM<1)&&(QtyPackUOM'="") s QtyPackUOM=1
	.s OEORIPhQtyOrd=$p(ordstr1,del,12)
	.i (OEORIPhQtyOrd<1)&&(OEORIPhQtyOrd'="") s OEORIPhQtyOrd=1
	.s OrdPackQtyInfo=##class(web.DHCDocQryOEOrder).GetOrdPackQtyInfo(OEItemID)
	.s Pqty=$p(OrdPackQtyInfo,"^",1)
	.s PackUOMDesc=$p(OrdPackQtyInfo,"^",2)
	.s QtyPackUOM=Pqty_PackUOMDesc
	.s MedLeft=$p($g(^OEORD(+OEItemID,"I",$P(OEItemID,"||",2),"INSUTMP")),"^",1)
	.s BBExtCode="",BBExtCodeDR=""
	.s BBExtCodeDR=$p($g(^OEORD(+OEItemID,"I",$P(OEItemID,"||",2),11)),"^",18)
	.i BBExtCodeDR'="" s BBExtCode=$p(^PAC("ADMREA",BBExtCodeDR),"^", 2)
	.s OrdStatusDr=$p(ordstr1,del,13)
	.s OrdStatusCode="",OrdStatus=""
	.s:$g(OrdStatusDr)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatusDr),del,2),OrdStatusCode=$p(^OEC("OSTAT",OrdStatusDr),del,1)
	.Q:(OrdStatusCode'="V")&&(OrdStatusCode'="E")
	.s PriorityId=$p(^OEORD(OrdId1,"I",OrdId2,1),"^",8)
	.s TPriorityCode=$p(^OECPR(PriorityId),"^",1) //医嘱类型Code
	.s PriorityDesc=$p(^OECPR(PriorityId),"^",2)
	.s OrdPrescNo=$p($g(^OEORD(+OEItemID,"I",$p(OEItemID,"||",2),1)),"^",14)
	.;s arctype=$p(^ARC("IC",arctpdr),"^",7) ;ARC_ItemCat 表中的ARCIC_Ordertype ,="R"是药物
	
	.s LimitOrdInfo=##class(web.DHCDocInPatPortalCommon).GetInsuLimitInfo(ArcimId,BBExtCodeDR,HospId)
	.s CoverMainIns=$P(ordstr3,"^",3)
	.;q:($g(arctype)'="R")
 	.d OutputRow3
 Set QHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow3
 set Data=$lb(OEItemID,PatInfo,OrdStartDate,OrdStartTime,QtyPackUOM,ArcimDesc,MedLeft,BBExtCode,PriorityDesc,OrdPrescNo,LimitOrdInfo,CoverMainIns)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetOrderFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrderExecute ]
{
   Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/*Query GetAdm(PapmiNo) As %SQLQuery(CONTAINID = 1, ROWSPEC = "AdmDate:%String,RowID:%String")
{
	select Todate(PAADM_AdmDate,'yyyy-mm-dd'),PAADM_RowID from SQLUSER.pa_adm where PAADM_PAPMI_DR=(select PAPMI_RowId1 from PA_PATmas where PAPMI_No=:PapmiNo)
}*/
ClassMethod SetINSUTMP(OrderItemRowId, INSUTMP)
{
 
  s $p(^OEORD(+OrderItemRowId,"I",$P(OrderItemRowId,"||",2),"INSUTMP"),"^",1)=INSUTMP
  q 1
}

Query GetAdm(PapmiNo As %String, HospID As %String = "") As %Query(ROWSPEC = "AdmDate:%String,RowID:%String,DepDesc:%String,DocDesc:%String,PAAdmWard:%String,BedNo:%String")
{
}

ClassMethod GetAdmClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetAdmExecute ]
{
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAdmExecute(ByRef QHandle As %Binary, PapmiNo As %String, HospID As %String = "") As %Status
{
 //d ##class(%ResultSet).RunQuery("web.DHCDocOrderMedLeft","GetAdm",29155881)
 Set repid=$I(^CacheTemp)
  Set ind=1
  k ^tmp("ChangeFeeTypeAdmQuery",$j)
  if (PapmiNo="") Set QHandle=$lb(0,repid,0) Quit $$$OK
  s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
  s PAPMI=$o(^PAPERi("PAPMI_PatNo",PapmiNo,""))
  q:$g(PAPMI)="" $$$OK
  Set AdmType=""
  For  Set AdmType=$O(^PAPERdr(PAPMI,"ADM",AdmType)) Quit:AdmType=""  Do
  .Set PAAdm=""
  .For  Set PAAdm=$O(^PAPERdr(PAPMI,"ADM",AdmType,PAAdm)) Quit:PAAdm=""  Do
  ..s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(PAAdm)
  ..Q:AdmHospitalId'=HospID
  ..s AdmDate=..%ZD($P($g(^PAADM(PAAdm)),"^",6)) //$ZD($P($g(^PAADM(PAAdm)),"^",6),3)
  ..s RowID=PAAdm
  ..s DepCodeDR=$P($g(^PAADM(PAAdm)),"^",4)
  ..s DepDesc=""
  ..s DocDesc=""
  ..i DepCodeDR'=""  d
  ...s DepDesc=$p($g(^CTLOC(DepCodeDR)),"^",2) 
  ...i $f(DepDesc,"-")'=0  d
  ....s DepDesc=$p(DepDesc,"-",2)
  ..s DocCodeDR=$P($g(^PAADM(PAAdm)),"^",9)
  ..i DocCodeDR'=""  d
  ...s DocDesc=$p($g(^CTPCP(DocCodeDR,1)),"^",2)
  ..s BedNo=##class(web.DHCDoc.OP.AjaxInterface).GetPatBedNo($g(PAAdm))
  ..Set Ward=$P($g(^PAADM(PAAdm)),"^",70)
  ..s PAAdmWard=""
  ..if Ward'="" Set PAAdmWard=$P($g(^PAWARD(Ward)),"^",2)
  ..s ^tmp("ChangeFeeTypeAdmQuery",$j,$P($g(^PAADM(PAAdm)),"^",6)_$ZTS)=$lb(AdmDate,RowID,DepDesc,DocDesc,PAAdmWard,BedNo)
  s admdate=""
  f  s admdate=$O(^tmp("ChangeFeeTypeAdmQuery",$j,admdate),-1) q:admdate=""  d
  .set Data=$G(^tmp("ChangeFeeTypeAdmQuery",$j,admdate))
  .d OutputRow
  k ^tmp("ChangeFeeTypeAdmQuery",$j)
  
 Set QHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
 //set Data=$lb(AdmDate,RowID,DepDesc,DocDesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetAdmFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmExecute ]
{
   Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod UpdateBBExtCode(OrderID, BBExtCode)
{
	q:OrderID="" 201
	s AdmDr=$P(^OEORD(+OrderID),"^",1)
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(AdmDr)
	s InsurBillStr=##Class(web.DHCDocOrderCommon).GetInsurBillStr(PAAdmType)
	s InsurBill=1
	if ("^"_InsurBillStr_"^")'[("^"_BBExtCode_"^") {
		s InsurBill=0
	}
	s OrderChronicDiagCode=$P($G(^OEORD(+OrderID,"I",$P(OrderID,"||",2),"DHC")),"^",66)
	s ret=0
	TStart
	
	//清空慢病病种
	if (InsurBill=0)&&(OrderChronicDiagCode'=""){
		&sql(update OE_OrdItemExt set OEORI_ChronicDiagCode=null where OEORI_RowId=:OrderID)
		s ret=SQLCODE
	}
	&sql(update OE_Orditem set OEORI_BBExtCode=:BBExtCode where OEORI_RowId=:OrderID)
	s ret=ret+SQLCODE
     i ret=0  d
	 .Tcommit
	  e  d
	 .Trollback
	 q ret
}

/// /修改的时候要修改所有处方号对应的医嘱，否则医嘱费别不一样！
ClassMethod CheckBBExtCodeChg(OEORIStr As %String) As %String
{
	s NotAllOrdPrescNoFlag=""
	s NotAllOrdPrescNo=""
	for i=1:1:$l(OEORIStr,"^") {
		s ORORIRowId=$p(OEORIStr,"^",i)
		q:NotAllOrdPrescNo'=""
		s OrdPrescNo=$p($g(^OEORD(+ORORIRowId,"I",$p(ORORIRowId,"||",2),1)),"^",14)
		continue:OrdPrescNo=""
		continue:##Class(web.DHCDocPrescript).IsPrescType(OrdPrescNo)="1"
		s itemsub=""
		f  s itemsub=$O(^OEORD(0,"PrescNo",OrdPrescNo,+ORORIRowId,itemsub)) q:(itemsub="")||(NotAllOrdPrescNo'="")  d
		.s OtherORORIRowId=+ORORIRowId_"||"_itemsub
		.i ("^"_OEORIStr_"^")'[("^"_OtherORORIRowId_"^") s NotAllOrdPrescNo=OrdPrescNo
	}

	i NotAllOrdPrescNo'="" s NotAllOrdPrescNoFlag="处方号："_NotAllOrdPrescNo_"内所有医嘱需选中，否则会导致同处方号的处理只能部分成功！"
	q NotAllOrdPrescNoFlag
}

ClassMethod BBExtCodeChgApply(OEORIStr As %String, BBExtCode As %String, UserId As %String) As %String
{
	s flag=..CheckBBExtCodeChg(OEORIStr)
	q:flag'="" flag
	s rtn=0
	s AdmDr=$P(^OEORD(+OEORIStr),"^",1)
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(AdmDr)
	s InsurBillStr=##Class(web.DHCDocOrderCommon).GetInsurBillStr(PAAdmType)
	s InsurBill=1
	if ("^"_InsurBillStr_"^")'[("^"_BBExtCode_"^") {
		s InsurBill=0
	}
	s RepeatAdmReasonRowids=""
	for i=1:1:$l(OEORIStr,"^") {
		s ORORIRowId=$p(OEORIStr,"^",i)
		s OEORIBBExtCode=$P($G(^OEORD(+ORORIRowId,"I",$P(ORORIRowId,"||",2),11)),"^",18)
		if (OEORIBBExtCode=BBExtCode) {
			i RepeatAdmReasonRowids="" s RepeatAdmReasonRowids= ORORIRowId
			e  s RepeatAdmReasonRowids=RepeatAdmReasonRowids_" , "_ORORIRowId
		}
	}
	Q:RepeatAdmReasonRowids'="" "医嘱ID "_RepeatAdmReasonRowids_" 修改后的费别与当前医嘱费别相同！"
	TS
	s ApplyTableName="User.OEOrdItem",ApplyTableNameDesc="医嘱费别信息"
	for i=1:1:$l(OEORIStr,"^") {
		s ORORIRowId=$p(OEORIStr,"^",i)
		s OEORIBBExtCode=$P($G(^OEORD(+ORORIRowId,"I",$P(ORORIRowId,"||",2),11)),"^",18)
		if (OEORIBBExtCode=BBExtCode) {
			i RepeatAdmReasonRowids="" s RepeatAdmReasonRowids= ORORIRowId
			e  s RepeatAdmReasonRowids=RepeatAdmReasonRowids_" , "_ORORIRowId
			Q
		}
		s OrderChronicDiagCode=$P($G(^OEORD(+ORORIRowId,"I",$P(ORORIRowId,"||",2),"DHC")),"^",66)
		s UpdateValueObj=[]
		s UpdateValueData={}
		d UpdateValueData.%Set("FieldName","OEORIBBExtCode")
		d UpdateValueData.%Set("FieldDesc","费别")
		d UpdateValueData.%Set("FieldValue",BBExtCode)
		d UpdateValueObj.%Push(UpdateValueData)
		//清空慢病病种
		if (InsurBill=0)&&(OrderChronicDiagCode'=""){
			s UpdateValueData={}
			d UpdateValueData.%Set("FieldName","OEORIChronicDiagCode")
			d UpdateValueData.%Set("FieldDesc","慢性病")
			d UpdateValueData.%Set("FieldValue","")
			d UpdateValueObj.%Push(UpdateValueData)
		}
		s rtn=##class(web.DHCDocDataChangeApply).SaveApplyData(ApplyTableName,ApplyTableNameDesc,ORORIRowId,UpdateValueObj.%ToJSON(),UserId)
		Q:rtn'=0
	}
	if ('rtn) TC
	else  Tro
	Q rtn
}

// w ##class(web.DHCDocOrderMedLeft).OrdDateChgApply("2996||6^2996||7","2020-11-18 15:41:00",1)

ClassMethod OrdDateChgApply(OEORIStr As %String, NewDateTime As %String, UserId As %String) As %String
{
	s ^tempscl("OrdDateChgApply")=$lb(OEORIStr,NewDateTime,UserId)
	s ErrMsg="",DateCheckMessage="",DateErrRowids="",ZKCheckMessage="",ZKDateErrMsg=""
	s OrdDate=$p(NewDateTime," ",1)
	s FormateOrdDate=..%ZDH(OrdDate)
	s OrdTime=$p(NewDateTime," ",2)
	s FormateOrdTime=..%ZTH(OrdTime)
	for i=1:1:$l(OEORIStr,"^") {
		s ORORIRowId=$p(OEORIStr,"^",i)
		s AdmDr=$P(^OEORD(+ORORIRowId),"^",1)
		s PAADMType=$p($g(^PAADM(AdmDr)),"^",2)
		s ordstr1=$g(^OEORD(+ORORIRowId,"I",$p(ORORIRowId,"||",2),1))
		s OrdStartDate=$p(ordstr1,"^",9)
		s OrdStartTime=$p(ordstr1,"^",10)
		if (FormateOrdDate>OrdStartDate)||((FormateOrdDate=OrdStartDate)&&(FormateOrdTime>OrdStartTime)) {
			i ErrMsg="" s ErrMsg=ORORIRowId
			e  s ErrMsg=ORORIRowId_"，"
		}
		s CheckMessage=##Class(web.DHCDocOrderCommon).CheckOrderDate(AdmDr,$ZD(FormateOrdDate,3)_" "_FormateOrdTime)
		if (CheckMessage'=""){
			i DateErrRowids="" s DateErrRowids=ORORIRowId
			e  s DateErrRowids=ORORIRowId_"，"
		}
		if (PAADMType="I"){
			//判断转科时间
			s ret=##class(web.DHCDocOrderEntry).CheckOrderStartDateByZKAdm(AdmDr,$ZD(OrdStartDate,4)_" "_..%ZT(OrdStartTime,1),$ZD(FormateOrdDate,4)_" "_..%ZT(FormateOrdTime,1),"")
			if (ret'="0"){
				i ZKDateErrMsg="" s ZKDateErrMsg=ORORIRowId_" "_$p(ret,"^",2)
				e   s ZKDateErrMsg=ZKDateErrMsg_" ; "_ORORIRowId_" "_$p(ret,"^",2)
			}
		}
	}
	if (ErrMsg'="") {
		s ErrMsg="医嘱ID "_ErrMsg_" 修改后的下医嘱时间不能晚于医嘱开始时间！"
	}
	if (DateErrRowids'="") {
		s ErrMsg=ErrMsg_" 医嘱ID "_DateErrRowids_" 开医嘱时间不能小于就诊时间！"
	}
	if (ZKDateErrMsg'="") {
		s ErrMsg=ErrMsg_" "_ZKDateErrMsg
	}
	Q:ErrMsg'="" ErrMsg
	s rtn=0
	s ApplyTableName="User.OEOrdItem",ApplyTableNameDesc="医嘱信息"
	s UpdateValueObj=[]
	s UpdateValueData={}
	d UpdateValueData.%Set("FieldName","OEORIDate")
	d UpdateValueData.%Set("FieldDesc","下医嘱日期")
	d UpdateValueData.%Set("FieldValue",OrdDate)
	d UpdateValueObj.%Push(UpdateValueData)
	
	s UpdateValueData={}
	d UpdateValueData.%Set("FieldName","OEORITimeOrd")
	d UpdateValueData.%Set("FieldDesc","下医嘱时间")
	d UpdateValueData.%Set("FieldValue",OrdTime)
	d UpdateValueObj.%Push(UpdateValueData)
	for i=1:1:$l(OEORIStr,"^") {
		s ORORIRowId=$p(OEORIStr,"^",i)
		s rtn=##class(web.DHCDocDataChangeApply).SaveApplyData(ApplyTableName,ApplyTableNameDesc,ORORIRowId,UpdateValueObj.%ToJSON(),UserId)
		Q:rtn'=0
	}
	Q rtn
}

Query GetOrdChgApplyInfoList(ApplyObjectReference As %String) As websys.Query(ROWSPEC = "ApplyId:%String,ApplyTableName:%String,ORORIRowId:%String,ApplyUser:%String,ApplyDate:%String,ApplyTime:%String,ApplyOldValue:%String,ApplyNewValue:%String,ApplyInfoDetail:%String,PatInfo:%String,ArcimDesc:%String,ApplyStatus:%String,UpdateDate:%String,UpdateTime:%String,RefuseReason:%String,UpdateUser:%String")
{
}

/// Function：根据医嘱ID获取医嘱信息修改申请信息记录
/// Creator:  宋春莉
/// CreatDate:2021-02-22
/// d ##class(%ResultSet).RunQuery("web.DHCDocOrderMedLeft","GetOrdChgApplyInfoList","2996||7")
ClassMethod GetOrdChgApplyInfoListExecute(ByRef qHandle As %Binary, ApplyObjectReference As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    s ApplyId=0
    for {
	    s ApplyId=$o(^User.DHCDocDataChangeApplyI("ApplyObjectReferenceIndex"," "_ApplyObjectReference,ApplyId)) Q:ApplyId=""
	    d GetApplyData
	}
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutPutRow
	set Data=$lb(ApplyId,ApplyTableName,ORORIRowId,ApplyUser,ApplyDate,ApplyTime,ApplyOldValue,ApplyNewValue,ApplyInfoDetail,PatInfo,ArcimDesc,ApplyStatus,UpdateDate,UpdateTime,RefuseReason,UpdateUser)
 	Set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	Q
GetApplyData
	s data=$g(^User.DHCDocDataChangeApplyD(ApplyId))
	s ApplyTableName=$lg(data,2)
	Q:ApplyTableName'["User.OEOrdItem"
	s ApplyUserDr=$lg(data,5)
	s ApplyUser=$p($g(^SSU("SSUSR",ApplyUserDr)),"^",2)
	s ApplyDate=..%ZD($lg(data,6))
	s ApplyTime=..%ZT($lg(data,7),1)
	s ApplyOldValue=$lg(data,8)
	s ApplyNewValue=$lg(data,9)
	s ApplyStatus=$lg(data,10)
	s ApplyInfoDetail=##class(web.DHCDocDataChangeApply).GetApplyInfo(ApplyTableName,ApplyObjectReference,ApplyOldValue,ApplyNewValue)
	s EpisodeID=$p(^OEORD(+ApplyObjectReference),"^",1)
	s paperDr=$P(^PAADM(EpisodeID),"^",1)
	s PatName=$p(^PAPER(paperDr,"ALL"),"^",1)   ;姓名
	s sex=$p(^PAPER(paperDr,"ALL"),"^",7)       ;性别
	i sex'="" s sex=$p(^CT("SEX",sex),"^",2)
	s patNo=$p(^PAPER(paperDr,"PAT",1),"^",1)   ;病人ID
	s PatInfo="姓名："_PatName_"性别："_sex_"患者ID："_patNo
	s ArcimId=$p($g(^OEORD(+ApplyObjectReference,"I",$p(ApplyObjectReference,"||",2),1)),"^",2)
	s ArcimDesc=$p(^ARCIM(+ArcimId,1,1),"^",2)
	s UpdateDate="",UpdateTime="",RefuseReason="",UpdateUserDr=""
	if (ApplyStatus'="A") {
		s UpdateDate=..%ZD($lg(data,11))
		s UpdateTime=..%ZT($lg(data,12),1)
		s RefuseReason=$lg(data,13)
		s UpdateUserDr=$lg(data,14)
		s UpdateUser=$p($g(^SSU("SSUSR",UpdateUserDr)),"^",2)
	}
	s ApplyStatus=$case(ApplyStatus,"A":"申请","P":"审核","R":"拒绝","C":"撤销")
    d OutPutRow
    Q
}

ClassMethod OrdinsufChgApply(OEORIStr As %String, CoverMainIns As %String, UserId As %String) As %String
{
	s ^tempscl("OrdinsufChgApply")=$lb(OEORIStr,CoverMainIns,UserId)
	s ErrMsg="",DateCheckMessage="",DateErrRowids="",ZKCheckMessage="",ZKDateErrMsg=""
	
	s RepeatAdmReasonRowids=""
	for i=1:1:$l(OEORIStr,"^") {
		s ORORIRowId=$p(OEORIStr,"^",i)
		s CoverMainInsOld=$P($g(^OEORD(+ORORIRowId,"I",$P(ORORIRowId,"||",2),3)),"^",3)
		if (CoverMainInsOld=CoverMainIns) {
			i RepeatAdmReasonRowids="" s RepeatAdmReasonRowids= ORORIRowId
			e  s RepeatAdmReasonRowids=RepeatAdmReasonRowids_" , "_ORORIRowId
		}
	}
	Q:RepeatAdmReasonRowids'="" "医嘱ID "_RepeatAdmReasonRowids_" 修改后的医保标识与当前医嘱医保标识相同！"
	
	s rtn=0
	s ApplyTableName="User.OEOrdItem",ApplyTableNameDesc="医嘱信息"
	s UpdateValueObj=[]
	s UpdateValueData={}
	d UpdateValueData.%Set("FieldName","OEORICoverMainIns")
	d UpdateValueData.%Set("FieldDesc","医保标识")
	d UpdateValueData.%Set("FieldValue",CoverMainIns)
	d UpdateValueObj.%Push(UpdateValueData)

	for i=1:1:$l(OEORIStr,"^") {
		s ORORIRowId=$p(OEORIStr,"^",i)
		s rtn=##class(web.DHCDocDataChangeApply).SaveApplyData(ApplyTableName,ApplyTableNameDesc,ORORIRowId,UpdateValueObj.%ToJSON(),UserId)
		Q:rtn'=0
	}
	Q rtn
}

ClassMethod CheckPatYBType(EpisodeID As %String) As %String
{
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s AdmReason=$p($G(^PAADM(EpisodeID,1)),"^",7)
	s AdmDate=$P(^PAADM(EpisodeID),"^",6)
	s:AdmDate'="" AdmDate=$ZD(AdmDate,3)
	s warning=""
	i AdmReason'="" s AdmReasonYBType=$p($g(^PAC("ADMREA",AdmReason)),"^",5)
	s:AdmReasonYBType'=1 warning="请先选择医保病人！"
	s VisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	s PAADMBillFlag=$p($g(^PAADM(EpisodeID)),"^",45)
	s:((PAADMBillFlag="Y")&&(VisitStatus="D")&&(warning="")) warning="此病人已做最终结算！"
	q warning
}

}
