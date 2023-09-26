Class web.DHCFBSchedule Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod CareSchedule(repid As %Integer, Para As %String) As %String
{
	s del="^",RetNum=0
	s RbId=0,LocId=0
	Q:(Para="") 0
	s PreStartNum=$p(Para,del,1),CtLocId=$p(Para,del,2)
	if $g(CtLocId)'="" d
	.s CtLocId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(CtLocId),""))
 f  s LocId=$o(^RB("RES",0,"CTLOC",LocId)) q:LocId=""  d
	.q:(($g(CtLocId)'="")&($g(CtLocId)'=LocId))
	.s LocCode=$p(^CTLOC(LocId),del),LocDesc=$p(^CTLOC(LocId),del,2)
	.s RbId=0
 .f  s RbId=$o(^RB("RES",0,"CTLOC",LocId,RbId)) q:RbId=""  d
 ..S CareDr=$p(^RB("RES",RbId),del,2)
 ..q:CareDr=""
 ..q:'$d(^CTPCP(CareDr))
 ..s TmpStr=$g(^CTPCP(CareDr,1))
 ..s Code=$p(TmpStr,del,1),Desc=$p(TmpStr,del,2)
 ..s RbcId=0,ArcImDesc=""
 ..if $d(^RBC("SER",0,"CTCP",CareDr)) d
 ...F  s RbcId=$o(^RBC("SER",0,"CTCP",CareDr,RbcId)) q:RbcId=""  d
 ....s ArcimId=$p(^RBC("SER",RbcId),del,1)
 ....s:ArcImDesc'="" ArcImDesc=ArcImDesc_"/"_$p(^ARCIM($p(ArcimId,"||"),$p(ArcimId,"||",2),1),del,2)
 ....s:ArcImDesc="" ArcImDesc=$p(^ARCIM($p(ArcimId,"||"),$p(ArcimId,"||",2),1),del,2)
 ..s DateFrom=$o(^RB("RES",RbId,"DATE",0,"Date",""),-1)
 ..q:$g(DateFrom)=""
 ..s RbDId=0
 ..f  s RbDId=$o(^RB("RES",RbId,"DATE",0,"Date",DateFrom,RbDId)) q:RbDId=""  d
 ...s RbDSId=0
 ...f  s RbDSId=$o(^RB("RES",RbId,"DATE",RbDId,"SESS",RbDSId)) q:RbDSId=""  d
 ....s TmpStr=$g(^RB("RES",RbId,"DATE",RbDId,"SESS",RbDSId))
 ....s PreLimit=$p(TmpStr,del,1),PreStart=$p(TmpStr,del,21)
 ....q:(PreStartNum'=PreStart)
 ....s Week=$p(TmpStr,del,2),StartTime=$p(TmpStr,del,4),EndTime=$p(TmpStr,del,5)
 ....s:Week'="" Week=$p(^CT("DOW",1,Week),del,1)
 ....s:StartTime'="" StartTime=##class(web.DHCRBResSession).GetTimeRangeByTime(StartTime)
 ....s:StartTime'="" StartTime=$P(^DHCTimeRange(StartTime),"^",2)
 ....s:EndTime'="" EndTime=$zt(EndTime)
 ....s PerTime=$p(TmpStr,del,7),AllNum=$p(TmpStr,del,8)
 ....s SessTypeDr=$p(TmpStr,del,9)
 ....s:SessTypeDr'="" SessType=$p(^RBC("SESS",SessTypeDr),del,2)
 ....s:SessTypeDr="" SessType=""
 ....s AddNum=$p(TmpStr,del,14)
 ....s RoomDr=$p(TmpStr,del,19)
 ....s:RoomDr'="" Room=$p(^CTLOC(RoomDr),del,2)
 ....s:RoomDr="" Room=""
 ....s:RoomDr'="" Ward=$p(Room,"区")_"区"
 ....s:RoomDr="" Ward=""
 ....s ClinicGroupDr=$p(TmpStr,del,35)
 ....s:ClinicGroupDr'="" ClinicGroup=$p(^RBC("CLGRP",ClinicGroupDr),del,2)
 ....s:ClinicGroupDr="" ClinicGroup=""
 ....S CircleFlag=1,UnitId=0,Unit="",UnitLimitNum=0,LimitUnit="",LimitUnitNum=""
 ....f  s UnitId=$o(^RB("RES",RbId,"Date",RbDId,"SESS",RbDSId,"AQ",UnitId)) q:((UnitId="")!(CircleFlag'=1))  d
 .....s LimitUnitDr=$p(^RB("RES",RbId,"Date",RbDId,"SESS",RbDSId,"AQ",UnitId),del,1)
 .....s UnitLimitNum=$p(^RB("RES",RbId,"Date",RbDId,"SESS",RbDSId,"AQ",UnitId),del,2)
 .....if $d(^RBC("APTM",UnitId)) d
 ......s Unit=$p(^RBC("APTM",UnitId),del,2)
 ......s:LimitUnit'="" LimitUnit=LimitUnit_"/"_Unit,LimitUnitNum=LimitUnitNum_"/"_UnitLimitNum
 ......s:LimitUnit="" LimitUnit=Unit,LimitUnitNum=UnitLimitNum
 ....s RetNum=RetNum+1
 ....s Rid=RbId_"||"_"RbDId"_"||"_RbDSId
 ....s ^CacheTempFHQ(repid,RetNum)=$g(LocCode)_del_$g(LocDesc)_del_$g(Code)_del_$g(Desc)_del_$g(Week)_del_$g(StartTime)_del_$g(EndTime)_del_$g(PerTime)_del_$g(AllNum)_del_$g(PreLimit)_del_$g(PreStart)_del_$g(AddNum)_del_$g(Room)_del_$g(Ward)_del_$g(SessType)_del_$g(ClinicGroup)_del_$g(LimitUnit)_del_$g(UnitLimitNum)_del_$g(ArcImDesc)
 q RetNum
}

}
