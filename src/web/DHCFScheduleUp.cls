Class web.DHCFScheduleUp Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod GetScheduleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetScheduleExecute ]
{
	Quit ##Class(web.DHCFBASICINFO).QueryClose(qHandle)
}

ClassMethod GetScheduleExecute(ByRef qHandle As %Binary, PreStartNum As %String, CtLoc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s del="^"
	s Para=PreStartNum_del_CtLoc
 s RetNum=##class(web.DHCFBSchedule).CareSchedule(repid,Para)
 s i=0
	f  s i=$o(^CacheTempFHQ(repid,i)) q:i=""  d
 .s Data=$g(^CacheTempFHQ(repid,i))
 .s j=$o(^CacheTempFHQ(repid,i))
 .s:j'="" Data1=$g(^CacheTempFHQ(repid,j))
 .if j'=""  d
 ..s Data1=$lb($p(Data1,del,2),$p(Data1,del,4),$p(Data1,del,5),$p(Data1,del,11),$p(Data1,del,13),$p(Data1,del,6))
 ..s Data=$lb($p(Data,del,2),$p(Data,del,4),$p(Data,del,5),$p(Data,del,11),$p(Data,del,13),$p(Data,del,6))
 ..s Data=Data_Data1
 ..s i=$o(^CacheTempFHQ(repid,i))
 .else  d
 ..s Data=$lb($p(Data,del,2),$p(Data,del,4),$p(Data,del,5),$p(Data,del,11),$p(Data,del,13),$p(Data,del,6))

 .s ^CacheTemp(repid,ind)=Data
 .S ind=ind+1
	Set qHandle=$lb(0,repid,0)
	k ^CacheTempFHQ(repid)
	Quit $$$OK
}

ClassMethod GetScheduleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetScheduleExecute ]
{
	S Row= ##Class(web.DHCFBASICINFO).QueryFetch(qHandle,AtEnd)
 Quit $$$OK
}

ClassMethod UpSchedule(repid As %String, Para As %String = "") As %String
{
	s del="^",RetNum=0
	s RbId=0,LocId=0
	Q:(Para="") 0
	s RetStr=""
	s PreStartNum=$p(Para,del,1),PreStartNumNew=$p(Para,del,2),CtLocId=$p(Para,del,3)
 f  s LocId=$o(^RB("RES",0,"CTLOC",LocId)) q:LocId=""  d
 .;s ^fhqgh(LocId)=$g(CtLocId)
	.q:(($g(CtLocId)'="")&($g(CtLocId)'=LocId))
	.s LocCode=$p(^CTLOC(LocId),del),LocDesc=$p(^CTLOC(LocId),del,2)
	.s RbId=0
 .f  s RbId=$o(^RB("RES",0,"CTLOC",LocId,RbId)) q:RbId=""  d
 ..S CareDr=$p(^RB("RES",RbId),del,2)
 ..q:CareDr=""
 ..q:'$d(^CTPCP(CareDr))
 ..s TmpStr=$g(^CTPCP(CareDr,1))
 ..s Code=$p(TmpStr,del,1),Desc=$p(TmpStr,del,2)
 ..;s RbcId=0,ArcImDesc=""
 ..;if $d(^RBC("SER",0,"CTCP",CareDr)) d
 ...;F  s RbcId=$o(^RBC("SER",0,"CTCP",CareDr,RbcId)) q:RbcId=""  d
 ....;s ArcimId=$p(^RBC("SER",RbcId),del,1)
 ....;s:ArcImDesc'="" ArcImDesc=ArcImDesc_"/"_$p(^ARCIM($p(ArcimId,"||"),$p(ArcimId,"||",2),1),del,2)
 ....;s:ArcImDesc="" ArcImDesc=$p(^ARCIM($p(ArcimId,"||"),$p(ArcimId,"||",2),1),del,2)
 ..s DateFrom=$o(^RB("RES",RbId,"DATE",0,"Date",""),-1)
 ..q:$g(DateFrom)=""
 ..s RbDId=0
 ..f  s RbDId=$o(^RB("RES",RbId,"DATE",0,"Date",DateFrom,RbDId)) q:RbDId=""  d
 ...s RbDSId=0
 ...f  s RbDSId=$o(^RB("RES",RbId,"DATE",RbDId,"SESS",RbDSId)) q:RbDSId=""  d
 ....s TmpStr=$g(^RB("RES",RbId,"DATE",RbDId,"SESS",RbDSId))
 ....s PreLimit=$p(TmpStr,del,1),PreStart=$p(TmpStr,del,21),AllNum=$p(TmpStr,del,8)
 ....s RemainNum=(AllNum-PreStartNum)
 ....s:(RemainNum<PreLimit) RetStr=##class(web.DHCFBCM).RetErrorValue(RetStr,"正号减预约起始号小于预约限额") q
 ....q:(PreStartNum'=PreStart)
 ....s rid=RbId_"||"_RbDId_"||"_RbDSId
 ....&sql(update SQLUSER.RB_ResEffDateSession set SESS_NumberOfWeeks=:PreStartNumNew where SESS_ROWID=:rid)
 ....i $g(SQLCODE) s RetStr=##class(web.DHCFBCM).RetErrorValue(RetStr,"RB_ResEffDateSession -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
 ....;s RetStr=##class(web.DHCFBCM).RetErrorValue(RetStr,rid)
	q:RetStr="" "Ok"
	q RetStr
}

Query GetSchedule(PreStartNum As %String, CtLoc As %String) As %Query(ROWSPEC = "TLocDesc:%String:科室,TDoctor:%String:医生,TWeek,TPreStartNum,TRoom,TStartTime,TLocDesc1,TDoctor1,TWeek1,TPreStartNum1,TRoom1,TStartTime1")
{
}

}
