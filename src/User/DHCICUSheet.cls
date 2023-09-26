/// 重症表单
Class User.DHCICUSheet Extends %Library.Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DHC_ICU_Sheet ]
{

Property ICUArrange As User.DHCICUArrange [ Required, SqlColumnNumber = 2 ];

/// 最后更新用户
Property UpdateUser As %String [ SqlColumnNumber = 3 ];

Property UpdateDate As %Date [ SqlColumnNumber = 4 ];

Property UpdateTime As %Time [ SqlColumnNumber = 5 ];

Property Status As %String(DISPLAYLIST = ",新建,提交,归档", VALUELIST = ",N,S,A") [ SqlColumnNumber = 6 ];

/// 文档新建用户
Property CreateUser As %String [ SqlColumnNumber = 7 ];

Property CreateDate As %Date [ SqlColumnNumber = 8 ];

Property CreateTime As %Time [ SqlColumnNumber = 9 ];

/// 文档提交用户
Property SubmitUser As %String [ SqlColumnNumber = 10 ];

Property SubmitDate As %Date [ SqlColumnNumber = 11 ];

Property SubmitTime As %Time [ SqlColumnNumber = 12 ];

/// 文档归档用户
Property ArchiveUser As %String [ SqlColumnNumber = 13 ];

Property ArchiveDate As %Date [ SqlColumnNumber = 14 ];

Property ArchiveTime As %Time [ SqlColumnNumber = 15 ];

/// 归档文件路径+文件名.pdf
Property ArchivePath As %String(MAXLEN = 200) [ SqlColumnNumber = 16 ];

/// 数据模块
Property ICUCModule As User.DHCICUCModule [ Required, SqlColumnNumber = 17 ];

Index ICUA On ICUArrange;

/// 数据项外键约束
ForeignKey FKICUArrange(ICUArrange) References User.DHCICUArrange() [ OnDelete = cascade ];

Storage Default
{
<Data name="DHCICUSheetDefaultData">
<Value name="1">
<Value>ICUArrange</Value>
</Value>
<Value name="2">
<Value>UpdateUser</Value>
</Value>
<Value name="3">
<Value>UpdateDate</Value>
</Value>
<Value name="4">
<Value>UpdateTime</Value>
</Value>
<Value name="5">
<Value>Status</Value>
</Value>
<Value name="6">
<Value>CreateUser</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>CreateTime</Value>
</Value>
<Value name="9">
<Value>SubmitUser</Value>
</Value>
<Value name="10">
<Value>SubmitDate</Value>
</Value>
<Value name="11">
<Value>SubmitTime</Value>
</Value>
<Value name="12">
<Value>ArchiveUser</Value>
</Value>
<Value name="13">
<Value>ArchiveDate</Value>
</Value>
<Value name="14">
<Value>ArchiveTime</Value>
</Value>
<Value name="15">
<Value>ArchivePath</Value>
</Value>
<Value name="16">
<Value>ICUCModule</Value>
</Value>
</Data>
<DataLocation>^User.DHCICUSheetD</DataLocation>
<DefaultData>DHCICUSheetDefaultData</DefaultData>
<IdLocation>^User.DHCICUSheetD</IdLocation>
<IndexLocation>^User.DHCICUSheetI</IndexLocation>
<StreamLocation>^User.DHCICUSheetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
