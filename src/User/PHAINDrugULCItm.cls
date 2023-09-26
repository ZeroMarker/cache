Class User.PHAINDrugULCItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlRowIdName = DULCI_RowId, SqlTableName = PHAIN_DrugULCItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DULCICHILDSUB [ IdKey, PrimaryKey, Unique ];

Relationship DULIParRef As User.PHAINDrugULComb [ Cardinality = parent, Inverse = ChildDULCI, Required, SqlFieldName = DULI_ParRef ];

/// DULCI_CHILDSUB
Property DULCICHILDSUB As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = DULCI_CHILDSUB ];

/// DULCI_Type  限制类型：医生/科室/费别...
Property DULCIType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DULCI_Type ];

/// DULCI_TypeValue  限制类型值
Property DULCITypeValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DULCI_TypeValue ];

/// DULCI_LimitQty 限制数量
Property DULCILimitQty As %Float(MINVAL = .001) [ SqlColumnNumber = 5, SqlFieldName = DULCI_LimitQty ];

/// DULCI_UseQty 当月已经使用数量
Property DULCIUseQty As %Float [ SqlColumnNumber = 6, SqlFieldName = DULCI_UseQty ];

/// DULCI_ActiveFlag 使用状态
Property DULCIActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DULCI_ActiveFlag ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="DULCI_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DULCI_LimitQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DULCI_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DULCI_TypeValue">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DULCI_UseQty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^CF.PHA.IN.DrugUseLimit</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAIN_DrugUseLimit.DUL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHAIN_DrugULComb.DULI_CHILDSUB</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>DULCI_CHILDSUB</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHAIN_DrugUseLimit.DUL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DULI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAIN_DrugULComb.DULI_CHILDSUB}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"CI"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DULCI_CHILDSUB}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PHAINDrugULCItm</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
