Class User.PHAINStatDetail Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PINSD_RowID, SqlTableName = PHAIN_StatDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PINSDChildSub [ IdKey, PrimaryKey, Unique ];

/// PINSD_SC_Parref
Relationship PINSDSCParref As User.PHAINStatCat [ Cardinality = parent, Inverse = ChildPHAINStatDetail, Required, SqlFieldName = PINSD_SC_Parref ];

/// PINSD_ChildSub
Property PINSDChildSub As %Library.Integer [ SqlColumnNumber = 2, SqlFieldName = PINSD_ChildSub ];

/// PINSD_INCI_Dr
Property PINSDINCIDr As User.INCItm [ SqlColumnNumber = 3, SqlFieldName = PINSD_INCI_Dr ];

/// 基数数量
Property PINSDBaseQty As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PINSD_BaseQty ];

/// 顺序号
Property PINSDOrder As %Library.String [ SqlColumnNumber = 5, SqlFieldName = PINSD_Order ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PINSD_BaseQty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PINSD_INCI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PINSD_Order">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CD.PHA.IN.STAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAIN_StatType.PINST_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHAIN_StatCat.PINSC_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PINSD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHAIN_StatType.PINST_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"C"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAIN_StatCat.PINSC_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"D"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PINSD_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINCI">
<Global>^CD.PHA.IN.STAT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHAIN_StatType.PINST_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHAIN_StatCat.PINSC_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>PINSD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PINSD_INCI_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAIN_StatType.PINST_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHAIN_StatCat.PINSC_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PINSD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PHAINStatDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
