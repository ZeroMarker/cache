/// 名称: DHCMed.DCEns.LIS.TSResultByWS
/// 描述: 检验结果服务类
/// 编写者：zhufei
/// 编写日期: 2016-03-04
Class DHCMed.DCEns.LIS.TSResultByWS Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2016-03-04
/// Description:  保存检验结果
/// Table：       DHCMed.DC.LIS.LabTestSet  检验医嘱/送检记录
///              DHCMed.DC.LIS.LabReport   检验报告
///              DHCMed.DC.LIS.LabResult   检验结果
/// Input：       InputStream：检验结果XML数据流
/// Return：      返回值return>0:成功，return<=0:失败
/// w ##class(DHCMed.DCEns.LIS.TSResultByWS).SaveTSResult()
ClassMethod SaveTSResult(xmlStream As %GlobalCharacterStream, aHospCode As %String = "LIS01") As %String
{
	New (xmlStream,aHospCode)
	Set reutrn=0
	Quit:xmlStream="" return
	Quit:aHospCode="" return
	
	Set $ZT="SaveTSResultErr"
	
	//输入数据保存下来
	Set flg=##Class(DHCMed.DC.StreamData).Update("检验结果回传WS接口","##class(DHCMed.DCEns.LIS.TSResultByWS).SaveTSResult(xmlStream)",$j,xmlStream)
	
	//XML数据流转换为对象
	Set obj=..GetObjectByXML(xmlStream)
	Quit:'$IsObject(obj) return
	
	Set TestSetRow = obj.TestSetRow   //检验报告ID
	Quit:TestSetRow="" return
	Set TestSetNo = TestSetRow
	Set OrderNo = obj.OrderNo //报告序号
	Set HospCode = obj.HospCode  //医院行政编码
	Set EpisodeNo = obj.EpisodeNo //检验号
	Set TestSetCode = obj.TestSetCode //检验医嘱代码
	Set TestSetDesc = obj.TestSetDesc //检验医嘱名称
	Set TestSetDR=##Class(DHCMed.DC.LIS.BTTestSet).GetIDByCodeDesc(TestSetCode,TestSetDesc)
	Set SpecimenCode = obj.SpecimenCode //标本代码
	Set SpecimenDesc = obj.SpecimenDesc //标本名称
	Set SpecimenDR=##Class(DHCMed.DC.LIS.BTSpecimen).GetIDByCodeDesc(SpecimenCode,SpecimenDesc)
	Set LocationCode = obj.LocationCode //申请科室代码
	Set LocationDesc = obj.LocationDesc //申请科室名称
	Set LocationDR=##Class(DHCMed.DC.BTLoc).GetIDByCodeDesc(LocationCode,LocationDesc,aHospCode)
	Set PCollectDateTime = obj.CollectDateTime //采集日期时间
	Set CollectUser = obj.CollectUser //采集者
	Set PReceiveDateTime = obj.ReceiveDateTime //接收日期时间
	Set ReceiveUser = obj.ReceiveUser //接收者
	Set AuthDateTime = obj.AuthDateTime //审核日期时间
	Set AuthUser = obj.AuthUser //审核者
	Set IsActive = obj.IsActive //是否有效（1有效、0无效）
	Set TSResultInfo = obj.TSResultInfo  //检验项目结果
	
	Set return="-1^保存检验医嘱错误"
	Set InputStr=EpisodeNo
	Set InputStr=InputStr_"^"_TestSetRow
	Set InputStr=InputStr_"^"_TestSetNo
	Set InputStr=InputStr_"^"_TestSetDR
	Set InputStr=InputStr_"^"_SpecimenDR
	Set InputStr=InputStr_"^"_LocationDR
	Set InputStr=InputStr_"^"_CollectDate
	Set InputStr=InputStr_"^"_CollectTime
	Set InputStr=InputStr_"^"_CollectUser
	Set InputStr=InputStr_"^"_ReceiveDate
	Set InputStr=InputStr_"^"_ReceiveTime
	Set InputStr=InputStr_"^"_ReceiveUser
	Set InputStr=InputStr_"^"_IsActive
	Set flg=##class(DHCMed.DC.LIS.LabTestSet).Update(InputStr)
	Quit:(+flg)<1 return
	Set return=flg
	
	Set return="-2^保存检验报告错误"
	Set InputStr=TestSetNo
	Set InputStr=InputStr_"^"_OrderNo
	Set InputStr=InputStr_"^"_TestSetNo_"||"_OrderNo
	Set InputStr=InputStr_"^"_TestSetDR
	Set InputStr=InputStr_"^"_SpecimenDR
	Set InputStr=InputStr_"^"_LocationDR
	Set InputStr=InputStr_"^"_CollectDate
	Set InputStr=InputStr_"^"_CollectTime
	Set InputStr=InputStr_"^"_CollectUser
	Set InputStr=InputStr_"^"_ReceiveDate
	Set InputStr=InputStr_"^"_ReceiveTime
	Set InputStr=InputStr_"^"_ReceiveUser
	Set InputStr=InputStr_"^"_AuthDate
	Set InputStr=InputStr_"^"_AuthTime
	Set InputStr=InputStr_"^"_AuthUser
	Set InputStr=InputStr_"^"_IsActive
	Set flg=##class(DHCMed.DC.LIS.LabReport).Update(InputStr)
	Quit:(+flg)<1 return
	Set LabReportID=flg
	
	Set return="-3^保存检验结果错误"
	Set isError=0
	Set TSRCount=TSResultInfo.Count()
	For indTSR=1:1:TSRCount {
		Quit:isError>0
		Set objTSResult=TSResultInfo.GetAt(indTSR)
		Continue:'$IsObject(objTSResult)
		
		Set TestCodeCode = objTSResult.TestCodeCode // 检测项目代码
		Set TestCodeDesc = objTSResult.TestCodeDesc // 检测项目名称
		Set TestCodeDR=##Class(DHCMed.DC.LIS.BTTestCode).GetIDByCodeDesc(TestCodeCode,TestCodeDesc)
		Set ResultFormat = objTSResult.ResultFormat //检测结果类型
		Set Result = objTSResult.Result //结果
		Set TextRes = objTSResult.TextRes //定性结果
		Set ResNoes = objTSResult.ResNoes //结果说明(细菌备注)
		Set AbFlag = objTSResult.AbFlag //异常提示
		Set Unit = objTSResult.Unit //单位
		Set RefRanges = objTSResult.RefRanges //参考范围
		Set MultipleResistant = objTSResult.MultipleResistant //多耐菌标注
		Set TSRSenInfo = objTSResult.TSRSenInfo //药敏结果
		
		Set InputStr=TestSetNo_"||"_OrderNo
		Set InputStr=InputStr_"^"_TestCodeDR
		Set InputStr=InputStr_"^"_ResultFormat
		Set InputStr=InputStr_"^"_Result
		Set InputStr=InputStr_"^"_TextRes
		Set InputStr=InputStr_"^"_ResNoes
		Set InputStr=InputStr_"^"_AbFlag
		Set InputStr=InputStr_"^"_Unit
		Set InputStr=InputStr_"^"_RefRanges
		Set InputStr=InputStr_"^"_MultipleResistant
		Set flg=##class(DHCMed.DC.LIS.LabResult).Update(InputStr)
		If (+flg)<1 {
			Set isError=1
			Quit
		}
		Set LabResultID=flg
		
		Set TSRSCount=TSRSenInfo.Count()
		For indTSRS=1:1:TSRSCount {
			Quit:isError>0
			Set objTSRSen=TSRSenInfo.GetAt(indTSRS)
			Continue:'$IsObject(objTSRSen)
			
			Set AntibioticsCode = objTSRSen.AntibioticsCode //抗生素代码
			Set AntibioticsDesc = objTSRSen.AntibioticsDesc //抗生素名称
			Set SensitivityCode = objTSRSen.SensitivityCode //药敏结果代码
			Set SensitivityDesc = objTSRSen.SensitivityDesc //药敏结果名称
			Set AntibioticsDR=##Class(DHCMed.DC.LIS.BTAntibiotics).GetIDByCodeDesc(AntibioticsCode,AntibioticsDesc)
			Set SensitivityDR=##Class(DHCMed.DC.LIS.BTSensitivity).GetIDByCodeDesc(SensitivityCode,SensitivityDesc)
			
			Set InputStr=LabResultID
			Set InputStr=InputStr_"^"_AntibioticsDR
			Set InputStr=InputStr_"^"_SensitivityDR
			Set flg=##class(DHCMed.DCEns.LIS.TSResultSen).Update(InputStr)
			If (+flg)<1 {
				Set isError=1
				Quit
			}
		}
	}
	Quit:isError>0 return
	
	Set return=LabReportID
	Quit return
	
SaveTSResultErr
	Quit return
}

ClassMethod GetObjectByXML(xmlStream As %GlobalCharacterStream) As DHCMed.DCEns.LIS.LabReport
{
	New (xmlStream)
	Set return=""
	Quit:xmlStream="" return
	
	Set reader = ##class(%XML.Reader).%New()
	Set sc= reader.OpenStream(xmlStream)
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit return
	Do reader.Correlate("TSReport","DHCMed.DCEns.LIS.LabReport")
	While reader.Next(.object,.sc) {
		Set return=object
	}
	Do reader.%Close()
	
	Quit return
}

}
