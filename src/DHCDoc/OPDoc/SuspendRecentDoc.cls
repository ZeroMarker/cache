Class DHCDoc.OPDoc.SuspendRecentDoc Extends DHCDoc.Util.RegisteredObject
{

/// 增加暂时离开原因
/// w ##class(DHCDoc.OPDoc.SuspendRecentDoc).InsertSuspendReason("","01","ceshi","2023-03-02")
ClassMethod InsertSuspendReason(RowID, Code, Desc, DateFrom, DateTo)
{
	q:((Code="")||(Desc="")||(DateFrom="")) ""
	if DateFrom'="" s DateFrom=..%ZDH(DateFrom)
	if DateTo'="" s DateTo=..%ZDH(DateTo)
	if (DateTo'="")&&(DateTo<DateFrom) q "截止日期不能小于生效日期"
	s SameFlag=..CheckuspendReasonSame(RowID, Code, Desc)
	q:SameFlag=1 "代码重复"
	q:SameFlag=2 "描述重复"
	if (RowID=""){
		&SQL(insert into CF_DOC_OPDoc.SuspendReason
		(SusR_Code,SusR_Desc,SusR_DateFrom,SusR_DateTo
		) Values(:Code,:Desc,:DateFrom,:DateTo))
	}else{
		&SQL(Update CF_DOC_OPDoc.SuspendReason set		
		SusR_Code=:Code,SusR_Desc=:Desc,SusR_DateFrom=:DateFrom
		,SusR_DateTo=:DateTo
		 where RowID=:RowID)	
	}
	b ;33
	s rtn=SQLCODE
	q rtn
}

ClassMethod CheckuspendReasonSame(InitRowID, Code, Desc)
{
	s rtn=0
	s RowID=0
	for{
		s RowID=$O(^CF.DOC.OPDoc.SuspendReason(RowID))
		q:RowID=""
		continue:InitRowID=RowID
		s TCode=$P(^CF.DOC.OPDoc.SuspendReason(RowID),"^",1)
		s TDesc=$P(^CF.DOC.OPDoc.SuspendReason(RowID),"^",2)
		if (TCode=Code){
			s rtn=1
			q
			}
		if (TDesc=Desc){
			s rtn=2
			q
			}
	}
	q rtn
}

/// 查询暂时离开原因
Query FindSuspendReason(TCode As %String = "", TDesc As %String = "", AllFlag As %String = "Y") As %Query(ROWSPEC = "RowID:%String,Code:%String,Desc:%String,DateFrom:%String,DateTo:%String")
{
}

ClassMethod FindSuspendReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSuspendReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindSuspendReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSuspendReasonExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindSuspendReasonExecute(ByRef qHandle As %Binary, TCode As %String = "", TDesc As %String = "", AllFlag As %String = "Y") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.OPDoc.SuspendRecentDoc","FindSuspendReason","","","N")
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	s RowID=0
	for{
		s RowID=$O(^CF.DOC.OPDoc.SuspendReason(RowID))
		q:RowID=""
		s Code=$P(^CF.DOC.OPDoc.SuspendReason(RowID),"^",1)
		s Desc=$P(^CF.DOC.OPDoc.SuspendReason(RowID),"^",2)
		continue:((TCode'="")&&(Code'[TCode))
		continue:((TDesc'="")&&(Desc'[TDesc))
		s DateFrom=$P(^CF.DOC.OPDoc.SuspendReason(RowID),"^",3)
		s DateTo=$P(^CF.DOC.OPDoc.SuspendReason(RowID),"^",4)
		continue:((AllFlag'="Y")&&(DateFrom>+$H)&&(DateFrom'=""))
		continue:((AllFlag'="Y")&&(DateTo<+$H)&&(DateTo'=""))
		if DateFrom'="" s DateFrom=..%ZD(DateFrom)
		if DateTo'="" s DateTo=..%ZD(DateTo)
		set Data=$lb(RowID,Code,Desc,DateFrom,DateTo)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// 暂时已离开
/// w ##class(DHCDoc.OPDoc.SuspendRecentDoc).SuspendRecentLevea("60","1608","1","30","18881")
ClassMethod SuspendRecentLevea(LocDr, DocDr, SuspendReason, RangTime, UserID)
{
	s ^tempqujian("SuspendRecentLevea")=$lb(LocDr, DocDr, SuspendReason, RangTime, UserID)
	s NowDate=..%SysDate()
	s NowTime=..%SysTime()
	s PreSuspendDate=NowDate
	s PreSuspendTime=NowTime+(RangTime*60)
	if (PreSuspendTime>86340){
		s PreSuspendTime=PreSuspendTime-86340
		s PreSuspendDate=PreSuspendDate+1
		}
	&SQL(insert into DOC_OPDoc.SuspendRecentLog 
		(LocDr,DocDr,SuspendReason,SuspendDate,SuspendTime,
		SuspendRangTime,PreSuspendDate,PreSuspendTime,SuspendUser
		,SuspendUserDate,SuspendUserTime
		) Values(:LocDr,:DocDr,:SuspendReason,:NowDate,:NowTime
		,:RangTime,:PreSuspendDate,:PreSuspendTime,:UserID
		,:NowDate,:NowTime
		))
		b ;3
	s rtn=SQLCODE
	q rtn
}

/// 归来
ClassMethod SuspendRecentBack(RowID, UserID)
{
	s NowDate=..%SysDate()
	s NowTime=..%SysTime()
	&SQL(Update DOC_OPDoc.SuspendRecentLog set		
		ActSuspendDate=:NowDate,ActSuspendTime=:NowTime,BackSuspendUser=:UserID
		,BackSuspendUserDate=:NowDate,BackSuspendUserTime=:NowTime
	where RowID=:RowID)
	s rtn=SQLCODE
	q rtn
}

/// 判断是否是离开状态
/// 返回 0 正常 1^Rowid 离开未超过预计时间 2^RowID 离开已超过预计时间
ClassMethod CheckSuspendStatus(LocDr, DocDr)
{
	q:((LocDr="")||(DocDr="")) "0^"
	s NowDate=..%SysDate()
	s NowTime=..%SysTime()
	s Flag=0
	s InitRowID=""
	s RowID=""
	for{
		s RowID=$O(^DOC.OPDoc.SuspendRecentLogi("DateLocDoc",NowDate,LocDr,DocDr,RowID))
		q:RowID=""
		s ActSuspendDate=$P(^DOC.OPDoc.SuspendRecentLog(RowID),"^",9)
		continue:ActSuspendDate'=""
		s PreSuspendTime=$P(^DOC.OPDoc.SuspendRecentLog(RowID),"^",8)
		if (PreSuspendTime>NowTime){s Flag=2 }else{s Flag=1}
		s InitRowID=RowID
		q:InitRowID'=""
		}
	s rtn=Flag_"^"_InitRowID
	q rtn
}

}
