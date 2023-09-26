Class CHSSWeb.WhNewBornService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: lyy
/// CreatDate：2009-10-
/// Description:检索新生儿情况
/// Table：WhNewBorn
/// Input: WhNewBorn
/// Output：
/// Return：
/// Others：
ClassMethod ListPage(start As %Integer, limit As %Integer, WomanRowId As %Integer) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT NewBornRowId, BirthWeight, Sex, Name, BirthSort FROM CHSS.WhNewBorn where WomanRowId ="_WomanRowId
	
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	Set json = ##class(Code.JsonObj).%New()

	While(result.Next())
	{

    s NewBornRowId = result.Data("NewBornRowId")
    s BirthWeight = result.Data("BirthWeight")
    s Sex = result.Data("Sex")
    s Name = result.Data("Name")
    s BirthSort = result.Data("BirthSort")

	Set tmp=NewBornRowId_"^"_BirthWeight_"^"_Sex_"^"_Name_"^"_BirthSort
	Set count = count+1
	If (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	
	Set resultString = json.getJsonData("NewBornRowId^BirthWeight^Sex^Name^BirthSort",count)
	
	k json
	d result.Close()
	q resultString
}

ClassMethod ShowInfo(start As %Integer, limit As %Integer, WomanRowId As %Integer) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT NewBornRowId, BirthWeight, Sex, Name, BirthSort FROM CHSS.WhNewBorn where WomanRowId ="_WomanRowId
	
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	Set start=$G(start)
	Set limit=$G(limit)
	
	Set count=0
	Set resultString = ""
	Set end = start+limit
	
	set tmp = ""
	set startStr = "'"
	
	While(result.Next())
	{

    s NewBornRowId = result.Data("NewBornRowId")
    s BirthWeight = result.Data("BirthWeight")
    s Sex = result.Data("Sex")
    s Name = result.Data("Name")
    s BirthSort = result.Data("BirthSort")

	Set tmp = tmp_startStr_"体重: "_BirthWeight_"g, 性别: "_Sex
	s startStr = "\r\n"	
	}
	
	i tmp '= "" d
	.s tmp = tmp_"'"
	e  d
	.s tmp = """"""
	q "{""success"":""true"",""info"":"_tmp_"}"
}

ClassMethod insert(WomanRowId As %Integer, BirthWeight As %Float, Sex As %String, Name As %String, BirthSort As %Integer) As %String
{
	q:(WomanRowId="") "妇女基本信息编号为空，保存出错！"
		
	s NewBornRowId=""
	q:NewBornRowId'="" "code-rep"
	&sql(insert into CHSS.WhNewBorn (WomanRowId, BirthWeight, Sex, Name, BirthSort) values(:WomanRowId,:BirthWeight,:Sex,:Name,:BirthSort))
	q SQLCODE
}

ClassMethod update(NewBornRowId As %Integer, BirthWeight As %Float, Sex As %String, Name As %String, BirthSort As %Integer) As %String
{
	q:(NewBornRowId="") "code-rep"
	&sql(update CHSS.WhNewBorn set BirthWeight=:BirthWeight, Sex=:Sex, Name=:Name, BirthSort=:BirthSort where %ID=:NewBornRowId)
	q SQLCODE
}

//删除一条数据库中已经存在的记录

ClassMethod delete(NewBornRowId) As %String
{
	&sql(delete from CHSS.WhNewBorn where %ID=:NewBornRowId)
	q SQLCODE
}

Storage Default
{
<Data name="WhNewBornServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.WhNewBornServiceD</DataLocation>
<DefaultData>WhNewBornServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.WhNewBornServiceD</IdLocation>
<IndexLocation>^CHSSWeb.WhNewBornServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.WhNewBornServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
