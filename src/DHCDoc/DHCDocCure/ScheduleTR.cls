Class DHCDoc.DHCDocCure.ScheduleTR Extends DHCDoc.Util.RegisteredObject
{

/// desc:   获取治疗排班可预约的号序
/// debug:  w ##class(DHCDoc.DHCDocCure.ScheduleTR).GetSeqNo(175,"17:00-17:30")
/// others: 预约的方法里进行了加锁；AppInsertHUI 调用
ClassMethod GetSeqNo(rbAsId As %String, timeRange As %String = "", onLineApp As %Integer = 0)
{
    s seqNo = 0
    s scheduleMaxQty = $p($g(^DHCDocCureRBCResSchdule(rbAsId)),"^",10)
    s appSeqNoStr = $p($g(^DHCDocCureRBCResSchdule(rbAsId)),"^",21)
    s appSeqNoLen=$l(appSeqNoStr, ",")
    s:appSeqNoStr="" appSeqNoLen=0
    s checkSeqNoStr = ","_appSeqNoStr_","
    if (scheduleMaxQty = appSeqNoLen) {
        q seqNo
    }
	s timeRangeData = $g(^DHCDocCureRBCResSchdule(rbAsId,"TR"))
    s timeRangeFlag = $p(timeRangeData, "^", 1)
    s timeRangeInterval  = $p(timeRangeData, "^", 2)
    s timeRangeReserveQty = +$p(timeRangeData, "^", 3)
    s timeRangeSeqSegStr = $p(timeRangeData, "^", 4)
    s timeRangePeriodStr  = $p(timeRangeData, "^", 5)
    if (timeRange '= "") {
        s len = $l(timeRangePeriodStr, ",")
        for i=1:1:len {
            s onePeriod = $p(timeRangePeriodStr, ",", i)
            continue:onePeriod'=timeRange
            s oneSeqSeg = $p(timeRangeSeqSegStr, ",", i)
            s sttSeq = $p(oneSeqSeg, "-", 1)
            s endSeq = $p(oneSeqSeg, "-", 2)
            if (onLineApp = 1) {
                s endSeq = endSeq - timeRangeReserveQty
            }
            for seq=sttSeq:1:endSeq {
                q:seqNo'=0
                if (checkSeqNoStr [ (","_seq_",")) {
                    continue
                } else {
                    s seqNo = seq
                }
            }
        }
    } else {
        // 默认取最小的一个可用的排班
        if (timeRangeFlag = "Y") {
             // TODO：是否考虑只能预约当前时间所在时段和之后的时段
            s reserveSeqStr = ..GetReserveSeqStr(rbAsId)
            s checkreserveSeqStr = ","_reserveSeqStr_","
            for seq=1:1:scheduleMaxQty {
                q:seqNo'=0
                if (checkSeqNoStr [ (","_seq_",")) {
                    continue
                    // 分时段保留号不能被线上预约
                    if (onLineApp = 1)&&(checkreserveSeqStr [ (","_seq_",")) {
                        continue
                    }
                } else {
                    s seqNo = seq
                }
            }


        } else {
            for seq=1:1:scheduleMaxQty {
                q:seqNo'=0
                if (checkSeqNoStr [ (","_seq_",")) {
                    continue
                } else {
                    s seqNo = seq
                }
            }
        }
       
    }
    q seqNo
}

/// desc:   获取一个排班的分时段可用号源数
/// debug:  w ##class(DHCDoc.DHCDocCure.ScheduleTR).GetTRAvailQtyStr(370)
ClassMethod GetTRAvailQtyStr(rbAsId) As %String
{
    s trAvailQtyStr = ""
    s timeRangeData = $g(^DHCDocCureRBCResSchdule(rbAsId,"TR"))
    s timeRangePeriodStr  = $p(timeRangeData, "^", 5)
    q:timeRangePeriodStr="" trAvailQtyStr


    s len = $l(timeRangePeriodStr, ",")
    for i=1:1:len {
        s onePeriod = $p(timeRangePeriodStr, ",", i)
        s oneTRAvailQty = ..GetOneTRAvailQty(rbAsId, onePeriod)
        s trAvailQtyStr = $s(trAvailQtyStr="" : oneTRAvailQty, 1 : trAvailQtyStr_","_oneTRAvailQty)
    }
    q trAvailQtyStr
}

/// desc:   获取分时段保留号号串
/// debug:  w ##class(DHCDoc.DHCDocCure.ScheduleTR).GetReserveSeqStr(175)
ClassMethod GetReserveSeqStr(rbAsId)
{
    s reserveSeqStr = ""
    s timeRangeData = $g(^DHCDocCureRBCResSchdule(rbAsId,"TR"))
    s timeRangeFlag = $p(timeRangeData, "^", 1)
    s timeRangeInterval  = $p(timeRangeData, "^", 2)
    s timeRangeReserveQty = +$p(timeRangeData, "^", 3)
    s timeRangeSeqSegStr = $p(timeRangeData, "^", 4)
    s timeRangePeriodStr  = $p(timeRangeData, "^", 5)
    if (timeRangeFlag = "Y")&&(timeRangeReserveQty '= 0) {
        s len = $l(timeRangeSeqSegStr, ",")
        for i=1:1:len {
            s oneSeqSeg = $p(timeRangeSeqSegStr, ",", i)
            s sttSeq = $p(oneSeqSeg, "-", 1)
            s endSeq = $p(oneSeqSeg, "-", 2)
            s mSttSeq = endSeq - timeRangeReserveQty + 1
            s:mSttSeq<sttSeq mSttSeq = sttSeq
            for seq=mSttSeq:1:endSeq {
                s reserveSeqStr = $s(reserveSeqStr="" : seq, 1 : reserveSeqStr_","_seq)
            }
        }
    }
    q reserveSeqStr
}

/// desc:   获取时段内可用号数
/// debug:  w ##class(DHCDoc.DHCDocCure.ScheduleTR).GetOneTRAvailQty(175,"17:00-17:30")
ClassMethod GetOneTRAvailQty(rbAsId As %String, timeRange As %String = "", onLineApp As %Integer = 0) As %String
{
    s trAvailQty = 0
    q:timeRange="" trAvailQty


    s appSeqNoStr = $p($g(^DHCDocCureRBCResSchdule(rbAsId)),"^",21)
    s checkSeqNoStr = ","_appSeqNoStr_","


    s timeRangeData = $g(^DHCDocCureRBCResSchdule(rbAsId,"TR"))
    s timeRangeFlag = $p(timeRangeData, "^", 1)
    s timeRangeInterval  = $p(timeRangeData, "^", 2)
    s timeRangeReserveQty = +$p(timeRangeData, "^", 3)
    s timeRangeSeqSegStr = $p(timeRangeData, "^", 4)
    s timeRangePeriodStr  = $p(timeRangeData, "^", 5)


    s len = $l(timeRangePeriodStr, ",")
    for i=1:1:len {
        s onePeriod = $p(timeRangePeriodStr, ",", i)
        continue:onePeriod'=timeRange
        s oneSeqSeg = $p(timeRangeSeqSegStr, ",", i)
        s sttSeq = $p(oneSeqSeg, "-", 1)
        s endSeq = $p(oneSeqSeg, "-", 2)
        if (onLineApp = 1) {
            s endSeq = endSeq - timeRangeReserveQty
        }
        for seq=sttSeq:1:endSeq {
            if (checkSeqNoStr [ (","_seq_",")) {
                continue
            } else {
                s trAvailQty = $i(trAvailQty)
            }
        }
    }
    q trAvailQty
}

/// 释放号源
ClassMethod RestoreSeqNo(RowId As %String, QueNo As %String) As %String
{
	Q:(QueNo="") 0
	s ret=100
	lock +^DHCDocCureRBCResSchdule(RowId):10
	i $test {
		s SeqNoStr=$p($g(^DHCDocCureRBCResSchdule(RowId)),"^",21)
		s NewSeqNoStr=""
		s len=$l(SeqNoStr,",")
		f i=1:1:len {
			s SeqNo=$p(SeqNoStr,",",i)
			if SeqNo'=QueNo {
				if NewSeqNoStr="" s NewSeqNoStr=SeqNo
				else  s NewSeqNoStr=NewSeqNoStr_","_SeqNo
			}
		}
		s $p(^DHCDocCureRBCResSchdule(RowId),"^",21)=NewSeqNoStr
		s ret=0
	}
	lock -^DHCDocCureRBCResSchdule(RowId)
	q ret
}

ClassMethod GetTimeRangeInfo(RowId As %String, SeqNo As %String, SessionStr As %String = "") As %String
{
	s langid=$p(SessionStr,"^",7)	
	s:langid="" langid=..%LanguageID()
    s DocCureASData=$g(^DHCDocCureRBCResSchdule(RowId))
	s ASDate=$p(DocCureASData,"^",4)  //出诊日期
	s TimeRangeDr=$p(DocCureASData,"^",5)  //排程出诊时段
	s ASStartTime=$p(DocCureASData,"^",6)  //开始时间
	s ASEndTime=$p(DocCureASData,"^",7)  //结束时间
	
    s TimeRangeDesc=""
    if TimeRangeDr'=""{
	    s TimeRangeDesc=$P($G(^DHCDocCureRBCTimePeriodSet(TimeRangeDr)),"^",2)
	    s TimeRangeDesc=##class(User.DHCDocCureRBCTimePeriodSet).GetTranByDesc("DDCTSDesc",TimeRangeDesc,langid)
    }
	s ASStartTime=$zt(ASStartTime,2)
	s ASEndTime=$zt(ASEndTime,2)
	s ASDate=##class(websys.Conversions).DateLogicalToHtml(ASDate)
	
	s timeRangeData = $g(^DHCDocCureRBCResSchdule(RowId,"TR"))
    s timeRangeFlag = $p(timeRangeData, "^", 1)
    s TRNumStr = $p(timeRangeData, "^", 4)
    s TRInfoStr  = $p(timeRangeData, "^", 5)
	s TimePerid=""
	if TRNumStr'="",TRInfoStr'="",SeqNo'="" {
		s len=$l(TRNumStr,",")
		f i=1:1:len {
			s TRNum=$p(TRNumStr,",",i)
			s StNum=$p(TRNum,"-",1)
			s EdNum=$p(TRNum,"-",2)
			if SeqNo'<StNum,SeqNo'>EdNum {
				s TimePerid=$p(TRInfoStr,",",i)
				q
			}
		}
		s TimeRangeInfo=ASDate_" "_TimePerid_"("_TimeRangeDesc_")"
	}else{
		s TimeRangeInfo=ASDate_" "_ASStartTime_"-"_ASEndTime_"("_TimeRangeDesc_")"
	}
	q TimeRangeInfo
}

}
