Class DHCDoc.DHCDocCure.ExecApply Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 查询预约记录
/// ;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.ExecApply","FindCureExecList","12!13","","","","2019-12-28")
/// DCARowId,OEORERowID,PapmiNo,PatientName,ArcimDesc,OEOREExStDate,OEOREStatus,OEOREQty,OEOREUpUser,OEOREExDate
Query FindCureExecList(DCARowId As %String, OnlyNoExcute As %String, OnlyExcute As %String = "", StartDate As %String = "", EndDate As %String = "", SessionStr As %String = "") As %Query(ROWSPEC = "DCARowId:%String,OEORERowID:%String,PapmiNo:%String,PatientName:%String,ArcimDesc:%String,OEOREExStDate:%String,OEOREStatus:%String,OEOREQty:%String,OEOREUpUser:%String,OEOREExDate:%String,ApplyDate:%String,OEOREType:%String,DCRRowId:%String,DCRContent:%String,ApplyStatusCode:%String,ApplyStatus:%String,DCRCureDate:%String,DCRResponse:%String,DCREffect:%String,OEOREStatusCode:%String,OEOREAppointFlag:%String,DCAApplyNo:%String,DCRIsPicture:%String,NoFinishTimes:%String,ISPRNOrder:%String,DCRMapID:%String,OEORETransType:%String,AllowExecMsg:%String")
{
}

ClassMethod FindCureExecListExecute(ByRef qHandle As %Binary, DCARowIdStr As %String, OnlyNoExcute As %String, OnlyExcute As %String = "", StartDate As %String = "", EndDate As %String = "", SessionStr As %String = "") As %Status
{
	s langid=$p(SessionStr,"^",6)
	s:langid="" langid=..%LanguageID()
	s ^TMP("FindCureExecListExecute")=$lb(DCARowIdStr,OnlyNoExcute,OnlyExcute,StartDate,EndDate)
	if DCARowIdStr="" Quit $$$OK
	if StartDate'=""{
		s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)	
	}
	if EndDate'=""{
		s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)	
	}
	s DCARowIdLen=$l(DCARowIdStr,"!")
	for mycount=1:1:DCARowIdLen{
		s DCARowId=$P(DCARowIdStr,"!",mycount)
		s CureData=$g(^DHCDocCure(DCARowId))
		s Adm=$p(CureData,"^",1)
		continue:Adm=""
		s PatientId=$P($G(^PAADM(Adm)),"^",1)
		s PapmiNo=##Class(web.PAPatMas).GetRegistration(PatientId)
 		s PatientName=$P($G(^PAPER(PatientId,"ALL")),"^",1)
		s OrderId=$p(CureData,"^",2)
		continue:OrderId=""
		s ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
		continue:ArcimId=""
		continue:##class(DHCDoc.DHCDocCure.Apply).CheckActiveExec(OrderId)=0
		s AdmType=$p($g(^PAADM(Adm)),"^",2)
		s AdmType=$case(AdmType,"I":"住院","E":"急诊","O":"门诊",:"")
		s ApplyStatusCode=$p(CureData,"^",3)
		s ApplyStatus=##class(DHCDoc.DHCDocCure.Apply).GetApplyStatus(DCARowId)
		s ApplyDate=$p(CureData,"^",5)
		s ApplyTime=$p(CureData,"^",6)
		s ApplyNo=$p(CureData,"^",18)
		s ApplyDate=##class(websys.Conversions).DateLogicalToHtml(ApplyDate) ;$zd(ApplyDate,3)
		s ApplyTime=$zt(ApplyTime)
		s ApplyDate=ApplyDate_" "_ApplyTime
		s ArcimDesc=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)
		s ArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcimDesc,langid)
		s ArcimDesc=##class(ext.util.String).EvalJSON(ArcimDesc)
		s OrderStatus="",OrderStatusCode=""
		s OrdStatusDR=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",13)
		s:OrdStatusDR'="" OrderStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1),OrderStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",2)
		;continue:(OrderStatusCode'="V")&&(OrderStatusCode'="E")
		s OrdPHFreqDR=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),2)),"^",4)
		s PriorityDR=$p($g(^OEORD(+OrderId,"I",+$p(OrderId,"||",2),1)),"^",8)
		s Priority=$p(^OECPR(PriorityDR),"^",2)
		s AdmType=AdmType_$tr(Priority,"医嘱","")
		s OEORETransType=##class(websys.Translation).Get("doccure.emr.cureapplist.hui.csp",AdmType)
		s NoFinishTimes=##class(DHCDoc.DHCDocCure.Apply).GetApplyNoAppTimes(DCARowId)
		s ISPRNOrder=##class(appcom.OEOrdItem).ISPRNOrder(OrderId) 
		s floop=0
		s OrderPar=+OrderId
		s OrderChild=$p(OrderId,"||",2)
		s OrderExecChild=0
		for{
			s OrderExecChild=$o(^OEORD(OrderPar,"I",OrderChild,"X",OrderExecChild))
			Q:OrderExecChild=""
			s OEORERowID=OrderId_"||"_OrderExecChild
			s execdata=$g(^OEORD(OrderPar,"I",OrderChild,"X",OrderExecChild))
			s OEOREStatus=$p(execdata,"^",16)
			s OEOREStatusCode=""
			s:OEOREStatus'="" OEOREStatusCode=$p(^OEC("STAT",OEOREStatus),"^",1),OEOREStatus=$p(^OEC("STAT",OEOREStatus),"^",2)
			s OEOREStatus=##class(User.OECOrderAdminStatus).GetTranByDesc("STATDesc",OEOREStatus,langid)
			continue:(OnlyNoExcute="ON")&&((OEOREStatusCode'="")&&(OEOREStatusCode'="C"))
			continue:(OnlyExcute="Y")&&(OEOREStatusCode'="F")
			s OEOREExStDate=$p(execdata,"^",1)
			continue:(StartDate'="")&&(OEOREExStDate<StartDate)
			continue:(EndDate'="")&&(OEOREExStDate>EndDate)
			s:OEOREExStDate'="" OEOREExStDate=##class(websys.Conversions).DateLogicalToHtml(OEOREExStDate) ;$zd(OEOREExStDate,3)
			s OEOREExStTime=$p(execdata,"^",2)
			s:OEOREExStTime'="" OEOREExStTime=$zt(OEOREExStTime,1)
			s OEOREExStDate=OEOREExStDate_" "_OEOREExStTime
			s AppointFlag=##class(DHCDoc.DHCDocCure.Appointment).GetExecResultAppStatus(OEORERowID)
			s AppointFlag=$case(AppointFlag,"1":##class(websys.Translation).Get("doccure.cureapplist.hui.csp","已预约"),:"")
			s OEOREQty=..GetQtyByExecID(OEORERowID)
			s OEOREUpUser=$p(execdata,"^",15)
			s:OEOREUpUser'="" OEOREUpUser=$p(^CTPCP(OEOREUpUser,1),"^",2)
			s OEOREUpUser= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",OEOREUpUser,langid)
			s OEOREExDate=$p(execdata,"^",19)
			s:OEOREExDate'="" OEOREExDate=##class(websys.Conversions).DateLogicalToHtml(OEOREExDate) ;$zd(OEOREExDate,3)
			s OEOREExTime=$p(execdata,"^",20)
			s:OEOREExTime'="" OEOREExTime=$zt(OEOREExTime,1)
			s OEOREExDate=OEOREExDate_" "_OEOREExTime
			s DCRRowId=##class(DHCDoc.DHCDocCure.Record).GetDCRRowID("",OEORERowID)
			s (DCRContent,DCRCureDate,DCRResponse,DCREffect,DCRIsPicture,DCRMapID)=""
			if DCRRowId'=""{
				s RecordStr=##class(DHCDoc.DHCDocCure.Record).GetCureRecord(DCRRowId)
				s DCRContent=$p(RecordStr,"^",4)
				s DCRIsPicture=$p(RecordStr,"^",11)
				s DCRCureDate=$p(RecordStr,"^",12)
				s DCRResponse=$p(RecordStr,"^",13)
				s DCREffect=$p(RecordStr,"^",14)
				s DCRMapID=$p(RecordStr,"^",22)
			}
			s floop=floop+1
			s:floop>1 ApplyDate="<font style='color:red'>-</font>"
			s AllowExecMsg=..CheckBeforeExec(DCARowId,"",OEORERowID,SessionStr)
			d OutputRowCureExec
		}
	}
	Quit $$$OK
OutputRowCureExec
	set Data=$lb(DCARowId,OEORERowID,PapmiNo,PatientName,ArcimDesc,OEOREExStDate,OEOREStatus,OEOREQty,OEOREUpUser,OEOREExDate,ApplyDate,AdmType,DCRRowId,DCRContent,ApplyStatusCode,ApplyStatus,DCRCureDate,DCRResponse,DCREffect,OEOREStatusCode,AppointFlag,ApplyNo,DCRIsPicture,NoFinishTimes,ISPRNOrder,DCRMapID,OEORETransType,AllowExecMsg)
 	set qHandle($I(ind))=Data
	quit
}

ClassMethod FindCureExecListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureExecListExecute ]
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

ClassMethod GetSTFreqRowid()
{
	set STFreqRowid=$O(^PHCFR(0,"Code","ST",0))	
	Q STFreqRowid
}

/// w ##class(DHCDoc.DHCDocCure.ExecApply).GetQtyByExecID("80||87||1")
ClassMethod GetQtyByExecID(ExecRowID)
{
	new (ExecRowID)
	set OrderID=+ExecRowID
	set OrderSubID=$p(ExecRowID,"||",2)
	set OrderExecSubID=$p(ExecRowID,"||",3)
	set Adm=$p(^OEORD(OrderID),"^",1)
	set AdmType=$p($g(^PAADM(Adm)),"^",2)
	
	if AdmType="I"{
		set OrdExecBillInfo=##class(web.DHCBillInterface).IGetOrdEexcBillPrice(ExecRowID)
		set OrdExecBillQty=$p(OrdExecBillInfo,"^",2)
	}else{
		set OrdPHFreqDR=$p($g(^OEORD(+OrderID,"I",OrderSubID,2)),"^",4)
		set OrdExecData=$g(^OEORD(OrderID,"I",OrderSubID,"X",OrderExecSubID))
		set OEOREQty=$p(OrdExecData,"^",4)
		set OEOREAdminQty=+$p(OrdExecData,"^",5)
		set STFreqRowid=..GetSTFreqRowid()
		if ((OrdPHFreqDR="")||(OrdPHFreqDR=STFreqRowid)||(OEOREQty=0))&&(OEOREAdminQty>0){
			set OrdExecBillQty=OEOREAdminQty
		}else{
			set OrdExecBillQty=OEOREQty
		}
	}
	;set OrdExecBillQty=$fn(OrdExecBillQty,"N",2)
	Quit OrdExecBillQty
}

ClassMethod UpdateQtyByExecID(ExecRowID, Qty)
{
	new (ExecRowID,Qty)
	set OrdPHFreqDR=$p($g(^OEORD(+ExecRowID,"I",$p(ExecRowID,"||",2),2)),"^",4)
	set STFreqRowid=..GetSTFreqRowid()
	set execobj=##class(User.OEOrdExec).%OpenId(ExecRowID)
	set PhQtyOrd=execobj.OEOREPhQtyOrd
	set AdminQty=execobj.OEOREQtyAdmin
	if ((OrdPHFreqDR="")||(OrdPHFreqDR=STFreqRowid)||(PhQtyOrd=0))&&(AdminQty>0){
		set execobj.OEOREQtyAdmin=Qty
	}else{
		set execobj.OEOREPhQtyOrd=Qty
	}
	
	set sc=execobj.%Save()
	If $$$ISERR(sc){
	    Quit "-101"
    }
	do execobj.%Close()
	
	Quit 0
}

/// w ##class(DHCDoc.DHCDocCure.ExecApply).ReplaceOneOrdExec("1504||3||5",1,1)
ClassMethod ReplaceOneOrdExec(ExecRowID, Qty, UserDR)
{
	new (ExecRowID,Qty,UserDR)
	Ts
	s rtn=##class(appcom.OEOrdExec).UpdateStatus(ExecRowID,"D",UserDR,+$H,"","")
	if rtn'=0{
		Trollback
		Quit rtn
	}
	s OrdPHFreqDR=$p($g(^OEORD(+ExecRowID,"I",$p(ExecRowID,"||",2),2)),"^",4)
	s STFreqRowid=..GetSTFreqRowid()
	s execobj=##class(User.OEOrdExec).%OpenId(ExecRowID)
	s ExecDoseQty=execobj.OEOREPhQtyOrd
	s ExecAdminQty=execobj.OEOREQtyAdmin
	s ExecSTDate=execobj.OEOREExStDate
	s ExecSTTime=execobj.OEOREExStTime
	if ((OrdPHFreqDR="")||(OrdPHFreqDR=STFreqRowid)||(ExecDoseQty=0))&&(ExecAdminQty>0){
		s ExecAdminQty=Qty
	}else{
		s ExecDoseQty=Qty
	}
	s OrdItemID=$p(ExecRowID,"||",1,2)
	s ExecInsSeqNo=0
	s child=0 
	for{
		s child= $o(^OEORD($p(OrdItemID,"||",1),"I",$p(OrdItemID,"||",2),"X",child))
		q:child=""
		s InsSeqNo=$p(^OEORD($p(OrdItemID,"||",1),"I",$p(OrdItemID,"||",2),"X",child),"^",34)
		s:InsSeqNo>ExecInsSeqNo ExecInsSeqNo=InsSeqNo
	}
	s ExecInsSeqNo=ExecInsSeqNo+1
	
	s ItemStatus=$p(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),1),"^",13)
	s OrderStatusCode=$S(ItemStatus'="":$P(^OEC("OSTAT",ItemStatus),"^",1),1:"")
	if $g(OrderStatusCode)'="V" {
		s NewItemStatus=$O(^OEC("OSTAT",0,"Code","V",0))
		&SQL(Update SqlUser.OE_OrdItem Set OEORI_ItemStat_DR=:NewItemStatus Where OEORI_RowId=:OrdItemID)
		i SQLCODE {
			TRO
			Quit SQLCODE
		}
	}
	
	s InsRtn=$$InsOEORE^DHCOEOrdExec(OrdItemID,ExecSTDate,ExecSTTime,ExecDoseQty,"",ExecAdminQty,ExecInsSeqNo,"","","")
	if InsRtn["^"{
		s rtn=$p(InsRtn,"^",1)
		s InsOrdExecID=$p(InsRtn,"^",2)
	}else{
		s rtn=+	InsRtn
	}
	if rtn'=0{
		Trollback
		Quit rtn
	}
	if $g(OrderStatusCode)'="V"{
		&SQL(Update SqlUser.OE_OrdItem Set OEORI_ItemStat_DR=:ItemStatus Where OEORI_RowId=:OrdItemID)
		i SQLCODE {
			TRO
			Quit SQLCODE
		}
	}
	Tc
	Quit 0
}

/// Desc:  执行操作前检查判断
/// Input: ExecType 检查类型：E 执行 ;C 撤销执行
ClassMethod CheckBeforeUpdateExec(DCARowId As %String, UserID As %String, OEORERowID As %String = "", ExecType As %String = "", ByRef ExecAry As %String = "")
{
	n (DCARowId,UserID,%session,OEORERowID,ExecType,ExecAry)
	s ErrMsg=""
	if DCARowId=""{
		s ErrMsg="申请单信息不能为空"
		Q ErrMsg
	}
	if '$D(^DHCDocCure(DCARowId)){
		s ErrMsg="申请单信息不存在"
		Q ErrMsg
	}
	s Adm=$p($g(^DHCDocCure(+DCARowId)),"^",1)
	if Adm=""{
		s ErrMsg="申请单就诊为空"
		Q ErrMsg
	}
	s PatientId=$P($G(^PAADM(Adm)),"^",1)
	s AdmType=$p($g(^PAADM(Adm)),"^",2)
	s AdmStatus=$P($g(^PAADM(Adm)),"^",20)
	s OrderId=$p($g(^DHCDocCure(+DCARowId)),"^",2)
	if OrderId=""{
		s ErrMsg="申请单对应医嘱为空"
		Q ErrMsg
	}
	s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	;if (ExecType="E")&&(ApplyStatus="C"){
		;s ErrMsg="已经撤销的申请单不能进行操作."
		;Q ErrMsg
	;}
	s ret=##class(DHCDoc.DHCDocCure.Appointment).CheckAdmType(Adm,OrderId)
	if ret'=0{
		s ErrMsg=$case(ret,"108":"医嘱未缴费,不能执行","1081":"患者已出院,无法进行操作.","1082":"患者已退号,无法进行操作.",:ret)
		Q ErrMsg
	}
	if OEORERowID'=""{
		s ret=##class(DHCDoc.DHCDocCure.Invoke).CheckFeeControl(OEORERowID,.ErrMsg)
		if ret'=0{
			Q ErrMsg
		}
		s OrderId=$p(OEORERowID,"||",1,2)
	}
	if $d(ExecAry){
		k NewExecAry
		if $d(ExecAry("CureExpJsonStr")){
			m ParaExpArr=ExecAry("CureExpJsonStr")
			s ParaID=""
			for{
				s ParaID=$o(ParaExpArr(ParaID)) 
				Q:ParaID=""
				s EleID=$g(ParaExpArr(ParaID,"ID"))	
				s EleVal=$g(ParaExpArr(ParaID,"Val"))
				s NewExecAry(EleID)=EleVal	
			}
		}
		s DCRCureDate=$g(NewExecAry("DCRCureDate"))
		s chk=$$CheckDateTime(DCRCureDate)
		if chk=0{
			s ErrMsg="治疗起始时间不能早于医嘱开始时间"
			Q ErrMsg	
		}
		s DCRCureEndDate=$g(NewExecAry("DCRCureEndDate"))
		s chk=$$CheckDateTime(DCRCureEndDate)
		if chk=0{
			s ErrMsg="治疗结束时间不能早于医嘱开始时间"
			Q ErrMsg	
		}
		s DCRCureExecDate=$g(NewExecAry("DCRCureExecDate"))
		s chk=$$CheckDateTime(DCRCureExecDate)
		if chk=0{
			s ErrMsg="治疗执行时间不能早于医嘱开始时间"
			Q ErrMsg	
		}	
	}
	
	/*
	s ret=..CheckOEOREExStDate(OEORERowID)
	if ret'=""{
		s ErrMsg=ret
		Q ErrMsg
	}
	*/
	q ""
CheckDateTime(DateTime)
	Q:DateTime="" 1
	s OrdSttDate=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",9)
	s OrdSttTime=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",10)
	s Date=$p(DateTime," ",1)
	s Date=##class(websys.Conversions).DateHtmlToLogical(Date)
	s Time=$p(DateTime," ",2)
	s Time=$zth(Time,1)
	if (Date<OrdSttDate)!((Date=OrdSttDate)&&(Time<OrdSttTime)){
		Q 0
	}
	Q 1
}

ClassMethod CheckOEOREExStDate(OEORERowID)
{
	if OEORERowID'=""{
		s execdata=$g(^OEORD(+OEORERowID,"I",$p(OEORERowID,"||",2),"X",$p(OEORERowID,"||",3)))	
		s OEOREExStDate=$p(execdata,"^",1)
		if OEOREExStDate>+$h{
			Q "-1 只能执行当天或者当天之前的记录"
			
		}
	}
	Q ""
}

/// Desc:执行/撤销执行配置为“直接执行”的治疗申请
/// 	 当Resource为空时，即为直接执行，需要更新执行记录
///      传入"Record"时，即为治疗记录添加，本身调用AppArrive方法已更新执行记录
/// Input:	DCARowId:申请单ID 
/// 		UserID:操作用户ID 
/// 		EexcNum:执行数量 
/// 		Type:执行类型(执行Or撤销执行) 
/// 		Resource:操作来源 直接执行：空 ; 添加治疗记录:"Record"
/// 		OEOREDRStr:执行记录ID
/// w ##class(DHCDoc.DHCDocCure.ExecApply).ExecCureApply(77,4661,2,"E","","636||3||1","44")
ClassMethod ExecCureApply(DCARowId As %String, UserID As %String, EexcNum As %String, Type As %String, Resource As %String = "", OEOREDRStr As %String = "", LocDeptDr As %String = "", LogHospId As %String = "", DateExecuted As %String = "", TimeExecuted As %String = "", TransExpStr As %String = "") As %String
{
	n (DCARowId,UserID,EexcNum,Type,Resource,OEOREDRStr,LocDeptDr,%session,LogHospId,DateExecuted, TimeExecuted,TransExpStr)
	i ($g(LogHospId)="")&&($d(%session)) s LogHospId=%session.Get("LOGON.HOSPID")
	s ^tmplog("ExecCureApply")=$lb(DCARowId,UserID,EexcNum,Type,Resource,OEOREDRStr,LocDeptDr,LogHospId)
	s langid=$p(TransExpStr,"^",1)
	s cspName=$p(TransExpStr,"^",2)
	s:langid="" langid=..%LanguageID()
	s:cspName="" cspName="doccure.cureapplist.hui.csp"
	s checkret=..CheckBeforeUpdateExec(DCARowId,UserID,"",Type)
	Q:checkret'="" "-1 "_..%Translate(cspName,checkret,langid)
	s AppEexcNum=+$p(^DHCDocCure(DCARowId),"^",15)
	if Type="C" s EexcNum=-EexcNum
	s AppEexcNum=AppEexcNum+EexcNum
	s CureData=$g(^DHCDocCure(+DCARowId))
	s OrderId=$p(CureData,"^",2)
	s ApplyStatus=$p(CureData,"^",3)
	s OrderQty=+##class(DHCDoc.DHCDocCure.Apply).GetOrderActiveQty(OrderId) ;$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",12)
	S AppedSum=+##class(DHCDoc.DHCDocCure.Appointment).GetApplyAppInfo(DCARowId)
	s PriorityDR=$p($g(^OEORD(+OrderId,"I",+$p(OrderId,"||",2),1)),"^",8)
	s Statu="F"
	if ApplyStatus="C"{
		s Statu=ApplyStatus
	}elseif  (Type'="E")!(AppEexcNum=0)!(AppEexcNum<OrderQty)!(##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)){
		s Statu=ApplyStatus
		s DHCDocCureNeedTriage=##class(DHCDoc.DHCDocCure.Config).GetCureLocConfig(+DCARowId,"CureLocNeedTriage",LocDeptDr,LogHospId)
		if DHCDocCureNeedTriage=1 s Statu="D"
		else  s Statu="A"
	}
	s NowDate=+$H
	s NowTime=$P($H,",",2)
	S FinishDate="",FinishTime=""
	if (Statu="F"){
		s FinishDate=NowDate
		s FinishTime=NowTime
	}
	Ts
	&sql(update SQLUser.DHC_DocCureApp set DCA_Status=:Statu,DCA_UpdateUser_DR=:UserID,DCA_FinishUser_DR=:UserID,
	DCA_UpdateDate=:NowDate,DCA_UpdateTime=:NowTime,DCA_ExecNum=:AppEexcNum where DCA_RowId=:DCARowId)
	s myrtn=SQLCODE
	if myrtn'=0{
		Tro
		Q myrtn_" "_..%Translate(cspName,"更新申请单信息错误",langid)
	}else{
		&sql(insert into sqluser.DHC_DocCure_AppExecChange(DCAEC_ParRef,DCAEC_Date,DCAEC_Time,DCAEC_User_DR,DCAEC_Type,DCAEC_ExecNum,DCAEC_LastUpdateDate,DCAEC_LastUpdateTime) 
   		values(:DCARowId,:NowDate,:NowTime,:UserID,:Type,:EexcNum,:NowDate,:NowTime))
   		
   		s myrtn=SQLCODE
		if myrtn'=0{
			Tro
			Q myrtn_" "_..%Translate(cspName,"插入申请单执行变更记录错误",langid)
		}
	}
	b ;点击执行(撤销执行除外)的时候会将呼叫状态清空
	if Type="E"{
		s ret=##class(DHCDoc.DHCDocCure.CureCall).UpdateTreatCallStatus(DCARowId,"")
		if ret
	    {
		    Trollback
			Quit ret
		}
		d ##class(DHCDoc.DHCDocCure.Triage).UpdateTriageStatus(DCARowId,UserID)
	}
	
	if Resource=""{
		if OEOREDRStr=""{
			Trollback
			Q "-800"_" "_..%Translate(cspName,"执行记录为空",langid)
		}
		
		s ctpcpId=$p(^SSU("SSUSR",UserID),"^",14)
		if ctpcpId=""{
			Trollback
			Q "-801"_" "_..%Translate(cspName,"医护人员信息出错",langid)	
		}
		if Type="E"{
			s NewStatusCode="F"
			s StatusRowId=$O(^OEC("OSTAT",0,"Code","E",0))  
		}elseif Type="S"{
			s NewStatusCode="D"	
			s StatusRowId=$O(^OEC("OSTAT",0,"Code","D",0))	
		}else{
			s NewStatusCode="C"	
			s StatusRowId=$O(^OEC("OSTAT",0,"Code","V",0))  
		}
		s OEOREDR=OEOREDRStr
		if Type'="E"{
			s DCRRowId=##class(DHCDoc.DHCDocCure.Record).GetDCRRowID("",OEOREDR)
			if DCRRowId'=""{
				s myrtn=##class(DHCDoc.DHCDocCure.Record).CancelRecord(DCRRowId,UserID,"Y")
				if +myrtn'=0{
					Trollback
					Q myrtn_" "_..%Translate(cspName,"更新治疗记录错误",langid)	
				}
			}
		}
		s ErrMsg=""
		s myrtn=##class(appcom.OEOrdExec).UpdateStatus(OEOREDR,NewStatusCode,UserID,DateExecuted,TimeExecuted,"","","",LocDeptDr,"","",.ErrMsg)
		if myrtn'=0{
			Trollback
			Q myrtn_" "_..%Translate(cspName,"更新执行记录错误",langid)_":"_..%Translate(cspName,ErrMsg,langid)
		}
		if NewStatusCode'="D"{
			&SQL(Update SQLUser.OE_OrdExecExt Set OEORE_OrderStatus_DR=:StatusRowId Where OEORE_RowId=:OEOREDR)
		    if SQLCODE
		    {
			    Trollback
				Quit SQLCODE_" "_..%Translate(cspName,"更新执行记录扩展表错误",langid)
			}
		}
	}
	Tc
	q myrtn
}

/// 获取长期治疗医嘱的已治疗次数和未治疗次数
/// 入参：DCARowId:申请单ID
ClassMethod GetLongCureApplyInfo(DCARowId As %String) As %String
{
	s ApplyFinishTimes=0,ApplyNoFinishTimes=0
	Set CureData=$g(^DHCDocCure(DCARowId))
	Set OrderId=$p(CureData,"^",2)
	s Childsub=0
	f  s Childsub=$o(^OEORD(+OrderId,"I",$p(OrderId,"||",2),"X",Childsub)) q:Childsub=""  d
	.s Data=$g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),"X",Childsub))
	.s ExecStatusDR=$p(Data,"^",16)
	.s OEOREQty=..GetQtyByExecID(OrderId_"||"_Childsub)
	.s ExecStatusCode=""
	.i ExecStatusDR'="" s ExecStatusCode=$p($g(^OEC("STAT",ExecStatusDR)),"^",1)
	.i (ExecStatusCode="")||(ExecStatusCode="C") s ApplyNoFinishTimes=ApplyNoFinishTimes+OEOREQty
	.i ExecStatusCode="F" s ApplyFinishTimes=ApplyFinishTimes+OEOREQty
	Q ApplyFinishTimes_"^"_ApplyNoFinishTimes
}

ClassMethod CheckBeforeExec(DCARowId As %String, UserID As %String, OEORERowID As %String, SessionStr As %String = "")
{
	n (DCARowId,UserID,OEORERowID,SessionStr,%session)
	s HOSPID=$p(SessionStr,"^",4)
	s:(HOSPID="")&&($d(%session)) HOSPID=%session.Get("LOGON.HOSPID")
	
	s CureAppVersion=##Class(DHCDoc.DHCDocCure.Config).GetCureConfigPara("CureAppVersion",HOSPID)
	if CureAppVersion="V1"{
		s AppStatus=##class(DHCDoc.DHCDocCure.Appointment).GetExecResultAppStatus(OEORERowID)
		if AppStatus=1{
			Q "该执行记录存在预约记录,请到治疗处理进行治疗记录添加."	
		}	
	}

	s DCRRowId=##class(DHCDoc.DHCDocCure.Record).GetDCRRowID("",OEORERowID)
	if DCRRowId'=""{
		Q "该执行记录已执行,不允许添加治疗记录,如需修改,请使用浏览执行进行修改."	
	}
	s execdata=$g(^OEORD(+OEORERowID,"I",$p(OEORERowID,"||",2),"X",$p(OEORERowID,"||",3)))
	s OEOREStatus=$p(execdata,"^",16)
	s OEOREStatusCode=""
	s:OEOREStatus'="" OEOREStatusCode=$p(^OEC("STAT",OEOREStatus),"^",1)
	if OEOREStatusCode="D"{
		Q "该执行记录已停止执行,不允许添加治疗记录."
	}
	
	s checkret=..CheckBeforeUpdateExec(DCARowId,UserID,OEORERowID)
	if checkret'=""{
		Q checkret
	}
	q ""
}

ClassMethod CheckAddExec(OEORDRowID As %String)
{
	n (OEORDRowID)
	set DCARowID=$o(^DHCDocCure(0,"OEORI",OEORDRowID,""))	
	if (DCARowID=""){
		Q ""
	}
	s PriorityDR=$p($g(^OEORD(+OEORDRowID,"I",+$p(OEORDRowID,"||",2),1)),"^",8)
	s ApplyStatus=$p($g(^DHCDocCure(+DCARowID)),"^",3)
	s ApplyExecFlag=$p($g(^DHCDocCure(+DCARowID)),"^",19)
	if ##class(appcom.OEOrdItem).ISShortOrderPrior(PriorityDR) {
		if ApplyExecFlag="Y" Set ApplyExec="直接执行"
		else  Set ApplyExec="可预约"
	}else{
		Set ApplyExec="直接执行(长期)"
	}
	s title=""
	if (ApplyStatus = "F"){
		s title = "治疗申请已完成,不能增加!"
	}elseif (ApplyExec'["直接执行"){
		s title = "治疗申请非直接执行医嘱，不能增加!"
	}
	q title
}

}
