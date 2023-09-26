Class web.DHCFHQ.DHCFFHQ Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 排班表
ClassMethod Schedule(ChangeType As %String = "", RowStr As %String = "", Para As %String) As %String
{
   //1 	      2 	     3 	          4 	        5 	    6   	    7   	    8   	        9   	
    
   //新代码	科室名称	职工编号	姓名（号头）	星期	开始时间	结束时间	每人看诊时间	出诊限额	
   //10   	    11   	    12   	    13   	14   	15   	16   	17   	    18  
   //可预约数	预约起始号	加号限额	诊室	诊区	号别	亚专业	限额单位	限号数
   //  d ##class(web.DHCFHQ.DHCFFHQ).Schedule("Append","ZYMZ008^NFMMZ-内分泌门诊^YS02^医生02^2^7:00:00^12:00:00^^100^20^10^20^^^知名专家^^诊间预约^20","01/07/2017")
    s ^tmpdzy("Schedule")=ChangeType_","_RowStr_","_Para
	IF ChangeType="Clear" d
	.s rid=0
	.for  s rid=$o(^RB("RES",rid)) q:rid=""  d
	..k ^RB("RES",rid,"DATE")
	..k ^RB("RES",rid,"Date")
	..;&SQL(delete from SQLUSER.DHC_RBResEffDateSessAppQty)
	q:ChangeType="Clear" "数据已清:医生排班表"
	s del="^",RetStr=""
	s DateStr=$p(Para,del,1)
	if $g(DateStr)'="" S DateStr=$ZDH(DateStr,4)
	if $g(DateStr)="" s DateStr=$h-1
	SET RowStr=$tr(RowStr," ","")
	//科室代码 科室名称	医生代码  医生名称	星期	开始日间	结束时间	每人看诊时间	出诊限额	可预约数	
	//预约起始号	加号限额  诊室	出诊级别	亚专业	限额单位	限额
	s CtLoc=$p(RowStr,del,1),CareCode=$p(RowStr,del,3),CareName=$p(RowStr,del,4),Week=$p(RowStr,del,5),StartTime=$p(RowStr,del,6)
	s EndTime=$p(RowStr,del,7),PerTime=$p(RowStr,del,8),TotalNum=$p(RowStr,del,9),PreNum=$p(RowStr,del,10)
	s PreStar=$p(RowStr,del,11),AddNum=$p(RowStr,del,12),Room=$p(RowStr,del,13),Grade=$p(RowStr,del,15)
	s Specialty=$p(RowStr,del,16),LimitUnit=$p(RowStr,del,17),LimitNum=$p(RowStr,del,18)
	q:CtLoc="" "科室代码为空"_CareCode
	q:CareCode="" "医生代码为空"_CareCode
	q:Week="" "排班日期为空"_CareCode
	//q:Room="" "诊室为空"_CareCode
	s:StartTime="" StartTime="07:00:00"
	s StartTime=$zth(StartTime)
	s:EndTime="" EndTime="17:00:00"
	s EndTime=$zth(EndTime)
	s CtLoc=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtLoc),""))
	q:CtLoc="" ..RetErrorValue(RetStr,"取科室指针出错"_CareCode_" "_CareName)
	//s Room=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(Room),""))
	//q:Room="" ..RetErrorValue(RetStr,"取诊间指针出错"_CareCode_" "_CareName)
	s CareDr=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(CareCode),""))
	q:CareDr="" ..RetErrorValue(RetStr,"取人员指针出错"_CareCode_" "_CareName)
	S:$G(Grade)'="" GradeDr=$O(^RBC("SESS",0,"Desc",$$ALPHAUP^SSUTIL4(Grade),0))
	S:$G(GradeDr)="" RetStr=..RetErrorValue(RetStr,"出诊类别指针出错"_CareCode)
	S GradeDr=$G(GradeDr)
	IF $G(Specialty)'="" D
	.S Specialty=$o(^RBC("CLGRP",0,"Desc",$$ALPHAUP^SSUTIL4(Specialty),0)) 
	.S:Specialty="" RetStr=..RetErrorValue(RetStr,"取亚专业指针出错"_CareCode)
	s RbId=$o(^RB("RES",0,"CTPCP",CareDr,CtLoc,""))
	q:RbId="" ..RetErrorValue(RetStr,"资源计划中没有相应的记录"_CareCode)
	s RbDId="" 
	k PLIST
	s PLIST(0)=RbId,PLIST(3)=DateStr
	s RbDId=$o(^RB("RES",RbId,"DATE",0,"Date",DateStr,RbDId))
	
	if $g(RbDId)="" d 
	.&SQL(INSERT INTO SQLUSER.RB_ResEffDate VALUES :PLIST())
	i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RB_ResEffDate -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	;q DateStr_"^"_RowStr
	s:RbDId="" RbDId=$o(^RB("RES",RbId,"DATE",0,"Date",DateStr,0))
	s:EndTime<45000 SessionNo=1
	s:EndTime>45000 SessionNo=2
	k PLIST
	s PLIST(0)=RbId_"||"_$g(RbDId),PLIST(3)=SessionNo,PLIST(4)=StartTime,PLIST(5)=EndTime,PLIST(7)=PerTime,PLIST(8)=TotalNum
	s PLIST(9)=PreNum,PLIST(10)=Week,PLIST(11)=GradeDr,PLIST(16)=AddNum,PLIST(18)="Y",PLIST(21)=Room,PLIST(23)=PreStar,PLIST(37)=Specialty
	s CircleFlag=1,RbDSId=0,CircleFlagRoom=1
	for  s RbDSId=$o(^RB("RES",RbId,"DATE",RbDId,"SESS",RbDSId)) q:((RbDSId="")!(CircleFlag=0))  d
	.s Str=$g(^RB("RES",RbId,"DATE",RbDId,"SESS",RbDSId))
	.s SWeek=$p(Str,del,2),SStartTime=$p(Str,del,4)
	.if ((SWeek=Week)&(SStartTime=StartTime)) s RbDSId1=RbDSId,CircleFlag=0
	/*.s id1=0   //同一诊室同一时间不能坐两个人
	.s CircleFlagRoom=1
	.for  s id1=$o(^RB("RES",0,"SESSRoom",Room,id1)) q:((id1="")!(CircleFlagRoom'=1))  d
	..;s id2=$o(^RB("RES",0,"SESSRoom",Room,id1,""),-1) 
	..s id2=$o(^RB("RES",id1,"DATE",0,"Date",DateStr,""))
	..q:$g(id2)=""
	..s id3=""
	..f  s id3=$o(^RB("RES",0,"SESSRoom",Room,id1,id2,id3)) q:((id3="")!(CircleFlagRoom'=1))  d
	...s Str=$g(^RB("RES",id1,"DATE",id2,"SESS",id3))
	...s SWeek=$p(Str,del,2),SStartTime=$p(Str,del,4),RoomTmp=$p(Str,del,19)
	...if ((SWeek=Week)&(SStartTime=StartTime)&(RoomTmp=Room)) d
	....s CareId1=$p(^RB("RES",id1),del,2)
	....if ($g(CareId1)'="")  D
	.....IF ($D(^CTPCP(CareId1,1))) s CareCode1=$p(^CTPCP(CareId1,1),del,1),CareName1=$p(^CTPCP(CareId1,1),del,2)
	....s CircleFlagRoom=0
	q:(CircleFlagRoom'=1) ..RetErrorValue(RetStr,"同一诊室同一诊不能两个人 "_CareCode_" "_CareName_" "_CareCode1_" "_CareName1_" 星期"_Week)
	*/
	if $g(RbDSId1)'="" s RetStr=..RetErrorValue(RetStr,"记录已经存在 "_CareCode_" "_CareName_" 星期"_Week)
	if $g(RbDSId1)=""  d
	.&SQL(INSERT INTO SQLUSER.RB_ResEffDateSession VALUES :PLIST())
	.i $g(SQLCODE)'=0 s RetStr=..RetErrorValue(RetStr,"RB_ResEffDateSession -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	.if $g(%ROWID)'=""  d
	..s RbDSId1=%ROWID
	..S Services=$P(RowStr,del,19)
	..q:Services=""
	..s CircleNum=$l(Services,"/"),i=0
	..f  s i=i+1 q:(i>CircleNum)  d
	...s Service=$P(Services,"/",i)
	...q:$g(Service)=""
	...s ArcimId1=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(Service),""))
	...s:ArcimId1="" RetStr=..RetErrorValue(RetStr,"取医嘱指针出错:"_Code)
	...q:ArcimId1=""
	...s ArcimId2=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(Service),ArcimId1,""))
	...s ArcimId=ArcimId1_"||"_ArcimId2
	...S ArcimDesc=$p(^ARCIM(ArcimId1,ArcimId2,1),del,2)
	...s RbcServiceId=0,CircleFlag=1,RbcSerId=""
	...f  s RbcServiceId=$o(^RBC("SER",0,"CTCP",CareDr,RbcServiceId)) q:((RbcServiceId="")!(CircleFlag'=1))  d
	....s TmpStr=$g(^RBC("SER",RbcServiceId))
	....s:($p(TmpStr,del,1)=ArcimId) CircleFlag=0,RbcSerId=RbcServiceId
	...;if $g(RbcSerId)="" d  //如果没有相应的服务就增加一个
	....;s ServiceGroup=$p(^ARCIM(ArcimId1,ArcimId2,8),del,7)
	....;s:ServiceGroup="" RetStr=..RetErrorValue(RetStr,"取医嘱服务组指针出错:"_Code)
	....;q:ServiceGroup=""
	....;k PLIST
	....;S PLIST(2)=ArcimId1_"||"_ArcimId2,PLIST(4)=0,PLIST(5)=CareDr,PLIST(7)=$g(Service),PLIST(10)=ServiceGroup,PLIST(11)="Y",PLIST(13)=$H-1
	....;&SQL(INSERT INTO SQLUser.RBC_Services VALUES :PLIST())
	....;if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RBC_Services -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	....;s RbcSerId=$g(%ROWID)
	...;s:RbcSerId="" RetStr=..RetErrorValue(RetStr,"没有找到相应的服务"_CareCode_" 星期:"_Week_" "_Service)
	...;q:RbcSerId=""
	...;K PLIST
	...;;s PLIST(0)=RbId_"||"_$g(RbDId)_"||"_RbDSId1
	...;s PLIST(0)=RbDSId1
	...;s PLIST(3)=RbcSerId
	...;S PLIST(8)=ArcimDesc
	...;&SQL(INSERT INTO SQLUSER.RB_ResEffDateSessServices VALUES :PLIST())
	...;i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RB_ResEffDateSessServices -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	//不同单位的预约限额
	s i=1
	for  s Unit=$p(LimitUnit,"/",i) q:Unit=""  d
	.s UnitId=$o(^RBC("APTM",0,"Desc",$$ALPHAUP^SSUTIL4(Unit),0))
	.s Num=$p(LimitNum,"/",i)
	.s i=i+1
	.if UnitId="" s RetStr=..RetErrorValue(RetStr,"取单位指针出错RB_cappointmethod:"_CareCode)  q
	.if Num="" s RetStr=..RetErrorValue(RetStr,"取数量出错SS_USER:"_CareCode) q
	.s CircleFlag=1,RbDSId=0
	.f  s RbDSId=$o(^RB("RES",RbId,"DATE",RbDId,"SESS",RbDSId)) q:((RbDSId="")!(CircleFlag=0))  d
	..s Str=$g(^RB("RES",RbId,"DATE",RbDId,"SESS",RbDSId))
	..s RbDSId1=""
	..s SWeek=$p(Str,del,2),SStartTime=$p(Str,del,4),SEndTime=$p(Str,del,5)
	..if ((SWeek=Week)&(SStartTime=StartTime)) s RbDSId1=RbDSId,CircleFlag=0
	.q:$g(RbDSId1)=""
	.S PLIST(2)=RbId
	.s PLIST(3)=$g(RbDId)
	.s PLIST(4)=RbDSId1 
	.s PLIST(6)=UnitId 
	.s PLIST(7)=Num
	.&SQL(INSERT INTO SQLUSER.DHC_RBResEffDateSessAppQty VALUES :PLIST())
	.i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_RBResEffDateSessAppQty -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	q:RetStr="" "Ok"
	q RetStr
}

/// 排班表   临时用于导入没有诊室的排班数据  bygsb
ClassMethod Schedule333(ChangeType As %String = "", RowStr As %String = "", Para As %String) As %String
{
   //1 	      2 	     3 	          4 	        5 	    6   	    7   	    8   	        9   	
    
   //新代码	科室名称	职工编号	姓名（号头）	星期	开始时间	结束时间	每人看诊时间	出诊限额	
   //10   	    11   	    12   	    13   	14   	15   	16   	17   	    18  
   //可预约数	预约起始号	加号限额	诊室	诊区	号别	亚专业	限额单位	限号数
   
	IF ChangeType="Clear" d
	.s rid=0
	.for  s rid=$o(^RB("RES",rid)) q:rid=""  d
	..k ^RB("RES",rid,"DATE")
	..k ^RB("RES",rid,"Date")
	..;&SQL(delete from SQLUSER.DHC_RBResEffDateSessAppQty)
	q:ChangeType="Clear" "数据已清:医生排班表"
	s del="^",RetStr=""
	s DateStr=$p(Para,del,1)
	if $g(DateStr)'="" S DateStr=$ZDH(DateStr,4)
	if $g(DateStr)="" s DateStr=$h-1
	SET RowStr=$tr(RowStr," ","")
	//科室代码 科室名称	医生代码  医生名称	星期	开始日间	结束时间	每人看诊时间	出诊限额	可预约数	
	//预约起始号	加号限额  诊室	出诊级别	亚专业	限额单位	限额
	s CtLoc=$p(RowStr,del,1),CareCode=$p(RowStr,del,3),CareName=$p(RowStr,del,4),Week=$p(RowStr,del,5),StartTime=$p(RowStr,del,6)
	s EndTime=$p(RowStr,del,7),PerTime=$p(RowStr,del,8),TotalNum=$p(RowStr,del,9),PreNum=$p(RowStr,del,10)
	s PreStar=$p(RowStr,del,11),AddNum=$p(RowStr,del,12),Room=$p(RowStr,del,13),Grade=$p(RowStr,del,15)
	s Specialty=$p(RowStr,del,16),LimitUnit=$p(RowStr,del,17),LimitNum=$p(RowStr,del,18),TimeFrame=$p(RowStr,del,20)
	q:CtLoc="" "科室代码为空"_CareCode
	q:CareCode="" "医生代码为空"_CareCode
	q:Week="" "排班日期为空"_CareCode
	;q:Room="" "诊室为空"_CareCode
	s:StartTime="" StartTime="07:00:00"
	s StartTime=$zth(StartTime)
	s:EndTime="" EndTime="17:00:00"
	s EndTime=$zth(EndTime)
	s CtLoc=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtLoc),""))
	q:CtLoc="" ..RetErrorValue(RetStr,"取科室指针出错"_CareCode_" "_CareName)
	;s Room=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(Room),""))
	;q:Room="" ..RetErrorValue(RetStr,"取诊间指针出错"_CareCode_" "_CareName)
	s CareDr=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(CareCode),""))
	q:CareDr="" ..RetErrorValue(RetStr,"取人员指针出错"_CareCode_" "_CareName)
	S:$G(Grade)'="" GradeDr=$O(^RBC("SESS",0,"Desc",$$ALPHAUP^SSUTIL4(Grade),0))
	S:$G(GradeDr)="" RetStr=..RetErrorValue(RetStr,"出诊类别指针出错"_CareCode)
	S GradeDr=$G(GradeDr)
	IF $G(Specialty)'="" D
	.S Specialty=$o(^RBC("CLGRP",0,"Desc",$$ALPHAUP^SSUTIL4(Specialty),0)) 
	.S:Specialty="" RetStr=..RetErrorValue(RetStr,"取亚专业指针出错"_CareCode)
	s RbId=$o(^RB("RES",0,"CTPCP",CareDr,CtLoc,""))
	q:RbId="" ..RetErrorValue(RetStr,"资源计划中没有相应的记录"_CareCode)
	s RbDId="" 
	k PLIST
	s PLIST(0)=RbId,PLIST(3)=DateStr
	s RbDId=$o(^RB("RES",RbId,"DATE",0,"Date",DateStr,RbDId))
	
	if $g(RbDId)="" d 
	.&SQL(INSERT INTO SQLUSER.RB_ResEffDate VALUES :PLIST())
	i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RB_ResEffDate -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	;q DateStr_"^"_RowStr
	s:RbDId="" RbDId=$o(^RB("RES",RbId,"DATE",0,"Date",DateStr,0))
	k PLIST
	s PLIST(0)=RbId_"||"_$g(RbDId),PLIST(4)=StartTime,PLIST(5)=EndTime,PLIST(7)=PerTime,PLIST(8)=TotalNum
	s PLIST(9)=PreNum,PLIST(10)=Week,PLIST(11)=GradeDr,PLIST(16)=AddNum,PLIST(23)=PreStar,PLIST(37)=Specialty
	s CircleFlag=1,RbDSId=0,CircleFlagRoom=1
	;for  s RbDSId=$o(^RB("RES",RbId,"DATE",RbDId,"SESS",RbDSId)) q:((RbDSId="")!(CircleFlag=0))  d
	.;s Str=$g(^RB("RES",RbId,"DATE",RbDId,"SESS",RbDSId))
	.;s SWeek=$p(Str,del,2),SStartTime=$p(Str,del,4)
	.;if ((SWeek=Week)&(SStartTime=StartTime)) s RbDSId1=RbDSId,CircleFlag=0
	.;s id1=0   //同一诊室同一时间不能坐两个人
	.;s CircleFlagRoom=1
	.;for  s id1=$o(^RB("RES",0,"SESSRoom",Room,id1)) q:((id1="")!(CircleFlagRoom'=1))  d
	..;s id2=$o(^RB("RES",0,"SESSRoom",Room,id1,""),-1) 
	..;s id2=$o(^RB("RES",id1,"DATE",0,"Date",DateStr,""))
	..;q:$g(id2)=""
	..;s id3=""
	..;f  s id3=$o(^RB("RES",0,"SESSRoom",Room,id1,id2,id3)) q:((id3="")!(CircleFlagRoom'=1))  d
	...;s Str=$g(^RB("RES",id1,"DATE",id2,"SESS",id3))
	...;s SWeek=$p(Str,del,2),SStartTime=$p(Str,del,4),RoomTmp=$p(Str,del,19)
	...;if ((SWeek=Week)&(SStartTime=StartTime)&(RoomTmp=Room)) d
	....;s CareId1=$p(^RB("RES",id1),del,2)
	....;if ($g(CareId1)'="")  D
	.....;IF ($D(^CTPCP(CareId1,1))) s CareCode1=$p(^CTPCP(CareId1,1),del,1),CareName1=$p(^CTPCP(CareId1,1),del,2)
	....;s CircleFlagRoom=0
	;q:(CircleFlagRoom'=1) ..RetErrorValue(RetStr,"同一诊室同一诊不能两个人 "_CareCode_" "_CareName_" "_CareCode1_" "_CareName1_" 星期"_Week)
	;if $g(RbDSId1)'="" s RetStr=..RetErrorValue(RetStr,"记录已经存在 "_CareCode_" "_CareName_" 星期"_Week)
	s RbDSId1=""
	if $g(RbDSId1)=""  d
	.&SQL(INSERT INTO SQLUSER.RB_ResEffDateSession VALUES :PLIST())
	.i $g(SQLCODE)'=0 s RetStr=..RetErrorValue(RetStr,"RB_ResEffDateSession -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	.if $g(%ROWID)'=""  d
	..s RbDSId1=%ROWID
	..S Services=$P(RowStr,del,19)
	..q:Services=""
	..s CircleNum=$l(Services,"/"),i=0
	..f  s i=i+1 q:(i>CircleNum)  d
	...s Service=$P(Services,"/",i)
	...q:$g(Service)=""
	...s ArcimId1=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(Service),""))
	...s:ArcimId1="" RetStr=..RetErrorValue(RetStr,"取医嘱指针出错:"_Code)
	...q:ArcimId1=""
	...s ArcimId2=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(Service),ArcimId1,""))
	...s ArcimId=ArcimId1_"||"_ArcimId2
	...S ArcimDesc=$p(^ARCIM(ArcimId1,ArcimId2,1),del,2)
	...s RbcServiceId=0,CircleFlag=1,RbcSerId=""
	...f  s RbcServiceId=$o(^RBC("SER",0,"CTCP",CareDr,RbcServiceId)) q:((RbcServiceId="")!(CircleFlag'=1))  d
	....s TmpStr=$g(^RBC("SER",RbcServiceId))
	....s:($p(TmpStr,del,1)=ArcimId) CircleFlag=0,RbcSerId=RbcServiceId

	//不同单位的预约限额
	s i=1
	for  s Unit=$p(LimitUnit,"/",i) q:Unit=""  d
	.s UnitId=$o(^RBC("APTM",0,"Desc",$$ALPHAUP^SSUTIL4(Unit),0))
	.s Num=$p(LimitNum,"/",i)
	.s i=i+1
	.if UnitId="" s RetStr=..RetErrorValue(RetStr,"取单位指针出错RB_cappointmethod:"_CareCode)  q
	.if Num="" s RetStr=..RetErrorValue(RetStr,"取数量出错SS_USER:"_CareCode) q
	.s CircleFlag=1,RbDSId=0
	.f  s RbDSId=$o(^RB("RES",RbId,"DATE",RbDId,"SESS",RbDSId)) q:((RbDSId="")!(CircleFlag=0))  d
	..s Str=$g(^RB("RES",RbId,"DATE",RbDId,"SESS",RbDSId))
	..s RbDSId1=""
	..s SWeek=$p(Str,del,2),SStartTime=$p(Str,del,4),SEndTime=$p(Str,del,5)
	..if ((SWeek=Week)&(SStartTime=StartTime)) s RbDSId1=RbDSId,CircleFlag=0
	.q:$g(RbDSId1)=""
	.S PLIST(2)=RbId
	.s PLIST(3)=$g(RbDId)
	.s PLIST(4)=RbDSId1 
	.s PLIST(6)=UnitId 
	.s PLIST(7)=Num
	.&SQL(INSERT INTO SQLUSER.DHC_RBResEffDateSessAppQty VALUES :PLIST())
	.i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_RBResEffDateSessAppQty -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod AddData(FileName As %String = "", ClassName As %String, ChangeType As %String) As %String
{
 k ^PAPER,^PAPERi,^DHCCARD("CF"),^DHCCARDi("CF"),^mdata("DHCCARDREF")
 s CircleNum=0
 s SUB="Data"
 k ^ErrText,^FHQ
 f  s CircleNum=CircleNum+1 q:(CircleNum>16)  d
 .if CircleNum=1 s FileName="d:\tmp\200610.txt"
 .if CircleNum=2 s FileName="d:\tmp\2006111.txt"
 .if CircleNum=3 s FileName="d:\tmp\2006112.txt"
 .if CircleNum=4 s FileName="d:\tmp\2006121.txt"
 .if CircleNum=5 s FileName="d:\tmp\2006122.txt"
 .if CircleNum=6 s FileName="d:\tmp\200701.txt"
 .if CircleNum=7 s FileName="d:\tmp\200702.txt"
 .if CircleNum=8 s FileName="d:\tmp\200703.txt"
 .if CircleNum=9 s FileName="d:\tmp\200704.txt"
 .if CircleNum=10 s FileName="d:\tmp\200705.txt"
 .if CircleNum=11 s FileName="d:\tmp\200706.txt"
 .if CircleNum=12 s FileName="d:\tmp\200707.txt"
 .if CircleNum=13 s FileName="d:\tmp\200708.txt"
 .if CircleNum=14 s FileName="d:\tmp\200709.txt"
 .if CircleNum=15 s FileName="d:\tmp\2007010.txt"
 .if CircleNum=16 s FileName="d:\tmp\file01.txt"
 .s IND=1
 .w CircleNum," "
	.D FILE^DHCFHQ(FileName,SUB)
	.FOR  S IND=$O(^zTSA("FHQ",SUB,IND)) Q:IND=""  SET TMPSTR=^(IND) DO
	..SET TMPSTR=$TR(TMPSTR," ","")
	..S ErrText=..PatInfo(ChangeType,TMPSTR)
	..if IND#100=0 w "."
	..Q:((ErrText="")!(ErrText="Ok")) 
	..S ^ErrText(CircleNum,IND)=ErrText
	Q ""
}

/// 医嘱项别名
ClassMethod ArcimAlias(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" k ^ARC("ALIAS"),^ARC("KEYW")
	q:ChangeType="Clear" "数据已清:医嘱项"
	s del="^"
	s RetStr=""
	SET RowStr=$tr(RowStr," ","")
 s ArcCode=$p(RowStr,del,1),Alias=$p(RowStr,del,3)
 q:ArcCode="" ..RetErrorValue(RetStr,"取医嘱针出错:")
 Q:Alias="" ..RetErrorValue(RetStr,"取医嘱针出错:"_ArcCode)
 s ArcimId1=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcCode),""))
 q:ArcimId1="" ..RetErrorValue(RetStr,"取医嘱针出错:"_ArcCode)
 s ArcimId2=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcCode),ArcimId1,""))
 q:ArcimId2="" ..RetErrorValue(RetStr,"取医嘱针出错:"_ArcCode)
 s OnItsOwn=$p(^ARCIM(ArcimId1,ArcimId2,7),del,13)
 s ArcSubCatDr=$p(^ARCIM(ArcimId1,ArcimId2,1),del,10)
 s ArcCatDr=$p(^ARC("IC",ArcSubCatDr),del,8)
 s ArcDesc=$p(^ARCIM(ArcimId1,ArcimId2,1),del,2)

 //医嘱别名
 s ArcimId=ArcimId1_"||"_ArcimId2
 i Alias'="" d
 .set I=0
 .s num=$l(Alias,"/")
 .s ALI=""
 .FOR I=0:1:num d
 ..s ALI=$p(Alias,"/",I)
 ..q:$d(^ARC("ALIAS",0,"DescI",$$ALPHAUP^SSUTIL4(ALI)_" ",$$ALPHAUP^SSUTIL4(ArcDesc)))
 ..if ChangeType'="Test" d
 ...q:$g(ALI)=""
 ...S ALI=$$ALPHAUP^SSUTIL4(ALI)
 ...k PLIST 
 ...s PLIST(2)=ArcimId,PLIST(5)=ArcDesc,PLIST(6)=ArcSubCatDr,PLIST(9)=OnItsOwn,PLIST(14)=+$h
 ...set PLIST(4)=$p(Alias,"/",I)
 ...&SQL(INSERT INTO SQLUser.ARC_Alias VALUES PLIST()) 
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_Alias -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ...q:$g(SQLCODE)
 ...s ArcKeyId=0,CircleFlag=1
 ...f  s ArcKeyId=$o(^ARC("KEYW",0,"ARCIM",ArcimId,ArcKeyId)) q:((ArcKeyId="")!(CircleFlag=0))  d
 ....s ArcKey=$p(^ARC("KEYW",ArcKeyId),del,3)
 ....if ALI=ArcKey s CircleFlag=0
 ...q:(CircleFlag=0)
 ...k PLIST 
 ...s PLIST(2)=ArcimId,PLIST(5)=ALI_"-"_ArcDesc,PLIST(6)=ArcSubCatDr,PLIST(7)=ArcCatDr
 ...set PLIST(4)=ALI_"Z"
 ...&SQL(INSERT INTO SQLUser.ARC_ItemKeywords VALUES PLIST()) 
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItemKeywords -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 q RetStr
}

// 协和柳旭生修改

/// 医嘱数据
ClassMethod ArcimData(ChangeType As %String = "", RowStr As %String = "") As %String
{
	//	1	  2	       3	4	  5      	6	     7	     8	    9	          10	    
	//	
	//编码	收费项	别名   编码	医嘱描述	别名	单价	单位	医嘱大类	医嘱子类
	//11		12			13			14			15			16			17			18	
	//帐单大类	帐单子类	收费大类	收费子类	住院发票	住院核算	门诊发票	门诊核算
	//19		   20			   21		   	22	    	23			24			   25	  	26			  27		 28		29	
	//核算类	核算子类	会计类	会计子类	病案大类	病案子类	开展	独立医嘱	优先级	结果	数量
	//30            31       32
	//医嘱提示信息 设备名称  急诊标示
	
	if ChangeType="Clear"  d
	.K ^ARCIM,^ARC("ALIAS"),^ARC("KEYW")
	.k ^DHCTARI,^DHCTARIi,^mdata("DHCTARITEM"),^DHCTARAL,^mdata("DHCTARITEMALIAS")
	.k ^DHCOLT,^mdata("DHCORDERLINKTAR"),^DHCTARF,^mdata("DHCTARFACTOR")
	q:ChangeType="Clear" "数据已清:医嘱项"
	s del="^"
	s RetStr=""
	SET RowStr=$tr(RowStr," ","")
	SET TarCode=$P(RowStr,del,1),TarCode=$$ALPHAUP^SSUTIL4(TarCode),TarDesc=$tr($P(RowStr,del,2)," ",""),OrdCode=$P(RowStr,del,4),OrdDesc=$P(RowStr,del,5)
	s ^LTemp(TarCode,OrdCode)=RowStr
	set TarSource=$P(RowStr,del,34)
	set stopflag=$P(RowStr,del,25)
	if ((OrdCode="") & (OrdDesc="")) d
	else  d
	.if OrdCode="" s RetStr=..RetErrorValue(RetStr,"医嘱代码为空:")
    .if OrdDesc="" s RetStr=..RetErrorValue(RetStr,"医嘱名称为空:")
    if ((TarCode="") & (TarDesc="")) d
	else  d
	.if TarCode="" s RetStr=..RetErrorValue(RetStr,"收费项代码为空:")
    .if TarDesc="" s RetStr=..RetErrorValue(RetStr,"收费项名称为空:")
    if (($g(OrdDesc)'="")&($g(OrdCode)'="")) d
    .if ($d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc)))&('$d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))))) s OrdDesc=OrdDesc_OrdCode
    .s:($d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc)))&('$d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))))) RetStr=..RetErrorValue(RetStr,"医嘱项名称已经存在:"_OrdDesc)
    .s:($d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode)))&('$d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc))))) RetStr=..RetErrorValue(RetStr,"医嘱项代码已经存在:"_OrdCode)
    if (($g(TarCode)'="")&($g(TarDesc)'="")) d
    .s:($D(^DHCTARI(0,"Code",TarCode))&('$D(^DHCTARI(0,"Desc",TarDesc)))) RetStr=..RetErrorValue(RetStr,"收费项代码已经存在:"_TarCode)
    .if ($D(^DHCTARI(0,"Desc",TarDesc))&('$D(^DHCTARI(0,"Code",TarCode)))) s TarDesc=TarDesc_TarCode
    .s:($D(^DHCTARI(0,"Desc",TarDesc))&('$D(^DHCTARI(0,"Code",TarCode)))) RetStr=..RetErrorValue(RetStr,"收费项名称已经存在:"_TarDesc)
    s UserDr=$o(^SSU("SSUSR",0))
    s BaseUom=$tr($p(RowStr,del,8)," ",""),BaseUomDr="" //计价单位
    if BaseUom="" s RetStr=..RetErrorValue(RetStr,"计价单位为空"_OrdCode) q RetStr
    i BaseUom'=""  d
    .s BaseUomDr=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(BaseUom),""))
    if BaseUomDr="" s RetStr=..RetErrorValue(RetStr,"计价单位指针出错"_OrdCode) q RetStr
    s TarUom=$tr($p(RowStr,del,35)," ",""),TarUomDr="" //医嘱单位
    if TarUom="" s RetStr=..RetErrorValue(RetStr,"医嘱单位为空"_OrdCode) q RetStr
    i TarUom'=""  d
    .s TarUomDr=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(TarUom),""))
    if TarUomDr="" s RetStr=..RetErrorValue(RetStr,"医嘱单位指针出错"_OrdCode) q RetStr
    s OrdMsg=$P(RowStr,del,30),Equipment=$P(RowStr,del,31)
    s OnItsOwn=$$ALPHAUP^SSUTIL4($p(RowStr,del,26))
	..s:OnItsOwn="" OnItsOwn="Y"
	if ($g(OrdDesc)'="")&($g(OrdCode)'="") d
	.if (('$d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc))))&('$d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))))) d
	..S abbr="1"
	..s ArcCat=$p(RowStr,del,9)
	..s ArcSubCat=$p(RowStr,del,10),ArcSubCatDr=""
	..if ArcSubCat="" s RetStr=..RetErrorValue(RetStr,"医嘱子类为空:"_OrdCode) q  
	..;s ArcSubCatTmp=ArcSubCat_ArcCat
	..s ArcSubCatDr=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(ArcSubCat),"")) 
	..;s ArcSubCatDr=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(ArcSubCatTmp),"")) 
	..if ArcSubCatDr="" s RetStr=..RetErrorValue(RetStr,"医嘱子类指针出错:"_OrdCode_","_ArcSubCat) q
	..i ((OnItsOwn'="Y")&(OnItsOwn'="N")) s OnItsOwn="Y"
	..s BillGrp=$p(RowStr,del,11)
	..s:BillGrp="" RetStr=..RetErrorValue(RetStr,"帐单组为空:"_OrdCode)
	..q:BillGrp=""
	..s BillGrpDr=$o(^ARCBG(0,"DESC",$$ALPHAUP^SSUTIL4(BillGrp),"")) 
	..s:BillGrpDr="" RetStr=..RetErrorValue(RetStr,"帐单组指针出错:"_OrdCode_","_BillGrp)
	 ..q:BillGrpDr=""
	 ..s BillSubGrp=$p(RowStr,del,12)
	 ..s:BillSubGrp="" RetStr=..RetErrorValue(RetStr,"帐单子组名称为空:"_OrdCode_","_BillSubGrp)
	 ..q:BillSubGrp=""
	 ..s BillSubGrpDr=$o(^ARCBG("SG_Desc",$$ALPHAUP^SSUTIL4(BillSubGrp),BillGrpDr,""))
	 ..s:BillSubGrpDr="" RetStr=..RetErrorValue(RetStr,"帐单子组指针出错"_OrdCode_","_BillSubGrp)
	 ..q:BillSubGrpDr=""
	 ..
	 ..s BillSubGrpDr=BillGrpDr_"||"_BillSubGrpDr
	 ..s Priority=$p(RowStr,del,27)
	 ..s Priority=$tr(Priority," ","")
	 ..s:$g(Priority)'="" PrioDr=$o(^OECPR(0,"Desc",$$ALPHAUP^SSUTIL4(Priority),""))
	 ..if (($g(PrioDr)="")&($g(Priority)'="")) s RetStr=..RetErrorValue(RetStr,"取医嘱优先级指针出错:"_OrdCode)
	 ..s:$g(PrioDr)="" PrioDr=""
	 ..s resGrp=$p(RowStr,del,28)
	 ..s ServiceGroupDr=""
	 ..//if $g(Equipment)'="" d
	 ..//
	 ..;.s ServiceGroupDr=$o(^RBC("SG",0,"Desc",$$ALPHAUP^SSUTIL4(ArcCat),""))
	 ..;.if $g(ServiceGroupDr)="" s ServiceGroupDr=$o(^RBC("SG",0,"Desc",$$ALPHAUP^SSUTIL4("检查"),""))
	 ..S Sentive=$p(RowStr,del,32)
     ..if ChangeType'="Test" d
     ...k PLIST 
	 ...IF $G(Sentive)'="" S PLIST(133)="Y"
	 ...;if $g(ServiceGroupDr)'="" s PLIST(97)=ServiceGroupDr,PLIST(76)=$g(Equipment)
	 ...if $g(Equipment)'=""  d
	 ....s PLIST(76)=$g(Equipment)
	 ...if ArcCat["材料" s PLIST(76)="M"
	 ...s PLIST(2)=OrdCode,PLIST(3)=OrdDesc,PLIST(4)=abbr,PLIST(105)=TarUomDr  //20110319
	 ...s PLIST(9)=ArcSubCatDr,PLIST(47)=BillSubGrpDr,PLIST(83)=OnItsOwn
	 ...s PLIST(113)=PrioDr,PLIST(117)=resGrp
	 ...if stopflag="1" s PLIST(73)=$H-1
	 ...&SQL(INSERT INTO SQLUser.ARC_ItmMast VALUES PLIST())
	 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItmMast -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	 ...q:$g(SQLCODE)
	 ...s OrdCode=$$ALPHAUP^SSUTIL4(OrdCode)
	 ...s ArcimId1=$o(^ARCIM(0,"Code",OrdCode,""))
	 ...s:ArcimId1="" RetStr=..RetErrorValue(RetStr,"取医嘱针出错:"_OrdCode)
	 ...q:ArcimId1=""
	 ...s ArcimId2=$o(^ARCIM(0,"Code",OrdCode,ArcimId1,""))
	 ...q:ArcimId2=""
	 ...s ArcimId=ArcimId1_"||"_ArcimId2
	 ...//医嘱提示信息
	 ...IF $g(OrdMsg)'="" d 
	 ....IF $D(^ARCIM(ArcimId1,ArcimId2,"OEM",0)) s ^ARCIM(ArcimId1,ArcimId2,"OEM",1)=OrdMsg
	 ....IF '$D(^ARCIM(ArcimId1,ArcimId2,"OEM",0)) s ^ARCIM(ArcimId1,ArcimId2,"OEM",0)=1,^ARCIM(ArcimId1,ArcimId2,"OEM",1)=OrdMsg
	 ...//价格
	 ...s Price=$tr($p(RowStr,del,7)," ")
	 ...i Price'="" s Price=+Price
	 ...;else  s RetStr=..RetErrorValue(RetStr,"价格为空")  //柳旭生注释掉
	 ...q:Price=""
	 ...if ChangeType'="Test" d
	 ....k PLIST
	 ....s PLIST(0)=ArcimId,PLIST(3)=+$h,PLIST(5)=1,PLIST(6)=Price  ;; PLIST(5)*: ARC_Tariff
     ....&SQL(INSERT INTO SQLUser.ARC_ItemPriceItaly VALUES :PLIST())
     ....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItemPriceItaly -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))

 //医嘱别名
 
 if ($g(OrdDesc)'="")&($g(OrdCode)'="") d
 .if (($d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc))))&($d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))))) d
 .s Alias=$P(RowStr,del,6)
 .i Alias'="" d
 ..s ArcimId1=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode),""))
 ..s:ArcimId1="" RetStr=..RetErrorValue(RetStr,"别名取医嘱针出错:"_OrdCode)
 ..q:ArcimId1=""
 ..s ArcimId2=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode),ArcimId1,""))
 ..q:ArcimId2=""
 ..s ArcimId=ArcimId1_"||"_ArcimId2
 ..s ArcCatDr=""
 ..s ArcSubCatDr=$p(^ARCIM(ArcimId1,ArcimId2,1),del,10)
 ..if $g(ArcSubCatDr) s ArcCatDr=$p(^ARC("IC",ArcSubCatDr),del,8)
 ..set I=1
 ..s num=$l(Alias,"/")
 ..s ALI=""
 ..FOR I=1:1:num d
 ...s ALI=$p(Alias,"/",I)
 ...q:$g(ALI)=""
 ...;q:$d(^ARC("ALIAS",0,"Desc",$$ALPHAUP^SSUTIL4(ALI)_" ",$$ALPHAUP^SSUTIL4(OrdDesc)))
 ...S AliaId=$o(^ARC("ALIAS",0,"Desc",$$ALPHAUP^SSUTIL4(ALI)_" ",$$ALPHAUP^SSUTIL4(OrdDesc),0))
 ...if $g(AliaId)'="" s ArcimIdTmp=$p(^ARC("ALIAS",AliaId),del,1)
 ...q:(($g(ArcimId)=$g(ArcimIdTmp))&($g(AliaId)'=""))
 ...S ALI=$$ALPHAUP^SSUTIL4(ALI)
 ...if ChangeType'="Test" d
 ....k PLIST 
 ....s PLIST(2)=ArcimId,PLIST(5)=OrdDesc,PLIST(6)=ArcSubCatDr,PLIST(9)=OnItsOwn,PLIST(14)=+$h
 ....set PLIST(4)=ALI
 ....if $g(AliaId)'="" d
 .....&SQL(Update SQLUser.ARC_Alias Set ALIAS_ARCIM_DR=:ArcimId where ALIAS_RowId=:AliaId) 
 ....else  d
 .....&SQL(INSERT INTO SQLUser.ARC_Alias VALUES PLIST()) 
 ....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_Alias -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ....q:$g(SQLCODE)
 ....s ArcKeyId=0,CircleFlag=1
 ....f  s ArcKeyId=$o(^ARC("KEYW",0,"ARCIM",ArcimId,ArcKeyId)) q:((ArcKeyId="")!(CircleFlag=0))  d
 .....s ArcKey=$p(^ARC("KEYW",ArcKeyId),del,3)
 .....if ALI=ArcKey s CircleFlag=0,ArcKeyIdTmp=ArcKeyId
 ....;q:(CircleFlag=0)
 ....k PLIST 
 ....s PLIST(2)=ArcimId,PLIST(5)=ALI_"-"_OrdDesc,PLIST(6)=ArcSubCatDr,PLIST(7)=ArcCatDr
 ....set PLIST(4)=ALI_"Z"
 ....if CircleFlag=0 d
 .....&SQL(Update SQLUser.ARC_ItemKeywords set KEYW_ARCIM_DR=:ArcimId where KEYW_RowId=:ArcKeyIdTmp)
 ....else  d
 .....&SQL(INSERT INTO SQLUser.ARC_ItemKeywords VALUES PLIST()) 
 ....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItemKeywords -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))

 //收费项目
 if ($g(TarCode)'="")&($g(TarDesc)'="") d
 .if (('$D(^DHCTARI(0,"Code",TarCode)))&('$D(^DHCTARI(0,"Desc",TarDesc)))) d
	..s TarSubCatDr="",OUTPDR="",INPDR="",EMCDR="",ACCTDR="",ACCTDR="",MRDR=""
	..s TarSubCat=$P(RowStr,del,14)
	..SET INP=$P(RowStr,del,16),OUTP=$P(RowStr,del,18),EMC=$P(RowStr,del,20),ACCT=$P(RowStr,del,22),MR=$P(RowStr,del,24)
	..q:BaseUomDr=""
	..s:TarSubCat="" RetStr=..RetErrorValue(RetStr,"收费子类为空:"_TarCode)
	..;q:TarSubCat=""
	..SET:TarSubCat'="" TarSubCatDr=$O(^DHCTarC("SC",0,"Desc",TarSubCat,""))
	..s:TarSubCatDr="" RetStr=..RetErrorValue(RetStr,"收费子指针出错:"_TarCode_","_TarSubCat)
	..;Q:TarSubCatDr=""
	..if OUTP="" s RetStr=..RetErrorValue(RetStr,"门诊子类为空:"_TarCode) 
	..SET:OUTP'="" OUTPDR=$O(^DHCTarC("OC",0,"Desc",OUTP,""))
	..if OUTPDR="" s RetStr=..RetErrorValue(RetStr,"门诊子类指针出错:"_TarCode_","_OUTP) 
	..if INP="" s RetStr=..RetErrorValue(RetStr,"住院子类为空:"_TarCode) 
	..SET:INP'="" INPDR=$O(^DHCTarC("IC",0,"Desc",INP,"")) 
	..if INPDR="" s RetStr=..RetErrorValue(RetStr,"住院子类指针出错:"_TarCode_","_INP) 
	..if EMC="" s RetStr=..RetErrorValue(RetStr,"核算子类为空:"_TarCode) 
	..SET:EMC'="" EMCDR=$O(^DHCTarC("EC",0,"Desc",EMC,""))
	..if EMCDR="" s RetStr=..RetErrorValue(RetStr,"核算子类指针出错:"_TarCode_","_EMC) 
	..if ACCT="" s RetStr=..RetErrorValue(RetStr,"会计科目子类为空:"_TarCode) 
	..SET:ACCT'="" ACCTDR=$O(^DHCTarC("AC",0,"Desc",ACCT,""))
	..if ACCTDR="" s RetStr=..RetErrorValue(RetStr,"会计科目指针出错:"_TarCode_","_ACCT) 
	..
	..if MR="" s RetStr=..RetErrorValue(RetStr,"病案子类为空:"_TarCode) 
	..s MR=$$ALPHAUP^SSUTIL4(MR)
	..SET:MR'="" MRDR=$o(^DHCTarC("MC",0,"Desc",MR,""))
	..if MRDR="" s RetStr=..RetErrorValue(RetStr,"病案指针出错:"_TarCode_","_MR) 
	..if ChangeType'="Test" d
	...K PLIST
     ...s ^LTemp(TarCode,OrdCode,"Price","1")=$tr($p(RowStr,del,7)," ")

	...SET PLIST(10)="N",PLIST(11)="Y",PLIST(12)=+$H
	...SET PLIST(2)=TarCode,PLIST(3)=TarDesc,PLIST(4)=BaseUomDr,PLIST(5)=TarSubCatDr,PLIST(6)=ACCTDR,PLIST(7)=OUTPDR
	...SET PLIST(8)=EMCDR,PLIST(9)=MRDR,PLIST(18)=INPDR
	...if stopflag="1" s PLIST(11)="N"
	...&SQL(INSERT INTO SQLUser.DHC_TARITEM VALUES :PLIST())
	...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_TARITEM -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ...q:$g(SQLCODE)
 ...s TarId=$o(^DHCTARI(0,"Code",TarCode,""))
 ...s ^LTemp(TarCode,OrdCode,"Price","1",TarId)=$tr($p(RowStr,del,7)," ")

 ...s ^DHCTARIIMPORT("ImportTreatmentData",TarCode)=TarId_"^"_..getrdata(RowStr)
 ...i $G(TarSource)'="" s $P(^DHCTARI(TarId),"^",20)=TarSource
 ...if TarId="" s RetStr=RetStr=..RetErrorValue(RetStr,"收费项指针出错"_TarCode)
 ...q:TarId=""

 ...set I=1
 ...k PLIST 
 ...s PLIST(2)=TarId,PLIST(3)=TarDesc
 ...s Alias=$p(RowStr,del,3)
 ...if Alias="" s RetStr=RetStr=..RetErrorValue(RetStr,"收费项别名空"_TarCode)
 ...FOR  s ALI=$P(Alias,"/",I)  q:ALI=""  D
 ....s ALI=$$ALPHAUP^SSUTIL4(ALI)
 ....set PLIST(4)=ALI
 ....SET I=I+1
 ....s TiaId=0,CircleFlag=1
 ....f  s TiaId=$o(^DHCTARAL("A",TarId,TiaId)) q:((TiaId="")!(CircleFlag=0))  d
 .....s AliaTmp=$p(^DHCTARAL(TiaId),del,3)
 .....if $$ALPHAUP^SSUTIL4(AliaTmp)=$$ALPHAUP^SSUTIL4(ALI) s CircleFlag=0
 ....if ((CircleFlag=1)&(ChangeType'="Test")) d
 .....&SQL(INSERT INTO SQLUser.DHC_TARITEMAlias VALUES :PLIST()) 
 .....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_TARITEMAlias -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 .....s ^DHCTARAL(0)=^mdata("DHCTARITEMALIAS")

 ...s Price=$tr($p(RowStr,del,7)," ")
 ...s ^LTemp(TarCode,OrdCode,"Price")=Price
 ...s:Price='"" Price=+Price
 ...s:Price="" RetStr=..RetErrorValue(RetStr,"收费项价格为空"_TarCode)
 ...k PLIST 
 ...s TPRate=$tr($p(RowStr,del,42)," ")
 ...s ^LTemp(TarCode,OrdCode,"Price",TarId)=Price

 ...s PLIST(0)=TarId,PLIST(3)=+$H-1,PLIST(5)=Price,PLIST(8)=UserDr,PLIST(13)="1",PLIST(16)=$g(TPRate)
 ...&SQL(INSERT INTO SQLUser.DHC_TARItemPrice VALUES :PLIST())
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_TARItemPrice -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	//医嘱与收费项目对照
	q:(($g(OrdCode)="")&($g(OrdDesc)="")) RetStr
	q:(($g(TarCode)="")&($g(TarDesc)="")) RetStr
	q:(($g(OrdCode)="")!($g(OrdDesc)="")) ..RetErrorValue(RetStr,"医嘱项目名称或代码为空")
	q:(($g(TarCode)="")!($g(TarDesc)="")) ..RetErrorValue(RetStr,"收费项目名称或代码为空")
	if (($g(OrdCode)'="")&($g(OrdDesc)'="")&($g(TarCode)'="")!($g(TarDesc)'="")) d
	.if (($d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))))&($d(^DHCTARI(0,"Code",TarCode)))) d
	..SET ArcimId1=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode),""))
	..if ArcimId1="" s RetStr=..RetErrorValue(RetStr,"对照时医嘱id出错"_OrdCode)
	..q:ArcimId1=""
	..SET ArcimId=ArcimId1_"||"_$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode),ArcimId1,""))
	..SET TarId=$O(^DHCTARI(0,"Code",TarCode,""))
	..if TarId="" s RetStr=..RetErrorValue(RetStr,"对照时收费项目id出错"_TarCode)
 ..q:TarId="" 
 ..q:$d(^DHCOLT(0,"ARTTA",ArcimId,TarId))
 ..if ChangeType'="Test" d
 ...K PLIST
 ...s qty=$p(RowStr,del,29)
 ...i qty="" s qty=1
 ...SET PLIST(2)=ArcimId,PLIST(3)=TarId,PLIST(4)=qty,PLIST(5)=+$H-1
 ...&SQL(INSERT INTO SQLUser.DHC_ORDERLINKTAR VALUES :PLIST())
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_ORDERLINKTAR -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod getrdataDrug(rowstr) As %String
{
  s l=$L(rowstr,"^")
  s a=""
  s j=1
  for i=67:1:l
  {
   s b=$P(rowstr,"^",i)
   s $P(a,"^",j)=b
   s j=j+1 
   b
  }
  q a
}

ClassMethod getrdata(rowstr) As %String
{
  s l=$L(rowstr,"^")
  s a=""
  s j=1
  for i=36:1:l
  {
   s b=$P(rowstr,"^",i)
   s $P(a,"^",j)=b
   s j=j+1 
   b
  }
  q a
}

// 以上为协和使用

/// 医嘱数据
ClassMethod ArcimDataqt(ChangeType As %String = "", RowStr As %String = "") As %String
{

	//	1	       2	       3	     4	      5      	6	     7	         8	         9	          10	    
	//收费代码	收费名称	收费拼音	单价	单位	收费依据	医嘱代码	医嘱项名称	医嘱拼音	医嘱单位	
	//11		12			13			14			15			16			17			18	
	//医嘱大类	医嘱子类	帐单大类	帐单子类	收费大类	收费子类	住院发票	住院子类	
	//19		   20		21		   	22	    	23		24		25	  	26			27		 28		      29	
	//门诊发票	门诊子类	核算类	核算子类	会计类	会计子类	病案类	病案子类	开展	独立医嘱	优先级	
	//30     31       32			33		34			35
	//结果	次数	医嘱提示	设备名称	急诊标识	医嘱项简称
   
	if ChangeType="Clear"  d
	.K ^ARCIM,^ARC("ALIAS"),^ARC("KEYW")
	.k ^DHCTARI,^DHCTARIi,^mdata("DHCTARITEM"),^DHCTARAL,^mdata("DHCTARITEMALIAS")
	.k ^DHCOLT,^mdata("DHCORDERLINKTAR"),^DHCTARF,^mdata("DHCTARFACTOR")
	q:ChangeType="Clear" "数据已清:医嘱项"
	;if +$g(^mdata("DHCTARITEM"))<+$g(^DHCTARI(0)) S ^mdata("DHCTARITEM")=^DHCTARI(0)
	;if +$g(^mdata("DHCTARITEMALIAS"))<+$g(^DHCTARAL(0)) s ^mdata("DHCTARITEMALIAS")=^DHCTARAL(0)
	;if +$g(^mdata("DHCORDERLINKTAR"))<+$g(^DHCOLT(0)) S ^mdata("DHCORDERLINKTAR")=^DHCOLT(0)
	

	s del="^"
	s RetStr=""
	SET RowStr=$tr(RowStr," ","")
	SET TarCode=$P(RowStr,del,1),TarDesc=$P(RowStr,del,2),OrdCode=$P(RowStr,del,7),OrdDesc=$P(RowStr,del,8)
	if ((OrdCode="") & (OrdDesc="")) d
	else  d
	.if OrdCode="" s RetStr=..RetErrorValue(RetStr,"医嘱代码为空:")
    .if OrdDesc="" s RetStr=..RetErrorValue(RetStr,"医嘱名称为空:")
    if ((TarCode="") & (TarDesc="")) d
	else  d
	.if TarCode="" s RetStr=..RetErrorValue(RetStr,"收费项代码为空:")
    .if TarDesc="" s RetStr=..RetErrorValue(RetStr,"收费项名称为空:")
    ;q:$g(TarCode)="" ""
 	
 s UserDr=$o(^SSU("SSUSR",0))
 ;s BaseUom=$p(RowStr,del,10),BaseUomDr="" //基本单位
 ;if BaseUom="" s RetStr=..RetErrorValue(RetStr,"医嘱单位为空"_OrdCode) 

 s ArcCat=$p(RowStr,del,11)
 ;q:ArcCat="床位" ""
 ;q:ArcCat="化验" ""
 s OrdMsg=$P(RowStr,del,32),Equipment=$P(RowStr,del,33)
 s OnItsOwn=$$ALPHAUP^SSUTIL4($p(RowStr,del,28))
 s qty=$P(RowStr,del,31)
 if $g(qty)="" s qty=1
 s:OnItsOwn="" OnItsOwn="Y"
 //更新医嘱项目时用
 //'$d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc)))&
 ;q:$g(OrdCode)="" ""
 ;if (($d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))))) d
 ;.s ArcimId1=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode),""))
 ;.s:ArcimId1="" RetStr=..RetErrorValue(RetStr,"取医嘱针出错:"_OrdCode)
 ;.q:ArcimId1=""
 ;.s ArcimId2=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode),ArcimId1,""))
 ;.q:ArcimId2=""
 ;.s ArcimId=ArcimId1_"||"_ArcimId2
 ;.s ArcSubCat=$p(RowStr,del,12)
 ;.if ArcSubCat="" s RetStr=..RetErrorValue(RetStr,"医嘱子类为空:"_OrdCode) q
 ;.s ArcSubCatDr=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(ArcSubCat),"")) 
 ;.;&sql(update SQLUser.ARC_ItmMast set Arcim_desc=:OrdDesc,ARCIM_ItemCat_DR=:ArcSubCatDr where arcim_rowid=:ArcimId)
 ;.;&sql(update SQLUser.ARC_ItmMast set Arcim_desc=:OrdDesc where arcim_rowid=:ArcimId)
 ;.&sql(update SQLUser.ARC_ItmMast set ARCIM_ItemCat_DR=:ArcSubCatDr where arcim_rowid=:ArcimId)
 ;q RetStr
 //更新医嘱提示
 ;if (($d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))))) d
 ;.s ArcimId1=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode),""))
 ;.s:ArcimId1="" RetStr=..RetErrorValue(RetStr,"取医嘱针出错:"_OrdCode)
 ;.s ArcimId2=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode),ArcimId1,""))
 ;.q:ArcimId2=""
 ;.IF $g(OrdMsg)'="" d 
 ;..;IF $D(^ARCIM(ArcimId1,ArcimId2,"OEM",0)) s ^ARCIM(ArcimId1,ArcimId2,"OEM",1)=OrdMsg
 ;..IF '$D(^ARCIM(ArcimId1,ArcimId2,"OEM",0)) s ^ARCIM(ArcimId1,ArcimId2,"OEM",0)=1,^ARCIM(ArcimId1,ArcimId2,"OEM",1)=OrdMsg
 ;q RetStr	
 //医嘱项
	if ($g(OrdDesc)'="")&($g(OrdCode)'="") d
	.;q
	.if (($g(OrdDesc)'="")&($g(OrdCode)'="")) d
 	.s:($d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc)))&('$d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))))) RetStr=..RetErrorValue(RetStr,"医嘱项名称已经存在:"_OrdDesc)
 	.s:($d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode)))&('$d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc))))) RetStr=..RetErrorValue(RetStr,"医嘱项代码已经存在:"_OrdCode)
 	.q:($g(OrdDesc)="")
 	.q:($g(OrdCode)="")
	.if (('$d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc))))&('$d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))))) d
	..s BaseUom=$p(RowStr,del,10),BaseUomDr="" //基本单位
	..s:(BaseUom="") RetStr=..RetErrorValue(RetStr,"医嘱单位为空"_OrdCode_":"_BaseUom) 
 	..q:($g(BaseUom)="")
 	..s BaseUomDr=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(BaseUom),""))
	..if BaseUomDr="" s RetStr=..RetErrorValue(RetStr,"医嘱单位指针出错"_OrdCode_":"_BaseUom) 
	..q:(BaseUomDr="")
	..S abbr=$p(RowStr,del,35)
	..S:abbr="" abbr=1
	..s ArcCat=$p(RowStr,del,11)
	..s ArcSubCat=$p(RowStr,del,12),ArcSubCatDr=""
	..if ArcSubCat="" s RetStr=..RetErrorValue(RetStr,"医嘱子类为空:"_OrdCode) q  
	..;s ArcSubCatTmp=ArcSubCat_ArcCat
	..s ArcSubCatDr=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(ArcSubCat),"")) 
	..;s ArcSubCatDr=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(ArcSubCatTmp),"")) 
	..if ArcSubCatDr="" s RetStr=..RetErrorValue(RetStr,"医嘱子类指针出错:"_OrdCode_","_ArcSubCat) q
	..i ((OnItsOwn'="Y")&(OnItsOwn'="N")) s OnItsOwn="Y"
	..s BillGrp=$p(RowStr,del,13)
	..s:BillGrp="" RetStr=..RetErrorValue(RetStr,"帐单组为空:"_OrdCode)
	..q:BillGrp=""
	..s BillGrpDr=$o(^ARCBG(0,"DESC",$$ALPHAUP^SSUTIL4(BillGrp),"")) 
	..s:BillGrpDr="" RetStr=..RetErrorValue(RetStr,"帐单组指针出错:"_OrdCode_","_BillGrp)
 ..q:BillGrpDr=""
 ..s BillSubGrp=$p(RowStr,del,14)
 ..s:BillSubGrp="" RetStr=..RetErrorValue(RetStr,"帐单子组名称为空:"_OrdCode_","_BillSubGrp)
 ..q:BillSubGrp=""
 ..s BillSubGrpDr=$o(^ARCBG("SG_Desc",$$ALPHAUP^SSUTIL4(BillSubGrp),BillGrpDr,""))
 ..s:BillSubGrpDr="" RetStr=..RetErrorValue(RetStr,"帐单子组指针出错"_OrdCode_","_BillSubGrp)
 ..q:BillSubGrpDr=""
 ..
	..s BillSubGrpDr=BillGrpDr_"||"_BillSubGrpDr
	..s Priority=$p(RowStr,del,29)
	..s Priority=$tr(Priority," ","")
	..s:$g(Priority)'="" PrioDr=$o(^OECPR(0,"Desc",$$ALPHAUP^SSUTIL4(Priority),""))
	..if (($g(PrioDr)="")&($g(Priority)'="")) s RetStr=..RetErrorValue(RetStr,"取医嘱优先级指针出错:"_OrdCode)
	..s:$g(PrioDr)="" PrioDr=""
	..s resGrp=$p(RowStr,del,30)
	..s ServiceGroupDr=""
	..if $g(Equipment)'="" d
	...s ServiceGroupDr=$o(^RBC("SG",0,"Desc",$$ALPHAUP^SSUTIL4(ArcCat),""))
	...if $g(ServiceGroupDr)="" s ServiceGroupDr=$o(^RBC("SG",0,"Desc",$$ALPHAUP^SSUTIL4("检查"),""))
	..S Sentive=$p(RowStr,del,34)
 ..if ChangeType'="Test" d
 ...k PLIST 
 ...IF $G(Sentive)'="" S PLIST(133)="Y"
 ...if $g(ServiceGroupDr)'="" s PLIST(97)=ServiceGroupDr,PLIST(76)="S"
 ...if ArcCat["材料" s PLIST(76)="M"
 ...s PLIST(2)=OrdCode,PLIST(3)=OrdDesc,PLIST(4)=abbr,PLIST(105)=BaseUomDr
 ...s PLIST(9)=ArcSubCatDr,PLIST(47)=BillSubGrpDr,PLIST(83)=OnItsOwn
 ...s PLIST(113)=PrioDr,PLIST(117)=resGrp
 ...&SQL(INSERT INTO SQLUser.ARC_ItmMast VALUES PLIST())
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItmMast -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ...q:$g(SQLCODE)
 ...s ArcimId1=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode),""))
 ...s:ArcimId1="" RetStr=..RetErrorValue(RetStr,"取医嘱针出错:"_OrdCode)
 ...q:ArcimId1=""
 ...s ArcimId2=$o(^ARCIM(0,"Code",OrdCode,ArcimId1,""))
 ...q:ArcimId2=""
 ...s ArcimId=ArcimId1_"||"_ArcimId2
 ...//医嘱提示信息
 ...IF $g(OrdMsg)'="" d 
 ....IF $D(^ARCIM(ArcimId1,ArcimId2,"OEM",0)) s ^ARCIM(ArcimId1,ArcimId2,"OEM",1)=OrdMsg
 ....IF '$D(^ARCIM(ArcimId1,ArcimId2,"OEM",0)) s ^ARCIM(ArcimId1,ArcimId2,"OEM",0)=1,^ARCIM(ArcimId1,ArcimId2,"OEM",1)=OrdMsg
 ...//价格
 ...s Price=$tr($p(RowStr,del,7)," ")
 ...i Price'="" s Price=+Price
 ...else  s RetStr=..RetErrorValue(RetStr,"价格为空")
 ...q:Price=""
 ...if ChangeType'="Test" d
 ....k PLIST
	....s PLIST(0)=ArcimId,PLIST(3)=+$h,PLIST(5)=1,PLIST(6)=Price  ;; PLIST(5)*: ARC_Tariff
 ....;&SQL(INSERT INTO SQLUser.ARC_ItemPriceItaly VALUES :PLIST())
 ....;s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItemPriceItaly -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))

 //医嘱别名
 if ($g(OrdDesc)'="")&($g(OrdCode)'="") d
 .;q
 .if $d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))) d
 .s Alias=$P(RowStr,del,9)
 .i Alias'="" d
 ..s ArcimId1=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode),""))
 ..s:ArcimId1="" RetStr=..RetErrorValue(RetStr,"别名取医嘱针出错:"_OrdCode)
 ..q:ArcimId1=""
 ..s ArcimId2=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode),ArcimId1,""))
 ..q:ArcimId2=""
 ..s ArcimId=ArcimId1_"||"_ArcimId2
 ..s ArcCatDr=""
 ..s ArcSubCatDr=$p(^ARCIM(ArcimId1,ArcimId2,1),del,10)
 ..;&SQL(delete from SQLUser.ARC_Alias where ALIAS_ARCIM_DR=:ArcimId)
 ..;q
 ..if $g(ArcSubCatDr) s ArcCatDr=$p(^ARC("IC",ArcSubCatDr),del,8)
 ..set I=0
 ..s num=$l(Alias,"/")
 ..s ALI=""
 ..FOR  S I=I+1 q:I>num  d
 ...s ALI=$p(Alias,"/",I)
 ...q:$g(ALI)=""
 ...;q:$d(^ARC("ALIAS",0,"Desc",$$ALPHAUP^SSUTIL4(ALI)_" ",$$ALPHAUP^SSUTIL4(OrdDesc)))
 ...S AliaId=$o(^ARC("ALIAS",0,"Desc",$$ALPHAUP^SSUTIL4(ALI)_" ",$$ALPHAUP^SSUTIL4(OrdDesc),0))
 ...if $g(AliaId)'="" s ArcimIdTmp=$p(^ARC("ALIAS",AliaId),del,1)
 ...q:(($g(ArcimId)=$g(ArcimIdTmp))&($g(AliaId)'=""))
 ...S ALI=$$ALPHAUP^SSUTIL4(ALI)
 ...if ChangeType'="Test" d
 ....k PLIST 
 ....s PLIST(2)=ArcimId,PLIST(5)=OrdDesc,PLIST(6)=ArcSubCatDr,PLIST(9)=OnItsOwn,PLIST(14)=+$h
 ....set PLIST(4)=ALI
 ....if $g(AliaId)'="" d
 .....&SQL(Update SQLUser.ARC_Alias Set ALIAS_ARCIM_DR=:ArcimId where ALIAS_RowId=:AliaId) 
 ....else  d
 .....&SQL(INSERT INTO SQLUser.ARC_Alias VALUES PLIST()) 
 ....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_Alias -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ....q:$g(SQLCODE)
 ....s ArcKeyId=0,CircleFlag=1
 ....f  s ArcKeyId=$o(^ARC("KEYW",0,"ARCIM",ArcimId,ArcKeyId)) q:((ArcKeyId="")!(CircleFlag=0))  d
 .....s ArcKey=$p(^ARC("KEYW",ArcKeyId),del,3)
 .....if ALI=ArcKey s CircleFlag=0,ArcKeyIdTmp=ArcKeyId
 ....;q:(CircleFlag=0)
 ....k PLIST 
 ....s PLIST(2)=ArcimId,PLIST(5)=ALI_"-"_OrdDesc,PLIST(6)=ArcSubCatDr,PLIST(7)=ArcCatDr
 ....set PLIST(4)=ALI_"Z"
 ....if CircleFlag=0 d
 .....&SQL(Update SQLUser.ARC_ItemKeywords set KEYW_ARCIM_DR=:ArcimId where KEYW_RowId=:ArcKeyIdTmp)
 ....else  d
 .....&SQL(INSERT INTO SQLUser.ARC_ItemKeywords VALUES PLIST()) 
 ....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItemKeywords -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))

 
 //医嘱对应设备的服务
 if (($g(OrdCode)'="")&($g(OrdDesc)'="")&($g(Equipment)'="")) d
 .if ($d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))))&($g(Equipment)'="") d
	..s ArcimId1=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc),""))
	..s:ArcimId1="" RetStr=..RetErrorValue(RetStr,"取医嘱指针出错:"_OrdDesc)
	..q:ArcimId1=""
	..s ArcimId2=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc),ArcimId1,""))
	..s Service=$p(^ARCIM(ArcimId1,ArcimId2,8),del,7)
	..s:Service="" RetStr=..RetErrorValue(RetStr,"取医嘱服务组指针出错:"_OrdDesc)
	..q:((Service="")!(Equipment="S"))
	..s ServiceId=0
	..s EqId=$o(^RBC("EQ",0,"Desc",$$ALPHAUP^SSUTIL4(Equipment),""))
	..;s:EqId="" RetStr=..RetErrorValue(RetStr,"取设备指针指针出错:"_Equipment)
	..q:EqId=""
	..s CircleFlag=1
	..f  s ServiceId=$o(^RBC("SER",0,"EQ",EqId,ServiceId)) q:((ServiceId="")!(CircleFlag=0))  d
	...s ArcimId=$p(^RBC("SER",ServiceId),del,1)
	...s:(ArcimId=(ArcimId1_"||"_ArcimId2)) CircleFlag=0
	..q:CircleFlag=0
	..if ChangeType'="Test" d
	...k PLIST
	...S PLIST(2)=ArcimId1_"||"_ArcimId2,PLIST(4)=0,PLIST(6)=EqId,PLIST(7)=$g(OrdDesc),PLIST(10)=Service,PLIST(11)="Y",PLIST(13)=$H-1
	...&SQL(INSERT INTO SQLUser.RBC_Services VALUES :PLIST())
	...if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RBC_Services -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	
 //收费项目
 if ($g(TarCode)'="")&($g(TarDesc)'="") d
 .;q    //fhq
 .s:($D(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(TarCode)))&('$D(^DHCTARI(0,"Desc",$$ALPHAUP^SSUTIL4(TarDesc))))) RetStr=..RetErrorValue(RetStr,"收费项代码已经存在:"_TarCode)
 .s:($D(^DHCTARI(0,"Desc",$$ALPHAUP^SSUTIL4(TarDesc)))&('$D(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(TarCode))))) RetStr=..RetErrorValue(RetStr,"收费项名称已经存在:"_TarDesc)
 .q:(($g(TarCode)=""))
 .q:($g(TarDesc)="")
 .if (('$D(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(TarCode))))&('$D(^DHCTARI(0,"Desc",$$ALPHAUP^SSUTIL4(TarDesc))))) d
	..s TarUom=$p(RowStr,del,5),TarUomDr="" //基本单位
 	..if TarUom="" s RetStr=..RetErrorValue(RetStr,"收费项单位为空"_OrdCode) 
 	..q:($g(TarUom)="")
 	..i TarUom'=""  d
 	...s TarUomDr=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(TarUom),""))
 	..if TarUomDr="" s RetStr=..RetErrorValue(RetStr,"收费项单位指针出错"_TarCode) q 
	..s TarSubCatDr="",OUTPDR="",INPDR="",EMCDR="",ACCTDR="",ACCTDR="",MRDR=""
	..s TarSubCat=$P(RowStr,del,16)
	..s TarChargeBasis=$P(RowStr,del,6)
	..SET INP=$P(RowStr,del,18),OUTP=$P(RowStr,del,20),EMC=$P(RowStr,del,22),ACCT=$P(RowStr,del,24),MR=$P(RowStr,del,26)
	..q:TarUomDr=""
	..s:TarSubCat="" RetStr=..RetErrorValue(RetStr,"收费子类为空:"_TarCode)
	..;q:TarSubCat=""
	..SET:TarSubCat'="" TarSubCatDr=$O(^DHCTarC("SC",0,"Desc",$$UPPER^SSUTIL4(TarSubCat),""))
	..s:TarSubCatDr="" RetStr=..RetErrorValue(RetStr,"收费子指针出错:"_TarCode_","_TarSubCat)
	..;Q:TarSubCatDr=""
	..if OUTP="" s RetStr=..RetErrorValue(RetStr,"门诊子类为空:"_TarCode) 
	..SET:OUTP'="" OUTPDR=$O(^DHCTarC("OC",0,"Desc",OUTP,""))
	..if OUTPDR="" s RetStr=..RetErrorValue(RetStr,"门诊子类指针出错:"_TarCode_","_OUTP) 
	..if INP="" s RetStr=..RetErrorValue(RetStr,"住院子类为空:"_TarCode) 
	..SET:INP'="" INPDR=$O(^DHCTarC("IC",0,"Desc",INP,"")) 
	..if INPDR="" s RetStr=..RetErrorValue(RetStr,"住院子类指针出错:"_TarCode_","_INP) 
	..if EMC="" s RetStr=..RetErrorValue(RetStr,"核算子类为空:"_TarCode) 
	..SET:EMC'="" EMCDR=$O(^DHCTarC("EC",0,"Desc",EMC,""))
	..if EMCDR="" s RetStr=..RetErrorValue(RetStr,"核算子类指针出错:"_TarCode_","_EMC) 
	..if ACCT="" s RetStr=..RetErrorValue(RetStr,"会计科目子类为空:"_TarCode) 
	..SET:ACCT'="" ACCTDR=$O(^DHCTarC("AC",0,"Desc",ACCT,""))
	..if ACCTDR="" s RetStr=..RetErrorValue(RetStr,"会计科目指针出错:"_TarCode_","_ACCT) 
	..
	..if MR="" s RetStr=..RetErrorValue(RetStr,"病案子类为空:"_TarCode) 
	..SET:MR'="" MRDR=$o(^DHCTarC("MC",0,"Desc",MR,""))
	..if MRDR="" s RetStr=..RetErrorValue(RetStr,"病案指针出错:"_TarCode_","_MRDR) 
	..if ChangeType'="Test" d
	...K PLIST
	...SET PLIST(10)="N",PLIST(11)="Y",PLIST(12)=+$H
	...SET PLIST(2)=TarCode,PLIST(3)=TarDesc,PLIST(4)=TarUomDr,PLIST(5)=TarSubCatDr,PLIST(6)=ACCTDR,PLIST(7)=OUTPDR
	...SET PLIST(8)=EMCDR,PLIST(9)=MRDR,PLIST(18)=INPDR,PLIST(21)=TarChargeBasis
	...&SQL(INSERT INTO SQLUser.DHC_TARITEM VALUES :PLIST())
	...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_TARITEM -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ...q:$g(SQLCODE)
 //收费项目别名
 if ($g(TarCode)'="")&($g(TarDesc)'="") d
 .;q //fhq
 .if (($D(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(TarCode))))) d
 ..s TarId=$o(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(TarCode),""))
 ..if TarId="" s RetStr=..RetErrorValue(RetStr,"别名取收费项指针出错"_TarCode)
 ..q:TarId=""
 ..;q
 ..set I=1
 ..k PLIST 
 ..s PLIST(2)=TarId,PLIST(3)=TarDesc
 ..s Alias=$p(RowStr,del,3)
 ..if Alias="" s RetStr=RetStr=..RetErrorValue(RetStr,"收费项别名空"_TarCode)
 ..FOR  s ALI=$P(Alias,"/",I)  q:ALI=""  D
 ...S ALI=$E(ALI,1,9)
 ...s ALI=$$ALPHAUP^SSUTIL4(ALI)
 ...set PLIST(4)=ALI
 ...SET I=I+1
 ...s TiaId=0,CircleFlag=1
 ...f  s TiaId=$o(^DHCTARAL("A",TarId,TiaId)) q:((TiaId="")!(CircleFlag=0))  d
 ....s AliaTmp=$p(^DHCTARAL(TiaId),del,3)
 ....if $$ALPHAUP^SSUTIL4(AliaTmp)=$$ALPHAUP^SSUTIL4(ALI) s CircleFlag=0
 ...if ((CircleFlag=1)&(ChangeType'="Test")) d
 ....&SQL(INSERT INTO SQLUser.DHC_TARITEMAlias VALUES :PLIST()) 
 ....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_TARITEMAlias -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ....;s ^DHCTARAL(0)=^mdata("DHCTARITEMALIAS")
 //收费项目价格
 if ($g(TarCode)'="")&($g(TarDesc)'="") d
 .;q  //fhq不导入价格时用，如果导入价格把此话给注释了
 .if (($D(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(TarCode))))) d
 ..s TarId=$o(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(TarCode),""))
 ..if TarId="" s RetStr=..RetErrorValue(RetStr,"价格收费项指针出错"_TarCode)
 ..q:TarId=""
 ..;k ^DHCTARI(TarId,"P")
 ..;q:$d(^DHCTARI(TarId,"P"))
 ..s Price=$tr($p(RowStr,del,4)," ","")
 ..s:Price'="" Price=+Price
 ..s:Price="" RetStr=..RetErrorValue(RetStr,"收费项价格为空"_TarCode)
 ..k PLIST 
 ..s PLIST(0)=TarId,PLIST(3)=+$H,PLIST(5)=Price,PLIST(8)=UserDr,PLIST(13)="1"
 ..q:(ChangeType="Test")
 ..&SQL(INSERT INTO SQLUser.DHC_TARItemPrice VALUES :PLIST())
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_TARItemPrice -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	//医嘱与收费项目对照
	q:(($g(OrdCode)="")&($g(OrdDesc)="")) RetStr
	q:$g(TarCode)="" ""
	;q:(($g(TarCode)="")&($g(TarDesc)="")) RetStr
	q:(($g(OrdCode)="")!($g(OrdDesc)="")) ..RetErrorValue(RetStr,"医嘱项目名称或代码为空")
	;q:(($g(TarCode)="")!($g(TarDesc)="")) ..RetErrorValue(RetStr,"收费项目名称或代码为空")
	if (($g(OrdCode)'="")&($g(OrdDesc)'="")&($g(TarCode)'="")!($g(TarDesc)'="")) d
	.if (($d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))))) d
	..SET ArcimId1=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode),""))
	..if ArcimId1="" s RetStr=..RetErrorValue(RetStr,"对照时医嘱id出错"_OrdCode)
	..q:ArcimId1=""
	..SET ArcimId=ArcimId1_"||"_$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode),ArcimId1,""))
	..SET TarId=$O(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(TarCode),""))
	..;&SQL(delete from SQLUser.DHC_ORDERLINKTAR where OLT_ARCIM_DR=:ArcimId)
	..;q
	..;IF TarId="" S TarId=$O(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(TarCode)_"A",""))
	..;IF TarId="" S TarId=$O(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(TarCode)_"B",""))
	..if TarId="" s RetStr=..RetErrorValue(RetStr,"对照时收费项目id出错"_TarCode)
 ..q:TarId="" 
 ..q:$d(^DHCOLT(0,"ARTTA",ArcimId,TarId))
 ..if ChangeType'="Test" d
 ...K PLIST
 ...SET PLIST(2)=ArcimId,PLIST(3)=TarId,PLIST(4)=qty,PLIST(5)=+$H-1
 ...&SQL(INSERT INTO SQLUser.DHC_ORDERLINKTAR VALUES :PLIST())
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_ORDERLINKTAR -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ...Q:$g(SQLCODE)
 ...;S ^DHCOLT(0)=^mdata("DHCORDERLINKTAR")
	q:RetStr="" "Ok"
	q RetStr
}

/// 医嘱人员数据
ClassMethod CareData(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" K ^CTPCP,^RB("RES"),^RBC("SER")
	q:ChangeType="Clear" "数据已清:医护人员和资源"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	s CtLocCode=$p(RowStr,del,1),CtLocDesc=$p(RowStr,del,2)
	SET Code=$P(RowStr,del,3),Desc=$P(RowStr,del,4),CpType=$P(RowStr,del,5),Abbr=$P(RowStr,del,11),CTSpecDesc=$P(RowStr,del,7)
	s CPPCPUNITcode=$P(RowStr,del,14),HICApproved=$P(RowStr,del,15)
	 //医生工号与执业证号对照
    i $g(HICApproved)'=""  d 
    .s HICApproved="Y" 
    e  d
    .s HICApproved="N" 
	q:Code="" ..RetErrorValue(RetStr,"代码为空")
	q:Desc="" ..RetErrorValue(RetStr,"名称为空")
	if (($D(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Code))))&('$D(^CTPCP(0,"Decs",$$ALPHAUP^SSUTIL4(Desc))))) s RetStr=..RetErrorValue(RetStr,"医护人员代码已经存在"_Code)
	if (($D(^CTPCP(0,"Decs",$$ALPHAUP^SSUTIL4(Desc))))&('$D(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Code))))) s RetStr=..RetErrorValue(RetStr,"医护人员名称已经存在"_Desc)
	q:CtLocDesc="" ..RetErrorValue(RetStr,"医护人员科室为空")
	s CpTypeDr=""
	if ('$D(^CTPCP(0,"Decs",$$ALPHAUP^SSUTIL4(Desc))))&('$D(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Code))))&(CpType'="") d
	.SET Label=Code,SMC=Code,Speciality=$P(RowStr,del,8)
	.s Title=$p(RowStr,del,6)
	.if Title'=""  d
	..;s Title=$o(^CT("TTL",0,"Desc",$$ALPHAUP^SSUTIL4(Title),""))
	..;if Title="" s RetStr=..RetErrorValue(RetStr,"职务类型指针出错")
	.IF CpType="" s RetStr=..RetErrorValue(RetStr,"医护人员类型为空") q
	.SET CpTypeDr=$O(^CT("CPT",0,"Desc",$$ALPHAUP^SSUTIL4(CpType),"")) 
	.IF CpTypeDr="" s RetStr=..RetErrorValue(RetStr,"医护人员类型指针出错"_CpType) q
	.s CtLoc=$p(CtLocCode,"/"),CtLocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtLoc),""))
	.if CtLocId="" s RetStr=..RetErrorValue(RetStr,"取人员科室指针出错CT_CareProv:"_CtLoc)
	.s CTSpecdr=""
	.if $g(CTSpecDesc)'="" d
	..s CTSpecdr=$o(^CT("SPC",0,"Desc",$$ALPHAUP^SSUTIL4(CTSpecDesc),""))
	..if CTSpecdr="" s RetStr=..RetErrorValue(RetStr,"取人员专长指针出错CT_Spec_:"_CTSpecDesc)
	.if ChangeType'="Test" d
	..if ('$D(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Code)))&('$D(^CTPCP(0,"Decs",$$ALPHAUP^SSUTIL4(Desc))))) d
	...K PLIST
	...SET PLIST(2)=Code,PLIST(3)=Desc,PLIST(4)=$g(Label),PLIST(7)=$g(CpTypeDr),PLIST(36)=$g(Speciality),PLIST(38)=+$h,PLIST(49)=$g(Title),PLIST(73)=$g(Abbr),PLIST(16)=$g(CTSpecdr),PLIST(12)=$g(CPPCPUNITcode)
	...&SQL(INSERT INTO SQLUser.CT_CareProv VALUES :PLIST())
	...if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"CT_CareProv -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	...if $g(%ROWID)'=""  d
	....S CTPRowid=%ROWID
	....k PLIST
	....s PLIST(0)=%ROWID,PLIST(3)=Desc
	....&SQL(INSERT INTO SQLUser.CT_CareProvKeywords VALUES :PLIST())
	....if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"CT_CareProvKeywords -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	....&SQL(update SQLUser.CT_CareProv set CTPCP_HICApproved=:HICApproved where CTPCP_ROWID=:CTPRowid)
	....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"CT_CareProv:CTPCP_HICApproved -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	.s CareProvId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	.IF CareProvId="" s RetStr=..RetErrorValue(RetStr,"取医护人员指针出错111:"_Code) q
	.S Services=$P(RowStr,del,9)
	.q:Services=""
	.s CircleNum=$l(Services,"/"),i=0
	.f  s i=i+1 q:(i>CircleNum)  d
	..s Service=$P(Services,"/",i)
	..q:$g(Service)=""
	..s ArcimId1=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(Service),""))
	..s:ArcimId1="" RetStr=..RetErrorValue(RetStr,"取医嘱指针出错:"_Code)
	..q:ArcimId1=""
	..s ArcimId2=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(Service),ArcimId1,""))
	..S ArcimDesc=$p(^ARCIM(ArcimId1,ArcimId2,1),del,2)
	..s Service=$p(^ARCIM(ArcimId1,ArcimId2,8),del,7)
	..s:Service="" RetStr=..RetErrorValue(RetStr,"取医嘱服务组指针出错:"_Code)
	..q:Service=""
	..s ServiceId=0
	..s CircleFlag=1
	..f  s ServiceId=$o(^RBC("SER",0,"CTCP",CareProvId,ServiceId)) q:((ServiceId="")!(CircleFlag=0))  d
	...s ArcimId=$p(^RBC("SER",ServiceId),del,1)
	...s:(ArcimId=(ArcimId1_"||"_ArcimId2)) CircleFlag=0
	..if CircleFlag=0 q
	..if ChangeType'="Test" d
	...k PLIST
	...S PLIST(2)=ArcimId1_"||"_ArcimId2,PLIST(4)=0,PLIST(5)=CareProvId,PLIST(7)=$g(ArcimDesc),PLIST(10)=Service,PLIST(11)="Y",PLIST(13)=$H-1
	...&SQL(INSERT INTO SQLUser.RBC_Services VALUES :PLIST())
	...if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RBC_Services -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	
	//医护人员所在科室
	IF (CpType'="") d
	.s SessTypeDr="",ClinicGroupDr="",SessType=$P(RowStr,del,12),ClinicGroup=$P(RowStr,del,13)
	.SET CpTypeDr=$O(^CT("CPT",0,"Desc",$$ALPHAUP^SSUTIL4(CpType),"")) 
	.IF CpTypeDr="" s RetStr=..RetErrorValue(RetStr,"医护人员类型指针出错"_CpType) q
	.if ($p(^CT("CPT",CpTypeDr),del,4)="DOCTOR")||($p(^CT("CPT",CpTypeDr),del,4)="NURSE") d 
	..s i=1
	..for  s CtLoc=$p(CtLocCode,"/",i) q:CtLoc=""  d
	...s i=i+1
	...s CtLocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtLoc),""))
	...if CtLocId="" s RetStr=..RetErrorValue(RetStr,"取人员科室指针出错RB_Resource:"_CtLoc) q
	...s CareProvId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	...IF CareProvId="" s RetStr=..RetErrorValue(RetStr,"取医护人员指针出错222:"_Code) q
	...q:$d(^RB("RES",0,"CTPCP",CareProvId,CtLocId))
	...if ChangeType'="Test" d
	....k PLIST
	....s PLIST(3)=CtLocId,PLIST(4)=CareProvId,PLIST(7)=Code,PLIST(8)=Desc,PLIST(11)=-1,PLIST(16)=999
	....s PLIST(19)="Care Provider",PLIST(20)="Y",PLIST(21)="Y"
	....&sql(INSERT INTO SQLUser.RB_Resource VALUES :PLIST())
	....i $g(SQLCODE)'=0 s RetStr=..RetErrorValue(RetStr,"RB_Resource -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	....q:$g(SQLCODE)'=0
	....if $g(%ROWID)'="" S rid=%ROWID
	....ELSE  Q
	....q:$g(SessType)=""
	....q:'$d(^RBC("SESS",0,"Desc",$$ALPHAUP^SSUTIL4(SessType)))  
	....s SessTypeDr=$o(^RBC("SESS",0,"Desc",$$ALPHAUP^SSUTIL4(SessType),""))
	....if $g(SessTypeDr)="" s RetStr=..RetErrorValue(RetStr,"取出诊级别出错:"_Code) q
	....s ClinicGroupDr=$o(^RBC("CLGRP",0,"Desc",$$ALPHAUP^SSUTIL4(ClinicGroup),""))
	....if $g(ClinicGroupDr)="" s RetStr=..RetErrorValue(RetStr,"取亚专业出错:"_Code) q
	....S ^RB("RES",rid,"DHC")=SessTypeDr_"^"_ClinicGroupDr
	
	//用户表
    s Group=$p(RowStr,del,10) 
	q:(($d(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(Code))))&('$d(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(Desc))))) ..RetErrorValue(RetStr,"用户代码已经存在"_Code)
	q:(($d(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(Desc))))&('$d(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(Code))))) ..RetErrorValue(RetStr,"用户名称已经存在"_Desc)
	if Group'="" d
	.IF (CpType'="") d
	..SET CpTypeDr=$O(^CT("CPT",0,"Desc",$$ALPHAUP^SSUTIL4(CpType),"")) 
	..IF CpTypeDr="" s RetStr=..RetErrorValue(RetStr,"医护人员类型指针出错"_CpType)
	..s CareProvId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	.IF (($g(CareProvId)="")&( $g(CpTypeDr)'="")) s RetStr=..RetErrorValue(RetStr,"取医护人员指针出错333:"_Code) q 
	.s i=1,FirstLoc=1
	.if ($d(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(Desc)))) s FirstLoc=2
	.if 
	.for  s CtLoc=$p(CtLocCode,"/",i) q:CtLoc=""  d
	..s CtLocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtLoc),""))
	..if CtLocId="" s RetStr=..RetErrorValue(RetStr,"取人员科室指针出错SS_USER:"_CtLoc),i=i+1 q
	..s UserGroup=$p(Group,"/",i)
	..s i=i+1
	..if $g(UserGroup)="" s RetStr=..RetErrorValue(RetStr,"取科室对应安全组出错:"_CtLoc) q
	..s UserGroupDr="",GroupId=0
	..f  s GroupId=$o(^SSU("SSGRP",GroupId)) q:GroupId=""  d
	...s GroupName=$p(^SSU("SSGRP",GroupId),"^",1)
	...if GroupName=UserGroup s UserGroupDr=GroupId q
	..if UserGroupDr="" s RetStr=..RetErrorValue(RetStr,"取安全组指针出错SS_User:"_UserGroup) q
	..s LanguageId=$o(^SS("LAN",0,"Code","CH",""))
	..if (ChangeType'="Test") d
	...k PLIST
	...if (FirstLoc=1) d
	....s PLIST(2)=Code,PLIST(3)=Desc,PLIST(7)=CtLocId,PLIST(13)=UserGroupDr,PLIST(18)=$g(CareProvId)
	....s PLIST(9)="Y",PLIST(17)=LanguageId,PLIST(19)="U&dDF1,""7k7k",PLIST(23)="Y",PLIST(103)=$h-1 
	....s PLIST(72)="N",PLIST(4)="UUUrwd?]?&&&"  //PLIST(4)="U&dDF1,""7k7k"
	....i $g(CareProvId)'="" s PLIST(19)=Code
	....&sql(INSERT INTO SQLUser.SS_User VALUES :PLIST())
	....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"SS_User -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	....if '$g(SQLCODE) d
	.....Q:$g(%ROWID)=""
	.....Q:$D(^SSU("SSUSR",$g(%ROWID),"PASS",0,"Password"))
	.....k PLIST
	.....S PLIST(0)=$g(%ROWID),PLIST(3)="UUUrwd?]?&&&"  //--PLIST(3)="U&dDF1,""7k7k"
	.....&sql(INSERT INTO SQLUser.SS_UserPassword VALUES :PLIST())
	...else  d
	....S UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(Code),""))
	....if UserId="" s RetStr=..RetErrorValue(RetStr,"取用户信息出错:"_Code) q
	....s UserIdOther="",CtlocIdOther="",GroupIdOther="",CircleFlag=1
	....f  s UserIdOther=$o(^SSU("SSUSR",UserId,"OTHLL",UserIdOther)) q:((UserIdOther="")!(CircleFlag'=1))  d
	.....s CtlocIdOther=$p(^SSU("SSUSR",UserId,"OTHLL",UserIdOther),del,1)
	.....s GroupIdOther=$p(^SSU("SSUSR",UserId,"OTHLL",UserIdOther),del,2)
	.....if ((CtlocIdOther=CtLocId)&(GroupIdOther=UserGroupDr)) s CircleFlag=0
	....q:CircleFlag'=1
	....s PLIST(0)=UserId,PLIST(3)=CtLocId,PLIST(4)=UserGroupDr
	....&sql(INSERT INTO SQLUser.SS_UserOtherLogonLoc VALUES :PLIST())
	...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"RB_Resource -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..s FirstLoc=FirstLoc+1
	q:RetStr="" "Ok"
	q RetStr
}

/// 科室号别导入
ClassMethod CareMark(ChangeType As %String = "", RowStr As %String = "") As %String
{
	;if ChangeType="Clear" K ^CTPCP,^RB("RES"),^RBC("SER")
	;q:ChangeType="Clear" "数据已清:医护人员和资源"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	s CtLocCode=$p(RowStr,del,1),CtLocDesc=$p(RowStr,del,2)
	SET Code=$P(RowStr,del,3),Desc=$P(RowStr,del,4),CpType=$P(RowStr,del,5),Abbr=$P(RowStr,del,11),CTSpecDesc=$P(RowStr,del,7)
	s CPPCPUNITcode=$P(RowStr,del,14),HICApproved=$P(RowStr,del,15)
	q:Code="" ..RetErrorValue(RetStr,"代码为空")
	q:Desc="" ..RetErrorValue(RetStr,"名称为空")
	if (($D(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Code))))&('$D(^CTPCP(0,"Decs",$$ALPHAUP^SSUTIL4(Desc))))) s RetStr=..RetErrorValue(RetStr,"医护人员代码已经存在"_Code)
	if (($D(^CTPCP(0,"Decs",$$ALPHAUP^SSUTIL4(Desc))))&('$D(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Code))))) s RetStr=..RetErrorValue(RetStr,"医护人员名称已经存在"_Desc)
	q:CtLocDesc="" ..RetErrorValue(RetStr,"医护人员科室为空")
	s CpTypeDr=""
	if ('$D(^CTPCP(0,"Decs",$$ALPHAUP^SSUTIL4(Desc))))&('$D(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Code))))&(CpType'="") d
	.SET Label=Code,SMC=Code,Speciality=$P(RowStr,del,8)
	.s Title=$p(RowStr,del,6)
	.IF CpType="" s RetStr=..RetErrorValue(RetStr,"医护人员类型为空") q
	.SET CpTypeDr=$O(^CT("CPT",0,"Desc",$$ALPHAUP^SSUTIL4(CpType),"")) 
	.IF CpTypeDr="" s RetStr=..RetErrorValue(RetStr,"医护人员类型指针出错"_CpType) q
	.s CtLoc=$p(CtLocCode,"/"),CtLocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtLoc),""))
	.if CtLocId="" s RetStr=..RetErrorValue(RetStr,"取人员科室指针出错CT_CareProv:"_CtLoc)
	.s CTSpecdr=""
	.if $g(CTSpecDesc)'="" d
	..s CTSpecdr=$o(^CT("SPC",0,"Desc",$$ALPHAUP^SSUTIL4(CTSpecDesc),""))
	..if CTSpecdr="" s RetStr=..RetErrorValue(RetStr,"取人员专长指针出错CT_Spec_:"_CTSpecDesc)
	.if ChangeType'="Test" d
	..if ('$D(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Code)))&('$D(^CTPCP(0,"Decs",$$ALPHAUP^SSUTIL4(Desc))))) d
	...K PLIST
	...SET PLIST(2)=Code,PLIST(3)=Desc,PLIST(4)=$g(Label),PLIST(7)=$g(CpTypeDr),PLIST(36)=$g(Speciality),PLIST(38)=+$h,PLIST(49)=$g(Title),PLIST(73)=$g(Abbr),PLIST(16)=$g(CTSpecdr),PLIST(12)=$g(CPPCPUNITcode)
	...&SQL(INSERT INTO SQLUser.CT_CareProv VALUES :PLIST())
	...if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"CT_CareProv -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	...if $g(%ROWID)'=""  d
	....S CTPRowid=%ROWID
	....k PLIST
	....s PLIST(0)=%ROWID,PLIST(3)=Desc
	....&SQL(INSERT INTO SQLUser.CT_CareProvKeywords VALUES :PLIST())
	....if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"CT_CareProvKeywords -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	....&SQL(update SQLUser.CT_CareProv set CTPCP_HICApproved=:HICApproved where CTPCP_ROWID=:CTPRowid)
	....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"CT_CareProv:CTPCP_HICApproved -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	.s CareProvId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	.IF CareProvId="" s RetStr=..RetErrorValue(RetStr,"取医护人员指针出错111:"_Code) q
	.S Services=$P(RowStr,del,9)
	.q:Services=""
	.s CircleNum=$l(Services,"/"),i=0
	.f  s i=i+1 q:(i>CircleNum)  d
	..s Service=$P(Services,"/",i)
	..q:$g(Service)=""
	..s ArcimId1=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(Service),""))
	..s:ArcimId1="" RetStr=..RetErrorValue(RetStr,"取医嘱指针出错:"_Code)
	..q:ArcimId1=""
	..s ArcimId2=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(Service),ArcimId1,""))
	..S ArcimDesc=$p(^ARCIM(ArcimId1,ArcimId2,1),del,2)
	..s Service=$p(^ARCIM(ArcimId1,ArcimId2,8),del,7)
	..s:Service="" RetStr=..RetErrorValue(RetStr,"取医嘱服务组指针出错:"_Code)
	..q:Service=""
	..s ServiceId=0
	..s CircleFlag=1
	..f  s ServiceId=$o(^RBC("SER",0,"CTCP",CareProvId,ServiceId)) q:((ServiceId="")!(CircleFlag=0))  d
	...s ArcimId=$p(^RBC("SER",ServiceId),del,1)
	...s:(ArcimId=(ArcimId1_"||"_ArcimId2)) CircleFlag=0
	..if CircleFlag=0 q
	..if ChangeType'="Test" d
	...k PLIST
	...S PLIST(2)=ArcimId1_"||"_ArcimId2,PLIST(4)=0,PLIST(5)=CareProvId,PLIST(7)=$g(ArcimDesc),PLIST(10)=Service,PLIST(11)="Y",PLIST(13)=$H-1
	...&SQL(INSERT INTO SQLUser.RBC_Services VALUES :PLIST())
	...if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RBC_Services -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	
	//医护人员所在科室
	IF (CpType'="") d
	.s SessTypeDr="",ClinicGroupDr="",SessType=$P(RowStr,del,12),ClinicGroup=$P(RowStr,del,13)
	.SET CpTypeDr=$O(^CT("CPT",0,"Desc",$$ALPHAUP^SSUTIL4(CpType),"")) 
	.IF CpTypeDr="" s RetStr=..RetErrorValue(RetStr,"医护人员类型指针出错"_CpType) q
	.if ($p(^CT("CPT",CpTypeDr),del,4)="DOCTOR")||($p(^CT("CPT",CpTypeDr),del,4)="NURSE") d 
	..s i=1
	..for  s CtLoc=$p(CtLocCode,"/",i) q:CtLoc=""  d
	...s i=i+1
	...s CtLocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtLoc),""))
	...if CtLocId="" s RetStr=..RetErrorValue(RetStr,"取人员科室指针出错RB_Resource:"_CtLoc) q
	...s CareProvId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	...IF CareProvId="" s RetStr=..RetErrorValue(RetStr,"取医护人员指针出错222:"_Code) q
	...q:$d(^RB("RES",0,"CTPCP",CareProvId,CtLocId))
	...if ChangeType'="Test" d
	....k PLIST
	....s PLIST(3)=CtLocId,PLIST(4)=CareProvId,PLIST(7)=Code,PLIST(8)=Desc,PLIST(11)=-1,PLIST(16)=999
	....s PLIST(19)="Care Provider",PLIST(20)="Y",PLIST(21)="Y"
	....&sql(INSERT INTO SQLUser.RB_Resource VALUES :PLIST())
	....i $g(SQLCODE)'=0 s RetStr=..RetErrorValue(RetStr,"RB_Resource -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	....q:$g(SQLCODE)'=0
	....if $g(%ROWID)'="" S rid=%ROWID
	....ELSE  Q
	....q:$g(SessType)=""
	....q:'$d(^RBC("SESS",0,"Desc",$$ALPHAUP^SSUTIL4(SessType))) 
	....s ClinicGroupDr="",SessTypeDr=""
	....s SessTypeDr=$o(^RBC("SESS",0,"Desc",$$ALPHAUP^SSUTIL4(SessType),""))
	....if $g(SessTypeDr)="" s RetStr=..RetErrorValue(RetStr,"取出诊级别出错:"_Code) q
	....if ClinicGroup'=""  d 
	.....s ClinicGroupDr=$o(^RBC("CLGRP",0,"Desc",$$ALPHAUP^SSUTIL4(ClinicGroup),""))
	.....if $g(ClinicGroupDr)="" s RetStr=..RetErrorValue(RetStr,"取亚专业出错:"_Code) q
	....S ^RB("RES",rid,"DHC")=SessTypeDr_"^"_ClinicGroupDr
	
	q:RetStr="" "Ok"
	q RetStr
}

/// 医护类型
ClassMethod CareType(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" K ^CT("CPT")
	q:ChangeType="Clear" "数据已清:科室和病区"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1),Desc=$P(RowStr,del,2),DocType=$P(RowStr,del,3)
	q:Code="" ..RetErrorValue(RetStr,"代码为空")
	q:Desc="" ..RetErrorValue(RetStr,"人员类型为空")
	q:$d(^CT("CPT",0,"Code",$$ALPHAUP^SSUTIL4(Code))) ..RetErrorValue(RetStr,"人员类型代码已经存在"_Code)
	q:$d(^CT("CPT",0,"Desc",$$ALPHAUP^SSUTIL4(Desc))) ..RetErrorValue(RetStr,"人员类型已经存在"_Desc)
	if ChangeType'="Test" d
	.K PLIST
	.SET PLIST(2)=Code,PLIST(3)=Desc,PLIST(5)=DocType,PLIST(6)=$H-2
	.&SQL(INSERT INTO SQLUSER.CT_CARPRVTP VALUES :PLIST())
	.s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"CT_CARPRVTP -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

/// 医嘱记费点设置
ClassMethod BillCondition(ChangeType As %String = "", RowStr As %String = "") As %String
{
	s RetStr="",del="^"
	s OrdCatSub=$p(RowStr,del,1),BillCondition=$p(RowStr,del,2)
	q:$g(OrdCatSub)="" "医嘱子类为空"
	q:$g(BillCondition)="" "计费类型为空"
	s OrdCatSubId=0
	s OrdCatSubId=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(OrdCatSub),OrdCatSubId))
	q:$g(OrdCatSubId)="" "取医嘱子类指针出错"_OrdCatSub
	if BillCondition="开医嘱" s BillConditionDr="OD"
	if BillCondition="执行" s BillConditionDr="OE"
	if BillCondition="护士执行" s BillConditionDr="NE"
	if BillCondition="发药" s BillConditionDr="CR"
	q:((BillConditionDr'="OD")&(BillConditionDr'="OE")&(BillConditionDr'="NE")&(BillConditionDr'="CR")) "计费类型出错"
	IF '$D(^DHCTarC("BC",0,OrdCatSubId)) D
	.ZN "DHC-DATA"
	.S Para=OrdCatSubId_del_BillConditionDr
	.S Ret=$$InsertBillConDition^DHCFBILLCONDITION(Para)
	.zn "dhc-app"
	.if Ret'="Ok" s RetStr=..RetErrorValue(RetStr,Ret)
	q RetStr
}

ClassMethod ChangeData(ChangeType As %String = "", RowStr As %String = "") As %String
{
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	/*SET Code=$P(RowStr,del,1),Addr=$P(RowStr,del,2)
	q:Code="" "科室代码为空"
	q:Addr="" "地点为空"
	q:'$d(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Code))) "取科室指针出错"
	s rid=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	q:rid="" "取科室指针出错"
	if $d(^CTLOC(rid,"ADDR",0)) s ^CTLOC(rid,"ADDR",1)=Addr
	if '$d(^CTLOC(rid,"ADDR",0)) s ^CTLOC(rid,"ADDR",0)=1,^CTLOC(rid,"ADDR",1)=Addr
	*/
	/*s Floor=$p(Floor,",",2)
	if (+Floor'=0) s Floor=Floor_"诊室"
	if (Code'="")  d
	.q:$g(Floor)=""
	.i $d(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Code)))  D
	..s rid=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	..;&SQL(Update SQLUSER.Ct_Loc set CTLOC_ContactName=:PinYin where CTLOC_ROWID=:rid)
 ..;i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"Ct_Loc -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ..q:($p(^CTLOC(rid),del,16))=""
 ..s FloorTmp=$p(^CTLOC(rid),del,16)
 ..s $p(FloorTmp,",",3)=Floor
 ..s $p(^CTLOC(rid),del,16)=FloorTmp
 ..s ^CTLOC(rid,"ADDR",0)=1,^CTLOC(rid,"ADDR",1)=Addr
 ;q FloorTmp_"^"_Addr
 */
 SET TarCode=$P(RowStr,del,1),TarDesc=$P(RowStr,del,2),OrdCode=$P(RowStr,del,4),OrdDesc=$P(RowStr,del,5)
	if ((OrdCode="") & (OrdDesc="")) d
	else  d
	.if OrdCode="" s RetStr=..RetErrorValue(RetStr,"医嘱代码为空:")
 .if OrdDesc="" s RetStr=..RetErrorValue(RetStr,"医嘱名称为空:")
 if ((TarCode="") & (TarDesc="")) d
	else  d
	.if TarCode="" s RetStr=..RetErrorValue(RetStr,"收费项代码为空:")
 .if TarDesc="" s RetStr=..RetErrorValue(RetStr,"收费项名称为空:")
 if (($g(OrdDesc)'="")&($g(OrdCode)'="")) d
 .s:($d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc)))&('$d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))))) RetStr=..RetErrorValue(RetStr,"医嘱项名称已经存在:"_OrdDesc)
 .s:($d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode)))&('$d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(OrdDesc))))) RetStr=..RetErrorValue(RetStr,"医嘱项代码已经存在:"_OrdCode)
 if (($g(TarCode)'="")&($g(TarDesc)'="")) d
 .s:($D(^DHCTARI(0,"Code",TarCode))&('$D(^DHCTARI(0,"Desc",TarDesc)))) RetStr=..RetErrorValue(RetStr,"收费项代码已经存在:"_TarCode)
 .s:($D(^DHCTARI(0,"Desc",TarDesc))&('$D(^DHCTARI(0,"Code",TarCode)))) RetStr=..RetErrorValue(RetStr,"收费项名称已经存在:"_TarDesc)
 s qty=$P(RowStr,del,6)
 if $g(qty)="" s qty=1
 q:qty=1 RetStr
 //医嘱与收费项目对照
	q:(($g(OrdCode)="")&($g(OrdDesc)="")) RetStr
	q:(($g(TarCode)="")&($g(TarDesc)="")) RetStr
	q:(($g(OrdCode)="")!($g(OrdDesc)="")) ..RetErrorValue(RetStr,"医嘱项目名称或代码为空")
	q:(($g(TarCode)="")!($g(TarDesc)="")) ..RetErrorValue(RetStr,"收费项目名称或代码为空")
	if (($g(OrdCode)'="")&($g(OrdDesc)'="")&($g(TarCode)'="")!($g(TarDesc)'="")) d
	.if (($d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode))))&($d(^DHCTARI(0,"Code",TarCode)))) d
	..SET ArcimId1=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode),""))
	..if ArcimId1="" s RetStr=..RetErrorValue(RetStr,"对照时医嘱id出错"_OrdCode)
	..q:ArcimId1=""
	..SET ArcimId=ArcimId1_"||"_$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(OrdCode),ArcimId1,""))
	..SET TarId=$O(^DHCTARI(0,"Code",TarCode,""))
	..if TarId="" s RetStr=..RetErrorValue(RetStr,"对照时收费项目id出错"_TarCode)
 ..q:TarId="" 
 ..q:'$d(^DHCOLT(0,"ARTTA",ArcimId,TarId))
 ..s StDate=$o(^DHCOLT(0,"ARTTA",ArcimId,TarId,""),-1)
 ..q:$g(StDate)=""
 ..s OltId=$o(^DHCOLT(0,"ARTTA",ArcimId,TarId,StDate,0))
 ..q:($g(OltId)="")
 ..s TmpQty=$p(^DHCOLT(OltId),del,3)
 ..q:($g(TmpQty)'=1)
 ..s ^fhq(OltId)=TarCode
 ..if ChangeType'="Test" d
 ...s ^fhq(OltId,1)=TarCode
 ...&SQL(update SQLUser.DHC_ORDERLINKTAR set OLT_Qty=:qty where OLT_RowId=:OltId)
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_ORDERLINKTAR -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ...Q:$g(SQLCODE)

 q:RetStr="" "Ok"
	q RetStr
}

ClassMethod ClearGlobal(UpType As %String) As %String
{
	q:UpType=""
	k ^TMPFHQ(UpType)
	Q ""
}

/// 科室组
ClassMethod CtGroup(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" K ^RBC("DEP")
	q:ChangeType="Clear" "数据已清"_"^RBC("_"DEP"_")"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1),Desc=$P(RowStr,del,2)
	
	Q:Code="" RetStr="科室部门组为空"
	if '$d(^RBC("DEP",0,"Code",$$ALPHAUP^SSUTIL4(Code))) d
	.if ChangeType'="Test" d
	..K PLIST
	..SET PLIST(2)=Code,PLIST(3)=Desc,PLIST(4)=$h-2
 ..&SQL(INSERT INTO SQLUSER.RBC_DEPARTMENTGROUP VALUES :PLIST())
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"RBC_DEPARTMENTGROUP -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

/// 科室
/// 科室
ClassMethod CtLoc(ChangeType As %String = "", RowStr As %String = "") As %String
{
	
	
	Set CurrentNS=$ZNSPACE
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace //
	if ChangeType="Clear" K ^CTLOC,^PAWARD,^PAC("ADMLOC"),^PAC("PACWD")
	q:ChangeType="Clear" "数据已清:科室和病区"
	s del="^"
	SET RowStr=$tr(RowStr," ","")
	s RetStr=""
	SET Code=$P(RowStr,del,1),DESC=$P(RowStr,del,2),TYPE=$$ALPHAUP^SSUTIL4($P(RowStr,del,3))
	s GROUP=$P(RowStr,del,4),DEPTCAT=$$ALPHAUP^SSUTIL4($P(RowStr,del,5))
	s ORDEXEC=$P(RowStr,del,7),adress=$P(RowStr,del,8),phone=$P(RowStr,del,9),MR=$P(RowStr,del,10)
	s Abbre=$P(RowStr,del,11),ext=$P(RowStr,del,12)
	s HospitalDesc=$P(RowStr,del,13),frdate=$P(RowStr,del,14),INDEX=$P(RowStr,del,16),Floor=$P(RowStr,del,17)
	s todate=""
	s ^TempCTL(0)=RowStr
	if $P(RowStr,del,15)'="NULL" s todate=$P(RowStr,del,15)
	i $g(Floor)'=""  s Floor=Floor_adress
	s:TYPE="" TYPE="OTHER"
	IF ORDEXEC="" SET ORDEXEC="Y"
	IF INDEX="" SET INDEX="Y"
	IF MR="" SET MR="Y"
	Q:Code="" RetStr="代码为空"
	s:$D(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Code))) RetStr=..RetErrorValue(RetStr,"代码已经存在:"_Code)
	Q:DESC="" "名称为空"
	s:$D(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(DESC))) RetStr=..RetErrorValue(RetStr,"名称已经存在:"_DESC)
	s:TYPE="" RetStr=..RetErrorValue(RetStr,"科室类型为空")
	if (('$D(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Code))))&('$d(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(DESC))))) d
	.;s TYPE="OPERATION"
	.SET TYPE=$select(TYPE["WARD":"W",TYPE["EXECUTE":"E",TYPE["MEDICAL":"MR",TYPE["OPERATION":"OP",TYPE["CASHIER":"C",TYPE["OTHER":"O",TYPE["DISPENSING":"D",TYPE["CLINIC":"CL",TYPE["ROOM":"OR",TYPE["EMERGENCY":"EM",1:"")
	.   IF TYPE="W" SET WARDFLAG="Y"
	.   ELSE  SET WARDFLAG=""
	.s GROUPDR=""
	.   SET:GROUP'="" GROUPDR=$O(^RBC("DEP",0,"Desc",$$ALPHAUP^SSUTIL4(GROUP),""))
	.   IF GROUPDR="" d
	.   .s:RetStr'="" RetStr="科室部门组为空"_"@"_RetStr_Code_DESC
	.   .s:RetStr="" RetStr="科室部门组为空"_Code_DESC
	.s HospitalDR=""
	.i HospitalDesc'="" d
	..s HospitalDR=$O(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(HospitalDesc),""))
 	.if ChangeType'="Test" d
 	..s DESC=Abbre_"-"_DESC
 	..S Para=Code_del_DESC_del_$g(WARDFLAG)_del_$g(TYPE)_del_$g(GROUPDR)_del_$g(ORDEXEC)_del_$g(INDEX)_del_$g(MR)_del_$g(adress)_del_$g(phone)_del_$g(ext)_del_$g(Abbre)_del_$g(Floor)_del_$g(HospitalDR)_del_$g(frdate)_del_$g(todate)
 	..s MRetStr=""
 	..ZN MEDDATA
 	..s MRetStr=$$CtLoc^DHCFHQIMP(Para)
 	..IF ((MRetStr="") ! (MRetStr="OK")) & ($g(TYPE)="D") d 
 	..ZN CurrentNS
 	..s RetStr=..RetErrorValue(RetStr,MRetStr)
 	 SET DEPTCAT=$S(DEPTCAT["OUTP":"O",DEPTCAT["BOTH":"B",DEPTCAT["INP":"I",DEPTCAT["EMER":"E",DEPTCAT["PROM":"P",1:"")
	 if DEPTCAT'="" d
	 .SET CodeDR=$O(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	 .if CodeDR="" s RetStr=..RetErrorValue("科室指针出错PAC_ADMTYPELOCATION:"_Code,RetStr) q
	 .if ChangeType'="Test" d
	 ..if DEPTCAT="B" d   //为B时是门诊住院为一个科室
	 ...if '$d(^PAC("ADMLOC",0,"AdmType","O",CodeDR)) d
	 ....s Para=CodeDR_del_"O"
	 ....ZN MEDDATA
	 ....s MRetStr=$$AdmLoc^DHCFHQIMP(Para)
	 ....ZN CurrentNS
	 ....s RetStr=..RetErrorValue(RetStr,MRetStr)
	 ...if '$d(^PAC("ADMLOC",0,"AdmType","I",CodeDR)) d
	 ....s Para=CodeDR_del_"I"
	 ....ZN MEDDATA
	 ....s MRetStr=$$AdmLoc^DHCFHQIMP(Para)
	 ....ZN CurrentNS
	 ....s RetStr=..RetErrorValue(RetStr,MRetStr)
	 ..e  d
	 ...if '$d(^PAC("ADMLOC",0,"AdmType","O",CodeDR)) d
	 ....s Para=CodeDR_del_DEPTCAT
	 ....ZN MEDDATA
	 ....s MRetStr=$$AdmLoc^DHCFHQIMP(Para)
	 ....ZN CurrentNS
	 ....s RetStr=..RetErrorValue(RetStr,MRetStr)
	 q:RetStr="" "Ok"
	 q RetStr
}

ClassMethod CtLink(ChangeType As %String = "", RowStr As %String = "") As %String
{
	Set CurrentNS=$ZNSPACE
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace //
	s del="^"
	SET RowStr=$tr(RowStr," ","")
	s RetStr=""
	SET Code=$P(RowStr,del,1),DESC=$P(RowStr,del,2),TYPE=$$ALPHAUP^SSUTIL4($P(RowStr,del,3))
	
	//科室与科室LINK 
	 SET TYPE=$P(RowStr,del,3),DEPTLIST=$P(RowStr,del,6)
	 if TYPE'="" D
	 .s CtLocId=$O(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	 .q:CtLocId=""
	 .q:$g(DEPTLIST)=""
	 .Q:(($p(^CTLOC(CtLocId),del,13)'="W")&($p(^CTLOC(CtLocId),del,13)'="EM")&($p(^CTLOC(CtLocId),del,13)'="D"))
	 .SET I=1
	 .FOR  SET DEPT=$P(DEPTLIST,"/",I) Q:DEPT=""  D
	 ..SET I=I+1
	 ..SET DeptId=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(DEPT),""))
	 ..IF DeptId="" s RetStr=..RetErrorValue(RetStr,"取科室指针出错PAC_WardBedAllocation:"_DEPT) Q
	 ..if ChangeType'="Test" d
	 ...s Para=$g(CtLocId)_del_DeptId
	 ...q:$g(CtLocId)="" 
	 ...q:$g(DeptId)="" 
	 ...K PLIST
	 ...if '$d(^CTLOC(CtLocId,"LINK",0,"Loc",DeptId)) d
	 ....s PLIST(0)=CtLocId,PLIST(3)=DeptId
	 ....&SQL(INSERT INTO SQLUser.Ct_LocLinkLocation VALUES PLIST())
	 ....s:$g(SQLCODE) RetStr="Ct_LocLinkLocation"_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg) 
	 ...if '$d(^CTLOC(DeptId,"LINK",0,"Loc",CtLocId)) d
	 ....s PLIST(3)=CtLocId,PLIST(0)=DeptId
	 ....&SQL(INSERT INTO SQLUser.Ct_LocLinkLocation VALUES PLIST())
	 ....s:$g(SQLCODE) RetStr="Ct_LocLinkLocation"_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg) 

	q $g(RetStr)
}

/// 专长
ClassMethod CtSpec(ChangeType As %String = "", RowStr As %String = "") As %String
{
	; ----*1*----*2-----
	;    CODE    DESC
	IF ChangeType="Clear" K ^CT("SPC")
	q:ChangeType="Clear" "数据已清:专长"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1),Desc=$P(RowStr,del,2)
	if $g(^CT("SPC",0))="" s Code=1
	if $g(^CT("SPC",0))'="" s Code=$g(^CT("SPC",0))+1
	Q:Code="" "编码为空"
	Q:$D(^CT("SPC",0,"Desc",$$ALPHAUP^SSUTIL4(Desc))) "名称已经存在"_Desc
	if ChangeType'="Test" d
	.K PLIST
	.SET PLIST(2)=Code,PLIST(3)=$$ALPHAUP^SSUTIL4(Desc),PLIST(5)=+$H
	.&SQL(INSERT INTO SQLUSER.CT_Spec VALUES :PLIST())
	.if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"CT_Spec -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

/// 科室亚专业
ClassMethod CtSpecialty(ChangeType As %String = "", RowStr As %String = "") As %String
{
 //1		2			3			4		5
 //科室代码	科室名称	亚专业归类	亚专业	亚专业助记码

	if ChangeType="Clear" K ^RBC("CLGRP"),^DHCLocSubject
	q:ChangeType="Clear" "数据已清"_"^RBC("_"CLGRP"_")^DHCLocSubject"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET CtCode=$P(RowStr,del,1),Code=$P(RowStr,del,3),Desc=$P(RowStr,del,4),Alias=$P(RowStr,del,5)
	s ^tempspe(0)=RowStr
	Q:Code="" RetStr="专业代码为空"
	Q:Desc="" RetStr="专业名称为空"
	if ('$d(^RBC("CLGRP",0,"Desc",$$ALPHAUP^SSUTIL4(Desc)))) d
	.;if $d(^RBC("CLGRP",0,"Code",$$ALPHAUP^SSUTIL4(Code))) s RetStr=..RetErrorValue(RetStr,"编码已经存在"_Code) q
	.if $d(^RBC("CLGRP",0,"Desc",$$ALPHAUP^SSUTIL4(Desc))) s RetStr=..RetErrorValue(RetStr,"名称已经存在"_Desc) q
	.if ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=Code,PLIST(3)=Desc,PLIST(4)=$H-2
	..&sql(INSERT INTO SQLUSER.RBC_ClinicGroup VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RBC_ClinicGroup -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	if $g(CtCode)'="" d
	.s CtLocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtCode),0))
	.s:$g(CtLocId)="" RetStr=..RetErrorValue(RetStr,"取科室指针出错"_CtCode)
	.q:$g(CtLocId)=""
	.s RbClinicGroupId=$o(^RBC("CLGRP",0,"Desc",$$ALPHAUP^SSUTIL4(Desc),0))
	.s:$g(RbClinicGroupId)="" RetStr=..RetErrorValue(RetStr,"取亚专业指针出错"_Code)
	.q:$g(RbClinicGroupId)=""
	.q:$d(^DHCLocSubject(0,"Loc",CtLocId,"Spec",RbClinicGroupId))
	.if ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=CtLocId,PLIST(3)=RbClinicGroupId
	..&sql(INSERT INTO SQLUSER.DHC_LocSpec VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RBC_ClinicGroup -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
		
	//DHC_LocSpec
}

/// 职称/职务
ClassMethod CtTitle(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" K ^CT("TTL")
	q:ChangeType="Clear" "数据已清"_"^CT("_"TTL"_")"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1),Desc=$P(RowStr,del,2)
	Q:Code="" RetStr="职务名称为空"
	i $d(^CT("TTL",0,"Code",$$ALPHAUP^SSUTIL4(Code))) s RetStr=..RetErrorValue(RetStr,"编码已经存在"_Code)
	if $d(^CT("TTL",0,"Desc",$$ALPHAUP^SSUTIL4(Desc))) s RetStr=..RetErrorValue(RetStr,"名称已经存在"_Desc)

	if '$d(^CT("TTL",0,"Desc",$$ALPHAUP^SSUTIL4(Desc)))&'$d(^CT("TTL",0,"Code",$$ALPHAUP^SSUTIL4(Code))) d
	.if ChangeType'="Test" d
	..K PLIST
	..SET PLIST(2)=Code,PLIST(3)=Desc,PLIST(4)=$h-2
    ..&SQL(INSERT INTO SQLUSER.CT_Title VALUES :PLIST())
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"CT_Title -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

/// 单位
ClassMethod CtUom(ChangeType As %String = "", RowStr As %String = "") As %String
{
	; Exel Format:
	;    ----1--------2---------3--------
	;    fromuom^   touom ^  fac      
	;      PLIST(2)^ PLIST(3)^ PLIST(5)
	if ChangeType="Clear" K ^CT("UOM"),^CT("CTCF")
	q:ChangeType="Clear" "数据已清"_"^CT("_"UOM"_")^CT("_"CTCF"_")"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET FromUom=$p(RowStr,del,1),DESC=FromUom,FDESC=FromUom
	s ToUom=$p(RowStr,del,3),Fac=$p(RowStr,del,2)
	q:FromUom="" ..RetErrorValue(RetStr,"单位代码为空:")
	q:ToUom="" ..RetErrorValue(RetStr,"单位代码为空:")
	s:$g(Fac)="" Fac=1
	;q:((Fac=1)&(FromUom'=ToUom)) ..RetErrorValue(RetStr,"转换系数为1,但两个单位不一样:"_FromUom_"-"_ToUom)
	i '$d(^CT("UOM",0,"Code",$$UPPER^SSUTIL4(FromUom))) d
	.if ChangeType'="Test" d 
	.. k PLIST       
	.. s PLIST(2)=FromUom,PLIST(3)=FromUom,PLIST(5)=FromUom
	.. &sql(INSERT INTO SQLUSER.CT_UOM VALUES :PLIST())
	.. i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"CT_UOM -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	i '$d(^CT("UOM",0,"Code",$$UPPER^SSUTIL4(ToUom))) d
	.if ChangeType'="Test" d 
	.. k PLIST       
	.. s PLIST(2)=ToUom,PLIST(3)=ToUom,PLIST(5)=ToUom
	.. &sql(INSERT INTO SQLUSER.CT_UOM VALUES :PLIST())
	.. i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"CT_UOM -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	
	s FUOMDR=$o(^CT("UOM",0,"Code",$$UPPER^SSUTIL4(FromUom),""))
	q:FUOMDR="" ..RetErrorValue(RetStr,"转换单位出错:"_FromUom)

	s TUOMDR=$o(^CT("UOM",0,"Code",$$UPPER^SSUTIL4(ToUom),""))
	q:TUOMDR="" ..RetErrorValue(RetStr,"转换单位出错:"_ToUom)
	if '$D(^CT("CTCF",0,"UOM",FUOMDR,TUOMDR)) d
	.if ChangeType'="Test" d
	..k PLIST
	..SET PLIST(2)=FUOMDR,PLIST(3)=TUOMDR,PLIST(4)=Fac, PLIST(6)="Y"
	..&sql(INSERT INTO SQLUSER.CT_ConFac VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"CT_ConFac -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

/// 药品数据
/// 药品数据
ClassMethod DrugData(ChangeType As %String = "", RowStr As %String = "") As %String
{
	
	if ChangeType="Clear" d
	.K ^PHCD,^INCI,^INCALIAS,^mdata("INCALIAS"),^INASP,^mdata("INADJSALEPRICE")
	.k ^ARCIM,^ARC("ALIAS"),^DHCTARAL,^DHCOLT,^DHCTARI
	.k ^ARCIM,^ARC("ALIAS"),^DHCTARAL,^DHCOLT,^DHCTARI
	.K ^ARCIM,^ARC("ALIAS"),^ARC("KEYW"),^DHCITMINFO
	.k ^DHCTARI,^DHCTARIi,^mdata("DHCTARITEM"),^DHCTARAL,^mdata("DHCTARITEMALIAS")
	.k ^DHCOLT,^mdata("DHCORDERLINKTAR"),^DHCTARF,^mdata("DHCTARFACTOR")
	q:ChangeType="Clear" "数据已清:药学项"
	s del="^",RetStr=""
	s EnglishName=$p(RowStr,del,78)
	s RowStr=$tr(RowStr," ","")
	s TARISelfFlag=$tr($p(RowStr,del,69)," ")       //自费标记 PLIST(22)
	s TARIExtendCode=$tr($p(RowStr,del,68)," ")     //外部码  PLIST(23)
	s TARIPreciousFlag=$tr($p(RowStr,del,63)," ")   //贵重标记  PLIST(24)
	s TARIInsuFlag=$tr($p(RowStr,del,72)," ")       //医保标记  PLIST(25)
	s TARIInsuDesc=$p(RowStr,del,74)                //医保描述  PLIST(26)
	s TARIAlterPrice1=$tr($p(RowStr,del,67)," ")    //特需价格  PLIST(15)
	s XHM=$tr($p(RowStr,del,54)," ")                //协和码
	s zbbj=$tr($p(RowStr,del,55)," ")               //招标标记
	s zbgys=$tr($p(RowStr,del,57)," ")              //招标供应商
	s zbcd=$tr($p(RowStr,del,58)," ")               //招标产地
	s TARIExternalCode=$tr($p(RowStr,del,73)," ")   //医保代码  PLIST(17)
	s TARIExternalCode=""
	s SFYJ=$tr($p(RowStr,del,61)," ")               //收费依据   
	s memo=$tr($p(RowStr,del,71)," ")               //备注
	s stdate=$p(RowStr,del,70)             //开始日期
	s endflag=$tr($p(RowStr,del,64)," ")            //停止标记
	s Code=$p(RowStr,del),Desc=$p(RowStr,del,2),abbr=$p(RowStr,del,3),Alias=$p(RowStr,del,4)
	s guige=$p(RowStr,del,59)
	q:Code="" ..RetErrorValue(RetStr,"代码为空:")
	q:Desc="" ..RetErrorValue(RetStr,"名称为空:")
	i (($d(^PHCD(0,"Name",$$ALPHAUP^SSUTIL4(Desc))))&('$d(^PHCD(0,"Code",$$ALPHAUP^SSUTIL4(Code))))) s Desc=Code_Desc  //liuxs add
	S:(($d(^PHCD(0,"Name",$$ALPHAUP^SSUTIL4(Desc))))&('$d(^PHCD(0,"Code",$$ALPHAUP^SSUTIL4(Code))))) RetStr=..RetErrorValue(RetStr,"药学项名称已经存在:")
	s:(($d(^PHCD(0,"Code",$$ALPHAUP^SSUTIL4(Code))))&('$d(^PHCD(0,"Name",$$ALPHAUP^SSUTIL4(Desc))))) RetStr=..RetErrorValue(RetStr,"药学项代码已经存在:")
	s:(($d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))&('$d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code))))) RetStr=..RetErrorValue(RetStr,"医嘱项名称已经存在:"_Desc)
	s:(($d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code))))&('$d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))) RetStr=..RetErrorValue(RetStr,"医嘱项代码已经存在:"_Code)
	s:(($D(^DHCTARI(0,"Code",Code)))&('$D(^DHCTARI(0,"Desc",Desc)))) RetStr=..RetErrorValue(RetStr,"收费项代码已经存在:"_Code)
	s:(($D(^DHCTARI(0,"Desc",Desc)))&('$D(^DHCTARI(0,"Code",Code)))) RetStr=..RetErrorValue(RetStr,"收费项名称已经存在:"_Desc)
	s:(($d(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(Code))))&('$d(^INCI(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))) RetStr=..RetErrorValue(RetStr,"库存项代码已经存在"_Code)
	s:(($d(^INCI(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))&('$d(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(Code))))) RetStr=..RetErrorValue(RetStr,"库存项名称已经存在"_Desc)

	s UserDr=$o(^SSU("SSUSR",0))
	s BaseUom=$p(RowStr,del,9),BaseUomDr="" //基本单位
	s OrdUom=$p(RowStr,del,5),OrdUomDr="" //基本单位
	i BaseUom'=""  d
	.s BaseUomDr=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(BaseUom),""))
	.s:BaseUomDr="" RetStr=..RetErrorValue(RetStr,"基本单位指针出错:"_BaseUom)
	i OrdUom'=""  d
	.s OrdUomDr=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(OrdUom),""))
	.s:OrdUomDr="" RetStr=..RetErrorValue(RetStr,"医嘱单位指针出错:"_OrdUom)
	s PakgUom=$p(RowStr,del,10),PakgUomDr=""
	s:PakgUom="" RetStr=..RetErrorValue(RetStr,"包装单位为空:") 
	if PakgUom'="" d
	.s PakgUomDr=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(PakgUom),"")) 
	.s:PakgUomDr="" RetStr=..RetErrorValue(RetStr,"包装单位指针出错:"_PakgUom)
	s Price=$tr($p(RowStr,del,8)," ")
	s ConFac=$tr($p(RowStr,del,11)," ")
	s UnitPrice=""
	if (($g(Price)'="")&($g(ConFac)'="")) s UnitPrice=Price,Price=Price/ConFac
	if (($g(TARIAlterPrice1)'="")&($g(ConFac)'="")) s TARIAlterPrice1=TARIAlterPrice1/ConFac
	//药学项

	if ('$d(^PHCD(0,"Name",$$ALPHAUP^SSUTIL4(Desc)))&('$d(^PHCD(0,"Code",$$ALPHAUP^SSUTIL4(Code))))) d
	.s precaution=$p(RowStr,del,47)  ;注意事项
	.s indication=$p(RowStr,del,48)  ;适应症
	.s contraind =$p(RowStr,del,49)  ;禁忌症
	.s advreaction=$p(RowStr,del,50) ;不良反应
	.s incteraction=$p(RowStr,del,51) ;相互作用
	.s waring=$p(RowStr,del,52)      ;提示
	.s cyjl=$p(RowStr,del,14)         ;常用计量
	.s Freq=$p(RowStr,del,40)         ;常用频次
	.s PhcCat=$p(RowStr,del,34)
	.s SubCat=$p(RowStr,del,35)     ;
	.s MinCat=$p(RowStr,del,36)
	.s PhcCatDr="",SubCatDr="",MinCatDr=""
	.S GenericId=""
	.S Generic=$p(RowStr,del,3)
	.if Generic'="" d
	..S ^Temp(Code)=Generic
	..s GenericId=$o(^PHCGE("GE",0,"Name",$$ALPHAUP^SSUTIL4(Generic),0))
	..s ^fhq(Code)=Generic_"^"_GenericId
	..if GenericId="" s RetStr=..RetErrorValue(RetStr,"取药品通用名指针出错:"_Generic)
	.i SubCat'="" d
	..s PhcCatDr=$o(^PHCC("SC_Desc",$$ALPHAUP^SSUTIL4(SubCat),PhcCatDr))
	..s:PhcCatDr="" RetStr=..RetErrorValue(RetStr,"药理学子类不存在:"_SubCat)
	..q:PhcCatDr=""  
	..s SubCatDr=$o(^PHCC("SC_Desc",$$ALPHAUP^SSUTIL4(SubCat),PhcCatDr,SubCatDr))
	..s:SubCatDr="" RetStr=..RetErrorValue(RetStr,"药理学子类指针出错:"_SubCat)	
	.IF MinCat'="" d
	..s MinCatDr=$o(^PHCC("MIN_Desc",$$ALPHAUP^SSUTIL4(MinCat),PhcCatDr,SubCatDr,MinCatDr))
	..s:MinCatDr="" RetStr=..RetErrorValue(RetStr,"药理学小类不存在:"_MinCat)
	.s:SubCatDr'="" SubCatDr=PhcCatDr_"||"_SubCatDr
	.s:MinCatDr'="" MinCatDr=SubCatDr_"||"_MinCatDr
	.s manf=$p(RowStr,del,46),manfdr=""
	.i manf'="" d
	..s manfdr=$o(^PHMNF(0,"Name",$$ALPHAUP^SSUTIL4(manf),""))
	..s:manfdr="" RetStr=..RetErrorValue(RetStr,"药品产地指针出错:"_manf)
	.s PhcForm=$p(RowStr,del,39),PhcFormDr=""
	.if PhcForm="" s RetStr=..RetErrorValue(RetStr,"剂型为空"_Code) q
	.i PhcForm'="" d
	..s PhcFormDr=$o(^PHCF(0,"Desc",$$ALPHAUP^SSUTIL4(PhcForm),"")) 
	..s:PhcFormDr="" RetStr=..RetErrorValue(RetStr,"剂型指针出错:"_PhcForm) 
	..q:PhcFormDr=""
	.q:$g(BaseUomDr)=""
	.s Instruct=$p(RowStr,del,37),InstructDr=""
	.i Instruct'="" d
	..s InstructDr=$o(^PHCIN(0,"Desc1",$$ALPHAUP^SSUTIL4(Instruct),""))
	..s:InstructDr="" RetStr=..RetErrorValue(RetStr,"用药说明指针出错:"_Instruct)
	..q:InstructDr=""
	.
	.s duration=$p(RowStr,del,38)
	.s:duration="" duration="1天"
	.i duration'="" d 
	..s durationDr=$o(^PHCDU(0,"Desc1",$$ALPHAUP^SSUTIL4(duration),""))
	..s:durationDr="" RetStr=..RetErrorValue(RetStr,"疗程指针出错:"_duration)
	..q:durationDr=""
	.
	.s BaseQty=$p(RowStr,del,11)
	.s:BaseQty="" BaseQty=1
	.
	.s EquUom=$p($p(RowStr,del,13),"|",1),EquUomDr=""
	.i EquUom'="" d
	..s EquUomDr=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(EquUom),"")) 
	..s:EquUomDr="" RetStr=..RetErrorValue(RetStr,"等效单位指针出错:"_EquUom)
	.
	.s EquQty=$p($p(RowStr,del,12),"|",1)
	.s EquQty=$s(EquQty="":"",1:+EquQty)
	.
	.s FreqDr=""
	.i Freq'="" d
	..s FreqDr=$o(^PHCFR(0,"Code",$$ALPHAUP^SSUTIL4(Freq),""))
	.S ManType=$p(RowStr,del,15),ManTypeId=""
	.if $g(ManType)'="" d
	..s ManTypeId=$o(^PHCPO(0,"Desc",$$ALPHAUP^SSUTIL4(ManType),0))
	..if ManTypeId="" s RetStr=..RetErrorValue(RetStr,"取管制分类指针出错:"_ManType)
	.if ChangeType'="Test" d
	..k PLIST 
	..s PLIST(15)=Code,PLIST(2)=Desc,PLIST(5)=SubCatDr,PLIST(8)=$g(ManTypeId),PLIST(13)=manfdr,PLIST(22)=GenericId //PLIST(23)=guige wyx modify 2015-04-21 PLIST(23)为医保类别字段不是规格
	..s PLIST(18)=MinCatDr
	..&SQL(INSERT INTO SQLUser.PHC_DrgMast VALUES PLIST())
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"PHC_DrgMast -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..q:$g(SQLCODE)
	..s DrgId=$o(^PHCD(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	..s:DrgId="" RetStr=..RetErrorValue(RetStr,"取药品指针出错:"_Code)
	..q:DrgId=""
	..k PLIST 
	..s PLIST(0)=DrgId
	..IF $g(InstructDr)="" S InstructDr=$O(^PHCIN(0))
	..s PLIST(2)=PhcFormDr,PLIST(10)=FreqDr,PLIST(11)=$g(InstructDr),PLIST(19)=durationDr
	..s PLIST(21)=BaseUomDr,PLIST(22)=1
	..&SQL(INSERT INTO SQLUser.PHC_DrgForm VALUES PLIST())
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"PHC_DrgForm -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..q:$g(SQLCODE)
	..s DrugFormId=$o(^PHCD("DF_Form",PhcFormDr,DrgId,""))
	..if (($d(^PHCD(DrgId,"DF",DrugFormId,"IND",0)))&(indication'="")) s ^PHCD(DrgId,"DF",DrugFormId,"IND",1)=indication
	..if (('$d(^PHCD(DrgId,"DF",DrugFormId,"IND",0)))&(indication'="")) s ^PHCD(DrgId,"DF",DrugFormId,"IND",0)=1,^PHCD(DrgId,"DF",DrugFormId,"IND",1)=indication
	..if (($d(^PHCD(DrgId,"DF",DrugFormId,"PRE",0)))&(precaution'="")) s ^PHCD(DrgId,"DF",DrugFormId,"PRE",1)=precaution
	..if (('$d(^PHCD(DrgId,"DF",DrugFormId,"PRE",0)))&(precaution'="")) s ^PHCD(DrgId,"DF",DrugFormId,"PRE",0)=1,^PHCD(DrgId,"DF",DrugFormId,"PRE",1)=precaution
	..if (($d(^PHCD(DrgId,"DF",DrugFormId,"ADV",0)))&(advreaction'="")) s ^PHCD(DrgId,"DF",DrugFormId,"ADV",1)=advreaction
	..if (('$d(^PHCD(DrgId,"DF",DrugFormId,"ADV",0)))&(advreaction'="")) s ^PHCD(DrgId,"DF",DrugFormId,"ADV",0)=1,^PHCD(DrgId,"DF",DrugFormId,"ADV",1)=advreaction
	..if (($d(^PHCD(DrgId,"DF",DrugFormId,"INT",0)))&(incteraction'="")) s ^PHCD(DrgId,"DF",DrugFormId,"INT",1)=incteraction
	..if (('$d(^PHCD(DrgId,"DF",DrugFormId,"INT",0)))&(incteraction'="")) s ^PHCD(DrgId,"DF",DrugFormId,"INT",0)=1,^PHCD(DrgId,"DF",DrugFormId,"INT",1)=incteraction
	..if (($d(^PHCD(DrgId,"DF",DrugFormId,"CON",0)))&(contraind'="")) s ^PHCD(DrgId,"DF",DrugFormId,"CON",1)=contraind
	..if (('$d(^PHCD(DrgId,"DF",DrugFormId,"CON",0)))&(contraind'="")) s ^PHCD(DrgId,"DF",DrugFormId,"CON",0)=1,^PHCD(DrgId,"DF",DrugFormId,"CON",1)=contraind
	..if (($d(^PHCD(DrgId,"DF",DrugFormId,"WRN",0)))&(waring'="")) s ^PHCD(DrgId,"DF",DrugFormId,"WRN",1)=waring
	..if (('$d(^PHCD(DrgId,"DF",DrugFormId,"WRN",0)))&(waring'="")) s ^PHCD(DrgId,"DF",DrugFormId,"WRN",0)=1,^PHCD(DrgId,"DF",DrugFormId,"WRN",1)=waring
	..s OutUnite=$p(RowStr,del,6),InpUnite=$p(RowStr,del,7)
	..s OutYuanyi=$p(RowStr,del,65),InpYuanyi=$p(RowStr,del,66)
	..s AntFlag=$p(RowStr,del,82),whonet=$p(RowStr,del,83),DDD=$p(RowStr,del,84)
	..//PHC_DrgFormExt 
	..s ^PHCD(DrgId,"DF",DrugFormId,"DHC")=0_del_0_del_0_del_""_del_""_del_""_del_""_del_""_del_""_del_""
	..if ((OutUnite=1)!(OutUnite="Y")) s $P(^PHCD(DrgId,"DF",DrugFormId,"DHC"),del,1)=1   //门诊一天量计算
	..if ((OutYuanyi=1)!(OutYuanyi="Y")) s $P(^PHCD(DrgId,"DF",DrugFormId,"DHC"),del,2)=1  //门诊皮试原液
	..if ((OutUnite=1)!(OutUnite="Y")) s $P(^PHCD(DrgId,"DF",DrugFormId,"DHC"),del,3)=1     //住院皮试原液
	..if ((AntFlag=1)!(AntFlag="Y")) s $P(^PHCD(DrgId,"DF",DrugFormId,"DHC"),del,8)="Y"
	..if (($g(whonet)'="")) s $P(^PHCD(DrgId,"DF",DrugFormId,"DHC"),del,10)=whonet 
	..if (($g(DDD)'="")) s $P(^PHCD(DrgId,"DF",DrugFormId,"DHC"),del,5)=DDD 
	..i EquUomDr=""!(EquQty="") q
	..s:DrugFormId="" RetStr=..RetErrorValue(RetStr,"取药品剂型指针出错:"_Code)
	..q:DrugFormId=""
	..k PLIST s PLIST(0)=DrgId_"||"_DrugFormId
	..s PLIST(3)=EquUomDr,PLIST(4)=+EquQty,PLIST(5)=+cyjl
	..&sql(INSERT INTO SQLUser.PHC_FormDoseEquiv VALUES PLIST())
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"PHC_FormDoseEquiv -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))

	//医嘱项
	if (('$d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))&('$d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code))))) d
	.S abbr="1"
	.if PakgUomDr="" s RetStr=..RetErrorValue(RetStr,"取包装单位出错:"_Code)
	.q:PakgUomDr=""  //包装单位为空时退出
	.s ArcSubCat=$p(RowStr,del,17),ArcSubCatDr=""
    .if ArcSubCat["材料" s PLIST(76)="M"

	.s:ArcSubCat="" RetStr=..RetErrorValue(RetStr,"医嘱子类为空:"_Code)
	.q:ArcSubCat=""
	.s ArcSubCatDr=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(ArcSubCat),"")) 
	.s:ArcSubCatDr="" RetStr=..RetErrorValue(RetStr,"医嘱子类指针出错:"_Code_","_ArcSubCat)
	.q:ArcSubCatDr=""
	.s OnItsOwn=$$ALPHAUP^SSUTIL4($p(RowStr,del,42))
	.s:OnItsOwn="" OnItsOwn="Y"
	.i ((OnItsOwn'="Y")&(OnItsOwn'="N")) s OnItsOwn="Y"
	.s BillGrp=$p(RowStr,del,18)
	.s:BillGrp="" RetStr=..RetErrorValue(RetStr,"帐单组为空:"_Code)
	.q:BillGrp=""
	.s BillGrpDr=$o(^ARCBG(0,"DESC",$$ALPHAUP^SSUTIL4(BillGrp),"")) 
	.s:BillGrpDr="" RetStr=..RetErrorValue(RetStr,"帐单组指针出错:"_Code_","_BillGrp)
	.q:BillGrpDr=""
	.s BillSubGrp=$p(RowStr,del,19)
	.s:BillSubGrp="" RetStr=..RetErrorValue(RetStr,"帐单子组名称为空:"_Code_","_BillSubGrp)
	.q:BillSubGrp=""
	.s BillSubGrpDr=$o(^ARCBG("SG_Desc",$$ALPHAUP^SSUTIL4(BillSubGrp),BillGrpDr,""))
	.s:BillSubGrpDr="" RetStr=..RetErrorValue(RetStr,"帐单子组指针出错"_Code_","_BillSubGrp)
	.q:BillSubGrpDr=""
	.s BillSubGrpDr=BillGrpDr_"||"_BillSubGrpDr
	.if $g(DrgId)="" d
	..s DrgId=$o(^PHCD(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	..s:DrgId="" RetStr=..RetErrorValue(RetStr,"取药品指针出错:"_Code)
	.q:$g(DrgId)=""
	.if $g(DrugFormId)="" d 
	..s DrugFormId=$o(^PHCD(DrgId,"DF",0))
	..s:DrugFormId="" RetStr=..RetErrorValue(RetStr,"取药品剂型指针出错:"_Code_"^"_DrgId_"^"_DrugFormId)
	.q:$g(DrugFormId)=""
	.s OrdDrugFormDr=DrgId_"||"_DrugFormId
	.s Priority=$p(RowStr,del,41)
	.i Priority'="" d 
	..S PrioDr=$o(^OECPR(0,"Desc",$$ALPHAUP^SSUTIL4(Priority),""))
	..if $g(PrioDr)="" s RetStr=..RetErrorValue(RetStr,"取医嘱优先级指针出错:"_Code)
	.s:$g(PrioDr)="" PrioDr=""
	.s resGrp=$p(RowStr,del,100)
    .if ChangeType'="Test" d
	..k PLIST s PLIST(2)=Code,PLIST(3)=Desc,PLIST(4)=abbr,PLIST(105)=OrdUomDr
	..if ArcSubCat["材料" s PLIST(76)="M"
	..s PLIST(9)=ArcSubCatDr,PLIST(47)=BillSubGrpDr,PLIST(83)=OnItsOwn,PLIST(51)=OrdDrugFormDr
	..s PLIST(113)=PrioDr,PLIST(117)=resGrp
	..i endflag=1  s PLIST(73)=+$H-1
	..&SQL(INSERT INTO SQLUser.ARC_ItmMast VALUES PLIST())
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItmMast -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..q:$g(SQLCODE)
	..s ArcimId1=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code),0))
	..s:ArcimId1="" RetStr=..RetErrorValue(RetStr,"取医嘱针出错:"_Code)
	..q:ArcimId1=""
	..s ArcimId2=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code),ArcimId1,0))
	..q:ArcimId2=""
	..s ArcimId=ArcimId1_"||"_ArcimId2
	..s ArcCatDr=$p(^ARC("IC",ArcSubCatDr),del,8)
	..//别名
	..i Alias'="" d
	...set I=1
	...s num=$l(Alias,"/")
	...s ALI=""
	...FOR I=1:1:num d
	....s ALI=$p(Alias,"/",I)
	....q:$d(^ARC("ALIAS",0,"DescI",$$ALPHAUP^SSUTIL4(ALI)_" ",$$ALPHAUP^SSUTIL4(Desc)))
	....q:$g(ALI)=""
	....S ALI=$$ALPHAUP^SSUTIL4(ALI)
	....if ChangeType'="Test" d
	.....k PLIST 
	.....s PLIST(2)=ArcimId,PLIST(5)=Desc,PLIST(6)=ArcSubCatDr,PLIST(9)=OnItsOwn,PLIST(14)=+$h
	.....set PLIST(4)=ALI
	.....&SQL(INSERT INTO SQLUser.ARC_Alias VALUES PLIST()) 
	.....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItmMast -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	.....q:$g(SQLCODE)
	.....s ArcKeyId=0,CircleFlag=1
	.....f  s ArcKeyId=$o(^ARC("KEYW",0,"ARCIM",ArcimId,ArcKeyId)) q:((ArcKeyId="")!(CircleFlag=0))  d
	......s ArcKey=$p(^ARC("KEYW",ArcKeyId),del,3)
	......if ALI=ArcKey s CircleFlag=0
	.....q:(CircleFlag=0)
	.....k PLIST 
	.....s PLIST(2)=ArcimId,PLIST(5)=ALI_"-"_Desc,PLIST(6)=ArcSubCatDr,PLIST(7)=ArcCatDr
	.....set PLIST(4)=ALI_"Z"
	.....&SQL(INSERT INTO SQLUser.ARC_ItemKeywords VALUES PLIST()) 
	.....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItemKeywords -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..//价格
	..if $g(Price)="" s RetStr=..RetErrorValue(RetStr,"价格为空")
	..q:$g(Price)=""
	..if ChangeType'="Test" d
	...k PLIST
	...s PLIST(0)=ArcimId,PLIST(3)=+$h,PLIST(5)=1,PLIST(6)=Price  ;; PLIST(5)*: ARC_Tariff
	...&SQL(INSERT INTO SQLUser.ARC_ItemPriceItaly VALUES :PLIST())
	...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItemPriceItaly -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	//库存项
	i (('$d(^INCI(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))&('$d(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(Code))))) d 
	. s BarCode=$p(RowStr,del,53)
	.s batch=$$ALPHAUP^SSUTIL4($piece(RowStr,del,43)) 
	. s:((batch="Y")!($g(batch)="")) batch="R"
	.if ((batch'="R")&(batch'="O")&(batch'="N")) s RetStr=..RetErrorValue(RetStr,"取批次出错"_Code_","_batch) q
	.s expire=$$ALPHAUP^SSUTIL4($p(RowStr,del,44)) 
	.s:((expire="Y")!($g(expire)="")) expire="R"
	.if ((expire'="R")&(expire'="O")&(expire'="N")) s RetStr=..RetErrorValue(RetStr,"取批次出错"_Code) q
	.q:BaseUomDr=""    
	.q:PakgUomDr="" 
	.s ConFacFlag=$o(^CT("CTCF",0,"UOM",PakgUomDr,BaseUomDr,"")) 
	.if ConFacFlag="" s RetStr=..RetErrorValue(RetStr,"取单位转换出错"_Code) q
	.SET ArcimId1=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	.s:ArcimId1="" RetStr=..RetErrorValue(RetStr,"库存项取医嘱id出错"_Code)
	.q:ArcimId1="" 
	.s ArcimId2=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code),ArcimId1,0))
	.q:$g(ArcimId2)=""
	.SET ArcimId=ArcimId1_"||"_ArcimId2
	.
	.s catg=$p(RowStr,del,32),catgDr="",catg=$tr(catg," ","")
	.if catg="" s RetStr=..RetErrorValue(RetStr,"库存分类为空:"_Code) 
	.q:catg=""
	.s catgDr=$o(^INC("SC",0,"Desc",catg,0))
	.if catgDr="" s RetStr=..RetErrorValue(RetStr,"库存分类为空:"_","_Code_","_catg) 
	.q:catgDr=""
	.s stkgrp=$p(RowStr,del,33),stkgrpDr=""
	.if stkgrp="" s RetStr=..RetErrorValue(RetStr,"盘点分类为空:"_Code) q
	.s stkgrpDr=$o(^INC("TG",0,"Desc",$$ALPHAUP^SSUTIL4(stkgrp),"")) 
	.if stkgrpDr="" s RetStr=..RetErrorValue(RetStr,"库存分类为空:"_","_Code_","_stkgrp) q
	.SET tran="B"
	.if ChangeType'="Test" d
	..K PLIST S PLIST(44)=Code,PLIST(66)=$g(XHM),PLIST(45)=Desc,PLIST(48)=batch,PLIST(49)=expire,PLIST(13)=BaseUomDr,PLIST(60)=PakgUomDr
	..s PLIST(50)=ArcimId,PLIST(14)=catgDr,PLIST(5)=stkgrpDr,PLIST(41)=tran,PLIST(28)=Price
	..s PLIST(64)=BarCode,PLIST(6)=$g(zbbj)
	..&sql(INSERT INTO SQLUser.INC_Itm VALUES :PLIST())
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"INC_Itm -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..q:$g(SQLCODE)
	s IncItmId=$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	
 if IncItmId'="" d
 .s Spec=$p(RowStr,del,59),InvitePrice=$p(RowStr,del,56),InviteManf=$p(RowStr,del,58)
 .s InviteVendor=$p(RowStr,del,57),InvitePeiSong=$p($G(RowStr),del,60)
 .s HighPriceflag=$p(RowStr,del,63) //贵重标记
 .s zjflag=$p(RowStr,del,76) //制剂标记
 .s ylflag=$p(RowStr,del,77) //原料标记
 .s PSFlag=$p(RowStr,del,75)  //皮试标记
 .s GJJBYW= $p(RowStr,del,62)  //基本药物标记
 .i $g(GJJBYW)'="" s GJJBYW="Y"
 .i $g(ylflag)'="" s ylflag="1"
 .i $g(PSFlag)'="" s PSFlag="Y"
 .i $g(HighPriceflag)'="" s HighPriceflag="Y"
 .i $g(zjflag)'="" s zjflag=1
 .IF $G(InviteManf)'="" d
 ..S InviteManfDr=$o(^PHMNF(0,"Name",$$ALPHAUP^SSUTIL4(InviteManf),""))
 ..s:InviteManfDr="" RetStr=..RetErrorValue(RetStr,"招标药品产地指针出错:"_InviteManf)
 .if $g(InviteVendor)'="" d
 ..s InviteVendorDr=$o(^APC("APCVM",0,"APCVM_Name",$$ALPHAUP^SSUTIL4(InviteVendor),""))
 ..s:InviteVendorDr="" RetStr=..RetErrorValue(RetStr,"招标供应商指针出错:"_InviteVendor)
 .IF $g(InvitePeiSong)'="" D
 ..S InvitePeiSongDr=$o(^DHCCARR(0,"Desc",$$ALPHAUP^SSUTIL4(InvitePeiSong),""))
 ..s:InvitePeiSongDr="" RetStr=..RetErrorValue(RetStr,"招标配送商指针出错:"_InvitePeiSongDr)
 .if ChangeType'="Test" D
 ..if '$d(^DHCITMINFO(0,"INCI",IncItmId)) d
 ...k PLIST
 ...i GJJBYW="Y" s PLIST(5)="Y"
 ...s PLIST(42)=zjflag,PLIST(43)=ylflag
 ...S PLIST(2)=IncItmId,PLIST(28)=$g(Spec),PLIST(23)=+$g(InvitePrice),PLIST(25)=$g(InviteVendorDr),PLIST(26)=$g(InviteManfDr)
 ...s PLIST(27)=$g(InvitePeiSongDr),PLIST(36)=$g(PSFlag),PLIST(13)=$g(HighPriceflag)
 ...&sql(insert into SQLUSER.DHC_ItmAddionInfo values :PLIST())
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_ItmAddionInfo -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ...q:$g(SQLCODE)
 
 
	s IncItmId=$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	IF ((Alias'="")&(IncItmId'="")) d
	.set I=1
	.s num=$l(Alias,"/")
	.s ALI=""
	.FOR I=1:1:num d
	..s ALI=$p(Alias,"/",I)
	..q:$g(ALI)=""
	..S ALI=$$ALPHAUP^SSUTIL4(ALI)
	..if ChangeType'="Test" d
	...k PLIST 
	...s PLIST(2)=IncItmId,PLIST(3)=Code ,PLIST(4)=$e(Desc,1,30)  
	...i $l(Desc)>30  s ^DHCTARIIMPORT("MaxString",Code)=RowStr
	...set PLIST(5)=ALI
	...&SQL(INSERT INTO SQLUser.INC_ALIAS VALUES PLIST())
	...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"INC_Itm -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	...q:$g(SQLCODE)
	//库存项价格
	s IncItmId=$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	if ((IncItmId'="")&(PakgUomDr'="")) d
	.
	.if $g(Price)="" s RetStr=..RetErrorValue(RetStr,"价格为空"_Code)
	.q:$g(Price)=""
	.s:Price='"" Price=+Price
	.if $g(ConFac)="" s ConFac=1
	.;if ((ConFac=1)&(BaseUomDr'=PakgUomDr)) s RetStr=..RetErrorValue(RetStr,"单位不相同但系数为为1:"_Code) q
	.;if ((ConFac'=1)&(BaseUomDr=PakgUomDr)) s RetStr=..RetErrorValue(RetStr,"单位相同但系数不为1:"_Code) q
	.//s Price=Price/ConFac
	.SET date=+$H,datee=+$h
	.q:BaseUomDr=""
	.if (Price<0) s RetStr=..RetErrorValue(RetStr,"库存项价格小于0"_Code_","_code) q
	.if ChangeType'="Test" d
	..k PLIST         
	..s PLIST(7)=+Price,PLIST(10)="Yes"
	..s PLIST(8)=+Price
	..s PLIST(6)="ADJ00000B"      
	..s PLIST(2)=date,PLIST(3)=datee,PLIST(4)=UserDr,PLIST(5)=IncItmId,PLIST(11)=PakgUomDr,PLIST(12)=+UnitPrice
	..&sql(INSERT INTO SQLUser.IN_AdjSalePrice VALUES :PLIST())
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"INC_Alias -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))

	//收费项
	if (('$D(^DHCTARI(0,"Code",Code)))&('$D(^DHCTARI(0,"Desc",Desc)))) d
	.s TarSubCat=$P(RowStr,del,21)
	.SET INP=$P(RowStr,del,23),OUTP=$P(RowStr,del,25),EMC=$P(RowStr,del,27),ACCT=$P(RowStr,del,29),MR=$P(RowStr,del,31)
	.q:BaseUomDr=""
	.s:TarSubCat="" RetStr=..RetErrorValue(RetStr,"收费子类为空:"_Code)
	.q:TarSubCat=""
	.SET TarSubCatDr=$O(^DHCTarC("SC",0,"Desc",$$UPPER^SSUTIL4(TarSubCat),""))
	.s:TarSubCatDr="" RetStr=..RetErrorValue(RetStr,"收费子指针出错:"_Code_","_TarSubCat)
	.Q:TarSubCatDr=""
	.if OUTP="" s RetStr=..RetErrorValue(RetStr,"门诊子类为空:"_Code) q
	.SET OUTPDR=$O(^DHCTarC("OC",0,"Desc",OUTP,""))
	.if OUTPDR="" s RetStr=..RetErrorValue(RetStr,"门诊子类指针出错:"_Code_","_OUTP) q
	.if INP="" s RetStr=..RetErrorValue(RetStr,"住院子类为空:"_Code) q
	.SET INPDR=$O(^DHCTarC("IC",0,"Desc",INP,"")) 
	.if INPDR="" s RetStr=..RetErrorValue(RetStr,"住院子类指针出错:"_Code_","_INP) q
	.if EMC="" s RetStr=..RetErrorValue(RetStr,"核算子类为空:"_Code) q
	.SET EMCDR=$O(^DHCTarC("EC",0,"Desc",EMC,""))
	.if EMCDR="" s RetStr=..RetErrorValue(RetStr,"核算子类指针出错:"_Code_","_EMC) q
	.if ACCT="" s RetStr=..RetErrorValue(RetStr,"会计科目子类为空:"_Code) q
	.SET ACCTDR=$O(^DHCTarC("AC",0,"Desc",ACCT,""))
	.if ACCTDR="" s RetStr=..RetErrorValue(RetStr,"会计科目指针出错:"_Code_","_ACCTDR) q
	.
	.if MR="" s RetStr=..RetErrorValue(RetStr,"病案子类为空:"_Code) q
	.SET MRDR=$o(^DHCTarC("MC",0,"Desc",MR,""))
	.if MRDR="" s RetStr=..RetErrorValue(RetStr,"病案指针出错:"_Code_","_MRDR) q
	.if ChangeType'="Test" d
	..K PLIST
	..SET PLIST(10)="N",PLIST(11)="Y",PLIST(12)=+$H
	..i endflag=1  s PLIST(11)="N" 
	..i stdate'=""  s PLIST(12)=$ZDH(stdate,3)
	..i $g(stdate)="" s PLIST(12)=+$h-1
	..s PLIST(22)=$g(TARISelfFlag)       //自费标记 PLIST(22)
	..s PLIST(23)=$p(RowStr,del,68)     //外部码  PLIST(23)
	..s PLIST(24)=$g(TARIPreciousFlag)   //贵重标记  PLIST(24)
	..s PLIST(25)=$g(TARIInsuFlag)       //医保标记  PLIST(25)
	..s PLIST(26)=$g(TARIInsuDesc)       //医保描述  PLIST(26)
	..s PLIST(15)=""    //特需价格  PLIST(15)
	..s PLIST(17)=$tr($p(RowStr,del,75)," ")    //医保代码  PLIST(17)
	..SET PLIST(2)=Code,PLIST(3)=Desc,PLIST(4)=BaseUomDr,PLIST(5)=TarSubCatDr,PLIST(6)=ACCTDR,PLIST(7)=OUTPDR
	..SET PLIST(8)=EMCDR,PLIST(9)=MRDR,PLIST(18)=INPDR,PLIST(21)=SFYJ,PLIST(20)=memo
	..&SQL(INSERT INTO SQLUser.DHC_TARITEM VALUES :PLIST())
	..i $l(Desc)>30  s ^DHCTARIIMPORT("MaxString",Code)=RowStr
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_TARITEM -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..q:$g(SQLCODE)
	..s TarId=$o(^DHCTARI(0,"Code",Code,""))
	..if TarId="" s RetStr=RetStr=..RetErrorValue(RetStr,"收费项指针出错"_Code)
	..q:TarId=""
	..;s ^DHCTARIIMPORT("ImportDataDrug",Code)=TarId_"^"_..getrdataDrug(RowStr)
	..;s ^DHCTARIIMPORT("ImportDataDrug",Code)=$g(^DHCTARIIMPORT("ImportDataDrug",Code))
	..set I=1
	..k PLIST 
	..s PLIST(2)=TarId,PLIST(3)=Desc
	..s:Price='"" Price=+Price
	..s:TARIAlterPrice1'="" TARIAlterPrice1=+TARIAlterPrice1
	..s:Price="" RetStr=..RetErrorValue(RetStr,"收费项价格为空"_Code)
	..if $g(ConFac)="" s ConFac=1
	..k PLIST 
	..s PLIST(0)=TarId,PLIST(3)=+$H-1,PLIST(5)=+Price,PLIST(14)=TARIAlterPrice1,PLIST(8)=UserDr,PLIST(13)="1",PLIST(16)=$g(TPRate)
	..&SQL(INSERT INTO SQLUser.DHC_TARItemPrice VALUES :PLIST())
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_TARItemPrice -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	//收费项别名
	s TarId=$o(^DHCTARI(0,"Code",Code,""))
	if (($g(TarId)'="")&(ChangeType'="Test")) d
	.set I=1
	.k PLIST 
	.s PLIST(2)=TarId,PLIST(3)=$e(Desc,1,30)
	.i $l(Desc)>30  s ^DHCTARIIMPORT("MaxString",Code)=RowStr   //字段超长
	.FOR  s ALI=$P(Alias,"/",I)  q:ALI=""  D
	..q:$g(ALI)=""
	..set PLIST(4)=ALI
	..SET I=I+1
	..&SQL(INSERT INTO SQLUser.DHC_TARITEMAlias VALUES :PLIST()) 
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_TARITEMAlias -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	//医嘱与收费项目对照
	SET ArcimId1=$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code),0))
	q:ArcimId1="" ..RetErrorValue(RetStr,"对照时医嘱id出错"_Code) 
	SET ArcimId=ArcimId1_"||"_$O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code),ArcimId1,0))
	SET TarId=$O(^DHCTARI(0,"Code",Code,""))
	q:TarId="" ..RetErrorValue(RetStr,"对照时收费项目id出错"_Code)
	q:$d(^DHCOLT(0,"ARTTA",ArcimId,TarId)) RetStr
	if ChangeType'="Test" d
	.K PLIST
	.SET PLIST(2)=ArcimId,PLIST(3)=TarId,PLIST(4)=1,PLIST(5)=+$H-1
	.&SQL(INSERT INTO SQLUser.DHC_ORDERLINKTAR VALUES :PLIST())
	.s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_ORDERLINKTAR -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

/// 药品通用名
ClassMethod DrugDataGen(ChangeType As %String = "", RowStr As %String = "") As %String
{
 ;导药学项通用名
 ;CODE    DESC  alias
 ; 1        2    3
 ;K ^PHCGE("GE")

 IF ChangeType="Clear" K ^PHCGE("GE")
	q:ChangeType="Clear" "数据已清:药品通用名"
	s RetStr="",del="^"
	S RowStr=$TR(RowStr," ","")
	S CODE=$P(RowStr,del,1),DESC=$P(RowStr,del,2),ALIAS=$P(RowStr,del,3)
	;S DESC=DESC
	s startdate=+$h-1
	q:$G(CODE)="" ..RetErrorValue(RetStr,"代码为空")
	q:$D(^PHCGE("GE",0,"Code",$$ALPHAUP^SSUTIL4(CODE))) ..RetErrorValue(RetStr,"代码已经存在"_CODE) 
	K PLIST
	SET PLIST(2)=DESC,PLIST(3)=CODE,PLIST(6)=startdate
	 &SQL(INSERT INTO SQLUser.PHC_Generic VALUES PLIST())
 Q:$g(SQLCODE) ..RetErrorValue(RetStr,"PHC_Generic -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	
 s ARCIM=$g(%ROWID),I=1
 k PLIST s PLIST(16)=ARCIM,PLIST(14)=startdate
 F  s ALI=$P(ALIAS,"/",I)  q:ALI=""   D
 .set PLIST(4)=$EXTRACT(ALI,1,8)
 .SET I=I+1
 .&SQL(INSERT INTO SQLUser.ARC_Alias VALUES PLIST())
	Q RetStr
}

/// 设备资源
ClassMethod EqResource(ChangeType As %String = "", RowStr As %String = "") As %String
{
	//1				2		3			4		5			6	  7			8
	//科室代码	科室名称	设备组	设备名称	星期	开始时间 结束时间	数量
 IF ChangeType="Clear" k ^RBC("GRP"),^RBC("EQ")
	q:ChangeType="Clear" "数据已清:设备组及设备"
	s RetStr="",del="^"
	S RowStr=$TR(RowStr," ","")
	S CtLocCode=$P(RowStr,del,1),EqGroupCode=$P(RowStr,del,3),EqGroupDesc=$P(RowStr,del,4),Equipment=$P(RowStr,del,5)
	s Week=$P(RowStr,del,6),StartTime=$P(RowStr,del,7),EndTime=$P(RowStr,del,8),Num=$P(RowStr,del,9)
 s TotalNum=$P(RowStr,del,9)
	q:CtLocCode="" "科室代码为空"_CtLocCode
	s CtLocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtLocCode),""))
	Q:$g(CtLocId)="" ..RetErrorValue(RetStr,"科室指针出错Ct_loc:"_CtLocCode)
	s:StartTime="" StartTime="08:00:00"
	s StartTime=$zth(StartTime)
	s:EndTime="" EndTime="17:00:00"
	s EndTime=$zth(EndTime)
	s CtLocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtLocCode),""))
	q:CtLocId="" ..RetErrorValue(RetStr,"取科室指针出错"_CtLocCode_" "_Week)
	s EquipmentCode=""
	
	if $g(^RBC("EQ",0))="" s EquipmentCode=1
	if $g(^RBC("EQ",0))'="" s EquipmentCode=$g(^RBC("EQ",0))+1
	q:EqGroupCode="" "设备组为空"_CtLocCode_"星期"_Week
	S:('$d(^RBC("GRP",0,"Code",$$ALPHAUP^SSUTIL4(EqGroupCode)))&($d(^RBC("GRP",0,"Desc",$$ALPHAUP^SSUTIL4(EqGroupDesc))))) RetStr=..RetErrorValue(RetStr,"设备代码已经存在"_EqGroupCode)
	S:($d(^RBC("GRP",0,"Code",$$ALPHAUP^SSUTIL4(EqGroupCode)))&('$d(^RBC("GRP",0,"Desc",$$ALPHAUP^SSUTIL4(EqGroupDesc))))) RetStr=..RetErrorValue(RetStr,"设备名称已经存在"_EqGroupDesc)
	if ('$d(^RBC("GRP",0,"Code",$$ALPHAUP^SSUTIL4(EqGroupCode)))&('$d(^RBC("GRP",0,"Desc",$$ALPHAUP^SSUTIL4(EqGroupDesc))))) d
	.if ((ChangeType'="Test")) d
	..k PLIST
	..S PLIST(2)=EqGroupCode,PLIST(3)=EqGroupDesc,PLIST(4)=+$H
	..&SQL(INSERT INTO SQLUSER.RBC_EquipmentGroup VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RBC_EquipmentGroup -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
 q:Equipment="" "设备为空"_CtLocCode_"星期"_Week
 if ('$d(^RBC("EQ",0,"Desc",$$ALPHAUP^SSUTIL4(Equipment)))) d
 .s EqGroupDr=$o(^RBC("GRP",0,"Code",$$ALPHAUP^SSUTIL4(EqGroupCode),0))
 .if $g(EqGroupDr)="" s RetStr=..RetErrorValue(RetStr,"取设备组指针出错"_Equipment)
 .if ((ChangeType'="Test")) d
 ..k PLIST
 ..if $g(EqGroupDr)'="" s PLIST(4)=EqGroupDr
	..S PLIST(2)=EquipmentCode,PLIST(3)=Equipment,PLIST(5)=+$H
 ..&SQL(INSERT INTO SQLUSER.RBC_Equipment VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RBC_Equipment -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
 s EqId=$o(^RBC("EQ",0,"Desc",$$ALPHAUP^SSUTIL4(Equipment),""))
 q:$g(EqId)="" ..RetErrorValue(RetStr,"取设备指针出错"_Equipment)
 if '$d(^RB("RES",0,"EQ",EqId,CtLocId)) d
 .s EquipmentId=$o(^RBC("EQ",0,"Desc",$$ALPHAUP^SSUTIL4(Equipment),0))
 .if $g(EquipmentId) s RetStr=..RetErrorValue(RetStr,"取设备指针出错"_Equipment)
 .q:$g(EquipmentId)=""
 .s EquipmentCode=$p(^RBC("EQ",EquipmentId),del,1)
 .if $d(^RB("RES",0,"LocDesc",CtLocId,$$ALPHAUP^SSUTIL4(Equipment))) 
 .if ((ChangeType'="Test")) d
 ..k PLIST
	..s PLIST(3)=CtLocId,PLIST(5)=EqId,PLIST(7)=EquipmentCode,PLIST(8)=Equipment,PLIST(11)=-1,PLIST(16)=999
	..s PLIST(19)="Equipment",PLIST(20)="Y",PLIST(21)="Y"
	..if $d(^RB("RES",0,"LocDesc",CtLocId,$$ALPHAUP^SSUTIL4(Equipment))) d
	...&sql(update SQLUser.RB_Resource set RES_EQ_DR=:EqId,RES_Code=:EquipmentCode WHERE RES_CTLOC_DR=:CtLocId AND RES_DESC=:Equipment)
	..else  d
	...&sql(INSERT INTO SQLUser.RB_Resource VALUES :PLIST())
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"RB_Resource -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	
	s EqId=$o(^RBC("EQ",0,"Desc",$$ALPHAUP^SSUTIL4(Equipment),""))
	s RbId=$o(^RB("RES",0,"EQ",EqId,CtLocId,""))
	q:RbId="" ..RetErrorValue(RetStr,"资源计划中没有相应的记录"_Equipment)
	s RbDId="" 
	s RbDId=$o(^RB("RES",RbId,"DATE",0,"Date",+$h,RbDId))
	if (($g(RbDId)="")&(ChangeType'="Test")) d 
	.k PLIST
	.s PLIST(0)=RbId,PLIST(3)=+$h
	.&SQL(INSERT INTO SQLUSER.RB_ResEffDate VALUES :PLIST())
	i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RB_ResEffDate -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	;q DateStr_"^"_RowStr
	s:RbDId="" RbDId=$o(^RB("RES",RbId,"DATE",0,"Date",+$h,0))
 q:Week="" "排班日期为空"_CtLocCode
	s CircleFlag=1,RbDSId=0
	for  s RbDSId=$o(^RB("RES",RbId,"DATE",RbDId,"SESS",RbDSId)) q:((RbDSId="")!(CircleFlag=0))  d
	.s Str=$g(^RB("RES",RbId,"DATE",RbDId,"SESS",RbDSId))
	.s SWeek=$p(Str,del,2),SStartTime=$p(Str,del,4)
	.if ((SWeek=Week)&(SStartTime=StartTime)) s RbDSId1=RbDSId,CircleFlag=0
	.if CircleFlag=0 s RetStr=..RetErrorValue(RetStr,"记录已经存在"_Equipment_"星期"_Week)
	q:CircleFlag=0 RetStr
	if (ChangeType'="Test") d
	.k PLIST
	.s PLIST(0)=RbId_"||"_$g(RbDId),PLIST(4)=StartTime,PLIST(5)=EndTime,PLIST(8)=TotalNum
	.s PLIST(10)=Week
	.&SQL(INSERT INTO SQLUSER.RB_ResEffDateSession VALUES :PLIST())
	.i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RB_ResEffDateSession -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	q RetStr
}

/// ICD10
ClassMethod ICD(ChangeType As %String = "", RowStr As %String = "") As %String
{
	; ----*1*----2-----
	;    CODE    IcdCode1    IcdCode2  IcdDesc  Alia
	;
	IF ChangeType="Clear" K ^MRC("ID")
	q:ChangeType="Clear" "Icd数据已经清除"
	s RetStr="",del="^"
	;S RowStr=$TR(RowStr," ","")
	S Code=$P(RowStr,del,1),IcdCode1=$P(RowStr,del,2),IcdCode2=$P(RowStr,del,3),IcdDesc=$P(RowStr,del,4)
	S Alias=$P(RowStr,del,5),ICDEname=$P(RowStr,del,6),billflag3=$P(RowStr,del,7)
	S MetastaticSite=$P(RowStr,del,8),InjuryPoisoningCode=$P(RowStr,del,9)
	if $G(billflag3)'="Y"  s billflag3="N"
	;if $G(billflag3)'="" s billflag3="Y" 
	if $G(MetastaticSite)'="Y"  s MetastaticSite="N"
	;if $G(MetastaticSite)'="" s MetastaticSite="Y" 
	if $G(InjuryPoisoningCode)'="Y"  s InjuryPoisoningCode="N"
	;if $G(InjuryPoisoningCode)'="" s InjuryPoisoningCode="Y" 
	
	if ((Code'="")&(IcdDesc'="")) d
	.IF $D(^MRC("ID",0,"Code",$$ALPHAUP^SSUTIL4(Code))) s RetStr=..RetErrorValue(RetStr,"代码已经存在Mrc_Icddx:"_Code) q
	.IF $D(^MRC("ID",0,"Desc",$$ALPHAUP^SSUTIL4(IcdDesc))) s RetStr=..RetErrorValue(RetStr,"名称已经存在Mrc_Icddx:"_IcdDesc)
	.if ChangeType'="Test" d
	..k PLIST
	..s PLIST(42)=MetastaticSite,PLIST(43)=InjuryPoisoningCode
	..S PLIST(2)=Code,PLIST(3)=IcdDesc,PLIST(17)=billflag3,PLIST(6)=IcdCode1,PLIST(8)=+$h-1,PLIST(45)=IcdCode2,PLIST(38)=ICDEname
	..&SQL(INSERT INTO SQLUser.Mrc_Icddx VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"Mrc_Icddx -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	..q:$g(SQLCODE)
 ..s MrId=$o(^MRC("ID",0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
 ..i Alias'="" d
 ...set I=1
 ...k PLIST 
 ...s PLIST(0)=MrId
 ...s num=$l(Alias,"/")
 ...s ALI=""
 ...FOR I=1:1:num d
 ....s ALI=$p(Alias,"/",I)
 ....s ALI=$$ALPHAUP^SSUTIL4(ALI)
 ....q:$d(^MRC("ID",0,"ALIAS",$$ALPHAUP^SSUTIL4(ALI),MrId))
 ....if ChangeType'="Test" d
 .....set PLIST(3)=ALI
 .....&SQL(INSERT INTO SQLUser.MRC_ICDAlias VALUES PLIST()) 
 .....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"MRC_ICDAlias -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 Q RetStr
}

/// 科室模板
ClassMethod ICDTEMPLETE(ChangeType As %String = "", RowStr As %String = "") As %String
{
	; ----*1*----2-----
	;    CODE    IcdCode1    IcdCode2  IcdDesc  Alia
	;
	IF ChangeType="Clear" K ^DHCLocDiagnoseI,^DHCLocDiagnose
	q:ChangeType="Clear" "Icd模板数据已经清除"
	s RetStr="",del="^"
	S RowStr=$TR(RowStr," ","")
	S CtLocCode=$P(RowStr,del,1),IcdCode1=$P(RowStr,del,3),IcdDesc=$P(RowStr,del,4)
	s CtLocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtLocCode),""))
	Q:$g(CtLocId)="" ..RetErrorValue(RetStr,"科室代码为空Ct_loc:"_CtLocCode)
	s IcdId=$o(^MRC("ID",0,"Desc",$$ALPHAUP^SSUTIL4(IcdDesc),""))
	q:$g(IcdId)="" ..RetErrorValue(RetStr,"ICD指针出错MRC_ICDDX:"_IcdDesc_" "_IcdCode1)
	s LocDiaId="",CircleFlag=1
	f  s LocDiaId=$o(^DHCLocDiagnoseI("Location",CtLocId,LocDiaId)) q:((LocDiaId="")!(CircleFlag=0))  d
	.s IcdIdTmp=$p(^DHCLocDiagnose(LocDiaId),del,2)
	.if IcdIdTmp=LocDiaId s CircleFlag=0
	if ((CircleFlag'=0)&(ChangeType'="Test")) d
	.k PLIST
	.S PLIST(2)=CtLocId,PLIST(3)=LocDiaId
	.&SQL(INSERT INTO SQLUser.DHC_LocDiagnose VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_LocDiagnose -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	Q RetStr
}

/// 药品厂家
ClassMethod ManuFacturer(ChangeType As %String = "", RowStr As %String = "") As %String
{
 //产地
 Set CurrentNS=$ZNSPACE
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	IF ChangeType="Clear" K ^PHMNF
	q:ChangeType="Clear" "数据已清:产地"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 
 //增加产地
 s code=$p(RowStr,del,1),desc=$p(RowStr,del,2),pinyin=$p(RowStr,del,3)
 if ((code'="") & (pinyin'="")) d
 .i pinyin'="" s desc=pinyin_"-"_desc
 .if code="" s RetStr=..RetErrorValue(RetStr,"名称不能为空PH_Manufacturer:")
 .i $d(^PHMNF(0,"Code",$$ALPHAUP^SSUTIL4(code))) s RetStr=..RetErrorValue(RetStr,"编码已经存在PH_Manufacturer:"_code)
 .i $d(^PHMNF(0,"Name",$$ALPHAUP^SSUTIL4(desc))) s RetStr=..RetErrorValue(RetStr,"名称已经存在PH_Manufacturer:"_desc)
 .i (('$d(^PHMNF(0,"Code",$$ALPHAUP^SSUTIL4(code))))&('$d(^PHMNF(0,"Name",$$ALPHAUP^SSUTIL4(desc))))) d 
 ..s Tel=$P(RowStr,del,4),Address=$P(RowStr,del,5)
 ..if ChangeType'="Test" d
 ...K PLIST
 ...b ;0
 ...s PLIST(7)=code,PLIST(2)=desc,PLIST(5)=Address,PLIST(6)=Tel
 ...&sql(INSERT INTO SQLUSER.PH_Manufacturer VALUES :PLIST())
 ...b ;1
 ...i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"PH_Manufacturer -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

/// 供应商
ClassMethod PhVendor(ChangeType As %String = "", RowStr As %String = "") As %String
{
	;w ##class(web.DHCFHQ.DHCFFHQ).PhVendor("","M00001^北京易安华^BJYAH^M")

 //供应商
 Set CurrentNS=$ZNSPACE
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	IF ChangeType="Clear" k ^APC("APCVM"),^DHCSTV
	q:ChangeType="Clear" "数据已清:供应商"

	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
 s code=$p(RowStr,del,1),desc=$p(RowStr,del,2),pinyin=$p(RowStr,del,3),type=$p(RowStr,del,4)
 s pinyin=$e(pinyin,1,8)
 i pinyin'="" s desc=pinyin_"-"_desc
 if ((code'="") & (pinyin'="")) d
 .if code="" s RetStr=..RetErrorValue(RetStr,"名称不能为空APC_VENDOR:")
 .i $d(^APC("APCVM",0,"APCVM_Code",$$ALPHAUP^SSUTIL4(code))) s RetStr=..RetErrorValue(RetStr,"编码已经存在APC_VENDOR:"_code)
 .i $d(^APC("APCVM",0,"APCVM_Name",$$ALPHAUP^SSUTIL4(desc))) s RetStr=..RetErrorValue(RetStr,"名称已经存在APC_VENDOR:"_code)
 .i (('$d(^APC("APCVM",0,"APCVM_Code",$$ALPHAUP^SSUTIL4(code))))&('$d(^APC("APCVM",0,"APCVM_Name",$$ALPHAUP^SSUTIL4(desc))))) d 
 ..s Tel="",Address=$P(RowStr,del,3)
 ..if ChangeType'="Test" d
 ...s Para=code_del_desc_del_type
 ...ZN MEDDATA
 ...s MRetStr=$$ApcVendor^DHCFHQIMP(Para)
 ...ZN CurrentNS
 ...s RetStr=..RetErrorValue(RetStr,MRetStr)
 q:RetStr="" "Ok"
 q RetStr
}

/// 医嘱子类 集团化多院区
ClassMethod OrdCatHosp(ChangeType As %String = "", RowStr As %String = "") As %String
{
	;Exel Field :
	;  *1*-------*2*-----3-----4*------------5--------------6------7------8---------9-------10---
	;    exam   code^Category^SubCode^SubCategory(desc)^执行类型  type   result  calqty 接收科室  病人所在科室
	;PLIST:
	;  -(2)------(3)------------(9)-----(8)-   PLIST(10)       PLIST(12)
	; PLIST(8): Drug(R),Diet(D),IV(I),Consultation(C),Normal(N),Dental(T),LabTrak(L),
	;           RehabMedicine(X),Price(P)
	; PLIST(12): Required - Calculate Qty Flag
	; *** CAUTION: IND NUMber ***
	;
   
	IF ChangeType="Clear" K ^OEC("ORCAT"),^ARC("IC")
	q:ChangeType="Clear" "数据已清:医嘱大类和医嘱子类"
	s del="^",RetStr=""
	;s ^TMP("aaa")=RowStr
	s ^TMP("ChangeType")=ChangeType
	;s RowStr=^TMP("aaa")
	SET RowStr=$tr(RowStr," ","")
	s OrdCatGroupCode=$P(RowStr,del,1)
	if OrdCatGroupCode'="" d
	.s OrdCatGroupId=$o(^OEC("OCGRP",0,"Code",$$ALPHAUP^SSUTIL4(OrdCatGroupCode),""))
	.q:OrdCatGroupId=""
	.if $g(OrdCatGroupId)=""  s RetStr=..RetErrorValue(RetStr,"医嘱大类分组代码为空"_OrdCatGroupCode)
	S OrdCatCode=$P(RowStr,del,2),OrdCatDesc=$P(RowStr,del,3)
	if $g(OrdCatCode)="" d
	.S OrdCatCodeTmp=$o(^OEC("ORCAT",0,"Code","99"),-1)
	.if $g(OrdCatCodeTmp)'="" s OrdCatCode=OrdCatCodeTmp+1
	.if ($g(OrdCatCodeTmp)="")&&(OrdCatCode="") s OrdCatCode="01"
	Q:OrdCatCode="" ..RetErrorValue(RetStr,"医嘱大类代码为空OEC_ORDERCATEGORY")
	q:OrdCatDesc="" ..RetErrorValue(RetStr,"医嘱大类名称为空OEC_ORDERCATEGORY")
	s OrdCatPatLoc=$P(RowStr,del,4),OrdCatRLoc=$P(RowStr,del,5)
	if ('$D(^OEC("ORCAT",0,"Desc",$$ALPHAUP^SSUTIL4(OrdCatDesc)))) d
	.if ChangeType'="Test" d
	..K PLIST
	..S PLIST(2)=OrdCatCode,PLIST(3)=OrdCatDesc,PLIST(16)=$g(OrdCatGroupId)
	..&SQL(INSERT INTO SQLUser.OEC_ORDERCATEGORY VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"OEC_ORDERCATEGORY -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	s OrdCatDr=$o(^OEC("ORCAT",0,"Desc",$$ALPHAUP^SSUTIL4(OrdCatDesc),""))
	s OrdCatCode=($p(^OEC("ORCAT",OrdCatDr),del,1))
	b //医嘱大类接收科室
	if ($G(OrdCatDr)'="") d
	.q:(($g(OrdCatPatLoc)="")&($g(OrdCatRLoc)=""))
	.s OrdCatRlocId=0
	.if $g(OrdCatDr)'="" d
	..IF ((OrdCatRLoc="各个病房")&(ChangeType'="Test"))  D
	...s WardId=0
	...FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	....q:($P(^CTLOC(WardId),del,13)'="W")
	....s Para=OrdCatDr_del_WardId_del_WardId
	....s ExistFlag=..OrdCatRlocExitHosp(Para)
	....q:ExistFlag=1
	....K PLIST
	....s PLIST(6)="Y"
	....SET PLIST(0)=OrdCatDr,PLIST(3)=WardId,PLIST(4)=WardId,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..IF ((OrdCatRLoc="各个病房E")&(ChangeType'="Test"))  D
	...s WardId=0
	...FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	....q:($P(^CTLOC(WardId),del,13)'="W")
	....s hosdr=$P(^CTLOC(WardId),del,22)
	....q:hosdr'=3  //东院
    ....s stop=$P(^CTLOC(WardId),del,25)
	....q:stop'="" //院
	....s Para=OrdCatDr_del_WardId_del_WardId
	....s ExistFlag=..OrdCatRlocExitHosp(Para)
	....q:ExistFlag=1
	....K PLIST
	....s PLIST(6)="Y"
	....SET PLIST(0)=OrdCatDr,PLIST(3)=WardId,PLIST(4)=WardId,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..IF ((OrdCatRLoc="各个病房W")&(ChangeType'="Test"))  D
	...s WardId=0
	...FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	....q:($P(^CTLOC(WardId),del,13)'="W")
	....s hosdr=$P(^CTLOC(WardId),del,22)
	....q:hosdr'=2  //西院
    ....s stop=$P(^CTLOC(WardId),del,25)
	....q:stop'="" //院
	....s Para=OrdCatDr_del_WardId_del_WardId
	....s ExistFlag=..OrdCatRlocExitHosp(Para)
	....q:ExistFlag=1
	....K PLIST
	....s PLIST(6)="Y"
	....SET PLIST(0)=OrdCatDr,PLIST(3)=WardId,PLIST(4)=WardId,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..s RLocDr="",I=1
	..IF ((OrdCatRLoc="临床科室")&(ChangeType'="Test"))  D
	...f  s RLocDr=$o(^PAC("ADMLOC",0,"AdmType","I",RLocDr)) q:RLocDr=""  d
	....q:('$d(^CTLOC(RLocDr,"LINK")))
	....s Para=OrdCatDr_del_RLocDr_del_RLocDr
	....s ExistFlag=..OrdCatRlocExitHosp(Para)
	....q:ExistFlag=1
	....k PLIST
	....s PLIST(6)="Y"
	....SET PLIST(0)=OrdCatDr,PLIST(3)=RLocDr,PLIST(4)=RLocDr,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..s RLocDr="",I=1
	..IF ((OrdCatRLoc="临床科室E")&(ChangeType'="Test"))  D
	...f  s RLocDr=$o(^PAC("ADMLOC",0,"AdmType","I",RLocDr)) q:RLocDr=""  d
	....q:('$d(^CTLOC(RLocDr,"LINK")))
	....s hosdr=$P(^CTLOC(RLocDr),del,22)
	....q:hosdr'=3  //东院
    ....s stop=$P(^CTLOC(RLocDr),del,25)
	....q:stop'="" //院
	....s Para=OrdCatDr_del_RLocDr_del_RLocDr
	....s ExistFlag=..OrdCatRlocExitHosp(Para)
	....q:ExistFlag=1
	....k PLIST
	....s PLIST(6)="Y"
	....SET PLIST(0)=OrdCatDr,PLIST(3)=RLocDr,PLIST(4)=RLocDr,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..s RLocDr="",I=1
	..IF ((OrdCatRLoc="临床科室W")&(ChangeType'="Test"))  D
	...f  s RLocDr=$o(^PAC("ADMLOC",0,"AdmType","I",RLocDr)) q:RLocDr=""  d
	....q:('$d(^CTLOC(RLocDr,"LINK")))
	....s hosdr=$P(^CTLOC(RLocDr),del,22)
	....q:hosdr'=2  //西院
    ....s stop=$P(^CTLOC(RLocDr),del,25)
	....q:stop'="" //院
	....s Para=OrdCatDr_del_RLocDr_del_RLocDr
	....s ExistFlag=..OrdCatRlocExitHosp(Para)
	....q:ExistFlag=1
	....k PLIST
	....s PLIST(6)="Y"
	....SET PLIST(0)=OrdCatDr,PLIST(3)=RLocDr,PLIST(4)=RLocDr,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..s RLocDr="",I=1
	..IF ((OrdCatRLoc="各个科室")&(ChangeType'="Test"))  D
	...f  s RLocDr=$o(^PAC("ADMLOC",0,"AdmType","O",RLocDr)) q:RLocDr=""  d
	....s Para=OrdCatDr_del_RLocDr_del_RLocDr
	....s ExistFlag=..OrdCatRlocExitHosp(Para)
	....q:ExistFlag=1
	....k PLIST
	....s PLIST(6)="Y"
	....SET PLIST(0)=OrdCatDr,PLIST(3)=RLocDr,PLIST(4)=RLocDr,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..s RLocDr="",I=1
	..IF ((OrdCatRLoc="各个科室W")&(ChangeType'="Test"))  D
	...f  s RLocDr=$o(^PAC("ADMLOC",0,"AdmType","O",RLocDr)) q:RLocDr=""  d
	....s hosdr=$P(^CTLOC(RLocDr),del,22)
	....q:hosdr'=2  //西院
    ....s stop=$P(^CTLOC(RLocDr),del,25)
	....q:stop'="" //院
    ....s Para=OrdCatDr_del_RLocDr_del_RLocDr
	....s ExistFlag=..OrdCatRlocExitHosp(Para)
	....q:ExistFlag=1
	....k PLIST
	....s PLIST(6)="Y"
	....SET PLIST(0)=OrdCatDr,PLIST(3)=RLocDr,PLIST(4)=RLocDr,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..s RLocDr="",I=1
	..IF ((OrdCatRLoc="各个科室E")&(ChangeType'="Test"))  D
	...f  s RLocDr=$o(^PAC("ADMLOC",0,"AdmType","O",RLocDr)) q:RLocDr=""  d
	....s hosdr=$P(^CTLOC(RLocDr),del,22)
	....q:hosdr'=3  //东院
    ....s stop=$P(^CTLOC(RLocDr),del,25)
	....q:stop'="" //院
    ....s Para=OrdCatDr_del_RLocDr_del_RLocDr
	....s ExistFlag=..OrdCatRlocExitHosp(Para)
	....q:ExistFlag=1
	....k PLIST
	....s PLIST(6)="Y"
	....SET PLIST(0)=OrdCatDr,PLIST(3)=RLocDr,PLIST(4)=RLocDr,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..IF ((OrdCatRLoc'["各个病房")&((OrdCatRLoc'["各个科室")&(OrdCatRLoc'["临床科室"))&(ChangeType'="Test")) d
	...
	...SET I=1,j=1
	...FOR  SET RLOC=$P(OrdCatRLoc,"/",j) Q:RLOC=""  D
	....s j=j+1
	....s ^fhq(j,I)=OrdCatPatLoc_","_RLOC
	....q:RLOC=""
	....if '$d(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RLOC))) s RetStr=..RetErrorValue(RetStr,"取接收科室指针出错ARC_ITEMCATRECLOC "_RLOC)
	....q:'$d(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RLOC)))
	....SET RLOCDR=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RLOC),""))
	....if RLOCDR="" s RetStr=..RetErrorValue(RetStr,"取接收科室指针出错OEC_ORDERCATEGORY "_RLOC) q
	....IF ((OrdCatPatLoc="各个病房")&(ChangeType'="Test")) D
	.....s WardId=0
	.....FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	......q:($P(^CTLOC(WardId),del,13)'="W")
	......s Para=OrdCatDr_del_WardId_del_RLOCDR
	......s ExistFlag=..OrdCatRlocExitHosp(Para)
	......q:ExistFlag=1
	......K PLIST
	......s PLIST(6)="Y"
	......SET PLIST(0)=OrdCatDr,PLIST(3)=RLOCDR,PLIST(4)=WardId,PLIST(5)="Execute",PLIST(10)=+$H
	......&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	......IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	....IF ((OrdCatPatLoc="各个病房W")&(ChangeType'="Test")) D
	.....s WardId=0
	.....FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	......q:($P(^CTLOC(WardId),del,13)'="W")
	......s hosdr=$P(^CTLOC(WardId),del,22)
	......q:hosdr'=2  //西院
    ......s stop=$P(^CTLOC(WardId),del,25)
	......q:stop'="" //院
    ......s Para=OrdCatDr_del_WardId_del_RLOCDR
	......s ExistFlag=..OrdCatRlocExitHosp(Para)
	......q:ExistFlag=1
	......K PLIST
	......s PLIST(6)="Y"
	......SET PLIST(0)=OrdCatDr,PLIST(3)=RLOCDR,PLIST(4)=WardId,PLIST(5)="Execute",PLIST(10)=+$H
	......&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	......IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	....IF ((OrdCatPatLoc="各个病房E")&(ChangeType'="Test")) D
	.....s WardId=0
	.....FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	......q:($P(^CTLOC(WardId),del,13)'="W")
	......s hosdr=$P(^CTLOC(WardId),del,22)
	......q:hosdr'=3  //院
    ......s stop=$P(^CTLOC(WardId),del,25)
	......q:stop'="" //院
    ......s Para=OrdCatDr_del_WardId_del_RLOCDR
	......s ExistFlag=..OrdCatRlocExitHosp(Para)
	......q:ExistFlag=1
	......K PLIST
	......s PLIST(6)="Y"
	......SET PLIST(0)=OrdCatDr,PLIST(3)=RLOCDR,PLIST(4)=WardId,PLIST(5)="Execute",PLIST(10)=+$H
	......&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	......IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	....
	....IF ((OrdCatPatLoc="各个科室")&(ChangeType'="Test")) D
	.....s PatLocDr=""
	.....f  s PatLocDr=$o(^PAC("ADMLOC",0,"AdmType","O",PatLocDr)) q:PatLocDr=""  d
	......s Para=OrdCatDr_del_PatLocDr_del_RLOCDR
	......s ExistFlag=..OrdCatRlocExitHosp(Para)
	......q:ExistFlag=1
	......k PLIST
	......s PLIST(6)="Y"
	......SET PLIST(0)=OrdCatDr,PLIST(3)=RLOCDR,PLIST(4)=PatLocDr,PLIST(5)="Execute",PLIST(10)=+$H
	......&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	......IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	....IF ((OrdCatPatLoc="各个科室W")&(ChangeType'="Test")) D
	.....s PatLocDr=""
	.....f  s PatLocDr=$o(^PAC("ADMLOC",0,"AdmType","O",PatLocDr)) q:PatLocDr=""  d
	......s hosdr=$P(^CTLOC(PatLocDr),del,22)
	......q:hosdr'=2  //西院
    ......s stop=$P(^CTLOC(PatLocDr),del,25)
	......q:stop'="" //院
    ......s Para=OrdCatDr_del_PatLocDr_del_RLOCDR
	......s ExistFlag=..OrdCatRlocExitHosp(Para)
	......q:ExistFlag=1
	......k PLIST
	......s PLIST(6)="Y"
	......SET PLIST(0)=OrdCatDr,PLIST(3)=RLOCDR,PLIST(4)=PatLocDr,PLIST(5)="Execute",PLIST(10)=+$H
	......&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	......IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	....IF ((OrdCatPatLoc="各个科室E")&(ChangeType'="Test")) D
	.....s PatLocDr=""
	.....f  s PatLocDr=$o(^PAC("ADMLOC",0,"AdmType","O",PatLocDr)) q:PatLocDr=""  d
	......s hosdr=$P(^CTLOC(PatLocDr),del,22)
	......q:hosdr'=3  //院
    ......s stop=$P(^CTLOC(PatLocDr),del,25)
	......q:stop'="" //院
    ......s Para=OrdCatDr_del_PatLocDr_del_RLOCDR
	......s ExistFlag=..OrdCatRlocExitHosp(Para)
	......q:ExistFlag=1
	......k PLIST
	......s PLIST(6)="Y"
	......SET PLIST(0)=OrdCatDr,PLIST(3)=RLOCDR,PLIST(4)=PatLocDr,PLIST(5)="Execute",PLIST(10)=+$H
	......&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	......IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	....IF ((OrdCatPatLoc="")&(ChangeType'="Test")) D
	.....s Para=OrdCatDr_del_RLOCDR_del_RLOCDR
	.....s ExistFlag=..OrdCatRlocExitHosp(Para)
	.....q:ExistFlag=1
	.....k PLIST
	.....s PLIST(6)="Y"
	.....SET PLIST(0)=OrdCatDr,PLIST(3)=RLOCDR,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	.....&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	.....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	....IF ((OrdCatPatLoc="全部科室")&(ChangeType'="Test")) D
	.....s Para=OrdCatDr_del_""_del_RLOCDR
	.....s ExistFlag=..OrdCatRlocExitHosp(Para)
	.....q:ExistFlag=1
	.....k PLIST
	.....s PLIST(6)="Y"
	.....SET PLIST(0)=OrdCatDr,PLIST(3)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	.....&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	.....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	....IF ((OrdCatPatLoc="全部科室E")&(ChangeType'="Test")) D
	.....s WardId=0
	.....FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	......s hosdr=$P(^CTLOC(WardId),del,22)
	......q:hosdr'=3 //院
    ......s stop=$P(^CTLOC(WardId),del,25)
	......q:stop'="" //院
    ......s Para=OrdCatDr_del_WardId_del_RLOCDR
	......s ExistFlag=..OrdCatRlocExitHosp(Para)
	......q:ExistFlag=1
	......K PLIST
	......s PLIST(6)="Y"
	......SET PLIST(0)=OrdCatDr,PLIST(3)=RLOCDR,PLIST(4)=WardId,PLIST(5)="Execute",PLIST(10)=+$H
	......&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	......IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	....IF ((OrdCatPatLoc="全部科室W")&(ChangeType'="Test")) D
	.....s WardId=0
	.....FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	......s hosdr=$P(^CTLOC(WardId),del,22)
	......q:hosdr'=2  //院
    ......s stop=$P(^CTLOC(WardId),del,25)
	......q:stop'="" //院
    ......s Para=OrdCatDr_del_WardId_del_RLOCDR
	......s ExistFlag=..OrdCatRlocExitHosp(Para)
	......q:ExistFlag=1
	......K PLIST
	......s PLIST(6)="Y"
	......SET PLIST(0)=OrdCatDr,PLIST(3)=RLOCDR,PLIST(4)=WardId,PLIST(5)="Execute",PLIST(10)=+$H
	......&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	......IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	....IF ((OrdCatPatLoc'["各个病房")&(OrdCatPatLoc'["全部科室")&(OrdCatPatLoc'["各个科室")) D
	.....
	.....SET PLOC=$P(OrdCatPatLoc,"/",j-1) 
	.....s ^fhq(j)=PLOC
	.....if ((PLOC="全部科室")!(PLOC="*")) d
	......
	.....else  d
	......SET PLOCDR=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(PLOC),""))
	......if PLOCDR="" s RetStr=..RetErrorValue(RetStr,"取病人科室指针出错OEC_ORDERCATEGORY "_PLOC) q
	.....if ChangeType'="Test" d
	.....s Para=OrdCatDr_del_""_del_RLOCDR
	.....s ExistFlag=..OrdCatRlocExitHosp(Para)
	.....q:ExistFlag=1
	.....K PLIST
	.....s:(I=1) PLIST(6)="Y"
	.....s:PLOC'="全部科室" PLIST(4)=PLOCDR
	.....SET PLIST(0)=OrdCatDr,PLIST(3)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	.....&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	.....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_PLOC_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..SET I=I+1
	
	;医嘱子类
	S SubCode=$P(RowStr,del,6),SubDesc=$P(RowStr,del,7)
	//if +SubCode=0 s SubCode=""
	if SubCode="" d
	.s SubCodeTmp=$o(^ARC("IC",0,"Code",OrdCatCode_"99"),-1)
	.if $g(SubCodeTmp)'="" d
	..if $e(SubCodeTmp,1,3)=$e(OrdCatCode,1,3) s SubCode=SubCodeTmp+1
	..if $e(SubCodeTmp,1,3)'=$e(OrdCatCode,1,3) s SubCode=OrdCatCode_"01"
	.if $g(SubCodeTmp)="" s SubCode=OrdCatCode_"01"
	Q:SubCode="" ..RetErrorValue(RetStr,"医嘱子类代码为空ARC_ItemCat")
	q:SubDesc="" ..RetErrorValue(RetStr,"医嘱子类名称为空ARC_ItemCat")
	SET CodeDr=$o(^OEC("ORCAT",0,"Desc",$$ALPHAUP^SSUTIL4(OrdCatDesc),"")) 
	q:CodeDr="" ..RetErrorValue(RetStr,"取医嘱大类名称指针出错ARC_ItemCat")
	s ORDTYPE=$$ALPHAUP^SSUTIL4($p(RowStr,del,9))
	q:ORDTYPE="" ..RetErrorValue(RetStr,"医嘱类型为空ARC_ItemCat"_SubCode)
	s ORDERTYPEDR=$s(ORDTYPE["DRUG":"R",ORDTYPE["DIET":"D",ORDTYPE["IV":"I",ORDTYPE["CONS":"C",ORDTYPE["NORM":"N",ORDTYPE["DENT":"T",ORDTYPE["LABT":"L",ORDTYPE["REHA":"X",ORDTYPE["PRIC":"P",1:"Z") 
	q:ORDERTYPEDR="Z" ..RetErrorValue(RetStr,"取医嘱类型出错ARC_ItemCat"_SubDesc_","_ORDTYPE)
	s RESULT=$P(RowStr,del,8)
	q:RESULT ..RetErrorValue(RetStr,"医嘱执行类型为空ARC_ItemCat "_RESULT)
	if RESULT'="" s RESULTDR=$o(^OEC("EXEC",0,"Desc",$$ALPHAUP^SSUTIL4(RESULT),"")) 
	q:RESULTDR="" ..RetErrorValue(RetStr,"取执行类型出错ARC_ItemCat "_SubCode_","_$g(RESULT))
	s CALQTY=$P(RowStr,del,10)
	s:$g(CALQTY)="" CALQTY=""
	s:(($g(CALQTY)'="Y")&(CALQTY'="N")) CALQTY="N"
	b ////
	IF ($D(^ARC("IC",0,"Code",$$ALPHAUP^SSUTIL4(SubCode)))&('$D(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(SubDesc))))) s RetStr=..RetErrorValue(RetStr,"嘱子类编码已经存在ARC_ItemCat"_SubCode)
	IF ($D(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(SubDesc)))&('$D(^ARC("IC",0,"Code",$$ALPHAUP^SSUTIL4(SubCode))))) s RetStr=..RetErrorValue(RetStr,"嘱子类名称已经存在ARC_ItemCat"_SubDesc)
	if ((ChangeType'="Test")&('$D(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(SubDesc))))&('$D(^ARC("IC",0,"Code",$$ALPHAUP^SSUTIL4(SubCode))))) d
	.k PLIST
	.s PLIST(2)=SubCode,PLIST(3)=SubDesc,PLIST(9)=CodeDr,PLIST(8)=ORDERTYPEDR,PLIST(10)=RESULTDR,PLIST(12)=CALQTY
	.&SQL(INSERT INTO SQLUser.ARC_ItemCat VALUES :PLIST())
	.i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"ARC_ItemCat -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	//医嘱子类接收科室
	s RecLoc=$P(RowStr,del,11),PatLoc=$P(RowStr,del,12)
     b ;lxs
	q:(($g(RecLoc)="")&($g(PatLoc)="")) RetStr
	SET SubCatDr=$O(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(SubDesc),""))
	q:SubCatDr="" ..RetErrorValue(RetStr,"医嘱子类指针出错ARC_ITEMCATRECLOC "_SubCode)
	;q:RecLoc="" ..RetErrorValue(RetStr,"接收科室为空ARC_ITEMCATRECLOC "_SubCode)
	;Q:PatLoc="" ..RetErrorValue(RetStr,"病人科室为空ARC_ITEMCATRECLOC "_SubCode)
	
	SET WardId=$O(^CTLOC(0)),I=1
	IF ((RecLoc="各个病房")&(ChangeType'="Test"))  D
	.b ;各个病房R
	.FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	..q:($P(^CTLOC(WardId),del,13)'="W")
	..K PLIST
	..s PLIST(6)="Y"
	..s Para=SubCatDr_del_WardId_del_WardId
	..s ExistFlag=..ArcCatRlocExit(Para)
	..q:ExistFlag=1
	..SET PLIST(0)=SubCatDr,PLIST(3)=WardId,PLIST(4)=WardId,PLIST(5)="Execute",PLIST(10)=+$H
	..&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	..IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	SET WardId=$O(^CTLOC(0)),I=1
	IF ((RecLoc="各个病房W")&(ChangeType'="Test"))  D
	.b ;各个病房WR
	.FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	..q:($P(^CTLOC(WardId),del,13)'="W")
	..s hosdr=$P(^CTLOC(WardId),del,22)
	..q:hosdr'=2  //院
    ..s stop=$P(^CTLOC(WardId),del,25)
	..q:stop'="" //院
	..K PLIST
	..s PLIST(6)="Y"
	..s Para=SubCatDr_del_WardId_del_WardId
	..s ExistFlag=..ArcCatRlocExit(Para)
	..q:ExistFlag=1
	..SET PLIST(0)=SubCatDr,PLIST(3)=WardId,PLIST(4)=WardId,PLIST(5)="Execute",PLIST(10)=+$H
	..&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	..IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	SET WardId=$O(^CTLOC(0)),I=1
	IF ((RecLoc="各个病房E")&(ChangeType'="Test"))  D
	.b ;各个病房ER
	.FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	..q:($P(^CTLOC(WardId),del,13)'="W")
	..s hosdr=$P(^CTLOC(WardId),del,22)
	..q:hosdr'=3  //院
    ..s stop=$P(^CTLOC(WardId),del,25)
	..q:stop'="" //院
    ..K PLIST
	..s PLIST(6)="Y"
	..s Para=SubCatDr_del_WardId_del_WardId
	..s ExistFlag=..ArcCatRlocExit(Para)
	..q:ExistFlag=1
	..SET PLIST(0)=SubCatDr,PLIST(3)=WardId,PLIST(4)=WardId,PLIST(5)="Execute",PLIST(10)=+$H
	..&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	..IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	
	s RLocDr=""
	IF ((RecLoc="各个科室")&(ChangeType'="Test"))  D
	.b ;各个科室R
	.f  s RLocDr=$o(^PAC("ADMLOC",0,"AdmType","O",RLocDr)) q:RLocDr=""  d
	..k PLIST
	..s PLIST(6)="Y"
	..s Para=SubCatDr_del_RLocDr_del_RLocDr
	..s ExistFlag=..ArcCatRlocExit(Para)
	..q:ExistFlag=1
	..SET PLIST(0)=SubCatDr,PLIST(3)=RLocDr,PLIST(4)=RLocDr,PLIST(5)="Execute",PLIST(10)=+$H
	..&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	..IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	s RLocDr=""
	IF ((RecLoc="各个科室W")&(ChangeType'="Test"))  D
	.b ;各个科室WR
	.f  s RLocDr=$o(^PAC("ADMLOC",0,"AdmType","O",RLocDr)) q:RLocDr=""  d
	..k PLIST
	..s hosdr=$P(^CTLOC(RLocDr),del,22)
	..q:hosdr'=2  //院
    ..s stop=$P(^CTLOC(RLocDr),del,25)
	..q:stop'="" //院
	..s PLIST(6)="Y"
	..s Para=SubCatDr_del_RLocDr_del_RLocDr
	..s ExistFlag=..ArcCatRlocExit(Para)
	..q:ExistFlag=1
	..SET PLIST(0)=SubCatDr,PLIST(3)=RLocDr,PLIST(4)=RLocDr,PLIST(5)="Execute",PLIST(10)=+$H
	..&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	..IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	s RLocDr=""
	IF ((RecLoc="各个科室E")&(ChangeType'="Test"))  D
	.b ;各个科室ER
	.f  s RLocDr=$o(^PAC("ADMLOC",0,"AdmType","O",RLocDr)) q:RLocDr=""  d
	..k PLIST
	..s hosdr=$P(^CTLOC(RLocDr),del,22)
	..q:hosdr'=3  //院
    ..s stop=$P(^CTLOC(RLocDr),del,25)
	..q:stop'="" //院
    ..s PLIST(6)="Y"
	..s Para=SubCatDr_del_RLocDr_del_RLocDr
	..s ExistFlag=..ArcCatRlocExit(Para)
	..q:ExistFlag=1
	..SET PLIST(0)=SubCatDr,PLIST(3)=RLocDr,PLIST(4)=RLocDr,PLIST(5)="Execute",PLIST(10)=+$H
	..&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	..IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	s RLocDr=""
	IF ((RecLoc="临床科室")&(ChangeType'="Test"))  D
	.b ;临床科室R
	.f  s RLocDr=$o(^PAC("ADMLOC",0,"AdmType","I",RLocDr)) q:RLocDr=""  d
	..q:('$d(^CTLOC(RLocDr,"LINK")))
    ..s stop=$P(^CTLOC(RLocDr),del,25)
	..q:stop'="" //院
	..k PLIST
	..s PLIST(6)="Y"
	..s Para=SubCatDr_del_RLocDr_del_RLocDr
	..s ExistFlag=..ArcCatRlocExit(Para)
	..q:ExistFlag=1
	..SET PLIST(0)=SubCatDr,PLIST(3)=RLocDr,PLIST(4)=RLocDr,PLIST(5)="Execute",PLIST(10)=+$H
	..&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	..IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	s RLocDr=""
	IF ((RecLoc="临床科室E")&(ChangeType'="Test"))  D
	.b ;临床科室ER
	.f  s RLocDr=$o(^PAC("ADMLOC",0,"AdmType","I",RLocDr)) q:RLocDr=""  d
	..q:('$d(^CTLOC(RLocDr,"LINK")))
	..s hosdr=$P(^CTLOC(RLocDr),del,22)
	..q:hosdr'=3  //院
    ..s stop=$P(^CTLOC(RLocDr),del,25)
	..q:stop'="" //院
    ..k PLIST
	..s PLIST(6)="Y"
	..s Para=SubCatDr_del_RLocDr_del_RLocDr
	..s ExistFlag=..ArcCatRlocExit(Para)
	..q:ExistFlag=1
	..SET PLIST(0)=SubCatDr,PLIST(3)=RLocDr,PLIST(4)=RLocDr,PLIST(5)="Execute",PLIST(10)=+$H
	..&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	..IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	s RLocDr=""
	IF ((RecLoc="临床科室W")&(ChangeType'="Test"))  D
	.b ;临床科室WR
	.f  s RLocDr=$o(^PAC("ADMLOC",0,"AdmType","I",RLocDr)) q:RLocDr=""  d
	..q:('$d(^CTLOC(RLocDr,"LINK")))
	..s hosdr=$P(^CTLOC(RLocDr),del,22)
	..q:hosdr'=2  //院
    ..s stop=$P(^CTLOC(RLocDr),del,25)
	..q:stop'="" //院
	..k PLIST
	..s PLIST(6)="Y"
	..s Para=SubCatDr_del_RLocDr_del_RLocDr
	..s ExistFlag=..ArcCatRlocExit(Para)
	..q:ExistFlag=1
	..SET PLIST(0)=SubCatDr,PLIST(3)=RLocDr,PLIST(4)=RLocDr,PLIST(5)="Execute",PLIST(10)=+$H
	..&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	..IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))


	IF ((RecLoc'["各个病房")&(RecLoc'["各个科室")&(RecLoc'["临床科室")&(ChangeType'="Test")) d
	.SET I=1,j=1
	.FOR  SET RLOC=$P(RecLoc,"/",j) Q:RLOC=""  D
	..s j=j+1
	..q:RLOC=""
	..s RLOC=$$ALPHAUP^SSUTIL4(RLOC)
	..if '$d(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RLOC))) s RetStr=..RetErrorValue(RetStr,"取接收科室指针出错ARC_ITEMCATRECLOC "_RLOC)
	..q:'$d(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RLOC)))
	..SET RLOCDR=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RLOC),""))
	..if RLOCDR="" s RetStr=..RetErrorValue(RetStr,"取接收科室指针出错ARC_ITEMCATRECLOC "_RLOC) q
	..IF ((PatLoc="各个病房")&(ChangeType'="Test")) D
	...b ;各个病房P
	...s WardId=0
	...FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	....q:($P(^CTLOC(WardId),del,13)'="W")
    ....s stop=$P(^CTLOC(WardId),del,25)
	....q:stop'="" //院
	....K PLIST
	....s PLIST(6)="Y"
	....s Para=SubCatDr_del_WardId_del_RLOCDR
	....s ExistFlag=..ArcCatRlocExit(Para)
	....q:ExistFlag=1
	....SET PLIST(0)=SubCatDr,PLIST(3)=WardId,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.ARC_ITEMCATRECLOC VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..IF ((PatLoc="各个病房W")&(ChangeType'="Test")) D
	...b ;各个病房WP
	...s WardId=0
	...FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	....q:($P(^CTLOC(WardId),del,13)'="W")
	....s hosdr=$P(^CTLOC(WardId),del,22)
	....q:hosdr'=2  //院
    ....s stop=$P(^CTLOC(WardId),del,25)
	....q:stop'="" //院
    ....K PLIST
	....s PLIST(6)="Y"
	....s Para=SubCatDr_del_WardId_del_RLOCDR
	....s ExistFlag=..ArcCatRlocExit(Para)
	....q:ExistFlag=1
	....SET PLIST(0)=SubCatDr,PLIST(3)=WardId,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.ARC_ITEMCATRECLOC VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..IF ((PatLoc="各个病房E")&(ChangeType'="Test")) D
	...b ;各个病房EP
	...s WardId=0
	...FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	....q:($P(^CTLOC(WardId),del,13)'="W")
	....b ;;各个病房EP -W
	....s hosdr=$P(^CTLOC(WardId),del,22)
	....q:hosdr'=3  //院
    ....s stop=$P(^CTLOC(WardId),del,25)
	....q:stop'="" //院
	....K PLIST
	....s PLIST(6)="Y"
	....s Para=SubCatDr_del_WardId_del_RLOCDR
	....s ExistFlag=..ArcCatRlocExit(Para)
	....q:ExistFlag=1
	....SET PLIST(0)=SubCatDr,PLIST(3)=WardId,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.ARC_ITEMCATRECLOC VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..
	..s PatLocDr=""
	..IF ((PatLoc="各个科室")&(ChangeType'="Test")) D
	...b ;各个科室P
	...f  s PatLocDr=$o(^PAC("ADMLOC",0,"AdmType","O",PatLocDr)) q:PatLocDr=""  d
	....k PLIST
    ....s stop=$P(^CTLOC(PatLocDr),del,25)
	....q:stop'="" //院
	....s:(I=1) PLIST(6)="Y"
	....s Para=SubCatDr_del_PatLocDr_del_RLOCDR
	....s ExistFlag=..ArcCatRlocExit(Para)
	....q:ExistFlag=1
	....SET PLIST(0)=SubCatDr,PLIST(3)=PatLocDr,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..s PatLocDr=""
	..IF ((PatLoc="各个科室E")&(ChangeType'="Test")) D
	...b ;各个科室EP
	...f  s PatLocDr=$o(^PAC("ADMLOC",0,"AdmType","O",PatLocDr)) q:PatLocDr=""  d
	....k PLIST
	....s hosdr=$P(^CTLOC(PatLocDr),del,22)
	....q:hosdr'=3  //院
    ....s stop=$P(^CTLOC(PatLocDr),del,25)
	....q:stop'="" //院
    ....s:(I=1) PLIST(6)="Y"
	....s Para=SubCatDr_del_PatLocDr_del_RLOCDR
	....s ExistFlag=..ArcCatRlocExit(Para)
	....q:ExistFlag=1
	....SET PLIST(0)=SubCatDr,PLIST(3)=PatLocDr,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..s PatLocDr=""
	..IF ((PatLoc="各个科室W")&(ChangeType'="Test")) D
	...b ;各个科室WP
	...f  s PatLocDr=$o(^PAC("ADMLOC",0,"AdmType","O",PatLocDr)) q:PatLocDr=""  d
	....k PLIST
	....s:(I=1) PLIST(6)="Y"
	....s hosdr=$P(^CTLOC(PatLocDr),del,22)
	....q:hosdr'=2  //院
    ....s stop=$P(^CTLOC(PatLocDr),del,25)
	....q:stop'="" //院
	....s Para=SubCatDr_del_PatLocDr_del_RLOCDR
	....s ExistFlag=..ArcCatRlocExit(Para)
	....q:ExistFlag=1
	....SET PLIST(0)=SubCatDr,PLIST(3)=PatLocDr,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..s PatLocDr=""
	..IF ((PatLoc="临床科室")&(ChangeType'="Test")) D
	...b ;临床科室P
	...f  s PatLocDr=$o(^PAC("ADMLOC",0,"AdmType","I",PatLocDr)) q:PatLocDr=""  d
	....q:('$d(^CTLOC(PatLocDr,"LINK")))
    ....s stop=$P(^CTLOC(PatLocDr),del,25)
	....q:stop'="" //院
	....k PLIST
	....s:(I=1) PLIST(6)="Y"
	....s Para=SubCatDr_del_PatLocDr_del_RLOCDR
	....s ExistFlag=..ArcCatRlocExit(Para)
	....q:ExistFlag=1
	....SET PLIST(0)=SubCatDr,PLIST(3)=PatLocDr,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..s PatLocDr=""
	..IF ((PatLoc="临床科室E")&(ChangeType'="Test")) D
	...b ;临床科室EP
	...f  s PatLocDr=$o(^PAC("ADMLOC",0,"AdmType","I",PatLocDr)) q:PatLocDr=""  d
	....q:('$d(^CTLOC(PatLocDr,"LINK")))
	....s hosdr=$P(^CTLOC(PatLocDr),del,22)
	....q:hosdr'=3  //院
    ....s stop=$P(^CTLOC(PatLocDr),del,25)
	....q:stop'="" //院
	....k PLIST
	....s:(I=1) PLIST(6)="Y"
	....s Para=SubCatDr_del_PatLocDr_del_RLOCDR
	....s ExistFlag=..ArcCatRlocExit(Para)
	....q:ExistFlag=1
	....SET PLIST(0)=SubCatDr,PLIST(3)=PatLocDr,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..s PatLocDr=""
	..IF ((PatLoc="临床科室W")&(ChangeType'="Test")) D
	...b ;临床科室WP
	...f  s PatLocDr=$o(^PAC("ADMLOC",0,"AdmType","I",PatLocDr)) q:PatLocDr=""  d
	....q:('$d(^CTLOC(PatLocDr,"LINK")))
	....k PLIST
	....s hosdr=$P(^CTLOC(PatLocDr),del,22)
	....q:hosdr'=2  //院
    ....s stop=$P(^CTLOC(PatLocDr),del,25)
	....q:stop'="" //院
    ....s:(I=1) PLIST(6)="Y"
	....s Para=SubCatDr_del_PatLocDr_del_RLOCDR
	....s ExistFlag=..ArcCatRlocExit(Para)
	....q:ExistFlag=1
	....SET PLIST(0)=SubCatDr,PLIST(3)=PatLocDr,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..IF ((PatLoc="全部科室")&(ChangeType'="Test")) D
	...b ;全部科室
	...k PLIST
	...s:(I=1) PLIST(6)="Y"
	...s Para=SubCatDr_del_""_del_RLOCDR
	...s ExistFlag=..ArcCatRlocExit(Para)
	...q:ExistFlag=1
	...SET PLIST(0)=SubCatDr,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	...&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	...IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..IF ((PatLoc="全部科室E")&(ChangeType'="Test")) D
	...b ;全部科室E
	...s WardId=0
	...FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	....K PLIST
	....s hosdr=$P(^CTLOC(WardId),del,22)
	....q:hosdr'=3  //院
    ....s stop=$P(^CTLOC(WardId),del,25)
	....q:stop'="" //院
	....s PLIST(6)="Y"
	....s Para=SubCatDr_del_WardId_del_RLOCDR
	....s ExistFlag=..ArcCatRlocExit(Para)
	....q:ExistFlag=1
	....SET PLIST(0)=SubCatDr,PLIST(3)=WardId,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.ARC_ITEMCATRECLOC VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..IF ((PatLoc="全部科室W")&(ChangeType'="Test")) D
	...b ;全部科室W
	...s WardId=0
	...FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	....K PLIST
	....s PLIST(6)="Y"
	....s hosdr=$P(^CTLOC(WardId),del,22)
	....q:hosdr'=2  //院
    ....s stop=$P(^CTLOC(WardId),del,25)
	....q:stop'="" //院
	....s Para=SubCatDr_del_WardId_del_RLOCDR
	....s ExistFlag=..ArcCatRlocExit(Para)
	....q:ExistFlag=1
	....SET PLIST(0)=SubCatDr,PLIST(3)=WardId,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.ARC_ITEMCATRECLOC VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..IF ((PatLoc="")&(ChangeType'="Test")) D
	...K PLIST
	...s PLIST(6)="Y"
	...s Para=SubCatDr_del_RLOCDR_del_RLOCDR
	...s ExistFlag=..ArcCatRlocExit(Para)
	...q:ExistFlag=1
	...SET PLIST(0)=SubCatDr,PLIST(3)=RLOCDR,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	...&SQL(INSERT INTO SQLUser.ARC_ITEMCATRECLOC VALUES :PLIST())
	...IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..IF ((PatLoc'["各个病房")&(PatLoc'["全部科室")&(PatLoc'["各个科室")) D
	...b ;lllll
	...s jj=1
	...FOR  SET PLOC=$P(PatLoc,"/",jj) Q:PLOC=""  D
	....s jj=jj+1
	....SET PLOCDR=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(PLOC),""))
	....if PLOCDR="" s RetStr=..RetErrorValue(RetStr,"取病人科室指针出错ARC_ITEMCATRECLOC "_SubDesc_" "_PLOC) q
	....if ChangeType'="Test" d
	.....K PLIST
	.....s PLIST(6)="Y"
	.....s Para=SubCatDr_del_PLOCDR_del_RLOCDR
	.....s ExistFlag=..ArcCatRlocExit(Para)
	.....q:ExistFlag=1
	.....s PLIST(3)=PLOCDR
	.....SET PLIST(0)=SubCatDr,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	.....&SQL(INSERT INTO SQLUser.ARC_ITEMCATRECLOC VALUES :PLIST())
	.....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_PLOC_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..SET I=I+1
	q:RetStr="" "Ok"
	q RetStr
}

/// 医嘱子类
ClassMethod OrdCat(ChangeType As %String = "", RowStr As %String = "") As %String
{

	IF ChangeType="Clear" K ^OEC("ORCAT"),^ARC("IC")
	q:ChangeType="Clear" "数据已清:医嘱大类和医嘱子类"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	s OrdCatGroupCode=$P(RowStr,del,1)
	if OrdCatGroupCode'="" d
	.s OrdCatGroupId=$o(^OEC("OCGRP",0,"Code",$$ALPHAUP^SSUTIL4(OrdCatGroupCode),""))
	.if $g(OrdCatGroupId)=""  s RetStr=RetErrorValue(RetStr,"医嘱大类分组代码为空"_OrdCatGroupCode)
	S OrdCatCode=$P(RowStr,del,2),OrdCatDesc=$P(RowStr,del,3)
	;if +OrdCatCode=0 s OrdCatCode=""
	if $g(OrdCatCode)="" d
	.S OrdCatCodeTmp=$o(^OEC("ORCAT",0,"Code","99"),-1)
	.if $g(OrdCatCodeTmp)'="" s OrdCatCode=OrdCatCodeTmp+1
	.if $g(OrdCatCodeTmp)="" s OrdCatCode="01"
	Q:OrdCatCode="" ..RetErrorValue(RetStr,"医嘱大类代码为空OEC_ORDERCATEGORY")
	q:OrdCatDesc="" ..RetErrorValue(RetStr,"医嘱大类名称为空OEC_ORDERCATEGORY")
	s OrdCatPatLoc=$P(RowStr,del,4),OrdCatRLoc=$P(RowStr,del,5)
	if ('$D(^OEC("ORCAT",0,"Desc",$$ALPHAUP^SSUTIL4(OrdCatDesc)))) d
	.;if $D(^OEC("ORCAT",0,"Code",$$ALPHAUP^SSUTIL4(Code))) s RetStr=..RetErrorValue(RetStr,"医嘱大类代码已经存在OEC_ORDERCATEGORY") q
	.;IF $D(^OEC("ORCAT",0,"Desc",$$ALPHAUP^SSUTIL4(Desc))) s RetStr=..RetErrorValue(RetStr,"医嘱大类名称已经存在OEC_ORDERCATEGORY") q
	.if ChangeType'="Test" d
	..K PLIST
	..S PLIST(2)=OrdCatCode,PLIST(3)=OrdCatDesc,PLIST(16)=$g(OrdCatGroupId)
	..&SQL(INSERT INTO SQLUser.OEC_ORDERCATEGORY VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"OEC_ORDERCATEGORY -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	s OrdCatDr=$o(^OEC("ORCAT",0,"Desc",$$ALPHAUP^SSUTIL4(OrdCatDesc),""))
	s OrdCatCode=$e($p(^OEC("ORCAT",OrdCatDr),del,1),1,2)
	//医嘱大类接收科室
	if ($G(OrdCatDr)'="") d
	.q:(($g(OrdCatPatLoc)="")&($g(OrdCatRLoc)=""))
	.s OrdCatRlocId=0
	.if $g(OrdCatDr)'="" d
	..;q:$d(^OEC("ORCAT",OrdCatDr,"RL"))
	..IF ((OrdCatRLoc="各个病房")&(ChangeType'="Test"))  D
	...s WardId=0
	...FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	....q:($P(^CTLOC(WardId),del,13)'="W")
	....s Para=OrdCatDr_del_WardId_del_WardId
	....s ExistFlag=..OrdCatRlocExit(Para)
	....q:ExistFlag=1
	....K PLIST
	....s PLIST(6)="Y"
	....SET PLIST(0)=OrdCatDr,PLIST(3)=WardId,PLIST(4)=WardId,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..s RLocDr="",I=1
	..IF ((OrdCatRLoc="临床科室")&(ChangeType'="Test"))  D
	...f  s RLocDr=$o(^PAC("ADMLOC",0,"AdmType","I",RLocDr)) q:RLocDr=""  d
	....q:('$d(^CTLOC(RLocDr,"LINK")))
	....s Para=OrdCatDr_del_RLocDr_del_RLocDr
	....s ExistFlag=..OrdCatRlocExit(Para)
	....q:ExistFlag=1
	....k PLIST
	....s PLIST(6)="Y"
	....SET PLIST(0)=OrdCatDr,PLIST(3)=RLocDr,PLIST(4)=RLocDr,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..s RLocDr="",I=1
	..IF ((OrdCatRLoc="各个科室")&(ChangeType'="Test"))  D
	...f  s RLocDr=$o(^PAC("ADMLOC",0,"AdmType","O",RLocDr)) q:RLocDr=""  d
	....s Para=OrdCatDr_del_RLocDr_del_RLocDr
	....s ExistFlag=..OrdCatRlocExit(Para)
	....q:ExistFlag=1
	....k PLIST
	....s PLIST(6)="Y"
	....SET PLIST(0)=OrdCatDr,PLIST(3)=RLocDr,PLIST(4)=RLocDr,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..IF ((OrdCatRLoc'="各个病房")&((OrdCatRLoc'="各个科室")&(OrdCatRLoc'="临床科室"))&(ChangeType'="Test")) d
	...
	...SET I=1,j=1
	...FOR  SET RLOC=$P(OrdCatRLoc,"/",j) Q:RLOC=""  D
	....s j=j+1
	....s ^fhq(j,I)=RLOC
	....q:RLOC=""
	....if '$d(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RLOC))) s RetStr=..RetErrorValue(RetStr,"取接收科室指针出错ARC_ITEMCATRECLOC "_RLOC)
	....q:'$d(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RLOC)))
	....SET RLOCDR=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RLOC),""))
	....if RLOCDR="" s RetStr=..RetErrorValue(RetStr,"取接收科室指针出错OEC_ORDERCATEGORY "_RLOC) q
	....IF ((OrdCatPatLoc="各个病房")&(ChangeType'="Test")) D
	.....s WardId=0
	.....FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	......q:($P(^CTLOC(WardId),del,13)'="W")
	......s Para=OrdCatDr_del_WardId_del_RLOCDR
	......s ExistFlag=..OrdCatRlocExit(Para)
	......q:ExistFlag=1
	......K PLIST
	......s PLIST(6)="Y"
	......SET PLIST(0)=OrdCatDr,PLIST(3)=RLOCDR,PLIST(4)=WardId,PLIST(5)="Execute",PLIST(10)=+$H
	......&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	......IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	....s PatLocDr=""
	....IF ((OrdCatPatLoc="各个科室")&(ChangeType'="Test")) D
	.....f  s PatLocDr=$o(^PAC("ADMLOC",0,"AdmType","O",PatLocDr)) q:RLocDr=""  d
	......s Para=OrdCatDr_del_PatLocDr_del_RLOCDR
	......s ExistFlag=..OrdCatRlocExit(Para)
	......q:ExistFlag=1
	......k PLIST
	......s PLIST(6)="Y"
	......SET PLIST(0)=OrdCatDr,PLIST(3)=RLOCDR,PLIST(4)=PatLocDr,PLIST(5)="Execute",PLIST(10)=+$H
	......&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	......IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	....IF ((OrdCatPatLoc="全部科室")&(ChangeType'="Test")) D
	.....s Para=OrdCatDr_del_""_del_RLOCDR
	.....s ExistFlag=..OrdCatRlocExit(Para)
	.....q:ExistFlag=1
	.....k PLIST
	.....s PLIST(6)="Y"
	.....SET PLIST(0)=OrdCatDr,PLIST(3)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	.....&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	.....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	....IF ((OrdCatPatLoc'="各个病房")&(OrdCatPatLoc'="全部科室")&(OrdCatPatLoc'="各个科室")) D
	.....SET PLOC=$P(OrdCatPatLoc,"/",j-1) 
	.....if ((PLOC="全部科室")!(PLOC="*")) d
	.....else  d
	......SET PLOCDR=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(PLOC),""))
	......if PLOCDR="" s RetStr=..RetErrorValue(RetStr,"取病人科室指针出错OEC_ORDERCATEGORY "_Desc_" "_PLOC) q
	.....if ChangeType'="Test" d
	.....s Para=OrdCatDr_del_""_del_RLOCDR
	.....s ExistFlag=..OrdCatRlocExit(Para)
	.....q:ExistFlag=1
	.....K PLIST
	.....s:(I=1) PLIST(6)="Y"
	.....s:PLOC'="全部科室" PLIST(4)=PLOCDR
	.....SET PLIST(0)=OrdCatDr,PLIST(3)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	.....&SQL(INSERT INTO SQLUser.OEC_OrdCatRecLoc VALUES :PLIST())
	.....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_PLOC_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..SET I=I+1
	
	;医嘱子类
	S SubCode=$P(RowStr,del,6),SubDesc=$P(RowStr,del,7)
	;if +SubCode=0 s SubCode=""
	if SubCode="" d
	.s SubCodeTmp=$o(^ARC("IC",0,"Code",OrdCatCode_"99"),-1)
	.if $g(SubCodeTmp)'="" d
	..if $e(SubCodeTmp,1,2)=$e(OrdCatCode,1,2) s SubCode=SubCodeTmp+1
	..if $e(SubCodeTmp,1,2)'=$e(OrdCatCode,1,2) s SubCode=OrdCatCode_"01"
	.if $g(SubCodeTmp)="" s SubCode=OrdCatCode_"01"
	Q:SubCode="" ..RetErrorValue(RetStr,"医嘱子类代码为空ARC_ItemCat")
	q:SubDesc="" ..RetErrorValue(RetStr,"医嘱子类名称为空ARC_ItemCat")
	SET CodeDr=$o(^OEC("ORCAT",0,"Desc",$$ALPHAUP^SSUTIL4(OrdCatDesc),"")) 
	q:CodeDr="" ..RetErrorValue(RetStr,"取医嘱大类名称指针出错ARC_ItemCat")
	s ORDTYPE=$$ALPHAUP^SSUTIL4($p(RowStr,del,9))
	q:ORDTYPE="" ..RetErrorValue(RetStr,"医嘱类型为空ARC_ItemCat"_SubCode)
	s ORDERTYPEDR=$s(ORDTYPE["DRUG":"R",ORDTYPE["DIET":"D",ORDTYPE["IV":"I",ORDTYPE["CONS":"C",ORDTYPE["NORM":"N",ORDTYPE["DENT":"T",ORDTYPE["LABT":"L",ORDTYPE["REHA":"X",ORDTYPE["PRIC":"P",1:"Z") 
	q:ORDERTYPEDR="Z" ..RetErrorValue(RetStr,"取医嘱类型出错ARC_ItemCat"_SubDesc_","_ORDTYPE)

	s RESULT=$P(RowStr,del,8)
	q:RESULT ..RetErrorValue(RetStr,"医嘱执行类型为空ARC_ItemCat "_RESULT)
	if RESULT'="" s RESULTDR=$o(^OEC("EXEC",0,"Desc",$$ALPHAUP^SSUTIL4(RESULT),"")) 
	q:RESULTDR="" ..RetErrorValue(RetStr,"取执行类型出错ARC_ItemCat "_SubCode_","_$g(RESULT))
	s CALQTY=$P(RowStr,del,100)
	s:$g(CALQTY)="" CALQTY=""
	s:(($g(CALQTY)'="Y")&(CALQTY'="N")) CALQTY="N"
	IF ($D(^ARC("IC",0,"Code",$$ALPHAUP^SSUTIL4(SubCode)))&('$D(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(SubDesc))))) s RetStr=..RetErrorValue(RetStr,"嘱子类编码已经存在ARC_ItemCat"_SubCode)
	IF ($D(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(SubDesc)))&('$D(^ARC("IC",0,"Code",$$ALPHAUP^SSUTIL4(SubCode))))) s RetStr=..RetErrorValue(RetStr,"嘱子类名称已经存在ARC_ItemCat"_SubDesc)
	
	if ((ChangeType'="Test")&('$D(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(SubDesc))))&('$D(^ARC("IC",0,"Code",$$ALPHAUP^SSUTIL4(SubCode))))) d
	.k PLIST
	.s PLIST(2)=SubCode,PLIST(3)=SubDesc,PLIST(9)=CodeDr,PLIST(8)=ORDERTYPEDR,PLIST(10)=RESULTDR,PLIST(12)=CALQTY
	.&SQL(INSERT INTO SQLUser.ARC_ItemCat VALUES :PLIST())
	.i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"ARC_ItemCat -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	//医嘱子类接收科室
	s RecLoc=$P(RowStr,del,12),PatLoc=$P(RowStr,del,11)
	q:(($g(RecLoc)="")&($g(PatLoc)="")) RetStr
	SET SubCatDr=$O(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(SubDesc),""))
	q:SubCatDr="" ..RetErrorValue(RetStr,"医嘱子类指针出错ARC_ITEMCATRECLOC "_SubCode)
	;q:RecLoc="" ..RetErrorValue(RetStr,"接收科室为空ARC_ITEMCATRECLOC "_SubCode)
	;Q:PatLoc="" ..RetErrorValue(RetStr,"病人科室为空ARC_ITEMCATRECLOC "_SubCode)
	
	SET WardId=$O(^CTLOC(0)),I=1
	IF ((RecLoc="各个病房")&(ChangeType'="Test"))  D
	.FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	..q:($P(^CTLOC(WardId),del,13)'="W")
	..K PLIST
	..s PLIST(6)="Y"
	..SET PLIST(0)=SubCatDr,PLIST(3)=WardId,PLIST(4)=WardId,PLIST(5)="Execute",PLIST(10)=+$H
	..&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	..IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	
	s RLocDr=""
	IF ((RecLoc="各个科室")&(ChangeType'="Test"))  D
	.f  s RLocDr=$o(^PAC("ADMLOC",0,"AdmType","O",RLocDr)) q:RLocDr=""  d
	..k PLIST
	..s PLIST(6)="Y"
	..SET PLIST(0)=SubCatDr,PLIST(3)=RLocDr,PLIST(4)=RLocDr,PLIST(5)="Execute",PLIST(10)=+$H
	..&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	..IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	s RLocDr=""
	IF ((RecLoc="临床科室")&(ChangeType'="Test"))  D
	.f  s RLocDr=$o(^PAC("ADMLOC",0,"AdmType","I",RLocDr)) q:RLocDr=""  d
	..q:('$d(^CTLOC(RLocDr,"LINK")))
	..k PLIST
	..s PLIST(6)="Y"
	..SET PLIST(0)=SubCatDr,PLIST(3)=RLocDr,PLIST(4)=RLocDr,PLIST(5)="Execute",PLIST(10)=+$H
	..&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	..IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))


	IF ((RecLoc'="各个病房")&(RecLoc'="各个科室")&(RecLoc'="临床科室")&(ChangeType'="Test")) d
	.SET I=1,j=1
	.FOR  SET RLOC=$P(RecLoc,"/",j) Q:RLOC=""  D
	..s j=j+1
	..q:RLOC=""
	..if '$d(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RLOC))) s RetStr=..RetErrorValue(RetStr,"取接收科室指针出错ARC_ITEMCATRECLOC "_RLOC)
	..q:'$d(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RLOC)))
	..SET RLOCDR=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RLOC),""))
	..if RLOCDR="" s RetStr=..RetErrorValue(RetStr,"取接收科室指针出错ARC_ITEMCATRECLOC "_RLOC) q
	..IF ((PatLoc="各个病房")&(ChangeType'="Test")) D
	...s WardId=0
	...FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	....q:($P(^CTLOC(WardId),del,13)'="W")
	....K PLIST
	....s PLIST(6)="Y"
	....SET PLIST(0)=SubCatDr,PLIST(3)=WardId,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.ARC_ITEMCATRECLOC VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..
	..s PatLocDr=""
	..IF ((PatLoc="各个科室")&(ChangeType'="Test")) D
	...f  s PatLocDr=$o(^PAC("ADMLOC",0,"AdmType","O",PatLocDr)) q:PatLocDr=""  d
	....k PLIST
	....s:(I=1) PLIST(6)="Y"
	....SET PLIST(0)=SubCatDr,PLIST(3)=PatLocDr,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..s PatLocDr=""
	..IF ((PatLoc="临床科室")&(ChangeType'="Test")) D
	...f  s PatLocDr=$o(^PAC("ADMLOC",0,"AdmType","I",PatLocDr)) q:PatLocDr=""  d
	....q:('$d(^CTLOC(PatLocDr,"LINK")))
	....k PLIST
	....s:(I=1) PLIST(6)="Y"
	....SET PLIST(0)=SubCatDr,PLIST(3)=PatLocDr,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))

	..IF ((PatLoc="全部科室")&(ChangeType'="Test")) D
	...k PLIST
	...s:(I=1) PLIST(6)="Y"
	...SET PLIST(0)=SubCatDr,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	...&SQL(INSERT INTO SQLUser.ARC_ITEMCATRecLoc VALUES :PLIST())
	...IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..IF ((PatLoc'="各个病房")&(PatLoc'="全部科室")&(PatLoc'="各个科室")) D
	...SET PLOC=$P(PatLoc,"/",j-1) 
	...if ((PLOC="全部科室")!(PLOC="*")!(PLOC="")) d
	...else  d
	....SET PLOCDR=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(PLOC),""))
	....if PLOCDR="" s RetStr=..RetErrorValue(RetStr,"取病人科室指针出错ARC_ITEMCATRECLOC "_SubDesc_" "_PLOC) q
	...if ChangeType'="Test" d
	....K PLIST
	....s PLIST(6)="Y"
	....s:((PLOC'="全部科室")&(PLOC'="")&(PLOC'="*")) PLIST(3)=PLOCDR
	....SET PLIST(0)=SubCatDr,PLIST(4)=RLOCDR,PLIST(5)="Execute",PLIST(10)=+$H
	....&SQL(INSERT INTO SQLUser.ARC_ITEMCATRECLOC VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,SubCode_","_PLOC_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..SET I=I+1
	q:RetStr="" "Ok"
	q RetStr
}

/// 医嘱大类的接收科室和病人科室是否存在
ClassMethod OrdCatRlocExitHosp(Para As %String = "") As %String
{
	q:Para="" 0
	s del="^",RetStr=0
	s OrdCatId=$p(Para,del,1),PatLocId=$p(Para,del,2),RecLocId=$p(Para,del,3)
	q:OrdCatId="" 0
	q:(RecLocId="") 0
	q:(PatLocId="") 0
	///判断病人科室与接收科室是否属于一个院区
	s PatHosDR=$P($G(^CTLOC(PatLocId)),"^",22)
	s RecHosDR=$P($G(^CTLOC(RecLocId)),"^",22)
	q:(PatHosDR'=RecHosDR) 1
	s OrdCatLocId=0
	s CircleFlag=1
	f  s OrdCatLocId=$o(^OEC("ORCAT",OrdCatId,"RL",OrdCatLocId)) q:((OrdCatLocId="")!(CircleFlag=0))  d
	.s PatLocIdTmp=$p(^OEC("ORCAT",OrdCatId,"RL",OrdCatLocId),del,2)
	.s RecLocIdTmp=$p(^OEC("ORCAT",OrdCatId,"RL",OrdCatLocId),del,3)
	.if ((PatLocId=PatLocIdTmp)&(RecLocId=RecLocIdTmp)) s CircleFlag=0,RetStr=1
	q RetStr
}

/// 医嘱大类的接收科室和病人科室是否存在
ClassMethod OrdCatRlocExit(Para As %String = "") As %String
{
	q:Para="" 0
	s del="^",RetStr=0
	s OrdCatId=$p(Para,del,1),PatLocId=$p(Para,del,2),RecLocId=$p(Para,del,3)
	q:OrdCatId="" 0
	q:(RecLocId="") 0
	s OrdCatLocId=0
	s CircleFlag=1
	f  s OrdCatLocId=$o(^OEC("ORCAT",OrdCatId,"RL",OrdCatLocId)) q:((OrdCatLocId="")!(CircleFlag=0))  d
	.s PatLocIdTmp=$p(^OEC("ORCAT",OrdCatId,"RL",OrdCatLocId),del,2)
	.s RecLocIdTmp=$p(^OEC("ORCAT",OrdCatId,"RL",OrdCatLocId),del,3)
	.if ((PatLocId=PatLocIdTmp)&(RecLocId=RecLocIdTmp)) s CircleFlag=0,RetStr=1
	q RetStr
}

/// 医嘱项接收科室
ClassMethod ArcRec(ChangeType As %String = "", RowStr As %String = "") As %String
{
	;Exel Field :
	;  *1*-------*2*----------3-----4*-----
	;  ArcimCode^ArcimDesc^ PatLoc^ RecLoc^
	
	IF ChangeType="Clear" ;k ^ARCRL
	q:ChangeType="Clear" "数据已清:医嘱项接收科室完成"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	
	S ArcCode=$P(RowStr,del,1),ArcDesc=$P(RowStr,del,2)
	s PatLoc=$P(RowStr,del,3),RecLoc=$P(RowStr,del,4)
	q:$g(ArcCode)="" "医嘱项代码为空"
	if $d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcCode))) d
	.s ArcimId1=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcCode),""))
	.if $g(ArcimId1)="" s RetStr=..RetErrorValue(RetStr,"取医嘱项目ID出错"_ArcCode)
	.q:$g(ArcimId1)=""
	.s ArcimId2=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcCode),ArcimId1,""))
	.s ArcimId=ArcimId1_"||"_ArcimId2
	.IF ((RecLoc="各个病房")&(ChangeType'="Test"))  D
	..s WardId=0
	..FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	...q:($P(^CTLOC(WardId),del,13)'="W")
	...s Para=ArcimId_del_WardId_del_WardId
	...s ExistFlag=..ArcimRlocExit(Para)
	...q:ExistFlag=1
	...K PLIST
	...s PLIST(8)="Y"
	...SET PLIST(2)=ArcimId1,PLIST(4)=WardId,PLIST(5)=WardId,PLIST(6)=ArcimId,PLIST(12)=+$H,PLIST(7)="Execute"
	...&SQL(INSERT INTO SQLUser.Arc_itmrecloc VALUES :PLIST())
	...IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,ArcCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	.s RLocDr="",I=1
	.IF ((RecLoc="各个科室")&(ChangeType'="Test"))  D
	..f  s RLocDr=$o(^PAC("ADMLOC",0,"AdmType","O",RLocDr)) q:RLocDr=""  d
	...s Para=ArcimId_del_RLocDr_del_RLocDr
	...s ExistFlag=..ArcimRlocExit(Para)
	...q:ExistFlag=1
	...k PLIST
	...s PLIST(8)="Y"
	...SET PLIST(2)=ArcimId1,PLIST(4)=RLocDr,PLIST(5)=RLocDr,PLIST(6)=ArcimId,PLIST(12)=+$H,PLIST(7)="Execute"
	...&SQL(INSERT INTO SQLUser.Arc_itmrecloc VALUES :PLIST())
	...IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,ArcCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	.IF ((RecLoc="临床科室")&(ChangeType'="Test"))  D
	..f  s RLocDr=$o(^PAC("ADMLOC",0,"AdmType","I",RLocDr)) q:RLocDr=""  d
	...q:('$d(^CTLOC(RLocDr,"LINK")))
	...s Para=ArcimId_del_RLocDr_del_RLocDr
	...s ExistFlag=..ArcimRlocExit(Para)
	...q:ExistFlag=1
	...k PLIST
	...s PLIST(8)="Y"
	...SET PLIST(2)=ArcimId1,PLIST(4)=RLocDr,PLIST(5)=RLocDr,PLIST(6)=ArcimId,PLIST(12)=+$H,PLIST(7)="Execute"
	...&SQL(INSERT INTO SQLUser.Arc_itmrecloc VALUES :PLIST())
	...IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,ArcCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))

	.IF ((RecLoc'="各个病房")&(RecLoc'="各个科室")&(RecLoc'="临床科室")&(ChangeType'="Test")) d
	..
	..SET I=1,j=1
	..FOR  SET RLOC=$P(RecLoc,"/",j) Q:RLOC=""  D
	...s j=j+1
	...q:RLOC=""
	...if '$d(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RLOC))) s RetStr=..RetErrorValue(RetStr,"取接收科室指针出错ARC_ITEMCATRECLOC "_RLOC)
	...q:'$d(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RLOC)))
	...SET RlocDr=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RLOC),""))
	...if RlocDr="" s RetStr=..RetErrorValue(RetStr,"取接收科室指针出错OEC_ORDERCATEGORY "_RLOC) q
	...IF ((PatLoc="各个病房")&(ChangeType'="Test")) D
	....s WardId=0
	....FOR  SET WardId=$O(^CTLOC(WardId)) Q:WardId=""  D
	.....q:($P(^CTLOC(WardId),del,13)'="W")
	.....s Para=ArcimId_del_WardId_del_RlocDr
	.....s ExistFlag=..ArcimRlocExit(Para)
	.....q:ExistFlag=1
	.....K PLIST
	.....s PLIST(8)="Y"
	.....SET PLIST(2)=ArcimId1,PLIST(4)=WardId,PLIST(5)=RlocDr,PLIST(12)=+$H,PLIST(7)="Execute"
	.....&SQL(INSERT INTO SQLUser.Arc_itmrecloc VALUES :PLIST())
	.....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,ArcCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	...
	...s PatLocDr=""
	...IF ((PatLoc="各个科室")&(ChangeType'="Test")) D
	....f  s PatLocDr=$o(^PAC("ADMLOC",0,"AdmType","O",PatLocDr)) q:RlocDr=""  d
	.....s Para=ArcimId_del_PatLocDr_del_RlocDr
	.....s ExistFlag=..ArcimRlocExit(Para)
	.....q:ExistFlag=1
	.....k PLIST
	.....s PLIST(8)="Y"
	.....SET PLIST(2)=ArcimId1,PLIST(4)=PatLocDr,PLIST(5)=RlocDr,PLIST(6)=ArcimId,PLIST(12)=+$H,PLIST(7)="Execute"
	.....&SQL(INSERT INTO SQLUser.arc_itmrecloc VALUES :PLIST())
	.....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,ArcCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	...IF ((PatLoc="全部科室")&(ChangeType'="Test")) D
	....s Para=ArcimId_del_""_del_RlocDr
	....s ExistFlag=..ArcimRlocExit(Para)
	....q:ExistFlag=1
	....k PLIST
	....s PLIST(8)="Y"
	....SET PLIST(2)=ArcimId1,PLIST(5)=RlocDr,PLIST(6)=ArcimId,PLIST(12)=+$H,PLIST(7)="Execute"
	....&SQL(INSERT INTO SQLUser.arc_itmrecloc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,ArcCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	...IF ((PatLoc'="各个病房")&(PatLoc'="全部科室")&(PatLoc'="临床科室")&(PatLoc'="各个科室")) D
	....
	....SET PLOC=$P(PatLoc,"/",j-1) 
	....if ((PLOC="全部科室")!(PLOC="*")) d
	.....
	....else  d
	.....SET PLOCDR=$O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(PLOC),""))
	.....if PLOCDR="" s RetStr=..RetErrorValue(RetStr,"取病人科室指针出错OEC_ORDERCATEGORY "_Desc_" "_PLOC) q
	....if ChangeType'="Test" d
	....s Para=ArcimId_del_""_del_RlocDr
	....s ExistFlag=..ArcimRlocExit(Para)
	....q:ExistFlag=1
	....K PLIST
	....s:(I=1) PLIST(6)="Y"
	....s:PLOC'="全部科室" PLIST(4)=PLOCDR
	....SET PLIST(2)=ArcimId1,PLIST(5)=RlocDr,PLIST(6)=ArcimId,PLIST(12)=+$H,PLIST(7)="Execute"
	....&SQL(INSERT INTO SQLUser.arc_itmrecloc VALUES :PLIST())
	....IF $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,ArcCode_","_RecLoc_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	.SET I=I+1
	
	q:RetStr="" "Ok"
	q RetStr
}

/// 医嘱项接收是否存在
ClassMethod ArcimRlocExit(Para As %String = "") As %String
{
	q:Para="" 0
	s del="^",RetStr=0
	s ArcimId=$p(Para,del,1),PatLocId=$p(Para,del,2),RecLocId=$p(Para,del,3)
	s ArcimId1=$p(ArcimId,"||",1),ArcimId2=$p(ArcimId,"||",2)
	q:ArcimId="" 0
	q:(RecLocId="") 0
	s OrdCatLocId=0
	s CircleFlag=1
	s ARCRLSUB=0
	f  s ARCRLSUB=$o(^ARCRL(ArcimId1,ARCRLSUB)) q:((ARCRLSUB="")!(CircleFlag=0))  d
	.s PatLocIdTmp=$p(^ARCRL(ArcimId1,ARCRLSUB),del,1)
	.s RecLocIdTmp=$p(^ARCRL(ArcimId1,ARCRLSUB),del,2)
	.if ((PatLocId=PatLocIdTmp)&(RecLocId=RecLocIdTmp)) s CircleFlag=0,RetStr=1
	q RetStr
}

/// 医嘱套
ClassMethod OrdSet(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" k ^ARCOS
	q:ChangeType="Clear" "数据已清:医嘱项"
	s del="^"
	s RetStr=""
	SET RowStr=$tr(RowStr," ","")
 s OrdSetCode=$p(RowStr,del,1),OrdSetDesc=$p(RowStr,del,2),Alias=$p(RowStr,del,3)
 s OrdSetCat=$p(RowStr,del,4),OrdSetCatSub=$p(RowStr,del,5)
 s ArcCode=$p(RowStr,del,6),ArcDesc=$p(RowStr,del,7),Qty=$p(RowStr,del,8),LinkDoc=$p(RowStr,del,9),DoseQty=$p(RowStr,del,10)
 q:OrdSetDesc="" ..RetErrorValue(RetStr,"医嘱套名称为空:")
 q:ArcCode="" ..RetErrorValue(RetStr,"医嘱代码为空:")
 ;if $g(^ARCOS(0))="" s OrdSetCode=1
 ;if $g(^ARCOS(0))'="" s OrdSetCode=$g(^ARCOS(0))+1
 if ((OrdSetCode'="")&(OrdSetDesc'="")) d
 .Q:($D(^ARCOS(0,"Desc",$$ALPHAUP^SSUTIL4(OrdSetDesc))))
 .if (('$D(^ARCOS(0,"Desc",$$ALPHAUP^SSUTIL4(OrdSetDesc))))&('$D(^ARCOS(0,"Code",$$ALPHAUP^SSUTIL4(OrdSetCode))))) d
 ..if $g(OrdSetCatSub)="" s RetStr=..RetErrorValue(RetStr,"医嘱套子类为空:"_OrdSetDesc)
 ..q:OrdSetCatSub=""
 ..s OrdSetCatSubDr=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(OrdSetCatSub),0))
 ..if $g(OrdSetCatSubDr)="" s RetStr=..RetErrorValue(RetStr,"医嘱套子类指针为空:"_OrdSetDesc_" "_SubDesc)
 ..q:OrdSetCatSubDr=""
 ..s OrdSetCatDr=$p(^ARC("IC",OrdSetCatSubDr),del,8)
 ..if $g(OrdSetCatDr)="" s RetStr=..RetErrorValue(RetStr,"医嘱套大类指针出错")
 ..q:OrdSetCatDr=""
 ..if ChangeType'="Test" d
	...K PLIST
	...S PLIST(2)=OrdSetCode,PLIST(4)="Y",PLIST(6)=OrdSetDesc,PLIST(16)=OrdSetCatDr,PLIST(17)=OrdSetCatSubDr,PLIST(25)=+$H
	...&SQL(INSERT INTO SQLUser.ARC_OrdSets VALUES :PLIST())
	...i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"ARC_OrdSets -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) Q
	...Q:$g(%ROWID)=""
	...s OrdSetId=$g(%ROWID)
	...Q:$D(^ARCOS(OrdSetId,"DATE",0))
	...K PLIST
	...S PLIST(0)=OrdSetId,PLIST(3)=+$H
	...&SQL(INSERT INTO SQLUser.ARC_OrdSetDate VALUES :PLIST())
	...i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"ARC_OrdSetDate -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) Q
	s OrdSetId=$o(^ARCOS(0,"Desc",$$ALPHAUP^SSUTIL4(OrdSetDesc),""))
	q:$g(OrdSetId)="" ..RetErrorValue(RetStr,"取医嘱套指针出错"_OrdSetDesc)
	q:$G(ArcCode)="" ..RetErrorValue(RetStr,"医嘱项代码为空"_ArcCode)
	s ArcimId1=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcCode),0))
	q:$g(ArcimId1)="" ..RetErrorValue(RetStr,"医嘱项指针出错"_ArcCode)
	s ArcimId2=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcCode),ArcimId1,0))
	q:$g(ArcimId2)="" ..RetErrorValue(RetStr,"医嘱项指针2出错"_ArcCode)
	s ArcimId=ArcimId1_"||"_ArcimId2
	S OrdSetDateId=$o(^ARCOS(OrdSetId,"DATE",""),-1)
	if $g(OrdSetDateId)="" d
	.K PLIST
	.S PLIST(0)=OrdSetId,PLIST(3)=+$H
	.&SQL(INSERT INTO SQLUser.ARC_OrdSetDate VALUES :PLIST())
	.i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"ARC_OrdSetDate -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) Q
	.s OrdSetDateId=$g(%ROWID)
	Q:$g(OrdSetDateId)="" ..RetErrorValue(RetStr,"取医嘱套日期表出错"_OrdSetDesc)
 s CircleFlag=1,OrdSetDateItmId=""
 f  s OrdSetDateItmId=$o(^ARCOS(OrdSetId,"DATE",OrdSetDateId,"ITM",OrdSetDateItmId)) q:((OrdSetDateItmId="")!(CircleFlag=0))  d
 .s ArcimIdTmp=$p(^ARCOS(OrdSetId,"DATE",OrdSetDateId,"ITM",OrdSetDateItmId),del,1)
 .if ArcimId=ArcimIdTmp s CircleFlag=0
 if CircleFlag'=0 d
 .K PLIST
 .s PLIST(0)=OrdSetId_"||"_OrdSetDateId,PLIST(3)=ArcimId,PLIST(4)=Qty,PLIST(7)="Y",PLIST(15)=$g(DoseQty),PLIST(16)=$g(LinkDoc)
 .&SQL(INSERT INTO SQLUser.ARC_OrdSetDateItem VALUES :PLIST())
	.i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"ARC_OrdSetDateItem -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) Q

	//别名
 i Alias'="" d
 .set I=1
 .s num=$l(Alias,"/")
 .s ALI=""
 .FOR I=1:1:num d
 ..s ALI=$p(Alias,"/",I)
 ..;q:$d(^ARC("ALIAS",0,"DescI",$$ALPHAUP^SSUTIL4(ALI)_" ",$$ALPHAUP^SSUTIL4(OrdSetDesc)))
 ..s AliaId=$o(^ARC("ALIAS",0,"Desc",$$ALPHAUP^SSUTIL4(ALI)_" ",$$ALPHAUP^SSUTIL4(OrdSetDesc),""))
 ..S ArcosId=""
 ..if $G(AliaId)'="" S ArcosId=$p(^ARC("ALIAS",AliaId),del,2)
 ..q:($g(OrdSetId)=$g(ArcosId))
 ..q:OrdSetCatSub=""
 ..s OrdSetCatSubDr=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(OrdSetCatSub),0))
 ..if $g(OrdSetCatSubDr)="" s RetStr=..RetErrorValue(RetStr,"医嘱套子类指针为空:"_OrdSetDesc_" "_SubDesc)
 ..q:OrdSetCatSubDr=""
 ..s OrdSetCatDr=$p(^ARC("IC",OrdSetCatSubDr),del,8)
 ..if $g(OrdSetCatDr)="" s RetStr=..RetErrorValue(RetStr,"医嘱套大类指针出错")
 ..q:OrdSetCatDr=""
 ..if ChangeType'="Test" d
 ...q:$g(ALI)=""
 ...S ALI=$$ALPHAUP^SSUTIL4(ALI)
 ...k PLIST 
 ...s PLIST(3)=OrdSetId,PLIST(5)=OrdSetDesc,PLIST(6)=OrdSetCatSubDr,PLIST(14)=+$h
 ...set PLIST(4)=$p(Alias,"/",I)
 ...if $G(AliaId)'="" D
 ....&SQL(UPDATE SQLUser.ARC_Alias SET ALIAS_ARCOS_DR=:OrdSetId WHERE ALIAS_ROWID=:AliaId)
 ...ELSE  D
 ....&SQL(INSERT INTO SQLUser.ARC_Alias VALUES PLIST()) 
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_Alias -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ...q:$g(SQLCODE)
 ...s ArcKeyId=0,CircleFlag=1
 ...f  s ArcKeyId=$o(^ARC("KEYW",0,"ARCOS",OrdSetId,ArcKeyId)) q:((ArcKeyId="")!(CircleFlag=0))  d
 ....s ArcKey=$p(^ARC("KEYW",ArcKeyId),del,3)
 ....if ALI=ArcKey s CircleFlag=0,ArcKeyIdTmp=ArcKeyId
 ...k PLIST 
 ...s PLIST(3)=OrdSetId,PLIST(5)=OrdSetDesc,PLIST(6)=OrdSetCatSubDr,PLIST(7)=OrdSetCatDr
 ...set PLIST(4)=$p(Alias,"/",I)
 ...if (CircleFlag=0) d
 ....&SQL(update SQLUser.ARC_ItemKeywords set KEYW_ARCOS_DR=:OrdSetId where KEYW_RowId=:ArcKeyIdTmp)
 ...else  d
 ....&SQL(INSERT INTO SQLUser.ARC_ItemKeywords VALUES PLIST()) 
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_ItemKeywords -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))

	 q RetStr
}

/// 房间
ClassMethod PacRoom(ChangeType As %String = "", RowStr As %String = "") As %String
{
 ; -1-----2--------3---------4---------5--------6-------7----8
 ; LOC  LocDesc   BED     BEDTYPE    ROOM    ROOMTYPE  SEX   query
	if ChangeType="Clear" K ^PAC("ROOMT"),^PAROOM
	q:ChangeType="Clear" "数据已清:房间类型和房间"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	Set ROOM=$P(RowStr,del,5),ROOMTYPE=$P(RowStr,del,6)
	Q:ROOMTYPE="" ..RetErrorValue(RetStr,"房间类型为空")
	
	IF '$D(^PAC("ROOMT",0,"Desc",$$ALPHAUP^SSUTIL4(ROOMTYPE))) d
	.if ChangeType'="Test" d
	..K PLIST
	..SET PLIST(2)=ROOMTYPE,PLIST(3)=ROOMTYPE
	..&SQL(INSERT INTO SQLUSER.PAC_ROOMTYPE VALUES PLIST())
	q:$g(SQLCODE) ..RetErrorValue(RetStr,"PAC_ROOMTYPE -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))

	q:ROOM="" ..RetErrorValue(RetStr,"房间为空")
	Set DIFSEX=$E($P(RowStr,del,7),1,1)
	s Query=$P(RowStr,del,8)
	if ((Query'="等待区")&(Query'="急诊等待区")&(Query'="多人房间")&(Query'="预留")) s Query=""
	if Query="等待区" s Query="BA"
	if Query="急诊等待区" s Query="WA"
	if Query="多人房间" s Query="MPR"
	if Query="预留" s Query="SR"
	
	SET ROOMTYPEDR=$O(^PAC("ROOMT",0,"Desc",$$ALPHAUP^SSUTIL4(ROOMTYPE),""))
	q:ROOMTYPEDR="" ..RetErrorValue(RetStr,"取房间类型指针出错:"_ROOMTYPEDR)
	if '$D(^PAROOM(0,"ROOM_Code",$$ALPHAUP^SSUTIL4(ROOM))) d
	.if ChangeType'="Test" d
	..K PLIST
	..SET PLIST(2)=ROOM,PLIST(3)=ROOM,PLIST(7)=ROOMTYPEDR,PLIST(8)=DIFSEX,PLIST(9)=Query,PLIST(12)=+$H
	..&SQL(INSERT INTO SQLUSER.PAC_ROOM VALUES PLIST())
	..if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"PAC_ROOM -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

/// 床位
ClassMethod PacBed(ChangeType As %String = "", RowStr As %String = "") As %String
{
 //^PAC("BEDTP"),^PAWARD({PAC_Ward.WARD_RowID},"BED",{BED_Childsub})  PAC_BEDTYPE,PAC_BED
	//1 护理站代码  2 护理站名称	3 床位名称	4 床位类型	5 房间	6房间类型	7不同性别同一房间 8是否预留房间
	//set RowStr="护理站代码^护理站名称^床位名称^床位类型^房间^房间类型^不同性别同一房间^是否预留房间"
	//s ChangeType="Test"
	if ChangeType="Clear" d
	.K ^PAC("BEDTP")
	.s PARID=0
	.FOR  SET PARID=$O(^PAWARD(PARID)) Q:PARID=""  D 
	..K ^PAWARD(PARID,"BED"),^PAWARD(PARID,"ROOM")
	.k ^PAWARD("BED_BedType_DR"),^PAWARD("BED_Room_DR"),^PAWARD(0,"ExtNo"),^PAWARD(0,"Sort"),^PAWARD(0,"WardRoom")
	q:ChangeType="Clear" "数据已清:床位类型和床位"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	s BEDTYPE=$P(RowStr,del,4)
	Q:BEDTYPE="" "床位类型为空"
	if '$D(^PAC("BEDTP",0,"BEDTP_Desc",$$ALPHAUP^SSUTIL4(BEDTYPE))) d
	.if ChangeType'="Test" d
	..K PLIST
	..SET PLIST(2)=BEDTYPE,PLIST(3)=BEDTYPE,PLIST(4)="Y"
	..&SQL(INSERT INTO SQLUSER.PAC_BEDTYPE VALUES PLIST())
	..if $g(SQLCODE)  s RetStr=..RetErrorValue(RetStr,"PAC_BEDTYPE -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))

    SET LOC=$P(RowStr,del,1),BEDNO=$P(RowStr,del,3),ROOM=$P(RowStr,del,5)
	Q:LOC="" ..RetErrorValue(RetStr,"科室为空")
	q:BEDNO="" ..RetErrorValue(RetStr,"床号为空") 
	q:ROOM="" ..RetErrorValue(RetStr,"房间为空") 
	
	SET LOCDR=$O(^PAWARD(0,"WARD_Code",$$ALPHAUP^SSUTIL4(LOC),""))
	Q:LOCDR="" ..RetErrorValue(RetStr,"科室出错:"_LOC) 

	SET BEDTYPEDR=$O(^PAC("BEDTP",0,"BEDTP_Desc",$$ALPHAUP^SSUTIL4(BEDTYPE),""))
	q:BEDTYPEDR="" ..RetErrorValue(RetStr,"床位类型出错:"_BEDTYPE)
	SET ROOMDR=$O(^PAROOM(0,"ROOM_Code",$$ALPHAUP^SSUTIL4(ROOM),""))
	q:ROOMDR="" ..RetErrorValue(RetStr,"房间出错:"_ROOM) 
	s Rid=##class(web.DHCFHQ.DHCFFHQ).WardBedExist(LOCDR,BEDNO)
	if ChangeType'="Test" d
	.K PLIST
	.s Rid=##class(web.DHCFHQ.DHCFFHQ).WardBedExist(LOCDR,BEDNO)
	.if Rid'="" d
	..s BedId=LOCDR_"||"_Rid
	..&sql(update SQLUSER.PAC_BED set BED_BedType_DR=:BEDTYPEDR,BED_Room_DR=:ROOMDR where BED_RowID=:BedId)
	.else  d
	..SET PLIST(0)=LOCDR,PLIST(3)=ROOMDR,PLIST(4)=BEDNO,PLIST(9)=BEDTYPEDR,PLIST(13)="Y",PLIST(34)=+$H
	..&SQL(INSERT INTO SQLUSER.PAC_BED VALUES PLIST())
	q:$g(SQLCODE) ..RetErrorValue(RetStr,"PAC_BED -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod WardBedExist(wardid As %String = "", bedno As %String = "") As %String
{
	s del="^",RetStr="",BedIdSub=""
	s Circle=1
	f  s BedIdSub=$o(^PAWARD(wardid,"BED",BedIdSub)) q:((BedIdSub="")!(Circle=0))  d
	.s bed=$p(^PAWARD(wardid,"BED",BedIdSub),del,1)
	.s:bed=bedno Circle=0,Rid=BedIdSub
	q $g(Rid)
}

ClassMethod WaitArea(ChangeType As %String = "", RowStr As %String = "") As %String
{
	s del="^"
	s RetStr="Ok",del="^"
	q:((ChangeType="")!(RowStr=""))
	s WardCode=$p(RowStr,del,1)
	s WardDesc=$p(RowStr,del,2)
	q:WardDesc="" "病区名称为空"
	s WardId=$o(^PAWARD(0,"WARD_Code",$$ALPHAUP^SSUTIL4(WardCode),""))
	q:(WardId="") "病区在科室表中不存在"
	s left=5,top=5,width=170,height=140,colnum=7
	s waitx=left+(colnum*(width+5))
	s waity=700
	s DateTmp=+$h
	if ChangeType'="Test"  d
	.//增加等候区
	.s RoomDr=$o(^PAROOM(0,"ROOM_Code","等待区",""))
	.if ($d(^PAWARD(WardId,"ROOM"))&(RoomDr'="")) d
	..&sql(update sqluser.pac_wardroom set ROOM_Room_DR=:RoomDr,ROOM_PositionLeft=:waitx,ROOM_PositionTop=:top,ROOM_PositionWidth=:width,ROOM_PositionHeight=:waity,ROOM_DateFrom=:DateTmp where ROOM_ParRef=:WardId)														
	.if (('$d(^PAWARD(WardId,"ROOM")))&(RoomDr'="")) d
	..&sql(insert into sqluser.pac_wardroom (ROOM_ParRef,ROOM_Room_DR,ROOM_PositionLeft,ROOM_PositionTop,ROOM_PositionWidth,ROOM_PositionHeight,ROOM_DateFrom) values(:WardId,:RoomDr,:waitx,:top,:width,:waity,:DateTmp)) 
	Q RetStr
}

/// 画床位图
ClassMethod UpBed(ChangeType As %String = "", RowStr As %String = "") As %String
{
	s del="^"
	s RetStr="Ok",del="^"
	q:((ChangeType="")!(RowStr=""))
	s RowStr=$tr(RowStr,$c(13,10),"")
	s WardCode=$p(RowStr,del,1)
	s WardDesc=$p(RowStr,del,2)
	q:WardDesc="" "病区名称为空"
	s WardId=$o(^PAWARD(0,"WARD_Code",$$ALPHAUP^SSUTIL4(WardCode),""))
	q:(WardId="") "病区在科室表中不存在"
	s left=5,top=5,width=170,height=140,colnum=7
	s waitx=left+(colnum*(width+5))
	s DateTmp=+$h
	s BedSeq=$p(RowStr,del,10)
	s UseFlag=$p(RowStr,del,11)
	q:BedSeq="" "床位序号为空"
	i WardId'="" s ^tempBed(0)=RowStr
	if ChangeType'="Test"  d
	.s BedId=0
	.s BedDesc=$p(RowStr,del,3)
	.f  s BedId=$o(^PAWARD(WardId,"BED",BedId)) q:BedId=""  d
	..s BedDesc1=$p(^PAWARD(WardId,"BED",BedId),del,1)
	..q:BedDesc1'=BedDesc
	..s id=WardId_"||"_BedId
	..if ((UseFlag="无效床位")!((UseFlag="N"))) d
	...b ;00
	...&sql(update sqluser.pac_bed set BED_PositionLeft="",BED_PositionTop="",BED_PositionWidth="",BED_PositionHeight="",BED_RcFlag='N' where BED_RowID=:id)
	...S:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"pac_bed -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..else  d
	...s BedFlag=$p(^PAWARD(WardId,"BED",BedId),del,4)
	...q:$g(BedFlag)="N"
    ...;W BedFlag,"^",BedDesc,!
    ...q:((UseFlag="无效床位")!((UseFlag="N")))
    ...b ;2
	...s lefttmp=left+(((BedSeq-1)#colnum)*(width+3)),toptmp=top+((height+3)*((BedSeq-1)\colnum))
	...&sql(update sqluser.pac_bed set BED_PositionLeft=:lefttmp,BED_PositionTop=:toptmp,BED_PositionWidth=:width,BED_PositionHeight=:height where BED_RowID=:id)
	...S:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"pac_bed -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q RetStr
}

/// 医嘱子类的接收科室和病人科室是否存在
ClassMethod ArcCatRlocExit(Para As %String = "") As %String
{
	q:Para="" 0
	s del="^",RetStr=0
	s OrdCatId=$p(Para,del,1),PatLocId=$p(Para,del,2),RecLocId=$p(Para,del,3)
	q:OrdCatId="" 0
	q:(RecLocId="") 0
	q:(PatLocId="") 0
	///判断病人科室与接收科室是否属于一个院区
	s PatHosDR=$P($G(^CTLOC(PatLocId)),"^",22)
	s RecHosDR=$P($G(^CTLOC(RecLocId)),"^",22)
	q:(PatHosDR'=RecHosDR) 1
	s OrdCatLocId=0
	s CircleFlag=1
	f  s OrdCatLocId=$o(^ARC("IC",OrdCatId,"RL",OrdCatLocId)) q:((OrdCatLocId="")!(CircleFlag=0))  d
	.s PatLocIdTmp=$p(^ARC("IC",OrdCatId,"RL",OrdCatLocId),del,2)
	.s RecLocIdTmp=$p(^ARC("IC",OrdCatId,"RL",OrdCatLocId),del,3)
	.if ((PatLocId=PatLocIdTmp)&(RecLocId=RecLocIdTmp)) s CircleFlag=0,RetStr=1
	q RetStr
}

/// 病人费别
ClassMethod PatChangeType(ChangeType As %String = "", RowStr As %String = "") As %String
{
	; ----*1*----*2-----
	;    CODE    spec   
	IF ChangeType="Clear" K ^PAC("ADMREA")
	q:ChangeType="Clear" "数据已清:病人费别"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1),Desc=$P(RowStr,del,2),REAAdmSource=$P(RowStr,del,3)
	q:Code="" "编码为空"
	q:Desc="" "名称"
	q:(($d(^PAC("ADMREA",0,"Code",$$ALPHAUP^SSUTIL4(Code))))&('$d(^PAC("ADMREA",0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))) ..RetErrorValue(RetStr,"代码已经存在"_Code)
	q:(($d(^PAC("ADMREA",0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))&('$d(^PAC("ADMREA",0,"Code",$$ALPHAUP^SSUTIL4(Code))))) ..RetErrorValue(RetStr,"名称已经存在"_Desc)
	if REAAdmSource'="" s REAAdmSource=1
	k PLIST
	S PLIST(2)=Code,PLIST(3)=Desc,PLIST(4)=+$h,PLIST(10)=REAAdmSource
	&SQL(INSERT INTO SQLUSER.PAC_AdmReason values :PLIST())
	if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"PAC_AdmReason -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod PatInfo(ChangeType As %String = "", RowStr As %String = "") As %String
{
	IF ChangeType="Clear" 
	q:ChangeType="Clear" "病人信息请手工清除"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	//卡号^卡类型^登记号^姓名^性别^出生日期^证件类型^证件号码^门诊病历号^住院病历号^联系电话^病人类别^国籍^省^市^区县^邮编^工作单位^地址	
	s CardNo=$P(RowStr,del,1),CardType=$P(RowStr,del,2),PatNo=$P(RowStr,del,3),Name=$P(RowStr,del,4),Sex=$P(RowStr,del,5)
	s Dob=$P(RowStr,del,6),PaperType=$P(RowStr,del,7),Id=$P(RowStr,del,8),MrOutp=$P(RowStr,del,9),MrInp=$P(RowStr,del,10)
	s TelH=$P(RowStr,del,11),PatType=$P(RowStr,del,12),Country=$P(RowStr,del,13)
	s Province=$P(RowStr,del,14),City=$P(RowStr,del,15),County=$P(RowStr,del,16),PostNo=$P(RowStr,del,17)
	S WorkUnit=$P(RowStr,del,18),Adress=$P(RowStr,del,19)
	s CardType="注册医疗卡-1"
	S Country="ZG-"_Country
	//q:$g(CardNo)="" "卡号为空"
	s CardNo=##class(web.DHCFBCM).ConvertStr(CardNo_"^0^15")
	;IF '$d(^DHCCARDi("CF",0,"CardNo",CardNo)) S ^FHQ1=$I(^FHQ1)
	q:$d(^DHCCARDi("CF",0,"CardNo",CardNo)) "卡号已经存在"_CardNo 
	;Q ""
	s PatNo=$i(^PAPER(0,"CNT","I"))
	if PatNo<30000 s PatNo=30000,^PAPER(0,"CNT","I")=30000
	s PatNo=##class(web.DHCFBPat).ConvertPatNo(PatNo)
	//s ^FHQ(PatNo)=RowStr
	//if $l(RowStr,"?")>1 S ^FHQ(PatNo)=RowStr
	//q "" 
	q:$g(PatNo)="" "病人登记号为空"_PatNo
	q:$g(Name)="" "病人姓名为空"_PatNo
	q:$g(Sex)="" "性别为空"_PatNo
	q:$g(PatType)="" "病人类别为空"_PatNo
	
	q:$d(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatNo))) "登记号已经存在"
	if (($l(RowStr,"^男^")<2)&($l(RowStr,"^女^")<2))  S ^FHQ(PatNo)=RowStr 
	//IF $L(Name,"?")>1 S ^FHQ(PatNo)=RowStr 
	Q:(($l(RowStr,"^男^")<2)&($l(RowStr,"^女^")<2)) "性别出错"_CardNo
	s Dob=$e(Dob,1,10)
	if (Dob<"1841-01-01") s Dob="1841-01-01"
	s Dob=$zdh(Dob,3)
	s Sex=$o(^CT("SEX",0,"Desc",$$ALPHAUP^SSUTIL4(Sex),""))
	q:Sex="" "取性别指针出错"_PatNo
	if $g(PatType)'="" d
	.s PatType=$o(^CT("SS",0,"Desc",$$ALPHAUP^SSUTIL4(PatType),""))
	.s:$g(PatType)="" RetStr=..RetErrorValue(RetStr,"病人类型指针出错:"_PatNo)
	if $g(Country)'="" d 
	.s Country=$o(^CT("COU",0,"Desc",$$ALPHAUP^SSUTIL4(Country),""))
	.S:$g(Country)="" RetStr=..RetErrorValue(RetStr,"取国家指针出错:"_PatNo)
	if $g(Province)'="" d
	.s Province=$o(^CT("PROV",0,"Desc",$$ALPHAUP^SSUTIL4(Province),""))
	.s:$g(Province)="" RetStr=..RetErrorValue(RetStr,"取省份指针出错:"_PatNo)
	if $g(City)'="" d
	.s City=$o(^CT("CIT",0,"Desc",$$ALPHAUP^SSUTIL4(City),""))
	.s:$g(City)="" RetStr=..RetErrorValue(RetStr,"取省份指针出错:"_PatNo)
	//s:$g(County)'="" County=$o(^CT("CIT",0,"Desc",$$ALPHAUP({CTCIT_Desc}))
	if $g(PostNo)'="" d
	.s PostNo=$o(^CT("ZIP",0,"Code",$$ALPHAUP^SSUTIL4(PostNo),""))
	.s:$g(PostNo)="" RetStr=..RetErrorValue(RetStr,"取邮编指针出错:"_PatNo)
	if ChangeType'="Test" d
	.K PLIST
	.S PLIST(8)=PatNo,PLIST(9)=PatNo
	.if $g(PaperType)'="" d
	..if PaperType="身份证" s PaperType="身份证-1"
	..if PaperType="军官证" s PaperType="军官证-1"
	..s:PaperType="身份证-1" PLIST(3)=Id
	..s PaCardTypeDr=$o(^PAC("CARD",0,"Desc",$$ALPHAUP^SSUTIL4(PaperType),""))
	.s:$g(PaCardTypeDr)="" RetStr=..RetErrorValue(RetStr,"取证件类型针出错:"_PaperType)
	.;q:$g(PaCardTypeDr)="" 
	.s PaCardTypeDr=$g(PaCardTypeDr)
	.s PLIST(114)=PaCardTypeDr,PLIST(113)=$g(Id)
	.s PLIST(4)=Name,PLIST(120)=Country,PLIST(124)=Province,PLIST(140)=City
	.s PLIST(11)=Dob
	.s PLIST(15)=Sex,PLIST(125)=MrOutp,PLIST(98)=MrInp,PLIST(129)=WorkUnit
	.&sql(insert into SQLUSER.Pa_PatMas VALUES :PLIST())
	.i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,PatNo_" Pa_PatMatmas -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	.S PatId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatNo),""))
	.if PatId="" s RetStr=..RetErrorValue(RetStr,"没有找到病人登记号"_PatNo) q
	.&sql(Update SQLUSER.Pa_Person set PAPER_TelH=:TelH,PAPER_Zip_Dr=:PostNo,PAPER_Country_dr=:Country,PAPER_SocialStatus_DR=:PatType where PAPER_ROWID=:PatId)
	.s:$g(Adress)'="" ^PAPER(PatId,"PER","ADD",0)=1,^PAPER(PatId,"PER","ADD",1)=Adress
	.s CardNo1=PatNo
	.if $d(^DHCCARDi("CF",0,"CardNo",CardNo1)) s RetStr=..RetErrorValue(RetStr,"卡号已经存在"_CardNo1) q
	.s CardTypeDrTmp=0,Flag=1,CardTypeDr=""
	.f  s CardTypeDrTmp=$o(^DHCCARDTYPEDef(CardTypeDrTmp)) q:((CardTypeDrTmp="")!(Flag'=1))  d
	..s CardDesc=$p(^DHCCARDTYPEDef(CardTypeDrTmp),"^",2)
	..if CardDesc="登记号" s Flag=0,CardTypeDr=CardTypeDrTmp
	.;if $g(CardTypeDr)="" s RetStr=..RetErrorValue(RetStr,"卡类型出错?登记号") q
	.k PLIST
	.S PLIST(3)=CardNo1,PLIST(5)=PatId,PLIST(7)=PatNo,PLIST(11)="N",PLIST(17)=CardTypeDr
	.s PLIST(8)=$h-1,PLIST(9)=22,PLIST(10)=1,PLIST(12)=$h-1
	.;&sql(insert into SQLUSER.DHC_CardRef VALUES :PLIST())   //把登记号做为卡号
	.;i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,PatNo_"DHC_CardRef -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	.q:$g(CardNo)=""
	.s CardNo1=CardNo,PLIST(3)=CardNo1
	.if $d(^DHCCARDi("CF",0,"CardNo",CardNo1)) s RetStr=..RetErrorValue(RetStr,"卡号已经存在"_CardNo1) q
	.s CardTypeDrTmp=0,Flag=1,CardTypeDr=""
	.f  s CardTypeDrTmp=$o(^DHCCARDTYPEDef(CardTypeDrTmp)) q:((CardTypeDrTmp="")!(Flag'=1))  d
	..s CardDesc=$p(^DHCCARDTYPEDef(CardTypeDrTmp),"^",2)
	..if CardDesc=CardType s Flag=0,CardTypeDr=CardTypeDrTmp
	.if $g(CardTypeDr)="" s RetStr=..RetErrorValue(RetStr,"卡类型出错"_CardType) q
	.s PLIST(17)=CardTypeDr
	.&sql(insert into SQLUSER.DHC_CardRef VALUES :PLIST())   //卡号
	.i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,PatNo_"DHC_CardRef -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod PatInfoAdd() As %String
{
 s Ind = 0, del = "^"
 K ^FHQIQIQ0109("INSERT")
 f  s Ind=$o(^FHQIQIQ0109(Ind)) q:Ind=""  d
 .s TmpStr=^FHQIQIQ0109(Ind)
 .s RetStr=..PatInfo("Append",TmpStr)
 .S ^FHQIQIQ0109("INSERT")=$I(^FHQIQIQ0109("INSERT"))
 .q:((RetStr="") ! (RetStr="Ok"))
 .
 .s PatNo=$p(TmpStr,"^",1)
 .s ^ErrText(PatNo)=RetStr
 q ""
}

ClassMethod PatInfoUp(ChangeType As %String = "", RowStr As %String = "") As %String
{
	IF ChangeType="Clear" 
	q:ChangeType="Clear" "病人信息请手工清除"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	//卡号^卡类型^登记号^姓名^性别^出生日期^证件类型^证件号码^门诊病历号^住院病历号^联系电话^病人类别^国籍^省^市^区县^邮编^工作单位^地址	
	s CardNo=$P(RowStr,del,1),CardType=$P(RowStr,del,2),PatNo=$P(RowStr,del,3),Name=$P(RowStr,del,4),Sex=$P(RowStr,del,5)
	s Dob=$P(RowStr,del,6),PaperType=$P(RowStr,del,7),Id=$P(RowStr,del,8),MrOutp=$P(RowStr,del,9),MrInp=$P(RowStr,del,10)
	s TelH=$P(RowStr,del,11),PatType=$P(RowStr,del,12),Country=$P(RowStr,del,13)
	s Province=$P(RowStr,del,14),City=$P(RowStr,del,15),County=$P(RowStr,del,16),PostNo=$P(RowStr,del,17)
	S WorkUnit=$P(RowStr,del,18),Adress=$P(RowStr,del,19)
	//q:$g(CardNo)="" "卡号为空"
	s CardNo=##class(web.DHCFBCM).ConvertStr(CardNo_"^0^12")
	s PatNo=##class(web.DHCFBPat).ConvertPatNo(PatNo)
	q:$g(PatNo)="" "病人登记号为空"_PatNo
	q:$g(Name)="" "病人姓名为空"_PatNo
	q:'$d(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatNo))) "登记号不存在"
	if ChangeType'="Test" d
	.S PatId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatNo),""))
	.&sql(update SQLUSER.Pa_PatMas set PAPMI_Name=:Name where PAPMI_ROWID=:PatId)
	.i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,PatNo_" Pa_PatMatmas -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	.s:$d(^PAPER(rid,"PER","ADD",0)) ^PAPER(rid,"PER","ADD",1)=Adress
	q:RetStr="" "Ok"
	q RetStr
}

/// 药理学分类
ClassMethod PhcCat(ChangeType As %String = "", RowStr As %String = "") As %String
{
	; ----*1*----*2-----*3-----
	;    CAT    SubCat  MinCat 
 IF ChangeType="Clear" K ^PHCC
	q:ChangeType="Clear" "数据已清:药理学分类"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	;"insert table phc_cat begin"

	S CATCODE=$P(RowStr,del,1),CAT=$P(RowStr,del,2),SubCatCODE=$P(RowStr,del,3),SubCat=$P(RowStr,del,4),MINORSubCatCODE=$P(RowStr,del,5),MINORSubCat=$P(RowStr,del,6)
	q:CAT="" "药理学大类为空PHC_Cat"
	IF '$D(^PHCC(0,"Code",$$ALPHAUP^SSUTIL4(CATCODE))) d 
	.IF ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=CATCODE,PLIST(3)=CAT
	..&SQL(INSERT INTO SQLUSER.PHC_Cat VALUES :PLIST())
	q:$g(SQLCODE) ..RetErrorValue(RetStr,"PHC_Cat -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	
	;"PHC_SubCat BEGIN"
	S CATDR=$O(^PHCC(0,"Code",$$ALPHAUP^SSUTIL4(CATCODE),""))
	q:CATDR="" RetStr=..RetErrorValue(RetStr,"取药理学大类指针出错:"_CAT)
	q:SubCat="" "药理学子类为空PHC_SubCat"
	IF '$D(^PHCC("SC_Code",$$ALPHAUP^SSUTIL4(SubCatCODE),CATDR)) d
	.IF ChangeType'="Test" d
	..K PLIST
	..S PLIST(0)=CATDR,PLIST(2)=SubCatCODE,PLIST(3)=SubCat
	..&SQL(INSERT INTO SQLUSER.PHC_SubCat VALUES :PLIST())
	q:$g(SQLCODE) ..RetErrorValue(RetStr,"PHC_SubCat -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))

	;"PHC_MINORSubCat BEGIN"
	q:MINORSubCat="" ..RetErrorValue(RetStr,"药理学小类为空PHC_MinorSubCat")
	S SubCatDR=$O(^PHCC("SC_Code",$$ALPHAUP^SSUTIL4(SubCatCODE),CATDR,""))
	q:SubCatDR="" ..RetErrorValue(RetStr,"取药理学子类指针出错:"_SubCat)
	q:$D(^PHCC("MIN_Code",$$ALPHAUP^SSUTIL4(MINORSubCatCODE),CATDR,SubCatDR)) ..RetErrorValue(RetStr,"取药理学小类已经存在:"_MINORSubCat) 
	IF ChangeType'="Test" d
	.K PLIST 
	.S PLIST(0)=CATDR_"||"_SubCatDR,PLIST(3)=MINORSubCatCODE,PLIST(4)=MINORSubCat
	.&SQL(INSERT INTO SQLUSER.PHC_MinorSubCat VALUES :PLIST())
	q:$g(SQLCODE) ..RetErrorValue(RetStr,"PHC_MinorSubCat -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	
	q:RetStr="" "Ok"
	q RetStr
}

/// 药品剂型
ClassMethod PhcForm(ChangeType As %String = "", RowStr As %String = "") As %String
{
	; ----*1*----*2-----
	;    CODE    DESC   
	IF ChangeType="Clear" K ^PHCF
	q:ChangeType="Clear" "数据已清:药品剂型"
	s RetStr="",del="^"
	;SET RowStr=$tr(RowStr," ","")
	SET CODE=$P(RowStr,del,1),DESC=$P(RowStr,del,2)
	Q:CODE="" "编码为空"
	Q:$D(^PHCF(0,$$ALPHAUP^SSUTIL4(CODE))) "编码已经存在"_CODE
	Q:$D(^PHCF(0,$$ALPHAUP^SSUTIL4(DESC))) "名称已经存在"_CODE
	if ChangeType'="Test" d
	.K PLIST
	.SET PLIST(2)=CODE,PLIST(3)=DESC
	.&SQL(INSERT INTO SQLUSER.PHC_FORM VALUES :PLIST())
	.if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"PH_Manufacturer -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

/// 用药频次
ClassMethod PhcFreq(ChangeType As %String = "", RowStr As %String = "") As %String
{
	IF ChangeType="Clear" K ^PHCFR
	q:ChangeType="Clear" "数据已清:药品用法"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1),Desc=$P(RowStr,del,2),Type=$P(RowStr,del,5),DispTime=$P(RowStr,del,7),EngName=$P(RowStr,del,6)
	if $g(Type)="" s Type=EngName
	s ConFac=$P(RowStr,del,3)
	q:$g(ConFac)="" "转换系数为空"
	s Days=$P(RowStr,del,4)
	q:Desc="" "名称为空"
	q:Code="" "代码为空"
	q:ConFac="" "转换系数为空"_Desc
	q:(($d(^PHCFR(0,"Code",$$ALPHAUP^SSUTIL4(Code))))&('$d(^PHCIN(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))) ..RetErrorValue(RetStr,"代码已经存在"_Code)
	q:(($d(^PHCFR(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))&('$d(^PHCFR(0,"Code",$$ALPHAUP^SSUTIL4(Code))))) ..RetErrorValue(RetStr,"名称已经存在"_Desc)
	if (('$d(^PHCFR(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))&('$d(^PHCFR(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))) d
	.if ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=Code,PLIST(3)=ConFac,PLIST(4)=Desc,PLIST(5)=$g(Type),PLIST(8)=$g(Days)
	..&SQL(INSERT INTO SQLUSER.PHC_Freq VALUES :PLIST())
	..if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"PHC_Freq -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..s phcFreqid=$o(^PHCFR(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	..i $g(DispTime)'="" & $g(phcFreqid)'="" d
	...s num=$l(DispTime,"/")
    ...s Time=""
    ...FOR I=0:1:num d
    ....s Time=$p(DispTime,"/",I)
    ....q:$g(Time)=""
    ....s Time=$zth(Time)
	....K PLIST
	....s PLIST(0)=phcFreqid,PLIST(3)=Time,PLIST(2)=I
	....&sql(INSERT INTO SQLUSER.PHC_DispensingTime VALUES :PLIST())
	....s:$g(SQLCODE) RetStr="PHC_DispensingTime"_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg) 
	q:RetStr="" "Ok"
	q RetStr
}

/// 疗程
ClassMethod Phcuration(ChangeType As %String = "", RowStr As %String = "") As %String
{
	IF ChangeType="Clear" K ^PHCFR
	q:ChangeType="Clear" "数据已清:药品用法"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1),ConFac=$P(RowStr,del,2),Desc=$P(RowStr,del,3),Type=$P(RowStr,del,4),EngName=$P(RowStr,del,5)
	if $g(Type)="" s Type=EngName
	q:$g(ConFac)="" "转换系数为空"
	q:Desc="" "名称为空"
	q:Code="" "代码为空"
	q:ConFac="" "转换系数为空"_Desc
	
	//^PHCDU(0,"Code",$$ALPHAUP^SSUTIL4(Code),{PHCDU_RowId})
	//^PHCDU(0,"Desc1",$$ALPHAUP^SSUTIL4(Desc),{PHCDU_RowId})
	q:(($d(^PHCDU(0,"Code",$$ALPHAUP^SSUTIL4(Code))))&('$d(^PHCDU(0,"Desc1",$$ALPHAUP^SSUTIL4(Desc))))) ..RetErrorValue(RetStr,"代码已经存在"_Code)
	q:(($d(^PHCDU(0,"Desc1",$$ALPHAUP^SSUTIL4(Desc))))&('$d(^PHCDU(0,"Code",$$ALPHAUP^SSUTIL4(Code))))) ..RetErrorValue(RetStr,"名称已经存在"_Desc)
	if (('$d(^PHCDU(0,"Desc1",$$ALPHAUP^SSUTIL4(Desc))))&('$d(^PHCDU(0,"Code",$$ALPHAUP^SSUTIL4(Code))))) d
	.if ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=Code,PLIST(3)=ConFac,PLIST(4)=Desc,PLIST(5)=$g(Type),PLIST(8)=$g(Days)
	..&SQL(INSERT INTO SQLUSER.PHC_Duration VALUES :PLIST())
	..if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"PHC_Duration -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

/// 用法
ClassMethod PhcInstruc(ChangeType As %String = "", RowStr As %String = "") As %String
{
	IF ChangeType="Clear" K ^PHCIN
	q:ChangeType="Clear" "数据已清:药品用法"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1),Desc=$P(RowStr,del,2),EngName=$P(RowStr,del,3)
	q:Desc="" "代码为空"
	q:Desc="" "名称为空"
	q:(($d(^PHCIN(0,"Code",$$ALPHAUP^SSUTIL4(Code))))&('$d(^PHCIN(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))) ..RetErrorValue(RetStr,"代码已经存在"_Code)
	q:(($d(^PHCIN(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))&('$d(^PHCIN(0,"Code",$$ALPHAUP^SSUTIL4(Code))))) ..RetErrorValue(RetStr,"名称已经存在"_Desc)
	if (('$d(^PHCIN(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))&('$d(^PHCIN(0,"Code",$$ALPHAUP^SSUTIL4(Code))))) d
	.if ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=Code,PLIST(3)=Desc,PLIST(5)=$g(EngName)
	..&SQL(INSERT INTO SQLUSER.PHC_INSTRUC VALUES :PLIST())
	..if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"PHC_INSTRUC -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

/// 管制分类
ClassMethod PhcPoison(ChangeType As %String = "", RowStr As %String = "") As %String
{
	; ----*1*---
	;    Name
 IF ChangeType="Clear" K ^PHCPO
	q:ChangeType="Clear" "数据已清:药理学分类"
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	S Code=$P(RowStr,del,1),Desc=$P(RowStr,del,2)
	q:Code="" "管理分类代码为空PHC_Cat"
	q:Desc="" "管理分类名称为空PHC_Cat"
	q:(($D(^PHCPO(0,"Code",$$ALPHAUP^SSUTIL4(Code))))&('$D(^PHCPO(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))) ..RetErrorValue(RetStr,"代码已经存在"_Code)
	q:(($D(^PHCPO(0,"Code",$$ALPHAUP^SSUTIL4(Code))))&('$D(^PHCPO(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))) ..RetErrorValue(RetStr,"名称已经存在"_Desc)
	IF (('$D(^PHCPO(0,"Code",$$ALPHAUP^SSUTIL4(Code))))&('$D(^PHCPO(0,"Desc",$$ALPHAUP^SSUTIL4(Desc))))) d 
	.IF ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=Code,PLIST(3)=Desc
	..&SQL(INSERT INTO SQLUSER.PHC_Poison VALUES :PLIST())
	..if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"PHC_Poison -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

/// 预约号的单位
ClassMethod PreUnit(ChangeType As %String = "", RowStr As %String = "") As %String
{
	
	IF ChangeType="Clear" K ^RBC("APTM")
	q:ChangeType="Clear" "数据已清:预约单位"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1),Desc=$P(RowStr,del,2)
	Q:Code="" "编码为空"
	Q:Desc="" "名称为空"
	Q:$D(^RBC("APTM",0,"Code",$$ALPHAUP^SSUTIL4(Code))) "编码已经存在"_Code
	Q:$D(^RBC("APTM",0,"Desc",$$ALPHAUP^SSUTIL4(Desc))) "编码已经存在"_Desc
	if ChangeType'="Test" d
	.K PLIST
	.SET PLIST(2)=Code,PLIST(3)=Desc,PLIST(4)="N",PLIST(5)=$h-2
	.&SQL(INSERT INTO SQLUSER.RBC_AppointMethod VALUES :PLIST())
	.if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RBC_AppointMethod -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

/// 出诊类别
ClassMethod RbSessionType(ChangeType As %String = "", RowStr As %String = "") As %String
{
	
	IF ChangeType="Clear" K ^RBC("SESS")
	q:ChangeType="Clear" "数据已清:出诊类别"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1)
	Q:Code="" "编码为空"
	Q:$D(^RBC("SESS",0,"Code",$$ALPHAUP^SSUTIL4(Code))) "编码已经存在"_Code
	Q:$D(^RBC("SESS",0,"Desc",$$ALPHAUP^SSUTIL4(Code))) "名称已经存在"_Code
	if ChangeType'="Test" d
	.K PLIST
	.SET PLIST(2)=Code,PLIST(3)=Code,PLIST(7)=$h-2
	.&SQL(INSERT INTO SQLUSER.RBC_SessionType VALUES :PLIST())
	.if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"RBC_SessionType -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod RetErrorValue(RetStr As %String = "", ErrorStr As %String = "") As %String
{
	if RetStr="" d
	.s:ErrorStr'="" RetStr=ErrorStr
	else  d
	.s:ErrorStr'="" RetStr=RetStr_"@"_"   "_ErrorStr
	q RetStr
}

ClassMethod SSGroup(ChangeType As %String = "", RowStr As %String = "") As %String
{
	/*
	q:ChangeType="Clear" "数据已清:安全组"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1),Desc=$P(RowStr,del,1)
	q:$g(Code)="" ""
	if ((Code'="") & (Desc'="")) d
	.s UserGroupDr="",GroupId=0,CircleFlag=1
	.f  s GroupId=$o(^SSU("SSGRP",GroupId)) q:((GroupId="")!(CircleFlag'=1))  d
	..s GroupName=$p(^SSU("SSGRP",GroupId),"^",1)
	..if GroupName=Code s CircleFlag=0  q
	.if CircleFlag=0 s RetStr=..RetErrorValue(RetStr,"安全组已经存在SS_User:"_GroupName) q
	.if ChangeType'="Test" d
 ..K PLIST
 ..s PLIST(3)=Code
 ..&SQL(INSERT INTO SQLUSER.SS_Group VALUES :PLIST())
 ..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"SS_Group -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 q:RetStr="" "Ok"
 q RetStr
 */
  q ""
}

ClassMethod SetGloble(RowStr) As %String
{
	s TmpStr=RowStr
	q:TmpStr="" ""
	s num=$l(TmpStr,"^"),i=0
	;f  s i=i+1 q:(i>num)  d
	;.s Str=$p(TmpStr,"^",i)
	;.s Str=$p(Str,"@")
	;.s $p(TmpStr,"^",i)=Str 
	S PatNo=$p(TmpStr,"^")
	S ^FHQIQIQ("DATA")=$I(^FHQIQIQ("DATA"))
	s ^FHQIQIQ0109(PatNo)=TmpStr
	Q ""
}

ClassMethod SetStrToGloble(RowStr, UpType) As %String
{
	s RetStr="",del="^"
	s TmpStr=RowStr
	q:TmpStr="" ""
	S ^TMPFHQ(UpType,0)=$I(^TMPFHQ(UpType,0))
	S ^TMPFHQ(UpType,^TMPFHQ(UpType,0))=TmpStr
	Q ""
}

/// 库存分类
ClassMethod StockType(ChangeType As %String = "", RowStr As %String = "") As %String
{
	IF ChangeType="Clear" K ^INC("SC"),^INC("TG")
	q:ChangeType="Clear" "数据已清:库存分类和盘点分类"
	s RetStr="",del="^"
	;INC_STKCAT ^INC("SC")  库存分类
	SET RowStr=$tr(RowStr," ","")
	SET CODE=$P(RowStr,del,1),DESC=$P(RowStr,del,2)
	if ((CODE'="") & (DESC'="")) d
	.i $d(^INC("SC",0,"Code",$$ALPHAUP^SSUTIL4(CODE))) s RetStr=..RetErrorValue(RetStr,"编码已经存在INC_STKCAT:"_CODE) 
 .i $d(^INC("SC",0,"Desc",$$ALPHAUP^SSUTIL4(DESC))) s RetStr=..RetErrorValue(RetStr,"名称已经存在INC_STKCAT:"_DESC)
 .i (('$d(^INC("SC",0,"Code",$$ALPHAUP^SSUTIL4(CODE))))&('$d(^INC("SC",0,"Desc",$$ALPHAUP^SSUTIL4(DESC))))) d 
 ..if ChangeType'="Test" d
 ...K PLIST
 ...s PLIST(2)=CODE,PLIST(3)=DESC
 ...&SQL(INSERT INTO SQLUSER.INC_STKCAT VALUES :PLIST())
 ...i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"INC_STKCAT -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	
	; ^INC("TG"), INC_STKTKGP  盘点分类
	SET CODE=$P(RowStr,del,3),DESC=$P(RowStr,del,4)
	if ((CODE'="") & (DESC'="")) d
	.i $d(^INC("TG",0,"INCTG_Code",$$ALPHAUP^SSUTIL4(CODE))) s RetStr=..RetErrorValue(RetStr,"编码已经存在INC_STKTKGP:"_CODE) 
 .i $d(^INC("TG",0,"INCTG_Desc",$$ALPHAUP^SSUTIL4(DESC))) s RetStr=..RetErrorValue(RetStr,"名称已经存在INC_STKTKGP:"_DESC)
 .i (('$d(^INC("TG",0,"INCTG_Code",$$ALPHAUP^SSUTIL4(CODE))))&('$d(^INC("TG",0,"INCTG_Desc",$$ALPHAUP^SSUTIL4(DESC))))) d 
 ..if ChangeType'="Test" d
 ...K PLIST
 ...s PLIST(2)=CODE,PLIST(3)=DESC
 ...&SQL(INSERT INTO SQLUSER.INC_STKTKGP VALUES :PLIST())
 ...i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"INC_STKTKGP -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 q:RetStr="" "Ok"
	q RetStr
}

/// 病人记帐系数
ClassMethod TarFac(ChangeType As %String = "", RowStr As %String = "") As %String
{
	IF ChangeType="Clear" k ^DHCTARF,^mdata("DHCTARFACTOR")
	q:ChangeType="Clear" "数据已清:记帐系数"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET PatType=$P(RowStr,del,1),TarSubType=$P(RowStr,del,2),TarItem=$P(RowStr,del,3)
	s PayRate=$P(RowStr,del,4),DisRate=$P(RowStr,del,5),PayLimit=$P(RowStr,del,6)
	s PayLimitRate=$P(RowStr,del,7)
  if PatType="" s RetStr=..RetErrorValue(RetStr,"病人类型为空") q RetStr
  set PatTypeDr=$o(^PAC("ADMREA",0,"Desc",$$ALPHAUP^SSUTIL4(PatType),""))
  if $g(PatTypeDr)="" s RetStr=..RetErrorValue(RetStr,"取病人类型指针出错"_PatType) q RetStr
  if TarSubType="" s RetStr=..RetErrorValue(RetStr,"费用子类为空") q RetStr
  set TarSubTypeDr=$o(^DHCTarC("SC",0,"Code",TarSubType,""))
  if $g(TarSubTypeDr)="" s RetStr=..RetErrorValue(RetStr,"取收费子类批针出错"_TarSubType) q RetStr
  if $g(TarItem)'="" d
  .s TarId=$o(^DHCTARI(0,"Desc",TarItem,""))
  .if ($g(TarId))="" s RetStr=..RetErrorValue(RetStr,"取收费项目指针出错"_TarItem) q 
  s CircleFlag=1
  if $g(TarId)="" d
  .if $d(^DHCTARF(0,"TARSC",PatTypeDr,TarSubTypeDr)) s CircleFlag=0
  q:(CircleFlag=0) RetStr
  if $g(TarId)'="" d
  .if $d(^DHCTARF(0,"TARI",PatTypeDr,TarId)) s CircleFlag=0
  q:(CircleFlag=0) RetStr
  q:(($g(PayRate)="")&($g(DisRate)="")) ..RetErrorValue(RetStr,"记帐系数和折扣都为空")
  k PLIST
  s PLIST(2)=PatTypeDr,PLIST(3)=TarSubTypeDr,PLIST(4)=$g(TarId),PLIST(7)=$g(DisRate),PLIST(8)=$g(PayRate)
  s PLIST(9)=$g(PayLimit),PLIST(10)=$g(PayLimitRate)
  s PLIST(5)=+$H
  &sql(insert into SQLUSER.DHC_TARfactor values PLIST())
  i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
  Q RetStr
}

/// 标本
ClassMethod CtSpecmen(ChangeType As %String = "", RowStr As %String = "") As %String
{
	IF ChangeType="Clear" k ^TTAB
	q:ChangeType="Clear" "数据已清:标本"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1),Desc=$P(RowStr,del,2),StratDate=+$h
	if Code="" s RetStr=..RetErrorValue(RetStr,"代码为空") q RetStr
	if Desc="" s RetStr=..RetErrorValue(RetStr,"描述为空") q RetStr 
	if $d(^TTAB("SPEC",Code)) s RetStr=..RetErrorValue(RetStr,"代码已经存在"_Code) q RetStr 
	s CircleFlag=1
	s SpecId=0
	f  s SpecId=$o(^TTAB("SPEC",SpecId)) q:((SpecId="")!(CircleFlag'=1))  d
	..s SpecDesc1=$p(^TTAB("SPEC",SpecId),"\",1)
	..if SpecDesc1=Desc s CircleFlag=0
	if CircleFlag=0 s RetStr=..RetErrorValue(RetStr,"名称已经存在"_Desc) q RetStr 
	if ChangeType'="Test" d
	.k PLIST
	.s PLIST(2)=Code,PLIST(3)=Desc,PLIST(4)=StratDate
	.&sql(insert into SQLUSER.CT_Specimen values :PLIST())
  	.i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
  	Q RetStr
}

/// 费用类别
ClassMethod TarType(ChangeType As %String = "", RowStr As %String = "") As %String
{
	; ----*1*----2-----
	;    CODE    SUBCODE  
	;
	IF ChangeType="Clear" d 
	.K ^ARCBG,^DHCTarC("AC"), ^DHCTarC("TMCNew"),^DHCTarC("MCNew"),^DHCTarC("CC"),^DHCTarC("EC"),^DHCTarC("IC"),^DHCTarC("MC"),^DHCTarC("OC"),^DHCTarC("SC")
	.k ^mdata("DHCTARAC"),^mdata("DHCTARCATE"),^mdata("DHCTAREC"),^mdata("DHCTARIC"),^mdata("DHCTARMC"),^mdata("DHCTAROC"),^mdata("DHCTARSUBCATE")
	.k ^DHCTarC("TAC"),^DHCTarC("TEC"),^DHCTarC("TIC"),^DHCTarC("TMC"),^DHCTarC("TOC")
	.k ^mdata("DHCTARACCTCATE"),^mdata("DHCTAREMCCATE"),^mdata("DHCTARINPATCATE"),^mdata("DHCTARMRCATE"),^mdata("DHCTAROUTPATCATE")
	q:ChangeType="Clear" "数据已清:帐单组,费用类别,住院发票,门诊发票,核算类,会计类,病案类"
	s RetStr="",del="^"
	S RowStr=$TR(RowStr," ","")
	S Code=$P(RowStr,del,1),SubCode=$P(RowStr,del,2)
	if ((Code'="")&(SubCode'="")) d
	.;IF $D(^ARCBG(0,"Code",$$ALPHAUP^SSUTIL4(Code))) s RetStr=..RetErrorValue(RetStr,"名称已经存在ARC_BillGrp:"_Code)
	.if ((ChangeType'="Test")&('$D(^ARCBG(0,"Code",$$ALPHAUP^SSUTIL4(Code))))) d
	..k PLIST
	..S PLIST(2)=Code,PLIST(3)=Code,PLIST(4)=Code
	..&SQL(INSERT INTO SQLUser.ARC_BillGrp VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"ARC_BillGrp -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
 .
 .;"ARC_BILLSUB BEGIN" 
	.S CodeDr=$O(^ARCBG(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	.if CodeDr="" s RetStr=..RetErrorValue(RetStr,"取帐单指针出错ARC_BILLSUB:"_Code) q
	.IF $D(^ARCBG("SG_Code",$$ALPHAUP^SSUTIL4(SubCode))) s RetStr=..RetErrorValue(RetStr,"名称已经存在ARC_BILLSUB:"_SubCode) q
	.if ChangeType'="Test" d
	..k PLIST
	..S PLIST(0)=CodeDr,PLIST(3)=SubCode,PLIST(4)=SubCode,PLIST(5)=SubCode
	..&SQL(INSERT INTO SQLUser.ARC_BILLSUB VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"ARC_BILLSUB -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	
	//收费大类
	S Code=$P(RowStr,del,4),SubCode=$P(RowStr,del,5)
	if ((Code'="")&(SubCode'="")) d
	.;IF $D(^DHCTarC("CC",0,"Code",$$ALPHAUP^SSUTIL4(Code))) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TARCATE:"_Code) q
	.if ((ChangeType'="Test")&('$D(^DHCTarC("CC",0,"Code",$$ALPHAUP^SSUTIL4(Code))))) d
	..k PLIST
	..S PLIST(2)=Code,PLIST(3)=Code
	..&SQL(INSERT INTO SQLUser.DHC_TARCATE VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TARCATE -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
 .
	.;"INSERT TABLE DHC_TARSubCatE BEGIN"
	.S CodeDr=$O(^DHCTarC("CC",0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	.b ;收费大类
	.if CodeDr="" s RetStr=..RetErrorValue(RetStr,"取收费大类指针出错DHC_TARSubCatE:"_Code) q
	.IF $D(^DHCTarC("SC",0,"Code",$$ALPHAUP^SSUTIL4(SubCode))) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TARSubCatE:"_SubCode) q
	.if ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=SubCode,PLIST(3)=SubCode,PLIST(4)=CodeDr
	..&SQL(INSERT INTO SQLUser.DHC_TARSubCatE VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TARSubCatE -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	//住院发票
	S Code=$P(RowStr,del,7),SubCode=$P(RowStr,del,8)
	if ((Code'="")&(SubCode'="")) d
	.;IF $D(^DHCTarC("TIC",0,"Code",$$ALPHAUP^SSUTIL4(Code))) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TARIC:"_Code) q
	.if ((ChangeType'="Test")&('$D(^DHCTarC("TIC",0,"Code",$$ALPHAUP^SSUTIL4(Code))))) d
	..k PLIST
	..S PLIST(2)=Code,PLIST(3)=Code
	..&SQL(INSERT INTO SQLUser.DHC_TARIC VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TARIC -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
 .
	.;"INSERT TABLE DHC_TARSubCatE BEGIN"
	.S CodeDr=$O(^DHCTarC("TIC",0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	.b ;住院大类
	.if CodeDr="" s RetStr=..RetErrorValue(RetStr,"取住院大类指针出错DHC_TARINPATCATE:"_Code) q
	.IF $D(^DHCTarC("IC",0,"Code",$$ALPHAUP^SSUTIL4(SubCode))) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TARINPATCATE:"_SubCode) q
	.if ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=SubCode,PLIST(3)=SubCode,PLIST(4)=CodeDr
	..&SQL(INSERT INTO SQLUser.DHC_TARINPATCATE VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TARINPATCATE -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	
	//门诊发票
	S Code=$P(RowStr,del,10),SubCode=$P(RowStr,del,11)
	if ((Code'="")&(SubCode'="")) d
	.;IF $D(^DHCTarC("TOC",0,"Code",$$ALPHAUP^SSUTIL4(Code))) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TAROC:"_Code) q
	.if ((ChangeType'="Test")&('$D(^DHCTarC("TOC",0,"Code",$$ALPHAUP^SSUTIL4(Code))))) d
	..k PLIST
	..S PLIST(2)=Code,PLIST(3)=Code
	..&SQL(INSERT INTO SQLUser.DHC_TAROC VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TAROC -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
 .
	.;"INSERT TABLE DHC_TARSubCatE BEGIN"
	.S CodeDr=$O(^DHCTarC("TOC",0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	.b ;门诊大类
	.if CodeDr="" s RetStr=..RetErrorValue(RetStr,"取门诊大类指针出错DHC_TarOutpatCate:"_Code) q
	.IF $D(^DHCTarC("OC",0,"Code",$$ALPHAUP^SSUTIL4(SubCode))) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TarOutpatCate:"_SubCode) q
	.if ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=SubCode,PLIST(3)=SubCode,PLIST(4)=CodeDr
	..&SQL(INSERT INTO SQLUser.DHC_TarOutpatCate VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TarOutpatCate -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	//核算分类
	S Code=$P(RowStr,del,13),SubCode=$P(RowStr,del,14)
	if ((Code'="")&(SubCode'="")) d
	.;IF $D(^DHCTarC("TEC",0,"Code",$$ALPHAUP^SSUTIL4(Code))) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TAREC:"_Code) q
	.if ((ChangeType'="Test")&('$D(^DHCTarC("TEC",0,"Code",$$ALPHAUP^SSUTIL4(Code))))) d
	..k PLIST
	..S PLIST(2)=Code,PLIST(3)=Code
	..&SQL(INSERT INTO SQLUser.DHC_TAREC VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TAREC -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
 .
	.;"INSERT TABLE DHC_TAREMCCATE BEGIN"
	.S CodeDr=$O(^DHCTarC("TEC",0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	.b ;核算大类
	.if CodeDr="" s RetStr=..RetErrorValue(RetStr,"取核算大类指针出错DHC_TAREMCCATE:"_Code) q
	.IF $D(^DHCTarC("EC",0,"Code",$$ALPHAUP^SSUTIL4(SubCode))) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TAREMCCATE:"_SubCode) q
	.if ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=SubCode,PLIST(3)=SubCode,PLIST(4)=CodeDr
	..&SQL(INSERT INTO SQLUser.DHC_TAREMCCATE VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TAREMCCATE -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	
	//会计科目
	S Code=$P(RowStr,del,16),SubCode=$P(RowStr,del,17)
	if ((Code'="")&(SubCode'="")) d
	.;IF $D(^DHCTarC("TAC",0,"Code",$$ALPHAUP^SSUTIL4(Code))) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TARAC:"_Code) q
	.if ((ChangeType'="Test")&('$D(^DHCTarC("TAC",0,"Code",$$ALPHAUP^SSUTIL4(Code))))) d
	..k PLIST
	..S PLIST(2)=Code,PLIST(3)=Code
	..&SQL(INSERT INTO SQLUser.DHC_TARAC VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TARAC -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
 .
	.;"INSERT TABLE DHC_TARACCTCATE BEGIN"
	.S CodeDr=$O(^DHCTarC("TAC",0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	.if CodeDr="" s RetStr=..RetErrorValue(RetStr,"取会计科目大类指针出错DHC_TARACCTCATE:"_Code) q
	.IF $D(^DHCTarC("AC",0,"Code",$$ALPHAUP^SSUTIL4(SubCode))) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TARACCTCATE:"_SubCode) q
	.if ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=SubCode,PLIST(3)=SubCode,PLIST(4)=CodeDr
	..&SQL(INSERT INTO SQLUser.DHC_TARACCTCATE VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TARACCTCATE -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	
	//病案分类
	S Code=$P(RowStr,del,19),SubCode=$P(RowStr,del,20)
	if ((Code'="")&(SubCode'="")) d
	.;IF $D(^DHCTarC("TMC",0,"Code",$$ALPHAUP^SSUTIL4(Code))) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TARMC:"_Code) q
	.if ((ChangeType'="Test")&('$D(^DHCTarC("TMC",0,"Code",Code)))) d
	..k PLIST
	..S PLIST(2)=Code,PLIST(3)=Code
	..&SQL(INSERT INTO SQLUser.DHC_TARMC VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TARMC -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
    ..s TmcRowid=$o(^DHCTarC("TMC",0,"Code",Code,""))
    ..if TmcRowid'="" s ^DHCTarC("TMCNew",TmcRowid)=Code_"^"_Code
    
	.S CodeDr=$O(^DHCTarC("TMC",0,"Code",Code,""))
	.if CodeDr="" s RetStr=..RetErrorValue(RetStr,"取病案大类指针出错DHC_TarMrCate:"_Code) q
	.IF $D(^DHCTarC("MC",0,"Code",SubCode)) s RetStr=..RetErrorValue(RetStr,"名称已经存在DHC_TarMrCate:"_SubCode) q
	.if ChangeType'="Test" d
	..k PLIST
	..S PLIST(2)=SubCode,PLIST(3)=SubCode,PLIST(4)=CodeDr
	..&SQL(INSERT INTO SQLUser.DHC_TarMrCate VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"DHC_TarMrCate -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	..s MCNewrowid=$o(^DHCTarC("MC",0,"Code",SubCode,""))
	..if MCNewrowid'="" s ^DHCTarC("MCNew",MCNewrowid)=SubCode_"^"_SubCode_"^"_CodeDr 
	s ^DHCTarC("AC",0)=^mdata("DHCTARAC")
	s ^DHCTarC("CC",0)=^mdata("DHCTARCATE")
	s ^DHCTarC("EC",0)=^mdata("DHCTAREC"),^DHCTarC("IC",0)=^mdata("DHCTARIC"),^DHCTarC("MC",0)=^mdata("DHCTARMC")
	s ^DHCTarC("OC",0)=^mdata("DHCTAROC"),^DHCTarC("SC",0)=^mdata("DHCTARSUBCATE")
	s ^DHCTarC("TAC",0)=^mdata("DHCTARACCTCATE"),^DHCTarC("TEC",0)=^mdata("DHCTAREMCCATE"),^DHCTarC("TIC",0)=^mdata("DHCTARINPATCATE")
	s ^DHCTarC("TMC",0)=^mdata("DHCTARMRCATE"),^DHCTarC("TOC",0)=^mdata("DHCTAROUTPATCATE")
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod UPPat(ChangeType As %String = "", RowStr As %String = "") As %String
{
	
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	//卡号^卡类型^登记号^姓名^性别^出生日期^证件类型^证件号码^门诊病历号^住院病历号^联系电话^病人类别^国籍^省^市^区县^邮编^工作单位^地址	
	s CardNo=$P(RowStr,del,1),Name=$P(RowStr,del,2)
	s CardType="注册医疗卡-1"
	q:$g(CardNo)="" "卡号为空"
	s CardNo=##class(web.DHCFBCM).ConvertStr(CardNo_"^0^15")
	;IF '$d(^DHCCARDi("CF",0,"CardNo",CardNo)) S ^FHQ1=$I(^FHQ1)
	if $d(^DHCCARDi("CF",0,"CardNo",CardNo)) d
	.s CfId=$o(^DHCCARDi("CF",0,"CardNo",CardNo,""))
 .s PapmiId=$p(^DHCCARD("CF",CfId),del,4)
 .q:($g(PapmiId)="")
 .&sql(update sqluser.pa_patmas set papmi_name=:Name where papmi_rowid=:PapmiId)
 Q ""
}

ClassMethod UpCareSpec(ChangeType As %String = "", RowStr As %String = "") As %String
{
	; ----*1*----*2-----
	;    CODE    spec   
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1),Spec=$P(RowStr,del,2)
	q:Code="" "编码为空"
	q:Spec="" "专长为空"
	s CtCareId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	q:$g(CtCareId)="" "医护人员不存在"_Code
	s CtSpecId=$o(^CT("SPC",0,"Desc",$$ALPHAUP^SSUTIL4(Spec),""))
	q:$g(CtSpecId)="" "取专长指针出错"_Spec
	&SQL(update SQLUSER.CT_CareProv set CTPCP_Spec_DR=:CtSpecId where CTPCP_RowId=:CtCareId)
	if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"CT_CareProv -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

ClassMethod UpCtloc(ChangeType As %String = "", RowStr As %String = "") As %String
{
	s RetStr="",del="^"
	s Code=$p(RowStr,del,1),Addr=$p(RowStr,del,2)
	q:Code="" ""
	q:Addr="" ""
	s rid=0
	s rid=$o(^CTLOC(0,"Code",Code,rid)) 
	q:$g(rid)="" "取科室指针出错"_Code
	
	if $d(^CTLOC(rid,"ADDR",0))  d
	.s ^CTLOC(rid,"ADDR",1)=Addr
	else  d
	.s ^CTLOC(rid,"ADDR",0)=1
	.s ^CTLOC(rid,"ADDR",1)=Addr
	q:RetStr="" "Ok"
	q RetStr
}

/// 摆药分类与医嘱子类类对照
Method PhcDisCatAndOrdSubCat(ChangeType As %String = "", RowStr As %String = "") As %String
{
}

/// 医嘱项的外部代码
ClassMethod OrdExtCode(ChangeType As %String = "", RowStr As %String = "") As %String
{
	s del="^"
	s RetStr=""
	SET RowStr=$tr(RowStr," ","")
	SET ArcimCode=$P(RowStr,del,1),ArcimDesc=$P(RowStr,del,2),OrdExtCode=$P(RowStr,del,3),OrdExtDesc=$P(RowStr,del,4),CtLocCode=$P(RowStr,del,5)
	IF OrdExtDesc="" S OrdExtDesc=OrdExtCode
	q:((ArcimCode="") ! (OrdExtCode="")!(CtLocCode="")) ..RetErrorValue(RetStr,"医嘱项目代码、外部代码、科室代码不能为空")
	s ArcimId1="",ArcimId2=""
	s ArcimId1=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcimCode),ArcimId1))
	Q:ArcimId1="" ..RetErrorValue(RetStr,"医嘱项目代码不存在"_ArcimCode)
	s ArcimId2=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcimCode),ArcimId1,ArcimId2))
	Q:ArcimId2="" ..RetErrorValue(RetStr,"医嘱项目代码不存在"_ArcimCode)
	s ArcimId=ArcimId1_"||"_ArcimId2
	S CtLocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtLocCode),""))
	q:CtLocId="" ..RetErrorValue(RetStr,"科室代码不存在"_CtLocCode)
	if ChangeType'="Test" d
	.k PLIST
	.s InsuTypeId=$o(^ARC("INST",0))
	.s PLIST(0)=ArcimId,PLIST(3)=+$h-1,PLIST(5)=InsuTypeId,PLIST(6)=OrdExtCode,PLIST(8)=OrdExtDesc,PLIST(10)=CtLocId
	.s PLIST(11)="Y",PLIST(12)="Y"
	.&sql(insert into SQLUSER.ARC_ItemExternalCodes VALUES :PLIST())
	.if $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"医嘱外部代码表 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 	q RetStr
}

/// 批量建卡 guobaoping
/// 数据格式  卡类型代码^卡类型名称^卡号^姓名^性别^出生日期^联系电话^住址^身份证号^病人类型(CT_SocialStatus表中的SS_Desc)(可以为空,默认自费)^是否绑定其他卡(1为需要绑定)^操作员工号(SS_User中的字段SSUSR_Initials)
/// 01^ 就诊卡^6217582600000011723^张三^男^1982-08-08^18761960795^广西北海市幸福小区幸福苑2幢102号^410203195612220063^自费^1^cashier
ClassMethod NewCard(ChangeType As %String = "", RowStr As %String = "") As %String
{
	s del="^"
	s RetStr=""
	SET RowStr=$tr(RowStr," ","")
	SET CardTypeCode=$P(RowStr,del,1),CardTypeDesc=$P(RowStr,del,2),CardNo=$P(RowStr,del,3),Name=$P(RowStr,del,4),Sex=$P(RowStr,del,5)
	Set Birth=$P(RowStr,del,6),TelHome=$P(RowStr,del,7),Address=$P(RowStr,del,8),IDCardNo=$P(RowStr,del,9)
	Set PatType=$P(RowStr,del,10),BindFlag=$P(RowStr,del,11),UserCode=$P(RowStr,del,12)
	;1.卡类型合法性检查
	q:(CardTypeCode="")&&(CardTypeDesc="") ..RetErrorValue(RetStr,"卡类型代码和卡代码名称不能为空")
	s CardTypeID=""
	s TmpCardTypeID=0 f  s TmpCardTypeID=$o(^DHCCARDTYPEDef(TmpCardTypeID))  q:(CardTypeID'="")||(TmpCardTypeID="")  d
	.s TmpCardTypeCode=$p(^DHCCARDTYPEDef(TmpCardTypeID),"^")
	.s TmpCardTypeDesc=$p(^DHCCARDTYPEDef(TmpCardTypeID),"^",2)
	.i (CardTypeCode'="")&&(CardTypeCode=TmpCardTypeCode)  s CardTypeID=TmpCardTypeID
	.q:CardTypeID'=""
	.i (CardTypeDesc'="")&&(CardTypeDesc=TmpCardTypeDesc)  s CardTypeID=TmpCardTypeID
	.q:CardTypeID'=""
	q:CardTypeID="" ..RetErrorValue(RetStr,"卡类型无法识别,请核对数据")
	;2.病人信息合法性检查
	;2.1卡号
	q:CardNo="" ..RetErrorValue(RetStr,"卡号不能为空")
	;2.2姓名
	q:Name="" ..RetErrorValue(RetStr,"患者姓名不能为空")
	;2.3性别
	q:Sex="" ..RetErrorValue(RetStr,"性别不能为空")
	s SexId=""
	s SexId=$o(^CT("SEX",0,"Desc",$$ALPHAUP^SSUTIL4(Sex),SexId))
	q:SexId="" ..RetErrorValue(RetStr,"性别不合法")
	;2.4出生日期
	q:Birth="" ..RetErrorValue(RetStr,"出生日期不能为空")
	q:($l(Birth,"-")'=3)||($l(Birth)'=10) ..RetErrorValue(RetStr,"出生日期不合法")
	
	;2.5联系电话
	q:TelHome="" ..RetErrorValue(RetStr,"联系电话不能为空")
	;2.6住址
	;q:Address="" ..RetErrorValue(RetStr,"住址不能为空")
	;2.7身份证号
	q:IDCardNo="" ..RetErrorValue(RetStr,"身份证号不能为空")
	q:($l(IDCardNo)'=15)&&($l(IDCardNo)'=18) ..RetErrorValue(RetStr,"身份证号不合法")
	;2.8 病人类型
	i PatType'="" s PatTypeId=$o(^CT("SS",0,"Desc",$$ALPHAUP^SSUTIL4(PatType),""))
	e  s PatTypeId=$o(^CT("SS",0,"Desc","自费",""))
	q:PatTypeId="" ..RetErrorValue(RetStr,"病人类型不能为空,默认值自费也存在")
	;2.9 操作员
	i UserCode'="" s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),""))
	e  s UserId=""
	q:(UserId="")||('$d(^SSU("SSUSR",UserId))) ..RetErrorValue(RetStr,"操作员不能为空")
	s newcardxml=""
	s myObj=##class(web.DHCEntity.PCA.NewCardInfo).%New()
	s myObj.CardTypeRowID=CardTypeID
	s myObj.CardNo=CardNo
	s myObj.Name=Name
	s myObj.Sex=Sex
	s myObj.Birth=Birth
	s myObj.TelHome=TelHome
	s myObj.Address=Address
	s myObj.IDCardNo=IDCardNo
	s myObj.PatType=PatTypeId
	s myObj.BindFlag=BindFlag
	s myObj.UserDR=UserId
	s rtn=myObj.XMLExportToString(.newcardxml,"NewCardInfo")
	i ($system.Status.IsError(rtn)) {
		q ..RetErrorValue(RetStr,"web.DHCEntity.PCA.NewCardInfo初始化异常")
	}
	d myObj.%Close()
	q:newcardxml="" ..RetErrorValue(RetStr,"建卡信息为空")
	if ChangeType'="Test" d
	.b ;newcardxml
	.s rtn=##class(web.DHCDocService).NewCardClass(newcardxml)
	.i rtn'="0" s RetStr=..RetErrorValue(RetStr,##class(web.DHCDocService).GetNewCardErrMsg(rtn))
 	q RetStr
}

// 学历

ClassMethod CtEducation(ChangeType As %String = "", RowStr As %String = "") As %String
{
	
	;w ##class(web.DHCFHQ.DHCFFHQ).CtEducation("","03^博士")

	if ChangeType="Clear" K ^CT("EDU")
	q:ChangeType="Clear" "数据已清"_"^CT("_"EDU"_")"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1)
	SET Desc=$P(RowStr,del,2)
	Q:Code="" RetStr="学历代码为空!"
	Q:Desc="" RetStr="学历描述为空!"
	if '$d(^CT("EDU",0,"Code",$$ALPHAUP^SSUTIL4(Code))) d
	.if ChangeType'="Test" d
	..K PLIST
	..SET PLIST(2)=Code,PLIST(3)=Desc
 	..&SQL(INSERT INTO SQLUSER.CT_Education VALUES :PLIST())
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"CT_Education -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

/// 职业
ClassMethod CtOccupation(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" K ^CT("OCC")
	q:ChangeType="Clear" "数据已清"_"^CT("_"OCC"_")"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1)
	SET Desc=$P(RowStr,del,2)
	Q:Code="" RetStr="职业代码为空!"
	Q:Desc="" RetStr="职业描述为空!"
	if '$d(^CT("OCC",0,"Code",$$ALPHAUP^SSUTIL4(Code))) d
	.if ChangeType'="Test" d
	..K PLIST
	..SET PLIST(2)=Code,PLIST(3)=Desc,PLIST(4)=$h-2
 	..&SQL(INSERT INTO SQLUSER.CT_Occupation VALUES :PLIST())
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"CT_Occupation -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

/// 关系
ClassMethod CtRelation(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" K ^CT("RLT")
	q:ChangeType="Clear" "数据已清"_"^CT("_"RLT"_")"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1)
	SET Desc=$P(RowStr,del,2)
	Q:Code="" RetStr="职业代码为空!"
	Q:Desc="" RetStr="职业描述为空!"
	if '$d(^CT("RLT",0,"Code",$$ALPHAUP^SSUTIL4(Code))) d
	.if ChangeType'="Test" d
	..K PLIST
	..SET PLIST(2)=Code,PLIST(3)=Desc,PLIST(4)=$h-2
 	..&SQL(INSERT INTO SQLUSER.CT_Relation VALUES :PLIST())
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"CT_Relation -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

/// 轮转医生
ClassMethod CtTransDoc(ChangeType As %String = "", RowStr As %String = "") As %String
{
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET CTPCPROWID=$P(RowStr,del,1)
	SET CODE=$P(RowStr,del,2)
	SET DOCName=$P(RowStr,del,3)
	Q:CTPCPROWID="" RetStr="rowid代码为空!"
	Q:CODE="" RetStr="code代码为空!"
	s rowid=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(CODE),""))
	
	if '$d(^DHCTRDOCi(0,"CTPCP",CTPCPROWID)) d
	.if CTPCPROWID=rowid d
 	..&SQL(INSERT INTO SQLUSER.DHC_TransferDoc(DHCTRD_CTPCP_Dr) VALUES ((:CTPCPROWID)))
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_TransferDoc -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

// 新增轮转医生Rbresource

ClassMethod RBResourceDate(ChangeType As %String = "", RowStr As %String = "") As %String
{
    //	用户代码	用户姓名	新科室
	//w ##class(web.DHCFHQ.DHCFFHQ).RBResourceDate("","000202^体检内科^1120010^DOCTOR")
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	SET usercode=$P(RowStr,del,1),username=$P(RowStr,del,2),defloccode=$P(RowStr,del,3),CpType=$P(RowStr,del,4)
    if (CpType="DOCTOR")||(CpType="NURSE") d 
	.s i=1
	.for  s CtLoc=$p(defloccode,"/",i) q:CtLoc=""  d
	..s i=i+1
	..s CtLocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtLoc),""))
	..if CtLocId="" s RetStr=..RetErrorValue(RetStr,"取人员科室指针出错RB_Resource:"_CtLoc) q
	..s CareProvId=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(usercode),""))
	..IF CareProvId="" s RetStr=..RetErrorValue(RetStr,"取医护人员指针出错:"_usercode) q
	..i $d(^RB("RES",0,"CTPCP",CareProvId,CtLocId)) s RetStr=..RetErrorValue(RetStr,"科室用户资源已经存在:"_usercode) q
	..e   d
	...if ChangeType'="Test" d
	....k PLIST
	....s PLIST(3)=CtLocId,PLIST(4)=CareProvId,PLIST(7)=usercode,PLIST(8)=username,PLIST(11)=-1,PLIST(16)=999
	....s PLIST(19)="Care Provider",PLIST(20)="Y",PLIST(21)="Y",PLIST(33)="Y"
	....&sql(INSERT INTO SQLUser.RB_Resource VALUES :PLIST())
	....s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"RB_Resource -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	q:RetStr="" "Ok"
	q RetStr_"^"_"no"
}

// 号别对照

ClassMethod InsertDepMark(ChangeType As %String = "", RowStr As %String = "") As %String
{
    //	诊区ID	诊区名称	号别代码	号别姓名   科室代码  科室描述   状态  标志  需要报到
    //RoomDr,:CompDr,:MarkDr,:st,:si,:Checkin 
    //CTCareProv  CTCareProv   CT_loc
	//w ##class(web.DHCFHQ.DHCFFHQ).InsertDepMark("","79^口腔科诊区^03857^吴青^1530010^KQKMZ-口腔科门诊^1^Y^N")
 
	s del="^",RetStr=""
	SET RowStr=$tr(RowStr," ","")
	SET RoomID=$P(RowStr,del,1),RoomName=$P(RowStr,del,2),MarkCode=$P(RowStr,del,3),MarkName=$P(RowStr,del,4),CtCode=$P(RowStr,del,5),CtDesc=$P(RowStr,del,6),State=$P(RowStr,del,7),Sign=$P(RowStr,del,8),Checkin=$P(RowStr,del,9)
    Quit:'$d(^User.DHCExaBoroughD(RoomID)) ..RetErrorValue(RetStr,"诊区不存在"_RoomID)
    s MarkDr=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(MarkCode),""))
    q:MarkDr="" ..RetErrorValue(RetStr,"号别为空"_MarkCode)  
    s CompDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtCode),""))   
    q:CompDr="" ..RetErrorValue(RetStr,"科室为空"_CtCode)
    s ccode = ""
 
    &sql(SELECT ID into :ccode FROM SQLUser.DHCDepMark
                       where DepmborDr=:RoomID and DepmMarkDr=:MarkDr  and DepmdepDr=:DepmdepDr)
        
   

    if SQLCODE=0  s RetStr="诊区和号别对照重复"_RoomName_"^"_MarkCode_"^"_CtCode
    if SQLCODE=100 d inbor
 
    q:RetStr="" "Ok"
    q RetStr_"^"_"no"
inbor
  &sql(insert into SQLUser.DHCDepMark
 (DepmborDr,DepmdepDr,DepmMarkDr,DepmState,DepmSign,DepmCheckin)
 values(:RoomID,:CompDr,:MarkDr,:State,:Sign,:Checkin))
}

// 手术

ClassMethod Operation(ChangeType As %String = "", RowStr As %String = "") As %String
{
	
	; ----*1*------------2---------3----------4------
	;    OperCode    operdesc    operalias  OperIcd
	;
	IF ChangeType="Clear" K ^ORC("OPER")
	q:ChangeType="Clear" "Operation数据已经清除"
	s del="^"
	s RetStr=""
	SET RowStr=$tr(RowStr," ","")
	s OperCode=$P(RowStr,del,1),OperDesc=$P(RowStr,del,2),OperAlias=$P(RowStr,del,3),OperIcd=$P(RowStr,del,4)
	q:$d(^ORC("OPER",0,"Desc",$$ALPHAUP^SSUTIL4(OperDesc))) ""
	q:(OperCode="")!(OperDesc="") "代码或名称为空"
	if ((OperCode'="")&(OperDesc'="")) d
	.IF (($D(^ORC("OPER",0,"Code",$$ALPHAUP^SSUTIL4(OperCode))))&('$D(^ORC("OPER",0,"Code",$$ALPHAUP^SSUTIL4(OperCode))))) s RetStr=..RetErrorValue(RetStr,"代码已经存在Mrc_Icddx:"_OperCode) q
	.IF (($D(^ORC("OPER",0,"Desc",$$ALPHAUP^SSUTIL4(OperDesc))))&('$D(^ORC("OPER",0,"Desc",$$ALPHAUP^SSUTIL4(OperDesc))))) s RetStr=..RetErrorValue(RetStr,"名称已经存在Mrc_Icddx:"_OperDesc) q
	.if ((ChangeType'="Test")&('$D(^ORC("OPER",0,"Code",$$ALPHAUP^SSUTIL4(OperCode))))) d
	..k PLIST
	..S PLIST(2)=OperCode,PLIST(3)=OperDesc,PLIST(6)=+$h-1,PLIST(15)=$g(OperIcd)
	..&sql(INSERT INTO SQLUser.ORC_Operation VALUES :PLIST())
	..i $g(SQLCODE) s RetStr=..RetErrorValue(RetStr,"ORC_Operation -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg)) q
	..q:$g(SQLCODE)

 	s OperId=$o(^ORC("OPER",0,"Code",$$ALPHAUP^SSUTIL4(OperCode),""))
 	q:OperId="" ..RetErrorValue(RetStr,"取指针出错"_OperCode)
	i OperAlias'="" d
 	.set I=1
 	.s num=$l(OperAlias,"/")
 	.s ALI=""
 	.FOR I=1:1:num d
 	..s ALI=$p(OperAlias,"/",I)
 	..s ALI=$$ALPHAUP^SSUTIL4(ALI)
 	..if ChangeType'="Test" d
 	...q:$d(^ORC("OPER",0,"ALIAS",$$ALPHAUP^SSUTIL4(ALI),OperId))
 	...k PLIST 
 	...S PLIST(0)=OperId,PLIST(3)=ALI
 	...&SQL(INSERT INTO SQLUser.ORC_OperationAlias VALUES PLIST()) 
 	...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ORC_OperationAlias -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q RetStr
}

// ArcInsuranceType  //商业保险公司

ClassMethod ArcInsuranceType(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" K ^ARC("INST")
	q:ChangeType="Clear" "数据已清"_"^ARC("_"INST"_")"
	s RetStr="",del="^"
	s ^TempArc(0)=ChangeType_"^"_RowStr
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1)
	SET Desc=$P(RowStr,del,2)
	Q:Code="" RetStr="保险公司代码为空!"
	Q:Desc="" RetStr="保险公司描述为空!"
	if '$d(^ARC("INST",0,"Code",$$ALPHAUP^SSUTIL4(Code))) d
	.if ChangeType'="Test" d
	..K PLIST
	..SET PLIST(2)=Code,PLIST(3)=Desc,PLIST(14)=$h-2
 	..&SQL(INSERT INTO SQLUSER.ARC_InsuranceType VALUES :PLIST())
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ARC_InsuranceType -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

// 更新药学项目的其他信息

ClassMethod UpdateDrugotherinfo(ChangeType As %String = "", RowStr As %String = "") As %String
{
	//w ##class(web.DHCFHQ.DHCFFHQ).UpdateDrugotherinfo("",RowStr)
	//1代码^2库存药学名称^3医嘱名称^4打印名称86^5说明书通用名87^6通用名ID^7生效日期70^8删除^9皮试^10招标供应57
	//^11招标产地58^12Big规格59^13基本药物84^14贵重标记72^15制剂标记^16原料标记^17医保标志74^18医保编码75^19医保库内名称76^20收费编码68
	//^21协和码54^22招标标志55^23剂型^24管制15^25商品名66^26产地46^27创建人
	;if ChangeType="Clear" K ^DHCITMINFO
	;q:ChangeType="Clear" "数据已清"_"^DHCITMINFO"
	s enddate=""
	s RetStr="",del="^"
	s DrugDesc=$tr($p(RowStr,del,2),$c(10,13),"")     //药学项，库存项名称
	S OrdDesc=$tr($p(RowStr,del,3),$c(10,13),"")      //医嘱项名称
	s Specification=$tr($p(RowStr,del,12),$c(10,13),"")        //规格
	SET RowStr=$tr(RowStr," ","")
    SET Code=$P(RowStr,del,1)                         //代码
	s PrintDesc=$tr($p(RowStr,del,4)," ")             //打印名称
	s smstym=$tr($p(RowStr,del,5)," ")                //说明书通用名
	s tym=$tr($p(RowStr,del,6)," ")                   //通用名
    s startdate=$tr($p(RowStr,del,7)," ")             //生效日期
    if $g(startdate)'="" s startdate=$zdh(startdate,3)
    s delflag= $P(RowStr,del,8)                       //删除
	s psflag=$tr($p(RowStr,del,9)," ")                //皮试
	i $g(psflag)=""  s psflag="N"
	s zbgys=$tr($p(RowStr,del,10)," ")                //招标供应商
	s zbcd=$tr($p(RowStr,del,11)," ")                 //招标产地
    s jbywflag=$tr($p(RowStr,del,13)," ")             //基本药物
    i $g(jbywflag)="" s jbywflag="N"
    s gzflag= $P(RowStr,del,14)                       //贵重标记
    i $g(gzflag)="" s gzflag="N" 
	s zjflag=$tr($p(RowStr,del,15)," ")               //制剂标记
	i $g(zjflag)="" s zjflag=0
	s ylflag=$tr($p(RowStr,del,16)," ")               //原料标记
	i $g(ylflag)="" s ylflag=0
	s ybflag=$tr($p(RowStr,del,17)," ")               //医保标志
    s ybcode=$tr($p(RowStr,del,18)," ")               //医保编码
    s ybname= $P(RowStr,del,19)                       //医保库内名称
	s sfcode=$tr($p(RowStr,del,20)," ")               //收费编码
	s xhm=$tr($p(RowStr,del,21)," ")                  //协和码
	s zbflag=$tr($p(RowStr,del,22)," ")               //招标标志
	i $g(zbflag)="" s zbflag=0
    s jx=$tr($p(RowStr,del,23)," ")                   //剂型
    s gzfl= $P(RowStr,del,24)                         //管制
	s spdesc=$tr($p(RowStr,del,25)," ")               //商品名
	//s cd=$tr($p(RowStr,del,26)," ")                 //产地
	//s createuser=$tr($p(RowStr,del,27)," ")         //创建人
	q:Code="" ..RetErrorValue(RetStr,"代码为空")
	s Tarirowid=$O(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	q:Tarirowid="" "收费项不存在"_Code
	s ArcimId=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	q:ArcimId="" "医嘱项不存在"_Code
	s ArcimSubId=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(Code),ArcimId,""))
	q:ArcimSubId="" "医嘱项不存在"_Code
	s ArcimRowId=ArcimId_"||"_ArcimSubId
	s PhcdRowID=$o(^PHCD(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	q:PhcdRowID="" "药学项不存在"_Code
	s Incitmid=$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	q:Incitmid="" "药学项不存在"_Code

    
    //药学项
    //通用名
    s GenericId="",GenericName=""
	if $g(tym)'="" d
	.s GenericId=$o(^PHCGE("GE",0,"Code",$$ALPHAUP^SSUTIL4(tym),0))
	.if GenericId'="" d
	..s GenericName=$p(^PHCGE("GE",GenericId),"^",2)
	..&SQL(update sqluser.phc_drgmast set PHCD_Generic_DR=:GenericId where PHCD_RowId=:PhcdRowID)
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"phc_drgmast通用名 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..q:$g(SQLCODE)
	..&SQL(update sqluser.arc_itmmast set ARCIM_Generic_DR=:GenericId,ARCIM_GenericDesc=:GenericName where(arcim_rowid=:ArcimRowId) and (arcim_code=:Code))
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"arc_itmmast通用名 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..q:$g(SQLCODE)
	//产地
	s manfdr=""     
	i zbcd'="" d
	.s manfdr=$o(^PHMNF(0,"Code",$$ALPHAUP^SSUTIL4(zbcd),""))
	&SQL(update sqluser.PHC_DrgMast set PHCD_PHMNF_DR=:manfdr where (PHCD_RowId =:PhcdRowID) and (phcd_code=:Code) )
	s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"PHC_DrgMast产地 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
    
    //供应商
	s VendorId=""
 	i $g(zbgys)'="" d
    .s VendorId=$o(^APC("APCVM",0,"APCVM_Code",$$ALPHAUP^SSUTIL4(zbgys),""))
    
   
    //剂型
	s PhcFormDr=""
	i $g(jx)'="" d
	.s PhcFormDr=$o(^PHCF(0,"Code",$$ALPHAUP^SSUTIL4(jx),"")) 
	.if PhcFormDr'=""  d
	..&SQL(update sqluser.PHC_DrgForm set PHCDF_PHCF_DR=:PhcFormDr where (PHCDF_PHCD_ParRef =:PhcdRowID) )
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"PHC_DrgForm剂型 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
    //说明书通用名
    &SQL(update sqluser.PHC_DrgForm set PHCDF_OfficialCode=:smstym where (PHCDF_PHCD_ParRef =:PhcdRowID) )
	s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"PHC_DrgForm说明书通用名 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))

    //管制分类
	S ManTypeId=""
	if $g(gzfl)'="" d
	.s ManTypeId=$o(^PHCPO(0,"Desc",$$ALPHAUP^SSUTIL4(gzfl),0))
	.if ManTypeId'=""  d
	..&SQL(update sqluser.PHC_DrgMast set PHCD_PHCPO_DR=:ManTypeId where (PHCD_RowId =:PhcdRowID) and (phcd_code=:Code) )
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"PHC_DrgMast管制分类 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
    ..q:$g(SQLCODE)
    //停止医嘱项目
   	i delflag'=""  d
	.s stopdate=+$h
	.&SQL(update sqluser.arc_itmmast set arcim_effdateto=:stopdate where (arcim_rowid=:ArcimRowId) and (arcim_code=:Code))
	.s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"arc_itmmast停止医嘱项目 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	.q:$g(SQLCODE)
	.q:'$d(^DHCTARI(Tarirowid))
   	.s Activeflag="N"
	.&SQL(update sqluser.DHC_Taritem set TARI_EndDate=:stopdate,TARI_ActiveFlag=:Activeflag where (Tari_rowid=:Tarirowid) and (tari_code=:Code))
	.s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_Taritem停止医嘱项目 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
    .q:$g(SQLCODE)
    e  d
	.s stopdate=""
	.&SQL(update sqluser.arc_itmmast set arcim_effdateto=:stopdate where (arcim_rowid=:ArcimRowId) and (arcim_code=:Code))
	.s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"arc_itmmast停止医嘱项目 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	.q:$g(SQLCODE)
	.q:'$d(^DHCTARI(Tarirowid))
   	.s Activeflag="Y"
	.&SQL(update sqluser.DHC_Taritem set TARI_EndDate=:stopdate,TARI_ActiveFlag=:Activeflag where (Tari_rowid=:Tarirowid) and (tari_code=:Code))
	.s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_Taritem停止医嘱项目 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
    .q:$g(SQLCODE)
    
    
    
    
    //生效日期
   	i startdate'=""  d
	.&SQL(update sqluser.arc_itmmast set arcim_effdate=:startdate where (arcim_rowid=:ArcimRowId) and (arcim_code=:Code))
	.s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"arc_itmmast生效日期 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	.q:'$d(^DHCTARI(Tarirowid))
	.&SQL(update sqluser.DHC_Taritem set TARI_StartDate=:startdate  where (Tari_rowid=:Tarirowid) and (tari_code=:Code))
	.s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_Taritem生效日期 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	.q:$g(SQLCODE)
	//计费项目其他内容
	i $d(^DHCTARI(Tarirowid))  d
	.&SQL(update sqluser.DHC_Taritem set TARI_ExternalCode=:ybcode,TARI_InsuName=:ybname  where Tari_rowid=:Tarirowid)
	.s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_Taritem计费项目其他内容 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	.q:$g(SQLCODE)
	//收费编码
	i $g(sfcode)'=""  d
	.i $d(^DHCTARIEXPINFO(0,"TARI",Tarirowid))  d
	..s TariExpRowID=$o(^DHCTARIEXPINFO(0,"TARI",Tarirowid,""))
	..//&SQL(update SQLUser.DHC_TaritemExpInfo set TariExp_TariCode=:sfcode where TariExp_RowID=:TariExpRowID)
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_TaritemExpInfo收费编码 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..q:$g(SQLCODE)
	.e  d
	..s PLIST(13)=Tarirowid,PLIST(10)=sfcode
	..//&sql(INSERT INTO SQLUser.DHC_TaritemExpInfo VALUES :PLIST())
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_TaritemExpInfo -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..q:$g(SQLCODE)
	 //医嘱项目名称和计费项目名称
	i $g(OrdDesc)'=""  d
	.&SQL(update sqluser.arc_itmmast set arcim_Desc=:OrdDesc where (arcim_rowid=:ArcimRowId) and (arcim_code=:Code))
	.s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"arc_itmmast医嘱名称 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	.&SQL(update sqluser.dhc_taritem set tari_Desc=:OrdDesc where (Tari_rowid=:Tarirowid) and (tari_code=:Code))
	.s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_taritem医嘱名称 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	.q:$g(SQLCODE)
	//药学项目与库存项目名称,打印名称
   	i $g(DrugDesc)'=""  d
	.&SQL(update sqluser.PHC_DrgMast set PHCD_Name=:DrugDesc where (PHCD_RowId =:PhcdRowID) and (phcd_code=:Code))
    .s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"arc_itmmast药学名称 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	.q:$g(SQLCODE)
	.&SQL(update sqluser.inc_itm set INCI_Desc=:DrugDesc where (inci_code=:Code) and (inci_rowid=:Incitmid))
    .s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"inc_itm药学名称 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	.q:$g(SQLCODE)
	//商品名
	i $g(spdesc)'=""  d
	.&SQL(update sqluser.PHC_DrgMast set PHCD_LabelName1=:spdesc where (PHCD_RowId =:PhcdRowID) and (phcd_code=:Code))
    .s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"arc_itmmast商品名 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	//打印名称
	i $g(PrintDesc)'=""  d
	.&SQL(update sqluser.PHC_DrgMast set PHCD_LabelName2 =:PrintDesc where (PHCD_RowId =:PhcdRowID) and (phcd_code=:Code))
    .s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"arc_itmmast打印名称 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	.q:$g(SQLCODE)
	//药品规格
	i (($g(Specification)'="") &(Incitmid'=""))  d 
	.s inforowid=""
	.i $d(^DHCITMINFO(0,"INCI",Incitmid)) d
	..s inforowid=$o(^DHCITMINFO(0,"INCI",Incitmid,""))  
	..q:inforowid=""  
	..&SQL(update SQLUser.DHC_ItmAddionInfo set INFO_Spec=:Specification  where INFO_RowId=:inforowid)
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_ItmAddionInfo规格 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..q:$g(SQLCODE)
	.e  d
	..s PLIST(28)=Specification
	..s PLIST(2)=Incitmid
	..&sql(INSERT INTO SQLUser.DHC_ItmAddionInfo VALUES :PLIST())
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_ItmAddionInfo规格 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..q:$g(SQLCODE)
   
   //招标标记
    i $g(zbflag)'=""  d
	.&SQL(update sqluser.inc_itm set INCI_INCCA_DR=:zbflag where (inci_code=:Code) and (inci_rowid=:Incitmid))
    .s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"inc_itm招标标记 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	.q:$g(SQLCODE)
   //协和码
    i $g(xhm)'=""  d
	.&SQL(update sqluser.inc_itm set INCI_ReportingDays=:xhm where (inci_code=:Code) and (inci_rowid=:Incitmid))
	.s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"inc_itm协和码 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	.q:$g(SQLCODE)
	
	
	//皮式标记
	i $g(psflag)'=""  d
	.s psflag="Y"
	.s inforowid=""
	.i $d(^DHCITMINFO(0,"INCI",Incitmid))  d
	..s inforowid=$o(^DHCITMINFO(0,"INCI",Incitmid,""))  
	..q:inforowid=""
	..//&SQL(update SQLUser.DHC_ItmAddionInfo set INFO_SkinTest=:psflag  where INFO_RowId=:inforowid)
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_ItmAddionInfo皮式标记 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..q:$g(SQLCODE)
	.e  d
	..K PLIST
	..s PLIST(2)=Incitmid,PLIST(36)=psflag
	..//&sql(INSERT INTO SQLUser.DHC_ItmAddionInfo VALUES :PLIST())
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_ItmAddionInfo皮式标记 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..q:$g(SQLCODE)
	
	
    //DHC_ItmAddionInfo其他标记
    s inforowid=""
	i $d(^DHCITMINFO(0,"INCI",Incitmid))  d
	.s inforowid=$o(^DHCITMINFO(0,"INCI",Incitmid,""))  
	.q:inforowid="" 
	.//&SQL(update SQLUser.DHC_ItmAddionInfo set INFO_PbVendor_DR=:VendorId,INFO_PbManf_DR=:manfdr,INFO_PDrugbase1=:zjflag,INFO_PDrugbase2=:ylflag,INFO_BasicDrug=:jbywflag,INFO_HighPrice=:gzflag where INFO_RowId=:inforowid)
	.s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_ItmAddionInfo其他标记 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	.q:$g(SQLCODE)
	e  d
	.K PLIST
	.s PLIST(2)=Incitmid
	.s PLIST(25)=VendorId,PLIST(26)=manfdr,PLIST(42)=zjflag,PLIST(43)=ylflag,PLIST(5)=jbywflag,PLIST(13)=gzflag
	.&sql(INSERT INTO SQLUser.DHC_ItmAddionInfo VALUES :PLIST())
	.s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"DHC_ItmAddionInfo其他标记 -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	.q:$g(SQLCODE)

    
    
	q:RetStr="" "Ok"
	q RetStr_"^"_"no"
}

// CT_HealthCareProvider  //病人记账单位

ClassMethod CTHealthCareProvider(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" K ^CT("HCP")
	q:ChangeType="Clear" "数据已清"_"^CT("_"HCP"_")"
	s RetStr="",del="^"
	s ^TempArc(0)=ChangeType_"^"_RowStr
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1)    //记账单位代码
	SET Desc=$P(RowStr,del,2)    //记账单位名称
	set phone=$P(RowStr,del,3)    //记账单位联系电话
	set address=$P(RowStr,del,4)  //记账单位地址
	set accountno=$P(RowStr,del,5)    //账号
	set bankaddress=$P(RowStr,del,6)  //银行
	set flag=$P(RowStr,del,7)     //停止标记
	set contracttype=$P(RowStr,del,8)   //合同单位类型
	set zipcode=$P(RowStr,del,9)    //邮编
	set startdate=$P(RowStr,del,10)  //开始日期
	set enddate=$P(RowStr,del,11)    //结束日期
	set pycode=$P(RowStr,del,12)     //拼音
	set accallname=$P(RowStr,del,13) //账户全称
	Q:Code="" RetStr="记账单位代码为空!"
	Q:Desc="" RetStr="记账单位描述为空!"
	if '$d(^CT("HCP",0,"Code",$$ALPHAUP^SSUTIL4(Code))) d
	.if ChangeType'="Test" d
	..K PLIST
	..SET PLIST(2)=Code,PLIST(3)=Desc
 	..&SQL(INSERT INTO SQLUSER.CT_HealthCareProvider VALUES :PLIST())
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"CT_HealthCareProvider -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	..q:$g(SQLCODE)
	..s HCPRowId=$o(^CT("HCP",0,"Code",Code,""))
	..s $p(^CT("HCP",HCPRowId),"^",6)=$g(bankaddress) ;银行
	..s $p(^CT("HCP",HCPRowId),"^",7)=$g(accountno)  ;账号
	..s $p(^CT("HCP",HCPRowId),"^",8)=$g(flag)  ;标记
	..s $p(^CT("HCP",HCPRowId),"^",9)=$g(phone)  ;记账单位电话
	..s $p(^CT("HCP",HCPRowId),"^",10)=$g(address)  ;记账单位地址
	..s $p(^CT("HCP",HCPRowId),"^",11)=$g(contracttype)  ;合同类型
	..s $p(^CT("HCP",HCPRowId),"^",12)=$g(zipcode)  ;邮编
	..s $p(^CT("HCP",HCPRowId),"^",13)=$g(startdate)  ;开始日期
	..s $p(^CT("HCP",HCPRowId),"^",14)=$g(enddate)  ;结束日期
	..s $p(^CT("HCP",HCPRowId),"^",15)=$g(pycode)  ;拼音码
	..s $p(^CT("HCP",HCPRowId),"^",16)=$g(accallname)  ;帐户全称
	e  d
	.s HCPRowId=$o(^CT("HCP",0,"Code",Code,""))
	.s $p(^CT("HCP",HCPRowId),"^",6)=$g(bankaddress) ;银行
	.s $p(^CT("HCP",HCPRowId),"^",7)=$g(accountno)  ;账号
	.s $p(^CT("HCP",HCPRowId),"^",8)=$g(flag)  ;标记
	.s $p(^CT("HCP",HCPRowId),"^",9)=$g(phone)  ;记账单位电话
	.s $p(^CT("HCP",HCPRowId),"^",10)=$g(address)  ;记账单位地址
	.s $p(^CT("HCP",HCPRowId),"^",11)=$g(contracttype)  ;合同类型
	.s $p(^CT("HCP",HCPRowId),"^",12)=$g(zipcode)  ;邮编
	.s $p(^CT("HCP",HCPRowId),"^",13)=$g(startdate)  ;开始日期
	.s $p(^CT("HCP",HCPRowId),"^",14)=$g(enddate)  ;结束日期
	.s $p(^CT("HCP",HCPRowId),"^",15)=$g(pycode)  ;拼音码
    .s $p(^CT("HCP",HCPRowId),"^",16)=$g(accallname)  ;帐户全称	
    q:RetStr="" "Ok"
	q RetStr
}

// DHCRFRETREASON  不可退药原因

ClassMethod DHCRFRETREASON(ChangeType As %String = "", RowStr As %String = "") As %String
{
	
	Set CurrentNS=$ZNSPACE
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
    if ChangeType="Clear" K ^DHCRFRETREASON
	q:ChangeType="Clear" "数据已清"_"^DHCRFRETREASON"
	s RetStr="",del="^"
	s ^TempArc(0)=ChangeType_"^"_RowStr
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1)
	SET Desc=$P(RowStr,del,2)
	Q:Code="" RetStr="不可退药代码为空!"
	Q:Desc="" RetStr="不可退药描述为空!"
	if ChangeType'="Test" d
	.s Para=Code_"^"_Desc
	.ZN MEDDATA
	.s MRetStr=$$DHCRFRETREASON^DHCFHQIMP(Para)
	.ZN CurrentNS
	.s RetStr=..RetErrorValue(RetStr,MRetStr)
	q:RetStr="" "Ok"
	q RetStr
}

// 区市县省邮编

ClassMethod CityArea(ChangeType As %String = "", RowStr As %String = "") As %String
{
 ;w ##class(web.DHCFHQ.DHCFFHQ).CityArea("","110001^北京市^110000^北京市^110101^东城区")
 s del="^",RetStr=""
 SET RowStr=$tr(RowStr," ",""),sysprovdesc="",sysprovcode="",sysprovrowid=""
 s syscitydesc="",syscitycode="",syscityrowid=""
 s syscityareadesc="",syscityareacode="",syscityarearowid=""
 s cityareacode=$p(RowStr,del,5),cityareadesc=$p(RowStr,del,6)
 s citycode=$p(RowStr,del,3),citydesc=$p(RowStr,del,4)
 s Provincecode=$p(RowStr,del,1),Provincedesc=$p(RowStr,del,2),flag=$p(RowStr,del,7)
 s flag=$g(flag)
 s startdate=$h-2
 q:cityareacode="" ..RetErrorValue(RetStr,"区县代码为空")
 q:citycode="" ..RetErrorValue(RetStr,"市代码为空")
 q:Provincecode="" ..RetErrorValue(RetStr,"省代码为空")
 s ^TempCityImportData(cityareacode)=RowStr
 //省份处理，存在更新名称后取出名称和rowid和code，不存在插入后取出
 i $d(^CT("PROV",0,"Code",$$ALPHAUP^SSUTIL4(Provincecode))) d
 .s sysprovrowid=$o(^CT("PROV",0,"Code",$$ALPHAUP^SSUTIL4(Provincecode),""))
 .q:sysprovrowid=""
 .&SQL(update sqluser.CT_Province set PROV_Desc=:Provincedesc,PROV_DateFrom=:startdate where PROV_Code=:Provincecode and PROV_RowId=:sysprovrowid )
 .s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"CT_Province -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 .q:$g(SQLCODE) 
 .s sysprovcode=Provincecode
 .s sysprovdesc=$p(^CT("PROV",sysprovrowid),"^",2)
 e  d
 .k PLIST
 .s PLIST(2)=Provincecode,PLIST(3)=Provincedesc,PLIST(5)=startdate,PLIST(4)=1
 .&sql(INSERT INTO SQLUser.CT_Province VALUES :PLIST())
 .s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"CT_Province -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 .q:$g(SQLCODE)
 .s sysprovcode=Provincecode
 .s sysprovrowid=$o(^CT("PROV",0,"Code",$$ALPHAUP^SSUTIL4(Provincecode),""))
 
 //地级市处理，存在更新名称后取出名称和rowid和code，不存在插入后取出
 i $d(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(citycode))) d
 .s syscityrowid=$o(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(citycode),""))
 .q:syscityrowid=""
 .&SQL(update sqluser.CT_city set CTCIT_Desc=:citydesc,CTCIT_DateFrom=:startdate,CTCIT_Province_DR=:sysprovrowid where CTCIT_Code=:citycode and CTCIT_RowId=:syscityrowid )
 .s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"CT_Province -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 .q:$g(SQLCODE) 
 .s syscityode=citycode
 .s syscitydesc=$p(^CT("CIT",syscityrowid),"^",2)
 .s CityProvinceDR=$p(^CT("CIT",syscityrowid),"^",4)
 e  d
 .k PLIST
 .s PLIST(2)=citycode,PLIST(3)=citydesc,PLIST(7)=startdate,PLIST(6)=sysprovrowid
 .&sql(INSERT INTO SQLUser.CT_city VALUES :PLIST())
 .s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"CT_city -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 .q:$g(SQLCODE)
 .s syscityrowid=$o(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(citycode),""))
 .q:syscityrowid=""
 .s syscitycode=citycode
 .s syscitydesc=$p(^CT("CIT",syscityrowid),"^",2)
 .s CityProvinceDR=$p(^CT("CIT",syscityrowid),"^",4)
 
 //区县处理，存在更新名称后取出名称和rowid和code，不存在插入后取出
 i $d(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(cityareacode))) d
 .s syscityarearowid=$o(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(cityareacode),""))
 .q:syscityarearowid=""
 .&SQL(update sqluser.CT_CityArea set CITAREA_Desc=:cityareadesc, CITAREA_DateFrom=:startdate,CITAREA_City_DR=:syscityrowid where CITAREA_Code=:cityareacode and CITAREA_RowId=:syscityarearowid )
 .s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"CT_CityArea -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 .q:$g(SQLCODE) 
 .s syscityareacode=cityareacode
 .s syscityareadesc=$p(^CT("CITAREA",syscityarearowid),"^",2)
 .s CITAREACityDR=$p(^CT("CITAREA",syscityarearowid),"^",3)
 e  d
 .k PLIST
 .s PLIST(2)=cityareacode,PLIST(3)=cityareadesc,PLIST(5)=startdate,PLIST(4)=syscityrowid
 .&sql(INSERT INTO SQLUser.CT_CityArea VALUES :PLIST())
 .s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"CT_CityArea -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 .q:$g(SQLCODE)
 .s syscityarearowid=$o(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(cityareacode),""))
 .q:syscityarearowid=""
 .s syscityareacode=cityareacode
 .s syscityareadesc=$p(^CT("CITAREA",syscityarearowid),"^",2)
 .s CITAREACityDR=$p(^CT("CITAREA",syscityarearowid),"^",3)
 //邮编处理，通过二级城市rowid，找出原记录，将原纪录的指针重置
 i $d(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(cityareacode))) d
 .s ziparearowid=$o(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(cityareacode),""))
 .q:ziparearowid=""
 .i $d(^CT("ZIP",0,"City",ziparearowid))  d
 ..s ziprowid=$o(^CT("ZIP",0,"City",ziparearowid,""))
 ..q:ziprowid=""
 ..&SQL(update sqluser.ct_zip set CTZIP_Desc=:syscityareadesc,CTZIP_Province_DR=:sysprovrowid,CTZIP_CITY_DR=:syscityrowid,CTZIP_CityDesc=:syscityareadesc,CTZIP_CITYAREA_DR=:syscityarearowid,CTZIP_CityAreaDesc=:syscityareadesc,CTZIP_DateFrom=:startdate where CTZIP_CITY_DR=:ziparearowid and CTZIP_RowId=:ziprowid )
 ..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ct_zip -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ..q:$g(SQLCODE) 
 ..i flag'=1  d
 ...&SQL(delete from  sqluser.ct_city where CTCIT_Code=:cityareacode and CTCIT_RowId=:ziparearowid )
 ...s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"ct_city -> "_citycode_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
 ...q:$g(SQLCODE) 

 q:RetStr="" "Ok"
 q RetStr
}

// DrugCompare

ClassMethod COMPAREDATA(ChangeType As %String = "", RowStr As %String = "") As %String
{
 
 //s RowStr="6000005^注射用羧苄西林钠(1.0g)^注射用羧苄西林钠^SBXLN^支^39.00 ^46.80 ^支^支^1^1^g^^西成药^针剂丙类^西药费^西药丙类^^^^^西药费^西药费^西药费^西药费^医疗收入^药品收入^^^针剂^针剂^西药^抗微生物类^?-内酰胺类(青霉素类)^静脉输液^1天^粉针剂^医保丙类^长期医嘱^Y^Y^Y^^^^^^^^"
	s del="^",RetStr=""
	s RowStr=$tr(RowStr," ","")
    //特需价格67^外部码68^自费标记69^备注71^贵重标记72^比例73^医保标志74^医保编码75^医保库内名称76^执行部门帐号77^套代码78^检查标记79^自动预约标记80^检查会诊标记81^检查部位82^收费依据83
	s TARISelfFlag=$tr($p(RowStr,del,69)," ")       //自费标记 PLIST(22)
	s TARIExtendCode=$tr($p(RowStr,del,68)," ")     //外部码  PLIST(23)
	s TARIPreciousFlag=$tr($p(RowStr,del,72)," ")   //贵重标记  PLIST(24)
	s TARIInsuFlag=$tr($p(RowStr,del,74)," ")       //医保标记  PLIST(25)
	s TARIInsuDesc=$p(RowStr,del,76)                //医保描述  PLIST(26)
	s TARINote1=$tr($p(RowStr,del,77)," ")          //执行部门  PLIST(27)
	s TARIAlterPrice1=$tr($p(RowStr,del,67)," ")    //特需价格  PLIST(15)
	s XHM=$tr($p(RowStr,del,54)," ")                //协和码
	s zbbj=$tr($p(RowStr,del,55)," ")               //招标标记
	s zbgys=$tr($p(RowStr,del,57)," ")              //招标供应商
	s zbcd=$tr($p(RowStr,del,58)," ")               //招标产地
	s TARIExternalCode=$tr($p(RowStr,del,75)," ")   //医保代码  PLIST(17)
	s TARIExternalCode=""
    s SFYJ=$tr($p(RowStr,del,83)," ")               //收费依据   
    s memo=$tr($p(RowStr,del,71)," ")               //备注
    s Stdate=$tr($p(RowStr,del,70)," ")             //开始日期
    s bl=$tr($p(RowStr,del,73)," ")                 //比例
    s endflag=$tr($p(RowStr,del,64)," ")            //停止标记
 s Code=$p(RowStr,del),Desc=$p(RowStr,del,2),abbr=$p(RowStr,del,3),Alias=$p(RowStr,del,4)
 s guige1=$p(RowStr,del,67)
 ;s ^wwj1123(guige1)=guige1
 ;set guige1=$select(guige1="甲类":1,guige1="乙类":2,guige1="丙类":3,guige1="":3,1:4)
 q:Code="" ..RetErrorValue(RetStr,"代码为空:")
 s inc="",ErrCode="无此代码的药品或材料记录！"
 s incdesc="",baseuom="",packuom="",billuom="",confac=1,yl1="",yl2="",yl3="",jx="",gg="",stop="",txprice=""
 s extcode="",selfflag="",PreciousFlag="",rate="",ybflag=""
 s xlsbaseuom="",xlspackuom="",xlsbilluom="",xlsconfac=1,xlsyl1="",xlsyl2="",xlsyl3="",xlsjx="",xlsgg="",xlsstop="",xlstxprice=""
 s xlsextcode="",xlsselfflag="",xlsPreciousFlag="",xlsrate="",xlsybflag=""
 
 s xlsbaseuom=$p(RowStr,del,9),xlspackuom=$p(RowStr,del,10),xlsbilluom=$p(RowStr,del,5),xlsconfac=$p(RowStr,del,11),xlsyl1=$p(RowStr,del,34),xlsyl2=$p(RowStr,del,35),xlsyl3=$p(RowStr,del,36),xlsjx=$p(RowStr,del,39),xlsgg=$p(RowStr,del,59),xlsstop=$p(RowStr,del,64)
 s xlstxprice=$p(RowStr,del,67)
 s xlsextcode=$p(RowStr,del,68),xlsselfflag=$p(RowStr,del,72),xlsPreciousFlag=$p(RowStr,del,73),xlsrate=$p(RowStr,del,74),xlsybflag=$p(RowStr,del,77)
 i ChangeType'="Compare" q ""
 s xlsstr=""
 s xlsstr=Code_del_Desc_del_xlsbaseuom_del_xlspackuom_del_xlsbilluom_del_xlsconfac_del_xlsyl1_del_xlsyl2_del_xlsyl3_del_xlsjx_del_xlsgg_del_xlsstop_del_xlstxprice
 s xlsstr=xlsstr_del_xlsextcode_del_xlsselfflag_del_xlsPreciousFlag_del_xlsrate_del_xlsybflag
 
 i '$d(^TMPErrData($j)) k ^TMPErrData
 s ErrNum=""
 i $d(^TMPErrData($j,"Drug")) s ErrNum=$o(^TMPErrData($j,"Drug",ErrNum),-1)+1
 e  s ErrNum=1
 
 s jdflag=""
 s inc=$o(^INCI(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
 i inc="" d
   .s ^TMPErrData($j,"Drug",ErrNum)="NoCode"_"&"_xlsstr
 e  d
   .s incdesc=$p(^INCI(inc,1),"^",2)
   .s baseuom=+$p(^INCI(inc,1),"^",10)
   .s baseuomdesc=$p(^CT("UOM",baseuom),"^",2)
   .s packuom=+$p(^INCI(inc,3),"^",6)
   .s packuomdesc=$p(^CT("UOM",packuom),"^",2)
   .s arcitm=""
   .s arcitm=$p(^INCI(inc,1),"^",3)
   .s billuom=+$p(^ARCIM(+arcitm,$p(arcitm,"||",2),8),"^",14)
   .s billuomdesc=$p(^CT("UOM",billuom),"^",2)
   .s conrow=""
   .s conrow=$o(^CT("CTCF",0,"UOM",packuom,baseuom,""))
   .i conrow="" s confac=1
   .e  s confac=$p(^CT("CTCF",conrow),"^",3)
   .s phccatrow="",phccat="",phcsubcatrow="",phcmincatrow="",phcsubcat="",phcmincat=""
   .s phccatrow=$o(^PHCC(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
   .i phccatrow'=""  d
   ..s phccat=$p(^PHCC(phccatrow),"^",2)
   ..s phcsubcatrow=$o(^PHCC(phcatrow,"SC",""))
   ..i phcsubcatrow'="" d
   ...s phcsubcat=$p(PHCC(phcatrow,"SC",phcsubcatrow),"^",2)
   ...s phcmincatrow=$o(^PHCC(phcatrow,"SC",phcsubcatrow,"MIN","")) 
   ...i phcmincatrow'=""  s phcmincat=$p(PHCC(phcatrow,"SC",phcsubcatrow,"MIN",phcmincatrow),"^",2)
   
   .s phcdrgformrow=$p(^ARCIM(+arcitm,$p(arcitm,"||",2),1),"^",12)
   .s phcfrow=$p(^PHCD(+phcdrgformrow,"DF",$p(phcdrgformrow,"||",2),1),"^",1)
   .s jx=$p(^PHCF(phcfrow),"^",2)
   .s gg=##class(web.DHCOutPhDisp).GetPhgg(inc)
   .s arcdateto=""
   .s arcdateto=$p(^ARCIM(+arcitm,$p(arcitm,"||",2),7),"^",1)
   .i arcdateto="" s stop=""
   .e  s stop="1"
   
   .s dhctarrow=""
   .s dhctarrow=$o(^DHCTARI(0,"Desc",incdesc,""))
   .s dhctarpricerow=""
   .i dhctarrow'="" d
   ..s dhctarpricerow=$o(^DHCTARI(dhctarrow,"P",dhctarpricerow),-1)
   ..i dhctarpricerow'="" s txprice=+$p(^DHCTARI(dhctarrow,"P",dhctarpricerow),"^",14)
   ..s txprice=txprice*confac
   ..s extcode=$p(^DHCTARI(dhctarrow),"^",22)
   ..s selfflag=$p(^DHCTARI(dhctarrow),"^",21)
   ..s PreciousFlag=$p(^DHCTARI(dhctarrow),"^",23)
   ..s ybflag=$p(^DHCTARI(dhctarrow),"^",24)
   ..i dhctarpricerow'="" s rate=+$p(^DHCTARI(dhctarrow,"P",dhctarpricerow),"^",16)
   
   .i Desc'=incdesc  d
      ..s Desc="<2>"_Desc,jdflag="1"
   .i xlsbaseuom'=baseuomdesc  d
      ..s xlsbaseuom="<9>"_xlsbaseuom,jdflag="1"
   .i xlspackuom'=packuomdesc  d
      ..s xlspackuom="<10>"_xlspackuom,jdflag="1"
   .i xlsbilluom'=billuomdesc  d
      ..s xlsbilluom="<5>"_xlsbilluom,jdflag="1"
   .i confac'=xlsconfac  d
      ..s xlsconfac="<11>"_xlsconfac,jdflag="1"
   
   .i xlsyl1'=phccat  d
      ..s xlsyl1="<34>"_xlsyl1,jdflag="1"
      
   .i xlsyl2'=phcsubcat  d
      ..s xlsyl2="<35>"_xlsyl2,jdflag="1"
   .i xlsyl3'=phcmincat  d
      ..s xlsyl3="<36>"_xlsyl3,jdflag="1"
      
   .i xlsjx'=jx  d
      ..s xlsjx="<39>"_xlsjx,jdflag="1"
   .i xlsgg'=gg  d
      ..s xlsgg="<59>"_xlsgg,jdflag="1"
   .i xlsstop'=stop  d
      ..s xlsstop="<64>"_xlsstop,jdflag="1"
      
   .i xlstxprice'=txprice  d
      ..s xlstxprice="<67>"_xlstxprice,jdflag="1"
   .i xlsextcode'=extcode  d
      ..s xlsextcode="<68>"_xlsextcode,jdflag="1"
   .i xlsselfflag'=selfflag  d
      ..s xlsselfflag="<72>"_xlsselfflag,jdflag="1"
      
   .i xlsPreciousFlag'=PreciousFlag  d
      ..s xlsPreciousFlag="<73>"_xlsPreciousFlag,jdflag="1"
   .i xlsrate'=rate  d
      ..s xlsrate="<74>"_xlsrate,jdflag="1"
   .i xlsybflag'=ybflag  d
      ..s xlsybflag="<77>"_xlsybflag,jdflag="1"

   .i jdflag="1"  d
     ..s xlsstr="",incstr=""
     ..s xlsstr=Code_del_Desc_del_xlsbaseuom_del_xlspackuom_del_xlsbilluom_del_xlsconfac_del_xlsyl1_del_xlsyl2_del_xlsyl3_del_xlsjx_del_xlsgg_del_xlsstop_del_xlstxprice
     ..s xlsstr=xlsstr_del_xlsextcode_del_xlsselfflag_del_xlsPreciousFlag_del_xlsrate_del_xlsybflag
     ..s incstr=Code_del_incdesc_del_baseuomdesc_del_packuomdesc_del_billuomdesc_del_confac_del_phccat_del_phcsubcat_del_phcmincat_del_jx_del_gg_del_stop_del_txprice
     ..s incstr=incstr_del_extcode_del_selfflag_del_PreciousFlag_del_rate_del_ybflag
     ..s ^TMPErrData($j,"Drug",ErrNum)=xlsstr_"&"_incstr
 
    q jdflag
}

// 诊疗数据校对

/// w ##Class(web.DHCFHQ.DHCFFHQ).ZLCompare("","")  
ClassMethod ZLCompare(ChangeType As %String = "", RowStr As %String = "") As %String
{
 set $zt="ZLCompareET" 
 //set RowStr="D01056^根治术活体组织病理诊断基价二个部(病理科)^GZSHTZZB^D01056^根治术活体组织病理诊断基价二个部(病理科)ttt^GZSHTZZB^500^例^病理检查费^检查病理^病理收入^病理收入^病理费^病理费^化验费^化验费^化验费^化验费^病理收入^病理收入^    化验收入^化验收入^病理^病理^0^^临时医嘱^^1^^S^^^京价(收)字[1999]第390号^例^200^W0301010002^0^2000-7-28^^0^2^①^^^2030000^^^^^^众邦"
  
 set RetStr="",del="^"
 
 set TarItemCode=$piece(RowStr,del,1)         // 收费项代码
 set TarItemDesc=$piece(RowStr,del,2)         // 收费项名称
 set ArcimCode=$piece(RowStr,del,4)           // 医嘱项代码
 set ArcimDesc=$piece(RowStr,del,5)           // 医嘱项名称
 set TarItemPrice=+$piece(RowStr,del,7)       // 收费项价格
 set TarItemUOM=$piece(RowStr,del,8)          // 收费项单位
 set EndDateFlag=$piece(RowStr,del,25)        // 截止日期标记
 set ArcimUOM=$piece(RowStr,del,35)           // 医嘱项单位
 set SpecialPrice=+$piece(RowStr,del,36)      // 特需价格
 set PatientShareFlag=$piece(RowStr,del,38)   // 自费标记
 set PreciousFlag=$piece(RowStr,del,41)       // 贵重标记
 set Proportion3=$piece(RowStr,del,42)        // 比例3
 set InsuFlag=$piece(RowStr,del,43)           // 医保标记
 
 if (TarItemCode="")||(TarItemDesc="")||(ArcimCode="")||(ArcimDesc="") quit RetStr
 kill ^TMPZLITEMCHECK("NEWTARI",$job,ArcimCode,TarItemCode)  //新项目
 kill ^TMPZLITEMCHECK("NOARCIM",$job,ArcimCode,TarItemCode)  //没有医嘱项目的
 kill ^TMPZLITEMCHECK("NOTLINK",$job,ArcimCode,TarItemCode)  //没有LINK的
 kill ^TMPZLITEMCHECK("UPDATE",$job,ArcimCode,TarItemCode)   //需要更新的
 set TarItemID=$order(^DHCTARI(0,"Code",TarItemCode,"0"))
 if (TarItemID="")
 {
	 set ^TMPZLITEMCHECK("NEWTARI",$job,ArcimCode,TarItemCode)=TarItemCode_"^"_TarItemDesc
	 quit "1"
 }
 set myTarItemDesc=$piece(^DHCTARI(TarItemID),"^",2)
 set ArcimID=$order(^ARCIM(0,"Code",ArcimCode,"0"))
 if (ArcimID'="") set ArcimID=ArcimID_"||1"
 if (ArcimID="")
 {
	 set ^TMPZLITEMCHECK("NOARCIM",$job,ArcimCode,TarItemCode)=TarItemCode_"^"_TarItemDesc_"^"_ArcimCode_"<4>"_"^"_ArcimDesc
	 quit "2" 
 }
 
 if ('$data(^DHCOLT(0,"ARTTA",ArcimID,TarItemID)))
 {
	set ^TMPZLITEMCHECK("NOTLINK",$job,ArcimCode,TarItemCode)=TarItemCode_"^"_TarItemDesc_"^"_ArcimCode_"^"_ArcimDesc
	quit "3"	 
	}
 set myArcimDesc=$piece(^ARCIM(+ArcimID,1,1),"^",2)
 //set myTarItemPrice=##Class(web.UDHCJFPRICE).GetItmPrice(TarItemID,+$H,"","","","")
 //set myTarItemPrice=+myTarItemPrice
 set myTarItemUOMID=$piece(^DHCTARI(TarItemID),"^",3)
 set myTarItemUOM=$piece(^CT("UOM",myTarItemUOMID),"^",2)
 set myEndDate=$piece(^DHCTARI(TarItemID),"^",12)
 set myArcimUOMID=$piece(^ARCIM(+ArcimID,1,8),"^",14)
 set myArcimUOM=$piece(^CT("UOM",myArcimUOMID),"^",2)
 set ItmPChild=$order(^DHCTARI(TarItemID,"P",""),-1)
 if (+ItmPChild=0)
 {
 	set mySpecialPrice=0
 	set myProportion3=0
 	set myTarItemPrice=0
 }
 else
 {
	 set mySpecialPrice=+$piece(^DHCTARI(TarItemID,"P",ItmPChild),"^",14)
	 set myProportion3=+$piece(^DHCTARI(TarItemID,"P",ItmPChild),"^",16)
	 set myTarItemPrice=+$piece(^DHCTARI(TarItemID,"P",ItmPChild),"^",5)
 }
 set myPatientShareFlag=$piece(^DHCTARI(TarItemID),"^",21)
 set myPreciousFlag=$piece(^DHCTARI(TarItemID),"^",23)
 
 set myInsuFlag=$piece(^DHCTARI(TarItemID),"^",24)
 set ErrFlag="N"
 set tmpStr=""
 if (TarItemDesc'=myTarItemDesc) 
 {
 	 set tmpStr=TarItemCode_"^"_TarItemDesc_"<2>"
 	 set ErrFlag="Y"
 }
 else
 {
	 set tmpStr=TarItemCode_"^"_TarItemDesc
 }
 if (ArcimDesc'=myArcimDesc)
 {
	 set tmpStr=tmpStr_"^"_ArcimCode_"^"_ArcimDesc_"<5>"
 	 set ErrFlag="Y" 
	 }
 else
 {
	 set tmpStr=tmpStr_"^"_ArcimCode_"^"_ArcimDesc
	 }
 if (TarItemPrice'=myTarItemPrice)
 {
	 set tmpStr=tmpStr_"^"_TarItemPrice_"<7>"
 	 set ErrFlag="Y" 
	 }
 else
 {
	 set tmpStr=tmpStr_"^"_TarItemPrice
	 }
 if (TarItemUOM'=myTarItemUOM)
 {
	 set tmpStr=tmpStr_"^"_TarItemUOM_"<8>"
 	 set ErrFlag="Y" 
	 }
 else
 {
	 set tmpStr=tmpStr_"^"_TarItemUOM
	 }
 
 if ((EndDateFlag="0")&&(myEndDate'=""))||((EndDateFlag="1")&&(myEndDate=""))
 {
	 set tmpStr=tmpStr_"^"_EndDateFlag_"<25>"
 	 set ErrFlag="Y" 
	 }
 else
 {
	set tmpStr=tmpStr_"^"_EndDateFlag	
	}
 if (ArcimUOM'=myArcimUOM)
 {
	 set tmpStr=tmpStr_"^"_ArcimUOM_"<35>"
 	 set ErrFlag="Y" 
	 }
 else
 {
	 set tmpStr=tmpStr_"^"_ArcimUOM
	 }	
 if (SpecialPrice'=mySpecialPrice)
 {
	 set tmpStr=tmpStr_"^"_SpecialPrice_"<36>"
 	 set ErrFlag="Y" 
	 }
 else
 {
	 set tmpStr=tmpStr_"^"_SpecialPrice
	 }	
 if (PatientShareFlag'=myPatientShareFlag)
 {
	 set tmpStr=tmpStr_"^"_PatientShareFlag_"<38>"
 	 set ErrFlag="Y" 
	 }
 else
 {
	 set tmpStr=tmpStr_"^"_PatientShareFlag
	 }	
 if (PreciousFlag'=myPreciousFlag)
 {
	 set tmpStr=tmpStr_"^"_PreciousFlag_"<41>"
 	 set ErrFlag="Y" 
	 }
 else
 {
	 set tmpStr=tmpStr_"^"_PreciousFlag
	 }	
 if (Proportion3'=myProportion3)
 {
	 set tmpStr=tmpStr_"^"_Proportion3_"<42>"
 	 set ErrFlag="Y" 
	 }
 else
 {
	 set tmpStr=tmpStr_"^"_Proportion3
	 }	
 if (InsuFlag'=myInsuFlag)
 {
	 set tmpStr=tmpStr_"^"_InsuFlag_"<43>"
 	 set ErrFlag="Y" 
	 }
 else
 {
	 set tmpStr=tmpStr_"^"_InsuFlag
	 }	 
 	 
 if (ErrFlag'="Y") quit "0"
 set mytmpStr=TarItemCode_"^"_myTarItemDesc_"^"_ArcimCode_"^"_myArcimDesc_"^"_myTarItemPrice_"^"_myTarItemUOM_"^"_myEndDate
 set mytmpStr=mytmpStr_"^"_myArcimUOM_"^"_mySpecialPrice_"^"_myPatientShareFlag_"^"_myPreciousFlag_"^"_myProportion3_"^"_InsuFlag
 
 set ^TMPZLITEMCHECK("UPDATE",$job,ArcimCode,TarItemCode)=tmpStr_"&"_mytmpStr
 quit "4"
 
 
ZLCompareET
	quit "-1^"_$ZERROR
}

/// 民族
ClassMethod CtNation(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" K ^CT("NAT")
	q:ChangeType="Clear" "数据已清"_"^CT("_"NAT"_")"
	s RetStr="",del="^"
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1)
	SET Desc=$P(RowStr,del,2)
	Q:Code="" RetStr="民族代码为空"
	Q:Desc="" RetStr="民族描述为空"
	if '$d(^CT("NAT",0,"Code",$$ALPHAUP^SSUTIL4(Code))) d
	.if ChangeType'="Test" d
	..K PLIST
	..SET PLIST(2)=Code,PLIST(3)=Desc
 	..&SQL(INSERT INTO SQLUSER.CT_Nation VALUES :PLIST())
	..s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"CT_Nation -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	q:RetStr="" "Ok"
	q RetStr
}

/// 邮编
ClassMethod CtZip(ChangeType As %String = "", RowStr As %String = "") As %String
{
	IF ChangeType="Clear" K ^CT("ZIP")
	q:ChangeType="Clear" "数据已清:邮编"
	s del="^"
	s RetStr=""
	s RetStr="",del="^"
	q:((ChangeType="")) "更新类型为空"
	s RowStr=$tr(RowStr," ","")
	s ZipCode=$p(RowStr,del,1),ZipDesc=$p(RowStr,del,2),CityCode=$p(RowStr,del,4)
	q:ZipCode="" ""
	q:ZipDesc="" ""
	q:(+ZipCode<1) ""
	
	if $g(CTRegion)="" s CTRegion="中国"
	s CTRegionId=$o(^CT("RG",0,"Desc",$$ALPHAUP^SSUTIL4(CTRegion),""))
	if $g(CityCode)'="" d
	.if $d(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(CityCode))) d
	..s CityAreaId=$o(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(CityCode),"")) d
	..s CityId=""
	..if $g(CityAreaId)'="" d
	...s CityId=$p(^CT("CITAREA",CityAreaId),del,3)
	.if $g(CityAreaId)="" d
	..s:$d(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(CityCode))) CityId=$o(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(CityCode),""))
	if (($g(CityAreaId)'="")!($g(CityId)'="")) d
	.s:$g(CityId)'="" CityDesc=$p(^CT("CIT",CityId),del,2)
	.s:$g(CityId)'="" ProId=$p(^CT("CIT",CityId),del,4)
	
	
	if ($g(ZipCode)'="")&($g(ZipDesc)'="") d
	.if '$d(^CT("ZIP",0,"Code",$$ALPHAUP^SSUTIL4(ZipCode))) d
	..;s RetStr="a"
	..if ChangeType'="Test" d
	...
	...S ProvObj=##class(User.CTZip).%New()
	...s ProvObj.CTZIPCode=ZipCode
	...s ProvObj.CTZIPDesc=ZipDesc
	...d ProvObj.CTZIPRegionDRSetObjectId($g(CTRegionId))
	...d ProvObj.CTZIPProvinceDRSetObjectId($g(ProId))
	...d ProvObj.CTZIPCITYDRSetObjectId($g(CityId))
	...d ProvObj.CTZIPCITYAREADRSetObjectId($g(CityAreaId))
	...s ProvObj.CTZIPCityDesc=$g(CityDesc)
	...s ProvObj.CTZIPDateFrom=+$h
	...d ProvObj.%Save()
	q RetStr
}

/// 辩证
ClassMethod MRCDiagnosSignSymptom(ChangeType As %String = "", RowStr As %String = "") As %String
{
	if ChangeType="Clear" K ^MRC("DSYM")
	q:ChangeType="Clear" "数据已清"
	s RetStr="",del="^",DSYMRowId=""
	SET RowStr=$tr(RowStr," ","")
	SET Code=$P(RowStr,del,1)
	SET Desc=$P(RowStr,del,2)
	SET aliasU=$P(RowStr,del,3)
	Q:Code="" RetStr="辩证代码为空"
	Q:Desc="" RetStr="辩证描述为空"
	;if '$d(^MRC("DSYM",0,"Code",$$ALPHAUP^SSUTIL4(Code))) d
	if ChangeType'="Test" d
	.K PLIST
	.SET PLIST(2)=Code,PLIST(3)=Desc,PLIST(8)="Y"
 	.&SQL(INSERT INTO SQLUSER.MRC_DiagnosSignSymptom VALUES :PLIST())
	.;s:$g(SQLCODE) RetStr=..RetErrorValue(RetStr,"MRC_DiagnosSignSymptom -> "_$tr($p($g(%mdiag),$c(1),2,3),$c(1)," ")_"("_$g(SQLCODE)_"): "_$p($g(%mdiag(1)),$c(1),5)_","_$g(%msg))
	.;q:$g(SQLCODE)
	.s DSYMRowId=$o(^MRC("DSYM",0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	.i DSYMRowId'=""  d
 	..&SQL(insert into SQLUser.DHC_MRCDiagnosSignSymptomAlias (DSYMA_ParRef,DSYMA_Alias) Values (:DSYMRowId,:aliasU))
	q:RetStr="" "Ok"
	q RetStr
}

}
