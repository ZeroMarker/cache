Class CHSSWeb.HISInfoTranCardService Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/*
	1.卡号		CardNumber
	2.姓名 		PersonName
	3.性别 		SexDR
	4.证件类型 	IDCardTypeDR
	5.证件号码 	IDCard
	6.出生日期 	Birth
	7.家庭地址 	Address
	8.联系电话 	LinkManPhone
	*/
/// 格式：<Request><PersonName>测试</PersonName><SexDR>男</SexDR><Birth>2009-12-01</Birth><IDCardTypeDR>1</IDCardTypeDR><IDCard>123467909766655443</IDCard><Address>成都市</Address><LinkManPhone>13880420460</LinkManPhone><CardNumber>005000000000107</CardNumber></Request>
/// HIS发卡之后更新个人档案的卡号
ClassMethod HISInfoTranCard(XMLPara As %String) As %String
{

	s ResultCode = "0"
	s reader=##Class(%XML.Reader).%New()
	s sc=reader.OpenString(XMLPara)
	;Request
	d reader.Correlate("Request","CHSS.PersonHISInfoXml")
	s CardNumber = ""
	s PersonName = ""
	s SexDR = ""
	s Birth = ""
	s IDCardTypeDR = ""
	s IDCard = ""
	s Address = ""
	s LinkManPhone = ""
	If $$$ISERR(sc)  //Do $system.OBJ.DisplayError(sc) Quit
	{
		q ResultCode
	}
	while reader.Next(.healthfile,.sc) {
		;w "CardNumber:"_healthfile.CardNumber,!
		;w "IDCard:"_healthfile.IDCard,!
		if (healthfile.CardNumber'="") && (healthfile.IDCard'="")  {
		s CardNumber = healthfile.CardNumber
		s IDCard = healthfile.IDCard
		&sql(update CHSS.PersonHealthRecordMain set CardNumber = :CardNumber where IDCard = :IDCard)		
		i SQLCODE = 0 d
		.s ResultCode = "1"
		}
		k healthfile
	}
	
	k XMLPara
	q ResultCode
}

ClassMethod HISInfoTranCardTest() As %String
{
	d ..HISInfoTranCard("<Request><PersonName>测试</PersonName><SexDR>男</SexDR><Birth>2009-12-01</Birth><IDCardTypeDR>1</IDCardTypeDR><IDCard>123467909766655443</IDCard><Address>成都市</Address><LinkManPhone>13880420460</LinkManPhone><CardNumber>005000000000107</CardNumber></Request>")
	q ""
}

}
