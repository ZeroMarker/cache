Import sqluser

/// creator: 	yunhaibao
/// createdate: 2018-07-03
/// description:系统计算排班
Class web.DHCSTPIVAS.AutoScheArrange Extends %RegisteredObject
{

/// w ##class(web.DHCSTPIVAS.AutoScheArrange).AutoScheArrange("2019-6-01^248^711")
ClassMethod AutoScheArrange(InputStr)
{
	s MonthDate=$p(InputStr,"^",1)
	s LocId=$p(InputStr,"^",2)
	s UserId=$p(InputStr,"^",3)
	s CurYear=+$p(InputStr,"-",1)
	s CurMonth=+$p(InputStr,"-",2)
	i CurMonth=12 s EndMonth=1,EndYear=CurYear+1
	e  s EndMonth=CurMonth+1,EndYear=CurYear
	s EndMonth=EndYear_"-"_EndMonth_"-"_"01"
	s StartDate=$zdh(CurYear_"-"_CurMonth_"-"_"1",3)
	s EndDate=$zdh(EndMonth,3)-1
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s pid=..NewPid()
	d ..UserLeave(pid,LocId,StartDate,EndDate)   ;构建请假的global
	d ..UserSchDate(pid,LocId,EndDate)           ;构建普通员工休息班
	d ..ObligatorySche(pid,LocId,StartDate,EndDate) ;构建必修岗global（领导班）
	d ..UserFixSche(pid,LocId,StartDate,EndDate) ;构建固定班次global
	d ..OrdSche(pid,LocId,StartDate,EndDate)     ;生成最终排班global
	;d ..UserSche(pid,LocId,StartDate,EndDate)
	;d ..CalcuSche(pid,LocId,StartDate,EndDate)
	s saveRet=..Save(pid,LocId,UserId,MonthDate)
	q saveRet
}

/// CreateOr:Suiguoyang
/// CreateDate:20190117
/// description:生成最终的排班global
/// d ##class(web.DHCSTPIVAS.AutoScheArrange).OrdSche(123,403,"","")
ClassMethod OrdSche(pid, LocId, StartDate, EndDate)
{
	s pSId=""
	f  s pSId=$o(^Code.PIVA.Schedul(pSId)) q:(pSId="")  d                 ;班次维护表
	.s loc=$p(^Code.PIVA.Schedul(pSId),"^",1)   
	.q:LocId'=loc
	.s code=$p(^Code.PIVA.Schedul(pSId),"^",2)   
	.s schedOrd(code)=pSId                                                ;按照Code进行排序
	s codeText="",stratUser=""
	f  s codeText=$o(schedOrd(codeText)) q:(codeText="")  d
	.s PSId=schedOrd(codeText)
	.s UserSched=""
	.d ..UserStr(PSId,.UserSched)                                      ;构建能上该班的人员字符串
	.q:UserSched=""
	.s UserSched=##class(web.DHCSTPIVAS.Common).AscOrder(UserSched,",")   ;字符串升序排列
	.s userList=$lfs(UserSched,",")                                       ;字符串转换为数据集
	.f date=StartDate:1:EndDate d
	..i '$d(^TMPPIVAS($ClassName(),"最终班次",pid,date,PSId))&&('$d(^TMPPIVAS($ClassName(),"取消班次",pid,PSId,date)) )  d          ;检测今天这个班是否被占用或者取消的
	...s userListLen=$ll(userList)                                        ;数据集个数
	...s userFlag="",freeUser=""
	...f len=1:1:userListLen q:(userFlag="Y")  d
	....i $d(^TMPPIVAS($ClassName(),"请假",pid,date,$list(userList,1))) d ..NewList(.userList) q
	....i ('$d(^TMPPIVAS($ClassName(),"最终班次US",pid,date,$list(userList,1))))&&('$d(^TMPPIVAS($ClassName(),"请假",pid,date,$list(userList,1))))  d  ;人是否今天有班或者请假
	.....s userFlag="Y"                                                   ;该人既没排班又没请假置人员可用标志跳出循环
	....e  d
	.....d ..NewList(.userList)                                           ;该人不可用遍历下一个人
	.....i len=userListLen d											  ;当无人可用时置自由人标志
	......s freeUser="Y"
	...i (freeUser="Y")||(userFlag="") d                                                   
	....s userFree=..FreeUser(pid,date,.stratUser,LocId)						  ;获取自由人
	....i userFree'="" d
	.....s ^TMPPIVAS($ClassName(),"最终班次",pid,date,PSId,userFree)=PSId              ;构建最终排班global
	.....s ^TMPPIVAS($ClassName(),"最终班次US",pid,date,userFree,PSId)=PSId			   ;构建最终辅助排班global
	...e  d
	....i $d(^TMPPIVAS($ClassName(),"请假",pid,date,$list(userList,1))) d ..NewList(.userList) q
	....s ^TMPPIVAS($ClassName(),"最终班次",pid,date,PSId,$list(userList,1))=PSId      ;构建最终排班global
	....s ^TMPPIVAS($ClassName(),"最终班次US",pid,date,$list(userList,1),PSId)=PSId    ;构建最终辅助排班global
	....d ..NewList(.userList)                                                         ;构建成功后遍历下一个人，以便下一个日期使用
	
	q pid
}

/// Createor:Suiguoyang
/// CreateDate20190117
/// Description:构建某班次人员字符串
/// w ##class(web.DHCSTPIVAS.AutoScheArrange).UserStr(17,"")
ClassMethod UserStr(PSId, UserSched)
{
	s pusId=""      ;人员班次对照表
	f  s pusId=$o(^Config.PIVA.UserSchedul(0,"Schedul",PSId,pusId)) q:(pusId="")  d
	.s userId=$p(^Config.PIVA.UserSchedul(pusId),"^",1)
	.s type=$p(^Config.PIVA.UserSchedul(pusId),"^",3)  
	.q:(type'="N")  ;固定班次人的不算
	.i UserSched="" d
	..s UserSched=userId
	.e  d
	..s UserSched=UserSched_","_userId
}

/// Createor:suiguoyang
/// CreateDate:20190117
/// Description:数据集转换(将数据集第一个位置放在最后，剩下依次前移)
ClassMethod NewList(List)
{
	s ListLen=$ll(List)  ;数据集个数
	s tmp=$list(List,1)
	f len=1:1:ListLen d 
	.i len=ListLen d
	..s $list(List,len)=tmp
	.e  d
	..s $list(List,len)=$list(List,(len+1))
	q List
}

/// description:获取能上某岗的人员
/// w ##class(web.DHCSTPIVAS.AutoScheArrange).GetDutyUser(7,248)
ClassMethod GetDutyUser(piece, loc)
{
	s PDId="",UserStr=""
	f  s PDId=$o(^Code.PIVA.Duty(PDId)) q:PDId=""  d
	.s Loc=$p(^Code.PIVA.Duty(PDId),"^",1)  ;岗位表
	.q:Loc'=loc
	.s Flag=$p(^Code.PIVA.Duty(PDId),"^",piece)  ;岗位表
	.q:Flag'="Y"  ;过滤没有改标志的
	.s PDUId=""
	.f  s PDUId=$o(^Config.PIVA.DutyUser(0,"Duty",PDId,PDUId)) q:(PDUId="")  d
	..s user=$p(^Config.PIVA.DutyUser(PDUId),"^",2)   ;岗位人员关联表
	..i UserStr="" s UserStr=user
	..e  d
	...s UserList=$lfs(UserStr,",")
	...i $lf(UserList,user)=0  s UserStr=UserStr_","_user
	s UserStr=##class(web.DHCSTPIVAS.Common).AscOrder(UserStr,",")
	q UserStr
}

/// Createor:suiguoyang
/// CreateDate:20190117
/// Description:判断应该给哪个自由人排班
/// d ##class(web.DHCSTPIVAS.AutoScheArrange).FreeUser()
ClassMethod FreeUser(pid, date, stratUser, LocId)
{
	s userStr=..GetDutyUser(11,LocId)   ;获取自由人字符串
	q:userStr="" ""
	s userList=$lfs(userStr,",")	;生成自由人数据集
	s userLen=$ll(userList)
	s ret=""
	s flag="0"
	s len=0
	f len=1:1:userLen q:flag="1"  d  
	.i ($list(userList,len)>+stratUser) d  ;通过传入的上一个自由人找到下一个自由人
	..i ('$d(^TMPPIVAS($ClassName(),"请假",pid,date,$list(userList,len))))&&('$d(^TMPPIVAS($ClassName(),"最终班次US",pid,date,$list(userList,len)))) d   ;判断自由人是否有班或者请假
	...s flag="1"                          ;自由人可用标志
	...s ret=$list(userList,len)           ;返回可用自由人
	...s stratUser=$list(userList,len)     ;置本次使用自由人，方便下次使用
	i $list(userList,-1)=stratUser d
	.s stratUser=""                        ;当自由人是最后一个的时候，恢复初始状态空
	q ret
}

/// Createor:Suiguoyang
/// CreateDate:20190117
/// Description:必修班：周末休息，节假日休息，其它时间上白班(只取第一个班)
///             休息算请假，工作时间都是一个班
/// w ##class(web.DHCSTPIVAS.AutoScheArrange).ObligatorySche("1","248","65104","65133")
ClassMethod ObligatorySche(pid, LocId, StartDate, EndDate)
{
	s HoliStr=..Holiday()
	s HoliList=$lfs(HoliStr,",")
	s calcuDate=""
	f calcuDate=StartDate:1:EndDate d
	.s weekDay=$zd(calcuDate,10)		   ;双休日
	.i $lf($lfs("0,6",","),weekDay)'=0 d
	..s reskList(calcuDate)=calcuDate
	.e  i $lf(HoliList,calcuDate)'=0  d      ;节假日
	..s reskList(calcuDate)=calcuDate      
	.e  d
	..s wookList(calcuDate)=calcuDate      ;工作日
	s weekUserStr=..GetDutyUser(7,LocId)   ;双休人员(目前系统双休与必修一对一)
	s weekList=$lfs(weekUserStr,",")
	s weekLen=$ll(weekList)
	f wLen=1:1:weekLen d
	.s PUSId=""
	.f  s PUSId=$o(^Config.PIVA.UserSchedul(0,"User",$list(weekList,wLen),PUSId)) q:PUSId=""  d
	..q:(PUSId="")
	..s SchId=$p(^Config.PIVA.UserSchedul(PUSId),"^",2)
	..q:'$d(^Code.PIVA.Schedul(+SchId))
	..s reskDate=""
	..f  s reskDate=$o(reskList(reskDate)) q:reskDate=""  d
	...s ^TMPPIVAS($ClassName(),"请假",pid,reskDate,$list(weekList,wLen))=""
	..s wookDate=""
	..f  s wookDate=$o(wookList(wookDate)) q:wookDate=""  d
	...q:$d(^TMPPIVAS($ClassName(),"请假",pid,wookDate,$list(weekList,wLen)))
	...s ^TMPPIVAS($ClassName(),"最终班次",pid,wookDate,SchId,$list(weekList,wLen))=SchId
	...s ^TMPPIVAS($ClassName(),"最终班次US",pid,wookDate,$list(weekList,wLen),SchId)=SchId

	q pid
}

/// Createor:Suiguoyang
/// CreateDate:20190119
/// Description:计算休班日期
/// w ##class(web.DHCSTPIVAS.AutoScheArrange).UserSchDate("12312321","219","64951")
ClassMethod UserSchDate(pid, LocId, EndDate)
{
	s UserId=""
	f  s UserId=$o(^DHCST.PIVA.User(0,"LOC",LocId,UserId)) q:(UserId="")  d
	.s pusRowId=""
	.f  s pusRowId=$o(^DHCST.PIVA.User(0,"LOC",LocId,UserId,pusRowId)) q:(pusRowId="")  d
	..s userStDate=$p(^DHCST.PIVA.User(pusRowId),"^",3)
	..q:(userStDate="")
    ..s Days=$p(^DHCST.PIVA.User(pusRowId),"^",4)
    ..f Remadate=userStDate:1:EndDate d
    ...s dateFlag=""
    ...s dateFlag=..UserRemaDay(userStDate,Remadate,Days)
    ...i dateFlag=0 d
    ....s ^TMPPIVAS($ClassName(),"请假",pid,Remadate,UserId)=""
}

/// Createor:Suiguoyang
/// CreateDate:20190119
/// Description:计算余数
/// w ##class(web.DHCSTPIVAS.AutoScheArrange).UserRemaDay("5","4","2")
ClassMethod UserRemaDay(StDate, EndDate, Days)
{
	q:StDate="" ""
	q:EndDate="" ""
	q:Days="" ""
	s remaDay=""
	s poorDay=EndDate-StDate
	q:poorDay<0 ""
	s remaDay=poorDay#Days   ;计算余数
	q remaDay
}

/// Createor:suiguoyang
/// CreateDate:20190117
/// Description:获取本年休假数据集
/// d ##class(web.DHCSTPIVAS.AutoScheArrange).Holiday()
ClassMethod Holiday()
{
	s Now=$zd(+$h,3)
	s NowYear=$p(Now,"-",1)
	s DateStr=""
	s PHId=""
	f  s PHId=$o(^Code.PIVA.Holiday(PHId)) q:(PHId="")  d
	.s year=$p(^Code.PIVA.Holiday(PHId),"^",2)
	.q:NowYear'=year
	.s Strat=$p(^Code.PIVA.Holiday(PHId),"^",3)
	.s End=$p(^Code.PIVA.Holiday(PHId),"^",4)
	.f date=Strat:1:End  d
	..i DateStr="" s DateStr=date
	..e  s DateStr=DateStr_","_date
	q DateStr
}

/// description: 基础数据准备完毕,开始排班
ClassMethod CalcuSche(Pid, LocId, StartDate, EndDate)
{
	/*
	s calcuDate=""
	f calcuDate=StartDate:1:EndDate d
	.s priIndex=""
	.f  s priIndex=$o(^TMPPIVAS($ClassName(),"日期班次人员",Pid,calcuDate,priIndex)) q:priIndex=""  d
	..s scheId=""
	..f  s scheId=$o(^TMPPIVAS($ClassName(),"日期班次人员",Pid,calcuDate,priIndex,scheId)) q:scheId=""  d
	...s userId=..CalcuUser(Pid,scheId, calcuDate)
	...q:userId=""
	...s ^TMPPIVAS($ClassName(),"最终班次",Pid,calcuDate,scheId,userId)=scheId
	...s ^TMPPIVAS($ClassName(),"最终班次US",Pid,calcuDate,userId,scheId)=scheId
	q ""
	*/
	s scheCnt=0
	s priIndex=""
	f  s priIndex=$o(^TMPPIVAS($ClassName(),"班次日期人员",Pid,priIndex)) q:priIndex=""  d
	.s scheId=""
	.f  s scheId=$o(^TMPPIVAS($ClassName(),"班次日期人员",Pid,priIndex,scheId)) q:scheId=""  d
	..s scheCnt=0,totalCnt=1
	..s calcuDate=""
	..f calcuDate=StartDate:1:EndDate d
	...s userId=..CalcuUser(Pid,scheId, calcuDate,.scheCnt,.totalCnt)
	...q:userId=""
	...s ^TMPPIVAS($ClassName(),"最终班次",Pid,calcuDate,scheId,userId)=scheId
	...s ^TMPPIVAS($ClassName(),"最终班次US",Pid,calcuDate,userId,scheId)=scheId
	...s ^TMPPIVAS($ClassName(),"班次循环计数",Pid,scheId,userId)=1+$g(^TMPPIVAS($ClassName(),"班次循环计数",Pid,scheId,userId))
	q ""
}

/// description: 计算某日期某班次应该为谁
ClassMethod CalcuUser(Pid, ScheId, ScheDate, scheCnt, totalCnt)
{
	s scheCnt=scheCnt+1
	k CalcuUserData

	s retUser=""
	s userId="",tmpCnt=0
	f  s userId=$o(^TMPPIVAS($ClassName(),"日期班次人员字典",Pid,ScheDate,ScheId,userId)) q:(userId="")  d
	.// q:..CheckUserCanSche(ScheDate,userId)="N"	 // 请假什么的不排班的
	.s tmpCnt=tmpCnt+1
	.q:(tmpCnt<(scheCnt#totalCnt))
	.q:$d(^TMPPIVAS($ClassName(),"请假",Pid,ScheDate,userId))
	.q:$d(^TMPPIVAS($ClassName(),"最终班次",Pid,ScheDate,ScheId,userId)) // 该日期已排班此班
	.q:$d(^TMPPIVAS($ClassName(),"最终班次US",Pid,ScheDate,userId))	 // 该日期已排班

	.s userScheCnt=+$g(^TMPPIVAS($ClassName(),"班次循环计数",Pid,ScheId,userId))
	.s CalcuUserData(userScheCnt,userId)=""
	s totalCnt=tmpCnt
	q:'$d(CalcuUserData) ""
	s userScheCnt=$o(CalcuUserData(""))
	q:userScheCnt="" ""
	s retUser=$o(CalcuUserData(userScheCnt,""))
	
	q retUser
}

/// description: 已关联到人的班次
ClassMethod UserSche(Pid, LocId, StartDate, EndDate)
{
	s userScheId=""
	f  s userScheId=$o(^Config.PIVA.UserSchedul(userScheId)) q:userScheId=""  d
	.q:+userScheId=0
	.s userScheData=^Config.PIVA.UserSchedul(userScheId)
	.s userId=$p(userScheData,"^",1)
	.s scheId=$p(userScheData,"^",2)
	.q:'$d(^Code.PIVA.Schedul(scheId))
	.s daysType=$p(userScheData,"^",3)
	.q:daysType'="N"
	.s days=$p(userScheData,"^",4)
	.s scheLocId=$p(^Code.PIVA.Schedul(scheId),"^",1)
	.s scheCode=$p(^Code.PIVA.Schedul(scheId),"^",2)
	.s priIndex=scheCode
	.q:LocId'=scheLocId
	.s calcuDate=""
	.f calcuDate=StartDate:1:EndDate d
	..q:..CheckCanSche(calcuDate,scheId)="N"	// 该班次该日不需要排
	..s ^TMPPIVAS($ClassName(),"日期班次人员",Pid,calcuDate,priIndex,scheId,userId)=""
	..s ^TMPPIVAS($ClassName(),"日期班次人员字典",Pid,calcuDate,scheId,userId)=""
	..s ^TMPPIVAS($ClassName(),"班次日期人员",Pid,priIndex,scheId,calcuDate,userId)=""
	q ""
}

/// description: 固定班次
/// w ##class(web.DHCSTPIVAS.AutoScheArrange).UserFixSche("YHB","403","65014","65044")
ClassMethod UserFixSche(Pid, LocId, StartDate, EndDate)
{
	s userScheId=""
	f  s userScheId=$o(^Config.PIVA.UserSchedul(userScheId)) q:userScheId=""  d
	.q:+userScheId=0
	.s userScheData=^Config.PIVA.UserSchedul(userScheId)
	.s userId=$p(userScheData,"^",1)
	.s scheId=$p(userScheData,"^",2)
	.q:'$d(^Code.PIVA.Schedul(scheId))
	.s daysType=$p(userScheData,"^",3)
	.q:daysType="N"
	.s days=$p(userScheData,"^",4)
	.s scheLocId=$p(^Code.PIVA.Schedul(scheId),"^",1)
	.q:LocId'=scheLocId
	.i daysType="D" d
	..s daysLen=$l(days,",")
	..f dayI=1:1:daysLen d
	...s day=$p(days,",",dayI)
	...q:day=""
    ...q:(day<StartDate)||(day>EndDate)
	...q:$d(^TMPPIVAS($ClassName(),"请假",Pid,day,userId))
	...s ^TMPPIVAS($ClassName(),"最终班次",Pid,day,scheId,userId)=scheId	
	...s ^TMPPIVAS($ClassName(),"最终班次US",Pid,day,userId,scheId)=scheId		
	...s ^TMPPIVAS($ClassName(),"班次循环计数",Pid,scheId,userId)=1
	...d ..LinkSche(Pid,scheId,day,userId)
	.e  d
	..s calcuDate=""
	..f calcuDate=StartDate:1:EndDate d
	...s quitFlag=""
	...i daysType="W" d
	....s weekDay=$zd(calcuDate,10)					// 周几,每周第几天
	....i weekDay=0 s weekDay=7
	....i $lf($lfs(days,","),weekDay)=0 s quitFlag=1
	...e  i daysType="M" d	
	....s monthDay=+$zd(calcuDate,4)					// 每月第几天
	....i $lf($lfs(days,","),monthDay)=0 s quitFlag=1
	...e  i daysType="ME" d
	....s nextMonth1=##class(web.DHCSTPIVAS.AutoScheArrange).NextMonLogical1(calcuDate)
	....s monthEndDay=nextMonth1-calcuDate			// 每月倒数第几天
	....i $lf($lfs(days,","),monthEndDay)=0 s quitFlag=1
	...q:quitFlag'=""
	...q:$d(^TMPPIVAS($ClassName(),"请假",Pid,calcuDate,userId))
	...s ^TMPPIVAS($ClassName(),"最终班次",Pid,calcuDate,scheId,userId)=scheId
	...s ^TMPPIVAS($ClassName(),"最终班次US",Pid,calcuDate,userId,scheId)=scheId	
	...s ^TMPPIVAS($ClassName(),"班次循环计数",Pid,scheId,userId)=1	
	...d ..LinkSche(Pid,scheId,calcuDate,userId)
	q ""
}

ClassMethod LinkSche(Pid, scheId, day, userId)
{
	
	s linkSche=$p(^Code.PIVA.Schedul(scheId),"^",12)
	i linkSche'="" d
	.s linkList=$lfs(linkSche,",")
	.f len=1:1:$ll(linkList) d
	..s ^TMPPIVAS($ClassName(),"取消班次",Pid,$List(linkList,len),day)=$List(linkList,len)
}

/// description: 请假数据
/// w ##class(web.DHCSTPIVAS.AutoScheArrange).UserLeave("D20190505P53","248",65134,65164)
ClassMethod UserLeave(Pid, LocId, StartDate, EndDate)
{
	//q:$d(^TMPPIVAS($ClassName(),"请假",Pid,day,userId))
	s userId=""
	f  s userId=$o(^Busi.PIVA.Leave(0,"LocUseStDate",LocId,userId)) q:userId=""  d
	.q:+userId=0
	.s calcuDate=""
	.f calcuDate=StartDate:1:EndDate d
	..s leaveId=""
	..f  s leaveId=$o(^Busi.PIVA.Leave(0,"LocUseStDate",LocId,userId,calcuDate,leaveId)) q:leaveId=""  d
	...q:+leaveId=0
	...// 审批通过的请假
	...s leaveData=^Busi.PIVA.Leave(leaveId)
	...s plStatus=$p(leaveData,"^",15)
	...q:plStatus<1
	...s plEdDate=$p(leaveData,"^",6)
	...s leaveDate=""
	...f leaveDate=calcuDate:1:plEdDate d
	....s ^TMPPIVAS($ClassName(),"请假",Pid,leaveDate,userId)=""
	q ""
}

/// description: 判断某班次是否于某日期可排
/// return:		 N(不可在此日排班)
/// w ##class(web.DHCSTPIVAS.AutoScheArrange).CheckCanSche(65014,27)
ClassMethod CheckCanSche(ScheDate, ScheId)
{
	q:'$d(^Code.PIVA.Schedul(ScheId)) "N"
	s scheDaysData=$p(^Code.PIVA.Schedul(ScheId),"^",10)
	q:scheDaysData="" ""
	s retFlag="N"
	s exist=""
	s len=$l(scheDaysData,"!!")
	s i=""
	f i=1:1:len q:retFlag="Y"  d
	.s scheDays=$p(scheDaysData,"!!",i)
	.q:scheDays=""
	.s daysType=$p(scheDays,":",1)
	.s days=$p(scheDays,":",2)
	.q:(daysType="")||(days="")
	.i daysType="W" d
	..s weekDay=$zd(ScheDate,10)					// 周几,每周第几天
	..i weekDay=0 s weekDay=7
	..i $lf($lfs(days,","),weekDay)>0 s retFlag="Y"
	.e  i daysType="M" d	
	..s monthDay=+$zd(ScheDate,4)					// 每月第几天
	..i $lf($lfs(days,","),monthDay)>0 s retFlag="Y"
	.e  i daysType="ME" d
	..s nextMonth1=##class(web.DHCSTPIVAS.AutoScheArrange).NextMonLogical1(ScheDate)
	..s monthEndDay=nextMonth1-calcuDate			// 每月倒数第几天
	..i $lf($lfs(days,","),monthEndDay)>0 s retFlag="Y"
	.s exist=1
	q:exist="" "Y"
	q retFlag
}

/// description: 判断某人今日是否可进入排班(请假\节假日等一些不应该排班的)
/// return:		 N(不进入排班)
ClassMethod CheckUserCanSche(UserId, ScheDate)
{
 	// 周六日
 	// 请假数据
	..f plStDate=StartDate:1:EndDate d
	...s plId=""
	...f  s plId=$o(^Busi.PIVA.Leave(0,"LocUseStDate",LocId,pduUserId,plStDate,plId)) q:plId=""  d
	....q:+plId=0
	....// 审批通过的请假
	....s plDate=^Busi.PIVA.Leave(plId)
	....s plStatus=$p(plDate,"^",15)
	....q:plStatus<1
	....s plEdDate=$p(plDate,"^",6)
	....s leaveDate=""
	....f leaveDate=plStDate:1:plEdDate d
	.....k ^TMPPIVAS("AutoScheArrange","初始日期班次人员",pid,leaveDate,pduUserId)
}

ClassMethod Save(Pid, LocId, UserId, MonthDate)
{
	s monthDate=$zdh(MonthDate,3)
	s curDate=+$h
	s curTime=$p($h,",",2)
	s errCode=""
	&SQL(
		SELECT PSA_RowId INTO :psaId FROM PIVA_ScheArrange
		WHERE PSA_Month=:monthDate and PSA_Loc_Dr=:LocId
	)
	i SQLCODE=0 d
	.&SQL(DELETE FROM PIVA_ScheArrange WHERE PSA_RowId=:psaId)	
	ts
	&SQL(
		INSERT INTO PIVA_ScheArrange
		(PSA_Loc_Dr,PSA_Month,PSA_Date,PSA_Time,PSA_User_Dr)
		VALUES
		(:LocId,:monthDate,:curDate,:curTime,:UserId)
	)
	i SQLCODE'=0 s errCode="-1^插入排班主表失败,"_$g(%msg) q errCode
	s psaId=$p(%ROWID,$c(1))
	s calcuDate=""
	f  s calcuDate=$o(^TMPPIVAS($ClassName(),"最终班次",Pid,calcuDate)) q:(calcuDate="")||(errCode'="")  d
	.s scheId=""
	.f  s scheId=$o(^TMPPIVAS($ClassName(),"最终班次",Pid,calcuDate,scheId)) q:(scheId="")||(errCode'="")  d
	..s userId=""
	..f  s userId=$o(^TMPPIVAS($ClassName(),"最终班次",Pid,calcuDate,scheId,userId)) q:(userId="")||(errCode'="")  d
	...s maxChild=$o(^Busi.PIVA.ScheArrange(psaId,"I",""),-1)+1
	...//s pduId=$o(^Config.PIVA.DutyUser(0,"User",pduUserId,""))
	...//q:pduId=""
	...//s pdId=$p(^Config.PIVA.DutyUser(pduId),"^",1)
	...//q:pdId=""
	...s dutyId=""
	...&SQL(
		INSERT INTO PIVA_ScheArrangeItm
		(PSAI_Parref,PSAI_ChildSub,PSAI_Date,PSAI_User_Dr,PSAI_Schedul_Dr,PSAI_Duty_Dr)
		VALUES
		(:psaId,:maxChild,:calcuDate,:userId,:scheId,:dutyId)	
		)
	...i SQLCODE'=0 s errCode="-1^插入排班子表失败,"_$g(%msg) q 
	i errCode'="" tro  q errCode
	tc
	q 0
}

/// description: 准备人员可上班的日期
/// description: 准备岗位班次数据
/// description: 获取下月1号 logical格式日期
/// w ##class(web.DHCSTPIVAS.AutoScheArrange).NextMonLogical1("2018-01-01")
ClassMethod NextMonLogical1(curMonDate)
{
	s curMonHtml=$zd(curMonDate,3)
	s curYear=+$p(curMonHtml,"-",1)
	s curMonth=+$p(curMonHtml,"-",2)
	i curMonth=12 s nextMonth=1,nextYear=curYear+1
	e  s nextMonth=curMonth+1,nextYear=curYear
	s nextMonDate=nextYear_"-"_nextMonth_"-"_"01"
	q $zdh(nextMonDate,3)
}

/// description: 验证是否已存在该月排班
/// return:		 0:不存在
ClassMethod CheckExistScheArr(locId, monthDate)
{
	s monthDate=$zdh(monthDate,3)
	&SQL(
		SELECT PSA_RowId FROM PIVA_ScheArrange
		WHERE PSA_Month=:monthDate and PSA_Loc_Dr=:locId
	)
	q:SQLCODE=0 "-1^已存在本月排班"
	q 0
}

/// description: 进程号
ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"PIVA")
}

}
