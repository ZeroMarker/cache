Class User.DHCAppPisDicRelationBLMap Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RowID, StorageStrategy = DHCAppPisDicRelationBLMap ]
{

Property AppPisDicItem As User.DHCAppPisDicItem [ SqlColumnNumber = 2, SqlFieldName = AppPis_DicItem ];

Property AppPisDicType As User.DHCAppPisDicType [ SqlColumnNumber = 3, SqlFieldName = AppPis_DicType ];

Property AppPisBLmap As User.DHCDocAppBLMap [ SqlColumnNumber = 4, SqlFieldName = AppPis_BLmap ];

Property AppPisDefulat As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = AppPis_Defulat ];

Storage DHCAppPisDicRelationBLMap
{
<SqlIdExpression>$i(^DHCAppPisDicRelationBLMap)</SqlIdExpression>
<SQLMap name="IndexDefualt">
<Global>^DHCAppPisDicRelationBLMap</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"Defualt"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{AppPis_Defulat}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AppPis_DicType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AppPis_BLmap}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPisDic">
<Global>^DHCAppPisDicRelationBLMap</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PisDic"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{AppPis_DicItem}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="AppPis_BLmap">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AppPis_Defulat">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AppPis_DicItem">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AppPis_DicType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCAppPisDicRelationBLMap</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RowID</SqlRowIdName>
<StreamLocation>^User.DHCAppPisDiB62AS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
