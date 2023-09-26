Class web.DHCBldStatTotalPackInWXC Extends %Persistent
{

ClassMethod QueryCicoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCicoListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// D ##class(%ResultSet).RunQuery("web.DHCBldStatTotalPackInWXC","QueryCicoList","A")
ClassMethod QueryCicoListExecute(ByRef qHandle As %Binary, DateS As %String, DateE As %String, BldState As %Text) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//TimeS As %String,TimeE As %String
	s DateS=$g(DateS),DateE=$g(DateE),BldState=$g(BldState)
	//s TimeS=$g(TimeS),TimeE=$g(TimeE)
	s DateS=$zdh(DateS,3),DateE=$zdh(DateE,3)
	//s TimeS=$zth(TimeS,3),TimeE=$zth(TimeE,3)
	f DateIn=DateS:1:DateE d
	.s TimeRec="" f  s TimeRec=$o(^TBBPi("DateTimeRec",DateIn,TimeRec)) q:TimeRec=""  d
	..s PackID="" f  s PackID=$o(^TBBPi("DateTimeRec",DateIn,TimeRec,PackID)) q:PackID=""  d
	...s SecIdent="" f  s SecIdent=$o(^TBBPi("DateTimeRec",DateIn,TimeRec,PackID,SecIdent)) q:SecIdent=""  d
	....s OneStr=$g(^TBBP(PackID,SecIdent))
	....s Supplier=$p(OneStr,"\",12)     //血站代码
	....s TimeIn=$zt($p(OneStr,"\",14))  //入库时间
	....s BldPro=$p(OneStr,"\",4)        //血制品
	....s BldGro=$p(OneStr,"\",5)        //血型组
    ....s PackVolume=$p(OneStr,"\",21)   //血量
    ....s Unit=$p(^TTAB("BB-BP",BldPro,"REM",1),"&",1)   //单位
	....s BldPro=$p(^TTAB("BB-BP",BldPro),"\",1)
	....s BldGro=$p(^TTAB("BB-BG",BldGro),"\",1)
	....s Supplier=$p(^TTAB("BB-SUP",Supplier),"\",1)
	....s PackVolume=PackVolume_""_Unit
    ....i $l(BldState),Supplier'=BldState q
	....s data=$lb(BldPro,BldGro,PackVolume)
	....s ^TMP($zn,$j,TimeIn)=data
	s TimeIn="" f  s TimeIn=$o(^TMP($zn,$j,TimeIn)) q:TimeIn=""  d
	.s data=$g(^TMP($zn,$j,TimeIn))
	.d OutputRow	
	Set qHandle=$lb(0,repid,0)
	k ^TMP($zn,$j)
	Quit $$$OK
OutputRow
    s ^CacheTemp(repid,ind)=data
    s ind=ind+1
    q
}

ClassMethod QueryCicoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCicoListExecute ]
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
/// Input：        入库开始日期DateS,入库结束日期DateE,血站名称(BldState,Supplier)
/// Output：       各个血站下的血液成分、A、B、O、AB 的入库血量 BldPro:血制品,BldGro:血型组,PackVolume:血量
/// Return：       函数返回值的说明
/// Others：       PackID:血袋主编号 SecIdent:血袋次编号
///                d ##Class(%ResultSet).RunQuery("web.DHCBldStatTotalPackInWXC","QueryCicoList","2014-11-01","2014-11-11","青岛血液中心")
///                d ##Class(%ResultSet).RunQuery("QueryCicoList","QueryCicoList","2013-05-18","2014-11-11","北京市血站")
Query QueryCicoList(DateS As %String, DateE As %String, BldState As %Text) As %Query(ROWSPEC = "BldPro:%String,BldGro:%String,PackVolume:%String") [ SqlProc ]
{
}

Storage Default
{
<Data name="DHCBldStatTotalPackInWXCDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBldStatTotalPackInWXCD</DataLocation>
<DefaultData>DHCBldStatTotalPackInWXCDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCBldStatTotalPackInWXCD</IdLocation>
<IndexLocation>^web.DHCBldStatTotalPackInWXCI</IndexLocation>
<StreamLocation>^web.DHCBldStatTotalPackInWXCS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
