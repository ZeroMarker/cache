/// 导管维护记录
Class User.DHCICUCatheterDetail Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DHC_ICU_CatheterDetail ]
{

Property CatheterRecord As User.DHCICUCatheterRecord [ Required, SqlColumnNumber = 2 ];

Property RecordDate As %Date [ Required, SqlColumnNumber = 3 ];

Property RecordTime As %Time [ Required, SqlColumnNumber = 4 ];

Property ItemName As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 5 ];

Property ItemValue As %String(MAXLEN = 500) [ Required, SqlColumnNumber = 6 ];

Property CreateUser As %String [ SqlColumnNumber = 7 ];

Property CreateDate As %Date [ SqlColumnNumber = 8 ];

Property CreateTime As %Time [ SqlColumnNumber = 9 ];

Property UpdateUser As %String [ SqlColumnNumber = 10 ];

Property UpdateDate As %Date [ SqlColumnNumber = 11 ];

Property UpdateTime As %Time [ SqlColumnNumber = 12 ];

Property EditFlag As %String(DISPLAYLIST = ",Normal,Deleted", VALUELIST = ",N,D") [ SqlColumnNumber = 13 ];

Index ICatheterRecord On CatheterRecord;

Index IRecordDate On RecordDate;

Storage Default
{
<Data name="DHCICUCatheterDetailDefaultData">
<Value name="1">
<Value>CatheterRecord</Value>
</Value>
<Value name="2">
<Value>RecordDate</Value>
</Value>
<Value name="3">
<Value>RecordTime</Value>
</Value>
<Value name="4">
<Value>ItemName</Value>
</Value>
<Value name="5">
<Value>ItemValue</Value>
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
<Value>UpdateUser</Value>
</Value>
<Value name="10">
<Value>UpdateDate</Value>
</Value>
<Value name="11">
<Value>UpdateTime</Value>
</Value>
<Value name="12">
<Value>EditFlag</Value>
</Value>
</Data>
<DataLocation>^User.DHCICUCatheterDetailD</DataLocation>
<DefaultData>DHCICUCatheterDetailDefaultData</DefaultData>
<IdLocation>^User.DHCICUCatheterDetailD</IdLocation>
<IndexLocation>^User.DHCICUCatheterDetailI</IndexLocation>
<StreamLocation>^User.DHCICUCatheterDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
