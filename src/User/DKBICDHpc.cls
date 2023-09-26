/// Function: 新装ICD诊断代码-卫计委版维护界面
/// CreateDate: 2016-12-16
/// Creator:  sunfengchao
Class User.DKBICDHpc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = DKBHpc_RowId, SqlTableName = DKB_ICDHpc, StorageStrategy = SQLStorage ]
{

/// ICD Diagnosis Code
Property DKBHpcCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DKBHpc_Code ];

/// Description
Property DKBHpcDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DKBHpc_Desc ];

/// ICD9CM Code
Property DKBHpcICD9CMCode As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DKBHpc_ICD9CM_Code ];

/// Date Active From
Property DKBHpcDateActiveFrom As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 5, SqlFieldName = DKBHpc_DateActiveFrom ];

/// Date Active To
Property DKBHpcDateActiveTo As %Date [ SqlColumnNumber = 6, SqlFieldName = DKBHpc_DateActiveTo ];

/// Age From
Property DKBHpcAgeFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DKBHpc_AgeFrom ];

/// Age To
Property DKBHpcAgeTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DKBHpc_AgeTo ];

/// Des Ref Sex
Property DKBHpcSexDR As CTSex [ SqlColumnNumber = 9, SqlFieldName = DKBHpc_Sex_DR ];

/// Valid
Property DKBHpcValid As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = DKBHpc_Valid ];

/// ICD9 Mapping
Property DKBHpcICD9Map As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = DKBHpc_ICD9_Map ];

/// 2nd Code in Pair
Property DKBHpc2ndCodeInPair As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = DKBHpc_2ndCodeInPair ];

/// Long Description
Property DKBHpcLongDescription As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = DKBHpc_LongDescription ];

/// MetastaticSite
Property DKBHpcMetastaticSite As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = DKBHpc_MetastaticSite ];

/// Injury/Poisoning Code
Property DKBHpcInjuryPoisoningCode As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = DKBHpc_InjuryPoisoningCode ];

/// Bill Flag 1
Property DKBHpcBillFlag1 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = DKBHpc_BillFlag1 ];

/// Bill Flag 3
Property DKBHpcBillFlag3 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = DKBHpc_BillFlag3 ];

/// 对照标识 
Property DKBHpcContrastFlag As %String(DISPLAYLIST = ",Yes,No,Give Up", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N,GU") [ SqlColumnNumber = 18, SqlFieldName = DKB_HpcContrastFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DKBICDHPC(0))</SqlIdExpression>
<SQLMap name="DKBICDIIndexCode">
<Global>^DKBICDHPC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBHp_RowId</Field>
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
<Expression>$$ALPHAUP({DKBHpc_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DKBHpc_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MRCIDDataMasterMap">
<Data name="DKBHpc_2ndCodeInPair">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DKBHpc_AgeFrom">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DKBHpc_AgeTo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DKBHpc_BillFlag1">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DKBHpc_BillFlag3">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DKBHpc_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DKBHpc_DateActiveFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DKBHpc_DateActiveTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DKBHpc_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DKBHpc_ICD9CM_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DKBHpc_ICD9_Map">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DKBHpc_InjuryPoisoningCode">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DKBHpc_LongDescription">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DKBHpc_MetastaticSite">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DKBHpc_Sex_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DKBHpc_Valid">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DKB_HpcContrastFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Global>^DKBICDHPC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DKBHp_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DKBHpc_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="MRCIDIndexDesc">
<Global>^DKBICDHPC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBHp_RowId</Field>
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
<Expression>$$ALPHAUP({DKBHpc_Desc}) </Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DKBHpc_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DKBHpc_RowId</SqlRowIdName>
<StreamLocation>^User.DKBICDIntS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
