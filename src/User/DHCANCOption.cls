Class User.DHCANCOption Extends %Persistent [ Owner = {_PUBLIC}, SqlTableName = DHC_ANC_Option ]
{

Property Code As %String [ Required ];

Property Name As %String;

Property Note As %String;

Index CodeIndex On Code As Exact [ SqlName = Code ];

ClassMethod Add(code, name)
{
	// w ##class(User.DHCANCOption).Add(code,name)
	q:code="" "code is NULL"
	s rowId=""
	s rowId=$O(^User.DHCANCOptionI("CodeIndex",code,rowId))
	
	i rowId="" d
	.s obj=##class(User.DHCANCOption).%New()
	.s obj.Code=code
	.s obj.Name=name
	.d obj.%Save()
	.s rowId=obj.%Id()
	q rowId
}

ClassMethod Delete(RowId)
{
	s RowId=$g(RowId)
	q:RowId="" "id为空"
	s obj = ##class(User.DHCANCOption).%OpenId(RowId)
	q:'$l(obj) "对象未找到"
	s sc=obj.%DeleteId(RowId)
	i $$$ISERR(sc){
		q "删除错误" 
	}else{
		q "删除成功"
	}
}

Storage Default
{
<Data name="DHCANCOptionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Note</Value>
</Value>
</Data>
<DataLocation>^User.DHCANCOptionD</DataLocation>
<DefaultData>DHCANCOptionDefaultData</DefaultData>
<IdLocation>^User.DHCANCOptionD</IdLocation>
<IndexLocation>^User.DHCANCOptionI</IndexLocation>
<StreamLocation>^User.DHCANCOptionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
