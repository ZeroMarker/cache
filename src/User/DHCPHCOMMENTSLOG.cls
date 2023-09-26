Class User.DHCPHCOMMENTSLOG Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PCNTSL_RowID, SqlTableName = DHC_PHCOMMENTSLOG, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PCNTSLChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PHCOMMENTSITM Parent Reference
Relationship PCNTSLParRefDr As User.DHCPHCOMMENTSITM [ Cardinality = parent, Inverse = ChildDHCPHCOMMENTSLOG, Required, SqlFieldName = PCNTSL_ParRef_Dr ];

/// PCNTSL_ChildSub
Property PCNTSLChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = PCNTSL_ChildSub ];

/// PCNTSL_Reason_Dr
Property PCNTSLReasonDr As User.DHCPHCNTSREASON [ SqlColumnNumber = 3, SqlFieldName = PCNTSL_Reason_Dr ];

/// PCNTSL_Date
Property PCNTSLDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = PCNTSL_Date ];

/// PCNTSL_Time
Property PCNTSLTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = PCNTSL_Time ];

/// PCNTSL_User_Dr
Property PCNTSLUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = PCNTSL_User_Dr ];

/// PCNTSL_Advice
Property PCNTSLAdvice As User.DHCPHCNTSADVICE [ SqlColumnNumber = 7, SqlFieldName = PCNTSL_Advice ];

/// PCNTSL_DocAdvice
Property PCNTSLDocAdvice As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PCNTSL_DocAdvice ];

/// PCNTSL_Factor
Property PCNTSLFactor As User.DHCPHCNTSFACTOR [ SqlColumnNumber = 9, SqlFieldName = PCNTSL_Factor ];

/// PCNTSL_Result
Property PCNTSLResult As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = PCNTSL_Result ];

/// PCNTSL_PhNote
Property PCNTSLPhNote As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PCNTSL_PhNote ];

/// PCNTSL_DocNote
Property PCNTSLDocNote As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PCNTSL_DocNote ];

/// PCNTSL_Active
Property PCNTSLActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = PCNTSL_Active ];

/// PCNTSL_ReaGrpNo
Property PCNTSLReaGrpNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PCNTSL_ReaGrpNo ];

/// PCNTSL_Level
Property PCNTSLLevel As %Library.String(DISPLAYLIST = ",Audit,Comment", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",A,C") [ SqlColumnNumber = 15, SqlFieldName = PCNTSL_Level ];

/// PCNTSL_SendFlag
Property PCNTSLSendFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = PCNTSL_SendFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexDateResult">
<Global>^DHCPHCNTS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_PHCOMMENTS.PCNTS_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>DHC_PHCOMMENTSITM.PCNTSI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>PCNTSL_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LogDateResult"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCNTSL_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCNTSL_Result}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_PHCOMMENTS.PCNTS_RowID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHC_PHCOMMENTSITM.PCNTSI_ChildSub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PCNTSL_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PCNTSL_Active">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PCNTSL_Advice">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PCNTSL_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCNTSL_DocAdvice">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PCNTSL_DocNote">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PCNTSL_Factor">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PCNTSL_Level">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PCNTSL_PhNote">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PCNTSL_ReaGrpNo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PCNTSL_Reason_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PCNTSL_Result">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCNTSL_SendFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PCNTSL_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PCNTSL_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCPHCNTS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PHCOMMENTS.PCNTS_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_PHCOMMENTSITM.PCNTSI_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PCNTSL_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PHCOMMENTS.PCNTS_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_PHCOMMENTSITM.PCNTSI_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"L"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PCNTSL_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPHCOMMENTSLOGS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
