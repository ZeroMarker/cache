/// 名称: BILL.COM.PO.PrintLog.cls
/// 描述: 单据打印日志表
/// 编写者: ZhYW
/// 编写日期: 2022-05-20
/// 产品组：计费医保组
Class BILL.COM.PO.PrintLog Extends (%Persistent, User.Abstract)
{

Property KeyCode As %String(CAPTION = "代码", MAXLEN = 500) [ Required, SqlColumnNumber = 2 ];

Property KeyValue As %String(CAPTION = "标识该笔单据的唯一值") [ SqlColumnNumber = 3 ];

Property Conditions As %Text(CAPTION = "参数", MAXLEN = 1000) [ SqlColumnNumber = 4 ];

Property Content As %Stream.GlobalCharacter(CAPTION = "打印内容") [ SqlColumnNumber = 5 ];

Property PrintTimes As %Numeric(CAPTION = "打印次数") [ InitialExpression = 1, SqlColumnNumber = 6 ];

Property OpterId As User.SSUser(CAPTION = "经办人ID") [ SqlColumnNumber = 7 ];

Property OptDate As %Date(CAPTION = "经办日期", FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 8 ];

Property OptTime As %Time(CAPTION = "经办时间") [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9 ];

Property UpdtId As User.SSUser(CAPTION = "更新人ID") [ SqlColumnNumber = 10 ];

Property UpdtDate As %Date(CAPTION = "更新日期", FORMAT = 1) [ SqlColumnNumber = 11 ];

Property UpdtTime As %Time(CAPTION = "更新时间") [ SqlColumnNumber = 12 ];

Index IdxKeyCode On KeyCode As Exact;

Index IdxKeyValue On (KeyCode As Exact, KeyValue As Exact);

Index IdxCreatDate On OptDate As Exact;

Storage Default
{
<Data name="PrintLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KeyCode</Value>
</Value>
<Value name="3">
<Value>KeyValue</Value>
</Value>
<Value name="4">
<Value>Conditions</Value>
</Value>
<Value name="5">
<Value>Content</Value>
</Value>
<Value name="6">
<Value>PrintTimes</Value>
</Value>
<Value name="7">
<Value>OpterId</Value>
</Value>
<Value name="8">
<Value>OptDate</Value>
</Value>
<Value name="9">
<Value>OptTime</Value>
</Value>
<Value name="10">
<Value>UpdtId</Value>
</Value>
<Value name="11">
<Value>UpdtDate</Value>
</Value>
<Value name="12">
<Value>UpdtTime</Value>
</Value>
</Data>
<DataLocation>^BILL.COM.PO.PrintLogD</DataLocation>
<DefaultData>PrintLogDefaultData</DefaultData>
<IdLocation>^BILL.COM.PO.PrintLogD</IdLocation>
<IndexLocation>^BILL.COM.PO.PrintLogI</IndexLocation>
<StreamLocation>^BILL.COM.PO.PrintLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
