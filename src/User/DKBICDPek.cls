/// Function: 新装ICD诊断代码-北京版维护界面
/// CreateDate: 2016-12-19
/// Creator:  sunfengchao
Class User.DKBICDPek Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = DKBPek_RowId, SqlTableName = DKB_ICDPek, StorageStrategy = SQLStorage ]
{

/// ICD Diagnosis Code
Property DKBPekCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DKBPek_Code ];

/// Description
Property DKBPekDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DKBPek_Desc ];

/// ICD9CM Code
Property DKBPekICD9CMCode As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DKBPek_ICD9CM_Code ];

/// Date Active From
Property DKBPekDateActiveFrom As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 5, SqlFieldName = DKBPek_DateActiveFrom ];

/// Date Active To
Property DKBPekDateActiveTo As %Date [ SqlColumnNumber = 6, SqlFieldName = DKBPek_DateActiveTo ];

/// Age From
Property DKBPekAgeFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DKBPek_AgeFrom ];

/// Age To
Property DKBPekAgeTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DKBPek_AgeTo ];

/// Des Ref Sex
Property DKBPekSexDR As CTSex [ SqlColumnNumber = 9, SqlFieldName = DKBPek_Sex_DR ];

/// Valid
Property DKBPekValid As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = DKBPek_Valid ];

/// ICD9 Mapping
Property DKBPekICD9Map As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = DKBPek_ICD9_Map ];

/// 2nd Code in Pair
Property DKBPek2ndCodeInPair As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = DKBPek_2ndCodeInPair ];

/// Long Description
Property DKBPekLongDescription As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = DKBPek_LongDescription ];

/// MetastaticSite
Property DKBPekMetastaticSite As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = DKBPek_MetastaticSite ];

/// Injury/Poisoning Code
Property DKBPekInjuryPoisoningCode As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = DKBPek_InjuryPoisoningCode ];

/// Bill Flag 1
Property DKBPekBillFlag1 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = DKBPek_BillFlag1 ];

/// Bill Flag 3
Property DKBPekBillFlag3 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = DKBPek_BillFlag3 ];

/// 对照标识 
Property DKBPekContrastFlag As %String(DISPLAYLIST = ",Yes,No,Give Up", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N,GU") [ SqlColumnNumber = 18, SqlFieldName = DKB_PekContrastFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DKBICDPEK(0))</SqlIdExpression>
<SQLMap name="DKBICDIIndexCode">
<Global>^DKBICDPEK</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBPe_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>$$ALPHAUP({DKBPek_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DKBPek_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MRCIDDataMasterMap">
<Data name="DKBPek_2ndCodeInPair">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DKBPek_AgeFrom">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DKBPek_AgeTo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DKBPek_BillFlag1">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DKBPek_BillFlag3">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DKBPek_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DKBPek_DateActiveFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DKBPek_DateActiveTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DKBPek_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DKBPek_ICD9CM_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DKBPek_ICD9_Map">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DKBPek_InjuryPoisoningCode">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DKBPek_LongDescription">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DKBPek_MetastaticSite">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DKBPek_Sex_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DKBPek_Valid">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DKB_PekContrastFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Global>^DKBICDPEK</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DBKPe_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DKBPek_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="MRCIDIndexDesc">
<Global>^DKBICDPEK</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBPe_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>$$ALPHAUP({DKBPek_Desc}) </Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DKBPek_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DKBPek_RowId</SqlRowIdName>
<StreamLocation>^User.DKBICDPekS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
