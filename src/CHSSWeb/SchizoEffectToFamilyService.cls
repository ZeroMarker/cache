Class CHSSWeb.SchizoEffectToFamilyService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Creator: liuchao
/// CreatDate：2010—1-11
/// Description:患病对家庭社会的影响
/// Table：SchizoEffectToFamily
/// Input: SchizoEffectToFamily
/// Output：
/// Return：
/// Others：
/// Modify: jinming 2011-6-30 添加CheckRowId字段检索
ClassMethod ListPage(start As %Integer, limit As %Integer, PersonRowId As %Integer, CheckRowId As %Integer) As %String
{
  
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT RowId,EffectRowIDDR,Times FROM CHSS.SchizoEffectToFamily"
 		
	i (PersonRowId'="" & CheckRowId'="") d
	.s sqlStr = sqlStr_" where PersonRowId ="_PersonRowId_" and CheckRowId="_CheckRowId
	 
	// w sqlStr
    //q ""
	
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
    s RowId = result.Data("RowId")
	s EffectRowIDDR = result.Data("EffectRowIDDR")
	
	s Times = result.Data("Times")	
	//s tmp = ##class(CHSS.DictEffectToFamily).%OpenId(EffectRowIDDR)	
	//s EffectRowIDDR=tmp.Description
	
	Set tmp=RowId_"^"_EffectRowIDDR_"^"_Times
	Set count = count+1
	If (count>start)&(count<=end) d
	.d json.InsertRowData(tmp)
	}
	
	Set resultString = json.getJsonData("RowId^EffectRowIDDR^Times",count)
	
	k json
	d result.Close()
	q resultString
}

ClassMethod ShowInfo(start As %Integer, limit As %Integer, PersonRowId As %Integer, CheckRowId As %Integer) As %String
{
  
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT EffectRowIDDR,Times FROM CHSS.SchizoEffectToFamily"
	
	i (PersonRowId'="" & CheckRowId'="") d
	.s sqlStr = sqlStr_" where PersonRowId ="_PersonRowId_" and CheckRowId="_CheckRowId
	d result.Prepare(sqlStr)
	d result.Execute()
		 
	Set resultString = ""	
	set tmp = ""
	set startStr = "'"	
	While(result.Next())
	{
 
	s EffectRowIDDR = result.Data("EffectRowIDDR")
	s Times = result.Data("Times")	 
	Set tmp = tmp_startStr_EffectRowIDDR_Times_"次"
	s startStr = "、"
	}
	
	i tmp '= "" d
	.s tmp = tmp_"'"
	e  d
	.s tmp = """"""
	 
	q "{""success"":""true"",""info"":"_tmp_"}"
}

ClassMethod insert(PersonRowId, EffectRowIDDR, Times, CheckRowId) As %String
{
    
	q:((PersonRowId="")||(EffectRowIDDR=""))&&(Times="") PersonRowId_" "_EffectRowIDDR_Times_"个人档案号，类型或次数为空，保存出错！"
		
	 
	&sql(insert into CHSS.SchizoEffectToFamily (PersonRowId,EffectRowIDDR,Times,CheckRowId) values(:PersonRowId,:EffectRowIDDR,:Times,:CheckRowId))
	q SQLCODE
}

ClassMethod update(RowId, EffectRowIDDR, Times) As %String
{
   
	q:(RowId="") "code-rep"
   
	&sql(update CHSS.SchizoEffectToFamily set EffectRowIDDR=:EffectRowIDDR,Times=:Times where %ID=:RowId)
	q SQLCODE
}

//删除一条数据库中已经存在的记录

ClassMethod delete(RowId) As %String
{
	&sql(delete from CHSS.SchizoEffectToFamily where %ID=:RowId)
	q SQLCODE
}

Storage Default
{
<Data name="SchizoEffectToFamilyServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.SchizoEffectAB3D</DataLocation>
<DefaultData>SchizoEffectToFamilyServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.SchizoEffectAB3D</IdLocation>
<IndexLocation>^CHSSWeb.SchizoEffectAB3I</IndexLocation>
<StreamLocation>^CHSSWeb.SchizoEffectAB3S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
