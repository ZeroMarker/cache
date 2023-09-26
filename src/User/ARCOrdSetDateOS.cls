/// ARC OrdSet Date OrderSet(1211)
Class User.ARCOrdSetDateOS Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_OrdSetDateOS, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On OSChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildARCOrdSetDateOSPrice As ARCOrdSetDateOSPrice [ Cardinality = children, Inverse = PRICEParRef ];

/// ARC_OrdSetDate Parent Reference
Relationship OSParRef As ARCOrdSetDate [ Cardinality = parent, Inverse = ChildARCOrdSetDateOS, Required, SqlFieldName = OS_ParRef ];

/// Childsub
Property OSChildsub As %Float [ InitialExpression = {$i(^ARCOS($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DATE",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"OS",0))}, SqlColumnNumber = 2, SqlFieldName = OS_Childsub ];

/// Des Ref to ARCOS
Property OSOrderSetDR As ARCOrdSets [ SqlColumnNumber = 3, SqlFieldName = OS_OrderSet_DR ];

/// Price
Property OSPrice As %Float [ SqlColumnNumber = 4, SqlFieldName = OS_Price ];

/// Itemserialnumber序列码用于输出
Property OSSerialNo As %Float [ SqlColumnNumber = 5, SqlFieldName = OS_SerialNo ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="OS_OrderSet_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OS_Price">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OS_SerialNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^ARCOS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_OrdSets.ARCOS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ARC_OrdSetDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>OS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_OrdSets.ARCOS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARC_OrdSetDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"OS"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOSDR">
<Global>^ARCOS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ARC_OrdSets.ARCOS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ARC_OrdSetDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>OS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OS_OrderSet_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARC_OrdSets.ARCOS_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARC_OrdSetDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>OS_RowId</SqlRowIdName>
<StreamLocation>^User.ARCOrdSetDateOSS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
