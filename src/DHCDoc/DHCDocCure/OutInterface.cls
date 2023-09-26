/// 治疗站提供给其他产品组的接口方法
Class DHCDoc.DHCDocCure.OutInterface Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:nikang
/// Desc：根据医嘱ID获得治疗申请ID
/// Input:OrderRowID 医嘱ID
/// OutPut:治疗申请ID
/// Debug:w ##class(DHCDoc.DHCDocCure.OutInterface).GetCureApplyByOrd("3382||5")
ClassMethod GetCureApplyByOrd(OrderRowID)
{
	new (OrderRowID)
	set DCARowID=""
	Quit:OrderRowID="" DCARowID
	set DCARowID=$o(^DHCDocCure(0,"OEORI",OrderRowID,""))	
	Quit DCARowID
}

/// Creator:nikang
/// Desc：根据医嘱ID获得治疗申请已经预约或者执行的数量，计费组需根据此方法限制部分退费可申请的数量
/// Input:OEORIRowID 医嘱ID
/// OutPut:治疗申请已经预约或者执行的数量
/// Debug: w ##class(DHCDoc.DHCDocCure.OutInterface).GetCureExecQty("1418||11")
ClassMethod GetCureExecQty(OEORIRowID As %String)
{
	new (OEORIRowID,%session)
	set CureExecQty=0
	Quit:OEORIRowID="" 0
	set DCARowID=$o(^DHCDocCure(0,"OEORI",OEORIRowID,""))	
	Quit:DCARowID="" 0
	set ArcimId=$p($g(^OEORD(+OEORIRowID,"I",$p(OEORIRowID,"||",2),1)),"^",2)
	Quit:ArcimId="" 0
	
	set PriorityDR=$p($g(^OEORD(+OEORIRowID,"I",+$p(OEORIRowID,"||",2),1)),"^",8)
	set ShortOrderPrior=##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR)
	Quit:ShortOrderPrior'=1 0
	Set ApplyExecFlag=$p($g(^DHCDocCure(DCARowID)),"^",19)    ;是否直接执行
	Set ApplyAppointExec=$p($g(^DHCDocCure(DCARowID)),"^",20) ;申请单是否预约允许直接执行
	if ApplyAppointExec="Y" s ApplyExecFlag="Y"
	if ApplyExecFlag'="Y" {
		set CureAppInfo=##class(DHCDoc.DHCDocCure.Appointment).GetApplyAppInfo(DCARowID)
		set CureExecQty=$p(CureAppInfo,"^")
	}else{
		set OrderExecChild=0
		for{
			set OrderExecChild=$o(^OEORD(+OEORIRowID,"I",+$p(OEORIRowID,"||",2),"X",OrderExecChild)) Q:OrderExecChild=""
			set OEORERowID=OEORIRowID_"||"_OrderExecChild
			set execdata=$g(^OEORD(+OEORIRowID,"I",+$p(OEORIRowID,"||",2),"X",OrderExecChild))
			set OEOREStatus=$p(execdata,"^",16)
			set OEOREStatusCode=""
			set:OEOREStatus'="" OEOREStatusCode=$p(^OEC("STAT",OEOREStatus),"^",1)
			set AppointFlag=##class(DHCDoc.DHCDocCure.Appointment).GetExecResultAppStatus(OEORERowID)
			continue:(OEOREStatusCode'="F")&&(AppointFlag'="1")
			set OEOREQty=##class(DHCDoc.DHCDocCure.ExecApply).GetQtyByExecID(OEORIRowID_"||"_OrderExecChild)
			set CureExecQty=CureExecQty+OEOREQty
		}	
	}
	Quit CureExecQty
}

/// Desc：根据就诊ID获得该就诊下所有治疗申请的方案及评估内容，提供给电子病历引用
/// Input:PAAdmRowID 就诊表ID
/// OutPut:就诊日期 就诊时间 治疗项目名称 治疗备注 治疗方案 治疗评估
/// Debug:d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.OutInterface","FindCurePlan","661")
Query FindCurePlan(PAAdmRowID As %String) As %Query(ROWSPEC = "PAAdmDate:%String,PAAdmTime:%String,CureArcimDesc:%String,CureRemarks:%String,CureAppPlan:%String,CureAppAss:%String")
{
}

ClassMethod FindCurePlanExecute(ByRef qHandle As %Binary, PAAdmRowID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	if PAAdmRowID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	set PAAdmDate=$zd($p($g(^PAADM(PAAdmRowID)),"^",6),3)
	set PAAdmTime=$zt($p($g(^PAADM(PAAdmRowID)),"^",7),1)
	set DDCARowID=""
	for{
		set DDCARowID=$o(^DHCDocCure(0,"Adm",PAAdmRowID,DDCARowID))
		Quit:DDCARowID=""
		set CureInfo=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(DDCARowID)
		continue:CureInfo=""
		set PatientInfo=$p(CureInfo,$c(1),1)
		set CureAppInfo=$p(CureInfo,$c(1),2)
		set CureArcimDesc=$p(CureAppInfo,"^",1)
		set CureRemarks=$p(CureAppInfo,"^",14)
		set CureAppPlan=$p(CureAppInfo,"^",15)
		set CureAppAss=##class(DHCDoc.DHCDocCure.Apply).GetCurePlanAndAss("Ass",DDCARowID)
		do OutputRowPlan
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowPlan
	set Data=$lb(PAAdmDate,PAAdmTime,CureArcimDesc,CureRemarks,CureAppPlan,CureAppAss)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindCurePlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCurePlanExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCurePlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCurePlanExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 提供给护理组PDA治疗站接口:查询治疗医师的患者列表
/// Remark：1、PatientID、PatName、ApplyNo 若三个字段有一个不为空，则按此条件查询，优先级（PatientID>ApplyNo>PatName），其他入参作为过滤条件
/// 		2、LongOrdPriority,若传Y，则只查询当天存在可执行执行记录的治疗申请记录
/// 		3、其他不做特殊说明外，均可传空，非空则作为过滤条件,若除必传参数外，所有参数为空，则只查接收到本科室当日的申请单
/// 		4、PatientID、PatName、ApplyNo,LongOrdPriority为空，则按日期查询，日期为空则默认当天
/// Input:PatientID 		【可选参数】患者ID
///       StartDate 		【可选参数】开始日期
///       EndDate 			【可选参数】结束日期
///       FinishDis 		【可选参数】Y 仅查询已完成的申请单
///       PatName 			【可选参数】患者姓名（模糊匹配）
///       LogLocID 			【必传】登录科室ID
///       LogUserID 		【必传】登录用户ID
///       ApplyNo 			【可选参数】治疗申请单号
///       LongOrdPriority	【可选参数】按长嘱当日需执行医嘱查询 Y或空
///       CheckAdmType 		【可选参数】就诊类型 I或空
///       queryArcim 		【可选参数】治疗医嘱项目ID
///       queryOrderLoc 	【可选参数】开单申请科室
/// 	  PacWardDr			【可选参数】患者所在病区ID
/// OutPut:	就诊ID，登记号，病案号，姓名，性别 
/// 		年龄，就诊科室，病区，床号，费别，接收科室，就诊状态，就诊日期，本次就诊包含的治疗申请ID(多个以^分割)
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.OutInterface","FindDocCureApp","","2020-07-01","2020-07-29","","",44,4661) 
Query FindDocCureApp(PatientID As %String, StartDate As %String, EndDate As %String, FinishDis As %String = "", PatName As %String = "", LogLocID As %String = "", LogUserID As %String = "", ApplyNo As %String = "", LongOrdPriority As %String = "", CheckAdmType As %String = "", queryArcim As %String = "", queryOrderLoc As %String = "", PacWardDr As %String = "") As %Query(ROWSPEC = "PatAdmID:%String,PatNo:%String,PatMedicalNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PatAdmDept:%String,PatAdmWard:%String,PatAdmBed:%String,PatAdmReasonDesc:%String,OrdReLoc:%String,PatAdmVisitStatus:%String,PatAdmDateTime:%String,DCARowIdStr:%String")
{
}

ClassMethod FindDocCureAppExecute(ByRef qHandle As %Binary, PatientID As %String, StartDate As %String, EndDate As %String, FinishDis As %String = "", PatName As %String = "", LogLocID As %String = "", LogUserID As %String = "", ApplyNo As %String = "", LongOrdPriority As %String = "", CheckAdmType As %String = "", queryArcim As %String = "", queryOrderLoc As %String = "", PacWardDr As %String = "") As %Status
{
	K DataArr
	s outCancel=""
	s TriageFlag=""
	s ExecFlag=""
    Set rset=##Class(%ResultSet).%New("DHCDoc.DHCDocCure.Apply:FindAllCureApplyListHUI")
	If rset.QueryIsValid(){ 
		Set Status=rset.Execute(PatientID, StartDate, EndDate, outCancel, FinishDis, PatName, TriageFlag, LogLocID, LogUserID, ApplyNo , LongOrdPriority, CheckAdmType, queryArcim, queryOrderLoc, ExecFlag) 
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s DCARowId=rset.Data("DCARowId")
			S PatNo=rset.GetData(2)
			s PatName=rset.GetData(3)
			s PatSex=rset.GetData(4)
			s PatAge=rset.GetData(5)
			s PatAdmDept=rset.Data("AdmDep")
			s OrdReLoc=rset.Data("OrdReLoc")
			s ApplyDateTime=rset.Data("ApplyDateTime")
			s AdmTypeDesc=rset.Data("AdmType")
			s Adm=$p(^DHCDocCure(DCARowId),"^",1)
			s CurrentWard=$P($g(^PAADM(Adm)),"^",70)
			continue:((PacWardDr'="")&(PacWardDr'=CurrentWard))
			s PatAdmWard=""
			s:CurrentWard'="" PatAdmWard=$P(^PAWARD(CurrentWard),"^",2)
			s BedDr=$P($g(^PAADM(Adm)),"^",73)
			s PatAdmBed=""
			s:BedDr'="" PatAdmBed=$P($G(^PAWARD(+BedDr,"BED",$P(BedDr,"||",2))),"^",1)
			s admreason=$p($g(^PAADM(Adm,1)),"^",7)
		 	s PatAdmReasonDesc=""
		 	if admreason'="" s PatAdmReasonDesc=$p($g(^PAC("ADMREA",admreason)),"^",2)
		 	s AdmType=$P($G(^PAADM(Adm)),"^",2)
			s PatMedicalNo=##class(web.DHCDocOrderCommon).GetMrNo(Adm,"",AdmType,"")
			s PatName=AdmTypeDesc_PatName
		 	s AdmVisitStatus=$P($g(^PAADM(Adm)),"^",20)
			s AdmVisitStatus=$case(AdmVisitStatus,"A":"有效",:"无效")
			s PAAdmDate=$P(^PAADM(Adm),"^",6)
		    s PAAdmTime=$p($g(^PAADM(Adm)),"^",7)
		    s:PAAdmDate'="" PAAdmDate=##class(websys.Conversions).DateLogicalToHtml(PAAdmDate)
		    s:PAAdmTime'="" PAAdmTime=$Zt(PAAdmTime)
		    s AdmDateStr=PAAdmDate_" "_PAAdmTime
    		
    		if '$d(DataArr(PatNo,Adm)){
	    		s DCARowIdStr=DCARowId	
	    	}else{
		    	s DCARowIdStr=$lg(DataArr(PatNo,Adm),14)
		    	if DCARowIdStr="" s DCARowIdStr=DCARowId
		    	else  s DCARowIdStr=DCARowIdStr_"^"_DCARowId
		    }
			s DataArr(PatNo,Adm)=$lb(Adm,PatNo,PatMedicalNo,PatName,PatSex,PatAge
			,PatAdmDept,PatAdmWard,PatAdmBed,PatAdmReasonDesc,OrdReLoc
			,AdmVisitStatus,AdmDateStr,DCARowIdStr)
		}
	}
	if $d(DataArr){
		s PatNo=""
		for{
			s PatNo=$o(DataArr(PatNo))
			Q:PatNo=""
			s Adm=""
			for{
				s Adm=$o(DataArr(PatNo,Adm))
				Q:Adm=""
				s Data=DataArr(PatNo,Adm)
				d OutputRowData
			}
		}	
	}
 	Quit $$$OK
OutputRowData
 	set qHandle($I(ind))=Data
	quit
}

ClassMethod FindDocCureAppFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDocCureAppExecute ]
{
 	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

/// 提供给护理组PDA治疗站接口:根据治疗申请ID信息，获取治疗申请详细信息
/// Remark：根据接口1返回的【本次就诊包含的治疗申请ID(多个以^分割)】查询对应调的治疗申请详细信息
/// Input:DCARowIdStr 		【必传】治疗申请ID信息,多个以^分割
///       LogLocID 			【必传】登录科室ID
///       LogUserID 		【必传】登录用户ID
/// OutPut:	申请单ID，登记号，患者姓名，患者性别，患者年龄，患者联系方式，就诊类型，就诊科室，治疗项目名称，医嘱数量
/// 		数量单位，接收科室，治疗申请状态(A申请 C取消 F完成)，申请医师，申请时间，已预约次数，未预约次数，预约已治疗次数，预约未治疗次数，医嘱总价（长期为空）
/// 		医嘱缴费，服务组，服务组ID，呼叫状态，直接执行or可预约,ControlFlag，HistoryTriRes，患者其他信息，医嘱单价，申请单号
/// 		接收科室ID，治疗申请状态代码，医嘱其他信息，频次代码，医嘱状态代码,医嘱ID，申请科室
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.OutInterface","FindCureAppInfo","24^25^26^27^28^29^30",44,4661) 
Query FindCureAppInfo(DCARowIdStr As %String, LogLocID As %String = "", LogUserID As %String = "") As %Query(ROWSPEC = "DCARowId:%String,PatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PatTel:%String,AdmType:%String,AdmDep:%String,ArcimDesc:%String,OrdQty:%String,OrdBillUOM:%String,OrdReLoc:%String,ApplyStatus:%String,ApplyUser:%String,ApplyDateTime:%String,ApplyAppedTimes:%String,ApplyNoAppTimes:%String,ApplyFinishTimes:%String,ApplyNoFinishTimes:%String,OrdPrice:%String,OrdBilled:%String,ServiceGroup:%String,ServiceGroupID:%String,CallStatus:%String,ApplyExec:%String,ControlFlag:%String,HistoryTriRes:%String,PatOther:%String,OrdUnitPrice:%String,ApplyNo:%String,OrdReLocId:%String,ApplyStatusCode:%String,OrdOtherInfo:%String,OrdFreqCode:%String,OrdStatusCode:%String,OrderId:%String,OrdAddLoc:%String,GroupFlag:%String,DCAMainDCADR:%String")
{
}

ClassMethod FindCureAppInfoExecute(ByRef qHandle As %Binary, DCARowIdStr As %String, LogLocID As %String = "", LogUserID As %String = "") As %Status
{
	if DCARowIdStr=""{
		Quit $$$OK	
	}else{
		set (PatientID, StartDate, EndDate, outCancel, FinishDis, PatName, TriageFlag, ApplyNo , LongOrdPriority, CheckAdmType, queryArcim, queryOrderLoc, ExecFlag)=""
		set DCARowIdStr=""_$c(1)_DCARowIdStr
		Set rset=##Class(%ResultSet).%New("DHCDoc.DHCDocCure.Apply:FindAllCureApplyListHUI")
		If rset.QueryIsValid(){ 
			Set Status=rset.Execute(PatientID, StartDate, EndDate, outCancel, FinishDis, PatName, TriageFlag, LogLocID, LogUserID, ApplyNo , LongOrdPriority, CheckAdmType, queryArcim, queryOrderLoc, ExecFlag,DCARowIdStr) 
			If 'Status Quit
			Set columns = rset.GetColumnCount()
			While (rset.Next()) {
				s newData=$lb()
				for nus1=1:1:columns{
					s $list(newData,nus1)=rset.GetData(nus1)
				}
				Do OutputRowCureApp
			}
		}
		/*	
		for loop=1:1:$L(DCARowIdStr,"^"){
			s DCARowId=$P(DCARowIdStr,"^",loop)
			continue:DCARowId=""
			
			s CureData=$g(^DHCDocCure(DCARowId))
		    s statu=$P(CureData,"^",3) 
			s Adm=$P(CureData,"^",1)
			continue:Adm=""
			s admreason=$p($g(^PAADM(Adm,1)),"^",7)
			s AdmVisitStatus=$P($g(^PAADM(Adm)),"^",20)
			s AppDate=$P(CureData,"^",5)
			s PAPMI=$P(^PAADM(Adm),"^",1)
			s AdmType=$P($G(^PAADM(Adm)),"^",2)
			s PatientName=$P($G(^PAPER(PAPMI,"ALL")),"^",1)
			s DCAOEORIDR=$P(CureData,"^",2)
		 	s OrdReLocId=""
			s:DCAOEORIDR'="" OrdReLocId=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),3)),"^",6)
			s reloc=""
			s:OrdReLocId'="" reloc=$P(^CTLOC(OrdReLocId),"^",2)
			s Arcim=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),1)),"^",2)
			continue:Arcim=""
			s OrderFreq=""
			s OrderFreqRowid=$P($G(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),2)),"^",4)
			s:OrderFreqRowid'="" OrderFreq=$P($G(^PHCFR(OrderFreqRowid)),"^",3)
			;按对照申请单对应的医嘱状态进行过滤
			s OrderStatusCode=""
			s OrderStatus=""
			s OrdStatusDR=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),1)),"^",13)
			s:OrdStatusDR'="" OrderStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1),OrderStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",2)
			//获取部位
			s BodyType=""
			s BodyParyDr=$P(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),"DHC"),"^",47)
			if BodyParyDr'=""  d
			.s inumBodt=$L(BodyParyDr,"!")
			.for inumBdoy=1:1:inumBodt  d
			..s bodydr=$P(BodyParyDr,"!",inumBdoy)
			..Q:bodydr=""
			..i BodyType="" s BodyType=$p($g(^MRC("BODP",bodydr)),"^",2)
			..else  s BodyType=BodyType_";"_$p($g(^MRC("BODP",bodydr)),"^",2)
			
			;住院 按照日期没有找到对应的执行记录不进行显示 只显示在范围日期内有需要处理的执行记录
			s ExecUum=0
			s CanDoNum=0
			if DCAOEORIDR'=""{
				if AdmType="I"{
					s time=""
					for{
						s time=$O(^OEORDi(0,"Date",+DCAOEORIDR,+$H,time))
						Q:time=""
						s OEOrdExec=0
						for{
							s OEOrdExec=$O(^OEORDi(0,"Date",+DCAOEORIDR,+$H,time,$p(DCAOEORIDR,"||",2),OEOrdExec))
							Q:OEOrdExec=""
							s StatusCode=""
							s OldStatusRowId=$P(^OEORD(+DCAOEORIDR,"I",$P(DCAOEORIDR,"||",2),"X",OEOrdExec),"^",16)
							if OldStatusRowId'="" s StatusCode=$P($G(^OEC("STAT",OldStatusRowId)),"^",1)
							if StatusCode=""{
								;计算住院的患者执当天未执行的记录次数 为当日可执行次数
								s ExecUum=(ExecUum+1)
							}
						}
					}
					s CanDoNum=ExecUum
				}else{
					;门诊的患者
					s Qty=##class(DHCDoc.DHCDocCure.Apply).GetOrderActiveQty(DCAOEORIDR)
					s subexec=0
					for{
						s subexec=$O(^OEORD(+DCAOEORIDR,"I",$P(DCAOEORIDR,"||",2),"X",subexec)) Q:subexec=""  d
						s OldStatusRowId=$P(^OEORD(+DCAOEORIDR,"I",$P(DCAOEORIDR,"||",2),"X",subexec),"^",16)
						s StatusCode=""
						if OldStatusRowId'="" s StatusCode=$P($G(^OEC("STAT",OldStatusRowId)),"^",1)
						if (StatusCode="F"){
							s ExecUum=(ExecUum+1)
						}
					}
					s CanDoNum=(Qty-ExecUum)
				}
			}
			
			s OrderPrior=""
			s OrderPriorRowid=$P($G(^OEORD(+DCAOEORIDR,"I",$P(DCAOEORIDR,"||",2),1)),"^",8)
			s:OrderPriorRowid'="" OrderPrior=$P($G(^OECPR(OrderPriorRowid)),"^",2)
			
			s ArcimDesc=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",2)
			s ArcimDesc=##class(ext.util.String).EvalJSON(ArcimDesc)
			;查询所对应得服务
			s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(Arcim)
			s ServiceGroupDR=""
			s GroupName=""
			if DDCISRowid'=""  d
			.s ServiceGroupDR=$p(^DHCDocCureItemSet(DDCISRowid),"^",3)
			.s GroupName=$p($g(^DHCDocCureRBCServiceGroupSet(ServiceGroupDR)),"^",2)
			
			s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice("", "", Arcim, +$H, "", "", "", "","","","","")
			s OrderPrice=$P(retPrice,"^",1)
			s DiscPrice=$P(retPrice,"^",2)
			s InsPrice=$P(retPrice,"^",3)
			s PatPrice=$P(retPrice,"^",4)
			s OrderDoseQty=+$P($G(^OEORD(+DCAOEORIDR,"I",$P(DCAOEORIDR,"||",2),2)),"^",1)
			s:OrderDoseQty=0 OrderDoseQty=1
			s sumDose=(OrderDoseQty*OrderPrice)
			s UserAdd=""
			s UserAdd=$p($g(^OEORD(+DCAOEORIDR,"I",$P(DCAOEORIDR,"||",2),7)),"^",1) ;下医嘱人
			if UserAdd'="" Set UserAdd=$P($G(^SSU("SSUSR",UserAdd)),"^",2)
			s OrderDate=$p($g(^OEORD(+DCAOEORIDR,"I",$P(DCAOEORIDR,"||",2),3)),"^",7)	;下医嘱日期
			if OrderDate'="" s OrderDate=$zd(OrderDate,3)
			s OrderTime=$p($g(^OEORD(+DCAOEORIDR,"I",$P(DCAOEORIDR,"||",2),1)),"^",17)	;下医嘱时间
			if OrderTime'="" s OrderTime=$zt(OrderTime,2)
			s OrderSttDate=OrderDate_" "_OrderTime
			s OrderBillFlag=..OrderBillStatu(DCARowId)
			s ApplyNo=$p(CureData,"^",18)
			Do OutputRowCureApp
		}*/
	}
 	Quit $$$OK
OutputRowCureApp
	;set Data=$lb(DCARowId,CanDoNum,ArcimDesc,OrderStatus,OrderStatusCode,GroupName,reloc,AdmVisitStatus,OrderPrior,DCAOEORIDR,OrderFreq,AdmType,PatientName,BodyType,UserAdd,OrderDoseQty,OrderPrice,sumDose,OrderBillFlag,OrderSttDate,ApplyNo)
 	set qHandle($I(ind))=newData
	quit
}

ClassMethod FindCureAppInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureAppInfoExecute ]
{
 	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

/// 查看治疗申请单的计费情况
/// 
/// 0 无需判断 1 全部计费 2 部份计费 3 未计费 
ClassMethod OrderBillStatu(AppDr As %String, BillDate As %String = "") As %String
{
	s $zt="errorOrderBillStatu"
	s:BillDate="" BillDate=+$H
	s Adm=$p($g(^DHCDocCure(+AppDr)),"^",1)
	Q:Adm="" 0
	s DCAOEORIDR=$p($g(^DHCDocCure(+AppDr)),"^",2)
	Q:DCAOEORIDR="" 0
	s Arcim=$p($g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),1)),"^",2)
	s OrderFreqRowid=$P($G(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),2)),"^",4) 
	s FreqFacter=""
	s:OrderFreqRowid'="" FreqFacter=$P($G(^PHCFR(OrderFreqRowid)),"^",2)
	s AdmType=$P(^PAADM(Adm),"^",2)
	Q:AdmType'="I" 0
	
	;按照医嘱临时和长期过滤
	s OrderPriorRowid=$P($G(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),1)),"^",8)
	s IsLongFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(OrderPriorRowid)
	
	s wjfnum=0
	s toolnum=0
	s OrderExecChild=0
	f  s OrderExecChild=$o(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),"X",OrderExecChild)) Q:OrderExecChild=""  d
	.s execdata=$g(^OEORD(+DCAOEORIDR,"I",$p(DCAOEORIDR,"||",2),"X",OrderExecChild))
	.s OEOREExStDate=$p(execdata,"^",1)
	.Q:(OEOREExStDate'=BillDate)&(IsLongFlag=1)
	.s OEOREStatusDr=$p(execdata,"^",16)
	.s OEOREStatus="",OEOREStatusCode=""
	.s:OEOREStatusDr'="" OEOREStatus=$P($G(^OEC("STAT",OEOREStatusDr)),"^",2),OEOREStatusCode=$P($G(^OEC("STAT",OEOREStatusDr)),"^",1)
	.Q:(OEOREStatusCode="D")||(OEOREStatusCode="C")
	.s toolnum=(toolnum+1)
	.s OEOrdExecBill=$p(execdata,"^",6)
	.s OEOrdExecBillDesc=$case(OEOrdExecBill,"B":"已计费","P":"已计费",:"未计费")
	.if (OEOrdExecBill'="B")&(OEOrdExecBill'="P")  d
	..s wjfnum=(wjfnum+1)
	Q:toolnum=0 0 //无执行记录的情况 不判断计费状态
	Q:wjfnum=0 1
	Q:toolnum=wjfnum 3
	q 2
errorOrderBillStatu
	q 0
}

/// 护理组PDA执行接口：根据申请单ID获取医嘱ID
/// Input:DCARowIdStr 申请单ID，多个以^分割
/// Output:OrderIDStr 医嘱ID，多个以^分割
/// Debug:w ##class(DHCDoc.DHCDocCure.OutInterface).GetOrderByDCADr("4^25^26^27^28^29^30")
ClassMethod GetOrderByDCADr(DCARowIdStr As %String) As %String
{
	n (DCARowIdStr)
	s RtnStr=""
	for loop=1:1:$L(DCARowIdStr) d
	.s DCARowId=$P(DCARowIdStr,"^",loop)
	.Q:DCARowId=""
	.s DCAOEORIDR=$p($g(^DHCDocCure(+DCARowId)),"^",2)
	.Q:DCAOEORIDR=""
	.if RtnStr=""  d
	..s RtnStr=DCAOEORIDR
	.else  d
	..s RtnStr=RtnStr_"^"_DCAOEORIDR
	q RtnStr
}

}
