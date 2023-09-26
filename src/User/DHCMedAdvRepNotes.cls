Class User.DHCMedAdvRepNotes Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = MEDARN_RowID, SqlTableName = DHC_MedAdvRepNotes ]
{

/// MEDARN_Pointer	报告
Property MEDARNPointer As %String [ SqlColumnNumber = 2, SqlFieldName = MEDARN_Pointer ];

/// MEDARN_Type	报告类别
Property MEDARNType As %String [ SqlColumnNumber = 3, SqlFieldName = MEDARN_Type ];

/// MEDARN_FormDicField	表单元素id
Property MEDARNFormDicField As %String [ SqlColumnNumber = 4, SqlFieldName = MEDARN_FormDicField ];

/// MEDARN_AuditDate	批注日期
Property MEDARNAuditDate As %Date [ SqlColumnNumber = 5, SqlFieldName = MEDARN_AuditDate ];

/// MEDARN_AuditTime	批注时间
Property MEDARNAuditTime As %Time [ SqlColumnNumber = 6, SqlFieldName = MEDARN_AuditTime ];

/// MEDARN_Notes	批注内容
Property MEDARNNotes As %String(MAXLEN = 2000) [ SqlColumnNumber = 7, SqlFieldName = MEDARN_Notes ];

/// MEDARN_AntUser	批注人
Property MEDARNAntUser As %String [ SqlColumnNumber = 8, SqlFieldName = MEDARN_AntUser ];

Index IndexParef On (MEDARNPointer, MEDARNType);

Storage Default
{
<Data name="DHCMedAdvRepNotesD">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MEDARNPointer</Value>
</Value>
<Value name="3">
<Value>MEDARNType</Value>
</Value>
<Value name="4">
<Value>MEDARNFormDicField</Value>
</Value>
<Value name="5">
<Value>MEDARNAuditDate</Value>
</Value>
<Value name="6">
<Value>MEDARNAuditTime</Value>
</Value>
<Value name="7">
<Value>MEDARNNotes</Value>
</Value>
<Value name="8">
<Value>MEDARNAntUser</Value>
</Value>
</Data>
<DataLocation>^User.DHCMedAdvRepNotesD</DataLocation>
<DefaultData>DHCMedAdvRepNotesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMedAdvRepNotesD</IdLocation>
<IndexLocation>^User.DHCMedAdvRepNotesI</IndexLocation>
<SqlIdExpression>$i(^User.DHCMedAdvRepNotesD)</SqlIdExpression>
<StreamLocation>^User.DHCMedAdvRepNotesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
