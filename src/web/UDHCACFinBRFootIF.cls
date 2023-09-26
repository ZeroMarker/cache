Class web.UDHCACFinBRFootIF Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 在账户总账增加一个类型标志用来存储按照不同的时间段加工好的数据
/// 分类：
/// 1.按照缴预交金时间统计   web.UDHCACFinBRFoot0PD
/// 2.按照操作员日报时间统计 web.UDHCACFinBRFoot0
/// 3.按照财务接收时间统计   web.UDHCACFinBRFoot1
/// ***********************************************************
/// 本接口的任务就是根据需要进行 “配置”
/// ***********************************************************
/// 隐含功能是否按照按照时间短类查找数据
/// 结算账户预交金和消费信息
/// 操作用户
/// 界面显示的结算信息
/// 扩展信息
/// w ##class(web.UDHCACFinBRFootIF).ACFinDataFoot(1,"^^26/05/2006^18:22:04^1^05/03/2006^16:06:10^0.00^25896450424403.00^1156.30^749843.70^-25896449673403.00","")
ClassMethod ACFinDataFoot(FootUserDR As %String, ACFInfo As %String, ExpStr As %String) As %String
{
	n (FootUserDR, ACFInfo, ExpStr)
	s myVer=##class(web.DHCOPConfig).GetVersion()
	s myrtn=""
	if (+myVer=0){
		;s myrtn=##class(web.UDHCACFinBRFoot0).ACFinDataFoot(FootUserDR, ACFInfo, ExpStr)
		s myrtn=##class(web.UDHCACFinBRFoot0PD).ACFinDataFoot(FootUserDR, ACFInfo, ExpStr)
	}elseif (+myVer=1){
		;s myrtn=##class(web.UDHCACFinBRFoot1).ACFinDataFoot(FootUserDR, ACFInfo, ExpStr)
		s myrtn=##class(web.UDHCACFinBRFoot0PD).ACFinDataFoot(FootUserDR, ACFInfo, ExpStr)
	}else{
		s myrtn=##class(web.UDHCACFinBRFoot0PD).ACFinDataFoot(FootUserDR, ACFInfo, ExpStr)
	}
	q myrtn
}

/// w ##class(web.UDHCACFinBRFootIF).AutoGetDT(BDate, BTime, ExpStr)
ClassMethod AutoGetDT(BDate As %String, BTime As %String, ExpStr As %String) As %String
{
	n (BDate, BTime, ExpStr)

	s myrtn=""
	
	;自动获取不同的时间段
	s myVer=##class(web.DHCOPConfig).GetVersion()
	if (+myVer=0){
		;积水潭自动按照0-0点提取数据
		;s myrtn=##class(web.UDHCACFinBRFoot0).AutoGetDT(BDate, BTime, ExpStr)
		s myrtn=##class(web.UDHCACFinBRFoot0PD).AutoGetDT(BDate, BTime, ExpStr)
	}else{
		;s myrtn=##class(web.UDHCACFinBRFoot1).AutoGetDT(BDate, BTime, ExpStr)
		s myrtn=##class(web.UDHCACFinBRFoot0PD).AutoGetDT(BDate, BTime, ExpStr)
	}
	
	q myrtn
}

/// 得到一个开始和结束日期
/// 获取方式：
/// 在表DHC_AccFoot表中
/// w ##class(web.UDHCACFinBRFootIF).GetDate("")
ClassMethod GetDate(ExpStr As %String = "") As %String
{
	s myrtn=""
	s myVer=##class(web.DHCOPConfig).GetVersion()
	
	if (+myVer=0){
		;s myrtn=##class(web.UDHCACFinBRFoot0).GetDate()
		s myrtn=##class(web.UDHCACFinBRFoot0PD).GetDate()
	}elseif (+myVer=1){
		;s myrtn=##class(web.UDHCACFinBRFoot1).GetDate()
		s myrtn=##class(web.UDHCACFinBRFoot0PD).GetDate()
	}else{
		s myrtn=##class(web.UDHCACFinBRFoot0PD).GetDate()
	}
	
	q myrtn
}

/// 查询未结算的帐户预交金和消费信息
/// w ##class(web.UDHCACFinBRFootIF).ReadACFinData("")
ClassMethod ReadACFinData(myExpStr As %String = "") As %String
{
	n (ExpStr)
	
	s myVer=##class(web.DHCOPConfig).GetVersion()
	s myrtn=""
	if (+myVer=0){
		;s myrtn=##class(web.UDHCACFinBRFoot0).ReadACFinData()
		s myrtn=##class(web.UDHCACFinBRFoot0PD).ReadACFinData()
	}elseif (+myVer=1){
		;s myrtn=##class(web.UDHCACFinBRFoot1).ReadACFinData()
		s myrtn=##class(web.UDHCACFinBRFoot0PD).ReadACFinData()
	}else{
		s myrtn=##class(web.UDHCACFinBRFoot0PD).ReadACFinData()
	}
	
	q myrtn
}

ClassMethod ReadFBRAccPayList(BDate As %String, BTime As %String, EndDate As %String, EndTime As %String, HospId As %String) As %String
{
	n (BDate, BTime, EndDate, EndTime, HospId)
	
	//s myrtn=##class(web.UDHCACFinBRFoot1).ReadFBRAccPayList(BDate, BTime, EndDate, EndTime)
	s myrtn=##class(web.UDHCACFinBRFoot0PD).ReadFBRAccPayList(BDate, BTime, EndDate, EndTime, HospId)
	
	q myrtn
}

/// 操作员上缴额的财务结算预交金,期间数据发生额
ClassMethod ReadFBRAccPreDList(BDate As %String, BTime As %String, EndDate As %String, EndTime As %String, HospId As %String) As %String
{
	n (BDate, BTime, EndDate, EndTime, HospId)
	
	//s myrtn=##class(web.UDHCACFinBRFoot1).ReadFBRAccPreDList(BDate, BTime, EndDate, EndTime)
	s myrtn=##class(web.UDHCACFinBRFoot0PD).ReadFBRAccPreDList(BDate, BTime, EndDate, EndTime, HospId)
	
	q myrtn
}

/// w ##class(web.UDHCACFinBRFootIF).BulidAccQFList(ExpStr)
ClassMethod BulidAccQFList(ExpStr As %String) As %String
{
	n (ExpStr)
	s myrtn=##class(web.UDHCACFinBRFoot0PD).BulidAccQFList(ExpStr)
	q myrtn
}

}
