Import SQLUser

Class web.DHCICUPrintRecord Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod SavePrintRecord(printRecordPara As %String) As %String
{
	s printRecordId=$p(printRecordPara,$c(3),1)
	s icuaId=$p(printRecordPara,$c(3),2)
	s printRecordObj=""
	i printRecordId="" s printRecordObj=##class(User.DHCICUPrintRecord).%New(icuaId)
	e  s printRecordObj=##class(User.DHCICUPrintRecord).%OpenId(printRecordId)
	s printRecordObj.ICUPRParref=##class(User.DHCICUArrange).%OpenId(icuaId)
	s printRecordObj.ICUPRDate=##class(web.DHCClinicCom).ConvertToDateH($p(printRecordPara,$c(3),3))
	s printRecordObj.ICUPRTime=##class(web.DHCClinicCom).ConvertToTimeH($p(printRecordPara,$c(3),4))
	s printRecordObj.ICUPRDateTimeSeq=+$p(printRecordPara,$c(3),5)
	s printRecordObj.ICUPRPage=+$p(printRecordPara,$c(3),6)
	s printRecordObj.ICUPRPageRow=+$p(printRecordPara,$c(3),7)
	s printRecordObj.ICUPRPrintUserDr=$p(printRecordPara,$c(3),8)
	s printRecordObj.ICUPRPrintDate=##class(web.DHCClinicCom).ConvertToDateH($p(printRecordPara,$c(3),9))
	s printRecordObj.ICUPRPrintTime=##class(web.DHCClinicCom).ConvertToTimeH($p(printRecordPara,$c(3),10))
	s printRecordObj.ICUPREndDate=##class(web.DHCClinicCom).ConvertToDateH($p(printRecordPara,$c(3),11))
	s printRecordObj.ICUPREndTime=##class(web.DHCClinicCom).ConvertToDateH($p(printRecordPara,$c(3),12))
	d printRecordObj.%Save()
	s result=printRecordObj.%Id()
	d printRecordObj.%Close()
	q result
}

Query GetAllPrintInfo(icuaId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select %ID as Id,
		   ICUPR_Date as StartDate,
		   ICUPR_Time as StartTime,
		   ICUPR_EndDate as EndDate,
		   ICUPR_EndTime as EndTime,
		   ICUPR_PrintDate as PrintDate,
		   ICUPR_PrintTime as PrintTime,
		   ICUPR_PrintUser_Dr as PrintUserId,
		   ICUPR_Parref as Parref
		   from DHC_ICU_PrintRecord
		   where ICUPR_Parref=:icuaId
}

ClassMethod DeletePrintInfo(printInfoId As %String) As %String
{
	q:printInfoId="" "打印记录的ID不能为空"
	s delStatus=##class(User.DHCICUPrintRecord).%DeleteId(printInfoId)
	q:(+delStatus=0) "数据删除失败"
	q 0
}

}
