Class User.DHCEQCheckPicture Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PT_RowID, SqlTableName = DHC_EQCheckPicture, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PT_EquipDR
Property PTEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = PT_EquipDR ];

/// PT_Path
Property PTPath As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PT_Path ];

/// PT_Picture
Property PTPicture As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PT_Picture ];

/// PT_Remark
Property PTRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PT_Remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCheckPicture("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PT_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PT_Path">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PT_Picture">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PT_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCheckPicture</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQCheckPicture</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PT_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCheckPictureS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
