Class User.EnsInterfaceMethodItem Extends (%Persistent, %XML.Adaptor) [ SqlTableName = Ens_InterfaceMethodItem ]
{

/// 方法列表
Property childMethodDr As User.EnsInterfaceMethod [ SqlColumnNumber = 2, SqlFieldName = child_Method_Dr ];

/// 方法序号
Property methodSeqNo As %String(MAXLEN = 5) [ SqlColumnNumber = 3, SqlFieldName = method_SeqNo ];

Relationship EnsMethdItemRef As User.EnsInterfaceMethod [ Cardinality = parent, Inverse = ChildEnsMethdItem, Required ];

Index MethodCode On (EnsMethdItemRef, childMethodDr) [ Unique ];

Storage Default
{
<Data name="EnsInterfaceMethodItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>childMethodDr</Value>
</Value>
<Value name="3">
<Value>methodSeqNo</Value>
</Value>
</Data>
<DataLocation>^User.EnsInterfaceMethodItemD</DataLocation>
<DefaultData>EnsInterfaceMethodItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.EnsInterfaceMethodItemD</IdLocation>
<IndexLocation>^User.EnsInterfaceMethodItemI</IndexLocation>
<StreamLocation>^User.EnsInterfaceMethodItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
