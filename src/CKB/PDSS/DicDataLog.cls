Class CKB.PDSS.DicDataLog Extends (%Persistent, User.Abstract) [ SqlRowIdName = DDL_RowID, SqlTableName = DicDataLog ]
{

/// 日志父表
Property DDLLog As %String [ SqlColumnNumber = 2, SqlFieldName = DDL_Log ];

/// 药品ID
Property DDLEntyID As %String [ SqlColumnNumber = 3, SqlFieldName = DDL_EntyID ];

/// 药品属性ID
Property DDLAttrID As %String [ SqlColumnNumber = 4, SqlFieldName = DDL_AttrID ];

/// 修改内容
Property DDLDicValue As %String(MAXLEN = 50000) [ SqlColumnNumber = 5, SqlFieldName = DDL_DicValue ];

/// 对应上次的日志id
Property DDLLastDataLog As %String [ SqlColumnNumber = 6, SqlFieldName = DDL_LastDataLog ];

Index IndexEntyIDAttrID On (DDLEntyID As Exact, DDLAttrID As Exact);

Index IndexLogID On DDLLog As Exact;

Storage Default
{
<Data name="DicDataLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DDLLog</Value>
</Value>
<Value name="3">
<Value>DDLEntyID</Value>
</Value>
<Value name="4">
<Value>DDLAttrID</Value>
</Value>
<Value name="5">
<Value>DDLDicValue</Value>
</Value>
<Value name="6">
<Value>DDLLastDataLog</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.DicDataLogD</DataLocation>
<DefaultData>DicDataLogDefaultData</DefaultData>
<IdLocation>^CKB.PDSS.DicDataLogD</IdLocation>
<IndexLocation>^CKB.PDSS.DicDataLogI</IndexLocation>
<StreamLocation>^CKB.PDSS.DicDataLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
