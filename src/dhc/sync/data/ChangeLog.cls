/// 码表数据日志管理
Class dhc.sync.data.ChangeLog Extends (%Persistent, %XML.Adaptor) [ SqlTableName = Sync_ChangeLog ]
{

//TableName ClassName ObjectReference UpdateUserDR UpdateUserName UpdateDate 

//UpdateTime OperateType NewValue ClassNameDesc ObjectDesc

/// 表名称，写入的是BDP_DataChangeLog
Property TableName As %String(MAXLEN = "") [ Required ];

Index TableNameIndex On TableName;

/// 表对应的类名称
Property ClassName As %String(MAXLEN = "") [ Required ];

Index ClassNameIndex On ClassName;

/// 对象的RowID或者表的RowID， 修改任何数据，都要有这个ID，即修正数据才写日志
Property ObjectReference As %String(MAXLEN = "");

/// 更新用户，这个一定去session信息
Property UpdateUserDR As User.SSUser [ Required ];

/// 修改数据的用户名称
Property UpdateUserName As %String(MAXLEN = "");

/// 更新日期
Property UpdateDate As %Date [ InitialExpression = {+$h}, Required ];

/// 取时分秒
Property UpdateTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required ];

/// 操作类型, 主要用来保存Update和Delete的数据,加入新增数据
Property OperateType As %String(DISPLAYLIST = ",Add,Read,Update,Delete,Import,Export", VALUELIST = ",A,R,U,D,I,E") [ Required ];

/// 修正的、删除的、新增的数据
Property NewValue As %String(MAXLEN = "");

/// 对应表的中文描述、与数据结构中的描述一致
Property ClassNameDesc As %String(MAXLEN = "");

/// 对应--修正、新增、删除数据的描述
Property ObjectDesc As %String(MAXLEN = "");

/// 按数据描述查询
Index ObjDesIdx On ObjectDesc As Exact;

Storage Default
{
<Data name="ChangeLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TableName</Value>
</Value>
<Value name="3">
<Value>ClassName</Value>
</Value>
<Value name="4">
<Value>ObjectReference</Value>
</Value>
<Value name="5">
<Value>UpdateUserDR</Value>
</Value>
<Value name="6">
<Value>UpdateUserName</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
<Value name="8">
<Value>UpdateTime</Value>
</Value>
<Value name="9">
<Value>OperateType</Value>
</Value>
<Value name="10">
<Value>NewValue</Value>
</Value>
<Value name="11">
<Value>ClassNameDesc</Value>
</Value>
<Value name="12">
<Value>ObjectDesc</Value>
</Value>
</Data>
<DataLocation>^dhcsyncChangeLogD</DataLocation>
<DefaultData>ChangeLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcsyncChangeLogD</IdLocation>
<IndexLocation>^dhcsyncChangeLogI</IndexLocation>
<StreamLocation>^dhcsyncChangeLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
