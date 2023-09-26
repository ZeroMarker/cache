/// Function: 新装ICD诊断代码-国际版维护界面
/// CreateDate: 2016-12-16
/// Creator:  sunfengchao
Class User.DKBICDInt Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = DKBInt_RowId, SqlTableName = DKB_ICDInt, StorageStrategy = SQLStorage ]
{

/// ICD  Code
Property DKBIntCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DKBInt_Code ];

/// 中文说明
Property DKBIntDesc As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DKBInt_Desc ];

/// 英文说明 
Property DKBIntLongDescription As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = DKBInt_LongDescription ];

/// ICD9CM Code
Property DKBIntICD9CMCode As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DKBInt_ICD9CM_Code ];

/// Date Active From
Property DKBIntDateActiveFrom As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 5, SqlFieldName = DKBInt_DateActiveFrom ];

/// Date Active To
Property DKBIntDateActiveTo As %Date [ SqlColumnNumber = 6, SqlFieldName = DKBInt_DateActiveTo ];

/// Age From
Property DKBIntAgeFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DKBInt_AgeFrom ];

/// Age To
Property DKBIntAgeTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DKBInt_AgeTo ];

/// Des Ref Sex
Property DKBIntSexDR As CTSex [ SqlColumnNumber = 9, SqlFieldName = DKBInt_Sex_DR ];

/// Valid
Property DKBIntValid As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = DKBInt_Valid ];

/// ICD9 Mapping
Property DKBIntICD9Map As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = DKBInt_ICD9_Map ];

/// 2nd Code in Pair
Property DKBInt2ndCodeInPair As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = DKBInt_2ndCodeInPair ];

/// MetastaticSite
Property DKBIntMetastaticSite As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = DKBInt_MetastaticSite ];

/// Injury/Poisoning Code
Property DKBIntInjuryPoisoningCode As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = DKBInt_InjuryPoisoningCode ];

/// Bill Flag 1
Property DKBIntBillFlag1 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = DKBInt_BillFlag1 ];

/// Bill Flag 3
Property DKBIntBillFlag3 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = DKBInt_BillFlag3 ];

/// 对照标识 
Property DKBIntContrastFlag As %String(DISPLAYLIST = ",Yes,No,Give Up", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N,GU") [ SqlColumnNumber = 18, SqlFieldName = DKB_IntContrastFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DKBICDINT(0))</SqlIdExpression>
<SQLMap name="DKBICDIIndexCode">
<Global>^DKBICDINT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBInt_RowId</Field>
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
<Expression>$$ALPHAUP({DKBInt_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DKBInt_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MRCIDDataMasterMap">
<Data name="DKBInt_2ndCodeInPair">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DKBInt_AgeFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DKBInt_AgeTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DKBInt_BillFlag1">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DKBInt_BillFlag3">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DKBInt_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DKBInt_DateActiveFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DKBInt_DateActiveTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DKBInt_Desc">
<Node>"Desc"</Node>
</Data>
<Data name="DKBInt_ICD9CM_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DKBInt_ICD9_Map">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DKBInt_InjuryPoisoningCode">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DKBInt_LongDescription">
<Node>"LONGDesc"</Node>
</Data>
<Data name="DKBInt_MetastaticSite">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DKBInt_Sex_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DKBInt_Valid">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DKB_IntContrastFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^DKBICDINT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MRCID_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DKBInt_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="MRCIDIndexDesc">
<Global>^DKBICDINT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DKBInt_RowId</Field>
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
<Expression>$$ALPHAUP({DKBInt_Desc}) </Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{DKBInt_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DKBInt_RowId</SqlRowIdName>
<StreamLocation>^User.DKBICDIntS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
