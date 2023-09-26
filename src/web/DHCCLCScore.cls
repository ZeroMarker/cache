Import SQLUser

/// 编写者：吴玲玲
/// 编写日期：2012年10月29日
/// 功能描述：实现评分项码表的维护功能：包括添加，更新，删除功能
/// 表：DHCCLCScore，DHCCLCScoreOption
Class web.DHCCLCScore Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCCLCScore","FindCLCScore")
Query FindCLCScore() As %Query(ROWSPEC = "TRowid:%String,TCLCSCode:%String,TCLCSDesc:%String,TCLCSType:%String,TCLCSFactor:%Float,TCLCSBaseValue:%Float,TCLCSIsMainScore:%Boolean,TCLCSCanEdit:%Boolean,TCLCSUomdr:%String,TCLCSComOrdDr:%String,TCLCSComOrd:%String,TCLCSComOrdCode:%String") [ SqlProc ]
{
}

ClassMethod FindCLCScoreExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1

	s CLCSRowid=0
	f  s CLCSRowid=$o(^DHCCLC("Score",CLCSRowid)) q:CLCSRowid=""  d
	.s TCLCSCode=$lg(^DHCCLC("Score",CLCSRowid),1)
	.s TCLCSDesc=$lg(^DHCCLC("Score",CLCSRowid),2)
	.s TCLCSType=$lg(^DHCCLC("Score",CLCSRowid),3)
	.s:TCLCSType="S" TCLCSType="Select"
	.s:TCLCSType="C" TCLCSType="Calculate"
	.s TCLCSFactor=$lg(^DHCCLC("Score",CLCSRowid),4)
	.s TCLCSBaseValue=$lg(^DHCCLC("Score",CLCSRowid),5)
	.s TCLCSIsMainScore=$lg(^DHCCLC("Score",CLCSRowid),6)
 	.s:TCLCSIsMainScore="1" TCLCSIsMainScore="是"
 	.s:TCLCSIsMainScore="0" TCLCSIsMainScore="否"
	.s TCLCSCanEdit=$lg(^DHCCLC("Score",CLCSRowid),7)
	.s:TCLCSCanEdit="1" TCLCSCanEdit="是"
	.s:TCLCSCanEdit="0" TCLCSCanEdit="否"
	.s TCLCSUomdr=$lg(^DHCCLC("Score",CLCSRowid),8)
	.s TCLCSComOrdDr=$lg(^DHCCLC("Score",CLCSRowid),9)
	.s TCLCSComOrd="",TCLCSComOrdCode=""
	.i +TCLCSComOrdDr>1 d
		..s TCLCSComOrd=$p($g(^DHCICUC("RecordItem",+TCLCSComOrdDr)),"^",2)
		..s TCLCSComOrdCode=$p($g(^DHCICUC("RecordItem",+TCLCSComOrdDr)),"^",1)
	.e  d
		..s TCLCSComOrdId=..GetIcuriIdByCode(TCLCSComOrdDr)
		..s TCLCSComOrdDr=TCLCSComOrdId
		..q:TCLCSComOrdDr=""
		..s TCLCSComOrd=$p($g(^DHCICUC("RecordItem",+TCLCSComOrdDr)),"^",2)
		..s TCLCSComOrdCode=$p($g(^DHCICUC("RecordItem",+TCLCSComOrdDr)),"^",1)
	.s TRowid=CLCSRowid
	.d OutputRow1
	
	/*e  d
	.s TRowid=0
	.f  s TRowid=$o(^DHCCLC("Score",TRowid))  q:TRowid=""  d
	..s TCLCSCode=$lg(^DHCCLC("Score",TRowid),1)
	..s TCLCSDesc=$lg(^DHCCLC("Score",TRowid),2)
	..s TCLCSType=$lg(^DHCCLC("Score",TRowid),3)
	..s:TCLCSType="S" TCLCSType="Select"
	..s:TCLCSType="C" TCLCSType="Calculate"
	..s TCLCSFactor=$lg(^DHCCLC("Score",TRowid),4)
	..s TCLCSBaseValue=$lg(^DHCCLC("Score",TRowid),5)
	..s TCLCSIsMainScore=$lg(^DHCCLC("Score",TRowid),6)
 	..s:TCLCSIsMainScore="1" TCLCSIsMainScore="是"
 	..s:TCLCSIsMainScore="0" TCLCSIsMainScore="否"
	..s TCLCSCanEdit=$lg(^DHCCLC("Score",TRowid),7)
	..s:TCLCSCanEdit="1" TCLCSCanEdit="是"
	..s:TCLCSCanEdit="0" TCLCSCanEdit="否"
	..s TCLCSUomdr=$lg(^DHCCLC("Score",TRowid),8)
	..s TCLCSComOrdCode=$lg(^DHCCLC("Score",CLCSRowid),9)
	..d OutputRow1*/
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(TRowid,TCLCSCode,TCLCSDesc,TCLCSType,TCLCSFactor,TCLCSBaseValue,TCLCSIsMainScore,TCLCSCanEdit,TCLCSUomdr,TCLCSComOrdDr,TCLCSComOrd,TCLCSComOrdCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindCLCScoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCLCScoreExecute ]
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

ClassMethod FindCLCScoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCLCScoreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 根据常用医嘱的代码获取Id

ClassMethod GetIcuriIdByCode(icucriCode)
{
	q:icucriCode="" ""
	s icucriIdStr=""
		.s icucriIdStr=$o(^DHCICUC("RecordItem",0,"Code",icucriCode,""))
	q icucriIdStr
}

/// d ##class(%ResultSet).RunQuery("web.DHCCLCScore","FindScoreItems")
Query FindScoreItems() As %Query(ROWSPEC = "Id:%String,Code:%String,Desc:%String,ScoreType:%String,ScoreFactor:%Float,BaseValue:%Float,IsMainScore:%String,CanEdit:%String,UomId:%String,RecordItemId:%String,RecordItemDesc:%String,MainScoreItemId:%String") [ SqlProc ]
{
}

ClassMethod FindScoreItemsExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1

	s CLCSRowid=0
	f  s CLCSRowid=$o(^DHCCLC("Score",CLCSRowid)) q:CLCSRowid=""  d
	.s TCLCSCode=$lg(^DHCCLC("Score",CLCSRowid),1)
	.s TCLCSDesc=$lg(^DHCCLC("Score",CLCSRowid),2)
	.s TCLCSType=$lg(^DHCCLC("Score",CLCSRowid),3)
	.s:TCLCSType="S" TCLCSType="Select"
	.s:TCLCSType="C" TCLCSType="Calculate"
	.s TCLCSFactor=$lg(^DHCCLC("Score",CLCSRowid),4)
	.s TCLCSBaseValue=$lg(^DHCCLC("Score",CLCSRowid),5)
	.s TCLCSIsMainScore=$lg(^DHCCLC("Score",CLCSRowid),6)
 	.i TCLCSIsMainScore="1" s TCLCSIsMainScore="true"
 	.e  s TCLCSIsMainScore="false"
	.s TCLCSCanEdit=$lg(^DHCCLC("Score",CLCSRowid),7)
	.i TCLCSCanEdit="1" s TCLCSCanEdit="true"
	.e  s TCLCSCanEdit="false"
	.s TCLCSUomdr=$lg(^DHCCLC("Score",CLCSRowid),8)
	.s TCLCSComOrdCode=$lg(^DHCCLC("Score",CLCSRowid),9)
	.s TCLCSComOrd=$p($g(^DHCICUC("RecordItem",+TCLCSComOrdCode)),"^",2)
	.s TCLCSMainScoreId=""
	.s linkScoreId=0
	.f  s linkScoreId=$o(^DHCCLC("ScoreLink",linkScoreId)) q:(linkScoreId="")  d
	..s subScoreId=$lg(^DHCCLC("ScoreLink",linkScoreId),2)
	..s:(subScoreId=CLCSRowid) TCLCSMainScoreId=$lg(^DHCCLC("ScoreLink",linkScoreId),1)
	..q:(subScoreId=CLCSRowid)
	.s TRowid=CLCSRowid
	.d OutputRow1
	
	/*e  d
	.s TRowid=0
	.f  s TRowid=$o(^DHCCLC("Score",TRowid))  q:TRowid=""  d
	..s TCLCSCode=$lg(^DHCCLC("Score",TRowid),1)
	..s TCLCSDesc=$lg(^DHCCLC("Score",TRowid),2)
	..s TCLCSType=$lg(^DHCCLC("Score",TRowid),3)
	..s:TCLCSType="S" TCLCSType="Select"
	..s:TCLCSType="C" TCLCSType="Calculate"
	..s TCLCSFactor=$lg(^DHCCLC("Score",TRowid),4)
	..s TCLCSBaseValue=$lg(^DHCCLC("Score",TRowid),5)
	..s TCLCSIsMainScore=$lg(^DHCCLC("Score",TRowid),6)
 	..s:TCLCSIsMainScore="1" TCLCSIsMainScore="是"
 	..s:TCLCSIsMainScore="0" TCLCSIsMainScore="否"
	..s TCLCSCanEdit=$lg(^DHCCLC("Score",TRowid),7)
	..s:TCLCSCanEdit="1" TCLCSCanEdit="是"
	..s:TCLCSCanEdit="0" TCLCSCanEdit="否"
	..s TCLCSUomdr=$lg(^DHCCLC("Score",TRowid),8)
	..s TCLCSComOrdCode=$lg(^DHCCLC("Score",CLCSRowid),9)
	..d OutputRow1*/
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(TRowid,TCLCSCode,TCLCSDesc,TCLCSType,TCLCSFactor,TCLCSBaseValue,TCLCSIsMainScore,TCLCSCanEdit,TCLCSUomdr,TCLCSComOrdCode,TCLCSComOrd,TCLCSMainScoreId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindScoreItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindScoreItemsExecute ]
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

ClassMethod FindScoreItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindScoreItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(web.DHCCLCScore).InsertClCScore("test","测试","S",0.5,50,1,0,"test1")
ClassMethod InsertClCScore(CLCSCode As %String, CLCSDesc As %String, CLCSType As %String, CLCSFactor As %Float, CLCSBaseValue As %Float, CLCSIsMainScore As %Boolean, CLCSCanEdit As %Boolean, CLCSUomdr As %String, CLCSComOrdCode As %String = "", clcscoreJianYan As %String) As %String
{
	q:CLCSCode="" "代码不能为空"
	q:CLCSDesc="" "描述不能为空"
	q:CLCSType="" "类型不能为空"
	
	k PLIST
	TSTART
    s PLIST(2)=CLCSCode
	s PLIST(3)=CLCSDesc
	s PLIST(4)=CLCSType
	s PLIST(5)=CLCSFactor
	s PLIST(6)=CLCSBaseValue
	s PLIST(7)=CLCSIsMainScore
	s PLIST(8)=CLCSCanEdit
	s PLIST(9)=CLCSUomdr
	s PLIST(10)=CLCSComOrdCode
	s PLIST(11)=clcscoreJianYan
	&SQL(insert into DHC_CLC_Score values:PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
    TCOMMIT
	q SQLCODE
}

/// d ##class(web.DHCCLCScore).UpdateClCScore("2","code","测试描述","S",0.3,50,1,0,"test1")
ClassMethod UpdateClCScore(RowID As %String, CLCSCode As %String, CLCSDesc As %String, CLCSType As %String, CLCSFactor As %Float, CLCSBaseValue As %Float, CLCSIsMainScore As %Boolean, CLCSCanEdit As %Boolean, CLCSUomdr As %String, CLCSComOrdCode As %String, clcscoreJianYan As %String) As %String
{
	q:RowID="" "ID不能为空"
	q:CLCSCode="" "代码不能为空"
	q:CLCSDesc="" "名称不能为空"
	
	K PLIST
	TSTART	
    s PLIST(1)=RowID
	s PLIST(2)=CLCSCode
	s PLIST(3)=CLCSDesc
	s PLIST(4)=CLCSType
	s PLIST(5)=CLCSFactor
	s PLIST(6)=CLCSBaseValue
	s PLIST(7)=CLCSIsMainScore
	s PLIST(8)=CLCSCanEdit
	s PLIST(9)=CLCSUomdr
	s PLIST(10)=CLCSComOrdCode
	s PLIST(11)=clcscoreJianYan
	&SQL(update DHC_CLC_Score values:PLIST() where CLCS_RowId=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
    TCOMMIT
	q SQLCODE
}

/// d ##class(web.DHCCLCScore).DeleteClCScore("1")
ClassMethod DeleteClCScore(RowID As %String) As %String
{
	i RowID'=""  d
	.&SQL(delete from DHC_CLC_Score where %ID=:RowID)
	q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCCLCScore","FindClCSOption","2")
Query FindClCSOption(CLCScoreRowid As %String) As %Query(ROWSPEC = "TRowid:%String,TCLCSRowid:%String,TCLCSOCode:%String,TCLCSODesc:%String,TCLCSOMinValue:%Float,TCLCSOMaxValue:%Float,TCLCSOScoreValue:%Float,TCLCSOType:%String") [ SqlProc ]
{
}

ClassMethod FindClCSOptionExecute(ByRef qHandle As %Binary, CLCScoreRowid As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i CLCScoreRowid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	   s ChildSub=0
	   f  s ChildSub=$o(^DHCCLC("Score",CLCScoreRowid,"O",ChildSub))  q:ChildSub=""  d
		   .s TCLCSOCode=$lg(^DHCCLC("Score",CLCScoreRowid,"O",ChildSub),1)
		   .s TCLCSODesc=$lg(^DHCCLC("Score",CLCScoreRowid,"O",ChildSub),2)
		   .s TCLCSOMinValue=$lg(^DHCCLC("Score",CLCScoreRowid,"O",ChildSub),3)
		   .s TCLCSOMaxValue=$lg(^DHCCLC("Score",CLCScoreRowid,"O",ChildSub),4)
		   .s TCLCSOScoreValue=$lg(^DHCCLC("Score",CLCScoreRowid,"O",ChildSub),5)
		   .s TRowid=CLCScoreRowid_"||"_ChildSub
		   .s TCLCSOType=$lg(^DHCCLC("Score",CLCScoreRowid),3)
		   .s TCLCSRowid=CLCScoreRowid
		   .d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(TRowid,TCLCSRowid,TCLCSOCode,TCLCSODesc,TCLCSOMinValue,TCLCSOMaxValue,TCLCSOScoreValue,TCLCSOType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindClCSOptionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindClCSOptionExecute ]
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

ClassMethod FindClCSOptionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindClCSOptionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(web.DHCCLCScore).InsertClCSOption("2","ltest","测试子表",0.1,0.5,30)
ClassMethod InsertClCSOption(CLCSRowID As %String, CLCSOCode As %String, CLCSODesc As %String, CLCSOMinValue As %Float, CLCSOMaxValue As %Float, CLCSOScoreValue As %Float) As %String
{
	q:CLCSRowID="" "父表ID不能为空"
	q:CLCSOCode="" "代码不能为空"
	q:CLCSODesc="" "描述不能为空"
	s repeatStr=0
	s CLCScoreRowid=CLCSRowID
	s ChildSub=0
	   f  s ChildSub=$o(^DHCCLC("Score",CLCScoreRowid,"O",ChildSub))  q:ChildSub=""  d
		   .s TCLCSOCode=$lg(^DHCCLC("Score",CLCScoreRowid,"O",ChildSub),1)
		   .s TCLCSODesc=$lg(^DHCCLC("Score",CLCScoreRowid,"O",ChildSub),2)
		   .i TCLCSODesc=CLCSODesc s repeatStr=1
	q:repeatStr=1 "描述不能重复"
	k PLIST
	TSTART
	s PLIST(0)=CLCSRowID
    s PLIST(2)=CLCSOCode
	s PLIST(3)=CLCSODesc
	s PLIST(4)=CLCSOMinValue
	s PLIST(5)=CLCSOMaxValue
	s PLIST(6)=CLCSOScoreValue
	&SQL(insert into DHC_CLC_ScoreOption values:PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
    TCOMMIT
	q SQLCODE
}

/// d ##class(web.DHCCLCScore).UpdateClCSOption("2||1","2","bbbb","子表更新",0.2,0.6,40)
ClassMethod UpdateClCSOption(RowID As %String, CLCSRowID As %String, CLCSOCode As %String, CLCSODesc As %String, CLCSOMinValue As %Float, CLCSOMaxValue As %Float, CLCSOScoreValue As %Float) As %String
{
	q:RowID="" "ID不能为空"
	q:CLCSOCode="" "代码不能为空"
	q:CLCSODesc="" "名称不能为空"
	
	K PLIST
	TSTART	
	s PLIST(0)=CLCSRowID
    s PLIST(1)=RowID
    s PLIST(2)=CLCSOCode
	s PLIST(3)=CLCSODesc
	s PLIST(4)=CLCSOMinValue
	s PLIST(5)=CLCSOMaxValue
	s PLIST(6)=CLCSOScoreValue
	&SQL(update DHC_CLC_ScoreOption values:PLIST() where CLCSO_RowId=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
    TCOMMIT
	q SQLCODE
}

/// d ##class(web.DHCCLCScore).DeleteClCSOption("2||2")
ClassMethod DeleteClCSOption(RowID As %String) As %String
{
	i RowID'=""  d
	.&SQL(delete from DHC_CLC_ScoreOption where %ID=:RowID)
	q SQLCODE
}

/// d ##class(%ResultSet).RunQuery("web.DHCCLCScore","FindClCSLink","2")
Query FindClCSLink(MainCLC As %String) As %Query(ROWSPEC = "TRowid:%String,TCLCSLMainCLCSDr:%String,TCLCSLMainCLCS:%String,TCLCSLLinkCLCSDr:%String,TCLCSLLinkCLCS::%String") [ SqlProc ]
{
}

ClassMethod FindClCSLinkExecute(ByRef qHandle As %Binary, MainCLC As %String) As %Status
{
    Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	i ($g(MainCLC)'="")  d
 	.s TRowid=0
 	.f  s TRowid=$o(^DHCCLC("ScoreLink",0,"M",MainCLC,TRowid))  q:TRowid=""  d
 	..s TCLCSLLinkCLCSDr=$lg(^DHCCLC("ScoreLink",TRowid),2)
 	..s TCLCSLLinkCLCS=$lg(^DHCCLC("Score",TCLCSLLinkCLCSDr),2)
 	..s TCLCSLMainCLCSDr=MainCLC
 	..s TCLCSLMainCLCS=$lg($g(^DHCCLC("Score",TCLCSLMainCLCSDr)),2)
 	..d OutputRow
 	
 	e  d
 	.s TRowid=0
 	.f  s TRowid=$o(^DHCCLC("ScoreLink",TRowid)) q:TRowid=""  d
 	..s TCLCSLMainCLCSDr=$lg(^DHCCLC("ScoreLink",TRowid),1)
 	..s TCLCSLMainCLCS=$lg(^DHCCLC("Score",TCLCSLMainCLCSDr),2)
 	..s TCLCSLLinkCLCSDr=$lg(^DHCCLC("ScoreLink",TRowid),2)
 	..i TCLCSLLinkCLCSDr'="" s TCLCSLLinkCLCS=$lg($g(^DHCCLC("Score",TCLCSLLinkCLCSDr)),2)
 	..d OutputRow

	Quit $$$OK
OutputRow
	set Data=$lb(TRowid,TCLCSLMainCLCSDr,TCLCSLMainCLCS,TCLCSLLinkCLCSDr,TCLCSLLinkCLCS)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindClCSLinkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindClCSLinkExecute ]
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

ClassMethod FindClCSLinkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindClCSLinkExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(web.DHCCLCScore).InsertClCSLink("2","2")
ClassMethod InsertClCSLink(CLCSLMainCLCSDr As %String, CLCSLLinkCLCSDr As %String) As %String
{
	
	q:CLCSLMainCLCSDr="" "主评分指向不能为空"
	q:CLCSLLinkCLCSDr="" "关联评分指向不能为空"    
	
	k PLIST
	TSTART
    s PLIST(2)=CLCSLMainCLCSDr
	s PLIST(3)=CLCSLLinkCLCSDr
	&SQL(insert into DHC_CLC_ScoreLink values:PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
    TCOMMIT
	q SQLCODE
}

/// d ##class(web.DHCCLCScore).UpdateClCSLink("1","2","2")
ClassMethod UpdateClCSLink(RowID As %String, CLCSLMainCLCSDr As %String, CLCSLLinkCLCSDr As %String) As %String
{
	q:RowID="" "ID不能为空"
	
	K PLIST
	TSTART	
    s PLIST(1)=RowID
    s PLIST(2)=CLCSLMainCLCSDr
	s PLIST(3)=CLCSLLinkCLCSDr
	&SQL(update DHC_CLC_ScoreLink values:PLIST() where CLCSL_RowId=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
    TCOMMIT
	q SQLCODE
}

/// d ##class(web.DHCCLCScore).DeleteClCSLink("1")
ClassMethod DeleteClCSLink(RowID As %String) As %String
{
	i RowID'=""  d
	.&SQL(delete from DHC_CLC_ScoreLink where %ID=:RowID)
	q SQLCODE
}

Query FindBoolen() As %Query(ROWSPEC = "Desc:%String,Id:%String") [ SqlProc ]
{
}

ClassMethod FindBoolenExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Id="1",Desc="是"
	d OutputRow1
	s Id="0",Desc="否"
	d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(Desc,Id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBoolenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBoolenExecute ]
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

ClassMethod FindBoolenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBoolenExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindType() As %Query(ROWSPEC = "Desc:%String,Id:%String") [ SqlProc ]
{
}

ClassMethod FindTypeExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Id="S",Desc="Select"
	d OutputRow1
	s Id="C",Desc="Caculate"
	d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(Desc,Id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTypeExecute ]
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

ClassMethod FindTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCCLCScore","FindScoreOptions")

Query FindScoreOptions() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT %ID As Id,
	   CLCSO_Code As Code,
	   CLCSO_Desc As Description,
	   CLCSO_MinValue As MinValue,
	   CLCSO_MaxValue As MaxValue,
	   CLCSO_ScoreValue As ScoreValue,
	   CLCSO_Parref As ScoreItemId,
	   CLCSO_Type As CLCSOType
	   FROM DHC_CLC_ScoreOption
}

// d ##class(%ResultSet).RunQuery("web.DHCCLCScore","FindICUArrangeScoreTest","2014-02-01","2014-03-01","","56","","","")

Query FindICUArrangeScoreTest(fromDate As %String, toDate As %String, needRegNo As %String = "", ctlocId As %String = "", icuaStatusCode As %String = "", papmiMedicare As %String = "", papmiName As %String = "", needGroupId As %String = "", inward As %String = "", atward As %String = "") As %Query(ROWSPEC = "WardInDateTime:%String,WardOutDateTime:%String,RegNo:%String,PatName:%String,IcuWardDesc:%String,Status:%String,BedCode:%String,DiagDesc:%String,CurWardDesc:%String,icuaId:%String,EpisodeID:%String,MediCareNo:%String,WardInOutNote:%String,InApacheScore:%String,InSofaScore:%String,OutApacheScore:%String,OutSofaScore:%String,ResidentCtcp:%String,AttendingCtcp:%String,Temper:%String,HR:%String,RR:%String,PaO2:%String,AaDO2ifFiO250:%String,ApachePH:%String,SerumNa:%String,Serumk:%String,CreatinineARF2:%String,Hematocrit:%String,WBCcount:%String,age:%String,CHP:%String,GCS:%String,EyeOpening:%String,VerbalResponse:%String,MotorResponse:%String,FiO2:%String,NBP:%String,ARFValue:%String,bedusedays:%String") [ SqlProc ]
{
}

ClassMethod FindICUArrangeScoreTestExecute(ByRef qHandle As %Binary, fromDate As %String, toDate As %String, needRegNo As %String = "", ctlocId As %String = "", icuaStatusCode As %String = "", papmiMedicare As %String = "", papmiName As %String = "", needGroupId As %String = "", inward As %String = "True", atward As %String = "False") As %Status
{
	s TemperID="6370",HRID="6372",RRID="6386",PaO2ID="6373",AaDO2ifFiO250ID="6374",ApachePHID="6375",SerumNaID="6377",SerumkID="6378",CreatinineARF2ID="6379",HematocritID="6380",WBCcountID="6381",CHPID="6384",GCSID="6382",FiO2ID="5578",NBPID="6597"
	s TemperScoreID="6389",HRScoreID="6391",RRScoreID="6392",PaO2ScoreID="6393",AaDO2ifFiO250ScoreID="6394",ApachePHScoreID="6395",SerumNaScoreID="6397",SerumkScoreID="6398",CreatinineARF2ScoreID="6400",HematocritScoreID="6401",WBCcountScoreID="6402",CHPScoreID="6412",GCSScoreID="",FiO2ScoreID="6419",NBPScoreID="6390"
	s Temper="",HR="",RR="",PaO2="",AaDO2ifFiO250="",ApachePH="",SerumNa="",Serumk="",CreatinineARF2="",Hematocrit="",WBCcount="",age="",CHP="",GCS="",FiO2="",NBP=""
	s inTemperScore="",inHRScore="",inRRScore="",inPaO2Score="",inAaDO2ifFiO250Score="",inApachePHScore="",inSerumNaScore="",inSerumkScore="",inCreatinineARF2Score="",inHematocritScore="",inWBCcountScore="",ageScore="",inCHPScore="",inGCSScore="",inFiO2Score="",inNBPScore=""
	s outTemperScore="",outHRScore="",outRRScore="",outPaO2Score="",outAaDO2ifFiO250Score="",outApachePHScore="",outSerumNaScore="",outSerumkScore="",outCreatinineARF2Score="",outHematocritScore="",outWBCcountScore="",outCHPScore="",outGCSScore="",outFiO2Score="",outNBPScore=""
	s inTemperValue="",inHRValue="",inRRValue="",inPaO2Value="",inAaDO2ifFiO250Value="",inApachePHValue="",inSerumNaValue="",inSerumkValue="",inCreatinineARF2Value="",inHematocritValue="",inWBCcountValue="",ageValue="",inCHPValue="",inGCSValue="",inFiO2Value="",inNBPValue=""
	s outTemperValue="",outHRValue="",outRRValue="",outPaO2Value="",outAaDO2ifFiO250Value="",outApachePHValue="",outSerumNaValue="",outSerumkValue="",outCreatinineARF2Value="",outHematocritValue="",outWBCcountValue="",outCHPValue="",outGCSValue="",outFiO2Value="",outNBPValue=""
	s ageScore="",ageScoreID="6410",ageID="6383"
	s apcheID="6385",SofaID="5453"	
	s EyeOpeningValueID="6403",  VerbalResponseValueID="6405", MotorResponseValueID="6407", EyeOpeningScoreID="6404",  VerbalResponseScoreID="6406", MotorResponseScoreID="6408"
	s inEyeOpening="",  inVerbalResponse="", inMotorResponse="", outEyeOpening="",  outVerbalResponse="", outMotorResponse=""
	s EyeOpening="",  VerbalResponse="", MotorResponse=""
	s inEyeOpeningValue="",  inVerbalResponseValue="", inMotorResponseValue="", inEyeOpeningScore="",  inVerbalResponseScore="", inMotorResponseScore=""
	s outEyeOpeningValue="",  outVerbalResponseValue="", outMotorResponseValue="", outEyeOpeningScore="",  outVerbalResponseScore="", outMotorResponseScore=""
	s inApacheScore="",inSofaScore="",outApacheScore="",outSofaScore="",startTime="",startDate="",startDateTime=""
  	s ARFID="6399",inARFValue="",outARFValue="",ARFValue=""
  	Set repid=$I(^CacheTemp)
  	s needGroupId=315
  	s atward=atward
  	s ^TEMPLLL("atward")=atward
	If $g(ind)="" Set ind=1
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s EpisodeIDList=""
 	i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr")=EpisodeIDList
	s ifSingle="N"
	i needRegNo="",papmiMedicare="",papmiName="" s ifSingle="Y",tBodySquare=""

	;s ctlocId=39
	
	s wardId=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,0))
	s icuaBedList="",icuward="",linkLocIdStrTemp=""
	s linkLocIdStrTemp=##class(web.DHCClinicCom).GetLinkLocId(ctlocId)_"^"_ctlocId

    i linkLocIdStrTemp["39" s ctlocId=39 
	i linkLocIdStrTemp["88" s ctlocId=88 
	s linkLocIdStr=##class(web.DHCClinicCom).GetLinkLocId(ctlocId)_"^"_ctlocId

	s wardIdStr=""
	f i=1:1:$l(linkLocIdStr,"^") d
		.s curLocId=$p(linkLocIdStr,"^",i)
		.q:curLocId=""
		.s curWardId=$o(^PAWARD(0,"WARD_LocationDR",curLocId,0))
		.q:curWardId=""
		.i wardIdStr'="" s wardIdStr=wardIdStr_"^"
		.s wardIdStr=wardIdStr_curWardId
	//$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId
	k icuaIdList
	//时间段进病区
	i ifSingle="Y", needRegNo="" d
		.s icuaBedList=""
		.f date=fromDate:1:toDate d
			..s icuaId=""
			..f  s icuaId=$o(^DHCICUArrange(0,"SDate",date,icuaId)) q:icuaId=""  d
				...;q:'$d(^DHCICUArrange(icuaId))
				...//w icuaId,!
				...s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
				...q:("^"_wardIdStr_"^")'[("^"_(+icuBedId)_"^")
				...s curEpisodeID=+^DHCICUArrange(+icuaId)
				...;q:$p($g(^PAADM(curEpisodeID)),"^",73)=""
    			...i ("^"_EpisodeIDList_"^")'[curEpisodeID s EpisodeIDList=EpisodeIDList_"^"_curEpisodeID
    			...s icuaIdList(icuaId)=""
    //时间段在病区	
   	;k ^TEMPWWW("atward")	
    i (atward="True"), needRegNo="" d
		.s icuaBedList=""
		.s ^TEMPWWW("atward")=atward
		.f date=fromDate:1:toDate d
			..s icuaId=""
			..f  s icuaId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId)) q:icuaId=""  d
				...;q:'$d(^DHCICUArrange(icuaId))
				...//w icuaId,!
				...s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
				...;q:("^"_wardIdStr_"^")'[("^"_(+icuBedId)_"^")
				...s curEpisodeID=+^DHCICUArrange(+icuaId)
				...;q:$p($g(^PAADM(curEpisodeID)),"^",73)=""
    			...i ("^"_EpisodeIDList_"^")'[curEpisodeID s EpisodeIDList=EpisodeIDList_"^"_curEpisodeID
    			...s icuaIdList(icuaId)=""
	//w EpisodeIDList
	i needRegNo'="" s EpisodeIDList=##class(web.DHCClinicCom).GetPatientEpisodeID(needRegNo,"")
	s icuaId=""
	f  s icuaId=$o(icuaIdList(icuaId)) q:icuaId=""  d
		.//w icuaId,!
		.s curIcuaStatusCode=$p($g(^DHCICUArrange(+icuaId)),"^",18)
		.q:curIcuaStatusCode=""	;20120625
		.s leavePat=1
		.s EpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
		.q:EpisodeID=""
		.s patHeight=$p(^DHCICUArrange(icuaId),"^",24)
		.s patWeight=$p(^DHCICUArrange(icuaId),"^",25)
		.s tBodySquare=0 //..Sqr((patHeight*patWeight)/3600)
		.;q:(icuaStatusCode'="")&(curIcuaStatusCode'=icuaStatusCode)
		.s startDate=$p($g(^DHCICUArrange(+icuaId)),"^",6)
		.s startTime=+$p($g(^DHCICUArrange(+icuaId)),"^",8)
		.s startDateTime=startDate+(startTime/100000)
		.s curWardId=$o(^PAWARDA(0,"ADM",EpisodeID,""))
		.s inWardDateTimeStr=##class(web.DHCClinicCom).GetWardInDateTime(EpisodeID,startDate,startTime," ")
		.s inWardDate=startDate,inWardTime=startTime
		.i inWardDateTimeStr'=" " d
			..s inWardDate=##class(web.DHCClinicCom).ConvertToDateH($p(inWardDateTimeStr," "))
			..s inWardTime=##class(web.DHCClinicCom).ConvertToTimeH($p(inWardDateTimeStr," ",2))
		.s inWardDateTime=inWardDate+(inWardTime/100000)
		.s outDateTime=##class(web.DHCICUCom).GetWardOutDateTime("",icuaId,"","","^","D")
		.s curDateTime=$h+($p($h,",",2)/100000)
		.s curDate=($p($h,",",1))
		.s wardInOutNote=""
		.i outDateTime="" d
			..s duration=curDateTime-inWardDateTime
			..i duration>1 s wardInOutNote=$p(duration,".")_"天(在院)"
			..e  s wardInOutNote="<1天(在院)"
		.e  d
			..s outDate=$p(outDateTime,"^",1),outTime=$p(outDateTime,"^",2)
			..s outDateTime=outDate+(outTime/100000)
			..s leavePat=0
			..s duration=outDateTime-inWardDateTime
			..i duration>1 s wardInOutNote=$p(duration,".")_"天"
			..e  s wardInOutNote="<1天"
		.i outDateTime="" s outDate=+$h,outTime=$p($h,",",2)
		.e  d
			..s outDate=$p(outDateTime,".",1)
			..s outTime=(outDateTime-outDate)*100000
			..//s outDate=$zd(outDate,3)
					
			
		
		.s fromD=##class(web.DHCClinicCom).ConvertToDateH($p(fromDate," "))
		.s fromT=##class(web.DHCClinicCom).ConvertToTimeH($p(fromDate," ",2))
		.s fromDT=fromD+(fromT/100000)    
        .s toD=##class(web.DHCClinicCom).ConvertToDateH($p(toDate," "))
		.s toT=##class(web.DHCClinicCom).ConvertToTimeH($p(toDate," ",2))
	    .s toDT=toD+(toT/100000)  
	    .;b ;"toDT"     
	    .s icuidtest="2236"
		.i outDateTime="" d
            ..i fromDT<inWardDateTime&&curDateTime<toDT  d
              ...i icuaId=icuidtest  b ;"1"
			  ...s duration=curDate-inWardDate
			  ...i duration>=1 s bedusedays=$p(duration,".")
			  ...e  s bedusedays="0"
			..e  i fromDT<inWardDateTime&&curDateTime<toDT  d
			  ...i icuaId=icuidtest  b ;"2"
		      ...s duration=curDate-fromD
			  ...i duration>=1 s bedusedays=$p(duration,".")
			  ...e  s bedusedays="0"
			..e  i fromDT<inWardDateTime&curDateTime>toDT  d
			   ...i icuaId=icuidtest  b ;"3"
		       ...s duration=toD-fromD
			   ...i duration>1 s bedusedays=$p(duration,".")
			   ...e  s bedusedays="0"
		.e  d
            ..i fromDT<inWardDateTime&&outDateTime<toDT  d
              ...i icuaId=icuidtest  b ;"4"
			  ...s duration=outDate-inWardDate
			  ...i duration>=1 s bedusedays=$p(duration,".")
			  ...e  s bedusedays="0"
			..e  i fromDT<inWardDateTime&&outDateTime>toDT  d
			  ...i icuaId=icuidtest  b ;"5"
		      ...s duration=toD-inWardDate
			  ...i duration>=1 s bedusedays=$p(duration,".")
			  ...e  s bedusedays="0"
			..e  i fromDT>inWardDateTime&outDateTime>toDT  d
			   ...i icuaId=icuidtest  b ;"6"
		      ...s duration=toD-fromD
			  ...i duration>=1 s bedusedays=$p(duration,".")
			  ...e  s bedusedays="0"
		.i icuaId=icuidtest  b ;"7"		
			
		.s birth=$p($g(^PAPER(EpisodeID,"ALL")),"^",6)
		.s age=##class(web.DHCClinicCom).CalAge(birth,$h)
		.s inApacheScore=##class(web.DHCICUOrder).GetOrderValueByIdAndDate(apcheID,icuaId,inWardDate,inWardDate+1)
		.s outApacheScore=##class(web.DHCICUOrder).GetOrderValueByIdAndDate(apcheID,icuaId,outDate-1,outDate+1)
		.s inSofaScore=##class(web.DHCICUOrder).GetOrderValueByIdAndDate(SofaID,icuaId,inWardDate,inWardDate+1)
		.s outSofaScore=##class(web.DHCICUOrder).GetOrderValueByIdAndDate(SofaID,icuaId,outDate-1,outDate+1)
        
		.s AttendingCtcp=""
		.s inTemperValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,TemperID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inHRValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,HRID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inRRValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,RRID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inPaO2Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,PaO2ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inAaDO2ifFiO250Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,AaDO2ifFiO250ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inApachePHValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,ApachePHID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inSerumNaValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumNaID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inSerumkValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumkID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inCreatinineARF2Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,CreatinineARF2ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inHematocritValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,HematocritID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inWBCcountValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,WBCcountID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inCHPValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,CHPID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		.s inGCSValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,GCSID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inFiO2Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,FiO2ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inNBPValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,NBPID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inARFValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,ARFID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		.s inEyeOpeningValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,EyeOpeningValueID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		.s inVerbalResponseValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,VerbalResponseValueID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		.s inMotorResponseValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,MotorResponseValueID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")

        .s ageScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,ageScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.s inTemperScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,TemperScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inTemperScore'="" s inTemperScore=inTemperScore_"分"
		.s inHRScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,HRScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inHRScore'="" s inHRScore=inHRScore_"分"
		.s inRRScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,RRScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inRRScore'="" s inRRScore=inRRScore_"分"
		.s inPaO2Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,PaO2ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inPaO2Score'="" s inPaO2Score=inPaO2Score_"分"
		.s inAaDO2ifFiO250Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,AaDO2ifFiO250ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inAaDO2ifFiO250Score'="" s inAaDO2ifFiO250Score=inAaDO2ifFiO250Score_"分"
		.s inApachePHScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,ApachePHScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inApachePHScore'="" s inApachePHScore=inApachePHScore_"分"
		.s inSerumNaScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumNaScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inSerumNaScore'="" s inSerumNaScore=inSerumNaScore_"分"
		.s inSerumkScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumkScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inSerumkScore'="" s inSerumkScore=inSerumkScore_"分"
		.s inCreatinineARF2Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,CreatinineARF2ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inCreatinineARF2Score'="" s inCreatinineARF2Score=inCreatinineARF2Score_"分"
		.s inHematocritScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,HematocritScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inHematocritScore'="" s inHematocritScore=inHematocritScore_"分"
		.s inWBCcountScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,WBCcountScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inWBCcountScore'="" s inWBCcountScore=inWBCcountScore_"分"
		.s inCHPScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,CHPScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inCHPScore'="" s inCHPScore=inCHPScore_"分"
		.s inGCSScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,GCSScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inGCSScore'="" s inGCSScore=inGCSScore_"分"
		.s inFiO2Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,FiO2ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inFiO2Score'="" s inFiO2Score=inFiO2Score_"分"
		.s inNBPScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,NBPScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inNBPScore'="" s inNBPScore=inNBPScore_"分"
		
		.s inEyeOpeningScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,EyeOpeningScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inEyeOpeningScore'="" s inEyeOpeningScore=inEyeOpeningScore_"分"
		.s inVerbalResponseScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,VerbalResponseScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inVerbalResponseScore'="" s inVerbalResponseScore=inVerbalResponseScore_"分"
		.s inMotorResponseScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,MotorResponseScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Max")
		.i inMotorResponseScore'="" s inMotorResponseScore=inMotorResponseScore_"分"


		.s outTemperValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,TemperID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outHRValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,HRID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outRRValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,RRID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outPaO2Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,PaO2ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outAaDO2ifFiO250Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,AaDO2ifFiO250ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outApachePHValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,ApachePHID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outSerumNaValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumNaID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outSerumkValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumkID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outCreatinineARF2Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,CreatinineARF2ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outHematocritValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,HematocritID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outWBCcountValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,WBCcountID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outCHPValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,CHPID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		.s outGCSValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,GCSID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outFiO2Value=##class(web.DHCICUOrder).GetRecordValue(icuaId,FiO2ID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outNBPValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,NBPID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outARFValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,ARFID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.s outEyeOpeningValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,EyeOpeningValueID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		.s outVerbalResponseValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,VerbalResponseValueID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		.s outMotorResponseValue=##class(web.DHCICUOrder).GetRecordValue(icuaId,MotorResponseValueID,inWardDate,inWardTime,inWardDate+1,inWardTime,"First")
		
		
		.s outTemperScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,TemperScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outTemperScore'="" s outTemperScore=outTemperScore_"分"
		.s outHRScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,HRScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outHRScore'="" s outHRScore=outHRScore_"分"
		.s outRRScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,RRScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outRRScore'="" s outRRScore=outRRScore_"分"
		.s outPaO2Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,PaO2ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outPaO2Score'="" s outPaO2Score=outPaO2Score_"分"
		.s outAaDO2ifFiO250Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,AaDO2ifFiO250ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outAaDO2ifFiO250Score'="" s outAaDO2ifFiO250Score=outAaDO2ifFiO250Score_"分"
		.s outApachePHScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,ApachePHScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outApachePHScore'="" s outApachePHScore=outApachePHScore_"分"
		.s outSerumNaScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumNaScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outSerumNaScore'="" s outSerumNaScore=outSerumNaScore_"分"
		.s outSerumkScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,SerumkScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outSerumkScore'="" s outSerumkScore=outSerumkScore_"分"
		.s outCreatinineARF2Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,CreatinineARF2ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outCreatinineARF2Score'="" s outCreatinineARF2Score=outCreatinineARF2Score_"分"
		.s outHematocritScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,HematocritScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outHematocritScore'="" s outHematocritScore=outHematocritScore_"分"
		.s outWBCcountScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,WBCcountScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outWBCcountScore'="" s outWBCcountScore=outWBCcountScore_"分"
		.s outCHPScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,CHPScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outCHPScore'="" s outCHPScore=outCHPScore_"分"
		.s outGCSScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,GCSScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outGCSScore'="" s outGCSScore=outGCSScore_"分"
		.s outFiO2Score=##class(web.DHCICUOrder).GetRecordValue(icuaId,FiO2ScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outFiO2Score'="" s outFiO2Score=outFiO2Score_"分"
		.s outNBPScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,NBPScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outNBPScore'="" s outNBPScore=outNBPScore_"分"
	    
	    .s outEyeOpeningScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,EyeOpeningScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outEyeOpeningScore'="" s outEyeOpeningScore=outEyeOpeningScore_"分"
		.s outVerbalResponseScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,VerbalResponseScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outVerbalResponseScore'="" s outVerbalResponseScore=outVerbalResponseScore_"分"
		.s outMotorResponseScore=##class(web.DHCICUOrder).GetRecordValue(icuaId,MotorResponseScoreID,inWardDate,inWardTime,inWardDate+1,inWardTime,"Min")
		.i outMotorResponseScore'="" s outMotorResponseScore=outMotorResponseScore_"分"

        .i icuaId=2043 w inTemperValue ! outTemperValue b ;"5"
		.;i outDate-inWardDate<2 s inApacheScore="-",inSofaScore="-",inTemperValue="",inHRValue="",inRRValue="",inPaO2Value="",inAaDO2ifFiO250Value="",inApachePHValue="",inSerumNaValue="",inSerumkValue="",inCreatinineARF2Value="",inHematocritValue="",inWBCcountValue="",ageValue="",inCHPValue="",inGCSValue="",inFiO2Value="",inNBPValue=""
        .;i outDate-inWardDate<2 s inTemperScore="",inHRScore="",inRRScore="",inPaO2Score="",inAaDO2ifFiO250Score="",inApachePHScore="",inSerumNaScore="",inSerumkScore="",inCreatinineARF2Score="",inHematocritScore="",inWBCcountScore="",ageScore="",inCHPScore="",inGCSScore="",inFiO2Score="",inNBPScore=""
        .s ^TEMPWHL(EpisodeID)=EpisodeID_"^"_ctlocId
        .s ret=##class(web.DHCCLCScore).FindResidentAndAttendingCtcp(EpisodeID,ctlocId)
		.s ResidentCtcp=$p(ret,"^",1)
		.s AttendingCtcp=$p(ret,"^",2)
		.i ResidentCtcp="" s ResidentCtcp=##class(web.DHCClinicCom).GetNameById($p($g(^DHCICUArrange(+icuaId)),"^",28))
		.i AttendingCtcp="" s AttendingCtcp=##class(web.DHCClinicCom).GetNameById($p($g(^DHCICUArrange(+icuaId)),"^",29))
		.s FGF="_"
		.s Temper=inTemperValue_FGF_inTemperScore_"@"_outTemperValue_FGF_outTemperScore
		.s HR=inHRValue_FGF_inHRScore_"@"_outHRValue_FGF_outHRScore
		.s RR=inRRValue_FGF_inRRScore_"@"_outRRValue_FGF_outRRScore
		.s PaO2=inPaO2Value_FGF_inPaO2Score_"@"_outPaO2Value_FGF_outPaO2Score
		.s AaDO2ifFiO250=inAaDO2ifFiO250Value_FGF_inAaDO2ifFiO250Score_"@"_outAaDO2ifFiO250Value_FGF_outAaDO2ifFiO250Score
		.s ApachePH=inApachePHValue_FGF_inApachePHScore_"@"_outApachePHValue_FGF_outApachePHScore
		.s SerumNa=inSerumNaValue_FGF_inSerumNaScore_"@"_outSerumNaValue_FGF_outSerumNaScore
		.s Serumk=inSerumkValue_FGF_inSerumkScore_"@"_outSerumkValue_FGF_outSerumkScore
		.s CreatinineARF2=inCreatinineARF2Value_FGF_inCreatinineARF2Score_"@"_outCreatinineARF2Value_FGF_outCreatinineARF2Score
		.s Hematocrit=inHematocritValue_FGF_inHematocritScore_"@"_outHematocritValue_FGF_outHematocritScore
		.s WBCcount=inWBCcountValue_FGF_inWBCcountScore_"@"_outWBCcountValue_FGF_outWBCcountScore
		.s age=age_FGF_ageScore_"分"
		.s CHP=inCHPValue_FGF_inCHPScore_"@"_outCHPValue_FGF_outCHPScore
		.s GCS=inGCSValue_"分"_"@"_outGCSValue_"分"
		.s FiO2=inFiO2Value_FGF_inFiO2Score_"@"_outFiO2Value_FGF_outFiO2Score
		.s NBP=inNBPValue_FGF_inNBPScore_"@"_outNBPValue_FGF_outNBPScore

        .s EyeOpening=inEyeOpeningValue_FGF_inEyeOpeningScore_"@"_outEyeOpeningValue_FGF_outEyeOpeningScore
        .s VerbalResponse=inVerbalResponseValue_FGF_inVerbalResponseScore_"@"_outVerbalResponseValue_FGF_outVerbalResponseScore
        .s MotorResponse=inMotorResponseValue_FGF_inMotorResponseScore_"@"_outMotorResponseValue_FGF_outMotorResponseScore
		.s ARFValue=inARFValue
		.s icuaEndDate=$p($g(^DHCICUArrange(+icuaId)),"^",7)
		.i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr",+icuaId)=^tmpIcu("arr",+icuaId)_"/7:after end date?"
		.s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
		.s icuWardDesc=$P($g(^PAWARD(+icuBedId)),"^",2)
		.s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)
		.s curWardDesc=$P($g(^PAWARD(+curWardId)),"^",2)
		.s icuBedSub=$p(icuBedId,"||",2)
		.s bedCode=$p($g(^PAWARD(+icuBedId,"BED",+icuBedSub)),"^",1)
		.i bedCode="" s bedCode=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",1)
		.s papmiId=$p($g(^PAADM($p(^DHCICUArrange(icuaId),"^",1))),"^",1)
		.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		.;病案号
		.s medicareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
		.s wardInDateTime=""
		.i startDate'="" d
			..s wardInDateTime=$zd(startDate,3)
			..s startTime=+$p($g(^DHCICUArrange(+icuaId)),"^",8)
			..s wardInDateTime=wardInDateTime_" "_$zt(startTime,2)
		.s wardOutDateTime=""
		.i icuaEndDate'="" d
			..//s wardOutDateTime=$zd(icuaEndDate,3)
			..//s endTime=+$p($g(^DHCICUArrange(+icuaId)),"^",9)
			..//s wardOutDateTime=wardOutDateTime_" "_$zt(endTime)
		.;病人姓名
		.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
		.s status=$p($g(^DHCICUArrange(+icuaId)),"^",18)
		.;病人诊断
		.s diagDesc=""
		.s tDiagdr=$p($g(^DHCICUArrange(+icuaId)),"^",20)
		.s num=$l(tDiagdr,"|")
		.f k=1:1:num  d
			..s Diagdr=$p(tDiagdr,"|",k)
			..q:Diagdr=""
			..i diagDesc="" s diagDesc=$p(^MRC("ID",Diagdr),"^",2)
			..e  s diagDesc=diagDesc_";"_$p(^MRC("ID",Diagdr),"^",2)
		.i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr",+icuaId)=^tmpIcu("arr",+icuaId)_"/10:OK!"
		.s tICUANormalStartDate=##class(web.DHCClinicCom).ConvertToDate($p(^DHCICUArrange(icuaId),"^",22),"")
		.s tICUANormalStartTime=##class(web.DHCClinicCom).ConvertToTime($p(^DHCICUArrange(icuaId),"^",23),"")
		.i outDateTime'="" s wardOutDateTime=$zd(outDate,3)_" "_$zt(outTime,2)
		.i $p(icuWardDesc,"-",2)'="" s icuWardDesc=$p(icuWardDesc,"-",2)
		.i $p(curWardDesc,"-",2)'="" s curWardDesc=$p(curWardDesc,"-",2)
		.;ADD mfc 20140207导出病人评分汇总项
		.;s ^tempICUScore(+icuBedId,icuaId)=patName_"^"_regNo_"^"_icuWardDesc_"^"_bedCode_"^"_wardInOutNote_"^"_wardInDateTime_"^"_inApacheScore_"^"_wardOutDateTime_"^"_outApacheScore_"^"_curWardDesc_"^"_icuaId
		.s tmpList((+icuBedId)_leavePat_bedCode,EpisodeID_"."_+icuaId)=$lb(wardInDateTime,wardOutDateTime,regNo,patName,icuWardDesc,status,bedCode,diagDesc,curWardDesc,icuaId,EpisodeID,medicareNo,wardInOutNote,inApacheScore,inSofaScore,outApacheScore,outSofaScore,ResidentCtcp,AttendingCtcp,Temper,HR,RR,PaO2,AaDO2ifFiO250,ApachePH,SerumNa,Serumk,CreatinineARF2,Hematocrit,WBCcount,age,CHP,GCS,EyeOpening,VerbalResponse,MotorResponse,FiO2,NBP,ARFValue,bedusedays)
	    .;b ;"56"
	s bedCode=0,curWardId=""
	;f  s curWardId=$o(tmpList(curWardId)) q:curWardId=""  d
	f  s bedCode=$o(tmpList(bedCode)) q:bedCode=""  d 
		.s icuaId=0
		.f  s icuaId=$o(tmpList(bedCode,icuaId)) q:icuaId=""  d
			..d OutputRoww
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRoww
	set Data=tmpList(bedCode,icuaId) //$lb(wardInDateTime,wardOutDateTime,regNo,patName,admLocDesc,status,bedCode,diagDesc,wardDesc,icuaId,EpisodeID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUArrangeScoreTestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUArrangeScoreTestExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindICUArrangeScoreTestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUArrangeScoreTestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 获取主治医生管床医生

ClassMethod FindResidentAndAttendingCtcp(paadm As %String, locid As %String) As %String
{
    s ResidentCtcp="",AttendingCtcp="",rowid="",ResidentCtcpName="",AttendingCtcpName="",LocID=""
    s ResidentCtcpDr="",ResidentCtcpDr="",ctcpLocID=""
	f  s rowid=$o(^PAADM(paadm,"TRANS",rowid)) q:rowid=""  d
	.s LocID=$p(^PAADM(paadm,"TRANS",rowid),"^",6)
	.q:LocID'=locid
	.;b ;"2"
	.s TRANSMain=$p(^PAADM(paadm,"TRANS",rowid),"^",13)
	.;q:TRANSMain'="Yes"
	.s ResidentCtcpDr=$p(^PAADM(paadm,"TRANS",rowid),"^",5) //主治医生
	.q:ResidentCtcpDr=""
	.s ctcpLocID=$p($g(^SSU("SSUSR",ResidentCtcpDr)),"^",4)
	.;b ;"3"
	.;$P($g(^CTPCP(Doctor,1)),"^",2)
	.s AttendingCtcpName=##class(web.DHCDocInPatientList).GetHadeUniteDoc(ResidentCtcpDr,LocID)
	.s ResidentCtcpName=$P($g(^CTPCP(ResidentCtcpDr,1)),"^",2) ;$p($g(^SSU("SSUSR",+ResidentCtcpDr)),"^",2) ;$TR($P(^CTPCP(+ResidentCtcpDr,1),"^",2)," ","")
	.;s AttendingCtcpName=$P($g(^CTPCP(AttendingCtcpDr,1)),"^",2) ;$TR($P(^CTPCP(+AttendingCtcpDr,1),"^",2)," ","")
	;b ;"5"
	q ResidentCtcpName_"^"_AttendingCtcpName
}

// 获取医疗组组长

ClassMethod MedUnitPerson(locid As %String, CtPCP As %String) As %String
{
	s ind=1   
    s CTLocDr=locid
    s MUCPDoctorDR=""
    s CTMUChildsub=""
    s MUCPChildsub=""
    f  s CTMUChildsub=$o(^CTLOC(CTLocDr,"MU", CTMUChildsub))    q:CTMUChildsub=""   d
    .f  s MUCPChildsub=$o(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub))    q:MUCPChildsub=""   d
    ..s MUCPDateFrom="",MUCPDateTo=""
    ..s MUCPDoctorDR=$p(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub),"^",1)
    ..q:MUCPDoctorDR="" 
    ..q:MUCPDoctorDR'=CtPCP
    ..s TMPMUCPRowid=CTLocDr_"||"_ CTMUChildsub_"||"_MUCPChildsub
    ..s CTPCPCode=$p(^CTPCP(MUCPDoctorDR,1),"^",1)
	..s CTPCPDescNew=$p(^CTPCP(MUCPDoctorDR,1),"^",2)
	..s TMUCPLeader=$p(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub),"^",2)
    ..;s:TMUCPLeader="Y" MUCPLeaderFlag="是"
    ..;s:TMUCPLeader="N" MUCPLeaderFlag="否"
    ..q:TMUCPLeader'="Y"
    ..;s TMUCPOP=$p(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub),"^",3)
	..;s:TMUCPOP="Y" MUCPOPFlag="出诊"
    ..;s:TMUCPOP="N" MUCPOPFlag="不出诊"
    ..;s TMUCPIP=$p(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub),"^",4)
	..;s:TMUCPIP="N" MUCPIPFlag="不出诊"
	..;s:TMUCPIP="Y" MUCPIPFlag="出诊"
    q MUCPDoctorDR
    ;q $p($g(^SSU("SSUSR",++MUCPDoctorDR)),"^",2)
}

ClassMethod ClearDHCICUUnderlyingDisease(icuaId As %String) As %String
{
	TSTART
	&SQL(delete from DHC_ICU_UnderlyingDisease where ICUCUD_ICUA_Dr=:icuaId )
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
    TCOMMIT
	q SQLCODE
}

/// w ##class(web.DHCCLCScore).CompareClCSLink("","")
ClassMethod CompareClCSLink(mainclcs As %String, linkclcs As %String, rowId As %String = "")
{
	s ret=0
	q:((mainclcs="")||(linkclcs="")) 
	s TRowid=0
 	f  s TRowid=$o(^DHCCLC("ScoreLink",TRowid)) q:TRowid=""  d
 	.s TCLCSLMainCLCSDr=$lg(^DHCCLC("ScoreLink",TRowid),1)
 	.s TCLCSLLinkCLCSDr=$lg(^DHCCLC("ScoreLink",TRowid),2)
 	.if mainclcs=TCLCSLMainCLCSDr d
 	..if (linkclcs=TCLCSLLinkCLCSDr)&&(rowId'=TRowid)  s ret=1
 	.q:ret=1
 	q ret
}

Storage CacheStorage
{
}

}
