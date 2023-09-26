Class web.udhcOPFinBalanceIF Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 61;

/// //根据操作员结算的日报， 完成数据输出，输出方式：
/// //1. 结算的数据
/// //2. 没有结算的数据
ClassMethod DelPRTTMPData(TMPGID As %String) As %String
{
	n (TMPGID)
	i TMPGID'="" d
	.k ^TMPOPPrintOut(TMPGID)
	
	q 0
}

ClassMethod GetFinFootData(BeginDate As %String = "", EndDate As %String = "", sFlag As %String, ExpStr As %String) As %String
{
	n (BeginDate,EndDate, sFlag, ExpStr)
	;生成不同的^TMP主要为Item
	s myrtn=0
	s myVer=##class(web.DHCOPConfig).GetVersion()
	
	if (+myVer=0){
		
	}elseif(+myVer=1){
		if (sFlag="INVItem"){
			s myrtn=##class(web.udhcOPFinBalance1).GetFinFootData(BeginDate,EndDate)
		}elseif(sFlag="AItem"){
			s myrtn=##class(web.udhcOPFinBalance1).GetFinFootData(BeginDate,EndDate)
		}
	}elseif(+myVer=4){
		
	}elseif(+myVer=7){
		
	}else{
		
	}
}

ClassMethod GetRegFinFootData(BDate As %String = "", EDate As %String = "", sFlag As %String, ExpStr As %String) As %String
{
	n (BDate, EDate, sFlag, ExpStr)
	;此函数判断是否加入挂号即可；及怎么加入
	
	s myVer=##class(web.DHCOPConfig).GetVersion()
	
	if (+myVer=6){
		s myrtn=##class(web.udhcOPFinBalance6).GetRegFinFootData(BDate, EDate)
	}
	
	q 0
}

ClassMethod GetDate() As %String
{
	;w ##class(web.udhcOPFinBalanceIF).GetDate()
	s myrtn=0
	s myVer=##class(web.DHCOPConfig).GetVersion()
	
	if (+myVer=0){
		
	}elseif(+myVer=1){
		
	}elseif(+myVer=7){
		
	}else{
		
	}
}

ClassMethod GetUFDataForFin(UserRowID As %String, StDate As %String, StTime As %String, EndDate As %String, EndTime As %String) As %String
{
	;专门为财务结算界面提供, 操作员没有办理过结算的数据生成一个TMP
	;^TMPUserFootData($j)
	;只在积水潭医院使用
	;其他的地方不能使用；
	n (UserRowID , StDate , StTime , EndDate , EndTime)
	
	s myrtn=0
	s myVer=##class(web.DHCOPConfig).GetVersion()
	
	if (+myVer=0){
		s myrtn=##class(web.udhcOPFinBalance).GetUFDataForFin(UserRowID , StDate , StTime , EndDate , EndTime)
	}elseif(+myVer=1){
		
	}
	else{
		
	}
	
	q myrtn
}

ClassMethod ReadPRTTMPData(TMPGID As %String, Index As %String) As %String
{
	n (TMPGID, Index)
	
	;w ##class(web.udhcOPFinBalanceIF).ReadPRTTMPData("3","")
	s myData=""
	i TMPGID'="" d
	.s myIdx=$o(^TMPOPPrintOut(TMPGID,Index))
	.i myIdx'="" d
	..s myData=myIdx_"^"_$g(^TMPOPPrintOut(TMPGID,myIdx))
	
	q myData
}

ClassMethod ReadFootSum(BDate As %String = "", EDate As %String = "", ExpStr As %String) As %String
{
	n (BDate,EDate, ExpStr)
	;w ##class(web.udhcOPFinBalanceIF).ReadFootSum("12/11/2006","14/11/2006","")
	
	s myVer=##class(web.DHCOPConfig).GetVersion()
	s myrtn=""
	b	;;;
	if (+myVer=0){
		
	}elseif(+myVer=4){
		s myrtn=##class(web.udhcOPFinBalance4).ReadFootSum(BDate, EDate)
	}elseif(+myVer=6){
		s myrtn=##class(web.udhcOPFinBalance6).ReadFootSum(BDate, EDate)
	}else{
		
	}
	
	q myrtn
}

/// 使用报表的RowID获取本报表的其他信息，包含： 支付模式子表,折扣优惠子表
ClassMethod ReadINVRepsSubInfo(RepsRowID As %String, ExpStr As %String) As %String
{
	;
	n (RepsRowID,ExpStr)
	s myrtn=""
	
	s myVer=##class(web.DHCOPConfig).GetVersion()
	if (+myVer=0){
		s myrtn=##class(web.udhcOPFinBalance).ReadINVRepsSubInfo(RepsRowID)
	}elseif(+myVer=4){
		
	}
	q myrtn
}

/// / 按照操作员来办理财务结算 这个时间段内的报表
ClassMethod UpdateRepForINS(UserRowID As %String = "", INSFUDR As %String, StDate As %String, StTime As %String, EndDate As %String, EndTime As %String) As %String
{
	n (UserRowID, INSFUDR, StDate, StTime, EndDate, EndTime)
	;财务更新结算
	s myrtn=0
	
	s myVer=##class(web.DHCOPConfig).GetVersion()
	s myrtn=##class(web.udhcOPFinBalance1).UpdateRepForINS(UserRowID, INSFUDR, StDate, StTime, EndDate, EndTime)
	q myrtn
}

/// / 把这个时间段的所有报表办理财务结算
ClassMethod UpdateRepForINSAll(INSFUDR As %String, StDate As %String, StTime As %String, EndDate As %String, EndTime As %String, ExpStr As %String) As %String
{
	;w ##class(web.udhcOPFinBalanceIF).UpdateRepForINSAll("6", +$h, "", +$h, "", "")
	n (INSFUDR, StDate, StTime, EndDate, EndTime, ExpStr)
	s myVer=##class(web.DHCOPConfig).GetVersion()
	
	i StDate["-" d  s StDate=$zdh($g(StDate),3)
	i StDate["/" d  s StDate=$zdh($g(StDate),4)
	
	i EndDate["-" d  s EndDate=$zdh($g(EndDate),3)
	i EndDate["/" d  s EndDate=$zdh($g(EndDate),4)
	
	s myrtn=##class(web.udhcOPFinBalance7).UpdateRepForINSAll(INSFUDR, StDate, StTime, EndDate, EndTime)
	
	q myrtn
}

}
