Class User.DHCICUCatheterDetailICU Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DHC_ICU_CatheterDetailICU ]
{

Property CatheterRecord As User.DHCICUCatheterRecord [ Required, SqlColumnNumber = 2 ];

Property RecordDate As %Date [ Required, SqlColumnNumber = 3 ];

Property RecordTime As %Time [ Required, SqlColumnNumber = 4 ];

Property ZhiGuanName As %String [ SqlColumnNumber = 5 ];

Property ZhiGuanKeDu As %String [ SqlColumnNumber = 6 ];

Property DaoGuanType As %String [ SqlColumnNumber = 7 ];

Property YLCGQModifyDate As %Date [ SqlColumnNumber = 8 ];

Property YLCGQModifyTime As %Time [ SqlColumnNumber = 9 ];

Property ModifyFuLiaoDate As %Date [ SqlColumnNumber = 10 ];

Property ShuiZhuYaCha As %String [ SqlColumnNumber = 11 ];

Property ShuiZhuBoDong As %String [ SqlColumnNumber = 12 ];

Property FuYaXiYin As %String [ SqlColumnNumber = 13 ];

Property QiPaoYiChu As %String [ SqlColumnNumber = 14 ];

Property Note As %String(MAXLEN = 500) [ SqlColumnNumber = 15 ];

Property CreateUser As %String [ SqlColumnNumber = 16 ];

Property CreateDate As %Date [ SqlColumnNumber = 17 ];

Property CreateTime As %Time [ SqlColumnNumber = 18 ];

Property UpdateUser As %String [ SqlColumnNumber = 19 ];

Property UpdateDate As %Date [ SqlColumnNumber = 20 ];

Property UpdateTime As %Time [ SqlColumnNumber = 21 ];

Property EditFlag As %String(DISPLAYLIST = ",Normal,Deleted", VALUELIST = ",N,D") [ SqlColumnNumber = 22 ];

Index ICatheterRecord On CatheterRecord As Exact;

// Index IRecordDate On RecordDate As Exact;

Index IRecordDateTime On (RecordDate As Exact, RecordTime As Exact);

Storage Default
{
<Data name="DHCICUCatheterDetailICUDefaultData">
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
<Value>ZhiGuanName</Value>
</Value>
<Value name="5">
<Value>ZhiGuanKeDu</Value>
</Value>
<Value name="6">
<Value>DaoGuanType</Value>
</Value>
<Value name="7">
<Value>YLCGQModifyDate</Value>
</Value>
<Value name="8">
<Value>YLCGQModifyTime</Value>
</Value>
<Value name="9">
<Value>ModifyFuLiaoDate</Value>
</Value>
<Value name="10">
<Value>ShuiZhuYaCha</Value>
</Value>
<Value name="11">
<Value>ShuiZhuBoDong</Value>
</Value>
<Value name="12">
<Value>FuYaXiYin</Value>
</Value>
<Value name="13">
<Value>QiPaoYiChu</Value>
</Value>
<Value name="14">
<Value>Note</Value>
</Value>
<Value name="15">
<Value>CreateUser</Value>
</Value>
<Value name="16">
<Value>CreateDate</Value>
</Value>
<Value name="17">
<Value>CreateTime</Value>
</Value>
<Value name="18">
<Value>UpdateUser</Value>
</Value>
<Value name="19">
<Value>UpdateDate</Value>
</Value>
<Value name="20">
<Value>UpdateTime</Value>
</Value>
<Value name="21">
<Value>EditFlag</Value>
</Value>
</Data>
<DataLocation>^User.DHCICUCatheterDetailICUD</DataLocation>
<DefaultData>DHCICUCatheterDetailICUDefaultData</DefaultData>
<IdLocation>^User.DHCICUCatheterDetailICUD</IdLocation>
<IndexLocation>^User.DHCICUCatheterDetailICUI</IndexLocation>
<StreamLocation>^User.DHCICUCatheterDetailICUS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
