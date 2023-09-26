Class User.DHCStkSysDataModifyDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DMD_RowId, SqlTableName = DHC_StkSysDataModifyDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DMDChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_StkSysDataModify Parent Reference
Relationship DMDDMParRef As User.DHCStkSysDataModify [ Cardinality = parent, Inverse = ChildDHCStkSysDataModifyDetail, Required, SqlFieldName = DMD_DM_ParRef ];

/// DMD_ChildSub
Property DMDChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DMD_ChildSub ];

/// DMD_Property
Property DMDProperty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DMD_Property ];

/// DMD_OldValue
Property DMDOldValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DMD_OldValue ];

/// DMD_NewValue
Property DMDNewValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DMD_NewValue ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DMD_NewValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DMD_OldValue">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DMD_Property">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCSSDM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StkSysDataModify.DM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DMD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_StkSysDataModify.DM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"D"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DMD_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCStkSysDat975S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
