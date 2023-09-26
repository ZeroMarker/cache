/// Function: 码表数据日志管理
/// Creator:  sunfengchao
Class User.BDPDataChangeLog Extends (%Persistent, %XML.Adaptor) [ SqlTableName = BDP_DataChangeLog ]
{

/// 表名称，写入的是BDP_DataChangeLog
Property TableName As %String(MAXLEN = "") [ Required ];

/// 表对应的类名称
Property ClassName As %String(MAXLEN = "") [ Required ];

/// 对象的RowID或者表的RowID， 修改任何数据，都要有这个ID，即修正数据才写日志
Property ObjectReference As %String(MAXLEN = "") [ Required ];

/// 更新用户，这个一定去session信息
Property UpdateUserDR As User.SSUser [ Required ];

/// 修改数据的用户名称
Property UpdateUserName As %String(MAXLEN = "");

/// 更新日期
Property UpdateDate As %Date [ InitialExpression = {+$h}, Required ];

Property UpdateTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required ];

/// 操作类型, 主要用来保存Update和Delete的数据,加入新增数据
Property OperateType As %String(DISPLAYLIST = ",Add,Read,Update,Delete", VALUELIST = ",A,R,U,D") [ Required ];

/// 修正的、删除的、新增的数据
Property NewValue As %String(MAXLEN = "");

/// 对应表的中文描述、与数据结构中的描述一致
Property ClassNameDesc As %String(MAXLEN = "");

/// 对应--修正、新增、删除数据的描述
Property ObjectDesc As %String(MAXLEN = "");

/// 操作用户的Ip地址
Property IpAddress As %String(MAXLEN = "");

/// 修正前的原始数据  2014-8-16 
Property OldValue As %String(MAXLEN = "");

///  有关联关系的数据关联Key,存储一个自增的数字
Property RelevantKey As %String(MAXLEN = "");

/// 按数据描述查询
Index ObjDesIdx On ObjectDesc As Exact;

Index TableNameIndex On TableName;

Index ClassNameIndex On ClassName;

/// 修正日期的索引
Index UpdateDateIndex On UpdateDate;

/// 操作类型的索引
Index OperateTypeIndex On OperateType;

Storage Default
{
<Data name="BDPDataChangeLogDefaultData">
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
<Value name="13">
<Value>IpAddress</Value>
</Value>
<Value name="14">
<Value>OldValue</Value>
</Value>
<Value name="15">
<Value>RelevantKey</Value>
</Value>
</Data>
<DataLocation>^User.BDPDataChangeLogD</DataLocation>
<DefaultData>BDPDataChangeLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.BDPDataChangeLogD</IdLocation>
<IndexLocation>^User.BDPDataChangeLogI</IndexLocation>
<StreamLocation>^User.BDPDataChangeLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
