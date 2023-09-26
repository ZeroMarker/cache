Class User.DHCNurTreatQueue Extends %Persistent
{

Property TreatLocDr As %String(TRUNCATE = 1);

Property TreatAdmDr As %String(TRUNCATE = 1);

Property TreatQueNo As %String(TRUNCATE = 1);

/// Wait等待/Call呼叫/Skip过号/Finish完成/Ready准备/Cancel取消
Property TreatQueState As %String(TRUNCATE = 1);

/// 1优先/2正常/3过号
Property TreatQuePrior As %String(TRUNCATE = 1);

Property TreatQueDate As %Library.Date(FORMAT = 1);

Property TreatQueTime As %Library.Time;

Property TreatRecDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, Required ];

Property TreatRecTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

Property TreatRecUser As %String(TRUNCATE = 1);

Property TreatQueueCat As %String(TRUNCATE = 1);

Property TreatReportType As %String(TRUNCATE = 1);

Property TreatCallUser As %String(TRUNCATE = 1);

Property TreatQueueClient As %String(TRUNCATE = 1);

Property TreatServerIP As %String(TRUNCATE = 1);

// 列表类型值与dhcnuropexec中的seatFlag相对应

Property SeatFlag As %String(TRUNCATE = 1);

Index QueLocDate On (TreatLocDr, TreatQueDate, TreatQuePrior, TreatQueNo);

Index Adm On TreatAdmDr;

Index AdmDate On (TreatAdmDr, TreatQueDate);

Index AdmLoc On (TreatAdmDr, TreatLocDr);

Index AdmDateLoc On (TreatAdmDr, TreatQueDate, TreatLocDr);

Index QueDateCat On (TreatQueDate, TreatQueueCat, TreatQuePrior, TreatQueNo);

Index QueDateLocCat On (TreatQueDate, TreatLocDr, TreatQueueCat, TreatQuePrior, TreatQueNo);

Index QueDateLoc On (TreatQueDate, TreatLocDr, TreatQueueCat, TreatQuePrior);

/// SeatFlag:2是治疗，3是输液
ClassMethod Save(id, parr As %String, allClient = "") As %String
{
	s clientId=""
  	s l=$L(parr,"^")
	for i=1:1:l
	{
		s itm=$P(parr,"^",i)
		if itm="" continue
		s name=$P(itm,"|")
		s val=$P(itm,"|",2)
		s tmp(name)=val
	}
	if $G(id)=""{
		//护士执行界面操作
		if $G(tmp("RegNo"))="" q "请先查询病人"
		s papmiId=$O(^PAPERi("PAPMI_PatNo",$$$ALPHAUP(tmp("RegNo")),""))
		s CurrAdm=""
		s EpisodeIDO=$O(^PAPERdr(papmiId,"ADM","O",""),-1)
		s:EpisodeIDO="" EpisodeIDO=0
		s EpisodeIDE=$O(^PAPERdr(papmiId,"ADM","E",""),-1) //add by linyuxu
		s:EpisodeIDE="" EpisodeIDE=0
		i EpisodeIDO>EpisodeIDE s CurrAdm=EpisodeIDO
		e  s CurrAdm=EpisodeIDE
		s tmp("TreatAdmDr")=CurrAdm
		
		if $D(tmp("TreatQueueCat")) s clientId = $G(tmp("TreatQueueCat"))
		if $ISVALIDNUM(clientId) d
		.s TreatQueueCat="T"_clientId ;$p(^DHCVISClient(clientId),"^",12)
		e  d
		.s TreatQueueCat=$G(tmp("TreatQueueCat"))
		s curId=..GetIdByAdm(CurrAdm,$G(tmp("TreatLocDr")),TreatQueueCat,$G(tmp("SeatFlag")))
		if curId'="" {
			if ($G(tmp("TreatQueState"))'="Finish")&($G(tmp("TreatQueState"))'="Cancel") q "病人已在列表中!"
			else  s id=curId
		}else {
			if $G(tmp("TreatQueState"))="Finish" q 0
			s TreatQueueCat=""
			if $D(tmp("TreatQueueCat")) s clientId = $G(tmp("TreatQueueCat"))
			if $ISVALIDNUM(clientId) d
			.s TreatQueueCat="T"_clientId ;$p(^DHCVISClient(clientId),"^",12)
			e  d
			.s TreatQueueCat=$G(tmp("TreatQueueCat"))
			s InTreatQueueCat=$case(allClient,"":TreatQueueCat,:"")
			s tmp("TreatQueNo")=..GetMaxQueNoByLoc($G(tmp("TreatLocDr")),InTreatQueueCat)
		}
	}
	if $G(id)'="" s a=##class(User.DHCNurTreatQueue).%OpenId(id)
	else  s a=##class(User.DHCNurTreatQueue).%New()
	if $D(tmp("TreatLocDr")) s a.TreatLocDr=$G(tmp("TreatLocDr"))
	if $D(tmp("TreatAdmDr")) s a.TreatAdmDr=$G(tmp("TreatAdmDr"))
	if $D(tmp("TreatQueNo")) s a.TreatQueNo=$G(tmp("TreatQueNo"))
	if $D(tmp("TreatQueState")) s a.TreatQueState=$G(tmp("TreatQueState"))
	if $D(tmp("TreatQuePrior")) s a.TreatQuePrior=$G(tmp("TreatQuePrior"))
	if $D(tmp("TreatQueDate")) s a.TreatQueDate=..TransDate($G(tmp("TreatQueDate")))
	if $D(tmp("TreatQueTime")) s a.TreatQueTime=..TransTime($G(tmp("TreatQueTime")))
	if $D(tmp("TreatRecUser")) s a.TreatRecUser=$G(tmp("TreatRecUser"))
	if $D(tmp("TreatQueueCat"))  d ;s clientId = $G(tmp("TreatQueueCat"));if $ISVALIDNUM(clientId) d
	.s a.TreatQueueCat="T"_$G(tmp("TreatQueueCat"))  ;$p(^DHCVISClient(clientId),"^",12)
	.s a.TreatQueueClient=$G(tmp("TreatQueueCat"))
	if $D(tmp("TreatReportType")) s a.TreatReportType=$G(tmp("TreatReportType"))
	if $D(tmp("SeatFlag")) s a.SeatFlag=$G(tmp("SeatFlag"))
	if $D(tmp("TreatServerIP")) s a.TreatServerIP=$G(tmp("TreatServerIP"))
	s hasTreated=..GetIdByAdm(a.TreatAdmDr,a.TreatLocDr,a.TreatQueueCat,a.SeatFlag)
	b ;1
	q:(a.TreatQueState="Wait")&&(hasTreated'="") 0
	d a.%Save()
	s TreatQueNo=$G(tmp("TreatQueNo"))
	//q a.%Id()
	q 0
}

ClassMethod Save1(id, parr As %String) As %String
{
	s clientId=""
  	s l=$L(parr,"^")
	for i=1:1:l
	{
		s itm=$P(parr,"^",i)
		if itm="" continue
		s name=$P(itm,"|")
		s val=$P(itm,"|",2)
		s tmp(name)=val
	}
	if $G(id)=""{
		//护士执行界面操作
		if $G(tmp("RegNo"))="" q "请先查询病人"
		s papmiId=$O(^PAPERi("PAPMI_PatNo",$$$ALPHAUP(tmp("RegNo")),""))
		s CurrAdm=""
		s EpisodeIDO=$O(^PAPERdr(papmiId,"ADM","O",""),-1)
		s:EpisodeIDO="" EpisodeIDO=0
		s EpisodeIDE=$O(^PAPERdr(papmiId,"ADM","E",""),-1) //add by linyuxu
		s:EpisodeIDE="" EpisodeIDE=0
		i EpisodeIDO>EpisodeIDE s CurrAdm=EpisodeIDO
		e  s CurrAdm=EpisodeIDE
		s tmp("TreatAdmDr")=CurrAdm
		
		if $D(tmp("TreatQueueCat")) s clientId = $G(tmp("TreatQueueCat"))
		if $ISVALIDNUM(clientId) d
		.s TreatQueueCat="T"_$p(^DHCVISClient(clientId),"^",12)
		e  d
		.s TreatQueueCat=$G(tmp("TreatQueueCat"))
		s curId=..GetIdByAdm(CurrAdm,$G(tmp("TreatLocDr")),TreatQueueCat)
		if curId'="" {
			if ($G(tmp("TreatQueState"))'="Finish")&($G(tmp("TreatQueState"))'="Cancel") q "病人已在列表中!"
			else  s id=curId
		}
		else {
			if $G(tmp("TreatQueState"))="Finish" q 0
			s TreatQueueCat=""
			if $D(tmp("TreatQueueCat")) s clientId = $G(tmp("TreatQueueCat"))
			if $ISVALIDNUM(clientId) d
			.s TreatQueueCat="T"_clientId ;$p(^DHCVISClient(clientId),"^",12)
			e  d
			.s TreatQueueCat=$G(tmp("TreatQueueCat"))
			s tmp("TreatQueNo")=..GetMaxQueNoByLoc($G(tmp("TreatLocDr")),TreatQueueCat)
		}
	}
	if $G(id)'="" s a=##class(User.DHCNurTreatQueue).%OpenId(id)
	else  s a=##class(User.DHCNurTreatQueue).%New()
	if $D(tmp("TreatLocDr")) s a.TreatLocDr=$G(tmp("TreatLocDr"))
	if $D(tmp("TreatAdmDr")) s a.TreatAdmDr=$G(tmp("TreatAdmDr"))
	if $D(tmp("TreatQueNo")) s a.TreatQueNo=$G(tmp("TreatQueNo"))
	if $D(tmp("TreatQueState")) s a.TreatQueState=$G(tmp("TreatQueState"))
	if $D(tmp("TreatQuePrior")) s a.TreatQuePrior=$G(tmp("TreatQuePrior"))
	if $D(tmp("TreatQueDate")) s a.TreatQueDate=..TransDate($G(tmp("TreatQueDate")))
	if $D(tmp("TreatQueTime")) s a.TreatQueTime=..TransTime($G(tmp("TreatQueTime")))
	if $D(tmp("TreatRecUser")) s a.TreatRecUser=$G(tmp("TreatRecUser"))
	if $D(tmp("TreatQueueCat"))  d ;s clientId = $G(tmp("TreatQueueCat"));if $ISVALIDNUM(clientId) d
	.s a.TreatQueueCat="T"_$G(tmp("TreatQueueCat"))  ;$p(^DHCVISClient(clientId),"^",12)
	.s a.TreatQueueClient=$G(tmp("TreatQueueCat"))
	if $D(tmp("TreatReportType")) s a.TreatReportType=$G(tmp("TreatReportType"))
	if $D(tmp("SeatFlag")) s a.SeatFlag=$G(tmp("SeatFlag"))
	if $D(tmp("TreatServerIP")) s a.TreatServerIP=$G(tmp("TreatServerIP"))
	s hasTreated=..GetIdByAdm(a.TreatAdmDr,a.TreatLocDr,a.TreatQueueCat)
	q:(a.TreatQueState="Wait")&&(hasTreated'="") 0
	d a.%Save()
	s TreatQueNo=$G(tmp("TreatQueNo"))
	q a.%Id()_"^"_a.TreatQueNo
}

/// 转换数字格式日期
ClassMethod TransDate(Date) As %String
{
	if (Date'="") {
		i Date["/" q $zdh(Date,4)
		i Date["-" q $zdh(Date,3)
		q Date
	}
	else {
		q +$h
	}
}

/// 转换数字格式时间
ClassMethod TransTime(Time) As %String
{
	if (Time'="") {
		i $l(Time,":")=2 q $zth(Time,2)
		i $l(Time,":")=3 q $zth(Time)
		q Time
	}
	else {
		q $p($h,",",2)
	}
}

/// 判断病人当前科室当天是否已在治疗病人列表中
ClassMethod GetIdByAdm(Adm, LocId, TreatQueueCat As %String = "", SeatFlag = "") As %String
{
	//w ##class(User.DHCNurTreatQueue).GetIdByAdm(1,18)
	q:Adm="" ""
	s ret=""
	s curId="" f  s curId=$O(^User.DHCNurTreatQueueI("Adm"," "_Adm,curId)) q:(curId="")!(ret'="")  d
	.s curLocId=$ListGet(^User.DHCNurTreatQueueD(curId),3)
	.q:(LocId'="")&(LocId'=curLocId)
	.s curQueDate=$ListGet(^User.DHCNurTreatQueueD(curId),4)
	.q:curQueDate'=(+$h)
	.s QueueTypeId=$ListGet(^User.DHCNurTreatQueueD(curId),12)
	.s QueueSeatFlag=$ListGet(^User.DHCNurTreatQueueD(curId),16)
	.q:(SeatFlag'=QueueSeatFlag)
	.q:(TreatQueueCat'="")&&(TreatQueueCat'=QueueTypeId)
	.s QueueState=$ListGet(^User.DHCNurTreatQueueD(curId),7)
	.q:(QueueState="Finish")||(QueueState="Skip")||(QueueState="Cancel")	//完成治疗的不显示
	.s ret=curId
  	q ret
}

/// 取登陆科室排队分类最大的排队号
/// w ##class(User.DHCNurTreatQueue).GetMaxQueNoByLoc(85,"")
ClassMethod GetMaxQueNoByLoc(LocId, TreatQueueCat As %String = "") As %String
{
	//w ##class(User.DHCNurTreatQueue).GetMaxQueNoByLoc(799)
	q:LocId="" ""
	i TreatQueueCat="" d
	.s retQueNo=0
	.f i=1:1:3 d
	..s curQueNo="" f  s curQueNo=$O(^User.DHCNurTreatQueueI("QueLocDate"," "_LocId,+$h," "_i,curQueNo)) q:(curQueNo="")  d
	...i retQueNo<$TR(curQueNo," ","") s retQueNo=$TR(curQueNo," ","")
	e  d
	.s retQueNo=0
	.f i=1:1:3 d
	..s curQueNo="" f  s curQueNo=$O(^User.DHCNurTreatQueueI("QueDateLocCat",+$h," "_LocId," "_TreatQueueCat," "_i,curQueNo)) q:(curQueNo="")  d
	...i retQueNo<$TR(curQueNo," ","") s retQueNo=$TR(curQueNo," ","")
  	q retQueNo+1
}

/// 更新队列状态
ClassMethod UpdateStatus(Adm, Loc, statusCode)
{
	s queueDr=$O(^User.DHCNurTreatQueueI("AdmLoc"," "_Adm," "_Loc,""),-1)
	i queueDr'="" d
	.s queueObj=##class(User.DHCNurTreatQueue).%OpenId(queueDr)
	.s queueObj.TreatQueState=statusCode
	.d queueObj.%Save()
	.d queueObj.%Close()
}

Storage Default
{
<Data name="DHCNurTreatQueueDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TreatAdmDr</Value>
</Value>
<Value name="3">
<Value>TreatLocDr</Value>
</Value>
<Value name="4">
<Value>TreatQueDate</Value>
</Value>
<Value name="5">
<Value>TreatQueNo</Value>
</Value>
<Value name="6">
<Value>TreatQuePrior</Value>
</Value>
<Value name="7">
<Value>TreatQueState</Value>
</Value>
<Value name="8">
<Value>TreatQueTime</Value>
</Value>
<Value name="9">
<Value>TreatRecDate</Value>
</Value>
<Value name="10">
<Value>TreatRecTime</Value>
</Value>
<Value name="11">
<Value>TreatRecUser</Value>
</Value>
<Value name="12">
<Value>TreatQueueCat</Value>
</Value>
<Value name="13">
<Value>TreatReportType</Value>
</Value>
<Value name="14">
<Value>TreatCallUser</Value>
</Value>
<Value name="15">
<Value>TreatQueueClient</Value>
</Value>
<Value name="16">
<Value>SeatFlag</Value>
</Value>
<Value name="17">
<Value>TreatServerIP</Value>
</Value>
</Data>
<DataLocation>^User.DHCNurTreatQueueD</DataLocation>
<DefaultData>DHCNurTreatQueueDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCNurTreatQueueD</IdLocation>
<IndexLocation>^User.DHCNurTreatQueueI</IndexLocation>
<StreamLocation>^User.DHCNurTreatQueueS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
