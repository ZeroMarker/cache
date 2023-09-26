Class User.DHCRBModifyRetinue Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DMR_RowID, SqlTableName = DHCRB_ModifyRetinue, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DMR_OEordItem_DR
Property DMROEordItemDR As User.OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = DMR_OEordItem_DR ];

/// DMR_ModifyUser_DR
Property DMRModifyUserDR As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = DMR_ModifyUser_DR ];

/// DMR_RetinueUser_DR
Property DMRRetinueUserDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = DMR_RetinueUser_DR ];

/// DMR_Operate_Date
Property DMROperateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = DMR_Operate_Date ];

/// DMR_Operate_Time
Property DMROperateTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = DMR_Operate_Time ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBModifyRetinue)</SqlIdExpression>
<SQLMap name="IndexOEItem">
<Global>^DHCRBModifyRetinuei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DMR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ORDITEM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DMR_OEordItem_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DMR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DMR_ModifyUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DMR_OEordItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DMR_Operate_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DMR_Operate_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DMR_RetinueUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCRBModifyRetinue</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DMR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DMR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBModifyRetinueS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
