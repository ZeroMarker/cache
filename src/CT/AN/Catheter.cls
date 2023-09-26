/// 导管
Class CT.AN.Catheter Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = Catheter ]
{

/// 导管代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 导管名称
Property Description As %String [ Required, SqlColumnNumber = 3 ];

/// 麻醉方法
Property AnaMethod As %String [ SqlColumnNumber = 4 ];

/// 麻醉类型
Property AnaType As %String [ SqlColumnNumber = 5 ];

/// 排序号
Property SeqNo As %Integer [ SqlColumnNumber = 6 ];

/// 激活日期
Property ActiveDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 8 ];

/// 激活状态
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 9 ];

/// 麻醉方法索引
Index IAnaMethod On AnaMethod;

/// 麻醉类型索引
Index IAnaType On AnaType;

Index ICode On Code [ Unique ];

Storage Default
{
<Data name="CatheterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>AnaMethod</Value>
</Value>
<Value name="5">
<Value>AnaType</Value>
</Value>
<Value name="6">
<Value>SeqNo</Value>
</Value>
<Value name="7">
<Value>ActiveDate</Value>
</Value>
<Value name="8">
<Value>ExpireDate</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^CT.AN.CatheterD</DataLocation>
<DefaultData>CatheterDefaultData</DefaultData>
<IdLocation>^CT.AN.CatheterD</IdLocation>
<IndexLocation>^CT.AN.CatheterI</IndexLocation>
<StreamLocation>^CT.AN.CatheterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
