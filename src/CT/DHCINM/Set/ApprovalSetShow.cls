/// Creator:lulin
/// Descriptions:审批显示/通知表头
/// Date:2021-06-07
Class CT.DHCINM.Set.ApprovalSetShow Extends %Persistent
{

Relationship Parref As CT.DHCINM.Set.ApprovalSet [ Cardinality = parent, Inverse = Show, Required ];

/// 描述
Property ShowDesc As %String [ SqlColumnNumber = 2, SqlFieldName = ShowDesc ];

/// Global位置
Property ShowNum As %String [ SqlColumnNumber = 3, SqlFieldName = ShowNum ];

/// 显示位置
Property ShowSort As %Integer [ SqlColumnNumber = 4, SqlFieldName = ShowSort ];

/// 显示宽度
Property ShowWidth As %String [ SqlColumnNumber = 5, SqlFieldName = ShowWidth ];

/// 类型【D日期，T时间、S字符串、P外键】
Property ShowType As %String [ SqlColumnNumber = 6, SqlFieldName = ShowType ];

/// 外键
Property Foreignkey As list Of %String [ SqlColumnNumber = 7, SqlFieldName = Foreignkey ];

/// 消息追踪数据保存位置
Property NoticeSort As %Integer [ SqlColumnNumber = 8, SqlFieldName = NoticeSort ];

/// 状态
Property ShowStatus As %String [ SqlColumnNumber = 9, SqlFieldName = ShowStatus ];

/// 键值对
Property ShowKeyOption As %String(MAXLEN = 300) [ SqlColumnNumber = 10, SqlFieldName = ShowKeyOption ];

Index sort On (Parref, ShowSort);

Storage Default
{
<Data name="ApprovalSetShowDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ShowDesc</Value>
</Value>
<Value name="3">
<Value>ShowNum</Value>
</Value>
<Value name="4">
<Value>ShowSort</Value>
</Value>
<Value name="5">
<Value>ShowWidth</Value>
</Value>
<Value name="6">
<Value>ShowType</Value>
</Value>
<Value name="7">
<Value>Foreignkey</Value>
</Value>
<Value name="8">
<Value>NoticeSort</Value>
</Value>
<Value name="9">
<Value>ShowStatus</Value>
</Value>
<Value name="10">
<Value>ShowKeyOption</Value>
</Value>
</Data>
<DataLocation>^CT.DHCINM.Set.ApprovalSetShowD</DataLocation>
<DefaultData>ApprovalSetShowDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Show")</IdLocation>
<IndexLocation>^CT.DHCINM.Set.ApprovalSetShowI</IndexLocation>
<StreamLocation>^CT.DHCINM.Set.ApprovalSetShowS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
