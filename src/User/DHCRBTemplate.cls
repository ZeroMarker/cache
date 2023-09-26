Class User.DHCRBTemplate Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DTL_RowID, SqlTableName = DHCRB_Template, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DTL_TemplCat_DR
Property DTLTemplCatDR As User.DHCRBCTemplCat [ SqlColumnNumber = 2, SqlFieldName = DTL_TemplCat_DR ];

/// DTL_Sick_DR
Property DTLTemplDIRDR As User.DHCRBCTemplDIR [ SqlColumnNumber = 5, SqlFieldName = DTL_TemplDIR_DR ];

/// DTL_Code
Property DTLCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DTL_Code ];

/// DTL_Name
Property DTLName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DTL_Name ];

/// DTL_SeeDesc
Property DTLSeeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DTL_SeeDesc ];

/// DTL_ResultDesc
Property DTLResultDesc As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DTL_ResultDesc ];

/// DTL_OtherDesc
Property DTLOtherDesc As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = DTL_OtherDesc ];

/// DTL_SeeDescEx
Property DTLSeeDescEx As list Of %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DTL_SeeDescEx, SqlListType = SUBNODE ];

/// DTL_ResultDescEx
Property DTLResultDescEx As list Of %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DTL_ResultDescEx, SqlListType = SUBNODE ];

/// DTL_OtherDescEx
Property DTLOtherDescEx As list Of %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DTL_OtherDescEx, SqlListType = SUBNODE ];

/// DTL_ItemMast_DR
Property DTLItemMastDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = DTL_ItemMast_DR ];

/// DTL_ExameMethod
Property DTLExameMethod As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DTL_ExameMethod ];

/// DTL_Note1
Property DTLNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = DTL_Note1 ];

/// DTL_Note2
Property DTLNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = DTL_Note2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBTempl("Template"))</SqlIdExpression>
<SQLMap name="IndexCat">
<Global>^DHCRBTempli</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DTL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Template"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Cat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DTL_TemplCat_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DTL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMast">
<Global>^DHCRBTempli</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DTL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Template"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ItmMast"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DTL_ItemMast_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DTL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTemplDir">
<Global>^DHCRBTempli</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DTL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Template"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TemplDir"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DTL_TemplDIR_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DTL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DTL_Code">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DTL_ExameMethod">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DTL_ItemMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DTL_Name">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DTL_Note1">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DTL_Note2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DTL_OtherDesc">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DTL_OtherDescEx">
<Node>"OtherDescEx"</Node>
</Data>
<Data name="DTL_ResultDesc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DTL_ResultDescEx">
<Node>"ResultDescEx"</Node>
</Data>
<Data name="DTL_SeeDesc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DTL_SeeDescEx">
<Node>"SeeDescEx"</Node>
</Data>
<Data name="DTL_TemplCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DTL_TemplDIR_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCRBTempl</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DTL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Template"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DTL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBTemplateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
