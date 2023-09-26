Class User.DHCEQRentAffix Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RA_RowID, SqlTableName = DHC_EQRentAffix, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// RA_RentDR
Property RARentDR As User.DHCEQRent [ SqlColumnNumber = 2, SqlFieldName = RA_RentDR ];

/// RA_RentStatu
Property RARentStatu As %Library.String(DISPLAYLIST = ",借出,归还", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",1,2") [ SqlColumnNumber = 3, SqlFieldName = RA_RentStatu ];

/// RA_EquipRentAffixDR
Property RAEquipRentAffixDR As User.DHCEQEquipRentAffix [ SqlColumnNumber = 4, SqlFieldName = RA_EquipRentAffixDR ];

/// RA_Status
Property RAStatus As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = RA_Status ];

/// RA_Remark
Property RARemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = RA_Remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQRentAffix("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RA_EquipRentAffixDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RA_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RA_RentDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RA_RentStatu">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RA_Status">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQRentAffix</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{RA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexRent">
<Global>^DHCEQRentAffix</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Rent"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RA_RentDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQRentAffixS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
