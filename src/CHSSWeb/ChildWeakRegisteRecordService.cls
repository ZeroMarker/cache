Class CHSSWeb.ChildWeakRegisteRecordService Extends %Persistent
{

ClassMethod add(RegisterRowId, Checker, CheckDate, BodyCheck, CureInfo, Remark, bNormal)
{
	 Set $ZT   ="ERROR"
	 TSTART
	s tempChild =##class(CHSS.ChildWeakCheck).%New()
	s recordResult=""
	s updateChildDisease=""
	i RegisterRowId'="" d
	.s tempChild.RegisterRowId=##class(CHSS.ChildWeakRegister).%OpenId(RegisterRowId)
	
	
	
	s tempChild.Checker=Checker
	
	i CheckDate'="" d
	.s CheckDate=$zdh(CheckDate,3)
	.s tempChild.CheckDate=CheckDate
	
	
	s tempChild.BodyCheck=BodyCheck
	s tempChild.CureInfo=CureInfo
	s tempChild.Remark=Remark
	s tempChild.bNormal=bNormal
	
	s result=""
    s result=tempChild.%Save()
    Set resultString = ""
    i result = "1" d
    .s recordResult=..updateCheckRecordDisease(RegisterRowId)
    .s updateChildDisease=..updateChildDisease(RegisterRowId)
    .i recordResult=0&&updateChildDisease=1 d
    ..TCommit
    ..s resultString = "{""success"":""true"",""info"":"_tempChild.%Id()_"}"
    .e  d
    ..TRollback
    ..s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    e  d
    .TRollback
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
ERROR
     TRollback
     s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
     q resultString
}

//更改体弱儿童登记中的 是否已经转正常

ClassMethod updateCheckRecordDisease(RegisterRowId)
{
	&sql(update CHSS.ChildWeakRegister set bNormal='true' where RegisterRowId=:RegisterRowId)
	q SQLCODE
}

//判断是否转正常，修改儿童基本信息的  儿童患病情况

ClassMethod updateChildDisease(RegisterRowId)
{
	    s updateResult=""
	    s Result = ##class(%Library.ResultSet).%New()
		s sql = "SELECT ChildRowid FROM CHSS.ChildBaseInfo where personrowid in (select PersonRowId from chss.ChildWeakRegister where RegisterRowId="_RegisterRowId_")"
		
		d Result.Prepare(sql)
		d Result.Execute()
		s tempChildBaseInfo=""
		while(Result.Next())
		{
			s ChildRowid = Result.Data("ChildRowId")
			s tempChildBaseInfo=##class(CHSS.ChildBaseInfo).%OpenId(ChildRowid)
			s childDisease = tempChildBaseInfo.ChildDisease
			 
			s tempChildBaseInfo.ChildDisease=$Translate(childDisease,"体弱","")
			 
			s updateResult=tempChildBaseInfo.%Save()

		}
		d Result.Close() 
		q updateResult
}

ClassMethod edit(RowId, Checker, CheckDate, BodyCheck, CureInfo, Remark, bNormal)
{

	q:(RowId="") ""
	s tempChild =##class(CHSS.ChildWeakCheck).%OpenId(RowId)
	

	s tempChild.Checker=Checker
	
	i CheckDate'="" d
	.s CheckDate=$zdh(CheckDate,3)
	.s tempChild.CheckDate=CheckDate
	
	
	s tempChild.BodyCheck=BodyCheck
	s tempChild.CureInfo=CureInfo
	s tempChild.Remark=Remark
	s tempChild.bNormal=bNormal
	
	s result=""
    s result=tempChild.%Save()
    Set resultString = ""
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":"_tempChild.%Id()_"}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

Storage Default
{
<Data name="ChildWeakRegisteRecordServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ChildWeakRegB6FD</DataLocation>
<DefaultData>ChildWeakRegisteRecordServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ChildWeakRegB6FD</IdLocation>
<IndexLocation>^CHSSWeb.ChildWeakRegB6FI</IndexLocation>
<StreamLocation>^CHSSWeb.ChildWeakRegB6FS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
