Class User.DHCAccCreSub Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlCategory = INTEGER, SqlRowIdName = CreSub_Rowid, SqlTableName = DHC_AccCreSub, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On CreSubSub [ IdKey, PrimaryKey, Unique ];

/// DHC_INVPRT Parent Reference
Relationship CreSubParRef As User.DHCAccCre [ Cardinality = parent, Inverse = ChildDHCAccCreSub, Required, SqlFieldName = CreSub_ParRef ];

/// CreSubSub
Property CreSubSub As %Library.Float [ InitialExpression = {$i(^DHCACCCRE($p(%d(0),$c(1)),"S",0))}, SqlColumnNumber = 2, SqlFieldName = CreSub_Sub ];

/// CreSubDesc
Property CreSubDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CreSub_Desc ];

/// CreSubDataSource
Property CreSubDataSource As %Library.String(DISPLAYLIST = ",FP,YJ,ALL", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",FP,YJ,ALL") [ SqlColumnNumber = 4, SqlFieldName = CreSub_DataSource ];

/// CreSubPatType
Property CreSubPatType As %Library.String(DISPLAYLIST = ",In Patient,Out Patient,ALL", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",I,O,A") [ SqlColumnNumber = 5, SqlFieldName = CreSub_PatType ];

/// CreSubAccItem
Property CreSubAccItem As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CreSub_AccItem ];

/// CreSubadmreason    ----  PAC_AdmReason
Property CreSubadmreason As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CreSub_admreason ];

/// CreSubpaymode      ---   CT_PayMode
Property CreSubpaymode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CreSub_paymode ];

/// CreSubcat          ---   DHC_TarOC
Property CreSubcat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CreSub_cat ];

/// CreSubLoc         ----  CT_Loc
Property CreSubLoc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CreSub_Loc ];

/// CreSubFlag1
Property CreSubFlag1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CreSub_Flag1 ];

/// CreSubFlag2
Property CreSubFlag2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CreSub_Flag2 ];

/// CreSubFlag3
Property CreSubFlag3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CreSub_Flag3 ];

/// CreSubFlag4
Property CreSubFlag4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = CreSub_Flag4 ];

/// CreSubFlag5
Property CreSubFlag5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = CreSub_Flag5 ];

/// CreSubPrePrtFlag
Property CreSubPrePrtFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = CreSub_PrePrtFlag ];

/// CreSubIncluAbort
Property CreSubIncluAbort As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = CreSub_IncluAbort ];

/// CreSubDFContains
Property CreSubDFContains As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = CreSub_DFContains ];

/// CreSubJFContains
Property CreSubJFContains As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = CreSub_JFContains ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="CreSub_AccItem">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CreSub_DFContains">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CreSub_DataSource">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CreSub_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CreSub_Flag1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CreSub_Flag2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CreSub_Flag3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CreSub_Flag4">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CreSub_Flag5">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CreSub_IncluAbort">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CreSub_JFContains">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CreSub_Loc">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CreSub_PatType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CreSub_PrePrtFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CreSub_admreason">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CreSub_cat">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CreSub_paymode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCACCCRE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AccCre.Cre_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CreSub_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AccCre.Cre_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"S"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CreSub_Sub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAccCreSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
