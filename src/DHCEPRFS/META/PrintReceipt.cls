Class DHCEPRFS.META.PrintReceipt Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 打印小票名称
Property PrintReceiptName As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 打印小票描述
Property PrintReceiptDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 创建者
Property CreateMRUserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 创建日期
Property CreateDate As %Date [ SqlColumnNumber = 5 ];

/// 创建时间
Property CreateTime As %Time [ SqlColumnNumber = 6 ];

/// 最后修改者
Property LastModifyMRUserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 7 ];

/// 最后修改日期
Property LastModifyDate As %Date [ SqlColumnNumber = 8 ];

/// 最后修改时间
Property LastModifyTime As %Time [ SqlColumnNumber = 9 ];

/// 打印小票模板内容
Property TempleContent As %String(MAXLEN = 1000000, TRUNCATE = 1) [ SqlColumnNumber = 10 ];

/// 是否默认
Property IsDefault As %String(TRUNCATE = 1) [ SqlColumnNumber = 11 ];

/// 类型 - CHARGE-收费小票 RECEIPT-收费凭据
Property Type As %String(TRUNCATE = 1) [ SqlColumnNumber = 12 ];

/// 背景图
Property BackgroundImage As %GlobalBinaryStream(LOCATION = "^DHCEPRFS.META.PrintReceiptS") [ SqlColumnNumber = 13 ];

Index IdxIsDefault On (Type, IsDefault);

Storage Default
{
<Data name="PrintReceiptDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PrintReceiptName</Value>
</Value>
<Value name="3">
<Value>PrintReceiptDesc</Value>
</Value>
<Value name="4">
<Value>CreateUserID</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
<Value name="7">
<Value>LastModifyUserID</Value>
</Value>
<Value name="8">
<Value>LastModifyDate</Value>
</Value>
<Value name="9">
<Value>LastModifyTime</Value>
</Value>
<Value name="10">
<Value>TempleConten</Value>
</Value>
<Value name="11">
<Value>IsDefault</Value>
</Value>
<Value name="12">
<Value>TempleContent</Value>
</Value>
<Value name="13">
<Value>CreateMRUserID</Value>
</Value>
<Value name="14">
<Value>LastModifyMRUserID</Value>
</Value>
<Value name="15">
<Value>DefaultType</Value>
</Value>
<Value name="16">
<Value>BackgroundImage</Value>
</Value>
<Value name="17">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.PrintReceiptD</DataLocation>
<DefaultData>PrintReceiptDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.PrintReceiptD</IdLocation>
<IndexLocation>^DHCEPRFS.META.PrintReceiptI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.PrintReceiptS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
