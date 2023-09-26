/// 名称: 动态查询数据
/// 描述: 
/// 参数： TableName:传入所要查询的表名
///        Fields: 查询的字段，格式 Col1||分割符||Col2 ...
/// 返回查询，将所有字段合并成一个字段
/// 编写者：yejian
/// 编写日期: 2013-4-24
Class CT.WS.dao.DQueryDynTable Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Debug:	d ##Class(%ResultSet).RunQuery("CT.WS.dao.DQueryDynTable", "QueryByConfig", "CT.WS.CustomDictionary","ID,CtmDictAlias,CtmDictCode,CtmDictComment,CtmDictDesc,CtmDictLink,CtmDictLinkCode,CtmDictOther,CtmDictRef"," AND CtmDictLink='two' AND CtmDictOther='into'","@@","0","25")
Query QueryByConfig(TableName As %String, Fields As %String, Filter As %String, Spliter As %String, Index As %Integer, PageSize As %Integer) As %Query(ROWSPEC = "RowData:%String")
{
}

ClassMethod QueryByConfigExecute(ByRef qHandle As %Binary, TableName As %String, Fields As %String, Filter As %String, Spliter As %String, Index As %String, PageSize As %String) As %Status
{
 
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	q:(TableName="") $$$OK
	q:(Fields="") $$$OK
	q:(Spliter="") $$$OK
	
    s sql = "SELECT "_Fields_" FROM "_TableName_" WHERE ID > "_Index
    
    if (Filter'="")
    {
	    s sql = sql_Filter
	}
   
    s sql = sql_" ORDER BY ID"
    s ^CacheTemp("sql")=sql
	s resultSet = ##class(%Library.ResultSet).%New()
    d resultSet.Prepare(sql)
    d resultSet.Execute()
    s count = 0
	while(resultSet.Next())
    {
      s count=$Length(Fields, ",")
      s row=""
	  f i=1:1:count 
	  {
		s field = $Piece(Fields, ",", i)
		if (i=1)
		{
			s row = resultSet.Data(field)
		} 
		else
		{
			s row = row_Spliter_resultSet.Data(field)
		}    
	  }
	  s ^CacheTemp(repid,ind) = $lb(row)
      s ind = ind + 1 
      s count = count + 1  
      if (count = PageSize)
      {
	      Break
      }
    }
	
	q $$$OK
}

ClassMethod QueryByConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByConfigExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" 
 	{	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid) 
 	} 
 	else 
 	{
 		s Row=^CacheTemp(repid,ind)
 	}
 	
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod QueryByConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByConfigExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

Query SelectAll() As %SQLQuery(ROWSPEC = "ID:%String, TableName:%String, ConfigName:%String, Fields:%String, IniValue:%String")
{
	SELECT ID,TableName,ConfigName,Fields,IniValue
	FROM CT_WS.DynamicConfigTable
	ORDER BY ID
}

Query SelectAllbyTableName() As %SQLQuery(ROWSPEC = "ID:%String, TableName:%String, ConfigName:%String, Fields:%String, IniValue:%String")
{
	SELECT ID,%exact(TableName),ConfigName,Fields,IniValue
	FROM CT_WS.DynamicConfigTable
	GROUP BY TableName
	ORDER BY ID
}

Storage Default
{
<Data name="DQueryDynTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CT.WS.dao.DQueryDynTableD</DataLocation>
<DefaultData>DQueryDynTableDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CT.WS.dao.DQueryDynTableD</IdLocation>
<IndexLocation>^CT.WS.dao.DQueryDynTableI</IndexLocation>
<StreamLocation>^CT.WS.dao.DQueryDynTableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
