Class User.DHCAppArcAdd Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ARA_RowID, SqlTableName = DHC_AppArcAdd, StorageStrategy = SQLStorage ]
{

/// ARA_Arc_Dr  医嘱项Id
Property ARAArcDr As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = ARA_Arc_Dr ];

/// ARA_ExecFlag
Property ARAExecFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = ARA_ExecFlag ];

/// ARA_TarFlag
Property ARATarFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ARA_TarFlag ];

/// ARA_AutoReqFlag
Property ARAAutoReqFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ARA_AutoReqFlag ];

/// ARA_Hospital 医院
Property ARAHospital As CTHospital [ SqlColumnNumber = 6, SqlFieldName = ARA_Hospital ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPARA)</SqlIdExpression>
<SQLMap name="IndexArc">
<Global>^DHCAPPARA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Arc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARA_Arc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="ARA_Arc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ARA_AutoReqFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ARA_ExecFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ARA_Hospital">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ARA_TarFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCAPPARA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ARA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppArcAddS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
