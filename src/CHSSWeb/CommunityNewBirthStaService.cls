Class CHSSWeb.CommunityNewBirthStaService Extends %Persistent
{

//根据树的街道节点，列出下属机构的统计数据

ClassMethod List(streetid)
{
 
	Set resultString = ""
	
	 
 
	Set json = ##class(Code.JsonObj).%New()	
   
		
    s communs=##class(CHSSWeb.CommunityTreeUtilService).getCommunityCode("street",streetid)
	q:communs="" ""
	;q communs
	for j=1:1:$L(communs,"^") d
	.s communitycodeAndName=$p(communs,"^",j)
	.s communityCode=$p(communitycodeAndName,",",1)
	.s communityName=$p(communitycodeAndName,",",2) 
	.s NewBirthCount=..GetNewBirthCount(communityCode)
	.s tmp=communityName_"^"_NewBirthCount
    .d json.InsertRowData(tmp)
 

	s resultString = json.getJsonData("StatName^ArcNum",20)
	k json	
	Quit resultString
}

//根据树的区县节点，列出下属街道和乡镇的统计数据

ClassMethod ListSection(sectionid)
{
	 
	Set resultString = ""
	Set json = ##class(Code.JsonObj).%New()	
    s result = ##class(%Library.ResultSet).%New()	
	s sqlstr="select description as streetname,rowid as streetid from chss.dictstreet where rowidparref="_sectionid
	d result.Prepare(sqlstr)
	d result.Execute()	
	
	While(result.Next())
	{
	s streetname=result.Get("streetname")
	s streetid=result.Get("streetid")
	s communs=##class(CHSSWeb.CommunityTreeUtilService).getCommunityCode("street",streetid)
    s newBirthCountz=0
    for j=1:1:$L(communs,"^") d
	.s communitycodeAndName=$p(communs,"^",j)
	.s communityCode=$p(communitycodeAndName,",",1)
	.s communityName=$p(communitycodeAndName,",",2) 
	.s NewBirthCount=..GetNewBirthCount(communityCode)
	.s newBirthCountz=newBirthCountz+NewBirthCount
	s tmp=streetname_"^"_newBirthCountz
    d json.InsertRowData(tmp)
	}
	s resultString =  json.getJsonData("StatName^ArcNum",20)
	k json	
	Quit resultString
}

//根据树的市节点，列出下属区县的数据

ClassMethod ListCity(cityid)
{
	 
	Set resultString = ""
 
 
	Set json = ##class(Code.JsonObj).%New()	
    s result = ##class(%Library.ResultSet).%New()	
	s sqlstr="select description as sectionname,rowid as sectionid from chss.dictsection where rowidparref="_cityid
	d result.Prepare(sqlstr)
	d result.Execute()	
	While(result.Next())
	{
	s sectionname=result.Get("sectionname")
	s sectionid = result.Get("sectionid")
	
    s communs=##class(CHSSWeb.CommunityTreeUtilService).getCommunityCode("section",sectionid)
    s newBirthCountz=0
    for j=1:1:$L(communs,"^") d
	.s communitycodeAndName=$p(communs,"^",j)
	.s communityCode=$p(communitycodeAndName,",",1)
	.s communityName=$p(communitycodeAndName,",",2) 
	.s NewBirthCount=..GetNewBirthCount(communityCode)
	.s newBirthCountz=newBirthCountz+NewBirthCount
	s tmp=sectionname_"^"_newBirthCountz
    d json.InsertRowData(tmp)
    }
    
	s resultString =  json.getJsonData("StatName^ArcNum",20)
	k json	
	Quit resultString
}

ClassMethod GetNewBirthCount(communitycode)
{
	  s newBirthCount=0
	  s result = ##class(%Library.ResultSet).%New()	
	  s sqlStr="select count(*) as birthcount from chss.childbaseinfo where communitycode="_communitycode
      d result.Prepare(sqlStr)
	  d result.Execute()	
	  While(result.Next())
	  {
		s newBirthCount=result.Get("birthcount")
		
		}
	  q newBirthCount
}

Storage Default
{
<Data name="CommunityNewBirthStaServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.CommunityNewAE1D</DataLocation>
<DefaultData>CommunityNewBirthStaServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.CommunityNewAE1D</IdLocation>
<IndexLocation>^CHSSWeb.CommunityNewAE1I</IndexLocation>
<StreamLocation>^CHSSWeb.CommunityNewAE1S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
