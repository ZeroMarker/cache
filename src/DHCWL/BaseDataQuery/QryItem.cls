/// d ##class(DHCWL.BaseDataQuery.QryItem).%BuildIndices()
Class DHCWL.BaseDataQuery.QryItem Extends %Persistent
{

/// 指向QryObj（查询对象）
Property QryObjDr As QryObj;

/// 编码,直接把数据源的编码作为查询项的编码，所以编码有可能会重复。
Property Code As %String(COLLATION = "EXACT");

/// 名称
Property Name As %String(COLLATION = "EXACT");

/// 描述
Property Descript As %String(COLLATION = "EXACT");

/// 类型，包括：维度还是度量
Property Type As %String(COLLATION = "EXACT");

/// 创建类型，包括：自定义还是程序创建
Property CreateType As %String(COLLATION = "EXACT");

/// 表达式。用于自定义创建出来的Item，保存这个Item的取数表达式和/或参数
Property Exp As %String(COLLATION = "EXACT", MAXLEN = 200);

/// 数据类型，包括：日期，整形，字符串等等。该字段必须加在这个表中，因为这个
/// 表还会保存自定义的维度和度量。
/// BINARY,DATE,DOUBLE,HANDLE,INTEGER,LIST,LONGVARCHAR,TIME,TIMESTAMP,VARCHAR,STATUS,BINARYSTREAM,CHARACTERSTREAM,NUMERIC,CURRENCY,BOOLEAN,OID,BIGINT,FDATE,FTIMESTAMP
Property DataType As %String(COLLATION = "EXACT");

Index InxQryObjAndType On (QryObjDr, Type);

Index InxCode On (QryObjDr, Code);

ClassMethod Insert(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""	
	
	s qryObj=##class(QryObj).GetById(inParam("ROWID"))
	s itemCodes=inParam("itemCodes")
	s len=$l(itemCodes,"^")	
	f i=1:1:len {
		s newObj=##class(QryItem).%New()
		s newObj.QryObjDr=qryObj
		s newObj.Code=$p(inParam("itemCodes"),"^",i)
		s newObj.Name=$p(inParam("itemNames"),"^",i)					
		s newObj.Descript=$p(inParam("itemDescripts"),"^",i)
		s newObj.Type=$p(inParam("itemTypes"),"^",i)
		s newObj.CreateType=$p(inParam("itemCreateT"),"^",i)
		s newObj.Exp=$p(inParam("itemExps"),"^",i)
		s newObj.DataType=$p(inParam("itemDataTypes"),"^",i)
		

		s sc=newObj.%Save()
		If $$$ISERR(sc) {
			s ret="新建统计项失败:"_$System.Status.GetErrorText(sc)
			q
	 	}
	 	d newObj.%Close()
	}

	q ret

SQLErr
	if ret="" s ret="新建统计项失败:"_$ZERROR
	q ret
}

ClassMethod InsertCustomMetrics(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""	
	
	s qryObj=##class(QryObj).GetById(inParam("ROWID"))
	s newObj=##class(QryItem).%New()
	s newObj.QryObjDr=qryObj
	s newObj.Code=inParam("Code")
	s newObj.Name=inParam("Name")					
	s newObj.Descript=inParam("Descript")
	s newObj.Type="度量"
	s newObj.CreateType="自定义"
	s newObj.Exp=inParam("Exp")
	s newObj.DataType="number"
		
	s sc=newObj.%Save()
	If $$$ISERR(sc) {
		s ret="新建查询项失败:"_$System.Status.GetErrorText(sc)
		q
	}
 	d newObj.%Close()

	q ret

SQLErr
	if ret="" s ret="新建查询项失败:"_$ZERROR
	q ret
}

ClassMethod UpdateCustomMetrics(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""	
	
	s itemObj=##class(QryItem).%OpenId(inParam("ItemID"))
	//s newObj.QryObjDr=qryObj
	s itemObj.Code=inParam("Code")
	s itemObj.Name=inParam("Name")					
	s itemObj.Descript=inParam("Descript")
	//s newObj.Type="度量"
	//s newObj.CreateType="自定义"
	s itemObj.Exp=inParam("Exp")
	//s newObj.DataType="number"
		
	s sc=itemObj.%Save()
	If $$$ISERR(sc) {
		s ret="更新查询项失败:"_$System.Status.GetErrorText(sc)
		q
	}
 	d itemObj.%Close()

	q ret

SQLErr
	if ret="" s ret="更新查询项失败:"_$ZERROR
	q ret
}

ClassMethod Update(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""	
	s itemObj=##class(QryItem).%OpenId(inParam("ID"))
	
	s itemObj.Name=inParam("Name")					//把主题维度的编码作为查询对象的名称
	s itemObj.Descript=inParam("Descript")

	s sc=itemObj.%Save()
	If $$$ISERR(sc) {
		s ret="更新统计项失败:"_$System.Status.GetErrorText(sc)
		q
 	}
 	d itemObj.%Close()
	q ret

SQLErr
	if ret="" s ret="更新统计项失败:"_$ZERROR
	q ret
}

/// s list=##class(DHCWL.BaseDataQuery.QryItem).GetItems(1,"维度")
/// s list=##class(DHCWL.BaseDataQuery.QryItem).GetItemss(1,"度量")
ClassMethod GetItems(QryObjID As %String, type As %String) As %ListOfObjects
{
	s list=##class(%ListOfObjects).%New()
	
	q:QryObjID="" list
	q:'$d(^DHCWL.BaseDataQuery.QryItemI("InxQryObjAndType",QryObjID)) list
	q:'$d(^DHCWL.BaseDataQuery.QryItemI("InxQryObjAndType",QryObjID,type)) list
	s id=""
	f{
	  s id=$o(^DHCWL.BaseDataQuery.QryItemI("InxQryObjAndType",QryObjID,type,id))
	  q:id=""
	  s obj=##class(QryItem).%OpenId(id)
	  continue:obj=""
	  d list.Insert(obj)
	}	
	q list
}

ClassMethod GetByCode(QryObjID As %String, Code As %String) As QryItem
{
	q:QryObjID="" ""
	q:'$d(^DHCWL.BaseDataQuery.QryItemI("InxCode",QryObjID)) ""
	q:'$d(^DHCWL.BaseDataQuery.QryItemI("InxCode",QryObjID,Code)) ""
  	s id=$o(^DHCWL.BaseDataQuery.QryItemI("InxCode",QryObjID,Code,""))
	q:id="" ""
	q ##class(QryItem).%OpenId(id)
}

ClassMethod DelByQryID(qryID As %String) As %String
{
	s $zt="SQLErr"
	s ret=""	

	&sql(DELETE FROM DHCWL_BaseDataQuery.QryItem WHERE QryObjDr=:qryID)
	
	if SQLCODE'=0 && (SQLCODE'=100) s ret="删除查询对象失败，SQLCODE DESC="_$SYSTEM.SQL.SQLCODE(SQLCODE)
	q ret

SQLErr
	if ret="" s ret="删除查询对象失败:"_$ZERROR
	q ret
}

ClassMethod BeUsedByRpt(itemID As %String) As %String
{
	s $zt="SQLErr"
	s ret=""	

	s itemObj=##class(QryItem).%OpenId(itemID)
	
	s code=itemObj.Code				
	
	s qryName="%DynamicQuery:SQL"  //固定写法
	s sql="select DISTINCT rptDr->Name as Name from DHCWL_BaseDataQuery.RptItem where code='"_code_"'"

	s rs=##class(%Library.ResultSet).%New()
	
	d rs.Prepare(sql)
	d rs.Execute()
	While(rs.Next()){ 
		s Name=rs.Data("Name")
		if ret'="" s ret=ret_","_Name
		else  s ret=Name
	}

	q ret

SQLErr
	if ret="" s ret="删除查询对象失败:"_$ZERROR
	q ret
}

Storage Default
{
<Data name="QryItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QryObjDr</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>Descript</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
<Value name="7">
<Value>CreateType</Value>
</Value>
<Value name="8">
<Value>Exp</Value>
</Value>
<Value name="9">
<Value>DataType</Value>
</Value>
</Data>
<DataLocation>^DHCWL.BaseDataQuery.QryItemD</DataLocation>
<DefaultData>QryItemDefaultData</DefaultData>
<IdLocation>^DHCWL.BaseDataQuery.QryItemD</IdLocation>
<IndexLocation>^DHCWL.BaseDataQuery.QryItemI</IndexLocation>
<StreamLocation>^DHCWL.BaseDataQuery.QryItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
