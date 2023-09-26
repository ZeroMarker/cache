Class User.DHCANCOptionItem Extends %Persistent [ Owner = {_PUBLIC}, SqlTableName = DHC_ANC_OptionItem ]
{

Property TypeId As User.DHCANCOption [ SqlColumnNumber = 2 ];

Property Code As %String [ Required ];

Property Name As %String;

Property Note As %String;

Index TypeIdIndex On TypeId;

// 添加字符串类型的选项

// eg. w ##class(User.DHCANCOptionItem).AddItemByString("Cardiovascular","心血管系统","胸痛;心悸;瓣腊病变;杂音;高血压;心梗;易疲劳;气紧")

ClassMethod AddItemByString(mainCode, mainName, str)
{
	// w ##class(User.DHCANCOptionItem).AddItemByString(mainCode,mainName,str)
	b
	s len=$L(str,";")
	s i=1 f i=1:1:len d
	.s name=$p(str,";",i)
	.d ..AddItem(mainCode,mainName,name,name)
	q "Over"
}

ClassMethod AddItem(mainCode, mainName, code, name)
{
	// w ##class(User.DHCANCOptionItem).AddItem(mainCode,mainName,code,name)
	s mainRowId=##class(User.DHCANCOption).Add(mainCode,mainName)
	q:mainRowId<=0 "Add Option Failed"
	q ..Add(mainRowId,code,name)
}

ClassMethod Add(mainId, code, name)
{
	// w ##class(User.DHCANCOptionItem).Add(mainId,code,name)
	q:code="" "code is NULL"
	s rowId=""
	s rowId=$O(^User.DHCCLOptionI("CodeIndex",code,rowId))
	
	i rowId="" d
	.s obj=##class(User.DHCANCOptionItem).%New()
	.s obj.TypeId=##Class(User.DHCANCOption).%OpenId(mainId)
	.s obj.Code=code
	.s obj.Name=name
	.d obj.%Save()
	.s rowId=obj.%Id()
	q rowId
}

/// w ##class(User.DHCANCOptionItem).Delete(294)
ClassMethod Delete(RowId)
{
	s RowId=$g(RowId)
	q:RowId="" "id为空"
	s obj = ##class(User.DHCANCOptionItem).%OpenId(RowId)
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
<Data name="DHCANCOptionItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TypeId</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>Note</Value>
</Value>
</Data>
<DataLocation>^User.DHCANCOptionItemD</DataLocation>
<DefaultData>DHCANCOptionItemDefaultData</DefaultData>
<IdLocation>^User.DHCANCOptionItemD</IdLocation>
<IndexLocation>^User.DHCANCOptionItemI</IndexLocation>
<StreamLocation>^User.DHCANCOptionItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
