Class User.DHCJFOrdItemCatSet Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OrdItemCat_RowId, SqlTableName = DHC_JFOrdItemCatSet, StorageStrategy = SQLStorage ]
{

/// OrdItemCat_Parref
Property OrdItemCatParref As User.ARCItemCat [ SqlColumnNumber = 2, SqlFieldName = OrdItemCat_Parref ];

/// OrdItemCat_Flag
Property OrdItemCatFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = OrdItemCat_Flag ];

/// OrdItemCat_Hosp_DR
Property OrdItemCatHospDR As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = OrdItemCat_Hosp_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCJFORDITEMCATSET)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="OrdItemCat_Flag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OrdItemCat_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OrdItemCat_Parref">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCJFORDITEMCATSET</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OrdItemCat_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OrdItemCat_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexItemCat">
<Global>^DHCJFORDITEMCATSET</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OrdItemCat_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ItemCat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OrdItemCat_Parref}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OrdItemCat_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCJFOrdItemCatSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
