/// Author : myq
/// CreatorDate : 2013-11-25
/// Description : 将抽出的点评单中的每一个处方分配给药师
Class User.DHCPHCNTSALLOTUSER Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = PCALU_RowID, SqlTableName = DHC_PHCNTSALLOTUSER, StorageStrategy = sqlStorage ]
{

/// 指向处方所要分配给药师的ID
Property PCALUUserDr As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = PCALU_User_Dr ];

/// 医院
Property PCALUHospDr As User.CTHospital [ SqlColumnNumber = 3, SqlFieldName = PCALU_Hosp_Dr ];

/// PCALU_Level
Property PCALULevel As %Library.String(DISPLAYLIST = ",Audit,Comment", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",A,C") [ SqlColumnNumber = 4, SqlFieldName = PCALU_Level ];

/// PCALU_Group
Property PCALUGroup As %Library.String [ SqlColumnNumber = 5, SqlFieldName = PCALU_Group ];

Storage sqlStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPCALU(0))</SqlIdExpression>
<SQLMap name="IndexGroup">
<Global>^DHCPCALU</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PCALU_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PCALUGroup"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCALU_Group}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCALU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCPCALU</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PCALU_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PCALUUserDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PCALU_User_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PCALU_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PCALU_Group">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PCALU_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PCALU_Level">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PCALU_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPCALU</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PCALU_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PCALU_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PCALU_RowID</SqlRowIdName>
<StreamLocation>^User.DHCPHCNTSALLOTUSERS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
