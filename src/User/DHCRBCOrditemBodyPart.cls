Class User.DHCRBCOrditemBodyPart Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DOB_Rowid, SqlTableName = DHCRBC_Orditem_BodyPart, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DOB_ItmMast_DR
Property DOBItmMastDR As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = DOB_ItmMast_DR ];

/// DOB_BodyPart_DR
Property DOBBodyPartDR As User.MRCBodyParts [ SqlColumnNumber = 3, SqlFieldName = DOB_BodyPart_DR ];

/// DOB_Posture_DR
Property DOBPostureDR As User.DHCRBCBodyPartPosture [ SqlColumnNumber = 4, SqlFieldName = DOB_Posture_DR ];

/// DOB_ExclusionFlag
Property DOBExclusionFlag As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DOB_ExclusionFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBC("ItemToBodyPart"))</SqlIdExpression>
<SQLMap name="IndexData">
<Global>^DHCRBCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DOB_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ItemToBodyPart"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOB_ItmMast_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DOB_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DOB_BodyPart_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DOB_ExclusionFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DOB_ItmMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DOB_Posture_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCRBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DOB_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ItemToBodyPart"</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>{DOB_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCOrditemBodyPartS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
