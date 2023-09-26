/// DHC_ICU_PrintTemplateDetails
Class User.DHCICUPrintTemplateDetails Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ICUPTD_RowId, SqlTableName = DHC_ICU_PrintTemplateDetails, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ICUPTDChildSub [ IdKey, PrimaryKey, Unique ];

/// ICUPTD_ICUPTId
Relationship ICUPTDICUPTId As User.DHCICUPrintTemplate [ Cardinality = parent, Inverse = ChildDHCICUPrintTemplateDetails, Required, SqlFieldName = ICUPTD_ICUPTId ];

/// ICUPTD_ChildSub
Property ICUPTDChildSub As %Numeric [ InitialExpression = {$i(^DHCICUPrintTemplate($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"Details",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ICUPTD_ChildSub ];

/// ICUPTD_Type
Property ICUPTDType As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = ICUPTD_Type ];

/// ICUPTD_StartPoint
Property ICUPTDStartPoint As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 4, SqlFieldName = ICUPTD_StartPoint ];

/// ICUPTD_EndPoint
Property ICUPTDEndPoint As %Library.String(MAXLEN = 100) [ SqlColumnNumber = 5, SqlFieldName = ICUPTD_EndPoint ];

/// ICUPTD_Note
Property ICUPTDNote As %Library.String(MAXLEN = 999) [ SqlColumnNumber = 6, SqlFieldName = ICUPTD_Note ];

/// ICUPTD_Style
Property ICUPTDStyle As %Library.String(MAXLEN = 200) [ SqlColumnNumber = 7, SqlFieldName = ICUPTD_Style ];

/// ICUPTD_Data
Property ICUPTDData As %Library.String(MAXLEN = 999) [ SqlColumnNumber = 8, SqlFieldName = ICUPTD_Data ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ICUPTD_Data">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ICUPTD_EndPoint">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICUPTD_Note">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ICUPTD_StartPoint">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ICUPTD_Style">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ICUPTD_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCICUPrintTemplate</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ICU_PrintTemplate.ICUPT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ICUPTD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_ICU_PrintTemplate.ICUPT_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Details"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICUPTD_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCICUPrintTemplateDetailsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
