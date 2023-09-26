Class CKB.PDSS.ComContrast Extends (%Persistent, User.Abstract) [ SqlRowIdName = CC_RowID, SqlTableName = ComContrast ]
{

/// D ##class(CKB.PDSS.ComContrast).%BuildIndices()
Property CCLibCode As %String(MAXLEN = 100) [ SqlColumnNumber = 2, SqlFieldName = CC_LibCode ];

Property CCLibDesc As %String(MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = CC_LibDesc ];

Property CCHisCode As %String(MAXLEN = 100) [ SqlColumnNumber = 4, SqlFieldName = CC_HisCode ];

Property CCHisDesc As %String(MAXLEN = 100) [ SqlColumnNumber = 5, SqlFieldName = CC_HisDesc ];

Property CCDicType As %String(MAXLEN = 100) [ SqlColumnNumber = 6, SqlFieldName = CC_DicType ];

Property CCHospital As %String(MAXLEN = 100) [ SqlColumnNumber = 7, SqlFieldName = CC_Hospital ];

Index LibDesc On (CCLibDesc As Upper, CCHisDesc As Upper);

Index HisDesc On CCHisDesc As Upper;

Index HisCode On CCHisCode As Upper;

Index HisCodeHisDesc On (CCHisCode As Upper, CCHisDesc As Upper);

Index CCHospital On (CCLibDesc As Upper, CCHisDesc As Upper, CCHospital As Upper);

Index HospLibCode On (CCHospital As Upper, CCLibCode As Upper);

Index HospType On (CCHospital As Upper, CCDicType As Upper);

Index LibCode On (CCLibCode As Upper, CCHisCode As Upper);

Index Type On CCDicType As Upper;

Storage Default
{
<Data name="ComContrastDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CCLibCode</Value>
</Value>
<Value name="3">
<Value>CCLibDesc</Value>
</Value>
<Value name="4">
<Value>CCHisCode</Value>
</Value>
<Value name="5">
<Value>CCHisDesc</Value>
</Value>
<Value name="6">
<Value>CCDicType</Value>
</Value>
<Value name="7">
<Value>CCHospital</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.ComContrastD</DataLocation>
<DefaultData>ComContrastDefaultData</DefaultData>
<IdLocation>^CKB.PDSS.ComContrastD</IdLocation>
<IndexLocation>^CKB.PDSS.ComContrastI</IndexLocation>
<StreamLocation>^CKB.PDSS.ComContrastS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
