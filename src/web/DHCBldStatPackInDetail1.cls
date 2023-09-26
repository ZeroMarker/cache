Class web.DHCBldStatPackInDetail1 Extends %Persistent
{

ClassMethod QueryByMessageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCicoListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

///    d ##Class(%ResultSet).RunQuery("web.DHCBldStatPackInDetail1","QueryByMessage","2014-12-11 00:00:00","2014-12-12 23:59:59","00602")
ClassMethod QueryByMessageExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, BldState As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s DateS=$g(DateS),DateE=$g(DateE),BldState=$g(BldState)
	//s ^TMP("wxc")=DateS_","_DateE_","_BldState
	s DateE1="",DateS1=""
	i $l(DateS) s DateS1=$p(DateS," ",1),TimeS=$p(DateS," ",2)
	i $l(DateE) s DateE1=$p(DateE," ",1),TimeE=$p(DateE," ",2)
	s DateS1=$zdh(DateS1,3),DateE1=$zdh(DateE1,3)
	s TimeS=$zth(TimeS,3),TimeE=$zth(TimeE,3)
	f DateIn=DateS1:1:DateE1 d
	.s TimeRec="" f  s TimeRec=$o(^TBBPi("DateTimeRec",DateIn,TimeRec)) q:TimeRec=""  d
	..i (DateIn=DateS1)&(TimeRec<TimeS) q
	..i (DateIn=DateE1)&(TimeRec>TimeE) q
	..s PackID="" f  s PackID=$o(^TBBPi("DateTimeRec",DateIn,TimeRec,PackID)) q:PackID=""  d
	...s SecIdent="" f  s SecIdent=$o(^TBBPi("DateTimeRec",DateIn,TimeRec,PackID,SecIdent)) q:SecIdent=""  d
	....q:'$d(^TBBP(PackID,SecIdent))
	....s OneStr=$g(^TBBP(PackID,SecIdent))
	....s Supplier=$p(OneStr,"\",12)     //血站代码
	....s TimeIn=$zt($p(OneStr,"\",14))  //入库时间
	....s BldPro=$p(OneStr,"\",4)        //血制品
	....s BldGro=$p(OneStr,"\",5)        //血型组
    ....s PackVolume=$p(OneStr,"\",21)   //血量
    ....s Unit=$p(^TTAB("BB-BP",BldPro,"REM",1),"&",1)   //单位
	....s BldPro=$p(^TTAB("BB-BP",BldPro),"\",1)
	....s BldGro=$p(^TTAB("BB-BG",BldGro),"\",1)
    ....i $l(BldState),Supplier'=BldState q
	....s data=$lb(BldPro,BldGro,PackVolume)
	....s ^TMP($zn,$j,TimeIn,PackID,SecIdent)=data
	s TimeIn="" f  s TimeIn=$o(^TMP($zn,$j,TimeIn)) q:TimeIn=""  d
	.s PackID="" f  s PackID=$o(^TMP($zn,$j,TimeIn,PackID)) q:PackID=""  d
	..s SecIdent="" f  s SecIdent=$o(^TMP($zn,$j,TimeIn,PackID,SecIdent)) q:SecIdent=""  d
	...s data=$g(^TMP($zn,$j,TimeIn,PackID,SecIdent))
	...d OutputRow	
	Set qHandle=$lb(0,repid,0)
	k ^TMP($zn,$j)
	Quit $$$OK
OutputRow
    s ^CacheTemp(repid,ind)=data
    s ind=ind+1
    q
}

ClassMethod QueryByMessageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCicoListExecute ]
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

/// Creator：      WxC
/// CreatDate：    20141127
/// Description:： 6.血液入库汇总：根据入库时间段、血站名称来统计出
///                各个血站下的血液成分、A、B、O、AB 的入库血量。
/// Table：         
/// Input：        入库开始日期DateS,入库结束日期DateE,入库开始时间TimeS,入库结束时间TimeE,血站名称(BldState,Supplier)
/// Output：       各个血站下的血液成分、A、B、O、AB 的入库血量 BldPro:血制品,BldGro:血型组,PackVolume:血量
/// Return：       函数返回值的说明
/// Others：       PackID:血袋主编号 SecIdent:血袋次编号
Query QueryByMessage(DateS As %String, DateE As %String, BldState As %String) As %Query(ROWSPEC = "BldPro:%String,BldGro:%String,PackVolume:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCBldStatPackInDetail1DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBldStatPackInDetail1D</DataLocation>
<DefaultData>DHCBldStatPackInDetail1DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCBldStatPackInDetail1D</IdLocation>
<IndexLocation>^web.DHCBldStatPackInDetail1I</IndexLocation>
<StreamLocation>^web.DHCBldStatPackInDetail1S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
