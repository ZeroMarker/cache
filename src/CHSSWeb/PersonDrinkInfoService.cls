Class CHSSWeb.PersonDrinkInfoService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod List(RelateROWID, Start, Limit)
{
	Set RelateROWID=$G(RelateROWID)
	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	Set end = start+limit
	Set json = ##class(Code.JsonObj).%New()
	s DrinkRowId=0
	
    For  Set DrinkRowId=$O(^CHSS.PersonDrinkInfoI("RelateIndex",RelateROWID,DrinkRowId)) q:DrinkRowId=""  d
	.s tempInfo=##class(CHSS.PersonDrinkInfo).%OpenId(DrinkRowId)
	
	
	.s DrinkType=tempInfo.DrinkType
	
	.s YearDrink=tempInfo.YearDrink
	.s TimesOfMonth=tempInfo.TimesOfMonth
	.s QuanityOfDrink=tempInfo.QuanityOfDrink
	
	.s tmp=""
	.s tmp=DrinkRowId_"^"_RelateROWID_"^"_DrinkType_"^"_YearDrink_"^"_TimesOfMonth_"^"_QuanityOfDrink
	.s count=count+1
	.i (count>start)&(count<=end) d
	..d json.InsertRowData(tmp)
	
	s resultString = json.getJsonData("DrinkRowId^RelateROWID^DrinkType^YearDrink^TimesOfMonth^QuanityOfDrink",count)
	k json	
	Quit resultString
}

ClassMethod insertupdate(DrinkRowId, RelateROWID, DrinkType, YearDrink, TimesOfMonth, QuanityOfDrink)
{
	s tempInfo=""
	
	i DrinkRowId'="" d
	.s tempInfo=##class(CHSS.PersonDrinkInfo).%OpenId(DrinkRowId)
	e  d
	.s tempInfo=##class(CHSS.PersonDrinkInfo).%New()
	
	i RelateROWID'="" d
	.s tempInfo.RelateROWID=##class(CHSS.PersonLifeStyle).%OpenId(RelateROWID)
	
	s tempInfo.DrinkType=DrinkType
	
	s tempInfo.YearDrink=YearDrink
	s tempInfo.TimesOfMonth=TimesOfMonth
	s tempInfo.QuanityOfDrink=QuanityOfDrink
	
	s result=""
	s result=tempInfo.%Save()
  
    Set resultString = ""
    i result = "1" d
    .s resultString = "{""success"":""true"",""info"":""数据保存成功！""}"
    e  d
    .s resultString = "{""success"":""false"",""info"":""数据保存出错!""}"
    q resultString
}

ClassMethod delete(RowId)
{
	q:(RowId = "") ""
	s tempPerson=##class(CHSS.PersonDrinkInfo).%OpenId(RowId)
	q:(tempPerson="") ""
	
	s result=tempPerson.%DeleteId(RowId)
	
	i result = "1" d
    .w "{""success"":""true"",""info"":""数据删除成功！""}"
    .
    e  d
    .w "{""success"":""false"",""info"":""数据删除出错！""}"
    .
    q ""
}

Storage Default
{
<Data name="PersonDrinkInfoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.PersonDrinkI8CCD</DataLocation>
<DefaultData>PersonDrinkInfoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.PersonDrinkI8CCD</IdLocation>
<IndexLocation>^CHSSWeb.PersonDrinkI8CCI</IndexLocation>
<StreamLocation>^CHSSWeb.PersonDrinkI8CCS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
