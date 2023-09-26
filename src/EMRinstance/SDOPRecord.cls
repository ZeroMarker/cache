Class EMRinstance.SDOPRecord Extends %Persistent [ ProcedureBlock ]
{

/// Adm就诊号
Property EpisodeID As %String [ SqlColumnNumber = 2 ];

/// 数据来源：OP 门诊病历，OL 在线问诊
Property DataSource As %String [ SqlColumnNumber = 3 ];

/// 创建日期
Property CreateDate As %Date [ SqlColumnNumber = 4 ];

/// 创建时间
Property CreateTime As %Time [ SqlColumnNumber = 5 ];

/// 创建医师ID
Property CreateUserID As %String [ SqlColumnNumber = 6 ];

/// 创建医师姓名
Property CreateUserName As %String [ SqlColumnNumber = 7 ];

/// 创建日期
Property UpdateDate As %Date [ SqlColumnNumber = 8 ];

/// 创建时间
Property UpdateTime As %Time [ SqlColumnNumber = 9 ];

/// 创建医师ID
Property UpdateUserID As %String [ SqlColumnNumber = 10 ];

/// 创建医师姓名
Property UpdateUserName As %String [ SqlColumnNumber = 11 ];

/// 主诉
Property MainSuit As %String(MAXLEN = 999999, TRUNCATE = 0) [ SqlColumnNumber = 12 ];

/// 现病史
Property PresentIllness As %String(MAXLEN = 999999, TRUNCATE = 0) [ SqlColumnNumber = 13 ];

/// 既往史
Property PastHistory As %String(MAXLEN = 999999, TRUNCATE = 0) [ SqlColumnNumber = 14 ];

/// 体格检查
Property PhyExam As %String(MAXLEN = 999999, TRUNCATE = 0) [ SqlColumnNumber = 15 ];

/// 辅助检查
Property AssistExam As %String(MAXLEN = 999999, TRUNCATE = 0) [ SqlColumnNumber = 16 ];

/// 过敏史
Property AllergyHistory As %String(MAXLEN = 999999, TRUNCATE = 0) [ SqlColumnNumber = 17 ];

/// 月经史
Property MenstrualHistory As %String(MAXLEN = 999999, TRUNCATE = 0) [ SqlColumnNumber = 18 ];

/// 合并后的既往史
Property TotPastHistory As %String(MAXLEN = 999999, TRUNCATE = 0) [ SqlColumnNumber = 19 ];

/// BP信息：脉搏、血压信息
Property BPInfo As %String(MAXLEN = 999999, TRUNCATE = 0) [ SqlColumnNumber = 20 ];

/// 处置/处理信息
Property Treatment As %String(MAXLEN = 999999, TRUNCATE = 0) [ SqlColumnNumber = 21 ];

/// 诊断信息
Property Diagnos As %String(MAXLEN = 999999, TRUNCATE = 0) [ SqlColumnNumber = 22 ];

/// 治疗建议
Property Suggest As %String(MAXLEN = 999999, TRUNCATE = 0) [ SqlColumnNumber = 23 ];

/// 病情变化及处置
Property DiseaseProgress As %String(MAXLEN = 999999, TRUNCATE = 0) [ SqlColumnNumber = 24 ];

/// 接诊/签名医师ID
Property DoctorUserID As %String [ SqlColumnNumber = 25 ];

/// 接诊/签名医师姓名
Property DoctorUserName As %String [ SqlColumnNumber = 26 ];

/// 病历记录/病历签名日期
Property RecordDate As %String [ SqlColumnNumber = 27 ];

Index IdxEpisodeID On EpisodeID [ Unique ];

Index IdxCreateDT On (CreateDate, CreateTime);

Index IdxUpdateDT On (UpdateDate, UpdateTime);

/// Desc:	获取指定就诊ID的门诊病历信息或在线问诊病历信息
/// Input:	AEpisodeID 就诊id
/// Return:	xml字符串，格式如下
/// 			<Response>
/// 				<EpisodeID>10</EpisodeID>
/// 				<DataSource>OL</DataSource>
/// 				<UserID>2</UserID>
/// 				<UserName>ys01</UserName>
/// 				<MainSuit>主诉内容</MainSuit>
/// 				<PresentIllness>现病史</PresentIllness>
/// 				<PastHistory>既往史</PastHistory>
/// 				<PhyExam>体格检查</PhyExam>
/// 				<AssistExam>辅助检查</AssistExam>
/// 				<AllergyHistory>过敏史</AllergyHistory>
/// 				<MenstrualHistory>月经史</MenstrualHistory>
/// 				<BPInfo>血压脉搏信息</BPInfo>
/// 				<Treatment>治疗处置、医嘱与用药</Treatment>
/// 				<Diagnos>诊断</Diagnos>
/// 				<Suggest>治疗建议</Suggest>
/// 				<DiseaseProgress>病情变化与处置</DiseaseProgress>
/// 				<DoctorUserID>接诊或签名医师ID</DoctorUserID>
/// 				<DoctorUserName>接诊或签名医师姓名</DoctorUserName>
/// 				<RecordDate>病历记录或签名日期</RecordDate>
/// 			</Response>
/// Debug:	w ##Class(EMRinstance.SDOPRecord).GetXml("111111")
ClassMethod GetXml(episodeID As %String) As %String
{
	q:(episodeID = "") ""
	
	s rowID = ..GetID(episodeID)
	q:(rowID = "") ""
	s obj = ##class(EMRinstance.SDOPRecord).%OpenId(rowID)
	q:(rowID = "") ""
	
	s writer = ##class(%XML.Writer).%New()
	s sc = writer.OutputToString()
	//s writer.Charset="UTF-8"
	s sc = writer.RootElement("Response")
	d WriteElement("EpisodeID",episodeID)
	d WriteElement("MainSuit",obj.MainSuit)
	d WriteElement("PresentIllness",obj.PresentIllness)
	d WriteElement("PastHistory",obj.PastHistory)
	d WriteElement("PhyExam",obj.PhyExam)
	d WriteElement("AssistExam",obj.AssistExam)
	d WriteElement("AllergyHistory",obj.AllergyHistory)
	d WriteElement("MenstrualHistory",obj.MenstrualHistory)
	d WriteElement("BPInfo",obj.BPInfo)
	d WriteElement("Treatment",obj.Treatment)
	d WriteElement("Diagnos",obj.Diagnos)
	d WriteElement("Suggest",obj.Suggest)
	d WriteElement("DiseaseProgress",obj.DiseaseProgress)
	d WriteElement("DoctorUserID",obj.DoctorUserID)
	d WriteElement("DoctorUserName",obj.DoctorUserName)
	d WriteElement("RecordDate",obj.RecordDate)
	
	s sc = writer.EndRootElement()
	
	q writer.GetXMLString()

WriteElement(name,value)
	s sc = writer.Element(name)
	s sc = writer.WriteChars(value)
	s sc = writer.EndElement()
}

/// Desc:	注册门诊病历信息、注册在线问诊病历信息
/// Input:	xmlRequest 入参xml字符串，格式如下
/// 			<Request>
/// 				<EpisodeID>10</EpisodeID>
/// 				<DataSource>OL</DataSource>
/// 				<UserID>2</UserID>
/// 				<UserName>ys01</UserName>
/// 					<Action>save|sign</Action>
/// 					<UsrCertCode></UsrCertCode>
/// 					<Token></Token>
/// 					<CertNo></CertNo>
/// 				<MainSuit>主诉内容</MainSuit>
/// 				<PresentIllness>现病史</PresentIllness>
/// 				<PastHistory>既往史</PastHistory>
/// 				<PhyExam>体格检查</PhyExam>
/// 				<AssistExam>辅助检查</AssistExam>
/// 				<AllergyHistory>过敏史</AllergyHistory>
/// 				<MenstrualHistory>月经史</MenstrualHistory>
/// 				<BPInfo>血压脉搏信息</BPInfo>
/// 				<Treatment>治疗处置、医嘱与用药</Treatment>
/// 				<Diagnos>诊断</Diagnos>
/// 				<Suggest>治疗建议</Suggest>
/// 				<DiseaseProgress>病情变化与处置</DiseaseProgress>
/// 				<DoctorUserID>接诊或签名医师ID</DoctorUserID>
/// 				<DoctorUserName>接诊或签名医师姓名</DoctorUserName>
/// 				<RecordDate>病历记录或签名日期</RecordDate>
/// 			</Request>
/// Return: <Response><ResultCode>0</ResultCode><ResultContent>成功</ResultContent></Response>
ClassMethod RegXml(xmlRequest As %String) As %String
{
	///b "s"
	s $ztrap = "OnRegXmlError"
	
	s now = $h
	
	s arr = ..XmlToArray(xmlRequest)
	s EpisodeID = arr.GetAt("EpisodeID")
	s DataSource = arr.GetAt("DataSource")
	s UserID = arr.GetAt("UserID")
	s UserName = arr.GetAt("UserName")
	s Action = arr.GetAt("Action")
	//-------------增加数字签名所需要的相关信息	start	
	s UsrCertCode = arr.GetAt("UsrCertCode")
	s Token = arr.GetAt("Token")
	s certNo = arr.GetAt("CertNo")
	s ContainerName = arr.GetAt("ContainerName")
	
	//-------------增加数字签名所需要的相关信息	end
	s MainSuit = arr.GetAt("MainSuit")
	s PresentIllness = arr.GetAt("PresentIllness")
	s PastHistory = arr.GetAt("PastHistory")
	s PhyExam = arr.GetAt("PhyExam")
	s AssistExam = arr.GetAt("AssistExam")
	s AllergyHistory = arr.GetAt("AllergyHistory")
	s MenstrualHistory = arr.GetAt("MenstrualHistory")
	s BPInfo = arr.GetAt("BPInfo")
	s Treatment = arr.GetAt("Treatment")
	s Diagnos = arr.GetAt("Diagnos")
	s Suggest = arr.GetAt("Suggest")
	s DiseaseProgress = arr.GetAt("DiseaseProgress")
	s DoctorUserID = arr.GetAt("DoctorUserID")
	s DoctorUserName = arr.GetAt("DoctorUserName")
	s RecordDate = arr.GetAt("RecordDate")
	
	q:(EpisodeID = "") $$GenRetXml("-1","未指定就诊ID")
	
	s rowID = ..GetID(EpisodeID)
	if (rowID = "")
	{
		s obj = ##Class(EMRinstance.SDOPRecord).%New()
		s obj.CreateDate = $p(now,",",1)
		s obj.CreateTime = $p(now,",",2)
		s obj.CreateUserID = UserID
		s obj.CreateUserName = UserName
	}
	else
	{
		s obj = ##Class(EMRinstance.SDOPRecord).%OpenId(rowID)
	}
	q:(obj = "") $$GenRetXml("-1","创建门诊病历数据对象失败")
	
	q:(obj.DataSource '= "")&&(obj.DataSource '= DataSource) $$GenRetXml("0","已有病历数据DataSource类型为"_DataSource_",无需更新此数据")
	
	s obj.EpisodeID = EpisodeID
	s obj.DataSource = DataSource
	s obj.UpdateDate = $p(now,",",1)
	s obj.UpdateTime = $p(now,",",2)
	s obj.UpdateUserID = UserID
	s obj.UpdateUserName = UserName
	s obj.MainSuit = MainSuit
	s obj.PresentIllness = PresentIllness
	s obj.PastHistory = PastHistory
	s obj.PhyExam = PhyExam
	s obj.AssistExam = AssistExam
	s obj.AllergyHistory = AllergyHistory
	s obj.MenstrualHistory = MenstrualHistory
	s obj.BPInfo = BPInfo
	s obj.Treatment = Treatment
	s obj.Diagnos = Diagnos
	s obj.Suggest = Suggest
	s obj.DiseaseProgress = DiseaseProgress
	s obj.DoctorUserID = DoctorUserID
	s obj.DoctorUserName = DoctorUserName
	s obj.RecordDate = RecordDate
	
	
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		d ##Class(EMRservice.BL.BLSDOPRecordSample).GenOPRecord(EpisodeID,UserID,Action,UsrCertCode,Token,certNo,ContainerName)
		
		q $$GenRetXml("0","成功")
	}
	else
	{
		q $$GenRetXml("-1",sc)
	}
	
OnRegXmlError
	s $ztrap = ""
	s writer = ##class(%XML.Writer).%New()
	s sc = writer.OutputToString()
	//s writer.Charset="UTF-8"
	s sc = writer.RootElement("Response")
	s sc = writer.Element("ResultCode")
	s sc = writer.WriteChars("-99")
	s sc = writer.EndElement()
	s sc = writer.Element("ResultContent")
	s sc = writer.WriteChars($zerror)
	s sc = writer.EndElement()
	s sc = writer.EndRootElement()
	q writer.GetXMLString()	

GenRetXml(sc,msg)
	s writer = ##class(%XML.Writer).%New()
	s sc = writer.OutputToString()
	//s writer.Charset="UTF-8"
	s sc = writer.RootElement("Response")
	s sc = writer.Element("ResultCode")
	s sc = writer.WriteChars(sc)
	s sc = writer.EndElement()
	s sc = writer.Element("ResultContent")
	s sc = writer.WriteChars(msg)
	s sc = writer.EndElement()
	s sc = writer.EndRootElement()
	q writer.GetXMLString()
}

/// Desc:	删除门诊病历信息
/// Input:	xmlRequest 入参xml字符串，格式如下
/// 			<Request>
/// 				<DocID>1503</DocID>
/// 				<Title></Title>
/// 				<TitleCode></TitleCode>
/// 				<TemplateID>519</TemplateID>
/// 				<TemplateVersion>1</TemplateVersion>
/// 				<EpisodeID>216406</EpisodeID>
/// 				<DataSource>OL</DataSource>
/// 				<UserID>2</UserID>
/// 				<UserName>ys01</UserName>
/// 			</Request>
/// Return: <Response><ResultCode>0</ResultCode><ResultContent>成功</ResultContent></Response>
ClassMethod DelXml(xmlRequest As %String) As %String
{
	s $ztrap = "OnUnRegXmlError"
	
	s now = $h
	
	s arr = ..XmlToArray(xmlRequest)
	//模板信息
	s DocID = arr.GetAt("DocID")
	s Title = arr.GetAt("Title")
	s TitleCode = arr.GetAt("TitleCode")
	s TemplateID = arr.GetAt("TemplateID")
	s TemplateVersion = arr.GetAt("TemplateVersion")
	//
	s EpisodeID = arr.GetAt("EpisodeID")
	s DataSource = arr.GetAt("DataSource")
	s UserID = arr.GetAt("UserID")
	s UserName = arr.GetAt("UserName")
	
	q:(EpisodeID = "") $$GenRetXml("-1","未指定就诊ID")


	s sc= ##Class(EMRservice.BL.BLSDOPRecordSample).DeleteOPRecord(EpisodeID,DocID,TemplateID,UserID)
	
	if (+sc=1)
	{	
		q $$GenRetXml("0","成功")
	}
	else
	{

		q $$GenRetXml("-1",$p(sc,"^",2))
	}
OnUnRegXmlError
	s $ztrap = ""
	s writer = ##class(%XML.Writer).%New()
	s sc = writer.OutputToString()
	//s writer.Charset="UTF-8"
	s sc = writer.RootElement("Response")
	s sc = writer.Element("ResultCode")
	s sc = writer.WriteChars("-99")
	s sc = writer.EndElement()
	s sc = writer.Element("ResultContent")
	s sc = writer.WriteChars($zerror)
	s sc = writer.EndElement()
	s sc = writer.EndRootElement()
	q writer.GetXMLString()	

GenRetXml(sc,msg)
	s writer = ##class(%XML.Writer).%New()
	s sc = writer.OutputToString()
	//s writer.Charset="UTF-8"
	s sc = writer.RootElement("Response")
	s sc = writer.Element("ResultCode")
	s sc = writer.WriteChars(sc)
	s sc = writer.EndElement()
	s sc = writer.Element("ResultContent")
	s sc = writer.WriteChars(msg)
	s sc = writer.EndElement()
	s sc = writer.EndRootElement()
	q writer.GetXMLString()
}

ClassMethod XmlToArray(xmlRequest As %String) As %ArrayOfDataTypes
{
	s ret = ##Class(%ArrayOfDataTypes).%New()
	
	s sc = ##class(%XML.TextReader).ParseString(xmlRequest,.reader)
	q:(sc '= "1") ret
	
	while reader.Read()
	{
		//b "s"
		if (reader.NodeType = "element")
		{
			s key = reader.Name
		}
		elseif (reader.NodeType = "chars")&&(reader.Name = "")
		{
			d ret.SetAt(reader.Value, key)
		}
	}
	
	q ret
}

ClassMethod GetID(AEpisodeID As %String) As %String
{
	s rowID = $O(^DHCEMRI.SDOPRecordI("IdxEpisodeID"," "_AEpisodeID,""))
	q rowID
}

/// d ##Class(EMRinstance.SDOPRecord).Test()
ClassMethod Test()
{
	s xml = "<Request><EpisodeID>760</EpisodeID><DataSource>OL</DataSource><UserID>6</UserID><UserName>doctor</UserName><MainSuit>主诉内容</MainSuit><PresentIllness>现病史</PresentIllness><PastHistory>既往史</PastHistory><PhyExam>体格检查</PhyExam><AssistExam>辅助检查</AssistExam><AllergyHistory>过敏史</AllergyHistory><MenstrualHistory>月经史</MenstrualHistory><BPInfo>血压脉搏信息</BPInfo><Treatment>治疗处置、医嘱与用药</Treatment>"
	s xml = xml_"<Diagnos>诊断2</Diagnos><Suggest>治疗建议2</Suggest><DiseaseProgress>病情变化及处置</DiseaseProgress><DoctorUserID>6</DoctorUserID><DoctorUserName>doctor</DoctorUserName><RecordDate>2019-09-27</RecordDate>"
	s xml = xml_"</Request>"
	
	s rtn1 = ..RegXml(xml)
	w !, "reg:"_rtn1
	
	s rtn2 = ..GetXml("10")
	w !
	w !, "get:"_rtn2
}

/// d ##Class(EMRinstance.SDOPRecord).Test2()
ClassMethod Test2()
{
	s xml = " <Request><EpisodeID>755</EpisodeID><DataSource>OL</DataSource><UserID>6</UserID><UserName>doctor</UserName><MainSuit>主诉内容</MainSuit><PresentIllness>现病史</PresentIllness><PastHistory>既往史</PastHistory><PhyExam></PhyExam><AssistExam></AssistExam><AllergyHistory></AllergyHistory><MenstrualHistory></MenstrualHistory><BPInfo></BPInfo><Treatment>治疗处置信息（医嘱、用药）</Treatment><Diagnos>诊断</Diagnos><Suggest>医生建议</Suggest><DiseaseProgress></DiseaseProgress><DoctorUserID>6</DoctorUserID><DoctorUserName>doctor</DoctorUserName><RecordDate>2019-09-20 22:02</RecordDate></Request>"
	//s xml = xml_"<Diagnos>诊断2</Diagnos><Suggest>治疗建议2</Suggest><DiseaseProgress>病情变化及处置</DiseaseProgress><DoctorUserID>签名医师ID</DoctorUserID><DoctorUserName>签名医师姓名</DoctorUserName><RecordDate>签名日期</RecordDate>"
	//s xml = xml_"</Request>"
	
	s rtn1 = ..RegXml(xml)
	w !, "reg:"_rtn1
	
	s rtn2 = ..GetXml("10")
	w !
	w !, "get:"_rtn2
}

Storage Default
{
<Data name="SDOPRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>DataSource</Value>
</Value>
<Value name="4">
<Value>CreateDate</Value>
</Value>
<Value name="5">
<Value>CreateTime</Value>
</Value>
<Value name="6">
<Value>CreateUserID</Value>
</Value>
<Value name="7">
<Value>CreateUserName</Value>
</Value>
<Value name="8">
<Value>UpdateDate</Value>
</Value>
<Value name="9">
<Value>UpdateTime</Value>
</Value>
<Value name="10">
<Value>UpdateUserID</Value>
</Value>
<Value name="11">
<Value>UpdateUserName</Value>
</Value>
<Value name="12">
<Value>MainSuit</Value>
</Value>
<Value name="13">
<Value>PresentIllness</Value>
</Value>
<Value name="14">
<Value>PastHistory</Value>
</Value>
<Value name="15">
<Value>PhyExam</Value>
</Value>
<Value name="16">
<Value>AssistExam</Value>
</Value>
<Value name="17">
<Value>AllergyHistory</Value>
</Value>
<Value name="18">
<Value>MenstrualHistory</Value>
</Value>
<Value name="19">
<Value>TotPastHistory</Value>
</Value>
<Value name="20">
<Value>BPInfo</Value>
</Value>
<Value name="21">
<Value>Treatment</Value>
</Value>
<Value name="22">
<Value>Diagnos</Value>
</Value>
<Value name="23">
<Value>Suggest</Value>
</Value>
<Value name="24">
<Value>DiseaseProgress</Value>
</Value>
<Value name="25">
<Value>DoctorUserID</Value>
</Value>
<Value name="26">
<Value>DoctorUserName</Value>
</Value>
<Value name="27">
<Value>RecordDate</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.SDOPRecordD</DataLocation>
<DefaultData>SDOPRecordDefaultData</DefaultData>
<IdLocation>^DHCEMRI.SDOPRecordD</IdLocation>
<IndexLocation>^DHCEMRI.SDOPRecordI</IndexLocation>
<StreamLocation>^DHCEMRI.SDOPRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
