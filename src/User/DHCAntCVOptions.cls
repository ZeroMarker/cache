Class User.DHCAntCVOptions Extends %Persistent [ SqlTableName = DHC_AntCVOptions ]
{

Index OptTypeCode On (CVOptType, CVOptCode) [ IdKey ];

/// 配置类型  Base(基础配置) CVType(危急值类型) 
Property CVOptType As %String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = CVOpt_Type ];

Property CVOptCode As %String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = CVOpt_Code ];

Property CVOptValue As %String(COLLATION = "Exact", MAXLEN = 2000) [ SqlColumnNumber = 4, SqlFieldName = CVOpt_Value ];

Property CVOptNote As %String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = CVOpt_Note ];

/// 顺序
Property CVOptSeq As %String [ SqlColumnNumber = 6, SqlFieldName = CVOpt_Seq ];

Storage Default
{
<Data name="DHCAntCVOptionsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CVOptValue</Value>
</Value>
<Value name="3">
<Value>CVOptNote</Value>
</Value>
<Value name="4">
<Value>CVOptSeq</Value>
</Value>
</Data>
<DataLocation>^User.DHCAntCVOptionsD</DataLocation>
<DefaultData>DHCAntCVOptionsDefaultData</DefaultData>
<IdLocation>^User.DHCAntCVOptionsD</IdLocation>
<IndexLocation>^User.DHCAntCVOptionsI</IndexLocation>
<StreamLocation>^User.DHCAntCVOptionsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
