/// Name:         DHCHAI.DI.DWS.FromDataPoolWS
/// Creator：     zhoubo
/// CreatDate：   2017-07-20
/// Description:  东华数字医疗-医院感染系统信息服务
Class DHCHAI.DI.DWS.DataPoolWS Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "SyncPatInfoSOAP";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://localhost:57772/dthealth/web/";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// Creator：     zhoubo
/// CreatDate：   2017-07-13
/// Description:  三方系统,保存患者日常病程信息
/// Input：       XML格式的患者日常病程信息
/// Return：      处理数据条数
Method SyncDailyCourseByXML(aSCode As %String, aInput As %String) As %String [ WebMethod ]
{
	// <Response><Item><CourseID>1</CourseID><EpisodeID>20</EpisodeID><Title>主治医师查房记录</Title><CourseDate>2017-07-12</CourseDate><Course>内容</Course><ActDate>2017-07-11</ActDate><ActTime>12:23:23</ActTime><ActUser>记录人员</ActUser><IsActive>1</IsActive><SCode>EMR01</SCode></Item></Response>
	New (aSCode,aInput)
	set ReturnValue=##class(DHCHAI.DI.DWS.DataPoolSrv).SyncDailyCourseByXML(aSCode,aInput)
	Quit ReturnValue
}

/// Creator：     zhoubo
/// CreatDate：   2017-07-13
/// Description:  三方系统,保存患者首次病程信息
/// Input：       XML格式的患者首次病程信息
/// Return：      处理数据条数
Method SyncFirstCourseByXML(aSCode As %String, aInput As %String) As %String [ WebMethod ]
{
	// <Response><Item><CourseID>1</CourseID><EpisodeID>20</EpisodeID><Course>内容</Course><ActDate>2017-07-12</ActDate><ActTime>12:23:23</ActTime><ActUser>记录人员</ActUser><IsActive>1</IsActive><SCode>EMR01</SCode></Item></Response>
	New (aSCode,aInput)
	set ReturnValue=##class(DHCHAI.DI.DWS.DataPoolSrv).SyncFirstCourseByXML(aSCode,aInput)
	Quit ReturnValue
}

/// Creator：     zhoubo
/// CreatDate：   2017-07-13
/// Description:  三方系统,保存患者病案编目手术信息
/// Input：       XML格式的患者病案编目手术信息
/// Return：      处理数据条数
Method SyncWMROperByXML(aSCode As %String, aInput As %String) As %String [ WebMethod ]
{
	// <Response><Item><OperID>2||2</OperID><EpisodeID>20</EpisodeID><OperICD>342D.342</OperICD><OperDesc>阑尾炎切除手术</OperDesc><OperType>急诊</OperType><StartDate>2017-07-13</StartDate><StartTime>09:34:34</StartTime><EndDate>2017-07-13</EndDate><EndTime>10:34:34</EndTime><OperHour>4</OperHour><OperLocCode>LocCode</OperLocCode><OperLocDesc>手术科室1</OperLocDesc><OpertorCode>Code001</OpertorCode><OpertorName>周波</OpertorName><Assistant1>周波1</Assistant1><Assistant2>周波2</Assistant2><IncisionCode>1</IncisionCode><Incision>I</Incision><HealingCode>1</HealingCode><Healing>愈合情况1</Healing><AnesMethodCode>1</AnesMethodCode><AnesMethod>麻醉方式1</AnesMethod><Anesthesia>麻醉医师周波</Anesthesia><ASAScore>99</ASAScore><NNISGrade>一级</NNISGrade></Item><Item><OperID>2||11</OperID><EpisodeID>49</EpisodeID><OperICD>342D.342</OperICD><OperDesc>阑尾炎的顶顶顶顶顶切除手术</OperDesc><OperType>急ddd诊</OperType><StartDate>2017-07-13</StartDate><StartTime>09:34:34</StartTime><EndDate>2017-07-13</EndDate><EndTime>10:34:34</EndTime><OperHour>4</OperHour><OperLocCode>LocCode</OperLocCode><OperLocDesc>手术科室1</OperLocDesc><OpertorCode>Code001</OpertorCode><OpertorName>周波</OpertorName><Assistant1>周波1</Assistant1><Assistant2>周波2</Assistant2><IncisionCode>1</IncisionCode><Incision>I</Incision><HealingCode>1</HealingCode><Healing>愈合情况1</Healing><AnesMethodCode>1</AnesMethodCode><AnesMethod>麻醉方式1</AnesMethod><Anesthesia>麻醉医师周波</Anesthesia><ASAScore>99</ASAScore><NNISGrade>一级</NNISGrade></Item></Response>
	New (aSCode,aInput)
	set ReturnValue=##class(DHCHAI.DI.DWS.DataPoolSrv).SyncWMROperByXML(aSCode,aInput)
	Quit ReturnValue
}

/// Creator：     zhoubo
/// CreatDate：   2017-07-17
/// Description:  三方系统,保存患者电子病历手术信息
/// Input：       XML格式的患者电子病历手术信息
/// Return：      处理数据条数
Method SyncEMROperByXML(aSCode As %String, aInput As %String) As %String [ WebMethod ]
{
	// <Response><Item><OperID>2||2</OperID><EpisodeID>20</EpisodeID><OperICD>342D.342</OperICD><OperDesc>阑尾炎切除手术</OperDesc><OperType>急诊</OperType><StartDate>2017-07-13</StartDate><StartTime>09:34:34</StartTime><EndDate>2017-07-13</EndDate><EndTime>10:34:34</EndTime><OperHour>4</OperHour><OperLocCode>LocCode</OperLocCode><OperLocDesc>手术科室1</OperLocDesc><OpertorCode>Code001</OpertorCode><OpertorName>周波</OpertorName><Assistant1>周波1</Assistant1><Assistant2>周波2</Assistant2><IncisionCode>1</IncisionCode><Incision>I</Incision><HealingCode>1</HealingCode><Healing>愈合情况1</Healing><AnesMethodCode>1</AnesMethodCode><AnesMethod>麻醉方式1</AnesMethod><Anesthesia>麻醉医师周波</Anesthesia><ASAScore>99</ASAScore><NNISGrade>一级</NNISGrade></Item><Item><OperID>2||11</OperID><EpisodeID>49</EpisodeID><OperICD>342D.342</OperICD><OperDesc>阑尾炎的顶顶顶顶顶切除手术</OperDesc><OperType>急ddd诊</OperType><StartDate>2017-07-13</StartDate><StartTime>09:34:34</StartTime><EndDate>2017-07-13</EndDate><EndTime>10:34:34</EndTime><OperHour>4</OperHour><OperLocCode>LocCode</OperLocCode><OperLocDesc>手术科室1</OperLocDesc><OpertorCode>Code001</OpertorCode><OpertorName>周波</OpertorName><Assistant1>周波1</Assistant1><Assistant2>周波2</Assistant2><IncisionCode>1</IncisionCode><Incision>I</Incision><HealingCode>1</HealingCode><Healing>愈合情况1</Healing><AnesMethodCode>1</AnesMethodCode><AnesMethod>麻醉方式1</AnesMethod><Anesthesia>麻醉医师周波</Anesthesia><ASAScore>99</ASAScore><NNISGrade>一级</NNISGrade></Item></Response>
	New (aSCode,aInput)
	set ReturnValue=##class(DHCHAI.DI.DWS.DataPoolSrv).SyncEMROperByXML(aSCode,aInput)
	Quit ReturnValue
}

/// Creator：     zhoubo
/// CreatDate：   2017-07-12
/// Description:  三方系统,保存患者护理信息
/// Input：       XML格式的患者护理信息
/// Return：      处理数据条数
Method SyncNisInfoByXML(aSCode As %String, aInput As %String) As %String [ WebMethod ]
{
	// <Response><Item><TempID>2||1</TempID><EpisodeID>20</EpisodeID><Code>NISCowwwwwwwwwwde2</Code><Desc>NISNaw3333333333333me2</Desc><Value>39℃</Value><EntryDate>2017-07-04</EntryDate><EntryTime>12:12:34</EntryTime><EntryUserCode>INPCode</EntryUserCode><EntryUser>INPName</EntryUser><IsActive>1</IsActive></Item><Item><TempID>3||3</TempID><EpisodeID>49</EpisodeID><Code>NISC11111ode2</Code><Desc>NISN2222ame2</Desc><Value>35℃</Value><EntryDate>2017-07-11</EntryDate><EntryTime>12:13:34</EntryTime><EntryUserCode>INPCo33333de</EntryUserCode><EntryUser>INPName3333</EntryUser><IsActive>1</IsActive></Item></Response>
	New (aSCode,aInput)
	set ReturnValue=##class(DHCHAI.DI.DWS.DataPoolSrv).SyncNisInfoByXML(aSCode,aInput)
	Quit ReturnValue
}

/// Creator：     zhoubo
/// CreatDate：   2017-07-13
/// Description:  三方系统,保存患者Pacs影像信息
/// Input：       XML格式的患者Pacs影像信息
/// Return：      处理数据条数
Method SyncPacsInfoByXML(aSCode As %String, aInput As %String) As %String [ WebMethod ]
{
	// <Response><Item><ReportID>412315454</ReportID><EpisodeID>20</EpisodeID><StudyNo>2131||31||231</StudyNo><ChkStatus>审核</ChkStatus><CheckItem>检查项目</CheckItem><ExamDesc>检查所见有细菌</ExamDesc><ResultDesc>诊断意见</ResultDesc><RegDate>2017-07-12</RegDate><RegTime>12:23:23</RegTime><RegUser>周波</RegUser><RepDate>2017-07-13</RepDate><RepTime>12:23:23</RepTime><RepUser>周波2</RepUser><IsActive>1</IsActive></Item><Item><ReportID>411115454</ReportID><EpisodeID>20</EpisodeID><StudyNo>2131||31||231</StudyNo><ChkStatus>审核</ChkStatus><CheckItem>检查项目</CheckItem><ExamDesc>检查所见有细菌</ExamDesc><ResultDesc>诊断意见</ResultDesc><RegDate>2017-07-12</RegDate><RegTime>12:23:23</RegTime><RegUser>周波</RegUser><RepDate>2017-07-13</RepDate><RepTime>12:23:23</RepTime><RepUser>周波2</RepUser><IsActive>1</IsActive></Item><Item><ReportID>45422222254</ReportID><EpisodeID>20</EpisodeID><StudyNo>2131||31||231</StudyNo><ChkStatus>审核</ChkStatus><CheckItem>检查项目</CheckItem><ExamDesc>检查所见有细菌</ExamDesc><ResultDesc>诊断意见</ResultDesc><RegDate>2017-07-12</RegDate><RegTime>12:23:23</RegTime><RegUser>周波</RegUser><RepDate>2017-07-13</RepDate><RepTime>12:23:23</RepTime><RepUser>周波2</RepUser><IsActive>1</IsActive></Item><Item><ReportID>454512121214</ReportID><EpisodeID>20</EpisodeID><StudyNo>2131||31||231</StudyNo><ChkStatus>审核</ChkStatus><CheckItem>检查项目</CheckItem><ExamDesc>检查所见有细菌</ExamDesc><ResultDesc>诊断意见</ResultDesc><RegDate>2017-07-12</RegDate><RegTime>12:23:23</RegTime><RegUser>周波</RegUser><RepDate>2017-07-13</RepDate><RepTime>12:23:23</RepTime><RepUser>周波2</RepUser><IsActive>1</IsActive></Item></Response>
	New (aSCode,aInput)
	set ReturnValue=##class(DHCHAI.DI.DWS.DataPoolSrv).SyncPacsInfoByXML(aSCode,aInput)
	Quit ReturnValue
}

/// Creator：     zhoubo
/// CreatDate：   2017-07-13
/// Description:  三方系统,保存手麻信息
/// Input：       XML格式的手麻信息
/// Return：      处理数据条数
Method SyncOperAnaesByXML(aSCode As %String, aInput As %String) As %String [ WebMethod ]
{
	// <Response><Item><SCode>OPS01</SCode><OperID>223||2</OperID><EpisodeID>68</EpisodeID><OperICD>342D.342</OperICD><OperDesc>阑尾炎切除手术</OperDesc><OperType>急诊</OperType><StartDate>2017-08-31</StartDate><StartTime>09:34:34</StartTime><EndDate>2017-08-31</EndDate><EndTime>10:34:34</EndTime><OperHour>4</OperHour><OperLocCode>LocC11ode</OperLocCode><OperLocDesc>妇科</OperLocDesc><OpertorCode>Code1001</OpertorCode><OpertorName>周1波</OpertorName><Assistant1>周波1</Assistant1><Assistant2>周波2</Assistant2><IncisionCode>12212</IncisionCode><Incision>I111类</Incision><HealingCode>11</HealingCode><Healing>愈合情况22</Healing><AnesMethodCode>21</AnesMethodCode><AnesMethod>麻醉22方式1</AnesMethod><Anesthesia>麻醉医师周波</Anesthesia><ASAScore>12P2</ASAScore><NNISGrade>一级</NNISGrade><WBC>23</WBC><IncisionNum>88</IncisionNum><IsSightGlass>1</IsSightGlass><IsImplants>1</IsImplants><LoseBlood>23</LoseBlood><GotBlood>24</GotBlood><Complication>1</Complication><IsActive>1</IsActive></Item></Response>
	New (aSCode,aInput)
	set ReturnValue=##class(DHCHAI.DI.DWS.DataPoolSrv).SyncOperAnaesByXML(aSCode,aInput)
	Quit ReturnValue
}

/// Creator：     liyi
/// CreatDate：   2017-07-24
/// Description:  三方系统,保存患者就诊信息
/// Input：       XML格式的患者就诊信息
/// Return：      处理数据条数
Method SyncPAAdmByXML(aSCode As %String, aInput As %String) As %String [ WebMethod ]
{
	// <Response><Item><EpisodeID>1</EpisodeID><PatientID>1</PatientID><PapmiNo>000032141</PapmiNo><MrNo>1241451</MrNo><PatName>王鑫</PatName><Sex>M</Sex><Nation>汉</Nation><Birthday>1989-09-20</Birthday><IdentityCode>51102319890920119X</IdentityCode><HomeAddress>四川省成都市</HomeAddress><Company>东华软件</Company><RelativeName>刘长春</RelativeName><RelativeTel>18508205822</RelativeTel><IsDeath>0</IsDeath><DeathDate></DeathDate><DeathTime></DeathTime><AdmType>I</AdmType><VisitStatus>D</VisitStatus><AdmDate>2017-07-21</AdmDate><AdmTime>12:00:00</AdmTime><AdmLocCode>中西医结合一科</AdmLocCode><AdmLoc>ZXYJHYK-中西医结合一科</AdmLoc><AdmWardCode>中西医结合一科护理单元</AdmWardCode><AdmWard>ZXYJHYKHLDY-中西医结合一科护理单元</AdmWard><AdmRoom>12房</AdmRoom><AdmBed>4床</AdmBed><DischDate>2017-07-28</DischDate><DischTime>14:00:00</DischTime><DischLocCode>中西医结合二科</DischLocCode><DischLoc>ZXYJHEK-中西医结合二科</DischLoc><DischWardCode>中西医结合二科护理单元</DischWardCode><DischWard>ZXYJHEKHLDY-中西医结合二科护理单元</DischWard><IsNewBaby>0</IsNewBaby><BirthWeight></BirthWeight><AdmitWeight></AdmitWeight><IsActive>1</IsActive></Item></Response>
	New (aSCode,aInput)
	set ReturnValue=##class(DHCHAI.DI.DWS.DataPoolSrv).SyncPAAdmByXML(aSCode,aInput)
	Quit ReturnValue
}

/// Creator：     liyi
/// CreatDate：   2017-07-24
/// Description:  三方系统,保存患者诊断信息
/// Input：       XML格式的患者诊断信息
/// Return：      处理数据条数
Method SyncDiagsByXML(aSCode As %String, aInput As %String) As %String [ WebMethod ]
{
	// <Response><Item><EpisodeID>1</EpisodeID><MrDiagID>1||1</MrDiagID><DiagICD10>E14.001</DiagICD10><DiagDesc>糖尿病</DiagDesc><DiagNote>长期糖尿病</DiagNote><DiagTpCode>1</DiagTpCode><DiagTpDesc>主要诊断</DiagTpDesc><DiagDate>2017-07-21</DiagDate><DiagTime>12:00:00</DiagTime><SCode>HIS01</SCode><IsActive>1</IsActive></Item></Response>
	New (aSCode,aInput)
	set ReturnValue=##class(DHCHAI.DI.DWS.DataPoolSrv).SyncDiagsByXML(aSCode,aInput)
	Quit ReturnValue
}

/// Creator：     liyi
/// CreatDate：   2017-07-24
/// Description:  三方系统,保存转科记录
/// Input：       XML格式的转科记录
/// Return：      处理数据条数
Method SyncTransByXML(aSCode As %String, aInput As %String) As %String [ WebMethod ]
{
	// <Response><Item><TransID>1||1</TransID><EpisodeID>1</EpisodeID><TransLocCode>中西医结合一科</TransLocCode><TransLocDesc>ZXYJHYK-中西医结合一科</TransLocDesc><IsICUFlag>0</IsICUFlag><TransDate>2017-07-23</TransDate><TransTime>12:00:00</TransTime><OutLocDate>2017-07-25</OutLocDate><OutLocTime>14:00:00</OutLocTime></Item></Response>
	New (aSCode,aInput)
	set ReturnValue=##class(DHCHAI.DI.DWS.DataPoolSrv).SyncTransByXML(aSCode,aInput)
	Quit ReturnValue
}

/// Creator：     liyi
/// CreatDate：   2017-07-24
/// Description:  三方系统,保存医嘱记录
/// Input：       XML格式的医嘱记录
/// Return：      处理数据条数
Method SyncOEOrdItemByXML(aSCode As %String, aInput As %String) As %String [ WebMethod ]
{
	// <Response><Item><OEOrdID>1||1</OEOrdID><EpisodeID>1</EpisodeID><OrdCode>A0101</OrdCode><OrdDesc>青霉素注射液5ML</OrdDesc><OrdType>R</OrdType><OrdCat>西药</OrdCat><OrdSubCat>青霉素</OrdSubCat><Priority>临时医嘱</Priority><IsThreeOrder>0</IsThreeOrder><OrdStatus>审核</OrdStatus><OrdDate>2017-07-22</OrdDate><OrdTime>13:00:00</OrdTime><OrdLocID>4</OrdLocID><OrdLocDesc>NYK-内一科</OrdLocDesc><DocCode>zhuguohang</DocCode><DocName>杨慧</DocName><SttDate>2017-07-23</SttDate><SttTime>14:00:00</SttTime><EndDate>2017-07-24</EndDate><EndTime>15:00:00</EndTime><Generic>青霉素1</Generic><Instruc>肌肉注射</Instruc><DoseQty>5</DoseQty><DoseQtyUom>ml</DoseQtyUom><FreqDesc>bid</FreqDesc><SCode>HIS01</SCode><IsActive>1</IsActive></Item><Item><OEOrdID>1||2</OEOrdID><EpisodeID>1</EpisodeID><OrdCode>A01011</OrdCode><OrdDesc>青霉素注射液10ML</OrdDesc><OrdType>R</OrdType><OrdCat>西药</OrdCat><OrdSubCat>青霉素</OrdSubCat><Priority>临时医嘱</Priority><IsThreeOrder>1</IsThreeOrder><OrdStatus>审核</OrdStatus><OrdDate>2017-07-22</OrdDate><OrdTime>13:00:00</OrdTime><OrdLocID>4</OrdLocID><OrdLocDesc>NYK-内一科</OrdLocDesc><DocCode>zhuguohang</DocCode><DocName>杨慧</DocName><SttDate>2017-07-23</SttDate><SttTime>14:00:00</SttTime><EndDate>2017-07-24</EndDate><EndTime>15:00:00</EndTime><Generic>青霉素1</Generic><Instruc>肌肉注射</Instruc><DoseQty>5</DoseQty><DoseQtyUom>ml</DoseQtyUom><FreqDesc>bid</FreqDesc><SCode>HIS01</SCode><IsActive>1</IsActive></Item></Response>
	New (aSCode,aInput)
	set ReturnValue=##class(DHCHAI.DI.DWS.DataPoolSrv).SyncOEOrdItemByXML(aSCode,aInput)
	Quit ReturnValue
}

/// Creator：     liyi
/// CreatDate：   2017-07-24
/// Description:  三方系统,保存抗菌药物使用记录
/// Input：       XML格式的抗菌药物使用记录
/// Return：      处理数据条数
Method SyncAntUseByXML(aSCode As %String, aInput As %String) As %String [ WebMethod ]
{
	// <Response><Item><AntUseID>1</AntUseID><EpisodeID>20</EpisodeID><AntiCode>A00001</AntiCode><AntiDesc>阿奇霉素颗粒</AntiDesc><OrdID>11||1</OrdID><DrgPoison>KISS1</DrgPoison><UsePurpose>预防+治疗</UsePurpose><OthPurpose>预防</OthPurpose><IsSubmission>1</IsSubmission><InfPos>肺部</InfPos><UseDate>2017-09-01</UseDate><UseTime>12:00:00</UseTime><IsActive>1</IsActive><SCode>ANT01</SCode></Item></Response>
	New (aSCode,aInput)
	set ReturnValue=##class(DHCHAI.DI.DWS.DataPoolSrv).SyncAntUseByXML(aSCode,aInput)
	Quit ReturnValue
}

}
