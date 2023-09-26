Class web.DHCCM.EMRservice.BL.PrintRecord Extends %RegisteredObject
{

/// Createdate: 2015-5-15
/// Desc:       创建病历打印记录 
/// Input：	    pIntanceId:实例ID
/// 		    pStartPageNum:起始页
/// 		    pStartRowNum:起始行号
/// 		    pEndPageNum:结束页
/// 		    pEndRowNum:结束行号
/// Return：    result 0:失败  成功:rowID
/// Debug：     w ##class(EMRservice.BL.PrintRecord).CreatePrintRecord("24||2","1","1","1","45")
ClassMethod CreatePrintRecord(pIntanceId As %String, pStartPageNum As %String, pStartRowNum As %String, pEndPageNum As %String, pEndRowNum As %String) As %String
{
	s result = 0
	q:(pIntanceId = "") result
	s ecrecordId = $p(pIntanceId,"||",1)
	s objEcrecord = ##Class(User.DHCPHECRecord).%OpenId(ecrecordId)
	q:(objEcrecord = "") result
	s objInstanceData = ##Class(User.DHCPHInstanceData).%OpenId(pIntanceId)
	q:(objInstanceData = "") result
	s instancePrintRecord = ##class(User.DHCPHInstancePrintRecord).%New()
	//ContinuePrint,是否续打
	s instancePrintRecord.ContinuePrint = ""
	s instancePrintRecord.CreateDate = objInstanceData.CreateDate
	s instancePrintRecord.CreateTime = objInstanceData.CreateTime
	s instancePrintRecord.CreateUserID = objInstanceData.CreateUser
	s instancePrintRecord.ECRecordID = ecrecordId
	s instancePrintRecord.ECRSeq = objInstanceData.ListNo
	s instancePrintRecord.EndPageNum = pEndPageNum
	s instancePrintRecord.EndRowNum = pEndRowNum
	s instancePrintRecord.InstanceDataID = pIntanceId
	//LastRowProperty,末行属性
	s instancePrintRecord.LastRowProperty = ""
	s instancePrintRecord.PrintStatus = "Printed"
	s instancePrintRecord.PrintTemplateID = objInstanceData.TemplateID
	s instancePrintRecord.PrintTemplateVersion = objInstanceData.TemplateVersion
	s instancePrintRecord.PrintType = objEcrecord.CategoryType
	s instancePrintRecord.StartPageNum = pStartPageNum
	s instancePrintRecord.StartRowNum = pStartRowNum
	s instancePrintRecord.UpdateDate = objInstanceData.ModifyDate
	s instancePrintRecord.UpdateTime = objInstanceData.ModifyTime
	s instancePrintRecord.UpdateUserID = objInstanceData.ModifyUser
	s $zt = "PrintRecordErrorHandler"
	Tstart
	s sc = instancePrintRecord.%Save()
	if ($$$ISOK(sc))
	{
		TCOMMIT
		s result = instancePrintRecord.%Id()
	}else
	{
		Trollback
	}
	k instancePrintRecord
	quit result
	 
PrintRecordErrorHandler
    Trollback
    quit:result
}

}
