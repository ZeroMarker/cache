/// 操作功能
Class CT.AN.OperAction Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OperAction ]
{

/// 操作功能代码
Property Code As %String(MAXLEN = 100) [ Required, SqlColumnNumber = 2 ];

/// 操作功能名称
Property Description As %String [ Required, SqlColumnNumber = 3 ];

/// 操作功能所属的模块
Property DataModule As CT.AN.DataModule [ Required, SqlColumnNumber = 4 ];

/// 操作功能所属的元素ID
Property ElementID As %String [ SqlColumnNumber = 5 ];

/// 操作功能的按钮图标
Property Icon As %String [ SqlColumnNumber = 6 ];

/// 操作功能执行时，调用的JS函数
Property ExecFunc As %String(MAXLEN = 100) [ Required, SqlColumnNumber = 7 ];

/// 操作功能执行时，链接访问的模块
Property LinkModule As CT.AN.DataModule [ SqlColumnNumber = 8 ];

/// 操作功能按钮的容器元素
Property Container As %String [ SqlColumnNumber = 9 ];

/// 操作功能按钮的显示顺序
Property Seq As %String [ SqlColumnNumber = 10 ];

/// 数据模块索引
Index IDataModule On DataModule;

/// 操作功能代码唯一性约束
Index ICode On Code [ Unique ];

/// 数据项外键约束
ForeignKey FKDataModule(DataModule) References CT.AN.DataModule() [ OnDelete = cascade ];

Storage Default
{
<Data name="OperActionDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>DataModule</Value>
</Value>
<Value name="4">
<Value>ElementID</Value>
</Value>
<Value name="5">
<Value>Icon</Value>
</Value>
<Value name="6">
<Value>ExecFunc</Value>
</Value>
<Value name="7">
<Value>LinkModule</Value>
</Value>
<Value name="8">
<Value>Container</Value>
</Value>
<Value name="9">
<Value>Seq</Value>
</Value>
</Data>
<DataLocation>^CT.AN.OperActionD</DataLocation>
<DefaultData>OperActionDefaultData</DefaultData>
<IdLocation>^CT.AN.OperActionD</IdLocation>
<IndexLocation>^CT.AN.OperActionI</IndexLocation>
<StreamLocation>^CT.AN.OperActionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
