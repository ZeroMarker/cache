/// Creater:wangpf
/// Descriptions:PDA执行率子表
/// Date:2021-11-10
Class DHCINM.Work.MgWorkPdaDaySub Extends %Persistent
{

Relationship Paref As DHCINM.Work.MgWorkPdaDay [ Cardinality = parent, Inverse = ChildSub ];

Property SubType As %String [ SqlColumnNumber = 2, SqlFieldName = SubType ];

/// 用电脑端执行数量
Property Pc As %Integer [ SqlColumnNumber = 3, SqlFieldName = Pc ];

/// 用pda执行的数量
Property Pda As %Integer [ SqlColumnNumber = 4, SqlFieldName = Pda ];

/// 用pda手工执行的数量
Property PdaMan As %Integer [ SqlColumnNumber = 5, SqlFieldName = PdaMan ];

/// 未执行的数量(停止、撤销都算在此)
Property NotX As %Integer [ SqlColumnNumber = 6, SqlFieldName = NotX ];

Storage Default
{
<Data name="MgWorkPdaDaySubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SubType</Value>
</Value>
<Value name="3">
<Value>Pc</Value>
</Value>
<Value name="4">
<Value>Pda</Value>
</Value>
<Value name="5">
<Value>PdaMan</Value>
</Value>
<Value name="6">
<Value>NotX</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Work.MgWorkPdaDaySubD</DataLocation>
<DefaultData>MgWorkPdaDaySubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCINM.Work.MgWorkPdaDaySubI</IndexLocation>
<StreamLocation>^DHCINM.Work.MgWorkPdaDaySubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
