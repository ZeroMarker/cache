/// 表格类管理
Class DHCNMG.Set.MgColumns Extends %Persistent
{

Relationship Parref As DHCNMG.Set.MgTable [ Cardinality = parent, Inverse = ColChildSub ];

/// 列表头
Property ColumnHeader As %String [ SqlColumnNumber = 4, SqlFieldName = Column_Header ];

/// dataIndex
Property ColumnIndex As %String [ SqlColumnNumber = 5, SqlFieldName = Column_Index ];

/// 宽度
Property ColumnWidth As %Integer [ SqlColumnNumber = 6, SqlFieldName = Column_Width ];

/// 是否隐藏
Property ColumnHidden As %Boolean [ SqlColumnNumber = 7, SqlFieldName = Column_Hidden ];

/// 显示顺序
Property ColumnOrder As %Integer [ SqlColumnNumber = 8, SqlFieldName = Column_Order ];

/// 排序优先级
Property ColumnSort As %Integer [ SqlColumnNumber = 9, SqlFieldName = Column_Sort ];

/// 是否锁定
Property ColumnLock As %Boolean [ SqlColumnNumber = 10, SqlFieldName = Column_Lock ];

Index Order On ColumnOrder;

Storage Default
{
<Data name="MgColumnsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ColumnHeader</Value>
</Value>
<Value name="3">
<Value>ColumnIndex</Value>
</Value>
<Value name="4">
<Value>ColumnWidth</Value>
</Value>
<Value name="5">
<Value>ColumnHidden</Value>
</Value>
<Value name="6">
<Value>ColumnOrder</Value>
</Value>
<Value name="7">
<Value>ColumnSort</Value>
</Value>
<Value name="8">
<Value>ColumnLock</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Set.MgColumnsD</DataLocation>
<DefaultData>MgColumnsDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ColChildSub")</IdLocation>
<IndexLocation>^DHCNMG.Set.MgColumnsI</IndexLocation>
<StreamLocation>^DHCNMG.Set.MgColumnsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
