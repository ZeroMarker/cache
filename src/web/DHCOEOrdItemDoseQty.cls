Class web.DHCOEOrdItemDoseQty Extends DHCDoc.Util.RegisteredObject
{

/// 新插医嘱调用,生成默认的使用剂量数据
/// w ##class(web.DHCOEOrdItemDoseQty).InsertDoseQty("140008337||32")
ClassMethod InsertDoseQty(OEORIRowid)
{
	s PriorityDR=$p($g(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),1)),"^",8)
  	q:PriorityDR="" 0
  	q:'##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR) 0
	s FreqDispTimeDoseQtyStr=$P($G(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),"DHC")),"^",59)
	q:FreqDispTimeDoseQtyStr="" 0
	//s FreqDispTimeStr=##Class(web.DHCOEOrdItemView).GetFreqFreqDispTimeStr(OrderFreqRowid)

	s SttDate=$p($g(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),1)),"^",9)
	s SttTime=$p($g(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),1)),"^",10)
	s SttDateStr=..%ZD(SttDate)_" "_..%ZT(SttTime)
	s UserAdd=$p($g(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),7)),"^",1)
	s FirstDayFreqDispTimeDoseQtyStr=$P(FreqDispTimeDoseQtyStr,"@",2)
	s FreqDispTimeDoseQtyStr=$P(FreqDispTimeDoseQtyStr,"@",1)
	;首日不同量的处理
	if FirstDayFreqDispTimeDoseQtyStr'=""{
		s ret=..InsertDoseQtyList(OEORIRowid,FirstDayFreqDispTimeDoseQtyStr,SttDateStr,UserAdd)
		s SttDateStr=..%ZD(SttDate+1)_" "_..%ZT(0)
		d ..InsertDoseQtyList(OEORIRowid,FreqDispTimeDoseQtyStr,SttDateStr,UserAdd)
	}else{
		d ..InsertDoseQtyList(OEORIRowid,FreqDispTimeDoseQtyStr,SttDateStr,UserAdd)
	}
	q 0
}

/// 
/// w ##class(web.DHCOEOrdItemDoseQty).InsertDoseQtyList("1876||24","28||1$1!28||2$2!28||3$3","12/03/2020 16:52:33",10209)
/// 插入同频次不同剂量变化列表
ClassMethod InsertDoseQtyList(OEORIRowid As %String, DoseQtyStr As %String, SttDateStr As %String, UserAdd As %String) As %String
{
	s ^temptan("InsertDoseQtyList")=OEORIRowid_","_DoseQtyStr_","_SttDateStr_","_UserAdd
	if (UserAdd=""){
		Q "-1^医生不能为空"
	}
	s ret=..CheckDoseQtyList(OEORIRowid,DoseQtyStr,SttDateStr)
	if (+ret'=0){
		q ret
	}
	set PriorityDR=$p($g(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),1)),"^",8)
	set PriorityCode=""
	if (+PriorityDR'=0) set PriorityCode=$p(^OECPR(PriorityDR),"^",1)
	
	s SttDate=$P(SttDateStr," ",1)
	s SttTime=$P(SttDateStr," ",2)
	s SttDate=..%ZDH(SttDate)
	s SttTime=..%ZTH(SttTime)
	s DoseUOM=$P($G(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),2)),"^",3)
	s DoctorID=##class(web.SSUser).GetDefaultCareProvider(UserAdd)
	s DoseQtyStr=$Replace(DoseQtyStr,"_","||")
	b //12
	TS
	s Obj=##Class(User.OEOrdItemDoseQty).%New(OEORIRowid)
	d Obj.OIDQOEORIParRefSetObjectId(OEORIRowid)
	s Obj.OIDQFreqTimeDoseStr=DoseQtyStr
	s Obj.OIDQActive="Y"
	s Obj.OIDQSttDate=SttDate
	s Obj.OIDQSttTime=SttTime
	s Obj.OIDQEndDate=""
	s Obj.OIDQEndTime=""
	d Obj.OIDQDoctorDRSetObjectId(DoctorID)
	s Obj.OIDQNote=""
	s Obj.OIDQInsertDate=..%SysDate()
	s Obj.OIDQInsertTime=..%SysTime()
	s sc=Obj.%Save()
	if $$$ISERR(sc){
		TRO
		Q "-1^保存失败"
	}
	s err=..UpdateOrdExecQty(OEORIRowid,SttDate,SttTime)
	if (+err'=0){
		TRO
		Q err
	}
	TC
	q "0^成功"
}

/// 校验数据是否合法
ClassMethod CheckDoseQtyList(OEORIRowid, DoseQtyStr, DoseSttDateStr) As %String
{
	Set langid=..%LanguageID()
	if (OEORIRowid=""){
		Q "-1^医嘱ID不能为空"
	}
	if (DoseQtyStr=""){
		Q "-1^剂量不能为空"
	}
	s DoseQtyStr=$replace(DoseQtyStr,"_","||")
	if (DoseSttDateStr=""){
		Q "-1^生效日期不能为空"
	}
	s DoseSttDate=$P(DoseSttDateStr," ",1)
	s DoseSttTime=$P(DoseSttDateStr," ",2)
	s DoseSttDate=..%ZDH(DoseSttDate)
	s DoseSttTime=..%ZTH(DoseSttTime)
	
	s OrderFreqRowid=$P($G(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),2)),"^",4)
	s FreqDispTimeStr=##Class(web.DHCOEOrdItem).GetOrdItemFreqDispTimeStr(OEORIRowid)
	if ($l(DoseQtyStr,"!")'=$l(FreqDispTimeStr,"!")){
		Q "-1^单次剂量数据格式不正确"
	}
	s SttDate=$p($g(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),1)),"^",9)
	s SttTime=$p($g(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),1)),"^",10)
	if (DoseSttDate<SttDate)||((DoseSttDate=SttDate)&&(DoseSttTime<SttTime)){
		Q "-1^"_..%Translate("ipdoc.order.doseqtystr.edit.hui.csp","生效时间小于医嘱开始时间",langid)_..%ZD(SttDate)_" "_..%ZT(SttTime)
	}
	s ARCIMrow=$p($g(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),1)),"^",2)
	s drgform=$p($g(^ARCIM(+ARCIMrow,+$p(ARCIMrow,"||",2),1)),"^",12)
	Q:drgform="" "-2^非药品医嘱"
	s uom=$p($g(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),2)),"^",3)
	
	s INICPackComb=$p($g(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),"DHC")),"^",56)
	i INICPackComb'="" {
		q "-1^组合打包数量医嘱，不允许修改"
	}
	
	
	s FistExecDate=$O(^OEORDi(0,"OrdItem",+OEORIRowid,$P(OEORIRowid,"||",2),0))
	s LastExecDate=$O(^OEORDi(0,"OrdItem",+OEORIRowid,$P(OEORIRowid,"||",2),""),-1)
	
	if (DoseSttDate<=LastExecDate){
		Q "-1^"_..%Translate("ipdoc.order.doseqtystr.edit.hui.csp","修改时间之后存在有效的执行记录，请修改至",langid)_..%ZD(LastExecDate)_..%Translate("ipdoc.order.doseqtystr.edit.hui.csp","之后",langid)
	}
	
	s err="0"
	set PriorityDR=$p($g(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),1)),"^",8)
	set PriorityCode=""
	if (+PriorityDR'=0) set PriorityCode=$p(^OECPR(PriorityDR),"^",1)
	if (PriorityCode'["OM"){
		s ExStDate=DoseSttDate-1
		for {
			s ExStDate=$O(^OEORDi(0,"OrdItem",+OEORIRowid,$P(OEORIRowid,"||",2),ExStDate))
			q:(ExStDate="")
			s ExecSub=0
			for {
				s ExecSub=$O(^OEORDi(0,"OrdItem",+OEORIRowid,$P(OEORIRowid,"||",2),ExStDate,ExecSub))
				q:(ExecSub="")
				continue:('$D(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),"X",ExecSub)))
				s ExStTime=$P(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),"X",ExecSub),"^",2)
				if (ExStDate=DoseSttDate)&&(ExStTime<DoseSttTime){
					continue
				}
				if (ExStDate<DoseSttDate){
					continue
				}
				s rtn=..CanChangeExecQty(OEORIRowid_"||"_ExecSub)
				if (+rtn'=0){
					s err=rtn
				}
				
			}
		}
	}
	q:(+err'=0) err
	
	s LoopQtySub=0
	for {
		s LoopQtySub=$O(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),"DQ",LoopQtySub))
		q:(LoopQtySub="")||(+err'=0)
		
		s Str=$G(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),"DQ",LoopQtySub))
		s LoopSttDate=$P(Str,"^",3)
		s LoopSttTime=$P(Str,"^",4)
		if (LoopSttDate=DoseSttDate)&&(LoopSttTime=DoseSttTime){
			s err="-1^存在相同时间的记录，不允许重复添加"
		}
	}
	//
	s StartDayDoseQtySum=0
	s OrderDoseUOMRowid=$P($G(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),2)),"^",3)
	for k=1:1:$l(DoseQtyStr,"!") {
		s OneOrderDoseQty=$P($p(DoseQtyStr,"!",k),"$",2)
		s OneEqDoseQty=##class(web.DHCDocOrderEntry).CalEqDose(OrderDoseUOMRowid,drgform,OneOrderDoseQty,"BaseUom")
		s StartDayDoseQtySum=StartDayDoseQtySum+OneEqDoseQty
	}
	s bsUOMph=$p(^PHCD(+drgform,"DF",$p(drgform,"||",2),2),"^",4)
	s bsUOMphDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(bsUOMph,langid)
	s MaxDoseQtyPerDay=$p($g(^ARCIM(+ARCIMrow,$p(ARCIMrow,"||",2),9)),"^",37) //每天最大剂量
	if (MaxDoseQtyPerDay'=""){
		if (StartDayDoseQtySum>MaxDoseQtyPerDay){
			s err="-1^"_..%Translate("ipdoc.order.doseqtystr.edit.hui.csp","超过每天最大剂量:",langid)_MaxDoseQtyPerDay_bsUOMphDesc
			}
	}
	q err
}

/// 获取默认的修改起止时间
ClassMethod GetDefaultDoseStrSttDate(OEORIRowid As %String) As %String
{
	s LastExecDate=$O(^OEORDi(0,"OrdItem",+OEORIRowid,$P(OEORIRowid,"||",2),""),-1)
	
	s MaxDoseSttDate=0
	s LoopQtySub=0
	for {
		s LoopQtySub=$O(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),"DQ",LoopQtySub))
		q:(LoopQtySub="")
		
		s Str=$G(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),"DQ",LoopQtySub))
		s LoopSttDate=$P(Str,"^",3)
		if (MaxDoseSttDate<LoopSttDate){
			s MaxDoseSttDate=LoopSttDate
		}
	}
	if (MaxDoseSttDate<LastExecDate){
		s MaxDoseSttDate=LastExecDate
	}
	
	s DefaultDoseStrSttDate=..%ZD(MaxDoseSttDate+1)
	s DefaultDoseStrSttDate=DefaultDoseStrSttDate_" "_..%ZT(0)
	q DefaultDoseStrSttDate
}

/// w ##class(web.DHCOEOrdItemDoseQty).Test("3||33",+$H)
ClassMethod Test(OEORIRowid, Date) As %String [ ProcedureBlock = 0 ]
{
	s Time=$p($g(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),1)),"^",10)
	s OrderFreqRowid=$P($G(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),2)),"^",4)
	s Freq=$$freq^DHCOEOrdExec($g(OrderFreqRowid))
	s DurationRowid=$p($g(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),2)),"^",6)
	s NumTimes=0
	s err=$$ExecTime^DHCOEOrdExec(Freq,DurationRowid,OrderFreqRowid,.NumTimes,Date,Time,"")
	k ExecDoseQty
	d ..GetOrdDoseQtyList(OEORIRowid,.DateList,.TimeList,.ExecDoseQty)
	b ;1
}

/// 获取对应日期时间下的单次计量，用于生成执行记录
ClassMethod GetOrdDoseQtyList(OEORIRowid As %String, ByRef DateList, ByRef TimeList, ByRef ExecDoseQty) As %String
{
	q:(OEORIRowid="")||('$D(DateList))||('$D(TimeList))
	s FreqDispTimeDoseQtyStr=$P($G(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),"DHC")),"^",59)
	Q:FreqDispTimeDoseQtyStr=""
	s OrderFreqRowid=$P($G(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),2)),"^",4)
	q:(OrderFreqRowid="")
	s FreqCode=$P($g(^PHCFR(OrderFreqRowid)),"^",1)
 	Q:$ZCVT(FreqCode,"U")="PRN"
 	s OrderFreqFactor=$P($g(^PHCFR(OrderFreqRowid)),"^",2)
 	s FreeTimeFreqFlag=$P(^PHCFR(OrderFreqRowid),"^",13)
 	if (FreeTimeFreqFlag="Y") {
	 	s OrderFreqFreeTimeStr=$p($g(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),"DHC")),"^",68)
	 	s OrderFreqFactor=$L(OrderFreqFreeTimeStr,"|")
	}
	s PAADMRowid=$p(^OEORD(+OEORIRowid),"^",1)
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(PAADMRowid)
	Q:(..HasDoseQtyRecord(OEORIRowid)="")&&(PAAdmType="I")
	k FreqTimeDoseDateList
	s Counter=0
	for {
		s Counter=$O(DateList(Counter))
		q:(Counter="")
		s Date=DateList(Counter),Time=TimeList(Counter)
		//获得同日期下的Time的名次
		s PreDate=$G(DateList(+$O(DateList(Counter),-1)))
		if (PreDate'=Date){
			s TimeNum=1
		}else{
			s TimeNum=$G(TimeNum)+1
		}
		//先获取该日期下计算所得的多剂量串
		if ('$D(FreqTimeDoseDateList(Date))){
			s FreqTimeDoseStr=..GetFreqTimeDoseStr(OEORIRowid,Date)
			s FreqTimeDoseDateList(Date)=FreqTimeDoseStr
			k OrdDoseQtyList
			s DoseQtyStrLen=$l(FreqTimeDoseStr,"!")
			for m=1:1:DoseQtyStrLen {
				s OrderDoseQtyStr=$p(FreqTimeDoseStr,"!",m)
				s PHCDTRowID=$p(OrderDoseQtyStr,"$",1)
				continue:PHCDTRowID=""
				s PHCDTRowID=$Replace(PHCDTRowID,"_","||")
				s PHCDTTime=$p($g(^PHCFR(+PHCDTRowID,"DT",$p(PHCDTRowID,"||",2))),"^",1)
				continue:PHCDTTime=""
				s OrderDoseQty=$p(OrderDoseQtyStr,"$",2)
				continue:OrderDoseQty=""
				s FreqTimeDoseDateList(Date,"Time",PHCDTTime)=OrderDoseQty
			}
		}
		if ($D(FreqTimeDoseDateList(Date,"Time",Time))){
			s OrderDoseQty=FreqTimeDoseDateList(Date,"Time",Time)
		}else{
			s Qty=0
			s i=0
			for {
				s i=$O(DateList(i))
				q:(i="")
				s iDate=DateList(i),iTime=TimeList(i)
				if (iDate=Date){
					s Qty=Qty+1
				}
			}
			s NewTimeNum=TimeNum+OrderFreqFactor-Qty
			///有可能是首日执行记录，开始时间直接默认的开医嘱时间
			s LoopTime=0
			for i=1:1:NewTimeNum {
				s LoopTime=$O(FreqTimeDoseDateList(Date,"Time",LoopTime))
			}
			if $D(FreqTimeDoseDateList(Date,"Time",Time)) {
				s OrderDoseQty=FreqTimeDoseDateList(Date,"Time",Time)
			}else{
				s OrderDoseQty=FreqTimeDoseDateList(Date,"Time",LoopTime)
			}
		}
		s ExecDoseQty(Counter)=OrderDoseQty
	}
	q
}

/// 获取医嘱某一天或者某个时间的多剂量信息
/// 如果要考虑数据的结束时间，这个方法要重构
ClassMethod GetFreqTimeDoseStr(OEORIRowid As %String, Date As %String)
{
	s FreqTimeDoseStr=""
	q:(OEORIRowid="")||(Date="") FreqTimeDoseStr
	s PAADMRowid=$p(^OEORD(+OEORIRowid),"^",1)
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(PAADMRowid)
	Q:(..HasDoseQtyRecord(OEORIRowid)="")&&(PAAdmType="I") FreqTimeDoseStr
	if (PAAdmType'="I") {
		s FreqDispTimeDoseQtyStr=$P($G(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),"DHC")),"^",59)
		for m=1:1:$l(FreqDispTimeDoseQtyStr,"!") {
			s OrderDoseQtyStr=$p(FreqDispTimeDoseQtyStr,"!",m)
			s PHCDTRowID=$p(OrderDoseQtyStr,"$",1)
			s OrderDoseQty=$p(OrderDoseQtyStr,"$",2)
			continue:OrderDoseQty=""
			if (FreqTimeDoseStr=""){
				s FreqTimeDoseStr=$Replace(PHCDTRowID,"||","_")_"$"_OrderDoseQty
			}else{
				s FreqTimeDoseStr=FreqTimeDoseStr_"!"_$Replace(PHCDTRowID,"||","_")_"$"_OrderDoseQty
			}
		}
		Q FreqTimeDoseStr
	}
	K OIDQDoseQtyList
	s QtySub=0
	for {
		s QtySub=$O(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),"DQ",QtySub))
		q:(QtySub="")
		s Str=$G(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),"DQ",QtySub))
		s ID=OEORIRowid_"||"_QtySub
		s OIDQFreqTimeDoseStr=$P(Str,"^",1)
		s IDQActive=$P(Str,"^",2)
		Continue:(IDQActive="N")
		s OIDQSttDate=$P(Str,"^",3)
		s OIDQSttTime=$P(Str,"^",4)
		s OIDQDoseQtyList(+OIDQSttDate,+OIDQSttTime)=ID
	}
	s OIDQSttDate=$O(OIDQDoseQtyList(Date),-1)
	if (OIDQSttDate'=""){
		s OIDQSttTime=$O(OIDQDoseQtyList(OIDQSttDate,""),-1)
		s ID=OIDQDoseQtyList(+OIDQSttDate,+OIDQSttTime)
		s Str=$G(^OEORD(+ID,"I",$P(ID,"||",2),"DQ",$P(ID,"||",3)))
		s OIDQPreFreqTimeDoseStr=$P(Str,"^",1)
	}else{
		s OIDQSttDate=$O(OIDQDoseQtyList(0))
		s OIDQSttTime=$O(OIDQDoseQtyList(OIDQSttDate,0))
		s ID=OIDQDoseQtyList(+OIDQSttDate,+OIDQSttTime)
		s Str=$G(^OEORD(+ID,"I",$P(ID,"||",2),"DQ",$P(ID,"||",3)))
		s OIDQPreFreqTimeDoseStr=$P(Str,"^",1)
		//s OIDQPreFreqTimeDoseStr=""
	}
	if '$D(OIDQDoseQtyList(Date)){
		s FreqTimeDoseStr=OIDQPreFreqTimeDoseStr
		q FreqTimeDoseStr
	}
	//先生成非当日的，上一次最近记录的，分发时间队列
	K PreOIDQOrdDoseQtyList
	s DoseQtyStrLen=$l(OIDQPreFreqTimeDoseStr,"!")
	for m=1:1:DoseQtyStrLen {
		s OrderDoseQtyStr=$p(OIDQPreFreqTimeDoseStr,"!",m)
		s PHCDTRowID=$p(OrderDoseQtyStr,"$",1)
		continue:PHCDTRowID=""
		s PHCDTRowID=$Replace(PHCDTRowID,"_","||")
		s PHCDTTime=$p($g(^PHCFR(+PHCDTRowID,"DT",$p(PHCDTRowID,"||",2))),"^",1)
		continue:PHCDTTime=""
		s OrderDoseQty=$p(OrderDoseQtyStr,"$",2)
		continue:OrderDoseQty=""
		s PreOIDQOrdDoseQtyList(PHCDTRowID)=OrderDoseQty
	}
	//如果生效时间是目标日期，需要按照分发时间拆分每个时间的对应的生效数据
	//1、先获取标准频次的分发时间列表
	s OrderFreqRowid=$P($G(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),2)),"^",4)
	s FreqDispTimeStr=##Class(web.DHCOEOrdItem).GetOrdItemFreqDispTimeStr(OEORIRowid)
	s DoseQtyStrLen=$l(FreqDispTimeStr,"!")
	k FreqDTTimeList
	for m=1:1:DoseQtyStrLen {
		s OrderDoseQtyStr=$p(FreqDispTimeStr,"!",m)
		s PHCDTRowID=$p(OrderDoseQtyStr,"$",1)
		continue:PHCDTRowID=""
		s PHCDTRowID=$Replace(PHCDTRowID,"_","||")
		s PHCDTTime=$p($g(^PHCFR(+PHCDTRowID,"DT",$p(PHCDTRowID,"||",2))),"^",1)
		continue:PHCDTTime=""
		s FreqDTTimeList("Time",PHCDTTime)=PHCDTRowID
		s FreqDTTimeList("PHCDTRowID",PHCDTRowID)=PHCDTTime
	}
	///2、获取符合当日配置数据的频次分发时间对应的每次剂量
	k OrdDoseQtyList
	s OIDQSttTime=""
	for {
		s OIDQSttTime=$O(OIDQDoseQtyList(Date,OIDQSttTime))
		q:(OIDQSttTime="")
		s ID=OIDQDoseQtyList(Date,OIDQSttTime)
		s Str=$G(^OEORD(+ID,"I",$P(ID,"||",2),"DQ",$P(ID,"||",3)))
		s OIDQFreqTimeDoseStr=$P(Str,"^",1)
		k OIDQOrdDoseQtyList
		s DoseQtyStrLen=$l(OIDQFreqTimeDoseStr,"!")
		for m=1:1:DoseQtyStrLen {
			s OrderDoseQtyStr=$p(OIDQFreqTimeDoseStr,"!",m)
			s PHCDTRowID=$p(OrderDoseQtyStr,"$",1)
			continue:PHCDTRowID=""
			s PHCDTRowID=$Replace(PHCDTRowID,"_","||")
			s PHCDTTime=$p($g(^PHCFR(+PHCDTRowID,"DT",$p(PHCDTRowID,"||",2))),"^",1)
			continue:PHCDTTime=""
			s OrderDoseQty=$p(OrderDoseQtyStr,"$",2)
			continue:OrderDoseQty=""
			s OIDQOrdDoseQtyList(PHCDTRowID)=OrderDoseQty
		}
		///如果存在一天内有多条生效记录时，以符合自己时间段的记录为准
		s OIDQNextSttTime=$O(OIDQDoseQtyList(Date,OIDQSttTime))
		///找到符合本次条件的PHCDTRowID及对应的单次剂量
		s LoopTime=OIDQSttTime-0.00001
		for {
			s LoopTime=$O(FreqDTTimeList("Time",LoopTime))
			q:(LoopTime="")||((LoopTime>=OIDQNextSttTime)&&(OIDQNextSttTime'=""))
			s PHCDTRowID=FreqDTTimeList("Time",LoopTime)
			s OrderDoseQty=$G(OIDQOrdDoseQtyList(PHCDTRowID))
			s OrdDoseQtyList(PHCDTRowID)=OrderDoseQty
		}
	}
	///3、不完整的数据使用临近的上一次配置数据补全
	s PHCDTRowID=0
	for{
		s PHCDTRowID=$O(FreqDTTimeList("PHCDTRowID",PHCDTRowID))
		q:(PHCDTRowID="")
		s OrderDoseQty=$G(PreOIDQOrdDoseQtyList(PHCDTRowID))
		if '$D(OrdDoseQtyList(PHCDTRowID)) {
			s OrdDoseQtyList(PHCDTRowID)=OrderDoseQty
		}
	}
	///4、得到完整的配置数据
	s PHCDTRowID=0
	for{
		s PHCDTRowID=$O(OrdDoseQtyList(PHCDTRowID))
		q:(PHCDTRowID="")
		s OrderDoseQty=$G(OrdDoseQtyList(PHCDTRowID))
		if (FreqTimeDoseStr=""){
			s FreqTimeDoseStr=$Replace(PHCDTRowID,"||","_")_"$"_OrderDoseQty
		}else{
			s FreqTimeDoseStr=FreqTimeDoseStr_"!"_$Replace(PHCDTRowID,"||","_")_"$"_OrderDoseQty
		}
	}
	q FreqTimeDoseStr
}

/// 批量更新某一时间点之后的执行记录的执行数量
/// w ##Class(web.DHCOEOrdItemDoseQty).UpdateOrdExecQty("3||33","65396","0")
ClassMethod UpdateOrdExecQty(OEORIRowid As %String, SttDate As %String, SttTime As %String) As %String
{
	s rtn=0
	s ExStDate=SttDate-1
	for {
		s ExStDate=$O(^OEORDi(0,"OrdItem",+OEORIRowid,$P(OEORIRowid,"||",2),ExStDate))
		q:(ExStDate="")
		s FreqTimeDoseStr=..GetFreqTimeDoseStr(OEORIRowid,ExStDate)
		s Count=0
		s ExecSub=""
		for {
			s ExecSub=$O(^OEORDi(0,"OrdItem",+OEORIRowid,$P(OEORIRowid,"||",2),ExStDate,ExecSub),-1)
			q:(ExecSub="")
			s Count=Count+1
			continue:('$D(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),"X",ExecSub)))
			s ExStTime=$P(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),"X",ExecSub),"^",2)
			if (ExStDate=SttDate)&&(ExStTime<SttTime){
				continue
			}
			if (ExStDate<SttDate){
				continue
			}
			s DoseStr=$P(FreqTimeDoseStr,"!",$L(FreqTimeDoseStr,"!")-Count+1)
			s Dose=$P(DoseStr,"$",2)
			s OEORERowid=OEORIRowid_"||"_ExecSub
			s err=..UpdateExecQty(OEORERowid,Dose)
			if (+err'=0){
				s rtn=err
			}
		}
	}
	q rtn
}

/// 更新执行记录数量、计费数量、打包表数量,如果打包表不是代发TC状态,则不能更新
/// 目前只考虑药品
/// Input:执行记录ID，执行数量
ClassMethod UpdateExecQty(OEORERowid, ExecQty)
{
	s rtn=..CanChangeExecQty(OEORERowid)
	if (+rtn'=0){
		s err=rtn
	}
	s AdmID=$p(^OEORD(+OEORERowid),"^",1)
 	s AdmType=$p($g(^PAADM(AdmID)),"^",2)

	s PhQtyOrd=$P(^OEORD(+OEORERowid,"I",$P(OEORERowid,"||",2),"X",$P(OEORERowid,"||",3)),"^",4)
	Q:PhQtyOrd=ExecQty 0	;相同直接退出 成功
	
	s ARCIMrow=$P(^OEORD(+OEORERowid,"I",$P(OEORERowid,"||",2),1),"^",2)
	s drgform=$p($g(^ARCIM(+ARCIMrow,+$p(ARCIMrow,"||",2),1)),"^",12)
	Q:drgform="" "-2^非药品医嘱"
	s uom=$p($g(^OEORD(+OEORERowid,"I",$P(OEORERowid,"||",2),2)),"^",3)
	s AdminQty=$$calcqty^DHCOEOrdItem(drgform,uom,ExecQty,AdmType)
	
	s INICPackComb=$p($g(^OEORD(+OEORERowid,"I",$P(OEORERowid,"||",2),"DHC")),"^",56)
	i INICPackComb="" {
		;现在西药没有在OE_OrdItem上存储库存id与数量的组合,按医嘱项与库存项目一对一处理
		s INICRow=##Class(appcom.OEDispensing).GetINCI(+ARCIMrow)
		s INICPackComb=INICRow_"!"_(+AdminQty)
	}
	
	TS
	&SQL(UPDATE SQLUser.OE_OrdExec 
		SET OEORE_PhQtyOrd=:ExecQty,OEORE_QtyAdmin=:AdminQty,OEORE_Billed='TB'
		WHERE OEORE_RowId=:OEORERowid)
	if SQLCODE{
		TRO
		Q SQLCODE
	}
	s err=0
	s DSPRowid=0 for{
		s DSPRowid=$O(^DHCOEDISQTY(0,"OEORE",OEORERowid,DSPRowid)) Q:DSPRowid=""
		s Status=$P(^DHCOEDISQTY(DSPRowid),"^",7)
		if Status'="TC"{
			s err=-2
			Q
		}
		&SQL(UPDATE SQLUser.DHC_OEDispensing 
			SET DSP_TotalQty=:AdminQty,DSP_Qty=:AdminQty,DSP_ConfirmQty=:AdminQty
			,DSP_INCIPackComb=:INICPackComb
			WHERE DSP_RowId=:DSPRowid)
		if SQLCODE{
			s err=SQLCODE
			Q
		}
		//判断是否能够修改特定医嘱的每日单次剂量使用计划,已发药或已领药审核不允许修改
		s IsCanMod=##class(PHA.FACE.OUT.Com).IfDosageCanMod(OEORERowid)
		if (IsCanMod="Y") {
			///调用药房接口，重新生成批次信息
			s err=##class(PHA.FACE.OUT.Com).RebuildDspBatchForDoc(OEORERowid)
			//##class(PHA.FACE.OUT.Com).RebuildDspBatch(OEORERowid)
			if +err'=0{
				Q
			}
		}
		
	}
	if err{
		TRO
		Q err
	}
	TC
	Q SQLCODE
}

/// 验证执行记录对应的数据是否能够修改
ClassMethod CanChangeExecQty(OEORERowid As %String) As %String
{
	s Msg=""
	s rtn=0
	
	s StatusRowId=$P(^OEORD(+OEORERowid,"I",$P(OEORERowid,"||",2),"X",$P(OEORERowid,"||",3)),"^",16)
	s StatusCode=$s(StatusRowId'="":$P($G(^OEC("STAT",StatusRowId)),"^",1),1:"")
	if (StatusCode'="C")&&(StatusCode'=""){
		s Msg="执行记录已经"_$P($G(^OEC("STAT",StatusRowId)),"^",2)
		s rtn=-1
	}
	;已经结算了,不能停止
	s BillStatus=$P(^OEORD(+OEORERowid,"I",$P(OEORERowid,"||",2),"X",$P(OEORERowid,"||",3)),"^",6)
	if BillStatus="P"{
		s Msg="已经结算了"
		s rtn=-1
	}
	s DspID=$O(^DHCOEDISQTY(0,"OEORE",OEORERowid,0))
	s IfAuditFlag=##class(web.DHCSTCOMMONSRV).IfAuditByPriority(DspID)
	if (IfAuditFlag=0){
		s Msg="已做领药审核"
		s rtn=-1
	}
	///TODO:此处需要调用药房接口，判断能否修改
	
	
	s dspStat=$P($G(^DHCOEDISQTY(DspID)),"^",7)
	if (dspStat="C"){
		s Msg="已发药"
		s rtn=-1
	}elseif (dspStat="R"){
		s Msg="已退药"
		s rtn=-1
	}elseif (dspStat'="TC"){
		s Msg="打包表状态异常"
		s rtn=-1
	}
	q rtn_"^"_Msg
}

Query QueryDoseQtyList(OEORIRowid As %String) As websys.Query(ROWSPEC = "ID:%String,OIDQDoseQtyStr:%String,DoseUOM:%String,IDQActive:%String,OIDQSttDate:%String,OIDQSttTime:%String,OIDQEndDate:%String,OIDQEndTime:%String,OIDQDoctor:%String,OIDQNote:%String,OIDQInsertDate:%String,OIDQInsertTime:%String,OIDQExeFlag:%String,OIDQExeDate:%String,OIDQExeTime:%String,OIDQLastUpdateDate:%String,OIDQLastUpdateTime:%String,OIDQLastUpdateDoctor:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCOEOrdItemDoseQty","QueryDoseQtyList","3||33")
ClassMethod QueryDoseQtyListExecute(ByRef qHandle As %Binary, OEORIRowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set langid=..%LanguageID()
	If ($g(OEORIRowid)="")||'$D(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2))){
		Set qHandle=$lb(0,repid,0)	
		Quit $$$OK
	}
	s ArcimDr=$P($G(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),1)),"^",2)
	s DoseUOM=$P($G(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),2)),"^",3)
	s OrderDoseUOM=$P(^CT("UOM",DoseUOM),"^",2)
	s OrderDoseUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",OrderDoseUOM,langid)
	s OrderFreqRowid=$P($G(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),2)),"^",4)
	/*
	s FreqDispTimeStr=##Class(web.DHCOEOrdItem).GetOrdItemFreqDispTimeStr(OEORIRowid)

	//s FreqDispTimeDoseQtyStr=$P(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),"DHC"),"^",59)
	//s doseQty = ##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(OEORIRowid)
	*/
	K DoseQtyList
	s QtySub=0
	for {
		s QtySub=$O(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),"DQ",QtySub))
		q:(QtySub="")
		
		s Str=$G(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),"DQ",QtySub))
		s ID=OEORIRowid_"||"_QtySub
		s OIDQSttDate=$P(Str,"^",3)
		s OIDQSttTime=$P(Str,"^",4)
		s DoseQtyList(+OIDQSttDate,+OIDQSttTime,ID)=Str
	}
	s i=""
	for {
		s i=$O(DoseQtyList(i))
		q:(i="")
		s j=""
		for {
			s j=$O(DoseQtyList(i,j))
			q:(j="")
			s ID=""
			for {
				s ID=$O(DoseQtyList(i,j,ID))
				q:(ID="")
				s Str=$G(DoseQtyList(i,j,ID))
				s OIDQFreqTimeDoseStr=$P(Str,"^",1)
				s OIDQDoseQtyStr=..GetDoseQty(OIDQFreqTimeDoseStr)
				s IDQActive=$P(Str,"^",2)
				s OIDQSttDate=$P(Str,"^",3)
				if (OIDQSttDate'=""){
					s OIDQSttDate=..%ZD(OIDQSttDate)
				}
				s OIDQSttTime=$P(Str,"^",4)
				i OIDQSttTime'="" s OIDQSttTime=..%ZT(OIDQSttTime,2)
				s OIDQEndDate=$P(Str,"^",5)
				i (OIDQEndDate'=""){
					s OIDQEndDate=..%ZD(OIDQEndDate)
				}
				s OIDQEndTime=$P(Str,"^",6)
				s OIDQDoctorDR=$P(Str,"^",7)
				s OIDQDoctor=""
				i OIDQDoctorDR'=""{
					s OIDQDoctor=$P(^CTPCP(OIDQDoctorDR,1),"^",2)
					Set OIDQDoctor= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",OIDQDoctor,langid)
				}
				s OIDQNote=$P(Str,"^",8)
				s OIDQInsertDate=$P(Str,"^",9)
				i (OIDQInsertDate'=""){
					s OIDQInsertDate=..%ZD(OIDQInsertDate)
				}
				s OIDQInsertTime=$P(Str,"^",10)
				i OIDQInsertTime'="" s OIDQInsertTime=..%ZT(OIDQInsertTime,2)
				s OIDQExeFlag=$P(Str,"^",11)
				s OIDQExeDate=$P(Str,"^",12)
				i (OIDQExeDate'=""){
					s OIDQExeDate=..%ZD(OIDQExeDate)
				}
				s OIDQExeTime=$P(Str,"^",13)
				i OIDQExeTime'="" s OIDQExeTime=..%ZT(OIDQExeTime,2)
				s OIDQLastUpdateDate=$P(Str,"^",14)
				i (OIDQLastUpdateDate'=""){
					s OIDQLastUpdateDate=..%ZD(OIDQLastUpdateDate)
				}
				s OIDQLastUpdateTime=$P(Str,"^",15)
				i OIDQLastUpdateTime'="" s OIDQLastUpdateTime=..%ZT(OIDQLastUpdateTime,2)
				s OIDQLastUpdateDoctorDR=$P(Str,"^",16)
				s OIDQLastUpdateDoctor=""
				i OIDQLastUpdateDoctorDR'=""{
					s OIDQLastUpdateDoctor=$P(^CTPCP(OIDQLastUpdateDoctorDR,1),"^",2)
					Set OIDQLastUpdateDoctor= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",OIDQLastUpdateDoctor,langid)
				}
				d OutPutData2
			}
		}
	}
	
	
	Set qHandle=$lb(0,repid,0)	
	Quit $$$OK
OutPutData2
	s Data=$LB(ID,OIDQDoseQtyStr,OrderDoseUOM,IDQActive,OIDQSttDate,OIDQSttTime,OIDQEndDate,OIDQEndTime,OIDQDoctor,OIDQNote,OIDQInsertDate,OIDQInsertTime,OIDQExeFlag,OIDQExeDate,OIDQExeTime,OIDQLastUpdateDate,OIDQLastUpdateTime,OIDQLastUpdateDoctor)
	s ind=ind+1
	s ^CacheTemp(repid,ind) = Data
	q
}

ClassMethod GetDoseQty(OrderFreqTimeDoseStr As %String) As %String
{
	s DoseQtyStrLen=$l(OrderFreqTimeDoseStr,"!")
	s DoseQty=""
	for m=1:1:DoseQtyStrLen {
		s OrderDoseQtyStr=$p(OrderFreqTimeDoseStr,"!",m)
		s OrderDoseQty=$p(OrderDoseQtyStr,"$",2)
		continue:OrderDoseQty=""
		if (DoseQty="") s DoseQty=OrderDoseQty
		else  s DoseQty=DoseQty_"-"_OrderDoseQty
	}
	q DoseQty
}

ClassMethod HasDoseQtyRecord(OEORIRowid)
{
	Q $O(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),"DQ",0))
}

ClassMethod ChangeOrderDoseQtyShow(OEORIRowid As %String)
{
	s CanChangeMsg=""
	if (..HasDoseQtyRecord(OEORIRowid)=""){
		s CanChangeMsg="该医嘱无法修改单次剂量"
	}
	
	q CanChangeMsg
}

}
