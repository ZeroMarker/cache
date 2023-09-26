Class web.DHCRBResourceRule Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod CheckAppQtyByApptSchedule(ScheduleID As %String) As %String
{
	set returnvalue="0"
	set ASQASParRef=$Piece(ScheduleID,"||",1)
	set ASQChildsub=$Piece(ScheduleID,"||",2)
	set RowID=""
	set RowID=$Order(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID))
	while(RowID'="")
	{
		set AppQty=$Get(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID))
		set Qty=$Piece(AppQty,"^",2)
		if ((Qty>0)&&(returnvalue="0"))
		{
			set returnvalue="1"
		}
		set RowID=$Order(^RBAS(ASQASParRef,ASQChildsub,"AQ",RowID))
	}
	
	quit returnvalue
}

ClassMethod CheckSchedule(ResRowID As %String, ScheduleDate As %String, RoomID As %String, SessionStartTime As %String, RBASRowId As %String = "") As %String
{
	n (ResRowID, ScheduleDate, RoomID, SessionStartTime , RBASRowId, %session)
	s ^zhou("CheckSchedule")=ResRowID_","_ScheduleDate_","_RoomID_","_SessionStartTime_","_RBASRowId
	;w ##class(web.DHCRBResourceRule).CheckSchedule(3217,65741,"",30600,"")
	;w ##class(web.DHCRBResourceRule).CheckSchedule(2,65741,"",1,"")
	;w ##class(web.DHCRBResourceRule).CheckSchedule(2,65741,"",46800,"")
	//同一个资源在同一天同一诊不能同时在两个诊室
	set count=0,ChkTRRowId=""
	;如果是全天和上下午这种有重叠时段诊区排诊这样单纯的判断一个，或者取排班数据就是错误的.
	;SessionStartTime如果传入的是一个时段的开始时间点，恰好是另一个时段的结束时间点那么通过时间点取值就会错误。所以+1确保是在时段时间内。
	k TempTimRang
	if RBASRowId'="" d
	.s ChkTRRowId=$p($g(^RBAS($p(RBASRowId,"||",1),$p(RBASRowId,"||",2),"DHC")),"^",17)
	.;s ChkTRRowId=##class(web.DHCRBApptSchedule).GetTimeRangeStrByRange(ChkTRRowId)
	else  d
	.s ChkTRRowId=##class(web.DHCRBApptSchedule).GetTimeRangeStrByTime(SessionStartTime,2)
	/*.s TRRowId=0  f  s TRRowId=$O(^DHCTimeRange(TRRowId)) Q:(TRRowId="")  d
	..s StartTime=$P(^DHCTimeRange(TRRowId),"^",3)
	..s EndTime=$P(^DHCTimeRange(TRRowId),"^",4)
	..s UseStDate=$P(^DHCTimeRange(TRRowId),"^",7)
	..Q:(UseStDate>+$H)&&(UseStDate'="")
	..s UseEndDate=$P(^DHCTimeRange(TRRowId),"^",8)
	..Q:(UseEndDate<+$H)&&(UseEndDate'="")
	..if StartTime=SessionStartTime  d
	...s Sub=(EndTime-StartTime)
	...s TempTimRang(Sub)=TRRowId
	.s TRRowIdSub=$O(TempTimRang(0))
	.if TRRowIdSub'="" d
	..s TRRowId=$G(TempTimRang(TRRowIdSub))
	..s TRRowId=##class(web.DHCRBApptSchedule).GetTimeRangeStrByRange(TRRowId)*/
	if ChkTRRowId=""  d
	.s ChkTRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime(SessionStartTime)
	.s ChkTRRowId=##class(web.DHCRBApptSchedule).GetTimeRangeStrByRange(ChkTRRowId)
	s DulASRowId=""
	s DocDr=$p(^RB("RES",ResRowID),"^",2)
	Set LocDr=0 f  Set LocDr=$O(^RB("RES",0,"CTPCP",DocDr,LocDr)) Quit:LocDr=""  d
	.;不同科室的出诊不判断
	.q:LocDr'=$p(^RB("RES",ResRowID),"^",1)
	.Set RowId=0 f  Set RowId=$O(^RB("RES",0,"CTPCP",DocDr,LocDr,RowId)) Quit:RowId=""  d
	..s SessTime=0  f  s SessTime=$O(^RBAS(RowId,0,"DateSTime",ScheduleDate,SessTime)) Q:SessTime=""  d
	...;s SessTRRowId=##Class(web.DHCRBResSession).GetTimeRangeByTime(SessTime)
	...s Child=0  f  s Child=$Order(^RBAS(RowId,0,"DateSTime",ScheduleDate,SessTime,Child)) Q:(Child="")  d
	....Q:(RBASRowId'="")&&(RBASRowId=(ResRowID_"||"_Child))
	....s SessTRRowId=$P($G(^RBAS(RowId,Child,"DHC")),"^",17)
	....;s SessTRRowId=##class(web.DHCRBApptSchedule).GetTimeRangeStrByRange(SessTRRowId)
	....Q:(("!"_ChkTRRowId_"!")'[("!"_SessTRRowId_"!"))&&(("!"_SessTRRowId_"!")'[("!"_ChkTRRowId_"!"))
	....s status=$P($G(^RBAS(RowId,Child,"DHC")),"^",10)
	....i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)
	....;过滤停诊和替诊
	....Q:(status="S")!(status="TR")
	....s count=count+1
	....s DulASRowId=RowId_"||"_Child
	if (count>0) quit "-201"_"^"_DulASRowId
	
	//根据分诊区设置 ，同一个诊室在同一天同一诊不能同时被安排两次
	s BordExaID=$O(^User.DHCBorExaRoomI("BordExaRoomDrIndex"," "_RoomID,0))
	s ChecBordForOne="Y"
	if (BordExaID'=""){
		s ChecBordForOne=$lg(^User.DHCBorExaRoomD(BordExaID),10)
	}
	if (ChecBordForOne="Y"){
		s find=0
		s ResRowId=0  f  s ResRowId=$O(^RB("RES",ResRowId)) Q:(ResRowId="")||(find=1)  d
		.s SessTime=0  f  s SessTime=$Order(^RBAS(ResRowId,0,"DateSTime",ScheduleDate,SessTime)) Q:(SessTime="")||(find=1)  d
		..s Child=0  f  s Child=$Order(^RBAS(ResRowId,0,"DateSTime",ScheduleDate,SessTime,Child)) Q:(Child="")||(find=1)  d
		...s RoomDr=$P($G(^RBAS(ResRowId,Child,"DHC")),"^",5)
		...s SessTRRowId=$P($G(^RBAS(ResRowId,Child,"DHC")),"^",17)
		...s SessTRRowId=##class(web.DHCRBApptSchedule).GetTimeRangeStrByRange(SessTRRowId)
		...Q:(("!"_ChkTRRowId_"!")'[("!"_SessTRRowId_"!"))&&(("!"_SessTRRowId_"!")'[("!"_ChkTRRowId_"!"))
		...Q:(RBASRowId'="")&&(RBASRowId=(ResRowId_"||"_Child))
		...s status=$P($G(^RBAS(ResRowId,Child,"DHC")),"^",10)
		...i status'="" s status=$P(^DHCRBCASStatus(status),"^",1)
		...;过滤停诊和替诊
		...Q:(status="S")!(status="TR")
		...Q:RoomDr=""    ;排班不录诊室
		...i RoomDr=RoomID d
		....s find=1
		....s DulASRowId=ResRowId_"||"_Child
		...Q:find=1
		k TempTimRang
		i find=1 Quit "-202"_"^"_DulASRowId
	}
	quit 0
}

ClassMethod CheckScheduleDate(ASRowId As %String) As %String
{
	;w ##class(web.DHCRBResourceRule).CheckScheduleDate("6||5")
	set obj=##class(User.RBApptSchedule).%OpenId(ASRowId)
	set ASDate=obj.ASDate
	do obj.%Close()
	&SQL(SELECT FESTDate FROM SQLUser.DHC_OPRegFestivalSet where FESTDate=:ASDate)
	Q SQLCODE
}

ClassMethod EditQueueNO(oldQueueNO As %String, oldTotalNum As %String, newTotalNum As %String, oldOverBookNum As %String, newOverBookNum As %String, ScheduleID As %String, NoLimitLoadFlag As %String = "") As %String
{
	n (oldQueueNO,oldTotalNum,newTotalNum,oldOverBookNum, newOverBookNum, ScheduleID, NoLimitLoadFlag)
	if NoLimitLoadFlag="Y"{
		set ZhengHao=""
	}else{
		s ASNoLimitLoadFlag=##class(web.DHCRBApptSchedule).GetASNoLimitLoadFlag(ScheduleID)
		if (ASNoLimitLoadFlag="Y")&&(ASNoLimitLoadFlag'=NoLimitLoadFlag){
			;需要由便捷排班无号串改为正常有号串排班
			set ZhengHao=##class(web.DHCRBResourceRule).EditQueueNORule(0,$piece(oldQueueNO,$char(1),1),newTotalNum,"",ScheduleID)
		}else{
			set ZhengHao=##class(web.DHCRBResourceRule).EditQueueNORule(oldTotalNum,$piece(oldQueueNO,$char(1),1),newTotalNum,"",ScheduleID)
		}
	}
	set JiaHao=##class(web.DHCRBResourceRule).EditQueueNORule(oldOverBookNum,$piece(oldQueueNO,$char(1),2),newOverBookNum,"ADD",ScheduleID)
	quit ZhengHao_$char(1)_JiaHao
}

ClassMethod EditQueueNORule(oldNum As %String, oldQueueNO As %String, newNum As %String, Mode As %String, ScheduleID As %String) As %String
{
	if ScheduleID="" q ""
	s ResRowId="" s Childsub="" 
	s ResRowId=$p(ScheduleID,"||",1)
	s Childsub=$p(ScheduleID,"||",2)
	lock +^RBASLOCK(ResRowId,Childsub):10
	s QueueNo=""
	set QueueNo=oldQueueNO
	if (oldNum<newNum) //正号限额增加
	{
		set max=##class(web.DHCRBResourceRule).GetMaxQueueNO(QueueNo)
		for i=max+1:1:newNum-oldNum+max	{
			if Mode="ADD" {
				if QueueNo="" {
					set QueueNo="+"_i_":"_0
				}else{  
					set QueueNo=QueueNo_",+"_i_":"_0
				}
			}else{
				if QueueNo="" {
					set QueueNo=i_":"_0
				}else{  
					set QueueNo=QueueNo_","_i_":"_0
				}
			}
		}
	}elseif(oldNum>newNum){  //正号限额减少
		set returnvalue=""
		set len=$length(QueueNo,",")
		set count=oldNum

		for i=1:1:len
		{
			set valString=$Piece(QueueNo,",",i)
			set val=$piece(valString,":",1)
			set status=$piece(valString,":",2)
		 	//if (status=1){                //处理挂号数在修改之后不对
		 	if ((status'=0)&&(##class(web.DHCRBAppointment).GetReturnAllowRegFlag(status))) {
				if (returnvalue=""){
					set returnvalue=valString
				}else{
					set returnvalue=returnvalue_","_valString
				}                         //END
		 	}	
			if ((count>(oldNum-newNum))&&((status=0)||('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(status)))) //0-未取号?4-已退号
			{
				set count=count-1
				if (returnvalue=""){
					set returnvalue=valString
				}else{
					set returnvalue=returnvalue_","_valString
				}
			}else{
				set count=count-1    
			}
		}
		set QueueNo=returnvalue
	}
	lock -^RBASLOCK(ResRowId,Childsub)
	quit QueueNo
	
	;未修改前程序
	/***********************************
	if ScheduleID="" q ""
	s ^RP("ScheduleID")=ScheduleID
	s ResRowId="" s Childsub="" 
	s ResRowId=$p(ScheduleID,"||",1)
	s Childsub=$p(ScheduleID,"||",2)
	lock +^RBASLOCK(ResRowId,Childsub):30
	s QueueNo=""
	set QueueNo=oldQueueNO
	if (oldNum<newNum) //正号限额增加
	{
		set max=##class(web.DHCRBResourceRule).GetMaxQueueNO(QueueNo)
		for i=max+1:1:newNum-oldNum+max	{
			if Mode="ADD" {
				if QueueNo="" {
					set QueueNo="+"_i_":"_0
				}else{  
					set QueueNo=QueueNo_",+"_i_":"_0
				}
			}else{
				if QueueNo="" {
					set QueueNo=i_":"_0
				}else{  
					set QueueNo=QueueNo_","_i_":"_0
				}
			}
		}
	}
	elseif((oldNum>newNum)) //正号限额减少,对加号也适合
	{
		set returnvalue=""
		set len=$length(QueueNo,",")
		;已经使用的最大号MaxUsedQueueNo
		s MaxUsedQueueNo=0
		s MaxUsedQueueNo=##class(web.DHCRBResourceRule).GetMaxUsedQueueNo(QueueNo)
		;
		if newNum<MaxUsedQueueNo{  
			q QueueNo
		}else{	
			S QueueNo=$P(QueueNo,",",1,newNum)
		}
	}
	lock -^RBASLOCK(ResRowId,Childsub)
	quit QueueNo
	**************************/
}

ClassMethod GenerateQueueNO(TotalNum As %String, OverBookNum As %String, ASNoLimitLoadFlag As %String = "") As %String
{
	n (TotalNum,OverBookNum,ASNoLimitLoadFlag,%session)
	if ASNoLimitLoadFlag="Y"{
		set ZhengHao=""	
	}else{
		set ZhengHao=##class(web.DHCRBResourceRule).GenerateQueueNORule(TotalNum,"")
	}
	set JiaHao=##class(web.DHCRBResourceRule).GenerateQueueNORule(OverBookNum,"ADD")
	quit ZhengHao_$char(1)_JiaHao
}

ClassMethod GenerateQueueNORule(Num As %String, Mode As %String) As %String
{
	set QueueNo=""
	if Mode="ADD" {
		for i=1:1:Num {
			if QueueNo="" {
				set QueueNo="+"_i_":"_0
			}else{  
				set QueueNo=QueueNo_",+"_i_":"_0
			}
		}
	}else{
		for i=1:1:Num {
			if QueueNo="" {
				set QueueNo=i_":"_0
			}else{  
				set QueueNo=QueueNo_","_i_":"_0
			}
		}
	}
	quit QueueNo
}

ClassMethod GetFreeQueueNO(QueueNO As %String) As %String
{
	if QueueNO="" quit ""
	
	set ZhengHao=##class(web.DHCRBResourceRule).GetFreeQueueNORule($piece(QueueNO,$char(1),1))
	set JiaHao=##class(web.DHCRBResourceRule).GetFreeQueueNORule($piece(QueueNO,$char(1),2))

	quit "正号("_ZhengHao_") 加号("_JiaHao_")"
}

ClassMethod GetFreeQueueNORule(QueueNO As %String) As %String
{
	if QueueNO="" quit ""
	set returnvalue=""
	set len=$length(QueueNO,",")
	for i=1:1:len
	{
		set valString=$piece(QueueNO,",",i)
		set val=$piece(valString,":",1)
		set status=$piece(valString,":",2)
		if (status=0)||('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(status)) //0-未取号
		{
			if (returnvalue="")	{
				set returnvalue=val
			}else	{
				set returnvalue=returnvalue_","_val
			}
		}
	}
	quit returnvalue
}

ClassMethod GetMaxQueueNO(QueueNO As %String) As %String
{
	n (QueueNO)
	if QueueNO="" quit 0
	set max=0
	set len=$length(QueueNO,",")
	
	for i=1:1:len
	{
		set valString=$piece(QueueNO,",",i)
		set val=$piece(valString,":",1)
		if (val>max) //0-未取号?4-已退号
		{
			set max=val
		}
	}
	quit max
}

ClassMethod GetRegisterNum(QueueNO As %String, RBASId As %String = "") As %String
{
	n (QueueNO,RBASId,%session)
	//if QueueNO="" quit 0
	if RBASId'=""{
		s ASNoLimitLoadFlag=##class(web.DHCRBApptSchedule).GetASNoLimitLoadFlag(RBASId)
		if ASNoLimitLoadFlag="Y"{
			s ret=##class(web.DHCRBApptSchedule).GetRegisterNum(RBASId)
			Q ret
		}
	}
	
	s ZhengHao=##class(web.DHCRBResourceRule).GetRegisterNumRule($piece(QueueNO,$char(1),1))
	s RegedCount=$P(ZhengHao,"^",1)
	s AppedCount=$P(ZhengHao,"^",2)
	s AppedArriveCount=$P(ZhengHao,"^",3)
	s JiaHao=##class(web.DHCRBResourceRule).GetRegisterNumRule($piece(QueueNO,$char(1),2))
	;加号已经挂号或取号数
	s JiaHaoRegedCount=$P(JiaHao,"^",1)
	;加号未取号数
	s JiaHaoUnArriveCount=$P(JiaHao,"^",4)
	

	quit (RegedCount+JiaHaoRegedCount)_"^"_AppedCount_"^"_AppedArriveCount_"^"_(JiaHaoRegedCount+JiaHaoUnArriveCount)
}

ClassMethod GetRegisterNumRule(QueueNO As %String) As %String
{
	n (QueueNO)
	if QueueNO="" quit 0
	set returnvalue=0,returnvalue1=0,returnvalue2=0,returnvalue3=0
	set len=$length(QueueNO,",")
	for i=1:1:len
	{
		set valString=$piece(QueueNO,",",i)
		set status=$piece(valString,":",2)
		if (status=1)||(status=3) //0-未取号?4-已退号
		{
			set returnvalue=returnvalue+1
		}
		if (status=2)||(status=3){
			set returnvalue1=returnvalue1+1
		}
		if (status=3){
			set returnvalue2=returnvalue2+1
		}
		if (status=2){
			set returnvalue3=returnvalue3+1
		}
		if (QueueNO["+")&&(status=5){
			set returnvalue3=returnvalue3+1
		}
	}
	quit returnvalue_"^"_returnvalue1_"^"_returnvalue2_"^"_returnvalue3
}

}
