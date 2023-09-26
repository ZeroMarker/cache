Class DHCEPRFS.BL.BLMRPrintInvoice Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	保存打印发票信息
/// Input：	AMRPrintChargeID 	打印收费ID
/// 		AInvoiceNo 	发票号
/// 			AActDate	操作日期
/// 			AActTime	操作时间	
/// 			AActUserID	操作员ID
/// Output: String 成功返回ID，否则返回空
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRPrintCharge","GetPrintChargeGpByUser","2015-11-30","2015-11-30")
ClassMethod AddInvoice(AMRPrintChargeID As %String, AInvoiceNo As %String, AActDate As %Date, AActTime As %Time, AActUserID As %String) As %String
{
	s objMRPrintInvoice=##class(DHCEPRFS.INST.MRPrintInvoice).%New()
	
	s objMRPrintInvoice.MRPrintChargeID=AMRPrintChargeID
	s objMRPrintInvoice.InvoiceNO=AInvoiceNo
	s objMRPrintInvoice.ActDate=AActDate
	s objMRPrintInvoice.ActTime=AActTime
	s objMRPrintInvoice.ActUserID=AActUserID
	s objMRPrintInvoice.CancelFlag="0"
	s objMRPrintInvoice.CancelReason=""
	
	s sc=objMRPrintInvoice.%Save()
	if ($$$ISERR(sc))
	{
		q ""
	}
	else
	{
		q objMRPrintInvoice.%Id()
	}
}

/// Desc:	重打发票:作废原发票，新增新发票
/// Input：	AMRPrintChargeID 	打印收费ID
/// 			ACancelReason	取消原因
/// 		ANewInvoiceNo 	发票号
/// 			AActUserID	操作员ID
/// Output: String 成功返回ID，否则返回空
/// Debug：	w ##class(DHCEPRFS.BL.MRPrintInvoice).RePrintInvoice("151","2","159")
ClassMethod RePrintInvoice(AMRPrintChargeID As %String, ANewInvoiceNo As %String, AActUserID As %String) As %String
{
	//取当前时间
	s now = $h
	s nowDate = $p(now,",",1)
	s nowTime = $p(now,",",2)
	
	s LastPrintInvoiceID=..GetMRPrintChargeLastInvoiceID(AMRPrintChargeID)	//取得正常的InvoiceID
	
	if (LastPrintInvoiceID="")
	{
		q ""
	}
	TSTART	//开始事务
	s $zt = "OnRePrintInvoiceErrorHandler"
	s objOldMRPrintInvoice=##class(DHCEPRFS.INST.MRPrintInvoice).%OpenId(LastPrintInvoiceID)
	
	s objOldMRPrintInvoice.CancelFlag="1"
	s objOldMRPrintInvoice.CancelReason="重打作废"
	s sc=objOldMRPrintInvoice.%Save()
	if ($$$ISERR(sc))
	{
		TROLLBACK
		q ""	
	}
	
	s objMRPrintInvoice=##class(DHCEPRFS.INST.MRPrintInvoice).%New()
	s objMRPrintInvoice.MRPrintChargeID=AMRPrintChargeID
	s objMRPrintInvoice.InvoiceNO=ANewInvoiceNo
	s objMRPrintInvoice.ActDate=nowDate
	s objMRPrintInvoice.ActTime=nowTime
	s objMRPrintInvoice.ActUserID=AActUserID
	s objMRPrintInvoice.CancelFlag="0"
	s objMRPrintInvoice.CancelReason=""
	
	s sc=objMRPrintInvoice.%Save()
	if ($$$ISERR(sc))
	{
		TROLLBACK
		q ""
	}
	else
	{
		TCOMMIT
		q objMRPrintInvoice.%Id()
	}
OnRePrintInvoiceErrorHandler
	TROLLBACK
	q ""
}

/// Desc:	作废发票
/// Input：	AMRPrintChargeID 	打印收费ID
/// 			ACancelReason	取消原因
/// 		ANewInvoiceNo 	发票号
/// 			AActUserID	操作员ID
/// Output: String 成功返回"1"，否则返回"0"
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRPrintCharge","GetPrintChargeGpByUser","2015-11-30","2015-11-30")
ClassMethod CancelInvoice(AMRPrintChargeID As %String, ACancelReason As %String, AActUserID As %String) As %String
{
	//取当前时间
	s now = $h
	s nowDate = $p(now,",",1)
	s nowTime = $p(now,",",2)
	
	s LastPrintInvoiceID=..GetMRPrintChargeLastInvoiceID(AMRPrintChargeID)	//取得正常的InvoiceID
	
	if (LastPrintInvoiceID="")
	{
		q "0"
	}
	s objOldMRPrintInvoice=##class(DHCEPRFS.INST.MRPrintInvoice).%OpenId(LastPrintInvoiceID)
	
	s objOldMRPrintInvoice.CancelFlag="1"
	s objOldMRPrintInvoice.CancelReason=ACancelReason
	s sc=objOldMRPrintInvoice.%Save()
	if ($$$ISERR(sc))
	{
		q "0"	
	}
	else
	{
		q "1"	
	}
}

/// Desc:	获取指定PrintChargeID对应的有效发票ID
/// Input：	AMRPrintChargeID 	打印收费ID
/// Output: String 成功返回PrintInvoiceID，否则返回空
/// Debug: w ##class(DHCEPRFS.BL.MRPrintInvoice).GetMRPrintChargeLastInvoiceID("151")
ClassMethod GetMRPrintChargeLastInvoiceID(AMRPrintChargeID As %String) As %String
{
	s LastPrintInvoiceID=""
	s MRPrintInvoiceID=""
	for {
		s MRPrintInvoiceID=$o(^DHCEPRFS.INST.MRPrintInvoiceI("IdxMRPrintChargeID"," "_AMRPrintChargeID,MRPrintInvoiceID))
		q:(MRPrintInvoiceID="")
		s objMRPrintInvoice=##class(DHCEPRFS.INST.MRPrintInvoice).%OpenId(MRPrintInvoiceID)
		if (objMRPrintInvoice.CancelFlag="0")
		{
			s LastPrintInvoiceID=objMRPrintInvoice.%Id()
			q
		}
	}
	q LastPrintInvoiceID
}

/// Desc:	获取指定PrintChargeID对应的最后的发票号（补打取最后的，作废亦取最后一笔）
/// Input：	AMRPrintChargeID 	打印收费ID
/// Output: String 成功返回PrintInvoiceNo，否则返回空
/// Debug: 
ClassMethod GetMRPrintChargeLastInvoiceNo(AMRPrintChargeID As %String) As %String
{
	s LastPrintInvoiceNo=""
	s MRPrintInvoiceID=""
	for {
		s MRPrintInvoiceID=$o(^DHCEPRFS.INST.MRPrintInvoiceI("IdxMRPrintChargeID"," "_AMRPrintChargeID,MRPrintInvoiceID))
		q:(MRPrintInvoiceID="")
		s objMRPrintInvoice=##class(DHCEPRFS.INST.MRPrintInvoice).%OpenId(MRPrintInvoiceID)
		s LastPrintInvoiceNo=objMRPrintInvoice.InvoiceNO
	}
	q LastPrintInvoiceNo
}

}
