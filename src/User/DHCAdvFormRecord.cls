/// 表单记录主表
/// zhouxin
/// 2017-09-20
Class User.DHCAdvFormRecord Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_AdvFormRecord ]
{

// 表单信息表ID

Property formName As User.DHCAdvFormName [ SqlColumnNumber = 2, SqlFieldName = formName ];

// 表单版本

Property formVersion As %String [ SqlColumnNumber = 3, SqlFieldName = formVersion ];

// 创建日期

Property createDate As %Date [ InitialExpression = {+$p($h,",",1)}, SqlColumnNumber = 4, SqlFieldName = createDate ];

// 创建时间

Property createTime As %Time [ InitialExpression = {+$p($h,",",2)}, SqlColumnNumber = 5, SqlFieldName = createTime ];

// 创建人

Property createUser As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = createUser ];

// 更新日期

Property updateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = updateDate ];

// 更新时间

Property updateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = updateTime ];

// 关联表单记录ID	DHC_AdvFormRecord此字段存储的为此表单记录关联的表单记录数据id

Property LinkRecordId As User.DHCAdvFormRecord [ SqlColumnNumber = 9, SqlFieldName = LinkRecordId ];

Storage Default
{
<Data name="DHCAdvFormRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>formName</Value>
</Value>
<Value name="3">
<Value>formVersion</Value>
</Value>
<Value name="4">
<Value>createDate</Value>
</Value>
<Value name="5">
<Value>createTime</Value>
</Value>
<Value name="6">
<Value>createUser</Value>
</Value>
<Value name="7">
<Value>updateDate</Value>
</Value>
<Value name="8">
<Value>updateTime</Value>
</Value>
<Value name="9">
<Value>LinkRecordId</Value>
</Value>
</Data>
<DataLocation>^User.DHCAdvFormRecordD</DataLocation>
<DefaultData>DHCAdvFormRecordDefaultData</DefaultData>
<IdLocation>^User.DHCAdvFormRecordD</IdLocation>
<IndexLocation>^User.DHCAdvFormRecordI</IndexLocation>
<StreamLocation>^User.DHCAdvFormRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index IndexFormName On formName As AlphaUp;

Index IndexDate On createDate;

/// d ##class(User.DHCAdvFormRecord).%BuildIndices($ListBuild("IndexLink"))
Index IndexLink On LinkRecordId;

}
