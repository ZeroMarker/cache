Class EMRservice.InterfaceService.WebHospInterface Extends %RegisteredObject
{

/// 互联网医院推送数据服务
/// 入参数据XML
/// 返回值：生成结果信息
ClassMethod RegOPXml(xmlRequest) As %String
{
	q ##class(EMRinstance.SDOPRecord).RegXml(xmlRequest)
}

ClassMethod GetOPXml(xmlRequest) As %String
{
	q ##class(EMRinstance.SDOPRecord).GetXml(xmlRequest)
}

ClassMethod DelOPXml(xmlRequest) As %String
{
	q ##class(EMRinstance.SDOPRecord).DelXml(xmlRequest)
}

/// 测试病历生成
/// w ##class(EMRservice.InterfaceService.WebHospInterface).DebuggerRegOPXML()
ClassMethod DebuggerRegOPXML() As %String
{
	s requestXML = "<Request>"
	s requestXML = requestXML_"<EpisodeID>37919624</EpisodeID>"
	s requestXML = requestXML_"<DataSource>OL</DataSource>"
	s requestXML = requestXML_"<UserID>3730</UserID>"
	s requestXML = requestXML_"<UserName>朱卫国</UserName>"
	s requestXML = requestXML_"<Action>save</Action>"
	//s requestXML = requestXML_"<Action>sign</Action>"
	s requestXML = requestXML_"<UsrCertCode></UsrCertCode>"
	s requestXML = requestXML_"<Token></Token>"
	s requestXML = requestXML_"<CertNo></CertNo>"
	s requestXML = requestXML_"<ContainerName></ContainerName>"
	s requestXML = requestXML_"<MainSuit>主诉内容测试内容</MainSuit>"
	s requestXML = requestXML_"<PresentIllness>现病史测试内容</PresentIllness>"
	s requestXML = requestXML_"<PastHistory>既往史测试内容</PastHistory>"
	s requestXML = requestXML_"<PhyExam>体格检查测试内容</PhyExam>"
	s requestXML = requestXML_"<AssistExam>辅助检查测试内容</AssistExam>"
	s requestXML = requestXML_"<AllergyHistory>过敏史测试内容</AllergyHistory>"
	s requestXML = requestXML_"<MenstrualHistory>月经史测试内容</MenstrualHistory>"
	s requestXML = requestXML_"<BPInfo>血压脉搏信息测试内容</BPInfo>"
	s requestXML = requestXML_"<Treatment>治疗处置、医嘱与用药测试内容</Treatment>"
	s requestXML = requestXML_"<Diagnos>诊断测试内容</Diagnos>"
	s requestXML = requestXML_"<Suggest>治疗建议测试内容</Suggest>"
	s requestXML = requestXML_"<DiseaseProgress>病情变化与处置测试内容</DiseaseProgress>"
	s requestXML = requestXML_"<DoctorUserID>3730</DoctorUserID>"
	s requestXML = requestXML_"<DoctorUserName>朱卫国</DoctorUserName>"
	s requestXML = requestXML_"<RecordDate>2022-08-17</RecordDate>"
	s requestXML = requestXML_"</Request>"
	s result = ..RegOPXml(requestXML)
	q result
}

}
