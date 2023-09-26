/// CTOR: QP
/// DATE: 2020-12-03
/// DESC: 化疗单流程改造类
Class DHCDoc.Chemo.BS.Ext.Process Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-12-03
/// DESC: 组织数据从小到大排列，并判断是否连续
/// 	  
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Process).BuildNumAsc("65749",65749,"I")
ClassMethod BuildNumAsc(SDate, Days, AdmType, ByRef RList)
{
	s ^QP("BuildNumAsc")=$LB(SDate, Days, AdmType)
	S mRtn = ""
	s ShortOrder="",LongOrder=""
	/*
		orderType:short/long
		num:对于long是预停的间隔数
			对于short是疗程
		freq: 频次
		containDay:此次开的包含的天数
		OrderEndDate:预停日期
		RList(date)=orderType^num^freq^IsLx^containDay^OrderEndDate
	*/
	Q:(SDate="")||(Days="") mRtn
	s OrderEndDate=""
	i AdmType="I" {
		;住院规则
		s MList(1)=""
		s MList(2)=""
		s MList(3)=""
		s MList(4)=""
		s MList(5)=""
		s MList(6)=""
		s MList(7)=""
		s num7=0,num8=0	//7天以内的个数
		f i=1:1:$l(Days,",") {
			s date=$p(Days,",",i)
			s j=date-SDate+1
			s MList(j)=date
			i j<=7 {
				s NList(j)=date
				s num7=num7+1
			}
			i j>7 s num8=num8+1
		}
		s over7=$O(MList(7))
		;说明有超过Day7的天数
		i over7'="" {
			s k=7
			f  s k=$o(MList(k)) d
			.s date=MList(k)
			.i ShortOrder="" s ShortOrder=date
			.e  s ShortOrder=ShortOrder_","_date
			.s RList(date)="short^1^^^"_date_"^"_OrderEndDate
		}
		;7天以内的为长嘱
		Q:num7=0 LongOrder_$c(1)_ShortOrder
		i num7=1 {
			s num=$o(NList(""))
			s date=$g(NList(num))
			i ShortOrder="" s ShortOrder=date
			e  s ShortOrder=ShortOrder_","_date	
			s RList(date)="short^1^^^"_date_"^"_OrderEndDate
		} else {
			;判断是否连续
			s LXNum=""
			s h=""
			f  s h=$o(NList(h)) q:h=""  d
			.s date=NList(h)
			.s i=i+1
			.i LXNum="" s LXNum=date
			.e  s LXNum=LXNum_","_date
			
			s isLX=..IsLX(LXNum)
			i isLX=1 {
				;连续
				s num=$o(NList(""))
				s date=(NList(num))
				s LongOrder=date_"^"_num7
				s OrderEndDate=date+num7-1
				s OrderEndDate=##class(websys.Conversions).DateLogicalToHtml(OrderEndDate)
				s time=$p($h,",",2)
				s currentTime=$zt(time,1)
				s OrderEndDate=OrderEndDate_" "_currentTime
				
				s RList(date)="long^"_num7_"^^"_isLX_"^"_LXNum_"^"_OrderEndDate
			} else {
				;不连续
				s freq="QW135"
				s LongOrder=date_"^"_num7_"^"_freq
				s RList(date)="long^"_num7_"^"_freq_"^"_isLX_"^"_LXNum_"^"_OrderEndDate
			}
		}
		
		
	} else {
		//门诊规则
		s num=0
		f i=1:1:$l(Days,",") {
			s date=$p(Days,",",i)
			s j=date-SDate+1
			s MList(j)=date
			s num=num+1
		}
		Q:num=0 LongOrder_$c(1)_ShortOrder
		i num=1 {
			s ShortOrder=Days_"^"_num
			s RList(Days)="short^1^^^"_date_"^"_OrderEndDate
		} else {
			s LXNum=""
			s h=""
			f  s h=$o(MList(h)) q:h=""  d
			.s date=MList(h)
			.i LXNum="" s LXNum=date
			.e  s LXNum=LXNum_","_date

			s isLX=..IsLX(LXNum)
			i isLX=1 {
				s date=$p(LXNum,",",1)
				s ShortOrder=date_"^"_num
				s RList(date)="short^"_num_"^^^"_LXNum_"^"_OrderEndDate
			} else {
				s h=""
				f  s h=$o(MList(h)) q:h=""  d
				.s date=MList(h)
				.i ShortOrder="" s ShortOrder=date_"^"_1
				.e  s ShortOrder=ShortOrder_","_date_"^"_1
				.s RList(date)="short^1^^^"_date_"^"_OrderEndDate
			}
		}
		
	}
	;B ;001
    Q ""
}

/// CTOR: QP
/// DATE: 2020-12-03
/// DESC: 判断数据是否连续
/// OUT : 1连续，0不连续	  
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Process).GetIsLX("65714,65713,65715")
ClassMethod GetIsLX(LXNum)
{
	s mRtn=0
	Q:LXNum="" mRtn
	s LXNum=..GetNumByOrder(LXNum,"ASC")
	s mRtn=..IsLX(LXNum)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-03
/// DESC: 将数据按顺序排列
/// OUT : 	  
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Process).GetNumByOrder("65714,65713,65715","ASC")
ClassMethod GetNumByOrder(LXNum, Order)
{
	s mRtn=""
	Q:LXNum="" mRtn
	
	f i=1:1:$l(LXNum,",") {
		s num=$p(LXNum,",",i)
		s DList(num)=""
	}
	
	i Order="ASC" {
		s num=""
		f  s num=$o(DList(num)) q:num=""  d
		.i mRtn="" s mRtn=num
		.e  s mRtn=mRtn_","_num
	} else {
		s num=""
		f  s num=$o(DList(num),-1) q:num=""  d
		.i mRtn="" s mRtn=num
		.e  s mRtn=mRtn_","_num
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-03
/// DESC: 判断数据是否连续
/// OUT : 1连续，0不连续	  
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Process).IsLX("65713,65714,65715")
ClassMethod IsLX(LXNum)
{
	s mRtn=1
	s lastNum=""
	f i=1:1:$l(LXNum,",") {
		s num=$p(LXNum,",",i)
		i lastNum="" {
			s lastNum=num
		} else {
			i (num-lastNum)'=1 {
				s mRtn=0
				Q 	
			}
			s lastNum=num
		}
		
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-03
/// DESC: 获取医嘱类型ID
/// OUT : 	  
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Process).GetPriorDr("short")
ClassMethod GetPriorDr(type)
{
	s mRtn=""
	i type="short" {
		q:'$d(^OECPR(0,"Code","NORM")) mRtn
		s mRtn=$o(^OECPR(0,"Code","NORM",""))
	}
	i type="long" {
		q:'$d(^OECPR(0,"Code","S")) mRtn
		s mRtn=$o(^OECPR(0,"Code","S",""))
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-03
/// DESC: 获取医嘱类型ID
/// OUT : 	  
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Process).GetPriorByDate("short")
ClassMethod GetPriorByDate(ByRef ShowDateList, date, dateinfo)
{
	/*
		对于住院，7天以内的不连续的不让开: 因为
			如果不连续的时候，每天的医嘱不能保证是一致的，A可能在Day1出现，也可能在Day2出现
	
	*/
	s mRtn=""
	s orderType=$p(dateinfo,"^",1)
	s orderDur=$p(dateinfo,"^",2)
	s isLX=$p(dateinfo,"^",4)
	s mRtn=..GetPriorDr(orderType)
	Q:orderType'="long" mRtn
	Q:isLX'=1 //对于住院，7天以内的不连续的不让开
	s isDayLx=1
	f i=1:1:orderDur {
		i '$d(ShowDateList(date+i-1)) {
			s isDayLx=0
			Q
		}	
	}
	i isDayLx=0 s mRtn=..GetPriorDr("short")
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-03
/// DESC: 组织showDate
/// OUT : 	  
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Process).DoShowDate("short")
ClassMethod DoShowDate(ShowDate, ByRef ShowDateList)
{
	s mRtn=""
	q:ShowDate=""
	f i=1:1:$l(ShowDate,",") {
		s date=$p(ShowDate,",",i)
		s date=##class(websys.Conversions).DateHtmlToLogical(date)
		s ShowDateList(date)=""
		i mRtn="" s mRtn=date
		e  s mRtn=mRtn_","_date
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-03
/// DESC: 过滤ShowDate
/// OUT : 1过滤，0不过滤
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Process).FiletrShowDate("2021-03-07", 65808)
ClassMethod FiletrShowDate(ShowDate, CDate)
{
	q:ShowDate="" 1
	k TList
	s mRtn=1
	f i=1:1:$l(ShowDate,",") {
		Q:mRtn=0
		s date=$p(ShowDate,",",i)
		s date=##class(websys.Conversions).DateHtmlToLogical(date)
		s TList(date)=""
		i date=CDate s mRtn=0
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-03
/// DESC: 获取疗程ID
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Process).GetDruByDay("1")
ClassMethod GetDruByDay(Day)
{
	s mRtn=""
	Q:Day="" mRtn
	s Day=Day_"天"
	s mRtn=$o(^PHCDU(0,"Code",Day,""))
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-03
/// DESC: 获取医嘱ID
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Process).GetOeoriByDay("471||1||1||1","423||1")
ClassMethod GetOeoriByDay(ItemDR, PDAID)
{
	s mRtn=""
	/*
		zw ^BS.DOC.Chemo.PlanOrderI("PDAID","424||1")
		s ^BS.DOC.Chemo.PlanOrderI("LinkPDAIDItemDR","425||1","471||1||1||1",1203)=""

	*/
	Q:(ItemDR="")||(PDAID="") mRtn
	s POID=$O(^BS.DOC.Chemo.PlanOrderI("PDAIDItemDR",PDAID,ItemDR,""))
	
	i POID="" {
		s POID=$O(^BS.DOC.Chemo.PlanOrderI("LinkPDAIDItemDR",PDAID,ItemDR,""))
		Q:POID="" mRtn	
	}
	s mRtn=$P(^BS.DOC.Chemo.PlanOrderD(POID),"^",1)
	
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-12-18
/// DESC: 获取本次医嘱需要加载次数
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Process).GetBNum("1")
ClassMethod GetBNum(cdate, orderDur, qty, ByRef ShowDateList, ByRef BList, ByRef QTYList)
{
	s mRtn=1
	
	s ^QP("GetBNum")=$lb(cdate, orderDur)
	//s ^TEMPDHCANTHH(1)=^TEMPDHCANTHH(1)+1
	s time=$p($h,",",2)
	s currentTime=$zt(time,1)
	;
	;
	s date="",ShowDateStr=""
	f  s date=$o(ShowDateList(date)) q:date=""  d
	.i ShowDateStr="" s ShowDateStr=date
	.e  s ShowDateStr=ShowDateStr_","_date
	;
	;b ;0011
	i orderDur=1 {
		s newDur=orderDur
		s newDur=##class(DHCDoc.Chemo.BS.Ext.Process).GetDruByDay(newDur)
		s startDate=cdate
		//s startDate=$p(ShowDateStr,",",1)
		s startDateVal=startDate
		s startDate=##class(websys.Conversions).DateLogicalToHtml(startDate)
		s startDate=startDate_" "_currentTime
		s BList(1)=newDur_"^"_startDate_"^"_startDateVal_"^"_qty
		Q mRtn	
	}
	
	
	s isLx=..IsLX(ShowDateStr)
	
	i isLx=1 {
		s newDur=$l(ShowDateStr,",")
		i newDur>orderDur s newDur=orderDur
		s qty=qty*newDur
		//s qty=##class(DHCDoc.Chemo.COM.Func2).CalcPackQty(EpisodeID, PGIID, "CUR",SessionStr,dosage)
		s newDur=##class(DHCDoc.Chemo.BS.Ext.Process).GetDruByDay(newDur)
		s startDate=$p(ShowDateStr,",",1)
		s startDateVal=startDate
		s startDate=##class(websys.Conversions).DateLogicalToHtml(startDate)
		s startDate=startDate_" "_currentTime
		//s ^QP("tt",^TEMPDHCANTHH(1))=$lb(ShowDateStr,newDur)
		s QTYList("OrderDurRowid")=newDur
		s qty=##class(DHCDoc.Chemo.COM.Func2).CalcCombinePackQty(.QTYList)
		s BList(1)=newDur_"^"_startDate_"^"_startDateVal_"^"_qty
	} else {
		s date="",HNum=0
		s maxDate=cdate+orderDur-1	;
		f  s date=$o(ShowDateList(date)) q:date=""  d
		.q:date>maxDate
		.s HNum=HNum+1
		.s startDateVal=date
		.s startDate=##class(websys.Conversions).DateLogicalToHtml(date)
		.s startDate=startDate_" "_currentTime
		.s newDur=1
		.s newDur=##class(DHCDoc.Chemo.BS.Ext.Process).GetDruByDay(newDur)
		.s BList(HNum)=newDur_"^"_startDate_"^"_startDateVal_"^"_qty
		
		s mRtn=HNum
	}
	;b ;003
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-01-17
/// DESC: 获取HList节点
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Process).GetHNode(HList,Node,RepeatBum)
ClassMethod GetHNode(ByRef HList, Node, RepeatBum)
{
	s mRtn=""
	s len=$l(Node,".")
	i len=1 {
		f i=1:1:100{
			s nd = Node_"."_i
			i $d(HList(nd,RepeatBum)) {
				s mRtn=nd
				Q
			}
		}	
	} else {
		s num=$p(Node,".",1)
		s decial=$p(Node,".",2)
		i $d(HList(num,RepeatBum)) {
			s mRtn=num
		} else {
			f i=1:1:100{
				continue:i=decial
				s nd = Node_"."_i
				i $d(HList(nd,RepeatBum)) {
					s mRtn=nd
					Q
				}
			}
			
		}
	}
	
	Q mRtn
}

/**
	修改开始日期：
		1. 必须改的是Day1 + N 
		2. 修改 Chemo_PlanStage 的 startDate 、 endDate+N 、 chemoDate+N
		3. Chemo_PlanGroup ， PlanDate + N (2020-11-24,2020-12-01)
		4. Chemo_PlanItem , ShowDate + N (2020-11-24,2020-12-01)
		
	修改所选日期：
		1. 判断是否在所修改的范围内
		2. 判断是否需要修改
		3. 修改 Chemo_PlanStage 的 chemoDate+N
		3. Chemo_PlanGroup ， 将包含所选日期的，改成ToDate
		4. Chemo_PlanItem ,将包含所选日期的，改成ToDate

*/
/// CTOR: QP
/// DATE: 2021-01-27
/// DESC: 修改开始日期/ 修改所选日期
/// IN  : ToDate: 修改到哪一天,SelectDate:所选日期，IsFristDay：是否是第一天
/// OUT : 1 修改成功
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Process).UpdateStartDate(PSID, ToDate)
ClassMethod UpdateStartDate(PSID, ToDate, SelectDate, IsFristDay)
{
	s error=0,success=1
	Q:(PSID="")||(ToDate="") success	//
	s PLID=$P(PSID,"||",1)
	S SID=$P(PSID,"||",2)
	s ToDate=##class(websys.Conversions).DateHtmlToLogical(ToDate)
	s SelectDate=##class(websys.Conversions).DateHtmlToLogical(SelectDate)
	s SDate=$p(^BS.DOC.Chemo.PlanD(PLID,SID),"^",3)	
	s EDate=$p(^BS.DOC.Chemo.PlanD(PLID,SID),"^",4)
	s ChemoDate=$p(^BS.DOC.Chemo.PlanD(PLID,SID),"^",21)	
	i IsFristDay=1 {
		S ToNum=ToDate-SDate
		Q:ToNum=0 success	//日期不变不做修改
		;周期
		s SDate=SDate+ToNum
		S EDate=EDate+ToNum
		;修改暂存天数的日期
		s rtn=..UpdatePDDate(PSID,ChemoDate,ToNum)
		q:rtn'=0 error
		s ChemoDate=..GetNewDateToNum(ChemoDate,ToNum)
		s rtn=..UpdateStageDate(PSID, SDate, EDate, ChemoDate)
		q:rtn'=0 error
		;组
		s sub=""
		f  s sub=$o(^BS.DOC.Chemo.PlanD(PLID,SID,sub)) q:(sub="")||(rtn'=0)  d
		.s planDate=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub),"^",3)
		.q:planDate=""
		.s planDate=..GetNewDateToNum(planDate,ToNum)
		.;修改组日期
		.s PGID=PSID_"||"_sub
		.s rtn=..UpdateGroupDate(PGID,planDate)
		.q:rtn'=0
		.s ch=""
		.f  s ch=$o(^BS.DOC.Chemo.PlanD(PLID,SID,sub,ch)) q:(ch="")||(rtn'=0)  d
		..s showDate=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,ch),"^",28)
		..q:showDate=""
		..s showDate=..GetNewDateToNum(showDate,ToNum)
		..;修改组项目日期
		..s PGIID=PSID_"||"_sub_"||"_ch
		..s rtn=..UpdateItemDate(PGIID,showDate)
		..q:rtn'=0
	} else {
		Q:SelectDate="" success
		Q:SelectDate=ToDate success
		S ToNum=ToDate-SelectDate
		Q:ToNum=0 success
		;判断ToDate是否在合理范围内
		Q:SDate>ToDate success
		Q:EDate<ToDate success
		s Rtn=..CheckDate(SelectDate,ToDate,ChemoDate)
		Q:Rtn=0 success	
		;周期
		;修改暂存天数的日期
		s NewChemoDate=..GetNewChemoDate(SelectDate,ToDate,PSID)
		s rtn=..UpdatePDDate(PSID,NewChemoDate,ToNum)
		q:rtn'=0 error
		s NewChemoDate=..GetNewChemoDate(SelectDate,ToDate,PSID,1)
		s rtn=..UpdateStageDate(PSID, SDate, EDate, NewChemoDate)
		q:rtn'=0 error
		;组
		s sub=""
		f  s sub=$o(^BS.DOC.Chemo.PlanD(PLID,SID,sub)) q:(sub="")||(rtn'=0)  d
		.s planDate=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub),"^",3)
		.q:planDate=""
		.s planDate=..GetNewDateToNum(planDate,ToNum,SelectDate)
		.;修改组日期
		.s PGID=PSID_"||"_sub
		.s rtn=..UpdateGroupDate(PGID,planDate)
		.q:rtn'=0
		.s ch=""
		.f  s ch=$o(^BS.DOC.Chemo.PlanD(PLID,SID,sub,ch)) q:(ch="")||(rtn'=0)  d
		..s showDate=$p(^BS.DOC.Chemo.PlanD(PLID,SID,sub,ch),"^",28)
		..q:showDate=""
		..s showDate=..GetNewDateToNum(showDate,ToNum,SelectDate)
		..;修改组项目日期
		..s PGIID=PSID_"||"_sub_"||"_ch
		..s rtn=..UpdateItemDate(PGIID,showDate)
		..q:rtn'=0
		
	}
	i rtn'=0 {
		Q error	
	} 
	
	Q success
}

/// CTOR: QP
/// DATE: 2021-01-27
/// DESC: 根据步长得到新的日期串
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Process).GetNewDateToNum("2020-11-24,2020-11-25,2020-11-26",65708)
ClassMethod GetNewDateToNum(DList, ToNum, SelectDate = "")
{
	s mRtn=""
	q:DList="" mRtn
	f i=1:1:$l(DList,",") {
		s date=$p(DList,",",i)
		s date=##class(websys.Conversions).DateHtmlToLogical(date)
		i SelectDate'="" {
			;从某一天开始后联动
			i date>=SelectDate {
				s date=date+ToNum	
			} else {
				//
			}
		} else {
			s date=date+ToNum
		}
		s date=##class(websys.Conversions).DateLogicalToHtml(date)
		i mRtn="" s mRtn=date
		e  s mRtn=mRtn_","_date
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-01-27
/// DESC: 修改周期日期
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.LifeDose).DeleteTPL("")
ClassMethod UpdateStageDate(PSID, SDate, EDate, ChemoDate)
{
	Q:PSID="" 0
	&SQL(
		UPDATE SQLUser.Chemo_PlanStage 
		SET PS_StartDate=:SDate,PS_EndDate=:EDate,PS_ChemoDate=:ChemoDate
		WHERE PS_ID=:PSID
	)
	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2021-01-27
/// DESC: 修改项目日期
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.LifeDose).DeleteTPL("")
ClassMethod UpdateItemDate(PGIID, ShowDate)
{
	Q:PGIID="" 0
	&SQL(
		UPDATE SQLUser.Chemo_PlanItem 
		SET PGI_ShowDate=:ShowDate
		WHERE PGI_ID=:PGIID
	)
	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2021-01-27
/// DESC: 修改组日期
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.LifeDose).DeleteTPL("")
ClassMethod UpdateGroupDate(PGID, PlanDate)
{
	Q:PGID="" 0
	&SQL(
		UPDATE SQLUser.Chemo_PlanGroup 
		SET PG_PlanDate=:PlanDate
		WHERE PG_ID=:PGID
	)
	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2021-01-27
/// DESC: 是否第一天
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.Process).IsFirstDay(PSID, SelectDate)
ClassMethod IsFirstDay(PSID, SelectDate)
{
	s mRtn=0
	Q:(PSID="")||(SelectDate="") mRtn
	s PLID=$P(PSID,"||",1)
	S SID=$P(PSID,"||",2)
	s SelectDate=##class(websys.Conversions).DateHtmlToLogical(SelectDate)
	s SDate=$p(^BS.DOC.Chemo.PlanD(PLID,SID),"^",3)	
	i SelectDate=SDate {
		s mRtn=1
	}
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-03-11
/// DESC: 修改暂存的天数
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.LifeDose).DeleteTPL("")
ClassMethod UpdatePDDate(PSID, ChemoDate, ToNum)
{
	s Err=0
	Q:(PSID="")||(ChemoDate="") Err
	
	f i=1:1:$l(ChemoDate,",") {
		Q:Err'=0
		s date=$p(ChemoDate,",",i)
		s PDID=##class(DHCDoc.Chemo.BS.Date).GetPDIDByDate(date,PSID)
		continue:PDID=""
		s date=##class(websys.Conversions).DateHtmlToLogical(date)
		s date=date+ToNum
		&SQL(
			UPDATE SQLUser.Chemo_PlanDate 
			SET PD_Date=:date
			WHERE PD_ID=:PDID
		)
		i SQLCODE'=0 {
			s Err=1
			Q	
		}

	}
	
	Q Err
}

/// CTOR: QP
/// DATE: 2021-04-12
/// DESC: 检查日期是否在合理的范围内
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.LifeDose).DeleteTPL("")
ClassMethod CheckDate(SelectDate, ToDate, PSID)
{
	s no=0,yes=1,mRtn=1
	Q:PSID="" no
	s PLID=$P(PSID,"||",1)
	S SID=$P(PSID,"||",2)
	s SDate=$p(^BS.DOC.Chemo.PlanD(PLID,SID),"^",3)	
	s EDate=$p(^BS.DOC.Chemo.PlanD(PLID,SID),"^",4)
	s ChemoDate=$p(^BS.DOC.Chemo.PlanD(PLID,SID),"^",21)
	Q:ChemoDate="" no
	S ToNum=ToDate-SelectDate
	f i=1:1:ChemoDate {
		s date=$p(ChemoDate,",",i)
		s date=##class(websys.Conversions).DateHtmlToLogical(date)
		continue:SelectDate>date
		s newdate=date+ToNum
		i newdate>EDate {
			s mRtn=no
			Q
		}
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-04-12
/// DESC: 得到需要修改的日期串
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.CFG.LifeDose).DeleteTPL("")
ClassMethod GetNewChemoDate(SelectDate, ToDate, PSID, Flag = 0)
{
	s mRtn=""
	Q:PSID="" mRtn
	s PLID=$P(PSID,"||",1)
	S SID=$P(PSID,"||",2)
	s SDate=$p(^BS.DOC.Chemo.PlanD(PLID,SID),"^",3)	
	s EDate=$p(^BS.DOC.Chemo.PlanD(PLID,SID),"^",4)
	s ChemoDate=$p(^BS.DOC.Chemo.PlanD(PLID,SID),"^",21)
	Q:ChemoDate="" mRtn
	S ToNum=ToDate-SelectDate
	f i=1:1:ChemoDate {
		s date=$p(ChemoDate,",",i)
		s date=##class(websys.Conversions).DateHtmlToLogical(date)
		i Flag=1 {
			;得到新的日期串
			i SelectDate>date {
				s newdate=date
			} else {
				s newdate=date+ToNum
			}
			s newdate=##class(websys.Conversions).DateLogicalToHtml(newdate)
			i mRtn="" s mRtn=newdate
			e  s mRtn=mRtn_","_newdate
			
		} else {
			;得到需要修改的日期串
			continue:SelectDate>date
			s date=##class(websys.Conversions).DateLogicalToHtml(date)
			i mRtn="" s mRtn=date
			e  s date=mRtn_","_date	
		}
		
	}
	
	Q mRtn
}

}
