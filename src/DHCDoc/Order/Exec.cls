/// creator:王清雍
/// date:2021-12-25
/// desc:执行记录业务相关操作类
Class DHCDoc.Order.Exec Extends DHCDoc.Util.RegisteredObject
{

/// 生成执行记录入口方法
/// Input:医嘱ID，生成日期
/// w ##class(DHCDoc.Order.Exec).Generate(OEORIRowId,GenDate)
ClassMethod Generate(OEORIRowId, GenDate = "")
{
	try{
		s GenDate=..%ZDH(GenDate)
		s:GenDate="" GenDate=..%SysDate()
		s Ord=+OEORIRowId,Sub=$P(OEORIRowId,"||",2)
		;如果本日执行记录已经生成,则退出
		Q:$O(^OEORDi(0,"OrdItem",Ord,Sub,GenDate,0))
		;是否需要生成 并在此处获取执行时间列表
		Q:'..NeedGenFlag(OEORIRowId,GenDate,.ExecList)
		;获取记录列表的数量相关信息
		d ..GetOrdExecQtyToList(OEORIRowId,.ExecList)
		;生成执行记录
		d ..InsByExecList(OEORIRowId,GenDate,.ExecList)
	}catch{
		b ;Generate Exec Err w $ZE
		if $TL>0 TRO
		s LogText="生成执行记录异常:"_$ZE
		d ##class(DHCDoc.Log.Common).General("Insert","DHCDoc.Order.Exec","Generate",LogText,OEORIRowId,-1)
		
	}
	Q 0
}

/// 判断医嘱当日是否需要生成执行记录
/// 1需要 0不需要
ClassMethod NeedGenFlag(OEORIRowId, GenDate, ByRef ExecList = "") As %Boolean
{
	;治疗项目预约时产生则不需要生成
	Q:..GetCureAppGenFlag(OEORIRowId) 0
	;PRN医嘱不需要产生
	Q:##class(appcom.OEOrdItem).ISPRNOrder(OEORIRowId) 0
	s Ord=+OEORIRowId,Sub=$P(OEORIRowId,"||",2)
	s LongOrdFlag=##class(DHCDoc.Order.Common).IsLongOrdItem(OEORIRowId)
	if LongOrdFlag{
		s SttDate=$P($G(^OEORD(Ord,"I",Sub,1)),"^",9)
	    s EndDate=$p($G(^OEORD(Ord,"I",Sub,3)),"^",34)
	    s:EndDate="" EndDate=$p($G(^OEORD(Ord,"I",Sub,9)),"^",9)
	    ;不在有效期内 则不产生
	    Q:(GenDate<SttDate)||((EndDate'="")&&(GenDate>EndDate)) 0
	}else{
		;临时医嘱 已经有执行记录 不需要生成
		Q:$O(^OEORD(Ord,"I",Sub,"X",0))>0 0
	}
	;获取执行记录时间列表
	d ..GetGenTimeList(OEORIRowId, GenDate,.ExecList)
	Q:'$D(ExecList) 0
	;如果是长期医嘱,当天没有执行记录列表,返回0
	Q:LongOrdFlag&&'$D(ExecList(GenDate)) 0	
	Q 1
}

/// 获取医嘱需要生成的执行记录时间列表
/// d ##class(DHCDoc.Order.Exec).GetGenTimeList("62||90",+$H,.ExecList)
ClassMethod GetGenTimeList(OEORIRowId, GenDate, ByRef ExecList)
{
	k ExecList
	;检查申请单
	Q:..GetApplyGenTimeList(OEORIRowId,GenDate,.ExecList) 0
	;小时医嘱
	Q:..GetHourGenTimeList(OEORIRowId,GenDate,.ExecList) 0
	;关联子医嘱
	Q:..GetChildGenTimeList(OEORIRowId,GenDate,.ExecList) 0
	s Ord=+OEORIRowId,Sub=$P(OEORIRowId,"||",2)
	s ArcimRowid=$P($G(^OEORD(Ord,"I",Sub,1)),"^",2)
	s PriorRowid=$P($G(^OEORD(Ord,"I",Sub,1)),"^",8)
	s SttDate=$P($G(^OEORD(Ord,"I",Sub,1)),"^",9)
	s SttTime=$P($G(^OEORD(Ord,"I",Sub,1)),"^",10)
	s FreqRowid=$P($G(^OEORD(Ord,"I",Sub,2)),"^",4)
	s DuratRowid=$P($G(^OEORD(Ord,"I",Sub,2)),"^",6)
	s DuratFac=$P($G(^PHCDU(+DuratRowid)),"^",2)
	s FirstDayTimes=$P($G(^OEORD(Ord,"I",Sub,1)),"^",18)
	s OrderFreqWeekStr=$p($g(^OEORD(Ord,"I",Sub,"DHC")),"^",55)
	s OrderFreqFreeTimeStr=$p($g(^OEORD(Ord,"I",Sub,"DHC")),"^",68)
	s EpisodeID=$P(^OEORD(Ord),"^",1)
	s HospID=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s LongOrdFlag=##class(DHCDoc.Order.Common).IsLongOrdItem(OEORIRowId)
	;草药目前没有首日,需要特殊处理 在此处计算首日次数
	if 'FirstDayTimes&&##class(DHCDoc.Order.Common).IsCNFreq(FreqRowid){
		s FirstDayTimesRet=##class(web.DHCOEOrdItemView).GetOrderFirstDayTimes(EpisodeID,ArcimRowid,FreqRowid,PriorRowid,SttDate_" "_SttTime,"",OrderFreqFreeTimeStr,HospID)
		s FirstDayTimes=$P(FirstDayTimesRet,"^",1)
	}elseif (FreqRowid="")&&LongOrdFlag{
		;无频次长嘱 首日都生成
		s FirstDayTimes=1
	}
	;长期医嘱的疗程用当前日期减去开始日期
	if LongOrdFlag{
		s DuratFac=GenDate-SttDate+1
	}
	d ..GetExecTime(.ExecList,FreqRowid,DuratFac,SttDate,SttTime,FirstDayTimes,OrderFreqWeekStr,OrderFreqFreeTimeStr,HospID,ArcimRowid,PriorRowid)
	;取护士选择关联的分发时间的执行记录ID
	d ..GetNurLinkDispTime(OEORIRowId,.ExecList)
	Q 0
}

/// 获取医嘱分发时间
ClassMethod GetExecTime(ByRef ExecList, FreqRowid, DuratFactor, SttDate, SttTime, FirstDayTimes = "", OrderFreqWeekStr = "", OrderFreqFreeTimeStr = "", HospID = "", ArcimRowid = "", PriorRowid = "")
{
	k ExecList
	s FreqStr=$g(^PHCFR(+FreqRowid))
	s FreqCode=$ZCVT($p(FreqStr,"^",1),"U")
	Q:FreqCode="PRN" 0
	s:SttDate="" SttDate=..%SysDate()
	s:SttTime="" SttTime=..%SysTime()
	s LongOrdFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowid)
	;ONCE或者ST或者无频次临时 按开始日期时间产生一次
	if (FreqCode="ST")||(FreqCode="ONCE")||('LongOrdFlag&&'FreqRowid&&(DuratFactor<=1)){
		s ExecList=$I(ExecList),ind=$I(ExecList(SttDate, SttTime))
		s ExecList(SttDate, SttTime,ind)={}
		Q 0
	}
	s:+DuratFactor<=0 DuratFactor=1
	s IntervalTime=$p(FreqStr,"^",5) ;频次间隔时间	$p(FreqStr,"^",12)
	s IntervalUnit=$P(FreqStr,"^",14)	;间隔单位
	s:IntervalUnit="" IntervalUnit="D"
	s WeekFlag=$P(FreqStr,"^",9)	;周频次标志
	;取分发时间列表
	d ..GetFreqDispTimeList(FreqRowid,OrderFreqFreeTimeStr,HospID,ArcimRowid,.ExecTimeList)
	if (IntervalTime>0)&&((IntervalUnit'="D")||((IntervalUnit="D")&&'$D(ExecTimeList))){
		;固定时间间隔,如果间隔单位是天,那么只考虑没有维护分发时间的情况
		d ..GetIntervalDTList(SttDate,SttTime,IntervalTime,IntervalUnit,DuratFactor,.ExecList)
	}elseif WeekFlag="Y"{
		;周频次
		d ..GetWeekDTList(SttDate,DuratFactor,OrderFreqWeekStr,FirstDayTimes,.ExecTimeList,.ExecList)
	}else{
		;一般情况 考虑首日、频次分发时间、疗程、间隔天数、
		d ..GetNorDTList(SttDate,DuratFactor,FirstDayTimes,IntervalTime,.ExecTimeList,.ExecList)
	}
	;如果首日的执行时间小于开始时间 那么计算为开始时间
	s Time="" for{
		s Time=$O(ExecList(SttDate,Time)) Q:Time=""
		if Time<SttTime{
			s ind=0 for{
				s ind=$O(ExecList(SttDate,Time,ind)) Q:ind=""
				s NewInd=$I(ExecList(SttDate,SttTime))
				s ExecList(SttDate,SttTime,NewInd)=ExecList(SttDate,Time,ind)
				s ExecList(SttDate,SttTime,NewInd).OldTime=Time
			}
			k ExecList(SttDate,Time)
		}
	}
	Q 0
}

/// 获取关联子医嘱执行时间列表
/// Return:1是子医嘱 0不是
ClassMethod GetChildGenTimeList(OEORIRowId, GenDate, ByRef ExecList)
{
	s Ord=+OEORIRowId,Sub=$P(OEORIRowId,"||",2)
	s LinkOrdItemID=$p($g(^OEORD(Ord,"I",Sub,11)),"^",39)
	Q:LinkOrdItemID="" 0
	;保证主医嘱已经生成
	d ..Generate(LinkOrdItemID,GenDate)
	s MainOrd=+LinkOrdItemID,MainSub=$P(LinkOrdItemID,"||",2)
	s AppReportDR=$p($g(^OEORD(MainOrd,"I",MainSub,"DHC")),"^",42)
	s DCARowId=$O(^DHCDocCure(0,"OEORI",LinkOrdItemID,""))
	;如果主医嘱属于申请单类医嘱，则按照子医嘱自己的规则生成执行记录
	Q:(AppReportDR'="")||(DCARowId'="") 0
	s MainFreqRowid=$p($g(^OEORD(MainOrd,"I",MainSub,2)),"^",4)
	s FreqRowid=$P($G(^OEORD(Ord,"I",Sub,2)),"^",4)
	;主子医嘱不一致的情况
	Q:(MainFreqRowid'=FreqRowid) 0
	;只生成一条执行记录的医嘱需不按照主医嘱规则生成,因为主医嘱已经汇总为一条了,需要计算数量
	Q:..IsGenOneExecOrdItem(OEORIRowId) 0
	if ##class(DHCDoc.Order.Common).IsShortOrdItem(OEORIRowId){	;临时生成所有执行记录
		s ExecDate="" for{
			s ExecDate=$O(^OEORDi(0,"OrdItem",MainOrd,MainSub,ExecDate)) Q:ExecDate=""
			d OneDateExec
		}
	}else{
		s ExecDate=GenDate	;长期只生成当天
		d OneDateExec
		;长期医嘱,首日次数和主医嘱执行记录不一致,需按子医嘱自己生成
		s SttDate=$P($G(^OEORD(Ord,"I",Sub,1)),"^",9)
		s FirstDayTimes=$P($G(^OEORD(Ord,"I",Sub,1)),"^",18)
		if (SttDate=GenDate)&&(+FirstDayTimes'=+$G(ExecList)){
			k ExecList
			Q 0
		}
	}
	Q 1
OneDateExec
	s ChildSub=0 for{
		s ChildSub=$O(^OEORDi(0,"OrdItem",MainOrd,MainSub,ExecDate,ChildSub)) Q:ChildSub=""
		s Time=+$P(^OEORD(MainOrd,"I",MainSub,"X",ChildSub),"^",2)
		s LinkOrdExecID=LinkOrdItemID_"||"_ChildSub
		s ExecList=$I(ExecList),ind=$I(ExecList(ExecDate,Time))
		s ExecList(ExecDate,Time,ind)={"LinkOrdExecID":(LinkOrdExecID)}
	}
	Q
}

/// 获取小时医嘱执行时间列表
/// Return:1是小时医嘱 0不是
ClassMethod GetHourGenTimeList(OEORIRowId, GenDate, ByRef ExecList)
{
	Q:'##class(appcom.OEOrdItem).IsHourOrderItem(OEORIRowId) 0
	s Ord=+OEORIRowId,Sub=$P(OEORIRowId,"||",2)
	s SttDate=$P($G(^OEORD(Ord,"I",Sub,1)),"^",9)
	if GenDate>=SttDate{
		s LinkOrdExecID=""
		;如果是子医嘱关联主医嘱第一条
		if ..GetChildGenTimeList(OEORIRowId, GenDate,.LinkExecList){
			s LinkTime=$O(LinkExecList(GenDate,""))
			s:LinkTime'="" ind=$O(LinkExecList(GenDate,LinkTime,""))
			s:ind'="" LinkOrdExecID=LinkExecList(GenDate,LinkTime,ind).LinkOrdExecID	
		}
		s EndDate=$p($G(^OEORD(Ord,"I",Sub,9)),"^",9)
		s Time=$CASE(GenDate,SttDate:$P($G(^OEORD(Ord,"I",Sub,1)),"^",10),:1)
		s XTime=$CASE(GenDate,EndDate:$p($G(^OEORD(Ord,"I",Sub,9)),"^",10),:"")
		s ExecList=$I(ExecList),ind=$I(ExecList(GenDate,Time))
		s ExecList(GenDate,Time,ind)={"LinkOrdExecID":(LinkOrdExecID),"XTime":(XTime)}
	}
	Q 1
}

/// 获取检查申请单执行时间列表
/// Return:1是申请单医嘱 0不是
ClassMethod GetApplyGenTimeList(OEORIRowId, GenDate, ByRef ExecList)
{
	s Ord=+OEORIRowId,Sub=$P(OEORIRowId,"||",2)
	s AppRepID=$p($g(^OEORD(Ord,"I",Sub,"DHC")),"^",42)
	Q:AppRepID="" 0
	s SttDate=$P($G(^OEORD(Ord,"I",Sub,1)),"^",9)
	s SttTime=$P($G(^OEORD(Ord,"I",Sub,1)),"^",10)
	s BodyPartStr=$p($g(^OEORD(Ord,"I",Sub,"DHC")),"^",38)
	for i=1:1:$L(BodyPartStr,"@"){
		s OneBodyPartInfo=$p(BodyPartStr,"@",i)
		continue:OneBodyPartInfo=""
		s BodyPartID=$p(OneBodyPartInfo,":",1)
		s BillItmIDStr=$p(OneBodyPartInfo,":",2)
		for j=1:1:$L(BillItmIDStr,",") {
			s BillItmID=$p(BillItmIDStr,",",j)
			continue:BillItmID=""
			s ItemList($I(ItemList))={"AppRepID":(AppRepID),"BodyPartID":(BodyPartID),"BillItmID":(BillItmID)}
		}
	}
	s Count=+$G(ItemList)
	if Count>0{
		;多部位检查默认间隔5分钟 需要计算判断是否超过23:59:59,如果超过，则缩小间隔时间
		s Interval=300,MaxTime=..%ZTH("23:59:59")
		if (SttTime+(Interval*(Count-1)))>MaxTime{
			s Interval=(MaxTime-SttTime)\(Count-1)	;整除取整
			;极限情况 间隔时间算出不为一秒,那么前推开始时间
			if Interval=0 s Interval=1,SttTime=MaxTime-Count+1
		}
		for i=1:1:Count{
			s Time=SttTime+((i-1)*Interval)
			s ExecList=$I(ExecList),ind=$I(ExecList(SttDate,Time))
			s ExecList(SttDate,Time,ind)=ItemList(i)
		}
	}else{
		s ExecList=$I(ExecList),ind=$I(ExecList(SttDate,SttTime))
		s ExecList(SttDate,SttTime,ind)={"AppRepID":(AppRepID)}
	}	
	Q 1
}

/// 治疗项目是否预约时产生执行记录
/// 如果是,则不产生执行记录
ClassMethod GetCureAppGenFlag(OEORIRowId) As %Boolean
{
	Q ##class(DHCDoc.DHCDocCure.Service).GetCureAppGenFlag(OEORIRowId)
}

/// 获取固定间隔时间的频次执行时间列表
/// d ##class(DHCDoc.Order.Exec).GetIntervalDTList(+$H,$P($H,",",2),8,"H",3,.ExecList)
ClassMethod GetIntervalDTList(SttDate, SttTime, IntervalTime, IntervalUnit, DuratFactor, ByRef ExecList)
{
	k ExecList
	Q:+IntervalTime=0 0
	s:+DuratFactor=0 DuratFactor=1
	s IntervalTime=IntervalTime*$CASE(IntervalUnit,"D":3600*24,"H":3600,"M":60,:1)	;间隔时间转换为秒
	s EndDate=SttDate+DuratFactor-1
	s Date=SttDate,Time=SttTime
	s MaxTime=..%ZTH("23:59:59")
	do{
		s ExecList=$I(ExecList),ind=$I(ExecList(Date, Time))
		s ExecList(Date,Time,ind)={}
		s Time=Time+IntervalTime
		if Time>MaxTime{
			s dif=Time\MaxTime
			s Date=Date+dif
			s Time=Time#MaxTime-dif
		}
	}while(Date<=EndDate)
	Q 1
}

/// 获取周频次执行时间列表
/// d ##class(DHCDoc.Order.Exec).GetWeekDTList(+$H,30,"135",1,.ExecTimeList,.ExecList)
ClassMethod GetWeekDTList(SttDate, DuratFactor, OrderFreqWeekStr, FirstDayTimes, ExecTimeList, ByRef ExecList)
{
	k ExecList
	s:+DuratFactor=0 DuratFactor=1
	s EndDate=SttDate+DuratFactor-1
	for Date=SttDate:1:EndDate{
		s DateWeek=$ZD(Date,10)
		s:DateWeek=0 DateWeek=7
		continue:(OrderFreqWeekStr'[DateWeek)
		if Date=SttDate{	;首日次数倒叙取
			for i=ExecTimeList:-1:1{
				Q:$I(FirstDayTimes,-1)<0
				d OneTime
			}
		}else{
			for i=1:1:ExecTimeList{
				d OneTime
			}
		}
	}
	Q 1
OneTime
	s Time=ExecTimeList(i)
	s ExecList=$I(ExecList),ind=$I(ExecList(Date, Time))
	s ExecList(Date,Time,ind)={}	;$ZD(Date,3)_" "_$ZT(Time)
	Q
}

/// 获取一般情况执行时间列表
/// d ##class(DHCDoc.Order.Exec).GetNorDTList(+$H,3,2,2,.ExecTimeList,.ExecList)
ClassMethod GetNorDTList(SttDate, DuratFactor, FirstDayTimes, IntervalDay, ExecTimeList, ByRef ExecList)
{
	k ExecList
	s:+DuratFactor=0 DuratFactor=1
	s:+IntervalDay=0 IntervalDay=1
	s EndDate=SttDate+DuratFactor-1
	for Date=SttDate:IntervalDay:EndDate{
		if Date=SttDate{	;首日次数倒叙取
			for i=ExecTimeList:-1:1{
				Q:$I(FirstDayTimes,-1)<0
				d OneTime
			}
		}else{
			for i=1:1:ExecTimeList{
				d OneTime
			}
		}
	}
	Q 1
OneTime
	s Time=ExecTimeList(i)
	s ExecList=$I(ExecList),ind=$I(ExecList(Date, Time))
	s ExecList(Date,Time,ind)={}	;$ZD(Date,3)_" "_$ZT(Time)
	Q
}

/// 取分发时间列表
ClassMethod GetFreqDispTimeList(FreqRowid, OrderFreqFreeTimeStr, HospID, ArcimRowid, ByRef ExecTimeList)
{
	s FreeTimeFreqFlag=$P($g(^PHCFR(+FreqRowid)),"^",13)			;不规则分发时间标志
	if (FreeTimeFreqFlag="Y")&&(OrderFreqFreeTimeStr'=""){
		d ..GetFreeFreqTimeList(OrderFreqFreeTimeStr,.ExecTimeList)	;不规则分发时间频次，直接使用用户选择的分发时间
	}elseif FreqRowid'=""{
		d ..GetFreqTimeList(FreqRowid,.ExecTimeList)				;有频次分发时间
	}else{
		d ..GetNoFreqTimeList(HospID,ArcimRowid,.ExecTimeList)					;无频次医嘱分发时间
	}
	Q 0
}

/// 获取频次分发时间列表
ClassMethod GetFreqTimeList(FreqRowid, ByRef ExecTimeList)
{
	k ExecTimeList
	s Sub=0 for{
		s Sub=$O(^PHCFR(FreqRowid,"DT",Sub)) Q:Sub=""
		s DispTime=$P(^PHCFR(FreqRowid,"DT",Sub),"^",1)
		continue:DispTime=""
		s TimeList(DispTime)=""
	}
	s DispTime="" for{
		s DispTime=$O(TimeList(DispTime)) Q:DispTime="" 
		s ExecTimeList($I(ExecTimeList))=DispTime
	}
	Q 1
}

/// 无频次医嘱分发时间 医生站设置->常规设置->无频次长嘱滚动默认开始时间
ClassMethod GetNoFreqTimeList(HospID = "", ArcimRowid = "", ByRef ExecTimeList)
{
	k ExecTimeList
	s DispTime=""
	//医生站设置->医嘱项扩展设定，判断是否为"计入不计出医嘱",如果是则取对应无频次长嘱滚动默认开始时间
	if ArcimRowid'=""{
		s DHCARCIMRowid=$O(^DHCItmMast("0","ARCIM",ArcimRowid,0))
		if DHCARCIMRowid'="" {
			s DARCIMCountInButNotOutFlag=$p($G(^DHCItmMast(DHCARCIMRowid)),"^",27)
			if (DARCIMCountInButNotOutFlag="Y") {
				s DARCIMCountInButNotOutIPLongOrdRollSttTime=$P(^DHCItmMast(DHCARCIMRowid),"^",28)
				if (DARCIMCountInButNotOutIPLongOrdRollSttTime'="") {
					s DispTime=..%ZTH(DARCIMCountInButNotOutIPLongOrdRollSttTime)
				}
			}
		}
	}
	if DispTime=""{
		s IPLongOrderRollStartTime=..%GetConfig("IPLongOrderRollStartTime",HospID)
		s DispTime=+..%ZTH(IPLongOrderRollStartTime)
	}
	s ExecTimeList($I(ExecTimeList))=DispTime
	Q 1
}

/// 格式化自定义分发时间列表
ClassMethod GetFreeFreqTimeList(OrderFreqFreeTimeStr, ByRef ExecTimeList)
{
	k ExecTimeList
	for i=1:1:$L(OrderFreqFreeTimeStr,"|"){
		s DispTime=$p(OrderFreqFreeTimeStr,"|",i)
		continue:DispTime=""
		s TimeList(DispTime)=""
	}
	s DispTime="" for{
		s DispTime=$O(TimeList(DispTime)) Q:DispTime="" 
		s ExecTimeList($I(ExecTimeList))=DispTime
	}
	Q 1
}

/// 如果护士选择了主医嘱绑定时间的情况
ClassMethod GetNurLinkDispTime(OEORIRowId, ByRef ExecList)
{
	s Ord=+OEORIRowId,Sub=$P(OEORIRowId,"||",2)
	s LinkOrdItemID=$p($g(^OEORD(Ord,"I",Sub,11)),"^",39)
	Q:LinkOrdItemID="" 0
	s MainOrd=+LinkOrdItemID,MainSub=$P(LinkOrdItemID,"||",2)

	
	s OrdFreqInfo=##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdFreqInfo(LinkOrdItemID)	
	s LinkIntervalTimeFlag=$List(OrdFreqInfo,7)		//间隔小时频次
	s LinkOrderFreqDispTimeStr=$List(OrdFreqInfo,4)
	s LinkOrderFreqFactory=$List(OrdFreqInfo,3)
	
	;取护士选择关联的分发时间
	s NurseExecLinkFreqDispTimeStr=$p($g(^OEORD(Ord,"I",Sub,"DHC")),"^",69)
	for i=1:1:$L(NurseExecLinkFreqDispTimeStr,"|"){
		s LinkDispTime=$p(NurseExecLinkFreqDispTimeStr,"|",i)
		continue:LinkDispTime=""
		s ind=$I(NurExecLinkFreqDispTimeList)
		s NurExecLinkFreqDispTimeList(ind)=LinkDispTime
	}
	s Date="" for{
		s Date=$O(ExecList(Date)) Q:Date=""
		d GetMainDateExecList
		s MainDateExecCount=$O(MainDateExecList(""),-1)
		continue:'$D(MainDateExecList)
		
		s DateCount=0,UseredExecList=$LB(),Time="" for{
			s Time=$O(ExecList(Date,Time)) Q:Time=""
			if $D(NurExecLinkFreqDispTimeList){
				s ind=0 for{
					s ind=$O(ExecList(Date,Time,ind)) Q:ind=""
					s DateCount=$I(DateCount)
					s LinkDispTime=$G(NurExecLinkFreqDispTimeList(DateCount))
					if (LinkDispTime'="")&&$D(MainDateExecList(0,LinkDispTime)){
						s ExecList(Date,Time,ind).LinkOrdExecID=$G(MainDateExecList(0,LinkDispTime,1))
					}elseif (LinkIntervalTimeFlag="Y"){
						///间隔小时频次有可能每日的分发时间不一致，这里需要按照次数去关联主医嘱的执行记录
						for i=1:1:$L(LinkOrderFreqDispTimeStr,$C(1)) {
							s LoopDispDesc=$p(LinkOrderFreqDispTimeStr,$C(1),i)
							s LoopDispTime=$ZTH(LoopDispDesc)
							if (LoopDispTime=LinkDispTime){
								//从后往前取
								s ExecList(Date,Time,ind).LinkOrdExecID=$G(MainDateExecList(MainDateExecCount-(LinkOrderFreqFactory-i)))
							}
						}
					}
					s $List(UseredExecList,*+1)=ExecList(Date,Time,ind).LinkOrdExecID
					
				}
			}
			//优先从护士关联的分时段中去取，护士没有选择 按顺序关联主医嘱当天剩余的执行记录
			s ind=0 for{
				s ind=$O(ExecList(Date,Time,ind)) Q:ind=""
				if (ExecList(Date,Time,ind).LinkOrdExecID'=""){
					continue
				}
				//找到一个尚未使用的执行记录id，并绑定到子医嘱上
				s LinkOrdExecID=""
				s i=0 for{
					s i=$O(MainDateExecList(i)) Q:i=""
					s LinkOrdExecID=$G(MainDateExecList(i))
					if $LISTFIND(UseredExecList,LinkOrdExecID)=0{
						s $List(UseredExecList,*+1)=LinkOrdExecID
						Quit
					}
				}
				s ExecList(Date,Time,ind).LinkOrdExecID=LinkOrdExecID
			}
		}
	}
	Q 1
GetMainDateExecList
	k MainDateExecList
	s XSub=0 for{
		s XSub=$O(^OEORDi(0,"OrdItem",MainOrd,MainSub,Date,XSub)) Q:XSub=""
		s LinkDispTime=$p($g(^OEORD(MainOrd,"I",MainSub,"X",XSub)),"^",2)
		s MainDateExecList(0,LinkDispTime,$I(MainDateExecList(0,LinkDispTime)))=LinkOrdItemID_"||"_XSub
	}
	s LinkDispTime="" for{
		s LinkDispTime=$O(MainDateExecList(0,LinkDispTime)) Q:LinkDispTime=""
		s ind=0 for{
			s ind=$O(MainDateExecList(0,LinkDispTime,ind)) Q:ind=""
			s MainDateExecList($I(MainDateExecList))=MainDateExecList(0,LinkDispTime,ind)
		}
	}
	Q
}

/// 获取每次执行数量 兼容多剂量
ClassMethod GetOrdExecQtyToList(OEORIRowId, ByRef ExecList)
{
	s Ord=+OEORIRowId,Sub=$P(OEORIRowId,"||",2)
	;获取多剂量信息
	s DQSub=0 for{
		s DQSub=$O(^OEORD(Ord,"I",Sub,"DQ",DQSub)) Q:DQSub=""
		s Active=$P(^OEORD(Ord,"I",Sub,"DQ",DQSub),"^",2)
		continue:(Active="N")
		s SttDate=$P(^OEORD(Ord,"I",Sub,"DQ",DQSub),"^",3)
		s SttTime=$P(^OEORD(Ord,"I",Sub,"DQ",DQSub),"^",4)
		s FreqTimeDoseStr=$P(^OEORD(Ord,"I",Sub,"DQ",DQSub),"^",1)
		d ..GetFreqTimeDoseStrToList(SttDate,SttTime,FreqTimeDoseStr,.QtyList)
	}
	;如果没有多剂量信息 那么直接取本次医嘱的剂量
	s DoseQty=$P($G(^OEORD(Ord,"I",Sub,2)),"^",1)
	s DoseUomID=$p($g(^OEORD(Ord,"I",Sub,2)),"^",3)
	s ArcimRowid=$P($G(^OEORD(Ord,"I",Sub,1)),"^",2)
	s PackQty=$p($g(^OEORD(Ord,"I",Sub,9)),"^",4)
	s PhQtyOrd=$p($g(^OEORD(Ord,"I",Sub,1)),"^",12)
	s ProtocolPackUOMDR=$p($g(^OEORD(Ord,"I",Sub,"DHC")),"^",13)
	s FreqTimeDoseStr=$P($G(^OEORD(Ord,"I",Sub,"DHC")),"^",59)
	s PriorRowid=$P($G(^OEORD(Ord,"I",Sub,1)),"^",8)
	s SttDate=$P($G(^OEORD(Ord,"I",Sub,1)),"^",9)
	s SttTime=$P($G(^OEORD(Ord,"I",Sub,1)),"^",10)
	s EpisodeID=$P($G(^OEORD(Ord)),"^",1)
	s HospID=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s VirtualtLongFlag=##class(web.DHCDocOrderVirtualLong).GetVirtualtLongFlag(OEORIRowId)
	if VirtualtLongFlag'="Y"{
		;虚拟长期滚出来的临时医嘱也算长期,不按门急诊只产生一条执行记录配置合并执行记录
		s FillerNo=$P($G(^OEORD(Ord,"I",Sub,9)),"^",12)
		s:FillerNo'="" VirtualtLongFlag="Y"
	}
	Q ..GetExecQtyToList(.ExecList,PriorRowid,ArcimRowid,SttDate,SttTime,DoseQty,DoseUomID,PhQtyOrd,PackQty,ProtocolPackUOMDR,FreqTimeDoseStr,VirtualtLongFlag,AdmType,HospID,.QtyList)
}

ClassMethod GetExecQtyToList(ByRef ExecList, PriorRowid, ArcimRowid, SttDate, SttTime, DoseQty, DoseUomID, PhQtyOrd, PackQty, PackUomID, OrderFreqTimeDoseStr, VirtualtLongFlag, AdmType, HospID, ByRef QtyList)
{
	if '$D(QtyList)&&(OrderFreqTimeDoseStr'=""){
		d ..GetFreqTimeDoseStrToList(SttDate,SttTime,OrderFreqTimeDoseStr,.QtyList)
	}
	s:+DoseQty=0 DoseQty=1
	s drgform=$p($g(^ARCIM(+ArcimRowid,+$p(ArcimRowid,"||",2),1)),"^",12)
	s OrderType=##class(web.DHCDocOrderCommon).GetOrderType(ArcimRowid)
	;计算OEORE_QtyAdmin
	s AdminQty=""
	i OrderType="R"{
		i PackQty'=""{
			s convFac=##class(appcom.OEDispensing).convFac(ArcimRowid,PackUomID)
			s AdminQty=PackQty*convFac
		}
	}else{
		;有库存项,就会有基本单位和计价单位的换算关系
		s INCIrow=##class(appcom.OEDispensing).GetINCI(+ArcimRowid)
		i INCIrow="" {
			i PhQtyOrd'="" {
				s AdminQty=PhQtyOrd
			}elseif (PackQty'=""){
				s AdminQty=PackQty
			}else{
				s AdminQty=DoseQty
			}
		}else{
			if PackQty'=""{
				s convFac=##class(appcom.OEDispensing).convFac(ArcimRowid,PackUomID)
				s AdminQty=PackQty*convFac
			}elseif DoseQty'=""{
				s convFac=##class(appcom.OEDispensing).convFac(ArcimRowid,DoseUomID)
				s AdminQty=DoseQty*convFac
			}
		}
		s:+AdminQty=0 AdminQty=1
	}
	s TotalExecQty=0,TotalAdminQty=0
	s Date="" for{
		s Date=$O(ExecList(Date)) Q:Date=""
		s Time="" for{
			s Time=$O(ExecList(Date,Time)) Q:Time=""
			s ind=0 for{
				s ind=$O(ExecList(Date,Time,ind)) Q:ind=""
				s ExecQty=""
				if $D(QtyList){
					s DTSecond=Date*24*3600+Time	
					s DTSecond=+$O(QtyList(DTSecond+1),-1)	;倒叙取上一个满足的时间范围，需要加1
					s OldTime=ExecList(Date,Time,ind).OldTime	;首日开始时间可能变化，用原先的开始时间
					s DSPTime=$CASE(OldTime,"":Time,:OldTime)
					s DSPTime=+$O(QtyList(DTSecond,DSPTime+1),-1)
					s ExecQty=$G(QtyList(DTSecond,DSPTime))
				}
				s:ExecQty="" ExecQty=DoseQty
				s OneAdminQty=AdminQty
				if (OrderType="R")&&(PackQty="") s OneAdminQty=$$calcqty^DHCOEOrdItem(drgform,DoseUomID,ExecQty,AdmType)
				s ExecList(Date,Time,ind).ExecQty=ExecQty
				s ExecList(Date,Time,ind).AdminQty=OneAdminQty
				s TotalExecQty=TotalExecQty+ExecQty
				s TotalAdminQty=TotalAdminQty+OneAdminQty
			}
		}
	}
	if ..IsGenOneExec(PriorRowid, ArcimRowid, AdmType, VirtualtLongFlag, HospID){
		if (PackQty'="")||(PhQtyOrd'=""){
			s TotalAdminQty=AdminQty
		}
		;中草药的取药关联医嘱
		s LinkOrdExecID=""
		if $D(ExecList(SttDate, SttTime,1)){
			s LinkOrdExecID=ExecList(SttDate, SttTime,1).LinkOrdExecID
		}
		k ExecList
		s ExecList=$I(ExecList)
		s ExecList=$I(ExecList),ind=$I(ExecList(SttDate, SttTime))
		s ExecList(SttDate,SttTime,ind)={"ExecQty":(TotalExecQty),"AdminQty":(TotalAdminQty),"LinkOrdExecID":(LinkOrdExecID)}
	}
	Q 1
}

/// 不同剂量串转LIST
ClassMethod GetFreqTimeDoseStrToList(SttDate, SttTime, FreqTimeDoseStr, ByRef QtyList)
{
	Q:FreqTimeDoseStr=""
	s FirstDayFreqTimeDoseStr=$P(FreqTimeDoseStr,"@",2)
	s FreqTimeDoseStr=$P(FreqTimeDoseStr,"@",1)
	s SttDate=+..%ZDH(SttDate)
	s SttTime=+..%ZTH(SttTime)
	s DTSecond=SttDate*24*3600+SttTime
	if FirstDayFreqTimeDoseStr'=""{
		s myFreqTimeDoseStr=FirstDayFreqTimeDoseStr
		d OneFreqTimeDoseStr
		s DTSecond=(SttDate+1)*24*3600
		s myFreqTimeDoseStr=FreqTimeDoseStr
		d OneFreqTimeDoseStr
	}else{
		s myFreqTimeDoseStr=FreqTimeDoseStr
		d OneFreqTimeDoseStr
	}
	Q
OneFreqTimeDoseStr
	for i=1:1:$L(myFreqTimeDoseStr,"!"){
		s OrderDoseQtyStr=$p(myFreqTimeDoseStr,"!",i)
		s PHCDTRowID=$p(OrderDoseQtyStr,"$",1)
		continue:PHCDTRowID=""
		s PHCDTRowID=$Replace(PHCDTRowID,"_","||")
		s PHCDTTime=$p($g(^PHCFR(+PHCDTRowID,"DT",$p(PHCDTRowID,"||",2))),"^",1)
		continue:PHCDTTime=""
		s OrderDoseQty=$p(OrderDoseQtyStr,"$",2)
		continue:OrderDoseQty=""
		s QtyList(DTSecond,PHCDTTime)=OrderDoseQty
	}
	Q
}

ClassMethod InsByExecList(OEORIRowId, GenDate, ExecList)
{
	;之前执行记录BillType一直未传,是否该传医嘱上的费别?
	s BillType=$p($g(^OEORD(+OEORIRowId,"I",$P(OEORIRowId,"||",2),11)),"^",18)
	;长期生成指定日期，临时生成全部
	if ##class(DHCDoc.Order.Common).IsLongOrdItem(OEORIRowId){
		s Date=GenDate
		d InsOneDate
	}else{
		s Date="" for{
			s Date=$O(ExecList(Date)) Q:Date=""
			d InsOneDate
		}
	}
	Q 0
InsOneDate
	s SeqNo=0,Time="" for{
		s Time=$O(ExecList(Date,Time)) Q:Time=""
		s ind=0 for{
			s ind=$O(ExecList(Date,Time,ind)) Q:ind=""
			s ExecObj=ExecList(Date,Time,ind)
			s rtn=..InsOEORE(OEORIRowId,Date,Time,ExecObj.ExecQty,ExecObj.AdminQty,$I(SeqNo),ExecObj.LinkOrdExecID,ExecObj.XTime,BillType)
			if $P(rtn,"^",1)=0{
				s OEORERowId=$P(rtn,"^",2)
				if (ExecObj.AppRepID'="")&&(OEORERowId'=""){
					;调用新产品开发组接口,更新申请单相关表与执行表关联
					s InterfaceParas=ExecObj.AppRepID_"^"_ExecObj.BodyPartID_"^"_OEORERowId_"^"_ExecObj.BillItmID
					d ##class(web.DHCAPPInterface).UpdAppRepItm(InterfaceParas)
				}
			}
		}
	}
	Q
}

/// 插入执行记录
ClassMethod InsOEORE(OEORIRowId, Date, Time, ExecQty, AdminQty, SeqNo, LinkOEORE, XTime = "", BillType = "")
{
	s $ZT="InsOEOREErr"
	s Ord=+OEORIRowId,Sub=$P(OEORIRowId,"||",2)
	;如果本次执行记录已经生成,则退出,2018.06.25修改为判断OEORI_ExVol字段
 	;Q:$O(^OEORDi(0,"Vol",Ord,Date,SeqNo,Sub,0)) 0
 	s ExistChild=$O(^OEORDi(0,"Vol",Ord,Date,SeqNo,Sub,0))
 	if ExistChild{
		Q 0_"^"_OEORIRowId_"||"_ExistChild	
	}
 	k OEORE,OEOREExt
 	S OEORE(0)=OEORIRowId     
	S OEORE(26)=Date             ; OEORE_ExStDate
	S OEORE(27)=Time             ; OEORE_ExStTime
	S OEORE(16)=+ExecQty         ; OEORE_PhQtyOrd   (OEORI(29))
	S OEORE(42)=+AdminQty 		 ; OEORE_QtyAdmin    单次计费数量;add by zhouzq 2012.03.01
	S OEORE(43)="TB"
	s OEORE(49)=BillType
	if OEORE(49)="" s OEORE(49)=$$GetDefaultBillType^DHCOEOrdExec(OEORIRowId)
	s OEORE(62)=SeqNo
	;小时医嘱用
	s BillFlag=""
	if XTime'="" {
		s OEORE(63)=Date
		S OEORE(64)=XTime     ;S OEORE(36)=XTime
		s BillFlag="Y"	;BillFlag
	}
	;医保标志
	s XSub=$o(^OEORD(Ord,"I",Sub,"X",""),-1)
	if (XSub>0){
		s OEORE(77)=$p($g(^OEORD(Ord,"I",Sub,"X",XSub)),"^",49)
	}else{
		s OEORE(77)=$p($g(^OEORD(Ord,"I",Sub,3)),"^",3)
	}
	TS
	s err=0
	&SQL(Insert into SQLUser.OE_OrdExec Values :OEORE())
	i SQLCODE {
		TRO
		Quit SQLCODE
	}
	s OEORERowId=%ROWID
	s ItemStatus=$p(^OEORD(Ord,"I",Sub,1),"^",13)
	s OEOREExt(30)=ItemStatus
	s OEOREExt(32)=LinkOEORE
	s OEOREExt(48)=BillFlag
	&SQL(Update SQLUser.OE_OrdExecExt VALUES :OEOREExt() WHERE OEORE_RowId=:OEORERowId)
	i SQLCODE {
		TRO
		Quit SQLCODE
	}
	s NeedInsDspFlag=1
	;门诊如果存在整包装数量,则判断已经存在打包表记录,就不插入
	s AdmType=$p($g(^PAADM($P(^OEORD(Ord),"^",1))),"^",2)
	s PackQty=$p($g(^OEORD(Ord,"I",Sub,9)),"^",4)
	i AdmType'="I",PackQty'="",$d(^DHCOEDISQTY(0,"OEORI",OEORIRowId)) s NeedInsDspFlag=0
	
	s DspRowID=""
	i NeedInsDspFlag=1 {
		s InsDspRtn=##class(appcom.OEDispensing).Insert(OEORERowId,SeqNo)
		if +InsDspRtn'=0 {
			s err=+InsDspRtn
			TRO
			d ##class(DHCDoc.Log.Common).General("Insert","appcom.OEDispensing","Insert","插入打包表失败",OEORERowId,InsDspRtn) 
			Quit err
		}else{
			s DspRowID=$p(InsDspRtn,"^",2)
		}
	}
	
	;此处不处理子医嘱原因:因为主医嘱插入执行记录时子医嘱还未生成
	TC
	if DspRowID'="" {
		s GenAfterErrFlag="N",GenAfterErrDesc=""
		;处理批次和在途
		;不是开始日期的执行记录都按照滚出来的医嘱处理
		s RollOrder=0
		s OrderStarDate=$p($g(^OEORD(+OEORERowId,"I",$P(OEORERowId,"||",2),1)),"^",9)
		if Date'=OrderStarDate  s RollOrder=1
		s ImportByContingences=$p($g(^OEORD(+OEORERowId,"I",$P(OEORERowId,"||",2),"DHC")),"^",62)
		//应急程序导入的数据不校验库存
		if (ImportByContingences="Y"){s RollOrder=1}
		
		s InvokeRtn=##class(web.DHCOEDispensing).PortForDurg(AdmType,OEORIRowId,OEORERowId,1,RollOrder)
		if InvokeRtn'=0 {
			s GenAfterErrFlag="Y",GenAfterErrDesc="处理批次或在途失败,DspRowId:"_DspRowID
			d ##class(DHCDoc.Log.Common).General("Insert","web.DHCOEDispensing","PortForDurg","处理批次或在途失败,DspRowId:"_DspRowID,OEORERowId,InvokeRtn)
		}
		i InvokeRtn=0 {
			;材料减库存,门诊材料减库存应该在收费结算后
			;i AdmType="I" d ##class(appcom.OEOrdItem).DispMaterial(OEORERowId)
			;物资接口根据就诊类型判断是否扣减库存
			s InvokeRtn=##class(appcom.OEOrdItem).DispMaterial(OEORERowId)
			i InvokeRtn'=0 {
				s GenAfterErrFlag="Y",GenAfterErrDesc="物资减库存接口调用失败,DspRowId:"_DspRowID
				d ##class(DHCDoc.Log.Common).General("Insert","appcom.OEOrdItem","DispMaterial","物资减库存接口调用失败,DspRowId:"_DspRowID,OEORERowId,InvokeRtn)
			}
		}
		i GenAfterErrFlag="Y" {
			;将错误标识和描述更新到执行扩展表
			&SQL(Update SQLUser.OE_OrdExecExt Set OEORE_GenAfterErrFlag=:GenAfterErrFlag,OEORE_GenAfterErrDesc=:GenAfterErrDesc Where OEORE_RowId=:OEORERowId)
		}
	}else{
		;处理收费项关联的库存项存在需要扣减库存的情况
		s InvokeRtn=##class(appcom.OEOrdItem).DispMaterial(OEORERowId)
		i InvokeRtn'=0 {
			s GenAfterErrFlag="Y",GenAfterErrDesc="收费项物资关联物资减库存接口调用失败,DspRowId:"_OEORERowId
			d ##class(DHCDoc.Log.Common).General("Insert","appcom.OEOrdItem","DispMaterial","收费项物资关联物资减库存接口调用失败,OEORERowId:"_OEORERowId,OEORERowId,InvokeRtn)
		}
	}
	Q 0_"^"_OEORERowId
InsOEOREErr
	TRO
	b ;InsOEOREErr
	Q -100
}

ClassMethod IsGenOneExec(PriorRowid, ArcimRowid, AdmType, VirtualtLongFlag, HospID) As %Boolean
{
	s PriorCode=$p($g(^OECPR(+PriorRowid)),"^",1)
	Q:(" OUT ONE "[(" "_PriorCode_" ")) 1
	;出院带药遵从旧版 只生成一条执行记录 数量汇总到这一条执行记录上 (取药医嘱也遵从此逻辑)
	if (AdmType'="I")&&(VirtualtLongFlag'="Y"){
		s OrderItemCatRowid=##class(web.DHCDocOrderCommon).GetOrderSubCat(ArcimRowid)
		s OPGenOneExecCat="^"_..%GetConfig("OPGenOneExecCat",HospID)_"^"
		Q:(OPGenOneExecCat[("^"_OrderItemCatRowid_"^")) 1
	}
	Q 0
}

ClassMethod IsGenOneExecOrdItem(OEORIRowId) As %Boolean
{
	s Ord=+OEORIRowId,Sub=$P(OEORIRowId,"||",2)
	s ArcimRowid=$P($G(^OEORD(Ord,"I",Sub,1)),"^",2)
	s PriorRowid=$P($G(^OEORD(Ord,"I",Sub,1)),"^",8)
	s EpisodeID=$P($G(^OEORD(Ord)),"^",1)
	s HospID=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s VirtualtLongFlag=##class(web.DHCDocOrderVirtualLong).GetVirtualtLongFlag(OEORIRowId)
	Q ..IsGenOneExec(PriorRowid, ArcimRowid, AdmType, VirtualtLongFlag, HospID)
}

}
