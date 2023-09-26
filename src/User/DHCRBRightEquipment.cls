Class User.DHCRBRightEquipment Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RBRE_Rowid, SqlTableName = DHCRB_Right_Equipment, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 251;

Index RowIDBasedIDKeyIndex On RBREChildSub [ IdKey, PrimaryKey, Unique ];

/// RB_Right Parent Reference
Relationship RBREParRef As User.DHCRBRight [ Cardinality = parent, Inverse = ChildDHCRBRightEquipment, Required, SqlFieldName = RBRE_ParRef ];

/// Child subscript
Property RBREChildSub As %Library.Float [ InitialExpression = {$i(^DHCRight("RBRIGHTEQUIPMENT"))}, Required, SqlColumnNumber = 2, SqlFieldName = RBRE_ChildSub ];

/// RBRE_Equipment_DR
Property RBREEquipmentDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = RBRE_Equipment_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="RBRE_Equipment_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPACRightEQ</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCRB_Right.RBR_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RBRE_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EquipmentRight"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCRB_Right.RBR_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RBRE_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBRightEquipmentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
